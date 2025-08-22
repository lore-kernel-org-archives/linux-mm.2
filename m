Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FAECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F69E44014D; Fri, 22 Aug 2025 12:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7488E009D; Fri, 22 Aug 2025 12:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F6644014D; Fri, 22 Aug 2025 12:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C888E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:56:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5884140249
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:56:55 +0000 (UTC)
X-FDA: 83804997990.06.03D261E
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D08811A0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:56:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XNjvbHtT;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755881813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7+mb346Ky9SrnqlMzxSuOIuQ43DVNmx39imjsZeCx8=;
	b=wOy+FCokrf4D5zIO36TQvaocrovgi9b5yN2FCMRZGkSPz13QMIDCZ/HCAWZkhw2eMmxON7
	kOkoQpElGmghfXwyw6fOSFA0O1y6eEYZmt4koKOWrtFR8576DGZAFmzIMwv7IFK78i7Spj
	KKqZNPyrLfYhFe7UxjXxTpdKqjxlYRA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XNjvbHtT;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755881813; a=rsa-sha256;
	cv=none;
	b=qVcSUj5UzJl3fp0KqHsLF+goovQ6DqjBG5pUqIWrZ00JRSENyGvm4aRqSpSHzfCOztzDMJ
	LL2XX4auX5zzFngDfKVRafPV0UtiU0x6RQUEaEGJQWS8PSTnNjh8rqe6jQHCv9iekwQa5c
	D+dVZzQ0QA5N1rmG2iG1zTQD1EJkcVI=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b12b123e48so15681cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755881813; x=1756486613; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7+mb346Ky9SrnqlMzxSuOIuQ43DVNmx39imjsZeCx8=;
        b=XNjvbHtT/GkE3JPRm96yIetiZr6u5KAk6NK+1kmu42rAaS1sRyxml6TYCu7/QoQyMJ
         zlC/xu72N6PxtfnstejCGUd7UKSsJV96ZcY7w7l1Sak3CO/07hNwAr2hV+ljKH7ZtR+s
         WwRxT/7U5g75i0oXv5FMIfp8iDL8FjTbasUxxjrBUYTyJufeQ5Mi9Ka9Zt3ZQSjR/sBi
         /8kqMMPPZnZbwnrPGCfBZTeokO4rBOON4VN42D1pELFLZ/3DYLGC814DLEbM/VQEzeIM
         Lsz2AhyZoSifzLtx/P/P5CafaPSfR12Y8GEAjeDfiEH9Mu/swut/Fba8nt2HvNXZR6UO
         9Blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755881813; x=1756486613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7+mb346Ky9SrnqlMzxSuOIuQ43DVNmx39imjsZeCx8=;
        b=wob8l/FKvcOFNAoSz0918HDq8t1pDODVOL1+49uPA+kaqeVfySSrmyDxMcIiKYPz0F
         sO8gYY3bw1Z70qRntxYYlEEGVap83svkFAi3v4O0zQl1Q8KlSOa7JHOhpI/oBalS9C1K
         q/H/tM8FNEkCLj1ZHZdBhQUXOYM/5NvXs4+8iPFngNkyoAyiwLCZ0B+ReUbpvpqe3Gi5
         vX7Xf+Cb8C2GTCbqfyWqsZXQJOk/OZR9c6iMjdLZ/57BScJ9gYmKVkrBcSoHxP9MwgV1
         hAUbcxC6uN69DjsGurwEeU56hCSyEUeuhKpngCW/L3YO9e/edyOZJccBe7J9zSmofhPb
         N86Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWjAESJLQI7fwMKmvgefKaFEuc/o3lqwF6Tb9laLAgtG1EEQ0BHHCxsUJvi0Z9NowYk/t2IVSo4w==@kvack.org
X-Gm-Message-State: AOJu0YzeNhV3XaoqTOCbTuo41AYY0YfWNDQaftY2zMzydW2RmOUc+ME2
	4zqTbLRj8UhJadTA8Ms7YzSwk4U4A3x9cdmA4zxZTQEIvchtRhbZXeI7ZANP53GdA1KsD78bmMk
	jqyicR98aEj6T0GzZ49hbT3JYlABpeNuDZ0VxapXK
X-Gm-Gg: ASbGnctLwgh8Y2lf06edjlGOT7rmxgvxHvGxGSE3GsM+HnE1Zdkd4/kZR0/l30uBgWB
	IK5vwkoN2iGmLRmjeFXpp+QnK79qej8bbRuu1Qk2TAtdfOuKHfwlaQjti3Z9InnuKn5v+9O8hMy
	LphP2XcuonJkRMRvks9Ub5ox7diIJKkyC+j6xj5ZLbEHsxjb/7/RJAA+mW9Re97G0e3YoZ9TjAx
	V5hQaio6VQKIVqV2Yaghgc=
