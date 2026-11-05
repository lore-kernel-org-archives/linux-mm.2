Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBD16071FA2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZhHfqlp
Received: by kanga.kvack.org (Postfix)
	id 11F566B05B5; Thu,  5 Nov 2026 14:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7376B05B6; Thu,  5 Nov 2026 14:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034E56B05B7; Thu,  5 Nov 2026 14:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC65B6B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:49:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 319B71A0C64
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:49:24 +0000 (UTC)
X-FDA: 85402104648.24.2981EE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C95C180005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:49:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZhHfqlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908162;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQGcFgpv842CZc+i4ADTXEHohf225g6/ddUxNX/0YAI=;
	b=D+sbY3Gecu8izYrp4VSuBNXDMqZB6az29RJpJRGbBCXanuJCKl5YQ37ycU5gZffFDvewav
	ax5we4hJEC0zFXVDCuhqYKEYAfTo1vth33AVxqG4B5Y8+HZLYRb6dtJx4qpGlKG75fJw8r
	1ZcGBN8Re554GlFVbxzTjC9IovAoZP0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZhHfqlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793908162;
	b=k5ooJkX95BqWZpFY9YEhkFvdjFH1nVpQO4/s0KC/tbM7/LzuOHGerx7nCr9q1GynEwsf4Y
	2+heeBJESdLnfacYm0VWDD8BEQJI3Ru/qjALTJUSMd9RzdNe7gxI2FW2jc2TZkKA9BKRUM
	IOdb7Pvdkc2zpCbSTmnnCsp/YbqI2Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C01A60223;
	Thu,  5 Nov 2026 19:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189221F008A3;
	Thu,  5 Nov 2026 19:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908161;
	bh=SQGcFgpv842CZc+i4ADTXEHohf225g6/ddUxNX/0YAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZhHfqlpVCMazdNLMYZou11HSNj+bC6q9k18GNJM/OWusa7I3cE38ZSDuLk7G2DA1
	 Jl3LWLfce8r1+I7/kaXnW4DM1El/rS4EDvcWvFSU9gRYnhweCDoHGXs46gI+xBDByX
	 bgwM+wgE3oMtnlEF7gWtZvRxJuCjnhN3KkQNB8x40+mSR/kNNPCHzW3fXCtyFHFFLX
	 FHCIUG4SqoA/t9wvId31tRsBFDoxQSd/YXuLLYEqclnuoDPsXk/7YqV8Md9LhmYBjk
	 /UvD2lsmagU5/J9f/mcGTlhm7gntE6pKkE9kjzxwlbL4fMuUu9RbvUKnSlvFWCI5Yp
	 a0z1KaHv2TqyQ==
