Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FB6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2418E0012; Tue,  9 Sep 2025 21:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C798E000D; Tue,  9 Sep 2025 21:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14268E0012; Tue,  9 Sep 2025 21:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9962F8E000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:59:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BD15C0764
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:59:47 +0000 (UTC)
X-FDA: 83871684414.24.50D5F9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C04020005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:59:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pcKBDT40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469585; a=rsa-sha256;
	cv=none;
	b=Mi7vDyLoCnao68vhj0/fcrvOkdQBNERwx8eHkX0PjtzF+qDGDppeZrP7IzUjzezkH57TFH
	yWWKCQus8yZSMmySZjfoHXsgfKwICUCrUtgagc69G6k9qvuZn84LVAAYzVO6S+1cN0svo3
	7O9ludWCMecS+YBfRUHFhLqwfZvo3MU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pcKBDT40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tY2g1ewNz2H31wMVaoYNp4hPaQ8OMzfHbr13qu9BshQ=;
	b=xDuZ565RdNJq2BJ0lF7gukuEuGitgtbJmkfrfBXq2hp7L4Gk8mb7EcsOzlpgi9yfQrzwEc
	EYHXdHQXv411Qggt8Pc+x+88JCTB5N1ujWzt+2zadYG81pkv5Z8tk+E8Dp4VuaiXdfaWfo
	YKI9c5k7/Lq/aiuC5vO0cmIjiEFnfh8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0073160195;
	Wed, 10 Sep 2025 01:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25188C4CEF4;
	Wed, 10 Sep 2025 01:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757469584;
	bh=tY2g1ewNz2H31wMVaoYNp4hPaQ8OMzfHbr13qu9BshQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=pcKBDT40l2OFNcvFOhCpqh4mzQO1YOZw3KzEyrS9QzV8G+18vGvcGaEoauo+jdN3E
	 MfuRJbuZ8vqts5jC5guF85KMn4PHQD+4eC5qIXp5IUfsXMgGJHvwYQdt7RCCAOWUal
	 wFhVOwrs7qnIXnmwlrYxdIWQdztTWchxwCOfWw2UPdQHOjBaT1Ux5HOeRIImeUBQR9
	 S8SqUfGWsoWXQjcaDU9lvv+ve6pgHsYLf5t5MOBAFw2hqPzP1DocXUe9E+02lbeOEG
	 TYaFLnzoRxBJvs/4N8ugvmcnBLpVpJgWW7cKgLVzyRECAy8titAUxclO+VesDQDed+
	 GO0g8MpI2ajaQ==
Message-ID: <5839b964d7465a8eb7235cd01575a0af073af60d.camel@kernel.org>
Subject: Re: [PATCH v5 0/3] Initial NFS client support for RWF_DONTCACHE
From: Trond Myklebust <trondmy@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Anna Schumaker
	 <anna@kernel.org>, linux-nfs@vger.kernel.org
Date: Tue, 09 Sep 2025 21:59:42 -0400
In-Reply-To: <cover.1757177140.git.trond.myklebust@hammerspace.com>
References: <cover.1755612705.git.trond.myklebust@hammerspace.com>
	 <cover.1757177140.git.trond.myklebust@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C04020005
