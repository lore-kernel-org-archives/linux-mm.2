Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5DFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC59D6B00A9; Tue, 30 Jun 2026 16:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75FA6B00AB; Tue, 30 Jun 2026 16:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66086B00AC; Tue, 30 Jun 2026 16:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70F306B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:55:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4FC91C35DF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:55:23 +0000 (UTC)
X-FDA: 84937784526.04.A0A144F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C0C980005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:55:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nIdg9WVc;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782852922;
	b=I+64LgLfK1jFvzSKMG2N53COfOgNObVXs7ULvXIZcVT4mblDJJjRYxGgfEkl618tVBaQHb
	vXzd8q1gsO0G/PxS60g3MkD+tjUYttQxwjNAZBZF0W3K+21bC4S37T5ze05QnB8/Sck50U
	+/WuYRrNQ2Py/E/yV86NRNWVhCd1TYs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782852922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqXMviszUJ70wdko7x9w/HLJnkvQD9s/VmU8YDU8zkI=;
	b=M8RTuGvjSRR0Qc2PT/7rYC1rKtJ8J29vkjJumDR4EjWFhC3mUSKiEi3BDhvHZTn0eF96Z6
	/Wv9dj3ZvBVjWu6P77lNVlMP/PbIAHW1a6e9OQ4t1we0IcHDI5EyIRTZfDLP0Xy2lFqAIw
	knRlRo6fbpndcisrjO37baOy/AkBUhg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nIdg9WVc;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 083A44076F;
	Tue, 30 Jun 2026 20:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C2A1F000E9;
	Tue, 30 Jun 2026 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852920;
	bh=PqXMviszUJ70wdko7x9w/HLJnkvQD9s/VmU8YDU8zkI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nIdg9WVcgKuztuJWZsgQgB8qhrK7N0juK0z53//izV+A18lotNu+7Pz/5jMQGMLFy
	 kVKPTUdFinPIsjTZAmG634V62nO9lUIJFNJsmgFSOE7zu2L0AlpVuQSpq2gCxmhvzG
	 /hh3A1WHx/9z1qQaUHx9JqA99cUwh+egfdsAqxGA=
Date: Tue, 30 Jun 2026 13:55:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 lance.yang@linux.dev, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v10 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Message-Id: <20260630135519.404f3be5cb3850a0208f1791@linux-foundation.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dd8mfe73zkncigjra96cr1ia7z8gygw7
X-Rspamd-Queue-Id: 2C0C980005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782852922-355255
X-HE-Meta: U2FsdGVkX18L/NatlXjpfEF04d8xbE0m/4pVjwzYC6PzqgzF//Ah8u8ba08tOFn19x7LB8Oy85xNa1dFUmBNgXuIUN7NMD4+oJIqdVtEz0cLVv+FsSS2klz7muoistYU67uOtNamv/zYwxjuGfUNq7gUYOfwBW7cbWw96FMF5Kn1x2cbLyk24BWw55UiMoCiHCrN0StKWZB8FZrGvXlGeq2aLUqC5x20QJ3xO5TRubG42nCEYH+0F7pIVM46nVBmZ92ae9Q/NmnX2MqJx45/pwzMBsaBL/wgJESv+bZboIu9kUqzvWE0rGs6i7VB3/vH1QEoYe5GQMCVYMrQWbYhdW1IZcIeYUCh+xCyqrhc59+jYBi9/QKMUUOQGCtB+Z3xOkhUX4nHWStpcLcyP5mzcwKy4E8CGu1ePMrC4djBMB7Tsac15MQ3wBh4ITZpGbclThlg9qZARACKXcJ88iBpOb79guuFYnqYK7Ufr0mc7K1gETm6wp5+IO6O+qx055X62tJg8cl2PPFkC/3YFmQfat2Q/W9zbBZyXVinszR0L860+ikHm5XyEX4vaaR6tPT7VhPEWMruailamijkx5rkqdbdl3Pj+DSOqgY+Q5LVRZIS8cPP3XSipkwgFZbQJy4TqbIWsm6j57uWPGoDidioHHGTuf7BzecqsM7eSvhTyH7k2OKAxVnxCFt093IkMbh7AdQqa6qWtl1YiP13ZGoyscPH1B08apGGM6Slb/RTnw0VgRHkN1N4wmI8zmvGYyjI1D+0h2/rwqUop6zlmCG7XPMHhng3fKK78w76W1LQ2BqGLAKJuR4jhhO91daFznVfHEVPeVxJj5lNeBLPLOSQUsyKgcpQmzxERlZq95ZPEV7Ob/du49qDBmutC5P8o5mst1amk3OP7bDaZTbmNrKK9gGaoj8Fe6G8u6CBYjhcdGpCaRbcYSYa3KiEAJO9uesTyJ4zZ/nbfggV9+Y/oTi
 CW6QN83c
 XSeek8vx3QQYzkg+w2/WLrIVXIkxYJ7fpyaCm8skThTpNxM8lm/N+jOvzyUnYcO/XjZObU7IWSROzlQlbF90igKrnbrdkbvSGf1N0JQ9RT+umQ0CijoBMsA53BDPOZS2g8xUTYnvTfPVF/yW1TJi/4kHA3Q6naSQ1MQt2vbrlfFKgEt4L61/x+5eCOkGeWe3Idlns1q+9dnE72DPx1GImxXz2iH6S9EmTYl+qlrAhoncBrVh0kJ7e4b2R2ePiQmJlTQWHXystAA421vRwHuBiHllzwcvz81aL7wPUP45819W82MYz0/dYBhkOPM35BwggdgDLcCIagXN46v6cngopTkqLyouU550p/P+B7/Ym8yCMkqyEz+6h6ZbFF+qm5XEZMF9+q9FKJfVB27QCzML0IfgUWwPxO2Uyw3+mI3gRqnSi43jPLJn9k4VHcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 05:46:03 -0700 Breno Leitao <leitao@debian.org> wrote:

