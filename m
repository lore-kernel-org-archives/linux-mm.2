Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA8F10A88FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF81D6B0088; Thu, 26 Mar 2026 14:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9316B0089; Thu, 26 Mar 2026 14:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BEB36B008A; Thu, 26 Mar 2026 14:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3516B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:22:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38BBA13C168
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:22:05 +0000 (UTC)
X-FDA: 84589033410.27.F3F11B4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36C0EC0015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:22:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XIlwPLqA;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774549323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2NCU4uykscWRD1sM4fvveSE6frF1GrPo7z442+61WY=;
	b=VoSt047EOIonwEqY46c+10p02HJHDyE4hmGaWhvKYYn7E20rfnyeIjXycD58fUEhJ0nzbi
	toGG1o+k566AsenrCHC19uLdoJ6JRU6Fo6xsLNlOCRQWsRtuP2zaK4guWDSNGphURAIidJ
	biYoFzaUm66XxpieirLdiQaUoPooouQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774549323; a=rsa-sha256;
	cv=none;
	b=lM/idcqfElquwLLzSNjENWyhcVzjt1PIg5n0U7ZfkpfgerRPRo78J5dkYYRgcLXEPJFaA7
	1czFI4siHFSCGmH+1yXSJNTTdf6neC27zxxrYFhpowUQS9YUQhXHbs9nWSHjbVEhHDaj6K
	ufSGl9BXToeWtaFPbNvIIu1WHod8u2U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XIlwPLqA;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 26 Mar 2026 11:21:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774549320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E2NCU4uykscWRD1sM4fvveSE6frF1GrPo7z442+61WY=;
	b=XIlwPLqAxSnVEZ5NKymCtuPS5yNb5S+yyBfPCsHHWs0WwI5SWGWCvZcgdDwjrq/tIzPyrn
	2NO5NMIiyWB0G8Ibj+l/ZkotaMqEO8HXPIk6cDDEE5bF+uZsJeYXSG3NzzLVy0PFd/kL8w
	tCW97Wdko+vK86sQq7FYQBArnDXY5/o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acV39ErpINby9rpn@linux.dev>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <acTcStxrTCWAN6Dt@tiehlicka>
 <acUzMdxCDfbuyv9J@linux.dev>
 <acVPlB1Y8IR-RKCg@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acVPlB1Y8IR-RKCg@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 36C0EC0015
X-Stat-Signature: gwzdshdrqx9gaabsfziygagekkfxagen
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774549322-602561
X-HE-Meta: U2FsdGVkX1+tNFvvRSKsL3QewdNAf3PZsofWj4epxfWPgZM3b0svm/lOjtmq6jpCOkYbIrAYNtjKM7/M0mjblbXUCrNKEkPFZLfuFabbFlVy2U+YG2z9WepyiiDovLHnWZaLRuBy029fCf692tK7eeoz9BhvbVGhSos7HUxopBcqagc8FwqtpOl5ZJE5ZcGipeFK0XBrWT9VKfjCG7nFqO1RcU1L3b0sPgHp/RPBAkfgOQZ34QxWGmnJxCm2Prxs46NWN6+MxnCgWBQxQJvq4FFZIDiq5dHqJVgYbYZtXHIPwRsurDabUuqeFTsyQqIdXfJZnqmFiIfAr0yihUjE2WCWm21CZ0sOeMz3dQNjUZnHAwsCsP+psjjkV7rLP0KQWhYnG5xyKwEul0/obcib38hLXBgrcvo7BoOC8jwTpIp6OuFsvlTT/QLFvFdIU73Arly93u8eaa2vW2oWGPbTYJkl43WObZW1jy9XpiR+c2ytgOUC3NCYGSLvb7NEoThrAC/d9zDa1LrCvsu9U6GMxo6ztHsaaRVnkZAVqbldjmAxFP3QBYjJygc3AFiiazwPCd9JyPVRy+r918HtQAgzmGcKbCgGXXzVi2g/iiFxCFIHPexlGGNvqB/xPlq2UG759rG0VZyJF0jqbIEW6Vpopqf2hu2jf+K0QStSG7sSGW4wrISMWSx8SMp9Yv/DP9Ojwtq4+syojLjK3HZS1sOob5i4hAPFCyys/3iIaJnCnCO+xzv5HsP8u5YCC4KaWnaUIJlRSTNuIDCQrAKrGg4M+DFlKaW4V8AQdUu7CU84EbpgxyUftCManc4pE5LtNsaWcN4SsNlrrHWDLGDD3HX32fcS6jSzOAFK3lJlnEUgr1cTFEP2NxTb/mCYUWgT5L8tpp+0TvoXtrLWjUB/l6+k60nR+nsniz/SL+XbGZR2/jMa1BB4upbgzKs8N6G4GKPVFENqNvRbYalYdC7K90W
 J9zt4XQ1
 8nFAnRaSN/7U6ONiBFwuF9XwjKG1kOtCBrsesG+QHdmHmuEtoWZaTDr8t8B0rgKjiROMBC+vOAVlD3n+ZBb0SZ0wkbGFl5yDTbZ0U3Eivaf/eW3/4nPBGoRKtjpreW620E5NZ4ZG0Sa2EyLCpWdiFMojnZxIjwEAMsIY/tqNzEVWOLrT0iJF57FaVRV/hBVQxqvZzABE8FidPKti6gN2TxZdiAn38M51Ir+pY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 04:24:04PM +0100, Michal Hocko wrote:
> On Thu 26-03-26 06:44:07, Shakeel Butt wrote:
> > On Thu, Mar 26, 2026 at 08:12:10AM +0100, Michal Hocko wrote:
> > > On Wed 25-03-26 14:06:37, Shakeel Butt wrote:
> [...]
> > > I think we should focus to make a single canonical reclaim
> > > implementation work well. I.e. we deal with most (or ideally all) known
> > > regressions of MGLRU. 
> > 
> > Here we disagree on the approach or steps to reach the single canonical reclaim
> > implementation. MGLRU is a plethora of different mechanisms and policies and it
> > never went through rigorous evaluation for each of those mechanisms and
> > policies individually. To me that needs to be done to have one solution. 
> 
> If my recollection is correct from the LSFMM (2022) there was a promise that
> MGLRU architecture should allow to add extension and eventually
> supersede traditional LRU. If we do not see that happening then we
> should re-evaluate current MGRLU approach. I do not think we want to
> build reclaim_ext architecture on top of the current code. Or are you
> suggesting to achieve MGLRU through reclaim_ext?

My main objective is to unify the reclaim i.e. one reclaim algorithm/mechanism
and then (later) provide a framework where folks/kernel-engs/researchers can
experiment with new techniques/algorithms without changing the core reclaim.

Regarding MGLRU, after unification something from MGLRU remains which does not
makes sense to put in the core reclaim, that can be provided through the
framework. For reclaim_ext, I just like the name, looks fancy :).

