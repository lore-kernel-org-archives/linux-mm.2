Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC263CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1269B8E001F; Wed, 15 Oct 2025 05:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFE98E0002; Wed, 15 Oct 2025 05:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014428E001F; Wed, 15 Oct 2025 05:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E45318E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:13:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB64611B335
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:13:49 +0000 (UTC)
X-FDA: 83999786178.23.97AF73C
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id DDFD9C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:13:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atBiBL8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760519627; a=rsa-sha256;
	cv=none;
	b=tEIKKtzKq1Xjrnz5zxo7UAED2a7AtTUlE5N7mmacWopPlm7up9iYcAGBVCqXs0198szXpz
	E+Ph/wploImjMuGYbc6X3x65i+qzBzsfE+dWAVnrwLG5WPaWxVID2VjMf0rnaf6cC+Pnjn
	dtMzBEZ2gOcqEKAKV4bHjrmZgsbrw5U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=atBiBL8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnzgMxSKOO72tfiR2hh9MnK1R64fNXjscr8+Cn1K0dU=;
	b=bPEPChOD+bTbVNiGcPBRLKafiwAegfFsgawbDy3VC2NOVDQujQ7q6f8AXNztrXNfk3SBkG
	CmqtWKX3bcD7mEOlyzD/FSE+qQo3nh82gpNZ0id+ul5HQHCzP3bK/LGpBN7ZwFnV/1+M7E
	Zczb8tOR/AwrrV7lCEtmukweAyk372A=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-78af743c232so5771024b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760519627; x=1761124427; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FnzgMxSKOO72tfiR2hh9MnK1R64fNXjscr8+Cn1K0dU=;
        b=atBiBL8gq8aVpDbtcZkg7/KHdXqkZdXOTgckBlPJ07CI0yM46Q6+vqR9HnbML1Unul
         YjpMef+s96sIgekutXKr9XB5ave/8IAHkE6U5Ngpfya6ql9pD1qdyZ9ZWN7d9fg9Yp8L
         1nq9dm5QbHroFHgLLU9ya9j3DK8lqUmL3T1qNGyAou7MPXru0OkBQzbd31Q8i0t00Rx7
         5UNSVGKGBn8NWTJNkfGT7xzGnu+0IfNfnjFKindTdu8fLYR4kwyuGRXMu3klZae99Mvg
         7/yO5Ut7nXhOijnR8ocUkUUxtFJY+D4HF/iRn+OQOm9ddVTvYgFFAN0c+SGxPXvE0dTV
         unvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760519627; x=1761124427;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnzgMxSKOO72tfiR2hh9MnK1R64fNXjscr8+Cn1K0dU=;
        b=PDueN5jQ8xuYBN3sqcU/2d73G9MjncyNT9y6lI4kgMxQXYQPjEYDWJZ4kEzhFTEdYt
         gGVEEszwjcTrkGnxC0EMjv+nc8Bf2jYzHl25bGoV9N1p0mn2oTNkyj6sLmUZ52QJXlnT
         mDKwfCS7/rrF9HFT+mK0ZcIqlqodsUq24pPdXOUP3pjPyqQJBUI39SISyP7brVxX5HIN
         bC4n99hB8cSHmrgE9sosNVyJFHC744v+1OcrO1lNQSsBypVWIQOrfagumprDExBwD5wz
         Z/exVofOP61opdlXxKRz8NXX1R8OPru4Y63B30j4O8DwLT9yoMVk22ci1Bc1gb2a+w9n
         58ig==
X-Forwarded-Encrypted: i=1; AJvYcCX0X5bhR8Iv1vkPSK/PTGsJsXywYyJ3qGUBO8OQCdYvJGvaJTV8AZq5bcGP/Ft/Y41xyTdRyN1T/Q==@kvack.org
X-Gm-Message-State: AOJu0Yxi/7+qNFrIho2LYMxjUC45WJa4CAoxQEk4rL4oLsmd4NChqu68
	zoRMBGxr8j1IGfkMpkfF4qNdgv1TRZCBKVVLT2kCqIgnIwsnzBvZL0j+
