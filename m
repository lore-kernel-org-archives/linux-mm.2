Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F02F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFC16B0005; Thu,  9 Apr 2026 10:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7BF6B0089; Thu,  9 Apr 2026 10:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F50B6B008A; Thu,  9 Apr 2026 10:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE566B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:06:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCEF7140872
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:06:22 +0000 (UTC)
X-FDA: 84639192204.21.C4A7F29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D34E1C0017
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:06:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6x9MLQ7;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6x9MLQ7;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775743581; a=rsa-sha256;
	cv=none;
	b=5250lE+5+Q09iGaYHWzq1SIeD51xbI7bbEBctEKqLmDY+DfK0erI6ivcMgCXw+UpOesrHc
	tq4GOpdy+kuBFF5z/EMU7FE8sL+qamk8UQa01eZZPTlCu0i1m/N7fppUbA4zohNyuuMOQx
	h2Hx5W0YamaGQqaGeZyOXTpFpISC0rY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775743581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zN2RWwliHwvmO1m7pKGVxIqLFw/Mka8ioa1+WJTc31c=;
	b=SpQPvO+sppNZ05v/X254R46ub2uVngfO2l3Xex7dOd5kqv2EEWBJhSusRZNMxqKAbNH9/C
	4AtRrxrn1S/eIoJGkedzdov3ZZtwvXzvp45rjtMcRHGGhQdW+g6boppWqG2GmRy5cq7Til
	rahqmeZnsqeKLGQw4tkeRayS6MpJl1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A778943DFC;
	Thu,  9 Apr 2026 14:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0FEC4CEF7;
	Thu,  9 Apr 2026 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775743579;
	bh=jBPfiBPxlm2WM1isURI2mqe0QeK/tVgNp/mgGBiaY/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6x9MLQ7cjeA2A6vdamXXAogq9IJ/vOhVwDB5AQhhNrQ3AAfsquP3Z3H+BA156lAF
	 0vwfVwtusDKhYcxIPc/jL6PTGrDyOLWUe5roveoWvL96NSlZ403TecgriRxnHwYbtS
	 LuP2mc9lkBWCUA+t0Pn+DvpcpOEjW2s9WPCmoaKMYKBNz1qPrYd3DBEpjx8Rg5HPrB
	 3bBz3V5KULZ/h8vfvVovwfyV40m5bo7LlMfbAVJIoOw/Yzww3632Aq33ST9HmopgAF
	 HJOZ7Ed0mSl64Qxieuwm9mBu3XbOTHiCVp4Bt8BGrG6NYEIrY7Fr0HAlVV5EZxbijt
	 /YX4dklSo4i1A==
From: SeongJae Park <sj@kernel.org>
To: "linruifeng (A)" <linruifeng4@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	chenjun102@huawei.com,
	tongtiangen@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: support freeze kdamond
