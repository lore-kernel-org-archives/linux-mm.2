Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0840C606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=J55tOz/l
Received: by kanga.kvack.org (Postfix)
	id 175BA6B05B3; Wed, 11 Nov 2026 01:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126F56B05BA; Wed, 11 Nov 2026 01:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014646B05BB; Wed, 11 Nov 2026 01:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2A8B6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:25:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B1734020B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:25:19 +0000 (UTC)
X-FDA: 85421851158.27.FDF189A
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 976E8140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:25:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="J55tOz/l";
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794378317;
	b=C9USuasS/LJMkU5GOi3e8quqHTQfsEPdSmm9kMIjbih0rEmabjxAtXV2dcOYzssNhT/lZ1
	C84v9c+R9dV1RZKKdweW+NMbraho+VGFis+c4qNIxYbJqRI4v8bJQkH4QR8MhmBStSuBlo
	Uw1ucpGx7zLPVGHDPxKDcnl9jZ7GOCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="J55tOz/l";
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794378317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpG4mWaD3IAbNd6Zc+GPW6MdrE6UHLepfWNOwfzGPT0=;
	b=dqp2svpi8h2hwvkEportwl+VJnbEwOY9Da+Q6l0UTabEMpdnm4BMEl8F6NmP+rdOTT3Ovw
	iZs4aHWC9IqzvnCtl81YP6JWXb4bJWkM7CZe3ogIdCZfxu7YXSGyWc5XpLPY5n3zNkpdKf
	QjNMoA1mquuGTde4vXu18MsFnOHW0X4=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdab938dc83so1138047a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794378316; x=1794983116; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UpG4mWaD3IAbNd6Zc+GPW6MdrE6UHLepfWNOwfzGPT0=;
        b=J55tOz/lmsH9K4cs+fq3AirQS1s53vJgfiAZSHQY1sBNabF6v8LpzLaH3t93U0HHBl
         eq5pTlggJ+iCEmrCFtUyIE51Vxpm+KVu6PG9u6sZeZOnw6jOgbfoHDb4gwapvxW3qOuu
         B7wcmAzsceFFcitsG/ul6B7SQztJqobg9p8jI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794378316; x=1794983116;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UpG4mWaD3IAbNd6Zc+GPW6MdrE6UHLepfWNOwfzGPT0=;
        b=fOHETMihdjXgN+VNBRLrBCfMCO2BqI2SnZMAknpqe87BtNHHf1hyql2vVhpzduSbOv
         AXw0Jazcqu12feypg6C1p+HXE3J4gncHiWnBJB4nKQrDmXuQiY4v3vgoO/pMm4Y49+sw
         XEn7M28uW0rBT2WZ7csMRRtTkKf/k6HQaGglGQQ6/xf09jUO8QhCe7cUFUImLX6MRYeh
         uqgwjwR2SqfQhollgjjKs/dXyixJvSsBig+fEpZ3jYkZHeGUIpzpgjxsld6xWzCN4dug
         tEYO5l2C63Gcc8519MZWr8tUwl0pMcaB5FM1oaVfoNeQNH3MxD+f6fHiA+Nn83j8BeO8
         DcZA==
X-Forwarded-Encrypted: i=1; AL+hErHU4sOrnnRfya1DwY7mQmr4kuZ87x9vR34Cc7vxROQkUgpvo1m2Fu4mqXi0Pq6kn98ezm3Lencxag==@kvack.org
X-Gm-Message-State: APuU4Z801adl67oAPw4YWCcvcPKg5HyJFExr6j1ve0N4d+AN9eLbWeHT
	QRpMMaVYPp36kziY/7LQOeZCu5ZhYeTjLJj391TM11wfXLGaUMqAQcSqQYICZOPn4w==
X-Gm-Gg: AYBFou0PhWDWBxNqHzp1IqkVw8RhoOtgFPPx9bPSlRxZ2NBJWO/Wp2zr8J9KNLodcno
	+u74FLr2r17nQYo1j0sIJM4yuciuhzvY4qsTnSmtYXet/pHQjiwS6HLS2oODuxBZLSPQ8sQOgDv
	mTd94ufogBMpBUWi8zfb6HbS8JfHEjFAgECWOalCPU9o4IqRvYIOqz0+ZzfZvR16YhjM0ctmkv9
	OnRFIrhRUHvv/p1gyQdF/0gbP2g2hl6aYLx7apFahcySjmmA1xZv/fNL6QLJ2YtrswxPyaGvl/j
	b0znmKj30rjrR2cRr5A15MEX2i/mMm7eKlCkorRfrwZdHG3kVmOS+8J9z5IuhLn1gc9OIl9USoR
	xrXc7k/klTtUroWMPet+Hyl4M+I0m86uzytpG4UvTfH8E4AZmR7IrJgfCsyt8IoDl+7X0fKYwgT
	jHLpUWXurDnfEprKw5NoElFAdnNXKt0EvefMmY4D8rW0LoJjrIZDCxIPBREOD96i2Ou9wzk6+2j
	GJlb+eCcnrrzrjYV9pstzjQDSqXckwWFxY/5VEHbvw4D/xxx2by/DRHRRQ6xXuvq72lq7vhRiLw
	OWGmChGSbun6X9EVrBr3h606UnkDq7+TlX4TtHEvvqiTcY3dIxQTsGSI4IpUWXoWuNtLaG8=
