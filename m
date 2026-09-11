Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A153C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DB06B0092; Fri, 11 Sep 2026 01:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE826B0093; Fri, 11 Sep 2026 01:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDC56B0095; Fri, 11 Sep 2026 01:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9C656B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:40:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5322A1406E9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:40:49 +0000 (UTC)
X-FDA: 85200382218.04.C82125D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8658CC0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:40:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=M+d4LBud;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789105247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/831fpL1BijVYX4Nh3eoAAyvWhJ/a1UeM3X/5uaTXzM=;
	b=k/u6l4ZC4jPIjtKwzUVEMFBfBvww5XIwPP6dPUI3XQuFEM/dSraJSmZ1FxhUQV07FTjt37
	zeuYL9YtA0/xqWIo1xh9P2aD9a5o569x1Gr6CYWn3ZChsIHrS1JtdZqnhqNunIr5S13sep
	sMhXOaBQuuBb6BQ0Wigj8z72yF4UlIY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=M+d4LBud;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789105247;
	b=Q+jkdB1QFvs0mf4cHoT3PXfybg2mgMeoCXZqBwwRDS289SdZOC75nDoUMJsTb0hKiyuPxp
	RaX77eKO+83F93JO6PYoyhbSzOsffqS4BG2bueNEvU4EoUZs5bGUFe8qjBQQwRPFHBRuBK
	cu0J3Ea3fgP+gd2rTqbDMgbs2c9nEKQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:From:To:Subject:Date; bh=/831fpL1BijVYX4
	Nh3eoAAyvWhJ/a1UeM3X/5uaTXzM=; b=M+d4LBudlflk9/56dGu+07+ITa2RPyJ
	FvCZbZF3sVuU/bfvRs/YRhjoFQK6Q9VOEMu/GfoUm+2+44obcSPgf6XKjAGEfuKo
	4M+Bn7bc2x+ERhzeNYB7u1YYM66K/AiCEamCKbwvEpgOSngWTfxIvctSaIhkDyVR
	u/Vev5IHVqMI=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3f2k_lKNqyckLAA--.5439S2;
	Fri, 11 Sep 2026 13:40:15 +0800 (CST)
Message-ID: <c1ef3ed47d2403fbc23a6032ca54a872.sh_def@163.com>
From: Hui Su <sh_def@163.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Zhi Wang <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gourry <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alex Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Fri, 11 Sep 2026 14:40:15 +0900
In-Reply-To: <c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org>
References: <20260817120758.669807-3-sh_def@163.com>
	<4ead5df7-f000-4087-83e4-13aae036e0b7@kernel.org>
	<apESOAPVzggWmbcJ@gsse-cloud1.jf.intel.com>
	<5ae7a11c-1db4-44cd-bf67-a98cfd5ca08b@kernel.org>
	<20260909112049.3202956-1-sh_def@163.com>
	<c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org>
