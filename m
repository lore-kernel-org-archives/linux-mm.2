Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0399606A6FA
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d6WQHGth
Received: by kanga.kvack.org (Postfix)
	id EAB066B05B5; Fri, 20 Nov 2026 14:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B3B6B05B6; Fri, 20 Nov 2026 14:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D711C6B05B7; Fri, 20 Nov 2026 14:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0A626B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:24:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 490EE401A0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:50 +0000 (UTC)
X-FDA: 85456474740.27.3EF600F
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 503EE4000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d6WQHGth;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795202688;
	b=3+HhFs4mt+mpjoZ8epB//382ad9Nr93s956+mJwy3rhm/kjTbOuVKCixwKkZxNazJYCOXr
	zVZPXgk8od6IKiweT9+gdHLeG/XbPhN2/n2d58e0nqNaoZ8QCMiPotgEVejYymURT6FHsp
	VGbu5z4zhzDLZiBNnpOATP48hu8wnbA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
	b=Al1RbCpUhMa4iCFxKFwDLrmSswKaI7efRJHK/kDQhasTYb7gDAVkzGlgEQpX6cSNTjmE7p
	MdTrgGoqtsm206sbouRdD7vZb36ft+gM3NstrE9QQZejYSFfT7y1zRya28zqhDqPjTRLmc
	HHhDzHhY1lnNRjfjdD7bToZ2Ura8K/A=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d6WQHGth;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c151178f0cso1387833e87.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202687; cv=none;
        d=google.com; s=arc-20260327;
        b=qO5BX9Jh3MXtniCE/+mNPPP2B9IcG6Ua+yAG2hQQO72X+0XVHXXxJVYtqDM9tD+nlH
         +8saW0GlwLv/zpx2k1fNnJIEMhZSAp/lMWQM6fTMoztuvJ0ap4weyDa1LaS/uscj+G34
         knfStm34AtaX9P0gOxU5CALg/GzDimwzqFGu9RTkm0YM8h0byDpqtCdxMpxygZ0C+Y+r
         E2SX1w4iDWnNDBiXJ0/iy+g5J7VG3tPvSdOUIPWRfeEWjbR3wqdJTxjqwPf5DYRhWxUB
         Z0seVC8VTTMlGlruwG1U1oQZhnJ6LurcJJEQzoMDS+h6ta6UHu5PQ4T8Ny6lDgq90feo
         CeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        fh=3VHfjlUAJIP5Af3hbCF6ntouIYCyDHstIzvKNOHfUEE=;
        b=lDkTy3Vj+rdGsL1ER1cj6qgjowrifO4d2J1oG16C6s+Af25eZiE6wbLLZuy3cPLgP2
         q4iaPxoh4gfuHhSrFTUkS3SMYV0s2EhBfpYXTEyOxOzr6Xk3QzZelBV3PsnaAKHuA5Nq
         NgDrdvQaQ/s5n69BJ37WBlHEnu9g06OtuB+94Q2gbeaGXih7jKPNQFz5cAoQVWpDxu1l
         IgGBZ+s67OCAYn1iqEatZ7rNkSIlrZfesg6oHpsk/A9j6WiYXm/DT+jI+gb2oRfv9uNe
         mec6/fsTcRAICl5ek/P2WZZAw67LZtReHiHkjdX91vtb8XzANcNTLlTfKZ50K0iBn2ID
         GU7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202687; x=1795807487; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        b=d6WQHGthMha57C0Abikr16sC0CJKrp/5yTplNQUdGgXz2NzCU1fNiFb3jkPykcZi/S
         jq8flcg56vDw8tofuDiH9NUVYXFIwN0+n2Z2eZNjFFwCAIgt06rkPwOmJ+ydiC1jA4B3
         qxdb3YLubvFJlWPfBLG4DWfK7624Z/M610K1CpYZDeNKqa/7e6c3uNLYXy2/milp1Xen
         L3TlI3+R2OKpTYa6XB+Q11zbpZ4MMLYx/QIfTrPJCDC/qnzuyTrTzazxnHPhNMzi8Gko
         HMUdJwnPR+TGNO1c5FXJebSpE/+V5hTRo/W5PFg+fzkfH+l51uGD0fBwDKrbkUvWvCGi
         dChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202687; x=1795807487;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zWIxONUZeQvHjISuRSptZ8FC7xw6mAb5ZCwaWbc76g=;
        b=eqN2aBdMtVCA/Q9T/SVE0PsTdx9xzD0xWSWxYlHxAFNg8K80tWxjecmlYBhjL7TyOw
         n8RCKXzVRtT5U8Rg/NLLtxB04yMmPbOFx/7lZJoNsqbvFQaE6QB+1bQrI/alqnW+zhtq
         3rH7EMW3ejfq9MPmZbVjTFMqHlpXkhN+k0uv7IirA4j4heDJPNxUQKWkPRvcCXv+B6Y8
         lYkThaa8HZ7nVISF76GsFtpA8RZfI4eloIAGKkqHbCsm/sKpkR7Tll5lxxZErgRrgkG+
         bW0ZnQQEmc8DQ3PV+/MP+m0YhRCIFXIfCECD5yKk7hSXV3B8QslgNBun89AomVkeXQsF
         drHw==
