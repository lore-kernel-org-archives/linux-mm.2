Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF122E8FDD0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 07:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338596B0005; Sat, 27 Dec 2025 02:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6296B0089; Sat, 27 Dec 2025 02:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E58F6B008A; Sat, 27 Dec 2025 02:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5536B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 02:21:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F50F160F94
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:21:29 +0000 (UTC)
X-FDA: 84264405498.28.1703499
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2F3D120004
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:21:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8aUmDp2;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766820087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdljBXK0WQRDxVM+CSQlEdP8KWdGIDaFBabhEko+Jc4=;
	b=xU+KfRC9bTRV1Ytd0Hy1RRB2wtqrW/WjjeGDHmt9ijmwNEcZCoeBlKCEwPp1s0Lk2Lwrpb
	zbm/W3AjfHBMR7MXl92ZiHwmTeVA3SEtbSQDdf3BD+/FGFqTLYnF/L32YEz3M+3Ive1QsI
	/bdG1CsI35jQ/Cr1/cbQoTblXk1PrbA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8aUmDp2;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766820087; a=rsa-sha256;
	cv=none;
	b=iERN7b5PkkCuRRLQmRt3aFNN5ZApkYk34dhtq0OR7j1KK3/3+LhzcOONKaWqbqQaZ6J67k
	yKwu+l0ARB/+fQUnQe0Pc5DxIazwF5AL5/wkPPGRGNnOvAcClf3/OkbAZKM7/9Gq9ZIS+y
	YGhBJx4Mtb2tBBFDA7UVJXCgXn7m1Tg=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b9230f564so8881249a12.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766820086; x=1767424886; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qdljBXK0WQRDxVM+CSQlEdP8KWdGIDaFBabhEko+Jc4=;
        b=X8aUmDp2cP1d2COpr6In7JhTUeOsarPT9yLPO5QUDV/W6aEEqEwiX1ntO15c+2986V
         J7pZmyd537nqgsUVRYLi1vQYY36TmKCWcO2tb09hebwNXexcgenrmdnw/dZhLSmU9QwI
         plBMQboOdgKJP0JvrHscU80LSGi2FdG0z3ovu1idcLOjCI2LjipGVALjmvh7X2c0Wrg9
         j0uHzU5kS+xGl2WfuDDdfC3a4S8ZPDpfl7NH7waQzp9CC90kuTreD7apG7u5L1wzu+pR
         YldgX14z4NZ5WtS8Is+IRH3tBhVj2eLsMcwT+57V4T4rSCt1ui1FYpV/ufKM/jRcECFr
         IMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766820086; x=1767424886;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdljBXK0WQRDxVM+CSQlEdP8KWdGIDaFBabhEko+Jc4=;
        b=uSiyw+x00DQBkH79QpM2qP+g0OCVwzdO4ZaGAK9Yf2Bi5Qk5kf31J+ohTw8xFP7RAw
         /B7FIWWMn7Qcx1OkFL7aJbFMu/HtLtfb3KYGBU5Kqxt3soR3InWztzhjsb+9Hz6OJi2S
         k/8M5D12fHXGaS7ObNE+a2qDaSqdBZWQM9u3YyxEmULYf39avx34JIQmPhVbcgrMhfiE
         BfLbsBlQ0UbfHMkZtZ8o3GPtNQVXsLUX0bq9rSjTl6FyPkfBc7rkPUGY/sdUZav86vlW
         AmdtSFZrs58VzRHrwdW6O20yrxGgtgyDMzvmZSFW4Aw+OgHz7q2pbXrX1PnIx+28RJwR
         7tQA==
X-Forwarded-Encrypted: i=1; AJvYcCUxq+Epi8IphCkhuWkRVcVBs2747TJvmWDB3JoGUZ0E+zZrqLYhF7rQJKiuNdeDuBxxLzVrIpX/hw==@kvack.org
X-Gm-Message-State: AOJu0Yx6mPglsCT7QzEPW2kKzUU0kV42KcYutcVEfvpDIoGTLDQ1bvjl
	XHq8j3HETlLQrIcjlXzlJSsDKKgBhdaqDcZB68tjn8oOsX0ZtEt0VROd
X-Gm-Gg: AY/fxX5gJDToLCOGlgMAJpo+KhCOb0B+HaI2ATqwmUq9H5GZOj1015J8nMWr69nTRcu
	I5sQVxGFIgVmJh0v2zm8ZvoGYjX72M7QLmiq738C2ItQh+tAzC4lPF8hAZVq+Nw9Ldd3LFn4EdV
	ItkkLQH0Vika3XHWMIrJkn6ol027kBpmYpSaD+RpfNJ0ncFkoDNYgxVIczO2NCxtGQjD5n22M+O
	YcxoEwMUxCo3PHXa7wy8FAJb5O++23sl86aoJyTaOjXZ2KCgPXKTgRfXv6E++GbrXo69G99Pp96
	Qyycw+MJUhd70Jxl09c1IZOuVYWhO5o8xTc8kuLZQu9Qe/yJFweAwKkqC7hoMiC2hp5Gjar1Yh1
	QdrVUiEvool1yQLG/6BWsnvMtiYlX0hTl/AuNqD1xXCKdH+8RCvZhTM9WrsJGYFKpcntuvnIFem
	krBWDgeV7Fu8NTCPBGeSxwIUkbnzxcF6FSP2S6MpIuCabj7eDhBlkvmMzXVUs=
