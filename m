Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158F7CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A196B0096; Fri,  1 May 2026 05:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661966B0098; Fri,  1 May 2026 05:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5782E6B0099; Fri,  1 May 2026 05:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46B1E6B0096
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A8531A00FB
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:51 +0000 (UTC)
X-FDA: 84718379382.29.C4ABE1E
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C44880007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RKd3GZhe;
	spf=pass (imf02.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byHariOe/418DnHhAYKU/dMJ4rRms9bwPBY0UESk+2U=;
	b=hpb5C0n427lM2B6EDXzbMM/CVGA/JEyEmZ61bemy6vBwPIFXqZ5EDXv8vKzqEXL04rWEly
	qsVmOZYpSaA4Im9kMaKCjtO1MV9BZb9Mb62fAyInfXnaik+pDEMlzM9xd44rE6PDnaKMW9
	gJdCVOS4hCgz1d2iDXFaxcNQ/x0fNEQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RKd3GZhe;
	spf=pass (imf02.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628989; a=rsa-sha256;
	cv=none;
	b=BSWOxBluZ2qAdOm2X3dl3DvmbFWDzxcCzBmllbq9aZneQ/QkdlgJzNJc8HHwOb8lzaO6LA
	kWgbcq5nKvVd6IP3thq8QsEPCUYFDnkatvMvvsSzjj66umjU6VRaIhtLUNvniF6j3JAggO
	BO2IlyFyjr6uZqB6Q7sv2bFikQOSPy4=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-824c9da9928so869755b3a.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628988; x=1778233788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=byHariOe/418DnHhAYKU/dMJ4rRms9bwPBY0UESk+2U=;
        b=RKd3GZher90Ds5540dfKQwmpsV34HEQwKVeaA+clP1yNJD/Auc1CFQkudKZHORwgeh
         UYZHgcYScrDWX4h5VA2R4x6iPrrb8eQsqd8IkWrl1sOX9cs6dzt6CofZnP/ukpUtX3Lg
         8C1rJAqyqOP4i/+UtpCXrafwQVv/Ob9JVY3ky8yzv4bCULI6IRHxE7dfmi5Cz1JiHI8H
         t88PBKwLnKIkAxza37NEWJY/m1EEIZ97FwFGiG3zQQUjquL0tokiBTaXvekrUXbbKdAT
         m1AjxDkpC6ZyqHrNb8G3bcxDTVP1iXd1EBTsMgkEAStgppHy1BMUCX8zceT7VcNVxKRb
         TgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628988; x=1778233788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=byHariOe/418DnHhAYKU/dMJ4rRms9bwPBY0UESk+2U=;
        b=QaUYiv1wkuQlC0ALp86QZqWgsLhpizR2ZDw9X2mAUm4z0mU61LCv7oO939rUGhC3zs
         chpAdIIoDh05SvZCmHVAhyVolI39nKpoU5TLHXn04GoOsLS3HWoAd6ouorEjbK+W+SM8
         /PXtI9V3EtHvz1UQrOEjoGOBILfh6tmQqoT345QOoyP4XdwvMJNX7y0zeRbcD3z4fjfd
         k2n+FOnXjafEzlLq6ggYxFITFBb98PjfhD+9ie/drV/rQ5ugwg2iFQLDOXti0zp8W62y
         E/srpwztWb8txBWZsdY7dxPdu2VpyzQY4Rw2JaOW0z3AUCUhLpaWRAXunP8x6QdTa/v9
         Sq6w==
X-Forwarded-Encrypted: i=1; AFNElJ+8/oUyR+nsbu1SxKn+CWU0VEa26urqnyRzBMBZcqvDKw9I/2bafbma9LeN5SegBw+7HgHo9wDQ5A==@kvack.org
X-Gm-Message-State: AOJu0YxxmuOrS7Rf1wKrqNgOUQeDU1S3VcklHHP3+emP/VyNduAraKX3
	r7RJF5Gey3WAnks/iVQdkvICqwmJkD6Ewh0PSVRdUz2oCg2jgQb1F/MD
X-Gm-Gg: AeBDieteeM1JdiCiZjpQwdNcUlfjybxdPLmCte7TnL0rsy+wC5KWNkrjgBdLgydmnCm
	WJfNBvOv7Ix5RpHFM6ULcp1TX363E2cKo38/a0zYM/hNstJHu5y1J7gAoPI4pcnd6o4Bb8SOLNY
	JU2H0/GTHHiHnzMKq103LzisOF+5/AuShrbEJ+0EfKZI5Fc297i6MSMg7WjHRJilEB/yXVPicC4
	AVChQv1jIKu/d1CJWqdp/9u9Fca9rku1n44nDlzAjHqMokUKfwEUEO2FTDMN0q3oWUbkjN0CAHd
	u96HldtN3Q/81HUeWGdy96M6pr/7SLPvxWRLl2fHXF2vBicAyG1DCZ8dGpgqbtIdW7LKmZ/8gv4
	ocACWyJymHa7AY2c4oV8UlgLkIjOkRCpkLZVW8f44OqbMJIJ4UPLHRknqDooD9xvw6p5pKnPRvv
	NFgSUtlcvjQmwHgQP9ETrVfaHcI30nukI2/6BS/Q==
X-Received: by 2002:a05:6a00:3cc5:b0:82c:9c47:fef9 with SMTP id d2e1a72fcca58-834fe05cc9bmr8047701b3a.2.1777628987950;
        Fri, 01 May 2026 02:49:47 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:47 -0700 (PDT)
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
Subject: [PATCH RFC 5/5] liveupdate: validate restored LUO FLB metadata
Date: Fri,  1 May 2026 17:46:37 +0800
Message-ID: <20260501094637.38650-6-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C44880007
X-Stat-Signature: q4rgcyec14xa5kfx4xgifcboxh8py8bx
X-HE-Tag: 1777628988-225775
X-HE-Meta: U2FsdGVkX18pZyzsfkd5jWWRw/pU3lnjlv/Z03o1EsUD4gNwAT2Z3jkoKel0eu9tEIzNGdDWFW8E08UUFNW/ixgH/sXe14TKMh9E/jsjUqQFdrKt2EPRl9eiDTkla4EzEbdqeGDq7DZgNLCwKbEzXQKxGEo8Fn3vVGbAVLNjb+L3ki0UDQL4dygE0pUyMHNHMSPcY6AGg7t1dbmaZrrGHmOnjEYkWtmHHQtYRjcF8RrOZYaEMGOs+200yudpMMVzTNejVBYKGoaCNLNs0UEEs+xUfx1EHWjCcAEEqPkr9gjdJOeD4eZMUvV6Pmed47E26IxLrlooJaFEtp7PWha2h5GRLu6hvXIsuyzkXhq8qG3cV7YLdQJF32mQwrHy8SzGSdYqryT2HcIlYlC6OtURO0CzUmoxoTO6VP1B+69BIUGs0aIgJ8SZjkSUipPNKdt5ibaVWqcOk5hAH4bdHK75FWs9v7R5d6XVlnaZMDGBZ/OVWYECJrO9yL12H6TxH5rPik3F06QcjbOKr4HRPfUEuIri+gcIlNHSY27tcPIVWzmru+MXpPcZOgQNm/Hh2po67H+HkjCe8lRobRDYUu+PhiHrSaTI+2QxgH2sJWMSTLI7e9JqZ1FfwgJoUXuM6WKI4alvSa3fq4dFirnv2SD6cD7UkN2Of2kCcuY+wcs20NGsh6sbm5eDZ1C9L2c+Vvodv7hd4HmZX0jSY9XqAqVvxfkr3v/Zi6fBo1YyalNItg4ASKXh1u59ZUSgqfJwuSZBJ0RP6qGiJdfxzmOew1VIgvu1Et+5dLS3bGXe+hX7j5EOeuNhMCSEEsjg7nKhjy+HImiQCM4ELbMvWOqQR0EKSJcqoq04m3YqXx9fvpAArWVDB4U73l7TrPWvSkIE49DhqPID7VpidFd3UqqU85+NXbso+55UECBQE5HW5tCllnpo9ayo6fmIy7kl4NSjT6odfGSPO5YCcMG/OuyeX7K
 MVxXJKxF
 OcOPAzF7PS4isrDwdDVvxll0jKCe5qfJQVkz+uw8kbcyqQZMjawgTPhf4axdcVrxBRguXRDAaLgBibq902PL1uk4kC8DUjOaq4yuxKFjqmebGLUjWdv4DIpCTQfrLfjx94+7TkRwPgIFJw+KmRNTZvZJ5mLHgWW2wvZn8O28BjPkXISwxkBfAgcMwaqzFhibviviD1Yrhw5WpI5k1QIDimFjU/kfWy72kfIQd5q0ncQWPv5xhjsQBNHJQRg643jjg0XVQKZ0eEZrM08koj7vq8kNE+j++my/8y/Fr2r2UFlszFNRQW0ohwCptc/9QNST6tcV4/BsmcNy4fL/HvyxdcEt1yulQrfq21gIWI12Uf/XnPwuSQVjt5Lu+Fuzpulggku6Z7IyJANcufmearFzvGVY8vw84jC8P/jjN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_flb.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 00f5494812c4..e80032669cea 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -162,6 +162,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	struct luo_flb_header *fh = &luo_flb_global.incoming;
 	struct liveupdate_flb_op_args args = {0};
 	bool found = false;
+	u64 count;
 	int err;
 
 	guard(mutex)(&private->incoming.lock);
@@ -175,7 +176,14 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (!fh->active)
 		return -ENODATA;
 
-	for (int i = 0; i < fh->header_ser->count; i++) {
+	count = fh->header_ser->count;
+	if (count > LUO_FLB_MAX) {
+		pr_err("Invalid FLB count: %llu\n",
+		       (unsigned long long)count);
+		return -EINVAL;
+	}
+
+	for (u64 i = 0; i < count; i++) {
 		if (!strcmp(fh->ser[i].name, flb->compatible)) {
 			private->incoming.data = fh->ser[i].data;
 			private->incoming.count = fh->ser[i].count;
@@ -620,7 +628,20 @@ int __init luo_flb_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!kho_is_preserved(header_ser_pa, LUO_FLB_PGCNT)) {
+		pr_err("FLB header is not KHO preserved: %#llx\n",
+		       (unsigned long long)header_ser_pa);
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->pgcnt != LUO_FLB_PGCNT ||
+	    header_ser->count > LUO_FLB_MAX) {
+		pr_err("Invalid FLB header: pgcnt %llu count %llu\n",
+		       (unsigned long long)header_ser->pgcnt,
+		       (unsigned long long)header_ser->count);
+		return -EINVAL;
+	}
 
 	luo_flb_global.incoming.header_ser = header_ser;
 	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
-- 
2.53.0


