Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E94E606A337
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYNrN/cR
Received: by kanga.kvack.org (Postfix)
	id 122046B05B9; Sun, 22 Nov 2026 23:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D13F6B05BA; Sun, 22 Nov 2026 23:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010406B05BB; Sun, 22 Nov 2026 23:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C36B66B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:09:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBB4A140325
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:56 +0000 (UTC)
X-FDA: 85465053072.18.8597541
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2180F1A0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kYNrN/cR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406935;
	b=kya7r4jfdEReITI6CN0kJsbFTyOGeS7tjw70QzMREz//SwYpy9l1D+hApFXJuh616iVV1e
	XkJWxnq3jOSa6LoLiIPjxeBGlmYog7ObPdmIy6fh/roG6sT97hTR3KH9OCp0bCPbnznrt4
	yp7p4a46glJF/Mx/QAtRG8+isfrK/vc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406935;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkB6AqmsMab5b2ZWWO69wff8bL46ujVgMLlY72Z6qGQ=;
	b=PLPYBpc/KwUryxIq6Q5Cd0D3CbejOUP8iK3SILBQ5dUGRrliM1bkONKKLJV74oigL1iqLf
	0QV/op0BXWRSJfcEFtrA9eu2kkADSBC/zZTSPUW3BccdfBXANgQ5687kyuhuP16UQeYtbX
	qYwWlXfUqyLioNGr2I3Bf/dwI/IntK8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kYNrN/cR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C042360D60;
	Mon, 23 Nov 2026 04:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6858D1F000CF;
	Mon, 23 Nov 2026 04:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406934;
	bh=kkB6AqmsMab5b2ZWWO69wff8bL46ujVgMLlY72Z6qGQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYNrN/cRj45aVGlGCLxboueqzMoyf1foncKVwiqqs4jE9AxuRK74A415aUjAXtscV
	 Fy2fWC28f85AHH29Eeno0eHUGtyvg5ePB81pxNfHJHl064/niRJXXYcAyqX255Ysae
	 +JdfXjHEx2sxqsataIDUrMNZoB35Cy97S/6jJ4nRV0TRzREg5S+43hVKI0sE6J45Ms
	 0C8PbULI6+D2lLmKCBiSBXY1xkx7tYinlmFuS4R7kLWKgeIwYvkCADNQcycev5VmLS
	 dwgeIU58+SiFJZRrjnmSNj1nSsVBFYXBwwMiKxCixe4/fe8UF9Kc5+/rsuZDxGglFF
	 maUHxeKGIGKXA==
