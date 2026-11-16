Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C64606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WWmkC8A7
Received: by kanga.kvack.org (Postfix)
	id A060B6B00EF; Mon, 16 Nov 2026 16:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B73E6B05B0; Mon, 16 Nov 2026 16:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD016B05B1; Mon, 16 Nov 2026 16:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6938F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:31:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7D691C29F6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:53 +0000 (UTC)
X-FDA: 85442279706.02.F985FC4
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA753160002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WWmkC8A7;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.50 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794864712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=IHtCrzMmF/+MAZJDvSyW8eBLph7tjxs6armDSTHVYD0ez9Falv0P60JJq8Wr2XztTns6AP
	KfnSR4FRLyNwXm9oxs+dkYnDZ4XzK/yyH4dcu5fH6BarDSL0Bc3NgvIK36pqBcq4/Vk1AX
	Gm/LHWrdMxDuW2cI0S3rhNwxqrXXpuc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WWmkC8A7;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.50 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794864712;
	b=KWYoByZQXtKGcb+eoPty6TiFwEOrD2pGV8pQzx1HcDK8FNEGAgud32KyaKPfEgNjyrMLA2
	x09qVw0Mep0qOgFpIxuQB6NBZOSVgdby2FUbCqGQCRBBr9uIg+ai36yG5NCE19jYNxI2+k
	kuTISrOO/O+oFOXok/Ta4e4M8rKcLC8=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b3acec6677so5726149c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794864710; x=1795469510; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=WWmkC8A7ojHGpsZay/l+uqDNKgXj+5Mf1TX8Byq8q457WqFtag0eI2FpaKuYHX1GHU
         ygxz1VRCu4VjYhlh6f9jZHC6fJAiwWrSfoiuOhX8NAM4ZmywQUmRiZVWCyY0GB8hwmV+
         7elA3oNelAlrDlFT3XOB37znNpR1i2IBuWzG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864710; x=1795469510;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=BLw/X+QNWloRONU01x9TUKN/N+sLmoiizZZyDCFtrWtQEFOaTFpfVwb37ts3QKtI+m
         GbMXqboNKJBTG3AGcXUvIMsW4Tgp2VmqdvZbUdayuRBnAI7uOnF6PwhUBr6iMsxyMfsk
         ecE/YPyWF+mzOb1PyrcyLKuFRdkQXjz2DoA1fhCgynuAWpstGZBhkLf4zICQ8DsOB8YH
         PXbzgO9cisdQdLPKguH4Bbo4AevsOHpaFQ88suoQb7GFJYwT8J4xZuxDSqJX2SY/Qj0W
         S8BrDzm0jPKj+oPMIH4TrNJEULeHET526/JzMeRZNtKI6lXXacAY+7IcRSAKuctfoFwp
         ewLQ==
X-Forwarded-Encrypted: i=1; AL+hErH5I+JCVNR6JRRwDFfMwsaJ7hrJ39KLdP6ovB6Y0hWPn7Oor6IJwdGJMkgLc3whKeKStr/NULYvNw==@kvack.org
X-Gm-Message-State: APuU4Z+bHZ3KenrxL33uv0a4+zf9b9i51ExwgBW3HdYehrycS11skccA
	26Ggr+py29bSZ7N7lLFIJ8YIcqLHfSvTTtwYGWJxrmvTFRew6EbyoqOv0mpxUsKhdO4=
X-Gm-Gg: AZFdTZdxd/2SbPB+O4dWe8Pq839wEzA9B+c5DojyCVaxIQkjyxyk9Et4RT6sEzroGjO
	Iv17b/3qPaGTjasakYxxw8ZDs/Mpr4IhAtcAUKZ0eINHhfFA14KqsTISLW9OjEIDPYn3JMcSTbS
	FJsl9QshdMVrRV5rKCNFQ/5uKFSJfdd7Lf3cGUpB4qBwvvKvRi9PH9TccfxGQLjfb48rDqf7d9s
	uH0Fl5B1moHORQB5jvbW0Myz6UwfA488oaWzc8R9JA3WFVuTRbwYxrh7cE6qw6rGdIDARrTWXQQ
	8V7j5NRyyXcqMsfL6zQk/slqOfLaa5ELjEbP05p4J4La64nTEKnlKVgGsTF/n5HE4H2DVKSS9hv
	LWOzXxUSSXPs8B2OGfVv4uZjmzDvCfFP47mgdSon7Uuo0H4bZD389us99rpTq0A/t49Tgy9+MyC
	IIzJmmHITLmvlGC61wIzOmWNwTrf+tfM+Bs98nCBS0UhX0vwQdeDqe555RZn0kMp+E47qRR1n7U
	vTESB+mQay8yrI98O5rkFr0ylvRbNdd7KnHhLMTliOTUI2K9mmL9dnwLpsndOtNnnB6vOyn19Fv
	PWF8Rrov/jxq6FpJMFhPFlwH6ksIs4GCQm+YlbFbLaoGSCCCKHXT+6gRBrUMtFLLwhUxwBaV5C0
	b4G5oShfD6vjZ/yqS7mk0N4n4y5sHflMOuAzXdet/T45HfDAqkOeJShgQxtDqwK2tkT/P/++I1R
	GwsRCLj2FW2fqT2rlnaYMGsA8jchWbWet78+PiY/IK58i8DVJ6zVS/sT7lLf3G+pUY
