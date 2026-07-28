Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BCEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009766B007B; Tue, 28 Jul 2026 02:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC7C6B0088; Tue, 28 Jul 2026 02:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39B76B008A; Tue, 28 Jul 2026 02:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA9726B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:40:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4996A135C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:40:06 +0000 (UTC)
X-FDA: 85037235612.17.C814951
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id DB7DF40009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:40:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ahajF5mh;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785220805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5vL8K7elVixiyioHzvpuSpD8hwQ+IAvP7Z0RgBWZFo=;
	b=hZQO0Q6lBuZki6gCjZd7iCEyNOrbkr6NNZwQTics1DoIb1gVdOVfQIpji/9FD/QtqDM5WJ
	oyJm9vrKP3ShaWR0aLK59u7dZs4rZZ1edFPQd9tzjtA2DFKFgqmZ4jD54w3H4I7zpNFISh
	0Hosy+/j9zBEHwWgCJiHLjQk/RBcb2A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ahajF5mh;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785220805;
	b=FaV/C71MxL5uVrzexv5ZQUOCfE32TBV5rU8uNzeL67MykGtzoliIthJQtUAF/n+HmYhHEq
	c7o+/XtNeWR3qtRlovSgnVFIz56w0GVd++tN/lc3c1lCnsq3E50DQ+t7kJLXVJX/K7jM2D
	NslCmSVlpEt+g3I3b14NNAPLpPl1psk=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-848479c9bd5so2706229b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785220804; x=1785825604; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O5vL8K7elVixiyioHzvpuSpD8hwQ+IAvP7Z0RgBWZFo=;
        b=ahajF5mhFtYKJjrbDSZRkqIkrkaZ2ZZBXl2RxS3KEup3PhTE6A79L9MQQ+IeS1Jx43
         7oyqhcqkm70Zpns2nkICXYW/zIcOF3JsdmKoRTPg+CaWnsHs6G+LdPBaK0QeuzgQStxv
         1SEO29yUCPWOCTEemNYlGdjb0gNmGpf2q3A2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785220804; x=1785825604;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O5vL8K7elVixiyioHzvpuSpD8hwQ+IAvP7Z0RgBWZFo=;
        b=TzVx7SS5viQO+s9avE1JDWDe7h6PPfCAAuWLBGAOzGb6dc6E8OcJvsPl8UGgoPXSYz
         nIZk+ABNWLiYEHXUc/VFxxriSmfGgWSCux0kvKAYvA7+O3POwpapqkKIWyh3x4skiu1z
         /c49kfAOnaXJyKhF+XGO19ameNgNfyxRvwGMhaVi9bqgz+aq3Ubv9RtyH7EiBLOix8bi
         gIbf6Ys5bQ8+CDJ3CQogXB6MNO9rJ6Hcdw4ZtmUxDiVMr62X1rEU4hPodMfaaO7Ijfg6
         jpc8mSSBsHUqMa7wTfjFRR12PL+K+rVlAxG9OQ7b3uO/jGBh9RhLSS+rmOljdF1iXiFc
         3F+g==
X-Forwarded-Encrypted: i=1; AHgh+Rpc9RIspA2sX14uKm82IZlARZyxLtdVzIf8Y5zOC1UYv4TMV0OWPM7JJQpILnibV02BcaiRdgZB3A==@kvack.org
X-Gm-Message-State: AOJu0YwPgU290YLMq4cXoPuJzyfnbXlI72dRmmwjW8oVSMa8BoWXPlCB
	ZWYLh1DDcJYLZaKdfhRuVc30/Qew94K3IlsBBVkewMiJctSM0Nu4zCPlq0fsYkogBA==
X-Gm-Gg: AR+sD113dEWFiRWF1LcWJn6iwgk3STd5HTpILA2ySMItYHwH0IDUxoYgsc10mcLLwul
	1bYYCcHSX3Uf8Hv5GzCxw9UeRH4veijcLlFRwW+dhtWiDR0f1/7Vw5iG2uefs28NNDkVZVgQGkO
	DMEzmCpa2/BvB/erWTpSPq1bspc/lvOuT46p2V+QeAoAgVIAXYT3Z1vHKieafFFIhso5VH/Vu0B
	+aqXhoslZ4X+Y+tpg4pQhkACst/j4pLtSMQQBCjDiQDlq6PfhUDhtjsMZB3dNVMQqz5DBiqhdMI
	VNI5wkMXf8q7N6rZW7A5Po5Gl0XnitrUbHwnxBluipLc9+seTkCNAuAmzfiWKNR536eBvtWFJX9
	Sr5NC1DKwKXswJ/oqjlVvPW+aBSZhtnyT8vUy6eVQHiSxGPrT2qAu3RFzI71TQRDePZg/oADU/e
	7i6O9Gi2fK2Iss0kjbuCx4tuyios7bagGPjyKCftVV71CiH3S9tJmFRwtkNyaozUwAB25PNbqDe
	3iOwC5782gwA85cxeQ/84HvIViE
