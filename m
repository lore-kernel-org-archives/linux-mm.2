Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC49ECA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F0D8E002F; Tue, 19 Aug 2025 14:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606388E0003; Tue, 19 Aug 2025 14:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CAD8E002F; Tue, 19 Aug 2025 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4E38E0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:22:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAB8BC0162
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:22:25 +0000 (UTC)
X-FDA: 83794327050.25.855818F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id AFE37C0010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:22:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NkouTBGa;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755627743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knVAXuJ8IevkSJ9uHc+S3tsU9P+kAKytQPJOP7VtkWY=;
	b=FmFycVZ1sRiMjItQU0MxeX/iB0GhxeUaJqVQFZBt3+bsnj6g6VXikscU0Kwi2aT2ohLt/F
	4fNhDaumuw5rhUZ6+BrVJondqGigV0KaaJO924wKSJocA+F89IaOGI9HnlUty+AlOO1qdl
	9q+Xriggpw7p5Fe12fuStAMp/AmIjJc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NkouTBGa;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755627743; a=rsa-sha256;
	cv=none;
	b=Y6mpEFyl2ouSUOwGO1sqBajd18C3NzTGaGSQuUCaQslZUPD2bBKp19J4GtMZUuPQNxbK/c
	3BpSkSTUhqQwr+3weGyvZdV3nJJP0r9PGHo/5NQZ5/rNUSWtc7Mmf/aFX+V+/s3Fq3YhNt
	HEsJS3DHiP38g7S2kSqf0lOfaXRx88o=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2445827be70so62663335ad.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755627742; x=1756232542; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=knVAXuJ8IevkSJ9uHc+S3tsU9P+kAKytQPJOP7VtkWY=;
        b=NkouTBGaXXftHhE/ntRb4u93Ad108b8EuCiDZ0V8ajsbI54+kKLhyDNRQDdgunGp6l
         rX7UHFjV0Ice+B03k1yMNSRJlc165qcW8zGJh49+y93uBsZq0CIOkP+G/tZuWP99N409
         cNgYqY8+yFlnIuZEpG5J60MrJhVDilc1EXfcjCzvsgtH9ojwahD7MvxoKDR6jeiBVhWQ
         dV6nzCMCR/DN7IaIlZ5/wt2IhHOu4j0gP28ba/FU82gCwHG9x7yulJGAPI8meMtCz95y
         184yHZqiIQJbNT8uQIg7mtUDRl+kCe2JLo0zjOII4AFwvj3At4f0Qd0qDPfat4fxMfH2
         tvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755627742; x=1756232542;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=knVAXuJ8IevkSJ9uHc+S3tsU9P+kAKytQPJOP7VtkWY=;
        b=h0ftOkj+XxtNUdKT/1SaZz3HGopxy6mV92lHq6O4/xk7tJoZXsJei4XX48ply5yYfQ
         fg+kTaGgNmUoRhYCj2BaxteAas06m2jboUjilnNpcgsHfSRFYzAw8vcAUF9ykE9jIV6J
         5R6Ir4Q2iGhN9zQ8ipe+o73BXXqdbFXq/+HkQV0mPG13UQIDChFMyFqfv5FxEc7dmsIi
         MWaZpcIjjDdRMvMalK499vGbnNCeEUh1/REtFk8hNY6tA7zvPU/hol5tR+nfLMSjBQhC
         rhKD/u/5cK1AGfF7mvF/+zZeoxc1c3M3oQnbics7KBbMQxTIEx0QNbDDO9QeYCI7h98K
         e1eA==
X-Forwarded-Encrypted: i=1; AJvYcCUTepMVBE5SJyPuJdD5XyEiw2bs3rrQnkM0PAv7LTf617wuuJqpPjP8aGxaRkk7ad1x9hu7PqClCQ==@kvack.org
X-Gm-Message-State: AOJu0YwGkPt+QFJtsdOPbacoJbpVAu0pRaoapqGgrAM7xS18OsfYioaL
	SBKBG5iFUbB169cHrf4+w6agioiPd4PviwZ755qsFIIDVruVBLgzgdI9
