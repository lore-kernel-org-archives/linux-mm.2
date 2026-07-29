Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C10C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C8F6B0099; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912846B009B; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F91D6B009D; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 564546B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E475AC053E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
X-FDA: 85040405688.10.D767592
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4076E20006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZVIomhI;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69vkU0D1ZC9y76VW8fWIr/5QR0D00VAs0a00zXjnW44=;
	b=04Zfilcx3DGg4wu3ZHKVUM9uRQZC/98o5EFJgVUc+q22GkHmdD/JBd5F9WEbaZKptXkCfM
	PiFYgTdxcHz+Eq8tBzLXo51Pku3S/nXfT80IZe205+TeD1j2AKaOHwG9S+nFTDuzSoy6Js
	V/1mP/gcN+DAS4tqCYMfkc/qPQ4OFAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296283;
	b=S2iJ/BOnzXGB+7yZoQCO4vQMO0ZzNlv2OpFhSNAAVD+AS6tO7kuALPuwZ9ZHVJ5Qm61Hob
	ZS5ATgOe/OSb/GvIIZHAG5QufssEMJn7UAmQQ9A9476qYhgrVstilhhRihkm1bPCKR2PCW
	MQBtBmIDNC7xfYNVo5wTQ2SMORPFRg4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZVIomhI;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90F0E4513A;
	Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDCE1F00A3D;
	Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296282;
	bh=69vkU0D1ZC9y76VW8fWIr/5QR0D00VAs0a00zXjnW44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZVIomhIx28YByczLCcoBJuIx77Q1yWQW28Mr6/2Srm20YVkegBgwBDYvl/o+6GIl
	 dbVbsP3hJwWvtAIyWY1uX6LHDVbittDBU8T6rAWrsc0e8a7tI+H4beeY7dP/CvZ0r0
	 80PsuAC/6xdG0+PM2IS8SK/dNO2/bD9FSIKZJdtihjY8dnk58hPTG+tdWO/dXw2A+W
	 wRGCgHNv+IeBzxldJgX7ifzCUfMNBJmH15otApafk0UfQAXTSCUBx44MuQrszARrjj
	 1BF5eB+vYxbPw1GjrWm8T8tI1hBVHCDNV5KpfKvkqIvIFyOJZgZg1X2Cg1i8fsKr8R
	 8TcLiPZOnVSjg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/10] mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
Date: Tue, 28 Jul 2026 20:37:46 -0700
Message-ID: <20260729033751.131213-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4076E20006
X-Stat-Signature: pds93cj977zxmp8ckren9yff95qapp9q
X-HE-Tag: 1785296283-911932
X-HE-Meta: U2FsdGVkX187EoTTIto1iw64j/VhXmwLT3CG5JrRTmpD27Pv8SS1qOkg1iW0F/LHS5LJ2S2xy+50P7V0j4QHzMN6S8u2hrQHJQOnCLcn6jdzdMgOebAKMrgxsn6qQiGDdeWRKlAFQIwE+1JS9GoQVoBE1DB8NHkfXPKGXgyf4xAt9+ofFJtz5IKaysa9oJyPQ2PsQsVYDYmygRv9FiRTIaVAwkjlXBOpi68W53dJKOFuWB3SfpJCK1Yz1MyYTBN0+R/n50hn4d/u2LSPwT5dGVsx/8PE3WaJmwMDqRpXCwH3Mt+zVpYyI/mdq/0+ktV0ogAhRoSX1xivkztcAVDeE89oNzx9cczxoqsX31Orz9/nWauOf1CfI3JH1nHtNIJlLWUFYY4+Nb3G1q70niybSVQm+DwSuGaH9Gdh6+xT+AkEaQurEb7QAoso3SOqxMS78CuiMZGHspzOUJXbZ9yI95MwDi1n6cX55Hla3IRSUc5spFBA7VUj8cNqGpLVpt5jw3uvofO0QUASsFpvyoZNEwjNXHDNpnrdTu9voHirkTRC+HkN9JLNBNJlpF7AhdduM6wkGII/MfUCRdsLuzjvxH7oMTlw5qtNgYTepS3G/tcQgd6IYJpsVOEf8TjSF152PC6rv8jvsxBWiqj/+RCLEQCT2XIE1hBwv0bcsyPzRefaqB0mQ9wejrPpi2ZlhhTVIAajgkw8pQMmJ0nt60K4W9Kml/+iWIsaold4yms5NucRmLHaYE0OUfBd25tURhuT7LsFKOc6ahpqfKIl7+mG9WeMAoCxPTYz7UQ51sGjoQCA9UGvdeK5lfySSDRzAQHbopE6dAWuUYlpLb1OQrjX6ip2Ic7ADAbvrpC/e7hwV6Wm94+A2cGz29ZA3mfp0/ZCguiW6AVCSBOlwiIkGqj03Qz6akS27Bxpnja4O2xPwvJ/usyCboLkAVQcFGCMmVGIZ7sNCBB5QrkYw0ig9DD
 NiFHFyI1
 UjClDhxkjWDLAdJxKLIt8wCfSkpicH+rDH2u/8hXzKaCGNHVnr6UYo/19hHIv7RqbzVoNxwRS66LxisnND9JpI5ppqsUgpZiiQeR2st9oxIvciL96jhjY/wP+ib4qfadp6OF14mV1tN3safCj91Pv+Im7hHKNJqErRNFZwUnaN4ZCNRlE159OjUAzcUpEE9QrkytNV2Z7qKQwDxQyJZUzjJxIVVB8otPspTbCb34R2M5+fM1D/uqb0uTTAfjdsoXWSm26ADn9+zDn+u5pRdaxyeUktQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 954157679ec3 ("mm/damon/core: disallow overlapping input ranges
for damon_set_regions()") disallowed passing overlapping input ranges to
damon_set_regions().  Add a kunit test case for the overlapping input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ac15393a7935b..3041b8288ec26 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -606,6 +606,17 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 42, .end = 21},
 			}, 1, 1,
 			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/*
+	 * Regions resulting in same region after alingment should return
+	 * -EINVAL.
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 10, .end = 20},
+			{.start = 20, .end = 30},
+			}, 2, 4096,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

