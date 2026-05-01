Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B958BCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77626B0005; Fri,  1 May 2026 12:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27F06B008A; Fri,  1 May 2026 12:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DB76B008C; Fri,  1 May 2026 12:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A72196B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:44:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EC31C010B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:44:17 +0000 (UTC)
X-FDA: 84719423754.29.071482F
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D7B61A0016
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:44:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dRU1Pqg6;
	spf=pass (imf19.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.50 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777653855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=258tSgDmQvsBwqYiudf3HzA2YcVV3/7qcjtUVSy9L94=;
	b=67oDEydvV4X/QBOj6G7bvpWnVgHLIHtB5ZqllBrixGfHvXUj/0+ZCJR0ufKPf2nKdGsvFB
	NrC5pSesrTrjCVKGw5aIGtNIMkTglJYyXq2plRZSn5f4iZmieBXXQRfM1wDlz5GVlAYad7
	4byMJcI0V8fhc5UGa0GLu/34CwS6f/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777653855; a=rsa-sha256;
	cv=none;
	b=v2fA0S5rTw+5VKsA82AZQSgWpjA1J3bSN5LnTRqPTnuTfGYo6amUj+8GvmnGy+3GOm9L4M
	KoNB5FEO0neLfF8ojEBwm3W+ofru69qrJp+lmxkCv8KazqV4nPFxpRnQpi2D4PFuBvJcGQ
	xhBkCSY/7H3N2JMFhButE2D93HCeMmk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dRU1Pqg6;
	spf=pass (imf19.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.50 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dea20cf21aso2020629a34.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 09:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777653854; x=1778258654; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=258tSgDmQvsBwqYiudf3HzA2YcVV3/7qcjtUVSy9L94=;
        b=dRU1Pqg6MSLOQUuldrRxOvIhd/8ULv7cUPE9xDybV9fQB13V+3NHQYGukWfjVPeU65
         0WTyzY9FzeSE4N4fjdkWFqWXrUJ701KUSaBI0irShzuJaWwtkGt7DSA3/xb6Hwo8uv8C
         GF8q0LHp/knVNAbZIn5o8rVVwqRxkQjSqF+nNdwmWGRLrSxys1lh5uZd1sRJTKq+aks5
         h1soNb7j2XkQjMLGUwk+kzTFUevV6zaZXRMaOlxYoGo730lWt4E3ENxv+qw/51iZJPa4
         VatVhdYk0LCMgGzbsOeHTCJ3qE9jHXlXjGhE707kczy3TgfUbHkrtUjuAJjSbUTayLBL
         8m8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777653854; x=1778258654;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=258tSgDmQvsBwqYiudf3HzA2YcVV3/7qcjtUVSy9L94=;
        b=UOrfGtcIFa4kBM2FQzSZEgRPAN5DJnPfYQ468inJSKGyMDMAf2BcIIgb8rJedtPyb2
         s6+d7DVu7DH+ofRyY8315wXa2x8U7f4amm/yo/GNJfUaIOIJxjCbwW2CwygC2HLoW1NS
         wQ04GAlRW6Qo2vNs/4LjnTdnLbKwgL1W3tXgJV5klOmYPn8VbLALfynn4nZ5Vi7iof/1
         Rxqf8lWhfIYrDxGL8vqHM79rYEcBC9q7m3bXVuHNxkL4tVzMXTkzDzRqFe5/xoMbH82y
         nXMmN186gxU7C2T6E1UR+9a87OSZEcPqDNyZYLad40CY5jCeecPX1VnPwji6kEv8vptb
         tUDw==
X-Forwarded-Encrypted: i=1; AFNElJ+/rHY9UfdLym1h4x7SSvVxxoLrWJRpK7rVG8B06Ke/0SzD7h59TsFxyucxIIU+nd+S9W4/gSN+OQ==@kvack.org
X-Gm-Message-State: AOJu0YylJm06iwVk5vf8tvWodT71fQjXcChh0yI3TEBDf6Yt3N5jplOm
	NmCo+3UEoIIPBG5LHXH35CaXp1Iorfz7BTHakDhb+uJyBLws00QgX83YuLXSQlQtngY=
X-Gm-Gg: AeBDieuMLVG7cJjJbK7x7ekI837/FAmsmv8mbe95KhX/79zAasSaam4w+lUG2oMPlR5
	3Lphc7AQNL7dNM+51vyIby186Ggf5b/Czm2xII9libvHPvB/JlVdSmTdazwSSIwgPja+G9iAORi
	NaaHd2VMlEhHZT3JUOjN2filMb7n6l6eOhs0ucMyD8RbSxRIDwbakOF8PW5kvFy5q+k109r15EW
	1EaNOuPJCRt9+iq3Vjuk6lCASotF7jVyGZRRZwLZNeUNiI39QqClPtgSOOtxNuZfzQq1XboXtcE
	8vGI9emZ5D4KFFLvlyNzGz1+jFkBmCrU6GvSo7s/cwa7ChrlpQUlF3JYOheTjZlPVSyzFbpBrlN
	oDFuW//ha9Up1/TZbX0LOH6JmR+7XMgIT9zUdrp7xX53WF2ItAjkzp680vIYkMua+gRXfxSr+FF
	7Ek8sgqXY5+N4qGaTdQIplmZKp0+Ug+V9ARK15v5qIe9Js3ojjpcemNgFUTK24+/S+KLfch6rXc
	qBkmHO6+oJsLDBdnyw=
X-Received: by 2002:a05:6820:a04:b0:694:8c67:5cb6 with SMTP id 006d021491bc7-6967a5dbd54mr3873019eaf.41.1777653853660;
        Fri, 01 May 2026 09:44:13 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43454d8ed0dsm2836466fac.17.2026.05.01.09.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 09:44:13 -0700 (PDT)
Message-ID: <ec07180c-665a-4e78-94a4-1670a8bf8efd@kernel.dk>
Date: Fri, 1 May 2026 10:44:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with
 targeted dirty tracking
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Snitzer <snitzer@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>,
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-mm@kvack.org
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
 <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D7B61A0016
X-Stat-Signature: oqpmrxzee3ntd1ykkpqifkcz5sgc9zfw
X-Rspam-User: 
X-HE-Tag: 1777653854-294738
X-HE-Meta: U2FsdGVkX18BR1lOPBF8HLdOiRu27rCJWzTX3733eEdiQKnPkLRcplTWPCfItzHpjcTvCI+Tt/9e1dvDXVlvlEAOIhbAttX+Gr5rApFoJcfmqqqn2uVThpsNpjXvNh80Lf4pFLXZHx7nQtlOnK6r84DBsbzNsGI2ki2zkd0dnpgeJ4zQmOBNzywylHG+QvG6fraXnTkJSJbcCuYVkJcI6dORrbt5xOztXw4hCGp6TijV/WaGCGaywXU525DlNqKLT8/Gy0g4elCZXcfsuOEgUYDrnwwC+CTtABXPlcRYqcM0yymyRcxaByHpuIndbBF/4995HvncjJZyweu8bpsFat6wJKwiU/fAjRY1vmoJw0Z9no9gMuXJSoq8rSH2A8xFtmy0aax2QVOEktrIVncAMJ96e0RAoTRHl6KpgJMewehb7V9f0jfoazx6nKyX5zR0ghWSuX8pXttzrrlYCSdUK+1c768S3qT0nN6cbfrEUM3BGljocPVkYkaFAihLOGntwgvHfuA6CuSeCkL8uF1i/WcyJUxJ+ybV7X61SLRZHoTFRuhVPRO7qOxuQwTGIQnZiEa/Z10OOgb8MDcU5L3Sby+/BTAVkTsag543WhKjr2uy+sMD2U+icH3R5DYv/tUVOzDqafubqrpNmVw4bJOBkzjiHVIOy6xYqcuRQ9ajyU3B1O0s8DkOlW4LNyHKT2VL5aVeGBf6k6lPbxvUilxj5i26yq4GxDL0cwOXZnoISkpQfaAwtGsqZC1BeK1VB7pcSnBOYjhvkhI2BNZoO8u1YYcOEg2jAItwexaRwLKfEnXaY1cp/szF5QAaq2srZPIbyKt56I8xkCnWm+crAv23Kql6pB/u6w/rw5MOA2CvyxaGdwl/MO9+mF0RNXLr/UXo9IoTcFLOmLJZwbyCQ/5WLLjj9VHTgXoBIv1qrv5K7Hw4D4khyIgjPgyM8lDek787TPzAI3SV46DgCCzoTg3
 UjzFkPym
 mgiWFC5wQ9g5gnimnC2KKrJM5/Tm0hSslG93OAKPjdxTru5IT44PbSTZScyEJa8DZfF1XkXqFlrexpHkpuFl+5FYYKPDvp5uqI2BqdaZh7mECiLtlGNhdZzX1OwiwvOPPsnRp1Hmv/GgAyXavJWIuSHVdLcK2ACbyac+4ZwbrNLAzAS+YQzuYX9qlmPbRkvKHlBKmfPt2sBXDsZBI2NYpyWSVfG/A17GPqjCjO4Xf0lZGP/FK/8GOv+TtWQmiXfn27IV9kCO+nNwdjFs0XzXoInVs+/jKFF0MtJcb/ejl7cQk+DDOnfPfqW0k8YPMmWEH6TvHDMcduq2pTzkNvu/y/5gICOzV6KV7zxlOuxgGZqTxNSOem7D1QOAKr+29+skwlfOeViq9IhgEa5swyTWUWwdyUJz89U7gUx/5TUL9KL3RajwPwpkEvo6lZTC0vmdBTDkwJjvmMgYylbhG+I8/TA1pIcxdOn4PbpFEbxOKtFMxdSdU01KDs0TDLSqLmq5GvedEib1YezKM8XSa89diqOrcCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 3:49 AM, Jeff Layton wrote:
> The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> filemap_flush_range() on every write, submitting writeback inline in
> the writer's context.  Perf lock contention profiling shows the
> performance problem is not lock contention but the writeback submission
> work itself — walking the page tree and submitting I/O blocks the writer
> for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> (dontcache).
> 
> Replace the inline filemap_flush_range() call with a flusher kick that
> drains dirty pages in the background.  This moves writeback submission
> completely off the writer's hot path.
> 
> To avoid flushing unrelated buffered dirty data, add a dedicated
> WB_start_dontcache bit and wb_check_start_dontcache() handler that uses
> the per-wb WB_DONTCACHE_DIRTY counter to determine how many pages to
> write back.  The flusher writes back that many pages from the oldest dirty
> inodes (not restricted to dontcache-specific inodes). This helps
> preserve I/O batching while limiting the scope of expedited writeback.
> 
> Like WB_start_all, the WB_start_dontcache bit coalesces multiple
> DONTCACHE writes into a single flusher wakeup without per-write
> allocations.
> 
> Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
> visibility, and target the correct cgroup writeback domain via
> unlocked_inode_to_wb_begin().
> 
> dontcache-bench results (same host, T6F_SKL_1920GBF, 251 GiB RAM,
> xfs on NVMe, fio io_uring):
> 
> Buffered and direct I/O paths are unaffected by this patchset. All
> improvements are confined to the dontcache path:
> 
> Single-stream throughput (MB/s):
>                         Before    After    Change
>   seq-write/dontcache      298      897    +201%
>   rand-write/dontcache     131      236     +80%
> 
> Tail latency improvements (seq-write/dontcache):
>   p99:    135,266 us  ->  23,986 us   (-82%)
>   p99.9: 8,925,479 us ->  28,443 us   (-99.7%)
> 
> Multi-writer (4 jobs, sequential write):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     2,529    4,532     +79%
>   dontcache p99 (us)             8,553    1,002     -88%
>   dontcache p99.9 (us)         109,314    1,057     -99%
> 
>   Dontcache multi-writer throughput now matches buffered (4,532 vs
>   4,616 MB/s).
> 
> 32-file write (Axboe test):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     1,548    3,499    +126%
>   dontcache p99 (us)            10,170      602     -94%
>   Peak dirty pages (MB)          1,837      213     -88%
> 
>   Dontcache now reaches 81% of buffered throughput (was 35%).
> 
> Competing writers (dontcache vs buffered, separate files):
>                                 Before    After
>   buffered writer                  868      433 MB/s
>   dontcache writer                 415      433 MB/s
>   Aggregate                      1,284      866 MB/s
> 
>   Previously the buffered writer starved the dontcache writer 2:1.
>   With per-bdi_writeback tracking, both writers now receive equal
>   bandwidth. The aggregate matches the buffered-vs-buffered baseline
>   (863 MB/s), indicating fair sharing regardless of I/O mode.
> 
>   The dontcache writer's p99.9 latency collapsed from 119 ms to
>   33 ms (-73%), eliminating the severe periodic stalls seen in the
>   baseline. Both writers now share identical latency profiles,
>   matching the buffered-vs-buffered pattern.
> 
> The per-bdi_writeback dirty tracking dramatically reduces peak dirty
> pages in dontcache workloads, with the 32-file test dropping from
> 1.8 GB to 213 MB. Dontcache sequential write throughput triples and
> multi-writer throughput reaches parity with buffered I/O, with tail
> latencies collapsing by 1-2 orders of magnitude.

I like this, this is the better way to kick off the writeback.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


