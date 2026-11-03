Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3DE606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9kOzyQI
Received: by kanga.kvack.org (Postfix)
	id 640586B00EF; Tue,  3 Nov 2026 07:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618F46B05B6; Tue,  3 Nov 2026 07:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554B16B05B7; Tue,  3 Nov 2026 07:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25B766B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:26:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EE35403E5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:26:02 +0000 (UTC)
X-FDA: 85393729764.14.A52438A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 20C8220002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:26:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9kOzyQI;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708761;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3kxy1ujNLOQAzfXbW/B0BxVSqDdmRml5zW3lrHUwhc=;
	b=cxQtzYu3ZWct1ojXN1YhPVhi9vH064VPTM3JZe4ndGT3tur35oFBYXOPp/wcAhoUl9LDXW
	MncgmP7Ux5HvV+3SMzETkhA6rC9alH05fY/+t4bPOmMiw/Ju1cJMVBfh7Guop9aM8vJTTI
	JQd3xF66rwyIRQrOwqJnO78MvmWmNrw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708761;
	b=J1UTIJx2k61pII00n+RqmLJZSHBNPcPj1owVnHVVr1VxEEnKCX2ZMGtlag3iBFSLmuWQXl
	Xyh8J4iycQ9B21X1HbcT2elrUp5NU2eNaaSGMBO8x4BR6aWoy33Z95qCkLLmU1pKd9Labt
	Jjsg09BLFzf9wJwg7OeCIup3/YhPboI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9kOzyQI;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33A0942A10;
	Tue,  3 Nov 2026 12:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD811F000C1;
	Tue,  3 Nov 2026 12:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793708760;
	bh=N3kxy1ujNLOQAzfXbW/B0BxVSqDdmRml5zW3lrHUwhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b9kOzyQIG6qgPURUzJogzK1XdAl2U/p5yCcT+AY4a/KQsn67VRf/jDb8D2Er3bSh8
	 slYpJKtGhi1uE3zuynI9E2VA3dVJmSQ4Br+kTDmyd32teGG6t9YyRMT38id5G/FhhQ
	 RQ7K4ZbIkjmW8qLUv6Nus8z4zdTwIl5YogcKsTJT9eb7FllLDlNQZOx8nL3aKOUpsr
	 cjARB3Fe4DXHjR7vyDKCsiyzRlIsXjSN2lQKEECKHCDjAQCW/nCGF04FatAk8HSJa1
	 yITlrCWvSDO8mVWUsnltrNdmFaS8iuV2qtuGuXlTELj5BbtsuXbGxSdE17BgDrhDjx
	 W4HdJz02FZ8yw==
Message-ID: <sashiko-outbox-195236@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] samples/cgroup: arm the inotify watch before
 reading the baseline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Song Hu" <husong@kylinos.cn>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org
Cc: tj@kernel.org, tjmercier@google.com, ddrokosov@salutedevices.com, linux-mm@kvack.org, mkoutny@suse.com
In-Reply-To: <20261102122528.1498193-4-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
 <20261102122528.1498193-4-husong@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 12:25:59 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zr63oj514xybupzpkeqy85bkjpou5z9f
X-Rspamd-Queue-Id: 20C8220002
X-Rspam-User: 
X-HE-Tag: 1793708761-135845
X-HE-Meta: U2FsdGVkX18JG3EYQY8151VSIgvxEe3mxKWFUl7TqqSwGaW8J2uHO2KsPsi6FPXAh4YMs3Fy2Uexs98m2ibtASRgMMpZwUV3S5akj7XkrSQUoQ/PD3gHygfsSEYlxZ69nd8lbdJYkj8cPzKGhcvYlhIEEKYwqChvaxzOPKS/3RSEX82ELtKxDil3InCksp5K3sfB7Wpuey8hE3mJkfpKgA/lcTk8H9YtQ8OQ+wnP7EGwHlDJeNZwKQzlFH0xvwN7ybTlxFOxbQN+0GYyqIzkuoEPgNQc2Od5LjU3533lKCOKezVSA+DMH048uhYi3yp+mbIN7rOyqrmJc41BFM8dTo7xUxZxY+3CR40gY6Rfsim9Z3qkOzEggP2mO1bdy6Wqs1mkiY3e5zoppnTFLWZIZObOQ9d+uz1qoccyTVpnsHev8q8EJ3ejvvUqQS8lQvY4yZSCGkfa1x4mNzGxl1k2hbBmawFpqD0LxIyzFAds+ieYRBmQMkd6aB+gDssXRtR2cVeh5FJKZQASldhY7f+5A+R3hjlxS69B94Btet3gDZgibsz/wHgTfyd2mUs1leGu0rsltqb0DMtKCJECvRuTz6SgP0I/nKMi1ahVu6ehpRXYUBNC0okdsyLB0wjcfSxVZ6ilDbD7JZeiUYl+fxBJ/etl6+Yi1JJlVFq76qbL9nUSubDbtWXQ1Vy9Xee69qj9UPcBzRsQzFvbrd/Ms6TykujLOES7HFV7oG7JIXrKVGG2y5JtVUDz8W3yCMCHKKC0CI8L62ei3QpOIkZJLsQs5bCEMQcYUH6h56XFKk9wlLoLTCxdUmTWFzPxZLNPF+VfTKSW904L9UbbBQce4zvzjwofyAqNvQMu5ccpxJThMtdSgrAdBUEDw1wq8FWWNX7vfCnWZoANzEyj2iv/dP7KJfOTPAAL/1bY9qT9YeO6xFDtQ2BrLa5PXKc/NuNuKWL0dPuOoCsU7WiO6/lSJzm
 Tc5dmU2b
 jyZ0MQqx7f5mUyMrnb7cbiG2aebp90RUWkSw9ZhRd4f4G5hd9/i1Vme+xv6Ev8AAj2LeBH1iAsiUjcYECFwZiuGa+TXSjhAyP9auTQQ0n4fjr5V57IDqkajf2xxjQLYcJ0VlXr3jXrUw/yf2AHWxpaZtYAw6Lw4OCDtEFTDGHpTHxIBiGtv0T0rTNNfeAWJMo6UFdqOExobtx+7rf0r934Iy9DGoNL9zORH3c0CPySE6ybnALUeT73kFTcAOTLBuXIKqKkxOczEVLx68hrTOQTxmMHC5tDpSN/caIIEVgmFQIdLupmWnKrLuMowcRillQSqp33OeXAaydOqByUGM6gRog5g1dTPk0Z1mdEUGL8OWwOwfMVSlv5i0fA9gQsYDL5BnWC2aM5w6WdHpqnewr/U/q8E9R43raMQiD4/OAY+pm1PT8tJiSt64wwH99soL+gwIl2JBhUqdYdBwwip69fbkf/17s3t1ug2js6CoLXap+CBJdSQjalI52LBdbDInSo5eWzIMPTrysUci8hPlpX3bPANUI2Wghyu6H9m1C0V14FKKj1h0zWc/smYm5hujUhONm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] samples/cgroup: events before read_memcg_events() are absorbed i=
