Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A1A606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QMGPSX+H
Received: by kanga.kvack.org (Postfix)
	id DF1A56B05BF; Fri, 20 Nov 2026 02:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1FF6B05C0; Fri, 20 Nov 2026 02:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91556B05C1; Fri, 20 Nov 2026 02:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A73FC6B05BF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DACD160DA7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:10:51 +0000 (UTC)
X-FDA: 85454625102.20.98C64C2
Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2538120002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:10:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QMGPSX+H;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795158649;
	b=mc2kykP0dW7vi3sCF9l4CXjEXyOpRr1QIEaGBPhIRBJJJ8gm1P+do94ijSrw/7191StN6F
	Uu3eEf/YTo/mDJ66y31yxnk7FrUvfLOHNWwYYjtR4VsMqAQo5Rxu/6R+rg5kCiGSWd2tfP
	m79XOIA2ooxphWq7UtrMPuEW806ZKVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795158649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrVjR0ldF5os90khgV8tI+gBuMvnvIaz6fwAZEMSvyY=;
	b=vZ98sADpt65lE7z/hbqTLw9QvVg5fXCBt0Frn+lXZQ/SbcYA/J7tzmasApJT/6fibIyiBU
	e4SEC3FcYgMnIieZ9OtXnmZIM1Bm4JvVLqTD0wc/Vgp/0bdZN+e0iUegYJ0R2uzYKw18DY
	unuEIzCblq2qrSUCydsdzZqD8ajtN9c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QMGPSX+H;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iXadPTuzEyYGK17GU1F26gUUhQt7mhcJQzKvAe1cH3A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795158647; v=1; x=1795763447;
 b=QMGPSX+HicDdod/qSRxo4k02P1uQff7lv/obQSFKKcivGcs8NZiHqFJJdR4DT/77ERiNZHOO
 miGrQ6btjiKZeWbdUxbHD/tnVlEruLqsh1PkutDa6rZu3fPykELid5nXKmXHIhR38CGa5/LqV9U
 DyQcmRqdZLXabyl17V4NaiwU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8e21a47625769387;
	Fri, 20 Nov 2026 07:10:44 +0000
