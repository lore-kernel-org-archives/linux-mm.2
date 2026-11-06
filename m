Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF271606D824
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSV8AS27
Received: by kanga.kvack.org (Postfix)
	id DD83C6B05B5; Fri,  6 Nov 2026 07:09:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89166B05B6; Fri,  6 Nov 2026 07:09:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E236B05B7; Fri,  6 Nov 2026 07:09:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5B166B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:09:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CBFD1405A2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:09:35 +0000 (UTC)
X-FDA: 85404574710.26.1EEEA93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B49940006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:09:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSV8AS27;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793966973;
	b=pW4QaNt5YcZPxYMTGbS71KbO4jNWNUa0cxvDvY6n60ibt1K4A7CJy9i6l8tRzXOHqtg6KU
	Yof9dmArVOb6K9gbJwQ9cSmzDy1spy8P0jJ7nCfS+wpv570YzSgGGwZKdxnSC6IOO+jmZ8
	AAbalnw3x+VzT+jWUB7NBhlKiv4ZdfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSV8AS27;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793966973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3b/3qYRDMXJenPydA6vHboyvASPjz0NdoyZJUNW0tcQ=;
	b=MnFza2JJM8yeUrnbyvckG66e0Udh3LN6V2SZTnR6Ej+UMVBZ4mSYOGOUG/P+E5mN9qBPOI
	qcZBb0cMu1LafWGDZzCxLISfnDMnfrUJzxQqVObZn41EnSBWa16hSNVIJdrv17qGjGkL7Z
	dZHzWt9EoRJ+uH21U5sQ0zSBEpfxvMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D9CE6062A;
	Fri,  6 Nov 2026 12:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C901F008A1;
	Fri,  6 Nov 2026 12:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793966972;
	bh=3b/3qYRDMXJenPydA6vHboyvASPjz0NdoyZJUNW0tcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SSV8AS2751IGaedM251Pc4kK1DfG/a5bXt5MUyMNuFjb3V6Vn4xUp3iR/L8tIzXEg
	 fW4QFbnPW9W7EFxJK14UemEGPM3sJH8q9j+G7WwaoQm9O8Df1ERa66qRD3/FAlWTxP
	 nWUN+s/FNTSF/IFYYiRX6jmkcO0Mt1AF6vtN0rX+pwFm65+yXDKIlIIJfYN1GjRDLT
	 KHa+J7Uc512zgU/qKs5v0uq/r6j8OxdzBWrasIoTrJry2k59HpAyPhqYtJ5oUuZAMy
	 rq+F+fgBjIH1SumhykP5qDVrutk32EhXAjAhaJXPidbzARM6gy4/UgMIXctumJc/sr
	 tndge1RuvYGKg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id A07FB1980047;
	Fri,  6 Nov 2026 07:09:26 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 06 Nov 2026 07:09:29 -0500
X-ME-Sender: <xms:dsPtaqxrJTBKMp7OtKltwm2epPFXcBPMCXjHSnvSTBZiEgpTCoszRw>
    <xme:dsPtaivhymwhYzphNsED75O-jVH3wrP7jKUF-fcFhrf_ltrIPQ1Mzf5fbdobahiN0
    DXR0fXbL_820ZYAyXeNBir1bUGTL_6fHcfbQL5d88PmyZsoB-KaOpjJ>
X-ME-Received: <xmr:dsPtajnMMIFZRQqyyuMajejjm8d7hjO0epIrwV9knfZzeapZLHElEqOGctw>
X-ME-Proxy-Cause: dmFkZTFX6YYaRab9TtEmMZcJX+vH22GvpLmKiqkJD2aksNON1/L0ndlQvnX8flK4ouosr5
    YGDUsiJ7BeAviv4JgQQ7uP7Q+wJ/EXSI9CRs9yYssUQBr42HFWwk4wrtc4JQdlkef7n68F
    nkAp48OZv+C6deWppFMl1GEzsmXrXcRCtNlS1Qjs+aP6RV1JNO9OgT6J+XnDi7YVbuR8De
    igCglYK6lQoAS4zHclSb0LfjyhmpZ/wcRoRbFIW9Kn8GxKsVqVGW+GF6OeO+8eok3lBCtN
    1D4Z9CbSWh1tkn1l7VRQwMsJnnSTVAwraXBCXqv6KiYwLXUWwr7wRmk/4JXWi7hqf99OBt
    0SzFoIlQgDEpMlYLsmsV44GLRWl8+6hUNbvse1m9zA3MICJRu2RPFptHarOrLNY4CY9lHd
    cmD82b0qW6ldXjXoIYNwPaaIwA0Q1zJXsfoLpowA0oUagELfqFgfzmKhi9i7/hYJNMOboS
    I80WilBCOxVz/X+dB1z4YwMbbGsJxJ0YGcdxwQ+oHybZTSxD49/KuR4HEZryIuuvDqnvYE
    3NpNfqDnIjTqqTUq5Hcxvfxv3tsbi9yVToFzcrI3NWelhh3yRDTy2trG/3lYRieRDRkKmE
    QS6adowkJkf/1ha5D61Y49oD8WyVzsZKzFUIOwtIblhjfFzxbZ8NKjXzIhHw
