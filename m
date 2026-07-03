Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B747DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4906B0187; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B906B0188; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B526B0189; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 100846B0188
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:11:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 969941C37BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:11:18 +0000 (UTC)
X-FDA: 84945687036.09.9EF9F33
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id C630C18000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:11:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3P1VkjF;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783041076;
	b=2sDfGw1OW1IPEltDM5Lvnqg4ZkMCQK7O7fFsbJPw+QYCFqPiZc6J4LroTnTC+QcwqQZrBO
	kPRGvVCvYvP05tIJdef50rglFcT+sOZWHhyZCzJwtq1eTdMbIlBYOLwbKNu1sZbJjeMiaB
	8CBYDBK1jPUMTOuw/Ujyv3eFEXvsPLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783041076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mi2h0LC4vHT1UDvZgc98fMyuk8IMzTGU3sRZXYUiVi4=;
	b=Qg5Jxe+Q2NBDWr0OEAUq4KhlThtu0m8gDsuWi8ycBJAYBRDZ1B6TRvzIWKpDrjBbf3N1bc
	XOtymTz1gQXajqhNqSTVMbuHRNAvjG/PbUrtL1gGiD7GoLAlFJ4wWdQGnU59SvGh6nBRzW
	pdn9t6W+TWufdPHGr9YjzF+w+2fahUg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3P1VkjF;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37defb2f231so6706a91.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 18:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783041076; x=1783645876; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mi2h0LC4vHT1UDvZgc98fMyuk8IMzTGU3sRZXYUiVi4=;
        b=a3P1VkjFMxEncT/h1je3iHe0bgBExWaK+7Bz5hkNncINMYRaDKD+JmvEFWYpayLS+/
         IU7tvcPZXzeg9mM3MhieFYN2LRahaorqKM/LxJGWwtmR/lFGxpDPsJoVYaeXcSloB8ir
         N4cZm6rn558dQkb0+Z0nEwA7FFEo7IO32gVeJbXOo1baGep6E9LiTcsV+wZ77nFATytN
         H+FEBStsPgWWCJ2gbGe6ZBm2OiDFwpTGK4kOGXQPiXAF56354qYBxOQcISS1QegkxvVh
         g6Otjzfp+ZgaZLrMRtgV/KsmMze37j9nIayHXBPTHQaWpkXkDtaOxq1i0nDTKyhScKmf
         XflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783041076; x=1783645876;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mi2h0LC4vHT1UDvZgc98fMyuk8IMzTGU3sRZXYUiVi4=;
        b=Qdcy0B51RwDMiXA+uT6loTawiisXW9zM3hpJVYHcCCz8L18NauTm/oMjRVXhBHQZ/C
         xU2N0quQaF3wv9jTcB3JcXCq/N9uFwXFyaoAjBHlTGOypydjl7dbQsadqFXzBehZfW0X
         2q3MY7LK7DB5H2SAqCc741ikN0AzjRMfDwLNFnDvn1N7aufyw16adsgbpMC5EF9QqMzK
         rSFSQG3tDM7C53YB0JY3tx2FzTjeY6syWex7Fdn1OKtpWAmlXLdJy50xp7/WRZJuOOgk
         mRQcknmrdGTbWC1Cs36Hjyux4BtZOKBPBaUhJIEkK4/QrMcflUhFj9x+O47vEoKZgwyR
         qnIQ==
X-Forwarded-Encrypted: i=1; AHgh+RpFJ58sXSo3wS2JZft3Wh6FuvZan90rcJSIyf/+4B4PRW9J4n0V7v9LnRfWcBi3UgNk+pw1RtwWFQ==@kvack.org
X-Gm-Message-State: AOJu0Ywn4CPyTFp+s7AuLfSrcJ4J/2/XDR8WLw1mJ63nfF1AyGY8RBLm
	BnQUzSUo4EdzSRoB8+OD+QMKxPGEQXZT8MxnZRqyYYhuiPeCe41BR5SL
