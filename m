Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A992CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86708E0008; Mon, 10 Nov 2025 09:03:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E578E0002; Mon, 10 Nov 2025 09:03:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B2F8E0008; Mon, 10 Nov 2025 09:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8D1F8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:03:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BD6BC0DCC
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:03:58 +0000 (UTC)
X-FDA: 84094866156.20.C9B5571
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4905FC001A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:03:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=APBOPyKN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762783436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTntukXdaVFjnftz5WTTeF+x0iVhUlIwTUQPH67TnYI=;
	b=p/QLwmvJace2cpDO+6MDbCKOuIvlVBHTPnNsxAXAkXJxIeYLTo/a7Yv+26e98Ms2fRwSxP
	7CnAg4HKWIK9u8pl8ilcuzyhqooXx7W11tyStk2b0cUUzdXV6aY3uWd1m7BNSZC/b43ltI
	DUX3dJD/VZ/Tyihgpdjp53bGAPyBjXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762783436; a=rsa-sha256;
	cv=none;
	b=6kagJCty9RmlCp7ZXMehaejs6jwQHqHflnY3Pdgx0XuI2PsjkPLxpLGPk46FeUW2UdZZF7
	rraFmKGerKs/ClN5FJrONcbhMW3TIEeOz0znYIUg76tICXPqtWnkO+E/l6SNHh3Hwp5tEa
	hrHGJZdVwARTgvjByGYvGIFJh6pD4hQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=APBOPyKN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wTntukXdaVFjnftz5WTTeF+x0iVhUlIwTUQPH67TnYI=; b=APBOPyKNe6JNBjwvNL5ANy0RHS
	6FNALoWP8USB0oxkWef8vyXGcUJ8QSiW6uIkCWiB/EIfRyqrImuDNRpbA9wWzVBdmn68foHJ1kDIh
	JLGqmtmQNQJEA9SXC9s2V5O14WEQyyPZaE19sGkWZYxsTx1WR5ZLU07/9gMwST/Zlo87g67UQMqQA
	HpbrFRnKHlhUxREbF+vv5DVk/ZNxmOF4QMCzG7IYGXk7CX/SZRGXr9miHifFgv2Gxkdf/JW7juAZk
	/reX6S9bZHznt9sJo3+2btv63m8oA7k86Bqwlg0JYGbVworWUEN3A3Nd0KlZLMiFOmTG5Wl+yIZoy
	tUGoVX8w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vISUh-0000000GkmP-35kQ;
	Mon, 10 Nov 2025 14:03:43 +0000
Date: Mon, 10 Nov 2025 14:03:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <aRHwv3XzI4XHcLPP@casper.infradead.org>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <9b622374-778a-4459-aca9-4eb406a58516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b622374-778a-4459-aca9-4eb406a58516@gmail.com>
X-Stat-Signature: skni6xmz6o8zoipgup3yyr6s11t4xebi
X-Rspam-User: 
X-Rspamd-Queue-Id: 4905FC001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762783436-863031
X-HE-Meta: U2FsdGVkX19xyABvVzpTgezR6uRQYg2xmcud54VtShux8J0ZDTOThdryUafnGmLvzLzNy9ZHgHc8AYvtg7JFlunoDAbXhL3ft7P7iaJeAwKf8L1oENFOaL1OEJReyFD4RPksB0FWGJTs+x5CnH4UuBwSkhd/tHJkMOR3svhjJ9RkTD4uz5NEEzTCdQezEIevw+1mqBJVuXqC+b7FCfRtMMlrnj8aHiMzLkNQgjgtdpg5iblzTvbBY0GTSr2HKb6hjmZYsTIT475WthrqotUrXhY7LAhGmD0f7yelXI8ltzoq+z4qLXcOdXa9zbXnakbjzoqdkQBFtbS/nyp8Ah9sQ7Jf1BCO5M3auDtMW2IqLrpSdz4FE0QihCciTozOAti0oWOxFEnMvE+/sjK/xcb51gfAG1+2vr/FRSNSRwz9Qnqma62Siq8Zdmmf/ldRATpcanEMu+hq+XJHC0gppzqYWU1uY2Jfz+ns/W0bqhjfv23o7xUT9OM8ESJdd9+Sx0aJKFjOMVTxSp49bY6ghpeg/Ao+w9JY8+q6YJHJQOaH64hVZKyPm69Iyk/QWiEFofvtuVJt1jWE6NXhgFPAiwySaSxbx6vBbFAdnR6cW0W2rYCkZnA/4jwWzbYFiK1Pa/knyE5923A/mGnlSMxakMHKAixN/yghvfJysFbyrErHWEv1pou/+ZI3UtoOazLb8VR8twg88+lmhsGlrNjQ2vqNSLotv1jz9j8XVvUAknbJgFPhTwSFkduog/TmUwmkEzynFqMIlTUensOrGWoPUlvxAiiwRC/SUqZRseyYQomzKu2xHBIIZHJ1Ioafata+Uu3R8x+pNcLXDCvfbCt8IPSc3aG8UdXhrMocXeTCqnYSvloPHj188Fl8hPC+jJMr2siGEiXLqzrpLAHvXh7QfPmWB9ydjuv4OrfsyOXlXXFQjLIDl5MrJjSKzCh9lfz8IXUyIj0yJ9Jhmlo4n83SH+D
 023yD+kz
 pcu0jPYV7miOFLSNMx2BwRmuYfo9JMGaX6+0dSF6O/oBPkmyUTd0u9Olt6rcguEO1NWd4nMkXANw5Cm7IWXRVnn7HE63+EPJZH40CXzDQAf9gRKTk2siLz8LAp8JI3RN3qtSKq0nByEjOcewHgnt0/vCUfkrWG6uqObwboo6IY7Bs/+Wqg4PIYfYenxwQZ9Fxq7N+DJEbXnOqa+uS00ss+I7rfthfHzHtzk6qfjR7m28zhKIFWTYjYTPH9orOyE2cSpQ0++n7fK3q9IU2oOORhgoxetaSQC0VUiADR7h92xGjXQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 03:00:32PM +0100, David Hildenbrand (Red Hat) wrote:
> On 10.11.25 14:47, Matthew Wilcox wrote:
> > On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> > > When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> > > text sections), the pages may still be dirty from recent writes. The
> > 
> > That explanation derails my brain entirely.  Text isn't writable!  How
> > can the pages be dirty and file-backed text?
> 
> Files are writable :)

Well, if you're root ...

-rwxr-xr-x 1 root root 158632 Jun  4 11:14 /bin/ls


