Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B128EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB156B009D; Thu,  3 Sep 2026 14:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D2F6B009E; Thu,  3 Sep 2026 14:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848DA6B009F; Thu,  3 Sep 2026 14:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F28F6B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:30:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD89E805B0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:30:02 +0000 (UTC)
X-FDA: 85173290244.21.91A431D
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09D78180009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:30:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Z fVUbLv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dP9rtL8a;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788460201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEML2BGHrlYhrMvp5AB1SPVVJb0CVEuxfoeolIQgojE=;
	b=pVECM9Nme+p2a9BI8qR9aBNnRn4OTn7VO8S/Xf+XOLBmE4Wo+KCb3nw/p2ajB93HH8ICDC
	FFLbfgb8V2IcURSjPAaa+MyNv/3Xzz3qNXUXlOrWXc9o6wvGou99ynQ46vDaVS+z3B+Aiz
	/GAkT9UdDtIolhX3qprFAJZFUe8vStk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Z fVUbLv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dP9rtL8a;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788460201;
	b=E8cyS4H1YGG+QDVJVFUCEaS66VV9Y1cjyU0gah9Eluqs9JoHknhra2xxN4WtkCgalmzTtf
	A6YEcNwtUonxOmIW1vETQ15BJq3V7bgEyqn35mnh0XELZlsG9FhTqxs6iHrHeRjHfG/bdh
	mQYisl2DtGhaAXdd56JkQOQjOAqHD6k=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 9E44E1380124;
	Thu,  3 Sep 2026 14:30:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 03 Sep 2026 14:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460200; x=
	1788467400; bh=vEML2BGHrlYhrMvp5AB1SPVVJb0CVEuxfoeolIQgojE=; b=Z
	fVUbLvAibQBespoCa9TCmGkV1BnOYkv1M/xJyjDG1gyY6rHvdR22a+kfxPAs9MB+
	XF8T/bbG9xC9y88qQ7bqtuGOLmN6GyKlA04aHOkj6hwVYPfX5KvBE9i4zrntsoBc
	tBOg6sEb36G1eyQGKX139+1gpWGm14daiHOTVoCZKG5VCbGm2Mx0xkUx8T0iPfcd
	OLUWSUDJe9K4rQ2LTTeG7Ivm/ELObsZvHg8cl9w3j+mk9kQ0l3d6i2Z48RHFI/s4
	jj9fCAIrR+St/752PEaYXkx3nnn/FJRII1xpI3iZ+oDRuS6ItlzppRL6SDlA1WSi
	D3s4QERuEPkjBJ7cEnO4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460200; x=1788467400; bh=v
	EML2BGHrlYhrMvp5AB1SPVVJb0CVEuxfoeolIQgojE=; b=dP9rtL8aWaMErlaKB
	Nkd+BmzduYONw4oxo8AFh5+75pLVElq5D7eNb7mpykySo9GBZJ+jVX+i19xGyLFb
	zM3egKiSN/yx5SzY3GDUm09bVmhK3GpOwZLiGioDnFBlJr0c/oU+1AAcef0TjgFK
	S3QnZIWeslmK3MSf8KJIbLZ/w6PFdckq2cyhO/UEQTwxQqMB7BqQga5sku0v5NHU
	mcG472xrqnHIjIaKZhnk29PWFH1EfImKodpDQqHzcc3twt5NjIoBxidJHhtS7o40
	tRdiyQq/7NNjATGbFmydEp1mDz7JngxCkXZ0wX/JN5IRKraMy9Fp948Dhg9pgydG
	Mvj8w==
X-ME-Sender: <xms:qLyZaj1TstH5-9fgTXdLz16Njpffb4ac_Ql1mcTdIBcY7Tyl7XYSng>
    <xme:qLyZajL2ogk4TNopHwwTJK6rWyYiQTstiaghUrznuMP9K-OT4FDz3Zwol3D7nCqKs
    EIdeVVe1r9Wv1GmK5j_ErVpSVYA2hWtnd2Hw9-tMbJRqu_bmE03bKT_>
