Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A218CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6B66B0005; Mon, 25 May 2026 15:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F606B0088; Mon, 25 May 2026 15:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637346B008A; Mon, 25 May 2026 15:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED6B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:43:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 023991C0D32
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:43:36 +0000 (UTC)
X-FDA: 84806966874.17.6DBE149
Received: from flow-c6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1084A1A0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:43:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 4Mur35";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=sViDS8HA;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779738215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYZqWDWmyjtutgvRJcqr8YK9g0zs3aP+mve8YH79Xw0=;
	b=bAI91kZOrvwdoGIUX6/F5LXkAVhbrh+s8iFNY+yV72h/lAzUWqK5UuTGgNuZdLctQVeQaj
	FZaPLybBtppZOisD47nMaDzFVE8/MnL+VuPKR9M51PcE/U3jbnHKaxzi5ScESnUmbiMAz7
	8JUSkAdj9gN7xfVQAzGCuR+R/JTqHO4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 4Mur35";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=sViDS8HA;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779738215; a=rsa-sha256;
	cv=none;
	b=x4QlQFsdSBoqlWw4ZU9ZqsHdvtFJZ1XHT32K2D1kjaeNR7DKgST1w5Fu0QzDUADiVQzLKl
	JpyMxy4ZSJ0rYE/O1jy504MMTbn9WFP75tlUCb4A5CYLC+3CzKzNop9It3bPWvoinDXgLV
	SqVrG69t75EgifowsmdjzJ6MQ6jXRnA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id B332B13007A6;
	Mon, 25 May 2026 15:43:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 25 May 2026 15:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779738212; x=
	1779745412; bh=eYZqWDWmyjtutgvRJcqr8YK9g0zs3aP+mve8YH79Xw0=; b=C
	4Mur35zTAbdD2IH43kVpVnAr6/c+7yOk/l7RaxWV7gUuKK0LNc012SvoYkL1W084
	3l5W+uvWNRqm5fhQkmt7O8t0iOvfRVp5c7hsHQHpE6Qh9FSZ/MEoPjx96aKk3AkE
	ssHYiwNmq1SEAVqnFbP0efBZxyldRCmC8s5Zl+tfQZ8WGuOzTI6yGE2h/vgSae7k
	mH4yLwNBGC7Rcf2oBc4LwvH9yTSphL11RFVYaRK4lx8Q1UmZQghLA8nEnHZAWaWf
	ANbAc/pq4iTpbnf6rJyZNkH2dmzPXLX09kCmIN9z+S/jXs+v1Y9/03JjxJgLlD/P
	VACidMDqSxRwBY//QEiLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779738212; x=1779745412; bh=eYZqWDWmyjtutgvRJcqr8YK9g0zs3aP+mve
	8YH79Xw0=; b=sViDS8HAC4PUJSq+rQLyeLUU8K1RBZxtExi2wq9BmqnqlgPgwyN
	A24DJP5LDnGg1XLYHaPLLcTmeOs9GGABxvDEts7fRHt2Cr4GzkPgcFXPC0/4z6rU
	S7MZLXXm9hUbWS/42u9bwfyccWDh5aqvzRRQFgkyXQ4N4ZIarTL88AlaJ88AS1PY
	LUhejk7h5TE7vhxge3p0FZMOlitRcZsFQTiKLqUlqfBiSXLETziIYFAXJmmwI7Sd
	DxnDbdMGt9z7apzpgLqymuEckeKuzE+TUb2C7cGXwaQClZF4CFliiAtp2+KnzRwy
	v9H84aLObrCHOxPeV9DArTRarjdVgpP6vkQ==
X-ME-Sender: <xms:Y6YUaipClrAJ8uJDR42SfSGS26hZSRBEPmfiDPDTce1H4j1lOv6VjQ>
    <xme:Y6YUapBwgZ821jjjbBe2VKkhReoLXtF_9ma9NNvoktqa1974baqEE2VtYpz2gorfX
    5JjcKdLE51LuAPXiwcWvcMvFxsvD6uVhK-jQU_OfE5RfKAxOOBtY88>
