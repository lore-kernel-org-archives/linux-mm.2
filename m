Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C8A606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkGIp68v
Received: by kanga.kvack.org (Postfix)
	id C657A6B05BF; Wed,  4 Nov 2026 04:17:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3BC76B05C0; Wed,  4 Nov 2026 04:17:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A6B6B05C1; Wed,  4 Nov 2026 04:17:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 961F66B05BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:17:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BD5D14063D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:17:45 +0000 (UTC)
X-FDA: 85396884090.22.339180A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B1B6740005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:17:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkGIp68v;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783863;
	b=Rf5AJ7dpUfWb/jD55pVRSKrvl2tQLT7B28tmK9M1i6vX/qWojp1h45eMhBM9EARn57kVS8
	0doJb4bL+q16R/++etl8V6/pk7JC7fZtdQV350hM4m+lLFv2wRCn+IpK7cbEQDH5yxoJqm
	4LiL1AhAEYmmDv+dK/72XJEJB8VRxNA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkGIp68v;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFLCfIpQzvj87maXuJncKjZMHxfbMjkVEErOwSrEMzQ=;
	b=WYFWMvpwB+pMr6nWMBqSM/zdyRJvbDza7OGdIiIdtuxl10guGcG3FQGkigjGsLX4BujEnu
	33b2wBe5sgcnxa2GLZbPTeWfEEIHD0jDYbn2FEDypyxNOVq5KuWgFhUkqhHuuL4aZ01Fz7
	rb0uc0PuATcDixlIZtQ0gl0ymvuXf40=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33B61600CB;
	Wed,  4 Nov 2026 09:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9461A1F000C1;
	Wed,  4 Nov 2026 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783862;
	bh=vFLCfIpQzvj87maXuJncKjZMHxfbMjkVEErOwSrEMzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkGIp68vobiZwB2XixXdCJHgtF8bS2InhigVuwsdqp6n5/W+M82eXJQmgMDIXncGQ
	 ZsgLev6upKoTph4wRGMw/6Rt8tdd4yiEe0QTNTPemQ626tgZDkM1GcZGQlIINcGmX1
	 rweyg/M+elK322suBIlSSUF7Ca/phJp24NGzpraEYkCKjrptZL+chTq0rR5ps9q2f2
	 buSjg3t9Zzbjt9a55NJ2t3tMIsF7dtK6fdeAh04poa02hll2Rco50kbc8I+oEfsxAS
	 NzUPxVvIxDSaOzz7ERaAm3QpoNHvfOUNEKEQothQH0rTaYd4IAl0SGRh52pJdJDENe
	 eaiECSjcPGAaQ==
Date: Wed, 4 Nov 2026 10:17:28 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of
 config space accesses
Message-ID: <20261104-beugt-kapern-geehrt-19e2e2dd58f6@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
 <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1B6740005
X-Stat-Signature: bk4hifnud8h4bdecq9r73rouonntpfn6
X-Rspam-User: 
X-HE-Tag: 1793783863-466238
X-HE-Meta: U2FsdGVkX1/21cBDDcrLHbwfGxm9sIoV3ul+t0m13uByqzSlYngDj+Wy2KoGs/51QGuYehkWh+b6XljuoEyldasv9tAcuMOTmLA1fc2kxxDsCEn5Gl0dRhB6Z7IRJAW1dfol+fTpt1DYyOEuQiYhQJZgNryCdk8Ey+pqzdCy0PytXvDdwAWi55UC7CkL1wQyY6KoZz6q/qY+vmdKwbIaYjznE81JEXzouWevhzZF3YrKpLZbZQ+DH69f921iLtpcpOFY/29hprzXneJszKUgSihTweajmEzvSpb4eolx+6OJf+whlmVSl61RsM+8xf6mqQcbj2RyeSgbbnoXRgRTX374hFHdMeuCLKTi582LFMvMMC6NubFlqwmDOrG1yJzkCl4IHJS9KUuK6GmEl411GFxwSkF+RwtJcfm818vtDHosxbUIILJ8c/qdYa+jRQT3v6mJBsPwDDzcZ8TPKQV/LeHwcFnXH0AE1RqplO8fQhjuZjtmZWczWDC9S+4B+bQa+Z4axyhWGPfevAM8br370kQpCMPNrmyADAijjMvYAmGsy33wJ3I1/yft2VyykQuDvodyUvV1/STWkt7RhA3RNPqPY+DRcND41PMt7UuJEWkZtv1hwWrsuCWI9s0j5Cmcl7Is0I8Rm9o8bFQAJ5Vw0LmhPeVKZkmCw7gaICRglX/xwFJi41JX0Y57DeuVdl8nqs1SHjzfJwgndNv/a7RlSBZ74/3F5cId0FnQkjmZMUu1nORuUA8EhJKUog/GuFSFY+FmK9iaBvtvBI6N5yXgxOchEcK3MwA9OHCkVHhcC4ZjpFP/ss+RaevKcjQ3yicldGKKs/m517MMsGDtZVpZu5Mrr2HaGlQHJg9bgJYzwq231iq0nclpFpPI5l92+Yvlj1SJ5TklcdXFlJ/3x272a2S+2n8oClW3b+4GpoHRal0/kwvSsuB09UN0VUSRrg4UsDSvy9LszA3rannDlgV
 sOiX1nx1
 CrEjUXao4EoKwA78yuoDscBJwekt7IXm0+D6rRWRrUj9kPHz6Gr6zG+XudnjP37dbq+zcgR3pZWQXwHlLCxRdYCgOeqwEvSoLQiVXTGRysP1Tw019Ni5Qr9hLoMyguaY8l65+lnafz2cdSmJ+NMFFspUsmlmamYslLkTYBPJ9Kp4SU/xLT6mcdLi3eHrUEpxmDtcj6z+Wpcq9a/MdAbVN0Y6j+dhjBgacApa1L0gifZIzuM++3oR02NwwKo/7qiJZO+7DpG6pDzyGYR1QRScHmCkLT6xhofhA8eSL8ildhMOoHbRDkaw6oxxk/cCH1ceNleEUl3Qpu7h1RHm6TwufPAZFDFexEIw+OgsZSpWZT3zPZ0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 09:58:51AM -0800, Linus Torvalds wrote:
> I think this would actually be better with rw_verify_area() just
> checking a per-file maxbytes.
>
> We already have that logic for lseek and friends - using that fairly
> hacky combination of s_maxbytes and !unsigned_offsets().
>
> We should combine s_maxbytes and unsigned_offsets() at file open time
> into f_maxbytes and check that not just at lseek but in
> rw_verify_area.
>
> And then things like proc_bus_pci could set it's size limit in one single place.

Yeah, I like that.

Hm, maybe we should keep this and the isapnp thing small and do that
change on top.

This also might mean a change in behavior. Because a read past the end
returns 0 for proc_bus_pci and for a regular file past s_maxbytes. So
that would potentially need some more changes.

