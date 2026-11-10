Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B94D606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KcOCCYWA
Received: by kanga.kvack.org (Postfix)
	id 52DA76B05BD; Tue, 10 Nov 2026 07:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5086B05E3; Tue, 10 Nov 2026 07:04:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4866B05E4; Tue, 10 Nov 2026 07:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 146C76B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4C0B16061B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:38 +0000 (UTC)
X-FDA: 85419077436.25.53B0709
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E3FA1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcOCCYWA;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312277;
	b=48/5X4aqV12FjXldrys6J5YJ32XT0Le4keqwozk2csA/j8YnJRHd/pdVj5aFqn6BHaYi8R
	4mKw20envzyhcghs5E9TWAjKBDqiCet5RfUDRMGLIGsqGNxjnGK4eNa2kB0teSGyVKIiWO
	ptFpjWlqpWb4ImVmDXlom+8QVIzVdqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcOCCYWA;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312277;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrygS1/RGf9WTTPg4mDCAkP4sfA4sEob9F/O4w3E0hk=;
	b=H9HkjSyaBP/DnT9q9RSNR2SavE/oDQo3ahgFpHbtZ76njVQ6C9QBOID+MUZEfRsAgzVu1W
	lNtArYTJXYYPwlKF4o08phxIGsgTzI4PeErVsSx00xWR9MeL0OQEAnlabgbo+fdqI6C7xz
	NrhYAl63ExsnoqtbBMBoVLAh1BKDk4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 630A641800;
	Tue, 10 Nov 2026 12:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE2D1F0089F;
	Tue, 10 Nov 2026 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312276;
	bh=jrygS1/RGf9WTTPg4mDCAkP4sfA4sEob9F/O4w3E0hk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KcOCCYWABoQtL9shv6zPEwfz36Q9vRKXw6kS6PUCkAF29BUIifBZeJ3ZX1ZSu2M/H
	 A9E58n2FVlp8ZuKlB+OxwSeA5yfk3por7FvaXW67VvLcYF0WC/YVoLmcgoWKju/Dzt
	 ngn/x6YEp3sYFKPyRTzy/+bdA6T67d+Jdi9F+SRc/o0H6uJGGQKMDd6chbYAVvjmBL
	 UnojlpFZBqADtU2Z81mFRSeFnazfmFeDvaP5iPRQg1/WHGEZuXYBt7aKSvdB/yp6c5
	 QtU4TBeyxdDgh+vnFkG7GvcfiHWoxEw34GifTgEEcQA7Q8/G2uuxm7E9aC4d9zedCT
	 tjtEPbqWuOFaw==
Message-ID: <sashiko-outbox-206973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQg?=
 =?utf-8?b?KEFybSk=?= <david@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Hugh
 Dickins" <hughd@google.com>, "Chris Mason" <mason@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261109120403.82361-2-kas@kernel.org>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:04:35 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E3FA1C0006
