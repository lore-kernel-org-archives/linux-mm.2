Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD03FC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC68B6B025F; Thu, 13 Aug 2026 05:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DC26B0260; Thu, 13 Aug 2026 05:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4B16B0261; Thu, 13 Aug 2026 05:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0A66B025F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:32:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B406405C8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:32:45 +0000 (UTC)
X-FDA: 85095731490.16.C49F8DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E4BB140009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:32:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XA7R+IT+;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJJD2SOsBAimCJQo+R1MuHYdNWNJ35S207Lx1jtpiF0=;
	b=0bhwW0skWXXYdsddvyCbv/if3BGPZR1orlzYtUWWr3rXlKgBDD3tvRuf+JjKaGi24/PYoI
	QL3dq5JDSP8AqMUK4Cd2wSePTrJFy5C+10+Q6o33e4+8swSuF2FJQUxepQcTYeN41P/+y1
	B+vgUiaf/s/YKMv6CN1dCVnElFFD+Xk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XA7R+IT+;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613563;
	b=uHSBwb3MEyn3pojaf3LMwlH9XHQZlIBWUtJEDHPDsjfhqEgLojsQ+YAznl1N9fAjmNrcu0
	O96mw2rfAbYzETnesaGv+74DNUp2Rz/QSu/KyWKKWJjz540q+MxHi+YifZkwD/UKToZgZE
	tyn0MH6dRc7rvHlgMQoEEyUXI9iSZoA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAFB40904;
	Thu, 13 Aug 2026 09:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B51B1F000E9;
	Thu, 13 Aug 2026 09:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613562;
	bh=bJJD2SOsBAimCJQo+R1MuHYdNWNJ35S207Lx1jtpiF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XA7R+IT+BDnNyGoiXzA1g4neAaMxXphARUKE8DBl4gDky1oOitRkv6qRZYAktbfhp
	 sxD785kZo8xjlMHMzcP/0Wsx5Q2jcBAcyDB6OHTGf0LOUteB9cj6Jb+kPogiHKrzlA
	 K9FbYk1Z5FgPer6sWWuaYlRm4+6FitZol8SgkoNnNr0TFCmr1wF2P8QmqGArG1e84H
	 ud5PvB9N2d7ZMZYUx1BS+OrsF39fx2XJfAGdlXxaLFMods1IYEQfy5J0hj4VpBsucp
	 Hf6lJ2RAmkLg20j2VXfZ/BLN0F4zauMVkxh2nMqaqkkhE4dVqOLWKzzIBNGWV8NPyb
	 Yt7j0nWZ5lgBw==
Date: Thu, 13 Aug 2026 10:32:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: david@kernel.org, akpm@linux-foundation.org, apopple@nvidia.com, 
	bp@alien8.de, byungchul@sk.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com, linmiaohe@huawei.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	nao.horiguchi@gmail.com, rakie.kim@sk.com, rppt@kernel.org, surenb@google.com, 
	tony.luck@intel.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <an2PGVZuYruQhzel@lucifer>
References: <837c2e83-ad5f-42f5-afef-5132e02fc19a@kernel.org>
 <20260813092343.214324-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813092343.214324-1-xieyuanbin1@huawei.com>
