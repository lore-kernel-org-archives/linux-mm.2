Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B787606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EwhdD0ta
Received: by kanga.kvack.org (Postfix)
	id 8B31E6B00EF; Wed, 28 Oct 2026 23:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C876B05B1; Wed, 28 Oct 2026 23:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7041D6B05B2; Wed, 28 Oct 2026 23:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49ECD6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:37:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C47F1C02B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:37:29 +0000 (UTC)
X-FDA: 85374253818.16.5B11214
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9150F1C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:37:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwhdD0ta;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TYkcz3oi8Hce4FiXDXGEUsAkrCmcslpFK3fxjBXOUw=;
	b=uz2fybDkzPJGsK2zfs4mwqsJsqcWxI/rXpFlAQAc+//8e48xHMohFPlGh2Im7M/qfKqJCF
	ldXNAKBFOyv8TfCc5fnV1BNG9LH9fUbc0w6VyQt9yqw6veqGcpnlqrcrXD+izNkOcT9wEW
	0GpVddXzKD3CBgW3vH1m/4UZYNGHM90=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245048;
	b=E6641JxDEbmR4M/zWUpIXH4hAk2bhn4prq0Nq8C75xKzkoorZLNZ45IrxmQrwzIOrwXGog
	Jyq7JXyhT8mhtqaJ1oNwBDYaTHgyweP55bCb2/PwDdC9VMYU5XfQpqaFr0zOqy+Rpr3Gep
	tNIDyMNV6meyCPP9ln5feeIMN09SUN0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwhdD0ta;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0TYkcz3oi8Hce4FiXDXGEUsAkrCmcslpFK3fxjBXOUw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793245046; v=1; x=1793849846;
 b=EwhdD0taQspvWOf1jRfVxj3kKfbzBcoW1Zh6PIQfZnIs/iXQRocbPuPpJfyNmtIfGQm3KGHU
 Oh06JsdTIGrNthlWEpv+6QrXR0Zdq/Zd63qqHMkLytRK+ku2AIn63jTXNRRnmPotzFTLiJNDfR3
 LZIOVGY4YGYH1FAzvkJnfq8Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b3dc07f6f034e3dc;
	Thu, 29 Oct 2026 03:37:25 +0000
X-Mizu-Trace-ID: b3dc07f6f034e3dc
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 01/15] hugetlbfs: fix integer overflow in fallocate()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
Date: Thu, 29 Oct 2026 11:37:01 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 luojiajun <luojiajun3@huawei.com>,
 Josef Bacik <josef@toxicpanda.com>,
 stable@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <497E3E4E-B423-46FA-AB00-5D2ABFB833A0@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9150F1C0005
X-Stat-Signature: ic6huw79we8ydo5p3xdbydkjyed6eq91
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793245047-743526
X-HE-Meta: U2FsdGVkX1//i0YmR3rFtoKv9nfuZJRV3fJ1XlV4ljm8Xk35dJuBmwAEOvoDd0JZEpr6oYitoep4HiF4zFM0Vjd+qoSIFu+9VetnGWOH+BrEo5HN90T9ZI6r71c/3RXByTIAwSGk+oZxQezK1LD5WnHhLlGSU3bvs3x+zKW84WWDRAsvxy67vGUZExWmxMjit1VUR14IVPHexBiHa9PV1iUSHu8/bWrN4FKmLPHo/8Iccu5aM+AgbyYDHHsah8OZXLUZ/Ql9aVhCchoLXl/rqef07a0PJoOIjT2BW+puF2d2C09rx/mNk6xh2r+cvwdZaxlv3DIYt11A1aVN2kZS5PQ6pQQsuSJg8nTsUiXhjTd1jb1pQ4hpguWRulg6sJFojLnF/cHNWQL+A+U831B0ylaXHUp+LqQJURtqiKmeNZVDhzd9oxjQlXElR1oDqUlEBfoMyKcWQmZvhYAWU3HvkhKzgDLDOEMaF9zGECArsXGC5Luw/vOlIEPc2VdF+uS20E41QUlqyQbAsLwJSv3g5mE+ThONVEMpabN3ErlK1EiXM8YuM5qchBu6naf6mJEIUXNE/TWIvvweLJHVp90yDmPUFL9mbBsAg2eHiVJkf/vOj7uwLv+/ociR4Kn+h2dz0ysTkUTdXYrsvsO8NUEgualLPOkBoeuwtMoJ9rIAhXMDAqWXygGVcWKIy1nDeuv8NIyylcomlG37f7TnE8JLkgEJPy7ns81f3cswZ3n8fjMzGi741ss3uLGBxsQ45BdITKA7f2RZ/KWMCA+b9f3JIAt77gb7CShcgafOPB5rsZ15UaYKZCs3rzmTWLtlWS6Uit8qfhHyyX0VfPFgA2Bh2DWt9oJqHwuJl20ZfWd7l23tCVleGcwzkFhJcJjTG8py0m0V7YS6RYxGiVJGQPVNU1yGmUmSs0slAJnG74iI0V/XksTueJixoTtCrbKCEj70XN2sBxZsR7InUxJQRQr
 Ej2AiXsr
 BEEmFcrHGcmdbvebWH1sfMepvoOJutyIhc4S+PJwB4np/Ke2mzfBDWR2DR5TgRb7UaoOAQ/+++h1yO30ebpc+qnNpQ7JrCrh/57TTbsALPWte2oEmINZFB9MBNS4bI6KyRgH7GaGElkHcwWx/poudwl9kdaL22sl/pdelskLJPy6tafcch4mhq7CzCvTiZZCPnpKORicft6L50by+jDZ2o4vbGUIV2DHfCNwiVr3ILaFvEBbOZG8HQ+7k9CwTbRuJekhMMEWzApA7xMaTfn3HewnXENvzsOFo3OCnSmjYrDk3GPWDLh8MLL+YGJ+E02WTgKZ5xbk79GakPGWtSDHZiowQm+pQkIaG4tginPgmPF1b/6cwPODqKXqPFIvjA0xXakF5SD10wv3yHTuNGlbJq1kYTt2LjnNZow59jzsaIeztbL9nKWl/cFkQRB8CAkc6oSSR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
> to offset + len. vfs_fallocate()'s existing overflow check only makes
> sure that offset + len does not overflow.
>=20
> Once we overflow for valid endpoints near LLONG_MAX, we can get a
> negative temporary result that is then converted to a very large
> huge page index.
>=20
> A one-byte allocation ending at LLONG_MAX can therefore consume all
> available huge pages. Pages added beyond LLONG_MAX are skipped during
> inode eviction, leaking them and triggering the BUG_ON() in =
clear_inode().
>=20
> To fix it, calculate the end index in a simpler way that cannot
> overflow. This also fixes the signed overflow reported by luojiajun in
> 2019.

Amazing that you remember something from so long ago!

>=20
> Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
> hugetlb special casing in filemap.c"), remove_inode_hugepages() must
> include the final huge page during truncate and eviction.
>=20
> Reported-by: luojiajun <luojiajun3@huawei.com>
> Closes: =
https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@h=
uawei.com/
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
> Cc: stable@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


