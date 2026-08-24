Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06393C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E756B0096; Mon, 24 Aug 2026 13:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F386B0099; Mon, 24 Aug 2026 13:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34F46B009B; Mon, 24 Aug 2026 13:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A22EE6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28A321201FA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:28 +0000 (UTC)
X-FDA: 85136781576.13.3CD3F2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 652C0100003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKHNCGhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tuxVMZTH96XP6FIpItXmNlPICI/Q5bWAFAVL7O6iwQ=;
	b=bWk627cALH578GoWl2+Rz8nLc/M0SyLwpga84Ao4tMLqt8Zbnb4j4MTWT4uezdORH/AQ3B
	jbmhgUXB57+zSQ3X70H/hwgnD/Prj2Ow8Q7s1y+GZ6+plxtWub3HNyBfoQ8mjDbDxvCcsb
	mU3T5KKCUWcW7QQrJJbxPrmO/xN5q7U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QKHNCGhk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590946;
	b=wEUOMnYXQFrGOa9sr3rfqoeCrg7KrveRTjshvB7Sazxqyfv4Z7BwByCv0oB+k5RPeIs7px
	7KTTLBSiukmrmaDSzzqyG4QcHDLxQD7/+fOngm2Mr0qHgHfOsEz40ob/QtPcL9vQ+6UhMq
	S1lRzxxDM5jmltdSIFl4xjC0pAFyv+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4BC440B75;
	Mon, 24 Aug 2026 17:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8951F000E9;
	Mon, 24 Aug 2026 17:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590944;
	bh=0tuxVMZTH96XP6FIpItXmNlPICI/Q5bWAFAVL7O6iwQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=QKHNCGhk2nwOGhuntoAkgT+Z1TfNxCaqfv0DJqeMmQybpXDer+dv1BlG386XWX99T
	 BkylOf9y6Z4Tzx1bskYSDIGeGcp1wAhF48HMa652N/8T9y2BfJ2hsNyjnecRTu3yy+
	 y5UhATyH3lgjBsCkM8RbyUIfXNAedhYKJvMamf9Y7mbyEwSqILoXXD3Wig32ki8KcE
	 ei7uKjZ3BK+q+1oG67GodMDt91daxIHAbXsSRAsieCoXjY3HStm75iDEQfrO5T8PkR
	 4Z74XNMZd38WoQtD1nvg85M4LmGYBrT30Tl9x9f55Om9RFL2nWlocAwgDDoYKWBh+0
	 tgLpfCa3IGNpA==
Content-Type: multipart/mixed; boundary="===============0322628108546578997=="
MIME-Version: 1.0
Message-Id: <4310125e5984331a686a7319ec57a92796571f4b7b1780345652726f717e41c8@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-4-usama.anjum@arm.com>
References: <20260824160523.3907021-4-usama.anjum@arm.com>
Subject: Re: [PATCH 3/7] maccess: Skip setup for zero-sized kernel nofault copies
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:24 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: 974md8fb7fb6u3mxhxnc9xwdjx9mscfq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 652C0100003
X-HE-Tag: 1787590946-275833
X-HE-Meta: U2FsdGVkX1+T5IdDJSNeB/XhP2lrzRzTlobEd6On3vIOrIVU7E23wMWJQ6RJSzgSH/wtow32uzfpxp/D8RYMZvM8HD1mH4WEof36R0ZOcMdwvd3QVloZyCOZVinH1xg7XW1LOxNwGv1x/jVKc0iZg6mzgYAJ1FXkqiQxUWYt8WFG8IbnOlSPadJv3F5nauMDl64wxb4zbsAL8fLRhgsfNIUIvisUqtFfjNsTXWWMNi2N2So/22b8CsZ9Xyjt/0IHFT2+Z3/2QwqsQpBDlnFeK4h997yjVQpXlA+UrD9+HuRyWK90VB3pPvEl5lhxpcwWdbWFX8XG72jRtJpqdWUD7X/ZQX0hARvPeGPGMziIg8Li33lhwdRuNr7p9jt8D+ODFXhiIs7aDB+vatJl0xDuDeifaPtTt3bp+CmQ9z2DwWtDtX24wGb/WDN95yxogVeSNHKVxOD/0QOyl9lsiyfQbu8FvJAblET8Jm7NbWgTSCa9GGCzfAOK+fOcGyFeEutgAbJfyKGcytEVKirevOsntEbMBW5IYE6975wT1H+l1lUhZiko6OdsvSszQgZu7YMBEkDIw2VSTgoGdcJmFY78Z2QsgD/6lH+5bMiEVBY+63o5lgu6n2ILleW9dNR2X6WXhPzdKA4rqELgwNpg4lPdMqSQuPOrEJuxG4oxr+xia0QP30rkD7VkbgGUi0zzoUSbzd+n7Clb2E+lRxH/gYzDlfnppGhEqBeqixptTIHQb8smO9jbVjn7FilcN1YEGgJJAlMmmQoNAPyeI0VKE9MgBWhTFtvSXE1F1lOzXD4/0SJs73EzZ85t2JCinMfMBD44q7ut2l5jgUEEVKcjcnE97xjqhL4XlDdz2vVETcNfR1JmnYxUiCxFE6uiFlAjthLMiCRc+4xrt5eJ/TyN2ijIqSS5zaa+DAR9E7GiAcZBpoSxprrDntgwhQ720LdugDS39KHFlbFmsjj3ysnAzDH
 xdFzlyoS
 xhj54as64sDuhhwjra8dXJcs5igSHqBYqhW2F04ZA0iMyjDj1rKeGXIPsymlY/RgwRlw0fgFt4b2qYdGPsV7yEu0YNk4ow82FHem4UYcR4Ad6yhQm/YYK6sljizydnhuq8+vGZbDBomnmzuzC3xrC+E8NVwHQHMKwUMcFHftjdkU87+oeoNLfDv0u47lS2aOqlguMz5U6JglKUo79egL/DrEmP45e6qp+dAQk0SyDvrhAzE8zJzlZNk98p6bAf6wijyD6dac6wSIq7Wdudkp/2HTRg8/tIHgWftgxCry8Z+ADEi32CAsrdPrY1A+246HaHD89gJMcvKUdDxTKD8OTeZazTZC9gV6vKSYfrLs7QX3UUjuE+ZHLk6v2ZHbnJIcBw6V2x0sS01JIyLXxffHUyptcWvmVEW3jaOd4koRQSqOCBbtbFulJRKwFXqtBINVZyqW8CjyY9j7oIeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0322628108546578997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> A zero-sized kernel nofault copy does not enter an access loop, but it
> still disables and re-enables page faults.
>
> Zero sizes are valid. BPF probe-read helpers accept them, and KGDB memory
> packets may carry a zero length.
>
> Return before changing page-fault state when there is nothing to copy.
> For reads, keep architecture-specific address validation before the fast
> path so its behavior is unchanged.

This isn't a bug, but would it help to say in the changelog that a later
patch in the series wraps these loops in a bare nofault (TCO) region and
relies on the operation never being empty, rather than framing this purely
as skipping the page-fault state change?

The current description focuses on the mechanical effect (skip
pagefault_disable/enable when there is nothing to copy), but on its own the
change appears to be a no-op: pagefault_disable and pagefault_enable only
increment and decrement current->pagefault_disabled, so a zero-size copy
already returned 0 without touching memory.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============0322628108546578997==--

