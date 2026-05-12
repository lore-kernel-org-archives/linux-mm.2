Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57042CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802DB6B0096; Tue, 12 May 2026 05:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3C66B009B; Tue, 12 May 2026 05:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2176B009D; Tue, 12 May 2026 05:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58FC46B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:31:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E271120423
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:31:31 +0000 (UTC)
X-FDA: 84758249982.29.463E23F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DA208000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:31:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOQB4kHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778578289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Tnfr8jAlEFK7gj1eDHylJ2uYaYgSHUYNxm9i9E7d0o=;
	b=SkzxURqIxH47TurNbnQjq8/u8Z9sNHioy5DARqyeCC4IwYbCQaStvPiq0u9pigSRQPeqKD
	73gN27P0bJs857jS5AdI/aUKfFA+hxYkIX9/TVSSi9n8Gp8yDUBeZ93R9m008Zq6SbZe+T
	vXyu4m/80KvQGldlJU84UWlezUPu/6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778578289; a=rsa-sha256;
	cv=none;
	b=djUiw2ZMcaj/0XX5Cv5QxtCkl9Ddp7ILDGSv+wkg/OnNcCUP5btIsuwn9SECW3wcQaiJLq
	CVKmc4/680mC2YgfslPVvHmdmb95Xv9QYhXXggLD50m19HXQQAwvVV6Vwe+FWGqh3OR4Rp
	anRJ5Iwm4FbP72TAok9pyeZV+7+JC3c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOQB4kHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1546844144;
	Tue, 12 May 2026 09:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53301C2BCB0;
	Tue, 12 May 2026 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778578287;
	bh=+GzPz+gI2GYfbiRoN2dqRZqYupazekpJJqvduzi/Bys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lOQB4kHdnMEnvNtfahCQ7KZxAsDqwU4jjBbR7Ko5onUAIT09DxFksacSN4l5ed1Ba
	 23Ama/5TI8gw7dEt3f4rEFniUPO/wEn+9yf/J4rDJ+Edu/eZPYYhF3VOwiYDth8zaA
	 R+W8Rg67C2Iul7zIbFWHemSpfmKe6QkTLsfSW0f5eWGbuBNnuwOSqSilsaoLVibA+M
	 gCwmLCX0RFbW2PQUKx0HrPZcwSxv8G8vPuoJMuZL0D5q6rPoz2f/Q5JkhA81hMWoRd
	 AtoPy2nVKKP+UUvy6WYvw6bEwQ90EIRmtpf1SGBcWUqQ3TtDVHv0QKxBqWtb9lbqkQ
	 6p+FfTuHUf+ww==
Message-ID: <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
Date: Tue, 12 May 2026 11:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and
 folio_mc_copy()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke <hsalunke@amd.com>,
 David Rientjes <rientjes@google.com>
References: <20260427142036.111940-2-shivankg@amd.com>
 <20260427142036.111940-4-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260427142036.111940-4-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DA208000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 7qhwma7ij35ojw4c6pqb81mjhbky4p7h