X-ME-Received: <xmr:qLyZam2UMwwXGWgeHmPlvZzIG2lUP9mo7s3W4WhX7ibE5LmnR1oF7jKmIg4>
X-ME-Proxy-Cause: dmFkZTGHxwC/Lj0Bpod+4rdZ9spd4mDaW4xhMdggMrFSzQCeA9RP9FzsfDxO1aVEQuln3V
    KlIkun03rqLJS4PF97Rrmwc8zvF+vhZeY8/AccbFhjx8xCTK9U2xEB/cnF/j4CrJu3iI+j
    BDg6h6fOcXVaNyEdDW/UAbX4yL7zrcocoaRK+UcMxdgx6bHH3qnz957Bwbxgg+ymAK7JCa
    v7gyu76p9eB8jE5O7T8JvzBRYgOMnbmzr1XCS8fmgHILKnNDK2ydQ7V9ZxlyJmWme3VYwV
    QfwByNxS35mMCJZpf38kt5LBBSLWPp97jeu/UaoDB9vrULq5ydrUj8GkH6/ySug8LGaySq
    coUY0N3OP70olSepNjMeWj5mqOhaxOuR5jUiYT9qIhV5gEVXIDgSEmlIq8NPzpG5TPztZT
    WubPaJmIDKi/lX6eG+dHBjR6VX0xMvJQxZll/fBCukIBGXC1ExxQGK8KqqT5cX/KXlkwXM
    4FYqT0LZXJPXcs6JPOJlwZm9nBcXjg5gjUkk4fNwkkMwx1NTEiwp2NyuHl07d80tuzCaLf
    F/Phi0zWnhMgDDVo4rrYJn7Ffca/6UsJYfLqR2BjyJWxCoYQuqWqF79I5bSSMubeuF+mi9
    LY22vDexfWFkE0EbRwniR67TbvH9OSLcNCYrDD+BG4uJRdtDQghYe18qvNFw
X-ME-Proxy: <xmx:qLyZamhmpjZa3d_wEn8mu-NXpWtlz3nuS0Gh5Ul3L1mL2XL410nddw>
    <xmx:qLyZau3FC3t9eyuUqJB0FXsiPPfIUMibATQfBvsJr7DwwIpHBzsmPA>
    <xmx:qLyZapfMll4A5y_W6IlQX_xh9a_SFLEZdtv-PV_5_ck6-hKsKI_MOQ>
    <xmx:qLyZapEe_Xlg9CVUzKRsv5--NXuehRYlG7dAWMIeNVExk1GqEzxuBA>
    <xmx:qLyZalEjUMEMKr-o3DecT032H0k8BjpNewJt5mvo0AOG6MUls1F2OafH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:59 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 5/5] xfs: track mmap dirty state per block
