Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66834C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 13:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB896B0005; Sun, 28 Jun 2026 09:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65286B0088; Sun, 28 Jun 2026 09:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56776B008A; Sun, 28 Jun 2026 09:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614BA6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:20:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B94641403DB
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:20:19 +0000 (UTC)
X-FDA: 84929380158.08.9DAE901
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0596E20010
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:20:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T58wKw3/";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782652818;
	b=Dl3xf1kHJXubadjBtxKBpcv9YaYQ1PbvyeEn5IdV7yYErOKvRfinRsnSENciDeel2Hguwa
	WuA/MSX3U5Je/7Vc7tZGPBsIqJk05DtjmhOHKY4sqlU8lkp8fcUADNY9twyDIontUcSMeC
	/Mikf0HH4hlnWkQTR2q5VhRPehxwz30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782652818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXoQjZLUk0Gu2GsfbmsyigRTgwTQyOHHwu7BBNkqboI=;
	b=PKLKqvQQd47blkSwlrSHEU9/8w9qwVd+Z4I5y3gfJP7hS3M/Qn4GGOYy3/4pPalJ4sDtcG
	zRlaC0/5P5RoqJl0ZXI6tuYhpdT2oVEXt4NMetd5pYK6kBN6FxU1F5QYJM5j6IDKhhD02g
	rTvbqh2R+6nWpXvq5O1iMFqdVALAkY0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T58wKw3/";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B4526001D;
	Sun, 28 Jun 2026 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3AC1F000E9;
	Sun, 28 Jun 2026 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782652817;
	bh=JXoQjZLUk0Gu2GsfbmsyigRTgwTQyOHHwu7BBNkqboI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=T58wKw3/h195JJKQslgax470vRU1moZzYMEaQLAo0MoeU72pEf8B43+d3jCrLorTI
	 SwkW7RJWoNeW+/Wlt8uFGkacN2dNc21vnPhntK7zSRu9W7trR+WCW6WmDwW4oGWGci
	 Lg65sOJVYJ7fVZ8OBSDwP0hygUcnbt1ZVZ3OHesiSeYjzRXxMokmWB+3bpHKKiH8Ar
	 HpWbTudaosHJDfaenjrQhyqaOR3OtMr4qXm6CJgd6w+QJLYKy1DBjPu00Uo7GuMK6o
	 lo/6Pvu9d4bU0QpyCBgbY43irSMjUq9QTCEUgPgSQCU0hkF1tvh51Uui+Y2mQ8RcTl
	 YvEA66rRM1a5A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 shuah@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
 linux-mm <linux-mm@kvack.org>, 
 linux-kselftest <linux-kselftest@vger.kernel.org>, 
 LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20260628-ungeordnet-orgel-stechen-36dd64038541@brauner>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
 <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
 <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
 <20260628-ungeordnet-orgel-stechen-36dd64038541@brauner>
Date: Sun, 28 Jun 2026 15:20:11 +0200
Message-Id: <20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2418; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iEXwwCjxyid4ZfFr2P+Mp82+XoX1Wd5fAjKvPPhBb94=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5yvfpGvgGyOgzlOotv/p9s/+c+m3O2xgLvZwmNTJeW
 r3AeLpXRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES81jD8T7zvks7EoT1j4+We
 RXfTDUQuVVX11Xx7XF3GLvV3khvPeYZ/JstLjUMu3Zs+0/97ncChzoavG1eomwlM1isIXnXln8B
 sXgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: stci6jfurk787ki88dj86bgdefg65wxf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0596E20010
