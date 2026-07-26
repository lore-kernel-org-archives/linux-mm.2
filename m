Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDF9C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 11:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027846B007B; Sun, 26 Jul 2026 07:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19FD6B0088; Sun, 26 Jul 2026 07:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BB26B008A; Sun, 26 Jul 2026 07:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B97A96B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:56:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37DF41204DC
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:56:50 +0000 (UTC)
X-FDA: 85030776180.04.3658B64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DE1E40004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:56:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kN4vCvFE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785067008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpwU+9PKazOTFn1wX64gm97MpS/jIFgxMXAts3m+7Ns=;
	b=1LvcCoR2JVbL4WutQ0lPQ45fB+howrL4a/lq6I2NnhhjqobRJtEcRHe1Ol2zDp1bvqjvyN
	NaByvQwari6f04Se8NOyQrEkWRfhRBjvPU1U7NByajIjjqUgHyJoblX28aHC7eigxsOfD5
	fIwTMybkZjUU4LBIaHXytpNgL3mZOhA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kN4vCvFE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785067008;
	b=LUosCezUq9t/Ihknx2iUWbRMAGw7Ko+nPhclX2JR0uaqJnwchYQv7QF4ikwWjKloPfLDAB
	maK6XfeFjiMNX8iB3vNNa9F09t0mZ1wdXtudGeKXJpLWbHTqjG1myTnaJQRe5/bokV7775
	lXKVzx3fb4CKnYFFHsHTAeib0rpJJh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B678960008;
	Sun, 26 Jul 2026 11:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2B1F000E9;
	Sun, 26 Jul 2026 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067007;
	bh=kpwU+9PKazOTFn1wX64gm97MpS/jIFgxMXAts3m+7Ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kN4vCvFEIgV8ViFcpG28tUFvMQ/NZfw+/pfeq7b4XQHz+5bHlvUeKy9cXII/jYN2B
	 Y0CzraY1iQ2PJ20S4vO+iRTr8ZzK/yA8U4yJc1zBXNqU83xxE30hgmeMqYLxDQ9MQS
	 kOVomnN19GNv3ZKAB8K8V/7oo4ZxCdl70tw3YeRQAwdH81cdcvUEgjZhitQY97Jstt
	 FhzsIADmOBDD1bbgszb0YP/IJcecrYq7rEF5uheu7nGS1k5jAHLGCybYuza9HMUjIq
	 IPMYb624pEaWGfnnFN+s2uewzUFIszOruMFTzINwSx2XwS+Dlk4TmLyhAVEzq4ZKKC
	 WopPjRqwKbm3g==
Date: Sun, 26 Jul 2026 14:56:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v4 12/12] selftests/mm: add a slow-GUP content and
 COW test for mTHP
