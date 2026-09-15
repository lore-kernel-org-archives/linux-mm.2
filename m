Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A651C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 00:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2AD6B0088; Mon, 14 Sep 2026 20:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173206B008C; Mon, 14 Sep 2026 20:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089B96B0092; Mon, 14 Sep 2026 20:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB4AC6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:18:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D92E6C02C9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:18:32 +0000 (UTC)
X-FDA: 85214085264.14.B1D6C3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E04610000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:18:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAK46F4n;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789431511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OrhICSN8u/RhjpK6xkumMZX+poXmfJW0hRinboZnoY=;
	b=wvRPWNnWSVL6zjlEe9oVVp+ctBr9Dz5ht3qN87P7XySkZhGEkqdRbYgmw7td2KW6UIei3t
	f8gjgKNdx+NodMgRHgXwrP1dqFDHWPP4g3ZTQmj0k8DBXYsUpyq8x1a+hbF5suRaNO7HRb
	91uTzn6O1pjIRuqyvv/CROfj/U1gH5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789431511;
	b=L9BTt0IpM+fXhf/Urm3u3pitvNanzEhg6yKqAxIeI5L1iLpX/XJSUcpHsZxiB3LxtgCf5g
	QO9jqoHhqZGg1r4hfTC/cC53NlJRIRiyd6vZy61bCqDHvqW4lWScxXthBUjfKNCAF499b4
	0geDI6DbBtTm7CHxm4nEEyJgSQ5LwMc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAK46F4n;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B86A16025F;
	Tue, 15 Sep 2026 00:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FB91F000FF;
	Tue, 15 Sep 2026 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431510;
	bh=8OrhICSN8u/RhjpK6xkumMZX+poXmfJW0hRinboZnoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAK46F4nt6bTyLy7tR9VugeUfayb/ObL/wGuJOegFUGF7UWPa6B/vSzVepsai0Pde
	 5vb+fDyUSFzgl6yNF0mFufupUfIHMUhq4QPeJkwEF/X35mjwWfPY7/FN65o6ErQ2Ka
	 lMztQGFBa05j/tCGrQnGW4BZhKZy0Nx6QggkGe5kAWidt77OFvnzYtd/zUtaEsxVPx
	 illCq9AN92R+uxmj1fDIe53EM8EcEKOwvUW5HBCY4tbiCf2M2LnjIKdj+Fl1Y8Ayq8
	 lU86Ka6hH2Svw/ZfHxgyRcY3gPaLF7O2o8SfRcOFt3WsTQSoszitm2uoI4gw+DZx6D
	 3zu/JsBsSOU/Q==
