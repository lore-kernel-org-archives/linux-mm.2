Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A31CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001A98E0002; Wed, 10 Sep 2025 08:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3956B0010; Wed, 10 Sep 2025 08:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A258E0002; Wed, 10 Sep 2025 08:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD5426B0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:54:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A066D8709F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:54:40 +0000 (UTC)
X-FDA: 83873334720.23.D06D62D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 526D2A0020
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:54:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s8CFhKY1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD0KplvS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s8CFhKY1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD0KplvS;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sk+37UwWwPALMxUocJnLLKSlfsnWl0NqUyQHiakKMtg=;
	b=BTfTBsImKbSGroqqrRi0FPx1onR0sKRvUr5neOtK5FUH9S5jR0EIg4Ubp3W7jONmKCcsay
	HtnyLY+O0DJeKiX6U172RAijzrTGboJaI95/EMYEUW7az+7yZfBmguyltfJ5dr3HPMgmgL
	sdfrurPnKdeXCM01jvk4b08W74vSjcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508878; a=rsa-sha256;
	cv=none;
	b=asxrOWjCk4MY46zGwIE2E0DoM7Vg4LiIRdLz5jlZkxm+k6Erq3QYq3WEMkqFMM/7M/ScPN
	KcBt1nesLRV2aeo+WErcBap0NDlD7SF/Zi8i8GvaotIeHV70EaGVsMU/1vU1/Crx0cXUkL
	B42zcHBHc4nDt0EY6M2uVPqu4mJvOcA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s8CFhKY1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD0KplvS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s8CFhKY1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD0KplvS;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB05720AB9;
	Wed, 10 Sep 2025 12:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757508876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sk+37UwWwPALMxUocJnLLKSlfsnWl0NqUyQHiakKMtg=;
	b=s8CFhKY19/NcLq+FjQWJYFX8TDi4dCHLzvXG9cZrHOp+Zg/M/L8q8xCxqijwySBLaniYIC
	LV3A7vg6iLgr96HKfywgqiOCiHf03hRtI1FxQLRSJeNWaPTmRf7ab5NAm2dQ6kGjQ4Nr3M
	q1E/KH1qXdiz5tHe4gdA13bib9cJ+As=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757508876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sk+37UwWwPALMxUocJnLLKSlfsnWl0NqUyQHiakKMtg=;
	b=YD0KplvSzl5fxb8wSKECLd6BOo9bH4N5o8VQPAszZLKkLV8X/zLMEGczoKeMQgwKLfNG6y
	xgoym8sSHwmjctCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757508876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sk+37UwWwPALMxUocJnLLKSlfsnWl0NqUyQHiakKMtg=;
	b=s8CFhKY19/NcLq+FjQWJYFX8TDi4dCHLzvXG9cZrHOp+Zg/M/L8q8xCxqijwySBLaniYIC
	LV3A7vg6iLgr96HKfywgqiOCiHf03hRtI1FxQLRSJeNWaPTmRf7ab5NAm2dQ6kGjQ4Nr3M
	q1E/KH1qXdiz5tHe4gdA13bib9cJ+As=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757508876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sk+37UwWwPALMxUocJnLLKSlfsnWl0NqUyQHiakKMtg=;
	b=YD0KplvSzl5fxb8wSKECLd6BOo9bH4N5o8VQPAszZLKkLV8X/zLMEGczoKeMQgwKLfNG6y
	xgoym8sSHwmjctCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85AAB13301;
	Wed, 10 Sep 2025 12:54:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5wyNHQt1wWgZBAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 12:54:35 +0000
