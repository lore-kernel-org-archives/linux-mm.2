Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6877CC55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1266B007B; Tue,  4 Aug 2026 22:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4237F6B0092; Tue,  4 Aug 2026 22:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8A06B0093; Tue,  4 Aug 2026 22:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E53FA6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:31:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72F2C16033B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:31:39 +0000 (UTC)
X-FDA: 85065639918.06.AB0E699
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7B6F180005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:31:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+tF+BTg;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785897097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zokNAeo5/eK1uMZFofy4rpd8tQkyD2FhGbzXwMe/1Gw=;
	b=graj10BQwpWy5Nx6O6RAOEDAJWdEWrH+jLZ7MBIztLjnXet7tyn7FXGDTjInJ75rdI7Muy
	goLdKUq9pBs7n+qHXfxss/gPGIRPUhWmUeXF3YriANBrhglwKN+EZfwZC35agBqk/tPBhw
	sM0niOqZKZyxLu0Kj+X866t1kACE1Cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785897097;
	b=Y9moJaSHOlvfCVDD/34tMvs7tkqzEOo9jjTRUzbJrDN2I0CIHSCOb+ZZG1yZi7iAkoxaY6
	rV0M8Rq7hMou3dBKU42pzsqU+afdLeOBHQuVSgLhXXbwqVVR259RMWv5fprNoUCIpNnjgU
	LYFbhMblvB8bEM3g1+euFNOmMKNE0V8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+tF+BTg;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25FF960A64
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E251F00ACF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785897096;
	bh=zokNAeo5/eK1uMZFofy4rpd8tQkyD2FhGbzXwMe/1Gw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H+tF+BTgPhHqnMOl3b4yC/zMsYSdtwzUPrz/q6n1JeopCHZrAKoAXKvzK+gtuKrk6
	 VVwAhQmLMINvKBIAKrMJd1cqfKeat0eyNyLXUW/S8kjCm3RqDsJ0tNBnrSQlsNsUvq
	 mBTXZKnobxPStVhtUjF0gF7BMm+jPcV+VgJDcAlNQ0qqOs+dohtFR99YAsQu7EGQzd
	 Iub/qtXw94duqCiMNFEYR1xEf02baOeTgS2heXyG0pN/3N+dTFBXIlrbwYjXvxx+VK
	 HDFIqzEL0+Kehsx70Tf6aux3/9dT8lP9EwIsud5rkfbfKVShTgv8cX4TxJGuo+tpPq
	 89cspnpRvLarQ==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e85499ffbso35736585a.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 19:31:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrBxDtmBtwydXO3EQ+JkPJPewzTTI2vdp8cL6PbYYcJWpTS55Jg2dbNoMtXu8BG6IObc+Fdp3ff4Q==@kvack.org
X-Gm-Message-State: AOJu0Ywc9M7HT5+aeM/nId94/QecTUTeEgNWVtvg+FiKEeJWUukjVjGX
	gxLyeYWdy8bJz5gaWoU9Dfba/vAl1mUYWNClExUDXnwEwJQfc1ebUpcOko+ctkFZXb5zXs19rwE
	ZZjv+aKi0mWMptuJS5QfOETlGrw1wBkE=
X-Received: by 2002:a05:620a:1d04:b0:92e:4799:a808 with SMTP id
 af79cd13be357-936492ba7fdmr294697585a.40.1785897096189; Tue, 04 Aug 2026
 19:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260805005545.66112-1-baohua@kernel.org> <20260805021944.1753869-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260805021944.1753869-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 10:31:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zsnZiVSrQ+bWbmDmjVCa-svsA_hXor2LP1uFFpyomrNg@mail.gmail.com>
X-Gm-Features: AUfX_mzxWvfoWfH-NihfuJkt_g-NHvVcHtgorIhplnkeBGUbO4QmT_Ic69h-4dU
Message-ID: <CAGsJ_4zsnZiVSrQ+bWbmDmjVCa-svsA_hXor2LP1uFFpyomrNg@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, minchan@kernel.org, 
	yosry.ahmed@linux.dev, surenb@google.com, zhangdongdong5@xiaomi.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A7B6F180005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: na5bkdkk8bs76mkzsimjhooicodwwps6
