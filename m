Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD55CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 08:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842D86B0005; Mon, 15 Jun 2026 04:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3856B008A; Mon, 15 Jun 2026 04:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB7B6B008C; Mon, 15 Jun 2026 04:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 561E46B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:09:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0A3CA093D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:08:59 +0000 (UTC)
X-FDA: 84881421198.27.7292FEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E9D3140004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:08:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9uwC3no;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781510938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czdigwlYZ8jdQimVMktoCHfmpDTgW1yiFk/SNIziXVU=;
	b=jEW22tcAubSM9W0CgKnMqOZYWCxns0uQi0thLqMQ4Nm2pcbcCOJQhUxPRMRVGq8m2pSN2d
	JKHWaeoE9VpIC8svdB3XhUJ5wy8bD2hfDhNvuHguS1k35lZhlRTOVIDWgP4gmKt78udP98
	yYVExGun49Zxlfmt0gPj4HT3N9UkfsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781510938;
	b=mrsNcWm0nnOW5hK0EE887LSqEl9sR/3GavxkMxmd/Xx9e2Y+CNCwNMFmtwD2hCDP15E3Ze
	Xj6I1UY3DhQbLpcPAHZv64OgYYECg0mJCeUAdQVlcQ+Kmoql33QOCB0JKkJYe2BHmu9B9d
	UF6o7rBRwNuMSLivJ/k3rkOeZ9obEYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9uwC3no;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94D3660132;
	Mon, 15 Jun 2026 08:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E91F000E9;
	Mon, 15 Jun 2026 08:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781510937;
	bh=czdigwlYZ8jdQimVMktoCHfmpDTgW1yiFk/SNIziXVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E9uwC3noUffTCjqknAzvm/sSeJXawABhkRsSILrPn17ih/UNq+c9+BkJD+Vkcn/hn
	 N5bBuOUgg+FUmzKQnsE/oVMZYLCCx9hrW6Yl7KgZjHKHkRGIUqwXwExRpSdnFr1lmH
	 CV9Fejyqa+F596cG/Rp0MUnKxO/YvIG6pWVKqXGu9IJR/Mbpn/1qF1W+iXNoEzYWu/
	 Fy51qJhpbToiLfgSvGECd+frmrnp9cXzd1yYGqL/Fg3Qlml0dOLSPHg7+a3XSASnH/
	 zvW0vmBxXA1GR+of9X+gR8TMmn6ZJGA8/W6aJIyJDqnhZRiL2xSqipW4HAshyA+atu
	 Ief3OVsouqFIQ==
Message-ID: <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
Date: Mon, 15 Jun 2026 10:08:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Waiman Long <longman@redhat.com>
Cc: Farhad Alemi <falemi@asu.edu>, Gregory Price <gourry@gourry.net>,
 Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E9D3140004
