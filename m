Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3CF606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=jZjDJKKi;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=LVQmvr8S
Received: by kanga.kvack.org (Postfix)
	id E59EF6B05C3; Thu, 29 Oct 2026 10:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31326B05C4; Thu, 29 Oct 2026 10:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21176B05C5; Thu, 29 Oct 2026 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5166B05C3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33F6B1A02B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:13 +0000 (UTC)
X-FDA: 85375933986.18.16FBFFB
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf20.hostedemail.com (Postfix) with ESMTP id 26FB51C0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j ZjDJKK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LVQmvr8S;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvmHhBLGohXx75lnYm8/9/6SdurdyYB9PRQDupCTi6w=;
	b=IZ1qHMN5dyGsN1OEwhfgr1gnnjEjeFS+6NXHaWmc5Uzkz+bB+46g63illVmTKTin9c5a/k
	v8Ek98DRtOSA+/q9DVGtkmbVeai+D1Q+0MeEiraIAuwlXHifXfws7yFpcgtTMVcIZFIcMy
	c9dDd28OZKw3WLBzmdk/E8rUTAYo3Qo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j ZjDJKK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LVQmvr8S;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285051;
	b=STr54g2eaDxyfC25jItJ2Tavar0vpUYHX4Ni99FdzOr2r0av38t+XO6W91jWk/txon9nmS
	U6ilLlziNxcc7s3r73KZJNKYka4L7LW9GW9Wc9CCFbzcOn3ClDPIhpJn+u10EITj9VxlOp
	YFGVszr7o+71k9iWz73mCWPSrZIJjHA=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 6FC3D13020FF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 29 Oct 2026 10:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793285046; x=
	1793292246; bh=BvmHhBLGohXx75lnYm8/9/6SdurdyYB9PRQDupCTi6w=; b=j
	ZjDJKKiyga4Cevqxjtfso81DEsOTxV/uhlEAOFzmtz0CyW4mt46lOfePwuK0F3N0
	TiF8k+bZo7QIGO8xB2Ab5ONpyMrFsW5klrCKtgyCQqao6BXVHxD6g1mUZBt5dBht
	/fnH6X7Vcb1K8dfovVWQxPa1yCRacnVPh/2y/Jz4l+6dDsLYCReX6SQzU0afmjMX
	xvFkn3vQuuLO7imA8tnV5aqCXRiMPrCbPqKO3W03HjCXRpZKSYhiKyb0l+xEqc2z
	xGrzLRaCXvNj0Woo1AMWqEFIqN/eilGjXL9+QmtyB62N6ed+BBgy8S3qKVHLAAXN
	z9xj+A/rdOocUrGUs/bCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793285046; x=1793292246; bh=BvmHhBLGohXx75lnYm8/9/6SdurdyYB9PRQ
	DupCTi6w=; b=LVQmvr8SFga7nNClFP3wH1vEsVGgAvsneoKcKk7SXjpyslOEX57
	CtCBlAgOdRlcXcZ/utgBP51U4eH1VUNyWbSCn6U/SqJ7WZItM+APBbplZk8KkChm
	H9+LFSHN+dQ2hoaPKd83JmzCC+1lXcnp0Q2ywDaiSu2XBvSp9kq7p0MhAXSBuOVi
	izP7SfmavUVRqzvFsX5lNBVET/pbghF7/Uv2vmJ+Me2r8AcrKC931UgaCOgj0ZpR
	kPEqpw0n0xlXatREcDf7CJTjHAcpetn+tPLGRCFVeyb9x6dWi/qyP7WIaqE/xUK2
	tndO6wdvTsbEd3Ts4N0RgITBIAZ2KQ8Dn1A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793285046; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:YpbPKeRwkROOSC2CytgxGLl/PuLNI7gTpIjQLhKrkTXUxpd
	rK3aoU9RYAL2ygEKbFMgrcxCZ6QYAQapEh4pvnPYMeVwND7TgKczsE0os3vSKCML
	Y0LTPQTqxqEmOnacQds3a0PpZvnqHKMRZh4XrqTyizarOcJ3wo42wryxIrARxCIe
	m7kkk7fMy3eINqeA2zAjpgXVmbddc7JjC4U7tNUGsCqYBtwA0gJEdNjvXzIliIk+
	eKzHDH2JUXnHiZ+eICyrmqgD8Y4ur97KUSsmpTnYti5uMbe8IslWutGupMilpbdr
	0QxvljsXYEbDj7Dq9wT1lUpmP9azdEWxQ6WTx8A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:qCKTloRUxu+KzFqnD2XeGlknVMYHZ3cPjnHt18V9dN4=:U8YSMlkiRiLYOyy3PeK4a5B8iRE6kJknDcsnh416pZc=;
X-ME-Sender: <xms:tVvjameR_5bxMjbvLRCRYU_cngleFesyNtYxk59Zk_oUlnhzVr3Y9w>
    <xme:tVvjah4OxNeceIn2bqlFMWLEh10wqIOp2bMbquHAv3JZoObyK6uI5zZ2wtUmZoDDm
    9pWSaG1EBbHIJ2K3tZfwkYAQXoRxFZmsa-Z9vn15ZtDJ_qRZNhcj2I>
X-ME-Received: <xmr:tVvjaq-nzwdVWnypXv8i3BONQtkCdWnAxasEIxn6hiJ-vFT9yntSmwtg29Y>
X-ME-Proxy-Cause: dmFkZTEyzILTy3ijUhQELdRUt+dULQWXMH3d37b3A/IMbT+rH32qhbXyiYv5MAyrfFVj5W
    hCqZUSC0FonhS7bC0Z9vJlqcbgXK5cFT6hUow9tIeZmDIRtpk28jvxEzlw0iqRZRuVXHI2
    yiU+SqbbfrSAUIZe1Zk1rhyIilsT3cdQCjQZGjSDYvTQnFY1/2Ep5yrkcVFI7Kpv1EuYaF
    MdXJkm7F35XfAMKXrAFrML4219rvWN0j3+/iGdzK2tkT7rCHBfpEtQoaSyh6EK5lwC1zst
    Rg6wgKhxvJdPnQKPzN2Zu4nBKp1kLm+dHkMmj9CEo+MIaGrTiSy63JBd66Uh0gHpPYBzpC
    dKVMCaQ/JfsREN9ztml5nthTteEQgCPxpp/85NKFHUCVFJzYpcPyvCnEw2HKsYq2uUXY4m
    srEKKAI6pIefzGujDbBHLoUwqeRjS+X0fDx/Fvyl/5tQi7rCONZliERQRIlnyvZcfUa3pE
    ezvB676aYzp2AvddYQ7O0+gKiPqHb9GswxcPR3i8QON6DtPkgeMAroxNSZwdhX6SE9tE9a
    pH8/McdZfeZT3CW2IWpPjdhiDarcWX3cwXKxARu/yI29LKPl3nFTKj9mWzpsXO0vUOmJBg
    rAbTn3i18WU4mtza/ib1CH83Y95F3byPZ4W6BeYbOYo0zA825oXli4PrMLKg
X-ME-Proxy: <xmx:tVvjajyV1JREAYbfj9We_kHNxZy__oIxXMOBGtVhk8en1t8qT6qFwA>
    <xmx:tVvjapHPU_wspVl2XD_smnL4Q7COVEOUwdYR1eTIU7IPRVwRivCxLw>
    <xmx:tVvjauMluvSlj3DeieWqjjzq-JBjwFq0UsWDrL-AlCxq3BbZVH3ZSQ>
    <xmx:tVvjaocaaI_ncLkEghvAXxylzAyU4EShXDwh7oxxaNGbxYVtyJLp9w>
    <xmx:tlvjasmxmFIj6TvazUUDo0D1qK0YHdBIfVjZ_hEuUz0WDpeT7hP3AQbW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 10:44:05 -0400 (EDT)
Date: Thu, 29 Oct 2026 14:44:04 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm/sparse: simplify the vmemmap alignment check
Message-ID: <auNbTHXp4o_Dqww4@thinkstation>
References: <20261029134521.62146-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029134521.62146-1-kaitao.cheng@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26FB51C0006
X-Stat-Signature: 1mkmrtgqbn6w3ah7xnrgaddt67jtubd7
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793285050-599798
X-HE-Meta: U2FsdGVkX1+B0tqIw8IiOChY+3z/Yc0FX1w9cmQFiIZ0uKbXqDV4IZyy8ASxlsXGh6ZMLJ5QiGLRsEWWKBhzf+6/0TLRnnBQR/MNvPSY2nNT/R7O4pqchPzk3dQLsZMxcwNs49scXEOp6CRvC+MvuxetbrxjfZH0g6+my2QmJ/Ql7Q1BovBs2udibyvI3mneJ8QP6o/Y74NjJGiQglHA1eepY+qajJOXZN4Rv2vFtjsxx2yAlXWcmXQNOorc0DPgzvEEIGDkgmAUkUlMwCU0UVgGLA87zrRskUmgMhOaZRWrrDeFBzBVb4UzcTt4LE3stYLhnutUxmMhGJbEW7J7A/x5339IB0DfAHxDanRhW6taRKZ6Un6YdzWX+GVn7kCcbmVtiv6IuUYrmau7FBf+eBU6KLY6ej4AOdUad2MFWpr+afyVyqov50HWDlXlC+gC3C9sSxnUtUElhH3fx96FYnLDrS4YdtukvdkNd5n/qcpDgWPbNYIGiOXTUxZSESyAn4kmvzuGhyHHjxUl8b2ST7TUo2jvFZFGejkA/56IKZtB2ITCgYGG+g1oMPzC6b2GOhfZkZaNp3hm3QF3DjUPF/Rz2+HQUf+7hrGn6f+kkB8sWsSvK4tmC4WYNealsdTh1SQyQMsrdpaJMUuJSroZ5rYXSrNpQSuT+RR6DU05bEnd5KagMuc0PbHG5b+RGwD5EIXGdl7PMf9oPFmXvJpx7KOqGWSt0n5swXsXxc02Bo8jLPpm7HJd+DHXkgaOCW8zDwmgcI/FiWykOleyR3FPodO+7Qe5TXssS4hOIhDZR1PkZoRoVM+UxN1pUf/qt55kOoN+NWN340saKBXKBGPwD3SNQ2ff1p/SKYDEKdD0TuSxH2OAhdtD9FLbpxTy/FlAmT19NIbfW5HvB0+j9Ql8cCEuF6CaBJBgm1lNgVPXi9mmqQyEr3iscsGVMoi+XTGjLo+JtnBMibhazcKVUsz
 RIRBiNcL
 CwMpak+javy+LDe/KaU8lfhjR6o+iLwE6nqykkTwbBD4lNPMxXj2lwC0ZywhF+Q7x8o1TNVSHqdrzEq4w2bggTtOJ7SlyIsbCRkgYJVgNyt5bl3xX8lCv/ue507tf2LQD1t6pvmRcWKKrrPpVz3uRSJX0BbY7L4cVxHigl6/M8VdQs4R/hlv3Es0gQKImeBQ3tUCT1YVh9T4MZVeht/2ejhUPABl+MTrdbMptpkz4JjsdiSIyPKNdHwMekttVgii67c2QU2w6J7hlbA/oktG6SqhkCOqXCeG9X94fwhde+9dkzV3AXuHzIcTDF66FkBodbCQq/nZg+x4NkvN9U3Ix98ylCVI7LiPHqRscdphUtozsqya1c4c5N+gqYwMW/X70gb6KLV/rCvMzqHuwmk9nDNfZ8uJi6cWt3ShqCVFWyptqHLlRZO1lS9kLFDuuwYdXcR9PdrAnQQ9Pg1ytYgONXP3vq22roPn3ebPL//XJADzivRH3EJQaogmKIE4hpVdt/Gbw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 09:45:21PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> sparse_init() is called only once during boot, and the vmemmap alignment
> check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
> VM_WARN_ON() here.

Okay, that's true. But who cares. __init section will be freed anyway.
I don't see downside in current code.

> Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
> preserving short-circuit evaluation.

Why? It only got harder to read, no?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

