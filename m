Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFEE606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iHiygrY4
Received: by kanga.kvack.org (Postfix)
	id 5714B6B0B5B; Wed, 25 Nov 2026 21:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548B76B0B5D; Wed, 25 Nov 2026 21:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460146B0B5E; Wed, 25 Nov 2026 21:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2B46B0B5B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:09:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A416F1C46B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:09:20 +0000 (UTC)
X-FDA: 85475638080.07.64D9A68
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf15.hostedemail.com (Postfix) with ESMTP id 970B8A0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:09:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHiygrY4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658959;
	b=WED4i10Ei9APZJNHT62CghAOz6DYAs4WftcgG0TUjOblkaf77GUBk6T+xpLJ9ipGRFTlD5
	ho/rpiDl/M0nd18CWtmp9/v7Sdh4fe4/zsJ0V2q0u7kGFxCboAnaVeakzstK62BumcHls2
	AsSegypRaoztZClGBQLZX5mnbty1HnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcruErW631cRyNVYcZhaTd+ooyBSWxhrtfIr60h9UBg=;
	b=kLKfnQx55kTsttqAjOsoE5EFhga08FnsVNigXydVEPXRwVSCGJ0JW0QuFN+Sc0FR/Y3UJN
	sbLvMVGlKRIiyx226KNZMznwVLFOxY4LshtN11/G7rO/TOp32/9mOgESwqfEpjGCID7mHh
	N8BWwaX2sbZOsdyl8H8w8reg0YtytCg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHiygrY4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CcruErW631cRyNVYcZhaTd+ooyBSWxhrtfIr60h9UBg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658957; v=1; x=1796263757;
 b=iHiygrY4YdMMVg2PiVGi7WPUsuMeCiRWM6CpkTSUqvsjiB8j+BahxwGM+iwWHTN8s2d4ECK+
 rD2PKTT8rm58DkMPRcCSgEq+SLUBU5EijXFnr1RTqgFh4CWIK7gmgjY5Ho7W6XPV0ubECqn0KyG
 WbO2danQxz4doYswc8WhOKrQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e1cc9e9085ce54e2;
	Thu, 26 Nov 2026 02:09:16 +0000
X-Mizu-Trace-ID: e1cc9e9085ce54e2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 10/21] mm/hugetlb: only check PMD table sharing for
 PMD-sized folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-10-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:08:45 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7348490D-C5B9-4471-AFE9-CDE68FDBAFF1@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-10-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 970B8A0004
X-Stat-Signature: hzeiau4uaj69zj7rzzweo989ytashf1t
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795658958-587183
X-HE-Meta: U2FsdGVkX1/aaQrcTH/za0hqA9ng1r+Bdj6pK12eKdE491mNVjguLD0VTt/3iwo9QF+S8vOYqLxs+mAmRt0NLvPgfv/YhvT8K2pQGhOr6BbS7kTiCeUXzrn/uOfpYlPiZa9cvvO0Xiu3I3HNCDEDUZ/ar3Y8IprGEq0L/c8gd+nEH/6mhz3OzYEo2JRnJ0FyPxCEjkONbbc8cW6nykMpah62HAP51qy5Nay/wXIjc0YRF3X4bswB5jDtvwLnUEFcttiNXXjRyHaIsBrAVFnPyeisf9l9BhUREY28mfwiKbyr9U0g0O77HF+evb25zG415m+3b5G4p3XL8aHAztgKtCVTvcGO4/GeXew67ci4zTaLlxoUyfK9Vp8RsO7Zxtu6+qmbU3MQsKeb4absyK33PFSiDSWFqQ8qGl3yULvtCrPnJuYNwQ8Wg2T/BeMZwu3tylQSgLKjfzVNpdgFtZuieGanTs3+jmIbQOe45R4Mb9C09gaOtF4AYJnCknxBw0OOehj3J2eWnyfuFySxBTbKyecKCWuAjtd3oO3eQJnuCqvVu3pOj+nxthJSAZU2n6oIoOX4e7zbG9hmbd91ZFaA9rQRhn6NTPridmCfON0MD7o6TZINBD4aTcC6aQgLXc3LLh3ovgExSjR7bxh/wo9eMiXkqSY+qhuLK+cFQlk4yXf3fo9Mi5MznMXnbJ7yOylJwlnROIpWmv/Aiji44bXUR3tinKOGX0Gcneote0NzzfiruCSKYJkJBqOrdjbTG9EqR9CazBLgo2RHXh21HJJJmwlaeh9vQc8+Am+dqwaIzjOoh2A6XxffAjhMShb+GJxpZBsWomt4BlI1KQ8EPLA+Voa9VPj1EbXB+4BHDC2J4QToHdi0cbDPdddSoSGOu9Pw402QKMPa1YlJJ7UQ06xWH2LEDUIjG0OsNAVswMKggw5BkfiFXXTF+AYKYT9CgL5AaGTBinO9U5xiFQ9C1U2
 IadWq82s
 hmkQI5QpkV1rhhbD45bdAq1O5q5fiEUXZ5UUiKP7thrJSNhr/6ae0h565ZCmpe716Pa8iqcGWxOZLKeyH3njbbk8f3NaXAvgis4h2KD8zzghPgBYElebga7LkGobZjxcqpbxO3/mxbWys56B1B+vnEt4yKbV1TcxPpyZUIaQPJd63sx4/vPpJuA1pWZM3kmJdHLrH5H+Keym2YafR22t1tlpEYnYjqZu9rlEpWVF8ph1vbCT+PF57CylRNx6aX4fAmjUbDpTklLly3zDXl04QrNap41y423oFUWRzS9Uav20PV9yvXS7hPiUGSbWsUBlcVzhqLLYIV2eLq59YXE1eXWUGWS4LDPkN5EO4J61LrzKpnVkh182BcXywWZDNrNvyvd412O2b+U3RCQtpGABZnupsTulvQjXBc8mhjqog+/AsA+LUug1Bhng2N8PtKN1FB2ar4kwhtvzaDna2S97Ue3253TzclBvLrCRUI03g5Iu0RwDDviwxGLemEFbeE5LT0ES4k4kx5GjmtM7C6YeLQLpLeNRSz4OPW2seJnlxoHszN32ponknebGtAclZMSb2fttUAWZ5ifkjizwLvHcsWVelSB5ZKv4cTE6PrOGi+U6COY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> hugetlb_pmd_shared() reads "pt_share_count" from the ptdesc of the =
page
> table that maps a hugetlb folio, independent of the folio size, to =
tell
> whether that page table is shared. Only PMD tables have a valid
> "pt_share_count"; for other folio sizes, such as 1 GiB folios on x86
> that are mapped by a PUD table, we read whatever another user of the
> union left behind.
>=20
> As a result, such folios might be reported as shared in smaps and as =
not
> exclusively mapped in pagemap, and mbind(MPOL_MF_MOVE) and
> migrate_pages() might skip them.
>=20
> Let's fix it by adding hugetlb_folio_maybe_mapped_shared(), which
> combines folio_maybe_mapped_shared(), documented to not care about =
page
> table sharing, with a check for PMD table sharing only for PMD-sized
> folios, and using it in the affected callers.
>=20
> This has low urgency.
>=20
> Fixes: ca1a47cd3f5f ("mm/hugetlb: fix hugetlb_pmd_shared()")
> Cc: <stable@vger.kernel.org>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



