Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4390DFD8777
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EE96B00B8; Tue, 17 Mar 2026 10:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F346B00B9; Tue, 17 Mar 2026 10:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944FA6B00BA; Tue, 17 Mar 2026 10:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8103E6B00B8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:16:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43412138DC2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:16:59 +0000 (UTC)
X-FDA: 84555756558.25.BFCB47A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5C6F614001C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:16:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AVM+jZN2;
	spf=pass (imf23.hostedemail.com: domain of 3V2K5aQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3V2K5aQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773757017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHyQW1j38add3gC7b1p33IpvUlEz/eLArJFX9nPP2uU=;
	b=QhPX1JZkkC3HQn0NuH/1GxyhE1AicnaxmcUA2qOBe9eAa4tD+5waOYQXRveP3JWKBL7ZJz
	vc9yuEvUpD7hdkMqG9ohupQlOXUkk0mMqADxV9OPR8AliFpqTYcXL+LsuFixRv4nYwUbZe
	zIcJ5nvSu2cdeWmC4pn8b8Ey1BachE0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AVM+jZN2;
	spf=pass (imf23.hostedemail.com: domain of 3V2K5aQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3V2K5aQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773757017; a=rsa-sha256;
	cv=none;
	b=oE4JcAPaqPZYUsRIcGy5iRZiLXZ4iwve347YI0AnaKlUDhRFEnUuq/mfCHpeqWECioY0IF
	AdMhtyPri+AqWspEY7ZiZ9sUrVurYC4hXobkW1LxaDkt+MGg+4o/npGjpnrz3uICFpPrSz
	gnnFU1i8Axe6G9a+zXVqDgOr/ZFBnU4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853553944fso8112765e9.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773757016; x=1774361816; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sHyQW1j38add3gC7b1p33IpvUlEz/eLArJFX9nPP2uU=;
        b=AVM+jZN2KdqHz2cQ6qT6PSV3fkr4eqqY1YpI6hyimNdy8McEborBNrNgZcgd5BnYtD
         jqyYerZSlWvMCr0FH/tjCuy0HW28SAqRt0TfjEjlhbf+8YZeqPQhpHRxcOTqUq3gyrth
         bXS+H0cSKLRBjKySyojr7AlkUeOcMHWByyBV4/mKsB2Jfo+qK0q9tVs/bnbgzro1/OT8
         dlOB/rvq7OF4se3ypNK0IXrkE4HWhVIWGSgY5d3l2tcjRyzLuSsIEumEADsQBxcwPA/a
         p0VH8yvu15phZx5kuaDIcazq6W2R9MIrAGdWKt9h1agWvUBvTdDR3EGFIEVSXmOTXhdh
         tWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773757016; x=1774361816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHyQW1j38add3gC7b1p33IpvUlEz/eLArJFX9nPP2uU=;
        b=cdnzLOTEhWOWGDmeHUD/QCSzOlAkb4ZVaPS9JJK1lm4iAjsGzARf+bDgiHA2Np5bZ7
         tZdOrqg+FmEkCHc4ExOQDSlEzQN5LIi1CSJ7dmvsrNsyWUVbwUveL6K3JM4ZrrnC3ZLq
         kzi1hc/KWZGGyMx6fxahKOVvn6HaX4Ot1AjnCgDwUbNaIUszWiEUPPh2Ub/ekheaMkpF
         nJhob9rtlxGXXGbNMwEaZtu57xlajBU5s6CJ9IrcZMjhxouvZUxY2ik68xrr1NUUwtGi
         A7HyBIZLHlAiFhUQ3fl0FE1F6+f5zpBv1ZAvI/52zTcp5E5DUerD+PDYh7SxL4TUw9KS
         H4sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw02wigly5xoyNSTrTH+K3Xn6vp/ipg1pAAE7HIuyjwYBLo1FIEKXtVO+Zr+WGBYngcATHn2ILyQ==@kvack.org
X-Gm-Message-State: AOJu0YyBoRyGn4eKe/1g7RJ8ZNMC+CB5oRds3JsmQ+23Otkd5cazK6uG
	iyfsjHIhVuV63aPuWJfsQCto3dSDGp5J+axNlAfX0kUSu6v/WsXDWstWkZFsyIaUmJX1dhuPZ0s
	wK2AA6Y0LGyVndnmRcA==
X-Received: from wmz7.prod.google.com ([2002:a05:600c:6b67:b0:485:3aa2:da59])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8488:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-4856eadba01mr59151605e9.15.1773757015602;
 Tue, 17 Mar 2026 07:16:55 -0700 (PDT)
Date: Tue, 17 Mar 2026 14:16:49 +0000
In-Reply-To: <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
Mime-Version: 1.0
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in> <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
Message-ID: <abliURxm14-xxgFJ@google.com>
Subject: Re: [PATCH v5 1/3] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
From: Alice Ryhl <aliceryhl@google.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C6F614001C
X-Rspamd-Server: rspam08
X-Stat-Signature: n9aze9usgscg8ngnyfre6whw1b3wsptp
X-HE-Tag: 1773757017-666494
X-HE-Meta: U2FsdGVkX18j+DkGGzXTshdOoTKbK21K/XLEH6I5OJtlGSyslofP5OqmfCKDDplrmvlaPBNXuSaKZhUQq+z60LGN1ea53VxsjbkgqcG8c8ZJOyIbgprjlgFAFUNrbpYkbT7j2LuYrAeqlbmyJioTNbV+4ozzg7LCcYjKdQl2StCP+Qtq/9Y7CjZkOjBENqNa+GVhF2cFFSDZ+vXxr39pr+nG8/1BznPgkxIPPOX+DmD8W4SrtOQeZQRidzHw7VPrrnnYEC9xj5/SO6ZkAT0+LzOFI5AbWycnIfl+j+JP0ycq1miVQtDCHWhAmL9CAiuMkopan0IK1UKjy1m+8G8xygxJS7iAWbF6t0nBW3J5+TjCyvtkS1wOIizlWWINWu/gIs/0dlFjITYgTAEOnohSNE0ZnqZ0YvkB+IR3jNFBnBxGVY02Og2Um8dSsu13CUAk1hBshyrGK6fY9VP/0GJIHDBxEl0ls8Qcw6C3RRB29hBA+kwz5TwmTZhnTPzDMWOPEbehFxOBPmAlMAz7uO39YVZADoj2PR1V3cIwrsj2SUP7xv+yNp7Ox9J2wt/LHeSyfiW9/w66bdsblAIKwbNzi6nLqJ9Pno8DKHiyEEkU0dfrPn1dIkyOqNqKVp2b/9MnXGXhuNVhvjtbcD1gbpu68Rsm/eDPjneXOGOnIM7+eBvee6tvp26JGrEAXv2QrSYtMDUOraBFnjAjb+sRJHlkqBwbOoerSqhxaD7Xlk+R/4pmHNe9svCZA5MT+hvKOATwEY8EfjhUdNoE1PpwTOVepOVomLBtckuLYcJEduaRZ6fhgk54aVLAyJSzbzWkRVU152sL27S4Le6kTjMxmuoCx8MiC7D3v09t5ww2kM2xF7hvmzjVfYrhYsrvZvDbSj69gDWJMV27nMPrm5h/64OuKS42Rzw8cne1G7FCZYH3NrRd2nIDikCeGfyEMoD2F1KtpsFl0KPD0/8NbYRGdCv
 5b9QxaNB
 rFKmCeGuj4GhKlRbZstBoQjEH9YsVHDTNfFsP4sJwKcOyX+fusSC6362SqyE1cpi82+S4yg+R/nGk42b5fqrJYwd9JUa8f8kZQVbkjLsr//xity7mSQvtKlsLdZjz1SMzoT7dTsl16ob7S/m9vuiZ/VOWV0GdADM+IPHXSPAim1TN+qE/yjf6o+XNa26WDXldPtYIU1N/19+ou7draEcgX82Bwei7HNW/6z+hoBg2o53NQAdGdbRfAeUhpdqrS9ZVrCpt6eVwkS5fXhR3boMbyNuqayY4B2nHr+ZWy1zZL+Y7wZD0VWfGjsPf0cOpyl6CrPKxMGRMe8lp+56d5w89A2C/72L4ZWYhF5a1fmEmY3+ewAiIZx0XBHbdLdpIYpSh8bdOWAtbEZTSJXFt5aGYkIgOWG2U/FbpsQ34GPQ8fmqvnOHt8AGBOy8t6EIgJGnFPsSK13TOyU8XbD2ex7UP0N1uiU5lHF6zjPv0+VtR74wExRdRbIBdpSyF1/DXQCswBmsY3AGRBbGt/CUm/+TXdPWUOxOKU/pv3c0LiFBrTpyTL2gBs2YFsk9Tyxa4z2eyBUjgOpQ5WnBSycon2IgfhXBwXb+tbtVeMY1liufj3NABU4Btn7ftbbzvavZqaBZKNyKiYJpdDagctTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 01:47:33PM +0530, Shivam Kalra wrote:
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vm_area_free_pages() helper. The helper operates
> on a range [start, end) of pages from a vm_struct, making it suitable
> for both full free (vfree) and partial free (upcoming vrealloc shrink).
> 
> Freed page pointers in vm->pages[] are set to NULL to prevent stale
> references when the vm_struct outlives the free (as in vrealloc shrink).
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>


