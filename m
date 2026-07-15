Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B936CC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9886B0005; Tue, 14 Jul 2026 20:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679B46B0088; Tue, 14 Jul 2026 20:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541F96B008C; Tue, 14 Jul 2026 20:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B046B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:25:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FF86401E1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:25:49 +0000 (UTC)
X-FDA: 84989118018.18.89CAF55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1317240003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:25:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqWjcJza;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075148;
	b=1LXW/QodJpsVKWNtm5XCNTvGZXUMZlrLK505f9lNzz6lwOGVo1LYQQokJGbPDKVrUMC68x
	HXSptfC9c4vOiWL4iZP7HVOL0LfCWHcOgWdSiRDO4T13/Ro44QMnqy/boKQGMUpfvEPVd9
	KkuzIEDgANnHWD7ZMaZxUe9taMu51W8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqWjcJza;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53f5eW+C7l6xeH3yzd2fDO+7tk1iBkcC3ITRebguIpg=;
	b=8fayxiE33nsrRQeV/FNRfR6QD/qUAKYn0vvUTf03OKGfQNZiP5RdK5tHQoPPapjgZUG1jT
	ORcYgtN9pLRQ0OluW5l6htS5dZBIUNUVLT9dJu+nzoePFXAk7p9L3/fC7/VV7HR74/wADF
	cz5cbu0GqONomLSzOSMeefbbBEWcm+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFE4643819;
	Wed, 15 Jul 2026 00:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374F51F000E9;
	Wed, 15 Jul 2026 00:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784075146;
	bh=53f5eW+C7l6xeH3yzd2fDO+7tk1iBkcC3ITRebguIpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqWjcJza+Z2/82d3473NB3vUVWSxcIhLmoZPoA/HARxtKXw6LspGntZS6l5aJbYOl
	 aTYLsApwIglx6HbKfzjAl8pR1QvAEkqirNUi64CIYvQ3taEWlbFrDAsHs3TRmqBLuK
	 XMKIMJanpc9byQ/zhbR8WZwosxD2+wRY0zqZvqOU+iR1t0qLXAhmV9kWY+ypRRG2YF
	 MG5SeXsfYxAjFwA61WHO+rCpoqn2qxEFfjvVujYdoBSP+E2jOjE5Vm6qhwSnsRMBQO
	 2lp+flBkWAP6l3k/sMyibqQZ5JAMfgDKDtBK0wGA15ftVA8sXZFPQOkvZCsg80mq9S
	 lcfNNDGp4C6HQ==
From: SJ Park <sj@kernel.org>
To: xu.xin16@zte.com.cn
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	chengming.zhou@linux.dev,
	qi.zheng@linux.dev,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for mm_slot_lookup/insert
Date: Tue, 14 Jul 2026 17:25:43 -0700
Message-ID: <20260715002543.106162-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1317240003
X-Stat-Signature: bkuuqpm6zgdgcunbi1jg19tm9o38j97p
X-HE-Tag: 1784075147-375726
X-HE-Meta: U2FsdGVkX1/cIg6dFYwH13YoltAQrSQRyTmS0id6WF2blN/ImDXTKYhfI5ivvWeg5CR5B2g2mVtZS+LhguSwPKj9fCHdEUJj/VGjKLO2ZMm/tqA8HT3b2KBxrWMzJfV7ln8jFZIfA9gf13HLIEHq46OrFTVZmOxCyYUoYILlUgGYTo1sXDDnrCRhCIfnFg6DJ0EPq/NrKWTJQG2hlFAAOhqFLe3g2L3TKuAJUJ0RaIdvFG3cnq/kBOvLKla92/E0ZF1i12ifH8RhwkSoSPtRnr/eO7kMmL1xrZZ+p4Zp/Idjn27kEIGoXdhKHdrwQ/9ba8RhLE9LoZNUBZ+crOlVGue3az3VmVH5Oqdg3whre4XpePRKgD0ANat86z8v0C7ruonGXQWqdTbGOWITNb6DQf+JHsxy2H4FF3vbKn1rXUo2FUej6ZuN9e4VS18mUZQZ1g+1O25zF1PzWNFcPBFxG1hUdtnU3NsoDBKwz9GKr3WX9/1TnuiU6K2v35jkd7mWUwuzMzN+NZoER/Xb4bw+Ywb9u70gZsB2vSMJ43NnzZHlzoTdIUdrc3v9xTqQwhVknFHECpJGhc7wg0hCup2TzExInfwsgO8lC3ix1TsmKFTjJVsCyG7pPOjuFXeDfFAogevFuKW3T2O5L5hoGlyc5YfFhSMmK1HhfYQOXDntk442r5Gs+qVPYQI8utRfwnYWJmkIsk9/DMHo3cgr2HeINsaYNP/sGkalALJBWOin8dvW1jZPRKHiYQvxL5kbjhR3d73viToXW5vg/d/qmW5vejnklqcepX9+1LjG8yuaGA7eA6TcZOemZK9viU7ZRefOB7X2FRZetK25wIHmfMP6EUea9PPBh7h4+yZ3zaOB/8Ywi8eig0EYPB/8YrQaqyGzrH5pBQOmd5mABKJZwaiOH69LDQimsz4NDx31OhUwCzsIauOT+3rXmfsXW7uKZyrhGStyqVmPifTAKnnF1db
 LgiJCf36
 uTyaPdQI/emLdaBBuVchiSJyQvwSNrNk+zuQKb/jVKiRQUPccZispv0obFKNDQ0aHOsNAHKUY0CP9mMg5GfQO5pElcf0j2FYweWA+8iaYvs8/GTUeUaGLXkwZyNq5IWtQcAJyvodUaSWfXAusEGItntglEjVkXy0hlUFUTnpm/PeIvlOmveBrtmoqo3tOOtSEpwjY4983qeccvDTHZdsF8ChC431QEeyym28zq59O8tG8Mq1QdFzmWwBjwZI/fw+1Xei+yXQM5N0yFIfmZqFsHCfnT4n501U7BqoOD14erj6YETqAZQyypH8zlaySn2KT4TC5bO7i87p/cduglUEFBDVEtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 09:28:15 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> From: xu xin <xu.xin16@zte.com.cn>
> 
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
> 
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.

Thank you for adding the explanation!

> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

