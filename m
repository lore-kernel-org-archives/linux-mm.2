Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7E7EB362F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 17:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96776B00A7; Tue,  3 Mar 2026 12:51:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43E86B00A8; Tue,  3 Mar 2026 12:51:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25776B00A9; Tue,  3 Mar 2026 12:51:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0FCF6B00A7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:51:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C96D160207
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:51:46 +0000 (UTC)
X-FDA: 84505494612.04.543E5B2
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EAD5C0009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:51:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzVutgI8;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772560304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL6WbRDTWPclsvE0UMM34YVtaLXqlF6tBavQfG2bQhc=;
	b=z8Mvc4xULQ3CLJ0zdnd2Fh2QY8Gv1k/ZJ8pgTBYAlxUHWsdbLdJR7PkJwE5h4FP19uMqa4
	eTkoyvVXCDKq8wc/eQBHEez8GktyOIlF3UcogSmoJV3XaMF0eRm4rA2+OH/gtBPtozu1oH
	PdWj5rRZpG8/gZxWWqOl/SZJ1ObutGw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzVutgI8;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772560304; a=rsa-sha256;
	cv=none;
	b=u7ziekZVSH+xl+yewUHhkb91MKvDmAioO4/CFJZb/hoSuzlbUqEfnPTk4z/+CDNQyn0akg
	P1yei0KfjUPeNgspMSVb6eP3nm6EHRVuy1TWQUvNBk2teD5KY5f0vc8Cuy+cKGQwUIMi6n
	iTZT26nURkq04GdNxL5M8nxgJHNtOxM=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-46394090d2fso2175391b6e.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772560303; x=1773165103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL6WbRDTWPclsvE0UMM34YVtaLXqlF6tBavQfG2bQhc=;
        b=CzVutgI8qZcTStoVbJjusOSzO4hLR8WcuXLHrMF9zvl8jWVhJHhKmf7+jUgV8QfHKi
         o/KjBxeGV5Xe/x3fwfnNafKYqI/AgejCc4gKAktkNVKPzb2BipvDEctuojwcmPkzwFGI
         q9SH90Y8zs7PIP3bHEO1A4gs73b9GnXmR5or4Z0Q4zGPckgeeqWwXD8OK8lY2WFpuIUK
         Ccj+H+Cl5d03GQsBz/7EoMuv6SdUQBPq1BMh24KwCtwkc0kZ6Ue/ip8/uLPzTzw+jzq4
         lg2pUgpj/ccNeOqwXmdG5Ww0wHDeMr5RElRAU6MyxmlLMVPNwcEiP4MC3bipo+W7FpJF
         9Vyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772560303; x=1773165103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fL6WbRDTWPclsvE0UMM34YVtaLXqlF6tBavQfG2bQhc=;
        b=hP2CEq+cv932+sI7l2ncpgbxD0DXv2+sVUREbIGzBfpvLeuNNtLlAS+pBRNEEogLVa
         6KXCPOZlwT6rdifu59O04q3x40di0znyuU8+8QTuCriw3u50YrWkhvTKZnKYMI7sc4Q6
         +0/rvIATKWOX1X7+VyGYf6woGcprV+aDiSLKy3KegTpKyudZ+rsOjuKF7MRmKBcqlEwX
         rOackuol046qMPIqBoBhvS8vOanb7aFgJgtrphqbxSyWxZT2HcjR+8csPanbGRpBXHKy
         F9+svTTMDqtUEQfB3OGMU3lGCxgtJ6bydrUMv1/yYLhKvhir9c3vx1lPxM71uKcX/MHu
         xtWw==
X-Forwarded-Encrypted: i=1; AJvYcCXLrbMeEV+FtHXBu6Zw3zLit1uU+oy8e5oGmyU+YDkYmNz6XKd7CXQqGYyoZJl/w6DfrA9OE7lH2g==@kvack.org
X-Gm-Message-State: AOJu0YwW+1+lUIS/wUFExlR8VDb8SVJ8NmEDBED2eJpGLRyiGdW+O/zy
	6db6O/W+tO6j/Rhx77LD5udxw1IyREPIWhtA1UWIykHxZUtuK012RsOV
X-Gm-Gg: ATEYQzwmIWAEamJHdrnveSWpE+hzwDqu99TyOZywlsQiqvNk+ge8FBAwishXxF9DHkn
	MnFDaDSQvU1WnDmc2UVBV7rlBZRLuJeA31+RnDk29VgGkBhw8PE5kA28wj5xpTDipouBY7/LMUz
	gwWh83u8cTAwPHeb+Cag3hUp1YEUl9GKZo26iITAtJmMr5B4pxQY1xJg5npx8DH4CxbY7XdPNDO
	RJOP9yZ88yd/EWtXVFT90s7Fi1VBYG2dBL5xzKWn6VWK7JCMPoj67gbvib8qgSxw4De8a6YN7J+
	jSxP5R8SZzsvSj28cI+XviThMVHjKkEiOvt4wuPxCKt1lSmQjmNEmN2ewTIxIyYt0j8UBgvx3jX
	NA3rU+zdwNEOa5KrNW+w3VeLd5AnldO3yacJGsLM8NdIEYUwcIEhD2OIybnWEJv0MdZMjc6yxnP
	vQP+d/T9R8KGsqVWIkw5C0iw==
