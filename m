Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB5CCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9FE6B0088; Fri, 12 Jun 2026 02:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A296B008C; Fri, 12 Jun 2026 02:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9595F6B0092; Fri, 12 Jun 2026 02:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8181D6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:48:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34D591A0393
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:48:03 +0000 (UTC)
X-FDA: 84870330846.24.E183A20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 752AD20004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:48:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYA1nWDv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781246881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYKn3nqZTI2tONzA/mOunAmSCw2g+cgo26Rk9W8RKAY=;
	b=yC4AgX7cxjeQXUipD9mzGaDwg26+YURfG4/Vq1X66ZYRRITQ8wDKyTGIlw6pBitWqqMArb
	JNcIYTdlIgICmsiwh02/4HOxAjM/TOB9MGVWnpGUzUEftGk7neYSobO43l+2xssKmWOg5i
	wDulGgW5VaQC/Ou3abMm+/DbpXWuDZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781246881;
	b=uS63XEk2/yYA2yhTwZmoDOAcBb0J7oKyFbOLpte0vhjtW4Y6ixqsFiT58zELGu8TfGlgS1
	cQRNygJi3WC+jN30BrnytPTNfBSxFKPYd0qiTOL9v7LN0wf5cfsTPOfyynINRatvwtv9Jw
	wQEB0wlTndZZHbjn6jkSSkckARcSRl0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYA1nWDv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1C4C6001D;
	Fri, 12 Jun 2026 06:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797EA1F000E9;
	Fri, 12 Jun 2026 06:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781246880;
	bh=PYKn3nqZTI2tONzA/mOunAmSCw2g+cgo26Rk9W8RKAY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZYA1nWDv5Kwx1F24wjee8yzwFfyzxfMG+g8cWzvDB3bEUM+EMfkYHp6ABVQ9fRMRd
	 T5YaKhfOZpYQjxQU55MBSKLYilBqhXMvNrhHHGQz0r5o04LvFzqj1rNcrziQdVjqP5
	 mgtT8FWQIY1P31vj/uykTfWkQu0gBpfZw99wjX6jGNrUV2PDEYvnBtoqU3CySIrALy
	 c0uK5vi5VyyvoR4M61Fey8iKtYLRqwIN9V4ezzbThVuHfPlSWKV9B5KcQUd5VfJtEf
	 LhU0zo6Whc6grmxDSJ4nryzfJ1hJZmrVx0NeoenuHrCQEF05auuoCz8/cxxtl4d03M
	 Q5Rw7oS+Las7Q==
Message-ID: <884cf1df-2256-4eb9-a2cb-67377a3bd8f6@kernel.org>
Date: Fri, 12 Jun 2026 08:47:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
To: John Hubbard <jhubbard@nvidia.com>, Yunhui Cui <cuiyunhui@bytedance.com>,
 akpm@linux-foundation.org, jgg@ziepe.ca, peterx@redhat.com,
 yang.lee@linux.alibaba.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260608025043.88087-1-cuiyunhui@bytedance.com>
 <932e1fa0-dd9e-47d2-9133-d3b2f78dcd97@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <932e1fa0-dd9e-47d2-9133-d3b2f78dcd97@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 752AD20004
