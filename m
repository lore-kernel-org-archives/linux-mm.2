Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF91AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EECA6B00A6; Wed,  1 Jul 2026 00:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6DF6B00A9; Wed,  1 Jul 2026 00:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE7E6B00AB; Wed,  1 Jul 2026 00:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47EE56B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:31:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8522A01E9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:31:06 +0000 (UTC)
X-FDA: 84938932932.27.B518995
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0155940002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:31:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RbxhsYd/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782880265;
	b=MD7tQ1VkAsgiZWJn+x+/5jgZtQpBd7KVndMsKs7hkfCs8zgF0vw20cWMQiNteyUzBy6rSf
	o+86JhImOYc18nBBpdXfmdKihALW2fgivW4eU82/azpIl21kRsRgew2ttAY3ajOUKyi3jH
	cyhUeB3k6riPBywQ2Qs2RWgEupekTok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782880265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tloZl3rnZnNSdyPLKmQcYCzAFnf6p2H8ExB+//cJ/SE=;
	b=RRuCjO1UufIwCJwnwHBO22neO0kZf1+RlQ9sCo8l1+Mq1Fhp6pd42IPyEqpj3Lul4eHmGe
	wTv11uKqE4RfNqpT6r0OHKFPnDfm48le7bl5wVX/lu2rqUoaHnIuN+FHgIPwTjGAcWeLrm
	qpDhiGE/PmT59Mjabd2KVJGEucMOn1c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RbxhsYd/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30608418C9;
	Wed,  1 Jul 2026 04:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468D91F000E9;
	Wed,  1 Jul 2026 04:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782880264;
	bh=tloZl3rnZnNSdyPLKmQcYCzAFnf6p2H8ExB+//cJ/SE=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=RbxhsYd/pL7HZId6hk3uZpF5v0dOdJEWm36wI/FjlErI9r9V0KuTX0C5MO3fPuIEH
	 knAido9Q/1dK2w9i7uwcwX7BT/GhbeFHVRGiFsxmdYKzo2YVvQwnt2zSh9CbDWYwy7
	 RAvFYXhUis9g7W34Ts+YSFZpXm8GPHSmejCGEZbfeZPjgi9wRgKwH8+Wn1S+DE57MA
	 bhdcdiVvzRVZv/TCRM2hGoqD/8cyJ3k/FnxxJmHZD5MmNRQobCR3eSzMtaOnuD/Aar
	 qfgLmTOdWhRfRKI0JeH36T921XSFO8B1nmXxw4L1429uQj77mk6EYo05ZUeJjMJs5a
	 0vpVhsFxucSSw==
Message-ID: <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
Date: Wed, 1 Jul 2026 13:30:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------PsZRKWkrNzHxq1aE0n858PAN"
X-Stat-Signature: jcngduh7og9ngf85su4yiat7447hfn5i
X-Rspam-User: 
X-Rspamd-Queue-Id: 0155940002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782880264-734498
X-HE-Meta: U2FsdGVkX19wpQhWnkMNydyASR5a7ybBXuulw+cwOH2t9UtfzhwIJ4FeA8iu4MGq4qFe5cWyQM3tsiHQdVxDttyuSnamorclT1yK+bOOJQ+JWOVnE8NZQbxaPhgS1OgfBG/PGVBJ7R1ZA38mKMMXLuEydbAeRi5hEoF3cfD5uuAqi+qNYLoqOTNnyEDZTBGSJlxqDEkbuifQNWUpJ9HY7rWZSb8YoxB19JYdFadBos3PL8n5y47lc+Uiapl2hG9CdG7UQtyX32lB5a20YWB/ZDF9Bs/RZVAEYV/j5zI1hQwpFthzDr3OOtd6s9UtPkWolhZ1k515yq6QvZwYYRirQr3LTL4SOQAP6JXXJNq3RMA+RVtba8STlWvN0UJHarmWl9+BP2lxrZDDLPiCS0BOQBzmLAEDWPhjru5J99wY4VXL87DQYnfQYHIHz6lQNHPWxpPDC9oceEnQK9hrYhMJWD4PMRS3ZZGeH1pm1mCbdzxfM1Ye7NFUINcOFbdo0Q8ArynnNpUIMewPF9i7oTIzJ2Q2tt6kmzKrGoNcezbajL8/RLfE75q9Xw2gBreB4rLz7U/SIdlnYmnnaM3AETOMJpT/AU6ljA1fFI3/sSuHacHstV030VrauZtKAsAL5gEGx8E79UMr6l28jSyQJgSd+LOlMy1e6ezsM8vOzVj9ExSGeZslGS3puO2BuqQoDVrg/T+J2vRfSMkWze2Y4ROrXyGcS4duKfd43pNOf3n/nqPltCXNxc38mMkUO2Tt/gLAcdR+sDHR02FnW56vODD0Wk6LO6mRPhKU4JFj5grlcBI/mXwGvIHSVCRQVGMecujPqx38MPFr+VddKiezw/MlcSgEtC35JSzzL6Oh/v6StLgbcnodJwJuwBnU7ot49h2go2ztu01Z9mRXkGd6tCmLNKrnJCxJjuoYvBKwLivSjc1SBSZx+tDC7jCx8YcvxXVDuwBt928QeDFu8P4Oj4+
 BKjqwIPY
 JrRA+JMff8Jb3/HUoP4Lqf34djJAEwkqojhmu1KUG2OLAeBKSgZcdcCQFcOE0g7J01SNarvQR2ReqkcFRTMiz5TtNfVP8qhIUUKWGIsgc5l9TL55zPq03RVThNVYkEfo22RlsvWEMU4iygW6Qy1w72+skYVd34HpPym1Z1oCNkkxrYzjvKlCgZ7HShS90k/VE5NIFXOk9AgW3gEBECeP0UgqKxwWNy/ipdm7ll9SsmO1H2OANtMBqxLhLB1zczgq4Xm1TT3BQRt2mcN46vS8mLZWB/vneI7zVrnqDDGnAtNP001rI+SqCvxya3mwxH+CIuoBOnautfQuZEGnwYn3iw0nJdY6c2M766onRCUB8Wg1JEMbhmfjL/sLAW8Q1EFP1gbWHcRm7hNb1YK+Rw2i1XTA1lsDV7scycRso85qm9DGw5wP6lXcWqIITPUJ+YcYjJMWdviSer/4gQA7IGYM0B4GnwkYOsLNUEV0QnuSPIoWSpzThLDMWIGGRfrMQzYTxA/pEM3KQxn+tV3sdEHV0l7deog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------PsZRKWkrNzHxq1aE0n858PAN
