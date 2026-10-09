Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3825DCA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CD66B0092; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E326B0093; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2000D6B0095; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDB326B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 035BD14045A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:17 +0000 (UTC)
X-FDA: 85303479156.15.AA5DCEF
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4830C000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=uaYh3Jj+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=MTHoNhnL;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791559936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eNkAHrZeuCrzAtS02DcDIkhItOapaZSzqCl0GxmQ6J4=;
	b=PMHHx4X1XyVF+WYOfba6GNMTBPmoRbtSkZSz1ndD7LVnwyUIaHMwIhZIzyA7S/KBEMMDPN
	ehB3lyuqSK9h/G3wsufNaSpB/1/508WxuiquGzTY4wNtw8kRVJ2V79pNfTqc8Gt/ZCv6sL
	0i5svZ8gahLYoxw4ZJV7PQ9mlTcwMaY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=uaYh3Jj+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=MTHoNhnL;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791559936;
	b=2Dp8K1nAoPTdFi100FxD/fCgYO+n1fzBZUFeVWASMtqiNAEOhAwCtUapfkedfH2cKNTfKZ
	RASPxeinnHDcyNO2q9CTko11kGrd6/tc5nsocoh7sI9rJcNx/yrfEDzDJ4/ek6AYhcK0DQ
	fIR6K+smSVmH7jUefrgqhmSKkd+EeVQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 4132FEC09EB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 09 Oct 2026 11:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1791559935; x=1791646335; bh=eNkAHrZeuC
	rzAtS02DcDIkhItOapaZSzqCl0GxmQ6J4=; b=uaYh3Jj+1H/rESeiWW1g2HnnwB
	a78moyoAs//QmyVF7U2GFE6Ty0kYZP8/WBPEjBZP7He5+dvpGFiuN3sdzKFp9Kpu
	eOQeR8kvvRSRp+BbUlBoeOf8qbOOz96kbjvAK9w8jPGQ+Or75k8UmJIZGkjOPuUb
	BuvGW6AkufavVCcUXIvAJDX58sCOMNM0DtBX6qHK+ASK+6I75zAEsbEbgHH9QRIw
	TcEcCfJQEiz8OaKkRaK4z0NTOCzTtDKyrH+Cn0Est4FqVbvxVqvwCeLtwA1qOYAQ
	FoEtCCIEU/knZtHa56yVruP3gI1eLyP62oOeUrjrxKlNrbNa5agxJRlGqKfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791559935; x=1791646335; bh=eNkAHrZeuCrzAtS02DcDIkhItOapaZSzqCl
	0GxmQ6J4=; b=MTHoNhnLRwi6L76aQvrXl9e34Zpf4FZTIe/4Z51Y+vMT/peNwts
	HCK3YhcilOPbj2XHcKOztw5Qip0JoHa4WUl+diaCKLLZn3CNCilXJxFSXQ+AE7yn
	rqYE1kSDBbqrWEahh/L2Dkn5InObtvj+mbTD9O3kTwj7BK8DPb+Dl2RJR9pEN6G2
	p2uFWuBARjnAHyqXD4/CuATYsBppiqgfysuZN9ZyMAkJwq119ByXzi9C85zNI7eb
	gbUKEC5EWkSfeqDfsKU6mnnC9NB9iquHw71Xr6kPqSlwdt3mu9UTQ4hoTrtxIWKu
	4qqPSQwfGg/GxQ6eo+sxaUbaCuyQZdhbEwg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791559935; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:rtiK+lBxHc4sCjlhaxe/oUUZaY0xblRRR/62tbqdE19Cplc
	BUzwgo5py3i6tHoXuCxbNYhvjidahJ7dYsvZ/rDFw0N63SosEgcxurg/u87fXe8f
	LBYsVD5sXjiOFk0r34IJNZ6REGeziSm2i7pAod8HK642YQwTvhMqGZSbA8Z6pK+M
	iVUI6Qd28x/f6GZUhUQiVkMQF43g8cWJfPZSMcmpha/ze2pFnvu6TxKAm7Z6463j
	t/2HXNXq6uwun3sXwWuX0UXwrBH5R34rcaKqwatbiByqpojuySkWEcGAhWLIxnFX
	W/2Pu8oRZumCLvbA9z93WAhMVVDGWrxOxHW1NUg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:3hpCA8iQi0r3kgj2aOfNu2B6wplYVejEYLENCZAaw8M=:iMZ/uX+ag5jz3/Kyi5t22CgDOcI9bb/p6hm7+/PLmns=;
