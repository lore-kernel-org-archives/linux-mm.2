Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A838BC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692C16B007B; Fri, 24 Jul 2026 10:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643046B0088; Fri, 24 Jul 2026 10:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5332D6B008A; Fri, 24 Jul 2026 10:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4476B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:26:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8B071C081B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:26:41 +0000 (UTC)
X-FDA: 85023896202.27.5D5936F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1174AC0008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:26:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dux/sLHM";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784903200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+VsBrgqmMgnylKKDE6sUiG3OINTfUBlUudCXfXiTsI=;
	b=GojKN9bnFMV4Pnxk8yhPfRaYkpKXAqlChgDD06zVb8X8qNK5yyGgPvi+j0e3rngqBT/0Hw
	SGo5YnsDNdzriv4tkr6ekAar4qsdmfbiPxEhNz+xBy44URxAEYZSlLCITpghczUzz5iEl1
	99h5u5n10/Kh6n6uIa1RqGAeIVuRt9Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dux/sLHM";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784903200;
	b=j4jNfoQZamTJVp9LVfp/jmgwS6iQrt+th1TFh0xHjZmv+4PxD8hjSO3aIAqbtHWwISv1+W
	xHihz9Mnzm8LZ29PMJkn1DR/EBAiKoKuPU+98oxeX/f9aG4BBbuq93qmWpJSYdrzoCTuGF
	Fw57eOBGn4H6AYw2vOaHJkJwVxAekh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF6B41874;
	Fri, 24 Jul 2026 14:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF571F000E9;
	Fri, 24 Jul 2026 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784903198;
	bh=r+VsBrgqmMgnylKKDE6sUiG3OINTfUBlUudCXfXiTsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dux/sLHMsptGYjDdSOys+5saGrO2hY0qqeWGU3tmR/m7AGZ09iWI3QyQkv/Oiw6gD
	 fj7ZL5QmfI6mRfwvp3SH3xU2M/Ae9cp0BgBXoxiqynYA17VdVmVZA+YbuQVpd4WbNH
	 gQz4qgRy47s4iPrR29Bd9FW0THbXlGx/QPUxiMCeeWHIGPg8esCeGQ9DvZXjZ7qCE8
	 uHjFATxoPIMSKWq9oDh7Ar9gUFfaJ+SfSBiMxoWYyZxLCjAFmaY3I0vvqMinwEifjX
	 pJuWE8zSXdOxkOPiR1qcaz5pYxZ5Y75l9xFEQnhEK+xkXSqc6qUcKJK6PJuYNHbovW
	 5aeimj+qt1HOw==
From: SJ Park <sj@kernel.org>
To: dayou5941@163.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	stable@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Fri, 24 Jul 2026 07:26:34 -0700
Message-ID: <20260724142635.93839-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724060135.3014676-1-dayou5941@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1174AC0008
X-Rspam-User: 
X-Stat-Signature: ks6ikcmjgke5fghwpqbd6xm9nj6hjoy7
X-Rspamd-Server: rspam04
X-HE-Tag: 1784903199-675281
X-HE-Meta: U2FsdGVkX18Lqn5Ka50LtyjX+8GaoSxEAAGkMuom1hKu+9ldh7kF7O50V7PSsqgHZIEg4c8WNsLKNMM36mf9up6MThC0SfJz/0DcHOmCnuK9+UYZh0KiDGN+L3MixTRcuwprGRzuWMP1T5nMJt+oqGvGlQ95U7XYHdI7ZQ20+IKK9SrQ4VxWFJvo+LQbu7DzrvuZuadtb96MXY1HRWtcnpDhY5JA2CqJZvpA71kDYQIeUQ0/Hfki4lNWackJndH/a4kEBGnRzCIiHghloDt3KcI6KCigvjX1j+OpQ4P2p35aZAUzpLdiWPr2D/vG/AuXMZ8ZrCic2gscT8+OgPtmWnw6nwKvfNbJBSbMwv49NWydstt+HThrbPqYeSCfE6ADvOWmsqH09xmlk6+WYGR59cZBRSdx20cYDhnTopAtPjKeGjbFjNwm9BTBgMBLL9OqyZ+v5rt+5nYGWy9mmtZ4XTelrIopXV+cow5VftVRX1XmvhL4kGT2u+jAmPUG+S0BAi9qLxAevLzpgHz57kGJoGKg9mcRyRZ8ZVxx/7At+I4WJ9fViQPo8rXLSAI9X0BPNXxJe+tHy0ZjFuN5zZTeQ2lG+29HWkvQUUT/R8DFsalsoyTj6I6BbVV3mF6zJp6638XSAACWiEmUG40tAsL5e8DZcrwk7unyD0IQnYy4I9xrGfO9Sx42K3azYEYVl+4tpBfwvPRo31scwmh2i8PAPbVg+4n1rOoLc1tCv4B8/EDzcoMhgQYuKnzNSRXhlRZ04my3n6PlKT+sgR8k+0mC8iWcOTAcUyznSnuMBaoBttdyK6XO/fWhE1gWDJpaEaac6N2TOp3W0MyOWehI2cG4DVu2hMk/NhO/KzbhYvsQ/fpiLViCsgOVdo6XwawDqr3CN0sCHWpHe62T04r0Z2Nrqs10kYIL8eviG8K1J1Pd2lYNSAbcB7ZGWaGQe2II5lPX4MYvnrK0AH7FEswrw8W
 Cg+2eLZw
 npBqa2VaXSQiKHZnU2vlBJpvs0PmFTK30gQTcVvkxP9G5tEipuiNuQwbzz/17bS0+ZNKCbiGW5R+UVBD78yxSgt5cK4e7NQ1nuRZ7pwVdE8Degm341Go8MEqmnvscfUG/2pD61Iy/a3yZfdRArExS4LgjuFMqQ+RpmxSTnzck0DfEbATE5PfIjA6gmnwFvce1qO1iYz1it5EM4TYz5mmRcIHiXNiW/eADLrnngr+WAZVe7suc1L56gkxZdzyvN6dCRgWqiNILipouDY2IXlAY7MY6/lmSVed3AcYoV7QYCSpswTLW8e3piJg3XILFZRtxAfZZ5SXKhuwjumS927RiOm3k38r9w2DgYaTiW4g/X1VDqv0iHwRKwliGpW+HA5WZhBTpf1JHGNTQjPEfhtgVZHjk1UvIvd0CnG0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


'checkpatch.pl --nogit --nogit-fallback' suggests adding below recipients.  I
added them.  Please consider using get_maintainer.pl from next time.

- Joshua Hahn <joshua.hahnjy@gmail.com>
- linux-mm@kvack.org
- linux-kernel@vger.kernel.org


On Fri, 24 Jul 2026 14:01:34 +0800 dayou5941@163.com wrote:

> From: liyouhong <liyouhong@kylinos.cn>
> 
> damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
> and then call damon_migrate_pages().  When target_nid is invalid (including
> the scheme default NUMA_NO_NODE / -1), damon_migrate_pages() returns early
> without putting the folios back to the LRU.
> 
> Callers then discard the list head while those folios remain isolated with
> an extra reference taken by folio_isolate_lru().  The pages stay off the
> LRU for as long as the mapping exists (anon active+inactive counts drop
> while RSS does not), and the leftover references can pin the pages after
> the mapping is gone.
> 
> Put the folios back on the invalid-nid path so ignored migration requests
> still return them to the LRU.

Thank you for finding and fixing this!

> 
> Fixes: 7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
> Cc: <stable@vger.kernel.org>
> Assisted-by: Cursor:grok-4.5
> Signed-off-by: liyouhong <liyouhong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

