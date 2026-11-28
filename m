Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA3D606A336
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hm+95tWO
Received: by kanga.kvack.org (Postfix)
	id 67C6E6B05B1; Sat, 28 Nov 2026 03:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652B86B05B2; Sat, 28 Nov 2026 03:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A416B05B3; Sat, 28 Nov 2026 03:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E97EE6B05B1
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:49:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C1FEC0602
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:49:21 +0000 (UTC)
X-FDA: 85483903722.06.C82745D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE24B40007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:49:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hm+95tWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795855759;
	b=5yOrb/SiBT3QZtxg7ktkoeeeARo3KUXFN90gxOIE8TSFoluGhqWWk2szgzQ6nOq/jYYWpb
	9D5vzNmJAskgXCMBQo/MFdTsgYV/YSYXSMf10eSSCYqHDdmKywU5x8xY5LKCBHb96grAhk
	k4ePMJ3fDBGBy1SlULt/+yW0O9MthR4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795855759;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+21YVgeXQXRrM6JQU5o844vwDVBFtZuPkBB+5g1Lbo=;
	b=oBAaLBGbMloJ72yc95phcvzptM3wsj6V0AV610Jz8pU+LNc0pOlh5nUfznULrF2d8IitOU
	F60BRMt89ajqXRYXraKtBu9FQ1qfwS3mR9fRozo93yirLP89dDCaFVr17qB1yzL06NcqIX
	yjTw2x8WG0LbGNI3QbjLbkf0iRdqt3s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hm+95tWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 457D760A4E;
	Sat, 28 Nov 2026 08:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CACE1F00898;
	Sat, 28 Nov 2026 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795855759;
	bh=q+21YVgeXQXRrM6JQU5o844vwDVBFtZuPkBB+5g1Lbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hm+95tWOcNNrTp7zIy9IYNmhCSzB7PjesxjnC720sk27GwlknMh+AJQjWTGTeqKwq
	 snVjFrHwN1wUbEnCmOx32vzmleYLpPq061GpWQI8xSXBHc1xMAaO28gGE+TavHjo+8
	 siyKyCPD5sb+uqJoSwZMXdsnttOOGssKO1uMwocDKdvLCRBnGzPKaHmh9mQS3KFVOT
	 kYiOOAeJFi9QDJhcySfsZNXsBXirgCFXM0iBlWFzS2vYi9AasuXidHd+jcwLdCdC0a
	 7aKKQ/mUOc9t/lux+bLn75bz9Eeb+l9V7TgQhOrUHcp6gAlmyDWAr/yMUuPsANRlCH
	 lnj0E38tMEiWg==
