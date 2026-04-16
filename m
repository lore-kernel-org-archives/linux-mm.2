Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E8AF8D76E
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F03A6B0005; Thu, 16 Apr 2026 15:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A0D6B0089; Thu, 16 Apr 2026 15:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241736B008A; Thu, 16 Apr 2026 15:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1025D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:28:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A965616096B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:28:40 +0000 (UTC)
X-FDA: 84665406000.19.626243E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF8E620008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:28:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGulQKW5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776367719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBQ7bDffd9kRNXq9uAO21YhqYs5PArmyePWmdRcWkR8=;
	b=2Y7do2FN9Csy/P/1JZUbDVxSUxZpZJ6idoNpFA+tocG1liumdczSd8aM338QcSvFv9DjUR
	UNpfTXzXy+cFFAQ2t4wkiwMLQdsVmpO1nbT6orlbz2UarY0mKM0O/auhTkBxOoweRLw77W
	U9dXm3rQZ2i+4l7/IkogOP19RyDwvDg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGulQKW5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776367719; a=rsa-sha256;
	cv=none;
	b=tIek7dcTmNb8GUQPWib/KRE0YgdAEVxOYVQbjk+pkYqJ43USdE5FDUZw9mKl1EYXCXQf+1
	9lgH8n+9Xg0K/KYKwPCTcXC9t4PSn1/YLuwoTd8fH8SQfzco3Ozx7FK0wipCg5ZLhr0kzk
	0AMiErcPdpfk4pYlqo8kOI5MYGeWgR8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00F11438EE;
	Thu, 16 Apr 2026 19:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C0C2BCAF;
	Thu, 16 Apr 2026 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776367717;
	bh=jRTCo/i8SIFZppIeH1n3bjiXuMDolHMz2V4AQp2BQeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QGulQKW5kZ+n5r4SXvoSKqk6bPVSNKDaxj3dbtekf1hfKUfo/YJUEGVDxg7EjT67y
	 KTfFyGQLzI+iAMCIKD9FfdblvLT7CLM54Qyr4JFpAXDoFxDIq5+180WtncPEpL+1gj
	 xalrBpjZ3tTFMz/EPYWxMzZr+0a14Ix6xp8ha4yZjG4ELDxT0+xpcQERLDF5iVtoh6
	 2jCFPmo7J0VV6N7yJRHl0hQEEQPI1p6eH7k7NGMc6kwUyWoXCVJ96A3WKyjMY+G0Ka
	 lVmWfgILj0SX77MffWtWZvcyg3RrLqlAAdHl3ETInAfPlid70ioRXNnJ45XzkxhuqU
	 7H7kaprGnW3Pw==
Date: Thu, 16 Apr 2026 22:28:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <aeE4XSuXY8RfphVs@kernel.org>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
X-Stat-Signature: 5isqa53fa83arta9io4earspa64kra3a
X-Rspamd-Queue-Id: EF8E620008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776367718-816920
X-HE-Meta: U2FsdGVkX198IaCUMNbruhqeViQ00BVCBJF5BsH+6oe615eg+0AixQZxOUCmff1qKcSPw5NTSrUxaTNZBiVk8Lyne57TktxEnPlGvxE1G+EPgHpYaOuAftBPK2uzGyqHWXgQBe2VaNTAonaZaY2VjYOciUGR7132RvQmTkdxDLpIk7UoU+Bj9Iz11W5DwTEmW55uAam5RDQpvByajWUttvHXX+ZNFR6cGntR+dD+3sR2u/n86nfgGBq4DiNM4gYQy9UyLmDvF2dzHELtHWxg1gxVgpNVmDCpxYAZuKpoEXKP6HevSmeGmYFQv/sPRwA6bXTnDn2e3kb1sahlR74lEnK2rRGn89G7v9f+C5G6n6r/KowTHJjUfY/2f7VnAfh/vzkOd8hLMXQzxsWM5/Gio+VRqi4BsGEmHaoHaqPfuhzSoFt3KloSMx/kFsXeVnx5qxV86FgfyqZZVevNeAAZIfYDjbA320wU87O8PsSswE3aiXnzuU11rMFO7DrY2ff5cj0hTZOdrbpyQSuO8Ylvkw3qB0U76GRmPhJa8bz5kXDR6McvwtrRblukB5BYjXPDSSLq0PPdNjCQw6JAnDyrsDTrW5mY2wZSv8zYt+95XQ65VUZJ+erwWaUs07OfLsz+YX1XIYe/hHhca8oniDx3i1FuCun8RJ56K3b5Wt6HP7toCigkzjDh0Nztp036ass+dF8uEtd41ouQOX4fiOETQBIfjqXXVaSv5Ja7Lah3NLCQns6+W2UrObt8COBbXDWneen8ZfRmA26je/Rs695MYt63wxQDA2B5/vgD1t+tkMu18hDi96Q8nhFfjHTjdh92uSW36LlZqeCjZyC2BkjjAJ80fb39g56ezknRLce6pLZTKZvteYig4PCh0eDF03sOIM2evSjtpH4o7g2NJ378evG9NgSZ9yB7L2EHbJK5aSeGMHpjySGZHG6IWBgqOZengBWEx/D3i8aID+kGXJv
 pNVEsXRc
 7U2srlTeneLEp0DPazPNHenHect7RgDQ0uqYutYah+N+e4rIYmx5D68/yQ44rNUnxGsQGaPihDu+9oXAmuM7skVkdCr3ITgUwxQHGzAN/rqfzrpo1+PelNYWFdwbk4tfSRziKw+Qyrr+M0Sjq4o1glIsYTTitmAMAs68T5pRQox++PhwQTg2g48cMDi+cfuRxTsEgNtSuKQ86f0SpfiIHBsBGtjrQzn47uBNbbRqios16fbNsiQ8gTGi9J7dGAzezr/Kvpur5iUbXudGxxEASBb3l4OslCxkjt1E41Z610zDBSXzVTPB81akZgi6O6sVnm7lTWYjvdOfU3fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 08:10:53PM +0100, Mark Brown wrote:
