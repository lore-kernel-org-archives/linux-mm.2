Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8211CC5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA786B00B4; Mon, 17 Aug 2026 04:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680E86B04A7; Mon, 17 Aug 2026 04:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A696B0917; Mon, 17 Aug 2026 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35AE36B00B4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:31:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2757A1A071E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:31:14 +0000 (UTC)
X-FDA: 85110091668.28.1802654
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BC09A0009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:31:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BikNjR1C;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786955472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ah5ew8DbE5Myy/gE+eNiI8cy5Ie1ItfK1DXj0IGZCH8=;
	b=ZYXy/oNCRkQUiRnwe1BGElWlzEZSjpKggRCAX3KMsstosVPmmBK9h8uLR0IUcfwcx1Pnpc
	kLVW0R8fBEynZ3Qai4q2iSDmQGiGJGfAttU7mIDzdi9zho4x0g5JfA22yfK4x5dznsnnCp
	MwVDRuH0cKtJs8X35utKkZq2cW6ljXM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BikNjR1C;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786955472;
	b=ECuqUD33AR2CRfpB+jZETspalWqBjFKSCoKZvWHWvsymmv4PXkCLeUg33h52keLPqchV9p
	BpSELQHuEbDg9HAqCGCAXEhUlhnZqWf4d4kow8F2G+djmTl77CgzxtwwN7lCFFnuCZ1339
	oz8/mTIZZhbY/EdPQanuAGSvoezHLOs=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1587747f8f.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786955471; x=1787560271; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ah5ew8DbE5Myy/gE+eNiI8cy5Ie1ItfK1DXj0IGZCH8=;
        b=BikNjR1CVHdyFNC+pQ8ZDF/K1T4lU21MuhGknbCx5p5oUtYGqAjx+vPVBM76tCS5jb
         IM+Aqt0tJPm5wP7kMDDx2fZqGcEEg4Z8fJJ9mGMRAKNl2ShrkY2bHyjAlOBOEJR88r4D
         4izPRCaQzwteQxtGCZsABxbwKSkxZj5Crij/mavV8abH5ZUkt/lUn0efnLxazWJgmzOh
         ps8UwRXASJCoDGitTJvwS+xPt1BulCAHa7HKJiPvJ2GJ0po2s7x67oVXZohIahR+0eBt
         HqMLiybkcBWT0ejPwY5X7GisGDElBtgjf2RRf4aO8CXE+aUkO8+GlG01ldS60Gc9V0+r
         I6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786955471; x=1787560271;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ah5ew8DbE5Myy/gE+eNiI8cy5Ie1ItfK1DXj0IGZCH8=;
        b=nnV4K0W7WA1RFVt/Zoxqn2FQ0MYZM1/Dd5v76fJ3dOz/OYjG7DnrcAAK+1cYvsoP+Q
         JG06dn6MoIVMVcImzd9DxXA+CNb3lQPzpBx5ZWuPuKedb92P9TXmacptzFi5Eft6rYX3
         HOcXSGvVTDqnX0yQ83xOvXgWZcc3gUQSWfoukez8kiporAWKTtc20Pg83P4VD5X4HrJl
         WdEFUYqLkqlMk1YvnwltAqDQgnE7i9FiEL4Lyl6jWXJ1F1gc6977rYFyW8QnNmDF9MJt
         qNe+NpHc17SwPc7y0evBszYEDh/HWKKu71++zOoH5E9tr7B9k7++yHZlqYDSwltg3FT1
         b93Q==
X-Forwarded-Encrypted: i=1; AHgh+RpwhKYVWdbV5t6o2y0WJaS/dHbyg6ptXG9Xb4JU7pRUJLqJ5h1wVUew+1mP9WsNHRCSuJgRWVMEcg==@kvack.org
X-Gm-Message-State: AOJu0YxJAKpfpuC4H7dY/QNzZC8tfVahR1N9l7lnJwZbJJrLiCHvLoZ8
	VnFVvMAlqdm+C8mjOQc0e/M5MlCOpmMPs7XogEP2fBcru+1N3StoEDaNhUmx77JLOqk=
X-Gm-Gg: AR+sD10wtMgz04/QcBi9ZKbf9v2kkWZ5b0Wwj2W0Uc4KwJdvQ/w9ul8dltPqtXXWyFm
	6KHRKgi/Lz8oApYIoAfKFi+gorVl/3QnF3wBzO3QQJE7Obzo/M+yCScQHUJfpaDRLbSnig9TT1u
	Mc8+F2lJDxnDoggUqueCf3K/eqQs7+oji8+iMElH1tBq1BBIF1VCWC6rjjpmSzknIb374A45pV/
	glv2S3aeKlhISE/5wLdC1U8Th5wawQetxi9RSmAflaAQ1CTIPBwvDt7zzHeaij5qiNPP2sTMghe
	VEzodwQ7Og7LTVOivyO9bBrJppwFTeBp4QDBi6ZQ68hKWy28ZzRxnMefP+nwfln3KfHk+kSNw6H
	MbOuXhBNys4XuKx1HxeifJXNO1iadOv2v5O4XZRYISGnfBtb41fgkQkcPh+B4sdiHIqN1N9ilRG
	J+GiljSfs7zT7Lm9mDTLV++pY+i90uAHJzuuFOL9fMZhMOC3HNY6NU2dLo6u4mLvwsikDKDAo=
