Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72796CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F1F6B008A; Wed, 10 Jun 2026 08:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16F06B008C; Wed, 10 Jun 2026 08:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53BD6B0093; Wed, 10 Jun 2026 08:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4CD96B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:13:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D1311A0994
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:13:48 +0000 (UTC)
X-FDA: 84863894136.30.B402DDC
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id D68BC2000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:13:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kHZon/L9";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781093626;
	b=EGwUdRferqugbkFWujm9UedaMz21t+SJl9FhG8SaM9sn0sPZeCnCToEpKCrd13xsz/6U2j
	e2qTFRi6lCRWsQgHAfFgUkdxrz6igcS3d2rGb3+AQJgL4edkjN44Cverc7ewB9wg2jh0/W
	Pv6HssibPsDIQH14j7JDjPqlLYSZ73I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kHZon/L9";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781093626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pwj8jdIsbpLPyXeeuKlvHP7KUJNAfbD2TmuqoyWPWCs=;
	b=j20yj5CeHkDjfVHg/bmCJOOph7iQpr+h35YGX/p8xVYTT2r4FWxbU3CvuH0vWVSaK4I+mp
	7mn7SQ4Xobo7jCFhZdO2coU1ufnH4lPVal7K3fZrmvKufSqOy/OBLaKtTl5GO2lBtUd3Le
	2lHE1FQjAzp+XlI6flarRGQH2TFtoTc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781093622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pwj8jdIsbpLPyXeeuKlvHP7KUJNAfbD2TmuqoyWPWCs=;
	b=kHZon/L9Rk/OuUATUmtFgYllI2r2VhkBLqmv89mnUttaPtOwahpgGto4qvMwY+P5M8q+Sc
	bOh4wFR3Pb39+NVgs12G8vkD7YnjH6QtsLeH+v8duM5y05J2iPXUhWJ0ARLdQeKQl4GwXZ
	LyF/A2b9YFG/Dl/fKi3rESfZcTfxukc=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse support
Date: Wed, 10 Jun 2026 20:13:31 +0800
Message-Id: <20260610121331.83926-1-lance.yang@linux.dev>
In-Reply-To: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D68BC2000C
X-Stat-Signature: 1kbiidk1jp6q6ufaxwt9trfj9bf5h4jx
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781093624-361196
X-HE-Meta: U2FsdGVkX1+R+uugnhExU4ZAg3o0R3g3JgFyuqMoHDNLO7kGr4fVoXsLiy9Iwd51P5ZWu3kI//Tsi9wBeUGX31GYScljVP+6tFksI4loj5sXmfV4XB+rqOBXPAR0OD0blS9HJZcZO7AdnWL5odzKQfR25vfpigW2s3FQWbqAHhz/U3VhndBGUwIIJne34YbmF5lo6BkPOXx1XZ8F35R7uACozRwT3faA0F8br2Gf7r263oR6jslZsErE5qoJ6hIVkxQBS0NtdGXnaLu2XM3BHXR1XdJYTHRpJlHMUdirCPtoMXPbHbSCpMkEU0CWci1pZPb2aTcU60phpyMvrB7jd8XsfJE4kUVL1ZRSnyp7GONW1cuTAO2dgjwqDb3iL70QROcNb6YiWuP0pa3/J1VLnvNLQSOfjkGkJ9oDvK/XyknKvTkfxi1WwIUF7EG/IFluOVpxlzMuq92GT1zgyT3JHjfxfEhd1FCMRKWahjx4zmPpl9mrQIswLomj8FdAWnfAoMUQR7pswW/WTwDOqAy4NprqU4JhrC3Hk00b77l/XFu6/Tnk2ijcoGHzeZPjqhhlskLpPWkPEGYcYiQ/qXOBeKAYPKbOgorsQylIX0ufdXdUk1LKEbzimflnHw7otILuR3TOudyKdLD91U+IeLVkRY9EMIXUXILufO2QiSRROUICzr859EjnJNenXs+Tk9sTIU9Ob+GL8iQSS71d/eVVVSUPdumfcE7vLFiYTk88s7SvCKEG5qYVMpS/giB1Zuwh7f+cUwDHl7kfPy+3gvd9bX1ZxolXoKIkBndAw8OXDcixpd9Zi1X/tz7QDNbSa5jeWNckaymenFIsPhWAJOJ0pRrSSqwB70hdo/y9Bb1eCZNaH/mG/xJCLQCQ8VYTWnc8Iy7a7wXK81+MKEWBUxXkFe+S3JshnbiJywt5C5v5CvEg7zXcq5ZSfRrfftPlGoheBC9lDNcY6l6V2DyOvZb
 HKG0W/YZ
 +N5Shq8vSk2HgeBmFphw0hN41LP265ArbYJA8x6JU37LygdeYIXh7wKHoNEKCVjojawXgturPyIzUjPLlqG7Sp6zOlj03gT42NL6r0wg5hlAyknP3b0x89DlnxPa1on/R9a62STi5Cfdgu2bfPs83B7FLcN8lcJbdQ3zOohqJQRCiex1/vrb5Rj6QEY4yX+4vS9a4VmYmPzgrUk4WnJOJ5OIyDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
[...]
>@@ -2808,7 +2875,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
> 	mmap_read_unlock(mm);
> 	*lock_dropped = true;
> retry:
>-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>+	result = collapse_scan_file(mm, vma, addr, file, pgoff, cc);

Looks unsafe to pass "vma" down here, since we have already dropped
mmap_read_unlock(mm) ...

A racing munmap() could leave it stale before collapse_scan_file() use
it, no?

Cheers, Lance

