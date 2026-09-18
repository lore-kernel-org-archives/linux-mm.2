Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC17C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76EC6B008A; Thu, 17 Sep 2026 23:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10B16B008C; Thu, 17 Sep 2026 23:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27576B0096; Thu, 17 Sep 2026 23:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2A906B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:19:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D690A5E07
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:19:22 +0000 (UTC)
X-FDA: 85225427364.05.22B3AAB
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8F7D5C0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:19:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNPZfB+m;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789701560;
	b=cyFMaW19/nxqpNK2XZ96YqKRFAqSsEMdtMJxnduB+Xf48UQE/aFiiR9BHG7cNAlkGGU1xY
	Ta1igMkWhXZUUK+0HLAc8ipK7iPLZDHrkcKon6wLmThFX9iDJpbJy40ipnqAOeE8hZgLxF
	hZ8+FCWBoamdGlEGaQrFqYlTPiglSS8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNPZfB+m;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789701560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIxsdRmMSxJu3iIAOaDQgdaY/ymHqQ4g3ZIpIcuJfEU=;
	b=aYXEyYMaVZIFssnvrDULsahNTxoqIAmw2c+sFXIot8c0EHXIp6iOsq8Q/rK1gZ3UHPmxNK
	VdvuLbYsQ0UuI/L2W7Hp0VDetRVGXTkK/1Yjh2vvLsAbNDyYALJbvAPehKpyi4OxhAe6S0
	V+5QCOb83IXBI8HqORaqMhxqOBzGkIM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j2Lw8GZEQcOr2+soUoWbEZu1bj00nT++axnccGw8S08=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701555; v=1; x=1790306355;
 b=rNPZfB+mFrG02kcVRXctAqSTPXGWU4QTkdnvSrN9tbnLbAk5yQ/IB6dodLVwRK5krObz4GSk
 hW4wO7sD/BgZLzP31rbGAjU876ThbGJFDVf3UWXHnS6K+rXFg7ON1PZ3QtFMKpNaJybzwCATRx3
 NgE2BBJAahV5xB3PChgxFDQI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a4960d5e0aaf2f40;
	Fri, 18 Sep 2026 03:19:15 +0000
X-Mizu-Trace-ID: a4960d5e0aaf2f40
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: lance.yang@linux.dev,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
Date: Fri, 18 Sep 2026 11:19:05 +0800
Message-ID: <20260918031905.92493-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260917161359.9ba88d2bcab42db8111130e1@linux-foundation.org>
References: <20260917161359.9ba88d2bcab42db8111130e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F7D5C0005
X-Rspam-User: 
X-Stat-Signature: 6fdqnj181z8qc6ru7dnqen6gjikbbmha
X-HE-Tag: 1789701558-83899
X-HE-Meta: U2FsdGVkX1+5zUoyY7RPACAUPCE9ubn4dlBrqQWQ8Nn3rwxM1XTcJSR/5nkrQAFCXhiHYxbpoePKpe/4bFl9/IXrnpkG/ZDGjZ1bpqB7V+Twex/dR4MJSAKoZc0sJB3Iz94uw4FXXMgx9t49f4TBuAx6lvhKMVQYHL/fLxhdfqyRH6c6U+Q8KDPC6Ed/npm74/KstsbQ13NC0taQRjixNmw5T8iY6ls5S5AKzlAluLToUJGrevFlYqOUux9zGzjv0u8sHzj/coCh1GdC1vj2MBcJlNQchdgwMs5+44bPz+1T6I2KQ7Qxzh0Fssu2jNdOUwhe8IP0njjJfe5TJk3mSjuudZlm3LyWrqVxSCTIr9vrOsPAyHw+wsRKElmtrq5dmaiW3UJAS89KuRbTLAQzKZJmvlBBaP4d+lXRRXf8jCK67wUMzy5gLkx4bG++naKVTzdmfeGcfBUUCymkI8qAw9ZjT16RBerSU6/MZgt9D5rfDG4FaptDefPbt8GXmMMIbNW5lotK1owrAs72SvGwaYD/ytzFUafRwmV+HkfS26a24+Q6u+WqDfr1n7N1y+rWdhkdkTG9jGFxO+RHbLdIbyUaZSd9tjXSSFUL9w9aAzcYWCR2+X3QkStCvUbr+cdYVvnAaomaJyGvUQyH4IuDExI70OV+6KkHsJdzC4X6pk7hZN4j2FI0zUrXQSj6U/m0e9oXimOcur4GA9OZxuAcM0jiShMi/QsdWUPhG8Qfo3NQQgLGghM0KEVWUxxQ2LQvhlk+CjBzAVH56FmxNngPb9CwiC6mvbFRjYHkLke+dLVTEHuLcm5tBM1R7ukB1/dFQjB/BwHGVaReF0/BZFHwbUKMbpSlPhcyzHiOSIMQpIdy0QjnSX46orY0/Py6NreBtWD4sm1GN7IyQrsKLl0bk1J/V9HeCQCVPK8YuN7T+FdSwnSsOVjVWeCXCrwF4ytk/mHYOcMHggy/f4UIkSt
 ssF8bg+9
 VSBHvzmMvpSgUAvFhr7HSW2JzBplnjIfIEpfFhRB9MK6sq6nwXJXDOXu9Rjxr4HXoGk7vmSnAtT4FcE9tpPYCjPFK1GQk5Praryv0MH0d3J9tOZhHECwp8eIPu49T1xBdpyI/rUem7nNb6n3dA3bbN1kmcjSNNOyKSwdkoEUcupliK+ncJEC7eoY/zhfYmBwyY7Kqh5XjY3wc96UJqz/w9y9hqJOaPTGn8OXtkVeUKidwloVfzmHn0XNTh/hUzUYYxauyxyaz3DxzIxXbgg+4feHsQ5T+lI22j1pR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 04:13:59PM -0700, Andrew Morton wrote:
>On Thu, 17 Sep 2026 13:40:15 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>
>> Whether a PMD has a deposited PTE page table only depends on whether the
>> architecture requires deposits or the VMA is anonymous.
>> 
>> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
>> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
>> to withdraw a page table that was never deposited.
>
>A large part of my life is asking $LLM "what are the userspace-visible
>runtime effects of this bug".  Because NOBODY EVER TELLS ME!!!

That's on me ... I trimmed too much from v1.

>This time it says "Processes using PMD-sized raw PFN mappings can
>trigger a kernel NULL-pointer dereference when the mapping is torn
>down", which sounds kinda important if true.

There is no known in-tree workload that triggers it, though. Mostly a
defensive/simplifying change.

>Help me out here?
>
>Also, thanks ;)

Thanks!

