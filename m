Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7741CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A520D6B009B; Fri, 16 Oct 2026 00:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29E56B009D; Fri, 16 Oct 2026 00:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918956B009E; Fri, 16 Oct 2026 00:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9C06B009B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C89661C2FD2
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:46 +0000 (UTC)
X-FDA: 85327248972.01.5AE2186
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 13F2D100003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XL95Ojv6;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
	b=NUDxbjmRX//X8wSBeaM210qkqIPJ54nPH3BbQWdhL9b16BDUY626vMGwOIYQm0Nj8ZE7s9
	6JDnJxdH7eDn7zOAUIYMZO2ebboY0qwkwIz7KWVb+jAu2opy+RDOp1w4NN9CQr3hZETTkk
	9Oo6U4RmBPB2G7zx5uRpia91xOQuuzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125885;
	b=N1V7j8dIDiRID17SgpIqNfIcggh1xduPa1WaYu2ucdowpH5EuGpKGoIfmA9lvZ5xdSXrMq
	rvXoXt5fEPl73LQPQPjA+ECQodG88SVc3qmaFS/85vKKdEGqN5DLu85lS036dFnDovzCJp
	B9eKsKz2OPhUJ90ye+6doKYVdGgSCP0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XL95Ojv6;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e608cd460eso33241485ad.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125884; x=1792730684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
        b=XL95Ojv6xv2W3ARZukzTPwgf+QHZFmiKPkoYJtJH992ZsjhjcsliYymNguI7BE46WA
         PS0ddSE6dgfz3CaOMVL0c4qm4TaZdIqDyJnPDGJHZ79tLaVRjR1/TYdbQTI8dMP5CQJ8
         +rWemwRLupxtJJ7uZkmI2HYsTHwa2fXOiOa3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125884; x=1792730684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
        b=e2MjtroO4hoRPo38ZU7er4566DnnJgEhTrpbsvTHL6JPIP6Ya02RvWb/8eiFF0KOvZ
         7CV9lSl0C4lHdGw8F42EbvGUizORlj6Aor4XOTUv8z/V7cqS9HxtvCDwu+SI/i8eKmVv
         YVKFQOnCTlT1vFYtyqtcxbYhlB5Ck3HjCP66DZW4VugzoyNeWePueBxfF2Sguz84ZyXn
         ynP0ucFC7YAAPjle1fyXQQekKpJOsAQVR7bAEIZYdPTS1UFch7hacsukZ6cSeQVapaa7
         fRzPnDn7txnLpbMqQN+IFfpB9C6hTw4Xpc7AEWMCt4ODE73U25axf578Izqa2uvxdwQi
         OEHQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3RJ4MDv/W/pPDoy0GAv8BjOKyAr3DBLXow/Ukpt/K031W8M6rFRuEInivXZiMuJPgAd8dfkJ+qw==@kvack.org
X-Gm-Message-State: AFq9FYLNR0H1Deufr36+qu9mUVNLpkuxVqNuVZt6rZm3NPi3uZ+WohJc
	ruGCQPzmuR/5lhUJTRd76oJTS0likMRcy7COfQ4gScZnbUqmFLlePGFYDlVb76AWfg==
X-Gm-Gg: AYBFou1jzt7sg7jOhnUV0sNGc3u+9EMj1vNSQqq2jmZOAtRKOgS3p3PidaIPQnSkvVC
	BPN50b4sho7lEZnhpTfcfyoJEQc84SDGf242VDjBt84Tdbh30KTePFWMe90Zf1s/Za+P6jPG/Z0
	cGHwqqt7UXE20loJnYDH7wJ+SJP/I9duY5Ry1ysNtBdJcBYmOlCTZGW6gg5PtFgIuF9iezdcj0f
	X+C+zOVRs8y12i85E8DYY7ly3gdtHCo1miw2DFe/6YVniKeA9sdw5eElP+5A9QJGaf6Ut5Neo3Y
	zJXO9Rtvo5MDIVABl5KEcKgF5OKCdMq9bh9INhfRRSvWx7HSEE+MxzBSNAXEcW/pP7HJSudK620
	fFjUAeIq5bqGz1+lL9rorg+rCnsbdDk6Zu4Fg2COCFpDLqyTmNKFmRsZh01+hledyeEQCZaFSyg
	RVD+VUySoo/23Pm7pBmYREVtEhQT8ojW6Elt/6SKHCBn1+BZKJfZpqkX/wMPYZ9YF3d5x17aFpL
	WWlIdnBpJynusP1EcbAh+rDoDvQ7DdvCa1lvgwnVWLbQHEXDbd8NvWgnfg87Po=
