Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5697CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 13:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF59D8E0003; Tue, 16 Sep 2025 09:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD038E0001; Tue, 16 Sep 2025 09:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2C48E0003; Tue, 16 Sep 2025 09:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB1FA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:20:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55D0A14019C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:20:57 +0000 (UTC)
X-FDA: 83895173754.28.073987E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF6CDA0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:20:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7OhipGo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758028855; a=rsa-sha256;
	cv=none;
	b=ocPRn7lkU5bMs1lqT4N6JzOX1YPgROPJBsVD0CJy+ygLJnfvZFgV1mqix+vudrZ8OWGmeI
	72szfAePvLAOBLDnmTHk0QyeTRh42Dpv/nbciU8jduS2JqKdZBNKQQrqJcBcKA+aKzVpf7
	laAvfyLucqNfXpKgpTN+Z+Fhg1S5wHw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7OhipGo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758028855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EM3YSkqrS+wD1DSZ8rxCwrnJyCPkgkPjNIyUR3FKILQ=;
	b=Iwm6t6wiEU7VpPBKngMwC+cihGqflu6b8QlGZn/zoPF61a9xNNa9mm/vxOo+U0FMphsY/5
	n7O5uhu8RrG/EVcP8TRERTOlpCQtMgm2C+MTWnzq5iNtJ8tV5F2kX6/6H6Yp9dXBclc+4M
	43q/hVpQ08lOvBxCw6QhmJnCox1yVJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 114E8601DF;
	Tue, 16 Sep 2025 13:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E2EC4CEEB;
	Tue, 16 Sep 2025 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758028854;
	bh=NkEqYgbQHqBRppulOAwQLkXQ/kR/tGJDaQ28SAU/ZbE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=H7OhipGoDJaVVg75Xy37xy/Gb3iNzhFXsIZqgKxxxy99QyXG14oqvwpdXzjYB6oOB
	 Pz0Ho367YOVHIksobf0Fxb4ZsK60vbtto3ZzcXGgUjpOegEmLGYTKfR6zvX5IjCkd9
	 +tC4O4jsuvaMlEQFuqv+ByjyZyCQFXOWFNhqDza+bRlT125FRjJ7uKyQn5HSMP5DAo
	 b/dhH2ac393YhcPbCsP+ya3oU1SARvXXSUcAJK7L8L68mer45+vP+YZbuNVoJ7X+TZ
	 9f4CvU+15dVkWB1BOrKADvt9Hkr7LyZIVSmneOlNsis/TIKe3K10+EKR11q58Ud2ek
	 e315dV4Chy44w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>,  Matthew Wilcox
 <willy@infradead.org>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander
 Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,  Changyuan Lyu
 <changyuanl@google.com>,  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <bhe@redhat.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Chris Li <chrisl@kernel.org>,  Jason Miu <jasonmiu@google.com>,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
In-Reply-To: <20250910155546.GB922064@nvidia.com>
References: <20250910153443.95049-1-pratyush@kernel.org>
	<aMGc-ExhkqwAyY_C@casper.infradead.org>
	<mafs08qimjoez.fsf@yadavpratyush.com> <20250910155546.GB922064@nvidia.com>
Date: Tue, 16 Sep 2025 15:20:51 +0200
Message-ID: <mafs0zfauh6to.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF6CDA0006
X-Stat-Signature: j5m9nzzj7rps9qogymcs8m4iua36cbh1
X-Rspam-User: 
X-HE-Tag: 1758028855-928130
X-HE-Meta: U2FsdGVkX1/XTtouHWE4qERCMmnK8FzvjEphYwlRGjFQHmfvcaufWPRw4oDjaP9ItfEXW9qkHqEyoWzbRVmbtQJQMD11OQsTJFd9eIiJwNZjoFcr4nqnuTEFIQQpbOipFvIJeJs1uxLP3PBfkpAk5qrIifIgJP72gtBvO1U+43MSD+BxccwD5MxGTRsTEjO+C0R7TiyXKJYD5Ke0e3acAGf4zJDEKT0bBhxl5PRyklYQa3/PQmuudJD0lr5s5lw1zTb5qPQ3vAHLJ8KS7ITI6d+bLfA4g0h1uySYXOeqQr5lbcrkX1FiWI8z/EFmr3QV9LPfGwTBoV+/yOoEsGLYT2b6N4qH179mpJ9BB2Zc+9c6ilCj1qOAxCn9mZntu4QPqFpDenBryRZNboikImjM7eFSq+Bo+2bMFg7VXybZ9ZGniF4TLE1Aq5qJlnKttP1UxfeA8BaSIxOPi7jRSZtJQ652TSn6Hs0vwPVpX/BsCEKLrfTY1rYPoc27uSI9COQw88VPK7C1KlCHCGISVULoInXxk/twH1pLEykpS9T5PI4NJW/kbVk9v5DT4EQsuyC9trlxBQy/n0DTLvPcGDpYav1H3wNX4TOe8TJIn0Glpmzqst4QGk257OEoGYOR1mmBVEaT1psegLPtPO0pGxi5e4lHi0Qzc2DgP2wBC5tyHuST1gZOBJoyAchxZrRMN8bYTElVA0x6u/GFrKvBgMCkMohv5w1BPjt0eQWYlOHNdNA2+S91mAHumD+3gHdWx4tFYhvdMUVjJadDFIBJTNSgCugY6LPaTfB2euIeQ2ZjyJywDSPS2LQUtB3tsyCmUOWRCUVaLC1Ijb+zeylSS/ism2+776zBnF3O5LAKHwoZS43vHkOdnJ2RVg6F6hyjzQqXpk6bb828MLhKY2UovEQjZZK/4XQO6HE79SdHQYAfXZnAiqgukyOYjc2YBt236xskgzd8Ilxwt0K6U4L4N9e
 eaCKzUBA
 ssWAGDwfzaTuTYtxCDucjx5T4ML+EVCUHLKh86YEAZohLBt2yMYk5jsclEEC+cwm+hV92DO/8h77FTiLAK4aR1XM4sT21nEYS2eyfKTfXQISWxxPVBKoUewoCEpu+o0xHv942iMl33fVgA8VWoTHnJZHXFBo0VJNFDIqCVXGmnnVlDLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10 2025, Jason Gunthorpe wrote:

> On Wed, Sep 10, 2025 at 05:52:04PM +0200, Pratyush Yadav wrote:
>> On Wed, Sep 10 2025, Matthew Wilcox wrote:
>> 
>> > On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
>> >> +#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>> >> +
>> >> +/*
>> >> + * KHO uses page->private, which is an unsigned long, to store page metadata.
>> >> + * Use it to store both the magic and the order.
>> >> + */
>> >> +union kho_page_info {
>> >> +	unsigned long page_private;
>> >> +	struct {
>> >> +		unsigned int order;
>> >> +		unsigned int magic;
>> >> +	};
>> >
>> > KHO is only supported on 64-bit?
>> 
>> Yes. Currently only x86_64 and ARM64. It is mainly for hypervisor live
>> update so there isn't much reason to support it on 32-bit platforms.
>
> Presumably this will eventually change to use some special coding on the memdesc
> pointer?

Maybe. I didn't think that through yet.

>
>> >> @@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
>> >>  struct folio *kho_restore_folio(phys_addr_t phys)
>> >>  {
>> >>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>> >> -	unsigned long order;
>> >> +	union kho_page_info info;
>> >>  
>> >>  	if (!page)
>> >>  		return NULL;
>> >>  
>> >> -	order = page->private;
>> >> -	if (order > MAX_PAGE_ORDER)
>> >> +	info.page_private = page->private;
>> >> +	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)
>
> All the impossible checks shoudl be WARN_ON()

The mental model I have is that the place that introduced the
"impossible" situation should get the WARN(). So for an incorrect phys
address (leading to magic mismatch) or incorrect order (say preserved
big range using kho_preserve_phys() and restoring it using
kho_restore_folio()), the caller is responsible so it should do the
WARN(). Does that make sense?

>
>> >>  		return NULL;
>> >>  
>> >> -	kho_restore_page(page, order);
>> >> +	kho_restore_page(page, info.order);
>> >>  	return page_folio(page);
>> >
>> > This all looks very confused.  Before your patch as well as after it.
>> > I don't see anything in the current KHO code that requires the
>> > phys_addr_t to be order-aligned.
>> 
>> Right, good point. I can send that as a follow up patch. But I think
>> this patch stands on its own without that fix too.

Actually, on another look, this patch implicitly makes sure that
unaligned phys always fails. This is because deserialize_bitmap() only
sets the magic on the head page which is always aligned by the order.
For any unaligned phys, the magic will not match.

Still, would be a good idea to do a KHO_DEBUG check for alignment if
this implicit thing ever changes.

>
> Maybe it is worth adding some KHO_DEBUG kconfig to protect some of
> these extra checks?
>
> phys should be pfn_valid, phys should be aligned, the page should be
> in the right state, order should be valid, etc. All worth checking.

Makes sense. Do you suggest the magic and order checks to also be under
KHO_DEBUG, or should they always be done? I am of the opinion that it
makes sense to do them always, but I can also understand the argument
for disabling them in production for better performance.

-- 
Regards,
Pratyush Yadav

