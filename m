Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A5B606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kqSKJoc8
Received: by kanga.kvack.org (Postfix)
	id 435526B05BB; Fri, 13 Nov 2026 10:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFCD6B05BC; Fri, 13 Nov 2026 10:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEE76B05BD; Fri, 13 Nov 2026 10:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 013B56B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:18:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 765DA400BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:18:47 +0000 (UTC)
X-FDA: 85430453094.03.79EFC8F
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id BDF261C0012
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:18:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kqSKJoc8;
	spf=pass (imf21.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794583125;
	b=CWuq1Y0ne6/S4JTSNTn5n/1k3d+L75K4jMsfIt9/iuhYFGJWM8wd9+/N+sJqt320DE1tyn
	4twSB17qeKvBZRH9fmuUKia69pZDHjamxkIsTpL6+mRPoQPxR1/i+xAOd8Cr5bDjTxg3Sd
	2JzAo14cYAzNmi9jAd8CWH/CW8q4Puc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kqSKJoc8;
	spf=pass (imf21.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794583125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hfc6N5bqMOZ9Ilqy3QOYV0grnw7Ekr2OsZD/GvRKsUk=;
	b=jcAeFqtidFCT+t8tT+U4QqCyjps8jM35D2t38KdOcBxGlEDdnvuHNNSUOOVB8A0cl2YS8K
	QJGpsiIJTTZCVT+uOyiGgt4PPzOxW7r2fio2eXxdLR1ijY2FVnfGDDUkHPdMYm9e64LcyN
	yrQogNAd2+IWZWI/QEFp7672ApOOtp0=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-372bdb942dbso1203347eec.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794583124; x=1795187924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hfc6N5bqMOZ9Ilqy3QOYV0grnw7Ekr2OsZD/GvRKsUk=;
        b=kqSKJoc8LaqCka2diYBaQxX4eNm7kz2BDaG2IlWQ/3XPrUE73zBMhwLqMMNKSgiw5d
         nhm38ldFaLtI3irNllPY3brAv6olfuoaEL4iFwD8COvmFIMDYm4o+MpBPuolaTRGuGxj
         1R2ESBaKyhmU1oEN13D1w9ivr8EZCdjJCTIi0aYj5aAekclBZQdsCao6X8dYc722eL4S
         lAD9gkSMv8OB8cgwOapn2/vngJ1yBxfCDToJ0USyddQe5/IF/7qu4z5tuYfdNbXcwhdn
         L5aQN29yEVp2mAp26ADTODV9YxQeOdYQ6wzmn0EoyT3swiZX7cxn7NFipL326id+GP+O
         dLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794583124; x=1795187924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hfc6N5bqMOZ9Ilqy3QOYV0grnw7Ekr2OsZD/GvRKsUk=;
        b=dVKdnSrBr6n5Bc5xZNwkbolUcQgzf/H4jy9TS6FLlZ0Fdjf/6s9eb4bheUlupE+Vg1
         o5Dw7Ohx71NbKTGbb0Owt2sgiM8d57s1lTUlD3OWrcQucbutuNVCsqHsJAdpVKNuDAgn
         +HTBrE1E+1b49aMuL/m3Zq+ql80DbFwmW+JBLpdbeyMYGt7gp+fcPGaYRTFnLSopedNw
         Uz4b2BJOG1WlxuoxRV+Lfm1X3oBB5YyoD0+GoNXxOC4kY7arBFQPYtbJauE5cKH8MmK1
         JxkpqqKNW1AMxl+A+LoKzxDlFR9P7DoUqP2qkqWQFNwzwAvLq19LsEXvV0mlNaCbdae+
         mEsw==
X-Forwarded-Encrypted: i=1; AL+hErFk5+hip+VS1PALTC7naVtWvz6oTVPt4UgbMK9GNHpzyOImlMzG/gLTwWG9ceJBq2/wuyL4Ky/zIQ==@kvack.org
X-Gm-Message-State: APuU4Z+8aGyWIILWLWFX6cmBK/vvWoFJLn8J9avPK3PT3EP6Sj2PpIft
	3hr+j0uQZXeY+uXoLSmYsAvQn4DzgN1j5dEsF/lqa9TgBqmIJWj0CjZWaiDoeg==
X-Gm-Gg: AYBFou3EIiZ5LgZaKwXIRlCbhO2T6JLeoHtKi2BofTuoOADN66eYbXKINme92PztuzS
	fcdw9kH4OGZojeq33Z+X6Ob6EtsrRGjLa9gLn4Vwci9/62C0uI/fdrSP4xDZ4DuaRu+tvXrHchV
	bMz1JcvVNLslVjNvqrESuP5PcV39OlaAOGvJZ4onn1MRI7mwNBnByJc/8i+9CyCuAbjRZd8YUKn
	REPiVXw3fl4WgXIMWgW0rwGxQwpAoAASGTfXzUvK3Ul0efI2MA0j2rgz9GwFslC+3tgdWbMne+2
	Utt5iWXyv+1sn6xGdVVhVCnDmO9qYhbPNkpE6MJyTq4ZiurkSt0Tc9K30UW1LJmMjmW5+eDvC2W
	WcV7ldLxA0Uh5BOAUXsUwliSxh/SQl19S5XmhlDw1OielXwDIq9FIwznE+3gsmJ4lcNYELJVY55
	OR+4IYeMiZpSDE3DVpK3KCWDTWUxqNmz8l17keL8c0VhsSlT/TAyIn+lWExwf6e7mwIfew7CQ4R
	9I3Rw5Ezm8JZ9nd8/H1VI7Gh2UozguyOVSk8ptL919qzaKF/ROgZrqlktqlk19o+9UBz3E35jqB
	B9qygUcB9yGDofVlW05etC9dW7ybYIA=
X-Received: by 2002:a05:7300:d40d:b0:360:d4c5:7243 with SMTP id 5a478bee46e88-37966e3a7cfmr2517287eec.11.1794583124302;
        Fri, 13 Nov 2026 07:18:44 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac1:7ae0:50::246:47])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm9134286eec.28.2026.11.13.07.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:18:42 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
