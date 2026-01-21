Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7226BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F556B0005; Wed, 21 Jan 2026 03:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5C06B0088; Wed, 21 Jan 2026 03:34:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE13C6B0089; Wed, 21 Jan 2026 03:34:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA8856B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:34:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F6A71A083C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:34:13 +0000 (UTC)
X-FDA: 84355308786.01.B3BED1E
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B4D92000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:34:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=stsN9BBL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of edumazet@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768984451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR8UQAhEPTcY6PXq6mSRhJOzhLXbgRU8yzc2N+B5a58=;
	b=pt2krq+9tvDhI+vkMHnoXK2R/L0Gl4ooQ2fzPYF4uracqR5QX0GU2g7TdhToXivBEsn3Q+
	GL4abTuLiKprIGS4S//fN4wRgVxgyLk1z9DvS7zSI5TyOByZgfHFwhLgK5odX25qT/ChMb
	9vY5uPxIZRDu6AhlSZgFCNyko0zyYUs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=stsN9BBL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of edumazet@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768984451; a=rsa-sha256;
	cv=pass;
	b=8lC2MU7zvOIUdST0/nDbTsFPmE+nXt0E+bC9BeXC7XerGAKwa9kyicZRidGdA8YJR+ZQw3
	j7RHlnJwgb8vKomF9NNeW1zrYwmHJ4VqKZ/1BhWf06ILhoghujODVlGOnUeGOMGh1M1W/p
	NnMKFR2GPJmJL+QTPKIuHfO0nz8pT7Q=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88fe44cce7eso64201316d6.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:34:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768984450; cv=none;
        d=google.com; s=arc-20240605;
        b=ZBJBBJbc00n/Kmts8hVgAPNoXxyr8hvaVrKX2w19OsIz6mYBKZmrGC5GZEnRESBVX7
         oREIaHdT5PFSvhMyk9Uctc0MrG3BhiHPbbvSFiFoHq6bIHXSZpjRYx0LB3g6gfPqU2m2
         VHICfd7eiecgj2pTeQJhWQZDIlWJPWhTZ5DF3H6c/X9V/DXc1TGnE2eOCYp/QIvCGiE9
         tfukZXtFfXCzFJvwty5y4vrIDzwZRVA373LAHDAfn3kN/oadECoCU0MFnkCkUu9ZD9tB
         icigQKLW1MtbhGz5VabfpvwtpkuhAe84MMratUIFnnFfU1IIP3dh4xrD5zz5PNKHS/1Q
         X4EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qR8UQAhEPTcY6PXq6mSRhJOzhLXbgRU8yzc2N+B5a58=;
        fh=L8n3nFkd6QUvbiy6j1ZXgZNCNQ27uI28sph6x6rbctg=;
        b=I+S9+A927OqlJcz9hP4BYK4qsXighEJsj5Hxv81pViQNc+k/IGYdhVAUqwMaQfrhT0
         jVrrrY/6Xl8MutBu87NSTzneMhI3nQu7FtyNl5k57TWTHhc3D4kUN7yD6MtPye0GFHj9
         VQo+atKxK/O0ipUlFoWHKJ96cydRiMMPUDaSojnRTX4uFoYCjMr8kxCTU1wlCY4beWwp
         MHjzS31Brr3E1xxHYGCvwMV1OiyexA1lttTpkeEHxdN6UxvcFbVmFt1GLzrBC1GoUdn3
         vVz7LS5mFyTysBlIRW12HUD/QAjVMbfVFAzNTLBU2DrvlsERVZfxSqPM/WWGBTxJQfXR
         WQcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768984450; x=1769589250; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qR8UQAhEPTcY6PXq6mSRhJOzhLXbgRU8yzc2N+B5a58=;
        b=stsN9BBLMmwtNfxr6cp9bc//NAIbs//65mUgPsWcBBrjtReI20CkA/hsJdUBnPQgp1
         11GoIExMw17Unf0Cl0ayPtbDWXTBuCPyIijOvk2ZN1397LlPx4JrEtYv/YW0ED3k0aOf
         BRDjMGnwCqp886d3elSPBxQZFYau12Jf8J6M034vT58/ERKSwZ5yaC14P0uMMGaMK3qP
         3lppAbJ0CLbQPYqXZ/8ydqfjIvtl6uHQO5uBIM+DzlUOGlhN6KBJ8OB4fp4YYRIteaFm
         IknGbWBl29hgZ0zqbhcDZ6gjwU7G533fwXmgS+C9iGHNGzIY4YGT5Y8wyUMKBrnVB8s6
         xUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768984450; x=1769589250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qR8UQAhEPTcY6PXq6mSRhJOzhLXbgRU8yzc2N+B5a58=;
        b=lfpYKhAuM5AQh2YPMnPJVLaLbSKLe9tOGtizXS5Lf4S/Bbrl+o6wKqRTMJyIZU7mQa
         m2b4CG+BLbPPFTb9x/tnJa5LdR+vZbN/vgEnRPH25cv7KXNT5xxBK21zTPGX+GYNBbnc
         nBCc3HcgiYDCvhYLwMFClKlIEPgcul0MvUhEpRjoz3VXeYygdt47I+963FO2fwbkbBql
         qyEnjWDd81W2/jCpEQ7cbmVjfeBLFg2VSzmP+NRLkGtu8SIsgymgtnUJqlIWPw41vpSP
         K+Lx2UbYZHDw1ysSSzNQVOeCPwKOLL9JOZS46KsCIuZzchf0+hTKIaduU5jn8sKFmPgt
         AaGg==