X-Gm-Gg: AfdE7cnCsAoIhF3oWvOfBw4c7exN1dDbjsKboVbVZFxYAjSLaG2/ZHVUxP+JpPazi1c
	+SV/meH256OHhh3N/K89HoK/lUfcpEjZ0QwlboWDjVHOmLFTdbCimB80Xk8ab6jx6jyxdrjpMEO
	JHTUYeNSMawjt8KFjjScmzHjOvZxpZZeBtqy0px6ewtJI7P+ns0pvPKMNdeVYWpqTbQMVgElBfi
	x6tAiwzVmeB/Io5HGnXA0X+vMxGCDXuyIN+WmYstIIcFRhwFUvfDSvqI2ecy0OdpU6vBukj7ft8
	hZ8VVOvum0a73CMRzon9+5jAEl1zcWpssbcjq8HK9yGKCxhECHsFkmUVntMJ65CFQ5enPdGgvZl
	p5R1KI9rIe6mriLdUYguOL4dqdIv4tVl6loetyNOlvAr5ZhSUhowtEQEjDvTHiFDRZfJ6mwmcYM
	1CiasZwg==
X-Received: by 2002:a17:90b:1c06:b0:368:ed26:15b2 with SMTP id 98e67ed59e1d1-380aa0d57f8mr8897189a91.8.1783041075513;
        Thu, 02 Jul 2026 18:11:15 -0700 (PDT)
Received: from smtpclient.apple ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0b86ef6asm15441961eec.13.2026.07.02.18.11.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2026 18:11:15 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <F1C05416-5D04-4568-B8CD-D4376B0F3848@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_D4419ACD-2D8B-4116-92C4-E3AC7FF78AC2"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split
 actions
Date: Fri, 3 Jul 2026 09:10:51 +0800
In-Reply-To: <akY6ZzPnwk-CToMp@lucifer>
Cc: sj@kernel.org,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 daichaobing@sangfor.com.cn,
 kunwu.chan@gmail.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org
To: Lorenzo Stoakes <ljs@kernel.org>
References: <20260702094633.75658-1-lianux.mm@gmail.com>
 <akY6ZzPnwk-CToMp@lucifer>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Stat-Signature: nx4zcttg5tzsyiagkdir995i9ymsisz4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C630C18000D
