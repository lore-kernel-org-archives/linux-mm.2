Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44154CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAEE6B0088; Tue, 12 May 2026 03:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA23D6B0093; Tue, 12 May 2026 03:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF506B0095; Tue, 12 May 2026 03:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 914E26B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:26:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A41B1403F3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:26:27 +0000 (UTC)
X-FDA: 84757934814.25.603105F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36368180008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:26:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V88nSviC;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCPqNoPPijRV3gL5b6ajQ4oELtZRP2K8OTVs6ADyC/4=;
	b=8R/MAjALWCjR3wDUXNArJr2KYjPVsRw6q0ZkexcFGnT1MCJEuDDb1ozj8O8QNj/ZLbHFYl
	c+WlRG+HPfKv+tTMUOmo7bRkOniQkoW4c3zQ7AENtDWQsRfsz3lkkDZEz3mqVVYQcwfL+8
	UxKYFr7TdtR2yXMB/IuZ6V4MSDVvvpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570785; a=rsa-sha256;
	cv=none;
	b=ODY/Ppmu64gw454CUDUSqdaFO63qxy8DYdjr7S2/NeR9nBPo/O7dYsogD87xIw60hb8Kw+
	6fEo8PLy2rj0/Uwomg0jY8DRnbxtdLRcaYapLDgZ5CCmVY5rwzGBh+QDruaxvj8YJyzzwI
	6GHSjUeYUabZjj/4AgyN1+0nffccPFU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V88nSviC;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b150559bso39894785e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778570783; x=1779175583; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GCPqNoPPijRV3gL5b6ajQ4oELtZRP2K8OTVs6ADyC/4=;
        b=V88nSviCk4ty0se1EpeK1+bWMXJO5qvA2VfI96cIW6GQDq/7IyAvPgFqWoiFuITOWG
         XsJAjCS0oKlgleHTxPw1GXAhzHp7i4JC4M0afxXaxramjiNeZA3/0fpe7WWPIQTq+sg2
         xWiAUrU2CYQCMHChrAsJZ9qfAegz3ezprqSJxpD/RFvIqCSGJXwJuBQlvOd/8On1Ls8/
         R/CXTZ2b/ZAO3YYKnUJ+A8IUDeCbjuKh4238XAZhE5f9rZV3yr9QKUX2wDOpqkJXr49R
         gLGQKE8wbHeMycWa1pf10ziCUr4j8cMLjahxteO0YgAJSnU3FKaFbybZmB7uMAxW9Orh
         u3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778570783; x=1779175583;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GCPqNoPPijRV3gL5b6ajQ4oELtZRP2K8OTVs6ADyC/4=;
        b=QmOEcs2AnVwH+uM1IFyRLN62Gr15SW7IP/awwTeFKmsQ1lC4GLi6cbdr6CLwxNE9J7
         PGrxR/SL3skwYHpwv/SFaEHma0zEa9glyb/1Bty+ZjlWAllrn3KYB8qQn8G6W/Rtt7WS
         ktIHLrtSb5CFmTOnwNgqvXTt9GF/b1l2bCoon1722yeyg0gsN0RCfShyumd1UmmB+Mst
         imxIqjm+g0zekRqT5y9VozUEd88hkIWPVaanMH6pXnj6xm5RNj29VmSF8VmXe/XUKsy6
         yFjVQuRKiuyMje/fJ8/BmunAhIzstDVOjPBtTIFLgBVNGQ5KV66t+a/HnCesFMevXwZH
         amcA==
X-Forwarded-Encrypted: i=1; AFNElJ9XlR8OxwQ/Y9DkRSVR5H3JKp9mOkGD1YAbL0RpzMHcssMqF4Dk3xiI0W6P2pZ+fAxzsgBrG1jbRA==@kvack.org
X-Gm-Message-State: AOJu0Yxlz67d+ShWXNKqxK9wBB3GiTlEavZuSFOYHMIoauNWbBz5H5Xu
	pSgdQ9mL1uae+Uvh+dZTDl2dk9N9zzrr2Jl9qsdKQCxPfYWGpa2h5DLKyNE2vMTameE=
