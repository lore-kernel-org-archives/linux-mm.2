Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D8CCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345E46B0088; Thu,  7 May 2026 05:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6CA6B008A; Thu,  7 May 2026 05:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BC16B0092; Thu,  7 May 2026 05:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3CD6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:44:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C41188C2EB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:44:09 +0000 (UTC)
X-FDA: 84740137818.18.AD10871
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 872DD8000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:44:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dBR/o1TW";
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778147048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c9VtdFN5/KRq1vRJj72HmobU8AvCaJrq+Ns3xrJza0=;
	b=zS2eZP0/jwyIMbsqBk17pFqkPBl5FOAXiai/yc7w5Cx5sDeIap4IjcBS8LrFdqqpyQ8OGS
	CPdahfIlyrd0IHpIkIH2VYYu82PrOUfpLMcFv33yAQs9iUold3zmur39OLMYO2VQ5yAUar
	YX0lx7PXToDe03l7VFg+0EbnaC8Pgo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778147048; a=rsa-sha256;
	cv=none;
	b=E6WnA03lZ5ZFkHLMzsz55bKFaHMAuSt8IYdGOrsyNxHhQOGAs2eXFT9r6kABBWthyPbBGm
	iiLlbhMq6CzYOGIMc4lfLVcC9kQ29D4yZzDQRxntnuIsHkF/VC3VBXtPf6WBY5mORus6Zm
	JsOJhqtipTlk5PArXYzyJGWoY8UM8Ag=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="dBR/o1TW";
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778147044; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=5c9VtdFN5/KRq1vRJj72HmobU8AvCaJrq+Ns3xrJza0=;
	b=dBR/o1TWbwPALzv05wV8aBrlF5x3YfkwlFAHwf7/fqyx1A0vTNyMqp0bBVCGW0LdOilHU3Zri/JYEiwnXxYyvHEpkCVrM5FmxWKZMCS7tjcagLPLNLzc08ejQPIT+mMo+cyYgeCQtaU4C/iWH58gn9TqChGIXP/Pk7IZXRNTbXU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2U3NgQ_1778147040;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2U3NgQ_1778147040 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 May 2026 17:44:02 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <kinseyho@google.com>,  <weixugc@google.com>,  <ljs@kernel.org>,
  <Liam.Howlett@oracle.com>,  <vbabka@kernel.org>,  <willy@infradead.org>,
  <rppt@kernel.org>,  <surenb@google.com>,  <mhocko@suse.com>,
  <ziy@nvidia.com>,  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <jic23@kernel.org>,  <aneesh.kumar@kernel.org>,  <nathan.lynch@amd.com>,
  <Frank.li@nxp.com>,  <djbw@kernel.org>,  <linux-kernel@vger.kernel.org>,
  <linux-mm@kvack.org>
Subject: Re: [PATCH 2/7] mm/migrate: use migrate_info field instead of private
In-Reply-To: <20260428155043.39251-6-shivankg@amd.com> (Shivank Garg's message
	of "Tue, 28 Apr 2026 15:50:41 +0000")
References: <20260428155043.39251-2-shivankg@amd.com>
	<20260428155043.39251-6-shivankg@amd.com>
