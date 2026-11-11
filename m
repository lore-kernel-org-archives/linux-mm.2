Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADF7606A8A0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=vV5nh+mu
Received: by kanga.kvack.org (Postfix)
	id F08AD6B05B3; Wed, 11 Nov 2026 06:54:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE08C6B05B4; Wed, 11 Nov 2026 06:54:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7506B05B5; Wed, 11 Nov 2026 06:54:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C28386B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:54:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53F62A029E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:46 +0000 (UTC)
X-FDA: 85422681372.27.DAC66C1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEE3580004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vV5nh+mu;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794398084;
	b=0E1psHtuiR9dKfeZ17oMmZZb5p+oTZ+cup+OemdPmcS5HcYrqhTWxH964v52BH9GXYHq+S
	05Az1oJHjLnYiDNi8j80SOPC8DOyiDqIfWjfZNgH1fvizzuZP2j/N81DVnYhLDG7IrRDLV
	K4pHXRQJusUBMjMEqucNHo4IBVoE6WY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vV5nh+mu;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794398084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ep5AJlsUvRo/Sl9Rg+NwP6D7Lq/wQPVEaLy1Gie9QQ4=;
	b=WHYllmb9qLHWAYlJenNkzTRDGHYhYS6Yqzr4EEd/2tkqk8rFWv0z9Uc4wg6Oz0xQD27++T
	5hG0m3OHhakD3f9IgcmTd8yMrhhLF6w7RwHHjfujYdDp5+0q/OfLfDO8MCISTWufteKqDm
	mPuMNVO6h7uuA5GbsW3+Z+Bo2VxczTM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ep5AJlsUvRo/Sl9Rg+NwP6D7Lq/wQPVEaLy1Gie9QQ4=; b=vV5nh+muii9KUwMXfoK65C9FPK
	aNSl0OiG0j4I+LFXc7WeA74kYOFf834TBtI7qS+ZEF0cf7hSHSrnoI47iOSAXQPCAXQU9fne6O/8R
	G2wk/XluU5ugbAZ7f5jU4JBscAk6nd/VyyPFhAk65/tq7U9wZjt9SJD8a8A/m2R6Cxj7l7C76kg9H
	1KIPLAQYQ/Fv+JWvD04uouKwGYT/8gu4uHiCPUf9Bg4PxVdqeWdNvrfltP4AIW+MdO1/5WBfOmizl
	DellelcAiKmJM9KaaC82wP83/72jAdgWurCb/I4tMo/beG16KgajqNT/PO+VCT1shIIGmoQlyuzr0
	Arg3hVEA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xR6u3-00DA6f-37;
	Wed, 11 Nov 2026 11:54:12 +0000
Date: Wed, 11 Nov 2026 03:54:00 -0800
From: Breno Leitao <leitao@debian.org>
To: Christian Brauner <brauner@kernel.org>
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
Subject: Re: [PATCH RFC 25/38] powerpc/crash_dump: check ioremap_cache() in
 copy_oldmem_page()
Message-ID: <avRXHYDKemkiDvoj@gmail.com>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-25-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-25-59422ed3e465@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: 1mefekhqr8su4bs7g9fy85kzuyig7fa9
X-Rspamd-Queue-Id: AEE3580004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794398084-149384
X-HE-Meta: U2FsdGVkX181hurWkvsJqdQHw1GGY715sq++UrUk9szxh2vESr1ujgF2GTTX04Nex8Wedss2JHpDkTsyew56PiBwXNwbEeAHwlO5uH/Pl9r7s0RhZXZ0mX6bCGHSIvalFDFYqvzbCHFeULyQBlMbtQ1LKKPc3Q5rS2ftEQYLWNTMEXPA22EwXHdvi8d/tE5/qQFX4X825GaYSmaMRgvCByY+G0ivN1R99OVvu4m/eTzsLuyNMmJOGYI2JA+fvlF3JqvrN/0123Rr+GxGdwLlhM2TYpxrYNGjwDYIBTkYdJ44Ipc61r1alDyLxuAdtG9rJLLqBlq5iHESmQbGIwZJCb3U/aAzIygNdK9i2FltdXnkibbKQ+5byt1sK11yqmnFX9Ldp8aHDUf7ONCdifqP45EZKtHRu5W3MMIDJ/5RqznYaDoexUw+YTwrNPqwGFNgMQ0L2aK7v+C9A0EvKgisX+Q49QDPH3eOqRVcAm9AnAFgCjfzFz3bOOVqq2GnSsCJeQeNG4WHBfxC7/KV9BQRnaghEz/Ft6kXmHcMjBOFQbaYCy7BSph0i82wwEs/tiP3AaMar8i0F7+YmiDPhymBuiRFVXwx2iVxKJ25nI5Dsc3JCes9oi1ARFAAtIxOqbo83uByguVGGjl9K5Gjmqi1KJpbUPPGD1pSMWVFH8wBJNBC3U+Ut5T90gIAvMUO0uP4/PWrU4YwnAj38ICMRNqAj+h/dS0cl/kAchvW0dm3q9VJfBS6/Ze5hgXn2j9P8KzKWZ9b1/ECX8JJibZ9EboMBefwdEK7qYblSJf/ygYyI71wm5jFg6QvQcHjVRsw/c/wl7a+hDrN/tv9ArNGJqSGhfuJMrBuggejMuTI+pcUf1gKgPOaCfApKzjm4An0e2s86jG/c/0PSBCgxdD0TcaVRsh78Uxze0YW11Q9Wj764i2TYTIq0WISXCtEIuUqUS9YjMV+rRymDDyeQowxev6
 SuFtRegt
 GOD3sAiUbUCCZtsKScJl4VCPZLq4qK6acdm/Dxo/2ji3QScHsbEjgvsIXpqXWc0+rGrMUV9fZ+TJiUkslI7ThJJdqJMVVnGm/awIPOHLWLBpzCmXnqXJEjfgTwloYd9GzYDe/mhLD+OExrbye+YO3gzBLMLunH4+39M6Owstt9UDIck/lVqe+DdAbeDenFkfnIzGKwCsYI/fItRLgqZjkwCXtgb2snOYbDAlQwuXG86y3VHDlmraoerrAcW89YdqkQLEnGxXmKovaSrfW8pYBS1TW9h3EL+hrjJ7r+1lJ1lzZKcO8GSBTOE2mh0z0E19GNgD96LuR1YCP+Agobi/2QOAP0RsdaUv4wQKJIyPAqMG3sSNh+u7PburBRMtQdWJXlaYgwPjn9BsMpAQknic6gb0kUcE+p2BcVE//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 03:21:40PM +0100, Christian Brauner wrote:
> copy_oldmem_page() maps a page of the old kernel that isn't in the
> linear mapping with ioremap_cache() and copies from it without checking
> whether the mapping worked. If it didn't, the copy reads from an offset
> into the NULL page. That oopses unless the copy happens to be a user
> copy, whose exception table entries turn the fault into a short copy.
> 
> Return -ENOMEM like the other architectures do. read_from_oldmem()
> turns that into -EFAULT like any other short copy.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

