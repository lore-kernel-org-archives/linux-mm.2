Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260A3D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776A26B009D; Mon,  1 Dec 2025 04:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663A56B009E; Mon,  1 Dec 2025 04:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B326B009F; Mon,  1 Dec 2025 04:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28A226B009D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2452C073D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:26 +0000 (UTC)
X-FDA: 84170427012.07.8ECE250
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A407140002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WVQdsDcO;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D55crJZWYW5y22wme+Q0xHtiGm3WaMjTuTpUN/z/uDQ=;
	b=OQSgkfsCJWuMk/hRTtgxqw/p29sZGN7nn7FZJEuCYAg22duwQfUh/WyLGEK4+kPfcn9bHP
	ETEMZgteHnD/JU5cOF/j1c/gVwSXjzBRs0VtO5NoZpSwKaBCKFtOYwLFjBRSBNbHnPQfu7
	hz0/ZCSM9K2xtkHrYiBqZXnppRc2J1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582505; a=rsa-sha256;
	cv=none;
	b=CAi39hiYGOmV0p0+LEpkP4X39jidQu9ToVEkIBT6wj6EXNrQJDCHpZi7VCUTrZuvpt64PN
	J9K7VECZd1Xvg3M34Vuwiq2SdBQPI9BUZV/IND4cMW4so/KjOFZTcgy729rpc39pFv1LIT
	IDU84XoAqFZ7NfXLiyzXlVlQavt8DCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WVQdsDcO;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7ba55660769so3286627b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582504; x=1765187304; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D55crJZWYW5y22wme+Q0xHtiGm3WaMjTuTpUN/z/uDQ=;
        b=WVQdsDcOHtQ9Vb4+yYz9QH7b9DdiEsAcwPMDIebiRsTdHnUaWG/RlOBPr5ZNrlXj/e
         lCCkWQdTrpbVe6N6/3mVsuq6c7xl9BlE5rQs1PeUCAUeajL9YM162Qej8hUGhs6dEBXJ
         QptQxqRJVsnWkRE9CTrGfNIqoC+I52qeDvMRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582504; x=1765187304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D55crJZWYW5y22wme+Q0xHtiGm3WaMjTuTpUN/z/uDQ=;
        b=wglAtXWSpo36zVCRH7zGD2DEPjcA8nkpjyYqfRJ4QQXCCJsV1VJ7gMsLUwCA4lpIv6
         8hKhmcNuECXW5VyZuKtdDbVG//aEjSh/8//7bj7EMpwu3XPzciai9/KT10KEx0rV7l1u
         cCZBrbieAtG36r/5g3zOIu/AGGtUWiIHMAgudSrIRUWwi5YrWMK81thIefWdPraTOjpD
         fuMW4W3zwOu7F3Dtqgy8t/JBvyGP6Y0bJ5BdShBeBDoJQGuT+hqSZGjD/L/dCMy9q8x/
         U8CE0emiEiPdex11gzv3VgYBdKM3D8lZ2TEV21Z+bZxdgiPi4a2AOQEdqrqM8m4N39mP
         GAWw==
X-Forwarded-Encrypted: i=1; AJvYcCVpoM5Ed6RcftNHa/bGsyVw9Me5D6zXH+lSWw7p6e2tYpv339Y0nM3SfOokK9zmIaMRtcxx+w8+Yw==@kvack.org
X-Gm-Message-State: AOJu0YwK1dVcvSami/1Q6nJV/yoeixrrjieEqJwYcOfZZBd7Y/aAzHxx
	AwJ/A1qZnKo8tniVJFsoYybMtntShy1b+4FppuWpPOq0EHMCtBw/FhpC11dz9dSseg==
X-Gm-Gg: ASbGncu/TBqZ+GTd6+Y5HTo2PFU+admvwSjHtbAeevuKUqyzrMsX6oEdB1lAMsHg27L
	6FCTn82gQFohrUKOHUzOMWZtxLMCiQdXb9qObUAlR0V+t73+4F+ihCpS3MwVxV+dn7hhPmduuDl
	ff7ISyyuYK1w8e3CSDNx4IC6JH+4TRajDynw8xQL79Aj3CvxQ3pOC4wX+b39xelf8VXZvWpCCNz
	D6qpfFtG/bTioOSPHNVL9FWg9dE/aXwYwyc5WBNB6Y4H3oUw2X9iz1D9zMlvqGJ8tAx563x++tS
	OlHzafwy2COq6NUD7nS9GKr9z6WWHSieFz3PqkKDfk5O5EIfQxHJc9NuAa3Xbe6YYXZ8NxKDL4x
	p+uo18u0y4dlyI1aRyhzt7gxv/r2fHt9CXazyQ/M1pzeacyRzcVZbgMRq1ewqs17ALaxksziL71
	UjkysIwmWficCxbu9l+bbDHfcnqLE0uAs1T1cY9ou6lRlt9i1yoCIfjoIlJFJElusu7VYKHkesp
	A==
