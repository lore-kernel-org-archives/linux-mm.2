Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A774D3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287B06B0088; Wed, 14 Jan 2026 21:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2321F6B0089; Wed, 14 Jan 2026 21:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F226B008A; Wed, 14 Jan 2026 21:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F354D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:07:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98CDD140199
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:07:27 +0000 (UTC)
X-FDA: 84332561334.15.6CBF948
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id B68C540009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:07:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Bp13AEWD;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768442846; a=rsa-sha256;
	cv=none;
	b=wadInBMtpRp/RifNm0JlQP31ASxIk2lk0jhEYRBpeLfwvbB167UXWqKnl5UyDRQ3FFY0HR
	LhpymhIFIB+uH3kYnDc+JB6cf+lGMcaLm07+sRm9jaMdmZicgV9a9d+hCsF6rMJhdV8S0k
	ikROYZ5zSQ2Ti6SiUsD93ClLbywELII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Bp13AEWD;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768442846;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+f8khbZNKCitWXbbKRIX1aPxZKAHv2BKTDxI/rs3qQ=;
	b=jAo+/BxeeiHfY5vigXcK6X5bvzzJUPSZAzub2rBPJusJOqJC+wDrqqH6D5rCPZ5lWM4ZGn
	HCkn0b0v2GXpOm9cEUEV88L59YRd5rd0uairfp1Vt4c63wL5gFQHxQ8hZojImChG+l/k40
	I32o7lFR4g38JOHrDvxTX6M4Q7APVTI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r+f8khbZNKCitWXbbKRIX1aPxZKAHv2BKTDxI/rs3qQ=; b=Bp13AEWDueP/X5dOq2Crlva3zp
	LObUkWbEx7P+fPaxVAVj7ECbXDtIt5fJQNi0W8/xeeAdqwQDMhG6aotDntGpnjPIlpDrLLXiKbW7y
	db69OsKZlPTXJY9hFApPOExXuwlJquBKPVPYlsfy27zSM5iEqc5lTBlIuN437J8zhOo9bRJ3HNX7t
	RizsEzCpgihY/8odVNz7ZqRlbeEBouXkkD+tnYyfw4WaNguyubnoxktd1QQC0rhX+BU9ysp/moenZ
	ZmL11G1jHS2NCQPDaLmxGJb3XNNlPtRsT3+g9Sz3nikP4QLqjwq1piFDSaFUaSPvv7auGAMPa6+Q5
	/cnA2QOA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vgCn4-00000000fv9-1myE;
	Thu, 15 Jan 2026 02:08:51 +0000
Date: Thu, 15 Jan 2026 02:08:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage
 duration