X-Gm-Gg: ASbGncvsI+P+ph2eVX6TGtrDSVUuTau4dDDgnJa3/i1kvXT07ShYwe+v23WeXN8Dv8N
	sGF06X+pjgHPrRaZVNmWKO2kGI9bTQH7N6D2ZkXcUyqQnlzQnGr8KXpGl1IpDUZ2ap3Bwe7OQjg
	dLqtXV1mOO537mLlPXL0Aj8PbwOKWfrCj7zu1ssga4rPQVmIHuCRdLphCR116VN4Es1rRZHzsi1
	1QFIcTK31tsopazWUzIRmmLT/w05XXh/h9DSRKko6nTseHWTW8pQlLhcjx9fQdt6Z9sFjSHk8NG
	B4j40+LRkyVUUQyu5r7lDyw+WDdHgvGQ07Wpv9zME9/zZGxQz9zwcwTEpGyBQGQPVErMKUISumF
	SU9yyVCJY+tE5neUdq0G/yFFRNeZBxmLnEQ6doF+JK+nSxOG12DCij9nhE/HLMnYZcileGq1Mun
	kDNd4vHE3tFxY=
X-Google-Smtp-Source: AGHT+IFS7b19eKD7+v/0MaXIMF6xHjpZvmgzcXFa5IRI9zXbzPuF57TjkjjGD6DeOJEUU4KNbw+Wcg==
X-Received: by 2002:a17:90b:33ce:b0:32e:ca03:3ba with SMTP id 98e67ed59e1d1-33b513b233cmr35842781a91.22.1760519626485;
        Wed, 15 Oct 2025 02:13:46 -0700 (PDT)
Received: from smtpclient.apple (vmi2771466.contaboserver.net. [46.250.226.198])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678ddfeb7fsm14605348a12.19.2025.10.15.02.13.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Oct 2025 02:13:46 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <EE05E2EE-CF52-4B88-8B7E-4C5EEB460617@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_8D79A411-92B4-4AD9-A37D-B91414B775F5"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] mm/khugepaged: fix comment for default scan sleep
 duration
Date: Wed, 15 Oct 2025 17:13:27 +0800
In-Reply-To: <a72ebcaa-2cea-47c1-bd57-f88c8eb417f6@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Rik van Riel <riel@redhat.com>,
 Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
To: David Hildenbrand <david@redhat.com>
References: <20251015064333.31274-1-lianux.mm@gmail.com>
 <a72ebcaa-2cea-47c1-bd57-f88c8eb417f6@redhat.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Stat-Signature: jinck97iiizmki9b65x7hyzssoyp9djz
