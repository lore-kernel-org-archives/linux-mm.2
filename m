Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D3CF506C6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3D36B024D; Mon, 16 Mar 2026 08:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70B96B0256; Mon, 16 Mar 2026 08:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73346B0258; Mon, 16 Mar 2026 08:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A12BF6B024D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:55:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37D0B160119
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:55:21 +0000 (UTC)
X-FDA: 84551922042.12.6895692
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9710816000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:55:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z39RpONo;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773665719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6xlAPVceefTSVYtnnCEUOoqotfcgckQMsCVyWwZg9o=;
	b=k7OF+0QJHHEX6Atqv0uUdeEpHthPAZ9oJVyMiInNUkkD6f4mR/GxhuYmd5fJTw4mS++ndY
	3b0wFPq/h8eKsmYoESbTWhfdVohNWKaIUheaFNNSN/dJK1WeqMK2ZJaoJet5OQyP9KRbTP
	xZlqjZFqbo3qn1amgyoW96IrMkNnraU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773665719; a=rsa-sha256;
	cv=none;
	b=f8wLGCF3/k6gP47uPQ3gnJyicbptpBFi5+wsEyLjLbxnRZrCyVHt1JGcigYDNGfnY5C379
	EwZC53ju51thIKegBjQg+JNv+LVzYa3zFOO1COcp3WULqITKCAChMk5i91ZcYB5mIR9ICa
	NRF6teIPmHprNAZ0SYor/jxMvawdD4E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z39RpONo;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB6A3437DA;
	Mon, 16 Mar 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B54DC19421;
	Mon, 16 Mar 2026 12:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773665718;
	bh=wHy8V+LzWLdTTdVeoapl4IuD4+RQ0hST4UcCMU5AgZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z39RpONoiVYxUZa7MI6oWQituJ5LRTSk8y0i9dQw/bnCgMabaWD1Hy3sUAuq5s+ga
	 KBwfqXD/EDRwYnFaXt7GxuDTjnYfcmoFBwPDbvbir2gHa2jAK7UdiYBgqF2+u1Bev1
	 sg0a1iGSSA4Srob48C/4Jluz3q30LfXexA/Xb29pRYVVKQyGuW/inoMWpz4e5WdoCk
	 7gw/HuL8dl3NKmE63phBxq3wdwxkH3/WagYMMoWL2K4erIT30ykL8pAtNv9NWLYs3i
	 yyBC1mKVAJv45SqOQdC32jUdXREki2xcjZezgWSqEY+ns14jGNdwLj2uz94iQoPnJv
	 lsKTUsukiSf8A==
Date: Mon, 16 Mar 2026 12:55:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
X-Stat-Signature: 4q6s7z58qkqy1m8ur1s3xoi8fio6n6mh
X-Rspam-User: 
X-Rspamd-Queue-Id: 9710816000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773665719-749583
X-HE-Meta: U2FsdGVkX191EwtPvhsSPucJ7s4zYZtw0F4SQXR62POESwUgKAP4JGRfYRva0tHHuW5HT+fQ1rwB/NjdX5igO905qN8eiE05JK6c4jgt/+XcUqKrNXO82QwsfyAiOB/M9CS0+L8nuGQkVcxEZ3dC7pNcwdEpMeYDoGU+Ry7yK9pEkkrru2CqTp1k3Thjgl/sK5RRPHoZbMQaoVL/tOfPAWtc8piMmgxn0Tgy9cRzklornQKFVrquefEr13GbQtI+oJtZMusVCO3aFXVv9JZdJeYRQL2RU2qmBFH2tbXLZKrxhIokgTb7GCO8gRkODb5nqyfq+HHohphtmkZwyE9e1cZXpM2q+ya5BrIUaEJQAsH1cY+n7k6mt5c2emN/J7t201jTLkYKg6KEULfBHOsgQZFq/IWKYG82Tms3dZVCLQIXxqa1uX0q5fuq4czhFYmJ8v+/GO7Ij8FDj7QS6mHFYFhTZZdZFrw/JE3lZPbLa8XIOpRwQmwdNY3TyJNzFPHTaIbyOZOgtMDcZDdj5hLHVtVdlJjw20F5xx2uKup6kO+fHcBRdTbgcZ+dIPXyzTPWxQNwkOHq7vCMjjJAf87SGbaTlqyzlyQ9ODIuyd5pTotI0QdYMgeVO/F47k3xrcmsByL0MzVehpq+3zsMVctUpJ/QQQVEyPRU4UqUbpc/4PYlzaGvV1habyqHyx/JkeSETBizEuBLckSfr3DdtYWiGyxBcdHbLCvNIiEyGNU2a0nM+qewx2X9AAHnGvnTIJIdYDzYyZzULRYw4nZD4+ZcwS+91NF5n07oSf3hW7X5Fgvc95IfofN3nTwbDmNNn/X91zc12I81/CPQc7264BbxSNPS6olZqUhP2qCzbRZANKNR/2zjGPGaQ5vNf9T29VGa4lFkZHiik74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> Add a shell-based selftest that exercises the full set of THP sysfs
> knobs: enabled (global and per-size anon), defrag, use_zero_page,
> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> khugepaged/ tunables, and per-size stats files.
>
> Each writable knob is tested for valid writes, invalid-input rejection,
> idempotent writes, and mode transitions where applicable. All original
> values are saved before testing and restored afterwards.
>
> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> structured TAP 13 output, making results parseable by the kselftest
> harness. The test plan is printed at the end since the number of test
> points is dynamic (depends on available hugepage sizes and sysfs files).
>
> This is particularly useful for validating the refactoring of
> enabled_store() and anon_enabled_store() to use sysfs_match_string()
> and the new change_enabled()/change_anon_orders() helpers.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

