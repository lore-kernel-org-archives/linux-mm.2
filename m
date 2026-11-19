Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA2260A2612
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHlpvBV8
Received: by kanga.kvack.org (Postfix)
	id 5B2066B0650; Thu, 19 Nov 2026 08:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BDC6B0651; Thu, 19 Nov 2026 08:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4033C6B0652; Thu, 19 Nov 2026 08:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11A556B0650
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:42:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3B0E160AD5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:42:46 +0000 (UTC)
X-FDA: 85451983932.30.5F9280B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB5D4160004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:42:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHlpvBV8;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095764;
	b=4jvlInvRriVQM83KWVZexnyiKETxLcMSISyOQ4587grLm2Qxnu/Veqt7Ji1WQp+DcnSBfr
	bvvJoyYxKO+1llG8nh6ZmYUvuAhg+fzzRNwwNJ6mGVkiolh05GeEsnKdBwdkTUj5nekbCd
	GIflmL4CyViq1L/pajM6jFchuo3kgT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hZLXfSf/17Ef5XJyZLOKhQU5fMpX1env96s9MUXf9kY=;
	b=3QfBvUlePjw0HlFlYORgJOjpmZJfr+6BEhQc40lstAGSUdIB3nV28kKL75ac7FRNyvILCs
	wgkcdb0t/h/apWvM22C50V5GiPwMA/Yi+LV+EfFwXJ2KqF33WueSOgSl02OeDwqaTH2XpH
	QngymOprRCzv7VDzlZdIw6DqIl5RLjA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHlpvBV8;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 011ED436DE;
	Thu, 19 Nov 2026 13:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0E81F000C4;
	Thu, 19 Nov 2026 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795095763;
	bh=hZLXfSf/17Ef5XJyZLOKhQU5fMpX1env96s9MUXf9kY=;
	h=From:To:Cc:Subject:Date;
	b=OHlpvBV8jPictW/e3Gt5Wtx4O33OOi4KIpv7i9J6DX8AgQtj/yahrTEbrpmzjMvcn
	 wmPnuu1fd1VTcfSxnac71Q9zs1DPTHzOBL4gY8ZhEDfadrFYfMn3gUmQli6JRNP59C
	 8ioYs7o6DS5NqgF48y1dq2IQE3P5RaoB1pONZ6AsHKL47Rc3KSxUsXJbMVsHN9mCl+
	 cWd5939Xmj6PCs0kHJWK/Si8jzCEuhcZ8jDzUK729QljugNz0yIFsMvpzXxlCPY8jX
	 JD9veVu+xbvtKGjro1R9DgMSGJhbefXDPcGGrGL7P1PCJdWPLxbxXApu7IU61s6vuG
	 sZqt7RikfwybQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 914F0198003A;
	Thu, 19 Nov 2026 08:42:39 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 19 Nov 2026 08:42:41 -0500
X-ME-Sender: <xms:z_z-aimJl8XCqb5MqUf-Tobp9vhrkPSgE_Vorci58WDqinU2zpClMQ>
    <xme:z_z-ahzzgkrjjVvUyO_wv3ZWJoi30-rT4jQi-cfs4EnSGzwDKyOhgMDm61LO8bKYj
    DdJ34f9ll6e51qh19W5t5GwEns_KCZYhgyY5b3DPCzpgXpZ9U9neyjC>
