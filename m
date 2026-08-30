Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10014C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 01:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53A06B0088; Sat, 29 Aug 2026 21:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC6A6B008A; Sat, 29 Aug 2026 21:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7456B008C; Sat, 29 Aug 2026 21:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3526B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:56:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E623A1A0219
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:56:28 +0000 (UTC)
X-FDA: 85156271256.19.44C82D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E29620007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:56:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iby4Jm3r;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788054987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktLOUS2dthbwSMgKwyyKMwScfNeWqoT/1bLyJqBmlPc=;
	b=OVC4SS/TxB4fNnAYrSHe5lWgfBsMQUKrmKsQD3pmADch3mVAyu36VWcZv8DY2Ej6tjyjUM
	4CD/Y6CFfBHq4mX1UoLDwVWwT5b5meokPdpUjIY13NnC0axr+aOJ9QmeQMyFNuU6+37Ctv
	57pcrsJH7oJA8UlPFKzRyLqsMV9K+WY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iby4Jm3r;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788054987;
	b=GuEPhhknksto5YOtiTBuWdodifiuEjKb+kj1jM9jPzS11u3PC2z44Rn2HhXbV6ddgkBwLV
	DTMozdPjrjI5qjOCVAKF5EjWwuKJXdPfuXRIpMADrGkrQUv5YE1SAUAp9KMopcMH/f6z/0
	SPDjdppT9bqVVuE3LcPOfBjfR9FbPf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85294600C8;
	Sun, 30 Aug 2026 01:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C20D1F000E9;
	Sun, 30 Aug 2026 01:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788054986;
	bh=ktLOUS2dthbwSMgKwyyKMwScfNeWqoT/1bLyJqBmlPc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Iby4Jm3rsZ8tfSz3FvmKIHdQOgTxh6SIlBZ7J6BwALAyJrwJAuRuqcg7Yz2e05fke
	 fbkXbPsZDeq0rRI0NW3ngAbpSnaQlemg/NtRhK4nQEu3r+iRW2Q3fqPVMwPHmLt5nO
	 Kq++nDMnigZAdvVoMH0P9f/2f38+CSUZt8jlLAqk=
Date: Sat, 29 Aug 2026 18:56:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev,
 vbabka@kernel.org, jannh@google.com, aliceryhl@google.com,
 arve@android.com, cmllamas@google.com, christian@brauner.io,
 tkjos@android.com, dsahern@kernel.org, davem@davemloft.net,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
Message-Id: <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tjtiq7k3g1cwezs9kfcemptij4wpioei
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E29620007
X-Rspam-User: 
X-HE-Tag: 1788054987-142325
X-HE-Meta: U2FsdGVkX195MK/kPhCGZTlMV/g/87Pq0bFEiVzT1UigZ+Q5ymAxffAo8TBkQ8pYATrm8ezeh8X2U4OJvVaORd8ca+1Tc3AytfKb+a1b7R+HH/tV/5lXphMIp5nvYE1tGwt8sNsSHEH0eCGfRIC+KvjaQ7QDUhquI3AhEbV9yQHEcfkMjK9iyFTTuwl7j/7uEohkYP4L/AcN4qShb7NtTy+0QDyklpgbIfZM92rlZ+4QasE8d80T2cb6uqjfK4Z7bQHlIAKJBv/1+nb1RQ8nMrXjCr7jXZi4Wb26YXot4zCAMQHOWp/Ay2Wzoqa1nD6S/g57V6ZzABsxy4/1O68sYyJebAYm0C4rp3H/xmTfPqhafIfJiuWnHAsbg4Vp9pcGN4asHlArGX8JESFQq41Jxr+S5NYTAEfFCaDqZ/PhlRYvOdueLmWzs4FNnZYuI8LtTtRKtXTeNaq8og9JPRmfIVf1iJ2J62ll4fnaH8XtS5ET0403qJUzZOGLrVWfVp/3j3ebuwsJqZ5vQAPS9NboCOPZg+u4PFXV88wngqxUbV7wh51DiMmSaWh9kBXb7vlWlWdYL2AJif7ef6ryj0c9CcQEQUPI2h0Zqd7VpykoNhdc8xHaV1whwApu3RerI92Dxj7lxzR4LuCRgo8z2OXu4+U+mYQvxzmajzLraB7msPF109YT+5mNkrj2Pvw+yGd5ndPh3+p4SqJmP43pxH02l10w8bd2MvBPKvQAICIc7bvfxVnZLm1ul7ZLGq11q6OrXt207tY5ziZiYX3e8V8rhZ8HjpJ38J+VoVPpi1f07m+Xb48sliBxGJ67onnZlDFdic7o5YL1TWGeRiL8lzDn45w21BBp4N4eBaVMhffyzvgIhVr34HxNIbCtR6rnFUAlfZU14+gnEq5Yc/WoyNySQi0Vq7uHXaFAbqnbeT7uub6izekZ1gDxBrjo62hK/jvo4ePYMGxSeOvAKoeUHS8
 ID/+nxlL
 za3Ub7dko0NdX/1b30TeBY/sL0rTsCXTeM9zDqoTBwPDxXlN7uVEqRjVonaHntO7tieOAPG88myntKVrfAEnPW1jZG+Diq3ut2+M/qV9TjsUlcECeD/jIglHX+peQlb3FvXDiLVQJHyBk+3Vov8WX1COicCPpdPSbvuwff9glkUZtFuGAeGfovrQgqGfi16SYxNOGEwe5hO3c6PnkcOAOAyBjTfwQ/zn0wJC+/C8z7gxeVMmgZziTGfvzDMLPRo9mE6LC5qZ44Am4t7XfYGM9HEGcFqCtn6Lr+Qk5Sba27Om+B79n8Dk5iZnu+h2GR6xsZZF3sCVFPZc2Ai6t10gWemNCVhxdFXFFANL45JTnuEzJWs7XaCDbdytzHZjWCcjT2aOfsg00LnuFnnvZcwaSKPrtsaHKLwzMiI5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> v2 version of this patchset [1] was written by Dave Hansen and per his
> request, I'm taking over this series.
> 
> tl;dr: Make per-VMA locks available in all configs. Simplify some
> of the per-VMA lock users now that they can rely on them being
> always available.

It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.

But it applies well enough and is adequately reviewed so I put it in
there for testing, thanks.

AI review might have found a couple of pre-existing binder bugs:

	https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com

and a small rusty thing which you might wish to attend to.

> Binder and networking folks: Your code is the target of the cleanups.
> I'm cc'ing you now on v2 because there's emerging consensus on the mm
> side that the approach here is sane. I'm not quite sure how this pile
> would get merged, but ack/review tags would be appreciated if this
> looks good to you.

As said, a resend might help with this.

More binder/net acks would be helpful, please.