X-Google-Smtp-Source: AGHT+IGw7Pkt+nPa5BqQmI3rSxIkNU+66I2ZSYPqvhJbttn+d3hLj7BStxnMej4LA7KUyYMX/ZtTCnEAprY29Edcnos=
X-Received: by 2002:a05:622a:28a:b0:4a7:bed9:5251 with SMTP id
 d75a77b69052e-4b2ac55b35cmr5874671cf.9.1755881812465; Fri, 22 Aug 2025
 09:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250723-slub-percpu-caches-v5-6-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-6-b792cd830f5d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 09:56:41 -0700
X-Gm-Features: Ac12FXx75l6CZ6aDpuoDjkLGCAv-mu9WsReIJ33ovw1NXAgsqe14IMrJ0Uqvw-s
Message-ID: <CAJuCfpEsVE7Jae7PqWvgTtm38C5MPFx43+dDyYzfKLMQFuE_3A@mail.gmail.com>
Subject: Re: [PATCH v5 06/14] tools: Add sheaves support to testing infrastructure
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qqt8bxzdwx7esg7n5hw61dhnen7ju7cf
X-Rspam-User: 
X-Rspamd-Queue-Id: D08811A0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755881813-899553
X-HE-Meta: U2FsdGVkX19BTHWO2OoG0/IDavGaj2clI9QYaAarQ8QC4Pip3kQn7C+eJDozQvCPpO+1lcDUoCueUnQZ4RVQKURYFzNhk+daMKM9pDJG2LntYH/wIVUYoQ5X64mLKG0nwFgkYXJ45EH8wxW6nRGwtpof9WkQ5DwpSqEqsPgc3BYy6f0BjyBq4dSSR98bGWfa3VWSyZUwyDncTf+++efFU3QcT5Wi9olKGkUZ48vf3xDG6d/UC1V8CU+UK0PwwMGhe2QODho0ZVLPcjh8BLvApmiS3wCmfTh5exp4SVFkvy8TDxLcpF/I5/GoN+mgNkYSX1vfldNW8Onfh6wdv4V++LszJCWhyaFmeT9spEp9mP/sue5lcn22zn5rY86id5iCaz1T2f0jJtx/D0qembOxeQXXDfA3Q07M+fsoWpdE6QeCqjzGmiFOmpuOJRMvNK4GYd2ywuhuT8YdV7sHrktNqr9zPNtgttw3dSJwjzc5FZvmT3BRNdyIn700kyU1Km2QyRso7DcuVqeOoy7OFY/0zDPt7U3c1uRoGIBay/RM4Sp49J3kMJ16BpCs4ytGi6k6xHLRIuaIJyy5X0U5ZakUuAwKNnoyGrzogjU15rf3T0oljGAO4bSrJoYT0jYwmKedIFnMRnrjnb8icxN87ceQO+NpYDoijsp26dFfM8xaWtsXkkvRH9L9a+EgyzovobwhgzcDcTFqyS9pBmOcXuAINs4dS6AV+PyL4c76GKTctHRz+bCYJad0jrhDKGm3b6d27CxRHZDvt4hk1E6OOa78CLxZAohphuKVS7pr/5nIUfCiHN38R1k34w4DFaXwhiekzQbf2l4fB9GTcWTgifU1UmT2BDhkhfYrg8ZES0OLicWgs20m8e+jRbYXAqjXW4A2bk/8ZnX1tSRBnb2fGo7gJcKPKBfoEVy34NTFSsq7CWi4CiYJWmxywZUoNdJOfzCEU3MlRaGGCUMh+D6FTy2
 3uB7ZuWe
 rcUfRU+JgwiHr1VViooEFNh7AegBDpMPgIfDKtj+bbCDWQz0xy/jhQjubDz6V2Xq10AsUI/+xsJmOcXUor1XCjDH+RjsjJRNVxDg4CR9IX6gVu0bNye57ApaUByx6cgSys/uBe2d1ZCwwZ9wliJB1s8ZSF3SJVMf+t6IaUa9JIq5H9gE1/o/Lk6h/j0T3kE5kC475hi36h8zG0DdjNLnz2WBSmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
