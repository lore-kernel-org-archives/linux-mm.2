Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934C0CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CCB6B028F; Mon,  1 Jun 2026 20:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFDA6B04E1; Mon,  1 Jun 2026 20:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5426B04E2; Mon,  1 Jun 2026 20:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5D646B04E0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:43:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43EA814080B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:43:53 +0000 (UTC)
X-FDA: 84833125146.13.0E42D75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6CC191A0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:43:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bFcb+93/";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780361031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh2n9Gu0rmNTDcj9emYz6ha4zA22fi+waHRK2Lt+xYA=;
	b=gK9xbHkLEZwxNRuKIfaJXRZMim2XunKPQS+UfoSSNAXRimtdB8Wn5+MQ8oI7Db4G+b7o/j
	6HZk4BwGQgwk4qjPsh8NnBnxCdvch3RMqf9F1hWX5fCX5rU1DKQhfbwHF9ZkqlPGp5B2eC
	JwzcI82u6W3gtVLMudsdLqv7WpN4Ilw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780361031;
	b=Ga8SmHtLZ27Y9F4tzT1BawuKlruMAmfm6ka7NhbO2wSOkIIsLQV/x4lToVU0EFH2Q00Aaw
	Jb/qXBWv//2ycuNBzDl7ZMrI2BFb3G/EGNg5qIn8ZI3rNG2BAD7CeuGU7Tq2eoqF1ARXVZ
	s5md2cCVpp9MFHAAz9bfp5mTIzoSVvA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bFcb+93/";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B7FC43405;
	Tue,  2 Jun 2026 00:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA561F00893;
	Tue,  2 Jun 2026 00:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780361030;
	bh=Rh2n9Gu0rmNTDcj9emYz6ha4zA22fi+waHRK2Lt+xYA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bFcb+93/9S95ynXbVnpuZtZBYT+X51bssv+rLmgGtRgV8B/W56LyHj9DX1uQVcj4i
	 Pd6p0tFzPEmJGOLkLwCU38i7iM7tieX6PLvShLWnLmzImiLUxjSOP+AuXGeNX+RDxQ
	 9ziqdplU8XWD78fouW0PPprxDLqIHU3nxGZ3Rhqw=
Date: Mon, 1 Jun 2026 17:43:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Chi
 Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 0/5] mm/shmem: optimize read with reduced xarray
 lookups and folio batching
Message-Id: <20260601174349.e521b96acac805ac3d9bfbbb@linux-foundation.org>
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6CC191A0003
X-Rspam-User: 
X-Stat-Signature: u8n84utjzoj3byphiia8ktz1s8hcnpk5
X-Rspamd-Server: rspam08
X-HE-Tag: 1780361031-246752
X-HE-Meta: U2FsdGVkX192vUKHW5uv9qPElqfrlf1gRtmdKrw7e9icYGHXyAYx8cbOgpLdOk9d1I65TEmL5OVlJVkEcj41o4WPmy+lFm4lUebdTwxdBYCTtdIfN1a9DyppggsDYBz3aXS2bsA14bOX35jLAWJ3ESv4jAtT5reoABqmVbE+vIwkZC6iZmNcD6FtJK6WhNmv5A28hGCV3R0VRgdshgQp6rfGREmW1hK4BSdniI309F7D1p/PGqHBdGxvh+b3i/sp+cn86f+KNAxIdwFo4FSgsFPRbwXx3VsYtdNiYH0dcBok+WxF8SszRattNY5TNbsOo6sPFq6UAUqHcB7QjVAkdl++6xpr90dRAFnofv8BaJ9hNDgZkk0FAi0KVdDrX7rh6mqZPUJNVFvEwYtY1cttSb0H1/9wneNDrRJNoOBWxxT0dLn2cxKTTGLMH9jeU/Ee+xwhXdHXL7bRCtC4hc2mzlvQNqijI5/yS2x2exEGMqkonJsmg1IAH+BPdW9lPZEeTSKTZxg9CQbBF78q1N/c4ieYVNFbyzCVby3QumPn4Mz7fxSQ965pNGQ/iwwPByC6PSon5HBCaznu6AJu6eBnZpJTTz3U8Fjtkd0Ns/00YwI/cTLBaEDb2a3xQEvce0CTP5GZeFolXS93IsvSvnwSaCiJACcxpIcDogYjFnHEeDGFYEyJr/8URqzeHba+LUiP+TFYvWJxwlvD2UoNIVobHmoOzwL35c3Ljln+tGoFKAFlOiM+V/Dxvj3MyKr+vF3A5anSlm18/VjXJAYbbHRPBnSsaAAVxihr2Zmp3Pp9ZRpCygbxD7My3y218O2xF7/McN4fbhLYWpMRMQ7y4+6ZD/SuUakhOI1B28q6z8LSfWx9IQIsLL6SdeGh1SSmsYEnyTCjHaxvv4dyzw2Bb9na9elNzorL/8cfcWtmsxG1kxnTX2tsDJjhPSM1zKYoWDAuWkCoSg6Awx7JpFcSPWn
 MwlE7o7C
 xIUJABMZdDr3b09c1zL0GZPv4RMYIX8nwVR9gGdUA5YZ5CkBy525kDsKuCyDAYbAfAIPWyYCp1PXf1xc70gtBsIzU8ojQNpGihc9r/dMKsL9hKWo4gC/P/mMDauhrS3+RnPQG+J2eo9IxsoUYpjiXJsx0cMEZQaKwMTfmU+3jb46KPOodH+dsGB2DBKg35hQ0WTEmWmC83P17d5kPZ5zlslU6hZeonV4258A1mfEUavxDrhXF0866BmgTE0QqJCBK5tJ5nx6ZKTLw/6w9GLv7dGdRSrAxMjyPKmDd0WESWGYDMqIln6bVneB2HQsJIiX3BizoI8H+K638nKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 13:56:59 +0800 Chi Zhiling <chizhiling@163.com> wrote:

> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> This series improves shmem read performance by implementing folio
> batching in the read path and reducing unnecessary xarray lookups.
> 
> Performance Results:
> 
> fio --ioengine=sync --rw=read --bs=$1 --size=1G --runtime=180 --time_based --group_reporting --name=seq_read_test --filename=testfile
> 
> | THP disabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
> | ---------------------- | ------------ | ----------------- | ----------- |
> | 1M + normal file       | bw=11.5GiB/s | bw=12.7GiB/s      | +10.4%      |
> | 64k + normal file      | bw=11.0GiB/s | bw=12.3GiB/s      | +11.8%      |
> | 4k + normal file       | bw=3826MiB/s | bw=3849MiB/s      | +0.6%       |
> | 1M + fallocated file   | bw=23.8GiB/s | bw=28.6GiB/s      | +20.2%      |
> | 64k + fallocated file  | bw=22.5GiB/s | bw=27.3GiB/s      | +21.3%      |
> | 4k + fallocated file   | bw=4655MiB/s | bw=4680MiB/s      | +0.5%       |
> | 1M + hole              | bw=24.2GiB/s | bw=28.6GiB/s      | +18.2%      |
> | 64k + hole             | bw=22.6GiB/s | bw=27.6GiB/s      | +22.1%      |
> | 4k + hole              | bw=4652MiB/s | bw=4489MiB/s      | -3.5%       |
> 
> 
> | THP enabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
> | --------------------- | ------------ | ----------------- | ----------- |
> | 1M + normal file      | bw=13.7GiB/s | bw=13.9GiB/s      | +1.4%       |
> | 64k + normal file     | bw=13.5GiB/s | bw=13.5GiB/s      | +0.0%       |
> | 4k + normal file      | bw=3833MiB/s | bw=3859MiB/s      | +0.7%       |
> | 1M + fallocated file  | bw=24.9GiB/s | bw=34.2GiB/s      | +37.3%      |
> | 64k + fallocated file | bw=23.0GiB/s | bw=31.4GiB/s      | +36.5%      |
> | 4k + fallocated file  | bw=4710MiB/s | bw=4655MiB/s      | -1.2%       |
> | 1M + hole             | bw=24.3GiB/s | bw=34.5GiB/s      | +42.0%      |
> | 64k + hole            | bw=23.5GiB/s | bw=31.1GiB/s      | +32.3%      |
> | 4k + hole             | bw=4690MiB/s | bw=4647MiB/s      | -0.9%       |
> 

That looks nice.

Microbenchmarks are useful, but are you able to help us understand how
much benefit our users might see in real-world workloads?

I'll take no action at this time - it's late in the cycle and reviewers
have yet to participate.

AI review flagged a few possible issues, so please take a look:
	https://sashiko.dev/#/patchset/20260601055704.167436-1-chizhiling@163.com