X-ME-Sender: <xms:_gjJapTr9Ar-ep6OuTri01E5Xfh2aFOKO4Q0ZCLQiD9kpZK4bMYL8w>
    <xme:_gjJakZNKFAuVPltOzDrmjJQzpl-5ZpUd9Hf_XeTRhvy6Jlky9jYBuDQEy5WZzYAd
    OHZs7_YYrXI1TVRBEs3x0k_1GW3ucL-FyBgd4WaQM2WdQYWxF6V1I0>
X-ME-Received: <xmr:_gjJai6w363qHX6zj48lr3uzlYTpVXLPSlUOvbf-GyqyAquXzCupRFpExSU>
X-ME-Proxy-Cause: dmFkZTEojCcQdCbQEnvG4GzFM0Gtq7SC6ZQGly27ZWNX9GO6WKU3jEBqxz5bk4ea1AP4V9
    TPIVGx/CiMf6Y3h10lSARpqgrsgYLVoWyL+3qaFGEN8UIxZ5UNN0Zcn/AwPUJGGNYkOwsQ
    /bXGq2esfoF2gPIa6ugHY37ND38FhjECueWLOExQaT66s1t5oGhQAo9RBdO1zLZ6svlUdv
    ZEEo/XaVdASxtbSclv98wGLIBUYpN5cbotRrAYvLY2fR7lKVfWMYBWP//sfN6G3mMS29Oc
    psTb54J5ZmXaENSaUsW9rb/rD1rDiProhVZFk4BmRjH5QFTp+YdwmKGW1Y6hQQ46k8CGr6
    cjYKoIhZ1L9XHkTQOdDoIZx1aEcx5n3Z8QmNZ08lG7MtWO0m9Lzz7vEnjTwd/ZaAikTg+h
    jyk4MDT0NCbjkZThKc9vonsuD5uIIkbQPLtiFrQzFxG+SKg9L/gvfV9xPo8iGq5DUWteIo
    k+9w5mtlvgXg8Z5Xt3goOQ47tzb3+HEwIDc/xONBE1pW/XfCF0V2wv2k45X89aoPIZg5+5
    qXx+vG+9qJkAFulsFHZD4bM5EGr83QuJGlTuudoRf0B4i82WMHEjfYzZz59GFsl8j8qSwI
    OIS+f7KqgRAgBcsV+0UO/TwIvgfGr/s07roOLKiVU1/5gI8jZf/EAbyTCxPA
X-ME-Proxy: <xmx:_gjJanf-ABUDb2WppoU4T1XMTLDMMKpnTBHDQtyW5kzSrabv4qwcwQ>
    <xmx:_gjJahffuWsilLrBqDkdE6Aod4d_XlzV1nMiV2fKFLac7uhThBJhQw>
    <xmx:_gjJakGaF3r6AkTzh9n0dI0768OpXteKmxP5w1g3XT8pw6-IBA2WEA>
    <xmx:_gjJaoEkuxpxdJSG4XS_OjHi0vNULJEmBW6uKttlE9ZiM8_EVuBLPA>
    <xmx:_wjJapD7GbOvm4B-L2klnmY89l2i-Xf0p1TAvAX9o7JmG7x2I3EqguJD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 11:32:13 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/4] selftests/mm: check large folio results through check_huge() only
