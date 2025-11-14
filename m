Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DCFCDE019
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 07:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6598E0003; Fri, 14 Nov 2025 02:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76668E0002; Fri, 14 Nov 2025 02:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C8E8E0003; Fri, 14 Nov 2025 02:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96ECB8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:30:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DCDD1A02DA
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:30:21 +0000 (UTC)
X-FDA: 84108389442.25.BE7935A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B050140006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:30:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dall0xEi;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763105419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jETUsrNOtIYAIHLU5+yC9wox6nnk6e6+1rYc5xFt4DE=;
	b=LbWMM3xotoHS+Q23vIT8NdAOMuaZwjkvdP7vblPIVCHL38N/yIPy7GyQsXmMFhWv0PKbR/
	MlpibxVWjx7Q0DhDJDx87vk9vP9m86Z3FY5n0BCqxOAp5yGtSZcf4PZFVBFKbSlF39InU0
	v4fswcz8L0/0xQuOVkTqmM0KjSaFJ94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763105419; a=rsa-sha256;
	cv=none;
	b=vGacdqCQtFluhFR22OIi0FafscuIml+XQ02+t7vpt80hKr+pTbRyFZ9jwopELU6EBVVPR5
	bfiXsxzWcUzu9NuZQ4C7olJCPtQPDbhz/gY0vMD+pCzKlGT7c/3nRWMk4XIfNFgpRmQs5L
	QYOwApnq1PatI9DXdFFCsvBzywckvj0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dall0xEi;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BFE341B1D;
	Fri, 14 Nov 2025 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD36C4CEF8;
	Fri, 14 Nov 2025 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763105418;
	bh=ofHq5p9Z3RmRzcDHoqIGOqiKwshUcCL3Eo8rh8N1eow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dall0xEicEsJMWwgN246NGUG4Wt2t1VsFM3lAbgskABkVYqL1yPKR9ohMLRjTEbgl
	 tOnE84T+jml7UGQaiA6+qdmCUCBW9t5lNIranNvkvTLuIH65oNGHt51yDu0lqkJVS6
	 kN34kkvGuzaxDIws+ZwdwOBVQuvj55/E/6rDCUx+nKohXQi2+qcJhgLpcbfho1Ep8r
	 cPQC7bj+ktc8Kt5wWtbCy2LZiKLVapRNbbTcZBxCyTmocKbHflDyxR/OTFgHkqadeo
	 NkwzniLBj861/jzwgronYdq5Eh6kVGynd+ps9lYO3/EpVYIg13iY8xZbYtIeR+pNXA
	 z78J7/QWR2USg==
Date: Fri, 14 Nov 2025 09:30:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, graf@amazon.com, pratyush@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
Message-ID: <aRbag7qR9OVNAQXN@kernel.org>
References: <20251110180715.602807-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110180715.602807-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B050140006
X-Stat-Signature: xjzryy87bmzpopj5b9zuxu38nqdgoziq
X-Rspam-User: 
X-HE-Tag: 1763105419-6004
X-HE-Meta: U2FsdGVkX19R+LVVFCE6a7HdOnS8eVETPUruPSnr/p/r1mcBb29DdqcGvBPd0PL9ORmbpgmAWU/fd2MP5wZo+qxBLRN3Y0/GiHlGJ7AQn7+jcxpZfp7MP31qpiXv0kVXG+WBwBmjzz4k54Uq0L4quCc0bY4Cwmk67O8QR/46dviQZlNSRDKGaC8HSZie29/GZcnDBFbl/N1rTmUrerk4ld7Y6qU2VXjqvogNVIXNetD6RHuGsh+mEjc/o6GfamI83h0inB0bzMeiAul3KTZrA9i9yNzKHr3Ews8CdMKK//lpJ4CWceLj31J8+BnFZNn8PQfaCeczr2tdAley40BAM9ZzMuCslZ/FrdPqCosvIKbzXb66kOWrZ2CM0wXZPjtJAbnA0mp9zPv3zakkLgY8usdaKLUSKsVCtxkZaVCPfQwviH1VekU18QN6vJBq+88M5/6pd2d2q844d7LC3gFK4w/VQ3QmJrTL+2BTNrZUzPbvoJ9ndcw9G9FvTs87bVcw/nf8zMbL7wzDrEXGIZwFPbs0dvMPu88UkE5CA8+3vZPgfx7S/w1gU4IDsvVa45erobs5w8llLFYrfdW1sycLlLH1q2Etu3qTYOne312F5e0DR8k4iqsKb3j87PndRF7vvOLdiZV5VaNBLYjsSGLkLM8HaJqtQslL11YMVD9OaRyFlsxF/9zYxPM1Syfg4RZBz6vXySbwel1xIFGyCBX9uC0ijKaHACnWzuI0Spnmx6HanXq8QyQup3xdBuGbvqlxVkoYTG/XfAgAZWi2gh4P0sk62KX4+tURTgk5RecENXX/grTgMs3epYg1XjN733H5+8DoZvyiUfnOkUaUeqfwHVP8ZZ1ERGGikbRrNXH1HLvKzaC3txb2rOj+XfEJKCeVaVZODsU8JdhFVRGgnwHftv4afhCb+MtQyZ1XICWl46xKmfxueVUq3Oe4SxuF1m1wsLNKgBpZ6iaslJLIFnO
 vEVaSVJc
 45DdY3/uiwYVyUlsDrE8D4x4fkq7iV8MTOOGK68JNpvi8r6AgPXZi1WFnDQiQcX67w6xtpGbAl42VerXhLwfyvFa4wE6qdDV8MLEqs2PTw+2x/VaYD/Nqvwqaq3K2CAjCgQxfKWbUBp9UV+lu9fDjE1znbsblJeBwRbcOkARZmEmoDH3nqgDo2EXBrilpDXme9I8dIUyjMQ9Jl8Ifkrjn/qwcZXubMtmLKJ48+2yTlNhf28TiRFDoTtzuVdZqp9C1PBQg6n0/i8BN/UG0vai6CcnxEgXJD+3ocvYQHwc/Ot3N7Ji2STIE9c/NzXTImwZRKHGKcM7PMH4Xf3tuIdEUMcKsfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:07:15PM -0500, Pasha Tatashin wrote:
> Upcoming LUO requires KHO for its operations, the requirement to place
> both KHO=on and liveupdate=on becomes redundant. Set KHO to be enabled
> by default.

I though more about this and it seems too much of a change. kho=1 enables
scratch areas and that significantly changes how free pages are distributed
in the free lists.

Let's go with a Kconfig option we discussed of-list:
(this is on top of the current mmotm/mm-nonmm-unstable)

From 823299d80aa4f7c16ef6cfd798a19e1dfe1a91ab Mon Sep 17 00:00:00 2001
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 09:27:47 +0200
Subject: [PATCH] kho: Allow KHO to be enabled by default

Upcoming LUO requires KHO for its operations, the requirement to place
both KHO=on and liveupdate=on becomes reduntant. Let's allow KHO to be
enabled by default, and CONFIG_LIVEUPDATE can select this CONFIG.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/Kconfig          | 8 ++++++++
 kernel/liveupdate/kexec_handover.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index d7344d347f69..25c9a4d7781f 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -63,4 +63,12 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_ENABLE_DEFAULT
+	bool "Enable kexec handover by default"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable the kexec handover by default. It is equivalent of passing
+	  kho=on via kernel parameter, and can be overwritten to off via
+	  kho=off.
+
 endmenu
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 568cd9fe9aca..23a3df297bb3 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -51,7 +51,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init = true;
+static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
 {
-- 
2.50.1

 

-- 
Sincerely yours,
Mike.