X-Stat-Signature: xxdcxbpcxyo5bwt75bxjqtuajgfgroeu
X-Rspam-User: 
X-HE-Tag: 1757469585-31293
X-HE-Meta: U2FsdGVkX19MwvKcaUtdlM6h5e1itlQOmO4bipS+yrWqebZPzYh0NopTKQfo9jve8MKP/MpNeRh4+/0/T0WiDIZTyMrQue2I2yMHCDIGVuKLsMjXsEhrGWfWBH0qvXPUCcXTxywuk4qIDDirB41aUkdkUIJcBbdC41lTV9901IhLf79xkRqAHKsztoARa65hNoHFA8w1tmVniynhxQVatVphGw+cql8KXHusgaEy+dbEZm6Iv+JlQ64e62mNxp4K3EKCz6AKTznP6uv5ilOSFL8Rs2ozH6FX4VhcoiwNHfCUIYtpcjPuHRHApjG309pJo9kcaP71c2oH2/0a8TrTb2Wuhe8XoTODHz5YPjxCQwbJH7ok0wJNyXsgRDQC6dzFvIa5tzrNg0J+ceNkh+UfcybUacLLkZTgdi6lv9mznWbhOKkSSHida4EPEkOzYuj3ooLRy1LH5eiSss9JT+SFYwrDUW9mnPpMZEEG/pFz+HEUwrdhF992OMWlIqxSGrmrc3eli5V/+lmrO8+A3Okf+kgoDDriFPtijAUatw5xauVnn6eQX239JlZcFifxIOIsueex+3/zTxosUdZNiUf5fpz10Fd7aBVAiORLRU4bE8xcEwwDE91PDLKOEbtigzvHJw4FFw+rSPKADvwNU7fngfr4FmTEV9UMlqQUhVkXo4AgqU4HTxpk0UGm1bSh0eAR5P1qCSLed7+69aswEQN/BB4G3roUeCXRSOWQaxvwNPlfP7vBLdKmoiRd2ernnRz5NyjDM1kG8w4yZAGWi8yWnTXprrLebqjuiYThvqHvEnZGTzQ9dJNAYTo/4DEoaD4XxkjFYv4sqwIOCXLbcmypREw+nI/ty2jOyYqVzkvCCPv1S2ErW7sAEAh64Cc3YcjnIJ5wqEPFhUe0jWNpfJ2xI9wilm+2SZfc7NEfMx+W8WAP/LKq+FpsGse0cY6MbNpcjRj409BF57i9W4kFGav
 Kt4eQFMV
 EyDQHDcmYcK84VZfulAfuqA9qFnXLRu37DGaurEc6Emx1QDUh/HeJy6QZ05UkZAFfpunOiFqZgphgCBR/uITkWlp3zEeTa4mz4Fbp1qDhuDSGMIC/nOIxKkdViDcoxofyw3xIpvLxKx9lKnYnIsYbbj8Guf4zBCvZ7L94Nn0RkZnab8kspHvsz1L6XwgpHOJLpCrzzduyWEx/HBm4ABlp/OtbmUikbvAJ1zbaM/bt1rRSD+FY3JaQ0uWpFqhBxzjE35m57xWcAU0NsX6HPDfuMFERojboCooyH50bbnNlskHZTHIG/1GsVkvQuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, 2025-09-09 at 21:53 -0400, Trond Myklebust wrote:
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
>=20
> The main issue is allowing support on 2 stage writes (i.e. unstable
> WRITE followed by a COMMIT) since those don't follow the current
> assumption that the 'dropbehind' flag can be fulfilled as soon as the
> writeback lock is dropped.
>=20
> v2:
> =C2=A0- Make use of the new iocb parameter for nfs_write_begin()
> v3:
> =C2=A0- Set/clear PG_DROPBEHIND on the head of the nfs_page group
> =C2=A0- Simplify helper folio_end_dropbehind
> v4:
> =C2=A0- Replace filemap_end_dropbehind_write() with folio_end_dropbehind(=
)
> =C2=A0- Add a helper to replace folio_end_writeback with an equivalent
> that
> =C2=A0=C2=A0 does not attempt to interpret the dropbehind flag
> =C2=A0- Keep the folio dropbehind flag set until the NFS client is ready
> to
> =C2=A0=C2=A0 call folio_end_dropbehind.
> =C2=A0- Don't try to do a read-modify-write in nfs_write_begin() if the
> folio
> =C2=A0=C2=A0 has the dropbehind flag set.
> v5:
> =C2=A0- Change helper function export types to EXPORT_SYMBOL_GPL
>=20
> Trond Myklebust (3):
> =C2=A0 filemap: Add a helper for filesystems implementing dropbehind
> =C2=A0 filemap: Add a version of folio_end_writeback that ignores
> dropbehind
> =C2=A0 NFS: Enable use of the RWF_DONTCACHE flag on the NFS client
>=20
> =C2=A0fs/nfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 9 +++++----
> =C2=A0fs/nfs/nfs4file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0fs/nfs/write.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 4 +++-
> =C2=A0include/linux/pagemap.h |=C2=A0 2 ++
> =C2=A0mm/filemap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 34 ++++++++++++++++++++++++++--------
> =C2=A05 files changed, 37 insertions(+), 13 deletions(-)

Since the above series has already done the rounds in the linux-nfs and
linux-fsdevel mailing lists, could you please ask you to shepherd it in
to the 6.18 merge window? As you can see above the larger set of
changes are to mm/filemap.c rather than being NFS specific.

Cheers
 Trond

--=20
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trondmy@kernel.org, trond.myklebust@hammerspace.com

