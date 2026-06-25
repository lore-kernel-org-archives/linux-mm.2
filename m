Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3BCCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067B36B00A0; Thu, 25 Jun 2026 04:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018926B00A1; Thu, 25 Jun 2026 04:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25326B00A2; Thu, 25 Jun 2026 04:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B23E56B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:37:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C1AE4063D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:15 +0000 (UTC)
X-FDA: 84917780430.30.F4225C6
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F72880011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gMmdoWY/";
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376633;
	b=I5qDc+0ba0NOII48SjAGy9qQuBeWOaXCxt0HjO7S5MrXEMf1x0J56fEA0KONlGWdsUnP1f
	yKtadHTH+2sVRP5qzqkxeAzGJEMyF9LKsNeZxebGnPcQTzAvm3Dq1dLGqkWJ8tpGI2Kt7z
	cjUS0rEQZAR9uWCdmYA7P8cAupZULBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Vxs0grT+d4GM87KSfFWu+blunYqTUopWsPT4iLI/6Q=;
	b=Gm712xDD/8TixmaNO4K4toze/muXc0forbocftrwFUwb6Zr0SnN1WhRIhMjShhgemcI6cH
	ln7zunfMwBvhSIIcKDs5zdEklIZo/7y1Q8t0NhNOB2ItMLWNj8r7yQsqrrkVZty1Pk2vbZ
	HVC/YO7WBUW+3n7SbupbouvLs+X2dH0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gMmdoWY/";
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46019edc13dso1194204f8f.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376632; x=1782981432; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Vxs0grT+d4GM87KSfFWu+blunYqTUopWsPT4iLI/6Q=;
        b=gMmdoWY/LjQb6t1aKUefH+oJ2HDCnxBmdWpqxMIQ7AnmIALubCRaU4cKlRL+sidg1Q
         gRIm2Ntlg/8etxzVoq6MrKkTWZv6aGMZCXgGNV4LBKn+9i8faxOvxQmo+KVw8msY6nLz
         GhXr94mI63oQOYX0oBXfmF6Bvqwb5QOz60rkDpbx1JoIRpvFzjlE8ZmOqKo3c0Bmvxv0
         ZUSrmi05NjJsgMjAVvq3pSmjwlor16gG7xst5UaVQvJ2P5fm1bbnjI7+WGmjg9x9u1Qk
         UitsVd6hbLRb9uVkTzlbPJvo8pMyAH/hJ00qV+7ZKQcs9U86iWuLd8R0Pjo3+tWynnuL
         YumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376632; x=1782981432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Vxs0grT+d4GM87KSfFWu+blunYqTUopWsPT4iLI/6Q=;
        b=kKnvlcaCx6/nw8YcuUZra7vXgdPS1CDF7TDRkXskZ7JQPx2qWd3eDEBC1p2ioTmjn+
         UuaE8jW1tsxdoaPHrOhBR7qltNooU0Q02yH3n0DdVfcMjD3YgHVAaRXwB2H3vVREi8A/
         xj+SBDPKsBYyD7RsZHNjaBSHiaFCH/Y4g5Kcp9nb3GI3sVhtzLHV5HBztZUfDJUxb2FV
         RIS9/8WC+RLOoDPfxpUKTW6qmAEooCDum4BDF7VsVLQg3yYMKS0sM9wXF8Pp6YkbnGg1
         jhGckHcxpoNrJKv1eFmGfjLxZjf1QYWPqh0HTjfxnAlV7t5reiYpCtj9TG7bCXe86ANW
         Og1Q==
X-Forwarded-Encrypted: i=1; AHgh+RquoUL0l4utpAFGsR8DtlOZTLeyiE+tvZ7JZCR6QlmB9L7iRTBO/IcJAVF3HvMAyMQJKMpjc1N6yw==@kvack.org
X-Gm-Message-State: AOJu0Yw+M2KZfejCDod+FGLWfz6m3C2ZXK10nYcTlu0iT6QlZ4LL5e1G
	Zxsu76sGj2czhUmdQvFBCZHTNOKp9vfB/66oKHAQ7csLk+m/nQKSgfLj
X-Gm-Gg: AfdE7ck+AmJ1yf9lX7B+EiTeqLXRU1yBKXvMZfzElqaKxMTrQnmO/gAlLTozkIvZCyS
	1bIl8Mymcbbunue5Y2qz7kW30/R+jv/DN8kLGu5x1jAz+UyDmNYxo7hLmf52npalyGFrj83OUH8
	OivUvrGgScPS7nr0US1xKpk3+wfQJASzVYVTwvEyXo6u8+midKaktoqPhunq0aBCF+T8rvuxrXN
	g3QJuxQdkO9VhYGnATOLtvqIONXT7uYbwBUm7Ml9PVMdqBKkwzKH0h22IMlWFiHRNF9LFZ+yAmD
	hnfCJM9UPK7nRzDvWBwRROLJ0yv4tdb/DhXDCnhmqOzY1Yeyd4l7fPwR+lura3DuX0G/MDAWxSN
	zrlGLTfacljmH6P0NKEn3fNpMJ8kkgiCeY2ngs/OAOJWoam8dWNzmcE0eB1ZniplBdKktVAzgsB
	4p5yjT8Urq
