Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA36606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyDteQG2
Received: by kanga.kvack.org (Postfix)
	id F28206B05D4; Tue,  3 Nov 2026 11:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF686B05D5; Tue,  3 Nov 2026 11:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEF76B05D6; Tue,  3 Nov 2026 11:26:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B416E6B05D4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:26:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4308414049B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:26:38 +0000 (UTC)
X-FDA: 85394336076.21.CC2CC07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8695040006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:26:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyDteQG2;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723196;
	b=Sm2CgG4Fa303ttTthodIultQdkKWblt5v8Wg5r5sLo6L5IIkZRga+crsz2PMOyzDOtwmRk
	GMasYBxkBv5rCLScOzJmQDdb+WEYN3HvjQi8U75UkjtLR+qlBKAxS9bNFElvZw+chg1SaC
	qRS85na5f1JmB50ID6oJJ4niFZgmyHY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88x5nWCU4/5DUnm5J75+/44oJREtwTCj+m3lJcaJoNE=;
	b=BzQnl0tWZwKfonBKI9bhShA8REWkFjmr6DK0x/sY7WMhzoOAaAN2YSrjN+387BUeZKCBff
	Ff/9mMeT6IZ7L8mqWchK3RQ664H7rR9ZcTR7ryS3zH60eStqdXYjHDQBjGJH0mxx7lyxx8
	L2OGlI45v7+HZMtH0cqo3l0eCwbwp5Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyDteQG2;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC725404E3;
	Tue,  3 Nov 2026 16:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A721F000C1;
	Tue,  3 Nov 2026 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723195;
	bh=88x5nWCU4/5DUnm5J75+/44oJREtwTCj+m3lJcaJoNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HyDteQG2VBDz2pwudxJvRFZ3NzuhMM1n/qoJyRpSIEa+4sIo8qfNjCKCMkx9fqPnu
	 PTXEB3HB8c+csEYJbUqrD18YNji+Wb3P0nPR4rCDriU41qd0d35Q951xfxtaew6zqD
	 xTRV7HQa/evoV4YEWVb3yEGxlVh8/pDAOnR650sPVOaA2QtXNMiUjYtFVGzVyuFmxJ
	 cuqSFcaDMPcPNDAwdq/HarCHKLW8nQ/TcudxBJnTO/IQN1HpQ6LTm2xHx92xHn7YRV
	 9GYQVIg2n29fkajQrtiWC1hueIuFYRrAfwMXbzDr3+UFxfeou5MMiBIFbN+ZYhp4th
	 RFlMkVbcaKQDw==
Date: Tue, 3 Nov 2026 17:26:21 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	Linuxppc Dev <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, 
	linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
	linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 27/38] sunrpc: make queue_wait a global wait queue
 again
Message-ID: <20261103-lufttemperatur-absondern-zweifach-31d272ad55ab@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-27-59422ed3e465@kernel.org>
 <16f91f93-16b4-49b1-b7fa-cec69759c349@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <16f91f93-16b4-49b1-b7fa-cec69759c349@app.fastmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: zk8u6prs6h3oy78tynfzsw6idzx619mg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8695040006
