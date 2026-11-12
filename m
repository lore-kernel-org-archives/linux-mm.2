Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E63606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VmTXplA6;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nCSh6HC5;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VmTXplA6;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nCSh6HC5
Received: by kanga.kvack.org (Postfix)
	id DDDD16B00EF; Thu, 12 Nov 2026 11:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB60A6B05B0; Thu, 12 Nov 2026 11:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD3D6B05B5; Thu, 12 Nov 2026 11:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A897A6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:10:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 776191A0579
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:10:57 +0000 (UTC)
X-FDA: 85426955754.21.1CDFB6F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C4A81C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:10:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmTXplA6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nCSh6HC5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmTXplA6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nCSh6HC5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TY1S6pONlaEy8PXrW1EyxT+5Cb+KB7r0xzu7FeRkMVI=;
	b=sdQZupfcfpxGc+Z1LNR8AqdpPAZiO/EIunOoG73+bccFThcs4gumRYx8lCABLYakZaDqpe
	qL2b0Cqz9Zjx9qBBz8aOjpFZ7HGarJr5tfiYLZOdpxskXZjOxsIoWu9t2K0/MGZvqsL12C
	hEOLxx2ZwGlTqTJFlj3lAkVb7OVcRFc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmTXplA6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nCSh6HC5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VmTXplA6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nCSh6HC5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499855;
	b=Am8GrGFx6JD/BXRSea5VXVBltj8eI0fPXi+dfYukJODHDSN2/7pBtrdtZATGzXUfXhILMh
	QG/UzF+4Yz0XgQh1txfJrl0LA5+uzwK3KHXyl7xiyX56AxTj0AD6WdHeNXwxrw8WJKqywh
	npCRyi1dIcuBuEtRw7mfZ6VSNJ+5wJY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E67B121FD9;
	Thu, 12 Nov 2026 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TY1S6pONlaEy8PXrW1EyxT+5Cb+KB7r0xzu7FeRkMVI=;
	b=VmTXplA6oiq409l1Q8u7Qgt4p69886cSyQzzPQ+YtJM0kaW9AbMPBie11VAtJTRFumr7xa
	ccBHcDBXf4Dw5mf+p9Ns8XyI80zNFbN8mHlEjK8X+7BOleqSXDENKhhsj++cONKNtCKOO/
	UKE8Mt4aLjyZ/8g4gE/ytLGkegf6710=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TY1S6pONlaEy8PXrW1EyxT+5Cb+KB7r0xzu7FeRkMVI=;
	b=nCSh6HC5G9PTcri4c07C8tEqlSP++XFq6z49AbkySWcUnri5AmuUdcJpMRiT8NlWzG3i7l
	skLZ8ZekpBADvLBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TY1S6pONlaEy8PXrW1EyxT+5Cb+KB7r0xzu7FeRkMVI=;
	b=VmTXplA6oiq409l1Q8u7Qgt4p69886cSyQzzPQ+YtJM0kaW9AbMPBie11VAtJTRFumr7xa
	ccBHcDBXf4Dw5mf+p9Ns8XyI80zNFbN8mHlEjK8X+7BOleqSXDENKhhsj++cONKNtCKOO/
	UKE8Mt4aLjyZ/8g4gE/ytLGkegf6710=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TY1S6pONlaEy8PXrW1EyxT+5Cb+KB7r0xzu7FeRkMVI=;
	b=nCSh6HC5G9PTcri4c07C8tEqlSP++XFq6z49AbkySWcUnri5AmuUdcJpMRiT8NlWzG3i7l
	skLZ8ZekpBADvLBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36FD913432;
	Thu, 12 Nov 2026 16:10:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4wFHAQjl9WrTLgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 16:10:48 +0000
Date: Thu, 12 Nov 2026 16:10:46 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 9/9] RFC: net: limit folio refcount when splicing from
 sockets
Message-ID: <avXk3dPpE8dNEOi2@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-9-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-9-318625d63a98@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C4A81C0009
X-Stat-Signature: bf9on5z43z9b5f76dcumwka7t7ptht89
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794499855-270605
X-HE-Meta: U2FsdGVkX1/P7dZuqQ5Z2GxJPgePObm8Jd6xId58tAIJV0BJoMns0CLWE/ZF091UtmlWxSt3kXsmq5efFuDFN68cmQk1YNZw0JoYUUlfhtkTtxg4kLWGG50Ugf9R/rT5WTli2o74aG9twd/12bEHDe3ubb20VLW8Ocff8nlUcqpbuH5Iwv9/+TFmA+R0OD/n19KinYkwROpi4F9wwK0+gpx9x5gEnVi60BuUcpj30smTiZWxdOwiPq+mKGtfLhMTh1wfo0TkO+eW7e5ZVifpWp+r0WhjV7lb2o/XHXi8KNE56dKNMd9DSQe2++LLa21b8AlwCoFutTzmHaHhfFhwjrEQojlu6DY4qBT71i6jRuJ0IDyD2CoFo8ORFbEPP+H4+ci8erh8jFoafCXeW3sbNqlPdCjQAKIbmEsDCfAM9DIY81Eh214TSlbo/CQudgxBEDoFXxFwuO6L5pJqVkyJSQXCA/cy351+JD/ejdeekHyUB1+qkChkD/7lISy/PMNozXFRcu+VFUKs+UKiWpKVvKLiEpYyjcnXWTTUbHk8VTKRcBoz6Zbp+xrBDBEFVyoTSoIIepfoO+vFUTpKvFkEmOQ1mu8D8USEVo3lkMsNccdqBU29ugTZY9RtGoVrFpM8aWCJ0U3KEyUkYuL3lvKemwhbLxFRHbM9loUhkOh9XW8PM2KdzawmsFwN6mFJr+cCOJgudrD9GDjLt8HVny1C3utTsmwi0yOok+fgEsoSRBcAZORfhHwr89U0ZdVor9DzYh7b7g9ztseGvXbx8RydjouMSAvA0z1z/xJk/mEEdtQvFVfhLO/2N0xXkf4yq/gNPK66xapMmxv0rQJYyxmFT/uO938GKJARP201D7W2kzYsraWUcXUJ5hh/E6Eg1rZSxAQ9daF+qDr70pOW3fvLAow3blZp6KPz8se/ar63ZLnxQblinX2FWrrK9Yib2SvAcEY0NN6hulIWWpmgINZ
 DLJL8lo6
 uX0QiWRq1uBYFVVScarkQKd4ZHYw4DydqdD62SaDMZHSlOwYKqB3bAelQqru9+hbxjXJYoyrr1NOhqDxSEdO4u44LapxG4DGaGgHba/H1vP17rRLDHUGA5O6pbJkgS1VF3syVJ/sMTe+V2IK0wUC+7TCJz88tAL89d2DfOG0CexenisSwhIviXrvgfMykMrPaZtTQpofU7rVn1Z4djRu3pXXjBCG9ZF66qMwH07uHt/jFSQL0D3TyMZpMN71Bl+VtWNmd+x4CRssZb6doiDBs9exSR9CB9PJvOnnn3lxZn7gaVplrnbRIQ9Z1F+9bGM3A4VjAgP8Cxe935HMgXD+UdKVhOEDEPzC6MmSZi3Er9bfM1AI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:49PM +0100, David Hildenbrand (Arm) wrote:
> Various networking features support splicing data from sockets into
> pipes (TCP, AF_UNIX, KCM, kTLS), whereby spd_fill_page() takes an
> additional page reference for each fragment, while the skb keeps its own
> reference until it was fully consumed. This allows for exceeding folio
> refcount limits.
> 
> This is not specific to large pagecache folios, but with them it is a
> lot easier to reach the refcount limit, as page table mappings can cheaply
> create many references.
> 
> Let's use try_get_page() in spd_fill_page() and stop splicing with
> -EFAULT if that fails. To propagate the error, let spd_fill_page(),
> __splice_segment() and __skb_splice_bits() return an int instead of a
> bool. If we could not splice anything, return the error from
> skb_splice_bits(): returning 0 would make the callers (TCP, AF_UNIX, KCM,
> kTLS) report EOF, although data is still queued. The callers already
> handle errors.
> 
> Use -EFAULT, consistent with splice_folio_into_pipe().
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