X-Forwarded-Encrypted: i=1; AL+hErHLGg/K6jL/oCpleKCeKpHAWlE7CzxBS58ra7E0f0C8sHwGgcs1DMCUXGFboWrxHaKF7nN7sqZz+w==@kvack.org
X-Gm-Message-State: APuU4Z82QaRkfxQCAQZ6n1OWNd1yuUtbJCFENqr4B0oYSaviJiko+e8z
	gUF7AgopIKV7OlYlkw+IrnoBMVLu1Uhd4YqgdRhC5LtMle8kdIwDid5k72VejDS9vF49+Y+JcyE
	qm0bCffhg7pvULUUSsP0P3UsM8omE0f8=
X-Gm-Gg: AZFdTZdx+D9e8yM/J4igT3lrIK7SPtOxPB/Qb9BapgYA6RkavFryU2tW6PyO7eJVFxD
	AK7VESQSNmok1hLi5Fi5WewHgdM9BVhlQMQ0Ysx4K71ILs7NCULkMxgdj8ZvcnOsRK1hW98Ic/u
	TOdgemR/fdTMCrrgBmN1qXrOs+s2zQT4gqrofGX4d4ihy1YtFxtcyoky6D6ePnnyGprbDS+wYO9
	FhccwQNU+rC5MCb/YdMZyVjczyxk9YgkSuhgMvgBdbJMcKZggEe18Nxj7SNRwuL/jnTxQVoeWHY
	we9lXDKIzE8cyF3bfzC0o5sQECnrRuM8gUcoF+N0LEKWuX1VLKs30MzbfqJiiSK9tyArSQVK8wE
	Dvl1cPrmTzHl2cZkmkaxkImV9ItoVlGJsHMgcTLm8Kj46uiOSrRdmYv+yDw==
X-Received: by 2002:a05:6512:3087:b0:5c1:4a42:fb17 with SMTP id
 2adb3069b0e04-5c1bc89ed7amr1304224e87.59.1795202686629; Fri, 20 Nov 2026
 11:24:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202714@kernel.org>
