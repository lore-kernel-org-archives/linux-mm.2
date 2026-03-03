Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E2DEDEBF0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055506B0005; Tue,  3 Mar 2026 16:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C6B6B0088; Tue,  3 Mar 2026 16:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5236B0089; Tue,  3 Mar 2026 16:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D85496B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:12:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 829CB1B7543
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:12:17 +0000 (UTC)
X-FDA: 84505999914.13.6E39961
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id C08D41C0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:12:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=BKha0jO4;
	spf=pass (imf21.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772572335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZetZJNjR70T/LFjqoXtayWjEQgG9hfstgIaETdeEKA=;
	b=bJa9gginwWuhoSK7BXSjnBG+T4t7gc5lOrQaVwsUjw7Po6TKL2nrd6Uy1rbt5mFLhLVyPy
	KC48YnEbFEdNWjYsM8J73BhDYmxpGO8CHSN2pYbfwhu/TYyEf/SOUypPkojjGVPO5Ka5ik
	pwAVXTMIjCugBD+VcginctucbUwIsuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=BKha0jO4;
	spf=pass (imf21.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772572335; a=rsa-sha256;
	cv=none;
	b=o9fuQVnKkrKmL/t0qz5MaXo9PjUQ4kCn6KGP3cw3ryxTZMOpxj2WdKY5oRrifysqzJEalG
	hujpp5kzM5eVchEP0MjoqVTAl3VRdYMisoyaYzbwl2DV/VMhtiPmfIMNbEzQ6vKzMFacES
	PNEDezuo6vJ4We2obO6E6B4wQGxmbkg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gZetZJNjR70T/LFjqoXtayWjEQgG9hfstgIaETdeEKA=;
	t=1772572335; x=1773781935; b=BKha0jO4EkRxoXf04+rg3fxJSdQlx0YsCiBy9OgPmPj8pO0
	+39BNSIw+Wx9ZJIq6vIWsTC85zayBIZkZe1sZnQ9TBOahbrveMrh6+2UcnfDE7VN9362joQ1e9MfB
	7BEOQM9rBUw3+ShnQC+EhgG4BwkwaOUZhh4h3CS/8jyYA7V2S2l5IUDeMVGocaAsbLW2sclFBSL5D
	Ys2D6qp+wPX1zHNuLh4bGLyvkqP7qhUIJNXUGVyXFIfFD+rpyEsB9GE0hz5/5vYocmyset836NVwd
	/E/RzCbcBuNKShgDgI7wywJWJ98dZ0YbVBN/bosQE/XxFLx6c/JMykx4NFc5pi4Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxX2K-00000007KsF-3UfN;
	Tue, 03 Mar 2026 22:12:13 +0100
Message-ID: <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>, linux-wireless
	 <linux-wireless@vger.kernel.org>, "Korenblit, Miriam Rachel"
	 <miriam.rachel.korenblit@intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2026 22:12:12 +0100
In-Reply-To: <aadKDCKGHk1Ua-7_@slm.duckdns.org>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
	 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
	 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
	 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
	 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
	 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
	 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Queue-Id: C08D41C0002
X-Stat-Signature: nanq83t7394wy91az993geynoktfrmfr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772572335-214489
X-HE-Meta: U2FsdGVkX18cxSPHSdad0nLkvATcCPTDHC0NOq2BPutAsoU8mfXXth4UAtswwqBrmxL9wkVlnnSyZ8mGc5lAc0bajaTxxzhxct6MyOZiPUcuDy+wdY7/XcWyF/dNHxd9AAZ+kHqmYiJ2fj1pRxA66EiLxS/3Mmt1pKP0ch6hLyR8SvU87/Rn3/RfCqWQJay5w2MlRYAVfjZcXGfW1MxgnSu/GEPQS4sSxZwx3LrzZfSOEVOMsRcgHWiF3nmab8U9OItQonUpFh1krYijFsGeadPQzaegnmblhid/nKl9NA2zcpvIWMoULK3hFUucPhleqvnoeFV9SMskloL9rnQMofr91t0zQFYyyKwks/3j10FL8NbaouXUYmbZCNSIH/VMynnJ9VV8Q1y/4HmWpL/AANl7VYtXYZxcH9Rp/0QMttxZesJmE0ELQ6wPziQiIjxWSHB0jc9Bqri9lwSLFWq57Z8Mg/4muFdvWlswWarJSS7Fswi1J/YNxk16EJX7YdlLCsYkg36oOTxEFpmkBTuXUoSMLFvUT4f8zWpJTCqlevKe220GSABOaqM5wzC1dPITG666LVv5N1Up6MINqrxHBXqlU0b5k6iqzHXm2eLbHKv8utdxpVlmcnhlIGbukvzWfWe5cAd2lT+KLZiDXL/ou+XZlKhYonOw3R45y5MrZskJBegcAUL30Powel+hqEGlEhmU87N7NfW6Sv5iKMhpg80TR30Tddqx1RHSDPGEhzkZGRJC7l2b1i4Cildb9ooL8FYlco/ZAByvumOXuW1RqKZDqS+4aYOgp8JooV8swWfAqipx+01FJ0BxX1WQEgBw1W9e5ySGX7gHhX5Iwg16QhcuPqkqof/jEu58Z2GKDgqsvnIUqGytb6Ae5MI8pXheT7cOjvRZx3XS3j39dcWOC2FROBISQhbBkIh9FONaJ392KnPZTV0aaeh30oDAUyjQyPtnTc7CDjzxaVZ80yX
 2l7fWibG
 xXB/HlWs5n25hvsMs6bGzl89FH86DTt1gTs1S8npbK6yzsLur0KHVKpN/C5CIlj8P/0U8VprIqGUBB36jlL1/gEjzye5Q3YBxd0qnoD8MjqanpdnS9L+gd8qI2oAYB3ETrxVWnHv05W2uOrgGVjfvQ8XEpXV+7RMs573NUAydOYTfc3dVfdIaaAUfsfeInGYCKgQHyu0eoyDKTeN+5YcjQPBwOUoUp7L5Z+KlfdUerv2a7Uw0gLUy0olnag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 10:52 -1000, Tejun Heo wrote:
> Hello,
>=20
> On Tue, Mar 03, 2026 at 12:49:24PM +0100, Johannes Berg wrote:
> > Fair. I don't know, I don't think there's anything that even shows that
> > there's a dependency between the two workqueues and the
> > "((wq_completion)events_unbound)" and "((wq_completion)events)", and
> > there would have to be for it to deadlock this way because of that?
> >=20
> > But one is mm_percpu_wq and the other is system_percpu_wq.
> >=20
> > Tejun, does the workqueue code somehow introduce a dependency between
> > different per-CPU workqueues that's not modelled in lockdep?
>=20
> Hopefully not. Kinda late to the party. Why isn't mm_percpu_wq making
> forward progress? That should in all circumstances. What's the work item =
and
> kworker doing?

Oh and in addition: the worker that's kicked off by
__lru_add_drain_all() doesn't really seem to do anything long-running?
It's lru_add_drain_per_cpu(), which is lru_add_and_bh_lrus_drain(),
which would appear to be entirely non-sleepable code (holding either
local locks or having irqs disabled.) It also doesn't show up in the
log, apparently, hence my question about strange dependencies.

johannes

