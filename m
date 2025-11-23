Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436F7CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 06:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBB56B00A7; Sun, 23 Nov 2025 01:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB466B00AA; Sun, 23 Nov 2025 01:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCA46B00AC; Sun, 23 Nov 2025 01:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 237596B00A7
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:31:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0BD5BCB70
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:13 +0000 (UTC)
X-FDA: 84140899626.22.51A2488
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2C1A140008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lGsnD5Bt;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763879472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
	b=IXSPf+FOcgdbyzQjrX+61cwoUvAP7lMVh9gyoL+6RKdE/frDfqlam+w3YVxW23ObhgTNZw
	xhnrpiA3NWhBL7vktg82i3EC0gw9b1XoQL+1AMRlaoECVTYxBZYt/G2XYLTpJNFcWuBDyw
	uTj7FpSYmZ+47ikAbOJrTp/Ub2kMGRs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lGsnD5Bt;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763879472; a=rsa-sha256;
	cv=none;
	b=E1RXyUre6IU7PSRlK/n8HLaqxKXQt5pQ+cFKXO3UyN3bRQJ2ecnqPXhKYFGJtBAeTeQWWn
	bpym9cjs+XvlZSZ/fOcTHu/srmVNCA1hoQYOlQAWkUZJUUA65+B6nMfT+RBgxmbVg/SPZa
	6Q2cdDYxxZnhr7Aqa1BhLZGBbCYmWKg=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so5287011a12.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763879470; x=1764484270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=lGsnD5Btv4R0rCZJE/8ZRltjKYNQn7dk5LF92JWCHx66a7NWNEik26bZHKrrLEF7Io
         bVdRSKa7Vcu53te33pAQjd+ETl9YxQV4SQZnGs3a5dZbmFfuqvrlkcd7e0HYzyACozLh
         Otie2/ZOZr2eUTsPgCynnS5Ac3TppiIBBO7mk5HySqdJpwFS56zxik5NnAPud0ugd4UK
         cWxMRk62tojKNZAy0XKAr4JMTP+91kWAtMJFnYP8kaHJQEKQxa5IrB8BRazJglcYMWI6
         rqenSNGOEZU2JJNP97qSygtG7FstNJlbCY/8d//ASkONFGpOGfhnlX35xyPxOsBbm9TM
         EgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763879470; x=1764484270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ighOjyvrf0/Zx4X8xYQ5PxpLMHcY6lBYspK5VjpofZs=;
        b=GXkkPxjjVZRNQaPhjTx8Er5S1LZs/nCbXDTZ1fKeumsQ03g/TW7yCIP1JUp0NWi2z9
         sFoaGVAgXRGTzyT176uy+7fcTEDcMkG0Fsqi2UFEn7krCI5uOq2LzEAd1O2qoHQ/Gmzk
         jpgJhKxMyEGNKJ1IOgrkffGjo/XVBxuvy2XqlP2GDT5o0kFqM/h4+7oFUWXLSB3PwmmB
         iHr4eueQ/YqKu3UoQ3ESTsgI+23eZU8zJjVRB3C3mLANetwoC9JScPA4jMp364vUn4rZ
         5MUEjUifIUmLd2xC8nxt49p02euuIrQUfvi2y+4bDk+y0VZLBBj2DlTZQGYISXSZVowd
         MmBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcYcb0FlANMs9IT/CXm7EPn9s3WmueS0MjASkv8TYvLG3KJTQKOZrn57xshBTqXF3ZqZQVB48JXQ==@kvack.org
X-Gm-Message-State: AOJu0YxzalOm3ocvF6nXWkcKSaWgZzQvUTfowY4hYQtIFZSzm9VrEUKo
	5g+Q50rxC7xRHNME3GNuJMCj8VpalcXTZKoG2in5Fd+AH0jjFyqpK7Zy
X-Gm-Gg: ASbGnctEnR41grCSLu0R2VpvHL3/k3d53rjm+V03tQI9t2CoSwVqLG7Cd3VLUXcFXrc
	/WshhNgjvuyPTCNGQ1qYpb0iEeCHqkcQHiydZPq9AJDr4tc/gabO12FCN3aV5fASD1Lh/s/VN63
	G9KpFJkRoqVKc6v1nNwjmyj52Xh9eYLjeOqGDY1DtGqAGM64dzKqtKx4mjv3fiX98hWCgdfIhZv
	oHhTiXudbBgNvKVONUGkOCiYa5ysL5VeNYF++nQpl+fJYEZDqowkYHSew+PA1vqrwZ+cMfk1MFD
	4JA/3cpJi44+ZZdoYeXVgfAwnPFq6JSlHBzsULHEimqHGbCDoZ9Pyd4NtUKyhuOlOGn6dSvoKY9
	wD+SW9dhrhzcZWmoC7NIRA2mV7q2s3HK80HBNN7aAC5HAksAMF9sDNc4zyR23U5+EGyqVGaDk6m
	fXAmKRhVim0D2WO6uf5+e6pNf8AddUEHoFrjTSk1rn8dXkPKWt8Qh+yRmpv/EkVRNa3MkORg==