nto baseline
--

commit e11bb86059068b47a263deb2a44878c61af9a6da
Author: Song Hu <husong@kylinos.cn>

samples/cgroup: arm the inotify watch before reading the baseline

This commit moves the initial read_memcg_events() call in
initialize_memcg_events() to occur after inotify_add_watch() so that
events firing during initialization are not missed before the watch is
created.

> diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg=
_event_listener.c
> index 996bf6fb117c4..c23af43bf6ccd 100644
> --- a/samples/cgroup/memcg_event_listener.c
> +++ b/samples/cgroup/memcg_event_listener.c
> @@ -293,12 +293,6 @@ static int initialize_memcg_events(struct memcg_even=
ts *events,
>  		return ret;
>  	}
> =20
> -	ret =3D read_memcg_events(events, /* show_diff =3D */false);
> -	if (ret) {
> -		warnx("Failed to read initial memcg events state (%d)", ret);
> -		return ret;
> -	}
> -
>  	events->inotify_fd =3D inotify_init();
>  	if (events->inotify_fd < 0) {
>  		warn("Failed to setup new inotify device");
> @@ -313,6 +307,17 @@ static int initialize_memcg_events(struct memcg_even=
ts *events,
>  		return -EIO;
>  	}
> =20
> +	/*
> +	 * Read the initial state only after the watch is armed, so no
> +	 * event can slip through the window between the baseline read and
> +	 * the watch creation.
> +	 */
> +	ret =3D read_memcg_events(events, /* show_diff =3D */false);
> +	if (ret) {
> +		warnx("Failed to read initial memcg events state (%d)", ret);
> +		return ret;
> +	}

[Severity: Medium]
If a memcg event fires after inotify_add_watch() arms the watch in
initialize_memcg_events(), but before read_memcg_events(events, false)
reads the initial counters, won't that event be absorbed into the baseline
without its diff ever being reported?

When the event fires in that window, the kernel increments the cumulative
counter in memory.events and queues an IN_MODIFY notification on
events->inotify_fd. Then initialize_memcg_events() calls
read_memcg_events(events, false):

samples/cgroup/memcg_event_listener.c:read_memcg_events() {
    ...
	for (i =3D 0; i < ARRAY_SIZE(map); ++i) {
		long diff;

		if (*map[i].new > *map[i].old) {
			diff =3D *map[i].new - *map[i].old;

			if (show_diff)
				printf("*** %ld MEMCG %s event%s, "
				       "change counter %ld =3D> %ld\n",
				       diff, map[i].name,
				       (diff =3D=3D 1) ? "" : "s",
				       *map[i].old, *map[i].new);

			*map[i].old +=3D diff;
			any_new_events =3D true;
		}
	}

	if (show_diff && !any_new_events)
		printf("*** No new untracked memcg events available\n");
    ...
}

Because show_diff is false, *map[i].old is updated to the new counter
value without printing the diff. When monitor_events() subsequently enters
poll() -> process_memcg_events() -> read_memcg_events(events, true) to
handle the queued IN_MODIFY notification, *map[i].new > *map[i].old is now
false, so no diff is reported and it instead prints:

  *** No new untracked memcg events available

Also, the commit message states that in the original order (reading the
baseline first and arming the watch afterwards), an event firing in
between "is already included in the baseline (no diff will ever be
reported) and no watch existed to queue a notification". Isn't that
description inverted? In the original order, an event firing after the
baseline read was not included in the baseline (it only lacked an inotify
notification until a subsequent event arrived), whereas with the new order
an event in the window is included in the baseline while queueing a
notification whose diff is already consumed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102122528.1498=
193-1-husong@kylinos.cn?part=3D3