From: SJ Park <sj@kernel.org>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Mon, 14 Sep 2026 17:18:17 -0700
Message-ID: <20260915001817.101713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pxy6z86p1pmkjciafw6aeczopy5mezyg
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E04610000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789431511-108906
X-HE-Meta: U2FsdGVkX1/OtFh2B4ZB0rVeAhNsYUbrzESX/LR+2s+v1+lqDkIoYhyqDS3m4JMdGshNwJTbXWEazL+BWk0XNfDoJ58vlLagLNW7SWakhEYSHei/qKUuB5gdS8D0LhRSYj8qmy1nh0VIBgmv3bqXF03FuSwMvYagh0vWUgftwsEuFHMbSO0mBq7LuR1tSwGNPW1mxS4+4q035iP34KKmvemfVqRR2TQW//SsGXKBspaKxBFN+iknBDfd7JW82r/Ksddonml+KDc6wd6nl2fXAK7mODXotyaTUSZQf6u+WRntAtfWxSnrrjQ/n4W0dnE6f+oh7pOS9fmg0g7++A+6gs+Z05JPSyPXGDrGZBQULC7gytaICa8wiq6mspx5XLmbSkSs3IxVy3q1VbHEBgmdSUvWFEDbLuV/6o4dkjk7Xo8mR3HiPr/Pd1foz7DeOxuwEtmR8WwhIj/xdgJJpVoSXAivf08e+o0CCml6sRgzroESzQU47YDYaeTy3nkIl+Z8eyo1nGBtP1UidjBNOxOHiKeG0sw/MsU/DmRtZGCvEkBWuDvU9Vj2fsHD70g4Dd2XkobDZunjL9aooHWXAw3TGNF8vP48wLueWUodK6DSidwXeTlxmKgMK/Ji67cLhg9esB4LUXu8Fbxb6aBNpbUN9rmmH4CbkIEat1TjRDtsjENF1GLLaG2QnaxBNamHwmSQmFBzkWP8G+eETe5Vioq2+UZVTHLoY464CHmSPNu2vcRbV84CPvtw+tKGN78Espa0SUvphUaCkU+QBZ+lhhbp2ge5Y4z9mnAw40kMrVBtRImcihnOvxOJ7D8I7Myjo6HhMzr1Ruk7IFxiSRHsZVXqAsSqpcqF9TKqSHf20pPTiAengbiJy6Z5GaEIM2kc8X7M1qBx5YniDsjn9kO3msBle+If/RxyeArearSHim1yq7ZuXClLS347f2bsVKHT6VcIruK1FqUnHWYZ1vdmgMi
 K0lM++pM
 70LSJTwzJR0NfpF2/fNMffW/yz5xEwXqQWkGKIG/gXW8R79GoR5p3nUTrsIrwifgeNdh8ml2DWlXcOZj/DE6BaXlYskZtcM4JmZ/ZXWq/LikH5JtXeJe6qplV1eZ5IL8lPE2MOZBlRwVgMrb+RtqKUu9/PA443P2w/mOPi36a4qvjmpLPUOqopBUYPUKZWQ0ST4X07c+f3UjqWWYrNzBoTOXjIW0dXL2kr4+xYjGDD8wIvR8w7be+1GaN5sZAt0KLkKvuman67wpihaF3g4QMuoUhyOozejzj1z4Ku+DUBKUI4JwYPWX34itunIz+yK9nBh99NPBT4LwqVYHHngbI4Hugow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:

> The zswap_writeback_enabled test fails when a write to memory.reclaim
> returns -EAGAIN, which means less than the requested amount was
> reclaimed. attempt_writeback() propagates the -EAGAIN to the caller,
> and the test case is marked as failed even when zswap writeback did
> happen.
> 
> This heavily depends on the performance of the backing swap device.
> Reclaim does not wait for writeback (on cgroup v2), does not count pages
> that are under writeback as reclaimed, and memory.reclaim gives up after
> MAX_RECLAIM_RETRIES passes without making progress. On a slow device
> where reclaim does not make any progress before writeback completes,
> a write to memory.reclaim fails.
> 
> On a VM with zswap enabled, where IO delay was injected via dm-delay,
> the success rate of the zswap writeback test drops dramatically once
> the delay reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms,
> n = 100.
> 
> When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
> determine pass/fail based on the zswpwb counter because that is what
> zswap_writeback_enabled actually wants to test.
> 
> With this change, the test reliably passes even on a slow swap device
> (tested up to 1000 ms delay). This makes the test resilient against
> the performance of the swap device.

Makes sense to me.

[...]
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
>  	 * it can't writeback to swap.
>  	 */
>  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> -	if (!wb_enabled)
> +
> +	/*
> +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> +	 * the requested amount of memory due to a slow swap device.
> +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> +	 * zswap writeback counter.
> +	 */
> +	if (wb_enabled && ret == -EAGAIN)
> +		ret = 0;
> +	else if (!wb_enabled)
>  		ret = (ret == -EAGAIN) ? 0 : -1;

My humble eyes were unable to easily understand the change.  Is the change
effectively same to below, and if so, would this be easier to read?

'''
@@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
         * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
         * If writeback is disabled, memory reclaim will fail as zswap is limited and
         * it can't writeback to swap.
+        * Even if writeback is enabled, it could return -EAGAIN due to a slow
+        * swap device.
         */
        ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
-       if (!wb_enabled)
-               ret = (ret == -EAGAIN) ? 0 : -1;
+       ret = (ret == -EAGAIN) ? 0 : -1;

 out:
        free(mem);
'''

Someone might hate the second 'ret' assignment.  But I was unable to make it
look cleaner without introducing a >80 column line.  The file already has
multiple >80 column lines and I don't really mind having a new long line,
though.


Thanks,
SJ

[...]

