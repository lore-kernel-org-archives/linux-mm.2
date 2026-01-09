Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8510D26D6F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 16:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289AC6B0088; Fri,  9 Jan 2026 11:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237396B0089; Fri,  9 Jan 2026 11:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143DD6B008A; Fri,  9 Jan 2026 11:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00AA06B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:08:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C8045840B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:08:31 +0000 (UTC)
X-FDA: 84312908022.02.BFD5F34
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 792D68001C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:08:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dUjtTcqV;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767974909; a=rsa-sha256;
	cv=none;
	b=2B3/X/8FEsXiQ8aNFtMMAtjWHZL/P0bY9lTlrsKDvJihcvmBAI5TtKzqEcYWopGW6I5m8j
	nzfR5UKYvJ93oMNSo9MmIb12MO1sWGYkj0W/AwfSLDIZ9P8y4Ld0C5UPVy+E7NiOFO2Yyj
	tUJDRtM4VrSsW2GYe1okZGDZqifGGCE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dUjtTcqV;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767974909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4vHEUNRYMXphH1rfrlOiSS0TJwDxNN0hMRXL63E6jo=;
	b=WbVamKryKFaIIpi22gjuGZhyWR6z9OOTaXx66X4LzE96NrgeLyAS2d4Xrjt8NKmeiVs3Bb
	X5eIhg/ECx/q+Y0Adm1Qfr7pd922rFQ2SKJggtlnmRE6IHCLnWXjx+viYdKJ6AaobBpERi
	JQ5+sj+dBcW1cZyz+3Eg8RzFF1tQBbQ=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso46424871cf.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767974908; x=1768579708; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V4vHEUNRYMXphH1rfrlOiSS0TJwDxNN0hMRXL63E6jo=;
        b=dUjtTcqVSKBici+Jqf411XGDXYhg2HUjM5xipyMYFC8kESUls+hFRH5lN+5G9h3uHe
         Tes+zZ7WcPsaBLtKVfdUWa2+LRgGLr8Riki3DqOF9iYOS/GZR6kDt/kz9MlhlenkFTIt
         kS4tigX+khdul0OS9QxSwYHIVkD9nHskO5f19rT+YQDFAsLEqZtx86UGE2iOTcNtk4eF
         Nuj9JKwOcEiJ7tHuQXuLevc2/YHV32xP8+Dl9SNZL6qPDpmQWovxdR7QLkqwPjEz4Htf
         2XkZsr9JgXSZ8wIm9qQ6QHYvPaavJn+BXEnSQS8VmgdyxdBnSgBKLs/CDbDHj0AJH31U
         rBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767974908; x=1768579708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4vHEUNRYMXphH1rfrlOiSS0TJwDxNN0hMRXL63E6jo=;
        b=H+XQN7DZBEx2LAocB1DGXhcZ4/r5JUg/6FTTjJIorWIWcHOevrsoBglp7Vd3rT2Il+
         u/eUGBUPqgvMfJGyAuS6VOssli0Ik4ddz9ihkfbwL45ekEWlNNMUp3pFnHz1PLPKCLbM
         nIz8XHGbK+dYa//L8Vfc40Aq8hmYoWdUbUdnx6AVwETEbDfMkc+rja8zEILA0RSP//Iy
         UHDqYBTf7qg19u95/96iTD5vKsyhWC39VN2ebBOcwbBD2szgKSmMTQOv9Cmow0U32OFX
         +uIILOlvrjcOvxWpeCGvpGCjuZnqAgBrU/zEEReZwUKBDUECNsn6ZtsQ0hGY3yHFxVbM
         dvwg==
X-Forwarded-Encrypted: i=1; AJvYcCVQrNbkfOzkG4h4N8S0r8ebPUVLczL7/HayaoUi9FbFvYhxK0kWgLxdWl7fFF5UAgRH+fMbXVVhzg==@kvack.org
X-Gm-Message-State: AOJu0YwJfVXJLQyu7cwxWxcHTSZHIHNjGyyFK5WJ0HToqxOPoWxKB9o0
	6weclQ0aV75hF19JQH6B+I+45pFlM2TOQlCa+09uPuyoRrkBTsX0WBOXc8AHKHwb6o8=
X-Gm-Gg: AY/fxX4wyl1HfU5wmEQJD2BtCLOhlzgUlMXeeTzYTFUbvjF8UCO32VOOTZSCHmSDweB
	xqP6ptEIbsdugNf1hijycYTe2T3cUyqBruHlMTYQpk8Fp3Hq+xdrHyScai3eLkfDv3MNSqYPFE4
	pFiayxuy3Et4Oa7UB00Ab8TY9lmQIxRUKCv6CJMMBaiDpGOktBsZ/91vR51DtnzLSnkzt1N/Kd6
	n3H54oPL6bLGi6vR1ln8JNjz3O7PE8GjymS0m0WLAl7S1codLPXG9eamXUHmliuz3TkZPtZhVKR
	K9iHgyLheT+zaKPPUD0hlRuxqOPrrn5k/tM9LhlMN4O5uQrN7mfylNJ0qOv9PkdcaYxcMeFGGBd
	6ly+v5HXG+HCIfq++GWe/3/nQO5xiln4G0Q4WVKia/mbM7+RKpGT9oM3rKt9Bx4nIMyaaLrU3Ip
	0HIj/aNABU4EMwDhCjwo8uVlLSHmv9P/WKMgRfEhYKvS7B8nbcolCSq6rDHp6U+eZLybE+cw==
