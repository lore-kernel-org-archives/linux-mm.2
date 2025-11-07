Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAF0CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F32B8E000D; Thu,  6 Nov 2025 22:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2FF8E0002; Thu,  6 Nov 2025 22:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E07D8E000D; Thu,  6 Nov 2025 22:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBED8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:57:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95FCAC0356
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:57:16 +0000 (UTC)
X-FDA: 84082450872.01.4448FB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC3241C0004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:57:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF9QGrLL;
	spf=pass (imf21.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762487835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrXL01HEhHzcS38wwZtQxqmsBJicDwxzt2ihpxFTZ2k=;
	b=6QrH523tN3a+MO576wLeG3+60eUII+kDQ7YKqqCMaZKIjP0qDzUyRe264JT7W3AkQA0J4v
	1eh+74n3LOKxYRb85+ul304wOZs/wuPMySsCocGyxdsfCAPOa8jZAWigDW8qpFjJ1S7mC2
	KHs0wmbOljD+ENnsQy84Jxwy0/XEt0I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nF9QGrLL;
	spf=pass (imf21.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762487835; a=rsa-sha256;
	cv=none;
	b=QLffywsAdiJy6IwwMd+X948gSxeVfH5C9z/4uUwS+71Ae+vw9mrrW9yqeVifrFfx+mB8dG
	gDk6uBpbllsOjzVhmESJetQYsmt2+GfXabDw8OEldyeLALBpB+ShP1fkmKxLJGA15023UR
	45F6RNNzqqokFotLHOrGhtjf1zpeHPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF5FB4167D;
	Fri,  7 Nov 2025 03:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB4C116B1;
	Fri,  7 Nov 2025 03:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762487833;
	bh=rN1ZwN1I45020nzvwYbgC37BspZ2A2ja3waZRSu0TmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nF9QGrLLVG96PONV+TEhyN7pt2F1eiJvIe5G782uDEd850OCSYotIoei6y6ASjuGe
	 6I7S98s8ez12u8BkMlBSuCNYsUpC9elKMQGs/BoKt3JmXjpMDQotGNVwCtjc6UdCdp
	 BBDLni25UvIWuXTg8DweAjUqC6kjNEwzWQJYaj+8M9bWV+1NLYYNqYwh5blWmYE29d
	 gFtMQk7TIQI0vbAO2e149zzv5E++8GD0iv9Sh3Fcut5AmAW0vb7jvMh1XmjjLwBCva
	 O8dGfBOt/by5QCgR6qHw6yukASjdAwRp1ctI6RvNaIf8CECvlzMS8ILOOo2DDcNDMR
	 Tu2XB61XS9d4g==
Date: Thu, 6 Nov 2025 19:55:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/9] fscrypt: pass a real sector_t to
 fscrypt_zeroout_range_inline_crypt
Message-ID: <20251107035533.GB47797@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-5-hch@lst.de>
X-Rspamd-Queue-Id: EC3241C0004
X-Stat-Signature: 3xq69csj3iyahyita3hju51pcks1qhiz
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762487834-833599
X-HE-Meta: U2FsdGVkX1/RNlfNCcHYVPBAz1R7M6T9+Syz0er/X52BT+pbsrtYaNukbav7hd/EcFWfaZkUWcnkgcxqBQrVM8Pcrsxxu0IVZxRtxURyfQl3XeAAZf9iRtVTExwkMl2ljENuMaYHaoJGJD81Ava23nyAAl7HZsp/Wu0lnw/6WJbmRia+RNTmqhrAOp5YbaKnsxlm5SmtPQ0k4Avc71wR1v/Y4c0hxEf38yRyQ4n6WR6qd+9F0+u6lkuJtw58xfZy6xvAiqcUFFIXZ75DBC8NmzcZ7xi62mJJsxWBqUmzyxZeliI0tjfQpJ+icdYR6siQY9UxUFKAGg9r1rAMKuiP9peu3Un7eG7jfv0wqLsQTBPORmuaNSrPVLWnxlzFZhs2aeU/jGdQi8RUR+WJcXn0yHcPNWDURRZek2NxFZEXvlZ2pWcJhtYSxI645zdEEKhfbJGqziluYrepZ6pi96V4njdFqKkbV1ezrHWdobGhCgRlvS2WBbyvRwfd0sPSz45JDniSUjJ7JsxxXJGM6LHVaJCHZpTLsIarHopOSowE9gzkbOKY5rRGzUj56iXpKmdl0AfOoWC7B+CYGNHLYan9Jp3KC2VaDd/pg+g8TkWTjaFFgvstLXnn1Ea2HBeLd866VlfmdfAotp9OO9T0ce+2hw9tFQb5bwJvPucqfkpTsnSK8PPa2HJurJOCY+FpaKm2jNbkgp2Wics4a3ovw6zAgFM23XDvsANCqRoszami1M8/7E/mts6PQU4lGEGBKQ0iC2VdYqSOapijuu2VBDHU8gIsMdHszsyH6npzgRnNZDmRfoWYsLje6kagmzheaJ+IPGSckGK1jLnJLJ1klYbQSVXBKPgO5ScWDrxY6/Tve+p/BBvxDBkaDKMBDq9dg167dhZ0z0+V7xDnmVGVHva3LR8V7HzZdGN2OYgY7Z2z5CwjpVABP0uZDgc4qHR8uuvR/dF0YGDfW3Q351sSTTp
 GmZx7kyg
 gD9/KJQrh4LfLMzWBkti6ipDUwvduYwWIr2ifCzw3Bs0K1MYbjOPtWy/M94caOG+9XUzIThDGkpovNzYpweFr0j/Tq+FxqxiczqHeY5UGTUEhGKyxfGzFiirrUEwZajnAjY7Iz/xNo0Qok67sMkPVX/6hBQ0ADUhs/pSlbSFEAOetpBssSz7L0Nkm5LvyHdYluqEprR2fCQ5n+5URyJ6D+DtW2OcsbZNQBf5HWQS9sY57tLyE3mjYk1XuEMlo4UwNeWbE4++A7iRTPgAq5Yz15zhLwqPEg1DvNDTR7b1wf+EkrK19iJ8D3LXGkKQD7ns3mj/Ii2aJZ5hv6asv2Myxf/cGkM919Sux+vJ6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:34AM +0100, Christoph Hellwig wrote:
> While the pblk argument to fscrypt_zeroout_range_inline_crypt is
> declared as a sector_t it actually is interpreted as a logical block
> size unit, which is highly unusual.  Switch to passing the 512 byte
> units that sector_t is defined for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/crypto/bio.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Looks fine, though of course fscrypt_zeroout_range() itself still takes
a 'sector_t pblk' argument.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric

