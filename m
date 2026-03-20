Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD061099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108C16B013C; Fri, 20 Mar 2026 18:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E23A6B013D; Fri, 20 Mar 2026 18:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F390C6B013E; Fri, 20 Mar 2026 18:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E831D6B013C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:41:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B69DD1602FC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:07 +0000 (UTC)
X-FDA: 84567913374.28.DECA7A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0FCAD14000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5lVmyuB;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD27jWLWbEa98fvVKfoytjky1VbbHaio0DVEeKTRKHI=;
	b=7Qias5lD20EWUlQDdROf1kZdIiwXVpVoWyzyKLAFyE7P2UipgaD/a5ZO7BV+cdMokqH1XY
	hvAXC/Ao/kh6oTR1TXS4ZRCUwnvMtNyGZ7L8eVDopDdtkPmrYWHsZz4z16zE0FDEm1uhYq
	B2lcpKrOcrGwS/uGP5xk7gmceZV1Idw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5lVmyuB;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046466; a=rsa-sha256;
	cv=none;
	b=7F1cXW3OpchfUJH1nNU+CsyYvvvlpZnZhhBPrXV53Taq9QwXTsqBymsMReSK3FS1gtC4za
	uBmypfrZVVhnohIYgNDVOmvUWYhaC+caHOn+pVkl5yIFnEnTEy6WUOpbFeAtg5xV9JAGKs
	TjCODAOve76vkOM4Bi6UZ+9DBkK0VDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37B8843A8B;
	Fri, 20 Mar 2026 22:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA36C4CEF7;
	Fri, 20 Mar 2026 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046465;
	bh=8qR80FHVrw1W7dNRTWXARimuDYTsH7/Z1DNv6yL8KUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5lVmyuBl/YHtF0SUASv3ZsIQ1natPUk22znSNUOoj9GyIsqTvNjDfuA4n6b+bsdY
	 0IktpYP0BWJT+oAlqd91mH+ucfqkC0/or3yrh+9mqekZCcnZ68PC+3+GOlR+kG/Gqk
	 qR3lrrIWipYfuWAhUod8000ikrQiwAYZOzekjarGe48HdLKV5DVaWMA5C5CGo49xdA
	 LZZnpmr2iLBxtmHqo8tPDQrQ9okPRHfMxpwhKc1UaJ49bwA70Zc8q8d7EItWlI2LcM
	 BcStZ6sq6rzSZ540KpAs0bxeFgzoEwLwBn4HNb9lYff6pOhtpLKVcI0Nxiz30+Upqb
	 ALlXbBOZOjIoA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 21/21] mm: on remap assert that input range within the proposed VMA
Date: Fri, 20 Mar 2026 22:39:47 +0000
Message-ID: <0fc1092f4b74f3f673a58e4e3942dc83f336dd85.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FCAD14000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 8pd6qonrj3x6nd467h7dkh4tzskj7y9w
X-Rspam-User: 
X-HE-Tag: 1774046465-346535
X-HE-Meta: U2FsdGVkX1+hLx1452ThjtI+dzjBehR/bQTgJ6NxhCeih33qdT2YjQJVw64y6tpANhI9DtobEF8Klkj09MHSlZuYicu7I0acz4eqUNLLZCdSnqnfipZRRd9toq1fIcqp6+aGfU7zVIS0A0/YRJD6HUCDt8rVWSmHvYCUJmLyyVKFWiWJYDGkOX2zZc050NN/Om2O2B2W40EAXhXiMOgKH1aaXPSt8PyVJpp4CiTOzCN40Ig+xswh5BITeMoaaRRBV5ghg8mzSMXi6XgDP5D4t0aszqRVk45lrmQMikl8MuRyxXb+GMkJ40zBYF3RVclgcvgUB6OZVDVGHt5aQZIUgyB/JiwK4qI/Y6+hRGtZXtG4nA1RfKhI6bJY2s5rQq2X+azDH9ItSwPo2V20qOE2NAfKhoAf/UNZA1Wr/TUiDs/dKVw2K7vZxG4d0LttfXTFvEDV7HebcMcv/Kay8eHinEtaTflbFSznD75LG5rQ6y2ckKSSbQpZsO+mNKdBhOk76ROjot4c0FLoiBUw61aLOTbFA68XWLqadGlUR8ZZHngdgkBQWQNbXBIMdyuGqLDX2C/Y4mkqaZjlzR4JkjcSCBKD5WZ82NL2U6RhAYfjAhmWrI4WtAyGc7hw5ngyXFxtfnpfwB3DEJPvP1pXpXC5Lz68xxabrmmd+QKX33mZPKEUIFT0i0VGRQ4huh4nt5V12hSuygqQP0DZJkEhkMZK5Kry1M9vhy/35LNY2mB8h3lwEsnJD1I6cdfbgXKdAqGE+zrP471BjbqqLFqx8A2lFd37e6kKDqmCie7n6d+TMj5/JZpG+eGrWYjAhqugh8b+8WQlXyrfdvlg8W9jVDHsNJAa1Q3b9hVuURBOGoNRDAo1POH6AKTlM/nLQWZ1VAABf++AfRSPDjlmNC+BFWLfo2GzMjYjDIdzu2fzORMhxLYaPKa1ySEvaoUbY+EB1dv3ap3RPD580eAL9K0+nJ7
 koBHiWCX
 CxQsM6wsa2tOyNbDktxnh0q2jz/x0mTtBwvhHN3pVOIMx4Cwzj/UEsOR+qpNoneHdR+p95Q1AgPDTz85ov+ZopwmjbFhj6o/5OtQ1T2wSEnEEl2am6DygDOo5ml7Sy0WOriw98Ku5tfe/BGbWEbujwrPRD8KmigV9Ts0DE3Hodr98br5U6PCei/KTYZpzY6+f9LPCCxlVnJ8K9cxX9r+WP6F/SM0bPlHLFG8V0FwQbRkukf5skh5eHqpsH1959GOlM1vUq/x8PJPgAoSi603yu+qAlLGq864xzV4S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to check
whether the input range in contained within the specified VMA, so we can
fail at prepare time if an invalid range is specified.

This covers the I/O remap mmap actions also which ultimately call into
this function, and other mmap action types either already span the full
VMA or check this already.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 53ef8ef3d04a..68cc592ff0ba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc)
 	const bool is_cow = vma_desc_is_cow_mapping(desc);
 	int err;
 
+	if (!range_in_vma_desc(desc, start, end))
+		return -EFAULT;
+
 	err = get_remap_pgoff(is_cow, start, end, desc->start, desc->end, pfn,
 			      &desc->pgoff);
 	if (err)
-- 
2.53.0


