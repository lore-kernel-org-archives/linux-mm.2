Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D17FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FF46B0088; Mon, 13 Jul 2026 17:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9A06B008A; Mon, 13 Jul 2026 17:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CE76B008C; Mon, 13 Jul 2026 17:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D68E6B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:29:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3C951201A8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:29:02 +0000 (UTC)
X-FDA: 84985043724.22.D196116
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4451180003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:29:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fP3C2ujB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783978140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQQoNjvYMy7swaXdt0/pPw+8PJHakFz/v63Sfote3Ss=;
	b=KRkHqdATzwQkMMLLXFE623/obYzTf4QJpoaA0glcKLwL2DN/4LOIanCwXwdG0pung5APkA
	4Xaaib1mWdOf2LyTr3Fn5HJA4kK7965bfU9gas8YdlE+D8cvxgd/98gRtZ9r59YF+dLZic
	hI8txYMY+JU+0Gh/vV8tHoH6jOCiRiE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fP3C2ujB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783978140;
	b=YEOz/oGA+HwC3VkYcEwr3nZVbgrjtGGMKfcDM9NpGwVXM0s1IE40QqWKluzgwg7nWSnEyL
	Vkbd/hqctLexQAHy61/5HhjAkjrg4Uog5/e9xiS6qMiY+lp1IdgMqo7wxXVxOoDY5CIcQf
	HdQk6o4ic7GmImpHEvL1pGmHqLPJWgw=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so2322365e9.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783978139; x=1784582939; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZQQoNjvYMy7swaXdt0/pPw+8PJHakFz/v63Sfote3Ss=;
        b=fP3C2ujBZp801QtUnwQihZKntgZFZjHDUN0faXGyVn7/J7qm7aCSdPjH6T72NK5Nt2
         I1146eFqXJjfCCOhKiZMbs/vXs0v4qrn1kvCXTDT9LBDwVXEwlhgGeJTE/sFBu7JoLzd
         vu89KFnlUShte9qJPxdlTBSbgn6BKSk2/LbeDEfz2/2dm6FeufCXjFXTqO8mkpgtOBE5
         pWuMIlYj0+tPT4q+utwGyYSqa/XTgP+hkmMyjY7onsj3rgi7MbGsd2jEgsOs2UxFvGtu
         9duirgRxqGShBlb+gUn8ZJ9hkTwZ1LZjz/qnLCxmolJJ9G4XRpCNegSo/kV2kyGewmWs
         T8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783978139; x=1784582939;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZQQoNjvYMy7swaXdt0/pPw+8PJHakFz/v63Sfote3Ss=;
        b=hWDQtCZGDAoiqCty0Dqmzp2xDvv+wkXdA9VT41VvsXGmvSVC+J11QsxZY6MKurzZst
         P2mUVW3rh6C3QP1PUt+WTBpPFPtGKMHBz9HqCmXnZMoOfZ7uTDZ0Wl3vD/uDYdRjiVUr
         lWUHER3U5eO/HVRn7LpFJK+Hdm1cOoub5j7IplAYT5MQL/9MeRN4gKPZ7qTYVdhEqrdY
         jTXHJGh1H8drk//GdeNn92oD24m/JsC9UG9STeLM5rKdBTRJg9/WJbsjxXz3YaYwkay9
         96rZot6RHwwGkjw0evl/4pZkXXQUMi1tMR0LALwBsTQAI4bo/RRj+yC+lCiU88IZX0DP
         lZ7g==
X-Forwarded-Encrypted: i=1; AHgh+Rrm/BgP9CyXiPrb4RjogwJ0XAnYGM0GIMRvAoegc6S3lPl8ep+pA8HPfbZ81Het78pfG+EovHFh3g==@kvack.org
X-Gm-Message-State: AOJu0Yz8ZccNkS5VwftojZWlC4myWLyrkHuC+LCaq0tJ9hNBVS8VZevi
	SioxrR1JNWdcxymeFhk7YnCsvtiDElBmKTMAZQbK+hC8CuaanMOKMmlv
X-Gm-Gg: AfdE7ckcMaYBUSftrXhYToXrxiTRaueXugiap7R5dWLeBMY4AFHoOhIEiYQExwkH3pE
	7QIKuRsOoz4KH6v3ka64ao3egx00T7G+OVNZG6/VgXpMaBWiH5q2LJ25zIaf0ykXnbQabawMIiJ
	0g4EqjJgmXW3H80CjrYCAEdJHvxIESZjpHPMXXv7vABhI6Yc6akstBQR2dT81NuX2CV+YGoa+SP
	ezHHP5kNvKeocePbw0AENz+eO12ZjZIqHR26VfSX8ncuSnLFe3VeST2AY+4eO6AJpJmWz4AIFTS
	Ui6DSv4jp2ap+nBeswt/jJOQf9HFsq7ClGfVpSWlveSXA5UkAeux5Dutxbz27RLRxIl1DgcnbJz
	+r8EH4FdFoz394FMuy31HOh9NoQxjnTJ/B7mvEUlCYfuX3qnQaeIaweSPEW84btNTWKJiSPXtX3
	2jmHWZJu2rCxn6/OUari72ooxfiCtxgPEZ
X-Received: by 2002:a05:600c:6989:b0:493:bfbf:1da4 with SMTP id 5b1f17b1804b1-493f881de65mr104977295e9.22.1783978138921;
        Mon, 13 Jul 2026 14:28:58 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635ac2esm2503549f8f.13.2026.07.13.14.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:28:58 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
