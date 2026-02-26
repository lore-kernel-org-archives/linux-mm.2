Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A4B7FCE066
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDFE6B009B; Thu, 26 Feb 2026 07:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABEB6B009D; Thu, 26 Feb 2026 07:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9436B009E; Thu, 26 Feb 2026 07:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 891CD6B009B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:27:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7D385CCDF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:27:26 +0000 (UTC)
X-FDA: 84486533292.26.B441B08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27A7680016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:27:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NvFgvUl/";
	spf=pass (imf30.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772108845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8koVmHPw/QzE8phfhz8d1B318EfEB7WbcNMNwpctqY=;
	b=TDcARt+2vGEv3U/rOEd29gi9Hl6otTnMVXFyN28inXd8db3DU9AnkZ5gs683COgLJKE9h7
	D2hKFjPuK8s2AVSjIlkbfr5d9tab6cjZc+Pk305wfdm7wiTf+h9fJYj19NBQhjlKX8r2yl
	fuIaFnF7imifuR5cjAmVTi091t4Lz9Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NvFgvUl/";
	spf=pass (imf30.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772108845; a=rsa-sha256;
	cv=none;
	b=wekt8qXOlBUA4wrWcWuEQk71nloCriBbIBFYKXMxSsISXPFwvOI4gYkW3KbMapeaONmmRW
	0olf73bbAtkp7uMaPY8c64B1nZSRarXeAjXS5nIgz64miQYmykPafYAgI+p01w3LijeEm3
	iRwurR6S2mCTkCrz8byideYrL89DEEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B9FC60054;
	Thu, 26 Feb 2026 12:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89BDC116C6;
	Thu, 26 Feb 2026 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772108844;
	bh=5T+IKcLz2704l+thlo/byfxXLDEQDyBPlzAy3ljbSP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NvFgvUl/Gmd7Ib+ARBt25ipXp5pIiv2hgkau3BRoYATgfHu/UsUKS6MS5ICemS0Fw
	 0i70eii95alNsBRUcoszLwc3XgYjoSBa4b9jP6/SxoVW6mrd5dcaOV681+kQPNLzU1
	 EJLsEcBkHdzm96LYd47JRFokryUyWobwS2gVUQJp0KnwA5YvauJkBodP4SzNgmLfi5
	 qc8NwR+j5ZC9gRVs55dP1j63u+avEVnVtr9dIoxY5bqRShhLjXsFRs+Vl6JYffGJEl
	 JE3KKSFAN8Y59fVnENBj3W5QuzYOwUoUScORc8lYCXKZnLLVuqXsMyDRPSJ80uWlpZ
	 WS29jVsLBp/Dg==
Message-ID: <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Date: Thu, 26 Feb 2026 21:27:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 linux-raid@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
 <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27A7680016
X-Stat-Signature: fh5g9ywopadiqe3pj186f8uqkzmmwtei
X-HE-Tag: 1772108845-494085
X-HE-Meta: U2FsdGVkX198SXxe/cStzhSWa1nnt19bq8LvThRP0p3jf4Fv+h/Kq8zMmIec3/uEgNW3bSya80AoDyRUylMaLwi3UmOt+mDOlxaIUJDP613iCQbvqj/GgvxVKgdAy0B++KkLUZM8EXZm0HuoWDHCYpSEUNNyxTRCp8Px1Z3tkY+CeDHo2p6GyFb3orE5ikqeS6xV6hkHESXU3Phfo9d4b9JiGvXcrKHJoICx11RGse27d82MbxJY8o41pil68hKFZ633OiIVluGxy0G5jdGkbj4A6mcjVh7LhCQ+Vv+wbIbw18Cz0iFAF9o51ihNIk+gmqUK0MTBPDkd3IPg0vFZL4NILijMWN2huQwBA45GX0gCT/ryRFB5zHKY84jEEpr6wF9ery1faW2a5INJGw3qDObVDOO73q84n76jDTLPbe2rlrrLgNcvFpzaTl7hZszCiKZiqBooOS28LxUEh8QXtLz8RetDgqwh46ZVzTSVdXUr2dnTeA5RJrQ12NRx1RTzhWC14iQOF4vHpawOziWGDAIFx53y33R4NrVIxiOtbpeThXqNltjtNJrCQ7gzb6GkFW6IDK6dUE8S43bctVbLErKSHAx/DA7qC/GMX8QdRk4Gr0wjrGJz8PHku5hK8uPHW4eXx28bFuROYMZQlvbJ1zc/P08G+cKOIoDf9Hk+aex2LZiSmPzXUgZvubVEgBUfOMnwBh/4mYWajyzzfseolg7Uas42875fUcfjF2qRXOVUtsDS2M86nvox4Xz4bwh7waI18HIhqxYC4pwuir/KN3LJp7CXqswcz2rSuunehOWgcs+GfIyXZ5qUzZsTGALm5cQs08iSZlC5ilDqssY+jbDJsJgdIqHopPodDnSqLLW8QRxZUjLHTEtm6n8vB7bkfCjr+xtRrGs6IoLHDqAD250egq3XuFGs3ZogI3/xWyCf6Sb8h9BcRJKoGD5pqP3y12YmlaTTa2TM9de/dR7
 jPf/bakN
 IaBNqy+GChAIlLLTewLfxpTVxzw++9PnhRyyEHB9mEHTqw6aqk56FkuwLKa4cv/+ISuqGphYwJoHdrqI7pZ/x+YQm5N5u8+28e2RsZJwvIvyyp2s25iG7nHEXd4Qt++pwgkJD0lQpur30PNHCPgfHwjIyncoZXEjo1x0w1OXaSnKEiy8nAAIbsCno6uN3CNWkee/pVIYpMVSxxHthHkzJ+7qDAhcBaZ6l9lf+WFwzWjQAv3FhaNV8AX5yVfSUTUAl4CFm7u9bB/KfJ8a+b2a2jliW7CrQ8fxKd0fI1zaHMnEwwvKUkc2u7UtFCdqr1y3WUDs3iY8hAAWzUzIt3J0i4Mb2Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 19:04, Paul Menzel wrote:
> Dear Damien,
> 
> 
> Thank you for your patch.
> 
> 
> Am 26.02.26 um 08:54 schrieb Damien Le Moal:
>> bdev_nonrot() is simply the negative return value of bdev_rot().
>> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
>> and remove bdev_nonrot().
> 
> Is the generated code different now?

I did not check but I doubt there is any difference at all.

This is more about having a single helper function for bdevs that is consistent
with the helper for request queues (blk_queue_rot()) which directly reflects the
setting of a block device BLK_FEAT_ROTATIONAL queue feature. This way is also in
my opinion simpler as you do not get your brain overheating when seeing things
like "!bdev_nonrot()" :)
  > Is it worth the change, as it looks quite subjective if you prefer the
> one or the other way?

I think it is a nice cleanup, but I will let Jens and other maintainers decide
on the worth of this patch.

> My point above aside, the diff looks good.
> 
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thanks.

-- 
Damien Le Moal
Western Digital Research