X-ME-Received: <xmr:Y6YUaheTNXu-YOC1yxulv5MrAXBFKOj4V6N8TttkUK-CbcGrf5Cmi-ODIUlOyw>
X-ME-Proxy-Cause: dmFkZTGngrPU8UnqgtZHBi2y4I4SmyZVOKDVY9/WQa8xOMHvTiQ9LJMMNTiLiBDkUTCnEb
    VmSZ0YH/NriLI6FeprGFh0FO2pN0fiL5RqhghH5nywUkn6bjGacjYJJo3Cei5tQxKfTyRk
    znk0VH0r3YdzTv38dyn04gsnUUZy5ILD6NFuKJO6eVTQADMTFq2bevs1uTCjhyveT7jM30
    y5wq28mw5I0yWm965Y3QDl2LcU6F4ztQfJCBam49DHPmA17AqsoHeyvSkoYi7mmDv04bir
    9qsX+ty+9nymwEGBpfIhsRiomOXpjmW8fBCDJTRxzSlpkO3BAb1yO1FTBnmN62zB7n3dCy
    +aqI1PIGiVpWUOKlMua6wqJfJZ3pKZazyu6GdRFuFYe04jJya3EtT+8qzvODERAt9Xr67A
    LyKEejtEHrJwvpmxTo826djH+4IlpOcQ+qWk+1pl5CIFNgGpaXHCfH09gGVYVoP8q5iR7s
    uvJBsCojis9FDdA5X+cKIAVLNYGwThfa64G5lZlqDBL2cRt1LicIU1gF+B0FfkliYnkQ7P
    cvbwqXazG9g490YMUzuTeRY0LTBh9x+fBwH9dOkG7Ol0zG9sF9HcblH4iyLcKUig45Vdep
    1QrMBKdiU+uAhtKZ4aAfF8DLYc3yfDZ2L7gxGx78FDAtDqrATaYgs/0xxH3w
X-ME-Proxy: <xmx:Y6YUamdUCTt7fnRYY1r_x2Okc3-Nb-VWlcnMljgq5J1VXLBLADs3MA>
    <xmx:Y6YUavP4yHvqbcJLMkazD0udv9gZugM7IOSYpKqj2kjKB9Dsl6Qvxw>
    <xmx:Y6YUanoxnCds8pQk1NO57YCbE-pcWn98OApZhhZgxwKYuXkqVXA63A>
    <xmx:Y6YUamWU-whlKbA8ZzMZjVrlSDufg11xavmpSu2i8Q8fF2cq_XIVsQ>
    <xmx:ZKYUalJW4HxZxn7Y43nNwQCuCQOb6PT0GdqWwOlWIFLym8SBXKKhw2uV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 15:43:31 -0400 (EDT)
Date: Mon, 25 May 2026 20:43:30 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 03/14] mm: rename uffd-wp PTE accessors to uffd
Message-ID: <ahSlqQCqrxGsQS4W@thinkstation>
References: <20260525113737.1942478-4-kas@kernel.org>
 <20260525120513.C51E91F00A3A@smtp.kernel.org>
 <ahRf00RTI4_0Puux@thinkstation>
 <20260525123108.0b66d07c4be97dab3536dfde@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525123108.0b66d07c4be97dab3536dfde@linux-foundation.org>
