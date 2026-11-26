Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B2A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=KTJSlmNc
Received: by kanga.kvack.org (Postfix)
	id 2E3DB6B05B0; Thu, 26 Nov 2026 11:40:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294456B05B2; Thu, 26 Nov 2026 11:40:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA306B05B3; Thu, 26 Nov 2026 11:40:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF0886B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:40:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C1C7A0232
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:40:19 +0000 (UTC)
X-FDA: 85477832958.09.61F8FDF
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86F84A000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:40:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=KTJSlmNc;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795711218;
	b=daRey5BAWI4akRyiwRhoIV60txf2xZ3LG0QxF550yEKHWMIhT7HXv/PpuHkf7tF+Qpqzup
	Mf9R75q7yjfxUD8CZUYXUNddbQFwF/p7Fn3SkKRZaoDOuuiV/ee6RFq6h6EpcqYu6FZ0Zo
	EyPlkw+ZJs6ms6zvcWbxHDIGSERzCtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795711218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E8O7WWNKkoQQEdjDwXx7NGol23PVosBpBg3kNF7U/ng=;
	b=Aks61Z7xmLgI9c/IF8hDO5YjFSFpW9rrTd04w49sCPnnEox/6YqKvXEgV1Me6LwrmTB/xL
	zTjVhjTzFo1KWkFELOUaC0calwiEyn80ikcIeLMQIEWah8K1HGe7sk//QZl5P+C37rw2m5
	HDUW7MsPqUp9naafkhBxZ3yQyATuX+A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=KTJSlmNc;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=E8O7WWNKkoQQEdjDwXx7NGol23PVosBpBg3kNF7U/ng=; t=1795711217; x=2111071217; 
	b=KTJSlmNcaF27Uo3D+BbLykYKNod9jRTlbYPfljNaUuSanI+PakmNojTHTGKoKk4SLORgFU0APgI
	nr+093K0BgRnqAKhq3LvsdVmXvRBIc3RQfH8iSQ3S0h8GG+LRiNN8HN5XIcbDj8rZ55L6tQJFYVKE
	UsckyG4sxbfDbACFYWYaNockxaDOmOwsIJ76eS6+3t3GUuzKW3z0gnfJSQgOxEUgLxU5/uugiZ82I
	eMKjziAldVMMovFvYgifNedQ7s1FA0f/nBZnhg9RK3AQK9hbIoUHFZsb962kz5NT5eOT6SuQAo2Nu
	cw5/VOhvUbBVLRu267KJta8x6RKdSxWsFhgg==;
Received: from 186-249-145-105.shared.desktop.com.br ([186.249.145.105] helo=[127.0.1.1])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xWcW1-00000004U25-14Ux;
	Thu, 26 Nov 2026 17:40:09 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Date: Thu, 26 Nov 2026 13:40:02 -0300
Subject: [PATCH] mm/page_owner: document shell usage of page_owner filters
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-page_owner_filter_shell-v1-1-cbbcff2fcb08@igalia.com>
X-B4-Tracking: v=1; b=H4sIAOFgCGsC/x2MUQqAIBAFrxL7nZBbSHSViIh65oJYaFQQ3T3pa
 5iPmYcSoiBRVzwUcUqSLWTRZUGzm8IKJUt24oqN1mzUPq0Ytysgjlb8kZEcvFewM+rWcgOuKNd
 7hJX7P/fD+34xbEk7aQAAAA==
