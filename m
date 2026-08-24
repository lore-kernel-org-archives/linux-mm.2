Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC21AC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC1D6B008C; Mon, 24 Aug 2026 09:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6944F6B0092; Mon, 24 Aug 2026 09:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA126B0095; Mon, 24 Aug 2026 09:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 369696B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:19:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB086160131
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:19:00 +0000 (UTC)
X-FDA: 85136218440.11.BF28EBD
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD6DF4000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:18:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UA4ldoU5;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787577538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
	b=D/3qCIJQ50EMlYPEtlLMnyVeYws3AJ1xTOKFfOnmRSiZOIQTD93343RPw5PUp1Cq+7NCyI
	RHo5yHkJpRb6syB9b270dg12ZxwN9uBW8Pe5GD4ovPwzLMyd2Zt8Wfki+16zZ90tar4By7
	epPxVD7udFkt376JLGJqg5iKPIRlJXI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787577538;
	b=7zA1mmmapWZr8zEi34qeweg5gCkTYAaGxR759DuvUUhGrAqVp5OifseXUUwOylfj4ftdct
	XskocQq7DUCG7T98YM5p5D96KL6yN/5HAQRyHslKzNoQVoTvFd/Myutn12vxt6uAkdmOEv
	EnYXCMbMa2rPZ+Z63u3JIpccMNO/Epc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UA4ldoU5;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c197e7e4e94so615126666b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787577537; x=1788182337; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
        b=UA4ldoU5rZJYERhjvxW/zLQUV+qXx2Xom9E80QPwILTLUZUht0UEAk5KOQCeBi5XtQ
         EgOhMMXkU/7KYTvh+aQ7qWAsNjE6DqTIzRMT53dCxIAEdZhpshlZOqRY3duEEQq0w4Yd
         R4aM7h8RG66YQ9TATYYO/ydaVLWKLhhCUnm1gHIuCCEQsGlKwCXOOkbPyCFB/RvTVviP
         /dCXEc7JqERBSE68ZhpNAQ7wkL1TeyvLQ+kNzE56Id+Os7zKKrL0yyF02MlTwSk7FAgw
         eyowL8Sh0dSgvG811ltLgwk+5JDLiZYl+fZXfwM502DqLLaymAE3c+7jDgYugMEAiwBM
         MqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787577537; x=1788182337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8RHTXuRYUUKOJBcAw84Ji+ZmzZO1dHfvXXjiERNb6fU=;
        b=BVF5a81mAz6CXrnlaP3hI9LhLZuwSv2RieEC6MNqvkKHQHMpYDrOj9PU0jH6Ch1vUB
         Qgr5sz5/8AQIrU3tBuJ1SUWdKhuxfwpFekT4xg1cYuTqlkTPWBUU0hGhD7IjQwByM0pP
         X5+OV9j8qhQ/Jo3t3qZ4JUAd80JGQUFjNZmsnu+krBZ01Y9EfGAW1EN3rvEngC8m74sq
         RXWV9LrNEMPYwH38bzZzM8ESZgngiocqrucA4CEd8M0bbl5OxA/7bOhHNbigClvPlJu8
         zVGD4G08XppdRX8HNPGeS8zALs1hi5nrkyutG2A628vkh7vX3+Ktwbhyvh3qXocIQgju
         e/yw==
X-Forwarded-Encrypted: i=1; AHgh+Rou4Mtkds3YwiQlDZN8ADIMqz1+gmgGwDTEyv12xYg4Svtjy8/rpMOHc5kjet5ILCAKOlPQ8bAlVA==@kvack.org
X-Gm-Message-State: AFuF++kSRmcL8WRVHDnA+tZh3RLnAwKPWDarTf/fG8mvbj+TaTxuT1KU
	t3TILa7QD1Jvm0SI3b+8pVS+BSjaDREfOEpnzwUbSwScDI9ORNsDnIn5QyZgMBdr3+w=
X-Gm-Gg: AR+sD10aLCFwmgM7Bxmc3bycL2eIj+O6066i3bpzZ6yPpABv8LyB1awCKzdYgyqRahV
	Fu7GhJJ639wXfhbf6taZoxnnDThF3ttptRzsaszcAP9YNOw3pT+6aHWkcx256/JuClJ/OHNtakK
	fEC/boaP+285B8sfLhD+iTnbjJER8vMYcCF7tWWEykgGo1GSFhA9wtlqqTBvSsZYTMvGOUGF0V4
	KfT1ORPh3TsAK7gS24aSPYm6QuQg/ODDVSrWmRHyHNiWct6PTFdbneVJyV/cyBM1x1oIq7763Jv
	K5OCvW0/phxds7VTcq/l4gmBoEaPP8+g5MvVqVcVj0kQLV5+7W/cbV/rNDOI9ebtj8vsa8IJnpr
	HZT9p225FeW91OzP5y2jbKCTMk7LNAxmB+EW7jMPmqvJjVcZd7JC+Tcjdp6wHHRxXM1at/YCbwa
	ZbPzf3zIk1slO9v5mH4SNB+1FPX0be5TZ5Tdaj86voDF1gFqrapnBwAicGqpZ8p2Y=