> A multi-bit ECC error on a kernel-owned page that the memory failure
> handler cannot recover is currently swallowed: PG_hwpoison is set, the
> event is logged, and the kernel keeps running.  The corrupted memory
> remains accessible to the kernel and either drives silent data
> corruption or surfaces seconds-to-minutes later as an apparently
> unrelated crash.  In a large fleet that delayed, unattributable crash
> turns into significant engineering effort to root-cause; in a kdump
> configuration, by the time the crash happens the original error
> context (faulting PFN, MCE/GHES record, page state) is long gone.
> 
> This series adds an opt-in sysctl,
> vm.panic_on_unrecoverable_memory_failure, that converts an
> unrecoverable kernel-page hwpoison event into an immediate panic with
> a clean dmesg/vmcore that still contains the original failure
> context.  The default is disabled so existing workloads see no
> change.

Updated, thanks.

Sashiko said things:
	https://sashiko.dev/#/patchset/20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org


> Changes in v10:
> - Reuse kselftest declarations
> - Residual race harmless documentation
> - Link to v9: https://lore.kernel.org/r/20260609-ecc_panic-v9-0-432a74002e74@debian.org

Here's how v10 altered mm.git:


 mm/memory-failure.c                          |    6 +-
 tools/testing/selftests/mm/hwpoison-panic.sh |   42 +++++++++--------
 2 files changed, 28 insertions(+), 20 deletions(-)

