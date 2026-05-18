Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95592CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065376B0005; Mon, 18 May 2026 19:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0156F6B0088; Mon, 18 May 2026 19:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DB56B008C; Mon, 18 May 2026 19:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0A946B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:10:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 749011C2167
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:10:16 +0000 (UTC)
X-FDA: 84782086032.21.8719793
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C50A82000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:10:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y7ln+Flb;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779145814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvPqhR1LaUO4lroRpey7abYHM0+zfpAZANAP1OnbnIg=;
	b=lERbPXQxvugV6Nadsejlw/XgbbhN9MWPQ6bpZN9pulj1QLHkFhUCWmi9r8yeUO/ZcAPQLh
	VuX9wGxHMARdAzmMYEBK8F72gk5vlMsubTM9pCGmApcIaN2aNKsH9lpsmjl+63RxV60vPk
	xx7bEWSiEhrP3dGMTsb24GD3tt4EjvA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y7ln+Flb;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779145814; a=rsa-sha256;
	cv=none;
	b=GhP+kmE6cMPyPaWPbGTbhawcdGB4bb1izauJb+R1tgKRhS1qLKDJQibIDCfTJaju/Z2k1H
	2ZKpWsDJTUp+JDtA0+aAF/r3bAgrIfpCAvTvVUOCu86NOgsJaVc3FGxTIsGYxu6dO8wDmt
	n14YyVrBIX8OABx5xNoro7dg68O8iss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1767C600CB;
	Mon, 18 May 2026 23:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F88C2BCB7;
	Mon, 18 May 2026 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145813;
	bh=kFs9cGA5D8Y5A8Mj8dKGofIM8Wn7Nb2XZEFQbOuFPtQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y7ln+FlbD4PcqCP5yEbB8+z9u5uBHbtgzePE+vl7CzyYQT84HWwiQ9gFE3LdDE6WW
	 kycw/NZCllnvk1C46CYmm/7XuZd4/1gGAZY+2PMKxUmLlIyJqXgGZsAFZqA5FQ/ybP
	 A4/bo86f6tQGFw3JxCxiqBCw9jBmvbMGP4A9+vLw=
Date: Mon, 18 May 2026 16:10:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>, Ido Schimmel <idosch@nvidia.com>,
 syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not trigger BUG() on BH disabled context
Message-Id: <20260518161012.6f92f9aca2a4db3776c536e1@linux-foundation.org>
In-Reply-To: <20260515153009.2296191-1-urezki@gmail.com>
References: <20260515153009.2296191-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mpqjx6upy7mw4jot8nuap94zb34dixta
X-Rspamd-Queue-Id: C50A82000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779145814-971211
X-HE-Meta: U2FsdGVkX1+w6gcLIEGN2mq7O3YKgg+D0wXUGWi9ebVOc1VxKZ/xn/cJWMNK2nxwYjjJt+KSb0waLHthFg4wLS/qd/CjIrRlAydhlG/9Uo5+ISh31O6CBEZFF8CkLjefoWF/bfF7GHeT5VP6Nn+Jv+zztFMP6VYLx5jteXcDMkx7o/XL+KoGReLST+JfqbeLXpYgKdR8MEMK2h7FSnRd6tjmdX4YL8ATfjMlgvwOn6jo0QhpNcnsCyboQbGdLXf2yoju8Fc+DmNxmzBiSJex4CtwoO4WMshi7AbnP6JuCZW61ef4QZMMj4RDvZ16RUkFAHCYwRxtNtGN4F93v7u05Uhg6iK3dpFLOxggO0pk+8nSFQFQ3vzcQ2mLR5drR4Y/CaoPqibRj7+M/QpeqYxqfWU3AVqH1dsYBf/J+QJrxEYvlmPEbhN3/L/b5IZgCcDTn9OWD111iDWpNewr0BF+eeYCHZ/5B5P599sphzBQZ/zhQNAk9vYCxoCMaTA8jcsgGFdKDHlyI77R+SQk/ykjIoFBTDbk9zjgaAkhpna/ru6ANHHxPHxR0kgTMDuzWvRTQHow1LO9lKhwAX9PJctao3159DG0jA4fy/YFr3dYXGgCa8wIf0OJiIszYbewV87RUR1Fcd9cYfAt0Yp9sdxc1qv2aAK002aUQLkNlQfjdm2/hpmq8USteag+hPT+8vOvNilNNrzSgb2b4SDfM97ss7jbzz61hFbIYW2r3HnT7/nnaAfj5TnTAuxTMIlc85pI2LwbMeMrM3WRM1v6nU5+Z/DV4FDEgzsivkKg1+8U+V+50rgKBmL8L14C0uBOlzZoW9jGn9RnmZRJZc/27fOoz8zdcucLwKCx59ZpxWh2kVi/BACt3RqCZfMSFpGXDoXEcp/Wjkq/+1ZUzS4Z96PZwhXg3PyWVPG1i7Rurst2sBaVbynn6gwUax/Lc6fSuQtD2BrmEXCDyQyY+aHmBg9
 Gya79PAl
 vBpvwyg1mq576GdWJUtDsClagYkC9vDbKDcTFpsQ1l9DqvmF3pR65m0fk2CY7WOGi8LpTMLPQStMiPGvYrEERcfpKDBNBjTi5HUfIDKdzS3OyyuNqj3sHU5J+L5nM+e1qRCNVZkrH9wx79YZqhsZq1KMTCGGtUY4NU+uq2pM6Po6zIPj5zS4gHP8oeY/6oxIK8OdvM/QBuNdRSr6RBSizyBewJAkQrhZ+wbvkti8TUq3tGafaa1XeqngQtc0Dbm+C/JbpsYjcg58Nwf3T+0v7q/4l4Q9lJW7nwe2iqQYAbZVGdgFFW4+F5N1vlOjYnjcW+9yF/qGUUCk+zGLNfYuIpBB3Oss2IpGzssmIzkBZNpHuFs0iJnOMECNagikuDQ4kDp/8dY+XYSyfK+DwC0uxCN3TfK1owLQBkecpUYPU36xAqC/jkRVrB98qyW8l70/oUiAo6sKUPu3cCOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 17:30:09 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> __get_vm_area_node() currently triggers a BUG() if in_interrupt()
> returns true. However, in_interrupt() also reports true when BH
> are disabled.
> 
> The bridge code can call rhashtable_lookup_insert_fast() with
> bottom halves disabled:
> 
> __vlan_add()
>  -> br_fdb_add_local()
>   spin_lock_bh(&br->hash_lock); <-- Disable BH
>    -> fdb_add_local()
>     -> fdb_create()
>      -> rhashtable_lookup_insert_fast()
>       -> kvmalloc()
>        -> vmalloc()
>         -> __get_vm_area_node()
>          -> BUG_ON(in_interrupt())
>   spin_unlock_bh(&br->hash_lock)
> 
> this triggers the BUG() despite the caller not being in NMI or
> hard IRQ context.
> 
> Replace the in_interrupt() check with in_nmi() || in_hardirq().
> 
> Cc: Ido Schimmel <idosch@nvidia.com>
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")

Was added in 6.19 so I assumed we want cc:stable on this.

> Reported-by: syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

