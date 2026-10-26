Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BDE606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=Jd5+JTA2;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=mB+sgAFt
Received: by kanga.kvack.org (Postfix)
	id 830A76B05B2; Mon, 26 Oct 2026 13:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808296B05B6; Mon, 26 Oct 2026 13:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E9E6B05B7; Mon, 26 Oct 2026 13:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AAD16B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:53:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2A8CA0831
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:53:17 +0000 (UTC)
X-FDA: 85365524034.22.C90F7C3
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9CCD612000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:53:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J d5+JTA";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mB+sgAFt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037195;
	b=tyCVXXHu2JtFTUVwyUyhm1rSreng8uJUuz495tHWO0tXjz64HQGfR11SHuACnPQjYMmnjy
	KMOov7ImarGbnw6/rRqC804j3EQ1ivvG3v0mhuUSb/fMW3Rb4PYHqP1KPdMmXk+8O/7TfJ
	krhcvE0yYfbt+dovIa+OEIUPuI8GQhI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J d5+JTA";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mB+sgAFt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KACmT1OYSdKCyCU57SCSDyT0EpPZTJC4vq2Q6TppUno=;
	b=T2olWjaEQRJQegm2qs4jGvQqYM9XjXX54d8u6IadkOUKgx92aJGDFL61MfQy+UTeToZAHO
	BJ68SY0uXf49f6A4pob/4qQ/6Txh4bX8BuHDtl7uAfK1cIM2ri/DPzFxuUt6viFLukXZFP
	OlmF/72ywPLvtAtSOkD+EJP+Vyd65uM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 4090313801E8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:53:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 26 Oct 2026 13:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793037194; x=
	1793044394; bh=KACmT1OYSdKCyCU57SCSDyT0EpPZTJC4vq2Q6TppUno=; b=J
	d5+JTA2anFbRN+nBzegXTAvu7ghYtA7aEPbLvwEE0xIqOGuA9F7c/gSv1oUUyhUZ
	nVFb87OeqlMd/ej5V1pOWWLROJR47pXdf7IkWj+LjNqdqvZwsfboZWgaGQ+yB+r+
	kbhT4Q6SYtjn/CaClOuV5ERYddnynImXnL5CYkx9EaM6v4nRgIyOxDdTEDpumGyT
	IVDrHi9JxfEhbstOpKYdts8q/olSFp1rhLTCM/bZS43lHJuoqt+R3A09GBiBws3i
	PfKgz43l55YoS309zIDia9nntfZb3b0FN0CZ/dtzcuwJaTY1JvLg2batxg8LNWSj
	PXSQx5bO2e0fA56EHCaaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793037194; x=1793044394; bh=KACmT1OYSdKCyCU57SCSDyT0EpPZTJC4vq2
	Q6TppUno=; b=mB+sgAFtkmhO4wvVqYZa6mOtpMK8TfmZ1ULJsH7qsBgqFl6bUHV
	NTrF7b/7PqofzAlUspS+OkDLgFpx1/ZnJy+eNxie0I9OjY78tO47/ekEENEmqcMR
	mP2IEE9jh1DzWLlOt68zoOTpBYyEuzu1N9RLEv193vf0yB7ka/j0XAWucu2c96DW
	2GusFOSsEO5F8wuazkJ29HaNmAwV8tXN0+48lWSimRiDppggTswICCi9XpKyQwVD
	p1a43nlS1NaL+sOgHOOwDRDgyzyPxM7mAVmCG2qUjQXJzNXCjD5Pvf0LRABET1yh
	ut6873xozx3JD1rhtCSrgiScfrgpuWhvykQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793037194; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:bACZAbHFlWhbaOnMsy5k/hrgkI0Aygbwmd/jg6LQLJnJJzN
	K1MbEiqL8LQW66qtpaAAJizpTaUqmOUhcNgN3PkbYQyYDuKR3lRqKHTKea8M9xVE
	lZulkL/5qYCloZRqE7BF4y3+8PotUNvAAwd2KlZ1Ys0mUGrohO+lh68K4PhsjdDi
	4+ls5SsGxRc2MNCnyivSUpkTMN8OiC4wWv5UIJwE/sjCICMkSe5w6776Ae3GESnj
	Y6ELbPKqIWy3mVicXuf9uzptj6GVvUefQhB1tq/g56mbYC8I5LO7vWKk/Z5PjKGN
	PT44iRjawrruIknnyUSpstgX/m3ASTXGDWtzqpQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:IeqHrH4qIXx+xPUlMhf7YIjv9KFxsPF2dPcCj2TGE0k=:wVd6akMHCr9G257g3NGzQjmz2P6BKorB5KPID/xSr5c=;
