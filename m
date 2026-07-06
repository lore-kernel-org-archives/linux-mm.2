Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD59C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 22:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED46F6B009D; Mon,  6 Jul 2026 18:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E844D6B009E; Mon,  6 Jul 2026 18:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AFC6B009F; Mon,  6 Jul 2026 18:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B088F6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:09:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A4E88C7C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:09:34 +0000 (UTC)
X-FDA: 84959744268.24.AA94983
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9912A1C0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:09:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd13GMsj;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783375772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=M6J8rmo74YDrXmogw0vI24lrkohvz1jMylSnzHCFxoE=;
	b=pzb+fiT5v5CI1MifjbXhvSCkSMp48BQg/rdua4G1gPaQdB52CEW+OcOM4UMWk8+yrzAZ5b
	NyQYiiVqeK3CGtxWX4vH5YKtGOSn9WzjSkG7GBiTGKFbFqZMPGm2IE9hwPsxL58t4+gdU6
	kNm1mDvvJZMANeOlgBnhuuQpvmOXKMk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd13GMsj;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783375772;
	b=t6cGdaj1cYFPxdJTBDw/7rSd/v4oGbmkwvlAjH33JgS92JS5D/8yPAJ01ljErjpIQNKcsX
	A3h/Ign0nfkEIEUgBjsr6RiFz2RzBIeVDSJamGQPED4QpjMkOkznrWMg3OkXz6ISjy73+V
	0FNUhSmbl8Q8pcLOE5OavPh1yhgraeQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9285D435EC;
	Mon,  6 Jul 2026 22:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359DE1F000E9;
	Mon,  6 Jul 2026 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783375771;
	bh=M6J8rmo74YDrXmogw0vI24lrkohvz1jMylSnzHCFxoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dd13GMsjz+V68AoYcFSkxKjX9vuQjKuPGTosAbHMWekrMvv5wa0NLPShtkKLLNmn8
	 GAoD8Qk0HrBF6122V2795T8BDX2P7CCCxsomh7/f9tKnyqr/N7iGrs7+oBnDQfLVs2
	 EMPy93w5CGSDBvIWxIRjzDDdPOXd80P6NlHAsIiaGfwvqoxyEddYSOAvNDlptktnyH
	 fMdQcGLtBUCsLuzeTL0XZ/XY5wGeG2MYheXIutoOfpYJzQ+qrXTpG7jKJwF6yj4tkw
	 DviJlqMuiNhqjww6jO6sBHHGhYGU4nwU97ZApTFuMJ0GXnYFwObHc34RlXURbaniMl
	 c4CesxPnQ3MQw==
Date: Mon, 06 Jul 2026 12:09:30 -1000
Message-ID: <1e27d727c3c35d11f6e19eca769478fc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Gregory Price <gourry@gourry.net>, Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>, "Huang, Ying" <ying.huang@linux.alibaba.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Zi Yan <ziy@nvidia.com>, Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, "Michal Koutny" <mkoutny@suse.com>
Subject: Re: [PATCH v3] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
In-Reply-To: <20260706082023.60832-1-david@kernel.org>
References: <20260706082023.60832-1-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9912A1C0005
X-Stat-Signature: 66cye3ykab1p1sazn9kyf8oc7e1bpihj
X-HE-Tag: 1783375772-29252
X-HE-Meta: U2FsdGVkX1/whItFObZ8qG7/eORGDgOFGfOiOIWzvSaVUi8SqOyVFkNTngRPWtwgyYVBvGgufXLJYTmDS/aJZgmt3QAkUyQcVZmkakkDSVW9rIfptD1TL8/8X/EIB/MTrZj64DfKe9ZYP382H+cyNk+URNYB5UIWiq7ym74Q80+ER+/rbPYzl13eYBipOQkbse5hE3lSFYAhEXnh0LnLmD1tqFHkDYkJmzsKYPJP/kICT5UO+CubTNUm+fXKsek5YN9jdmrExxYA+gBaBsWRwUBFwBJ4V2Vg+UOFO2oj/U25Q9x/1+3IfdD49CowJ4KCCQmuqizXiRSDk16D37N1DFIfjaEj3xDA6Ah+PSgYhs3FQ5fIPQOvB3j5gdSsCw1u2RbmzZrqmgxKJV3CJogzbGqt2Quo/pLMU2+LW6+bSbkee29jdmKGtDxeUu3hUEc3SQ9rrOK/MGI1pRTdFuuyQKqnwuoR0JTHYxOx3RA71CUrlZ1+ekxKdRWxXa/jhV6aOk/3hHW/HdwpeEyHcAoN1BLf6jBofhFT3Dzmp6q1zJ2KeVskrMuQEsYaEV7bYZE2AzrKi3yqXUxuTP2V8WIIUY0a+rVTc97pcGaPuoYVG8W6Uk97snFe0t+urWTyn1l+7nDaPpNpQOuLJ3BwUdJCDOTdzkYVLFSIYtPCvK9u54E++G9A69dbXThU2fqt0tbb7IoLtDcnXx9D1O+VNMsxu2l4hsMX9LDGjxT7WXRHpW1UDlCUiv7Pq4WL2f/JYinp4b4R43w7X6Yhy+obga6Yb0S1fnlUTEQ4od6vG+JrqxrBhLUXWHF3BDLxoEXQccVpQ9MNZaC2TdpqykGbUw/76TXSBmQOxa31lbx0vVxgsoWzgZeQdApIdc2qh4D+hW7/sD81QMfVkbbDokOOeg8CZuLTTeY21M3xgal5SgtAPPO5ViHRzrMrpOp4oGfvOz50JIOnM8FWpvnpxcK10yl
 z/yZnOSl
 2PD9h9KsAjPjH+BPIUT5hBi7+GrhxuoQa63ZAu4t/BapgOmDTo3dm64S0ntse+Imp3TpfosagL6B/wNCnexhhlVmXxQ1o1RSyVQmsEDcv8c/oQBsg9VcyZWcl0u+oMgFMJ0EQcVh+8mFcaoLZ0inwPnVzE+MaKW/gjvdntI/5x8IPLd4v1EInyrHWbux7W0wBM8ZMELiKnkZLfB/HWqlxlQ72HpGy5zNl/na1cgrbBVkPm8iG02gXdSa+eGAnrD9X5j0P8yPE2UySHZZElwXPk3ebW40KrcJghY1awMC79d1aKLX9D7PwOmaHZoJaO3J5u9HppPjHgmezkWhMMaQH8u+DWaZDv91weNTM+KUCh1Lk4CI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Applied to cgroup/for-7.2-fixes.

Thanks.

--
tejun

