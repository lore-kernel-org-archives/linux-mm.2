Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11EDDCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F3B6B0088; Tue, 12 May 2026 03:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF6A6B008A; Tue, 12 May 2026 03:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEA76B008C; Tue, 12 May 2026 03:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26B926B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:11:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A87021603C2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:11:50 +0000 (UTC)
X-FDA: 84757897980.07.7C6EEFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 02F0020007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:11:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uv2j7SCC;
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778569909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqDV7IDs4hRtS25A7/4rvsfR7M1+1IrU1OOvisYqrvw=;
	b=XBxMgvLOs4PDBMzzWpT2vmnoa4v4KF7X/k7tzRlNaToK9OE25hvls6PUF2jw8P47TW0kSh
	9DW1GDjc/kVCLwUKLEwiCJ4XJBKvut+cbnPtMdYZrWBihzRZuP1NciY8mEgt62Pet0Bzjx
	b+Xtsxp3tCiIij6E7XMtPfg7KIgQ3yA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uv2j7SCC;
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778569909; a=rsa-sha256;
	cv=none;
	b=XdCmATyPTh9GP5Ch5gYXGVhTgW8bZzserVuaMvVE4lRjiqUgrDC3oAXByGSozuVRcUELj1
	l8LLW9CB2KRhwNxVyuOPD988CPyMywOEOTJeGL/wm9Z9wSEoKJpPTeBAXkKgj9v283lvoL
	IBOedJFPXOwoix2hXEwcd3vognGB33s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AF866001A;
	Tue, 12 May 2026 07:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43CAC2BCB0;
	Tue, 12 May 2026 07:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778569908;
	bh=oTkeOjEXbl4bVt9/z0YucKpdktlh9eD+Ruo6SFZVlhE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uv2j7SCChIAEuE5qdpNPXKPK9XFm+A2Y9VuBIpNTsBxttCqQYaWMN0rsAiGBhYiXY
	 W3pwmePaa1PphsLrHjKeA35fljhz50Cf+sh/UmqmjHZbmcoHeYD5Gbne7/WO2GBTd2
	 X3X72l8mRd2d8MWemJYGD0xJlOv+/50gI2qzcROm9S82EYaVSziWoJ79GWnVZPb9VI
	 y0PW2ETNW/5xkD7S679nuHkbfvAum5YdPX9FXUZGmYNyxPPQIPE/finUoal0Jy+h1y
	 jtRPiHUDeIUQTue4219h+SzjEvAPoXvq5kSlP14yDV+lekrne4Xtwqu/qxgUIAGQNG
	 tHvpg7vzQMTgA==
Message-ID: <b00249ba-928a-4f56-aed3-89354c0abf52@kernel.org>
Date: Tue, 12 May 2026 16:11:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] swap: move boilerplate code into the core swap code
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02F0020007
X-Rspam-User: 
X-Stat-Signature: h4tctitce6w5bjmecj7i4544qcsx6pag
X-HE-Tag: 1778569908-671754
X-HE-Meta: U2FsdGVkX184264FLTjQrIfpqZsvOeLj2u0GttxITxopnIpdz8isew360F6XHTzf48YuA5renaRIzByQ1mqCET/YQgFoDG+iWEVsgKFNu7o4eFMZQtvJ1+ErS+xjFsNFF7fd/Ci8av5iw6w4BuDyoslJ4mBfT/nc/ZwdVJcj43eOv1j8FEQpfnuq2pvuOD44rNgulMIc2V/RWrk74rWgkTg6jxvCDt8lYN+Vh57vSq6WjdUOb/vGc9fVT6IQMNURMAYPPzLd/zaqKIyugY83SIMHz1t0FmMOVGyhVYddkT4vmXsHuoYpy5Vc/fJwCwjpUXBy+wqA5lWtuk/YSgTxR4maTApmPqgN7dfq6UxEERZKswNvWNoRjkmVFWNHCb0rRtVnWWrAySTAHiJNGSxrkc9Xm8Kl+/oKbGCqPLBzA/vkXoI9zJQpT3rb6zsMX1pkv4q7J3XV1qA00JJd58YWz3aLznoW2c/e/yfBN7/lIWxpiB/FX/pqT9zMsnJWxBUlSR1d6zpxLdZmynImo9cv/eZD0OsTC/rHCKTs7k2CyGuLH37KPhNB6M85NgUR1zk4IEyO8vcrmUkUJxyhhCQSPduI+5DdyxgRZIAXZTgCB5KtWYhbR2sVVvZwKsoVueTGle1JCHw0/h7PO2iCNuYCYtcV3bAzXlOm2Kc1m28DHcbggVaTbLaH1x9x4rDZ2ny3uhEHdMyA+2qwOJ5tU74v2aN1y5o2QvNBtMlMg9eTwummT87iNzIcM0HuaN9P/9iCKS9ZU2MTWP8nqGvgtQR9haPLuYGeOv4B+wW03hsOuxu9rvICdwvs6j4m1rLZgBceDscBjl0wYw1cDy0tsxi9Ok7ojuTQqSaCU4x4bUb9xUki9cbynA2k8qjLon/KFqY5WpBOXx3l2l6kATORFiXoWUz/GiFtbFw1UbHDPBu4+gZMR6edsq1+JwLpHFAPsbSRa3KME+oRLwgsVd/rdOX
 wPl+mRb3
 yuE4VwY2Sd3rdIorfVKhvrzdgiYqEN7bkZCICJb8WV1kQLo4ECp1nnfA/lSiD0iq56gCklO2sF9b83i1uRdjSjb91hVBEiMEjFqIYEZ/U4pOoxfErk1f1d5q0DckINdAnIgVWCdz4lI1LrPEO17U5udd3n9pc14BLBhKEaAwhX1K8Qx4k6IPyJMiTKRi5fmkfC4wQAtMfapRc62Ne4KTbcugeD6fNgUdOLqWOFlbzPj4zlB/+dbqdanYO/wXIZSCI+vcOkN/A0iwdbWvhzVP1QGjvGgPdDZy/InpEuZtLTir81basHb9dwJjGxxYZPW8aJGxa1k2MBG05lLuRFoXUtU+jJEy4CXtY9w+VAGCIDcv4gKxsJ+x/KyuyNSOD+s1T4Zej
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Make the core swap code calculate sis->pages, nr_extents and the span,
> re-set sis->max based on it and don't require passing the current offset
> into the swap file to swap_add_extent as all that can trivially be
> calculated internally.  Also truncate the spans based on the available
> information.
> 
> All this removes a lot of boilerplate code in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the zonefs bits,

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

