Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E169CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA4E8E00A2; Wed, 17 Sep 2025 23:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881FD8E006B; Wed, 17 Sep 2025 23:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEB38E00A2; Wed, 17 Sep 2025 23:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA328E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:01:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12217140758
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:01:49 +0000 (UTC)
X-FDA: 83900871138.30.50970A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E8C040010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:01:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CxY6FjIo;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UstZYnDTYubWSPv257SpAM28nLgTIajqfeOeGwdEyA=;
	b=RtbjM3J3lrhEn1AO+yMELsJf279WgTPjE/LF7/uQJMGaPiiVFU55Zynn4xJC9EbzBezXnD
	5udyFU46gEBCW31c0Nh5NPQXZN0JJNT/DXGa0MSiYa0FK+8svfPtSqny8V6e13WbWuRl9x
	NjqN+49h20PWGfdDmjrPhFk54v+G6Rw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164507; a=rsa-sha256;
	cv=none;
	b=l81mro0aeUfwNf4iLb/6V03qoBumAb7EPolHKgTTYd/RMrA3mf/286oU19Spd42+Kr7Shr
	t88mk2XCw9zvHPoz83WrGlWIPxfq83u639OJ2tI6AybpLLNr+x7zLaVVAhBkN2Z9pb7BM6
	mywu7ZfsKXeoGKjBX1ePtnrUAP7ubHM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CxY6FjIo;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758164506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0UstZYnDTYubWSPv257SpAM28nLgTIajqfeOeGwdEyA=;
	b=CxY6FjIo3b4Htx8Bb8JMGzpokQWGstC8YNSQDtVD+hkyK9ElGM1ImkSVaTwYmSzdhzu8my
	+lzhn6raiMB05/oUlGvdOiyiqzliT76/lRu+yVYJUW5Qn/IstIAGD/hNcBrNGSFrDZSD+W
	W+TnkPg+FtXub1B5MCDzYH1a/gubNR4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-KwOoJ9HdPXWb_jhpI_xUnw-1; Wed,
 17 Sep 2025 23:01:43 -0400
X-MC-Unique: KwOoJ9HdPXWb_jhpI_xUnw-1
X-Mimecast-MFC-AGG-ID: KwOoJ9HdPXWb_jhpI_xUnw_1758164502
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A40601800576;
	Thu, 18 Sep 2025 03:01:42 +0000 (UTC)
