Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE8C606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVhlZskd
Received: by kanga.kvack.org (Postfix)
	id 4BA3B6B02EA; Thu, 22 Oct 2026 19:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B8B6B02ED; Thu, 22 Oct 2026 19:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381B06B02EF; Thu, 22 Oct 2026 19:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93B3B6B02EA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:16:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97DFAA7BAB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:16:02 +0000 (UTC)
X-FDA: 85351822164.20.C2A7671
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3F7E2000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:16:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVhlZskd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792710961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBg17K/M2nYjg0CJ2VB8RcMiLnQd34uRF9TAFezMHP8=;
	b=iHi7P0QrCTol5k1Hw5lQudgBakrZi5PhAxb8erxEHuaSledTQ9y6y37W5AEKT0iLTZ/5S5
	O4FKhJsqwv+4UtmKSDq3dEtMebrF8GLNhG1FhAaubQiE1hFcoTqvfDvUNvQpfw/cwsjF2j
	2zHL3X1gPhYnzTDwKEq7qZEbOnk5hoY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVhlZskd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792710961;
	b=aSvWB8DtKZdCHB7l7u/vWJLEWfrcD3HgJns4Zr7l+zx/FkDhW0n3jxRINxGYLSG3BK3F0/
	+DMkUNGdkvKwCRt1n+Ad6fU6NE7FKqTBJr0V9gPOMAmM+JO2EW88y+dNQo9iFIsqo5z75t
	i5hTHmBT1cZ0Ae6HyCKZ2VcsS46FYaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DA156022E;
	Thu, 22 Oct 2026 23:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB81F01825;
	Thu, 22 Oct 2026 23:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792710959;
	bh=EBg17K/M2nYjg0CJ2VB8RcMiLnQd34uRF9TAFezMHP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gVhlZskdTjjRGcb1sPLj5Vhn+WjGwji3C+5JBi46aBSw++60J4o+IrdTWTd/k0crC
	 1GCz+CzKZGtls6nwJ9Q0xU3uiOWZpJx8nfJjKY81yvnzDXsRUFbEdo4kaG7XziAG1A
	 M/0x6gHH63L9JaLKj8X643ZcDLNaHJjmqDApvDrgI5RC+xDowbhcmlcBe7DoJj1xLB
	 wj43MwjCYJNt+jOiqPjWBlVzEfQIWKbmhEMCJxrSbqUINUi+PXYC3SYCRIpPkYc3HR
	 b7LIMG0vBU6zF6jhCEWOmiYv4dMx5winYRDr7X/ZMUW4p21zDlNCkBJM06h6GBd9dD
	 W6YIoYbC9Gheg==
Date: Thu, 22 Oct 2026 19:15:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Mike Snitzer <snitzer@hammerspace.com>, Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 2/5] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Message-ID: <atqZLryFXwjiUboe@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
 <20261020220346.28020-3-snitzer@kernel.org>
 <8b666ab283f58e5913b3e4c33c52742a1153e9bd.camel@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b666ab283f58e5913b3e4c33c52742a1153e9bd.camel@kernel.org>
