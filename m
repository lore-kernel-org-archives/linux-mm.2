Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86309606A324
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aagEIk5k
Received: by kanga.kvack.org (Postfix)
	id 2886A6B081B; Wed, 21 Oct 2026 21:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238A06B081C; Wed, 21 Oct 2026 21:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1013E6B081D; Wed, 21 Oct 2026 21:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2B8A6B081B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CBD14074E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:31 +0000 (UTC)
X-FDA: 85348600302.14.DA8F6F5
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2592140007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aagEIk5k;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/p+8Vl7+8PhXJMc34NF0xrQaeakIDsKG9S8+b35h8GU=;
	b=M4VhcnPirD4U/zteY/eHZ9EK1r1gzkNLbOy3kWqKlS1SeZIkW3LQ3yFibmAquaWm9m1q3Z
	HAjfLSyIGcSOK/tufmoOkjQkDVFr5zg+Nuj7AmkqIKcVOIVy9Wslz6tFzLr7jucTrW32wj
	VecPrtQYCRQpBlYM71C7Ajz3UdkXEGU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aagEIk5k;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634249;
	b=DCI8jLuh6H3wN3vNa/K8BItbAwUjm5ivETjl+oTqDXrpRrO/P00NiASwJKCQ6vJVdyPRCT
	kAP0VVhIiybmahE1XCXDqiyun6Kan/iRKpyjf5v+o6pPm7BPogtftwgPDQjRWnrGHMoAKW
	KP5sQJrgfXlRFgAtVl4uubq99GS3InA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9d1114320so10063265ad.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634248; x=1793239048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/p+8Vl7+8PhXJMc34NF0xrQaeakIDsKG9S8+b35h8GU=;
        b=aagEIk5k2xfijbF/RReYdwhZeWKDvMqmbeqJBWRASjohdRtWn3KiUltlztA1DN3g4H
         a/LE0+t4gSg4+2nwH2PqNJFkzXL4ux5fJuEnWf6lqePX7CVyZiiltyrEVPVxgunHn5QR
         f7NT8/g72fRKQ5B1Yf8fGV/uYEfFf21RNlsJXFssE9hQzS/Y5JSji68SM58drUEtm1l1
         hIgOU4Vo8L1CZoZC8W8Xus6dOwmmYrVdtxekDx9qS4MFeK0ya6vzgIW22t5uqqBK1EUE
         kSzWiuiy+sJeaBdLY1plkaJMi9oXKAAblEH700t+dE+cuN5h7wl1WeQRsN4BhP30sl2w
         wiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634248; x=1793239048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/p+8Vl7+8PhXJMc34NF0xrQaeakIDsKG9S8+b35h8GU=;
        b=KrTClW9Z+iLSp/2E8fmInMjCUMJEMTIPd0edoUVb4UzpfQ8aAo+vX/U7FhFpzXcyAA
         6bFeKgiLTk3lbm2+9FIzM+bVByBKbZ2GMVJ8mfGsyop5ji+cC1DiRNj43Vk+X88cIi9O
         GuwTc30VLPcGb1uTpL6c8o1cYBm6FRou2aVO6nEVZWyfYv4jk6EebV4hUpEB8MMRUC/K
         r3iY4Wa5NAonuoBcbEVyorr6488C6b0pock/TXwBoNlEQ+Us2GXHaSDmhYfuwpZ+hQJ+
         NoBmDujfKpb6zWAxrUeQVN6tvGZiT0wcGXx77EIZqqAdrfZiVBrvG6GYfUbBv4vwMhT6
         qfBg==
X-Forwarded-Encrypted: i=1; AKwUvByzWw6Yi2DaIQb+NzIoNz/CRHLeonN7ULX9g0y5AAUMKeEaNGdJy1rfQ7t/QTv1fAGW686ZY9x5Qg==@kvack.org
X-Gm-Message-State: AFq9FYKFZM8Mbk0Fde7PaZ0a/v2HS1eL2Fx2A5IWdhECHNh7cz2k+lqA
	wqnmFF7AY1iqPRsxmiFsUYlbFhaDYjrrIZU9aA+iWMZ6vl0HnPfDxi24
X-Gm-Gg: AYBFou17f72jndVizPdDnDTS8Fu3pjUtD3FyQ5hU/1IzjL0MuFlhHuIigu7x+tuyNg9
	eU4MuMRFAHNtiMdQGXV1ZuJ9rCZagEZdcapq5g2X4mdg1zC4e6xmWFAB2cA3fst+SZrKXlWxBc0
	sJj8Fumi2Y/uWzGVJFHo3jZUkRJeiFfOwwK++yIdZ3tb5b71XmCoDjOPHBT7hP7GXiWJgDYdmKN
	MlIsAQ532nXlKAES+vKlr7YgOC7L4idOY04xnArbTHIntlOKnwPXjIq40hEu91HYcVpwkHWDCJm
	0EmuowbZNdKSk21lt46IJQ6iab4qoPn6suOxoTXM/lEKzLSSx7aU7rNYSefg2xOYW+yRWaMqfCe
	Qa4ZviJo7tmPJBsO+Zj8VQAS6rjw8RE5djnl32CmdFS3YDDdYumTy/7HIFb/0VfvkJcJeJjSuLv
	JGY5dAG4mC/dTW4USKegsGvJVz0d9UIlUNofuViFfxDs/M3D8DwhbonzjyOla29DcD0PpeH11Iw
	yTGLk/3+hSDK6T3ef5N9rZPYKbKtjuU+5r77O8Hw01YELtFMEszfrpQ6FJEoeY3FZcsQXg6+rOP
	AP9UYdhUPvvkEI9d3zsA1q5w9ZBPNQMryDGmoURlK5GnN26l7IiQsQYIvsoSd+S8bYPtJe8AmtG
	u37Rn9h8r7bjFkGDtk/o9z+uC
