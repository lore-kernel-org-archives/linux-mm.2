Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DB5CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D0F6B00B2; Mon, 18 May 2026 21:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B7B6B00B4; Mon, 18 May 2026 21:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5816B00B5; Mon, 18 May 2026 21:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C67C06B00B2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:28:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 923D61C01FD
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:04 +0000 (UTC)
X-FDA: 84782433288.24.ED42155
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6992D40003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ds29aoHL;
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSA5ue1X4vqSsU9ce40m8EGDnzYMIz0AiRlAoh99mwA=;
	b=f03oI9Q82sIL3kYT0eoSFG2sAs4DaZJOQ8qYuc1RSDWPaV/njwgMYr9zxA14Ztl+BQLCik
	1ic34fjHrygyOEcyc/tj+3LDB52hIqyNi1Tnny7TSGhPuVEOnWnkTpkL02cJQwRHxKqySI
	4zZ06lSgKbXeBxqLcWB5L5bpw9i9NS4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ds29aoHL;
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154082; a=rsa-sha256;
	cv=none;
	b=dc0iAzDVNB5IO79zBFux+cP1bkm/+YdQFJTOUKNSBvES8wvrvMlFS2RBMwi2lRYBsgOViq
	bIvv9RDZnRMvYfQzFO3PM7YvsMOJM9HmF2DspA/4ovyykPSFeEoczJJ2kn8z5ItJpnnD5m
	jm9jFlpEPGnW90V8pKJoGovK6DHW2s8=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4526a8170ceso1300901f8f.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 18:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779154081; x=1779758881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSA5ue1X4vqSsU9ce40m8EGDnzYMIz0AiRlAoh99mwA=;
        b=Ds29aoHLuqltCafmXyoz4C/JRN+Sv3yUJVWR1Z3jtBfEgu9V6NSHiU8nelf4reI3Vo
         Q505jN8ywPf5rGERQIJF3xewfFMmwRsZVAEREinremDTe01XmX57PFymsBObQXs0Qled
         sCk5HcTlE5eeCE18h+WnvoLgVe+njKj74xoGEY5qKci1A+vhyiDVyFAx1UnihhR82+IY
         SzAmVv93ht2okQ/ftxCLD3Qys1kHPHU+qeMKZuT0q4PnIfm0Qt3zyUj681BCXepaxIqG
         6PydyefiUniu/JtoPfyF6lNYb/a53lX3t1GxZQm2pXigHqp3EKYYSZWyZQ2Gw7ayLmJa
         2B+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154081; x=1779758881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rSA5ue1X4vqSsU9ce40m8EGDnzYMIz0AiRlAoh99mwA=;
        b=cpjq1UmOOierPFe12su0CUnJzZlfYQlZY51UFzkrP+kcmtrdWMr0pkTqkt5fCM18Lr
         SgjqQvLmvvGfwlfKwgPMCQjkFaPc55F3kDWd4Fu+E6WjrncVvuy+6xoppZCwqrODcq35
         RRJ1lbwKL5uM6Fe2e4iW9h1k7amcmk4p7UegTx8LQ5av+C3a0meADzlRiv23I5UhF78G
         WslAG3dSAH/RjMF3cdJudZetAVn3VMEayiigWU04Zr5E5EMRlDDmHInPLcUhSuPSokEM
         wOYvX8gHBDBuSOxkwuMulJLSh1cu5lCWlAijtT10ajZVND/PnWfcOrsTeo9SnGSVztmS
         385Q==
X-Forwarded-Encrypted: i=1; AFNElJ8vN8NY8QHJZeN2Y4vvb7Bni/d4cRdnjZmLzHpWUHLhbN/Q33J9Rz6r8sOecHS1/DydH2Bs1NfRbw==@kvack.org
X-Gm-Message-State: AOJu0Yw/INxvdoPaH5bEu3TPSyqN4HRtGL+Y5nV4vPFofJT3xnJ08bra
	dWPcTm+HA3e7G7dgEHSTvlkNntLwyOTXBrzXnP3qu+3THThJQBrVAqE+