X-ME-Sender: <xms:iZPfaqQCidi1UPaTv9N5eLldVWZynia8Oi9eg3oyYThcBvNwqm-plQ>
    <xme:iZPfauSK6YsCZCu-Hy1qRsE8v3f7ohP6sReOFlJac_9R0zkrn-z1H5IYAP19-UW9w
    ZLovY_w9F-P_tX5zLQ9U0NrvNrb8Z9nyKAt0FqsjqLT-IgNeyvcO_4>
X-ME-Received: <xmr:iZPfauhwInFRFYstERI3dLG-GFcy4h0llenFAbbBv-P88ae11TXqtoWDkJU>
X-ME-Proxy-Cause: dmFkZTFCJC346uT6BkgpqQYR4FNPAi1RA63Z+5L1PPhx5EiCpW4UTmnFOpzGWG2lAFxYWG
    ow1NfL/UTp/Pd4DBanvkvVjQX4/GJ9QHoxX2Gnm+9O7gKo81tMOLCB6mgJceKwlnlE/6R0
    V2YJ39AyV14l8ouat82SghyoTr/S0qOn4UjCWDfZBVfbZ8H6KBl+RFmwuyJgsMdh+ieuFV
    d3YZBJi/v/7a8u8UDV+6GBpxXisMoQE/lBwP/kVhG7Ecprx03wwiSqHTSA8W8XkMGFowSD
    sBsXoX6pbh6kmOG7yuRNSEET/XSSH+CeKPAuXjog7+s9n69YFxLZ6RvMAi2C1P2qu/rztS
    Z6h7Bk6lcrSoJpk0r5tIQZ32INvXGzppWl/zUTV/+JrDHRouN5X1NkNQRS9mQX+ZMkxAQG
    yuI2KtNX+MVO1nPv/LUVzeMu1skyc8UPO67BpjOrJQB30rkhzCBlUWI8auYwoN6To/3Gr+
    PrjzqVoryOE91bbJ76HytMXjUtJpnfaGneD0WZ+6lz+q3nhG433Lqm+AEW+vJeQGxfhj9W
    DA5+frXFGSYYYRUVroTmsSKPKDRM1xeYtNcajZ/wqDmkv0snlv081E0SS2TmnCDXlTe1Lu
    hkKPdhvEzsMWhe/dY1J8rdd+7t7BNLU1RQ6t5Rhm833tvRnyF9S5YycCZQOw
X-ME-Proxy: <xmx:iZPfalJtL--z6xTOZq9C8MTzUStdVcC7q5RaJCzrXHWjffyNjIPO_A>
    <xmx:iZPfaoyIXFFInL7MgoVeCrXnbbYFlhQKDGsQGVNgBVxeaCvUxRG5Mw>
    <xmx:iZPfalH6fmBsm7jFLTPyirWAjTDIezwZASigPySIcM6gJsfbzqHn8w>
    <xmx:iZPfag5IyLv3WMATrG_ciQH9hx41q8yLQuLkZ9Bj1Wmj_sUItjiYmQ>
    <xmx:ipPfapk17ES5yDc78-yfcDVcAYf98re0iAEFDFPiQ8bUBE8OwOyq1Ja4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:53:12 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:53:11 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 14/16] mm/shmem: fix truncate loop after boundary swapin
 failure
Message-ID: <at-TaQ7RoQj9rMCN@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-14-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-14-703206d5fa0c@kernel.org>
X-Stat-Signature: pa7a19mn75w91iqrhfzn6r19rwuzn1z8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CCD612000A
X-Rspam-User: 
X-HE-Tag: 1793037195-306316
X-HE-Meta: U2FsdGVkX18MywSlEG26UeDL0laweuLLzmlQDyoMbp51m8xpXKB3aZwNNQPniFE8Ttcy0mBlwdZ3a41DJdT9awctcTqOoZLjX5Lb7bAT/SVpGiy5nTbZ3dPDRsYll6XGR6xskqJMZjtwN0nw8/lNnpWItF1lBNePGBrjkfKevEAWVPbgeJB0BTo1wi3nCXQNJaIsBUjVaD4r36TICT26az9p1TT1Y9AoV1jUne13EXImi1A0wo2g2Fu6IAeOPYIWH0N2JGmngm8o8YOizGnUnHyw/Ay5wiCBDqVr/xQzid8oTPzHjQifv5xJWyjKcENhdq8co8o8ou8AOitVzlBvUF/p1dbSk396uUsC8VZDhfVJhhOoErjfnRQI/1ZmTJmkSw6TA59wctilduUYEpI4rJjWfQqK7SvZNvGqv7hv1fIql7umiaiLUbyPD4VwD0+mGx/pz+eIQPsro9iYStSfBttyRVI4J3z2+PJk5861zPu1ApTFL/+C1MRoQ9itYZq0s+FVFvTsOG6dDuI6FR+L2IxbaKpet+V6rcsQ9SnExS/+dNOdMiLTcpMeTPEQmLsYh+uRAD6838F6PCQEHvIH4qNPG7/Lgj0XiaEm9detIFkS117cDcUKmXqoY8IZR9mT5lnzjiFh1KIsO42JUeVoFO327LjHzZ3GFhq0m4hoCntVdoX6b/5qWZ8G7EtIbjx5jLhxZ/8l+Jw6MiJXtv1h8GKLQYYWbLWyyyFO8RZ4w+9zVl/kLgKMvaPtJ+oasN0xmADeX2LGwJ0Pect/IC5DJ5ziZa4aOREs8pzhBNs9KiOjR5p5KTbRShNRXD5HChfUMliXPEd+o1j/kFiawkiMantD4hfjnnvksHwg+e0qgFmBPGLLcz/CZZWtvZAwVxIB3VsG51g4cKIHAWMqq2/VL79tR3wVPiyIFXJxdtGHqyjDektVQ6/kcli50MFR2Yzmi8OfBu+UFCRZa2o5rhU
 cAQ0Rbgm
 dElrb2xYscP1VQwkd81nMuoV9Pevu9BR9z4GdI6dFyzieTaPqBRY3W5nvxcs+8BCnTksHtghOiWDRdx0N9mUAc32ehztsnfvUAP6IDo/e0w0/TGlZTks6ahDAfLfrl04cAZ4YEd0cM4wowpEGOFvN2SHIUlv/JmXpM7NBlnlE0jZNlWxhFP2k9MEI+mJcQzN5B5a7E1qrKPKDXart5kHSzbdQfnkYewIhT4/5Ka0gwrGYwkTiDWpBv0w2MaZeSV4BgM9p/Sd+Zqlq+WEOpQaO68CoD5Qoki+DbRpxzKAXgEVqkEa22I0amdguLK4rTBzN+a+ePrLWe+xp1Z2uombdRUU8dFIINoWqlRCahjCcKSmO7mlzPi6AqJ53Br/6Hnnr9R1/j+BRGPSzMt/M3HIw4sFfmtOA3q4K6+LrLpb3NX3S+cFEgOkTBgBAMWuyan9l2/WJ9dcNxypgkXnt3kQAnW/7aVRb5JjyA20ydmyCZzw4OvDIO2zeHJySUinZhi2FtgHxXBla3Edxjh0CKBnCwM1kHS/oCuMGW0NGpOHfPmbom2G93ruVrfngn2pujvWsZiy/frezmFh4Q3Cwo1L5UAdCIqkn8ep0AH6LM06HjydIF+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:47AM +0100, David Hildenbrand (Arm) wrote:
> If swapping in a large entry at the new EOF fails, shmem_undo_range()
> leaves the entry in place. Its final scan skips the entry, then restarts
> from the same start index and finds it again. Truncation can loop forever
> while holding i_rwsem.
> 
> Advance start past the skipped entry so that a restarted scan can finish,
> as we already do for folios that cannot be split.
> 
> Note that this does not fix the missing zeroing when boundary swapin fails,
> it merely prevents the endless loop.
> 
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Okay, one more stop-gap:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

