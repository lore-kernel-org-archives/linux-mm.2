Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC337606D808
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 09:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iW02CE60
Received: by kanga.kvack.org (Postfix)
	id D498E6B05B0; Sat,  7 Nov 2026 04:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38816B05B1; Sat,  7 Nov 2026 04:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAFB6B05B3; Sat,  7 Nov 2026 04:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9A86B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:48:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 148EBC02DA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:48:53 +0000 (UTC)
X-FDA: 85407848946.05.7D65DC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B3531A000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:48:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iW02CE60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794044931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rorNI1UIic/55wFWIBl0e+Ri75FN+PnMt9WvbEXwkRc=;
	b=KOauFnxb7/gjfARGQhPrEKMCIjhj0eG/8Uy5mtsbIZciSno2h1bB0fz4hYh3LH1FNzZg4v
	D2I87fwVQ91r5TwoA36PwPhQvj0Y0HqgsnXAQusR1ZBRnC49l2iNpTIXbVQ5dUcdqBEVnB
	72norDOGkcLRCXTMoKTRH7rKxHavIPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794044931;
	b=Q46ljVhiy+BNE47YD0/qmda8WTD/kG7ab22FaPFgdsj3vYaOpplvnG02F5YIHcloeoyFO1
	X9Tj3tHlp3jllqRhXVBCTdZzsN8u/v+WyfBhs72cZ1HCH5QIjc59jGRdn072DK+Sm3Saw5
	Tdc12hyaYiXEVKDyfYROn10vWgJ4MFY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iW02CE60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B777605DC;
	Sat,  7 Nov 2026 09:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328FB1F0089F;
	Sat,  7 Nov 2026 09:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794044929;
	bh=rorNI1UIic/55wFWIBl0e+Ri75FN+PnMt9WvbEXwkRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iW02CE60RHF02fEuqPqKcJf6i4V3KTjWDHzo9DZbo95gORtH0ZrmCJDxrNOCnD4Id
	 9WnOBlB++VD4fZIWQsCzrQhJIry0nbljvHblYH3quGITH2PJSiPvwUzFopDT7DZDt2
	 EHHmNwDws2w9I0dTG1wwVA0PVma1a6Hmr9kUmUnaP/d8oN+oH0kQjwhxNPRQPPwlA4
	 xw0Rt/uXRWnSdUas9IyJY6YU5S7A3WpR700rHxBipZTWxfOwImozcBkuV3AdARVDwJ
	 t+x6t7k7LiUG553yMU1QgCJYHr0hUKV7+ybnwND/Tl+BQydELSVgjRpI3YK5OOLnj3
	 agc3DJMfrldDA==