X-Received: by 2002:a05:6a00:3992:b0:845:e8b5:8c49 with SMTP id d2e1a72fcca58-84e932c585bmr1091894b3a.10.1785220803771;
        Mon, 27 Jul 2026 23:40:03 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f891:e0e8:e2c3:fb20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e532ad0f2sm3878806b3a.25.2026.07.27.23.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 23:40:03 -0700 (PDT)
Date: Tue, 28 Jul 2026 15:39:59 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Chang <richardycc@google.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Martin Liu <liumartin@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: fix release order of locks in
 zs_page_migrate()
Message-ID: <amhOkJPfTjkuWElp@google.com>
References: <20260728055333.421080-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728055333.421080-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DB7DF40009
X-Rspamd-Server: rspam01
X-Stat-Signature: ax3oe9y8spgg7519uuyacgmxaszn1a39
X-HE-Tag: 1785220804-722237
X-HE-Meta: U2FsdGVkX18wbQ4iGnrQ9KixEDJ7ZjZ4rx6zE9fFsfa174OV6Vi06v6iC8nIPURuSa+9sTZIvloUauDBSKlSNZVw7UlTz3TL4qKu/wbXZcU2oqYuXQWNKf8K6VEQHS2qQtknkr6Xyr4SbNXtYF4htG/CN2QX/+nKTxGSYjvUJ7211ghmIT0ShdR0qZDxR9PgrrRUmabUMIyqBgyZySKV7CnIh8HcWXDjppmT70rqFWXfp3emj/ezTftDSGTcUZB2QnTZc3+kbDZMq0sY/mrFklyPMTeSgsQtY6N3KeCY8W1+cgvPBZQhpWjeXF0ZVHkwtK46aEdvozQXO9jBRJCMeLkAr7GFA4um0tVsNOZYSBZAwa0OwvRpZvtFNx6S2uqlM0SWtvayc2uj99TZx3WTAhjBUxCAaeANa/F7KHINdp+eNqKNjRsH7DpVwweqnTndOCN0XJYqAAsAhnANVsFXFuV13qsKp0GG0JnZYwgjVpZqn6MUiihvfOapfxC1AHEdQivy3ovk29JtU9xuFbS7Q37A8iJYlBJwphP+QdoLnRHFYkCT5E5akWsxItdtgh0/SiFqDSlyf4gpU1zDWGD0JRgFGYOXeuIR/6zDrOFoHYfcoVeKICbmi2Wi2+GmAUitC4L5yBmA85IsUHWEF2v5kRSHecH1+lIsYEAFvAOTe0r9Lz0/hs0klgqEflNMmqpLTUC9RT4QQO1BD8CJ+LOpGTSzIv4sOvklnWc0neab1/v+yX6VkoeDDWSVAFtnNIG71arrOyWBS+3sMsH+2/lPfFxQS8M4Ob5D/4gJynRn7WAgAFYIgg5Nf9pxa/II0pzADNln81fiQKgDs2YkF5iTm4mEn1OuMfXaPZ/dxJOcz6RznbxhYglepp6mqD7IMtXc1HWyp+SegWg8bWMcnzvVx93x+adX/c48baGk6Y9KZajpHATz1gVTfewvczi5JDyTs1O5kHetcZWmp02Ax28
 LJY49LzC
 5wJhlsg4v314mMlC6xNobkPJUP2uQdI2g/bUcma/oEpLcPwcI741+4SxKZuXJ2nTK9RUE9nwM2PX+7dQC8EbnMZAkH0KMUqDDOwqZOtHVfzcc5XA9UeU3dNTl4Pprg1IxRrNRgWYnicOjuNH9skp2ZVDsFMjd0S/tUUl3Ap2nShbzT8Ha/A+NJQOPfHjDh8H8bVrRRyPmNkFgb6CGMObIgkWXgOxIPXmQlzp6mC6b+ieljT52yBv7+8ln0QfRKVFJc+wgghtZKk9H8aTGQnkGdIbH+H/s9nIT7ysf/gqc6qeFAe4iEwboHRmt4/PfhNjIg0pBiwaPJdsf36BbBQ5Xz9UZKQpf1AjqbcpdylBZruxrou0WWFU89qz5mxwNSm5VTwGj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/28 05:53), Richard Chang wrote:
> In zs_page_migrate(), locks are acquired in the following order:
>   1. write_lock(&pool->lock)
>   2. spin_lock(&class->lock)
>   3. zspage_write_trylock(zspage)
> 
> However, upon successful page migration, they were being released in
> forward acquisition (FIFO) order:
>   1. write_unlock(&pool->lock)
>   2. spin_unlock(&class->lock)
>   3. zspage_write_unlock(zspage)
> 
> Fix the unlocking order to release locks in strict reverse (LIFO)
> order of acquisition:
>   3. zspage_write_unlock(zspage)
>   2. spin_unlock(&class->lock)
>   1. write_unlock(&pool->lock)
> 
> Releasing locks in reverse order of acquisition adheres to standard
> kernel locking hygiene, prevents potential lock ordering and lockdep
> inconsistencies.
> 
> Signed-off-by: Richard Chang <richardycc@google.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>

