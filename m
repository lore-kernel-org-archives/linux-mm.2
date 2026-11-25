Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100CD606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 04:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ejcex2YN
Received: by kanga.kvack.org (Postfix)
	id DB4D56B08E3; Tue, 24 Nov 2026 23:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65626B08E5; Tue, 24 Nov 2026 23:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53E16B08E6; Tue, 24 Nov 2026 23:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF9D6B08E3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:03:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDA07140DA7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:03:53 +0000 (UTC)
X-FDA: 85472297946.11.C837EA0
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 070091A000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:03:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ejcex2YN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795579432;
	b=fU10HN0pnhCSRg8QmENHHHHEBL6q2mKopO8HEmUpnKEhrTbmpUFr5yOHHca7lB6bv3paSG
	1M0tAmkB0qLGqfgUcO7r0IC9HGX0FgJgJGwdMQ5bFRfsjrOpE5ypnH+BIjEomRtyisjfEB
	qB6WkxgX70QXGZQXkldAFck7vH1lw6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795579432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJpFlG2KhF/i7ZYFbAbjEhsaAMAjHqUu1cyD0w44kPw=;
	b=8Pv6fTqhtpghq3/qQa+ybRMVGnM+lMQhHLDyIzVLjFfx0BjpPcEAICK624Qmf6Ystz0y7i
	TInP5qcwnJt7OLwc0/986uKcBq++QJRcAcATNWGz12MK1EUeOLBRJe5sUkeyTdljlvhu//
	hCPVvDQ5Qn8FmXCR6x4CL+7kk8tb4a8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ejcex2YN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdab938dc83so2110382a12.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795579431; x=1796184231; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FJpFlG2KhF/i7ZYFbAbjEhsaAMAjHqUu1cyD0w44kPw=;
        b=Ejcex2YNKRl2O/+pXAhe8OBso0/y1D7yYvC5PdCd4Q+AK5xusy5fyQTUZ6GcdwDwip
         q0Zred9HIA4iwUGRCtB1F51sqRUx4JvQuZUSbAEEelfd+TV6rQ8TyV3btgWveVdPvhzR
         a6JA8AgDI9eKFOuHOa2Y8vlLfzkjucd9nqCZNVdNBRHKjKyfTksK66dGOz1fre3pAiRH
         o7PsoiQKC6hX4WVw08kWPnbWJjsmoRO7DQaPQfr/x60n9TS/Zg73DPsH4n5c5VA4ej3Q
         wAAYtJV18AuR3NOgyF45PcCC7Jpr8Qn4B+MDOEBg7zkK2P+N677+ehvmCHGRPWNJHR69
         6wvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795579431; x=1796184231;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJpFlG2KhF/i7ZYFbAbjEhsaAMAjHqUu1cyD0w44kPw=;
        b=pHpgSIYaCvZsvvzF6XDfxXFgqilj84rDx+EIOjWWAu9bb8ETMewI/RO7H877Y9QGLc
         GXB+kWRQ6vO3//PKcclxgpk9pFd9gY2+45mTnVS3yCaOAwOCbRoSdhidD609xSbIyFkO
         6r9H39uJDFOepRHmff1eu4kp+cFE7pbvFZERc6BqlJAMZnr2X8T+Rwrz2tg6wsl/132l
         wDD9Yrbor7zz9Djx3peyuxd+qnrl1zAK00+ISaXFR0VexBzEsvS8dKS7nJJRHmHnh25L
         6DoLIUocVoj60IL7/tqRpwotITIlCOhoRmuxeo//3fu+1axJW/GfjFfAgR88xTjJNZTT
         2RCg==
