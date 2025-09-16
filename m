Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2F4CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508C28E000F; Mon, 15 Sep 2025 23:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8FD8E0001; Mon, 15 Sep 2025 23:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEE48E000F; Mon, 15 Sep 2025 23:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27C928E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:05:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0EB114033E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:05:05 +0000 (UTC)
X-FDA: 83893621770.18.989CB3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E9D5180003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:05:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0dr5Bsf;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757991904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbDFDutOt5zkpPugVmwrt2lXz64f822+ujJVyhbWXvw=;
	b=PvYqQG5iQCVnOOYrOcO1kOu3763+YGAj/ogPi69YvcTfuvnbFh/cithOOMDpo+KXZhj4+d
	ehfTIi7GfGdpd+4ubGM0iEw2oyTEijmVX5h2i2kbirWd6gv/t+OsfOIo4Swk6IyYo/MMlB
	p5ydzble2enQ3Eml5YWJKdpmTIiBKR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757991904; a=rsa-sha256;
	cv=none;
	b=Yik26QjGP4fGrNu3CaQgelFqWf4R7+tGtt27Scs9sozXY1+/yvO6B1K9+9iW4q8fAOUved
	/9bNfm12Z5E9P1ckkoi+Kxw0RLAmhIuiwTNUcwukWV0eIATLUsahf+x6w5JJueGaPIvqn9
	AyHi5Vxn2i7YD5vHON+C+M42bma8RpY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0dr5Bsf;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E938743919;
	Tue, 16 Sep 2025 03:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D09C4CEF1;
	Tue, 16 Sep 2025 03:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757991902;
	bh=CDq+k6WKAKWCHXOa21JcbnmXe7JqkortJRjx4/7bAYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0dr5Bsf6F7wID+23pMS3qtrjYQw7SfnZQl42LtDNmJjlMGb5mGUg3pF7UTmUErLa
	 pvSPR7oOrAgp/ho4rJY3oAmhfK0QuPba7c+3LqxfKRlRUoaF/1NsvAqUYxKL5Csbcf
	 JmuztPVwKoYy3DK6f3XKugtJzs6hxResL+XMVZRP5wqWYsAp4+1ZRFTXNdcLs6uzyL
	 Glt6kWD5BSDU39XQlyzK5EYGlOdQtGNDLoOczZEIpX0nhxjOgimEQNJy+Z6ySbHEJ+
	 XwAHYd6Qx71N77KQAQV7IQnzHEKLRXQcHpzGIWF/u++CjCQgZGJQFSrMmD72W/RZWm
	 mIqJDPyzd7/mw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm/damon/lru_sort: use param_ctx correctly
Date: Mon, 15 Sep 2025 20:04:59 -0700
Message-Id: <20250916030459.114166-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915184306.110418-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E9D5180003
X-Stat-Signature: 81u1ybjn9cjrs6c9x749ce3q54dardne
X-Rspam-User: 
X-HE-Tag: 1757991903-289821
X-HE-Meta: U2FsdGVkX1/Q952j19X+cvn7z2pk0dlkeS/FFZSPAEo93VSnaaNeThsqJuA0ZMEGbDONuzjRVeYki/F2hnJ6zkHfuHNdZKQcSlrhcQbuM+mCT+ixWt3vQq+M2+qWvrtd2iCRA22Fg6weQdgy8mocRydaxerUK2gyYcn1Cc5fD8TVL8sAG/LXtFLOEu/H/4H+DF4qPtDon6eoB5/ErkVZoX6tAiJYS4DiJboyh0UtmxBd6Bzmp3HoLH6z35ngraleWE7bSbKPp7ez7fJkOAruxYLR2pf3ahpJELEsZoH+TT4G693JtzWVAm3KkpIqqvTqTdsPE+VGhdzyXJCHU786sZs7LUdQXhQ2FjWaGvd+xKC7r7efFfhU+PsYYdDEMi/lIIBQFyPaIOz6tJrbU2rxLricMKRvTJaenVfgbZiK4NJ3moTjbkUYaLNQgOPu68RdjjWG4mmYjmu2ktmQy2JPXO9fpKUvVgv2UyPYvkxBy3iSOINbrsbtEOvZmtnKmyXxMO/qJpGM+9FGsi5o//oQ2lz2UGxzqkRwds4LJAJHdEpU+D13mcKkLVgeUvxzAcxHxdTwUYF9HxUV72n5l9J+m5otC/J+2oS+vXL27GEmnFM3wE+YRRZ30cOA3v804suG5Ozv1f0CJZCdHPmNTPqRAd98EN7HXB6Igzl+gqBheUQtWeCsUaz1JaWrGZULjGqwv0SzSS/b8RVp2E6vWJsTaLeg4G0Gc9UhZvhHsI1e3Eh0xmmVpVvYjFbYztpXD245XWZfmDD57lPW9EPTN+bDOWfDIeTudUZhQ1B/xUJYFJfA/GC1/21Abdwtm243jTF0nc/AW0v9DCqGJ/vsTrO8LYP8LbaYH8tTpnv6caRH40FqUNJUhT6X9MrgV1t/seWvXu6touqqTeOuMiv736otXX392ZCxY0hI5K+Ugg03N41vi3f0DUksAX68bLqY1vyFGMDaqcnMvw/D6ZNAvuA
 YmnjiPBC
 gx0OY/TMWmd8p1HTerBD9JI4rw0Et0mVn5mj6qtarapyih65A0ptTzK0W418OaZPQvH0kQkKLvhydT2fEOFz0mN0ZmwolijXQpu2vJBRZdX7Dc2yO9+jfvXr3Z2Rf2wPKid2O+UYo64Vn/WaVGrRMJZHt8l1QaoQ4x6it+0+SX60MB4PwywtVlEHoUT3EcKh/AKInPKV/6iAIRSnqoVR8LGmDjJkDgRGay8MQOvHsWxWY4RuG/zh+aWiJoDzWfSQ5+E0XmfImsawXxbujAn9TDLoDILctkzFObMe36hoyKBRVcB+Nk74TP6u3NxllUcsKfd3/S+rHrNzxks+8G8o/9DpZuG6oSDd67Xj5I9zJ2qp/e4zkf49PsWkaEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 11:43:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 15 Sep 2025 08:05:47 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > On Sun, 14 Sep 2025 18:58:04 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
> > > user-specified DAMON parameters on it, and commits to running DAMON
> > > context at once, using damon_commit_ctx().  The code is, however,
> > > directly updating the monitoring attributes of the running context. This
> > > doesn't cause a real user problem but apparently this is an
> > > unintentional mistake that can cause code review confusions and future
> > > real problems.  Fix the wrong use of the parameter context.
[...]
> > So in particular, the global ctx will never have the correct attrs pre-patch,
> > since it will always be rewritten by param_ctx, which never had its attrs
> > initialized.
[...]
And it measn the monitoring attributes prameters of DAMON_LRU_SORT are not
working at all.  I think this deserves to be a hotfix.  I will send v2 of this
separately, cc-ing stable@.


Thanks,
SJ

[...]

