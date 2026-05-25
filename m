Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613FCCD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60736B0095; Mon, 25 May 2026 02:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9C96B0096; Mon, 25 May 2026 02:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD94D6B0098; Mon, 25 May 2026 02:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 951066B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:52:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F9CA120169
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:52:17 +0000 (UTC)
X-FDA: 84805023114.02.BEAED2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92505C0004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:52:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Du8rvlbo;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779691935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uZTIJVoSvZifmb04HQsusRFodHBZxoyipd8FVMzc/o=;
	b=M4m6YjJUEWffjijhCD2mQN0B4LEOnL8SElSlcczXjM0S/v93zHwrSq7Z9cMpSDpV7hXkoo
	LN3ddZX2v3NcM3uddUORMkZx7x12WDAc313EMx+43mDLJ9vXigs2DoVQpofkMOT3dSz+Jc
	WxIfttmz+lSKTqy7Uq9yPGpEkpWW/7k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Du8rvlbo;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779691935; a=rsa-sha256;
	cv=none;
	b=fNN+IEyuYdqFhhithj0oPettpGMlqgLpaxHk8ZcIsSMmsEbtXT3Obz6CG466lpV/oJnAv8
	ESQiidRQOd9lHEHjyRrpKjGFjvJFNzeJUdez6vzLMrGzaxYBTE05Z1BxS/oZh1I3nXWC5D
	lnjt/YeDBP/ij19ZqfIwkuZ5XgHz9zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF5AC601E3;
	Mon, 25 May 2026 06:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4701F000E9;
	Mon, 25 May 2026 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779691934;
	bh=+uZTIJVoSvZifmb04HQsusRFodHBZxoyipd8FVMzc/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Du8rvlbouwmZxG6k0edes5et7yEI2nRm3c/x2AVTwBp0vryg6hpb/jCt6nq3b+DxP
	 cxu33nDCEKVh8Xe92O5EAN2kQ+rK0YNTtPsxHivGMu00FZBqxx73/jXxtimF/NPipL
	 tQErUxNCUfQWNSyg/fLodfNBpjk0oRgeoEpUI1uyp5w+Q4H5MZexhZRuL3e73EJgfF
	 KiyFz5s6sZN5ZOnkW9stWFIv1Wvr6XEjvu+LFdsYV6yB92UY43bYze22ZbHtSomSwW
	 0XZAZdYhpZULPnO5WPEHwmvacqWaqZtjmNig8zXC6PJsmAQ1/2TLrkvgNSM/73+h3d
	 dbGUyvvwaeV+w==
Date: Mon, 25 May 2026 09:52:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahPxmSqT4Y4jcAbQ@kernel.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPnX-CwVgK-9chp@infradead.org>
X-Rspamd-Queue-Id: 92505C0004
X-Stat-Signature: bmbt71rw5pkqkm5insbaqajyyjysmr1a
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779691935-948552
X-HE-Meta: U2FsdGVkX1+D7A5si/ahZEV1AeNIbenflFcGrlzXurVQ0X/002ilkCoeaelzPsV1QjqANpUyOCjw9PVyySpWqe6VxNoSEjuVS7e4FEMzupP+AkFBEzuSI/ysngTdXkZoYpWvZHqehoHHQkZTAplj0ChI4znfqp7e/Sgj9DDqhkopz8x6qa/TUCJevPM5I8c/VHMx+bMgoOX7orkPkeLTg5aywZChsGYnQhf6vbU1mss/YysWCy/1o5XzTRI0pVZ4vCUFbuc08Q0K999RBswIBwTUeIvYzV78NOD4jMgFCdFMLOy696QwSPMSvFFf9bNeqQ0Km9kRR2VfqOp9AY+6jAJQL6j4zjyDchVPsYbDyLMmJFcaOgwOK7JLZA2Qs3yukdgTC89L+eIrtwQmp0dPATBPuv3cC5XC8qEpVsbfLdx6qAsSk1/Kjc4ILc4MdHzAk1Pu8lJ4svRUyJHQ/UmVqMOIu76mzYI3d0ecEL/0exYlcBrTVXVwrr7OV23UCj4fqtWV1OG4Kt/pLeAoU44p0wAa4aHy3ubef931FtbuhAHB+8/XrGlCCwwzaknpDUbxDUUCg0qrOaDJlV2c3a5NTxSjXxR/iMq64/m2RwEoRDq7n3ZRe88QVCPmatMyhwqlMVSnqIj/Ov3O4wP7uBK1S+pm10D3gLdlWSELvT+v75xarmTOc8K8vlE4xqgMygXRJD6SR584HFAaj1tTYnxE9gNEkbCu8ldRPrZbGJ1JdLWXweZyBAc6uZQZcFKICmj6NWbfMGIRx8NuLWbJiulYskuUIk/n8oK+y2gAWME4AgE0Q0uvRooHhzgzyjQdgcGNhMQ7TAG6BPztilrEHMAJKcGDBAMAESBms8L6tA83nft6Bl/mZQ5Ji5+/bC3T14qeJFdSxJvUq/ru1IeZXxtxreAZh3uaXWTd9UmaWwcG9r2OBC3o6xDLhMVYBHIGbfTSE9PXrF9i+/cYtnvmZAL
 h2RuNrq6
 YR/cyQ5+JLQvOYoZoDSx1ojlQnmVziRCkYv0BeegJ/l4mAU33Eg3u2IByv0APRUtlgM3vLjDlhwnoHGs7BYswV1ZcEtYz+iO43PUarTEsPdFmuwX5pHSb28Ywsl5Ra9pwhcg9D+NnxLOfXC8luKA9wDM+uJepTrknFQQy56unL6UAKSNtXZVkZiH80VrkuqXRKqj1HiwtvPf501ijvUGHuviNu+EMIn68KoIyUeleENsVokjoGaqBftUlp8Pfp82/dDtLziM42KNBdZ/dLE5b7/yjRel+gWCWH+nCRs0olRSPmWoN5wnlXjK/+LIA5ogXFS4ljYVVLXSYJGWLJGnjVTt78g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 11:08:31PM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 11:15:52AM +0300, Mike Rapoport (Microsoft) wrote:
> > check_partition() allocates a buffer to use as backing buffer for
> > seq_buf.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > Replace use of __get_free_page() with kmalloc() and free_page() with
> > kfree().
> 
> So I heard various vague references that we should replace
> __get_free_page with kmalloc, but nothing definitive.  Can you please
> point to a good resource for that?

There was quite recent discussion when I posted patches that change
__get_free_page to return void *:

https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/

And an old thread when Al posted similar patches:

https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/T/#u<S-Del>

-- 
Sincerely yours,
Mike.