X-Stat-Signature: 61n4fhzq1xbpgs4eucgus6md7imhqkfa
X-HE-Tag: 1781510938-182693
X-HE-Meta: U2FsdGVkX1/eNN+dVUYSShS5C8IbLTGvXl/KHd1zQCnkBXH3AP0g7fIFLeEGObWDOwWibZypILWLpj4JRvYOlEbs0fdiw6lNOapOFvBANYv5kOrL4GUT44QFZLbRPCy3IoO0JO+bqo1XvA0tSoZjWHYkdgT17MkPpnOyBAxH3zfD/WKfMMeVKCFn26tV3NL9+3t07hRgEIuLWZCnhOlgH00Sms3b4s+LJv2KDzTVZQ0hMPKpbC1kK9GBMCepWoKph4C+V1CrXxG2QbQNeO5OlWvTPrPST2+HFj6YXfdoqZikIC46wQnmBrXry4B9M5cUirEvV/Fs2wNNJLOcN4EVTySg5LLnmNIlexC5fgep5hPbQ5696o8MHF6nw+MZfvDdWQMtzXNI7tclMSuzq5/psZnRh62dmuISUNXDtDP4ENWmjHo85ULUIxnI/gXO1vkIHJkHn/kbMCzF+/tuYdVQRvWLHRZyLtyFtDQrPM4wuTs5h6cY5U99kNCp1MPEOI+NnF9odWFBqqIVcJGRX8Wer3wPIrV2P+PQJWAgELY2v9CuD0p4vm4SHEsVpG1NDuN8vmYYpXfE5BhjBEJTGTPf3rPphPiA6i6TQ1yLwc1NLYS2T6OgWUunlCMm58p9vtqk15/Op31yG6HeLtzLOWhEW/uZf2HOmUBWLqyx7PdZsHBY/dw39EoR9UTbjkUcUSxLplLKP+/vjWgCBsnjxSPYtmfbFN4vqnUVdcK4pFQMQNi+euMIDKXyqrJrv01h1INZQ7BlF82MobKL1T4341jH6GDjBPLHp9YRFBd3Eq1m5bGK9EqHlB+5lVmDFQ7xHf/XPkbIrCx2rc50nOFB+paoWiTotYaKRskbI3KYVSUI5GFy4doF4JNymxeBdnsodRWtPj5oKQIiphOU0jsLaF9P2TzxcV9ITlsQEvd+mnQJ1VcEaUmdEbWJ1YUCtNgxkU3gLBa6biZ1x542n0p6JCS
 vGPIRiKn
 Po7xk1W8xd93pjZWGPidrE4FMykT5V37t5uE5PoCclM91GRKGbY6J8nBfadbiUtEOl7zCyULhdzcbQeSc0UuFLBcI5CfjP437592PkCwSaKi7SBC3FYgykK2j10p3TTOOi59a9oDAeXALckw7HtAQ/YdAJ5YpdolmT/Ss3slcro1R8nxWCZFwlKxs7GYISiTbvaFAd64gjyVAzOuBmpxY586pNi2ko+127KFazKLZRQaw3AtMn7Cmpu5qPfnzoK+FpQx9ruJhWw0gIpHz+/RqZVbHytgAxFkvHoDpmPoRLC5hTLe6bIExxP3trCpgbo/9OuhPvy411+hikR5okbCaZwXlETy+EtL4vMjiKB00op27IoYFXVolejRAKZS6y+vJYqqYcEMUJrpbJ76f3qm+g1X5pm8CL7+fph3s2pPHfcOVMpOPDCBhWiXQvUiO5NGE4tkIOWZggp65RJvJKn3g4vAT+eqxa+/wLl1ubrAx3dLa8PzsV3Vgj6V1TJdJZRfMqqWJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/14/26 15:25, Farhad Alemi wrote:

Hi, thanks for your patch!

For the future, please don't submit new revisions as reply to previous submissions.

> Creating a child cpuset where cpuset.mems is never set leads to a div/0
> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
> CPU hotplug event.
> 
> Reproduction steps:
>  1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>  2) Move the task into the child cpuset
>  3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>  4) unplug and hotplug a cpu
>       echo 0 > /sys/devices/system/cpu/cpu1/online
>       echo 1 > /sys/devices/system/cpu/cpu1/online
>  5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>     call to __nodes_fold()
> 
> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
> nodes to the rebind routine.  Use cs->effective_mems instead, which is
> guaranteed to have a non-empty nodemask.

Probably worth mentioning here that this makes the linked reproducer happy.

> 
> Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

This should be a

Closes:
https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

> Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
> Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
> Suggested-by: Gregory Price <gourry@gourry.net>
> Suggested-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Cc: stable@vger.kernel.org
> ---
> v2: rebind to cs->effective_mems instead of newmems (Waiman Long);
>     condense the changelog.
> 
>  kernel/cgroup/cpuset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
> 
>  		migrate = is_memory_migrate(cs);
> 
> -		mpol_rebind_mm(mm, &cs->mems_allowed);
> +		mpol_rebind_mm(mm, &cs->effective_mems);

God this is confusing.

So, we obtain newmems from guarantee_online_mems(), which guarantees that
newmems is non-empty.

In cpuset_change_task_nodemask(), we set tsk->mems_allowed to newmems, and call
mpol_rebind_task(tsk, newmems).

So at least tsk->mems_allowed should be non-empty.

Then we call mpol_rebind_mm(mm, &cs->mems_allowed);


Naturally I wonder: Why are we not using "task->mems_allowed" (maybe cs vs. tsk
was the original bug?), which is effectively just newmems?

guarantee_online_mems() computes newmems as "cs->effective_mems &
node_states[N_MEMORY]", but walks up to the parent if it would be empty.

-- 
Cheers,

David

