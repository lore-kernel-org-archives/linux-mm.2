Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E20CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AED6B0093; Fri, 22 May 2026 16:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622B36B0095; Fri, 22 May 2026 16:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F946B0096; Fri, 22 May 2026 16:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7A36B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:22:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 178691C1FB0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:22:04 +0000 (UTC)
X-FDA: 84796177368.15.2A2FA84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56C6840009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:22:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eNkr+pGC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVT0GsCmp0z+OWsAjvQLKMuJ3m5x5E4LmFka9n4wvlw=;
	b=XqIhzUnK2XphPgK3uTAb9df96aQbB5F3IfIxFGXN8f/mimevKpYtF2fF6Xnt52NtD+T3Wx
	t7lm6BmUk61VS0SZb0wKsVc1/OG3H3YrqjUg+BXJ1dehnR/CMYXPoCAS79tpyu57f5VPeB
	eO0MqI71L82aQce66HcLzdkK+lzxVsY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eNkr+pGC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481322; a=rsa-sha256;
	cv=none;
	b=mHFwMMQIfuoB5QQ1yAlYzhD7CIpLw1olUtebJfu4gdjABWEOBZxlz2orTWfFUqtMTTFfYH
	wszhP3UFfzdCsYHUBqgTuJX+Oa3KHY7v7rFrTG7Zxl9B56jym1VT879VAokd4RjCxWqwPp
	9ZcH7r6lBIE3V9DlpZii0d21/VAnb08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACE4560136;
	Fri, 22 May 2026 20:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B7D1F000E9;
	Fri, 22 May 2026 20:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779481321;
	bh=sVT0GsCmp0z+OWsAjvQLKMuJ3m5x5E4LmFka9n4wvlw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eNkr+pGCvFyU+hJOQ5+sjI7sgFViRAD56CGaDdboAN3PmGKsdx85UXM90IJZ5ZidT
	 zRSh0h+8vwXq7tT3cVfcZ8DFHzZN9Wtg/Tkn4Msz+BFBHUq6hdcfiIYxYbhugZjU6y
	 IXHbeUPXpUxA32IapFjcdhdJ+8kr3HXVb9sGNPig=
Date: Fri, 22 May 2026 13:22:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, Brendan Higgins <brendan.higgins@linux.dev>, David Gow
 <davidgow@davidgow.net>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 00/14] mm/damon: minor improvements for code readability
 and tests
Message-Id: <20260522132200.fc3505a9b9af4243b960547a@linux-foundation.org>
In-Reply-To: <20260522201352.3459-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
	<20260522201352.3459-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 56C6840009
X-Stat-Signature: 1kbqcqi4i4hffi685kk6kkdygj94g4ud
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779481322-615692
X-HE-Meta: U2FsdGVkX1/qNGsR/ZYV77ru7H0vTA2m2d7YJj1S4bvEcX9PcZ6hQEGgCkDERA+A/TZzbV7TWKDSw+wJb4rf0ZSvi8Rn2ZM8fT6AVglnb+1QgHn4Lc/z8TQOT3y73BGHKqrixQySRUthXGz70RJiwsP+2oVO1q8CFvhewlv0amMVaTG+xTsYgmrGpuoIHB2K5sI35k4GMgKyliec/SS1mcc6z11JQqUD/cWbM2Oxz8BkQPabKa2bNhZaV2xfQD3JYaRT6+JOEFhXUZFh+ucMW8HkO1SxNNiQAx/G+WWUUZWZAH3Pez/jymhq0NWnkcNf7o0yudV6l1YAFGW5rtz3ZUPDFsNoE7Y7LGwdrPrCcT+W8cZyMm1n62Z8egvGv4ow9jmLYUqqdoWw/Ef5AVYTns79WWlSosa5YWciRDt+7yFGUKL9LMl/vLfnXw7p/jO47VwiYsY/B9taOnA7ayx80JKrM1/hlKlf4Ij6x08bp5azqD1PEOhlQg4MZ42uJxKBBM9MGp0wA19+CwEfv9ItGj8d/k1zwA98jNr/YY+WQiqO9NdBGDXpdw/ubVg60NEgAP5CX5uFWlsLfp5g4Y5thM4wfFc+kxSRRWLTClAP9wClcpmQq0p08axO36Rp7Y2RClvRyo1NlwO0PP+j/AcHvG43djUg49/9cD0/yAC3G/M9hrhQeD8CJPg1uDFED0mVVZB4h4cbuQxI1T7evLHTyh5aa8JuRpSzuv8a7gANDe3FQflIvoH/dDvQKcf5O9c8zPOW/Di2bQ5zKWPEPHRx2/DKDsfjCYJEPfR+6wYjSvi0mcwMEHLieYhfSv5w+EMUzVpL28ADl1/UaPA7uEWgmRpCfkbUhvrQo08kFHTVNiz1AAYXR+giTXrq3MnXXti+LYmCLrmupjnafUxb9uEUnEFVoOoEQQg0T6WjaC9dHg8bnPHEuNagwJgnMzwsxy8iZVWlOwei4rA0RszqmkF
 HpXrnohk
 RPCIb5qtKbdMvvocUDa0iKxcqhZIqs1fRj7svkGkwLw8BWvDaJah5TozWs8y4kEEZIDqpZcPSYz51ztT+l0L24FQ2TNVUfgM6J4Hr86jY5MVHHf6LNaGRLRFVKLcYX48yYtgwDxCjx20r4FXI5XZKVzqYbq0TockeWTK1tAeQrZLyIGWtYyu4zO3N+Q/6W+rYCxiikaQwX5zYrAI6ggJ32SZmDLvSs4s/JC0IlGDCQBqOgY7yhk6Yzyc/Y5kplUQMrpkOy6WMbDj54f/zmHEtiSV/KiaD7doTqMOq8tX7o7r2OtKNKw2XMVE3KzZzfU5d43JpmiJ4OtxXcKeQZ7f8b/orgtl5t+Pucw++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 13:13:52 -0700 SeongJae Park <sj@kernel.org> wrote:

> Dropped individual recipients except Andrew.

Re-added them ;)

> On Fri, 22 May 2026 08:40:11 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Implement minor improvements on code readability and tests for DAMON.
> 
> Sashiko failed reviewing this completely, but found no blockers.  Also it
> didn't find a blocker from the previous version of this series, which is same
> to this version except the baseline commit.
> 
> [1] https://sashiko.dev/#/patchset/20260522154026.80546-1-sj%40kernel.org

OK, thanks for checking - I'll add this series to mm.git's mm-new
branch.