Message-ID: <sashiko-outbox-228643@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/19] selftests/mm: Add HugeTLB vmemmap optimization
 stress test
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-15-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-15-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:53 +0000
X-Stat-Signature: 1qpt57aoty85jwsx95a4iyx15cj8jn5d
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2180F1A0003
X-HE-Tag: 1795406935-859441
X-HE-Meta: U2FsdGVkX19l680j49mzMk87Pm9AqJSxOfZPyhcOAOseFEb93sZZ6kvsCl2faO0nJDplYlcQBRuSOJJ26jHBsLP2fXsVaQA0WDbXvN/v7shzw6K1uJDjzu+9YROhwtatFDwhsCZ2Xj79H3hI6YAx2VCpdV1JmFMcpSGGFz9M5pHAwT0kL/NptvB+bOcHh5tM1KiSY9M7pIK5zEOX9a4FfnzP5GnwWfBJG7cgY4+f8tcMmHgOtF5r8NijLKdNqMUzy3FTevrnHxHYpMhQeufkVU4K2txxXO8M5x4glGvE6rSf2gf8t8Jrcs+wlFx953G3qxuvMZ8dO/amydZTBERaTCAo8EK8Ewy859cCOPq1ghGrC2RRhR1FSrcIPssK1kdll5ZNCNTNXuIfYdIegv3izj7DVz0BKI0ev07Szt8djcEogqI+yC/U7e9EP8YX1WXUURwTTUOFHfkjAdGQNRkswcA1ifUUDIA73xwjJeyqMsY08w9PjSIv7+oCU4NRrwuQQ7Nj4z6aAxwGSxDpvRU1cHjtZKku0o+qMDQYsyWf4zl/FxBxakmNdWHBAmZlFaYIUMj+O9N4sKxkP/CSaNVm0E33XbGqfNgXzVJQr0vgWG3YFThTdFRa9oISIo5fHswgpBTrvCZ2TVzbSKsqBovD/z+piP5BQKXWktVHmT6nMhBntO+faDJTxEpNKvl7b27VifjbRWc4geWGVDbpyKzxbdW+uASb9dlIHytnYhq88T3FyA1Q0tjxX/QvZOU3IGlDUPusr6OXOCP5UkPcFmxB4NVQAF1B4xz2fK9vD34YqJbfQ4qPbfaOfA1JfcrdDfz8jWlJ1JglMWlFfsHqO9bifgXycJH1LXFHYv4C3Yh8FfoIoyiB+AaXFcl/AkyGn7A6xS9Fa/kHtte3EYJd/OTLRAqkIQw606sPnGyZoW8waFlYQOrV8m4qmLsKYT7FlEP+ujxNrlYgFbxlmS+yuMx
 4Bj9hk23
 uQKBrTy8ixwkEpMgNREqzLpSCX2wr0v1ofQL4tAMen+ywz0OmOdQrvM913lYaDCMzGJKOrS0LWfQQTIkbJGgslawxJyZXuD+NY2toHr26BV9O956UffK6mT9a6cZSe8XAYgviQHRO1bz1DxMFFQVhnh+JZvZ9HfUnPunP/lWQ+3XrgZv6da1UGPF4TSKK7Wxy/RBhPHk9xNvQniYZprC0YMzNzTjkAZeHHANYNQHox3STrvvEIm+e+7zZh6pPGlC+4uEX+YvQnvy76slM1G8jrr7dIIclM+NIHc+caTfmFuEatKW48lnp1YLMBVbXKzNp6XzdP713jReeg1In50Ez6IlFMA2T5KtsLGVePD+/6hSz1Ly7ae4zwpd0oVaoJ1+1MwG3OyOCxsb7TqdSal1qypx+lPMe0WrJ5YTqWeP+BMR9iU6uHN0YwrRrGae6bKTHptIM1A67l7qmnkr+u4Y8eLSDPHAgYOdu5kMBnW57y9YoPHR/bAuOp2ozMLck2FR04JpMnv0wtvoUA26WNJv5PYTahmpnKgutgTIzpAALm7oKAZJIe3iIjxou5fCPB1hVEGJSAWpj3o3J2lFKgWyJ3rA/iDjZ82K0SPl4aJkJmcDPNhPOC2sh9moq6b06iBt6wcBCN/KP4eYHFHaWb3PSkpIDId/Zf8O1+5bxZR33mmCOpbeTwOdrPso+x1lnwLR00Tn8kvgnE3MtfijHhsutnj7jsQBeuPE9/U+Ol5g0cjRqUzcaTZSuYr4j6ydoJRu6e7nH3sBD18eIat0RpPZDGxmKRGnjW/jDuCvrFc7HwNDvqZ8NV3uWaMLMkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests/mm: offlined memory blocks not re-onlined in
  stress_phase()
- [Low] selftests/mm: unchecked mktemp failure in
  hugetlb_vmemmap_stress.sh
--

commit 15090370906fbd4c082668bfc18a1ce3c873bcb2
Author: James Houghton <jthoughton@google.com>

selftests/mm: Add HugeTLB vmemmap optimization stress test

This commit adds a kselftest script that stresses HugeTLB vmemmap
optimization (HVO) across accounting, concurrent access, and fault-injection
phases.

> diff --git a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh b/tools=
/testing/selftests/mm/hugetlb_vmemmap_stress.sh
> new file mode 100755
> index 0000000000000..b64fdb3ed7614
> --- /dev/null
> +++ b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
[ ... ]
> +orig_nr=3D$(cat "$hp_dir/nr_hugepages")
> +target_nr=3D$(( orig_nr + nr ))
> +marker=3D"hvo-stress-$$-$(date +%s)"
> +tmpdir=3D$(mktemp -d)
> +pids=3D()

