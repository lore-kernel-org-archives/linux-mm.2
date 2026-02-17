Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6729BE9A03C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 19:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89756B0089; Tue, 17 Feb 2026 14:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C161E6B008A; Tue, 17 Feb 2026 14:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEECB6B008C; Tue, 17 Feb 2026 14:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B34C6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:58:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B89E1C2E2
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:47 +0000 (UTC)
X-FDA: 84455011494.16.71BA42A
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7EFBE14000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=LaqiP1tK;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXuAwV7EvPnrzwYm1Nj10RW4qIvW3kT9YlwlXXuuzFI=;
	b=Rkh6eOCf4Pn8XrVqeEAb+YZRLVM7p+9IogYWZWJ97+H8kUv+Xo+rJRDZ9gxpzIb9ZSP8qj
	7wAa3ptA4vZ3/VUxonfMFkdc+ONONysfNRxaEva1i7kd/F4ospxKlvpLygTGlsOd/bbS2J
	z5lsnoRpZOewHrCE3rvTEEmtN5hF9OE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358325; a=rsa-sha256;
	cv=none;
	b=IGjODYq9EZovqXEwfS81QdOQOhK0/kAWwtclPyBTQadqnW49N3R0RfCv/U0je+FVGA9jbU
	dvj1jNWdJuDbi9w1BhViqGIvFYLiD9yDT+xMFiyE0PTZ9x6x6vUfXP+PuXiGJOqz3YAD3d
	xeexLEIdeek3iWDnQ8bxIuqYwNXzxkQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=LaqiP1tK;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RXuAwV7EvPnrzwYm1Nj10RW4qIvW3kT9YlwlXXuuzFI=; b=LaqiP1tKNet3KRNu+1d8iYOjO3
	2lVUrYVDdGpWPsZ/HTe/NbzLZ6AqlI4ETF3MXFNCy500uMdTck8cpWYjuRHT2cSVxfNarRCim54rt
	TBydzckayuRqC1JqqxucOk+jiV/EHiVMtJIJ62wq6Rsk9V9C0Cn9RoAw0GwvdgiV4ijVufKMJXYN8
	pqsoOi0m77R1RAfjUUbvfUqL97ViqvAjR+fytqhD/RYzOyj0nDWpYRfC2DAvuFemlBwFTwK/Z44tM
	NGxrEJrIzMFgjn33UHOwiKdorOJGxT4LqhdZEnGDwXEhuHyu1f9mxZKMGdvxq7VQ09oMVPnUHBk/u
	W2Vvp5YQ==;