>
> Allocate a sheaf and fill it to the count amount.  Does not fill to the
> sheaf limit to detect incorrect allocation requests.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  tools/include/linux/slab.h   | 24 +++++++++++++
>  tools/testing/shared/linux.c | 84 ++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 108 insertions(+)
>
> diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
> index d1444e79f2685edb828adbce8b3fbb500c0f8844..1962d7f1abee154e1cda5dba2=
8aef213088dd198 100644
> --- a/tools/include/linux/slab.h
> +++ b/tools/include/linux/slab.h
> @@ -23,6 +23,13 @@ enum slab_state {
>         FULL
>  };
>
> +struct slab_sheaf {
> +       struct kmem_cache *cache;
> +       unsigned int size;
> +       unsigned int capacity;
> +       void *objects[];
> +};
> +
>  struct kmem_cache_args {
>         unsigned int align;
>         unsigned int sheaf_capacity;
> @@ -80,4 +87,21 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep, s=
ize_t size, void **list);
>  int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t s=
ize,
>                           void **list);
>
> +struct slab_sheaf *
> +kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int s=
ize);
> +
> +void *
> +kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf);
> +
> +void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf);
> +int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf **sheafp, unsigned int size);
> +
> +static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *shea=
f)
> +{
> +       return sheaf->size;
> +}
> +
>  #endif         /* _TOOLS_SLAB_H */
> diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
> index f998555a1b2af4a899a468a652b04622df459ed3..e0255f53159bd3a1325d49192=
283dd6790a5e3b8 100644
> --- a/tools/testing/shared/linux.c
> +++ b/tools/testing/shared/linux.c
> @@ -181,6 +181,12 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep,=
 gfp_t gfp, size_t size,
>         if (kmalloc_verbose)
>                 pr_debug("Bulk alloc %zu\n", size);
>
> +       if (cachep->exec_callback) {
> +               if (cachep->callback)
> +                       cachep->callback(cachep->private);
> +               cachep->exec_callback =3D false;
> +       }
> +
>         pthread_mutex_lock(&cachep->lock);
>         if (cachep->nr_objs >=3D size) {
>                 struct radix_tree_node *node;
> @@ -270,6 +276,84 @@ __kmem_cache_create_args(const char *name, unsigned =
int size,
>         return ret;
>  }
>
> +struct slab_sheaf *
> +kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int s=
ize)
> +{
> +       struct slab_sheaf *sheaf;
> +       unsigned int capacity;
> +
> +       if (size > s->sheaf_capacity)
> +               capacity =3D size;
> +       else
> +               capacity =3D s->sheaf_capacity;

nit:
capacity =3D max(size, s->sheaf_capacity);

> +
> +       sheaf =3D malloc(sizeof(*sheaf) + sizeof(void *) * s->sheaf_capac=
ity * capacity);

Should this really be `sizeof(void *) * s->sheaf_capacity * capacity`
or just `sizeof(void *) * capacity` ?


> +       if (!sheaf) {
> +               return NULL;
> +       }
> +
> +       memset(sheaf, 0, size);
> +       sheaf->cache =3D s;
> +       sheaf->capacity =3D capacity;
> +       sheaf->size =3D kmem_cache_alloc_bulk(s, gfp, size, sheaf->object=
s);
> +       if (!sheaf->size) {
> +               free(sheaf);
> +               return NULL;
> +       }
> +
> +       return sheaf;
> +}
> +
> +int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
> +                struct slab_sheaf **sheafp, unsigned int size)
> +{
> +       struct slab_sheaf *sheaf =3D *sheafp;
> +       int refill;
> +
> +       if (sheaf->size >=3D size)
> +               return 0;
> +
> +       if (size > sheaf->capacity) {
> +               sheaf =3D kmem_cache_prefill_sheaf(s, gfp, size);
> +               if (!sheaf)
> +                       return -ENOMEM;
> +
> +               kmem_cache_return_sheaf(s, gfp, *sheafp);
> +               *sheafp =3D sheaf;
> +               return 0;
> +       }
> +
> +       refill =3D kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
> +                                      &sheaf->objects[sheaf->size]);
> +       if (!refill)
> +               return -ENOMEM;
> +
> +       sheaf->size +=3D refill;
> +       return 0;
> +}
> +
> +void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> +                struct slab_sheaf *sheaf)
> +{
> +       if (sheaf->size) {
> +               //s->non_kernel +=3D sheaf->size;

Above comment seems obsolete.

> +               kmem_cache_free_bulk(s, sheaf->size, &sheaf->objects[0]);
> +       }
> +       free(sheaf);
> +}
> +
> +void *
> +kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
> +               struct slab_sheaf *sheaf)
> +{
> +       if (sheaf->size =3D=3D 0) {
> +               printf("Nothing left in sheaf!\n");
> +               return NULL;
> +       }
> +

Should we clear sheaf->objects[sheaf->size] for additional safety?

> +       return sheaf->objects[--sheaf->size];
> +}
> +
>  /*
>   * Test the test infrastructure for kem_cache_alloc/free and bulk counte=
rparts.
>   */
>
> --
> 2.50.1
>