X-Rspamd-Queue-Id: F3F7E2000B
X-Stat-Signature: 7nhsuxprpk5teg66yo3n5w88xiqate9h
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792710960-369601
X-HE-Meta: U2FsdGVkX19F/WAN8vQqPN5IVZ5Hmz5foeMi6p3mbD4Gc70DBhajUpl3moFfMbBn+cljjUCTXHVM7aBdv6NAv31Spet7HFLrbgvTn6ZFEuN2u3IeRtuuTc3oCG524pkm5u+MEX/31xLQcRCIRDbB5QvA86+b93N/Przvbn0lzPyKmMyokiurlyqwaZANP1nb+W98aPtPtPYU2TkOCV+zCyLllopGSJ7qrZz2q3r5r1zHUwTbuiFdLhsJnp6tHcnBaPgIT61TlHGyKXn6P+g/5qWCFYkBrKhJN5tzBu8LV/4OcG6GP/JjmZZzfp3TMAwmxrmLHp2mgNRcvh3m7lBU3aIkM3PQYQu8EDk+zQu+f7HWdvcC6yLQJ9garrTVHHoEQPhxHAjP9iN1u5YIKmczRRUIPvzhPZDyspAuO/EJp0b39t+hqNZUt5Y1OqlgcX+9b8FKHyBHoilqc57yPXJz5UB8l9h8mZIF4CDL8sKeJlzaTS5+w/EF+QVvcX8dqvX1wDx1pz2CBmy3j+aCracSFIgnuvE7fSGZx6uJmAYRNfkSbZ/w2g8F5CmCJnyhlGrQui1SngEhfoIQADwHJ3yixXx8de390uuhaMcYprR3ZlqIdbotBqJCC62EgYLUHu1RxswcpAp7jOlk5mbxv3Xh0zLT27U1Yhesgf2TXoDFqvvkm+0OoXUBS5yVmzUsKPBUtHyHtgUurORzqPwW9Vxgars+dhURld+3CxbiwidmqstnXQ5q1jnVZbimt5rIa9wHrXFI8kGuCeA+Ds/ae4QLUzosx+zpV4VAPpa3T3igpwO0zP9hcIsSawImWbwuDgoUCjf9RN8+6YkFYlp1dqvKMQnYtVVk1X03AHuyvRx8DyBN/Zv1jXB4DiXoK1CAOG02r7Tf6tLafVbq9yYlls0kNatjMBsZmT0syn3x5+E2ImL/dmTVRUYwJO8P3txYtnK5h2KvkkXx2fDcex1E9X9
 n2R0uSR0
 jYZnR2tRpkR7+IQCxKK5Lsfjr4j7ZuUaxijqFgF1OvPNzto+kMsOqs+yk9wUJdx2sL7Y9zI7uwAvhsW77Ta1XG8KlcTdLVXI+xgzj/MHVU4upXVLjT+XG1HKrR8BzdSRaRNyLClrvrkv524B5oai4esdmFF5+RllwSDbQoJqecAzCh17vHND1kpFG5dMC+F8JDPtMgdpGBygPWCEeSekvC7ZKwFyYXpQU5CpwkihrQf+YAnBGukitrJ8ARE1+I4Eh8M92IYrulm1mU8yKYejhLneSFaEzkYNGwybt14wKH1j04UctVUR8sM5khs0r5eq+QjuQ7Mynu5U0euMlktAFkKiAxxdN7phzeD8l/mgkrDvJLgHTN7ecx1iBFFfSoBWAspKc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 06:52:59AM -0400, Jeff Layton wrote:
> 
> Chuck's sashiko had a comment on this one:
> 
> [Severity: Medium]
> Could this overcount WB_DONTCACHE_DIRTY if folio_mark_dropbehind() races with
> filemap_dirty_folio() in mm/page-writeback.c? The dirtying path can set
> PG_dirty before folio_account_dirtied() checks PG_dropbehind, and it need not
> hold the folio lock. If folio_mark_dropbehind() sets PG_dropbehind after that
> dirty transition but before the accounting check, both paths increment the
> counter, while folio_account_cleaned() subtracts it only once. The later NFSD
> use of this helper retains the same interleaving. Could the flag update and
> dirty accounting be serialized so the counter is incremented only once?

Yes, it can double count.  Every path that takes a folio off
WB_DONTCACHE_DIRTY holds the folio lock, as folio_mark_dropbehind()'s
callers do, but folio_account_dirtied() adds under the i_pages lock
after filemap_dirty_folio() has set PG_dirty without it.  So
PG_dirty is the wrong test: it is set before the folio is counted.
Reaching it needs a dirtier that doesn't hold the folio lock, such as a
zap of a dirty pte in a shared file mapping or bio_set_pages_dirty()
after a direct read into one; the cost is a counter the DONTCACHE kick
reads too high, not data.

v8 will test what folio_account_dirtied() leaves behind instead: the
dirty tag, which __folio_mark_dirty() sets in the same i_pages section
that counts the folio.  With the folio locked nothing can clean it, so
the tag is set exactly when the folio has been counted, and taking the
i_pages lock around setting the flag and testing the tag orders it
against that section:

        xa_lock_irqsave(&mapping->i_pages, flags);
        folio_set_dropbehind(folio);
        if (xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
                wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
                            folio_nr_pages(folio));
        xa_unlock_irqrestore(&mapping->i_pages, flags);

A dirtier past folio_test_set_dirty() but not yet in that section finds
the flag set and counts the folio itself.

The same interleaving undercounts in the clear path that 88d6f128d06d
("mm: track DONTCACHE dirty pages per bdi_writeback") added to
__filemap_get_folio_mpol(): it clears the flag and subtracts if
PG_dirty is set, which a dirtier that has set PG_dirty but not yet
counted the folio makes it do for a folio that was never added.  The
same change, clearing instead of setting, fixes that; I will send it
as its own fix for 88d6f128d06d, at the start of this series for v8.

Thanks,
Mike