X-Google-Smtp-Source: AGHT+IEdvXZpwW/0Rj/zKD9Q0FT8JfSOnFbEdErwx/lCsZ0mgwmxjheOk0MqApSu4txhmwbpb7cX6Q==
X-Received: by 2002:ac8:580f:0:b0:4ee:1db1:a60f with SMTP id d75a77b69052e-4ffb47d6537mr154025831cf.16.1767974908465;
        Fri, 09 Jan 2026 08:08:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffb75d7916sm57189031cf.7.2026.01.09.08.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 08:08:27 -0800 (PST)
Date: Fri, 9 Jan 2026 11:07:52 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108101535.50696-4-akinobu.mita@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 792D68001C
X-Stat-Signature: zpgjbtsw8tgbnytxersh9qfk81egzr1m
X-Rspam-User: 
X-HE-Tag: 1767974909-450115
X-HE-Meta: U2FsdGVkX1/tnYiPU72syPyLMsCVu0NwPkOXwHCxOBTNmCusSIut1TrtbeUy+TS0cp6eRTxptT6nTH6UlYNYMp1FEsNRW+dbq7rQGHeoLL/eDygfwgjtRLYFV+V8KxMuGhUHWQvO0gTQpDULYaAJVAN05sQK9NaZHJB7X+7JtNbAdgCoX6NrRMEC9brKIscVHF5w26HkcncIwCIg64+742N+Rh+5rEghzhCtmaU5QvnRjLLIsEuIiSKipKBZz1aXEHIKBqJvKymGJ7qWYsmX/yHGIO43O1S3cqaPqbr9NvjuiaLOQy/30p5Q8JFbCTnamgm5Ni3adOnglmvaJl2APowK556G0k1VqJ1TgeArILacrfaGUFfplExUtzWcqamwdKiHLRMlIESxswBshFdKySahuc42q8BRaWECv+e+hz4dOvuOtCfnHSm6P1BuOlPYu/wWwEH2rCJpLaE/c//vN7yYgtx0fj4PpFYc1pNQjEYtmLWpCacHVprbZCyCrjXWZUTovG5PIdjvt9IjusrOrFeIInh4/wEUjWMscKwzl1npbNQDcNNjnVYvvp3bc9+/Rgvmxt3AkvlSKPaMMBT2mJzGCBV7PBLxMSfur8q3wsfSh4hP+1G72vpy6mYIdn1OQhYhUCGP2alHIFf/LA9su8iYvmskTD+rHXLM4JHhGUJ/XbdWrlETxxBk9upvK0R01XNrA1cO/9YDn9a4WKIGXEQlk5QXm+kOuuOcFIeJJiJC1Q/aGBWxHPlpH/yy+t0jRkN6GEkbaeKkE3GVCYZ2O4URePPfp/I4fdAAAFiHdUQ2U9fIwk2lfUsXtLHj4tfSVLUee5BIjh5+ukf0QoMg9EQP3mmSdJ5kXIiIYV01Hrr/RdcJ3397sHv7TnwBD3upsc9Ep3Go3jc0TZlKfZBh+PdXcQPIYJtiKF5wrNYS3yAVanstuqJIAWpHaHD2A8zgL9VKBaanyAZ14pvp9JD
 2ZQKZIyc
 oPO35O5jG7acdMr0Z3i0DXZmN0py9gDtggXGpkp0sItknNenwKFcKNgZr0W838uQ2OFroU+pU5XrwtVQwifxGYfTStyRNuLyb9aN4/8M8mRPFW7wWVe2SimcdiyM3vUVQA5TV4dbBWpSgqjqVP65Cwc3Ra2ttKnuujJhB/jOGNyTLJxq62Vc2SqyI1XsC2rf74JCW6+uN3/mSU/warzPuLbunx0zNFn2Ygu1sJgsYKlAx0zdfvEzlKmNVlq1ZeVBX+e52y5uVUEy5fWCHAO7FLMM4tuIquVVeAQ/QZSZ/d1xmjuFLpkLEg62buKTI2vR61Tq/pvgIGON3ru/yfLifgpLsdKtnc/ub66o+T4tlZH3DmedFIHj2B0PbINvmtzcMXWAlZhNAFj8e3GBvJW/F+wvIFVJdsk7KqoKw2mz16PXXGck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +	for_each_node_mask(nid, allowed_mask) {
> +		int z;
> +		struct zone *zone;
> +		struct pglist_data *pgdat = NODE_DATA(nid);
> +
> +		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
> +			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
> +						ZONE_MOVABLE, 0))

Why does this only check zone movable?  

Also, would this also limit pressure-signal to invoke reclaim when
there is still swap space available?  Should demotion not be a pressure
source for triggering harder reclaim?

~Gregory