X-Gm-Gg: Acq92OFqqj2EAeqM+u0p3UvoamVcVKZqpRP3wRA0RNbKVLkGH7PMNN+Mucu22R2VtnI
	N8rXfgk1rewhqLl90sHZ0+0r6sZB1m3Y6BNwqHZWqjyCEp+XOilBlqnqU4hUn5CrorbRbjnra+H
	qe4zBhcdLe8JzxRYATS2NfNwLfobcLXhpGHLq1GoTtsMJ6Qj/5mcgmE9u5H9Z1w4ioWTgGO3FY+
	JlZPAJKWPtzAbItQ8fz8RKpIa0+S0FYCYCfUh/adgQ72PrQ1Y4CzZl3U8OClG5uD6KBxMUlPDrb
	MIs46IXou6FlUZo63jC8nhGGaAj6JE8+Hqm8VJM5dhjF5VsDmMKY0EEqaygTHe28Ye9FQB7UjOm
	d6E0ovJVe8EEytrmvADv/nSK2/zi7YCx6NDmumTY8ad8wHG1OUcMGP5NRSSXdc+MFXN5mEUbV0t
	uXhRhBDnR9JJmgwyzXU2qHdkv9qD2+FEMGsQ6C
X-Received: by 2002:a05:600c:6299:b0:489:1c32:210d with SMTP id 5b1f17b1804b1-48e706f120fmr211843515e9.15.1778570783509;
        Tue, 12 May 2026 00:26:23 -0700 (PDT)
