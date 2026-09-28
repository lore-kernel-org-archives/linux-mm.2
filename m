Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5777CCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB926B00A6; Mon, 28 Sep 2026 13:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100FE6B00AA; Mon, 28 Sep 2026 13:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2E46B00AB; Mon, 28 Sep 2026 13:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA2B16B00A6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 576FD140292
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:57 +0000 (UTC)
X-FDA: 85263889074.14.ED78754
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3B56C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k3ipXRbA;
	spf=pass (imf22.hostedemail.com: domain of 34qa6aggKCHcnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=34qa6aggKCHcnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUO525MYjN5YsfP/KDhp3xMzNW05smVZVp3S7wkbxmU=;
	b=eWY+u8sfLXGyJUw+CblwQ02ak5pCSRWY75HraXL74AM6wcdTvYuyN3FZFsSkFzsXHJrH+Q
	8ayB7LOn78w8QjHiv1/wak3+8PL1Hie0sk7Ub1XRbBKZ8nC+qEg7v/qPe10ILBY/pMBeKl
	gnYNdr6q4Bg3ZwmfZrm1+0A7+ALie/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617315;
	b=pWxQ613wTetmbtd9AwdQZ0CZ3ejfD1VWfz/+m7ZsbZPEo0faxpzALydb1Pa3gIx7/PpYIG
	y0yc2UmMbzqEyoe891WenWrqP7OzCy2cDILI4LQuU4XzCVcQ8la8HU0iANYDTacOwUKN6q
	3ZFxhWh3KrY0J1sX7SqyAeu5d7X+pFI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k3ipXRbA;
	spf=pass (imf22.hostedemail.com: domain of 34qa6aggKCHcnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=34qa6aggKCHcnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a009f82bedso6260055e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617314; x=1791222114; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUO525MYjN5YsfP/KDhp3xMzNW05smVZVp3S7wkbxmU=;
        b=k3ipXRbA111Ep1GecXNexRGKsruSffekUSthovX/ISCesuOAuyxpKQ1aPG2vNUnE74
         fYmYmMt2+/z3e+j4qdLZqmreWhlva5CNnBJDGgI0069Ju1mEK9wnFk07/CkdCVHrgtnN
         HJph/v9v86ZIi8ZFWnJPnH1OiNqBfnw0/b5qo4Gnw3Fvb6iZmAICfb7/MNjbTi7LuLeD
         HouA1qRyBfT84TMi0Q3UfhZS81dGnpNNYyDLnD12JZDtrlV0+k057ooruQgfvKCUBzNj
         4WWHi43eIvJeTt9eQpDd21XCmncPuE/Fv/K/pVXWuGg5iqpGidvJfiwL/tOD1fFO8h5p
         69nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617314; x=1791222114;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jUO525MYjN5YsfP/KDhp3xMzNW05smVZVp3S7wkbxmU=;
        b=yASDOdlQpYr9Ny00kcKyj8dqzAucI9sUgRlqDY34miRUJ4X7AZwydYMcMWZbD1sr+s
         Gb0GCVsG13X/zlO28QVQYRrtrsLE364vlUUUhC0MqqNuMF04NU3F6G3DSY7BqgNBKrMa
         PHyYd3YRPqa4vW6laNFmn4wmd8Nm4L4AcHgnoL5wxv8euqSXeUwDnmjiATdCh1ma1B4P
         fNU7U0BrYpe+0mz4L46sH0xCqeO4MWZOjOF1VxU9gzRgCK9CnBl38jxVtehVuEMM4cVR
         ru6haDyMB8KyhxbtrepdK2dNVCpSdv3zWKY5DoXYooxv/afQx+P/B2/OdOLvdDe9496B
         hGag==
X-Forwarded-Encrypted: i=1; AKwUvBwJfNWO8IHAYKDl6mq6x8YKRPi767UjIiK6V76nwxVbaEKmLJzd+JAZcNEH+0AGRaUaVIw+sCVcAw==@kvack.org
X-Gm-Message-State: AFuF++k5nTBtlLuwhsw38LdnDsW40OWbaHSODlLI1jPsWOgbqWJY4hGY
	PRPdQG2BGLqWbXkeHcl07jHlTkaXpXTSWpL3wC5MvqRcFkZwyq7ymgca/D8EWj2diVoKNerkHeg
	HLJDmsni6oh/K0Q==
X-Received: from wmgb3.prod.google.com ([2002:a05:600c:1503:b0:49f:fec8:8e56])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5487:b0:49e:7c8c:361d with SMTP id 5b1f17b1804b1-49fe66ee809mr241216335e9.22.1790617314094;
 Mon, 28 Sep 2026 10:41:54 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:13 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-7-smostafa@google.com>
Subject: [RFC PATCH 06/15] exit: Don't assume the kernel stack size
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3B56C0004
X-Stat-Signature: w79ebmjxos8fg6o48eapck44ut74xfbm
X-Rspam-User: 
X-HE-Tag: 1790617315-127390
X-HE-Meta: U2FsdGVkX1+xB2gKDHGdeGxmz80mJTSKEa84UYjY0MHEoFRCe5/ydzQJ6Etp6KT+ADgzqcpXPGoV39UyhiW9TXGIaQ/f7+yFpfM+fe6LJuOglVoCpX00vzAaCxNykIyenmaE3r7EWV9xRrf8Xlmw+SxMvwE1tf5EziOZyapHdkyoxSVUhtWIoDcxsN+v6gMEWP3L781I+YqF/bXP0DdurL6FyqsapI2gFXAvx9fp42tQFjDanRTiyFa5qjBJ2iqKj4lqlR1lCG1FWAqNFoEQoSu3HkT1QhyXwrCutBVBfz/jnKVNo6nnS6LzC0TcDoohJN1cHsMlMnnHfEcKPkzDk0p7p90BLXE1GxRdbK6oLR5gfqEkBNNiYHC0MCknuQ0ZjJrIlNhbt5uH+OicocjjmF6pC66Hz2W4Nvp/SN4vw/WjjRO9Nb9gmColATZ7JlBHqkQPjzGVwyxpLgwwCEpBlbos2Qb1qVQsDfg0JyswTzDZVhCMBNp/Yuqhn9Ni4RyyH4AulvwZM7wR/ihHUW2heoJHLzAlCwgRrRmmczrEwXYw6i3p9mWZ/3HDjUiPOgnrKl2OZxZNmQPN4sU7pPN9VriGlFUDLFsM9KuVAq9yxOc5Hs6qUGQtcH5yICjL7RGxKgn5ufQIKfHafTOj4fkQXnoocbykg/zqVWHsybySYChhegPKbTMsRJAe7yt8nmgH5h3ZyyjehPhTVnjQ6OpvRIJ6VHG0TFjagkkdwb6tm62Z0jXTUGfjhQ5kO2vIddqnxaVvifsP2ZUYg6Jl2A/e+TJQCRbiRIDBG7il3aPBtE5Z27iuMuaR6sWNAy3s4pxF6jlBFEYxjUjGPudxtjK6tgMrx5rI0OwTh2/y1wNGK0rA68p5PaYOgk6NzdodS6i21yjKGnbdGhl3SBCEZc5Czp3jHIqriEAyTaNdqL0K2Clds40x4zxRZgeMMJh3RjWT7bD23d1JGtW6rE97jED
 e5SptOAr
 rsOp+HYam0ojcyT+bZdx9+qGGaBUENrHFmFAl5D1GbW9wlsVKThujjLOImqlk+FJVPOXGfiWS4XMDK+PYzJfcdoAPI81yEQ4MwrPRwXvZmhkhm6LeLkfQQCAWJT4+0A/YS7nTrFyMwC4xPpgHjrDrrER8E3nPFZRbhkkUX4rey2dWLEIJ6KOwLZIHAS76aB7ytoILiXfxbNVuAtAMu3bXXulVqVgYfqiTWmvzgBqkclYEi2F3nuM7U5XGc/fgs5ta297XMMrRg5n7QtYspa/Sh3HXYNxKtbz+aGQYtIIcje9cTOYV9BiMaYdkfewo65Q7KFjIbdJWMZiFP4kphxs24fQ/Z3jvt+0/hvRQzc9im8ZHXkCMPNKlLHxC4sMTXj+TR6IkWLx+3d38hBCT51roLNANX1JprLYoSbUy03ULyGP452bWsIMCSJPVp0+7mZgl2TVUZogNoWFpsWN6/cf5CNX9I6Ym5Cr6d7DJc1DKp/L2kbo6FjiTbX6I07pJMAVUAmRgZxpq6EKw9JdoXxLrcPj6mjzxKahEUGspLH5bdUx6UMhk651Tf5dAJaUcUD5adph35FaqXXeMW1LjRyPOEi8O5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_stack_usage() assumes that the kernel stack size is THREAD_SIZE.
The allocated kernel stack size may not be THREAD_SIZE anymore, rely
on the newly introduced helpers task_stack_size()

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 424c44a42a4d..899d3bf048d4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -883,7 +883,7 @@ static void check_stack_usage(void)
 	unsigned long free;
 
 	free = stack_not_used(current);
-	kstack_histogram(THREAD_SIZE - free);
+	kstack_histogram(task_stack_size(current) - free);
 
 	if (free >= lowest_to_date)
 		return;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