X-Gm-Gg: Acq92OEDv2dZN+68a4G9oGe4IXqB3Orv+HJs2Xx6XuFFVfhRiX+lseTFr2NpD+/rkvr
	3M4/6DWEMYRLoPUWk5xIKeo7Dr3bm5h0SrjijJ13giTRyzUsJxgqLenibrweMqJeGEqutTh+mRp
	gFnJTnrJB83CF+C36jxngdh9QTNCaIbPN9qbAg1atuaSKXuJiHlgA3cinr4YPx33hhAzJXq2OVj
	wTLsrcM9K66GMmFjgbAcAM9tIVSGq5UfyGa1Xmoi9FaA4FQOVHCv9DA1LPeZgInaysYoTOVxmoA
	uby4hKKoSmB/bdeAGIz3sqw7clNw7OCgmxo9Uk915hSkB7PVSQteEHg9pqx3R6mfmuHmsKn+vRD
	gwau70epUuNkJmo2uHfSS/u/lq03JltrpWm/HcgEhyjqORRtmEdccZJzi4eNESbwqqiQhTq03Kq
	oqJh8iDj44rM8JHb0bLA512JMWyS2Yiw==
X-Received: by 2002:a5d:5f90:0:b0:43d:300b:2285 with SMTP id ffacd0b85a97d-45e5c5be273mr27212388f8f.11.1779154080739;
        Mon, 18 May 2026 18:28:00 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f83:8501:800:cd4:5e2:9556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm40548683f8f.16.2026.05.18.18.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:27:59 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Leonardo Bras <leobras.c@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v4 2/4] mm/swap: move bh draining into a separate workqueue