X-Stat-Signature: iw9pppmw3tsnmxy899hqanohc5bxqp7u
X-Rspamd-Queue-Id: 6E4BB140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786613563-984009
X-HE-Meta: U2FsdGVkX19O0tzgW8p1sC4OzRPqUbCjSbJ6LPaYeX6uFLscyYRkuLO2cLEa4H7/RW7PIdNEhuXDWcq96vXfBq9j6AaUcZMxrWpUf7E1zdM4rUX1JyNw+Jy/NHyEq6ysbbwBRs7bjDbkLrEqutqaYU9wnUUNYLa2aLjlyXwaobuBeu0qisdsg1KS6sTepNVwdlm33oGW75Gaenaz919yYJ+kCTGICYHY4fWurCcLtjrRr9xDAPO+KhILaoxbXoIZr4HgwY9iXIPpvwTlLnhVnRioaVMp22hzMLL3Medtto+GclUZp+BfHLCh1y6n9HOfStdG5G6etAoHf7SNYRLvfTSJXEFMSeT24a2zzmDglcVF18wMjtxfobCB4Fn3l9xxielokTjV7ca9Qgyov1IBAirnghG8PaXSm22nVC2KlylSHgg4XgemktzidA2XFW2Al0vjHTZVNk01+1rRuzQ4b/vB5ywSH3ujeN6cBeFz5jz1MvJaYWcCBTa0bA/pPERNroAQUJeniGspo3JqObtq/UJtzASKFM9riU+igdMSVbn5WQSv8GQqmWLDWQQ/OlhGDn9FMS82wvnJsXVPeqgpdjGmQ/kGXLLkL+/X2XoajKCgbK+k6p+t4/m/xenapGBVteNFnh/C/zWy3vpEI9a3SDqZ0JTucB3hiofd+TNlAb2MFdPOa2BxE1U4qmASc6p3uatj/IUkA7+2FXIcinERsy7uTDKeHdgdXr2XqkvU02edUcImm/Lgy1ri6wSFBimwJoin+oskDPwK/JvKChD8qe9GlPm8WmFGC8Ykjl6KFCIwAeitPrCOif6jp2Qda1ieOIGEmpBAxwfvl1XDrNoC/wZR1mFG5kjOZnoSfWCA8LHLhSWzb1QuQyAD8x7KvAFlUBB83pq26RYd0s6dQFBHFaFslxa9ilYfEY/pthcOJueUpR8KZgxyy9HOz44awTa8boTfB9ivn7ldpIMY9Wk
 DVxoGjOE
 ka3OgMOVszk7PIbcuTZtzmDIhPhCdECyoIPm8u9Q2eZEuBY81gIy6EkNuxMgQmw8GptKwXDW1o/ChJPVTB6lEiYeFj1Nm5EPd1uZq5KD0XVQdp5X3dpHDC1mrvaqqTmKgFjO1S3WZuc8ek0spCp+KeH787GogfJSnB5RLP10QTYcEWLF/ztWCynsYwf9SBjpm39OPSW+3nrk3buTqglZTJkv5BfhQ8qtrcNka4nWW5D+L8nSt8rxtKepXkOVVrATawJzsFvySw0YdchVZLzc80WUqj22KYROy8UcYl11jXFuPZm+T0ak4rijfk6OqOhIP2r2nHlfaMCCqoa/iKuLsKE6J3EgoRIYUYsjJYuMQSv8Ii3G52KrPBYuRQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 05:23:43PM +0800, Xie Yuanbin wrote:
> Thanks for replying.
>
> On Thu, 13 Aug 2026 11:11:11 +0200, David Hildenbrand wrote:
> > On 8/13/26 09:23, Xie Yuanbin wrote:
> >> I think that just making MEMORY_FAILURE select MIGRATION is also a very
> >> good solution, and I respect the maintainers' opinion.
> >
> > There must be a good reason to do something fine grained like
> > MEMORY_FAILURE_MIGRATON, really.
> >
> > So if there is a use case out there that absolutely doesn't want
> > CONFIG_MIGRATION but does want CONFIG_MEMORY_FAILURE, we could discuss it.
>
> At least so far, I haven't encountered such a use case.
>
> > As really only softdirty needs page migration (IIRC), we could also just put
> > that under a separate config that implies CONFIG_MIGRATION, like
> > CONFIG_MEMORY_FAILURE_SOFT_OFFLINE. But I'd rather avoid that unless really
> > required.
>
> Okay, I understand it now. Making MEMORY_FAILURE select MIGRATION should
> be enough.

Agreed with all that David says, and yes that seems the best way.


--
Cheers, Lorenzo

