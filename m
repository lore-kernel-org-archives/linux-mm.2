Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDF3CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48CE6B0093; Mon, 11 May 2026 08:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9816B0099; Mon, 11 May 2026 08:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FE46B00A4; Mon, 11 May 2026 08:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6726B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B535C2552
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:54:35 +0000 (UTC)
X-FDA: 84755132910.16.2B11B5D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1058D1A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:54:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TuoJ8bAZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778504073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnyUJDnBiYAt8XpIP24bVRpYkuXBS+8repkr/WetloE=;
	b=IMHViSUETlnMcM4bwB8PYK2de1XhFeRwjG6UCZhKB0EkLmbwhn4nvCIF3LgWq8K6D30bI2
	48O6TAoXbpE1XJ+xDJAH1HR1wi0qPagnJSROGmcP5EQqPK/hGx3wpEh1wsLD8VKdeuSXhn
	j6+XCrTugL2vxXYM5G1zHb08cd2vxhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778504073; a=rsa-sha256;
	cv=none;
	b=Rhx9BN4e9SgSf8tfZaoKOkQ7pEKN7qxHi0T74Mk/WheV1t0XbSD3qAZB1RQxs7QhCFKYCN
	ZOkiGR/IcEZSKDGCyX9iO9vraZ6oLlRtS0+zZswtk12hddmFASmBIpFIDBAHs8SyLuktif
	o5pV7olkaa47UAvnEJPWtXLffUweBKU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TuoJ8bAZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso49879455e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 05:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778504071; x=1779108871; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NnyUJDnBiYAt8XpIP24bVRpYkuXBS+8repkr/WetloE=;
        b=TuoJ8bAZix7dU85LRF1vxq1rYMLJbC96BOrEakzbyc528lhFHfu7zM5XOFAqpiqmcP
         AhggkBihcaurd346Ja70kyKPNBuwR3Grjd0sf1Pdwq1X2HfQ1pJ3PoQ5Vwlolwz8qsWr
         Oiywq8xLTzQgbx6KlyydaoOnT/LvvtgQhqSPxJgRE7NowcGItX2XUQHdFrusE1CMVV5l
         LwxkVYviGIfY/VWvVpJrJ5dI3Yi/O4TuHyg4zfzeNPppX85iqGpNLOLMQPwXLUIs/MT+
         +5OQF+HGApAoklmXC/45ojCBz4ElH3le/MmfUXFuYNpWqToBummRVRN/CoxVDQSgrDW0
         HVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778504071; x=1779108871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NnyUJDnBiYAt8XpIP24bVRpYkuXBS+8repkr/WetloE=;
        b=l2LK2utplVCXShdaLapoyx7H3CLvmc1wSZG9QGH8P5dbdqk7+QwoYy+qP37ekaYzWn
         rLddLxWPd3qgTDaw8bhqDEmqum2k8VUFtuRqjjpmqN7pbiGvnzCGZEyDSW8k47juDFSf
         QbG2LTlBcjmkjGgXZ6U13vkFAEiXu+Td9HFblE1rvgqCBagyeHJzxa2zys5l+aa1tiJa
         I/yUAKGEfKQzX6zjwwFXi3R2RgcxpgiaJL83R0crp7umSxAbWnedygCbSqdsWijRGBKx
         ah5w69gUb0ZXwZWTLjkH426u/NAWZ7WPrJaIEohoAudk2NffrzSpaLU7gR3dRPGDsUeU
         wPlA==
X-Forwarded-Encrypted: i=1; AFNElJ93c16byiVEH6PvGKUqJSAZ+gDsybatueQWsL39i6TP43izcpSMc2ZR/0/do0JOGduBy1EJrenuPA==@kvack.org
X-Gm-Message-State: AOJu0YwAOo86I9rUGRhy9952g5E9JjaDiHW+aCDzS0hVcaKrTpatAaXp
	e6VJVZ/JSgVmvcJ8I/I03/3YqgX9+YSeYYghYpHUSNDp0LLjqXnW9cc4w3fD+FUqL1s=
X-Gm-Gg: Acq92OH8sjh9+DI/hpPt1lTY8fQaJzuYwJaH+qdQH1LBEVLSgIj92/gsJSv64Br1S5+
	qXrivJZQX/x3axQhNI7GF573yK5ll6Z3kDmFEVUjfJsERgeiLWrMPWbGBTxAKSjIdG1ud8djjun
	Ae21GzlmYByc4hLGnbt9MP+6U9+miNYyQePyZkiZnTN5H5LHQpXvXV/X9cltM4dqayF449KfCau
	3vu2x/f+d7nGFgiNMqq0XdUQW2Nt/7/I61BxBdFoOwXLRxUCD9oM33S9D+akStgIySk4oFLmzIa
	aDe6rl/d8lsOt9dVPdBYcog2Sk3X4uFaTEApC3hZH7C+KSD/PYV/Ao6IoEwb5dPWj9O+bpH5l4q
	EPKsAG2bNeSU5+bFnojrpoqHJE0jNMdHY1B9/v9WCRB5tjz9VtMDcLLHHx5dnB9MPF/P4F3boKl
	u42dmK2csDvUYIORellxUo9VLWDwXT2FiLdSig
X-Received: by 2002:a05:600c:8211:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48e51f40ecemr425061575e9.27.1778504071455;
        Mon, 11 May 2026 05:54:31 -0700 (PDT)