Date: Sat, 7 Nov 2026 10:48:35 +0100
From: Christian Brauner <brauner@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
X-Stat-Signature: bh4xc3wos46hjhiif4xbeheh6tiqh73m
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B3531A000A
X-HE-Tag: 1794044931-316010
X-HE-Meta: U2FsdGVkX19WjYchY8J5B2JbknYE2ZCvLGf8eWfMh5Ytto7JtKEmUK4P0RwdDftenDKmF6o+FrQpVxK7zGeTReYDC6cY0ekryOZgp2H+swZYiTEsioCrbSH6bpDWgWRk4bH7dpPzRd5ZrVn5FKn3Ei+hDXnhU/3GR6EFV2sJyvAtYnz8CZiyn6Cm1aj3kV/pfoiH5wQvIo7Xb1tAh7hlMYDJo2HAslOUwm3J5xA4lazW9A3eS69v7XR5NsbsK7UGv28liaAIVEeHWN4q/NYmcom5iS24iOYv2+9Wxh6di1/TcdEDDKryWUMlRmJkDEU6tYmwVcIWmVpS2t2rcI5kwn6vOVPwZ2/umUpxe32ghMWDi0/9MOAxPbldPbmq6p0Wd8++pjVN+kQHZdVstsMUltrwUmECrkK7BT3vTDQRZG+RQ4+YcfVrcrYpo09sKXSFfgC+++OhT+AFGXZ0GQjxC9ZkH5cKIUz9HTWb0KmFb/vsjBr339fX+eZoPblEiG9p3XrQDVkp4MNkuIkPiC+tvPKgKyflr9mUCdqPzBW73ugp8Us+lhqaCl1ZmoLbicCT1gFOc5dkvORW+I/TsIRECRrMGcoaRZ2Hziz9LVAtEmyhYn7Em2K8f9Ur5Xx9KUZRF7vmdrWssAgAzzjjQOnzyVWZyP0aMDaOGgGnneLeyKELJ4MAbhOg/xMAGyiIoEkAvkAz8o74qDOTSRvrxXp5kEmOkcWA1kTW00eNE2olXuub6AMLQb6VzaDs232KG7eCPCYtQxEwhF3XA842YPbPGYWjwq8WMUWvyn680gvVyqjGCekQ6ztQ3rV0zUQUzFe2068SK1HQFYaWGuG11qD+qvaFniOVY2M+EQyXEV3ovQ0xuX/braX5TflXktCoNMEx7mbYyBXsJUnvJVfjuM+KbuRTYKlHBRZzrue5jwgnThV3rndeq26Pg+GVcfWbhJWfexAh50qbuGxrS9RG+bv
 z6wqza+z
 5aDVqxa49w2aHe0HBvCmKUdajAgjXoBoOF0VFJnRy7Sc150IWY0S/+pGNmiD+DQZC5n6RQPiM0vPXfvlzSz0xXSM3wx+ewm9mLCJcxmGAuyj1eDmy06tUW8wrg9CxFhIFosf/k0YBra0ds8ezPw7/4/TkPaCmD1dxm4bL+L1zEP95tRKbwld1iKv7FV7VEiQ2dVFgbVyZgDG7kYBjrQOf+3y5PrsDljgT852FRfYkpSnoAJmqNvDVSGcHo3k++S+Fci/YC19hL59EBcFYsx2+BfSM1aPRgnWPpXls7wY5oQPBJhiYKr4tO4v82toXv8b8+M7yh7VlwVjaooGNBgJwLemKCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:07:32AM +0100, Geert Uytterhoeven wrote:
> > +       ssize_t (*proc_write_buf)(struct file *, char *, size_t, loff_t *);
> 
> "const char *"?

I prototyped this to have a detailed reply. It's not worth it.

* The buffer is the entry's private copy.
  procfs creates the copy for this specific call and frees it
  afterwards.

  A bunch of handlers modify the buffer in place and it's documented as
  allowed:

  - afs_proc_cells_write()
  - afs_proc_sysname_write
  - a chunk of the sunrpc cache channel ->cache_parse() implementations
  - thinkpad_acpi's ->write() methods
  - SCSI devinfo file
  - dyndbg
  - cio_ignore
  - the pseries ofdt parsers
  - two more hand the buffer to a char * interface:
    - the SCSI host ->write_info()
    - simple_strtoul() in proc_scsi_write()
  - four strip a trailing newline in place

All ways to make that work suck.

(1) Copy in the handler. That means eight kmemdup_nul()s and a
    kvmemdup() for every nfs downcall.
    IOW the copy this series just removed comes back as a copy of a
    copy which is not acceptable.

(2) Make the parsers work on spans which also sucks and doesn't solve
    all of them.

(3) Leave the buffer writable. Costs nothing, nobody else can see it.

So (3) I think char * stays.

> While at it, I think it would be good to use this conversion as an
> opportunity to replace "char *" by "void *", which will probably let
> you drop several casts from users.

So I tried that too. The thing is it drops exactly one u8 * cast in
ntfs3's label write. And to get this done we need to introduce a whole
range of local char *foo = arg assignments. So I decided against this.
It just doesn't add value.

Thanks for taking a look!

