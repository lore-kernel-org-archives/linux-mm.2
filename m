Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A1CC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9473F6B0088; Wed, 23 Sep 2026 19:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7DE6B008A; Wed, 23 Sep 2026 19:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DFB6B008C; Wed, 23 Sep 2026 19:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 581076B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:25:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD68940175
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:24:59 +0000 (UTC)
X-FDA: 85246609518.12.6E14FC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EB4C40008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:24:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMIRNr4O;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790205898;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9YKFd/Hl7YhdOyAieKBjsie7xEHxxz4e55B/x6uzdo=;
	b=uMjW9KrxCAx641oSMDGsgbBO94TUzoqXY0p0uVIAHOMszRqvwd/1F/SDMB8FVubKchofLG
	2CFSiB3qlV/dX6xhJIPH+1DL6YmVrFWJPO1DmaUBMRZDp6MZG8t+oMpguNpr0e/v7QKa8n
	U/bmsuvOxJ5b6g1A0G8U3WX0AObxp6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790205898;
	b=H7EEhRjJyd6aP3w7xEH/NQsEDgc2PnzBfZpvD0vJfWrdahNZDjtBlC3Q925T9vfnWtcBam
	K48OO2aBZNnwgsVY645uW/k89CbXh6WcvvaSXs44PBF6dsdXCIiyCjtr7yTo/aoiqXL+vf
	MTD/Z+FmhqcVcyY9TmWKM1y8I8R1z7U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMIRNr4O;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6BBE60008;
	Wed, 23 Sep 2026 23:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC0C1F000FF;
	Wed, 23 Sep 2026 23:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790205897;
	bh=U9YKFd/Hl7YhdOyAieKBjsie7xEHxxz4e55B/x6uzdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OMIRNr4OLiUixLKnhBolSnExmjDFWiRUOgWv20SvZaXjb2auAnjVO7paMjuqxwVUh
	 gAznIr7cxA8iwbMkmKDqKHfpe1TD8i+ljP6YUolouKAwsl4f7+f1rOlXQVB0XCdwbH
	 zyqskPgnBxQTHf32dDgeBvVOID2t7ytyP4gz5du6Is0yMc5oUiSqdo18GwgRg6AGe4
	 ExTY00SKLiY9HVRr3LlDd7XhgF4nLqikcaON2hjaUoR0iYwBwr+xjA1FfSfDhUATqS
	 W/bTglH0wjmNowS+kVve+Q8JaSPv3Vhw8YXbWFuO3I97nSsjIRd8+ETJemkQbLwLdK
	 92jaAVSIpl77A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 5/6] mm/memfd_luo: allow preserving a tmpfs file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Hugh Dickins" <hughd@google.com>, "David
 Hildenbrand" <david@kernel.org>, "David Matlack" <dmatlack@google.com>, "Alexander
 Graf" <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260923224408.3745689-6-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-6-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 23:24:56 +0000
Message-Id: <20260923232456.BCC0C1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EB4C40008
X-Stat-Signature: w7w5wsqmnq9gaayhaf4mcbww8i8kmpge
X-Rspam-User: 
X-HE-Tag: 1790205898-642883
X-HE-Meta: U2FsdGVkX190IrxbgYkYCN0GYYLVufdn6wpA0uhNj5Nn3PPzAq21X8rT8IokOUNhExNg9G6HNypun/yJaPOqSdVp7fK7oDN+DffpFxGZpbMnHIypdbqdhO/TwlPqpDCALqHGvRFR2iFzWUOQGXwY1R8wzua3SMDuNILZN0gZng/nFENqoVGZwlBr6gawlqbZ+Mom07MmEbdFi+AZjnKOHEWlRpXiFIms99lLwroibFMlK6UlmgSE/GhUPvaoozXTU+hcjM0TEFFCb0UmHUAQ6Q8zij9SYRg1esQhB15UwmsCFj7EgASnhdJCeZoeCt1U6d47Mf7HRcXM26WWtQ7/yoyG+qMtvROoSIvsB2Q4ZRPbjG9jobEv1s4Y5FHuquMkcgOivbw9ST7HA84Y2h65Qjp/vvV6hz0/R3nH1Zc+5qeeSlHZv1mXWpEcLoGIM6+yuLyBdJdkrzxtPM9XrzxCUol8nHEYT9onjZFtHbWXo0uibMIt3zETAFzigv5UgDM+fnoKK/YlHfgXg5vW12hpROjLDjjP7Lpi3JAU24H3iQsFsHUV5qfv6rX5quwrJ4u/IiatNOwQORf8UV0euUV/KORsbBAmSlQgkawASM001YTdwUwPseWhbJuh/Dwc/U8SmLNy1yJAXXvQE2KS5Ty2Vzw8oPKrf7lVRqR4cW63lll3uosk/Bb/YFbrm9S8rLWSpCgyCt5PwCdAy6/BUQwuAUab1ts0RYuRIq0pr93ZM6B9acphymvMpRpoa1dzlbewTRkqv9cD5uuKaV29VID/heZET0vcMa4JWkHex5J5SF+tICcbLlyQ5PWgqwjlOdiJ5fqV1DZMoG2YgQDVkgZ6Ep4JEfsw/mRsYUxoggaypzvZQND5nunvugKqQpnCWGCh05xyoLxrFAv6ueH+KpQKn1q9SRyWAzfTWvGbKi5nQ0OR1PjGJEn9GsOcrJi6l8EVvJjbVpHrZFQJEu6siWL
 4UbvF35M
 1wfGMlZrf+3sG97yYaYu+EgPlRaHFLkHESY0LAu7xU1YEURakvCzvOS8enLfAnBj9WY3ouuaK+hOzsrHiiA8Q1f0up0N31C4St5Glk78mviLPCAVqj3mYdmjhNlkFP8+g62Uo6H6g5nAAKO/8X4l1tU77gf6Rozvs6nGaI89ADtVB683Met3N0s4QJTTmcFYjXmBaN/quI/E6Mg/gut6E5BqajG3usNTIS49uq36tzWxHMJ5IqYgvJdojzQepI7TsaOYxn+FFEhgR5x1RZtDKZ/h/5yb/HSni1K5j4DDsizuL0Mr95+90xZEXdj5Ov7HflQ0Dlz5smUyPp2D/OkFejqWFFgr5R+XrWOBGOdyzb8+XixiyK8J0am9CXU/sTGr+zEeObZC1jfWx+BcCUHEJWfzpT4g1Ss+DsbE+DTTP1zzir0lTeg+trdca4NURWoOi1HrlgT4LIk4DdGP7q3oI/paAD4eKSC6bH+MuGB1SXBW+onJeQkT1Xh3qPeYkw54uzDfN8FeIYzR1ad0OEPfPni7zxWgGPu46PnSh/PHVx9v2bYMzayVbWM0DPX7a5SuMIhqa6X4L9Q8mX7wGeAHE4XAmrEOZuI4VMNya/09PqVrdz2xEsAlYn820oy0pdGl1VDkmjPb0JWXUp44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] mm: restored file permission bits are corrupted by current_umask()
