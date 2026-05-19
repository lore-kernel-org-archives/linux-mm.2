Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527CFCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F456B008A; Tue, 19 May 2026 12:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16B56B008C; Tue, 19 May 2026 12:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954646B0092; Tue, 19 May 2026 12:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87DFC6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:20:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21EFDC258C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:20:45 +0000 (UTC)
X-FDA: 84784682850.24.D0DBB8B
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1EB2D8000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:20:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lv1/ZX6X";
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779207643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrVHE1tjtjYU45caQmD8ov5BHoK/24RLcmHV1na59qk=;
	b=5axI2qy1/6skvbNC0Pn+mhONhCgXU0go7FPCdIIddlv1+Rjyt63rabgpixUk2uFS9yoMXW
	vXZCFdBdQrVCa4muZLHsmgjO6ezXtneGz2Xg5JDOd7lQN1BwvKk3VCoPRU/0cXWPRrCZ/M
	l4tzmlp6EDEZL9ipwzc6PEpmFEpIY4I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lv1/ZX6X";
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779207643; a=rsa-sha256;
	cv=none;
	b=ZRsKvf3H/IXkGSntWtLzyZw0d7/Usm4Ns8Jtpw/w+E8ck9ZGdRKG8YMy0fQkkMouKdHpPM
	UF/aEkUCpD8Ih/2SHlJ+NbDLpuysPSJvA/qNtGCokk/uWSiM7Q1dBWOgkN2+/c+rJ7HwQC
	FaiVZWTHS8S35FrJop5SfVl5F5Noa2Y=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a8fbe18b1dso6433861e87.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779207641; x=1779812441; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YrVHE1tjtjYU45caQmD8ov5BHoK/24RLcmHV1na59qk=;
        b=lv1/ZX6X4vvaVBWuq6+7COVZt0IbTNTDJyp3J+uLZRzVrbhYvQQgguFcZW3zs4B6bO
         IpXAMo8xDZiMo3oJFySjVkdEFdx5MqAptaMGsdHFJAHEyEdvij1l8J1CIrTvd/WM4ZD+
         pJRjTBMGaNM7DQ8PHTvL4rnU8ebIYLAgYTGeiHeEgVYKutf1xoaqj6I9s4VeU06247+h
         WZx/6SL7mJp7Che3b6n2jkDZ36DmiFVYFSNh0vbSWCzweKKCwRaXkq8X5JKkCXaVs1I3
         0+Lc08YchVL/NN9GcTii/S5DjdEZkMOoFdWz1iZ6YmBhvT/EzTOXXOVv+Nw6WNGomhdB
         M2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779207641; x=1779812441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrVHE1tjtjYU45caQmD8ov5BHoK/24RLcmHV1na59qk=;
        b=BEO0cfK3mrQD19XaMzcvlN0aj018BzkpyAqdODN+/sf7sthnltJORtXPbmcXrqf/g6
         t1bGZMbaK2FHztNL0jmcQOcuK/zOoWWVAzWMURgCmAdWSTw5lm00Vh3/aUjwznxXj0Xn
         spXSY6/gUQ8rx+I1APOkcR2hYZZnt9RWZmWeNYKvCfwa9oIkJzcm6025qYrw2FWFkttU
         XQ8fkSF8cQZEX/QVGRRq/NsK3V8Jpltw01BviCFsgnh0WvESGqK7V/n/Onrpnxx6X4MG
         PKdqB4fXG7GbtLwJ+fARmPigRA8GWF0Twiv8hO4K6dwlLaB8npHWjZt1hnh2Q5BiNHdH
         9ymQ==
X-Forwarded-Encrypted: i=1; AFNElJ9y4EUc/yWxbqrtk5elEYZY1kUP279hdx+RO57QEKAso6FA98+DLe/X14BOsddAL3KwSqzG3PtZ5A==@kvack.org
X-Gm-Message-State: AOJu0YxkvWnPXjowMcYX3NbRYvtG2DuRWxucJkH0UyZbLqMpqf3jmst2
	scWHm3mQ55OyCSUVh6woR2gS9GvHvujc/96+b/+q7XkO4GrQ/hplIsX/
X-Gm-Gg: Acq92OGJ3mrkuIGmiYSByyjLUaLFwsckAY0MZgrq4rZZwePHgYp7zgBr0lXIpM0NA2R
	QsyUm6jAShYEhLgjphbZgaSl2dEaEcrvxXsW6N1PVQRZ5LJad5xu6Ge6BhNK8rjV9i68TUMBGOA
	kNyoRRh6FirCehYGRZzgQ6qmCVZlnsJEp0JEXn6gUgkSCyH4XJEb36A0ngsYD4oxIJ1pgVmMG26
	6Aqiwawil+UEW5PzBnt1ap/R2zZk+hjd6olsgBlgyvR/ymfAns+RWJltlk6e/9HUm9J5JnqZgIH
	/10jTsB8z/dbiVKPF4U7JUoPZ0ykNhMIHcTCXbtqpckTk0Lp1qxNwslxz1rjBImpEXJ72L5r/A0
	9bkKgkZL89lEYPb6hXM3QlDU7jZPwcdBXBCmzDqdCrmUFGbmU/H9l9Wnq8BOGi57p
X-Received: by 2002:a05:6512:3e0f:b0:5a8:891f:b3c8 with SMTP id 2adb3069b0e04-5aa0e7741c2mr5890522e87.39.1779207641205;
        Tue, 19 May 2026 09:20:41 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395882c7214sm22512551fa.14.2026.05.19.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 09:20:40 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 19 May 2026 18:20:39 +0200
