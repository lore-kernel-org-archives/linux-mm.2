Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7965D116E3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 01:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FC46B000C; Wed, 26 Nov 2025 20:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7CE6B000E; Wed, 26 Nov 2025 20:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6BF6B0010; Wed, 26 Nov 2025 20:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA376B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:15:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15BD9140600
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:30 +0000 (UTC)
X-FDA: 84154619220.30.ECB4700
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BB3720008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BtISppem;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764206128; a=rsa-sha256;
	cv=none;
	b=Nz2SFC9UTIbYdUFAbZjZ3weNa2jSL3sAEq5QUZELmwh2cJY/YTrvCN+Nexc79SYaR/NyTl
	Uc8zs3o/UL8UkxMtp1TxUM7uNere4g81ZcFVko1BMq029bC4gtWKFhRcOjwz/TP+QYK+EF
	ooBZQi+K0GQw4icjjd1whfUhTmzvykI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BtISppem;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764206128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWpzj6B5gF6DB+hbE+NOEZVJH7N1deEp/v5DIh9IZkw=;
	b=6rpSuSmY6DCFQ9OF4C9aqyNLQ5ZJy/4TIDdlci4u3a5QY8lJYMIYz42qWe5x7HSc1HCTh9
	/QjApLzJqxfWQWYDLgmJGaV3ZlZH089LLwJeleNQJ5d6NThzVJlzR5Drv2uVuHG/W2/UEC
	hd5+icYGJFsjeXJAY8gQA7F6hYy4/Nc=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3414de5b27eso271837a91.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764206127; x=1764810927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWpzj6B5gF6DB+hbE+NOEZVJH7N1deEp/v5DIh9IZkw=;
        b=BtISppem1OVVQQ7ybXJBi8zTS7mDj1oNZwkrkiUKCJJSJ4YgzbqzGrNn9iVTbwwh7c
         1rsfWX8pXZmjZv4xU/5M8kYtyB4PUY/GWCdNefgjDIhmOc+avuTWs2eTzzg8Rug1jM6J
         eUJyaNBBGYbq9iVrz5U0JTu86OR0MXWGt4lYgP8ReyfsW52/Sudh8Diglv+xVnzsQpej
         pPujekqMTBUhOTWpn6rq54EJIPcltW2qLqG1AhObV0yOV+mAlxBrc5HsyN8Zwyt9DwEh
         TCIvcV4ThR6JCUewsKd4FhlwcwkYtNYESkUCwc3BYNB2ZcPWfz5BurVS9JSroZ8xI8w9
         SThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764206127; x=1764810927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FWpzj6B5gF6DB+hbE+NOEZVJH7N1deEp/v5DIh9IZkw=;
        b=MVuCEPQPeFmcODCEyrfJcPFtIggvB6cxbthOju4VxEcIKbcQBQvoOHue+09Qcs9q2r
         E78s3m8dUQdBb+UnmzT++XWqIHddEsWK6PhFojI8W/zEsa9sKl32gnUoiwXChmLFS89o
         mQ5z+Lh3MNnY2Y6hFEwNkVjLlaIRaEYRuUMWLXWIhDET54JWUbYRoPhxIpBbS2x2pcUX
         2H1d9m4HG5YvAHfmRoF2sCy2lT8eAyd/gxjin+DfsNeCRIXHbhEWCBA78xUCoZtEhNOs
         BImuyLsjB1/g3KkAIQynzxb6CToBQRVtjFXeO9JMWAL3J6FyICeqFF688PkCGJowN4ne
         3yOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxM1x7wlaDfaTVmnXrHkOHg1cnnKsBbR3JdKerkkoD9bzoN2ZVLKDRl6MLrjttwYq4BrROd0CuvQ==@kvack.org
X-Gm-Message-State: AOJu0YzA0qcd7HBjpKyS1TMBdEpIlv1ym+KDZIttnN2HRcmLhr4QRDgd
	WqS6TetZgkQhQuNoZ8+aQ5kliOWp179eLTIW/8m/E5HAAlaTRd+5uQAv
X-Gm-Gg: ASbGncvqJ7VQPdWYQOLfcCF7PaRw2k8fywSwgegldYI2KVz0oI0Mxa1J+Cg3mxDweXf
	a+S2ww5IlGvnnR0rJb8itg6Hfzr4d8v+l9tYt4RIbojBgcKPVJY/1Erta9ekIbVcol/l5+s0JH2
	uEj8TmgmOI7UJUGqvErGR9MLlDzZ49s62bi8wgd7ulJz1R6ixNJnbDzM6TcXU9WSPkZJm0r7guH
	klAWrDj5XtIBaASiIx+ZgWEYKuOgYd0sPKqRwMlqmAryU2CLJaIGibuFFuQjtJFQ16+N9uCanhi
	SEUtZxjLiJlA6x1jYKcDqMhgtWkfC5B69Isy8RoZHNhPyj6UZmqhfeE9+fdSGgJOxFLFN6egy6Z
	iDxLenuCUS19d5paaxkfSgMzJllFqMAv8F+owpXYU5C/Le/faD5c+hyJziKkiZIVfTbzUP4WftG
	k3SMcFGmHiGTN2ll2COa5vk/RU
