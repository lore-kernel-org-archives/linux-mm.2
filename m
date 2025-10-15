Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409D5CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6051A8E0007; Wed, 15 Oct 2025 05:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCC88E0002; Wed, 15 Oct 2025 05:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2528E0007; Wed, 15 Oct 2025 05:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDE48E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:44:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D163988C0F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:44:53 +0000 (UTC)
X-FDA: 83999864466.29.D08494A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id E4BE01C000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:44:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ml9puZtV;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760521492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQ4Rdd63886DrlQK0CJhuoqjrN26kQ9D1DjcBf+snTA=;
	b=jZhzSzPP1DPu8Pgh1YRD/cRZLFRwOf/feOUN7/gOetTOFbyc9lZxhnEBoeLdMHslrfhiEO
	74QQdAbvNu475IqIvhK+370ZeaClrt8jZ+7VzpZ8BY8m+bOu1Ry4WUAFqhgENJ1b6pP529
	2ySCyGIZ9CYH6i2lXvogvZ9aBUoib/Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ml9puZtV;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760521492; a=rsa-sha256;
	cv=none;
	b=2jbX9Ut3hMHHu1hoWnp1m4UQ5aalHS3TQ3JZHvREvtPXThls9ULv1G8GfRezLrpfSjBroD
	BhAAb+OHxVprGTTJxJMNrF9DD90v7iO5BSAZu6owZkTKI5rzxL/lXO1Sl7vc00KNbCodUn
	HmhXwEwwb0bztrsa2peSLqcz65QpAg4=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77f67ba775aso8803402b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760521491; x=1761126291; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eQ4Rdd63886DrlQK0CJhuoqjrN26kQ9D1DjcBf+snTA=;
        b=Ml9puZtVmbLJAoz7Hg14/Mf/aN41aaZvHEPuM6Rk157et+RWfpSD10Gvv56iRi9Wy2
         n67Wm5f0KD4xxaSFhhFxjUZUaYk6eLiAn3LbalqCUsAfxNKkPdJQme1DPv9h6euKHWwz
         j9BfJCzzQppCfYvNkjC6OGfilokhF6QxZ6L0iV0+FY983zZhE9vxeMKhIqGoGKkdPQfL
         seprs/qaQiM4mGIvgQE6Y9lAL6wsSekpsoIVjs4yGKM/BtUJpyLPQyGHGxZeTNtHakX/
         Z3VtucKImL4Fe4djUbKqiPntKLtx0iJhRokvNJBAGlmt1eKHMCajlnRPHL069xVWU3Ic
         IQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760521491; x=1761126291;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eQ4Rdd63886DrlQK0CJhuoqjrN26kQ9D1DjcBf+snTA=;
        b=w6YIz/vEQ/sohzIQBCJ5+bkgLo7KlkpqNwtZ5h5kbWjbyJiv+ZZ3xajCopGZNswtHq
         2MSbtB0f2g/ksgIRvZxt/0yUcuTDVWGEwDHKk0ePIXDiaPpZ/f+RBcZfddmtIwm8aoVd
         4waPw6rt7o1o7D8fJG8LwQYv8Nwdtaor4Lf2AhxrVjyhpsnH6jipISLjJjrFyHffU1oH
         2cvHIdW+vxv6jhQGeZPc8s1Sws8go85ZA7ziAzLNOg+Dar8nqnV941Rm3zgEkPKKhzM3
         HXg9IP6RdI/YstqY+Br1sxHn2bjx1QjXYYF8+Xro8L34GUhWp/rDXPzO+xqge3rIiWxL
         FCog==
X-Forwarded-Encrypted: i=1; AJvYcCVYTb+xl2aZSM45XGw19NaNgErQ9lyaDWv4xO51a7jBPZGQe2RH25q3rlBtb57beCSlQcpgojDISw==@kvack.org
X-Gm-Message-State: AOJu0Yzhyc9K0oMwhp+rmO4e3/O44DpmLWi3canHMAluPztD/xT+PySQ
	Cy5rjX8gaDsVGJ43oa/sOLZB/FJJg+uzzye4Qe2gPvXFxIyDYNwiEgBG
X-Gm-Gg: ASbGncvXBookP11Jdqdw17OqMzTYhQQKZCmnHX9dXKJXGVsU636xaYKF0KrCBELj0dk
	tS0Uixmk1LljzcryMoSJjejax9nSsUbGttOVMXZMsmOQ5Fk6t89CVwFfo1jlMWt/ypDbFjBfYp/
	pYkmZU4dQ9YW3MenD7pSqC3zKvCQ5MxqyqC05MwODgoZslW3P5byuHXj9nnCFJFnD3kTWcSIWr8
	q+RounQlidOTZkNV4foXq3KwDaI5bexXi8XMAcpwttb+Pq6jVLITXdZyYB8h8UFVGQKntzekuKa
	zspRHhRLFUCUL5AIFoafiOArwWDCOB3oOWcMpaKgWlp7fqUwHrlJfAA1Bg4oy48PQOFBC3in/mV
	+kigN2CFdx7M4RbGL7iqVsGFGDXJCPCJIHoW6XuY4UJfVdQWZaRf7ulezHURHuFX5nwtgxusxIB
	uTuWZVDuVoisI=
X-Google-Smtp-Source: AGHT+IGweg4LL+gb4dwqqwc1jPy5xP8RZaCb5DBKJ6KmLJIcxJMULBnK7wSEu/rlhjPAD7uez+Sl/A==
X-Received: by 2002:a05:6a00:812:b0:782:7052:5167 with SMTP id d2e1a72fcca58-79384f489bfmr36102351b3a.6.1760521490571;
        Wed, 15 Oct 2025 02:44:50 -0700 (PDT)
Received: from smtpclient.apple (vmi2771466.contaboserver.net. [46.250.226.198])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992bb116basm18084044b3a.30.2025.10.15.02.44.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Oct 2025 02:44:50 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <06A056A1-51F9-4BC4-AE71-805FB0AB48A9@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_874436C0-E429-4838-B9B0-D604E4F008CE"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH V2] mm/khugepaged: fix comment for default scan sleep
 duration
Date: Wed, 15 Oct 2025 17:44:31 +0800
In-Reply-To: <52c8ac78-7a79-4a92-a371-6fb4520a84d9@redhat.com>
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
References: <20251015092957.37432-1-lianux.mm@gmail.com>
 <52c8ac78-7a79-4a92-a371-6fb4520a84d9@redhat.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Stat-Signature: yb5nf6sq9e6u8qunpsnx5oa7h9jp8hoo