Content-Type: multipart/mixed; boundary="------------Ax2loyT0t0fFBrA0ODoBSwHw";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
Message-ID: <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
In-Reply-To: <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>

--------------Ax2loyT0t0fFBrA0ODoBSwHw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/1/26 8:55 AM, Suren Baghdasaryan wrote:
> On Tue, Jun 30, 2026 at 8:27=E2=80=AFAM Harry Yoo <harry@kernel.org> wr=
ote:
>>> I'll also give it some thought to see if there is maybe a different
>>> way to fix this that would be easy to backport.
>>
>> Thanks, let's discuss!
>=20
> So, below patch is based on stable linux-7.1.y branch and I think it's
> the simplest backportable way to fix this issue. Build-tested only, so
> use just as a prototype.

Thanks!

> Not sure if making buckets parameter
> unconditional from CONFIG_SLAB_BUCKETS has side-effects...

Increased binary size and register pressure IIRC
https://lore.kernel.org/linux-mm/d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@ker=
nel.org

> Attaching the patch as well since I'm sure gmail will butcher the tabs.=

>=20
> The fix for 7.2 should be much simpler using a new flag in
> kmalloc_flags() for obj_ext vector allocations and serving these from
> a dedicated cache.

=2E..which means, in 7.2, it will have a new KMALLOC_TYPE and now
kmalloc_type() and kmalloc_slab() will select the cache based on GFP
flags AND slab's alloc_flags (based on SLAB_ALLOC_NO_RECURSE, this is
new)

Hmm, wait.

We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?

e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not
set AND __GFP_NO_OBJ_EXT is set.

This doesn't require kmem_buckets and should be much simpler.

> Please let me know what you think:

So I think we don't need kmem_buckets for minimal fixes?

> ---
>  include/linux/slab.h | 42 +++++++++++++++++++++---------
>  mm/slub.c            | 61 +++++++++++---------------------------------=

>  2 files changed, 45 insertions(+), 58 deletions(-)
>=20
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 2b5ab488e96b..2d4a6e3064a3 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -618,6 +618,10 @@ static inline unsigned int arch_slab_minalign(void=
)
>  #define RANDOM_KMALLOC_CACHES_NR        0
>  #endif
>=20
> +#if defined(CONFIG_MEM_ALLOC_PROFILING) && defined(CONFIG_SLUB_TINY)
> +#define OBJ_EXT_VEC_CACHE
> +#endif

Should be || instead of &&

>  /*
>   * Whenever changing this, take care of that kmalloc_type() and
>   * create_kmalloc_caches() still work as intended.
> @@ -646,6 +650,9 @@ enum kmalloc_cache_type {
>  #endif
>  #ifdef CONFIG_MEMCG
>          KMALLOC_CGROUP,
> +#endif
> +#ifdef OBJ_EXT_VEC_CACHE
> +        KMALLOC_OBJ_EXT_VEC,
>  #endif
>          NR_KMALLOC_TYPES
>  };
> @@ -654,6 +661,18 @@ typedef struct kmem_cache *
> kmem_buckets[KMALLOC_SHIFT_HIGH + 1];
>=20
>  extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
>=20
> +#ifdef OBJ_EXT_VEC_CACHE
> +static inline kmem_buckets *obj_ext_vec_buckets(void)
> +{
> +        return &kmalloc_caches[KMALLOC_OBJ_EXT_VEC];
> +}
> +#else
> +static inline kmem_buckets *obj_ext_vec_buckets(void)
> +{
> +        return NULL;
> +}
> +#endif

This is bit weird because it creates a new kmalloc type while using
kmem_buckets. Conceptually, a kmem_buckets can be thought as
a KMALLOC_TYPE, but created by kmem_buckets_create().

Security folks introduced this to isolate some kmalloc allocations from
of varying size (e.g., memdup_user, msg_msg where users can control the
size of allocation) from the rest of kmalloc caches.

>  /*
>   * Define gfp bits that should not be set for KMALLOC_NORMAL.
>   */

--=20
Cheers,
Harry / Hyeonggon


--------------Ax2loyT0t0fFBrA0ODoBSwHw--

--------------PsZRKWkrNzHxq1aE0n858PAN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakSYAAAKCRCGXBN6rc5S
1qO4AQC3xLA+xOtG1pNuADu7EGYWVEy2miVP1+ORubgaZsY9JQEAh0/HUloSjGui
AI/lb5skTmjGGjyTesbuRsZNbIqA+Qs=
=egrm
-----END PGP SIGNATURE-----

--------------PsZRKWkrNzHxq1aE0n858PAN--

