Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56033CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07CA8E0005; Tue,  2 Sep 2025 05:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8D08E0001; Tue,  2 Sep 2025 05:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F56A8E0005; Tue,  2 Sep 2025 05:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFB98E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:52:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22F151DF224
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:52:56 +0000 (UTC)
X-FDA: 83843846352.16.B2769F4
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54FDE180007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:52:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GdrOIe40;
	spf=pass (imf06.hostedemail.com: domain of 3dL62aAYKCBkCD57965DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nogikh.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dL62aAYKCBkCD57965DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756806774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCSyoQoZCHpnltai8AjxVufHZRb5HZc6ehbijicV91c=;
	b=eqbi7Pvn+1uRHf275DAwvUbnPXn0IT1Fwecg4kFFEz66SgGZ6lJInsCqZyAECEPuYW03vv
	BC7AbDP3FFXnT4FiCRrmstEbVmpwIYLAjxeaOp2rj97rWVcoROmYiu7j4DH35E/s/KLGps
	U2t0HlSkWgDH7J2yYpuwfio4BOL3X3M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GdrOIe40;
	spf=pass (imf06.hostedemail.com: domain of 3dL62aAYKCBkCD57965DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nogikh.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3dL62aAYKCBkCD57965DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nogikh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756806774; a=rsa-sha256;
	cv=none;
	b=pgGvP2tp40M3qH0tRhZTn9185TP6pEOlG5QmvlkYRlBRor2AFEHbCl4Uf82AvOw2AC9hha
	pQsT72LPWEQR5LrpD8ZgaJoywFApHlI5FIJkMFdBNLlb2BExpPxzRo/cu3VcE8DGGhiMlx
	D2ddtCX+YSqy2hLEbmjdYwD1SlqiE00=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b72ef3455so19508995e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756806773; x=1757411573; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCSyoQoZCHpnltai8AjxVufHZRb5HZc6ehbijicV91c=;
        b=GdrOIe40B4+0O6slg7yy40Ma9ZEhOrZx+SBZeltMYq44sOV1fWi8sJjP1zIzZg76TU
         5AUjJiZE6Oj+Vf9gIN8z/mSQwN0E1bwSnmnq9cOP2Wm19zlSsYQZ5qwXikHTBDOUGx4B
         zf1nNXMFQqqGDC9a0HAnybcsLJofuR0AJBnwu8eyn/g1I9Xr7ltFTBWVVgSxb2o6rof1
         O4zaVoyVoBNVeg9/i+YlUSxxK7ptyfGqGMmrmtemO6LgoIcn60NqGIMHEZEHJt+tftW8
         6WvcNgmLtjP5fH6MWAicaEb+PFaAlOgWwA87ANYRcTPzO8wjTU8aLp0DlM0aiBG8yWKL
         v48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806773; x=1757411573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCSyoQoZCHpnltai8AjxVufHZRb5HZc6ehbijicV91c=;
        b=FNbuO05YI8iyPULhc94n78imV6CpA8mM+prhUoH0N6NBlxYzX48AZnkXespOHVAzQ7
         ReTzfmRVJbMDDEKqn/eEgZE9R+PWgDhJoYFrAQtxVsmeliBt0rxU+TU/NTd1DXM6bz/f
         OpKHjU+9qXRK03b2yRC4jyrrZ3vNhPymzCp0w/wWr+W+wEFfC2Qrf22acBDRhXASY1JK
         Qj8Go73cBKEj1H58sYcB66ZYjXigZRSkrcn3DsPjIwm9KTy0I3lcVDauzUOa/vv0pFRb
         Z1GixJjb299Y5XShzyyiVldph2OVCQYTaeNrokXiDcU1LmBSpv7j/5OyRh1JJBYTrY6q
         e1Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXc+O0i88vqjnmt6QjlwR/nKr/Hfl2fok6riAkMiVgjndGAPIVuDVmoow5QNkx9v0XAopQ3vgHtEA==@kvack.org
X-Gm-Message-State: AOJu0Yxo/1S4fOFIcc4DMXL7q1babLbB7Do+Dihm1FLbysUuNfD/7Nxm
	bZ1+FRkeXTRZTj1oJPKIhlIGECZYJmPonis5b9xHfCZScjuTWpwlgGaXzzhP5hMBk5bUl9oWm9K
	47cnFPg==
X-Google-Smtp-Source: AGHT+IFhVx6/fp9bQrLU2+COALc3WyAOQyYyAQ0ATCo0PnkqRHubwOfZgEMWzw4a3O8baNUfr2wInNKraIA=
X-Received: from wmsz16.prod.google.com ([2002:a05:600c:c170:b0:45b:883d:4704])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1994:b0:456:18f3:b951
 with SMTP id 5b1f17b1804b1-45b85575580mr90608915e9.15.1756806772777; Tue, 02
 Sep 2025 02:52:52 -0700 (PDT)
Date: Tue,  2 Sep 2025 11:52:50 +0200
In-Reply-To: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
Mime-Version: 1.0
References: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250902095250.1319807-1-nogikh@google.com>
Subject: Re: Re: [PATCH] mm: fix lockdep issues in writeback handling
From: Aleksandr Nogikh <nogikh@google.com>
To: david@redhat.com
Cc: akpm@linux-foundation.org, joannelkoong@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, m.szyprowski@samsung.com, mszeredi@redhat.com, 
	willy@infradead.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54FDE180007
X-Stat-Signature: 8jnrman7sjr4jrxeuroagpm8i1w4oqz6
X-Rspam-User: 
X-HE-Tag: 1756806774-9512
X-HE-Meta: U2FsdGVkX19OkUjYrdLrGG5CeI588iel4tL9NNlmhdV4+T7QbauEVCVN9dcVrMg8Hpq9nkVQOw3M7ITH9aprBt7oDHiHLwpb2oNoYlRWt3KwngyQT/i+JHNJ6t7NHeXQ8ubZdjCT3VFvo6mMOr5Fn+w+WQ+LeoEzfNZmQlGsj6tVb0nO8SzxsTk+fIEedopnnYe+MRz01/BR637x+KQXQdsgntM2TmqbpLYDdckF3IyoJBe+chFetnqhFCCGiGIkXfWWLRr2Pg7YYNBOdkT5y5vhijv/f+5Coe/mm6a9nX1+l+Ap57edS5eCrluAhIv2aw4amVtbJoVFPIGSQpWnv1FsUJYvEDBModuDGyXZT1dw8+c1E8IQTPph+Aswg7ST6PUDKHbnPNGm/+V+q57euarVIUi17cNt5m0VvFpac02iU3JFTq/F/35A0IE6mJB6OmhAMhjfkigiXzLMu1yyFaY1f5c7nB8dA3VJ1I+Lvm78ChDPP8HAbEtGt+Kp45jPGbfvo7u60+JOakOKycLoqZFhCJ6Ph5Ar3J7Gb5knX2ZLI5R+GZ5f4y8CknZtdUZl5RYFTIADIRPbvRgt8PcO55XGZeCkRfA0fdKZUpfoAzZZ+/MpAPaf9h7K5jqkdr6Cc99FbMUyyQpCtUY5kCt+O1FIpFNS4XEBAJy/ge5onqLb+yJihCx6UXrdp6koY+qLr9dJ1/qlqi/bu8issYrTk84yHVd934wSwUQ9d3yfEmlmERXSjlVMJpBBYKR92gQ0GIJcnPPQbRowubwFkqG3uMQabjjQmbBf9JinGhuY9khTmH4vy4K2cqySBMjpg5NgEev0Ale1M0k5lkP/oGriSnl62FytTage0Oo6p8bV0Yh95HZG20qPdDFA4GnBD1jljCuGQjS44Vm1B+kug08njbEI7X4ejotnhg0IKx8s+s1xal8KkCY1xJy5hKjGUHk9sm/YZmO17wkZ34emOjK
 fFmHAUDX
 bsiAw2vuZ7DiDTqPp9ePFFYSQs7nyPJiGTQ6cdlWWVSIm/JQWY4Hy8FplcAesJtPa5jHJNqgXtkFsd3G8+ZKdY5u2AB3Z+9GhQYVunAov/Ecu9ZiCAFqQFRSlUOEILGXSFd6uiUNjYMIQXaw4BB5YeQBAb6gxu2emG/qTb6CWa+PX/Fe+p+TwMwEQEshqwBarRxKE3fnvaFe9hOWcpY3MlQZZGcbyRHFvdLWzwtV0N2858INHZy/3e6kRyneCTdj1S5QjhnLmTFnKtzcCleS5v1FwGfr8c0AFHXuA4X6VT5GRDOwmuhIA/CbSxeYJoTdG0Uzqkr/YvZs2NyoQSZ/eoexoY/512t0TpHhvVHoUemtvLz6hCwoSOxnZwUoEpjrANOuJDGLijYqvq03ueghj+UeD3lORhZO4yHd1+uAv6YP/W78dDdtEFhdWfwIZ1MCX9Sq6iEGbvrwQIKjtor8M/nCGr2Z3km2XupTl1djdKRmzgp90/CD34eaqLILqygiYp8zCK5eUdRcP+lbA7/NTIPNgAOZPXQiG30buKE75G84uVUN3F2qrPmU1hqLwHX23plGcgXhUZsul14LYoaWUkX+xtcD7Pycoupbi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

When can the patch be expected to reach linux-next?
Syzbot can't build/boot the tree for more than 12 days already :(

-- 
Aleksandr

On 27.08.25, David Hildenbrand wrote:
> On 26.08.25 15:09, Marek Szyprowski wrote:
> > Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
> > BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
> > Unfortunately it also moved some variable intialization out of guarded
> > scope in writeback handling, what triggers a true lockdep warning. Fix
> > this by moving initialization to the proper place.
> 
> Nasty
> 
> > 
> > Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 
> -- 
> Cheers
> 
> David / dhildenb

