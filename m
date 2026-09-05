Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15E2C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 01:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639466B0088; Fri,  4 Sep 2026 21:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2A76B008A; Fri,  4 Sep 2026 21:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4F06B008C; Fri,  4 Sep 2026 21:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27CE36B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:47:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1C391C1818
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:47:48 +0000 (UTC)
X-FDA: 85178022216.13.50D80D1
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73412180004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:47:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dEfaFyt8;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788572866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=th179hZpXGUDtqfRBCviJrhRmlQL2IvTDEJHG3qpgJ8=;
	b=6uzg3m2nS29FLoLWeLtC8fM51abw5LKUQat00ejXbhy6FjGrxY60D18eQZ+YZMqHTcq2Mu
	/72Mlv9WP0wq+7bSvPePCOK5xLcndlFEC22+5VZxzTYXyshfgs+LPb7Kmnx3zsKjdxvWf+
	v9iWyf5crhfz2+/rjb5uU5aKqLCqG3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788572866;
	b=DEFOBqca/ekoC5hllaH1gCI6OI59JrbmuYDo4cVXbpLWypmEWI8Z6u+J+DKGQOLNJygx7Y
	ewOkKyeTuV4bpE/+aWKRhdahFDR3Hu7c/L1/E/TqrKEYDENMHa4iwNBeN3l9cjY8epMM1n
	+36Nq2k/og5j8uHlhSNLuzv7+iZSasg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dEfaFyt8;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TUsToWMbWDdUPZfVfcX5WlBwFVjpp22QmIMA12UED+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788572863; v=1; x=1789177663;
 b=dEfaFyt87tjrHMlPR8A/XXrKpSTHttGU7NHNkbSk2vGVXN37/gS97r+bfbBBWeVQk3w0Jqsq
 RhVKtqSGOJdbtQYi5k/MZzxhVfjoqlwbiYohG13cg5X2e2PqOpaBlctqwq0o3cE2FYG8nMNtKxQ
 fD42gJeZ/YdigOr4/92ZlqCI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6a96a44c2aaa9fd1;
	Sat, 05 Sep 2026 01:47:42 +0000
X-Mizu-Trace-ID: 6a96a44c2aaa9fd1
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 18:47:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 2/7] mm/page_counter: report the number of pages
 charged
Message-ID: <apt0e6M99xvsxBrp@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-3-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-3-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73412180004
X-Stat-Signature: b9t9ie54u6id6ejthfwq9d3go3887acr
X-HE-Tag: 1788572866-838441
X-HE-Meta: U2FsdGVkX1/xiEQTKn34i5DiAU8xQ3Nb453rLbIIa3NiQx0VnxJv3/DFlUO6QoQWXMIaXdPQXe4+ur19WFohQB1Z4ODSHFCRuaJ89p+iw0AGRuJbzzUN0jlsogqLwjGNp/a53+xav3G4vtvLqdM6vvB2AELSPN9LISRPglH7DoHRxpm/haABesQl/7Wp6Q0P1GRNkPkGMoJWXy9DzaMGmxobQJEnDk9eXssNuyEF23bnwsgjf7b8YED1/9rUFBlLmq7C3CgU8yFBsIhbgIJ20LueO7HQf9eRBYfN2vGDCTsNFLXxp4sMzPvJ+R+ig39wmH9bFE7wVrFpr/c+pCTD9dCf70KpvltYRE7a8HdJ8K6WHqwCginr2GL4yW4EOCDO1UbNyOp5+2BZSVpQj9zAUILwFlo0v0GcdwZnP+KDTksD+nsL44qkU9QUxauUmVq9W5po11M3DDTXATgS48NVFFinlc1/Ns0GkFakapgGmJmSSfjcm0oosQf+VRa6UCmaQmdd2OW0wRO+tZS8Zhals+puFzWdj0mxmWy++XATek6bKnf40mEUTep1X0U2yy01EqDsoxYgA5pLlRcaho+MThnctQq0RSN0ytUNouMlB9xbzjSQBRrShpBroDD8b+xzF/kAwEqAdvWuMdUpl0/UpHI4sRfLnRiNc8NMoEigpJpgZ7iNvedQuSQpz9MHsh1EiLZAS62C+UROWxGJGf6k2pm65t0mpotTJsT/cRGjIjBfqprTawDOanOspUkjA429aLBbNZQg9WjxQWX2BIo3t8FbErSOjPSDqBLV+Zun3yjsgc11wvbOReYDYhxjG/BQ4622VXMsZHdvEou0zTLkXdV4mFBuiU9GsCZzUysVTwKrv9ox9elhiEyLI83LExFeBS8vNGyM350gTTLXXpGXLMZi4A7V3UuAyq6JGsQThYIRKz9RjXrVeO5xstlOanbT1+Tbtu4Oz48J6wiGFHl
 YH/yx/p/
 JAmijp7r2S3qJice8acGppLPb5Fzz3a/0ZjjWzUE13C4S6C9TLNRsirQoHtmgE4Na6c18x4nYUhQ1eFqZVKCCSvt1nmay97yOZyxD2p+AyOSnJ64J69xaq0eiQ8Ks9Ybrn9lP3t9xIQBVWvVuklg4aYv6A+fxY+l2me60QKFNATxszQdj11CcUE7/XjM9q7lzzSMjJc6uWnafPc7mhIAV6mMY72d1t8Pv/G8vQxO6Egl1dl6JKM1zENC8hWnDxs+yfcKligtLD0x56+ql/rhuwbj7p/BfCXEM7Md+h/rQpYPu7zwd0ZTgIX3ut9SiUE4TehhlwbBokrL5mrXoaKo9S68fq/Veb1SyBJeqBtH0vlpkSrRHOhRcTdsDDIGjDDYR3gDY/Wx1pI6QXhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:37:46AM -0700, Joshua Hahn wrote:
> Add an optional @nr_charged parameter to page_counter_try_charge.
> On success, it will be set to the number of pages actually charged to
> the hierarchy. Today this number is always @nr_pages, so there is no
> functional change.
> 
> Of the 6 callsites, only one user (try_charge_memcg) uses that
> information. The number of charged pages is added to
> current->memcg_nr_pages_over_high to indicate how many pages it charged
> to the hierarchy while over high.
> 
> Today, try_charge_memcg requests "batch" from page_counter_try_charge
> and adds that same amount to memcg_nr_pages_over_high on success, since
> page_counter_try_charge's only source of charges is the hierarchy.
> However, this invariant changes later in the series when stock is pushed
> down from the memcg level to the page_counter level, and a page_counter
> charge can be successful without growing the hierarchy size.
> 
> Plumb the new parameter to all callsites, passing NULL where the source
> of charge does not matter to the caller, and passing &nr_charged in
> try_charge_memcg to account the hierarchy size growth.

The terminology of "growing the hierarchy size" and "hierarchy size growth" is
confusing.

The code looks fine.

