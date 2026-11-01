Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FF1606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VGbBnxpN
Received: by kanga.kvack.org (Postfix)
	id E3D8B6B00EF; Sun,  1 Nov 2026 03:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC79C6B05B1; Sun,  1 Nov 2026 03:59:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92266B05B2; Sun,  1 Nov 2026 03:59:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2DA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:59:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 146C8A09DC
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:59:55 +0000 (UTC)
X-FDA: 85385952750.21.4DC2B6E
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 436F3100008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:59:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VGbBnxpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793523593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qot3DPVKnGE0VVwUhDNO4+shB6YIfE7k5yrGO2m+J5M=;
	b=B3kR1SXmZdbAh3cDnoTSL1+lRh6UPIxvwU3xttv2YBvE6XGffk3KwmRkDLEdv1VkySRXlT
	wB2Tht/80KI5NWsmdCMMb8sMFe5rAazO3GW3zph1jmf8kp+7V7jRh6gXZyW+hmYYQl+Gx0
	Pb+PNGB+aarYEoX4cnel80YSBTvZQAM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VGbBnxpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793523593;
	b=qzpZVstdNT4IhA2ve1MGZ8kp84XV4n0H6mIlXrSfyC/totHzdoyNAQndOf11TICfc21GB5
	nkgEJhPgTOymvdfFiVukjvB1p1vVUD8ptDaPTaeMLRThV+y3q7DoPzkUFOr0o5AFTicatX
	G/nMZWnkSW2vDYQyLBIrRLuexMewKC8=
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a24f47293so1295152eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793523592; x=1794128392; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Qot3DPVKnGE0VVwUhDNO4+shB6YIfE7k5yrGO2m+J5M=;
        b=VGbBnxpNJHHAKlpn2kuDbwiQ0nkvLEB4ig/p38SQbOYrRocUpW+DIAYam38CYNvVwX
         nxjH1U8FauE2mnSoL1zQv1JVMe9ZXd/CfmQWj1ypkcyKW8NENgWoudpvIhGk/srMZg6R
         M1UHTSMGwJKkv7c6AYMY4uzPfYhGO1D28fccO0VFFSjaz2gZWQZDiDF4v+Yoi/XvQQwx
         2Q9sD+f1aKmbl8g3Wq8IHQV05ROa2272wszDgStU4GGDMPRGa4L0iY7TWM4ryU5iuL8u
         qotol9c5P3aJum8hz9Gw0fVb1eQqQK8clWKcPi401bNkt3h21O9nL/BjbbPOyFctdraL
         cZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793523592; x=1794128392;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qot3DPVKnGE0VVwUhDNO4+shB6YIfE7k5yrGO2m+J5M=;
        b=E+1ob5PuFAoyKdvAo9W6V8nGPZYKlonS/UYuUI/cfLYrApcH/AC3TlPgmj2bX6tLtp
         PZECkIYePSHiVMztiDQb/LTzP2BxNVMYAcxvWKHvbG/fG8S9/L0ePE96B3cIDJqsEC1H
         3PQG39vhxt1zyXwtD4QGNmzJsGbQEE4lwzgqthKxSp+cpt3xEvqqlfetW8pYE3qXWXcg
         66328ELgYjk47ueGR7F8tVfn292GIVqtc+I5XfwR9gVbRdegVeAO4yqMDe7wydc1EvRY
         DE0mEkcLz0Gm4UsOyAvIOBMZk3phsWM70AqoYQ8TGQyE8nZkG6G2rqhip8bUY8jJsT4M
         6TbQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6dUYfuhgQRSQSOtKnON0XGZRe+WkTIwWeqriNVJqpPGS8eB3kbZvHa8X8xJ6PckNWXNHGNd7tiw==@kvack.org
X-Gm-Message-State: APuU4Z8FK9AkKP/n1JORYweLXMQEnS4N5pj49GRZleWNxk8q3Xjv5yxA
	hv60rVQEynJo7H3huUZDVqSP6IBS78nsoffhrylvZZA/a+9E6s3QEjzT
X-Gm-Gg: AYBFou1UCA5kQqJKNF0v72C8yXwUtPubhHTbmLtjHufm+Rf0AflVTyPw5Enkx4EBN/l
	ZfitFT6ucmFaq7962PzxBrut4TB9eh/Fm9h7bvO0HaNSyF9FPOmry4eZmtJnUGFEJPaVtTi0v/4
	tKGUGvSx/n/V4eDb5naBDHNvKSIAoUDlsVsQJsc3XXl73NKMkV8yV0zED3JXmeqoXP8P/S2Iicd
	nwywiqnRgxHn/MrgoozD6Oob2Agn4mVZvlmEUMUmWQvBApFQG6FVikkwxjPRTUakgLlpVwMDcWk
	c3O5/6U4Mx20XBTPpbYzg5tCDPrUCohxeaCWqE0Wa4zBB1kkmx6De4jXT+IMReSUeBC1PV7+yjX
	yL/Hzl2liwX5sNjErzO5rGdI+iqW6qB9/8KndXSRsRHgrKFzG37uTO4cmIGjPdZ95ggyTtW1dEf
	0Pru1eWyeK471MGGrzxzNNxx6R5i0DPXp+2Sqo2qUv89IgSOwPHF6sTXRfBydtV9OMY71aCp6sd
	7/4x6RauLNv5jSLCU97WKLqybMD03GN8VYsEKLVOixKAcXXJKnWJWFuZce5DLu7Cx4xy183F3Na
	Y7CO874fAVQJNxSFFCnZrIegvLIhBQphrGizX+kiRBep8+LpY6J1bi7V+GdQYRzp8YvXqDqBXIq
	qo3eKwyQn1l3GWSNjhP+D+NuC6Kc=
