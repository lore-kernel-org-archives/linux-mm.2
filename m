Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9DFC79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 01:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DE96B008A; Tue,  8 Sep 2026 21:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5083D6B008C; Tue,  8 Sep 2026 21:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2E36B0092; Tue,  8 Sep 2026 21:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBA86B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:45:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E1261A0827
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:45:20 +0000 (UTC)
X-FDA: 85192531200.14.6F04745
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5BB8180003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:45:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IGTljDXw;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788918318;
	b=Awni54Z28KdFis7+79UKLSqjCVdXxDM0Hmyt3aS9KdMBsvlCDH2m/QxInBwFnuAP+FCri0
	DkWTm0AvKBWzHysqvzbsX8vUJ8mxZ9+Hzf58A6yuDpuDiAk6BojyS0GoIFhv9Xmh0StAJT
	j2iGaSobeScrNd+E0uSvueAXlV3Gcck=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IGTljDXw;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788918318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tp3dXhAy5jR6y6z8B8hfuKasJOA/kRC+FrcfbplZSPw=;
	b=m8udy0kshtsPu07X+9eAZH0TLhLwb7ShKBmtd1rZYeSDMDENUR7L9vMwKbt6BAhiFwXI4v
	FsOex0M83Um5aiAzyy7DhxBPgywHsTa+XtpQz+YLNFqmfbzmIHRQcHA1XJqD+P11sjeoKK
	XC7rNRbqifVK9gjd3MDH69Bwcqunk8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 993D1408C4;
	Wed,  9 Sep 2026 01:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46D71F00A3A;
	Wed,  9 Sep 2026 01:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788918317;
	bh=tp3dXhAy5jR6y6z8B8hfuKasJOA/kRC+FrcfbplZSPw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IGTljDXwgWO0FriKqdwJFtPwF4QskmkLh1pQ2+3IPqHdcjNgnrUbTK/OI7mrSSwQQ
	 hx/vqsHOSMfoCqwnOJMQqb12JTW/Pczsmtdwzg/3yJc8S0UKEzUUjhUAx6q2c1x6JF
	 wQqqLdHznKYFGH7WFtTIn66xXVi5PzmW0nR/aEJ0=
Date: Tue, 8 Sep 2026 18:45:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>
Subject: Re: [PATCH v2 00/11] mm: Switch device DAX to section-based vmemmap
 optimization
Message-Id: <20260908184516.c026438445ff3db78ee120fa@linux-foundation.org>
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5BB8180003
X-Stat-Signature: ywgdwsacjcb3a4c5fxc3ewy5r8c735tj
X-HE-Tag: 1788918318-457543
X-HE-Meta: U2FsdGVkX18+cm+xA0atT2JH6CJX7uPwjP4Z92LaGBsB/H1knwmbY5c1BZlMu5e3olbO7imX7zpFLlB4yJUQpEJa6H6XZOHAQa3cgYcmCHxcZpQyM3PYyRxqpYEba13vW9GvxZME6VdPCwfaXdbestjbkaRpOtPlEfux3EhK1gJFdIGZzii2t1LuE9ry0NI0yhC+ZppHarQcwHqH4x2cbVGA3wBePYgkhYyTNjS9AayR0FWryii4vFcwSKogFjqsWFQa2Q0k3TeOoc2/b8v+/cTEuJMGiJxmQVhADsyqVGbi25O/NABLNruQx9rqsO5aJY5xkBGr79t5JJf20kffLMr//u+UF8DJhk2L8WRWIOgnhqqvK6BqgM8wzQTh6EmCTUPjVyJBjKR/vGUAWoncPDufcSjj+Z9k9evVDFR6/KPJGgiramx2tOQ1Uj5RX8JRYsEmTFSnOUG5x7BhZzAAMxTvYYDQRw+QtZgRbvVPFuwW1X8WjoGrT2VI5k7flI3Ke8MibAGzCH9xn+jBJfrl5b0tjpoPolFx/b5WTLq+rV+kKHP9ip81drdJXO7AXvqjX001hj5fcxMcFCZz0jFkLlCHkkCGd8+EfqVYy1u22ZNS7kclZ9ENLt5LA2uoLXjPm76S7mNW//3EL8EQtwM2Fg5vi+984ZnLMdvb2ELvtVA0R+BJjEGm8Wcf/9HESaXPYSOaC7Jf39tyP/w1t2w/uUDbKT+4S2th36d8c8+KXbidAZvVRNf6jp2+QS6R+I+ShvzvMOtrKnY0pFbZpjWuuU4g5iP9m7aq5W1fOWF5mMki6GkGNWbGmTenk/Gvu+PzRVzQCYMp3jH6fkz80d8le7y7lDdsDH7S5eLQEX+w62yf/qfxQmLvQ/ZlAmq1gf8O9Gk763se6LPf+VtlZJbMfc0dU3UX2ior6PptF/DSY5Sa19vtygrHNm9ANOA/Sy7IajYaIAbA+tlwBSkWUTi
 nqOCoWra
 JRwy/oDEkB24sUnTEs929rwql5iCQfs65+XDgEitoXmqhqaJGmSicgWru8ssUiFb8AFCMPR/p2g/RAueAsSlE8jrQNx3/ycwDdIbneGo88iZdgVAwRa7XrC366JJ0oUR1pUkSnCwGR/JZSGB4yEq6uXq4FuA4NDyiyG5JYjaXz4IKNNz/9us2yBtwKr2u0/vIkvb9RFeXRKHOXWQe/ahHdSNxydUmuyt64zJv3zyNmCLqHaR5/2AXy0V+u6EaEL9TgL3qo15PLRpwFHv8we4tRShg3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 11:03:24 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: switching device DAX to the section-based
> sparse-vmemmap optimization infrastructure introduced for HugeTLB.
> 
> ...
> 
> This is intended to be the third smaller step toward the broader HVO
> generalization. The wider HVO consolidation between HugeTLB and device
> DAX is left for follow-up series.

Thanks both, I'll add it to mm.git's mm-new branch.

