Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C19CA1017
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 16:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8588E0005; Sun,  7 Sep 2025 12:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF7F8E0001; Sun,  7 Sep 2025 12:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC658E0005; Sun,  7 Sep 2025 12:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3128E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 12:08:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9E951A043A
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 16:08:42 +0000 (UTC)
X-FDA: 83862937284.14.5F1F870
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F46B1C0006
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 16:08:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cnhuTERj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chelsyratnawat2001@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=chelsyratnawat2001@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757261321; a=rsa-sha256;
	cv=none;
	b=XipI3aPcqIUg7zwmcG+dICyEbjoLt7RYAGjyClRl9k/IeM1PNrpSF+TiJBMJnDxtyjT4Pk
	HTFhqN8CHpH7bXXNsexPP5m8hUyzHEMwnZUYCyGXMN0gJoocPfgvMSjca5HRB584T5u9O+
	Uv7lZFTghL83DEn7ljRxR7+YLRKpl2U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cnhuTERj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chelsyratnawat2001@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=chelsyratnawat2001@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757261321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yQnuV9+K/RP9Hv9kFvq53N68LodSsoEzjZ/8chvxMGA=;
	b=Zzl/dkgzUaU723nuMHUUs7xZ6h2g5mJy9+IierQTquaxIk6wAUdxPf6yFEOAPeLWGxeKis
	o/reHidIps91eqx2+BqBqMhrjMuhOdBqIIJdrQoWQLwPFGG/oVzA5N3llmVJlm5gC+J0Zt
	7TWvqpwxwOPvKOuwgLeCr2ISSfM25LU=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7e86faa158fso411505585a.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 09:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757261320; x=1757866120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yQnuV9+K/RP9Hv9kFvq53N68LodSsoEzjZ/8chvxMGA=;
        b=cnhuTERjfDKdcR9n0NBovA2Af/6BnhQYctyl3gWCXuHPv6LlTP44i4r+lKHYWjXQop
         T1IAlSCloXg/hegyix+JPsFbrGJ6R9OI1rkmI1Kx5XP+ICYWCO2N/2bwaeC9GZOy2Zk6
         FXZS8uZVKRdETHpHSpsxjNe+ejk48UgnippG70wBRaaadeH/SflaNG5PzluJERzvL0S3
         GMGNZVJm4GoDswEHL3diQRgABM4uNxMdmT5jI+3V4dSg2PEi0uUzSW0/BcSJsgJLtYs8
         atUjAKX/0GhS5JhXrwR6eNqstf9YQ01gwnReCjv7dFmvO+wuWAqyUi+zt9Q+g1b4QmfF
         44GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757261320; x=1757866120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQnuV9+K/RP9Hv9kFvq53N68LodSsoEzjZ/8chvxMGA=;
        b=pIZ3VAWskpU+EIZ5iOdbdzUdSnH8ZmMLyVBL2PgrvjzKXpeRsqnD9swEy+4Y/yXmor
         lpeQciEPDFLRyJ6CfodNTO1tdZC0eBLX6UjASFUi9aEShAXM9SdBRqT05AQA8JQJ4q5Q
         FpNUt4Vjuq/m9Tvo5LUpDRomf5ekAq0AZScc689fN2xUbVmdwiB3a3UywiaEtuReUpW+
         m8QzvN+fzdBoG3hV6jpDoScM3zEmZGXaTAjqsmgmqoA+IhMIOa4vDaUtSn52n2OZbFTO
         uAxpMR0haoO/MM8yj8UCDBxmlHqNKmV15kU9sDl50l/dhSgjqCSXSn98qZ1DfCoWS0aP
         bEog==
X-Forwarded-Encrypted: i=1; AJvYcCU/f8TRHI822rh+MA5LPtmAn5+alE6O4GY7feMdylSFNfaTfYLpe2Hmg+BUVq9VqBKIeVBXcx2Mhw==@kvack.org
X-Gm-Message-State: AOJu0Ywonzt+PyvzQoQtNCosUJSFTXroT/TPJP0kAymjPCLHZckSqerG
	ECxQr43DS5Q9BgF6y2MAA3qEY8CCW5XYjeXmW/+3PAiqZgNnMAaHBbbF
X-Gm-Gg: ASbGnct8Ln/nZV8GKDCrv2dupN/E4r0TM6Kpb2wHzTjJnvKTu7M3DHHi0K94Wzg2puu
	HKcw4BVUiYNYceCNVZIlFM1LrJ1gatBAMk9QlNUGEajawFWj7JXX8gBGcJBOKglaR28oM+Vx0B5
	yQKYIcI7sCTanYXK2/ETlidasmdEmEJ3lKXHwhrtAKUx4t1HzLnJlYizbewD0yMHE3rjU1HWDSs
	XssNgtC4Bh4mjjOjogWniLKrvfngk/S6ovTJj/wR0rIfQvGUIIyL7HOjo10OMGnpRJF3H5yYrO2
	FF+OXRBfgMzKASJVnc76pMC0CZU4LJcEtnvw0E1JNPhf2OyHjEkM9jEl5nRJ9EWI4ssyNpoAEa6
	25nPIBQM6H4q1gexNHwmygaiolnnts5Q7W8xwpntt7WK1b4KRL/Upf+tvCkF35w==