Date: Thu, 07 May 2026 17:43:59 +0800
Message-ID: <87ecjn3674.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 872DD8000F
X-Stat-Signature: 7ahpde7aw8e9j67gttjrikb3xtyb11ni
X-Rspam-User: 
X-HE-Tag: 1778147046-311937
X-HE-Meta: U2FsdGVkX1+H9eN3fNTrAvD9YLGdH1/+/Li44GbexFd1Xjz5nTk7NAZrW/u528HiKEI5EfWO2pOqNo+jmHiqMGUsRGBbDTl+/qfFHrtadxWgocXduPUw+rhNUSQiy9v3aaJ3rx7wU/ePS2F+3d++N926p+cjaPCuKWOFSnYu/0zmyQYLw5sdc0OIwwlcmlMffQALdjsa6Z36mpxaK6oGxfvQK5x21Xq1F9nH8QruPqALqXUH1AAS42Za04nD15IrwOaI8Epj8nwEuBEIVUmDmAsBOsmFXsiyzucpm+dVhJwY540OYMS1342eyIsrTg8mTx1aimwfmAJPSCc+3DAAS7tqLAz2CG44a6fHxwgv8rP2PbZLAPapKPDM+ughaSBHxDZVIuKlD6X0d295IdJAbdEmP8nXyq9JdlHh9xJHtcgRnMTK0QSmBbpxlPYetsIgwuX3epOJuPZFrEjiJr/W3KfTM04WF4Leva7iv7Wx8BeRYO9ZuNPc2jabeK4Blbf8Hrr+6Zr+LbIy9Sq1er7I9Jx7lpae2hx/sGDILyQhTHMOIGWywoGqdGGqNRy2Cm42bAb8NH2SHzPv/nllN0sSpPKS5sMaT9ag9Co+IEYEmEZJlWvdH0oAvVhcKHGzFMU2OLMcrseQixuBDm68m8ngGmMqw7h6Xp4O9IypFCJukrEqrjL++eHLSeF6S1nDXAwBLshAvvlIsnsFZf7oNkVklDzQ36vigJCXUxcoLffn5JD3i9tL2KQcND/wZVCBlTEbJJvBbG8yO5ATUQEt+JrwX+2Gt5+548k3gJrGJUouIqlbfrmbPcAUGDPsyqO80UYgu4YjFfo3mD0yxRD0bIFGcIEcpLZ5N5BxfmQ+q0CVXNu8MlvlvGOi4bSqJumCZPjJ3+h7qYu1SSYJpoOI9UEPa3o7stXasfoGxBZRiIhwiZei0npl52pOBjj9suweoEk7diha2qbSQsXcfMDkZCo
 z/y6UiZg
 DwdsZS+XUzT/qkIrv7SDv70aED60jA+7hErfNCXxpI2FKpkOQY0Me55cLD49A0MIiIh7wuW9uIP9s8W9oYKYAxrpJPq8ZgfoMCtU4021dJhJ4fKXMCL2Fo3eyZf9MmO4seN51xEAQSu60iJjXU+PxRPb0JMQA1yf2DljV0wZbrHXUQzgeotmgsSezfv47WVC57I5x+kCe/LZLdco70x5zT0hgWqsX/5LLy//q7fq8KvSKNBBLKbC2zcUVWgK/vG13+cQ6yHCz4UK5uNjnNKbQSz9Cymwewytf4RfoF89Cqm0x6mxz1FG317Vzzws3Jx5CKVC5LQu/U5fOZt2RFqg3MBxQi4fzqU+OhybX9KxAU6t7G6pCG72aSyXCQXx6Fl6FcFK5rHhffTuqoeRw52O+UqON3noj8+gSyn4sKs67ZxUBU/PiWrGwUpiMIGc0u/fLYDseinGIPj9uHwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> Add an unsigned long migrate_info member to the struct folio union and
> use it to store migration state (anon_vma pointer and FOLIO_WAS_*
> flags) instead of using folio->private.
>
> No functional change.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/mm_types.h |  1 +
>  mm/migrate.c             | 14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a308e2c23b82..f52818dcf4d2 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -426,6 +426,7 @@ struct folio {
>  			union {
>  				void *private;
>  				swp_entry_t swap;
> +				unsigned long migrate_info;
>  			};
>  			atomic_t _mapcount;
>  			atomic_t _refcount;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 0c6a0ab6ecce..03c2a6f7e5e4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1130,7 +1130,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  }
>  
>  /*
> - * To record some information during migration, we use unused private
> + * To record some information during migration, we use the migrate_info
>   * field of struct folio of the newly allocated destination folio.
>   * This is safe because nobody is using it except us.
>   */
> @@ -1143,17 +1143,17 @@ enum {
>  static void __migrate_folio_record(struct folio *dst,
>  		int old_folio_state, struct anon_vma *anon_vma)
>  {
> -	dst->private = (void *)anon_vma + old_folio_state;
> +	dst->migrate_info = (unsigned long)anon_vma | old_folio_state;
>  }
>  
>  static void __migrate_folio_extract(struct folio *dst,
>  		int *old_folio_state, struct anon_vma **anon_vmap)
>  {
> -	unsigned long private = (unsigned long)dst->private;
> +	unsigned long info = dst->migrate_info;
>  
> -	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
> -	*old_folio_state = private & FOLIO_OLD_STATES;
> -	dst->private = NULL;
> +	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
> +	*old_folio_state = info & FOLIO_OLD_STATES;
> +	dst->migrate_info = 0;
>  }
>  
>  /* Restore the source folio to the original state upon failure */
> @@ -1217,7 +1217,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		return -ENOMEM;
>  	*dstp = dst;
>  
> -	dst->private = NULL;
> +	dst->migrate_info = 0;
>  
>  	if (!folio_trylock(src)) {
>  		if (mode == MIGRATE_ASYNC)

LGTM!  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

---
Best Regards,
Huang, Ying