X-Google-Smtp-Source: AGHT+IEbVGx3N69Si7CHlaljqaf40tFMimNr+eyLkblnTtUDUiJAn2jdCvTJXncBxHt/s07HBZRGvQ==
X-Received: by 2002:a17:90b:48c6:b0:340:5c38:3a56 with SMTP id 98e67ed59e1d1-34733f5cef1mr21117170a91.37.1764206126598;
        Wed, 26 Nov 2025 17:15:26 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c414c226f9sm22447356b3a.53.2025.11.26.17.15.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Nov 2025 17:15:25 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: Oven Liyang <liyangouwen1@oppo.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	=?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <v-songbaohua@oppo.com>
Subject: [RFC PATCH 1/2] mm/filemap: Retry fault by VMA lock if the lock was released for I/O
Date: Thu, 27 Nov 2025 09:14:37 +0800
Message-Id: <20251127011438.6918-2-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20251127011438.6918-1-21cnbao@gmail.com>
References: <20251127011438.6918-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BB3720008
X-Stat-Signature: 8rkzdf4tbh1dzjnfij4a7uud4gyuk4ba
X-Rspam-User: 
X-HE-Tag: 1764206127-495356
X-HE-Meta: U2FsdGVkX1+dpGr+nsMYc22P3EiHmfU/A4P+e/NOVmxpjBLb2XwyaC8TngQTbLq/UoytFR5cySWCGEprIcy5fRojelIAmfLfbFqUnAKzYuITdkZCfZwekPTyrJgguklOUknB7LMvHf6dFqKG8fwi15Ggf9jX31KUl9h8lM9pa0vbmZj2gUC1+QCmcVPJCl8k6Rx98idb4AY6CUTtGKAIj3KPB0vtqzwDy9uCHa+VzkLFh5IETa4kwUrobFRZlKlW45BmDchRiUQM4g+16pHDyrtgCEF11N9WJwGon02HJS8Sy6hlhH1WbZ+klwhJ1bNiMp6wIHKftxKzdwYMMpMrkiBt1N7bUVVSF9DBWajJJh86ouBV5QibZHsibsPFkdngIVGXcV26QIVDHHlSSMB/RX6EJDvdh+qvb3/dixD6vh954BurOlaIa7Er1JhhlSW8QcuFmtltWnA91R+zVLt95RXDHD257ccMH94A8CczAr/z7H9miEAaTB7xvZD1uCOsOhSPbSounS/ZzGB40bEyeGtqRNVDcr+iM9IdkV5+LEw5q7DWxsTtLWqWMajFQsOgiGqLOvQxz2fb459TdehKdw46r8BmcAtUK0OKmWM5WVrsdhLQPGRAY3FJrKVv2zG+u97Ve4EXjNMrElLteWyWUA9LcteK8OjxbacMK8heLEVxqxE7oh2Rx5HVMWHC/w1skjs3HDOS9AFWeapVRdqzRDdwGx+uz7tg7BhKcRYgMaWQFNviXEMfQl2uq839p9ObaKBSwLMGzAhwK2PwIE8BTKvTUjT6t42y0ddah3fuX3v2t0eSQX/MGvcxSa8IlALaLiV2e6KssZoFXFKjrnJOwLdJSzhfPIsCr4e3kcwkkkS/BLGAwfLYxvewKOtzOEMLWmRAQzOhbakNv21gTg6E8+7tqylm7XuWxelnQe6dx7JMZKax78uGQnyRcNzLa7K2CeYorgaCCmF6PUCFq2I
 +OsfOX22
 nT4nOHeGuhOQ/g3nNcfaStGb0JBVWVpb09WUMMV23cOq6AweAzOWKD8/O/onclN1UrnYsfA7YTLH6q4yIooeu3nAiRHIQMalrcEKHxYsykGiF9xKui9Z3LlcUg737zAMZiokyl5Cb4OJgiBwjy2Lpt080RYHSiMFF13ceVlupjpyoMs/oJObAxOcmi8N++jUpEJgqwMUCC00W/O4T4vu428AxiIMMyZq1VoIGuqijWAvTm6MWP3+JxMIbF0UpgKcfMJjJK5piRclKEj2Ufm0b7zTKNtX6qHHlWv7L2riGwN/aG2laao5A2oUbALDjVYwggrbk66MOPF1OH28L/EP2cDxfhaOpjmZHzoNamm4p88GXxVopEefZOKM47AdM+A7/3eGO7HWvVgL2fi6PLnTWYSoRrsBHBCtKl4Et5QHyMxGE6JMMUUpxdZyBSmaxAXeM3t81yShYsUh9PknzU+iUKH2PoJUAOW+mnAdXylKdxBSRBGNSpMiqNyiKzIEFcwM+RjSt2ZDmXA1iKzQhM2p12zFtq823x9RX6tZpDxc7BnbMDpMxev8UNovG2hPplb40E3FX+OBt9ZcgI0SkGrzRvenmnnQQmeHkkO+nD4v0hFlU1KMVtrd6Z9Yu0wdes5+mmAzFuJGTqP9+Cx6YxaiTA7UtvdSQi3LPe22thoJm20htPLrYUfeF88Y0VraaFKistZ46agspGMPDPgo5n1ZGPjNBNfzrp0wvmq4OVewG2emIYkmpVt+ueUmcSpwf/vgI8Oze2hRITjqOMspVFIBuOqLq2Bl1ZD0cYaygcaab3gCU1U9JZPjYeApktHEN8//nKwbnrGgSwiYNa0mauWoud6y1eXri8xBlngqeRz17/6VLYV+sBaMqH9i3rt3vtugcbUeJijn5YGs3xL5XHfPT8vN4o5fFzmU+XfK2qg/rB1qhicJHNj0nUqs+7EvtRJtI+ZdGtkjmJ4QdrtxMegJr+ynSiEM+
 h5qL8u2D
 qPD09MTrYwGbzUBKl6JQogFbZ8IRNyT9tddq+iyChXM1OvxKpSxFEqtI2UAeYHniklITlVMt4TenA6giJFpivFx7k3kz5PTypHhQ4pLPOITNmcZp4SqfumByPuXIpXwkRZ7yS/7Rig+9VAc4bF7X0XZtLxjEVkSf4XWYlLQaBVAx8seCzlDyA+Sonfqp7NgQYQratCFrv7qnj86pldA3oV8nVefUwKtIS3gY9DJvZg1YFkK58dlwHebFQdvQZbh95ctxPTLnfms5YQevonNVPVgMB+/g7OMw8QWODBXvb5F3zeY6iY9XqqFJC9vNWyh7uG4MtWXbSmKKW28FXg98p9cOLYdwfEJ4gYkV3ZsXLAPF5Uq93G622YEhmZGSs3xy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oven Liyang <liyangouwen1@oppo.com>

