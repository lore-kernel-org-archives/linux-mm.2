Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85CEC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2756B0088; Wed,  2 Sep 2026 11:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA28D6B0096; Wed,  2 Sep 2026 11:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992D06B0099; Wed,  2 Sep 2026 11:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72C6C6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:32:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 008C6140284
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:32:27 +0000 (UTC)
X-FDA: 85169213934.30.D9C63D1
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28AEF1C0013
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:32:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avZUDY+K;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363146;
	b=rHp4fkSCojDxI1CAup62/LDq6WZZPMDGEI53hXsh89htwnQvAQn/pvnJmqISFVv97oH46u
	XXmA7VPdQkt7lJDaeRdFl/pxojAILtfrPJG6D7jnhwwyG/PadCCtNo55rSAurcgBq/BvVp
	Li3jJ7kRscqZbgI1jgLBeoKtIjpqqyk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avZUDY+K;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6CFSQBR//cpcDAomOpl3DbC5UldpOdeC10IA56wysg=;
	b=7fab3PZaZGjaFgicVWTiatpZPz0E38wDztluq6QWR7GOVF8+ztkLmm6TMWXeec4KAsNZLi
	ec5NV2J1O6NGqCzEna6fFydStsdD//dxdv1hCTLXvxMsgA9knhVs+Cpwwr1LmIq6jBTMdA
	kvfi1IU5WFIumJ743cFUGNyI3xQi7ig=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce98cb8165so14263155ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788363145; x=1788967945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J6CFSQBR//cpcDAomOpl3DbC5UldpOdeC10IA56wysg=;
        b=avZUDY+K2T9GLfgsMiH2jDZE38CIm8sFBt8Lqn0oaVparezKIKvT/Wdcl5kgcOmYop
         1hmgSFEG4+iMYX/Bgv3Fs5pE5eUboXYyJ4JFS9zeunWRNQNLw7tVbO3azYowdfM1OK5k
         LPnszi5FZXOKTmsvrnjbKljYMNwut9Ri4S3VL5+odzMVc7ThSPiqpRDbomcGxekUJGVk
         LF/QsSJHDbLQ91RzP3qeS3Zb6+Gdvwmak23x0iQBggPEdo+Q88tzndYCn4BDYyevaKmg
         crHNOFWJvehzTI48tgryby2VyWueBrU+MX2cpD7bm+U9CDqIJTxuGHnZ4IJNQjBIOkMw
         OOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788363145; x=1788967945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J6CFSQBR//cpcDAomOpl3DbC5UldpOdeC10IA56wysg=;
        b=ga6semK9jXC1DPAblV+UI7TllKMGh3D6yquilwpBIRAzZ2jcngb7WgJV0TxJ6LfTHQ
         sMCI6fF6u5P+E8/uCHcex+YUpeIqAUwCsfccx+l7K5ZIxj1lVcT/2YS1CLT+ZjdbJqFJ
         50X+nYUBW9IVFWVMPpImve+UflqLDxJqEPOmAQ1v/Rs7jjtUVaB9cday9CxIF+N2MwOH
         rIKNdA5Rk7hL3pLZrar3h3enggsaAKmNg/T86+CZ9xBH0S04iQNFEzbO1knCP04OWLhM
         Pvvn/itPNuXtkGhZYT8J0GA5OR8GlhRPKeHyioMAusqX3AL9GqXJ8GOtMF+J5+Xr1Y/m
         L/og==
X-Forwarded-Encrypted: i=1; AKwUvBxrgDFPFn5dQ5dpb1GycDrWkMBkORzZyylI8kETzlq1f0kjV0YtpEpYEGulcLD0o32BpVwJh50LnA==@kvack.org
X-Gm-Message-State: AFuF++mlNCoXHRI+dmA+GTPVV5euAcyIJCjxOcsdCzE21u9T2vdbbYwB
	frZCoqqUvGwHcX1C6y0Q/XSCTf4jvuZDHIi6TnlfqYVUb0DAQ6V+5jyc
X-Gm-Gg: AYBFou0HAYQpFvSoayx842Mv5i8OaTcNT7j6x+Z24iPIq/e58ZFFVGExlux70RZ9WOS
	m8TEfjY+5KaLyj1sPyYEs7zBGkjCwxssqTynQN4X8o/MVyXjzhADOHMnAcogs69Au32U79SMPsV
	ph5CG+C8UekJ19gA6GBUNyi6GlpElqUUcCGPdN+nFfjOR2bgS9phIXfb3SYrHFhNTZmtcZq3a88
	QJf+b3kGQETKF8A7BlRFRb9SfBLN5yUy4yBq9SRIrB/FL7zXSGWkBhudLATuTGVE6XWabRKQk5P
	XkWfmHyQdib6Y5GCDunXlZJXKgb/XvAsQ60LoNqiVmiv51oA2QoIigjbjPEuhZNcp/TB4PfCc8D
	dgxgJfQwHM9961AdGxZhIY22xZzjnH23kaHwol4k+M/zzpyaI7o4VgkBQEujtEQAUO+8H1emYFL
	8UwYtRxBKKIpWHBxNgD05djW6fb7XYz3snGON19EXU0yRFKVBuNrWFhGrm7E0=
