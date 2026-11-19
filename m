Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD2F606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=klsxY4PJ
Received: by kanga.kvack.org (Postfix)
	id 9E9096B069D; Thu, 19 Nov 2026 10:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0C16B069E; Thu, 19 Nov 2026 10:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7356B06A1; Thu, 19 Nov 2026 10:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDBA6B069D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:56:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4882C0B38
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:56:23 +0000 (UTC)
X-FDA: 85452320646.30.29CD858
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf31.hostedemail.com (Postfix) with ESMTP id 979242000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:56:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=klsxY4PJ;
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795103782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+k74e9867nRhb8ulyLRle75AgKH2rav4a8VKiRxz7g=;
	b=SRqGiNOUUb5LbziMD9vnll4Z+IZhSF6oi+vjQGmQ0Lf5xnjKtAdo7KT2j+KVzkOeXY5Nn0
	dSTXZNybhHfzvGrFimWBaJUQcQKBFC0fvRWdg9LNyAgFNoR50RYB2RjfyhzaipzfQW9ht0
	oYr3VP1JNxJDghIef3GMFmy4bEibLkE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=klsxY4PJ;
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795103782;
	b=qRHF6MQNr8UFiFET+V2NFyMtZzOJ2qV+E87Y4n2UFgS/Ma9IIwMMQPSUUUaPEUcrVCLE2e
	K9VM2Mq5DK/yjYUX40xuNyPXNkepRMQ7uoFuEZm8FJRoX8HLnGTkbhOxOi3K/3Ocw3VeZI
	fO2x8ivnoQMIDXlgE8+qiosDI8Rd5JI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ccsxT6du60e05bc+5yqFYQ0nZGJ4mi0+0AzsLneGKZo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795103780; v=1; x=1795708580;
 b=klsxY4PJMl4Ikgo+XQKCm7RtgIevP/q/v5kRoZWFqtjJ092Y0vbMrBbA4cCeHgEKgUd9+Co0
 gn/CVJdvsGwuro+UMNi/q5MOuM8fZtlc5G9qjm2CclVAVNTd+IbEtXxN5xDT1EMSJ8GbFB+TIVu
 E3LrltzHOAK3lrK3ZXJABywA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4a01da6eccbc7804;
	Thu, 19 Nov 2026 15:56:20 +0000
X-Mizu-Trace-ID: 4a01da6eccbc7804
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 15:56:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <6e04aec6ca71cd754ace7ccae8284edb472b6528@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 01/18] mm/swap: remove unused parameter for
 reading swap header
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <f42af36d7ec66fb36fb7024966f4a7114f338a77.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <f42af36d7ec66fb36fb7024966f4a7114f338a77.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User: 
X-Stat-Signature: jmbre3xu3crrqcspzq6iuh1szk9hqsgs
X-Rspamd-Queue-Id: 979242000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795103781-974458
X-HE-Meta: U2FsdGVkX19nxPKrhgXRK20xaUCs78ETpzggNrTy/4go2NctrCpbuc35i+/AESHQQynN+cK5jNCjD9mn4kAXADkvt4oU3LB+wwH+U02FivbZatKsk5iOKGSGhfIMJGNllB3WBdiu4eRgrpegektzEnjtjoqBjJrVPpYC6DlAXGdxTvLwaUYBIb7yev5IMIn3lDjYOCSxYiHSIx9FxNpzHwcYnIEkXkDnRwwLie1/7dtAYQK9rFHeVvbDCeROHjukhtAq5BqpcyniqK9Y3yl+bX0LjIHvAsFhzyYpbwtioTQ0cZDvXoFMBCcoynu93MPXt85Y1cof/pisGJtf51v8qviGQlvyOAjuXX0FRpGBJCJfnfd5djRyM5TIHc1NQp31/cLeNwdbe3+cLVKT7Zgdou504CL9zi1upRpJai0qeBJZ2epDycfukVswy7Xx+Gpp1LrHz+Xs5/kxamNWtGcybiU59VqvhbP6pYiWiV5F7LCv/1AKs242L3RsOAu5aoncE5vshPjVExNXk056yWiFZvJZhWpU9cC37hmXQo+3Upu+SLaMDtgrrWohVivMZPGVbIa5a5MaL+Yb1o2t/O8kyxLjg/J1TIi8NYL5RAQbjQ5rA46ZziLB5MWn4IFO3bBBKdFJUqfD4nXDMsgqDiFPumTvfhuQeSYakgwMKfqGtWjIbFvsoVorTmF+NNs2WXYZppZv+LS62KYD1eSB5Qt6wt0/mrA136Ff9oC8qY3ejMAHWnWrjUwYf6LAY5gmYGYpagyK1Qmg+BlMi5bl+/J+ly/yuE27BngP1/QyCH5N2A29VvFNV89KJaVCW9LrysanjDo0SehW+38hjXoSzNqN+dreydmyCszfjvuhjv1mh6wm97tkafQzDelTYRr8c3rDKZSRcuRKUQiYUzxAfQigXLfnyjZc1pyro1Oa7UkwjTOp4o2N7oumubEs0OtsB/si1HElIchilEI4184d2bS
 CshzANIE
 cBBxsPwqf4L/E+cKfCziPGOXwpx5sac7zEZVLoQp9hdVs/1lfHd9wV/94gnWC9MowSDmE4RqdiY6/tbWYQ7bE7tjz0FBbpgY2d0BKgg5ftALMZpX5jrzZSMISKipfHRlBLrSj/HJLSHwoJqa9n7VfICczYMmhPEWhJ9xlOhW3o8PotXHer2dsFp1LXVLi0+BH49lSulQ3LWE7AlcKB/G+xMdxsATrf4DLEOjpAYpb2O5g4jN7QiF1tkEAVgZGfLWhgAU0UIP3hiwmAcSvVFhxtynC7tjnun6xRt2eO9wh+q53UHCJEA/VBo5iQ7r+J+L024rdP+tvj6Dv2bbUIqm4vQc9NI6IPpzNiH3Q7SmKb0TqLjKpx/kUW8n9wadV/r5Li8xh8veuOPo4ptM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20The swap_info_struct argument to read_swap_header() is unused. Remove=
 it
> and update the swapon() call site.
>=20
>=20No functional change.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fcda5eba1714..c41c4d26a7e6 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3630,9 +3630,8 @@ __weak unsigned long arch_max_swapfile_size(void)
>  return generic_max_swapfile_size();
>  }
>=20=20
>=20-static unsigned long read_swap_header(struct swap_info_struct *si,
> - union swap_header *swap_header,
> - struct inode *inode)
> +static unsigned long read_swap_header(union swap_header *swap_header,
> + struct inode *inode)
>  {
>  int i;
>  unsigned long maxpages;
> @@ -3863,7 +3862,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, spec=
ialfile, int, swap_flags)
>  }
>  swap_header =3D kmap_local_folio(folio, 0);
>=20=20
>=20- maxpages =3D read_swap_header(si, swap_header, inode);
> + maxpages =3D read_swap_header(swap_header, inode);
>  if (unlikely(!maxpages)) {
>  error =3D -EINVAL;
>  goto bad_swap_unlock_inode;
>

Looks good, thanks!

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

