Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC3ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32FB8E0029; Mon, 10 Nov 2025 10:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4178E0006; Mon, 10 Nov 2025 10:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921C38E0029; Mon, 10 Nov 2025 10:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 81E768E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:48:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 233005603E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:48:58 +0000 (UTC)
X-FDA: 84095130756.25.FAEC8AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7807840014
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:48:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkDGoHUt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txXTSPkmpnLF9RR37284+5s6nTSt7z1v18AvQwAo6Lc=;
	b=6DP8glUpBwDgkeSZ2Viy6Bz0GjB9fheIERg0G9e3vc+NfyTCmcO121ql8FJ3n+EaiHly1j
	X+AiGLwpuFcRXs33amfHG31/6jNUtHLU47nPA3yCOZi+HEIWwxnFZiUVsGCvFhAvYg39rt
	YlY9JBfJ7u7hz3cUvS4/Jjf0OB3OATc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkDGoHUt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789736; a=rsa-sha256;
	cv=none;
	b=MkICevikkqeJjnx9Oe/urw8yizau3Dq4+czza/dMCuk+lgxFMSky/7PKPRh4dcpWd5TsR3
	/f1sq9UjPeiRnXOarDlPu6oTHxtFoNFDt4/FX0A/hilNYYVXFVltW0/GleMwPC+iCQYG6s
	TZwvtfqi+IVKZPxDdewHmyfVR2EAssY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0172601E8;
	Mon, 10 Nov 2025 15:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13125C4CEF5;
	Mon, 10 Nov 2025 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762789735;
	bh=7usNNwK1oc17KCZRQqTRb/jOrzz/mLzKHFv/CibFkeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LkDGoHUtlL8QYpGw4ssnW9I1tDmONc4GV/GO/tQBHXeFFR5yPpVf/tXZxGcf3mzH4
	 loJlkqn3ALuwlm3wFCbm2t7gFrDDJsflbmdJuICFfvXfphGisNrEYHOmy2xdHpEy7t
	 vI2WK3v9FsDIvMDCpvjbORMZTOwQjU0y6aBdWPlKagw2cMPNtMeKdjrarMqqlGWxdu
	 Eg6e6m8AWcs5/lIzTp8vTBKvNXWwwD4okmCMe/mKu91/wECnkLCk6VFbMLrA7Vsixd
	 v4TA8fDYJoPg+THe6BniVVBWlUBB93nnDgMstLqijd672t2AXdSJQDR9W+Y5EZyBY5
	 C3qs9WcXC+1Kg==
Message-ID: <f7a69885-7bf6-456b-81fe-3c6a5a29b470@kernel.org>
Date: Mon, 10 Nov 2025 16:48:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: rename walk_page_range_mm()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
 <2e48c7ffbd2ecec8ac189569636173fb44ed3631.1762686301.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <2e48c7ffbd2ecec8ac189569636173fb44ed3631.1762686301.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7807840014
X-Stat-Signature: ax554waig1umbt9a1rn5xnpnwci67mna
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762789736-127134
X-HE-Meta: U2FsdGVkX1+wJs0pV/m30F2isFywTjqs0aO+pqngq6tmugKqThyopo/pX8jFiyx8gpqjk+VzaecPI3cSRM+uPPN/+wtD/Ht6pMxnRjhMYOs8hQTEWy3+3/PQh+TGn1IVUVfrK6YWcyynooRa/L3MuYTgCloUF1xY+dWIa03/1HeUiiDANKs71+LycoWG+/RYbPjva1a+Mg1XXFGRswnKoBKrOaJR1nS09QaKyWTNtxZfrwN6h2sz1WT7ZB8q83aI9SBN7K4+alyHSwvUPwe4Imuu5LMm6WJQAO74P5SvAGKVY5/7SREZ1kfVb2B9bPGhy9YcqGTuMufgSD+pEmqN6d6elAAqv+0wlxpGcrYhHah/d9ZKk700oEldFaFwu3c2nHr082NpBsH1Tv0oj+RRsqZSHPJtMjbKp/a4LNofr4bE5/S8BII1HMq2f0BR/2Ty264iTqUHltqYta3qLfRwbCem3moTutryWd6kvXnuFj+vEaGONLPpiXRtpMu2DD+6Bxe8WuZDU8MEslxpxSr/JQGl2A8eU2V1yFrFzd8flcgQorMS93VhwELDBGVjzFdh/oLJ2+KmL+HKvqfweob7xwe0fSywdAOSYQbwQBL8zG9qh00LZXA1VnR+uHl9K4Mij7dwaXLuA8FIieiZgBe84ZHP3UQ6yAVrkrZqiCa7lKN4BCd5s8LrJkqVqIWcQQtNUOpBHXF+VoxeiXILKy9sGgV8vgfx6LSUACP3u7mVREUG7O6WQRaTsxsLUus4FN7k2x9+sZEDd+kNzR4/ZdZMAEAzkLxmTc1Q+QYnxgnocx/xxZTs89swNNcOUuNjDuPQEyolMM4+dFTfc9gmqiWfgl7VUVQtCx1FJT13urWHwD/B3DOUoX1ymnrK3At4MXsTwybDh3pMZpHlf2ch2lQng6unscf2oEjIcMzEjF3zVTRpaHk5D8Qi9SAaKNjImOmj+qyP9bmix5alfqbW20H
 tsTIS2z5
 8/IDvxftcunikVai9XwP6fgu3hdlrNP48ho3tyNykyGAe6FYiWjMYBGtTW3wG6flE0U4T623lFKA2s+y2RkYsxCa2QKGP4OV3afZXCJ2RN92A1v3xXyRXr2y7kocuCFM0na9/p6z74Awr+Her68pKKmVwnACztMlB9yazTEFUFuV/Y53MO6RhqimNchFmOdcr+LpyZFlkmc106glzu911bMawOZM1qI/giXEt23QwkJBj/AhU3W+D/BWWrfVXYeGkBUHcxHaKfHsGvdtISThXSpRnSakPbiEJkg1kwPIPsPE98rG4PLQVfVLPxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.11.25 12:16, Lorenzo Stoakes wrote:
> Make it clear we're referencing an unsafe variant of this function
> explicitly.
> 
> This is laying the foundation for exposing more such functions and
> maintaining a consistent naming scheme.

IIUC, the "unsafe" variants only bypass the check_ops_valid() check, 
correct?

Staring at the code, I wonder if we should then rename check_ops_valid() 
to something like "are_ops_safe()" [or something similar along the lines 
of safe vs. unsafe]

Because now we will have valid vs. unsafe which is a bit confusing, at 
least for me.

-- 
Cheers

David

