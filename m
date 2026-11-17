Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BFA606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lbG59ViW
Received: by kanga.kvack.org (Postfix)
	id 009D16B00EF; Tue, 17 Nov 2026 00:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCCC6B05B0; Tue, 17 Nov 2026 00:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBDE6B05B1; Tue, 17 Nov 2026 00:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC9056B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:42:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 523411A0186
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:42:16 +0000 (UTC)
X-FDA: 85443515472.22.272B4F5
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 983B7C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:42:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lbG59ViW;
	spf=pass (imf10.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794894134;
	b=pMw/tny6t3t+l8DjywNPubpVdW5yRxrI63gNqqhLtzIxuLWs3saayN4KgO32afFXtZNULN
	VqJYjkaHn2QMehRSTbcfps1OO+q3g7Sut64g7FGoTDg7jCzFdo1BIyVe7i+9gBy3ep/SHc
	mThSEipVVAdvf1aAGBT9IkXrwbzVC8s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794894134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXX+yyLfhvLwx/H4++TlJSCsQc1ztTB0esKx/piWuYU=;
	b=E04S0ZNN/A/tnl5tPPzbQCvOU+ByI13vIrgGV+CUpd+yeYgAyU8cOai9dcperhM+TFnzYO
	1Lc81JmEQQGrsDA1dRMVd/43L4xr3AMPYTYjERLDzc753w/uYbJmo2XD8QsQTk6x0uvvtZ
	VDdZh2ns/Ss21qjy9MCG7GcQpavdIV0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lbG59ViW;
	spf=pass (imf10.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IwpDjeYOrVcNF5/TGijmvXdAi7xLWiQJD951NWDFYP4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794894129; v=1; x=1795498929;
 b=lbG59ViWxgiu6VL8dzuK/XrarL58XgCuLO49gfHO1zPt7XYO4757KPl7qKseVw/OLHHzK1rf
 HISlbAFKB0a5EVghdVy0qXzoQ3SBuIVweJjs3VubqBqFPWoevyI8eaqUEqhyETbbdxZ9NpMAn90
 gDyEeDkTaSduhkCf+imli2Rc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6eef51c466824a1f;
	Tue, 17 Nov 2026 05:42:09 +0000
X-Mizu-Trace-ID: 6eef51c466824a1f
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: look two windows ahead for the hole on a marker hit
Date: Tue, 17 Nov 2026 00:42:02 -0500
Message-ID: <20261117054202.50460-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115203328.f98ce9a068849c2f2fb32a41@linux-foundation.org>
References: <20261022-bug-mm-readahead-async-overtaken-v1-1-c05b8d8bd2da@gmail.com> <20261115203328.f98ce9a068849c2f2fb32a41@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 983B7C0006
X-Rspam-User:
X-Stat-Signature: 35puf857jix8rwipp435j4hzpaihomqj
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794894132-750689
X-HE-Meta: U2FsdGVkX19Wg13FmAp4HM5ZvHVsDU6+AzB63jHQ6BuIsGbAEuYwuqnowEsBGjsLQkwuRh6ojTXgChU8OZnpQCynZ2of9UyfsaxZTflh0Mxe73KZZnQQ2JuY6AeeIm2UxmpYOJhUTvraBUTC5jPt1dVG+dm6uf8k3pW5qDFE+nCAmTKmW1Ool6hT5PSO1b39gSfbfA44XPYB1x3PFaubptLIAYs6hm4k0OFsLllfpN0X/fzwmo157hsxDwDUjgDT7+7Iqi2bkGDvSipw/8PxKir4s+qHgmwZDlIyqd+Qat08y0QQQUz524MpHQp4aw4Y1PmFNaA9sqeUnI2csYxSpSkcYzBsu4F2RgRLbDWSAC6h21Tw1M6QJ6Y+1puQVNRqj4xUgNxl94S3I0K9WZr8nOMAUv6vmH5AE9sD19qDnLPUa7+npazu6UIgUJkYKUNb8H47p93vNDv6fFfdECoVByAZQqY3YAvwDJ9SiRc8QM+msGHZ+CEpwQ5j+0eNZHDlkzShSS1xEIRNhwtnlu3bgmWEQ/dysPNeUh8NzlDp5VpwSoApEe6wJw2l0OFKfeLOyyzGgTKe8wVxnq8K82IfxMFLe21yn4CZXY6kKLha2ajsExWBxzQU2PRErmAWvobMy3lZwRxMtgC1OAIJjb+jRTP9xZ5k6uqOnOrHbDLnsFJJ2DKIrUqR1Nipa/FovQa0N4yVYlqDiF6E1ct3as+TaInFMaj3A05GwFkK7owypixShuyJBMk5fUnUMbR3Wyzowap6BWOKEBHbYR+e8oPKK5NEQNM+A0rcWgSlZaOwE0izVm+L1UAIZy3hbTIBNk/o+lUB1xTqvPZVrD+Yx2EYD6Or/K3jIZ6eT206fEjLP+6CkjpVIodPWXLqmfXvW+6yUdjp6aF1u/u3rPKeg0VeGKB+PyM3VklAgYbaQNX+b1AHxJTEa9oYCv1UGkPsHljOVs4M14Gk8Mjt+abbkEi
 b6q+b7Oy
 n1oVr3ZxSd622XpGbEfSL78TPFeZw2d+shL1+y3Bn71RuNpdftaLfN5XvUK4vsPhyiYW6ZckeKsx47LpzIy7A2EnIkW+G/qmxjd4IYOAutDz70L+ee1phybL3yOfvsMiqWS68zZ8iLMxd7EDIeh4gQjX/H1t/r8F1o0sW4RHglsOOHypqEwHr6lBRufjkR8NiQNvSRLLqbKwNqBQIwabJO2nHH+x39euP+NZWMIBI/JIgz02+CeMXKqFf84Bo7w+G4Ymrti/RGX8Rdd2XaVwtk/Om/lk1wKjUMEwI4envaNILmpEJcGS6EE86KMvcgnicchDZj9sLQXUDyajE29eUJ1mu74pUQC5/pr6IzlcN4nOtbwnFyRtL89i81vJGixc/7qbS6mb23X8aXzYznUdZrUAxackcbsrKubzUgAjqoXwTiK/duo7P9cpFXvNLJqYbxaYpAUXV3k32NfZxqttOl4kFO3dfTMeHsAscYiFtmsqks5GGNLOgS+wS1z39Q2+PdzM/PH9Fbo1Y0UY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 08:33:28PM -0800, Andrew Morton wrote:
> And you have QEMU in the way, so reads can get served from host
> pagecache (depends on QEMU setup), which also matters.
>
> So I just don't know what to conclude from your numbers.  I *suspect*
> the gains are from reduced CPU & memory-access times which is of course
> good.  But was there any actual physical device access involved?

No, the host page cache was warm in those runs too.

I have now repeated them with the file on a raw disk attached with
cache=none, which sits on a hardware RAID of spinning disks in the
host, so every read in the guest goes to the disks. dd with O_DIRECT
reads the 16 GiB file at 440-490 MB/s. Same 8 MiB memcpy() pieces,
read_ahead_kb 8192, guest cache dropped before each run, v7.4-rc3
(666539eecdf4) with and without the patch, three alternating boots,
median, with the amount read from the disk:

                                 time (s)            read (MB)
  workload                    before  after change  before  after
  1 thread from offset 2 GiB   60.69  28.68   -53%   14340  14340
  8 threads, one range each    36.80  31.22   -15%   16384  16384
  32 threads, one range each   34.67  30.38   -12%   16384  16384
  8 threads, 7 MiB interleaved 27.54  27.20    -1%   16384  16384
  8 threads, pread()           32.06  32.27    +1%   16384  16384

The single reader goes from half the disk's bandwidth to all of it, and
its major faults drop from 1793 to 2. With 8 and 32 threads the disk is
already the limit, so the gain shrinks to 12-15%. None of these reads
more than the copy needs.

> I tested the patch on my LLM-driven test setup, which is similar to
> yours.  The results are...  ambivalent.  The things which you want
> faster are indeed faster, but other things slowed down (wall of words
> appended).

I reproduced both costs on the same disk in the same runs: fault in the
middle of a window at 64 places in the file, so read-around marks a
folio 6 MiB in, cache the next 8 MiB (or 16 MiB) with
POSIX_FADV_WILLNEED, then touch each marker once (median of the
per-run median access times):

  beyond the window      before (us)  after (us)  read before  read after
  8 MiB cached, then gap        16.1        43.1         0 MB      512 MB
  16 MiB cached                  9.3        17.5         0 MB        0 MB

The first row is a real cost of the patch: mainline reads nothing
there, the patch reads one more window (read_ahead_kb) per marker hit.
It is wasted only if the reader stops before that window. A reader that
goes on, like the copies above, would otherwise fault on the hole and
read it synchronously. The second row is the longer lookup when nothing
is read, about 8 us per such marker hit.

v2 is the same change rebased onto v7.4-rc2:
https://lore.kernel.org/r/20261109-bug-mm-readahead-async-overtaken-v2-1-06ead50562a2@linux.dev

Thanks,
Qiliang

