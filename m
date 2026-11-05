Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2E1606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QEmAV63O
Received: by kanga.kvack.org (Postfix)
	id E769B6B05B0; Thu,  5 Nov 2026 17:25:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07426B05B1; Thu,  5 Nov 2026 17:25:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17EE6B05B2; Thu,  5 Nov 2026 17:25:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADD176B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:25:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36050140531
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:25:07 +0000 (UTC)
X-FDA: 85402497054.08.8CFCDBF
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7729740005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:25:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QEmAV63O;
	spf=pass (imf07.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793917505;
	b=YbL3B7hkVFnH6WIaAwEXcs98a9F0LgPdLKSb2d4zM95vklQnX1e4gSWjPebKYJAKP2/eBi
	tLoqAcUw5tJ6V9WaSUA1XH8mAI5/UHjJNyfb9CZdT9ifkxn+Fv2D1WNWymolnzKfEllSqQ
	/vH+c+X49XYhi86PkbUokgOYlSJbJws=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QEmAV63O;
	spf=pass (imf07.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793917505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aC+qtiKQ023bm9o1O7eQng0BAlQQoW+kw14Srbp6hgo=;
	b=SGCuRNL23vN2FH4Xm3yrwr/zJNVjaWcNElFGtXq89Af+dfTHZeb5ixXWL6Qdd090wDNfXI
	LZMO9+NebrUhRaqG7UFLiE0dTsKho+X4LgdO1W0sPvpqr6Pl3dFHQG7QXPcAr9ss1Pznvk
	1IKteXGeTzaFU/LXF+IiVklX2+gfxwU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aC+qtiKQ023bm9o1O7eQng0BAlQQoW+kw14Srbp6hgo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793917500; v=1; x=1794522300;
 b=QEmAV63Owd5BM2w6frMC5QUdHeq45kNM34HaD0v1OQq2PQulxCRLiMPjUAfpCdgJzhX7jxRd
 F7FL8QPwkH+3lzQ9TDFopccc4Jv4RLTuyls6DgNBAaUNgxHGE2ieItx68IDmXzWKsG9zWOdG5gh
 IY5pjkR0O7ME7Ws687zf08x4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 204d4cc12b5d9ed2;
	Thu, 05 Nov 2026 22:25:00 +0000
X-Mizu-Trace-ID: 204d4cc12b5d9ed2
X-Migadu-Flow: FLOW_OUT
Date: Thu, 5 Nov 2026 22:24:54 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <au0CJvc-OwFbL6lm@linux.dev>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <20261102092750.e53073b2c7b872f9d70c0711@linux-foundation.org>
 <20261105-jf-filemap-v2-akpm-testedby-reply-r1-36ef39856b46@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-jf-filemap-v2-akpm-testedby-reply-r1-36ef39856b46@linux.dev>
X-Stat-Signature: ku9cknxs5jmpposbbthbtp4mxgm5174r
X-Rspamd-Queue-Id: 7729740005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793917503-796582
X-HE-Meta: U2FsdGVkX1/6CnW25+WPtOmMxpvTQw14LD+lXS38flVgUtxDK9ikp7IC4cU1p1PJL+0LLDdCOObfz6qvz3x13JJ1veHTWeCSGuw3NAeQ9WV2EJP/MXOLFlF49vL0YAE0Ww30q0iQ1vuNDkiKrV23JjWjTVGL7AH1a2RgB8n6Qx7pzKxlCdOe7qloj/t1L8ezClv4ZUvqU6gn4bph3UStYrb3f/8mXnYO/hA53ohJWjE/Q0+Y6ugsx1PaF94TgE6GLKM+VwyV0NY0qlivXylk5N32+Fp/sTika6HbtVM6MsekwoHGkJhK1OhwzAlR7gLzKBy0/XypZsxL1fGtAbd+j+Pr5+i+eVtgQI3jr5cfPAUMvT62BxTO0RRvj0sKUq8GCA//V01Y/6xq06S3Q0743BWfUhfcfdBv2ya0Jmc0i1UxknqpGi/Bv45XlWgkVqXnl0mpOuZZwIMu4u2YE502UyoUgPdwHTnSUBC1bqaMCqF3WQzLEG9cxwaSCiPBD6GDrREDLFSJYkrVe1tMymMMECOU8nvogCWcyTUbNCu5rt3gmGfgR0YV2lZspdv0me3cbGxnM4rM/IQ2Gp7tbq9QOvg238E1VwnuASRyro80GIZEUydmRoRXI15JCxJ2lOqMQG+z2VitaWmwQRWxPvC7PEHDPhZWYFOJvwib7UxAxcrqu417n2YeFpgY3fFse9MhWVFAA43zvYR5NOR7braSCL15+vKKLAXEERJ69ebKAXv4J4+a1476SnQbJNHzZMJa/8KEXIxY7mRSwBvGcqWdEi6lSRQpkdCNJNU+9zWmt86y7dRJhQXCDKD6bl/wD45E2dsDqPo1oOzLxNjmJbxyuJOMdWvmfiF4/Kh1+N1h+SIAXg07WZDEY7xEUhXA+pQ3DWzD3SYEgk8ADxLHl2WIoypzz+OWSkq/yeWpuUUT31UPfiL62Y9mZAPbRn311Ai/yKED+Vijx8ITAT6a6sP
 0lvgVqhR
 7ZCxlrAnOvct+KuR0n1/C8AbETO6vD90x7i/cYomkWWxUTcXt8ARyhqKXc1cscD0Di1mHu1oNV4EtnIX2rESzOyiPHLiRYDew8MZZu+Ju9GjE6sUWYzV8y01QSORLNyqamC5exMWAWvs94C64dXXBw1N6TjTr1aQZeskazvJ5vsAaDoYcw3AdxCImuA6G+mKpZY3OKD2vlCvDc2jhNuIgXp7/5eF9vEtIzyk9qb0GRmuEmb0uiiN2QD7EdSgWA5UuxkrAGNB1xTbXDOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 22:13:34 +0000, Jose Fernandez wrote:
> I ran it under the stress test from my reply to Pedro in this thread.

I also ran the check_multi_find_4 test that comes with the patch. It
fails without the fix and passes with it. The stress test only ran with
the fix applied.

- Jose

