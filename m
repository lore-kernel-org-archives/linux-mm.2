Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1917F5A8DA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0A46B0088; Mon, 20 Apr 2026 23:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072306B0089; Mon, 20 Apr 2026 23:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2466B008A; Mon, 20 Apr 2026 23:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB95E6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:45:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C0965C6DE
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:45:51 +0000 (UTC)
X-FDA: 84681174102.07.CAEAF9F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23B8A20003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:45:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FwnwfsJN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0g7slwHV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FwnwfsJN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0g7slwHV;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776743149; a=rsa-sha256;
	cv=none;
	b=gweqHLsik4hr0BVY33M5Lb/BHfYgFxtNt/DPunLO5AQWnGiDsZr4/oMtlCNlmz32sEdkqA
	/wu81W0r7rfD/x4Rj3rhlVqe/g7llM/5ytGM4MAIuhJW4pKZvkD3dLHZMMgtpdkF8ZTOCr
	2QQz6zGNiLyzVDCDDAe5ILoLcVuOi+I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FwnwfsJN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0g7slwHV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FwnwfsJN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0g7slwHV;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776743149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJfTWXk1mSbZKfRW0DNvuHTmZm6Tw2gEEwGye/AIRbg=;
	b=6Lto2wu+ZkfpPPs8g8lUA04eB+/DaM57VoDSZpOrp7WM6xQnCrn4J5szJ6NF13IGbnZs2e
	umL1BhqCizA2pJSsWYiqqLAL76ZGUMIzWKRm1Vh5Renx7yGpiglm4mQynLy7k/HnuMos1d
	5T89cwTLVEq2O7bXTXR+3Ne/F4digGw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46DCF6A7EA;
	Tue, 21 Apr 2026 03:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776743147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJfTWXk1mSbZKfRW0DNvuHTmZm6Tw2gEEwGye/AIRbg=;
	b=FwnwfsJNvJQyvE7l3cZfssEq4WjipWOchHPpCqYz8LwmH6Lmo4/24QiaMzyyBHixkRk2Oa
	MwuJTB0IcEOhwQzhpCCeVMOh9sNxCCEzpo4GLEbJ0KtsHSY19OyMkQDAofkMXzyNPLSRgK
	xGKCMsBZAoyXj6XV7ATB+ZIxX6pv6qM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776743147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJfTWXk1mSbZKfRW0DNvuHTmZm6Tw2gEEwGye/AIRbg=;
	b=0g7slwHVd1GI62pXsPEDF4i5WYqsG2QxlBjPi3h2Aoz/fswC+9NDUJM0gq63WiR24nZtWp
	RNRv9RnJqNtv4xCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776743147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJfTWXk1mSbZKfRW0DNvuHTmZm6Tw2gEEwGye/AIRbg=;
	b=FwnwfsJNvJQyvE7l3cZfssEq4WjipWOchHPpCqYz8LwmH6Lmo4/24QiaMzyyBHixkRk2Oa
	MwuJTB0IcEOhwQzhpCCeVMOh9sNxCCEzpo4GLEbJ0KtsHSY19OyMkQDAofkMXzyNPLSRgK
	xGKCMsBZAoyXj6XV7ATB+ZIxX6pv6qM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776743147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJfTWXk1mSbZKfRW0DNvuHTmZm6Tw2gEEwGye/AIRbg=;
	b=0g7slwHVd1GI62pXsPEDF4i5WYqsG2QxlBjPi3h2Aoz/fswC+9NDUJM0gq63WiR24nZtWp
	RNRv9RnJqNtv4xCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58617593AF;
	Tue, 21 Apr 2026 03:45:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U/DjEury5ml4VwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 21 Apr 2026 03:45:46 +0000
Date: Tue, 21 Apr 2026 05:45:40 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm/sparse-vmemmap: Fix vmemmap accounting
 underflow
