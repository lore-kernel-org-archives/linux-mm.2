Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCF9FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 04:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D8D6B0005; Sat, 28 Feb 2026 23:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0011F6B0089; Sat, 28 Feb 2026 23:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24AC6B008A; Sat, 28 Feb 2026 23:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEF0A6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:10:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40F4F13B1B0
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 04:10:34 +0000 (UTC)
X-FDA: 84496167588.17.EDB49CA
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F914180005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 04:10:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cqIeyuF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772338232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfkmYxNazmSUYov2VmIhFLWiffqz1ZOTBMBqaFvFj04=;
	b=Tz+ctADh1U8qDkPnij6VyPBmlgJC0wFu5DwNvmVBvRb/nhl3Ou9KUm9CUOylLlZfuNjkxx
	NevFPUc89z0/PgiESXI7ootDU8aHs+/IQ3yG0Z92Lr/ZkcilFGAp+nFs2NOuHBm633Nk8n
	7Cd6iKl0N7lxdNeckC1kHfDEdKlTZhs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cqIeyuF2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772338232; a=rsa-sha256;
	cv=none;
	b=Lb3OkH263/kppWVo9xe+PkpAUYA5W+Q3aWiq/gi2h4wy1kuzWvVdrLVfLGkRSvzxp+Jh65
	kPLdQSsAkjS+A0AP+mnG39NFcMSAvCg01EweWjqnhoJzyaflXaM6YyMzNSpIcUH6g2vLQz
	5kchsR/YegHqQavKo7oqu3QMAZWV/t0=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ae43042ea7so6759905ad.0
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772338231; x=1772943031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bfkmYxNazmSUYov2VmIhFLWiffqz1ZOTBMBqaFvFj04=;
        b=cqIeyuF2lvGF90T4SkZ/QK9itiDTWGlYnUr8wvk74/kL0vnBafoytSz3bXtI1+U8tq
         DcoIiqhX6ElfgxUWeBvAkIk+GR4EG5ulluuMhJJoR122scYP1bJBxdAe2mnXWZgY3MSu
         r1o/JzOU65oSGX/O3v7nCbZdmEsMWEMWWoE+WK2th3mLYNeR+ZoEpviJknw5bqnBq/E1
         iQOtqNuWodjUgcnoRx1TH6S+0UYy/5ekCw1llJDV9/O7DbXa4cCeKJp/ONxLTZfD42vV
         kWtSCjxa+M+KQkNEyGiejfnhC+89+01WLxJ9AjwSLwjAGoTqGx4dJqhLNUvvPrtCbQVI
         FGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772338231; x=1772943031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bfkmYxNazmSUYov2VmIhFLWiffqz1ZOTBMBqaFvFj04=;
        b=srW/syvKs3PxPz/Qtmwvc46BdBtqEmw5DRynNtCs1FUf/nnGRXpsTNFLhQoyH63ji2
         DsM/mEmMOl4mE6i+YDB6fVLYalADyjvpvcWAFISimAhrbMgjpZMax8KOpBRqEp3T+8Ss
         lTtg0E1C2UdDI0e88kBcgx7f/PupFSjuIvXBGX5jhC6pig8L0mE2Ua/yXnw7s/e87GZ4
         mzdkUPwTHSjumCTdji2genGMZpUQapjoFss8f4/zkJiNve6SXfqVKsURgPvUj/aVjJB7
         A/icd9PlygGiDvwc7yCYRr81arRGQE91qnq+/vT+qjDNS1wYKJ00f+fJaO1VtITYxXVg
         7pDA==
X-Forwarded-Encrypted: i=1; AJvYcCUIg+FGWUZPcaBvkznpuqAF9xnLpHvq2HOjGCKwu9UxQ2oDkRR2skRT5TebiVi70241TOJ0QiU5nw==@kvack.org
X-Gm-Message-State: AOJu0YzbiN1A8YlMHL/iwgGSaqhH5UPnKiarVuWsGxLOyCZTwEJdt2mt
	iua5oAx4AIhKYYrSKmYDqmNIYUZHBlowcukK4Cif3hxx3zMPjnTS2ZwA