X-Mizu-Trace-ID: 8e21a47625769387
X-Migadu-Flow: FLOW_OUT
Message-ID: <73a452ad-4346-4f77-a2f6-4c801562c050@linux.dev>
Date: Fri, 20 Nov 2026 15:10:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/shmem: don't use the memcg of an uncharged folio
To: Chris Mason <mason@kernel.org>, hughd@google.com, david@kernel.org,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 qinyuntan@linux.alibaba.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261119193656.88678-1-mason@kernel.org>
 <20261119193656.88678-2-mason@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261119193656.88678-2-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: xwqp5gyni73njgrf8rc3jaimp8oi34np
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2538120002
X-HE-Tag: 1795158648-393486
X-HE-Meta: U2FsdGVkX19OImnaOFWyFh6AmCWuwvubeiBOMXlWU9z+WFh8PtjfnriN1paHgZWb+PTgztt91kJYGHloClDygHXDaR5ZEYTKT1kLjNL/VaNtx3dGaHovlW1fNBWqbtSDcY5TcPVbwhmR/x3bcHPVO7WMb6d4kBihXJsuG7LNMvSSQWvsFtkGvwn6yh8qu7ZPrWtnhGsDrdq0RGQ7a/jhJYgjlfrTnDpgrV+YS3l8sm0WuGsNGdtLxVNAnE57Xwiky39vZYznrdOiiXYYusi2/IPNWKFJm0f1mWo7NaDDPB+eYK0XnqYI70ZI5MMClcb2inXeVkLt0GS+oARr4voB2tp7Ci7ao6vq7e99yBXBqWjDFG3CcaPy4HChKeODZ6o8r3YQSKXsR8+ppzbTwRUNlItuU0CtBGjEmUxZLhsothSKRnP7tSvblfkZxl//jE08sGoiurYPF/Fe4Ajqa07aKqG5X/VyQsBb6a3N608Ouqig8SLkQxYDOLKbyarpucFgD/l3KRkEBqrmsnuqMylo8Gw8IvjFr+YvT9daEeF2VfKgx0luT50CW0ZIQZphiWIk4wHkjs+XAi4UJ8M7gQWg2KOB991DBKGmYgUFXD2JDe7/TMI+1KO5t7JKLa1XCWDAtzsiEb4IQALkxZsKiLN6BMkVUaNtEzuRV2bhb6JE8pec+1u7ZRuEFcaCb1BXMaTp439tTRmaL7rQf66UBoCukHPUn180eI8itNYkv1GnxyojksJ925wVnpdGrNIFgvlk6P/DATPRzAbzuQJs7E8AZppfdz6P4nu055LFzfxafB+IHEwdi1ouPk8DfzbBVG0HBqWcxV9Tw9cATAK8p06y3ZAtiNm1CF/OIWeMa1UUbahDW5GozAy/KZwiNSebCW3Ov6J95PBrR9CswzVwVui4JvFZk2O/Dv6RidLdGkTjWmKY96sJk43ZHUKsvvCg7lFuNNMdGKUknsern65VihQ
 kI1xNdjo
 nkcXPXQLAHuozpqDs4biATj+GuLChtgcnoO1Lt+N2TbKfooc4riMuE4m7WKzXfGqBRM4GKExlJ0kSaMttafZCzOwPi+0ZVaDjao6rFJk45+8UzyIriXPC0AtNoAoN8hqIUC1o3+qSi8S1RxFiElHulZHiYI2bL8lukeghd/8GaAy2ifgv+pkX/Prn8SjARcJwGNvvxMcwiLmQbRQTl6Chn9d3MAZSrvGevadavh33ToCQjA1l/LJ4bPfZCIw7PmKdygEsi9MWnKYmKLPSodqFTAb4h9tasQ1FIa+rbA3AMy5xsKcfvzxB+slSEaAgqFa7CqPUI4cqLlMxq0nk4dHrU3Takfk75NsPaAWuD/Eebi/cTniMxa5MQb5/4rRgOImbkdy4rBGBjbCB2JYfnhwZ/SBsgmC080pbkrzDrmPzQ+XV8egWLCWxI36vFF5MyQAqz4jD4PGZLP3NZm9qTrtVhmDaTULnMFUqRHJ7f37REOj5XJjcBhMp9A8riFf4IPnuW611
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 3:36 AM, Chris Mason wrote:
> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
> if it races with the migration of the folio at the end of a file.
> 
> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
> But it is NULL until the folio is charged, and a migration target can be
> in the page cache before charging.
> 
> shmem_unused_huge_shrink() looks the folio up without the folio lock,
> so we can race with migration:
> 
>      __migrate_folio()               shmem_unused_huge_shrink()
>      =================               ==========================
>      __folio_migrate_mapping()
>        xas_store(newfolio)
>                                      filemap_get_entry()
>                                        returns newfolio
>                                      folio_trylock() fails
>                                      shmem_unused_huge_requeue()
>                                        folio_memcg_list_lru_alloc()
>                                          folio_memcg() is NULL
>                                          memcg->kmemcg_id
>      folio_migrate_flags()
>        mem_cgroup_migrate()
>          commit_charge(newfolio)

Thanks for catching this!

Some nits below.

