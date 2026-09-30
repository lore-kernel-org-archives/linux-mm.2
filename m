Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A22BCA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8266B0092; Wed, 30 Sep 2026 06:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A97E6B0093; Wed, 30 Sep 2026 06:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01726B0095; Wed, 30 Sep 2026 06:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2ADF6B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:02:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D238C06E3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:02:51 +0000 (UTC)
X-FDA: 85269989742.25.9A74B18
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0668040009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:02:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfkHMdka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790762569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qRsSUfuBnTMx2Y9L6KCbkAYKGnB+pDv2tFE4p6k81k=;
	b=pZvVkvWnz0orwTcOnW6CyE8iUwngMPCTDQCToYlwxlBED+MC1G21TH2NVkVPfsRIdkzG8e
	db5qEn069+spaU11/PLKrNmcjHF2YuGgWElbzTqbkIwO7iHRYSeGid8bx88CLFw4WfZzRP
	tbIEfpQ42uiNAb8CI9qOusHUL0b6MWE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfkHMdka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790762569;
	b=4RE4akQ69CyRaGx/5bNaDYpZ/0Ff9Z5vXqGonKycJ0Aaa+DS+CRmHXdc/2tcKeRYJVki7T
	XGPaT8SOr0Hd77bi7emgLxpUWsYoRMw2JkUUHY0V0D1Cuc5Tu+AFsTmBiSchCg55Cp4Ckw
	viIc2ufal65PWsrvst2SWAgwPoPGCgw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6qRsSUfuBnTMx2Y9L6KCbkAYKGnB+pDv2tFE4p6k81k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790762567; v=1; x=1791367367;
 b=MfkHMdkaZFeZ63PXyuvaJ9E6glbryTwVflyII1EBXG9UvkZF5eI7Oq52rSTfVLjfFsC1DQGh
 2Z1dsZlDdoMPiQZ9UtihJSHd7yfDlfskF94GF2nKN7Ei2AWEmZaRkPTSU+XDaaTgGUvluLXgcky
 ZbwRYYmSbBhwEZmdmKbQRIbw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 702ad52dc12a4244;
	Wed, 30 Sep 2026 10:02:36 +0000
X-Mizu-Trace-ID: 702ad52dc12a4244
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Wed, 30 Sep 2026 18:02:26 +0800
Message-ID: <20260930100226.23688-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-3-songmuchun@bytedance.com>
References: <20260929053231.66085-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0668040009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: frmdqmnsabaznkb9ncadf4wy1kujocm1
X-HE-Tag: 1790762568-440736
X-HE-Meta: U2FsdGVkX1+izVNB3fwHC2YrcP/GY7B0SaMEfXaGAqLuU5m+aSJujGdgd423PkKu56p25mZMUNOzQxAC/d1i4+nQ57oIP9EIURrUaW3j7I/jEBdHRXS/ihpvU+eu2rLPvF8ZChBW+ipahmnA/i57BQPvNiySkzvmE0pmZ6WSgQqcKQG2DRO27ENQSxoVDVTxW02M80qN/FTETeXrJCMYE6Kz30UiVPfzseWAq8H3Pix+2G9JL9KYWF4tCyztd/4Ig2nYvYEO8DCxR6chpF8p0jVDFRTLzv10FekanWXcly9hZANLihyQ50fq62v9kCQpCCkDa15D2q1IBbJhhg8zICqERM6dWDhVthtN603RO546XwiyE8jV3ILeTo3iorVIqmJBl0ta2uMxNCe64B7JaU6I9fvsdFSAECofyv6+gG5XaV6MltWJQBp6R+yzaC8MANgpglDXi4MFUeZG1usQI0x6uYzIZwu64mXrH6539pj7ZxOARl+D+N8i/6tEoQ8IFQcvYxq20QznnIZ4EQVEgHELOvrGfqxIMRt9Cr77/v8YbpZldYRQCx54m06u14Jor7Z1jPbb72uQRry0i/ILMKsphSkJXNKa5anWB6N7nuVgsuAncdYUM9sGWk6CkDPC/TZVuzuo+jWu4+HL4iekrrnxfHAwiH19FzuSXSYP1Whgs7Zl7uf7GN7NKDVvSKI+EVdojn5hyr9JdMXlX+s9VskKDGSYTTOjt0YDfyEkv4z32JDwL7V2da8f1zNN8E+BsATy6RFEq3ByCusD9KPeq5uYso8lXCjlXiRGfC7QYzw9vyCL9HKgXiD/4V6mFFHKJV3E+4vr8PNOghFWeYzjlBxU1/DYq9H3GXm4ejLY3ktR3MuCRukp9jVPNFQ6eJ7jKF+B7MVRmq2xzvnG3SSHv8fTWcIujxXekmomFHlZc8cLQ1vUWESI3jVq2iKi48pPJ3kmW86CnlcH1Tb1sOe
 T7RUvH/r
 ts0PSlbVm96PagKY2LCD+5Mio8i/u0g/tNxWdEegWdYRT07JFOzesKZ8lzSRQopHlVAhhqD/GYFHscD8NeJl1z+9OajxftUZcrvFwsisavX1mCiBL7kTiJ5X9Pt9pYRczS0Chm6w/TpHmBctfSDhA7s/CrRT8zzu/BNA7ffP/EmBfuC+yDXcZ87jPkEnletzfZzWns4zrbYscXAxbgRKA2s8Qn4fCVkXNYVFSXj63+l2BStFZQe50RCDIAPROdcRe+k4ewPGxLziW26WTMQipq7LZrvPk6Z8N+gWAYoh9iUaj3MdDsFDgP6Gfwfe5qq+nJi9qNv9sdW53Thc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:27PM +0800, Muchun Song wrote:
>The common vmemmap population path cannot yet handle optimized Device DAX
>mappings on its own. It uses pfn_to_zone() to find the shared tail page,
>but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
>is initialized.
>
>Teach the common path to use device_zone() for runtime optimized vmemmap
>population while retaining pfn_to_zone() for early boot. This allows the
>same path to support both early boot mappings and Device DAX.
>
>The backing PFN supplied by the Device DAX-specific population path is no
>longer used, allowing the redundant lookup and population code to be
>removed later.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

