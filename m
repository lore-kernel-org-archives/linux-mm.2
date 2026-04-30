Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7B3FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0816B0005; Thu, 30 Apr 2026 05:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A84E6B008A; Thu, 30 Apr 2026 05:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE376B008C; Thu, 30 Apr 2026 05:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC386B0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:54:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E9BBC167E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:54:39 +0000 (UTC)
X-FDA: 84714762678.13.882A149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3F33A40004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:54:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k48ftvrM;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777542877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faKniwqQ+I19X36DwGl4E3Nxpm49tFX+y5NB700EScU=;
	b=fdVP8KYuu7vCOrPTdaqCHL1ppOGQFrs55PJcGkfCjJclcRXcyvuJUk64Y8TmtcKbbVtj8x
	W/9AIKtO4eVnunCaFsHXv4pnu/dy6s2Ja6GDcRxIhEOFqDWT5dPfusvo7xUTTaBLWTozOA
	htyIvKfXavERkDkn7QhivBOViCpK6Dg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777542877; a=rsa-sha256;
	cv=none;
	b=VxdY6WnR6F1jVGcN3wsO1pyC6rD0IT7b36Ov8gh+1OQxjDr7oyOGKuTnjlgP+fnRa1gQeE
	gwvD60t56IT6CmWBJi0K+3I4xZSwPfr9bKVKGL5IcKc4uTJK/Mm4G/2aFFAKqhUQechf47
	TbnQ7R29+JJEL5kPiqNKGlkogDOPE1c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k48ftvrM;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 212EB40551;
	Thu, 30 Apr 2026 09:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1739BC2BCB3;
	Thu, 30 Apr 2026 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777542876;
	bh=kcmvv0Zl7vQDtUGPG9gy11VWG9dOBfTGHblaASB3wYY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k48ftvrM8+rjMnTKWm51VnSYQ9LWvsDpQYF+Pe/a81FDALVZ0/28pe0iVbxyi4zhV
	 mV5o3WGO7DoBlVI7MUSlKHn3V7rD3lSiYHyBZk4jmJFPB+dvoPlcm7jVK3tXLX/0Kz
	 felCmXSJ9BeoCQuyaYeOfw4q8QzE5KgI2nGl3pUZZg+aZqcB9C6jNLVtcsQ+5AaXhm
	 Eohfb7kYtIOnauMHAoWbAxB/1yPYXtd5TgXAFWkqlm/Fz2L/gzxl4SxP6bCExKqLR/
	 sgTQddrJeJusVOppg+ZLjebGTRVnwECjvxTri6CT2PyQL1CMjTSYFUuAslWX6OOSRz
	 K70m8ba8YTnmw==
Message-ID: <2d815203-a81e-40b4-92ba-31832c84c20b@kernel.org>
Date: Thu, 30 Apr 2026 11:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
To: Oleg Nesterov <oleg@redhat.com>,
 "Daniel Walker (danielwa)" <danielwa@cisco.com>
Cc: "Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)"
 <dtominac@cisco.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com> <afJz3l6435DHLorn@goliath>
 <afMeAs6upm8kLCYb@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afMeAs6upm8kLCYb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F33A40004