X-Rspam-User: 
X-Stat-Signature: 17jbxfumknfxbwzzrnndef5zreatrn1x
X-Rspamd-Server: rspam08
X-HE-Tag: 1781246881-937973
X-HE-Meta: U2FsdGVkX1+3JRtY4Rgl9/zgRk/YxQHADFwD6z4FoIfV73POJ0M5HCKC2XVSe8o2mBHtNesXZ9K8IoemGfX7HjbjnruehJogXESVGmAEGJiBYvWIJUq5UvyzEE4Bf8MxBE+EZpaOwh8jHzKYALGBAtPB2XLO5RZSY4+7b9vm3jhpr88UIINPJdD3cJhG9oIqC5gF39WZ3/LWIjiZraVbX4pb9D+rdwhrQsJFcpW2u4jwMT6+uBJLPpAxG1BuwhputSmSROpZD/kbVwCQw+bjpVgH38+dKT9gjsE8jVw5wgt7R5a1AG3xzepPUQ71S4E+9yhVGU0oLZJk6KXdF9XbTYyz9IP+fnjcSP//DxszVSVK3/i43IjOV1LOaAeyVBYhCTPG9uVmUe0fFsLLk3hxtFe/PZj797Wnw3Zo6oFbSdKrndZid2LHClS8g3WHgBbGSAZIS++mUBQOcBsJqkNqvjhBgl7WFDkX5vsWPpK1c9aIHcqheVL68a0iVoUwbbj2K1qH7a2SKqUVW7e/Uxb18dIRIDUNIkwrH4VcX5RbGqxLuoRmpx7HHAwPIq2u2J6kTlX71F3ruxWBO9b0CaOOgfUwOtYtuTUqSnVDUEcPfwHjNPH8fKhy77PTVBWdPPsxibc1XdjH7GvWDho0ARzSNhod3mMvdy8tY7s38HRcf99PFuEzJkcG2IvNybD82YdWjEE3Ds/PFqFQXZUxKIiEJpC75YN7iCElUUyHGqU6XXvsWq50+T/hTYVuWp2uFq2iIOD3lE2Ht6dsjc7BsJ5vl3e603pkg3ThQHdbdEYMMCyE4wuEvM3ugImujL/KfA91rBrTOYTTk8h4Gg1lu/5Wgpc+kuCt8iz5RK3xPZl21kXI5+RTo3T3EMSmgp3XUWCvTo+Z7+eKz3G3wOqnslk8Mw5Wr5T5DxHP1Q6NniQ+cjEAdvjeFvR2qTjUyLVh1A2VE3rWYow3HhQ9m+ucZaX
 IojMKZRf
 TN6oFmecXtH3GNQw6w8kLKmC0+Wri1cBKKUGBFV4BSwWSwAJ1P0ypJuMMBQkp0A8Dju/0x2fHT1fe1z1PboD5+4WaaUuPWZYgTktJHaU++zzcy5CEzGDN2b9n+fcC3LYH7rxdCRBNSQv15/0i6QFgIzKwp9yp06BWvAr/HNwZS/WlVnei2iFkJ9l/4j24Gv8aJtFAubO0Z5jSglVKb31jvUXkpNotcoxsS/wQbBJIMvGCAQ3kt74rw6hI5LkKCIeqX+LCH9GQk6IVR/XvaRZOKtrgvpetP+GOUi4bUYiB7SXw5nyJ8EhZcTl1PQZUpxwK48TwKTPIwFf3Yms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 06:20, John Hubbard wrote:
> On 6/7/26 7:50 PM, Yunhui Cui wrote:
>> The PIN_LONGTERM_TEST helpers keep their state in global variables that
>> are protected by pin_longterm_test_mutex when accessed from ioctl().
>> However, gup_test_release() calls pin_longterm_test_stop() without
>> holding that mutex.
>>
>> This can race with PIN_LONGTERM_TEST_STOP and let two callers operate on
>> the same pages array concurrently, corrupting the test state and possibly
>> freeing it twice:
> 
> Let's add here that there are *no* such callers in the kernel, today.
> 
>>
>>  CPU 0                              CPU 1
>>  -----                              -----
>>  ioctl(PIN_LONGTERM_TEST_STOP)
>>    mutex_lock(&pin_longterm_test_mutex)
>>    pin_longterm_test_stop()
>>      if (pin_longterm_test_pages)
>>        kvfree(pin_longterm_test_pages)
>>
>>                                     close()
>>                                       gup_test_release()
>>                                         pin_longterm_test_stop()
>>                                           if (pin_longterm_test_pages)
>>                                             kvfree(pin_longterm_test_pages)
>>
>>      pin_longterm_test_pages = NULL
>>    mutex_unlock(&pin_longterm_test_mutex)
>>
>> Protect the release path with the same mutex so that stop and release
>> cannot run pin_longterm_test_stop() concurrently.
>>
>> Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
>> Cc: stable@vger.kernel.org
> 
> umm, no, to "Cc: stable". This is the sort of thing that gives AI
> a bad name. Specifically:
> 
> * Nothing in tree can possibly hit this race condition.
> 
> * This fix is purely static code analysis hygiene: correcting
>   a theoretical problem that does not actually provide any
>   sort of vulnerability fix in the kernel.
> 

Yes, all rather useless churn that consumes our capacity.

-- 
Cheers,

David

