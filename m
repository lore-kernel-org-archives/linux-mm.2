Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C29CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D951D8E0015; Mon, 15 Sep 2025 23:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46758E0001; Mon, 15 Sep 2025 23:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23538E0015; Mon, 15 Sep 2025 23:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBBF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E1678721A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:55 +0000 (UTC)
X-FDA: 83893669230.26.4824E7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A70E840004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hfjKY/Kx";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgcZ9tAVp1vvZ5l23O8F3Ymf1MI8H9jy3t7AWw7yfBY=;
	b=crUsGRIIpTFqZEA+VhpgnND3h7/SXqBThz271Bg+XXTAkzVMrSUGUGGXnlmzeZUlCA8Vih
	7nCQt7CpY5fIjEnxH6IiWC5iJOVE+7aLJIHOPZE/XOf0MGFqK0RMsKOopHExmNfzSPdbPC
	UYY6fk7I/S2MQlBJ7Loqu4JtiDxlWKY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hfjKY/Kx";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993033; a=rsa-sha256;
	cv=none;
	b=Kwhnn4muEJ39Y24DoXN1To2fc2q9wsivWI0WXtFtKVoVuJTol32W5O39pZc/4YqZukE0KL
	yebmNSRBUB/bp24/wI8DrVI4ydzLGVRZ+ffPukf8umqXxjdRIZ25Ik3WckDQQqSeRVnSoz
	uiYNrRriKrEle2x5mcHONohaeF5o7pU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B566343917;
	Tue, 16 Sep 2025 03:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F29CC4CEF9;
	Tue, 16 Sep 2025 03:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993032;
	bh=tG/+3LKYF2FSnLVHXLho3ONEf7Ek8I7B7tVYfXji6YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfjKY/Kx8ktevyHtWSRTdz9zmLnjn4C74c7FvIXgziK4QPt9nDiqQZuKa9pxtu33x
	 nx50QAGy9yUb6skEIzlrFBhhA5wLHfgqwfbuAopVNFZzH2nXxCkSfA8ASl4Mrn1UqZ
	 ZeZ5/5adpyKPTfgLrF+ehrSawMINbTxLJ5sdnaguqPdAcjb30M9vFPjOWMcRriQlbv
	 /dyeU47MmK3n0XKcpBH8EE8C+egeSaSNKEajbdtBiYPCy4elXfvJZQLc82opUu0j4V
	 Crqsrwp8cQH/1gTYlPXZLyIMe/WG6txghRkiVFl0sZb9Ywz7ctTaEUwhEU6R39jSOv
	 y/29l+ReygZQA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/5] MAINTAINERS: rename DAMON section
Date: Mon, 15 Sep 2025 20:23:39 -0700
Message-Id: <20250916032339.115817-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916032339.115817-1-sj@kernel.org>
References: <20250916032339.115817-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A70E840004
X-Stat-Signature: ofbj1rs3dujdwboe5ii8u8o4a4mkca1e
X-HE-Tag: 1757993033-657346
X-HE-Meta: U2FsdGVkX19gnDr3Xe+ePXn2N731GIQHRr+OnFFEKsMDyvBZAWf3DhAbIxNGabVpY2v4C8IL1m1vdxskLnwPi3wmsWYswZUp49j1LgtJ5cILrltArZ5NYLJcPzBzZ8f++cCgP7szcgOTd+qDkZrzEGGiB2TNr4Dfd3lFO/hJhZnL1WYMop5lxNCEGgop1uzjYFMLew5+0Pb5Jk1+JiLG8YuTclCAtUm/N0e4OKoZ/eDm875BN/eHbDsJcwVj3dvw+p2zTFAXuXLIwe+mt1lzri9+Vxu8UOcHWZ3yhMNFaa021OaFa4aWbZ0ifB00Tr9LyLJzJ7eIizv4NYAJ7XzooihU6jDUwjW0vES5XZSt1J7e5jwDdZZYL8Ie/q3Xps+SWLwedyDtCJQKLLQE7afmT1Co3A4Xch5DWTs2bOr1TfNZQRDnbja4w2HkgTTjJySFd5sE94RDYFm1ic0xxnJw3YtuI7LiXtIhdvVEOCNY1DXB8lcQK42NmEmEvc1YfPZ96RmD/QxOnQNQyWRZnmfi6Qcdl+dVXlsiuK8jFhbTxpTxD7aMlxeJpib37OGvpEYTxBo3ZGlt+pmhWQFY+fm1kT9ViBIdI3dHeJyy3AU0WNDZAvCaJWGjCcovVDhVZFHZzN39hAroT7e1Epxpvwg+SWsJi+5JQeBmyoXa4PrPU9P/bL0JZaXjEWYkMRAK6F8IoK1bU3yhDTc3ZY3otH31yGOUA/eTqfhoedQd79JkHaXc9AnqvSSvIvDKAVYoIe5IjS9KY8pwOgMIi6XYhhe7nulmLKDDjYbkiu0NV2qH2N6WqgQBXqyG/sV9qXolbsW0vT9wwIwD3BYrB4Ocfd8DNwtwVOqxLekFR57fKtTrUem8yt1ku2F5/mvvI4NqQCVSQwQrpd/ZMRooCZxJKvueTqyTOujLmq/i/m8F7quhxGfAXbjPtgzaGC2iCGV8XEI93aUJG46yy260wujNDm9
 e6KZJLtR
 fNMnSYmQM08lOAiCoY58Ul0ql0kjI9Ohj8RVD8PVnCR+1mFe0NOkEGxvrNkWdUWhTFaZsBdLEUrzT3MbEb8yXfbCUfpiV9pA2+g8IFU3jgeCzmFGE7pwgAfLBD8Ap2FRjeaM+azCaiwQ16/idVLUrT2+bIx8DuqlgpQHu4vYSAQMhYN0eJhdoyDJ+WllhK+siIDlg60ZAU2E6hTrl5QlBhAaB/q5zCVOWDyOdV0nf8gWxYirG/OKSbTsIjDSgC0VpTdL47E4+/3u1X/84cPnjmUJXdlHUxF/spbPGmCZuHags6HfMKWvabu+aRPBiBD5pFtAgiHkVl4h0qg62IQeCl6D9Tmi30Ze6f1Y2J10wWTLcFG2cwt84v8H3zA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON section name is 'DATA ACCESS MONITOR', which implies it is only
for data access monitoring.  But DAMON is now evolved for not only
access monitoring but also access-aware system operations (DAMOS).
Rename the section to simply DAMON.  It might make it difficult to
understand what it does at a glance, but at least not spreading more
confusion.  Readers can further refer to the documentation to better
understand what really DAMON does.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c8bbf70a3c7..ca8e3d18eedd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6738,7 +6738,7 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-DATA ACCESS MONITOR
+DAMON
 M:	SeongJae Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
-- 
2.39.5

