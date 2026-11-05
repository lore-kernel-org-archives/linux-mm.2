Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84419606EA66
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMGngCoO
Received: by kanga.kvack.org (Postfix)
	id C2CA66B05CD; Thu,  5 Nov 2026 14:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4906B05CE; Thu,  5 Nov 2026 14:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9B46B05CF; Thu,  5 Nov 2026 14:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8673C6B05CD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:36:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10E59A0C19
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:36:02 +0000 (UTC)
X-FDA: 85402070964.22.57E3028
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B2C2F20008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMGngCoO;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907360;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7pbLgB+bOANV7ZH7bSfet1egKll+CXGNKYzJQU3Yrk=;
	b=s0vGIypb6SLjSskCZf3W5lNrkAEqXSTF+2hT0ADcjQuMtuPPcLPwjwHeBHVVNOHerdH/LC
	8y010hpyjTIrVxnfdNOjitaK7ILBd8y3BRZT5sE25aCXfhhcsmxamJgp3Q5IxcRJi6Qz8x
	lsP72pGvPloNUZg/jc/foemMW5gwg1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907360;
	b=A4OWaQNYizWbFHmbIQTpfKmToNZLkrGfgoM9YW6KrTES5DwErMvC034W5qpwpzimYkgxku
	FnNK2XlwLs+Xb9AcmoIYiPvR6FfMIHSNJn8msqsN8nrkfTcZe5lnoEhMmvlQA0d8gj509p
	7Y3CGGR6IT+PRQnJCVTm9cwJ8RlpQ8Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMGngCoO;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B0E3601EC;
	Thu,  5 Nov 2026 19:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E9A1F008A3;
	Thu,  5 Nov 2026 19:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907359;
	bh=f7pbLgB+bOANV7ZH7bSfet1egKll+CXGNKYzJQU3Yrk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iMGngCoOl/U4CYIB1rTzS3RguQRqLRp2sKfBp3odJCcMgrP4Y2V8PmtfZZo1x5Xkv
	 FLC9VNWmdujwFQtrFCf8Mg1QUR9V0cBoPIZOnqaamHivU1nhWiKlmj37JQBwx8Nw4V
	 gnJGb6AJHKNc0HghHI9fJU1uQS16q3fA1JPSybQgU9VxlezkJg9W+I3Lt4LPHuBS+G
	 M91zjKny9mmSeWhknnqhOUNYocrnIZ20lXgBv1WbhSSK7LtbVS4MpUGhBLakgtch3v
	 NiR+5uPctDAbSjOlOz7BSSMrEU1NCpxJBHKCCILKG0ymIlPQ81348+1c7a3Gat7yd+
	 kdKHITt2fXI3g==