Date: Wed, 10 Sep 2025 13:54:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 2/9] mm/mmap: Abstract vma clean up from exit_mmap()
Message-ID: <lrkxxt3ywknfqudhf4u5kwgegrewqw6laxqonx5ysqmop6flxc@gwbqpadk5btv>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-3-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-3-Liam.Howlett@oracle.com>
X-Rspamd-Queue-Id: 526D2A0020
X-Stat-Signature: mma7whh48okztnau98mx1ojoip1xzoaf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757508878-812588
X-HE-Meta: U2FsdGVkX1/c2lrWE0wHK+OJz39ihmiuESsezKHEc+sSy1HwbZJ4mpfmOE11AEz1bQSVzOUWYPbs1KQWHB90iAs6SFhpKbUgk4okEuz31Ufd4HdEBd9KCMDBZyjtk9EvhZTBe8Ig5k9EOIE+BepBnZ72btUnKklLKh1sBnHZuduDgBFZ1dXEKDGU1uVRLlfHkN5JfwG3VBsbZYnMn/3o3Iem4pPz+27BJkLym/yhadMsDMF8C3ewQ4bmIacYQNDjmWP0ucc2NuPereUt6iWVSswNLrrFtnps0z3kcbbEauAJSYr38Kr5aUYm1tgC4v/IKLY93n7Y9BPc/OKBJ9HY7oVpISjgwodNhmm089KtG7VZ3uDQ20lhMQJO9YubVQhSlNHoQxkqBWISUY3m55x3luXRlLGhfIOrZSH+6+BP+LMV5Q0ft7nSBAk+5RnaWRq1nsL//MwVCwhZSdrsuHaL++PVyslbIByA1GZietNio4ps+eqDuNXrraaHOX6eekVdu3tLV5e2EwOLijaaHjjdO53WXEixnGYc75QdbGeJyRC1o9444ficKUVFX36xxqvFx8ZDrMaZiukFH+nbj5/X5XSqmX7Ht4hYZLEqUIUnjrar9nQA7UZ/qB7pXFNxdB5+QTucDaYaJJSVmWGTX3ApfJ2GI5g6x69jUGCvLbFLUWEQum+r4omGMz4JwI8p+6Vy/KphdnK9f3x1zgSK2Vvbkw1XtjNw73ExRLc60vLL1WBRX4S3f4RvJoQJ0ll/6eSdAISlpucykAMSW/ujSN/o4LLfoE6M3XfNWofo8szUkuqQeIlxL+maPAiLdCAO8TmekARazZGJiCm/PbA53NqYG3F6YbHbCzI7wn2hI8S2R4tkoLwAZ1tWlprZG0MCVGIJzX1gmh/oZgCFa7Ry9aHnlt9JlGcHRVKAyltFppXkvKR+2mRS6Ev/MUm8Q1TlVaaCr353gjoKctA3kd5zmKk
 eS+JU67E
 eb1o8SCTa203H9C0VJe+FatkW69tIxMW+obQ2c4XCFMQQ5aDvZi09kfT+Y1EVQRjBhF/U/+f8hfW5OmGhCrghZxwE5055YY17S/kQBpV2C808TAZ6mpFZdrd7t2LKO9glSWnDxhixjTBMYzUoNfJUGp+lCZFLZN/grahpfPWUyUEeHxdkcebBDJZI7LwDnZw5yctDkTHqpnYIDtLy3dbPNPd/yEpB7qYcnvi3/Urq2V4GjjSxSaP7nfHoRbt78+/RhtLzQt8r5deBJIvm0qBIYK11JwsfHBjqwl6aE+6AOIgHWGYYNtd+Fa01abljsbRerQN+tdWhLfCMvcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:38PM -0400, Liam R. Howlett wrote:
> Create the new function tear_down_vmas() to remove a range of vmas.
> exit_mmap() will be removing all the vmas.
> 
> This is necessary for future patches.
> 
> No functional changes intended.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/mmap.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index b07b3ec5e28f5..a290448a53bb2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
>  }
>  EXPORT_SYMBOL(vm_brk_flags);
>  
> +static inline
> +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
> +		struct vm_area_struct *vma, unsigned long max)
> +{
> +	unsigned long nr_accounted = 0;
> +	int count = 0;
> +
> +	mmap_assert_write_locked(mm);
> +	vma_iter_set(vmi, vma->vm_end);
> +	do {
> +		if (vma->vm_flags & VM_ACCOUNT)
> +			nr_accounted += vma_pages(vma);
> +		vma_mark_detached(vma);
> +		remove_vma(vma);
> +		count++;
> +		cond_resched();
> +		vma = vma_next(vmi);
> +	} while (vma && vma->vm_end <= max);

By not checking for XA_ZERO_ENTRY, we're technically breaking bisectability
here.

In any case,

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