Date: Fri,  9 Oct 2026 16:32:04 +0100
Message-ID: <20261009153210.236517-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4830C000E
X-Rspam-User: 
X-Stat-Signature: z4s4xzugpsttz7rhnopzdqs33skrksfc
X-HE-Tag: 1791559935-856830
X-HE-Meta: U2FsdGVkX18ig29FCu8WY5QgIKghFnq9Jmq+YSgzX7iBqddExLuZ37AExIeHgS6kcRN2uBtGFgyIeGq8EqP9/4OeEDCB26xVAS2rNczLrSf2zP9Ol+G6d6MJd7RSdgP0x63IKSSXjvb7gt9ik0lNUT24c/koPt+JYAtxqO/lS2uLpPnH+uGILWO86NbpEcN6pJhrkHwOI0qEbLj/Gi2OJrwXsR3mkcvdDWuEl5Llhv5xQz3qW/HD8SbJcK05kNGNztVDmBwfz0p5XyYMmNAZKE6JOF4FbyGj8+LqoqUEPBWB/htos7OTViXRD0Y5MNBnhxYwdZf8byYahoOJOaVhDPKnnFXrIOmHdBS/nk9B7OAXgORlPkZSuPTnWaxfO5GqzQjC3bVGRy0Zz0blh8Gd21fdjDsCpJmlSHhY3OE3BkdLgWffH9w1Bdxv+/W8FtTQnO7wfKGO7kSEEfhWAc/d6Hg/PCvvO8Nc26pNDlXrdUe33EhZp0UgepRk+KYRd7KbRoMo4P03Wcyq/SNsnRxQN0w6FyvzUtUB9Rxq0LQUVrCiaW1kuv2/Xr1kmm3VWLDMMblus4iEdGU2CPD/LWOQM8duNy0zS9d/4bdTYoeUkZdaOEEJdkeG6OIY/OEEQ9YPJN5jb0U74yAUJjnPTjuJas1VGnW79FuHUpidX/sotdEE7hii72Tu00fnrXIISW+lwsFB2CMenBTnxgWTjWiGaF12QRM/SCYOfQweSjCqGXCF4NZnVw8v0DL/zPVb/ZPqDJgsa1Bk92f3xyjcHs4cYWqxnhO62xiPJpDHRknSRwQnCXjngGXogirvDNXmno9f8v8Lsk0p+6+I3EpchzApeYZ8k12T3JJkbz62x1Tn/r23dvKrIDoJPfGA8D8nePSbIpsOpgCWG20gI5m4gbnAwSXC8SvBqzhTEPc/geGb+1yyEwJu939ky3uIIZSAC+RfKVwtoLux0HNguMhVMIb
 OW+P/nBz
 e1PSUTtVHPMfoDAzwc4Kik4voaN2x1kSLPQIfaBzLRClHeVCt6HCMB0yQFR8vU2gA9ypWjo1SYhY9DMDygD/G+2V7Nv9UCAhn2reIdgSZHXbKrc2xJOHNNf3i8u/TUzeGpIeWYmM/g9PO2JN6CqIS8jo/viD2LVRJFfdQDd5VxolHhPStsWLXfq4xPwzu+3MQL/mXJYChy/niJ9PQKSnv1wNdqvtJHSh2eEKAU1nUD7tAhRFx880HvlolUW4DqN4ce79+XvZqzq1oe17yStRaRGWCCukvXNWwwImXg+MZTt1FjO3mYa5D4zCIbeK6LRewwsndkuLObdEt+CCG/qERaSNRERo54XhjzILSgzt+ez730DG36P40NxZH3tuZl3KoAk/bAk2pNTcVPOMDYDKkXLwrz7j0XdO3PIiyphO5kfb4BJEIWuFYMqsWcc7ykqfM4Py8B8vPa4f1vdqFZhrp70FaVZ1InRXOtR6qTh3CCMv/9Yvex2gHD52b4PLVPZ/DOTJbOc31S5m6e6QnWN4dJLt7hoM7/YZJ0KP7ttl78qA4ghmfzX0OWCOsLoyESJxkASjjW/VsoMsI8rfJWkQJG+VgCmP+p3RnEvVH6afYVbwjNvX4vcisAlCnzUR0riN2OKLSOu3E86GMUOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mm selftests had two ways to check that a range came out as folios
of a given order.  check_huge_anon() and check_huge_file() counted
folios of the order in the range.  is_range_backed_by_order() checked
each window for a folio with its head at the window start.  Baolin found
the two sets in khugepaged.c confusing [1], and the answer at the time
was to merge them once Yeoreum's rewrite of check_huge_*() on top of
pagemap and kpageflags landed.  It is in mm-new now.

Make check_huge() check windows below the PMD size, route every caller
through it, and make is_range_backed_by_order() an internal of vm_util.c.
The split test's count-based check goes the same way, which also makes
it notice a split at the wrong offset.  On the way check_huge() stops
reopening pagemap and kpageflags on every call, which was the other
reason the separate helper existed.

Yeoreum's HPAGE_SIZE series [2] renames read_pmd_pagesize() to
pmd_psize(); the only overlap is the one call in __check_huge().

Tested on mm-new 2589c5593c20 with KASAN, in 16G guests, x86-64/4K under
KVM and arm64/64K under TCG: the khugepaged matrix at every order,
split_huge_page_test, pagemap_ioctl and khugepaged all:all on tmpfs pass
with the same counts as before.

v2:
 - Drop the PMD size caching from patch 1; Yeoreum's series caches it in
   pmd_psize() (Zi)
 - folio_order_check: skip again when /proc/kpageflags is not readable
   (Sashiko)
 - kpageflags_fd_get(): return early instead of nesting the open

v1: https://lore.kernel.org/all/20260929131521.153079-1-kirill@shutemov.name/

[1] https://lore.kernel.org/all/65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com/
[2] https://lore.kernel.org/all/20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com/

