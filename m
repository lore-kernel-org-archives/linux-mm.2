Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E991ACCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9B08E0014; Tue, 11 Nov 2025 15:21:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391648E0002; Tue, 11 Nov 2025 15:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F518E0014; Tue, 11 Nov 2025 15:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13FB48E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:21:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93D8CB6A9F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:21:13 +0000 (UTC)
X-FDA: 84099445626.04.58FCEF8
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C357C000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:21:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DJ+SB4TO;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762892471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bM/Z0egb7ac8A1IhbTkYcl7dpLdkBduvWKO9rOoaso=;
	b=sVDe+3pC9bjz2ryZh79kqLr2eAeDQIy+gEQWbr/oS40GtoYmxz0Fb/gZ6CsxFTQc800MXF
	f1Mh+1zlCsd3QAXlYs5d3R/LfHfUZslbFJ72/rCPelCAk+TgkAQx1brqZdf6ohacQmWvsP
	MmYRL+cAVfmQ+aj0rNndFxKTD+TOQK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762892471; a=rsa-sha256;
	cv=none;
	b=PCPqp/PFUC4Jv4ku9IZNj+GO4kL7DwVdHMFa0JqBGiVK5gtFUP9uBcboIbKNNXpsOsnh+e
	n40XuwxA23IEEq+0AOC8+Y+58SJCmXFEouN0W/u/y4DfRRtdieb3XOIYpLDpd2J7XzWsgd
	FIMDndN4oD9i7azfoX+/ZsCZHoWSMtk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DJ+SB4TO;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5957753e0efso76190e87.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762892470; x=1763497270; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7bM/Z0egb7ac8A1IhbTkYcl7dpLdkBduvWKO9rOoaso=;
        b=DJ+SB4TOFc9Z53BYSeytdr/YplAQdLau8BZiAidAd/YYUIPKM6Y3Rl+3u+hn3yo2LF
         BaM5ZXh2bZ1boMLMoYQW0KQjBWSruwizFq8Qj7MLfmNy9qE1JXQ7W/RkQtId//qYr7/K
         ANcQ17zzJpBQ70K2wubqAXgxJlbkqNbDMkwiOyxBK5ThKu/3StQbRVLF4ZxRIUubsMTu
         N2HU6Pkh3O/8la365+avfykOYL+ileZ+XmIOWodZvvbYn1usL96F7a1FKOvBvq6azLeJ
         /s2czFYAi0eJo8B/DfbVqWRK/XXDRTzwXYDttg9Oc4pZfvBfEXICcz9PQwWbc4wK2deO
         A3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762892470; x=1763497270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bM/Z0egb7ac8A1IhbTkYcl7dpLdkBduvWKO9rOoaso=;
        b=N/qxW1QvB4EEdfE3QDeTXW8OfGqIYSuCO0ARM2ZCqjtUELZVTZs//kG7bMSMBXxiMH
         mpdz6Ju2NN3SpPqeqAoABCClD/bWmY/v2sSXVKr/XZ2kcgLSs9Z7WfFMJFLOyzT4mI6d
         w2npPbvkDsimAtNhl8nlqkistlWYs6an20wUyIiL8DIsxgC9ssnYqEDSeli6ob/xX/he
         Q0qsD3oMEMKdQfkWqzCnn/GZoHhB0YkO76rFqIIxCehrkw51VYAMrN39G4dN5ar27Eyz
         yBgHp2D/axjac1fdHNWXzCE996H8lkDe3TwaJUaeT8W+sjcaSViN07UXczt7PK3gTRR0
         Gd/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUoMs9YOuAH9U0cOG5n+9+wYAmfVgJEN3fkrY9DZiM9v2Al8eVn2IyYoYz7sDapZtanHZul648b0Q==@kvack.org
X-Gm-Message-State: AOJu0Yw4OynlXQgpL2TS1m+n18JdGv+GkqPSXOADdRR2V0UiTE/oMabT
	BBFmkqmm+ABBSWeN8vaNDyjB1DPZzTrkh3G411ecpiLWsBKn9YjFNDmx
