Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC4CFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71F56B0088; Mon, 27 Apr 2026 20:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC0A6B008A; Mon, 27 Apr 2026 20:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAC56B008C; Mon, 27 Apr 2026 20:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3996B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:45:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 172BF160379
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:45:06 +0000 (UTC)
X-FDA: 84706120212.25.9B60930
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86D942000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:45:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qbuZCbob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777337104; a=rsa-sha256;
	cv=none;
	b=exp/thpIph1qe+mdwNTTiqhIDloUR6oKnafpRoVWEsn2CnIeqDWQDKz8WNCbQCIxAirpXJ
	l5eAJKUcPsGDnxXbs/cm0myCOpgF+c/nzcc4qvG0cO4YGN6on/wsFwI1HzwrRnze/3f2RF
	KBTT8UoIpWrcZKnNRu2vfdZMpBweyg4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qbuZCbob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777337104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=942CyMg01ue9iAYNLY3dTp268w0h9+Dvm2V+XEV/B4k=;
	b=5jhpNZyRm7zQLrqirW28+E0EGoEEXoNLZEuEsDv97FAik6wvFmrkmMeQOtS6cE0R2h4t9V
	DkfBI1eikDFJfRKdyetChXM6uSMmcXjweMVzIVGXMJRorZRDY0u0h5A+mDv6Hgx7yosJy7
	pyyVJdj6Qey6Vu2HowDCbE0kw1PXOH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE92A60121;
	Tue, 28 Apr 2026 00:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CD6C19425;
	Tue, 28 Apr 2026 00:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777337103;
	bh=w+KfGykqmSbSQkq+ww/Klt27t8J2MFRZ7n8ybXamOSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbuZCbobFcgQmoszya8nZwxi/D0MTMxubAn3oSkBpHjOFYonPA0Slj+Pk9KwquUhq
	 wjaiSnVxBymgzpLgYL2oKD9OiejRMWwEXCZjmO3bDT7g0zG6/oBt8tCyq1NWm6sF+1
	 11YAf8mC2/pqtwLk/sGPPbrzM4WKmT5nYN1CmUco+nQ9JAvlyVjS/pFjOTWbFRMt2T
	 utjRoXzSrjSDLR3uH4KZuZVa9BLHCRIiDwtnRoz72eY/blwe2vuF9N0MuU84lXpQP6
	 nsy4vcH+gJgTjA2oo3C4t1leZm0aFuf05TdOpxtlKRH4QxovMA5XB2ArvNo36xhK6s
	 XpD3eQD3KLjvg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 13/19] mm/damon/sysfs: implement filter dir files
Date: Mon, 27 Apr 2026 17:44:54 -0700
Message-ID: <20260428004454.113463-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <666090aa-a679-4ce4-b66a-a5bba8284268@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: weg7snkjj398c9u66s1f1qyu53g8ybez
X-Rspam-User: 
X-Rspamd-Queue-Id: 86D942000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777337104-942430
X-HE-Meta: U2FsdGVkX1+mNlsbCJdQkprGfnK/DMxq+q4Fxc1rgeNzkjbh/xwMZPO43AULXO83s0Tt55drTWCGjfS5kMDhoF24bquUrXYOA3bc9U072xESkXphmf1gKhyrBopXkbzFhfI0xOgrGeWCW0wLv9CyFk6VhLwKlCm2DHYPb6EjIKjRIKYzSV9U/yJR3mHBi2QI0tLiysJ8khJlXnKpje7hbQwleLuWL255I2nOzBqHiFARMEV1bCpFqXxAf8cQ4MCkwceuUfhlIvD1RdjRQIGNWyj1sBk5Dj2+BsaN2NKaonp2p1N4iYeYGk2RU/yOoXdnIZEns0XGDP99CoqxQEbsU3KGVhW8YTf8vEi551I2rBJShlsUphLVfPWdyrg95PT4jN9uYwOK4FBQwrUQXrt7GKWzo6n8AAwrcyvF/ekELTXDUsUebvppNeybfw+JXDiCe5bVEGIqnOLjJ+rcRdHG9vbyvFTK+gbwo2oSTLM8ncl961euAg6SX3+RzCzvoGdl/3J1GNCp/hc0ysuTIGWRBjTGnH98gotHYj/kijYTAKUrppHl7Kwvl3rvzs4W5daRtvJtCgNetgGTrz7+yWnUvYvSmY50KvjwsWd870L6/39jI69lH8gn9RelQW/wR1sYW7++5E9g6/nBKdJaIH5NDpe7mACwDllTqcQ3gSivcbrJlCJKR/8SsTnK1xXgqdAUvOBMOkfseKVcIZkV/p0VqGgSIjMtUoZzTAoV729lRjPx3+npnbfLD2C57kpNZWLGwST9qEwJvArCi8nhUOoMWxNJoG7ChdAq2QkxzLsAD7L5XGt8371yLxQ+G+QVK4AM4tRQxLFLw8xaWlDbPHtWF90PymuTrFXnRKZTyrQvlenmgHXO7ru4yuXW78zipeSHY43P7n6maZ+CX0sFmcXwzECZk+Kwka9C/2MoDbCH+xaXF0y/MgfxfMsLmwV1nnIncVLknv7fmUh9wGEJq7n
 G5otf9fs
 opXiXdlhf02pYqCBD6Cl21AkAlI1iQVVPqh+vBO9Qc1E6zKyNqRqnGgLeCOIhgRuPk3n5cIcffG284i6V8P7VAa3OKP5ZSsS2xbs2ljs077605WF8S82E43y5U2Krj5KPmyBS2LbIUH+KA0IInuSqXyMpkhg6/jsGBTjt1aWGg0TkfC/PyQ1I2HJ9GN4FR6lpCgbVvkDbNMsW4GNCxTFcl/vU7agV/kSXm4ODUwnAWv1H7av/9cWbUs3SVcvB84RHRVjcsLZ/oZfs23wTXO1kr9+bPnz7IEcWU0x1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 16:24:10 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 4/26/2026 11:52 PM, SeongJae Park wrote:
> > Implement sysfs files under the data probe filter directory for letting
> > users to configure each filter.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
[...]
> > +static ssize_t type_show(struct kobject *kobj,
> > +		struct kobj_attribute *attr, char *buf)
> > +{
> > +	struct damon_sysfs_filter *filter = container_of(kobj,
> > +			struct damon_sysfs_filter, kobj);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
> > +		const struct damon_sysfs_filter_type_name *type_name;
> Can we move this declaration to the top of the function?

Unfortunately other parts of sysfs.c and sysfs-schemes.c including
operations_show/store(), type_show/sotre(), metric_show/store()  are also using
this pattern.  I'd like to keep the style consistency, if I'm not missing
something and you don't mind.


Thanks,
SJ

[...]