X-Rspamd-Queue-Id: E4BE01C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760521491-404087
X-HE-Meta: U2FsdGVkX1/DwkEt4NNEXzSBYvg2MbQ9Kr283iZCjkgSCept6XyDltld45IVQ0RqT1EyEXg1aJTfljM5lO+tK03RYf4TS6Tw5an9x9ConMCMJAuR0ltf1EnMRrmDVU3kbdKQgZrJ2kkXdThomzdhadlOH7Oj48aq36Ur5UUwzUO/JxYS7f00YUSA+BtB59LB/S6hF3Lwb+p2D0wiTLRjV4GvBlbRppaSks3xJeENpzcYnQI6Yjq2KLDPtp1Nw81t35j0vff6v0wDUmycE/K1uQ9EIKPngJqjnafFFjI4FYLpVyGJHuWn0X2fvSJOQuQflV7tZRgzUgsR5RZAZ/4M1y0ca1OPRZ0erDKP6rycR9KHvu0I6uzxxomkFxx4NL+T/6LRQF9exyMLP7NVmTOgcEt4nCtaVaYXNdwNA8394aG9uxlSdoJGyBszapEhHdpCt0vePfPvgSNR5iFQaSV0RAZXslet3ZIy8VvzHn9MOQqCVtAAwWHzzyBYJpIVi906VEzg+pnan0VCQMqK9oFN592rO5v5EJOGYMe3PuBOq8t0TQZoNj2NBEFojDdhG1ku+wZ+txi/29kJwU4WmOZIiwOfBjtramSeQ+sNhiLV3OaDt3ah7SGIM8Qn2oSzQ+EuTZ4QmAMY2LfAbtt6K8hRLX9yoxc/YxTcJ7AX4WCA0tXlSYDkuCDduiNG6iddvY6R5z/rXloRPuLBw8fEGcVSHjItY2gobO/xr337ZIe+LiqrSoHQptz32cggcvnSGruyQlbLsFCIxBfAn4X1T4Zal/1wg61+0JH9QagTrPKQ0HzoJg+ty6Rxc5lkOQjGPeNHMsWP5trGz98LpCuwvVXyR6JJxkewb6xM+b7RVuAs38zF5EU4yzWp/kwxCwxxsLhUlF4ibF9SAD57ZOG368n4orlQ7Icv1M+yE4IIV1uc/9wfTK0rcRTGbIBNTkdNcvggfQ4M4kmCIwI5TtjwMIP
 5TQHVWNv
 8AuoiLtydxGzhVOgA0zeC3TisxFfAZEXajC66AIBOSd2MgDJLINDnz4slRxm5zHfF/xNx40EFjc15JCx0CDlww5oWrwdeoWE/Fhr7TQjICDJVjY+4jXngVUAvo3hfE2DtGhEHZhwrHxzpcCqQKndy8oa++uZ3k3aEpoY/62cm1dulJvmg01ewLnGWBxG0Iro/Xp7m+pt+JpG910QXv4YSATSg7d9waqWtV9t/AZtzg1RcSLCWTLK8m8ui40gmhf2mE+xtvDcCXGv4cfbmWvT+o8l5ClQvEdR5TeWd68/FhsxcU8Oei2yE26fqDIw2mTW+g3cvph+/l6fmQwKEGNfKssHWSuypfEmlC/QNPzFvLCeWWlzmhntKuoWo2exdfggOrdHPQPa7R8S8pggCb7x5tmle2yOc5OulNyPAd+tq9DX/fhZj6WQo8ksN76LMLSPIfbpTJjhm76R0P7cdxaCONfcDMy3Zc701g/Zq/oEixsZ0inmfP6lloQjtLts3PVgr0yP0rkO1AbByEFn6UepGV71xZr7Bk5G4qAyoz1X3Yvl6vZTqxISP+jdLvH0995wbwghLENVsbuBjeFf88hRxxHBNQiYcgGtkfFZ4nv8r6CSTmYj9nOEVpVI77q7Hn5K/+YMXjkjvupROm1XR9IHC+0V1wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_874436C0-E429-4838-B9B0-D604E4F008CE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Ok, I get it, thanks.

> On Oct 15, 2025, at 17:38, David Hildenbrand <david@redhat.com> wrote:
>=20
> "While at it, replace the magic value 512 by HPAGE_PMD_NR and use =
'ptes'."
>=20
>> Fixes: ba76149f47d8 ("thp: khugepaged")
>=20
> I prefer to not have fixes for comments. It tricks people into =
thinking that this might warrant a backport.
>=20
> Likely no need to resend and Andrew can fix it up when applying.


--
Best Regards,
wang lian=

--Apple-Mail=_874436C0-E429-4838-B9B0-D604E4F008CE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;">Ok, I get it, thanks.<br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Oct 15, 2025, at 17:38, David Hildenbrand =
&lt;david@redhat.com&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">"While =
at it, replace the magic value 512 by HPAGE_PMD_NR and use =
'ptes'."</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">Fixes: ba76149f47d8 ("thp: =
khugepaged")<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">I =
prefer to not have fixes for comments. It tricks people into thinking =
that this might warrant a backport.</span><br style=3D"caret-color: =
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
text-decoration: none; float: none; display: inline !important;">Likely =
no need to resend and Andrew can fix it up when =
applying.</span></div></blockquote></div><br><div><br></div><div><div>--</=
div><div>Best Regards,</div><div>wang lian</div></div></body></html>=

--Apple-Mail=_874436C0-E429-4838-B9B0-D604E4F008CE--

