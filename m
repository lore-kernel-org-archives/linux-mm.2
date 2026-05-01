Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BBCDFF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03F66B0093; Fri,  1 May 2026 05:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB916B0095; Fri,  1 May 2026 05:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1526B0096; Fri,  1 May 2026 05:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB09A6B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 567DA8B5A4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:46 +0000 (UTC)
X-FDA: 84718379172.20.9377E60
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81D0BC0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IO5on4rt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628984; a=rsa-sha256;
	cv=none;
	b=6yeyHdCn7Wg+5wuloAm/5mGnGuv5Ozc9NaaMgAT8USqWFRN4ZDKtCPbMxy3veo20AFsmfP
	H071RtQnDvrlmVIc+aCuu+4U56uo9KI2dT9ld8agjGRg87OaHGciDEIOwQrlimX1dJqSDz
	gpsJ6KQSpf6+NSKvEDTfpzz5A0OK8u4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IO5on4rt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg6/BjuyUXCcpPF5+z/gged95vUIgjLnAi+C6UXeFxk=;
	b=rxJNzTQdCkDGrsjiRBlwrfUL0peL1XJFFI3nsaAD389dfomIrMbU01i1cM4IENfxqiW6Y5
	SGSC8i5qCKF629TrqRPKyThx/uRDBNB18B4UXqC6hYvGiskCwqKxLOMh+RfMk1FMKJOqSq
	1wKYYhojE/PiTeoJz3ZWut7111PO7UE=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82f8893bff3so881499b3a.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628983; x=1778233783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rg6/BjuyUXCcpPF5+z/gged95vUIgjLnAi+C6UXeFxk=;
        b=IO5on4rtSEGmFALxY+WMDV5UQtwzeBxNsQR2DC4fKkO4sWm+WoN/HX8WsOsL8LR7Su
         Lw/2j+Adt2HkaHKqVCVegfpFFNbEEzwosvoURe0DFHZRj4BBGg01msT65Xff3pp6bPRm
         n9343xJQ8ct0AVE+lxl8d9GGfDkjf8VqK7QiASaYvsrafI7CfRqWUoG6Fwu4hb+ZPgQQ
         UBgXJWwrq5PyLwVyX/YkpPb79weVngAzCp5+L6TRyvtDGp9IK3SvvT/U+XetOTOV+FXQ
         DRM110kNEcTo82WtBxM44yjcx3g/CSWe4NQrGv1LZ7I1r1DhuhND201CBORBL1YnJINZ
         c/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628983; x=1778233783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rg6/BjuyUXCcpPF5+z/gged95vUIgjLnAi+C6UXeFxk=;
        b=aRZAYdQllmqFxlmOfVhYVU+gF5wOh7na+IPNKlSEV3Cx6CMTwXtAaY+/XM6NW6Ci9q
         pQ9/slaaeAu6QHVAEIBdYN6DOt3SgbH19rgRFSMoVYQOPqCSeVuuZZFQq/LYMEWabfLY
         RU2dMkDBivt2uEQ2F6UdoRiWuzuAz+3axuT/PSOr/SKMjBe+9J2IQwRMux8BjWzB++lj
         0Q32Q13ZXpe0jXX3RHKU6DKbtmvK30ZXQPxf/fYo/stb82DZjk7AQNFrY88mUfLOYeqy
         dM3UuvUWbQ9KFLIVBFwaKjLqNuKQaw6XNSca/ubviQJzT+UrT6ypswu54ujvZj2bm8XK
         UzUA==
X-Forwarded-Encrypted: i=1; AFNElJ+KE7AeKMfPZPV8NXtBnr0jnxBw5/GO6s1WtmIPTa0STCD8IkVgoIY96HLI0lP6eEMjD18hN6YrmQ==@kvack.org
X-Gm-Message-State: AOJu0Yxl10b07LAzbESK5NpBLC610M9Sb3kGZjcAv81Pl+XTRYT+80Ec
	Zmj0CRmLCLc41wqraDl/SIVWHX1P+1009hkMwme6aG/ZvHFPT7GNALDy
X-Gm-Gg: AeBDietcJIVKdNSUMkxnEEb4m1gsf8twnwv+1wLsZ5yuRhd8dqc25U2NgtzSziTWGhz
	y9mB0zugDH6+3WIgZ3e/GIl6KYtke7JftRv21VM8MjRPO1RTGwNPDZTIOv70uzqtuYwn2/VB/dA
	ldvRvRgG0s76z8TcRN6nF/SsDH7snJKhnhLPy6Zmt81MhISxGhW2zz018+nbPfmkqpgc+aGowBB
	A6GtYmn7V3TKqUjc06C/LnYNxsSCOSxT02+ZRfVmCs+TZUnt3QGIeKJefnAaiN5t7d/7nP6eM8K
	GHuavciOng9kIhAQkIEJ/3IYHkb9Lf+qz2mfcMX6uXDJ2/UfiQyhKWhV/K2dYUe6TOC0bhzXS9X
	AL5/Mu5ax/52RuZnK/fi/z4jgx91VqmsE+CTfw6SvVIowvrtYw1Tob3a6h+Djiw3zZsQ+xLFEY5
	8yYDB853sa5VFKFKRmTjBaM2luinyhCzJpDNmz2w==
