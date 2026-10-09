Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F9FCA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EFF6B008C; Fri,  9 Oct 2026 03:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0116B0093; Fri,  9 Oct 2026 03:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6796B0095; Fri,  9 Oct 2026 03:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C63B6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:07:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CB2680299
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:07:46 +0000 (UTC)
X-FDA: 85302207732.28.F36ED21
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id C826B40008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:07:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HbCbb0E/";
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529664;
	b=jNLe+ymcnwoPCodMcHW/VGVOmCFZnyqOnKeQS6H4QqApQpFcCoPWh5GctHugoWrk4aCjtF
	uCZFa1PRb3AIymOjHQMcIFmxa1petjzoqNP1i6ZPX+4QolwqaE+ZVX29rJj1ngdDFYth2p
	uwYXRuegZ47jmumjprKW2bqhMwvuQ3s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HbCbb0E/";
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKKm9SmEIl/bnNoeHMWb5gysBaP9kkRYpBJirexaJDo=;
	b=oHm8+G7r6ccFzYUz+JIvql5yRmDCSCEqFf2tV5X1cRBhjCF33gPZTV9YkmISmm4DdFTOMX
	45IewjVQ448vplqL08Jc510ABMJuOnTnETP9BY/HXS2Psv12jUV6H0Rn4yqw4WNagF8QBt
	HvLwxBbc3kXxhOkJFp5BZDlTnqlc/h4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso62547555e9.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791529663; x=1792134463; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKKm9SmEIl/bnNoeHMWb5gysBaP9kkRYpBJirexaJDo=;
        b=HbCbb0E/0nSXVkF/jk1hiyNIyYM/tGitxtNzNNoBqp+ppwQdvr+sSnDcU2t5cKygAx
         qx9fLtiZ++FLGSHJEZLduZovDAYcO4e9oClDQn4ZMSsshnYi3pbFX1hejNbkBaSwccOj
         pQ958xi0hMlOd9s0F4vxK82s76NGhfcgVWv8astPNDtAYSRJRMuya5HdS7larv6GgjGk
         YdywdBbUXjVCnPkSpM9K+OCvgngBUISa4U+rNcl1J3oltX6XPcPKCDd4b1jNksOqlvbu
         Q20+AShtT8V920u4QMBGBe9LQ6u5X/oob4PZ7/57qvO1592f+/4NmBGlwpiMTwDJSJVf
         59Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529663; x=1792134463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKKm9SmEIl/bnNoeHMWb5gysBaP9kkRYpBJirexaJDo=;
        b=CRmIcSKAHBpQOvcN/q1qBvu6s/HxumiCRXaOZ8GKfIst9y8smD4Je3BxZDPSQYX6At
         d93wvcM+asufIUcbRWDZ+/ScL2GZOSmfq8yKRbIvaiegyGCu8TggfaEApenu75eNdegc
         dzuUZ6BJo9khX12MPUU0ubmNTKh1D8ARQOGY8wlf7vfFsUr5P+kcmJq+JGrDJyJW2MBe
         WyIHb/1jM+hkVjrB7+WZaVurEcXBWyUcRYLBQ8toISAV3Qv2oc2Ttzjhl2Qa95nTNh9r
         tt+VBMOI+G6mqO4Tw3OUtwLgyuYjZlNnmAw6o8QCP4Gpj3gmuxzQ5PN5N8/H40m7glvp
         w8qQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4p3R1Uf2IXBm6iv+d6k5KDlSMcRIMekXj2Jf2KB1VG1VULUk2TB8yHh1hPL7LZpZ3Fsk9ma8xQg==@kvack.org
X-Gm-Message-State: AFuF++nAvmk5mN5+EZJyVtnDgfM/Sj8x0T4yYHO4LKUAcuW2OsduZQ1u
	16pdE5omzBFwfdbLCmWkeI6YzUIFiGTaO21bVSC50JqexdR6dWt2KxVn
X-Gm-Gg: AYBFou1mjV5Uu1AmyLVyhj2HiKusvzcx6vwCt1DdHLZfd0Dv0HB0kX2koid51bowdJW
	v+MX7cU79TH9Wf4NCvRt1NNIvxfUbBdqfQwhMm1A00vkgwBCnuy0N2vsIg4z68KcRYE+rSWLVEQ
	gUwH7Dzzc/w2iZXQGRLRdsuBh3BHtxP7U/Y53HueQWq19vly5A9HM2vSlIe8gPOobICtUXB1c3/
	juZtE5qMmkREYiod4wdRvzB432taOKpxUQhSD7qjzQrTacih/2Csybult+g9nwWTmekICVnN0Po
	8trIr3TGDjwFuEEiR/Q9x/aTEWn9YBBosuKqy7Vvrf8Rj/1oa3464t0Y+eSh2IuG0RcMdZuNBu+
	nOX6us89J01eFCfqkEgBhWynShaEbQr6Q62d7eypkNL1KJRUk3q9yRJjjecoZX0ZL9AEsExknpV
	ChnAI1qgHHXh4YU3DKQUPUo+DQ1Ck+Mz8J2NSu2zL4cB0EclKgniSSUz62LiOIHRXlzkuqmqH8R
	/l7/iezTOx9UMl81ruHHhHZSn+SlJbA8uxi0Kk6pXKBJDBunnf3DZ6LK7BelNjLIVPrjuJ2NCB5
	NEte0yLuz5lZIWWATQKkm+4c1LM2K36MWnKK3y82Ty/Ba4mrwath5P3AmX5+Jk28jDCBLzYVqI0
	A8Nc2x3ot2Q==
