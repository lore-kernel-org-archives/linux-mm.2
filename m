Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425C3606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=icrcJRzK
Received: by kanga.kvack.org (Postfix)
	id B737C6B05B5; Sat, 24 Oct 2026 22:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BDF6B05B6; Sat, 24 Oct 2026 22:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A617A6B05B7; Sat, 24 Oct 2026 22:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEF36B05B5
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:18:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19AD480507
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:53 +0000 (UTC)
X-FDA: 85359540546.18.C5EC6FE
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5193F40002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=icrcJRzK;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbo8DF5QYQnx8DfVRTkAJCVVYmLZodegAu826PeFH2k=;
	b=ZFCJqbIFnjoBb09hLdxMYdrrakHyhlHL5vTu6YNpA3Z44e/QwGjfwF/3bOb4F/2bM6E6CM
	rJH9yCAbR/SVFNr6fenS8znKH1/QdkYGdNJHKlj88CaCl2TNXj42j75qw+Ter7HxXDiAWp
	PBeVXHaZIBh9A3IDJIcHeBwa5oWM6h8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894731;
	b=MLplwURSkWbca4b8iviJezJhw2ckCPPCfGauPDs/lw2LeBjAG4ijKh3Pwz38FarxKDfWkR
	gEnHo8N7X+lClqQ5RcTUJmnM9+WupJyTWRRLdtWy86KzZ7GKSdcio3xLpKnVRGejFr7Ijz
	zFSobnFhF2q/QpqzrDlDL1HrzySzGM0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=icrcJRzK;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36661f953e4so3728167eec.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894730; x=1793499530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hbo8DF5QYQnx8DfVRTkAJCVVYmLZodegAu826PeFH2k=;
        b=icrcJRzKYJLP8F36UueFp05fg1d8T2svmCG6ZOhU8jiLwE39mVrgBaD5stRRfFGFbr
         sEAqFzxhH2vcwiUJokr3czFF4MhPvuSgCmW4ZnAG+FLsaC1OakOI1lEaJuU1Vi8LW0lA
         kN2xrAbufohyHtAyrgXNyUtCcdcbsTF91tM2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894730; x=1793499530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hbo8DF5QYQnx8DfVRTkAJCVVYmLZodegAu826PeFH2k=;
        b=atjbyR2eYp+0AvG5IcgW3Aloic1zyKVVELn1NKJwjtO0i9b05OXx4jnVdxPGO5acoO
         MeFmP8+CJ/yW6buDvYyFrT4JlLlmxu2daRO/9r2ro9B2RU+0ISJWOZdrH0EcOfkYudCb
         Ul4YLksP2iYOuAV1MynlAM/6P03ihpUYOj3mbNhmhkvi4VDpj7FFgseZb622/GgA3V6+
         L3xnX+a/EnC7SvUp2tLEYeqy2FLlKUY9jOOkYdqa92j/pFLswBP57/cQed9nDVb7pSfI
         5xdD0Jm6ZHkxjKZHE+NJt1RWAdgEhwmeJ13/MXY1QN/XqCLakwc8Nr1r+rnHLVvs0sO8
         ch3A==
X-Forwarded-Encrypted: i=1; AKwUvBxCoXIsdmqThuxZlHOs8+UvJqjsX6xdY4ooSi53REABVahDtdKSh/vWLcKR4ucdj5ZCCZXxGAscIw==@kvack.org
X-Gm-Message-State: AFq9FYIr2AzN2Dc0jyPboWS0D6bqU6aQgkKgT5aTr9u6kMfwsfbBn4FC
	C75lTR3OV8AnNBGd93lnwB3JM8oo8HlaU/cDdTrpL3Tz1UpYw5E6SdSrQzT6uWwoYQ==
