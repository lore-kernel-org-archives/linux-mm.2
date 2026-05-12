Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA31CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002916B0088; Tue, 12 May 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C6B6B0092; Tue, 12 May 2026 03:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59B56B0093; Tue, 12 May 2026 03:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67406B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:35:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8460B1C02C4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:35:04 +0000 (UTC)
X-FDA: 84757956528.13.7301E30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B34A8140002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:35:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CLRtx/UM";
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQd55LajexpGLYq3nw5x9rGxQqldh5nydMlhuddhLnk=;
	b=S09NyqxDTnSMjTrKl7mxprXirBsfAkzlPDFkcFe6i0xhGOSj68+vXRYUnk7UPj2ybv7cPM
	X4veXkClUqcc/RfYxsstqglZz25fzLsU5ISx4xRRcqGh65C/wllu1Mr5t29qZ1lt3aofI0
	2DS6RBvjDTSgA+R/tUpj7eb0G3m9jXk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CLRtx/UM";
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571302; a=rsa-sha256;
	cv=none;
	b=8jlUGhSxT/PdOCMGeGp3k3JX57DpUb+EEqSn1jCbFSKyGoozdNCb9T2sfIUGSGXoO4R+Rl
	dtqjxoZAr6UIMr82ZRPFGjkpbyKFCqr/d66ndPRvzqCCBFoX6KPbzocNhvY8okyY6w/Jcv
	v5+rbtyy6AZWey8f0gRtL24mXfhc5VA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A921843713;
	Tue, 12 May 2026 07:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46713C2BCB0;
	Tue, 12 May 2026 07:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571301;
	bh=s/liCqvWpwzbf+Ors2mYM2xHnFEKG2Ez9stMzBy2CUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CLRtx/UM0efOdLrvjlbvsWzTtbQven4c5sLOwml2whwHzcCcqJMd7bCclOjdEZ20O
	 UXxIhdcs2qt054/GJeHr0t3YI+ofKCUnTiipODTRt7ADIbQc9JEeasCk+xcR9aOeew
	 Gi2vyLOb8+DJmCJSkdwtTx7cYb0d2rd57ymwPj9cTLhIyaPzAcrpNE2ILkt0jpqzId
	 HkOrmdLVr7An8cZeKIiB8TlR7lnPGvQeaV1/jiF25kcRdf1pFOXUoCx3u/XpqANN/f
	 VbTmMIKsMtE+C2cPfrNbk1D6HdbQj6D6wJTNfrXhs2YxKIj4hNpJ6iQIh+220eEt3H
	 1k5nf0s7jSIog==
Message-ID: <b2fab68d-541a-4f58-85a6-a304134cf127@kernel.org>
Date: Tue, 12 May 2026 16:34:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
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
 <20260512053625.2950900-10-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B34A8140002
X-Stat-Signature: gwgkp9mrnp8zorzd6d11hq5skw8541pp
X-HE-Tag: 1778571302-867593
X-HE-Meta: U2FsdGVkX18B6dzKbrULQw1ix6Yqj37VJvOAgYqLOgI9XjC0JZdNWqhL5g75nQaQkKBHoz25iWZ+dZkItCtcB3rscjV8/OM9HVyDtBHOS/+R+QY0WZsaCDXn7W4GjBGWHzdTzsVuUCIN0131oPfcNeAapaBijHVHzbal2vIivJFtFQVcGeyh7+6DwGiAYQLHOCnp83aPBdDYcjddxd8k5XkpH0RRdY8W8L8F1PHJd4pRguKWsjLERSwh5LR4n7saEjkIse2pzZtPUySQqXGcdwgRRJuBTeXuyGQHqPZEZv8FMAhkm3WtLw2rbvVE2llQ21gM/FU3by5Xgpc4i78RwzbvvhH7rjMlr20sV7YFQulyiQib5Wk/ekmv/3Oc0XWsp3hkZRcZ9WkoYm08+UaXg5LjcnVIoRWTJMpChwToCmUbYKZjb5MYF6eDOrTrAJ0KOwPnHfJL1eqhgJYzmTP3zdrRXKQqhvFuztiMN8iIo3+dIUn1JIycXC5y3AW7EFaHakpHju4FiWShAj+Wq7HvPiXg6VuJm9w9e5yEIopxkMGaPl4qgHjse9VrUfz2j71pr2PfqC7ypuBBDETxv/cBsFKVxveB99je0tu2/IfTdAI4i0plWQ74IRjVuiNQNTptC4gldpenVwwZIP7uiGigwqVqS2HThQHVPncZN3gJFt9Gk3LzU5JfStN3y2mVnpLbaqw9rGJRQk7YK7CXPGJDONhqPWWWycAXRQMZJ7asZCKtdp+oj/SWuzz3BiierPtSrUPEUv4V8179Zzv6LI0Dcni32V/hd6Stnd+B9SCcLpBBv1B7xjQ508P7Xsi0LxB8h7yxgYLWgdTZqcePTXOwX2PiKLSjXx//f9bjacoNQXArsxMFYUuFNOQxDww+ASxxmlwspRG7S/C8uUp3MflWbL2MMoDhBCV18xqQW8kPA5sPkOZSqMGRUR2DVRTuaaCzY6/RbuhAM8xX2VweTM1
 fuYt33Ao
 UpHEfcEYf7uC+C3SjDSlyDrGTt5CcFkYLgljN6sl1CPo3HzpCMOSjJK9INrwcQBGDmcA7bxoIDxMLk1nl+9iWSONklw3e1Mz/gt/phr1q7MPmwPV79q9cyLKO9k/KfggT770+ggHL304n3zqs9GGqmiLr3loW7XK2ZiLuo1R+SU9WzSri9rURtp1si/xooweu0EYCTXQpA7CjLMRbc4jnP+s0qnnpWT/s4oDIwqEj72U6giUuVqzoek6EshZxUhWOygSXppxlp0kH7Khr54JadfGhbQ6UDaNC2bx0AkFNTKwgLZ2vny+DAqy5YWXVHXbIBo+BftJQTxw+GeJ1K06n0clTPGyqxkqLgN7bOQjkkpNxA8hrE/ZoT66/yHI2zvulAoMYMqfNmqShEsA75KYAMlB900MWIElNfXFVOfFtJnAjBx1I/tjxtDLZSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Only the file operation method knows what block device we'll swap
> to.  So move down setting sis->bdev and the special blockdev flag
> into ->swap_activate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One nit below. Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> @@ -141,7 +141,6 @@ int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  		continue;
>  	}
>  	return 0;
> -

whiteline change.

>  bad_bmap:
>  	pr_err("swapon: swapfile has holes\n");
>  	return -EINVAL;
-- 
Damien Le Moal
Western Digital Research

