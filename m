Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B155D2FED1
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 00:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCFD6B0005; Tue, 27 Jan 2026 19:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AA86B0089; Tue, 27 Jan 2026 19:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7EF6B008A; Tue, 27 Jan 2026 19:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3C3A6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:29:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CC178B7ED
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:29:09 +0000 (UTC)
X-FDA: 84379488018.18.FD7A2FF
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90422140003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:29:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2XxIxhKH;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769560147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afdfdT2YOMsD0iZJQSrtAQ+axiAIWjxn1C3TT/YCmDM=;
	b=3RZo+AYxS52luaMsK3FFXwHQaPiATG7+JAV2RkYL7oH1EPf+JO9wbLBS3DQvPAHT2DtQjt
	ljHSFuypCXcMqA18IRkee6x9dWvTHlfGxAM68YUSLRWiEDWbH0FQdiXd24DDKSNgA62sJN
	XyMzUvyHEBRfmzhYekmYbqRek6hWZ0c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2XxIxhKH;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769560147; a=rsa-sha256;
	cv=pass;
	b=SSj7/zo3fF7SLk+r2rshNgNMzfkgHgYHzulmx7fV80gKUg/3vrEykpa0VKvmw/7cNhYwyf
	mf9Yk6SGq0MWBXXK/dMYMf0BFkk4I86N7Y/TXo+dyfbfo5dWJIvjo/ZhS1/wmLJqrDrQrk
	50GSHBgLw4L3KWrkj8dynO1kmTckOz0=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5f53021703aso2151863137.3
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:29:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769560146; cv=none;
        d=google.com; s=arc-20240605;
        b=eVsB6KNW+x+Lmi4HRWu/vA9reedkarDb7UTrdcuSpYL5o9gVWb3ZB34xYwD/BXMoJ2
         Qfczw3HHiYX99NOp7Jrg8ARLakS+oQ+WfTRjM+UcAW3gfTBcaRglXbU940Gn6cjEkZrj
         mft2gGzCrygI5L/4auDJ1FBbrhe7XvUZL8E/H2QqTu5U3LKrp8djmUftXiCAyayaIkwV
         zY2xYe7CCYy10VkgYgUCrEjuqSzF7H5uX2zRHL/ZJrj5F74bLnwVIgNf5Y6jhC9eCSMW
         8LZCuUQEvytHFSNDfu6ToF6wfzMT++C1dIHTeASrTKidKonKuZipcGVFI08YhC5lcRan
         s63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=afdfdT2YOMsD0iZJQSrtAQ+axiAIWjxn1C3TT/YCmDM=;
        fh=K5DAYv9x12g7fuZwfE8xTRldWbw45HZNpBOLBG5ar+A=;
        b=cAkmwcoSE7redXz0Chhbc110DddoJGfHgnNDIC7VF1NgL0Ms6TT0dFApUSK6vSLKLO
         zr1r5yO3BAv9Wweob1OYZKwPDnClnTD+0429sTlX/xeefAd5TP5X9WESrgHBuc6g1wCq
         yDSVpSnMYb9gqVq+tMbIJXOI/stbTF/8AQeAI02l7D+hPwgsEOyk6Cgwm476/1triIAG
         ZfBL8Sc6U+7VkUWeW0qp0s5Lx5p2xBfqHBwWu7iJcsFpCXROzEeNTKagcgemKhfoNnpx
         4yrYfYypIgjohsfLGu8kwOmzGRlhnzz+TPxkm9gdCw0MwcAqDUJcj1ue0EpPEIO8ui7R
         1qoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769560146; x=1770164946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afdfdT2YOMsD0iZJQSrtAQ+axiAIWjxn1C3TT/YCmDM=;
        b=2XxIxhKHnApwIlM582rzYEQeJRE4gOfJfonIlHcTe2cFj0NGPzrF4y6jJ/CS1pjZDS
         f4aDhDDTmsfK15hnJqMBwpveDCKYnr1rHS1egGmN2w7HJRGZ7P5N+FuGSzHDxZGJvUml
         UGkAWRc6LUve1SxoDuNvvi1Bj27nVLI63vVDXGGrr2NVSAI7qGBdvvD/PudoPvgDpjds
         KazRZboV5zy6CXwgkwDwbbmsLNALl14zVS3am98RWOgKTmh1eLS0mNZl5+7A+7XOxDUT
         hy57D0awmGnR94Z9ROvOc0x42IvMXVRuQJYIl67ppRPPds8Op8luxpr00yFzRcno/86r
         O6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769560146; x=1770164946;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=afdfdT2YOMsD0iZJQSrtAQ+axiAIWjxn1C3TT/YCmDM=;
        b=fkYJUB/lOVLexKxSAihEWAF/DzmI1o8A0zxNL/fvFAcsnQl/lQ59ianGfDYxxcW7wk
         0TU1hTY9voZcG44W5EQWaq4XXamSSpl2kRu2x1oJ/g/OKBmcg8pq5cSA6iifzVRAEFzB
         rhNiplgrFZeWzvoqcLwH8TFnZUMP5Dc6PYkwtlrTjjBVmXW3r7IIWOsXjF7LFME/5dRO
         lDiR92WM6de+oGv0NkQc+WbhYbqHTt0g51iM9kLklbqoejryDtg3pO8n71uJAXjfVQD8
         thmm4VkpaVbcV07s7hj1CvRKXDEtTvSC0bO7mf49BVNjEM+XuGw0tZ1ookSQE0vRHv++
         C63A==
