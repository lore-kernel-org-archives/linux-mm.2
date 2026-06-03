Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9116FCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA436B008A; Tue,  2 Jun 2026 23:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C216B008C; Tue,  2 Jun 2026 23:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A6F6B0092; Tue,  2 Jun 2026 23:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5ACC6B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70A2E1C042E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:11 +0000 (UTC)
X-FDA: 84837170502.24.CE2514A
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9DB01C0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JI9lQ+jz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
	b=vDyJuVus4Kpqk96qKoUxUOvzY09lGjMljzPZenrrhTlVzdGGvduwZkF3amfcYdw+dkRC5p
	aOVMCSEBauH8MlU88JQXBQuxwGjCjgb7s/HqmEAgUuT8myPBoIgDy4amhcNjNat46YnuD+
	HPDajr5AmmQzofPMdTQanqcIQ5nSB5I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JI9lQ+jz;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457349;
	b=AOFeoqPgp4NW9Y3cB7DapJwfiEZjcNkRCn0nd+ZYJN5C+eqfnm5yMYfz8Skwmm4vpUhrFA
	LN4KrjULgEe6eqLB88HQoQVMFfVe8c8OOSkfDoN4e2QpTEIhqu7xyjCVCrT2HPzsusp8Or
	Qi01UA4/KY4CUx7AE5RASD+TLP3ya8g=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ccedaf0b54so27714106d6.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457349; x=1781062149; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
        b=JI9lQ+jzBCHXtp8yImaC0BiOpCeAcPW2qPx7D8p2lWdfZ6zRgBYGQqlFbQn8OpRQPD
         UdTq04BimQCSqaSb2A4BQ5MSvTHuVnRp7761vu6m6daZNbMwA0+s2YQbFWBefP7sOzU8
         QkXLWvJdX6QC/JMg7kN3NbT0h3jrqmaRsM6JpS7pqvPCTLq7ylKjzwSQuZo/aAQDGUF8
         6rLaFgerlr+SsVeBAA92ZlR3kpAzyAYTa6wR+BPB00CVCpPnMgbfDBRPRR50775W8xwM
         ns6QvTUN2a6nBgnnrzauoQAUR/eWXB20rUpqbMoVjWUynvf/Cazg2NgGa6ibgD4EbIjk
         wa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457349; x=1781062149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
        b=Y6thWnDqrNg326H9TkuVUkDahTqHi995BbQBxvdRZ6Oe1GQazK/YkbCkcn1yN0+DdN
         5tYl32BSsKZMOtI/9ZeZVQ7cWXQ8ehGwh0zX/L6JArZ/vV8tMKz65DS7c6axorpF0hg9
         D0jfrByRsDOUoQ2nV9yCdyv0PggWR3QEVPx8L5MBM6NSIu0pxJ2/uWvCyku9/nVYU30T
         1fGdYmO3YpPWd5j9GJJm6T5kXbqyLyahhBJAoVG05FI9ZK0MbsIebMuFUFoxnpXwO9GJ
         PjKvdkXw+qFJawx2BtxB/Vb5RZ6vSn+b6M79DgyPEgeb/iJrhJr1rPpFeDlqp1g32GBC
         H+jg==
X-Forwarded-Encrypted: i=1; AFNElJ/1NOjwKxj/5FWtboJlk4zq40izsuEVgkRKSdchljPNkF191oyjdxAnroEbTMC2wOvCLlctSFIIKQ==@kvack.org
X-Gm-Message-State: AOJu0YzRZK7NNXRtiZjYSE90tXIFGB6h+yLw0n27QKxEdPMZpy3hEadX
	XEKZKaCqf/iMGeET9rCk+AX1g6Bi3qCTyi9iXEL6If7xrH/jUDy0H74ALDHCrDHZfQs=
X-Gm-Gg: Acq92OHXeO3enBJ1IdAUSfw9Q3Ct46wP/fJ39iCDG6/g7KFKIMYoJgB26tsjxBsku4q
	XOgzC8LlkPg5vOMb6+7alyiRYbk3jKNwnhGaYLv+QqpBYQFPajkjQKcifgsNyWqmWKIQ3YI1xDX
	mgcpW/A/Vbv9axlPN9a2ZmwUtlbB86/1O8SokkbLo+GKEK8D9Vx8yZWx2V+s8NYSTTUMuDdZaUL
	qS6j8YyJHq28N4kZ5Sv+66OQ31Iw8g2iyxgJOHCEAclk8xmjFK8lGjRjbyPgTiM/RVRjU7gb5fm
	dWb2tpdDIv/iybr9jWvEFaHRuW83zgy0zbTd0XYhjXDWgqONiuP+DLp+6CrCNyfYKQccVlmD66T
	VIu7ORyRo6mq87I0n75PZSloSnjgjYtBS/pdJJIte5btYjB0+JBTHP/crJyIA1E3wYtWA/C1igu
	UC74xs9rpi81CXyT9dfnJ8Z/FadbKKQ7fzi4bLas3lJxmDEUt6XRM9UdF2CPMwaQ==