X-Google-Smtp-Source: AGHT+IHYNp/Pemijs3vjwvDpV9xEIaPe1ZCEM/ekF2ALuybxN3KU9cdrUq5MSvJHyUBYfhnNrsIu8A==
X-Received: by 2002:a05:6402:520d:b0:643:e2d:1d6c with SMTP id 4fb4d7f45d1cf-64b8ea61109mr22194001a12.4.1766820085702;
        Fri, 26 Dec 2025 23:21:25 -0800 (PST)
Received: from f (cst-prg-85-236.cust.vodafone.cz. [46.135.85.236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b90f53b21sm24924146a12.5.2025.12.26.23.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 23:21:24 -0800 (PST)
Date: Sat, 27 Dec 2025 08:21:16 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: =?utf-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, fvdl@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <fmuw35nyxafum22ni7ozhybjaarf77baqq774czok4k6y6eqqb@4oabqflx7ryz>
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2F3D120004
X-Stat-Signature: f8zettocznwaim5b18ksxj7nfc3n57rb
X-HE-Tag: 1766820087-478574
X-HE-Meta: U2FsdGVkX18GDEZHAwzZ7UUn2Yddh5/vuw6MD5ejOSIYEGMKV4M1RKz56j0r+tbQi7Vg/dDDZLVPRY/5WmEY5dXNBhlumxeCatlhQOK4dJCs/bOuoqvAqMm32bstGmFqnFzbX0Ft0I1t6/KM6X7XWRN2fIfWO3Ft+ONQViDIUw3MD6L/UuHYm6Pe4XvFobrwS+a1rtxNl3zRlmKUQ0rvyD4JGmbVChuxudRhIfUtQVg3lTRxS3RIRYYqj4Wi2CzcKwbSe8hC+vv++F8Y6f5IplVcDc+FQRKg5w2TTXaWtBtBhkffAPL6/jhFysF+SO70KwHZcKGOkT24LYj04WQApB38n5LBM+7SE6PvDoTmwTRiCjEmsLwqvEppRRZpJe+5pSQuv6IZqrTdAYRdIGffkDQGqzMPxkccXn9daZl6Q0QojyDGETwTlezM8x8BxK2bFav8ulYR5+dH7dBgNM1ituh8ZvKTeAHA+E5e8FVaTOwIg1sOVx+lmLLvHfWMKMQdsZxfMuRIMKt0TUcchHdGN1OrQy6oZEO8qZYHge/wPMLKZC3/ilwj98akTNfWCPS5YJhXvAGzkbrc9XhD3agNru1/vChhhSGwc9V7SUkFGEkRK77SoqaIzfO64cpxPuqtUWunsPnuBMTGA4bld07naIIOXfNey+VeZ73DMt2jYpza5RGQpT8sdo1DNDJ8PsmiNSPjv21OAlBv8naZ9Oqz+bZrlHHJEisKQ0gLIGqR/UdafO6Urpys+tSYw7rAgGeAXhdoVVcGQGLqtExlY1nTHSmCK3yXE9JWiUhXHYFtVYCaEvZzvmt7TBw2OhGGbTPac9OcE78vnOfjgjnmsKglA3f+Qp33PEj18K0i8xxRc85Yn26rh1r7/VUSrNQGteqPlqJrMPewUZNryod8sSeyLGVT995lRGKx750AaI3RVyit7dwo5R088FAAm7Tf+8wbfmTiDr8LbjZ+0s2WfR1
 wv4tC3i3
 F6sFnYYF+VGzIYNkI68lTW6slOZSpECLcZIKkZPOZTOdPzuoPWpceIohqqkW5TZQ0P7L2Tq7gopYtJz7uccgxYX9G99tb0TbXqmQ2UQuyztb0qFzWkiPZt0FVLlGm8aA+FSqD6BgW9DumvFVeiwWZN9MgWtHdEoaoKnStiIgPS0JJbEluzTeaRzw5GQ4jVPJ/tuMMQCS9YR2wk9paBC/k7rJMcc+oyy0vf32D5aiKRvTCGBDKygTnkzJaPLII5KcpN5tLIPcWOYegwRqXARnNe99UNXUJv9UJJnR3OUIfeZMhGOutVfXF5LqloJhk2d7/r0m0cSoJ3KMBjXMRDYYaGm5LCpq7r/TEERJpLfhcj2jkc4aEqdB5U6WY+RK9J5tQIv1dG/QWVejTkHQOR/l29mahi8OAY+cfc7MxPnA+D3Lt8O0Xfoq7f8KPafXYqKNPDPZSiipaemhqD6MyIIQh1qcI7YYqvd2wtziX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 04:20:51PM +0800, 李喆 wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").
> 
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 40
> milliseconds for a 1G page on a recent AMD-based system).
> 
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
> 
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application (such as a VM backed by these
> pages) starts. For 256 1G pages and 40ms per page, this would take
> 10 seconds, a noticeable delay.
> 
> To accelerate the above scenario, this patchset exports a per-node,
> read-write zeroable_hugepages interface for every hugepage size.
> This interface reports how many hugepages on that node can currently
> be pre-zeroed and allows user space to request that any integer number
> in the range [0, max] be zeroed in a single operation.
> 
> This mechanism offers the following advantages:
> 
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
> 
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
> 
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
> 
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
> 
> (5) The CPU consumption incurred by zeroing can be throttled and contained
> with cgroups, ensuring that the cost is not borne system-wide.
> 
> On an AMD Milan platform, each 1 GB huge-page fault is shortened by at
> least 25628 us (figure inherited from the test results cited herein[1]).
> 
> In user space, we can use system calls such as epoll and write to zero
> huge pages as they become available, and sleep when none are ready. The
> following pseudocode illustrates this approach. The pseudocode spawns
> eight threads that wait for huge pages on node 0 to become eligible for
> zeroing; whenever such pages are available, the threads clear them in
> parallel.
> 
>   static void thread_fun(void)
>   {
>   	epoll_create();
>   	epoll_ctl();
>   	while (1) {
>   		val = read("/sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroable_hugepages");
>   		if (val > 0)
>   			system("echo max > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroable_hugepages");
>   		epoll_wait();
>   	}
>   }
>   
>   static void start_pre_zero_thread(int thread_num)
>   {
>   	create_pre_zero_threads(thread_num, thread_fun)
>   }
>   
>   int main(void)
>   {
>   	start_pre_zero_thread(8);
>   }
> 

In the name of "provide tools, not policy" making userspace call the
shots is the right approach, which I advocated for in the original
thread.

I do have concerns about the specific interface as I think it is a
little too limited.

Suppose vastly different deployments with different needs. For example
one may want to keep at least n pages ready to use, RAM permitting.

At the same time it perhaps would like to balance CPU usage vs other
tasks, so for example it would control parallelism based on observed
churn rate.

So a toolset I would consider viable would need to provide an extensible
interface to future-proof it.

As for an immediate need not met with the current patchset, there is no
configurable threshold for free zeroed page count to generate a wake up.

I suspect a bunch of ioctls would be needed here.

I don't know if sysfs is viable at all for this. Worst case a device (or
a set of per-node devices) can be created with the same goal.

