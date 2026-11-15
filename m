Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB544606A8A9
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibTWXuln
Received: by kanga.kvack.org (Postfix)
	id F24AF6B05B0; Sun, 15 Nov 2026 15:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBE76B05B2; Sun, 15 Nov 2026 15:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E133E6B05EB; Sun, 15 Nov 2026 15:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCDE66B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:37:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCE0C120810
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:37:22 +0000 (UTC)
X-FDA: 85438513524.11.42345A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 335D61C0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:37:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibTWXuln;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775041;
	b=h3jEBTaINIEiVQP9hQrbyoA9QVoUSkrrf4P5tTyCQzkans4BYJJMoU6jLV0XTC54FSxu1I
	6WbAZsUwJ5+iqROX8bktrP/ZDbmu29tBOqknQ6H9EWuZMiuxDY3JmB13mu58LK0/LUmKSc
	cjAa3oyu6iIQ4g1f5AnRzxfLqY5FDWs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibTWXuln;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775041;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ikmg9N1RsKIQbI3uEth/NIY2dtjDJEnXxL3eJbP4m4=;
	b=anwOqEFbSsvc4IarhuxgQ1lRWut9MdoG71FzFQxke6KIdgY8VQiv5FP0uftdCgULOdHgS3
	jH8jLlNXwLMeGrYE6jXSfYMxK2QZOAPuXfCnOl0Iyt2niB4zjn4cgMyks5030FvL4Zi3iD
	2z8HIUYZCTHguTl50/wi5bBYOdJGY20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6DED60613;
	Sun, 15 Nov 2026 20:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3063F1F000C5;
	Sun, 15 Nov 2026 20:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775040;
	bh=+Ikmg9N1RsKIQbI3uEth/NIY2dtjDJEnXxL3eJbP4m4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ibTWXulnm28aRjewGrfq6X+okOL9yYiscjWw6mYnGt7knhi/F9w8MR032Xl5rDvaP
	 Inu4IFd4B5cpdoJXapkN3GLodvVDOnFSgYli8deK0COtDp8o4OQFICCna0oLS4howi
	 WJFHEbwOdYk6IIGiSj2PuhFV4ZlHRSR6TB8sSTQOlRpsnQ5C3Ow8mC0di726vKx7JQ
	 IsEzyO2ZiCNESLXtPfCJqwrGRC3lMqj3s++MkaH7TERa9Q1hoGY6UaiSdkEyXnPQh1
	 3ZlgDmPjFHmGT6A5lfI4IqnFgFDJICzjhco5R0GJ/FYS5h7Gsxy6v8zrK8Ky3puM9l
	 R0C+rcPwpLPAQ==
Message-ID: <sashiko-outbox-215847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-14-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-14-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:37:19 +0000
X-Stat-Signature: 1fh8jsq9gtxrxq6dpwsef4mwtrzhdzme
X-Rspamd-Queue-Id: 335D61C0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794775041-848690
X-HE-Meta: U2FsdGVkX19Ep940wguzUoM9ZE13qwCaC2IzLZxu7+T1r0JN3mILWo/zcQ2T7NDufmtNetbTj0mUvCUs+5F/YOR/s8Ihcl5UvrtxxBVTzUqMQjQaDc5l9311XBJx4FFHTxjkx8ZpJSU5kK7IWBEncUMe3S83YxByb3EbBudHy8boql4VZFWNguLBVghkWKiYp1bmeRshjdY91wxy9OpZTv3oI7KOsgNoYwDi5ZiwW9gjoWIiFW9M6OSTxnPzrhB4x1WKBgobfNaw0jY3DR5f3m1O7Jkbzqu3x0DNyxTTKiQf2zUHBX/SrNJrWUjRreXuz8JidKMZsN7IPEa2xYEiwizBwVsozjv+GXxwSTrkEOh1h97wvNakmqfQ7xA9SF1j18/0ONCXDwCx9DEoIBBnF6BzwsukJuGnu/L58i6lujWSt5QHVkbukPDHkFSm+2nS5sAc7CjOuLUlwx6xEoRjI7I4kVJAYmazIKN3fEpFg1zBIA+MsLzEapdv3EYTWrTI/nMm4wnOcwDspW3CJCQHkNcEK/uvp56FZC191jprayrW1u1Oq+3tFcluFXpI0UvHyAWuUkqrcp9qI2riHeegEWPnIPgJ9d+rYRMCMYTY9kdoz21YF+uMljzPL1I6GViN2RiOLfX/pAGR4KzzfA1Jf5ty0/FxZNBgXt0Rrq1fUprQsCxARHSyHpZfJJDuBpsU5OmusH0GYCjuru67gAUGm/7CHApGRibcJKvW8l15Tk6YYVtWuHHw7EzRRkJe2/ZgNyDmq6fOhw8ap2DaLsOlfmTMm3No47RbkejElPcrIgdefJJ+i7YUUpv+GzYFUI2LaqEu+ETwnLioTJi9AnFJc+dz5o6DdRfpB1MGw5+fGTMOIHLMU789ejQXscvNQ/SxFpZKToKR6tXerysnlSOJxAg2FTD/rnLMoUSJzg7NUZoHcyiimQwDy0had4u2L4AF+VTDQEUOp3gUxkTDjhH
 GLUKCXqm
 Mw2BMA6gjbDj/x2yPBm+uHxWg82fRs8P6ID5WHDreQ0dq3aJYwoKQI5pPNdqm/nrsupv+zr9A++6Nd46TvFuch5AN9s0d/7YGsV357WVAJPMWyYmmbAy8/B/lyEvAH3dJTKeDFwjp6TAVx4XXl9pJKvmX+yZVMbqLCVNlDlSVqERBBvY3fRF2jDkVvWo/+N7X9qcW/w5pblUHORieYKlg21Z2HNvEt9WkwELO45T7puk5is8C1rLvE/ErHdkoyTXnYiJqwfZ93C/320JeU2X9WDkZioU0jXRqiCwpxHQNlHA5rrK3GfJN1ShZlGTbRYK8DlFai8LHAtaGOj0Ykeoru3r/OUJKODWcTZXCnm+/JkqYWwHAUSW3QLHNbKTjvohtughs5jFqmURG8cSeC7X02iReJZ0ikjthFXXAwQij3OXf7dh+9frpIUDEfUVSwFXpld8hoxvc8lvrtkHsTcj44S9XjGgKVhqGKYrZxNvM4HiyiECBUjAQh71MK+V2wq3on31dEWEK4oGcmHFtT8Bv4LI2b4CEHfeTQQUAfiUWll622xhbLX7vtl3AaEe5HFW4wDR3d6G1w++nXkQhPJJDd5eFcdToZMVD1Y/CcJJAwZot/dbCzS4FpQhWzz6qKMV/kUmB
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
- [High] mm/damon/core: out-of-bounds and uninitialized read in
  damon_report_exist()