X-Gm-Gg: ASbGncvWWp6vhXRANKUmk1QpjgFBHyPx8HrHmwY7i4Zf28EIfUf8LuX/He0qQN9jn2f
	379vYPawCrM2VKAE3sgKPjNh8HmpS+4nG8O0fD1HyaNv1em3lRtM75xHV9Zyqp74AE6zZVJ2yVH
	9VBfLUY6NtG1q6yGGT+6Dpbe+BZmFRnCboriTFdG+mQVvfGt4sNTCVWmk29WEUsVUKTN1uTPLin
	Mr2I6zAwvSSqzvaGr06pohcSTRgkTafhfrvFErcKmZ+vRw84651rOUWOFzaSVTLPitfq3Yv4Q5o
	wZO+5gPL/o8VUrrNz291L9FRpERjWkVKIM0TX+Hr30sAGRnuX+YL6zlsueYRy4RgmBo8EJ6ihv7
	zVXuJP3Z3OdgiyGR1jcPvFNAvi7oxarrdMsnxb/c=
X-Google-Smtp-Source: AGHT+IEQJD72c+pqed3GNT6fHpX0xryUy7gh9SzHpStCBB5KNkZotIMAkC5ThYsvSWDTNdmL5IzWXw==
X-Received: by 2002:a17:903:903:b0:235:ec11:f0ee with SMTP id d9443c01a7336-245e02c8a3dmr40052725ad.14.1755627742423;
        Tue, 19 Aug 2025 11:22:22 -0700 (PDT)
