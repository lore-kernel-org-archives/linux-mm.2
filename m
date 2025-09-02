Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0731BCA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A838E0006; Mon,  1 Sep 2025 22:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472268E0001; Mon,  1 Sep 2025 22:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF138E0006; Mon,  1 Sep 2025 22:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 297CB8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:50:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E54C1A0ABD
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:50:29 +0000 (UTC)
X-FDA: 83842781778.10.4C9B113
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E3A9A0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:50:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YWKGCc76
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756781428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hf6Da6Iq95ZbXZKuGgj/YV9gGgv/dEeEFT9XrC4vfVs=;
	b=JKvd0eq5AxIQ1r0b6JVn2y8i4OMsZAkcIHmNEeXzV8tb2CPZ+jRpVFp9mfoMlZFpstHnn7
	h0xD63AAIKbyar6vlYShG8vL2VgG5Pm7OA/Ja+8gKCt7t9ZFHnRT6GGutNSYET5hSofIsp
	qrwthF/FjXzeWCY6ycnEXt4CBwCpOXw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YWKGCc76;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756781428; a=rsa-sha256;
	cv=none;
	b=4mhs2KOjaKjmOSzgxVdV6AQi/+QfQtH1Fdg9+jNSveD8mkLhabsZLyu/3lpOZFJdhz5CqO
	kyXqgMZHZqDjsEhZHpo8NJN+G4pc7IK9xMa9gaRAezUQxPxbvNb7NP9srWfrF1gDVaZluE
	lQr/Dfxs9RmzyG/0AxSHBz1+9vz9pQw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hf6Da6Iq95ZbXZKuGgj/YV9gGgv/dEeEFT9XrC4vfVs=; b=YWKGCc76MDqwdQGQ+YNvxvBkE7
	LOtsZ/0qAhffBjWu2LlUUNNOwjLMqqeegxqzD84CwosaGVQPg3tYgm2N7OBQVwIKzyUITZLtL/Yce
	RTiKplKHrXU88mi+OFSDvF6nVFL17jqSkRmJ+SaxTvUL16Kpb7ukadvFSbeQC3zGTfvoj8cVCf49F
	O4ns7Vm5RaRFlO4WDOwnTREHtTe6+GdlFzFfU8lWr03F1EBbv6ITczdHk5xcuqUrCwivrKjxXNfyE
	buBpYx7MRb5+QPg3NMDAnd0muprWfiSDnR67Hw1+LsSBpzsd21TiroQj+2Xhy9iw2N9BUGc7mpDFh
	bb0u+gbA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utH68-0000000H6f5-3MNh;
	Tue, 02 Sep 2025 02:50:16 +0000
Date: Tue, 2 Sep 2025 03:50:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
	linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com,
	deller@gmx.de, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net,
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org,
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
	rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
	broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
	mpe@ellerman.id.au, nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 00/12] mm: establish const-correctness for pointer
 parameters
Message-ID: <aLZbaHf-euLQ0isT@casper.infradead.org>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 5E3A9A0004
X-Rspam-User: 
X-Stat-Signature: c1e8ez3pqqqwzh84n5aut6du71jhyznw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756781426-39195
X-HE-Meta: U2FsdGVkX19CIvgT02Zc+h8QDR1vyGAinvppXT243I29HrirvL4ebrAeFXSlYjyaH2CYut2g1aFBTHixUL6u1KWJ64eDccUodUxr7XnLH08Oub6FnQIetU+6fV9Q73qyAksjV9X+MNSIf7gSjjx8YVku6HlFLbigyy+YTs6v336mouC02epJjoR+VXi7MzIITHtxRanImqqo6Cells2nckBr8bzQn1rsx7tyiJmH5ZH//I6QiTy9BYzrInsYTLJnf+d/zZvkWCIcwLfWA56S/EcazVai6yDO1NhmFhnlDWpe33wxlEhvWdnNluY0ZeLuwg5SPb6qzzOt+Dg6/km4a2VDPLijuc+4K1lRC0n2vLtK58jA6Ra8bPJ6zrUuBr1FS8Y+/7a+XcXpaHUXnJTLd7yeWr+6yyA4a1t00K7j/jseLZLYGYofWHmGKIUsXiRIYowBiE95Qz7lZ75wOQNWeTTJlqWvKrKQ/OV+HZ5wFdg2jDwbmLvAkjh9iQ1ChITRskX3EvmOsHWi9jI80+tZFZPCeW0QQncPz51n+2xm7VnEz17TFysjWFk8TDYCKbs7QDIM4AZrYzn1yhutwS9+4ZKRR7DDQuNJj/XQC7sGqzyGmpHJc+/RmG2E8HkX9kpl9q6Dndin1G787ZCTARbeY/FM+DnQx/ZUi8ttTuqFRwkWbq9oM50JTwXNLD4fo82yfPzEU16mXfNIuKD549ocp8LW5/pEbTXsU/0SLtZLZaXUu0vnljguazfsGJqCLo56MPDpKfOeZiKypo8TvkZ2JNrh5I90ZvCsOSzYvXhU2GPpJM1Mzq95bhpOkUzRYzT4gAqtSTBFLLGxajhdirZOyFePrn8RrQBsEeME85MxnwUIlM1RtlbLv0nTMpI3YDPHO8xG773+VcKLQCmZr2/Y6OwJuuPyAlYrVUi/txHwEUSM/7k7nppG4YGL7QmYwpel0QYBGNY9NQM6hRdfNYo
 dv9kvohd
 PaD+0YOd5pPlz4RVdOK59LVvweLNVY/XNwLn5Fi1NNF+HWnbQywTqJezL03xxXvySSdHE+r0H+Nft82TmOuuHU5Bd1G9AAI6C3+hrrV9v4grWk+/gLoNKK8jKdush2t4QaKZrDgyGFPZcxkC2Hh/0HCKQY16PKKr62B60g9uItJEwtwzbIroMad9iIFZCU8bo2y3dhJTn7mRAAeKoCmWpQ5NuCnqhT66SRbqj53yXcs18lLU4KHxElxSNWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 02:30:16PM +0200, Max Kellermann wrote:
> For improved const-correctness.

SLOW DOWN.

This series is unimportant churn.  There's no way it should be up to v5
already.  Wait a freaking week before you send another version.

