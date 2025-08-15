Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E56CCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5C28E021B; Fri, 15 Aug 2025 18:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD0A8E020B; Fri, 15 Aug 2025 18:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24E88E021B; Fri, 15 Aug 2025 18:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF3C88E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:53:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79584B821A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:53:25 +0000 (UTC)
X-FDA: 83780494770.26.2017759
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id DB1D280008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:53:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PuwaftD7;
	spf=pass (imf02.hostedemail.com: domain of 3YrqfaAkKCKETVEBSTBONHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--sudarsanm.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YrqfaAkKCKETVEBSTBONHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755298403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFMLvpP6SQOf3Z5/hje0uPsmcH8OWRP/M8qsuDbYAZA=;
	b=Io4iG3f6Ud29AHIuRIlPIr4GNSnUhbzYtFg3d5KhG/VtRLJNwlVT61IJOu+AHLrOcEsfDy
	E4q9FBs5BqKE8JzkQeTA7FU2b/UcJcoou3W9ApPstOlwwc3ucw5oIkHgoG3MLyXWo/t5vK
	qvVYUeQkEnm8px/HcGq6WEnWLZdmvmk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PuwaftD7;
	spf=pass (imf02.hostedemail.com: domain of 3YrqfaAkKCKETVEBSTBONHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--sudarsanm.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YrqfaAkKCKETVEBSTBONHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755298403; a=rsa-sha256;
	cv=none;
	b=0t0yb0xsJ98JIACoQiIRINDnDcJROEl2gnGeFm3gUA7GErQj7OyoqYQVh8zU39IbBhK5tC
	g0TsIgyAndRUiRWKKssXPXwYVwpV+SCq44Ef1/pvEOy2yG5OXvE2pCR14nUmMgzcLiwPlN
	QggTgQlIStnQou3uM3sty3rPm41uqFI=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457ef983fso42614215ad.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755298403; x=1755903203; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CFMLvpP6SQOf3Z5/hje0uPsmcH8OWRP/M8qsuDbYAZA=;
        b=PuwaftD7f8FiQALTgX5pKuSNUvaLtvFazzqb5/0Lk/kJDBi8esKAJYKDRXxdd/uxLN
         CHeZoxXxwg9RkzuOWJueku7IqJyy1lblIz8zfeI54ZP2fdVikiJOlrwYc071ZhYPoArz
         ChgD4Tp/TjHINBIFKQcO+64UPSD0IAyZo2gkuUBZ4GlVKMmkU2eT6pa5OC/WvCzA5PIL
         Q/OzX+jrMcY0WIpfrYG+mlSWXOVvKREnOpXxnCDcg7iftkbs/FQEnJwzPvPJnBfHXJcm
         auTE02SJPmeR9iA4AyLFJdn+mP1mpnpRorgmP9Glbj9oA/T6AduhufkMJPWAvhQjQdRj
         pIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755298403; x=1755903203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CFMLvpP6SQOf3Z5/hje0uPsmcH8OWRP/M8qsuDbYAZA=;
        b=EFKlRsQJsTY3CJQS6xHt9eUAEc0tto1D2vsu8W5U7pvuuw5rPYDf/OE87kNDN1r706
         Tl87JJQqPPmQ4sB3IsPciMhPKyNDoOuPeP+huXAI3q5OkHXU7U6rnD1D/POxjQ6S+rSA
         ho/Li3GKfVu4ExRp3shXIlxd844vwuftRJlebc/IxHvqvsvx+lRHTxQ1RJqosYrNLMQI
         r0881cVCB5EyIQdxLj/ShthihpIR3avpk0XZGNfTZ7OaXwNLV0d6sxBa+M+p3H+eiWGZ
         5qOxqaNfCGPjQtNfojLmnihjBV7bqf+azu5+HY7Obid3OVh806qcQ8cZ1UEPmpyWPGdO
         yrPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa4faDOhBzqXyyRM/BISC66eQBxTDurC46m3lv9GADL5Jfc6q8+bqP79BIXKL9K1wKSOG1v8SIPw==@kvack.org
X-Gm-Message-State: AOJu0YwtBKbxAUiqwLNxNcsGrxy0SjXQtu46waa0o0NDSrQCvBikij1w
	C9RowNAwkdLL8BjTW/jlrrjcM/QFnMmsZUJ9dnqpsQLFKVtJDn0CabKmT3p7A/cvfczYKFXQJBJ
	CL7gW+0qAxdXYRk1QKg==
X-Google-Smtp-Source: AGHT+IH7JBK049AunCZUq+7FOlhgfZ1QYyvLcXJcq8h6JxKHDaYqMNRfr1A1z7pyw1f+47LqRRmiZD6Bg10U5YM=
X-Received: from plcm7.prod.google.com ([2002:a17:902:f207:b0:243:31a:f8e2])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce0c:b0:243:8f:6d7d with SMTP id d9443c01a7336-2446d93d241mr44547495ad.50.1755298402798;
 Fri, 15 Aug 2025 15:53:22 -0700 (PDT)
Date: Fri, 15 Aug 2025 15:53:00 -0700
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
Mime-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815225259.3012455-2-sudarsanm@google.com>
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
From: Sudarsan Mahendran <sudarsanm@google.com>
To: vbabka@suse.cz
Cc: Liam.Howlett@oracle.com, cl@gentwo.org, harry.yoo@oracle.com, 
	howlett@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DB1D280008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wymwco98eahast7zr5irbi6m4i773e46
X-HE-Tag: 1755298403-811723
X-HE-Meta: U2FsdGVkX1+EGZxXCvfcYXwfiAIp6ewLE725AqX6nPYXs8iNF1RuucOOwkyiQ691nM80dpDUgpCW+grgFkl/EBGXa56CvlIMFmFvtrE8T3kVgafzggeEyz0V5zeRBSpHlW+Ndpqn8wSzyJjQiWBIiH5ShQBCuMKUtrD1oluEMoihb4wh0pHwpTNaLIjDKp59V9oeG/vxLlzjRut2B2BD51MQh/FQOiiGmvDE8CbkAR+/nmWF7U+jW/Ah0imb2uAVj5rgP6YrV8fpnCT4Z6zEHRP/20/PptymOowje9uwu+ANLkCg/NpQ0dBx8tdb8dCSy56jb/IKobylafvTnngNIwZq1VqEW1aXzGJWP3sXFTg4N9lX39mjO5xGBVsTRLvlV9cwYbuCoyWtbsPntJ32KIFr73ujOPykubYxzuyLhMGF7BGO3eRyTN1ZPe7U2oFXFUy9HwpLEeKAVOz9QanJKUc9ywpOulIFygQo3GiQE+QjPDTPV99pISo4CtnN0i66dzIBGDOEmlxKtSlIHx7KwYlXrjZBU5RjB5CcdTkSl+MK4SJcjuZXo8bwGx9WncJi5a3ZSMMbpUomo/6M+/H7WvFGkffH7UB4fVje4WwwrZS9+UkTyXGfAup12Lv0K8VUUY+CMj4TLybTy7lDJypMjBKlWrW6P0gB6z+yefFSPJCCJj8+tH7KH1lH0OL/BjaPy1djO2rumi2oxF+pd2dQnFt0yCF0504VirXeSpEUHd7934S/2XRN7OGh2qXYJJNlUBXHMtxP0Ff8gCMCkjTH31pBOpnnpMU70Ig3YHYVabn1gPRG/Mxbc3+GtqyBXmhzVeZbTiKQlrhReS0nnBtArP7a9sfr5bg2+FYJ668YICjOR2QQEZ+G8wOZensuRaGxacKMGjO9MgAHXiUw12R1UOLQwOcsJhgvhnEGOEFP+cRyx4Ev79ToHdvTHp7THEs9FRG0Uvxg8SDM5EeOmf6
 o2KzZVDH
 2z5rRmYMQogP18pSFHx+yNl/DJhNOVUJ5zugs2S6kh/91+12WFrFdzV4RItVTqYDpRuUWZCQoyN9Dk5Z2LVHEb0Ym/v5YDBYNh1eFHxDIHA2oOVsiyIeComr8pugGk7tfUGwdekucWc8NZkQV0zl147sb7Ar6sS2yqBm4umE/Zjbmp+6dVlsBtfaEsAjT95AAW3/hhopfOmcOWxh1cO0q9aGJ5mJAKqie8n/3H5OaHZXtmPuUJlwRT/+T//5Hwf5h3ewFMTNpforR6g5auGlv9fptNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

I ported this patch series on top of v6.17.
I had to resolve some merge conflicts because of 
fba46a5d83ca8decb338722fb4899026d8d9ead2

The conflict resolution looks like:

@@ -5524,20 +5335,19 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
        MA_WR_STATE(wr_mas, mas, entry);
-       int ret = 0;
-       int request;

        mas_wr_prealloc_setup(&wr_mas);
        mas->store_type = mas_wr_store_type(&wr_mas);
-       request = mas_prealloc_calc(&wr_mas, entry);
-       if (!request)
+       mas_prealloc_calc(&wr_mas, entry);
+       if (!mas->node_request)
                goto set_flag;

        mas->mas_flags &= ~MA_STATE_PREALLOC;
-       mas_node_count_gfp(mas, request, gfp);
+       mas_alloc_nodes(mas, gfp);
        if (mas_is_err(mas)) {
-               mas_set_alloc_req(mas, 0);
-               ret = xa_err(mas->node);
+               int ret = xa_err(mas->node);
+
+               mas->node_request = 0;
                mas_destroy(mas);
                mas_reset(mas);
                return ret;
@@ -5545,7 +5355,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)

 set_flag:
        mas->mas_flags |= MA_STATE_PREALLOC;
-       return ret;
+       return 0;
 }
 EXPORT_SYMBOL_GPL(mas_preallocate);



When I try to boot this kernel, I see kernel panic
with rcu_free_sheaf() doing recursion into __kmem_cache_free_bulk()

Stack trace:

[    1.583673] Oops: stack guard page: 0000 [#1] SMP NOPTI
[    1.583676] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted 6.17.0-smp-sheaves2 #1 NONE
[    1.583679] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
[    1.583684] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
[    1.583685] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
[    1.583687] RAX: 0000000000000000 RBX: 0000000000000012 RCX: ffffffff939e8640
[    1.583687] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI: ff2afe750004ad00
[    1.583688] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09: ff2afe75368c3b00
[    1.583689] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12: ff2aff31ba00b000
[    1.583690] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004ad00
[    1.583690] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000) knlGS:0000000000000000
[    1.583691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.583692] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4: 0000000000771ef0
[    1.583692] PKRU: 55555554
[    1.583693] Call Trace:
[    1.583694]  <IRQ>
[    1.583696]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583698]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583700]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583702]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583703]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583705]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583707]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583708]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583710]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583711]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583713]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583715]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583716]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583718]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583719]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583721]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583723]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583724]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583726]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583727]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583729]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583731]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583732]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583734]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583735]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583737]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583739]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583740]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583742]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583743]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583745]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583747]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583748]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583750]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583751]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583753]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583755]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583756]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583758]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583759]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583761]  ? update_group_capacity+0xad/0x1f0
[    1.583763]  ? sched_balance_rq+0x4f6/0x1e80
[    1.583765]  __kmem_cache_free_bulk+0x2c7/0x540
[    1.583767]  ? update_irq_load_avg+0x35/0x480
[    1.583768]  ? __pfx_rcu_free_sheaf+0x10/0x10
[    1.583769]  rcu_free_sheaf+0x86/0x110
[    1.583771]  rcu_do_batch+0x245/0x750
[    1.583772]  rcu_core+0x13a/0x260
[    1.583773]  handle_softirqs+0xcb/0x270
[    1.583775]  __irq_exit_rcu+0x48/0xf0
[    1.583776]  sysvec_apic_timer_interrupt+0x74/0x80
[    1.583778]  </IRQ>
[    1.583778]  <TASK>
[    1.583779]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[    1.583780] RIP: 0010:cpuidle_enter_state+0x101/0x290
[    1.583781] Code: 85 f4 ff ff 49 89 c4 8b 73 04 bf ff ff ff ff e8 d5 44 d4 ff 31 ff e8 9e c7 37 ff 80 7c 24 04 00 74 05 e8 12 45 d4 ff fb 85 ed <0f> 88 ba 00 00 00 89 e9 48 6b f9 68 4c 8b 44 24 08 49 8b 54 38 30
[    1.583782] RSP: 0018:ff40dbc4809afe80 EFLAGS: 00000202
[    1.583782] RAX: ff2aff31ba00b000 RBX: ff2afe75614b0800 RCX: 000000005e64b52b
[    1.583783] RDX: 000000005e73f761 RSI: 0000000000000067 RDI: 0000000000000000
[    1.583783] RBP: 0000000000000002 R08: fffffffffffffff6 R09: 0000000000000000
[    1.583784] R10: 0000000000000380 R11: ffffffff908c38d0 R12: 000000005e64b535
[    1.583784] R13: 000000005e5580da R14: ffffffff92890b10 R15: 0000000000000002
[    1.583784]  ? __pfx_read_tsc+0x10/0x10
[    1.583787]  cpuidle_enter+0x2c/0x40
[    1.583788]  do_idle+0x1a7/0x240
[    1.583790]  cpu_startup_entry+0x2a/0x30
[    1.583791]  start_secondary+0x95/0xa0
[    1.583794]  common_startup_64+0x13e/0x140
[    1.583796]  </TASK>
[    1.583796] Modules linked in:
[    1.583798] ---[ end trace 0000000000000000 ]---
[    1.583798] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
[    1.583800] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
[    1.583800] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
[    1.583801] RAX: 0000000000000000 RBX: 0000000000000012 RCX: ffffffff939e8640
[    1.583801] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI: ff2afe750004ad00
[    1.583801] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09: ff2afe75368c3b00
[    1.583802] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12: ff2aff31ba00b000
[    1.583802] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004ad00
[    1.583802] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000) knlGS:0000000000000000
[    1.583803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.583803] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4: 0000000000771ef0
[    1.583803] PKRU: 55555554
[    1.583804] Kernel panic - not syncing: Fatal exception in interrupt
[    1.584659] Kernel Offset: 0xf600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


