Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B46FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 19:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CE96B0005; Sun, 26 Apr 2026 15:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F40E6B008A; Sun, 26 Apr 2026 15:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131936B008C; Sun, 26 Apr 2026 15:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0358A6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:54:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A51B405E5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:54:26 +0000 (UTC)
X-FDA: 84701758932.14.23357B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9A4840003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:54:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rp2Y7Zmj;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777233264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNtWwGmEhkrT7WalqGhI+SvhUXQY3XRF/vj/IJ9Aq+E=;
	b=7a11rbuZaU4jY87R3YOqj7ejDp8DU6JA4h6SgGnpzOe79u3lzon3X4Qr0VuhB1VqJSM5Xb
	X6c2QPKEyLBMqDhJNR3fJIeS53BE4ti9rDxE3kgU6fKZqH6zqlprtBGjFA991pPjmGksNf
	Pp1MlJMqznGuugOy/IlFR/TXer7X0tA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rp2Y7Zmj;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777233264; a=rsa-sha256;
	cv=none;
	b=1t8XNWj1l/9d6PInio4fU9ZnIh2ErrzlI8RbOItEiJ9bNEEVktySj694MyRBGKtNr0YeDM
	l9U30sD9s6CM/4qruew63nSMLyvW58Xps99UrPrEYIDlGq0oaYriQ19Yfmn8suqywl1gZ5
	v3lR3lb+QXh+j9X5Ka5LJi1tSsZws1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE8D943871;
	Sun, 26 Apr 2026 19:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88F3C2BCAF;
	Sun, 26 Apr 2026 19:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233263;
	bh=2+t0bSo3wG70KgHsJncoi/FDJXRJNptMIoE1v74zA8I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rp2Y7Zmj2dHc9UArOcwYWowJQ8wL5qBe9PYyZ86R9/kgcmunhNCvade1vNsLW3bCu
	 XfsUt3s9vHrnzI7Fqd3+hJ86TN8R77toJ4BhTMvg04xEPmUgkp+uKz+OekimhPaosx
	 UbzjpaxgPGGBHX55IHAq8lBaLfLtEclZwJAs7exQ=
Date: Sun, 26 Apr 2026 12:54:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/6] mm: Fix vmemmap optimization accounting and
 initialization
Message-Id: <20260426125422.f9fa79ec47db2e552d75e29b@linux-foundation.org>
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9A4840003
X-Rspamd-Server: rspam06
X-Stat-Signature: 1y7tdogauuxngs7w7ieiop1ginuubs8i
X-HE-Tag: 1777233264-250626
X-HE-Meta: U2FsdGVkX19dR1id3KuY699LT8lEBjhB8BiO0S9ZbWw6RNKA8Zj8MnFsRL1maT+GePp7h2DRN/BxXTVRxCag4HT3YkVhn8jVPZx71sPf1FF/E0+NxlwkVaPPMNoiZvOcyfyUx8mV24E6azgentShbcV2nxRIH+QP+yfsBhT3xdiFMrRlRawHdS0nGl2wsBU28Nd4GuHGzQxspFhihyus9amgvIdsN1QwHAytzVYTcq6rZcRoIcDx9Dhm+9LS6MTOdnsyidmAYXysYq0PSHZNjVqeCmT7CRRQfzcE/16lT2rahtB86JeIRnm4TwULuUGmbGRIqx0TdAw8YwsuKhhbArCbM1WLiQo/wd4UE2Qmiw99Ps2G8HH/k+Z+ROYfLcdHZJv0LqZLsMfGONOlAjSz3n5w8RjA3+FXnGmbBMGVCUJjypcqZgqpRTh95wNDrE3Bdzz0AupD3U5rsWXNIwz0jRREuVtnx90ZB3AKsV4hPjUZp+iGvlBvnNNfQavzfKi3bEzQRADm+ufMNuF8Fap1rM2Ic8VJZjMWdb6IsfEyRAVtGeB82wvGy1oZozxZ58m4lHjvKqopRJA5PS5sZt8oHX4JvV2cFcjYSNr+GfpnQ/FIgxSEAD5RRYRT8yb2ENJN/n3LIBT2dUKOkw4Ii6iC4djV4xU+gsOfNROk/5wYEuU47JV+ygEuBGq1Xh7k1BgmWNpLLze2m3uZEsH/w4qXvv37TF4I7eqTYqU3tEAL02UGUFi8z0fGPHz2HHG6ph8SAWkeoDFrgiFWDX7nzerbsqUNFMKXSZZ97SjmIhjJzt8rmmLuOuoReJNRnOXrWf0ccYFArmSV/Egv/8bSu/+hYPUhJ62Nq3zJ4sWPQYI9mHQfQCnApiqVA5/hsvrw83wgnqvBmWT/yKTGIcAgNe53gdWxP5iuXdWUIw8J6iDajo8l2aTaqevUxp4gKPrkANLfYAkYn+z3Qjc3MgK5mVJ
 YSZFg6Xe
 METAnmj/Isah/Zk2KZImXWL691dd8wT4qZS2TZ2zusAM/dU3rPUt123YXWISu4/krbMhjHDBWkl+i890hhNK11JTuwTIZh8h1Lye0zl0+QBIoVRJJWCJ12UIQ+BDhx5jEtQavVfL/n2ZV4puduWvjTAsgG4enACsMbyGcEdCqPXztZMD5hNWURETAYSKxThVGg44ihuFA9op2E2kzRrdLh6+ddR/AtnLfBH3xPBj0fVYyJpPg8iMEwwt9smvyIxtYXI6EAzqmhbR8sOxBe4WgtRQGhN1iEgDWXvtaV8fkMxhyrefLJsWEmDJT869zjR/DP1Jf5MNHaN6H7O8kKg1ex1T4OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 17:26:34 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The series fixes several bugs in vmemmap optimization, mainly around
> incorrect page accounting and memmap initialization in DAX and memory
> hotplug paths. It also fixes pageblock migratetype initialization and
> struct page initialization for ZONE_DEVICE compound pages.

Thanks.  I'm assuming that none of this is urgent, so there's no need
to fast-track any of these fixes into 7.1-rcX?

So the cc:stable patches will be offered to -stable maintainers after
7.2-rc1 is released?

Sashiko might have found another bug in there btw
	https://sashiko.dev/#/patchset/20260426092640.375967-1-songmuchun@bytedance.com

