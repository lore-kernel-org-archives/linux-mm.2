Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F61606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bD0aREKl
Received: by kanga.kvack.org (Postfix)
	id E34EE6B06B8; Wed, 21 Oct 2026 06:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5BE6B06BA; Wed, 21 Oct 2026 06:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD49D6B06BB; Wed, 21 Oct 2026 06:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC3A6B06B8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:53:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 192B3804D8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:53:14 +0000 (UTC)
X-FDA: 85346321508.25.FC0694B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B18C10000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:53:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bD0aREKl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMLVnnDM9TfSfMpUppQf1/87O9OPgyCoy93iqIcO2rs=;
	b=MvGqdOP0Nkykt59a1wmWLJ2ee7Ejk6mqi+czgXmZ+2UU8VQig5QeCQeStHn3RX5IMIkycn
	IaPvOsooDIizKs4tjwFO6haDPzLIWi7y+3uXFIswj8d2gpl+KEoaMbHvneT9fDp3rTMS1H
	4s+79vAPWN3xoMy7LZ181qOdGPI+uYQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bD0aREKl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579992;
	b=5dXC/BNEBXtxgW3nr03EnBrBlKxkPieLuC8VKJS2VtgyDFZTo9Vpd1Fg6CIwrvW02wtPfT
	XkwsZEIedNXKqwYBkUNUKog9RbKynZ3kRQ3iC2IijmCRJuPCTWChpEcyf7gvPhmdYE1tfm
	4qVLBO1hsCWU+s9OUOqDPridpmpE8wM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7DEE6021E;
	Wed, 21 Oct 2026 10:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363C1F000C9;
	Wed, 21 Oct 2026 10:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579991;
	bh=gMLVnnDM9TfSfMpUppQf1/87O9OPgyCoy93iqIcO2rs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bD0aREKlvvHtB8UL3zZ3KTvP55m3iQg7PJbTukXdUEHg7Z2dHxMz4ywzNVpgDXmA4
	 x0N631ipCR7GDV25tqOWNUBqXAPzTNxWGQ5PKl34pdD/kQdVkokz58K14imlZpWH3p
	 kIJb34nBl/rO/8mBwmO0H52d/bqjQpAy36u+owlCnqRPLI4ZYwsmaWJaf/FimC2Iy5
	 b3+/T4+hcAU00TFo/fhb1JlccM9ww5SARPvkUN5LuLgdEpaXRcvZl5VfrxJxpIkVjd
	 jqfLdDUxdf1z45ir3D+Pwr6MqdpoZNUO18owuqfJTkSn+uYyf3D+WfGVzQ0jWvKw64
	 7oPVl0BgaQdiA==
Message-ID: <8b666ab283f58e5913b3e4c33c52742a1153e9bd.camel@kernel.org>
Subject: Re: [PATCH v7 2/5] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
From: Jeff Layton <jlayton@kernel.org>
To: Mike Snitzer <snitzer@hammerspace.com>, Chuck Lever <cel@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>, Olga
 Kornievskaia	 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom
 Talpey <tom@talpey.com>,  Christoph Hellwig	 <hch@lst.de>, Jens Axboe
 <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,  Jonathan Corbet	
 <corbet@lwn.net>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Date: Wed, 21 Oct 2026 06:52:59 -0400
In-Reply-To: <20261020220346.28020-3-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
	 <20261020220346.28020-3-snitzer@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6B18C10000E
X-Stat-Signature: d9whma3xad64bdm3t66w8p7xxz4wmqa5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792579992-497039
X-HE-Meta: U2FsdGVkX181AyzSJSV03JPXUC2UySdoD5zkpNCbSQJZQVyyvrue96o+jx4BDtolGGDDHDfxmGyVB3yMqfshgV8gkcaEsym8T1GExDAUSck9Zd4XXK5tJRPs4cBmqITh2KijhfoXwfxTpzf0BJLkjEFKEh5x+CBHZap8tto317oyYxA89P3IgdwvtBshn8nBVG3kA0T+7rO/G5C1bSVT1f4MTfV8AI2gwqo/DieWq/3ROPLzpRKkODUr8diOV3UGrfHMDVkr9plwsSH35r5LAbFVhpVFh12/A7Dkhfcs99Zmptf7TEdvRIgAfnOJ/EC+kXrVjC/ZbisU+nOoXB2ly06RewBfqbv53h5JDMt81kC+RtjFWScpHJ6KX1OcKIw8zNT+7KN2lczlg1Q1VfLxcrEzE9DbbacEcf0PUUd2/RK6AlrWM97UJ5W6kF8SEQVMwy/vnfQTFuzufUmJHJKi7o61qVF2C5yBn5mdOR0nQQPn+fGKadNNBqCzYqljX7ILfXbF6D0zvkea3mNJYeDjNXkFiS0ZdiMhZoIv9RL6iyR6tOyTpzd+EY1ZklUJ46C35BYrzK4cfma1Ts8Ec7bad4zPIfLNIDV4owVRwZO0k5vMYgdyTGdHs0+RP7dl+sC0weuA5nrAUfqmIiNCnnYxuxh1X2b9WN6c+AaNWbxeLOwQ2xYuEfwy25FntIkFHGrAEsJSUpb6UCbaC4smIsImEKfvvGp3454keiJZTCCTHAMkYKaN5HvDzqAk4D2U45edjOx9WX6aEtbNE62sa8w/Rft3uu8oFYS5RP1XbmTlcI5fn7RKMBp3xdrFuG1oCd2jazYbBfkcaL1GbtvHi7v7qoJCcJLga+WObjfzx55HrOLtdsFQlP+WQ8mh950El02xBFJngllzX4WBNJNRUPshbqRS8OG9QVjl40PHsxOY1/8uPFjWDmQNIoV01ALok/b7xjq2RHktHMhsQwTRS3c
 j8Q5gUAX
 Hy52wJFlFfHnWco4tu2axfRlJ1gJYnxRd7ZDehLL7lNqaXPcbhsazT3qAJUB1EZmOPi3CavKg7C20MQQbkT79IOkqAN4mxVJbgsbO44XgxUnOvjm+QKt7vMRpYcPIJfZa0S+8oXAKF2/oQLxhYapuh9RZHq07m35Yht/1LwJem7syAxT6wINnV4sRS4oFcMocaFogHcnXa0/hN0nbpfrsQbPgrkJsxrE3uj4qkfMPLASbm/v4xDMZpxqwx3qPuIg27WOryPiwPzZ9G08HdTN6qQ8Yt3GHhuLLh6CvF3PwsCfeO3ItW15i+jPYrZdgfo1qskQJnDenkFePr+wX7a0OMa6FTwfyuS2XpmUNtImWIciNxO7/fKIGrcqkHC8vtNgIJ1fK5v+tY3VjayBcR7JYSPFnh7k8b/SXMlqh8kEjsBDDhReZAmFNHHFEBpAqsx7omcD5qpPaPIGqhAIIJirSCk1znwJSIcbruo29tPjPJ/j/0s4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-20 at 18:03 -0400, Mike Snitzer wrote:
> A folio allocated by an RWF_DONTCACHE write is marked dropbehind before
> it is dirtied, so folio_account_dirtied() adds it to WB_DONTCACHE_DIRTY
> and folio_clear_dirty_for_io() or folio_account_cleaned() subtracts it
> when it is cleaned.  Nothing marks a folio that already exists.  A
> caller that sets PG_dropbehind on a folio that is already dirty
> unbalances the counter: the clean subtracts what was never added, and
> once the counter goes negative, wb_stat_sum() reads it as zero and the
> DONTCACHE writeback kick stops writing anything back for every writer
> on that bdi_writeback.
>=20
> Add folio_mark_dropbehind(), the inverse of the clear in
> __filemap_get_folio_mpol(): with the folio locked, mark it and, if it is
> dirty, add it to WB_DONTCACHE_DIRTY.  The folio lock orders this
> against dirtying and against folio_clear_dirty_for_io().  A concurrent
> lookup without FGP_DONTCACHE that clears the flag again subtracts what
> this added.
>=20
> The name follows folio_set_dirty() and folio_mark_dirty(): the first
> only sets PG_dirty, the second also accounts the dirty folio.
> folio_set_dropbehind() likewise only sets PG_dropbehind, and
> folio_mark_dropbehind() also accounts it in WB_DONTCACHE_DIRTY.
>=20
> A later commit uses it in NFSD to drop a page shared by two misaligned
> WRITEs once both have written it.
>=20
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  include/linux/pagemap.h |  1 +
>  mm/filemap.c            | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
>=20
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 0adfa6605653..3012bd95812a 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1310,6 +1310,7 @@ void end_page_writeback(struct page *page);
>  void folio_end_writeback(struct folio *folio);
>  void folio_end_writeback_no_dropbehind(struct folio *folio);
>  void folio_end_dropbehind(struct folio *folio);
> +void folio_mark_dropbehind(struct folio *folio);
>  void folio_wait_stable(struct folio *folio);
>  void __folio_mark_dirty(struct folio *folio, struct address_space *, int=
 warn);
>  void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb=
);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f55..ed7e4dbea653 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1644,6 +1644,37 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  A folio t=
hat
> + * is already dirty is added to WB_DONTCACHE_DIRTY, as folio_account_dir=
tied()
> + * would have added it had it been marked when dirtied, so that the clea=
n
> + * that subtracts it leaves the counter balanced.
> + */
> +void folio_mark_dropbehind(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (folio_test_dropbehind(folio))
> +		return;
> +	folio_set_dropbehind(folio);
> +	if (mapping && folio_test_dirty(folio) &&
> +	    mapping_can_writeback(mapping)) {
> +		struct inode *inode =3D mapping->host;
> +		struct bdi_writeback *wb;
> +		struct wb_lock_cookie cookie =3D {};
> +
> +		wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, folio_nr_pages(folio));
> +		unlocked_inode_to_wb_end(inode, &cookie);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
> +
>  /**
>   * folio_end_writeback_no_dropbehind - End writeback against a folio.
>   * @folio: The folio.

Chuck's sashiko had a comment on this one:

[Severity: Medium]
Could this overcount WB_DONTCACHE_DIRTY if folio_mark_dropbehind() races wi=
th
filemap_dirty_folio() in mm/page-writeback.c? The dirtying path can set
PG_dirty before folio_account_dirtied() checks PG_dropbehind, and it need n=
ot
hold the folio lock. If folio_mark_dropbehind() sets PG_dropbehind after th=
at
dirty transition but before the accounting check, both paths increment the
counter, while folio_account_cleaned() subtracts it only once. The later NF=
SD
use of this helper retains the same interleaving. Could the flag update and
dirty accounting be serialized so the counter is incremented only once?
--=20
Jeff Layton <jlayton@kernel.org>