> On Thu, Apr 16, 2026 at 09:05:11PM +0200, David Hildenbrand (Arm) wrote:
> > On 4/16/26 20:40, Mark Brown wrote:
> 
> > > Several of the mm selftests made use of /proc/pid/mem as part of their
> > > operation but we do not specify this in the config fragment for them, at
> > > least mkdirty and ksm_functional_tests have this requirement.
> 
> > I guess we could teach most tests to SKIP if /proc/pid/mem is unusable.
> 
> That would be nicer, yes.  I imagine some of these will predate there
> being a configuration option here at all, it's possible there's newer
> tests that skip cleanly - I didn't look at the skips.

Enabling access to /proc/pid/mem keeps the coverage, not that it's great
right now, but still.

But sure graceful skips are better than failing the entire tests. Would be
something like this:

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 8d874c4754f3..374b5a25f36d 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -37,7 +37,6 @@ enum ksm_merge_mode {
 	KSM_MERGE_NONE, /* PRCTL already set */
 };
 
-static int mem_fd;
 static int pages_to_scan_fd;
 static int sleep_millisecs_fd;
 static int pagemap_fd;
@@ -622,10 +621,17 @@ static void test_prot_none(void)
 {
 	const unsigned int size = 2 * MiB;
 	char *map;
+	int mem_fd;
 	int i;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
+	mem_fd = open("/proc/self/mem", O_RDWR);
+	if (mem_fd < 0) {
+		ksft_test_result_skip("opening /proc/self/mem failed\n");
+		return;
+	}
+
 	map = mmap_and_merge_range(0x11, size, PROT_NONE, KSM_MERGE_MADVISE);
 	if (map == MAP_FAILED)
 		goto unmap;
@@ -694,9 +700,6 @@ static void test_fork_ksm_merging_page_count(void)
 
 static void init_global_file_handles(void)
 {
-	mem_fd = open("/proc/self/mem", O_RDWR);
-	if (mem_fd < 0)
-		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
 	if (ksm_stop() < 0)
 		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
 	if (ksm_get_full_scans() < 0)
diff --git a/tools/testing/selftests/mm/mkdirty.c b/tools/testing/selftests/mm/mkdirty.c
index 68dd447a5454..e4a94638018b 100644
--- a/tools/testing/selftests/mm/mkdirty.c
+++ b/tools/testing/selftests/mm/mkdirty.c
@@ -27,7 +27,6 @@
 
 static size_t pagesize;
 static size_t thpsize;
-static int mem_fd;
 static int pagemap_fd;
 static sigjmp_buf env;
 
@@ -86,11 +85,18 @@ static char *mmap_thp_range(int prot, char **_mmap_mem, size_t *_mmap_size)
 static void test_ptrace_write(void)
 {
 	char data = 1;
+	int mem_fd;
 	char *mem;
 	int ret;
 
 	ksft_print_msg("[INFO] PTRACE write access\n");
 
+	mem_fd = open("/proc/self/mem", O_RDWR);
+	if (mem_fd < 0) {
+		ksft_test_result_skip("opening /proc/self/mem failed\n");
+		return;
+	}
+
 	mem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (mem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
@@ -124,10 +130,17 @@ static void test_ptrace_write_thp(void)
 	char *mem, *mmap_mem;
 	size_t mmap_size;
 	char data = 1;
+	int mem_fd;
 	int ret;
 
 	ksft_print_msg("[INFO] PTRACE write access to THP\n");
 
+	mem_fd = open("/proc/self/mem", O_RDWR);
+	if (mem_fd < 0) {
+		ksft_test_result_skip("opening /proc/self/mem failed\n");
+		return;
+	}
+
 	mem = mmap_thp_range(PROT_READ, &mmap_mem, &mmap_size);
 	if (mem == MAP_FAILED)
 		return;
@@ -343,9 +356,6 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(tests);
 
-	mem_fd = open("/proc/self/mem", O_RDWR);
-	if (mem_fd < 0)
-		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("opening /proc/self/pagemap failed\n");

> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Thanks.



-- 
Sincerely yours,
Mike.