X-ME-Received: <xmr:z_z-an20otvXVua2svjDqlIDFl_z3T2H4j9UO09g1vOcmgTmzZvS4NnJ-O0>
X-ME-Proxy-Cause: dmFkZTFHmT+KFWUidJgUngFM8yp8kVRG2IFi1T6SjyyYCJuUmIsF6IdJZHernKMGzpOMgc
    N7kcPP/LThQoj1fmneGFg+J+zYjzV1DzWnyuedRueYR+KwZkHR+LyFpGcTO3UxZHbsHZLI
    VeemSW0OzNfHw3hjpvSetYaKqHsRxd0DgRmV5azyzryGDjg3EFKQ6nzyTRfvrGJpuDWk0A
    Q4DoYcz7Alv8vaF0fCd22ynjNg8DvM8ITRH1kkAyG8F8iFh2WQkYXrXeSHv++WNwQHhPco
    DoboXMgRx3iyIxqEIEn8S65o/o6x09rTMI6ipa8RxHIekKwEDY7+h5gHfKkxmXEeivWKB7
    dyMXwzm2z/J9TwCOGP1H9rZx6vcd10RDMfAdWVoqGem2UuvuOpgoXyQh5D43Ev1puVlk6z
    jue8XaJ2qU/DA/o+RpOEh2CLzgoxg1N0gHYYYCoPeju+Mo3Cp25f69TrleeYFJK3MKBo9J
    arGQ/sRpQcLDJUAk2yA2StZNFnjrAk3moF7+W9MIzjdMOgIOgGgWoWu0122CF6WemIYqMQ
    TixAddxU1H5FdYQob6/cdlFW+VH7Uae4k61kJFjWHADpr97i0ItclPVGPE3oQh13psDCl+
    tin5ZYgNfGptXWID9zL+GBw5zYH/S/FGOZV6DyDmINfP0UdFR5VecCdDgggg
X-ME-Proxy: <xmx:z_z-atCEjpCU5Dkkrm-b_7_6_SAaMTKlX7xWCQlvYqrVoyNIF6mejw>
    <xmx:z_z-as--sBmjlT8JyoP707xtXeBePkF59F5HfS-iWlMppSKOk_8mVg>
    <xmx:z_z-aj9wOUnLA4hJEyP5clpx21s9R__P7F3HP3RKjfh_mi5Zv-0ntw>
    <xmx:z_z-ak1ZwP6TBd09Xjf5A3Eaw5pyIzOpG8_N1el1TxRgkSZw5TADcg>
    <xmx:z_z-aj8L793r-tafdJbyAXNuoLMkq0eU5lnOeXZXJ4qnfm2lQby6bR95>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 08:42:38 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Usama Arif <usama.arif@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/memory: don't map hardware-poisoned pages in finish_fault()
