Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AEFC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC20F6B0092; Thu, 17 Sep 2026 03:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99896B0093; Thu, 17 Sep 2026 03:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6726B0098; Thu, 17 Sep 2026 03:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C2C6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:49:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07457A3B0D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:49:58 +0000 (UTC)
X-FDA: 85222480476.07.4289036
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76508A0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:49:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mPrnrGDl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789631396;
	b=FRyhGbjLGu16+hvOyYxSpZHsJYR+JU4ARcBMXY7Ws7ncOsXEGEhRGg/3d4GJnXmYRqfVWk
	zMEwFFMgfc3Fcmd0EN7RPfUl69SdweR7UAztT/RbNCltkHFp0chlc9aNfZGPF6NEKpwFqE
	hAx7ouibFKGn/7/439GLK2/a5Wg3rik=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mPrnrGDl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789631396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCqSR8xT+K91LfjRnuBwTlwBBPOS+Tdfm5v39XYfcwA=;
	b=uGP//riXXJtC+dmBd5N8o/wem0uFrFz7dvpnQudfI+nVpKe/B6w5U2zpPCAhJ/FRM24KPK
	QX5pZKwE/6ROZyyNqMIGQERoiQRwATu10jq1bJoFQT6PavzY20gKzKdVGF9u5yUUm/bo4O
	4ZAbh7rbXYSVxQYJru1vR5qZa6RY8bc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7EE660210;
	Thu, 17 Sep 2026 07:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26FA1F000FF;
	Thu, 17 Sep 2026 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789631395;
	bh=GCqSR8xT+K91LfjRnuBwTlwBBPOS+Tdfm5v39XYfcwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mPrnrGDl1B0O0DCjj5NSbukmuO+NaJ/CVMhVOTh8pz/dER+cyNq+5QbbPOYN5OoTs
	 CuHsuK9JrztoMrYyANJfzVPU6BdOM3vB1DYAvVe0RE2P3aP6MDSt7zHqQTj4h7+Vpo
	 ME/8jK0SEHE79sp2vlmJqtgVSstMCn/iT86UOBp9UKHfMnJW2oFRGnQtXz3dhcxNDf
	 5HXmthe8259/mMkoJZFj2gaHLA0T+/0LnyqaXOLkr/nFBpenGCE2/DduX+HQBuJYms
	 wtCASsQnZlyL/mth6PwCKBLbkxQM2O6yyHz0u2WEizQ4fEZ42FYu2ZHmZlhvziGKc3
	 0I9yPBG3NeBlw==
Date: Thu, 17 Sep 2026 08:49:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, dwmw2@infradead.org, dwmw@amazon.co.uk, kvm@vger.kernel.org, 
	liam.howlett@oracle.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, lkp@intel.com, 
	llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, me@brighamcampbell.com, 
	mhocko@suse.com, nogikh@google.com, oe-kbuild-all@lists.linux.dev, 
	pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, seanjc@google.com, 
	shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, skhan@linuxfoundation.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
Message-ID: <aqubYaxM1zQMdGN1@gremlin>
References: <6936812a.a70a0220.38f243.0090.GAE@google.com>
 <6aaaa2da.86093f18.33004f.0001.GAE@google.com>
 <aqrZMReaQPG0M9oV@gremlin>
 <20260917073931.iggMficE@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917073931.iggMficE@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76508A0007
