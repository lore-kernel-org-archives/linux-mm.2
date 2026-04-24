Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E4BFED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D578B6B0005; Fri, 24 Apr 2026 14:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1616B008A; Fri, 24 Apr 2026 14:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA8C6B008C; Fri, 24 Apr 2026 14:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A23EB6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:23:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF9D21602F1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:23:50 +0000 (UTC)
X-FDA: 84694273020.29.533433F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E355C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:23:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dHRi0OcS;
	spf=none (imf28.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHmkC1PpzrOj3aa7cR/k5HER8pUMmXZ13ybCvJpbXxY=;
	b=j9y2L8onz/YzBW9LQrfI9IX6o4AiESlflU9FFadG65m2ItvEqw0D8r6+tBrF5giN76nknr
	F3gVEqrJsf54p12jpX6/B2DLu2OCsGC34dz3Ta8LK9xO+LGkjhF4rawNBJQgCcgC+yeFVn
	u9mEpbmEhX7wums1Fwd8OW3PrUorpOU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dHRi0OcS;
	spf=none (imf28.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055029; a=rsa-sha256;
	cv=none;
	b=COHEQSWwFKtmJtUVZ3Lw5WJ26JCyUcBhVjGcRs3y8hxnC43W5yranLpNB9bUGqLt8vRtU+
	GXoTWz5pAIFoM3D6ViE4QNOZSyjWjJnFyBIellR6Y61lOCVTCxb4PuV2+aZ2S5V7p+WX3A
	t0642cxC/11f+Ij1teeNRxlyIKl7oKM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wHmkC1PpzrOj3aa7cR/k5HER8pUMmXZ13ybCvJpbXxY=; b=dHRi0OcS4B46i0eR7NtQPZMguw
	F78uOcGHZcuruDxtl+pDS6qwIvrOirqySnnDqrM5t+7be/EQFHCVJeMumOJn4Bmy1/Unsc871qUpS
	yBNgM1Hri0HxWY8nPIqia0IxU5YuIasZbaFti4R7h+T/SGjkGOtDinjzTtmYUUKOZb/vYOv2c0p05
	S2YyF6M6GuljMjvXImLTc249o8bVObxvZ+i4CV+5UHBgC6VmL0w0NYtAAchhHEG0DmerIZtKtmwWS
	Gpi1x9r0x80GWbElko6JZrsVyv+HutB79JrfoxVZbosGa2AUzNa2UCISnDC1y7NDKXFFvLMHD4qge
	g0yHWDWw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGLBo-0000000DdxS-2GcF;
	Fri, 24 Apr 2026 18:23:44 +0000
Date: Fri, 24 Apr 2026 14:23:42 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/3] selftests/proc: add /proc/pid/smaps tearing tests
Message-ID: <qxxhshfoe5tph4z324fzl74r532bxdrdvll2xvhaeken6bsdwb@q2wk2nbvxr3p>
References: <20260424070234.190145-1-surenb@google.com>
 <20260424070234.190145-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424070234.190145-4-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E355C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: a1u4xwwbbsgswgx8esanjo913ujgu5eh
X-HE-Tag: 1777055028-818557
X-HE-Meta: U2FsdGVkX18L0zdjeV1DJin41AaY6UjS0mmLKk8LFwTPjea/LjD35NW/vSfu4Dx66GWI5gMhqgEZVsvSUIWqF0XPLKRm/cx3KDmrqxO1svPfcaPBP60QZYGwqrXX9wC+Uj6uaHsOK6c1xqRsbL354nlje9nl1z5J3gJUQtSMAtG7x7dKDM9kVei76WAGAs5G1Guuf1wMJcSdK328sEmWkXJWK/69GUiX0Pn1pBGNinDcmOuzcuPoS1EY366A7Oj58T+CPSR9nAcbG9mftY5CnTsb0mT6i+qQvaVzoWP6z1nnmeye04QAMU1z5fzuxi1sVm4oU1RiRmfR4DL8hpOsnXeLrw0CzifvCUbUfFcXDwq1xz7ePHgHEDsNgRNeIt8486eSGDa9iBuZ6cEpitoPzlW4cEBnZQO4JDxwDplUDnI8i8p2yXnHeWfvfzwwPU2pVkDd/8ylAid5tUsEwLcB7n2FIhrQ+b97vUKnO9Nuw2PQQ8IYB8QpqAurwUZ0KXU+W3zUefH+cpopkfL+jwxHQ/VJ6pglAIuwVOeOGa1FACn6SztrjX4evu7KyCVUnhK6MOB7/Cj32Nz/2wAdM0N8ZG6kBtLKDcF8S7h+uSiwJpy9KOPF4oubkUMumK8jI0Yz7+6Gw0tkbpI8xRbfJKay3pxlzr4Cb7ABfH3rlWeCzf2+NbnjsLJwBZhVg/y7tEGQclKwMuRW/ddkSE9447A0nTHsVwX6Y0sqesQCei7iQxGenEdGZgIXB9pjbquWU0TSdQYWMjV2m1WY8gYD6JlNSaynyc3bsUlStVXvg5oYFEcwIv4mbfzywmUIdFMaPWu3fTkyPNmU+3/MAA3f2Hc2mQ76KR7wOEP4x3XKb2r5CVztBLIZfPDXhFLALq/93XGn1nizCkHEeemeWzp2vX/ZZ6b3n0/LXwhgfrDfpOCyUnoJiqch3t/zi1U0OPgyHeUmHpGoQ+zh+6xhCBw2p5y
 bWfYXvjB
 UoyITqlmPpWIBAfx5UcnrqjXktS8AMUsvjA9fAa1rMDReq7b3c5oTCt8I2HiTp5FfzeJ8CL4TnSN161fpxKpLzQv+pA4HNxpimVWoHdkU4tZjHpEjZrqaPP/NLGrpRkNeiPdxrZ4YWf48bpvyVh86YdSGJAMZNNncBzTAjKz14qyuas0RGgXjyT3OOLhdsb5X8rQngUKaUxibktWwuPu/Maln5C4eetwIFbSpkC2H1eD0zn8H9PssGGCnATVsViZsMz+1EHONI5L2Kc4qKoKlcVals/7kWs9HcPpiJVrCU9ukUZnpvFylRvbAupqUOFKtAbVn4hlO8hkHCJU9HN74kpoKA04/JLzLQbat/jJayRLPWdUc1NvwwepL4B+kmlQ/dXx8UfavXCJnntKcW63689HXsmBl+JdRoMASSa9G6ArjUTnTsQ28EvfX/TV0gIbR8IKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/24 12:02AM, Suren Baghdasaryan wrote:
> Add MAPS_FILE environment variable to select whether the tests to be run
> for /proc/pid/maps or /proc/pid/smaps. Add support for testing smaps file
> by reusing the same logic as with maps file but skipping all the data
> except for the VMA addresses, which are the only part relevant for the
> tearing tests. Skip PROCMAP_QUERY parts of the tests because smaps does
> not implement that ioctl.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

One comment question, otherwise..

Reviewed-by: Liam R. Howlett <liam@infradead.org>

> ---
>  tools/testing/selftests/proc/proc-maps-race.c | 176 +++++++++++++-----
>  1 file changed, 132 insertions(+), 44 deletions(-)
> 
> diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
> index c5031b0593b7..b677bc23cab9 100644
> --- a/tools/testing/selftests/proc/proc-maps-race.c
> +++ b/tools/testing/selftests/proc/proc-maps-race.c
> @@ -17,8 +17,8 @@
>   */
>  /*
>   * Fork a child that concurrently modifies address space while the main
> - * process is reading /proc/$PID/maps and verifying the results. Address
> - * space modifications include:
> + * process is reading /proc/$PID/maps and /proc/$PID/smaps, verifying the
                                         ^^^ and? Should this be or?  It
                                         doesn't match your commit
                                         message.


> + * results. Address space modifications include:
>   *     VMA splitting and merging
>   *
>   */
> @@ -73,6 +73,11 @@ enum test_state {
>  	TEST_DONE,
>  };
>  
> +enum maps_file {
> +	MAPS,
> +	SMAPS,
> +};
> +
>  struct vma_modifier_info;
>  
>  FIXTURE(proc_maps_race)
> @@ -83,6 +88,7 @@ FIXTURE(proc_maps_race)
>  	struct line_content last_line;
>  	struct line_content first_line;
>  	unsigned long duration_sec;
> +	enum maps_file maps_file;
>  	int shared_mem_size;
>  	int skip_pages;
>  	int page_size;
> @@ -199,6 +205,57 @@ static void copy_last_line(struct page_content *page, char *last_line)
>  	last_line[end - pos] = '\0';
>  }
>  
> +static bool copy_first_entry(struct page_content *page, char *first_line)
> +{
> +	const char *start_pos = page->data;
> +
> +	while (start_pos < page->data + page->size) {
> +		unsigned long start_addr;
> +		unsigned long end_addr;
> +		char *end_pos;
> +
> +		end_pos = strchr(start_pos, '\n');
> +		if (!end_pos)
> +			break;
> +
> +		if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) == 2) {
> +			strncpy(first_line, start_pos, end_pos - start_pos);
> +			first_line[end_pos - start_pos] = '\0';
> +			return true;
> +		}
> +
> +		start_pos = end_pos + 1;
> +	}
> +
> +	return false;
> +}
> +
> +static bool copy_last_entry(struct page_content *page, char *last_line)
> +{
> +	const char *end_pos = page->data + page->size - 1;
> +	const char *start_pos;
> +
> +	while (end_pos > page->data) {
> +		unsigned long start_addr;
> +		unsigned long end_addr;
> +
> +		/* skip last newline */
> +		start_pos = end_pos - 1;
> +		/* search previous newline */
> +		while (start_pos > page->data && start_pos[-1] != '\n')
> +			start_pos--;
> +		if (sscanf(start_pos, "%lx-%lx", &start_addr, &end_addr) == 2) {
> +			strncpy(last_line, start_pos, end_pos - start_pos);
> +			last_line[end_pos - start_pos] = '\0';
> +			return true;
> +		}
> +
> +		end_pos = start_pos - 1;
> +	}
> +
> +	return false;
> +}
> +
>  /* Read the last line of the first page and the first line of the second page */
>  static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
>  				struct line_content *last_line,
> @@ -207,8 +264,16 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
>  	if (!read_two_pages(self))
>  		return false;
>  
> -	copy_last_line(&self->page1, last_line->text);
> -	copy_first_line(&self->page2, first_line->text);
> +	if (self->maps_file == MAPS) {
> +		copy_last_line(&self->page1, last_line->text);
> +		copy_first_line(&self->page2, first_line->text);
> +	} else if (self->maps_file == SMAPS) {
> +		if (!copy_last_entry(&self->page1, last_line->text) ||
> +		    !copy_first_entry(&self->page2, first_line->text))
> +			return false;
> +	} else {
> +		return false;
> +	}
>  
>  	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
>  		      &last_line->end_addr) == 2 &&
> @@ -464,6 +529,7 @@ FIXTURE_SETUP(proc_maps_race)
>  {
>  	const char *verbose = getenv("VERBOSE");
>  	const char *duration = getenv("DURATION");
> +	const char *maps_file = getenv("MAPS_FILE");
>  	struct vma_modifier_info *mod_info;
>  	pthread_mutexattr_t mutex_attr;
>  	pthread_condattr_t cond_attr;
> @@ -474,6 +540,18 @@ FIXTURE_SETUP(proc_maps_race)
>  
>  	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
>  	self->verbose = verbose && !strncmp(verbose, "1", 1);
> +	if (maps_file) {
> +		if (!strcmp(maps_file, "maps")) {
> +			self->maps_file = MAPS;
> +		} else if (!strcmp(maps_file, "smaps")) {
> +			self->maps_file = SMAPS;
> +		} else {
> +			ksft_print_msg("Unknown maps file %s\n", maps_file);
> +			ksft_exit_fail();
> +		}
> +	} else {
> +		self->maps_file = MAPS;
> +	}
>  	duration_sec = duration ? atol(duration) : 0;
>  	self->duration_sec = duration_sec ? duration_sec : 5UL;
>  
> @@ -540,7 +618,16 @@ FIXTURE_SETUP(proc_maps_race)
>  		exit(0);
>  	}
>  
> -	sprintf(fname, "/proc/%d/maps", self->pid);
> +	switch (self->maps_file) {
> +	case MAPS:
> +		sprintf(fname, "/proc/%d/maps", self->pid);
> +		break;
> +	case SMAPS:
> +		sprintf(fname, "/proc/%d/smaps", self->pid);
> +		break;
> +	default:
> +		ksft_exit_fail();
> +	}
>  	self->maps_fd = open(fname, O_RDONLY);
>  	ASSERT_NE(self->maps_fd, -1);
>  
> @@ -675,20 +762,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  		last_line_changed = strcmp(new_last_line.text, self->last_line.text) != 0;
>  		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
>  		ASSERT_EQ(last_line_changed, first_line_changed);
> -
> -		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> -		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> -					  &vma_start, &vma_end));
> -		/*
> -		 * The vma at the split address can be either the same as
> -		 * original one (if read before the split) or the same as the
> -		 * first line in the second page (if read after the split).
> -		 */
> -		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> -			     vma_end == self->last_line.end_addr) ||
> -			    (vma_start == split_first_line.start_addr &&
> -			     vma_end == split_first_line.end_addr));
> -
> +		if (self->maps_file == MAPS) {
> +			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> +			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> +						  &vma_start, &vma_end));
> +			/*
> +			 * The vma at the split address can be either the same as
> +			 * original one (if read before the split) or the same as the
> +			 * first line in the second page (if read after the split).
> +			 */
> +			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> +				     vma_end == self->last_line.end_addr) ||
> +				    (vma_start == split_first_line.start_addr &&
> +				     vma_end == split_first_line.end_addr));
> +		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> @@ -758,17 +845,18 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  					strcmp(new_first_line.text, restored_first_line.text),
>  					"Expand result invalid", self));
>  		}
> -
> -		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> -		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
> -		/*
> -		 * The vma should stay at the same address and have either the
> -		 * original size of 3 pages or 1 page if read after shrinking.
> -		 */
> -		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
> -			    (vma_end - vma_start == self->page_size * 3 ||
> -			     vma_end - vma_start == self->page_size));
> -
> +		if (self->maps_file == MAPS) {
> +			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> +			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr,
> +						  &vma_start, &vma_end));
> +			/*
> +			 * The vma should stay at the same address and have either the
> +			 * original size of 3 pages or 1 page if read after shrinking.
> +			 */
> +			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
> +				    (vma_end - vma_start == self->page_size * 3 ||
> +				     vma_end - vma_start == self->page_size));
> +		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> @@ -838,20 +926,20 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  					strcmp(new_first_line.text, restored_first_line.text),
>  					"Remap restore result invalid", self));
>  		}
> -
> -		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> -		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> -					  &vma_start, &vma_end));
> -		/*
> -		 * The vma should either stay at the same address and have the
> -		 * original size of 3 pages or we should find the remapped vma
> -		 * at the remap destination address with size of 1 page.
> -		 */
> -		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> -			     vma_end - vma_start == self->page_size * 3) ||
> -			    (vma_start == self->last_line.start_addr + self->page_size &&
> -			     vma_end - vma_start == self->page_size));
> -
> +		if (self->maps_file == MAPS) {
> +			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> +			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> +						  &vma_start, &vma_end));
> +			/*
> +			 * The vma should either stay at the same address and have the
> +			 * original size of 3 pages or we should find the remapped vma
> +			 * at the remap destination address with size of 1 page.
> +			 */
> +			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> +				     vma_end - vma_start == self->page_size * 3) ||
> +				    (vma_start == self->last_line.start_addr + self->page_size &&
> +				     vma_end - vma_start == self->page_size));
> +		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

