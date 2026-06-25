Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1DECDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57336B0088; Wed, 24 Jun 2026 23:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D073C6B008A; Wed, 24 Jun 2026 23:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF83E6B0092; Wed, 24 Jun 2026 23:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960D76B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:09:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 232041C5EF4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:09:52 +0000 (UTC)
X-FDA: 84916955424.22.647DC6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D7BC80006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:09:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GHLdobnr;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782356990;
	b=ysjkqax/G8KtPF+VvgbBCj3fGSQYEeOwXoQzXiORfmv5FbZT98lETzJ1W3LIyXpKRHp+kH
	oNm6xfaYiQkdC+BtkYykm6CVFvdN0m6pOD19Di5+AocDtXGzeGDvX4mjbJJVlMoblor9HG
	4br5X/QIzMnd+n8/lkGqdXkynlmK910=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782356990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0veS0g5fF+whbLGepad1n2C9+nnzZ0GFYK9TZo8pw8=;
	b=PwaJnIvJmqA9zv/jwkvPUVaadlVW4VZbf73yc+7mSiXoJXFgeZLnDAISMI6T7/pnoAGXC2
	OL6vO2pX1LBXSbs4vTvOJLlzmcWeLiaB8VerG28JmNE+JGr+RLWgIShcq4lPmvTTJlTZ9H
	xyRE7HrywaTGLSWXb/30xziPdApPUXw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GHLdobnr;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A194343624;
	Thu, 25 Jun 2026 03:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030CC1F000E9;
	Thu, 25 Jun 2026 03:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782356989;
	bh=l0veS0g5fF+whbLGepad1n2C9+nnzZ0GFYK9TZo8pw8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GHLdobnrwqEOu9mc/isAREnl7jRAbh5wy+vtnmCxEZJtPqlEdTfp25iqb9geOaHyQ
	 TJvrO7dvB4c7xAjQ0V18KgLjpQUWJvTk+CLLPUM3iL/h0NJVG3iY4DQM28F1v2+0fb
	 yONKAIo9ZFObi3fzZXkfmrLsv2wMIBgfIqgauCB8=
Date: Wed, 24 Jun 2026 20:09:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui
 Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v3] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-Id: <20260624200948.d4d09c02540db0099e260c00@linux-foundation.org>
In-Reply-To: <20260625024019.838786-1-hui.zhu@linux.dev>
References: <20260625024019.838786-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D7BC80006
X-Stat-Signature: t8tocjtb1xjdqknm3ap4955k77krjgux
X-HE-Tag: 1782356990-988956
X-HE-Meta: U2FsdGVkX19v+jgs7SQRhMQK6fUcLq96XvoDa3bFD+emcXHXqBLtctt1/hOR7wI+S/m/pLEUF/qJOkNWuHHrCfREixW04NI76klp3Jhip+sutR6kVDQVl87vBReIvRPnDTgmVG/goW6ZhtFY2gPc2B9nYAyGVW5tHluGHe9GDslM1ynbi2VCvShRoxrrS6BIFc4tKMfzSW9g0PmzAnnZhbO/iMxdk/fji5r/GH2vQPw/F1bW5hARGAJX0sFJBCeSKOzb55FPQ/kzHWXZT2wbPqFkUQQzYFun4qT76o9r87EREkwMhYuh8uF6u27lKY9ZUjhSWYKo/pxmX7MhXY96uF1BpkvNw79EUzLdz03EV1Wf+KLe7BpkPQUELg9Z7wR9ynzWUf2iQhuFX4Uy/bR2YG0T5mfRVWkNGma60oYgG/H1gWP7CNpg0Us0dMTL1glcqn89EjULEvldVvV+c9stttdNzw7ibX8m5zQd85hDCLo2C0vIeSMwumQJ6UYa+WnVJW5v+QfMBuPUlA+knjow3t7GVF0aS+fMK9tPU7iJgDPOEKhgO37aWVm6ToMIBH6DYM+/HwVK+98FLQDfzFjQQUExlAiPiRh3k0wslmoDfZ7T5HV5fVoE1dSgfcb+3QBU+uLO1tj9RU70NTLp+NeEg3HoKtDqfMYAOFxnpQi9yomRjDok6mjSnaItvnzHsZhiCb3o0V11UueBx6YYsJyst7vnAEh58GgpwhUM+Ckv0bqQYofG0l4yue7awe8P/14u6EbOUbur/UN4+gQ/cEU+WGWMvnrzIxDHyH20Y2lA/PTHi9jD7pdec1RnSj/J7c9LEsYZfKLClLF3rvITrgE/sLT6KxAdaxJI+vKZ4pFpBUz88XGyPDX6+aFY8uTCjz8rGkO3lNM+S3Lhcva4OMFk2jaLv8iKAX4whKWxzROrSC/WiPO//UuO3IPJ+reBToRfaWtwQ6l/aB2QPo+1iNG
 Z6pxAIo7
 cLZwq4ol/9ksyNqRHCeBV4DWM+MYBcnAT7SAXJknqLYZHjibaJEJ/3R4np+yDOsJ9AAfiocvgO9kpkfc56IhN8oNLuWzQh1ry2d/YZWiK/8guDOGban3d3cg6BG/PZPEoEyA296DFRjx4bnoW1nuLR4TxtnuKUIJPrI+W57lDKHCbd5aEgVLArqykIB4xGSDiAR/ljSAWhBkWj6aaBbNMwZmUF0RuKrGma8545Vcc6pEWXAzC+Vu0UANZjbOli78TizL69RuLvfon5frP87TEA+5DHSTF/YosIGUNU+q8lcRfw5dxAaOGGkSLwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 10:40:19 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id and zone id occupy fixed bit-ranges of page->flags that
> are set once at page init and never modified afterwards, so they can
> never overlap with the low PG_locked/PG_waiters bits touched by the
> folio lock path.
> 
> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> checks a by-value copy of the flags word, not the actual shared
> page->flags/folio->flags being modified concurrently, so it doesn't
> reliably assert anything about the real race. Move the assertion to
> page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
> flags is dereferenced directly from the page/folio.

Thanks.  Sashiko is worried about CONFIG_NUMA=n:
	https://sashiko.dev/#/patchset/20260625024019.838786-1-hui.zhu@linux.dev


I'm a bit surprised that these functions even exist on NUMA=n.  That we
don't have simply

#else
static inline int folio_nid(const struct folio *folio)
{
	return 0;
}
#endif

