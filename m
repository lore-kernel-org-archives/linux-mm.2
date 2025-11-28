Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995A4CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 16:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885BB6B0005; Fri, 28 Nov 2025 11:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836426B0010; Fri, 28 Nov 2025 11:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7248E6B0011; Fri, 28 Nov 2025 11:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E68B6B0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:05:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D8BDC0682
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:05:04 +0000 (UTC)
X-FDA: 84160489728.28.79DE83C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 36E6A1C001C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:05:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jj3fftO2;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764345902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSImvkgjLiiovtaVlBIP7UpbPtHd0rTo/B7dJqHzg3M=;
	b=v8HFJ5mExwZnh/9buUxHDJwD+S9D2Odb+1Jexgv4T3Y8zSV4aC+tlALZlmGbOzs/Q91P2b
	CbT9gEFESogL5xY44/6Uu5+ib4wg3+rMvism66qQt7h5EzV32t7F77GzCygIzOQygc0tBz
	8KCW22bJk+8OzBYxRwKTMEixWuTjQBI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jj3fftO2;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764345902; a=rsa-sha256;
	cv=none;
	b=5SvKkyYRWOTtCfpjLSg0L/2B7FUSnwWvspX7W6YA2GMb76v41HmR18aAawrTGtXaLBB+AD
	2WymFf/DAQRj/c6Kplxb1CgnUa7aRA7NY1UlV9g5cTgsaDGS0QRAVk+rjaYbVcfCqYyFVw
	2M0JQWbHG/bGEGt/8LG7K7bm25/TN8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E89E643E14;
	Fri, 28 Nov 2025 16:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16639C4CEFB;
	Fri, 28 Nov 2025 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764345900;
	bh=3QLK8JIJvkJT47nt6Y+wOWoVhNKf+gXbNFhrZJ+9LPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jj3fftO2wyp2Hiclw9912EhI7L+pKeuEMMKKgqihIgQWf8RZ2eK8gnhis4jlJPmTA
	 Cmx2sBivmv72A8YPRHEHpyd1GLhiqJ17jAH3cH+jUJiTLec0bioy5/TgLFwscbdNQ0
	 4MVHc8qD5xGyg4/oGrv1KUrHQi9oIiJMtPjwXTtted++ACEYpuR8uboPZbBexbWUh1
	 cTnvaAY9yBFr6WlCmfXHOmOCgmORHdt99kHGRcVCjj2Ii023yka2c4niEFEC4lFbUN
	 FDV6ISXqSUn/KQPasQuCfyyvZxZTsD/RNMFa3Ju6/tZnF+e+doUSKo+t+NXroddk7a
	 Pvv3sbc2Wj/0Q==
Message-ID: <123e0d99-ef29-4906-828a-9dfd29dafd29@kernel.org>
Date: Fri, 28 Nov 2025 17:04:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com>
 <872562fa-5dd7-4cc9-82ab-5b7c09ee8fe3@kernel.org>
 <9b6e39ae-c317-4433-8171-0927bce3acad@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <9b6e39ae-c317-4433-8171-0927bce3acad@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36E6A1C001C
X-Rspamd-Server: rspam02
X-Stat-Signature: e78enr68okx6pu3gs4nsfhwp4u4h8636
X-Rspam-User: 
X-HE-Tag: 1764345902-34961
X-HE-Meta: U2FsdGVkX187FfbZ8svaODlyfAa+nI6UJK2pleCJ7NBrDYSUf0iQkEvizHinBDy4kaNpqtYW/44NuL9JoCUa/gdZVFPtSzig07HkpsLAjhEasSBfEbNk5PHp3e5TrRmq6xzjDY5auz7UDRRVHQzSb1MNb8igg7P+iYeVHiv5QHt0/mdjJrx13919zDX006nX/R5R0j83DVt2JL39LFnFpZ1iJfuOC7M0Ss9WZ4UEEAZciuC+EHRcZUb3W8yyMLkTBcJVsZdYVV1yIgrL2J7QL2x4/DZvRdL69q2fb3kL8wROVAZL/TvSDtrkv4SZ6vb1PZn5oDS9LWmq1hLOHa8bxcEsdmt3jlaH4ZhCaDSNqlCe/5Ok0MYGNm4S9/gMY9jAkiYkh8Zdkj+siEFtWQCX+cgOuw5Zuo+DMyxThujHqn0fzPLUDSaeVHmRKiHRERC5HpDXqdMcFyw8zzNHvVVEaqVqWB//j6x4nHE5R9Z+1rc2iF4czDi+rEE7ILUeW4E3H+llaQnJSkJhtoISBAwxTtcGzshQ3PigMYwsnvLhvU+VoXRjyubZ+r4rxE2X6JFp3TzymOyOdyPkHQU6rdtIXSreeXWjy/l763S/RWU2/XtsA3dmpyJe1piBHHlppsQrZabzJZkiXRmxIvRaDRUDy205ifaSM9ORRPoWVikU6cS+O9GOwkvk3JXxd1qPK3k0IVZyVmc1wQI0/OUokE+n4tdCSPTg6MJ9x5LteWatHor2SwzXv3MzAjYx5myZELuDGbheevTTrM0FrgBFu5uDaKSWhVQXqxVSFL/jL+M6XN3Wsh9aTL9WWneTjd4ATnNsCuTfwSHRPplelNMLGKSQIOXWtaC8QG7JlWSjsuBeqQ8Pld1mhhOU0eBVa7sovV+2oTQR3fXNJ3VNO0hQd1H0kISHAc2XZ8W1pr1G6p1tD6mPkolSs4ylmCnORwTZ8wzNbuhVdPaYH3/qHRtuJNq
 7bvr/qRs
 wfeJkuL2ada40hxzMxx01uVAOSw5HecmrMzGdV7vBd9l5pjz1Iw2jKoeD3cTAqADXEZQvQpwwAMcNYI4anlTOQLD+rRCG4mJ2LGe9n9E0SYYd35w5rNdDwJZRvH8GC0qnXxQrAeDqrcc1CR40zfkoYvkFF/1JkMPGCZa2BursaMxsW7HdIGClGtgPiOJG/0fPZpwwYoDFUN0XlUpW6XKywz0sGK/b128rcl9fUD4V8dAQmt4sqLJrv4VQX72adAh7UnlwAEzjq3Nq6OmNbPbHAx1uokbY96IL70ZWH4pkI5fVLUWNihatrV1qpNfayx5O4x0GcDnJHY69H5ys7BdD5XITaT/2acMntlUQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Instead of a bool value, could the clear_zone_contiguous_for_growing
> and clear_zone_contiguous_for_shrinking return a enum value to indicate
> one of the three states: 1. DEFINITELY_CONTIGUOUS;
> 2. DEFINITELY_NOT_CONTIGUOUS; 3. UNDETERMINED_CONTIGUOUS? The
> set_zone_contiguous took the state and skip the contiguous check if
> DEFINITELY_CONTIGUOUS or DEFINITELY_NOT_CONTIGUOUS.

I had the exact same thought while writing my rely, so it's worth 
investigating.

If that helps to come up with even better+descriptive variable/function 
names, even better :)

-- 
Cheers

David