X-Rspam-User: 
X-Stat-Signature: 6xra97hywysgfkijrz3wpb5m73tty9gq
X-HE-Tag: 1777542877-395358
X-HE-Meta: U2FsdGVkX1+PbJea11N6m54VMq3MYw4g9MUddbqKq/kvl9MrQlKfRK0Q3IQCKpHcANo651wfEf0PY5sYtyo3dGbyxVUCN+PLp/MPlVoJxyVrRH9YvVmfg5ZZxi+o4OZqTCSkBV7ulrN2mPhzbrqf0CSadeKRLMFeUfe7YnGAs1XCrQ1WJgbLO4csOmLZzASLW2fzVVfyjDMPTYN/6yUkv3YIfT7jCsFCqqpS6eqV2wyfAlviqzNEtnSi+y2HZAsWLjOlByExkjqoPKnEh6PPSouJYivq3Rxl7vHfc3xWxA2VsXw+S09wHV0Vxlx6/flvu0oNQoLcMM7sdi3EhlX+SZV808blAOqV+P0ilwv0r9Wrr6JcW8c4hLWMYCPcZxgJ0Ig0OthYhMUjPpgAkx4/dcltlG1L0fmYex31pwppIKAru0iIh/rjS/A2mywjDq3MBrd+2qk/xYa3LI9q6zR6Q3DIzz4rwxYI1ZsfSfCS1r2Ob/02Tf2ke+LYtgzPO0B6heN464Osz9/aoSSY224gkY+cD0sAr9pGWye4SwsnOGcErXK7puaI7W06qOBK1lwmcjUkP4hSbP1SmmF7YFi8eb5S7r8YrZCv3Z2y/o687gg34c5h74Vg8hnymeRxTnLKXzcL4xhmTu6wneeiVQ+r0qCUftRaksDsQKDVofwTHCahvfuqwo4mMrZNKRZ3CWPT28VWMDQPpd5dLCc4zo4q6bEuLdYI2q5fSz7N3zRJi1HdQA8hBmgAHH/ksWE9lpenLvAOmai3S0u+L+fhMVlY9G2zsHJWXYsirdHTtij49+JX10P7LaMy7UHE9HExdq2C3oaGHbaZyv0qJiil8IsFGqYa9ciur4+Jcqu/xRXKlx0r59ioIdU1rwdSfKrYzEv6/bNG6NyTPaQcGqqB0zm3EMPoEGMpSNmd5dSRz3jwaezN+HFHHC5v1NIu/BkWs7xs0EzJMZc3qxtsV1ctRmX
 zcrGx7wl
 GJs3S5rLA6Hqv6b4LS0lQEm/M1GXyTHVDYAsV42ecrqO6qgHoenIbla3CocMqei8NaglzCmECt2RssEWm6x/VsNmNRTdi4O1clxtX5cB3o1WHWW838JDMygBnWGDUNP2CsgRd+hOGcy4EK9FeAZDt2OzoGpv3Iz6vSfpVHXZEajO+05vVO/twxPe9PHv1RTYfeCQ4yjObqn2UUNLgiA/qtPKaI21JZioKZXNWynxmL5ayjlrC65fl8Wo5/IWqskQBwWTFqCbchd1JKEA5kkOEFDh18jcIJG17AR9hk2LrZLoDfKyCwSn9nu30lh/4lnAYIYok4R+43MAdreSUQX+moScOl3Hbj1DTYkLk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 11:16, Oleg Nesterov wrote:
> On 04/29, Daniel Walker (danielwa) wrote:
>>
>> Shouldn't there be some sort of compensation or notification for this, or is each person that
>> hits this suppose to just scratch their head and send a patch that's rejected?
> 
> Not sure... uprobes assumes that it owns the modified page and nobody
> can modify/unmap it, including the probed application or debugger.
> 
> But may be MADV_DONTNEED should not set zap_details.even_cows == true
> by default ?

It should. If you do mmap(MAP_PRIVATE, fd), and modify some pages, MADV_DONTNEED
must zap these pages.

There is a recurring confusion about MADV_DONTNEED.

The man page is relatively clear about the semantics ("subsequent accesses of
pages in the range will succeed, but will result in either repopulating the
memory ... or zero-fill-on-demand pages for anonymous private mappings").

But the initial sentence "Do not expect access in the near future.  (For the
time being, the application is finished with the given range, so the kernel can
free resources associated with it.)" mostly only makes sense for shared mappings.

Maybe we could emphasize that MADV_DONTNEED is not a hint but something
destructive in private mappings.

And that MADV_DONTNEED is not for memory reclaim, just like munmap() is not for
memory reclaim.

-- 
Cheers,

David

