Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E45C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D8E6B008C; Mon, 24 Aug 2026 12:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDDE36B0092; Mon, 24 Aug 2026 12:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD526B0095; Mon, 24 Aug 2026 12:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDFD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:59:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DA91A1FCD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:59:47 +0000 (UTC)
X-FDA: 85136774814.27.3C4EF15
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 69620120007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:59:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFfJP9Ki;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590785;
	b=XW9mpPQ42q9blQZ8WUPsJEf5M+eZPbLfG41Ys5I+ap3fEJdokIgnZUVXKiE1Ff+7bUBVJg
	sPyY13aQ2vivH/7gEDnJAcUsxFaCMcDfIVySWsQXNQdWh8OK1k6FPzSkHdErpZ6NTw/9Gx
	rjaLVczUA+oD3jujFas4O7bAwZGwA+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFfJP9Ki;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MA9J/J4dz8CmMza6uNEHvAF2e5np5uw3UUGqTjXdZKA=;
	b=pPxqRf0QZau64L01sSYWuKzzrCIq9sd9yaMxD0SITmvBfH8fcqHUPL3Kat6z5ESyb++vF+
	Tgkbghx209SQTIHNkDjwPyaCpZRZ/exbK+K6H1BYd1iGyqAAxBU1BynlYc4QTthpd7Atui
	wjvMvwz5QlA8un5CHYye5ZSltUHXv2w=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7eb6573bd52so3759412a34.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787590784; x=1788195584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MA9J/J4dz8CmMza6uNEHvAF2e5np5uw3UUGqTjXdZKA=;
        b=TFfJP9Kit52aywF8qLHultv02ErJPqGkrhW3rHTEMARtM8RmSZaD7PJGQry7Tm9Lt7
         uphokz/NebjqMHF22R+gPHPeau8CcKNX2wuYFR0A9HbDVdlflxRPMTaRDCpXziQnkMwQ
         VLdRUVFmDK69GmJx8WD6Otwp/HZfA/wR2WNXi43TKg2txUT1//N/plHpzsPOjgK2lDr7
         3Y/MT339cJc6ix1JCBkTtuiOnjs8S6rRR/BA6fzFxvlrN4kSfRQpH+9aLA04P2/ALAFK
         1lLFV86K4sPO8niCRTL5bpWLsuLkxv1u/CWCDfT1I3/aIiIgwdQdA5lWFfso2L+/N8W+
         xOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787590784; x=1788195584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MA9J/J4dz8CmMza6uNEHvAF2e5np5uw3UUGqTjXdZKA=;
        b=EM2yiAFrPjTsd4JCj3ueg+yIe+/4vQf8kLw0EGz0aJGLlARDxRAU1oT/XOIIol7jBm
         yRaoalylLAva4cOh+K85MOwJa0qKR0yEaqQbLkXcW4uf2qoJNzXhIYWYoTnWclfIVoBi
         vjLdOGRwi3vNg/R1I9Y6QpJDoEqK0Bpv7eZ1q0kyrSY2V0E1cNdQ8qSom8ZzgTLIE0Bn
         SdVaApULRxhHgVaRhLMRxP6jD3g2to1r00fTOvs9u1pFbJV2SDEIWdcy5CTPZysEBQfq
         k2Rd/KzJ7RIr2D0WGHIqNpVnNquwsRa9a7sBJ/wYcum4iVzN9B0wraJIDu34xUi/FvkI
         f/rg==
X-Forwarded-Encrypted: i=1; AHgh+RrB2xu8988gdramshPryQtFtvACnOofenKE+MYtPodwFXqWBfcaSud//oiZBEP0Pw5yeWJgVbaEyA==@kvack.org
X-Gm-Message-State: AFuF++mBHzzJedhOqGedBJjNabgLmxkNkLNayOLRXgdgT1c8yuGw1sGg
	Fe7hk4DlaoGvUdLo0SWuo8hbBJnzCG6CwHT/ACtkLqU0MqeQZs/WYMXY