X-HE-Tag: 1778578289-394532
X-HE-Meta: U2FsdGVkX18zuWaSgVtll6C50MSqHIvdq3y4d/4gf+csv3veFH6puw1Y0oV2Ppngijl8w0HOHYFvIRd9PzG24FR1a2rszflPeRJEwzTKhinDpbbCmQmIckNyhGsYL9pFRsLYHdQVca7b+AwRPL/sccOap06nJc8h6CRL06Q1I/DyNO2f2rzqVQnp+sEnBbj7emLnNY92fL+qwpkXV83faZJzkxvOi5/95LK7IapMW6IQ/0C9KvnZYtBF2zXErFiBGKplpKqeGBJgqhYNES+JE2sa9YpLuOK01NYkPrscFGmYHoT0P55SgXH22s1CQ3EotPHsa0Hg9FiRXfeUHonzCy4pp2OH70+NCc1SLfIvJgC06FBnMeawrrmugYWszzZOcOFuttdx6I3MpRvLG+r3gg3KhID8tS04p8N/sRtrK/AYBdbZnwEJWxx42YH8aqdowh7mzTs9LkSNKmOmMjDq+0t7/xgsbqC3sVibRXTPWQGhXZisnkuoFYc9h324Nj24NbSJS8z/+lqPkmljJFXkss99+baMsC/TwReV0oQPkKyV79zMglPAwD0GuGbsqR8N5UdK7JCU1E3ilr7pHCAKF2KX12US7o8ykMixN0khOzNo6AvNTpvnW9fGNrfukyZQcAA5QiUDf5MAf5Z3TskvEK8yshLaBRgr4i/Ik/8eB6G6XASavzz7Kp+lzgxZ3NvgfCJG5dmBn8flr6nrDlbFd9/KzpCNn8IyqfPXygX/I9LGR/k0sxMLUg2smdLQz5mx7fedW1wf7Ktw6lPDtGTrNFQkQa7vekBeSmVjolonu0IUWy+oe0hcqhUpomiPRAekuyee+q7usYiVd0h6U2GiBlvIqJr6pHAfF7X8u7nQhQDxngIt614JT9RENofr8XqASQTGGQAfL2FvNbgJFhhWe+/rA4x/Oym2T906q1eLMPj7F+f1Lrp4cN6mg/g/m1AzHxjmmMPN4gM2IkpxKzx
 l/6BNmQ4
 FyS6UNyBZ7GxbyulGmlJ6z3kEIiCqozOeGqqtBIEXffJ/3ELbl+xqsS+TsQZM6xFQFg62pXQDilfNrT46dU1BXJ6CPXemmjX3t3Bz+70vB7aOeS7tFRkpeTBlYJB57+/E2tyV9X8syx6YyOihiaOzP3bDGskhhPA1k6UGt2w+N8Zw4eN7RpXFYBbHUDpg6zQc0hW2AHPwxZu99Z+gWAepAg8TIu8CQQzoJ52lgob8VAoNwsACPJb+Ihv7IySOPApfoksbGvvzlabZJ162X9HlavHkv5Ohn13QLtWZExpERPB0NKqOqZRAAettsiWE22rgtvCOU2RiVRokbG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 16:20, Shivank Garg wrote:
> Rewrite folio_copy() and folio_mc_copy() as thin wrappers around new
> batched helpers copy_highpages() and copy_mc_highpages().
> 
> The current implementations iterate copy_highpage() (or its #MC-aware
> variant) per 4 KB page. For a single 2 MB folio that loop runs 512
> times and pays, per page:
> 
>   - kmap_local_page() / kunmap_local()
>   - cond_resched()
>   - one invocation of the architecture copy_page()/memcpy() primitive
> 
> The new helpers issue a single copy_mc_to_kernel()/memcpy() over
> the whole contiguous range when CONFIG_HIGHMEM is off and no
> architecture overrides (__HAVE_ARCH_COPY_HIGHPAGE) copy_highpage().
> HIGHMEM and arch overrides keep the existing per-page path.
> 
> Tested on dual-socket AMD EPYC 9655 (Zen 5) with a CXL.mem node.
> In-kernel folio_mc_copy() microbenchmark on 2 MB folios, source
> evicted from cache before each iteration and measured throughput:
> 
>   direction         baseline GB/s   optimized GB/s   speedup
>   DRAM0 -> DRAM1     18.65 ± 1.37    38.03 ± 3.21     2.04x
>   DRAM0 -> CXL       25.46 ± 2.89    39.29 ± 1.17     1.54x
>   CXL   -> DRAM0     20.61 ± 3.95    35.07 ± 0.62     1.70x
> 
> End-to-end move_pages(2) throughput on anonymous 2 MB mTHP folios,
> 1 GB migrated per run:
> 
>   direction         baseline GB/s   optimized GB/s   speedup
>   DRAM0 -> DRAM1      7.20 ± 0.03     8.01 ± 0.02     1.11x
>   DRAM0 -> CXL       11.12 ± 0.15    13.07 ± 0.03     1.18x
>   DRAM1 -> DRAM0      7.21 ± 0.02     7.95 ± 0.02     1.10x
>   CXL   -> DRAM0      9.10 ± 0.05     9.49 ± 0.01     1.04x
> 
> On AMD EPYC 7713 (Zen 3 / Milan, REP_GOOD without FSRM/ERMS) the
> folio_copy() bulk path regresses because memcpy() falls through to
> memcpy_orig (an unrolled movq loop), which is slower than the
> per-page copy_page() (microcoded rep movsq) it replaces. 

Do you know what the reason for that fallback is? Could it be fixed (e.g., when
we detect page alignment or sth like that?)

-- 
Cheers,

David