Message-ID: <sashiko-outbox-199993@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 07/26] md: let procfs own the wait queue of
 /proc/mdstat
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-drivers-v2-7-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-7-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:18 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C95C180005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: uxf86jkskozf7q3q6tq8oztbqr4zityy
X-HE-Tag: 1793908162-417215
X-HE-Meta: U2FsdGVkX1/A2PGbWk6NhMkeFqahWfXW9c2lijRrPOTYexcfBrLYqck/VsXe382gJAuFz/sZKufHxcw80hjrNvVv2OliWMjFbO+hsxv4YSrRaCCj+BPTfd1DSa7DFiT48XoZ56sPRf6nLejvCNE8Gj8uWR6bpZAPB4CSioLOdRWhUGjnWgkcNWLvYt8Ub+RgWdVZigqr/d6XBXTB8XsYJkVxq7uJVnxUQc6R1iTHmxiJvzmv5bRuUhURstbXycDNxOAdTSPVFiFMiukg9czfLlYjk1GAIcCfRjBPCOZ1cNrUYuFqDXz7nCwk3O7+m5TqezC3K4yLpS+qFtZFeBsApav9NMO4lzHpM88prsixbGAToReWmJEjSd2zF0ZUWeIW2bbXAbYnOhhvNFDXLyK4W5xOntU8Nac1IlHjE8783w/b+BBD+Qmp1z9rmxMKjkWEIwfR6EPWBPbdg5xAF+cdLjHvhZ9J9qxKRrF5y1nSCTlz4S6Lhs1a4Y7bgcSeuWhVgHLkzQ+afMuaeabYRPdbtDMn936TRTgk+ZJiDypYdhOTP73VHvGTyt7do0u2KVChU9BEIZjiWh6dXDKT+YQvBuuvEveIVIzCSJ4sRZJ9ghTSgr0xcuhmaU4FK0KvmjCJmmlEDnH0i5IxYSKWbH3Eu4JskQpToPqYaW1glDerYbGNtjbfLU0IiC3sG/WgN2qIiUDN3VRI9RDxpZipd0FbZdksfzRgnRTDXcbptSdJyQK81r43Z7WWfCd2Z6gvhoEBHUAr21WLbogHOWUsNzFatrJeLYE+nhllKs7LjPqGGKZhDWoixrByQzImudxA5p8W0dlYTX16CnLNf9KvAkiOVfvPh/8pWTs0BU/h4Xz3hJHkLv6C1V2yAeHMmGwWYE5wVzS/4fBViuj9BquLGWM5UeJgOwpCqga8JbgOaOLFq+p2X8/XyOjsI9WkokseJe2qmmKRGlxBYazr3HVcfve
 toXf96zP
 P+fuxEUoG/z6G7HoteGgUASpJLa5JbtK5DAI7yXKX3kp00mPYWjaSpIcsG1KTqIud7P0dWlooI21coAl7bxlXcR2nZqWIV8r0cJZj0YqiLWwAP14Y2HyNSABEw2NnCloro6dLE9MgOaWGW3kaxlx2cBlTvNWdRHZgJ8AyvIYh62pip1TiVbupKkecKookrdba7vVXIQ90J84viRN0kOHKgcN0rRb2PhR9o5cG70ZDJ50SA7CdowN5i3drYiTaUDKHYXHWeKQEKzsCWkXl+MfwlOvcBqMY+bO2NvHNn9eGsiaUV60trloocUpMf1yRgtoWyRmzEYoeBsc492/FpQPqfCjDsGL9PanHASWAbpklzhwzrRShfkZ8uiQvzHIUC+C0bavvhBQ5hyUmOmSnJ0KuGpyCBcluFfjh/YksNxWT45geJzXYkf3oCQ91CqLAZpBzY+/VSAvn6hIRNuauehFdBbmEnNB4Qyr7EnL8ouOS/jJvjpyYG/sjlNMohqHtanrANHHuagz3kPnv2CtcuqC2cyhBEoTcmoupJm6JyVbOg8RuidQTds4X+jDu/wcgtG7sqZs0vmAGfUxae7S1OaW14lRK+9GcioG4rGzGc/xo1gyoLvjSamMQsdrz8quKChUxZSx03xxmKqXq7FDqft2VKQ6JrMrMqnITzg2h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] md: use-after-free on md_misc_wq in md_seq_show() during md_exit()
- [High] md: use-after-free on mdstat_entry in md_new_event() during md_exi=
t()
--

commit d5381c9dd419c5377924fd70f1baf55ca30c4844
Author: Christian Brauner <brauner@kernel.org>

md: let procfs own the wait queue of /proc/mdstat

