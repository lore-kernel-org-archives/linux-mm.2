Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611F4606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829876B05B0; Thu,  5 Nov 2026 02:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC2F6B05B1; Thu,  5 Nov 2026 02:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F05A6B05B2; Thu,  5 Nov 2026 02:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4720C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:59:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C84D080956
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:59:42 +0000 (UTC)
X-FDA: 85400316204.12.3BF6556
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id C59E180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:59:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793865581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ln52JZJddcocWfl/gxFwMTgRR26+BYApy8AfhWYLYyY=;
	b=ETRhjS2yPJ902s8pyyG0Slucq8jcNpKl3YDP1VCM0yogx6OcKgO7DUC46axIMxovi/teQW
	SjF3srYx5rAzOoHS1S6tqCc7TGljZDF8vhbhaeuOv5JnUNR/gA6IpcCJpgOb/I95+FRP7f
	29rPp9i04txWAiuadiSBAsGdjM0iKV8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793865581;
	b=8Sm3lJV5b/GYtQvhyz7/6AGQDBaGoB3jrkn3lFgA3l+0wY5oq5HF5lIXCqI1CgUuZZtfLk
	Gzh2TIS8rlBKiK8EKgc/LSxgqM89Dc2DNsnPnZ2g8ARI1gWE4bfwU8WGvzcoqVN3R0i9s6
	WQBiK3CnSicFFpqFI/7owkbLlH2w0vE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29D0C68BEB; Thu,  5 Nov 2026 08:59:36 +0100 (CET)
Date: Thu, 5 Nov 2026 08:59:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v10 7/7] NFSD: drop a shared boundary page only once
 both WRITEs have written it
Message-ID: <20261105075935.GA18069@lst.de>
References: <20261103211754.35352-1-snitzer@kernel.org> <20261103211754.35352-8-snitzer@kernel.org> <20261104091543.GA31130@lst.de> <autk-osSQ8l2LKz1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <autk-osSQ8l2LKz1@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: tjo66oi56ebbz8hjqt3mxcgacwxt8cc3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: C59E180002
X-HE-Tag: 1793865580-421471
X-HE-Meta: U2FsdGVkX18l8qZH7nhrl80MR7tHh/bLQvo0Ww7TgQRFlFx3yvNU47UctG96CRP8kMk5RRkMyGaNA/Fp33DdsM8AERbSUrNsUcXzCsttss55NrG2hdrTmq66pMGDlO5FhHqAgqqk6cnE3dZrqVlsPyu4746Dq0ooQ2BCxXfyZKnWDLJilXAXVvL1cXmiPuUZruvonb6QX4Th5Mn4p/kkYrPQtTY0gMhM3EHLBxOnYXE+hU0YeQmTtbic5z2tvuzZSjPkUjHzlPO8n9sSLy1a6Y70B33O6RaEQpxGUAwaZWuC0iLcfoVrCtf3SOs0IfEpZd+UuSvfXG/fsdvU/aKZZJUcPCl8npcjmy0AUG34OyFi0Hpn/Y0k/i0quG09lJOxjoDtaUo9IGJ0p0t0PtI9tTUAdQKrT9cesaJSJ0PXrUxx3mJhr3NDsMMqKHNeV4fhiV+SDJ+oNad2eLf9rw8jeOxJKBGK7MppcDeDmFwWElEFsk3YyjxCgXMcKnpP4wag0GAjkCjg+O66tE+SDizyMvu6l++eP2Hy3D9pF1hj544numb/n/v/G/gtPB13nilNOE9ozU3sYYD8Bo8heFfL8udltZ2CrGd586H8z4lrKBPB30k4Xa4xO8S67kVzy1Jaem/y5duPHGurYcKf2fHoZvZ5ATDSe1Vd9BLs2fZatXj9MVJAfDKBYb7zO/rmfxaJtaVmHgyfWrQM8A1b3oSypRtZC5NvNjX87e9jSCwuClooMqhsRF8wXIri9Nv6TUNee/0SKBRM3mRFrifZLI5TdNuu76VebBcJRYBkWuuXeaC2S6gmzovbruSDGK538liB+OmHGH/KV33Nh8+XHre0JU7WhiY+6tRpXtjtseWacGruE/TUpSMHbrKN+xgAHQQXwc2Xku+r29bvade1X2odvJbUUMczeAZxHFs3XqgfCeUvivQ3r4LB2bpGM6IezQZEgiEDaLeyW9dvWWsOX4I
 DMrpXAF3
 UxY7w9HhkgIL+DrPp+3CIpTExr9JL0f39M3oZUcbxkT5fqNr+PQ31L2MwlfCfxbJkQhDrpcl47GnYyWvQ7yM1nkMGkHkLB4H2rcLGsxoLivwAJ3hBacgfGdtz7ZvFNq5VS+06l6B8bhhVmJGM7anvUQHpXDsbxwCRxwYKc5jtYWHxv7lwIH6w6a297OVOVAS3kAN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:01:46PM -0500, Mike Snitzer wrote:
> It is the transfer size of IO500's ior-hard: every rank writes
> 47008-byte records, interleaved with the other ranks, into one shared
> file, with O_DIRECT.  It is meant as a hard case, and it is the
> workload that showed the problem on our servers.  The same happens
> with any record size that is not a multiple of the page size.  The
> cover letter also has 6000-byte records.

So based on a bit googling your totally optimize this for an intentionally
stupid benchmarking workload.  And that's not been disclosed anywhere.

I guess everyone else was right and just ignored this bordline malicious
submission.


