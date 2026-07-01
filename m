Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02970C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12766B00AB; Wed,  1 Jul 2026 16:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9F96B00AC; Wed,  1 Jul 2026 16:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00076B00AD; Wed,  1 Jul 2026 16:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9888F6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16D43168454
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:08:54 +0000 (UTC)
X-FDA: 84941296188.01.247C4E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83AB8C0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:08:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYaWBAz7;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936532;
	b=A8Eh8+UQsKGEYlvV3/pRyASK+1bEhrdKoQge+KED8Q2uz5Fd09RiQ3P4mfU+rDjJ9ACQfr
	eLEoZoKUdnxPoLP6smDaVpXBUfWa5NFwv8wfj1+WORnBsskUB5hNLoE7+A2w/NNW0zAP/1
	c1xWbwQR04hdqW5Tnk3sitZ/yw5vplQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLxgycIlH73T/Z4NDAOwA1ZnWgwK5lm7yqvdPVfx9jQ=;
	b=p0115hiRemqug/Ig7qzvy6BjOXJl2H1ASyoahKqidiruru23hkqiAYNJOg/lW9w0ABW5iw
	egH0iylrC0Ic7WgcMHkH3z9cPlH1jXdrB9BC8g1a7TpMqkV6TYa3mg4dQE1iNxCIBRm6KZ
	nMK1a4qR8kqd50pCVfKaLsnNGdub+2Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYaWBAz7;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 139BF6001D;
	Wed,  1 Jul 2026 20:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF221F000E9;
	Wed,  1 Jul 2026 20:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936531;
	bh=QLxgycIlH73T/Z4NDAOwA1ZnWgwK5lm7yqvdPVfx9jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TYaWBAz7dyKXyPdlRA941LMAtZ5+x90gsbHGCk83x7YC2EqtUwrPvBW+nVonPUhcf
	 I4+/mHW6IDsJbblVf6408D6+ybW+HP6IeJ2sdBChiGO3K0fB3Vd/Q1XTCJszQ2vHvp
	 0RYFQnYWyr7XN9Ndx78idaDl5WygSeeYikUlyRaGjIqvsgy28QZRWhxBvUpGXUh2Bl
	 XHnbWq/ijPBXr5ugw1dhzK59rUTLPt5zOYFSf1lyt8qfXVpY73E45RBPeh/ECe+l4I
	 QQOeM6vzdXbEIwufkvVJwdy8Nu6RLbQJN7efYpOZkFiE64lENYs4T9aYRsx412OEmo
	 ypVS30BDp2elw==
Date: Wed, 1 Jul 2026 23:08:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] dev: selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT
 as a failure
Message-ID: <akVzzR4TYwAyzKgR@kernel.org>
References: <20260701200143.1470229-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701200143.1470229-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83AB8C0009
X-Stat-Signature: egnzp7o6z5wjhu4m3qpxbcbrnohf63xt
X-HE-Tag: 1782936532-694428
X-HE-Meta: U2FsdGVkX18yVvWSW0YTNB0cm/dSgiSUMSYA0hSfOCfGcrD+CpX0DY1QxAYAlwnCLrKxJIxcsSZaVxXVuR2JDGxUI8jNUq65wbmkjt5YhTZm7N8zCkfQUjvaGtBnHEJCyD9ACr1rNvYJce1M3VJh1ET71y+xJ/59EAY2ov0dMMC69ZHViIcPQR59KWlThbN+CGK7kagDo0vbvZDyF8Mz34yxfqkTrwSdLEHuxDfAMv1JNjXfZ4sWexIja+A7RRQG1tg6kUzh2C5lpw2Sq0igGz3JGfMFVrfq/BzJmub8Wh31ugCIcrgtEj1N6CMtcXmvJV3SuB0XhLci+xXC7PEkpxmqZXB2HWA8PWPE3wzQJ2woZZLG0lSnR4fIjwEGQx+a8eetlJFtXR35UFkDdbBEpIUiiGLgV4dCyqeOrWSGVEpM4CNHtkJoHAWXoCFEbs/WPZMljWixcD9Dd7FrHvSNenPwbWbS9AHBkKvuFATKdEzojvtrl2dQZeCuzik0FgZvj40xrzHPxoXyR2/j0i0WvSoqd/kqdP5PXqTf0nL+/X0sga/LuANg6yT9gpkK/EALv/bcGqc+YDTjQGuFjaQFVIRq1KSn+GQe7AlvV6flV+/YNqxFUlSFMSXHHKKK+nT2zindCeL49EC+Yyhk+XlIZgNvoUkmPSensydOTUiSEprQbeBtlCpo8KpM5gTyjTg9STk3F7DbG6uJDAk92aytwZBQM5xc2JnEaVHfL2UgbPCkiz40fROGkLbBFWMQtn68jiWSh+1zqP6dP1daqyRrfMyMRIVe9LFiSdIki2GLfXu6wetu/fNVTHau7vi09gMvgmBjVHJ8dN6H70Uy7t1kZfpZfLtxe45XjBn/T4Fpf/jK6P+6/4hL0j7eTDfeUawpq3b/G4CIy5GQbOKFNhmBPrqIr7vPL6x51uEJ5igx5IClcdtiuvwxrlQODLJ6GnBkGFo7YZzKUvALpljPegJ
 K2pRGsfQ
 7jMadN/8WN6FV2t2DDMo00v8IeClCmniK83AbEBj0kIUvGx9UnDuqMRKyf2nAP9poKL1yh5vfPJ7AdsR4fa+PK7qnSxbOKzk2vyjN0Uf2MJzD0NKrNIYvTeZ3+DIaZ0qjVHUeJaMYIAf1pdDHfeLVq+gHmh6q10Q77oJqSuFkmYniopvp5J0NQz2J0qzWGKP6vUensYv0s77xUAehGILcmKMrUSS7YIgVVGZ9eqBD8Rzmyw8lJ+s/S/Azq2wLbi5lDH2jpHjrC0o5Km8LScJhUtpqEuZba1MKmuqd5oPK5CauJzeNvLnb/vaLIpJcfTVRfpC0HreA3X3cwpjPiKR+4CCdOWB6g8oKLgv+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oops, the subject came out wrong, will resend.

Sorry for the noise.

On Wed, Jul 01, 2026 at 11:01:43PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Non-cooperarive uffd events are inherently racy and can happen in
> parallel with other userfaultfd operations.
> 
> During event tests in uffd-unit-tests, the uffd monitor calls
> UFFDIO_UNREGISTER upon receiving UFFD_EVENT_REMOVE.
> 
> In parallel, the faulting_process() verifies that the removed memory is
> actually zeroed.
> 
> If a verification read wins the race with UFFDIO_UNREGISTER, it causes a
> missing fault that uffd monitor would receive after UFFDIO_UNREGISTER is
> complete. The monitor resolves the fault using UFFDIO_COPY that fails
> with -ENOENT which means that VMA has been changed (see commit
> 27d02568f529 ("userfaultfd: mcopy_atomic: return -ENOENT when no
> compatible VMA found")).
> 
> Treat -ENOENT returned by UFFDIO_COPY as non-fatal, the same way
> -EEXIST is treated for concurrent faults, and don't fail the test.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> I've noticed transient faults of uffd-unit-tests in the CI runs [1]
> and found this issue with uffd-unit-tests.
> 
> The issue is longstanding and it's not related to or exposed by the
> recent uffd refactoring.
> 
> I didn't even look for a Fixes: commit, as this is a selftest only and I
> don't see a reason to backport it.
> 
> [1] https://github.com/linux-mm/linux-mm/actions
> 
>  tools/testing/selftests/mm/uffd-common.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index edd02328f77b..f48f5d4594ab 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -639,8 +639,13 @@ int __copy_page(uffd_global_test_opts_t *gopts, unsigned long offset, bool retry
>  		uffdio_copy.mode = 0;
>  	uffdio_copy.copy = 0;
>  	if (ioctl(gopts->uffd, UFFDIO_COPY, &uffdio_copy)) {
> -		/* real retval in ufdio_copy.copy */
> -		if (uffdio_copy.copy != -EEXIST)
> +		/*
> +		 * real retval in uffdio_copy.copy
> +		 *
> +		 * -EEXIST: the page was faulted in concurrently
> +		 * -ENOENT: the destination range was concurrently removed
> +		 */
> +		if (uffdio_copy.copy != -EEXIST && uffdio_copy.copy != -ENOENT)
>  			err("UFFDIO_COPY error: %"PRId64,
>  			    (int64_t)uffdio_copy.copy);
>  		wake_range(gopts->uffd, uffdio_copy.dst, gopts->page_size);
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