Date: Thu, 19 Nov 2026 13:42:31 +0000
Message-ID: <20261119134236.3745231-1-kas@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB5D4160004
X-Rspam-User:
X-Stat-Signature: uakd4qq38qnnkkabcnnb3hcases9fryp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795095764-146539
X-HE-Meta: U2FsdGVkX18p/7L6M80YdEpkBGRkkwvJDC+GlAozQM840IUs6vOv/aEk1J+QCxApKRqTLMQTsBRyj+dHgY82ci5zgtqfnmOsqMdcPUDk9SPO6nt0Q8edIfE0ZCtfU6XSDVgwD6ii80nan/yZ3D9QL2Zp9DdWDUBxi6ixbXgmnP0/YJsbbHoXZg6JaJJ2HNaJecL4wMKjHTcLvfdlF8RCMiVi9fK8if0QGh+IFC4TsZoCqER3iAAj/yCkh4S+abvRZKFEg45byPc63gmPtdRnY86IQl20x0GKFtLjcI8SNRuS0cDaNzvpKLaP+EJHYDFG5eO5+AcohUgzgdmW3LyWDo/W0Uro6UP+2SuvJoQIWkf4VqREYS6JN83Z3S2YDedD15u8mtXIOibZiELSRUPugzknd+u/AJwQsxQNCuY8mETQriZ9X+AG18kRApnD2OwLhgK+A9gw+KQTiGNs2la6ddE9eTxzkTcLS6A62XPnLFQ+InOlYfkF4zvWob/EEoe9pHovagSuWjbv0aGNWuepv7Bd8upFiBAY8JnETptzqMLcZ1lQAyLFCxnhFIK1RLWQD+h7vdx5m19lF4v8ND0y7bwRYlXx4gZoVrXNZr8wLmgb+k+bsy0TN79lgux2pMMr85wcefrlfdmyN9K4NxPhMgdq6glxpGmQVHd39NGS6xTWg0zHtCIzbWWhPuOr5KZUEW8GLGttpfJVtino8yDMW5ziQ3G1eIEIo/KWfX3JW7/Q4uvWmG3YyhsW8ZNUp2SpzvI8KnwoBbn9+mQhTF9x4pN8QNs0R0UdfUtyhAiHQBkxxshltzOcaPM7I504DJmnQh3TyJxFo7W66qZpaRFeFeNDkujS7VA7SJ6sqlWvEKChGDgdli3eNsiqM+fenh7v+BK5lwa8omqOYq7/X5GbmLHb9wTDQNQdE+fnYVRkLJWnCwoXVGtSaGBAmwHXdw1cfhnZSkXW+wBFgMoaPO9
 o8Z6UlPS
 +MLfojVAqEv8NmxOcStGGDPa9XNfdSV9ptgb+83L/nxVTJlu7wHYT1/Yb2CTSYW7hzQUXXKS+t55ZF6JJrLoUp//YAYH5bAsxpEWJwY4Qv58Qsgil8X4L/Z6t4O/PcULPmyYd+j0/CPvzlpLwuGxoPxnSR1Voe7TOBZUthrmSWmzfpZu3/qYn+zRvVGPKLZVCAXKilqPOsgkXJCGKYmQCcKcdfZXoslpuTrBcvfwQvuPLkH1u7BW3VFOISdUa3UzXD7YRHmV3z0yKiRD21pUySZS2S+z9tl9AaC0Mfu97CHRSiPIPIW6ehD67u7lLHiVO+xWbeqMOTv0tE5OMNWXj52d77IzTYdl1evct9BKlhybWPS/3WC41alYd8xMTRh9z5Xn0wopyjix04aZVsh4xlp+EdES896oFfnhF5RHLEI+oRay9o4f+SKoj0TLTlZZuyKdSkb4NnhaOzFtO/p1qRZWjmQMzAUgbtiBHst0PnE1T4ufqOeqhwBl8oOd8JLmTpjFPK796TJgGydWq1WN/lcFLxtI2lx91xJ8f77ybRUdg+lLfK8E3J6B6x8/Qxzt42Oz1CXLH9S7pcRf5ulr3aR36GNiLM4rmhwMUpxZNVtvYq7Lh5sXDNlwiZmJttD13QZbOtYfkEtC5F+N9GcI3jnutZ6N9VW72L+Gbkkh2BW4Z5uKvuMrmJZ0PwzA65+jKOeel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When memory_failure() cannot split a large file folio, the folio stays in
the page cache with the poisoned page in it. do_set_pmd() refuses to map
such a folio with a PMD, so that the poisoned page gets its own fault and
SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:

    do_shared_fault()
      __do_fault()
        PageHWPoison(vmf->page)
          // the faulting page only
      finish_fault()
        do_set_pmd()
          // backs off on has_hwpoisoned
        set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
          // maps the poisoned page as well

A process that touches the poisoned page takes a machine check instead
of SIGBUS from the fault.

Map a folio with a poisoned page one page at a time. The poisoned page
then takes its own fault, which __do_fault() turns into SIGBUS.

Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
Found while reviewing Usama's fix for the swap-in side:
https://patch.msgid.link/20261116063624.1382944-3-usama.arif@linux.dev

Reproduced on a huge=always tmpfs, with a THP that vmsplice() keeps
memory_failure() from splitting. A write fault on a good page of the
folio maps all 512 PTEs, the poisoned page included. With the patch it
maps the faulting page only.

 mm/memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index c966b3fe48b1..1f899d1be407 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5920,6 +5920,10 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
+	/* A poisoned page must take its own fault */
+	if (folio_contain_hwpoisoned_page(folio))
+		needs_fallback = true;
+
 	if (!needs_fallback && vma->vm_file) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 		pgoff_t file_end;

base-commit: 5e600d79135124a4eb8e9db30ad524224c267c07
-- 
2.54.0


