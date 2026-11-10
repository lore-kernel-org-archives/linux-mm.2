Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C9D606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=fpuoEYb5
Received: by kanga.kvack.org (Postfix)
	id 7AA416B05B6; Mon,  9 Nov 2026 21:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781546B05B7; Mon,  9 Nov 2026 21:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF706B05B8; Mon,  9 Nov 2026 21:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9F26B05B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:51:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6750A076B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:51:30 +0000 (UTC)
X-FDA: 85417683540.05.5262380
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6AFC100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:51:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fpuoEYb5;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794279089;
	b=fDcnF84GvJL6PxIlJ5Jm79Qmd0Ju8Vt3XREkT6LCFPP2jqvcP8jkGmy78yBcNeOW1F6Flh
	4SOTC/NYSl//zUDRPRavrBU7VzHg/XEkkiX+3vg8Yc6sbJ4TcoqUnLVIHgW6fJOIQ7ym0D
	JbopQFmuumlQahSHDmEAZRvZW6XCkn4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fpuoEYb5;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794279089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbLMU1pYfk4pMCO3YrPvND96KRltx8I0UXJznwRM32s=;
	b=stnlbtP3+QJU2PwQ1ZHjB/uydxi7UF5kWHOc1wJPk8jcS2aezQNHzGl0mLGZqSYaKntLvW
	C3kQXLu1IzPDFMdBccc3V2eo1GXudMiMVz5ZSraIsE+r23X///IOCOhc4oHLTJNYXPS/Yv
	dcdstJLNsooJFkRmATmauOv6iFmmldQ=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so938327b3a.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 18:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794279088; x=1794883888; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rbLMU1pYfk4pMCO3YrPvND96KRltx8I0UXJznwRM32s=;
        b=fpuoEYb5vJmR8cWazU476OHEdqNOf1nQqe41fP/INEMI5Z7X1POuDfrHi+CRrZ4/7w
         cAf5t2Nsbz43C8I+rcgx7uTvndnBz6JanV0yHZqeNlNAl0/lvB0HAWDI8HQ07Ii/v3Pe
         BqRpi6tzeHP4FWReIM+ysUvUfCwfOxM3/ENiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794279088; x=1794883888;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rbLMU1pYfk4pMCO3YrPvND96KRltx8I0UXJznwRM32s=;
        b=vYtStUzICjXBcRnw6kSdwFWNt86i618nDDqkecDWhmR2gG1iEvqbuJ0BT8g2jVdI2I
         qFlMeduBNxAgx5mnPoB9Eop/JVGvQrAy8PkZaLLYPsTlhGibSkBge1n11W/EOhX3A75D
         LZHl3GIMjF8G7yAZlFWCum059XdgxSw0dtSjqCuHAJghMs8fqsC2x/Go7ycN4uChI3RQ
         kIOX8Tlu3PE51Fwrbz0I5PbWxCZZV+zXyEHJh0MJd8PiBe6X/4b7X948hYsQ/vhwGrNa
         rm4v0lRXY8Hq2k1YtYSNHSmICdJ/teDhlwd9X5bjld+0PGKgSEGJ1GbbERmVgpukyCNJ
         IUVw==
X-Forwarded-Encrypted: i=1; AL+hErGtNkT6U6mGuQI0KHM+XBQCTmLLJwVuhbpayTP+1h2zGEoJMgOdx3POah4w5zrh7FiV4tD+l9SwoA==@kvack.org
X-Gm-Message-State: APuU4Z8B1OGKHYPiiWNUsFwfXyIXdFeBAH0dtgNPMFJ0kriSKS6KoKA6
	Cq/hWLx0MAVR7LzEwnAPsB6IZa/jxOGhpU7c+XTNlVVfdl7zAs4qZKLmOLtgboXUiw==
X-Gm-Gg: AYBFou1gFtOC7t0NUyySHp1IBFPhgIrt7N+cYFCCA5zNtvVt+cTeNebZmvMBHRXvS9w
	ALi2FRi34Ybqf3gNxPfSNAV+kLb9g1XbUASwIyWYIUsoIyTHIHEpKv32c6LnmV6cle4Wjg9cD8z
	RLPY8ot2gGdkc2vTwDD2s1lXNgPZgr6aBG79u0g5+SanKygnmyvChUxc05GZZEw4BfHpZMRoDKu
	mBm/RbS5nbVmF8VIhwdHvB3yJxEDJwcROqrgSpdUfk724LobW49I1AhycNH3slIEYAn29Qot803
	nktCuAZ8vMG50JfwrEoaKMlDCpHMQkf1Q0MnFSrFn7VAiwBTCuepL1bFIO9bFMcGUBS2IyaYqFb
	+5T6Hymn39h4sZWaHEjRZwqY+n9Bu3sKtGLdKpXF0ZrixEpava3T7glchVlXFuDVOTs8D4uAiRM
	Gu52U+lZyu9Ik2K1qejUD0CYkCnTWsfGxdJe07n7ktoAh/zt4bawEzCYI7a4jo+ZZRYGCS0A8Fp
	DwTVWVCHivDjinEvgUUdyA/0eK8QycOENmObGOUHnnwBRkXLUa+sGYZiVb5xOeEGue+z7r4Ln0i
	eKuRNiM7cXUN+hXMSYvOHNv3th+93LfSyYl5GcVaPQ1Gdzl3SByReLwBZAALHNsiE4UPe4C6FVG
	CpGOkIebcx4L7vYU=