Received: from localhost (109-81-80-123.rct.o2.cz. [109.81.80.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454922715b9sm32447501f8f.36.2026.05.12.00.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 00:26:23 -0700 (PDT)
Date: Tue, 12 May 2026 09:26:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-ID: <agLWHkhlkBotiLYM@tiehlicka>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <agHKWCw3CFO0CZ_E@tiehlicka>
 <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
 <agHRhlfIYbaqHHMK@tiehlicka>
 <4a06f50f-fb7a-4b5a-a9d7-664407f83472@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a06f50f-fb7a-4b5a-a9d7-664407f83472@easystack.cn>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36368180008
X-Rspam-User: 
X-Stat-Signature: ptg47p3m4aythjsn5oenng8d1z5kcdp6
X-HE-Tag: 1778570784-955307
X-HE-Meta: U2FsdGVkX18piZV8oNjhOiTzNJZ98FM28S86BX0RBYOcb3ZFEVoTWmA8xDZTOeDGcoh58pPJUBXAUHgNaqoxgNutxlBEuz0C0WvJ5hIWz+xAHtgeded8oD+k8I08fQGQ/0tAposamgUo7Rq+WqTGjhpmIgqo/kTo+UkJ79B3rZ30ugXHl0SgeHlcHGVPqd3z6toz9uAGSjt1ZF1JpTwDcNMFJYk+KZGCJk7DrV8LYRUcH45fE7SiER1LC+boZ6sQ9U37TAEXlvNhxE6e/CKRUCOXjocYvgbXAtdPt66wWLnVq8fx31bNt8ThtMT4zjBdwYdsGZ0pvGl/jg+hpxbZoCqi8326eupCMH3lBPPaAxqBlA5+oL8Y5r4YWr8Trggsg39O6IabQi3jIfgDg+TCu8713Vffds12OZA+7BMAeEoPFzmduR7nEAiy0nW0UeAV3x/9YNRbDxMkqLzYtRItOynealRYf0vbjWBvZrk8a7jmDWJmGGs2NLKLwk2Sxb6WYRccHwGj6IbEIriOlCEeehrVefFQwO4gPG1L8JPL/ZTshLmMDTNLWQnP3dE2GavaJh99BVZKbg1r1nZEnMcShOZ/2+9FYG/GWSNDhjSDxsAV+eIz6sd7fG742zKFH6XQAXx2XT+3znZTjxhKUbdT2Q61vuLtaeNDSxY8yya2XhnD45WL21Qjfu9WRp/vr8fjK7EHRfu+7GA0QgFYzFVxkWweqokeVcsvfVeZNk3QhWtF1yBDoXIkFqrgbY8k+f2POCvDwGw6MhGaRqBO7aww4k9MoqKdM49KbJyTCXk5DuTpuoDmfqQ6aUwyrpmaw1qkp7vBPUi2A5ePT4jdl8mYLWdkdd+M2uNV/MH25bNYb/SbEpiezF8t6vWRxEfU7wR+F4x5mQ8O2uicxYX2pvk2j71wIgJl0oHhiLwSQ12bBTMaQdnLjAClOzGH9xUgbSNTARfxKGTHkHoZlSpQ/Mx
 fBEj9pAx
 PHRmjQKYOCEz96g1BeGsApLekl46Z8Efhj7Gi+gRBn/DofaCpeFDHABfW1ZpTYqGC8BmZLnfB6YnnoygPbfw+m9edPfrAtN8Xzsx4A9rwguAXDfPXvQou1gM+p21iwNxw/2cZZWrCZaeqi4O7jiWZ9IEWR3DyHbw0VQE42QWLExDf204D31JvmIGWkfdcmii207pN/XiiLddmnBt2HG/fyxZBNL2a/72zLfVB2vtWqXDSrmXKvFAubLyhOjA/IiCLZIGyFoPfoTXIbWe9qCKJ//NQJ2bie90LcSHAi2Elm0j0aPzNsklCATsrA8sk6G1SBs/KKY9/8Ln19nVwmf2aUAP3sQvajIWITPQZ5+djhICIsrauYHtMx9VJvFeui4UdvqUPG+yzVflFZb6VZYaYGwRFzpc5JJogQQ8vFbh8sX7x1FQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 12-05-26 11:11:47, zhen.ni wrote:
> 
> 
> 在 2026/5/11 20:54, Michal Hocko 写道:
> > On Mon 11-05-26 20:40:07, zhen.ni wrote:
> > > 
> > > 
> > > 在 2026/5/11 20:23, Michal Hocko 写道:
> > > > On Mon 11-05-26 11:30:14, Zhen Ni wrote:
> > > > > Solution
> > > > > ========
> > > > > 
> > > > > This patch series introduces a flexible filter infrastructure with
> > > > > two initial filters:
> > > > > 
> > > > > 1. **Print Mode Filter**: Outputs only stack handles instead of
> > > > >      full stack traces. The handle-to-stack mapping can be retrieved
> > > > >      from the existing show_stacks_handles interface. This dramatically
> > > > >      reduces output size while preserving all allocation metadata.
> > > > > 
> > > > > 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
> > > > >      using flexible nodelist format, enabling targeted analysis of memory
> > > > >      issues in NUMA-aware deployments.
> > > > 
> > > > How does this work when there are multiple consumers of the interface?
> > > > E.g per numa tool to watch node lock page_owner information?
> > > > 
> > > I understand your concern about concurrent access. Are you asking
> > > about this scenario?
> > > 
> > > Scenario: Multiple tools monitoring different NUMA nodes
> > >    Tool 1: echo "0" > nid && cat page_owner > node0.log
> > >    Tool 2: echo "1" > nid && cat page_owner > node1.log
> > > 
> > > The current global filter implementation would have race conditions
> > > in this case.
> > 
> > That makes the interface rather broken in my eyes TBH. Is there any way
> > to make the filter local to the fd?
> 
> I agree that the global filter state creates race conditions for
> concurrent consumers.
> 
> Regarding per-fd filters, I've looked into this approach. The main
> challenge is that per-fd filter state would require changing the current
> simple usage model:

> Current usage:
> echo "0" > /sys/kernel/debug/page_owner_filter/nid
> cat /sys/kernel/debug/page_owner

> Per-fd implementation would require:
> - Add ioctl interface and allocate filter state in file->private_data
> - Change page_owner_fops to add .open/.unlocked_ioctl callbacks
> - Provide user-space tool (e.g., ./page_owner_tool --node 0)
> - New UAPI header with ioctl definitions

ioctl is one option. Have you considered to write the filter state to
the page_owner fd to create a local state?

> This would replace the current "echo + cat" interface with a
> tool-based approach.

Which doesn't sound all that terrible comparing to a non-deterministic
behavior of this proposal

> Alternative: Simple mutex protection to serialize
> concurrent filter modifications. Though this doesn't fully address
> concurrent reads, it could mitigate the most obvious race conditions.
> 
> I'm wondering if you have any thoughts on the trade-off here. Since
> page_owner is mainly used for debugging (typically not in concurrent
> scenarios), would a simpler approach like mutex protection or documenting
> this limitation be sufficient?

The thing is that unless you own the whole machine you never know who
might consider information from page_owner interesting to filter and
read. So you might easily get garbage. Not completely terrible
considering this is debugging interface but I believe we can do better
than that.
-- 
Michal Hocko
SUSE Labs