X-Forwarded-Encrypted: i=1; AJvYcCXdfeIC6bTFSQb32ALde7e+cHmUwmPFlmI2HvcRq/vY2gNlu9F9JfW7uJyNRNPUcINx/4Mbp8m//g==@kvack.org
X-Gm-Message-State: AOJu0YzNoJudICZSDFlv8HeantJVIWihERjvRoSB44hHOqFRXnWBA3vf
	v6L3fCdZvO9ZnrZLqE2NosBwhmbDcQUKIBMB/uoMknlz4q7NzScIHRE08r0IxgNA5IB3NST+v2z
	L7Lf27LOux/0qV1XONjgOP5TBwrBPDX2vjFHBh6p+y5g9SQTbjQ296orw
X-Gm-Gg: AZuq6aKRvSyigV6iwRMhZzenFy/FzGyPlagcuxBwhE6O9fa/pRVBql1O1KK9qzw2ynd
	0G9eZ3ae3H+imaO09jdluOtp2nti7kNlkq/woAw9WC97GCctsaQ/vvzmgoHbEHgjhyw0Xm/OjpW
	bRFfnGoCnhKYaDn0RFBbXr+SnTaPasYtXoGta2kUbE75rkSSxrg1tSytxkGs5zS13gjb60NGNJt
	GQReJDpEKLldLNZH6As503kGH2ermU9BCjwGJ0O/TwMSXEzU/Ceit28n18AqyG6MqVWX1jW
X-Received: by 2002:a05:622a:1a9e:b0:4ec:f26f:5aea with SMTP id
 d75a77b69052e-502d852debamr64442781cf.68.1768984450268; Wed, 21 Jan 2026
 00:34:10 -0800 (PST)
