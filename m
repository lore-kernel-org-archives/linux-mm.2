Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3433DF9D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924BC6B0088; Tue, 14 Apr 2026 13:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCB56B0089; Tue, 14 Apr 2026 13:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839926B0092; Tue, 14 Apr 2026 13:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7557C6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:40:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EEE51601D8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:40:30 +0000 (UTC)
X-FDA: 84657875820.04.96F392C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B81820019
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:40:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pkBwYtIk;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776188428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H34Qz4t0dOFSEu57O5bBR0ByBGobQOtvzsKeF/dJkS0=;
	b=CagFasnVx3EZxIvbdYH1wdT40sqA41dmMKEGEXwWBDM08s1h7DTD1RoyQQD/6lQl/9pQAF
	JHxlFzU3gfMfmg0KXrxTNiwyrFbqRfHiaK6zGpOBihn9f3pIArwCU6mbUJTfaxslnJ86xp
	F4AwVrHfHLa8Ud2e7nsljUMrdkbvIGE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pkBwYtIk;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776188428; a=rsa-sha256;
	cv=none;
	b=ecMTC5FIsC1G4Nufy2Ff7DIvlqOgZ97IVMVEunAw5MMNatrE8XMGqSGUzApmhD/eTMWi3r
	gCF0bIGlxxGblX/IqL3S7GHO3gHdS3CgnDSrdru0XYt9oYQ1fNvbi+6okLdJs0WQiJ42Tt
	85ov/gKiIKAchbrDLwV0bRrrFpZszhk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H34Qz4t0dOFSEu57O5bBR0ByBGobQOtvzsKeF/dJkS0=; b=pkBwYtIkbRZIjLyneuTW65xL3+
	eeAj/0ArP5i6IeX/Ddqr97HyFgDMUMMcWqEHKrLByJp2q7cqu90awbUiiTzZZp3rdJ3hXqQRCVqKR
	dkixxZmQtAf3p2l2osR32cyGWHqiNOzxR6VmSYO+/DXvCVVE6f7F8w8+SZ6MY8Vt5KYC/O715zIPo
	SpTK10LNJfcI2FuMEV2tetR8QC9MgCRMgwP2GMMs/Q97jyDLvDrO1jkFzAvENmYFzxSmNXjp/ZJMz
	oq9V1ZY6x/wRTEO+CRbUWXCetmHbtZWyLTL0aYGk6OdTIEXc9/94uDh8nARgFwfpGmMzmHaNO1D/0
	4fXCHStA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wChkB-0000000FzXu-1gMl;
	Tue, 14 Apr 2026 17:40:11 +0000
Date: Tue, 14 Apr 2026 18:40:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad57-5Nqd5cci8HQ@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
 <ad1uK11f_J8sFN0e@casper.infradead.org>
 <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
 <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: kq1rahrpug8f15t1trhtfaz9rimxrcsw
X-Rspamd-Queue-Id: 7B81820019
X-Rspamd-Server: rspam09
X-HE-Tag: 1776188427-570340
X-HE-Meta: U2FsdGVkX19ykTXQqi0tjmo84KYh7TahfcRFhdrniEzXmFXzFkzpx+5AjvIhfl39vYgBUQMK5SLeH3oHa47GWvgbgTuJfLx0bvF+GXtLQZWR9XnZknWgDGLLLHZ7NhayVDEfuUHB0pSU6LIWuLgHj+Izl5IBeL8UAz5n+aKkxvXtttoidosiJp6qOR3UVHa5A5Jyvz07V7SSBQ9WWxba8T8Je6FSY/BzSpmvEH0qYL7N/wQf7K5DCAwSUyEfIgbPD55t5fb8687PWMBoLmrbw+qFU5RAlXBweJz4rk12vCQN4Q4szSc0fmlAp6P5HGpDmg78WyEsRmyWdghQTvu+0E9HfkZgiQS+3TMnStJ7wMIitYzz5D4GAPXOWgd+98p2BoPEjjnZj4Gve34RsU0+nUr1iDvtKrdXLmNTFp7YATMi9IMkujxaY1s8yWgPulJTw7oXv/pa13Mu5PBK4LT+Sxq6NDP2CKQhpnLxW4yajNTv80p/HUsRIccNSm3GOoDSKEtYq3ktUUM9F4UNku/jnufvP5FHogVZI/Dqx5LelUpamPvDI7vaJmEAMsRsE2s7iCWRxENUJULromp6FVbHO1NNYegN98tChmr5Wm6zBAO6PVTs9PpnBZlHQ6Fpm0vm5rVLNU/78ml8g3oacNihjIOfuVPZC3cUnoKINbViR24kzgpDaqqqxJ+odedSw+CArEZuG8RetOhW7HiLn8ptLiWjvdWKSWN7A2bF3ZkJhENB6tgeDZhkRCK5OWQ5SkOXKZMjHDO7QvFG7F8Sdy66+L5lGr7wVmrb5Cxgm3lXlRyoQK9RvQlqnuwGbtDR6XdlO+Tc4VomJUJbkIZ7vTuhONdFmVwVheShX39jX8IQLADOktmFnLqj+pDz75v6b98697i4+1ddV14GqGJEp2d+KMTcR+wXNi53k7x2AVRdcCOwacgMfNuZGss7ONTiY7syzJD5mqfEIOCTpXImz3w
 xXMMxQKa
 KS/LsyeMV17T4NUHmEa9BztWArfFX9gC51zTT1TE/I0+v8q6Z0QWOwmzbZL0oQ7yZrxwIhjqVrouK7NNh89dMOL/BBcDfaEMiMjTL35FoEuKiH/9SqDcja1wp+YmdqPuahl2iMBTFWHpemNoWCyoV4NdkmY0sBAgjpuRfeWqs2opV/XaODiyhPbbS7BeAGzy2Uixb8EBwa3Lpzg+CdpnThJJcyg+nLZJQK68J7N35bQffIAEon2QfZCQvxYOguXodgYgHQ0TGtB57ElKsCGToI9ZQ41SALRLdO9O1t77JDp8WBuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 12:45:18PM -0400, Zi Yan wrote:
> On 14 Apr 2026, at 7:09, David Hildenbrand (Arm) wrote:
> > On 4/14/26 00:28, Matthew Wilcox wrote:
> >> That sounds like more code that was added for RO_THP and should be
> >> deleted?  See commit e6be37b2e7bd
> >
> > Sounds like something to implement on top of this patch set?
> >
> > But with the added dirty checks in patch #2, maybe it's trivial to do it
> > in this patchset already.
> 
> Can you two elaborate? The code from commit e6be37b2e7bd is moved around
> and replaced by functions like __thp_vma_allowable_orders().

What I was trying to say is that this restriction was added because
of ROTHP.  Since we're getting rid of ROTHP, we can remove this
restriction.  No matter where the code has now migrated to.