X-Forwarded-Encrypted: i=1; AJvYcCVBDQViFoXOhY5Sp4YCr5D25Yg7X/wIx3xgD6bWKtwOWGJv5EWsQLsf7YK3yKXxfqSsiQp1pTu7tw==@kvack.org
X-Gm-Message-State: AOJu0YxEaWAbzzIb08hfj6SpcZFm0aPHHf41NoCmqjNN94QFlvtj+jBv
	I1ZsOyphSgN2roIboR8hm7Gj9f/GzBT/ZTyNQEj0MvmpZrfRl/dUwWqknOwMDnJAgMPvHN3fXVG
	8RQUlVSkqiGTOktDYjVE3gb+j1yLzd4kri0qehXPv
X-Gm-Gg: AZuq6aJKb1TL8MIQ6StqvZi8aK07dx53B7N2xG3PUWhoMuCpOF2BKQPnGYtTB1bUHj6
	A0JcHU+LcLMMe+xaSVR2CUinwklhg7T38kmRpdjllN1U0gmrT/yZEOBD1YBHvs1uax95z0JqYWT
	a7NR+mCkXvztlhD5HixhMoSfQvBcXHnI9CZvFKCeiKt4jiHiGHVUhZiMW4QTUH92XB/Uxk9IW9X
	+ch3MVRzjh1NnpzjkAdUSsk2BUM8AVcPnPaIBMJDTegExpOgfMM3At1joxX47yOihNoqEYNE4im
	+946IxVJw6mtzdwH53WTAXS8yiDoePE58Wtu
X-Received: by 2002:a05:6102:94f:b0:5db:cba0:941 with SMTP id
 ada2fe7eead31-5f72380ed5bmr1335024137.38.1769560145803; Tue, 27 Jan 2026
 16:29:05 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:29:05 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:29:04 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <f4f2a0297e38ac45e4438342ac2c882b91544acb.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com>
 <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
 <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com>
 <ee9c649eed3893d852c3d20fb96bdc4904b7c295.camel@intel.com>
 <CAEvNRgEz0+ic9uvcsWYqWgR5EV=TfY0SAGC39zAL+n19SoBXmw@mail.gmail.com> <f4f2a0297e38ac45e4438342ac2c882b91544acb.camel@intel.com>