Message-ID: <aeby5KB7E8Hr8l6G@localhost.localdomain>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421022044.1217503-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 6bqjd176ti6cctskb1rai1wiz74edc31
X-Rspam-User: 
X-Rspamd-Queue-Id: 23B8A20003
X-HE-Tag: 1776743148-242019
X-HE-Meta: U2FsdGVkX1+62GTS+SUCKQYtE2XF2sbbxg0TM4JKbzFsEOtcEuZMLuBzGpwBsPW4jZ3Dl96xgSrvafbCJYh8xY1j2wywuEnZPqze+niIpj6uKsG++sA1qy+meWIXZOyM3qpESdQqRDQL3fgJ0PwvdYgDL4GVxd/wLru4dQcGVHTrIq/CbumQpnvCqEvz9gw3+b+84maVQ5TmtFsCztkbaPYpasXMWSCEJdnETqcTZmtnng8nw3RJyR8X8qlM8UlEq9nOZnd4gkGD1xDZifUQSLebcwDRjVDey60DD7SkU51IpEYNgYyT+DHNR6m0/ZR3Y2Ank83BbSX36PL/aBmkCDOl3GSqbns9jEV1JqAiLo957nRGlNXu2QCSfvn1PGoSvTBV9NwfCD9cZ0cNBNlDBDFTCOGymH0gg0pJ9GCZOY+ImlwAkxrdrJnJj9yjWelGhMrRm1oIaCoQVZawAqUosx92Od4dOAcXhCNcXVt06eCZ4EF753w2DtDZ1Ui/7f9ybQRqMdYqVRRzAQq/kaCu0yDbsp/wJ5jJ2Mkvxd0D+e4lOfobEoklQMV3U0P5sG0ie6byUm4HtyLzLyT9LWk+QfAKYxuYxRyFZ3RMaXVKElfyYCiMsFldNMVrauo6plFIiF1ipNUfPt/DF3Q+e36TkJVoNrWe1Gn0sRID8SGAYDazs9mfsi2ZEcFWy5hcxYpMPrs5rG21nrU0r7A2726SmTNjAwGQlZRZxdpZe61zkAYj561xmNMe+QebyrUbkOAG051Q/zKuQzSi9zJUK68GxVNX8x55C0xPvEZPZMKv5mTiKB+lfYF/YCrjTOiMmZhUdQn4G6+I6cHrZzmnsDsJ+u5fj9i7HFLzdw6+ripyNCimJheuhc39bQaMnzP3bTy6EN1nl3NqpHIDHXWYJsIra5SOEMeosRXHkuPC7Lir1SzdgOHXW1UUzaFZFMS/oKiuQiyjYs5r9i0Ri9hHH6+
 0zIWL+dM
 0QBWK6YQhcXMRVco1ZZGqcamEOOLAqEIygW55S1pXbPXKomEfJLyj9guyQnGn9K7AjGqAcxifmEm1zvFKNUT1CgNuJT0WARGW0r5mbp09U0FVbDdO1cebTHP0JaVfuDbxdwbnJlTAPJVgcODXMtsIMLTXk1pJNjC8uwrq5dPxlBExkc/g70yzVuEWRhBNp2htVa3Pjqktj3IO4Ujy+6yJ57NwtpKIcu+slUFnjvwAbmG/v0M97sMqq1Orhtvtmx7u+D/UVj3Z2+V8jMpys+iizo8ykJXuQp2G5FlndHTYZbnr0963/+bfjRgzbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:20:41AM +0800, Muchun Song wrote:
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> causes a vmemmap accounting imbalance.
> 
> Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, the failure path unconditionally calls
> section_deactivate(), which decreases the vmemmap count. Consequently,
> a failure in populate_section_memmap() leads to an accounting underflow,
> incorrectly reducing the system's tracked vmemmap usage.
> 
> Fix this more thoroughly by moving all accounting calls into the lower
> level functions that actually perform the vmemmap allocation and freeing:
> 
>   - populate_section_memmap() accounts for newly allocated vmemmap pages
>   - depopulate_section_memmap() unaccounts when vmemmap is freed
> 
> This ensures proper accounting in all code paths, including error
> handling and early section cases.
> 
> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