If the current page fault is using the per-VMA lock, and we only released
the lock to wait for I/O completion (e.g., using folio_lock()), then when
the fault is retried after the I/O completes, it should still qualify for
the per-VMA-lock path.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Kristina Martšenko <kristina.martsenko@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Wentao Guan <guanwentao@uniontech.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Oven Liyang <liyangouwen1@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 arch/arm/mm/fault.c       | 5 +++++
 arch/arm64/mm/fault.c     | 5 +++++
 arch/loongarch/mm/fault.c | 4 ++++
 arch/powerpc/mm/fault.c   | 5 ++++-
 arch/riscv/mm/fault.c     | 4 ++++
 arch/s390/mm/fault.c      | 4 ++++
 arch/x86/mm/fault.c       | 4 ++++
 include/linux/mm_types.h  | 9 +++++----
 mm/filemap.c              | 5 ++++-
 9 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..49fc0340821c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -313,6 +313,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -342,6 +343,10 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 			goto no_context;
 		return 0;
 	}
+
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 125dfa6c613b..842f50b99d3e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -622,6 +622,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -668,6 +669,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 			goto no_context;
 		return 0;
 	}
+
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
index 2c93d33356e5..738f495560c0 100644
--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 			no_context(regs, write, address);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 806c74e0d5ab..cb7ffc20c760 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -516,7 +517,9 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
-
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 	/* When running in the kernel we expect faults to occur only to
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4..b94cf57c2b9a 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
 			no_context(regs, addr);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e1ad05bfd28a..8d91c6495e13 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -286,6 +286,7 @@ static void do_exception(struct pt_regs *regs, int access)
 		flags |= FAULT_FLAG_WRITE;
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -310,6 +311,9 @@ static void do_exception(struct pt_regs *regs, int access)
 			handle_fault_error_nolock(regs, 0);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 998bd807fc7b..6023d0083903 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1324,6 +1324,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1353,6 +1354,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b71625378ce3..12b2d65ef1b9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1670,10 +1670,11 @@ enum vm_fault_reason {
 	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
 	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
 	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
-	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
-	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
-	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
-	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+	VM_FAULT_RETRY_VMA      = (__force vm_fault_t)0x000800,
+	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x001000,
+	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x002000,
+	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x004000,
+	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x008000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 7d15a9c216ef..57dfd2211109 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3464,6 +3464,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	struct folio *folio;
 	vm_fault_t ret = 0;
 	bool mapping_locked = false;
+	bool retry_by_vma_lock = false;
 
 	max_idx = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(index >= max_idx))
@@ -3560,6 +3561,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 */
 	if (fpin) {
 		folio_unlock(folio);
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+			retry_by_vma_lock = true;
 		goto out_retry;
 	}
 	if (mapping_locked)
@@ -3610,7 +3613,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
-	return ret | VM_FAULT_RETRY;
+	return ret | VM_FAULT_RETRY | (retry_by_vma_lock ? VM_FAULT_RETRY_VMA : 0);
 }
 EXPORT_SYMBOL(filemap_fault);
 
-- 
2.39.3 (Apple Git-146)


