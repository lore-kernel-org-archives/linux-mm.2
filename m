Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD58C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9D06B008C; Mon, 24 Aug 2026 08:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1996B0095; Mon, 24 Aug 2026 08:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD72F6B00A7; Mon, 24 Aug 2026 08:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3246B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:38:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 106D8120121
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:38:01 +0000 (UTC)
X-FDA: 85136115162.07.0C82159
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id 23B0D1A0005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:37:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S JOBuqo";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Y0T5/pTM";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787575079;
	b=ywO7yDgKL3Rx9tBewi4coScvM/Vjd6NH6s0cXQt7ECM8z7rxxhBbtBsxTCCxRyWsSQEQPB
	132nGz57Wpw1giKeZD6FBZ3Zlrpx7hH3q0k4mun5GLyWm2nqEVGTxWZlTjswrr7CXQzU+B
	qCBfhIxs20+OYtFTphNsacF4qpFag/I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S JOBuqo";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Y0T5/pTM";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787575079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+ZXrHhOcBNBIWSTKX8h/D+gSOatS4LTJk6DxU43bvs=;
	b=VxrJ92KtiLZz3uzduJC4XvCM5jDX92CUmH3+U+D26ua83NKM3cH5Ew5WZMyFGQkHbHa421
	7EwtQHCl3r0t/SzwTfxEnvjFiE1B6bXt6Ub3MrlkzFXUq3MoXTYaXcInlACPXr4lzd7zkr
	MKgQa0OWHwOtUlg4cPFqY7uGWmy3/Fc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id ACCAF1380293;
	Mon, 24 Aug 2026 08:37:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 24 Aug 2026 08:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787575078; x=
	1787582278; bh=4+ZXrHhOcBNBIWSTKX8h/D+gSOatS4LTJk6DxU43bvs=; b=S
	JOBuqoTpRZnoUcj18paDGTJxmqQMHeGAO5tqVOMb66NOsjBsqN0usyDojsqHFm8o
	YwhyH8Qge/ybjiXY0sSwgbOXtG0A+yk6xGopSvJyVUugG6tfD9dpGLBOgVrIwuHa
	tT3S/LPCJThrY5PEDkrjeOPNkyfM9plZ3H5R1dYxxnph67zJCb6TgGoatk7jjNJl
	ZTFj8yrOz39JuAVZO0+XNfTybA/KLxtq/o7U2k4Sbd72q+HWV3VFbEzxj6HsDbSu
	Kb3KeFQJe300YRMCVnbDbvI3YSy9RkzB+NIaJmMwQMMgBiqPELjbY2DuAIkxh4xj
	npFAnGnfpJQtdoLL9uItA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787575078; x=1787582278; bh=4+ZXrHhOcBNBIWSTKX8h/D+gSOatS4LTJk6
	DxU43bvs=; b=Y0T5/pTMB8VJ8mAceiSRNanYWt5zXnC43h3jCMJ9QAWf04l2swi
	pD5ddTN3S+Nw1F5JW+8vuLVAorMf8hW1spoGbvc1O8Gwgot5R5z6P6J9nlUbmFG7
	/1hv9zWTuy5ZASLdgxjfiZo/OpS85uzxwTcUAXIokMhS5v0ikDpS8JNm27I8cW8Z
	UBKnsm+/NlfubBzl3AKjtZqVvNqAaNC1UUdg8Umse3u15hFTGUV0hbICcG9dUyFc
	GLlYFnGREr6vb5eH1q0AylyxcPt0kh3yhmurEJ/mQZHJ68y4hLKJW39T1q/msfwy
	CiryKQAfbho+uBRuEJLMm/BK1/MwPB7AeIA==
X-ME-Sender: <xms:JjuMauxO6FySxIcOaHs8arOohEaT0-DcSVy5FI2jB-iQtE_makpRZg>
    <xme:JjuMaqsadM63Co14tbsXNwp4z8utQUMx6Nm32_8qCg_8jEK18Voch4B4N2P94_jk1
    xY2Fu-W8Z2tRdqvHghcDv0SrgI8jXoSM_QEc9VtHd5ERvLDI_oc1dBx>
X-ME-Received: <xmr:JjuMahyTa8PTHf-d_XN6m8oBoE4uI8fSJLDXQFO4Zj16Ww4D_YWd4upLLy4>
X-ME-Proxy-Cause: dmFkZTFatED5oZ77MZ22tmOlCD7GXKUCkzazb9gE5N4jgJhO01yYiclBrAnEbUBwSMdDoc
    xpS8o1ggZwKBr0QTMYS32p4YvobQag58DBIKQmfASsSYKFAQkV56vf0rfC+M5T/OAxyf9+
    0BZZrbk1y3cjZ7YKuDxC1b7JW+tNrUw6zPDKlukbK3F1Ex8Ss+kandwlYX1KARtnat28hK
    +dtQLf49G4LcemSGTffDvkSTWzHV3mDceKuVvXIWrRZx5JR0WlkLGTn9wDNBBZi/llCEgY
    dyPJRCsKQyE+/7S/K1X1tfD5wJhh2tcYYfhhBh9LbMoMvU6qhEbhxGy/O6t5DGZuoCPFR8
    yte7bPjdZw6iZbXU1WqcKwdEQD+O45PZpWtLMr2N2TfP9kDgMEcFkVGBIQCGc4hZghM1hx
    HB6bGHOO1H3WwR8Igy6WL0tBYTv2HEkz3LZkl/Uu28pT5K5aekNMDVy6452N2FOOQSl99T
    pTQg0PGbhGIw1sz6c3kzH7JbbE+CUGVqMcgkMRsqa8VkM0K4ul76/czBecME8fJQlNok2e
    VOnYxVTTGDk9pI8UG4hofchPXLr85+xVdD/TArfiawIBOJNLbNPW7C8IdUjB2Ebgv/ApYq
    yvyePaUH7xTtILMBfO2o0Q+CTU9+OpD6r6t/zIEJaG8WKE7p9Jdnxbb2XkLA
