Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351C1606D823
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N8czzOm3
Received: by kanga.kvack.org (Postfix)
	id 517876B05B0; Thu,  5 Nov 2026 14:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF8E6B05B1; Thu,  5 Nov 2026 14:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CDE6B05B6; Thu,  5 Nov 2026 14:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4A96B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:28:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2813160BF4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:28:52 +0000 (UTC)
X-FDA: 85402052904.16.3BE9353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECD62140009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:28:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8czzOm3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906931;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5ltLRfeO7A4ze3tr9EcZS3s3I93T55/6iRGXRatBcI=;
	b=CYgx+cEQ7KGDZEnnyRYgw2rckQbBALIlVq6CeUnkkctWIbBIZyrRVGsrd8YbzXloCRAYtu
	PpX9tYWRSO9J43blIsukODe+31R+6I99+WKU2FVhLuqNxdxHVjq9g0fr3rJCrz/rqmZtm4
	5rdQmxGO8q09iC2tiL7esbopBAq0PI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906931;
	b=5JxHwefmn6U8YKyWKiQGuw5G3f6/Dm8ecu2u724Xl2NrUdR0EFlx9Z5oojlcRwfjYe38Td
	4rYK8s/6hWHOQppP5/ccWc7G8jzoisAUwBJSUtYP8rDVma1r0qerof4YVvSI+Z90kv/8id
	OqkHCL4AA4Ktq8tkhk8JvAsY6wb1bYc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8czzOm3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C4684168D;
	Thu,  5 Nov 2026 19:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F791F00919;
	Thu,  5 Nov 2026 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906929;
	bh=t5ltLRfeO7A4ze3tr9EcZS3s3I93T55/6iRGXRatBcI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N8czzOm3uss/Nev41wWI2HCgtA/JJ30J5ZI/5HvqHyryejYB/vPH/hBylXVkVGrv6
	 OielTQZZJsAgzXMX0XY5+ywbGo0mmqbyFRwY2koxZomesAs/TJ9/gk+vP/71ryRjrz
	 T4vkNotZqPxmBNAvJ14HURgj7iVi6JGCZi7FoFu5UsPJYhvBEXafmV8KZulQt0TLUa
	 bnhBhsrybsI04J6qaEoTmohzhtxxwuJRWFtL3gmSrI+vhB1bjBR5l4UtjzfZC6c0lO
	 DCD02LTUhjPPRIlhUjpD4vyOQAhRmKBCDZpyL6ta2I03KLDunRpmQHSavStcgYROjy
	 RlifknHgKJUtA==
