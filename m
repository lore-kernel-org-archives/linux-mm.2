Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C675DC61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8940F6B0088; Tue, 25 Aug 2026 21:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845886B008A; Tue, 25 Aug 2026 21:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733536B008C; Tue, 25 Aug 2026 21:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 505E86B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:25:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8E29160230
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:25:07 +0000 (UTC)
X-FDA: 85141677054.21.F38393C
Received: from buffalo.birch.relay.mailchannels.net (buffalo.birch.relay.mailchannels.net [23.83.209.24])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B981C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:25:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b="j6is/86G";
	spf=softfail (imf10.hostedemail.com: 23.83.209.24 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787707505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mvVAM5/C4VKX+uyn+Ue+KiWk4xHiIhC8s/6hAlyMMs=;
	b=vr1K5EIgSHlMUL9sMWefXCPeX+Yh32Tb5UiWGECKXs883yQjGIrXiC9AKkUBaI1+gr7/US
	mHovlMEPBYn39YaFTdkkBxoxRqTGQu/PcEY8w12w2D3w0Q0gINk3FougM+dwvSxFXl0zVH
	6DspfUsmtYpK+wVtwl78VxE424MHplI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787707505;
	b=hQhf1gr60Qet+ARd2jMKudj4ULITkjPe1V0x8pWR3ulS0VdCz3oCENvhNpO8HWlHxLrxgc
	+2ZLL88w250HZ3+y7ulT6+eDOzdRHF/4IC0ni7a1rNGIYMaX6R7h+3900ojAxKJbvH8tMH
	kAthI6JWpdpXk1g+keIlQT/TIYh7HJs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b="j6is/86G";
	spf=softfail (imf10.hostedemail.com: 23.83.209.24 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id CF1D84E1377;
	Wed, 26 Aug 2026 01:25:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a204.dreamhost.com (trex-green-7.trex.outbound.svc.cluster.local [100.96.17.28])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2F6304E1551;
	Wed, 26 Aug 2026 01:25:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Shoe-Trade: 329137dc4d059e0c_1787707503612_153827419
X-MC-Loop-Signature: 1787707503612:1092170596
X-MC-Ingress-Time: 1787707503612
Received: from pdx1-sub0-mail-a204.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.17.28 (trex/8.0.2);
	Wed, 26 Aug 2026 01:25:03 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a204.dreamhost.com (Postfix) with ESMTPSA id 4hV6QN4m4Qz1V;
	Tue, 25 Aug 2026 18:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1787707503;
	bh=8mvVAM5/C4VKX+uyn+Ue+KiWk4xHiIhC8s/6hAlyMMs=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=j6is/86GlPmrZ409Z13BQVNYvcmsOqVE5NPB3rajquDkLuKgFEq0vQWaBy2ze21v2
	 guCgQsPzj672ix7aiK7PSuDhiCMVjcjSMi5txQiqHwQLAfOf8Q+hShk7ufHCvwCnu6
	 /OOITLkG4BMZPC1jlQGIAZRiaTZPHCF39n3GLKv+l55qryyNpe2zkTeOVzWiW9IfKV
	 U4T5po5xCW5Xej0JU0qJ7HjxmAtVCs9RuJ5fB+qIkZXb2R7sB5qT4/LKDKeIHj1LOQ
	 jU8YPXWFwRY8qmN6V26lMSe1iKhNLDNkTu+x6NyKkDURg3qwofhyDd7XtCE6LBvdVX
	 DHlAkm+mFg8/w==
Date: Tue, 25 Aug 2026 18:24:57 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
	bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org,
	thuth@redhat.com, ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com, zong.li@sifive.com,
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com,
	seanwascoding@gmail.com, andybnac@gmail.com,
	menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn, atishp@rivosinc.com,
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.com, qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v8 3/3] riscv: store percpu offset into thread_info
Message-ID: <20260826012457.ig3rfmji7vywf6kc@offworld>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-4-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260703122832.15984-4-cuiyunhui@bytedance.com>
User-Agent: NeoMutt/20220429
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B981C0004
X-Stat-Signature: 44xnfe5hgi5z8wepk5xjzehiezde4k1k
X-HE-Tag: 1787707505-970812
X-HE-Meta: U2FsdGVkX18VK4HpeFHegg7+ftmVqXGdavbYSm1rIa3jPTkw5y8hdXm5qXZwiJk6H9+xH5yBglkQllDLyhcpTeN7fclQif5KQJBFJ/dwUlDZ4gtCG20idom0AJNARxO3CeOdrN3imf65L11j2BuV7/5lQDcR+WoFbkAVDME+fvFf2Ao7VOma9kurQZ0nM/CIIriCVh90lcIbFOztwtiFcjRDw2SpyXK/2n8tVUIkre6st+IqasiczqwKY3nxAH2+sPA70n6fcx5GdSQIteNx5QVK8M7g8NfOyD2MWnpK5rOsj7SJG9ArjaSVSxqc2pq2jybuSqMJRBIGhzlTrmb776LJNXxU5XxoEy9u703tmXalwt1pE85+yLxiUz0ihR5lFLzwGmX+iVts4TZhgOc9ZrTZ9L/hJyCfyd1yJESNgES4M7iqb+v7mgm+dxBILuWnJZ3cB5N3vZQBY/ej4LODH1yOzCqAIjlU6RXtsgGhoHtcksxsLXLgHB8DMI/aTvK0jIKzJ18lqZse9gWLtXvlPJxk1RlvjNZAytGrQlQhzLGup7NTd3skvFdzlvtjzLffguAMpCBunAeT4os/LzikknqcEu7YNsaDLaonChF+3ObLL1ntKdgak05qjxOFtm+HunWQ8C3h5keYS6z8BRFGSKLDc8E419eUFnU9BVC+P5qMn9pXwVQwBdEDoYxG8Vi+YKRbgFrWb6izfj95lS9gFpGjDM+thlGvCacKwC6cWqA9ni+nMao34b9Ago3GeUGP5KVJ5l3o+GOIm2v6d91M7rJTrfVvMWqgR/5L7erIXcNvxhCEt045aM/98LiE/RE9UtZxppBTdNf1Cn8j0RPAg7gbnaWxy3xUuvlO3+P5TZbwWHv/40GeniNFRjgdHqeEobA6NCP+ENjOa7kQrDq0GgUAnWs8ii8GzW7N9UgcV84RdN8XtHBpsGKIWxnsqcWcmqGkVEML+Teo1VAw5Cp
 tpYLkjx9
 LCN+I0u1AOT6fItLZ49PLS3AcCfEHyk9yxS7GAVtKdKC3Ct7OG6rmgJW3FnFTp2Y1t8AU0YjNmDkg6xEw9NsmsQ98en5tSuHYIlYkyDOs1HKd9TRWDU+NWzZYrCVWzJl5pKvM4VZFWDMn6raLtrtMnTGMqWw1QvDzp4dRrJhTOawO5aYBynQHH1MAFW+5S2Z8/1US5EIlRbejNLvn/aTRZhXCa98mFHJ8/3KOeOeR3Y+Tgp8+/GuGyNaIMDUCAgNqNny5KrLbFtNTH4z2uKUZp5AmaQcBdD/QVMOFm7+QQpgvSC9FIERnqwgtAle5WOW5bwWZJlo05FNJNgkvuRlU+A2YmZ1lAznsbxhutlfG6D5LEGovgAiaWoMlGulS8GZW7gGpvxD8w0pih+I0lsntZBdHkLiCV242ToiGCTTzq4dztSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Jul 2026, Yunhui Cui wrote:

>RISC-V percpu addressing currently derives the base offset from the CPU
>number and __per_cpu_offset[]. Cache the current CPU percpu offset in
>thread_info so percpu accesses can load it directly.

fyi on a sifive p550 I am seeing this_cpu_inc() cost dropping by ~15-20%
an adhoc microbench measuring/grouping various calls.

Thanks,
Davidlohr