X-Received: by 2002:a17:90a:dfcf:b0:3ac:9a03:20bc with SMTP id 98e67ed59e1d1-3b182f858f5mr1600801a91.47.1794378316367;
        Tue, 10 Nov 2026 22:25:16 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d9ed10sm17185825ad.49.2026.11.10.22.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:25:14 -0800 (PST)
Date: Wed, 11 Nov 2026 15:25:09 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] docs: zsmalloc: describe statistics with
 CONFIG_DEBUG_FS
Message-ID: <avQJ5NG99xSRhAwV@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
X-Stat-Signature: dbrhf15qit6fkyo6mwhtgrig6a1o5kwo
X-Rspamd-Queue-Id: 976E8140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794378317-882564
X-HE-Meta: U2FsdGVkX1/jF9qTw8khNQSaid1fMQJ/Je8RZoDJ6/Quoa+1Amvs5/DWmdZvlWPq3xzD+swYskgH90/xJGS2OdTT9AXGTowZBF4KmBxgaFkSEJDebKU/oV9WTs0g2BkeMtHjpSewFQCbG3xwe6OGg8WhBIBJX4/oS4AoOQ44/HHY+gr/GIODLJgOYVcELUVqJNhd4XuUXZWd7E2R60ZlaOtNiXPovgt4BP9i6yNIl7D/YLcTzYCz1eIQyVLNNhGnGt+D1q92czR4bwtDY/ZC6EbBZhTKksLjWl051LDEgT8Pueb/NULt4YN6PZiJPI9hVPVcgJDN0ywXO1GWBcDjpNutr6IBv8Nzng5ad6hB+DhLzxg724kVUTUezyh8gEXfJuXFYvEIWHDX3L5IRRvXP2dQWA4oUb5NRYKmBDA7XZs8uGbjrQjWa3062uKhPU+OGAWLxBjZYH/QIrqwJMi56IwQeRwI6yN/Z85FZRzrq8+YOfpcufs2HVGDMeU2Ex74xrjA3XpUjsItLx53v+CNaBZzs7tUcZIb+QtWWRaucD5C893b8hMe7rhEHmsNNL6H3o/gK/AXv5SvWcesvSjx0kodoqH7qkXYTQXAsUZsuAys6JjvN0Z49wN/CtP6egtUvm7qKLUgGOo2x5dlGuAXwjY4QuQSQIjEvQApeVKzsRGTYTfMVjNcMEsmJCPeV3NiE6cqwtAT7o1Q1C50IxbeZjLmWXhkl62feMdIXIN41642j7kjU0oas8ZUH5DICPnNcWyhkHDcs+uwNtj/Skk7a7sQlztgvxm6fj6y86q2UzNqH0YPfcpHftmnVjjcYsX80GaxAMxbOxAmG0k9EBduu+6mknqZ/pFoRCOOjEARVB+AN4dBAnGgO/mtyGNRFJipRQVsERM2lj+OkX8e5ZsMnqpqm50Y6TwwTlxW3Dj/Y2RcqjyGa5aToJfu1yNtZ+yCj/Hn0tUdxD8w4e8JL7/
 iV/mvYzY
 WRMJTmGyIcztWgrnpC0YvP1ZLg+bJtWS3l+zLAS5HidPG/GzCPS7scj4DnpM3MPZD8dolJ/GQ2mzjVq2QgLjMqsaLbbkD4R68100HfHL6Dpn36p3sZsxfyVG6qjBLKN6PTdJiTDEWROPuK9xB9ilS4XH65QoSiMJGrTFgZJQcDvRjgwnvDYYLSfNAPAMK7OE9P5+rUV1MpdpmH1gmDHpKIfIZo4uny23hSIwJYqdH0nS/etnf7LTBxEINmw+yjz6/1uwjR1CkTz6vuZg+OPi/BHRvuiMZcHLOIUIeIRmz6tdIEblVvOTjy5WDwkj3KZHMiJHHKzIs1HJ/BxbWqGZLAoJ2LHS/4PD3UNLRPxTxp4oCmalKYlAPuFAYUkkF4z/6hUXlyMUShLpTUrLvJfDRTc/UC5jARQd8UjAAtlucssowGsfhy9ktjsWBE96iqxu8QT+I3YAUJ5mmd4VqfTv++0ArnRP7PS877fhMWgXmVRE+vzxNHsS4/yVUPKqNxyRSMZMj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/09 20:59), Xueyuan Chen wrote:
> -通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
> +通过CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
>  看到zsmalloc内部信息。下面是一个统计输出的例子。::

Just out of curiosity, what does <user name> mean?  The stats are at
/sys/kernel/debug/zsmalloc/zramN/classes, where N is zram device number.

