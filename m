Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242E5CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3111A8E0008; Fri,  5 Sep 2025 12:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8EA8E0001; Fri,  5 Sep 2025 12:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE998E0008; Fri,  5 Sep 2025 12:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B468E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:30:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D107F119A42
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:30:53 +0000 (UTC)
X-FDA: 83855735586.14.034E295
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2423160005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:30:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B yJ+FIf";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=X2XmmMHo;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4vjSGJs9Q=;
	b=5LAh7qPQCB2BQ5cHcxBIey0ON788oSCAMipH90cQQKIxhQrEUowrTkee3xGlF7Q5egb5CT
	DHokE2JTEUpkqad8Sv695qSiUCSzzliL86snyRYBVRNK6BwtkiFVVb+/RBhfWj5xZPQj69
	VQJel9v7AScVUgsrBE8l1cf94bVKfHI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B yJ+FIf";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=X2XmmMHo;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757089851; a=rsa-sha256;
	cv=none;
	b=bQl/SIWmtaMqgjwYOcEAY8/nl1fz8COcqSTjsw7HtHvKPihdRRUOeyO6ALpOnxBCkpy2hc
	UCQI9Uf/aVAQzBQ2tQ6M6F0SD9Zg/hn7sh14ALLUjxiuU0HJ9t9ci2vrBedgoRSIwiuoZH
	IW75L7UkKWeC66p/3wViH052qieUSeQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 12BA6140040E;
	Fri,  5 Sep 2025 12:30:51 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 05 Sep 2025 12:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757089851; x=
	1757176251; bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4vjSGJs9Q=; b=B
	yJ+FIfZaANMrFYAagtKrhCZVqVE3VR30JuDhD3eZUMW06b5S741S8jAUGbZkNdYM
	rKmi0UGQS7jPg7UXqY1TgaG0Q5vhLSLgjNyWRUKQE/IIjlOq/0Qj8lFukrYPwjxW
	22Cy54w7CCrJMY+/xJLub6bH1oTTra8XFLCXemY7aE+tqAf+DNw3fNJDQ49zZpX8
	0x5OF8vDfwDTDYFhq1vUjxTx8WEUi9735xnNX5OjWpQJbyBFgcWbqtLDvU3VcZKS
	3QQ0QZbMGvPMcKWfDR0FskLaZB1ygHKwFdQ6N+oJE5mqMe/7cozcdhdEZsFMQcxY
	8rq6k/BHWCwhq7dV1Ax9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757089851; x=1757176251; bh=WvoqT+34WcjwxPrkxl1DFeCqulJwxB+n8f4
	vjSGJs9Q=; b=X2XmmMHopjpk9eEjUFO295TheFMUZ0Dh3rBtzk87C7kk1d1LvJ2
	7tN8jejKUp7tBffuXDXCSvVYVo8vsLOzTOHTu5BXnwk44VWaHRGF30buVnc1SHO6
	ajxWqyWEbgZfz5riiKDla/5wc5HuSeR02eXlKtA3sGSu5DWmMtodH0qZ3/kmnRqd
	CkM1ylzhj/Gt/hxHMFUwgweOPTJw5Z7hkSN1LEGJ8GuSsO1amM0XJo1Jsj52W5Kl
	s1ROlRkZ8aOurwS4ACyfOIjtP57MwZaLNTNWfybAKH2cQPASONwUjzw8Lu/dIGlK
	Szchmywg0v2XMJNrd+Y/8Ad9eMHVXg5quhA==
X-ME-Sender: <xms:OhC7aIVRPWU7urXb0M2gfTgnPpDTn9lW_g9GPmFUSIGxKHea_T11aQ>
    <xme:OhC7aDI9m8SYROm_qWdMVZrqBjFtEijt5ic9dDUggLN86LNyYdd24UWW5t71ZZmoP
    5LZy5a82wYnb_lE7MI>
X-ME-Received: <xmr:OhC7aOFXDwrOtMuT7F781OShxUCq8MeGnWzozX61f2pKiGDmXnra_MxpJs-OwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdelfeejucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:OhC7aAzj1-RkyrTN1Dms2iVOKT7-sXN__lZg6K2fwsoI56uUxUz2SA>
    <xmx:OhC7aDisrkHrAjMf-YrrYwYLVh6I1nvSbIjxKEwoEReWi9vuzeytFA>
    <xmx:OhC7aFKYGFQ6vu5byVGDhfjR6OwN0PWk7pJbjSi08z7k87C8u__L7Q>
    <xmx:OhC7aGBevOuD4RD1k8TXo8Gdo9TLi9OHN1U1S0OmTPYXDCIP2L5-Fg>
    <xmx:OxC7aPDOGBrEQoLFZbqdoGfUPqCYg-RmKSvgOue8BwMxdwK0bCnIFmF->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Sep 2025 12:30:49 -0400 (EDT)
