Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CCDEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62446B0005; Mon,  2 Mar 2026 14:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19B36B0088; Mon,  2 Mar 2026 14:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2196B0089; Mon,  2 Mar 2026 14:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E29B6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:34:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27A9D8B170
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:34:34 +0000 (UTC)
X-FDA: 84502124868.30.78D00B0
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2CA1A120004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:34:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W8GEjMfv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoMWMeFpV+41+73EqmHf5v/mpaZlLM4LbfRc6LGuF48=;
	b=hc2OzOXJVLGB+9TG60c99A3RA7bpptPs3ujBLDvmIYNydnnIhXBiyq9qQrZ1G4nKGSClAh
	/Y8n5XX9iOesoALomH8B9Ji7BosNywEy9g/sNHzr7WSlGYjDFT9iJMrIUfVHd+HKO0Pkdh
	xkewg7Dtey9/stdWpzletj3HzOTHlso=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W8GEjMfv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480072; a=rsa-sha256;
	cv=none;
	b=5SoZN5FQnQouA1XUETPkOl9OJCTLSAI6WMKFUVJbloYUYVQjrP7xNh54jQ/ceCx+fMurvi
	LORJUhlfC2zbdy2zNqiH75RTP1Uu+5h5zb/w8VHT3IlqQC4mtQXC4LBMA0Bk1RA5v3bTb/
	7CzeuG58wo65vIToEIhJMcqgeiVXqdQ=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65f812e0c83so9148960a12.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772480070; x=1773084870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PoMWMeFpV+41+73EqmHf5v/mpaZlLM4LbfRc6LGuF48=;
        b=W8GEjMfvDqN8H75nQI8Sa7OkH4rjk4gXWPpto7OnapeO7hcwcmi6D2+kMJGh8kh4GI
         Jwytx3XNMJVtrKySAn5HeKOQKeWrqz1Jes3qqv5IsY2g+8DdNIcXK1cvWQm561AWY+l2
         yFf6K7qRVYRuL3iWqyJODK4iJrswnYFp6QMsUNW2a/FtFwG9Zh55CXuN8xyqgLY6uKig
         U3EGeUygYDhQk5n2m1GX7NF2xGg47xIKB9/jZBa2fEsKPOWPLwsvNCtQBCo9MHnbTeN/
         ZibzNX87RfsvErF37bqaSAOlT4tTWoWYI3jCZEx9uUNGQ+zUgscOnjauQNe9w6RSpLTZ
         vuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772480070; x=1773084870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PoMWMeFpV+41+73EqmHf5v/mpaZlLM4LbfRc6LGuF48=;
        b=HHFwYE+fhCX/OKh85jOtkdJNUvt4Ix3dn5vs+U+cxD99VOmpTrhaMMcuziq/RJ23pn
         v3CixdDusf/krjBIIi6IwJqKWqtEXDpeIQMnTlsef4fZt5ng9+t/fPinnsjaEsRVqJ1y
         E2Ko+m2K3BBpaxkudXYRpOafkuiCl1c5iGBF875kWIErDpN2gEXHetBX74gdhL5kZhWy
         SadYo1SDHwoHY6eODq69homkjZ0ycm4m5sep/e0fRbHusJSxUJw7QvSpHnWSY2YAJXVf
         F5l8EyWLSPh0Ev/Oj9sXE0kD5M1rHX9y8XxjqifYtCTWzaJcwpjd7bqkP8sufcY7kMqY
         iZZA==
X-Forwarded-Encrypted: i=1; AJvYcCWbHEYbSGyfcSLDmE60f0ziTmZvj6RuoBbTp9baojbl3UR0IPZNBwTQ6XxW2iru/tWnAOmtAACupA==@kvack.org
X-Gm-Message-State: AOJu0Yy/PQTrZW6IfYaHIlZwPXJJcKsvWX4CfebQDybq9qbaVQpDUnxb
	DbiGx+0A9VqphwH76YGE3gRoBilFejRebAC7kt5PXlsw7feGUSn7durf
X-Gm-Gg: ATEYQzzd0kOe9oH5yN5dQUlR8e41nQY8IInpwmwT0GAeZ4hCMbKFODhXyW6qKc365nw
	304K2Jspr7gYJloM1fMAAwfoWv0aWtsTS7Vk9nf7UwXWHLD8hQIpQUuCALasUVddtxqJhlABMR5
	6EupwqQ+Y7/m/G/z2zXm3dvN5cRZPAHpFTWtkFhttSxQhHp3dV2+cBR6Xpw9/BUrEztopw+TNH/
	7DTDCETdCbI3eYSQmiBTDTkCD6qKBfWNYycriF8cF8LnS5j1VZEpSs3tTcGcWiObAvIZ4r00PNC
	34t1Q9QERhp/wyHF4qhKcRS/qBRBoVrcba3z7rdo5KN+A/VGrgrg5PLVwHQS9+a/q7ABLG4CxN8
	SUEIIyOUV2PzakzWBN6yB4SotiRgwu84SjWHhQkiXj+FAWWDMKpMOk2nxWdZAIYEHNKIfc6J//B
	5fxiSjlwWO8/n+FDeH3L12vYlt
