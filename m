Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE48606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UdF1H0gr
Received: by kanga.kvack.org (Postfix)
	id 9D6956B05B2; Tue,  3 Nov 2026 15:21:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9878B6B05B3; Tue,  3 Nov 2026 15:21:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D646B05B4; Tue,  3 Nov 2026 15:21:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA3D6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:21:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBF3A1A02C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:21:43 +0000 (UTC)
X-FDA: 85394928486.12.9B8D2B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2D88100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:21:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UdF1H0gr;
	spf=pass (imf05.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793737302;
	b=quDpYllQuX5kPe2ZBaIIHd8EGcNF+VYm6Z3bdAnfkL/U4QLcWYPf0Y2Q/vAGTBR0mahcy+
	P7p8YHvEXOcbE0n9k/+8FWXtMR83+pyp1C9RfHNwJFVVhIIlKU1LFBueNziyR98RiCqhIH
	/xP0ZfnHn5alKlQBvpxs9FSKTAocvIU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UdF1H0gr;
	spf=pass (imf05.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793737302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CQ9QXYgEq5HlpZ4WHk4AkIIAa+3/a95hTxApO1XSIs=;
	b=db1DzWNhjg4IC4L4ZI3rqwv42M1HUbdQuCo+uVIvjrqnpeo2BqMe2riz8+n5MjwZ3xyijl
	kCERcdmh0G7Z7pw+9KW8oLPGfQgU/ELaAC+p0aROejDq4Z3ImI9qG2zC/xuHHpuJnN49sU
	njRX6M2Ct7/vL+UgT5rXnBnmmjzJ/jo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793737301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4CQ9QXYgEq5HlpZ4WHk4AkIIAa+3/a95hTxApO1XSIs=;
	b=UdF1H0grguCbUaOWk91SlvQmsiVNGuFyuQ005lZKLUcKOXPlT1EIJ/paYmGPO5yrAObBco
	Q7NuAj+Wop+orTGN1HmEVR1L8jgNbPa83PJrnt6HgWkqYzIlRmdLWZg90sydFAGSjuaCU/
	vL7jdBurvywDMDDZtEeUmXlqnupTlS8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-y3M3VMR7O3mDnncLOjtuSA-1; Tue,
 03 Nov 2026 15:21:38 -0500
X-MC-Unique: y3M3VMR7O3mDnncLOjtuSA-1
X-Mimecast-MFC-AGG-ID: y3M3VMR7O3mDnncLOjtuSA_1793737296
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8547E18002F8;
	Tue,  3 Nov 2026 20:21:35 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6FE4A18004D2;
	Tue,  3 Nov 2026 20:21:32 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: zenghui.yu@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	audra@redhat.com
Subject: [PATCH] selftests/mm: scale uffd memory region contingent upon base page size
Date: Tue,  3 Nov 2026 13:20:49 -0700
Message-ID: <20261103202049.499206-1-jocolema@redhat.com>
In-Reply-To: <20261011163527.95988-1-zenghui.yu@linux.dev>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ERJZufKI1YhykxPrmJs967rUSY-pN28r-0pR42JCVKg_1793737296
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2D88100005
X-Stat-Signature: a6b5g8stwqoqsu3zqtgtsegkuehzbe6j
X-Rspam-User: 
X-HE-Tag: 1793737301-644563
X-HE-Meta: U2FsdGVkX18ETlbcuhf35x3CamKzgWdEYpJxOKQMyH7Cy+39VJ76rB4X9wsKTOu2Ban/hjdksGmo7vM7TceNjhTsx+mgcQph3XiNoFwjoSqHyfNqB1n6iXHSVHYqxql/DIoPKctRAYTOIrr7drcVx7KhzQBJOrj8QjfHxgy5JBSd3O2NkpnRCiVRejhYqRo7ENNNnMxiuiPjuNpwSVnciU8T0oHucuPAe6fLy1qiv7V3gdhnCpkpqh1gTJ3burxHfId13fdEMill3vU8k0AXT9UjRWozA8sLqGAy7VEiuxv5i2fPCzRorDjZraOMlQQ6if9/STB6MDLpoXRxKTjdvV1vj/SwOYXFR5yeBVJlsREo76hz6Ooj4XJWEpDo6pyxQmBjTvqo4t4SF0r6BzjSHH+VX3mW6mdRydIqfI14FivdjH2T1seTTsUcAWlcv8hoTIrQUUGHN6SAcRUqfmGk1JZiWECWOAJF11oR0U3O99Qp/j8XwKVns/waDhpOn5UMfrtB49izoA26Clfu1cxrtCnDsTpdSDGR0PeAfd/4RkUWHKOjHb/An5SmvrLboZhP/EjKnNNfjMSJ9KT+Uxh2M6Ka0wVR4wO2X7vQsegZoeFB/KKX7r3w1qRXh7R/EeXH3vKI4NX/a26MrKC/l+i0tPsd4voFqhTD+B6CJ2jx+OQz2d85K2JUHAguQgz8WkgPqL11IXtC51GgJ1a9Lm0ZXtPk9pLqnHnGVC8N/zQWCHRzPekJM8m3SKliS+QhiKUBt8AFYGD6PsSOaUABMM0Nu5vhWN4aeICQRaQAzeoO2GVY1FfztYM/tC2dnHra1Vxi005lNtrEAb7VGdt0vwR+7tts0oapkMvrPJhcelzPXittz+EuK4ayXKxHFURIbjDqmU+6lj13FrHeKyk1qVKY8G42rgiE3uuOFrJr56Y0D+kQn5bng/HOZrzaU2r5mxlBMFaL5MWZDtyCFVxNnPc
 ADH2qcrs
 iy9wvrI7AYGBkhwYQRZCpF5ctzSxcE1qyuyuOq9DkiUfaK2qzQ4VFDdYKE5xb6OzYlKo30BBMk20DAN/4F3igdck6paLvcarZUnclKicJiqVIyEuES+VE06hRtGgtVHfBeR1Obc4pPC3rf1knCIJ9Sji7EqxXDbbMotJk1/0Ma8/AKk9KcYcePudbDc3SGFqxnGVlab5iA9CwVn3TD6a/kWZNKmwiJ44XoiyLSuPm/eT5xncpmD+Fgc3ixsuZmQx8fMlX/1sBg4EZonB0TVcn0qJ3d3pO11AvG/TPsGV/hBLmMct8DJe0F9NoXwXHn1CiwX8lWlY9hd6UrYReuIvodM2mOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When executing the uffd-unit-test, the "move-pmd on anon" test will fail on
aarch64+64k with a segmentation fault because the initial allocated memory
region is too small.  This only happens with the move-pmd* tests because the
architecture base page size is still utilized even though the memory region is
specific to the size indicated by the pmd.

Patch 9f5c2aec3388 ("selftests/mm: fix uffd move-pmd test crash on 64K base page
systems") implements an initial fix to the segmentation fault by skipping the
test if the allocated memory region is not large enough for the number of pages
x page size requested.  But as this will skip over the aarch64+64k pmd tests, this
patch is intended to resolve the problem with 64k pages by scaling up the
initial allocated memory region subject to base page size of the architecture.

Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")

Signed-off-by: John J. Coleman <jocolema@redhat.com>
---

I too have been looking into a solution for aarch64+64k.  I wanted to gauge your 
thoughts on this patch to scale up memory allocation region size predicated on 
architecture base page sizes.

 tools/testing/selftests/mm/uffd-unit-tests.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb1b35d6281449fd1917793a64fab1..c6cebb3c880d0b47e44c8afc4e3a4c3050cea579 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -13,8 +13,14 @@
 
 #ifdef __NR_userfaultfd
 
-/* The unit test doesn't need a large or random size, make it 32MB for now */
-#define  UFFD_TEST_MEM_SIZE               (32UL << 20)
+/*
+ * The unit test does not need a large or random size, but the allocation size
+ * needs to scale with base page size per architecture otherwise pmd alignment
+ * tests will fail for architectures like aarch64+64k.  For standard 4k pages, 
+ * this will allocate 64MiB, while allocating 1GiB for 64k page sizes.
+ */
+#define  PAGE_SIZE                        sysconf(_SC_PAGESIZE)
+#define  UFFD_TEST_MEM_SIZE               (PAGE_SIZE * (16 << 10))
 
 #define  MEM_ANON                         BIT_ULL(0)
 #define  MEM_SHMEM                        BIT_ULL(1)
-- 
2.56.0


