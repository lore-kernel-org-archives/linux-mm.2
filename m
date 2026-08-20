Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B45C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2166C6B00A1; Thu, 20 Aug 2026 04:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C76A6B00A2; Thu, 20 Aug 2026 04:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD6F6B00A3; Thu, 20 Aug 2026 04:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD2486B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 750D81604FE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:21 +0000 (UTC)
X-FDA: 85121003562.01.78EF5DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B232520008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQr0lUO6;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmLT+lbLlZGhVRGS5nzuJP8BWMHxLCoiEFWXXq+9RLo=;
	b=QCbCpx2V/drurhzWlj+xVpT/1CpEzyWphWBUvoD1wLLfDIsMidAUG3Mf/hoSz69qGRP3Vs
	nTpTA/rl3fS9dqAe2jGB7208IMFsN7EGaB9ZjuFE0H4sW144Jqwzja6aYGzIEXuDmcl3xG
	5SJDlXSzlnOc1jhXDMyho4A74ouk1g4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215279;
	b=dJ9Emq++39I0HknEmji7TcmOK96+x9WVqL5VM4iSO5edTg5WFxIZzscpf8eDorX0W0ma0B
	lZGIvTcc869CUdEJf4+IGl+HpLwngrUjnz4ylspOf4pVrdBLT+UtTSIuIxPREtsySXsZL8
	VcKgk9JwvqRsitu01JXHq/5GtNDf3js=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQr0lUO6;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13C3B43470;
	Thu, 20 Aug 2026 08:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0F61F00A3A;
	Thu, 20 Aug 2026 08:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215279;
	bh=rmLT+lbLlZGhVRGS5nzuJP8BWMHxLCoiEFWXXq+9RLo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZQr0lUO6N442CdC9SKRk+GDcbzgI7G5ymhvUKwkNE9eDkoUeGhGVZ3ozk593Qc5JZ
	 tbMOAtksSDe/6wYNPCyexqwdL4rXNpxTerRSP00esMoKObjnMgdypwpeAkty0ZYPXA
	 c5h/WynHG64CDgPQ9BIlVJyB4t6OvXL9Je/MzI/ygbbVkFauK8ucvwNv2ghMBCjiNL
	 0RUle4n2Dx6uJn5fIBZzPFZjmfbvD3Ql5ToLKsOLC02UHPR8d/AAbsDjZMiDw4RkOZ
	 oaszqYVVBAGB+NQjbqw08BnYcsLzQ0BeIUxQND+U4xxlodBdGZzpTGhzvXQyqevqIe
	 2ESke7FepeemA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 10/19] selftests/mm: add khugepaged completion
 barrier helper
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-11-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-11-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.9631834855392157058.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: dhk3p3kjo1jhbpsap349wop7647msf11
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B232520008
X-HE-Tag: 1787215279-417185
X-HE-Meta: U2FsdGVkX1+5V+5HczydUho/noQ35+aRS3E9p615Vmy35nYI7hPVOn5GNCQ9onF+Vjh4knOY0qsDPh84avjBvQ3YJgFLYd0krsjDqIahIHAAt/1tOLgenzK/jul7nQMMw845QQvrFLaWX8rVXorhfZ/zMQe1NjLZ2SS0KFHYOWLsLkfeI7TdWtrQ89a9Y5sS/vIVFpGnUYlj6LluYnwEIO9/UPfY2M2xUmGk5v8Z1YelgqFB4GPkRYBPvrXP9ag5+9VaJ4GTXpxd0A0dEpLPLzdVizG+xRwrn5TJOeUNtK4c6kgQwbUEeCdcFHaFZcGQtiPVLoXgd50v6otyiMQKJxfyUJ53h+7yho7scwitswXmejkW+KHw8QpS/XbmbXfdexPQd5P4zo+3wR+gCyDO6yHiF9FT4nFfij4mBhi46cRjHqlXB01L43Ic2a3vkZXNpv6Np0xzsDQtpUX9ctksCk3agVao3pVUjrzLRBuc9F+G5eSCyFfIN6jicNZ/1IT9/8Ik3KQ5uf6ExWw4+eu0bWMHQGjwSdjPhKkZrIQFJCigZt1MDConTbLKIIiPy63Wklzjk8h2dmnPEsNv3TEXUrL+WBdjXfzB8S+OhO8m+KqWU88rgBpRFniu6gsuwMIrY3hbts5ty+8/zVStnwynK5rFXfJVMtS/Z3dvuw0WF6BfZNbP3JDl2takmCEpkDWja/EKRRUm3wciwbi/0OO2DmKp2ZFkAVghW09m20Q8d+TQg8gZQ4oN6TZ1+g0PZWYVWl23/xFgdDLifZD5HU7HQPCSJiNUeWTn8xyhJj+zCftSrpRMXlgPyiKGoAUzU3tqFl/is4MOWJd0VInpNZ4pj0eAe1jrG9GiV+/LHFwt1CIL6uTfaxC9eqTz1Fuia70QK/usacED/Vn+Ubgp5xc4rh++ebvGDzbB7c0eEg9+HLssuEf6CNMotED3q68JdFWbadL3xrwhJHDNnhogcyC
 BBLC5udO
 xUL1hWUXa3mRMIww86r/jZg8qdUw0HhU8VOyPdTuuK+fvT5ARj+JJdYojeDY29x+6BZOfrBbmgrlBCyEvzpBUopG+mFWj4GHcoo+DLaSkyDn+49y7QELpJplhShj5GmEdbw7K0ZeVdKKB4Nf19hV++bexTptocassehPVMMRU0GLCkNmUYtEHhghP4VUXTntH2j6L30oLuFrN3/Y9Gcgpn25uWltdQwfe5lo6wP6R3pKhK2kzc/NUs4nNZhqxrDs8vqD085dfLyMzF51s8UB3fdfsb6NbTUO165wnlL4pboOIphc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Race and functional tests need to drive khugepaged in step: set up a
