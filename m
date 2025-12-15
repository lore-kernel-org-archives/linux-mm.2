Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63444D5B866
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5CB6B00AA; Mon, 15 Dec 2025 16:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78BF6B00AB; Mon, 15 Dec 2025 16:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E7B6B00AC; Mon, 15 Dec 2025 16:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99E2C6B00AA
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:18:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F9E71603A4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:18:00 +0000 (UTC)
X-FDA: 84222967920.06.1CC29B8
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7EB6B100012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tb0gRwKT;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQYOTwdjJwYgvuX1nPstCicu4NCv26qFYc5XYhTLu6s=;
	b=hcOXzgktE7cY0CBkzf78v95XE1Bwtd8DvJ1wYkCINLsypC92G2KqHEzu1naBHkGiYeYuHT
	ah3sIb5XtM5eo0LhxeEmvgAO5g/6ZHTzxGEnoPfiP6lHMRuiIAx3pdANwEArMG4urMe3oq
	uD9PCAelgZ9EddZGMP4IZ5nJeDf/uIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833478; a=rsa-sha256;
	cv=none;
	b=ULLKjQUeHWlIo7mHuJOnDCkepmnyU0sbApF6UcCSkskoQ8GxfV69dNm/Gkjnl/qat49UGz
	lw0a1KCZdWWRrvSf2XgwWWK9riVhlt3E+3DINw1I2OB8MJmQahx99EDZilx8s9QXUrzT3W
	mW7IzjaVBoQjSlDGq7DxE9V+V2k57ZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tb0gRwKT;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so50682061cf.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765833477; x=1766438277; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQYOTwdjJwYgvuX1nPstCicu4NCv26qFYc5XYhTLu6s=;
        b=Tb0gRwKTDeDmXlTHOtIVLpfpR+inb5K0kGcGIrujTPPhPMfwFe/4TTe9oQv5Vm9sb4
         iFZjU2rg2sX1qSZ8ThbUbXB4viM+ua2+/yanqdzZDQewCXeYUWVaQCfZLTmM1pjsfFFT
         exr9DN54VUnHgMEF8vLF916UsMXx50wV52zDbaT8ANOSGo1lilhIePO+4Rkoi1XsDXel
         TLN+XxM3uwJUZeHwDLWroDktHshrj3J/Mju3zmdaacv7v7L01cHpsMpsTumCffKNhBRy
         pGVPxDGvIS2SjbSPL0klLnE0dFA4zdGQhaszzeUn6DH4VtMFa0KU+ktcMs1P/up80pR0
         jqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765833477; x=1766438277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQYOTwdjJwYgvuX1nPstCicu4NCv26qFYc5XYhTLu6s=;
        b=VXEcPogCVpBq9lQSVwEwIW44EtoT5YkosOoLHnsltE70aWICTNG35ni2JqA2A0pCKv
         X3sjAiGYZQmcaXcPuJEAd4vJrFNKI9IkUHxpwum4PQ2ES9eyLbjApy36NkH/08L/BUPi
         jIfAfQ/rfUI0iSmC+GkkVGtiCexbG/XbmHO4wnIyk59x+29CjJhXliNET4FWbRWWS1zo
         qVlXB4MPX5dCJMAhXln9mQOx6Upk1uYQACx7sVHkhgVGTtmgPuNs27ivBSPcfewU3jhL
         08dHdOIMufnPGRoHL3tSCpDg1PY5yOvTZ88j72D6WiWim99szOiHVpNsHjR1Osf6ohlt
         zrog==
X-Forwarded-Encrypted: i=1; AJvYcCWEDjxEd2EL2XlGYOBGeux3oIlNz152Ckj8U7Z2WmDtW9UvaOfypytwwy1nNUFJ54iqxMdoDjpxKw==@kvack.org
X-Gm-Message-State: AOJu0YxTD57P7n0yxh6cSDl1198Z36Zj1HZKDL1g8OKQpAFOGeoM//m8
	syJ8Ivn9S7vL6rkm3ZwG2vrK2MWrJvMEflTn/Ne7ZD0AS4KN2RdFjFOxcKJT/rvKFNA=
X-Gm-Gg: AY/fxX62fjnOJjEU2VaHLcJG39lc5whdOtbbG/I+93ab3fIUvLfz6HOCaZ0DP1PNGFM
	Az1Ht4PQQHJnmmBnGTneV+TvR8C8b43E7GSs9uHp7YTHe6p4LB52oO8pKExaPQEYusnQoHgWDfO
	/sUAdcGQ+IioZ6zHx2o5WHjAJBETy3UNVZi3h0VxA6XsYJUJkR56XooXZ7A7tQWPvFhYVvpoan5
	/Axy3NvMqxj9znMSd/bfbKQ1C4teymzOZFHqQ3y9+6qSjOKpD22RrJhApeiRaaE77XZh8KlYhZ/
	8Xi3B062rODtD6gvUyaxHnl0lwh9iiGgdZJLBW2E7ZGjdzF35skouDcRjHCK6fyoW/tfGPWy3zR
	RAN5KAKm6pPkB4hN2I74ggVf3L8+tXW732A8KdBK+uwLR8g47j9lc3kMiu9gM2rAS0RWM/VzmnZ
	ScmUQiJZBndA==
