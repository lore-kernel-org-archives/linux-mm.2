Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1F0D232D7
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80556B0088; Mon, 12 Jan 2026 04:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E486B0089; Mon, 12 Jan 2026 04:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F6F6B008A; Mon, 12 Jan 2026 04:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1F866B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:34:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58A0B13BA84
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:34:37 +0000 (UTC)
X-FDA: 84322801794.11.6CA1CE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 33ED8140003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:34:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768210475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHjqZxq8Rxm9YJqJ/rHHHus0y6ZvLFd1PGp82VqI4Rk=;
	b=AtE32gyg0c3T5azlRLqcP3De+89SAb+Ha+LtYIHl5Rb1fzbNFscDnsATn53qzonjn25cy6
	2EZOy+is7d0KHhpko7AoAWgaC7b7tt7dbZmnGRM9z3DLkVVKXzsWpVbapWz0Z0o9SgS3ti
	mNHJ4mK9qw52AMcrGk1CVO9zfPUVMkE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768210475; a=rsa-sha256;
	cv=none;
	b=zx4WK7bStBFW/2BiilAR+5nmbnSEnf0EbVx20mL2YVKUQRqyo8pI16sQ8R4myG0+Q51/p9
	616duN3ZXgvvXdm7P4mC/+QN3gt7SP4lgSrc0n4RbEbG/kYhcQJpnDbn4BsVN03XmRnceP
	hS5pEFi7JV+bRzkib2Xfg5jicEfXELg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56DE1339;
	Mon, 12 Jan 2026 01:34:27 -0800 (PST)