X-Received: by 2002:a05:600c:8708:b0:4a1:7b05:3a6d with SMTP id 5b1f17b1804b1-4a18e49881amr14849175e9.8.1791529663117;
        Fri, 09 Oct 2026 00:07:43 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a128-aa01-297a-7094-853e-a20c.310.pool.telefonica.de. [2a02:3100:a128:aa01:297a:7094:853e:a20c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm41656205e9.10.2026.10.09.00.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:07:42 -0700 (PDT)
Date: Fri, 9 Oct 2026 09:07:41 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge
 failure
Message-ID: <asiSUpAYYU8Od4HM@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
 <20261001044056.75079-2-kmehltretter@gmail.com>
 <asaAwg1KeZoEYd4K@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asaAwg1KeZoEYd4K@thinkpad>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C826B40008
X-Stat-Signature: eumpga8a1xwffk6we1qfo6bafaqmzxua
X-HE-Tag: 1791529664-394981
X-HE-Meta: U2FsdGVkX19K1/6wCkKsn1dERICW8XU6IhFjQOKetBFDGhBUEQrveFWgAcef6tYRwtwW+9YzCCfNtV1lunj2736w71Yvxd+kJot+xGX6ATVxtxp9csLngysu16CJi56ds1KX54RXVoP7wInvUKNgNGTPBnl2YRILCpaYYpuYu1ab8uqcTPfyK/ggplcCGrJo6GPcNIzgfrBXpTt22B2/9nWwtzzqxhvqroqRlxqaVm60X/QHCw/gx5mI0WS2yx0PBWA9aLwvNW1QcJlSwePL68Io6HyYcd2+nKc1XEV57K4mKhh5iUIpIVHUvBEAG1YETdKE1DESb0qPWBjqATBHMZ14jN7ZUcW9fLmoFN5z3teRDJeBizBPmyQAzTVWmwtAa/OJoZPLUTun2J2qj3sfQBMRoWxy3P7dlXb1QGXELY/xls97LA8y1Pxjg3SRRIjvO68pl/d/8vZUhOpQ3pJ3fR5xxuctA/anmoxEP5wAk6FMcZxJUQYhFTjGTYnRSre42NSDXomgcFtrOapVuijTzRPjGfSfR2B0kbfJu6P6Xdmn4rqKBiezEzCmHuE6KUuKYB/tXDUE0Cb2EdRTHXO3YJJs89O0Y0tn3X17muIKH3MgZHe9+tMGggm6Lc9FqCwWHhuunYB7M4YnbVztRMO2oRqsrWGaa5rgx2sYYqKw9Jz8oe/reSyDngufeSeuqntPgUBme61+m9FunB26plZFayhVAuVnJ7D6k5fSojuNlBNJMq3MTP/Kdo9Hw1oA2B4Y81hpzVc77D777UTDIvK+jCBgZ6yVfM2pNtypKQ4peZ4kdEza96dVuLxYj/4S/U3wess34jKw68hmEwcTKesFBSGTP1ja9GADaObpt0Kzo1iaSunyVv5oxYxteTb56XUofgLs1hstO6CTZJmh5vswx2RovOlWmSuU23BErBL4NyVJPwVK+ccsMlQpR54ZnHPcqosM3A+He+MyHVwRa6a
 2VudQgux
 dCVdi8zEQtgs2W7jYdU66Od50s4tV40P6L53+6+nBirmqYBfMP93KRpgtyktTH/z7+p76W4NfyfYmwiIr3SMw6lgiYhp6o5V77//3yINais9DvwOxBc61lpu3KOODN3uASugKhG6KZwMSpxY5eTJ4DnVJZgsa+RUQEQxi1Wx7SxwtUsU01ptB9nu/JJ/lIVMfA3VEYcT5HoU3hvNEv92nm4mY+tHIXxBKcgsQgxhMcjEFFMFhsZww/T6pwNlEJqGe2SVb2PUGsV0gCobxnFPEfjcqSqIgL2VBHLW5BILyNqBPx1YNLWEjxlrBeV4E/qhrWDYQ7Z/YAGL+89AqXs6b1nZZ7n0ZnHh45MEi1XjE7+YODwC8RKxVoC1zCFUDFdYj2waSU8cHptPwUFz7xCPwEGxAasK2N9HqeG86LTa9hEuEj5UvKIX+1Q+pD+gLJxjxyWg6ZO9UjehyMVkhyOXODlvqsi6O1RjxU3HgRLBrHGtWc8riPd0havZ3RN52DREI02eB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 07:40:17PM +0100, Harry Yoo wrote:
> > 
> > Use kfree_nolock() when the allocation flags disallow spinning.  This
> > keeps the SLUB object rollback on the no-lock free path.  The failed
> > allocation continues to return NULL.
> 
> When this happens, the object is not charged by memcg.
> 
> The kernel should not invoke memcg_slab_free_hook() (called by
> kfree_nolock()) for a slab object that is not charged by memcg.
> 

Agreed. I'll avoid the memcg free hook on charge abort.

One question: kfree_nolock() currently skips init_on_free, while the
existing charge-abort path honors it. Was that intentional? I couldn't
find it discussed in the introduction threads.

If kfree_nolock() should honor init_on_free, I'll include that fix as
the first patch in the revised series. The charge-abort fix will then
reuse the shared initialization helper.

Karl