X-Google-Smtp-Source: AGHT+IE8FsLQ2VymIvRsF2ZuIwOTx+4ZDlS+GI/ezuoIX8sR5zhWFIikKuPXylhlABTyXdIpL8IwYw==
X-Received: by 2002:a05:620a:17a7:b0:815:1717:8abe with SMTP id af79cd13be357-81517178f44mr386285385a.19.1757261319849;
        Sun, 07 Sep 2025 09:08:39 -0700 (PDT)
Received: from cr-x-redhat96-client-2.fyre.ibm.com ([129.41.87.1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b48f7838edsm80514721cf.39.2025.09.07.09.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 09:08:39 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	joshua.hahnjy@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com
Cc: rakie.kim@sk.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] mm/mempolicy: prevent the risk of division by 0
Date: Sun,  7 Sep 2025 09:08:29 -0700
Message-ID: <20250907160829.91628-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F46B1C0006
X-Stat-Signature: swq4r4ngtn6zfqbn9rypaihrts5sfd6m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757261320-357806
X-HE-Meta: U2FsdGVkX19VYVARdyVSgrPjK43FmfckB58AK/l9+TeFEh8fp2JIPn2iYLDJH3MTr9yFT1slJ27amVXet5ZOtqQQgFIvJooEfW9OFMAfTYGgtMnx6u0adKLFByBvc0fewr37MCTExk+Tz0/NZnjSQZvXowHWP2p7u++WgEwipgNa5RffSi+b3uTE8i4uV5dQrbGbtaioq12eTdJiKDhRbELF7lQfNbJe37D5Vf3Z3TBoYVQVn5tbNzVkNpnoLZxXQ/JABeSoG6nOKr9nI8xHpjstVA4bW3OTpqN8G63/cZaBDYKl0JW1Hy9qF8XcsJ0XOcWqRXX94ntvYz5P4MK9MLPKB0yNnkp98jqQZeCgBRaCkpjsqEJUf9dlgWWGvm9sJT5raC1vEc3tQKCGUV2V3/eTPHP+n3UIPsPaoso3LHouj1v0d2S6zkKeD0W21w1D3BCdwFzPTVMmUdx4y+ZazeUFok+ZBILmPJ9/5N4YrglPyrmVL2vx0pyQrmD7+o60+Cuzs+6P4TAETScvNgSXSBBMl4YseamPqR6HY3n632VRwwysKHl5N5TQnjwjMHMHqM8fMm+k+6IgfEjnt3tr1hxMLn4qVA8XW1w422ypZXsfEXqRN6eO5arRCnYsXnv6Uh8112EhYBwVxa+zeRJ+at9+7w52jqH8vTNn5Cbs6JoMyGTPvCwxQmhn1bcHPPr69ipPhonuVh7fTDdo0poZ4saGSdLa+ZaiLFZMlCnVCVZZYSRRhJySiQ2Db+Bh2mSz0UV+b4Iytcr+aMXx4b8bu5/RwIAIxhpWY2sjgR4iJDZSQXQlg0HFlzUy0f9axF5vba8HC/Pvo3BsRrAOyBFwdfXGAV7jRVy+msrC9L2ny3ssNJx6D0iB1Eo30Q8XaCEyQ9N2ZLYlXNcDqCH5xZ20jBrP1GtXpSxePFILMtnkfOZMQ1jAMTwJciKGjSsdlHIIccFa0Pwg3/C41zmA6uU
 bzra6UPJ
 e7ZFGhIz2i1hp5qjhIXt5u88QFYEIbfoz+TYbgQ5DDwQFWCDiVgCl1EwRQJylepP9FAc2TGqrFXtv1DMHr1/7/koxuUXl3lZQYK9gzfY2opp3aIqebEelHfzpkQJp0s0vgf36weOScMgQwKcmetWHwdfro7bmleXAjKqzkWtaOoFPfMnS6ZAf2tLXfmslP5qRNkXGHCCgJgs3nS73dyWNGFXN8WQngZfEL5ZhuPHv18K5Nq4J8laaykWAjQNUWwD4mdLPHD3A6HnxDOswDyOqxYC+WYJcTiEqK1yzhPrGpUAyzaFg8g+hw3JQ3MDzDqFMBIwASXsnvUzlJVih45TuWPE5PpIWRC5KdS6cLALf0W12sURRT3+JBAC+Uv88Nt3fjioWJHsTESJIc0fmWAQLqwy6mEjzHtSBwsvJ9u7dGF4s2eWUFc4wsCPDjYaPR4npH+lYeQGeyF9O4tI9bMG1Bf8BS1/CW0/P07xn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If no bits are set in the policy's node mask, then nodes will be 0.
This patch adds a check if nodes == 0 before dividing.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..faacc604fc16 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2530,6 +2530,8 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
 	unsigned long total_allocated = 0;
 
 	nodes = nodes_weight(pol->nodes);
+	if (nodes == 0)
+		return 0;
 	nr_pages_per_node = nr_pages / nodes;
 	delta = nr_pages - nodes * nr_pages_per_node;
 
-- 
2.47.3


