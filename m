Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EFBF46446
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7E66B0177; Mon, 16 Mar 2026 06:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF846B0178; Mon, 16 Mar 2026 06:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6626B0179; Mon, 16 Mar 2026 06:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEF346B0177
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:13:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 839C41A01A3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:13:30 +0000 (UTC)
X-FDA: 84551514180.30.309E80C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id B7B3D40012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:13:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GtR6ulxl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMGqjhYGheXdeL0YxuFwQSpgFTVcLscLtzpDIsQK/28=;
	b=sFTGffIQCplH34vhSiPFOmImlDeNamD0Er+x66yYMtcz2cbKzgyb8w6e3bXX1+f65rS2NB
	W1lFMZGaTIZbYPJK55PIRPKQSiTZ+96CzCnud1ZQjJWYFZlM3gfxxTYvdbzsQtSosSBBKx
	WLt++1DYaLIvJqhz1WhMqZJhE7XFqXo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GtR6ulxl;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656008; a=rsa-sha256;
	cv=none;
	b=4wC1CG6wmDOMzLNZjGokR7xFxbVv9n5VumC401YmK7J6bWsulEgqFud87pW+CsNTwFWekB
	fP/F/gr+TR/qm4xf/qozh1gsl3ueZ8IRmV3qphsPj7tS1fDS+3rMgC9U3ca7S6WO8/sTLP
	uCUVUdQTk04UTm0Sx+xjRzMujQ1TuI4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PMGqjhYGheXdeL0YxuFwQSpgFTVcLscLtzpDIsQK/28=; b=GtR6ulxlBEWy60LKh5iSh4feQM
	O6HFJZ2Z5VjZcqKplOhTD1WR/F3FMVeUWRx3iBHAuiG0E2Yo75X5f9UqISpKQEs+C8aTPeWcjyJaj
	iQOg8opYbm5Yj0mOQJ5vq6z2aCUjQBCmJaqBPGwYOsHusSTbKWiu8GI1MLRAfH2IH6e3xrNgOse9G
	R70Nv3Y7az4lQrQd+hSxkcgmqyjs2H/H+WYUVPjgAQQxQamtihIDbaF46Nqqr5opWyBoitlKsg/0A
	0SI8pGGPFEeETZ6qNirdJJx+F4YkaUsGc37bRhlyT7btpp5wc2pSKLlKu/Ocu6gKZfOWu4YgQlLB5
	QWOW9GMA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w24wV-0022S5-Fz; Mon, 16 Mar 2026 10:12:58 +0000
Date: Mon, 16 Mar 2026 03:12:51 -0700
From: Breno Leitao <leitao@debian.org>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <abfVLky1zanZyEx8@gmail.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: B7B3D40012
X-Stat-Signature: h8e88rgks74xfi8db16xp47mmph7e1ot
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773656008-758554
X-HE-Meta: U2FsdGVkX1/gQwyM+aM3RHWLd64fU+Bh4kCPmwuzvhWoELVp6kJH7eF82ioxJdMj6MXhxBuXgleJVCUdA9R82t38GOqoi28A/JsnA0Bn1d0+wIhkissw4TKbNPwboUiPXv6rkhAlkkJPPCV/Sv+tOtZ+SairDqL1qXx35HhQX1yosbckGQ4orTi2ASTPzWJfrLpPGa4kV/eJLHm16RJ4BLKat3kwL5sPHhkJVOWygmXq/fq9EooaSq1DzM4dkBMr/ZvbufHnXo5TdvjlEOg6PPHqKtEL/uMXgdLzKU4WsdT7tOvqunwEkOTfYswGD2gzgCj5tQy7pdjVJBKK2tPzlUtTQHQhZB0VYGC/al4aBJehk6M+Ro/ddFmG96rq5DFc5UHr/V7Zf+DITRV78toqkX82/MEfx7c3zvbmP/ob3zgrLwVXFljQ4XktBRvzSJb4tpYjyn/bt1/rI527H/PbKkSgRYVCnVvrBjnaKlmPgkLjycTaN3m/q2fP7CdsWkyl9faYCt8x+JqKTJe6z+6HrdT7nixk5Vb9IUQlDXqZ1kZ+kW4elEiBtW6hL5Nhjlw+XVNResOI5h8gyi3PJJ/9iyzPuVjfOEfNSF9acZ9IyThBYhzxHE2t38MiZj/HlRvgJLDMcc1v62F+zbt93mTG7lunCg4u8BeJehJHdOpG3eN9qdPzm79N/dXraWxY1mUTIGU1HmusPUezZKDRMMRTIAfB7pwAR60YuV6F5mPIwpvufu8w33cV3I9vVJRe7LVhuyxcSdG3N5pZh5VaNdr90HZkA5QwGnjNMPckpKMyPNSHphcOTCCY/2xLH+ixZhMa3Jx828BgdSEqBX/ErslCphvxZj2k0v7ZrjP4CUL7Os0NjpGuhadngmd69dnf4vJLmTj/5Yhpb0L5JzHEFRfKEg4X9RvGDD4DWLidxzfIcJggMyDcl6f6K8MBlTwmq0UKQgZRvVwGo7mPebX70DG
 MbAj86JD
 etD5UZahlpBieUOZaYpqJEf1KGpzEOeHzaKgKSagfeRSocKklGbe5w3l14owgpfsKj7EWmJp3K0F/CxdHYmOZrCwZjo20WzGv58g32gDm6uDNIgRk+XnHC7HeL1MN3I3o/9wCDJIltzWXlTR1MKRFlo0MYEYtvncdUxZ1LFKUSvUQEbar87rksU7qn8yanPmTcS2iH4qifU856q2WzpRV8GCcQQlOO72W5Pue0Lp2kTrjvjvFwrKXey8avw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sohil,

On Fri, Mar 13, 2026 at 03:31:25PM -0700, Sohil Mehta wrote:
> Hello,
> 
> On 3/11/2026 3:17 AM, Breno Leitao wrote:
> 
> > +static bool set_global_enabled_mode(enum global_enabled_mode mode)
> > +{
> > +	static const unsigned long thp_flags[] = {
> > +		TRANSPARENT_HUGEPAGE_FLAG,
> > +		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> > +	};
> > +	enum global_enabled_mode m;
> > +	bool changed = false;
> > +
> > +	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
> > +		if (m == mode)
> > +			changed |= !__test_and_set_bit(thp_flags[m],
> > +						       &transparent_hugepage_flags);
> > +		else
> > +			changed |= __test_and_clear_bit(thp_flags[m],
> > +							&transparent_hugepage_flags);
> 
> I am not a mm expert and typically do not follow the mm list. Is there
> an issue with the usage of non-atomic variants here? The commit message
> says this uses the same pattern as set_anon_enabled_mode().
> 
> However, set_anon_enabled_mode() has a spinlock=>huge_anon_orders_lock
> protecting the access. But, transparent_hugepage_flags seems to be
> unprotected in that regard.

I don't think that the atomic vs non-atomic will not help much, given
this is a compoud operation. Independently if this is atomic or not, it
is racy with anyone changing these fields (transparent_hugepage_flags).
In other words, Atomic ops make each individual bit flip safe, but
set_global_enabled_mode() and defrag_store() need to flip multiple bits
as a group. With atomic ops, two concurrent writers can still interleave
and leave the flags in an invalid state.

That said, Although I don't think this patch is making it worse, I think
the is a racy issue here that we can make better. 

My suggestion is to move the rest of the helpers (defrag_store()) to use
sysfs_match_string(), and then create a thp_flags_lock spinlock to
protect operations against transparent_hugepage_flags. Any concern about
this approach?

Thanks for reviewing it,
--breno