Date: Thu,  9 Apr 2026 07:06:08 -0700
Message-ID: <20260409140609.59881-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1b340c6e-4e21-42c3-a1b1-d07813b8b8b7@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D34E1C0017
X-Stat-Signature: qzshs5uk8aa9z5z8sw554z4hbzkq18y5
X-Rspam-User: 
X-HE-Tag: 1775743580-589881
X-HE-Meta: U2FsdGVkX1+JZVsbska0kC4792uk6nVhmWjoekvHfN2DoElXbjs29oTOIUaH0TJG8QTCENZvO1uUjVmzlUiIL5iJ/5BMirR/w3+wlIxEba1HolvIU/E9SvQLGMPyoOYQDmyoPjZFykZjGEmTjK17jQvETXaztpf/Gam2/Aew/wgeDrGpQBQdOzWvtF/fP/uw4TeeIjOCLsSLhhIonHDOWU5lmxlU6hHSk2dqk2BofCFO1XrC7xT/Sl8yWBAdTdSprVMFTegP0NpO4JjqdOst0cxMPkbhsKXMHkZPpeDr72QWby5A4bfmkUXS6t3bZiWikzIIe5eOWqB6iXe+l8irVk9iogk3CA/O7neEJ4gjaplXjs6xKwGOhwN7UNm3auSgROGEMS8Q7SW3bxAZuXuWLwVNUOoEmz/gFuRan6qV5KKTkS3USTwiZG22V3XSLRqIsGQgxhBaGjdF2f/29lnAS2cDqjlSu6YozYW3PCAxjsA9hQ93dF+saN9cmckt8XnO4JGusV1EMEWDArYbQlEjvGo6UDTb0Hr+VU5nz6ZUPh4jBRDcd/eJzyYapfn8iuPGO0Uq2Y+vQiChmi3LZvc25vFH0+rGZcfmG+MtyXtkYOAIORbDBYWaWhlhC25dbd0dZBJfdw8aAzNGrJ6FRENhooRE2hRveMBZzfidFkztoClYnk9siOLfBsWHhVTDH9rfnFSpG2GoT29ZaqJeyyK7c/MFZa9dGZVUE4vVLHwiYnclZHMeBjd+8KhFuy+/SL7xh2TtMv8pa0rc+a0ctRD4pXJ+fuK7hV8sM4nzfLL+AxN6GTRL1dZPUtpngmdle7zLbiAdHpDO8u3n6mGwzMhkHC7wlsCRJ53cZyMPR0L/7/0vwYHDNwU60QmJWOXqnF0drZoguSJIc5RG+TRZYUMMDxByROHDKgikS3Kmqt/f301Fl249vDFkh2nfhvu7nmtYwfZkncm/uN6+O7VC/7f
 dTn8KYzj
 NI4klzzwvnXqarxI6HWi+NFSf/Iv8xMV9KneQqi56eHZllls+QjfgLfqRvsqGcNxNSZFCZaBWubl1Z4vjyCutBDKnM5DUQsq6IRjFF5ALZ4brFxaWGdfL+V72he9A1ndG8aXDZTpZEzBuI6av4BgEBeitf2pTYIigKsOzEzho1fIqaV3V/L39VHJymz5f9jq7YP0YTA/dYE9MuJFXGE7lxB2wk1XWErSHjgpw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Apr 2026 15:20:10 +0800 "linruifeng (A)" <linruifeng4@huawei.com> wrote:

> Hello SJ，
> 
> Thank you for your reply. Based on my current knowledge, I think this can be
> described from three aspects:
> 
> 1、kdamond monitors physical/virtual addresses and performs certain 
> actions based
> on the monitoring results to improve system/process efficiency. When the 
> system
> undergoes suspend/resume, most user-space processes are in a suspended 
> state.
> kdamond may therefore perform operations such as PAGEOUT / 
> MADV_NOHUGEPAGE, but
> these are not true data monitoring results. This may cause changes in 
> the efficiency
> of certain processes after system resume. Therefore, I believe that 
> continuing to
> run kdamond during suspend is meaningless and may even have negative 
> effects.
> 
> 2、When performing hibernate, most of the used memory in the system is 
> swapped out to
> disk. When memory is large, this is time-consuming. If kdamond does not 
> sleep, it may
> affect hibernate efficiency.

Sounds making sense, but I'm failing at finding some specific problematic case
and expecting the real impact.  Can you share a concrete problematic scenario
example with an expectation of the impact?  Also, is this just a theoretical
concern?  Or, a real issue that you find from your real DAMON use case?  If
this is finding from a real use case, could you addd more details about the
observation?

> 
> 3、As discussed in [1]:

Seems you forgot adding a link?

> "The principal reason is to prevent filesystems 
> from being damaged
> after hibernation. At the moment we have no simple means of 
> checkpointing filesystems, so if
> there are any modifications made to filesystem data and/or metadata on 
> disks, we cannot bring
> them back to the state from before the modifications. At the same time 
> each hibernation image
> contains some filesystem-related information that must be consistent 
> with the state of the on
> disk data and metadata after the system memory state has been restored 
> from the image (otherwise
> the filesystems will be damaged in a nasty way, usually making them 
> almost impossible to repair).
> We therefore freeze tasks that might cause the on-disk filesystems' data 
> and metadata to be modified
> after the hibernation image has been created and before the system is 
> finally powered off. The majority
> of these are user space processes, but if any of the kernel threads may 
> cause something like this to
> happen, they have to be freezable." During suspend/resume, processes 
> involving I/O operations should
> be frozen.

But what file system changes DAMON could make?  Could you please add more
detailed scenarios and expectation or observation of the impact?

> 
> Based on the above reasons, I believe it is reasonable to support 
> freezing kdamond. If there are any
> errors in my thinking, please point them out.

I feel like it is reasonable but I'd love it more if there are more concrete
examples and/or observations that support this.


Thanks,
SJ

[...]

