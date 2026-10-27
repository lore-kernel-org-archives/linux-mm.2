Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ADB606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UDNs964I
Received: by kanga.kvack.org (Postfix)
	id 885566B05DF; Tue, 27 Oct 2026 11:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835346B0739; Tue, 27 Oct 2026 11:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723EE6B074E; Tue, 27 Oct 2026 11:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 431696B05DF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:03:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFA261607D2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:24 +0000 (UTC)
X-FDA: 85368724728.23.22871AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 247EF40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDNs964I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ej+2A3eI9QkEIZfLtqDhWXflwH2CM30fmNauKQbThvQ=;
	b=KfOZlyYo+tuw2hdwLDEDmuROpCXK23lum1nTMA8IW7DLnBDrl/h0OVu6jS+GBpA/n2U/Pi
	wG7amaRqh6AdOeXJ9dHfzL+TunAS5FzUYM7/Hi9hNFH//13JomZ8mSHBMeIX6myQpRc1ut
	MrQtDdNz3uN20l+PYOCjMASRX/RVfLU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDNs964I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113403;
	b=AG555z0RmSnSn1x+HwT57Nri9hZVM/BYAgaZrGdHF7r4B4CeRHsOC9VlfseWgs6eh4n4cJ
	Dfd94V2SNeI6iLslbGLleBgnZYPCkZOZ0i9VBPf+MW+EMFYXuAl+5vwqA9bVrVvB0rh6sX
	8QfHphOrFgLEyWo943r/MW2LQjAssv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41269404CD;
	Tue, 27 Oct 2026 15:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C821F01825;
	Tue, 27 Oct 2026 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793113402;
	bh=Ej+2A3eI9QkEIZfLtqDhWXflwH2CM30fmNauKQbThvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UDNs964InGfq4NmI+D4H6JmyaobQzLcTE30PJnJfMZlFIzKGbmtuUhzYbnv4oRI03
	 VtpFNEVHvFDphOPyprGts94mgXV3YKbbfMzBt5UE4j0DuIbo+XZcM/sYbZABAeM9nX
	 PR7nZzincxdDnTTwSoKjwqS3sL/IG3CA4TZyjMinPsPDEaXVLodjBH6pebQSwjp4mG
	 URJZOf58cy9cO5ywnL3QN5ZDD6CRtry0RVGi56D9KwDs8QCDPchdurnI2XD85ae82T
	 MX9mYDi62989dPYaLLEgz406J1oq0MULkELtpW67Q24Zk1p2wPrRbHs5ddhSJQBJn0
	 snLgtX2hBsVjQ==
Date: Tue, 27 Oct 2026 15:03:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] selftests/mseal_system_mappings: Test vdso unmap and
 remap
Message-ID: <auC7_5XYr31fimvL@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
X-Rspamd-Queue-Id: 247EF40007
X-Stat-Signature: np4fpp3uz9h8sjw86dinarp6ck68trxt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113402-52639
X-HE-Meta: U2FsdGVkX1/uoRwkCXyifXr+1oX4/MgDL2NHBdR83adxcKJr5/mvBFRty+PPO88O6EfmLjyBZhwbkWrNSSp8JWoApc/1328+ZPSaUdVwCdR/4AKBvZrXH9yl6YLPymgGVu89JUH1w4veIBWY8jCXG9m1ECUp0UIPYnFILEQ/8kBI8Z5iZ9Usi/FmXGgZPUq+qnWnwfV8X7xforS5llDK0Z4m3vQv8gBnMDKeiT58E5GlEs0UsSAPzLkj7N8oAwBneyWLVFgp9NaB2wZieY05WQ8logeazjvgEL1nAjGnULx173kBzKCasrwfu6fW02fvulbgVuYuOnu5c+nVIqTrTmRgkOZacSiLZSjpVw2fM7739Z8hRdw7OJHSK8TeKzVRcdRJbC0/N+hJjLT3gjiakviDEMVcpysp7UY4ttT9DSrXNHW/khmJoz7/8zTz34geJQA0D82lDdezIn7CiayovXHfvjGkqLJRKCbJZUD5Svb4YZGJ5ZZBjT0Y7zphLCILUSQvLlZQ+QF+pO3T6QK2MBUCfjEs3Q4QKnpHNjDgAd0dirk6zK+Nhik2VY9Vn5dit/6kw6KmnnveOcyWQASFXyZ55El6WJN/FWfgxLSJCMIZ/7gNTWJdmQ90yLPKFomqA9IemlCQQIkLB6nf4Cvt4SgyQ0oIORhTSR5/SehRURtjxpQHtRkbZPsyVPFwwuoHMb+T9NO/VGvsFQIr2WGCasIRFA5tdVfSB4Ys1DL+99RfV3GgyG7UAKMATQBtnGJA7a+5MMB2DHeB4XvvUM0SvLXzeoQQ8+kRyz7KxkyQn0Qh90oo5ageNWq5SrE+vNiPmDu+m1gckl3FRLyRZiEWElZXY/XIAzB8X2x5zQgUP/hH4EiPv4d85yPJjcPeJK8XoeWv68WLkDUnzNbqGXCmrbI+p+6xef1HdQY86HON8SRtiyUP797sw+OwmwAWHxVS/be/5CvQ828E11Fic6c
 /5/TTF8w
 f5d5fYa15CYN85SVpS65nHJ8QsHcXJzEjIFjsb9u5RUAUhwFJC83ZrLPNRRJNozeYnnUyYmxtbJ/yHGJfPggtOX0Etmf8j1y7Lg4HmVQpAC0+r0ZNLQzmPAXWgP74FF4PvM4Ss4nbRcCErZkLjcIKxmUV6Zn/vTAAsYw206bCF58bQDCVvJ8jK/W04+8Ry4htm9LkwtHF1pb0I24wygPs59qfFbbvZCjce9Mpjmdc2EcwLq4O9GNNSgZq3tdprcW8yooGKgMMLSpoBSWHhrwTTUsHnxqAt3vca5kfpCp7r2p6iUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sorry, in mm we require commit messages. Even for tests :)

