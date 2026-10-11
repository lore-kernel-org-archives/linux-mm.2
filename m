Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4EDCA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 04:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828266B0088; Sun, 11 Oct 2026 00:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9C86B008A; Sun, 11 Oct 2026 00:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBED6B008C; Sun, 11 Oct 2026 00:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCF36B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:28:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AC931406CA
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:28:12 +0000 (UTC)
X-FDA: 85309063224.09.3A4699C
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4259E1A0002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:28:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b7AVaxCV;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791692890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgUBQDdodR1jUKBZJnt7Hs3MkCVZjH756ozkqdENr9k=;
	b=RLPClwKbnHZMeL/7qupExY/pQwqorbBu4PqC437VVJIn0+HnUV2YsQzKZAEYHt4OotYKPN
	Ra8fkaGTZ+2Ddc4xByI1Sre0UBjWZQyfZ0CnhzfEV67/dqb6kuc8tsUZaI+Wdg4e8l1czR
	tr9xmSCw9E3SwdzQGBXYuyNL+xGB2lE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b7AVaxCV;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791692890;
	b=QXqaXWyRXbSHdh5hRBdqXbg8cj/8jxp6lTmdsj/ZNtd/v9URnq7XdxRgDD9NJ2KY+//Wmj
	uW8YZ3mGhKHsAd23fH5DPAFgbXJDMGsod17+jkjhH28n/w0v3gCnMyty+1siNmbdB9dxvd
	zOq6ybxA+cN7u9PzgfgRQ3Xg/chTR/g=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2db710396ffso17369385ad.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791692889; x=1792297689; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VgUBQDdodR1jUKBZJnt7Hs3MkCVZjH756ozkqdENr9k=;
        b=b7AVaxCV+V+6vTGvqpE8L37hE3LffPDoRxrw7tOqu6khTFbpLph6nfb3rRjtc+sBnQ
         METk62DDWb9BvM0+GF4xSPpGzlwqosSF9Egt1NEehkNvnzvhCr0ZIcjaQpUgvGiEHF/S
         pWjmA1YUqHccQdWUYuxcT1uvCgfWZQM8YUU2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791692889; x=1792297689;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VgUBQDdodR1jUKBZJnt7Hs3MkCVZjH756ozkqdENr9k=;
        b=TNe6bkmwTgQX2PKMG63vroUctzKcwZpKKkMUttGGz6/Lk54Y+i5NBWvA3XAPKf8+VN
         ovWJcAUVTO5hD/qha36+NgGSOFzLCqnWz/zlO9YucnhRCIcye+F4/f0LfXC9h9XvOGt9
         Ir5BRqckHbQf0Da+NnRqWFG4LD9WZPHPMCIJBlYHMe+tnbAfADOY2Zqzp292hU1n5cTP
         W9ZadEcsLdP0B8YaYZS5oDfve7P06qJd841e6R0hYuBbe7Ypk2lYTcElHxP6IHRbEIro
         kFpqy0qGPFV9KSbbeOrgbqBLqcFZCRvf0pp29OxKQkNtTb3SeRkNvB6EHdjUFWgIjUpo
         ECeQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8qW1xqp7CIMaXz0cEPjJfZjKw2r11MdDI6MjjkEahEmPlSPA2lLkRGtRz9OKm7J9elmvGqrpqvQ==@kvack.org
X-Gm-Message-State: AFq9FYIjbkVzVBHxCt8VCRjzn6+Dfqjm3/PpNZai0QyTq0dHXBHuBC0C
	wR20RFnRsoRGBeHpupqMD6rkfqJv55syHIbgCmKJOPLF+KgIJ9XlxqfKypDwymZE/uo/OFmmobu
	KUd0=
X-Gm-Gg: AYBFou0OKPalKyU7vCvR4E6ePZAACPLLAxBGxCrOOPKzl2NeSRVdjFPcEgu6314ajAF
	BAeZ6VYspeqIfeVR883PQkEiH+2Wo9qBAj4CgIWjmrHwG5IAEDqWjW548bW/JJCbF/H84XsDgSH
	8cASeEOTUleIrJpgtonYr2dqH6MEvS0gjHCEPq69D+Ysb4xGOwF+fbZcjPUElOhlMR7yRvQSXaP
	vhIv2IdQMMz6v5+duBAPTz3SoZWn0zzT1WKMiGpfVT2ALLibYcG4Kf7mgy/R9DdzPTnMGcNHwrI
	gk8/oXwrvx3rVhegF+y7Kza2VsYywlOSKG1wVKBCFe/j0+gZviK6q+lG5xw3xYKcoOEpr07QWRW
	6i8xclZ1rX3Ee46QP47hoOe9ETEOdUsy0dTf8NKYhMEHmkDOAvY+22OGetEXRv2sTSZOk1zvnky
	ZzgbmQfXb+Y+wFwTTfxv4ff91n2pxvDmLdzqFDw+JOEuX5vU4WnlcbLWs5wQ0Q3uo6yjZyplg20
	DVzGbYpcYcaOyYEMwWXMe+9fVkHg0ZVOAR5bqA=
X-Received: by 2002:a17:90b:3b84:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3ab3a369ebamr3764665a91.3.1791692888901;
        Sat, 10 Oct 2026 21:28:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:75d8:6a8c:e079:f021])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab37163e21sm11921110a91.14.2026.10.10.21.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 21:28:07 -0700 (PDT)
