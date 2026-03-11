Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB22A1125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CA86B008A; Wed, 11 Mar 2026 15:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7A56B008C; Wed, 11 Mar 2026 15:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530246B0092; Wed, 11 Mar 2026 15:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 429DA6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D98FD1403A3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:59 +0000 (UTC)
X-FDA: 84534827958.03.91B98BD
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0333310000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNroT86e;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66epcnsZKRJCgUvj1UpodhEZPhy6a4TqXH4bGO7dPGI=;
	b=0KJhlnJzfWqxXdPJ/JLf7yapmE/JNmkbAee2JATC2I1IPUTkSbgItxxAvxQmpLxPm4uc80
	+ooqTlziSrwNjof2Rj7FsuSqrzvOhlCS4xncLzcJTYAY6pSzTmyGQZh9pRGUPMjTJnzCl9
	MfgQfF61xB+RutBEH2em0N7ipm3TPKw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MNroT86e;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258718; a=rsa-sha256;
	cv=none;
	b=4l9j+fivdvgUjSwvkI2543d3noanzh+2MZZ9jkgMELLJSQkdVxLCTzvKcO4dgP879MdkCn
	wy++qb/2wAXixa0fqzp2jE5M2hN5GHoojk0cj9YZUbHsMz6yCg54q+Ge96dmWEiCXjjUH1
	wzlz0JsPaPT5amHRHuhb1VAyySyLwOA=
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-466ebbf7ff7so119277b6e.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258717; x=1773863517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=66epcnsZKRJCgUvj1UpodhEZPhy6a4TqXH4bGO7dPGI=;
        b=MNroT86e7PsO62J3rcaA94gjMlKg/+u2knk6tXJiSFP/48unbyffCO2UYOCERWXjaz
         b8UZraBHclaps20KPS9y4vb60bJSPf6fNi2nOBLAzLQhGSWgu08KrTEul+9Uq7ttQreq
         HCpEZNm5uC8lNknGOZ4eGW9gYbU9+d1fOPI8dAbwPU3e4yqpgZokWcw6rY2li+NGzvIp
         xsOQrfPe1Sj5fN3vjFfjRKxseYIun/qzFw/QyhL4Qwz4vCDJLxXp4TEUrjKMRqcv27YC
         s14Q4CLrpAtCH+x0VV+Zi2eFrcMjI56ulwHi1+RjpLe6ySJeMfYzYTVxzdBrGB9gRABT
         kTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258717; x=1773863517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=66epcnsZKRJCgUvj1UpodhEZPhy6a4TqXH4bGO7dPGI=;
        b=Cko4qq1y1hdyZCD+Ot5I22+KoUL9gpVjB+z2ouFUDwcQG2M+ipgh8iC/KJOVwCRNvZ
         7orYQJc+JbBV0L8bj/fQjBx4MDdEh2fovkkdi+wRCD42aJvF+8kH9aqLT3ClJynY06l2
         R4wnzkyH5osfRQtQ9T9K15oJJAK/1o1tlDUImHzg4csRW5+D16fewnm6rJDlURlpWdXF
         m/wG/1TWRQTQCv6mNTr5FLDLxkQNrHGKEJxLXiyJ9qgpcnG6ZTIaC7bVAsuXpLv3fvDj
         t45BY2b/073ecvfq0cRs8O2OA1MRbWqi0ZkfP5CH29YQ9EZ50VlCCNClMNyTRpNGc5Cb
         O2eg==
X-Forwarded-Encrypted: i=1; AJvYcCVDQkFinpR/FPbYmgcjGxxrrhS/BRY37taVCcGqBvC6hj6kXYIfLG0W2GZiSeNMfqSP583BUvvo7A==@kvack.org
X-Gm-Message-State: AOJu0YxrL4h3fH7XKyMOKMf/Z1ycFAO7l4Azo20Br7ilHqjHzQZclENM
	gZYTTnAndggoEcuiw4nDSH+fzdS0sL/2qHHUK8e5NCican9f/K3xP+QL
X-Gm-Gg: ATEYQzzgazuR3uuKFTZQgWdIUsBnSqykq+3lHXUmeyRafYMYZYG9PYj4UxRKwpMKRmf
	2BIRlv5iq/hIH1+HRrSuAqlVLCes5AjZuLZWaaVNIDI5JHmHPiXybnAP06Va8TxtS4JykL10J3r
	bCrtJnfNjuYcwOAGaoGHlmF9p8760ZdAQYI/qMjl42Jk5YMTEoNW4TRPQyJZGarcszSihtGpT0q
	h6XEokRRG9npeTB9s0RpZELX9lGrnz7ikxywbHmHoP43iQdJ33Xb1RckfZJAD9g1A0/1vzK4hd5
	772KEVThGFM6fs1Gxko3eK2GZ0dSTbLVksiaHporU+hxwyG5BckfuMCmj6AivODYgM0GD7OJTgv
	4oxGaLseDalcPCMjOtzhbASi7y89WH6PqY05S6WHl9tmE4zrGo+pEZzmJba5xK+MhoFrgvHc38W
	Cr1ue8o4188rGcg94KrzfG0A==