The test is broken locally for me, returning error code 127.

I do appreciate the effort here, so I'm sorry to push back negatively, but I
feel a bash script here is pretty janky, and frankly if any of these interfaces
were as broken as this it'd be a major failure that would surely get picked up
far sooner elsewhere.

So while I think this might be useful as a local test for your sysfs interface
changes, I don't think this is really suited to the mm selftests.

Andrew - can we drop this change please? Thanks!

Thanks, Lorenzo

> ---
> While working on the THP sysfs interface, I noticed there were no
> existing tests covering this functionality. This patch adds test
> coverage that may be useful for upstream !?
> ---
>  tools/testing/selftests/mm/Makefile          |   1 +
>  tools/testing/selftests/mm/run_vmtests.sh    |   2 +
>  tools/testing/selftests/mm/thp_sysfs_test.sh | 666 +++++++++++++++++++++++++++
>  3 files changed, 669 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 7a5de4e9bf520..90fcca53a561b 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -180,6 +180,7 @@ TEST_FILES += charge_reserved_hugetlb.sh
>  TEST_FILES += hugetlb_reparenting_test.sh
>  TEST_FILES += test_page_frag.sh
>  TEST_FILES += run_vmtests.sh
> +TEST_FILES += thp_sysfs_test.sh
>
>  # required by charge_reserved_hugetlb.sh
>  TEST_FILES += write_hugetlb_memory.sh
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index afdcfd0d7cef7..9e0e2089214a3 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -491,6 +491,8 @@ CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>
>  CATEGORY="thp" run_test ./transhuge-stress -d 20
>
> +CATEGORY="thp" run_test ./thp_sysfs_test.sh
> +
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if [ "${HAVE_HUGEPAGES}" = "1" ]; then
> diff --git a/tools/testing/selftests/mm/thp_sysfs_test.sh b/tools/testing/selftests/mm/thp_sysfs_test.sh
> new file mode 100755
> index 0000000000000..407f306a0989f
> --- /dev/null
> +++ b/tools/testing/selftests/mm/thp_sysfs_test.sh
> @@ -0,0 +1,666 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Test THP sysfs interface.
> +#
> +# Exercises the full set of THP sysfs knobs: enabled (global and
> +# per-size anon), defrag, use_zero_page, hpage_pmd_size, shmem_enabled
> +# (global and per-size), shrink_underused, khugepaged/ tunables, and
> +# per-size stats files.  Each writable knob is tested for valid writes,
> +# invalid-input rejection, idempotent writes, and mode transitions
> +# where applicable.  All original values are saved before testing and
> +# restored afterwards.
> +#
> +# Author: Breno Leitao <leitao@debian.org>
> +
> +DIR="$(dirname "$(readlink -f "$0")")"
> +. "${DIR}"/../kselftest/ktap_helpers.sh
> +
> +THP_SYSFS=/sys/kernel/mm/transparent_hugepage
> +
> +# Read the currently active mode from a sysfs enabled file.
> +# The active mode is enclosed in brackets, e.g. "always [madvise] never"
> +get_active_mode() {
> +	local path="$1"
> +	local content
> +
> +	content=$(cat "$path")
> +	echo "$content" | grep -o '\[.*\]' | tr -d '[]'
> +}
> +
> +# Test that writing a mode and reading it back gives the expected result.
> +test_mode() {
> +	local path="$1"
> +	local mode="$2"
> +	local label="$3"
> +	local active
> +
> +	if ! echo "$mode" > "$path" 2>/dev/null; then
> +		ktap_test_fail "$label: write '$mode'"
> +		return
> +	fi
> +
> +	active=$(get_active_mode "$path")
> +	if [ "$active" = "$mode" ]; then
> +		ktap_test_pass "$label: write '$mode'"
> +	else
> +		ktap_test_fail "$label: write '$mode', read back '$active'"
> +	fi
> +}
> +
> +# Test that writing an invalid mode is rejected.
> +test_invalid() {
> +	local path="$1"
> +	local mode="$2"
> +	local label="$3"
> +	local saved
> +
> +	saved=$(get_active_mode "$path")
> +
> +	if echo "$mode" > "$path" 2>/dev/null; then
> +		# Write succeeded -- check if mode actually changed (it shouldn't)
> +		local active
> +		active=$(get_active_mode "$path")
> +		if [ "$active" = "$saved" ]; then
> +			# Some shells don't propagate the error, but mode unchanged
> +			ktap_test_pass "$label: reject '$mode'"
> +		else
> +			ktap_test_fail "$label: '$mode' should have been rejected but mode changed to '$active'"
> +		fi
> +	else
> +		ktap_test_pass "$label: reject '$mode'"
> +	fi
> +}
> +
> +# Test that writing the same mode twice doesn't crash or change state.
> +test_idempotent() {
> +	local path="$1"
> +	local mode="$2"
> +	local label="$3"
> +
> +	echo "$mode" > "$path" 2>/dev/null
> +	echo "$mode" > "$path" 2>/dev/null
> +	local active
> +	active=$(get_active_mode "$path")
> +	if [ "$active" = "$mode" ]; then
> +		ktap_test_pass "$label: idempotent '$mode'"
> +	else
> +		ktap_test_fail "$label: idempotent '$mode', got '$active'"
> +	fi
> +}
> +
> +# Write a numeric value, read it back, verify match.
> +test_numeric() {
> +	local path="$1"
> +	local value="$2"
> +	local label="$3"
> +	local readback
> +
> +	if ! echo "$value" > "$path" 2>/dev/null; then
> +		ktap_test_fail "$label: write '$value'"
> +		return
> +	fi
> +
> +	readback=$(cat "$path" 2>/dev/null)
> +	if [ "$readback" = "$value" ]; then
> +		ktap_test_pass "$label: write '$value'"
> +	else
> +		ktap_test_fail "$label: write '$value', read back '$readback'"
> +	fi
> +}
> +
> +# Verify that an out-of-range or invalid numeric value is rejected.
> +test_numeric_invalid() {
> +	local path="$1"
> +	local value="$2"
> +	local label="$3"
> +	local saved readback
> +
> +	saved=$(cat "$path" 2>/dev/null)
> +
> +	if echo "$value" > "$path" 2>/dev/null; then
> +		readback=$(cat "$path" 2>/dev/null)
> +		if [ "$readback" = "$saved" ]; then
> +			ktap_test_pass "$label: reject '$value'"
> +		else
> +			ktap_test_fail "$label: '$value' should have been rejected but value changed to '$readback'"
> +		fi
> +	else
> +		ktap_test_pass "$label: reject '$value'"
> +	fi
> +}
> +
> +# Verify a read-only file: readable, returns a numeric value, rejects writes.
> +test_readonly() {
> +	local path="$1"
> +	local label="$2"
> +	local val
> +
> +	val=$(cat "$path" 2>/dev/null)
> +	if [ -z "$val" ]; then
> +		ktap_test_fail "$label: read returned empty"
> +		return
> +	fi
> +
> +	if ! echo "$val" | grep -qE '^[0-9]+$'; then
> +		ktap_test_fail "$label: expected numeric, got '$val'"
> +		return
> +	fi
> +
> +	if echo "0" > "$path" 2>/dev/null; then
> +		local after
> +		after=$(cat "$path" 2>/dev/null)
> +		if [ "$after" = "$val" ]; then
> +			ktap_test_pass "$label: read-only (value=$val)"
> +		else
> +			ktap_test_fail "$label: write should have been rejected but value changed"
> +		fi
> +	else
> +		ktap_test_pass "$label: read-only (value=$val)"
> +	fi
> +}
> +
> +# --- Precondition checks ---
> +
> +ktap_print_header
> +
> +if [ ! -d "$THP_SYSFS" ]; then
> +	ktap_skip_all "THP sysfs not found at $THP_SYSFS"
> +	exit "$KSFT_SKIP"
> +fi
> +
> +if [ "$(id -u)" -ne 0 ]; then
> +	ktap_skip_all "must be run as root"
> +	exit "$KSFT_SKIP"
> +fi
> +
> +# --- Test global THP enabled ---
> +
> +GLOBAL_ENABLED="$THP_SYSFS/enabled"
> +
> +if [ ! -f "$GLOBAL_ENABLED" ]; then
> +	ktap_test_skip "global enabled file not found"
> +else
> +	ktap_print_msg "Testing global THP enabled ($GLOBAL_ENABLED)"
> +
> +	# Save current setting
> +	saved_global=$(get_active_mode "$GLOBAL_ENABLED")
> +
> +	# Valid modes for global
> +	test_mode "$GLOBAL_ENABLED" "always" "global"
> +	test_mode "$GLOBAL_ENABLED" "madvise" "global"
> +	test_mode "$GLOBAL_ENABLED" "never" "global"
> +
> +	# "inherit" is not valid for global THP
> +	test_invalid "$GLOBAL_ENABLED" "inherit" "global"
> +
> +	# Invalid strings
> +	test_invalid "$GLOBAL_ENABLED" "bogus" "global"
> +	test_invalid "$GLOBAL_ENABLED" "" "global (empty)"
> +
> +	# Idempotent writes
> +	test_idempotent "$GLOBAL_ENABLED" "always" "global"
> +	test_idempotent "$GLOBAL_ENABLED" "never" "global"
> +
> +	# Restore
> +	echo "$saved_global" > "$GLOBAL_ENABLED" 2>/dev/null
> +fi
> +
> +# --- Test global defrag ---
> +
> +GLOBAL_DEFRAG="$THP_SYSFS/defrag"
> +
> +if [ ! -f "$GLOBAL_DEFRAG" ]; then
> +	ktap_test_skip "defrag file not found"
> +else
> +	ktap_print_msg "Testing global THP defrag ($GLOBAL_DEFRAG)"
> +
> +	saved_defrag=$(get_active_mode "$GLOBAL_DEFRAG")
> +
> +	# Valid modes
> +	test_mode "$GLOBAL_DEFRAG" "always" "defrag"
> +	test_mode "$GLOBAL_DEFRAG" "defer" "defrag"
> +	test_mode "$GLOBAL_DEFRAG" "defer+madvise" "defrag"
> +	test_mode "$GLOBAL_DEFRAG" "madvise" "defrag"
> +	test_mode "$GLOBAL_DEFRAG" "never" "defrag"
> +
> +	# Invalid
> +	test_invalid "$GLOBAL_DEFRAG" "bogus" "defrag"
> +	test_invalid "$GLOBAL_DEFRAG" "" "defrag (empty)"
> +	test_invalid "$GLOBAL_DEFRAG" "inherit" "defrag"
> +
> +	# Idempotent
> +	test_idempotent "$GLOBAL_DEFRAG" "always" "defrag"
> +	test_idempotent "$GLOBAL_DEFRAG" "never" "defrag"
> +
> +	# Mode transitions: cycle through all 5
> +	echo "always" > "$GLOBAL_DEFRAG"
> +	test_mode "$GLOBAL_DEFRAG" "defer" "defrag (always->defer)"
> +	test_mode "$GLOBAL_DEFRAG" "defer+madvise" "defrag (defer->defer+madvise)"
> +	test_mode "$GLOBAL_DEFRAG" "madvise" "defrag (defer+madvise->madvise)"
> +	test_mode "$GLOBAL_DEFRAG" "never" "defrag (madvise->never)"
> +	test_mode "$GLOBAL_DEFRAG" "always" "defrag (never->always)"
> +
> +	# Restore
> +	echo "$saved_defrag" > "$GLOBAL_DEFRAG" 2>/dev/null
> +fi
> +
> +# --- Test use_zero_page ---
> +
> +USE_ZERO_PAGE="$THP_SYSFS/use_zero_page"
> +
> +if [ ! -f "$USE_ZERO_PAGE" ]; then
> +	ktap_test_skip "use_zero_page file not found"
> +else
> +	ktap_print_msg "Testing use_zero_page ($USE_ZERO_PAGE)"
> +
> +	saved_uzp=$(cat "$USE_ZERO_PAGE" 2>/dev/null)
> +
> +	# Valid values
> +	test_numeric "$USE_ZERO_PAGE" "0" "use_zero_page"
> +	test_numeric "$USE_ZERO_PAGE" "1" "use_zero_page"
> +
> +	# Invalid values
> +	test_numeric_invalid "$USE_ZERO_PAGE" "2" "use_zero_page"
> +	test_numeric_invalid "$USE_ZERO_PAGE" "-1" "use_zero_page"
> +	test_numeric_invalid "$USE_ZERO_PAGE" "bogus" "use_zero_page"
> +
> +	# Idempotent
> +	echo "1" > "$USE_ZERO_PAGE" 2>/dev/null
> +	test_numeric "$USE_ZERO_PAGE" "1" "use_zero_page (idempotent)"
> +	echo "0" > "$USE_ZERO_PAGE" 2>/dev/null
> +	test_numeric "$USE_ZERO_PAGE" "0" "use_zero_page (idempotent)"
> +
> +	# Restore
> +	echo "$saved_uzp" > "$USE_ZERO_PAGE" 2>/dev/null
> +fi
> +
> +# --- Test hpage_pmd_size ---
> +
> +HPAGE_PMD_SIZE_FILE="$THP_SYSFS/hpage_pmd_size"
> +
> +if [ ! -f "$HPAGE_PMD_SIZE_FILE" ]; then
> +	ktap_test_skip "hpage_pmd_size file not found"
> +else
> +	ktap_print_msg "Testing hpage_pmd_size ($HPAGE_PMD_SIZE_FILE)"
> +
> +	test_readonly "$HPAGE_PMD_SIZE_FILE" "hpage_pmd_size"
> +fi
> +
> +# --- Test global shmem_enabled ---
> +
> +SHMEM_ENABLED="$THP_SYSFS/shmem_enabled"
> +
> +if [ ! -f "$SHMEM_ENABLED" ]; then
> +	ktap_test_skip "shmem_enabled file not found (CONFIG_SHMEM not set?)"
> +else
> +	ktap_print_msg "Testing global shmem_enabled ($SHMEM_ENABLED)"
> +
> +	saved_shmem=$(get_active_mode "$SHMEM_ENABLED")
> +
> +	# Valid modes
> +	test_mode "$SHMEM_ENABLED" "always" "shmem_enabled"
> +	test_mode "$SHMEM_ENABLED" "within_size" "shmem_enabled"
> +	test_mode "$SHMEM_ENABLED" "advise" "shmem_enabled"
> +	test_mode "$SHMEM_ENABLED" "never" "shmem_enabled"
> +	test_mode "$SHMEM_ENABLED" "deny" "shmem_enabled"
> +	test_mode "$SHMEM_ENABLED" "force" "shmem_enabled"
> +
> +	# Invalid
> +	test_invalid "$SHMEM_ENABLED" "bogus" "shmem_enabled"
> +	test_invalid "$SHMEM_ENABLED" "inherit" "shmem_enabled"
> +	test_invalid "$SHMEM_ENABLED" "" "shmem_enabled (empty)"
> +
> +	# Idempotent
> +	test_idempotent "$SHMEM_ENABLED" "always" "shmem_enabled"
> +	test_idempotent "$SHMEM_ENABLED" "never" "shmem_enabled"
> +
> +	# Mode transitions: cycle through all 6
> +	echo "always" > "$SHMEM_ENABLED"
> +	test_mode "$SHMEM_ENABLED" "within_size" "shmem_enabled (always->within_size)"
> +	test_mode "$SHMEM_ENABLED" "advise" "shmem_enabled (within_size->advise)"
> +	test_mode "$SHMEM_ENABLED" "never" "shmem_enabled (advise->never)"
> +	test_mode "$SHMEM_ENABLED" "deny" "shmem_enabled (never->deny)"
> +	test_mode "$SHMEM_ENABLED" "force" "shmem_enabled (deny->force)"
> +	test_mode "$SHMEM_ENABLED" "always" "shmem_enabled (force->always)"
> +
> +	# Restore
> +	echo "$saved_shmem" > "$SHMEM_ENABLED" 2>/dev/null
> +fi
> +
> +# --- Test shrink_underused ---
> +
> +SHRINK_UNDERUSED="$THP_SYSFS/shrink_underused"
> +
> +if [ ! -f "$SHRINK_UNDERUSED" ]; then
> +	ktap_test_skip "shrink_underused file not found"
> +else
> +	ktap_print_msg "Testing shrink_underused ($SHRINK_UNDERUSED)"
> +
> +	saved_shrink=$(cat "$SHRINK_UNDERUSED" 2>/dev/null)
> +
> +	# Valid values
> +	test_numeric "$SHRINK_UNDERUSED" "0" "shrink_underused"
> +	test_numeric "$SHRINK_UNDERUSED" "1" "shrink_underused"
> +
> +	# Invalid values
> +	test_numeric_invalid "$SHRINK_UNDERUSED" "2" "shrink_underused"
> +	test_numeric_invalid "$SHRINK_UNDERUSED" "bogus" "shrink_underused"
> +
> +	# Restore
> +	echo "$saved_shrink" > "$SHRINK_UNDERUSED" 2>/dev/null
> +fi
> +
> +# --- Test per-size anon THP enabled ---
> +
> +found_anon=0
> +for dir in "$THP_SYSFS"/hugepages-*; do
> +	[ -d "$dir" ] || continue
> +
> +	ANON_ENABLED="$dir/enabled"
> +	[ -f "$ANON_ENABLED" ] || continue
> +
> +	found_anon=1
> +	size=$(basename "$dir")
> +	ktap_print_msg "Testing per-size anon THP enabled ($size)"
> +
> +	# Save current setting
> +	saved_anon=$(get_active_mode "$ANON_ENABLED")
> +
> +	# Valid modes for per-size anon (includes inherit)
> +	test_mode "$ANON_ENABLED" "always" "$size"
> +	test_mode "$ANON_ENABLED" "inherit" "$size"
> +	test_mode "$ANON_ENABLED" "madvise" "$size"
> +	test_mode "$ANON_ENABLED" "never" "$size"
> +
> +	# Invalid strings
> +	test_invalid "$ANON_ENABLED" "bogus" "$size"
> +
> +	# Idempotent writes
> +	test_idempotent "$ANON_ENABLED" "always" "$size"
> +	test_idempotent "$ANON_ENABLED" "inherit" "$size"
> +	test_idempotent "$ANON_ENABLED" "never" "$size"
> +
> +	# Mode transitions: verify each mode clears the others
> +	echo "always" > "$ANON_ENABLED"
> +	test_mode "$ANON_ENABLED" "madvise" "$size (always->madvise)"
> +	test_mode "$ANON_ENABLED" "inherit" "$size (madvise->inherit)"
> +	test_mode "$ANON_ENABLED" "never" "$size (inherit->never)"
> +	test_mode "$ANON_ENABLED" "always" "$size (never->always)"
> +
> +	# Restore
> +	echo "$saved_anon" > "$ANON_ENABLED" 2>/dev/null
> +
> +	# Only test one size in detail to keep output manageable,
> +	# but do a quick smoke test on the rest
> +	break
> +done
> +
> +if [ $found_anon -eq 0 ]; then
> +	ktap_test_skip "no per-size anon THP directories found"
> +fi
> +
> +# Quick smoke test: all other sizes accept valid modes
> +first=1
> +for dir in "$THP_SYSFS"/hugepages-*; do
> +	[ -d "$dir" ] || continue
> +	ANON_ENABLED="$dir/enabled"
> +	[ -f "$ANON_ENABLED" ] || continue
> +
> +	# Skip the first one (already tested in detail)
> +	if [ $first -eq 1 ]; then
> +		first=0
> +		continue
> +	fi
> +
> +	size=$(basename "$dir")
> +	saved=$(get_active_mode "$ANON_ENABLED")
> +
> +	smoke_failed=0
> +	for mode in always inherit madvise never; do
> +		echo "$mode" > "$ANON_ENABLED" 2>/dev/null
> +		active=$(get_active_mode "$ANON_ENABLED")
> +		if [ "$active" != "$mode" ]; then
> +			ktap_test_fail "$size: smoke test '$mode' got '$active'"
> +			smoke_failed=1
> +			break
> +		fi
> +	done
> +	[ $smoke_failed -eq 0 ] && ktap_test_pass "$size: smoke test all modes"
> +
> +	echo "$saved" > "$ANON_ENABLED" 2>/dev/null
> +done
> +
> +# --- Test per-size shmem_enabled ---
> +
> +found_shmem=0
> +for dir in "$THP_SYSFS"/hugepages-*; do
> +	[ -d "$dir" ] || continue
> +
> +	SHMEM_SIZE_ENABLED="$dir/shmem_enabled"
> +	[ -f "$SHMEM_SIZE_ENABLED" ] || continue
> +
> +	found_shmem=1
> +	size=$(basename "$dir")
> +	ktap_print_msg "Testing per-size shmem_enabled ($size)"
> +
> +	# Save current setting
> +	saved_shmem_size=$(get_active_mode "$SHMEM_SIZE_ENABLED")
> +
> +	# Valid modes for per-size shmem
> +	test_mode "$SHMEM_SIZE_ENABLED" "always" "$size shmem"
> +	test_mode "$SHMEM_SIZE_ENABLED" "inherit" "$size shmem"
> +	test_mode "$SHMEM_SIZE_ENABLED" "within_size" "$size shmem"
> +	test_mode "$SHMEM_SIZE_ENABLED" "advise" "$size shmem"
> +	test_mode "$SHMEM_SIZE_ENABLED" "never" "$size shmem"
> +
> +	# Invalid: deny and force are not valid for per-size
> +	test_invalid "$SHMEM_SIZE_ENABLED" "bogus" "$size shmem"
> +	test_invalid "$SHMEM_SIZE_ENABLED" "deny" "$size shmem"
> +	test_invalid "$SHMEM_SIZE_ENABLED" "force" "$size shmem"
> +
> +	# Mode transitions
> +	echo "always" > "$SHMEM_SIZE_ENABLED"
> +	test_mode "$SHMEM_SIZE_ENABLED" "inherit" "$size shmem (always->inherit)"
> +	test_mode "$SHMEM_SIZE_ENABLED" "within_size" "$size shmem (inherit->within_size)"
> +	test_mode "$SHMEM_SIZE_ENABLED" "advise" "$size shmem (within_size->advise)"
> +	test_mode "$SHMEM_SIZE_ENABLED" "never" "$size shmem (advise->never)"
> +	test_mode "$SHMEM_SIZE_ENABLED" "always" "$size shmem (never->always)"
> +
> +	# Restore
> +	echo "$saved_shmem_size" > "$SHMEM_SIZE_ENABLED" 2>/dev/null
> +
> +	# Only test one size in detail
> +	break
> +done
> +
> +if [ $found_shmem -eq 0 ]; then
> +	ktap_test_skip "no per-size shmem_enabled files found"
> +fi
> +
> +# Quick smoke test: remaining sizes with shmem_enabled
> +first=1
> +for dir in "$THP_SYSFS"/hugepages-*; do
> +	[ -d "$dir" ] || continue
> +	SHMEM_SIZE_ENABLED="$dir/shmem_enabled"
> +	[ -f "$SHMEM_SIZE_ENABLED" ] || continue
> +
> +	if [ $first -eq 1 ]; then
> +		first=0
> +		continue
> +	fi
> +
> +	size=$(basename "$dir")
> +	saved=$(get_active_mode "$SHMEM_SIZE_ENABLED")
> +
> +	smoke_failed=0
> +	for mode in always inherit within_size advise never; do
> +		echo "$mode" > "$SHMEM_SIZE_ENABLED" 2>/dev/null
> +		active=$(get_active_mode "$SHMEM_SIZE_ENABLED")
> +		if [ "$active" != "$mode" ]; then
> +			ktap_test_fail "$size shmem: smoke test '$mode' got '$active'"
> +			smoke_failed=1
> +			break
> +		fi
> +	done
> +	[ $smoke_failed -eq 0 ] && ktap_test_pass "$size shmem: smoke test all modes"
> +
> +	echo "$saved" > "$SHMEM_SIZE_ENABLED" 2>/dev/null
> +done
> +
> +# --- Test khugepaged tunables ---
> +
> +KHUGEPAGED="$THP_SYSFS/khugepaged"
> +
> +if [ ! -d "$KHUGEPAGED" ]; then
> +	ktap_test_skip "khugepaged directory not found"
> +else
> +	ktap_print_msg "Testing khugepaged tunables ($KHUGEPAGED)"
> +
> +	# Compute HPAGE_PMD_NR for boundary tests
> +	pmd_size=$(cat "$HPAGE_PMD_SIZE_FILE" 2>/dev/null)
> +	page_size=$(getconf PAGE_SIZE)
> +	if [ -n "$pmd_size" ] && [ -n "$page_size" ] && [ "$page_size" -gt 0 ]; then
> +		hpage_pmd_nr=$((pmd_size / page_size))
> +	else
> +		hpage_pmd_nr=512
> +	fi
> +
> +	# Save all tunable values
> +	saved_khp_defrag=$(cat "$KHUGEPAGED/defrag" 2>/dev/null)
> +	saved_khp_max_ptes_none=$(cat "$KHUGEPAGED/max_ptes_none" 2>/dev/null)
> +	saved_khp_max_ptes_swap=$(cat "$KHUGEPAGED/max_ptes_swap" 2>/dev/null)
> +	saved_khp_max_ptes_shared=$(cat "$KHUGEPAGED/max_ptes_shared" 2>/dev/null)
> +	saved_khp_pages_to_scan=$(cat "$KHUGEPAGED/pages_to_scan" 2>/dev/null)
> +	saved_khp_scan_sleep=$(cat "$KHUGEPAGED/scan_sleep_millisecs" 2>/dev/null)
> +	saved_khp_alloc_sleep=$(cat "$KHUGEPAGED/alloc_sleep_millisecs" 2>/dev/null)
> +
> +	# khugepaged/defrag (0/1 flag)
> +	if [ -f "$KHUGEPAGED/defrag" ]; then
> +		test_numeric "$KHUGEPAGED/defrag" "0" "khugepaged/defrag"
> +		test_numeric "$KHUGEPAGED/defrag" "1" "khugepaged/defrag"
> +		test_numeric_invalid "$KHUGEPAGED/defrag" "2" "khugepaged/defrag"
> +		test_numeric_invalid "$KHUGEPAGED/defrag" "bogus" "khugepaged/defrag"
> +	fi
> +
> +	# khugepaged/max_ptes_none (0 .. HPAGE_PMD_NR-1)
> +	if [ -f "$KHUGEPAGED/max_ptes_none" ]; then
> +		test_numeric "$KHUGEPAGED/max_ptes_none" "0" "khugepaged/max_ptes_none"
> +		test_numeric "$KHUGEPAGED/max_ptes_none" "$((hpage_pmd_nr - 1))" \
> +			"khugepaged/max_ptes_none"
> +		test_numeric_invalid "$KHUGEPAGED/max_ptes_none" "$hpage_pmd_nr" \
> +			"khugepaged/max_ptes_none (boundary)"
> +	fi
> +
> +	# khugepaged/max_ptes_swap (0 .. HPAGE_PMD_NR-1)
> +	if [ -f "$KHUGEPAGED/max_ptes_swap" ]; then
> +		test_numeric "$KHUGEPAGED/max_ptes_swap" "0" "khugepaged/max_ptes_swap"
> +		test_numeric "$KHUGEPAGED/max_ptes_swap" "$((hpage_pmd_nr - 1))" \
> +			"khugepaged/max_ptes_swap"
> +		test_numeric_invalid "$KHUGEPAGED/max_ptes_swap" "$hpage_pmd_nr" \
> +			"khugepaged/max_ptes_swap (boundary)"
> +	fi
> +
> +	# khugepaged/max_ptes_shared (0 .. HPAGE_PMD_NR-1)
> +	if [ -f "$KHUGEPAGED/max_ptes_shared" ]; then
> +		test_numeric "$KHUGEPAGED/max_ptes_shared" "0" "khugepaged/max_ptes_shared"
> +		test_numeric "$KHUGEPAGED/max_ptes_shared" "$((hpage_pmd_nr - 1))" \
> +			"khugepaged/max_ptes_shared"
> +		test_numeric_invalid "$KHUGEPAGED/max_ptes_shared" "$hpage_pmd_nr" \
> +			"khugepaged/max_ptes_shared (boundary)"
> +	fi
> +
> +	# khugepaged/pages_to_scan (1 .. UINT_MAX, 0 rejected)
> +	if [ -f "$KHUGEPAGED/pages_to_scan" ]; then
> +		test_numeric "$KHUGEPAGED/pages_to_scan" "1" "khugepaged/pages_to_scan"
> +		test_numeric "$KHUGEPAGED/pages_to_scan" "8" "khugepaged/pages_to_scan"
> +		test_numeric_invalid "$KHUGEPAGED/pages_to_scan" "0" \
> +			"khugepaged/pages_to_scan (reject 0)"
> +	fi
> +
> +	# khugepaged/scan_sleep_millisecs
> +	if [ -f "$KHUGEPAGED/scan_sleep_millisecs" ]; then
> +		test_numeric "$KHUGEPAGED/scan_sleep_millisecs" "0" \
> +			"khugepaged/scan_sleep_millisecs"
> +		test_numeric "$KHUGEPAGED/scan_sleep_millisecs" "1000" \
> +			"khugepaged/scan_sleep_millisecs"
> +	fi
> +
> +	# khugepaged/alloc_sleep_millisecs
> +	if [ -f "$KHUGEPAGED/alloc_sleep_millisecs" ]; then
> +		test_numeric "$KHUGEPAGED/alloc_sleep_millisecs" "0" \
> +			"khugepaged/alloc_sleep_millisecs"
> +		test_numeric "$KHUGEPAGED/alloc_sleep_millisecs" "1000" \
> +			"khugepaged/alloc_sleep_millisecs"
> +	fi
> +
> +	# khugepaged/pages_collapsed (read-only)
> +	if [ -f "$KHUGEPAGED/pages_collapsed" ]; then
> +		test_readonly "$KHUGEPAGED/pages_collapsed" "khugepaged/pages_collapsed"
> +	fi
> +
> +	# khugepaged/full_scans (read-only)
> +	if [ -f "$KHUGEPAGED/full_scans" ]; then
> +		test_readonly "$KHUGEPAGED/full_scans" "khugepaged/full_scans"
> +	fi
> +
> +	# Restore all values
> +	[ -n "$saved_khp_defrag" ] && \
> +		echo "$saved_khp_defrag" > "$KHUGEPAGED/defrag" 2>/dev/null
> +	[ -n "$saved_khp_max_ptes_none" ] && \
> +		echo "$saved_khp_max_ptes_none" > "$KHUGEPAGED/max_ptes_none" 2>/dev/null
> +	[ -n "$saved_khp_max_ptes_swap" ] && \
> +		echo "$saved_khp_max_ptes_swap" > "$KHUGEPAGED/max_ptes_swap" 2>/dev/null
> +	[ -n "$saved_khp_max_ptes_shared" ] && \
> +		echo "$saved_khp_max_ptes_shared" > "$KHUGEPAGED/max_ptes_shared" 2>/dev/null
> +	[ -n "$saved_khp_pages_to_scan" ] && \
> +		echo "$saved_khp_pages_to_scan" > "$KHUGEPAGED/pages_to_scan" 2>/dev/null
> +	[ -n "$saved_khp_scan_sleep" ] && \
> +		echo "$saved_khp_scan_sleep" > "$KHUGEPAGED/scan_sleep_millisecs" 2>/dev/null
> +	[ -n "$saved_khp_alloc_sleep" ] && \
> +		echo "$saved_khp_alloc_sleep" > "$KHUGEPAGED/alloc_sleep_millisecs" 2>/dev/null
> +fi
> +
> +# --- Test per-size stats files ---
> +
> +found_stats=0
> +for dir in "$THP_SYSFS"/hugepages-*; do
> +	[ -d "$dir" ] || continue
> +	[ -d "$dir/stats" ] || continue
> +
> +	found_stats=1
> +	size=$(basename "$dir")
> +	ktap_print_msg "Testing per-size stats ($size)"
> +
> +	for stat_file in "$dir"/stats/*; do
> +		[ -f "$stat_file" ] || continue
> +		stat_name=$(basename "$stat_file")
> +		val=$(cat "$stat_file" 2>/dev/null)
> +
> +		if [ -z "$val" ]; then
> +			ktap_test_fail "$size/stats/$stat_name: read returned empty"
> +			continue
> +		fi
> +
> +		if echo "$val" | grep -qE '^[0-9]+$'; then
> +			ktap_test_pass "$size/stats/$stat_name: readable (value=$val)"
> +		else
> +			ktap_test_fail "$size/stats/$stat_name: expected numeric, got '$val'"
> +		fi
> +	done
> +
> +	# Only test one size
> +	break
> +done
> +
> +if [ $found_stats -eq 0 ]; then
> +	ktap_test_skip "no per-size stats directories found"
> +fi
> +
> +# --- Done ---
> +
> +# The test count is dynamic (depends on available sysfs files and hugepage
> +# sizes), so print the plan at the end.  TAP 13 allows trailing plans.
> +KSFT_NUM_TESTS=$((KTAP_CNT_PASS + KTAP_CNT_FAIL + KTAP_CNT_SKIP))
> +echo "1..$KSFT_NUM_TESTS"
> +ktap_finished
>
> ---
> base-commit: dc420ab7b435928a467b8d03fd3ed80e7d01d720
> change-id: 20260309-thp_selftest_v2-4d32eba70441
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

