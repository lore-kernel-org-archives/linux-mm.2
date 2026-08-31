Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145F2C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20E36B008A; Mon, 31 Aug 2026 09:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1AC6B008C; Mon, 31 Aug 2026 09:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E76C6B0092; Mon, 31 Aug 2026 09:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72F9B6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:55:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF1F712012B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:55:55 +0000 (UTC)
X-FDA: 85161713070.01.1711772
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2470920006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:55:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JiLDbaD2;
	spf=pass (imf13.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184554;
	b=yp4wTTwnZNMXnpgD6FnwWS0Yjm5ILEGcdkpw68lY2QFmGxN6ir0GXIe/KARKwWObVQNBnA
	hN2aeyHDPp9s8LLO7waTouzQjl1V/l2w3KsvDgeZNLnNK0ReXhcslTYveUrz1c/liktIDr
	24Oars/2XjnuaXmCHHz0HQkmnenIo4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlQZGfunhhSOxluD44L3CBAxHK1ofhgstjgbuCZgd3o=;
	b=EjfZMTT0tM3X6uCJS9KTqOlH60qZG7UNvsIEjedZ2Rgw5VQjcYQDHPyg7cLlLEd+VaTkPA
	EDDUqwv6IxpT79M1X9C88Z0+yyUtvmrz3ZNo3AnF+eYpHT7YDhNsrqHu35eXzk1ddVZMHS
	5CLwrIjZjM/1Yf77BdbhVsk4nVorC3Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JiLDbaD2;
	spf=pass (imf13.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c9aea40d799so1967377a12.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788184553; x=1788789353; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jlQZGfunhhSOxluD44L3CBAxHK1ofhgstjgbuCZgd3o=;
        b=JiLDbaD2s0ihuXTjte5te1icZfUaZQZ2dtocG/071GBimiLRTz28aAi4HHTbv0+CQz
         SRiuYIgO69iEH/7anojKCvJgarNI7Mg49DpaHzAYgADNV+zs6YWlaBIgyvB0QbzqEdRw
         9d6j7c8A3Ny4KTys0eNTIWYJFm7IJspeXPxUSIdoWgXAOTSc7ovZzDGF1xt8/uzXfTKJ
         sR3IV862l0Dv/7MoQnxhXGWnZCwhFgl17Ic7Bx+V8QynmJGo8+wNxWjBN3tXQyHGY709
         vmGUQ4UDYW9DaVj/A1c0DlUIyyJydxUknXoetHwU1d28lerTrnQGibVBK5WX9Wxxts09
         aUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788184553; x=1788789353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jlQZGfunhhSOxluD44L3CBAxHK1ofhgstjgbuCZgd3o=;
        b=gS0kVAlJQ8IxqhKcYn9sCBCWBk7rjbUo/BWL47LfiZsDmmL5gXRM+dHC2X2yb51/vE
         ox6BzqZyvzvPvP0UFkLNWOidAj8XTJtFkDNnSgr2B14ReaTWuZhf78JGB4FosSYtQmpz
         zY42ynzfq/bJDv65SryFkC9Vm6eEg+zFQCI4iaMNtbp2h6mY2AWnxvR+57hr9EbcY+eJ
         AU7w0R+nfgr4qUlRkPQIafhEeMkjM+MqBMYz/racuOv40bLOuiWBLWRHgVNiD3g7nOfc
         LGsIRopVDSGwCVDzvIhpI2aZtmMYPgDtpJIk8dMe5UMa9CfRBjIesWerRCluwvkM862G
         nG/A==
X-Forwarded-Encrypted: i=1; AHgh+RrMLN757qnd7SYefVvVmwA24z0/sw192+F7yXxTfa+zZ51Ypz8Cl3QbtJocTGvez9ShqoDmAIvNVg==@kvack.org
X-Gm-Message-State: AFuF++kur++XYfyoXjxgBLQKm8DwH5kSQ9TrOitAXbMb73Fh/c2Lwa6W
	vQnjg/4oVtNzdqklkKgRLHbDCxXsRZFVrbQXc+Eafr/YRS2EHGjk0FwhP8MV8w==
X-Gm-Gg: AR+sD10EU3aTXpGUG7EvFrYiFgu8lM/g2Zw3d5DGwsAo4pTurBeOsCo30IgXalmyGF3
	FaMqmk45Qbsmsqk6scmJfDRUksJqANe4xraTGmezNHmjFAt4oaPF66GIsPbyToSljlqu7tFwqsl
	uJvOXy37noulvOzAJSTS2rIvu5PCyE+PkNvalSsx/u/UOdkjNAB5DdUFj2kAmMMxv626UHba+82
	PKxL3Mck7h8LlmvnlLvdyWuDuntshrb9Qx6I9ihgdiGSPhpnH3vfmw8jaMyIHHTuJnquORcV9Xe
	WrNRYRCg2BMjTsptZ3Zq7yaB0mimRN52ZYH8cAAjIQJSUUllrFfHI6fA/AMgF9S+kAKw2TvTHGb
	JU839QM74wKH0bBou8OyzXX95I2dKrrh5bM2KwHuR3dxLwvlC1HvgQ1jN6ctqLmxt0ijq9idaoU
	xBSpH/k+pZlcOhdwCAkT95AjNVtCYycbho8yN4PJsJyP9ibueVdxP5SMlP9BmkA+Zm6QdwliDnB
	sX8Ibs=
X-Received: by 2002:a05:6a20:3d82:b0:3cc:b26a:7686 with SMTP id adf61e73a8af0-3d26784f231mr40133026637.6.1788184552749;
        Mon, 31 Aug 2026 06:55:52 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:50b1:2f22:32bb:703])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f3312676sm4204321a12.12.2026.08.31.06.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:55:52 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-devel@lists.linux.dev,
	linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v3] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in kvfree_call_rcu()