X-Google-Smtp-Source: AGHT+IEl7N/dM1tmzBzSc8w5jctWzUot+nqnpPOQiY3QXNdxfFy7u3OLp9wLsDD2vN5+NSzPEqYx5A==
X-Received: by 2002:a05:6a00:8d6:b0:7ab:e844:1e76 with SMTP id d2e1a72fcca58-7c58c2b20b5mr34419865b3a.5.1764582504112;
        Mon, 01 Dec 2025 01:48:24 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:23 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 7/7] zram: consolidate device-attr declarations
Date: Mon,  1 Dec 2025 18:47:54 +0900
Message-ID: <20251201094754.4149975-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A407140002
X-Stat-Signature: jhbdesut1hskeunitisjtqe94ddx4d3y
X-HE-Tag: 1764582504-291502
X-HE-Meta: U2FsdGVkX19B6BqP1kCrseclzBXF3klJURgiPLqum83k6UTkgxVhV96Y+4hNhhSQ72PngAV2jAxZHtAKbXu2MOioCgf5Nre+JictJIdqZTpXsoPcxBo23V4VUmv/zjz55Q7dm6+6ujVxJL/AP5RXnNv9/ojAXgn985DflZCWJRIeMKc4eINtUdnLDEBjBFi4ocbatRRw2Ex3syrL8p8s4BIJWhJFQGZP56aUJRDG+5Rx2ITPLLAdKt6mYzkbuWJno4RjPgr+XQVozRM14IZhU72hBuhYDPqFDvIVCtNcPmFIgmQE+J5YxF3FT9quG39zPnXDgoN9gZwoWlDtOG4F04ayCXSO8uB0yCTzaUm++lKO6qLWI1vXMjWEEzX/HjDrqSeFD+q/0OvxDAEtU2aEYsZ1tf2YqLjfU3ZfJNBSzTT9sI+hZbPFIgbrXvsubYY06SVMR933/VR9coYO/LWlCrewpTvU7S1ZkQkwoJIhjUIlzI7K1lf0G+iM/X+eWYsoJWs3xALrE+oSBmDYcZsaXSWerpnMoE8XQNlpkLs8iq0Pe6aJ7LImlydT1DsYwQlgCROS7VAkDQFdI7QOV3mEWfx6PZ8rTjTnvNN94AYY8CklcpUMEIWbIdecUZ46NDIooHm4XcSim7TEOCcwQEvKNKz2kJ61px/O6H44zfxAx/rAlXTtrsUOgCJ9nbPU1DRz7MaemqAISgcP0EqTP4xxvmKdF6d3agEQDhBdFiS5EbLviVoJlwMH45cVsRUF7hwMet9ildxIjxp2GSvQ/sdadDWkjdgo4E4QfkleIsFArAv1KkD56RKf3WhQUGs1UNLApN4eFZE1O2Rrb/A/xICiZMhy4rH7uapxH0JbTaUrXn6+rNU+w8GwGseTx/MLTJL0uFtXz2aL7i5qzXrT/8VApqWIWMwaqME3RHb1cGjtkN7fGF27bYrwrNa1xjJB5DYaKZX5VkBs1lx+smFXPb0
 sSHcGMe4
 ri08XzCtUXTYKjvhQuY9qqvi+4esbuFWQawpK9ljm/ErVJcpy+fgo/B3Gb0G8zetdWjcqfgrDPgUrVgjP1ZUdgqTzBrE7CjTOHfA0N1zgMUMrld3BtcBm4utIBZNlB4dQN+ZfRCKmtFXaJvxg5OHRKdpEMn/Pkk6ijz9fnKAL0/JG+j84mK3gA3UHeQC+x989vuKb8X7Bcrz3krzSWjDTEoo4et9B575qhWpgo+VCmPY0phPF8VhqruJjkZqc76cG9E1kmOf8HWb9M31TK4yK/K/VcHVJOBXsxYbQHhmGvdZHgShKbh9UKGXmbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not spread device attributes declarations across
the file, move io_stat, mm_stat, debug_stat to a common
device-attr section.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4b8a26c60539..67a9e7c005c3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1966,10 +1966,6 @@ static ssize_t debug_stat_show(struct device *dev,
 	return ret;
 }
 
-static DEVICE_ATTR_RO(io_stat);
-static DEVICE_ATTR_RO(mm_stat);
-static DEVICE_ATTR_RO(debug_stat);
-
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -3008,6 +3004,9 @@ static const struct block_device_operations zram_devops = {
 	.owner = THIS_MODULE
 };
 
+static DEVICE_ATTR_RO(io_stat);
+static DEVICE_ATTR_RO(mm_stat);
+static DEVICE_ATTR_RO(debug_stat);
 static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
-- 
2.52.0.487.g5c8c507ade-goog


