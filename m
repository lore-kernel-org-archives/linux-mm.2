Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F8AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653646B0092; Tue,  8 Sep 2026 14:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C326B0093; Tue,  8 Sep 2026 14:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568A86B0096; Tue,  8 Sep 2026 14:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 328446B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:19:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB3B2A077C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:18:59 +0000 (UTC)
X-FDA: 85191406398.21.F45BC2A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 47A2C16000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:18:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Luj6RHCd;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788891538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Li/ybmICa60a36A5BNtThplp6R00X6RYCrxbOUvrWvU=;
	b=GpYUov+X5H1d36m4Rq0TXmVEh32o/QeJRLMJutalWrrnEe1sm+AU1VYfLqM8JL6FAmbyTO
	vtiTpElpr3U3ke+ZSrfVSYZ1hE4QZsi8tkFlJl2oVYUcpkM0Cahdoiu81FV4T4ae5nqcTn
	zM0ZGudNpDvXu4Tmul3JQj/OdmQWlSU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Luj6RHCd;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788891538;
	b=fRK2iCBQzwaCrg0S4nduXDuNz6oI6nLhZaOtSTuqXXHHr5O8uT28KVQzzASFpppfiKW0G5
	A4GoPAIOUcsB2Q2l9FbPk1l/8BRYFi/RtAYMwAbWeWKtYeFkYng1MoPqX4Jahs8DcT/20t
	e+7ExF8OHbNVTjW86D1DjdyriL8kZuI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Li/ybmICa60a36A5BNtThplp6R00X6RYCrxbOUvrWvU=; b=Luj6RHCddO2eLmRGq1mFZIXKPY
	uFHiwRUEke2ZBWZ7XJ42jcIpuOUZ8tYkRkT8ZgUc7Je4qIzqxSs47vni975PywKADIIY6tv3iArhi
	WOAW4XrekF0VnyUSEOxqYzZe6oP1agV/v2opf+TqB/t0Re52dxJ270OKQTcJTVNALiCsnJvKUs7D/
	7g5OUra4oLYtrk14Bl1WPZP4I2EYgby1WE2nr2Ya9ca9Fnp54+/KVwDJagFm3kGBeEtY4f85ZZBoV
	RhPhrGtZBok50Rt8frrCOgWFvlgdE+sscBqOAJMd1HoaU41x8lqyFZ1PavwlQ/M7oUsNoT65qrHr5
	qsv1Dbxg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x40PF-00000009xMy-3Xbw;
	Tue, 08 Sep 2026 18:18:54 +0000
Date: Tue, 8 Sep 2026 14:18:51 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] selftests/proc: add /proc/pid/smaps_rollup
 tearing tests
