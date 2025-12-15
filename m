Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA95D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD1B6B0007; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30146B000C; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8340D6B0007; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67E126B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32B38134016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:13 +0000 (UTC)
X-FDA: 84221509386.01.5EC8721
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFB8280011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WVsnI196;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798751; a=rsa-sha256;
	cv=none;
	b=3N4OzoOGZJo0s5MhObzAcDInHNmHIl+RtIRLGJNTpHBOfrw8ca5AiN3oGYGG/07vzRSwei
	KZ4ba7KkhNAadRLu8G6BlRCOlC/IzJe0HXVwFgLKo/iTolXv8419u2LWRt7ZV8jmp2Tv7t
	yPU61sktu7uvxCYwRLnMCuKA6YjicW0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WVsnI196;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOExJIUd6SMMpu9ecZcijfoRnX+3TKAUcxRzAMDO5OU=;
	b=8oJ7LpCKciD3pe2SO5UnVRbsC5IQ97ur75tsLwFmSL8qseartZ1tZ8lV1d2B176f6xIP+P
	WqNYTg399VjuBQWCYTeP8jFPxDUC+E1MCt5j/fuTJYltzsct8iSkrvt4thAScXIUkRkVIP
	84VVjbLqaOP4le1vDkQ1GzmahNBB3yE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso522482a91.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798750; x=1766403550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOExJIUd6SMMpu9ecZcijfoRnX+3TKAUcxRzAMDO5OU=;
        b=WVsnI1965KFHkPqb8at3sGNN4TuXdSStwWh0kTXXDB+kBAQEPVg4yXQU0lWSqQyUlS
         zaCGNmykiLHAPfEoRyjtt7TsPsP+2/RvzJp19VX9Vd7VjqUYz2lGIlzJ57XHKzniRS8D
         WnM8DVuUnr4b4PqHwCR2V4hjCgNBnbXG7BPGXqCfQj4oBAbGGrM3786U6QIXQb2rwA2r
         wPBGcTlGrECB0g4Pmq5jvgMGF6IAf40JBVNYS001DhUhhqrLg51H2KexpaM125R97kmy
         /ijzC550/KD4/NMaksidPeV4F+RvZplR3gWD5N2a5eYKXzjzkfTqIJB+BKRZwvkq0KfZ
         xf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798750; x=1766403550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOExJIUd6SMMpu9ecZcijfoRnX+3TKAUcxRzAMDO5OU=;
        b=ngWBymHXH0ryzQs171D44MpInSpsNdCZyjknlEUjZrpuzwX/Sq4WRGg2jn1AXpQ3+s
         ko7YZhQLt+h5t+kgCFx2Y/E2kWMvys+Pu5QPcoOkMPX7Ejeq0myMUC6P1g1ai9LFhU+r
         /SMPBQ9aBQ0YFW95YjQClV9v3OOyjVh2//rYoeGRxhApgIorbAdi50v+6fRcTTW7aNjp
         Mvtf3IveKQS7S3sG6ws2hWhAdHGjYKzAI1RdGkLMNQpIgxBMwkwfb9cXFy9RC8sV9iZh
         30a1JhDJ89P5SO/lGGqS+N77LN814upKggDCHLzpuPbgKRK86tQqdbnLJtFjzkcpgL/I
         Sr8g==
X-Forwarded-Encrypted: i=1; AJvYcCUC9XrOytg1Uig/U4yzG2BZcojA8sFABfQcvvkZDI0wzmXRbV8ar+7dInfFqEAV/EjASd9z7MNUPA==@kvack.org
X-Gm-Message-State: AOJu0YxaPlZMTyhm7vEEDAlb7b+3VFM0UcxAcESUgrl0IzGfNdCUztee
	Ofjg4Xb3OyQXPBty6GsJO4FSj5Bl6rveiGQ/NgBlTW03wONRKuZD0clc
X-Gm-Gg: AY/fxX5g14Py72fxA44P7++M4eTSrFBHNzaP84/G4eGAiqYFY+ITfP4fGMyWTwQcfK5
	fvhrO3mXJ4xcybcacfzXImDne8Yo5KcyCgKIyfHn2Mj4FtCCeW4L6ab+oTl+LkpKLhdmhNEXpar
	Bejbo1gKCNlL4QMyoK4YVJerV5Fqrin0dhgQJVXfCsr+h0fO5Cz7PWOayvnaDRMTFrj/f0erUIi
	Pm7aZZCZYWIYbnlc0L2BitZwmRcA0HR0iOGDunFMX+qyNZaU67KwzYvDHFIKY/M5HO2w+laeCrg
	ms3tL8bLJYolZx+MtnwTw/cLx/532n/2EDI7SiIHhgg/LOiv4AZC2xymojv+EHtfUr4moqRPd56
	/57wvH2p2CtmjPnlDqSGvNac/xTTa60ZoG0JnPibHIj6yXkDDgFnAUlV2kJoLm9G6HNwZIeEFgv
	mpd0+4w8UFv2NgJyf7vrEo6g==
