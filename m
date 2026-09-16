Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17655C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE3B6B008C; Tue, 15 Sep 2026 22:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77EC6B0092; Tue, 15 Sep 2026 22:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BC66B0093; Tue, 15 Sep 2026 22:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7116B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:52:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F27B51405F0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:52:30 +0000 (UTC)
X-FDA: 85218102060.04.8DD99D5
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf30.hostedemail.com (Postfix) with ESMTP id E8FD880002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:52:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGKGQzfd;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789527149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlXbv7Ps1+ySvWOpSb2tddB3Ck/9lSM+T0+kjhXf4kc=;
	b=R3kTVf+M1Jz9vMkelaDDTAukbabOwE9gAMPWuzbVexVvirJf+RLSWyeiNvGih+fH+JFrQu
	l+DpY94iOlurf9WZSBUe42ZqKEv6MDY0zJSvquliatLh4b4FI3nL5WR/yNHRADYYGwiiMv
	jC3/jequAqYYdej8JMYr03x+kiWHF7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789527149;
	b=qNPqR9e6cnrKx8W2T/vqQl10l7rYC2/YYvQdY2JGI6IXcSCp8leZ9qXSXZ9pbdPKCY/iY4
	TrRDEPNgnm+36AkxDbXKsf6kmaF9rfjcwnalgfD0qFAG8GDZ+nWPOlofBax/46Hlt07kuZ
	dTqYeWka4mrgL6vfCxG7rHH1T/3T708=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGKGQzfd;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YGkbI/aBa2R7Sc4KMCjD1BQTq1E2F3Jsy4Klibs1hmI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789527144; v=1; x=1790131944;
 b=kGKGQzfdjxnWReDujphVixic95Cscec/qt4aAv0ge83Ycv6pSKHku0bpzM7w7IsiIzaT12b1
 gQ2GoXS+oVBp9KJ3KemfXoFgP/KBK43/ZIQEiL1QtO88C9oudr0ZmEQazxNPBEvlrCdIVQNCP08
 GmEILnsMtNIAnGpHX8FuwBKQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0282261fe3cbfd76;
	Wed, 16 Sep 2026 02:52:14 +0000
X-Mizu-Trace-ID: 0282261fe3cbfd76
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 10:52:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH v2 01/12] mm: xswap support for zswap
Message-ID: <aqoEVyxikqQ476IS@fedora>
References: <20260913075014.1732524-2-hebaoquan@kylinos.cn>
 <20260915100308.1599989-1-kunwu.chan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915100308.1599989-1-kunwu.chan@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kjo1j1jghqc6jkkjybgb5e87d9ffzfz4
X-Rspamd-Queue-Id: E8FD880002
X-HE-Tag: 1789527148-829375
X-HE-Meta: U2FsdGVkX19pqTjrQDbegvzOAd0aAjgLcw7m2eOraAAi/b29exQ0eqfCnHUnE+/SOhjirejK0E91jqwgyGBgi433nuulYtlDB0yrZIdXaugwYeOK9Ldk8PzPDq/FQy68PZs14MUExrpGZrtyypRTImOf22+UF55+9ypyzqg48aTKGeQpr4g+e69EH48qca8x5OnADmn7u0/kAa6Z6KMM9f2B+gfE+/TMTXVnZi9ThiBaiUmvaHMv087vMgrrw759vgsSDv+7U9jd4bYa2vkDzLS+w6i4TdHtMXzdoMui2TslbWeXfrdbEcwWwLYGaw2PEUE+dcbeJcabHt9lt7Ci4lQ4UTYq8Sxtq/VYvBnDfRoN+sRanPAtWzvcZ3C/HenNKwvj87CAmIDkRlWaSGqU7DRSQWpK0QFNxD4qlbdTuFKyfh7Gogy/2tKuv4HXJuFswc3w2/JBtqaLyDc92uZUasByKnf9wkVBSnILquFLJGdWEjRX2fPmdS8ijfM7gEN3C7hnoPUbp02oCz0MkLI45EAQGxJ92wpUA1RaTaAcvrXGhsQeWhngUtDgtyo1bLZpiYdFhoNKzNmm2pPKW8x+DUHLzUlRHq011akqrb4QwaZbTgQByzcG/UbMalZkZ/4HfH6bqOLtnLoUz3lAytNqKLZ9ZbzV93wm6Lz7BtO6SgYXH/AspABvDDRC5+o7U1hEf/31mXJX1Gal1i5yEBYxglHKW+dVUkdhTMklJfMiHwImWYBAmDMUrFbJ888osk+277yIao1XE9XIG8os2dObArJI0Mq3uzCJzdYAfD3WmhkHwFCH5LC03pdxfg+l0qJ1A5d+DToatUMFPLmC5SVHTgMKlgw84/aWM0fbgN4JIWMPjY82yTPLLY6v2jHMqn3nG9zxelgunIuxagWcUXsyvIyUqTWQSPVSoV8SlG7QW+HGv3xB4eW9WiCij7pDB6xDhVCN8qttsAGn/TNVJHk
 oAkPl+ul
 9+vDXgYgi3pkl9U3zlqfK7uVFYZzPU6cz/8fuR3dLsQelBM8gO6qbuq3Nu+IHtlb0/COS4uXy8N3j8ETvJ/hTXR42LA5C8Qs3QCaPivK9WPjFx101dkrmyfeRuZv+fn/pLRz8BxLQMsBC84nmaUmof5KbKAB04p1kthG2BhmZwfS7icD09SqeF6L5L6fMNNckaP0AU8CMD1UZjEF752Fg/YrBwGuks+54fODA2M5isrWIpoUIVQxuZHVQgpGWh2N1uUw6st8bBds7tJ1v9s0IuFcQi3GXwduC6JDsC2iY2aWUAAR/V4zRBI7Mb/ON7thouQIGRQrF4PNIImCQTLsA107DKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/26 at 06:03pm, Kunwu Chan wrote:
> On Sun, 13 Sep 2026 15:50:03 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:
...snip... 
> 
> The SWP_XSWAP flag and nr_real_swapfiles accounting look correct. The writeback guard 
> in page_io.c (both swap_writeout and swap_read_folio paths) properly short-circuits 
> xswap devices, and the zswap writeback gating on nr_real_swapfiles ensures writeback 
> only fires when a real swap device is active. 
> 
> No issues found.
> 
> Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks for careful reviewing. I will post v3 soon. I found this v2 is
based on a older commit of mm-unstable, and I forgot adding base-id, so
Sashiko reviewing is failed to launch. I have rebased this onto the
latest mm-new, hope Sashiko can be satisfied.