Date: Thu,  3 Sep 2026 19:29:43 +0100
Message-ID: <20260903182943.662461-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: <20260903182943.662461-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3twhntymztee4z1dr59ge338qff48f95
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09D78180009
X-Rspam-User: 
X-HE-Tag: 1788460200-351531
X-HE-Meta: U2FsdGVkX1/BJIHpbuucbR8j4LWbgJ6JjCDICmQlvxqE6IbSsvFmj+Y9xC4dt4S/2T4FoxqQh8dRtLQV67eYtZY3z+NLBqk6D7c9zGeLgwFkyApeKvu6Y1YIN9O5YktrLtFOBXSGWkArZy6tzctovQqE9IZQmJfFOTF+iISPPLnAM0AKftVUA7oFYxlKYr8nWCu0Ra0wHVlzfKdQSG4dtf0lozKLDmJOJSRAzuVEIPFI/RTTeUJk39gmEZ0Did0YnmQjaPz5nlpj0xeB8DEqoeH1k3OyALjbU81GnlFQyaQq6xxMAcVvzD0y7C7h/oaA6uMPulXo9zWfXiUdknjZeQHiYFlRzximnyPOI8YVSvAvgmBD5JWPPUbj0YnrPzvvKt71l9UQctYqQunp6Q9tD5nv44ZXwSfUW1Ed6J6rtxKnYBSaOrVDdN/MUTqaO2xDkqSWKllfjK8AxB31RReHjoZvwMvPwolTvT5S+SLEHjQujacWPSFLMr63woSXIkOh97nEv2/yqaMiOUPEgYEAuoMLq7gnRHGeEZ0AqsC0gCuaHYPdmx5Eo0LVb6dZVGZjSR4FdORSZsFbNl96JsaQbxTfng1WToCuss6yTwu8Etf6DkbvKre9WXWhyNJhPknUQ1GupC4kduYNyRKPDOqlze8l16XQuzwKmY38HppZbupSsYMbMgTS+sMqvA3I5nLqy2ILq+zS+s4HtM0W1gA7rQiOYHoWczF1QICQYVHjp+XFTc9vXaGMwr6wxO/QeuvCak25SOPQC/OZ/T7njopiTGQAOrYm1ufTSDULxYqtZrgTTblBHYBTmrvaGO11xEyDbKstGNPsZeZ8Vc9dUnxxM/jlzR1HC3Y9Sc7WrfaxCQH80M2JH2hdZ8BiKehQNSoZIhmYonef8XqFqGUGrmF1IMTLs5n6QiJxR35kT3MnAJIQBlfJjB9pfttKDZ7GMTDO5/CaSOlr084gQdtBFfT
 KeWpPVsb
 KOPA/K3XpC6qmDUykrPR9XIoZlZvHEeOGFRU6oo+rAAayAJbOV+TaYS0O1mmgfkozyerHQ5uWppM6/+Ubo70Q2OI5V4kirZitlwu/J2QzbevwnQRIW/2fMlEUYy5QTSQVDClH5ARUDNoL6ZCf4MqFzjuVyaVbgZ3Gs/yXZLt7cgHSPUodrKSOtKvTaPGL8CEUicc89oRGD2M8WfqwX80mPb/13J9DLxbdFdhNbR4bKfW0lUKw8CJXUj6Cji4ZdLq5zEX6ocBZP2deXTm5y+fdzxvnSFodOa8/3IMMcqt8R3vSSQdFdHxv1WXj+W0gHCtwbLeeXUMI1nm++KuUKGhTW4THZlZj7SP2Nzb9FWhKFvBHKbPPbPtdm1rfxbWpBwP+mp6DbPXj1oaGrhzmLGlK5vbBbRR6lvlBxbvgdmVnkp6yXxlAM4dBQCxmgu9j16Dub9j/shdyEP2sQHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

With a_ops->dirty_folio_range() wired up, a store through a shared
mapping writes back only the block it touched instead of the whole
folio.

a_ops->dirty_folio() goes away with it. folio_mark_dirty() reaches
a_ops->dirty_folio_range() with a range covering the folio, which is
what iomap_dirty_folio() does.

On a 512M file held in 2M page cache folios, storing one byte per folio
and then calling msync() wrote 512M of the file before this series and
writes 1M after it. Minor fault counts are the same either way, in both
the PTE-mapped and the batch-mapped case.

A PMD-mapped folio still writes back whole. A PMD carries one dirty bit
for the 2M it maps, so there is no per-block state to recover.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 74a6089abadf..600e7de2e599 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -863,7 +863,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.read_folio		= xfs_vm_read_folio,
 	.readahead		= xfs_vm_readahead,
 	.writepages		= xfs_vm_writepages,
-	.dirty_folio		= iomap_dirty_folio,
+	.dirty_folio_range	= iomap_dirty_folio_range,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.bmap			= xfs_vm_bmap,
-- 
2.54.0