X-Stat-Signature: fb3ybq6ywofkx35a5tjprkss3phorx95
X-Rspamd-Queue-Id: 1084A1A0002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779738214-340664
X-HE-Meta: U2FsdGVkX1/6NDdCwoISGxoWpsJD8n6i4Muw/HyPDBYNLMXg8WLlUE9a++svOzcDnVfm9jooz0oPC1xfDDwuTdfzw3YL/WRv3NA8HF1YSvKPAzWpV1b1YImtxZjw91MbbxHAsDmr7pZd7T9MbFmrkBAQU63gAbqLv2HyisDdqNl+1lYPKm7EVEYszhaW4Q0ItlnAbIh0RsAPPQyEiRzrl03mTjn+LiuG1lxSge09C9GEbroedNV1ToNcqFo8t2pw0LxRWAKu7AAc6Fo8xoMX4WZ9omZoeoF9o5LPJnl049wJ/SEUaU2EUm0CStAXo4bTASzvZwbFPAy1/4q92tMndxaMT60En9Cj7f9z/0dz0DoAOCBOH7BVLJqPrhwBLp6likHGInXpaYSAGkRCyxrJfaB0FocAMjy00O9ygkk8Hxp3Z+2hozOoM8a2O3jO84beXF2kjoXkM746eH/XTAc0/plKxf2CLy2h7c1fwGHl4sbGLjvSQT4+Ue6Y+TSUoQQdO9T4P8+HuCS4kOhY+IZR2Wb+D/GLdNE6NroB7JBqjObrT2kzjRKVMFx+ZxpgdzDXIp/Ahp+WTHI3eW4QZlfBQtArrBpUDxzdQshGLuAQ0o/Vy4hODENclMrEEnTDugxVeuNguz9SQnySvqAzXGGsZnzhlFddzumpxkY356GoNIJi6Cxttnap0P/m9PYhgSo7W5V7Jh6Y6TLxNmYckVHe29yenlW4uQc/36rcY6JEcCsVj0x7/OQxqobWd7eelGT1+V5nBHx/iIZXE3xKsPRVDaX6Pbu7gKXphzPRy9tTpOUpiFymAL+C6FFVvxvfRc6xK7aegN6TNHl8RfC+Q+ybLCtcx0qgIZsRBibDd/b/pG64f359aWHQmi7tQiuYpEFQfU3pc9FI2PQkdOYqGp+ua/nRoKHiEHn+8teqYj0aJnsaDzmxxk6pZq0RwQ2G2X2WwOVuB055zdcmsNZP/eO
 kz32WoP6
 Im8vdkBtph64b5AHPEMpsbHqSgdDRfPHvBpv4kyBtipMyK9M1XdPn2nblcapLlBE8kBNyh/qPXY5B1NQFtTPkKceKCljEpelyd4gJQs9mqAbuuQWuZuqOexX2vK1UAIQzDfMsJharojEth0t+whAn00V+dc5G6TlNfcoamYXgY2Icj+YJmhxtPO08OADR/lfOAsp/schRyE1AwnQSa4v6TVnWKck1ZRJOe2tU/HZjvctheQzTGzkiUHSC1n/iqYOdZ8xd19oTLltvFmdbhMWS0g8/Uo2unZlayaXAJM7pCbQZBnRB7PV5mc+ORGbjaq0A8pcya1CLluNvm6C0Wlf90lOhElDgqNgDxsJrrYT6O3tUASXxhOpeHOa+XxrSJVCW9bk1livOatjHhHBJ19lAuWSxZ24oWp391Zsfoe7lkM+W/Yx3F0WPzIYKsODI4ROSaeCSYSrrYgpENPTMfdjCwNBlIBY21MSYI8+FIroj2cNOnTNThquYurLAR5WRBSEnGgyzK3IUbjRNMSRYiWSqisPGjdxJBTrZZ/N1W2EDtJdlK718DAqPxALeO0zE+dh5sKQeVgWrUv5MK3ADNTrv8kfL9cQ+/iFrvcsnTKm0+OZp6Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:31:08PM -0700, Andrew Morton wrote:
> On Mon, 25 May 2026 15:43:32 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > To: sashiko-reviews@lists.linux.dev
> 
> hm.  What's this.

kvm@ folks opted-in for getting review feedback by mail for patchsets
sent to the list. I've replied to all recipients of the patchset not
only to kvm@.

> Sashiko seems to have been useful this time around.

Yeah, better than last time.

> > Confirmed and pre-existing ... Will address in a separate
> > patch on top of this series.
> 
> There are quite a few like this.  Would it be better to address these
> existing issues immediately then base the new feature-add on top?

Fair enough. Will prepare patches this week.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

