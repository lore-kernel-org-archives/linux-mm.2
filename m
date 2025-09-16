Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750ECCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7938E0002; Tue, 16 Sep 2025 08:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8DD8E0001; Tue, 16 Sep 2025 08:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE808E0002; Tue, 16 Sep 2025 08:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96EE08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:14:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0EF56500
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:14:55 +0000 (UTC)
X-FDA: 83895007350.28.BA54935
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 276D91C0007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:14:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TfMltC9P;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758024893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68fTgxGOkDPgE/dxuPBgdULhxh+AErlys1SpQIpQJ3g=;
	b=R3AqNkBsccI/EFhwRBfmhbXTd3olDiKlGz7SuCUXv9VnbiF4RpDefaRcD2ZJSN4wn2xSkd
	vLyqKMEpEZrNye4jaANn0eC3nq+gk8hsDRejfvVBoMW0izRLygunW4lMNMF0VjHKC8NybA
	/3YK8GkcQ2UFLarTXqy1mNeqPMcNSE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TfMltC9P;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758024893; a=rsa-sha256;
	cv=none;
	b=Kf/EqjCcfTrP2L/HHYsDALqYLAx0kYebif9t1T0xX7P6FNvnCP3eVrX9AGqGNjwVgbZ9I1
	m/sBR/2tfHuXgHZqX6WzZDlgQSdWEaUq7nsxPOcoY6T1xymSZs0ICYH+sPRJTDiWkhT2SZ
	JtZ41Pb8pFtLrxFLHdeZeJSkz3AtB8Q=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ec4d6ba0c7so815515f8f.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758024891; x=1758629691; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=68fTgxGOkDPgE/dxuPBgdULhxh+AErlys1SpQIpQJ3g=;
        b=TfMltC9PMfxoke4dnsakpBccaklIBfZwy72Hs545UHM0Ocq3TzFGQBVSCQj9Sn/t0s
         RSMCeL7ztlT5Zvdgn2nSyVDsTnK/Zw0Ne7dU3q3JAP5GEKv+DK0lMw5VPupKkxJ9dI3d
         +4psl5oIAx4odKPrfBVdJ1U4oL8DGUPpGMT8T90URkq9Oqo7vcMrVuCzjaK6wjE0TkpM
         jE5v9RgVQIKhA2E34tiPBQnzFO+0Dln9Kvg87RQ2hK5r7EXsWG7x2QmmhVGhsb8Mnn1L
         dYNYR403Hp0dCwT1neIB+Iy9SkZ0DEYuX11W+G874IasPRkZkfBo2z1czX49l015i/yw
         +5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758024891; x=1758629691;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68fTgxGOkDPgE/dxuPBgdULhxh+AErlys1SpQIpQJ3g=;
        b=ZJdMr+H+NdHgua9D2CSUHtebKqeeKE9na9RJE9efDQZ1Czo41/4Mx8vyk9OYcRb9G9
         cf4GfxN0Cr+RV+h3LWumJNMCzG0YtOxTTEw3CArti9+UN9LMB6PbO7/tKI38LcEpk+g2
         Id0LJt9+0BdUTbTc0Ejpl/Tkxuh/MkmPc1Q1cK5iwS+/KquOezDA07i99TyCphRToAPy
         E5JZYkBH0mJeSu41WcN0/bw2hV+8QHb8mRfBmkteexgCG2swf2PaxSnhYMGaVREfLGFt
         9y5PDI/ngEWFkiGwUex93B0FmmpHAiQEz3fth4QVsF0jen52/cLCwuQxWl2pEDy+sENP
         gbHA==
X-Forwarded-Encrypted: i=1; AJvYcCXLrZN/XzE/+anyfItAAUn/GP9N9BQk8NGPGZ4iuCcgcEL0EpQB5xtFO7cqRVW749r+6uxtjrn3ZA==@kvack.org
X-Gm-Message-State: AOJu0YyjTpNIY7AlBQQ8EhPqnxUgL8iZQnGzv9yXGaJ+XtDCPy9/iUw0
	l3C9brgqafZd9hI6NDcY5g4Q0myilfXVbFKTt8yVUGlhc5nr0gXBRoQA5V09yw5Vs70=