> layout, let one full scan pass over it, check the result.  The khugepaged
> selftest already waits for full_scans to advance by two, but only makes

"advance by two"?

> progress if scan_sleep_millisecs happens to be short.
> 
> Lift it into khugepaged_full_pass() and drive it through sysfs: any store

Lift what?

> to scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
> the scan cadence.  A store can be lost when the daemon is between scans, so
> it keeps storing until the pass lands; a store to an awake daemon costs
> nothing and queues no extra pass.
> 
> One wake completes one pass only if the whole mm list fits in a scan batch,
> so callers need a large pages_to_scan.
> 
> Settings pushes must not start passes either.  A store to either sleep knob
> wakes the daemon, so thp_write_settings() now writes a khugepaged knob only
> when its value changes.  The other knobs do not wake, but writing them
> uniformly costs nothing.  thp_update_num() is exported for tests that want
> the same restraint.

This very much elaborates on "what" and "how" and very little on "why".
I'd change the balance.

> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index d7917dce3aba..992efee17b71 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -183,6 +183,19 @@ void thp_read_settings(struct thp_settings *settings)
>  	}
>  }
>  
> +/*
> + * Write only on change: a store to either sleep knob wakes khugepaged --
> + * __sleep_millisecs_store() clears khugepaged_sleep_expire and wakes the
> + * queue -- and settings pushes/pops must not start scan passes nobody
> + * asked for; khugepaged_full_pass() is the only sanctioned wake.  The
> + * other knobs do not wake, but writing them the same way costs nothing.
> + */

Hmm, the function name already tells that it only writes on change.
Do we need this long text along with it?

Surely "khugepaged_full_pass() is ithe only sanctioned mode" is out of
line for infrastrucure helper description.

-- 
Sincerely yours,
Mike.


