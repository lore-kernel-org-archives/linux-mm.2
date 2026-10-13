Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990A5CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19516B0096; Mon, 12 Oct 2026 23:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2A56B0098; Mon, 12 Oct 2026 23:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8B66B0099; Mon, 12 Oct 2026 23:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75F386B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DD4E160A8D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:21 +0000 (UTC)
X-FDA: 85316230482.13.63DD0EE
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3E7EF20005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LaLbaEEo;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
	b=qDtPeYmcO5oSOcr53y3UW9hqJxcty2RpHH6hwMiYHOFSbbCzOg5BmP++4w9LaTY6Sn09E+
	pJkJlErutoVoG8hkKbz7usdJATBLBLYWRHcYh/o1/GzZeEOyPL48Pn0QYBa2BPVLjoC4D+
	QGDxICmsART9Xqj6o+r4Uv1y1DkqENo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863539;
	b=YovxAmHr1c6gvDp6jDI4EIbxYrUHDxqH1x99vMFxUfahJcQjujTobQ88XbeDstUaVQeM4I
	7uulPSuff4j5dmiqsQC+Q+veR9hg2EHQOJPU0riHektVe15lwKfN7QTc614RbtJnC6jO2A
	90YpCQ5KGZB5ktsYPF2kY7etFSdBeuo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LaLbaEEo;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8917c712f32so1039528b3a.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863538; x=1792468338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
        b=LaLbaEEoQ9F4BJbMfSs9GnInJ6x8tNubvWQtbBt52n1HhHIMkF6xyNSJ/TkOA3b3bW
         pBhWf90nWB6Ili2voKOVOsYSb4b4FUpGXohNwKZrnpMLO32Op81+gsxDbH0eIUNFjlko
         TBAn29zZ/v5w2LoTnDCOtrVMyOFu375JsQRhk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863538; x=1792468338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bA1flR9Lu8v82O37oxNarBOltKmvw8qroUoydC4mNOA=;
        b=PHLFweoIndAFlVWZyLtDG1p/7MoEo70inmR2Z+PP1nW+m0gopm2sEDvLeRrM/bC97b
         ctpain+oPLeCVr8lKW2YiVm3+FsygPGyHI3EdySL3Tyk7VgSXLoP22L1uCYhkz4XmgfT
         APEv+vMDcnKo+hQt8ezYHtmadZdfbXmjeIqn398LvUmUZ+Dj0zFqzQiqfzXjiavyAIAi
         rqBWPCYbBgAH1519Pe2n6xJKe5p5TeK6ZBXktCImQVGwzdvsvYEBhcXdjH8I8jKPOlzv
         j8w3SULJpYEg4Hq+Kfps4C1H8jOqY+HYff8db4HEJ8iOd4xXAEq1yQbnp6qXsNMIggux
         k9vw==
X-Forwarded-Encrypted: i=1; AKwUvBzlKEApKiw0WpVeS5bZ47zkct1hfCHwbk7yU2IlN4cCynPLN8tdfrrEYg61y/f5ux3N2Pd7+qXeFw==@kvack.org
X-Gm-Message-State: AFq9FYLij9//ukGhq8J6sJEzO1FoEjXn7XB7kX+3jFs+eq9dcLwAXf1s
	fv0BCHuWISHMfICeOeyGWfPvUCjCMCWOFOZ/VefDF1H/45vFl1yWtu8K9hy8D05DUA==
X-Gm-Gg: AYBFou11BhKk0sF0P78CI1jRbU6JCbfNsl4r5szej0vyxMYnFWHVlvJFqH4j9MphZxg
	2zKAGRHD9lobnFrvqPWrEvIjQsmwnvJtoGol0sYpEWOnqdp+R5Mg1WV4ytkKzzFP4O8dBNvpXQV
	Ec3Veps80v8CwdFpynOge4m5C4rNxHR3CvasKssK1sdHQix5anoDJuZhMqL1OOpUICaOag4cEbX
	aPgIYG8okvNimN4vP93biosYmwXVNy/JVdxk1BPYE7RJnfiIfVXvU2z/XdY5Iedy1BvXe+1J4Og
	Hy73bQ2wJsx4FmRSlLtEq8Dd5S7XODfs4fdNGmV/nE4vJ6H4V19zDOIfggFouw6i3jwEl7Paze3
	o3DvFVUKSZsyQnGg7dE/HZS3xYb40Dng9Z7PCKQDNiBJ/c4YYJhy4PQUWKQ9vkJj294MqKOM6vO
	qdHB1Dm71ovJrO4adz3fk7rpNRZDXCGNtxEG2qGejVbCbrcENZ3Nc6YHYiBqAVCLytgXu0Yc3Fe
	rSolaeqFcYMQz7mRqt5BAWLOGpTj2NPSD666uYMcz7+yMmyFX2ptal15GrXzA==