X-ME-Proxy: <xmx:JjuMakjyc-2lgDWCP_lubdQSINTnPd2c7mC3kuta_Tj3w4HCQixyCg>
    <xmx:JjuMavZE-hmQOIB3IlqJr7s_7f2F7PxPD-3h2S0jrAUGVP7n_9YcIQ>
    <xmx:JjuMatib15jvUIdzdqXUBi8FczOeLG2jOwd_rCWLD5tMHYsbTPydMw>
    <xmx:JjuMam99b79C06mkp61kQLmt3F1GM_CkeV-aY-YV-zYhcOTJP-08Mg>
    <xmx:JjuMagJMmNs3FIFLkKCEOfVwULclr412rRPHM0btNEi_XdxgVHRK83jj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 08:37:57 -0400 (EDT)
Date: Mon, 24 Aug 2026 13:37:56 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 12/57] mm/collapse: allocate a destination per
 candidate
Message-ID: <aow636Xhrof8hj38@thinkstation>
References: <20260816224609.308019-13-kirill@shutemov.name>
 <20260824112005.63097-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824112005.63097-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23B0D1A0005
X-Stat-Signature: ohmnft5s6fq53t79cuj4xy9opucwrjbx
X-HE-Tag: 1787575078-102844
X-HE-Meta: U2FsdGVkX19drjw1LLf7FeE8y4f40ELVWJR8WRFido7eBC7XXnfjCUO0be504tmFEiucw8vAbnIBV7KNFBU+V6wDSQnnUuPeYrNhZR43YDP/QxkR0UXOvErxihI879X1wf8WTMBIzYBpgjxCelkiGD5G5oS1wHUeyWFmPTIvO/GMA+J+2ijCRcrDSs3oxOZ3MiI4ey4PdwgEnIywjFyXOAOyUsVB6vqWkaLrYZO/cimVvpk/mNQ3b2Wjypx+kDBIuBTTGF/01mYA/gFnrUfBZBg+WYhhPkYAEmQTON2Z0S9/9cYzgl+UMvuObHP6DIvbnkJHqoel3NBtbVFEqDi3DIoSFfqs+EnmI5xRshY0mvtM/VG4PG/3zB7+rklg+U6uXRQLNEHmhFCNm5Cwp/kWTZDgmsxJMHh8eOfvYn188Cjs2KpbEZfd4NIhK1broFwl8ACV1rhIAmC1fcbaovGky7ZZwZl3bdsY0oKKmeFKcMej+EzwB8RlfE7wK2E3EO+ocAgXSpppRr+bUoWiDVTcD2FX7RP0uw4s1bjO9eIOGuL513242qa0bX/ZsB5usb/IzXqh0bbGWaZK6lX0WpH3nfsy1PuzTSvc4lRmgwfSQBiYUM9Vx4DIJ7sg47UnRVYECEfsukT23vALv9v+Usx9cvg4il4aYMDBOQKPoQmfWc/SBr47gziisQYTeCB54nhkMtWbjptsSssHA/8FP2S9gFo6qZo8tg2kTp7XpZzqShzZ/3YpiNUILFdAUZwmq0IWVNBFhflWxmZSZMUlwEvs64WF4IKFRI/lej+zPpOhIGH8aPShHbMy6XCYq1Zwn6kq0RV0c6SdvKmT9mxJK4E/HBUT6SDQ7jh+7gzUEWw4rnQkDKYaRnSIZw/zKipny6g+4nLILciOaKBEjMrnwOwPWVe/j69HPY2I+6hxG8VERp62c2DoF1S268UdgIpGMEumQMIILszjM486mIGzizD
 gemtPTIE
 9gI0UnaaTov7zsK/iIFMcJu/2LtXtEAVv+azRyqssqA7wGvWF35rxVEgNRU7K9o+kKXJVGQ2HVhXSCdLw4YCvRYt5wbb3LdWijO4HeMQUtWh2S0pY1PjQld6AWRweSp7FS/FD3ACHcCsBrMPt4Lv0Ck3qBjuUpSrchtTUpNAYp2seD+lJn22Eejr1w7AXH/Jn3TMaAFSmh8onnAOaAPxfgyMNfJEzqFtwMmAt9Jx3cpn5lyZDkve61ADPnAPuuhKZLrDEcR+fXRFpyJZuZ9DZYFYbknqYM3PIciQAHm9PzOizA3+d9oKVDgRHfJ5Ik57kBS1h1rKgQa7JmrYxLmagsqZj4H7qZl3yBzw8BuS6k2icDmB/u5DX2sJlD6OB7+9wAR8YrbpeipajwPumTeS87aSD33jF7XHmn+Yr+wheS0/pF5WS5FUzOAdMNCo1mZmw22Nz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:20:05PM +0800, Lance Yang wrote:
> >+	if (unlikely(mem_cgroup_charge(folio, mm, gfp)) ||
> >+	    folio_memcg_alloc_deferred(folio)) {
> 
> One small nit: folio_memcg_alloc_deferred() passes GFP_KERNEL to the
> deferred_split_lru allocation.

...

> This only affects calls that find the metadata missing; after it has been
> installed, later calls take the fast branch. Still, it bypasses the gfp
> with direct reclaim stripped for the freeze window. Could
> folio_memcg_alloc_deferred() take that gfp here?

Right. Passing down gfp is the right thing to do here.

Thanks, will fix.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

