Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002C8606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLyf66Bg
Received: by kanga.kvack.org (Postfix)
	id 09F996B05B1; Tue,  3 Nov 2026 14:07:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050596B05B4; Tue,  3 Nov 2026 14:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59FE6B05B5; Tue,  3 Nov 2026 14:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5A96B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:07:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0021640528
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:07:57 +0000 (UTC)
X-FDA: 85394742636.05.24DBF0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 472C440007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:07:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLyf66Bg;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732876;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8HtBIj+8UA4ApalLzQOjrxxVwWtafDT0U5NHOYSGZ4=;
	b=hNwKHgrbp9Rd1Qsu4Bw3Ls3YOeXukDrOGXgSynpo7wmW7tkx61vkuOcSV/8Dp+bNWyxbe/
	6Hfrk0Lo2FuytNz5XFWoe/Lii4QdCUeMBQ0CG56BWCqL2oed828NfgD5jJHAQrRXdMT4ap
	5ITPpb5ATFWtM8RoBuUtyx/T0zeon+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732876;
	b=r+zce4bmd5LTuBxLxF10EJej0lKWHaN6EO90lWRD7YUH6rfisBajS6kJB93sGRgqQuK4cG
	cC6o+7PR047HN6qJvyQ6IslFU3gz6+rF4PRNnOzA9kq1fqGqAYQz0vV7h1oACAPeb//3Yh
	dmxN6Kks89zuc/o3Q55kzouGhTR7bK0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLyf66Bg;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E20040A39;
	Tue,  3 Nov 2026 19:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EAE1F00919;
	Tue,  3 Nov 2026 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732875;
	bh=A8HtBIj+8UA4ApalLzQOjrxxVwWtafDT0U5NHOYSGZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BLyf66Bg4MDZlU9tb2muOvLe5UkZij27IYV6xhAPA0ep2kCD2FPvQ/7/ePAfdBylG
	 gk0qlnzuFxiifl0+RdCwSxOOZVY6Ik8HGKZBGfOcYGFndCCQEfidiFHNnCTeC1HEPd
	 OyOulLS47jp/EerKnj0NNDMDA5uaZy2EylXgTL8il6jZaQIZmKzcHy//zwjY16Vmbv
	 NK6X2/iUw7iRe0oCjfua1n3e6nDdo1aTh0e0jcLDrkWz5Ap0cPV5Dp/2UjnzI4DkwH
	 0+9g8dVeSto7rqo/jHYi/KFb/ovXApI4W90MmzUiXPb34UG83ok/y0AzkTltUhATJt
	 scvzgGSXdo+GQ==
Message-ID: <sashiko-outbox-195886@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v23 04/10] tools/testing/hpcc: add userspace test of
 hierarchical per-CPU counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Martin Liu" <liumartin@google.com>, "David
 Rientjes" <rientjes@google.com>, christian.koenig@amd.com, "Shakeel Butt" <shakeel.butt@linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Wei Yang" <richard.weiyang@gmail.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "Yu Zhao" <yuzhao@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Mateusz Guzik" <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>, "David Carlier" <devnexen@gmail.com>, "Josh
 Law" <objecting@objecting.org>, "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Kees Cook" <kees@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20261102190708.1287100-5-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
 <20261102190708.1287100-5-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:07:52 +0000
