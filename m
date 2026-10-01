Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8D0CA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0ED6B0092; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA236B0093; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEEC6B0095; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F03E26B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 799641A0278
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:47 +0000 (UTC)
X-FDA: 85272244974.28.0159480
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id B591EC0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G+k/yU4W";
	spf=pass (imf10.hostedemail.com: domain of 3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTQtDRZE6hbaSqiCeRYm1Tiy2pek4MhmDBkS+QhXVW0=;
	b=nuhKy9wAKXBh3cWv2QOtCKemEt1ao0LRHo1q91Xsi/LnH4AxxGZwEQk85ntHBcNige0yDo
	kO2A4ejaQWnF96x16Xwar5zlRQ4hm9T/bEFEgC+vu4eC4sLEPZnl7kzJkIg7zjIyNLyNl7
	91Y5lf4xQ8Jw7cTczGSbDY7uP49fpIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816265;
	b=vnmtFtsXM2r8zFiaUNBRTZ15TUhf0md+3hEAvUGKF3x//Zvie2aztHarLBhiPWfVXdas95
	KPJmuebKtpzLgYzq4O86PWQUfZ05slanW5XrXqJzVHsuYmVT7uQYF4Bqo1ImQ/hXsHUEZt
	fJggrkC4piZhGK1fKy1N7HuxRC5fp/o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G+k/yU4W";
	spf=pass (imf10.hostedemail.com: domain of 3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d9057fab9eso62800055ad.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816264; x=1791421064; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YTQtDRZE6hbaSqiCeRYm1Tiy2pek4MhmDBkS+QhXVW0=;
        b=G+k/yU4W0U0Y7/AWraOl8opRRH8BuE/WEgfUylvLp9ZS17bPyXD7ZUmrysP67C/Vjv
         jcAON8bng5uddIanWVsVKSden3XPGCCjSsH8BFKjAEqnJUdmrczeIU6KIKydhl8t6Av+
         7Wi0Y61qCGTRUZhlIjvgdctHA3CpIG0oUU4/qUFf9qQTb+dvaZqzoNzXtYykhWVEBtw9
         t7Fbk/VwU/h32+uvXOjD/CMjUZSVTR1STHm4xyHZx4ECrpWLEu1xR0whDYDX7Ga/3VII
         sJn0PryfRrIK32OVc+BFP3RnF2o4pcF6p87M9doXIyfUMdjLozMQW1eL0NQiA9wVcBwk
         6p8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816264; x=1791421064;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YTQtDRZE6hbaSqiCeRYm1Tiy2pek4MhmDBkS+QhXVW0=;
        b=NaQ0NlAqms8yyMssyJrck+HMa2oqQW3KouQQ5CQDlc3YOIbpMoKBbmZH7TwoxjO2LK
         1ejZTLCNagsMc02smpXFVsRb3RtWbkEDOyG/ZMHwCZZ+IivQE6+jlf7JqFNsFhw2riBy
         oVHENHMA8WkNFHr/KpxeG2bxKpdTXJ9yL9z65Ry5DWUe3pXEbfvPFHxrGKifO0kwmUwf
         JujyejFkSXqG3iqWo5YpxwfZBbGbzZe1BvbekIBje6/HFIm2zX3U+dWapdFXzxL5AlmZ
         wQf4SeIuyaeiyKP742/UCPa93jLUBDIoDEbHW5dUdTU/DwZMm2J8mT5c+Tnpl6rQMS8R
         y/iQ==
X-Forwarded-Encrypted: i=1; AKwUvByRZ0wlcMldw5B7zPDCrZCcFsw/NT0uHrqD8AftWMh314i2Xuud8kJmRCG89Kz3oVT355b9FNUr8A==@kvack.org
X-Gm-Message-State: AFq9FYLQ8uQEQJwwW8xLaAalqXjf9ID7HftAggxahiFYBGOJlHi/srtF
	K2sFmDyzZgaxPodOeL7tIAOH5Fu/pv9BhEBj6d577IVNlZ1CjQ1wfb0EMXrZFTdQrH35Kb4l6qG
	wKY3nahchFe2PWQ==
X-Received: from plsm24.prod.google.com ([2002:a17:902:bb98:b0:2e2:dfc9:4865])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3bcc:b0:2e3:110:b71a with SMTP id d9443c01a7336-2e30110bc9cmr8262235ad.0.1790816264188;
 Wed, 30 Sep 2026 17:57:44 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:32 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-5-skhawaja@google.com>
Subject: [RFC PATCH 4/6] vfio/pci: Set live update file handler level
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B591EC0002
X-Stat-Signature: ymzweazk1o1z9wmq65xr48pncpbe8xwx
X-HE-Tag: 1790816265-816179
X-HE-Meta: U2FsdGVkX18uU2JLVRQaWyxlxz/UGkrLQTx5Op7DiTbIM0lwe7se0KO3+0LKX4570swQogGSMJkeo9o15G78wKY8AsK2f7qNnEPWucs1ms54iJ4KqZn2ebyr0GG24o+8LBxKq/m2RO3Qg3CB5rwYho6su9MfPqNfX5mfJfpcaobshog/vacc1nWflfXdxxVoHVPUgm8y4mrCBYOTXWYoH/KpvDAjQcv8HwoVNkDJeHP9BZpDPnAnKl72DT0e30+tXEXtw/SbQr6vilB85UjgplUTaMSMXnwiH7Mrl7NsRA16tFKLKDUJwYpHoH6LbSHclbRHJWJMXyr5csH01hlx4QDm1meNDvwhXp6P5CB5OKuB6zyvJNGSDCdls7GN7T3JKfUU7uqV9BIPaocrWz8qGgdH8+0l3KzXEpfq8ny/D4bFFZyyeDwZWjLzqk9jOFoOVRQv/HzuGb+K3sT2ZIompGPgsbV7CBtYbdGx5qxRjWSbqLi3yHNpSLoF+lRZHCVU9UxfUq9Bu6C5lKd7YTz1FrM/tMPZQ2xXaBJg7fUA7eEbyRdaaHPt9u5myjQVAcKBUfd9rJfV2sIet83J6q7lvAD1xJT6yb5gACvo7vT6oVt9khAC15qq3e7EzfXfQa76+1MId/tR6j4T22TqKbg8r+yD2yzk2k1MwDtrU18UfCcf8lx6iSgRgg6D2EItDfoadDKo2YufCczoG/aMsxrTAJHEHAa8CcZi851tMLuduR0GXh0zdahEnqBfVt8zUirWOhYgTyhRLbdzeKBPmAUkQQF5W85NUmHFx3lnL5/Aje1bREqVq9cWNAle5LrZFiBgxjl6vj6lZgvByKkgRlJOyJ3HHjLuanEuv+GM5O3hKyrA9ASeuXvi1ikp22zd86xN2BsZq5eT5YOfDbZTP4IJjqsAI0wQJ2VXNgs7pg5Rou0IftdtwyO9UrXlVieOC+kTeIew2wpXHjcFBfcCjQz
 rIgxYmRF
 Y4f1NlpZC5nBZS/vCiJRJ4l3Soccuom8ia8R0ocf2q/NZYh3l4nksuaBKPXYvaCYdf7e2Q1mKUky6XnXRscZVQ+wwAo1hoqUyA453+JL0XAU8n4jKf7I6u9l4IdY9wuA3WqFc/3ylZ7XowxnJHhXzB5vGZhQNapfRTWe10/GAvy7y4rfEqOFXEhj3Q98bpW+OjYygNu29OedtLo7HMD6Rur/ian2onP5BgDrgWpY/SAleTkHqBa9yo6tPRuQkumxs5of15Q86Cxsb4As9L4r1KjstE3UdCGXo6QYh58o3OXOfDjChfDJyBjWDDeC6rlcjZfLM6/xv6uff+RfeW+3mv5mzTh6aSIFx2NHNfZKGrF+XhaW78715Xtl6MTc73ia5nrut7+e0fxqs/RuMQQRHRbyThaUTVhGpFnw70RI4m2JEubDBOfnyvxRk1qNgb7vG42NLSyX1wE8yZbC7DngFLBJDTPoo0KXAAhChuXuEZMs33rGRTfTEgCt7+6BOUaxlRUXrJ0eQ6tOjtXSXSD1pCuYvSyAJKhm6SBhvBLZVXngm/fuwRLYYJQVh2LXQWZNmjzTnp3V7y29/dImv6BmMWSoOEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set live update file handler to LIVEUPDATE_LEVEL_DEVICE.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index fb2141ee8942..4b8a350b867a 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -335,6 +335,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
 	.ops = &vfio_pci_liveupdate_file_ops,
 	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
+	.level = LIVEUPDATE_LEVEL_DEVICE,
 };
 
 int __init vfio_pci_liveupdate_init(void)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