X-Received: by 2002:a17:907:72c3:b0:c20:2d38:e518 with SMTP id a640c23a62f3a-c249238c382mr2130827666b.2.1787577537181;
        Mon, 24 Aug 2026 06:18:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24dfd91dd4sm20165366b.16.2026.08.24.06.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:18:56 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:18:54 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoxEGzZ1eVzIU8xH@localhost.localdomain>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4jd5dcmb4dfal7fx"
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
X-Rspam-User: 
X-Stat-Signature: fayd63e3jqcy71whyewqaicgornxd6tj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD6DF4000B
X-HE-Tag: 1787577538-250046
X-HE-Meta: U2FsdGVkX19emaV8Pw4v85zTB2fHv5Js/mg/GQJFP/qOdzlRC/lvsWfv04qi4ptmKPGnbu/8FOaVYdlj2BO5lyYwa2+6dukYGsPwNCYgBUe2z3mvj/YDpzJGiImokNYScelvVqf56tiFGitJfI5ivcudY1JVCibNijZJhlteZhF01p1cQWSs3Xfco6tu1AiCVZ3fY6TjjBr16mutApnH5+WrNMH/gQqMzpb/gV/MgKBqqWuk3P6mOBLwTvPkbBj44C8JteWnPKuv5UroAa6H2MXbgmaWsIIWxzLsI2qbS5bAEd9IoEwSVJSMmo321VdY9y9dHINDBfWasheF3Jmuv5Y5kqHdNb6VZuym/ms0qsIulHJwySEvmMb9xYasVEzvxHM8F00X6VU2jIyEPorGwD2J2jWmft56dIIKKUAjwITqhfiispPmD2E5nSwU5AV84vVrgrYPTzEGxgbV+EBGraVt4xVhSwbziPx1QclJHjI86M6BEpSJiXNm4dmxRwPnhvyTYL7u+xpkjjwUu74YX9Oea12tfxtVKyRve6bdse/6Jppb8vsmRIL3+Wj/4baeW1QkYC35+MhPJV/FT3jdV+ltgl/bmiWW4HDPYkz22Aq08YX8IQ5dLeuYVtrmtU8SBrwKNkYtGoGGh0jwYp1OO7xCUCWAidld9jtZGsD/b5yunlYFMbbFVXA3hGLM+zDjVaVnCVUKNuUYsUJgciqAKw2mkbIokHFSY+W8jd1Jgq/QPKfn1mEVXvbhiiI/biG4Lq9vpKeSe20Aw9aUAiR0tcxnwHx9f64o3czeODZ33eRa48dlsJaScsZjEeUmqMU43/CZqrSln1jXELoNaRzUugXw4FIh8xO5z3V/2E7tWokp6jgd4jCe8mtSxt2+o3ptgcuImGXk0xzfZin1oB3QJ5FgLwhfpPzonAsbvhIXDGPdJk3wxM/0Npn9X1JjOXWEotTnWFBVMTaFlyAwueM
 y7wMPufX
 G+dP7KaXa3ZHr2iiI2pxLWs0ocNLriRb3VRFPWeEg6DsVzuLPMhRFiOhjBScyE3RLex+hZeFWPuJrIYa/2ssPTwiwznKZsHx8Hzj9rPY3AYBeT7D+/I8D8Y7mrGDQ/5nJmpRmFy/ccWzdBCHLnLAHCjtznK40V5IwlEIvF15zVyQZ35x9zkhprpDtoXLcq43kjXsqugZ4994OE17kpPqvAhUsfD9ilwiOHBMtbQENZP5uDW0ZDaxnov6VIW0Rk1xyGBMnICSaSFieUWKiOLRe0xNfoOgg0kJN6SAzcKpujgnZbEVkwjMkl0pkoDSPGuEXdATG1W7qFtuaMqTTwl50vUm4XWyS5Cumjc71PHm0Yh1lu0U+CpSDMhXx8s05GNVS60QBBcm6osQnsluZW6DDctY/40Bl7N4MAUoi4SSDRwRThVxT+yshpyr01UWnCUjWYSpv4hV2Trj5sCHB6JMDhlEW4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4jd5dcmb4dfal7fx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
MIME-Version: 1.0

Hi Eric.

On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> Finally register the per-area usage counters in the cgroupfs. Each CMA
> area creates a memory.cma.<area>.{current,max} pair for reporting and
> limitation for each area.

These areas quite resemble dmem regions.
What is the relation to the previous dmem double-charging [1]?
(Successor, alternative,...)

Thanks,
Michal

--4jd5dcmb4dfal7fx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoxEuhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai6WwEAt6IhJ1j5eKMrYIQuXx6H
vcVhIKJYy4uCLIiKXOf6/zMA/jVVm1UxH8BKR0Myu49nuRzoWqbLCU9ie1WLGOPG
nZIA
=+xTm
-----END PGP SIGNATURE-----

--4jd5dcmb4dfal7fx--

