Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1E1CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9246B0088; Thu,  7 May 2026 05:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0776B008A; Thu,  7 May 2026 05:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BA16B008C; Thu,  7 May 2026 05:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1BBA6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:34:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C5501C0351
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:34:38 +0000 (UTC)
X-FDA: 84740113836.14.2B295FD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 797FE20007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:34:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1nUDCaZ;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778146476;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=702H2S4N5D7RzWa0xl6b2kbo8YfTndWwy7+YUwKRtHE=;
	b=Gufd7S7lPhY9mRnwDzsqmIc4Q65wYVFMMUjNIdP51fYFmDk6cxEq4Yr6LbP1UZG/QWcNqq
	FqGpS8i0N6THmoHeYlfkc9lTwUqySOCcwRY/r9IyED/HUOeSFST+GQ+lvpM2Kc4CLznDyr
	OCMIAGeMlkdqUP4aU/A412lt6A4CTgY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1nUDCaZ;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778146476; a=rsa-sha256;
	cv=none;
	b=TSuuNlDCZ3pTH+j+lQ5TS1f6Cu6Gq4KpnsguLhUVSoww/BAO3Y8sD/aeSYKff/t1g0/XIw
	swRma8KuaIkVeqGTZ5XPa/qMLXHTUplCHc1ohO9glf/c3lxG6gzd71Njx/uiIM4U0WLXjF
	mhQ++/0JtmeZsyqz68n5Hx4AJ/GWUNI=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-453903ee4adso153820f8f.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 02:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778146475; x=1778751275; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=702H2S4N5D7RzWa0xl6b2kbo8YfTndWwy7+YUwKRtHE=;
        b=g1nUDCaZKS6UKrQXBT2NzlFbAlxQrzEqNB2fNMxcMX+/+IuscH7GEoJaaQ+kPw7Zm/
         Y2/s9UI2QJL72M1UqjgWrx2TkgP8BN5DfG+687cMKstbK0/XoO7VVucK0d/Dn1Zo/EWl
         sSATlNv+MOSS8d7mDCsB9eqLk0wlFxKkJMnx5Uh76YVt6mMoX1a0ehXxwydcQ+qyL0lc
         426XBYGZBTGXVydvt1P3fvkdF+At4g0OD/NZbpt82g+T3rAPDMhHj1/1/B76ahivRpMh
         Iheca/XKFK8ZFR+YTUi/cAAfayodSDXzVSUpgYkJHsOGQjNthpNlFGRkpIFzTc99Biyl
         aCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778146475; x=1778751275;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=702H2S4N5D7RzWa0xl6b2kbo8YfTndWwy7+YUwKRtHE=;
        b=Les6/a92MU2SVKism95D0OkIH8FOnUkeLllQE/XtQQCCzjjiHfl8iFjedOWuXiff3Q
         PwyTznoiR4A0jJe3Fqn0Du9XRvFnnpJ93gAuLmVKyxzQk06ESjxhPacJZ9RZUTXN3E3C
         //SCm2vVfockamxdNMv+WKDw57tJQSiZ8+UBCZYuQGWIhRTzoFfMnaBOCuF3ZMTqyGoy
         Flf0TMHim+SivbTJFvWShN8HfcBnJYXbO1DJTN0Ydv4gE4gm6SPfkKjRZjmO2ho9HA5H
         uYmfi+IPvgRXn2DTmhUY2dAU7aM8Tpmb0EPJ05Ig8F53Xd9V04Z23j7TJNbu3GTKKDi3
         ESXw==
X-Forwarded-Encrypted: i=1; AFNElJ/WJ0emKrJlXKLYZcHoLhk6T+RJowHTYUulmAEbsKg6nVzLYGEsunN5a/axmPh2957DPaUgBOjhTw==@kvack.org
X-Gm-Message-State: AOJu0Yy/3gao5NV8Lji93A/PFLc35ZFeAnMbgqMlRZHeATqmh9N392Je
	5YjmbBUG9D8UDxoOpzGuRqEF4nNQd2coVYn+5ScdDJgrOvG2sqqeoztB
X-Gm-Gg: AeBDiesE7PbsTHBRN8oTnIXCpwRo0hURr3LJHCTp6FJjtFRDu8CtoCFUFzpETgk7SA7
	M4TjelyzQSrCrCr3aoJ6lsDjk1Nl5lA4ofRN4wpElDTbEPNMjgfbzI9BeD204GsiRNCDGw2Lf/6
	Kb58kATUmrSqUo+cS+ApOMvW1wYIoE2jZCewRVEcdB0PBRGsfEkDbCPiz9cNAV38lmgtcjCf7h0
	fX9IZZwWv6mTvEZTANHkou4mdoyc5WlI9n3QSMwIVWSAaxkW4ph6OqV8ALBf9KdyFrHdxkgLkp1
	wzBVTRuKa88FW/mGEpdzHyJsV6s1OdrU4b5cqVOGBKaShPe8jBTlpgywXy2RUZcx390GELsk76s
	xjgMEJiSXG0c3LWJRelw/4/tDZK5yOpQ2SO5g2mu5WiPKZpInj8We1hRla/yTEK7t6lLpZ7YleP
	+aawkRkA7cQZ6UjdPK9KWnUGRLBjszFY2PduZfqHeBpr4=
X-Received: by 2002:a05:6000:420b:b0:43b:5097:6f62 with SMTP id ffacd0b85a97d-4515d99f016mr11855726f8f.36.1778146474525;
        Thu, 07 May 2026 02:34:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b03e04sm18747199f8f.21.2026.05.07.02.34.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 02:34:33 -0700 (PDT)
