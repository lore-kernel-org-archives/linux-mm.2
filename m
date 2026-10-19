Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B7ACCF2E4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CBB6B01B3; Mon, 19 Oct 2026 07:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D3D6B01F1; Mon, 19 Oct 2026 07:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE486B01F2; Mon, 19 Oct 2026 07:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9686B01B3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:34:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24633A8167
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:34:47 +0000 (UTC)
X-FDA: 85339168614.06.D55A5CE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id F1F3D80008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:34:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Btioxvxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CSXyFG4N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Btioxvxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CSXyFG4N;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409685;
	b=UXJaJTCuvWhw6i+kIn1E6Q/p+2OdiL0svalmk4sDoM9S8JXYRsHn0UPjbxGC582y/PnWoA
	tb/uHywcB+y01Rx18VL9xm4s9lflbs9IslsoK30xaam1bI1ALZuhU7UkKmbTaubnl+iXZd
	x2nx2gTvEwYk0h+lNBrvUIBpVsy/YNc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Btioxvxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CSXyFG4N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Btioxvxy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CSXyFG4N;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD3t1wkN6Rchd26X8X6BEMEdqv5151afoVogq/j3xEE=;
	b=H9B+tYKtJVacwzBtw/FduDe0Ey1IY5PftXrS7B+T8371rRWAVDq+yQczi+wqVTxNZtAq7z
	Kc/SeFqFTh0VmlWLZDpADFrK+P15h67tOv69R88smjAn+u583aKsqk6votcQ951xV07NK6
	yV6QJHw/QQEJCZY0yejjBvZ6k88aroI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1F521F441;
	Mon, 19 Oct 2026 11:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792409683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD3t1wkN6Rchd26X8X6BEMEdqv5151afoVogq/j3xEE=;
	b=Btioxvxy2o/5nNjvrR/K024Fg9yRxU/DMlJ4FkQmX30tIdzdPtTzjjyLAOgv/bA6lh6nQC
	EhQICIipr8jVetUX/9sbV8pdOzUwXssZDtg7CLe8V89kWRPWE4yApuL1Ko/JGJmD7A41+u
	hipbb7daq4UFDKgMx1HWQds7Am1G+Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792409683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD3t1wkN6Rchd26X8X6BEMEdqv5151afoVogq/j3xEE=;
	b=CSXyFG4N0Co80mhRy5z5Z4Tf6vZKCYn4pVt1fSZvcp/kmS1ALupPvQJ8F3fw6DMCtG1808
	ECpplwObsREGaDCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792409683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD3t1wkN6Rchd26X8X6BEMEdqv5151afoVogq/j3xEE=;
	b=Btioxvxy2o/5nNjvrR/K024Fg9yRxU/DMlJ4FkQmX30tIdzdPtTzjjyLAOgv/bA6lh6nQC
	EhQICIipr8jVetUX/9sbV8pdOzUwXssZDtg7CLe8V89kWRPWE4yApuL1Ko/JGJmD7A41+u
	hipbb7daq4UFDKgMx1HWQds7Am1G+Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792409683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD3t1wkN6Rchd26X8X6BEMEdqv5151afoVogq/j3xEE=;
	b=CSXyFG4N0Co80mhRy5z5Z4Tf6vZKCYn4pVt1fSZvcp/kmS1ALupPvQJ8F3fw6DMCtG1808
	ECpplwObsREGaDCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87164134B3;
	Mon, 19 Oct 2026 11:34:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xFQWGFMA1momMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 11:34:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 13E2BA1413; Mon, 19 Oct 2026 13:34:39 +0200 (CEST)
Date: Mon, 19 Oct 2026 13:34:39 +0200
From: Jan Kara <jack@suse.cz>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Zijlstra <peterz@infradead.org>, 
	Manjong Lee <mj0123.lee@samsung.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: bdi: reset min_ratio after the sysfs attributes
 are gone
