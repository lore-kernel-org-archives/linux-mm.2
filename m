Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8202BC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6908E01CA; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EDA8E01B6; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C539B8E01B6; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA8B9900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:14:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 642F31402AB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:14:16 +0000 (UTC)
X-FDA: 83771021712.24.2C85B6D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D2B3C0008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:14:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MS27p4Gf;
	spf=pass (imf10.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ygmsewkf5T2USbfV7/eaFtCh/3kTJRR7dvKlmbHq5Jc=;
	b=i5GBDQuRGSj9mvDdgSQmYTuxcqshdiLixsfh31K0O0Owx9VAqT4reNU7MOMM+Zy9GrK9PF
	7I7JPuZCWif5AFDiyi9oM4ghN3C3JNGlEq6MiSOwoBrdZ7j7ANbryhkRo8nZTYWLESH8qG
	P+BgRNtLxgfbbTE6ZakSI2naN+meWhA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MS27p4Gf;
	spf=pass (imf10.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072854; a=rsa-sha256;
	cv=none;
	b=N/3oFH2rekvWz5dkPIQB6BZaqnZ6PUMddAAP7cuf+ZPwx6/w5+qr57DZ2FHHXsTDjHaIDk
	ydHjwKpWaO2U05IFwmcHO5NWaYi8J46AUl6r2kzvdrxPOr+dmOsiD32vs33ThNjrSHoUw4
	PAqhODabZi1Wrm95s0exljD3giR/lno=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a15fd04d9so3959065e9.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755072853; x=1755677653; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ygmsewkf5T2USbfV7/eaFtCh/3kTJRR7dvKlmbHq5Jc=;
        b=MS27p4GfgiyT46nU3dP6lKY/F2BKoIhZIUH9NkcXIHtKVvJO+y374GoSuqgtt+UghF
         puBKdvF+aIu92BTSNRayMYeCsix52lJcgRFyZ6yGOckAeU/i5lDCELZqWMC3bpoeeHK9
         U8n7eBfpox2okycGJm0vQyUY8WRe1BL6Qop9zUvBj6u3xCb9Z6WkaZYrx4Szs8i+LsBH
         6IHDjIWyoho31jjPI+GBJ7M+z1qVMa//MS/t9tU5pUbrTCaNU805F1zLYzAubWQam0vG
         tQYa6SshsxaYmYtDLeYRYDZ0Nzqhls7HH8LOqqHVmoRvK3HFefRWigm67agDkrCmXKCe
         9Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755072853; x=1755677653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ygmsewkf5T2USbfV7/eaFtCh/3kTJRR7dvKlmbHq5Jc=;
        b=QL/wa7VTaCbrPXY4ej3JY4e2rketdH7wM+aCrviuBbKA12felsby1GXBmXDBEuG21t
         XvMO4rnPguqQW2l9N7g7Vy+gGBc4TDAQLqidYh9Qu9YMfpg1cs9tr2Q39fGcPZYxjlQL
         DuGg+VclOQmZit4pW0IqnxHxB1KpfYIYAVCUXLAkdTcFU79Cf55m8wseHucqARrAynay
         GvS8MbYBU/1gtmCaoDpRNLFd7layQGc9fyYV4bohJVtb2WsWXIykEw8MYYu4g4bps5yd
         YNuBqxfxcMetgntcRjd9Iv1a1D4r6TrfVqzQMqtJK2OkBfMsYqfnN2Y9W5P9BKPt1+9h
         22gg==
X-Forwarded-Encrypted: i=1; AJvYcCXrdj87dyzIO0bMtPcIxbwKlnj4sxubY6suGGZB4fDIjJpB6lkxR6fIuvRF7hCXvlouKU1YBy8ezQ==@kvack.org
X-Gm-Message-State: AOJu0YxiZ8YN+1IiYJOS1KdtU3xM8V6cIT811pYucH/cwi7d7p/eoRL7
	/PELWc/nl6sht5RdcVUkDjRgO1QH/gXOP+/W3+I2kuU3HBSDWgjrL9nw
X-Gm-Gg: ASbGncuuXKQbFub/+kcMC7qGSD7IN5VVmmNTtJZxTkBAkqU8o9pf5ts2YBbbUebZKSa
	JRafXHP4ptRZ+vdlM8rWJ56VvPjgS4aGV6NGA3S9lVUmxWGC+FGI38DVMvCzrKu7KEraSnhMhW3
	FyyZPEm+pyUFtL+LvwTFh117GPX/U8YqNK2/VN3btiPJEGbR+n3ygWdi0Om/Fsg7UUxtRSaeVWl
	M2nXLg0PHzacwoOq3cQOazJ6+cAnndBiVWQtlrTTvfFfSTEqw6vrpv1iMtKS0uCO2aQMkiIZLAQ
	QJULvlMfGZqe6F1gA3j5LBwqJaCcaDGFeYHNx35OHv5jhhCZv0/7EuvlnOvbrZWVbBXjDXpbny6
	nX1opFkGDWwE6yPnRErbh
X-Google-Smtp-Source: AGHT+IG3yh7PyjDQgWpA08nA+Rs57/Rf3ACPKR25hbtuA5dzYAhDSBEN6RkmUj4SepffsfVfC3aqlw==
X-Received: by 2002:a05:600c:3b10:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-45a1704e410mr12559155e9.12.1755072852760;
        Wed, 13 Aug 2025 01:14:12 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3c4beasm45554467f8f.30.2025.08.13.01.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 01:14:12 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" -> "mremap"
Date: Wed, 13 Aug 2025 09:13:33 +0100
Message-ID: <20250813081333.1978096-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D2B3C0008
X-Stat-Signature: qyzqcnhme46gih8eo5xwo83pdy9rbycc
X-Rspam-User: 
X-HE-Tag: 1755072854-78040
X-HE-Meta: U2FsdGVkX1/A7jLiEa9ZMAQ4RFSmUS1p7+OOHkCMmWe/9N+MYbwxOg4UFhEsqOs5wDgq+Yv0iRfv2KY35Twll1iblNAhxBAkTSaYdsxtu7RN15C+6zQUSk0dvo05y5svkme/QkaHKt8r1nNM1VjJF1Tp1HKwJv777S5uDfz3x8+SHzxNi4uIMvNyAohv5LqkdAtLBvd/A1Iu6G+aaMRDtneWv1WMyXNAT2MPLYat3cRMG0OLd+ZKxgRdSyF7UOmcEWJgOfvHvt8XtU+twc7AZnhqZgR1NVrFOvTi6KzLVC9Fjn8VYfNHQumeWvbUgaYybEaFXJymGVKpIc1uFvBAk04seGU5g5palUdAYLqIEkC2nX2d9t4LSlWPAsV/08967UYBiMWOznjFOvSYL8+EjiLNpRyg3Y/FrrtkLH7onYEGvHt2X3MbcukXqsfa1a7fjGgF8UGewEJVuWkmpPUXgoRJuLHbZRf32rQKYdBD0h6KGo8U72z4YpHv+UHMDk73T5Sv3+Frp2jmfkD6chvDCzl1JTiUyhHxv3hchXWLIPOE6JaOV9FiGFor8cs5LQJN7ncL5ufoIQZuWl+KMQqxzcpk1rmr/ADrqN1Xk4a2AaGTF2FnTR0gEwt9hoWhrMy5UGWAGEXlS1Z00NE0Ev/8nLwQF1LWFciMLWXWBcf9q3SnaUaOyQm+QljuWFpdsrUxZjg8AuSKZWeMT9WttZxPu8sjM5Wm85GIon38sggWgYiM17a9SWiAV4AYG3XHQeAykoEZlFp6s3/odEiAOTT555QyqVu9TL51s85rNocMSqlpfihZrbNC1Cu88BolK0NzA4NVWuVgwusF84ExpaPzZBMG2qqh0Scc7drhe7VLEw1kchGyjronElGoEcw7iGgaDiXbXNt99roZTLpmrSqbnPILU/xykisspAvtB75TeIiVEz47XT4cUoQ8NZk7mgEB17KdCfwxjTyvu2YpoRn
 MNMQfw5t
 Yei/k+wIAsxka4IeV/eUTSqed0+XaB12Py6eGI/9hJMUNjlE3OvUsnfqWH1oAvcpKJLWJYGktgH8gLJaE+xP+Vd51yyosGQEbGAZHHSDBaTi7Mdzz7H2TNXlYou5HcULOH59n6qOC2cMCOYV166odbuuXgW617qBr0Hwohk+6E4uH1SDP2DGxJSQVvWhBddpYWCmZ+PEvxwLkDwsxmSTxUkOuMsqAiBJ1Cv/rZcTFpy6ZZDQRvzk/EILT36NSgq7e5YOq+nmlBYZXFvurGObpsVhCVKgGN/mBOh1+aku8c0pmmO/1RXCPU43n3NOoE/MeCczOOfRKABfD+2Y+V1jbdCMjWmiyY65O/0YLH9r0O5pzTlNmPgroRcN+OrI1Zhfc8SeU67J3XgUECOzuyEz1PSidsRPJxi3tZMAwaXC+1gscK4ii6Ye1m4PwnFoOem5+JzNXL7xWMEF7UzGmwgbZh8ZqIwtAbsvVFr16/5/sDAKUYDdGkN73xP1t2sDHTYwohmI1dHM4Znq9hheSFeyziDizB/ek6FXY5AJlz8uHOclFKaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are spelling mistakes in perror message. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
V2: fix typo fixes, I need more coffee
---
 tools/testing/selftests/mm/mremap_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 5bd52a951cbd..e289bb1112db 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -846,7 +846,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -899,7 +899,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -948,7 +948,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
-- 
2.50.1