In-Reply-To: <sashiko-outbox-202714@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:32 -0800
X-Gm-Features: Aa3M54ouMN2ITwFj5M9g2-yqpSHQYsFb1T7wXbDyaNC29TFae9jRHTQF_lWNW-Q
Message-ID: <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qwzt1snaijokgd3skyby8okc6ka46jta
X-Rspam-User:
X-Rspamd-Queue-Id: 503EE4000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795202688-388473
X-HE-Meta: U2FsdGVkX18MWntE8rV/l0Gbq7Ys/KZIcHjPjhwmTQKkPUCiToeLMCHuoafG8omCbE8wUBfz0NevLQ7glFR7vOLiUGBXcbyi7l15ynEA33lbHD47aA/M/jxXYFCViBXyEPyfi86UL/JAEC7vVOVOf8gjuCHCzAiPZEK7fQcirRgTKdVrVGhz4eZs8BrG86cRwJum8Txb43NbiAake6hqQ54YeJq3EITJ4EBVTaZ7ZWgpJzc0/+RULTKoyB7Ok7Y5PiYbs3X8jXgBNBciS3h98dfD7e2W6nJtdix8RE5Ychv+SAc53vmOLE1vCxqsnL4gGb3N5Q2xccwjZ1xA3uhughDhVSqdY8H90s1dzVM6sI6zKqSvZR0grEsgJQBDG1VrlDZeyIKvLKALZDZcD08nwprDakiZ3CSLGaoaV4KaGcbVQrP/3pZ85VjmH9GYmNezZ/xot/O6QRSNlFIZxt7ZWOlPRISCtJSbO1Y87GxKdDOOvLosrlJZxhVdbxwzgiflXQ+8/OzyJRkvMXOJXqjnOdoNl4Vz++sR16zHtdcdFT/AoMv6BhwKyoR/pJhtDLXA3kaps08HlARA7HHf9FnGngcuU0c9U31JNQDe+0Hmdv0qLBq3QNNmqhCS3u/2XxQ8k/WWUSZekFlPkIHQ47wrqoDTBmHTpvAFqw4pcv8GNamd6n8+M7SZbr+JvLkXFVp14MkdGv3wYR24w9A4TWmEhvsbvhqZeg0eNcCitZFZB9tyktg6uw5fr06FubFz/EbXOF8gOSFiLUht8IVhz/Hc3JLCrOgVXX3e85Ezek8oRIEDJe2f+FSRIxBBlYQvh5KR+IT2oU9BdLK6NpJK7kd+RMnJH0xIzN1lnxLdu9f2P/LmlI5+HaEM/YNkgKqJF4TwxIwl9xvq4usqcMMw68QCCTt3Mjh1vJqRnfLPyRYlEztpxwRqgiHhd+5BsILjEr7eQP9JDAI4ExeLN3yqnwC
 CuhjvVtj
 Hv6Ay+Z6i3bkmXzaS8HJ1cmcMQfQQr4fBd+2IAhfHqoW/sifqXcAwqvKQqS9ugHO0W6dSH5Bju0zb3O7Pj5k/wU8KfXNsLQPmFvTgNHwuNLa66qR+InOGrSSeLlvaNnH8OKxRcKkImpS0aip/lVqPQGDpo/GXSReYyDnS+ZRSBFMjRATKXPSUZaFKcuJk91w4koo53kX3FQeT++6lX34+A1tNa3bMjCCxHfo4Bp9i9CunwaxseKczK0ylKFkQ84HLiDcKfhbIECIFgVx6rORFk6cjZO+1i5PdhH1YREv+oiTg1uZOKOa4aZLfJ5uMJIxCSdpCLA8lcbOghewV53t+1mCxMUNzTe5K/RcsX85KQgeWsl1JWxGUl3Oz1DxCIB5safqXIIYjy1mSsVeRZumoh8H7wtxWlqa7BfKBMKZbwrBV3ysK2/W+Y1PQA7xXx/1xb6IJMr9DQWcri6ZhxLrP+Yux2/eMvne+/6D/6SLiCFN9GyWAOo1sHvHZMR7xCix3Yu42lqyOAlqDbDpV1rIwkSUWqHYU95YnWJsHtzfnvaGLMNU/yH2VvAdUhFqjxogp2Bd32lGNx0HEm/EdjuJwLsMeupgUvktqcSKltd6BGlySHMNPsKKrwC1EzzeBgxJXzhuWbJDmwYEwAcznnzVVMCekCdA4TcP1stfjeW8PphgfUkF4McTCMzDUn582BeaMS8akt7A5duv3pT4CcVCgLmjkemYOrVQzGroDS+yD7vyjHHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: corrupted and unterminated dst scatterlist in
