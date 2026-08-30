Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1412C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 15:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D81B6B0088; Sun, 30 Aug 2026 11:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5888A6B008A; Sun, 30 Aug 2026 11:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477766B008C; Sun, 30 Aug 2026 11:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1562F6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:23:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95A34A031B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 15:23:17 +0000 (UTC)
X-FDA: 85158304434.03.73F6EC6
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2B9D10000C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 15:23:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lVjnc/jl";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788103395;
	b=6/UXV2VePq32cx+vJVqRSmTaVQe5IqWXDo4ba9b3YDEm8ZDgk+jkcJ91q6OZmODsgz+Zk5
	OJDkDW7KhMBDkvnB8/JRPnjyPeir7FZYSydqYXZm4eNmXN2csrHw3Z6Fzx4NSF+z23dNeH
	6Hin+PcPnCPbfL3AanreBq7s4lMg294=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788103395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSSNdx4wCVGEy9NUCcpQnulEBBrI8D0cxb20fm37FAk=;
	b=8gnCO4LmY6Q0Sch+d7YBiZaxgbydUI1IzsdEybSxrmqEVXKi3OwrUGnRTIPyfpkRvSkmQ/
	MbRTCu9IfBXGr8DBdCmUgynXdXLF55gq5b4nsDmuoMdEipclNuVGBbl1qusDdnRHQ/2QYb
	Q00HkmNbsJFDqGheqW+DEmKJFsVlVoA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lVjnc/jl";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d6d28aa26cso18188235ad.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788103394; x=1788708194; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dSSNdx4wCVGEy9NUCcpQnulEBBrI8D0cxb20fm37FAk=;
        b=lVjnc/jlYv0FmEyLpTwdamjZ9D74PI8ULIhh/ypIB/neprcRidI++pJIFi9Jk0kZ8p
         fG6bJ3LSqovHHyRwyn7BmLR+IL+P/EV19jnFMxjIXw4Tk4QjsuiI6aQxL0poAwtHIVBo
         1PdAMBj5pUmMV7bKWp3Wiszs7/+fHtqce/LvhJJ54Xko+HzfG83fqgO8kjsQqoY4uOlW
         Kvda4aINyzfuFTkVJej+niOmb8znvs0NiH2Q61koUTFSDhwKI39aiivppaY+K/z79E3z
         ciY8CQ4XAMm/2+bvpDSDTv7AU6n92fSHd+vDQYaYhVOxQH/PJLZB5owL3ayZaSf7uq4p
         j2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788103395; x=1788708195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSSNdx4wCVGEy9NUCcpQnulEBBrI8D0cxb20fm37FAk=;
        b=W8Uip1uLvEqmaA/hEMjEB0ViROWzzBXF5fFyIsHWMXMPdfuYNu7a0Hy3HIpiaEHxfz
         YvF//mN/ygwdv0AEKjTwD2ByaIxXRFPU97TX9LUNTOSKrAjnr0DSMzdPE0JRoWvJFjH/
         CrBvEmwu1fee1HQptzF5xDW3TyNKSbKvEq/DiqPACpJP070AUG4a00W7YrFo+R2/tifb
         F975BBJqdckWt/JiL6x8l7D61SoGuGciha8dX7hahUZNuio1WqkU2uzVW+iFdaLVKS9d
         NhiP0gpnQd1XBXXxG6QAG8hJ50hOhXQkk1RyrsqiuNCZfsJ7XSrlOy4BeCT/SCr43KK4
         kNdg==
X-Forwarded-Encrypted: i=1; AKwUvBzf/qt9f6CsM0JirHHS6EaTWYmvhjg5izG9gUT22t9t7j/iHoGTNoiUQ/9TVdgIKNBfo0V0pNRCcw==@kvack.org
X-Gm-Message-State: AFuF++mB0tdiiH7amTn/2CefvcT0oI4Nhh/i/ymC7/9y62y5ryyP7mK5
	0jrNSF/M42BvKfwGq8m0EwG553mASKTdJrgAcsOVtn3z4HvvWzAcoiG+
X-Gm-Gg: AR+sD13Dq85FVt+EurPlfQ/+Te3ZJYplVzRh/1xEwV4JYFNMn1e/sWg7fhF8HEmLfko
	Gc3cqqQbKgn0GAXeuXlml8riZ4ZzylgGcc7gYC3V0/jNL1r7k//EpQKmw/dK5xTsYjo1GCFKoMT
	nTKLka5gy0jKSPDZ6TDd1CHlabuKpOuHvMDOisr3fxqOlUfCTOjhuru1eIzY4jNTqg6zDFHDQv6
	2Ghrm30GnHaMePtYQBO/S/q58Fq1o0bSbMzkt6YoODY7KGjhqztEke9vUFDEVReeTNOl8uPHkk2
	RyOsNUsLpgpYHbcU+YytE47rsN+LkOgSynbjmnM8POuvWM0t+dgK7P+QFDaQDdL93nz4akUcxhj
	24Mjf50lnpvcAkVbJir6S7rT9ZTXHEAf19n69upxn4+070cIllgnQZ4qAYl5dDnqBGwA7WEAqEH
	XUyhDBzAKV9CJlMfCy6sBT9NoRLlV+COimOwk1x+9RPDomqc78mQKKQQlsaCcaiRrZtHq4xs+nd
	6U4tYes/dceI1MAk0IIaUXB
