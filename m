Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FEEC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0306B0390; Mon, 17 Aug 2026 00:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77AD6B0392; Mon, 17 Aug 2026 00:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4246B0396; Mon, 17 Aug 2026 00:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A425B6B0390
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:37:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E6E6804D6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:37:14 +0000 (UTC)
X-FDA: 85109501988.24.DD12007
Received: from mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
	by imf30.hostedemail.com (Postfix) with ESMTP id 49BEC80004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:37:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZXnm9Yq;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941432;
	b=WF2XwY2zprZ/HJMM9Zu1yql0KThIYU0TkfqcDsUWI03HLKavdjaZtkL/2sGj6+GMfnKPXA
	wHNYgWlfqqw5fpkjbkaSOhkiFIlItCnOeymMrlS4nd6kr9GQ5plL4oYIxEO6PcJsPzwtiw
	rWs5y/Nr5E2EmEIBRJszNjxTBn+Mw0w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZXnm9Yq;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQVZWc2/JWe5tCn5l2jWkSOLcNsDOsT2p2+BDwA76P8=;
	b=4z0ZDQCHZUUfjRvFAZLjbVhOEO5v8Y5U2FKeNUgIoY48edRErlFp1C43hkrQcN9wZluXWq
	nvsGopEuqNzsmOw73DcLuCd/DCncZOHGJnV36rLKgnZdv+8KcK36UeNcURiWgsUtlCiikZ
	fZn6CpONageaGHTLpKSghIeY0zPsZcw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SQVZWc2/JWe5tCn5l2jWkSOLcNsDOsT2p2+BDwA76P8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941430; v=1; x=1787546230;
 b=VZXnm9YqJYDISNjsx54ojc8FArPwMrIOscHxbO/wzT8S8mX013hmSk6zI1tVnfJH9JsteqOs
 oIDQYbIOPZYmKIRIaGj2LQgbxyjYNiProYJd7aF1121ldqjZoeIDYCqGP/sRBPU4sGJnON8m9pt
 4nnBnxoHqZ8WPYN3eqSNwEGg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 988b58362ce64e26;
	Mon, 17 Aug 2026 04:37:10 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 3/7] mm/khugepaged: introduce a count_collapse_event() helper
Date: Mon, 17 Aug 2026 12:37:02 +0800
Message-Id: <20260817043702.83778-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49BEC80004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wiebmmaga8xc319o9pd9woxnx7u8q3yd
X-HE-Tag: 1786941432-838200
X-HE-Meta: U2FsdGVkX19cAKoyReXhbVUIiB2Y0Lgp3zNprkXUyzY5RTtRIv4diD3fHEuMcoU5CUCXyOEXI3Q0C3YVF4WiB1vNemRVWkwFF8qQPbuBaDPdeU+z+buZWIV223mahXQpzTobgExes9Xftk7QU6ULPu7AobQYWK/hoFqMC18uhyegZYJWnpaYZdFQuLkfhNf36Aqz/bO2/Pnu8LsYgsynvSWzN6ZaBaTfnPORTOlBHGoBertbYN0bLR4yisliOrbxYzL8f6cfwSoA47u9GewVU+mmhHncx1B5heS/UmOH3CLD/L/X/bhuesvgyivCZB9XePeTu6yFTo4fyaNU0f6fbBqxeBxM3pXlLKQrcLCyfLZ9RiXE/o13oAYWEmEtuVxAQSlVgG3PtChQtkVzayn4C+SH4q28EfevYoH2mkiHN4qmL2IDT+pI0TATPa+29PiMdw8zhRo4zHfjrhaodO0xkLZy9vLhESfagbfxxmIBsypEhzb2kkFdYCNemYviWlu4KMCGPQyvFtegGDlYsy1Ez+NYPn60uZXcsq0kN6doajnd3nn/Dfs8S788DYTydlF2W0C75QL8UWpgQAaZYRKIoER1TvcnLM9ZrtQAfpRAhH4fjWP1GvprAQkk1derTS2IAd9pFdx8spfvVsOvgGlzfOl8dLcvC3f1B9EHputSFqoes7CcQZ+F5QKc8eYp58PO9GiL9SVLwY9/pcXYYmaJsRgFTGkJ8e6q3XRskPZE9yQQ6veCqYUKn4tH4J7vYmg1+db7qNNQ1mnRNSk1JKIwEVjoOUYDjI8YQ4oAZLx0gHnts6WSQItgJTNmJ6REio6o50atx1GTbeReiZl5H6xG12GFfIQuCg7eLsCQ8unP73MXrlDRd8ZjGhUxm4OZkom7zTkFT5SDLgNt7vELosuHIxQCAycItQEg9v8iQnTLHlKAAUCEqE5Rpx3Bl6IuHSwWXaTqv5rOAId5Fx+cLNj
 YN5XT+TE
 rHeOpbL3KIVWCMOd58BIf4wHQByz56rer1j411dlIslPPxj0xQtM2fnunn2PJrOoS9yZ81+QIK1hwdAgMaVRS//VHxt/PHE8Eq26/jtxjV/mBChWvV1wU9kA1rmRcFAljAg0BLDIAIKt2zQJayjUD3phtx3VW3BKfbFqeRwfH3zxWqqeRfFvwl7ld9cxaU7u4S3IRY1MhRs6PfEdr/kBOBgvjDRLAxST6HEVEjtE99hApRQXb3Ct2dR2XOss1j1ERnAOnGAVv6D4KmyD77vFT2dKsSPFsrrg6DJxlgeZp5Tzq49UjPK4FUoda8cwEPR9V4HZcCk9wkekDWm7N8MuN1vZ3YCm3aLkKpdvGsv075scX9ruUEVFXOJzrXmhRZ7d+aMvw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:35AM -0600, Nico Pache (Red Hat) wrote:
>Provide a simple helper function to help reduce a often used, and
>duplicate pattern across the khugepaged code.
>
>When collapsing to a PMD we need to record a vm_event and the mTHP_stat
>event. When doing mTHP collapse we only update the mTHP stat.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

