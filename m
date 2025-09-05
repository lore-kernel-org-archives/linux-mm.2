Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E1BCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F226B0006; Fri,  5 Sep 2025 09:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36CB8E0008; Fri,  5 Sep 2025 09:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925C26B0011; Fri,  5 Sep 2025 09:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D97F6B0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:35:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C0031401C0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:35:22 +0000 (UTC)
X-FDA: 83855293284.19.C8B1B6F
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD9BC160018
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:35:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B 226WBY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NNnCnrJ9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757079320; a=rsa-sha256;
	cv=none;
	b=zLE4b/I9iVFdxWJG8NCdtBK25fC++VTvt6umgqGTPzOyAzcMV0OxS1bOPJiZlCLuWkj+zo
	bQepRhnXxNQJolJB/TCUmy5Lup2J8/iX7MuzAP6pteEptqfcq09Ch+z3iU0piIH8P6a5LQ
	7DiCgM+AOgG1js570IeBbcVhImnN7Lk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B 226WBY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NNnCnrJ9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757079320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4vjSGJs9Q=;
	b=mZuYb/eR9zjjS/5FQeUmPomLWvfrj5KYyOWQbEGgpLzMIKyA6KujuRBs5iMw0R1hXmOBxY
	usm5qQPs3MeFd0NFJkD+vmgNWCYp4f8aDUbns/jWvOj4+u5g+Ilp7jhQEfQZROzxNPfCfO
	zH+Z4mZTjICf2qKH8JzwlZtjHXs0+Fo=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 2BB12EC040B;
	Fri,  5 Sep 2025 09:35:19 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 05 Sep 2025 09:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757079319; x=
	1757165719; bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4vjSGJs9Q=; b=B
	226WBYwyxCxI5qR7sTMKLd4OqO3G5qzYlDXerCNRFTVEMOGAamZfzJKxjK7WK5VD
	x9U0XwdL4FdgkjUfq6nAU6gnKx4VcUEhSErrl1gjGplXBJu+AEXm4C6SDTvVpMeh
	yYrUG0W9ajzwG5pGZ7Vkym9vQy3FPxSHEwdwixxqGSJJ5CV1r4Bh3KwU7OJIpmT/
	alGjouFMzL2S50SxoLFUbfEIeCIr8pqXzMV0FcN3u9MP/Z0oaZLzqSuyyU5Ty/MB
	+a7qeZ3U+DtjTJs0GvntWVsOrtZi1AS7uY9//1oV9FNv4DOOYnzvCy59bP4Hleee
	asQigJ0avdRxDITzUjE4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757079319; x=1757165719; bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4
	vjSGJs9Q=; b=NNnCnrJ9emwtICgTlEgcKpn4BF71s7+UdWlgjhMVaWUcDHj2H6X
	nzkJ9yW8RQXzvfnEFriqsX0F2xNZccew0igZw5lRLC6WeeCQLWUciYyQUybrW2+f
	g/cpV2MRGgZCI91F6bgYxKAbxlgQEvqHdIc4bzCkcsvFA9l/1nZn2B+FBK2ydzkL
	9fooS6UtwPFp02yDUKgErkOaa9p8+RTphe6OCEkhbKYL1SZb+EiyDB/jhZfkYa42
	B4vb6fOAXeHnHsWzAwnjo9pMwZUU6ovLMFBdN4V3hyCjN3TeE1339p7FjbYhWKzp
	F1n4iQRAhR1NgAEutSr7e/7HJYNy2mzdang==
X-ME-Sender: <xms:Fue6aNXg6kE3t2xqQ_VTEsZKGooodoFWbTFa6Xz9uIG2kGqYDKdSYQ>
    <xme:Fue6aEIiAyeODo8nhVKd6uMgGnV5zU-6gHKHB9J-vsWMU-RiLe9XTYYERwYFt8-5O
    9JbdoMI3A2Rn7t3EPs>
X-ME-Received: <xmr:Fue6aLE_2FKE2HlDjb1YT8isZmGyWBKU-ZquRbmrYEKo9jzvVEA2bxzwbi5H>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeltddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvtddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvsh
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskh
    hvrggtkhdrohhrgh