X-Received: by 2002:a05:6a00:99f:b0:886:61e5:cfbd with SMTP id d2e1a72fcca58-897c79d7cc1mr9570153b3a.45.1791863538092;
        Mon, 12 Oct 2026 20:52:18 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:17 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 03/11] zram: zstd: do not allocate empty C/D-dictionaries
Date: Tue, 13 Oct 2026 12:50:50 +0900
Message-ID: <20261013035201.2809924-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E7EF20005
X-Rspam-User: 
X-Stat-Signature: bttrzqjpbfdhkm1w1udmo1h7npe4cyfz
X-HE-Tag: 1791863539-527993
X-HE-Meta: U2FsdGVkX1/mYfX76xK7ol/oUk5xMe5jF0C9AWrlOhBolcRmTnED3ZDcgAPea2U88tOhojrt0WnOAj+NszlRf07MmGL9kC/xM/NgF0zXlYmRKawQlj9OEaf42pA2RzxAoz0dyKX5g1iGAh22Ombup/5R3e7vIwAFgDE40PhInPDYBurRscnk3PMT6Ejw++L08q0IgAqnQToI39JzXvr1Bnsf3AS2Ts7hRNKUDFzECP8xawx4t3VN6uov77oN6/0zMiXrRljgiPvCJUuIe8JWY2hguZ4rkkMr/u2eQfCTblERN22/yoChNuHFDfmX53hiEnuv1uTKEm5N0IWHbhUGSbzhcFqBF6kxprIOtPOF9NeKQeITmL2DMSY3yYgfWtRUnWcfYT++rYNY7LhtsR02dCS+JVAU8nM7zZzG6fAozMn/gYBIMaPaUBRvp5+E/eG1YG5GaVw2aO2Svc4KCqpVy2CBFBNo9+DNp46sKpBC10KdV8qlUmCLmCCuXWgWg1KLjAbDNNYIXDvX2srKkdO9gN2aRV+KMyWcxmq9TN9KAvh1jXImTEgVZrsRb7Sq88n31PwLdvv//uJHqBUZSid1m8NJiofklrGR4bUPgmIRsVm/y5KUnrzmkO0cyX0Zdb6FVCWnEsxWq4V533DhyHfyRVaggffLBz+nx9U5u4R65RJZ76DqW2CAzIbybayU6ZUT6y/tGIdOfB4Yt3ga9u0pqVY3zdVekhCfGaE0E683WE7RUWYs2O4JPEsjf6oxT882uGH4JDbS+Bowhtm2nmKnmVJdFS8if98cQVm/7u5YhrTFelljr4o8jtzm5z85cbaKAY/skKbdLNKoUD5NbvJIT2NyANLMi94N60NZ5Arh0/2nnYjbmuALfClZi8uz9zJaFm0DwjwCCbyqZKg7lkq6rUsLI9PxrP42XHU65D9kJxfe6l8QQVmj04ETDsJv9UMpqvmI6Hpx9OMfAKPBbIX
 8CIYPG3e
 UTSU7wcNIJKBv7H9sKOqYi9KD0gBeF7fOiMF16uxtR5VGUN2j6QGIv614AQOCnBJsF5DpKFYTs7fXq7s0QyLDeHy8nfDQ/NHjqemS48rK5nmzGzdr3S9StRJScFjH6kwTXWsKMdZJ+JOFyFpsFsMTZLqkIlVphM1bfEMqeTEYkJ2tBAj74tlaHqCJPUgd35TYn8tMyBgXr7ZfvVHbuL0wHkUroLFx8Yx+uH5tLEZ8VMuSiRLbZdAporsEFA23PXAVfAIv8x40TNdJn4l2Icem55hCiol/vZA2Gai6NJ+bmYsjVU57GFhhAjIuXA==
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


