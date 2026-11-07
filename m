Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B214C606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AwkH5jyM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JTEoL3TZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nvoaJ0mE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DZerp02L
Received: by kanga.kvack.org (Postfix)
	id 832F26B05B0; Sat,  7 Nov 2026 04:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E20C6B05B1; Sat,  7 Nov 2026 04:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A7E6B05B2; Sat,  7 Nov 2026 04:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F0D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:00:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F3F4A7BF2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:00:20 +0000 (UTC)
X-FDA: 85407726600.26.C1BC6B6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1319D40004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:00:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AwkH5jyM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JTEoL3TZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nvoaJ0mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DZerp02L;
	spf=pass (imf12.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794042018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pUKIrJSjwOPfwhHfcJFzwrup6gCdhbZ3XgMEjE3Sk8=;
	b=7efk1d9x2OHlP9zYbavLXiU5/ABgp0yDfHG3vm+FEejKj0AOPmWyZgDuY76zEeFKEB2axX
	tCXhE9o+FGo1ArfxkoMLSP/wO6LlhDf1Sf8dGnLhjq8uLCJ9cJVspKb4P5HZHJsMwsDj0I
	ElfTftmGK8OqsEF0kDrfQTB+a607nHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AwkH5jyM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JTEoL3TZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nvoaJ0mE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DZerp02L;
	spf=pass (imf12.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794042018;
	b=0l7yd/VDenvOgahfiABYzUxp3ngS9MikSbhkFBQEWDjtl703NhODcU8wM/iBRm/tiTJrav
	E3OwroWYtA65TFCh6m9A7KBsFntPqo0kW1VEAFwrifzU7o2t09TGPKelY4HDCjsZmvcbt7
	po/eD4mGtpDpdFjoBQLH3Z6cNvOZX2E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 630761F74D;
	Sat,  7 Nov 2026 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794042016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pUKIrJSjwOPfwhHfcJFzwrup6gCdhbZ3XgMEjE3Sk8=;
	b=AwkH5jyM7t60XRGf7G1aRSt+1A3cbarzW4z/QkvISjLGNPrA/fY2MleEP5q/AQIm+UOa85
	wJkleCWTNZsU7rGkzPqgTOEFser1A2ESxcK9o91TyOKwj1NxwYRnab9MqOSmomM2duqzSM
	4ziRifDlEsg/eNGZ4IfRyZBtKF7+5L4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794042016;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pUKIrJSjwOPfwhHfcJFzwrup6gCdhbZ3XgMEjE3Sk8=;
	b=JTEoL3TZlb1DCclunsyxaCbXUYbLeMKEOnsS7PWO9bNheMA+zCRiSp1byJB7A+sAicRsv4
	5OXD2QVrenEMHmAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794042015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pUKIrJSjwOPfwhHfcJFzwrup6gCdhbZ3XgMEjE3Sk8=;
	b=nvoaJ0mEP/zd/0bKFGcoiLmtApr9OQGHZOiEECFWhUq1H30dGD7ZkdmACOX8M4XQGS4NuW
	oB4Mc0g4OfzK2wWf0UF/9cqPMqA/oflypYavZBONS2BSNW+J/B7gdSUDzy/0qA9b4r1pv4
	UXAedxogQW7c2CJkDX8oa4Afmn/sre4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794042015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pUKIrJSjwOPfwhHfcJFzwrup6gCdhbZ3XgMEjE3Sk8=;
	b=DZerp02LRPNT9d5/AecFdQdh+IJlOFhOxwpkpzQNy3DQvQ4hOwgMkZ3mhYuZ46BFCA5rf0
	CaTL33x7XZsPDhBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0528132C9;
	Sat,  7 Nov 2026 09:00:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 19k0LZ3o7mq9VwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Sat, 07 Nov 2026 09:00:13 +0000
Date: Sat, 07 Nov 2026 10:00:13 +0100
Message-ID: <87jympyq1u.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2 03/51] ALSA: cs46xx: hand the region to the region proc files
In-Reply-To: <20261104-work-procfs-bugfixes-v2-3-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
	<20261104-work-procfs-bugfixes-v2-3-021c84d852e0@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Action: no action
X-Spam-Score: -11.01
X-Spam-Level: 
X-Stat-Signature: ozwjtn54z1nihun17m4dfg3m3eu5y4t3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1319D40004
X-HE-Tag: 1794042017-916490
X-HE-Meta: U2FsdGVkX18JNzRZCKmqomRfDthLrUYB2Mws5n+IgWFsLfRo/EXyeIcAAUBCY3DDmyiVQJG/zDchYzUJth7QTjHognDzQ5hzVTgym9ACxz4I8D4IPq9jgPCXkSR+/HZpuCDicvq78LmGZErC+jScFH3koznCa2pnqC8sSDeZS7yZU2vrEFzFqcY4gEPDgNohbhwgkuHjVAT19i7aPna5eNa2CryD/bAcPMt582JwZRhEm+IxRNUtqm14uyrb6KFLRGi0GBZbK7HCxFW+ZFOAAVI3mo7xm0WRCHy8YUyFlr2b363u+YEB342cBdaKY7n4sRVCyddFwqc2XEp+x8cvTpJQiT7bFbxpBJoWWBQMCeK2RDkaFUT6nC0NQPO60inyqWgeWiSggl1JFkOH+3V14J/EXhoTJu8gpSRR1SpyUFCU3loZyazvp7eVdRWFZvu9GYeUXri/F5Drgatncs4HmbVncZed2cmVS81yhLnJPNAMia/I/8zrz3KV49V+yWxfgKM7xYqidcJju/ZDXaHcGelWdRDSujV+6qWz+Kc3DLJ1Dmk4LFOn0/eIk0clXxIpi4jVzv0f/+0Xbu6CvAoOOfJuwj3iBr9GZThcbVXP6/xJa732rhCovnj0soScECMg5LuyaHnkbWLwTcotmRt5IYUhl5Ng7a+RPb9dl4tDT24pDglVr2ncjs+lz1LlA97R90nJifo7ye4tSdS8gu6O9IkuhPAbPcCu4jHw5c/W0m9rKe41GNZ3l74rGu/seQoXebVQOxzRzHaDR0LaUgMbdNw7oRZuPHX4g2nDcF+YUZXavkxu2i65+IIr+iNOg+lWHfCf/r9t/dSLPvCmB6ychW2GYEbU9MS+YUvPor9SwHkipXo9EZHbWxypIzZ4C48f/1bFzTgeml1ubA7KJPtVAyjLZJk8nVj+g0mklVVg5Q1ouVy1rVxeAO4hJiVEEZaNaCY6F8Pu6cBFAKsKtSi
 vmfearol
 1hgUJcL8MgfYjQlqOXdn2n+/HB55vaCgxDK3NnBcYsUuQHYq7vTkhDV249/xu6SeIIpmqjHLi9QGg9zCepJPNurkrqegTx/DYhu4iVhPq2UagMhPQJeUp3wC85wnx6+J9BWZJFejDtMFneOA9EdPMXJtC9slDOwnze8c3JJNjDn/uknVHt1g36VMKW9AYlEouaK1xFWPePbG+HoOlW1LAqZH2nnNl6zlASLdej+vxGCmB/MzNwcmGnOG2xi2eic1f3LsqxURUGUmb9ns17VARLqKUWIGPKmGFxk7E4Hoz38GOlGtQrjON4TfmidTmY3+surZ1ea/L0MdwykQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 20:16:45 +0100,
Christian Brauner wrote:
> 
> snd_cs46xx_proc_init() stores the chip in the private data of the five
> region entries, but snd_cs46xx_io_read() reads that back as the region,
> so a read of /proc/asound/cardN/CS46xx_BA0 and friends copies from
> whatever sits at the region's offset in struct snd_cs46xx instead of
> the mapped registers. Store the region.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