X-Gm-Gg: ASbGncuC/cuZVyUYwEywuHKgTkGxgcpi+Dg3tFmcGBE1CjP3tDQj0EMTmfCrtV/tBJd
	R5HmR6QFb6lgTNp1kxx4m+6tRu+nEdATHcyw/Zm1bHqkmTNh/bwwQOhTP1VudOM5faHwcTzeumr
	uO8nyTn3ggBNkdhfsY4f+HKQbZM/k8Y4TEBQN3KAKxVABn20GUaCFYjctKqp0KrHllIS72qsbHE
	tf7r9tQidr8CQf5r9YzQZhOH1U44GtMU3+iHg9ehWchxqF0C3Hr43ZNSHNhy6GlMLBdYDmdwXqW
	fepmQJiBwzbwNXlbQXLMeUfSG1fpeAzINQ1PiAKgcrGLUVmSkfg8peAqHvPnHC4biPT9M7XReYu
	Z+6NpbhqvUDBuy536G1T9lMWOvn9h2qqXbWP6vrDyiAA=
X-Google-Smtp-Source: AGHT+IFOzNyOb24VBUupwqxWTVYpD+MA84ViEpm3t8gfgJpb6EOwHuFRtQ8tg4P+Y1UGmZYJD9xpaw==
X-Received: by 2002:a05:6512:3e0a:b0:594:2fe7:11e4 with SMTP id 2adb3069b0e04-59576e1bd76mr156463e87.28.1762892469267;
        Tue, 11 Nov 2025 12:21:09 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5944a39eb32sm5298492e87.82.2025.11.11.12.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 12:21:08 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 11 Nov 2025 21:21:06 +0100
To: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, urezki@gmail.com,
	vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aROasppMPmek9Afh@milan>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69123b72.a70a0220.22f260.0105.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C357C000F
X-Stat-Signature: mqh6bu733axofgcaypuno5r9t8rjcg1e
X-HE-Tag: 1762892471-281045
X-HE-Meta: U2FsdGVkX18JUJUj+2PmOdSlj0URnNMa2hpcZ1zuIYP5efh2FF3VBOpQtJ8PmoxXydMz2fs7ry6zwPxVhArjOiQcpJIlZ45QJx23ieAvzriBOCcbVhU3E+BxtaswmqoJXURgolAmMngr62Ew898K7ZK65UcpZxLW9e4iWeqJrDM3uHz0p2SmC6FHSc+IIhwg6zYxNCaaqX4npWH9b8J5spFHetZTLmvf8H/giWhxWoFS8++0lKGr/oXigLVh/2dO5Dn3nKfbkzZ/0Tf4muaConHKWPsZlkegx9ZAuwOA+T/EPrggzN98hq/IpWGlb5Vxx8gJAdx9Uu5uqblR/Ltp7YdcxZiKTlTJvh61P+k+gJE+5EDSuflQy4d4oG5qDyR8FboabMdlYmJDohhz9fcYknuG+QKUXA6lAkTwICffyReo+T314CcC7tLDo0p4CqnrhZ5E5LE6lIQJS/wRHy2jg4NmANW68h4Upbhvt1i2k5+Z+cQhO7MgaUepDhAacWp1MYJzvIaGBlukzlvTdfN8+fEXujyFAzgJPsXGvMk6heNa2tjsKjjynjdDUj6Vo3fcPTUyUy2N5pO51k5oDnXbvV7AThRMOxai0KcUjR2DwxNhuuS/X2ceXz7/gh5ftrXqB5GpczZFT0ocx2GOzUpvUcluPTYNzVNh+3V/+whmfRnT5ZQW1rNfHqJSuETvVUAN+sXB5zgylXblHFLNGXaF7Pw3iQQ1KturDhqFkQK6a93RJ7JyIuE4QG7HAXtn5GgISy2zWKCi3VAW6D4P8ruNsT8gYpzCvn8nyD3Rv/qq0BS6z0j87aDr8fJP4/Iq+q65WjUG57LQX983MpGQif5uJErna4p2ao1su/mnSkDd1vutNP6CynCr6fMi5oF+ZZAJqLkNZSe+y9CFeX9FnhsO6vhvLKuic8YEhVW8bWXcMRdVsbuSGOI5X5/Uysuz4WBC4g8rmY1EMHy+IDHE8W1
 Y/8Y4/t7
 EDb0Vq2V5dIvd3NktbkufDLFOhBpjUbMg37+cC93igA5YHmSWhziLkzyP+PY3uf4IAG7J5b6gXLYQsg17XVpGmJqMudeLn+HQNGFWMUqBcjV2zi98hr9LjFI+P5WgLlAlXJ2Ec4Ix43tq3CXv6xpqCt84VyDj226898I08oXmIMlU9yDY3k+/Kt+2NRCm9zZRTGiiPOAyZbLRCKiG+UCKtoj9cQBsku/zv8LmaKhqNnlKtTgGJ20SNUoIZfUHoAv0QIOCr8JR2mWoCc1Zfb6YhDVihOjLtZfAAVhOOVB83Mmj4r2Y+LPRpW7T5qr8jfrOVYK14vV2FPZHcC2Dzk7lZlX5wBlLYx9WWnXPYcXQq0C+wnOQ+fvQ+hkeYOCqj466jLP2ysfMOksJjnAHHvjHAi+lZU3f0QquskeRE7U+ZPfrYIRYvlE4J4wut6ysZDdMZyxnWDiuAlbTk0lSY9Ee39qqbd/W/sbaU1jK1hV4BEVlYON7HT8ulf8WNNhiYAMY4n1q95uA0fgoDonc9jI/N3V0lrZKtXdQh531L+h0aFkgVXE/oD6j2Kwl0Uw+Br7Gt4TFMgTflBMa0WEsnv3vir4/Qa6SdXpdTM7bcN8G8j3w5OWsBA2X6kW47souxM1G550/MN6RcvIc6w5LbeuJxUNLUKqBe9M8CCLT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 11:22:26AM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] make vmalloc gfp flags usage more apparent