[Severity: Low]
What happens if mktemp -d fails here?  Because only set -u is active,
tmpdir becomes empty and hotplugger() appends to /hotplug in the root
directory (which cleanup() does not remove).

[ ... ]

> +hotplugger() {
> +	local blk state removable
> +
> +	while :; do
> +		for blk in /sys/devices/system/memory/memory*; do
> +			state=3D$(cat "$blk/state" 2>/dev/null)
> +			removable=3D$(cat "$blk/removable" 2>/dev/null || echo 1)
> +			[ "$state" =3D online ] || continue
> +			[ "$removable" =3D 1 ] || continue
> +			echo "$blk" >> "$tmpdir/hotplug"
> +			# A signal aborts a pending offline_pages(). Use
> +			# --foreground so that the writer stays in the worker's
> +			# process group and is killed by stop_workers().
> +			timeout --foreground 10 \
> +				sh -c "echo offline > $blk/state" 2>/dev/null
> +			echo online > "$blk/state" 2>/dev/null
> +			sleep 1
> +		done
> +	done
> +}
[ ... ]
> +cleanup() {
> +	local blk t
> +
> +	stop_workers
> +	for t in fail_hugetlb_vmemmap_pte; do
> +		[ -d "$(fa_dir $t)" ] && fa_disable $t > /dev/null
> +	done
> +	if [ -f "$tmpdir/hotplug" ]; then
> +		sort -u "$tmpdir/hotplug" | while read -r blk; do
> +			[ "$(cat "$blk/state")" =3D online ] ||
> +				echo online > "$blk/state" 2>/dev/null
> +		done
> +	fi
> +	# drain() also frees free surplus pages left by failed restores.
> +	drain > /dev/null
> +	rm -rf "$tmpdir"
> +}
> +trap cleanup EXIT
> +trap 'exit $KSFT_FAIL' INT TERM
> +
> +# Run a stress phase. $1: name, $2: fault attr to enable ("" for none).
> +stress_phase() {
> +	local name=3D$1 fa=3D$2 base after injected
> +
> +	if [ -n "$fa" ] && [ ! -d "$(fa_dir "$fa")" ]; then
> +		echo "SKIP: $name (no $(fa_dir "$fa"))"
> +		return
> +	fi
> +
> +	log "phase $name: ${duration}s"
> +	base=3D$(memmap_total)
> +	[ -n "$fa" ] && fa_enable "$fa"
> +	start_workers
> +	sleep "$duration"
> +	stop_workers
> +	if [ -n "$fa" ]; then
> +		injected=3D$(fa_disable "$fa")
> +		log "$name: injected $injected failures"
> +		[ "$injected" -gt 0 ] ||
> +			log "WARNING: $name: no failures injected"
> +	fi
> +
> +	drain || return
> +	after=3D$(memmap_total)
> +	if [ "$after" -ne "$base" ]; then
> +		fail "$name: memmap pages $after after drain, expected $base"
> +	else
> +		pass "$name"
> +	fi
> +}

[Severity: Medium]
Should memory blocks recorded in $tmpdir/hotplug be re-onlined at the end
of each stress_phase() (or in stop_workers()) rather than only in
cleanup() on script exit?

If SIGTERM from stop_workers() terminates hotplugger() after offlining a
block and before "echo online > $blk/state" runs, that block stays offline
during drain(), the post-phase memmap_total() check, and any subsequent
phase.  When page_ext is active (such as with -o and -m together),
offlining a block frees its section page_ext table and decrements
nr_memmap_pages until the block is re-onlined:

mm/page_ext.c:free_page_ext() {
    ...
	table_size =3D page_ext_size * PAGES_PER_SECTION;
	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
    ...
}

As a result, stress_phase() reads a lower memmap_total() than base and
reports a false accounting failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D14