> 
> Fix it by keeping the original objcg around while the inode is isolated.
> 
> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
> Signed-off-by: Chris Mason <mason@kernel.org>
> ---
>   mm/shmem.c | 29 ++++++++++++++++++++++-------
>   1 file changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 10cef89b00b0..4465a43d6f74 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -758,6 +758,13 @@ shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
>   {
>   	int ret;
>   
> +	/*
> +	 * A migration target is in the page cache before it is charged. Once
> +	 * charged, its objcg can't change while we hold a folio reference.
> +	 */
> +	if (!mem_cgroup_disabled() && !folio_memcg_charged(folio))
> +		return ERR_PTR(-EAGAIN);
> +
>   	ret = folio_memcg_list_lru_alloc(folio, &sbinfo->shrinklist, gfp);
>   	if (ret)
>   		return ERR_PTR(ret);
> @@ -887,12 +894,11 @@ static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
>   		return LRU_REMOVED;
>   	}
>   
> +	/* keep shrinklist_objcg, requeue may need it */
>   	list_lru_isolate(lru, item);
> -	objcg = shmem_get_and_clear_objcg(info);
>   	set_shmem_unused_huge_isolated(info);
>   	list_add_tail(&info->shrinklist, &scan->list);
>   	spin_unlock(&info->lock);
> -	obj_cgroup_put(objcg);
>   
>   	return LRU_REMOVED;
>   }
> @@ -928,32 +934,41 @@ static bool is_shmem_unused_huge_match(struct folio *folio,
>   static void shmem_unused_huge_drop(struct inode *inode)
>   {
>   	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct obj_cgroup *objcg;
>   
>   	spin_lock(&info->lock);
>   	list_del_init(&info->shrinklist);
> +	objcg = shmem_get_and_clear_objcg(info);
>   	spin_unlock(&info->lock);
> +
> +	obj_cgroup_put(objcg);
>   }
>   
>   static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
>   {
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> -	struct obj_cgroup *objcg;
> +	struct obj_cgroup *objcg, *old_objcg;
>   	int nid = folio_nid(folio);
>   
>   	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
> -	if (IS_ERR(objcg)) {
> -		shmem_unused_huge_drop(inode);
> -		return;
> -	}

Maybe it's better to just return early in the failure path.

How about this:

+static void shmem_unused_huge_requeue_locked(struct shmem_inode_info *info,
+		struct shmem_sb_info *sbinfo, int nid)
+{
+	lockdep_assert_held(&info->lock);
+
+	list_del_init(&info->shrinklist);
+	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid,
+				  info->shrinklist_objcg);
+	info->shrinklist_nid = nid;
  }

  static void shmem_unused_huge_requeue(struct inode *inode, struct 
folio *folio)
@@ -943,17 +975,18 @@ static void shmem_unused_huge_requeue(struct inode 
*inode, struct folio *folio)

  	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
  	if (IS_ERR(objcg)) {
-		shmem_unused_huge_drop(inode);
+		spin_lock(&info->lock);
+		shmem_unused_huge_requeue_locked(info, sbinfo, nid);
+		spin_unlock(&info->lock);
  		return;
  	}

  	spin_lock(&info->lock);
-	/* Requeue the inode to shrinklist */
-	list_del_init(&info->shrinklist);
-	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
-	info->shrinklist_objcg = objcg;
-	info->shrinklist_nid = nid;
+	swap(info->shrinklist_objcg, objcg);
+	shmem_unused_huge_requeue_locked(info, sbinfo, nid);
  	spin_unlock(&info->lock);
+
+	obj_cgroup_put(objcg);
  }

Thanks,
Qi

>   
>   	spin_lock(&info->lock);
> +	old_objcg = shmem_get_and_clear_objcg(info);
> +	/* The lists for old_objcg exist, the inode was queued under it */
> +	if (IS_ERR(objcg)) {
> +		objcg = old_objcg;
> +		old_objcg = NULL;
> +	}
> +
>   	/* Requeue the inode to shrinklist */
>   	list_del_init(&info->shrinklist);
>   	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
>   	info->shrinklist_objcg = objcg;
>   	info->shrinklist_nid = nid;
>   	spin_unlock(&info->lock);
> +
> +	obj_cgroup_put(old_objcg);
>   }
>   
>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,