X-Gm-Gg: ATEYQzw8UWN2uHIFVQ7UZvDMld0x+W8cNoJFOAIddVHyF29bkxZvxSlVCTGPxtO20oj
	IhwMhmh2Cg9VQUfznJAQPIms8bpwG1Prz7bIQdjrjKzppmHJbuuffb13J4zgZoVcPkmwZDP2rzL
	gVXSSGW2FeCeZVx3JAyiOAWG0eSXjN84RxOnXw+ddaW+9Cz2eePgOl+By3ulwIxqeZ6PrrfUhD8
	XHpFzyFbuJwL19Wr0W1PtKUUZLeyH5rAYCS0KJop5gdaL+pydxeQKVJL2rj1bFdOigxasBXcXK7
	JUeVNbIecv1xrBT1O61zmlNOllrtK0SdqgU/ZvLhraXzIEle2vcIK8431eufnBTNsOIm5H4v6L8
	Q45Mcq6nWCI7zOxLbuiKYx2JyEe486mBY5AtBON9LwCYRAJzIpx/6AKDU997tnydDQc616dQQ7B
	owYjbhBQ/kytZjuInx4ow0VMO2flGRSCGd+pHt
X-Received: by 2002:a17:903:2c8b:b0:2ae:4a4:f483 with SMTP id d9443c01a7336-2ae2e4bbd3amr79194265ad.49.1772338230844;
        Sat, 28 Feb 2026 20:10:30 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae489c3626sm8136105ad.8.2026.02.28.20.10.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Feb 2026 20:10:30 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: lenohou@gmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	laoar.shao@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	weixugc@google.com,
	wjl.linux@gmail.com,
	yuanchu@google.com,
	yuzhao@google.com
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Date: Sun,  1 Mar 2026 12:10:22 +0800
Message-Id: <20260301041022.66111-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAGsJ_4yCA008MKV8OKoV=Ge3B_KS1gnVxEPED7VQBmxJxR35hQ@mail.gmail.com>
References: <CAGsJ_4yCA008MKV8OKoV=Ge3B_KS1gnVxEPED7VQBmxJxR35hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F914180005
X-Stat-Signature: jc4bqndm8wyiw3cygr8ud51craczh4cy
X-Rspam-User: 
X-HE-Tag: 1772338232-991196
X-HE-Meta: U2FsdGVkX1/jtOWDvWl8r9e80SFFlGxTcH2IaRSUh4e0TQXA4vCffoO+bmlEQS0R8M1tPqhdAZbKARpfo3+bJxAeMyFL2ndczpQCd7BbXMqQ7kORwQH+ztdzt3pj+rYlU82WB+2mqTzx3dQ7k7a0/1JwQvtF9llamPT695MoCtzTStbMu9Q9PWz5IQ6daKxeHxItmxcQmAi9O7LaW5HfR9zTP0W4MAPXtrFzAMshHJ7eZt2Kb55naBhYdTkQj+CtQ+sjoCVmn98PStnZC0y5pTtre2R+k67OQCSsgNfnWDbTn5tBddwJD6wXyAR073Cu9IaHMQd75mtVFE9TpbIdzIR3k/57OuGDewogT1bGrRUCt84WiXn4ON+MRm6XUW4J8NhMWbw3G6itj8y/T4QD32FFnMothOa/wEobbMOVpo9UIG2Ci2not7KJlFtC3qFJnLlAa2IkWdp092tYEa26XSAEuKk0kU/aPAfEGfvksvNdXzXNSNISNp480gj3sp3X0dDAENnTVtAFWXfPMgPi5Z3JhyQeg7hv/jGmL2Oe19XEiEO69v5ozYyT4nO6CenCsd6dt5ity5SkVXgZWLS9v88QA7rZ7e0ePXx9SVs/u+yvS5CQpZaGeLfrCkIILHFtorVXwqZ8sMzX8VX23a+ZPfUO5Wqn3IDYOmUzSybed1e7L//7ChscZFJNhQnTQxw2BFGZFNC6/r00ctIrYmQl5SPrcD68XQbMH38mSBz8faU4SMiYB3HK1LwDg09db94SbZg/OvvxQXEe/1/Ly5cb1WHbF7kXuExk7pXTG4LhmtFmaaQ9yK6iQKq1knHjQkJC/f7nSIi+d6JnFC6EvIaTdDfNVkguNAwyq1mOFdRLQfO2qj52/vVTgY3BRBoafVLXIiFaztMKA7oDeVTcbqjq8lQmEF/q30CkZndZ2VeI3Oq0ovUqxFePRh6rPiB8SaTwAP0xZ/fLv9i4peNogPv
 vF7nNOEs
 nxcR2qPpzdP4HQvZZbQNCqJlw/Plcp0elmTvBsmqkXK1pxkXBLvofTLwwprUMXiRtfXzpO59RVBYmPSA0TAROl1nBbZSZoJxLGYqrwqopln5jDjucK+Pa6sx4M0MP588/VoKZToo6KPnPOnbPhXdME+lUlkv7sG3dYb1RFxGZ2JvcQToUTgNHi5BBjwE6dpkbFixZkmhdaNnTMZriYw+XvE1NEfnhcFcM5KNpvpecmFfWZj0Na30Um8Y3CmF4SIEep4uAvFZm2H95hHnUnyMM20xrJH7pEaNaZPN4PVT0lFdtXkX2bt3nPdA0EONb6g+UqMKchd0SpHVc6QUz6KjuMiD9gZvfOyQ6bqtzoPhwSp93Vf/ewU8v8gDBF9HyFSi3YgCUwjOzGMXfkeDC6qx3yRJjoMTaK/53plqNokJdODMZGEyb6aU2iQqSDi0LPSI2zR5uzUbK5EcccbyulDkA8oy4I/6DOS3XKwYO65+WgsVm+j/3xwDPZ06XeY+9nuYWneAl+ISr47XpkIfQhVjfpxyI9H3ph2qh4Ttd9Xe5u+Qd2bgBZHlDBBb7Nq7AjxAKwfu+w6U/Gz9eH/AFMm34wEnCnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 6:41 AM Barry Song <21cnbao@gmail.com> wrote:
>
> On Sun, Mar 1, 2026 at 5:28 AM Barry Song <21cnbao@gmail.com> wrote:
> [...]
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 3e51190a55e4..ba306e986050 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
> >         /* whether the multi-gen LRU is enabled */
> >         bool enabled;
> > +       /* whether the multi-gen LRU is switching from/to active/inactive LRU */
> > +       bool switching;
> >         /* the memcg generation this lru_gen_folio belongs to */
> >         u8 gen;
> >         /* the list segment this lru_gen_folio belongs to */
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0fc9373e8251..60fc611067c7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5196,6 +5196,7 @@ static void lru_gen_change_state(bool enabled)
> >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> >
> >                         lruvec->lrugen.enabled = enabled;
> > +                       smp_store_release(&lruvec->lrugen.switching, true);
>
> Sorry, I actually meant:
>
>  +                       smp_store_release(&lruvec->lrugen.switching, true);
>                          lruvec->lrugen.enabled = enabled;
>
> But I guess we could still hit a race condition in extreme cases—switching
> MGLRU on or off as frequently as possible. The only reliable way is to check
> enabled during shrinking while holding the lruvec’s lock.

Sorry, I was talking to myself.... Since the switching and the 'enabled'
state are not inherently serialized with shrink_lruvec(), their values
can change at any time, leading to race conditions.

Therefore, I believe the only safe approach is:
1. Do not allow enabling or disabling MGLRU on an lruvec while
   shrink_lruvec() is running.
2. Do not allow shrink_lruvec() to run while MGLRU is being enabled
   or disabled on that lruvec.

Something like the following:

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..c4b07159577e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -509,6 +509,7 @@ struct lru_gen_folio {
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
+	struct rw_semaphore switch_lock;
 	/* the memcg generation this lru_gen_folio belongs to */
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..aadf1e7c31cf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5190,6 +5190,7 @@ static void lru_gen_change_state(bool enabled)
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
+			down_write(&lruvec->lrugen.switch_lock);
 			spin_lock_irq(&lruvec->lru_lock);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
@@ -5204,6 +5205,7 @@ static void lru_gen_change_state(bool enabled)
 			}
 
 			spin_unlock_irq(&lruvec->lru_lock);
+			up_write(&lruvec->lrugen.switch_lock);
 		}
 
 		cond_resched();
@@ -5680,6 +5682,7 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
 
 	lrugen->max_seq = MIN_NR_GENS + 1;
 	lrugen->enabled = lru_gen_enabled();
+	init_rwsem(&lrugen->switch_lock);
 
 	for (i = 0; i <= MIN_NR_GENS + 1; i++)
 		lrugen->timestamps[i] = jiffies;
@@ -5780,10 +5783,14 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+#ifdef CONFIG_LRU_GEN
+	down_read(&lruvec->lrugen.switch_lock);
+	if (lruvec->lrugen.enabled && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
+		up_read(&lruvec->lrugen.switch_lock);
 		return;
 	}
+#endif
 
 	get_scan_count(lruvec, sc, nr);
 
@@ -5885,6 +5892,9 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	    inactive_is_low(lruvec, LRU_INACTIVE_ANON))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
+#ifdef CONFIG_LRU_GEN
+	up_read(&lruvec->lrugen.switch_lock);
+#endif
 }
 
 /* Use reclaim/compaction for costly allocs or under memory pressure */
-- 

Thanks
Barry


