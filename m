Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940EA606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cGy5Z06g
Received: by kanga.kvack.org (Postfix)
	id B2AE76B05B4; Wed, 11 Nov 2026 06:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02976B05B5; Wed, 11 Nov 2026 06:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3FAF6B05B6; Wed, 11 Nov 2026 06:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB216B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0995D12027D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:47:42 +0000 (UTC)
X-FDA: 85422663564.27.430C134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47E62140008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:47:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGy5Z06g;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397660;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+4YllydhLYIhKjaH2Dq1a349nWeQdKBMYQlbh0797k=;
	b=70GntXK7FW13+xZUTQ9wHupIsRXsokvBmOtK0Gf+Zn2Wwg5uPWtdLPkQyNaj+pafDeAts7
	//+ZLPGmapU8OAYA5v91m4GjAJQVv4nX6dtnM0A9eYBP6dvu5S0qrRXRYLVgwrus+TGW7T
	WwYGum52vuU7sRn8HMH08dAyC1e0Yhk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397660;
	b=4yWM5+KAO/t/ocyJHBqnjsEV+TW3Qn5dLhFCI+kLth9lOgxjNNDwgzCgJJB1gHUhPEvAjR
	VsTBEPEBfIQXIiaqOiSJv8j8nxForqqNGX6P/x3dZdOmtK+Zh4d7/bC/rgYVZr8cdnrffi
	kSAQ4AMkPrt8vp46Pgnh/2kMzXvJW5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGy5Z06g;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F26346187F;
	Wed, 11 Nov 2026 11:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B138A1F00A05;
	Wed, 11 Nov 2026 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794397658;
	bh=5+4YllydhLYIhKjaH2Dq1a349nWeQdKBMYQlbh0797k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cGy5Z06gRnAurReB0aL9C5sS+GXSKxcYqsQ8Gllupj76P+K95XmkFuQ3JXz0SAMoC
	 UXJHRMLK8KBHW1F9uBuM2BUZZN9pL8R2ZLeDZXkGY0ZNglIggFbTegu4zFaSpIVKle
	 6zimhSUXEku3NQ+3JCu0jeYRblVoGFFOmFWBVuPUlL9MYjWwHICDlJ0OY4G9KUqEGU
	 CLeiNj1JAoeOWLR9v02ybDIuT1xjcThTOUHyAFGQDw7zUbb5F4qC2ofRVifhDd2ZUO
	 oSHepuYh8H2I9rEIqhUWRKmnnJa0OGRmDA03kVnWpcfhjYU+w2BMYTiktfL1OfktUJ
	 PrAXJ+pTbd1Kg==
Message-ID: <sashiko-outbox-208900@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per
 timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Breno Leitao" <leitao@debian.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Julian Sun" <sunjunchao@bytedance.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, kernel-team@meta.com, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 11:47:37 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: ru4icbk7zcopgqj5wzso9xonxmfduzcc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 47E62140008
X-Rspam-User: 
X-HE-Tag: 1794397660-595559
X-HE-Meta: U2FsdGVkX1+AsUEqLlbGDdvn1PVAckeYZG7gjsn78jlP0Yn8BkY9FIqUTz9PTzWtjZvHUK/E5qDiNxjNBBRmqvb4J9/IibFFGjIQxBZBc4htgtlpaXhA8q8Qz6dBmhilTIKVDdEOBcGafw9ubYkeeQeY5J6SAgg7I5zBF0eyGWbPeqivBQvvJp6sIoXNinT7/i7j9VSaNv/McjTy5K+43dGPo83Zb5vQTrqxpsKZVYEdzyjyp7ZkVSRg1dI9oeL/G6jogAiGNdmjk6uWQ+Orc6Bp1u6ZL8o0y1NxT4Poa5yeMWZJQVzDJ9TamU6k4zaPkbAwGpZ5xVGH0xF5Sref/1NOAc6seQWSt7b3gsE1PONga+ez71sqz0buvFepQdhyHGPdju35/rWvgJvcxhHxq99vAhUfRqHUcLQCmS+6xltSdN5Fae8v36PgWYKVO50YjTCx7jFMrZmVvzKxaDt0uwFZvIzU12mcBffbDFTlNQRKEIv18YGnhXJ1LG3Ok2M5igQQi/PKq8LrjGN4hoS0XG2BufLWc8lUiaKrAASVkogZfWRbB6vW2UNTT5gaH1Hxnt6iDfG0m6adjJDC7QWvlNDdyBwXrc4eP0JpFacf/An/+nDteHGRPrnFYc/biyc85rvHMXXQdKS6EbrOyv84cElLZVOzao7oQL/uKfLRD8g1xNV2mDJ4zzjpDPw3FNNZn6lL68mgejMuJ7Vcn/95hkzMElN+iHm5+lXmjJtf/O4VOs2tyAWuiHflhduE6mpBZb7GVogWry2oJSgLikcJSip3QZGfmUdG3SmxRxgMU6lneaaZCSjufVAY9a7WWDSxMeG8eds9pIpa7345lc8Cxq+UTLYcsZn+sFNJafO4NhXvQf5RjjEiQK+Ty6vIwK+ugh5t0LC3t6EFS/3SbH+M+K+XseODlCUROJ+Wu27rWcw45dW+usuIgBOu+g2n0mhiah15ZKbEoJ+jxXF96lG
 5WfrBBrt
 GEt8fps6KilpgVGEvmfLL1gQYFkdnOzWe5+5GisRNIRyIM0+0shj/zA5yLgQqXR8jq6iNArY6MIONg0kxrPjBC2gdDq1G21Z5dZxRFzgIRTkADZFFtOqyx1hWV9R99Ak1J6pZXI1FWMKNyNBT9JhOr6tLgaLWGZWHlmTIiaW1nXf7+NaEh+HhFsjMEMi5o1cDJ2wQ7kTBVPYSIIfONjmbwJfS5UIWTeaf6DEeYuFKH1fhITrkfNnur0EqOtukADrjm0k/H4GG8tsWQ/IiBpzHa3sb/sPb8VP/MxollRHNV7eJG4DETwEXb1/sq1vnFghRl3uGYkQ/8c967cy4nY+lPakcRvelcCTaO0SrAgi+3VM2B2pldElAlxMXsWP3e5q5GHDOZIjPtEU7VFRlwvrN5CGl1Jg5XfztBjCHg3UokTqAfWb/q0qNEM7k90I30Z8QQdARReGeo0W/EnEz38vpgWyOp4Tr5lmaf5juM0EAbB/4/R9aQEQH86d2X8LZHHxWZe5QE+1ttHonVjKhtfvt/iIQI9ywEpeIuxKXZenfStZ/BvjdFR5al7EbDP965mAg61VHmP5SNVcsHtd2tMLsK7N1HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] writeback: hung task wakeup interval exceeds timeout in
  writeback_sb_inodes()
