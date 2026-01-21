Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2751D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E972B6B0005; Wed, 21 Jan 2026 01:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45166B0088; Wed, 21 Jan 2026 01:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52BE6B0089; Wed, 21 Jan 2026 01:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1F146B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:26:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D9091A07EA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:26:56 +0000 (UTC)
X-FDA: 84354988032.28.9645D75
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10D341A0004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:26:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rwVwLK5M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768976815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNhH2riMWX3Q+myVpHniFxOejkk4Wa8DeInyiyrQIbg=;
	b=onvj+RNbbEJlWv8dcbqc8eXNviT0f6J6D8+LQihDme/u+Ya+3phaQZwgvKSiNdiSxPuX5j
	7FByKYiePdSo/oDC05puWAcTu1HjZ2FAlJkmwlPPTz++3rsL5tDfnqZ+OnKd5pzL+ygoUw
	JD6KgqeblMvMI0iJi4mN8jhW2LWIVlc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768976815; a=rsa-sha256;
	cv=none;
	b=FWt9IYgQycYLBSz+wMQJkyLWfoBrP74gjYaLL5NtIFpmoaIawdjX3n61Lu35WRRsHRzMoo
	Dnr3XNaNxPF/cmGyACnpnuLn2dyW1KDhRIWQkNK69twg/Vh6ux/+1W1EDYyzVLt8+n3Omi
	raMauTdMKZBi5oYRiOAZD1JdjvAZteE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rwVwLK5M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PNhH2riMWX3Q+myVpHniFxOejkk4Wa8DeInyiyrQIbg=; b=rwVwLK5Ms767Y714H1sr3+c/rP
	pQjmUSg0nCv4AHR88HEpeU/yN3u4pmbEyw5fVOv4nSrRUK+EGAKKdJeE4bGKKFSCtgZwH+9sPszSP
	/b+QXFFUpDcSIROxu1pOXNv2PQI+PoXueLsQcjxfyzfvhbYdFNss0Ri4/baUoQjc8ulvGwCbs30i5
	nqYk+sr0o1HmejMC0CfirI1e4yZIaqvfltSSoykgtsZOfZc1sUDG1KS5w/cTaX2S/wlxIGVZGkcpv
	+k995blS+qXX0HkB11y8YuN6RoSzIE6Cn5kIGAWM1Osg5DGi5rlJsH/e+5mkzB2NmI8epl2M+qWPk
	I49Kjvww==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRft-0000000Fymj-0Uvn;
	Wed, 21 Jan 2026 06:26:41 +0000
Date: Wed, 21 Jan 2026 06:26:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: zenghongling <zenghongling@kylinos.cn>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com
Subject: Re: [PATCH] mm: Use %pe format specifier for error pointers
Message-ID: <aXBxoBTz16h-eKEs@casper.infradead.org>
References: <20260121034817.607435-1-zenghongling@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121034817.607435-1-zenghongling@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 10D341A0004
X-Rspamd-Server: rspam12
X-Stat-Signature: t7thaiwgrx4dsf97gy8muqucwq37rn7c
X-HE-Tag: 1768976814-595915
X-HE-Meta: U2FsdGVkX1+Z/JpLotFPvOu9LA6npRi3yUUQCnSuNfT3JL2rLvGkUFNm+614+FG+62e0UKE1VpUQHbGTSeDuV5D/k1c2+4wMOhnVvK3y/8G1HDg4JpN2g/7Vn+M/T0UO9hUD5getb1NexMPENfBW7lCulPyTLYzC2ZFEHMh6vukM2Iu1s6qUzKrb6m5J21+dkwhZKJ217DyQr+lh8Ud8n7nPLQ3YZAYnzO5YpvPnUhq6unuR72mPYtlTWprP7ARU4ojfTqLapRgdYvfSM1BIa4DNQ8427x6gk35zxzSx2olJz7HaEA4Pkmusou5bskQcGNRePfQjnRrrNayUgzLX2rxM68qt7YIcgs7Mu7BGk+0Np8Iy+t2j4eair6DYRy7IskXU7Y/JhVb1y5s910iu5BoYefWG1YWUk07XJsHo6MblUKWV7wSZJxGjIhOB+nnFuGFc+LpLis6U6LqWH39MhpODYPySZdlduP+FqnLbY8GNQknJkAn+tDx4hTscxINwZfzeOmiVvj0/NKzUzjed6y6eHcK/rUjP7BV/ZkJMkkSdXgHowh0nXMIEwx/L2Z+NV4AQEMzNjIcrxqIozt4CmjLYEvQZBlLlzdbtOAcVHEgEasRVe37RAQKvcspe5+qCKmL/D8RjxccmHexjlEIK3MSMWZhr0JHnQagjiz755gNMfzwCGIOiXVS8bN/HP7HUAyIvayD8obDLOb7N7MIxg6nwGjZQLxMtWOeiIVV68x2GExcSJmwF9fkwsO1TZXjVXy00TRC966TdIvIf/Mm30MutGJsElnPbBwY+kqwYnrrYFX3cyLRYM9p8k471YlOSvClVlRmfPo4rNDOmVh2d5q7ykXt+GGZdgRDoGCLmJd3gC3SOL8z31tI9h2UJ60UoRLehAvnnGDoLl7xfagiS69LLIRqwVlPGeosdOFUg6aMZzMsE6REtiVt035j9fyw1tJWsa1Na47rZ7GyKNpv
 4xXENOCI
 wEN1y/LwXJ1wb530ngCz/gwSwTSlB4BGf/h9rC/jP3YxOepjR7qpGHcAoqtMAo6TN6Q0ZW4xtK4PZiWZLBj/2e6CkrudwfM/MHC4tjonJUUVklRXzxtXDhW2mh0CkSacI4Qc3kn+BeqNvwmJ+7Z3Lg8l5PIDKi94Khmf+W0hU+Vql5YqIMwMioEoLlxVClpZd8Njqda/AMHFiwos6sAazdfrhXRNXEUGIb9m33rSaoNgdgQmv7lAK/dwKau4o+6OBrM23
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 11:48:17AM +0800, zenghongling wrote:
> Convert error logging throughout the MM subsystem to use
> the %pe format specifier instead of PTR_ERR() with integer
> format specifiers.
> 
> Found by:
> ----
> ./zswap.c:753:20-27: WARNING: Consider using %pe to print PTR_ERR()
> ./vmscan.c:7504:12-19: WARNING: Consider using %pe to print PTR_ERR()

Please stop.

