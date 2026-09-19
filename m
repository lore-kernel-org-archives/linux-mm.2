Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99954C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9D36B00D1; Fri, 18 Sep 2026 20:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BA06B00D2; Fri, 18 Sep 2026 20:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669696B00D3; Fri, 18 Sep 2026 20:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4440F6B00D1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:26:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 927314015D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:26:09 +0000 (UTC)
X-FDA: 85228619658.08.CBB6CFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 068B71C0003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:26:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV3bGKNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777568;
	b=VNjUAyMrTqX/ix80NzSTyWmjUk+sqFW2WTpbnPTZUgC+uyrMRo/b/80EFpcdpyVg/K7syn
	rc2u2EVaUnkzo+SPaW1UWZykPvtmoUdz3+U70c0NjsV/LmR5/At+apwZVFZhbU/3HtQaEG
	7as8tA0rh7ovlsEVDDN/pWtBw3pNgKE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV3bGKNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GELPEbFVXKBklHiVlViGJWcS9YhkAO9x07HDRK0Qds4=;
	b=lfbUNQziOq1yqRU2yNP1cwvKySoCiIOfxsle0dI79BuycqQfMmf4/Wuq6aOEgKhvHFHK5o
	IYzwVn+VVzJ5ln28DBT3Y5XbNr8HJbAT4jxV3kBK3zfjGagwLzlDRqi7lzX4ZrTJbCcPrI
	FqUwnbFJbo97MrRPhH0FFQAYefZzyr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82CC860A62;
	Sat, 19 Sep 2026 00:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A801F000FF;
	Sat, 19 Sep 2026 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789777567;
	bh=GELPEbFVXKBklHiVlViGJWcS9YhkAO9x07HDRK0Qds4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV3bGKNTwt+dkaw3NYtbnogRbP7A4Fi+w35zUwtO1TuyPq0NINwHeY5n/wakATuno
	 uyGjDCfSlS0O1xEFzVIL1rXT7NBO9Jzdqa+SByrG9LvpD8YlE2S914XaajU5ISUpEd
	 jvFA26hMiyQLQi1o7hSESoH9n0XSesNoLYx1Y7BXRzYfshv06+6JfJVH8vqSeuz1MV
	 AUgjctXXZk7BV2l9ahtxhEfEN2BfWFHIgHx1F5QUNoMN85fyKiN9BA0aSQ+l0t1hQr
	 G4ONe9h6qe3s/Oujmq9+uLFdqYPimkS9LC3ayndEFuiaOcqlMj/72pH/rNIE5HwLlB
	 JFLjCPqxwQsZw==
From: SJ Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SJ Park <sj@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Fri, 18 Sep 2026 17:25:58 -0700
Message-ID: <20260919002559.77365-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 068B71C0003
X-Stat-Signature: yyi94siw1qmdb58k9jthnt99mkc4jbju
X-HE-Tag: 1789777567-156404
X-HE-Meta: U2FsdGVkX1+rcUKYggV16pQWvk7oRM/nLwlkOK5d7PMPh8gFOS3TUcvXFKiFMhA5TQRD/DwYGGwLXxkbybw5pO8grXQKpgaCFxepj3dwnacl7hD93bY4jJtEhGaVC0V1Iz7FPbuHKK63k8YMwUUuIiIqq1CeWty5lsT10PbMZWMn/gmZF4x6KjzhpbIJ32tNKT/b+3IgQ77fJAE5JGjmkGKxWcyHJ/NBU0wa1Of/GRbWiAHgCwgMOPjLr6BFFzLtAL3ax7HiGiNPXq0m/43eOGbsPD0MoflKjKWju1SRu513aYJzhutr3hdEmVXfymwH1O86PFT2yQ0vVRBGOzkxfq5paAycvwfNJL3ueGDT779jkzMV9ClZP/IbjqsU63b5+qmPlYB4ezCd4FImJsBoMOE2/u5K27H4sAs0kVEfNtcGm1hwGfDI5tF+1NuXsy+DRmI5mQlaXbn83qt9ijrS3Le8kjduaoq1gCn2kR1A/gQeJlr+CLkdtRiW2TEXc8PF6VqpJyJpgKY2zFQBykP6Q8IUodS4lqb+pQG+8wm+83xNl/8EmJpWhJZrHjWMGVTdhMSiLZppni6xSgTJ3SX08iDVt0R/DiUCqCYqIKCVnj3ACvFwdrcSnMnCuBxcXJHfk+MnNrldDmbBny6AKR7UgWX9BD2EfYr/RmjyGtnqVbyLZmn6dkqdvtcYdzRWKfaICfjj/+8JhTIG2Nz0SPAyYXmbQoSORqpQQlDmZEG8GG6XK8/m3K0u9IgH8WsSZY2ZYsn+R0aspcegTmXlEGGfCJUDiO2XYYWwj8gTWEuVGSRaA0ba1myE1fl/TFM7SoR9XfeeM8EJPWsHSdcrhC1GqpaVZwAQOT4jw7nDsv87chgbDXhiBH4qrPAcdcBivbeeRIDEn773A/Sszf3liO0u/C1UPZd9d27oy8HB+9r3ft+7cfXdPlMXujFf/7Zrjvz45Hvwze25C4XT0Q+ZO6o
 dDneqapM
 k2gH2LLZiAzgBhaXh7zRwZUmF+u2lpt9XITtQIfTe2eU94CHLdYVJ4VMeMVXT1pnsRxSu861huq15GXNjpszEHJcPlbHPV4avuHM8BcS5VEvhXVYhnFRKgOp12veOUomLeTWSj+XIGnoL9Iz7hhdUhf08h6qjYtcwFIsG89C8ykJ2HtqcQoHscGG9FOal9t2h9Nr1OUlFXHgh29DgO+XEaDxQqQfXc/fat9LrjxYFnIqBWWorcJMuS2OBJOwZs+rucV0U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 04:24:37 -0700 Breno Leitao <leitao@debian.org> wrote:

> This shows up in the Meta fleet on ftruncate() of large tmpfs files:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
>   task:rocksdb:bottom  state:R  running task
>     __folio_split
>     find_get_entry
>     find_get_entries
>     truncate_inode_partial_folio
>     shmem_undo_range
>     shmem_setattr
>     notify_change
>     do_ftruncate
>     __x64_sys_ftruncate
>     do_syscall_64
> 
> shmem_undo_range() walks the whole of the requested range in folio_batch
> sized steps, twice, and its two cond_resched() calls are the only
> reschedule points in that walk.
> 
> cond_resched() is not an RCU-tasks quiescent state.  Use
> cond_resched_tasks_rcu_qs() at both points so the walk reports an
> RCU-tasks quiescent state as it proceeds.

Makes sense to me.

Btw I wonder how many cond_resched() will survive from the Mutphy's machine.
Just thinking loud.

> 
> Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