Message-ID: <sashiko-outbox-238563@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] f2fs: enable buffered RWF_DONTCACHE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wenjie Qi" <qwjhust@gmail.com>, jaegeuk@kernel.org, chao@kernel.org
Cc: hch@lst.de, jack@suse.cz, axboe@kernel.dk, tz2294@columbia.edu, baohua@kernel.org, linux-mm@kvack.org, qiwenjie@xiaomi.com, syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
In-Reply-To: <cfdfaea72b21b8abf58cb250495150d92e73beda.1795746008.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
 <cover.1788795700.git.qiwenjie@xiaomi.com>
 <cover.1795746008.git.qiwenjie@xiaomi.com>
 <cfdfaea72b21b8abf58cb250495150d92e73beda.1795746008.git.qiwenjie@xiaomi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 08:49:18 +0000
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE24B40007
X-Stat-Signature: nrjkdxouzrxdex439sgbiz3zj58s678s
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795855759-284452
X-HE-Meta: U2FsdGVkX197P5beVsoFMKg7DW5GlYUfvQci3nhz/uymFLp0IMh6b3EZcQE3dzeJT+nOoAew+98L0vL9GLBm36pKdvwYr5sClg3l+kCBikaRozw7BnzpT1TC7iR9GzUQIhc0tYRmoa31OOGGg8ecOVMT7EgYvi5ZPXYpksJM98mHowBUT8SkUD+UrRBIwsMU3BknjmV0VSSHHJwHYwhcE/4C/G10wzCxlmZC4M6YT6UfXVsRiAjsMyEKWfZCxOAEwTP4wvSv/l5ZKlxTA8+cvhY/URgZ/WULrFNV+YnOck/kL9jTlHn/R/8Em4QAvnviMNHhKObWyRuXT5xH74gUEJPuN0F2OlMnslojG6YGPVHOw4UVnCU8lI3HfwfMWsBSs/IpQgyW+8070bNMEZ94BTo9qQR7s1NHRASB3o9Pyh3latQtF9He3crXaW4GLcPtU2DPt72TO0Nb3MUZxtIv9RVKgiDF4b07y8f/2O2v4cG2ETLZw3mCgDFHkaiLVewMdZX3WdfoxrhZSD+rLc9zBG2u7X4Q/e2y8bEjwMJKpEo3eFRJS6BjYfKSbPsM2xEAJnTST2vTENqdK4pkMa7lWeqs3nZfaPFWjj4p3rd8T8sPu9u3XUPP/kOt+3k5VYfHASQBD4siepOgwrdVhnt5OxMQYmi7xmrAXQnadXV+7xbP/7qpJwcIKLh3jndTUUMU5KQj2LgvcgCR5SmiEn2CSd5nrE041KJiGID7LDeWGO1ACeqIkp4eCevPekQ0wAaSLxkYZm+vuSXhMKiqaAQ5xf1ZQJF4PFoXGv5Z8JB3toWGfIOZE9+8hVlnbK1klfrFlhJ0OnesQXQNH3H+HhfWTpgo53x5wsTYV6lPvSgV0moMdHl7NXMpxeYLXTlAEdi5iTOIXbqvawBzRczkmFqvv+HCLB6sA0CNrYEscCWHh1cD1hfX9stXYZ1CieQHXolaFmtzrJqpkSWP1kddmUG
 4IUocRmC
 FphC+E3RRYiFnCQRjptl7Iap29eGlaPW/9xpnUmrYxTRoQsXuyMevBumZm3Iz9qoweJ2zYgrQPDyggZamQAfWC4mZVDTW1+DyxhagKvkBgWwXLX+TV5gw2QBJ4Pljs6KmagaMv1MfmKusRY5cIo1GoeiPeFEBWaqmyANMxPknoDmMNeytRx0ocGt1MLs3NloxP1dezk4v7HvjbMWJKV+WHmAqU8rHiALP+fSp+xW0ql/LINEnvH8ygg8e6fzNVKi2xmz5mvOXjvpxu3z3gRgCGMNo70KUC0yD+pJGpNnVU5k2L1ukPB5Jcd5vfMZazpLPJggCHDp6OFtnp2dyV62fDBtS+LTOKJK5pA9k6eC50EWR1gJ9B6WCtO3Fz/YisPPiqnGj+dTTWP1uO1nbt6XWuFcnHzH1sOt+PdZs9ewVRjB7pNfssjpvOp4yZaPi4DK+Dy8jMcZtzajhGnfHd6JNQiZQ36GldHm+h6/piLzTlP+rRmgCt/KJw3ra40v2FVdkj3Zz1MahGa7opPcLNZocpOiHOkcHZDu8VtnwO/35WHHQ9DPLD6j9fuHrzAN/cLbeN4lSjfyHMKFAYsqws/WsDrN+1w63L9iYoSYqX4F61dm0m4bZTarLP2PgHGmmDKsa/pd+UQO0gwm7BE3gNuHLX5xk87Z6RdjWAlYo8/c8cJ0oV6PfnTbk6851VNOLZ/IPNhD85cwGHktkJaac+WwuYPtSP+PQf7Qss/mVi2gjaajQ8fsMgOUsjKh7DQSIuscjVK+FJ72G5nvePQQdIXHmBVUkcOyQO4tSw6XXnjovS7a1zSCYkzW8kDzlAr+Fx4bVXQKazxtT7aikqM0XM8Uw4lKkEDPBq3MtvFo76J+Da7FQ3a+wpl1W6mdqXo0oPd0tGEFKtoMHcQ4fag4xLS6/Xe51oilajUAj8+s8Zwp43Utyc6vII/GWjBQrJfuv1r4jNE6I9y2gCouJOJ2lR7z/mKzIy4JG
 2gDvdJUz
 diolORORdFY3zzSa8OHwkEqCkxEo4cRR
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
- [Medium] f2fs: lost dropbehind state on compressed writes in
  f2fs_write_begin()
--

commit 2b2066d5ccd0493ea51e9dc20f74af55a2621a50
Author: Wenjie Qi <qwjhust@gmail.com>

f2fs: enable buffered RWF_DONTCACHE

This commit adds buffered RWF_DONTCACHE support to f2fs by passing
FGP_DONTCACHE to f2fs_filemap_get_folio() in f2fs_write_begin() and
advertising FOP_DONTCACHE in f2fs_file_operations.

> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 37d74afc8b26a..f3559c27d44cb 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -5622,6 +5622,9 @@ static int f2fs_write_begin(const struct kiocb *ioc=
b,
>  	unsigned int blen;
>  	int err =3D 0;
> =20
> +	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
> +		fgp |=3D FGP_DONTCACHE;
> +
>  	trace_f2fs_write_begin(inode, pos, len);
> =20
>  	if (!f2fs_is_checkpoint_ready(sbi)) {

[Severity: Medium]
Does an RWF_DONTCACHE write to a compressed file lose its dropbehind
state on cluster folios?

When f2fs_write_begin() takes the f2fs_prepare_compress_overwrite() path
and returns early, prepare_compress_overwrite() looks up and relocks
cluster folios with hardcoded FGP_LOCK | FGP_WRITE | FGP_CREAT and
filemap_lock_folio() without FGP_DONTCACHE:

fs/f2fs/compress.c:prepare_compress_overwrite() {
	...
	fgf_t fgp_flag =3D FGP_LOCK | FGP_WRITE | FGP_CREAT;
	...
		folio =3D f2fs_filemap_get_folio(mapping, f_index,
				fgp_flag, GFP_NOFS);
	...
		folio =3D filemap_lock_folio(mapping, f_index);
}

New cluster folios are never marked dropbehind, and existing ones have
PG_dropbehind cleared by __filemap_get_folio_mpol().  During writeback,
f2fs_write_compressed_pages() also skips f2fs_outplace_write_data() for
i =3D=3D 0 and i > cc->valid_nr_cblocks, so BIO_COMPLETE_IN_TASK is not set
from all folios in cc->rpages[] even though f2fs_compress_write_end_io()
calls folio_end_writeback() on all cic->nr_rpages folios when the last
compressed block finishes I/O.  As a result, compressed cluster folios
written with RWF_DONTCACHE remain in the page cache after writeback.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795746008.gi=
t.qiwenjie@xiaomi.com?part=3D2