X-Received: by 2002:a05:6808:4f08:b0:450:4782:2b0e with SMTP id 5614622812f47-464beca70e5mr9277735b6e.15.1772560303135;
        Tue, 03 Mar 2026 09:51:43 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:44::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586474d4csm15115726a34.9.2026.03.03.09.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 09:51:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
Date: Tue,  3 Mar 2026 09:51:38 -0800
Message-ID: <20260303175140.1032459-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKEwX=N-yzg66Ge5YgDNG7nh3ues62fSjmi6oGq1B=gkz6e2Uw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EAD5C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: tsno1k84a15kftqm6eabfsyyp67yzj53
X-Rspam-User: 
X-HE-Tag: 1772560304-852195
X-HE-Meta: U2FsdGVkX18A5w8PFl1q/hF0krpNEtYwuv8SZlJVwZb2u9VTpDEmP4I5Jogy2X5qbs8HUzH+k82gLr1BoutwDtVYvMmWNCviBajk7nmAN/Ft7iftR/Zx3JeKEL0P6fQB9YiWRCJzA8CVQAqL7+f30E+DIUI2iLfcboVe0P8xCqefkj9j/FtbXr5OFSFyEQqDh1ngprcuJdOFvjpVBNnDwCD4kRmgPsrN1anl8M2qNtTkhh1x3zyWqIGrIk+mgBxDbIOAwUxGnYrGnQJ8ll3e8bxECOM2Afs3LYzcZ6LsvZ/8n73cb8ge2axoRmPoelDG66+ldrNnbH8XkOtbe0mVN+Ko9aNTLH6RPf+USLOYS0r3Y4KwF4fk/Jf9nJXVbqI7lmORtnkaUI+RxukIzX2Ov+37JI8QlYlRtJ6HEiEXmgqU45OWCYV1Enct1P6n/JezDfd/8GyyHa6CCfybRRIk4bsYJrmzbYMXTI+0f0kh06ealvsoASW48SR7/C/X2wihfoJ9wH1ZMbXjqUST9V20IYtoKqgWAWYg8h+h5ibs9Mp5OV+Mrge504UzClisOsI5+KE33S3q5uZTYS1W6OtP4LB/oFEUzNgOFEtZl/hR5znBov8mb3IbbC8GNbR9D0LQEpv6u1MC0Pdo4k0nhdM5osrOx4XDJUgmxNAAcrE0RpOFxAOTccS2EDvVx0HZBGp7hPpffTZ2Xm5PXXQvLWyFz39x9bS0cbRVTIW8EvDHdIbXR7iLcioAmGlgLg6WnnnQ00Kl+fXl2WAAnYUTUMyeoYbo+fNyUe1PfFR9rsT0JLYDxiwK1Qo75fZI31je7hEOdnrw8MtyYzo65t0jtr1v59bj77E/J0/QdwlHJVPXTuhRPScC4FB2fiohg+ba8YcYSVgV44CG2W2KJXWtbDEc2TiBZiVJFr36o3AzXjHkmnmrXJ/7lCVwStYsqPOpkX+7NraFz6QWk3FmtgKtM/l
 AJMFKYc3
 AU7oHXt+lvnlfSXmQcTfWVnGcqfyxWPrauM3S4eNkVJYr6cCfWMKkJVEmEL8xMv+liHaa97cAb4hoQsudf9LLYKNsX0PYvpa+RANGUQpFnIpEyvROO8xLaBV0Ko1JYEYafDKg8qgv8SL4LQU1UPrzSnDm4ZagtJMbTUoXkLjUcgCbcz7QAPZyoO0hFIPwy8WjOTzPg6Klugjm6fhqPWEOyxQuaA58j9Daj0k+MJOlD++o4nGBP7anbx3/bYY4xwhcT9xjMKzidZjaEmoxkNJjbYAJYNLpnK16EgtO+s5p7YiRZWuedFOl704gERBAKCYp+f9TETwT/3ui0Cup+Gh4I5UWFvVekq1SE/i9m9H8eDAm14sxzhOpzd9WJJBQOUuWxuuWws7+/h/ifWZ4mhFuMeUvP8CfBeq12sHIQ9NCoi8zazIa40JRC8UW/x5WfYSw0A2EvENPpMRt9Iig2J44YtXE/7P4s1IMpqbRTgCcqvR3NQQk6wfHasd1A8o30GRdM9gSpk04OEXfzx+K8vqg/euLcpZPot1kC3Hj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Mar 2026 13:31:32 -0800 Nhat Pham <nphamcs@gmail.com> wrote:

