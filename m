Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88321CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14E38E000F; Mon, 13 Oct 2025 03:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECA78E0002; Mon, 13 Oct 2025 03:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29488E000F; Mon, 13 Oct 2025 03:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C38178E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:55:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FCA91DF52F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:55:58 +0000 (UTC)
X-FDA: 83992332396.26.DBED648
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C51FC160012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:55:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6gq+hjH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6JY4ljRru+mLGsidDjVKshW6S3LGQOqHzxa6CnY5eU=;
	b=GDRvRddNZV4DozTV88lGMheCS7mwckwMU0zmHPuEvuTt/1ZVQqvcxDFzedpzgT467GYGM3
	gBzrSMFveVfEPGK1yYSOsJXnY2+8WWPMxXUgAHsL0fC1anvKXsLVIQlFAA0Vs5FTVvWW46
	aXkS3KHCfcz+jBCQ77E+ptceHsnQaAg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6gq+hjH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342156; a=rsa-sha256;
	cv=none;
	b=UniSTzaaT7Iv85KPhzUe06lWlXlFz98ETWZztuuIk+mo34n0vf17A+78TcnFIHJSvywPOL
	iR9d87PN79NOIE8bf03JZujgyCbPc/xYO56HRmJFIMmxplz1PJFRB94MrrP4cUDQ0dk7Cj
	i+H45Vchg5UmEjhdPE1MhRNLy6CxOck=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED5AE60F75;
	Mon, 13 Oct 2025 07:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233C0C4CEE7;
	Mon, 13 Oct 2025 07:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760342155;
	bh=mgqubBXmcDUB0Vocd771Uy113a9CMlT/bu1FmLbtKOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N6gq+hjHSCsbUKZZjniwkCj7yvgxSN3jmQu09ii02JLpjVZZaG1+SqSfGTa2PeQ9x
	 R7zyxn85U6fWuqA2AB23LvwxslESlaO5wo5K7hZ/gvYDn+OVkG2vUNL9ufHlCEsvAV
	 q+hC/o+wKMQWBb5bcyxqJh1BetJEcjhid1m9y7HnLAFbp3G+xhhZ23Cnl4l4WWHD76
	 V2jEgIkBRxE3s9Xn3yq02N9b78hjJl85DrFjOxiO8abK6gSh0CQMZ79HAaVzGzOwvD
	 XLcWUDUdyi4nGwosNspIhk/cPOcSTvepUqz9oxzPF3sdkl9nM8rHgA74VUSGFn9FSG
	 Fj7T8n4JaMxlQ==
Message-ID: <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
Date: Mon, 13 Oct 2025 16:55:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] btrfs: push struct writeback_control into
 start_delalloc_inodes
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C51FC160012
X-Rspamd-Server: rspam03
X-Stat-Signature: sfpbktp957g43qds645bz8m38hk3ochp
X-HE-Tag: 1760342156-776202
X-HE-Meta: U2FsdGVkX1+Wq735XQ5MSnhlGPQAjWkJfWbuf4bbNOTLardEr/uU7TNzQiToi0YWySCSR1ousU+q8W+jSQe2p8Jq2D/PippuERY6XmXeg9CuoQ12jgTc2CKJ5EQsGNv3QaSOVAInCrvZodQDhOUee3Uds2SvihEi16xOjAWbZBBvyxsNLCfz8aMKG7KcfqwKN6OriX1pdg6azGsMSWmmKh9Bqy5roSYU0cWVFyFeKuZn1fV7DRNKqGm79+R4/rA5dugKPn2u17cjC2T0fjVm5hXAJknW6qpnTjdNtC8oFdCBBRQB9OAV/RuZzHhYRCdBwu9huZEdoNCyQAUyjjjriNgG3xj5MJ2byLlFGjpY8jonq8E/cttn57+6wir/Sp+Erx8z3RHS6CGDOpkoesfH7bRca9m89oCuQhM/KvAGkJ6HtMickEd5gwh5hc9YMX4VFQns64WztH32BhUIBhLmg8x8yzy6K6YEEpLPzosv7f/rLqxEPXcMB/uS5CVym/bF0fnwOleMq7bedu3AGMPYtE63LVe8XVh9pgQqiVbvTgxJau/5nAjtD5chmrJVTyX9CeNKuPGXzBzb+YT3NVCnfWvGqF3BFyxp24+MyDUdXS9rdzNeY/hsc9THMb/IuXLkqGxkG1V8CYsVaUd3LHxpnEvTIxbpnk9il86KfqU75nxrZ5Scy10QT0gmE7Y3PpYsLBrMZzd2l6ag/48abx6R5XyymkeSDivfiPxOm1KR6l11Xrgb+/kNuFa1QEyptPzXXyE71dyh6VjboPvqDDNw6R+lzOBFmxNBLCT/r6yTyR2W7EV9ZhCSPC1u1k01OrrFCohwL9UEQ/hpYTTvT2nahWpSv1g1euhvZ8D/UMEHdchNdOW+VLBtKxQHM83usL2FhJC40tdzLmnD2gUppFigSLdlixC5HwQFPlKxhcEY8RKBabZi84OBQWs9L/sah6zsyrbJYnhpUa7YbJbBGaG
 36dSIudr
 VJhP3gub5gmMMEOmAjZgxWGCWK8FppQfvQ2I4EKOIS+TGyhiK1xHZFRBMuarxPhmmn63oTJXz5F+uOrf4WfwGJo7AkBUnlLTw3edlQl5WdmjB4CzYhLCPo35q47f9bXeXxsn5KBORETX4KEN3Ng4OUjWqZ89YzHelKGU5/4U7w8qGbeXPUIQedWlnJG+A72oulJq6ERMaTda3Yz7WkrqljawXqQfvHwrZoAf1mkjVnX15hy8HFAMPbq4xOMqin4wVfhuyYMrS1DMT35ebgXuQupP+do/XohTPYZI8yOgNd3s2hCZCEZeuH5A8C2N5cUnkDRiXqd4cPyg0TeMyXajOd4lbuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> In preparation for changing the filemap_fdatawrite_wbc API to not expose
> the writeback_control to the callers, push the wbc declaration next to
> the filemap_fdatawrite_wbc call and just pass thr nr_to_write value to

s/thr/the

> start_delalloc_inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> @@ -8831,9 +8821,10 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
>  			       &fs_info->delalloc_roots);
>  		spin_unlock(&fs_info->delalloc_root_lock);
>  
> -		ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
> +		ret = start_delalloc_inodes(root, nr_to_write, false,
> +				in_reclaim_context);
>  		btrfs_put_root(root);
> -		if (ret < 0 || wbc.nr_to_write <= 0)
> +		if (ret < 0 || nr <= 0)

Before this change, wbc.nr_to_write will indicate what's remaining, not what you
asked for. So I think you need a change like you did in start_delalloc_inodes(),
no ?

>  			goto out;
>  		spin_lock(&fs_info->delalloc_root_lock);
>  	}


-- 
Damien Le Moal
Western Digital Research