Message-ID: <5tivjbxj2nqcgebjxx2lp4lymduaslocdbdibgain6pxtpec5f@dvgvxuod4byt>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-6-surenb@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47A2C16000D
X-Stat-Signature: du19m4h5obnx4nnpyuboqd1ig9pertid
X-Rspam-User: 
X-HE-Tag: 1788891538-21642
X-HE-Meta: U2FsdGVkX1/mzXto0JkrnEf/7350xM/M4oEVqNx/UBRV9GiHfC3C5fVnfclrU2oTnexW8unIATRoFA/xaJHyxZi2mDhEiu9Fyq7HkkEIl9EhBnvtsjv75+94GiAXkMG/wQX9NBEL7fMaANq7SUVaU2NmKUxchUO1gWDg+9EnLh8xwnxxX3etarksyyJLRpylhuUAaELxG5rVsguQXxEDLxx2hSe67pbp7K+PK2bP0aje15eBWq6h0NAADz9+pvAUp+vOTgE31ap9VqnGYRa3aFOt6BbV+LlbMQW3QNCnEH88bQikA1CZoeSkUaK4rqCcnD8Yt4xyqQR/LQaOnAskOX22CMlVeWKhpVJee5WzJM+wsAuEqA4uWf+dWJEeH+3bECutndzIyaC+7MKhpJfXXSQNdzjmkpsVEpYcidxmcfUG35kO2QC55YAPyOJocbnB8+da/3AQw9LcIjI18v+zuCPeB5cfUz/Jj+brawIL4hjUshUclp55Ku8nj4rkOjIwBpNHgm1SGI9wdM1P03jYct8z4gSCAhyo6ngwaTv7FeK6mx/56pdnd1kI55zSVcX8Fox0ve+DRe1fbDbVf2mvONeQG4ZO7lRl+ce2Hc5nWttxj6r+K/HbItjbUsXPXxFAvCs4bmw3PHvP1k1a8jHS4R8uAulJP6a9GDpD8AaCd4luPojqLymLtDhf0v22Z9XwOAtjZ7+vn1J0u2NYPfh+UpjXM0RCOCEuhZa2MfI3mGsiU0jLY3oDygw0RB4nFuaXH5ve+xbWCwSr2x5Tto0aDvL1Ws9qO2/bxLhnBlS3ZXiDclFwe8WCO+RCMIbUNJ4RXZfjI+o6hhzbf9D4CuDO25Bm6h6FKMvoZpEdju9X/g+ahncFDddK8f9jdCSbnjmvX3a1XpBurxQshFuf3HPi/CrkKdGBZ6Ds4MIQXLDzI28EvcsIOMogrdAjXRdOQnWxzgUoERNumUyqcnym2NR
 QoxIOMtN
 jCQUizyTBWX5y7YI5v4f7Dh3/YVcaOAUUuPz3S77NqIADl0vrPt/A+klbXoIuuKJNIQ+AA/yLx7dtRoacMVqIcf500ECOzzLqqRs3gaJyvfa6AHlid2vjxMrB9MPRvazH5/5XQBFsj7/WS1AlI6BUQUjv+nn5YToCUzYMfXuHAeyW3XDeK9w8p7p7idPFT1HnSy+DDUFB+VcBug5dqrh2VHwQDEoRnmvCiK0YEB3dExDAxAu+USyy2wYVYSQjtwF5ylDCrmNKgrZlzSqqIXbh355J7/Urr8mXJCe6zSyBj1+fz4Moh4FA8vLxaJMvrHyfaiz3CM/V18TCCsKem2UOco49kQspxGigyNZOuyeK+eUyrXA4lbLtuwDDPbyFOSft3cOJ4FxVAgGbDgSWcvbNjIbSFj31CG/SvSSX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/06 11:39PM, Suren Baghdasaryan wrote:
> During tearing tests, smaps_rollup Pss* metrics should stay constant.
> Extend /proc/pid/smaps tearing tests to also check for smaps_rollup
> consistency.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++++++++++-
>  1 file changed, 182 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
> index 415eccb70468..8d00d7db1c65 100644
> --- a/tools/testing/selftests/proc/proc-maps-race.c
> +++ b/tools/testing/selftests/proc/proc-maps-race.c
> @@ -80,6 +80,61 @@ enum maps_file {
>  
>  struct vma_modifier_info;
>  
> +enum smaps_rollup_stat {
> +	Rss,
> +	Pss,
> +	Pss_Dirty,
> +	Pss_Anon,
> +	Pss_File,
> +	Pss_Shmem,
> +	Shared_Clean,
> +	Shared_Dirty,
> +	Private_Clean,
> +	Private_Dirty,
> +	Referenced,
> +	Anonymous,
> +	KSM,
> +	LazyFree,
> +	AnonHugePages,
> +	ShmemPmdMapped,
> +	FilePmdMapped,
> +	Shared_Hugetlb,
> +	Private_Hugetlb,
> +	Swap,
> +	SwapPss,
> +	Locked,
> +	RollupFieldCount
> +};
> +
> +static const char *smaps_rollup_stat_names[RollupFieldCount] = {
> +	"Rss",
> +	"Pss",
> +	"Pss_Dirty",
> +	"Pss_Anon",
> +	"Pss_File",
> +	"Pss_Shmem",
> +	"Shared_Clean",
> +	"Shared_Dirty",
> +	"Private_Clean",
> +	"Private_Dirty",
> +	"Referenced",
> +	"Anonymous",
> +	"KSM",
> +	"LazyFree",
> +	"AnonHugePages",
> +	"ShmemPmdMapped",
> +	"FilePmdMapped",
> +	"Shared_Hugetlb",
> +	"Private_Hugetlb",
> +	"Swap",
> +	"SwapPss",
> +	"Locked",
> +};
> +
> +struct smaps_rollup_stats {
> +	unsigned long values[RollupFieldCount];
> +};
> +
>  FIXTURE(proc_maps_race)
>  {
>  	struct vma_modifier_info *mod_info;
> @@ -91,6 +146,7 @@ FIXTURE(proc_maps_race)
>  	enum maps_file maps_file;
>  	int shared_mem_size;
>  	int skip_pages;
> +	int rollup_fd;
>  	int page_size;
>  	int vma_count;
>  	bool verbose;
> @@ -132,12 +188,12 @@ struct vma_modifier_info {
>  	void *child_mapped_addr[];
>  };
>  
> -static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
> +static bool read_page(FIXTURE_DATA(proc_maps_race) *self, int fd,
>  		      struct page_content *page)
>  {
>  	ssize_t  bytes_read;
>  
> -	bytes_read = read(self->maps_fd, page->data, self->page_size);
> +	bytes_read = read(fd, page->data, self->page_size);
>  	if (bytes_read <= 0)
>  		return false;
>  
> @@ -175,7 +231,7 @@ static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
>  		char *curr_pos;
>  		char *end_pos;
>  
> -		if (!read_page(self, &self->page1))
> +		if (!read_page(self, self->maps_fd, &self->page1))
>  			return -1;
>  
>  		curr_pos = self->page1.data;
> @@ -205,10 +261,11 @@ static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
>  		return false;
>  
>  	for (int i = 0; i < self->skip_pages; i++)
> -		if (!read_page(self, &self->page1))
> +		if (!read_page(self, self->maps_fd, &self->page1))
>  			return false;
>  
> -	return read_page(self, &self->page1) && read_page(self, &self->page2);
> +	return read_page(self, self->maps_fd, &self->page1) &&
> +	       read_page(self, self->maps_fd, &self->page2);
>  }
>  
>  static void copy_line(const char *line_start, const char *line_end,
> @@ -317,6 +374,61 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
>  		      &first_line->end_addr) == 2;
>  }
>  
> +static bool parse_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
> +			       struct smaps_rollup_stats *stats)
> +{
> +	unsigned int dev_maj, dev_min, inode;
> +	unsigned long start, end, offs;
> +	unsigned long value;
> +	char name[32], perm[5];
> +	char *curr_pos;
> +	char *end_pos;
> +	char *line_end;
> +
> +	if (lseek(self->rollup_fd, 0, SEEK_SET) < 0)
> +		return false;
> +
> +	if (!read_page(self, self->rollup_fd, &self->page1))
> +		return false;
> +
> +	curr_pos = self->page1.data;
> +	end_pos = self->page1.data + self->page1.size;
> +
> +	line_end = strchr(curr_pos, '\n');
> +	if (!line_end)
> +		return false;
> +
> +	if (sscanf(curr_pos, "%lx-%lx %4s %lx %u:%u %u %31s",
> +		&start, &end, perm, &offs, &dev_maj, &dev_min, &inode, name) != 8)
> +		return false;
> +
> +	if (strcmp(name, "[rollup]"))
> +		return false;
> +
> +	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++) {
> +		int len;
> +
> +		curr_pos = line_end + 1;
> +		if (curr_pos >= end_pos)
> +			return false;
> +
> +		line_end = strchr(curr_pos, '\n');
> +		if (!line_end)
> +			return false;
> +
> +		if (sscanf(curr_pos, "%31s %lu kB", name, &value) != 2)
> +			return false;
> +
> +		len = strlen(name);
> +		if (name[len - 1] != ':' || strncmp(name, smaps_rollup_stat_names[stat], len - 1))
> +			return false;
> +
> +		stats->values[stat] = value;
> +	}
> +
> +	return true;
> +}
> +
>  /* Thread synchronization routines */
>  static void wait_for_state(struct vma_modifier_info *mod_info, enum test_state state)
>  {
> @@ -397,6 +509,41 @@ static bool print_boundaries_on(bool condition, const char *title,
>  	return condition;
>  }
>  
> +static void print_smaps_rollup_stats(const char *title, FIXTURE_DATA(proc_maps_race) *self,
> +				     struct smaps_rollup_stats *stats)
> +{
> +	printf("%s", title);
> +	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++)
> +		printf("%64s %lu kB\n", smaps_rollup_stat_names[stat], stats->values[stat]);
> +}
> +
> +static bool cmp_smaps_rollup_stat(struct smaps_rollup_stats *s1,
> +				  struct smaps_rollup_stats *s2,
> +				  enum smaps_rollup_stat stat)
> +{
> +	return s1->values[stat] == s2->values[stat];
> +}
> +
> +static bool compare_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
> +				 struct smaps_rollup_stats *expected,
> +				 struct smaps_rollup_stats *actual)
> +{
> +	/*
> +	 * Clean/dirty metrics might change but Pss-related ones
> +	 * should stay constant.
> +	 */
> +	if (cmp_smaps_rollup_stat(expected, actual, Pss) &&
> +	    cmp_smaps_rollup_stat(expected, actual, Pss_Anon) &&
> +	    cmp_smaps_rollup_stat(expected, actual, Pss_File) &&
> +	    cmp_smaps_rollup_stat(expected, actual, Pss_Shmem))
> +		return true;
> +
> +	print_smaps_rollup_stats("Expected stats:", self, expected);
> +	print_smaps_rollup_stats("Actual stats:", self, actual);
> +
> +	return false;
> +}
> +
>  static void report_test_start(const char *name, bool verbose)
>  {
>  	if (verbose)
> @@ -572,6 +719,7 @@ FIXTURE_SETUP(proc_maps_race)
>  	unsigned long first_map_addr;
>  	unsigned long last_map_addr;
>  	unsigned long duration_sec;
> +	char rollup_fname[32];
>  	char fname[32];
>  
>  	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
> @@ -649,6 +797,9 @@ FIXTURE_SETUP(proc_maps_race)
>  		break;
>  	case SMAPS:
>  		sprintf(fname, "/proc/%d/smaps", self->pid);
> +		sprintf(rollup_fname, "/proc/%d/smaps_rollup", self->pid);
> +		self->rollup_fd = open(rollup_fname, O_RDONLY);
> +		ASSERT_NE(self->rollup_fd, -1);
>  		break;
>  	default:
>  		ksft_exit_fail();
> @@ -711,6 +862,8 @@ FIXTURE_TEARDOWN(proc_maps_race)
>  	for (int i = 0; i < self->vma_count; i++)
>  		munmap(self->mod_info->child_mapped_addr[i], self->page_size);
>  	close(self->maps_fd);
> +	if (self->maps_file == SMAPS)
> +		close(self->rollup_fd);
>  	waitpid(self->pid, &status, 0);
>  	munmap(self->mod_info, self->shared_mem_size);
>  }
> @@ -723,6 +876,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  	struct line_content split_first_line;
>  	struct line_content restored_last_line;
>  	struct line_content restored_first_line;
> +	struct smaps_rollup_stats orig_stats;
>  
>  	wait_for_state(mod_info, SETUP_READY);
>  
> @@ -736,6 +890,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  	report_test_start("Tearing from split", self->verbose);
>  	ASSERT_TRUE(capture_mod_pattern(self, &split_last_line, &split_first_line,
>  					&restored_last_line, &restored_first_line));
> +	if (self->maps_file == SMAPS)
> +		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
>  
>  	/* Now start concurrent modifications for self->duration_sec */
>  	signal_state(mod_info, TEST_READY);
> @@ -799,6 +955,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  				     vma_end == self->last_line.end_addr) ||
>  				    (vma_start == split_first_line.start_addr &&
>  				     vma_end == split_first_line.end_addr));
> +		} else {
> +			struct smaps_rollup_stats stats;
> +
> +			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
> +			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
>  		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
> @@ -817,6 +978,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  	struct line_content shrunk_first_line;
>  	struct line_content restored_last_line;
>  	struct line_content restored_first_line;
> +	struct smaps_rollup_stats orig_stats;
>  
>  	wait_for_state(mod_info, SETUP_READY);
>  
> @@ -830,6 +992,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  	report_test_start("Tearing from resize", self->verbose);
>  	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
>  					&restored_last_line, &restored_first_line));
> +	if (self->maps_file == SMAPS)
> +		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
>  
>  	/* Now start concurrent modifications for self->duration_sec */
>  	signal_state(mod_info, TEST_READY);
> @@ -880,6 +1044,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
>  				    (vma_end - vma_start == self->page_size * 3 ||
>  				     vma_end - vma_start == self->page_size));
> +		} else {
> +			struct smaps_rollup_stats stats;
> +
> +			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
> +			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
>  		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
> @@ -898,6 +1067,7 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  	struct line_content remapped_first_line;
>  	struct line_content restored_last_line;
>  	struct line_content restored_first_line;
> +	struct smaps_rollup_stats orig_stats;
>  
>  	wait_for_state(mod_info, SETUP_READY);
>  
> @@ -911,6 +1081,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  	report_test_start("Tearing from remap", self->verbose);
>  	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
>  					&restored_last_line, &restored_first_line));
> +	if (self->maps_file == SMAPS)
> +		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
>  
>  	/* Now start concurrent modifications for self->duration_sec */
>  	signal_state(mod_info, TEST_READY);
> @@ -963,6 +1135,11 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  				     vma_end - vma_start == self->page_size * 3) ||
>  				    (vma_start == self->last_line.start_addr + self->page_size &&
>  				     vma_end - vma_start == self->page_size));
> +		} else {
> +			struct smaps_rollup_stats stats;
> +
> +			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
> +			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
>  		}
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
> -- 
> 2.55.0.979.g7e5102b832-goog
> 