X-Forwarded-Encrypted: i=1; AL+hErFsRwYXNpHmc9oDg5RCrRfaKhzJuJ4nMOj2W3kENuUapV45DD3LcajjHPatZX3xMD0UX3gumyYjLg==@kvack.org
X-Gm-Message-State: APuU4Z9czROPh9cIaGJzV8PpUC+aBoJtBTtskvasavM8/B6emKvHKEzh
	2hhucobf9SyzchKJu1cBmfMzXfU2Q1PxXFBjxkT2nJFWbE62K8ZaNp8v
X-Gm-Gg: AZFdTZfk9Lmi9DJ2zgM+v+XMxO2kv0+jhrRHz+h9v2RfjuK9qf2lZTWONHeHxhRC4g2
	8tebfkLsq9F2AoNjpMksaeQ/Vwx2tPsVK9SmHhihcx9bspTpNSd0gak9hwtR19HyFTWcR2vBRlt
	5wXwUlB8immmYNhP7W0qq3dZTTdX+PjJWYQz/gIh0cvpquXdPy1EDpNdHkt/sZ6bd7WSQM34qpq
	d5rgfgTVkYMjqKvNOI8B8f572PPwB4JotpEM5jUCyN2vZtCSVEiz4IuMfzMyPXrQAvE1Wyuz2ni
	znHo2vvscMCDTd1IJO6rgk2hXOshaLU+i12RXk2QzurmmOHlnFyEKsDcOxUMwl0UsrHxQRHZuN2
	Vz8CPYRXhmtIf6HMOu3QRJ1X+dxwF98hDSDY9nIlZTKjWwhrCujVFFJwkXHlBpV3VIgkRzHXCB2
	ty3vg1PVa/QDzWmg7WCs57toM+X39tzv6vUPVOirYa/mPRw3rpTZMND8p5h3Id2jWRRhXTE1+kq
	7A6GdSgEWyDhBiqzm4miG1EKreX2ypaBNEHVvqoNHpX8wJ6eXsNAqlcV4ETUDNn0dZHWCDNBWe0
	WTFLZ+1ifKej9QhsaDME0oBEVzGqtjZQxOOV0mrfL7PL1ZSevCzpmAu2OxVqH+AuRSNU3bbkds6
	/HHjuQxOjDOuCf4gVdVHkvD4B+eGw7lKUEQ==
X-Received: by 2002:a17:90b:3a4f:b0:3ab:5758:3757 with SMTP id 98e67ed59e1d1-3b41c98bec2mr15855830a91.61.1795579430408;
        Tue, 24 Nov 2026 20:03:50 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b495035339sm12649812a91.0.2026.11.24.20.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 20:03:50 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 04:03:49 +0000
Message-Id: <DN3ZSA718QIA.11EAQE8I69WJ8@gmail.com>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo" <harry@kernel.org>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>, <bpf@vger.kernel.org>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <daniel@iogearbox.net>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>, "David Hildenbrand"
 <david@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Will Deacon" <will@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>,
 <linux-kernel@vger.kernel.org>
