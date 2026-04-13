Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1C0F531C6
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826776B00A5; Mon, 13 Apr 2026 14:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6DD6B00A6; Mon, 13 Apr 2026 14:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECA76B00A7; Mon, 13 Apr 2026 14:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 607BB6B00A5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20C0AC144B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:46 +0000 (UTC)
X-FDA: 84654426612.08.81191BA
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5318D40006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XMnIH8XX;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106304; a=rsa-sha256;
	cv=none;
	b=BUIWMb6vSnJVC0egqPbrxszeaF+xz4Sn1iNcaiOFYthwTvBox2yLx9TiVfOt/ozB6G44mq
	YqiTq027MwAvsicc8LAVRFVqSCHMqSxJgb6GPt7PKMZi5DFRBRPerH+PLlni7JqA/KWE8U
	qwurGBGlQAps+Dpm/czMmKcJStaBUvc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9T19sIzoZYsgH9efdR4OU8RRGWUzOru59l0S18klbK4=;
	b=Ik0F9Lken9EjVHq8K6wJ182crrwgvvsV5TsiO1M7AKr8aPein/ijN9vgYJIcoHvzlE4FmU
	Ld1/A9rLpJPv0SPgF+aVn4ESxyxSWut0DOU97gEWmTatiX/YS70odCe66qf7neOFPNpsVt
	vXUL2BURVZft3BCbL+Arxk/yNczGPbQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XMnIH8XX;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d68f702851so761103285a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106303; x=1776711103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9T19sIzoZYsgH9efdR4OU8RRGWUzOru59l0S18klbK4=;
        b=XMnIH8XXPwyeZEMBT8eEgT/A1gLeYT1so999r12nuWdUmc2r0AERBc5BHfm+LYNqQd
         xKgksqbXjred0ayP9CBmprpr3M3PWffCuZM9tyuUf9dx4leBlZSe5RDKWAnYhhmOslZm
         rUzPjhJMHBZrWUjuADoZmsYPzr4c8ArqxQ/7Yh4+cVPU1t4qdDuzw/RNDF8n7iox5DEw
         Uf0ke5PJ3RfnjX5hHoNEZZz2GdhE264TSMAd9kJAqi78FcYFNiYbFZKDPzWUu71XRXcQ
         EmQgxYaHt5jkpzkfwNFfjSiDfzcoQVjtMbnEvTxnnhXD03pdCBQHJsFtQvQYw+n5rdeT
         oBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106303; x=1776711103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9T19sIzoZYsgH9efdR4OU8RRGWUzOru59l0S18klbK4=;
        b=p4OCz7SHo6yWLsefTk4miBUcbSgMc5TudeeBmh5jPwhCNAa09V8Lg7lA/b8U/n2J7F
         QZU9bm+PP1kJ6xQzOveyeN5R6rLpUj73CuQPcdzWmS4m+CLPgdgNOn283rMeuNDLi5f1
         739hqbhRo8Qq0b4LWdJVDk3UzDT6HGjPhdRZ2bO8e/je645OSa9i4e6fl4tSEMKVWEaN
         9UFvlvAQCzDK79uiE/by8xrYFV2gJmLbnwPpvsmQcZS1DxmOntgtm5VG2VNfLA5VQ2pR
         rgQxiYQpI1SB3LEQaS1jDzuDIR1V6jmZNN2uT59dVeYNd+44SHGr1e53+6T6e7/Iw1N6
         mBNw==
X-Forwarded-Encrypted: i=1; AFNElJ8Q2Ri2Si+w83l4R8NiJG05oiXZ1uF2/Qq0D8+5H+rQJQfn399xviq0XvgqeoLuwUuY9CKc28JUMw==@kvack.org
X-Gm-Message-State: AOJu0YynQTGRHKfS99eN4Q5doW2uYMYFXmWzU6///x6bnYv0zvDah4vZ
	EFexlMLPlh22z+dpDv4XCVR0XPw9uAnCJuaRuRbTCN8HvypMS00h7n+jOjU2rbaRRnU=
X-Gm-Gg: AeBDietc81NCYQVhPl395UYYFqdnlJd97ndEAYvLE4Dl4EuL2p6mswEFL7bKIbU3US0
	sqMmY+O0s2ORvupY6RQ3oEhYZwmd4w/4y43uNIMuetOv1VqXls8HZMHbpJyURoiHZG4R2irsxU+
	uPf7K9SBIuCr/M3ibd8OrdCdibWWu1z/jKIUD9sYUsprrEQzRWiaQ9Ps+MFNC1MPtMP0kR8QWl4
	oVM6S/tps3YxT96/jtCDNOEPR+O1pUMjJ3q/euqTGqBEJV+75+gE2ket1eY7WVc4ABSQVZrbIJJ
	me3P1Zbcd7TDqoag86ohdUrT/9N3J4Z+UQYj+kveUn5sNGfdW0nXTEDHLvtKbjmggRpmHLdnPhL
	1Q5Spm+XkXO0u4eG2v4IJiF/FiUa+EFeyxcKZheHIqC/xjO/aYJD62CrQVwSn2pmUMWw8uVkZMz
	F+l9U5m+XuugtLj7DlEZXdksB0Wi2fq5MBwJLxvzoV94TZz3VNMp720IF9Jl+X9ECaTg==