X-ME-Proxy: <xmx:dsPtanBGI0m3xopWzemDYTi6JuRs1JLnAPlsouh3Y_0c8HYJfcb_CA>
    <xmx:dsPtasQCcTihdD87s1X0vrmqulaZ4IXi8iL-xm-1W4DFdbuO3MPh_A>
    <xmx:dsPtanI8ymsHX5TW3iOzWHpISJ_hH6rm0IAbh5X-NisdFWL8tDRDpA>
    <xmx:dsPtal0dZAG_OiwyPICzFkV9pDGpdlM5nDgnzQIMZkTnC1gpHob_1A>
    <xmx:dsPtajuRiOMZHIW4dzpShBuOzRcwTMEriXB5q7BFJkzYYX3quu2Zor2y>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 07:09:25 -0500 (EST)
Date: Fri, 6 Nov 2026 12:09:24 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
Message-ID: <au3C8lNElGg4LnR1@thinkstation>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Stat-Signature: x48bct8z5hjaey98shzix19b8tsray8a
X-Rspamd-Queue-Id: 3B49940006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793966973-261639
X-HE-Meta: U2FsdGVkX1+iLwAb0VpPjFLA7xvY66owum70E5b9jFK7718eiC0a2IVNfcSdSfhvKbp7eSXIHVY4nimchLH2BAtdCL9PRPdXjaGo8ZkzQsokJqL3QRA07aAhe3fMgu9DmAE/QzquE3XJPinTrDUka/TcOdVC7/16SqJR28HsLMNQqdef73KIkqarpAGMoFVbqWCOYniL40H0DA+BBvvtXwX6hc+pQcwRvUknG4mv5pAo/Gdw/zVxnYGxKwHs61bDxNo/d0TqGQ/txf/78LlN43f1BxNMb71tzDM5Q/taSDenwfjUscAPnSy41JkbI99sSGJxh7K8T493SCH726ja8w/FIJ2XqYQ7HlKvMK2DWP97UVCkxKX4rdatJT6M4Kk1oi0u6bWUgQkPeAOszNLQ/RrNw1pUfe4F0h+KqZ+kx/ohVmGIr2ORKA6/Wu7/P0bE+vP0WhfQX/+3wQLifN3hvHyEwa38+iBoXmv3Jx+DhrwU4vu1ENaqB828jXDpPJlhO1JpoEb5E5uhaXhLpFFD1y9q+X/kPRvyxHdogfyUHleeGXwxBoKyqFawlW3nfE1W7yI/aCXuhTrphAKce3YigHw1iO0mwd+FMkbIFuJX75rD7XG2Eyzp3kT2GXXP8mrLgfVhK5Hx4R9To2Xs9aplZup5L8DxFW/wFwE8nI1N3l8qs4p8FFZ3NeyPGZGvwMv/R0+X8sabgKeiRomDeib63eP/Ca7zYKkwS0meav5OnSKBbNn7QqkR8tTgvArz7vAAsDlEGEJHcaohJxbwXCYpgWsfshPNGPBekUa7qW1LOF3nW1b9zcm6TwLjo3YMyhlu8mK9yCa1q3GT9boT6aoE/vPSYOmPSSJmfytO9PEox7/dXObSlH2wwnjGKNYWqsXHpQdewFTdbuqg/tIxjfrG1ouYI1FCqt+YrcUokHQpxepWxtIknRjx+tpwqiwNoSDvF2y74EHA3Zm8R4eiZzF
 AG0IEljI
 vLFNsOLDOwjrS8km3C8PJ4eSo4fxWcCZjQLvSUqdlQDEDFkfuXtFxhAqy33DWhSrvLZk5pYI2rErXkFECIPjWfMOxI5TkIyhPrapVqKjKLOHcI5bCw4tUo7a9VxU8qb1C5LpQGuyOf6KmwjyyNn7eoEkpy1IHM87KM95t/4613qo+H2mscAk6lTPxhSyHAwb+KrK0mZA+ORdjQS3qX2py8dUxJ7PQP6jPOpwdnEx8QTKp0HAgrhW0OoZV6FgDAfzdJGWMOnhi0OgLpkunQ81s2YYIgyfF2E4jwe1gI6avtIEI92ndAKACkLNkC3ZDaDfB4AnWpUz0LLcesOloKIrlpSktjay1VZ7qi4kC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
> 
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Separately from this fix: nothing on the mapping side catches this.
Every caller checks uptodate on its own (next_uptodate_folio(),
filemap_fault(), shmem_get_folio()), and khugepaged was the one that
went straight from filemap_lock_folio() to do_set_pmd().

Should do_set_pmd() and set_pte_range() assert it? Something like

        VM_WARN_ON_ONCE_FOLIO(folio->mapping && !folio_test_anon(folio) &&
                              !folio_test_uptodate(folio), folio);

The ->mapping test is for set_pte_range(): finish_fault() also maps
driver pages that never get PG_uptodate.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

