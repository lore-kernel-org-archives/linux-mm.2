Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B8AC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB156B0095; Fri, 18 Sep 2026 03:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245636B0096; Fri, 18 Sep 2026 03:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E566B0098; Fri, 18 Sep 2026 03:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB8086B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45B8C405FB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:58:24 +0000 (UTC)
X-FDA: 85226130528.16.DBE8B1A
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FCAC180007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:58:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HS3QkIC2;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dV9H14tWbd96/qCJ/vqD0rQ8aDrl9j+AsefZpIAGXFA=;
	b=KNP1VKgWeCTkf/BXdvGNsT40i3tanVLxeIPnr1i2dKATcLezhcIjR3LSUsj5djUG1ED5K1
	4YkmWD3cTo5qv3NVbM9MPe3dg2e101aRZw2xIJYPpHceAf4VZKSSxikSOLoT094OGnaLRG
	l4+3C/hucK+nAR+NLpLKuSh195GvOes=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HS3QkIC2;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718302;
	b=2XweLaDHm2gteDl8krLbC4bgcGxb5fmuiOYGk2RL63v6UmE+PlJ56HyIixzLBB49gJade8
	DvPEFZYV4N/FdldrssZ+U8uWB2OVw9ys74f2qvhCbkAK4p1FAeTUkKK3CrvqFcPgJh7tcL
	luWQbGAbpTvw9tlZxIvTkntDNEIrLhc=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3920so3048565e9.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789718301; x=1790323101; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dV9H14tWbd96/qCJ/vqD0rQ8aDrl9j+AsefZpIAGXFA=;
        b=HS3QkIC21uqIVOidGOwyCWPiQ6TpGVN6/mY37vZv1bMyiuoeq50yKs3Gymv0hCV7fw
         wGx7GrIbx6B3xPk5O846pyg7CdE2L4Jk5O51G0QKWMLuarsyuFlDAmkjy+nAGNJdzVsM
         KB8Uqmk1AP2kw3UtShsAIcEUjgYztd6kR9vK/qAS/XRmmDRxttegMVDQrU4jk5D3fWN9
         fSxxXN+22Bb7WXoNPPTaHj7nV8OW54SQcNGFYzZVZ4l8SDDi4UUgU/oQN8jASFy8TO7Z
         38pIpScUeBpTG69wgIhPtVbtyd+/WwvjSBfbJbwWtxWiWVDymG4DELXqoOpH+7FauFk4
         YN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789718301; x=1790323101;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dV9H14tWbd96/qCJ/vqD0rQ8aDrl9j+AsefZpIAGXFA=;
        b=PU+ACHhQ6mOKLAITDnxC/sDGMg5AxQlQrKsrQYrr6i5mK+Hc6MO/nCF0N+qANY5/8F
         X9/7+8pL6vRrzLdg4nrBDBvNEl9oMcVrqo9E15/P4CtQJBgkZSHmf0clSfdGby8hwcf9
         Fg95N+z6oOBhL/8EDVK9Kfo/0XJks44xHjN6yP9RO+HGqYC5x6d+0OQ9jirAPuZBaPNq
         HCTDCW3aYl68zQBwxQqifHVEYwdvN+6AuuXRl6iU/7doZ6DD1g3D1lj74++GOXtln6gC
         SuBKtgklpmDXidLJnI5JbXCGIWVRODjmI/kLeaXSe06gwywStqjgsIRjhk7N1niXs9IR
         foJA==
X-Forwarded-Encrypted: i=1; AKwUvByVUzKV2TZVQr5qq0hbWzFq33rjO/Nkk2hQjWE4YSwFh+CKklmKD+3CTBh7CMkEVBSbe6Cb6yZKNA==@kvack.org
X-Gm-Message-State: AFuF++mrtrsEIyxox2OQdLNyLN6HzAXCj0JwUa8WTtqHykFgx05nLr2V
	YAXrkHRYPvq1X4ldYirRN4BGlYlRgoi69RAxF/tkWCfWsgdiAd5popHfS0zA1Omy+3w=
