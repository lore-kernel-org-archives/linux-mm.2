Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB45ECCF2C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 21:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798CF6B0088; Fri, 16 Oct 2026 17:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749F86B008A; Fri, 16 Oct 2026 17:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667026B008C; Fri, 16 Oct 2026 17:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 437B86B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:28:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD0D61C1115
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:28:27 +0000 (UTC)
X-FDA: 85329778254.20.52629EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CD1FC0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhK5CACk;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792186106;
	b=rGy4ZaUSWu9CBcIOOthMOoEWoDQzJPpRis0XoU5403gBt58zgOxgc0Q6JZGSgB4zdkd/dT
	Z0r08uz8w4N7HbNOXE3swPuYcMku1tkEY0EPtMgj6r3YFk5fnhs6iWuTKMBNxo6IQgPH3U
	owJoy//NNoihHayJIPFErTJeV3LNDeQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhK5CACk;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792186106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=YL8v3ikz/W8u+Qt9X03/iAXSAmcRvygnsgXdC5kGQwQ=;
	b=AQfzAlw+e+A57wDxnF9SHu45Oy00Fc+9ASVoEGwAIKT3CYIZ2A/ZJ93OWfbJb1hnAeP1xf
	xEuc2E5lQSF4sWlae5ekkQmYEsXCKdEPgZVLXLcMzxQMxops8MZJo42BrBqHHfrzZPDz+o
	THn5qWRgi2FCLgwO2gFEn9Q8j1cWI0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B6C2418A7;
	Fri, 16 Oct 2026 21:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F8E1F000C4;
	Fri, 16 Oct 2026 21:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792186105;
	bh=YL8v3ikz/W8u+Qt9X03/iAXSAmcRvygnsgXdC5kGQwQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bhK5CACkCHQDF66EDC8C2pABK4CFbYwJawdxJRRT3/v6QK1aLVKO+9lIN7vy4Z2pA
	 PQpGUx1JRAQOh4Sk1x98fZuPu7U3alrLDAMglVo077+b7R3JWIHvvtrnagJXXVSDgP
	 zNmSiXjqu4MWnj+UDkMBE/ZNGCY974pVR9pOccNupA4QGF8KKo3F777YSClX1cNHF6
	 ekKkbFdHbFpcZWn4mzly4QAn52eanzAZ+cu7su5MG3XFiK37Wg+SgjX9lHsez7fqO/
	 K87QMoeOKB4hqBGKX16vjjWoLNfRoR63BJAf7rG3xAQxjOAZepRXSWVTIlho1A2+lt
	 OIa1G1c5NFUIg==