MIME-Version: 1.0
Date: Tue, 27 Jan 2026 16:29:04 -0800
X-Gm-Features: AZwV_Qi5-DP-v6wjOnL-aDMsdDCx4XY7-YGdXQ0tP6_jJk0lLjibrIAwkazF3pk
Message-ID: <CAEvNRgHMOWfCRnkx7YJoAzNpBBOHCgvR5GHe66uHJX45WDT-YA@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "ast@kernel.org" <ast@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "alex@ghiti.fr" <alex@ghiti.fr>, "pjw@kernel.org" <pjw@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "luto@kernel.org" <luto@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"oupton@kernel.org" <oupton@kernel.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90422140003
X-Stat-Signature: wo3zfpnk6rd6hsg6q1n3eren447pig9j
X-Rspam-User: 
X-HE-Tag: 1769560147-461162
X-HE-Meta: U2FsdGVkX1+YxH/aQgXzFF35Otp6Qg5MtxKY8xjkhs/N46beFqqDrNNz3pP2ozaXVIklxjC2+rXe2hDOPvjuYZ1W2IOwMF78FKNXDi5elYTxVLHYz60XvVoNVKn0ky3t6iqs2EOX7asB7u5JPe6514A0+W9SQAa4SPFy/eZ1As5L6rrWFlANmRjbU//bu0LsJRTaPNHUbqA0gmi41IQ6LybpVDDsES695i4x5Bo1/OXSTmaSavmxDvSkKhJpyNwQyK3/nIaOUTYG34MOAIvyOui+W0DjKRKS1/P4HSl1lIDKFIqd8hNFvrD/EMrtIqXVPYUZjUO7DoBmtPeeOtsLTFK1vW5khWi+Mbe15VcA6a99MQ6p0rNVVIsQMZoXm4LcNmrfavRjbqzbdGb+FNkRf3RQlHXqhhoz9XpYdKfSUY4BHahtAaR7JBRyK1T4aiZQvyGUn+8KvM0TozU7t+TVE58QELIpnxBpFO6wY28Tp2/fGqFT0AcCl/mnGUUYKFnRx48kc80vvrMx1QCwfd6Z7yTVS59WvSj0Vph9R2OqpUDkMPmKGCbf2cyptZrtWXIjxxtQT7+utLSTlyWCeuwqYn7m+hKZszmzRhVHSGzUUV4mtwxdrlwgYV1WlNDKXizInN5KVx5gyJP+p2LfcSHSXOU1AoXXR8DYRppFafWEonPhnuX6rBNmrA+XQMTZI482+1Z28ewAW3vdqKdGefw8AZhc3NbTkC/mBYEDCv3wHHIeZLKfGHolAWIMYNP9YZhOQ4Zt3nGn8HJa9JlgUpIILrpgAMXCXIWHXxXr+B+yY3cenQrzA4CKdMP/KGbRtXeCiwbMityf3Tb4dEUr3n5tEPBDQurEYlX2OdE7o3rFuL5KLkQin3CQ8tGtOO02GcVS0DsRD4ZGxw0Oob0sWCZ1f31R0ha1Tz+OgJcPLJVqPnrmTmnXoKKbePbKpnct0Q0pxXpJ6b8xp/NoXRSoo1p
 ZiWUXHPj
 ed1zkKp57PXgMOpwJap/Zie610/EXmPaVGB9pnzGUF9REcvBq4MCGuibSA0wPZgKAq8+TwG2cG2h14CxoerBPJCyTreG3IHaj/4Eb+ce7055455uVz/IrtF7TaKFeXaoMYJieLB98oSjlgn7GYk4Wh6Xt16QfyjSM2CC3OKiydoPi+EBJrgGAxaiAcZ5+00AbJp3Y6q+IqBd40KWK8pr/HmuM+PurntdxEU62AKJ13XO1PRD6lChX9+j2vT+wCZuAnZz5w9/TgxF/40Yt/bxZXIAhNq+saZHprEp6/fb7GBrIMzXZD4VfeoGtO+Z/mpMjqdcXhRoWvRKTY4kQKSVaoOH12B9+ltJ+KeK+BqCAK+Q28zrYCBdH9yOb+L+sjfG/b62D9BX9p9jzg9t+CY73Z+ZzgK/7CPmtz+VtYLRTygg9i+fRtpnazKmCd5ThEyVf6E0+7wscDsjw1dUiyp9YnpLytr805/GAy8wD7PUumSufdikq+gfrA5uZJX7rYsADttd7U8C9lcxtAGyt/lNmVLszUkGJotCurnEXxAgCWzvntBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Thu, 2026-01-22 at 14:47 -0800, Ackerley Tng wrote:
>>
>> There's no use case I can think of for unmapping TDX private memory
>> from the host direct map, but Sean's suggestion
>> https://lore.kernel.org/all/aWpcDrGVLrZOqdcg@google.com/=C2=A0won't even
>> let shared guest_memfd memory be unmapped from the direct map for TDX
>> VMs.
>
> Ah!
>
>>
>> Actually, does TDX's clflush that assumes presence in the direct map
>> apply only for private pages, or all pages?
>>
>> If TDX's clflush only happens for private pages, then we could
>> restore private pages to the direct map, and then we'd be safe even
>> for TDX?
>
> Yes, just private pages need the special treatment. But it will be much
> simpler to start with just blocking the option for TDX. A shared pages
> only mode could come later.
>
> In general I think we should try to break things up like this when we
> can. Kernel code is not set in stone, only ABI. I think it will lead to
> overall faster upstreaming, because the series' can be simpler.

I agree on splitting the feature up :), agree that simpler series are
better.

Perhaps just for my understanding,

+ shared pages =3D> not in direct map =3D> no TDX clflush
+ private pages =3D> always in direct map =3D> TDX performs clflush

(I could put pages back into the direct map while doing shared to
private conversions).

Is everything good then? Or does TDX code not apply the special
treatment, as in clflush only for private pages, as of now?

