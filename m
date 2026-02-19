Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAC1E9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7546B0005; Thu, 19 Feb 2026 12:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578356B008A; Thu, 19 Feb 2026 12:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497B26B008C; Thu, 19 Feb 2026 12:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 395036B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:09:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3BF2BA2C7
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:09:01 +0000 (UTC)
X-FDA: 84461841282.01.A8B952D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A16B14000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:08:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fgUA1bKz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520939; a=rsa-sha256;
	cv=none;
	b=138H6i53CknKYY0PXF5LX6qxIqFCyrL7Oktzj93XfWa3hH85/hP96hwxmgfQJaeyUlNSWg
	H/NleE2jFwLnOv8xJqXz4dxf8yhgaUB6MSAw0vdVz1A7CGcsR2gQWu/kQLSnzd9tA9KdN4
	f1JB8Kmk9zH15/Xt3n8xqh46+Hmd+YU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fgUA1bKz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqWa7xJlSybxdki9kKYYkx5l5hbJeVrJ9ui8j3KmRVE=;
	b=UbfydOTNOcWLnNOzeEjRtnUdkQibQyJqz0VKqBPUC+qExnkhFDlXEDieMDPDma811MjGXA
	CLxMJ+lyrAmUnZdvbEwhGHkRjAkrSDczEC/1vpRprjtvVF/76vHO/5egILXG0L6byDsb7T
	w0qEQuRCU+Tzzp+4rWy59QduOAoPAnw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771520940; x=1803056940;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kZE4/rs9/9P9AUUJMWjq0WP7sM4CyqEi+WaxO8pmhzg=;
  b=fgUA1bKzDn2+5cWeJxi7iSNhDH7YVsNwDHso2wAIFCa1wrEv16+fC8fQ
   kUJImg49/waMR1IgY3C0dW7APHunq08uWKnOxqW04mA0shcGN+WquDATW
   EyDNa7E6UaFnBKrhSLsl1f+b2nRvTfyH0O4t7T1ADxr+wRJd6jyUR4rBb
   PvYiPot75rUNg6cLjq2xsKv98u8a6VLo8EMES/AfKcLm+C7ernNS+8a6o
   HtvIzT60fcYV+lJOtjYZ23ugkPWj/328nulL2jTGOS+fL7Jmjum2Ru1ok
   fLcUrMZhEtsOhYXjff8oky311EBpgTUahN/iGloJ3/bww9Jt3RB1Su627
   A==;
