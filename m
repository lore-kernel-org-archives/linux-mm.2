Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E37FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206266B008C; Tue, 28 Apr 2026 07:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBFC6B0092; Tue, 28 Apr 2026 07:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1FD6B0093; Tue, 28 Apr 2026 07:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3FBD6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:42:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CEE014064C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:49 +0000 (UTC)
X-FDA: 84707775138.13.81322CE
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id C41B0120009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c4yeT+Rs;
	spf=pass (imf29.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLsCRxiSk9JCczyCTSC3xk7yAKwnu18iR/LzsMMrkH0=;
	b=5KnRm7fblhqXy3nO1LRSECKVq0+WvImuBkHA31CXa+5Uley091G0Ou6cDpX3ns/U+Nh8o5
	OUrJF3kncw+3smjIvGkZ+F6GHjAoIqeIF5detYRW5gYqKopyR5DfiHSKQE0jc6uosiefmt
	ZabD/CzYD5xK7Y6E0ICabSzdX0vahV8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c4yeT+Rs;
	spf=pass (imf29.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376507; a=rsa-sha256;
	cv=none;
	b=sTVjy7ZY9DRwidbzy2kz+0uzY/0aAtqiHKl8d4gWe9tD50c0TqDGyNiQcKH31vxEm/mfDI
	PjS2r8W78toDiMTnI3rC4pgDk2WmKJjes/Cpnuckxoxzjm67OO++yJ9Kg8aq/rSJnFOADv
	jukI+R4/PyIuWvlWB8v2HkYMb8gEJd4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so9522951a91.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777376507; x=1777981307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLsCRxiSk9JCczyCTSC3xk7yAKwnu18iR/LzsMMrkH0=;
        b=c4yeT+RskURQD75l08giMMdoJwi4V/mPcSf/rma/ar2KNAoh4m3+NHha2eMBDnvFw2
         LN/4wQmq18OkMi0Dhx8EAiIq1W8W0XfQTLOnQWlJyG6iHfPZpWMVU5IoHytOsztFytlI
         rGClS5vPd2f1H1Y0i72fJebjWcvpr6F5c94dzeVVYgP5bri4BxU3zZYlgLrXWZZ5c3Wt
         GwVeqpQCcT5YEZe+KoJl0sdOWz81OWCY2USN//zZNcdxjOhlW38EnGxrkhGNXLd2A2uZ
         gUmWjPmF7OIAr2s0Ve7h688Ngwznd16pW31fo4UY5eHnLYHle5QuHHyLL7JTXe1aoWNT
         myYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376507; x=1777981307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NLsCRxiSk9JCczyCTSC3xk7yAKwnu18iR/LzsMMrkH0=;
        b=p1zqEQy/wh4/MK0/bHNOwEZcbk1YaXir37Ifbv4pOvWIyb1v3FQ1NnTgE2GI0w2K46
         bjDAIheM+3lW/nWI2tHc+aT36YFU/0UjXakfNYy0wV7dYva6sgK7Qi4L0gvr4mDHo+gu
         oD+Ze6SzCr0Eti+7FM9eMvce1N/i0NnR+wvzHax63B/Tu8MuF4+vcmxv8BuAS3JeO4CF
         kWcWqLIY8PiJUHja+tZ7BvKJgQXBXFnODeFNFe9Ao3JucdHCIBLBNiYQbww7VgBtyRyZ
         5cznHCy4TaZ7YhK9o4pu3lDiI6ob6tjd77hOvGjctQDyxYscLr82XaVwshzskEGC0mGR
         sJdA==
X-Forwarded-Encrypted: i=1; AFNElJ/FVU4PE/hmwAINde/G5FHlsxZMcORH/Bl+XmutW9btZ1dmVs2Y3vDHAhKRag16RW/vh3U6jLTEcQ==@kvack.org
X-Gm-Message-State: AOJu0YxJVTriKrfmdx2aGSOYHJ/RbGP8zHFM2AVkwwBg7O/cpKaPgDMj
	/bRlgml9uGODal7A0ZW6cPDicIRk20sazKczBFdPIfbbPYwqEHbCpFfV
X-Gm-Gg: AeBDiescdy/7D4eypGwxMfofHmr1zomk83G4qRE5XjzrwbtBH6rUdCS5g8cb1nOTACR
	qxICG7qExn9CG8q+mAye4h14r0Ht/EmZgXglgXSq0vKJ5RJCH/xi1tXFxCDg6ag/Y+oUs539Zry
	UkrtBednSRzkEesjZMeYctdCFjsGJVdxPyawcrb8yqjCqqiomwm+/9yqRCWIpdS0WzTOPOs7lgc
	9WWcJafTOA1E6FP4wX3dZQU95w5DeRVEZ3+/pnj//c4PegF7aOzNnr8xTRKj4o3i+Goh1Pg8mCZ
	zYjiMVwMsoanpGwiY36GKhrPfddBVREHze6Lca+XmYf9YFEsRMMrws2xTCcNKBlX18rx4jox5m4
	6g4FREmLLSAW3WLHnq7CwyCq6w+dann7nSMesMCE7UZbQsQeF/TTWv7gXajAoB/KOLksJtblCon
	qF8Lh0tD5N9nNwrzfg7D52keg+yRxUD2rWzVLI2XXkUhZUT3zl5Kn537Dy6UiaZfgsHkDLNbcE
X-Received: by 2002:a17:90b:1d50:b0:35a:1762:92fc with SMTP id 98e67ed59e1d1-3649205ab5emr2794234a91.26.1777376506660;
        Tue, 28 Apr 2026 04:41:46 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([2001:c10:ff04:0:1000::8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490924f01sm1785721a91.1.2026.04.28.04.41.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 04:41:46 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Tue, 28 Apr 2026 19:41:39 +0800
Message-ID: <20260428114138.92159-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260428113059.79001-1-lance.yang@linux.dev>
References: <20260427145247.84157-2-enderaoelyther@gmail.com> <20260428030712.66256-2-enderaoelyther@gmail.com> <afB49BIqmLL2RKHM@localhost.localdomain> <20260428113059.79001-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nb8xh1ro3np1jkb6s1ctswf8r6dfh6dr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C41B0120009
X-Rspam-User: 
X-HE-Tag: 1777376507-270388
X-HE-Meta: U2FsdGVkX1/1DJfT9sf7X39pQE5DMqSa4n83/ZJ3PHiGqAFJQ5veLpaF8bSBxyp9t5m4Wbld4NcyS2CiYxG6cZcCh9VguNJl4/lrjXPKijWdoWcPaZHpZp6GbYfMiS+CnPhQqkKENX5tiPAAu7TKUWy+XAuOkpe/j2P9TOlwqBZzAnRZAB4WAA9AWDHs4duoOdwM1rgaVxEaO9vZ3qj1gCYV4O8Sa8JVDiqiPHm7oo7PYh05VD711a6xmslK4r6gvr8qnv1K9xQ3PHNVDapSgxuz+LQe2JM4vH1xrtBiccHElM4r4cMZ3oyNVIviW5bdQnFV2n52FiKevD/7MWbjEM2wZST03j0onSIRGhZba5otNVmRNmVJq9ayM4XgQnjco//ba/UxWcmTdMt7oy6D6329klRnL52T+p7/dqvO3nYbrREfrh+FeThRpIEVaiZnk7wY6OmXlXYa+DFUkYC46hm3a5uH4SUz8TBKY/yuPlGsxvoWUFG1c0RCRlDIuCp10gnF6DW4vWJY0TxryhDjdqOgrr835itZQvoyhdMV2ABvlkP1Gt+p0iKdHyzmVZJSG+g0EoW8wtrQ3YGWypkmyuP8B2JocLyiPZK5yl/xFcnyiWx7fLGyIA5qJejZUmUcMa+po6KBZuzTitMSbbGqrpJL+cnfb5bY88IGqM7vBqpT0YSDNhUeo0SqKFHb8qXKlPXiQHE26ooUJ004MKRFyBPmLIF9rw3GEadXBh9RsWRlC9jmadMhsOb5lQfm1iONfp/R+DFWXvAXrYo6si940B1K0ov0wEF3vgu1hqYumpf/Nnblxvmy2RSVl31JlZclmtExosL9l8hIUwn5WsG8+xRXe4FkunGcM4uJ42lanIOUDNRqjJwIyWInQBPl9q3cSiTSV4ARr9zP2lTNrsEj0ULcPRZrBEGQoyp7G6Wv1O2mug5FNgcGqvsq/85TEE8ED6mlE9gffld444p6IJX
 5wMSSP0d
 85LcFzOj/3g9nr9H3JrCE4VM2vapfAxl5TQ/8xmFAR+r3Xa3zWIg5Dzjn8+WTqvRv8XMDEKLstYBqpqQBry5bs2za6weyFiSq9LsMNORaZM4uGXReVJfx0OCaVSTDW+rn0BzEasi6DwqtIbxJ4SnjPpH+Kai9hQ/yeHWoiIHl6zOwaiwWXWFEKo41tp1EyVdiiCZNPQ8VqOA+6mmWHbZw1hljLcKIf3WrrUnOwLnyYLo0AIX5JEzdOBsqX3P6SWShNTcvcDH6XunA2FwqRXBplX+cTPdcN4aSL8V3qeIci/bgd6IPOo9N3DkHWdgEaJnKDZW46iw4j+4HepNJ/9spiafz7c4DPA02OXzixjmzk9LkOWh6RlCS8rbamKH0a91O0/r74ATNsqB8NZjxD+10iSCM5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 07:30:59PM +0800, Lance Yang wrote:
> IIUC, there are three cases:
> [...]
> 2) gbl_chg > 0 && spool->max_hpages != -1
> [...]
> If hugepage_subpool_put_pages() returns 0 here, it restored one
> reservation in spool->rsv_hpages, so we also need to increment
> h->resv_huge_pages.

Thanks for working through the three cases - that's a clean
breakdown and matches what v2 was trying to do.  We ran into trouble
on case 2 specifically: the h->resv_huge_pages++ on the
put-returned-0 path looked right in isolation but turns out to be
unsafe once you put it next to concurrent hugetlb_unreserve_pages()
or free_huge_folio().  Two reachable orderings break it:

 * free_huge_folio() with HPageRestoreReserve set already does
   h->resv_huge_pages++ on its own.  v2's bump on the gbl_chg > 0
   cleanup double-counts against that.

 * hugetlb_unreserve_pages() does hugetlb_acct_memory(h, -X) which
   subtracts from h->resv_huge_pages and may also return surplus
   backing.  v2's bump then leaves rsv_hpages backed by no
   h->resv_huge_pages - a phantom reservation that the next
   subpool_get_pages() consumes without real backing.

v3 ended up going a different way: the gbl_chg > 0 cleanup is now
restricted to (max_hpages != -1, min_hpages == -1).  In that
configuration hugepage_subpool_put_pages()'s min-restoration branch
is dead, so a direct used_hpages-- under spool->lock is the exact
inverse of the speculative bump - no put_pages(), no
h->resv_huge_pages++, no concurrent-races to reason about.

Your case 3 (max_hpages == -1) is unchanged: cleanup is a no-op,
because get_pages() didn't touch any subpool field.

Mounts with min_hpages != -1 are left at v1 behaviour for now.  That
quadrant has an inherited race that also exists at
hugetlb_reserve_pages()'s out_put_pages cleanup; a coordinated fix
belongs in a separate RFC rather than this stable backport.

v3:
  https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/

Thanks for the review.

--
Zhao Li

