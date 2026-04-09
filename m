Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A99E9DE58
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403456B0005; Thu,  9 Apr 2026 03:36:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4426B0088; Thu,  9 Apr 2026 03:36:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1546B008A; Thu,  9 Apr 2026 03:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20CA46B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:36:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65D221A044F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:36:11 +0000 (UTC)
X-FDA: 84638208942.13.B6783D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF3D7C000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:36:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4jIiKbb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775720169; a=rsa-sha256;
	cv=none;
	b=sE/JRHBm/tZbPNpCOuz/ro0qio5eMlkZEQ+CBwUOwm1iGb5Uj24y+D+JbKhMBeIfXfX76l
	rHMdx71ymX1yp6vKDpLqio6XpD620xIgJFs3l+nbIY7J/V+++suKwcg7vfC2EUerpTnd7L
	rtgYvTDyznchoD3udo+OBHhQY0hQmVo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775720169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=briQCaY9uH7vIRYVKSDxcvroZBPJ2CIodNJu6UDH5EU=;
	b=8AeDICfFf6OAeh473bWzMWv7Xcro/vP5b+AGsQ0Q+GMceT4winxUhabAYMiLMuyzidyjxv
	t8SxhFcrG/12zhYX2nk+ib7aob/7stFIneru3IGsUZIhaVWPemxu2AhFXktm2SbXw+07f4
	/QBC8tu5fv63DoWJW7INeKld3xh7/lU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4jIiKbb;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3672760123;
	Thu,  9 Apr 2026 07:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B990DC19424;
	Thu,  9 Apr 2026 07:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775720168;
	bh=briQCaY9uH7vIRYVKSDxcvroZBPJ2CIodNJu6UDH5EU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D4jIiKbbdSXPmsGikexUvR5ryZm6GS5ahpuWztmVW2V+zsifytIQVFK5eQHYpNd1r
	 Pg9U4tCS2RKGTkeLCrzDDs2x0plWBjGn3a/3iM4FaYw2D3hFrnDwwjNiRqTudf2OFB
	 JllnHJ1LFHd+w/k9NMqXF4sgtndM4Vd5SUkhtRoS42cb96PIx8yQ1RduZ1zhBo8qTu
	 sE2Aak3AaKGmalo5Saj9tYZ0tndaYtQxvgAfSom0yI9uGjKLBRywNbfiL2p4kToPcn
	 w/z3X6iR8SRlDrwPap0IiuY4/fcXcJm1laxpLdSDbswKlxA82LVW/16l2yvRoGHi6o
	 c6BMzkwr9VgOQ==
Date: Thu, 9 Apr 2026 08:36:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: ye.liu@linux.dev, akpm@linux-foundation.org, david@kernel.org, 
	liuye@kylinos.cn, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Message-ID: <addVRdpQRe6KPSX6@lucifer>
References: <20260409014323.2385982-1-ye.liu@linux.dev>
 <20260409031242.91778-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409031242.91778-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF3D7C000A
X-Stat-Signature: yzd68ymrkfi66m6ewh3e9fcrfjgdguis
X-HE-Tag: 1775720169-629068
X-HE-Meta: U2FsdGVkX1911Wlbp5mzOFByWYdvDPiz7IaTSh8iZQ94ZbCCogxq9ejigbUSv+6fuMSfx2EL5SZbPiZ1WfDHggSlzuB6sopaj8nzEtrcxawrpV+C1OWI9x355uPLSz+RuOjy65v3PNT3fc5j2p2SfG2FlJ5Y82TVJXRReW6YPzYOf+a8rqCnkfnz/Qcb9rjXbDMTYJyFPk5uHYVa34RcjlLfU13l/BL7ly2cfOaZkcuksbNuKzXxoGU9RFKt0Iu+feCK8QokAIlpiUSHj7zOjKo55c75Dx2XMqZuOf76b4J6kDXfkfE/GNL76wi8wqeFe5dz1zLMhN3XTjzMp6pnPP2OKhO2tPgY5IpU8KzxTcdI6KJKms4IbitENH8n698xYXU3GaxOhTk2XfjxtD2TblwmlwbweklUPixac5Wf/L/+dDR+MB0uKi69+ItJhgMI2IB1jrX/1M2eHea8lAQEeAsPuS+qj1hAnow2S+gxyTlvenZsY0GNHjxanqV1qv6GRf53VKxA989c8Fwhj1irMnrg3iznEdXQwjX/oaGcX6C54YAwOkxpmeiHV60ILWJFbE56jtROy9Mdl+67zNrXkv5pZ1YSzKl2ZJu+5PJfs6nEdbhjeNg00KtfuU7diqjuuXDqisuRN54YB+7X1eaY6Xi6GTtngg5e0xj9aPyYpcKTmNQSdAQbNesFGHgTUIzJjXOVLkvnsDFO/c5mznNJ/dZY+G23UqNEAW5jaKVGYtKnBh8tZmtzLgBeLqyJ1iXMxZGEWrXBk1KmR5WGrPsV8A9oZ+ofbQ83/Wxa5PKjnFtErWbbS77dp8HbYpoMVUzUZHCoU0fDOUCDcXDGF3rUbkWir2oElhCCyje4luSZE4VWwF5m4xVWoAk0eSg8bQThrhNiVL02cazPIBFmtMiB+ClqUxmh+uT5NLWjiAA0AmFZDRstCLzonJ73S/VQuH/8Z9DqTVNy7uDmmXpyXvk
 VRIjbBBI
 KE3GG7Z3z2Y9P/HCzoYQGzo3DNONdIVCIkX//Ql+2/A2/TpX9euC5GuvJhxIpR1HDWfMZvzPrkcqzN2yQbZQzywUcMNYLi1g0qXirXL+21JyYy+fyC9yVirVby3h/FQVkFQzV0t0gOclRo9XIy+3ubyvwS7MTb4zxnc06HQOmG7kBCfOFJ7pl1ecnHoZNv1h44iXMoBa5fTUZtNATo1X7Vf7/pkxFo1VsAKcUgbkseO8VkiJpV+odvGUhHBpaZYfu59TU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:12:42AM +0800, Lance Yang wrote:
>
> On Thu, Apr 09, 2026 at 09:43:22AM +0800, Ye Liu wrote:
> >From: Ye Liu <liuye@kylinos.cn>
> >
> >PMD alignment in khugepaged is currently implemented using a mix of
> >rounding helpers and open-coded bitmask operations.
> >
> >Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> >alignment, matching the preferred style for address and size handling.
>
> One more spot in madvise_collapse():
>
> hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>
> Maybe switch that one to ALIGN_DOWN() as well.

Sorry to bikeshed but I'm not sure if:

hend = min(hend, ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE));

Really adds any clarity there, possibly better to just leave that one as-is.

>
> And there is also in try_collapse_pte_mapped_thp():
>
> unsigned long haddr = addr & HPAGE_PMD_MASK;

This one's fine though, be good to also const-ify haddr and end there.

>
> Just a thought :)
> Lance

Cheers, Lorenzo

