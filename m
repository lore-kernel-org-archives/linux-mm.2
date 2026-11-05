Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528FA606D80C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBi5aVin
Received: by kanga.kvack.org (Postfix)
	id 6B73A6B05BF; Thu,  5 Nov 2026 11:34:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FC16B05C0; Thu,  5 Nov 2026 11:34:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5CB6B05C1; Thu,  5 Nov 2026 11:34:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34EC16B05BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:34:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D8E71209C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:34:43 +0000 (UTC)
X-FDA: 85401614046.17.C0668B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EACCE140002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:34:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBi5aVin;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793896481;
	b=3ScHvSXb2hUZbzV3pgvH94672U/x0vDwKPyKqra+p7L+Tj2FvmiMAHAbWdUuZPCXtmz5X7
	7VL1n7J700MDjMmykwevdXcQ3VMP7D5m3nTfcLh10ThmzA9eUUZvDkB3JRXlB4oCmKMTbG
	LSbiO5T2iauF7Iv+FkQsDhhKlKfo82U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBi5aVin;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBv924hgucUDgTSkptAFinyCftVnMUELhrGg/YfjC20=;
	b=rImIkV5mm1HvuxU2VTV72ShEBniO6Kq+bmJJJiSZBDZ2WQUBFmSZZGoGVMkJmLexWvJZdo
	m7lmSReH8HodfBE3PzbipBsmuPXxDjiPcnfTxIlhzB8lEY0yFG/Zt3eFCJhuqAJF57kNr5
	RIbtAz43U6FkVfuV5PcjoAmzMcFhf6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B1C4609FF;
	Thu,  5 Nov 2026 16:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC081F000C1;
	Thu,  5 Nov 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896480;
	bh=TBv924hgucUDgTSkptAFinyCftVnMUELhrGg/YfjC20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kBi5aVinozWdr30SvlvWrbdI+oxqrfg3wYreCZsip56P/UpCA483hwMdhKZsZz7mj
	 KjuO/qua4lm1T1mf88OAbvrP/gBxXSPQVsLvkQnRrFoRWZpaF7S1WlGP6GhfVMesz7
	 2V7ZNv/cQ4Ob8gsjHpKE47v9oHbp30d1zMVdi1J2YQJSrYu0jiQY4yVmh8c4SUZ3uT
	 3o/dU6wNdMjidrvPNWkPVzuRpPBSsk67u2Y5jDdYv8Li012xdmn/q8HMLeknUWTI4p
	 /gffZiGoufno26Ei7fpsRfB5GlREuJZJgJchn/9BssPnAtTfT2ILPKTuaBFNuVeREH
	 dmWVx4tsdojMg==
Date: Thu, 5 Nov 2026 17:34:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Takashi Iwai <tiwai@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-raid@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/7] proc: move procfs to what kernfs does
Message-ID: <20261105-chauffieren-zertifikat-weinanbau-685bf4373da7@brauner>
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
 <499ba73b1a72a30c6118a4f693f8fc5b.josef@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <499ba73b1a72a30c6118a4f693f8fc5b.josef@toxicpanda.com>
