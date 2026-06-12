Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F378CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960BD6B0096; Fri, 12 Jun 2026 14:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911336B0098; Fri, 12 Jun 2026 14:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800066B0099; Fri, 12 Jun 2026 14:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 704E46B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3347401FF
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:56 +0000 (UTC)
X-FDA: 84872049192.18.BA273F2
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3206C1A0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cR3qo/2j";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
	b=VMXAxFkcDhUCJLjG6iwipq2VVPZ0bfB3DtxRaXn7ae5TlneyUNPIF7kBTv+vFEN2Cku0Mc
	JteZh59xAwGQAi1IwMqAMUhnLB/XGBg3S0jVvX0QJeZ2rDNHOFtGQXAGI5hAzeQ3CXFkbE
	aImrLGy8WZWF14HWazYfCMAH3ELDyKQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cR3qo/2j";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287795;
	b=hllAaRdwuVjdHa0+NU5ejuUE0NReQ1JSL3OhC35DwsTE298044W22lGVweTVs1DYnyJoMw
	0ruwPq3PcyNbA1pD+Rswg4T09CtaXdQhBg+TJ4pD8608j4Uc9XdY/X7jOGXGh5RDvkSKpm
	HqLvVFAu1lKd+qf4HqikPvBPgC/bjbQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf1cda2b17so10489405ad.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781287794; x=1781892594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=cR3qo/2jUWRJYR45ocqf/ZIBYPZrNxJ7AKqzEqo9tp/8P9oK3rI8YE5sJwHIxPVMRu
         BU2FqpTuPuRi8AfO026JAJXm1pTVBXIUxJRICC95mppfsVTn1oYmmnZBF/5Z4+HcLoqB
         FNKrQVxNMzU0jJCYGnaO5tmGdlMn7bxoo/ZW7cDilGtOd9H7y+iZX/tnH1rh3FiiWT8q
         ijmG1p98TlPw4GlLL6RmWBY59diYcZJN/9lJBXkJSgkO+0Rp0fWzQE/wF7K+aMVRNqoD
         lkZILCfv7D12l3sX6lWy45ZdNopIk6T3DhTClgaPZa/X+EpRjPhyA6QeueKUBq+8WzEV
         Xjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781287794; x=1781892594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=HYRp7qXYRs6TIZuko2HS/44S5+CB/TxdEywjwuaI7JvBu8QtxHhNzKiWMCSyTYom/o
         14WUSG8jvexqZYQiD74A8P5ENgJKp3rusOa0RfmgRX7N/8GVdRikQ+IXUeIMJYM9rKq+
         danO4LGEY92PUJm+q8ZdN8mORfI4CYnY48ECG141t9crjzGp9BZVj7Xg7RX5Oc01G/SO
         ZtGniUXkgBto15G8u5VBVHY70O/vLlRiyhFyyQjZ9E26lqnt6ksznl7uZAPnu8UQ9PFr
         WEcFdZr2M9rutkZb5MO5/GSbUnx7ccHOrLdkJ9a0VmIbn3hGMRNHtZzCylOsrLWHYb9N
         SMOA==
X-Gm-Message-State: AOJu0YxWayo+CKaLjEqW8Fhzp7SlmJXZU8eJNggTTKBNX8/3TJfR59e2
	wM9UZHZiPxeI3+I6lbAN4mV4cQbqkn/O77synKRoFxSgHnL1NpZQJlLzTTYQbY0k
X-Gm-Gg: Acq92OFvnDLyOI1iw9ZUYF8eO4GTIkgs6ZHeyJoavT3Zutd7SZ4MF7e6EorHCz/Gik2
	pVvSDdBomT++Ldwjoqm/fNKBfE1HbVGVKLeP5u1Uf59s/Xh88HKmGugp943j07zf2G1Wq9fWz7I
	MLctULwGoCGxhRK0aJAnT7pCjLr5VcYWEwgrPQaujTVVRrxNA2WPND3X6ynJ3VSIBLl8Dvyk0ZD
	Z44bZ7Vt9yinnLNn41ZL1yhN6+kgTy8MKbjxObCJcOke9VfUiqPbPtACTW5FlqD0YGIoi23Kg3u
	HHL29wDcFplig8qhOUFkomcVBOWHbo4bCW3ipS4Rerzy8jPqQ3/KyGXagwU/Ehvd3fwQC7BO0G2
	PobjnnfwwMBrl7JAHWJeI5zHKGu0Mi3W16uy1pp/9LJ8auKP2gblrEsUmid6vC1quPHoJVt9xO8
	KA7v3wzqm7A7lo3MHH1JZgJbpILCQGdu7Z
X-Received: by 2002:a17:903:b8f:b0:2c0:c262:b924 with SMTP id d9443c01a7336-2c42e834bd0mr32424725ad.13.1781287794124;
        Fri, 12 Jun 2026 11:09:54 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c70easm38956975ad.25.2026.06.12.11.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:09:53 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v3 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
