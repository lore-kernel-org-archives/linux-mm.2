Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A30606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fA/vhGip
Received: by kanga.kvack.org (Postfix)
	id EFDE86B05B6; Mon, 26 Oct 2026 06:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEC36B05B9; Mon, 26 Oct 2026 06:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4C86B05BA; Mon, 26 Oct 2026 06:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDF396B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:44:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54F07406CF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:44:34 +0000 (UTC)
X-FDA: 85364443668.24.96A48AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0EF8A0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:44:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA/vhGip";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZT3sIrPYsLf4bF7EjJfBOJes6yXJ8vu8pSt2SltAhV0=;
	b=spdSmWtjbE9GsjMdPEDJXcaG0tRIOjcr95CLwt8MWVI6WShszG0rM/lZDpqEBbnGFlkOba
	FyaCdvslkDXHs+BIw4UqxugdY5YZuzyUMEUjhgIn/3lq3oeHrBTIqI/E1gxEQPrpQ8eYSc
	ZqWdcBCZ8bSqdLB23vGMI8L3aNHTIUw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA/vhGip";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011472;
	b=42ep6ACwDJ/Vp0QxgxzuPpcOla25qImiuIXWwGJi8Xi6FBZOgSltIGk7kmp5foflEsGfri
	NGvua/BkSFuuKfPRijHyWppH34fhAzkC+UtwEfJp+l/NqLMdTDwKq9tD4JxWxEMAwGFXLO
	heGYDPvroXiWh7AIljMoKC6v3TdNcUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA590600DA;
	Mon, 26 Oct 2026 10:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367B61F01825;
	Mon, 26 Oct 2026 10:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011471;
	bh=ZT3sIrPYsLf4bF7EjJfBOJes6yXJ8vu8pSt2SltAhV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fA/vhGipLIk1O8gOBsJtkkVVYQX814G2padlR/E3QpRBcK9Qi6+HvZ2ExCNOfCNwa
	 rwu46EGB1Ig+KgwWwFAMn3XSlehwoSFnKuXERVlXj/MT4cMi3ci5SHxxU1xSaZq5F0
	 JA0Un8J+PEVjd8yImOpT2z+oBDU0Xb58usskbKjW2GmBV/vQ7fOEHmyEU++MBHHBIc
	 qc9BcyIsbAHuACLSyGoxZaIZBwYVH+BNpEkIO02v5yPrxfepNl2gd5BKGOMypn3Qg4
	 Pipvea0+AzWp200ETgLLs/fltu0GJ/fJTJXimDKzvaxXG4JtEw7QNt4dOEigK2ChW/
	 8MaEOASm4t+Uw==
Date: Mon, 26 Oct 2026 10:44:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, Colin Cross <ccross@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/vma: write lock source VMA before duplicating it
 in __split_vma()
Message-ID: <at8u8H9dVRYLJI5u@gremlin>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
 <20261023192627.yj5ltdj4fjzydblp@offworld>
 <24bb4c36-730c-4f04-9cfa-be096d4da9a2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24bb4c36-730c-4f04-9cfa-be096d4da9a2@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0EF8A0006
X-Stat-Signature: 7dmkhy1dbxt1hyfarx1u4qnsy3iktiac
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793011472-148672
X-HE-Meta: U2FsdGVkX1+0uLBvparPDXE6GgB2i66qtQCxVoadJxHBwzcAk9ovEpaTyRRZmCq3hTbpH44Yjoe+2hvzvZ7s1CiV3tzKljxTDnM6bdhht7tsuPOv2HGf10pMqT/6sJyEz/LnablDuE0ACQ9IfYxsPfvpD8zYz6ZL8BQnLyOIjh1gDm39hjAzAQPh85AbpAGb2CiTmW5TjW+TUmgAFX2cC5kg9qCM+MTL9491Y10DAqrabZISFoKNpkTlBB6dZHddcuvD7Mi7T+KFqGXUQU7+IOtOhCB644otkzYukWFLBGlui1Cll3tSY2jazOiUfKv1j4TvDFfhxCkB6BKhj8yRXskr89qB8cISu3LSQmCU9+jANRRdXv9mQa3BvshKRTiXXcbWjMJLWSKfP73IWciuqv23/GUjEyauq7slZ+WqZCH3NovRHA+vVhZ2og6cVRDJliD8G7z7h6i9PVoh4tPDJdEIWN9OxyQhhPs2p0NIiAd4LO2N8tMPUfzjDtqE+yLdl215L+9Fg1GJL2RD1Yz/pSF9QM5msru3YvYNEngyFVlZ8D/ZijEnvZd9gcMCjbyBbDfwsXxVLr2KfJEgy7qtqmI7n7H/8dRhMAzI9ZtWIG7Wl4MhBcMRRh1qMq4FiUX2SNXZwqk2yUmOmJ8JHGrem5rE3dHUdbGquyFqcD4Vexv0dH/GHjea6UD3C44aM64YSkihL9RZ6eIjvacDxt7ceMfh3DXaIsZH329u2tQKIeeOVoPzL58mEtyb6V7LOwSfTITZXsD7QUSB9zDPZZLQ+fCQrS9WGcLfhstVITEze0LK/OHpbPqBDrDALFc3tLRxTRaWihfeNYYQhOUWovvGGtRMpAo4cszNfrFkkGAfSX0KadVKOAV6f1cmBMllH7A0WiKEyHZbRyWIkh+t1XtAMP+jy3kEknhf0CqL0a4nZd1cxizziH/ziP8ZflOsXLhphe/hGsIbrDD/5Y1fFDI
 nnhOmjqC
 8kC00amuIb8wknYdq2wrhecJFNPCVbrkkxTTxJmPSjYbiRgI9BaHPZBuZCV4N+osv/2mlP+EGmgUSReLv8r7mAQlFOtOgiEJ42nG4FPt6/iV0tLBzirArtPlPTC9NOX514JYifd0Dw+pz3CzF8bBLsP2AWfcyvvHHq2ws9Cl5w1iDGwwZF62xb2j7xzaRph+dctBswZxbQ5hiGxymLA14sKOciyWpUI/E+Y/ppveNK7tF2+FsGzc4sqIlNXaC7Ze2mvJLXolVVKu1uOjZ8Eq6octkY1Z6F4N7+52ymSfPF4zw0Xc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:42:40AM +0100, David Hildenbrand (Arm) wrote:
> > should just say "stabilize atomic VMA flags".
>
> You mean the s/stabilise/stabilize/ ?
>
> I guess that's just the (uncommon in the kernel) UK english variant Lorenzo
> tends do use.

King Charles dictates that this form be used ;)

--
Cheers, Lorenzo

