Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416FD606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=htltHbUS
Received: by kanga.kvack.org (Postfix)
	id 614B56B05BE; Mon,  9 Nov 2026 06:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5AD6B05BF; Mon,  9 Nov 2026 06:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC156B05C0; Mon,  9 Nov 2026 06:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 355866B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:22:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C46FC4064F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:22:15 +0000 (UTC)
X-FDA: 85415341830.08.A31D048
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9DB6A0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:22:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htltHbUS;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794223332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EGlkjnTPXViKqQZVNQ5OhXpwdoUkAoPNRSYCRrjUm4=;
	b=Qo1BweouFsNrr9rD/L79+yATz0FUaZ3vW6kOVrzb6+NUwMCM3kF2QKwMDOHk4b5u/8b2fi
	xmDMajuVzBidEs+6ACibp427wEwmGmJBJ+dGWsw6kBQGrVjuLEsRQXXY2LUcycg/W0jhGu
	MXe3ZPr4K5kwb9ERJRkUb6Ge2cYzuEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794223332;
	b=4z+o1VpTeKTn+gcuCIz+nNJ98UHQNft68lBiCmDGJk37S76owItFm7K/+sig3Ggc67HXyq
	RnoC1llyJFth1OhLgOq2JCUCxiscXeGMcKdKkWJQbT/NqXY9jR7qa2oTWmPEZ17arZvrRV
	iqpxIdAitJQTDlUXFoJyPUcSnBd6Gds=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htltHbUS;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42F28613F9;
	Mon,  9 Nov 2026 11:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931A91F0089F;
	Mon,  9 Nov 2026 11:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794223332;
	bh=/EGlkjnTPXViKqQZVNQ5OhXpwdoUkAoPNRSYCRrjUm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htltHbUSacOuNqzjJ9rauWTrqcdykKX6USyqFGrUK9Xsa38SnEMQxb7T/ZjiCXkEa
	 Q3m4xjJ9yNTSt0qsBs0OHMh2c3NiQTo/IkQbsECjBb82KMmTcgAvO/htFjpHzCaGRE
	 Dr34Ia6Ph2F0gzzJYkwD9mERLqFmcNp0qIXlhazhqzYMvO6QdiHSxnhmhYnRS3wVX7
	 aMdc9NiJL+XVYIbIVwTb5UEWJUq9mHr/u/UYPehQ14rEs0B4NUXfyGGzQsJQACdAUa
	 SvBWUQdAlhi4419n9w5EnjfN/FsofQ4t5bL/MY/OybcPVK/0yI0aCReWdGkuwdNUco
	 TSHC0IPQ2kIDg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	Mukesh Pilaniya <mpilaniy@redhat.com>
Subject: Re: [PATCH v4] memblock: don't allocate new reserve_mem regions on a KHO boot
Date: Mon,  9 Nov 2026 13:22:03 +0200
Message-ID: <179422331231.3350534.16388829888932023722.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109075733.9051-1-azpijr@gmail.com>
References: <20261109075733.9051-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dmxp5q3ba65xngjzij51mqdpw533wy81
X-Rspamd-Queue-Id: B9DB6A0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794223332-43107
X-HE-Meta: U2FsdGVkX1+m3/fRTW/npxMli48vVk6bE+gdk0fbmsXKmvK9zsDruLUILWBFI+7rMAO8UH/0V5CoyuqHcl+0a73k6Bf/WBWf4hXfKAbkaUXO5/kGpWMLeNcopejzvSovAo38iLyqCtxibhm8rV1OfcR0RzPsnSSd2D+pTqu7jY860m3jhwpABD5rIH+kbB4en2ZnzxXzUOVGVJ0HkeiHY2x0ttz6OajqtDLbCDPTXJypa6SshUXuAoImf0Kq4qdiNUvjrOQe+wnejcIXYZBTMtnURnvuEDBX9Z7Shf1zsm1w/+E0zlXT0eBjwshTqnNhZPaAdvJmvtDcGK52TKKW9mXCPx3Yvi19SNvrD0HE7s8jRlrIKvqu1KdglAfF3EKL6Ta8dLF4287oZNmHUTyNC8NCPWe+5WTKRuQMwb1acggnxnLiLpIOFUIUbQHJK+Xdm26GJiMKFa2XJ1MlonuIlSWdA9eE3Ie4cK7wKQhxcR7KgroDlw9uXeDeatVgkrK907FkRcQDPtaCatGbO0V143Az6vHuXy9S/cCm+YJ+ul3YOwLWv3eyEIu8jVneQqGxMrshtoGE9Z7HeHQNSf1D1TFcl+x7danH1zh0dT6FCZapHgxLjQtIydUJS0Nfe6/q/WLKOzP3SVFKBv875bgGHcP5PQBSPqtGozd8til+hYXB2ic4XXWItsUZh47/4VtH4wI4U7jFVn9kMlcAAna0M/yQwGu3lNiXQEdJDUblGFau/qQ2D3Yis/nW+tvj2tPo0spc36SBJpc5tUaYMJ6PTdrEdQ6WspXs/9qrmQruZXbDlIVpd3Nes7kcmKycTPPKMjjCsjHjl8G2cdwEFpgg0s3jtFbLE0vG3CPAVC4kgKk/T2TSSUxbBFnjbcCnQHNNd4993iwYhGiwBX1IWNSTXv1XCa7re0Cff0RBlWMnDxbBDMZ6Q8KYjxDoZ675HMGZiPypxfHhRrFjgkJjjy0
 oFB74fAu
 H1G8yURtfBkAuAmvg02ibqB4e6YHXXzoSVfTgHeVEBFr57JK1HPBEAV7F0pU54BRaLAg9G72vEY9M0Ir6XRGcCwmqRtKWKaExzISvqZb58ljy8uIuPy52mn/nakblmJUjQhJG7euH0LWnrX95z/2TQ9089EihDmv2FEzPcWgjkqDB+qe6ooNr5BUFGCWFhfQYEGdOA/JfqezJzJAco0IlpllAQq7+FZvIwlWLaMS+rj0gBD+qIgrJJ08Mwatv6fFClCrIF53jvwiV3n8BW4rY5wxVOfVHffZySYrX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Mon, 09 Nov 2026 08:57:25 +0100, Jose A. Perez de Azpillaga wrote:
> On a KHO boot, a reserve_mem region that can't be revived is allocated
> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
> then fails:
> 
>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>   failed to prepare memblock FDT for KHO: -22
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] memblock: don't allocate new reserve_mem regions on a KHO boot
      commit: d9a27fa1050902a6e38bdb780b0277cbf1dfa5a5

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


