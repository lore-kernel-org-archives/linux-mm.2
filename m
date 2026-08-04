Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C5FC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0366B00C6; Tue,  4 Aug 2026 17:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51136B00C7; Tue,  4 Aug 2026 17:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F7E6B00C9; Tue,  4 Aug 2026 17:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A054C6B00C6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:57:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3431E1602D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:57:00 +0000 (UTC)
X-FDA: 85064947800.08.3493569
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0276A000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:56:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=DAe+N2tm;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785880618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRxCeGb+Adq7LiD+7lUvdxxJiJP+D9Kgl6PhZ4uJptg=;
	b=5sc+gyllTmqC/fcJs9LZ+cDKnzLSS8g8Xq/h3L8dVGudMzuMaUt8y1L2+JqWSiYJYdNI7l
	MktrEKFVYoqv5fsSnCg0/41YHxM0s2jrnmTwrTI7UL5b0e4kuavRyxgbFkMzCnXa40YA1U
	qAmeAf9Q910UdXkzeMwkEKbAhjffNS4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785880618;
	b=luThK4eYfRv6KU52dQ/wTbBT+PZgwNHmNvsOsu2hzzi5cvkUrm+a1TE2mSkgnhm9tWJm1Y
	z8/xpXn46HZ0GUMDDsPOdaMSMqfpp8bd+8Jg8xBkHr2c9wIuAYhbC+WA4wXpVGBawAymAD
	UTNWpegmm8HYdYs5BTRmxZwIXOCzBAs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=DAe+N2tm;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785880617;
	bh=QRxCeGb+Adq7LiD+7lUvdxxJiJP+D9Kgl6PhZ4uJptg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=DAe+N2tmEXUl4l/i68CbM/BPesGL9wZ1sVf/tby8SgjxJsjizi9dHc5L7byqB2opF
	 pTWvumsCikE9vevIMNTQZRbJcbKISuBgK3tLyCfw1UW64tZOOMALZAFC+WDaMNZlce
	 WBXT52dg/Eov66DwE5mtH/6nta6O70Du5tdlJ40c=
Received: by gentwo.org (Postfix, from userid 1003)
	id CD19540FCF; Tue, 04 Aug 2026 14:56:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id CBBC040287;
	Tue, 04 Aug 2026 14:56:57 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:56:57 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <4baf6edb-c84b-4da9-b905-4d40d4bf5fdc@kernel.org>
Message-ID: <7f2b2030-b912-70ee-5019-02dad2e87ca6@gentwo.org>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org> <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer> <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com> <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com> <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
 <anIhSGs70TTzymHM@lucifer> <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org> <4baf6edb-c84b-4da9-b905-4d40d4bf5fdc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0276A000B
X-Rspam-User: 
X-Stat-Signature: xfqn13adk7hejh6oa713jr9451rcq8iy
X-HE-Tag: 1785880618-187023
X-HE-Meta: U2FsdGVkX1+EaQtdwOiLwhHivfUQB9Ozxz4IDI08pkoW7MGgERtA0YxZmE7S09HCJFKnBHrLhW9Q/+GUWL9H2XC3dCUlUb+6fWyQbgmD+rEM8bWqmaLULksCIBdfvzjVkOIB6Uxy7YZcQB6zHxprWqq9OsiF7GNEkJjMcDKrYtD+YFi6dxREUnJ+AEdWdHMo5KrJavFDt5zqbq4+U/WOqpXym3IqqvRreqUrxat9TBV3qh3Dy1OpMCAnMASz05uG2zfLTMygM1JXFoZRo8kq1o5VFW7/9E0p+WMeIckd2NXyJfSNL94dachNNkvJ288HaSHDhVJJpbAObQgxtkXJPuAfzy7E0SjUZDRqKhyWtiMbg71XOMlToJrGii5KUXb3LWwlh9JeLY9G9s+yqHAwxF1AColfSb7GuqTe/cjq0uttYH84WAzx82XoPVHKT+GJrTYKEP/DcIHYU8cyPiTqmGqO/7FhDKZwPruA2dbWRpN6lZdLqTq2338GrLlUirnBNMUnTmGfaL4+5r8El5DpWXaPhWTZ5I1qlf+pM7HuVuvfZiX4hLLv0SokN4ahxe8mZ+heH+yvSw98SjBoZnSs1HdTvyYy8D/0yLARU1paXvul200tXwhljpiZA1up6VO6b/VUng8BBO1WZKtxqG7Bjn5rnAC2y1b90nNAs0ZqpG7F4LMHh4vKp2yqgu1rezOx/fW/62YF3kYjqJUzvGYuxccH4RoWzK1kjjS39SSlZi2YtkBdsRE507OgIJlpBYXqzKbm1UUu8Cl/r58GXEzf6387m8NGm6uOiwEaHjrgbVq+vZ6c7cF9vHC0DTlOmupFOJXJdKnHtrrc8FLGJoP0g6IkKklvgw9FL51Q/gcg6h9ja0A6vSa6PnOkSDJHCZnoh3JZ9VmZFxdAd8Q/6aU3nv0VtO/7WFe1V/1zJUPxTfOmsoM16iUCMPIM7vwAmvLZJRVTCva6LUv/XjYF1G0
 Zydss9KG
 6VZ0VHVAe4JMNGlOKPovdw8p+aJ8SMfz+Z2KmZH9fVxFjzufrUYrXbSeoWlZ70E+IqUeeAHNeCOujaxmJELLBCI9CB4EP0mSsKM9ZQeFORESZ0MgexZgE+FfrpcKow0o8QJTWKvBydwpd59jVsa4vifwlIdEykWaYk4Og4xSkuIVZI85pcdMxBejk5iZb60Dcp7V2fas4k8aa++q1KGA568uyHJ+FUTMS9jjvtkSOOC3uviZ/JEF3VY85RAWqz3Qvw0XI4sQjeu7Jx14kVyUS66F6Zu48/OyUjsvUdN+HHpUKxOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:

> > These are operations that are key to the performance in critical parts of
> > memory management and this code is replicated by being inlined thousands
> > of times in the kernel.
>
> Cool, then it is easy to show the difference by running micro + macro benchmarks.

And we have done so repeatedly. Look at Yang's posts.


