Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC16C982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DE36B0093; Sun, 20 Sep 2026 10:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EA56B0095; Sun, 20 Sep 2026 10:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D7B6B0096; Sun, 20 Sep 2026 10:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0103F6B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:47:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EAD91A049E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:47:08 +0000 (UTC)
X-FDA: 85234418136.17.B4F584C
Received: from outbound.pv.icloud.com (pv-2001b-snip4-5.eps.apple.com [57.103.64.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C02F80003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:47:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=B9Z8hwmp;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.78 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789915626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09jiLbzpb1veArtuXhL84Hxo7NJy/m+yRETm/PTbJXM=;
	b=Z9BcC5cfbIDMf+RuskW99UcZlOmGm5PGFdqvEraZdgSWOvcoRkKfpjDXcOeaSaQ7OoY4kK
	ynBH2iT4ypQosbZ3aNGmqK3ym2ypIQZFz/iSXwqyljEfRkt7H9exFghFpr9w7HeRVUpIeu
	KKGFoHXWZUY+wdXVWzF8iNAYagi7syQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789915626;
	b=J3etSnrs6gyYtzYi6cGlztoSUYFvB5e+/YHVP+BfKhzWNVnghOdv7B41LlCat5byHme59N
	iQ+giYJsSnM2d/0mKQXTb5c6b2xV7qLk2eeHdNxUB0DqzFt21ZbYuMAtn63rpnuzHh2jE/
	66RBuw7wiOrzNvAs3RsRjoCh7exxpqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=B9Z8hwmp;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.78 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-0 (Postfix) with ESMTPS id 7C5BA18001B6;
	Sun, 20 Sep 2026 14:47:02 +0000 (UTC)
X-ICL-RepId: 01a0bf48-ec0a-7a7f-a463-1916823a79c0
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXwZLWhVVFw4CQh9QH0wWV0NHHRwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdaBkQPTARDA1gBQwpVAkBNAkIAXApeAlkAVwl5EVABWB5WXloXXlMXH0sAXEVaDlsERxQ=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789915625; x=1792507625; bh=09jiLbzpb1veArtuXhL84Hxo7NJy/m+yRETm/PTbJXM=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=B9Z8hwmp9+SQ7EaHjGu4O3EE4TOO56BGpkmOlXmH8xPLmgxy9uPR2l3S4tbtpkkzle5PetrDmfi1gcFLkcvKx3xTfHXbj9E7GWe6EgbONyuGb/QOKw4N/i8pfNM2GzNui+qEET3o1jAR9ppf+jRVdHs5Cxun+RwFCBFZrG62ZJx2m6EtmcoTG5iEC1vbs3I2lpVAMn1lBJ31V04GdCWjj+7bC7mhcc0s//rLPb7K3joWZjsjkKzI4m1vtaN6PfiPBNAUZC6V3BZUVpL/5rW7AETjcGJs5LUJ5xafiGz2INhwvq6rXDcFH9V5G5+U3P39/5XD9qXAjE1IkpbC6bBwpA==
Received: from BRUZZHANG-MC1.tencent.com (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-0 (Postfix) with ESMTPSA id 695811800207;
	Sun, 20 Sep 2026 14:46:56 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Zhang Peng <zippermonkey@icloud.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Zhang Peng <bruzzhang@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/5] mm/vmscan: extract pageout_one() from shrink_folio_list()
Date: Sun, 20 Sep 2026 22:46:46 +0800
Message-ID: <20260920144647.43333-1-zippermonkey@icloud.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To:  <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com> <20260720-batch-tlb-flush-v5-3-db943a0d0d6b@icloud.com> <CAGsJ_4zOfR3Rn5tk_RcOWUDmREO1JyRwXA15Vr3aeUs=+ybMMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: fy9rEMDQMrPKHRWHN-6yUqk-6O7WW-7b
X-Proofpoint-ORIG-GUID: fy9rEMDQMrPKHRWHN-6yUqk-6O7WW-7b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxNSBTYWx0ZWRfX8gI4cbZRMWuI
 KcCjj6CThf8vLJmvMDeWXV/ybMzoNi96Ux+hL+qNHgUTCKLL1tuYe/jr55yOHUqBYAzGeV1YlAi
 VW316FN6iHrDMhFSuO44EyXS90cSq1Ck+RWOkaRLL5BCTDHAx0gs1EQsPhXzg0ZhekbUUsv0nEa
 UWdT592jHkFC2V9nosNzFLaeHPxqTFd7zRg4KtWmPUDjol+ICw9Oc3tbJc/Z8oH36STkA9fCycP
 3pPD1xR3vZ5CvdhwSlmHwdCiG3dKc38li0j/hfWjgWfm2kpHQD1ALeV2Eap3LnibDpE/rNqP+T2
 toJ/6S26n2AyFXK0Mq0UShDf0CFZNPWr2sMPr184Vsrvo3Gbfmn3yy/6elfkM0=
X-Authority-Info-Out: v=2.4 cv=RrvI7SmK c=1 sm=1 tr=0 ts=6aaff1e8
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=_kJJyzcaNiJmjTfxGhgA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=kKg27zqgtulLWh45kPDF:22
X-JNJ: AAAAAAAB1nRey5oJZ5F0KLj/9N0cLRbSJoEF39yyVxr75/6La6rO40JosQD394aQDfSDJ3l3H/mMOBI3LcEcOFejkhBB4zmEoHX7h34F5la8K45IEG6slCWkklQn3s2PDsYCWIW7poavcSrlgLg3Qgo56AL7xmyCV1dmh9W4ELAPgNpG7pvKQ3FaZeSvPiyMEaZ39D+9lKRLhbpBgqKvHV0+15SOFVS5Te+QOxHuOwhGiLbUtcsLpIJL8UB+J61U/k1EN+54kIAvmZ+wS0RxAChmpYxRrSphfkYlStZg1vfCvAbyycRP7P0R0UYoe2acnhn66iQprqMOmDoSM4pmW0N4yXWq6pwUbsW9OJf2qcvxVqgpooWj8+5Sjrx/mD0HNbW345EFkeek72TzVBAk9w3WWXrHMq5H4ApY6BghjdJOpJ813aRo9o6gDKMNJ8Qpw4DP6KjmodQuLCoN7SnFbdJLXSbdjl2ldeKjJd+8rdkJMrYYxM4hnXRYlSbco3GqfTIxGy4LCfY3DPo3XEPpnHfNzpq8QQCUfq7sEfJPPZtWjVMfbEEC/DHmGGR+iwTc9zt44ht9IXIYo1RCtrX0WoRTXxdLjWz8cn/uuBix4HL1BMjtoxPjGTs3HwCA9kwj5K4hzym5rtmf27RE0QsyNDvAXNVMcZ69BPoyhHQeCYw+A5qTWzgaxePZa5ZSLyhaCLdPBadPGt6HqHO8R2DzRLyjN4a49VoAyAwQZxbifELRt5Rrk00hkM6yy8ob6JMHlcYKOP3C/RBdOdSXqysvRjDB7mBY97CFhJglm3Sinr+qdh2SUxsEGaH+XYQP++u9jDHCZ5JPw/Y1vdKgAuphOqxjEhR96Y9LAAfsGUjobBGUDuEt7q/qI0rTf9F6utbk9Xu0uSyFdxuEAX9ZdULfT9NU9MryhF1JrFR2zGR8AgX1NJ3DXagRrgs/XVrVxItF+TcIuqPALFX7sKxov3IkLkZ
 B6bta+vN
 gmf0hbLDOrb+dcB6NJVQESsPHmhSSvERtls2lwTlqzkJLMy1by4aoxi2RASv4uXNLZ8RrI/BlnMaW8O0bonKhc9UiF+cnez6pPR13TORw+CqIBr6hM62/ig3KzjPLDYkri1KIaUy3jTwC7fp2WpwNdINj2RH69ZBSqQNlMlqKA4RE1KsXjiP/B+DZBkFeeg2EsunPMoW5hFUtjP6u1BcNExnwGHTXmO7B43UXBfH4lfa/zB5dOPZ4P4zq3wPFCPJENg2nPedFQh6IWz0BQqM5uOw5JJdfo7y8dmPFPsEwdbGo17ih/5z25s6hBpX4HxP0yp86S65SG9FwzK4HlY2TsLUZr/dM6Q+KhO3mmTFTIb0iR/MDpuiSPD15qWw9XKbFsxgxFFikXHBEQRkGKC+fp0CoXNjl5PkuhuTuNfWXu7qrL9x1k+1OyJ1Zw7hSgbpHGpbCKMKtC5uRr4Tdd6tCCu4i24GoOypYNci3E/eylVjTAHKsrGpq1BNLkbxqalwwwAJ3ERs/RFukvNgiZlRpjIM=
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4ostnw5i7zqb7uhfzo7qqpfex8cdh765
X-Rspamd-Queue-Id: 9C02F80003
X-HE-Tag: 1789915626-731990
X-HE-Meta: U2FsdGVkX183w8cfJtJelXVV26ZNDgvN4M5gASA5zqsqDenRJJCGZrZHr8WkIinuiYEvOmraKoAdDAQD55mlIfBDmeldoW8HTCQjfksq8PP98pNpR/CreRl0Mv57T8KcjLKmJkS6DEdsp5ZeKok74A7RaF3aCoHGnIeUMueAF4jPipWPUnXINtVno0UAd8ixz4OxRJ13fdNzyzgM0Zfcd7TXQJtCnohhF0463vC1L1IRBXsz0BiPrHOrKYOhooJQ5VxENVeueNKu5bHYDUA6pqMHj5OfLs5WTvolaie+elK2+3rjHckPjrmNZuxN33OLU7c51CTjkDjWN657RQaIP6aAqBdj+GL7hM2FkZ9QqIlS0SXrZv9Dw9ry6XbcH3L7ChI3yaVHCBGxMT4vlOseKxGIYcG0cITjFg1oMV0n6Bc9/16U4w0F00MZv21wCT39m11A73VbewjmMtc6I7al1UXwOkAnGD9tSojMKU5REs2C8GE6D3gNISveVD44cdZtuuufu4YyGucZJr2uYHuWSrbpOX2TH3I5KOtK5G5DXZjnlJmHfi/iCZFykZAdcf+l/L1UmCw18y0MTfZiIcUvBkRW31o8H3csH8TZSf95kqnKJDQIQBtwDW0r9OwdbYYXQEX1hErVH6NPfOGGGD/cpXiho2tDDlSxFzi3c3Y/MnhfomD1sO+EN8mxHFYhctZ2/HA9l5zPNBlGZAGSvTAcirx4BnT3mlkg+yt2zj5TMH47YE47eYFHxFaDE9KMMEoiNOr5c1dWUXJUTXBOwP3cu0l8nqMvmrITCgQJspg0zEzMjgDmbZDdjCk0uyNDoYWWz273CzkTHkUo/fvC0X2hTloRvuU98VBQ9qweYa6SDTZanTQW7Hnmhn8VI0CH8flgMwoGSc253osUHiJfe4JQOzqvOi9fASgLrRFfPlroP06m1StFN5jet7hJqhtVa4W1GqPV7H2K2Zz0HiBcA+Z
 wbSKvaI4
 1/bYOkm+DMDVCuxvZRaE9Arf7f1sm31k8mp7luTuqZkn8ewXRLaMGyw0JTFsdK/UeplGotGNPLHET8yT93yeBqn8OYtgHKibK5BuBLaZeNO/99Zc5iUkZg9O9XLHRUjq71iuX1fL0qc8VSyPmveO4gg7Itpet9Ij0VyyrTueXXD3yTWPdahgkrKvXqGDyiUUDVNfDMGmF22l62ylVLA0SB6kG/wnzJwFdCau//3l6Wg53Tk/JnXpr24JuNo1yAUszt/0rjty8QUup2azlD4mYDODukVuGIvazthBaW4GdBhs3gO1d4CvUazioNhJl/uGAZQw4GoNA4otOyrMMM/EW8ae5z3DN4AOxJjiHtaJSooBeN/74LzJfAj8yY+vc0yE4IiE97bxZUmloI9IWa7MKSOqq3+Z+OMwV+08pVyeWHoGOzeynzyrWl/PEAFm5IUJFwNyCMNTXvQO0HDd8Stvp+MiYvqMg2ua9fiQJpheNSan3T91KvS2KEU3kBmTRPsvZczZU6yMM97HIxxzaqBPhz97HK4JwHCNZdT5Wq766/zTV1Li+V0kWQaUIpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Resending this one on its own - my first attempt accidentally sent
all four replies concatenated into a single mail, see
https://lore.kernel.org/all/20260920143816.39827-1-zippermonkey@icloud.com/
Sorry for the noise.]

On Fri, Aug 14, 2026 at 5:49 AM Barry Song <baohua@kernel.org> wrote:
>
> Also, this patch looks basically good, just like the previous one.
> Could we also avoid hiding the activation semantics in the inner
> function? It would be clearer to make the activation semantics
> explicit at the outer level, so readers don't have to dig into a
> deep internal function to realize that a folio may take the
> activation path.
>
> In LRU, we have two distinct possibilities: activate a folio or just
> keep it. This is an important semantic distinction in the LRU logic.
> Hiding the activation decision so deep in an inner function makes
> that semantic much less obvious.

Done, same treatment as 2/5 - the helper reports the decision and the
caller acts on it:

	enum folio_pageout_result {
		FOLIO_PAGEOUT_KEEP_LOCKED,
		FOLIO_PAGEOUT_KEEP_UNLOCKED,
		FOLIO_PAGEOUT_ACTIVATE,
		FOLIO_PAGEOUT_FREE,	/* folio is locked, hand it to
					   folio_try_reclaim_free() */
	};

	switch (folio_try_pageout(folio, sc, &ctx, folio_list)) {
	case FOLIO_PAGEOUT_ACTIVATE:
		goto activate_locked;
	case FOLIO_PAGEOUT_KEEP_LOCKED:
		goto keep_locked;
	case FOLIO_PAGEOUT_KEEP_UNLOCKED:
		goto keep;
	case FOLIO_PAGEOUT_FREE:
		break;	/* folio is locked; try to free it below */
	}

Two things beyond what you asked for, both because pageout() has more
outcomes than the freeing path does:

 - "keep" is split into KEEP_LOCKED and KEEP_UNLOCKED. pageout() can
   return with the folio either still locked or already unlocked, and
   previously the caller had to know which internal branch it came
   from to pick between the keep_locked and keep labels. Now the
   result says so.

 - FOLIO_PAGEOUT_FREE keeps the "and now try to free it" step at the
   outer level too, instead of chaining into folio_try_reclaim_free()
   from inside folio_try_pageout().

This patch is in the cleanup-only series, see my reply on 5/5.

Thanks
Zhang Peng