To: Baoquan He <baoquan.he@linux.dev>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not trigger BUG() on BH disabled context
Message-ID: <agyN12SyEz_si8_l@milan>
References: <20260515153009.2296191-1-urezki@gmail.com>
 <agu_g0HODqOHXodu@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agu_g0HODqOHXodu@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EB2D8000B
X-Stat-Signature: 4xx6ue8za8qaxrzr7977dyuufdb5t85s
X-HE-Tag: 1779207642-638238
X-HE-Meta: U2FsdGVkX1/yIswEDyVA7bdp54QO9q1QrPLcygPymPzAZM3gfzw9asYC6kRYgwxcSD13h1PttAKByKGQlZ0186htixZohJ/1RHisYM7a7hLjhp4VcuLFTBw9xmuSaMGGyfBnuPcXBnGBlV2CfZOHNXsrAYqBT24LRWMZ4cpsRLeo6cz4fAB62CTyECz2A91/wq6rH2gndZB5mCYEXzQTpb5FdxAnIIvVbxI8LLdbs0Tx2Sy0hf3+c7jXuT8xYnwPqylrYDmvE2z/Uu2jW19Tv6GfxZ8giysEo/fQCfQICaA78bBBrqMSCkeNlQJQ3Qn60CwnVpJfE+Qh/G19x1BJWSbXrpP/cbZ9M9furcOgSLS2ks1MXdDw5TrmUVQ7lIEP/vSt49iV6b/oUpUJnoXBQKsQOIUaCYlkm4aH5xFh4+lTQev8aCHeBdvN7YfPdTrcjNx95gol2UboxCm2Mp3T737m5L42G0dPgzguAT/7v21u9n5zUgCdiO7UD1tGwomkeTbokViAlH84s5tJ8U8NYv1DNXzMiNJIQYCYLtXQh6tRTODNlwvsPEtqYi1148Esqjaxx3maEHgIgmn1m4giMyPagZ5h3hGAX+s4IUU1Q7C0LDkKN3YBRBsr+65QsKSoBlqFBu//g52wrJiU7MGDUNzIQjk/E/rPjNib8PwdssEYVwwO40hGCcWtgWjCD6yEQ3R9FcXIXt3BkA8r488xpELOzOCIADXGpp8yIhXdu92yWzQcNy87OR5bh6k4Y28Oej9F0bm5eNZ4TRzO+4bo/xz43zV9R38twZagunrRd9mVZwpN3PrJajxF6yImhaknZfaOQS4f8anDZkEwMJFzZDhRDwUKDwqS6kyyH/LPnmwtuuvCAZrhH2u9X4nS+43H0WfBIo8luYMChLO1/RVEtxqbtbFA5GFVGuMuuTRLHN43A6wlVjsjtjfHN42feTaBviXIxP83gd68W0d2/O+
 5YWv68L9
 7N1IN9Hkd5OZgGCia9jp/57F9rhPrk9cSD5FWYWp9aIOqUBF09ufIZu1yYtJ5PHIad1QAaA2+33+pJELM1/QcOKwSAtxOpC7pycWSBbduf45vtJ0PNoTgHdjt6LZcmnoGCTSAj6aCaeM/BM3fomimFIBkBfgTnjoG7BmJ2pBe+E/53UujnifXj7QIj6uqIr/6P9J+qys1UQC4zA3EBEAAd3pU0/K/ab5mW9lWII1YDv+0bquti71W2zOLxqWCwsiut4ZCv/PwFrdeNJie3uSv0OKP+QYzZXi+q8UQBTQrHeQp0WlTnsF5PaiydfempkfkQ0+qEby+x+cbZ5AJpZ9oei/t4IaVEh89GR3AElZEDKszWP0lcuMqXtB/aOOJnzMT2LZhiwQGJzosCOTuABiAqndYqSvvGH9j2qbGIL01tvwq/dutCmeS+J0rOW/BtY5MGZZgtpNqz1V1p7iQrkSgafNi9/d0SnwtAxuujoDX3jUuAaV1CU4/YOl/ImogRcV39WNacZRdURnRwM8VNJAWBaFKO7C4cHzzs4RcgdrvvEamv+5WNKdZhi1gvktTU6wV4ht/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 09:40:19AM +0800, Baoquan He wrote:
> On 05/15/26 at 05:30pm, Uladzislau Rezki (Sony) wrote:
> > __get_vm_area_node() currently triggers a BUG() if in_interrupt()
> > returns true. However, in_interrupt() also reports true when BH
> > are disabled.
> > 
> > The bridge code can call rhashtable_lookup_insert_fast() with
> > bottom halves disabled:
> > 
> > __vlan_add()
> >  -> br_fdb_add_local()
> >   spin_lock_bh(&br->hash_lock); <-- Disable BH
> >    -> fdb_add_local()
> >     -> fdb_create()
> >      -> rhashtable_lookup_insert_fast()
> >       -> kvmalloc()
> >        -> vmalloc()
> >         -> __get_vm_area_node()
> >          -> BUG_ON(in_interrupt())
> >   spin_unlock_bh(&br->hash_lock)
> > 
> > this triggers the BUG() despite the caller not being in NMI or
> > hard IRQ context.
> 
> Because the current vmalloc supports non-blocking allocation, so we
> need to skip disabled BH or in_serving_softirq() cases to avoid unwanted
> BUG(). This change looks great to me, not sure if I undersand it
> correctly.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
Thank you!

--
Uladzislau Rezki

