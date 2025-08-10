Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A39C87FCB
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 01:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2DA8E0002; Sat,  9 Aug 2025 21:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A57F8E0001; Sat,  9 Aug 2025 21:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFCFE8E0002; Sat,  9 Aug 2025 21:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE5E98E0001
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 21:56:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 540A7160342
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 01:56:31 +0000 (UTC)
X-FDA: 83759183382.11.EA9894F
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9DA540002
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 01:56:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=FKOJBMey;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf07.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754790989; a=rsa-sha256;
	cv=none;
	b=gTEo0SANwRX5Y8Hto9jMMlW6HiFUnLrQVFC3FiVtmu+yrdIgph8fJiIX51+mdcWeH/IKAM
	XUQ4JflvfeXzkmyY0gxGEuZ/bwQqhijO35GTUhEvO6F1wTrUzsd/+l+QOeoKS0NMOAXdJo
	zMTHD98N17vP6tgzhathDc30dWBERjY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=FKOJBMey;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf07.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754790989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gk7Rrap6m/JcBi9xp6sWJRJcd7s+2s1ezjCVNiCQhg8=;
	b=LV7wQM75rJUY+Dvk94VcgqAtSyJIiCzNX12NykGhsxKf7RBI+4faPGVSbx4rZoEnq0FoyA
	v0z0G0p/15725Zk0+GX2/qC4WNe9L+kMUYiehPKSGDJNHQmR492CktfQOrE7ucPy4zYlzJ
	N/GpTXHO7Uc6a4hBKNcwxOlgSWezeqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1754790988;
	bh=gk7Rrap6m/JcBi9xp6sWJRJcd7s+2s1ezjCVNiCQhg8=;
	h=From:Subject:Date:Message-ID;
	b=FKOJBMeyY23HY7A30+6s3GcDGuMDnI7w5eY+ko/9Z47tAVa+ynXUPU2XFqwWF8uSa
	 PaLEIwmxiHPumcO3M6s3ZVQnw2lrcP6xHU1GuIrtdjxW0BiGB/B1p6q2U1qMfjyMyI
	 ZUCn9LOPXw+mUw6cFoqBkaLZtyHWkpyy87AAfGAo=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 6897FC45000035DC; Sun, 10 Aug 2025 09:56:23 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 6166724457115
X-SMAIL-UIID: 23DC30104ED84353AB622780476B2448-20250810-095623-1
From: Hillf Danton <hdanton@sina.com>
To: "Subrata Nath (Nokia)" <subrata.nath@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	MM <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: prevent RCU stalls in kswapd by adding cond_resched()
Date: Sun, 10 Aug 2025 09:56:11 +0800
Message-ID: <20250810015612.4133-1-hdanton@sina.com>
In-Reply-To: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
References: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9DA540002
X-Stat-Signature: utbpom56sqratiy4ff84sep1n8r7wfi7
X-HE-Tag: 1754790987-443791
X-HE-Meta: U2FsdGVkX1+mSfi5FOdz6ON35A3HlnwfVrLiysqjXiGGCakbr+o+OPYE3jjZTo/9W7mTdbuyCyoilNDXI0I8m/KwCxHi+w0SXIQZ4xaima1qWiRdb/AvE5BBh7vW51tsaqNFvOyWylUlytzk7FepW+Iqh+gSMidxtRgAUjTBXkAarNIHPwurxZ8HX2ZPEJAS1lGh/QTGGuWtm4b1CSlGKA+v/oA1OtIG9NH0DsT0chi3RDyazYFkrMO3run8CfO1tbGlbe8alBOab/4neWuZGFRUVH9Krt5YPcK58g7576h66opVdfGxyRw1SLC/stkc2yMKwViUqrzSu7o7EVH3wahkNnl7D8NFuYTe46tQ4urHG9YwecSVijrIK1QTHEILXGLdMUbE6PsS9bWkSkYPJqKsMwkWFaTxoUO2EoMLvezZv34g0YtucxgvBy2KD97Mb9RI8AjD1dXO73HEG4fkaN6T4t0aus1u3etHUfLV6ztdMlGkMgSwbMB351InNoyn3dGG8tRemRY+96AlpkAXO5FgEQ/tLA9B4phUl2y19UR8aTb1rafwnacOfPARr3uSKGRze/pyoc0PVmeQ8YO/CptRFZU2xLNYHR9+HGVm9sJ+ooI1p2dgA4RWecTBrv1EATYK8jVM4sdEfS+Qm5FAl+E4NoB9TShaaNulsA3h9COsaiswkcyMOUcaaWgQFjKXLj1APUtwGHAbcu5JBkZsCANLxWbpWoMmkpJVdzgmyIv3f8HilVC/+QiSslyVVeFEkwmcSA+z0VJl5brOFDxvPSI47gqM45VZ5me3JkbDc1dq5bSmul9/ZwQB8sxCzjym4b44gciFHQcMsxXPatjk4vqcI3AMh5IBSRUds3DUMZ+4LXlbrKvDfpvwGiUMe+vmQfQzLUplAuPVG+4a8WkJx55C+D4x6nbvtooCiO7ckLh4rNZEDwMhjdZBZNyqaoMveUfEhdMJDGasS+wETTw
 /Fq9BGEo
 6cafopzMrWiMguZfCQUUjdQx8m3THAousmV5VsKpHYARiAZWo+klOP2LH+BJbjT7YdPRsnypbguwIBJ3gR5LC8OZPg5tvGJXU98CKI1huSJdzL4wauhfSkgp58mryCBR+g91dmX/cxzvfDL4Nx6gQpwrwbDp+EeCNDyaaQN99CAVAeHFH8stiunvZiexfsX43fgHDf4PQBPQpV2EtVKH0X9TnsXg6FR/xf8xV78TIq9XgH5b0J3Oijz1PiVa5ki2HYgf3eH9ndK/mv1Sc9fClMRTOQ8tYxg96MYS01hF4gmzbcfV4/ZcOe0FGUdKd/R8jWmZZMKT2p936Ad8t7Ceh3HsIMZ07hIo8hy6eVLENDuOimHImvqoTApiVZBj3Oi8EBlIW5pzXY9qxNC0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 Aug 2025 11:59:16 +0000 Subrata Nath (Nokia) wrote:
> The kswapd0 thread can spend extended time in
> page_vma_mapped_walk() -> queued_spin_lock_slowpath() without
> yielding the CPU. Even with CONFIG_PREEMPTION=3Dy, the rcu_preempt
> kthread cannot preempt kswapd0 because preemption and interrupts
> are disabled while holding the spinlock.
> 
> Example stall report:
>   rcu: INFO: rcu_preempt self-detected stall on CPU
>   rcu: rcu_preempt kthread starved for 65939907 jiffies!
>   Call trace:
>     queued_spin_lock_slowpath
>     page_vma_mapped_walk
>     folio_referenced_one
>     kswapd
> 
> Similar stalls occur in shrink_zones(), where long-running loops
> prevent CPUs from reporting a quiescent state during the RCU grace
> period. Without such reports, RCU stall warnings can escalate to
> soft lockups or OOM kills.
> 
> A quiescent state is reported when a CPU exits an RCU read-side
> critical section, enters idle/user mode, performs a context switch,
> or voluntarily reschedules.
> 
> Fix this by adding cond_resched() after all spinlock release points
> in page_vma_mapped_walk() and in the main loop of shrink_zones().

Given spinlock in calltrace, this fixes nothing at best.