This commit replaces the module-owned md_event_waiters wait queue with
proc_poll_notify() on the /proc/mdstat proc_dir_entry, removing the
md_unloading flag and wait loop on module exit. It also moves the removal
of /proc/mdstat in md_exit() to after destroy_workqueue(md_misc_wq) so
that late md_new_event() calls do not dereference a removed proc entry.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 64abf1743e41d..7560dcf0f5c87 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -11074,25 +11069,12 @@ void md_autostart_arrays(int part)
>  static __exit void md_exit(void)
>  {
>  	struct mddev *mddev;
> -	int delay =3D 1;
> =20
>  	unregister_blkdev(MD_MAJOR,"md");
>  	unregister_blkdev(mdp_major, "mdp");
>  	unregister_reboot_notifier(&md_notifier);
>  	unregister_sysctl_table(raid_table_header);
> =20
> -	/* We cannot unload the modules while some process is
> -	 * waiting for us in select() or poll() - wake them up
> -	 */
> -	md_unloading =3D 1;
> -	while (waitqueue_active(&md_event_waiters)) {
> -		/* not safe to leave yet */
> -		wake_up(&md_event_waiters);
> -		msleep(delay);
> -		delay +=3D delay;
> -	}
> -	remove_proc_entry("mdstat", NULL);

[Severity: High]
If remove_proc_entry("mdstat", NULL) is moved after the all_mddevs
teardown loop and destroy_workqueue(md_misc_wq), can a concurrent reader
of /proc/mdstat trigger a use-after-free on md_misc_wq and leak the mddev?

Previously, calling remove_proc_entry("mdstat", NULL) before iterating
over all_mddevs waited in proc_entry_rundown() for all active seq_file
readers in md_seq_show() to complete before mddev teardown started.
Reading /proc/mdstat pins the proc_dir_entry rather than holding a module
reference on md_mod.

In drivers/md/md.c:md_seq_show(), a reader takes a reference on
mddev->active and drops all_mddevs_lock while formatting output:

drivers/md/md.c:md_seq_show() {
	...
	mddev =3D list_entry(v, struct mddev, all_mddevs);
	if (!mddev_get(mddev))
		return 0;

	spin_unlock(&all_mddevs_lock);
	...
	spin_lock(&all_mddevs_lock);
	mddev_put_locked(mddev);
	return 0;
}

If md_exit() runs while md_seq_show() is between mddev_get() and
mddev_put_locked() on an inactive array:

1. md_exit() calls mddev_get(mddev) (incrementing mddev->active from 1 to
   2), drops all_mddevs_lock, calls export_array(mddev) (which also
   mutates mddev->disks, mddev->raid_disks, and mddev->major_version
   without holding mddev->lock while md_seq_show() reads them), clears
   mddev->ctime =3D 0 and mddev->hold_active =3D 0, and calls
   mddev_put_locked(mddev).

2. Because md_seq_show() still holds its reference,
   atomic_dec_and_test(&mddev->active) in md_exit() drops mddev->active
   from 2 to 1 and returns false, so __mddev_put() is not called and
   mddev->del_work is not queued on md_misc_wq.

3. md_exit() then calls destroy_workqueue(md_misc_wq) and blocks in
   remove_proc_entry("mdstat", NULL) waiting for md_seq_show() to finish.

4. When md_seq_show() finishes and calls mddev_put_locked(mddev),
   mddev->active drops from 1 to 0 and __mddev_put() queues
   mddev->del_work onto the already-destroyed md_misc_wq workqueue:

drivers/md/md.c:__mddev_put() {
	...
	set_bit(MD_DELETED, &mddev->flags);
	queue_work(md_misc_wq, &mddev->del_work);
}

> @@ -11112,6 +11094,11 @@ static __exit void md_exit(void)
>  	spin_unlock(&all_mddevs_lock);
> =20
>  	destroy_workqueue(md_misc_wq);
> +	/*
> +	 * Only now can nothing reach md_new_event() anymore, which wakes the
> +	 * pollers of /proc/mdstat through its entry.
> +	 */
> +	remove_proc_entry("mdstat", NULL);

[Severity: High]
Does destroy_workqueue(md_misc_wq) guarantee that an in-flight sysfs store
on an inactive array has finished before remove_proc_entry("mdstat", NULL)
frees mdstat_entry?

In drivers/md/md.c:md_attr_store(), the caller holds a reference on
mddev->active across entry->store() (where md_new_event() is called) and
only drops it afterward:

drivers/md/md.c:md_attr_store() {
	...
	spin_lock(&all_mddevs_lock);
	if (!mddev_get(mddev)) {
		spin_unlock(&all_mddevs_lock);
		if (kn)
			sysfs_unbreak_active_protection(kn);
		return -EBUSY;
	}
	spin_unlock(&all_mddevs_lock);
	rv =3D entry->store(mddev, page, length);

	if (kn)
		sysfs_unbreak_active_protection(kn);
	mddev_put(mddev);
	return rv;
}

If md_attr_store() acquires mddev->active before md_exit() reaches
mddev_put_locked(mddev) (for example, while md_exit() drops
all_mddevs_lock around export_array(mddev)), md_exit()'s call to
mddev_put_locked(mddev) only decrements mddev->active from 2 to 1 and does
not queue mddev->del_work onto md_misc_wq.

Similarly, if the inactive array had bound rdevs, export_array() moves
them to mddev->deleting via md_kick_rdev_from_array() without draining
mddev->deleting or dropping rdev->kobj, which holds a parent reference on
mddev->kobj; if rdev_attr_store() is in flight, kobject_put(&mddev->kobj)
in mddev_delayed_delete() returns without waiting for rdev_attr_store() to
finish.

In either case, destroy_workqueue(md_misc_wq) returns while the sysfs
store is still running, remove_proc_entry("mdstat", NULL) frees
mdstat_entry, and the in-flight store can then call
md_new_event()->proc_poll_notify(mdstat_entry) on the freed mdstat_entry
(followed by md_attr_store() calling mddev_put(mddev) and queuing
mddev->del_work onto the destroyed md_misc_wq).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D7

