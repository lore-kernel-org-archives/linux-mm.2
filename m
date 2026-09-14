Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D067C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FAE6B0088; Mon, 14 Sep 2026 06:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051306B008C; Mon, 14 Sep 2026 06:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82126B0092; Mon, 14 Sep 2026 06:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4C3C6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:38:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DEDCA027D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:38:39 +0000 (UTC)
X-FDA: 85212019158.19.C52079C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 82EE780002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:38:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctkBDj2o;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382317;
	b=BYeaaGiaDpNtlAaLGpNHeUxJpGu+utJ5N/qYZp6vKo14dSgdlDKSvQOY5Xg1Wbs4gUnXun
	NMY+t6f2LxjB37qI8ggESmvs2hNSVzN2Cs78Twtag3XGo1iRYoXHT+bI8s0anbRIdbrevr
	631+faCK2FnGwylbJWtVCBmMvsUgeqA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctkBDj2o;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxIXOATk5FhrxMumaqsjd//lfDHJpwYqEyQwUB+eAxM=;
	b=rCLBUHnX6N4JDXDs9YXjooz2LM67Eeh2EgrzPR11k+xMKG7FxCbNKv3KemHF+UdWj2cZYc
	BwJcB+F4CHeGuGQbGTkC13wLWus5gKpdN123DL1FKVq32nba9XS+ZuMY6/RtFpu1XUuBIs
	g6jlzOiFYg3ndZgV22YzGKTzbF2egWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1743D60142;
	Mon, 14 Sep 2026 10:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456821F000FF;
	Mon, 14 Sep 2026 10:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789382316;
	bh=wxIXOATk5FhrxMumaqsjd//lfDHJpwYqEyQwUB+eAxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ctkBDj2of/0yY1ZCeqTf2CkovUmeZu8zOO1SBiBVw11JNgCFxqoVU02D1SlOVIrgc
	 nTvH4H79+jki0DSlPszf70mxlpTXqMJmBRgV+A1UBLF47eS/lJl/eQscGj29MryduT
	 1K883kqZDPIFT7O3XOP3JolNlf/VN+jvwEBCG5Icamfhbv/Hh37yLcN+xHzRNGkbK/
	 HzvKxtoM8tv9j4/V4udWdo2O9mNz4qSaCL2W7SxQTdxNbvFOFCgWnSFhrxnydcuK8o
	 UnNrN0nFl64FBdVcBqV1hFEYtSKkxfRKHmdUDGVTVqfcd9IGgZDL2A2ualdzWlr4Lv
	 clwfQNOBom2bg==
Message-ID: <cdffaae3-dc7e-4307-984a-8fbb55beb931@kernel.org>
Date: Mon, 14 Sep 2026 12:38:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260911194145.1781926-1-surenb@google.com>
 <20260911194145.1781926-5-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911194145.1781926-5-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82EE780002
X-Stat-Signature: 4afbj4j9eqfds8mgan67y8xd5o9aikua
X-HE-Tag: 1789382317-757015
X-HE-Meta: U2FsdGVkX18VokZOVK4l96fBrZ3SO1ludcUzyyQhDfDmUTQgv/D3KmEcP9FdzYcx+HxYhoOLnhkAh0DWDaCSdSYmYcRVzHgSE0LW1oMo4AS+BPS+HOWZpgA3z7Cmy+f1zCT+2KUoS39ulV26157nEZliG9t2nozq9+8Q3WtDvXs3bSO2Lb8praigBjOCs+mnA454S0aVQinN8QWIqAI5KLMS6/xyvAzBxcbvqRTWxze2/A4KP0cgsNLkIGY1H38zvv++h8AvHYTEqLsbs/n5RjJzUQdUpZaR8GUIFaTc+GbC1qK5vV0G8TgDxo8CfihGeHEpyq7PVKe1u8YLuaqtAy1B4JwwcHSA2Z9xsriGrpadTDVNAJJtfAiwG/DgXIwK4vYG+4we0YwABYTgJI60FDgZ7XKJXYGQ7fm2GsYzvtQccrPTGUQsXZZ/SeC/XKaL8CNHhr2VG/Kth93MG3fftmj3hatcjvL+PqdTBQk6oAYoMkFCy+3bCNO9rl6upBd8xUa4VGURo3YKS+Hxhz+o/GS28qEbhBBrrq9ex2XNKZJH7tdi0zv2x42Go8iYmx1BjNMU1V00W/qIqFGLkUfjWeTcYdfSJN04PSHDq7oujRfb837EDPYgOINR8IgX9+pm7JRA9/Q8vjKI/JGyjtoFQZ/E7biYYMXyC4sMANQc3y2EDGyXCy0hah7OM0sHDR5eXae1WSGwY1VXAKzUtF7LlL28bXyDmws7BVKOICT3gN4xtIWUdiZ6abRd17DAr+Xo5HnwWpoXXIusQNwEkP4XsIISv2PebBP0CH6sI75LJqtV33UW2a0Sv+aCGPQmUoTXC7c4EYXSFrG4RUXR41PnOCIBW5xaI1ieii8TQDi5RC78oAPHtaXiovb994o1luxmEJ9ZBJsrEzS1aersg27WW47UoNr1dKg8daxIDtDcj03WSkPRcf1JA1+fSBqLiZX87FMIgj4DvGSyZiKjvHo
 phsXl1U5
 SkK40Bf1Zz1zZBRHmlDwT+NgZYH8dHUL87KqkKNsok9azMmR/EVY4jfy7Y1PquChBrJO8C19bo591CL2vMW6NV9ZybB5EWrCM6XiVE8aY9lL/TLSInAwbCF5Ac62MZvqQOGgSf7U7jOohlsxVXn8eFiP16qYummSAMSIn95sWxEcoUpQlFVa21pSOMthXV9FPQlmgMidEuPr85b5bcXeRMhDeteYLEmAiQw17kbk9Zag+1IoZL9KP3aXW2uv55Y7I93s2CTJwEbszy1WORw9m8qji4rEAJgJZDm6kRXDqIvhNruQJFnxsUVCzP4231/j2W+7m7B8YEtIZLYfaow0dCw0HrJVVrbcWvQUeiOa9vzdDyMJAE2ox414M2VXQ/Jtmk+6oxKiSPNJbx6cRuEO+ngN6qNDGLtVxcCzUc7xBBiIsBRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 21:41, Suren Baghdasaryan wrote:
> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> when it's set to 0. Eliminate this special interpretation and provide two
> separate functions for a partial and complete VMA walk.
> 
> Since smap_gather_stats() operates within a single VMA, we can replace
> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> which is simpler and also can be called while holding per-VMA lock.
> 
> No functional change intended.
> 
> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

