Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04A1FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 22:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72BB6B00B9; Tue, 28 Apr 2026 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23536B00BA; Tue, 28 Apr 2026 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39306B00BB; Tue, 28 Apr 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2EB66B00B9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:12:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D6038B900
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:12:57 +0000 (UTC)
X-FDA: 84709365594.22.97F6A57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B6F240002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:12:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XNpnAMES;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777414375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P38o4ftQzrV1YAuvv/5sD3orfSdL//VwRgFJ+EWZsmw=;
	b=tHDVz3zxEfy+To3eSH7x5IFh/CW/O4wpdkL3xoLFaRALm6LHkrQMNP1jYFdG36FyLFQyl+
	c9WGNU0dxGQPWplC8DGpNWuD+bTQZI6OGtvDxEix2+18uU1M2gX9kKnbGsg89/rYM6jnxf
	liEudb1NqDDbPaTtixE6QJeJCkCpH+o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XNpnAMES;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777414375; a=rsa-sha256;
	cv=none;
	b=jL5Too0sxnc0i9dwYxnHRXLZTqH5mcxpKLE5nxx9zaCXNiW9S5PhiCJHaTMLQxMyMsXktc
	eA2qI7D6+m5e9oPmFNa2ED+0Lpu2VoQMAVOIiUdrlM6jsp2PwXIv+Cyx94LXwwS20wNg0Q
	ebkFtXozSwsnxZPQPga3i9UFc/Gu6LA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82D916111B;
	Tue, 28 Apr 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB121C2BCAF;
	Tue, 28 Apr 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777414374;
	bh=kkg+9dj6Kg2m+RboFcKUDNE4w+XzBqWMxSts1BhV6I4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XNpnAMES5OC4zofWEQ9KsfRL5J+zTlmIOclCucf7XWL26Ni9y2W9YOCHeIz4luJxW
	 6epdhnr0Ye6sH711e47Tlb8kS31HcY0e+SY+dZqW8c30qVDfqDpzZUDcKjrQCHSjD5
	 IFOoeMtYNvW5gut/7PMoK6wqunXzLTWN86Q4Xl3w=
Date: Tue, 28 Apr 2026 15:12:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, yosry@kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2] mm: memcontrol: fix rcu unbalance in
 get_non_dying_memcg_end()
Message-Id: <20260428151253.bdfb08401ebb74c438df0e52@linux-foundation.org>
In-Reply-To: <20260428103108.45719-1-qi.zheng@linux.dev>
References: <20260428103108.45719-1-qi.zheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B6F240002
X-Rspam-User: 
X-Stat-Signature: ip6wmzmbgkxy5fbigbju8uzhm9aokno5
X-HE-Tag: 1777414375-824661
X-HE-Meta: U2FsdGVkX1/3/kCBWb3l0to8znqaYUb86rOyhNq/YkRWG5Kw4gSiUwTcIJE0YsNTX2/V1tSY9NqgwydHU+xDSEgOLZiQF5YeS9ETItwLAG6pdTnq+SIFypsKWtb4hwgVR35YTJpSDBvkS91+duA3nEHeN/GbT21bceXUqaOy7Mi8aeYh2gwXL1qc0jnB9CS0f5xdngmyTM9mwxxSXPGQq3tC40P+RPWWyHMbbDNw/MPAQW9P/As3jsYLBNorE86r2tsrt9U7BXoZ4Ht5A2+ca12oLN3HdE3KDzJC6FQpGKBbN+PX4JKG3Etaq4NnVTJLFSTrp90mCyXsp0j26EvvLdGAPDk9Z1K/O+uIgxlkxKZyfClccQ0MLgqc+ZLjUp/zvjqX+ZTagBmlWhvybnLpUFoUsjgM1QAi21u50cAISG/sD4kocRJquNr+mDtSXjC9+pEj6srUcHx/mmN6+QSD1Q7/Lsp3puwjuj4fnKLBaqr8WWK37bqG2IUmVQR1EVYXkc7nT/qBrqlOfRXt7SpPko1W+jE4eJke1xesIQQV1XCixjShWCoaymDiSH43vVIGMBdmcaN8QQN2XesW1vHTQ9xawniVbOchh9Rq2H7x8CNed71XQEf66cAOWJCWmP4NGNtszaNZCQ8f4RfMLE8pefvUlle3KZt5QbGLj+AnJKnviBMDnNpnbZ2AmTys0hugS7l03QEfjaQHxW2/dd/wsAgexstHFTqD5R7QlKhk564u0RuChaciAI5VFgrblsklGC4RRC/oLCcUTW29tTga8W1We1BeaBoZW8LNOsFl0rEnCt6xjVNI7e2HJB6qp3iu8G/+7xTcyoY+x77GJmVB9ylObpzRNurOj8nRKV+YBdzXk+vqBPz3zy/mfxdB/FFlO+zIFlodFDJt+fBU9uY/6T7e0q6t9B95m35W5jlWlwgXpcFZI+cwnjEoP1fuhgdALmmlG5BxdrI5/TNgTLN
 m683Ox2O
 rH3PzVMfa6fPW/FYHEzbSOtbplCBm3jv8AiWbdQIhiVaHuj4N7teqBIWDe75jngibz3ZUOxuP8bQDPSXj2ossHIV4ONtra9eHoUH+DYpcGKiIXsRH2K6oSulz3qHwADgFlJJqX99VEQvkqG7qaXLKLXnPVqvZyYQH2M0A4PQFh5E+GZZyO4aNOQgoltV0q87RrnE9FU9hZiVq36oxnIOLP4BU/FjY1/ygqGvRMy6T84J8mpt/cZtEcQRA/p98Cuv26TDsZdDC5BmhXEUI/XdjTtvQKmiYywPWH8uCCl1d8nc2DKvtKMIUzUGzk6BEzEgju4dpqS1rdVY7v6bR6g7ueyhNRYnLrx2b+k3A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 18:31:08 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
> evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
> determine whether to acquire or release the RCU read lock.

Sashiko review
(https://sashiko.dev/#/patchset/20260428103108.45719-1-qi.zheng@linux.dev)
is correct.

mm/memcontrol.c: In function 'mod_memcg_state':
mm/memcontrol.c:881:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
  881 |         get_non_dying_memcg_end(rcu_locked);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/memcontrol.c:874:14: note: 'rcu_locked' was declared here
  874 |         bool rcu_locked;
      |              ^~~~~~~~~~
In function 'mod_memcg_lruvec_state',
    inlined from 'mod_lruvec_state' at mm/memcontrol.c:973:3:
mm/memcontrol.c:952:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
  952 |         get_non_dying_memcg_end(rcu_locked);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/memcontrol.c:944:14: note: 'rcu_locked' was declared here
  944 |         bool rcu_locked;
      |              ^~~~~~~~~~
In function 'mod_memcg_state',
    inlined from 'mem_cgroup_sk_uncharge' at mm/memcontrol.c:5392:2:
mm/memcontrol.c:881:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
  881 |         get_non_dying_memcg_end(rcu_locked);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/memcontrol.c:874:14: note: 'rcu_locked' was declared here
  874 |         bool rcu_locked;
      |              ^~~~~~~~~~

