Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEFAC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255B76B009D; Thu, 20 Aug 2026 05:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206B86B009F; Thu, 20 Aug 2026 05:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F59C6B00A0; Thu, 20 Aug 2026 05:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DED496B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:58:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 646DB1A049D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:58:39 +0000 (UTC)
X-FDA: 85121198358.14.8B15635
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E67640002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:58:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FdIXlOYN;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787219917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyaZk8aK8FjrhgHqtfFe8sbXuvonOinZPWzcC56af1s=;
	b=VBsP69Rlyskk9GvlTiumg93ZmJv1rTeIcMDrwlX+sZwP7cNoMFv7lCa7Kc4hxq2kaBM1x3
	P2e+9Dmeg+E2W4klixc7IDaF8gmS835+j6pTGMl39l5KvsY0uVRARdwcamnY7iKrLPZMtC
	8c4DMqalcjWneJgOT5df8+omiJ/7sSw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FdIXlOYN;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787219917;
	b=W3d/A6GyXIZBe/A2jZ+THAfrDfX9tmm1Lw2dkLEp1Lu0VrP45BD2MY9afFAgGNxb2sSoTK
	YAsJtuShs7p9MHaypIoCiHj8em46aN59MUijtakc81sEGX5KDyZhLSbU0trDNQ5aRGGHvF
	NJF8PPDm90YUmL/HGvdCGk6M5MdV0Q4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6+e0IVBhQsqNOnef2seSVjbtBoQ3uLTFSRseSeIlRqA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219916; v=1; x=1787824716;
 b=FdIXlOYNJW3tKLZOZLidF9aFp5YCR/c7kD6T9z2R+LihnpSwEbI1Bc6QpvEL8PlKdOB/p+XJ
 7YUuEAXEvm4iIPUVDrmwAfSftpVu5CMG5a8PfEPsn4n4MldOy520m97f0v74LZqsf1FhQdaiwA0
 V5DzhQ0uL7I6Ox28XXzuGA24=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 30b66ec55db78dc2;
	Thu, 20 Aug 2026 09:58:35 +0000
X-Mizu-Trace-ID: 30b66ec55db78dc2
X-Migadu-Flow: FLOW_OUT
Message-ID: <9c699958-c5b6-4aff-adf2-7c27a91cf4c2@linux.dev>
Date: Thu, 20 Aug 2026 17:58:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@fygo.io>,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-3-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hb4xd1n55ih5pmg9smwwzrpr8nkaxqf1
X-Rspamd-Queue-Id: 3E67640002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787219917-304885
X-HE-Meta: U2FsdGVkX1/qbm0Pu2sWNjpIyOy8BfUMasqpo/KRXvTRsBpL9k0C+5n0bGEV9RVBpsblZAcpETlPOWCnDA6Q1q9rZDshCsrtNts0VbezGkPFgavuE6D4z+XYtcZJ5ZUEK4r6bYV5sFTh3Ojs6fkvsUs9nUlcfZdfdDMHqnmDiRxIO05eib+WvhA0B8M3Hq/50hkxcjzb0hhrO/FDnAwrJ8vE8xwz2JSC0rz1fI1MBU88jZ6XeLlBk3lB56mZ4Yyz6AQyp4edX3SdQU64q6IyE40Vz5YTRFmXzkdbHoLZgm9jmu6gld73rI7BYEsK68stt/hwuH5uWHg6WSYf/7p3qSfm1sbTDQF5D6dEoZL28gp6pFn7xVDC6DYf/h4LKyGdAkS3spVwIQyVgjVqN/Jdw86lSlO8XkP+MAAFuIEZDNY0IcbA82tn7P0hwGmxU7qSHd97JYROAvw8h6ZC4hyJXMIg0rrD9EZvAtYKeiVtYCc6zTLRrRGNBinB0+wg48eXGzbBzx9A29qxsHq60LjdKyLakdMwZXfVYY9tdfOzbVy31vUgh+fnKv/h0B/403e75v5kv98bPiZHw+7EAn3mk6qv7defPY0Jmk8/X9R7PJDC9slnPRYJfknZWREP7HPWwwxYs39xZLJbMz9rd1sK9wSgK79SSlU+mfciHkZGVUadiDmHqZ3r3Hm1RhRCsfdFPD6A6JCzsaXjMjgZOOwIcOX0KSScuRwEQiPOEESH4dZaLaH1KjMbU2nnWeoPRRWfUMDu4hOlMCmGg79q2qvi0JNChe34iY2DWiJwsKPqX8Gp3mAxcgQi2ULk6ZkAKB1oUvcCWBqvyJ0308fzWw4qcUwMcM+oPdKybeUnbc45AUirDPeaTf1cJPZb9KFtCd5YkpUkI9HMhp2b1Vo6/Yukntgd9uSH7fohk+vC8nUg+6dzFMwyzTKeuQjw+7dKz2SgklUo/T+2pGnA65Jqy71
 CUi+ncUJ
 NSoYLexfV4piVTz707iWErbR4/bSDbVrYoDR49o0JiVYZkSySS+RBdRIYjBhMNha2Fvewar9xG9WxyC/SZUoLLnx80Jmc0r8T42o249B94m7TnHv/LOmZ2DT09/Z8ytnxmrSf6o3U5aHD1np5s+UkJLzSTTRvue6whjfJ+9vTds2WYVMWv9P7YSeJLGYi5VNa60oTiQns4ZcTn4qgK1rSUcwv24BWKbTnfcVcMOVS2hzDhUD+gbOJVJNRFlHMvNmeY01hy8Q76k3FFLqG6Jkx4F2HbvJgtooX+e07Ta00mUox7es4EMSi59IPe7r3C9xr7NN8JSdSmgh8cT58y8YBJi0KT8gWzDysuv98GioI1yoOMlt0U2i5HTMm6CT91UzBVaIp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 15:06, Yu Kuai 写道:
> A bio currently stores and pins a queue-local blkg. This forces bio
> association and remap paths to look up or create a blkg even when no
> blkcg policy will use the bio, and ties the stored state to the current
> block device.
> 
> Store and reference the queue-independent blkcg in the bio instead. Add
> helpers that lazily look up or create the queue-local blkg when a policy
> needs it, and pin the result until the bio changes devices or releases
> its cgroup state.
> 
> If blkg creation fails while walking down the hierarchy, use the closest
> available ancestor and update the bio's blkcg association before recording
> the blkg reference. This keeps later CSS ID hash lookups matched with the
> pinned blkg.
> 
> Keep lookup-only users from creating missing blkgs. A pinned blkg remains
> in the queue hash until the bio drops its reference, so allow the bio to
> recover it from the hash after the blkg starts dying. Rename the bio
> association helpers to describe the blkcg state they now store.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>


