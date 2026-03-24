Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51942F54ABC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B4D6B0089; Tue, 24 Mar 2026 10:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BDE6B008C; Tue, 24 Mar 2026 10:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31D86B0092; Tue, 24 Mar 2026 10:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 911FE6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:15:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4163AE12EA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:15:47 +0000 (UTC)
X-FDA: 84581155134.14.4DC6626
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99E3A100018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:15:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQdclUNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774361745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IripBIZuVOX8xpzpYkofrsk/V3EyKnRnGZAg6OBozbw=;
	b=1MiXacLvrGR7f66cjd3jEulNWcUMOLEQ2zCMJ9bnrY3Gfnf6UOJ1w8GCAEtF5d60MaoIrD
	vCAccTtR1K3mQb4nBqDIhQoWmPLg6F6pntvpfFqMJqpptOcJJmhvw10aHNoFLrnnZH1mb6
	kK7byQyo+vGI3AmOCCgY9gaAeccNyME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774361745; a=rsa-sha256;
	cv=none;
	b=TvA73jeDzmZ52wgugHW7Qv/6cOu630prdEHgFVV+4mXfSYzYZAz9TusA+A7wHi6xkmgfm3
	cFsX8DB3midUjLDiUNHyprRKKkCdGmbUKvcLKUIU+Wtk8Lb/XTLRplkElqtHAdUI4co0+w
	NLJ6ONxmQBvudMzi/0oNoogqsxeqFV0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQdclUNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08A95600AC;
	Tue, 24 Mar 2026 14:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874A0C19424;
	Tue, 24 Mar 2026 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774361744;
	bh=rdNwTeZrJVIPFYcjbtTuAiqhCIJwk99EdUukTgho27E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQdclUNFHffW5wwZjD+EMKJE50q8xQHVKyM1l83HbpGQq85u/WW1TmUgsAhwkLy3Y
	 wN4QvlE1cbPbpP/XdoINCviYRr/vT9utsjYQCLdnIZTL2h0TvklQtTfL9+pqNUHzD4
	 d06Jv68Ho8g7N9ujedjENGhJMPvBhtbQQZ/FyZU/3NmhG0glTnUkPaNKKdX+9N3nTp
	 xi6exbRRM+3UV3hWNNBsbk8NvGpHm1vTZMIVz7/hsdgJWSMMh9gNtmIh8ciYv8352+
	 NGEUkNodtOjhMtNAuieiovyon7/ogiNz7sXttL0NA2VjpcktfATimkMiQ1z3PzcvFn
	 Z3/p95wngBcZQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Markus Elfring <Markus.Elfring@web.de>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [v3 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Tue, 24 Mar 2026 07:15:37 -0700
Message-ID: <20260324141537.91434-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <A0701CEF-CDF1-4B3E-B25A-C05A32AE822C@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99E3A100018
X-Stat-Signature: ch9pd8kq1yxjw1sdp8o56dn5kgkre3ef
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774361745-292736
X-HE-Meta: U2FsdGVkX1+/nW/UDfxxJlB/CFdanxoj3kT5Ukthyr3C5TzPFvSVBYa0SXGi2WTyIfabkQXbBz8y7yVnsUZcgbizstUfMSLNnq+AlrwpmeUQH+lpcNhgsUyOrpbor4O2GjcCdxdlsDRUHIDJU2SXscM2sLeas0iDxBvgAYJd5vx5j9m2H4Wm8Zu5DlqvNj2qYrT1vgAsnneEkmAXmKxsIpU9V0Wk4kr+N3rhY5zHK41PUkIXNsPmfwiVcHvmGk2avf4qXdoiswWJJy37mY0HzHTOsPIy5IXkxlWU1v3coz5z2VGvaJA2XLN/tA170jx6EgbwaI6H5KE8XZ2iHniMARy0oX3uKAdljqO96zeqfU0ODUgeEnNUCY2ZSFqZTYOzgceXwSGn5PiHrUBQO7cHcZ/geuNRxmrTQ80jGqhYkNEYVURLa72IwWhN5KA12ScRO+DibfzQdf4Yb9q+udD15XD1bNQh9hI9jgAkBHiU5i2WbpYyI2Z+c024X3adGcoFT0BEupznbedxt8796zZuVycSznpQeMQ3OQHm+AaBV5CAX6rGkqFP6HFB/QfmUxFDMVWbtoPm6Mp3VLVLtZUdl8usoTX5ccN5mA9kRlTO86FBU1ErsdM3EeAKRDrxgGb+SfafI3srrIKmruiEwCINU6Ng3StEq0y3dTaUcYpqQzKiEWKEOEHdFiH38FRjSPZOB3LU6b+Emzh9ImtVVDAGpT2wnlbquZ0b+/p0n4JVYb+1ocreA3eC04xpenFMgXmNeiCDmfIrRg4EBV7EAfeks97NZD7yv6qHpfYsqx7UttEENEqhWNEtxD0nrW68f1hFg8Ju9/wBI9Ze81Ia4QMQl5nkzabMbusXxAO/ccjFI6/LVm2s5XaQNMGV/3PG0NySdYhcBkrUiLtvcl1H2HxDb38yeUxjJJyCvxQaoOg6lY1t/Q4gNjwT4NvgaIWNbj1mli/mwVNgdSYdrfkCKyS
 sJ/eIjoA
 dgBpwB171J7kY1NyzVgFum1BmmUARTcNBYlUmIHOrk+O8LNDk1ZaZSk30/BqhVoo1mwa/XdNM5AKM2Von0FOZ19n1JNhAWFisuE/JabGXEnqLsDAP3Mt2yHCvYO/8hlYQYavwzcYpjicHriH9GMk9tIjztwMrIfRjWaJ6w6GEG3ywSYRrYo7p4KTjGduOZFTj8lwgJB5i+9Hht0crmClo/Wc0R/ULTrMhvAEj/eEI/sC1U3INwx87qWdVhSGMRNpAqS1nXcSPrqN/q6HrOfdWO5tTKpO17dyuiDYVYNw/VUbD2yhR1DnJdFFSOS8ADT4pQ38cTbjWMqhlkfeB4+LNuIalHTstEcYxG2CCDAOiE5CNwmNIYfQfRVJx3BfHnpZgDC5E9k03XNLfqSdqopGpcZplqBOOeWHhS1w8Um1x0AgaQxZvitTD8bX/3F2pf6XqOWLRhG3sLQfzmKqYnOONDm9TSguqM2oduygzbJocR72XepQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 07:06:25 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 24 March 2026 00:14:59 GMT, SeongJae Park <sj@kernel.org> wrote:
> >On Mon, 23 Mar 2026 16:48:19 +0000 Josh Law <objecting@objecting.org> wrote:
> >[...]
> >> Also, unconnected to our topic!
> >> 
> >> 
> >> I've tried to backport Damon to 4.19 (for a personal android thing, and failed! Of course)
> >> 
> >> Can I have a bit of help if that's fine with you? The tree is based on GitHub a bit
> >
> >Sure, I will be happy to help as much as I can without burning myself ;)
> >
> >Seems [1] Alma Linux has backported DAMON on their 4.18 kernel.  Maybe you can
> >try their port first?
> >
> >Also, what is the oldest kernel that you have to use?  As newer it is, the
> >backporting will be easier.  When I was in AWS, I backported DAMON of v6.7 on
> >the v5.10 based Amazon Linux kernel, and the source is available on GitHub.  So
> >if you can use 5.10 based kernel, using that could also be a good option.
> >
> >[1] https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON
> >
> >
> >Thanks,
> >SJ
> >
> >[...]
> 
> 
> 
> well android likes using old kernels for some reasons, especially LTS, so 4.19..

Well, but the long term support of 4.19 has dead a few years ago.  The oldest
LTS kernel of today is 5.10 [1].  I understand some vendors might still use
4.19 kernel, though.  Anyway, let me know if there is anything that I can help.
I will try to help.

[1] https://www.kernel.org/category/releases.html


Thanks,
SJ

[...]