X-Google-Smtp-Source: AGHT+IG+zh4ATHjbiK5vyKe+SzwhMWh4xwNYt1jBoUD/n+vAKGF6wzNqxClWwQoSqksxMaxVIvFoJA==
X-Received: by 2002:a17:907:7286:b0:b3d:73e1:d809 with SMTP id a640c23a62f3a-b767173270emr1002823866b.48.1763879470281;
        Sat, 22 Nov 2025 22:31:10 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cf0435sm929432866b.4.2025.11.22.22.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 22:31:09 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 2/3] ns: pad refcount
Date: Sun, 23 Nov 2025 07:30:53 +0100
Message-ID: <20251123063054.3502938-3-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251123063054.3502938-1-mjguzik@gmail.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2C1A140008
X-Stat-Signature: ztgywso7u9gfewuaefk99ss19heufaew
X-Rspam-User: 
X-HE-Tag: 1763879471-499040
X-HE-Meta: U2FsdGVkX18KbNlbaHjsPz19pOiA4VKjR7Kz009/OGboYwd2I1kvG584NwNa9ChJ1p24bShH+5yB6355r4PQX52Pe98r+r2Ph4facba4gyTC+mBilLfbiY0c8z0vFLW2f7E0RNbIuIdDDNGl4VX8qpYD0233TyZxlFpZ5ia/G6OUFH9bnOgGRG9muA6JUb43L9cywb+oajwdE7RfTYwkTqGZCU/Gk1Tq6UTGRwQ2No2gfsz5uBV6goYmh4eOtgjZXdOrOHvxDt7yCLZoRVIizOUpiMwSoZoNw9JyuPyaItcO87wYaF7eUl3gQuHYDcPPADIlaCfjVAmHH6QbPg6hGw+nb0DJdrFExjgMA6NVnE01gHgOFbjt1IgqEHRz4i8TprF+V3IctdB3E8Sof458Tv3hKOgYBM6yw1Hwr8D4SAaOJcKIs9mGYLc17qgiwKI8zkyjPRhZH2ZblzerU+fGA12bASxIQtLzViqroBfPFiNceR2vyi1/vDhlPGehiiGZhUupTkOQkkD/ZjhbVPsvOsbJ69QMeS4lHeeGGP5bUg6/U+DIxCTD02XreFPyspiaIPICaku1vG3S+HDnX26O4ibO58uFfCXaW3+kaY3Cn072etyusBRhAw5ZEfcIGD51QpmNhw7S5EN/y1/+pI24KPvkVWxp8m1LrEsegNNnWnXzq8lOANykvmEddM++6xkphTfJ7wucSL6HbBtde7Vno6ob1Ro54PkDrnQFUyB3587H8TiqSGkLZBmmyPK2PoOfZ0a8PgDj/faWRKo3O9gc+vkfuqRhl9rf+f191gGgPLmRXlA+7Bd5yHXGOLaGBty6Xg8trVbOO74hmhVuMw8f+PgYQz7qxYd+O91J9fmCsM/zYw01fNowB37bj3bR2icIj2hoXvB0KMDU3JLmk8R5QTe6C+i+5tIdNyvjyjMt3V98VouMdJVEPnc23LHGWabQu2XYRX1FPkDjfQ+65ZD
 bYIqPWqp
 qrXU3Ryv5BLXfI8MwaAwMEctewhJW/cc5KRQ2M+ajv7B+ytiSDl19OpMRqfwDM8qzJ5oSkkf2CZVyKkyHv2sHr/BHUoRFBo9PIyee2tC0mLw/RkqKf0NKASVr/FzOMusVeN9Lwp7rFzT70ylf2Yhpn+s6CcLYRYZr6goEf2kQ20VXWTp036c7bsSZ5mlj15jRAG0iZ0ROLBjB2XlrsBTwURQFsiq+WC9pXW40kTAm2RiCfIgCkuRpdVlWfGRMV5xntbGny5pcp+ExxagDyzxTk7zcQNKQaZb5Rn4k0ADGXz72iRkvO7n3njRTO1OdWDhY0HzEpt3U53kVUzNcV/5LjZ3ifKqEmBpSTdkWuIPhKAjM+Fqq+BMKCSkN8qthr2ki5bkJyrnbL7amL7nKILvkpNDLTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note no effort is made to make sure structs embedding the namespace are
themselves aligned, so this is not guaranteed to eliminate cacheline
bouncing due to refcount management.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/ns/ns_common_types.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ns/ns_common_types.h b/include/linux/ns/ns_common_types.h
index b332b019b29c..0014fbc1c626 100644
--- a/include/linux/ns/ns_common_types.h
+++ b/include/linux/ns/ns_common_types.h
@@ -108,11 +108,13 @@ extern const struct proc_ns_operations utsns_operations;
  * @ns_tree: namespace tree nodes and active reference count
  */
 struct ns_common {
+	struct {
+		refcount_t __ns_ref; /* do not use directly */
+	} ____cacheline_aligned_in_smp;
 	u32 ns_type;
 	struct dentry *stashed;
 	const struct proc_ns_operations *ops;
 	unsigned int inum;
-	refcount_t __ns_ref; /* do not use directly */
 	union {
 		struct ns_tree;
 		struct rcu_head ns_rcu;
-- 
2.48.1


