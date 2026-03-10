Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FFAFD2D69
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FDA6B00EB; Tue, 10 Mar 2026 08:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DB56B00EC; Tue, 10 Mar 2026 08:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEB66B00EE; Tue, 10 Mar 2026 08:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4046B00EB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:41:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7D651B6C75
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:41:13 +0000 (UTC)
X-FDA: 84530113626.30.9AF6023
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7550B4000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:41:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JcoqtBh8;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773146472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23S97wgINlWLXAiGS5HNLUZSukSYxUCQHIDnN+UqDZY=;
	b=2xpLuRK/FDVte++BafznyT7/OGZjczTB9RSSkj4+VKiPZATZd4RUQ1LZXvtpCCZxjvin4M
	yR9uiw42pwCpwgb6Zdowd69W7tmvazUziI29+7TxJiIjAad4wC9qTp6jcBW6TKoJXcHDSq
	NZRkZ6ptTHUihoCuqa3UFQU+JG/ebM0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JcoqtBh8;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773146472; a=rsa-sha256;
	cv=none;
	b=5NZF2yJjwYLF9NQjCDDcDITK3WUKJbdpfL4pSm15uDTMj50nAqee6URN4Qn8yx7UML+DoS
	wI8o3eYELyTQU3Cflor92P2tN8jSqrQ0bc6m7/hCpWjqnLsUa3jMWl9CXql+7LKc0E4n10
	TR2VHdRzhD7CX6k14cA2lnREWg8lbaA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=23S97wgINlWLXAiGS5HNLUZSukSYxUCQHIDnN+UqDZY=; b=JcoqtBh8b1cfBMYuyuM0FhR0wI
	uqAjSAiHzKKwHs4YECVgh4dIA++lxMa9D0zb8oqcgpATWH2ifULpZMM/tJlaSWj9fbTw3qScjJlj3
	lOAWQo7GC3mPmq4R2mGe68On4ggYcHLuxcksAFrB6RRKBxq7gM/Sl/EWrGEGR0BJsn2HR4EMHOjpl
	PuTMRmqYMN1ny06rVGELy1PAE2yeWJHG4nv2tsxE7GQaADLLfFzMNRejrnzo9WfJM5RKDifV4yDGb
	ckXbpUbeYmJX/UGWsQKGKDSOuPiBDucdf5Xb+OYO5NQXqIC0Ky6U4Za6uYvKpJHjj/lRfLdb6TsFy
	VpMR4+wQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzwO3-00000007pkc-0XaG;
	Tue, 10 Mar 2026 12:40:35 +0000
Date: Tue, 10 Mar 2026 12:40:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, hughd@google.com, chrisl@kernel.org,
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
	jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
	kas@kernel.org, yuzhao@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: Re: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
Message-ID: <abARQsqJ0vjg2VTw@casper.infradead.org>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-2-dev.jain@arm.com>
 <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
 <31f93292-3de6-475c-b7fe-82ef41a3a7de@kernel.org>
 <04a7465b-ee69-479f-aaa4-ccdf3ae16805@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a7465b-ee69-479f-aaa4-ccdf3ae16805@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7550B4000A
X-Rspamd-Server: rspam08
X-Stat-Signature: 56sxjmj353fd1e7xmrptq4hat779tu6m
X-HE-Tag: 1773146471-594520
X-HE-Meta: U2FsdGVkX18uzRS4fcaK15fucK2Mj1K8OhTR/sYnsf8eWJeTMAUOOGqOuKPYTGcClMMjXK6sUj6jXfKAXZ244h6JBTSNaAv3uJV4xnSp3FSR6DirQgo+PtJqWtga5qCQ5adEhMjaAT5/jDp8a88K0QhFvc+Don7cgwYjRmQXxYRnvpfUR4ezRmJt18TxQKIY2Ki98ODaIhklRkm3r0KCjCh246HH4kp4WZrRVxPCFpe14asfi8baDOooIeGTj7fYGUTvjhRUjYeYNnyJLt+cwiWM6nv/ab/+x2OphOWRzV6nXNTI6K1LcZd32pw50PigzzZksvQ6+IRHXIT/xTy0sVh5QBOyE/C/CvGYOjXBN0zMC6KgnltupaQ4iHWQlY3JpZyF6tA2MVIDHGFAs9HDHZzKL90+DLZASjZxd2ITZeMBF891mpMbP5Zmy+KAEewz8OTEnAfbnNXACXYesiETBEbnG4y9jPEW4Lt/8jYbOy13BwW3tqkfHpmJUyqNHEINYWdmjhFeOl8sVP0qJRM/pR+2S2Sc1Ei/1/2KIF+n1n9iS+NB1ziyq87QZbF5CfopdKKhw3kUfar+gKgc0fCMY0rxKtknK60LbE8SuvEJGNgmM/gU6KZQ5bGxzEr/JTngQnsrDcvhJNiJfG8bZknEiYX5JdHyiF8As+zkTQj4eQ3AZ/YDwVd05sca1NGS1LUxRYHnHylYntfuURPbPpH5QqyOj5tEOfnWVa3L+G8fSUS6cL3q2ojNsffyVABtzKbWIXZTdwP7CImHKGM0gfICB+vIvHe107OtGWcXtGo/uugp1qwY+CkLUJlpMLVPasJ3+I68ljW2NHRDhH00ZU45e4h1Oc55pU7flR2Cq9KZtf8wfWXMh9vBy3shZ2YmW+B0yOW0MamccSKb+Zud7WUFGppgGQd3zfAiPPh0fP806syQs9dKnKb6BSyEhjNeh4Fia4FB1FJQNTzDXq3/FHm
 Nsp8Apko
 q+9KaTfsiHdKlcG20PvhEBBiBvrPRE0wtJAVeet645EmEOFB7NrKxvxuWn0N9OX247saCDwQ5jCyht1DQ4SGCcKi4vYiE3uTnSuVYddlssrG/t2pMm/C2G4/2hb7cGLQHO/Icvbe+pPOAutw9QsXkJcrFhGmMKEdj53UXr+xG/nWMROPeRoN3e1or3KABt5uXsfq2IspTEBBiGXnp2vP3NElLyYrkfMop/HGY1Twp1uIoutdi5o1HogT0kfWeZn0u68cIwFILUdLpcoyZfDfE0cpqkQ86jfTDBydPKTC7oCHJ56g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:53:21PM +0530, Dev Jain wrote:
> So when I was playing around with the code, I noticed that passing
> unsigned int nr_pages to add_mm_counter(-nr_pages) messes up things. Then

Using int (whether signed or unsigned) to store nr_pages is a bad idea.
Look how many people are asking about supporting PUD-sized folios.
On an ARM 64k PAGE_SIZE machine, that's 2^26 pages which is uncomfortably
close to 2^32.  It'll only take one more level to exceed that, so, what,
five to ten more years?

Just use unsigned long everywhere now and save ourselves the grief later.

