Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C32C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753966B008C; Mon, 21 Sep 2026 08:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A396B00A9; Mon, 21 Sep 2026 08:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665B46B00A1; Mon, 21 Sep 2026 08:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4726B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:25:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAE59A015F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:25:57 +0000 (UTC)
X-FDA: 85237691154.08.2F9D059
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 24FB12000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:25:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=macFNaFB;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789993556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAdc5FO1i9grgLMSpUoVxK5/k0rBXY6fo8pkrWSvNnI=;
	b=vrHBus1qB2KOlFbDWQLr31lAUURC0GvRTl+JSZFV7qnqvHiIf+AOVjq0814aO1OS2gvumf
	pw3TkremD4zB1EdtEybf5coTAkyDFMh4a0PW8axxk9hmXT8fMwksc/ZaWh63kC5E0w0Gk+
	3Z0wDvWtx2Qhr/wXDbYrUd09di/dm08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789993556;
	b=XZwfFOIfovAjZ4vknerdnVTE4prAXrgyzmlloEC7hz0n8nAgJB14R0QprCmkDPFB7/wmzJ
	DtAxmSGOffKHsNvaS2t88BhUH7/R0ayVEgJdPROhiSUyHDfaEFW1IbFV7pqE306CgN1H0D
	R3289rYyEVISoVJGIROUZ+tCKLznlBM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=macFNaFB;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8AFD600C8;
	Mon, 21 Sep 2026 12:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02D41F000FF;
	Mon, 21 Sep 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789993554;
	bh=ZAdc5FO1i9grgLMSpUoVxK5/k0rBXY6fo8pkrWSvNnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=macFNaFBbpsX9/6u2Pgy1/4vXZApG1r1E4HHNo2+PQpwfaNoImd3nZ/pijk8QyBh7
	 5Qmmt/2tsXtkNyT3ZX/mp9eteN28sUEJEmDNjIpyGk1K07An6f6D/26tKJ55duYBhN
	 zCqlGduHUAwTP0TnBFel3P8TjyNKbEYzYdVUugR6zof6RI8UfXkR+09l4gh1TWYeZb
	 bZTNUyM/IddcMWZC4p3VW9UPLst/pHTnVL6cLIfgInkXwOMdcs7qshacZbTADsBWpj
	 gLRs9iKUiEwPUP7jTRaJGzywvo2PXXqZy//mc/0ujyJsRG83pSEHDtBCqwoS9w55Lr
	 97aZIGomqcakQ==
Date: Mon, 21 Sep 2026 14:25:46 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 1/4] mm: generalize vmemmap remap architecture support
Message-ID: <arEiSiD4-3c5UkHf@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24FB12000E
X-Stat-Signature: rq86ffogwzhmfn8trfao4hstf6shsbjx
X-Rspam-User: 
X-HE-Tag: 1789993555-458771
X-HE-Meta: U2FsdGVkX1+sOzv+G7dG6SqYrm3k6SXTS8YjmQ/M9UunRt/c0SOse4M92+f/sAbvmdHBEzceqHU/yfo8Y46VcMxaGyy81WNUYVurovYMPAHCstFxVMZai63qJ7IxX5xmDEKJaYOCgyBOpuUqY1mf1OQliweu22gNnxdlKYKhSA3/8koOsWtjZZOLR/efk87cXD9Q7ceZczw4ZmAgQJZQWmh7xgQAo2gbXhWJDtQ2GNk9ywPw6pJrH8WO7H70XB9Mxc3bCWOj0D5eJaQQQ5C4pDGZUyjmf7C+ERyK8i25LIxpTZzvlhaVP5fHgtRR6uDF370HIOGnMREoy17roVOMvNjsCNeY9KN9qwm82X5lLbWeB9mRI0E/aFaxxiWzbYKHZYDbha6bZnQEOQHuDyjTSNPEsiMO8BVwdpicUjYLc9TaDQ/Wu2XrYulvDkerHDe9SH84sFL3HJewVOLfUNE/9lbmiq9+mzZYXOSdZbRUcufhc+Dr1QV4A/J4jT2G37w+b9OOF8ltP0I1B48NDofZp4fWcTDk9dz3qMZEbh5XmxpgLuke21GAlO29XKlKD7XEzVjbHs4BM2W0cd/IZYtMsGtJ1rtaEC9iriBdgoIBU1vQQTVC4JEuC7tVpw/5GOuU/djx3vmZTUdDkygfy7FUkGvGF/mXvHSJol6P8yGvvk9/vljboARRyzZeIYHZOUMAThpGy2gQ/4991NNQhuZ8K5Z9w8t+5W6F80s2Ji8GJPDdrrEKZO/e6oxJcmNri74XeGMsMVNcP2dMa3jxiCutF43Qm44GYxIV87HuDnaftGH81V9lVOzIpkcwNhNrGCT/PuiE+3SNVyVmFDxgDuEaaAYjjsqEHrqEU03Tfv1U6QMsU6PpH2zicvb0s6jVHivwIx09lqR5p5Waxknl50zCWYGTSJM7CjNAPD3VnjHbaShsUWZ34175rjIeu0UqjmkjVq2SJAjrKQhAs23zEyZ
 dUj5UvQG
 hBBJfl4xGbBhLEqMp9JRwkFW9ulcEejDMz0jqsy9z6LvmtyONZph5UGWbVXpRRQDWW4jlb/b4Xy2ChSMVH7W0/u6kyXRogh/2ikZa23RVXIL2STq5/Mn1OiBZ6ZTQBAJdjwBBCD49pJqoZR5SwQCMdGxr0fW/TMsHou8o71GOTp0Fx129XUOyvpxjEjuoGwEwqQ6D9VQfHUHko4BvcWAvyphRYw9b93KIzGo3Qk/X6WQVTBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:21:24PM +0800, Muchun Song wrote:
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP is named after its first user, but
> the underlying requirement is not HugeTLB-specific. Generic MM only needs
> to know whether an architecture can safely remap populated vmemmap PTEs at
> run time.
> 
> Rename the architecture opt-in to ARCH_SUPPORTS_VMEMMAP_REMAP and make
> HugeTLB vmemmap optimization depend on that generic capability. This also
> prepares for FS-DAX vmemmap optimization, which relies on the same runtime
> remap support.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