X-Google-Smtp-Source: AGHT+IEi7Much+ynnSaGi+9pLWL2hRrocApHWp5vBqFK1ft2pjcvnQtgIu8VXEyupMREgh2/mG55NA==
X-Received: by 2002:a17:90b:2e03:b0:341:1a50:2ea9 with SMTP id 98e67ed59e1d1-34a926d9c70mr13163422a91.16.1765798749780;
        Mon, 15 Dec 2025 03:39:09 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe294a00sm9273005a91.12.2025.12.15.03.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:08 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id EAE05444B390; Mon, 15 Dec 2025 18:39:05 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: [PATCH 01/14] genalloc: Describe @start_addr parameter in genpool_algo_t
Date: Mon, 15 Dec 2025 18:38:49 +0700
Message-ID: <20251215113903.46555-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=962; i=bagasdotme@gmail.com; h=from:subject; bh=yvRLY8BHqBHKchvPjcPm3zDNVddYxArgXi7Qv6PDXBI=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4MeLjlRVOvo/zL51uM7fT8nbubcy37qLGeos8/kb VKe75YIdJSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiGosZ/mm4fru/UqLr5XIZ H96Qry1BDLd3LedR2Gkharj+Q1jej2pGhm7zlf21hfvmpVcxGBvN2yCmrfs71+wCw2eFqbVucQl NvAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EFB8280011
X-Stat-Signature: hpi8rdz1yjwr4rn6as1ruzcui6sfskou
X-Rspam-User: 
X-HE-Tag: 1765798750-305124
X-HE-Meta: U2FsdGVkX18+Wz72dsKuOU+44EP6yQudFSoYXv2S9LIljs4WE+Cf1QImQcLn1mjK3/Z9WTkae2SZViFsIhmxBWS1zt1eCFMAUH8/Gf1zZv8sAQPtvhqVTvxG8lUl8siPX7/37Ki2zYVojT8Kqfvx+W2YnlNX9JE0aDBMZinYz7GaR4WYWxQxHyRg30MSUPlhdz5nu84PtBZt9+wq55OkA+jQ3bu4yzI+Y+0FLI1EcD9uBvIQ0e6auYrQKJlYlMZNiqGZxDcuSxSQzgpw8psUPQmdxcSuyskEYR0ULsjkwmA8ktS3q2NVGy0twehYKXBUe9QUyAl1HfV2N6wd8Ib4sCEu8ow0l4wh3stOH3PPVNzI0cNZXRZP5CQYHKJ3r784ZAn5DmrsTY9wvWSDAz0k7AVG+VJb4bxrunCvmsbueX6TncFaJ5ADpECfE/rH42CyO/rRNxu0/tkPKyjhPdNNMpS51Olj0cJ6h1RTxwmOCUN6z7PXkgx8cEVcF8rybgehrHCD4orUDeF7QyOkNQ+yeTnZlZKCM9bvu06tjYtc/ubR+5f3knaIHKeypbJP7AgOZJBro8qwYUn4Q+FLJlkyNALyazCs27wsrqie5xeh8ZBBKGYY/bm2XV3wnUw+B+KT9dNf9bIZyMOeiErign18+koDe7zccZ9E4/DRXSgGG1TxhsZUY9t+Ku0PWhtsb+KNR/AFYm4kedw7HKGCCTxqNyhZxKIdiCEPxUUa33boqc4kDJfDmt7JO0B4H5Tg+hLxkYZJXO4QZx3LGXUOpgE15rP+f0l0I3540LOapAuc1Rpy4I0RZ9LBm+ppNQ0dw/mLV17p5DaIGCXm6cXe5l0djw0zhFHxduR3XaZlHpRaePfqx89S+62d5uZ/PIZvvvhKqC68pbk5CW/DO9Odf/L1KvhI/odrayzELE1SMsmnzzGmOF3UhA0D8slE6esNByrbQQJAkUJl7H82zTlitf6
 +abr2zHD
 WsjLSIUYxz0V8a23p9vxkhFtZxQ8lzhzk92JcFvMOimiveU0t6IFIR9AYTeJulImWcV5FQN4SbaSi4M+RAtqzUp8hJ9bqBWQvJMSz7MF+t19zGgUD0Q81VWmZBiX0PIJCYAkm70VfnLMGwiK22WrA7tWvBm74t36d1uZB1f0wGj/EdpScqv9VrR1ZyXxq0FUD8Hugy82jV1TG0a2FFDw525XRIl+dMGdbe9gZ5fLX5LA9M21h0/KfNYYNeSV8LSj5sqj3IPmbOnfchH4g/46IGHWNIpET4zmDx90/HDZ40NF04hW1FY9MFVBRkic19I5sxnN/wdKmiBsfjzQtQzhNGuJHnnBr93BBUU8k30t+ve+OvZcHNsjxxx8na7kLT82W74PqCBWbjK3kDxTtQ1tru7j2od/bMLOWiYqX+HG6kAJdUqjyxFDhQ4YbiD4NRtO/MVHm2NbRRothzpNgesyor0XY2gaVh9E/WBvcoC4HPCh0mfP7GlQyUVJE/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/genalloc.h:52 function parameter 'start_addr' not described in 'genpool_algo_t'

Describe @start_addr to fix it.

Fixes: 52fbf1134d4792 ("lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/genalloc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 0bd581003cd5df..0ee23ddd0acd3a 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -44,6 +44,7 @@ struct gen_pool;
  * @nr: The number of zeroed bits we're looking for
  * @data: optional additional data used by the callback
  * @pool: the pool being allocated from
+ * @start_addr: chunk start address
  */
 typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
-- 
An old man doll... just what I always wanted! - Clara


