Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E970C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6817B6B00AD; Thu,  2 Jul 2026 20:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6592E6B00B5; Thu,  2 Jul 2026 20:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595E86B00B6; Thu,  2 Jul 2026 20:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6A26B00AD
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:21:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01F688D58D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:12:39 +0000 (UTC)
X-FDA: 84945539280.20.1A86DC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 14544C0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:12:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tb50A/dS";
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783037558;
	b=NU9QXTP/mE0Mz/wRYDGVI4JMufV3IVITBeaqguitr9y+ZuRjDR8iiuTAmIxjFTvFSIsQnA
	t+CAnd4tgKGmW4LTG5F5zSqUOv7tKZQQHMnWsiwqfBVtzpK4UVpdDSmOnP+l9xkZhI7kZK
	ONSfBX4jRKnTKfij/DYiTM30cwx12cs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783037558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LN+VlUU64xomiYlQ6F7UHxeiqMWSdTj4VlmHCeuMCOU=;
	b=Itx6dQTur8+FlgfzqqeeTlDkGOtnNvUpddbhxUaxqoLCh5ev1ap2A+c80I/dX3dOg1yMHG
	3uEiOAsgL2fX9kuRgY/3zV1CFy6W7UTzIU/YzqVcvgU5vaHqGEtfH9ky7fpp7+Cl83CmlX
	86hsgZQKlOOQNxD39x3JiXIgGTykKdk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tb50A/dS";
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D24F439D6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A31F00A3A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783037555;
	bh=LN+VlUU64xomiYlQ6F7UHxeiqMWSdTj4VlmHCeuMCOU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Tb50A/dSC/k2pIa1weRNyRhz4UqXgCqbnRAJFYl6rFeM03LYZLcfVJ7qoJ4A/2MG2
	 Rr1en5rhFj93/iqH731LtZb5Vj6kSfVMxfW73fECjIpKwhICPfuHfGgTEu8iQUg9yE
	 H+ZkjumjdIc+bHeTQRwHD9hYLlNwUlKmCGD/vRRYz1GxjeaW15UJkIElIghCAJ2jXt
	 plptmVfxs569/tWn/9gQBGO9p81YKLpTDRNPI3bJRGd37DfWBg1BsK8/CpxOn8Hthc
	 pCmjIAWE+YSYpxquS7SQ1e9xK1YZjqnHBlSBenMY7MHbbxp/eSWft6MI0mw6l2pXQk
	 d456cNpjaCVGA==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ee88fce572so25194866d6.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 17:12:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrkAFbnLWYhhwzJMipB9nIyr73ar3mi7WxHVSvaiSSp5EKEJwo635pB+EZo/7NYLQC0N994vgW30A==@kvack.org
X-Gm-Message-State: AOJu0Yyz0tqfJO0t5/MIQBC5+Tj4OCm8HslIX1IQ+A06xQPGdDTr7oiS
	+N8DUN73mJYPnS6jlR3NhLZVCMAn5GgnpqpiI6CXDgr6POR/xxqIuzyd2wOpdb4Kmo0L8m8ibQD
	iRQCARceKDwlhOCj0+MsKGCmAt77OI+k=
X-Received: by 2002:a05:6214:43c3:b0:8ee:ab07:c79a with SMTP id
 6a1803df08f44-8f4236257abmr99737436d6.33.1783037554547; Thu, 02 Jul 2026
 17:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260702140257.44780-1-lance.yang@linux.dev>
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Jul 2026 08:12:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wkSrA9oRPFkWkZbym-6wK5Z-eRZWRLNrKgmO0adpWudA@mail.gmail.com>
X-Gm-Features: AVVi8CeWx1IRN45D52TTDictU96YFaU3t5miuYraMM_UyrWA1zuxQ9nndFocYdE
Message-ID: <CAGsJ_4wkSrA9oRPFkWkZbym-6wK5Z-eRZWRLNrKgmO0adpWudA@mail.gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pm4yn8cordqbmgypgxobg3jntsaiery9
X-Rspam-User: 
X-Rspamd-Queue-Id: 14544C0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1783037557-830917
X-HE-Meta: U2FsdGVkX19MXx9eN/VqakTTLGwK5FWuVU9QJxoSNnceesejSAQ9pqCV1S4dWJqqJb6Z5Ulx1K2BWzjRXJKBVMr9XdV84GgshWQncB2XqXMTSW8gM9x6N0RZ6YXBgsH3qqt23cZm6EvIpRS/0CKhqIgnZrHDONwQhzOu6pZjLPhQj80hQiuHj8gazTHfsrOYJJvpCeoEcymN0+E7sTCBQKJDHpdyUDJkDYgfjpoSH9xUKHkPHcCG47MLn9eHYmSMuQmvEswr9JGofIUzT+iw3eeNHdF5HVop69bIR8T9q5ufj6vCtHYAmiTKdiWCvNL/fJxEqsIRJ1znsROY+pbFqozPOb5kUYkKDAG/v2DFGQhRh/6E1M7Oa2Kn+xn7+x1cj9LyaW8PoAaZ2gYoNYu8rG+uqoLcX0vGET3G5flHh9cB9MHiPlyoc9Pl9EPmMjlSktxqleRjG+NSKWohrFDQr15sdQXNvIlEPf2vmEIJuVRtZA2TR7XLABDc9f3J6jh+/kt7FvS2Qu6BK/F5PuiakEPi9wlyul1XVCbjkXJCHACPMPkqkOhFk4dGbSur/pjMddjT+YOPbm472eDEBS2jpq/PMCEtyFPJ3Pz8JC/mrHo2FwGaBsG14J41mFzu8wd0w6q0J9IjKbFGi3eL1i+4/meKNKhATPGQrdqX2iaW6GFXf13703bZSEMMaAmeB6+qQFtWQ/oxG+YlC9xCFyQzF9NWILZFvGu1kU1qtrWfPFNYIj13hqM91LeeW7JvlXmvjzeJ0vgaPnIjlOouOzcFIXG91G8Dy5FfQjTmrgsKqhtMsZ3z/YdJ8XbChJW3DIsX1xm1+uPubb9kS5CLWBeE6D/Hc2nXwMiLm7IAY2fksKnWLvhtbj8IOWIIGQbGhcKeTEOZeIyzW5SeihGIQyA3c4OjjHEq3uXGOPnHJ1ed8rLM7v4At/swSpTxAnQbefkHJN2w36pzPvk5uaP8Jpu
 NZpkbrSg
 kdvrZfdOTIeolGP1rs63OFFUkGFApQunSRZnIU12+g9Hg33DBLU7Nixq8tIvsrfEMactyl/wTrFrmMsjFu819Wow4gkb/57MLbomOKLlKJRMyOZ9kDwEUqsZ1QMsarpYQ6s996or0or1GkAK6/fT5vahXSV3zfDjN2MJuc+yKYgjVP8tIAdsCuUJXsVXM25M9BHiqqKbojYiPNtDtkhZYyGTGahFS3P/h3lPRYPFC4ejdvLUGqJoME6LuPwt2RW+e/yhM2SbeWZSijTs2dvg+gHobhW3ff11haQLT/7VZ25+xHJVynDidYhc9+pjxiyglmYTePM+i8o9+nal+ejpd73tncg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 10:03=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> From: Lance Yang <lance.yang@linux.dev>
>
> Usama has been active around THP, really enjoys working on THPs, and trie=
s
> to review all the patches that come in.
>
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: Barry Song <baohua@kernel.org>

