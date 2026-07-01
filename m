Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3945C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5126B00A8; Wed,  1 Jul 2026 13:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3DE26B00A9; Wed,  1 Jul 2026 13:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05FF6B00AB; Wed,  1 Jul 2026 13:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F176B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:37:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC456C2339
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:37:26 +0000 (UTC)
X-FDA: 84940914492.07.792268B
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F3664000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:37:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UraQ0Ag6;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782927445;
	b=SrOrFwhaOH6vJ4dt38hwaNbiDkjvqzQ6tdlUL/d5Sx/OlYKbM+FPr2Ph6BbiwSX+XtsJnH
	pMYqJr4TYNjoesNPsXIUZNkQgVy3GY8ZpqPUJxKtpgNKW1WBFbZXdJa79JyVakw3hT95Hg
	FJ/Jn4grU+Y9HrRDRVVlUeKDpM3zx+c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782927445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D09WX3fDR+aS4AC+tTDSMISse/qU3FNHoR5AIw8MW8M=;
	b=D/9Jeoj3uiGo72vfMAzcXbNdtqw30XWmmPZqnfRkThmphWNc1PjlMTrB2h+HOyFXnm5/qd
	peHEJlUu7JmQgE2+EcT0wV1VDvH6B6v8SNX1A09H02kA+dPI8JwKoTWLbBTTnxsKt1t7fR
	6HOnx3wwLDEYppXQ8/pg7nx95109wG4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UraQ0Ag6;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so8294615e9.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:37:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782927444; cv=none;
        d=google.com; s=arc-20260327;
        b=ecqKZibvqgT3GgZxdYfgfW4zYjNozc7wpTztLpcKnfIDfRyiybBMJxwvXSut8/wFYX
         UjkejBcgUd2xjZ4zHAvP55JWwxC/nJ9Di4IPl49pdGAeJNFNI6L0dAFj5kANtPeAfLC2
         TLjQ7o/GHflkM5jBak4gsiiAGUFkZb9GsxNIRhRDV3XtPOl61n6cjqw527VOeLjgIW/O
         kJSIbpwHozxMCRF7h7WY3ej+o/EW1aZ/3WaGog1p5bxYlWSdD9pVFxEx7Szb0/49i0eH
         53QoW9IJpfZZjhpms99CK4Y7Hl3HW1WHDdO3Glyzj18cAVWIU/9AjDsildZ87rudgSlt
         070Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D09WX3fDR+aS4AC+tTDSMISse/qU3FNHoR5AIw8MW8M=;
        fh=SLqnxyJ1J9mslWtYhetiEJ1CPj32+IDUWNh7+ai7XTk=;
        b=FqkfSZ+C5z1/dJgIGu3jfCycievA2n/lONHLzXZy8vrLjr9yalI5U40OmKWdFT/h8h
         0ebRbs45Gwx+j9YUmvMo3muvXAaPkDkX0mg+nEFhOsJC1DU9YiWQ0lsnDX+E4zM09CHF
         9C6brhz0x7jZpLZSXNqEYfJw3kVu8AVEfvzAJ+tYYmNoHGswByKv0yIYmWUO/Zp+qULk
         HGK5SkKOpgj9AQtYqIxnThFysVWQFeXfg2C8fwdbND1u8RjOCpog4R/Ojti1t2ZuJSSL
         6LG5iwRF0xATEt3gPoNwKf/EJZaOZj4ufBObJ5u/xCriUBdAjnjvNa2uOQHKi88hmDk6
         UmVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782927444; x=1783532244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D09WX3fDR+aS4AC+tTDSMISse/qU3FNHoR5AIw8MW8M=;
        b=UraQ0Ag6yz22m/sLlrJuWXuFhrQ9xcZbrGjIhymOuzX2jSRR8LHK9re8mN2pcYRHC2
         zXNF3D3N/zRBonZcTUokQgdRGt/O38kZ62tMCT98XyJhKdfm/tR4gqO/G7KBFnNBjmCJ
         f9ky2VmuERpBDOZy+2PtIfwo+F3D3C2/LTWT0nZ0+ia85m5d10K+6bm0o+h3QSgE0kX9
         8swYosLOfKKbLOoPnLraaZJN/M/tQFm2FB7rWNeRBB2VZDSWMIM4lsMnOYFd7AX7lev5
         Hm1ymBsYQqfKozwzFvwnHY+RqFtZJnBLn+QuqXr2j0kXshIsRPmLQj+YKcJRYsYVnpFD
         Ip1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782927444; x=1783532244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D09WX3fDR+aS4AC+tTDSMISse/qU3FNHoR5AIw8MW8M=;
        b=pKfuViByww+4R4P5QcnFFIHmlH6RvDuo7evpYYBcxYAhS9dESgPxPi09OK5OvOBfOc
         Y4tbpB0jmvsKD34bwwiV4Q6HciUTmGsVwn6302FobkH6pA0wD4DpZZCFAIyg+uHzgGCD
         MU9Ek2PXkBetLwlDQqGjgv13kTUQRYqaS5GnGNTNdZvgTGw9kfWSvIhoLFQFW8t/XnZG
         EZrpWovjQcuN1uS3tFr7lykYRcu5ZpvFb7RyTJOD5dkCWxIu5nwhG0rpMwAHjhfDB5Xx
         39jjrSdS7v2Fiph2sbq46cLrNpoI5zNWXutmurDW96WqE4Ygde7ZfPuwR7Flo9KxbirJ
         XMGw==