--

commit be7b07b7677627ddaaa72484649217b5172610a1
Author: SJ Park <sj@kernel.org>

mm/damon/core: introduce damon_report_exist()

This commit adds damon_report_exist() to search damon_report_queue for a
report matching a given type, address range, and minimum age in jiffies.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index c02c7fbc1d864..c60a6504d0a15 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2386,6 +2386,52 @@ int damon_submit_report(struct damon_report *repor=
t)
>  	return 0;
>  }
> =20
> +/**
> + * damon_report_exist() - Find if a report of a given condition exists.
> + *
> + * @report_type:	Type of the report.
> + * @addr_range:		Address range of the report.
> + * @jiffies_old:	Oldest jiffies to find the report for.
> + *
> + * Returns true if the report is found, false otherwise.
> + */
> +bool damon_report_exist(enum damon_report_type report_type,
> +		struct damon_addr_range *addr_range, unsigned long jiffies_old)
> +{
> +	struct damon_report_queue *queue;
> +	int lock_old_val;
> +	unsigned int idx, nr_read;
> +	struct damon_report *report;
> +	bool found =3D false;
> +
> +	queue =3D &damon_report_queue;
> +	lock_old_val =3D atomic_cmpxchg(&queue->lock, 0, 1);
> +
> +	if (lock_old_val)
> +		return false;
> +	idx =3D queue->tail;
> +	for (nr_read =3D 0; nr_read < queue->nr_reports; nr_read++) {
> +		report =3D &queue->reports[idx];
> +		if (idx)
> +			idx--;
> +		else
> +			idx =3D queue->size - 1;

[Severity: High]
Can indexing queue->reports[idx] before decrementing and wrapping idx read
uninitialized or out-of-bounds memory?

In damon_submit_report(), queue->tail is post-incremented after writing
queue->reports[tail]:

mm/damon/core.c:damon_submit_report() {
	...
	tail =3D queue->tail;
	if (tail =3D=3D queue->size)
		tail =3D 0;
	queue->reports[tail] =3D *report;
	queue->tail++;
	...
}

Because queue->tail points one slot past the newest report, the first
iteration of damon_report_exist() reads the unwritten slot at
queue->reports[queue->tail] (which is allocated with kmalloc_objs() in
damon_init() without zeroing) and never visits queue->reports[0].  Once
queue->size (1000) reports have been submitted, queue->tail reaches 1000
and the first iteration reads queue->reports[1000], one element past the
end of the array.  Also, when damon_submit_report() wraps local tail to 0,
queue->tail itself is not wrapped and increments past queue->size on
subsequent submissions.

Should idx be decremented (wrapping from 0 to queue->size - 1) before
indexing queue->reports[idx], with damon_submit_report() updating
queue->tail =3D tail + 1?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D13

