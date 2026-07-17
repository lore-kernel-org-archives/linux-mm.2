Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8DFC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EAE26B00B2; Fri, 17 Jul 2026 13:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B4D6B00B4; Fri, 17 Jul 2026 13:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BE86B00B5; Fri, 17 Jul 2026 13:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 495A56B00B2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:14:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF4AEA01E2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:14:15 +0000 (UTC)
X-FDA: 84998916870.26.E17EED4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC16D1C0002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:14:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XMgmXh8v;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784308454;
	b=OKw6ZqJ1IWAGUL1wGXmYc0LYxOdx7A+E80Wd5cG367Ro8ByRm+350NHvdXU0gnwQr5eJfy
	ojpaJUWiCV7fUxYO7uQ9FqUC6z9yNJubZePNoVljapFsPOF7tGqtIa/hq0vcgwK9DdddRv
	DsFy55kcx/MfongavvSpjf4EHfyLS/0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XMgmXh8v;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784308454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6oit8yhuXpcPuY80F3MemWaYa5clX84cYfxKDBIo3w=;
	b=VjPobRlrViBjDgN45VrXSAbKm552Ihhmp4uD4jm6WxXbrXyAwlOxlBC4FgACDnc64RVlVc
	kHvqrxrwXBeVpf8ggIFpRnISUjT7xnO0FBZ9Fxk2+w58fg+nhg513ex19it+TeBwr+FSIh
	QBI2Ey2NjxPIq1kxBGue5JfbyernBkU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 951EF1476;
	Fri, 17 Jul 2026 10:14:08 -0700 (PDT)
Received: from [10.57.85.89] (unknown [10.57.85.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DA383F7B4;
	Fri, 17 Jul 2026 10:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784308452; bh=fKLHwWDsT70IOS55zp9+fmUR6rNub3TYSs84mX6aGQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XMgmXh8vex+m4K9cZzlZq5WNmdeN7osWAy3/rAp/i38LfeLs3WdrJ/U9pQyVJkstU
	 krj44fzOAE2k2Jfrk88DCDtSb3O3ZifhZP16RZY6pDcDUzZfEFEC7pjIHcz6BHWctT
	 sImLifnPM3U8WdiTuuoESC7WmL5WTokCGSjsWXRY=
Message-ID: <b44e071d-7c9d-4e7e-a84d-4af3499a5a05@arm.com>
Date: Fri, 17 Jul 2026 19:14:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use proper PTE accessors in madvise() and
 mremap()
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Chris Li <sparse@chrisli.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
References: <cover.1784292223.git.agordeev@linux.ibm.com>
 <3c4d3c768ebf9cc7bbc7667e0e08bf5ad2fe8729.1784292223.git.agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <3c4d3c768ebf9cc7bbc7667e0e08bf5ad2fe8729.1784292223.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC16D1C0002
X-Stat-Signature: d9kqfqj5bjez7a564fijmhrbdd3s7717
X-HE-Tag: 1784308453-145396
X-HE-Meta: U2FsdGVkX18Yz4hI/wTNq/sJ1C7+CVFeprDFL8iR5GrDeFDRFhEOueR+92enquHKbpNkQKcYyO//vWOI2R3DIcKPzqNCOOT2nLldgpdg4t4GNANV/IbBAsaVmVFuhrQffoWjobdP5Ym+4IY8vb6H4aCAww6zkMQ7OGxpUdW4Eh4zvnYappXCntYosPHaEXVLE1FmQ8d7SCCTQoJxpEzMel+kGVHh6p2sqIJ/2J2kAzl8cOHYK1Dk72xcwDJqD06zQUr7JaQph54zFXdPv+4J+hB8X2ZnqQpDn2xOO7JzWYN/BVOxAcJj0CiEl151O5uYzen6827BxmSu1IAmCI+H+IvfPEbDGrkxGVllnKS1g6au5qz7QfLmtvoAjang7XT3kpTOXOJO36vVFblkyLTfUWOd1Mou8pDzBaR7p07IL/Os8tEp4BvQA3K/Zvdw5q5aNCp9a/yMa5OIbSdh63ECOZGmh9o6+56sPiNCD3HGQXH8aMbcd3KlK5rm8ktCTWXUv9Xb9bKfl2q6x2psMTuGMzBu+LM+PeiWI6zhQPN0eGZzcJYscMfDBkOnJVvAbLVgRlghzrq1PbqP0L8S7V1IfLNnju5AUiBLi5SFMl0n+BUo2EP5g/ebo4X934JOaP2WP+/Yg2Mm/95eaZ5av5t354TNOZojxQYve0OMRppLHiC+A6tmkx449ewfjUHyzLRC40SwiBi+kOUd3pgctk4wxpv+UQNRiQdAY7T12cZtAroQxIgeRLaVQJJU+io4PsW6iElrL/wf8+/Z1K6YvOFz8STf2c4Zwdx4BLIP6FJ30+MzKPN3Wa16Yhnh+T5+N8/A+8FD+k/FSfGG0b2h+eiJHEMwWOrxE6uwHb+1+s/BMck3PHeW/yOBKhwKiow/cceyUaX1TVU6vWm3f2advlPWZ+TEFtsjNrDexDZzzIPWv13PmGIf0Jd9IwG2LK8SAuyQ6y4sdtYf1WmnTrhlxQy
 ZE+IqpPk
 DoitdkWq81Ci5nVRDUCWM4OKzOQsAyf4bhvWOl9ILu1xwbn3Fk16TobIoA1f/V+g+b+mzsI74HU/EUqx1gg770q6HMF1N1lOy2plRSFqFoBcTsxbsZU1P10XMrpWzHcpPdwuYqS2X+zHdRkW8/Fj/SwsS/0ERzGaSxpSe3EIfu+vTo18z1ru4YhCyMZ05SaSS/xYhPWrLPN5hbGxtJIZAHgKALp5j8ELDpqiCt6BSdH3HttPvJznDH3fwAyWC2Ctf47SVNjtyiH+nuGUzM4w7JKt9Q3tZsiX80ARZt1rXPy5OZS+srlGQCB6haXh5ICSeRJogr8C4fw71+he2wmkcJx9Q+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/07/2026 15:32, Alexander Gordeev wrote:
> Follow the pattern established by commit c33c794828f2 ("mm:
> ptep_get() conversion") and use proper accessors instead of
> direct pointer dereferences.
>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/madvise.c | 2 +-
>  mm/mremap.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 77552b03d318..7d369b1ff8e5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1106,7 +1106,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>  
>  	/* Simply install a PTE marker, this causes segfault on access. */
> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> +	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));

AFAICT ptep is not pointing to a real page table entry, but a local copy
- see walk_pte_range_inner().

Such direct write to page tables are prevented by the pkeys-based
mechanism I proposed [1], and I can confirm that the guard-regions mm
kselftests do not cause any crash with that feature enabled.

- Kevin

[1] https://lore.kernel.org/all/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/

>  	(*nr_pages)++;
>  
>  	return 0;
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e9c8b1d05832..fc3b90274a57 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  
>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
>  
>  		nr_ptes = 1;
>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;