X-Received: by 2002:a17:902:da8e:b0:2e9:5829:9b41 with SMTP id d9443c01a7336-2ea43e20647mr33495795ad.37.1792634248345;
        Wed, 21 Oct 2026 18:57:28 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b4addfbsm16725685ad.74.2026.10.21.18.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:27 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/9] uprobes: Don't run exit_mmap() under dup_mmap_sem
Date: Thu, 22 Oct 2026 01:57:05 +0000
Message-ID: <20261022015712.1297331-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2592140007
X-Stat-Signature: hhostsicernxztodckzgf8ob4ou9czt8
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634249-829691
X-HE-Meta: U2FsdGVkX18uGDCltGLDCtxc/diT/WwGMhInWFoQ18eDuF3zjwhcphQnhvjyFj28AHW4XEywkUj9CScR+dlhMPm9Bsi2PkCbBf47NJY//nIBiV0UahAl1X3xshscOjHYIg6pT7mC8wnuVH0fpCXb7QrRSe1HNefwnQ9CqAWAYhySEFS3XgERzcp8oecabt6Skc8ZMrnrP3Lm2MgpmLEgMEGzmnd+M0L9DmPeZlvbaM68V9kXzVjVlRtzTbLdPWzoEb/Yj5UM1jlqrTVwa+PFVFAtOH8F0GS/JkwxukzSos9rOlUdIGAQLL8BILWFIV+KQDt+JiYd9nxcUwGbaLIFC/mz9b1nSeNFTAJJscGbdWdyDKhQE7ArW959ozQURAkLrs50lpojfBJDDK0oZ9xgOGpK9i7P2Qv7JATsmTRlXC7h/xCJBbLhteJF2jSAjNJYnqYq1alPUb72j1xnDL7KYA2bQ+uxrzMV4AXiUkRj9wi0P4ailrkGlsYCJf6lXYi9/bNR79eCCHDe5EHkP7Nkvwd7Oahns0Xh+6x3Gq8Y/BsmudVXIrJ8gdeg+q4w3JIuKs4DlWU1YX24J4Gq2rubUoGKkcZk4Z26APOUUswt4f7a1XinU5zuau1GbfJF1A79wrDIyI38wEbE9AxwgIjvJM6uzrDZ2aUvEvwSn8ii7gW34ntajeK3phjzKefvR/bI/5qIhh0rCqwl8h+yUF3KcumX+LXNv3AV8ZJHl28KxeSSCaCO3CVrZ9n4f27xsA+qs3ZUD3el5ieNv5vLNa7atACv4tUWYFMjHjxjkZUAhlzesOzJM23QAMTd0ijG/mvUlKT8bBViHk4xhhKQ7wACx+Vluj8tjyNzUay18NGYbX6wEEPTz2nm0bAlNwQBu0bPfR1SGDI2rgNy+xwLGppb+4XPM0EU3orw1YORI8V0UvY/ghuTn29kca720n//1kbhePBbekqLmL6EYph0jLs
 OrjXQxQo
 L7TljBTh47AUXTjZCiypYibHvFe7aLjoSxaP6cooQwIAQzp3cXZSWZIyV2w27B3W0YTaC2mPobBaDox5ecpWY6MER1Vb4s870QXec2poESmcnp3hH61eCdz6EMVPhrzAa+hNIOrb2/ObtE1k1s4B4rdSsVCpwpkgHw9fL2TJbbExi6sj5JXLeWS54dPW+pev48xe3NylwOQ1gWItt/F3u2i01SAthUP5D+v4fW8Wdh6ddo+BeWyKXSnV9D4G+ITcJ6ghDT6NgmJyKpVnKoxHObhlA/YQpw/oRaxDPPD1zRnfy6GY2n8bH0TGM0fBwHRbmerZzrXass5eYVIcy1LSOsYkBHrYfrSL4aLjtJnRuHUQ5pH+4VCH11U6cv9zRy0/hKiwTbd8Rm5JLbM3wn+bPDCW8MLacDb6056ISBl/pDqwQCi3z3OuKDBted/sPhppUIYKdSrJL/c93HbsIx+44UIiM8VUtRO1T7bAa9vDmrSjLxVreA064SRzTKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

build_map_info() takes mm_users of every mm that maps the file and
register_for_each_vma() drops it after the visit. When the process has
exited meanwhile it's the last mmput(), and exit_mmap() of a large mm runs
with dup_mmap_sem held for writing. Every fork() in the system waits for
it. Use mmput_async().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/events/uprobes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..6792004be6fa 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1250,7 +1250,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 
 	prev = curr;
 	while (curr) {
-		mmput(curr->mm);
+		mmput_async(curr->mm);
 		curr = curr->next;
 	}
 
@@ -1324,7 +1324,8 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
  unlock:
 		mmap_write_unlock(mm);
  free:
-		mmput(mm);
+		/* exit_mmap() of the last user must not run under dup_mmap_sem */
+		mmput_async(mm);
 		info = free_map_info(info);
 	}
  out:
-- 
2.55.0


