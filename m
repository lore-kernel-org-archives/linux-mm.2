Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2EDCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59028E0027; Wed, 17 Sep 2025 16:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E090E8E0012; Wed, 17 Sep 2025 16:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EC78E0027; Wed, 17 Sep 2025 16:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C58C28E0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:29:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6012ABA7C4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:29:17 +0000 (UTC)
X-FDA: 83899881954.30.202EB48
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id A99DA140004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:29:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wFEBCd+F;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758140955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1fulQ0gQjzyFPF7toelr6M7l0Oc8OAf+GJq3MYg+zc=;
	b=erJj/NV9U1jpsyqOLytf6t2D02t+zkY4IyArxZjyVOmKSBhp+Gl9wYubUuKedTGWVumhiT
	fOZ2bSeEOFR7co7ZZm+77R937KekZo8FunvjAj/9Ew5wsI+BCmQ2uwDUL4oQcppsGa2oRh
	bGWzSaAzkQ0Pw+FurcgwQAKqkw9ont4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758140955; a=rsa-sha256;
	cv=none;
	b=gXYypIIbMIhGYPZdCrDDJT9GGiU5mSIPdsFP4OSGTGGO8k5xGnH7gBMMlaE9o/KcIEn+Ru
	J+uR1ZXKyP0+iF+1Ws0CUU7P9GKh5cVNORTqunpLmwBCdofa2N0UPFT7GYnKevTPXmwcX2
	hkIIc5GJCA7mHUzq0ZVdwBu2wE6pKiE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wFEBCd+F;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=w1fulQ0gQjzyFPF7toelr6M7l0Oc8OAf+GJq3MYg+zc=; b=wFEBCd+FzEQc7BlKjb+v53jCY6
	JCiORP3QCMwGeNazAdH3o3scAQiI4/Z/E0SYboN2gfHysz+J44RBzGMy+qDQpmvcV8Ht+HL/bq3Rj
	R+D+36kVQPIjBho1YiVAg5qleJ6TyNmitB62iEOnQwU9WoLAnunQdSYXpVfvfFC8q9pAUFEOd0R6a
	+F/VSP16v1Tavpahim8UWx++scDN+ntaVdlBywL6U9lWWKY4g4vdj8gGGDSHe80YPcebaM/RFUTzi
	IIkw/O8wQr8ki3yF8y93qUfRAHW/nrRLfSN1CTRYoxiDvjwqP1GZzCcIW9CDoJ9G3itL2R/1htLop
	RN8WvW5A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyymA-00000007q9U-0IXT;
	Wed, 17 Sep 2025 20:29:14 +0000
Date: Wed, 17 Sep 2025 21:29:14 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917202914.GZ39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV>
 <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
X-Rspamd-Queue-Id: A99DA140004
X-Stat-Signature: bhq1ywpa1ycst64nhumfym3ibwbqqs9m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758140955-210340
X-HE-Meta: U2FsdGVkX1+rHO16V41EorJqxwYXqmDIACF87qVUIYdjtSg7Bb0+4Z7dDKb54K12+dYEA21FcZTuWG4AqoUQfP1YDlz75jlSo97Z3v8CxIyh8980j15//mvl7fHGw8ZnLcjxpPcJe4yjRLxIlREe+lBywG3BGRhu7wvu6Rvmx4itKqNgk4X/ssp0RHCUxwPROHZDxmN+YuR7FjYnV92ycsm5tpJ4qVtT9LQVZOVMjCZDfWjktzHyA0HFscFVOZxPwY9QkgB77freEKXZSc86xW7fmFZcrFtC/01hncxoQ2A2pb4bOU5qXPZ5odA9FPcNhJM+jpdmdf5u7MjXiCUV6K/NwSyqjNI4JIbWsoCuherGKKNaNTFRFXbDmczmjZYYEJJJthGLxoovsOPjLwr6SR9t3BqfGycpxj0Vf/PMJv5TMU0I3L+a7mk3+lycv8kSa6iotiCK1UNRQ0bS/q0oL+801YsU8tcpeb6AUAtK82e9Pmsxxf7QxEs+DpkfPZDWPyEXh9Hwbz5Mlfqd0XTG0L376WDYLcoFbnDU6M82OBXmxVe4FHQaG9zYGhMYkkntkIAtLQg4hu2OYttyiUqX3HDsLRmZWQpUOlrrtwSdKhqBb9+3KXn4fzUaz2z7xPn/ywaH2MGJ00hmfwTv1E/4kcLC6JN2+YsCTSNk/FS1mznyNzD7oV/+poXmMKwVoVHmXYTJGjs+JryIgWZOfgGSbuTgou5NQxTCIhNWEYO6i4E7mIkbIQCC9a0d999GRAoxHMbAKhj9JCdkYP7DxEw/+nU4GMxMiuWFMN5enh/QI0LWXZw06587kfycN7wjxuAMfaeMNs6fmiMcDzmoNLfFLmxYF9FA40bINcqp13OoXkaVRAghFNR3Pf/TAd7me04diYUI4rqyelALV2Mvb4kOrwmnmbp2rgPoQZkp8RPM85RmiMG+fsaSJNjz+PwovCJ5RXQKH1/CJesHt0w3+BP
 8AQvjJX7
 JtUu0LWyfJZ/PyOZvQl9HMFKiAHvcXoevpLXWtXfIzTdQTU1XBJxvqOMTf7dx46zVwP8CZWTOVOL8mXKGSkYtPxXBhPoFJ57iY3ZotIBj38E7D5+ZaXNNFCtY16mNgxGY30PodjlZ+1YYMnoU1KQtJO53Pts9GxDNalpsC244aoOBKVs2jDP8bx9CGLgAGMVmNQODJt8B8NLkk83GXl22i23aId4DFNoSR9B6rVH0TMBtvtGAVyHUY6s40Xcv9BF2IcNA7qe7xWjva/7Lsz8wbkfjVa9GPAc/DuK661y2X6CrK9E3qLHb3qNPeDzPRhC8PZKuqjg2UroqKjWweRboN80KK6BJAHmYywokXJ6ys1HanEU7L0slgVn1YujJLNpSipTjusOll2xbAGdG2iou0m6+c75/wD2mMZsEOy8urO8lgHkdV4hcosLq0/wsED1l10z4B3p3kFwSMge5jcv6tdtgPdL+/kildbOaWMo0ZQhaRFENBUIR/AkCFgix+zaD20wW3GBQwWRbP6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:19:27PM +0200, Max Kellermann wrote:
> On Wed, Sep 17, 2025 at 10:14 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Looks rather dangerous - what do you do on fs shutdown?
> 
> Sorry, I'm new to this, I don't know how fs shutdown works - stupid
> question: is my code any more dangerous than what's already happening
> with ceph_queue_inode_work()?

umount /wherever/the/fuck/it/is/mounted

calls umount(2), which removes the mount from the tree, then calls
deactivate_super(), dropping the active reference to superblock.
If it hadn't been mounted elsewhere, that's the last reference and
we this:
		shrinker_free(s->s_shrink);
		fs->kill_sb(s);

		kill_super_notify(s);

		/*
		 * Since list_lru_destroy() may sleep, we cannot call it from
		 * put_super(), where we hold the sb_lock. Therefore we destroy
		 * the lru lists right now.
		 */
		list_lru_destroy(&s->s_dentry_lru);
		list_lru_destroy(&s->s_inode_lru);

		put_filesystem(fs);
		put_super(s);
At some point ->kill_sb() will call generic_shutdown_super() (in case of ceph
that's done via kill_anon_super()), where we get to evict_inodes().  Any
busy inode at that point is a bad problem...

