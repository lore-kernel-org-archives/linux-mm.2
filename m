Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145F9C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E006B0092; Tue, 15 Sep 2026 17:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D08D6B0093; Tue, 15 Sep 2026 17:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDD96B0095; Tue, 15 Sep 2026 17:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0A96B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:19:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D765160517
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:19:33 +0000 (UTC)
X-FDA: 85217263026.17.73D3F91
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id 88DAB2000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:19:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G1Q2Gwkm;
	spf=pass (imf13.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789507171;
	b=2AUnP/Gv1PGUJZQPXH6q1GTcZ+Y+hm142FbFIFTah3wNyHeuMAntBzoCcs90Ye7l3eO90u
	NDUdqseEUaBNZWeroCy9YLPk1mJpHGVrAFakqEPPW/iUTWyJ0Vs9o7jWUhD5qquAad0VUs
	JHtxGawORrzHBZxeqxYFymb8fEkPMWo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G1Q2Gwkm;
	spf=pass (imf13.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789507171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5wwx/Pk3zkVIRABUWvpOwMc3Rzh9znio31a5NcZ404=;
	b=1siudfn0R3mLa42yIb/GDpJBwopaLSmh5v8Q2jVQ+eCz8s0trkXPCcaspc1aceOcB6VWwt
	FXm/CBNuhMoF003soaFhOP73u5fDLfs9xk2zlCNAULJnAyJqHpw4UFUL2kjIvr+ANgtGrp
	HBAinAvWmwyIpIp7iWcmGn5kTkqCIRI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so1792635e9.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789507170; x=1790111970; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D5wwx/Pk3zkVIRABUWvpOwMc3Rzh9znio31a5NcZ404=;
        b=G1Q2GwkmdfZhqOBmTzNvDyZVxdO3cg/W+ykzE2DQ78Dh9IKeOQbgE6GtkdbuR2KaJD
         kAgNZ0boFWSMVRi/5qFcfqDWHwfvOiGYfHWf9UyiufCc2SSjLt3CyM8NShVUQBo3Fpak
         FntkPJvOHhMQmnUIpesc5etppXxIC4Q2tYoORsQiqDuT7dSUJeH78O0WyTA2NhopUkO9
         g8os716+ocftv0eOMWTX8KID9QR14cem/NW6R/R1ZUey4gBrt6Y4jXO0qR87WeFndwTi
         w+yH9AoFALt0rjWsNtQPqmNuKvGRkBFlrdxK0D8heJeErKAdGPX0f5BmtiJBIH0ElsPE
         vp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789507170; x=1790111970;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D5wwx/Pk3zkVIRABUWvpOwMc3Rzh9znio31a5NcZ404=;
        b=khwAC2wPHAff2+VExs9/B0j3Z7vtDHlqzSSMbwjF8+iOjGwdsEOdpxwPAkayN9aV7/
         V3EXOERRIcjrwTCka8jgAR0CuCiu8Sx/KuMrcbK9zW2KXyWPX/8ab7P6Sy4XZTNcgzdx
         Cb8LbWDc/UtdDlx6oC7Qwag2+U5wfehlNCqOcfmCRBXBd21h5uu8CThg0KTo/PY+z4IB
         0a/76cl+vXs0A52eGQUwFwHXNQZ1gc33S5Tg/fYEdi4GRxEgib44nnAUUJCPXgJ2T619
         gcmkYZvyRrGxNqAEfwEFoaX2m0SRzPFA2m3LWxVuQiSqiWmMS00DN4EGNfGOavlB03NY
         1WaA==
X-Forwarded-Encrypted: i=1; AKwUvByHBBqgxDFDGnJHy3juZSZn1ExZAQ1L5Hu9jLsU4og0ORS0Y/aaCeLdN/5glRK5PxM2sOZmVQulpg==@kvack.org
X-Gm-Message-State: AFuF++naa37AEESbJ5bLdrmnPT/tKSecKR9KVZmLlWrjvoHs14alhNI4
	PzqkHRmuuTf4tr1a3rA+ZtKG9+bDAHEIK8qARaYLy7YUqI+oxq1dOHgJ
X-Gm-Gg: AYBFou3yleVlVNiW4s+GByKjsQON7sgA6K8FFSjN/sw3HmivQbRHC91gCS4/vz9zGW0
	W94/baGaukq8AROhxlCPNsr+3rPmbtJnZNyBdYI5+U2A/irI6UrEGmh2gHS+0kkH8nTQ1zZvKEu
	J3Zw2LC7O5Ccjqx3jqRN6fla301HvNaLktOU0O8U/Z8EMNASoiM2aD/oXp+q0yGIMnCX/QxIPBo
	zdyrE0sTQibb9yKFj6amw9JMNtE5DTUKdMEVirLnqYyX2L0SfOct4bm0KjTg4CTgWQQ9exHGozX
	eKM54UgGCISDlZjxNSWZT5g4qTZa0UxBW7yP3w7yNcJPGvSbhyJQdZeFLf6iQ1tfXMtayljHS2v
	S5EG/rctzCT0XxAAHd/4UfadLabdoHEPvyZljlRBi6nAx2XVp7YtXLXaoMh2e23jF/SBb2HXcmJ
	k3VZtE4Dmot52BeYAD1KYZ81AGKWXatbE5AfHsUwnHXILc9HDPyE7hNuduv51firTLKBJyvnYeI
	63/dMdtxRLGHFvo+tT0la9/+bYNQOHLMHciQa2xOvXnrRysTgHTKb/C836eY/m5xPj41aqlMnsm
	V86k81CQqew+Z7UGVcvenJVoPW92Gl+pL1rwcRQXRDj8BDqAAwU12vRb4/aJBlg7hzzS5Kc=
X-Received: by 2002:a05:600c:1c0e:b0:499:be2d:c290 with SMTP id 5b1f17b1804b1-49e8222a2aamr39456665e9.9.1789507169739;
        Tue, 15 Sep 2026 14:19:29 -0700 (PDT)
Received: from MBP-von-Karl (dynamic-2a02-3100-afd5-c801-ec9e-1a2a-2fc8-3f88.310.pool.telefonica.de. [2a02:3100:afd5:c801:ec9e:1a2a:2fc8:3f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27198sm1671382f8f.15.2026.09.15.14.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:19:29 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:19:27 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not
 achieved for the temporal tuner
Message-ID: <aqm1ZPUHiXf9PFWq@gmail.com>
References: <20260915060937.3423-2-kmehltretter@gmail.com>
 <20260915145054.92001-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915145054.92001-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88DAB2000B
X-Stat-Signature: c41js7r8xpsuijebw9z5bctnahu74ggm
X-HE-Tag: 1789507171-179801
X-HE-Meta: U2FsdGVkX19lEeurtR/N2UZOyN9sDaEUbs1VVnMJ5hXdICq4oP0bYqPKJHt4QV5QXupqFJ4CVjQ7cknz/LM0WJpoYX7d6hvqIdAZ96ps++1e2Kp6s3tIV7tS6RYQHgWojSf5j0q/nMFA7j/D6z4ZSqyPheQAF/TF8wTCAh6ek9TUf2I0EnQcuS2rHgeDe5wrmkCq05X7TqVQtpVJHcSLZpY4aL9b6apdJtn9rSAwZZMlXPo9x9lAT9MaRWia3ZXGWUW+cTHeMgyD+VrbtbljDuMtQR2pi9PTtbKpR431hHvXRn3bKKPvj7lX0nXhWgKM6nXBO9mqxdrgpOw3hZALpHw12DcK5bBjL/oO9x6Id+1RHSC4LLkV7s6KOP8yZfuSiiQXddebCchNxsN33kcKd7P5dzcGhhp8J0NPyw3w89DscyOTNDoOdVzaavj4EiHgiLWpsKoDlppwVGXt4VS6cjXNuBZ2lCmhEvd+FVsdNFEvOrGFnepFIstQGoXlehlHp1xt4MxNhXbvwm2Qd83/g8aLUdE1GXC+Me47KBYFrtIepvlSo7q6Yzgw0u83lT8l6zq3KA+oOdWnHfwFJo5wbHN8dr5gNZyhXuW18BjoHoyMCEb1pETFI1cZXAtRQIKfsRzieTG0s4pJgT+6Bhjqph6EIKGZZAcdfpnB1y+2Xq3hY5qUabOVdVfzhTZ5mR6FM1dFtuX6ENR61VGxHCY87e5tPH7uDG2Cv/WRdVuftl/aTlM8gM5PplFW7ZxGf2LgIZZEtrRWnQDpwsI6jc0FcQNzuwPXQoGRcCYhX81usXkqY2j+yUfA9UymfKSpK6dh0CHVlGWwhN/G7c9Qj3MIwy/XD5BFDTcox0T4htlQXDplzP9/064GEMdkPph27AViQboS2tM363YRQ/1JBiqWjPOlgxoxmL/uZQEh4qu2MOX6MooP0MlIeoPLTP+rtFbdvngz6ehH3tWKjNrfPuR
 JMqOMLPi
 6xhXk0e1Byyt7T+QAGnoNf0KLywKzD3FHQd0cUBaW7ar7nr9FYad6jAzxVS8bbsLs4JxbT7VAhl/NKa7T0yk4mYC783z/Y6TlytvjdLyRuuZ6eFuo9VfYUAC07hHp+CnxaZBdvDuV2BT3zY4wqRUsBJo6F1t22IbLP1xFHzKp8HqqmqFRfZ2llkvYuRireEmMyUukBDQP2DI2I33SBJck3zNa//T43iIkT7y3OPQkZMMhl8z55BJGCshbMKOqZmFcoLEgpfxf08mR0zLzzYj5fr/Th96ip1IhdVjp3TD5PuJQ8lv3iaglj3yDp371XENzC6ZmQzXi/IdSN2HOzWDDL62u4ZfBYMH3ZLl8HVus0+d0soD1cuABSCmPdvi77uLODmpOQxDJnvMpgupAvnf9x9f0z0c4Vuv4IJx0uQGf84jmVzAUjFaicEbneuqjrieombvAGGlv5RXyd5omcPgzya94CTTx5wpM7gRDvXyOR/GphsVWdvxaiTNMEvniUdmHpZ+sCpPO+KcvAye4plNdNh0gmv7dXD06WGLcnpBEYnE3d0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:50:54AM +0100, SJ Park wrote:
> 
> The intention is to make no effect this round.  Setting current_value to zero
> to temporal tuner means it will now have highest quota it could have.  If the
> effective quota before this was zero, it gets an effect.
> 
> Ideally, we should somehow remember what was the last esz and keep it.  I have
> no good idea for doing that with minimum change.  This is a corner case in my
> opinion (correct me if I'm wrong) so I want to keep the change as simple as
> possible.
> 
> If there is not easy way to do that, I think just keeping the behavior but
> making it explicitly explained might be better.
> 

Hello SJ,

I believe I have a version that addresses your concern without adding
too much complexity.

In short, it leaves the tuners as they are and instead keeps
last_psi_total across a commit of an existing PSI goal, as the code
did before a68878f83ae6. The U64_MAX round then happens only once per
new goal.

That also covers anything that commits before every tuning round,
like the user_input feedback path or "damo tune", which currently
never gets a measured round on either tuner.

I will test that and send it as v2.

Thanks,
Karl

