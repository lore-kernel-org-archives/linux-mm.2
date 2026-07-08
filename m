Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D82C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1E86B0088; Wed,  8 Jul 2026 02:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083566B008A; Wed,  8 Jul 2026 02:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB796B0093; Wed,  8 Jul 2026 02:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4A226B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:31:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D5651A0698
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:31:35 +0000 (UTC)
X-FDA: 84964638150.11.0F299FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7242C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:31:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMBpqUXc;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783492293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdgAJHMGRJTpfsfF+AYasgFlGXIoomItdq4jFM8o5mA=;
	b=trpdhHbx2Xu4NYKCwi1yJs448zzEhrE/JYefBM8Zy5TjZi4bnJ8HSLlo0pGfcE0nw2J+Xp
	1LzjODrgAAXAH3SXEMkmpfJsuGsNkEfX1TqAjlu+JxvmorUMUktm9/WQZ6CHymLXKNZQmN
	s28RUqFPCWPnIV21xMXM2kaQ61or18Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMBpqUXc;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783492293;
	b=KUQVnEZM3mNph85Nd80btIVxXkEcQ34wRHQije9TH2I7RIuTTmCgifCUkoAJmfIIRqMSfN
	F0O4Knx7yuVoMCATikgiTlFZCQ3EngVj4DyG4lM6V4ZzZkFC7EXr8XP33DIfaWuSyTKHYT
	xQYbDBU+3/jNWGC2dIqlvlOazap5lQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 805E0410CF;
	Wed,  8 Jul 2026 06:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA33B1F000E9;
	Wed,  8 Jul 2026 06:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783492292;
	bh=IdgAJHMGRJTpfsfF+AYasgFlGXIoomItdq4jFM8o5mA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FMBpqUXcx1rEMTajpDAMv6rywRMlwmMyOccijI1R/LaMEARbJW4BU2vPsEM16GZ3w
	 C6OSsjIMkOGc/kaMV3u5QLJfXv9sX4z8gmmz20zVgxW2/9uz2/iWaD5rhqR2+xIIkJ
	 kxMMksBnbV5y4F4dehkhT6QGP3MQsPVfWf5IfDUdLjIwCF5W9yuD+fhsr2ikpLaDbf
	 LJ8ZqfLC0pDgnKbxRUdlH23b3D4isas2eAoxs16Oj4XhDPsI4a5lO5rg1lIY7LXYSA
	 ou++MqG63MBLoNaRzzrtzkcGyuuuFSyTVxZvdaFe8QSylmgXFMU3uXogsqti8rg2np
	 uyWq1EFX08FOQ==
Date: Wed, 8 Jul 2026 07:31:18 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, david@kernel.org, liam@infradead.org, rppt@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, Alexander.Krabler@kuka.com
Subject: Re: [RFC PATCH 0/3] mm/compaction: honour
 compact_unevictable_allowed in mlock race and alloc_contig path
