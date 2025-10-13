Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67355CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32F98E0023; Mon, 13 Oct 2025 04:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE40C8E0002; Mon, 13 Oct 2025 04:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9958E0023; Mon, 13 Oct 2025 04:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFB58E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:23:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 546BF1DF8AB
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:23:23 +0000 (UTC)
X-FDA: 83992401486.03.F4B196B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7EEA014000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:23:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7GUKc0p;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWZgHXxBcz5Iy79EMz07wJ3G/Gcb4/W61XEISke+Y60=;
	b=jqWr5+lLfrOMxK/7fxTmBqCpu2VV2ZJx0ajXl0LZDMYXfTCSbxnFK6ig+jk2theVsanPrj
	J61mnzFcCiozi0KhNul8+yZ71oH2/Y75/OOmrM/q37haeG4ny6VsCMUPgj1MwgMWLFibYB
	hfp25YMByoCDaRu3+gVV5Rq6NsjfxvM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7GUKc0p;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343801; a=rsa-sha256;
	cv=none;
	b=0RZS5Z7gJucRSSaxs1fRn118FFBfftsnjoZdkxNhMxErGmH63qjO+zKCZEzgU3ti96K7Qd
	hmBwv4Wl8+0FqigDoG0SXfvYoY/eJaKQwb9qlXM/YrSKd9rsz/zj5ykOpf11sH1uGwLNHO
	4orQ69SJLbpxSweDjLaxyq/xf78HJdU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 876C445B72;
	Mon, 13 Oct 2025 08:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29EDC4CEE7;
	Mon, 13 Oct 2025 08:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760343800;
	bh=cnSh8W6jhFCAzaT940CS+TKEufGQdg5GaKndRn4BVvk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z7GUKc0pKniE7mLAPZ/6pqdvN6WS2EGnlbQRlV7qxincVQQUZa2U3P7ChEwKeVC4x
	 SlEKS8xSrHY3CnyD3YbWDRS/kA0K60YGo053lr62M+geB650bwBSwyC8aQjQLkzuKk
	 kHFlR90vbfuxBpdkKSCdFPB8lmMCQ0ustwXMoTx+EvvSGfl74gubOnvcn+Vd+uQzft
	 dOtpQMN8sqT4KxQxAVE+mkkL349M6U9ZIrsk7THwobYeYosNK80tQEvOXdrX4Swmgj
	 iFt3eWBkG9Ar/XnxgL5APEFIX+GCqgi2thNRqaBVBW/tJDHGT8OJLVYu9/UXd4+e7s
	 660G6HX+IccMQ==
Message-ID: <6f7e9453-de4e-4f43-ac1c-aaf9322cc6a4@kernel.org>
Date: Mon, 13 Oct 2025 17:23:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] mm: rename filemap_flush to filemap_fdatawrite_kick
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
 <20251013025808.4111128-11-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EEA014000D
X-Stat-Signature: q1kzyujitjkri7kcq61ncoa9oqudshc3
X-Rspam-User: 
X-HE-Tag: 1760343801-744343
X-HE-Meta: U2FsdGVkX18OVu+V1xRE+Kq3zPG6oofFu8NHK4mxqS4nk3/C7Y0XkK5hZTRA1zTFjTkCYR0wWqL+8Wb1Zubi+OQZZsUci8zk/SjWUkQGVf+Ck6p8O/caPx50RCRVEGXsAKLuR8HgeJj+CW7DxHZcPtpXYmLzwayJz47yO+qRd2X+jliw4ZUgc8lDA/p+6iTQL7HWq2cENfR1XjFyqawfjv6jKyCxcQEypdVI8F++697JTaxelS8ZuWNuwcskrA8klzwBgHfUE7D8HsMA2rp+ruZeLbcQDBhlntx08PU+IlFrNXGdf6+10xg8U7CWSUfoGgHp4vjv5fwTa56Yn86RPG7ftBvoAEwOW0/nWt8hb8QwhXXbbGCZaRYfkIkXNb8KuE0tn9vakvNm1IEG5BaiGPbhiCIOqHRttawrTFgAKK4tACjzRcWVR5IpJKVFvhLjRV9oizxte7SeIeeXgoHFjvxJcNtb81ShP9T0SAsgJ0/gXBhmjBpMQAf6Hsr+9tmCKxdZIAgXex4/Fj+vYrKzXznOV6UmF/6o9yqdZ5UxbODEuIABz3JG95nptGMtgtFaXVTP31UvQWwl2OUgMUVu7qbYPXsGsElbqMx9KS/+GH5PsGy8gCNEd143ALNjU50I18e+c1ft37/OVRT7JG7iGH1RC22W4lI6dXJxXQKax+nNOXcqoYtdGDrK9dfjj7cbj6/6joChq8hHVwJIYV+33EPBuZbdrSwW8KJv9t18QWxSHB1JSppu5xa5g3JH3PuhBhLz42hqLC1+VebHJSnVILqgmI37ZYIuNbZmt7ZoxyKrf+hvTzFB/sk8W2rxrlocCUKRI0TS+YTeNZUURjIO1T6MiaGDaoLQtADyWgurfHU+rNlaLRGZqnEs0bZ5YwZf0d9bE3zW/05Esk6meXK62CM7ggLpKB3J/6Z5/dgx/zgMIEcNVSQfnZnWTc34DtjoNFkDAJmQPePp8h9RvG6
 rWgDK+qy
 7QF/duKlr8yMDoRMPSnk9sLhtcEmR822wNeBw9G0KZdIMwPwK7U9jtlDqFe3pwN2MvgdD5SU4oohdhwRKl4oVQJA/doB9eGpHhwKarl7I/XcHZ7QyCqEp/phsJUfC+3ufI6WXWiqK8NBUUSKmgonZCwLZUBJbTID7N05D09v3TBj/cy3y+UlOS2ClNo5eQr7AGNYZcrSShbh1bkW1WZhrcREfNjwIKsUw1xAgOtI3VZOgZuWZ4+NAOzXB6QxL2ZhXhdg4hnng4eXGbmYnEVFryCYBrWuU++FaybD2XNysvHD36Prb2FUMp8D9GlgMfmMLCnWXai7Kw6iAaxgkKlGonGOhXh1GllSvpDc7LVA6B8RTrAMbyjXi++7Hk2BiFngiVT/89dFKNAEm7pgTZWmkG6ny7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> Make the naming consistent with the other helpers and get away from
> the flush terminology that is way to overloaded.

s/to/too

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

