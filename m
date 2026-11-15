Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C419606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQb71zmK
Received: by kanga.kvack.org (Postfix)
	id 75A9F6B00EF; Sun, 15 Nov 2026 14:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AB36B05B0; Sun, 15 Nov 2026 14:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621576B05B1; Sun, 15 Nov 2026 14:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4214C6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:12:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C95841405A8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:12:02 +0000 (UTC)
X-FDA: 85438298484.22.E521CC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 041B94000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:12:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQb71zmK;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794769921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxIzf1rOBt5UVX6T+4jsFLqJIyKEfYJr89yjL6zf2/U=;
	b=PF5oQQV2P4a8X3lh3vARcgMB8Y2eTyrUD0sN8oqDSslBSAXyHjz7o9hyUdaXMh63CdqEO4
	rM0KwhLZHZyrul3FPL7+7zCkOIA0WPiH3yarqvWx+YDeRTAKPDSIeB3I+NIRN1+lCubAjQ
	1v+Cr57dbURfLm7/1ejx6A7pdOj2xV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794769921;
	b=eZW9yY5yjfPOgNdKVq2Lr77xPcz+6xDz+LEUSp2zX8e+uI60saos6AT0pViyloKFTBpdZA
	01c2vfVuwQxpgcXehGtpz2Bzgp6vbxLiqE/WzTSU8LV89LD6i0b05Zl5Pvx7yD8MfGWNTz
	LH1p+TaxX0LsIvqkFbzt0XEKQzbY8HA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQb71zmK;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C182342A23;
	Sun, 15 Nov 2026 19:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA51F000C4;
	Sun, 15 Nov 2026 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769918;
	bh=ZxIzf1rOBt5UVX6T+4jsFLqJIyKEfYJr89yjL6zf2/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQb71zmKT7FEnL7pd/rUA4mBP+ArRSohAYMmWp7K3aKZPN53O8r4cQUMdmW0cK6kO
	 26rQC2rpgdE1JrBb2SO9nmpP8d3+zhlkOiAFAFNK21MAWV1lWq+uB9txYcdInHf02V
	 HMVT12eD2GhINHfUUCEw4DOUxY2NGlqUR+RvqGk9UP5O/fVgmfmV4/8lQAwDQ1gtSw
	 6BVYpuvBUcrF5MXElUHmD45Qkke4sZgKaWtfRD72YX0jPxRFztd6JHJs+7Zufj+bOz
	 rWZ4jM3N2KCmsgYhyofDmNzbWszbLyBnzTMB/E6Ej3mvzqqRL9UiKWsdztLH/RDJNo
	 QsdzUX890TszQ==
Date: Sun, 15 Nov 2026 21:11:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 2/9] kho: Make bootmem reservations visible to fleet
 monitoring
Message-ID: <avoD9gIBLvMW4vPp@kernel.org>
References: <cover.1794383544.git.chris@chrisdown.name>
 <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
 <179443886218.2329176.10742245280418377061.b4-review@b4>
 <20261113003059.056dd036a6546756@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113003059.056dd036a6546756@chrisdown.name>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 041B94000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: m8a59fg7mg6y6zxmawae7sjtphkqn5m1
