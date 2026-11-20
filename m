Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551F4606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FHjb350R
Received: by kanga.kvack.org (Postfix)
	id 436E16B05B5; Fri, 20 Nov 2026 17:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A1B6B05B6; Fri, 20 Nov 2026 17:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2618B6B05B7; Fri, 20 Nov 2026 17:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9E86B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:44:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49BD3C01DD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:55 +0000 (UTC)
X-FDA: 85456978950.23.6D61327
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98AB9120005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHjb350R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214693;
	b=GYUWcVjYdKkRnnJ8O2UyvE+Z50eHVOyWX8ESm8H49rXrtSobLx17Ur3uXK8yyGusUR4Gk1
	0ACE36whsiYe2eXX8MZSOQe71ISTy2n5w5I7eTRg9D3oak/oPgo56lBJWMBN4BDE38EDnA
	f0bFMLu/o0v4/JgXRTypLK5RK6h97IM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214693;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQuR/rEK9xvDJFqiz1UABVYdb4hEzkHLUCVdirqFjdI=;
	b=pITq7tvgdmCTH/NPTkgYN2b42TMvEniJwPkQncTAIxjgo/vmEYv7eR6f4m5p5h8lVsAvkb
	bg5lgYPjH84vgHtDWRSoweZ5VkB3PGHGZZZBiOYvacTlZ//KmhGKUCqJvsAPbYXWYwU+SI
	AwUvgwlu5KkEQZRp8XfzYSt802qYofg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHjb350R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A92745BAF;
	Fri, 20 Nov 2026 22:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7681F000D8;
	Fri, 20 Nov 2026 22:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214692;
	bh=CQuR/rEK9xvDJFqiz1UABVYdb4hEzkHLUCVdirqFjdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FHjb350RwdNDx+9XuxWJKnHSqDA9YpQtSsjVFqc5E/Z2DizU/rETAQCu+K6C4UQMw
	 vJwKkDcVgW5PB4n+A5c9zJvU/QP4l4tJh45s0+W0RsNAdfjNeOtm3v9dLn/pajZQz6
	 QaNsDlA0dPYdtiX6FaKpemMRh/bPS1Aa+aI315I2S9uJGjLxs929UVu7EQRtnguBaQ
	 XmaEX1qKmqHj9Nss5jQXzZN9UgQOcwhWPoKWl9DcAcYgcSS9FPO/mlsF4+H+p4rVpJ
	 ddeL+H/Pi2P2rGjrGj+7+AQPpF7Dk1aOkW1mkyHni3cZYWcJPXhVfnQeCMSkFM6L35
	 7QPTv0XAAeqpw==
Message-ID: <sashiko-outbox-226301@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 09/14] fs: Support MOVE_MOUNT_T_MNTNS in
 move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Andy Lutomirski" <luto@amacapital.net>, "Andy
 Lutomirski" <luto@kernel.org>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Arnd
 Bergmann" <arnd@arndb.de>, "Ben Segall" <bsegall@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Casey Schaufler" <casey@schaufler-ca.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Chris Zankel" <chris@zankel.net>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Davidlohr Bueso" <dave@stgolabs.net>, "David
 S. Miller" <davem@davemloft.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "Hallgrimur
 H. Gunnarsson" <halg@google.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Helge
 Deller" <deller@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Jan Kara" <jack@suse.cz>, "John
 Johansen" <john.johansen@canonical.com>, "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Magnus Lindholm" <linmag7@gmail.com>, "Manfred
 Spraul" <manfred@colorfullife.com>, "Mark Rutland" <mark.rutland@arm.com>, "Matt
 Turner" <mattst88@gmail.com>, "Max Filippov" <jcmvbkbc@gmail.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michael Ellerman" <mpe@ellerman.id.au>, "Michal
 Hocko" <mhocko@suse.com>, "Michal Simek" <monstr@monstr.eu>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Nicholas Piggin" <npiggin@gmail.com>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Paul Moore" <paul@paul-moore.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Richard
 Henderson" <richard.henderson@linaro.org>, "Rich Felker" <dalias@libc.org>,
 =?utf-8?b?Uml0ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "Russell
 King" <linux@armlinux.org.uk>, "Serge Hallyn" <sergeh@kernel.org>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Suren Baghdasaryan" <surenb@google.com>, "Sven
 Schnelle" <svens@linux.ibm.com>, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Valentin Schneider" <vschneid@redhat.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261119224312.1037966-10-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-10-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 22:44:48 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98AB9120005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 45wghqpkuiknkh64ppgsdpt5dsgaut37
