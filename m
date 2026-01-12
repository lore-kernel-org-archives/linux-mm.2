Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DDCC9EC69
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC48A6B008C; Mon, 12 Jan 2026 05:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47FA6B0092; Mon, 12 Jan 2026 05:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DF26B0093; Mon, 12 Jan 2026 05:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 991D06B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:36:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66AF58C84D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:36:22 +0000 (UTC)
X-FDA: 84322957404.17.62F313B
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6EEE20006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:36:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LuGX3Bhb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768214180; a=rsa-sha256;
	cv=none;
	b=qUF3zhbIdUr8TKUXOAMBa6Y8+d2IvykkxMt73M/k+QYMcu/T9kOoSQl8r46FxewZ9s7iE1
	zjVxyowwng1KKvGjrhgH1ryg7EdB+UzPELLNBRP+Jam5/RER37FyMNnfutx16ChZJY1vMo
	X3GT0Ix4WJHy9h6yYXB7zDA0Wj/Sshk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LuGX3Bhb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768214180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yBp5tG6OoUe5GSpJmoxf+bIWod0JQI10dx4rxNiqqPg=;
	b=IMD859lTC9aqenlJoUGoQyNgwPKYsh6bTxmP9DHhk/5uzxYlS1rHFlSM7HXiBVZCMLqByw
	ab+E/yyE+09reKyOZum+BgfUIgL76dhHg9EKEwFts3ySqgPdqxtbQ/7nCqoJeZ2OsYuYaC
	RbNQukjL8PkWqi6I13ntpkHfG8NSY9k=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0bae9aca3so40665205ad.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768214179; x=1768818979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yBp5tG6OoUe5GSpJmoxf+bIWod0JQI10dx4rxNiqqPg=;
        b=LuGX3BhbhsJpSlCwFNAm8aC8wYJYYt3OIsntEcA6Xn1QWfgYrAEDMWsP3+3FG1dr9O
         vbi+xH/wcWODimrpJItusHSjMKv0Le9fHjXlv8XWMGwDFYJyngZYhDYMKgQEql9meGaF
         jDuBaYHgUe/YZhTZ+v/3DoupHjOkygD4dqNM0L7JzlXpQH+xcidN9NHYQuU5cMfKTqnA
         onVlvxul+JvXScMG/P67IH52WowoCl34uiWA9HhUIDyhYJ6A1efPf/9/n5sbrCnQZvem
         mfkKOHRkEuPPDI/n580TF46lHvz1hCCpgbQmdTb7YXZ7ZLDr2Ow8gfZ2asyy6ikFf3nq
         J/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768214179; x=1768818979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBp5tG6OoUe5GSpJmoxf+bIWod0JQI10dx4rxNiqqPg=;
        b=bU/NM2mn2qqrdqvW0J3IvWweczFyKCANAXsoRu6OR92NioIQhaZ1g2qweHJ9qb3b/q
         CGslVFWDF4maSzrMcrsZGE9MVZ6Lq6VTAteA8zA4ZfOMsFcwcz2BL8hdGW3Q5eJ1eaFl
         FQOj/2BToA+UGmoFwVCF63k4d+Jp9Bynf61CfT3frkPj6Y4E2MbF/ZAqxIgQlIDtuFY/
         XfiJ6Gzp4QH7z7YCjXUjIhDPhK5Z36harXlXAKcDQ4NX7qCvXmriZOBUOQk6rsYLnAGR
         x3bHjCFfW7MFRinX1AkLRGJPZOVPdEqpgtE6tLxADnFKpDIFG4VE8SCnYSazZqOoYrdy
         rkww==
X-Gm-Message-State: AOJu0YyziMUIUZOVNWkmeNyzDRTfU1Rerq4fIS37CfLzux6arJEsDxU8
	yeM3a9IKCMVEfSjL69bbdYkvhQfyn1etfAnxWN9dzJUAhl/HOdoOVxRa
X-Gm-Gg: AY/fxX7dQG9/xtB/7sZlE+rMsnB+uU0hAeo22fxhD6HNE6rJVqhkekyM3/HUB//Q6yg
	Qj28dRo3ReEbVBTc4SU2T20H1XOLBmj2ErGXtQi6WyH2GNpWwrJ5yre4xK8NLrovWyCTIALSRcG
	Nllq+DjvxuNgpVuUN+Orq6UFvZJf6pkY2BvdYMhsrwXSuFZeI4RcoZhWXwf2U5KrUvlh8+NMMgS
	LNsC9zzUIGQPgFv0QAqHGBjwp7jMRier9/nNyFBxVsUWxAnRKd1HHt7DqROTgY0gB8GLirUz+dz
	5uW7NRHLt7keawBS2AUTS2vOG5cclUKPFExmheQQGXwKN6OrqPbfLL9O8YC3sPkDgtBoxgo2g46
	fEEKS0IP/TN8JoXL3yjSm7xZWmZUUHPrrzv/TZp0cIdzhwSCk6Xc8CIELABx/1QfxMS9wLgO7Ow
	LEkYDGdGLp92Tby76SH6RWYJjT8K9ljREu2Jx5M7wtFM5f6M4hHoWBzYeMYXVJfpxR+5M=