On Tue, Oct 27, 2026 at 07:43:25PM +0800, Chris Down wrote:
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  .../mseal_system_mappings/sysmap_is_sealed.c  | 92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
>
> diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> index ea75ad537620..83b4fadfbfe7 100644
> --- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> +++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c

Why on earth does 'mseal_system_mappings' have its own directory...??

Ugh I don't know how I let this stuff go on the original series :/

Please, for the love of all that's sacred, move these tests over to
tools/selftests/mm/. This is an mm feature, for our sins...

You can do the move as a prerequisite patch in the series.

(And, again, I really do insist on your change doing some cleanup here as
 well rather than extending this stuff.)

> @@ -10,6 +10,7 @@
>  #include <unistd.h>
>  #include <string.h>
>  #include <stdbool.h>
> +#include <sys/mman.h>
>  #include <sys/utsname.h>
>  #include <zlib.h>
>
> @@ -232,4 +233,95 @@ TEST_F(basic, check_sealed)
>  	EXPECT_EQ(expected, sealed);
>  };
>
> +static bool find_vdso(unsigned long *start, unsigned long *end)
> +{
> +	char line[MAX_LINE_LEN];
> +	bool found = false;
> +	FILE *maps;
> +
> +	maps = fopen("/proc/self/maps", "r");
> +	if (!maps)
> +		return false;
> +
> +	while (fgets(line, sizeof(line), maps)) {
> +		if (strstr(line, "[vdso]") &&
> +		    sscanf(line, "%lx-%lx", start, end) == 2) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	fclose(maps);
> +	return found;
> +}

There's shared code for this kind of thing, please don't duplicate a
/proc/self/maps thing if unnecessary. Also there's a nicer ioctl interface for
all this.

See vm_utils.[ch].

> +
> +static int vdso_is_sealed(void)
> +{
> +	int sealed = -1;
> +	FILE *maps;
> +
> +	maps = fopen("/proc/self/smaps", "r");
> +	if (!maps)
> +		return -1;
> +	if (has_mapping("[vdso]", maps))
> +		sealed = mapping_is_sealed(maps);
> +	fclose(maps);
> +	return sealed;
> +}
> +
> +/*
> + * Unmapping or moving [vdso] must fail with EPERM when it is sealed. When it
> + * is not sealed, it succeeds and leaves glibc with a stale vdso pointer, which
> + * is fine because each test runs in its own forked child.
> + */
> +TEST(vdso_munmap)
> +{
> +	int sealed;
> +	unsigned long start, end;
> +	int ret;
> +
> +	if (!find_vdso(&start, &end))
> +		SKIP(return, "could not find the mapping, [vdso]");
> +	sealed = vdso_is_sealed();
> +	if (sealed < 0)
> +		SKIP(return, "could not read the [vdso] sealing state");
> +
> +	ret = munmap((void *)start, end - start);
> +	if (sealed) {
> +		EXPECT_EQ(-1, ret);
> +		EXPECT_EQ(EPERM, errno);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +	EXPECT_EQ(sealed, find_vdso(&start, &end));
> +}
> +
> +TEST(vdso_mremap)
> +{
> +	int sealed;
> +	unsigned long start, end, size, new_start;
> +	void *dst, *ret;
> +
> +	if (!find_vdso(&start, &end))
> +		SKIP(return, "could not find the mapping, [vdso]");
> +	sealed = vdso_is_sealed();
> +	if (sealed < 0)
> +		SKIP(return, "could not read the [vdso] sealing state");
> +	size = end - start;
> +
> +	dst = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	ASSERT_NE(MAP_FAILED, dst);
> +
> +	ret = mremap((void *)start, size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
> +		     dst);

I mean arguably this is an mremap test that belongs with mremap? I guess
debatable...

> +	if (sealed) {
> +		EXPECT_EQ(MAP_FAILED, ret);
> +		EXPECT_EQ(EPERM, errno);
> +	} else {
> +		EXPECT_EQ(dst, ret);
> +	}
> +	ASSERT_TRUE(find_vdso(&new_start, &end));
> +	EXPECT_EQ(sealed ? start : (unsigned long)dst, new_start);
> +}
> +
>  TEST_HARNESS_MAIN
> --
> 2.54.0
>

This all just seems like work that should have been done in the past when this
feature was proposed, and doesn't depend on your changes at all AFAICT? Maybe I
missed it though.

Valuable in itself, but probably worth sending separately as a result? Otherwise
it's a little disconnected from the actual change you're making.

--
Cheers, Lorenzo

