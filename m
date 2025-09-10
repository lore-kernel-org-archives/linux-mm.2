Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1229CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B52B8E000F; Wed, 10 Sep 2025 08:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EA18E0003; Wed, 10 Sep 2025 08:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D5E8E000F; Wed, 10 Sep 2025 08:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7B4C8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:57:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6EB1140899
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:57:06 +0000 (UTC)
X-FDA: 83873340852.16.7A02856
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 844E3180003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:57:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zrNMJfWy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+Opm/xw4";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zrNMJfWy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+Opm/xw4";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mwinq8gsjwiHlcc0O4dms+YN1QO5jIp+XwdfQBarGdk=;
	b=sY/SobXnmlNhM8744fwyq4wEPJa0QdpTL36HV6aw9IFyWb7gH2XNVmz7PSURhf/JmSyH25
	Efs7AGY2NH8pFi/GYMBk0NMHFZCRqR6W1x08lJOWuYqg2iFcc47jDPGZU7r9s2Nz1t6pGz
	2+4VCfsdKu/s9mqWBpO6Q9tjDma3sT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509024; a=rsa-sha256;
	cv=none;
	b=6RxnFiAZQv0FhbSssNYqdoSo6ZSLk7pbA3pY0hAtuPZL0XjYU1eXkzFiAlDf3oyjslDzFu
	bJlkdEzPxgBwYgRFJdkTD2OjVQro9dx7dZF6JC+TH6bvpqJ7ZOoCDMeA/jqpCHgr0aajGa
	fg2C9FyYQf10GzXwkr1A5bUmanbCqCs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zrNMJfWy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+Opm/xw4";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zrNMJfWy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+Opm/xw4";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9F0A34AD5;
	Wed, 10 Sep 2025 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwinq8gsjwiHlcc0O4dms+YN1QO5jIp+XwdfQBarGdk=;
	b=zrNMJfWyTUAJv9/QajN+dxw1lowq1b5xo7iYC33VNiutR13Y0lEpGCugpEYkjJURRCkxSZ
	mxk6mrguZS5K0i8Hfga+ftK/8uO4y+WqJINm/Ezo7gYoy/OWI5Yc1gRoSKiOGn6T4tWsQU
	XnRHR3s1ZN8qpdbw0N7VemCelr+gV30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwinq8gsjwiHlcc0O4dms+YN1QO5jIp+XwdfQBarGdk=;
	b=+Opm/xw4Gd6mN2XQHPUz9IXWZ2mnZucVz5+xsMOZFbF911FoFRNImuxdMNfz//GY/4p20v
	Bb3tifOUHCaEZ1Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwinq8gsjwiHlcc0O4dms+YN1QO5jIp+XwdfQBarGdk=;
	b=zrNMJfWyTUAJv9/QajN+dxw1lowq1b5xo7iYC33VNiutR13Y0lEpGCugpEYkjJURRCkxSZ
	mxk6mrguZS5K0i8Hfga+ftK/8uO4y+WqJINm/Ezo7gYoy/OWI5Yc1gRoSKiOGn6T4tWsQU
	XnRHR3s1ZN8qpdbw0N7VemCelr+gV30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwinq8gsjwiHlcc0O4dms+YN1QO5jIp+XwdfQBarGdk=;
	b=+Opm/xw4Gd6mN2XQHPUz9IXWZ2mnZucVz5+xsMOZFbF911FoFRNImuxdMNfz//GY/4p20v
	Bb3tifOUHCaEZ1Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91AA813301;
	Wed, 10 Sep 2025 12:57:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sqhiIJ11wWjwBAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 12:57:01 +0000