X-Gm-Gg: ASbGncvGXATluGKCQkPjKJGdzxerGQibhDIwXfacuBksgLhcvVYctAqWo73/xYuSS7r
	hKgym51SEhjGZk47FF6KBGx0XtaBwMOJHzjQo6LL27rQotwCjUZE68d0r07P6J1gXgkQVyaPeEN
	4819BxKkjX7xr5S+zijeDxAYPrFsmsFm+TTn1hGVTBFtEIOs1PMBkIZKVnuA6ZA9Woh9w8M3QJi
	gf8aWy/Cf90xkgvcF/wwbI+/epQ7neDdnc4Q8zkLA7sh3m809kdswGwFifH8MVh5QcoNfrfKnQi
	aYdy15ukgEHz94g0SHQSi3QQIoR7a5CGFYZhptztphVOrG+u1aKvIQJtBxVc7dEQEaJsUVfclFO
	r5F9n64e1YHVEjAg+HUXZ0EmneEi8zQ==
X-Google-Smtp-Source: AGHT+IHYkVIY2ZUL66SYOAEdIjUILilWh/J2qbDUZHNmGmKTBXIdsJxRt1O2yTUKDaFB4LxgnlXS+A==
X-Received: by 2002:a05:6000:248a:b0:3ea:ad2c:c159 with SMTP id ffacd0b85a97d-3eaad2cc59amr6403979f8f.51.1758024891243;
        Tue, 16 Sep 2025 05:14:51 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f2cf19c68sm101830935e9.14.2025.09.16.05.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 05:14:50 -0700 (PDT)
Message-ID: <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
Date: Tue, 16 Sep 2025 15:14:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
To: Matthew Wilcox <willy@infradead.org>
Cc: Amit Shah <amit@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Aneesh Kumar
 <AneeshKumar.KizhakeVeetil@arm.com>, Christoph Lameter <cl@linux.com>,
 Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Kirill Shutemov <k.shutemov@gmail.com>, Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org,
 David Rientjes <rientjes@google.com>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
 <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
 <aMlS9Kb6_x3fqsLG@casper.infradead.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aMlS9Kb6_x3fqsLG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 276D91C0007
