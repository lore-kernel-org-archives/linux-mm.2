Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9AECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B608E000E; Mon, 15 Sep 2025 16:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CF68E0001; Mon, 15 Sep 2025 16:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8AFC8E000E; Mon, 15 Sep 2025 16:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 897838E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:09:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38A4B86F72
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:29 +0000 (UTC)
X-FDA: 83892574458.25.F7033A0
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6BA8120006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=czNqIZTg;
	spf=pass (imf13.hostedemail.com: domain of 3dnLIaAYKCMk796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3dnLIaAYKCMk796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757966967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1irnAaC7Dgk7HdImUgdg3erV0zSH2B8o0J/F+rFZfQ=;
	b=16u3jikzEkqGMfGPHRlKPvwVCbyKr/ZMcD8ooJKG1dR0X++CEVlHrnFI/iF2q1ml66+eGc
	J5SWG2yczq7eujYtHPHlTndel2zo5ENMEKtSM4euflEeGXER5Z0MGgB03Eg+7mgl8305Es
	3kBJZKLnxYQ9DfKeoVAFeubi799ymhM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=czNqIZTg;
	spf=pass (imf13.hostedemail.com: domain of 3dnLIaAYKCMk796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3dnLIaAYKCMk796t2qv33v0t.r310x29C-11zAprz.36v@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757966967; a=rsa-sha256;
	cv=none;
	b=6HdR1NpJHmwRl85SCtZUmvNHzM2YlrYkofKyCOL44VNihM/Btx06zBamhXCcpERML2O3H8
	7lvKuSoM559W1UsyvuxOoxa+X51nL9GnIj1B5fmSBAPXJtHoqOPQQowwSYrsogn5FNClQv
	+rI+QwJ48A/gkfvwoWctCcZtnLtPWI0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e09eaf85dso2718235a91.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757966966; x=1758571766; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R1irnAaC7Dgk7HdImUgdg3erV0zSH2B8o0J/F+rFZfQ=;
        b=czNqIZTgsmv3VeISqnIGd4CVZu0uYSoTKkpvw6qIDpCiN8jARg3vupOeFKtWjdcnzY
         LQ+KS/wW7QX1gupUU+4RRI3eswiJSndiiquLDHneklrvtdJacdvU0hdiilKLlUxIaFCi
         4lRUFguAu5L8ViyWY3F3o82jvyLQOflvGiBWZSXN+vYVAiwHA/Bxwx4SsDON+7QcnAnA
         QYwr6XBCFEIVbQNHeG4K6toYLJdpQuTrO106zieWOAl98k/Ai5PDRmnhIQMFMACc534w
         Jdhr5scovWDUmtJRriqKFjfL9QJrMYGWGrRbciH8m8qQE0WXeKkjb0jBCW7a1zpZGnDP
         Ml8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757966966; x=1758571766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R1irnAaC7Dgk7HdImUgdg3erV0zSH2B8o0J/F+rFZfQ=;
        b=Sd27hfxEApmVFx6BG2RG06BabrTULJQQQGnrIFbhX93hNR1FmOxRlIqe8jOMbc8sb3
         he7Jp5D+dD8/7fdQU3Ah674zZB0MubpFzLsmkzIVzlXAWHhX8+B7qKbhybDriIEmgMnf
         cXXUb0AEZjzrRQwDPxwbKfYJRY8yHD0ekO8qHZJtDIERF9HYFZbBgOq9dKLTEujHfCSS
         mmls7d5yaUo6YJNypkFCFMhXu39SyS2jnqaFRB9PIwmbUsOCY9d7oIHZMoUqqsK+SSB3
         2GGf2StWkS9aNzQpCufjii6dkHtkdZUQItUufbhBEA54+aYjhVWKNLIsQZjQl+gUZijy
         dj9g==
X-Forwarded-Encrypted: i=1; AJvYcCWJOh7X7iiRIlfOmXfJ5ZSVLFKq/52eXvDZrJn+B4qp1s+XvqwXaH7W4VacmaUiv9AowmW0Zy1G4Q==@kvack.org
X-Gm-Message-State: AOJu0Yxc4DTQpmtiD/j7YnRSUSivBK1UUgYZCTgx1RLm5vJASC0oLAKa
	42o84shh1/IkRkeCgDDIN4nrUDeQ9WyQgFxHvz8muPG6KRuN3g2+mG5mTnL3yI1UTmxU/x8GPIN
	Cqw8n6g==
X-Google-Smtp-Source: AGHT+IGvKewiOGnHoWDqmlqcJxcDGi3xUQdfSPuLW445AIGj+JDuHNOrwmjURPZbSnfYa96dSkMxZkvKBCg=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:321:c441:a0a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5743:b0:32d:601d:f718
 with SMTP id 98e67ed59e1d1-32de4facb32mr15187043a91.31.1757966966323; Mon, 15
 Sep 2025 13:09:26 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:09:18 -0700
In-Reply-To: <20250915200918.3855580-1-surenb@google.com>
Mime-Version: 1.0
References: <20250915200918.3855580-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915200918.3855580-3-surenb@google.com>
Subject: [PATCH 2/2] slab: mark slab->obj_exts allocation failures unconditionally
From: Suren Baghdasaryan <surenb@google.com>
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev, 
	alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com, 
	souravpanda@google.com, kent.overstreet@linux.dev, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6BA8120006
X-Stat-Signature: 8w8qqjsyjjcf84bnai8f9sd1iq9uqdcd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757966967-290095
X-HE-Meta: U2FsdGVkX1+1WBF4NcwRmb3npr0HT0iYKiX8Wxmqr62QSZOM7NKtuvhaNxyj9DRzPU6tRknHjeuJm4lIeKoa5t6oj93mJoLCR0grPpqaBjpHHSuG+ght85LzAMGyZZnks6amRn37P/UAbK58Dk4esWo4p7dmp0/PYfDeEqzXKihXjDSvkoH8A2WGxncIi9o4igqgJ7+snYsTtDOuMNb0xjJpoVP+0M6mRFahzaL/06331ewrjfvD83Ux0KKoOzl4i8M81imABa23KXDdsK2OOxXVwtSbSbAdYNQ1iNdAyECwsghMZb1vfecxfQfh4JW3FH/WW0Oa1zDJPwUAHoRSTF7+lIgjZZZ71AAXRgX2PFtloXPDZ2+ZaKYQQqU58pskU2I/ys1dTJJyeezkWr1XfgAzOuXIw4Ndauc7ZI6YqQ9LQyghh/aL4SxSaQgkK1pA8w1+XHHID+YxZyMjx9RGvUZmDulI9Uk67CLOKlqv0+HbTcnvaY77YNWp3p2F0HMy/rM2Zt7e3lOC2LPCDyjMf54jx2miGiDzTHDf7HbhNFQyXTQcQSTgQEhU4GLPH7NINtiGue/6npDSPCYURoId2RKtBglFxAnyRT3Ncc630O8xh8PFTzqNIlpPi2qW2YSSdZ6yN0qQTYOPA6kCo7Pq1FXJfPZntAfa7IIqctEu4KxUn4XKzGtmnw1CqVAblxUzL35tXYauF7l/yuHxlSGN2I9EZYoOHA+gT7quSjBMoQwcOjyFvdAtvV3EYkc9FVBviP6BpmJOWdMx+zJQyWeN8CPjeZjxJWe6dJFWm6UFKeOt8n/0IdFnbn5M/j7co2YTr1Ds6tuYiRQ+XWP+/6XQH1vkJrzjdkYEB8PoRObJFX/XTkU3nKFXiJBVGEBUIMvdTuxfePtwo+gHPSMyJUuSH60FDSiOEwfdqfVHvh1Pb80hqLErbo9GfkmFz7cr8LTfxm30m5uI4XQVpRDjEcE
 sK6nwsQt
 h6SLvi7+he/pbXKaodwT9XK9RvTa1CR+FZg9aOYmAJAVQSKbC5MH2R4mCDYW3F6IdS2wrRb/YoL4BEufzkaeUnNkTprrEGeKZl81C3v7pYt2zWhbXnZb15dVeMD8OasM+DOpHlKESLPBT987WcrkXjuleNRozVeixcpIOAaxtCyRtjD0wvfjD2ZQsgfdo5o3Sj9tAOgCrslUFFkHFzmK4z9jtEx3vjP1Flb+yRGvrZAu1lhEbeCSFR7b7EgwPds5v1RLk94kRsdZ5wlbEDeM3Dla1ozpiKwubPpYbJEvCGpCvAlV+ZcQOWvsqAiW1u6oOzcv496RLI0Rp1kDpAKsIhqRygagIb85zVNhqGeC+9vGzvEaxqbpnWayKhcCsikxfPoDf9JlKyVbaBzjueTtt3ht+M1UOhPVoU5gVy+qwGZFK+3PevNAEf+HpKZscK1AbPsFB4m4+IONUhkYY7bcJgEqyh+x9X5no/23UB6rhlvuZ5d9IqjXCT2AzgQ+pNs0A3KL0r7JF18XI/riizLOY8HGdHHz0olOkLpWOCl1Ut6Ic9iRV0zp0g0kZfuHKXAnJToagMPtnw8AoqhXI3DuJ+kbBtcAoP2mteIGVcoj1bPMufFkUOcp8R2hk9oCXxx0QxmE19RsBMdLiiNEN/tkjHi2KKUUUieLulNs7+KujDFzqGl+iHPjIAMCQ5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_slab_obj_exts() should mark failed obj_exts vector allocations
independent on whether the vector is being allocated for a new or an
existing slab. Current implementation skips doing this for existing
slabs. Fix this by marking failed allocations unconditionally.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://lore.kernel.org/all/avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org # v6.10+
---
 mm/slub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index af343ca570b5..cab4e7822393 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2029,8 +2029,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			   slab_nid(slab));
 	if (!vec) {
 		/* Mark vectors which failed to allocate */
-		if (new_slab)
-			mark_failed_objexts_alloc(slab);
+		mark_failed_objexts_alloc(slab);
 
 		return -ENOMEM;
 	}
-- 
2.51.0.384.g4c02a37b29-goog


