Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32195C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C836B007B; Fri, 31 Jul 2026 20:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CA26B0088; Fri, 31 Jul 2026 20:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E1D6B008A; Fri, 31 Jul 2026 20:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948D06B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:58:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2136CA10E8
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:58:34 +0000 (UTC)
X-FDA: 85050890148.25.37DB4CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71991140002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:58:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2vjah6U;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785545912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYRQpuzIyMl3zJADWFX5IN1PL3+LNC1In3syVPUK/5Q=;
	b=nL8MHMeqyH/PhQsishnLSMsBRDPrgXAkJgGQia+LCtKm8hIGo2XgLFTwOtzxQOS2uXh1az
	MAJ65OY7R2zlIIVlpDGGt63cAUPs8zvBsOpFuhFaba0Cq6l/cY4gTQze4PPiAbw8YjUQ0I
	LgEzUOlnG137YrTI9IgkeUw0qbwNQR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785545912;
	b=XtlLeReRzTEHZHFsRhIQ7cC2yphYFTgYAmg9j0HstGV+z6ZztxyuC+3SEnmro9mk85XEp2
	g8X4dM6ZS3nQtQ2ZumVNMp4H6C68h9DCXifHnWQigxMn7mq/mgcdWTGbPtDyUbjze5XbER
	5eyLDSOL3KkcW9JideE56EtUcjRfVEQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2vjah6U;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83D543C3A;
	Sat,  1 Aug 2026 00:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D501F00AC4;
	Sat,  1 Aug 2026 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785545910;
	bh=LYRQpuzIyMl3zJADWFX5IN1PL3+LNC1In3syVPUK/5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2vjah6UX4HkhcO/C80E/gRhOBWJZ5SSXbNB0qiZz+WfzvCn3guWvCwnQ4pbpjV16
	 cUVgtuJDxq3ZXRK0l6vidQr5Yc8izrZh1b0MolILgsT0WkFS232GW9DoUeK7g0OLAg
	 3gOJ+tOFkMZRKvgXJh4lH9EG65N+4n57enz2fJ59qymLGd93f88ubVL/x5DYUZMZ9q
	 UiB2STglkP9IEWDUWm/MdrwuU4AWhnGBNA4xHeCRPs/33kxircMfIPWMeVWScITbRK
	 1vRhVer5ahnOMz2Lr7Nyv9BTFUOoxNm7zJah5w/7SxNjxCBamHBqZfzkXqjW26YcC+
	 yB4JTdCqX1zhA==
From: SJ Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kernel-team@meta.com
Subject: Re: [PATCH] tools/mm: add hwpoison-panic tool
Date: Fri, 31 Jul 2026 17:58:22 -0700
Message-ID: <20260801005822.85110-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71991140002
X-Stat-Signature: ntpznaw4tyc7hc9h1ofuedstk9e3iy64
X-HE-Tag: 1785545912-400938
X-HE-Meta: U2FsdGVkX1+xavKShyGhyk1qNRBif98tkNzjmwXHFn1Pckd+s8niQ/WpREoFo0zkyMiby4HIuoPaJ55JbwxV/Z0tLMymDjIjgqlG+LdjW2idSmCda01MqiE0/QnV9vbZpDvl08ctC4HRigFik4dYK8mCiQUkq1krqLLVS8Rktx1orDcz00CLZ7/7j1hmIFSh9lcFLIK8Gkol0mXW+kGGDAKpRd2f/PisV6gPtaeGmOGMfe0JCz32I7spqflB8d91joXeCPSYpsSWnBjiumPFkIDJxd2NFkQdDUd3RzNbX19n+XsvQMmS51P66At2n89x5QL7JXwpw+tstQRf2G6PX1kJjyWrYTzmdy1R9sqqBBQqS7OPQbTmPZN+fa+s0+4vpLuwLABI3+/vlFnQAAizdJ4hNsdQ3Kkro3vTnF3iPdhq2D0+ln65BUpLKFglonFH9sbbcU3Q24binxjS6cexe5VAIUhrTV3qqvLOls0WJK//Sf382UZaLfEQTITOUw7RF383Jz/Z/xoono5oqBRas3ceu3Kw78ax5mhD5ygUtEk6m1tQLYENiF48hhGhSblNk+OWYHass+JiEIdql/NVE5vVBg0L+yY7+NLCMglAlEJ/SK3A7Ufgk3GBmNCroHBir41gmX1oOeWhwjMM8VBTGxJYVug30tIWlhHVzPpa2MDxoGZNxJRYdb+W6B2coSEzc4L/9iKv31SI31e/kFixD/3GWG+073UrogB0FwJJnH4+ln8ktaAZ4j4bPuA84BOOg+CYxUOpDlZDPuytAPTOiSqUeSVkBmLJvqXpdy16JyUL4hmjFOnKW+E1wpoQYctNH8mbb+WnPBFcPDQFSff8B4450Aktg+TGepxvZuoq44nbZQksufLLezTbv2wKgIjJP80m2HeZ4SlTsOHu3+3jXBBT/t/akHlBohw9L+Nx6kWIQltt/j/YSTEt8OUhrRNNAnZeuEpytFY9gBVUJw5
 aJwoq7qW
 Op7IGIjUQIuYFAxarqoXpmwrVpiBc2LO0i01JbM6vI0ssx//UZjWiey+dcXqcPGBvig1VCJa7aolVV1aD+6wq5vwkIO+P676koH6dNvwTj/weqKORbveUJrvul7rXn231JKwNMz6e5QNhabRM42O6ydoX9AxNsw3Xz24vc91KZKeIWHUUoN5vPMMFbs4EhEX/iDC1FZqt742KO4zemiZqYaNkINrGnbPGFlji9yYbLYoq400DLPPmw7lzBnF9gdS1szz8Y2XfZiuBtThCL7IRQf6NI4DHryBG7LLFZu7p4dlbxPgKVDFxnlVfXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 06:16:12 -0700 Breno Leitao <leitao@debian.org> wrote:

> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic  -k slab -f
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.

If the purpose of the new program is testing, would it make more sense to put
it under tools/testing/ ?

Also, does this test really need to be end-to-end test that cause panic?  How
about doing unit test of core functions, using tools like kunit?  Or,
live-patching panic() to only print messages and return before running the
test?

> 
> Argument -f is required so an accidental invocation does not take the
> box down.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  MAINTAINERS                              |   1 +
>  tools/mm/.gitignore                      |   1 +
>  tools/mm/Makefile                        |   2 +
>  tools/mm/memory-failure/hwpoison-panic.c | 353 +++++++++++++++++++++++++++++++
>  4 files changed, 357 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 56b337a064478..799c4883d5b0b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12094,6 +12094,7 @@ F:	include/linux/memory-failure.h
>  F:	include/trace/events/memory-failure.h
>  F:	mm/hwpoison-inject.c
>  F:	mm/memory-failure.c
> +F:	tools/mm/memory-failure/
>  F:	tools/testing/selftests/mm/memory-failure.c
>  
>  HYCON HY46XX TOUCHSCREEN SUPPORT
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 1446a659e5408..b9b80d909db4a 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -3,3 +3,4 @@ slabinfo
>  page-types
>  page_owner_sort
>  thp_swap_allocator_test
> +memory-failure/hwpoison-panic
> diff --git a/tools/mm/Makefile b/tools/mm/Makefile
> index 858186a6eefdb..9f6de957a95a0 100644
> --- a/tools/mm/Makefile
> +++ b/tools/mm/Makefile
> @@ -4,6 +4,7 @@
>  include ../scripts/Makefile.include
>  
>  BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
> +BUILD_TARGETS+=memory-failure/hwpoison-panic

I was initially thought why not underscore but dash on the name?  But, I
realize it is obviously too persoanl taste.

[...]
> diff --git a/tools/mm/memory-failure/hwpoison-panic.c b/tools/mm/memory-failure/hwpoison-panic.c
> new file mode 100644
> index 0000000000000..b8076d86da15b
> --- /dev/null
> +++ b/tools/mm/memory-failure/hwpoison-panic.c
> @@ -0,0 +1,353 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * hwpoison-panic: verify vm.panic_on_unrecoverable_memory_failure by
> + * injecting a hwpoison error on a kernel-owned page and confirming the
> + * kernel panics.

While reading the above explanation, I was expecting this program will directly
say me if the kernel panic-ed or not.  But this only says if it was not
panic-ed iiuc?  How about saying, like, "Trigger intentional kernel panic by
..." ?

No strong opinion.  I'm never a good English reader.

[...]
> +static const struct page_kind *parse_args(int argc, char **argv, int *force)
> +{
> +	const struct page_kind *kind;
> +	const char *name = "rodata";
> +	int c;
> +
> +	while ((c = getopt_long(argc, argv, "k:fh", opts, NULL)) != -1) {
> +		switch (c) {
> +		case 'k':
> +			name = optarg;
> +			break;
> +		case 'f':
> +			*force = 1;
> +			break;
> +		case 'h':
> +			usage();
> +			exit(EXIT_SUCCESS);
> +		default:
> +			usage();
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	kind = lookup_kind(name);
> +	if (!kind)
> +		fatal("unknown kind '%s' (expected: rodata|slab|pgtable)\n",
> +		      name);
> +
> +	return kind;
> +}
> +
> +static void check_prereqs(int force)
> +{
> +	if (geteuid())
> +		fatal("must run as root\n");
> +	if (access(SYSCTL_PATH, W_OK))
> +		fatal("%s not present (kernel without the sysctl?)\n",
> +		      SYSCTL_PATH);
> +	if (access(INJECT_PATH, W_OK))
> +		fatal("%s not present (no MEMORY_HOTPLUG?)\n", INJECT_PATH);
> +	if (!force)
> +		fatal("this panics the kernel; pass -f to run it in a disposable VM\n");

I personally feel like this option is not very intuitive to me.  I think the
name could be better to be intuitive.  Just removing the option also seems fine
to me.  If we really want to warn the brave root user, adding an interactive
prompt (E.g., "This will panic the kernel.  Proceed? [y/N]") also be an
intuitive and safer way in my opinion.

No strong opinion.  My user experience design skill is undoubtedly bad.  Feel
free to keep this as is.

> +}
[...]
> +int main(int argc, char **argv)
> +{
> +	unsigned long phys_addr, pfn, prior;
> +	const struct page_kind *kind;
> +	const char *verdict;
> +	int force = 0;
> +
> +	kind = parse_args(argc, argv, &force);
> +	page_size = getpagesize();
> +	check_prereqs(force);

Maybe check_prereqs() can be called before getpagesize()?

[...]


Thanks,
SJ