Date: Mon, 18 May 2026 22:27:48 -0300
Message-ID: <20260519012754.240804-3-leobras.c@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519012754.240804-1-leobras.c@gmail.com>
References: <20260519012754.240804-1-leobras.c@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6247; i=leobras.c@gmail.com; h=from:subject; bh=dnloqw2ofMQgHOlrcYy0lnqm5BG7U4//P9axIvgFWic=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLK494TzVnNUJFg81Ts0ocTPLebpfN6VmUXcodwz5y0JL 7X/fq22o5SFQYyLQVZMkUX20fxVPN+nZBy58mMBzBxWJpAhDFycAjCR/dsZGZ7evOjOcdlPqGRu KOdb71KxD4+SpaKb4ybbzjk6J2V9UAjD/4xnL3beP7nksgDT/e+u/+W7W/7N3vX6d+XkTRuYzVd UL2YFAA==
X-Developer-Key: i=leobras.c@gmail.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ytuim86pddm5a7fkjzmisaorc8g7isr3
X-Rspamd-Queue-Id: 6992D40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779154082-213944
X-HE-Meta: U2FsdGVkX1+wwXyZgXJA5eM5xukfTnUELn9qP/wnzw1rYQLatJJOZVLtJ0DmZLueog/u9Rlbgxy9IUVpTJJ4/BHay3R9sz4F251NmDY19/AGLA0AY0XFNS9WNK5a084ZjyJwXfBVzSyQfXfMhpx7gK8U+y7H8b4eQIbCrJP3NZ1Y0QSpre/zCeFIEHBGOQRW/QGekuRr55mGd/IRZ23Wfh5eo4B3RsTnM9iqglqVPfBC4oHy+alMDWxyHb0/epocqjXzpOzftDOZ7Gkfz0eXJJc8U8lRvNmZjzFmzf9c8YVLicAlj+Lz8IfXWPCgJyAbdPXbAaILA7GWA+Yfcpt1845lTGiepm0IalURld7d4neUC77SGFjTXOeHLS9Jn5n9wwuFGb0EQwdZjwUu6KxHlLSdnE29vba+GjXkEcckfQEBB++wZKrCNIqTUE527Jc2USAhw73vUiql7CQ/Rbo/UqX1NwWRk865GF7qWCkns/7B7RUl5I1HjBThMetJqI0I+mJu0uJrT3Nkr5OByseARl/icmg4E8ofxNJNwAwAr4DJDhLNtoJNkI22s/BZqsPGM9K5GGlP9FtudeQc288MdihdH4MiLWSPzqGLU8G30jcMqTdTq+fDRz8F2lRiljlwEdBa/T8k9WW1HpH8YNIhMsySgdE4RVnh9mlQ8uk/nu2F2aI9GGyqTQBx58bsBU845eLLbXR9ptBXwsbSNZoVDVynUz5P0Jzc2uJ5ySNnvtSzKVzeNcHWyzNO8U0ao8PZCUs4WlUE3UKTjoE8C9YMdZp12MfDCFRxcxyuibB07O2KD8FvlZZl3D95W96qmoVPVMosFsMl0zUfeEEOK0MOQZrXg/JW3cUIhwR/aZdwOpS5jalkcxSEwv+hpuzQfyhuqthI1MyzxJ7XUKB2MVW7IdwhGG/RB8mW9GvmRNfN7p5M2jmw9Mm051Ean6eZvLe+n3UEHJZjtAixhaNxC63
 AhO1sIAs
 dJ1IvPcEhIuJ+m64GKmkA93QIt25ErLx77fbXduUrQyTmqm36gza/jIsiC2f4RF4/jpuD5xr8vomo//3T8Jj2lyelV5B5v+06elEXgVE0ynSFJhv5m6jOy+tb6djJE6ShHubkHxi6IPwSdd3kqLjmZau3IkbFQyuVfywBqVRZjKHnpTtH8zO3oCwNlbCT3NqjwkOp+hljgKOoDoeYcYx5ugHBpcks5GhLGxHC9yTB65e15bNPba3KIVq290J5MOC9peU8tT2dKlIaj0GO6Sx+1HPGVPmC3rM9uv89Taf5fkO1Sk0IhXrSkZcHrn9E9E21gCFhX6AyLJtcpbkPS3Q6yGdUk100KCnEOMp4yMqav9tdMl0tH1QeDdyRvaEOU1UTp7rh73xsfTadVTvoJb3/gcaJNJGJfpzF3GoNkpgh1phuPSSlOPoM0vHGZFi6+aLAtekKJW4UF1kKCqJdu9nYPEErbOGk0+okNPwW/GqAN7RRq6gI86kiJjZ+TsRviuJU5O2RiklwN0Zf7HNz5Z0tyBoopUOS5kR9DhSDNXJQYHsGxbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Marcelo Tosatti <mtosatti@redhat.com>

Separate the bh draining into a separate workqueue
(from the mm lru draining), so that its possible to switch
the mm lru draining to QPW.

To switch bh draining to QPW, it would be necessary to add
a spinlock to addition of bhs to percpu cache, and that is a
very hot path.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
---
 mm/swap.c | 52 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..ed9b3d371547 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -744,60 +744,70 @@ void lru_add_drain(void)
 	local_unlock(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
 /*
  * It's called from per-cpu workqueue context in SMP case so
  * lru_add_drain_cpu and invalidate_bh_lrus_cpu should run on
  * the same cpu. It shouldn't be a problem in !SMP case since
  * the core is only one and the locks will disable preemption.
  */
-static void lru_add_and_bh_lrus_drain(void)
+static void lru_add_mm_drain(void)
 {
 	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	local_unlock(&cpu_fbatches.lock);
-	invalidate_bh_lrus_cpu();
 	mlock_drain_local();
 }
 
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
 	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	drain_local_pages(zone);
 	local_unlock(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
 #ifdef CONFIG_SMP
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
-	lru_add_and_bh_lrus_drain();
+	lru_add_mm_drain();
 }
 
-static bool cpu_needs_drain(unsigned int cpu)
+static DEFINE_PER_CPU(struct work_struct, bh_add_drain_work);
+
+static void bh_add_drain_per_cpu(struct work_struct *dummy)
+{
+	invalidate_bh_lrus_cpu();
+}
+
+static bool cpu_needs_mm_drain(unsigned int cpu)
 {
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
 	/* Check these in order of likelihood that they're not zero */
 	return folio_batch_count(&fbatches->lru_add) ||
 		folio_batch_count(&fbatches->lru_move_tail) ||
 		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
 		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu) ||
-		has_bh_in_lru(cpu, NULL);
+		need_mlock_drain(cpu);
+}
+
+static bool cpu_needs_bh_drain(unsigned int cpu)
+{
+	return has_bh_in_lru(cpu, NULL);
 }
 
 /*
  * Doesn't need any cpu hotplug locking because we do rely on per-cpu
  * kworkers being shut down before our page_alloc_cpu_dead callback is
  * executed on the offlined cpu.
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
 static inline void __lru_add_drain_all(bool force_all_cpus)
@@ -806,21 +816,21 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 * lru_drain_gen - Global pages generation number
 	 *
 	 * (A) Definition: global lru_drain_gen = x implies that all generations
 	 *     0 < n <= x are already *scheduled* for draining.
 	 *
 	 * This is an optimization for the highly-contended use case where a
 	 * user space workload keeps constantly generating a flow of pages for
 	 * each CPU.
 	 */
 	static unsigned int lru_drain_gen;
