Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A8F606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLncX2Zs
Received: by kanga.kvack.org (Postfix)
	id 1AADE6B05B0; Wed,  4 Nov 2026 20:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135606B05B1; Wed,  4 Nov 2026 20:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F5C6B05B2; Wed,  4 Nov 2026 20:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C46FB6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:37:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 429EE40907
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:37:08 +0000 (UTC)
X-FDA: 85399352136.08.FCC17E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A29B0180004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:37:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLncX2Zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793842626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA2+HfHYPMGCbmJQui3IKYKhygxU8H4CQyQtWKnvlr0=;
	b=UkjBxBOlUAEzpYhr4mywbnEeoJmPfYP8w55KQQs7hymjAErnypCYMvaPJu2BXCqkrrSZto
	A7HwEn0QJX5uQIPnOPG0lGjpTywg2QgMMnzpC7T6DfQPzzoWIsSNOg074pUQetcYhA/hGY
	eWqZltfT6mwVOdwRWCiA+S/cyzt+S5M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLncX2Zs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793842626;
	b=mwY2S5kaoPUU3LKC9d+BnJKWOf5uG20ZDAtfGmYyFv24YDwpt4fU1atGu6ObncMiyTYxaw
	8+AkwDCNHzgsZm9fJJ4LVxK8j+8GbgGOfrFW+wUPfAX4G2kcB5jRCRWpSDcyHcudgggI6F
	M4FU00UgYSDd0G0JWN+uzD0QDL9cDIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0B2742D8B;
	Thu,  5 Nov 2026 01:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4927F1F000C1;
	Thu,  5 Nov 2026 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793842625;
	bh=SA2+HfHYPMGCbmJQui3IKYKhygxU8H4CQyQtWKnvlr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLncX2Zs+2hBT1JWu+JG2f41a2GOjtb8ZMj/7XZz90p/SDCrpc6hRRabv19xKgK1e
	 90653Of7K/ZKdrCGmc/IpfESzxbWX/UPClFz605D6Wtg0Qw81+D2+8d+exoFHNzkjx
	 Q+nxPajPLOQRe/an1SJIlnOMNwuy98DfPnaw+WEhgjhqVXCjulg3OGZ4hFyLWoBf1F
	 4ikp1s+NBR17wwsL5/iEI8V0Tu8blmOXU9vBPo5ds+Soi1p+sdS+G7RkqAE/E4eB91
	 o8pV8kLqamj/HaSn2pp/HN9NA4uNvExfeubP/nBnhX7qE2tcsLGWaYYm3lDxBUHRDt
	 SAFdcAXtw8M1g==
From: SJ Park <sj@kernel.org>
To: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	jm5905938@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals on scheme commit
Date: Wed,  4 Nov 2026 17:36:51 -0800
Message-ID: <20261105013653.88123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9bb64032-09ce-4ddf-81cb-206bb85b9be3@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A29B0180004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nm34u6e3roj668n56dup8d5jnz3wzctb
X-HE-Tag: 1793842626-927140
X-HE-Meta: U2FsdGVkX18ZohC1O6MLg8sICh3BbPm1zSPSNikENV88bGGv/Oa9ME8BXt1zkioZEJ1H8v00GqBxpbIhYWOv2lDlzNJqL36OPz+AOm8rJ/Lqhz5skK7LkZF2iwFtqGTbXZEing2TYSMQktr4CqgxdjCSidReAvfU69rdgpyliGOBUjSMU/tGYrez8nSvNPGKSGnFSwRv3K40FTnflvcmFGPwqSCl+7U8cN60ARcOF6bRm8jUJ1wQEa65nR/vIHltgh1KX8mstMpSGzuUuSxpyLOx87CgFkUvTNm8/B74T5cR94fj2YV3hyS1+feLurzkP8pQeCRQPgGX/GAwHndtjbyYHbATTnzGZfqP55tE88865Txhkv58LyEhn18r1WbjenftbfMxXhDsJVNgTPTJayMr9kJMzKGukY3hmrS5nRDqeZfMTkRfP9jRzK4n79Tbtk2PyJ10hoViwl5dIfy5HzkLMaxFVVWvlATa75qe8Zo7XKzbbkDY9z+eRExMIbqqaSZhbaxvPecu9mCPQX2zMg09MlZ4Lp3RAKEwWJ6nAwdvWk5GfTwXdWdkxn7g4/DGRyKNZS1ExWrUvCJ4qPsxH2/2PVMY8vkU1158AwK3/wxkAqjtB9FDnbgJo5WtSGB+6K4VRyrNQ81J/cSOzYZVn+pPWKNWHTa6qeExc9B5NF2kpWQ/9+bvLxdceHmdzkTpA0VCHsAaKfLKv3pufCrtD3BZ1dx7NEabZLsy5G0tgYCNEbR3vMMrFADbdT7MgqfGP7zwH8m0zADGvwpGMQwne9LDQk1DKJzGRVTk8xQAI0QQ52uZQUj+3wV+2EMeZjoyPzy13CWq/Dv7q45BwAh7ULb3BVX1Mr/KIFWYIXXAv/kRs38CJ1ydPmcB0P52mX+b5VDahRoBH9edFQHkHBte8L1Ie0qnbSl/tpZL5fgreeOBKyjNf9LcpFu1mn5Cvq71dbv6aa2dKb2zU+iJ4o4
 9wmtULvk
 Gv87t/LNIycwl6y4yTcMb7aM2cfhxuabdVVNWuciUShhv2oBWHXkpiHVDTJSaUa48aK4KZKpL2JzWrpnXsoxaTdBfb5fUoDgmnNyau39Y4Le/w6S6ctZsgDmCSr56hnacqvpPQZXVJanCXHuph4H5sUVyRVwO/a6SWBLr8Ng/zLFEUvC5uRQk/IDrtQhZi7TrPOtUZjp1kdfpAPcHj2FAglWg11ocFHAgPaO/mPJYviAnL5rai3fIx286ytzQSL8X6Yk/W4NOSCpppB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 09:17:24 +0800 Wang Xiaolei <xiaoleiwangxiaolei@gmail.com> wrote:

> Hi SeongJae and Aveline
> 
>   Thank you both for the careful review.
> 
> I appreciate the clarification that DAMON simply executes what
> 
>   the user configured, and that this is more of an input validation
> 
> improvement than a bug fix. Perhaps I was too aggressive in framing
> 
> it as a bug.

Thank you for clarifying.  But my point is that this change might be just
unnecessary behavior change rather than an improvement.  What do you think?


Thanks,
SJ

[...]