Received: from smtpclient.apple ([124.79.171.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed377843sm3770695ad.57.2025.08.19.11.22.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Aug 2025 11:22:21 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
Message-Id: <FFD095F0-C84E-4F9B-88BB-D4F7BC7FC3EC@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_D5CB0B22-3F31-424C-ADDC-BB0AB37825F2"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [RFC PATCH 0/7] add mTHP support for wp
Date: Wed, 20 Aug 2025 02:21:54 +0800
In-Reply-To: <cca76935cc9f480d969340c914a44f3b@huawei.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "glider@google.com" <glider@google.com>,
 "elver@google.com" <elver@google.com>,
 "dvyukov@google.com" <dvyukov@google.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org
To: zhangqilong <zhangqilong3@huawei.com>
References: <cca76935cc9f480d969340c914a44f3b@huawei.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Stat-Signature: diou3cmypj3c5oo7xd11dzhto6izecfw
X-Rspam-User: 
X-Rspamd-Queue-Id: AFE37C0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1755627743-329608
X-HE-Meta: U2FsdGVkX18f79+Uvu3nR3QEt6Nny97L3ChuZfzu3GgjAWAa0PJMkBGnW3eslqUsah+Sm7PyiaKL6bes2hVs/mKsstO9QpRTopzNieY09y7vNswoCgQClaA56ZXLJ5Z0cWXjrBPOEIpOVOuiAjZqvCdCiWniGPTINbKOyObhS8Jm+sWbDguyqgEigKh1VJ+sg+Od44JtApqCqViwmCHFSQamO/yoOgkq/ge7HrXJYGOHTgXElJlp9Ui3b9RdsE4x3DKq+aOHPrqAScHIcAJtFrLFluT9919V3G+bRhXZzLbpoJE2CJy5sRBYf1FvacZOU6PHZhcCcWwCkrqglg+D/l7idBfoXLVEehGJBd+yxVl8OxjV9tqcFO9tK7gsom6Og/AWG/ZD9mwB8RWu5TzuKH3Pk1y7w8pUJJa7FnyCcAXiZeCcxtV+uXJJG119n7mkPL4ImccNGzxPFKIL+mcMkBujChs5VG+CvH7cPM7+YgVh4sDWtd6Ul98dTrn5OYOHCHstRA5OkEoKMSG9vfndQpqEdjiVYhUHuMVsC5JKbEBs1fh1h8T8NjUX0V5pLqFUsB5XnmRBkjqVKjifVzXn3WfXfDwoUq7Mh7/xhmoYNxiSILmKtEjh2RCdrYqDzaJUrJ3s5xseYSqOAEzUTQUUSnraF0jKd3OkPLLXc5EKQ92/UkPs+bQY8Afpoi0EhOoMAdWndfQZ3HzQ7yo3S1HCOJBDfuOO/YsdXyEgaseWiBQZPGt5nnSiQxmXKkdj+9wJWoI9pUiYz7shKkPqp6ejlemNl7XuB9Ir2t4FXAxI2+E2wc76veWCQdRgpYDa0pkHufd6H4VoqjaQWYhgeNDkU3G/KUALnibvgDDb5t5oWnQp9lCWAjukraZdsS+KSR4mCmiaU5HxmELGzgqu/fnUWL09I60DONvDGkykIKEoJ2yQnyYjMZp7I0KgK55NmYOpLjGRQRahm003MthN+K6
 ygtWpVvc
 1eU2WQqvbovVtmch9/tqj+U2hGsemEbF2EThRqoPXGhwIvlrrAPT3gYZ5lb0zPChrs5LrP94lfc3KNI/1PSuVZb7Ff9kDcfqBpnfwDyJSetIUSFCrzankmeE7RScEYOwuMgjO71VS758Wit1gll2HeZKjAD1v/CYSci0OGy5LFKtUiYwR8tGMZG1cT67LZla+ZuAY1wH+EbwZw0seAs1NUle++gkCLTnM4nW2cyNEt1RQSW0h1rhzuWygkFSzvUv1gMxSLuLvvSUk0ubRZSDlRomBNrCnR8G3qWFxbUzfyX/PMiuxH0sfUWCyb4cm/BO5heAfDkcBAc5DZNKSzRck9UMZLR2Wcc6r/PcOWGTOETkTWyWoVpw6KFymI7Tcbf6AClaiRMXcdyES2LRPWGFzf5LDn3i9ZkHgLfPX/6ZTzNIGfofAlC203U6fFgY4tycHKPirCcmUz3tOIWd7zKGQs2zAsxjnW20ap9es/5NNLiDdiYVEvZLw7L/nnFxWlZPHCi1tuHwgYGxH+cAfwyovuITszlySqQBhBTEm23Bxfqee0qHj3c/aggCAaizBQSZdvzJRQvudvgIBduGOAmkFPiCplQhRfIo7M1f8GtsgBHv+C5O3bA0rDebgWsE0Ydxef9b9VFzNQRk9DZGDEoNs6nZZmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_D5CB0B22-3F31-424C-ADDC-BB0AB37825F2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Aug 19, 2025, at 08:55, zhangqilong <zhangqilong3@huawei.com> =
wrote:
>=20
>>=20
>> Hi all,
>>=20
>> This patchset is introduced to make pagefault write-protect copy =
support
>> mthp, with this series, pagefault write-protect copy will have a =
9-14%
>> performance improvement.
>>=20
>> Currently pagefaults on anonymous pages support mthp [1], and =
hardware
>> features (such as arm64 contpte) can be used to store multiple ptes =
in one
>> TLB entry, reducing the probability of TLB misses. However, when the
>> process is forked and the cow is triggered again, the above =
optimization
>> effect is lost, and only 4KB is requested once at a time.
>>=20
>> Therefore, make pagefault write-protect copy support mthp to maintain =
the
>> optimization effect of TLB and improve the efficiency of cow =
pagefault.
>>=20
>> vm-scalability usemem shows a great improvement, test using: usemem =
-n
>> 32 --prealloc --prefault 249062617 (result unit is KB/s, bigger is =
better)
>>=20
>> |    size     | w/o patch | w/ patch  |  delta  |
>> |-------------|-----------|-----------|---------|
>> | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
>> | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
>> | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
>> | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
>>=20
>> This series is based on Linux v6.16 (038d61fd6422).
>>=20
>> Thanks,
>> Vernon
>>=20
>> [1] https://lore.kernel.org/all/20231207161211.2374093-1-
>> ryan.roberts@arm.com/
>>=20
>> Vernon Yang (7):
>> mm: memory: replace single-operation with multi-operation in wp
>> mm: memory: add ptep_clear_flush_range function
>> mm: memory: add kmsan_copy_pages_meta function
>> mm: memory: add offset to start copy for copy_user_gigantic_page
>> mm: memory: improve wp_page_copy readability
>> mm: memory: add mTHP support for wp
>=20
> Oh, we are also doing similar optimizations, but only for the code =
segment. :)

Good! You use a similar optimizations in your code segment, which mthp =
size=20
do you use?=20

>=20
>> selftests: mm: support wp mTHP collapse testing
>>=20
>> include/linux/huge_mm.h                 |   3 +
>> include/linux/kmsan.h                   |  13 +-
>> include/linux/mm.h                      |   8 +
>> include/linux/pgtable.h                 |   3 +
>> mm/hugetlb.c                            |   6 +-
>> mm/kmsan/shadow.c                       |  26 +-
>> mm/memory.c                             | 309 =
++++++++++++++++++------
>> mm/pgtable-generic.c                    |  20 ++
>> tools/testing/selftests/mm/khugepaged.c |   5 +-
>> 9 files changed, 302 insertions(+), 91 deletions(-)
>>=20
>> --
>> 2.50.1

--Apple-Mail=_D5CB0B22-3F31-424C-ADDC-BB0AB37825F2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; =
charset=3Dus-ascii"></head><body style=3D"overflow-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;"><meta =
http-equiv=3D"content-type" content=3D"text/html; charset=3Dus-ascii"><div=
 style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"><div style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><meta charset=3D"UTF-8"><meta =
http-equiv=3D"content-type" content=3D"text/html; charset=3Dus-ascii"><div=
 style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Menlo-Regular; font-size: 11px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">On Aug 19, 2025, at 08:55, zhangqilong =
&lt;zhangqilong3@huawei.com&gt; wrote:<br><br><blockquote =
type=3D"cite"><br>Hi all,<br><br>This patchset is introduced to make =
pagefault write-protect copy support<br>mthp, with this series, =
pagefault write-protect copy will have a 9-14%<br>performance =
improvement.<br><br>Currently pagefaults on anonymous pages support mthp =
[1], and hardware<br>features (such as arm64 contpte) can be used to =
store multiple ptes in one<br>TLB entry, reducing the probability of TLB =
misses. However, when the<br>process is forked and the cow is triggered =
again, the above optimization<br>effect is lost, and only 4KB is =
requested once at a time.<br><br>Therefore, make pagefault write-protect =
copy support mthp to maintain the<br>optimization effect of TLB and =
improve the efficiency of cow pagefault.<br><br>vm-scalability usemem =
shows a great improvement, test using: usemem -n<br>32 --prealloc =
--prefault 249062617 (result unit is KB/s, bigger is better)<br><br>| =
&nbsp;&nbsp;&nbsp;size &nbsp;&nbsp;&nbsp;&nbsp;| w/o patch | w/ patch =
&nbsp;| &nbsp;delta =
&nbsp;|<br>|-------------|-----------|-----------|---------|<br>| =
baseline 4K | 723041.63 | 717643.21 | -0.75% &nbsp;|<br>| mthp 16K =
&nbsp;&nbsp;&nbsp;| 732871.14 | 799513.18 | +9.09% &nbsp;|<br>| mthp 32K =
&nbsp;&nbsp;&nbsp;| 746060.91 | 836261.83 | +12.09% |<br>| mthp 64K =
&nbsp;&nbsp;&nbsp;| 747333.18 | 855570.43 | +14.48% |<br><br>This series =
is based on Linux v6.16 =
(038d61fd6422).<br><br>Thanks,<br>Vernon<br><br>[1] =
https://lore.kernel.org/all/20231207161211.2374093-1-<br>ryan.roberts@arm.=
com/<br><br>Vernon Yang (7):<br>mm: memory: replace single-operation =
with multi-operation in wp<br>mm: memory: add ptep_clear_flush_range =
function<br>mm: memory: add kmsan_copy_pages_meta function<br>mm: =
memory: add offset to start copy for copy_user_gigantic_page<br>mm: =
memory: improve wp_page_copy readability<br>mm: memory: add mTHP support =
for wp<br></blockquote><br>Oh, we are also doing similar optimizations, =
but only for the code segment. :)<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; text-decoration: none; display: =
inline !important; float: none;">Good! You use a similar optimizations =
in your code segment, which mthp size<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; text-decoration: none; display: =
inline !important; float: none;">do you use?<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><br><blockquote type=3D"cite">selftests: mm: support wp mTHP =
collapse testing<br><br>include/linux/huge_mm.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;3 +<br>include/linux/kmsan.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;13 +-<br>include/linux/mm.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;8 =
+<br>include/linux/pgtable.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;3 +<br>mm/hugetlb.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;| &nbsp;&nbsp;6 +-<br>mm/kmsan/shadow.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;26 =
+-<br>mm/memory.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;| 309 =
++++++++++++++++++------<br>mm/pgtable-generic.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;20 =
++<br>tools/testing/selftests/mm/khugepaged.c | &nbsp;&nbsp;5 +-<br>9 =
files changed, 302 insertions(+), 91 =
deletions(-)<br><br>--<br>2.50.1</blockquote></blockquote></div></div></di=
v></div></div></div></div></div></body></html>=

--Apple-Mail=_D5CB0B22-3F31-424C-ADDC-BB0AB37825F2--