X-Received: by 2002:a05:620a:400d:b0:8cf:cf2c:e003 with SMTP id af79cd13be357-8ddcd02470amr2028285485a.6.1776106303300;
        Mon, 13 Apr 2026 11:51:43 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 11/11] liveupdate: fix return value on session allocation failure
Date: Mon, 13 Apr 2026 18:51:27 +0000
Message-ID: <20260413185127.128180-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5318D40006
X-Stat-Signature: nsodiqbai97mrf64xxxtyjt8tb5ts7ob
X-HE-Tag: 1776106304-20668
X-HE-Meta: U2FsdGVkX19YcwQqBD0s62F/q/fY5aT6VgwQ2rvczlLOUF1ZivHw7Gasii/ucQ/QRqE9nNa+a6vueQo4/yznRDfg2BxZLApbwT9SHmzksuRGE6/2ScInQBilWM8HKU56DaTUH1XMrpRQCKZRHo1ehphuHK2XXGTQd7GMuTgQozuz5UIn/ttkOyl0X80fWEG2Sm/NwsUqoqh6W1w1s9TfEGv/kKPNAjAFA8qrrY5okrgABPbgM3AubbO7HfxCGPCKUJ9AdIxHoPxEl6obwf3VDnQNAyAcmb+m24+nxOolOu4CzgPOhyFX81F51xbFgcm1dQnQU9kR1W4KlofEFFyu4JM6U31EX6RWl7IfaTheNaOHnHom/w/tSAmnmdV3aaTdw8+12/UFMC5ZUw6tw+moQntWv1Jzvbh4hVFH2cHdbLpxYiBa1iENKHnNe/4E/MLLKMgqJT6yteQXFnF4jUifoZjMgzGQwGX+CEy+OQDstv/Mp2JA7rGlNzHWIaclx/VopaJ/Fx2p3PTs+Q7AU36Nfpl9KKaBttMfAWkcnTeoa4wympoqKA3RAhQr+6UkTSFmmWHkcDAcmHXR6lYeChRnQJArrZqnQtvG0hG30ZBUBFMXIXlr+IHFSEvtGNIgWmVaL+hj4vaFNUP7duBaL5c2D2tS4pL6zy96k5hsJgCrQ1PHLRaCYbq0Nr3sVZhFMuG3RtHzQEA4PSeCKxYEfayXz3I9ribdVP0X7JaY0es3+u1RKQ8GCcwvypg0bGyXyB/enVX3ubAeJB84VXpuTCPFlyVb6iKbh0JXOsRAvChau8fOUvJ2rWIP/8oLazXmtOckaY1UhZVDIIXG5vi9GEJ77geLO93xw0EYvEviPFxrf9GU186Vyy6fHEUKKiX7hbmDgzzRBzBY7eVKu6cXN6kAXsiSNgWJDfa7m31l/VUG/43tCnJW/1CGFpS4811oEnHSTVkobNbdetGK1N+xaqM
 QsOlAA5H
 0HphqhFFqUeqsJW7TQ3SdKs3q21eIT9jcU4+WeGFFhZpHK1modCuUJuQ4x17EOz/LANriFpKXG00ydzmye0qIhKTnwwK1B39GMHgLsGkanSRTGNktjyxo8OiCdoRNOCS7fRti0Mnbhzvy5z6YXUPW37+JAEPYnnY2wi4UVFrnF4Qq1RYWWwWMyuCdkGj39i+3moZAMDvIsRlC6pobAVSA+B4/AtKZPXguuvOnT3AFAfD2gP6wOMqCkBuHjy1jcrTfEgc/r7USmNnjb1z45GjxIi/U9fHuyresWngeQzxMo2v5aLjbSPWskqh5j3HkbjMiM3dXscoXVpu7qQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When session allocation fails during deserialization, the global 'err'
variable was not updated before returning. This caused subsequent calls
to luo_session_deserialize() to incorrectly report success.

Ensure 'err' is set to the error code from PTR_ERR(session). This
ensures that an error is correctly returned to userspace when it
attempts to open /dev/liveupdate in the new kernel if deserialization
failed.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..92b1af791889 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -547,7 +547,8 @@ int luo_session_deserialize(void)
 			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
 				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
-			return PTR_ERR(session);
+			err = PTR_ERR(session);
+			return err;
 		}
 
 		err = luo_session_insert(sh, session);
-- 
2.43.0


