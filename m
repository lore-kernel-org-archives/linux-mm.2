Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78358CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7ED8E0007; Fri,  3 Oct 2025 06:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97ED88E0003; Fri,  3 Oct 2025 06:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB838E0007; Fri,  3 Oct 2025 06:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 751498E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:57:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 242D35B323
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:57:43 +0000 (UTC)
X-FDA: 83956502406.23.A2E8644
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 581B08001B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:57:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IzNH+hoB;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759489061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4E82BzJ+qnZl9t686gwkNW5SiYgkKEnPv8qcJ31GnI=;
	b=DNgA5O3mwlOErOCi0xdV6lJsN3liqu4A0oS6KtJFJG4JqeLOsB9pTkvD5UDSkN9drmMEki
	Um/ErIxdU08c8fa++cjzAuzBaAQvORDc5fmpXbH+61YM1dEOEXiehAtF58We0BOoa63qIq
	kgkQyd2t9xW/wYK/Ma4vOkq9oMmZWY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759489061; a=rsa-sha256;
	cv=none;
	b=xMjcqh+YTt6XHut4a7B8B3seQZziJ3Wf/xgO9AC0HkZju2vwM2MXdjeeHE6nIjzHqRy71f
	4Mf66mI6S1oQVEVMjPzpwqGcHXcGYAqnEZiOfd/WoWNuMsa9CgVfUckyDKa29dJc7TiLqC
	TT1y+ezux82YyFOMJlNl0sn17dYWxsA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IzNH+hoB;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DBB9B43249;
	Fri,  3 Oct 2025 10:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B7EC4CEF5;
	Fri,  3 Oct 2025 10:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759489059;
	bh=rDsisar/vYgR0nEa1CjXdibGYgfr3Orwsw6CMhWJWJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IzNH+hoBKXlgqXqV5h879YvS8RJLuUSecYMjYPykeRmmcXyiy54f2Sf1+cSPVRPbg
	 2s/1oVtluS/1q5o0gmNqjDaAz8FSElFBRimmCDMODmyPX00fdV2W3XRJ6t/Rw95cFK
	 Ji/19gfkQg7Q6GG09Ct3yb4UinBIynF8RFJluvg5EBcpwuboUcrVROfz0xHmS2REgq
	 3oKUuvDRGbnJB0c2IKXs2la+hAahpoH3oP953R2fkhWZtm9sD3fQUIVrDq/PfOddOx
	 wQM1eTod31KjJEf9GR5l13l3uh58WzvQNpGgVlNxIHcJnyKUT4wcoQFyIbpfjrfXao
	 0P0lT5lQhlJkw==
Date: Fri, 3 Oct 2025 11:57:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in
 hugetlb_vmdelete_list
