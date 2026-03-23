Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E371EC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE456B0088; Mon, 23 Mar 2026 04:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FDD6B0089; Mon, 23 Mar 2026 04:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E6A6B008A; Mon, 23 Mar 2026 04:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 452976B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:52:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D94191EB12
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:52:57 +0000 (UTC)
X-FDA: 84576712794.01.0405632
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13FEB120004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:52:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DIpa/29n";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774255976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LZVrE4F3IF8H6xX1BAnZQKv8f64W/xMvCvHGs/VoQU=;
	b=2hRpXh/BXLB6ebFUbQU37AfLnzqwI40j62BxYB76wgvAqmlCh1erXHQYP37hBr5z0juAUb
	PuNqE+nRPi9oYcq0NXN+XwJL2ShJ11s4vT3X4y0wYCj3WNhLDgYTG9z1zdnlc5MPHMOrk3
	MABmNexaw9DMBg+tc6OkP75PK5P2fzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774255976; a=rsa-sha256;
	cv=none;
	b=6TW35zQsNSF/H1FzwvVlmphE1lGSuXLmo/lcCI0iJh8v8njlqIdC8MAWuBTPS4pq9VCDsw
	VdeMIyMcDAGKZA/r7ALa0gusN5g67AfcnxsMp1zYhisHX9RBKszoSGbqazyf/xFoaSKe3x
	tqe/sb8W93bIcVvBDFylnKhVg25avrk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DIpa/29n";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C27AC440F5;
	Mon, 23 Mar 2026 08:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2163C4CEF7;
	Mon, 23 Mar 2026 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774255974;
	bh=18UNDQsNpgLSTLWrKvwWo9FGvRTyO6v+NbBTHbWYc94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DIpa/29nm6gKgiX0JR5l1fSr+4WLTLNlV+vp0JOijF7w2QMsywxrRm51PtA71RPdH
	 iRozO/6diEgBMkm0iSflndMafaIvWelDIHs7fSM9FeMcfq3HDOvWXfjnyYHqu0Zu+H
	 ezv7jBMdL4v8nFykw/RRnfstkdfs19L05nDIIZUWgU7LzGv3dzGASqFGBVlVNBdLnx
	 Ag4xTVczGtpHyWfKlLgiv03iEySdUSFwc87wV+5gUEXBwDcjmDnwhzpwG4f94L0dlU
	 t+pb8klOd65pEeGikxrSQv/kSk7lXSjxoLeHeg94IqYeD5v1irBp7iJcQWRFnTEU1n
	 gbpe4coF/ovvg==
Message-ID: <a0dd1a23-1114-4cb1-87b2-c2f2f5195c0d@kernel.org>
Date: Mon, 23 Mar 2026 09:52:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: fix stale reference to
 memory_block_add_nid()
To: Kexin Sun <kexinsun@smail.nju.edu.cn>, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg,
 ratnadiraw@smu.edu.sg
References: <20260321105704.6093-1-kexinsun@smail.nju.edu.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321105704.6093-1-kexinsun@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13FEB120004
X-Stat-Signature: ggzazbd4copat59i467bqjhnfqh3nunu
X-HE-Tag: 1774255975-807465
X-HE-Meta: U2FsdGVkX182bFtfzKFuzXKVZTMtrPhLvp+tbHFbhG1KGMc+J/hjUReUmeyq6Ce8DLsKRgwUKXqMoDNqoR/R8+u15hmgqY6y58dHpZhxPtn5+DKXWanezgmvjDt5IER5ngoP8/dZV7C8i5XToTtISAi27Sv3eDokxeKi3yAs70B/GZv+uWgtaJ1GBuqdMfQmPTX1OxMUCNjiSZadYiK4ExwCEwP1CmSBFJA4aSe003OlxBn+r/5+WN7VFRJDhq07qjdfNHe7xqmeZMVbKSNDbztNdB3ReFcTftZ6NIIO4QXXd3ItDjSk1Du2mA7HuoijVTxZ4ng6296VF2tpQBItMi37S235aQj5OLICJHvEtuYmT6LgNdPjb08u4/JZiFfhvF8CGgY6qn0zXA9Uh8hw59lQyfupQvQ8fvUvKvMUYFf/eiiZtAfVw7+lNqt6tPxPt/8FdAwwM/XP3qlBKiufED4ffe1r9o7w+2WsNOtN6Wfe012eVg06UWGabbc8mfNbPxWdnkaueWgQQ0NAao7M8PnW2WjLTRneABWZ2lhXtxhhJ17+1oernw7m8mTWW7r5NoUAplYApeOvI21vRx2ARyV67fSvysVohTVDTqX1vGEmIHUATHE4QMqvbgl/6LNFwCN3aBWMngqXhiEevEYmBT1ZoFY3hdYGmdA20jqrVqBDNI5WBX1C7KZKuznaOoiJtFgzLXDScOiCTlt/8fKuYQB5z8q/ROHgl5Mriy16T2C3wS3mqXtvYwYDzh3mqpyH6wg90Y3q2Qt79Hk3FA8bZpKb0egOHwiQKIreqDQktT/EpVpfBwN9qzHsLlAD/yFNVW2lBeKqQfiS73MWqrWm4dhMP32Tfr4nevL5gMCHfIBzIAZEttkdqMqEnIP7eEcM4rudvsZfhhJOZbksiepEtbF8TH5K6VQ9l2jH6kmFk57urGj60J14oaLCuUh2o2aGjzEr+G4jbybGXb+yDpJ
 BDo/AXiL
 M07hYa0VjiF7vBTEHeSv38ZWoNWMEM1LX85axqQ3g6orfclUwig306Zwi+vxBmusf0Af/Ihj2VAoaTzOk0Qbh3LxOd+cRjug8/Pm3gDtua3ySnlVIHDH0Ctg+xwSKNnQzdKHsQZ13FvfedMlxhoq8DlbIvltFKCDn4cjrPQkCWSNnKed6iYywGb2lEz04MIL2U/ewNPPOuABdTtRW7jlTCzlWe/DpkTjKegDHFUz88l+3F7BAVkMFzDoT9zgsGQnX4LEu0tQpuRpHNHH3SZHAcoQr07iBGAUV/VJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 11:57, Kexin Sun wrote:
> The function memory_block_add_nid() was renamed to
> memory_block_add_nid_early() by commit 0a947c14e48c
> ("drivers/base: move memory_block_add_nid() into the
> caller").  Update the stale reference in add_memory_block().
> 
> Assisted-by: unnamed:deepseek-v3.2 coccinelle

I'm sure that patch was impossible to craft without an LLM. ;)

> Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