X-Stat-Signature: r5cdii88i4yurr8fh9rmnk89yhbqmexp
X-HE-Tag: 1789631396-646355
X-HE-Meta: U2FsdGVkX1+uaz9wcUtfKNcvCj01ks/VN0pVGBzTUoP3TawZhHfgj67zYnQJO5xOZE2nmrhQEtahQ6dvlx3u4MadQs9Kaih2ZlWMEsfIuwyhkT/gDYTwdYuJoFV1zXNbz9yeJ+JLnYPlFK2MC9tTnZSN2IqMChvHdhBRSB7/mXVAnhZll6+bGhItXGh7WiywAVcZaoAzPB5Hf75zB0tqyEak5Mpw2DWoAr2BFty0AQ0ipvbeZYL4/k1erDg3zN6THriJNDjyE2cyQIg/yh927F3Z6Nqnpg/50xiVZXGzIl/v3SXURg/LLTwHFhoZPcqzPXUCooEA01sIsOyc2+bF4iQJXHiMvZ3zQ9mUSpDOYsSVvx/L65ttzMihbbE9+0WNPErM3ZEjEFG0SHdgNv3SHgO0wT355Q0GRNVe8R6pAdlRDSTG+j2f/sptHVM5lZGs0YgaAhRG7FkLU67DCb77vmnWru+wgU9kKsf6X/bUq3qlxTB4dz5vg6vHnf1XikrZBuZBXPvi+uQ4d4+3qdgC640GH5Vw+b5zaymrlWBNOO/izasQFszkMY1+S7GZvdqEibDIJUi4TvzdnZYd7m9ipYrJdOUQfTYqm6msVlhDSiIpv+LjVboIzBKMkzPMHKGemB9zCSc6r2WU/FgMoD3mqurTmjB/Nfzk2FoEP2FH8/UDRurEKTdVlby0epNtIKBm73aCo0wnqNSFyKXtFhygEEGei1q423h8Ct8Mk+wUoFT1sZjznbQIqwAh9MOW9H3GX56YZQYoCNDlX6Z0PzK8MXfE+34bmbCEj7wU82XN7ceuT7XnnPM+vyb99dLOII8C5dMXlloknIZXIq+tbjS3ZHmljbuS6RDtQCQ9DSCitl6rIQw7l5LDi7XOTOCEg/uqg5dzVVGlUj5P+VAoTSqXbmjLLNvJA8uVTt8YDrS7muP+IHeDohekxVjy26/HhLmFHF+92hK366ebGBsJlYP
 0fIPRgbu
 d68UNKQTrPsFlhSGQdlt1f/a9lTpEBMc8wD5bsOP6slKr+gLExJAkieP4+2okRwoig5urEi/MGst8EqCpMApp81MQTNgo/lPQiz8EKUU+4Ty6lXeESLVThpoIOTXuesamlVf9+OGCt9C4X6eRMDMGEiYwkrnWZcFD6j1p0SO5aBptZCKxF94Y/vzr0bQ8Oz7NcQR9NIlp8yefi1bf+Caw7OLZLr3Jih1ZFc/poSiW+sXxDD26PUMutqGE5ltZnlY1hOY2m108zpn6xaTj+23DbV2vTvF79Qf4J+RxNS1GUMzZT/mdjc+sDUF7TZ0D099b1QItnL5VR9+NANbIuvmRLQ/T15+WagVgPnYoWVtblDbbNXAki6jV2AE3wkXFrZBptFFzrN+858S/KZ092BIMvNrE4Q77WfI7dVyOnnAT/7U7fauvjBpHBP+QRFKHRFBWF4QEliAMKNt4M+3boDP8tMwdmntdILpdnqDjtERqToUJxNgIYmghUaFTEGbG4hsnc0cdgBSSuVz8dS9tgC/60xCM1ZlbhLz4Q1LyzAPUr9J6P+dnegOcsQnGUpszC3faakTBr3A1/le46ksviUhJhqHfulPiqWr54KPfp+W38zyVO3RxzyimIkOMfIQJ5T6hl5eu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 09:39:31AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-09-16 19:05:03 [+0100], Lorenzo Stoakes (ARM) wrote:
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
>
> > Seems like a false positive and an RT thing?
>
> yes, it does. The proposed patch has a matching reported-by of the
> report. dwmw2 did test it via his tree
> 	https://lore.kernel.org/all/6a8d9a7e.a5a502ce.31d34.0069.GAE@google.com/

Thanks! I may try that here then as my attempt at a test failed, but I think
v. v. likely this is what it is.

>
> Sebastian

--
Cheers, Lorenzo

