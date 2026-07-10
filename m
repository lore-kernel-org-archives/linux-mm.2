Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C3BC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4B06B0088; Thu,  9 Jul 2026 23:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65E06B008A; Thu,  9 Jul 2026 23:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8976B008C; Thu,  9 Jul 2026 23:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85C2B6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:03:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 904ACC1592
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:03:53 +0000 (UTC)
X-FDA: 84971372346.28.E0F05B9
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2A971A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:03:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vq+b6GYT;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783652631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ynSAhKjwAAjcKTYW0e4L0bg5A+RQVDw3lejJ8fmbfs=;
	b=C6mlxvBUQfcTVoWS/4aW3gCmuZLKgDmmOKP4CJGkDQaMSxQkMGU93CMBnavx17DGpcUcwq
	wsCJjUQaeEEe4P+jDWzyoKORHz1T9cCl/R8HMFSvVIrfyxOrltASGBFWgy/2b3dcstg82q
	n8UtHH7mh9O3L01WADtriKwOnDsHlpc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vq+b6GYT;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783652631;
	b=cibs2kl1adqtAjQxkEIbXyWLSSm5p0STBs95FZW3av/DqJpqBC75PLjHDzeyh84ZdnhbhU
	jLu6OY6q+bbHUtmtmDQknylS8JJrutMEtfkMsUFaM/QnyqWZxoR0DZhglCF7hGWcrGR6pn
	heoAF4onNjDmUVtgspOxJtqQiF7e+tY=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-380a02c71e2so218733a91.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 20:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783652630; x=1784257430; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ynSAhKjwAAjcKTYW0e4L0bg5A+RQVDw3lejJ8fmbfs=;
        b=Vq+b6GYTDAY/xW6kVXsYFaHbRg4lkWiweYQM/bIf3YS1uJYJrsaQlwjB5/0zmqSzrj
         GqLrUbseb8wmR82Hilj87+ddYiLuehnTU8mZCPCPC1rn0nGKNFSd6Mbv+zhj2zQJSfRX
         4nJsYELoPwo+oQ0kyRA7rh+REpB7PiGaT6l7LLb4oI/BqTM5s9nsGGINuIxMyaXr5Mlw
         erM1rvefDWWySLfylyqor16xOiWOI2HpBQHp4PeVAjuElRzzHE6t2M9YccD11f0Ehpye
         cuIxx6AEyCeBolH86Vhme9snRNF9JWHlSV4A8XtRIUseoQdeNkQaGdUxwIQodBcVogOM
         hC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783652630; x=1784257430;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ynSAhKjwAAjcKTYW0e4L0bg5A+RQVDw3lejJ8fmbfs=;
        b=cwOr5R0KU0LMs4NoXAim2feWuF1JZymX8HIGhYnwBYsh4pxygT89U2+yW1xwsfSelS
         kCSJ4ZE23oe/cU9vaa8jVwSK95HgoS4qgQ4fK/CIVW2is0TC5nvegPOKS7QquRbxusEY
         KTe2oqQEa7kTutWVHJQjeCAK8UkuUCBJdpDO2aUSe1HOh4J+mhFPM2YhT8F+HtySeGBx
         Ki7jtbezsNz9KABzt+qWLf2iQc5NF+8iFK8quEkLPIjx+oFtS/AGFavGY93wvIPk1GgO
         i8g76VOIAIFhMBQks2kN1gfawjBKLtifXLUSKb2SH7JOas5IpDSTrv7nZM2FUT3jbQz8
         l6XA==
X-Forwarded-Encrypted: i=1; AHgh+RpSmXq1XaBjbpR8Iw8H/l6fIVQKMXeVqg5VpvDYsPdDJYUzFB7c4+yXbxQ4eKZRJH08gN8T8mCW+A==@kvack.org
X-Gm-Message-State: AOJu0YyQiOsE4x1YhWmXzzZuHsR9GegCkigEP33lW6iyqCuqvtIH59Yj
	nMBAMV0VWTUhYFxsnB+sABI2zIJGHE8UfOUrekpJQwWbFggYdJqmmnV1
X-Gm-Gg: AfdE7clUYckeJz7OAz83ldovRhXDCAMaVd5DapPTDI4agnYD/px+hgY6uQgTSloacx3
	dnc/FQrg3Lbk4EqH2yrX3J5Jo5yVwcY2gAaBLkLE/0gf7uRvCzgsydMy6ElvgV2mVR9ZogAecMQ
	QEDt8XYPtmnKwRN2FBYE5uWqXhXhljRl7C1CUMkh9T7mt9AyycFxTe8aHPXgXyasyiXeXpTeXJW
	TWzracZAtjDOWq8k0OGIL+Z6a33qelt7lygLsTYHPna8vGRj6gQn//g8oWSAdwwoyPZvFfPm/z2
	Cj/XYo4EwgbqyDbqeoXJgWyTQKnOohrSq2cGmfpcaA0nL8ShC6/ACuQLRUywGOXFVfpZfyXs/Y1
	PlTnPhjy840nFWwcLpc1l3BmL4+7J9oV2ii1bnUpYggrmvrVAwDhIO/U7NXbbmKbL5f1m9nfIMq
	IeE8QmTU91AW66qA8MCZ6JP1Gs6qZ5dF5mSagEKJT/KMsNFDS3YvdQK1s=