X-Received: by 2002:a17:903:1245:b0:2d7:1cbd:9ceb with SMTP id d9443c01a7336-2daf1342881mr28557975ad.12.1788363144243;
        Wed, 02 Sep 2026 08:32:24 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2daf43d41e2sm6944815ad.60.2026.09.02.08.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:32:23 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 04/12] mm/damon/core: validate number of probes in valid_probe_params()
Date: Wed,  2 Sep 2026 23:32:15 +0800
Message-ID: <20260902153216.4034305-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 28AEF1C0013
X-Stat-Signature: wiapae6ji9smwma9kxz85nngcw4643dr
X-Rspam-User: 
X-HE-Tag: 1788363146-193948
X-HE-Meta: U2FsdGVkX19ojK4fo2InjTVBp+ZpHzfJpS16vs7lvRb8/uzmz9UzNMfriu/zQ9z6GTSmgfdDYVWpsiskUH2z3Ge/mX25AWXnyJ1koF0q3TGkUMoFbLb7f8UYTgCTI7BhCBPMVRJs79gJcR1e2duYaU1jE7iKwoqbwClUkrIjaeVydRjmrlxsQs4Kye930Vf689J3+NCZ0YEuGCgs8l+97j9Ns9A9FEUCPOauZz09n6jDDlJ1GA+6+WeanXUK77KhV4rPvwqUfk8zc1vuvtTL7tfqLwk5nwTF0W1HXChsRGunssoAWP1HcteSiZPYR5TayAMriLYpFJK1nK40PXNowwPxW4sTL//U0sgqoZkCJAaBNdLuTSsBzyBC7LqdK10jHAWxImnE4CcUt0fqZ6hwvV4q8i5QPXSBPVNWEMNUdsEWk5CEJjSgCPrJ7lQ7VJWatItAS9DtkPsnP3BVohUt9xR4jMRtq/A9DsmO1k0R+/f7qjhjyS7t5KyAfrj4OJJrch+xmfGUB7YeFBt2tDhrYEAjIFi+wRpCphJRHRMTDzUr4fklra7OavHdOivF+zzztpAcj9qtt2CZOtTuc38M8RY97ddqqaODPHLhVeXmHwr/GkCtgjLVhyAUF9rI5Z64behjbFdnERkeXzTYPIYwD/ITKpux841nFVZ7VJ7mxjumix8/ZnEEXeh1yHU63HEztk/UrjwNiCZAokS19Z1P/3xFop4hqE8unSCIZN5mk09iuYFy8dk7DRfKuHGDGMLJxAZDH1J/AoQ7rE8gk9/kdoUsGUIouuFIChsQPih+05Wc3CxxmL5/Yat5+qnwiBoul/6FBa/k44pAnY8epy5GQZ9QUvfpvsc5wqFkjINNwr02od6r38Bg95PJYERbGPVscuqgER/n8/kru9utmWNIROf9+9PsBHWWut0W+LWhHLxrj12YWKmetuoHpgyWdNCaeED2v5+XE/8yvKHjK7n
 SSoL8xkI
 QIy7JZdMbiUiTkcUN+IZe9ZkDUCBNdWJyDHGikKL0gtyraOQBxtXfRmf2naJJ5PxJpdWZEX5POUe7JYUH64AEWkTZkJY6CvdFXEuKaniw1kvrrjSxqlLxQXmBZgqEkJuKI992RPWDvc1hmM7MmNX/dGKDcQ9ZujED18DEBxfKxLYekqbGtMqeUiTDEctXMzP59r3k3S8E8pVqT3w+oXivfumeRVYjYfOb1SSPN+pUh3Ok7trszhMUM/8nVWAJIfgkWuc3sW1ZHp8bA7GwQxEZS2+kyCdItCBi28TIq0UUOk9kuCV9z59fqGZQyiBNFpoqJENiEs35/FrvgR3adWCPwlxa4MU4XmU4NeindCGmC3as1mB/XrepQqoL64CcC844iVZS5XqSFXJFa2adEMeMLGbxj/O+eJAal+lHQVsv7Q2SepzI5HpOq4H02LYxKexFcROtIkLrjP24Cb2mnK1Ph1R4NhwTecgOHXmdHGLw+el7HMeZKFlTiJ9lPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:37 -0700 SJ Park <sj@kernel.org> wrote:

> Each DAMON context is allowed to have only up to DAMON_MAX_PROBES
> probes.  The central place for validating DAMON probe parameters,
> damon_valid_probe_params(), is not validating the upper limit, though.
> Do the validation.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 4d28eb033fc4a..c010f686d033e 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1420,6 +1420,13 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
>  	unsigned char max_probe_hits;
>  	struct damon_probe *probe;
>  	unsigned int wsum, wsum_to_add;
> +	int nr_probes;
> +
> +	nr_probes = 0;
> +	damon_for_each_probe(probe, ctx)
> +		nr_probes++;
> +	if (nr_probes > DAMON_MAX_PROBES)
> +		return false;

Hi SJ,

Thanks for the explanation.

I agree that `DAMON_MAX_PROBES` is better enforced in the core layer,
so that all callers share the same validation path without duplicating
the limit in the sysfs layer.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>  
>  	if (!damon_has_probe_weights(ctx))
>  		return true;
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