Received: from [10.57.95.123] (unknown [10.57.95.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5C9E3F694;
	Mon, 12 Jan 2026 01:34:32 -0800 (PST)
Message-ID: <315a7239-f5ce-474e-bd0d-f1deca3a7b26@arm.com>
Date: Mon, 12 Jan 2026 09:34:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260107164842.3289559-9-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b5mnfb7395m68jaxjm7c6gmu4rmf7q7b
X-Rspam-User: 
X-Rspamd-Queue-Id: 33ED8140003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768210475-489989
X-HE-Meta: U2FsdGVkX18VRvVG4SRMWYqTdwMDWuqNMmh4TQO6s/JCanPKhh2qHmZY0yXkMSk+OoVo2OCL3RC6sSkWEwVkazdLloQfFKlp6ETsrkxiZ8UW7XWicl8EWMRq7Zhty/G1GXpr6TJEzvmq9Vhsi8bZtqyeZCMwVlCLUXXTG5BaXXKJoX9Ql5JZBWQ3GUdfrHhbkUNQBAD/5KpOB4b46HftxB4ygAd1RfOZZteVl11LroXIfJqaAMDpVVB+bRbd+qpU32B5fhxukmtB7SvkXmMlJtCrR3INtjrv0+a3kRxywfCHJcN2hg0Vms+oOHEKXS/KVtQtqOpXvLaYGZBHLzts2zXvmq0FAbXQDUTTqO5zmUAXzwXjKia2krA38DgLCPa++NPbmBoiHAB9aM5wQF4O6DBzsonBr+gIfhwe3A8uHJHft4RYbeK//EQEQt0VzdTMwGgpXGCVJHiLsN4z8JUnv3JuVrOy0eJ8GRlSd/6E0d/OKsBLaiNJXe6EWOVsK4PNJNgyPgCCiDT0L2A0FbvPeHksJM+vCw/+tces/hVzK74LbtJrGanwN0NarV4AOBwSbL/NorOTNIN16a+lCZAj8d9yE+Ht7m11tFvOMPelX7taqrOLlp1Iz2GLXU1x1AFzj70K+ZkUz5b2KWisMobfzp3bzsNjfob9RCakw2uDVS+Ps8VIOZK831Cu73NDb7Ixi10xAuUju+gjpSitpX+xpkKPafNXfAs0+pQWyu9p7ihlzipBYgtFiIsJpIEnrtlsNH+cmZukx5N4lsJREkFjP+/N2BldIMnx191AbvwFheAnVjF56KcKLbdCNzGHGf+6lzUBuh0guAIn8/Bg2awjeDOziGhuvkJwU+mbOHgK28Gfe6ujKNgFek4WnopFK+ZC26ZGcyxib4K+M5taybz4+gO9E3QwLL8B02NbQTMW4rjFM4aRsFk6ugBWKgcc4syoDBf98o86NQVT0oYSHZg
 qkdyko3D
 ncRPmNybWr2HCG+fpmaHLasVQlnHhnCLuWPJQucRvrES+/1H1wDjT8f5fWci//miQzKkmXX0rqQcPz8qXhKI7h3euHM2fqIp4YBUgBAtIorCkew2BYmIwCXmoZ02OTwZnuOb6t2jJhvMrVzK/kKHwlrXL0aEAb9FCW/lEb2otlutYhBWl00wrrs7gMzDI9JoDmsEsr4ugYYsDjI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/01/2026 16:48, Kevin Brodsky wrote:
> pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
> meaning once for every test, and skips the test if any check fails.
> 
> The target file is the same for every test so this is a little
> overkill. More importantly, this approach means that the whole suite
> will report PASS even if all the tests are skipped because kernel
> configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
> being mapped, for instance.
> 
> Let's ensure that KSFT_SKIP is returned as exit code if any check
> fails by performing the checks in pfnmap_init(), run once. That
> function also takes care of finding the offset of the pages to be
> mapped and saves it in a global. The file is still mapped/unmapped
> for every test, as some of them modify the mapping.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  tools/testing/selftests/mm/pfnmap.c | 81 ++++++++++++++++++++---------
>  1 file changed, 55 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index 35b0e3ed54cd..e41d5464130b 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -25,8 +25,11 @@
>  #include "kselftest_harness.h"
>  #include "vm_util.h"
>  
> +#define DEV_MEM_NPAGES	2
> +
>  static sigjmp_buf sigjmp_buf_env;
>  static char *file = "/dev/mem";
> +static off_t file_offset;
>  
>  static void signal_handler(int sig)
>  {
> @@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset,
>  			break;
>  
>  		/* We need two pages. */
> -		if (end > start + 2 * pagesize) {
> +		if (end > start + DEV_MEM_NPAGES * pagesize) {
>  			fclose(file);
>  			*offset = start;
>  			return 0;
> @@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset,
>  	return -ENOENT;
>  }
>  
> +static void pfnmap_init(void)
> +{
> +	size_t pagesize = getpagesize();
> +	size_t size = DEV_MEM_NPAGES * pagesize;
> +	int fd;
> +	void *addr;
> +
> +	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
> +		int err = find_ram_target(&file_offset, pagesize);
> +
> +		if (err)
> +			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
> +				       strerror(-err));
> +	} else {
> +		file_offset = 0;
> +	}
> +
> +	/*
> +	 * Make sure we can open and map the file, and perform some basic
> +	 * checks; skip the whole suite if anything goes wrong.
> +	 * A fresh mapping is then created for every test case by
> +	 * FIXTURE_SETUP(pfnmap).
> +	 */
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
> +
> +	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
> +
> +	if (!check_vmflag_pfnmap(addr))
> +		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
> +
> +	if (test_read_access(addr, size))
> +		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
> +
> +	munmap(addr, size);
> +	close(fd);
> +}
> +
>  FIXTURE(pfnmap)
>  {
> -	off_t offset;
>  	size_t pagesize;
>  	int dev_mem_fd;
>  	char *addr1;
> @@ -112,31 +155,13 @@ FIXTURE_SETUP(pfnmap)
>  {
>  	self->pagesize = getpagesize();
>  
> -	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
> -		/* We'll require two physical pages throughout our tests ... */
> -		if (find_ram_target(&self->offset, self->pagesize))
> -			SKIP(return,
> -				   "Cannot find ram target in '/proc/iomem'\n");
> -	} else {
> -		self->offset = 0;
> -	}
> -
>  	self->dev_mem_fd = open(file, O_RDONLY);
> -	if (self->dev_mem_fd < 0)
> -		SKIP(return, "Cannot open '%s'\n", file);
> +	ASSERT_GE(self->dev_mem_fd, 0);
>  
> -	self->size1 = self->pagesize * 2;
> +	self->size1 = DEV_MEM_NPAGES * self->pagesize;
>  	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
> -			   self->dev_mem_fd, self->offset);
> -	if (self->addr1 == MAP_FAILED)
> -		SKIP(return, "Cannot mmap '%s'\n", file);
> -
> -	if (!check_vmflag_pfnmap(self->addr1))
> -		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);

I wonder if we still want this check per-fd, but upgraded to a fail?

Either way:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> -
> -	/* ... and want to be able to read from them. */
> -	if (test_read_access(self->addr1, self->size1))
> -		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
> +			   self->dev_mem_fd, file_offset);
> +	ASSERT_NE(self->addr1, MAP_FAILED);
>  
>  	self->size2 = 0;
>  	self->addr2 = MAP_FAILED;
> @@ -189,7 +214,7 @@ TEST_F(pfnmap, munmap_split)
>  	 */
>  	self->size2 = self->pagesize;
>  	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
> -			   self->dev_mem_fd, self->offset);
> +			   self->dev_mem_fd, file_offset);
>  	ASSERT_NE(self->addr2, MAP_FAILED);
>  }
>  
> @@ -258,8 +283,12 @@ int main(int argc, char **argv)
>  		if (strcmp(argv[i], "--") == 0) {
>  			if (i + 1 < argc && strlen(argv[i + 1]) > 0)
>  				file = argv[i + 1];
> -			return test_harness_run(i, argv);
> +			argc = i;
> +			break;
>  		}
>  	}
> +
> +	pfnmap_init();
> +
>  	return test_harness_run(argc, argv);
>  }