X-ME-Proxy: <xmx:Fue6aJx2Z3YZ2ogZb6u_fcFSaI0HnrK-agjn8a61SOM5by7aSod-hw>
    <xmx:Fue6aIjgIyNSObyOEsRhGF58q3DqfOEq4a442QfTx766_N9-MRac2Q>
    <xmx:Fue6aGK-vznOcdSz9Z7HjNyrtQDudjvdBKw7Rz1KAwV1M6yp8ay85g>
    <xmx:Fue6aDDz2dbCG-Q5f3I7ecShpEGFFSI39oi53LyHQI1E8dMPy-yeFg>
    <xmx:F-e6aMDQg9RtNquIC-LHZ71Bdl34tiDcoMrbl5oeJ6IDr1dLbAZWbrjJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 09:35:17 -0400 (EDT)
Date: Fri, 5 Sep 2025 14:35:14 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <bhnshjoy2ce332xlxrrgx3rz27etop635csj5cypwlnavvs3yl@rdfd2ujkfkdk>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <f229a315-8b76-4d27-97b9-6ec3103a36e0@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f229a315-8b76-4d27-97b9-6ec3103a36e0@lucifer.local>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DD9BC160018
X-Stat-Signature: rutfy3b3mydqqskp66bwuctswuuxdbt6
X-HE-Tag: 1757079319-457087
X-HE-Meta: U2FsdGVkX18sd1a97376glLbPq7/qgC7U5RIm3MD3Ynjk7dar7HYSk4zJ4yQTPdlvlOy5aPxLu/bFWXmtMP9lwMLaY9dwGQliFYh3xrM3JjPAZ8Jen5361E4YQw6ZLemNHfksHs61/WDqTWfXbSnVCDXYJLevnHwbongjUjYu/TrXoY5DIaVdmaBhgIc1LKbQCjisUcRaObmlPkJI8D8x1JlDpYi06PEJV4jQlexcYdT7NtPIezbMXXKCwpENHSSXUMDep3Jwrm3ETDMhZaSBxeLMLu40x5FIwhvkeLTiNzQIjwZlD9qBJh01QchVAGYBhszcnHJ31FTgGWEhjwMLLLNfda08oVc21SsSzQ76M8GVdPdQTbnKsVINIEfKSSW4rJ79P5oJKq/dC4hCfHWtuP8owqx7WyoGkJHKfD0FGinTc5Zph7NLF7+WnfzHlg14lnlKSiDhigMhh5WdID8WebiJeHrQu7dgI6+uc7L287IM2NAmrUAKSCafNysuJ0i6rX1En4QS0g+lTDzpAChjzKkxaIqrLT4pTducJm2hT2dtM5RzvVy5dxivoPnjHbzz3UyXAdorJoaoEQCVpePuyw4YmEdhzgBBmea9x93myGibx5GMx+QKZ+515SR2aCB/Dayf5QucHs0up1dMmWYOMSPHHIj4IXywKI6x9pXJPQSUTG06uMx/pnA55FY0s0ngzTJHJY6uILt76T5bkR2FyHdn0PhEW80qP5qr4oN5eA2r846z9aFROGezQBVcSAO+tLxWUY5H7M7MKROmIh7xFpvnYeA8xu6mcsr/7pFboh2GioPxQdJQ0d87HtbtMzoO44ooCL1GPNSB9gPCZpM6Bdx7ntiG3heefHElgh3uy4fPn3kZncpxwwXO/MGjoTz2rWBJu66qm4QOxHdQ237Dguwl5cbNaemqKhx7pa+RI1EeM2PUmKwrxM1hhoFao3wJ5ILAoqDAYKUDAuWtQK
 7Aagsdey
 k6DAqLsY9uOO3d8obyysIXHne+QXIPKOBxBNkVx4kOofrIjiXNP+GEpqTyYABDXwV6pt8O+NwKsqG+uB1k33l0m5/UAWx52JMZSR2ZDY45zsmmh3MxxAn6RCeoc0mdFrpHPIV1FeZWOwWyyD0xvS+V1Z/bgDfff9DoMaIorITq6YjUf0mzE5DyDT83EUP594rXwmfEUPr4XRNCdzBTp5YWFRQuQkAAj5LUNVUuqvHMEulyVcaoG026DJXvCGJy/lT49q5TJyZdGCRnX+/ZofFnbAtk08yARB9rZs/7TLCMe1ynEl3CBotWMAaE9EJyBvm4KzfJ4cNPLph5USZAA0jZrXkJYMKUzNsD6bhg2j2hMFS0vS25poCJVebhSaCnLy89ZFjc5awVx5smDNTerG5PJdJiChmNmy7EueD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:37:23AM +0100, Lorenzo Stoakes wrote:
> On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> >
> > Add a simple tool that allows to issue an advice on a process or a file.
> >
> > It can be useful to experiment with effects of an advice on a workload
> > without modifying the workload itself.
> >
> > Only supports advices available for process_madvise().
> 
> It's a mega nit but 'advice' is plural already (also used in the singular
> because English is a troll language but there we go!)

Oof.

> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> This is nice. I really only have nits, so with those addressed LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Thanks for doing this, this is useful! :) may use it myself in fact.
> 
> > ---
> >  tools/mm/.gitignore |   4 +-
> >  tools/mm/Makefile   |   2 +-
> >  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 174 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/mm/madvise.c
> >
> > diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> > index 922879f93fc8..b713fcf4a2e0 100644
> > --- a/tools/mm/.gitignore
> > +++ b/tools/mm/.gitignore
> > @@ -1,4 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > -slabinfo
> > +madvise
> >  page-types
> >  page_owner_sort
> > +slabinfo
> > +thp_swap_allocator_test
> 
> Nice to add this at the same time :)
> 
> > diff --git a/tools/mm/Makefile b/tools/mm/Makefile
> > index f5725b5c23aa..db315a48adcd 100644
> > --- a/tools/mm/Makefile
> > +++ b/tools/mm/Makefile
> > @@ -3,7 +3,7 @@
> >  #
> >  include ../scripts/Makefile.include
> >
> > -BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
> > +BUILD_TARGETS= madvise page-types page_owner_sort slabinfo thp_swap_allocator_test
> >  INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
> >
> >  LIB_DIR = ../lib/api
> > diff --git a/tools/mm/madvise.c b/tools/mm/madvise.c
> > new file mode 100644
> > index 000000000000..038b3e1076ea
> > --- /dev/null
> > +++ b/tools/mm/madvise.c
> > @@ -0,0 +1,170 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <fcntl.h>
> > +#include <limits.h>
> > +#include <stdarg.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <sys/mman.h>
> > +#include <sys/syscall.h>
> > +
> > +static void usage(void)
> > +{
> > +	printf("madvise TARGET ADVICE START END\n\n");
> > +	printf("Arguments:\n");
> > +	printf("\t<TARGET>\n");
> > +	printf("\t\tA process ID or a file to give the advice to.\n\n");
> > +	printf("\t\tUse \"./\" prefix if the file name is all digits.\n\n");
> 
> It kinda sucks to do it this way, why not just default to a file but have a -p
> or --pid param for pid?

I wanted to keep argv parsing trivial, but I can change it.

> > +	printf("\t<ADVICE>\n");
> > +	printf("\t\tcold\t\t- Deactivate a given range of pages\n");
> > +	printf("\t\tcollapse\t- Collapse pages in a given range into THPs\n");
> 
> Is MADV_COLLAPSE useful for a file you map and unmap? Maybe make
> process_madvise() only?

It is actually the primary case I am interested in at the moment:
collapse tmpfs file under workload. It works, but it is very fragile and
fails easily.

MAP_POPULATE is a workaround. We shouldn't require PMD to be present for
file collapse. It also put an question if MADV_COLLAPSE suppouse to
imply populate?

Alignment requirement is also silly for file mapping as we can still
benefit from file collapse due to PMD mapping in other process or from
less entries on LRU.

I also saw -ENOMEMs I cannot explain yet. I don't see why it would give
up easily on allocation.

> > +	printf("\t\tpageout\t\t- Reclaim a given range of pages\n");
> > +	printf("\t\twillneed\t- The specified data will be accessed in the near future\n");
> > +	printf("\n\t\tSee madvise(2) for more details.\n\n");
> > +	printf("\t<START>/<END>\n");
> > +	printf("\t\tStart and end addressed for the advice. Must be page-aligned.\n\n");
> > +	printf("\t\tFor PID case, it is addresses in the target process address space.\n\n");
> > +	printf("\t\tFor file case, it is offsets in the file.\n\n");
> > +}
> > +
> > +static void error(const char *fmt, ...)
> > +{
> > +	if (fmt) {
> > +		va_list argp;
> > +
> > +		va_start(argp, fmt);
> > +		vfprintf(stderr, fmt, argp);
> > +		va_end(argp);
> > +		printf("\n");
> > +	}
> > +
> > +	usage();
> > +	exit(-1);
> > +}
> > +
> > +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> > +static unsigned long read_pmd_pagesize(void)
> > +{
> > +	int fd;
> > +	char buf[20];
> > +	ssize_t num_read;
> > +
> > +	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> > +	if (fd == -1)
> > +		return 0;
> > +
> > +	num_read = read(fd, buf, 19);
> > +	if (num_read < 1) {
> > +		close(fd);
> > +		return 0;
> > +	}
> > +	buf[num_read] = '\0';
> > +	close(fd);
> > +
> > +	return strtoul(buf, NULL, 10);
> > +}
> > +
> > +static int pidfd_open(pid_t pid, unsigned int flags)
> > +{
> > +	return syscall(SYS_pidfd_open, pid, flags);
> > +}
> > +
> > +int main(int argc, const char *argv[])
> > +{
> > +	unsigned long pid, start, end, page_size;
> > +	int advice;
> > +	char *err;
> > +	int fd;
> > +
> > +	if (argc != 5)
> > +		error(NULL);
> > +
> > +	pid = strtoul(argv[1], &err, 10);
> > +	if (*err || err == argv[1] ||
> > +	    pid > INT_MAX || (pid_t)pid <= 0) {
> > +		// Not a PID, assume argv[1] is a file name
> > +		pid = 0;
> > +	}
> > +
> > +	if (pid) {
> > +		fd = pidfd_open(pid, 0);
> > +		if (fd < 0)
> > +			perror("pidfd_open()"), exit(-1);
> > +	} else {
> > +		fd = open(argv[1], O_RDWR);
> > +		if (fd < 0)
> > +			perror("open"), exit(-1);
> > +	}
> > +
> > +	if (!strcmp(argv[2], "cold"))
> > +		advice = MADV_COLD;
> > +	else if (!strcmp(argv[2], "collapse"))
> > +		advice = MADV_COLLAPSE;
> > +	else if (!strcmp(argv[2], "pageout"))
> > +		advice = MADV_PAGEOUT;
> > +	else if (!strcmp(argv[2], "willneed"))
> > +		advice = MADV_WILLNEED;
> > +	else
> > +		error("Unknown advice: %s\n", argv[2]);
> > +
> > +	page_size = sysconf(_SC_PAGE_SIZE);
> > +
> > +	start = strtoul(argv[3], &err, 0);
> > +	if (*err || err == argv[3])
> > +		error("Cannot parse start address\n");
> > +	if (start % page_size)
> > +		error("Start address is not aligned to page size\n");
> > +	end = strtoul(argv[4], &err, 0);
> > +	if (*err || err == argv[4])
> > +		error("Cannot parse end address\n");
> > +	if (end % page_size)
> > +		error("End address is not aligned to page size\n");
> > +
> > +	if (pid) {
> > +		struct iovec vec = {
> > +			.iov_base = (void *)start,
> > +			.iov_len = end - start,
> > +		};
> > +		ssize_t ret;
> > +
> > +		ret = process_madvise(fd, &vec, 1, advice, 0);
> > +		if (ret < 0)
> > +			perror("process_madvise"), exit(-1);
> > +
> > +		if ((unsigned long)ret != end - start)
> > +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
> 
> With a single iovec this should never happen. But I guess no harm in having it.

process_madvise(2):

	The advice might be applied to only a part of iovec...

As caller controls the range, it seems possible to me.

> > +	} else {
> > +		unsigned long addr, hpage_pmd_size;
> > +		void *p;
> > +		int ret;
> > +
> > +		hpage_pmd_size = read_pmd_pagesize();
> > +		if (!hpage_pmd_size) {
> > +			printf("Reading PMD pagesize failed");
> > +			exit(-1);
> > +		}
> > +
> > +		// Allocate virtual address space to align the target mmap to PMD size
> > +		// Some advices require this.
> > +		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
> > +			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> > +		if (p == MAP_FAILED)
> > +			perror("mmap0"), exit(-1);
> > +		addr = (unsigned long)p;
> > +		addr += hpage_pmd_size - 1;
> > +		addr &= ~(hpage_pmd_size - 1);
> > +
> > +		p = mmap((void *)addr, end - start,
> > +			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
> > +		if (p == MAP_FAILED)
> > +			perror("mmap"), exit(-1);
> > +
> > +		ret = madvise(p, end - start, advice);
> > +		if (ret)
> > +			perror("madvise"), exit(-1);
> 
> I mean we exit immediately so it's probably not all that important, but not
> munmap()'ing or closing the fd here.

We have kernel for this :P

> 
> > +	}
> > +
> > +	return 0;
> > +}
> > --
> > 2.50.1
> >
> >

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

