Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D611AC982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C716B0088; Sun, 20 Sep 2026 08:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD116B008A; Sun, 20 Sep 2026 08:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BCEB6B008C; Sun, 20 Sep 2026 08:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2476B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:20:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C3EC80431
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:20:41 +0000 (UTC)
X-FDA: 85234049082.12.1DB3D39
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id E0E244000A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:20:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oaUD7Rdy;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789906839;
	b=B+E+Ahae6ivm12L2gjIk5znjB48lQlky39XabsTDp/sStLG5VN+sZD45iMqfo5EjT09gOY
	4qTnwuYvxiMMLiSYhrmiMh6YuT+N6Dagzq2J8Nff5fyBlpevmDXXvkSvPIgEWbg6MXm/w8
	6SU5BDiMctAjCI+Y+a8cueYaLNOPPkw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oaUD7Rdy;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789906839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOMKVBKBfUL6Eqo1C/LC7lB1eE674NCOqBy+dNKmAd0=;
	b=BabEu5pZQdGGyfbkDepayBLoUQnnUa7QDbHV6ixpErf9SYcdYC75cKVQ4jxCiovqcPT2TM
	dNb36Oy7y5UvGoBhST7dCQmVdYpd3hXsi2ebaXe7LDlq3WF/T5Zc5VPADERNBem814HYHw
	+C5pOaNV2TMqicND4ncb/j1psK/1VcA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mOMKVBKBfUL6Eqo1C/LC7lB1eE674NCOqBy+dNKmAd0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789906834; v=1; x=1790511634;
 b=oaUD7RdyLK32CNLCjj2ZekgwNiO8e8L/LKzBHb0wLwRSaqG80AM9quK0nQHFYR7p7HKRz/zr
 xR91qp6UoNMJG09XRZJJvpYL5JIkYKHmE5x8ozk/m0BRkxS7ltG/iZSQXFTDqfLxksVLQ0dgClh
 BmhEHL/10+9Fjwp5So1vnTuw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cca487d333b8b0d5;
	Sun, 20 Sep 2026 12:20:34 +0000
X-Mizu-Trace-ID: cca487d333b8b0d5
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	pfalcato@suse.de,
	riel@surriel.com,
	harry@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/vma: const-ify vma_assert_stabilised() and associated functions
Date: Sun, 20 Sep 2026 20:20:27 +0800
Message-ID: <20260920122027.8234-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
References: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0E244000A
X-Stat-Signature: mxuhzyr5bt8zgaw4ss4xei6p955jyedp
X-Rspam-User: 
X-HE-Tag: 1789906837-578078
X-HE-Meta: U2FsdGVkX1+LK4qclsMsHuASowMVpZwfqAorfIXvLalYop740R0nrbannYikm5gG60mAoMtYzp6p1K0SByJLXpF/dtIe8yaVKpXRtc5pG8UQsHsg5Ns091Q8V8Pma/F3RTugnWHnlJReo9AyGc3I3kkClr6PwBSEbNK3lPvwnytoHcVnb8W+yYm/ezXmjyyJR3bTN2ZDDwD/kuERdj6hBbJsxWNfZ+l5KjuVzi4XzIoSfNrL6QguP8y/rzhA893KGlO5I9ae+puxHrb+ghpGY32vnbTY1Dy5543dN/kUDloahWOMP86sHPvcwSn754UwZvaGhIPaBxLmCVOeJHscoagDflMIxLI69C31u2AMCuddMA4FebpMXU/j2c5SNUAirODc7ZHNdWCiRmnZUzZzZkd0RsAxh1dUNbqYmi+EoWSbNFLEhkT2oRifEKup2O0+7bI/bAHhalGeRMU3JyBAZVD8bWojPMhPDyaPHqtRCZ0hSMNWbtkOrrchutr9h5d/9Hjtxm2GrqFVnTDswVbAegexCfysiQCV/cHpk4PEDX6gv1DZRV+i0m2nBUIf9q/MJx91OUISMT5AHzedJ5bc6P6JBn4ClbI7rbPIaurjEVf9mFfXwlHvSf1Dc6BIEOw+KFpfVSgObXtmOQadbUezlMyXiCiuDWbk6QRovVr9FfenxXmXTAtnIeeTD6SKBeQV9qFlsHywjdfmn0B87pFnrsbEKjjLbo2NCjKn0QOIMmimBDe87ojby6FuOWWK0lYWzKmxXtH0ZM2/NlBL7Uv90LRb5+vbcIiDGUCL1fmPC8OBcPvOZmowq940kZZKF2sQHGe4gUWyVZht3t619BEVaxRLZhZIGnVmusWKqO8q+ksPk5O9oZLtZ60LhffFGXfmU/pm3amJRObDSxmtTjey968r0V2b6/WkapMvFDjEY4bOeKhZU8KOCrO4QNc3zXcYI9kjEnAdUK3jMuM0gPW
 8eGjVNae
 Rk2gC1toOBtnFmHNeKUp4qUWcodJJaCERZ9eL4lsx+LtL6m4oSL7LRzN54Q3ssRaSSvIT9OeIpEFFrstAA/4sC8VW2uNcONJxk95q5S/Q8fS9gXrkeEE+iutw5vU4a5MyErEScFNfGNJ1INCz/gJszT9J8AgMrnykmOYtrENTa6pMwWBE7IdLbiNcqOz2s879pMoQuakgJ3bmp7KSFCfG5bsIiHq+tgxtMsyWBkoAjcYVviDw2s37HXUtpg9KDyO4CLJxIep9isPDkMOgpC4SioI3yA3QPMRAw11SJjO3yx+vlkw0e1aarBbb3j+euloCookM2K0V3LZ5HqmVpCSE0LdudMglVv22es/CaP7nvBHxIcy3u11XqflnljdAQSeJFCcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 08:47:41PM +0100, Lorenzo Stoakes (ARM) wrote:
>The vma pointers are not modified in any of these functions so make it
>official by const-ify them.
>
>Propagate this throughout the call stack.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

