Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB22CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774B36B0098; Tue,  2 Jun 2026 11:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725E66B0099; Tue,  2 Jun 2026 11:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663256B009B; Tue,  2 Jun 2026 11:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5757E6B0098
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:41:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE35B409C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:57 +0000 (UTC)
X-FDA: 84835388274.21.E69277C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 248BF80010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5txiQYE;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414916;
	b=sCfhL/QJ2/LPyD1HZod7CXyFIoc3hfjCyFXEX9eIpdQIqGUkLM9qqchGewMMpFR7PDiT1Q
	S583wJuM+5IDzSKpyoD356aVoFv+vjz0zcSOcmhfvEcu1+L7KAcbjyLT6KRLmDL37X+sCW
	rjRlSBuqMOKgNWS7PfXdMRPkIF0yb0w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5txiQYE;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AULNQb+g6fJUZlryqt0xEDBzan/vuWgTF6qm0cBWlWE=;
	b=wQIp0921Gwn7m+AnCEMeBtuUvLue2vqu+Hi4XU+pYZMffRr5CoQfLp42i9Z4Z7lD14x0wy
	V11pnCt6BDu5or5Q4MPSXdr1Ll00vVPbgcoIUostRHLnhK95fwEVJBZVbOlNLBWebnjNc4
	2f31fvx7yhvWjXLvAhVQpVdQYCmo/pc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A17A40835;
	Tue,  2 Jun 2026 15:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1CE1F00893;
	Tue,  2 Jun 2026 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414915;
	bh=AULNQb+g6fJUZlryqt0xEDBzan/vuWgTF6qm0cBWlWE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=O5txiQYECnW1/ur43TGykfWS5RozIhiiGfdSugDtUNxMzeMj9Lrksy5+uYLs2fH+T
	 e5lVdzdOj3Hw+T+eC7ddXMv11vt6D9tRpINxttmEDIPop49RtVUtnikkZsMPFY08yw
	 B4sljFfEVp+oza+voiJ/gobsdi2y0Pn/Mi2qJhvLXnRbQg2Zqet7SpigjYmQ+jnVkF
	 v9ngBk4Mc3Y8tiLU9T/s67JKK18X/tEh/i3yBYUswnR7O2K+3VAP/1fDlTmSLoRmSI
	 gzW73wzV27MvItWFLJNmniqyZvEK6sa7U/0bE+JV7rOneIb76u/nn91Kgqt2ve5C7K
	 Jhyvvbs+k7EMA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 17/19] mm/sparse-vmemmap: Remove
 sparse_vmemmap_init_nid_late()
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-18-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-18-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:33 +0300
Message-Id: <178041489399.457517.7388921848895940892.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 248BF80010
X-Rspam-User: 
X-Stat-Signature: 75xzqdc7qt5cc7as1yqwe9offm5nknpw
X-HE-Tag: 1780414916-174398
X-HE-Meta: U2FsdGVkX1+AtoCL58jvATy8kdtEM2H1q2k+g9l1Tmu4RdvB3g5FfG9Jjq2In64f2ofxJmFHTgKMaNIG8yL2DwyyROY4FU5y/dSHvJtqUJjiQAUYYDoHMR9fZXgQZIseACgBFI7YqpLEaPoOEboDhK/qP8nu82+xFe/IiGBrK6DptN0KM2T8cKPcm50oyVjrP0YAK1t9qhdpLonwsVT9bbFBliCkgXKlvhgODAicqaiz8OMVu3rcB3Ie/oP4do0wm1z8c6SN3/zCJrNPcUVtJ7WgJrDnqNBPu21z4rSFYQsQFrqwRhZpeacMBnbkVago+J8HloILCYd0Uv2rRcnUQeT1DK4vvGZn1xlrU9UKWrFHgQi+m+nZgeqUMwgUi2sa91QdKJjy2WC1gpFLknnNYMCodF5Mrh80uyim8dW5XGET5Anqn7YbdxUguGNohifMZEwSOBXkHjJ+evqtCdtCxe07ZFwaI8J4wpQnt4se/tgD8/FTOYK9RkEUNhhc7Tds560vGbUVflgsfN86VNplRrx/O4pYoNVv4e2A4guA30Hu5AwJd/TCsIb35di5R9esBHCQsN6Yys2CqDvlulSOU8LFb4lbtBsblz3wpCxt0UA9JgeugYPEtEq0vXDxbcdhswkuYkfmkVBUqkRLhfRk6TRboYGY5Kz+ifr4wKZ5oNiviPtoIHSpg+Bsgorxr10s1TyLp0bJMbUGKjzhCB9w9IoJGZNqBAfxKWbG4WPf6OtNMiV62AGeFe+pfhpAvlAP/bsgzHHuZMOi7HGEGtI1eTdEFqJ8I9XhNDP59nNWk8a0IgNdGU0inns7Qz/t2tPYrfmEgDd5cZAIU4VB61GrTAgucF9qR9YApW/A4cXz+kGSNCdPDpKJ23pF3qRFUdRa1LPIzO3KV1bh96Wd2fQPoI65P42zqdOOdBEnz+Bn/lOcaN982Qplf1sfNpN35kvvPzKIdmIwPvHibOxvf8v
 hUU7nngU
 VzdV2csUPQxXHoSpSLssH99ZPvQngP42qpmfavbs5otA8KMJw/KOJvg5QENYbDNNqZVBSCpQjj5P7K4Re6iclRpsGPKR2dxvgFPAtIasQ+ocf+5tMeoqyEo1ofHYFTLWUSds8EtsuWEvUtu8QhxE2+QdJ92ZgrHzLPylis4uebKzeKhAQfCcMC4x1Xiqrsgyj3j54fcmxN2aHojw3TfY3VNGMstg+n+W1tIK/zfLc653WoEydbJRS17/rSku5A331sGrv8v9blb8nagFCzIeWiBnvGRUGUaUKLuBqZhxWTrcvjo0jBw+WYwJEo6GvgM0K3yIOvzW8pVL6VSla1pJ0HNYa6jvWOuqtypYx7teLiYZf3NYm6JEgBLc+KJ8Qs0QD6Cfw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:37 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> hugetlb_vmemmap_init_late() no longer has any users, so the remaining
> late-init path in sparse_vmemmap_init_nid_late() is dead code.
> 
> Remove sparse_vmemmap_init_nid_late() and its declarations.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