X-CSE-ConnectionGUID: /qtTxYAhRlqHst5+nhqSYA==
X-CSE-MsgGUID: TZCQ+hBiRVSFvyYoaKcfAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="60188266"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="60188266"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:08:58 -0800
X-CSE-ConnectionGUID: PvKqQUNMQ3mGilM2/FTQgg==
X-CSE-MsgGUID: qHCSGaNlQ4axw+cqaFkxdA==
X-ExtLoop1: 1
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.10]) ([10.125.110.10])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:08:57 -0800
Message-ID: <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
Date: Thu, 19 Feb 2026 09:08:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9A16B14000F
X-Stat-Signature: ootdqkfnc8p31je4czgj8zyhjaxajry8
X-HE-Tag: 1771520939-627431
X-HE-Meta: U2FsdGVkX198ebap1MiKqor2GskxN7DjeH5W0zzpdjH/VYtt6CHLxJv9AOr/gjyr0FootT4xju6d0jsRFNKOu2seBVJpLVplMEa4DZ5cM/TXLzwKwYdyCTsQUu85F6qJnYs8Vn7FfBoKqAq1vLUO6Wk7bcIy237rN38lxJqtNR6EVVXlGJoK4Jrn2kkdqMgVZFWvRX603NU+YnqceU8fMnmajgNMGhnG9ZRWSscHXM4VovR9nF0gHxvu8/7TbqQh2YrxzluwYeHIRh5dgl+MesLa3D0Q3sDNZFDKzhMiACxqumIDU5H/wUMhM+itH+HmkFpVzDMLX3jmX/2ak42GsFsYzDxJis99IuMu5+YplTXMt/3MLN/RIfee5Mj20w9aY7TK4nel3uYUanQQ8UAKLzBEOsR0S3zbk+Y1iWnB79Zc+sPgX3wSX18cb9i1/bXi3HVTMiMPgnJpTwczUpAX/G5EKAMIecieukiTpglg8W8UdOipL90YQPUb6kg37uniM7ygLSkIiT+Cd3ubKSbrFWy/+AnWgKDEWSNub1hJupMUieQhk3TTbK4KEspYBgOoYl7OqdqqqoqCZk4TexH3v/y35jZ8y2uWNNZOqfgSkGJ6JEryyKNPbLhTA19YjPHzLbKBwhoM1fe+H/oIRxBblTYcMWb3IcVG1WaCiQHSrhZC4Ag6P2UCqYEOScZlK6pLWr0q1FIP7xP5d4g0Q5wq1B/DxrjSHXna13OcGotq5trthBgUVxNdNJSJXhY5AGOJ/MET8KW+sMmtDee2a61OrpGcSTpS1qZensFX7ljpuMUwM/iF2217QWJT4JcorfVd14RuqVQWynlgks5Mbcl5DZykepWRI0TrWR0OhkA18gRjViuMLs7aQNdVjGH8ajlobmGS1KpHThfdj8gckhFRxon8mUm6tUG8n/5+bEizEXZN2nCHBDpmzDR5s8I/esvaU9n95ScYMr17B1VHiQM
 fJIDHSQw
 OdESWH7/1AYr3W3FxxXcI2+YT+DP8w2iCabrHLyF2dvl2ARDjJwS91Wn/vJB9stzaAyS14bI0szBkri8Fz3ukyK4/VL1swYQh+nERFqTKShLq9MrKcQFtUSUt2vl5zAbA6FNfGiUj9LEpt54MQriOOUD4KIZB9zU1qPBWgqhL413PNYPjDit5l5eZ2fP10TksonGfm0gRHgeXfQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 07:08, Kiryl Shutsemau wrote:
>   - The order-0 page size cuts struct page overhead by a factor of 16. From
>     ~1.6% of RAM to ~0.1%;

First of all, this looks like fun. Nice work! I'm not opposed at all in
concept to cleaning up things and doing the logical separation you
described to split buddy granularity and mapping granularity. That seems
like a worthy endeavor and some of the union/#define tricks look like a
likely viable way to do it incrementally.

But I don't think there's going to be a lot of memory savings in the
end. Maybe this would bring the mem= hyperscalers back into the fold and
have them actually start using 'struct page' again for their VM memory.
Dunno.

But, let's look at my kernel directory and round the file sizes up to
4k, 16k and 64k:

find .  -printf '%s\n' | while read size; do echo	\
		$(((size + 0x0fff) & 0xfffff000))	\
		$(((size + 0x3fff) & 0xffffc000))	\
		$(((size + 0xffff) & 0xffff0000));
done

... and add them all up:

11,297,648 KB - on disk
11,297,712 KB - in a 4k page cache
12,223,488 KB - in a 16k page cache
16,623,296 KB - in a 64k page cache

So a 64k page cache eats ~5GB of extra memory for a kernel tree (well,
_my_ kernel tree). In other words, if you are looking for memory savings
on my laptop, you'll need ~300GB of RAM before 'struct page' overhead
overwhelms the page cache bloat from a single kernel tree.

The whole kernel obviously isn't in the page cache all at the same time.
The page cache across the system is also obviously different than a
kernel tree, but you get the point.

That's not to diminish how useful something like this might be,
especially for folks that are sensitive to 'struct page' overhead or
allocator performance.

But, it will mostly be getting better performance at the _cost_ of
consuming more RAM, not saving RAM.