X-Received: by 2002:a05:6808:250f:b0:450:275b:d942 with SMTP id 5614622812f47-46733425adamr2199782b6e.10.1773258716902;
        Wed, 11 Mar 2026 12:51:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41791432d87sm1535210fac.1.2026.03.11.12.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:51:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 02/11] mm/zsmalloc: Make all obj_idx unsigned ints
Date: Wed, 11 Mar 2026 12:51:39 -0700
Message-ID: <20260311195153.4013476-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0333310000A
X-Stat-Signature: rj6yo3w6aouyfe7jkpstz19ukso4nira
X-Rspam-User: 
X-HE-Tag: 1773258717-939378
X-HE-Meta: U2FsdGVkX1+QYdSVs0tDZ92d0iwAbGUktbFtB8Kfvy5bVrs/2fMY2gUsGmEQbM03ykm8UDpR7Xixgkhkzpgcze0Sy3lkfgznNpnfLYyoRXVww49ZRdLIqo7Fa5ZELhoi0LaTsgPFulIEpqL6BlWQttY+iuoIaQ6/SSb5xsklwbZO59g6K4S6PlTDOLnrJzAGrBcLJswdI5xWjrYJsollSVvYMfXwQnmibGOg6sKh6JyqIfGdfbZgZJwoFq318Bq791XnI9I8QEEfH7LaPpM9I0EN/erzsMoLo5dL2gHu769CbvYBxFgLHuRfP5PJ+xrkqJb5u+MXA8GFUiicWYyMnVn2zwGCxYupVYCFq7q+toWlfXSQYsnHS+x4xkr6jdgAjD0Ton2nYz4heicHD3X7dkgUir/M2xmT4GJvCzLFwTXTJ2yWmlxwtTjKZTGHjNxe6bQ3PcjXJ3wxqoEant0+fZUFddvmwcoFwus7v+IQ7BmB9j1ZVOZIoTDDnpV4OP0wtAKJEDNkfvw4WaJLfU/woO4PXfhCNeP0JLcdoBfPbLyOcxvmddMUKEbzSk2NUDF+sf+qgKtTh3J3y4qV0SvFGAC1grMmPuk/sk0u1sc732mxO8YW/uX8jPPu+iHxKmrwyJ59HUSIQnrgUKcTri3F3fPEEihBVN8ihbRZcW/alHujLWF6eQiDXWcjZrV/JzG8iXMfL0BQ2RrTrl/8qZ7pQXd4kngPqPMhlY/ILgjjT9YQH6wxfy6QYCgQbpEo37t1aXu8oQgmPSffojujDI8zm31djkZQW7GsBExwgU+j+DkJ/SygkvKqxu/7s0X8s+JLTYYrJoJxk1CSL35Qe70GY3Tk1TjJOSVyp34tcDVlFpbwS0U5BgjlWxH5MkXEtIHveXtF8XdMBhlfQnTtS2e/VcRijebOBhFcf9n88sZxnQRws8QOR7h7CN5QrAVvMAn5KVXF+TfZ7fFAi/pcgpA
 aY3nNxN/
 NX9nAtM417n+SnfiHT9PYmVms+BkSIVEzp5RHCa+qe8CLmgE/uPWZtFen2S7qEmDMxHd8AVMQeMIWxx50GpWuyn+veUUO3WhvlOa3eQ/ay1uoWk9YVWaG8gi//Hwj3bboBHVw7FUe9mQPR7KhRpXFyxSpefXhfIkCO4RIhBuwe2CRwBPxvkCwD6VVsjA0a8BptQBLxkF6d5veZigGd/wXDbmS4jIdsFyCWWI6P+5vY4R7cVjT/+6Uzy8TkoFIpEltuzuIsBsr2KyoLJQttWaW4/J3DRaC2wk7wgTaj2a+Q/JEI+lHTsx52+DldgOpIGFNXBNJI6l4KrGtAMOy6HDAvM5OmomZ0LP9dIY8ZqO/83lFihtJM0+IzAcYAbqsNDrlOO5dhgGI7MHhmEcFBP0FOYKNEIeKCHtziQW5uTvivMwjvIlKA06VqjRIHA20xTUwTYRg3H4BQTJKgca8LH1vPuPNFNkMxMNCR+egS0HchPiDk8qr31vPdV6jUeH+Jeti+RR9kwK3KKi27EbMYT2SZNu2T1FWutJ5FBKd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object indices, which describe the location of an object in a zspage,
cannot be negative. To reflect this most helpers calculate and return
these values as unsigned ints.

Convert find_alloced_obj, the only function that calculates obj_idx as
a signed int, to use an unsigned int as well.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7a9b8f55d529..7758486e1d06 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1491,10 +1491,11 @@ static void zs_obj_copy(struct size_class *class, unsigned long dst,
  * return handle.
  */
 static unsigned long find_alloced_obj(struct size_class *class,
-				      struct zpdesc *zpdesc, int *obj_idx)
+				      struct zpdesc *zpdesc,
+				      unsigned int *obj_idx)
 {
 	unsigned int offset;
-	int index = *obj_idx;
+	unsigned int index = *obj_idx;
 	unsigned long handle = 0;
 	void *addr = kmap_local_zpdesc(zpdesc);
 
@@ -1521,7 +1522,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 {
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
-	int obj_idx = 0;
+	unsigned int obj_idx = 0;
 	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
 
-- 
2.52.0