> On Thu, Feb 26, 2026 at 11:29 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

[...snip...]

> > Introduce a new per-zpdesc array of objcg pointers to track
> > per-memcg-lruvec memory usage by zswap, while leaving zram users
> > unaffected.

[...snip...]

Hi Nhat! I hope you are doing well : -) Thank you for taking a look!

> I might have missed it and this might be in one of the latter patches,
> but could also add some quick and dirty benchmark for zswap to ensure
> there's no or minimal performance implications? IIUC there is a small
> amount of extra overhead in certain steps, because we have to go
> through zsmalloc to query objcg. Usemem or kernel build should suffice
> IMHO.

Yup, this was one of my concerns too. I tried to do a somewhat comprehensive
analysis below, hopefully this can show a good picture of what's happening.
Spoilers: there doesn't seem to be any significant regressions (< 1%)
and any regressions are within a small fraction of the standard deviation.

One thing that I have noticed is that there is a tangible reduction in
standard deviation for some of these benchmarks. I can't exactly pinpoint
why this is happening, but I'll take it as a win :p

> To be clear, I don't anticipate any observable performance change, but
> it's a good sanity check :) Besides, can't be too careful with stress
> testing stuff :P

For sure. I should have done these and included it in the original RFC,
but I think I might have been too eager to get the RFC out : -)
Will include in the second version of the series!

All the experiments below are done on a 2-NUMA system. The data is quite
compressible, which I think makes sense for measuring the overhead of accounting.

Benchmark 1
Allocating 2G memory to one node with 1G memory.high. Average across 10 trials
+-------------------------+---------+----------+
|                         | average |  stddev  |
+-------------------------+---------+----------+
| Baseline (11439c4635ed) | 8887.82 | 362.40   |
| Baseline + Series       | 8944.16 | 356.45   |
+-------------------------+---------+----------+
| Delta                   | +0.634% | -1.642%  |
+-------------------------+---------+----------+

Benchmark 2
Allocating 2G memory to one node with 1G memory.high, churn 5x through the
memory. Average across 5 trials.
+-------------------------+----------+----------+
|                         | average  |  stddev  |
+-------------------------+----------+----------+
| Baseline (11439c4635ed) | 31152.96 | 166.23   |
| Baseline + Series       | 31355.28 | 64.86    |
+-------------------------+----------+----------+
| Delta                   | +0.649%  | -60.981% |
+-------------------------+----------+----------+

Benchmark 3
Allocating 2G memory to one node with 1G memory.high, split across 2 nodes.
Average across 5 trials.
+-------------------------+---------+----------+
|            a            | average |  stddev  |
+-------------------------+---------+----------+
| Baseline (11439c4635ed) | 16101.6 | 174.18   |
| Baseline + Series       | 16022.4 | 117.17   |
+-------------------------+---------+----------+
| Delta                   | -0.492% | -32.731% |
+-------------------------+---------+----------+

Benchmark 4
Reading stat files 10000 times under memory pressure

memory.stat
+-------------------------+---------+----------+
|                         | average |  stddev  |
+-------------------------+---------+----------+
| Baseline (11439c4635ed) | 24524.4 | 501.7    |
| Baseline + Series       | 24807.2 | 444.53   |
+-------------------------+---------+---------+
| Delta                   | 1.153%  | -11.395% |
+-------------------------+---------+----------+

memory.numa_stat
+-------------------------+---------+---------+
|                         | average | stddev  |
+-------------------------+---------+---------+
| Baseline (11439c4635ed) | 24807.2 | 444.53  |
| Baseline + Series       | 23837.6 | 521.68  |
+-------------------------+---------+---------+
| Delta                   | -3.905% | 17.355% |
+-------------------------+---------+---------+

proc/vmstat
+-------------------------+---------+----------+
|                         | average |  stddev  |
+-------------------------+---------+----------+
| Baseline (11439c4635ed) | 24793.6 | 285.26   |
| Baseline + Series       | 23815.6 | 553.44   |
+-------------------------+---------+---------+
| Delta                   | -3.945% | +94.012% |
+-------------------------+---------+----------+

^^^ Some big increase in standard deviation here, although there is some
decrease in the average time. Probably the most notable change that I've seen
from this patch.

node0/vmstat
+-------------------------+---------+----------+
|            a            | average |  stddev  |
+-------------------------+---------+----------+
| Baseline (11439c4635ed) | 24541.4 | 281.41   |
| Baseline + Series       | 24479   | 241.29   |
+-------------------------+---------+---------+
| Delta                   | -0.254% | -14.257% |
+-------------------------+---------+----------+

Lots of testing results, I think mostly negligible in terms of average, but
some non-negligible changes in standard deviation going in both directions.
I don't see anything too concerning off the top of my head, but for the
next version I'll try to do some more testing across different machines
as well (I don't have any machines with > 2 nodes, but maybe I can do
some tests on QEMU just to sanity check)

Thanks again, Nhat. Have a great day!
Joshua

