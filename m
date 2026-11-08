Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5191A606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hU7EM3I5
Received: by kanga.kvack.org (Postfix)
	id 01EBC6B05B4; Sun,  8 Nov 2026 14:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB8A6B05B3; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A8E6B05B3; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2DD6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:16:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C06A41A04FB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:26 +0000 (UTC)
X-FDA: 85412907972.25.0F14A99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3520EC0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hU7EM3I5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeP31xDwtklkLCBDsJsARx3xlsMptNDNnDQPe92kOMU=;
	b=a7ea6WTLRYVNmRYjHlZ8bHuWA7uo/MC9W08apBhftnNNjk8fDaO/f8CwnbW9tJKUHvB8JP
	G3lJ00p6JCPs6IlCxotu14/a3A53fPDyZhnR+37dIQeiSyeDg5x/WRmfu+Dnd4wncOybMX
	DW5qCA1WjpEbxD4gioj19f1ZDxCjG+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165385;
	b=I0RQz57XR75OypK0X3E+6CY3RiVCYsBWLCzIlkH5JdYr2m5m0MtsAdoxTqM3j20A2AaW2t
	idJmnz5R5886zjt0aliHTEEpLiPnIVDkQXi2KuDvO+WIzv1AJ6sCGVhDHltd5Flf8eQCxX
	S/2+1AKe0wNVfEwkUggG1n2i+2ipdf8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hU7EM3I5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C81CE6183E;
	Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498DE1F0089F;
	Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165384;
	bh=EeP31xDwtklkLCBDsJsARx3xlsMptNDNnDQPe92kOMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hU7EM3I54v53dGUQvw/0DPNNvc2Vl2utnr+b2e0l7ztKjVHNigT8AnL6yE259Row/
	 vj6+DTH3Uf6JOTALlbtZuuSgjos5/t+4xYFV6kGEV3e9Js0xdfye3evfjZ00duAzDI
	 nk7IOfMWNTn3MGbWcYSXcRylbAgeLRD0+J0OlzUqcgL1/4FsbgUBlgLyuCDIiiabOP
	 MA6AKvFqInvwlPa9f5Qm9BYaqoZbAv9+KmFQVKXijUIPSogZzRyM0t+Naz5OdEAPzc
	 95RQbj7Cvh1ZDmFS56O4svbuIqJNmMc5iTIGaJ7el6lfh5XMIsiuSdtZP3CZl9ga0D
	 Vi9DCn1n54U7A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE
Date: Sun,  8 Nov 2026 11:16:14 -0800
Message-ID: <20261108191615.113362-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108191615.113362-1-sj@kernel.org>
References: <20261108191615.113362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: najnbou6ttupp8cfyosdyumz5dtbfr1f
X-Rspamd-Queue-Id: 3520EC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794165385-241173
X-HE-Meta: U2FsdGVkX1+gWYoO7gj/fFXORBTYMMPkSibMZrxQ/NpHsNBC6kvgFXXl2nCKrVT4oN6d6wkhblTk1lLtXzEQzTmfaJla3mf/cYeiVsePxjbOVTDkDopMvXNX1AmMGUpMEPF7/7St0CvjELXLnp1OlCz88C8cd+yrHExWS6WnyGyubjcoq1FIasNFIBUhFsD30prPalLzI/ZF5PUjk62NupJ9QUd1OsGC8F6MD26DXxuHuFQKr2VgW7GX+kZbYkVxiDJBIX7AWZurwWxUnfM2mUHnBXi1MWMtIjRRZeY4oVxME9er21k3LV/MCxi2Oz+EK5bZPLjIrCZMmqRAmbxRifaCJA8gRLw/vlNfUbg/6DvjB60xmBXqeqQtmIj3xyfM4KJA+oAMWI1suJMNnpX3SJIIVs+zt4z3Z4yLC+TsMLu9+yeWtZ2mJjiJxJaJ/Y1ep6ZqHmKGitcaGRMY3VF8cMA82qQZTEWm8+IFMcoQuTkYSioSpYsLFvVegM3vC/kNFuOkS9kHI+omhOMyCYFvSYq9X13w+MMhWytYMLPTRXpIaXrYY1k+Ft4wIg7DNhc5c+vwr0NV1hXws6zTDXMZBkX+5wGDIvMYKY6v6wm4pWoeF8cb3vhkqrQKkazo5xgoHG3LcRg1q0aquY+a8FdMiLgNEFr0mN6sDbIdYmVm9v3WZNWIZHvomW+IdnW3fH/k1OVZ1jNiW4Q/CZc52m6JQqhLpH6L198bnqPJ80J9p+TS1h/elaoPwJyyxgVuTWneijaHPPWj2QjzxhWZFZsqwt30cZNqDOO0aqQBUvC2V7T8ZpSsNUfU+wrHl6jqVuxJuxZWftOEFmifHBmCzgybk3xt7y7N+C50TTS44leURkHjnj+jabgM1ucANr5ZBQBfupChI4+XdrEsUgfm6LNGw0AHj0pdZmtylno3xvPvJKKTVjlcl+xiw2z4gQBQ9MdAXNxN4JsH+ygRmblUm70
 N7BGMoC2
 O85oF3l40XCVdp4FXZd49hiviJNcjJU/I09DAHWgzbujWDB0prQoH+KaF6lU0QIIUbPInCvRu5+oEVsVFqVAKotZKnCsI5QxpaYkBJVCu0qeRxvEFjs9JioiR+kjlH2sxUKCz2fwmqiat9/9J4F6Hd8kjjICV4nAnfp2DBU2Z5+zUrrDY4ZG4ZijOHnz/OKH1JE16N6ymgNlHuKZjOsgeozsISLWbExfESQ+73f7zQEGeHdeETEVljPQYfI0WySylJw5u26MEyQl01HDpDEUA6PG0KlfW9Et/pFgtEyceVzylt8WUcARjxsGT9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added LRU-activeness DAMON
filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 8440c4954090e..b676be6971589 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -302,6 +302,7 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
+- ``active``: Same to that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