Date: Mon, 31 Aug 2026 20:55:46 +0700
Message-ID: <20260831135546.9929-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831135150.1B4B31F00A3E@smtp.kernel.org>
References: <20260831135150.1B4B31F00A3E@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2470920006
X-Stat-Signature: in86p3concogr7p8dw4k9o4fm5oppbp7
X-HE-Tag: 1788184553-479451
X-HE-Meta: U2FsdGVkX189Kc6/SKEu7EvhhGhsxB7+X+5/BLVOazW8yUnLJtQttfH6PDVG529C6t3VY7Lg8rk+xI3z89fmJ1V7V5P+rZzrrBvINZ5aPR72wqhHGg3zpS//JbHH86UU+cKFMepF5CCSUXFzdWq5I1shyeY0z0UY5oQP+CcpPyWzHDJ4bLjTLmUkkypsZJRdBsqx3LxxA+rEmoQZ7F+y0iYEhG3s9n9xZ/n2BHLE67YrMGvP8064+Y1Pgs0XaoFP67sY22PKKRflzr+sYursIE942GesO7bh2oYnzFYOoCtHFFyyvKPVUbl6jByW/2hE4knQPH4ni1rUsAuIJDth8UG1/NJOVWXH9b1o0sRDyhKVFmzLdYKpMb3sy520xakWFTf+6v2l9zpyu1VwQbLQQfllhlTd0hk+1zSVsbFlp26QtMpnyDy5PTu9eWV1teuy2/LGH4CoGLtsY34SndzPX1c6DH2uiO7d3JDyDtROf7Il1NRnPMW5828J3olbDS2lCedSk00sfEUyZu5XQ1jxYg9rVCSr8Qw9Gx+4md42ms2TSM2uCKx+fgzFRdHVFPSP3zy0kIDD2le5eOy13dxc4VWbRg56U11a4eGNm5BkIICc52T4JSdKGVJ4wpMiQexZLZGfxT/AnfI0zeK94BnXFkpPFldfOkbP0fAV3hiZEttTPkeOP8QhhieQqlakxOEoExeT15TCcd5bzN47LI89isSXKtbBqABWXf/J0VVRvMoszO3MGvCYfVICvWRLVMM1eQkuTk4QpT9lDLjWXcU1SM/emZ9GdpcvTbqj5I82rD2BPHBAba0c/qK/3zsvgxuIFgcNnOnWleZsQZ/bY79OFbuCgflMc2knmnSIkfjlPpUs6o+NLt/RsoWECCvT840VkE9ACfSitk1pgheCnfEud4cO7seIw4UC0zYMOZbe5wURcYo21GYL3CSlEhz6GKlKIxapPPics2/ZizjRXNI
 y3J4NTnc
 5iYsHnx9B8qFWX9ZNfdo61WIwMspvL0gmw1K5D6tYCc4iGmzBxKEhCPrKabtvOf7M+G4s8jLYqeEXOd7g23Nqm4npqCj7vOUUs4U85mM/srbi2q2JNI/fg8ZwwUxG5rTwPY92j6FRRaHBJGs+vEpea3QYwvvMbGT2GbCfzuhD3SUQizkEtU9RUUgyHys6Ni8ARRYjin57Kd2kmeoozOy97m5dmrZ3CBnOiY8g+EyaeQiasZsr02ZtaUzfCOBQ4BdYLir8GfeFXjrpFNxL5GCd5TW3/DrE1QA2jzKb+b1RTBZyL3vEyLYb3Y9o7qmu/YXv4NoM21HA9G3gWjoKlI+1Tnq6o14TfVJ+G4DUkpVKgbqM3FRpA8tVEZlI+mf9qXuQu1Bsfto0Ad9FJ8NaUNvFeAVXNycWhMf2pRXLHBNOyJoBZIa7B1CTEKAkm4NPjRokGs2Wdserefe9bXrRTCrscI8Yxxt6hKKA6TtvyhoUjsr6xPzjbgZ2+T5FhXfGMIYaKI5GqM4VH/7/js8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, both are pre-existing and out of scope for this patch:

- The GFP_NOWAIT/wakeup_kswapd() concern in __kfree_rcu_sheaf() applies
  identically before and after this patch on !PREEMPT_RT; this patch
  only changes the PREEMPT_RT branch. It also predates the commit this
  patch fixes: alloc_empty_sheaf() has used GFP_NOWAIT in this call
  chain since the sheaves feature was introduced in ec66e0d59952
  ("slab: add sheaf support for batching kfree_rcu() operations"), not
  since 2a8bb29ec9b2. It's a real question about the sheaf/barn
  allocation design itself, not something a small, targeted fix for
  the syzbot-reported splat should also try to redesign.

- Same as noted for the previous review: kfree_call_rcu_nolock() is
  intentionally left untouched by this patch. Agreed it doesn't fully
  deliver on its 'any context' contract on PREEMPT_RT either, for the
  reasons given (local_trylock ordering, and now also alloc_empty_sheaf()
  reaching zone->lock). That's a separate fix.

Both would be good candidates for their own patches from whoever
knows the sheaf/barn allocation path best; happy to help test if one
gets posted. This patch stays scoped to the specific circular-locking
splat in kvfree_call_rcu() reported by syzbot.

Thanks,
ThangNN99

