Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1851FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E2B6B0005; Fri, 24 Apr 2026 14:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD9F6B008A; Fri, 24 Apr 2026 14:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3F86B008C; Fri, 24 Apr 2026 14:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6396B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:21:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B71731C010C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:21:54 +0000 (UTC)
X-FDA: 84694268148.08.FDE490F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A05480013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:21:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YTM5dHmh;
	spf=none (imf30.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777054913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR6vNZVk0dPAkPir5/ba6AkbwkyQyimA7C2z0CUF9jY=;
	b=aSFqeUshCJMG7MG9KOyftchuWD+PlKMQcrksCVK3drotOgVgtKpYiDiYEAOV3KTGR/A3wR
	mIJM4DKiUF4hGEu7lWTUWbcmP9fwW3TD6gF1KnqsdLCMfTL5Yk445OeM5qHFNtnGZvMr0t
	BljLklT355v1oWNtq9ajYguTXgINAIQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YTM5dHmh;
	spf=none (imf30.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777054913; a=rsa-sha256;
	cv=none;
	b=MMgsw59vmFOmZjfYTPcjc8Av/vpHmyb54jmIJPzmB4bwj6d3ke413u/8BIqPo0Ucqdl//T
	dm9Ms1cicr1oce59eIwcHbERyd3U1vDvDL4CcmrOAYwNOUg3oVUX0CUb7oPxiASn3fFy4l
	nrZXVcsU0yDCMZn+r/k150qGkb2CL0k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NR6vNZVk0dPAkPir5/ba6AkbwkyQyimA7C2z0CUF9jY=; b=YTM5dHmhKFhPLVD6m7frehsJFM
	mkj+cMbG3hOIBtH3eNMKjFSYlQtfVSqwEbPE9yeoTWzJcBEHHR3aj5pqNEuoZE1bt69PyBlIDjIdM
	KqDjCSSQbbFUI38/J2+55KCaRWVtI01mVaD73WMh6nLoTy3zTbe9voRbhqx5zbTIrlB6z7Rce3m3q
	x4IuSOxw15q7QZE9wkXZE8BOZkHS5oJSpyCqW9oHnEN/E6Udbj9qMeR6kyVwLb74sthaThO0y1H7n
	MDuA4sUYBz7vpKcwCfCWd2aHGplA6xd/2b2IDXW/nAr9YfsSKiBdHG+mL8iBO1mUwHaDbEb5ioymZ
	OaI17/rw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGL9x-0000000DdtV-2Cgk;
	Fri, 24 Apr 2026 18:21:49 +0000
Date: Fri, 24 Apr 2026 14:21:47 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/3] selftests/proc: ensure the test is performed at the
 right page boundary
Message-ID: <j3vswsvp6jp3hopogpc2qqre4mwneeffoutbytlgt6sah2blgz@33rsxbylk7bv>
References: <20260424070234.190145-1-surenb@google.com>
 <20260424070234.190145-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424070234.190145-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A05480013
X-Stat-Signature: o4c715i88636wk3mmncs9jp7jkfwfqq4
X-HE-Tag: 1777054912-549474
X-HE-Meta: U2FsdGVkX1+C/L/CwUToovpYmx1kdflRT0VPEY6IYpvx+Ck5ssAbndjvF8IUxAdWICrEpWjalQDfpILnCyGm/0+D74w8mrSZn4oFtQtAvqJUWNhpXv1VuRLo1fG8FdBGp6LiFoAEKhCZeU4tuneW14pFIJjY5OlTAiSxilxyGXtXqFvZER5yh9mih6fViW6tDJfYXIiuE7wbSv+0lb7BXp0jgu0pq+rFePGGjMNkwVRSXDkSeTsLoQeozqF5wzveA6HEN58lnRn82t8Z8I7AYjBWh7pxcLTxNjyda094sj33CjSPqlvxqXvhXQL5gXQKNGwocxwxg57NU25VLMeOV4mWx529hHxreLKELkf3LmNvBFOJAYpf/l/qa3DWDrhmEtXw6Fl4dqKim6Z3N0TfaXRzNdv3rz1z7gMU84iaDMfVuGVgJPb8lXvDC1sCVlENUWmNZhBLqXYnc1xecryriejySSxh904Z93ocuzma4coOWte6lJgoX5pR4hmwwT7exMYkFyfpDW8y1xsfMiTk1fiqfD61Crae42a+BXYJZJo29Za/w+W+4MiLMhcwI0QHu51aACQIGajxx0SbdKZcDQfhRmussaZAOKXfoXO8e1HzvoOOaJDTtuwYPcjIihJGxWLJXxBU6uc2PEhCMSlq1vy0LC5k5A0V1/8G+ST1ZyT1gnfC9Al7oXCKtwoxmB6fFoD1qN9tJoKzIBn4UBSTfj/RTsrGIVvIJggl6yToRHciMVbqOp1C2NGnRhSzrgojo7e++ZwE81iuM/AmO15OzQYRz/CUJIW2mDzEaDataqhAQ9zwGMvhMRru+HUW82nHpRLdhAq7ftGGVwk2ONGYp9XifcgkC7cCo+koWaCg+ayrQCqZDQwoT1R0spNdk5OEsL//GrJfGbDdjw+Dq9bFuRLa7QQVviLjYyrZHb7b6J1d9Gnm8hUUxCeUa/YOqgO6FjKrvCObxFti9UVVwZT
 gd62jUJ/
 qPpydBwuM13zO3xiWNlQ6tCsvCiAmudD3xJB6aVLET2E1DAgYjzoDbDJINPWzYe+dkECnxDNub5YaszxO36EpTrfrlp2ULaozDJKNZrbtuhYRUIPzoAUUExQwFXeEiw4gNx71B/BOJBm6ujnDnJYWHTNNhEPUhBh0hddqbD1ohk2g/6YOpq7Dk+3JFcrWE8yTVI88dL97LQtTtEYxBT0KhTb+k3uXJLBhNkXTLpZ1aP9xQF5/ICV0rBZpeOT4gjcBn9IuIHb9FRXQZXB9uAetsjWHEmEW0JjN+UPafXrS2GvN/pj2vAz/u+I+U9g5yN5JbXGzA/nsY+rEIU9njy4LaYFwlLCspIFI1WmDoY8wiYz5jTGBpUcqSe6DLLOahN07DFeWS79RrHD2KZ3bKAqn/cZQcHDnSgo4I448ezCYzL0PV1xiYMuxzAGkCQn+ERnk8tUi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> When running tearing tests we need to ensure the pages we use include
> VMAs that were mapped by the child process for this test. Currently we
> always use the first two pages, checking VMAs at their boundaries and
> this works, however once we add tests for /proc/pid/smaps, the first two
> pages might not contain the VMAs that child modifies.
> Locate the page that contains the first VMA mapped by the child and use
> that and the next page for the test.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <liam@infradead.org>

> ---
>  tools/testing/selftests/proc/proc-maps-race.c | 78 ++++++++++++++++---
>  1 file changed, 68 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
> index a734553718da..c5031b0593b7 100644
> --- a/tools/testing/selftests/proc/proc-maps-race.c
> +++ b/tools/testing/selftests/proc/proc-maps-race.c
> @@ -39,6 +39,13 @@
>  #include <sys/types.h>
>  #include <sys/wait.h>
>  
> +#define min(a, b) \
> +	({ \
> +		typeof(a) _a = (a); \
> +		typeof(b) _b = (b); \
> +		_a < _b ? _a : _b; \
> +	})
> +

Another implementation of min in the selftests.  I guess it's somewhat
unavoidable.

>  /* /proc/pid/maps parsing routines */
>  struct page_content {
>  	char *data;
> @@ -77,6 +84,7 @@ FIXTURE(proc_maps_race)
>  	struct line_content first_line;
>  	unsigned long duration_sec;
>  	int shared_mem_size;
> +	int skip_pages;
>  	int page_size;
>  	int vma_count;
>  	bool verbose;
> @@ -105,27 +113,68 @@ struct vma_modifier_info {
>  	void *child_mapped_addr[];
>  };
>  
> -
> -static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
> +static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
> +		      struct page_content *page)
>  {
>  	ssize_t  bytes_read;
>  
> -	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
> +	bytes_read = read(self->maps_fd, page->data, self->page_size);
> +	if (bytes_read <= 0)
>  		return false;
>  
> -	bytes_read = read(self->maps_fd, self->page1.data, self->page_size);
> -	if (bytes_read <= 0)
> +	/* Make sure data always ends with a newline character. */
> +	if (page->data[bytes_read - 1] != '\n')
>  		return false;
>  
> -	self->page1.size = bytes_read;
> +	page->size = bytes_read;
>  
> -	bytes_read = read(self->maps_fd, self->page2.data, self->page_size);
> -	if (bytes_read <= 0)
> +	return true;
> +}
> +
> +static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
> +				  unsigned long addr, unsigned long size)
> +{
> +	unsigned long start, end;
> +	int page = 0;
> +
> +	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
> +		return -1;
> +
> +	while (true) {
> +		char *curr_pos;
> +		char *end_pos;
> +
> +		if (!read_page(self, &self->page1))
> +			return -1;
> +
> +		curr_pos = self->page1.data;
> +		end_pos = self->page1.data + self->page1.size;
> +		while (curr_pos < end_pos) {
> +			if (sscanf(curr_pos, "%lx-%lx", &start, &end) == 2 &&
> +			    start == addr && end == addr + size)
> +				return page;
> +
> +			curr_pos = strchr(curr_pos, '\n');
> +			if (!curr_pos)
> +				break;
> +			curr_pos++;
> +		}
> +		page++;
> +	}
> +
> +	return 0;
> +}
> +
> +static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
> +{
> +	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
>  		return false;
>  
> -	self->page2.size = bytes_read;
> +	for (int i = 0; i < self->skip_pages; i++)
> +		if (!read_page(self, &self->page1))
> +			return false;
>  
> -	return true;
> +	return read_page(self, &self->page1) && read_page(self, &self->page2);
>  }
>  
>  static void copy_first_line(struct page_content *page, char *first_line)
> @@ -418,6 +467,8 @@ FIXTURE_SETUP(proc_maps_race)
>  	struct vma_modifier_info *mod_info;
>  	pthread_mutexattr_t mutex_attr;
>  	pthread_condattr_t cond_attr;
> +	unsigned long first_map_addr;
> +	unsigned long last_map_addr;
>  	unsigned long duration_sec;
>  	char fname[32];
>  
> @@ -502,6 +553,13 @@ FIXTURE_SETUP(proc_maps_race)
>  	self->page2.data = malloc(self->page_size);
>  	ASSERT_NE(self->page2.data, NULL);
>  
> +	first_map_addr = (unsigned long)mod_info->child_mapped_addr[0];
> +	last_map_addr = (unsigned long)mod_info->child_mapped_addr[mod_info->vma_count - 1];
> +
> +	self->skip_pages = locate_containing_page(self,
> +					min(first_map_addr, last_map_addr),
> +					self->page_size * 3);
> +	ASSERT_NE(self->skip_pages, -1);
>  	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
>  
>  	/*
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

