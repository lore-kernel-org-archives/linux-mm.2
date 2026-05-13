Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F65CCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDB76B008C; Wed, 13 May 2026 03:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D706B0092; Wed, 13 May 2026 03:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CFC6B0093; Wed, 13 May 2026 03:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 747736B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:45:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F63F1A07A4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:45:03 +0000 (UTC)
X-FDA: 84761610486.06.544DEC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 62C4640005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:45:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W88QhGV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jfc9VamWO5q0xBx3b2s9XvXr4HRth56IxXIXv/8jUV8=;
	b=DySCtNouqvvspSrtRwMkqeRK5wu8yp/lUAtR/max+QuiQq+8fX1O8eSB/EntMu8BtSJ0wX
	938fnAKyq6aDu2FiA0vqD87agNtEs3hFqcJnQgk2481KAO8n3gbY3oAZ8YfvTzjOODxQZ6
	0QW0zDIYhFqQvVqgoTuqtkvnx0lazSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658301; a=rsa-sha256;
	cv=none;
	b=Zy+wueZrrQGVZ2VbW4WB1F8uinayw80+ImYZrUr8B34rnE0xtOVeVWUKKEp2d1fTngKIpN
	pH2pMF5cK26wkgxKfe7K+fD1LA30dKQ1pVC4LWn1QxgrewInkcrlH/BgVYo8xSIgtdyO9M
	sxWYKqJebZCeFp1YBSdCIc+qFv5YsNA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W88QhGV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21E5F43DB5;
	Wed, 13 May 2026 07:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B4FC2BCB7;
	Wed, 13 May 2026 07:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658300;
	bh=Dg2nW1p160NOCn5umFdjytzvydm/ZD4Y8VIlSf+k0CM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W88QhGV5fNBgG29b6A8+2aMpfRcsRHQN/DvQSObUW7md2OERCUFlHgf1cKsHqoq2S
	 8ykZnWkud0SccegE0umMkD4j5jJ7KgzhBrzoBcb9I/I9zNm6SNrd0Urp9aI7aA2mFH
	 Ls43dph0TYLcQ7SHMgIKKiqIjYNGHdG0bRvkSKaUSVLbUqXi1S0+3eREdcpqS6vbou
	 pjHmEbKTKNOrbnUGt7tcluhtcMyTN3bE6oKaewls6oT44KMpU3eYtzejZxITRlsKNU
	 MrtDtAfOwb3/X7OZISUgYCyAwxQnZAGj2NCGbnTCksT5zjWWNFVhk+szDVycr1iBRH
	 EXReRb+kSdmJg==
Message-ID: <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
Date: Wed, 13 May 2026 16:44:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-10-hch@lst.de>
 <20260512170846.GJ9555@frogsfrogsfrogs> <20260513055806.GC1236@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513055806.GC1236@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62C4640005
X-Stat-Signature: 5mrd6ypp5erxff6fqoxo4g43qaywak5q
X-Rspam-User: 
X-HE-Tag: 1778658301-806035
X-HE-Meta: U2FsdGVkX19ouJCSqKAJgDSs4nKNrg8kCVyYDTFNHXGvnwCf7Szvb5gjvAcOTd4XriYfYlfs96E7d4LUCRtOClJROd0fbemab+tBPgfS/VYtSMTVJP7YFoaajbDziLsMXMTyUxzpoccIa0Y79+H2GptVV7KsZIuKN61bgixZQtro97PayBwrpzBCq/9G8GEHMsWBY1lLKjKsQi/UUUhNY4K76lbgJWI/mSatUKjCInAwKn5zNGDCTTznV60TyYcXQaA4jo5G41PSYPAUiY1D6rxVA/kIQJTqxIbQDr30LIzC3U98QWH1WV7MUxx3G0rPnrgNS8mt5A+fCPOGcmavtXWK2PJG7gcq7hr+D3o9JEfjfnDBEsNcYRRUmSCuJDfqBRJGNyMl+hV7oh7yQRBQsbgH2ASQtB/bQ9j1/clwJdLCPwuHZHP8CwWQyB/ZM5CLbpSKMS8xduPF+cpvhFQn30o7SEw1k+P92XUDJmDTswlhbynyO/AzHc6gG1xHLLO6VjULzjqlf3zrAf5wLoEox+EGVi8j9Mbu+OTNLffLybbQv9VrgQv+HhzDUcFYqN1MBrgzea133oSFjgO41zJkHGNjQ880kjITI9qIY9V1P4tYkIxld/MoOwTc+kS1PLqI48geo0gh4c4IQ7RKQ/a8XayFCMUCONiCE9CM2pBCgN2fsHMK+xPXP4sfPyn2pSTkhyg+n8030OT37eDcNMDfxvb8ZFImTD0S4HdmTXEmICMCsbr8M9hvV4RTFuOjRoeEwuCb/6wIDb7JfiXfmBqoXHxI7HUhXJJiKevb4hf1LykBtrAkLT3orjCfUubCzh5+TmFSEillq8D7lchhr6qmdouRmVekV/evH3RDQcr50vW0HY85w7VPBGqvWWA6xuXBi/LF7rWpVAK8+EeSBYnpxGNvaTrt482yy2K8mkVN2UAiNAAcHC44u5cT8iDwqvIa5sMb5vtSr9wrsTE5jwD
 hvS5EvrH
 4d4yN5pM55Cx4ZMoNGj85EM8vb58Lo/EBSH9jkkaGb/WpS7JnH19k6l3Z9Y6ZURur+SLgmsU4NUaAGJCHK4uHD7alcU8fP9JCjekm7KIX6893d7NgMs54Gc2Kl5e4ZtXKAN/BaG8+TiR9L7XNlVVHNc81BstMgnAbRAqYF6a5FHRbHsAxmFwfo0jzJmyweBOBoTXH0Fov4OePIpGdUSiQ9uAWzQ/qbRu+EVi7pCUuIo4eMRbC3XHmgev4UUewzgcxcx2KtUrSr3m5TKquwd7jTnIrlabzJ7UxR+LokII7cBxWBmHHK+Y0gyTHNgYXEVSXFivlmAODUCzO4h+W4mLmcJ0oNyKRgeALvzLvpvdxJdeI/3KeCj9vXLaIPdJd8NJAtiZ1gyG8CYTH7TgorIu3SoY2fVaB37CCNp9byTxE2BrUF1GwycfTXylyAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 14:58, Christoph Hellwig wrote:
> On Tue, May 12, 2026 at 10:08:46AM -0700, Darrick J. Wong wrote:
>>> +	/* Only one bdev per swap file for now. */
>>> +	if (!sis->bdev)
>>> +		sis->bdev = bdev;
>>> +	else if (bdev != sis->bdev)
>>> +		return -EINVAL;
>>
>> Should this return error if the bdev is zoned?  AFAICT XFS and zonefs
>> already guard against this, but other fses might be more naïve.
> 
> Yes, now that the bdev is passed down to add_swap_extent we could
> consolidate the check here.

Hmmm... With zonefs, swap files can be created on top of conventional zone
files. So enforcing "no swap on zoned device" here would break that.


-- 
Damien Le Moal
Western Digital Research