Kiryl Shutsemau (Meta) (4):
  selftests/mm: open pagemap and kpageflags once for check_huge()
  selftests/mm: check sub-PMD ranges window by window in check_huge()
  selftests/mm: check collapse results through check_huge() only
  selftests/mm: check split results by position, drop
    gather_folio_orders()

 .../testing/selftests/mm/folio_order_check.c  |  29 +-
 tools/testing/selftests/mm/khugepaged.c       |  47 ++-
 .../selftests/mm/khugepaged_sync_check.c      |   7 +-
 .../selftests/mm/split_huge_page_test.c       | 104 +++---
 tools/testing/selftests/mm/vm_util.c          | 314 ++++++------------
 tools/testing/selftests/mm/vm_util.h          |   7 +-
 6 files changed, 173 insertions(+), 335 deletions(-)

Range-diff against v1:
1:  887d475288bf ! 1:  058de2172bde selftests/mm: open pagemap and kpageflags once for check_huge()
    @@ Commit message
         selftests/mm: open pagemap and kpageflags once for check_huge()
     
         check_huge_anon() and check_huge_file() open /proc/self/pagemap and
    -    /proc/kpageflags on every call and read the PMD size from sysfs on top.
    -    The khugepaged test calls them hundreds of times.
    +    /proc/kpageflags on every call.  The khugepaged test calls them hundreds
    +    of times.
     
         Open both once and keep the descriptors.  A pagemap descriptor is tied
         to the mm of the process that opened it, and the khugepaged fork() cases
         call check_huge() from the child, so reopen it when getpid() changes.
     
    -    Cache the PMD size in read_pmd_pagesize() as well.
    -
         Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
    @@ tools/testing/selftests/mm/vm_util.c
     +{
     +	static int fd = -1;
     +
    -+	if (fd < 0) {
    -+		fd = open(KPAGEFLAGS_PATH, O_RDONLY);
    -+		if (fd < 0)
    -+			ksft_exit_fail_msg("open kpageflags fail\n");
    -+	}
    ++	if (fd >= 0)
    ++		return fd;
    ++
    ++	fd = open(KPAGEFLAGS_PATH, O_RDONLY);
    ++	if (fd < 0)
    ++		ksft_exit_fail_msg("open kpageflags fail\n");
     +
     +	return fd;
     +}
    @@ tools/testing/selftests/mm/vm_util.c
      uint64_t pagemap_get_entry(int fd, char *start)
      {
      	const unsigned long pfn = (unsigned long)start / getpagesize();
    -@@ tools/testing/selftests/mm/vm_util.c: bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
    - 
    - uint64_t read_pmd_pagesize(void)
    - {
    -+	static uint64_t pmd_pagesize;
    - 	int fd;
    - 	char buf[20];
    - 	ssize_t num_read;
    - 
    -+	if (pmd_pagesize)
    -+		return pmd_pagesize;
    -+
    - 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
    - 	if (fd == -1)
    - 		return 0;
    -@@ tools/testing/selftests/mm/vm_util.c: uint64_t read_pmd_pagesize(void)
    - 	buf[num_read] = '\0';
    - 	close(fd);
    - 
    --	return strtoul(buf, NULL, 10);
    -+	pmd_pagesize = strtoul(buf, NULL, 10);
    -+	return pmd_pagesize;
    - }
    - 
    - unsigned long rss_anon(void)
     @@ tools/testing/selftests/mm/vm_util.c: static bool check_huge_type(uint64_t categories, enum check_huge_type type)
      static bool __check_huge(void *addr, size_t len, int nr_hpages,
      		uint64_t hpage_size, enum check_huge_type type)
2:  e89550a21307 = 2:  a95eb5e9e2c8 selftests/mm: check sub-PMD ranges window by window in check_huge()
3:  3988e8ff5c3b ! 3:  40aa2e377b65 selftests/mm: check collapse results through check_huge() only
    @@ tools/testing/selftests/mm/folio_order_check.c: int main(void)
     -	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
     -	if (kpageflags_fd < 0)
     -		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
    --
    ++	if (access("/proc/kpageflags", R_OK))
    ++		ksft_exit_skip("/proc/kpageflags requires root\n");
    + 
      	orders = thp_supported_orders();
      	if (!orders)
    - 		ksft_exit_skip("No supported THP orders\n");
     
      ## tools/testing/selftests/mm/khugepaged.c ##
     @@ tools/testing/selftests/mm/khugepaged.c: static int collapse_order;
4:  898256c09252 = 4:  405414814409 selftests/mm: check split results by position, drop gather_folio_orders()

base-commit: 2589c5593c200e5146db848730baa1d7dd0c9f4e
-- 
2.54.0


