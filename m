Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04452C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086FB6B009F; Mon,  3 Aug 2026 11:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E3B6B00A0; Mon,  3 Aug 2026 11:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F4B6B00A1; Mon,  3 Aug 2026 11:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8A476B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 737EA1C0E9E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:05:05 +0000 (UTC)
X-FDA: 85060280970.03.53EAFD6
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 079D2120004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:05:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ClYJ934r;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InaA9nphc+gU/P+HAgEZidewKrxFbc6zJkV9A2LJFs8=;
	b=WB8eXQ/rFg2AIDczcxfq9gfdWJ0pyK5OeRURxUHdI2V+qImL1OMhR8+i5+O3HXt4RwZ10C
	JWBmi2SQ4SNRgHFxDOdo6TojivUFlrylOUylWszWP4DQh719ex1+oVhkk7yq5dmed8ZiZl
	y6fFo726IGkTXMrqKYeOfZH+S7epVSY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ClYJ934r;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769503;
	b=izFDs4ZGZgKGdalKw8WV8ZNQCMYxFz//wIKo7kZ8dZBDi1yC1K7cdi6S0D0lZkx60lzhxy
	yJwVB2O8Y+/zzTPwy2T76EUyp7ShkbBFo2ed0uuu1pPKrKE7BQotVHjQTS4/f9mBNSRGre
	chi2MEZOuW6V9tBA9+SeoA56cCFb+88=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92ea24a2dbfso273276585a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785769502; x=1786374302; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=InaA9nphc+gU/P+HAgEZidewKrxFbc6zJkV9A2LJFs8=;
        b=ClYJ934ruymHMRUhciDOmFy1hHfNOq0LwrqWrNlAUxDKB2ODRpCVT18g4HIshyqN11
         st5j1/mg1lcISOnjlA2+Jdw6VsfAAaTttLAylqXXtKQSrQALAMoTyjYiGXrKRGXp3FZD
         yS3lsxZh5owqz8HQNDLW99xI/fWCgp/N/JEORYCQ8A9oLBa8Lx+CsldDj910uib/hg+j
         rEpwQZxkmJYBa/DXpyJJjUdCHEV4HsQ7nm+QfN+D+O9LkYXTKzyrf8jUo+3jo9jcXb9g
         0AI/UcTrw4XHsgPAjCm5svMXQi8wENM8boS+B7O5vF2mAdDSN6t06nCTb9a8NlhkFNFy
         xCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785769502; x=1786374302;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InaA9nphc+gU/P+HAgEZidewKrxFbc6zJkV9A2LJFs8=;
        b=ExPHdjgf7AZDFxUXUGUH9wnzS1evPJWpZwqhoUvHnhPuGK3kben+dLqaE08agAgjEv
         PPqd2Feqg/T6sYUC8aSjcu2o17zZNha3T0fyOE559xzCK5uWh5hXAMh2nRcpswud0K3j
         XsXmIMbQf44GG075PRcfVnNGpCZKV+bceLyXliSvJZW0sAK8yXfCf8OOTs5oXzY1FKDz
         zq2fFbUK75l4kIOd0uXdLPJ4MgRuMFNlgwho4NknvS2Vvz1pDUiodnLKMTPpulR7+iv9
         68n+AfMQVlygAiLq4t08hKY8s/CI6BmI4O2ClIOPlftJPP4fS03xnNLEC0Skl6vY57ut
         Tcrw==
X-Forwarded-Encrypted: i=1; AHgh+RrCzuQmrqOdPMQ/zFjvvuf8+kKECwe6jRBv0jTp74cDJ4ItTZLoLspN4+E2FJai2SdvoAATHzTzhQ==@kvack.org
X-Gm-Message-State: AOJu0YwUtC32TNDUuVkmwkVFYtC5DUPsqTBHD839QIC2EKZ2qvCoXiZ2
	ESUh8HlIxHYyBL4DFv+9JwPN0SDCjdBhqTWXkNM//tiiysWfdjIR7OnnQKUzUcZjfw0=