X-HE-Tag: 1783041076-308572
X-HE-Meta: U2FsdGVkX1/HmrHvrhwHcZSkJk7wfMFja5VbfT7TC0IgTj+R5i76Do08K9+zuADel1Y6DteqHcMcxC6vLaNhoPCHTunQ3aiqM6zwhEZkGuGdqDZx/c8sWIMJZV2+pYrfV44+8HyQSJC9I0NIv/S2kC+tjzQU44byRM9BulLlZqL3QUlKEs1Yay7ERKv6bs1KfJATm3akophLxxx7w6RkIL3hBSAttst0QFcVwXDb2AacsT38Wm7qlJJxG025ao7sNC0oF0Cs5NfDU2V/99Qr49IT60g1lqs6x7aOAllvOnEM+bEKwF0+23PLxA3V2movVTGqmLpPfrF1jujnl+VtnI0SVzuc2kyHcvrgGt4KExi1DxpAJcwEuH2+66yoOXTGvswKWiCnC/Hxm2cplJ85n1UYLBfdd1CziO/e42PLhmcsgaayI2EW73nFTIHMy3XE0Ku/zGhWdc7WGHSWGB/UkEt4ZMLjhtimeRQNc3kiujHnBuNWqsHzFq+6loTgf3nHc7q+lgR8kQyHvpxLAHkRM16QGarbhPbtH/DvHezEGhfzMiyHAvyDnIivVguhjpB3Uii+FSuYG3BlF2bIhiPaAD/ESoFQKawvSp8Ux4uEHMxCTqGX9i8R6AKyLnpb80ZfASbuBk/gTl9uTBfdEB4mMsY0w2wkyipJzedEEWp9YcnAme++LLmZlE0Gha1Ds+CEHLZ+u1BntuydDrAJyzeAbRbPi8ZNSHwavznHpik75wSzcQIeLi9zWm8OjE/8EH04VFLOttsT2i54KR2I0yIArqtFg8EtuxKyx+IYjcUybhyFG9Bj1LOkvDNMwXjTd2IabevaBX33WtaDXtu88b1Mz6bsUEe40IpfKvxL/O5wv/oe6S1B1/JgStz24ZTZkWHTtmeMH5oleMDJPmRBMHPuQyHTKOcMRFAghHrqsraJCWTHQ4Z3Vv8WM9rHz0TmL8gynxv3sHjcStUu9d+QBi6
 tvvPfRp2
 lJ86nX0ZYoeQGBgDaOzJxc9JyyOHfyjGuGmgmjOGByvxSHkkvrfCFqdmOaRSTN0aMxwds0yJ56NpZmVbHfuwtkPZhcTa4tMqLL5pWU5tsStQFJKvFB6cju+tTmZfahaZ9bGltzp/MtlD2PTaf96fk84lDnejTu7TxnxnZnKWbF8iVeoQPRI3h5zOTh3BDkT8RWbvZqS/MCpFyIJ3BoHof5gcK35BaN7BGQktMasNjlwjMsPEEPFBUMwO+1wfFFXM6F0I+n8yyOyhqDvyTy8cPAvj66V12QrchXikZfO/IUfN8fdbYaKPMiQJ1RRWeSqP2BwxTvJPy4E33iGlwCw++w1gLhEUs+BLDiJhxDB/9eU2ck2w4/AQ6bfobccESuPwfNFMfHflssBoQt4uVxjKFoWha1PLNSmNbHz1R8iWP+Odwjv91PUrmNtc+yq5SFhuAOS/y8uKPhmnYL/U0TT1DK4tC7JVzXEBCpmLGf4sX7VI6pHrx8kKBgBOm9d8we0BoElk28RZTB9kDSwbupNoXR0n3WJadPXpxIeV0mw2jNBuQpHbPH/yamfG2GlfYtLMRZWcmw2AsalkdcVbP0jr4J3ngy8oyYINUP+vz5rtFlqdjoylcS7BgKjo4NUFEhXaL7HS/Wwe8x3Z7KjQH5gETs/+f6rfxkSGmXh9pBYZGFHIJEc6r7dvdM6dFMs1Vzj+WLqaoI6OI9N8ENqV8J59BsUPHb/OAhIwIRXpSudgnkMPqPAlPe6KRibtfFuBtr4emzJNYFuHHdMoToWQBESlFhDN+TlepnHdWH6L/6slPEfV3R2Q8dEFpGLlPYW8Ez/8XabY+7uWkwLsNudolcWL9wlVEkvj32Jrr2Q2lKvCusTz2xj33x5H3Tvf6nyBGXwsiUaeubSIPhPZtiBRGqOueCR/XwLwHLJjeyBLHhl/S0SVlk2hiyO2P9IsoU5sjNTg4WAtqHHOMwCNNQ20ZOmuxGrB50BgS
 qsNexGMX
 +/YTJqk286Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_D4419ACD-2D8B-4116-92C4-E3AC7FF78AC2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,Lorenzo

