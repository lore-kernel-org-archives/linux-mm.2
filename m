Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2D1EA853C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 18:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5876B0005; Sun,  8 Mar 2026 14:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A34E6B0089; Sun,  8 Mar 2026 14:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684A46B008A; Sun,  8 Mar 2026 14:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5942C6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 14:00:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F33BE13B2F1
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:00:42 +0000 (UTC)
X-FDA: 84523661124.19.BCF0A01
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id E827440003
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:00:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WNhndBv+;
	spf=pass (imf04.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772992841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WigD4xTv35FpDIaB0ncQLYNkLlhATinqtn7c2ncFLjE=;
	b=rULd6rEd2yX8NF/o6moDvrVrMHvvMDEhvgyorLNha0ol+p8ocJXa8abMVIAqwPSmmdNKWo
	pYfgwr4woSoA3LdUnd+JrJzeNcrezjT0at1eggVS+xhzV4LgSOQq0/+BRu4G8ESKt6iZ3O
	QJ6i2lU/kiphOY1nurqls19SPBNr0HI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WNhndBv+;
	spf=pass (imf04.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772992841; a=rsa-sha256;
	cv=none;
	b=WTVMo/xDM/U4y+YVBpbl9ML3fNmpKGJIsDzrZpekiv1nlCH7+17YJR2kltHDjole+XgQ8o
	ZK77PyG6CAFh5gpR2rCwCV/yTbYZqTDW5L6yYg8yYHb4eySWwot2r/yZUWnnh1E/4Chb+L
	0ohiOvlrWTDK0DqcPFMvmE5S0f7/Xq8=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852ff06541so11777255e9.2
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 11:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772992839; x=1773597639; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WigD4xTv35FpDIaB0ncQLYNkLlhATinqtn7c2ncFLjE=;
        b=WNhndBv+ROzC7lMUWv0c0qXqqrzs657aruYsFSn+k0TOK3US3XQt2OpD0pDdmg7Dih
         ozBWI60KU3DW9ZJkdE3aDCYsmKYUKn9UGeoM8QhthO9ivwhqkqp1PWSakuUhiLVQxzA2
         nTOKpyvFahwElHkDjzff3QlE1QIg5U8KD00yLreruO38xYb/0yB9zMAj+ePvk2xPTkfO
         DeTejFIuLcsCOBEyiLE9zzQa6irCSRdHLO531URGGU+ju2V2tJutFNRxwtwWAw0djb1w
         itnhC16MTNWCbQ5WnqqpsTWLdKC7nDYb12Frr7fNSS5BkHMZfiiA/rQLXBbLJwXIBKwM
         DoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772992839; x=1773597639;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WigD4xTv35FpDIaB0ncQLYNkLlhATinqtn7c2ncFLjE=;
        b=J4woKDKZkHdJU6DDMg5TEnP5TemdxmFx4bv4YunMwRVk5UuIlkxFBtMXq2bWDRdAZZ
         zDm1Dm6N9a0MUw532nW+YJhVI0lwxirVPfcHskHE5qDYDLh5gLKyUKKWSxuHSO8JG0xj
         uR69qNtVyv70mK1UuRkrQcNmm9KmQPPivrQNkrE9NKK6AH486jQVRVTumUwfmGjfIqhB
         aPqJp6begphwNRUVEsSu4XdLWtJ2Rc5OzW+JpTZhAK3FG50cEhXNBkF4DUuCbwV9MWPJ
         /wd3Rk8hiRgyYnrkKUgHJl/TsvD2mgIp1gQ+O0dJ8O+G3d7KYVD7w0ed7o+rop7BzkLt
         fJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCU0zHEwJjUaGxmjo+xYlMJqKO1wRQsBCp0cgCq1DyyP6lak0Xa/cad85GOqloPFOyGrxnSQl+OzHA==@kvack.org
X-Gm-Message-State: AOJu0YwysVPFIx9GZBryUTnqlOmhhY/XJ/7a6RkPWKpgDwcgbdZQDGIW
	BT+wSpla+PhXvXpeMvW6y5RFy3u8HfMnUhcm0BW5i014630Hj/fxCbrqt1KGh5c/
X-Gm-Gg: ATEYQzzCsInmDotj00E8kcGlK6jSeWLYPNhI77uVUZ0yINicGXqXmc0TKcTL5yovPfN
	ZE1E/oK7Bz4Dr7/gupBxzVN680Cafoet1SmLlBqww8StEoL4vT0pxStQsCPfgx3OkpQid6SNpYe
	MQSZOPLT4g8rzcXyOVB5wNnOaWr022GCIZJMrCMrWarLF9x44bXVHVmOWGPP2KQUWl1hZTuBRU5
	3oPqSaUZIoi4lnXUqduTK0/h1noBd+3guBfAIyNCRZrG8Ddb/woHmHjJU03ufBDcuqbqa1BOD0M
	fNZ/0GPPEhLEIznIDxPizKPRwruxJdnRetqJHFCeJzhKKO1lVnFF60GiVlyUsYZiZvyZrmYW/45
	otIw2hpbOolJnSqvsvWHNEea6KlRLX1EF1kGu32BICjFZv8NdDH392XGpAAKz9uEoV+urHA3kCo
	s8cuGoxiH1axtI/Pky2CihafJIuOG70KKr8tQ=
X-Received: by 2002:a05:600c:450c:b0:485:358b:e802 with SMTP id 5b1f17b1804b1-485358beaebmr46396005e9.0.1772992838937;
        Sun, 08 Mar 2026 11:00:38 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4853438017bsm119290095e9.0.2026.03.08.11.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 11:00:38 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sun,  8 Mar 2026 15:00:26 -0300
Message-ID: <aa25OmY7HlbU5kDV@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aacGBc9x+zn1tluU@tpad>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org> <aacGBc9x+zn1tluU@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E827440003
X-Stat-Signature: hyqmuqfb4pcyxxza8q71amgzwqxuynmh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772992840-829626
X-HE-Meta: U2FsdGVkX1/rburTIpANWwyQQteXzNaFiMOfqgsFk0iFgjmY7A7DRDfs6+GlSkHevJtO/J/IOo1NBKwIHDZA7vahNjgx3hSHgfI2qsNT3NmOceYL7qtvHyYPLPec1zLHyjW9FeHfcBHgjM27ckO+Bc5xVEN/F/Ntub0xnnQYWiLkncFboxuHoxZy6+9t89Lot8IjEpl2t83Y1sJ0C1V4jwSUpPaCFVTtPqvY0EO/2ybN84G0fahAYjvV8nT80ECI1mpLImroJbt7ooC3KduOu7MgtMDLn48ZkFpBJMbEPdUMIHXtzueE04fLuB177A2WIqlHTLu0FVBpfakFGR6sYnQItCjFSzkOeAUXBSncaYXtAPdF7rjkrXsogSH3IZqso6P/tJxllduIClbnLQR6m/VHIS5KToNqKiQeUbMdCHj3JdOaYTirE9SVcyHhAhxK5Be9qbPdgccguaFkEK0K0TL3/UgHCGCOg2wzfzlMa6vnoz3WTtDctpafZs9rITc3U8SDnu0sO4dMLNeUONRrLi5ZXUxeo6xRmQh0dxyyFEEAUkC0kaa+/zMXQTkx9brRbo1ifSWzbgqyYtuvzEEhjv5Apre2QJoVpNKAXyTJQTTNRhmrBIS6+7IaVjJTREGxQ53233klN9mEtWdP6Gr7RyZs4oMBeoiQjAimz5jlJdkIAc3XjVywLW3LP3Zu8zgPmI8E3QMug9erkUfxntn7YZYymLAr9LVlzATH4f4XyFKtGnHPChK7bDmbxMrbrx3mBsHWG5XICKGlBF5vFtqKE62PwSCCr/mjLQOsBpA0qc5yGdI6nrx35cO3ZSwT1w9aHm0fzijohdUrRUZ2nnPtFf9YXCUFMKEUX2n8jOOVcZP4TMiMc6+dfruqk1F+1zrBXmG9akxX91LJC26Tj8IE2N8q00cPp1ypC0NoiJ1Ug4IyzRTNzzsrbQ1YgrZ8LLthphcpgh/gTLZWRGVKIxX
 aX/zT5jh
 aRBCxYbwDU6PSEQQc4fKlbMutXX1zrXuWJAqJLrZzpZaX0E/AOE1RtUeC10tFNuw70YqBYyPqOyp9sSutZFdcYq0zPyN8cCtnAU8F7ufysAM/ScjTGoky5cNDcnxYqERY1/0xamC5oqjyqSCeAIAtmgiXnz3kqMwK+qxC4rmzpg08eU3j4RKOdtHgNYLZf07116P4cdMYYBv5bBY+qs13dwX2wVS90U0PNjCXbQ7Qw54+qXX368jS5Ji3q1dU5xDSS+2GhvuB6tQ6YHuBcVcEhOGnbBB8uqpNhIt8atxQ06Hns7HFrTd+Y35rJ2M6CCWwloJu44UbTMrKf7TyvMDKFAMi/wBq0NmghZhJYbIeDf5nxpnt97KfrpFnR5MszcVt5D/jHNf3DaNt7kw6A7lne7MeSxZe7SvhFnOaMX19vLhzWcseyJZnPopE3whyCVAiDDcW7gGXn5sMMQS/+WKI5uIDSBAeAeSrNWrhAhyf2rkqRZmKU8oLqt/Hz/SFFNp0a8fpaddjimSjQcsPAVSZXgZUxcJmj9cmS0P8CAvHQJDSfEFSREdN8vFMK43+LB05bwTl/L2UzmP5dbJxYygn0FnX8sI/oxJKqN5v1QuN3xDjIOAgLaYUkxc9aI18vj2KzxRosMOg9y05NYcOAec4Ix74zI8DIl4/1evPxGINyfkksRv0EI1TGoBBW6rDP1QJgxjwzGjmxk//n0EFy2K9it5qMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 01:02:13PM -0300, Marcelo Tosatti wrote:
> On Tue, Mar 03, 2026 at 01:03:36PM +0100, Vlastimil Babka (SUSE) wrote:
> > On 3/2/26 16:49, Marcelo Tosatti wrote:
> > > +#define local_qpw_lock(lock)								\
> > > +	do {										\
> > > +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> > > +			migrate_disable();						\
> > 
> > Have you considered using migrate_disable() on PREEMPT_RT and
> > preempt_disable() on !PREEMPT_RT since it's cheaper? It's what the pcp
> > locking in mm/page_alloc.c does, for that reason. It should reduce the
> > overhead with qpw=1 on !PREEMPT_RT.
> 
> migrate_disable:
> Patched kernel, CONFIG_QPW=y, qpw=1:    192 cycles
> 
> preempt_disable:
> [   65.497223] kmalloc_bench: Avg cycles per kmalloc: 184 cycles
> 
> I tried it before, but it was crashing for some reason which i didnt
> look into (perhaps PREEMPT_RT was enabled).
> 
> Will change this for the next iteration, thanks.
> 

Hi all,

That made me remember that rt spinlock already uses migrate_disable and 
non-rt spinlocks already have preempt_disable()

Maybe it's actually worth adding a local_spin_lock() in spinlock{,_rt}.c 
whichy would get the per-cpu variable inside the preempt/migrate_disable 
area, and making use of it in qpw code. That way we avoid nesting 
migtrate_disable or preempt_disable, and further reducing impact.

The alternative is to not have migrate/preempt disable here and actually 
trust the ones inside the locking primitives. Is there a chance of 
contention, but I don't remember being able to detect it.

Thanks!
Leo

