Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC72FF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 08:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE3D6B0088; Fri,  1 May 2026 04:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEFF6B008A; Fri,  1 May 2026 04:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977286B008C; Fri,  1 May 2026 04:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 829346B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 04:34:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02A6C1401D6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:34:03 +0000 (UTC)
X-FDA: 84718188408.08.6FC9639
Received: from cu-ua11p00im-quki07170902.ua.silu.net (cu-ua11p00im-quki07170902.ua.silu.net [123.126.78.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF3551A0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:34:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Pz65A3sP;
	spf=pass (imf19.hostedemail.com: domain of lukafocus@icloud.com designates 123.126.78.68 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777624442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EoSV0poOaAunmo+pUTJocizW0WnMsTilP/It+3Fm1fM=;
	b=rLqjGwdIZ9Z0bM0fpEUi1uba/7+kaP9RUXsZ7iVO7zoPJng4ZW7BCccqu23L1zXrCydUnT
	xV1rkejrsuzDgF+kaMNjw0LaFoUUd7f0FmXRjWt1bzYR2QPItayYet6cictF6tdXBSefiL
	XYJ7ah1L0VK8hLVSszyaP3tjGATVpeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777624442; a=rsa-sha256;
	cv=none;
	b=Zak6AUzH6+CUP+jD6M6J/NnpJXgNMwIP8WgVcnRjF7YMAH4/ttI2HbNIp73xk3xhKrJBlW
	H4l986cu08tnEqv7Q6cV4tQjnEc0dC5LidSbfFYqTNGNtkxqzSDe+Cmy8JXo+kLdhVFhT7
	ppVElKzlWN2WE3BGiQHhZk1X7xNBwIc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Pz65A3sP;
	spf=pass (imf19.hostedemail.com: domain of lukafocus@icloud.com designates 123.126.78.68 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki07170902.ua.silu.net (Postfix) with ESMTPS id 462E8CC00AA;
	Fri,  1 May 2026 08:33:36 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777624430; x=1780216430; bh=EoSV0poOaAunmo+pUTJocizW0WnMsTilP/It+3Fm1fM=; h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To:x-icloud-hme; b=Pz65A3sPJC2RjN+orkRzco5tuISvcZm1oS2w9cgEOxqr+M9BrUFd7x+nD7HVaFxV2uOeyZpM09BxbCBADL7Bu2ZoVUqKTkVSMMgZQeLAfV2A6gIAttXvMfyzXh3C3mpljDsrVRRXlFhZrN+EsL7MO0AFGyD858d/w+AMgEtkJ8Pj9dpXICHh9fqVqavG822lQ2VewpyzT5/A38Fh5H9h21H6cxO5/+F6iAoa9vIlguKBg52Sf+46xiATi6kEdvqgoVLbCE/97HiRdV0gciJjRRvupt2BU+V5AiSJSP8qm3UXbBe82nJxspaRTCqQhQxFjuv7W16M4W6Rg/b1NyLWKw==
From: lukafocus@icloud.com
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_29DC8C7B-D576-45CD-A759-75360BE2266D"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH 0/5] mm: Support selecting doing direct COW for anonymous
 pmd entry
Message-Id: <8F6F0691-91A1-4645-A218-2219DE6047AD@icloud.com>
Date: Fri, 1 May 2026 16:33:25 +0800
Cc: akpm@linux-foundation.org,
 arnd@arndb.de,
 baohua@kernel.org,
 baolin.wang@linux.alibaba.com,
 corbet@lwn.net,
 dev.jain@arm.com,
 jannh@google.com,
 kasong@tencent.com,
 lance.yang@linux.dev,
 liam@infradead.org,
 linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 ljs@kernel.org,
 lukabai@tencent.com,
 lukafocus@icloud.com,
 mhocko@suse.com,
 npache@redhat.com,
 rppt@kernel.org,
 ryan.roberts@arm.com,
 skhan@linuxfoundation.org,
 surenb@google.com,
 vbabka@kernel.org,
 ziy@nvidia.com
To: david@kernel.org
X-Mailer: Apple Mail (2.3826.700.81.1.4)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDA3NCBTYWx0ZWRfXxN5dhDWFDggU
 MSLSmTKGW/5m/uLXtvVMCTOejl+ES3pp8A+TpDoc9cIDy0VqpaniuIOFXVrjHNMgUIvaBZaF1ca
 oSgpWBwNh7v3Os0um2zhj010j6Bi97SJNDxR+Q92C/O74XZuW2J+HDYnugA/yIdJVyxAny4OrB6
 OFrY3XDmf+lT0gtEtTHqj2xlKaKxJOCJ/Osp1OdweHHOXTURjCVM3bIEPCZlRWugXQQYWCL5/yc
 Y0dzwRK0vmbbg6JduVfFS4bSM3qhrHqz9ylgu8fUZ/qpyYfrf7+XstUAGAJD2xDcxSh6UPtAKUE
 6RPGMvlR/UzmtYtYHSvD9LAoJWxMhbAa1kO1e11NA==
X-Proofpoint-GUID: fydz3qU1mCvs-Kdo_Ob4Rlf93mr2fONi
X-Proofpoint-ORIG-GUID: fydz3qU1mCvs-Kdo_Ob4Rlf93mr2fONi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_01,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 clxscore=-2147483648 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2605010074
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF3551A0006
X-Stat-Signature: tjdi3akkmiwdfmu579cd883183biehr5
X-Rspam-User: 
X-HE-Tag: 1777624440-311553
X-HE-Meta: U2FsdGVkX18UOX39f7qoqj/oNADF3Ciot7UdywSWs0ntUmnZOCE38RNgUfHSaQcxP68tdoyh91lRql5cEEmArGAzfof3IoMOMoOn0Ri6v4wps2Ju3NkIoOpw8iVpubMrGRefA2jNbgDVAtH0cLN/5OV4DQ/IGaEDVj9QwcvyvmTKKRiFw23RAvutWDmYYoov/doozAe/vtekyEgSYBjB09IBHcbEKN9lLyMcVMNf7V1BPwJqeJuyXoyIyjzbKG9mZWqDPT2N6RVPep+7pcIcFpipb4M/ag8cSjYZKq3lH4NsMfWjtXvl4hwNQZ9JyiIPuy3b4wck07u7ybQGHOVGOXVrnqzDbFRyEGsDXImyHEzrm0xcusPwXY0k2l/BTz6wSXCeElqGrGf8+9rJLB9dR9lnGTXQaL8s0QbyRxghrwliUuaRSHsF060uN8PNBm+kQWC2T+IJZPt/O6H8TADbcJD2RtJMz8/3G5rAn+IlbbEEK1pD3YqfKMFE5JTbUUFRSXH7BcP/8SwzQ9fKb4U0DV70Vl9AT2Sav510pgEaFU4bm8vhN8DBpxfrz2W/7jKzfVnnbhzsVQ2OGTk2CWCbD+vRg60zd0BYQHQhTxnJddYeTXb30Uf6m1YhT0ubJ/n9RaoISE0kiEDgGKAIr7jHMwECxGj4Gtu6rAeimOd1ZXVnBStGJHYuPfjoDl4pP5RGe1OtaILj2tWpFTgS8JSpgIz2oJgM3N8n2sMOpqBV6ZPB3RBYngKdZ75wIjkwX4iXDGN8INUZzPBB5vbMqZYp/aayhGPsqb/nyngTKGjRKheLMeekaihRUO/XC8piYBrZuq4MyYNKlaMeHaOPRxuAc4LViYlDqasShbGR6PBTX7a1V6KgFKqXoKCBLKsz3L5AiTIfRzkfCpFLC8M/p/FmnIMpWXiBxefoVTJy7gDOHeBjeM/btv5Un8zL39DzWe941felYmbhtICYl1d1dNV
 EbnVg34b
 fcWcW/1bAOuvJ5un7HpXPUunuwZ+ADCu8FvtHyPyOzrvDp5juBrcjcpyr+6TAFcs5kVy3+V2n8XdNXbZgiLrRG3lakwyvKaTy/wAvNRuuKuwhmkYZUiAPKs1p1OpwmClYXxL+rpd0DcdZ9PEDzI+TbrUkxfAR/dpO81xhwUGoaP4pCeZSOPY3WRGLx8q5kCb63GG5lxo5VOSl32RmpDwmjrzN1ZbTUnZBJpellDBkkpL9hNWraAh7Z2s8WZcce6rkriAKxKin3DjqIaCVO7fK9JiS1inejOHounhd1zTYNOkTPnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_29DC8C7B-D576-45CD-A759-75360BE2266D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi David,

Thanks for your review and opinion :) I really appreciate it!

> > Copy on write support for anonymous pmd level THP is simple right =
now:
> > firstly we'll check whether the folio can be exclusively used by the
> > faulting process, if we can (when the ref of the folio is only 1 =
after
> > trying to free swapcache or the page flag AnonExclusive is setup) =
we'll
> > directly use it with few further handling. If we cannot, then we'll
> > split the pmd into 512 4K ptes, and do copy on write only for the
> > specific 4K page that we faulted on.
> >=20
> > This logic is truly memory efficient since for most workloads we =
don't
> > want to allocate 2M new memory simply on a small write. However, it =
also
> > makes the original 2M page for the process suddenly splitted on a
> > write which will generate some performance thrashing. For example, =
if
> > process A and process B share an anonymous 2M pmd, if process B =
chooses
> > to do a writing, then its page table mapping will be changed from 1
> > pmd entry into 512 4K pte entries at once, so the tlb benifit will
> > suddenly just "vanish" for process B, which sometimes may cause a
> > observable performance degeneration. After that, we can only wait =
for
> > khugepaged to do the collapse for this area and merge the pmd back, =
which
> > is not easy to happen.

> You probably know that, historically, we did exactly what you describe =
in this
> patch set. It was rather bad regarding memory waste and COW latency, =
so we
> switched to the current model.

> Note that there was a recent related discussion for executable, which =
was rejected:

> =
https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com=

Yes I know this history, and I know that it will cost some memory or =
latency,
That=E2=80=99s why I want to add a switch to it to make it configurable =
:) But I don=E2=80=99t
Know the existence of this discussion in=20
=
https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com=
,
I=E2=80=99ll check it out, thanks for imforming me that :).

> >=20
> > In addition to the problem above, this logic can also generate some
> > deficiency for THP itself. Currently THP is just a "best-effort" =
choice
> > with no "certainty". THP is easily splitted into multiple small =
pages
> > on common calling path like reclaiming, COW. A transparent splitting
> > can cause throughput fluctuation for some workloads. For these =
workloads,
> > we may want to give THP some "certainty" just like hugetlbfs,

> There are no such guarantees, though. And We wouldn't want to commit =
to any such
> guarantees today. For example, simple page migration can split the =
folio.
> Allocation failures will fallback to small pages etc.

> If you need guarantees, use hugetlb for now.
The reason why I want to use THP over hugetlb is actually I need =
reclamation for my
workload :). There are many processes in my workload that need 2M
aligned memory, and we want to reclaim them back automatically when the =
process
doesn=E2=80=99t need it. But hugetlbfs cannot do passive reclamation =
from what I
know (except doing active madvise my the processes themselves). And =
using THP can
easily split the hugepages. So that=E2=80=99s why I would like to add a =
certainty for THP,
and use THP for these processes as backend, because THP is very well =
integrated with
the swapping and other filesystems. And from what I checked,
it seems the most common case for splitting a THP is COW and swapping so =
I am trying to handle
these two scenarios (But coincidentally, PMD swapping is committed in
=
https://lore.kernel.org/all/D3F08F85-76E0-4C5A-ABA1-537C68E038B8@nvidia.co=
m/
a few days before, which is a great implementation :) ).

> > The effect
> > we want is: after some customized setup, if only the system has =
usable
> > folio, and the virtual memory alignment permits (or we setup to), we =
can
> > make sure we always use THP for it, the system will never split it =
except
> > the user wants to do so.
> >=20
> > This patchset is about both two things above, firstly we add pmd =
level
> > THP COW support by revising the code in do_huge_pmd_wp_page, we =
added
> > switch for it because different workloads may need different =
resources,

> The switch is bad, and we won't accept any toggle like that. A =
system-wide
> setting does not make sense for such behavior.

> A per-VMA flag? Maybe, but I expect pushback as well, as it is way too =
specific.
> So we'd have to find some concept that abstracts these semantics. But =
I expect
> pushback as well.

> We messed up enough with toggles in THP space, unfortunately.

> Also, anything that only works for PMD-sized THPs is a warning sign in =
2026 :)

> You don't really raise any concrete use cases or performance numbers =
for these
> use cases. Some details about applications that use fork() and rely on =
such
> behavior would be helpful.
Oh, the reason why I added a switch globally is also because the =
scenario I mentioned
above, I want those processes to always use PMD sized pages as back
end to make sure performance. COW is truly not that common like swap =
out/in, but it
can happen sometimes and can harm the performance for these processes. =
Setting the
System globally is more convenient for my situation :).
I don=E2=80=99t actually have a performance test set in workload level =
right now since COW
doesn=E2=80=99t necessarily happen in my workload, it just can happen =
sometime. And the workload
itself hasn=E2=80=99t been finished yet. Pure performance comparison =
between 512 pte COW and 1
pmd COW is easy, but I guess that doesn=E2=80=99t have too much meaning. =
But I think maybe
PMD COW can be a more common case in the future? For example, maybe pmd =
level KSM
support? :)
And for PMD-sized THPs, actually, I=E2=80=99m also considering adding =
more support to mTHP
If the upstream consider it useful. And also for pud sized THPs also. :)
MADV_DONTFORK and MADV_COLLAPSE are nice and great options :), but the =
former one seems
to be a little wasteful :). And the latter one can greatly solve fork =
situation, but
It seems it can not solve the situation like pmd swap in for pmd pages =
mapped by
two processes. :)

