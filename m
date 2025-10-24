Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE389CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 10:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF508E0072; Fri, 24 Oct 2025 06:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6E38E0042; Fri, 24 Oct 2025 06:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ECCB8E0072; Fri, 24 Oct 2025 06:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE9AC8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:06:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F6CB13C3F8
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:06:32 +0000 (UTC)
X-FDA: 84032578224.12.6B2DB8B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id 969EB100003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:06:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S2/4vdZp";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761300391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axIA7P+AQSjY62b1eHGJy8vlVdvRAxUy0/HBHXY5V7s=;
	b=fBvxf0SAEu1Y4PTGaXkoJpQtTolaaePrEHJFRmjfWpWe/8Ze7KJjAXxnSjOhJaFAhMEMfH
	0HJxnUZ24hcPFGFBje8QK8xxvk7BfMWP/5nGmJsc/EVociSXTK1VfOWQqOcZJTQFkA4oox
	n4cPFxCdQdks2tpIyNzouiQ+c50xJ8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761300391; a=rsa-sha256;
	cv=none;
	b=sFpi+qfRE4eW3YuxmiDBmitbFq8onOZ+K8Hd6bxYApWyIS2kcCl9glz38UV3btsbrttRTZ
	zccPqN4607Cxq8I0HuvQ0C6ZFWCCtbZ1SelxeQRfzEUSFXV+vWr4mniGBLrzYGVxeKg0FQ
	4gCoJKsf/7NQD+tibk4RVaCW8kldfDQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S2/4vdZp";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761300388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axIA7P+AQSjY62b1eHGJy8vlVdvRAxUy0/HBHXY5V7s=;
	b=S2/4vdZphxmPM284+KB8fDDlsiiG+nUBCHOC/X5U39uz8PLG2qH48UTVpCHdwBIV16uz+H
	Gx6hhje9oqy/kr6xr3GQU3s0HXEaJVRDB9NB408/0O1tXz77W4UO2NdenGTGr7cGkssByZ
	p6oxiXYYLZQm/kFZfYnkn/N2s2g+HMk=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due to race condition
Date: Fri, 24 Oct 2025 18:06:09 +0800
Message-Id: <123334B8-89A9-48C2-BBD9-A601E0395AB1@linux.dev>
References: <8b152d73-ecc4-415c-acdc-3f5105412ac0@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
In-Reply-To: <8b152d73-ecc4-415c-acdc-3f5105412ac0@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 91csncn6eqeat9yzsx74gwcou314jwm7
X-Rspam-User: 
X-Rspamd-Queue-Id: 969EB100003
X-HE-Tag: 1761300390-856166
X-HE-Meta: U2FsdGVkX1/FHCgddbkeyv0BTqgAZF/Maru3KiqeUWbGhmyaM/AlAu/s4uLGAd6gx5g+GceIcCa/NREgFfG3ui3UuJW/P7itNsp1i0CfBiW/8pomV3Nl6KSZzQJmWp4/xUzIDIgSnULfaaQyxNXbMsGp+FHP26ZRpXZFg1P7OIhFoGBYCECv9ny3UtCEJhJu1pn7cOCkd+klXa+61F/de8IpMwd56YR4JnwZKfqX7X8ahmBEzu/MQOD/7LO6/J9iB5H+J5rtJT2sfwjcW+78u8mgmy0/qPkEEhXU74Mz9uSn3ahaVZsUiZAqp+LWuecJjrUd1EAC2rWNPrg/YX+5M8/Wme94ae6rr467oKtf3UglFNl+s0XaXqDjDjdWEXAe0W6XFTsqISEdcdlFUt/2ZdWy76HiHYevriOZw3lyUS7jnwUoriqpsHKDPYQ7wpjNnzeYrKYOEhnTXABaQrd5B1gN/fuBQl/J+Itb6QXrR2oJ2wwUTKxDMRGhijmcEaW1wfDX0e6dyANZQCbPmFM2mY6BYLjoT823ONlziBwZO8XGIgHL4KrRSEW3xzMvAL2FihgtC4xzzJ0Lc9VrpjaBAkVxfRdpLB6dpPvKa5AEWljFcjwyAh7eq/F4WyXcQNalV7YEkQeuTuirsQBXluIHgONCHNGaXYrt81sTFBVXd1RS2RNNdDyiRWTP16vDwNrRA+cYoou66juwBkUlkObb5K/dwuQ9X3YHWuNdlwT8HSvVdNUrTw4c+IXbwUG/0QhYo6wIedDvEVFDoFXxRLpogSbsirv5UA6L0y4z8rnQdWi+RR8tqgtmxDWwpt+SV4a+6rjorFuWV1gORRSkVQ86L2+kSjispr2Jan6TP8UCMc7V1OQ4kLqaW/9tyCix7eZnE8DjYE+s6gOlM6f+tMjlVYqlbeJiv9wOnlLAEGg6zDVwblXSQ43Qv8GEvoaTy91xS0nY73rlqQj3e8C8FJd
 DV7CRODf
 bsqIBTqZjka0q5jtgeyTHDDIrxQ9jqETREPth+hG3XbqF3gJKyDYwW1tpQQsjDigairfgJ0Yqq4Nz1zq/8fiwjto47wgGvjLpL6Aj7U9ZQ/e7LDn1Cy6wYHViNYxNSJu+wCp0WryK2RiMwDlM0dDXwrCE4I8z6UyjGdxZdW9dmkZp7UXg1N6h0bypiUtH1XVADq6qdBx5fwaGPKe0fOKIdDVfE9onp8K0oKnqOeRe/NYEnKoyYSPn3dYJ4CmMT3vD/pAiNmurhuRxa6vuJ53jhRAukCCVw1D69cjrkQ1Glz6sAk3ZXhwSEfpEfu/fvBSmCce4RaOfy/xgzo+rdVKp0i3shbktCNpwf51fzU+fjIJIiTxSVCXsWwEVM1AXsB6HLNvdaqB66WFTPpUoz+3KV+xH7f/4eniclNyIiLVp4+R6PCyeruaxRSWjupbzFFlc6J1F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil


> On Oct 24, 2025, at 17:40, Vlastimil Babka <vbabka@suse.cz> wrote:
>=20
> =EF=BB=BFOn 10/24/25 11:27, Hao Ge wrote:
>> Hi Harry
>> Hi Vlastimil
>>=20
>>=20
>> Thank you for adding V2 to your tree. Now, should I resubmit V3,
>>=20
>> or can you assist with making these modifications in your tree?
>=20
> Massaged it a bit more and now have this:
>=20
> commit b4bdf6770cadb8bffcf3dce7ad7a346979f79ede
> Author: Hao Ge <gehao@kylinos.cn>
> Date:   Thu Oct 23 22:33:13 2025 +0800
>=20
>    slab: Fix obj_ext mistakenly considered NULL due to race condition
>=20
>    If two competing threads enter alloc_slab_obj_exts(), and the one that
>    allocates the vector wins the cmpxchg(), the other thread that failed
>    allocation mistakenly assumes that slab->obj_exts is still empty due to=

>    its own allocation failure. This will then trigger warnings with
>    CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in the subsequent free path.
>=20
>    Therefore, let's check the result of cmpxchg() to see if marking the
>    allocation as failed was successful. If it wasn't, check whether the
>    winning side has succeeded its allocation (it might have been also
>    marking it as failed) and if yes, return success.
>=20
>    Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>    Signed-off-by: Hao Ge <gehao@kylinos.cn>
>    Link: https://patch.msgid.link/20251023143313.1327968-1-hao.ge@linux.de=
v
>    Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>    Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>    Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 87a1d2f9de0d..d4367f25b20d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj=
_ext *obj_exts)
>    }
> }
>=20
> -static inline void mark_failed_objexts_alloc(struct slab *slab)
> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
> {
> -    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> +    return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) =3D=3D 0;
> }
>=20
> static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsig=
ned long obj_exts,
> #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>=20
> static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return f=
alse; }
> static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>            struct slabobj_ext *vec, unsigned int objects) {}
>=20
> @@ -2124,8 +2124,14 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                   slab_nid(slab));
>    }
>    if (!vec) {
> -        /* Mark vectors which failed to allocate */
> -        mark_failed_objexts_alloc(slab);
> +        /*
> +         * Try to mark vectors which failed to allocate.
> +         * If this operation fails, there may be a racing process
> +         * that has already completed the allocation.
> +         */
> +        if (!mark_failed_objexts_alloc(slab) &&
> +            slab_obj_exts(slab))
> +            return 0;
>=20
>        return -ENOMEM;
>    }
>=20
Thank you very much for your help,=20
and I sincerely apologize for the actual trouble I have caused you.=