X-Received: by 2002:a17:902:ccd2:b0:2d8:d4d9:ce3b with SMTP id d9443c01a7336-2d8d4d9cf90mr167753515ad.22.1788103394485;
        Sun, 30 Aug 2026 08:23:14 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8dad3ddeesm17231775ad.61.2026.08.30.08.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 08:23:13 -0700 (PDT)
Date: Sun, 30 Aug 2026 23:23:03 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
Message-ID: <apRHC9Hk9Ve1gO0o@KASONG-MC4>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com>
 <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2B9D10000C
X-Stat-Signature: 9ngch7r4u9e7t6yfc3j7wcyt6jbs45cd
X-HE-Tag: 1788103395-229350
X-HE-Meta: U2FsdGVkX1+l7STr5xRBEVoiTPtRaA0dsv6/E6F5waESqBUWwOZxm/U/DL8Kb3BCLEnzoAOlqo+B9NyBgmVyGdUSLfxGOAUO5rW8vhcHx9o614z9EtdulJJ5eE7NIcTJpyAIf4CVR2ViAuqXZT74q8hnPSBcj1srdBI1R4bI9q/9zQ1fZcxA54HZLLXhcyONOjWdOw0YkoqJschC34eR+eNA4Geg2o3ZGVS0uG3QQDlSpJT676xCAJT+SR812u6Whq8CsN2tfCCrFV8a6o/fxflkKnitkmdf56sOYPjfL2uQ/yVgzJJi20y8DrFk3iqTT6PsXH8Q6/ElqH7/qtCkt8s31a4DebjkBDIysV0gw9k98GPxi2x9eVyfTmJv8HD8aIM1Jk2vf7wC0MNYRMjqdeqEkJczbkYMJrCMiZaqBzRIUMIH5csnjsxsulQt9ZK747zOWaZ9cnDe3mxTTRXSYS4SwZCexVF5sB4EHbsI7wC5hORGz2z41vRE5KrTq5t1k9KwXneY1dP/b1KRc92V7QaieMRVuyreXz68IemWW9vUKTi/WysNN9VBcmm38dagTtEX7A173VtpgJtHWIJ4R6czDVti3jDuRAB5FDXGYc19c+oq5ePm6iFVJFfLKV+CcR0J+OyXiwh0iUjVKd6Ljwx6t/+g55aJig5zm/e8ec884yfVIUmbmYBD4xIj0svIKzQOrukZ/sfGgjv4jEBZmPHGav6+PCZo4F2S5El+KTbInQCH8culGVrs9W2LsSyyuAnVeH8bPxwTRXEZADcKgeJhKxihqD+GPyfUm0WCfNhCuXZjo95zViBuUhya5LLzRxyqAXgFH5oKFECeLLxWbXQfL0w6GPJ0MPJJ9365Hhj6+s0ZJKxHt3CsPYewiN2WskRE3FvdI3DSCXKf2TOpn6b8kIeYOjrFQNszS7ytRNvtLp7aAfjCJcpGmOc7wN9mu13xop3dERU+NpgC+si
 sqvAOqL8
 hGRgomxQRZYm5PAl0AqviZvbXbs6+l0KHarIFQ0hOPvL/28zM1h1valVj870HCzl6F0Tva4x+pv3+Z6bs52l6hGdz/lXIY2pR2yqIXm8VQz+QO5E+Sx9cyT94QI0p1uwc982VVALPZXw80iMW/8KYGHwq8IYcreJ//1TI+flvJPrXwangUNOtGGcvLZ1Gj32OI5F0oveUXgrXJgLumRS12Rr4HZIc2PxHu1hwZDZRRhsRMSs5Bq1NQHh4ySWsyrSFIpzD0DcU9NSbVQlYz9j9YAh32PqfU2AGTpUCFhqlX8CoMxx4ujftsi4NfQkUUcj9EHYwEiewtShmy3OPXOkHdSDStUQXiCSY6xr9g2TdFJJL76Bt/2UrVa+qGF8sVCe9sAIHQHJU4DAx1D7eWhnLkY5RxLo4JkzIQMgGoFaKVjB/XtnnCdG/E9dBmtHtATZe76pe2FeCEvKeAxwiHHEy2T1tCnVdLZxzAp9CaoPAYdNtJQIS1cyQ8Bi/JwvNq5Gpdbw6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 06:36:18PM +0800, David Hildenbrand (Arm) wrote:
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Only anon split needs vma info, and only file split needs the filemap
> > handling. Move the related code into separate helpers so they are
> > genuinely more self-contained.
> 
> This patch seems to do more than that, like relocating the
> folio_expected_ref_count check (and duplicating it, which is not so nice).

We can keep it where it is right now, but this patch is moving the
anon_vma_lock_write and i_mmap_lock_read into the two anon / file
helpers seperately, so keeping the folio_expected_ref_count check
outside and before the helper call will cause a potential higher
false positive / negative rate of this check? Leads to unnecessary
call to unmap_folio.

How about moving the folio_expected_ref_count check into
unmap_folio since the purpose of the ref check is to avoid
unnecessary unmap? No more duplication that way.

