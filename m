Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256C6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F314B6B008A; Tue, 14 Jul 2026 06:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08AD6B008C; Tue, 14 Jul 2026 06:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E3F6B0092; Tue, 14 Jul 2026 06:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD4976B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:12:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4622F802CA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:12:54 +0000 (UTC)
X-FDA: 84986968668.29.ED0B7AE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 867461C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:12:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zk2GyPuL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UX4RPTay;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784023972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTkmerU8UE91t1uqi1Zg80dTpHp+N6TCCSgmWke5AWY=;
	b=7GbhoK1x0r5aYygIrVtiVSLwKFa6WKtMDGV24RaOXQ7qWvAso/R0IkXMn0ACBwLdUmIBRW
	Xq/GDfH3EIP1JS4eoEZlMkB97WptliTEa8PrkVTp3XocfLOtaR9yO9BS1X6PRXEqxEptag
	jJjUts2x1Ok49wS6kxwUsTvDDKSwmbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784023972;
	b=Y1DhsYbyv8RiKLvSVBmhJ1EMOaKECASgZ3MTubnqswKr1BSVlFplADKd978k6Hgm/1VRSh
	yqN2YV8gyU+oJrO3wMqUM1p+pquudz3Xi8+Oo9PXOu4eaVc1OfEIrl0+Ica6fH1cQ2GckP
	LoRkiMZRbI8fAkTwz16DcWZrv9qeFEo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zk2GyPuL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UX4RPTay;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Tue, 14 Jul 2026 12:12:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784023971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iTkmerU8UE91t1uqi1Zg80dTpHp+N6TCCSgmWke5AWY=;
	b=zk2GyPuLv/CULvPLi8yopdSODYUTrhGxZKZk8dd8mzHUNuBSoZcHm43puFTCkFjFXm8uD0
	EKzG/04UrVUW5/s+MKyPIecaj7TnLKSsJhra2w69fUBlZqCRtgex48kf84oZWv+ijO7xUB
	MXwsbqhdUvynljp3nafCL1enVh0Xp8d/AJUv6JgfXle0ZzSTTq8sBb6IEcWVhyy4IO8/Nf
	/s+UlSdE/v9xVUUZpvRTJ4pVRv9yKjQPDDR3a25XVGjttjZOmrgfZv5qsP92UwibxkupX1
	ZRClx/XM9C1sf50o+COZoIqgSIL+m5BDD0Lri5/T6Nvz3L8z47TpJqgu3s7SUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784023971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iTkmerU8UE91t1uqi1Zg80dTpHp+N6TCCSgmWke5AWY=;
	b=UX4RPTayR35zaZYCZZkIfXYdmcBvYC+h+fQ87S32/PfxvcS+wsHmXehsVSYaPPhLzb4Uhl
	mvzIyqsh+iM8wJCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Masahiro Yamada <masahiroy@kernel.org>, Coiby Xu <coxu@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4 0/4] Introduce Per-CPU Work helpers (was QPW)
Message-ID: <20260714101248.hV06z2cr@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260520130903.Ebsd4aUa@linutronix.de>
 <alP58SgTc2_8OFPc@WindFlash>
 <20260713080723.XOTiibfG@linutronix.de>
 <alVV44RO_SolaqMW@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alVV44RO_SolaqMW@WindFlash>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 867461C0004
X-Stat-Signature: m857mjxxeppki339kzh1ysfgfcsft7s4
X-HE-Tag: 1784023972-216195
X-HE-Meta: U2FsdGVkX1+jWTC9rdjrPx0fCMgpbZHXCjw2b+x0EMM3OS7sztIcvzXtJ+KVes5e7Pl+NyygFJq9nBtTd8pdnOmAD72zJLJTeObT28wQMsuvC2npgQweXODFjFY8G+kWtcInv6EEja8Axg2o19QjBsE2rLIKn7LYUhd5ppf8dxwyeVHy3OJyKZM/dZryIGZ+iqboDLkZ7isZugkpehftnPWEOslRSFqEL5NObcH6lozqPMCf6OijvkEgiQIVDcNTa+rag4I3f2QCFV75cgU6/N8pMNeuAwAKnanjPfRXHxwBUFRwwiodcfKpoytd8urC4RHEeFKj/YYJ+wFG26eRhqJQE6Y1TjoD/92ibbI9PabBsBsrwB12pAj/Ou7a22YztRdagRMaJyIVAEgBXtKIt+nq3oxFg2ESmzQtZfoabhFvrm8sMxKelY6y8MTQn+QVbErAgXfxl6S/WcR/zfoeK6nqvuDPrBTJjQRIQhJyj8ZItLDyQTuFEA+IAyJ+uQgPRHvPlZ/CKUFUhjsIZLnzxOOgfySQe44rzLWcN/CGijyEuHhS2HAt3pkiKtrcdihUXW3Sm5WsMohO+a7RjeIVHpZ6qncimytU9dYQzlwsA8iSG+PHpwURKwNOPl0J4ZadomnxJIoP9otM7VSdjePhxXQQV4wxxlW5jQS2bDOYo/6IcxrZ5gmj9T/efeVptCKlVoMXpcjkqGxVLQG0nRdGDcE862wv2cDXIIek63i+wbTo3U64qcnt5rlTiUmUIG/zAc/2ARlono3k+ay400OVRxSeNlRH+k2laMNnXAkeePu9GkbPRphvoOUOIHKbrs3Oj4ThD17HVHmDYRCcMnUDOhgra6qSvRcDBvLW6JE25qseyqGv4oC9Fn7t/FCTnyFjod6CZa/3Slml5jV2nO05If9CVfmoyN2Lcj6nwKMPJUvQduGMbWBHLcNXEhDgsHWNLZmZhuKSW1JhIMTDWu3
 4YzGSETG
 coXV04FfiJiET9/GxUIog9cd9znIqkoxPTL8k4RijAvaiH6yBbec96e7oxsxp9GD9XvxlMn8W/aEcIQewRdPv3t3nFSL9+0QOhxYS06x5XnSKqe/nw8/ubSIfuwYoV/iCHNTfhH5M89108IOf5TrVscqmQ46hnMINamo1c/0afjEUBtcyUeAwAb8fdirpsDPFQ2VxRJonCTsr7X+zbJYR39MGY3Agzu+SEJas/owtQZAWep080ZmqZlvsEAZO+7Y6lrsvFNAqbko3UJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-13 18:17:23 [-0300], Leonardo Bras wrote:
> IIRC there are multiple users of this mechanism around the kernel. I 
> remember picking the first three (swap, slub and memcontrol) as examples of 
> how to use pwlocks (QPW at the time). With the concept proven, I could then 
> proceed to work with other potential users to replace it. (We ended up 
> dropping memcontrol in the process)
> 
> The main idea is to replace as many potential users as possible to reduce 
> as much as possible the amount of IPIs in isolated cpus, and allow Linux 
> to run workloads which require much lower latency.

Right. I am not entirely opposed to this idea. If you can't improve the
situation by other means I would consider this as the last resort. If
the mm folks are on board with this, then even better.

> This idea came as a general solution to a bunch of latency violations  
> Marcelo and I were coming across.
> 
> Thanks!
> Leo

Sebastian

