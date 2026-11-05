Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEE4606A607
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=DxHZMLxC
Received: by kanga.kvack.org (Postfix)
	id 4A0A06B05B3; Thu,  5 Nov 2026 10:59:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42ADC6B05B4; Thu,  5 Nov 2026 10:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3296B05B7; Thu,  5 Nov 2026 10:59:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 089C96B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:59:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D09B160A93
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:59:49 +0000 (UTC)
X-FDA: 85401526098.03.FF46B95
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27C2612000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:59:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=DxHZMLxC;
	spf=pass (imf29.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793894387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyweY0UXz6hh0hI/nESUYL8IRVfask0csXM9VevHXJw=;
	b=Hk+0ILxGLeuM/Wwb6yEVFpexB1LcE3DuFzzTyR8HKcmdUgOTn09meUZD9LftS78GuVDzmp
	eO/4NTBXDnHVsEpiEDc+yXunAQxlJhb/RUy5yKxaeBxSLWUZ+ci3Sh0JiEgLom2u/updi8
	tp5VAoTcDhWMVQ0b1q84ftsdqjluk6o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=DxHZMLxC;
	spf=pass (imf29.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793894387;
	b=vTkm3/AuZge8TDFMMgP5X82WoR6OqrVyRprV41q6DgikCF9orSxHUbILldhhVqO8zuKdZi
	LWO+q6ZKkWOsbMDecv074kPSRJxaL9FL+SGVLoxieLgATOjLxXiWIYauY4cHokWhphutns
	KpguyTBEeqLMLu+ojsZBy90O2FEGjLQ=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-996eeadfbeaso1052984241.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793894386; x=1794499186; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SyweY0UXz6hh0hI/nESUYL8IRVfask0csXM9VevHXJw=;
        b=DxHZMLxC4pp8hQ6d4Q9OweYfor9jZ7A26yTReseGUGYeyfb7fD39oJAy2Np8RgWN2/
         TtYb1BHVnYl7SLsBvAu/6uTYZxr8tj8vIDN4yVdD5X3WKdsS60PngvISv+f3Y4bg1MXy
         dpKR2PzqjapHEEHBeUsYPONLm1JNZ+lwarGHMWq8cLXBHSK9joHPNgMtFE2i+S4IEtyW
         MPXmV+BSWapDp+3ipju4/j2VOW43NUKQhP4Vi13EXBol65wwI/KiOWUp+Xs5OZfzxnV3
         ct1r9NlfDRHLEcrT4e6KEgPoh7EKeT5Q8Lfcd0Lmuv9LVfjUAEXkH4g9QLff0yxqxMrX
         S0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793894386; x=1794499186;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SyweY0UXz6hh0hI/nESUYL8IRVfask0csXM9VevHXJw=;
        b=MWSwUH5uP0NoyyJxtkEevetG/f7L1HlqeAL0kaC0FSWnO1+m7wrTYv/O9rnkbK+hgs
         W9FKtuvazSr4+gV4uj+4IfAccg7bqeISxK6aIttKotjvxeo8XAAva7zsLWxQHQLbhLZr
         rcrnuZ5W9i/CWo5fDxGiTIBI4+VH6R9Hk5L+BZUxVc5n6PlW0ibLeludvBC48+Yo5BM8
         mZeUeVJqaClA+6NGlYq/rlERUJ71Pl+sE4d+cZoCA59Z0dORD6LzZiEjxU0Yc6v9E3aA
         uztfndz1UxlTffLVLvhrweo12lozyLeCdD5J+PjbfMuJZqHoH59rfsotH/zPlX+g8kVB
         GA9A==
X-Forwarded-Encrypted: i=1; AKwUvBwdnXgoF/qlptM4JVu9TR2VzAsyaJ1ORj1duFjieFsUVsmHjYG8v2PEW3kH6lnwdaBGOrqdSux3UA==@kvack.org
X-Gm-Message-State: APuU4Z/S8cbPg27pRM719077tsCYm0HkfKt5NLXyqwvtHpwuRjKedExW
	3FFhfoFeBRat6uj8DL6Bu/dAX+AAnlp0jowc83Ly1yCTBxQ6F/SvJZUsWAuf8HQTGDU=
X-Gm-Gg: AYBFou0VJpi/Uh+Cu/NoLdLOGip9dGApZm8yKs3J8FNU9ywFTxyLN6x1+/zOpr95xRE
	7mKCgNsYMtHrnqk6vGpMFVYFw6yQCZ6rF72gaYgPJfKi3Yu0Pg86O5hYix/CbcRCa4qENSovOcT
	+2n30LumK+fPZtmHbZrysgFhhHH+2H2pQAyJzb/wsXChMJa1eZT06Ks/m41+VpDzQqEmJrlHTXy
	OeFuQsRxpKAQPTqE0c7tdgl4eCtOKd6yTBmymjWbMrvqDYfnfBu13+4smkKtQKn4z6ruFjYrZDH
	rmX+tRE1X98tNtbs3NCKeSyvzw0Pm9jI9s+pPS5rd3t+WqfXnmcHlxGo3WDjCU6WVVjsyx4slb/
	st/TNM2CVEpyMGr78vS3cg+jFol7jlv/oX0cyUvJCyzeW2sWxYlTc0dsiZED9Vj1oupmUHEFiqu
	7MwrU69tSAyKmH5boJoGtA9PlvJ0RwOcHn9I5PLKVZ59mu0Mg60gSp8syJO6vrrQ0b5Ope24LJK
	CyaRK9MBRxdrCR7BM5XES66jqMHXryCjWyTOh/v83iEnjOuP5KqLOXjjoALkGyIX+C0+g54jACI
	pFyaF4b26umuhCkPtfs2xrkaOOos6pfUi1d/VYZu/CHQjC3pucXxC8ZWKcn685846Q==
X-Received: by 2002:a67:e11a:0:b0:7cc:2c52:47aa with SMTP id ada2fe7eead31-7d2a0f73864mr14699137.0.1793894385884;
        Thu, 05 Nov 2026 07:59:45 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d296415719sm1096670137.8.2026.11.05.07.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:59:45 -0800 (PST)
Date: Thu, 05 Nov 2026 15:59:44 +0000
Message-ID: <499ba73b1a72a30c6118a4f693f8fc5b.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
 Christoph Hellwig <hch@lst.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>,
 Jan Kara <jack@suse.cz>, Takashi Iwai <tiwai@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-rtc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/7] proc: move procfs to what kernfs does
In-Reply-To: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Stat-Signature: irs3kkstjaqs3wceb5iefhzwtq6itpex
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 27C2612000C
X-HE-Tag: 1793894386-270756
X-HE-Meta: U2FsdGVkX1+9DGw20mtjRQsuk9fArENy5HcQUJet+HXIOZtqWGSFxR3WdOKYlPw6enOhLBthhBYcmJfTb4QQQVwDdAhAl5fPjPp+K0itFfTeictLYLvCNitdzgDCQKsmV8Xx/MnFeCs0kx7SSza3wHMQWqIhVQLCxp0ddFm0RSn4HtQnx1ohTI1EJBgaI5l7MaIhR4tJYuyz3vVOSfgTF4XguH75OYxUE4H9pvkVjaypQEsMjIAfNV2glVAbB699MBz7jbwDSSv3nv26MuU4xdjecEWYUs7ecA4mKfDwkStV2cQyA8hbVzhSM2d8ncQTnIgvBOhs67kTDN9vWyAuijiI27VMs/8Yg1zi7ol7iV/AWGlnRKW7YIdYwxI1hXqQYafnRq8TIxeS8uVzsBC/pL1kRUnlLwr8dB3nsUd61ANMOV8gjJgpmtIWqqf9iwFS1wMvW9kBGFQUy6WI9tcOIzgruoFDbAA1nghzt2JZ7t5noDpTKRa8rHIzDc7nuurP1MHziFLu/tJM10TSoBuclWY5FP74PHWuoP0gWzWqpLu/GrJY8yPQAaOkU91hTDVZi4FP/v9JS+Wjlwxy7rBOcsjdKaHpsrwCLBG2zkQnxALSyyJUshREAxcl1W4HvhtiQLmMBfhVKsoFUGOEfxr8/ZL35vL2C3sk8Rb98W0bDGvJ3//7DvFD6Ri+IZa6lHjw1Opxfjdap0KfmH203tfq/9nQXn/GBz81ukchk1KUdKS151JN6ocj/wfZE+nxUgsbVKd4lFz1zZwNRboPGJ4TBA9TGyqab5yucMME5G1BxCBocT5wF+wGShlaCuuzY+uj3sMZPmx8BhTtfcimuqed79EpFbXkEQF+Ua5U00ZjrHLeXWqo8WOFv2QDydqsHNfgNJFEfEk1LZMLoDt5/jnlNaFxv75rmG2Enhwq2l9RczKw0BD4zQKgAwiOaTA+rVZ3V38UpBvvPyaXu/Gpub/
 U0ovh7SR
 Alrlno4etPmALPZQ6CM2ojM2kh1I0Ft8yNLx6fp5V8vP/YHwAumJG3WBtnZk1ASn+i6yh9rzMigZ5C/W3U3n+XdwAh9TYzvFPdwk/+wODa3BFi/Pkh538wh67By7A8a3Jqa7EhMOZkmkIEaerU4FJhmYgWDM/X9nxfNPhVos7+ujDXvZMQ1L+R2JqBMNJxNFE37uZHGmCGjcYdoOV4LZgT3jQuvB9yn5Lw5JoI+bIszlvRPdW2BIknQCDXHKZaEroZ5CIXkOem2ZnhsUxLbhjyzXBkgRLxR4/HpG+nkBh+PJNIRoDz2eBghpUYl4cazDAXtuG0qnclbZYZS2wpGRgKK3oTSCa2kjaRy79bMhJCCnVde7ITOS8wxXsJUKCePo6fqay/EtSGOoF4d0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hey Christian,

This is a summary of my Claude review of v2.  v2 went out before my mail
on the RFC [1] did, so the first part is what's left of that one with
the new patch numbers and the second part is what's new in v2.  What
says "run" was run in a VM on top of v2, the rest is from reading the
code.

3 (selftests Makefile), 4 (pde_seq_next()), 5 (sysctl readdir ending
early) and the allocinfo deadlock from that mail are gone in v2.  These
still apply:

- 1 is bugfixes 32/51 ("proc: resume readdir after the last name it
  returned") now and the patch is unchanged.  Run again, readdir(2)
  still returns 1 without a dirent at the end of /proc/fs, bus, driver,
  irq, tty, net and self/net, for all of the 100000 calls.

- 2 is cleanup 5/6 ("proc: drop the _buf suffix from the new methods")
  now.  Run again, the module with .proc_read = seq_read builds without
  a warning with W=1, loads without a warning, and every read() fails
  with -EFAULT.  There's still nothing in porting.rst.

- 6 is bugfixes 47/51, 48/51 and 50/51 now.  47/51 has no Fixes: or
  stable tag, 48/51 is tagged for stable and git apply takes it on top
  of 46/51 with two hunks offset by 6 lines.  50/51 has the same Fixes:
  7e0e953bb0cf.

- All of the smaller stuff.  The cursor is allocated in one place since
  core 03/23 and it's still GFP_KERNEL, copy_to_user_fromio() loses its
  last caller in drivers 24/26, the sentence about ntfs_set_label() is
  in fs 07/30, and snd_info_text_entry_write() still drops what was
  written before it grows the buffer.

New in v2:

1) bugfixes 01/51 ("alloc_tag: don't remove /proc/allocinfo under the
   codetag module lock")

shutdown_mem_profiling_async() is defined outside of #ifdef
CONFIG_MODULES and its three callers are inside of it.  Run with
CONFIG_MODULES=n, CONFIG_MEM_ALLOC_PROFILING=y and CONFIG_WERROR=y,
v7.4-rc1 builds mm/alloc_tag.o and with 01/51 it's

	mm/alloc_tag.c:620:13: error: 'shutdown_mem_profiling_async' defined but not used [-Werror=unused-function]

This one is tagged for stable.

2) drivers 07/26 ("md: let procfs own the wait queue of /proc/mdstat")

md_exit() used to remove /proc/mdstat first, which waited for the
readers.  It now does that after destroy_workqueue(md_misc_wq), so that
nothing can reach proc_poll_notify() on a removed entry.  But a reader
can be in here while md_exit() runs:

	mddev = list_entry(v, struct mddev, all_mddevs);
	if (!mddev_get(mddev))
		return 0;

	spin_unlock(&all_mddevs_lock);
	...
	spin_lock(&all_mddevs_lock);
	...
	mddev_put_locked(mddev);

md_exit() clears the array, but its mddev_put_locked() isn't the last
one anymore, so nothing gets queued and destroy_workqueue() has nothing
to wait for.  The reader's put is the last one and ends up in

	queue_work(md_misc_wq, &mddev->del_work);

on the destroyed workqueue.  It takes an rmmod with an inactive array
left over and somebody reading /proc/mdstat, and this wasn't run.

The two orders each fix one side.  If proc_poll_notify() was safe to
call on an entry that's been removed the removal could stay where it
was.

3) core 21/23 ("proc: let lockdep check the pin")

