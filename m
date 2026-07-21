Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399C3C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF126B007B; Tue, 21 Jul 2026 02:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69D86B008C; Tue, 21 Jul 2026 02:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BD96B0092; Tue, 21 Jul 2026 02:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A26176B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:41:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A8DDC039F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:41:14 +0000 (UTC)
X-FDA: 85011836868.26.90A8A7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7623D140004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:41:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTiZGmzZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784616072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOHrExRuWAF3V9Vp4izbIbOaYSPY1V+m+7eA9UxNOs8=;
	b=Q3/lB7/ifDiZSW/kmE5Z0DsthCE/ojnG2P1mjJ8N+ekOkJ8EFpUs8wk7YMvvDM+lZXd8q2
	HS07PGJgVm2gLogpt56uxqKo7SByJ826rN6/0lv489IYGIB376905S0EpL2nLUXgrYrKqE
	2dIRAxs2Arh0K5KMKfpTNpB4GsqGLnU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTiZGmzZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784616072;
	b=SBzuF20ycD6SGSmnwzsy+G6wRPyQyQUGcVQy6Di3diiC6FSIl/TVCny30WTlP0YLEkttpJ
	QruDwDWyZ7DDC8JMsoaCxyVN7OtQFfZdrLwFUWfUDJmdfbCMzmjq/jBA+nwVbnbvOxc/Zh
	tqOu0CoDB6MdNzsQWk8vz2/GkNJ0P/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D5F842DFC;
	Tue, 21 Jul 2026 06:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372371F000E9;
	Tue, 21 Jul 2026 06:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784616071;
	bh=dOHrExRuWAF3V9Vp4izbIbOaYSPY1V+m+7eA9UxNOs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTiZGmzZz3UketVn5wFBEYl1u3hPtLyHVEEOz4TULPcMK8jBb99DiCJjEo0c5Jcvk
	 ybN/XDXNCuR2DLNeCcLaLqvXV7j0dJ8KPUD3hCNet8cDB2iZYHTBSmf54HtRXCs9lT
	 l+T0nwHVrwvjECzB6Hnjts1BDzAwiNNFNstCzKCDuZRM9OseOrWsCJ+9n2+XuDQnQD
	 wYkk3UXA8sbfsTj2fzQwDTl000B/BWPTWREbcZKEB4Pa4UUUYK9Et1PVkFpDzIpzcJ
	 C8ZlF67xWrbQOl4ZdnFznWQF2umYIw+dHh6mRpsfaDIWy4KJXJuv9352pwX4YP8gIT
	 yvSkkJLoaDKfQ==
From: SJ Park <sj@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org
Subject: Re: [PATCH v2] selftests/damon: Add missing NULL checks after malloc()
Date: Mon, 20 Jul 2026 23:41:03 -0700
Message-ID: <20260721064104.182094-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721060542.326-1-yanlonglong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7623D140004
X-Rspamd-Server: rspam01
X-Stat-Signature: awud8z5kxouks4uohtrwuz85ecgtkykj
X-HE-Tag: 1784616072-497754
X-HE-Meta: U2FsdGVkX18fXRLZ+Y+zOUZ330YgJPE3i1KKgTg7XvK+RZwS2ysiMrSV7fbIsufC88cEpu7rgvHLHvD2ce4Pg5/TNyNiOcoZHG009CZJWh7vlkSmrCQ7VFcnvKd4BtI1h24c9m19Kj2efguGBOmyogfdw9yPStZaoRI+16yVZc/kvfdJo+iS4N7zJbbnpiHCgSWSDW8PQRbNa/t5ciX2+U0INxMOCMFU0QAxREzHIhX7u7hnAIM1M2Jdh1CY/rybMpgZCLdi+tSHsfVfNFMQclADQpLDR1ADXDO1v+3YR/sAj2OFtLS/pSZRQXHRpI3vNGGXDRFxI5hQ9JePxqV29bhZ0H/hBc1W4C8LaiXCL8s07nYBnwsa+5L5sR9+N2BjCWuxdgDEae3at3uVRTw0zhfolU0IuetoDkX06Cpj0eVjmZSLRQW+drCvmItOLiTEX48yXAwa0Qi90C+plqjxjdr10RIlLj0rwfH7s7QsPxThEv4RKoqK/LoMiflTdF/oUNMCxI/SE/+wNPd/BrB5J/Q1E6UjIxZ3eo6sSsZe54fOVobZOHMTH8uL4MNUzaaFjF/tsulfRwEMH5rixrqu/qepjVZLXwg1hihb/Z/RA20vHPbcIQE2s567hOmLnWFmP6FLoygjx93DHJ/6+9IYsdT9MpaAHm/JWraEXWYRhZyLoLU5caIlD3CUqE0li8MPbVip15XDpntcfawDsSD3Czjc6CWof6JBRfpsfq5Ngw1Gi4YahZuYJy52nCYT82AStHTIXHj1cul0P+/mbFvYt3a3IB5cqwjIKYZ/rm4f+EQNXqfWjmTNWni8OB8TuVMsAtWwGeAmc810ydmKP3FIbvvMAHyJD0j8nKDMFDWitGzFIeOt58qZFe784degsHPXPMBlUiIfzz1GQ2qjfqMJAugUHQiGANNOr8wem0YAF+xd3jz0SWJEBsYn6/oeE9pl0vWku3Z5WMEb0H0a4ha
 Y0CQQmBY
 A1raQJwQeWIXJKZNnXC3s7zppZsKFrNaxZ0Q3uQJHKiSZ+GyFcUqxnffgYYJHdvI9j1ZnUJPhhtpCSlTDCjS4f7MCYetSIbBrVqd/FD11xSTulSTRW5+CyP+OJiDCOf+rtpDXwAecgHe9ZSTYJ/jf3OEY+EktCmhgYNMDlaFskXh30oRB804HXgcgyrkga/cbO5kxqMuMi5pC9qeNLWOcODAW0oiNlhdz2kaXLE3dG2/93+JonUJz0DOywsc2SFkhaLJf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello longlong,


From the next time, when someone asked questions to your patch, please answer
the questions and keep the discussion until the next action item becomes clear.
Please don't post a new version without making sure such discussion is done.

Also, don't post a new version of a patch as a reply to the previous version.
Post as a new thread from the next time.

On Tue, 21 Jul 2026 14:05:42 +0800 longlong yan <yanlonglong@kylinos.cn> wrote:

> In low-memory scenarios, malloc() can fail. Without checking,
> the test will dereference NULL and crash, causing the test harness
> to report a failure that is unrelated to DAMON functionality.

'test harness' means the DAMON selftests that internally runs the access_memory
and access_memory_even programs, suc as damos_apply_interval.py, right?  Could
you share more details about how the test harness report a failure in the
situation?

> This is a false negative:

Shouldn't it be called false positive, as this is a context of tests?

> the test should skip or report a resource error,
> not crash and mask the actual test result.
> 
> Add NULL checks after each malloc() call, printing an error message
> to stderr and returning -1 on failure.

The above description reads like this patch makes the DAMON selftets skip or
report a resource error.  But I don't show how that works.  Could you please
elaborate?

> 
> Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
> ---

Please add changelog on the commentary area [1], with links to the previous
revisions.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