X-Received: by 2002:a05:6000:460c:b0:47f:e886:6dff with SMTP id ffacd0b85a97d-481606f67e3mr39202641f8f.4.1786955470859;
        Mon, 17 Aug 2026 01:31:10 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b816c0sm1827065f8f.33.2026.08.17.01.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 01:31:10 -0700 (PDT)
Date: Mon, 17 Aug 2026 10:31:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoLGzZHS8kj53-ey@tiehlicka>
References: <20260817025917.66233-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>
X-Stat-Signature: ywibca1ut844rfm3ne4kbobmf3fswnj6
X-Rspamd-Queue-Id: 2BC09A0009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786955472-189709
X-HE-Meta: U2FsdGVkX1/NOQGvaqmbT4obzmAkuzV/S7Irh6xyHASRfB6+JgjCQPfyJfYDKMbqKRu+9uoaAcI/W6PBb3j4nO0naBG12wqdOlmg3QnVv3dxBL6FHPELV0HOqqviaYUPi9imLY4QqJzcOSk4hMUDIPvTv8PRZuhEMrungWlT9NJfaebypMEMv4n3hOztPiSnI4VX5Eu9kQmT1LmKaZUUAc66NzTbAkAGpcziL3ULCKR/6bdyTcMy+IlLxsdVaUxPGNFYJoGr6S+4AH4cOkUpQ37r9/iYx4S+OEv0++XDzLf73ikqpUy9Zb3UtVASwYNc6XZIvRq+QSvyEwjZUWwuRBo+hSk4uFHxGfuXn+zzZBLcvhtDaRcohmEBXAvOo5zcNYxSgkLPhqiIi75d40Vz+OHAB2I9jSN9pF1BuRph7jGuXq3NwYzNssXnaJYcEuMcwpDAgyrcJCbxRfD7LA58U3bGdsFENTpbjJqsfP/76yTLDKSLEi3F+O2gByyOUW/LMwJwHMIDeFiMD1Kc2nIpbOB4j+2yxw5wSkLe7k0XxV0gdhj5w1KIjc43Hery2wDTOD0Ftg9bgkX2DIV9DdOj3esJUfIf11A3RefMzin7koLYctfg4fLQlig8FxS37zn3Ww7jVgXzi+YCNeiiKI4YhitUBN+Bn73jc328D3jFIMdevt76Cch3zbDBs4Osy9mNH0uiZKMBYbbranqUuEElHU/x4XkDnBkgzapKXN87subVZZNdddncdfnQtLJBacjTu392fSpZTfJ5ji93KFtpxlKC/L2g0C8gEpjEx7HloH/JowIfIQNS8e4drLaYxW+KSNmvytnLK53Opom7hEyNE2y23Lt+7rIhrYISu4J7H3/FcQ9G31pYtvCJdjul1P6Nku39Mp6OkBT0IwDXhWoMIVl7XBBej4RkDcUIHdxtB5WDDZtMkb1DjS9lFvZG3dESeZDUDzatTSXt5+BRuYC
 I68teHp+
 zvj5Hhg36xvVlXKrovOqjvGsgu8Q8OOhnwqUtrzER15/vHzFwcZSIdm7j+6b1HTBtOHiUSKOFQySHiPahFgryZKuuKrCBrMi/cDEOq7c7r2apmb8p5f2fS9m5K9ARrSr0f6Tn8mXCYqotJRH0bmPNZtmJAd00luqltf9HqjQXfq69bH8a/yeXziAy791BHyDMy54AFF53M1KERUMXLRL4Z/zl7+x0vplvq89k72kBk+Udv3Q/deWi3Ypak9Qb8PI2ntvHNhmkFe4SYd+/TxN1Lz89PfSvKQMV8Mqbl3BHzk+swlFFEVsyv0p7Ie6u78wNQmEhMj5BfcZdyXAr5GP42sUNf/F3jhmElCwYDcu+YwSSUFeFrHplICy5yopyhiLuMt/I1K2xlu7G/BfzkRih8QSCwVaLUOvl/pIdpAW9bQt1T5RL9HzoeqVNZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 10:59:17, Song Hu wrote:
> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.

Is there any specific reason why the memcg stays in the cache slot
without any pages?

-- 
Michal Hocko
SUSE Labs

