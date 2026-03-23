Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B859FEC01A0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0912D6B0088; Mon, 23 Mar 2026 03:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068F36B0089; Mon, 23 Mar 2026 03:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1226B008A; Mon, 23 Mar 2026 03:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBDAD6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 723EE13BF50
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:04 +0000 (UTC)
X-FDA: 84576551808.27.3512BDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3B35120002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soMwPHB4;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRKSTfQ2O+eVNBGid9yhgznzOkdGuXgn3KcDsHXlPeg=;
	b=wdPN8409qTZY7pzinTLQkgXVU++H6h3bK8CUNyMlf02mRFkohkp23vEc696CyrfvcoXEhf
	JyTjSt86Q1VwBwATYa1JMNJlPZVKKUW+Xa7+ai01eZNZqe6N0lcbWBbF+0ga7fy/QfksMB
	z4vM4DVytYMaZlhGPKYSeE6rEtuIWPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252142; a=rsa-sha256;
	cv=none;
	b=lIIfYIZIK4HRHHcul5ht3J4DhuwTby749VkYqY+cDXn7iJsddzuSTw8XcXjY0qK9d9DtT1
	EYGuljpuiZN0Lxp+Xd3JfAj+D1pow9/mGSsfgYCuVfb6dcAB1aHEYMFWk/v864tIa0aZZ3
	4dxF3pjlQWklX6ra8AIlZfSlSlaBP8c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soMwPHB4;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE2A04358A;
	Mon, 23 Mar 2026 07:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B1FC2BC9E;
	Mon, 23 Mar 2026 07:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252141;
	bh=ZPayAoUZgLwz6EhVKnVbCR0MqW3d3UF4hy1nzr/kEys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soMwPHB478isjyOEuq0IFRN9Cief5Jqwxg1OL7jUkDAL9y4hBeM9dbR/1MWaRqGWi
	 ib0jpyTzOuLzovqiLkfFzH/sitT7zv4W8SFvjQAfIZyXowACHhmqxuqnkiN4Ye2w/b
	 fqdb/4qzrOD886HOPMUSVszQTzLVwA06GpzpYZb9RUwXxMKzldKhDOEpdPGEiqzvEz
	 d8ZnoMumXfNyr/H7/zGCKqVZFhNYMDERdxkrZ9jFtVB2x96iGjkhmG/En+iUsCJUVO
	 API6o3jBTJGcQaw3dzn8rTLMq1L6nSmRBE/0It/iNumPWF5phnJ73bZcJMJHMFZdCH
	 C3sxaPr5Q/wkA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
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
	x86@kernel.org
Subject: [PATCH v2 1/9] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
Date: Mon, 23 Mar 2026 09:48:28 +0200
Message-ID: <20260323074836.3653702-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: si5qhk5rk3y3dh8fnpzeoznsqtrdwfdh
X-Rspam-User: 
X-Rspamd-Queue-Id: B3B35120002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774252142-925039
X-HE-Meta: U2FsdGVkX18W08Dkdo6r+8wy18VnMTjFwS2dKtPvwarNlDX6QMMJwPTD2yIRNfgQo0HyvazEluGynmFm7M/GGNqznGSTS12ICjn75LDckyxy9JmPJjZ6rR6G/t8IsdzBBU2ZHFaaQGwt3Y7xvzs6+REhyikaz+Jy6NFUbKJLfXignzbqutdp6bpV+gXcq3OY4kahP190C571ZAWcVEg96xeADjWjNyI4XCargST6fiCg1cW+DO+kldt3LWTIzGz/eFse4mrE+7rzB2KPjniz055ZD8Kvg8pnTGg3TtZWtS36fH6SSfP6f4YYS63IdPUhk4ol8um3UqtIwZGpycj2J7QtldlSLOC9/rypPblSgvX0yOIdY/TNg3raq4nOV3KDfF5oDXT/XoxyoJFdJ/tYETMEPHF0mATFmKiqhYghy1XXMcjbtKLfcMNKQd6sPAestkrJnFxDaxzORMeecxKVq/yMgXsV8q82CxqQQWhDRTvz0UAaBllVlWHBnObE0hZ5j7ZqgHCuCA/rBIeL+XzIGrkyAQOuAFFYTVfZCoCuODjVV9zTxxoUaK7sEZZIqpSNzKaFUh9tgwNGMH5W1WPDP3IEcbAhzt3EMBH/jFCmTsODjTyxLvmw4vIY7IdnjUe5GEFdYxhSBtCk/FoD6anUQo5haVR6Ckd9WFv8Sp/rMPu46C4vSvvK+tD8EF2KtKdpmmUHA16w9S+jjq2Tdf1yqBoTuAx1JE2gtBemQ1kT80Z/K5/VE31K7AGGhxArv3Ed0wm0hTweZqeApHEVAZX/MZxoTkOZab2Ce5agp1pCbEWIMA8EGDgruyWSha1J6Ok/yd9ybz+LY6EQHYqox0ezazI8PuYnZLGkmp4FKbxUtbSqoQBRHNqNq+eTdOuTPxq9OOzfyELJK0+YhOEaWSdu08IhQ0XyWCO+7WezYcZO4wI1pXSH3mGPJJTTlgRxrB6BRC0sdIvuG1v0JHBE6Co
 084JBU81
 faxB2XJ8qx8GiunH0kCdUW9RrFM1eT3PnPiaoGq3RHSnfnXLMQ+nFoPHVoxfycBucq0kJE+iJeJLDJxgjce0kKBof4z9eN5Zi81MMCkDztT/mX7cVhZ6MlaYLVXWyR4ah/kDhMO519gIjg4AgZ9fEPsRFzwi7otNoCNqv7PnrnR2ZeCTrji6GBDoEO3JbDYf23GnNNBeAK5N0GbncWhY6t38/SrouXSbVIPQC8+PpQkl22LCEdV1RM9aexAXyJ7SjQrwFpXWoSY/fBKyyKDYbj+3aLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

free_reserved_area() expects end parameter to point to the first address
after the area, but reserve_mem_release_by_name() passes it the last
address inside the area.

Remove subtraction of one in calculation of the area end.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d4a02f1750e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.53.0