Date: Fri, 12 Jun 2026 23:39:17 +0530
Message-Id: <4c2b2590251be875cac2acea434a60e1c0f5c343.1781287298.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781287297.git.ritesh.list@gmail.com>
References: <cover.1781287297.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3206C1A0009
X-Rspam-User: 
X-Stat-Signature: 4bknfexhxjqxcyes8w3ghg9ycue8g9nf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781287794-692889
X-HE-Meta: U2FsdGVkX19dWm4NHF9LZrwuhUA5RxMqzmx4kAv+dga+Fhz7b1BJaTHVSbUmBaqLHvN+4Eq5Tp6FZiSjgxzOrkxGm4S1U93c0t8liQTsLX4hrVKCBL0EF3wn31nzbUv2jeb+4Rc0kFU9V2jZdw3rfaRN+EMDShLkYVM+s7xEia224Ms1DUikxJRW0DjkekyIY/2J3EsulcBcGfh/I1XiXVKDvYFV7pK21++Z/Qo3YB9Ple6U9jxdaKwsTnZNeU3EiQdNGp1IYMgQs3wUFdzI3aqp0e1TVfq31W8f8NlWGXjKBkO0BFYi0b0ejBUKdJU9Ipdqz2oxGg622XSv8gZGLIAv4SOOZU03Z5vT25G6tXQPNhEE/6fSqtHIbHcDwaOox5S3XxJGxlhzVuSQdSXHjoSrC1GwS7CS3Tq+TX9+3G8uME6LuZyYi64MVEI40XObdy1yBYGHBj1LUnwfnvsttgdHzOgS2gSpwE8VA24x1twS9IrFu5F/d5ALXh46nzcPJtpuZxZa4ssIgdENYFnYiJyUsp+LsbcwiiB041rLYx099Sea0BOdBlU0TCYOD5YsSyDQZHt2CEZFcNweWmQbqXz6s2UjyjuS1eQqBHdHjhIUj5VkLFGUDf9YD5KcvRSPYhQsXBBVCj/TuHJtmj44vIpg9Zh5MaZxY/5hVutWoy9aRB50Hbb2O+sb8nhvVwm9aHZVnnKT3QD975s9E0z2O7h1g0CDC7RKc9BB14aaOTfW9DaTIlk4PqxmdWCJArJdKuos+WdzxYuUpA5gWnLUFzrK95lYf5GgW9zlTeDoJm6SVuue7xEe3aMWLu5wxYdzSG+y7Lu3rydCTcOTldHyKMO1RKge5Yl3hFSmFeSqbDdlZTKrvi+nj23umfZ4tYyRtQPLgcXrirfMg9t9Ck31XeUni14anV7bYbqxgeBKWf3I8Q8hgzDo703yy6F0V83XxGZc7tr2JlVQuVqvQ9f
 0UbhjR4g
 JaBdtuDVHajTi8RMD/JncKrBtD+UkC8A9t56D6aThI+lVNDMsyaNWQ/ishv9pbTAtBeR5Oi4xC/PY1cVUXJMeEGOaL0Top1q6lcMxOg0Je1A/83AkPPe7p5CetU9NuD/OLOSS2lu+uSIKhCPQ7ikBzyOhg2oFVA/OXFp6uh+GZK1OwF8RlC6K5ky5oYpZB9udnIJc6Zci6oZQt0+0IxoU+yWH+zdpNuxQBXZSJ6et5FEG7/MM8U18q+jgyPgLC8jIADCdhjkMoPxL16R/jjjF/zICzQPN0GuLsajh3+HEC5DWLLHY96R+W1Y4auTopT7xlRw8Yp6MZhfeC57QzXOmg2DIsjQJvYcTQ3b+G29G5zuipPMaZ03JPIMn/OAQIpvPYdcJznVkMRE47npZ5hEe/sTu+6eCoQvXIe8ZE5aeO1l2k79tlG5C1HtUfE3A8tpbmWDXnQoUVclK2jZe9xpnZvVkaJl0b03AbVulvMhkRjUEfB/EQkShki07jrreog80aHhPcbvkmVIUhxDhzW5muUTrbqbwBSX38mi/Ems4WgOr9pxEr8Wc+hDNgvKbxGBFS0ZJtqatlQTPp4FyeMZ/tk8pi5Xza5o6CYKb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
(Hash-64K pagesize / 16M PMD), during swapout. This improves the
swapping performance since all the bookking & I/O submission happens
once per large folio. More details at [1].

PowerPC Book3S64 could not enable this before because PMD_ORDER is
selected at runtime depending upon the chosen MMU. The earlier patches
in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
changes, we can now enable THP SWAP for Book3S64.

This increases bandwidth throughput with zram backend for swapout by
40-50% with Radix and 100-130% with Hash (Tested by Sayali)

[1]: https://lore.kernel.org/all/20170515112522.32457-2-ying.huang@intel.com/

Tested-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/platforms/Kconfig.cputype | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..48f74bd22343 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -113,6 +113,7 @@ config PPC_THP
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
        select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_WANTS_THP_SWAP	if TRANSPARENT_HUGEPAGE

 choice
 	prompt "CPU selection"
--
2.39.5


