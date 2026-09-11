Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39F0C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47F66B0099; Fri, 11 Sep 2026 15:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8A16B009B; Fri, 11 Sep 2026 15:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1D86B009D; Fri, 11 Sep 2026 15:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 800A76B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:12:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8695EC033B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:12:42 +0000 (UTC)
X-FDA: 85202428164.16.008443E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E9DFE20008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:12:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgJh0y02;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68KFiehfIHvDcGVNGsPrWYIf012K7fCsBnqAtZBD1Hw=;
	b=fsGuSqj6+KGBOCQY0RgaobHX0NnRKexe7VgpQzjlJXmwlbJ1aCuwyO3LtXL8MY818pe/yH
	WaKX1KViIgVhLOVPrZSuVwwOu32ZDYaAIwHAvPCBWu8jgp1hAKEhO5zbeB7EXD5em8B6lX
	rU+0wdh230gtBT6z9F9udueyb9aSLm8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgJh0y02;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789153960;
	b=K8ZoTo7KvyYeHJBUCgtXSjljR+azCqqLTi49Cn+2xpnqJB6KcT9cmUzb4MBH2qBLbaiBZh
	RlNVTjpO1dOyZkTikBvWGA/DQBO+s7VbQUvouhT1I+vV63X6UJj+kSzowQhTYsFp6b//d3
	VkyHNubpvALD2XXS8cLcgmHqOcPDb/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68652600AA;
	Fri, 11 Sep 2026 19:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACB11F000FF;
	Fri, 11 Sep 2026 19:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789153960;
	bh=68KFiehfIHvDcGVNGsPrWYIf012K7fCsBnqAtZBD1Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MgJh0y02DAWbVmlXfPlNkkDtdNLPZcojTJp087N/3g+LYogw6GJmoGQfBHPM6D4xE
	 KaElPdcZ3qfCRK8n7UMrbSLAhuvH28wdV4Q1l8T+/mpEgNHXzlyrRzQ7pXWTxeVOOF
	 NFjYSWEWvmEbHJ3zAlEkZp0vQqSNDQ8iUIRw+Zuz1PWaPqbPaBRXG2e8ilH9yJQdz6
	 5yEojp89jNzi8wbVLK7xPTJUXc7ce8dE0b3349ZufNED7xdd6gIauyQf1gwROuXcbG
	 v0CYdcxH1PbCCpb8WkLyAMJ6TQJlwO7w/UiLqCueljb1w+Oz13s2LyTqEZJCyRFmAl
	 +ITqpGBwQRJ2g==
Date: Fri, 11 Sep 2026 20:12:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] selftests/proc: add /proc/pid/smaps_rollup
 tearing tests
Message-ID: <aqRRpPywkExEyDEw@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-8-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234737.1340642-8-surenb@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9DFE20008
X-Stat-Signature: e7jdz7knoyricy51xexreapyp8f95p5f
X-Rspam-User: 
X-HE-Tag: 1789153960-717519
X-HE-Meta: U2FsdGVkX1/JtgX9aMF6PFgc5bLDNhUNgAi+/DAEBvBhHCgXTR5LalgHKXnaCGvE1zhYKM1VbqLzL8dPWO2bSFIKfXuxr3+RkxXeWDCu+ygXFKZXrUQFxd0RdZMIarz9jbGICnfwpHeG5f2HZTf/RqPNDrV0f4uEEpfHp4X6i6LqPtRJlbytRbu8ROwc+0nwQZRulzxRcDUImx2dMnv1RMGZJtaf5UTd3K9l4AIkmU+hmyJMwhfmIN+0fi1qWATMGWimv0hEBeBLWYweGC/SfydDGjRSe9upzXnIQVsHWuSqdcp1s6b2g/7+3FYQjEavP81rJ3v+sBESaehF/CAmsKDe1MI/Nt4UCEW7sEz+Eh8fj0ItIIE4p6wbqNluwYfYpEKu43q7e7XJnAcu+PqYbwwZMyseNWnhBJVLfPqOOSwKuRF+Wfh/ZMkRWPbF7NMHvG39+M2Yx0Qnep2wSUZvLkzk0e11NWVNmQ5jiFZ8TJMJB5/KYT04sAxoTbDh0AIYgABJFaEZnN1a50XEK2X0JLLY+ZC0EHgzWTFhObLxh6RG5+G/JupX8bdBolevjNkPvuCYoAWaQW7RRccaQ+BdEkT38a3Ej41mfOE8BVGmI+CnVjK65YmpISh/KmCcL/MVjrKM+wmPche7ph1Cgm2LkuyjCiXM2dV11LLbLPkEZf/1LjJf66wWZLgeNtqO1nfpb4RIv69JK3/I1eGOGXovF0o25p0PQcGkaldAu3zDf3Tul/A7dS1Q76OA1sZYLDrLMp6U2E9LBtvWQJghOfz5Ogpkmm4hpRbQZVtvX9G8rjA/WaFW3lg9fhJLTvH1pqMO9MQYMJ+q3UBWn3K0lq+nrZXjZQD6rL9v/gjhFxndg0sYYlbgEdDvd7Yng0gcGtgV1IIBldbHWdspilYEbvBD9pMTHlPTkbJ4QSrxrNj0h/2E+RKW0zyaKBxVrmziNSqd2uqmyw4uqqoooC5AUZu
 rFYBQYfz
 zY8WDdtEBmw3j2VsbviibDA3SRp+4yAbNWbvkamzyCguUYcR8X6HaZAuEL3oMr9MDAN7crB8htuML+rlkCVTcU/pCWXLbG/KwApEeu7PdLvvEeYqS7edkMOh7Fkub22+/ntBplDFfKkHKYA3oIzKYQCfM8hjLCiYvf7NBE/HM6DxIWvHsmTbMbg2a8omygk5n3XILm5qq3GvrVC+XD3Ee3uWrH7nGG1qQtS+p/T+drPzcFLjjtiFjgNMwtaNHE2oGiUVoZlPzXzdeBIqElyna2ukPq8qFrh6XVCkZvSe99BaJ6VHl3k5L+BskkR2CZmjltB2/ybiiyLLxbsWLJzlLwN9PF4EbplMwb2KFXMjEHIE2cjDkZ7WSEiNLbiCaD01MRGMWMEslgAXWSx6WD3vZFsSpwMlsLXiKnACm1WCQ+wYSclA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:47:37PM -0700, Suren Baghdasaryan wrote:
> During tearing tests, smaps_rollup Pss* metrics should stay constant.
> Extend /proc/pid/smaps tearing tests to also check for smaps_rollup
> consistency.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

All looks reasonable an dall passing locally so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

