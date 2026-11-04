Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED82606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QF98rpjB
Received: by kanga.kvack.org (Postfix)
	id 44BC16B05B8; Wed,  4 Nov 2026 04:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4243E6B05B9; Wed,  4 Nov 2026 04:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361036B05BA; Wed,  4 Nov 2026 04:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 153C16B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:15:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BAE1120619
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:37 +0000 (UTC)
X-FDA: 85396878714.19.4B6CB79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1008B120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QF98rpjB;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tun3DxnivT6n8ykyvHDle1jgjloMyn9wMMyaVwUBJtE=;
	b=QI2d6wktKIQH/gVvH3FtInzExWPu4D2rShu0TfQhklJDxpg6+UXfxXgQZRO1ptbN9sroIv
	7QHt5nMw7FhhceW/ip0GNXC8zZa5jXzPUB+GOnLXwct0lV4Zcu5DUTM1Hgjucw8JjZKBL9
	NJLOEQVzZakxb5zGBTLC5WlJHDaFmkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QF98rpjB;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783736;
	b=1W03d2N5UwLAhxKHWYf2RqnssXIVAlcSlMxa6dwklOYrj1u198Y/AEUR/HCQlVLKAFjpnp
	ASzXkONo5x4BG/9+Ty/fozHZKOfbbz4i/Fs4LOgm9/FRhEFaaoRIW0ie4sKLEwZI52poDs
	N2jEy4tR/a9mOoMh2rgTr4wJcLqRmdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A35A0602BE;
	Wed,  4 Nov 2026 09:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786C51F000C1;
	Wed,  4 Nov 2026 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783735;
	bh=tun3DxnivT6n8ykyvHDle1jgjloMyn9wMMyaVwUBJtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QF98rpjBzH7nX1jmz4Zo8ykeu0WPbxz0HGt6XxCXrOQ4V4PB3P/wbn5sluIzZ3bgP
	 woOpkCVq06Ek6V7bKkHEP2phdvrGGARxXAl1OBE0IhgkRUa/IQ935AFbXxh1YUY5bJ
	 utfjbIjp7LtybAhtZNGHqFcIoDw2mhpfxaUaUe5IHuBCvHt5tgYAPu/YfrtEAf4jWd
	 v5zbJS1rE1Hby/io2vM2SNwmccLVR3w7pjdFYCtf7rR4Wu4skeBeZ5GH0Q1ajKmHHR
	 yetiYqpJqieJOdcKUSYdWCjNW5p22mqd+bHsoVYbOTO4y8Ft2ybe6f5kRc5h/hiSzc
	 /PiiXfUYZ7Gcw==
Date: Wed, 4 Nov 2026 10:15:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
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
Subject: Re: [PATCH RFC 03/38] netfilter: xt_recent: don't remove the proc
 entries under a spinlock
Message-ID: <20261104-entgangen-nettigkeiten-intuitiv-f39521735261@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-3-59422ed3e465@kernel.org>
 <auig_zhd3L0HEis3@strlen.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auig_zhd3L0HEis3@strlen.de>
X-Stat-Signature: c8txuu7qpw388zwsbea3juwtgbdn1b8c
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1008B120005
X-HE-Tag: 1793783735-855960
X-HE-Meta: U2FsdGVkX1+v1pKOd90KFJwHtdKi+0+WRspAMU2ubiakFTz+d++ZzmRMbiYTRLj5IdgVX/DrYPS1PRzvbuhu/Irqj5GpF/Pe9/B2e6FH9iGNlZFu4wrXmmtc3L3krDo6uOAuzfsDdAGF3G8ZJ112vp/3eIs/q4ojx8JeNsY8mithEE7Xf1nMOytqv0N+tnZibnY6PQClIgozPVE7eG+6t3Uafofn8PuGwoIJaikpo3I4Zhp0fqzHurPVem5e7QgE0vEqiJxkDYAj5E0OtP7woA0ClFoSypVyCVAxWql67LjOqZx4tyoQA0TDCbwNrl8yfPfUHgXtOtxpzA2hLlMGPDMcTr7rCmKeqN6MpniPg1LfKGuL4FuOR96r5PRvd/6cERTdsMUzt4KxMoq9VIYDrH0S179Xd0SUDRPG1U1oEDGBVL2bNAvmcON+H8M5CplPo5FRm3Xcs3Iri/R2wOQfRr/wKPkXEyNCH+stf73BmWBOiXLwzyLpzl9B6lzItnCyynF3OVOFWOyTOQDJ5pH79mMWuoO1742/a6hR+hpm0tlSatn7QysBIDW+qLUPwOGM3GYkr2JGLcgyWjcwAgNKy/KFtU1KhbTDNOxgDvI73Wd0VPjUl44RWYJ7vBq/w4r86s2ww/uieXpRprtZiVHHrgPCXOolZEI2lU/yqUeAxSZbNJskrN9gSClgu+g+WC5k2bAneUrfp6V4fOnXlgucauVBwyKonOaYO1W5UJdH7axXdxfzOatLSwWAg1+DiTyYKvfTJrmDRHbMw3hN8VClDflDUrnEZdTxcHJHiCSV08XfjhOaAnbK5fdG1W7WYjm6WolwpMU5zMWatSXoVqeCYhcnsOHPB2AjFEBmruDWdGtOs5eqdlOdzGOoUFZfB/cQRM6VOaIbJeOAwiuee0vB+Kd+qG1mvzkKG9VKsO3I2ZXd8GHGmCObvtWFdcZpZf1DoxJCy9fj3DwsWZUVt9k
 vMhRtHRh
 PEntRgSJgKjDNnSWxNVIeJRGcwoTKF1JKd6KjdjF0UrXbcvFOxogkRCOqyZ7JLR1Ra5L3E2b5sWcGIzwY5Y07pIqoOstgEuopWP/XFhaFqiRpq3BuFsvxjOcZUCEk7lO93dHsyFtKWMIdzMKN38JTZDU4hayGvh+k7omDvYyoujBhytRsLQJBoV90sp3xQEv0E7xaUB4fJSbO+8N8uC1PJ6QrWdRPaasII1gpM6JxEdQGe9Av7vNKp58aSChko+oymdQP4/KQ/lg1SiZfzDLWIEpBfRwyIZPiTjyUIrYk1ViI9rLNA/771q5d9IOofjUpHVxafK1oDq+1Ln8+uWx3ePNi80jKSNMG5gziIxKEuHsQ2RaioqmfFc4Xj5TuoyCBcQzv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 03:41:03PM +0100, Florian Westphal wrote:
> Yes, but note that this change is already part of a pending nf -> net
> merge request.

Dropped.