X-Gm-Message-State: AOJu0YwRWZbQELHf10loC450DZST7hXjw55QK5cvz0vZvIPGbbpvhSrO
	mZruHmPIoyvyKBT/u2ibZuCBZieeUSDnM1bVwnaA2+uELqfgVlE9usDhsyjOIsed7p3uagrAWbi
	qG8ML97rMsGXhu4DyR+kzD9DEmJG2zIs=
X-Gm-Gg: AfdE7cmV2WGt+W19C90MYP8oqAzaRICeMu9GTP8DEbdOVTcTAW/hSjUO7V8Jw5IH0bE
	6DhwTVStU62UnKOHlP6ss1/IyaTxjNrG9ZZXRqlaj8Hrax1Y6EvYAsm1Lr3M48b454uqOE/P7hj
	j8F1tJO5tzcwCBhsjyDeUlwwZzy1nsO50KPlrjRT75uEj8R8IDNiUQzTDfG5oQs03vy4Mu+XRLY
	AuFKRFlEg2EAVKXj6dpvIk1a22jVbCunRLGCP3e8BftHFooiVeG+MJO7DrPNMGfumfiE7z4GV2C
	0/fJsJryNFlvDNtdtyqS3W7sFhcH
X-Received: by 2002:a05:600c:4e4c:b0:493:b2c1:b2f8 with SMTP id
 5b1f17b1804b1-493c3cd568fmr29279035e9.4.1782927443456; Wed, 01 Jul 2026
 10:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260630100832.107062-1-jiayuan.chen@linux.dev> <eb3a62d5-5fff-4da5-a211-860ef0d4aec2@linux.dev>