Date: Mon, 13 Jul 2026 18:28:52 -0300
Message-ID: <alVYlIPpCEUNBjeA@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713073158.CHjwei-N@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-4-leobras.c@gmail.com> <20260520150736.HZnlFkv7@linutronix.de> <alQKlBaKIOAxMzc2@WindFlash> <20260713073158.CHjwei-N@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fy3x5d1xmz16dcoomapbu565dmbpufio
X-Rspamd-Queue-Id: C4451180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783978140-65288
X-HE-Meta: U2FsdGVkX19vDWzfeXTz8wwT4N9LBlIcyHV0Uljo1vjBz9er2tTfZECuCfovj3Sodl2CYxhmpXbC/5OdN425A5Iz0XuSNmVJ8xP/ayRPWqoD17yHDrBppTfE4eppfkoIq++xDoylINu6nuOTVXSqzYh4c7zQ94ir+176qT7ud186qxn4Cxz40LDlXks0GN1q43II34Q+wPocWCK/rG1MzG8RjAFQpZzY3J2GWdwPPHo5rH62uhxYQqVITtaOLjGJeQ/Yr+89mzCCxWCWysin8Vc9YbK091BO6HhNDFrd66U9EkKuB8yOZxRM49cGzKIArfCLuTHuN3+ebtc7thMXxJIQ+c/iul7V35U1YJjcE60Tb6NE+0x4Tdb8bsB0Z1ZWS9vqh9yAs84ynjEYIUDHzD7wsHMvcfB8z3n1AvfS/NkQlKLR7UHGHN/uhadxWIoz8MV+lLCbmJetWSeGxcUqwy+A/trwdQGsqTkrf8Y5Ng4WmSebzAaVUIkxI4X343c2XvL3FA9L2NQ7lM7shMY73kUDg6ueq2ptOFOF/bNUvKB5fAopE3q1h7P5iShrViWVgH7c06skqMwXf4lOZxx9YNILZ7pCY4KlbP3fWsLT7a3l8CYuHsKSNLYHb7c8dSbFx5VvrXG9sQyYbPvM5bJEVvTzUQrgcBE5lAuR/b1QEIIcWdFih9dqkCJR28gAErSKdwdB9Iwfmx7NLP1gb9VRmz7ERdfhZhcxVj+sKoWMWzEx4q3xIdVYCojF2QTWPs4ei5TWNW4z+lZvK3uYvER+Uu/Zva/zSSh4uY3DqOB4kwQ0NjDJkK3fk2A2DLyjlE/EVRg5WZjJDX2/vrOAQUv62T2/pGq/DU7xRbVWemkrdRIpDicm2hdODPIRXLhoOrNQfg6L/fmTx8Re0OAb9IJxM2GuunxL/eRmxWEYVPR8GjWEXIE04D5/uTBSWLfgUmB6fA+aVFY9/PuqJZZCxqy
 640kw453
 0YuNI+9a/Yxm/D4TQHWw+dF6EnEiBNqF+VK5N0OFqrE17jO9K4TpPAzYaNa/y3xKNIhxyyBYT+ZARG6tlyWwmBj0u5HgvRUHJG5UqJ5bwnSFmf+F7px/hbI/RFsRVWLTe3r4nAMHKUJLzqeXMzqWb9YZ6gffoCY8/7Wrw7ZPBhpnGURqw3oian4xY58qW7NDRFQ4XPkjznDKU/nGf9dJNl+/WpzAyH4IPW5YNQSZzFDX9HqQ2NwFLRZQeT51GwwmPlWpym7X5OBiBjcPaQLUI4WZuOL1cpyTE14tLDmgScRnUAXL0fea5Tatn4BCuNFacFrPtb3LRD5h0JLtUCxSxLrUcExIub5fLbBbi1MxQmxHJU8+Gf6kX5kt4TGODJHWG+BOQEANE5YypV7GlUKKTdf7avCscDiYp46P/t8pN6KgMutwWPwfr0W1a6ZAhBM0BcXzd0Ov3FyaBtolVpyGHhSg8t9A5Qv7zZLqCNT+NsBAXB01bucCBiEdEK7Wikdf9+XQtdPofyNT7ki5wdWQalSOV4evFNSwbK/Rmv/dVF8AR+HNKWq+8irDDTj7HalRDxUjUTHCqL+Fdy6SaqpcL5MirnzecokmAJhWY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:31:58AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-07-12 18:43:48 [-0300], Leonardo Bras wrote:
> > > I thought that this improved since commit
> > >   ff042f4a9b050 ("mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu")
> > > 
> > > Did it get worse or was it not entirely gone?
> > > 
> > 
> > I worked in this patchset majorly after that commit date, and it was still 
> > an issue up to last time Marcelo tested. Not sure of the impact of above 
> > commit, but I suppose it may have brought some improvements without fully 
> > fixing it.
> 
> It would be good to know what is still missing and maybe it can be
> addressed without introducing this remote locking.
> 

I get the point, but the main idea is to make this as proof of concept of 
the mechanism, that can use to solve the latency introduced by IPIs from 
per-cpu workqueues.

I remember discussing all those examples with Marcelo in the past, and IIRC 
to solve this we would either have to use per-cpu spinlocks, which is 
undesired in terms of performance on !RT, or skip remote operations in 
isolated cpus, which may have weird behaviors, or disable caches in 
isolated cpus which is terrible for performance there.

In any case, the main goal is to get something generic enough to deal with 
most cases, not an individual solution.

Thanks!
Leo

