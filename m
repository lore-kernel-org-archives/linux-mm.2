Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F8E606A331
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1DElYiB
Received: by kanga.kvack.org (Postfix)
	id CD7026B05BC; Sat,  7 Nov 2026 14:35:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87A86B05BD; Sat,  7 Nov 2026 14:35:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E586B05BE; Sat,  7 Nov 2026 14:35:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91DF66B05BC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:35:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F4961203C1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:35:39 +0000 (UTC)
X-FDA: 85409327598.01.66067DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 63DB2100008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:35:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1DElYiB;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794080137;
	b=WlsaUuGz8BOoNTz41hazuwgQbfv/atlF0jBfjYXoYSJ0KUr+58JZyNNzRX1p4wUs0oAMdx
	qfXLuQsRbYtUAuxYwOuGJKYVG1KdqHhscB2Xa20xys+XZmKf13vcOlTDxFBMjyk+jm+zgM
	nuveHM1PK6mSb2rVOlZ2og6atT39yMY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1DElYiB;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794080137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y91yUk3QMpxcP22L5RRZVkCw7buIe7KPREWLseYyt3w=;
	b=n8Xb10FPxi9qpwfpSBxgm1AdjqMJZPUOsC8gFJse6mQvf7tkjLn6JLYAWmPTauAGokuJ+/
	7r94ekxdpV3XkmHltMitIS9RGi6ilbLZLNwqh6kaqfMCxPS72mIJS04Od9BOqRi8GZ5U75
	mz4IBiMs9s9TTUDt+dpqjZiGeUfnW1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFEDB61178;
	Sat,  7 Nov 2026 19:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3303E1F0089F;
	Sat,  7 Nov 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080136;
	bh=y91yUk3QMpxcP22L5RRZVkCw7buIe7KPREWLseYyt3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1DElYiBCAwYNb5lvnlydTAg+Zx/qbjkhjIeGQqYkRaeyYdOGOECsJgFK+4t8mPgz
	 kSt884AE/XerPp+N8+qYwVKaiR7Y+UBvrDNbEktuXsk/Xw1sG+J6lpGyEsAfVnGSl0
	 YEfZXo/fqEJ38p5kWs935lTGr8wM3oN13+H8uwh1njL/1jfNF5zSefgdLLvi4WYT2x
	 HwD0lTfeJm+z49lcXZYMhkBUBK/8Ev5WTvODQmBd19QxRtrUS8v2iYYQLwqSjXt4bV
	 3sppTarAIZbmHOlEiwLj4IpYtSP50gzqmLVtOG8R8ZVHl2xY+4Gg7taTVaFJfeyt6K
	 FxAStSYhTeUjw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rheinsberg <david@readahead.eu>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	stable@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 1/2] mm/memfd: handle GUP pins more reliably when write-sealing
Date: Sat,  7 Nov 2026 20:35:23 +0100
Message-ID: <179408004350.4783.10820829282179060083.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
References: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63DB2100008
X-Stat-Signature: 6936dnwcdf1ynmo8eukbsuugweqnn5s9
X-Rspam-User: 
X-HE-Tag: 1794080137-695103
X-HE-Meta: U2FsdGVkX1+klHVBdklAogt/u24utIQ0b0Zh+6U/ik3NgSQ149ZwwtNeNtdaCgSpZJGIHAOfsU9GpXPMuLfmOMiUszC75ZnLKpk8ZsbH9XoMMVjmUnwavAPfIPWbozyxgDlxHc2CDfUPJhzCFbdLuVfLx3Ha8FAHSoNf8vt3fUwqPS/dd0MRqHj/etzCrVC4Yk7KYLDjAjwnGJ7E2gjREBkbZQeTskhzKh0zKpa6t0sF8ByX/rUGwwJREUc2m66t37MPgPAUHUwLTiH03VXahohI9yMUlDXsveUAoqxWhWJAu+4Dl/X3XzakhqmBd/yepqJKBJ1Xep5JzlwoHIydRU8u34jDJlJr7AppLj7jTyi5/nixVVVUMH9L35k61rD+UZWEOCt2SGOkb4M85j9WOnyTXZnSD1I+Y/Nsn8CDnkKw8mAC9ro/4riYu+PQvn8dORsBaPfQmYyW4EYcN4zMpg/qP/oQ46Yvx9nice2X/iU+ud/20eC6D0BEdDMBQFYr4QRPOtIYMgNfm3hGu2d4Yr+5dLQy7KEgu5WkIIScOyXQ7rPc0D2yHr82er/xR7Joiu/suX9ETI1V3WjFw7qFFq8CAIOVftsUxVVookgViYBFmR5BmBHNWhrXVERum8AXOTbG5RkVK6mUTcCPPdVNpBPscTJzsEA4zsTdgPO5sjM73OD01iokzWzokrimnxTjodnufey1bRjQNWl3Y8MsJQixDNytYcRoMiQqRkKPVT5em3lZzrduvF49EKjNIg3UrceQA4Q58pmdIWWD8hJZrWpDmq9j24yGZk8MaV0UVYxGwiSYlqWh2+9M3JboRWYDeynK9mxVs6XECyAR74OYNJLJYSETX/Op/35yuMaAG3CqcBs6LvwJCRGUtn6wUEwmg5EBPTL77rEdQkfuelzih2MwkzxhU23CYBpuPrdw3WkI0+/ZA6beUjXuVFUQTScAK1Dj8CClUrjgtT74XfF
 GISQpA9I
 5AkrUEKIMi8SEAeeiRMtamqoiG7wmCJDrt1uPPZv/8yODEcqkpG3mpYuFxWH9KV+p4XvtZ5uNgXTc/7zmtUsIrza7dF5cjtPOwvGUjdwcj/aNelSGA/bQDDBOLK5XvzeX6H3giiW1WkfNlreQNJ+07GdZu9na0CtwBjC4DyJ35CWtZMivvaWVWHwExVFPJ6Chub3s1wq/h7zK+FeYjI1/ot0hM5xibGdtYY2b3SEK9h/CEY8bg8BuC3pbFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 19:31:44 +0100, David Hildenbrand (Arm) wrote:
> memfd_wait_for_pins() detects GUP references by comparing a folio's
> actual refcount with its expected refcount. As spelled out by
> folio_expected_ref_count(), obtaining the expected refcount when there
> can be concurrent folio (un)mapping is racy.
> 
> So it is possible that a changing folio mapcount can race with our
> check for GUP references, and F_SEAL_WRITE might succeed even if there
> are some, allowing file contents to be modified after sealing.
> 
> [...]

I'm applying the first patch for now, as that is an obvious improvement
for many GUP users (esp. iouring fixed buffers etc).

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/memfd: handle GUP pins more reliably when write-sealing
      https://git.kernel.org/mm/core/c/42990cfe

-- 
Cheers,

David