X-Stat-Signature: i8j6uqris457zpx31mjdmaro6wjqjyta
X-Rspamd-Queue-Id: EACCE140002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793896481-263825
X-HE-Meta: U2FsdGVkX19D/JMoEJZ8cknYH1kzGaPwTB9Isj1+1ji5haX0JziD94Y11heci3Pm75622gFUNx30ub1p1gN2oEZUb9D/RrEv6i4mZ5QK31ztXdw8Twwcsy53OhFKehHoU7eT8KfwMqzogLxvTLHxL2jZ0FVdrBNhSBKcPJgFPttf5LuQ2DU2HLUoPuwn8O1mqWBB3Jz0cW8aOZhiFkkxGQUTQS+PgbZyFh/SdkVYn6Byj1NLUzqc+hOlst/Od/21RcsSbz4aUiJhLR6NIzksg8GKbw/jNhEUtt1YEgpOTmoReyg+a8GuW8y8If4lAD0093t7UFI4PN5UxhPww/QtP+merQe4iqzsBhqdAAMKYHd1Gy16xYzg0hDvZCv4eDlhQdvBWR5jvrcbOaGgNaL8xaLECdIOVbVN1S5ymIlcrkXJQcsRUJH1dy1yqpnPiRB8xahJQaGeEC7GQF7JtlGnB8RbBGjCo39904wsJIdo0vpY8erxGSfuObQNjvm7bn+Z8B1Kt5PWjNr9SKgj6fjqC7RiYbGNPUYknZwXJJEX0aXEgnYPNU+Y/qPRBI1+TjbVWTtUnVrKn/PXjHKdZfhuk9bhgJ1wPZ1gIQYrvr/hgOFcuGvIjx+OzarNNxoEnXI6KIb1r5MF35MW1JAlPTPU2WJUGS6YpBxYgH/ZvNzNylK7Lc+Ztkw3aAxYY70SA96MK0RQk24A+cwAMnosKAfJlJDLzXOtfSQ+scCV+1a3wL5mvk0nfjR4V9PHaBOepFUib1AvR8mLDERW6BTP7cawQZ9s3ZBjJ0onlQJ/IV82qYWFKZr4GIbrX/dxi6BnziPY7Z7x8F2Ws7R/cjCrec3j72Hspbly0t16yXFR69/XEUicFUNZGDVrA7ifXeXr0BfEp9/PmymOqbLBGBF9byYy8VqQyIVD7eeu0Z9MUOduYm5AASAbgmkip4ghyv9MjnRO8cW/b5BMmhtGr2rQYm3
 UtynA465
 hdaXoc1Kw8NPREAA6PCb5aI760wHVK3WWON+YjhaJcVB0uzgSP4LnAdLHHNTOW97dSaThoHNoTtsHGR2sI+Ly3lDTdvCJ63oavv7zD/Egkuso1paEvfSkKDiMd7R5Tq0Pb6rksXbmWGUAssU1snGtgH7xAv4V9l3/kiALtua9YxiNJXVRL2Ip0Xdh6tsKXNps24cZxCFA6Zx4iBtvU+Un0ITZuWAEfr7DjPzMbn9OWlDiU7UeDtpn2Yrf3ckNjMc+ZzP/Bj2vrgRddmDAtKbKKG103TIYdsa+y312wEclN98h4FtDA7vzPzhwiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 15:59:44 +0000, Josef Bacik wrote:
> This is a summary of my Claude review of v2.  v2 went out before my mail
> on the RFC [1] did, so the first part is what's left of that one with
> the new patch numbers and the second part is what's new in v2.  What
> says "run" was run in a VM on top of v2, the rest is from reading the
> code.

Thanks for running it again. Everything from the RFC mail is already
folded into the tree.

> - 1 is bugfixes 32/51 ("proc: resume readdir after the last name it
>   returned") now and the patch is unchanged.  Run again, readdir(2)
>   still returns 1 without a dirent at the end of /proc/fs, bus, driver,
>   irq, tty, net and self/net, for all of the 100000 calls.

That's fixed.

> - 2 is cleanup 5/6 ("proc: drop the _buf suffix from the new methods")
>   now.  Run again, the module with .proc_read = seq_read builds without
>   a warning with W=1, loads without a warning, and every read() fails
>   with -EFAULT.  There's still nothing in porting.rst.

That's fixed. I'm keeping the proc_{read,write}_buf() variants.
All methods are documented in porting.rst now.

> - 6 is bugfixes 47/51, 48/51 and 50/51 now.  47/51 has no Fixes: or
>   stable tag, 48/51 is tagged for stable and git apply takes it on top
>   of 46/51 with two hunks offset by 6 lines.  50/51 has the same Fixes:
>   7e0e953bb0cf.

Fixed.

> - All of the smaller stuff.  The cursor is allocated in one place since
>   core 03/23 and it's still GFP_KERNEL, copy_to_user_fromio() loses its
>   last caller in drivers 24/26, the sentence about ntfs_set_label() is
>   in fs 07/30, and snd_info_text_entry_write() still drops what was
>   written before it grows the buffer.

Fixed.

> 1) bugfixes 01/51 ("alloc_tag: don't remove /proc/allocinfo under the
>    codetag module lock")
> [...]
> This one is tagged for stable.

Dropped because Hao Ge sent the same fix in August that I hadn't seen.

> 2) drivers 07/26 ("md: let procfs own the wait queue of /proc/mdstat")
> [...]
> The two orders each fix one side.  If proc_poll_notify() was safe to
> call on an entry that's been removed the removal could stay where it
> was.

