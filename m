Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F203C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859B26B00B9; Tue, 30 Jun 2026 15:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A4F6B00BA; Tue, 30 Jun 2026 15:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8086B00BB; Tue, 30 Jun 2026 15:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F44E6B00B9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2BBEA0508
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:18 +0000 (UTC)
X-FDA: 84937517196.28.5715608
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1FF25C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hv3BCoM8;
	spf=pass (imf28.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846557;
	b=Hsd2c9l/vCTZfJCk5zIJlNDpjL5dNHWb8Ex1gwRhFEgLrBwDiWcmirWKyd3HmDpUTj/RS6
	uqzTXI5lUDh7npEZrCLvALHhEums0F2BHlMf2/8HaxqIVt+SfXqHgIVmVc6dPJhgEvWqRr
	l1/vEUOrOxpb95bgxAzJd/4qpvUfDIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=;
	b=VZJToQo7DyaUH7ti9+OkpcOZGjoyMTngNC53lfW7idlambYWVjpvt5iybRBYdBOorAeW0d
	b6jpd1ManbfHQJ5JQnmCcbwqTDTjAbCMn8/qKs92LHq97SUSbiRXooxCXd4nqnQfFRpjpG
	cw5jyvhq0sV0HXiKF//luY8amFxbDeE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hv3BCoM8;
	spf=pass (imf28.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=; b=hv3BCoM8vhD3ocMbMRW9R3ul2v
	7QY9ljFg2gkawpcfFGmEiMDJssl22em6nqlJdxIU80C3bD0G1tRyE/u515jayxUybath4UMOTvXNL
	zZjCBCmV3zGfSP6ChxqqGlCDlRmEbQN/eXHyYPTlAzgJjjvoE5p9o1r1xkX5lyohj8pbgiOxOQFYk
	PDvy8+UmQp76EYOi+zPmXxK4h2qj1JVQbAn6MiP9OP3uYTl+vm0U2ZEWu69riigKcObOBnp8YzCpX
	dLaHHXUtUTv3gvcE+gIGfyRdzXr1H3+UpP6/mNbYRx9NpRpVtGn4a5As//A6HDCe6lZi/TTcZ4LBs
	jaZbkLOw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpb-0000000061T-3cX9;
	Tue, 30 Jun 2026 19:09:16 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Joe Perches <joe@perches.com>
Subject: [PATCH v2 16/19] maple_tree: Change two GFP flags in tests
Date: Tue, 30 Jun 2026 15:08:40 -0400
Message-ID: <20260630190843.3563858-17-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k67q5sti15nw8x17uxixztcpp4cd47hg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FF25C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782846556-699831
X-HE-Meta: U2FsdGVkX1+v3PhMdSek3L9i6XaNeWyx3uAv6FdgVQVnY64ZXWr4QNxSDLauUsbmW9oegP07yik5ybfge/3B1vYwT5wBBiJkGadWIEsSsxxDhZ2Wbp0ctkdFHMxRjmtzS15QjjmEctkZjj3fNRtr3+C0Y93B+etRNlYP45lzOLbMrp6hyYC24UQh7VI+rTW/n688FbReA1Vd4ap/XGDq6ZALTPZeCREpaC7uXPbFBmIhmEQdJ0xe5XhI2emgSEavLCMA5jJ4qCW/79GMIgRs7XkRAj5+cwDFRSGv4o2jdtqrueRpYH0lr4wdRMgIPTmCUsi4B01gRBGBRR1MeOBeaBd6obzSM3uk86OpSMeKoBEzjQRXoxpUm8mk9eZDcoQzOhjXV8RhrlSUSAz4pR2c1q9mZrP44D8U8ytYp1RNwQo+UmjTg6PSnNA+oPP/nEvy6L5SnEQXnuyB7kq2fAVIAyIee5TtdCaL3svz6bvOs4Xl5niSctPgcsqC1oV0RWWDaD/z0mPMS14vGztGuSAyxMSBeOd9jh/sHAbTOXrG1+eOx+03MtPIfvNL82ERzetl1bw2HNSvlr5TV5vhjVedm3OydxxVmGszN6P4SDsnPK2BrVMbxVPUxXpOLbQf8LiKpHTJqFSXGm1sg9QHklUfPCMK2gZ+y6JE0sbPo59nqPWS+hs/d6vARfTVb9OsrhMapmHeCOJ9VWESMBnb+iuQHKZvkQk9F2sK1Mk4RODL0gAhWdHBvqbAVCdAeGnP6MEUXlZrXp1Jlilx8d5kJCutIAg0K3wUv17JWprkcb2MbBn+yvOSnDM58PdOQ66xcQg2/pOlBWpPv6XlXpYjWLEdKA7HdsED9bM8ZjCKavHjh0BZegT2Foj/T1Ia50f95MoeTs4GrsJUyWlH/8Oq9paAxfwTShYQ+QpwIQzXxQ3gKFuujMJ73uk/QbI4ZRh096AKYGdbtQhQJKq7/TPQEBq
 g4jgYDg/
 BzWAKCZQPiSb4G4DoXd/wIBt7koEtG929Opg71c7FTDCB0PzvorszVQlmlCnFReR8Si9IT50QletxzZT+1O5hGseVzjPfwUvRmJ0mMdvaPzhvhVwpaGNdS2basl5QxEY/pxQooshSebpomCUf/BYBN5xzkyO6FUuFt/oA2ehP/8dNZ4NwXvRtrmnLyk5Sh8YAYZzqdJ45KhTJyTcfeI43dB1TE2DrLlPzdjs82gqpFbvDjEj9IKv/RUx6rEfzukNf3Pd3tMb/ZCSRLwm9LdyT+jdt9JLHYpqvKrmcLcjXFKRjZM2sIeh0VL5I3tOpRboCQFSCJbX2KEfMiJ3L+dlPUo4hvIrEnLW99TIPfVUb1yEr24Y9XPbg7xnac0jqOBMciOfd9Nu5VdHYfhcj73TQlvFPwds2KtDpskH7fUFVZTSVftc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 tools/testing/radix-tree/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 0607913a3022d..d967e76a3c065 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
-- 
2.47.3


