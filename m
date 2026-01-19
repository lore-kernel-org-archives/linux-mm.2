Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51ED5D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9041F6B031E; Mon, 19 Jan 2026 18:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F5B6B0320; Mon, 19 Jan 2026 18:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A016B0321; Mon, 19 Jan 2026 18:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC9E6B031E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBDE713A8C8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:00 +0000 (UTC)
X-FDA: 84350240520.10.27CC431
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13F55C000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Br5khT2B;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOhimITwx1r2zuEIDc2ZQ3tSXbcjEeOsA5hsp/L0Lbs=;
	b=JSBDVGS4iX2q7jExXLwmhZ/Zrb/TBE9DTM54B1tnvLJ6l4jOMUra178mn2lqiSDt1IvQG4
	izUh2d47M5srLsJCVhhEvyMrpE83ww/QwYpJotgVzu9jySUUyGS9gTBoKqkwJDV4E0tMFu
	hKatmECcP2jsBorf3zD7hvLDDFOXlvQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Br5khT2B;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863779; a=rsa-sha256;
	cv=none;
	b=NPXrKkl0Q8WM3LoCyX2yVm+NfJrHgTn6KH4aAjntNelZ/IvHTdytn5+FQ8qk85bgZIQOW7
	DkWtNM7WTX3XAtA7MdKa5wH/MdQQ1+fVS9jr2mZpzcpa11sDONdg3tlzVGuvoBuzNecLJt
	U8PwZowaLo/4fEUnex88iwsoIEyHyZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46EDE40846;
	Mon, 19 Jan 2026 23:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F01C116C6;
	Mon, 19 Jan 2026 23:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863778;
	bh=QtradRf0GStbdIUHbJa+QxsYtSkr1ee15tID6//kWAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br5khT2BqgdVGETSbAaQu5YrjdjqXAvfXqQO1VMxW81Py8o5g7cf/09LcteyZ+CjP
	 VMkGGAnJ8GPsE1LyANcYOnXfeiSRbDgg7MhrSmwtzPuqS4MgxJRjqVToYtAkXTPVJA
	 80NtDQhI3xgllJk3hAdxv2JszAzpIuLWMNjNgYDsHPyM1gnGqRaq8jiISVtc3DSKb1
	 4XUufNGKEG13eLM3e8HEUHsOs6WdQVrPLBpmRGZZS+cPouXUJUplA+4tg7GZ+4ZUma
	 BO4JhKXQUjH3JcydqiW4udhJysaXEMdd7XxhQCej1whSbJaHBvADBiVb/EtAMzsa2t
	 rnfM2VyKYEtZw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 11/24] mm/balloon_compaction: drop fs.h include from balloon_compaction.h
Date: Tue, 20 Jan 2026 00:01:19 +0100
Message-ID: <20260119230133.3551867-12-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13F55C000D
X-Stat-Signature: riporxb679nuwongff7dhdgdipse4eef
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768863778-181772
X-HE-Meta: U2FsdGVkX1/s7V+yWBS7ePpm6YnV1rcx1n4z22e7657XdgzI/Wluo0aAU+a/Pb8IM+5nXzY9tLSVJ4ujU3yj/Z80Oow34qEYOZlyRuqNqnpmBBY5zSXRdBFq27xLawaql1VemMy4JE8ID6Ca603nYAy/6rc7/UFMn7j1zAqU1wrzJoMRraYPV10v++y1CPS1EJrVmhO6Jd3WCczLHg9F+KnADHg1XLTLGijoiqYeqPLyJIkDStGFov34lU/6/iNjcaW1bc8TUEm7rRijSNCRCvFdVZe6IF1h8hJDzzYQR8w27Inb4IgtYUy0+2hZw/z9vaOW4fQJrlVk5R4W0Cjl2xw7fDCH/l+lcGRR9Pp/Jc3HNy3dDFh18xJ+uglE9OOx2ZNIbU5IpsZR5tdPRdNweJjHuS4LaxYTbCo9r1BEZHiFlfMFYe9S/EQryMv2mcvm4MZFbxm2Alp9uA1n7Psse9UWuOeqtjsq41FBDLrO9xAyMbjx9DhQv6o2IIAxKDucrlA1wtmKbpkTjWmf81RaScflqh1PImBZsOGLIhoAzGBuDsKd4WvN84Bq9I4R2JEN8L/HXGsdKq5arQbFtb9X5sYSkRsienrHh3168Y3nkYf71lhQwYgu/QOBj+tGRUF1SHc1CQmuSDSTma4xfNc0GM9bY+br8f+qyConFWjUNlR2lRuruJ9wOkJfxQ+kYwfhdWRLZBGM0WmLQ5CwbIybGWRBmDai9EVsSecPOmH/aQomngdjDSMf9EEbD217DCiE/B5XO5twk2dZWHCmbGYreKRFQSjDmE/n6SsLkLzV6IN/wkmdHHcBlX13c/pFovqg4CH0ubLAgSmwGQ/PoUDaGKiBB/FD9atXMh/Wn/HefNAXVhfnyn3oYnkf+u0QMu38o3CKpvreLW1Ax4Uo9czX3zLGJ8H5oqF64wYY7c2f83G5F2MlUgO2/AKEkdp+/lGD3a/7rCIcrQLAYZu20UW
 SHSD6zA8
 RHl5sffS9g2oX7On2m1mh/UhG4f3m6IjFS4A8hmRI3pbC2Hj66RY7jeIQmfDqJAenI+B7e/+/qwr/9TAwbXU1Dbm0Gx08z1tWmOwBN0nGe9m6DiXXP2A2PqY/WYyJsyO/nbFVmfqxOoHP03D9qxfzm00kIGVKH+rf6s72j5FACcXJ5jXKKROOwVRtgY2RbaJCTDs+w31SXPNWXXhTrB/7J67eLBhWVuUlPgTdxxi09lAtwR4qZhYGzSa6MG/Zv+tZyyqdCbY4E0wiTxD93TtzT2jvjCF7IbmtDIuKLTpPqItwbpzDnvDzgM+XBHi93S2hxmzQq/15MEZM5RKadfe0HbickC1EtV8Q5lzllVqtoTddqXs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit 68f2736a8583 ("mm: Convert all PageMovable users to
movable_operations") we no longer store an inode in balloon_dev_info,
so we can stop including "fs.h".

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 7db66c2c86cdc..1452ea0635245 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -42,7 +42,6 @@
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/list.h>
 
 /*
-- 
2.52.0