Message-ID: <jf527frib32yfvdlgrmjozxav2kujmijsmakmr3a6wlshdzwx5@ju6qpy6pztng>
References: <20261017030620.793108-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017030620.793108-1-nickolai@csail.mit.edu>
X-Rspamd-Queue-Id: F1F3D80008
X-Stat-Signature: yrcich9nrbn9893kqrr7h3qqeeq1m7ok
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792409684-983923
X-HE-Meta: U2FsdGVkX189lmXgYgx9i2tiV5PAvcBBhz7nagn7DtQJBi21ASFEw1P+83o1EXELWtoLjkydq5Vi153HCsg8tXZyOGvMQfbf2SUPkstR3PfNHh+8J7jMrO/QZZYjNmqc6oH7vnbC06DlENZ7jUULJjuLnaLKaaopuI2zMsSkdcYu/Mgn/AhQVKTiKOS+bULno/EazvdgAuGKyDUqgcdYY1Cm0/6sPYzeKFS8vbr4Yl0pKlUSq0hNVOuAa+nYrQTCTCzfqvIXn0G61vEztbAesHYDHSWfzdeMxUfeLKyJDUt4REAmuKzKdn6Kii+oW4nDV7oJmCKkTfZgw6h5mJUgaoEyMcBlnZgA72qfvCCNBE3D1TIthpGskRucCWupuxkJaFaTwS4vsO62KUKm4CrqUXpIx4VA1sHxfW5uInDU3IuR9TlDevwN4S/vZnmCJx99Cta9KBhcipwFkl4NFhKN4a0NhIh5YKgqB9+gvFD51E9fQfOxxePJ12LnIn9mJqeSkH7LJz16AMtu62M23nGq+0SFRjm9DE29dByTUp6Hte4cfImB2usdGHuhp90KTgzWbyZjryJPmkiNZLmWck8F6JUpwwr7CRogCUnR+00EJdYLq61i9jhRl8uPiDJexhx/OmvwZ55nmKCYrU42iu8/iFT8cIThi/Ev99vHLMzYgHCozAb7ikRyreAzVitl4cRbOmj9DYmYyLRtdURW3hP+BDKlWipZtfDVWm+i9TTRM4bC1rO1mpQYp8JteGRvDVO57SXrQ38hLRtnkTQdoXRXmM57b9B72iENhbHsIKxoDqOHrFg1mylpbZTV386mjAifQFoXNsx7C9zueDKDYXQ/tverWDz8DHZVtSEyFUBd9LU8a8NS3B5XEXJxmw5UaJbP8Jrcdjb1q5i7Bho3uRol8LNCLWrSCNuKTMDvmnASHd0DCBA+DSwvcbFib++Mo0kzjA0Dt95l+ZNOlGYBU4p
 4Wgm5Csj
 80ZCfJ7lTAf/n5bIP1PO05+JWeJHYYMiwzGMRCvMcbw7brBBGLqKWwnTCCz4r3SFf18ZaaT4unNiZA6QRPKV5z1J9JL1bUkfYZ/vLI50KuiELk4ldjEYZeQLqWY2cbc0OxABlV+FWHQ/x5RJZhLpjQhxpvKg/jqR7TdUklUwcetVDu8NW/TYUi10ZtQX4LCxws/zW2Qwj78L3gHHqPWwUqQb20Wf3poepndFKjpELbX8cx4ncq1s5eGsL3+hPdosCK0PxTeXwYvZccXaG5VIrfoM5HXvEaTvjB6KvGJ0S0YsXZo01PX6Rk0AK2ILtH99DrhmYg1s+OrGZGdl3O6bCmryIr4/qVDtqsDE/9s0hruYDtsfKhrKXrgj8tMzXOyhQL9tWUvDnyWXIPiK7U8yfYH/OR3eogqBdHZH59dfEpMIqULc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-10-26 23:06:20, Nickolai Zeldovich wrote:
> A write to /sys/class/bdi/<dev>/min_ratio (or min_ratio_fine or
> min_bytes) that races with the removal of the device leaves the global
> sum of minimum dirty shares charged for a bdi that no longer exists.
> Until the next reboot, that share of the dirty threshold is withheld
> from every other bdi (__wb_calc_thresh() scales by 100 % minus the
> sum), and a later min_ratio store on any bdi that would push the sum
> to 100 % fails with EINVAL although every bdi reads 0. Root privilege
> is needed for the store; the removal is any del_gendisk() (a disk or
> loop device going away) or the unmount of a filesystem with its own
> bdi. On an x86_64 defconfig kernel (v7.3-rc7), 2000 rounds of
> LOOP_CTL_ADD/LOOP_CTL_REMOVE on one loop device with a second thread
> writing 50 to its min_ratio leak the share on the first round the
> store lands in the window; afterwards `echo 99 > min_ratio` on another
> loop device fails with EINVAL. With the fix the same run keeps the sum
> at 0 and the store succeeds. Affected since v5.16, when the reset in
> bdi_unregister() was added.
> 
> bdi_unregister() gives the bdi's share back with bdi_set_min_ratio(bdi,
> 0) and only then calls device_unregister(), which removes the sysfs
> attributes. A min_ratio_store() that gets its kernfs active reference
> before the removal runs to completion after the reset:
> __bdi_set_min_ratio() takes bdi_lock, sees bdi->min_ratio == 0, adds
> the new value to bdi_min_ratio and stores it in the bdi, which
> bdi_put() then frees. Nothing gives that share back.
> 
> Move the reset after device_unregister(): once the attributes are gone
> no store can run, and bdi_set_min_ratio() needs nothing from the
> device.
> 
> Found while formally verifying bdi_unregister() against the kernel
> binary.
> 
> Fixes: 3c376dfafbf7 ("mm: bdi: initialize bdi_min_ratio when bdi is unregistered")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> Notes:
>     The window is between the reset and kernfs draining the attribute's active
>     references in device_del(): bdi_debug_unregister() and the device
>     removal (uevent, bus and class teardown) sit in it, tens of microseconds,
>     so a tight store loop lands in it within a few hundred add/remove rounds
>     under QEMU TCG. A store that lands there also fails every later min_ratio
>     store of 50 with EINVAL, which is why the unpatched run shows few landed
>     stores: the leaked 50 % plus a new 50 % reach the limit. The same window
>     exists for min_ratio_fine and min_bytes (same helper), and for the
>     per-superblock bdis unregistered from generic_shutdown_super().
>     
>     Reproducer (x86_64 defconfig, root, loop devices 20 and 21 free, QEMU
>     -smp 2):
>     
>       gcc -O2 -pthread -static -o bdi_min_ratio_leak_short bdi_min_ratio_leak_short.c
>       ./bdi_min_ratio_leak_short
>       before: min_ratio 99 on loop21: Invalid argument   (exit 1)
>       after:  min_ratio 99 on loop21: ok                 (exit 0)
>     
>       /* loop device add/remove racing a min_ratio store; root, CONFIG_BLK_DEV_LOOP */
>       #include <errno.h>
>       #include <fcntl.h>
>       #include <linux/loop.h>
>       #include <pthread.h>
>       #include <stdio.h>
>       #include <string.h>
>       #include <sys/ioctl.h>
>       #include <unistd.h>
>     
>       static volatile int stop;
>     
>       static int store(const char *path, const char *val)
>       {
>       	int fd = open(path, O_WRONLY), r;
>     
>       	if (fd < 0)
>       		return -1;
>       	r = write(fd, val, strlen(val));
>       	close(fd);
>       	return r < 0 ? -errno : 0;
>       }
>     
>       static void *storer(void *arg)
>       {
>       	while (!stop)
>       		store("/sys/class/bdi/7:20/min_ratio", "50");
>       	return NULL;
>       }
>     
>       int main(void)
>       {
>       	int ctl = open("/dev/loop-control", O_RDWR), i, r;
>       	pthread_t th;
>     
>       	ioctl(ctl, LOOP_CTL_ADD, 21);			/* the control bdi */
>       	pthread_create(&th, NULL, storer, NULL);
>       	for (i = 0; i < 2000; i++) {
>       		if (ioctl(ctl, LOOP_CTL_ADD, 20) < 0)
>       			continue;
>       		while (ioctl(ctl, LOOP_CTL_REMOVE, 20) < 0)
>       			;
>       	}
>       	stop = 1;
>       	pthread_join(th, NULL);
>       	r = store("/sys/class/bdi/7:21/min_ratio", "99");	/* sum must stay < 100 */
>       	printf("min_ratio 99 on loop21: %s\n", r ? strerror(-r) : "ok");
>       	store("/sys/class/bdi/7:21/min_ratio", "0");
>       	return r != 0;
>       }
> 
>  mm/backing-dev.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 18e999053bae..fad1495d3b20 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -1162,19 +1162,20 @@ void bdi_unregister(struct backing_dev_info *bdi)
>  	wb_shutdown(&bdi->wb);
>  	cgwb_bdi_unregister(bdi);
>  
> -	/*
> -	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
> -	 * update the global bdi_min_ratio.
> -	 */
> -	if (bdi->min_ratio)
> -		bdi_set_min_ratio(bdi, 0);
> -
>  	if (bdi->dev) {
>  		bdi_debug_unregister(bdi);
>  		device_unregister(bdi->dev);
>  		bdi->dev = NULL;
>  	}
>  
> +	/*
> +	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
> +	 * update the global bdi_min_ratio. After device_unregister(): the
> +	 * sysfs min_ratio stores can no longer run and set it again.
> +	 */
> +	if (bdi->min_ratio)
> +		bdi_set_min_ratio(bdi, 0);
> +
>  	if (bdi->owner) {
>  		put_device(bdi->owner);
>  		bdi->owner = NULL;
> 
> base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