Received: from localhost (109-81-87-110.rct.o2.cz. [109.81.87.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8d30dbsm100442215e9.1.2026.05.11.05.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 05:54:31 -0700 (PDT)
Date: Mon, 11 May 2026 14:54:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-ID: <agHRhlfIYbaqHHMK@tiehlicka>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <agHKWCw3CFO0CZ_E@tiehlicka>
 <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1058D1A0008
X-Rspamd-Server: rspam04
X-Stat-Signature: t7pr3r9qzcntbo3nedkaso1wp3m6agar
X-HE-Tag: 1778504072-548537
X-HE-Meta: U2FsdGVkX19fnuedj8xTs0qskUbtCtz3OjGUWX1Yq6UeWIVE0H5QDOSWyK++k5an3AsfDCwstJE6CygF9eqooMC7car1fak44vZsfkIhaeKEdk1cGVCho0pqpmSslSDnvKMWvxE/X0VUwafOkO8M5IAi7/leXHy1hpe0E3lwxIjC0fe3mDeYgErpCeLvb/5W1PHjWNr6vwlNagnE4jHGDoGNQ0vwcofN3zgbjYeoxerorvnhwAq54gUS35Q2bPhkpsNlZep3Uf1WCk5G0cqFxSdo06m1GKsU4si1oZQNV4dPvfW1cY6S1XVbSubPsbXq36LdOKrOkDLblk77NIaGfDyiVURs1nQrcNc5A31vUiS4W5XYD+lG7QoiCxpAlCY4kybGOSgCw7W0KMLduSvpv7guE3PFBnaCHCKRlsUbBsFpJUhqgh2jdD0FDktOjP0Xl/6OsIfk1B+1McWgVt5scQRNN+LjOU6xgG2EBtKdCtufNIycEx4+kylmtZDaSJ5c+tCoVrdTrzV5GPCLYHYtmuxiG7c4211Fbbq9dm3u45gvo3ZGcCQKeijVAMy2aH3S/Yl34qcEvvzya2jwdcGB4mzQvNC3E/y3yHiajUxeHthnr8nAaYy78cUKpzZan7/TAq0FEh9cquTEAuQWJo2P5hQLNYWAxJ0WPylMFZyKHlAcG01DOpxNh9CUgVJ87REv1B7E7eXAMfCtiBhIRDF6DFHFAibL+eTLapLXXXy68FTMEWc4hSBgHsXPser/pO7Uvd03oXEVl83bE4yGKKAzicGMs3zGMHo5EO4jyTHNM+VeRTKbmoGYx5DI5zbsDVaA5a6qAAgKbvgOlz5yJ+FA4V+YwZgg47TNQTzLiEezxXspEOJN38eHY3ifPKPVbDpKrreoAol4eqH0p6DDEHe3dRCmYIYbCijjKp30Sn4EImxh/baa2P0o8BPwNW4aeyCNH/lclDntwumDe8Q23G5
 OiiYHqkf
 7c6qbZY98/uMDu74KYdyJo0D1bwMFovqv6CnDYriLMggvnMpdOK4guhfIo+IqYQreNkp3ZNsllbUZN0nBsDvyD+Bc4RLDE/j5bmUgcwtZ8+jjxh9XKiTSuijxnbSXgja5FAG7X5iJs3N0mOuFkRRgtUZeApB3BQufLuIFkl76n21B/vSHMt+XlKUJOvQcMcDVC37rM+L03lCDYIMvgXRoKbSuiTawcuazyxYq7f3MGUXYL89PeRwjdCPVjogAqfDoPYCwA2YO7kH4C7ztDi5t7yQpcSvZ3G0FW5uqBKpnd38213MGrTvkHYYJZIgCfdzDPyINzXGgjSRmvoACyIDj77dNFWchLfFCHgJysU9Vg3HByPSuPDD5wLLjspJ2qSvSoR3JAAEw+9rmvmy0et4zNBgLSoJNdiDI589LMeBehbLYPSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 20:40:07, zhen.ni wrote:
> 
> 
> 在 2026/5/11 20:23, Michal Hocko 写道:
> > On Mon 11-05-26 11:30:14, Zhen Ni wrote:
> > > Solution
> > > ========
> > > 
> > > This patch series introduces a flexible filter infrastructure with
> > > two initial filters:
> > > 
> > > 1. **Print Mode Filter**: Outputs only stack handles instead of
> > >     full stack traces. The handle-to-stack mapping can be retrieved
> > >     from the existing show_stacks_handles interface. This dramatically
> > >     reduces output size while preserving all allocation metadata.
> > > 
> > > 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
> > >     using flexible nodelist format, enabling targeted analysis of memory
> > >     issues in NUMA-aware deployments.
> > 
> > How does this work when there are multiple consumers of the interface?
> > E.g per numa tool to watch node lock page_owner information?
> > 
> I understand your concern about concurrent access. Are you asking
> about this scenario?
> 
> Scenario: Multiple tools monitoring different NUMA nodes
>   Tool 1: echo "0" > nid && cat page_owner > node0.log
>   Tool 2: echo "1" > nid && cat page_owner > node1.log
> 
> The current global filter implementation would have race conditions
> in this case.

That makes the interface rather broken in my eyes TBH. Is there any way
to make the filter local to the fd?
-- 
Michal Hocko
SUSE Labs