The class is keyed on the proc_ops, and every ALSA text entry uses
snd_info_text_entry_ops, so they're all one class.  Run with
PROVE_LOCKING and snd-dummy built in, cat /proc/asound/pcm and then
unbind snd_dummy.0:

	WARNING: possible circular locking dependency detected
	init/1 is trying to acquire lock:
	 (pde->in_use){++++}-{0:0}, at: __remove_proc_subtree
	but task is already holding lock:
	 (register_mutex#3){+.+.}-{4:4}, at: snd_pcm_dev_disconnect

	-> #1 (register_mutex#3){+.+.}-{4:4}:
	       snd_pcm_proc_read
	       snd_info_seq_show
	       seq_read_iter

	-> #0 (pde->in_use){++++}-{0:0}:
	       proc_entry_rundown
	       __remove_proc_subtree
	       snd_info_disconnect_entry
	       snd_pcm_dev_disconnect

snd_pcm_proc_read() is the only proc callback that takes register_mutex
and it only serves /proc/asound/pcm.  What snd_pcm_dev_disconnect()
removes under the mutex is pcmNp and pcmNc, and nothing below those
takes it.  So it's a false positive, and it turns lockdep off for
whoever unplugs a sound card.  The removal under register_mutex is
already there at your base, only the annotation is new.

proc_create_single_data() gets a key per registration site, but there's
no way for a proc_create_data() user that multiplexes callbacks behind
one proc_ops to say so.  sysfs has the per attribute key and
ignore_lockdep for this.

4) core 20/23 ("selftests/proc: check that a mapped entry can be
   removed")

The core cover letter says this one "fails without the mmap patch and
passes with it".  Run against a virtio-rng device, it passes on core
18/23, which has no proc_vm_ops in System.map, and it passes on the
whole series.  The test checks that the removal doesn't wait, that the
entry is gone and that pread() fails with -EIO, and it doesn't touch the
mapping after the removal, so none of the new wrappers run on a removed
entry.  These kernels had neither KASAN nor lockdep, so if what fails
for you is a splat then that's the difference, but the test itself
doesn't notice.

5) core 18/23 ("proc: let procfs copy ioctl arguments in and out")