In-Reply-To: <awWRZ9xCzWLnj_R6@thinkstation>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: zwaa6cy95jwdh8t959dtef99w4kd1xgd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 070091A000A
X-Rspam-User:
X-HE-Tag: 1795579431-733488
X-HE-Meta: U2FsdGVkX1/jkWAY1+xpRpPYDAqJhN31b09hIWlVZSpI6qOfKpd9WExqyL+e7LlUACBkdajMOzudWO00rGddkfg1RpExrMatsbH5oyEtiTZu5sI7IZixIbDv4Y9Co+4YFhegwTGlywAGOhbUuqrKAhdcpfKQqBOizOv5rr5kRJQPGkPc6UDh3vjavx5GLHlmQ6a8fHQU/TUx3SF3PX2Ov3QhgxVt4syAdsm7wLP1R6GdHy/VbfvJNix3g6xeq8q+W/Vb4X5Vbmwdr3WijAe4lPVkLgw0z8YxGG3moF7oYV7odxeFiEvBcxGZlOFcUVhMqKOfBfosyupML8+97hEzuPs2I0AC53mUsZ6/npC5wZMWwn5dfQ2/m2Wtz69lMb8U/jQwv7ubHqnesaD7YHsRLI9/ut/LhbGA8eIBD4AHE11QfbyHVEbKvqo4BhUrOwzB+mETJNujAweBsyGC7WIcFFKX/sr8wppyCJscekWYXcxTWu8dTY4XUR+vwOfSZiKSHysH0Z1Df2zlbq3ZsgLnvYz4r6uUuCkpa6F85q6IBnAxLmUP5laaT0ghFrnSa4ILm1HCEJCxQipUKhAbpzllj0xjaI0M6i1w91ce6tRnxlfvlQ4JJUE0sIkyNS09dQxHhq7SHS61agyhBxe1Pe644rLXpFUz+5V6/1YVZE6K/rPNzVnPgXpiHYlND+ahOvoNvIAbHNb+iZzGQnZHb/jNVi74szvI3jqN/ahwaaOXDzUIi9gAtISq4+ROYWAiPmb6uyrgrwYXo2jY2xFriTtTGxNMxqGthR7s8JO3cDm6z8lJWMRLmyxa+2tTApBtZPRp9VOJN7kzttgMMU5/PulJdFRLenPt+TM8GYJQiqjzPYJAhYYS+ebcEOvo92OIbsQrapY0t6TLo/8bX89nmRQH9UhA8Ggj01RkzWEEUb7xlC2Q6a3ubZOtAsAwhqnkDB3ab1z5JDpZlV9n3Pqh5uQ
 FW7+rMnj
 cU61Wiwr1c2BZZ+AaEeRDcHdDvSpFVWdPV+DL1pPBqzYsqV1NYum/0DOp2v4pGiyjcQp5+RRw41SIEQgKsqyzTlr8w9vQz4mfVyQqNp8Zsu6LK7JTbDGqJ0BN8XGAeJ6EsOsnJZecEomY5CZ+pRW18py6UTedt4YRFAk3lD8Z1n8Yk4VAPwPQgqhHF94nctTdpxOJtaz54exJb6FamPu+ntC5SOuJcTwWltbemFeOe4AOLk3OYMzryujHRPvOFO+0BGD8qQwbqirNDb6WWROfzHdr15m7dVX19BAsmW3cjrN9hHTuy4R9P0sQBEk5S1S0FovRG0oWRpPSE5ERXMcJHt3Cw6CYpVlFxjmlPCFORgq9X5RK69+3cH/TV8pUQIPISqldBq+AJTqzCHdBBAJ1QYTbJ6aDDaK30t1yxfOXDVrVeg1S0oqI2DtUAt6LmjunBIVUejzt5PUpRoiFau4NuuiaW858Ff2ryjkZH7QJqiHNxK05bmGTey7522BK6tgTqMqya1RsAFb6RO3bzGboXGBIBhpNbozyW1u/3n1voMGLfnV1+cHGSr2F09xLEXmL3Qtp6AMHsa2GSacckQx3pZfCGWn+dXHRFR2DkeIvcNKBuVplfbx4egRi/G1YB+/78b7YJNy2mN3YbM2sdTsq2knxH96pANDY+99bymVsLd41CzfV/QrCTWNc+1U9jdohcovbiN+FlJ5TAyBWKZatzNYUBXdIAT9dF3i9dcXNTKct6c2qBG/HLFCOsdPHztqIoRNkd9jSIfiS55XtXiyL6YMmfujy5zAR0M0Q56OylOmW7VMcWBbhaPEePg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 05:59 AM Harry Yoo <harry@kernel.org> wrote:

>> +	/* The caller may hold a raw_spinlock_t. */
>> +	lock_map_acquire_try(&zone_nolock_map);
>> +	spin_lock_irqsave(&zone->lock, *flags);
>> +	lock_map_release(&zone_nolock_map);
>> +	return true;
>> +}
>
> I'm not sure this is a better solution unless this could be generalized
> or abstracted further.