Date: Thu, 7 May 2026 09:34:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <20260507093433.q5xybwumryxclnqy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504130434.2285053-1-agordeev@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 797FE20007
X-Rspam-User: 
X-Stat-Signature: pfexqywqjg1eg1azg3fafnwyuy837sik
X-HE-Tag: 1778146476-32472
X-HE-Meta: U2FsdGVkX19LY1TP0xPRPHGTcVcb311sYAjRp9en3bXC5EWoUioDD8BxBay0KTXibpsCgLAF8t9KyOJ2QaoO2PY6A4jpxLd+g2B54g8bbbUOGyT9dG2uC5DjAYe/9zPlDYh2mrIuYgWEGejQjDqAfFJaA6/G8RAJar0s6Dm2g06qaWs7P80o8ImvLNt+PsUpFEvi4nIohU7uIeIceV2PryeSsgB1FHNVWWYldKEXGeMkygaEFCnsrJrk+YYwdZ9rHq81PMpDWyymbQuIFc1zIdAdcwKFitXitCFxMsflohdDfI4kxolgqmLg6G/uhE0P8kQLTpEc9ivnGGf6FZxHJMrFMUKabLgh3s4x74A6SnfF7NBIXwjaRcK9KePEbaQsg3autyQbuxooT2DNmyVKVhvezz1uodPY0s5eI32LUNjibX9eQAAUXLdlyPx/V5L+tKdKRKqYnOF6S4q56WVVlcr7rL3z07NnE1FH1E/Gr0GK2azhUNlcS5bBasicM2CuyzXCvV0kLQ/NOQO4VFuvXbVt3f+f1N6eadIFP0utuGsk3f/HmcSe3C7imITDGVUM4cJmRKtbfovEiyOFb+ZlyNqhzaw9nbdLUX5V9HBfNrRboSPorSEUj8Rs/RH66m8UqeQ++0dMXv/wWgEgfJMt6jv9Sk0qBXWL6+OncrdY6qSN/dDNi6QFugS597ZeGIHAVtSQI4VMafJ9WbEAxJEclSONXgcNMzZQPjezHGn0bxGHXJpgPcGfcwvzdP3bPEIyCcps0nRlD0WYVMsWD9OKKvnqOtkrRci/Ajfq2gRzenlq5HEpnEm/78jgw9KeCbqYK27JsL4Lh4ECsZ1FPWx146vo4CrvS+ZVgBqqIt3wIuy5Yt88gTGt2r3WKWsLfKZuy12Lhkjzi+j2IUkYs/1wUpCmCLhQaKorJYtZWidKqYSotx/Thtd90hJfkMd86oe6OV8eW57+X14jtZkc7/k
 32sFwSZ4
 tZMTiw/apKICrXzaNu+u2+Oe3AnEtQwEJWRtX4fRSMylF8aOxdUeN704u+Y7HG06B0aOjYgU6V6YASfJq+/CT3ujOp3/4lhl248cUe2jmEJgshkYC1KZvbz6N9XOzzHy2P98PD5dZEwgPXKei03GdI+wXhLMbeEzk0dhW4ImfIk/re7O5qfQpZiS09QMwmZUGmKKYg96ScQfLL+S7CS48R+zxbUn0RoUFp49bD4hOxWe/A12hBLk0Moh1v9zSljKHEM/jf4yUJKQoirax7dWji3XGSDBkV/mpt99llXKVdIp1WbXVPkh7pWpYH7+5nWH7MuhYTSVHbdXbWGSt0ZLh4pqLnrB6cXuUewIBZQnQqLL6KJpAxUDP6/wuaJfFi3yGkbN5X3IabErryMj91ZV7MRlsCd9HoyDwcHo8UFRATACkY3zoqiw8rkExsaUgr1LSMoM7ElXm3YC94mdS06wIZR51tGmhmGOVBlSVQWhnSH1KxMZrXw98Op6AsVU/oyD8WX9tO7sNqMQVReYj/MdJBdgVpfUGV51ikfwiqa/YyczFtHMFSlwaNwXB9hA2DNuOckHyU4IUytDIA+h/soddu/Wq16HbQuQjLWFwyF4KWp5uUJ8m0CE+RU1ltxT7JiqJNbgyp/iyWzkI+wU6D460FADTB4wQXrHKo/csdKps8Wur8LLEVBdU+3+Vs8+cp4ErIwWMV5l0bjRdnCOQy3HUQOMaRIjWsK71RzbNckL+15JcesdrwgtSkWfHKNnx6is/xcYCA/hXMyXiRzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 03:04:34PM +0200, Alexander Gordeev wrote:
>Switch from ptep_get() to ptep_get_lockless() accessor for
>PTE reads when no lock is taken.
>
>Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>---
> mm/page_vma_mapped.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index a4d52fdb3056..6559e17f11c2 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
> 	if (!pvmw->pte)
> 		return false;
> 
>-	ptent = ptep_get(pvmw->pte);
>+	ptent = ptep_get_lockless(pvmw->pte);
> 
> 	if (pte_none(ptent)) {
> 		return false;
>@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 				goto restart;
> 			}
> 			pvmw->pte++;
>-		} while (pte_none(ptep_get(pvmw->pte)));
>+		} while (pte_none(ptep_get_lockless(pvmw->pte)));

As Oscar mentioned in lkml.org/lkml/2026/4/27/630, map_pte() may take the
lock. So probably it is not right?

> 
> 		if (!pvmw->ptl) {
> 			spin_lock(ptl);
>-- 
>2.51.0
>

-- 
Wei Yang
Help you, Help me