X-Received: by 2002:a05:6a00:1249:b0:89f:3053:9af2 with SMTP id d2e1a72fcca58-8ba860cdac1mr1637379b3a.12.1794279087731;
        Mon, 09 Nov 2026 18:51:27 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa2a7fbesm298559b3a.11.2026.11.09.18.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 18:51:27 -0800 (PST)
Date: Tue, 10 Nov 2026 11:51:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and zswap
 entries
Message-ID: <avKFc82JS4R9yU-N@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-6-senozhatsky@chromium.org>
 <auy22TkX0ADxP9WR@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy22TkX0ADxP9WR@google.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6AFC100005
X-Stat-Signature: 8djrac7znexncghrhgjyrgymxwxao7pq
X-Rspam-User: 
X-HE-Tag: 1794279088-892261
X-HE-Meta: U2FsdGVkX1/IFCERWhwtw46fn8Q0o9Q76lLFEKXr2C9hyYNN/ClEk3L+yC/4Ib0X4gSy8uT5FYoYAPKWYKHhusEf6PodH9WNfWG5VSzzhv/l9mxPtlcS7ooHCRvxYcplF9uK0OLlI5zobi0UtCLlEP6bkXtPcH+GHJLw1v7zebVemaeo5ewJZrn3pYo6CFBMGmnPJ+gAAj0eFb6Q6l+bbkQHPrrFwxliRYtXalFOaiUqRInHnHwQgxL4X8The8gxxLXOe655GA/1mW0Lv12tTeiE2FxWvfX8yuVeML/fvIRe5nYqgNkPjfCp7zus9REBCFSc7U1zi5Zhg993w/U8lvm8sNXnq86DHP7TM2pAlQ1RitfCLWwFX5f4hnukie/xpHzcI4nogZqlWA7VPD38TPD7TjZ/cZhsnQnJc6uKhs41rZotoU8AEtMv+mJhP6QBdd5gXniSs69KueKhDtMhkQbV4P5UxHZlytj8J7Y1zsinN9UM4DDNDfOV1knAdAAAZ0KxE9SdVtMj2S73s46fMM3jPPdhOC+8zt+nqJ0Iu97C4clfrjdt5qtdVw1wG90EErGBz1YeMjniGLNDMitWvtJ1piot163+YlTNyFOH9R+RCXCVuouwyh9pqdUm/Ga6RmYooF2VxqtJo4x3mL4ktyVmqXmsTSbcGqY01CDvggNb2FCkvXtUNb4zZaaXS9aYPHO08yJn414b4EUvbGLW3bOZhwY5QRLo/D4KOupE52d1Axd5rssAdGbt+QyGbWy4HswS3Idrd3giom5/OCsAY0lg4413Ew8thxHWPWOLU0Q8Y5fVlFnDIUb7EjnCaHkmb6zr9GcFAWoTMEajNysRLfW3FqbR9LnNGIRgf8W85iNZ0vhaZziBHcDK2fJCnkt1XjVvv93iCeV6E2fqmQ1xgUAZ8YyoNfwn2fLimNvzdw0CHyAAOLfu/htQzRvVHCcJWZBl2fZNeQA4q5FpnVG
 hx31iz+5
 81KDnQSvoN7ZArXVG4tvQw6dtUK9zRS+golzWTpUYHaZKB0HuCa5kvCvRhdiePMFxWYtKamB4nLHmZr2fjEue0pYZ5nKxOQXdORNm8zLSWnZLklGSR/NnAmKRU+5hOF8iaNwi2TbOmyh8RCu58HeS+onJ8sateOiBWSKpQmEUXyoANm+d0tY+mrsIUYCgdp6VKxmVOZTe165DxGGKHNAiA0UoW99aADEoEnTnBxCojODySFq8ffcQYI/cU7CZVJ12ekZkC13ea50E/F5wCJ5FRllV5JUrg5OWrmq+ya6DlvqD1dsSKtbNOdX3sGHKjsWwGx64mlEFqiSJ+xTQogbbTn4zQtYs4gQd/wz5FUoPM/KZ3PDj86aiOjZrdMDHxQMjzfBXf22k4wcwDQ3EitU7hcvCWDzn7esVIVJd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 17:19), Yosry Ahmed wrote:
[..]
> >  Additionally, zs_malloc() does not return a dereferenceable pointer.
> > -Instead, it returns an opaque handle (unsigned long) which encodes actual
> > -location of the allocated object. The reason for this indirection is that
> > +Instead, it stores the encoded location of the allocated object in the
> > +provided ``struct zs_handle``. The reason for this indirection is that
> 
> Should we explicitly call out that zsmalloc will keep a back pointer to
> the handle and update it asynchronously, so the owner shouldn't modify
> it, and should keep it allocated until zs_free() (or rebind)?
> 
> Probably somewhere in the code comments too?

Yeah, perhaps.

> >  zsmalloc does not keep zspages permanently mapped since that would cause
> >  issues on 32-bit systems where the VA region for kernel space mappings
> >  is very small. So, using the allocated memory should be done through the
> > diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> > index 693c9484b638..6c76fd10344e 100644
> > --- a/include/linux/zsmalloc.h
> > +++ b/include/linux/zsmalloc.h
> > @@ -14,6 +14,7 @@
> >  #ifndef _ZS_MALLOC_H_
> >  #define _ZS_MALLOC_H_
> >  
> > +#include <linux/compiler.h>
> >  #include <linux/types.h>
> >  
> >  struct zs_pool_stats {
> > @@ -21,16 +22,39 @@ struct zs_pool_stats {
> >  	atomic_long_t pages_compacted;
> >  };
> >  
> > +/*
> > + * zsmalloc writes object location into the handle and updates it when
> > + * the object moves (compaction, page migration), so the handle must not
> > + * be on the stack and must not be copied.  Use zs_rebind_handle() to
> > + * move an object to another handle.
> > + */
> > +struct zs_handle {
> > +	unsigned long __private obj;
> > +} __aligned(sizeof(unsigned long));
> 
> Is alignment guaranteed even if this is embedded in a packed struct? I
> wonder if we should have an explicit alignment check in
> zs_malloc()/zs_store(), and probably rebind too?

I guess only run-time check will work.  I can add those.  I wonder
if we actually need to worry about this, neither zram nor zswap use
packed entries, but I think it's cheap enough to make sure in run-time.

> > +
> > +static inline void zs_handle_init(struct zs_handle *handle)
> > +{
> > +	ACCESS_PRIVATE(handle, obj) = 0;
> > +}
> > +
> > +static inline bool zs_handle_is_allocated(const struct zs_handle *handle)
> > +{
> > +	return READ_ONCE(ACCESS_PRIVATE(handle, obj)) != 0;
> > +}
> 
> Can this ever give a false negative?

That's a very good question.

> I believe that's only possible with pfn=0, I don't know if this can be the
> case on any architecture. Should we use something like OBJ_ALLOCATED_TAG?

Yeah, I don't know, I guess would be better to not rely on "pfn cannot be
0".  Let me look into this.


> > -struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
> > -			    const int nid);
> > +int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> > +	      gfp_t flags, const int nid);
> >  void zs_free(struct zs_pool *pool, struct zs_handle *handle);
> > +#ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
> 
> FWIW, I don't think this is buying as much. It's one function that is
> only called by zram anyway.

Ack.

> > +void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
> > +		      struct zs_handle *src);
> 
> A few comments in zsmalloc.c mention zs_free() reading the handle
> locklessly, do these apply to rebinding as well?

Let me take a look.

> > +#endif
> >  
> >  size_t zs_huge_class_size(struct zs_pool *pool);
> 
> [..]
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 397b06c9f33b..f28a46cae1e1 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -215,7 +215,7 @@ struct zswap_entry {
> >  	unsigned int length;
> >  	bool referenced;
> >  	u8 pool_idx;
> > -	struct zs_handle *handle;
> > +	struct zs_handle handle;
> >  	struct obj_cgroup *objcg;
> >  	struct list_head lru;
> >  };
> > @@ -769,6 +769,7 @@ static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
> >  	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
> >  	if (!entry)
> >  		return NULL;
> > +	zs_handle_init(&entry->handle);
> >  	return entry;
> >  }
> >  
> > @@ -787,7 +788,7 @@ static void zswap_entry_free(struct zswap_entry *entry)
> >  
> >  	zswap_lru_del(entry);
> >  	if (!WARN_ON_ONCE(!pool)) {
> 
> This check is mostly defensive, and if the pool was ever NULL it
> prevented a NULL deref, and potentially leaked the underlying zsmalloc
> object, which is mostly fine as the pool being NULL points to a larger
> problem (e.g. corruption).
> 
> However, if that happens now, the handle pointer in zsmalloc would point
> at the zswap entry after it's freed by zswap_entry_cache_free() below,
> potentially causing a UAF. It's arguably fine as it's just a cascade of
> corruptions, but I wonder if we should just bail early and skip all
> cleanups below if the pool is NULL.
> 
> We'll leak the cgroup charge, stats, and the zswap entry itself -- but
> that's arguably the safer option if we already have a corruption
> problem.
> 
> We can also just delete the NULL check, but it's cheap to keep and I'd
> rather have it tbh.

Sounds good, let me reshuffle the code a bit.