-	static struct cpumask has_work;
+	static struct cpumask has_mm_work, has_bh_work;
 	static DEFINE_MUTEX(lock);
 	unsigned cpu, this_gen;
 
 	/*
 	 * Make sure nobody triggers this path before mm_percpu_wq is fully
 	 * initialized.
 	 */
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
@@ -869,34 +879,45 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 * along, adds some pages to its per-cpu vectors, then calls
 	 * lru_add_drain_all().
 	 *
 	 * If the paired barrier is done at any later step, e.g. after the
 	 * loop, CPU #x will just exit at (C) and miss flushing out all of its
 	 * added pages.
 	 */
 	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
 	smp_mb();
 
-	cpumask_clear(&has_work);
+	cpumask_clear(&has_mm_work);
+	cpumask_clear(&has_bh_work);
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
+		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
+		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
 
-		if (cpu_needs_drain(cpu)) {
-			INIT_WORK(work, lru_add_drain_per_cpu);
-			queue_work_on(cpu, mm_percpu_wq, work);
-			__cpumask_set_cpu(cpu, &has_work);
+		if (cpu_needs_mm_drain(cpu)) {
+			INIT_WORK(mm_work, lru_add_drain_per_cpu);
+			queue_work_on(cpu, mm_percpu_wq, mm_work);
+			__cpumask_set_cpu(cpu, &has_mm_work);
+		}
+
+		if (cpu_needs_bh_drain(cpu)) {
+			INIT_WORK(bh_work, bh_add_drain_per_cpu);
+			queue_work_on(cpu, mm_percpu_wq, bh_work);
+			__cpumask_set_cpu(cpu, &has_bh_work);
 		}
 	}
 
-	for_each_cpu(cpu, &has_work)
+	for_each_cpu(cpu, &has_mm_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
+	for_each_cpu(cpu, &has_bh_work)
+		flush_work(&per_cpu(bh_add_drain_work, cpu));
+
 done:
 	mutex_unlock(&lock);
 }
 
 void lru_add_drain_all(void)
 {
 	__lru_add_drain_all(false);
 }
 #else
 void lru_add_drain_all(void)
@@ -928,21 +949,22 @@ void lru_cache_disable(void)
 	 *
 	 * Since v5.1 kernel, synchronize_rcu() is guaranteed to wait on
 	 * preempt_disable() regions of code. So any CPU which sees
 	 * lru_disable_count = 0 will have exited the critical
 	 * section when synchronize_rcu() returns.
 	 */
 	synchronize_rcu_expedited();
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_and_bh_lrus_drain();
+	lru_add_mm_drain();
+	invalidate_bh_lrus_cpu();
 #endif
 }
 
 /**
  * folios_put_refs - Reduce the reference count on a batch of folios.
  * @folios: The folios.
  * @refs: The number of refs to subtract from each folio.
  *
  * Like folio_put(), but for a batch of folios.  This is more efficient
  * than writing the loop yourself as it will optimise the locks which need
-- 
2.54.0