Message-ID: <sashiko-outbox-199864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo
 under the codetag module lock
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:47 +0000
X-Stat-Signature: wrryyhy3i3pk7ap7n9ksi3w9ibppu6tm
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECD62140009
X-HE-Tag: 1793906930-607602
X-HE-Meta: U2FsdGVkX1+A4RZqWAbouyhSaHG84OAaN6AiZ/DaXI9ubA09Q5nOM7yGTAOf3mv5ssE8xujUlpeNWO9d1NhYf/nKTwfTKFAftQzX1ZjQLjBn0FvC7mj//rPHsPlpJFJgre+uB/pVp4Wn2ZgWgq+vGzVc7TzrxC64TXEE2FHfObhkPAReY5D4oWzTRKIoUK1qke011kAtruN7p6Q4lk6yS5P6oABxE4BTh7E39bKNTriTgGd5ir6TAeKmZLbE+Xz12XeKTkQaUX4XSdFE2AoIRFgjbucHPLA5EB6Licf67xw5SMadrvIB9ijvV3prxCVWxIotdaYkSyYiX01BT/9cxDidCnqiadbEQcGaT5PWvTjv1h3k0nRUFuBE85OC0BVXfNaOd8WBAQMEF9W+nYid8rG+5hcoO2KDI5m5HnMqbFVqYV5p6a5ecjxk9/FbhL8pxiBFwKTZduaTK32PzolbpNP++JwargB2eUqJvpHDkeHSMTvD+lgrGTgNA80nLNPsEUtpMeeFlpW8rN7EmMQRWOzjI4roewHKzbjOr6SAwzr759JAN6rII1IABMky8CJT8zAu4HTCNZ4U7lfo+gDYGPfKgjmS0tf0Z8AJbDSR7dK9iw9KPRdQG/l02D9mQu+86z4O/tgYo9axe4NRV+NjVQDS90dAtL3LWtaSROUtIHYyACM3uj0XboPT035zfRG2sbqZ8d77WaXwkkPbZDWyViLmPU9W0h6hbUZ+HV8TwqohK/XfZopG9eNyLXzTQWYyEjsXhv+/DZJXeccftcdBXZnE3glL6Eh5bqVMc5W88FNCeii9qLOnOa3nTqRRuI9gMRGAPzQ/7/JjTdJqnoONA6r3OLDfx74nuxrqhFB45m+9qlgGcThkkqkQ7N5OwI2f8caQXOu1UAwojuFODWGUbgivDbBqLea/IpsyRyQbKVropc1hA03FyL217mrnMy1SxkPTLoEXNJk6UnG+dHG
 lhp3mFt3
 v6fsf+Ci4pqPWMmH9FJlk38UV6bb9s+I5maS4y4NSX1jWmAySCAEnKCzikZEWZp5l937BEi4KRLtJ8V8H+yHDZgRiYoWMLRSdrUJ4u528VnK8vGLjVK5OuohJxN74TjHnufkNZ5PeMeT03+w/eG0CZVlXxTEHMMOGrhWItUGIEG6A+cbyJBFjTI17BheBN8wiZ/SsKnYPLrnp1QVsU6V8aVvmuULwdwhDkcJsIlm/BnbXC8uMFyN/M2P21Bl2Jk8d0ZRuoxDdvbadivv6vznQ9Vv7367ugs7ofGi92/7ilLuu8astKuwFPfS6bhLosKiKpsKjgZMrxQ1P0vEvCAXOC5VBygvOQV38CosQ52bl6sPRv0UOdjcm8yezdvVFsQe0MEL/2pBNTamY7qVnOipAJNsLSLIQAynWhx6ZwtAGM9como2sdL+JjuFTZe8qjAjB6OmYTJm07//Mpp7ldhRnd/6T91nAj6FUXbQzKSw60FznDb2NIzXN6urNCXuHtGQEtITFqfBEWCutogExg6XkBzYDbM0mhvtxFfLxaK15PTSAJxsfW6A3XIF984T6WJu5VATbN5wlVGsUphwyZVi1eD4nX1Fs01vErDHyUL4Jolx0ZdVHKll+cpL22rhl4uWhQjmjCnnlkT1U+Jdz3RkFRG3U2G6Ri/Ru7xDngaj6z+tE22S7Hzp08UIC3Md5NSnNJl8p6jFlhNl8anNd69BLLQT38g==
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
- [Low] alloc_tag: unused function shutdown_mem_profiling_async() when !CON=
FIG_MODULES
--

commit ec0095b3ecdd2d01651f48bc80cc81d976e06106
Author: Christian Brauner <brauner@kernel.org>

alloc_tag: don't remove /proc/allocinfo under the codetag module lock

This commit defers removing /proc/allocinfo to a work item when
reserve_module_tags() fails, avoiding a deadlock between remove_proc_entry()
waiting on active procfs readers and allocinfo_start() waiting on the codet=
ag
module lock.

> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 82e2c3448dcf2..7d7ad67049537 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c

[ ... ]

> @@ -604,6 +605,26 @@ static void shutdown_mem_profiling(bool remove_file)
>  	mem_profiling_support =3D false;
>  }
> =20
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
> +/*
> + * A module's tags are reserved with the codetag module lock held for
> + * writing, and a reader of /proc/allocinfo takes that lock with the ent=
ry
> + * pinned. Removing the entry there would wait for that reader for good,=
 so
> + * let a work item do it.
> + */
> +static void shutdown_mem_profiling_async(void)
> +{
> +	if (!mem_profiling_support)
> +		return;
> +	shutdown_mem_profiling(false);
> +	schedule_work(&remove_allocinfo_work);
> +}

[Severity: Low]
All callers of shutdown_mem_profiling_async() are in reserve_module_tags(),
which is inside the #ifdef CONFIG_MODULES block further down in
mm/alloc_tag.c.

When building with CONFIG_MEM_ALLOC_PROFILING=3Dy and CONFIG_MODULES=3Dn, w=
ill
defining remove_allocinfo_file(), remove_allocinfo_work, and
shutdown_mem_profiling_async() outside #ifdef CONFIG_MODULES trigger an
unused-function compiler warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D1