X-Gm-Gg: AR+sD10CQpxnbSvEeoG2wYCAFPejELr38iTxb8y5FY+0CZv87t38W2W4x+cGEgefy6+
	wPSILvF6/1A2vvsaOgldNYaSH9trvgcVJwqoAFq8suhcrvOXrsncQZAawGP9Zi1d27Qqtn/xMGF
	hvMBVXa8q8Afq7wwAFUykn20k73GLUX81Up0f5j3/KaKBPVOKW5kvRkR/S++2r3FSiZiLRrhoEq
	ehsnr5KtVBqPhtTl6Y16gXCqu+T506JyrYIFnNudk6FxbIAI0IRmtHHMOBcR/YhefUsIIazRXGb
	4bCBOrhYR1WQYda/9lVo42gUqnxZuhC7MQtumINrjyAb56DhRaVnShOfkjezIOf+K0y39Wdwihj
	pZyaAFU4kjI13EhjupMPlcdusBR0PDEKhaQ5pZY91iskbwVf1P6eYCFwpAI3u3mtHbBmbDQL4ui
	lz5njlM//AwlMslOzZogAuKwzuqD21ECLDhQLyz7axnaVec+jcXruzWFJzpNhEeG+G5xptorsGX
	d8UpkyxT56OezRC3ow=
X-Received: by 2002:a05:6830:6187:b0:7e9:e257:81cb with SMTP id 46e09a7af769-7f461845b89mr33734265a34.7.1787590784236;
        Mon, 24 Aug 2026 09:59:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fae8e1fsm4566560a34.1.2026.08.24.09.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 09:59:43 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Joshua hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