X-Stat-Signature: 9fdhjchzrru65a57udx5rojdtgwjpgjp
X-Rspam-User: 
X-HE-Tag: 1794312276-38768
X-HE-Meta: U2FsdGVkX1+NSelg/fSG/TAv5z6z4FyhlCk1FsfnwlNqqVKNRlDcrxdHTqbwDc+Z9RBTSxuBhxj9Xu1AcJ2nu0UryR+o37KgpUrRxwiRG7krMSqUdJBPEyRloGOTsmsy5ej2nTkxaQP7PpB4V6xM5mdYmIDu/ZWJhjUsGm+w7CxPOY0jZ08UGeuQpPfALhtSCt2Y6rNhfqfh2fd7P/v7Poyq81q7UBioNAMIFMRva2H7r1j1nym3yAniF3s8fbqt8RD9dqq9n8Y9PLU2ujCUJXeUn6miaMemZYHVProBNRqFkqpDZvTWYFaQ8O5CYkTFyaDmO9k0d0n1rHks9/kTBPaoA28K4nDyB8jNE43B0IIPaLjL/dw6vVmECBWs5pI6/fxTxbpPyHiF1yANaspdIaIABVg9lZPCOgISHBMC5vBW92k2p8lzdqKBy0uZ19GKWegJ4UkSDhG7kAEVpMdvHp0cdTMLTLM7ikNEcGG4Hvy79lGaOS6OCkdOEg+fSIP8HEMEIBRaQEWPx/SyFdjozGp9mJmKdHd4eaduJgqPDAIoyR4/MNHpGxCChgX4oi+oE6jjmhSa8eMI2fY6YCYfmyj9FMCVxAtjBtO7dGnsbJdx7aLwgDMdVy/XtpDut2dXhKIkz1sPSwxESpe+t5MsN975kGVb6yiq4DRTQjSjzKkI5xr14t0Oqsm0or9xOrrYHefx6kiaGNnOg8cxSrMkTH4TAAzSe43m8YNr/EkbE/W/pFQIf+tF7OUXZUdpqTokVFz0ZqoFmLVxIhva0+FckXtJasSmmFwCWTYstCCU8KK8BGxx4H6VFNUpMSjYX0Pr2x12G4IH4lyHV+cA2HzwNloZ7ME4PeEdc8G6O+XVMwCEgD8JsoNvD6kMUjSXMrsANnYhg1tToBvPDI6e3064ooueE1enp2emMS+R9V1+SZRdWPpHLFHo0TCxZniHnpKa4ykAzuoq6ificu1W0W8
 876Rz8TZ
 7Lf9RDG+qdjo4zxi5A5ZY4YfC5aaHUll8PzDnmEFWfGDUHbSp+X91wfwXKtEF58yFF5Q/+ZfhfOxE3FfOUErQRu5T9UukPX05V0u1nI9//EuCnED+ZF5YXLqinwdt8YcuLzNP8KB/LVL2slZr8RdupVX3nvLDrj3NuQN4HsRutEBIfTnWxHl6kRyzqz9NgNjZTReCfQ+rAT4gVC7Aw4NchgZKzLVT0lUM8KqPT2EccTpYvQY8miLk2a++UNYviEOEWSqrl4knClD7SHsize8gKTzerVUj7VRIKoLudvQD4sVznUEIZxuR4uiL1nUHQeioLkzAT/RehT/kCD2g0f3HdpUVwGYk2lmrHGUHlt4pA78fr8/Fc/HHBwy+Gx2jzlyUY7AXV5UMQC1ingyKHV6fwQo0HqBtDRD5MG57Qfcx+iBq3AqO1c8LFJA29l/GWRCfndJ+CqS5DulCoTn1N1iTFczm/xnSzMitsY9R1Be9BqYvvxaHZp+1gBcDrtHnF4mRhqyriGXnfRXeLXd0rEbdW39/GiPVWU2442qZ/UeF2B7X830VZGyWHOwQ8cpinlge/PgqxHW9rOGzDWhxgODWIAbZ0FzJ9hF8e3J5S3dTv7ZPxSp90wte8LQOJBzk9r6ug51aTJ+irG8zwr2Wyww97VaLqC1NK0XriJTkZfgURO3J4QNxNWxBWYdYAUPdI7p5GphKExgWIfmDBsB0emhmTdmE+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/memory: PG_uptodate check in do_shared_fault() runs after
  ->page_mkwrite()
--

commit 700a620ccdd59b966f387e178bdcded1ac07e9a0
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/memory: recheck PG_uptodate after ->page_mkwrite()

This commit rechecks whether a file folio is still uptodate in
do_shared_fault() after ->page_mkwrite() returns with the folio locked,
retrying the fault if PG_uptodate was cleared while the folio was unlocked.

> diff --git a/mm/memory.c b/mm/memory.c
> index fe72e66c9c2ee..cc1d0b7d15c75 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

> @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault =
*vmf)
>  			folio_put(folio);
>  			return tmp;
>  		}
> +
> +		/*
> +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> +		 */
> +		if (unlikely(file_folio_not_uptodate(folio))) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			return VM_FAULT_NOPAGE;
> +		}
>  	}
> =20
>  	ret |=3D finish_fault(vmf);

[Severity: High]
Does checking file_folio_not_uptodate(folio) after do_page_mkwrite() run too
late once ->page_mkwrite() has already dirtied the folio or set PG_uptodate
back on it?

In the race with ecryptfs_writepages(), writeback clears PG_dirty via
folio_clear_dirty_for_io() and then clears PG_uptodate when encryption fail=
s.
When filemap_page_mkwrite() runs next, it relocks the folio, checks only
folio->mapping !=3D mapping, and calls folio_mark_dirty():

mm/filemap.c:filemap_page_mkwrite() {
	...
	folio_lock(folio);
	if (folio->mapping !=3D mapping) {
		folio_unlock(folio);
		ret =3D VM_FAULT_NOPAGE;
		goto out;
	}
	/*
	 * We mark the folio dirty already here so that when freeze is in
	 * progress, we are guaranteed that writeback during freezing will
	 * see the dirty folio and writeprotect it again.
	 */
	folio_mark_dirty(folio);
	...
}

Before returning to do_shared_fault(), folio_mark_dirty() ->
__folio_mark_dirty() triggers WARN_ON_ONCE(warn && !folio_test_uptodate(fol=
io))
and tags the non-uptodate folio PAGECACHE_TAG_DIRTY.  When do_shared_fault()
then aborts with VM_FAULT_NOPAGE, the non-uptodate folio is left unlocked a=
nd
dirty in the page cache, where writeback can pick it up again or reclaim
cannot evict it.

On filesystems whose ->page_mkwrite() goes through block_page_mkwrite() or
btrfs_page_mkwrite(), block_commit_write() and btrfs_folio_set_uptodate() s=
et
PG_uptodate back on a full folio without reading from disk, so
file_folio_not_uptodate(folio) returns false and the invalidated folio is
still mapped into userspace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109120403.8236=
1-1-kas@kernel.org?part=3D1

