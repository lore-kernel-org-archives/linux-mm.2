Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB88C606A868
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IBuVOV73
Received: by kanga.kvack.org (Postfix)
	id DD32E6B05CF; Wed,  4 Nov 2026 16:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB3A6B05D0; Wed,  4 Nov 2026 16:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8AE6B05D1; Wed,  4 Nov 2026 16:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC81E6B05CF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:18:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28A1F120716
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:18:19 +0000 (UTC)
X-FDA: 85398699918.25.BE1727C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E2A5C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:18:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBuVOV73;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827097;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVBo0F+lHYpHmKchrj85xaTTXEU57RF1wEb5LwPjMj8=;
	b=rXkOb7KtLcLqfF0OrhkTJMRSVv7wbx/q8oQ7bB6DQVfxWE1yOXDm3R+gYTJs0989FpdYtV
	88+LB0I9qZ0TT0U5RiUqrJhT69NihsAeR/DM9CQ+0rhiqu46IGuRSftvEkigTbSmtRTtFw
	xxQ7Vn/8NyrFaHmb3wEmrRJwJuw6zQQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IBuVOV73;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793827097;
	b=ktm54Fk/NdJY3+koMf3t1V3JuR9PA41HFZKa6I3tIw3Ca6rMKSGNpc05FhTqpGrsjWiBSK
	O/mNn7QBOK8KDgKYWKs1avMkRWPtaSXiQfTMAe4bIUz88ONjInjylXpARxKvQdpRmT2zok
	FuHYkoD/4vxVI0jNVgl6+Qg5YzWOKY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFA804229D;
	Wed,  4 Nov 2026 21:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEAE1F0093A;
	Wed,  4 Nov 2026 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793827096;
	bh=eVBo0F+lHYpHmKchrj85xaTTXEU57RF1wEb5LwPjMj8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IBuVOV73t0oIuUjFzqLCd3dqXgzPZ/jr/UqQVI9rDaQquWg0OpLUcK6vXEkfXE2E/
	 QM7PHRE7VTP3SAzsj+GSiWh+6Hseu9YKHHGlh6SMPszJVXkX1BJre6TL4jeg/WJxVa
	 vHPpX9K3VRBe8NGqN5Mj5TD1+vPlPXSy+yE25d4vP9OtqzaY2w9pialk4zXHtAzHNR
	 8fkiHwuNh/Fb+TZmE81N6Vq1hjJj44BLy2yf1veIRHUdT676cUqh+HrWstAqn24gA9
	 kMhtg3079A333cyK7oyA/tYPxaQl2ME54XCSXAEnuw4CKpD2dvSBG5VzOkNBhZXDCn
	 WrBMb7AFe0CDQ==
Message-ID: <sashiko-outbox-198087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 4/7] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261103211754.35352-5-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-5-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:18:15 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E2A5C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7djncawd9kmrx97i6tcb89iopo3jrnq9
X-HE-Tag: 1793827097-473754
X-HE-Meta: U2FsdGVkX19ugOUAZcW+VgpFXPnJi261eZoz8pounWjDWOUlM3CYjJIs8uuteV1ijwCj6Xp8l1AndrWemncY36wP9/Wk3Wpw1RCr8JbRM8oCeoNRoZGSaYjz87kIaqSOLCTVPF1jHN3FNkjMWvpBgK6Qk3nfeg6rBiQlsJT5RmzoaIUp6H9KBt6Xr2P0bxKUiZb0wnyVz0Jwy8ujo1LmjEdYM9p3acB8CsTrh4TiEa5/RKaLqth3gMH1fwp8o+Rz0NZyvZ+m5dJrq/dgAsoVl0S/zaweBc+8JNY7+UA63K5wGT9vosiUCiIpAm+IkNUi+keGVIZ2kK/kNoY+8hDGScZI2mNzKFMmg2c7aadVh2BNPR26mHf6NLQ9wyxLow84cInOTLvxPsWKcuHUV6RVpiHOO8/9jLr7QEISxa/ZK/LB0Q4vnVqwkljZQHb1AxqwqZZXCnaNA27nL5BlD+U7F5l15TnfkLtaFXItVqS3ofaUDLcUSJRqm9Wh68SW8JxfqYNTHPL7OFDZw1Ba5TQDJ5tInguNOrzRX6Js9jix3rKyml/hP3QcRkiU5d3fmgGMN2Q4UdH8OfG0+/UZ10lPk2QARHUC3lHkBBnoraVVxyzx8DX1DqDMnfCbC4G2qp1ZwGairldKEcNDTiFHDpcXHJOXgtDEoxjU8zNVvWjEqdRViPM9vX34Pa4cr8iCIJPu7uSotxV7d8mUf4tCQW1v0TDymOmCVb+ObxssEMEOxXD+AKO4OiMC/W3rywwK24OcFpUXRlLy+4jeT/qxS+4gfKkmlttSwRFr+aNshJLYycHpNIqDp0aortrioGiFUxJgJdkBk5p9z5WgsEikZTQDyDoqgmyD6jVszOwC1fTSQ+Pj6gL32qUOc0ml+M0EL+4Liew/C4LDVaqtT/QZbDAZO4vkz67vlCmzWzYbBsr/0vglymets7CeaszfEn1Urv2TzyZnVMnMI/hx9PqtuA+
 kxoCrpbk
 e5/TC1IHXCE3cx7SWDz1joKKcpmK2g9mdqCFYtiYbYKrmLQ7Ui5WTxc9f1/ozhSbssIK1gXaAnG2Tl66Y3vvXJtJ6qLviydJaFSNLuhQq2hiPKYLm3ljNLkkyvHiUMWRnp+IuPV/Ra4DZrzeu+h8iV3+XDDRiIvSKnnBy1cB6mlTkP3BC/K6PmuW3pgOIzjpR0NPtPgXjf4bCsMq7McBmVF2OiB/dEWbcgJYmlIyI0qG4ql5HLdriedyv/f0nK5ESlv6JUwfg0U93esHLSWjV6PTtkCbt9TekDTvRImz6WFZOt3Yx3LW14PHnTLGCUdTbqrPT9Rm+0YmHSs1lFsTHPV4eFtlwJuo5MvBKIUT3+1uOQGfuJlCRRKzyj4KoFWk8qeNOjeY6uPmwnrD53P65yhK3RQaX9THs8QZOUCPRmlRzu2VHTogv5Gi4OO/l+qyoaCgWQPOMa+5IHU0MnM3DXzsAMNVZ+2knoNEq60zSazzD6GfkNJwT9ZfjA6dn5PtjEom0IOIgsI85Oql4GZ4+SPGfZKSsxHbi3nGgg6co5KKosnQn6Sxa6DoCi3yeux8L1D6CJJFc/L7URkdJfeV89s3wsjkuoZNf8+/lxMDq/UpXIhGKLbRPzH3aPVmRAms05RgB3be5gl445dMP8wvXxyxn9I+W2SxswKL8fl4f5IcdChsLTKZ9rW+Dq9ZD37JaJf5FlB2t3qXRSxy/2a41E23B3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: double WB_DONTCACHE_DIRTY accounting in folio_mark_dropbehin=
