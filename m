Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EE4CD5BB6
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCDB6B00C5; Fri, 22 May 2026 12:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CD36B00C8; Fri, 22 May 2026 12:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7D96B00C9; Fri, 22 May 2026 12:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0F446B00C5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:00:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 741291C08E0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:23 +0000 (UTC)
X-FDA: 84795517926.07.0231985
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D098E40012
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2bjIlf2;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/lmuTiZtPMl17nLhjSbVCW4szwACwBZSRvlcNxu5fk=;
	b=kpDFi1UDH0bB39yGWXSG9CyCDs2j07Yn1FjJlfR/Amjzau/5NV8jIMJGTwzFmcycWfr2/3
	24ncs1rD1boTKMWitHkSeL2Vj9NuDyzxIY1nCBPlWZHexu4AsCsfdbR32tyUUCfj+ucinV
	a3eSa+ryrqcghjU0WXbjBhYC0935zOg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2bjIlf2;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465621; a=rsa-sha256;
	cv=none;
	b=Q0rXaEyj4K//E/fgkw/8ZUdYSgVQZF4jh+FX2xn4YXbxdpVwmd9ffG5g3wTX4bAM8sjeUw
	YCHcqCpH1VFbJPpLMK2BOnCV9e3DTPcYHhAE6+c4Y/mQISQSHVs2sK1MTbtoXtyhcUmHKD
	BXQK36bFxO1hixlCzZp03tiY4ziXAfg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 599976021D;
	Fri, 22 May 2026 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D861F00A3D;
	Fri, 22 May 2026 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779465621;
	bh=2/lmuTiZtPMl17nLhjSbVCW4szwACwBZSRvlcNxu5fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2bjIlf2K3GDTF/EjDuqYrr09Zq8Y3kryDvD76ONFa0zAwm+lDaiHhSpjFqm8V4ig
	 c/5PRUbz0vu5jSxMcz1kNWpVJh+Fxal2fdKMBIiSawEWAMmqH8CNBcIs1PU6p+tF0r
	 bp7k4SBOPao66C3nJMwiYYYWcWQPZ8pd2jouhYylWxrYKyvtO6IO3B8wspvUELCIIM
	 ELM/E5eFiWPMvI1sgd5us3M072bRK+d9bFfSX6W+sipIBjm/hmjQowRsvaztFKO0CG
	 ufJK/A0sPZnvez8ABVT5PU3J0s7/PTBwRY0KCX/9JPytZ4k523p0A5EXSAQWduYrqZ
	 N1D+2k433TsYQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/3] mm/vma: remove mmap_action->success_hook
Date: Fri, 22 May 2026 17:00:10 +0100
Message-ID: <2521c19866f3f10f9085d094cc4f06769042be71.1779462249.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779462249.git.ljs@kernel.org>
References: <cover.1779462249.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D098E40012
X-Rspam-User: 
X-Stat-Signature: pd7wqwp5y34w5phetdzjk8emfxkjgtyd
X-HE-Tag: 1779465621-110284
X-HE-Meta: U2FsdGVkX1+XmwVwfxKKpID3NOL0pNvIt8JCQVhTkGouoBJ3V/VSqSmT5b+b/2VhKI6hikEYkE7wV4smHANQLIViRJR/Ecv+bhgpRBF6nGL+1uBqaDhZcEVg43UX0gSRJ1eUPzr9OAyam8MxWm3yvcSFX3xPDWMdL9Bb0JFyCFzlPiEkwox2EVMEXyqE/q9t3whZ7I+0vtuqE8Kh7HKZQWEQM61mljeNfZo1n7skSkqZXeKwJuqxrYaWe3SBytSqGKC/9wOdWU1b2Q0e1v21xO7qq0C1daueCr5XdPBlpjClWlrNpqrXcoKhtH8tXWreN0eDLKGx/oSQRqK5EcjokL8nBdwEyCSpyuw0cf5RW/+Gslw05sY6kmGxAuH04aU1jKRN9CxTQOR6eT4as21I+1o5gDaAUkt/8taptatNdOAnjeuOIMIXTgqe/d8bylIEizRugcrhDvuhjIHcm1UUQxkDkSE8M9nKj6CPjw3RKXDCdmsGx3fQJagsn+jj/1557sou+NSZboe/XmlwiQpfGJhRa8snWJEsBJnP4dg+Ag0x1USJWbKJthi4PKLwUE2kQaI3EkhXavFgSAlCtbXwYYf6E+VQeQBxYWH3q2AipkoHow8MPc2ieuSHRrv1jzKj1P5WaCjjTksPH12osCOFZ8zXkzCSMpR7HuM/mHC0WebD3b2qa5Mpm9ora1Wa2M0kBo5qC+VGoqQDh37dEoYVhjARxKE7ZxQFX3CGc3z3LTvY7vv6DVYrC7FnQkNnBk9NRxu/CepQRw9Qpkge12crKWYoB1IgyWmHtqS2m6HN6zCNAT88seVIM0FEMTJoRkAabCUg/1CoYX2dVmhuUBNAtqt3UjCU8c/zx0Suhj8FaShNsG7ywUrRTbqTpCCiirSLSrbpCmwWSg+tP37EoZ31dc2rvnSIrKRsRrOAeslaIrKKkS0rAG4wANqG84ZW8kdr8H7jyEFWSLrgSVsPdo9
 S0yTyVqu
 Q0xF6Q0wufccoyAmQV1LSuRqAusI/QP9/Bn4GIg2LMsmTDiRdpO0l+yWavHL3Kjg6A6R9Tf7Z5uegIjrt6CsX3UCS2OJeNG/DBurCFDg5SXmWEUpBrQl4ATdlx8O77/zrCyiyeXvk7DMMlMUzvxdpr6mRpzwK/n02pvhANRdhkIo5yUTeqJp4n6dpyi3xLDZkxpYcl5u4vVVnYx5DBuBAqUNTN93Un/i8Y3z4CFlpwEpkWG6289s1SS/8XnfNYwEMuLOF/kIsZx4vLuf4qsxtFHnLoxANpuTKEAJY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This hook was introduced to work around code that seemed to absolutely
require access to a VMA pointer upon mmap().

However, providing this hook leaves a backdoor to drivers getting access to
the very thing mmap_prepare eliminates - a pointer to the VMA.

Let's solve this contradiction by removing it. The key intended user was
hugetlb, however it seems that the best course now is to avoid allowing all
drivers the ability to work around mmap_prepare, and find a different
solution there.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm_types.h        | 10 ----------
 mm/util.c                       |  2 --
 tools/testing/vma/include/dup.h | 10 ----------
 3 files changed, 22 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..945c0a5386d6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -843,16 +843,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selected action.
diff --git a/mm/util.c b/mm/util.c
index 2b2a9df689d7..4e172990afcd 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1397,8 +1397,6 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	if (!err)
 		err = call_vma_mapped(vma);
-	if (!err && action->success_hook)
-		err = action->success_hook(vma);
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 306171d061e7..fddfd1b57c09 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -482,16 +482,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selection action.
-- 
2.54.0