For illustrative purposes perhaps something like this:

I'm assuming centralized file/device. the node parameter can be dropped
otherwise.

struct hugepage_zero_req {
	int version; /* version of the struct for extensibility purposes; alternatively different versions can use differrent ioctls */
	int node; /* numa node to zero in */
	int pages; /* max pages to zero out in this call */
}

then interested threads can do:
	struct hugepage_zero_req hzr { .node = 0; pages = UINT_MAX; }
	pages = ioctl(hfd, HUGEPAGE_ZERO_PERFORM, &hzr); /* return pages zeroed */

struct hugepage_zero_configure {
	int version;
	int node; /* numa node to watch, open the device more times for other nodes */
	int minfree; /* issue a wake up if free pages drop below this value */
}

and of course:

struct hugepage_zero_query {
	int version;
	int node;
	size_t total_pages; /* all pages installed in the domain */
	size_t free_pages; /* total free pages */
	size_t free_huge_pages; /* total free huge pages */
	size_t zeroed_huge_pages; /* huge pages ready to use */
	size_t pad[MEDIUM_NUM]; /* optionally make extensible without abi breakage, version handling and ioctl renumbering? */
	.... /* whatever else useful, note it can be added later */
}

Then I would imagine a userspace daemon with arbitrary policies can be
written just fine.

Consider this pseudo-code which spawns 8 threads on domain 1 and
dispatches some number of them to zero stuff based on what it sees.

#define THREADS 8
int main(void)
{
	bind_to_domain(1);
	start_pre_zero_threads(THREADS); /* create a thread pool */
	epoll_create();
	struct hugepage_zero_configure hzc { .version = MAGIC_VERSION, .node = 1; minfree = SMALL_NUM; }
	ioctl(hfd, HUGEPAGE_ZERO_CONFIGURE, &hzc);
	hfd = open("/dev/hugepagectl", O_RDWR);
	epoll_ctl();

	for (;;) {
		epoll_wait();

		struct hugepage_zero_query hzq { .version = MAGIC_VERSION, .node = 1 };
		ioctl(hfd, HUGEPAGE_ZERO_QUERY, &hzq);
		if (hzq.free_huge_pages == 0)
			/* nothing which can be done */
			continue;
		tozero = tune_the_request(&hzq);
		/*
		 * get up to THREADS workers zeroing in parallel based on magic policy
		 */
		dispatch(tozero); 
	}
}

If one wants one daemon handling multiple domains it can use open the
file one time per domain to cover it.

