Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A50EDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 22:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940426B0088; Tue,  3 Mar 2026 17:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9221E6B0089; Tue,  3 Mar 2026 17:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84EAB6B008A; Tue,  3 Mar 2026 17:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 736046B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:47:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ADF6C01D3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:47:51 +0000 (UTC)
X-FDA: 84506240742.24.07A4797
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 593488000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:47:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EVq7jMda;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772578069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKkcFIW0rZcSJrQSa7i3+w3BkUEejorX4Hk2Yq5/aOg=;
	b=XNwJBRA/mgS+fcYrjFbdounPwGc14TRuHHdPqHxQUgbpvivC2GNyqLQX+JROTj+w0Q9P9D
	yaVFrK+/3/IfqyjqssMRDQIO2r88TxhnRIU/Lvl9NfRjMPe3rPExZ/1Iu+NHHbZl41aRjQ
	MlISjKsH+91ImWvYTcuhib+Rt2g2WFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772578069; a=rsa-sha256;
	cv=none;
	b=BV/V94os914r/bk9qL7ai/8AURo5X6phexhF5kH3UI9O0/+OWD+qwoFfbj9jio0xryweBy
	/8hvdWgnN06ktWvI+1S37BFV22WagmmwCIlAT9t/nVGI+X2LVMRPLyDET1jOFJYv2Kil++
	r7iodrBd2Cc6IoMz6Q1fBi3xE11k/Ws=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EVq7jMda;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 3 Mar 2026 14:47:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772578066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EKkcFIW0rZcSJrQSa7i3+w3BkUEejorX4Hk2Yq5/aOg=;
	b=EVq7jMdaPB3N4r5uSZRYVIPkomqpvsSxY2BUZ6LiuO2tjTYzIX7DuN/l9d/d9LTKNzPfw+
	AKH+o5wincI51CR5s72Vn5GloyOkWyItpVWsQuSU7ctXGKmMF8Tk4JTIG5zqAaTg4aXaW4
	2NuYaMixy112qoj2uMHs9azQ618/pLI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>, roman.gushchin@linux.dev
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <aadk2GKKMpMqvFWo@linux.dev>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <aab0AFAgAzBi4jO6@linux.dev>
 <mmlwwn5dgwzcg6svb7t6torq4py663fgqceea2t4y4ktiep2ch@qm2zw2k5njoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mmlwwn5dgwzcg6svb7t6torq4py663fgqceea2t4y4ktiep2ch@qm2zw2k5njoh>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 593488000A
X-Stat-Signature: ujtx8bmg3xjq3uqk7514jmtbyahdumzf
X-Rspam-User: 
X-HE-Tag: 1772578069-680134
X-HE-Meta: U2FsdGVkX19aLUOFUJo6XtiIc6+iJAgr9o6oG6ym81fH/9RlAb2r1vkW8qPsHws9n3zpDbh3gF4KyxvZvjP66zbTpjbgMN+ls41q18xqFyP+N0lEuHJM4vNJB66oahEewdkKRz8hQGwsqr+pyCb/nKYOmBOuomvZh844n1N7+1PhH+nghNEOBXWoJzc2gwDYRDaqOOq1PpygnJ6I5YEzQOpynjjestpVrI7iJbGCi/Q3ZrbL0HEEUTP/+Oh0CNlw8jV77KSo6bP87BNFB6Eua/MZ2hUB4QRtT3t0D7bc6e6NOQNfWGBuWXQiA2s3bS9kOIC2KuomCtxrT5kefjh4W+tkCGNJWm+JLKCScXJALaJP3kWjVrncj78cpA9XU7WUOszbNJYxPNiwogQZo3h4mOWT+LQXDTllFeC/bzIJ2oCOMO3ECSmN6S8wobIylYbTFSGZFEwgPLUGB74PG5wLsAIV18AfNHztls0sG/HyWB9Jkl4PPCtybMTge+QqeAbRg2UgRGJi8c2flZIuA7zXbzp4yiUqrTWNlCEuZhxWhq1f/Y/yY35aRDQYbKX+Pp2Gw1EVBj8uZDHSuVVZMTB5XakuOK1KfGuqEBVZfqWsi8dhDaOpqDzaIsX9J4OIiHNqmoR/f2z4kpjanFjqJuMLtVxlMwGVVgt+MGKh+J3O+DmPj0R+TZQK4FmQ8hK07oIKF+frifCwfKI93hBKE1XiXmEpjXf/UMtkhmxWpxP1JRyArznfx3Q508xbBQAaJAbRqTfpo1O2JF6eSk5hyrw3/4rLcofXxaIDBr8KyCzmZAvCvVGM7fBiZncs5ZQz6d+J+WfTk2FnO7qRVqrCy6EydsvEyZMIUJY75DJUxb+FB7y0qls5VnT7RGozcXu+lhaCg5NKObdqyTWka3B59fJ20gGo0qDKRfXoF8Q1VrY8jKHNZNrxIUp3EZOATYEO7h5w9F4ohZ7AbFA89/Odk5g
 GpLwkK6u
 Z34alm7v3s/3q6TkCHXHXzeOzssDv2K+JJCATZB9TbcY1rj5vIY9kBmBofKFpewLK9FSFJ5HWSJ11hxekgqTETY1xMr4L2/I1ynYmX0nTggDKuNQSMJNQogHknDUNGEEm3s0MiTE5gioqAOpaCL6W7CY9SBLl7vQkiVSGG7NCbfU1hunHtmXnxD8maCviLeD+vFRkXnIBecwQE+zRE7lWXLzmcTrNTtNorsYlQwQ+ngCF4ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 07:37:54PM +0000, Matt Fleming wrote:
> On Tue, Mar 03, 2026 at 06:59:04AM -0800, Shakeel Butt wrote:
> > Hi Matt,
> > 
> > Thanks for the report and one request I have is to avoid cover letter for a
> > single patch to avoid partitioning the discussion.
>  
> Noted.
> 
> > Have you tried zswap and if you see similar issues with zswap?
>  
> Yes, we've started experimenting with zswap but that's still in
> progress.
> 
> > Over the time we (kernel MM community) have implicitly decided to keep the
> > kernel oom-killer very conservative as adding more heuristics in the reclaim/oom
> > path makes the kernel more unreliable and punt the aggressiveness of oom-killing
> > to the userspace as a policy. All major Linux deployments have started using
> > userspace oom-killers like systemd-oomd, Android's LMKD, fb-oomd or some
> > internal alternatives. That provides more flexibility to define the
> > aggressiveness of oom-killing based on your business needs.
> > 
> > Though userspace oom-killers are prone to reliability issues (oom-killer getting
> > stuck in reclaim or not getting enough CPU), so we (Roman) are working on adding
> > support for BPF based oom-killer where wen think we can do oom policies more
> > reliably.
> > 
> > Anyways, I am wondering if you have tried systemd-oomd or some userspace
> > alternative. If you are interested in BPF oom-killer, we can help with that as
> > well.
> 
> oomd is also being discussed but so far we haven't experimented with it
> yet.
> 
> What's the status of BPF oom-killer: is this the latest?
> 
>   https://lore.kernel.org/all/20260127024421.494929-1-roman.gushchin@linux.dev/

Yes this is the latest and I think Roman is planning to send the next version
soon.

