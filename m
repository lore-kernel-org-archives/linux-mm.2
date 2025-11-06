Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF8BCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2C58E0015; Thu,  6 Nov 2025 10:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C3F8E0002; Thu,  6 Nov 2025 10:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0828B8E0015; Thu,  6 Nov 2025 10:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6D0A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:00:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98B0985251
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:00:56 +0000 (UTC)
X-FDA: 84080494512.14.091E2CF
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEE3C1C001D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:00:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDT56b8f6mIhkoMs1OET2Ye4HEuizq3/55Pj7SeXi6c=;
	b=2ZkMSzLGnRTHznihmhDUf7et5lMmCdOjlAFOrwuwf7N6r8cirO11zRx7c+crVKSW8Xhu2R
	7VZgSiVGnAIiXHlO9EyqatWFuy5UvMfNZdYbMuNlwvoR1jQOEEAM1pPsy1Hl2PRU/kzzIK
	dsqjCAX5AnLLgXeMWP3g7F1xfIDsJhs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441255; a=rsa-sha256;
	cv=none;
	b=UtNoZTtXZbgiz60QdkXKVBwn+Mek7JrJfeJk8TqUDJczPgispwSnOprTJeNqUWkiwPqklp
	A7ZvG3Mr8+IbdZ+dUWBV9T+37Xkz+wzVMUpWwNkTKVZanEl764gxRO8wNLnywOMCogRdmA
	yGlVYyaHQPwJTAgavxBkTmv9I5gzw2E=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8E486227AAE; Thu,  6 Nov 2025 16:00:49 +0100 (CET)
Date: Thu, 6 Nov 2025 16:00:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251106150049.GA16252@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-4-hch@lst.de> <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz> <20251106141306.GA12043@lst.de> <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz> <20251106144846.GA15119@lst.de> <f933b80c-0170-4c0c-bf91-7c862127e96d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f933b80c-0170-4c0c-bf91-7c862127e96d@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEE3C1C001D
X-Stat-Signature: bepz3am1zbujk35d1dzirbg7b64i3uf3
X-Rspam-User: 
X-HE-Tag: 1762441254-249309
X-HE-Meta: U2FsdGVkX1+CEhRxBui7FAigfoegWC7ufF/y1XpqJ8UYXpqE+aV0R5H1CKWZtVe4HJ1QUT4E8+TQh6fT8gdQ+7FWlkLfLu8YWnXdEIMJd/PTuKsV29WNVLGl933Tb1uiYQRWM1Txw5iUf+AOsCfnSD42STYN0rxGwCR5JWnwRzNZ1wzvlddjM6yronqXu6mhBbQB5l3bVXqp9vLbO5NDqK2jNXpeI/OJAKzpY7MqPKxL6UnyD7IxVRSU4f9orM8AqbyAGDvtAZKLueF8+1s7SIKeSjKjUSJBl34r1EGPZd6saFKcFzjlA4hQHCaD2ABQ/SmBDNFdUW1+pVhax6uVMYwWE+tmF9xznx2qGHfujyjcFtCLS+pOHBr8uDE+wcl/ZaW0bdzwa9Ml8WzGXS2sn7NxK3dXEF38EheolnPHSKPqTWqurN516gSCt7FHfwgC7ckdIFFnPcP1zSwrk8eeFmEg2jlGOmXmQE9B0MXFNYF9sUw6nKmA0/P6NGwyPbS68PRXI/xmZguZYRuvwz5+dRnf6x+IBH6+8a5UI/5giT3v34f1pON/f3q3HsbR7Tc0CIeH0DGcabLaj3CH97ZiC+5iNEk0yj8mLbq/azw4jaZYNvoDAyXbdMAaYCqEbNukKJPhljda15YT+hTxCz+PH1rRux04lJfe2CL41x0nhbNloUDLKwGvxKb+95YtwusFqazftA8WrjzrccGfW3w33DG2pM9MTNBHbJXob8nseyCB6R8eSIhhK9OgJdxgNuz7sIKz0mdlCfSShlS4gnbNVUIvuRQ6PLpmNbFuQyFggqk4Podjm3IdbBnfFRmCd3moo3s2e/4FKDh18SlxXUU+kG/wRBF6XDxLw3iEM3xCK8KWlK2hze9+f2PQtd7SozZhYVCOlcDhYoKlA7cW9+saLoDHg61NtPanuXNIQG4b71tfTlkKtWPJBpzEvLBkr/dnokpQ99Goy427gNZjCIr
 UvXX2W2i
 y1/IA8sDM6G2oXSDXHeOBbKsZAJJepU8WgQzuOwCpMxOeBT7O7MeOSdWoXwE6KK17FPdpazeuURslxa+HLkKo3vwnmYNM81WKG6UWV5G+sevn3aHuQMckVchwpZHO0+JspXExL6BwRGV/Npr2Z1PqOpgm6008TUHym6VFtvXBKDHG4BI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 03:57:13PM +0100, Vlastimil Babka wrote:
> > I think the only reason mempool_alloc even allows !__GFP_DIRECT_RECLAIM
> > is to avoid special casing that in callers that have a non-constant
> > gfp mask.  So maybe the best thing would be to never actually go to
> > the pool for them and just give up if alloc_fn fails?
> 
> Yeah, but I guess we could keep trying the pool for the single allocation
> case as that's simple enough, just not for the bulk.

Doing that will be quite a bit more complicated I think.  And given
that the !__GFP_DIRECT_RECLAIM handlers must be able to handle failure
I'm also not sure that using the pool is all that useful.


