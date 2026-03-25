Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CBC106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D465D6B0089; Wed, 25 Mar 2026 10:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7376B008A; Wed, 25 Mar 2026 10:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE54C6B008C; Wed, 25 Mar 2026 10:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4B7A6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:10:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E6DC14095D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:10:29 +0000 (UTC)
X-FDA: 84584770578.19.406C1EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 677C980011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:10:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CcF/cFqA";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4pwsmyanlNDAVc199GO/bLHEX9c5vCJTQZuiHhG8gQ=;
	b=XodO7uR86sSrO4/aOVpjkMP3/J/MFBpbnahp9k5Fn7N2PTQsfsbtUdotM+UpdkFMqh4L/b
	dpjX1LrM98+k+V8oX0SVGEU5ovOYy1IVb11bb9mgKW73SNWnc/b3p8bMCCmiMDpFT6V1rw
	PTpFfIzJipiJGabc4WLj36nunUclYi8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CcF/cFqA";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447827; a=rsa-sha256;
	cv=none;
	b=agI67UX+UqNGUcdPWcPkT6O7DD9GsEpZb8rTCENYde3LzNU6+eIiP4mZ0uWbr+3XPS0mWX
	HBiU7EyGb1uxDm8svZ1U3LmppyZ1nxuKPDTQBKVx7DV7KsBWiczYBEcm2oF/oK/AIPgOzj
	NoCaQCagehiwH0yK+7U7z4onMLhlqW8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7660341513;
	Wed, 25 Mar 2026 14:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C2CC4CEF7;
	Wed, 25 Mar 2026 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774447826;
	bh=j+9XRVrfFaG+hzCjGNEprbRdCLP8evJg2yIG9r3fY9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CcF/cFqARf0VuUhI7Y/Pt9slkoRqLx674TxnSdmyHU/puzVrbNwnd3VXHJgeUa9W6
	 419nMt72rDHPd5p7sN1FkWntwtoHPMuFe5879CchUb3356LArWQPPU1HHywl/oIT6m
	 NFvrmCv71j0R4VtxhZ5scVhEvD39MMx8U4gadelKRQdKHzBVLjjaX609KhW6vBiKa9
	 oKeYAxpU00syBdrNlI4hmPAXFUKbOftolNHzF7rTzWQ/wr1yo8qj5oefDFRyNOfGnE
	 nzctTlDEXeE6bvAL+hqqJfE2SF2obHRaKUv/QTnULqqhNiLmfN6fsrZ0ls1JMezJLl
	 xNHWza5UwVNIg==
Date: Wed, 25 Mar 2026 14:10:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 677C980011
X-Stat-Signature: mumyssfe6yy4wxncmxh4fhhwgw9r4hwf
X-Rspamd-Server: rspam06
X-HE-Tag: 1774447827-405609
X-HE-Meta: U2FsdGVkX19pCFkshDD5zUoxWqqUWijNVKSMcjhSsHGwZ7PyVMYwghT6W9fOATYyQ2CHqwNvknJuAaes9ic1F9WjlED+CjFlTeF8tLvUU2l8hbxRTm5Iv0AJUFyjEUmyDybEl6+kL5wJ0lCfotfxa1nYFhItkydoKe6Dp2wSdA4QiM/WBrv2n7A/9TQDKafQ2MLDAsokuR79VgJx0ybVLMsgG2v5er7GVv/K9dumHphgs1A/Dg02R2rzTDKXkZM/gOOTRAIzEjJoqcr+oGfd9sxoYKxPRIu6Zanp73sFrg/a9wIf2VxBzMxex8z+/f8HaYgJjm5ZEC779XgOv+Wj1rz16ffx/SHACVKX7CYdJxHKwJiDeAtt54sg4vQNQzMQ36VNC+BOXnmSnP+s4kw32kBwoiGKYURctAw7iT8ipdy4+ldQUKS1YvCrICeyJB2G3ZU61zV7bENYFKYtj8UMty5HB6ndPx270xZSz4TKkbuYNrZr9aj6zb5D+thy34SDeDMRr+Fp/y+NrjKqgwb2kO5pOzupVhy++e5Il/+NwbddwcZVqzF5hEsBdZ+V8syEbBcqibDK/iINlhKAF/7jo+WiIfe+ou1Y084iN+6dE4SpE/PRwpMvR9APIcFoGh9PHDjMYeaTOBeso/7c//CjL1eq596bJWkjx7+qcFBEaubsuxgeo9kQNFT+AaS31Yd0x7SQw2l0sTtpgDDsxnLqOkrUU5JwpAGVxP3yBzZdZQ2FUnVw3MgNQhm6c+emzyMuO31BoKXpGPMQ3heG5Sb7bOI7X9of7P3mDGQo9/3Q7R/cys++tm/Ukqoq9AwAoRx/5Vq22jjmxnJDrWDbbJaSqUyXPWS3KfUKkaaX7Rk/vNd/NMjT8TyZ45VavxPLa1RPdbqvavn6ciUKuPSU5UdZL5Lx0WIXb1gKcMbQoTnG+JB2JWTvOz7HJYacyEjAIYjSE2R9iAzFZATLar9e/E3
 lurhvPPZ
 kKExPdPpzCI83LP48pB5YjqF+J+PWC2B0PSrZS32KZb4QPNDm+tP5RxW5lE+a0V7wEvdw4uE9O3B53+LVacDIXmpgP7Yy0EFl75UW6W2hmSGY89LXBsvhgZSkiMvlO3HR5SaQRhLpl0+yfC0WRIsLLeI8qbdtREwQ+owCmXoEM/K8aStHOTVntiHyd5mVSw+KQ4stB4hPC+V5HCIXGGmvudW5fgfxCvbU/4F1L97glJy5nSJXOt3d5Nu70LARrJUfXrkfLDO2edaV8AnkUJ02in1E+JbVi9Nm3L9/b0A9MLItWHSLG4Ndo2QxeJ6qlxFVakv0XCQoUGDDsnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 01:15:24AM +0800, Vernon Yang wrote:
> On Thu, Feb 26, 2026 at 11:45 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 2/26/26 15:31, Vernon Yang wrote:
> > > On Wed, Feb 25, 2026 at 03:29:05PM +0100, David Hildenbrand (Arm) wrote:
> > >> On 2/25/26 15:25, Vernon Yang wrote:
> > >>>
> > >>> Thank you for suggestion.
> > >>>
> > >>> Placing it inside "struct collapse_control" makes the overall code
> > >>> simpler, there also coincidentally has a 4-bytes hole, as shown below:
> > >>>
> > >>> struct collapse_control {
> > >>>         bool                       is_khugepaged;        /*     0     1 */
> > >>>
> > >>>         /* XXX 3 bytes hole, try to pack */
> > >>>
> > >>>         u32                        node_load[64];        /*     4   256 */
> > >>>
> > >>>         /* XXX 4 bytes hole, try to pack */
> > >>>
> > >>>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> > >>>         nodemask_t                 alloc_nmask;          /*   264     8 */
> > >>>
> > >>>         /* size: 272, cachelines: 5, members: 3 */
> > >>>         /* sum members: 265, holes: 2, sum holes: 7 */
> > >>>         /* last cacheline: 16 bytes */
> > >>> };
> > >>>
> > >>> But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress"
> > >>> will be counted, while madvise(MADV_COLLAPSE) actually does not need to
> > >>> be counted.
> > >>>
> > >>> David, do we want to place "cur_progress" inside the "struct collapse_control"?
> > >>
> > >> Might end up looking nicer code-wise. But the reset semantics (within a
> > >> pmd) are a bit weird.
> > >>
> > >>> If Yes, it would be better to rename "cur_progress" to "pmd_progress",
> > >>> as show below:
> > >>>
> > >>
> > >> "pmd_progress" is misleading. "progress_in_pmd" might be clearer.
> > >>
> > >> Play with it to see if it looks better :)
> > >
> > > Hi Andrew, David,
> > >
> > > Based on previous discussions [1], v2 as follow, and testing shows the
> > > same performance benefits. Just make code cleaner, no function changes.
> > >
> > > If David has no further revisions, Andrew, could you please squash the
> > > following clean into this patch? If you prefer a new version, please let
> > > me know. Thanks.
> >
> > Do we also have to update the resulting patch description? Patch itself
> > LGTM.
>
> No need to update the patch description.

I will take a look at this (sorry for delay) but general point - while
fix-patches are convenient, they're incredibly anti-reviewer.

I hope at some point in the future we can move away from that so you can look at
a series on list and know that what's shown there is the actual patch.

As it stands, I can't go line-by-line correctly here without quite a bit of
additional effort.

(Not a criticism of you Vernon just a general point about mm process).

>
> --
> Cheers,
> Vernon

Thanks, Lorenzo