Date: Sun, 11 Oct 2026 13:28:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 11/11] zram: use rw_semaphore for decompression streams
Message-ID: <assQJStvoDK0nepk@google.com>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
 <20261009071157.3730698-12-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009071157.3730698-12-senozhatsky@chromium.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4259E1A0002
X-Stat-Signature: grcxar16g1nojo5u79963w3gs4xknsik
X-HE-Tag: 1791692890-386512
X-HE-Meta: U2FsdGVkX1+jAmhbfLHzNSQQNiVUk3sLLeVtwZnwdZOFAUXUrNlZ5OhMQKwIoIyPiO+6W13+TtbVrqUYvO+fUc4jzeCYxK6JUVs9XHF/OSnXe/pVsZh6dnNishNgbQWd2HkS2oFNg1xvXbnG3/2t0oAy0nTl4j0RRtQYg4CglEr/Un7xTJC0QPAi0yDVD5HXENsDkcwEIPRMEcNf9feY5XV52d5pkF98oBIPmtJnbm8MRjU+rK89tQjQvIEHiVmaKjoES4qnsPM190MsFDbMxoE+d1oj6BZ0L+PYwuXoVU4nwtVNtVD50tmDfpNVV40DNG5T6fAJm/I2tYzNokUIlP26tjNbjNGGTkOMhBHslvIZtL/Q8F9s7tXulVhk9lOUIZAGBfd0E7r0wX77h2791sAvMIOfLEtVKhN/+zoTATwwFqLK+NY7+AZUB6OtIaTl6crnJpiHMzOaKsAhRP4RvydBfSBQ1q3fi5FOJgbaxaN4rK9MYgzTcQOR0VsnWalWkya/fRJFTFHnju49jJflF3zZ7VA47nORbKEM/T8b5L0fN69ue+rkbCW0Tao6CWV/cN6EODy0amMjfQpLh+LFI6iIGOF34jY5iqiNDOqvpUicshecJ68YXCYrebQyjyzDZ9bNYSqoL9BEg9TwjIYx+ZyYG9z2ziRo5PxvcRt7DuQoCngEH5Tmngv5aT+M4L6tgi2iPYBM6UhaZ3ZQKepUiFHmRZ+3S4J3LrUWlxm+Ke/nfZC4/k106BCwD4DQjBJBEbwluN9c/sSatec+khndei9SbaND17oexjweNUf6J8wPfe49foD77MKdni5xf5v1WLM0wksIpuCka5kYqa3U0PmHqbZ2eUeL6bi5gML4iQYKLvyblrOtpJBAlqPV073xR3Gg0CoCmjUf0FHNxf8rkgQi0GYth5xeJfn5fMeLa8VMba+LN8q3NXnGBJdQ32TVM/P3yFVKNTCn92iPjoM
 qcc/dyFB
 lkMa7H0irZYkIV5pA2aAwaT16RapTA4ct82pS6Ed0Hvx1olIWojBdsemW2UCjLgWbm7N59bSIFGkXudLEHkuGhTO0c4RnPcy7+EZc9Q5B4mXSQiozoEsWw0W1s67wmddAL/8lKwxj1C12WBJ/YDVbNRlhY1/AETmt+qKjYlO6/GZfWMeCZRHxcGrUGfUJT4yORy4C2wpgGipyLuqcF7zKZsRUP7HKu4kbxjmDN5bZKiwBrjlAnW93W+bTWov7rQfKeNSbaLGwFkNVU6y0IjDxY4lMQHYoTkDmo234t7YiH/2y1QNZA8yRpLleSEYKDMiUQKTSL2y6t973Xd8rxqfkiGOSTDyo+Ht3l2Hw16qKfJCCpUiVW8EE9l/DjPzfH+lagvui
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/09 16:11), Sergey Senozhatsky wrote:
> Currently, per-CPU decompression streams use a mutex, so there is
> a chance for priority inversion - a low priority Reader can get
> preempted by a higher priority Reader, which simply will get
> blocked on the stream mutex.
> 
> Switch zcomp_dstrm lock from mutex to rw_semaphore to permit parallel
> usage.  However, things are not completely straightforward.  Many
> backends have stateless decompression and don't modify decompression
> context, so those can be used concurrently.  But then there are backends
> that do modify decompression context.  We also can have compressed
> object span across physical pages, which zcomp linearises using stream's
> ->local_copy buffer before decompression.  That buffer, clearly, cannot
> be used concurrently.
> 
> When the backend has no per-stream decompression context (stateless)
> and zsmalloc object fits in a single page (ZCOMP_DECOMP_INPLACE), take
> the stream lock in shared mode (read).  Otherwise, when ->local_copy
> is needed (ZCOMP_DECOMP_BOUNCE) or the backend has a decompression
> context (zstd, deflate), take the lock in exclusive mode (write).
> 
> A quick synthetic fio test on 24 CPUs (preempt=full, lz4, 48 low
> priority (nice 19) readers, 24 normal priority (nice 0) CPU hogs
> and 24 high priority (nice -19) readers):
> 
>   Metric           Base               Patched
>   ----------------------------------------------------------
>   Read IOPS        473k               680k          (+43.8%)
>   Read clat avg    35.98 us           21.28 us      (-40.9%)
>   Read clat p99.95 55.55 us           20.86 us      (-2.7x)
>   Read clat p99.99 6,717 us           2,834 us      (-2.4x)
>   Read clat max    2,005,100 us       1,614,300 us  (-19.5%)
> 
> Suggested-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

JFI
I have completely reworked this patch.  Will run tests and then
send out v3.