Alright. Here is generalized one.

diff --git a/mm/internal.h b/mm/internal.h
index 85cf7be..1de6292 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1688,6 +1688,44 @@ static inline bool can_spin_trylock(void)
 	return true;
 }
 
+/*
+ * An IRQ handler can allocate at any point where IRQs are enabled, so a
+ * _nolock() caller can wait there for a lock that is IRQ-safe.
+ */
+static inline bool nolock_can_wait(void)
+{
+	return !IS_ENABLED(CONFIG_PREEMPT_RT) && !irqs_disabled() && !in_nmi();
+}
+
+/* @lock must always be held with IRQs disabled. */
+static inline bool spin_lock_nolock(spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	if (!nolock_can_wait())
+		return spin_trylock_irqsave(lock, *flags);
+
+	spin_lock_irqsave(lock, *flags);
+	return true;
+}
+
+/*
+ * The caller may hold a raw_spinlock_t. The map has to cover the critical
+ * sections of spin_lock_nolock() up to the unlock.
+ */
+extern struct lockdep_map nolock_wait_map;
+
+static inline void nolock_wait_begin(void)
+{
+	if (IS_ENABLED(CONFIG_PROVE_RAW_LOCK_NESTING) && nolock_can_wait())
+		lock_map_acquire_try(&nolock_wait_map);
+}
+
+static inline void nolock_wait_end(void)
+{
+	if (IS_ENABLED(CONFIG_PROVE_RAW_LOCK_NESTING) && nolock_can_wait())
+		lock_map_release(&nolock_wait_map);
+}
+
 /* char-mem.c */
 bool file_is_dev_zero(const struct file *file);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fef409..f22ae49 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2550,7 +2550,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	int i;
 
 	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags))
+		if (!spin_lock_nolock(&zone->lock, &flags))
 			return 0;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
@@ -3237,7 +3237,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	do {
 		page = NULL;
 		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-			if (!spin_trylock_irqsave(&zone->lock, flags))
+			if (!spin_lock_nolock(&zone->lock, &flags))
 				return NULL;
 		} else {
 			spin_lock_irqsave(&zone->lock, flags);
@@ -8115,12 +8115,19 @@ static bool __free_unaccepted(struct page *page)
 
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
+DEFINE_WAIT_OVERRIDE_MAP(nolock_wait_map, LD_WAIT_CONFIG);
+
 struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
 {
+	struct page *page;
+
 	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
-	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_NOLOCK);
+	nolock_wait_begin();
+	page = __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_NOLOCK);
+	nolock_wait_end();
+	return page;
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
diff --git a/mm/slub.c b/mm/slub.c
index 5c33d12..5bd00d1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3821,7 +3821,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	n = get_node(s, slab_nid(slab));
 	if (allow_spin) {
 		spin_lock_irqsave(&n->list_lock, flags);
-	} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+	} else if (!spin_lock_nolock(&n->list_lock, &flags)) {
 		/*
 		 * Unlucky, discard newly allocated slab.
 		 * The slab is not fully free, but it's fine as
@@ -3939,7 +3939,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
 	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
-	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+	else if (!spin_lock_nolock(&n->list_lock, &flags))
 		return NULL;
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 
@@ -4543,7 +4543,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 		if (allow_spin) {
 			spin_lock_irqsave(&n->list_lock, flags);
-		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+		} else if (!spin_lock_nolock(&n->list_lock, &flags)) {
 			/*
 			 * Unlucky, discard newly allocated slab.
 			 * The slab is not fully free, but it's fine as
@@ -5608,7 +5608,9 @@ retry:
 	 * kfence_alloc. Hence call ___slab_alloc() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
+	nolock_wait_begin();
 	ret = ___slab_alloc(s, gfp_flags, node, ac);
+	nolock_wait_end();
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with