--

commit f3edfd7b6ff429943317ab66c7dd1c29f9226156
Author: Breno Leitao <leitao@debian.org>

writeback: report a slow writeback wait once per timeout

This commit rate-limits the slow writeback report in
wb_wait_for_completion_cb() to once per hung_task_timeout_secs, initializes
done->progress_stamp when waiting starts, and increases the progress wakeup
interval in writeback_sb_inodes() from half the timeout to the full timeout.

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e2da4781b5e00..fcb7fb0196208 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_com=
pletion *done,
>  	unsigned long waited_secs =3D (jiffies - done->wait_start) / HZ;
>  	int left =3D atomic_read(&done->cnt);
> =20
> -	done->progress_stamp =3D jiffies;
> -	if (left && timeout && (waited_secs > timeout))
> +	if (left && timeout &&
> +	    time_after(jiffies, done->progress_stamp + timeout * HZ))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds (bdi %s, work items left: %d).\=
n",
>  			current->comm, current->pid, waited_secs,
>  			bdi_dev_name(bdi), left);
> +	done->progress_stamp =3D jiffies;
> =20
>  	return !left;
>  }
> @@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *don=
e,
>  	unsigned long timeout, waited;
> =20
>  	done->wait_start =3D jiffies;
> +	done->progress_stamp =3D done->wait_start;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
> =20
> @@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block =
*sb,
> =20
>  		/* Report progress to inform the hung task detector of the progress. */
>  		if (work->done && work->done->progress_stamp && timeout &&
> -		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
> +		   (jiffies - work->done->progress_stamp) > HZ * timeout)
>  			wake_up_all(work->done->waitq);

[Severity: High]
Does raising the wakeup threshold from HZ * timeout / 2 to HZ * timeout cau=
se
khungtaskd to report false-positive hung tasks (or panic when
sysctl_hung_task_panic is set) during slow writeback?

In kernel/hung_task.c, task_is_hung() stamps t->last_switch_time with the
time of the scan that first notices a new switch_count, not the time the
task actually scheduled:

kernel/hung_task.c:task_is_hung() {
    ...
	if (switch_count !=3D t->last_switch_count) {
		t->last_switch_count =3D switch_count;
		t->last_switch_time =3D jiffies;
		return false;
	}
	if (time_is_after_jiffies(t->last_switch_time + timeout * HZ))
		return false;

	return true;
}

Because writeback_sb_inodes() only checks the threshold after
__writeback_single_inode() finishes, consecutive wakeups are spaced by
HZ * timeout plus the time spent writing the next inode.  That wakeup period
is strictly longer than khungtaskd's timeout * HZ detection window, so a sc=
an
that runs right after a wakeup can be followed by the next scan at
last_switch_time + timeout * HZ before the next wakeup happens, defeating
1888635532fb ("writeback: Wake up waiting tasks when finishing the writeback
of a chunk.").

Keeping the wakeup threshold at HZ * timeout / 2 while tracking the last
pr_info() timestamp separately from done->progress_stamp (or only updating
done->progress_stamp when logging) would avoid waking the waiter late.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-writeback_=
stall_report-v2-0-9e0ed75074ca@debian.org?part=3D4

