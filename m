Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53744104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772576B0089; Wed, 11 Mar 2026 06:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5D36B008A; Wed, 11 Mar 2026 06:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDD16B008C; Wed, 11 Mar 2026 06:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3784A6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:47:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9F8ABA91F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:47:42 +0000 (UTC)
X-FDA: 84533456364.04.ECE00BB
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F2D314000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:47:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdah5RN2;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773226060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=us9WYwCiTBLLsk5cVeG22xmuXfkRkjPu0Kbcd1njBZs=;
	b=i7TWfwMWeR04c4h7IAAOCxJucFWLlxi0/Y0zr7paH6mf56y91ds3ZlwGmA3C81Liox2W7e
	+XVj5PPUyFBStsU+LqehE8BTmV0munq3e6n1FcWvBP5i+11h4+Mzy6VVL/9c7QrZ1q4Frb
	MUPUehkPBkCagQaA6F7UlUVJ7gz3ftI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773226060; a=rsa-sha256;
	cv=none;
	b=8f5IYxM8IsX2XJ41AvpekprCeew7qvQ57568SI6+PJ6A/X0eKe5IopUK08OBvt9u2pkdUJ
	CuR8i7OFCdQqNMHOKJq9ic/qOqAmb1wkaU7cbDsaUWsp3acCPqOAtXWMkF3eu0EJtuAvj0
	pUpcB4kaljUbRVN0zoOYKfFE9nlymdA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdah5RN2;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-485345e1013so6526425e9.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773226059; x=1773830859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=us9WYwCiTBLLsk5cVeG22xmuXfkRkjPu0Kbcd1njBZs=;
        b=hdah5RN2vTix7X+wu3tGHwQU/P5bfAlavpyPPs27jSL17pDnYjGzv7anr+Wz09XGgW
         MQdIeT8jqQecCeY2tPRyHFQgdaXF1gna6njF1BVaBEs0Z4nQ9QgzUufXO9eHZTr19AuE
         31lD/U3nf/G4qW5k9hr5ToMvOqRN881GxWvmmweQLPV6NkZLaCWLgAS6IrXzI3g2hKnQ
         AIaSwjDO+Kf7PkABsA+ZlRCwJZevNUjR6bo6Xfv6zbmKQlK4n9XvdVdTFb03sIt5nZFF
         QqOh3JgjsA/P84wMPp11dnJlR1zxWeugIAcso+FMqczWxRbJSBhNAt+s4JaXhjPE6kfI
         2XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773226059; x=1773830859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=us9WYwCiTBLLsk5cVeG22xmuXfkRkjPu0Kbcd1njBZs=;
        b=VQ1iTKwhcKmsZEPVUxiS0blSeAYv8EG1k1lDMdsKWpX1hZFA9OXuF/OSUkws0Z1c93
         0nLaFSAInrgknfSnmRvGxJfpyr3d99RS59DEHzLqlQX/61wb1fKHvzF7Ng38Q3+nmfIr
         hzMi4DJevHnOtYt6tofo4UX5sFMzMm1sP7RTTUCCHgSZRmh65Udd4ewn5BbWNJ92IHam
         +9TjmHSvtfu7mKN2h6pyYJ91fQN5QkzJU8YeUJQ5smOd+LHy3O8JY1yhbJux50E4XHOa
         izwZNuk9vjvo7597BTt4m0SJYOdrBGCJiFdVdPI0rvTzQkKXBxdgSNRkAg+dCa7tFNzy
         i39A==
X-Forwarded-Encrypted: i=1; AJvYcCUUeJqJfqpwv0uJfjYNzm7KqQ377ml5OIXomqgWaD5BVtvF/ZubUA7GhxF44l3xnpDVwBaIs7lVLg==@kvack.org
X-Gm-Message-State: AOJu0YyRZpoz73Obs0LWqbJhdHoI544kirE7oyVMbIg76TK4m3UKvVpD
	MJ3k6hhln4L6Ow8fUBXDS5oRNAXFiKPagQdlurKNOp6D9qI2/M75O1ag
X-Gm-Gg: ATEYQzw5YLi6Tu0hckeXHYw8hq1H1W6zblvL/5ZTfyWU2JH/fKc4kxAjEdR68wYgLEE
	+F+6wmSMzhXJJr1Yvxc1y7oB/mBK6q93J/lXD5yPImTGqjKmoxp9v1Ub/4fIgSCow7YL/gbwqsg
	y5C+SEqV28JdXEeizo0E7wziLWXfVjbKOTYEqvVHEVUZ3EKYvbeQTTRNcbj4SEy7qflz/HnJQgN
	QvBe3/eGsumj8JC4rNeHy2+UuxiVHwdvz46U5EXzFJZkSy0G2gwjmcMGQwfurHv01BYzrtSz2bC
	D/GsZwYhImJFE6YPxPnsE6ocFZM0+gPB3rncpqQJzYVzz7WxGYJBfbZrBP+VEo7S74C5QJc8TR3
	S59UXazqEZjppaDSkiirjlJ7WpLUq2sychdOqR7rSYcZxKnnK7DrMZhfkKPrHqIQIWnKP6zaVHI
	KOc57Abs10mCt+1dPH558qtzv3d3mzawCRg1IsLZ9LaJk0lzW2UjvmEmAdbfjbEskvBJWKVzXpD
	Xc=
