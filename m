Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EA9CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB21C8E000C; Fri, 19 Sep 2025 09:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E627B8E0001; Fri, 19 Sep 2025 09:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A888E000C; Fri, 19 Sep 2025 09:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD21D8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 746C91603CC
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:41 +0000 (UTC)
X-FDA: 83906024202.12.CB7CCF3
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 761482000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mod43Sr6;
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
	b=zqIwa57yQ6HfNnELR3H5Is54/LwpaeSPijn28loMxxbsluER6SgCvMdt8cspvGJpjUeQGf
	E9C0nZE919r2KKrrLPXNUjzgiMZYivbjKrq8J0Q8ExvpZNQDdiyu1ToXlKMd4crks/YB+Y
	ekNh5xYpserGLttQZZdBfJVrLvAnHkU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mod43Sr6;
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287199; a=rsa-sha256;
	cv=none;
	b=4iMW9SsqPYyE/N08ITEuBO4rGerePYzdBvDgzovVqLsEmd0KyEBH8kjEq9nWosYL5jj2Sz
	F0LhTEDTKBVKX2lbx3jYP+5APtCaZlLWJqjzmJsXJfxP5Mbgc/5Azzu+lmTqyhKJ3iyB9i
	Zu4W8SBAJnNPHHuRTYPSj2+mOHN8tBs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2445824dc27so22214545ad.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287198; x=1758891998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=Mod43Sr6MB9wo7tfYl6iDDgIx1sNq8wmuSc59klauYxF+fMYt+4siKCm/+P93Ap7gM
         0DglfNXiwBuz9rWz4FklabpY0e2LHtxoemvqpF6wnpEETEqOr90g5vN4Xi/CAhIYtnMJ
         SURH47BlZVrJ35ugULiLy7kd1Au6tsTi3FARwkLEkBTiae1HrfhRZlpCe2fuenObZ7Fj
         hSPpPqy10ok4/y49+p4DRhcLqkB8NC96Tt2/AP08Sh1SKC0aaOJjWlDixmIJ5VfK0j7J
         636eS/q3HhRKG4RDp/wIglxybNBfygSGiF6bY4j8dkXeFk0I1cigccjHqMf28HthM8Hh
         fGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287198; x=1758891998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=rtM7/8iZARBIQhWabY1DhvFe0gBHu8/SE8oMWtQw0PkdAdUdKssSfyGG2wmNtva2PE
         U5Ob/MPQ3CVPwiYhBZxRVwQm7T7rkmrdnwTiqsCzQI8ZSjxuBk+aeelQjN+5beBgwasJ
         /XF+BlVcBNrYsyFNvJ1dMvZuUI6eD1s3XzCORF4Xc8gRaesSavdZhgdvQ/p6Cao5GTwl
         /HGm9ABYcIa45Xnw3/0JZHZpE+5oazjyBA4e72shoW3azuL5gFdbh9RKBR+xXfGgNRkt
         m3sHI2Sfd7KIdnkrwpUa1N+MtVGv2cJp4BjjIyr2hujgSn3/aYnrsScmeYg76nYgYcFU
         su0w==
X-Forwarded-Encrypted: i=1; AJvYcCX638i0vlU29Cd8yLD8pXCNXBn7Rluu2EPVVXA0zUOvxPA3nOyQYBN1avB+sy/GmwJ9qmNJvFcF7g==@kvack.org
X-Gm-Message-State: AOJu0Yxcj4fmIJUQK2TlqsZVokQxapOTHo3z05OfE3kpvp5r1uAkm14a
	lf3kWKYPg3X5graoiOS/zLYaZk4+YreUgkKBdlOv6tqRxo14KM6Ry8lfAkexIMZtX20=
X-Gm-Gg: ASbGncvWVHvrqRp929+oFrmZ958cy7D1BYmybJLNKyMO6C3M/NUzCjZrw7dxYj3wlm6
	ei9BC0UqL6v6jRsQ0Eo/DKvXjs5tdZwWN476/LmxokVYILsDeldIgEWLrrf0nrcx/S+ECDkXt4P
	9wtU6iJsh3xeLw1UwLaVlGCt/FSQZY1dQ/+AjrDKvuEM4/2+eG2czTsTvErNjcyb2V++7m8d90B
	/zW2jGSNrwxwjTbDOuIwAWXfw1To1yWrEQNkk8beLW0HN/GdUL0xkY/DpjxE2K4Wk4DfQ39PQZp
	DyKCEdzNpoy+4Y2e+AshrJPP7oXou4RE1fk89fvfc/UrJ1Ojthx8kRnFasoggF34nmrUxm8apz/
	CJ6WU/OHU/E044Ylx7NyaErU2RAUQvoXmuTQvQ12kXl3s7n4=