Message-ID: <20260115020850.GX3634291@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <0727b5a1-078f-0055-fc52-61b80bc5d59e@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0727b5a1-078f-0055-fc52-61b80bc5d59e@gentwo.org>
X-Stat-Signature: it3bbtbezuj41y1khhq6qff1q6fa9z6h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B68C540009
X-Rspam-User: 
X-HE-Tag: 1768442845-461427
X-HE-Meta: U2FsdGVkX1877LXnemBnwy5iweuDzD/RYWEib7fQA3p1K0QIFAJVM5v7DedtRPs6Afws4rNXbx8ib316ddh+dw36VwH+glH+vBGhgsfLU4hAYlD7iSJWRpuQf+BD4pDRk2Zx8SvaKIleMyRa1EPcg/XH9MrDBHIFe3uArkoqaBXg8OI2lUOLBCGANqfaeOwZVcUrhw+7wioVMObVHygDTKln2usOMCbyne+zRYkaD7xwUSR15eBGn//hFA4rKWzsLrbWGZFDXw6ocXV7ItAxUfWogKq/Ujj0eDXLj3YJRQFn53CVOfbtgRWMxP5mI4gPITyMKmaywijqsoohiifxEtSkZ1OUtcMy5t4s4qMQ29oChQK3ov0rQHJN2xepeXUttDTqaAc/e9NVK3oPk/LW7ISqiKq5jisdpS4uqn6DUZneADCyN5XWME2EfrHesBAwZRY4Qj0fHVOHOOgfYCZkCr/D4468S3e9F7YA8gdN5DUAe/nk8E6607BCsoyIy36Pza4+9THzBm6Sj3Q4UU4wj5/jfH1pYPsYiAe8acxtcdjBRDNM1uMlEXk9gbwH6vanv6RwmFQGFtY+74IX2ywS1xSBG5ZLkasxyvxef66kh7yteybIXcYMtERZXCnF2+IC04jrd+ZRsu+GH0Z2N6+2+bOb8QKpoe50yuszZo0djZmbWBDyu/cPlfS2qYqylDdjmA/EEAzEqI28v0p7gT2YE4eeqTq3Ju+yDJW7ImPP/MFC43Sbh9HFhpeMr9kqHMQQTJweVWuevRagTRGrqTpUMbjb5yxT1fwypSy0HsuehV8wbIHuGjP757hVT4k3/kb8WF2K4xmlFu7CP2iToTv5i+8TPciE8VssOYmzmZn712gKNJFWZFj2ht031jHTTm0FuDC81I8SqePdCLz7iykExQGWIjKl2n7hm1QKLgRrWV7g6xg74JyNkeFRu8TzQn8vjQvDZ2KAda8q16yFSWT
 MeHBnrgD
 gP/unlJRJezmUc7jbAbPbqZmsQZ9hzmir4tqhVNRKql+CZCg84J47NUSKYCoKtuGN02VhxZbs/xtlyl9SKMmSBB7+zpK//dguIz5aSkdeXcewgQF39INauXGlS0RJRsQWMjd+ZBVzzluG4oi5GxK+tiMH+rtvjZMkXn/1hVROvkrEKVIpQOHjejqbYwzeuQ4vAO6zVpn+70t+1WC5ZN9Nt6CqGGD1VRofwN7Ewp1GlYPxQ3Jyi1/nk+24VuPrUISIE5b+1THiko+iuDs0xZGhKlP8FQn6BhTxcmbCkqZGlYDeb8cVqDhNIqrWGWq4I7Rlg5fDwMQRN1Vkd3ICq728+HLfQj0HcKcAJgcTio05nq9Fy+UgMyiaNOKYSe5NDs/Jpj47JCdWXHXKJFdUlLUx/1w1swAJxoCK0ay3oFUWzHHLDwN9sCwuO56L7tV/yVz0ipBJCKv42O8ZbF1M0U0dgnx3s7DMHiDezF9EfHxE6XEqzG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 04:46:04PM -0800, Christoph Lameter (Ampere) wrote:
> On Sat, 10 Jan 2026, Al Viro wrote:
> 
> > 1) as it is, struct kmem_cache is opaque for anything outside of a few
> > files in mm/*; that avoids serious headache with header dependencies,
> > etc., and it's not something we want to lose.  Solution: struct
> > kmem_cache_opaque, with the size and alignment identical to struct
> > kmem_cache.  Calculation of size and alignment can be done via the same
> > mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
> > check for mismatches.  With that done, we get an opaque type defined in
> > linux/slab-static.h that can be used for declaring those caches.
> > In linux/slab.h we add a forward declaration of kmem_cache_opaque +
> > helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
> > into pointer to kmem_cache.
> 
> Hmmm. A new kernel infrastructure feature: Opaque objects
> 
> Would that an deserve a separate abstraction so it is usable by other
> subsystems?

*shrug*

Probably could be done, but I don't see many applications for that.
Note that in this case objects are either of "never destroyed at all"
sort or "never destroyed until rmmod" one, and the latter already
requires a pretty careful handling.

If it's dynamically allocated, we have much more straightforward
mechanisms - see e.g. struct mount vs. struct vfsmount, where most
of the containing object is opaque for everyone outside of several
files in fs/*.c and the public part is embedded into it.

I'm not saying that no other similar cases exist, but until somebody
comes up with other examples...