X-Rspam-User: 
X-HE-Tag: 1794769920-514930
X-HE-Meta: U2FsdGVkX18k+5tUu/+s7TxM9n6MyTJZ7/LRtpngpZdoVeRiehurw56t0AsspEvMj0Fsi12o0GIqZqPAJ8b/VCwr0D9rYecUw8JnVx3BRKWJ0TiaFgeBWt+awroQOBpUo8iNj2sEI+bkYfG2+Nou5yErIIkjCz4f4SUcYpz4pU60g93CRqlowtSIubw0e0cxlMujipSfe7faE0UpSgz9zPyRgLCrqJwVxc58NTRoJz1ramAYiZnm8UBUDfWebWNQaw+FrFYfIYbzDq/4yT/40PkvxGsfD/3wr85zJrELs87IOEI9XtnuOHwNLHwPurOi9UVMZlyU43xjAQcXiaqUicieFnEo7O2R/4P5+GlwFl3JfbWHns6msxg1QuhAgeif+BzJVdOgVoU5k8cwYwPL6RPqUoPEKlN+LmPQ9hVmmL6oTx3zJp9vehrrAFhpeZqhaybhP0tl6HsByI+zBNQlcBZHT4LA0c7UK4mfPP09r2jeBuESqQPlohKiR4DUr+qZvVKKtTRi9Hwcm5yX8lFKZA/9sRAcXXY/Pu0anucgi+qXxs2ilan7ykL+QmdwvmfqWsHemfaaNtkv5TMqtFYrs09vRPU7TOA/hZna/tCdPeTzm7zboB3iQJhHf/ddG1TiMHatuQDTYuB3uihUVjOJkdP3ZVMypmj5YapIERCEhsDUU+eVOFgRih8t0bCy7deUV5oB5Js49aR+fU19ScR+tsQeNWJtxUzkI6z2QYtLsUMo5M0txRg+Fz4n3mPk8M996PdRRKRME061UOnM53HW6RcoIWB5onu2BuoldMjyYeLfYyEvJFh8B4Kn1me9E1sh1FGLHV8GD+wS6ONdWZQrsP/HgNZ2N5uJDCfc72QVrfkd51zIMNDcK/7lWxeEo8fM+hyEm/wfkwDS2Bj6wxQVxkTKBsktJq89U0sVRRNqqXlOvuRFHqGZ5cwG6X8Q0rE1qD9M8oTyh/qy7vMwkbu
 2QxycS1T
 aPT2OMIyBTh+BrueO8W68tBcRo0xfOf6OWVXd4vvT7jr7lJ49yXG/RXLmnmuUbUv/3o9C1tfGJivm+GD8XU88yRC82N0v3FJ3B5+kLzRhApVk9Fbr5b21qOOJfLB9ahrBGa1IElP8i0O3Rc4o+f9PxLx9wtdxjhBtRlRFSaRfDWujdMuP4G1RoebtL+wVEeWKmFkHufGpvoJ9s1VSQKmxFJoT9YsNVXf3EwrzDat2mgq+L4wJ0gnBVFPHgugRdze6a9r4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

On Fri, Nov 13, 2026 at 12:30:59AM -0800, Chris Down wrote:
> Hi Pasha,
> 
> Pasha Tatashin writes:
> > > The reservation varies with the kernel, memory size, NUMA layout and
> > > command line. Our fleet collector needs the actual size from each host
> > > so we can decide where to enable KHO and catch a kernel release that
> > > takes those hosts over their bootmem budget.
> > 
> > HM, that works for cold boot not for live update :-)
> 
> Yeah, that's true :-) A kernel we live update into just inherits the areas, so
> we'd only see a release change the size once hosts cold boot into it. I'll say
> that in the changelog in v2.
> 
> > > Today the collector would have to sum kho/out/bootmem_len in debugfs,
> > > which isn't a userspace ABI. In /proc/meminfo, free bootmem contributes
> > > to CmaFree, but the reservation doesn't contribute to CmaTotal. The cma
> > 
> > Is this a different bug?
> 
> I think so, yes. Bootmem pageblocks are MIGRATE_CMA, so their free pages are
> counted in NR_FREE_CMA_PAGES, but totalcma_pages only counts the areas that
> mm/cma.c knows about.
> 
> zone->cma_pages is a separate problem. It only gets bootmem added by
> init_cma_reserved_pageblock() in kho_init(), and on a KHO boot we return before
> we get there.
> 
> I can send patches for those separately if you agree that bootmem should be
> counted in both.

Yes, please :)

> It wouldn't give us the bootmem size though, because CmaTotal
> would still include any other CMA areas.
> 
> > I have some concerns about exposing this as a stable API. What if we get
> > rid of bootmem or make it resizable? We only recently renamed it from
> > scratch to bootmem, and we have been exploring for way to optimize it.
> > 
> > I would keep this exposed under /sys/kernel/debug/kho/bootmem_size for
> > now, and not worry about it being stable.
> 
> That's fair. I'll move it to /sys/kernel/debug/kho/bootmem_size in v2, and we
> can look at sysfs again once bootmem has settled down.

The sysfs vs debugfs argument applies to anything KHO/LUO right now.

But we'll need sysfs at some point to lift the requirement for debugfs
mount.
 
> > Keeping it together with the rest of KHO code would be better.
> 
> Will do, it'll go in kexec_handover_debugfs.c next to the other bootmem files.
> 
> The kho_incoming files in 6/9 are already in kexec_handover.c, but kexec_core.c
> still adds the group to /sys/kernel/kexec. Is that ok, or would you rather KHO
> set that up itself as well?

We'll need sysfs at some point to lift the requirement for debugfs mount.
And I think it can live in /sys/kernel/kho and there we can have incoming
and outgoing and the implementation can be in kernel/liveupdate/kho-sysfs.[ch]

BTW, kexec_handover_debugfs.c was initially given the "full" name because
it lived along kexec_* in kernel. These days I believe we can make it
kho-debugfs.c

I promise to look at the rest of the series Really Soon :)

> Thanks!
> 
> Chris

-- 
Sincerely yours,
Mike.

