Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA74ECC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96296B009F; Thu, 15 Oct 2026 12:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46286B00A0; Thu, 15 Oct 2026 12:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E72D6B00A1; Thu, 15 Oct 2026 12:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1276B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:08:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFCBEC0163
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:15 +0000 (UTC)
X-FDA: 85325342550.20.E22616E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27E0310000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYhfvFO4;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3afvpKZmu+aKIyTGjKM2wG2gBoeR2hpYzLmhDcjm3gw=;
	b=7WDt9UwFAx0c5YmwqwphUOJ18euB+C2OQN1DZPgXqsexjK8I6UFrznw6g/fwhFCPjd8Xsu
	JfoAJSuzJODLD5gGUU+3uIULeTai5Sr6O837N9AUn12i+ob18ymsJkFz+3thRMFTpWLSI9
	YHxToIBWD9bxkZ4YHJtWJCOtcYqJfek=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYhfvFO4;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080494;
	b=eiHj3aqUJebIr+Dl7tN0fyvlIG2ILZGxrdzC6j8FbdxLcUSgxFn8HOQynhVYllSKPbHv1C
	pmmo1XM+vExQiVX74N4ndBv3TEEF/hn7RsyzTZPy+3EVMeJ+c+uzjCUumM3D5eMkQq5cFX
	GUA+d49rICpnTKoR6Mw6VVhYrTLmn5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3BB560120;
	Thu, 15 Oct 2026 16:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B770A1F000C4;
	Thu, 15 Oct 2026 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080493;
	bh=3afvpKZmu+aKIyTGjKM2wG2gBoeR2hpYzLmhDcjm3gw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fYhfvFO435HJX8G2tJtP76UAXmJ91Nqa2hGQgcoVIF+DmlQd1+edSNcaE1eEqpnvg
	 slM//rKzJmgasqG4T3BL8RHQwMQn7VfrN/UPyCvclOS6KJ5zuXQcJcgL2EIsAUCIy1
	 +WE8HwVO/tfCMQ7iqK//NkgCsprNmQ6irdFK4X6ROpiLwhn7QRz8ZL4dYlFDe1GRc/
	 YhOk4ISazQ9WQfsOxGSynufEw9x+vERdRgx4ENL4OqQwd5dWVDS+Zz7dWB0MZ7rlWy
	 hsz2tsA2CD7DotS78D5FBwfpxg8jVm5OFin/K4HDru4o6SZ+EJryWcMmEpvlmqv5tf
	 ea2VqumbPfPtw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:14 +0200
Subject: [PATCH 08/10] mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-8-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1330; i=david@kernel.org;
 h=from:subject:message-id; bh=ofcXbd6OOZoV/XLvMGg3PkUCMySCCrJuOQSO/eipRzw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DKO/u4dbn2Vryjmo2WmyN2iOelftGYEZC9wuDY90
 WSiiHR9RykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPZ3crwT2ESC8MXne43+r4x
 hk+0nC/qmUf0JDC8qko3dEoXW6yRzfC/sHDFvMK5Jk+S43JFfEuiegWWbtqYekwm2/3cBq47233
 4AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 27E0310000C
X-Rspam-User: 
X-Stat-Signature: 6esu1hz7q73y3sriaj8a6ir5wn7upzfy
X-HE-Tag: 1792080493-546740
X-HE-Meta: U2FsdGVkX183qRgV+LV52/nuDBqp7RozqjdaSBOvNXGAmbldPU4FrfDElfD/djCMKi40DR45PHYqeW4f/g+da5OFRj+Jqd8gxtNH0abllShu9FHm/9ElVrPe6izud5URZVgyt5T1mYZPXnBOeKvlizsVcbo4L88ZMf+jA+p/Pa3RXwr00RjKg7EONCpG3FIWETSpCcB9Twr8eHf8ppkVJDG3EVs6D8z6vQlqfzn2hsQIkiZnly0o7Gw8ysXk3o+enPC1z0HOGh/02IZX2nbz/RLfJBD8Tj4ngFRmJhM7+ZAFmaWi4jnjnc5b8QyMIGJpFW6YE+arVxn/u+MwRGGl+y+b5F+HfJ7y3ha16jiFCpjEwJxtVhz7Clo9BixzFp93b8+KEhZzn0dOtwQa+kbtFUi/7vb/GYKM2BPbEk8E7IHl6ZVvscO6JyvoLeD9j7+8zbXDxiBj76LDCZaULMIcrwJc71oPlpJL06giBA94lTKNlH20l9A0z6H7GriQr0dXDKty74zoVJ4cotBtFa0YnX40uV3TB1KFdAwrUfRj4c+/gtr8c6g2kkL5PsyzfAiFGkuZxScaRQ4smAA2JZqs/PylmD5CrZq1bkNCkWX9LObrL+KtVfrc+2qp0jXvm+9+ycY3nvWQhbFRcv6XG0yPBVHOn59wFbFlkBjOFeYecsQcjfO5gbpacADId2Uvguca9t6c04Ths78dBW6/NIHoFCqe8QwqckXrlmdawT5+fv0HvcmUqJZauxPBcE8YvW88lvqbfZdydjFGToDNCrW9ssFI1mZ2LQ2ihK/MdpsfUXSWpRQCcBTOzSVi7qe4tB6ocrK6pq9heswCDrDQqS+D76QCMlT7sycTwLPYbf1mY7HO++k1DU6wtzLB0u69HDcUwIuz5NQRhIsTDd4QNUSITAv2/w1NYzDNVDnTf9DUkBu6DwcI2nd1vfrtaISv3ikNmePWQgEAeufdz7HHhZH
 ysbaqW5a
 AmSaxWOlPwZ4qZjuySXDnUfItIT/Hxf1eWCplNrJMn3V7+ozYmuP25jXj+SCKKDwo7YOodoiOiAnknMT6lHKq6+n/u4vXpvPSZ6EAFUdUecMrfkZFe3seGiJPeLZErPynKWBcg3zCq/ZQgwSGBUlHlCieJBnf+RPJLogyhkhv49izVu4vmI7JZGaHl8Reg/fK7hrvpPj2R/KRnnAGb6HQD6cClnSJXiZrdXHt8rdNemSbGk4kfjF7VsukMv1u6F++H+KEFsQEBnY/DUSL1tFuYuJkbCQvOFsFyta1KwaaDIM+xXkODM9qgHPGnqSeQfHY8Jo+UkhhTibUm3M6y+2t/Bn4Pc0qzZmAZY60/ddyJq9x6CU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFD PTE bit handling is a bit like swiss cheese, in particular with
recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
already confused this code in the past and resulted in uffd-pte bits
confusing other code later.

Let's play safe and just ignore these markers in hugetlb_no_page(), not
silently propagating the uffd-wp PTE bit.

Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ba6860b9b7f4c..1548a6156206b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5939,8 +5939,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
+	 *
+	 * TODO: fix all cases where uffd-wp markers remain in VMAs that are no
+	 * longer registered with uffd.
 	 */
-	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
+	if (unlikely(userfaultfd_wp(vma) && pte_is_uffd_wp_marker(vmf->orig_pte)))
 		new_pte = huge_pte_mkuffd(new_pte);
 	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 

-- 
2.43.0