X-Received: by 2002:a05:6a00:a253:b0:82f:776f:a78d with SMTP id d2e1a72fcca58-8351a344c46mr2584281b3a.19.1777628983321;
        Fri, 01 May 2026 02:49:43 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:42 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 4/5] liveupdate: validate restored LUO file-set metadata
Date: Fri,  1 May 2026 17:46:36 +0800
Message-ID: <20260501094637.38650-5-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9dd8n6iyu4wnmj9ptgrwinoapqypmck
X-Rspam-User: 
X-Rspamd-Queue-Id: 81D0BC0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777628984-177611
X-HE-Meta: U2FsdGVkX19yxP8b+HhiT5Qkw7H8aFJQB0Vy9JRFjCDmnPLJXZuWdiP3Zr19ZwIxqk3dx4bQzRLN470SnYZ+3tMGNSte2BI4zKf2yHxYJ8JHdCTpwzXVR5swnJE3X+Yn2YvcVaNONXGXshE1xwoMzvYgS8LT4ueDJvOYICSmBQI5RRYcvsmQpa1+EZXINQmko+DjBktnfy/xUZiTwjQyDbfz9QmXicZI0w1BxQwpE6EJMBndKuezL7tcvLtLctsQXAbZc6y24C2nII8581quACOoO89HI8Y0U6ku2HsLjv05Mn3Sz8nfrm4OCTTy66RjSWfjSHcsJGDdi/zgetlJN8Hj4WA54BE0PZbEv2M9cLQ2rGRiQckzRYSm3kMRtqI+GSCHBj9Y0XtTsxnUewNPs7HP9r/NxtqQPrs5JXT3qmxGtVNNX7cUKBCslk63TqjTYQjeUbnBuzxICF3xZNUQB1wEl2RzF1X2ocaUxY1wvFx8P1HHvu1WxcZAZgJ40cEDDk+bhF98XGmfELGurmBN3yDXa2MmgBk3SDhcfs0kGJaJYQe4EsoDcOGG03xdxz/OzHlX+6Z/8HrxRvkaMyywA79SF3zcR2N77/v4yYtP01yBTrX6HTO6WJsEKDr/f/lI7BMt9CYqjPeeojTajSCoYQ07Huhwj7nKrkD5F2iDhU7zErlybPfC29JrqLJy6c9NukjIKV11CmtsScIIhWLyAawTGPK5jJ6DWF/dYZW/QsK+68gw7Wbk8mbtoVMj1Iear2v8JFSsoT0xLWw/dygNcPN7WJLDwgYg2LQasMoszUy+rxLaqzzKQSOTT2mGyTiWvkDMk9VNJc4mSGTlm/BLK7ympxT4hno7Wjlh6FfCvDwsVylZwm9t5HQTRMm19sdY0IUNlfP6wN9Q8B2R7U0zfpWqw3BZn9k1N7xZxMN3+NWpVIYHrK/RPngxp/J14WPgqx6letgLozXwgu2Zjvf
 wCoS1KAR
 jubqGR36r37u+SfH+JI290gFabHVhqA0bo4eXtLrMIwvnP96/64TiNcy5M6bOE4H95BOtAOzjeiqY9uq5sXTDB1M9jWP6Qo4Hf703zlw8eS/rGEQ7SzK8nmvLkia12q0wwFTWbgK9BH0WZmfPMVmzTkbxFjsk14hzP+dZ4u/EjBtL7StBoNSwVnHgCIPMr7VTDt6aOWnptKWE7TGVIoX2jDxl5XrDpZoG7HNEbKDbVpIuACDNX9oGq53S3zmnJXqKFkNNVTRkSnudVpXGKvaK3mtr3blD5IBZxAJqSanUguUcbgMyj8GkABqgfKeqWSt2TKyzDNjBzEAlZCA7bBdXKRuMifP8HY2fmjXvFRf13/oyBe4QK7Hsly+P/FlYcV9P3thTcCOy7bJt391opWiXk3sdZrG9cyEfdum+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a0a419085e28..cde43d822f8f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -783,11 +783,21 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	struct luo_file_ser *file_ser;
 	u64 i;
 
-	if (!file_set_ser->files) {
-		WARN_ON(file_set_ser->count);
+	if (!file_set_ser->count) {
+		if (file_set_ser->files)
+			return -EINVAL;
 		return 0;
 	}
 
+	if (file_set_ser->count > LUO_FILE_MAX)
+		return -EINVAL;
+
+	if (!file_set_ser->files)
+		return -EINVAL;
+
+	if (!kho_is_preserved(file_set_ser->files, LUO_FILE_PGCNT))
+		return -EINVAL;
+
 	file_set->count = file_set_ser->count;
 	file_set->files = phys_to_virt(file_set_ser->files);
 
-- 
2.53.0


