Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA52C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6DE6B0093; Wed,  9 Sep 2026 22:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867E66B0095; Wed,  9 Sep 2026 22:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4A96B0096; Wed,  9 Sep 2026 22:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF026B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:47:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBD83A03F6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:47:15 +0000 (UTC)
X-FDA: 85196316030.06.103211A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1472D40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:47:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GqB8NuMi;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789008434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwQIpJL6XFgYeovLrOfrrQBEuXDvt/nYNYAROMqmr4U=;
	b=aDi2oYmt3QlAgObcWfQpccQMJJZsI5ok5ULSXWIJ1zIS1ScA7DKbx8AdEIpZGB3TqbNMCa
	Z+9xJJOGOrNWcTzbJfCC1sxY/fiNUFBfP/Zz6SG4GA0LxhghzFZ2YOk6bRr2kCnSku4mcC
	jW4c6onTHGc7a6YDEkVfi3PlzkEEn74=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GqB8NuMi;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789008434;
	b=0WfQdAWi3ZnKGilDjBVFturqa7a7KcOgHWOevZ8I3GDBc4uKgTK2iOqUH1YGnJYCPG7/f4
	X+cYeInN+ziirsD+ghviEaIyfOl2LrnDgPzKNSwy28F7nM6F3Y2rzUvV/ge+P/iKlIIAMQ
	YJw1gnPYvcXD9D8v8acAne3RamAqUgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57950600CB;
	Thu, 10 Sep 2026 02:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF841F000FF;
	Thu, 10 Sep 2026 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789008433;
	bh=DwQIpJL6XFgYeovLrOfrrQBEuXDvt/nYNYAROMqmr4U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GqB8NuMiJIO3o52zIm9Um/v0WDyjDNDLMrzcmqdqsCMJGuke572wcg3uVfMlUl2Q7
	 7KReR5eczs3MlwumyAKo3tUFyHPQ5FI+Qtr24G4RkCYGbyy+h9XQ4DI5hFNhz4UJ9d
	 MKZe2wBRBN3bcLtW/VDIPE3RVoPHuQgVkwlD0VUU=
Date: Wed, 9 Sep 2026 19:47:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: yosry@kernel.org, chengming.zhou@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com,
 kernel-team@meta.com, stable@vger.kernel.org, Alexandre Ghiti
 <alex@ghiti.fr>
Subject: Re: [PATCH] mm: zswap: don't fail a large-folio swapin whose range
 is not in zswap
Message-Id: <20260909194712.706fb2e87a6e59097424c31d@linux-foundation.org>
In-Reply-To: <20260907161938.1932355-1-usama.arif@linux.dev>
References: <20260907161938.1932355-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: az56nn4m1cjheg67zpmyf8x8r5b8s61g
X-Rspamd-Queue-Id: 1472D40004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789008433-439828
X-HE-Meta: U2FsdGVkX1+BA8iqdpWSH/2SEGcamyInVUDTwMB610CtUzJck21+ZIUO/SUFl1NieOq/GRFx2tOY0kkQ+Qf5aQTP3To4p4bzF2xKPTmXyuI8iLPLgw6vBo585q8Ht0UpfrM32SuVE+lcPnumG944AHTZhgqDmrcOH4ncyxl+kwC3Z9tHAx0JRHyHH2D9PXTfrQJlsN4oYG7g11cQB+bK5+NUW8HHKGcd6uRuaKij9PvKF4fMjLdMIFrKlm95zEUP7oWf/uXg5gH9m6QSonW7VbWsRSzkDIreO+eAbGT6yegOiAm/DFYI0+SkbmWhi7t2uR7T3JKspLEyk+zB3l5YezO7TQACehnVyQG1ONi1is5FHxmaCTqmu2vQj6q1m1KFw0K8pE/az7QCOYrviVgz26S1RyrxjKBZNWmyQtNtirKIzvuJg5X+QBFOVn7z9WQlNbT48uKt6N39GMLQ1KnCcyLPSlB9w98wK1p6Sa3Ev6bGNHqg8Aui2HKS8ojSx84C5UlonfIjTJ77zwAz0z5c1qrzfSodytf7hSTTM72WK3wb/EtUtEaqmf/V3J+HFKxt1tvAbXMpiiMj3GhGIBePQsyIga/AxcWySUwWBVDeIGZlJP83NzKmoA2abs6KE1pa9HLnwAguoVz/Z5K11epP2fqONvOntK9EI8y2WC3RTOQ+RnYdOslI3v9IK6BaTW+7X7+rsdNm2mJFXd/ZcLtih3SzZu6J4/1M++KRG6vzf6UgLM+v8cNg8G6Kkm7O2mDU/y0AlJVkc08C2MMzk+RaYjE7O/7PUR2K2BQI0KqbgYUR2Oz4wYqpKA9yz58xTzbbOaBZVNzG45uL0w/Gqoo37TCHfVBA2EpcXT72kKusxyIHZDa+akwMx96eirzDTGm+k1Uq0I2FIj+eqGxxLcNl2KjZVfPmf0hQfTMXNhfQjafxe0fxnI/Lc108fUkMS5MtViqR1+sY1KudraCWzTd
 NK/KzLSv
 etv0OtGopM4K9tm1my4SVl9nV1h8icq0J35SFVlNT0rw1p5yUm1nMaEzt9h066Ah5g4pw/ot+ks2YC12vz49BjGFaZK3wPOlbjSzXi9XY5jDvPtvTKWhXuRTvrD1CEZmJAdPSXmKK0LBQi4ZN7HcrKIGb+eSUQmzYc2Q+5qpMC5sr6w2G6B+RupbLG8HuirI6Q4lE8eA0FTmFVK9R6rrYBMglKbhPaQtS+E1htIoDdCY1BrwkLw88UwSHQCMKeUaHXsmpeyLo893DxIws6HWR6zkq4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 09:19:38 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