MIME-Version: 1.0
References: <20260121-b4-remove_cache_from_obj-v2-1-7213d36b89d5@suse.cz>
In-Reply-To: <20260121-b4-remove_cache_from_obj-v2-1-7213d36b89d5@suse.cz>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 21 Jan 2026 09:33:58 +0100
X-Gm-Features: AZwV_QikhwEzU8VLl-_D2F-UkNB_eH87BoWYdZ-Q4Ay03HF_gzeB9yWn3TofxPY
Message-ID: <CANn89iJhz9RfpG62kW1XmL1=cTKvVN5kS-KM+TpzE-mPW4WhUQ@mail.gmail.com>
Subject: Re: [PATCH v2] slab: replace cache_from_obj() with inline checks
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B4D92000B
X-Stat-Signature: 85okw1zafernuzzwohoob77iex1z4k7s
X-Rspam-User: 
X-HE-Tag: 1768984451-977807
X-HE-Meta: U2FsdGVkX1/ztBHJiCGtF3UdLzlOWDtx+1wBwPmdlxk0cJmfkTGmrt04pKN1v6ehLlAA4GaBIeAFnR9Canao3DC0PCF2pJE372oBsImvGb8IXhb7ij1ATaOC/TZmlqv89lRGIFANMiuqL9p2OMPwAUn+/Nxp9pOdU1sJ72PpoTSghZHJEuti1Wy/1VAFi6Q1ik3YwkBM/oGwA/1UXQtWjOqDrnmbofOV5DiF+NGNn1nKcWqd90fSiEVdb3FORP3FlCxV9faao+UMe7r7zp+MvyXBcAzzBu0+lYGX1WsBP0tMYF4k28ACUi8CRgPQBKRDgTNWqHWY1BqO1zWTIst4arRjNl1YiSoJecoAxYte38geYk+I631epLDKaeG8pJtOEjn6jAn+fEdlqzj+dgCdPcTzK8u0Pnd3OZqZO36WAOQWJIsqpzBMnc7LczjCpRmVhZMrWTxRocV6K/LQW1QuUtzn3JMQ5VZnqGZbaQ54gnWiM81pKA3RpPYH2pxWKex7vQS4aLfXwTyFdZwFajyAKq3FRxx+m6/wjqkg1GZ7Ksud8PzI73G/a2xEC7b4iQyRO+svmmRS+JByCoZEMi/DEHNy91LiF9jUup2m2pgDpuJavkDWXNYSv2PIUWFaEvNw3V2mcwqc/EQB5YzSpi/fnfsSuHnhXRH5QKctaepDfaQP264FGyvcDKUjHkaSkfo1Mn2H8QKYIdNn6/6z3NQeXKd9tmzNoX8AAHLNU/F6CBiNPrDH4gZ5IKyvft3RTnesK/55EwOqGoj9Pi1IVDLunwAOvz/YVsifQ8cQORBdvaI4BhiBsADJWNwrg0eSevEwlmEhfRAOTwXiZ/jRmIoApfttGQnnfkCOc1QV3ut6777+pVtBEtMHS4FrdTI0tPdllOW5T0VXZPR5wvmbwY648Rr9Nt8u4m7bwbq4/D/c2Qz+Qd8vOWc2fg1x+LWfBzxYXIQsR5O0FAjKVfIIjUg
 emqc0dJg
 95DCj99i/rV3SRpB1crQWU5r0SjRZ+o4/j9YPUYAswF1irufNueoKs5LpZBrzi8Evq28N5x89P8MyLukx2dHSFU3AFGpb+GLpjrBbUOmzQilSmpUAmBipKBpa05giPlU1alXllEVwKZP0iwdJwc4lq7V1f8Pk+0g6wlQ6BXs10FTAdUkgTJ28RZTyRgvbcD6fiuKKVOQeiUpNtkAiIOBCWQdbKs9edQOL1CdcYdC00X+GdRuOjFR6V5ZVCoyd+Dv1YaWnV71QUDgHVG4ePMU+fbhP5yeM5i3qZvJerEInHzDG/q9MZdK0uEk6kdHphNskaeBuX/Z3fJBVWaK/Ldjr/YPLKuBC/akD58LZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 7:57=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Eric Dumazet has noticed cache_from_obj() is not inlined with clang and
> suggested splitting it into two functions, where the smaller inlined one
> assumes the fastpath is !CONFIG_SLAB_FREELIST_HARDENED. However most
> distros enable it these days and so this would likely add a function
> call to the object free fastpaths.
>
> Instead take a step back and consider that cache_from_obj() is a relict
> from when memcgs created their separate kmem_cache copies, as the
> outdated comment in build_detached_freelist() reminds us.
>
> Meanwhile hardening/debugging had reused cache_from_obj() to validate
> that the freed object really belongs to a slab from the cache we think
> we are freeing from.
>
> In build_detached_freelist() simply remove this, because it did not
> handle the NULL result from cache_from_obj() failure properly, nor
> validate objects (for the NULL slab->slab_cache pointer) when called via
> kfree_bulk(). If anyone is motivated to implement it properly, it should
> be possible in a similar way to kmem_cache_free().
>
> In kmem_cache_free(), do the hardening/debugging checks directly so they
> are inlined by definition and virt_to_slab(obj) is performed just once.
> In case they failed, call a newly introduced warn_free_bad_obj() that
> performs the warnings outside of the fastpath, and leak the object.
>
> As an intentional change, leak the object when slab->slab_cache differs
> from the cache given to kmem_cache_free(). Previously we would only leak
> when the object is not in a valid slab page or the slab->slab_cache
> pointer is NULL, and otherwise trust the slab->slab_cache over the
> kmem_cache_free() argument. But if those differ, it means something went
> wrong enough that it's best not to continue freeing.
>
> As a result the fastpath should be inlined in all configs and the
> warnings are moved away.
>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@goo=
gle.com/
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !

