Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B262FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F966B00AF; Fri, 24 Apr 2026 10:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFD46B00B1; Fri, 24 Apr 2026 10:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C456B00B2; Fri, 24 Apr 2026 10:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22E36B00AF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:10:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76DE71B6EE7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:10:58 +0000 (UTC)
X-FDA: 84693635796.23.6FD2E5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9176B180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:10:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bzPvRblR;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgTU2r7fWWebC8P6mWYTgK5KO4TXcHSXkQyemNlTMfg=;
	b=73FNyr/VZYc5Uo/p3SP00Gzgc2roS+NY06jB+qoeoSCljEtGfDGdl8lha9zEdb7oS3r47Z
	OEdSbzWCJFdeRHzmTWtLQP+9u1nCWlRCl1bLgnIyomPMrrwEXWU1F755xpvKyuMGdZbF0D
	N4VJzCkZiHGraeDdzHAf5iohVcw/6ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039856; a=rsa-sha256;
	cv=none;
	b=KL+VPJg1IhnQiT6OhgGfUx8y8Aw19dAv2Np1+v6960Zi9xwBGpXGtvErGbIo2gejPI3/bD
	DMeyyuRW04c+lwc7UY88lvDARcmAu3rk2c4zcAXVTdgSgTDBZXL2dX5aH+NVhRB64IJ20s
	s6uR4CoXfRej+6NLy3D4kscSuZNqbFM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bzPvRblR;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AF184368C;
	Fri, 24 Apr 2026 14:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFB3C19425;
	Fri, 24 Apr 2026 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039855;
	bh=FufG6rtOJWdODqqVpGjpGMYcAJMiCngdvLFaGNid+qk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bzPvRblRAgWfGDJ7LfEC5oGo+p7osBdjVsD922f2zO24o5OYJDcAOIrb3XQ5injHS
	 9CqvY3b/kT5zTdbtGnRxCHTXl0jDn1JUs2jg6wnEmA/9ZMTuTo7eQRX2ThUdvYBaM3
	 ihPGn6zGGppfoN/+n3cK06na1M6QE5loNKzNr5lw=
Date: Fri, 24 Apr 2026 07:10:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lance Yang
 <lance.yang@linux.dev>, Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui
 Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, Suren
 Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, Matthew
 Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon
 <will@kernel.org>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
Message-Id: <20260424071054.3a4a09c61007e0c24d9223a1@linux-foundation.org>
In-Reply-To: <20260418120233.7162-1-baohua@kernel.org>
References: <20260418120233.7162-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u1nr56cagtxmgb86fgyu8p51hi4jc11t
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9176B180003
X-Rspam-User: 
X-HE-Tag: 1777039856-346726
X-HE-Meta: U2FsdGVkX19Ir/vIdIPbr21iihE0FHy9UsawqrSe3H9RnNuDXc+LdQ1PHoOnTfVuohiXhfY7PTFqYLn/cJMJaRX41SS+jkcmxwF1iF2L1U5i9Strju6RPVIXI9aVCPiG/UcDKR9O5tJdlBr7Xa93T4FbvCDeQvjM4tyPOH7BUxr9e8cxDuNskGPBi1tbapQfezaV5WwRD/FfLzWo17M3568feyZgCM/wW/SKxo0uawG+S8I0Xk7/LQru6LQEokjQZMdI+vwPOvDhhaV6nrVUNgcPh7B89XXeiqmNqUwjyBH2fBQwfqrvrDydPu/YJ0QT5GFbu+xDcq0R8oev19/6wHM+pz5cy6Ccb9DxZ9Rh1Dk/wQPSpcC3931oOGYF4kV/Mj3CojNSFc1d+OgrThUITgCVDALP4e+b112KnJCsMESNFBl0r0oCR0UGIq0BU7ZaaHLkVK5mfD2f4XX7roPcu2MmyCAzUlRXU+DcbB7ypSFh1Pdned4BY4NAqQPds7WJMbyaNBH0cZOocQ7+lRT6/78C+WBtK8p4YTMD2TUAnhlsDQo4N9KTVvQV53ksjxOcr5/iMJn0Q58xf7RSzBPbwOlPHFYQML9rIaDV1bdpfzxfDCFK9/7z51vp3o3TwzYrhIRFrEqxBWa/qBAhZWBqtJn/7VudJfxnGA+g6AaSIqShw7eWM8piT+Fz3zZ/unC0pQIW+8h+S5miyBl9m9tDSjInjNxYWztdnpkBu+NXxbsC823oPnm5URzo6/jTxQsbEjKdl7Q4q4UzWeZPALIeOrY3FQ9q88D+whO0ykIBbJJtsAT25D4YlPiCkua2YROU9De6GeQwIANYBrEXqcFtKCGhNuztWIljg7E/+c94udTL2AdVwXz04Obgh1pCjCtQVZ/j4lUZnyvT77a2qmGNID2hsHfieKwWuvN6hq2xP89ueiJZ6b/IVBin7JKoqFep63SF9TI4eimPSgjRMrV
 qtdj6gNP
 RR5IvfL+8oKD8SP/7q9RPAF0Blh0mYzYMj3o6FLtfQe0qJBbOCD7zFldRA9O8UFCwv+3oIPYtI8l5O60CYQTOEsdQ8YrzJAPAY+Y6smBO0G3E9zqnZYdtZR/V2NkGcgf0KLE7s0HF/JVQVO66jefj32SuVB7OeJ5wwFPfVd1rmbs/GxengIUIiSEmPmh1SDw7qFB73lmygiFkYCOU1qTc1esjI6g4vjSeA2HwlgBxyCniMgg6M0Zkag6AKBGjzDzuVng4UfzCZitbwfdkrUn5+E6rR839nY2Veby8eQ4PdnhPTNQ0tugMT1h/BrLWaHq37DdXs4BuqAoo+30Oj1oXa82Pd3uqyXA6V7R+uVQ3LF+Eh0GLRPRzRyMgL4Z8HhrQwv5gBbQVXIPijg1DZHOHovn2caRDCwFvMpUa09ZMwUw7Wb5sUj40j7Hfc2Z9IQHfylHvn48E2ycIJkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Apr 2026 20:02:33 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> MGLRU gives high priority to folios mapped in page tables.
> As a result, folio_set_active() is invoked for all folios
> read during page faults. In practice, however, readahead
> can bring in many folios that are never accessed via page
> tables.
> 
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1] to make readahead pages easier to reclaim,
> but that approach is likely over-engineered.
> 
> Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> protection"), folios with PG_active were always placed in
> the youngest generation, leading to over-protection and
> increased refaults. After that commit, PG_active folios
> are placed in the second youngest generation, which is
> still too optimistic given the presence of readahead. In
> contrast, the classic active/inactive scheme is more
> conservative.
> 
> This patch switches to folio_mark_accessed(). If
> folio_check_references() later detects referenced PTEs,
> the folio will be promoted based on the reference flag
> set by folio_mark_accessed().

Sashiko: https://sashiko.dev/#/patchset/20260418120233.7162-1-baohua@kernel.org