Received: from localhost (unknown [10.72.112.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8892B1955F21;
	Thu, 18 Sep 2025 03:01:41 +0000 (UTC)
Date: Thu, 18 Sep 2025 11:01:37 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 06/10] mm/vmalloc: Handle non-blocking GFP in
 __vmalloc_area_node()
Message-ID: <aMt2EUYD75Wqz1p6@MiWiFi-R3L-srv>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-7-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-7-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E8C040010
X-Stat-Signature: 9ad1kuc3jns9krkkb7dxutzsus5itjyq
X-Rspam-User: 
X-HE-Tag: 1758164507-920554
X-HE-Meta: U2FsdGVkX1/uTmbDeVeyv1m/qo3jhbpgK/7huaFGV6APCHpNgYQZ527pHlAqGPbwWxNmW7JGiGYEXG83tO3P9CyQi0RdrbPeAiJauE5g5tZW3YMTRjh1EnVCrrKfMNUIRc7m88J/jqIrywUrag12y+4T1OigcOpANNlFWdXgT4tRDaAzSwWLLuF20oXNCPx/80+3aIhpqAy+H9WRTB27733oWZ0HlnS9+Agk4ZPsY1cweJ8A4IQGHspadCRj2nq/hVyAx4M9tXKYgmgOc2qU2X26QSKjZekt75dUDuXhuGjYYc3yFX0ogVIlKgPO6ZYz65b5gL6cDsnXEH6dukAMHR/VEQVizshBExBQtqgPq+Hx9GdTbIkrhgIFQMtTLKz9V4Ohjpqtk+W1iepBK9Py/3YclDmEUaVN/AAwt7+A7ZvFM11y7RRAa/6U/i4BUwXFXNeDjrRV3gdZa2W1iGkAjudfjxgmTGY9DFYMd2ZJ9Lpd2KXxbFVOjzoW4/uoOe4mMrgmRZC9dYg1BUN9EZiZGW0MsbGtAvQyQN6+ZsT5fr+4ILd7Indwj2UDfbDfiuLmC1RungRLb75g0jm1lKgO8K/z30pbGRMWqMdNjhVfA3XcGCxtrkBPE8J7Ves/Tc8GRU9VYp/3C3pkxMT6GY0SlIDv5M1vf4s+1Llm9YCNcAox0WolAhZzetG80IwHwSZzE8VcOcCsUqseXr0JiLb6If1UMaVAgm7IN6BOgA2zdtorl+SUuDVuhULVgyL9NIpD32eegdQoVXrDfevbaZIYnIxZEuAkQ1Yf7uYhwozSfDIWwYVfbcbEYK8SQGrsE1zAnrumAueXSqm2pdTWp3P7/HUMGp21x4DKSu1SPgWhtShHVb67/9Y2Dcqyaf4D90xHo0ABJMkVp+BTWFhjgdsGMw5nZLwzpIp6N4WWxeyRNXglTdku48+c+87d0eF2fcT114DyfkPHUpLSGjggYlw
 7a9+W77q
 vZgqEpfJksgC96hJIcMAMLOo+kFdsYOZJKtgnPamfcZdQbu/fQQC69fv0MRLZAr+lX3Wa7zVjM/yeprYaro+Eez6I2qpiRCKie6vtYKVCZ1yaWmPO4c8+NSRyk3ZQha6bC6Op8oydopPBBUTvJgkC36U1haqM3T49V0vFdT/TN0LW6HFhLbg7MTjdiieIQo/TFwJZZfyXMjjOsbNiRkb5QXFbwcUSHA9H3GvlqmSpWE8hitnWju188Cz2mtt1hPl4HG9JdU8/jOtFSEwW/D+fQYLgsESp5f6L/OwF3cfnGglj4e4jMqd0ENJDTq0X9Eg1/ubQ9mUfFwQKZjrbav1cTt1tJKRiB7UGVtbhBDWsMqHkKZO//4ZbZiuJ5CxzQCQOyfNVvAnExC6d/VDD0WP2nETwGK0bTcIVFmnPSggwYwXCo9tpwS89CKeTayO4q56lByZdrM9BQ1eqabEvcBOpjvUJsYambrurtnSUyEfLQoKzWKi1lPVAvtsn90149s1zyvPkRpd4q+IBJpInE7aXY4rjGkPEgKuIDI8sFenO8jQwerc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/25 at 03:40pm, Uladzislau Rezki (Sony) wrote:
> Make __vmalloc_area_node() respect non-blocking GFP masks such
> as GFP_ATOMIC and GFP_NOWAIT.
> 
> - Add memalloc_apply_gfp_scope()/memalloc_restore_scope()
>   helpers to apply a proper scope.
> - Apply memalloc_apply_gfp_scope()/memalloc_restore_scope()
>   around vmap_pages_range() for page table setup.
> - Set "nofail" to false if a non-blocking mask is used, as
>   they are mutually exclusive.
> 
> This is particularly important for page table allocations that
> internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> scope restrictions are applied. For example:
> 
> <snip>
> __pte_alloc_kernel()
>   pte_alloc_one_kernel(&init_mm);
>     pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> <snip>
> 
> Note: in most cases, PTE entries are established only up to the
> level required by current vmap space usage, meaning the page tables
> are typically fully populated during the mapping process.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  include/linux/vmalloc.h |  2 ++
>  mm/vmalloc.c            | 52 +++++++++++++++++++++++++++++++++--------
>  2 files changed, 44 insertions(+), 10 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>


