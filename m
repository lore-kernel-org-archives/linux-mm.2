Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4C4CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D003C6B0098; Fri,  9 Oct 2026 03:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0996B0099; Fri,  9 Oct 2026 03:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52056B009B; Fri,  9 Oct 2026 03:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5166B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B681C2AC8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:23 +0000 (UTC)
X-FDA: 85302219366.30.5B42502
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 33ABC140006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lf43ZEER;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529942;
	b=d6FOrq9JDl7UFeiOh5Crz8v6mWUTMxBOQncZ7a+O35lujMxPZeU39DlvZJ6ribEzRCImqQ
	ApJ8gNLJvNuSUYnovsFzgx343KsE0Py6Aa+y0HJllv4vTP0C5ACR/E+DgcjBcIAJXEJ4s4
	SFQkh/nPmsq4HDBGJHDTZaDjDbg3ZaM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lf43ZEER;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
	b=pQgp3zsGu5OoziB8VE9cId7lANEx+UvUqgBfmfWMSFJiZt5rWMYTRhGm9xbf6gvlT1Pb7L
	EJP/+jBFgIlMJ6lpjTEwnwEA9bTtljeULMOw1XRjtZvAuozNz0padXkXc+L5L//J7iP8GK
	0Ep9+zMoeDm3yJSBBvwVL01kFXdvJDQ=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e8246b13cbso9428515ad.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529941; x=1792134741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
        b=lf43ZEERqkwbmr+BlpPy9JJQFroaYOxiM/WkvOa07qCJYlJy2N6KV0gLKb3UbW1G1U
         6sPDF0kq9hs0gXf0+u9V9LCAkR1D7UbPChHWBPQbr7PMPbI7t7JCqkUqakvqSMonOpuK
         O+CpsECkrwg89TYxDtwHz33Ux65ARWoCVi6YA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529941; x=1792134741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
        b=t7xN4kXxrywrB9hweIdF08kxI1NmQNtZKPkVhf/3RL8X82r6Uq2uXXke1eIaDK80Xe
         HHsyZ+kuNOEhBxwCcHYYDGOmKNU66ucEHqQavadZV95jPcW/7y58890q6i40KPPPb1JF
         UXm1cWbizvI3N159gUeuBAl4jUBk4MzCHeOm/m3eptVLfAnbblx5fl2rMtzn/TfQOVsg
         CAgkgkEPjWlUNkNbDZsZLyGVQAx92KWhuwfaW3l+O+07OVPt7yUF4Lgmx7pAwe5VgZac
         OwrZG9B3PtBqXOdnAvTLLECr+C5DDpTplR0169Pq8l0zoFORQoDhVfbrRTkzbH/E5hQ2
         8d5Q==
X-Forwarded-Encrypted: i=1; AKwUvBy89cEbSi1J3NN4o2wI51rGyAIqvJw7Q6Nknvy9dIx+5Sjhq1yaL8dEzyj5no/MjjWgh1btnNTDGQ==@kvack.org
X-Gm-Message-State: AFq9FYLEVc0hxzvhVRYu8fUrpZieeA98h4nFiSftPPxEZPNU+L0yqsAV
	BJKEQ4z6epYghuYS4DfFZPvfJ6MmkCB45lnicRRcWrsnWvPo6bTkEbyo0F+Qy41s6g==
X-Gm-Gg: AYBFou0qA5X2A1yyc9+cVrnojjJhUqVYjhHHAuIhpSh4lIEP66VwHtPGCIdAZiXsiyr
	4eCg4Z14qJgA7szgrwO2dzf/RwyUIhBR9lNi7JSxdW3un6x8ShK21yRiGhSQAJIMvpCkYCMM19h
	xIcXiw+jihvCZU7YfSRmy+avGAlkCStKc20uy5PrN71T41reb+KzB0Rh5ZvntZxreTQ/T1jeyAE
	XYsT139lkgp9sTYKtEigkGv+3AKy4TT9pofEKDpRMGcX0kTuDUDQPzEqZmo5wwhajCfhCls3TB+
	9RXlZ7Fp/LypyWEfN1318CadmmeXq4dqeeq8Gd+3ixxZ/0De/mvhfsTJdcK+MFNw7ViHv5ZteQA
	3KcBMw5v7YdDOiR94B1sF9tv5UOW2tSXgPNxhHG5wmNgYDfn95m5kgY/v0SGSLM/C+ofS0Aq1eo
	T/LBXDjipF9Q356k+Eary4Ua43jWxhnW4bTjG+gQCa1JpOewIPqmHDCIYg9INT3nLZ12wjgqSaZ
	LgtUzvWT4d0YG6+YiAOWPVPTP/wq9cS8X8ZVeMUPwrZkENqte/ERXvHgKE1XxY=