X-HE-Tag: 1795214693-478254
X-HE-Meta: U2FsdGVkX1+yiAx2fByF5ekVoWQD4Q1VeeSbEyh+7k/2t7h52wV5E76ATzvtzxqwZeBgFdgT20pd4hGEXmXpevwbYN16nMwaRenzQJVnaYm+i9KACaHylIdkRlVcio14wvCA48Tb9HoFiFjxcuZn8EknQM55sk4zPH3Eg/uBjsvixyz99FA7MFM8p6nh93dT2q6GJ9rABL6in4w5e+Ahk/ej/+S0ic5U13L4z+avgogThiZMOTm0NQpyTkFc8M7A+8pk95IGET+RkulMdpBDSdT8M0vQAx1VfALSSISVaosJFBJg2MFAoVyIrZ+CwovKA0w/bqi4tkm93GXIzpYHKRw9T2ucURg965ihZVuTS/0/PxgbcgwDmTClX7luwpB/KPrjgzL9ndAMa/k5eJ6Df1Kwfud834ysXs25gSig0AYjfYGC1a+l0yU2l4ZFUBKolOznsZCHammJ5JAsqYQeA3XU5kX6z1dN7f3dphQo9inx1UlakYYBAQmkKLbpxrpd1kqhY95WPTq/4ImFl5h7/gUQp6jcLsxHwygHhBGAmXW0dbdp1SFQ0vWCiVlzOVJnb/1kHve+3xegBtyyIsMs97cr9TXqljHTQDxkmRJKan0D13WQoZrY5nMCQORgE5GoJcsABINP4ly+uBLyilREOtLmYARV4vM4pLGi+gXy7uxN8/bI1xKdmQGITO4iq2m/ndqtc1wOzLdFaUhwTzARAS1OBD/z4t79nIRzzRqGgsMN4xAQowtO9xZARRyphbtBA/P9zDcpS8QBNd55uZbmOljYL/y0PU9yBx2bNn+IDt6cQoz/EXlo4PQnd8+04zWVpP381FYeVy4B9CVRXffNCC6pP1ou2NCiGAck3E29lcw9Er3ATo+UW3+Lr/FXP/bVL7AhzvQbt0QX0kJxiwFHiqiTZYUi2UlbZRWJV+NmorGSsMdRd8pQ+siLgAeN1iVzRc2/t7x5WjOGXXm4azX
 JYRqRT9F
 lbc/oz8IU6KYEI+LVn0cXO2yvcLta3KMoyKfp6yuOi6wcPELPv1iEqyAi4eqb5Z3UvCsnIA4JrNXB4IGw+LGsQcxDf6RPIWNBfkD+jLunfMSgssqPk71lLtNnKzeix+8A9Q+wIHOU47LnA7NiT4zF2ucMfr3nPu5RHfhMH08RT17qKETXmArw/TNGsTDcey44nLuG1D0A/9OthUiw53qCXfinwQnBGkyKRW6xsK1bOIl7+AEZKn6OoNQ6TTyMQ5F4Cnux1mOKk3peVI9jMsQR7fXpfGg/UsnaIyKyYWduVxAmE0+WDKj+S3D0B0UJGFDPe3rQTy4eC29MgSlg8zReMHIf1gkPG7EleUAUAqpYbi3AZ8xRvvBs50SFfIFnxIte0OyM2pX0GRCF16xJPjb5sluw+lSft/7VwJuS6rGB9LanADTMyLRmI9ZToBaDtx8qfUmKo4x0jKU5Ab3mgYqcwdX33m7HnlL+iHu2P+9VS27+bB6mZQfFC9NRqPerAZgbPi76jlvBdeAphmXFdihpw8wsUxfkwe6IrOcNmK5I541dtnhZy2Bbtx3DzW88wR77YLUWpRirFSqqQ0m2VVw6E1EawlTYuo1iz1HGixpHWMjzSMPJr5wP4fHnqolR8+Zy6KO2ruTLH7cxK9N+OpzVCzWtu3MjycuY5hXH2+5/NresMfEZuPYoWtRJUv2yr871x8D4YrsTq0ff8VrfgzhJ5H8nrZLZJM5b+3LWlkoyMzNWgXGvjE3xRBfkVL0GXOns2ukJUTn/3zVnWAcOeJfBpWtJGKfKRUlm/9pUkyDHv2geoO2K+Tcjwryh5RJyH6LRyK8gD/fU3l4zPZJS5ydf1FBEP+JRqfKIpy1CD/jR7lDGGARSz2Tg5X311FbMDMKJPgBJHjb+ltwHa/pdF50vVvfmt8lXqiDH/N5SWKVQ4+cGIdSj5u/kpgOadqVOo+P/5yVWUzhAnTh5yoTZ8RfQd4Gy2tFw
 v/tNZLaw
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
- [High] fs: cross-userns mount locking bypass in attach_recursive_mnt()
--

