Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9664F1077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083BE6B02E8; Wed, 18 Mar 2026 15:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B8F6B02EA; Wed, 18 Mar 2026 15:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAA66B02EB; Wed, 18 Mar 2026 15:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC7D96B02E8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:09:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 902C8138972
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:49 +0000 (UTC)
X-FDA: 84560123298.27.74DF7AC
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7EE8100011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=PGFyI47g;
	spf=pass (imf05.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m0lXHU2lWcqrhkJQ99ARYJjJF2+Qcqk4dCFKUtuKU8M=;
	b=R6yyTvUGshomlHeLiMrWJxqeSx8sNFaUdCUCneGss5ziRi3hsDi5uG/IEioVjT8a/Yrg1v
	zGltQYP0ehOzGOIOeQAHjlDpUh4W9Sz+llTLJT5cpKKeXfyM8WLJ8r7SFTViyZY85eo+/h
	CRkd3HuzhCczu6zjYSKzsnDDf4wQ5oo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860988; a=rsa-sha256;
	cv=none;
	b=VmQ+bBgvtGlfVRHpct2NgiuVG1f7b90SBCroPDo7D8Wzo/YFZ7UfEPgNBan/o3xtQ/rCNg
	8ggA7dy5AxEFmCKGuLmHmLexv2nJ8/1IGwmYqhcYnkhUSghMQNgu2MFtOkyiSXRem2wytY
	p9HtAsR2jHoUfJ2mnsDk+LXQSAy62EU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=PGFyI47g;
	spf=pass (imf05.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m0lXHU2lWcqrhkJQ99ARYJjJF2+Qcqk4dCFKUtuKU8M=; b=PGFyI47ggsVMStJB0225Z9/zCT
	jsrAgwI7gWlppPGrC/7q5UDXcgm6qxgTNim7bit7Co+RdTxblE67sg5cfbAxAdVHZUHowMzMLf9D9
	jvoyLR0mxEuNfhbcGtm37Tp4nDwC2kKAP+JchHVSSzYaTc3wDZbGdnzkmNSjePibu80o266dyRBNV
	rFCsqGZrt+VaKR6ub5zjJPtDnfN4c5Ww7VhsqI4e+Bkf25szCet1HOPlFTvq7S4i4YZUwfkXrHk43
	DgGf4d2GNVidQrAau8OaRqyKvlQM4seYAMCUdmKXQBeuvuh6hBxLO4R5EYNzMEEqnHkxerFSbBo0y
	yRz/U9jg==;
Received: from [179.93.15.111] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w2wH0-002x5O-Ca; Wed, 18 Mar 2026 20:09:42 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 0/2] Small improvements to reserve_mem, 3rd attempt
Date: Wed, 18 Mar 2026 15:56:31 -0300
Message-ID: <20260318190816.1811325-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7EE8100011
X-Stat-Signature: rrd9eanraes6m57ck8q14w6f8utx1eew
X-HE-Tag: 1773860987-751680
X-HE-Meta: U2FsdGVkX1/bRGHAbkQEZz/DZDAYn7+ApJA6TnExvQJ9b91rIKaRuxNpWKX4IzEdaAIlfERsymiix7c/qWjajzRtG1MjotM0E07hwpzOIwt/4rL0YIuDm9PKXlFfCJ0ijk76T/abyxv1QdtsN5hysXYi/4L5XIDO+xpv0ycEluVj9dDuV7hN88ZT43RzpYqyG/Ky8UU+OQfP+9skP/CauOyiVcDwA9PgOkZGRgdOLy8ktqa+3R5AS9eWxBmwy4SBfp5q7qTBLLtkZudjhKsaoxDWgLi/yDLoK47a/sKU0HGgjC/G7ZivcODFF/17xc6sL0vfGkofYGjligw3rDKDTo03vOv762ewnBIn4/X3TdxqUj2Eur5l9umKNHQcBZEoCiaMkXDEgLhump+2+gB7BNvkySjG1qqZXVAXGyi6pVskJ5BkEXAbSyQzZ5p0zGcylcS4CD8UVEDUBvdWiOR8GPLEVkO6m8zQuNvgH5F41kWv9+bqN6Yi87SSVcAzKAQhaHtG01pc2s4+Nxn0twRT5UfEA/NSFHFuPSa+LhkiYp0AuPcw4tOZOc1sau8XUtUUyoDNDv0EKZiTRLeivykenpPiv1r17BIB+oKHYR2buMMzWvAnf01ypp+/xEWxUFIyqHSFcUvE4kcHBaWnpgSv2B5iolfDDLTyB/ZChzGOWfqcYsfv2uTNb5wIxaSP1XJUSbyTkiohUjvILG+dloYW5TmB19eUSY1nXFn5Buo7uN5matSuW/nvhP7t+vRHTmRDcg9T1lifJLzeo3biMTPJEbuSKWSAHoDFEi7RrJOmy//H0ohZjTg9hAVcgu+drtZ2ACO7V5w6+jeIFmL/uuBHvHoNp7FYeRTjDYd25vFakKN7ycnQdbRpVzE0BMQTFLMuyFymCAqgBOCvBfYwnHhPzIYAlAqLDUJl/WsKt58GkopOAeCmPBFln+RyEabuZ6tjhlnMhUab2liwGYyyKrP
 yx38ie9a
 IAMMBwkVvivUOrSfLDv30ppiGzS1eX0xgGTEbw1ShIlPpt4vLn2Afe9rKo06ZFBIpqedIW4tC/941BVRBANx3EKkXWWVsjMO3eNB/b3E51lL9pDT0TGk7gZ22MNEujE744hz3m7Y6EkbLPrwdk75+SlW38lAdUdCcSTbQxmqzdcnqR7LxszKQt3Vtg87lqacHWUC0XEbNDc5Ixh2NESqxpWMuT/MiEUDszh55eKzy1wojvl41t0ndT9Ahngl8ZYBAN3WMpfLtopWXEZaNzUcLENhXMkdbpZv5ZTMX7l6zarvspTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks, this the 3rd iteration of this patchset.

tl; dr: we are adding here error messages in case of failures when
reserve_mem parameter is used, and also a debugfs file to show
successful reservations, with name and size as passed in the cmdline.

More details and history, please take a look at:

V2: lore.kernel.org/r/20260304203300.1414286-2-gpiccoli@igalia.com/
V1: lore.kernel.org/r/20260217195816.861684-1-gpiccoli@igalia.com/

Special thanks to Mike and SJ for the reviews =)
Thanks in advance for suggestions / reviews.
Cheers,

Guilherme G. Piccoli (2):
  mm/memblock: Print out errors on reserve_mem parser
  mm/memblock: Add reserve_mem debugfs info

 mm/memblock.c                                 | 83 +++++++++++++++----
 tools/testing/memblock/linux/string_helpers.h | 10 +++
 2 files changed, 76 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/memblock/linux/string_helpers.h

-- 
2.50.1


