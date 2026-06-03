Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12255CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743CA6B0096; Wed,  3 Jun 2026 09:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDAB6B0098; Wed,  3 Jun 2026 09:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5951A6B009B; Wed,  3 Jun 2026 09:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43DE76B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:42:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A24612034B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:42:54 +0000 (UTC)
X-FDA: 84838717068.04.128D1DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6532A14000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:42:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmmDKal3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1s3wYbkURqhM7qkvJRBzhJenXV+nbjO4FcCfUvzTI0=;
	b=H9Pz/dDjaGSJG4qUK1XEjIMkl76im3wCA5MMdL07cTKJuST9x74ILx15a0M1/opzN1RbyS
	/Y1a8V+SABaId8xKoDBPcCK1p0aYUXVlmGe+mgoSsHKO9i1Shq8beiUuOh6NZSbpKwA+Kw
	+3qHgmn/EW4QW3H4R444HLFQ8n5lMfQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmmDKal3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780494172;
	b=ibu2QpFOjH63nFn4eZUaeD0SoxA/seQsY/KSnD18Iujq5XeoQrXPDYhfrlke/U+T1hh1R7
	amN9anIyvHbSXWjCb71MlkkUThztIBXVkAX1ZVI1lMegpPb2djnGnKuD8elTtygUTSnHUL
	WHlF7zPo8rS2bMiuuZ+bE3Pjm/U/AMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3742E4333C;
	Wed,  3 Jun 2026 13:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8CD1F00898;
	Wed,  3 Jun 2026 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780494171;
	bh=c1s3wYbkURqhM7qkvJRBzhJenXV+nbjO4FcCfUvzTI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lmmDKal3j5juWoavef85dcQUeUs+HB448UiSj9bp43A2WeRYvNXS4A8q1QaMXMnD8
	 03NYxRzIKwaZ8yKdBSCAsmwGbPdHk8J1XUYivek+WREcdTrAoSvxoTCT8oVg7sNjsU
	 UxVWsTyvgB5I+zXGy7OUb8NabqNFk7oVBO0Obx9Vn21a0cSxSYWGyOFJxZffclTRPo
	 VZHQaMX1+XFowxETj7fNtwkOg8kFtVQIqYajjaP1LqBwyqsO+uuSDiK+Gb3m6oZdDX
	 +AHyZt1ebA7L+8PpMLdE6Wah/uvaNsH0rsTik1wm17uNxWmDRUrdh/t1JgHZpZ4nMx
	 DfZDg3QzWzkUg==
Date: Wed, 3 Jun 2026 09:42:49 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 3/3] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <aiAvWRr_3Y07Ba0V@kernel.org>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
 <20260511-zusieht-amputation-efe8b5058cb7@brauner>
 <7c0880ee25b13f64f71319203fcd7105f54e5ad0.camel@kernel.org>
 <20260511-caravan-behaupten-0402c454c22d@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-caravan-behaupten-0402c454c22d@brauner>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6532A14000C
X-Stat-Signature: mfhtqbdum4qgh6hg4zrsqig39adkymh1
X-Rspam-User: 
X-HE-Tag: 1780494172-790400
X-HE-Meta: U2FsdGVkX1+aa3dsNWq+RoSSAxo2XPN8+DXBIawae8/wKshBHq8JRTPV9nGCkBlaDOLpkoox5R/EKujvMZForzAfWiYZ0nbnrYlbCr+QzjrmxOvOIA/mKbUsoa1UfjRaNWajPth25wnEXX3iynzvtR93Nc1MWiTqEzlDmIQRaZkZ+1sno2E09DoX+fdPdunuqY1msNQFbpvx5TGVtSIRg5Uaw8+u4MqPBgMJFXQHHARgv5xI7lzrPb+2OfsSoloscK0hYJ4iimmEsRfe/nM4S2fAOxGB5j1aa5TQ8LdlQQygZ6nW06VsU4YeLAL9MKKVXCvThNnnBii+gfInbQP9G7k9BB/cTwH7AKwVlB1G+pU9rn9aahEIdhRF6fOm8yCPNn38oQVqFoj9zPYeVL/Cz+3DrNZ0zgMy9bgKPbnVeDFyypKtyWiWUdUNtklQuuHBIcakf7CofuPruZ6D2p9Z7mmIecoTry6AQfOYHq/2wisvRYZreexLVLCGaRm1HPnK6ynekZ7OZKcHhD5hDYYYW87IDh8RC/0j4u+nyXhQsqZEO8r0y6apbFt10DeNs9UriKHCxpYjlQcVqnka32f7nIhuG9Qg/mKzCTKKU9/H9tp1YQDm4PZdDT2k+rEKpjLOmQf/TOnHAj64bQzppgywtQqUXCXC1sxN1TrcaLZ7cXWLo+DY1L8nqBZzajfm9Nwxc5vWsyaOv17qs9AUD1zGem5lrlch3WjAreJXd6n4HLiWWOWKThFfZGqcEAxW/0pWG7W4S4jeZ3C57NBWw7Yo+avDEhzQl3ItZkHb+z+tHFQBTwFEEJgoMQkiMci2DyJWpbYLIEfAROYPB/XSUx2EtVfkt9Y80ZCIr1cqiqpTXtbzghIlPbDPVIzh02XUWyov909v2CUv7OuuF+UtXcf3KpeOZ/MaVdhvF4UtRYZqPq/5HxjOK6SAt48b3Eh2aXZknVan5av9tCzFhnRrXuM
 DVZaqW8p
 yuBxMNjLm5S+JbVlogrAFn4ERpDAe7loZm1BKNLvPbyYn3GPLxqqmfiXK66KoGHn5EWDm+DzLv3pO9rubjI0K8/Yt2jEIKNE94uCme4SaUDNib053im99Y6HwWAAoFrqWab1WHEKRRr0FM5FhwPSlf2O9qfjHIhhaLDZvKc0MJXRt8IYaTTdXO0aV8yQH9SfNblf+bMT86H2ce1ekJcNnY0aOUlGSaSPkUQblWOf1tuBEyMR1MJweDCguw8soNIRvNbEKtUXcJ2LlyBGIYtzY6IWk0wRoknrkeF41CPPFEvieqxmssswmXiAG8F0hydejH9RbWn1YcCrvTV03TeMPPE77IyMGHBOTirRIxo8BKHro7vz9KxMlEqVm2mFldFy72VA1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:06:42PM +0200, Christian Brauner wrote:
> On Mon, May 11, 2026 at 09:53:21AM -0400, Jeff Layton wrote:
> > 
> > That does look much cleaner. Do you want to just make that change or
> > would you rather I resend?
> 
> I'll just fold it. I already have 1157 mails. I don't need more. :D
> 

Hey Christian,

Did you happen to pick this series up from Jeff?  Not seeing it in any
of your vfs-7.2 topic branches.

I could easily just not be looking in the correct place.

Thanks,
Mike