> zswap_never_enabled() to decide whether a swapin may use a large folio.
> zswap_load() samples the same one-way static key again once the read
> reaches it.  Nothing serialises the two reads, and in between the task
> allocates and pins a high-order folio, which can sleep.
> 
> If zswap is enabled for the first time in that window, a large folio that
> was correctly permitted reaches zswap_load(), which rejects every large
> folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
> as "zswap handled it" and skips the backing-device read, so the folio
> comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
> for shmem.  The data is intact on the swap device - it was written there
> before zswap was ever enabled - and the not-uptodate folio stays in the
> swap cache, so every retry of the fault fails the same way.  With
> panic_on_warn the WARN takes the machine down rather than the task.
> 
> Scan the range instead of rejecting the folio.  The caller has pinned
> every slot before issuing the read, so zswap cannot start a store or a
> writeback into the range and the scan is stable.  If nothing in the range
> is in zswap it is all on the backing device: return -ENOENT and let
> swap_read_folio() read it.
> 
> A range that does have a slot in zswap is still refused, because zswap
> stores large folios as order-0 entries and cannot reconstruct one.  That
> stays reachable - a slot shared with another task can be stored inside
> the same window - and refusing is correct, since the alternative is
> returning the stale device copy.  Report it as -EIO rather than -EINVAL:
> the request is valid, zswap just cannot serve it.  The only caller
> distinguishes -ENOENT from everything else, so that part is a
> documentation fix.

So to hit this bug the user needs to enable zswap system-wide during a
teeny race window in the swapin code?

I suspect nobody has ever hit this and couldn't do so if they tried?

> Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
> Cc: stable@vger.kernel.org


Documentation/process/stable-kernel-rules.rst, with which I agree:

Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

- It or an equivalent fix must already exist in Linux mainline (upstream).
- It must be obviously correct and tested.
- It cannot be bigger than 100 lines, with context.
- It must follow the
  :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
  rules.
- It must either fix a real bug that bothers people or just add a device ID.
  To elaborate on the former:

  - It fixes a problem like an oops, a hang, data corruption, a real security
    issue, a hardware quirk, a build error (but not for things marked
    CONFIG_BROKEN), or some "oh, that's not good" issue.
  - Serious issues as reported by a user of a distribution kernel may also
    be considered if they fix a notable performance or interactivity issue.
    As these fixes are not as obvious and have a higher risk of a subtle
    regression they should only be submitted by a distribution kernel
    maintainer and include an addendum linking to a bugzilla entry if it
    exists and additional information on the user-visible impact.
  - No "This could be a problem..." type of things like a "theoretical race
    condition", unless an explanation of how the bug can be exploited is also
    provided.
  - No "trivial" fixes without benefit for users (spelling changes, whitespace
    cleanups, etc).


If this patch meets the above then its changelog needs an update!