d()
--

commit 22fee9ca43388b4bd59c934777df4d9990967b8e
Author: Mike Snitzer <snitzer@kernel.org>

mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it

This commit introduces folio_mark_dropbehind() to mark a locked folio
with PG_dropbehind and increment WB_DONTCACHE_DIRTY under the i_pages
lock when both PG_dirty and PAGECACHE_TAG_DIRTY are set.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3a13289c07dc4..5134227ba3a23 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1643,6 +1643,38 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  If the fo=
lio
> + * is already counted as dirty, which with the i_pages lock held means b=
oth
> + * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so t=
hat
> + * the clean that subtracts it leaves the counter balanced.
> + */
> +void folio_mark_dropbehind(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +	unsigned long flags;
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (folio_test_dropbehind(folio))
> +		return;
> +	if (!mapping || !mapping_can_writeback(mapping)) {
> +		folio_set_dropbehind(folio);
> +		return;
> +	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	folio_set_dropbehind(folio);
> +	if (folio_test_dirty(folio) &&
> +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    folio_nr_pages(folio));
> +	xa_unlock_irqrestore(&mapping->i_pages, flags);
> +}

[Severity: Medium]
As reported by Sashiko on v9 [1], can WB_DONTCACHE_DIRTY be double-counted
in folio_mark_dropbehind() when a stale PAGECACHE_TAG_DIRTY mark coincides
with an unlocked dirtier that has just set PG_dirty?

Specifically, PAGECACHE_TAG_DIRTY can remain set in mapping->i_pages on a
clean folio after __folio_cancel_dirty() clears PG_dirty and calls
folio_account_cleaned():

mm/page-writeback.c:__folio_cancel_dirty() {
	...
		if (folio_test_clear_dirty(folio))
			folio_account_cleaned(folio, wb);
	...
}

(or after folio_clear_dirty_for_io() clears PG_dirty and writeback exits
early before calling folio_start_writeback()).

If an unlocked dirtier that does not hold the folio lock (such as
zap_present_folio_ptes() -> folio_mark_dirty() -> filemap_dirty_folio()
under the PTE lock) then runs concurrently, it sets PG_dirty before
acquiring mapping->i_pages.xa_lock in __folio_mark_dirty():

mm/page-writeback.c:filemap_dirty_folio() {
	folio_ clamp/test:
	if (folio_test_set_dirty(folio))
		return false;

	__folio_mark_dirty(folio, mapping, !folio_has_attached_private(folio));
}

If folio_mark_dropbehind() acquires mapping->i_pages.xa_lock in that
window, it sets PG_dropbehind, observes both folio_test_dirty(folio) and
the stale PAGECACHE_TAG_DIRTY mark as true, and adds folio_nr_pages(folio)
to WB_DONTCACHE_DIRTY.

When __folio_mark_dirty() subsequently acquires mapping->i_pages.xa_lock,
folio_account_dirtied() sees PG_dropbehind set and adds
folio_nr_pages(folio) to WB_DONTCACHE_DIRTY a second time:

mm/page-writeback.c:folio_account_dirtied() {
	...
		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
		if (folio_test_dropbehind(folio))
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
}

When the folio is later cleaned, WB_DONTCACHE_DIRTY is only decremented
once, leaving a permanent positive drift in the counter.

[1] https://lore.kernel.org/r/sashiko-outbox-184464@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211754.3535=
2-1-snitzer@kernel.org?part=3D4