Subject: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Date: Fri, 13 Nov 2026 22:18:37 +0700
Message-ID: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oz5bas9qo6hg453igqhdnh659psr5qfu
X-Rspamd-Queue-Id: BDF261C0012
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794583125-227621
X-HE-Meta: U2FsdGVkX1+O34vfhP2f4KkBrsT8RB2pQXqva6a1WO9P6V0PkeSaft91oeQTYMiD5x6hH1ZYz1YrdsuyXv1XaHELh0AVN5zqcZ9js51LMxHkgsTle251c7RExK4BkFZsb/aSuLziXRA3xl2T3gx3Smx/tlATG/1bT68IDFi4qfdmzWSlpl4PVmesMi6gYX7RyByIgjFWKPt+cKvvt5sDlYUHlUjUtRSJIBtKL2chlRoJXHNe6MH2KTZkeo7o62vauVp6ymHpM2rp0G5Lk86KbCYl5ktYTWsJ+xi98IIJfmq6wpuk7L718AzuhlGeNRHUoRiP4/EF3dG/Ah6kfrqYq2zG3XrC4RiOpT5myraxm8ypdiQBLblW/DxbdrLQxzZy4C1/rh30ylBIFRv2/qrNsPuOnjmzSiGhCk49IYenzhb7Q1s6Ze4co5lZZ7NlSRXTxzorMnVbItrYJjuPgg2PwQHKEM/ADaxRLm0Rl369+YTIF+Ce8B6sjt7+La2eSq8cUT6+BJYNsOB0afMQQ0kJbXfPo9v5/tKbyH2S/+z8W7mvOU10E0+4KLgf3XhtuKmUOuYC3KrwWiEABhI2Xn9aSfWK+6fTjUVRvg+DJid5k2F/+gJ2I0sILPpr9XRjjxj6t7bTnE55vQZYZnV6NWgVESMQWZl1VR0Upe++Jjofc7fCLzdOHOK5tXhp4XJcHTsWyrv0wHjU79/kvJ4OdMyWyoCHB7zEToqm94Ggfxks0JJOqXtBRtuv0+OQksJrvYXyTC9m4UkLVf4uMrzNmUs7qdubV6IOpDXRfZQIq94M1WYcn2vGWONXLaz9ZWpsFhjHcfx81rjx7THEd4tK+8yrKLS+Zn4e3q541tlVFdRLTZnWjxds+3mQK0qxu2JS1lEOPakwLv0M+KdFMamOxJxobd6grlvLIEs8k4DvChgIanYGAE9/3GfFTgj1COTvVSy4esEvpkv8DuDkNj+W9py
 UOgGNhtZ
 rR68VfefRYhswqWlJX4fwmtE/Hl0UletsYkXXNNcr4PPiVjas/A6dHZdOGf4gHsyJpCQ2Dy4q0KcXw4hMZNdkzERS4y6YADWdTAkAENfSDJxKrQnbgSjcGTQmZU0eE7SVmA+dWSfLHUvR8472435+Ln0fz920Kt04jEIZCcyFWnI8s4k9+PLygXETT/EqltFz60L/cANsAWyfxTeR63NaCf08jMXk1a4xRPXhodN72LTWCOLHX7YZJIghxfitpuhJ1TV0BsLWkX9WdbEvRBZrWzrx0bFYMbn0sFwVcDl6c1tg47eh1wXV5LdW2e9Dl11T05wzIz7KG4x5E9Cj3SdsWYUce99ryMwOAbCiaMaVcm2WkrgE238zolsKiBRr2X9DF7T6xdb5+VTglxFJS0RQ7YFIA4tQ2xhzXpC8pNkyw78zTUWcRBLAog7rxmw4U6I5gUJR7TjJhahiBkIp+WwKFi2CA8Q9shvfjBgFiZ9P4foSDSZgP76YHYS7AAHg50P/TfNHcvTk8385QRouYNdEU9IIp3gZN7+3Ew3nU2sQbtYJf0XYihHRLF6hru3DEJk3MeXCZbl+4VIjGka8kUeEg7okwjNVWEykGROKWeKkLj3b2twriNzH8DDAyfNp7TS4XnQH1Sw/tTCi4+m6MZN2m/DNpd3AUWJN4u7ygQt64VdvyUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmemleak reports full rcu sheaves as leaked:

  unreferenced object 0xffff88810005f600 (size 512):
    hex dump (first 32 bytes):
      e0 79 f0 2b 81 88 ff ff 20 00 b4 81 ff ff ff ff
      00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00
    backtrace:
      __alloc_empty_sheaf mm/slub.c:2854 [inline]
      alloc_empty_sheaf mm/slub.c:2874 [inline]
      __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806