Good catch. We can simply move removal to the front and md_new_event()
takes the entry pointer under RCU that then gets cleared/synchronized
before the removal. So no side can reach a freed entry or the destroyed
workqueue. Looks like input and sunrpc have the same problem.

> 3) core 21/23 ("proc: let lockdep check the pin")
> [...]
> snd_pcm_proc_read() is the only proc callback that takes register_mutex
> and it only serves /proc/asound/pcm.  What snd_pcm_dev_disconnect()
> removes under the mutex is pcmNp and pcmNc, and nothing below those
> takes it.  So it's a false positive, and it turns lockdep off for
> whoever unplugs a sound card.  The removal under register_mutex is
> already there at your base, only the annotation is new.
>
> proc_create_single_data() gets a key per registration site, but there's
> no way for a proc_create_data() user that multiplexes callbacks behind
> one proc_ops to say so.  sysfs has the per attribute key and
> ignore_lockdep for this.

Hm, I think that's fixable like sysfs does by allowing to specify a key
per entry.

> 4) core 20/23 ("selftests/proc: check that a mapped entry can be
>    removed")
> [...]
> entry.  These kernels had neither KASAN nor lockdep, so if what fails
> for you is a splat then that's the difference, but the test itself
> doesn't notice.

Dropped.

> 5) core 18/23 ("proc: let procfs copy ioctl arguments in and out")
> No Signed-off-by in the mail.  It's the only one of the 172, and the RFC
> version had it.

Yeah, dropped it when I folded the patch in, I guess.

> - The 0/7 mail still says "the xt_recent deadlock fixed in (1) below".
>   The part 1 cover letter has it right, it goes through netfilter now.

Fixed.

> - cleanup 03/06 says mmap() and write() are all that changes for kcore,
>   kmsg and the kpage files.  proc_reg_poll() answered for every regular
>   file, and kcore_fops and the three kpage ones have no ->poll(), so
>   EPOLL_CTL_ADD on them goes from working to -EPERM.  I doubt anybody
>   cares, it's only the changelog.

Added to the changelog.

> One more old one for part 1, and this is the lockdep patch doing its
> job.  devm_rtc_unregister_device() holds rtc->ops_lock over
> rtc_proc_del_device(), and rtc_proc_show() -> rtc_read_time() takes
> ops_lock while it's pinned.  Run with PROVE_LOCKING and rtc-test as
> rtc0, cat /proc/driver/rtc and then unbind rtc-test.0:
>
> 	WARNING: possible circular locking dependency detected
> 	init/1 is trying to acquire lock:
> 	 (pde->in_use){++++}-{0:0}, at: remove_proc_entry
> 	but task is already holding lock:
> 	 (&rtc->ops_lock){+.+.}-{4:4}, at: devm_rtc_unregister_device
>
> 	-> #1 (&rtc->ops_lock){+.+.}-{4:4}:
> 	       rtc_read_time
> 	       rtc_proc_show
> 	       seq_read_iter
>
> That one is the same entry on both sides, so it's real.
> rtc_read_time() uses mutex_lock_interruptible(), so a signal to the
> reader gets both of them out of it.

JOSEF! I already got yelled because of the amount of patches. :)

> The end state still checks out.  Every proc_ops initializer matches the
> final struct, nothing copies to or from userspace while pinned, and it
> didn't find anything wrong with the new seq_file, open node, poll or
> vm_ops code itself.

Thanks!

