Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E747607884D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9CQocWC
Received: by kanga.kvack.org (Postfix)
	id BFD766B0299; Mon, 19 Oct 2026 10:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF7A6B029A; Mon, 19 Oct 2026 10:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC46C6B029B; Mon, 19 Oct 2026 10:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 945476B0299
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:59:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31AB31C4075
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:59:33 +0000 (UTC)
X-FDA: 85339684626.17.74D1A62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8B71100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:59:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9CQocWC;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421971;
	b=Xrs5qpCwA3ZIRvZKsWMs9WYFigi9eCEYKbFEJNUiFB+cmptOUkM3dy8yHP1imvTBvi9YRq
	WF8HxtlyE5HS1croYMNokBzzfgr1WTLyNRY7JH8SV8a3xyvJpeHkmHn3803QOrSHO+xe7u
	6Z/ifhPTTzzxfp3k0OgPJMw61qEUbDk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9CQocWC;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yve0cUum9UQSEKmMOgKb9cO5F5O72C97ZH6SJDHLlwk=;
	b=Q0LXeqli/F73rfiYAsqW7g0y+PDYoQSFjF/ug8c5ztx9X5tIJtHygoopwO6az32pFVPKTp
	gYFNhchrSUOmT3XDk13ThSeqYsR/xchE0N7tqat9RH7XG28sz5YX9IcTAmFuSgPbNxy0zb
	ql5NMocvnrUwAllo9yQFa1PV4J4M4IY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38F7060210;
	Mon, 19 Oct 2026 14:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEAD1F000C4;
	Mon, 19 Oct 2026 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421970;
	bh=yve0cUum9UQSEKmMOgKb9cO5F5O72C97ZH6SJDHLlwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d9CQocWCrg1MwkPcNEJMJTPoYIufvaWwh7pFHAQXpkzVF3uzdXwg0HLcq8QO/UDoJ
	 nYY2j6wFjSjqMNiiN3eIkKE7NnxlOhm9APJcn7RdKsXPOOT5TG1w5B0wrT6xNjF/wJ
	 WCWmur5wo5pI3OXmNZB2/p/GW+5uOp6ttTsAiT1G4Vzonsno5y/unM28H5i7aX50hf
	 lKJYk/asfEKtupqvgScK8RG7GL99tx3n+2zhO8A4lKTO8Fyci2FsQPnGxuYX91GeH6
	 4BIRhxBT2CiXQwwovFJ6ZeVFgN+8oZFsXegfZU2Jqp5FHsYjUU2vDIAfZtcnSYSc3r
	 5Fnq961JIFrBg==
Date: Mon, 19 Oct 2026 15:59:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: Re: [PATCH] mm/mremap: populate calculated fields in vrm state
 correctly
Message-ID: <atYv-s4dz_UD4YXJ@gremlin>
References: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A8B71100005
X-Stat-Signature: jjhmhtjggj7wqt3oegysuni4a5m9iqfa
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792421971-534667
X-HE-Meta: U2FsdGVkX18QiF6ZmNbZ0LiAfFtmCLmzL6+oHIcCasPVOEny4/rmj0eyEqd5MBNZRMohpVr2K++Pv41L0+4chx9qu+fmW7OeNAfMZpjGdXe4WlT30rYpsiIq355qwpGI6/D+K/w1F09qfs5UowUKdONckobqVR/FkMVRpcQSTXxpemRBhgeX4/JoWzsVyAAKdTjunrRDQUPmuLuUX0s5xvsBlF7/Yal6O3CicdxZ2O658yXxu2sRH2OPOXNuEZpruBrXmKRfuTp6kpA6Vp44U8sH2EJWXDUyNQbI7u70Ji+p7EEe+hYens091pxY3tYzgxyOygMjuJYKahLzYYGI+bjLfMc05mcYTx+C4lA6E9oBJaeIvB9Rf2WgwOa8vQuF6/QeC7eVm381aKr/aiNt+nYHRQ5rU4Lu/YBfZLPxnkebREkSiw+LahnaMR5vbhzTHQ7rWu7xCb/uaq5Ikeg02yRhUj2mzaeH+El4kXdiFm8sr3hnOzxKH2oylWiy0FDoNwloWqmBWJlbtQpNiF5VKMNyMojRD/+Wpw+WR8f1q1mmPlF8WTJl90vVMkp6C06Zq8IZ8N6L357lz5QtvQzMzr1SxNF1r0eg+w/IpqukX3iXnjqM5qTcjw2aHh0lREs4m0uWFN4RaMgW9A6dpB/R1hwDEW46J9FPcG3Mpziv+hfl5qdoNrwnaASNUS5n0x6BQuqBOHEOQO63sc3OEsagOjTuj0i+bzEUWy6UZesNc/6d6r5NXzvpxuRLuTNpCIhOcGo12jo7jHVdCTOnkhHazOwqVtDAxHP6ccGS3pvPljhA9BPu5GafqrHx4BgU8KDtjIQbGsE7O8BhIPFM1AB4cC4vMyG5edyhZCKnES/h8oQuxr6X9YExowd/buFJdT+87tJ02Fk5nvtXEDC3HRMbYdDb7vUmsVzZYJiZ2jf0h86dJkG9h37CqjW60HaTKSOUiN93fUk6MGtawQrchjh
 vsBh34u4
 Iknu4SjsEbzNF9+qhRpp2KR5rExnX8P0b42THy7ddgYWWLAgtHRQ/SfuSe81iQF/CEbeTne6IEtOgD4yx1eaii914AJzfTJC3QSsRA49BTD2z1G1zfu7CcJU2X6b33Hsm659ceeN8fKkNGrGVQFynqBoIp2jKc8RKOfKRblIzIVesdrB/Y8r1MNUkDRYH0kHPI8BBvUEXY7EYtshQHVV1JWB1nRxVXuwTujmxDWuaAKyHDw1NxJoW4LENHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 03:28:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
> introduced the vma_remap_struct helper to pass state sanely through
> mremap() logic.
>
> Part of this state is vrm->delta - equal to the absolute difference between
> vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
> respectively).
>
> This value is used to correctly charge accounted VMAs.
>
> When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
> having performed the shrink of the VMA first, prior to any potential
> move (e.g. MREMAP_FIXED | MREMAP_MAYMOVE specified).
>
> However it does not recalculate vrm->delta, which results in incorrectly
> overcharging the VMA.

Andrew - could you update this to:

>>
However it does not recalculate vrm->delta, which results in incorrectly
overcharging the VMA when both moving and shrinking a VMA.
<<

To make it clear that only when you do this (rather unusual) action do you
encounter the issue.

--
Cheers, Lorenzo