X-Received: by 2002:a05:7301:4d07:b0:375:87f5:ccee with SMTP id 5a478bee46e88-379684b56e7mr12617736eec.29.1794864710396;
        Mon, 16 Nov 2026 13:31:50 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563df84fsm72571250eec.20.2026.11.16.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:31:49 -0800 (PST)
Date: Mon, 16 Nov 2026 13:31:46 -0800
From: Chris Down <chris@chrisdown.name>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mm/page_alloc: drop unused gfp_mask from
	zone_watermark_fast()
In-Reply-To: <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
	<20261113235238.3595412-2-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avt2QreyA6p99XLQ@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: edgx11iqg5w1af6jwk41gjowxdacepy4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA753160002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794864711-813333
X-HE-Meta: U2FsdGVkX1+KDXvXQLhAjO8BN14mbFpyI3I/L2cZgtMaaB8Q88FWctUAcyvvNBBGwMCPx4d9I715Bnkli7JC95b+DICtjef306Pkbz8y5gXtcvuxMYokVLVZAYS9BvRJfaclW67KSWBkh2VgjinQR6HXFhxrfLn+fvD5213Ol069dkOr1dB15uWO7eqnsBoDbi/ze1uMt0GYFyGVvoU6Y8BwOHV9e23RwfM+vXTPElAYMHVpiSsmiwUXCxSq0ef7KIskbubldCICxbHSPQ/65GaAD468+g81qX3+hBR1FI7w6gDbSbU0W7KrS1RP2W9cBUtD1BOQOPBxxTzk6WWGQ/LPSsnRnqGMrZc/UWFQxgQNsdm0PvOmfKGGuGr+Saanp4+7xCHp8+1jDhwNY9FxcyaOFDjbMF6rO2te6i6/Dke0Dz6g3igGBVranmxEO67AwAuX3TZNtgvXqaHrpqtzU3yjoeV2zvPtAUvI5ZxjTCMZiyOuwmBdHRmKNDQ2fzA3B8lYTqg/uj8NO/A4nZOeiKEjv789cJ0q1RXkQWH3VsD23vRG90/fMrYuXhQU38cb8HfjKGBN18BRLygWPwfg3Ncpc7IL89Amjvv83zWDeA1CXdPvlbng/GKJIsC9dl2bK6ePxAvj16HYNyDdlRzxkUKj2N1t3JuZUWDou2eUouZxTeQ/RhiLoHxlubEMs/rmBuNDRMbnrRp8iBGWnUKvru6bPxSWTxNL3s6t6lAg+FCLQMu/lGtp6f0u8oyldK+XqOaBXlqZgUKO4CEu2nRszW7R/HZZcuXo+/9M4538j1q4PZk1Ln/ckyb+X/V+jTpF1umxxhfAJ+5GRK/LrjraXI73ksY/Ic7q0rA/edmMLz0eWyjm3buugbEsFVU4OeJsI790Y2m6CnieUHyweaK37mD/S7sDcIdl5PHPD6uEFexeoQ9TI71l7PU8EkHIY+BQD8xpufyjXxKwqK9gF0s
 SlBf4Npp
 LhjdwUd2CRXbPg6ngb8TOMSZVxrgEpbONl/34eNS/ZGVH9ADqTOJ0XgLSf/LYvjNj+AhlR6AuXvI9+o/qY08mlBdbKjfD0YvDYRFVrq4VRGGLwY1mBtUNGrBTEe03A/KSexFiotM//qQamnkbrsdyMQekiRdwJQjgQsAxDZM2QqSRaVhCxzCBPQhGlu7lwlMpAJcx682zsXhLG+Fe+dZkpkTgeDL0hmmNGscaTjhxQjLx5vPRh3kq8PFAuXFrp2oVhY1e7LkxGOLbu/cm4/KSs7UDh/pH2orOpGgW/HVtTHe8PJU1Rgon5K1g5HBunUsQ8uNmm4JHEVeJ/U1mnmh2am3Zgnsg+JsbTfyHxNDCWwidAGyegOde70jK6GgAoOvNy6/8QYy4zunOP66pY1NcdtJ2kk6/OTu9P831ZsqyUQK6SbB4VfnVQwIq2A2fWioF98zjY3AUoArfpQ/Ua+phPipKva2LlfnepTrEwpc66CS/z8XkyITmoHA5+a4TA46pNOz99ZXHaEPaKlcWzg72S53SoEpvC12TZBqr5dPGzvLelFNL0+q/O62oS2S4oNdXX9KpN9f/P2BSQmC6D5mkGQzqF7sXit6BO+ue1/D4PBaqfO/7oa2T68CKog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