No Signed-off-by in the mail.  It's the only one of the 172, and the RFC
version had it.

Smaller stuff:

- The 0/7 mail still says "the xt_recent deadlock fixed in (1) below".
  The part 1 cover letter has it right, it goes through netfilter now.

- cleanup 03/06 says mmap() and write() are all that changes for kcore,
  kmsg and the kpage files.  proc_reg_poll() answered for every regular
  file, and kcore_fops and the three kpage ones have no ->poll(), so
  EPOLL_CTL_ADD on them goes from working to -EPERM.  I doubt anybody
  cares, it's only the changelog.

One more old one for part 1, and this is the lockdep patch doing its
job.  devm_rtc_unregister_device() holds rtc->ops_lock over
rtc_proc_del_device(), and rtc_proc_show() -> rtc_read_time() takes
ops_lock while it's pinned.  Run with PROVE_LOCKING and rtc-test as
rtc0, cat /proc/driver/rtc and then unbind rtc-test.0:

	WARNING: possible circular locking dependency detected
	init/1 is trying to acquire lock:
	 (pde->in_use){++++}-{0:0}, at: remove_proc_entry
	but task is already holding lock:
	 (&rtc->ops_lock){+.+.}-{4:4}, at: devm_rtc_unregister_device

	-> #1 (&rtc->ops_lock){+.+.}-{4:4}:
	       rtc_read_time
	       rtc_proc_show
	       seq_read_iter

That one is the same entry on both sides, so it's real.
rtc_read_time() uses mutex_lock_interruptible(), so a signal to the
reader gets both of them out of it.

The end state still checks out.  Every proc_ops initializer matches the
final struct, nothing copies to or from userspace while pinned, and it
didn't find anything wrong with the new seq_file, open node, poll or
vm_ops code itself.

[1] https://lore.kernel.org/r/464ef986eab97abf226791c7e19ad111.josef@toxicpanda.com

Thanks,
Josef