>   zswap_compress()
> - [Medium] mm: zswap: unclamped nr_batch_pages on remainder batch in
>   zswap_compress()
> - [Medium] mm: zswap: unsigned sg->length check mishandles negative
>   errors in zswap_compress()
> --
>
> commit 212f5740068394b4c82b7b1e5452b1ac6625322f
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Batched zswap_compress() for storing large folios in batches.
>
> This commit replaces per-page zswap_compress() calls with a batched
> implementation that compresses up to ZSWAP_MAX_BATCH_SIZE pages using a
> per-CPU scatterlist table and updates the batch entries in
> zswap_update_entries().
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5ef1ae67e67a9..45fd8dfaf916d 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -898,6 +914,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>
> [ ... ]
>
> > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_t=
able),
> > +                                        GFP_KERNEL);
> > +     if (!acomp_ctx->comp.sg_table) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE=
,
> > +                        GFP_KERNEL)) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     /*
> > +      * Statically map the per-CPU destination buffers to the per-CPU
> > +      * SG lists; crucial for performance.
> > +      */
> > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SI=
ZE, i)
> > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
>
> [ ... ]
>
> > +static bool zswap_compress(struct zswap_store_context *zc)
> > +{
> > +     u8 batch_start, comp_batch_iter;
> > +     struct scatterlist *sg, *dst_sg;
> > +     int err;
> >
> >       /*
> > -      * it maybe looks a little bit silly that we send an asynchronous=
 request,
> > -      * then wait for its completion synchronously. This makes the pro=
cess look
> > -      * synchronous in fact.
> > -      * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> > -      * acomp instance, then get those requests done simultaneously. b=
ut in this
> > -      * case, zswap actually does store and load page by page, there i=
s no
> > -      * existing method to send the second page before the first page =
is done
> > -      * in one thread doing zswap.
> > -      * but in different threads running on different cpu, we have dif=
ferent
> > -      * acomp instance, and compression and decompression use separate
> > -      * requests, so multiple threads can do (de)compression in parall=
el.
> > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's compr=
essor
> > +      * batch size and the @zc->nr_pages in this store batch. @slen in=
dicates
> > +      * the total source length bytes for @nr_batch_pages.
> >        */
> > +     zc->nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr=
_pages);
> > +     zc->slen =3D zc->nr_batch_pages * PAGE_SIZE;
> >
> >       /*
> > +      * Compress the @nr_pages in @folio starting at index @folio_star=
t
> > +      * in batches of @nr_batch_pages.
> >        */
> > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > +          batch_start +=3D zc->nr_batch_pages) {
>
> [Severity: Medium]
> Can zc->nr_batch_pages exceed the remaining pages in the store batch on t=
he
> final loop iteration?
>
> zc->nr_batch_pages and zc->slen are computed once before the loop instead
> of being clamped to zc->nr_pages - batch_start on each iteration.  If a
> compressor has a compr_batch_size that does not evenly divide zc->nr_page=
s
> (for example, compr_batch_size =3D=3D 3 with zc->nr_pages =3D=3D 4), the =
final
> iteration reads past the end of the folio batch and walks past the SG_END
> terminator of zc->comp_ctx->sg_table->sgl in for_each_sg(), causing a NUL=
L
> pointer dereference when sg_next() returns NULL.

Thanks for catching this. I have resolved this and will include it
when I submit the next revision.

>
> > +             /*
> > +              * Send @nr_batch_pages to crypto_acomp for compression:
> > +              *
> > +              * These pages are in @folio's range of indices in the in=
terval
> > +              *     [@folio_start + @batch_start,
> > +              *      @folio_start + @batch_start + @nr_batch_pages).
> > +              *
> > +              * The source folio pages in the batch are directly submi=
tted to
> > +              * crypto_acomp via acomp_request_set_src_folio().
> > +              */
> > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->f=
olio,
> > +                             (zc->folio_start + batch_start) * PAGE_SI=
ZE,
> > +                             zc->slen);
> > +
> > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > +             dst_sg->length =3D zc->slen;
> > +
> > +             /*
> > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are s=
tatically
> > +              * mapped to the per-CPU dst @buffers at pool creation ti=
me.
> > +              * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and ds=
t
> > +              * buffers allocated for all compressors.
> > +              */
> > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> > +                                      dst_sg, zc->slen);
>
> [Severity: High]
> Does setting dst_sg->length =3D zc->slen corrupt the per-CPU scatterlist =
table
> in zc->comp_ctx->sg_table?
>
> In zswap_cpu_comp_prepare(), each entry in sg_table->sgl is mapped to a
> separate PAGE_SIZE buffer and only sgl[ZSWAP_MAX_BATCH_SIZE - 1] has SG_E=
ND
> set.  During compression, each entry's sg->length is overwritten with the
> compressed size or a negative error code.
>
> When zc->nr_batch_pages > 1, setting dst_sg->length =3D zc->slen tells th=
e
> compressor that dst_sg[0]'s single PAGE_SIZE buffer is nr_batch_pages *
> PAGE_SIZE bytes long, while dst_sg[1 .. nr_batch_pages - 1].length are ne=
ver
> reset to PAGE_SIZE and retain stale lengths or negative error codes from =
the
> previous batch.  If crypto_acomp_compress() fails while zc->wb_enabled is
> true without updating every entry's sg->length, any entry still holding a
> stale length in (0, PAGE_SIZE) bypasses the sg->length >=3D PAGE_SIZE che=
ck
> and causes zswap_update_entries() to store stale data from the previous
> folio.
>
> In addition, because SG_END is only set on sgl[3], passing dst_sg =3D sgl=
 +