X-Received: by 2002:a17:903:1a10:b0:2e9:7b4f:b98f with SMTP id d9443c01a7336-2e97b4fbaf1mr15649355ad.6.1792125883969;
        Thu, 15 Oct 2026 21:44:43 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:43 -0700 (PDT)
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
Subject: [PATCH v4 03/12] zram: zstd: do not allocate empty C/D-dictionaries
Date: Fri, 16 Oct 2026 13:44:08 +0900
Message-ID: <20261016044429.1304561-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13F2D100003
X-Stat-Signature: ccnojx8c9kd1ezh856g7gmn7dryj4qt8
X-HE-Tag: 1792125884-414106
X-HE-Meta: U2FsdGVkX1+7ZpChsWDz10nxxN/aAhaPe1b9n2t/tWMNZnNQcpnCf2q0eEBCXiy/e0/OQxbAaIHa9cVoYov7qXO+RsQKfXHTIH6radvVShWIVt1FilCElXhMYIVVjkggJEIqD3E+QALeYKg0cAOSjPEd5aEDqC934phFhL9yg710QGItxcHGMYe89lIyySp8CGwGrzDM6bRLvkiX42vQVRAnv+RN/8wPhGcQjFnBNY1oBeA5kRmxgOiol18x5BpAVkBI1L4BSjaTooRUXapQg8Jn09coE8z5RJmAH4BHePigMgFnhV3mZAIGcVINnUF4ehBxvHgrTMFOW9yWuAz9TBEXCpkLWtwO9o73zJ6dKtXLOSFgtG/zWrecFzfuXpnx1w+UsKQ8buHC4x4t5ygzUWVi8proxCvVNs0pzXdgFHPQlqgYhCm59ksCOedK/FqhVNzcWN3+hYOQHOv4Nma/XDnYvfWT52Daf9ilZQuqHiPqXDqPEIgdLUY0ZRXUwPHldaHtZ9rnYlmyk4OyE7q6mQs7rHKEFI5Nqe0KOBnE/Qyq8F2U0aSXIOLd1MMDrOk+zNtWzvSYcuAOEUP8QpabCzXs4/VjPI50otqFogBN5P+UwTRuqEQMjp9t5R717VTOh7M4nISBBrjUzID/sI3UTxP3yPtBzT583y8uSD06Wo7U2FevfGzvB8six3UjWJBmTMVeIDANupHAoszl4e3poTFBKxnaJCst088niQtmGWnlWer8scWlySJY6sZUnNhSPKx/mN5ZUMCOHKxRbh7YDHlc5CxiUsWjW7zVvC2oClUO9B+MwGNQBj53WIJKkG0p3WbYM3VHYmv8FEnbsXSovo2RKk9Wfda9aUtf66Z7KDg65XiE9cf+XrjV7fDfMVhNd5EZn59qtPM8qripR2oY3ao9R+xYX5QwBo+Tdrf/h5Elzj0FxvHtLMBdtR4EwuH+5FJnjEzJ0QGtCST+rfR
 mEKJloi6
 mSNDMUPq6dC81LrZhTFmpC2teBQy7s1HgEt645yzKZXpSF2JIxMGfVisIQOZvbjI4FdeyZNP6LtbhcDopaIy5JMzlo6UmUcXgwQaCzvBFdAGw/PXSA7zxzlsLnP4jm8UTXxgfYG0nwMcAU1bHSlttP8QMZ66c10FRIcIEQ0QQ8HHRuPXx8PFQQDrcwC4R/VBe6xuwiV9TSyLubkLBIjsyieN7048wfBmlf1koMtA3DnPPX9H4W73//+nUQ151YlmJXaLc+G5vPPoT6t0ii4WVNrJJ5GT1nWbAcMB54xHZ87pc2VQjmb4b7sgKaQ==
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
2.56.0.176.g3575e65682-goog