Received: from [177.45.213.208] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vsRDX-001nLA-3A; Tue, 17 Feb 2026 20:58:43 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] mm/memblock: Print out errors on reserve_mem parser
Date: Tue, 17 Feb 2026 16:45:06 -0300
Message-ID: <20260217195816.861684-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260217195816.861684-1-gpiccoli@igalia.com>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7EFBE14000D
X-Stat-Signature: wf17ytijraimj1h5u9usxe9k1nmxkwqn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771358325-955019
X-HE-Meta: U2FsdGVkX1+8vpcMQpzQELLT2badJeN99tIKRqmYsP2+7KGRfgVpoZf7MmKWkCrwD8GnRtw07Q4XkG5ZD7XvL/NUBO2mNVUMdpDQO8JmiJK/6we8IoZv+ES/3VAhb0whXX6WbSN+JhU+EWydp0goGUw29cG/6CUrh8CuApDi+yXwHF/VCKFcSixawr7ZMa3YdMQ8n1cLcRsGeke7qv85bpkRhNXgXHRdQFreNtiKZ5bQU3kzLIWqgFIlS3neqAYQNYL2VJG2HST9rFLNOGR98Hs5i0PMyVlJb93ferud1x047sOo/3B8Ab1D7GVX8kKuvaGEURXMOa1M35AkxceJyDGkzBERKcp8VEREBNTWTs/73q0Wh7zTsTKAqhYblikaMo5Ze7H59lQRVlMVoI8Jr4dNE3Ye1YHQ1ltAh62Fhbn6/KEHSbFh4vjpzIN+Mxel3qr5Cr0bmaV3J/ctT3JqhYtNGOAS5Y5mCjrLl7dTMaF8LzYYdDa/7WBkUBjFMsitYBQ/MgLZMqtFB7cZPo/QfnlAXD8sbWf/u7NwFb4hDHpbKqA2o828XV6vnRKBBFjAbYwWw8bP/IPn+mjO/OXs7zQ5ZccDDksh+fX3lyT24NDGu8o0sVivVMXff6oNwEU2P13V2F4ie8AcAF0QUEPclQLbMSmeZZw0DBy6lhDevCueryCjnOJhIq1wgKbIGNvOkI1wB7/M0DzSuuv7dXA0LMjB82io6/ZbHAH2Myyfeaa52yfU7a1wX4br3b7auHNab7/1AuXsaSz46EmS3uODKxSKN7w8D808aN8HAzZg8ryxLCPCu4cco9qIAPON6kotT9+wqMt3+jEK3fRJ11BBll8P6ihyHEU4A3b26GmncGz6pNJYhPmVh74QoCQoQWbToZW+hMmEPFFSUb+liAglYKKDfXWpcBHWrL3QZhp+5tkVAa0nd7mgtgvaM7xtOje4y55R2/AaVPjgnLXM13B
 FVMjlPfK
 U5qMFbn1CDHoVtITypgVkWiDAkawl6BbvNcOamkuIM88NmqRdX+zQvojfZSU0Mo3ugIoP6bElBJejPrCHSc8NvQ0RhG2iUExnh59R69ENFf+2v7f047Wxt6ULflsktQe/0kkM+HHpBJiFpFC7EMda4Hf/HXOQisLVhC7AB1w20A0PuaU44Q9ifp5IyWutBy4Bl2hYxnTn0vnPiXYtIzxxFry1W1gjd6MZNgGdqLgTI1Sa5cfXTEjuQ3hsCXIziypIhrIKOWR70fVrNlfH2xc2ef7pOtUlATuV9q3s6/9i61U6oAECy2hEzVPZ+w57MJ54wNq/s75r1PpD1ByxR8T0jsEwnnx/CFuc/BokblVAUqFEyDxInYar4CLh3v/zjjiaTzu/Fa2HpHC8V5m0q1uWGOTEcVqUNIqLrn1TVszw7UZD8jDGqt6xhauqcExiCKXguIskhwTX3nIhDd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The parsing of kernel parameter "reserve_mem=" is subject to
multiple failures, like duplicate naming, malformed expression
or even lack of available memory. Right now, all of these fail
silently. Let's add some messages so the kernel log can provide
useful information in case of failures.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 mm/memblock.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..2d2646f7a120 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2642,23 +2642,25 @@ static int __init reserve_mem(char *p)
 	int len;
 
 	if (!p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Check if there's room for more reserved memory */
-	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES)
+	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES) {
+		pr_err("reserve_mem: no more room for reserved memory\n");
 		return -EBUSY;
+	}
 
 	oldp = p;
 	size = memparse(p, &p);
 	if (!size || p == oldp)
-		return -EINVAL;
+		goto err_param;
 
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	align = memparse(p+1, &p);
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
@@ -2672,7 +2674,7 @@ static int __init reserve_mem(char *p)
 
 	/* name needs to have length but not too big */
 	if (!len || len >= RESERVE_MEM_NAME_SIZE)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure that name has text */
 	for (p = name; *p; p++) {
@@ -2680,11 +2682,13 @@ static int __init reserve_mem(char *p)
 			break;
 	}
 	if (!*p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure the name is not already used */
-	if (reserve_mem_find_by_name(name, &start, &tmp))
+	if (reserve_mem_find_by_name(name, &start, &tmp)) {
+		pr_err("reserve_mem: name \"%s\" was already used\n", name);
 		return -EBUSY;
+	}
 
 	/* Pick previous allocations up from KHO if available */
 	if (reserve_mem_kho_revive(name, size, align))
@@ -2692,12 +2696,18 @@ static int __init reserve_mem(char *p)
 
 	/* TODO: Allocation must be outside of scratch region */
 	start = memblock_phys_alloc(size, align);
-	if (!start)
+	if (!start) {
+		pr_err("reserve_mem: memblock allocation failed\n");
 		return -ENOMEM;
+	}
 
 	reserved_mem_add(start, size, name);
 
 	return 1;
+err_param:
+	pr_err("reserve_mem: empty or malformed parameter\n");
+	return -EINVAL;
+
 }
 __setup("reserve_mem=", reserve_mem);
 
-- 
2.50.1