Date: Fri, 5 Sep 2025 17:30:47 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <zdh2h3lkd4kv6yt7cnxlomb4nvavjgpwvq4bralbzpt4mefofy@sdhkf6g3t4qu>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <f229a315-8b76-4d27-97b9-6ec3103a36e0@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f229a315-8b76-4d27-97b9-6ec3103a36e0@lucifer.local>
X-Rspamd-Queue-Id: C2423160005
X-Rspam-User: 
X-Stat-Signature: u9ieiajtjjmoa7fiq7ftotgghoiq6e6p
X-Rspamd-Server: rspam09
X-HE-Tag: 1757089851-672293
X-HE-Meta: U2FsdGVkX1+tWCTlmHeYg4D9KSNGOvNUIR7oraNdwc/pVAdqfJEnIJjeedaTDbn8Wrf4Xi0Uo7PwI6iDsG8iRoVziguqSnOO73KE/7nUSVhs/XBBbivkziAlgJiOBXrxepryDqqnB6xnVq3ZQA2RjIiAh8AIBdffE4k4GhAAGlWz6Fi4PTK48OlIE/WQpkJusabGbJxqde0SBJM2463qh+IvHqOP9orpmjtGiBXNGhxzm8O8vm7YmguqlwvSXUj2WUcUgBOBybkGGDG5CBukSeIWn8IwW5x+45etojNfaJgdTPwoVhooAB1ZBWytohOz1U+EzFI93y8LZRGMfSeA9uMxzyExw9Ax4rDZgM2DuW6juHgctfhztHJLxiL7LVb43ItcmjyQ+cihgwvbNoAAXjK6cZZEP7kOT9A9Lv/DrkQCREPbaXJqnoMPAlqTQlsx8bbsT0YchK4cTFGot/96pR3YLvXCg6StdiJWBn1zbIGbL/N5KAk0Yz0wUQ+e5olrjk6fT7bFUvRYAMl1aG7hlEdowplIQ1LearbhyjBUebwnDoAXwoXOmDhRwAKfJCcsSmcoTX1XMQpjljTuAlvqHjAsGlEaRGyzo+bnOJ4ZFPPeUta1CWQ+UTci120g7VxoZWnAguwCpLip0UigcguZBH9roODpa4icPfVZxh5g4zarLFUlQKP5szx0BDHWarZeJGa7oKgFn7ZIAHkCgyzZ2f3RHzJSofVK6sVnXyAcSZds1VNiHhTiod7QUqpNymj/iJ9+cAlOu1JEnSvMz2uX1J8qnkXyWEgk5YQG2tCPr5UkJXxMraV8iY6BelCZUD7R5SgRgC/2ba4B5ZxLeYGe/K16aAqwsqTbe/mpcf8/MYhZFb7/QrGrkgrFWXhe5bT1AJA50SsvU4KCjHbdr29kT0uPpjNbYBBDmdT10847dsjdNHBQv9+nS2UM7wGO6g9uWV8BtsIzpvdPWpxeuyZ
 jV5lXaFc
 t1pesmWCGwiUQl5UPN+FJMUeh7ArW5Cy3I1ef3oDVhXGranr7T3bsd5+TD/xSCm71Sap9to/9gjfm1yYzhNFTwq3mP33fFmynY85hE1rPd707NIAQja/GSwrnvj879mzt2HAWHdpGojG7+vCY5qgGF4lVEuEG+pv/CyxcD/lY8sAE0YzOW4QKmCmdOB/3hWHhbw0TyguX6jm4s3w2AkRgI7CsNGfbRgkfBoteh4fWDowuaL5fyr1AkQV4S77ZBIu8myyj6fi8De8GBsXLgaKRh/2tu/wqdKjXNUony1bT4Ww8DlX/y+dVhJ3lHouV3+VDlw1NnNfHRW7C0TRRpzzmaoFFco0XAEBQWhvFFoOZzJTU6q1kuL4++4f520hhNJEAET+r0fkMPitJnsCHUEeDZaWRTtkc7ODGKJRU
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