X-Received: by 2002:a05:600c:5298:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-4854b291dc2mr30148705e9.15.1773226058755;
        Wed, 11 Mar 2026 03:47:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f820a2f1sm5725154f8f.30.2026.03.11.03.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 03:47:38 -0700 (PDT)
Date: Wed, 11 Mar 2026 10:47:36 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org,
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, Christian Loehle
 <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kthread: remove kthread_exit()
Message-ID: <20260311104736.51b53405@pumpkin>
In-Reply-To: <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
	<20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ewttn4w6zdcwgr9xp7ipekh4k3pfz7pb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F2D314000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773226060-828177
X-HE-Meta: U2FsdGVkX1/+yWJOFpoNT5ErJbDoUlrWKfj7SYrkn+nuWq9YkNBC9AFaeR2vQXzW6dS/h4GbTWFsFQdj6SL8t7tZtJwupqmX+JceJsdwN4KaPjpMOZ6uq+G/COUlDrxC96Rr05ht/glBQ3t4Unxn726K8LQKFWleNlEbtAFP3NjAeLrZui30ldp6DskDAPZg+oMOhPR0bn7v/8PVvux+Q49qX3qGYAdp07axx9LOFeSTHWILlJ/u/4AFWmC50oJUeoXP5vV1pI14y3+wGzCB73yi3sXPw9CRUvsjR+rhvdJfnL/3aJFK9MfR4StCKrCMY4FM6ZngiuaAe1JEwdvm5sdHxRmvee3K1ODi+EQblDjTFrFeUO8fnpmt8nbVWd2Wt95oMnU3Qp7qP/GhnxJUaVvobmZsCqwvx4eaRfIrhFv5rojl2NTSgCrZ+hRvkNZUTwFVcNuEfPbm5EfOGMIOuCaAgIgRKdwxdPSlWAS9LgRLyV11jcr4gjHj7LpCV7ocp3RwxAEcFY0rxXU8jLT9fsywqyHhp+fcjAOJvhPmS0S8lS8w2GkEicOHKYXNBuOFNWARowGzJwG2VGHDVPcSqJEHJ6wLvJKSZ0o55RP/6hpqiTtbXYl9s2mQAs2hLAMRkox0p2NrwpXjJQ0zu+lEbCHSxc/QaoE4bvmKHCXiysGgTD+6YoceD4FC5ZOpEF0beTLSqO9YmVHVzaVs9t6tRBOePKAQEu0nSg43PUMz1ee09/O5ki3+dngNzL4a3oIixFPZN4aP/VCjVv9o3f8d0iMmKlciPwz2vbm0K5EE86MjGvu2oWP1SAoU3NLc3y2m2WOrQyNrLE3dfPGPJOgzbOMp4YJw3Ow+bOJJfZzdazgTIeL3s7CtWxj+JICE44hfPMOXFRwXJvIwnedR58JYvUf3HAOzUVYqsJMngiIOmHdr6EmHOxlBTrx0W5wjGIkA798zYl3ClmtvFBLODbu
 Ox8mfXGu
 lfZkadtYmj+AksO4QHP9c9oeZXmjQhmcNd15N0FVE/2okpPqchcQgLfxhAXeSO69lijkRJCBVai6X9ZEFL0eqgzjOL3dF581SrGTYM1Xsbz/b6i4Fs2GTIYV4DusMIO+/47qtsPz7YWB+SZDyG1aWeLyv4y9Pyu2NpJTshXHE+FrTGBVRK+pOSG/CYeYx8jYAUI/XkQy9W9pqnZPB/Ng70g7RydjR8FXmTBgBaVIbFvknB4Pko4VmmBvztZwc6727vJ9Nzzf2BQh8RtR4VnAeEnJyK5D7CgzMQ7XxxpJLbQQ0MHfr9rqLP4BkkbT5VSyASEGiZx84AIcu1ys78DZFVw8FrpNeY35U7SCZFSDcebsW4xXowI5dITfuFWqL6C5A4m6x4hJzLKbGHfDxf8NZU4S85gVZV1WYzbBEwJJyEmZgZ2PnLtyeJCO5T5hs6fLaoChhwrcP6EYwnGDBrK2dNtu0ZTyoNaYeMA05DYCaKPlV7NFaDWzBlMihRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 15:56:09 +0100
Christian Brauner <brauner@kernel.org> wrote:

> In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent use-after-free")
> we folded kthread_exit() into do_exit() when we fixed a nasty UAF bug.
> We left kthread_exit() around as an alias to do_exit(). Remove it
> completely.
...
> -#define module_put_and_kthread_exit(code) kthread_exit(code)
> +#define module_put_and_kthread_exit(code) do_exit(code)

I'm intrigued...
How does that actually know to do the module_put()?
(I know it does one - otherwise my driver wouldn't unload.)

The corresponding try_module_get(THIS_MODULE) is done before the
kthread_run() (and has to be 'put' if that fails).
So there is an explicit 'get' but an implicit 'put'.

While a loadable module that creates a kthread usually needs to give
the kthread a reference to its module and then have that reference
released as the kthread exits, I can imagine cases where that isn't true.
(Or broken code that just hopes the module won't be unloaded just
as the kthread exits.)

It actually makes me think that module_put_and_exit() ought to have
a 'module' parameter.
Or, perhaps, kthread_create() should have the module parameter and
hold a reference to that module until it exits.

	David

