Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD5ECD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59716B0005; Tue,  9 Jun 2026 09:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A206B0088; Tue,  9 Jun 2026 09:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8C86B008A; Tue,  9 Jun 2026 09:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED486B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:25:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21E431205B8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:25:04 +0000 (UTC)
X-FDA: 84860444928.13.9C55A5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D8BB8000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:25:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eT0iyD16;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGB+OvVONd6SPuLHVWBqT8ifMP+j15JEDdf0lNucBcU=;
	b=EO6UNk5wn4XxZveoqhFL9QyCwHJzOI6SxJqg0KwboxtF5JEXh24aUuX/A0dNB2B75gU4fv
	bN8sI12i5mO30aHFDBvgnLHBO3Cvh400sX676HGmh/SD603ZOyD5vBiaxcDdEZHnnDymJz
	99PpR1AoMa9pyCgnV/tLePQpWqDPVuk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011502;
	b=7KzHvt8mSRVX1nIN/PlzAx9IirrhNo8HbCSYyYINmuhQ0WAPY2W28oOSDCQIoZiTjUVLAB
	R8czESijUdMcVXvj54AYynz1WJg/FVfTmZA1PC58XHk3c2/80Zq/61XNY0koI7ueUnWx6U
	kQIheGl9sPd8+GLbRvK+BumBWIS8iZA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eT0iyD16;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80006402EB;
	Tue,  9 Jun 2026 13:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EEC1F00893;
	Tue,  9 Jun 2026 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781011501;
	bh=vGB+OvVONd6SPuLHVWBqT8ifMP+j15JEDdf0lNucBcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eT0iyD16ladRfod6LkrmqNSXjn+wr2cS9lONFb3qeVpeylpD5+UvMG1wFSCfd6Hpz
	 E1A38VRANXVUkbCc6JzSpU2qhqakL3PzaX48DfXQvLN4urFNqNdQRMIeNbylc0QyNs
	 Eiz3UD5phgEJwg4SgaTikP/DvTZPc+ZSMc5Br2T200YvKu4rHZQWxW7zd/56bzrZhl
	 l23QPapzDpZErk9jNVC/QBau+Yrg8V1PeFHMpASLqxViqQtd43TPdlFrcr443U/bB3
	 s19BwDhfbwFSd5txhCy3AZcfW1oIZUb90VZqiI6lRFOxErW7dj4eZhp6abET4LRMcm
	 WDGJSXVv3ZSmQ==
Message-ID: <6dd97825-1da7-4de4-a508-41cb023e9803@kernel.org>
Date: Tue, 9 Jun 2026 15:24:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Optimize anonymous large folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D8BB8000A
X-Rspam-User: 
X-Stat-Signature: n7ekks4rmxwc4x3ed3ndi5k8dhpxq3er
X-Rspamd-Server: rspam08
X-HE-Tag: 1781011502-30860
X-HE-Meta: U2FsdGVkX19uMwCMDcMS/c70i73QLfbweTFgeM0Ce6FX2Dv6gKlo+2oVNtadUa8ua962nr1KysrcyVdIslVAhf4mFsvHXAWm52oz6gXY31V74COqsg8GaEPduZzrecOPgONj6IYJiyS//mhCevWznczHYFcY9PwqjI5l4fVdJpfSerOBUtuQ8GxecOXuzMkJZAYnDigu2NlL0X2Ycnn4iFyebLx8ewiFdT5Des9RJHTzegZJnEa9AwDWnJDUadNyXZGwZFkInIupr9ehx7o3KmyjzSjYo/TIN86pZKY0Oi9nWM1bZIRBiJfp6WOQTX7a4r+R3YgGn1p8h3wJ4GawUFtmyotOgsSBQm6VBfOmVS2xQwI8uA5JzotIQjzbGFoU2zoTUiMmSmAIH2nCR+xIwFyyvNN4CgdiaBbbx0GXxcKSHL1l1wG9wvAS1Y3wzWIkFXuPVo+nBE5h3D/BdQSonXTgsQ/iO6AK2HuoLS3iDjogv3OlQrnyt2XqLFF+5S2Pmzh45zlyJ44OvpDdODi+mZH2opHOyM1G/a0FBkbCddJ5mrzBMwqZDgbXPxLlTHcW2taD/oay1uJDCNhYbu4GwiSkreZmU9TPa00LswOwenZJ0lze7Fg4HFDJtDwAZCJvAf8tL+RY+aFr/v6Q75HoyrP3rJUY9GYhS9nBzjXr1tUjJ2FgmT1tAirupKsthVbb6yyiRv+1hX6eQF7FwZUhcbN0FBitzH3HrzAy/IAkgfsyIQki1PyS8ISxSr736Ukxhp1yUH/WlNccyrh9Eu8K3h3BK54gcXL0ZEcwiAR0m7GwBWi+ohSQ+Ate5r6y/kHFRWiCpu4yfGCLH3FUp+WTYwDgP896AVRu1wVM+STQhvzNvZqlVxmJzpedTc+T9tUGKPsCDLo/ba4tqfDQdh3i9DVLHrigv9YIB7G1kx0LJs6woWN18IwewHDjRIR0xl6O+16mzN57KMyH/RQyH2B
 KP7H3jDu
 +GBjy3H80xzVxhAyCfLtPY/gEwqPB3T19Qc6oGiUaiywLzegcU3qKdxxAgf8oM/T+7GHiKiKxMdyfGHdP4XdiB7Xowa0hKY3th5p0cTqWkPGiSQGAOAzUpXbn1xZs2tnF1G3EU2Gw0AkVqTcbvo8U608X7EvKxJpPwCO7w0Ysv1lQlLWd9SWIYV4iqIr9kqWaPwf7047VPkUJ05QXmnr25zJA4lCnx+jZ+7OKHVkGdI77akjAyhPY4DeKPcmNDyRxx1fK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Speed up unmapping of anonymous large folios by clearing the ptes, and
> setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry at [1]) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
>  #define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
>  #include <errno.h>
> 
>  #define SIZE_MB 256
>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
> 
>  int main() {
>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      if (addr == MAP_FAILED) {
>          perror("mmap failed");
>          return 1;
>      }
> 
>      memset(addr, 0, SIZE_BYTES);
> 
>      struct timespec start, end;
>      clock_gettime(CLOCK_MONOTONIC, &start);
> 
>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>          perror("madvise(MADV_PAGEOUT) failed");
>          munmap(addr, SIZE_BYTES);
>          return 1;
>      }
> 
>      clock_gettime(CLOCK_MONOTONIC, &end);
> 
>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                         (end.tv_nsec - start.tv_nsec);
>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>             duration_ns, duration_ns / 1e6);
> 
>      munmap(addr, SIZE_BYTES);
>      return 0;
>  }
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%

-53%

> 
> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%

That's still -5.5% (with a stddev of 3%).

What happens on larger folio sizes? (e.g., 1 MiB)

-- 
Cheers,

David