Message-ID: <ak3uV7L5EEi3aKyD@lucifer>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604023812.3700316-1-chenwandun1@gmail.com>
X-Stat-Signature: 3qe4iyzjmjkn1e8yy35fa1iw9n3qj9kn
X-Rspamd-Queue-Id: B7242C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783492293-51995
X-HE-Meta: U2FsdGVkX1+sQ/LrNbVPYvClH3OrU1hZL4y7tJAgky00v0Q2VWPQTd/dzmV6eIw7yyMZu0tBtPia9XTgtTzsJ0N/K3Oisy4AD2R6GMLKVqyHbEQ3BVTOQ5G3ofaPaqSVS8yNml2rBNeWzeit3XKZcoFfkUC8wiJ0gzaXAqET8vcWZgzOZ1N00lxsF8fTtToCfrZbu9zpex0P/ySZHDydmFjr6I527azJcOkuroturJNb2sSLvbTrVAVaGuEEkyT4A3D5MN7c8wWwGA7ONDBdQW4i28bxycU6UTV5D6Y0qL5DmugiSvKT7t065xGL1wCQS1XMH7YkcC2TzCew/oboGRGe8OcHJ2w7M0OH0jbr7wIogvTtmuFA801NX2gaAof9UakSObSuD6Opm7NdBsrT71DUG2bUFTzbqVXf5zfC/4BdXijU0xN2pmH41ElDof5TlRl+rJnNcPACsmAVe4N4/sd7WbG1NBrb7rWgvwqP7lqGLD3TIDRGj47zK7QxnvxzyE8XeQxvpPxOe482g+4re0JUbbHYePWZWt9dkE6d6iOvg631tFaHrnQwj/dsN8PFL301BsmqI2ejUXqqdO+dO9w3o6CaNWE+vf1KxEoxr6FBGRVzijHXx0BEkFWsTk0bHXSmfpYeTDelDZwp5xBymscgG84z1+HcE/Yc1msRAARie0ycMdmmz+c+TKWQpy690w2sf3d7t40u6+LpWJxfaKt70SjzDFYOLc1P9Bmz4rC25/AMeR/BX5faWUYNxJz6M6+2C0CH9uT6hF961nTtoXNYq46Kx8Y/048HbSGIr/LFXwUYVoJnOj3lpdeWKu5e6N94TIrK3gIqAAgxHGcYfvPmmkPRdIgsdTfns30aPpIEC4uA6tvFSNLoUo+B74q4TIpf/a4DXPzdgHm0FzCrk/+QyvqD8Gv/3EnJBe2eFRCtwP265DVPNnhaTFNpPN53LLyGUL3OURgVPNh4lY1
 1CYjVSPn
 4YXIHvsn9jNxApRMMFrQW5eLjfb+OQrTPLaRQWLRTOM68E/y8FIli8gwMFosRWHLpWeXU7+oVDT2npThYxga28H9Tc2YH0BuAEsjD7yr5miBprnNp5yIP9Lf9SeFbwWe+RMkq6qbqye32MQMxvIyTjuz6AGGUmniZFOW/+EqKt4CoJ209aIuB4PCJ1aBtmQHFp/1EzTiHJnhFs/PpQjtbMJjTeQ/6dWUgUnpVWbD+r73RCgoeaelpZ0xrHqZMa1OxTyXfgi2pBeYZ7IwK8EQ7EvSxAfpST0i4aAlIs68EfiFN7HWAUV+uUe0aFunXK4QRqGXLiP5ZHxFaihJonChNJLtSYLLV5wZg4pgRJUZXvTa/QmV9xS+EGkPs6UBuC0SvmQNQTqecwYnCIUSi+FKd2pdCa5VFFm3nju4vPyqs52OtHeQcuELEMeDAUGmp+NIu4ZUBmhmnYFK84NUdRaWoBVNqHCRJyS2/EPjh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Errr... how does this relate to your other, non-RFC patch series [0] "mm: honour
compact_unevictable_allowed in mlock and CMA paths"?

Why did you send this separately and why do you not mention the other series
here or there?

And why is one RFC and the other not?

You really need to add more context like this, I spent quite a bit of time
reviewing [0] and don't want to find out that actually you are abandoning that
for this or something?...

On Thu, Jun 04, 2026 at 10:38:09AM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> vm.compact_unevictable_allowed=0 is meant to keep compaction from
> touching unevictable folios. In practice there are still two paths
> where it does not take effect. This series fixes them and adds a
> tracepoint to make such issues easier to diagnose in the future.
>
> Wandun Chen (3):
>   mm/compaction: skip isolate mlocked folios when
>     compact_unevictable_allowed=0
>   mm/compaction: add per-folio isolation tracepoint
>   mm/compaction: respect compact_unevictable_allowed in alloc_contig
>     path
>
>  include/linux/compaction.h        |  6 ++++++
>  include/trace/events/compaction.h | 26 ++++++++++++++++++++++++++
>  mm/compaction.c                   | 14 +++++++++++---
>  mm/internal.h                     |  1 +
>  mm/page_alloc.c                   |  2 ++
>  5 files changed, 46 insertions(+), 3 deletions(-)
>
> --
> 2.43.0
>

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260707125925.3725177-1-chenwandun1@gmail.com/

