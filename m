Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B082FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796656B0089; Wed, 25 Mar 2026 04:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7204F6B008A; Wed, 25 Mar 2026 04:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8536B008C; Wed, 25 Mar 2026 04:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A54E6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:51:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E593FE0B3D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:51:55 +0000 (UTC)
X-FDA: 84583967790.16.3D7C3BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D666C0004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:51:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b1e3/Kii";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=728svDarDpybv6q7KG00Eki4xvaBhCJwwC+/P9iXkjY=;
	b=OtM7jTufsRF1nuIUwXGCRVKCGHj221g8m+gtOUGoLYbwjZi77TdWAzf43HOVKNexShGQhV
	DW9QruxaKBBHweo9dL1MdOlZbliLVxfg8SunVsMs0PTAktRtpSb/ZTY5988buMJgxAizar
	tkjs2wX1HUcy/+63Lr7mvlQtsG02Wto=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b1e3/Kii";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428714; a=rsa-sha256;
	cv=none;
	b=Qt3NkjODeUKCxDWV+PFSP6AxsFhTmQLD6GicrCfL5nZviBG7Z3KXVcjRj814ITdp8EFPhC
	jNwqopEoKtRc5qTWltcpTVDSWUwuUJDMOCwkTMwZnHC6ibpvk8gNnQZQsSnDaJycR+PBL0
	i26O7BUSlNtdWeeUjEGQ/PX5aIAR+vg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33F004023D;
	Wed, 25 Mar 2026 08:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F3AC4CEF7;
	Wed, 25 Mar 2026 08:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428713;
	bh=wb0mpku6g4vk6LeYoqKTVgZtD079ouSEG5afLG7CYHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1e3/Kii8oNvJgJ1AntUStWco7jvCebnWCtuv9zQCi2oUsNeV3CcabZ/VnDWT/4Bu
	 SdMcpnZUmux3R7PA238aj+buhQoQTRaRCXpWVo3lfGnlVNamvRsJHecUDO4uY4JETZ
	 xHJynwGclZ7csipkKUqwqfdSbhr2yZe/cHdAo7WUa3IRdxgN7vSItNWj8/2zpJM8+z
	 ZD01fhqLFQqk3slMEX+1PFlTdn7jeaS5TQm3vnMZ8RuoTjWtwNM3l4/A2ygJ2Hvbj0
	 HyR0HIfxv2d4zYS9GJNQyVlSryBTgfJVvw36EgMl3VIff5tJxeQAebFY0sT7kqzmW+
	 QsAWpfwuNt7wg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v2 0/9] memblock: improve late freeing of reserved memory
Date: Wed, 25 Mar 2026 10:51:37 +0200
Message-ID: <177442863989.343689.8532363597437067519.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D666C0004
X-Stat-Signature: h1e3y8srqzy5caqjkjhp6r8nq8r5cejk
X-Rspamd-Server: rspam06
X-HE-Tag: 1774428713-355466
X-HE-Meta: U2FsdGVkX18l32g/G9S+WB8EVJWMEDSdZrHkQmkfCUoGoOut/Z8ZCoNOcGa/eR50Wm8DH+gFQ5CQdHbi00Yhcnk4Mctbcjrznqdi1zo1bQWEZ28Xual0p0F+Fc0J/RZr82K+T+fjSJp7Imy14ISVnT2ISmDc/9Vy6M89JfzHzunhUNESUM04/uje1En7fkbQiZuS6wY98JGusGHOFmkIvXAAfw/qaRIUyM7YTNNXt73/sNoNGPNIziazEeBQXKM1W7nLu/RKJSBcvuDuOG+uwKWusAvtdBGsI51SNGvTAxq1Zgg2wAn87ubt67CCxRf4d0tn3C262g0L2IHMMRCH0XAZAHdzX1WhTIC9PMoCD6BgIuoTLoS7bk+4QoISrj1lVtv3wxAcp80apMkPVEqNdS1EYNWNdxrrIL9DZjCGQ8OEVzrtyAd4DgAsLIpMUH9hf3Zs2WBidxPZ2D9VuxVCPm2OZTOeIrLE7x2Qm2D14DBXYJX8ogsS06fjs0YKquDxID0Zg1nbjnwOH7lejasL+gne9N9jkP6IYnQGvZfPF0JTEQzamZt6F9hsQ37H8w+m+ycM/8+lBPmKo+O4+5V5YIU9HbarFlYQe1xcuRsaDssJdmaJacsijxYjNkM8cJkocQ4vJYJ/yNS9PnSCYJuzhsvi5xDHFHheEa2BXpCUKUgEhe1GfdOm1rnUUMfVFuFh4IfAqUaQFVvD6Bp+Fj4k9cOE/6HRDgCHVZotwKunPHx4ChxMtMMFVIHlor9oIKiHJBMZsBe/CV9yR89DdzZmL/QSkMFxWzXkinpsWM9iJXKzyqHLLlC8Tqp2PcBPEiUFqyJYFolVfqpx1/EC9YWm8WX3+fp81PtNB+bj/zIF5bIuHq8dj7QIFSKESBwK6YkKJy+PrfyLPGwDiGrT6iiF5gXfzOKRfQGcS7JUr1bQdV5hVeWkZHpBDdkcBkdni7erkS/jE+ZW7JhywUYgPdY
 ZgZoBom3
 aMJ5l5hEIX5YzDQHaWeoJdK6BoJaxUBS7O4c0h5vSW48cZlSFBNFSKooS91+MHiI9b/wy3hQQCJkg6sJZJX2zmacIrJDbDSBOQp1n+BKApHRSQ+G37wqEG3YtpRZYRDLYZZqS0Dcr0sKAQpdN7DEUw56qh8dbjNtHDEjDum3N5DzA4DMPNFp3kEvQ69EvM8gf5P7Y1XTLn3zTMJdeo6RGbiMhIYY/tbdljqAMd5YtvkksBJQspCmgZdsOKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 09:48:27 +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> Following a recent discussion about leaks in x86 EFI [1], I audited usage of
> memblock_free_late() and free_reserved_area() and made some imporovements how
> we handle late freeing of the memory allocated with memblock.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/9] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
      commit: ea459d3c24fefd90b60a702f4a73833434ae0248
[2/9] powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
      commit: 6e827110aea5fb9c53a5bf070413ffe5cad105b0
[3/9] powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
      commit: 3cf80188ecb828ed034ba562614cf1d48156b126
[4/9] mm: move free_reserved_area() to mm/memblock.c
      commit: 0aa264cda784f9fbe1a80ef13144cf81610086c7
[5/9] memblock: make free_reserved_area() more robust
      commit: 456ac994018598bc57ceaacb8a2c72e722c9755b
[6/9] memblock: extract page freeing from free_reserved_area() into a helper
      commit: 40191dae9ed84c816b593bb1b36a80f86c2279d1
[7/9] memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
      commit: b9e028ca869de24df00206d7ec640380670fc38f
[8/9] memblock, treewide: make memblock_free() handle late freeing
      commit: 64cb853c2ab4d8bd25b965f05e33ac0c6672bae7
[9/9] memblock: warn when freeing reserved memory before memory map is initialized
      commit: c7fc9cde41be029cf6675befbafcbb2dab40b39b

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