X-HE-Tag: 1782652817-21885
X-HE-Meta: U2FsdGVkX1/2QJf+1xtC/9LCP2Np4Cj4Lwwmki78VQst+VwEpAqXglJOLsQkrstNpxV0LG3icAqGPoGxfVjX7DmqZVaUVppo/WITBT62WXzleuJRR1/ZW2D9UwOOYvEHEF2PusPVUrejiGoZi4DipuG0UHwl0hbkJxIcJ57Y0Ti1sUbeYoeTIgb4J3hzbNIZ6Mw79jhRKJnovMiz5V50/XSXEQdoO8EynacSz0thsAFr7Jkurkt9Sjy+loGtT23aBOzD9D/O3SueP8Qy4q5jZ6fg6SU1su5iLbafCh7z+EQbyY8dJ8j3N9/7Tf3ILWmI5F9km2NlerHQ1Fz0z+Xhtjpn9RcrOrXPyZnZvC8hRLKMGiY0kkWeITr4mTEBEjJGM5TzauKSKNnX0O5n+JLq+UCkj+4gxLmtibLom4FvnhYy2AY3MNElrnSvnkYXR0rxMZ7fMIqMZIBicjPb3W9DxuUKjlCyNz1uLNySB27f9I2sVlDlkDPbLsVEWaq01B1YREh7GSIDu3piWjIoxbVY4TSI6sumjrAWQgX8YFQX3yl9VfQF/5pt4Korktq8shxv8WBrjn4S9ui2s/IEVEABim6IfkkHU2dWG3vUPMSnyZRybQMqzRR2rXRF7Q+QPtVY2W9Oze7nRr4kqe+bcJt/1P1Z4jAQiigIRK1ONaUIUQsBrW3x8nzb6ppV9gZ7Foa6OOtGkYdELwQmKJ1IFOh5vuQbsGBLdrl6WVHHojdWbNj8z8WksQR0uG89m5tB0s2a4MbmqEmmkNzlrUKM6nteY9UaxxBKnC0BUutag8zTBIvedbxINLN1LBqCiUTQ5wlYntcavu2HqoPjDCfU0mokqUIbuRZBAob4Mb0cC5F3s7jlhPhkyl1BwBB7EU3T+ZMa66lARU4GRmJK/MdU7yI5uxOwGcewf+2mDZCAMQqHKWWMmDY/630jskA9I6K+v55nvVitnTzDwYAwzqavGQe
 EKiKNycM
 TRP+IayLh9eWyusF+L6ej2vLAHPJtdkaQkdg6ZiJdZDXdpdluW2FRoynbt+fdTkxHH4pkPx4Bxv3WQk9SteK6W18Kwsiz60AffxL76Kae+16x3tX+9JO267AvWrx54ei//3Jx/PlOpvrli94ZcWY2zKfpQqaMgfn0IJyLqZROfYedgqanntKe9MXykv//GFUHZvMnWpBfuqhg98K2+nErFzbtvUFytwJpNjoAoGEZQDjS5W8Y1aOfUAB2oaDsuQp+NBF0wHpjfh0S2008YwX0EJp+sS4K58qwkQfqG4F6r6B+8+CwWcLlpWyAw8leIxKFWNor5gsslXCRpcHMabVzkvk98TbkzSm4YB4RQ54X6Yj7mgrIy5i+QiX40H1gW1yT0l3q9Zi8qzLx8Wu4ndSsYR0XdTL3QTIs9+fDxvu9l3lEl6ptSMh80euttoJzryRfTn5oVKJP5gfDd6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-28 14:36:52+02:00, Christian Brauner wrote:
> > I think the proposed patch will only change behavior if the
> > interpreter path starts with "$ORIGIN"? That wouldn't work on existing
> > kernels unless you have a directory literally named "$ORIGIN" in the
> > cwd, because "$ORIGIN/..." would be interpreted as a normal relative
> > path.
> 
> I was thinking:

A few other things came to my mind:

(1) memfds: /memfd:woot-woot

    A memfd doesn't have a path so any $ORIGIN type behavior - script or not -
    will be at least useless if not very confusing outside of a sandbox.

    Btw, used by runC to guard against binary overwrite attacks.

(1.1) deleted memfds: /memfd:woot-woot (deleted)

      Same as (1).

(2) deleted executables:

    /woot/woot-woot (deleted)

(3) unrecoverable executable paths

    No path can be resolved at all. What to do?

All of that needs consistent, easy to reason about treatment. Reading through
the glibc implementation of $ORIGIN for shared libraries in rpath - even with
an eye on cutting through most of the complexity - doesn't give me very warm
feelings. It feels very hackish and full of edge cases...

Imho, tying the lookup of the interpreter to the binary itself and making the
kernel responsible for figuring out the relationship by resolving bprm->file
and splicing it with PT_INTERP is terrible.

So, I kinda like the concept of having relocatable dynamic executables but then
let's cut through all the userspace red tape and figure out something that's
super simple and outsources the problem to userspace.

I think the wrap-buddy approach here: https://github.com/Mic92/wrap-buddy is
going in the right direction in that it gets the kernel completely out of the
way. I like that a lot more than moving more nasty bits into the kernel itself.

In a way we have been doing something in systemd that goes in a similar
direction. As of systemd 261 systemd _only_ links against libc and nothing
else.

Any other shared library is dlopen()ened as needed (discoverable via
elf-notes). Lennart wrote about this just a few days ago:
https://mastodon.social/@pid_eins/116781776665322560

This effectively minimizes the work the loader has to do at startup. Imho, your
effort with wrap-buddy is related. To me moving the loader invocation out of
the kernel and into userspace makes a lot of sense to me.