Date: Fri, 16 Oct 2026 11:28:24 -1000
Message-ID: <29b280c82730b879e5f3ccdb35639ead@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ian@honeycomb.io
Subject: Re: [PATCH] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
In-Reply-To: <20261015114307.1041273-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3CD1FC0003
X-Rspam-User: 
X-Stat-Signature: 17b4ji6j1iw8tz1tbg5ez37admiemap4
X-HE-Tag: 1792186106-360971
X-HE-Meta: U2FsdGVkX1+WDn1vLSY3Jcnh3hXJ1hNrEXCDAZXv10LylX7NF92I97D3p8aRtfEhbgU7g6avzrjaO9BwB1Fqiw7Cpjeugz0I+b1kta8jyS8ufSrdV5eSkMFE7lxte827NwA1yaLD/WiV771UAUajMsay4p0c3tgXDbNCqe2aw1YxKG9yK/9uk2T6vM2vHHAW2JR1xCR6vsQGrfaV+pmSYJEaIKwsU5vXG+YGo4G6qTjZRAcJexBALgHyEbipR4FGwzGhzJEWCrN80ffMnPrBsvUJaUgoL7H9ODgjuvgH08b1lL14qc8nJc7HHmtLkSGPC46VEKUKzUOwGmA6z1uxrAPi3j44JPYZSKoHOfhFOiBGmROy5jSshm3gDWeKdWB8KYN86wAJc6zK8vJcOPty0UDDKo6cEvsSVP2Hd5voWCcRiTpRY1rhVjx6p/ZWU2Xy4mUwF5oH10gAzjRnyOzdBheA/iTA9/Lf6MOZC8+eyIA8PXQEGQv5ochkvRCTx5HNA/Y4emfVuil8A7R7M+n1oDrPr0mBRlR00y+wxl/9qWoyGVtER5u1EQZwAfbAVTvKBvquQFQTAA78Z+ldEGNKkn0VPstjGJmmZ76Rezd70trZnsSRM9TnBmVWTpfsxEIDH8DSGRV3RZC4eN1KiaWffV74j0Sh969CT/SFZH6cjWBYl3w97glGiWk+EvhUUR1dofr/lBk0GM1jrZBRphsiU+h3bDsYxcvRvnSiOEOHg8Mly44srZBWMNRMawt9PcsCfDYndoSvQL31g/KubRwOJFkkSRf44NCwdYMJ8TUqpYgGuyQr41oEDZegTSrjbjrou37QmNPrSVPbRNd3v0obXjGsEj3usQOY0LT8FPIde8nNvFSpn0KjIBJhgNIyP/nhAqNNtEiSPPA2HBgCJuGQMzAkUgTsD+zpMqr/VyxWJprTBf14bY+xjayjZjy2p8KXLznkkiCxakf5Et16T1G
 bSXAKQ3a
 XV0fAvjXkWVXRHcia6DvK3lX4MliQBfxqgEi6kdAT4q+ocex5DxhQD+ZX01yLHs/Ra/8nvzx2TCgpAkHR9TaAJoTTQcJ3mbGvyvp3QGYv00W6xNYDDI2ULe8dcn+GXY0pnpnsJ9yw9/f2TbB36CLUUB9Tmc1ZVJcXGraTRCD8p9CDtrtk4IBAZl3aZ52M1oioAhIQYXXxH8s63QbT6IWPKSa7zsAX6olONunLv5rR1IS+doNTho1oqqK4WzIqEV5Tg58jQ95cTyHxENsudlHJweY8/L8TVY/zFzmwQ4ngxray3v0lhj1KwIpx+GvNQPS2Z/sRc9hL2/C2M6v8wBgkP+QPnSlQG2d96zntAggIOAmo498so6u6/ckg6FQT9sXRUh852MPvBVl3ELQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Thu, Oct 15, 2026 at 11:43:09AM +0000, Liz Fong-Jones wrote:
> Trigger: a wb has lazytime-dirty inodes on b_dirty_time when a sync
> starts, an inode on it gets a timestamp update after the sync's cutoff,
> and then its memcg (or, if the wb is already dying, any memcg) is
> removed, which runs cleanup_offline_cgwb() on it before the sync work
> queues inodes.

The late inode has to be one without a pending lazytime update. One
already on b_dirty_time keeps its position and dirtied_when.

cleanup_offline_cgwbs_workfn() skips wbs with anything on b_dirty, b_io
or b_more_io. So the scan has to land between wb_writeback() fixing
dirtied_before and taking list_lock for the first queue_io(), which is a
few instructions. The exception is a multi-pass drain that started
before the wb got dirty IO, as the loop doesn't recheck. Maybe say that
the window is narrow so that stable can weigh it?

> Once an isw fills before the scan reaches a newer inode, or a later pass
> walks past it, older inodes land in front of it on b_dirty_time.

A pass keeps the inodes it walks in order, so the only reordering is
between the walked inodes and the ones a filled pass didn't reach. "or a
later pass walks past it" doesn't seem to be a separate case.

> Tejun spotted this reordering racing with a sync on b_dirty in a patch
> under review and suggested holding wb_switch_rwsem for read across that
> scan [1]. cleanup_offline_cgwb()'s scan of b_dirty_time needs the same.

The description is pretty long for a six-line fix. Maybe drop this
paragraph, which Suggested-by and Link already cover, move the test
details below ---, and tighten the rest?

> +	/*
> +	 * The scan reorders b_dirty_time.  Keep it out of a sync's way, which
> +	 * could otherwise miss timestamps moved past its cutoff.
> +	 */

The inodes' dirtied_when doesn't change. What moves is their list
position. Maybe something like:

	/*
	 * The scan moves walked inodes to the newest end of b_dirty_time,
	 * past ones it didn't reach. If one of those was dirtied after a
	 * sync's cutoff, the sync's queue_io() stops there and misses the
	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
	 */

None of the above is blocking.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