X-Received: by 2002:a0c:f09c:0:b0:8cc:dfa6:3333 with SMTP id 6a1803df08f44-8cece028a1amr19783726d6.32.1780457348680;
        Tue, 02 Jun 2026 20:29:08 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:08 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v6 01/13] liveupdate: change file_set->count type to u64 for type safety
Date: Wed,  3 Jun 2026 03:28:52 +0000
Message-ID: <20260603032905.344462-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DB01C0003
X-Rspam-User: 
X-Stat-Signature: zcf99f37muqwibg77wwip33swpiwfejd
X-Rspamd-Server: rspam09
X-HE-Tag: 1780457349-411608
X-HE-Meta: U2FsdGVkX19zh+dg3Z22z0XI38j0gZezvIjpzddEVWW0LyJ+kPq//YcsD7coTP1qcX1wDXfDMeK7Xf+p6BvKWwIi/ulol3uyV7euKOsUEjMWKEY/ZPyvm9aFI1A1RSnKdenEdVWvX9tZTr6VpuRLtZAy3StTvgsb5npWxi4puYOqfjJcDSUGTqsQBbZEfMVO0KiPLkDmeqwLtxVVXnjBA5JKp6STOfbpCGYLFowCKXBXf1b83etQijbgcGsl0nr/c0kIuHuLsNZwmviiN+m7o1sQDcPwklmiGhaLUUkPv4zPEbt0OcBxwdZ7/IylGd6JJ5KWQoaGVvW3LlMA+5fY5Z2YwoXB1FlI/PJ8l+//JUSsAMDkKl29RU4U/Zl+owdCjn/Uy4zfnMLhmolYlXNyY/3PAyYMXknJZ2ykSBLk4v1DbMmsBBOS1ZYmLH/NPOLfWCaRl8ZpWSpqJrKH5wuZmQTXpfB2bpbzOzqMm5fzpyC274VQD+B43E2cQBwRFjV2W4sebheyiy3kIn/xOOt/HZ9G8mNG3e+F/hl1oYQCdbgd5oYDZmCi1Yg3GULJvw7ZATpGuTIkDwP2xjRiKeiNhX2Twj+74eQJiEmOjpTXLRIW2muWWrQJyjD4p1o/5VzLTpy+9chebYALMJuFgc+xH6tZqkPfmu+U+blxVOLvVAYvxgR4VO9Jxkd41KWPmtDgZ9M72RpT8AUOTOzGxlnH/4Ae6fWsPLhYDogGoEFdTXC/Rz1WjdCswid4eq/Z3CibgKJgsqq/dmw588Hl0dTCd1bToFTHiRaMIlfwmeihqizTH4S/Ghba9ChsHrVMJkY5FXKrG4nb8heSvPpOgQnoRsX1OkNVPK0TS/7OlmKyvEfVwpekQstS33/b4DcSHjBn8CGhs+umFgAsGomGWGqoRLnFPDhcnF/E3bMTAxtU5zlQAprikKK1MDhMc0Ctn0b4leDSCzC7GAlSKZsAtdV
 iESc2AIb
 MqLhRCCnWuynLyUnE86n+XB6fAsz8Hf6J0eYHkr5LAZQ+d8Am5StW4wqVF5sRaTWXdOJuB9P/SR+OTfJSAJKjsG8tmieC1hu29XwVkwejPeAIhnAVWlRPW1zZhdR1Eeg1ZdNVzjrOIaqFNtpE535BUUtGk/q8oTgDbCdyt82jMk1dMNphTbgRfg+DQlmqjT+AWA90SQ+RVPnNqw8X0qXpWr4rF2dZSwMPYamIEhVF/wJw6SmW/p6Mc3qH3jGDZo2e1oS2pjhFcyP83zYVDff/jvB+zTku3jSe5PrtvZljArzxrYXlJndeNLb5ScWWq60RFNX9LEzDUmcpE8xlYuVdr/hliGAgzUtLAVt5FGKC5gq/E75mXydcWml+TrW5ySnHTeS0xcNUv/Rlnys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This improves type safety and aligns the in-memory file_set->count with
the serialized count type. It avoids potential truncation or sign
conversion mismatch issues.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dd53d4a7277e..ae58206f14ac 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -52,7 +52,7 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
 struct luo_file_set {
 	struct list_head files_list;
 	struct luo_file_ser *files;
-	long count;
+	u64 count;
 };
 
 /**
-- 
2.53.0