Message-ID: <7a1d0eb0-ab08-4fa8-bdab-b193b69a8c9d@sirena.org.uk>
References: <20250926033255.10930-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="67sMmfEQjBtt4ZBF"
Content-Disposition: inline
In-Reply-To: <20250926033255.10930-1-kartikey406@gmail.com>
X-Cookie: Save the Whales -- Harpoon a Honda.
X-Rspamd-Queue-Id: 581B08001B
X-Stat-Signature: g9rbccep67mm5fhib3q66sfic81x3xg6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759489061-737990
X-HE-Meta: U2FsdGVkX19/YpE0t8YQJWnSkMA4yDcBmbRw5BYbPv71fM6lt/lzjJZ1g7m1B2yETgilpO8AVov/daODkakYjMsQzkKQ7p3jRM5MLAgFAKfPdr939A6uoaSChaJgj1RENa4CF/gZdbzE3Ajj3Y53qACKZywdTjzGJu97s7OIqFOfvTitIovKa/0NiU5PHEJ8ZzhYaK4+nnZMtq/+eJ6ee+Pbw7ZfL0aR7Ph/HClgHRH1JAkyxu/Fzejezlh5qIebh6bWYPk2cET6T+beRhnHboikdIzt5fl+9AgZSsrnqTxQmPE7ACRYiq5sPHQbyBwgM/ucwYLesSFMcyTAb9mdpj1g9jKrTO0PsqmO4eUvRGv8EkJOr9JNJTZFvuU0dhJnouAn0N2bMVU1XBz84sejh5j2J3SmwlR0XxX2fWebyyr+SsPnpJ+xkrQKTn57Aa9WDlVdqG4ZeMjbH7vkDIIwAu1VDsdzBmzT/UX2s5p56AIhM97K4AJMrzvUu6mXElD28oLXjbGq2ptmzdWIQnnJjbHusKy4+2O5obAV52QLNiaS35vuxUFFWLb2qJf8TJhqHPzLLEs6nXFKod0W7OGv+HK1nKpF3+KB84FCyeoa1yGaep7vLbZ44qIAc8FI3/WRRTtXamoMWjeaR4hM6W42b6ok5RBAJkWiOj9J+igi5nFy+F80PqgOHDlVb9FVLXPEP+iM1GwhpIPJMkPQU72/6++yIP1n6n3Yo7iC5jL4yr6g/ScCFeD4cJDj3GIYxrLptKDVqnkR6eoCO5yj3jsGRLJKEI5uH8nlV1MsuDAE9DxuODdu0TGftW/p9bPN3xH7oWmyFxhnRLfBTWYq7HTiqK2/oyE0Vi87PWrZDXB5DuJwWaSXCwdakJSoHqSud6gUuGVyxyxd44WhmflnCtCA+m2x8+Vj6Fl8yOLG01XGkSYQdg6MFPV/A5nLbgye7xbeSm+XnaG+jYWL1NyB56D
 z+vE6nwn
 yxZ7VB2wrXBQlwpiHFXuTeSvHPPO/5jXr9/3DNRJ8ybniZ30YDJgLosaiA90JD9IOXw4QNSLZPKWL4cmVIngD8wRLi1MF4WiSX3E7y93F4muMt5nZ154nYUM0lvs0JEm/AdGGLY/2jX/u+FwESGARGhL9iHEWz3IzSDtLdOT2q4DjhzEZrtCJeajyfQUddbJFzRe7nznenK0Qrh3xRXaBGoW3uSGNeQyTSTbdDr1vaauOn9H9zvBJ7nWUyPzgUyCl5u0GYr9FozP0kOTqAO8O6uA1aasbnXZ9exbuSJO+J7PNdAHkWlPnsqygwAqXPMEBDD/tC2w7UKJdC/Xyh41F+N8Sz5h+k9ujxYpyxO28vcfwURzkrmOMv3YmgwXnQ6bH3dqsJdXkvHLkRa1HXv11NM02izWoaBR84+cN+vsB+zFxmc0QLkFd5b4CBD4nW86B5gSZSbfC4iy9ZkOBRuZwjUovHYPZ4iJ6yCpcTbXRksq5ir/gZFn7d/TwjVBU+XhCcWHVP7iZLi0n5VRoig+tKWKdhNUEN4p1xEOu5KicwghZyOkr66EIIVX4l5prpTW1AxEZXiKl/GEupNiN2U/20OQOu5Y6szljtPU4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--67sMmfEQjBtt4ZBF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 26, 2025 at 09:02:54AM +0530, Deepanshu Kartikey wrote:
> hugetlb_vmdelete_list() uses trylock to acquire VMA locks during truncate
> operations. As per the original design in commit 40549ba8f8e0 ("hugetlb:
> use new vma_lock for pmd sharing synchronization"), if the trylock fails
> or the VMA has no lock, it should skip that VMA. Any remaining mapped
> pages are handled by remove_inode_hugepages() which is called after
> hugetlb_vmdelete_list() and uses proper lock ordering to guarantee
> unmapping success.

For the past few days I've been seeing failures on Raspberry Pi 4 in
the hugetlbfs-madvise kselftest in -next which bisect to this patch.
The test reports:

# # -------------------------
# # running ./hugetlb-madvise
# # -------------------------
# # Unexpected number of free huge pages line 252
# # [FAIL]
# not ok 6 hugetlb-madvise # exit=1

Full log:

  https://lava.sirena.org.uk/scheduler/job/1913276#L1803

Bisect log:

# bad: [7396732143a22b42bb97710173d598aaf50daa89] Add linux-next specific files for 20251002
# good: [9d3bc72cc0a9791bf4910ef854b2c3dd61af3bbf] Merge branch 'for-rc' of https://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git
# good: [d4ecae56a8c7d3287a5bcdb2d65f7102ee580ab6] clk: mediatek: Add MT8196 mcu clock support
# good: [4c134c2a5f3db29afe35b2d30e39bb6d867b08da] um: Indent time-travel help messages
# good: [bf1af4f6e62878e053d20cd71267aed8dfb3e715] perf arm-spe: Downsample all sample types equally
# good: [e414334883f4835058ca06f934bc4988eb9cd9e6] Merge branch 'next/dt' into for-next
# good: [54653bb3ec83d1f717adab6108db82a3966d19ee] clk: renesas: rzv2h: remove round_rate() in favor of determine_rate()
# good: [87a877de367d835b527d1086f75727123ef85fc4] KVM: x86: Rename handle_fastpath_set_msr_irqoff() to handle_fastpath_wrmsr()
# good: [c26675447faff8c4ddc1dc5d2cd28326b8181aaf] KVM: x86: Zero XSTATE components on INIT by iterating over supported features
# good: [6684aba0780da9f505c202f27e68ee6d18c0aa66] XArray: Add extra debugging check to xas_lock and friends
git bisect start '7396732143a22b42bb97710173d598aaf50daa89' '9d3bc72cc0a9791bf4910ef854b2c3dd61af3bbf' 'd4ecae56a8c7d3287a5bcdb2d65f7102ee580ab6' '4c134c2a5f3db29afe35b2d30e39bb6d867b08da' 'bf1af4f6e62878e053d20cd71267aed8dfb3e715' 'e414334883f4835058ca06f934bc4988eb9cd9e6' '54653bb3ec83d1f717adab6108db82a3966d19ee' '87a877de367d835b527d1086f75727123ef85fc4' 'c26675447faff8c4ddc1dc5d2cd28326b8181aaf' '6684aba0780da9f505c202f27e68ee6d18c0aa66'
# test job: [d4ecae56a8c7d3287a5bcdb2d65f7102ee580ab6] https://lava.sirena.org.uk/scheduler/job/1907306
# test job: [4c134c2a5f3db29afe35b2d30e39bb6d867b08da] https://lava.sirena.org.uk/scheduler/job/1903298
# test job: [bf1af4f6e62878e053d20cd71267aed8dfb3e715] https://lava.sirena.org.uk/scheduler/job/1900552
# test job: [e414334883f4835058ca06f934bc4988eb9cd9e6] https://lava.sirena.org.uk/scheduler/job/1904803
# test job: [54653bb3ec83d1f717adab6108db82a3966d19ee] https://lava.sirena.org.uk/scheduler/job/1900685
# test job: [87a877de367d835b527d1086f75727123ef85fc4] https://lava.sirena.org.uk/scheduler/job/1697972
# test job: [c26675447faff8c4ddc1dc5d2cd28326b8181aaf] https://lava.sirena.org.uk/scheduler/job/1698132
# test job: [6684aba0780da9f505c202f27e68ee6d18c0aa66] https://lava.sirena.org.uk/scheduler/job/1738722
# test job: [7396732143a22b42bb97710173d598aaf50daa89] https://lava.sirena.org.uk/scheduler/job/1913276
# bad: [7396732143a22b42bb97710173d598aaf50daa89] Add linux-next specific files for 20251002
git bisect bad 7396732143a22b42bb97710173d598aaf50daa89
# test job: [74fc450198cf792e3db35ea4d49197a467233373] https://lava.sirena.org.uk/scheduler/job/1913848
# bad: [74fc450198cf792e3db35ea4d49197a467233373] Merge branch 'main' of https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect bad 74fc450198cf792e3db35ea4d49197a467233373
# test job: [db484ff3fff1fafa0017cdd017795bec09ace5e4] https://lava.sirena.org.uk/scheduler/job/1913993
# bad: [db484ff3fff1fafa0017cdd017795bec09ace5e4] Merge branch 'docs-next' of git://git.lwn.net/linux.git
git bisect bad db484ff3fff1fafa0017cdd017795bec09ace5e4
# test job: [7d942c9d9660e6808dcd835c4c73ad5405cc5518] https://lava.sirena.org.uk/scheduler/job/1914055
# bad: [7d942c9d9660e6808dcd835c4c73ad5405cc5518] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git
git bisect bad 7d942c9d9660e6808dcd835c4c73ad5405cc5518
# test job: [db03d3c83bdb21667392d1596fafdfb38325c2a0] https://lava.sirena.org.uk/scheduler/job/1914176
# bad: [db03d3c83bdb21667392d1596fafdfb38325c2a0] Merge branch 'dma-mapping-for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git
git bisect bad db03d3c83bdb21667392d1596fafdfb38325c2a0
# test job: [84a7a9823e73fe3c0adcc4780fa7a091981048ef] https://lava.sirena.org.uk/scheduler/job/1914247
# good: [84a7a9823e73fe3c0adcc4780fa7a091981048ef] mm/shmem, swap: remove redundant error handling for replacing folio
git bisect good 84a7a9823e73fe3c0adcc4780fa7a091981048ef
# test job: [c7416f37e4d31fb28ac4ed584b13037e69a22dbe] https://lava.sirena.org.uk/scheduler/job/1914387
# bad: [c7416f37e4d31fb28ac4ed584b13037e69a22dbe] Merge branch 'mm-nonmm-stable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad c7416f37e4d31fb28ac4ed584b13037e69a22dbe
# test job: [3dfd02c900379d209ac9dcac24b4a61d8478842a] https://lava.sirena.org.uk/scheduler/job/1914497
# good: [3dfd02c900379d209ac9dcac24b4a61d8478842a] hugetlb: increase number of reserving hugepages via cmdline
git bisect good 3dfd02c900379d209ac9dcac24b4a61d8478842a
# test job: [fe7a283b39160153b6d1bd7f61b0a9d5d44987a8] https://lava.sirena.org.uk/scheduler/job/1915206
# good: [fe7a283b39160153b6d1bd7f61b0a9d5d44987a8] ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
git bisect good fe7a283b39160153b6d1bd7f61b0a9d5d44987a8
# test job: [74058c0a9fc8b2b4d5f4a0ef7ee2cfa66a9e49cf] https://lava.sirena.org.uk/scheduler/job/1916011
# good: [74058c0a9fc8b2b4d5f4a0ef7ee2cfa66a9e49cf] Squashfs: fix uninit-value in squashfs_get_parent
git bisect good 74058c0a9fc8b2b4d5f4a0ef7ee2cfa66a9e49cf
# test job: [9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b] https://lava.sirena.org.uk/scheduler/job/1916064
# good: [9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b] Squashfs: reject negative file sizes in squashfs_read_inode()
git bisect good 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b
# test job: [fb552b2425cf8f16c9c72229a972d1744b24d855] https://lava.sirena.org.uk/scheduler/job/1916102
# good: [fb552b2425cf8f16c9c72229a972d1744b24d855] alloc_tag: fix boot failure due to NULL pointer dereference
git bisect good fb552b2425cf8f16c9c72229a972d1744b24d855
# test job: [81e78b7ec61e89e8bab9736551839f79b063614c] https://lava.sirena.org.uk/scheduler/job/1916193
# bad: [81e78b7ec61e89e8bab9736551839f79b063614c] mm: convert folio_page() back to a macro
git bisect bad 81e78b7ec61e89e8bab9736551839f79b063614c
# test job: [1acc369373008b9eeb930fbb47847c0693055553] https://lava.sirena.org.uk/scheduler/job/1916218
# bad: [1acc369373008b9eeb930fbb47847c0693055553] mm/khugepaged: use start_addr/addr for improved readability
git bisect bad 1acc369373008b9eeb930fbb47847c0693055553
# test job: [dd83609b88986f4add37c0871c3434310652ebd5] https://lava.sirena.org.uk/scheduler/job/1916225
# bad: [dd83609b88986f4add37c0871c3434310652ebd5] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
git bisect bad dd83609b88986f4add37c0871c3434310652ebd5
# first bad commit: [dd83609b88986f4add37c0871c3434310652ebd5] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list

--67sMmfEQjBtt4ZBF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjfrB4ACgkQJNaLcl1U
h9DAAgf/dem2WT55fAIeHx5L3Ugexl4ofWcegpn4HsI55fzE/1iBMaA/UKbCzLgi
hCBpEFtNxWel4h+iBjtDsYOh/V2R6a0YiqGlG2QJc0RaJOhJyJeZwMAlJAkbVqqp
fnfzr9GJw7MsnfNfQ2UxHmDnEIUH7sWJ49z/nXKkp6qLef/dvjNsvKRk/Q4x6PI0
IdWWOpaQlgMvHcal/TVbBxtiC5UqoaSXUg2JzxkjADAKrfCAV2C49JmLmlOL3iP+
zfDAyf0kQ/8BNbcPsnWVkOwXfatw/sVbl7sL8JCma2rsmp8z9bBOSuGpWvEGBJIp
95LhrPm8x9sMzjQryrWPRR/zsk6irQ==
=SKjz
-----END PGP SIGNATURE-----

--67sMmfEQjBtt4ZBF--

