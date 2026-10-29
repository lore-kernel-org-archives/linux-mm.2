Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB0A606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hNgg5EZ+
Received: by kanga.kvack.org (Postfix)
	id 403C36B05B1; Thu, 29 Oct 2026 00:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB5C6B05B3; Thu, 29 Oct 2026 00:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318726B05B4; Thu, 29 Oct 2026 00:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF596B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:46:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 884F61A01B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:46:33 +0000 (UTC)
X-FDA: 85374427866.05.3BBFF52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CAC1340003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:46:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNgg5EZ+;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793249191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrgRFRyJzb1d3IFLLaW3xDsmEBA9Xn0LOezkTYfW0GI=;
	b=g26zyLl8/pYWtYVVsPPWo3BFM+blfhscZSLVS/o1jnfZrPAuMFuTDOOHxH8CqHsUKn3JrI
	IgKAKvyViCIZX+oU8MbHT8WWmqdkwYniSLUQ/mitk6pc9k6Dv7SWjCsePu1PSnQN+LrIPH
	6tMVYmN5AvHO7B/qcnZlvFKL9ghj+Ow=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNgg5EZ+;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793249191;
	b=rZtFipYn/DSe0vizgq7yCguZlBwhelvso5m2cGIrNIt6pYeD/d5q2CPqVrIemW698pFjc0
	mQbf63rEcfAv2Sx5AeZOxdCsZPdlqLOxHp3Xqb3jbTmiZKKw0iKn4G7SuiwdEAnap+r4R9
	+z/zZrvr4/tUvnrXfZCAL3rPmSTr2kQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30C43601FA;
	Thu, 29 Oct 2026 04:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9461F01829;
	Thu, 29 Oct 2026 04:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793249189;
	bh=rrgRFRyJzb1d3IFLLaW3xDsmEBA9Xn0LOezkTYfW0GI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hNgg5EZ+VUgwQ+8qwSEFwtrVdHWtns30vjLcTGdkyI02RJM2VkljJ8Nn5eD/VioIG
	 QkniXKl18F8jaTkDI9Rn9YDBY+aCw1ukX6u1q+sN/oyE6/D5nUDY90A6fCC1LE1Fkf
	 mjlMWRjEhVCSjfruF2ptbTAvBpMTgKzPGrND7748=
Date: Wed, 28 Oct 2026 21:46:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Alexander Potapenko
 <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov
 <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] mm/kasan/kunit: Add double-free tests involving
 kfree_rcu_sheaf().
Message-Id: <20261028214628.aaaa47c78c5b1257d399257c@linux-foundation.org>
In-Reply-To: <20261028194014.3671161-3-kuniyu@google.com>
References: <20261028194014.3671161-1-kuniyu@google.com>
	<20261028194014.3671161-3-kuniyu@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAC1340003
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jsbfroc1jxbb5ebt14t4kfij5ennkuia
X-HE-Tag: 1793249191-453773
X-HE-Meta: U2FsdGVkX1+06JZN4anAiil6UbJhYnUl9UxydJfOoRZtjKzMy3ShOv+dSFVJWDAcL4BwXpdJ52wCI2kZCKdXd/XSYyHgDf6rVHFjjcYE5ZRYmT4Eb/wUS6baowvAdHeIuHNNx1ZZFadvJD2HWaMruwGjhiCM9VUJL27zAv2zRq15hKnpxZrau93a40beCY4eSDXQSc2VMjXdVYfByQQcAlUT5dxTBZlHmgidJMdTgcUrkFUhLPOSCFi9ZZ7kcGE8S3C0Au/w+ewRK/a/tsnmvutYCHhB6Z7W/lZfywagN2PFsMcmWbG61//a1XgbAJ/q2fB0APtNnMw3jawAFXNaK1wLEv4BkuzQMbipkTO/n5V6KsZqFy4Kz+LmD8Qlp15FpGNU8vhsYAd3HpTZ+zueRNXR7rvwJxScgvucQLtLF1FBPwjN6PWNb809QjlbuUY3fq99Z9g/OuZjJBRHH6LGHFF3XQhBXlthJYQL4/wlowv+2Hql0jDW/zNJqF3A9kUkh9k/IpFu2mkL7RpD9AOzz4AXYOkzA2FYTZN7zUsY7taRlg+sRHnLz9bgucDvKZOj7iHI9HPD1MnH9Tx+chSYvmlH6ePwmR1ZeLZVF5eO/3ftAByBiqvdE1PWnJMUBg+dIlb++fb2v/3neP627nrav4Qj4xAYVs63ky/GBPQvc8qPURffasgFzCq5XR60fZUETR8DMt3bUd1GsCShlVOHD9cjdhdsqp2lywW3I+WQ5zdcNPONmsQ+5vesnDPTgL5Vst4RXc7ZDVc0r1AFGTZjwQvadWz5yW2VpObH3Sou+pQslWnOAs7VOYnqEVjahV9vw9RzY+wMtR3fB1i9tWB6djP9+VJEsxg5mA0TvXCdJu2evpr5Lyb3ySf4N6sCnzwd/9eijOkQ6X9lWbAsS4NV+7icVy7iMyfcyp+YYpU0M1VbIsmXjmd2dff+XkgbGMb0tjlQ7937VBbOoK34/F5
 +p9cJrwR
 45tkPFA2XRMVceTwDCKShiS9CVCtohS0Xy0jUwFcT0te/V0YAU/FSA2KqEtbogOkqnU8Cqlmqm5edWif+abVm9foL6AtoVfemGqRzJtrr04zlhxSfFQqqM7Mjk96Y2E96vJzyCkqqA3LXHzQbDVodjYWzcnZD3lp8m8hsuTUKe/dP9zDafx88NERGX9hhgtD4m8CJWmnYnX00BOFbWVZ5efVkxva7z98oTqUcwOVfQV1O3hK9LrUZzmYCkLcXfNtDUNCRKCamDyDYO2eaXOkKkZcarNIlmYQnSG19pkomTfQidQ4XVbkv8rBwBxRXA3TuVF4dIhIjcP+HS5RMBEg6S7/Ao6ppDchHzgnjcbntqgb1jSyJjchDyaGH2nE4h40+uZ7iVTnP6ILaIaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 19:39:20 +0000 Kuniyuki Iwashima <kuniyu@google.com> wrote:

> The new test cases verify that KASAN immediately detects all
> three combinations of double-free involving kfree_rcu_sheaf():
> 
>   1. kmem_cache_free() -> kfree_rcu()
>   2. kfree_rcu()       -> kmem_cache_free()
>   3. kfree_rcu()       -> kfree_rcu()
> 
> Each test also evicts the object from the KASAN quarantine and
> reallocates it as a victim object before flushing the RCU sheaf
> to ensure the live victim object is not poisoned by the rejected
> double-free.
> 
> Without the patch, all tests fail to detect the 2nd free, and
> the victim is poisoned:
> 
> ...
> 
> With the patch, all tests can detect the 2nd free immediately and
> prevent the victim from being poisoned:
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>

Thanks.  I believe this should have

Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")

and that both patches deserve a cc:stable.  Please comfirm.