> On Jul 2, 2026, at 18:23, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> +cc all those you missed.
>=20
> I really need to write a bot to do this, because I'm getting a little =
tired of
> pointing this out :))
>=20
> On Thu, Jul 02, 2026 at 05:46:28PM +0800, Lian Wang wrote:
>> include/linux/damon.h      |  10 +++
>> include/linux/khugepaged.h |   9 +++
>> mm/damon/core.c            |   2 +
>> mm/damon/sysfs-schemes.c   |  77 ++++++++++++++++++++++
>> mm/damon/vaddr.c           | 128 =
+++++++++++++++++++++++++++++++++++++
>> mm/khugepaged.c            |  46 +++++++++++++
>> 6 files changed, 272 insertions(+)
>=20
> You are doing damon changes, and that belongs to SJ, sure.
>=20
> But you're also changing core THP code? Please ensure you cc- THP =
people because
> without our approval this cannot be merged:
>=20
> $ scripts/get_maintainer.pl =
20260702094633.75658-1-lianux.mm@gmail.com.mbx =
<mailto:20260702094633.75658-1-lianux.mm@gmail.com.mbx>
> SJ Park <sj@kernel.org <mailto:sj@kernel.org>> (maintainer:DAMON)
> Andrew Morton <akpm@linux-foundation.org =
<mailto:akpm@linux-foundation.org>> (maintainer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> David Hildenbrand <david@kernel.org <mailto:david@kernel.org>> =
(maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Lorenzo Stoakes <ljs@kernel.org <mailto:ljs@kernel.org>> =
(maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Zi Yan <ziy@nvidia.com <mailto:ziy@nvidia.com>> (reviewer:MEMORY =
MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Baolin Wang <baolin.wang@linux.alibaba.com =
<mailto:baolin.wang@linux.alibaba.com>> (reviewer:MEMORY MANAGEMENT - =
THP (TRANSPARENT HUGE PAGE))
> "Liam R. Howlett" <liam@infradead.org <mailto:liam@infradead.org>> =
(reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Nico Pache <npache@redhat.com <mailto:npache@redhat.com>> =
(reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Ryan Roberts <ryan.roberts@arm.com <mailto:ryan.roberts@arm.com>> =
(reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Dev Jain <dev.jain@arm.com <mailto:dev.jain@arm.com>> (reviewer:MEMORY =
MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Barry Song <baohua@kernel.org <mailto:baohua@kernel.org>> =
(reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> Lance Yang <lance.yang@linux.dev <mailto:lance.yang@linux.dev>> =
(reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> damon@lists.linux.dev <mailto:damon@lists.linux.dev> (open list:DAMON)
> linux-mm@kvack.org <mailto:linux-mm@kvack.org> (open list:DAMON)
> linux-kernel@vger.kernel.org <mailto:linux-kernel@vger.kernel.org> =
(open list)
>=20
>>=20
>> --
>> 2.50.1 (Apple Git-155)
>>=20
>=20

Thank you for pointing this out again, and I deeply appreciate all the =
tedious=20
work you do as a maintainer to keep the mailing lists aligned.=20

As a newcomer trying to transition into complex feature development, I =
must=20
admit my initial design is far from perfect. I leveraged AI tools to =
assist=20
with certain implementation paths, and although I extensively =
self-reviewed,=20
tested, and reasoned through every single line of code, your and SJ's=20
feedback clearly shows there are still major architectural flaws. Just =
like my=20
very first kernel patch=E2=80=94which was strictly reviewed and guided =
by you and David H.=20
=E2=80=94I know that your sharp feedback is exactly what will help me =
grow as a kernel engineer.

I will completely step back and radically rethink the design of this =
series,=20
especially regarding the cross-subsystem encapsulation and locking =
hazards.=20

As for that bot you mentioned getting tired of running manually=E2=80=94le=
t me write=20
it for you. An imperfect newcomer who just made these exact mistakes =
knows=20
precisely where the traps are. I can craft a pre-flight patch check =
script or=20
a CI bot that automatically validates the `get_maintainer.pl` output =
against=20
the patch file diffstat before any email is dispatched, throwing a loud =
warning=20
if core MM files are touched but their respective maintainers are =
missing from=20
the CC line.=20

What do you think? I would love to build this tool to save your and =
other=20
maintainers' valuable time in the future.

Thanks again for steering me in the right direction!

Best regards,
Wang Lian
> Thanks, Lorenzo


--Apple-Mail=_D4419ACD-2D8B-4116-92C4-E3AC7FF78AC2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;">Hi,Lorenzo<br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Jul 2, 2026, at 18:23, Lorenzo Stoakes =
&lt;ljs@kernel.org&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+cc all those you missed.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">I really need to write a bot to do this, =
because I'm getting a little tired of</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">pointing this out :))</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On Thu, Jul 02, 2026 at 05:46:28PM +0800, =
Lian Wang wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;">include/linux/damon.h &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;10 =
+++<br>include/linux/khugepaged.h | &nbsp;&nbsp;9 +++<br>mm/damon/core.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;2 +<br>mm/damon/sysfs-schemes.c &nbsp;&nbsp;| &nbsp;77 =
++++++++++++++++++++++<br>mm/damon/vaddr.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 128 =
+++++++++++++++++++++++++++++++++++++<br>mm/khugepaged.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;46 +++++++++++++<br>6 files changed, 272 =
insertions(+)<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">You are doing damon changes, and that =
belongs to SJ, sure.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">But you're also changing core THP code? =
Please ensure you cc- THP people because</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">without our approval this cannot be =
merged:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">$ scripts/get_maintainer.pl<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"mailto:20260702094633.75658-1-lianux.mm@gmail.com.mbx" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: =
0px;">20260702094633.75658-1-lianux.mm@gmail.com.mbx</a><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">SJ Park &lt;</span><a =
href=3D"mailto:sj@kernel.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">sj@kernel.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (maintainer:DAMON)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Andrew Morton &lt;</span><a =
href=3D"mailto:akpm@linux-foundation.org" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">akpm@linux-foundation.org</a><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (maintainer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">David Hildenbrand &lt;</span><a =
href=3D"mailto:david@kernel.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">david@kernel.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (maintainer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Lorenzo Stoakes &lt;</span><a =
href=3D"mailto:ljs@kernel.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">ljs@kernel.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (maintainer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Zi Yan &lt;</span><a =
href=3D"mailto:ziy@nvidia.com" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">ziy@nvidia.com</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Baolin Wang &lt;</span><a =
href=3D"mailto:baolin.wang@linux.alibaba.com" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">baolin.wang@linux.alibaba.com</a><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">"Liam R. Howlett" &lt;</span><a =
href=3D"mailto:liam@infradead.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">liam@infradead.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Nico Pache &lt;</span><a =
href=3D"mailto:npache@redhat.com" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">npache@redhat.com</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Ryan Roberts &lt;</span><a =
href=3D"mailto:ryan.roberts@arm.com" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">ryan.roberts@arm.com</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Dev Jain &lt;</span><a =
href=3D"mailto:dev.jain@arm.com" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">dev.jain@arm.com</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Barry Song &lt;</span><a =
href=3D"mailto:baohua@kernel.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">baohua@kernel.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Lance Yang &lt;</span><a =
href=3D"mailto:lance.yang@linux.dev" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">lance.yang@linux.dev</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><a =
href=3D"mailto:damon@lists.linux.dev" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">damon@lists.linux.dev</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;"><span =
class=3D"Apple-converted-space">&nbsp;</span>(open list:DAMON)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><a =
href=3D"mailto:linux-mm@kvack.org" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: =
0px;">linux-mm@kvack.org</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;"><span =
class=3D"Apple-converted-space">&nbsp;</span>(open list:DAMON)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><a =
href=3D"mailto:linux-kernel@vger.kernel.org" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">linux-kernel@vger.kernel.org</a><span style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;"><span =
class=3D"Apple-converted-space">&nbsp;</span>(open list)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;"><br>--<br>2.50.1 (Apple Git-155)<br><br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"></div></blockquote><div><br></div><div>Thank you for pointing =
this out again, and I deeply appreciate all the =
tedious&nbsp;</div><div>work you do as a maintainer to keep the mailing =
lists aligned.&nbsp;</div><div><br></div><div>As a newcomer trying to =
transition into complex feature development, I =
must&nbsp;</div><div>admit my initial design is far from perfect. I =
leveraged AI tools to assist&nbsp;</div><div>with certain implementation =
paths, and although I extensively self-reviewed,&nbsp;</div><div>tested, =
and reasoned through every single line of code, your and =
SJ's&nbsp;</div><div>feedback clearly shows there are still major =
architectural flaws. Just like my&nbsp;</div><div>very first kernel =
patch=E2=80=94which was strictly reviewed and guided by you and David =
H.&nbsp;</div><div>=E2=80=94I know that your sharp feedback is exactly =
what will help me grow as a kernel engineer.</div><div><br></div><div>I =
will completely step back and radically rethink the design of this =
series,&nbsp;</div><div>especially regarding the cross-subsystem =
encapsulation and locking hazards.&nbsp;</div><div><br></div><div>As for =
that bot you mentioned getting tired of running manually=E2=80=94let me =
write&nbsp;</div><div>it for you. An imperfect newcomer who just made =
these exact mistakes knows&nbsp;</div><div>precisely where the traps =
are. I can craft a pre-flight patch check script or&nbsp;</div><div>a CI =
bot that automatically validates the `get_maintainer.pl` output =
against&nbsp;</div><div>the patch file diffstat before any email is =
dispatched, throwing a loud warning&nbsp;</div><div>if core MM files are =
touched but their respective maintainers are missing =
from&nbsp;</div><div>the CC line.&nbsp;</div><div><br></div><div>What do =
you think? I would love to build this tool to save your and =
other&nbsp;</div><div>maintainers' valuable time in the =
future.</div><div><br></div><div>Thanks again for steering me in the =
right direction!</div><div><br></div><div>Best regards,</div><div>Wang =
Lian</div><blockquote type=3D"cite"><div><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thanks, =
Lorenzo</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_D4419ACD-2D8B-4116-92C4-E3AC7FF78AC2--