X-Gm-Gg: AYBFou0Wu2cdAiYOuZP8ZLP518PQO7ANnhvXAEfOCaYIXZJJ3mUJX5cWbTk0Ap5WuzL
	YWaxyQxoQ1FTh/dTH3wrIlUd+ViY0tvN3NKqYmsm99gVxbz4HtzqgEQ8d9QB/G7lfPkNLWYrB9r
	WjcyN0UFSto2QZyIH59vnaAcJjDeoAqv3m4f3Lqbzo9621SQGVmUlGHvR+NMzZTNg/tGwt702wf
	I/t7WnGXrJ22/Rgh+6HZTNyVLsYUA1uqGxadKaTxfBhiNz5thFqES1EtllpFz/E1JlPyaGJmtkF
	0uUeVYI9l1YGYLnMfTHMi5reJrdT1p5y/ZyDDo0ie05DAyZo1RPlQ+nLZ87oyitCtMo6NA3jBAU
	v+C8gwqRdlbCjD4gh1iIyMP3g/3PoyVLjII2KV6WbCGapbz7MFaWjJ/R4WLeTmOiDZNbl47auwd
	Z2pd1mghtuWoukzwCOUlBaCfAhq4jmrgl5tuRazBMNfWazI6bhEjCAIOnsqxiFxp43BmkFqgflv
	NgS0XCHjzECY0DDSk5ZIN4P2qIlJO6eKtgGH2qUtTbmRZ0a7LLU/c4CB5fwD6hQHGpF+OxfUETx
	sRFiNHh6nTT2YrgbkwX+4hh5F913QEiyNGnr9oFOJOvlpFQ0h4sEfZBBVeVdEc6sIbxu6IXUU47
	mlsvD5hXs5mGDKKjqjg==
X-Received: by 2002:a05:7022:3b8b:b0:169:9f67:a91b with SMTP id a92af1059eb24-1993505df87mr5872389c88.12.1792894729886;
        Sat, 24 Oct 2026 19:18:49 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:49 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 02/15] zram: remove debugfs entry on init failure
Date: Sun, 25 Oct 2026 11:18:18 +0900
Message-ID: <20261025021839.1542805-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5193F40002
X-Stat-Signature: o7ekux13by84gmdm37tryges6ioc3rcw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894731-973076
X-HE-Meta: U2FsdGVkX18V+A2WY3kV5kmZtoBMpweKNOtcZs4eJfNf9jTCsaUnZRbceXaIfeZ/ne/Cv0vPISDthrnZXtCMY5acLNt1sPK0p+a1u2sim2sRPnhTTSsGpRJx0nMO2IRuGPzMD67N0d8SHRsx2E8+7UppZsXTu3uLGGo+gy5Yzm3heLDjcF/NW9cipgMCDr9b3sES0SVzfzVzX2uXyF650SfoqPZOFjphzjVitH6CSCgld4yTIy711AJkCD9M3Qb4RYEF4JK8MS1uLDeITkKI710JZnSWyny/z1OIp7gxu6AAjP1QK/MDIxNsUsYf/DhVB/7KDssK2ak+skRg6tm5IzzHed6b+XdGImVa5yUrVXUlOG86tgYucYNDGK7j4qOALN752dy2Qsz3vYnsCEi50a4hMv6dOu6Eucms8+Jqv/GQfFBASJFVo54oujidoOY4XGYqlrztHZDNJQpFjx29C+rFEDfdF/g7k/aYtuDNNKHGelSQyCgY6kW9Zj1q4WzgGZk0ocLh6kEwYwH/l8pTxhYs8cBDBvH/9m6RYW8m2Z2jvTM3yG/89B7qY5YEJSUSWNZ8CLg+vrmjnnBZEdL7S8zhegMrhLXh/QymuMRESC2yOP8y0GsseZILdmXdXYFb9WVNFMLBB+boXGogzK4TXTVQsH8z2KF8PhcIarhXYtUqe8T+96mtx7sGNxndCydpAKOIvsKgBIRWQze5krTrkA4LnCmVF9No0RdniAuhWzzmdHY16yL6+7ebzZHnJCEhfuajuDvTsfQmoS3kc/2AcYMWSoIVo1Ri6Ql164NEmwGmQgA35iL/PuwxfvRhH+/OzHGi6cxKpKAu/JYV0TbmO9nBNSr/ogtwL8Y2NYz5J4hRBiXKI+SzWqR50tSbwNsAuNbRPTmCkV6brf+RquauWDcXTMfXPHto9rch3zW0jNEY8pXZEkgaWSF1rmgWbB2RbXCz401c13zVrdgnGDD
 h+z3WvLv
 bfn597C8Lqfn7bGXkA/H+bVc45ZrVlf51amEtnLoEJQx+Z+ELDo5oIeYJVeyRZaYuLYqBwTjJhTU8jUb2ZynBNdB1ES/xN7M73hDId3awGP6YFaRq9BABGEeus/5neA11Hh3wJj/8Y6972UfFj0gl2fuY+XTN47DpjpiaZMJDSbgA3swIAcgWUnTWsMDn2xzgPPvdPGYn6zCHheAmva4LZ5xvsOWk0CI2ziEaCaU5ZxvzKYG6HZ0nfl+3OizDefw3F100juFNDikld6UXIH+J9BN7Q4IS51FIkkXhmBMQgDH6A2TT7pl1TmDR9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.257.gf7497c7d27-goog