X-HE-Tag: 1785897097-560923
X-HE-Meta: U2FsdGVkX1/sPNJMVyP5R8AJT2tMy0Ps1gJfY/bvGgEIcjEF+j/W9JJ5hUfHBO5A6SPDK6T1QlhkI1IV/ijTjUkdfSJv6v0smevhFL7xwKPedVllSHEsTm91ZR3cucGEOTlzQ2Hkji9IjxIGJguV96zyAEFOx2zGPSCqJAZU3aHr/l8DN4oLjOgcxhD1nlaonD+mAUR51M66KraNZzu0xbClzk8IPjb2UftPNNduFVQy8XVy9SCF00oE/CuuHY0P6GR8TVb9PYlqUMcGJYuS7XO/rZDnS/DzVhANtCJvFFF/J5thLFeXmInUElR3Kx8JnJRbrSlS896LNQ9LBPORNIVv3DKwo3HGluwfjd5eNx3bankpJMauAW391zsYp3kC+rZ+7LNI+tIkNefo094E3iRUvPmHXUQuEdaXfpEwvAV2r5sHt3ya1he02/LPWGeNkB5SZ2ihEzdVTEjnU+KaZI5ZCtxVlpCXFFCxLNcTMrVnRiiI70TAsskmyiJLO3vfnjQ6GQhxGl+H06y4SbaXe/Sx+gR3rYngnVQ8eVurWoLgbTYhHtIlciFBkW+oZXTc/WO/ci1O890rEnk5JkqO59QfI8nyekcIN/T4Nh7/5z+UFBk+8O351ow3QMqGzYzncHJ0811MF6PF0oe1gmCmeZNgXdGKVZUripMKkAIcZ80T6BLaN/KNgD63Im79aa/yGeYzGmyQPG8szS5odchLPlCgfHm23Ko4u1Ram0783c+lJk2MqLjf1gPNSRiJYFVZD3qsi9LcFMxdgWUAqSU6A3ZcGN0AneZIYWpsssOIqAwGNKliO5ZictOCuu+GmZbMyUdPfoyBD+i0iJ35gpyDT3mhAXMUj+PyQJLRkGwkbso1LHphWsGdHDhJdK1B32BlUldgiM6g8s+fSHI7tZqpUXZ4dhDrV32bsn6TpjS0FMN1ZzXfe2rG2jVJvp4hNOuTGbVhU52Ob1Hcg/LiQod
 ah+gU9Jk
 /rpxXK5euWm/+b9LDUn2Z8Vgq25r7L6e3jihN1j+EDfIld2D4Y0dkicUGtYfLXXWUsvTa0aqSO66E7YI/0mAKZ8jKFUhHmzy3UChnMthfh/OJ1kMfGn6aQaHcY2dpRz0wVlNkoZa4JAgJHfAC2pm/pyYrBxjlJ0GHvMTaOlUz3RwvuD7UmthmYF7mXuhfsoVhya8u3RLawrhxIrblehmYEU76T/hoPokvD7yvuqfFGP0ZJ2NrSEhKVVpB3fqeLJwSPj+PHEo46Ic2nlV0wdBVcZaWz2PiaADO56wyamAuylZUeumJa7f63wuLlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 10:19=E2=80=AFAM Bo Zhang <zhangbo0325@gmail.com> wr=
ote:
>
> On Wed, Aug 05, 2026 at 08:55:45AM +0800, Barry Song (Xiaomi) wrote:
> > Since commit 2efa9e9eb4db ("zram: permit preemption with active
> > compression stream"), a major Android regression has been reported.
> >
> > We add an async flag (currently false for almost all backends) to
> > indicate whether a backend is asynchronous. For synchronous
> > backends, we use preempt_disable() in the !PREEMPT_RT case. A
> > zram_zs_malloc() wrapper is provided to support a two-stage
> > zs_malloc() path, allowing allocation to transition from a
> > non-sleepable context to a sleepable context.
>
> Hi Barry,
>
> Thanks for working on this. The priority inversion issue on Android is
> real and we've hit it too.
>
> However, I think there's a bug in the zcomp_stream_put() change.
>
> The new zcomp_stream_put() uses raw_cpu_ptr() to find the stream:
>
>   void zcomp_stream_put(struct zcomp *comp)
>   {
>       struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream);
>       if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
>           preempt_enable();
>       mutex_unlock(&zstrm->lock);
>   }
>
> It relies on the thread still being on the same CPU where
> zcomp_stream_get() locked the stream. In the normal path it works
> fine, because preempt is disabled the entire time.
>
> But zram_zs_malloc() breaks this assumption in the fallback path:
>
>   static unsigned long zram_zs_malloc(...)
>   {
>       if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
>           handle =3D zs_malloc(..., __GFP_KSWAPD_RECLAIM | ...);
>           if (!IS_ERR_VALUE(handle))
>               return handle;
>           preempt_enable();        // preempt is now enabled
>       }
>
>       handle =3D zs_malloc(..., GFP_NOIO | ...);  // may sleep, may migra=
te
>       if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT))
>           preempt_disable(); // Preempt disabled, but it may work on anot=
her CPU
>       return handle;
>   }
>
> If the first zs_malloc() fails, preempt is enabled and the second
> zs_malloc(GFP_NOIO) can sleep. During this window the task can migrate
> to another CPU. After preempt_disable(), we continue on the new CPU.
>
> When zcomp_stream_put() is later called, raw_cpu_ptr() returns the new
> CPU's stream, which is not the one that was originally locked. Which may
> cause a mutex_unlock() on the wrong CPU.
>
> The original code didn't have this problem because zcomp_stream_put()
> took the zstrm pointer directly:
>
>   void zcomp_stream_put(struct zcomp_strm *zstrm)
>   {
>       mutex_unlock(&zstrm->lock);
>   }
>
> The caller always passed the saved pointer from zcomp_stream_get(),
> so regardless of CPU migration, the correct mutex was always unlocked.
>
> I think the fix is to keep passing the zstrm pointer:
>
>   void zcomp_stream_put(struct zcomp *comp, struct zcomp_strm *zstrm)
>   {
>       if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
>           preempt_enable();
>       mutex_unlock(&zstrm->lock);
>   }
>
> All callers already have zstrm available. Then It works as expected.