X-Google-Smtp-Source: AGHT+IExtT3C2ce1bnbMtFFEc4vbTu4xnrtsiKWUFgckjaMMD6DyYbjwCUrjL+1tWyqf3FThMCPBWg==
X-Received: by 2002:a05:622a:4109:b0:4ee:2420:4f7a with SMTP id d75a77b69052e-4f1d047a1aamr167228381cf.2.1765833477067;
        Mon, 15 Dec 2025 13:17:57 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f345c2e0ecsm2877711cf.19.2025.12.15.13.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 13:17:55 -0800 (PST)
Date: Mon, 15 Dec 2025 16:17:54 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 4/5] mm/mglru: combine shrink_many into
 shrink_node_memcgs
Message-ID: <20251215211754.GG905277@cmpxchg.org>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-5-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-5-chenridong@huaweicloud.com>
X-Stat-Signature: jz8omh9hme8uj96tfyw3w7udzzgyrjue
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7EB6B100012
X-Rspam-User: 
X-HE-Tag: 1765833478-92146
X-HE-Meta: U2FsdGVkX18PzPwwdoS04e5gjWRThuGx7PO0vGSqm2qFhCkOskMwckx1fUwfZ50djw8l+FzKhtzOY0QC7v8SFtUVOeGyxNbWLKotUbFt+4/VsRSwzCNgA4DeXNjaiYunt/HDPCB89mr/Nho2GKgu5wCHwTmlvgsY1w50qkUtlHiOL2gli87+VZlzVGMgggTAreiRJCcgLYnL7xSoJ+n8FjzAlVp3ZdwR+piLtWkwRQiU2J7dAnX/OQblN7tC85ZXoqtakKYFSeqp2DaA/dX0ZdgpCgbUUe0Kxexda4I2E2DX9CPEeFe4PYZKexM5hhF/vJQHJePMlRkNqQuBHFwsUfcP3l/ZA2V4KL1vpqslchQss8wqb5P0XjzvvO37X9CbXzXSwUXVTk1ju7y+1fpmw3W1WUGwi/WrOS9vzvTAIktzkrnk1eUbJicaEoERc1TRksvN20mXODkdLpzEPZbD4ZjeNMIzUh6KuWEYVCnn8a2dNQ4vkSEQckiasOYj5cZDrtvGw9zkGfRw6fZ3xJkWP7df92z7bY+Uk6UaZzr6fi8J+5jb/qydm8XHFh2IlqRC8yCsv6eMvFe8BGjKi1mbQ+R79r/cUO4YH70EVZnwYhYmvZSsXrLH/Za1uC6kfdWHBA/4EG+0fqr12M0llW4kbl/96/bmlDW3hKsaHwxogZXH5AVw59khFMhCRKR7FUCEkZlMBu3k+SzP0c/8kvQaCzj8NJpz12HcmAZ7CqxQ4Lkrikv5fiefrawqT3xMeo5qeQDC8wYNTUH2lTO4wJVxktRvjZCaXT5qAijcEf/ZSDl9EgdSFLZd0iVfBC3VB0PMNqc4MbAByYMt3c7x4emZcjel3HC93gZBBR4GZfHa7ZN9xfNATPKtqKFiZTCoG5P1bX7J2dVkoW0RWyqW5cfzB8cXEzQtabW0BTFoZM0aaU4qYq+0tgZVJzvp2VpAD5/TyOsD5YlitnX9Fnwco5s
 Kpw0Pxq1
 gCVNG4kWnV5dFQJ1O64uH8rSDkfrbhVilDHJB535zFq20wsQNoyP7kg7xtBipb0qNvEnOfDxqHEK/F5xChLo+RzcmzVzdcPO+gOCl04R1XYfb/fa4iQglsBBl6DW49JOTieBgp1z+ALFhs6ukKDMpFyodJBGzAS6Ui2Zkl26G62os0YKJ+WosPsoDdLuKoEz2cZyVz5Sm+B3hnX7Zj5AinVtjZIgnZ4qTYIjTJwjpSfs7isR20K2WiZ1DNuOTU9tcApkb5NfxGuRVqaBK0oK+6Kkm5Pz88CccyAswezvYisNRJpf+MGHm7c0I0QR/L1EYHsrtT4irwxmNxZzOE01PwekgPbb7hRdY+6HfQNX9sPPqAIUEipDxa5zp8O0AhMtzVj9RsiiEoLWi39sfIrj8hE1gaaZXbixq+o+g/gg5k+/oHJexuV8FGfbdTmiCyF9KtjFgvQ54UZmlZoo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:25:56AM +0000, Chen Ridong wrote:
> @@ -5822,6 +5779,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  
>  		shrink_one(lruvec, sc);
>  
> +		if (should_abort_scan(lruvec, sc)) {

Can you please rename this and add the jump label check?

		if (lru_gen_enabled() && lru_gen_should_abort_scan())

The majority of the checks in there already happen inside
shrink_node_memcgs() itself. Factoring those out is probably better in
another patch, but no need to burden classic LRU in the meantime.