> https://lore.kernel.org/all/20251110160457.61791-1-vishal.moola@gmail.com
> * [PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> * [PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> * [PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> * [PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> 
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> Full report is available here:
> https://ci.syzbot.org/series/488ab7c0-de91-4749-bbb2-ca76c3fb798b
> 
> ***
> 
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2334ae39-552d-4ca2-8562-7adc18ce2cb0/config
> 
> can: broadcast manager protocol
> can: netlink gateway - max_hops=1
> can: SAE J1939
> can: isotp protocol (max_pdu_size 8300)
> Bluetooth: RFCOMM TTY layer initialized
> Bluetooth: RFCOMM socket layer initialized
> Bluetooth: RFCOMM ver 1.11
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bluetooth: BNEP socket layer initialized
> Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Bluetooth: HIDP socket layer initialized
> NET: Registered PF_RXRPC protocol family
> Key type rxrpc registered
> Key type rxrpc_s registered
> NET: Registered PF_KCM protocol family
> lec:lane_module_init: lec.c: initialized
> mpoa:atm_mpoa_init: mpc.c: initialized
> l2tp_core: L2TP core driver, V2.0
> l2tp_ppp: PPPoL2TP kernel driver, V2.0
> l2tp_ip: L2TP IP encapsulation support (L2TPv3)
> l2tp_netlink: L2TP netlink interface
> l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
> NET: Registered PF_PHONET protocol family
> 8021q: 802.1Q VLAN Support v1.8
> sctp: Hash tables configured (bind 32/56)
> NET: Registered PF_RDS protocol family
> Registered RDS/infiniband transport
> Registered RDS/tcp transport
> tipc: Activated (version 2.0.0)
> NET: Registered PF_TIPC protocol family
> tipc: Started in single node mode
> smc: adding smcd device lo without pnetid
> NET: Registered PF_SMC protocol family
> 9pnet: Installing 9P2000 support
> NET: Registered PF_CAIF protocol family
> NET: Registered PF_IEEE802154 protocol family
> Key type dns_resolver registered
> Key type ceph registered
> libceph: loaded (mon/osd proto 15/24)
> batman_adv: B.A.T.M.A.N. advanced 2025.4 (compatibility version 15) loaded
> openvswitch: Open vSwitch switching datapath
> NET: Registered PF_VSOCK protocol family
> mpls_gso: MPLS GSO support
> IPI shorthand broadcast: enabled
> sched_clock: Marking stable (21550045890, 115271513)->(21677757748, -12440345)
> registered taskstats version 1
> ------------[ cut here ]------------
> Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
>
It looks like we need to add __GFP_HARDWALL to the white-list-mask.

--
Uladzislau Rezki