X-Google-Smtp-Source: AGHT+IEkWV9n/ohjWW+yF7jdxVvxZObwQCvMpend+6nO2RmVHzT5C2NnEtHNfFofCLYTULYhtnwMEQ==
X-Received: by 2002:a17:903:354b:b0:2a0:ccee:b35a with SMTP id d9443c01a7336-2a3ee4da855mr151624235ad.46.1768214179316;
        Mon, 12 Jan 2026 02:36:19 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:7751:dfe4:62a3:f9d2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc8ddfsm170993495ad.74.2026.01.12.02.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 02:36:18 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Subject: [PATCH v2] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
Date: Mon, 12 Jan 2026 16:06:12 +0530
Message-ID: <20260112103612.627247-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6EEE20006
X-Rspamd-Server: rspam06
X-Stat-Signature: pq88g8m3kgeresfqdnftgubksk91xena
X-Rspam-User: 
X-HE-Tag: 1768214180-98351
X-HE-Meta: U2FsdGVkX1/e4ucEqHdV6njBhzk303ZZdoU0lFiw1H7NdOIlRQVaIMX9APtlH10bztYf/pxjQXhq6nK6cYwqNvw+tSstMnNnAmf6mcu3ogvUNCJz9WfavQxciKANHPoKOaUjnczmR0bQ4u9264DxqVSbiCU/IM8edEQzZFgwXr2mVPI0xcB1nkk2Eaxb1Z9o07magSzZvloOH+qdAWn+JOF/Aq0qxOCMJ6k4nNWz6srjR/6001sHoAxbnzM3Z6VAZhXA8TFN7lA18b87VYhxodlXYzze9RnWvfbgRqZsC1JuM33UZ5SL1VqbWseqfSrSs9Ruzlz5+LyQb2Ih1OsOSADIi2CIqbLNfCNcSfNxPXcZuHPHc/y8RDBFyNZ5YFGRx7bdwyJS+l+oLsMgd4Z26MchdDNcqf7fO42jkutq8OxdafaqgS4h7mYUlAX3D/IZkStgTUFUwAh9Ef9LYGwL0V/QsZ4b7CIpWI9S47G/VuimLB4dBrvnbU1wr01mJYTUOQmEcubHXo7YHGWgFzGnE71/eHKWBIzjpkEA8za/si5YEXOhKj1mEqd2L7+EbeJ/TLS+IIVLurMPb/bN1Q23goaFjz1dBnQIzA01+B0QEs0z7S34U8hmyPpEpL6Y+jYj7X3XkcHMiHVR2htflH56AGSmgrTDOoV2grG38OrwfkImxM8ilN47TcE2b0W1cZV4TRTEPSWYw+0GAS+foEemz5oFcCpo0xfmriAJGr/uVRuMJ+FgLOKit6Zeok2smKFCnExrJMOcUXOxJuq87R2U4zHzYFY9Bg2x1x7knClNGCb+dDQHADFBnXY1E6SLDCF0EUAqiEDu3Yge5hAVgZZwXuZzENzeJgAT6Q1iS9/o+1mHSu3/aO4WPdf3rJRckCPT6jQv7nY+kmgY4OkNdu4X16jgTleqr0ahVFMO1QhmZsQuNyf2UMfvPhY9U9eR5lp5Onbyw+91twL1RcZcjat
 jthoBXJf
 eePVwOfWZddNlzSPBRMkBVTO546zqNMirk2FiIsvN++E71ZTu2cTbzUYZ0nSo/l1BuuAdXRCn3iLYL5J+NQz/Wsgd/RMnvu/BTejgVdrizwROcibbcV3FsxPeBWrS2DzZgbcXDWLnLU7NkX+kdIFcV5VRnUuwGNnxHr4TlH1fBCtMT4glOATXk0H13ZafiesvNoz5yfWum+QrOuU/1LD9hFSb9uFyHbwilSJLUAZs82hzBz2LhmvdOJ1CpdctgN74Jux9l8hz8Oag4sen5XWtMTacl/eKtQPPUREOMpVvZcHM7DF7Wx46WMmOoyDnytK8dSeeB/iePArOMoeti4pXf9IBmPChXG4LZzViYcZutjf9/ZyAA7vF6rB8/07/6q5OrJE3pwj1Lo15fR/yONIi92eyHhptiSSt9aiZCQ/B/QZCt/eNfaaWNeQ/boHcRG9YF4qiNCZbxmUGxuoS5Zk2vHTAxkk/H8HKQaD6ZPY96hydGojbftkcBGRJkJfWLEtdKRe6TluuVrgztkisKNzMpt4jGoUSX6S4NpBSq5v1vXTmJYdBAurpahLxi6fom+On9lTaC9TC3AGQ4lRiVjvW0AFroeIVeWQ7FvNz2E604lPJz9I50ZdhH3lGExz4GSPxw9R7sv8LkO2PTNPrhAhAeKm2+31QSZe7tAYLJVRrDdGztM2StT9SuWq8+FsSRhv9GS7I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU
read locks. Processing a large purge_list without rescheduling can
cause the task to hold CPU for extended periods (10+ seconds), leading
to RCU stalls and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs
stack unwinding under RCU read lock. Without yielding, this creates
an unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with
a batch count of 32 as a guaranteed upper bound to prevent worst-case
stalls even under light load.

Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2: Use a macro for batch size (suggested by Uladzislau Rezki)
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..51e58701565d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2268,11 +2268,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2282,6 +2285,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.43.0