In-Reply-To: <eb3a62d5-5fff-4da5-a211-860ef0d4aec2@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 1 Jul 2026 10:37:12 -0700
X-Gm-Features: AVVi8CeLOF-foergKkfJRWxxCORizHYveGUtTsIGiHyTBqYnPLxUB6T6yfmq35Y
Message-ID: <CAKEwX=NF9nHTwXp2zFz1AY2nhEbBK1fE1Z4tMbtNbnK-zcEGGw@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: reset zswap settings in css_reset
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F3664000D
X-Stat-Signature: 53goacwrqm48cfcn4h6y748fywxtn487
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782927444-331075
X-HE-Meta: U2FsdGVkX18bngxwcTvE2JnG6ZyoAgQ9ZW4BAUH/Nt/IQ/w5TZjc3Mb4Aac7yiw/KoCVaFI33hzmiAE9clGx2GuvdFlwp85TLhIDXLKct7YU9nFtp5+ohFT1oXszuUbN1UcrOm4uUo86xM3YfLYyiBKlbbFCEfvaoxZnAcDA0qSa3mk/82QhCIgWLXl/ALZ7oLt9plNUCB7I0djSHEZmk/piXgPDmUOvPmH7FPBhdjKZEFX8EWdvmj1yFkNTm8F9nXEjo5/oL4SNzwm0KXDadR1dU0QisSuWls/zS/3xnfbm17o9KbMZZpgVixaxa2K/lnTjEzG3+MED+Q8j3C6A6k/9mvH+Pk7jnQy2vjD4TXZZKJPIzfgcfYFMNHM2SZrgPDDupou29JdXGmMB1EhI1hc0nAcyap1Mdpog4++PyGIZWVQYZCl5s0nzbYqfCWxwfFBmGGXX0k2gc07Z/ECCV4/w6wMK1ZMmLLc3sIAvcM4LEccMmJLQVtPZUQcg5KB9oHhb8qDbJy1VLG3sYdpg2Nu9sPEr2FC9BrraCtGqmLvVDv+XIKwUakq70P1iLz2yLnWWkc6irqifLAuqRATcRhrNnoLzYzuyOyz9oq21ZlB37J4iPULdc3NIRDnKhxwR3XdVGFIswVR4HACHMbpHV63XkrhyR4sTA8OuIOwY1Q7pvD1U9MU+svbVf4fZQFUexPaQ6O8+3BGsOScxT/4fW7oYIHQ5yv0yoFyFqFSwwyxmQXIuc33rFMTaM0peiGVgW7glJ4GaqY+mDlXGWkGMTNmApjcp5Y4gBN4+3JMAyTr5ygGEDoRSp++wF4XulmhHQA+zFV2sTJh3iDQOgmi+UOc39ZL52HZXQKL7cYXfSOxanNO4bske8F9UG6gU/KK8jZ+XBKn1yJfehlwhnzI7E2B6zgGSyfYZsbiqBrIwny1vhzCP92KHCNsjQWU6hcRt4144mwijUG5m7zDtgx0
 RV5sFtBp
 fT9HeR7QDxbPZ7CVqQs2nwShhK8zH94VcXO/bUU+IihsP/lUrEHvI+xrKS5f2zur1NLMoJlneph2iAxkWf46uCWmnGQDqjXjjY/5ibSszDLMPEqqKUNlb3EFSlFYGnC+0+bwnhKEj7JsEiksxoTpuYeLrqbrq3gKhPzvEdbvYLiRIMDthNOlXWOg09Zau8ibFLwkXF6O4pEqT5QOXPg4SqRhu/q01BX/hRzbcqJ+bouV/aP0naIHIWvf3BX8v0tVBumNjuATfqHRYMEIwgW9XIcKpLKn03iZChj7WwXX3JlW28KpDSui0OPTzbFlMXCSxBlkauwWfVEcn9fu79EoKWJDT+pbuhU+9IL8qjhcsEh6hgwL5DxmGC3gQqIh0EvlW8kKDbSFev3GKqwrLriEfywBzdYKdwEssH3KFT2btdSILYDMKrk4eiuq7ebVeLt2SgBeoXuvtboRy6CHjK2B6AZMzkln6J/2Du2jKv7kVg1gya4Lb5PFWUJZottGymGuNRZPS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 3:44=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 6/30/26 6:08 PM, Jiayuan Chen wrote:
\>
>
> https://sashiko.dev/#/patchset/20260630100832.107062-1-jiayuan.chen%40lin=
ux.dev
>
> Ai is right...
>
>
> Also I'm thinking that should we add a helper instead of using open code
> in css_alloc and  css_reset ?

Hmm idk, seems a bit much to add a helper for this single use?