X-Google-Smtp-Source: AGHT+IGjrAZ4ana6L1lfOx9cqydZTbCutC99XQcIBsreys2Dh65escr5oEpaYr4mKrnWMUardvltDQ==
X-Received: by 2002:a17:903:290:b0:26a:8171:daf7 with SMTP id d9443c01a7336-26a8171dbcamr33445425ad.16.1758287197311;
        Fri, 19 Sep 2025 06:06:37 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:36 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	libo.gcs85@bytedance.com,
	Yongting Lin <linyongting@bytedance.com>
Subject: [PATCH V2 2/8] mshare: selftests: Adding config fragments
Date: Fri, 19 Sep 2025 21:06:15 +0800
Message-Id: <20250919130620.56518-3-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 761482000F
X-Rspamd-Server: rspam05
X-Stat-Signature: 4rpcyxcsyzqhcajtra8kqsgn13iiyuzc
X-Rspam-User: 
X-HE-Tag: 1758287199-590800
X-HE-Meta: U2FsdGVkX1/4k65G+bweWEhuGptQ9AQr7rIT76i9s3zg7P/CmhMZZVsocJGzO/K2uVCstqlxl2Orll/mta8V6qucBchjCj8u5zmSi1RVS9Jz0HjyFHgVgCEa4+0Qvko/orfcUUNiTKYLaihdWzj2kfvHD2mWR3L/VvCTApMlCg0+iboa1Q3PJH0mf5gJWXrnOguftxAJFlbdihXFJ7z33wGCESe5tgpMc93etGGRMI9c5Q+UOKI8j33qNzNyAAJ/tqyz1zs6vFanEpqr3Zzn8vm+i0cf0lC5KrvCUgMzkcFuflwHo6HoWKYhZuMveCX5u3yI8/OBXgtIMvqrPzm+7Jb9egLWO+byHEdiwIQEU3Wt+6ibcb8SrDdHzkTs3/jMiRLXvucGWto/fc/EhPqD74xDmtVyim8Ll9AHzIJ3zr2OfXffp8KhfGQFXxQCvhLmNtStBNb7O8R1d/5VfFA2xaS8gDsmrzYplJPC7aIbFQXLP4kWG5Hy1jh48ghL2zdBUUZsKDc2Gs8dvYfqkRgwTPywEqsh+K3lNbPtOkaBPv8djq9qJxCa+50t1xkDcp5KzHuDpcJyc/IniAvL9MqKPaeH9u1XqDsPRTQfZO7LUb+01tq5v4KlhRLhskOZQNXBrgcU55d1h56sBccYYcRsJC1XaTTJndGOV0oW5H9LVFSPtLWh7cIgVuLGkqDMdSrijMh2zIbuX38disfgmINnz6YFKiATP3YQz1h8kesPdIocDYa+CnWghTN+Pw7UGZlgBzRLiIj4Ux8uSAvCh/GxesefjFlQUtewZHOE33IfZx+pJ+Wt36dAr3jjkU/0xseTfJeQvXlIvJuXyfc3CLXnbP9XlFB1eZ5nnWebpOsojVaYpwZI81LfLE0+xPJeqPy9zQYgdf2udfAphVe0VFTrqMquE5f9N4WEfFUSlgKiWZop25wmYTeYUZhUXu8QEGlqs3VrtEHzvspYiiUjw9n
 QHTP3FA5
 CBBqTTI2vhdtyVmLDWOfcjBW4sDsuH3mqVSEmsWxuhez0x+GKcUlJrPrCUKSty7KalanuSUB42RzKIw90lAZhQv536a5Xau+DMG1fqv1ZnCtOYV762KJ2XvbDxlOYIpZblfux1fcR72Y+XPJjyB0I6R7lmJD9q5mYKeXwAdWNqwe1wbBY6qRs+gkxXexzzkDQyPukXGf8KF04SHEh+sRKEkgoYaAICu2N5G0Z/T1109mVS6w79mkfcURzpD04oeI75xSIY8+FYsA6ByC4t6URHuqIJDiDooBke22D08ETQ+SR6CG+Vo3G7Mop8g9RCkPlCqHj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mshare test cases need pre-required kernel configs for the test
to get pass.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/config | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/mshare/config

diff --git a/tools/testing/selftests/mshare/config b/tools/testing/selftests/mshare/config
new file mode 100644
index 000000000000..16fd9a3ca12a
--- /dev/null
+++ b/tools/testing/selftests/mshare/config
@@ -0,0 +1 @@
+CONFIG_MSHARE=y
-- 
2.20.1