X-Received: by 2002:a05:6a00:1804:b0:845:3ffb:ac1d with SMTP id d2e1a72fcca58-84842ee0509mr7628366b3a.2.1783652630328;
        Thu, 09 Jul 2026 20:03:50 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm9594805b3a.53.2026.07.09.20.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 20:03:49 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: usama.arif@linux.dev
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	lance.yang@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org
Subject: Re: [RFC PATCH v3 1/3] mm: make persistent huge zero folio read-only
Date: Fri, 10 Jul 2026 11:03:41 +0800
Message-ID: <20260710030341.8527-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707131714.3266156-1-usama.arif@linux.dev>
References: <20260707131714.3266156-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2A971A0004
X-Stat-Signature: fp5uycix1tf4p5ag11fmqzpy5yeanf5x
X-HE-Tag: 1783652631-828089
X-HE-Meta: U2FsdGVkX19rhqJQasigwmAAtuem+Cbv8iewmeDsrO8DO4Afx/zgEdLjluIO4LFyMOiPesvrtd9Sc65j/z+ht8cwnovUMZmLbjeaeWhNiRpk/NJl2geOjhk14ITANNnJhFTbvkXmzKITMqE4+Io64pzbocwibk7IvTdGTqFsgIx+k6gVWXNplKqKKImIiJTC7XGDgBOrSIhi6lrRnN8gqWQA+iyFqOBbHcwLT+ZTTF19Q0WRdYLHQcDwGBWUseYj4Y6HW75cpAXowxL39cubKDDhSuDPpVZHTyE4IPxQ4H5JhBKo7Np64i4NuLwqr80svkRoyBQSae1jWEbouxm+NWQHW2EtOHFwXrcGqdNBFwdIuOO+DvMXyW2ZHizBCAoUoyP+SyKZdyekRL2Q84YE+1qGriE5cvTtebKJYK1c72QBTcBW5/2FvU3TXoZxOoGXYCueJY5kznv3UsgztjWWmER57rP7MgiEuuHRziKo5luQe6Wf27i/d/aFEuBa53NhDeyPLf98nEKN5Ki5gsnLOfgoXmgRKyjwz01sQEvIjUUpi5N0D/s6gtSBdCY+Ik9Mmw7xFbq49aei72TuTciYIi9Q3dxVJ1TV5gAIxd/n4jCAAfxFg9Py/GRVe34+T9YZkDeypwf9W1zw2MLAifw9NBVirF6V70DQ+UNAFyzqjxNN0UepXUtXn+u3b+ub/EGkEn10gJ2oWGtaP0D7wZWF2Dc5ebhYc+b2quW9cBC1K6IkGtKhAgqU6oNK+rb036qzwBvrJzsnpRIKHEETorZ+V1NcN30ODgOxYxL5kP07a6FJgocF1vzonlyi++rz30MVaQ6bEYw8iPFCet+QsnD4drdhTpxfEP23soRcD9V4fAEBUDfOLku9EnzRnO/k+qmDk6o1uu5yPEtawNNrYRRInqkVaJ2rioEUzQXpvnLD2CSqLl+JeYgbA+UYKUA2y3V819riEYAa2JorcHNJn6o
 cXofT5cz
 2pUFtjz3PtjVzJEs06Qxj0OPcqbWujfXmISQ71Ggi9GcDve2o5+Rp0KYdshBsAhrV16DowWlM16d9IaoZdZQSBfJI7sdsIaIrsK2ogR5Ms1n4pwF/C7bwLMRplXDQuKM/d/1ulNro34vYF87jZn5R+1LSMelNiLSTSaYZd2xX2qxk+3kKOK0gmu7yk2LUQFSncbwTBiIi/yZziTAFQMFJ7mjb6NauQqAUKgl8Z6Mq01IW5ak+wavcLyX5wAEY2BElgAVd4RYBVhfNcPfLtLBe3JxxHQsU6+KFj3YSlr3huEbsYAt7t6fWq91B07/oPZnX3zRMahGz6/nFLZJNMnKvO1Yqcf3Op0tTOqi7ufS3VGsQdR0yXkeLzzc5jujnfu+EAEyzxKr71vbl1k/c5NvyEAdSW79zkpxrM3lenNhM08qXTUXyhzVAFMuMXf/RQ9JOXgVOQyf8QglbGvF19m/jgsPBud5SRJSt91izZnIU8KqtCiLBvSZVXTc8b0i8J/KzixGuO7hFHIOOO5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jul 07, 2026 at 06:17:12AM -0700, Usama Arif wrote:

Hi Usama,

Sorry for the late reply.

[...]

>Can this really skip the TLB flush here?  This runs from a
>subsys_initcall, after smp_init() and after the folio was allocated and
>zeroed through the writable direct map.  The noflush helper updates the
>direct-map PTEs but does not invalidate stale writable kernel TLB entries.
>
>I think we need a TLB flush here?

I checked the code, and you are right. This runs after smp_init(), and
the folio has already been allocated and zeroed through the writable
direct map before changing the direct-map PTEs. So skipping the TLB
flush is not safe.

I will fix this in the next version.

Thanks for catching this.

Thanks,
Xueyuan