Message-ID: <amX19fK0YVIEonfI@kernel.org>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-13-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724222934.1463812-13-riel@surriel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DE1E40004
X-Rspam-User: 
X-Stat-Signature: 7sj4ddi1nacbucn8bgdso5ngamufab69
X-HE-Tag: 1785067008-824283
X-HE-Meta: U2FsdGVkX199Ln5VVmkwlHs3Za4QG2oIy/SBZD1S4FSOt6hsv7SgDHLrIPkzAvu/P6QpMyybcfyKlALu6kKi4SfO9AFiyYHf3XNf0CgpsOVZO0jP1hfQuHunnqGenZl0LDTItydztwXTnnPQ6EMsGw23oI2bth8/mm/5Z7VOWXuFpmKiyPMdmsuTdq0rnyNTZwzWtTnpvSbvqQO5XVTZI4ivUMAykz63Z/1FxvWwGSjsSR6Zki6C9mxsulN3MGA5rlzHZ3GUuPqbanCR96LbyuhrQtMDy3xLYqDn/S2E43c1nwbUwvyY7s28mBb4e3Y58yEXRiiThyxMF7sfvX7eNaoXaVmkOm1sIWV6dJO1vfTOx2FRshNCpONq370GmNJN7w+TaAS5bcj3ans07fbdZPJK/ko1IGfKUxesdXeiuNYB7JONq/q7WxN11dsR7lT4W7a4wE2NM9y5zClGkpv0wHkaV7PK+6KH4b5VEnhH7WFdDriOv2E8QfxF2LuhyJZS3mt3ngUWoapWQY76jDYJthQBxiZ2PX1rlfH5js6Ol2p/KTDm58zW0WbxI9HPiIZxNhpxTtpdi+wNO8FgtzQq+jPZwFsqtmji+5Kd+GCP+MWFLUQ8bWw7CNKAnyZR0TMLOgUzgf9V566CEevOKuvUaSBcpdGsd1tSsHCLGtOKOLzefmjJ3oonrGH7gmIB6UC23HNhFDqO5APT+BYcwLvSIq61ixE4tCWRdMUSspMHc/SH+38naO3JjYiMeuZO/8CwEQvI6Xp3vvdcDk7lQg0vhznfOwDPi44Xrth+oKfqfb5Iyvk8fhWVWDYYDMfJ8K0oXK/xG3b/9wPEQ4h0XS1UcOJA05J2vCuR3TgokxCh4DYS8ZOTXZ0OzKiwMaZ5/EV+fTaHbwqFBkqEhQ+TFCPVC+LBJfoEyVG1o5CJXdz0GstXwWHf0AcODynUQ3wEbE3b0JGSEwU0Mo1X6vHAXMI
 FYDLIBIj
 FtSS8oYxhe9XxBBcS4m/wvvIVe+us0XBGAh7Wuc5536ChUByvSnoKfINdC4eZv++Z7dX0RUd9eOswJM5t9sndWi7zA2K0jDUWWmtOfsiFCxauPIhSQYTX1e5q8q5+jguP6SlOwHbaB5BfH4RS0GEKboAg+/PcRKnQ95wgNsj2jFD8fpzE4Fu/+fpvc1J4ebPboJhlxywpDsEMVnEJb9IA7ZJ6M8kSIaq51jJPwrbZ9Dnc3NMsLN/EMHbqQaFKJF7Li12m6r+rt0VmA5DCz4eZh/xERh94AphPRfk3j+grX/Uk5MJcPd9LBLPNavLgQGzQwU4Pq2eIb9cYa5tJvBVn6mvbc5AojvSHs74O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rik,

On Fri, Jul 24, 2026 at 06:29:34PM -0400, Rik van Riel wrote:
> follow_page_mask() now batches a PTE-mapped large folio (mTHP) into one
> contiguous run for the slow get_user_pages() path. A mis-batched run would
> hand back the wrong pages or a stale COW copy, which the existing tests do
> not catch: gup_test checks only pin/unpin integrity, and cow exercises COW
> mostly at PMD size.
> 
> Add mthp_gup_cow_test. It forces 64kB-only mTHP, writes a per-page-distinct
> pattern, then pins the region on the slow path (PIN_LONGTERM without
> USE_FAST) and compares the bytes the kernel copies back from the pinned
> pages against that pattern.
> 
> The test covers a read pin, a write pin, and COW after fork(): a child
> write-pins to force per-page unshare and checks the copied contents, then
> rewrites its copy while the parent verifies its own contents are intact.
> 
> It also reports how many pages sit in contiguous large-folio runs, so a
> kernel without mTHP shows light coverage rather than passing vacuously.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../testing/selftests/mm/mthp_gup_cow_test.c  | 213 ++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh     |   1 +
>  3 files changed, 215 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/mthp_gup_cow_test.c
> 
> +
> +static long PS;
> +static int fails;
> +static int tap;
> +
> +static void ok(int cond, const char *desc)
> +{
> +	printf("%s %d %s\n", cond ? "ok" : "not ok", ++tap, desc);

Please (instruct claude to) use ksft_* helpers for printing messages and
tracking failed and passed tests.

> +	if (!cond)
> +		fails++;
> +}
> +
> +/* Deterministic, per-page-distinct pattern so any mis-order or leak shows. */
> +static void fill(char *base, size_t sz, uint32_t salt)
> +{
> +	for (size_t off = 0; off < sz; off += PS) {
> +		uint32_t k = off / PS;
> +		uint64_t v = ((uint64_t)salt << 32) ^ (k * 0x9E3779B1u + 0x1234);
> +
> +		for (size_t i = 0; i < PS; i += sizeof(v))
> +			memcpy(base + off + i, &v, sizeof(v));
> +	}
> +}
> +
> +static int wsysfs(const char *path, const char *val)

There are existing helpers to read/write sysfs in vm_util.h

> +{
> +	int fd = open(path, O_WRONLY);
> +
> +	if (fd < 0)
> +		return -1;
> +	int r = write(fd, val, strlen(val));
> +
> +	close(fd);
> +	return r < 0 ? -1 : 0;
> +}

-- 
Sincerely yours,
Mike.

