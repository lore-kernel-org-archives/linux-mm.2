Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A437F109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30E76B0553; Thu, 19 Mar 2026 14:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E6E6B0585; Thu, 19 Mar 2026 14:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998646B0587; Thu, 19 Mar 2026 14:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7504F6B0553
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E37E593B6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:34 +0000 (UTC)
X-FDA: 84563638068.10.B3DC226
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C4ED4000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVYC5dOU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD27jWLWbEa98fvVKfoytjky1VbbHaio0DVEeKTRKHI=;
	b=Xr31JjYF279bgLv8MpQgj8hUQEi594/YnKRpLi+BCvZ67PEs/AcMGncVsXm7usQNPlx6Wx
	fbr8VkOxJgtHO31W0iarnH/ID/RjKpbhXsadZQ8Q/JL06a7LpN3F5sGY0LgbF6ZRvJ/Q8b
	fH/I296hp5cjDyxNI3jpAL11oIYgqIU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVYC5dOU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944672; a=rsa-sha256;
	cv=none;
	b=baUIAwdYAGi752A59YXInVyPMmxFhsNeumyz39yFbDuu1J3DQLWXfNJToioDdBwGorHYQu
	KvJyX0tBWg3/K39c9kDRhGWpaQlz7stneqZ9gzpO+/+0vDo4muc2awczmnY0C3F15WTv3h
	LaxWcZOGv89w3gNRn3BxS/hCan0ebhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AAC9B4417E;
	Thu, 19 Mar 2026 18:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB8C19424;
	Thu, 19 Mar 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944671;
	bh=8qR80FHVrw1W7dNRTWXARimuDYTsH7/Z1DNv6yL8KUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVYC5dOUj/MbE21wKE4nC0COPv75LzNV8x47CMH0fC7fje4DYi7sI71at8mJPTABJ
	 zLkW2Y9lJtB8KKDRpClfNeZ9+GACa60E3OtWIpyv9oiEfipIUC9W1uC6jrCj1jOhkM
	 dkK1SfZU9We74Zu0a49ak0Fa+zdY2gjFoh0p7RYVEwI/GdAYtU3+5Bf/MoQPsC0o63
	 ATj+FKbZAHped9Et6+jZt1cHcO8myFWGd/JpVmmmrjFfDkETPB7rnHZCgCy4VnDe2n
	 sllqGD7f14dzxHtZDpdJKoPpVCcXghN9qbtYCYU6HRbdvL+EzTSVLY5zt6ARM6vM5g
	 mi+fTT0jvaHiQ==
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
Subject: [PATCH v3 16/16] mm: on remap assert that input range within the proposed VMA
Date: Thu, 19 Mar 2026 18:23:40 +0000
Message-ID: <a2b328f5b9bc902368b18c5b1678a0adb8693516.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rz1d4qozp5nnkqf39w81froj1pcmmnj4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C4ED4000E
X-HE-Tag: 1773944672-401231
X-HE-Meta: U2FsdGVkX19HRoQW8wOGYMc3kgoZunro6kfFZTHLzP0K+PrJJoFkAHTe7EhiDNY2K+Wj0kM0nUQ1TpiezFcyuo7mG5AEwfNQIheZE3Cr0kkDPnG8EdgL313c6nzaLKKNeyTRID/9jcDIAsLK52yEgA3+yGMsW8Jy7AFx5zk+QrC7gKILIfOk5oDBALiVrYr3lyslKfBSSDWmVnIAXRw+IB/TsQ5KUFwUmyng69EkyUGasELlaZWzbvY+Wqvx1BFHDdJmCR3mjPd9J/y4kiCn7cfobBOHo1EocdaDEmiim4MSp31bih+dbcvYTgNY7sE1+iqTRwTSI/+un0Q2zgg+Kj6W0Qn05ypWMV0W+CWNpiqhtX4xAH7Se6XyxIv+UKc4CfOKRUSf51j4VVo8/L2OlNAq40dG++wct4vvpEi8tI+aqM0JPW+npx8cB3W5tRC1kai6zBL/TEjcuCT/yVTCDBBj4cJcwRZfjrLg2kXS0Q4Zfox2QlnIHII9/1KKyMjBM/exw3LooiGv7sUPF2JNRDXd2sMu4iMYZ2E3jlhF2YS6Thi1q1e3AQzjtz2NRwu7iO+pO/QQtpI6Z5J4ZVRYxQ5u5I4yFPQDi/qLL5hq/9b0v+ngGMxDcMKx0v3ffKr1lhmhKHXm/hFuGYGOjyGNhdCHVsx13bkZv+PJ/ZipkYgmVlkaSMYukOBkeHgSUCx0dHhiCMTmaWKmEB9MSrug0lUb6MglcrtPB3sJFHTpNpInCWEaMjhjVJ4v1ekanNvJ3Q10YeQZHzVx2hFjztkqTJTLlbiAkwPknGTGpzWHjR/oTI2AnFKoXrSnP4spu68PCT4YNftn4w5w/T7TmHZo0E0KCOfH6aj4UQUJrzK3TYUN+JLGmUkc+iyJxqq78yLQes2JVdJB2yC72tDAqhpvCZ0I1nRI29W+6L8T+3QM9Txso0s/RGQKKMLY9eVZdjenmUlHeChnhcPvWsDSQi4
 PNfm2GXe
 2DAAIBPhbYM6Ntlt5Ib22AkvIi5Qv7PTkfs3F0uuZBmiZASfILyp+XPU1Maqlvt0IQ9ZmYb++83RcHpXMZgVv6j1wPOtJWlA4N2P5VQuqmdaCmACxnQchlXI5I7pV4sTslR1c2UbV+aXMAxh421cIGI3EASYmxdadEDlytOg+j3mzMeHYgmaa5n5N7J5NEx3R74PLzXZPEKdrUq4hXBRC4aBsVT3P9gGziUO0zsqFlUZdxGfUiO8cKTXy91d2r31PdlhTJA6gYyJE2/fvVLOZ6YDvw77lDdoXpbp33NE1Ufj3zTcWRICeCogGHHlmKXrzOD2hz5X4hedDmwI=
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