Message-ID: <sashiko-outbox-199951@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 21/23] proc: let lockdep check the pin
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-core-v2-21-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-21-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:57 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2C2F20008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ebo5nkje1pwfyychukny9n5cts756roc
X-Rspam-User: 
X-HE-Tag: 1793907361-854343
X-HE-Meta: U2FsdGVkX1+czFWTpyZo/jKBSS9Ta94EmTOc+xwmDSzMFZz3/An8GE1IrHAhHfyeqamyPpv7QBoDoyH6637cuD4Dzfma7d2SMZydkeOHdKEPlo6C6dK5HaZKsEiHoggKd9TDr/UkT4r1CbM9R09v0rFB5s7bi1z47bQOq5pf5925HRYkGddzvI5tDUfquriK3+ouvryk8+TR5gPvRfZCFWargwRyJExGnkAOutBtsesZzLaXixkKh+kOKP0mvrPI3lZSViL6X3ExgY7mGi/UvufDm1G0pz1S2axI6Khl0whyPo/AL7TgIW9iL11GOvZFuJQetfOv+o4/9uY4Rt5ksdDLpCnmRPNhgi1zoR5f4RlmgCiyatMVf23hXIulBW4HsI4GFNsPb//yeV1sUVuw6U/m57WQEOsDQ6XCMzbF9jaP2mpF5VEXymARVfduiqBKKAzS8dFK2Dt5sJvIBifrW9p7jxG1floXB2bTdKI4Dtk0KD3KMQk5gZn8Z5hlqZdk4vC1gTzOO3GkJl46WMvgS9NO71RJVn7ev8X7zc2wYbjoVCgv602qA3i6RotWKUMZ6o63YA5tknCqfMyIGSyb1YuXHD+RQvG1L1vJMTka2oA3suARUH+uCojInmbw0Lyblh4tLvknlGX+jdSE+phGT0n2nF2zLgWIrOtXFTcfNYZQcMUO8cValhrmQo+wooFyf7I94MZtSYnSZj4eWbBvQE3HVhwg84u6X0r0NYBPEdfEC6YO+iTi8c6ccyrr2l80NWMx8vG0W5x/igrJq/2py9wYdaxvba4SsgD1GNBrhSm5LB9/wKzAlB5FeT3rJJTnTrH5WTBVqKFwreasNcX+NS9YyNAaiX4Ky8I0Z+1XbEImMFLe9BzRGk94xtR7i8CQvqUPy98MH8gdE741pEVJthQ6CRPfCbMzfLqxAE2xTvArzzC1I1KdeaR1ME6Jcuw7rmp+eJIqEtxJoIi8xgs
 90my9nv2
 6qgPKb2H56Ii+zhSRwZNO1zX2o8qLQ+0/yoBZXecDa6m8Hmdf8zf6rNqvwgA80Clh2Jmkp/HDcV77yruwtRGzFeYvw4iaX0AwQDKqXdfwPm2D1htqT1sjF/u95KxHeNep8nIDioCPcmKSI4pND+Dri5xllYTidDUWisBo3YwWijybeeowDOexcWOlua/UEmvoPlUtKVmQjhVjdxye5scwWr7czr5zQygZ7Blk5rPzOlRiVQL20a/4yZjjZNVFCbnsB60KCIOCgklk2gyAJWgzqkbCTyLtcgR/BvLM/9lAkuw3lv4APSWPGGDGtAyNIaSA5gF9eBbk9OpcyzOcE+D0phVwbG/AyWY8K4eqD7dyAEfSd1MuaQ+zGH15efhKZX6a/lMMQxL5HFhXml0wNIh+fNYrRl5FX5JOx8UNOOpdYUtOmPMlgMGCK0EV/Z1wwekdUt7fbj/ZdcAr7h0dB7gImp5+GQZacKDVjUNGgznECrRvT11JGYTmdyvxeHAfk8Bg+P7PV34UBKfnkIJ3gWasuYt8ulleVIw8RTixmkmdDKN7UFsD3NdNp8XPFKqrMcYQ4VNU5N8jo7a7gscd8cXXnkzNcHVYY+SNK/0uI9tFT3bvZr59JJxwqc268mNzIcN28tAI4lV5wZ+BEFUSUOnJrcBR/cR/U2GnqyvS
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
- [Low] proc: kernel-doc mismatch on __proc_create_net_single_write()
--

commit 095fce4c95ecbe25e644f1a3fe90061f695e9271
Author: Christian Brauner <brauner@kernel.org>

proc: let lockdep check the pin

This commit adds lockdep tracking to proc_dir_entry pinning so lockdep can
detect deadlocks between proc entry methods and removal under held locks.
Entries created via proc_create_single() and related helpers receive a
per-registration-site lock_class_key via wrapper macros.

> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index b78d627b024f8..9ddd7c323dfcd 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c

[ ... ]

> @@ -232,11 +233,12 @@ EXPORT_SYMBOL_GPL(proc_create_net_single);
>   * pde_data() on the file inode.  The network namespace must be accessed=
 by
>   * calling seq_file_single_net() on the seq_file struct.
>   */
> -struct proc_dir_entry *proc_create_net_single_write(const char *name, um=
ode_t mode,
> -						    struct proc_dir_entry *parent,
> -						    int (*show)(struct seq_file *, void *),
> -						    proc_write_t write,
> -						    void *data)
> +struct proc_dir_entry *__proc_create_net_single_write(const char *name, =
umode_t mode,
> +						      struct proc_dir_entry *parent,
> +						      int (*show)(struct seq_file *, void *),
> +						      proc_write_t write,
> +						      void *data,
> +						      struct lock_class_key *key)

[Severity: Low]
When proc_create_net_single_write() in fs/proc/proc_net.c is renamed to
__proc_create_net_single_write() and given the new key parameter, the
preceding kernel-doc block still documents the old name and omits @key:

/**
 * proc_create_net_single_write - Create a writable net_ns-specific proc fi=
le
 * @name: The name of the file.
 * @mode: The file's access mode.
 * @parent: The parent directory in which to create.
 * @show: The seqfile show method with which to read the file.
 * @write: The write method with which to 'modify' the file.
 * @data: Data for retrieval by pde_data().

Should this kernel-doc comment be updated to match
__proc_create_net_single_write() and document @key (or moved to the
proc_create_net_single_write() macro in include/linux/proc_fs.h) to avoid
scripts/kernel-doc warnings when building with W=3D1?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D21