X-Received: by 2002:a05:7300:ce08:b0:343:ff9f:26f3 with SMTP id 5a478bee46e88-36a42401de6mr10143619eec.9.1793523591850;
        Sun, 01 Nov 2026 01:59:51 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a5eee0f20sm6176212eec.17.2026.11.01.01.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 01:59:51 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: honor write requests for owned device-private
 pages
From: Aveline Noir <jm5905938@gmail.com>
Date: Sun, 01 Nov 2026 19:58:21 +1100
Message-Id: <179352350180.2.12918668886938034091.b4-reply@b4>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Francois Dugast <francois.dugast@intel.com>, Christoph Hellwig <hch@lst.de>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, sashiko-bot@kernel.org
In-Reply-To: <sashiko-outbox-192310@kernel.org>
References: <179343062238.2.2773026701442863377@gmail.com>
 <sashiko-outbox-192310@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 436F3100008
X-Stat-Signature: dyt9ei8u5xmbrhmbwwgrn7gz3uk5kak5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793523593-23914
X-HE-Meta: U2FsdGVkX18+telTQwC97wTiP7DPfgNreKaezVV/kqb/EWJFNQt2UqPSRc0bvjTOFcxJmypEJ3oPbMV3TMrNGz0UA/Ruq54oIM8lNWfznXAboKOg9gGnvzUaWjR141YGVW59FwQOMuxa6ZtHx7v8L/WyZH91nMaCtxMNtFq2oWWK8mhM95RGSk7axxgRL6Lqodb0ZvKkknWD9pU7vEtIuazjYlKN1ZgkJarb0rYkWt1PrASQlMnhb8Xaupva2V2yRhFPUfw0dtfTzhtx+CFcmpInBGpMfAIIEdRkuWgIEvbS88swnQQ+WKB0lbGSrI9Tnvuw65c/4Fk863IfmoEF2hKN0WVItG/6azU21ELegzoADCXYlDwaLL3Xtgm5se1aEUTjUmJBbzhq2ie84et4a446zu0F0DpmvfwpwSCUB4MUd11CN9wTguTiVIWXo6YLZ26JgLciun4DVpi+cEa9UDasRGoC8l/cjqy5liBF42vEXxMzpRAYf9C3p7GeqMaJtRUGItkk7irj1XcIPOV3atIQiYKPSCqlehMs1Uf0sei4dBpx1yH3cGFX/jHC+r+dKuW+Ec1XfFcZM5YQFDpyUhW4xFPzGvf6moK+IvP2VgLeHF2NWg9ZglW3w+C+CnbeaYOElAdikaLAfo2fNlGb16jfENToy8o7sEyuJkgoW7XVMmuqD/dn81eFmHIANH/G0yvKqIbn/VnMX1rI6lVK22qPhKxEsfdkj2rSpapPaEwpYzAJnO4YL0XDChdNj4H86szLC/c8W4zhwUXFy0emDxraBI6jg6zbbvfjihtCOeTwaCsmGTBJUqnikEAKVsUE72KTGwhCEZbDSwBv9wkfOLgPfBDfjhR37w3wRe8kRoR5E9GiMZs+06S2hnAmRg8r1NiAtvRAESoukxjIE2JlQUeTbF6Fmaw9UHR4mhg/9+JGfqp8NDjNJYDD7iZVjMPh5DFFXU8JA3QBEdPCOk6
 5uSI/BhH
 UJdKQIjdgA4kObnEgqEeDv1ZWUp+br4v2KlfXm0UR155W96Oot8yGN/dYAthYAEb+u4ib7+GB9TsDK7rKip2OoStAQqp3uCcAWmXpUwqi0/dZ0DPCmcQTD/A4BRNwlwEL5n6tmtiYWaNxLMtcna/MjacR6UfIR4rScMGIoLhU95s0bjjcTUUSNJsolkuZFb/SmnbqMKq9wFRdSbyNc2sjKLg21cPIThBZUITnMXQzDzn6CZOMDsdI1NxkVVvN8cEcUlYwaSlQkMcSOYyWFILiNy9e5At1zzqNzk05DMSjw2Hsa4c2NHUhORl4F2YCwUuOZYpAcKtVT/HykAAvYNv2efC9cTqLuQN99LamYDvVPzzwphCX4o+N770tSF6sc2jW5p4dItdF5yuAeLp2Uiy20/8z4GsYY1DJdiHrPay3B/c+1ZFl7IJrmWC7bpfj2pP33XieUuQcQEQfqOakaWl+Ng3vJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sashiko,

On Sun, 01 Nov 2026 07:29:15 +0000 sashiko-bot@kernel.org wrote:

> Since no MMU notifier fired, mmu_interval_check_retry() returns false and
> walk_page_range() restarts at the same hmm_vma_walk.last address. Won't this
> spin forever on the unchanged SOFTLEAF_DEVICE_PRIVATE_READ entry while
> holding mmap_read_lock(mm) (or mmap_write_lock(mm)), svms.lock, and
> prange->migrate_mutex?

Oh, I missed that. I'll try to fix it.

Thanks,
Aveline Noir