X-Rspamd-Queue-Id: DDFD9C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760519627-133894
X-HE-Meta: U2FsdGVkX1+9kHdiXPcGFO2QkxQZTXD7bvRZC1syL6qaCDonG+KlIw7gd28f0SvcPJozdm1tXOe5MlgQs4/fKwl6z6treWY3WAxucKSDkip2eWPrAYM0C5lvXe9dkc94HQ8PAzOl7s33Le0SJ2RcZ/qVkk+kXaA/iLHiF85FI7Lm9GCa35T86UIUDKIKhG3up5roTr7eidzC/UBYe3pNpWph6q5SHjnI6lBgzPhew3ghUcAkILDyuLhQ7tDUYDUgUCfZapYw3cRUhrr1bnlTOaHsE7bH6RVfuwRhw6oYnA6VhFdpgg2EBki0OMnbHxJGPY2QSHkta12zxaUbFfSgIWmGkS5nPOAb7sU4u3d0/m4TR1etwcgUu97SNDBr6EYqoXyJpjMdcxdkgwDm+hsty1Dj0xrFwrbPs8vVuurx/+EU8VdeBnmsVAVZaHFVwo0PEUkeqKHOqsyXmulbVtcVQMd0sME+yYXuiY5sT9sldVsEDNoUucf/RVSgPRXzTVYs62LIKYPiDfYbLs87TMvKmFZup7ZYyH7nrriGKgd8S30c/c5BU54pNqdgnZ+RF5Vcfzo4uJdCh3wdME0vx1Pe+UbU1neQfz1dpolr6HWailbvdOyneGFxz3C1zkkfO27po1Vfcyfji23mTfbtOeEtMQWOeMg0iI5xoLR4fCR2R0x9pw/mqc8t/e+JHH0wB0yW8to3rpjiGxSl0KtJv46tb82Uz72sA1fLgMM16AoGWWHRTwSMU9Z6ZcdGanFYerqd1I6Dj1HrUdrGJdZzA0KN9RGsXePj35arSQh8/Oc+aPL3BkM6un9UL47uLQekXwQVsEdvcRz9vBz0tM5tdRxIfLgWrhPdLYXQ0FEbVwhX4YKt1rwScyraXepp3KA3W5+8xGEaMwcqLDa79NtTnmuZV7/DCR0HgQbpEtRuFnf1RAKzMR7YMErJvOFvlh/ekpDzvZFCUxJYGsaJ7S9EiXe
 LXn0ztcd
 GcM6lMfK5rJb99zQS1rdbztnRKbAz08XyP0akUHdI/noHfOZ+RyGIqmBCcBLzP1QrVJy3Pa6CKNNGkb0mNat8Be3BxWX2e62hC00upS+YFRXLl1IYsYNMI3YvC/huB3m3O4DUGpOoT58f8/OwXGHLvutQ4HBqCltzgqG6SvpxtWBJtfiD0Ko89ULhIbbkE1G86/twhliBufz3KM+xHzrT+a1oLemDpoW5w9tPes68jRXCZfp9F3Ji8zXVKy3evrOLt096RDoiwUcrGErduBZMnItsBg2kEW9mfi/O9Gg1HXqzfVSHROpr1sc5WOkQBj4hmgbF+yKdsqeWhvIiIz3DVAwjT8OgmF1IijpEUQ7hDLnHH88CR/u4CgPqb4941EFg/aOk6IUTE7XwwO/lFTCZLNVnEszAJg7GFYlGfWh7pY0pZ//Kmn9seDQXTLlEmGGkTR1vrCfhadgVmyszo3pTbMjTeks2pftDHkNaID8gvTp/PQfGGYhmzvPuW22jsrCs3PBbY8PQHT7Q+vki8NlsN51dzczOmwYZcDOqR0prVNkg5/E7hG6hqruDMqF29iWxDUpE4nj23q846Xa3emKs36k91JEnfsYSRzxGnnMNPccryP6dLHAZvHYH/19DM7ymNStm5hRHPFv4GWWpyPX1xY38PA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_8D79A411-92B4-4AD9-A37D-B91414B775F5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi David,
Thanks for the great suggestions!=20
That indeed makes the comment much better.
I will send out a v2 shortly.

> On Oct 15, 2025, at 17:08, David Hildenbrand <david@redhat.com> wrote:
>=20
> We should improve the 512 part while at it (e.g., on arm64 with 64k =
page size it's 2048, on s390x it's 256).
>=20
> And s/pte/ptes/.
>=20
> /* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */

Best Regards,
Wang Lian=

--Apple-Mail=_8D79A411-92B4-4AD9-A37D-B91414B775F5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><div>Hi David,</div><div>Thanks for the =
great suggestions!&nbsp;</div><div>That indeed makes the comment much =
better.</div><div>I will send out a v2 =
shortly.</div><div><br><blockquote type=3D"cite"><div>On Oct 15, 2025, =
at 17:08, David Hildenbrand &lt;david@redhat.com&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">We =
should improve the 512 part while at it (e.g., on arm64 with 64k page =
size it's 2048, on s390x it's 256).</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">And =
s/pte/ptes/.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;">/* default scan =
8*HPAGE_PMD_NR ptes (or vmas) every 10 second =
*/</span></div></blockquote></div><br><div><div>Best =
Regards,</div><div>Wang Lian</div></div></body></html>=

--Apple-Mail=_8D79A411-92B4-4AD9-A37D-B91414B775F5--