X-Rspamd-Server: rspam05
X-Stat-Signature: 6f9bghtqwjb4guae1kps6m14xdm4nkxr
X-Rspam-User: 
X-HE-Tag: 1758024892-611687
X-HE-Meta: U2FsdGVkX19gvwCiCKJoTxnG9BsdBNJamhpASixOTtSvTAGqLBKWAuNqHb9E1crYtu/z3Wqf19R/L1hnoSWeQ2tbIkq+B2H4Xz1omzD+6z3gPFRGcJ6ykRM6AHtm8kTGo2dqEiReYA27sIRgh0AMbCAUOxSs/AEFgbI917vQFw+Sgop1xnFlb55vMHiIQk9j+6q6TuhTpQaszKmAWcHgDFDdECkn4Bl32ii7J8/AgyZvQpv3INOAOC7IFClsFfPinnUG1LD5vDFLxfS58WO3s+Sgk9BiiRI3YybUTNcmRVpU46Y3ilZV4MsXbGiL1cOteoXnhrqfm4/5aSDcelWfcT+VuGIa2okwtyOXj9YSzsh4pxDuhHfcKpB5e3szWGAklfB0h+TNDWOkAmorSpoii/S2ZNkkIv/4i8iOeNkuGwcv6/9mYK+aFklxfR0haCMH2LBHv+5LzZJddcMzaMPH/KpX5dtS+YH+d9Cb22PM9ACOc9sl3websvsyBhiBYXgOyYxAx+QIntcZJju5d2gP+bZgVsh75VuQPdQB5+YRuDao+8/xUVODuGY5ZhAcD/Qe9m/3gLFWeKD0+s03YkBwia12Z+PX+amc3GzOcbH6JGra7Sa/kxsSSFwsjajL+dWiQH7w86Mmvw1UivYn5UZYNpxFuCBcS7OOK7/2ch0FrlCUDxaLQH0otsAKp7OUb3KqDFwu66CHf/KM8+b8TZHpiclozAv2D3yw/k6v8LT/WNxC8lFEYyQ3e5AeVDxn4AZRt+748+HB5maSFNH3BbqvoGdt3PJcat6BMGJCF3ESr5DzvY4rksEuhggHca6N3Ey3gOjt+uSfwu0k3Y6aH69RBo3d0g8oCxY7rAI/E1S+thGPMJeG3QIpUPq7u4+02UvhzPAFwvAckJEugv5w72fIFTWJJTCXqLKret6O4iguTco7OJ6PTkfcb5AkI0lGG8mDzpih90YCMjFBYXWQzxx
 AipsBQRn
 +L2/Kew5JRzTw0qMWGv+rutdnSVMu5qU/FfgT3jDKF0swGh8D8V+k6MTak7LTnNZ/KTiB8Q4Q/jTSlrg+ESP3YPb397ZdLuYRzB7JQRS8BRFHq2VZgUtmDDTtsrPP2GZhW/z5I0odQUOL94tvShEumx6d7zQiJ5IfDq1C5vsogwqRP7n3B77RIKiDLQDIHP9GG8sPdvITpI/qY7prwZza6iLFuPdDHjMeexz6q+C3FstVaPQHTym+Rce5+S+p0+DPtV+btQN0wlFti97b9f/wrm1FxE5BLgxhKkBW/JShmVDkta97VcPGPB9XoMC6tfPBQhSfcG48CmqNh49AMY+9Oc2V0UUTLlkw3AXULeUfVHM88b09sKdMWt5XcVU1ZraCR8v3Vbicvp45cKR0hNAsUREh/4y/rGiRlYR98TO11kCrcxczvsVb/pYBQeITXXhKMD1KnUayEA+br1Mg/YYEOeMwUPgXPlOIYq7vhc0eIlQdEfs6EhUbimV5toOzXu8K0HJGv5PL+Ye/pU9YbS87RR/zHyjqWjDrH/vtuI4yTxpIhiUGBrcDUWnHFjiLbhGmoXdRocPhUN1+tn7V5pDWZjTJ2p2ywuMrABlsrYfIcQNIIxQfbj9N/yIeSpDByOcdKY8TLeimqNqi52vIeaILzGhp6SnPWodXReZ/s6hjZb79f6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/25 15:07, Matthew Wilcox wrote:
> On Tue, Sep 16, 2025 at 11:49:35AM +0300, Eugen Hristev wrote:
>> On 9/15/25 21:53, Matthew Wilcox wrote:
>>> On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
>>>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
>>>> proposal at https://lwn.net/Articles/1031319/.
>>>
>>> I don't understand what this has to do with mm, to be honest.
>>> It looks like a debugging aid.
>>
>> It was suggested to move it to mm/ :
>>
>> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/
> 
> I feel like you should be able to explain this rather better than
> "somebody else told me to move it".  As of this moment, I still don't
> know what kmemdump even is.
> 
>>>
>>> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
>>>
>>> is a great example of how to write a lot of documentation that doesn't
>>> actually tell the reader what anything is.
>>>
>>>
>>
>> Here is a link to the v3 where I changed it a little bit :
>>
>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
>>
>> I am eager to improve the documentation to make more sense out of it, I
>> am happy with suggestions.
> 
> Start by telling me what it is.

A way to select memory areas from the kernel that can be used to debug
the kernel, instead of saving the whole memory dump which is mostly not
of interest and takes a lot of space.
Anyone can register a pointer and a size, these are placed into a list,
and a dedicated firmware can parse it and save it in case of a crash.
Does this make sense ?