X-Received: by 2002:a5d:5e81:0:b0:468:4f81:5aa4 with SMTP id ffacd0b85a97d-46dc026de2bmr2181270f8f.10.1782376631864;
        Thu, 25 Jun 2026 01:37:11 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c221d93eesm13786367f8f.20.2026.06.25.01.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:37:11 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 6/7] vmsplice: return -EINVAL for particular combination of flags
Date: Thu, 25 Jun 2026 08:34:08 +0000
Message-ID: <20260625083409.3769242-7-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F72880011
X-Stat-Signature: kowpdjsxhyxkjdxd7ke6oo4is6yryppn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782376633-394143
X-HE-Meta: U2FsdGVkX1/LB8tHV0LCk+7psoCG/wk2ipr0PV7rKVSOO5xbwbbbNp6s6zAfUcZevArYq7hmOaPvxSVnWLaCEuBMfN0mGi+Dd1OINYt8WXGi20/3yCG/jkdogzgGWwug8g/ljPM0E3MUfTtm/F5lu7iQ8AT4Sl/rrEfy3Zrjt44IJiJRT2lNhLOAouFJFAFa4/ZwZGiJUySUystvDK/C2lG/ATHE1oHL2dgHn0NxZHgB7Z6M4atxnQ5pFAhMVwb1NoDcMMfIljSReszFal67kW0/TZ4uqJ40DL0t0x1yaIFINLtvP7qP2btO/i35BGdaJupuKPODc54Uu3yubz/kN5C1Ip1JjaDdX8nqiz/kzr/x+352+INZ0keL+hbznk8qeD3XH2msedNkKBdcxvfd7ZsOzU1y3nknosuX6Bw2x6+zn4IsjphrSdUYfUO6iuG01PzEjJyRy6qTO6N7R0XIOxyV9X2yOBRgid7Z2eOrRh5ZwgOWo+dv1duSbs+lNdMsYAPoY86KWdrbCPdgWKAcHCgw2rc61uvXAQDDHlIL4Hu09MvK8cou8NkEbsRwlbm5gjrqSPtXvTPZoig3VO6OrZ8WAeIop19L6KNSsGj/PqReorWfvRNIaK5AgPNJ2+jSToTvFRM+ZTdYgpvaxgXGFlQmTX3M3sBO6UmgOsX9thHsJ+mx+owSH3Rl4jwJpdjL3zJsRz5oeM9mWFzMBUXQK3VQHSwSmAVwfmpxVSprp3KmSA1EOG9CrsNRZfpHLICGnSziaAXEL35ALEBkWcMZgYktQZHg9fTwhk0Mx5mx0dmHjLGcxoE3CKyz08GrQiAbdXqjh4HdLK1k2z56UmOdDrJJq+WChXznPQ3ipIVPB2nJSJbZgfkC++kBmfbClmKHW83THqxKV6R3Z5MbkaqnyoGLYszhQtV6nMc1KYT6ygqnu0+a0x1QFrHbbEa6577f4psHBdiMuNpFASjTDRl
 DjoOfsIZ
 Lf/hs9stlGFoYuVwDUB/fpdWI3QSjsz8737G+2l+ftl7AXKD0qFXOxPU3cefBLGPrNwcWcoy6biixV4khp5V8Vx/9MlhR1+vdPhuDGpaW5sD80NqJI/hWPtPnG8f5wKT6PmTEo+2ZwblolOFouYjXbJDsl2ySwN9HUdxaYekV/MQAj05vyWADfJ8iM6shvYcJTPwQtVrX6eEg/zzKRTkyODrDLcOjuG0ao8bWlbVZ1Lg31Bpz8z+nVcCg3wwW/87x6OXwrBoU0ZawgdD1gpNIvwyT9GNwTFVQAnYuX5N6sSACXMZkekTw+QdbObHOPK7Ukr1ZX3WKFaGubs2sdhp1jvayCOz7FB7+HjDpQhsaUjTzSVNu9kuP/Qar1DDqC2Ta6HeGkprqRU5A3ODh4LFh7gNF++5tHM6kRcIJiOtvwSwPD7K7fxgn2oqPcu1wI2pOXmNDMQ215VXnLjuOm9t70vO+CQ/Tk6/EjF7+ywewRuv/7dwpIZ3lmILP4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

See comment for details.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index dbd0debc2..b1f71b142 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1258,6 +1258,16 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		bool non_block = (flags & SPLICE_F_NONBLOCK) || (fd_file(f)->f_flags & O_NONBLOCK);
 		ssize_t ret;
 
+		/*
+		 * libfuse relies on sharing vmsplice behavior.
+		 * So we detect particular combination of flags to
+		 * pipe2(2) and vmsplice(2) and return -EINVAL.
+		 * This forces libfuse to fail back to non-vmsplice
+		 * code path.
+		 */
+		if ((flags == SPLICE_F_NONBLOCK) && (fd_file(f)->f_flags & O_NONBLOCK))
+			return -EINVAL;
+
 		do {
 			pipe_lock(pipe);
 			ret = pipe_wait_for_space(pipe, non_block);
-- 
2.47.3


