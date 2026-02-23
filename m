Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBCAE98DF1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5E16B0089; Mon, 23 Feb 2026 02:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8CEE6B008A; Mon, 23 Feb 2026 02:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61AC6B008C; Mon, 23 Feb 2026 02:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED116B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:04:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AC2D1A0828
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:55 +0000 (UTC)
X-FDA: 84474834150.11.24827D1
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96E8312000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WFmnTPQr;
	spf=pass (imf29.hostedemail.com: domain of 3E_ybaQsKCM4uw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3E_ybaQsKCM4uw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lJdfKFYNuLjR953Ng0mcH/dDhHLbnTZ2j5PCnoQPSQ=;
	b=IRhpmSpG/YiDJJT1oImxThkCuX+L5jLZF77OX8aWeKwqMJ2Taxl58Zs+Th6UKKk/QZjA7/
	WpVq/Ux7lwNp8aRJCRhqQ00+T6Vxlw+10JMhLSNRkEmukaFkZC5mP2f7BJ27TUA6xlMiOe
	4/Ths7yEOPZPKE08DUYINLRJbXeJKx8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WFmnTPQr;
	spf=pass (imf29.hostedemail.com: domain of 3E_ybaQsKCM4uw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3E_ybaQsKCM4uw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830293; a=rsa-sha256;
	cv=none;
	b=hwBda68ypD9mIjuWN5d9g36FWHnCnHVZ4w5QNs71tZYnRrKg4nP8g+griN/0ZK2CCDXa2L
	DdDYlPHZrK301w35f510w2DzlvJxndVrAqjxMxawxtDb3juu3LV464UK9X8hF36Now7/vs
	N53Gd2ohfpt5/xr7gpfv7/ZF38Rm5Dg=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35658758045so2873328a91.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830292; x=1772435092; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJdfKFYNuLjR953Ng0mcH/dDhHLbnTZ2j5PCnoQPSQ=;
        b=WFmnTPQrn3rm7zs1BvnfAIem5WqPZecqaGuPEeasFZi6HjL+b7jb/PmTaBf8Rdp/+L
         0+LdI+i/q+NY0+TaDE7qIG1Bdt1xQstx46cAVc3wppOBzXYpr579wk3E6N0oDSxjAKHW
         v2Gi2CXxCQmpLrQOnwtydQEP7ZmXTlpl9mCW9PSNyx2nUtEPxbrVyAvugEeviOqfwbcB
         ZPpHxbSh3Y0erHflrvKir/CbO2+LwADbTPtrIrAgz681kM/gheyw6XRT3dzUC5EWG/dN
         07cYIKxbe19D2tBTBtuxVgju6QGtHoliVYEIOGRrev49Jk4P3juQq/EnD1QhA22i+iyX
         Q0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830292; x=1772435092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lJdfKFYNuLjR953Ng0mcH/dDhHLbnTZ2j5PCnoQPSQ=;
        b=TZxTzbeWgA6WStOrNGDjaBn0x2LkpjUfulPT9xRRc92RX4oX1mQkoYB05l0SnhcArt
         KmO/De1OlzxBr5a9WEcWdte2vGDzqoKXLMzAthgMiqoBc+WAHsp1cFfXrl0GtSk9Xe/9
         Tjio806Gry2W6V6uRJjIByKV9/fCa31wjKzSkzvl3EA/Y/KrEdlmZtZKOIgPUcI4y7UQ
         7pnpjqjgr6Tb4OKEsd0Xii68gYJU5ga1yTUM8ZE2fvMZdpcMU+bFhuwlCDDlV63v40N3
         GLApjOb73SERUdtDhWRQe6LwJkzKLOsr1A4ROZYd4RX4JvtP6BidrJxYnKVWAGeXdHna
         WfTA==
X-Gm-Message-State: AOJu0YyhJVnlKSFMIHlMBqWB33rC1lmxmflzUy3rGb2hK1tjMT08NHKL
	Y9Hc6VIZTjxChkj7VrmrhdfbLKWWxZWQ/euYH4m5ECN2fpUUMViqZ8wDHg/yg0/B39tzY4W/TmU
	/VO6BsJ2oEFb4p1cPt8F6+rtoahyv2akQAEcIdRYVY8jpn1/qObRUf+h55lhhUHtJEZhW3nfUFf
	v4z7drCwzRdYO+gFbS8YBtFK8QH7doYF0ZK9qjAtHvgs+NwVkfvnY0ZIZf+Q==
X-Received: from pjup4.prod.google.com ([2002:a17:90a:d304:b0:34c:2778:11c5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d46:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-358ae7fd556mr7480246a91.11.1771830291734;
 Sun, 22 Feb 2026 23:04:51 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:34 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <108d4e27b72480a20e4490d839acadd0b0a2dcea.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 01/10] KVM: guest_memfd: Don't set FGP_ACCESSED when
 getting folios
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 96E8312000D
X-Rspamd-Server: rspam02
X-Stat-Signature: m331qesuu57xqiyo5ackxdbmjczairqw
X-HE-Tag: 1771830293-767792
X-HE-Meta: U2FsdGVkX1+QJz159jvEeJt6NGepMpJsQE9/2ADBHmD3g9Z7IfeMBwiqoECNOKpc4LDcsU53WXO2knM1qFPTexmHYtjV2hPEckex8Za3R1YFxHCbSSmlHngWY4kGydKGUVj9OF+0B+5Dnx2rBknb4xULXoiiYAmIFLwqGO9ZxPI5xcYbvbF8aokONS8LfIYX8uVs/oyrHUxFjwmVy7teiopKNS8pTmXcQy5DztKaWFlMasWt1LV3GR1cJ0KHEvGji4Xj3fIZYmf5bIbr07fbuF2BUSBS77MI8Fg+/fxjhoV1oBL9r3PbGJH/d4f6bhfARbKGYOSzWR0O96wndQX0ANWvOXFyU/aroi9fKMRtmypcxI3hlQ2uJyBFPtEhTCaRzXyfN4uUkLOvAA8ytlWlwE/b+dktnF0c1RwXzoEESXTmjrugCs7JjEaSZX4lg930ZHfUU/9+cKXKd6nZA6U32d29mvbHHdA5ZjH9bg5CmWkIVt4ZZKUm9ySSkh6M1zXOriHftmfJCHgnw7lXMIzOQxhBJuogw7l3VOBFzk/cRT1hip939Zhm2ieRzCBYIUe0/cNE0p7WdJBqLltBLeXtgaqFeOmRP0P5KwEGhHb+7csbSPTyikNbYPjg93yFmqDRY1Dn6BTadcXNWN2gxP0suJ5OcxQj2wD/uAYmTMQwNDLxaYd6AF4K1ZR2B3WHugwPskIltXPh0MsMaDo9+0TrR9SGft17gl69MyYze3yp0qq4FTmfhjJae5lgL+wWytRAUtJebg7gx7E8pXVZEdEhr+6h1Pj4vyxLm+RDJHB7Zx63FJBB8bkCVUfGujee89CV1HeiFfU1/bJu3xnShnDcOGuk9606WWupqwckrN2eBIQD3WxgggmnMwy9PiAtTpptwN4T1H0rlEl+GZAH3hetzEEkQi1UZ2krbjiN5a2CAnhmVjypIH3mrYGElYCl1uSGI/iC3vr8nqZbLMp07pT
 CKLVt6e3
 tJ3bsIwWVvXLnCakW7LrQ0lyuNnmiJ971bQALYF6GFybrMsyJxq2COh7yryCGhA+mwiE9Yxb2oESCkU0nYCOKFQ+xqz0rSCwiYyKjCADMuxdHlPLwwq/ZyLllfZI3N+Q/wbaM9dqMZGb2c/07+r9CSvgtKLataqqFd5C683w4O09EfDpSq4bh1yFu/lwgishEwaqtQU570HdCcpK7aizkPhuzs83SO8PqGZslXl1eqYDUkEBFRGLq9oop10TJ05YZoqqzZntKNMNMh+/Wfr/RDnKsEz0P78LuxqRU+lmiH0BbgvD6mpkquNHS20fuKAOQoJJHjdya26P1HNBu3Gdrp1zXz63R0V655ztFDjqJ3Z601bIC+JjR95gnE+IChrzFaw0kdf241LXjqsRRlvZ2tOvg+SDQTSfZWwSrle6WqL/cLVfTTZGVsZ1iTpoiMRJNHc8RplDG2btI6rceDUBXcyJY3/dZPK6Z3q7PGuCRWlSfAs71ZATQb315aXkINfKfLlZLZhIH40iqNv4D29w64BHRNkNzfWUQntCZs86IKpyWqqQSzNtOS3m0G5gfp7F/QMKX27R7ep4S6IhVwhy71I6j8uGUgC0XjXoLnPwj7NWcwoGBaYN0rvLUdKo8wCquqUaFDHF64y7Fs4f1NTGdmv6caPQnGIpW9e49CQqZohOJe/wHhhqQM5NThSrYpMoLjkkH++YusAXtK3YfU3jcvtVr4NDlnV5kR0nQhzBr8pWpg2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios don't care about accessed flags since the memory is
unevictable and there is no storage to write back to, hence, cleanup the
allocation path by not setting FGP_ACCESSED.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 923c51a3a5256..2df27b6443115 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -126,14 +126,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
-- 
2.53.0.345.g96ddfc5eaa-goog


