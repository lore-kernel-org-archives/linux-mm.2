Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AF2C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D0A6B007B; Tue,  4 Aug 2026 19:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDC56B0088; Tue,  4 Aug 2026 19:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3126B008A; Tue,  4 Aug 2026 19:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE02B6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:12:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5666DC02F7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:12:08 +0000 (UTC)
X-FDA: 85065137136.28.65B5D93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9126B40002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:12:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qdlse2fh;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785885126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4QTWJQpnYCgvZMOp8Lec9E0diWM87JoBrgrWTI3fCo=;
	b=FrL50FGkI9tzrL49V+7ScSmt+jWF3OxIcSz/zXBNA6AfComY33MckpdZemTZK/XRgeCqot
	r/T1xbdKgDUWHfJ1VVqQMXu2WZqaLhL3rOeCPMxf255c8rjkBq7GVxgLaOV0zlIk9hlMgU
	a8KCyIx2wPVsQvQRY5mSVfdndeRh6Qk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785885126;
	b=67QuUzOA5H3Kh1RF+sgdKgpjV7v/MrcKenmJLEw4xsQ2sYb9PAtHxyp15o1It+ERtEUR3F
	0HUyrgD2SuMM+VNL6let6MZnLLZnYrjgoDWNpFFmAk7mMg7WrqUccXhf6D/iCuJSfbjQIc
	PRU3aVeNNZcs3+DlOtmBjQK7/IN1lhM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qdlse2fh;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BC1A40AF0;
	Tue,  4 Aug 2026 23:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3DF1F000E9;
	Tue,  4 Aug 2026 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785885125;
	bh=h4QTWJQpnYCgvZMOp8Lec9E0diWM87JoBrgrWTI3fCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qdlse2fhDvX1iCH+zgWT3U3of8I1Z+o+aamxuKtzmTGoXI59i313At07ihexnsu/m
	 g8hEgtaAnrvi+IZR+Ve5r/boz1nLIcfZf97yrtcCd4uRq2vwUTx9x0sFepV+kI6eMD
	 MTAsoJ7ffNw+2qTiBQchiyETAYCVEbLdtnNI2UFU=
Date: Tue, 4 Aug 2026 16:12:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3 0/7] mm/khugepaged: several cleanups
Message-Id: <20260804161204.140bb3b8e482c43cbbacc2bd@linux-foundation.org>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9126B40002
X-Stat-Signature: qcz7xazo6bxc84e897snffgbza3of3fe
X-Rspam-User: 
X-HE-Tag: 1785885126-50434
X-HE-Meta: U2FsdGVkX1+r9SeeV0yQilq4GnB81QRrwPFExDYL7v7lDdMBWoEIh5DJZKU6yMJdpBS0MAqaV8UpZqt3OY4OLSYDdurl60nzbMZdw2dgjMyBgFjSY4qx9hShgpkbvV8kqmsN8git4ATHrYRT77oJ9jI056RhsAbft+o414dmxxrqAIA1yQ3ZxaSdPB+FbGYGysQslY1+vhi3JJ5mvbHQKCpkvGt8B6kfYm2fV2OLPpjCboyds1t6YCw4uxFpHZVg2u2xpoWiw3PX8OFslvn/96wCLKzK+N55IDDXQBiQJ4qLkvAECKwBGmwddiarKYatsIeWlpcs2jOU+M2gKoA6jE5NANAnjReTIdgOoScGB8Pve7xMAGtPclpyJksWtj8+C+muX//LcWkFaiyn6sJfLOatFTD4WRcViM8JIPV0iAlpLg2kc5p8AnqhUNRJxhTjekg8dm/cng2a/I/YE/dRX2kTEVFTkNYEZujUm3fRoPsFbgYttiwfLAZBN5b6tIfiCH66psu++uuapWAbVdXHiz8Bqj9hCMYNcUGJobZGiRGHwPm15NRQteQKE7WM+Xy8bswQL2d6iHrALCFxBE78Gz41O7IDt3WhBtaSI294Tg1ABDuaahcSkCCam3/2fqwA95D6p1+LOvI8RPw3Tknd28BOEZ5azRrKdcABsFDCrRhEdWzewQKgv4vcq1C6gX9m8JJWzWOqGsRvlR4mQhbAkjcvRQwNe+hXQk5X9MRj5mapKkSKjbWVJHFJD5ejuK+cktgiR0ssL0PRZQPIQZcVZ/oEp9LHr8DAutvQU8QCmbLmBRLeMyYBwfp+7uzbMp9Ur+C3WJirFPGg6lU0nc3QitpFY19pmm9jNt1mNZoj1DVsZ13xz+EXmlD4qfNCSOZWl7ODp5KRaOlIhwsh1nBPNt1cwaBmWujxwx4+b5Qi9fou3XuXh4jJ1srKN8nh5/vYoywrIm22Vll3i+z+Y2F
 9bBmytLh
 ZlYfALdvEYRz8hhAFnXVwAjRdT9u1USXD0EKeSfsHYGRgaHz98+XB2z2+e+oI9YjArFEJRiYofhH5Aun5XyBcMM7SUZgkcgsnNry/OaA4TEuAOfMpZ6cY4fzI3SuEM6N8GWF/CBlcIJDV6WNEqLaQy3mvbpMaxernvAkMnlGHTL1+OBWlm8AZjA8kqlSiZYXbOPA8zB25jEXKdO/J3tjLEEr2s83uQ7rX8AyYv5jZhxVXDALYNvpKMWckYJgjAHs5guqF5SjXdUIzllf6Wwt6FohA34lbd1A7+GXAEM0R8HmNKj8hSM0IIqvcoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 04 Aug 2026 13:24:58 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:

> The following changes stem from a number of reviews during my khugepaged
> mTHP support series [1]. Some of these are minor code cleanups, issues or
> reviews that we decided to deferred to a followup series, or in the case
> of the more major patch of the series, changes [2] Lance Yang attempted
> while my series was in-flight and we decided to wait till later to try.
> 
> The first 3 patches introduce helper functions to increase code reuse and
> readability. This includes a per-scan state clearing function, extracting
> the young page check into a helper, and a count_collapse_event() function
> to reduce a repetative pattern used across mTHP collapse.
> 
> The 4th patch was the byproduct of me throwing Claude at all the
> comments in khugepaged verifying and looking for any outdated info.
> 
> The 5th patch is based on Lance Yang's commit series [2] trying to extract
> the PTE state checking into a helper function. This required a bit of
> rewriting due to differences after mTHP collapse was introduced. I also
> took into account the changes requested during his patches review cycle.
> 
> The remaining 2 patches were review points during my mTHP series that we
> agreed can be deferred to a later series.

So "no functional change intended"?

Sashiko had a little doc niggle:
	https://sashiko.dev/#/patchset/20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev

