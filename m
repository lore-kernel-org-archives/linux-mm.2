Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E2BF357AD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE806B0089; Tue, 24 Feb 2026 09:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78266B008C; Tue, 24 Feb 2026 09:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0CB6B0092; Tue, 24 Feb 2026 09:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 278426B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:26:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3CD0B4CD5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:48 +0000 (UTC)
X-FDA: 84479576496.04.F64231B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F2C440006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0RTj2x4H;
	spf=none (imf17.hostedemail.com: domain of BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771943207; a=rsa-sha256;
	cv=none;
	b=yHzPBDaoYdl0FITC7AxlnvnW06HJ5gdBX1GK32miWuYLcfCEdmm/nVhpYqEGKEtE8cihC9
	ykazRwkxZHjhm/vyvdEM+b3xXVkXHVMSCvOCV9pJ/GEs8hnq4iVKAJvZ4CBc1kbx//J9Za
	Q4/pYgUTLlptZ2H3X/WhIflLSKuPQSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0RTj2x4H;
	spf=none (imf17.hostedemail.com: domain of BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771943207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvbaCOtedkXc45t9+1HNJ5IrJX/bSLKiSUSZ8gJ1fA8=;
	b=1jT93fjeLtauQT8e2a34jYEP+FhnVt7G9kNxW3lscAjGYhuIdVgPg0vjFoZQJLa7uMC+QZ
	EZ2psgMJOefBKRzgEiP1mt3kT6yH2Up4Khsj0p58UQB44y5W0ktY0sq3H0F5akBQ/effAq
	B7TvgONG0aZIC0G7RKX0oc3sL9VjaqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hvbaCOtedkXc45t9+1HNJ5IrJX/bSLKiSUSZ8gJ1fA8=; b=0RTj2x4HDWwZaKTb1l/nq/X/hr
	a9T4CYtWZQ4vQP+mj1ZXkk/jjw4MxLE/TplYyPeKNPxhffCFWcvT1e3Hdr/PsNfpLRd680vB05Lhg
	RrTeu6/waJwF7KARU0WA85jGm9Yey6TNxTTfTKYggHHqmwesayGhdRdSVP4FARjgxmJTVStgaf8uH
	9SCQ0DwbUDF/YyBsE1LOThGKBGXoDgc6n9XqZ6lQ8okI+wZzUXQlQ2IQ7BcUqOWhK6KMiZkb5JSVw
	x5q4SnhWbdDB5qVNhHR5DIcV3oUHw/tt4AeTNekQrErba4e9xNv5QvN70gfNxybFa1eVlcwhZzpQB
	/h8YKi5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vutN5-00000002ChY-00IX;
	Tue, 24 Feb 2026 14:26:43 +0000
Date: Tue, 24 Feb 2026 06:26:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ21Ij0hT6VyDg_J@infradead.org>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 7F2C440006
X-Stat-Signature: focq7r395xi4uz5bkhdekt6oes4gnbtt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771943206-173236
X-HE-Meta: U2FsdGVkX19FrJ+usrSUaH8bFqww/8/TnlZhD3XMkOoAA34MCvWO/htrwGaZT1+KDAZ5HLENk8qY6S5WR7tA9UI2E++MtGQDsVY/bqDGUljr1gSUP2tOXzOPNqar7fFoTGdDtJShcF3aU1GnKx626ngrIGGq/B5ltZkZY9W4E/mB+e8eQaPSN1Eg/ZbY7JxsNK4NvSyl6d5AxMw9NIDZcA64Pa5O/Dsx/e7+/6otOq1oI4HWnqPTxBayUIlngK5HsZAQlApG8bTjAgWE/tw8G97pb4g51WDuJGlX2zxkf95bJYNm0Koy6XlWK7pEwbELrxwbOMugTDCdc6RLYF2M+AzRQ1nHiZhIre7Bb+T/ABrjnAlWJ3UypIU9DxEj7VrkmpXzAkawOY/l3xztW9BbOuL8q0k66f8WmtA7f3PXxv7454x6Pw7TITgKvny9aHYu/jnGeInqTZWNkao8l9bDkrg6JwIQ6J+a0LBwnQApM8FjlnNT79ZvFgfC2nDpPPNnv9vIkgIbj7uUdfXCH9g5Fu2mfyJgTupeM8bdm5klKLGRDQcAvmwH5Euh49WeuScnp3TtSkTPR4F/b+UiBfcCMkdJUVQ3GMjkmrLoUmKAj8bIXu6Qs883hIMDYPYSXHeEdFYt3KA6sWCsxNuhYKFHOscEj0IQySHt9sJG8GcFZWsnSpsnm4r3KSBTZAUNiM/OWpM3bMQaC1qWkNR4TmmRMjse7na2ju/U73LNPXaOjLJtdV1wb2at5M3djH1w+ARrCgcQXUrpBvdHClUl4b1dDc24OcclPGUi75oGc4GKXOmkg6htsZSogYKMxGdmU8BmIQ6oTWHuv+zqveFcse086AJTwm0UGxQExuFsJ5TUePXZoSkBgfkopzJ+GzDlrVpLwFEoS1yLvtaBKBsj+CA0iej1ZH/iQ8OFO93S1NFReF1+sIzr5J828HbyMGHBrlw9n3NRfFVMR1xE3lLOSDn
 FO7xrSjf
 //WS8fzynsj+a0l5wrZUFIniItoCtx9bK/f+I1WF3OMJtudbzEWuvezQDS0FYpYs7uxtSUcTUaKYqqJbhqY7EOXMb6z9E173FHTR4xMUzu3wJj/TECuaEUFVDwHI6gy9y+XPITvV9YvEO6Elqkv0HNHcipEs0i+htJdukYEx9hjkHMiqWcIDroxNI/Ucxq8pVxtvpUVahKGHEiVbojSr+XuHRUh51RFeX4iPIbIOaeL8NlLbzND51BqVqson06tJWJT69O/SDG713VrptFhRLmorv2MaTc1yiva9GtujgWsCRo/x7mfdaa0QfjMQ+8ElgUIwQgSj9ul0eVih3tgfZsBDWGAm4CcczKvmPlI3eEi7TZk3viXCoxGpXni8l62oT3wQiioqZ351qX5QrZU6tbOrerN25N+t37oJorRVf8mLQAyVp5ZK58JDOBtfEwEwXTqQd5I2OF4HHFFUsogGmU7ZjKtWOkMfsI8PxKze41b0v4qGBFvKiBV/BuIuCnkrES7vedGSrd2r90tvaXqVWA8qqo6eTfcBdrD2HbWqg4fCRUIgp2eLrCwR0XILR71VEGfs08o0pDiyi6y5b9qyN/BiFW1wCBY9NwuDYj9FiMf3NK1A7ny87gQC4kltcjfNdaP/1IcLemd8DVEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 06:22:15AM -0800, Shakeel Butt wrote:
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.

That is a good point.  Compared to other options documenting that it
might would still seem like the best option after just not using
__GFP_RETRY_MAYFAIL with vmalloc.