X-Stat-Signature: fubgeyki7c4rg5o5dzhw9kau8m1ec4dh
X-Rspamd-Queue-Id: 472C440007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793732876-192793
X-HE-Meta: U2FsdGVkX1+rVBbAG1FQ+2oR304RaqpO+H6L30FV+29gYd8FQYO8pabno82HNwyaZ3aDqMoLZd/sb3i+7Qb9YAY81Hjr2f0SF2uDDhantcNSxgJEeDZejz5wSdYZ37NriFrArJilWK0+W73xQ2iDJJtHxxZIS7tphJpDwdDBkm98hCr4hiA/gpOHTY6daMnOmElcfPhXq00GTcx7lvbHNplGVt11y6v5Wn4KLeOKsfPMSAdISW6lBce2DpY8rmz87IZPu5e4zX5eW3qAbnhyTEpFpVXjXId7QrlIf456i8DTPcUenf1cGQ5bATLxxWUOhfVIIuK9FHb+5xcoaYdsvvRfZ2vz+rKm5PgAWb1X63c7BfayTXnI+Fz0abmDUcPgqpfmqOWl9LE0EFW+/iUzzC0lQmce8Wce3QdQMyhr4GbwDA7qfyPMCiOWPAknADrUp6p17zyaqXLosRwDd3ioDifolZliGkGFtdjbgFz3QUv7FHwG52Xygu2cZYhJ7gbi0vfNhe5JD1Gp32aQsIX6ttV7woTTjJ7cPHVFR/WC+68nQIBCiYkMXp/v74bmfA4U6T+sp5rlnUbPWQ7YG8JchHl16DeTESg6fliO0nM+ZXcf+oHpmFUKzvew+rkG4ALub9QDeNsN+zqSYTjtLyPvIcM+G5yJjc2TTOS6kSAdaplIbYOE1TZI98VM1vWIwJNU/rd5Vm4NCeQzCcUguJ9Bfn/AureZXGr3Mar3/SWacq9E/AE+12OvXQmY9RJSIhXGOVRcbRTuOoRcjaeVqr5TYzLT9jM3GC2u3e2QbR3nVZL+vxN+2/yfl/R8HGz+5ndC/OXimnIBLqAmoIFa7zWr17UOO303bml5qFzesZJPQfqFEgd5OfVugXb3/wdvVQqSw80m71FSRhxvsB+RJdExkOU8YCrlVbTh4qrW7xopNRJ/W7zmvLzxQCPYAvyW1ZjrwPAWmvRDD6HSE4tOM0k
 Ad8SnulI
 3CPj9Ob+O4Lx+t4ah3WvpmD1LYF4cMTUEuzCEQ8xDIlQjazJi5oyVNq/92QaVoUuigT//E3/mSu/mA3zQAF6njIzp4OkRKihAwsN4xH3c5bOYsRB2FS2ohtZrmfTBWReGZZkXbYtBNetIBgBnDfkiqCVaI8m9CEFc3A7I8hxLq2ogNrpXUEUn7LgeN97Ccy0vD0oJcMrJ+5UKDfVzVxQlYhea/xHmiwjL30XLDiRipnRwWiSa6hvP6aNJkh9bOKH1zWCX0jyztYUbN1E7HZDLZjkx9TfcetF+sUK3kO03nRfIXApoimnwGIgw7uVy/E11jlPhouiFLb0xxHsBcdCGIDslR/0LpdNQ8t4h9sTx2ySDV6MbJtAdinfN/msEk3A88V7lWjYgcJBgxW0m8pwrnTS7PFELK1YGdVz6H+v7DXVnIYo79qUArybkFnT/QGBqT6rvOGyg3uSv8vdjEOaZDHsLBkonV9a1n03hWEQKfY/yq3xobkEvdLmqC9kDOkm2iXJmljdhobaL6E2haNRNrgOsw3h2n/7Z8VIWvdrrQkmrJtjfh9iRsWM0PQwcj+tTmmFaA/PfkUFzHoBzIsEMy0dy9gsTxoBC+9W7UMfK3VaJ62n8d+pDmliYz57xMdOmFLhkKE0tuQSo/WlrZNJZEGTJiSKNabNyJcOigt5GHY+MnY+DLWH30t/pZXx1yIJoC7oT
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
- [Medium] tools/testing/hpcc: counter leak in test_saturated() and test_ra=
ndom_walk()
--

commit 503d613a781c32158eec55568b3137245d93fe15
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

tools/testing/hpcc: add userspace test of hierarchical per-CPU counters

This commit adds a single-threaded userspace test harness under
tools/testing/hpcc that builds lib/percpu_counter_tree.c with a simulated
topology to verify counter saturation, random walks, accuracy range
contracts, and comparison functions across all supported CPU counts and
batch sizes.

> diff --git a/tools/testing/hpcc/main.c b/tools/testing/hpcc/main.c
> new file mode 100644
> index 0000000000000..b707754aab0a7
> --- /dev/null
> +++ b/tools/testing/hpcc/main.c
> @@ -0,0 +1,413 @@

[ ... ]

> +static void test_saturated(unsigned long batch_size, long inc)
> +{
> +	struct test_counter c, probe, exact;
> +	unsigned long accuracy;
> +	long approx, delta;
> +
> +	if (test_counter_init(&c, batch_size) || test_counter_init(&probe, batc=
h_size) ||
> +	    test_counter_init(&exact, batch_size)) {
> +		CHECK(0);
> +		return;
> +	}

[ ... ]

> +static void test_random_walk(unsigned long batch_size, unsigned long nr_=
steps)
> +{
> +	struct test_counter c[2];
> +	unsigned long step;
> +
> +	if (test_counter_init(&c[0], batch_size) || test_counter_init(&c[1], ba=
tch_size)) {
> +		CHECK(0);
> +		return;
> +	}

[Severity: Medium]
Can these error paths in test_saturated() and test_random_walk() leak the
already-initialized counters when a subsequent test_counter_init() call
fails?

Each test_counter_init() call allocates per-CPU level0 storage and tree
items via percpu_counter_tree_init(). In test_saturated(), if
test_counter_init(&c, batch_size) succeeds and test_counter_init(&probe,
batch_size) or test_counter_init(&exact, batch_size) fails, the function
records CHECK(0) and returns to run_case() without calling
test_counter_destroy() on c (or probe). Similarly, in test_random_walk(),
if test_counter_init(&c[0], batch_size) succeeds and
test_counter_init(&c[1], batch_size) fails, c[0] is not destroyed before
returning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102190708.1287=
100-1-mathieu.desnoyers@efficios.com?part=3D4