X-Change-ID: 20261126-page_owner_filter_shell-efce38f24e20
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Zhen Ni <zhen.ni@easystack.cn>
Cc: kernel-dev@igalia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 Mauricio Faria de Oliveira <mfo@igalia.com>
X-Mailer: b4 0.14.2
X-Stat-Signature: 8gmobmkppr9fbxry1hwnimpbur5u3imj
X-Rspamd-Queue-Id: 86F84A000B
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795711217-382124
X-HE-Meta: U2FsdGVkX19I3xNJT7jASw9o013v5/wjfjA58DvgDTMza9poKZxkzzQ2mI7LFRqEJWA8geXxN5FvXT6DcznVn7CjYSny0UTY4ohm25eIPz1thwRLgPJHSRGDoEernvxBzjZnlAmgJHlRRXpdybmUWiDQtXEYRdqtl/sGn+1GKXZEaPAVOTYd5NrEQvVAHRBqdAwSIurrYOTXTmoJXG7r94KmuHiyWS883vfRMRH7wTubOympoItiTzpIRIJz+h5LrpRg7XopFzYL393NPAY9JF4g6XkIf3Q3PkY7eYM3vqlU83x1IKMX4vp7m1GFI2eAMPqUSPkPVhd7NwJi0l0Vp9zYBqZJds7QD+U4Fd0Fw7IOBWb5XkTCUWfi4iwiV6wjdKyCyk4wqFhsB/u276YF2WcbLLZLTNWYqWZavEz8rKHkBSkQSI3ZjuB6ZROk/FhuobOQLHsza7oGhZJo7kFjn5w0z3QSOjKEiDK9AP2gE7KbvsiATfjERN45SP+UjXwHKXHpJLUvrfmfmLYhuuhze1Qfm8k8JVKLiuZSt/o3MlSvfnV1eu9fY/WnIFTJYswEJy44SdAd2KMV2hs9buJjRXvv34LdpFl7dp6C+b5gN9b7zoOhg5QuVWcpM8i77uukOalvfgQuWtD8sdD6o2eJTregKVGXAO/TXBYFGt8WiGzly67g74CEDE+OXBSQvOx5L/4+yerefNvQmOMvjv0IfBXZpMzvF50BIP8iK9L3SvlAs4DAhgRU7SWUGdHcfrX2mv1Hkjb9s4wA9ZFba5qlvpEruhDX6WWsCdRdjvEqPHahMik8/IXF6ap7da5jpLV03DTgbB+HfRLSKrz1svJhvpPy5DKw1s4wGplh8pZofxVmRU5XeNwOiAeD/SkX7AKZUJEvE/UzqljPtYdW4zpXo35Wt37LQn4OqjxDWYcM8G23mg1BJ63illSBiw1oEGmok7yJyF08/AEUY0/kpPI
 YqUWq7Br
 vDAcLFOq3cSQxgYprl2Y9QWwr/CdcWJ8rB09YIiNFFg9gVQ0NtaJLOA15hQQHz52JYmEiNNGOJcove8c4y3iDxJgkAoHPBXGdAjYW/0slLsqcKLCjPKHXuN8euW6VRDjTOJ/6nEQlFzAYhixnfKXYRq/w5nXlHWymSJnpVzxs4TrzqKXgfVw7T2wzQfy4UvER8lVJfCjhs+a+OjrXeIJWR7IYOAewNENP6fb341Ck10Ai559iRpgOJiPkemD2K2NP8K1GOepPJHnIYwP/F4hzcW9lYstzb0KDP16vgDw3laIUEi9IBKNkRcpjFfhwufDDTrCTfwqHYURy+mu2kDljbsjrrVAhOk+UQlmNQ6DTkuJ1r7WR79sJcnOfHhed7qYT1hfVh9dIw1jCpW015697sOYc50Y8hA9/zrJnswbeHBazDOOU6zFtIKOcp1G7a2l9/tOKYeTUz9Rq2upDmgtMyH6bbFpl/S9TPh8S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document how to use page_owner filters directly from the shell,
without relying on the page_owner_filter tool, with an example.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
Tested with `make htmldocs` and checking the change in a web browser.
---
 Documentation/mm/page_owner.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index bd027377dff6ee8f06462884baee458d621686b7..11fdde0ab77d6610dc3ad2234e30238bcdf1f226 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -343,3 +343,21 @@ terminals you can run different filters simultaneously::
 
 	# Terminal 2: Filter node 1 (runs concurrently)
 	./page_owner_filter -n 1 > node1_output.txt
+
+The shell can also be used instead of the page_owner_filter tool, as long as the
+same file descriptor is used to write filter commands then read filtered output.
+For example, using file descriptor 3::
+
+	# Open file in read-write mode
+	exec 3<>/sys/kernel/debug/page_owner
+
+	# Write filter command(s)
+	echo 'mode=handle' >&3
+	# (and/or)
+	echo 'nid=0' >&3
+
+	# Read filtered output
+	cat <&3 >output.txt
+
+	# Close file
+	exec 3>&-

---
base-commit: 9437046953b2fb3bf55b36582450ea0267df82a7
change-id: 20261126-page_owner_filter_shell-efce38f24e20

Best regards,
-- 
Mauricio Faria de Oliveira <mfo@igalia.com>