X-Received: by 2002:a17:903:1585:b0:2dd:c100:9433 with SMTP id d9443c01a7336-2e842cd0d8dmr9030255ad.49.1791529941146;
        Fri, 09 Oct 2026 00:12:21 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:19 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 03/11] zram: zstd: do not allocate empty C/D-dictionaries
Date: Fri,  9 Oct 2026 16:11:26 +0900
Message-ID: <20261009071157.3730698-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owufsqzb5daimhnmkjexcnhgtqg4comf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33ABC140006
X-HE-Tag: 1791529942-719791
X-HE-Meta: U2FsdGVkX19AOAdT0/rnqOLpdM3HM4iXIe9lZ6SfByJpUM+XGef0PLFio2WtW7jTtxuHsjwiPsnsWSR9GEPK4MOT3AtphE/EuoMl5eAs/+H2LxBj3bl9Lc333MDMxroECDBi776EBbJH1VuwiQ811OnYaF/2GN1afZFAHWk7mIux50D+jij+Uc0UhS0TSARvKozw+98PS1X3X9ao7r2tqP4Wz8WzwJgCwq5EnjwLmdezAvTd8w26PO4FS2jAPOdKpxtTkOMyoN+OEoti0eVk9jn/QCdOxvdEELQVwhzSjwvFSMk/xY3BuD4EWb1LSxj7n/ESYMV4szndZrYkSKH4HW4N1iWkhBItry0hnFIZFE922bKyx35VyzlEvOgh8sAdBOyCQibpgOr2/Ck7lp97ew7TqiPxI/y+y8i1TEpzOJ4XoD8ONlWMAVSYZSI5r0dKlIpVYudehrNcKDoIucHHhsYG9Aq6DER8U+RsSAKJqkMQWWEXAT763ydm1c9N1BcJ0aEhXAnltKiInwb9P5a+eKIQQCDMVAgW+x30OM2EtyZJ2wNVPXBsJBd9EyIULNoIugqCdcNcmM3N1jLNk59qC0xQilNzoSZQP8LLXLlDMaTrSrXzYu9QkLx52VSAC4bbSXxV+Wv6c1lxIBM1RdYa8BNYRU6AxWXMATByXpyd7AmABnwqrGx2yjvfrhA3s3F43NVU0j7wfDQleBPom+wNgFT5zy//cvT7T4rkOLGVAysXhHV3JRxqnxr1doHO+5o6gMq0DmpaG3rUPaQtN7iPAFxYZZYKYuiFRNqXzYUZsYqaacTFQm8I/gSZ15IIiHf2wcgNi8a8YHEcK4h5UuPAGSd2nA7PncrPO0lVOQdz0X8oJDU+MlPWGbB5BEZ8fl35oC3rCw7ju3nyA8b2MpOxRzV4VgrLbEIAUB5O+HzmfavpphplEM+KcPZKxARPPE1L6KJGlF3xzDjDHnBF4RF
 tCUMQQQ5
 XOqddp4r+cixX6DFcN/RqqWYqdgCqf5aetn92zCmxD9UYdGnFsN+KlHHVHSiz7J1eIV+MbxeV2Q3i/PPfnApbHP/Eq3klx2hAsBN1ui9IQAbDnY9GJqOD03YDAMDbtCIE2oNJQM0MGFhbin92VmmC5QcYwRSn7+3LzySH+sgAAPXLhKz/9aYLv0Yg5o50pehLHQObvr+Y8VeV1YVRiScIlpLt6awkTr5HYu2Adf+L/kV9nyYl62DjWpDZpNSI5SDtRAkMe7F2U7iQOAQFo1sm+6KNHtVqQa7i5HmNi19Wcz0KEeUlW822R2xyQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 127976b5455b..b367049f131d 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcomp_params *params)
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
-- 
2.56.0.385.gd3acb90ef8-goog