Date: Mon, 24 Aug 2026 09:59:40 -0700
Message-ID: <20260824165941.2354729-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824151655.30840-1-kaitao.cheng@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69620120007
X-Rspam-User: 
X-Stat-Signature: cwc1yyro4jbpfp73mmktw7uquzekna5d
X-Rspamd-Server: rspam06
X-HE-Tag: 1787590785-841716
X-HE-Meta: U2FsdGVkX18uYsZ7kBNPMlLwnmCKHMsujXg3+q70gkAXDdjM9o/dVeJifjLDqUPWq4B835Zw6ra6yXzDuXS4ZygbStKeMIk9H2snKyZjBQzHmkdclitvZZPYryaIgGZzkMCt3AYB88MoRxVnLyyEy17f9LUzedaNPrbmGQdAvlWxJ87oK3uvdIWlM3Vc5kjvtbNjcmUdzQbDC+ykaP/nTVHvOV3rKehyuBRK57lOttFwxidBgTZvKuVPzty6pKbGV/LPOGD6QUhboVa9fgaGpOGx5tcX187h4A8XjWWyG0bGmJFJ8V7MdsklgRwWrmnu16gfjniQCF8FUr5rPUQSHV0/lxg3O1gGc8gl4qhyaT1GbKpySlSVCSWjO/fFAPEWFMS0niFC/Apg3mGpXFiujPXJaOvsWM82CcUYZdr3u9yv5ujnuI77muIVLzAmzyqXwT0P1DWiTOGadqKrx1GAczfnGYExhxkJYJXiHr2jREN7Rin+jDHWfRAw50J7y3b1RzeClToNnssB32CcWllGsk3d84ZUWOOkuG+Yd0MH+uCCuQo8umFp7leh26vKfvB4wd/X/5tpceqzdd+czUrYLdxx8mx/Anao+0UnagBtlQ8cIVtXnbmhPZeevtl3QMt1XYMKszILd3EAKND6F5roOux5wC9R9DOZQKbg7X5lG/jK2hFwlmhSwpXNhckMDMD89VjB5SN3WWcY4nDZsUyWxFvqLRuJoDWDZYKDW0J/KLXLfSlBm9fkvu3o6yPbKts69Z9e8MVDvjT2t7V73/Hpxc6TLGYc4WBBbI45qK7WGu/oGK4Iq9SuYMMy8Xiu2HjjLiLp7IfFK+FkLmV0cIgIebAxWlNi0kELAg31gh22Q0ijKedpqv69p+4Oe9s0I3N5qBoMpL2txz4EMTyIenUYQ3qGdr1kBnX6XKh0D+CsX+7XoQHhUJKhTb6fDARSZpIBHrBh/uHqgJCcHzifo+N
 tT0d+Hap
 l9ibfav3m2uTYlSo5ecyw/AsRefWY4x1jBM+Hdd9nciCv0h8tDmg50e19437E13lknUVVGddW9vXEcBkUR9RZUDI9u7KGj46tA+VPEfXiAtCgnopZLQPuji4R3HwX/DaGXhzin8hu0YfdRaHALfQT8+oQ3Arp16w4ubGOJtnSpRan0/tHeWQTbSgfyRjNOAixVAsP1+3vkMoiVCGFMGWXvzNdxC88086BoNhc17pepVUXQN46R0F8JdWNaMmAb7/EvPGY/ytmHmUZgAcUFrGSFdeZgsh7EQSETwPvG+QrgocvkFJpb7DQBtK0WEA7d8ATxTZMKEP6Ip9p2BI5FaH4rslf8BBIJXKs+S8fb0UVfM7PvRc2kleRZN1M6OrgAzfF3MVB5nRMmTG97169u+UXcmxqziMhbyCuz38/3Y2QjsAukEYjBGDA8iRZFRQvSnTxY3Wv9q57yjsg++F1KVKWOSuV5QSLXj3k6AwAdpOKXeShefwjiqLuKueUxf08rOt8P1PFwU2TpmtmczTGiE1EtCgD+p4ZZufOCsHEqpn0WBttQqyIRcnmirAPipuN3bAykj4kGyDnngvlTAEFV7H+XSqE39D2kVUqfWrB3wQXk4MLk93DvnPmS8OaWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 23:16:55 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The two boot-time sites in hugetlb_hstate_alloc_pages_onenode() and
> hugetlb_pages_alloc_boot_node() only need to know whether HVO is
> applicable, not the exact optimizable size. Switch them from
> hugetlb_vmemmap_optimizable_size() to hugetlb_vmemmap_optimizable()
> to make intent explicit.

Hi Kaitao, thank you for the patch.

I think the changes look good. hugetlb_vmemmap_optimizable is just a
oneliner that checks hugetlb_vmemmap_optimizable_size != 0 anyways
so this change seems clean with no side effects.

Notably this leaves the only user of hugetlb_vmemmap_optimizable_size
an inittimepr_info statement. Just thought I would note that here.

Have a great day!

Reviewed-by: Joshua hahn <joshua.hahnjy@gmail.com>

> No functional change intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/hugetlb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a03a75fd7fa8..885f721999e6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3416,7 +3416,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
>  			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
>  					&node_states[N_MEMORY], NULL);
>  			if (!folio && !list_empty(&folio_list) &&
> -			    hugetlb_vmemmap_optimizable_size(h)) {
> +			    hugetlb_vmemmap_optimizable(h)) {
>  				prep_and_add_allocated_folios(h, &folio_list);
>  				INIT_LIST_HEAD(&folio_list);
>  				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
> @@ -3485,7 +3485,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
>  	for (i = 0; i < num; ++i) {
>  		struct folio *folio;
>  
> -		if (hugetlb_vmemmap_optimizable_size(h) &&
> +		if (hugetlb_vmemmap_optimizable(h) &&
>  		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
>  			prep_and_add_allocated_folios(h, &folio_list);
>  			INIT_LIST_HEAD(&folio_list);
> -- 
> 2.50.1 (Apple Git-155)
> 
> 

