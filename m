Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31530CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 16:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B36E8E011C; Fri, 31 Oct 2025 12:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78AFE8E0068; Fri, 31 Oct 2025 12:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8188E011C; Fri, 31 Oct 2025 12:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3918E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:55:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F27BEBA090
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:55:51 +0000 (UTC)
X-FDA: 84059011302.11.145E033
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5BFA4000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:55:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qTtzE8oV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761929750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qCy5swEssUMullwBDPcwfeBomRmX6dNZ26zQAFEBsA=;
	b=supaAI04Or0mOhWS6pjXMvN6IQ980abMG3m8RJcaDDzBiKhC57BE88JbuRVPWxZZ4npqzg
	kxHP4KciV3hF/gshejMXn76w4U4VtrB9eNwSjXdIH4ECKKkxqEkipDW+RTRI6A6qnreacZ
	+5DKwFq/0xgSuBukJe319VqOlsbFldY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761929750; a=rsa-sha256;
	cv=none;
	b=y/0F+MZ5TEWG64+yDT0dfHKNNmtR71FUda4JCZt46e+s0DlLrKixr/z4buaiNEc2plwA6j
	SpqG+kuvHnV+s21VH28zaTyuRAKOoD9x5UTgqkQY6As4t7vPCYc7xROrwILqy3Zm/4hx7D
	V7HvBFdhmIGAQRzl+08ge/QpoJmmfDk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qTtzE8oV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7qCy5swEssUMullwBDPcwfeBomRmX6dNZ26zQAFEBsA=; b=qTtzE8oVyKCUwrgE/uhYAnrk4G
	GbKvNob6deotW+MjtUmWHGfPNixdIu/Mf1H+59JBUQsIg3CqBxZt4+yPr0GxfxhrLQFj++0iXyOYz
	K2XJWX50lPIF4rsxAGXPktHZeWnV1lxF7lqAHC/+JPnOnsAivXpJsOLbj7RGnalMF6/pKehRbFK7y
	SzGA3tOEb1WxBsD5N0y7MVI5hNzk3zUPDA8vww2Vni9j+s+EGIolSaPvAQ90TdzHKZpwjoUdEjf9a
	zSEyelA0V4PKlSDvldCW1bUvbUlC1GVbPbK2SJQ/Iccw/2G/qfUqiAdSJX5fz3wAtvy7+UfDL1qd7
	UV12zAtg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEsPg-000000032GW-1ifG;
	Fri, 31 Oct 2025 16:55:44 +0000
Date: Fri, 31 Oct 2025 16:55:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	libaokun@huaweicloud.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, surenb@google.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQTqELGGKCN3JTIm@casper.infradead.org>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
X-Rspam-User: 
X-Rspamd-Queue-Id: D5BFA4000F
X-Rspamd-Server: rspam02
X-Stat-Signature: p8ybkfyczysbhfdfwdcth9d6n33wuzds
X-HE-Tag: 1761929749-424252
X-HE-Meta: U2FsdGVkX1+wga3eYHoS0bpDqTDBOe3TieJ5Dj9Cu6XBmRecp1HAnVqj3vGkTUEJ9eEzODvgX7UbHomNfDmuWP4zk+FD3kaMUIlveg9QNjTNijsvRIIHHiSzbYWUCcM3FOYDA6TxibTX3kmzqiWnKjudQ4ZbMdain9P1X7QyIn/NiVpnzd5gdTBMn80HtjA+4K6h1QiGJa6WuSdKeJbkxumj7WyfnpWDG/M34oHVQxkjIsoPNARf7GvTE1QIwwJvGyWayL4uh9F1kioS4u/fs84N0RkuWZZIF9zNVGo+mxe5wDysoEQGoVznWDtbTgFIhmstxObJpREU8WDWIXMpAH1UYXI3BXOD8OY+D9u+wiJr2fxQGKMK54/n4780w1brLRIdfwa+2V8rdebBXmz0upRHqUc5LyBrI4G9kHf6+5TEod5uG5as0eivdW78eIRjh56cfkVM+uFYM5AhLEjjAYp/fbmjL2TROYbhZmlXQk+CiwZfzFBEsZja/Ybu+OqcPlhkiPla8+0tJaxUVvWC/vuyI7czTjuMUMeNkLCh7fuASjIs8RLglcnOravVHSSxYlho8860ETTEp5m6pr54GqpykzKovYi7poaBrMBM82HygXGG1oMs9Brj2uDN8U4FtzK6cUrEmfuhSnZxggkqqXowe1522bmTfYaxz5c7thF/H7DOjjTvNUVD6DWbMTNp/81u8FOb6Et0EGce/OYIXh3Q8IYEkSqGC57xlFBnUykNOiY6X2+M5SCm9+T5CStR6qxZb6zFDUT6qwTfiqks9B8Uj5fscqCEev3IvGQClG6zc9Km/0S/6ZUK3mBEjQBWzY4wC+CIP4Q9UwYtSwxF4b/Oz98s76b8i2TrxOZLYJupKJmMcoU8sUkUXdItbmZJXDcwso9n7x0vBkTb9hgzK86q3db7/pItuRxMjbTTbkPW3eRgO8KEqvLMqPc4QVqih9QeyhBd8cQsG1UeqMj
 m7Crffid
 lM9zes/fzFynzjZJZW7PddgTzKbgvD/a+aU6fGamJSGa/Zt/dlKAyNbfFcK8Lwsyc98Sw8zCLkOLp8mNk8Q6zvkIEWVjFrMJX68LmChyz7n/I5znNcbDKhUTCTNPdJtyFXakbbJuhj4aIISib+4/bBHmBQfqZUTuBZ4V/FSkgYRueJxAMFLMNndFxnF6bD1sVkpik/9/mVHS+aCzlCoNNg6G95Qe7rhXBg2f3VDwKNRu84WNgqPrrPkTzubVhXCxsrsv6mTB1oTXohCfrqA8uveC9L+to1cTlHvW7BzOZ2p+Bl8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 09:46:17AM -0700, Shakeel Butt wrote:
> Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
> (FS specific) gfp is fine but will require some maintenance to avoid
> abuse.

I don't think a new GFP flag is the answer.  GFP_TRUST_ME_BRO just
doesn't feel right.

> I am more interested in how to codify "you can reclaim one I've already
> allocated". I have a different scenario where network stack keep
> stealing memory from direct reclaimers and keeping them in reclaim for
> long time. If we have some mechanism to allow reclaimers to get the
> memory they have reclaimed (at least for some cases), I think that can
> be used in both cases.

The only thing that comes to mind is putting pages freed by reclaim on
a list in task_struct instead of sending them back to the allocator.
Then the task can allocate from there and free up anything else it's
reclaimed at some later point.  I don't think this is a good idea,
but it's the only idea that comes to mind.

