Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8616082BCB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+guEyix
Received: by kanga.kvack.org (Postfix)
	id 6CC6B6B05B1; Wed,  4 Nov 2026 17:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655F46B05B4; Wed,  4 Nov 2026 17:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C836B05B7; Wed,  4 Nov 2026 17:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3058A6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:46:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9789A8088C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:46:11 +0000 (UTC)
X-FDA: 85398921342.23.E5F06C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F0D3140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:46:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+guEyix;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793832370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBOw8umZc0PSygGL6ZhSsNEhyMPfzoczgqWFX+5YDNY=;
	b=Ns1GEpcyxPmiGkGGnAC/oGmh60nGmR2VQWUgqK6zeHBk+8F1L7wfEDpkYmgk7LJr3GwXW+
	/KUU0aJTO3OJC3+j10c29bHYhNWK9OLtMfSYiI9GF3LPtuBZ08xHjJ4YimNq8r6hL8VHAE
	mQwts3gSh9OFxlxTiTDxr/otobA4hmg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+guEyix;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793832370;
	b=SCIebB3WXZrPYzPNO7hQL7cplWHWJkrp8XarqqKWYkgRcORCaB6tdvaRzL6EjG2WOO8yv4
	bwYYqN1uLmKhRmWSBaqdMs/0sm4MfjTTV/gfGorcGVjcnJhQxgJGwqA4ziIG4KMjxqdkT6
	Oh2NzMlME+Cz+mdtvgFk6B4PNtclOuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E931605D5;
	Wed,  4 Nov 2026 22:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C1B1F000C1;
	Wed,  4 Nov 2026 22:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793832369;
	bh=XBOw8umZc0PSygGL6ZhSsNEhyMPfzoczgqWFX+5YDNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y+guEyixDVYqpS8g3d4FmlRYq/qp1tQeGL16K2BSxNthPOaRsDL0VFTK+tjHByNf5
	 UG3G3TR4IbDk5BaZwlgwVySr0HiRvL1WeYdDEujyS+zzG35LMJqu1Pm8BzfQ5Z+w4F
	 3DGZwBGiTOYlKSVRIgaBstWj6LtjUlnMrGUfTY6AgB7LPx3pVl/0nxTfWzl1eRWVeu
	 9SzZPPQ7yLUIbBzvzOD5olkzaVc7Od6fJQ93jvoDvEvbyLIezG28vK5PJuGqQJ/Zu+
	 C/TFnkMniWMHftytXgdebgJiyvQu099dnGFvQXlwnwRKY6VGKt0bkFzVDUexAPr+Sm
	 GvRbuyQmKti0Q==
Date: Wed, 4 Nov 2026 23:45:55 +0100
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
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
Message-ID: <20261104-allein-bepacken-hitzig-5e517d3c129f@brauner>
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
 <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Stat-Signature: ynoqgxz4tebanpwm63m5sjoqztiz3sgd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0F0D3140005
X-HE-Tag: 1793832369-650510
X-HE-Meta: U2FsdGVkX19f/+mW20NhAH0ce6PzNqPBkZOVYc1hRfjqBpIJ4MuynhdXJI9XS26CvhCtUJQetid/B4X4lEmmUMSd/+pARunVB+CoSlkpv6UAyhxjNV40jT/+kqvMs6yVxkyQ/TP1rEMc063Vql+F+ISOPRhzxjAb3xv/zuWTvR1dB+CfgFzctbFqsNiz7ZBw4DWym17v1ArVjv3nIwAw056QM+SgUNMw7wL5A/4xyFC6Frt+ap7JBTi835+OCxXivtlPr/w2iVa4zb70h0m3/GvopsoGILhcjicdKakeFCkP5euIaFjPY3DknQxV4oMBPeP2ih25/fb5wob8+DiVIdAvc66tn6GGLCFN/TicoeYKiS/SlxwJoVTd2eRaLJf3i7CMGp8D3qZ+cv09lU+DtTJUFKl+G//fDOqTvKOOO7UcEkWqSubuZHxmtXLcxFLrjtSv/y5oVDCZzeZRJs7kn0MRCIxrPqUVrip/nayUHcCJAB14bEhS+Ve+DTL/7dosHPkcPw7hp3m8BCcLeLCz/+gUlMDC90RjFN5uuxPm9HXNTnMyy0FYmbePYbeLiJIqgDyOTe6H4rPUeU0Axz3KAUloVNTCUZCqV+ibNHs2sViMYMRO5eYCro/mUgDMAF59MXpsfTPlDDEvzSioXFBEYGR1ohSCfdOuwnjQAuN5nS+wbLnbCBWk6kvUlKNh8kpPsx//mnK3Moox9xQm0jGEOHDw84YhQg8csWznpkA7ZT1FO1VQ3wehY/1acbtBxLs2iUTQFF3FYlJ8beYxdobQkMFv3UmQdhvOwktHSFaydHov90NkhD5cYsX5Y33c0yontNtyLLEFDu+rnfeTowBDx42r29h2BZxZYQpEbXrChrWyy3kvK9oZo2YYg4ccOmt7xDyjiKk4uTOHOJIcSqJkFWlVW4+PGUKdYxM9k+U+y1i+EL4y6vyj44ECM3aTeOPMuc+DD3gsjUEHa5IASzf
 Vk3ux5fe
 wG4k/Wb0+WSry1ixVOoOwWNh+SzPzjDOjbtImof9qaPNAMOREjDhdsBDDLCzyXe6oh3g9B9fPblIBSjz9+BIXN/dDqBY/P8mn7MKPRT9pRIdKARj3zQ5aHe7lvBc3HGAKPRY3xqgM+psaAxQbyjqd9pYxiWOCBlWYogBu1f1FPU4ZsybDp/MgUthDe7rbZTD+OCEyIPApsXqDgVXdbQLBQkkm6U9IWWZGb8S3Q8xMUsiH92W5vFO0HOJrVDX3h/HTAZtg47ZoVgX8/NC5R7MClsa+1LLylfQPSNYzOE2CGfUuRhuRSMCVtxcoTc14YNHOL19VVz6GXGIY5HLMwywY0G2vP9lsa0Qk7/sJnmEjMdQj1n9yf8L11hihp8DH07vIrKSptsQLrbsuHlZQV0glgLDtNSFbWpjODafo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:05:08PM -0800, Linus Torvalds wrote:
> On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
> >
> > Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2
> 
> Christian - way too many patches, re-sent much too often, cc'd to way
> too many people.
> 
> Nobody is going to read these repeated resends, and all you are doing
> is clogging up peoples mailboxes.

I resent once after I cleaned things up post RFC and I don't plan on
resending (one failed attempt due to my network dropping).