X-Gm-Gg: AYBFou1Id5vmpF4lSqMJ9aMWyvAbMU/E3l80fyxgRPCr3oKtS5JpMWuwT41yZBkPLOa
	FI0yy2y5EmMKIGQqApEpFh+aQa1WgrAfOVvJDbZqdYF3a29/DSqopMByz7JwNa3sSSGdO3CRv9d
	upzR9qVPOCsNh+s8QbDFbcgDbfSkfkmcRzoETzDwq17htzPj6o0smDHcdl/gW9iWdbeEYsopo5x
	koTrnkSJDNTN5jmFUIaxrmgKoVQAVTt3Po17U1IRpF7Dh9FEn6cUD1F7TnSu+FdZnrG6JEmmbwN
	KmzzdEmAf5/2Q5Q9K6yIWmR6fWmLaWJ0qdbZaWNHSmHGHfHuiJxK52bVkzckjjhozjOBBwE9nWc
	4gZlaQgA4eydsKt8Y3OBugD4UeYKqqOzWrjEO/+dqEGsNSLszKitXb5yOmlbvEUVNL5UGWEZ2ri
	Kfz3+O4I7svAm44tKBYedDl6a9g1IEno50q/WG97BRVf2iFnXfxFqV6mKH+JmeQh4PcoS6LtKox
	mmFaOswz3uh
X-Received: by 2002:a05:600c:8518:b0:49d:28c4:b304 with SMTP id 5b1f17b1804b1-49fc5741563mr18804255e9.29.1789718300499;
        Fri, 18 Sep 2026 00:58:20 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd204d89sm160372235e9.3.2026.09.18.00.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 00:58:19 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:58:17 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aqzulM8S63363Tr1@localhost.localdomain>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
 <20260917175701.2343946-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6tot43pwavmchhic"