- [High] mm: TOCTOU race allows unprivileged userspace to disrupt tmpfs fil=
e retrieve
- [High] mm: memory leak of KHO folios on tmpfs_luo_file_retrieve failure
- [Medium] mm: potential double free / UAF of ser and folios on successful =
retrieve
--

commit 4087da995ba7fe7684120abaf9ec59deb366b97b
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm/memfd_luo: allow preserving a tmpfs file

This commit introduces tmpfs file preservation across kexec live updates.
It preserves regular files within a tmpfs mount by serializing their
properties and memory folios, and restores them when the mount is
retrieved.

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -1005,62 +1005,51 @@ static int tmpfs_luo_file_retrieve(struct liveupd=
ate_file_op_args *args)
[ ... ]
> 	err =3D liveupdate_get_file_incoming(args->session, ser->mnt_token,
> 					   &mnt_file);
> 	if (err) {
> 		pr_err("failed to retrieve tmpfs mount: %pe\n", ERR_PTR(err));
> 		goto free_ser;
> 	}

[Severity: High]
If this path jumps to the free_ser error label, does it permanently leak
the physical memory reserved for the KHO folios?

The free_ser error label frees the ser metadata, but does not discard
the physical folios or the ser->folios vmalloc region. Because the function
returns an error, tmpfs_luo_file_finish() may skip its cleanup logic if
args->retrieve_status is set to a non-zero error code. This would permanent=
ly
leak the memory of all files preserved inside that mount.

[ ... ]
> 	/*
> 	 * TODO: This is racy. This will link the file in the mount so after
> 	 * this call userspace can already open the file and write to it.
> 	 * Ideally we should first create the inode and set it up, and only
> 	 * then link it to the root.
> 	 */
> 	file =3D file_open_root(&mnt_file->f_path, ser->name,
> 			      O_RDWR | O_CREAT | O_EXCL | O_LARGEFILE,
> 			      ser->mode);

[Severity: High]
Does this code inadvertently strip the file permissions via the
orchestrator's umask?

VFS creation functions like file_open_root(O_CREAT) will apply
~current_umask() to the newly created file, which could alter the
preserved ser->mode. Since the kernel code lacks a subsequent chmod()
or vfs_setattr() step to enforce the exact preserved mode, the restored
file might have incorrect permission bits.

[Severity: High]
Does linking the file into the namespace here open a TOCTOU race window?

Since file_open_root() immediately links the restored file into the tmpfs
namespace, unprivileged userspace could potentially open and write or mmap
the file before memfd_luo_retrieve_folios() is called. This would instantia=
te
page cache folios, causing the subsequent shmem_add_to_page_cache() inside
memfd_luo_retrieve_folios() to hit an -EEXIST collision and permanently drop
the preserved data folios.

[ ... ]
> 	args->file =3D file;
> 	kho_restore_free(ser);
>=20
> 	return 0;

[Severity: Medium]
Could this lead to a double-free or use-after-free regression of the KHO
folios on a successful retrieve?

This code frees the ser object but leaves args->serialized_data as a
dangling pointer.

[ ... ]
> static void tmpfs_luo_file_finish(struct liveupdate_file_op_args *args)
> {
> 	struct memfd_luo_folio_ser *folios_ser;
> 	struct tmpfs_luo_file_ser *ser;
>=20
> 	/*
> 	 * A successful retrieve() already consumed the preserved memory, and a
> 	 * failed one cleaned up what it could. Only a file that was never
> 	 * retrieved is left to discard here.
> 	 */
> 	if (args->retrieve_status || !args->serialized_data)
> 		return;

[Severity: Medium]
If the LUO core framework sets args->retrieve_status to 0 upon a successful
return, tmpfs_luo_file_finish() might bypass this early return, dereference
the dangling args->serialized_data pointer, and mistakenly double-free the
folios. Could args->serialized_data be explicitly cleared after it is freed
to prevent this?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D5