X-CM-TRANSID:_____wD3f2k_lKNqyckLAA--.5439S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1UGryDurykur4rZw18Krg_yoWfWFXEvr
	yvgw1Dt3yF9ay7ta17Kr4agFZ7ur48A3yFyryDWwnavryrJan7trWvv3Z5JF15urZ5Arya
	gwn0yFyj9w129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUjaii7UUUUU==
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwQC4GGqjlEAQwAAA3s
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8658CC0009
X-Stat-Signature: 7pghimqr8q8da97mmh1zhciwg45stgpn
X-Rspam-User: 
X-HE-Tag: 1789105246-746881
X-HE-Meta: U2FsdGVkX18DCif8p3AuicXT/yRJVYebF94wBd3tzDqLETqRrI5LpAc/lXbF0LcabZo7kuIqUkNmeva05z07obpeuM21qbWCU43PbihTy87yf7mX2Y7L/DAcwujZRBFMlkXw+wp0qqsICHnmGq0rYCInzAJOwX2nlaFbz1brs4EoNd0vPL0lKCx84cfCEL3DMXFSAWCKt/J0oyRg43aBrUbIm1pgIpdA2vFum6GbpZpdjBFCypPIQ3nqjAv7WH+3CJ/kxmR6aZJwcUp/a/HYnz813RPSxijATvh/1ixnppReGGGGRd9fTSD4TL5eke1CSK31BpYK7hA9XKfoBXz9OhxCUMWBgR1fm+W0yFRZtbxsKZJERgskukO8CfjEEqGuR0lWL7ck46iODNrII5U59UP8T/xCE2rfn2c8ZDaUdvOtVWveGQB7tE3yNWpL0e6oB1ilLOnf/t3m/s3iaClXPl77xJQC+XHyK7b2s+iUsqTCnJiB96euv6Iv3RBZotKGkoMZz+OHX/T/P2lyasaDOcpv9vjqawFjJn0HIupVC3qRGrpR6C/5wKzDEMEc0LekW+AWvpdOtl0vHp70cVgtLjryGzWuOCyHehyv2hzSToQcN5us5B0bz414WkP/Iw3ec8Wzj28wvZHHxmZqOOIjDhrilSBYVEOf4e368Hubh15AcX5pv6rXEjv4HNa//ltXabRRtxrztzNJrKzjEtYEQ+yBYadwdwjktPB875bW0JgoqJVZQrez00a8cLV5cGMS3m6fbrb9gw4eZ5CM65IInC7UDmFvpmB+ZGIb6Mc0vl+vHdroHQJyYh030z6Wb8f81lr8mXqmdqFwGTD/0L3Q+V7/eBLkL/KU/GMHvMy0Q+opqdexTQ65I4N6UIh1+QNoR4rAaJ+0DtUkZbG6CoYcNmZWntDoo4V+zDNEnEP4Jzm4imudQiTjtQ8Jmg1yxI2avVAVcDtichmVqy8/BkO
 mILXez8/
 Oa0hHJgccyeq8Ggd4dvtwZsDls1EfZItk+IdR/eXW5rUXeoQtLhrmovNu/NSOiHU0ANVBrSKlaLb6LW+us4bMIg/BU20T9I4TRjjrUN76tUOBP2NUOMsIsBqpTmXpAdge5LpZawwuqAarpEhPvA5OJSD3AMmKc2Qg3QY9zMtXjx43sjeKwrLOTo++yAmBI6v4M5S0PRHQyP5k3cLbCvK54k3f+ngNYAaZW0CXobpy1Q9MTfF8McrJYfOLEsaofI4lBnaqmWwJuvK2fOcvImZdZkkIwe8A0UlPIA/hxqBVeCUzZFYk7Uy6LfMGxDcLS1EJ37UXD/X9Y4qfn2LgQs+IuDUWXJh7E7TB6z6WsbQ5XGiykDGomsl9w5wP60oP8KnXA6AvO5ysYgHzmwkGTWMpejwvIIC3cfV/kXkNHKCaK8LJ+2/8Cgnobdaqxac/sS/+qOWx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:43:03PM +0200, David Hildenbrand (Arm) wrote:
> Yes, and please clean up the code in any case; the duplication should be avoided.

Hi David, Matthew,

I reran the original HMM migrate_anon_huge_zero reproducer on current
mainline.

The private-device case passes, and I could not reproduce the original
KASAN out-of-bounds write. I also instrumented the truncated
compound-folio case, and that condition was not hit. The coherent-device
case was skipped on this setup.

So for the follow-up cleanup, I don't plan to add a Fixes tag or Cc
stable. It only consolidates the duplicated compound-folio handling,
uses memset() for the tail entries, and adds WARN_ON_ONCE() for the
caller invariant discussed here.

The original stable Cc was based on the KASAN OOB I observed on the tree
I tested at the time.

I'll send the cleanup as a separate patch.

Thanks,
Hui