commit 5e90ce5c3ee9b66d7c6a41077c19c225ae139217
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support MOVE_MOUNT_T_MNTNS in move_mount()

This commit adds the MOVE_MOUNT_T_MNTNS flag to move_mount() so that
detached anonymous mount trees can be attached directly into a target
mount namespace specified by an nsfs file descriptor.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index dfe0ee9ecdcd0..36ed48c3f6467 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> @@ -2632,7 +2642,8 @@ enum mnt_tree_flags_t {
>   *         Otherwise a negative error code is returned.
>   */
>  static int attach_recursive_mnt(struct mount *source_mnt,
> -				const struct pinned_mountpoint *dest)
> +				const struct pinned_mountpoint *dest,
> +				bool move_mntns)
>  {
>  	struct mount *dest_mnt =3D dest->parent;
>  	struct mountpoint *dest_mp =3D dest->mp;
> @@ -2641,6 +2652,7 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  	struct user_namespace *user_ns =3D ns->user_ns;
>  	struct pinned_mountpoint root =3D {};
>  	struct mountpoint *shorter =3D NULL;
> +	struct mnt_namespace *src_ns;
>  	struct mount *child, *p;
>  	struct mount *top;
>  	struct hlist_node *n;
> @@ -2662,6 +2674,7 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  		user_ns =3D current->nsproxy->mnt_ns->user_ns;
>  	else
>  		user_ns =3D ns->user_ns;
> +	src_ns =3D moving ? NULL : source_mnt->mnt_ns;
> =20
>  	/*
>  	 * Preallocate a mountpoint in case the new mounts need to be
> @@ -2694,6 +2707,12 @@ static int attach_recursive_mnt(struct mount *sour=
ce_mnt,
>  	if (err)
>  		goto out_cleanup_ids;
> =20
> +	if (move_mntns && src_ns && src_ns->user_ns !=3D user_ns) {
> +		lock_mnt_tree(source_mnt);
> +		if (list_empty(&source_mnt->mnt_expire))
> +			source_mnt->mnt.mnt_flags |=3D MNT_LOCKED;
> +	}

[Severity: High]
Does calling lock_mnt_tree(source_mnt) after propagate_mnt() leave
secondary copies unlocked when MOVE_MOUNT_T_MNTNS attaches a tree onto a
shared destination mount across user namespaces?

When IS_MNT_SHARED(dest_mnt) is true, propagate_mnt() clones source_mnt
into tree_list before source_mnt is locked here, so the clones do not
inherit MNT_LOCK_* or MNT_LOCKED (and copy_tree() silently skips unlocked
nsfs submounts instead of failing with -EPERM).  Then the tree_list loop
checks:

fs/namespace.c:attach_recursive_mnt() {
	...
	hlist_for_each_entry_safe(child, n, &tree_list, mnt_hash) {
		struct mount *q;
		hlist_del_init(&child->mnt_hash);
		/* Notice when we are propagating across user namespaces */
		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns)
			lock_mnt_tree(child);
	...
}

Because user_ns is dest_mnt->mnt_ns->user_ns rather than src_ns->user_ns,
secondary copies propagated to peer or slave mounts in the target user
namespace match user_ns and skip lock_mnt_tree(child), allowing root in
the target user namespace to unmount masking submounts or clear read-only,
nosuid, nodev, and noexec flags.

In addition, if a foreign anonymous mount from another user namespace was
previously attached via regular move_mount() as a submount of an anonymous
mount tree already owned by the target user namespace, commit_tree() set
the submount's mnt_ns to the anonymous tree without setting MNT_LOCKED on
that submount's root, and attaching the anonymous tree with
MOVE_MOUNT_T_MNTNS skips lock_mnt_tree() because src_ns->user_ns already
equals user_ns.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119224312.1037=
966-1-jarkko@kernel.org?part=3D9