The second word is rcu_free_sheaf and the size equals the capacity: the
sheaf was handed to call_rcu() by __kfree_rcu_sheaf() and is waiting for
a grace period. At that point the only reference to it is the ->next
pointer of the previous callback in the rcu callback list.

That previous callback may live in memory kmemleak never scans, e.g. the
rcu_head of a struct slab queued by rcu_free_slab() for a
SLAB_TYPESAFE_BY_RCU cache. Slab pages are frozen (page_count() == 0),
so kmemleak skips their struct page. The chain from rcu_data is cut and
the sheaf, typically allocated long ago and recycled, looks unreferenced.
Since the sheaf is then not scanned either, the objects it is about to
free can be reported as well.

Sheaves are allocator metadata and are always owned by a pcs, a barn or
an rcu callback. Mark them with kmemleak_not_leak(): they are never
reported but still scanned, so objects queued in them stay referenced.
Allocations that can't spin are not tracked by kmemleak, so skip them,
as alloc_slab_obj_exts() does.

Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Reported-by: syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=527fed49e5b988882c9a
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Reproduced in QEMU (syzbot config, 2 vCPUs, numa=fake=2) by stalling a
grace period with a preempted reader on CPU0 while CPU1 interleaves
rcu_free_slab() (filp slabs) and rcu_free_sheaf() (maple nodes freed by
kfree_rcu()) callbacks, then running two kmemleak scans:

  before: 16-18 sheaves reported per run, rcu_head.func == rcu_free_sheaf,
          plus maple nodes held by them
  after:  no sheaf or maple node reports, no new warnings

 mm/slub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index cd671b934719..e01416ae0b4a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2856,6 +2856,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely(!sheaf))
 		return NULL;
 
+	/*
+	 * A queued rcu sheaf may only be referenced by an earlier rcu callback
+	 * in memory kmemleak doesn't scan (e.g. struct slab). Never report
+	 * sheaves, but keep scanning the objects they hold.
+	 */
+	if (alloc_flags_allow_spinning(alloc_flags))
+		kmemleak_not_leak(sheaf);
+
 	sheaf->cache = s;
 
 	stat(s, SHEAF_ALLOC);
-- 
2.43.0