Content-Disposition: inline
In-Reply-To: <20260917175701.2343946-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3FCAC180007
X-Stat-Signature: sps79f3m7aih4bw11pk7jp7mfnjdcsd7
X-Rspam-User: 
X-HE-Tag: 1789718302-283868
X-HE-Meta: U2FsdGVkX1/WUZZYXsQ4+vOzXJihRR98bubT8zTurS9nm7j8RV2XbUtE/u84NwgrkeF3xx+htpNOdUETrP6Wi4SJdYCpdr+AJVwJSpp0Yt5Fu3896Tu0lizyQdrx8yfoPqAxOYYabI/nnn00QxVp1K/BDTgnCpsbFAL4aNpYFIkSRm1GkHoNtsmbmMqOkY25D1xUYsurgAfbB4ekJLAJv1WfXrBege80i8JHlcMz777naYVeiv2QKFrPlVC9bc3WLepAcG1uOMvSXK9lpby2rhDWIAMXUenMGQpaixN6aAAvh88hp9qNI9TMnnMWdzFmO5Loda0GiILt2y4VcGJ7lgsMuRyyErZOtoH9LI2yO6y+WChNANMtlbUlM1SuJ9J6Sk8LnH01gilhPGgHk4hzFgZ6YRRLZgvv4h9rykgavO8HfWHzNDjLaK9BkGaON1WJHLimUwt5Ot5aa2YSUSNHC5bBOsRA9KudgxarcS2ZxL2YcgMB7CEjeVEv501aBI9fOCFPaa7g4VtP7L8B/UH+0rgzJiFpXiOiY6qGy/jnfvDsrnE0Dv3rhfbIxaTXMdrzvwvJoxEIVM8i3ow1ww1FnlLgTJoO+4tfLLvLy4W6C+1X98qokN3ELFy8fBC3uvdwFBabA3cAvlD4cmoTmluSXvuNtfqfS6qjZc3eSfohqTv5s5QQTRRphdT6CjCPG7ai2WSHOdBTaKB72e9hkgUQxlRLBHwcoyrFOvkuSREr25TZVlfd9rfyEObqGtgI3T0k47rBo2gX/zeN92v+TkaRI+amyEUfKLOT/2vuC5L5raKzfQQSNRahPxgH7YQamp8qzqBmKYCUkwxPQhtge1e507Sa4DOZReDx6/XK37vwUrESO/1Oo4NdCA5SMMPE+C41WFztqLOathJM31HzsGj4bR3jNRzXR0I5ZN1UljTvbOG3Oi5ot6WOYOrxyC3OiYLr0gvYXpmGyyF4LN/mooA
 lz5OIWvZ
 /Vp6SH0qkrHNHtwj/Z2oIPQeMjj9dhVQkfyr9JpWGN9u1PA6z23bMsLlh06EDumoWPkTccbwpDnZhrpC7aX2+FJ3uFO2kdaR5boy5vi3UByYNUyKHsa8J8pZa4dsoIm0c4HjjZ4+sFNtBblmxiqnI6zo0BwEvxvmDoxBUVDLwUHB6Gvvmbo3m1uwgdGWE9aofndFUHJ7W+4XOZDUe/+D6HEJFNbc5HXk9G4xHsipNKvhizCRHcLirEJG7qQ/cQc5YaelkWz2ljmnBDpJHeArzGV0TdbIsXC2UcPtqRqPfhSB5CTaugCGFXtpB9m1B8nJQHq/3pKrfMmqq5I3DZyf11CJu+0V3kac6zmWhhUBPXHLi56SV+vsJVWK0PCqgX4qp9txPPxcux1B7WoPy2qiXRse7+zFOkE2DS1h99La0L3j+pZdB7eelYELjQ/dNFgL1i1+zzNOVu+P/FoogKlOdUPyYXTQdf67dIzwA8hysrB9LKPZGwL7IzHMgzZtceHRuTWJqBqC68ph0IctwrLYeKQnSVgo/5yY3LkqliQGTAqZNmYi8O7zQua3MyVCUDhn0l83VIV/3G4pup0hV6QbzuIh8K8nksdp95Av9sW12aqUqUVOifQ+963Lis4WgZQzEYcod
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6tot43pwavmchhic
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
MIME-Version: 1.0

Hi.

On Thu, Sep 17, 2026 at 10:57:00AM -0700, Joshua Hahn <joshua.hahnjy@gmail.=
com> wrote:
>=20
> This is true, but this is already the behavior for vanilla memcg.
> In this series I'm hoping to preserve all existing semantics without
> changing behaviors, so I can fix this problem in a separate issue.
>=20
> Specifically, in vanilla try_charge_memcg:
>=20
> done_restock:
> 	if (batch > nr_pages)
> 		refill_stock(memcg, batch - nr_pages);
>=20
> ...
> 			current->memcg_nr_pages_over_high +=3D batch;
>=20
> So I've just preserved the exact semantics that we used to have before.

Kudos to you for the conservative approach.

>=20
> The problem isn't that big anyways though, it's a transient inflation
> in memcg_over_high and will be wiped on the next high handling run,
> and there is no effect on accounting or permanent inflations.

It reminds me [1] where stockage imprecision could even trigger OOM but
it was reportedly only visible in LTP.

HTH,
Michal

[1] https://lore.kernel.org/all/20250530151858.672391-1-mkoutny@suse.com/

--6tot43pwavmchhic
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqzvFhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiyGQEAxBEcNkVlUsFJunbUaXyj
fCr+UQ4r8t6S3GNeKJPgiYYA/3Gky8F7pWf3EmNRaSTu35DLuveVmYfJTnxV3o4s
qHYK
=tu6R
-----END PGP SIGNATURE-----

--6tot43pwavmchhic--

