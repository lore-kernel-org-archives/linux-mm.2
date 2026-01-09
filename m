Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D0DD1A639
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C4B6B0089; Fri,  9 Jan 2026 09:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7256B008A; Fri,  9 Jan 2026 09:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06306B008C; Fri,  9 Jan 2026 09:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 923CF6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:45:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 419AB13BF97
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:45:04 +0000 (UTC)
X-FDA: 84312697728.21.0D55F96
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1C9DC0002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:45:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHJcKxj2;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767969902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoZEkcP81J9S3LDfhd18FIDcOfNOHxVwqIdavyFjCcY=;
	b=ju/oc+xGuch4Iak0YnKEXCZNVsJj9Fgi1ogiJ4/79wPTpZhZpjUp2IjikEU10AOFpYhvX7
	kv2Wx8mlfhz/G+NgiNXv6EYs+i7yXCXz403CuYP8AaqZM7r9NPtXL+rpvI+y00gvmSpuE+
	NKXFCoyTkTL/gmyES4QXtfyksawOerM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHJcKxj2;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767969902; a=rsa-sha256;
	cv=none;
	b=eufm7T2NDRDF0N+4iv7jmrTMf8oxGL4pnX9abe6SRFCQOIqr+cgTMmNprty/tr1tNGCcdJ
	3eN3v80p710BtN4qZgcVRaoCWsoqbsDM8D7A4dUWlOvxe6Wltblor86Inmmdg8SwOZL2OL
	ar+7j+kvB1oohEGH77+tNiVrwNVy3pM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YoZEkcP81J9S3LDfhd18FIDcOfNOHxVwqIdavyFjCcY=; b=BHJcKxj2yeh95VRAEMy+WwO+hX
	ucUCoR6gGGXhz/d2SOVoCO1+FR/lX5MJzHmYTJV9BOP5ugNsAenGQkjSFok27X94Wyypa/Z+zBboy
	gqQJwG5kdFbvRp0H/WlrlbiQ8clbkMRQlQQU3veYfj961e5yof7tzKWuUb+6NUnkSywc//0jnCdy5
	eEGai36Ud9I+LLKFHormnIRTX/PVJewliP66fCB5C+OVGshRIe6Ko/2mRQC5fuSI7fodvXZgazijl
	0I1+VYC4OsYGkMdajZiMc9+FoY0pd2esYb7DU4SxY05QZASZi3FxgREgpQATFGNLncSgTLz+WE2U3
	oRGX8OEQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veDjT-0000000GuRO-018d;
	Fri, 09 Jan 2026 14:44:55 +0000
Date: Fri, 9 Jan 2026 14:44:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>, linux-mm@kvack.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] migrate: Correct lock ordering for hugetlb file
 folios
Message-ID: <aWEUZiKX7QC0xtMy@casper.infradead.org>
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-2-willy@infradead.org>
 <509ac447-e5a7-4cba-86b8-e9c0e72fc93c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509ac447-e5a7-4cba-86b8-e9c0e72fc93c@kernel.org>
X-Rspam-User: 
X-Stat-Signature: kromfzgqdunsncm9pzssoaniz1w9kh7b
X-Rspamd-Queue-Id: E1C9DC0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1767969901-69979
X-HE-Meta: U2FsdGVkX1/aBFvA71n2O1GlGR/5B0MOrg41FwKkTPjQzHO88RUvV4iuYl4kfkVdq5feI003kG2ryxFSLiZTsjH9aiVLnMBEt1EwM9PNoKTx1ahqtkI0qfa8tgVlhLJVxJ07lNnCqwKJSuvoIKoSSPsrCnkI874VnVdMWjqZ7PJjXTGGY/8PqXGyp7GOENonUyAA0veR7qN95gU7S/uc6nheExkIWyDqsuWIH8lPJ54ornxKMmS4R39aP47ZlequTBgZ4jNuZTcV1j9LWTltwn0EsRv/ig22TQZ81Sep3TvVTglp/IsLJI5kKLWmbo/sF5uVuk0MFgTtSDHQy0WD/Pg9RbYesWbrCfs+goNVVqvlZCz1HvXMB3U6Z9j+wdbiyfpam4TjC6G79AiuKNM9M2ExNhnuBTTRRhJEt65Y0MKI3AFH8E5ZqO7k+OINi5+gVzqgz4NaErD9uM/RPJO9YdJ4Gy773TS3PZCvb+fUBSKSP91x+UUsozk3oXlksfuv/mwO4BF3l8ovGBDOhN+R9sCCabhAmWhJvSpMeMpi+TZGCX0+pQv8NfkIkKU0Y9We9Kfqld0cPkMOnl0+PIxFvA51yZr0De6HOYfYlWRMjaXm6CLliNIlP2xzcCatlwpuZe1ZLefkVg3NiF8BdbweUCxy5zHdLX6734boVSANPomWDc6g/SrTh2syzDkfakenSOxochMFRbUG/PtgDlneYyCR9qSMIeffe0toD65l/liSBpO12T0gDyXJA0TAjYivvSSeygUO4C+8fYZrDO+jw0Zfz9LESlPAvQ+9sKLOH/v9rj4M1eHM8mEUJiJO2mKXxH7ojiir8nBmkj9hNqwRrCsFuvHTzCom5sV0LueyFGJlWRd28QMfb9ZRd750W1XbAl0qhyvW9vfQZfj7hq/lhleqoANNKR9ZkOeK55tsmumsQWidMyp1vc8K1mSfTTpCF3KvosCJOj2NmesG8n/
 QeMbomo3
 B69GcCTX4aVK1aGImzoIyZ3WiN+NcgQT4VEE1VWYxYTbU3ZccqLFdgD04d+VUvHtQUI/7GQesM13S4vsDQv4gz8w01gm294gxBQxhKrvG95cbALX6JPmAjCPeI2W9nIKeBdQU/ihElgcknyhRmVZhd5vAVHarSaZaP6JqhmJyb9ujHM8vQ/j1eLEtIGmeECT1pfO0zzB7jP8+Ir9fSADFrmMmqzK0M6dQGCkdLUMfXzUZfq8QRBDVFP7twJaO/OGGnudym47wcyuNvdwcKaqFet3EnSck/kz0fso9g/JBhq503stCDXz/yRAEKdFVZ3xHB0sxH14dFX5UcIZ3LJ+6SmX5yh8KcrvMDcyGbJlI1QTtc0PnLNnWtnBxYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 02:50:26PM +0100, David Hildenbrand (Red Hat) wrote:
> We now handle file-backed folios correctly I think. Could we somehow
> also be in trouble for anon folios? Because there, we'd still take the
> rmap lock after grabbing the folio lock.

We're now pretty far afield from my area of MM expertise, but since using
AI is now encouraged, I will confidently state that only file-backed
hugetlb folios have this inversion of the rmap lock and folio lock.
anon hugetlb folios follow the normal rules.  And it's all because
of PMD sharing, which isn't needed in the anon case but is needed for
file-backed.

So once mshare is in, we can remove this wart.

> >   	if (page_was_mapped)
> > -		remove_migration_ptes(src, !rc ? dst : src, 0);
> > +		remove_migration_ptes(src, !rc ? dst : src,
> > +				ttu ? RMP_LOCKED : 0);
> 
> 	(ttu & TTU_RMAP_LOCKED) ? RMP_LOCKED : 0)
> 
> Would be cleaner, but I see how you clean that up in #2. :)

Yes, that would be more future-proof, but this code has no future ;-)

> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks!