X-Gm-Gg: AR+sD12+yQTBNag02X3vDuTTBS2kYUpeq9WKXWhUf+1YOy5JGKDqhylCNFChYBYR3zU
	VHot5uUbz5tx6yBAI7u65EqK/2NRnHLvzUTNCqcYiwVbP8zfPM0IPdw58i5GeDHT0Z8X2ZKB1rD
	LVAXuRgxxgwYPipyvvBa45+JnSIk/B8Wn22RN5nVD+Sr2yzej7OrkaJpQux73zfYK5iF0/SlAA7
	Rn72hO8z+z5/DRN/oNojsoxUNSWEzcjl3hqkgm1MvXL5zNZiyzniYBQHxgKZtjWrvkSklOrbBp8
	Zo6RwFbqPHecTEoQHPHaBbEuGPUjKK9ZDIU8K+Qm3F+c4bMJcDzrQkuKMl+Y81Y3HPrbuddWg4p
	rSs0ww4KXAQ/OBILWzxKl2REW4k0UIvj4BM/+ALoKy6NJxx6M/FyhE8mIVeZAX01BvwHOWvcwZ4
	pOK+XA7HcKXue60Kr01HkXTBYeB6HqV/j/MnHTMoPSGAXrM+vDIksT5BYwbMI=
X-Received: by 2002:a05:620a:4725:b0:934:aa05:f590 with SMTP id af79cd13be357-934aa060270mr1387660685a.43.1785769501831;
        Mon, 03 Aug 2026 08:05:01 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349bc25593sm681081085a.6.2026.08.03.08.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 08:05:01 -0700 (PDT)
Date: Mon, 3 Aug 2026 11:04:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Message-ID: <anCuGbQ_-pTajAed@cmpxchg.org>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 079D2120004
X-Rspamd-Server: rspam01
X-Stat-Signature: fphsky74syegqg8m78k8kj8t8xeeqi4i
X-HE-Tag: 1785769502-576421
X-HE-Meta: U2FsdGVkX1/aq+zZRfZmQTEjaMRoece2VY3KNnB71qFIAHP8ABBkjElKIqkqNY+pWIjpYHjtHWSC4RScvIo8KuVe7PCDJzC8vSITFqQU4A8mAPNG8Q7yD+SuKJGQkjs0QmCSNG/jy0DVoWcOa6Y+Sc6nUbJI6+cKfz0pVd96rDVxyID8I1Lv7rRGZADhiBKbyifDQue0wRuqC4Tjl5brtkuHNYtQJ8aiWCQeowkirQoPUrxajR4LTM44Ezq/C3Xdy7EYpPCHEGaCdBs4CuyriJzIXCbUbYeJA9E4JBs70Qf2M2iCQFuzSwrSeZVsOwYq+75oy4IsvfnQCZQnzNpH3NpjpDo81dmzS3M7IUkNtKLzH+MmK1WEjdsXDZrlWfJAgZcL05Dg0qQjXN3wrThH92ZXl3p4vKJrzhF0FBpJwFQBVCgZHQo8UPxbO+KTLel2Cw3A8dn1k7LLowgJLpsr0ynPerZIxFH6q2meujouMhySltpMsC2D4SJY7+V0fsPwly54KhUZYJJelNF6LcPgPKT3glKogOjm+RsRV5X26sqR9nwZNeT9mrcX1z8eLadFRlCa7S2/yX93MA8qtnf1qH/XUel7mBa9gMvEBqrKWVFOT/t1Q0ipxAmcGzKDRDSPJNP5hGDHEI7LdAzFeS9+kvnOa8ARYDuGbNx280rTaxX3FVUmzhM/E4VGPbCfsUG6Lha1M3FbFujU7iey58YsMIKl77VoQDN/am+xLSd81UOftl0JL7Gjf0NOTcCh0BVq7Bn7D0lrOz7OmK7wAbBvrlcTfWG0Agd9H/RlZvf9ocopgVZMjhZTkgkm6B3n5vXThjeDt1BC2cdsdhjCMRfDhnnM91FlYeCbi7uXexNyDX9xIMXOwmMBLU0TMXfPukybuZ5HJ95NLr/eR1dPDOsTty28a46XXrndCDUSUI7KgewoBI/nwAdNrMXSMWzvwH6is/brkyOP3gkwf9bM5Vz
 8i+wZ7kI
 mAszSW7bfSgnVR+R92kv9bI90rEz85vLm4pGgRa2aIZmyGV7yG7ymyAZEue0ncc0J1ofZhgSuo/Fc4efDW/W1LvETSagMP1i+6CgXHwoGl6PQhH2TF5pe3UCQCrKw2FK5x0swoSKLN2b3TBinvhsLCWlmcCWVJX94QOCVeT2z7tOULd66DtoZWyeaH5GuI+yt+YQJJylItDiJj6jWez6EqwG7vCmt33kgIlr5JX7zhjUBvPjYgLoYNCmtIS4ZDyyU83HML2QNpS2AfC/P0EZkyp5tRKrt180SuXBzf6HI49D4Z5/k45s64yGo7nd2FkbvbGPXl/HFIamEiEuOsxG7W4Wp082cPZmRBoD/uJ9XDi17PTMTplJrJqoXs0Mq+I8DjktPYKhlE3oZazObdrvhrQRm8xXiOdDH1cttDWth+wAx2RqgDrvDO6RkHsWL1ESIUF75s9MdeExbeM/GkafHAqtg4gT+YYXZmpXPShDX8YY3wrYFnS6YQoSpmbswsRyUXSK4i7qmRkN1AJHcahuqLeLSd75FA8/uboJgssxk7TCk4DJMIHCI7pYs6VdrQNIb/LKf/b+ZxlXrLq+J/y4L7YaqophBYGZ9+YWZ3Zxel0028Uar3gAzg9Fm7KdbkVho5vlzYlhqa6W3fe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:13:24PM -0400, Zi Yan wrote:
> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
> Replace it with zpdesc->zspage->first_zpdesc == zpdesc. The check,
> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
> should be negligible.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Minchan Kim <minchan@kernel.org>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/zpdesc.h   |  2 +-
>  mm/zsmalloc.c | 15 +++------------
>  2 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
> index b8258dc78548d..4fd81c2e80769 100644
> --- a/mm/zpdesc.h
> +++ b/mm/zpdesc.h
> @@ -26,8 +26,8 @@
>   * with memcg_data.
>   *
>   * Page flags used:
> - * * PG_private identifies the first component page.
>   * * PG_locked is used by page migration code.
> + * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
>   */
>  struct zpdesc {
>  	unsigned long flags;
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 8204b76f78308..e8ef227624efa 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -290,11 +290,6 @@ struct zs_pool {
>  	atomic_t compaction_in_progress;
>  };
>  
> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> -{
> -	SetPagePrivate(zpdesc_page(zpdesc));
> -}
> -
>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>  {
>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigned long obj)
>  
>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
>  {
> -	return PagePrivate(zpdesc_page(zpdesc));
> +	return zpdesc->zspage->first_zpdesc == zpdesc;
>  }

There are two checks: get_first_zpdesc() and obj_allocated().

static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
{
	struct zpdesc *first_zpdesc = zspage->first_zpdesc;

	VM_BUG_ON_PAGE(is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
	return first_zpdesc;
}

If you expand the helper, this seems kind of pointless now:

	first_zpdesc = zspage->first_zpdesc;
	VM_BUG_ON_PAGE(first_zpdesc != first_zpdesc->zspage->first_zpdesc, ...);

Mayyybe it could make sense to assert first_zpdesc->zspage !=
zspage. But that's a separate issue that the previous check didn't
necessarily catch. And might not be worth checking, considering how
trivial create_page_chain() is.

In any case, it doesn't seem worth keeping the check as-is.

And with one caller remaining, you could delete the helper and inline
that expression into the check in obj_allocated(). What it does now is
self-explanatory; it doesn't need another name like that PagePrivate()
check before did.