X-HE-Tag: 1793723196-763828
X-HE-Meta: U2FsdGVkX1/yLcpLsh6+kBEu2o9EZK/7R8ZKfV8AkiIDMjQ2bDesJFO50eWq7Q9Ylpm6jMy8zSy1zwE3wmlUhUOxyWFjj1MwbG0Mc54BH4Ci40bvvcfA8mbp0P3TAcBuE1nJnq/nvDmX5jZM5pq8OS96lSLX48WcPAXARxTio+/BVEUR3ei5PsVJBZmh7/HBJ1rrBT2mKy2YP0elnXGDin9MY9DMmfAAD4VK8rxt3MWi8ldvfoOnfE2DDRy/2U2lg9SzjmilrUPclgV9LWUU2bfHAJx7qwyUvL4eILVHk/aKXg/e6ZWNitN6Iu2zf3o+CFYktR1nRuxaoE/ICFRIS9T+w6AcaIC9z33WMMgXBgQVg4nXi865+eVnOrCfdp/1T5kbgYcnfChT8rsKQiSWmd+sNqKObEfhZohfcUPJr+Uw1aAyytBHJIBFfqNyPwNQjV2p5GOe0j6CSYifrV6AdU2iR2voGmoPkGlJwSkgvmWOn2t+6BluzLviOx+Bay+/iQlEQso6zZcGG8Xk9dEtvJqXwiSPPMOuBfo2/4DZaSpk4VwHCGuWXbDS9CL1qQenP7b7YImCTTf5OFLTJWV2Ox4sqFqTG2r47t/ai2P4DiYfz7Jdhddp2D5bgQeDGDig78POLTeyhFZhPN7Xu0HRhWsZbR2+PRjdK/l0Jt8ctip5jPzEHcVxxj1k92Z+idfjR3ohf/5w8EekUV9BhoTxqWGsH+5AAjWfppC4OkqFCOPHLN0oTtnU4qMlRHo2I7nFI8zroPpw0SSBWlYK0NMjSAz0ALzdHahn/AV9DwNQyY4WRd/rHGEm6y6hv210uk3lFrgVQL0bDfl1BrlYjPR2V7oPq4AwrYs169soZuY7E05ZheqUvu22eEcYDw5tza2pxVJ9Go1aNcSgAD8tbGhQ1mLvD13hIMduYVoPLCjkAw8GxIowEbQ4M8m2IYFu3VyhaZVrKl2XlxK+syXcrp0
 AuXXSZbt
 /e1nDXTDMAQDbR+jymxXc/SddK0D0mL+A2qt1mebRji8fiN9kcdBvrKYzDznhmSor22koH8bpLLWZq775Q3OSZl4uVosM2JIti834fnGE9FaPd6KYCZDW50j/rMabh6Vixk1csRvmjn6zeLfmmKWtkFjaR7CJ39PXbm9Ax8SEozgjifuxPA0FVdNwSLsmF3S7tdFnN/YhRV4bt18uGoVNbpSNEx/Zb+lRmeaOK1+/Q7r39jjvUMd2aJ2+LpF/K0fK++1n6Q5T6EimMcsTLc5rM2klgAtiU65RDOG5wP4bGWeotQrSHQSWwixOCWLwwtQJ3mYqmLYGJY3a/cCQAX+pNPMr0YdHKOsLHNkZAlN6DeEpdqXVFj4w6o6QALBmdaMTdnDHbpjPvOO6LojF/X+kwdbVaER3wBHW6tEPyr4Bfa+koNXoTIs1v544Bh3HguQy/08ceoZviCVpo+8R2rUb6JbtOX+SZEHc+H3C/GZNPgYNtNBp8RT+bDwb6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:12:12AM -0500, Chuck Lever wrote:
> 
> 
> On Mon, Nov 2, 2026, at 9:21 AM, Christian Brauner wrote:
> > Since commit 552d0e17ea04 ("sunrpc: convert queue_wait from global to
> > per-cache-detail waitqueue") poll() and epoll queue their waiters for a
> > channel file on the queue_wait head in struct cache_detail. But the
> > cache_detail can be freed while its channel file is still open and
> > waited on.
> >
> > The procfs channel files of a network namespace are removed when the
> > namespace goes away. Removing a procfs file waits for the callers that
> > are in one of its methods right now and then calls ->release on every
> > file that is still open (cf. close_pdeo()). The waiters that poll() and
> > epoll left on the head stay queued until their file is really closed.
> > So:
> >
> >   sunrpc_exit_net()
> >   -> ip_map_cache_destroy()
> >      -> cache_unregister_net()
> >         -> remove_cache_proc_entries()
> >            -> proc_remove()      // ->release, the waiters stay queued
> >      -> cache_destroy_net()      // kfree(cd)
> >
> > and when poll() returns remove_wait_queue() writes to the freed
> > cache_detail:
> >
> >   BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x4b/0xa0
> >   Read of size 1 at addr ff110001131bb570 by task sunrpc-poll-uaf/242
> >   Call Trace:
> >    remove_wait_queue+0x22/0x1c0
> >    poll_freewait+0xc2/0x230
> >    do_sys_poll+0x9ba/0xd50
> >    __x64_sys_poll+0x165/0x470
> >   Freed by task 12:
> >    kfree+0x267/0x620
> >    sunrpc_exit_net+0x34/0x80
> >    ops_undo_list+0x271/0x8d0
> >    cleanup_net+0x3f3/0x860
> >
> > Closing an epoll instance that watches the file gets there through
> > ep_unregister_pollwait() instead.
> >
> > The channel files of a network namespace belong to the root of its
> > user namespace and cache_open() doesn't check for a capability. So an
> > unprivileged user can open the channel file of a namespace of its own
> > from the outside, poll it and let the namespace die.
> >
> > Go back to a single static wait queue that never goes away. A wakeup
> > for one cache wakes the waiters of all caches again but cache_poll()
> > reports per cache_detail so that's just a spurious wakeup. procfs
> > should really own the wait queue of its files like kernfs does but
> > that's nothing for stable.
> >
> > Reported-by: Chris Mason <mason@kernel.org>
> > Fixes: 552d0e17ea04 ("sunrpc: convert queue_wait from global to 
> > per-cache-detail waitqueue")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> 
> Acked-by: Chuck Lever <cel@kernel.org>

Fwiw, I have a patch series on top of this that makes procfs own the
waitqueue and then this whole UAF issues goes away structurally and you
get to elide that global thing here.

