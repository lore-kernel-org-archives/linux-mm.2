Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BE9606B136
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACB26B05B1; Tue,  3 Nov 2026 05:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DDC6B05B3; Tue,  3 Nov 2026 05:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6258F6B05B4; Tue,  3 Nov 2026 05:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47ACA6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:41:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E66821603B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:41:21 +0000 (UTC)
X-FDA: 85393465962.24.B26B50E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA13240005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:41:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n3928gBIWqHxVcE0Q0TQTSHKUQ5+JmJrD1oVco54lEw=;
	b=Xk73EFcdS8bk2vamjm38ro2gMrhz1AsnzLTJHhWUnlRjjJxjj7aukPqFkyPfCtX39WBJyX
	U4K7CrFxqEYhuswRO5+1QarJA/XxJv1n3pHv0Pgp4V8ThYSoxwq7zALNxEB5wEYTlD/ugR
	LGhWjboEoe6894qLDKi7zUlA3yD0olo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793702479;
	b=EuExxpG0FsplXouNTfvYQezPUPh8HT01l1CcPz/2yJW/bw88G39h621lFkqqJ1EbdeWMcV
	AQuXdaACqlgmVtIgGOLla+0jdfni7O3YKn8SAB8XhTXbEm4B07HbcozT1HecNk+VCdgBnS
	wN/xNKCtDbiyi/TtZXI8fPQrjkXPqhw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8017122D12;
	Tue,  3 Nov 2026 10:41:18 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A98D41350A;
	Tue,  3 Nov 2026 10:41:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fPJkIE266WqxEgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Tue, 03 Nov 2026 10:41:17 +0000
Date: Tue, 03 Nov 2026 11:41:09 +0100
Message-ID: <87ik2exkmy.wl-tiwai@suse.de>
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
Subject: Re: [PATCH RFC 09/38] ALSA: info: don't write past the end of a data entry
In-Reply-To: <20261102-work-procfs-bugfixes-v1-9-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
	<20261102-work-procfs-bugfixes-v1-9-59422ed3e465@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3acw3b9e48rjzr7onqascpunc5uho7jr
X-Rspamd-Queue-Id: BA13240005
X-Rspam-User: 
X-HE-Tag: 1793702479-695371
X-HE-Meta: U2FsdGVkX1/fZ2SmGYAqKhLAre3dRgINIXg6G85JJ+gAJEHrlXYC9QOVXFi3+ILDk37ImWJHNVig/yPJx04qKYvBd2X7B2sWbFXGA/x0qM5cITxwrzm+Cwo3Ac50leURaz0ar1cC59R+jpBy0jsgM9hVEhdx7el2SpxYnXCMO1ySF1/Msr5KwigLMT4zIJO3SMOeLE98Lb9TE3sXhjPMNOvzXSciqwodBqa8T+JM4iCfqUzyVefjTgT6isN8Gk/ASGiKWpVaBuSXSZEJ28MM8Y2HmKyQgoa7EZ1n7qd+l7sZRp/LqQccjz9EUUauMIc4iftA6YtjE4z8M7r1K32QvEjhxfaqkl6ByKGw6DtZrL8y13ZhXCOO0ESaPAqVTfJtZ0FvtgWsVS4cAE7Yd7OTDyBXPVUXqLKib7s9mF3xsZReG880jgLQUAJBWBNmc2rFLEvxR5sQGAlmY9Mfpww0/nHI69neP/l4CzMJreYpjgYmHyktsgJlEP9WBPyfEd/vXrSZfnRanNOmynltZROQVfdEBk9/sMASQhRS0dZjGDUUWqMjYqIK+d8KBqoRytSuWMy7Pgpr1Xlb1XSoFyIfb/mJ/mN0MECtviCyYCjmn0p1NjIHuZ+pHD9ZLGR2lekHrlrPdfHxhOd++pILROZLpQCoNfAWjcTo4KQjmrKC7kZlnunwDiPOs0YsNyZrwKQzjMsSROsJ3Ru+ph8rJdUisuv+Ynlf1W/K0b+UFq94csj+sI6h79Hcds7AoAtrp9LGq9xw28IOtvtJZZYfosd0v5nTroNB040gD1E/kEowOsv8DYuCIQ296yizgBbK1L4bOCwBRz/5fLE+8JCCdYWA5uxEv6cj/VtBP3gRz5scLm+Zh3NLsF5UkbUBQTutK1668zhH4xYdcCgONAgAS/c67AmxluoQC7MvzoQUaOH6fJ3vgjMXli1RK/eIKK2wO6tY5ryD4lezRRbnxX2T3kT
 eghvjqkg
 UTSQhmms5bP54HzLWTDwWNvptNcyLBj87C/1cIRS6Bm0NzmWWe84dMcWMBDdtSkjpZDgVcBEOtruXunHgeQhtXV4FVR9I8aWRHvybNwbXG8KIJ/aTEYLtJM87LVJ9Nk1IDXKxX8BIkxos6uTJnBlsqm4SPM3IZmJiqQULy7UbGnZWJOf0RKd+icWWo8mrpMbaHadfSOInZovXNJMOCK2SncqwYlpMO6CU7st4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 15:21:24 +0100,
Christian Brauner wrote:
> 
> snd_info_entry_write() clamps the count to what is left of the entry
> by computing entry->size - pos as a size_t. For a position past the end
> that wraps and the write goes to the driver unclamped, for opl4 into
> sample memory outside of what the entry covers. At the end of the entry
> the driver gets a count of 0 and vmalloc(0) warns. Before the clamp
> moved into the common code the driver ignored such writes. Fail them
> with -ENOSPC instead, like a block device does at the end of the
> device. Returning 0 would make writers that use stdio retry forever.
> 
> Fixes: d97e1b78239c ("ALSA: info - Check file position validity in common layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

> ---
>  sound/core/info.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/sound/core/info.c b/sound/core/info.c
> index c4d57d0809ad..982087bc8575 100644
> --- a/sound/core/info.c
> +++ b/sound/core/info.c
> @@ -171,6 +171,8 @@ static ssize_t snd_info_entry_write(struct file *file, const char __user *buffer
>  	pos = *offset;
>  	if (!valid_pos(pos, count))
>  		return -EIO;
> +	if (pos >= entry->size)
> +		return count ? -ENOSPC : 0;
>  	if (count > 0) {
>  		size_t maxsize = entry->size - pos;
>  		count = min(count, maxsize);
> 
> -- 
> 2.53.0
> 