> batch_start leaves 4 - batch_start entries linked in req->dst.  Hardware
> acomp drivers that check sg_nents(req->dst) or DMA-map every entry in the
> scatterlist walk past the current batch into trailing entries whose
> sg->length may still hold PAGE_SIZE or (unsigned int)-ENOSPC (0xffffffe4)
> from an earlier failed compression.

Sashiko raised this in v2 code review. Please see my follow up comments in:

https://lore.kernel.org/all/CACpmpofOE797D7f4YGZEJ2jtHn08d9Jo8Ya3cdV8h9UL5h=
Ud9A@mail.gmail.com/

and let me know if this explains things better. Thanks.

>
> > +
> > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
> > +                                   &zc->comp_ctx->areq.wait);
> > +
> > +             /*
> > +              * If a page cannot be compressed into a size smaller tha=
n
> > +              * PAGE_SIZE, save the content as is without a compressio=
n, to
> > +              * keep the LRU order of writebacks.  If writeback is dis=
abled,
> > +              * reject the page since it only adds metadata overhead.
> > +              * swap_writeout() will put the page back to the active L=
RU list
> > +              * in the case.
> > +              */
> > +             if (err && !zc->wb_enabled)
> > +                     goto compress_error;
> >
> > +             /*
> > +              * For each output SG list in @acomp_ctx->req->sg_table->=
sgl,
> > +              * the @sg->length should be set to either the page's com=
pressed
> > +              * length (success), or it's negative value compression e=
rror.
> > +              */
> > +             for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_it=
er) {
> > +
> > +                     if (sg->length <=3D 0 || sg->length >=3D PAGE_SIZ=
E) {
> > +                             if (!zc->wb_enabled) {
> > +                                     if (sg->length =3D=3D PAGE_SIZE)
> > +                                             sg->length =3D -ENOSPC;
> > +                                     else if (WARN_ON_ONCE(!sg->length=
 || sg->length > PAGE_SIZE))
> > +                                             sg->length =3D -EINVAL;
> > +                                     goto compress_error;
> > +                             }
> > +
> > +                             sg->length =3D PAGE_SIZE;
> > +                     }
> > +             }
> >       }
> >
> > +     return zswap_update_entries(zc);
> >
> > +compress_error:
> > +     for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> > +             if ((int)sg->length < 0) {
> > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > +                             zswap_reject_compress_poor++;
> > +                     else
> > +                             zswap_reject_compress_fail++;
> > +             }
> > +     }
> > +
> > +     return false;
> >  }
>
> [Severity: Medium]
> Does checking sg->length without casting to int mishandle negative
> compression error codes when !zc->wb_enabled?
>
> scatterlist.length is an unsigned int, so a negative error code stored in
> sg->length (such as -ENOSPC) is never <=3D 0 and instead triggers
> WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE) and overwrites
> sg->length with -EINVAL before compress_error: checks for -ENOSPC.
> Conversely, if crypto_acomp_compress() returns an error before setting
> negative values in sg->length, jumping directly to compress_error: finds =
no
> entries with (int)sg->length < 0 and increments neither rejection counter=
.

Thanks. I have resolved this.


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D8