Look forward to your further opinion, thanks!
Best,
Luka=

--Apple-Mail=_29DC8C7B-D576-45CD-A759-75360BE2266D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"overflow-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;"><p =
style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Hi David,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Thanks for your review and opinion :) =
I really appreciate it!</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; Copy on write support for =
anonymous pmd level THP is simple right now:</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; firstly we'll check whether =
the folio can be exclusively used by the</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; faulting process, if we can =
(when the ref of the folio is only 1 after</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; trying to free swapcache or =
the page flag AnonExclusive is setup) we'll</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; directly use it with few =
further handling. If we cannot, then we'll</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; split the pmd into 512 4K =
ptes, and do copy on write only for the</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; specific 4K page that we =
faulted on.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt;&nbsp;</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; This logic is truly memory =
efficient since for most workloads we don't</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; want to allocate 2M new =
memory simply on a small write. However, it also</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; makes the original 2M page =
for the process suddenly splitted on a</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; write which will generate =
some performance thrashing. For example, if</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; process A and process B =
share an anonymous 2M pmd, if process B chooses</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; to do a writing, then its =
page table mapping will be changed from 1</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; pmd entry into 512 4K pte =
entries at once, so the tlb benifit will</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; suddenly just "vanish" for =
process B, which sometimes may cause a</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; observable performance =
degeneration. After that, we can only wait for</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; khugepaged to do the =
collapse for this area and merge the pmd back, which</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; is not easy to happen.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; You probably know that, =
historically, we did exactly what you describe in this</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; patch set. It was rather bad =
regarding memory waste and COW latency, so we</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; switched to the current =
model.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; Note that there was a recent =
related discussion for executable, which was rejected:</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; <a =
href=3D"https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@hu=
awei.com">https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@=
huawei.com</a></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Yes I know this history, and I know =
that it will cost some memory or latency,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">That=E2=80=99s why I want to add a =
switch to it to make it configurable :) But I don=E2=80=99t</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Know the existence of this discussion =
in&nbsp;</p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-width: normal; font-size: 13px; =
line-height: normal; font-family: &quot;Helvetica Neue&quot;; =
font-size-adjust: none; font-kerning: auto; font-variant-alternates: =
normal; font-variant-ligatures: normal; font-variant-numeric: normal; =
font-variant-east-asian: normal; font-variant-position: normal; =
font-variant-emoji: normal; font-feature-settings: normal; =
font-optical-sizing: auto; font-variation-settings: normal;"><a =
href=3D"https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@hu=
awei.com">https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@=
huawei.com</a>,</p><p style=3D"margin: 0px; font-style: normal; =
font-variant-caps: normal; font-width: normal; font-size: 13px; =
line-height: normal; font-family: &quot;Helvetica Neue&quot;; =
font-size-adjust: none; font-kerning: auto; font-variant-alternates: =
normal; font-variant-ligatures: normal; font-variant-numeric: normal; =
font-variant-east-asian: normal; font-variant-position: normal; =
font-variant-emoji: normal; font-feature-settings: normal; =
font-optical-sizing: auto; font-variation-settings: normal;">I=E2=80=99ll =
check it out, thanks for imforming me that :).</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt;&nbsp;</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; In addition to the problem =
above, this logic can also generate some</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; deficiency for THP itself. =
Currently THP is just a "best-effort" choice</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; with no "certainty". THP is =
easily splitted into multiple small pages</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; on common calling path like =
reclaiming, COW. A transparent splitting</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; can cause throughput =
fluctuation for some workloads. For these workloads,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; we may want to give THP some =
"certainty" just like hugetlbfs,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; There are no such guarantees, =
though. And We wouldn't want to commit to any such</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; guarantees today. For example, =
simple page migration can split the folio.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; Allocation failures will fallback =
to small pages etc.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; If you need guarantees, use =
hugetlb for now.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">The reason why I want to use THP over =
hugetlb is actually I need reclamation for my</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">workload :). There are many processes =
in my workload that need 2M</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">aligned memory, and we want to reclaim =
them back automatically when the process</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">doesn=E2=80=99t need it. But hugetlbfs =
cannot do passive reclamation from what I</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">know (except doing active madvise my =
the processes themselves). And using THP can</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">easily split the hugepages. So =
that=E2=80=99s why I would like to add a certainty for THP,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">and use THP for these processes as =
backend, because THP is very well integrated with</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">the swapping and other filesystems. =
And from what I checked,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">it seems the most common case for =
splitting a THP is COW and swapping so I am trying to handle</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">these two scenarios (But =
coincidentally, PMD swapping is committed in</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: =
normal;">https://lore.kernel.org/all/D3F08F85-76E0-4C5A-ABA1-537C68E038B8@=
nvidia.com/</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">a few days before, which is a great =
implementation :) ).</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; The effect</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; we want is: after some =
customized setup, if only the system has usable</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; folio, and the virtual =
memory alignment permits (or we setup to), we can</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; make sure we always use THP =
for it, the system will never split it except</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; the user wants to do so.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt;&nbsp;</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; This patchset is about both =
two things above, firstly we add pmd level</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; THP COW support by revising =
the code in do_huge_pmd_wp_page, we added</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; &gt; switch for it because =
different workloads may need different resources,</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; The switch is bad, and we won't =
accept any toggle like that. A system-wide</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; setting does not make sense for =
such behavior.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; A per-VMA flag? Maybe, but I =
expect pushback as well, as it is way too specific.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; So we'd have to find some concept =
that abstracts these semantics. But I expect</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; pushback as well.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; We messed up enough with toggles =
in THP space, unfortunately.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; Also, anything that only works =
for PMD-sized THPs is a warning sign in 2026 :)</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; You don't really raise any =
concrete use cases or performance numbers for these</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; use cases. Some details about =
applications that use fork() and rely on such</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">&gt; behavior would be helpful.</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Oh, the reason why I added a switch =
globally is also because the scenario I mentioned</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">above, I want those processes to =
always use PMD sized pages as back</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">end to make sure performance. COW is =
truly not that common like swap out/in, but it</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">can happen sometimes and can harm the =
performance for these processes. Setting the</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">System globally is more convenient for =
my situation :).</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">I don=E2=80=99t actually have a =
performance test set in workload level right now since COW</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">doesn=E2=80=99t necessarily happen in =
my workload, it just can happen sometime.&nbsp;And the workload</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">itself hasn=E2=80=99t been finished =
yet. Pure performance comparison between 512 pte COW and 1</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">pmd COW is easy, but I guess that =
doesn=E2=80=99t have too much meaning. But I think maybe</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">PMD COW can be a more common case in =
the future? For example, maybe pmd level KSM</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">support? :)</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">And for PMD-sized THPs, actually, =
I=E2=80=99m also considering adding more support to mTHP</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">If the upstream consider it useful. =
And also for pud sized THPs also. :)</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">MADV_DONTFORK and MADV_COLLAPSE are =
nice and great options :), but the former one seems</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">to be a little wasteful :). And the =
latter one can greatly solve fork situation, but</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">It seems it can not solve the =
situation like pmd swap in for pmd pages mapped by</p><p style=3D"margin: =
0px; font-style: normal; font-variant-caps: normal; font-width: normal; =
font-size: 13px; line-height: normal; font-family: &quot;Helvetica =
Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">two processes. :)</p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal; min-height: 15px;"><br></p>
<p style=3D"margin: 0px; font-style: normal; font-variant-caps: normal; =
font-width: normal; font-size: 13px; line-height: normal; font-family: =
&quot;Helvetica Neue&quot;; font-size-adjust: none; font-kerning: auto; =
font-variant-alternates: normal; font-variant-ligatures: normal; =
font-variant-numeric: normal; font-variant-east-asian: normal; =
font-variant-position: normal; font-variant-emoji: normal; =
font-feature-settings: normal; font-optical-sizing: auto; =
font-variation-settings: normal;">Look forward to your further opinion, =
thanks!</p><div><div><pre id=3D"b" style=3D"overflow-wrap: anywhere; =
background: rgb(255, 255, 255); font-variant-ligatures: normal; orphans: =
2; widows: 2; text-decoration-thickness: initial; text-decoration-style: =
initial; text-decoration-color: initial;"><pre id=3D"b" =
style=3D"overflow-wrap: anywhere; background-image: none; =
background-position: 0% 0%; background-size: auto; background-repeat: =
repeat; background-attachment: scroll; background-origin: padding-box; =
background-clip: border-box; font-variant-ligatures: normal; =
text-decoration-thickness: initial; text-decoration-style: initial; =
text-decoration-color: initial;"><pre id=3D"b" style=3D"color: rgb(0, 0, =
51); font-size: 13px; text-wrap-mode: wrap; overflow-wrap: anywhere; =
background-image: none; background-position: 0% 0%; background-size: =
auto; background-repeat: repeat; background-attachment: scroll; =
background-origin: padding-box; background-clip: border-box; =
font-variant-ligatures: normal; text-decoration-thickness: initial; =
text-decoration-style: initial; text-decoration-color: =
initial;">Best,</pre><pre id=3D"b" style=3D"color: rgb(0, 0, 51); =
font-size: 13px; text-wrap-mode: wrap; overflow-wrap: anywhere; =
background-image: none; background-position: 0% 0%; background-size: =
auto; background-repeat: repeat; background-attachment: scroll; =
background-origin: padding-box; background-clip: border-box; =
font-variant-ligatures: normal; text-decoration-thickness: initial; =
text-decoration-style: initial; text-decoration-color: =
initial;">Luka</pre></pre></pre></div></div></body></html>=

--Apple-Mail=_29DC8C7B-D576-45CD-A759-75360BE2266D--