X-Received: by 2002:a17:906:c145:b0:b8f:6699:a036 with SMTP id a640c23a62f3a-b93763a28dfmr864928866b.19.1772480070292;
        Mon, 02 Mar 2026 11:34:30 -0800 (PST)
Received: from ArchLinux ([89.105.203.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac51843sm520925466b.16.2026.03.02.11.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:34:30 -0800 (PST)
From: Alexey Suchkov <aleks.koyf@gmail.com>
X-Google-Original-From: Alexey Suchkov <dywoq.contact@gmail.com>
To: aleks.koyf@gmail.com
Cc: akpm@linux-foundation.org,
	dywoq.contact@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon,  2 Mar 2026 22:34:05 +0300
Message-ID: <20260302193405.37961-1-dywoq.contact@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302191237.34375-1-dywoq.contact@gmail.com>
References: <20260302191237.34375-1-dywoq.contact@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CA1A120004
X-Stat-Signature: u6q3kfesox551ynxkaaeuzc37f9fhoky
X-Rspam-User: 
X-HE-Tag: 1772480071-265595
X-HE-Meta: U2FsdGVkX19aW9XgymPGydhvrEHrrwKzX2q7J8W3TWVGaAIW8N4ftCLZUW3hx+6K3pdv1goiVDfAHNvxUg5p0asrtxdmW5O1WzqyiRtOJ/33tq8NB0S9O59jF+M1ICCs37ADKVb17EHsSCTK7cLL8hUa07q1alc6DZLu7l2yMo5NGu59k3mLVmJ9kjEC3WOdfs9qxUE0Xg/Ktr6htgXSA57vE/j3Lqkfi/tjYn2hDMzQv7xh0AVyZpbeQj/Sedu/N2ymKgd+uo6ipYEn1kGnKfwFPCGogovrNv46Ufh+VDPkjvnXJYg/ELIX/B3Xzjslm0h0rnySdBfitYVlnsS1teD8Ghv6e/5nIsiYOiDPy3nz1CU7Q3x3baKNjEL86BmfHCsXN0IAgaUtoVsoQbFLGfI9UBqZFa6D7WYM9n1JgwuhOoGRXqyzplFhY7P8YhVwEjD/O4c1B7K1/i1iik10yslOCZbWk/r/T4hCvaoQ9O9igubrRpTMPKtOpXn1cpELyLZsiiWCrblp/UCfiE0PxnDsSza2gXi5RlFYV7+TB3Sfyx4epQX80IOgt4HB9U+JlqkCr/kV1j2VS3pxomYAU3FVpvIRl+ZqGPpkseTJNpkMnjq2lpyGLITOyFXt0SYzAb2qEZmnHXAcTChs/czsJc1JdJeyzpU22YYMwQKG1LS4WBeW2uS254ik7n/5+4ng76xLilObM0Xh7JbLZCII6/mCXQxFKFoH/gxJORnsSC+FFOMugiINUY43vNS06zuf8avTmk3Dpw/RGx3CdWfa2SABXfNSycPmwhmN43BBTmEROctSKv06b6tQZlYcHrGnv5L2lJfhhz09H8Lt0n+I7Nbfm4mDQfXQMRNYmLZKcrHgSTR9z2DsAwc+em1PckIKv8Gb6VjqItf23+rLZu/XdZ87rpbQG4H99eyNR3UzA1GT7g10IinteSMNYgR6uzdUeIAFl7LjCtCOZ1lCyYq
 V8KwpEGv
 TNf6nYFBSCn6Yo2Q9XOeNkHmGIFWQwznDaTWAOblwDqMP+pB5s0cf+KZfrv/bJb6ArDDETBHUAlC1ZY4ktlRxyZe6gFMgUs/0WG3q7zmF7/2j4Yd65SpqwPSBkgHGvW/oLzbysHDQQaE+7D1479ChNwlHt5wm9H7fjOwr0yqdXdDiUKDnNGaabSfi8f/68Kr3Or6kouzly5o1yoMtR3obuKAhIrrPXhf4DqkEGRqejZpav9OhruI79KLGnCDaokrkhfPRMP04tYme1yfaCyT2A4OFloA1Ag16kuQ0fYHq4o1uE8IVSQQard4znFuRaBGTr5VAEU0h0kUrEdHrD2Iw/e7IM5khuJqHrmYYpDc0GPBUe5w6lJnX/QFXQz3tpM4kUcSDI8aHey/yHKvIx6+vl7Am7IVEA3fihK/89Nsl1Riw0qxkcqxmtHtm4KZBDJLzgc2xD+dWuYzqMS1Euw8T9Nezervxaf7SLqvuCyrxjiVKl0npxA4NUI4sKD0U2GIgRSePDkj/reUwONSSYtfjmlYdtRv0mkhnYBFjdKdSPd54M2X2pSGeK3hzijWlMHjO7EQV/uFh2ihi4vV898gTpM6nkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The local variable 'seq' in gup_fast (mm/gup.c) was declared
without initialization, which can trigger:

mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized]

Initialize 'seq' to 0. This does not change behavior, since
read_seqcount_retry() always writes to it before use.

Changes since v1:
- Removes the accidental formatting from v1.

Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
---
 mm/gup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6e..879798de5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
 {
 	unsigned long flags;
 	int nr_pinned = 0;
-	unsigned seq;
+	unsigned int seq = 0;
 
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
-- 
2.53.0


