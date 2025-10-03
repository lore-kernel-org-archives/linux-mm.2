Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C322DCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9678D8E0006; Fri,  3 Oct 2025 16:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918408E0003; Fri,  3 Oct 2025 16:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFB58E0006; Fri,  3 Oct 2025 16:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 609678E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:15:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A7E487F6C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:15 +0000 (UTC)
X-FDA: 83957907390.23.07BA250
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71061180009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FAiGGoC3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759522513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7MUZ1SW74w7TiQIYpufzexzvF3vpnfWGzOhFu9B+Ps=;
	b=shSbjTrWCIVZCk+8UCE0Nv75PQIK9KaCcB66Mq3PcOVFICAWHZ4EULKviWa0WS35Xtv1CZ
	k74fXzZur4XjaxLuB5MM2MNLNnQFUNo6SCJRlX04VCdtGdoIp+BLvP3Dman9jA904//Sh6
	DgXRUPHBSQSEwfF5fYpqPmRAR/gGLj4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FAiGGoC3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759522513; a=rsa-sha256;
	cv=none;
	b=kiatezn3lysHHOnZs61qLXDE5szlMsZma4ChekOReUup0rYUtajCC33FW95FZ4scVZIaGs
	mhyPDlP8LaBJOe33Db8V1A0+LJY+yHtY524qkaZOdpIWapDLfiz+D7ikKywL55ZpaZR1X2
	t/yZSuJlxxdGx76gsb7fN/Rz4ZKL1UQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B35E624CA;
	Fri,  3 Oct 2025 20:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B9C4CEF5;
	Fri,  3 Oct 2025 20:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759522512;
	bh=bjwiI9Qos1leLOU/dQfUObg++Tq8M6DnTqo6oPGEiwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAiGGoC3YCsVr4iogOumZyxh+ejcDryCAR6xlmtdwpzmPRapmWe/8/vC6ii/Iekmn
	 qrVTrHY1nQ+tZcwdyLnWwuE1SWd46ShRfMqfE0PLmv1judTAgpdNBXm3VUYVG5ZSs+
	 7GDWZuGnwrVzsgMB0ROjGo3Q8rFf75L02xxAUxp1KZlksOF0m35m5rgP7EWrnLpkxa
	 7KXmGufNdLh+PEH84FHy/v6zeobPwA7Ohpf9gnOd7qj9PMbh9yZYAtBllDy0/fShv3
	 V/HlnTMboDq19GvntLbUNYnUh7kie3pDjZIqQR+XxPLaIV74zWx6lljpBcnnrFWB5c
	 1ogpe7EaBVj7w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/sysfs: catch commit test ctx alloc failure
Date: Fri,  3 Oct 2025 13:14:54 -0700
Message-Id: <20251003201455.41448-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003201455.41448-1-sj@kernel.org>
References: <20251003201455.41448-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71061180009
X-Rspamd-Server: rspam05
X-Stat-Signature: mmod7qf1yudas759jy46r9w1gwtyc9m6
X-Rspam-User: 
X-HE-Tag: 1759522513-442774
X-HE-Meta: U2FsdGVkX18hYKzvK6EdcN4zARLfBfnIZWyqHQJTxBg9EyK+BFQk4+Z9Q5+GxWZsjBMFxeogecx5gbBvI0yoeF/zHd8WQaBG/4Nl/loN+4M6f7+X+sJol2qOKQIaKtp+py9RCC7jt5GhA6r3ESrFK00sg2shsJgl8uGJczSXvIRECLfPIPY8324yVaTJXZxuC3Mia+ByxVRgmbSDcAJBVae1zsgwa+UKaetySozV5mJg9uIJtE1JgCoOxf83a/cLrVsb9Qc/UzXU+AiCUvEgxxKIVdepnQDL/S1vgZbqAIZ3GgEnCbGwb5Wy8ch5Hv5SYwbEyj67TJ3cgaC41D91oDznQCs96win+n+YKrjB4GplSzA/y0wQj6s6uyrFXOAtNaa5zOyd0dSkQiMpMbCIbRNGiIxoEi72EYDsSy1NjA9sYfIR8mjWB0N2zo6ES5poOFlFYvVz1P+X31C9957V1Zzdaqc7w8yc189/aeP2beq4XIaUf5xHYUY3jLsUsjBbOoYH3Q+2WiMxPnwncx3IZUIVXrk9zReaurgNQv2HxEPlMmodP5mH8p2/OmE93oAm+6U0kq64SlpnpNBK99e0yn2fshTTKHLo63nweIY4gWKCVZaIigPY+EPdVzM6gS7n4cPguVZ4Sl1ZeUmULl8AWWnxlFRKp8kTQd4KeHQFegaU/r5ZcjOZFoDnSPuwH5Y43pTFZNDw+SQ6x9jMKvSc7984BFoGbYOImffgnYDg3gIWKhbNni7WKYQhxy0HMb50VQwUuA6E3uWkYKmVtyCvftqhSOh0Gc0NfrZxZczAu9MpzFh9qHyyENJa8MSKiAMTg8mCsSA+mZqcHHgLDH1qnFsRvecO64e/XqPj/VaGBmvNbyFYzYKHKB7eFGIJIvbqlPhOQ9kw1urkgQVh4NPB/40eyoe6FaFBxZIcd0ij6nSkb5WLg5dD6O7RYXwtc87y1SXhhXziXNhaXWhaN5/
 6DezRXcu
 0RW4u0RK358K7R5g+jAFaSeyHIaX7jzgKUa4vpJwCDXUG9AExh4VDSqcjdShPQOlcmGE/73HfOo5HOa4ku/YWX3+ANujW8VLf8L3DWVyP94zKjo/6AGJaFUDweu8piTpV+tCWsYW7CBtebAP/iixgt1TmWpsN+NW4kqyUr7TKPfSk9Obkin3eu7xYacrvBCWr+7WjM3IfOd17GbT41k2Tt8o/icw+UkwVvdOXRudFtcUaXulj6t8n8+kiwMo5tq/ug1uQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_ctx for testing online DAMON parameters commit inputs is used
without its allocation failure check.  This could result in an invalid
memory access.  Fix it by directly returning an error when the
allocation failed.

Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index a212877ed240..27ebfe016871 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1473,6 +1473,8 @@ static int damon_sysfs_commit_input(void *data)
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
-- 
2.39.5