--- a/mm/memory-failure.c~b
+++ a/mm/memory-failure.c
@@ -1366,8 +1366,10 @@ static inline bool is_kernel_owned_page(
 	 * Page-type bits live only on the head page, so resolve any tail
 	 * first.  The check takes no refcount; recheck the head afterwards
 	 * so a concurrent split or compound free cannot leave us trusting
-	 * a stale view.  A free->alloc->free in the same window is still
-	 * possible but closing it would require taking a reference here.
+	 * a stale view.  A residual free->alloc->free cannot be closed here
+	 * (frozen slab and large-kmalloc pages cannot be pinned), but is
+	 * harmless: where a wrong verdict could panic, memory_failure() has
+	 * already set PageHWPoison, which bars the page from the allocator.
 	 */
 retry:
 	head = compound_head(page);
--- a/tools/testing/selftests/mm/hwpoison-panic.sh~b
+++ a/tools/testing/selftests/mm/hwpoison-panic.sh
@@ -35,7 +35,11 @@
 
 set -u
 
-ksft_skip=4
+# KTAP output helpers (ktap_print_msg, ktap_skip_all, ktap_exit_fail_msg, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
 sysctl_path=/proc/sys/vm/panic_on_unrecoverable_memory_failure
 inject_path=/sys/devices/system/memory/hard_offline_page
 kpageflags_path=/proc/kpageflags
@@ -53,24 +57,24 @@ pagesize=$(getconf PAGE_SIZE)
 
 kind=${1:-rodata}
 
-ksft_print() { echo "# $*"; }
-ksft_exit_skip() { ksft_print "$*"; exit "$ksft_skip"; }
-ksft_exit_fail() { echo "not ok 1 $*"; exit 1; }
-
 if [ "$(id -u)" -ne 0 ]; then
-	ksft_exit_skip "must run as root"
+	ktap_skip_all "must run as root"
+	exit "$KSFT_SKIP"
 fi
 
 if [ ! -w "$sysctl_path" ]; then
-	ksft_exit_skip "$sysctl_path not present (kernel without the sysctl?)"
+	ktap_skip_all "$sysctl_path not present (kernel without the sysctl?)"
+	exit "$KSFT_SKIP"
 fi
 
 if [ ! -w "$inject_path" ]; then
-	ksft_exit_skip "$inject_path not present (no MEMORY_HOTPLUG?)"
+	ktap_skip_all "$inject_path not present (no MEMORY_HOTPLUG?)"
+	exit "$KSFT_SKIP"
 fi
 
 if [ "${RUN_DESTRUCTIVE:-0}" != "1" ]; then
-	ksft_exit_skip "destructive test; re-run with RUN_DESTRUCTIVE=1 inside a disposable VM"
+	ktap_skip_all "destructive test; re-run with RUN_DESTRUCTIVE=1 inside a disposable VM"
+	exit "$KSFT_SKIP"
 fi
 
 # Pick a PFN inside the kernel image rodata region of /proc/iomem.
@@ -208,21 +212,22 @@ pgtable)
 	missing_msg="no usable page-table PFN found in $kpageflags_path"
 	;;
 *)
-	ksft_exit_fail "unknown kind '$kind' (expected: rodata|slab|pgtable)"
+	ktap_exit_fail_msg "unknown kind '$kind' (expected: rodata|slab|pgtable)"
 	;;
 esac
 
 if [ -z "$phys_addr" ]; then
-	ksft_exit_skip "$missing_msg"
+	ktap_skip_all "$missing_msg"
+	exit "$KSFT_SKIP"
 fi
 
-ksft_print "enabling $sysctl_path"
+ktap_print_msg "enabling $sysctl_path"
 prior=$(cat "$sysctl_path")
-echo 1 > "$sysctl_path" || ksft_exit_fail "failed to enable sysctl"
+echo 1 > "$sysctl_path" || ktap_exit_fail_msg "failed to enable sysctl"
 
 pfn=$((phys_addr / pagesize))
-ksft_print "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (pfn 0x$(printf '%x' "$pfn"), kind=$kind)"
-ksft_print "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
+ktap_print_msg "injecting hwpoison at phys 0x$(printf '%x' "$phys_addr") (pfn 0x$(printf '%x' "$pfn"), kind=$kind)"
+ktap_print_msg "expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'"
 
 # A successful run never returns from the inject -- it panics the kernel.
 # Reaching the code below therefore means no panic fired.  Note whether
@@ -243,7 +248,8 @@ try_unpoison "$pfn"
 # if it raced to another type the run is inconclusive, so skip instead.
 kpageflags_bit_set "$pfn" "$recheck_bit"
 case $? in
-0)	ksft_exit_fail "$verdict (page still $kind)" ;;
-1)	ksft_exit_skip "target PFN no longer $kind; raced before inject, inconclusive" ;;
-*)	ksft_exit_fail "$verdict (could not reconfirm page type via $kpageflags_path)" ;;
+0)	ktap_exit_fail_msg "$verdict (page still $kind)" ;;
+1)	ktap_skip_all "target PFN no longer $kind; raced before inject, inconclusive"
+	exit "$KSFT_SKIP" ;;
+*)	ktap_exit_fail_msg "$verdict (could not reconfirm page type via $kpageflags_path)" ;;
 esac
_


