Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7276FD3760
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0AA6B0005; Wed, 25 Feb 2026 09:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E516B0088; Wed, 25 Feb 2026 09:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80A06B0089; Wed, 25 Feb 2026 09:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 947596B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:59:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B0B78C15F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:59:16 +0000 (UTC)
X-FDA: 84483287112.07.1A3084D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2824540006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:59:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0zibxXI;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772031554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ez+9tBSaOyYy3NJcr81pEaOLOKf656QoxRx6G2fLGYA=;
	b=lntfIFvrWMZQESz5XwQHxr8RCHHVLEirJ3La1gRRM+dT8CRfaKQ8uhjeKy7s0NjNCrdBNM
	jc8r6XET3ZTPXeX8Ldc7r0b1aL6u/iMb2o/xT/BP8cR/1iTZ3vZhvpki6id0Y37Cq/xUET
	aeZP/I8W3OPPvyFOipqSSIg7jasx5R8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0zibxXI;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772031554; a=rsa-sha256;
	cv=none;
	b=IgyAu8kVX3gVTi4+NpDuSV4FvbIseAyo65sDWZVsJt6lSEkvBOVKYg7k226XIgyDk/epZi
	ttAZ0g8lDv3s+hNzE5jTmZPR0zL1ESaj7gd4xEmyCSpdTlRiYiJC2+kuYxKz8BBQux5qfG
	LHIEHiwHUUiVphuQRKb2Yz6qJrVqRY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26BC34458F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4A7C2BCB0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772031553;
	bh=3Txd1OyD3NLDVRwknS9tkgQm0Wseoy61mGvIdnnZ8lA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=j0zibxXIDvRI32Szy39t/LVN2gUqqHXwdvRH4afoVuNPGaiznP4mjnSpktY+1g2r0
	 Bu2V8UI6xgcIzvMVSa4Xe5fJbLmo74RXISYuKPaTmMYog1KCSt7mNYZrA6cKBwjGqU
	 p3ZE+ohuVK/7Cu38zwCh8HxzEXjyijII3BDmymSrOD6+Vp/mKuEzwFGPL8tythWN/0
	 EuN0GBi7uFjDmWm1O+BK3174wXUrnJuWQGkiPXzSBQYgUA1ovV5JepiXP9RDH8CN+n
	 z+QNVXNVQydLFBulIp8tI4NYdXI8p0kPbaiNBno/Um2tMaqbMx/veaIMzj5UJa25CN
	 6p71n1ebfGfBA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8f8f2106f1so918505666b.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:59:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUDXt1K5MknEn+LlGwXs2FSbutYwlF4nCI6ibDsodriU2Ub8KtiWYM//Jk8MNTS9niobEFzG+KMSg==@kvack.org
X-Gm-Message-State: AOJu0YxwnGYZoEkEWHBtg39t2sgGEkS8KcHHdUcLg0Bzt0KE/ntQ+LtV
	ggCFgRNZZIXB+4Gbv0ph0hofY7orpa4l3a4jc8g2F0gm9MvRhzbgrCCJ4NbhL3ixXrhp/lqckdU
	HsMl9Us3lDT9R99h5zMyPWv8nbQsJ1nU=
X-Received: by 2002:a17:906:fd83:b0:b8f:e46f:8079 with SMTP id
 a640c23a62f3a-b93516596b6mr43482566b.22.1772031551370; Wed, 25 Feb 2026
 06:59:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772005110.git.zhengqi.arch@bytedance.com> <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 25 Feb 2026 06:58:59 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
X-Gm-Features: AaiRm51rcgwmhy_l6lMgbqkiAK7g6vTS87LlDp6ohQJzV813HW9AeoQpr_xIsok
Message-ID: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2824540006
X-Stat-Signature: sge3riku3b45hpxumoopu4qjyskawhoj
X-HE-Tag: 1772031553-431667
X-HE-Meta: U2FsdGVkX1+uS3Eg1xcE7Kjd9KCsQMX+elX9WgoR2CUYcWyJpXPaaEnlLHyzetz7DIC+7YtFCsOGdoGVWvCI0yZG7mk4GCLvfYRdMgmHpNsZDKkoMdOuH956tZ33h1q3AvachdtPyvIFcORM4Noi6sEFEM/VIP2ApQVPcvL1tovCCxysf8rw6Q/K2zYSEI39lDPkLPsqe7Zfel3coEl/R6dyVPE+XB2bx4RFdj3shm1RoGJE55yl8/+SJFAWivGzeugeK5tBsjyiLBBWbhg5/OUqcKhMSDCQWS/QNQ9nmPjRWA/8C/jF0kjAq0tOh8Miob2N7HMvOLNPOPealImBgSHI94MMASpdg52Ji08peo1m3A0T5JFB9NLDlTlmsHhYAyqWMlqRq1al3dDZxvAGxhm9BiAlu5W0cdVGhvBOaMz2NM473VjsbRpIXo/vYbyZWo9PnCpY+LSL09+FAUJ4PTi1nQC5j1TrMFUGTMQmczOFabPL89zjo8qvQcQA/d88jc0dPo4vMcDbk2C2R9SdcRUb9iOBT+68STQ7FSybiTtN8hsvlc2KgnS9GMKYDXIcfwxKZ+Ojf+jC+sCeCoy/1tt+oG2WIgFQaOtfh3cEuS5r+VXBDEkltS8ds4op66/0i/FFPsZrQKnXPMJ7Wv/c/V3kVBdcsGgrLmum9K5IurePhAuUWb5kXOa9QXbfwJfKraWge3RU6sTTiBRwe+EBVK7z77LLbnspSN3gowIkYmx0hGqjB75apJukYmyexDtFhDy8UeB3fVooheaePCjVdA0w8mnMffRgTMahWGb7LHwqyIvQrz9+EKtbifT7QoiJaI/gDNB4yLxm/AREDRzCP5OvCx5lWugCW+BxJJvg7m58dJwVXAPqigGQEE1mwERplFK5BmYa38AHdw9SBloee5SznyP/xZdLH3nbuohYl8WiGN3ReaC1y9OGxiAfSvidV9FyWKFnp5NHINAoFFg
 RBcC1m69
 DZEaF6brKmEVMT87dt20TflraYVgUUwyq23S29ogWh+/4DaoXEOsZteRiTYEdLnHOSQ3AqFoM1A/p1tVaDKf2UREOYYaDA0Wx3vltSJfwzrJCZ/866xBNJQ/DGlo6bUxmA2E1TIRXRn34wWGJrCdmSGteg1/jjFjr2YRjTBNST1MT/JFcwYAaRJiqcKGtVL/A8Ng75FxaGG1BB1K9/KfuG/2+B0mJGyXFTvcFZ04jYUcd13y+mgvWajHKaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>         return x;
>  }
>
> +#ifdef CONFIG_MEMCG_V1
> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> +                                      struct mem_cgroup *parent, int idx)
> +{
> +       int i = memcg_stats_index(idx);
> +       int nid;
> +
> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
> +               return;
> +
> +       for_each_node(nid) {
> +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> +               struct mem_cgroup_per_node *parent_pn;
> +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> +
> +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> +
> +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
> +       }
> +}

Did you measure the impact of making state_local atomic on the flush
path? It's a slow path but we've seen pain from it being too slow
before, because it extends the critical section of the rstat flush
lock.

Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
will update the stat on the local counter and it will be added to
state_local in the flush path when needed. We can even force another
flush in reparent_state_local () after reparenting is completed, if we
want to avoid leaving a potentially large stat update pending, as it
can be missed by mem_cgroup_flush_stats_ratelimited().

Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?