Good catch. You're absolutely right. We need the following
(will fix in v2):

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index dd4db4a8af73..b7f5127c05c8 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -136,10 +136,8 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp=
)
        }
 }

-void zcomp_stream_put(struct zcomp *comp)
+void zcomp_stream_put(struct zcomp_strm *zstrm, struct zcomp *comp)
 {
-       struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream);
-
        if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
                preempt_enable();
        mutex_unlock(&zstrm->lock);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 5293d638da8f..aa2fd3646018 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -87,7 +87,7 @@ struct zcomp *zcomp_create(const char *alg, struct
zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);

 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp *comp);
+void zcomp_stream_put(struct zcomp_strm *zstrm, struct zcomp *comp);

 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
                   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 52b9fbe3e0d1..8f36ca122e1c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1364,7 +1364,7 @@ static int decompress_bdev_page(struct zram
*zram, struct page *page, u32 index)
        if (!ret)
                copy_page(src, zstrm->local_copy);
        kunmap_local(src);
-       zcomp_stream_put(zram->comps[prio]);
+       zcomp_stream_put(zstrm, zram->comps[prio]);
        slot_unlock(zram, index);

        return ret;
@@ -2098,7 +2098,7 @@ static int read_compressed_page(struct zram
*zram, struct page *page, u32 index)
        ret =3D zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
        kunmap_local(dst);
        zs_obj_read_end(zram->mem_pool, handle, size, src);
-       zcomp_stream_put(zram->comps[prio]);
+       zcomp_stream_put(zstrm, zram->comps[prio]);

        return ret;
 }
@@ -2124,7 +2124,7 @@ static int read_from_zspool_raw(struct zram
*zram, struct page *page, u32 index)
                                zstrm->local_copy);
        memcpy_to_page(page, 0, src, size);
        zs_obj_read_end(zram->mem_pool, handle, size, src);
-       zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+       zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);

        memzero_page(page, size, PAGE_SIZE - size);

@@ -2304,30 +2304,30 @@ static int zram_write_page(struct zram *zram,
struct page *page, u32 index)
        kunmap_local(mem);

        if (unlikely(ret)) {
-               zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+               zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);
                pr_err("Compression failed! err=3D%d\n", ret);
                return ret;
        }

        if (comp_len >=3D huge_class_size) {
-               zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+               zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);
                return write_incompressible_page(zram, page, index, async);
        }

        handle =3D zram_zs_malloc(zram, comp_len, async, page_to_nid(page))=
;
        if (IS_ERR_VALUE(handle)) {
-               zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+               zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);
                return PTR_ERR((void *)handle);
        }

        if (!zram_can_store_page(zram)) {
-               zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+               zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);
                zs_free(zram->mem_pool, handle);
                return -ENOMEM;
        }

        zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-       zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+       zcomp_stream_put(zstrm, zram->comps[ZRAM_PRIMARY_COMP]);

        slot_lock(zram, index);
        slot_free(zram, index);
@@ -2484,7 +2484,7 @@ static int recompress_slot(struct zram *zram,
u32 index, struct page *page,
                *num_recomp_pages -=3D 1;

        if (ret) {
-               zcomp_stream_put(zram->comps[prio]);
+               zcomp_stream_put(zstrm, zram->comps[prio]);
                return ret;
        }

@@ -2493,7 +2493,7 @@ static int recompress_slot(struct zram *zram,
u32 index, struct page *page,

        if (class_index_new >=3D class_index_old ||
            (threshold && comp_len_new >=3D threshold)) {
-               zcomp_stream_put(zram->comps[prio]);
+               zcomp_stream_put(zstrm, zram->comps[prio]);

                /*
                 * Secondary algorithms failed to re-compress the page
@@ -2509,12 +2509,12 @@ static int recompress_slot(struct zram *zram,
u32 index, struct page *page,

        handle_new =3D zram_zs_malloc(zram, comp_len_new, async,
page_to_nid(page));
        if (IS_ERR_VALUE(handle_new)) {
-               zcomp_stream_put(zram->comps[prio]);
+               zcomp_stream_put(zstrm, zram->comps[prio]);
                return PTR_ERR((void *)handle_new);
        }

        zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_ne=
w);
-       zcomp_stream_put(zram->comps[prio]);
+       zcomp_stream_put(zstrm, zram->comps[prio]);

        slot_free(zram, index);
        set_slot_handle(zram, index, handle_new);