Date: Wed, 10 Sep 2025 13:56:59 +0100
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
Subject: Re: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
Message-ID: <k45ojp4yjaqp56azyuobcsxyqmm5uslo5gq3ddujwfi3ynvkqz@2oncyj3tbnhy>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-4-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-4-Liam.Howlett@oracle.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 844E3180003
X-Stat-Signature: iz4pzec5escoj7bgq9ohdsjha78pn1uo
X-Rspam-User: 
X-HE-Tag: 1757509024-463617
X-HE-Meta: U2FsdGVkX18HCCp1IpVNdEBudBC9HBDE9N9aZPG1xIr82j1jSeG5cgFbrEYdJk+OSsaDQn1ioBQ0Jr05uHjsH6yzU9NTEeWFz+NS0X1dNGFNuVyp68ghJuHdYBTKoPajosTXBWBMywZU5InjXAAkmPZ4coAZr26JsoCCUMzMUL8lSZtj5zyehyM9BbO9F9JcF8i5KKc1peefGUkNJ37Z51KMM1yWmmjuUHHfDCS0rT370uKCJj2dVwJ9SlUX4JWJIxSFbMCKzuuy9fXFN9Ab9QNitxyFwxkFJ3VMMWltQqGW5NU9dusRtJgZUa99hIV4LT5XGPhson8/J79PoQjsdVO2hwFzJ1zU/GGaItBkpOD9Jbt/PKhfvbwRCbwDY+fy63lQ5Ehbit2d9lhlVTX0vJRH1c468tV+5ti8QpJjEi8VyUY9i8fIqyqJqxyogoqwJAxGYB6Z9h3fnIXxbIvdsFpCpXnR230mTQJt651l7EkbMXZHd8aoRhs/7HV3QBjIB2AYjsr1zc3Bx4Kufph8w4j8U7E5d2bFnqrj8kA8yLpP5KGNrf1EElVoR3J5e5P9/k7YbGnsiQwPypV5Mpwa8SvXnxYKhyP+YccaMRAH+EQq9AX/vB37fshY+XGxX/q+Wpqlx/cBkqSwdFRGJ54j7LMDkfxSvpsEvjivkMkZ7lWiDhvqQoDEV8rOrsJMqARooXrCsx2bwKs570lPGPeZAsAGoUztIph7X8FWBppmKaF7viqLV5fsuMgBPXWAgf39+GbNWKWcZ65g+KCiEu5bIjySQjFkPsfXBBG9CgHOqLX/ulLOoWl1HgQ4OiMLrvdhQsWPzaUSrU2qS9Jhv4hLnvlcPN0L//w3q40+7K2tHRI6FdbWrPhwAugyy2gRYmUJWp7Um7WRih75kXMOc6JjlFFRwNULO3+a8QmRIfUIzS5cZukRKP8t8qleQM1wABsibfpohnFTIzhEIUXdMy2
 rZPkM2ie
 AC+kPf8AXt9dkLHROHRNASLCWXOXU4nSMvh9sW9Z9wwQfR7ipuWmIhTjDljMqIz7sPJjvBcyZN2PcPL9T8LwuhyQVXP2V0W7V96A2bN0hLcFWEoPCF7xOB9ideoiOdrMJInZHHZUjOkewQJlJgdtwFqGx8f4qR3pyR0sl+T758KALLkw4fOWX/b+0nnj9u/v1mQKufp9OgjvokUgE3VT82TI7MuRaXEnGVyWgVvPbo72Y3IC6432+N7GQuujNoLPwO3iWIz396E4LuRCLAj7pUg9NK/CATOlgSYJ3/ExT8H52q+pqH/4UfZa9TcLLvJOs09+P7h22rHmvfj1e68qrlG1mjfZ8MqjVPEfmC/mxh9gzRWlgYk4oI9XqwiWml7PDT8MbO0a/+0TSfNXa5zv+Dk3cXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:39PM -0400, Liam R. Howlett wrote:
> Add a limit to the vma search instead of using the start and end of the
> one passed in.
> 
> No functional changes intended.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/vma.c | 6 ++++--
>  mm/vma.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index abe0da33c8446..a648e0555c873 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
>   * Called with the mm semaphore held.
>   */
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +		unsigned long vma_min, unsigned long vma_max,
>  		struct vm_area_struct *prev, struct vm_area_struct *next)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  
>  	tlb_gather_mmu(&tlb, mm);
>  	update_hiwater_rss(mm);
> -	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
> +	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
>  		   /* mm_wr_locked = */ true);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> @@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  
>  		vma_iter_set(vmi, vma->vm_end);
>  		/* Undo any partial mapping done by a device driver. */
> -		unmap_region(&vmi->mas, vma, map->prev, map->next);
> +		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> +			     map->prev, map->next);
>  
>  		return error;
>  	}
> diff --git a/mm/vma.h b/mm/vma.h
> index 9183fe5490090..a9d0cef684ddb 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -261,6 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
>  void remove_vma(struct vm_area_struct *vma);
>  
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +		unsigned long min, unsigned long max,
>  		struct vm_area_struct *prev, struct vm_area_struct *next);
>  

nit: min and max don't match the arg names in the actual definition of the function

Reviewed-by: Pedro Falcato <pfalcato@suse.de>


-- 
Pedro

