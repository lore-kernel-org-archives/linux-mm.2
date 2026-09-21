Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43FEC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 22:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C406B00A4; Mon, 21 Sep 2026 18:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554BC6B00A5; Mon, 21 Sep 2026 18:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443BF6B00A6; Mon, 21 Sep 2026 18:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6716B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:35:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E95C802E6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:50 +0000 (UTC)
X-FDA: 85239228060.13.AA74FA9
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf08.hostedemail.com (Postfix) with ESMTP id CE8E0160007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S3bsJ+MA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790030148;
	b=C7uyAdwgVcr6FZmwvN7/S/sI8JyAuoYqTbJnX8r+X/SfxtKuvn344SIw1uI3SuZcj7uDPE
	TD9+pdXzIBHZMNmz+0y63FG7+RekVtPZXIUnm7PHLBKKjHu8hktycl2vDEog9XwY6X9kY4
	xyPD02UnE2CA/zJs0g6x4a6mZX3+Cf4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S3bsJ+MA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790030148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNGCiFvjZR5zDf6Moy6F7fBM805r8TOBg7DYawpb12s=;
	b=16F2A6/pZQz9auCBXjUn/M3AJK7HHQkeoHolAF63zZ8S61kpTRYaWFBuFb2z4qoqpDg0SR
	jkwroj7AdUt6ObfRaKjyk5II3c9ocU3fLykjVpKKTjArleRVRRwyYsXaTrQolirj6jVO/K
	ZCRHSmve/otOtjE5HC0kT2BvYif2SM8=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c6b4783778so1959510b6e.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790030148; x=1790634948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qNGCiFvjZR5zDf6Moy6F7fBM805r8TOBg7DYawpb12s=;
        b=S3bsJ+MAj1Xaj1FX1KyaAptXajSuNC0zOzGjDpk3rSQHypqgxlQUCmpzp+38mqJAlY
         zW8NkdKXIQ/SLd9nKPqWOqvfh5K5zdEXy5+m5PEj/2Z7nJchfATVlNUh7+x7wLKoklch
         l1brswzOKUiUgpP1X4Q/aPoo8aNVNC/YZEJr3bbutmc5fANBsgiNJXL2nSnxaysN3KL5
         A5BCdHw3NMbEksYyEONCvX/tbWIZpNprj7jaKFyDJ2MuIWL6+caHOgrn6JiMSBSwqhyJ
         Znnb/Ek5xvfEnobTTycKoiJxtt2YSXb1Hm+6HA3u/5vMYHSDC/73AohwUigoAgaEj6gJ
         mgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790030148; x=1790634948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qNGCiFvjZR5zDf6Moy6F7fBM805r8TOBg7DYawpb12s=;
        b=e+jiPqzUp/iZCxmE0thWDTsuIS9cE0ztgJ7+Ac3oljBDrdREEKBvNoCXQuYbl4Vg2+
         42EhmQ7h6P5UVMCjLI8BhEG5YtjCTy3GKaLrNR3MhlwqrCaw5OQnYOHHuLMTIAu5zorO
         qlUoVcSOoeLCIN6aKdgoXEIiG4uJvOpza97kENivQx5utN9s5YI6+6rB7cJ7JZj5/5aG
         lPu3bTzVL6HXL+WDbAuRWSfNYNBFgON4qyH9auq+JOodvb+gzwDkf29z27s86OzNU7hj
         ceK60iaoZmAIn+tPNOTkN5cOapI52+Rq4m/Alo+ab9pkx7tjzX2q8T7OLseEoCJaxgPW
         LaOg==
X-Forwarded-Encrypted: i=1; AKwUvBwWcKQyOlmR6K8jLTn2VvM/w8uNFVqgpeuGbZQjyIZaRaF6CsLAukHxLvxyLNU59qRU3KTSmjOo+w==@kvack.org
X-Gm-Message-State: AFuF++kWxbQmzrcapCkzB+hFXUniZ98OvlYGx2iNs0GjV/gLyNCwumCD
	eh/Ueu/NfABzak0L8GCYP2YXmhiYgyyKup3BdvueeK3n4ljc+l9GAkgh
X-Gm-Gg: AYBFou0PD9c+eutJ9e7E/JnHVMMDeoy1ltwNJtOLkXzykcMzz9DEq6zUSe2Ln3W4mzF
	vW/7US1kVvsZkCCE6M8y1Y+Jjx1KAOML24H9WlzTZOQpJbKNOuRETkVb2XB8tNhAK3/5QAQhxJJ
	/808ScgA15Ls/7Vl5weCF1Ws5aEzJObnuosHG/6Nsvg/uJKOr879xpJ03hAnct8rkE6rKsJactQ
	jvGyX9LQXn5fC9qOK+p/BBp/6PaYMDbm+mPanJddtbRtGTqKypHkwAHLqPiPgzDkLGcjZCqCqLK
	6KZLbWAgJ9/Qs5PIND5BrtZY+eYCUUE/+xUaV6hBeso0Q2iL+O6TvGyaQZztkysaEChcqTCY4gI
	ZDgesYVRxGdM2OFsDFt4iq2PqL/XaLyef/56ZHeCd6527HmIM7iHE1ZyJZlwJdz0akBKNRU8UfU
	PiET8kjYkeqV2P498Hx6ifctjQbZs2D10bGZNjGG5Fyzse5B84nhMtspqUQ6GFb+IYBzeJkvk82
	mIXgFMzkH+2OtkZiXUVjREwukJTig==
X-Received: by 2002:a05:6808:1185:b0:4cb:f21c:a799 with SMTP id 5614622812f47-4ccf9366320mr12128261b6e.33.1790030147780;
        Mon, 21 Sep 2026 15:35:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:16::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e649352bsm93244a34.19.2026.09.21.15.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 15:35:47 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
Date: Mon, 21 Sep 2026 15:35:44 -0700
Message-ID: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE8E0160007
X-Stat-Signature: gkp6n9iyker38ym3fnhu5fyqfjry8k9g
X-HE-Tag: 1790030148-584040
X-HE-Meta: U2FsdGVkX1+NgOLXJsI001/LtC6kJ4cobJXcmduupiK2d/bArG+a/kjm3Mbx2MwVZF1/J6C9bIgib5+NxqPlq1FCTXHE1v5riUE2/uVdcLRiiW8rpGas8RS6cZ2q1Q7/nkI4nXF09YmDsGoGZgOGgGg8w4xGmUqRBq9yqVAahTXZKsQ5OxUS5zOgNjilK9fhMIKyt7Hp9uKdKZaGyv1cqyBNMDMkupWa6EgGuBp//fPHmy6a+Hg2mjHmWwmOLGWMd/IDXCkYJv3Awtn2QhZbeOzGzEOB42mF4CVkFGOD+IgR738bY4SwLGbT+8XNzoMyr9o9lr6ZZ0wuesYeBT34B9/rRNnQQVYEYUHnrRovkfaDoAZw33AoHhVrj5LCR8jqX1I5Jozt83i9hbuECTVFFtu9i84WAZJeM1f82R11kep8y/ulTc+ASmTcCOo0TpO/Z/+d6KVyvbF2GTW5cT7AzdwOFu3LNPaqUqLElHw4DyLFpj+2Na5MjO0KFFIGQK5gOP2+zSYAbHyW0jUIRAvy+xpOASE+BBitPc1BhGGW9+OD5C3SRT4etl5C0iamRT4j619Gl4eTU8uSqdccKj95ymFxzLdIrQQy6+yABUvCrFRVLffeoWQUy6FfumOs9oo/CPsH9AEqnKbKrFK3VLBPLZ0Rn+A1yIIW1BmKh2W83QxgTkbZNHv6szFLQhbVp12dY9K7TKR0A9lCJvqvUacMZnVPlAQAxrF9zm/YO3Q3BThc5GlQGeciJt71w/5UbiR3vCvwrbBcjUahPURKBx9k/5TYXoPGutngom24ny+ebdNwzIkQlexhJuUc0VKVBGJQlN/dysltm23QVDfG5jCYrenXMs4efqf6AY0JX2Z618lKsNYjRYzY/4V6/xkyd9EDagwd18kScazyhJ8P5KPoW52VkkHCOsnwOM2QH7bFJJ+WSsRRNy8GEb9FvY8yop1Q7fUJvJgZOPw0hKWeLNo
 RCFsF13Q
 drydU4sNSWKsR+YVayafnE3+U1ulA9dD2077x4WE5MOd04Fqs7Z+xgir8RmGUXOCf3m82hf8XwVg/xX6mKkyJmFrPAPynIBzGTB7Ydq2njkki4q7/XQ/hTR6iq8estVBxVcRHbL2oFy7t0mn2AQqCHmJhw5lQVW5rBtafzjFwzHg3zV/iBKl+6VMef7Ya9jXbOfiwliEefmMYO1NhXZAOWnQPxkw7YYTGR2Au2ACM4xMd6cLsFtIUmwAl+W76fwFX6iE6DDKd3BsF1qg1YQF8d9+MwX/gDBtPx44tHKDs9SCXSrq89uGtpRWMhm82kj271GGaW7Gtfam0kQ1A0tezRpPd33BSxm7TkItGGKy3AfVeay+6le9/C9JzJ3ly/dPhyCadtkj2hDVsvfSygX/1TmlfxkagdKOHOCZhsR05v9e6pOuL/mOQXhlxUPB3AsRngH0Evbbcr3VeS4gqXgAH7WvY1bgMinYEcp4m3nY+HqP3zbu9hbv+M99SMlrjSnC+RPnamRwLDYFAEqNPA7BQ0rkMyX9hMT/KsVqszcoPYQHfc1vVLX4nZ05TFQRiHClHVAzU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 17:12:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

Hi Hongfu,

Thanks for this fix. From the cover letter I was frowning because I was
thinking to myself "surely there's no way hugetlb accounting is this
broken..." but it seems like indeed it is. 

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is.

That's pretty scary! Glad that you caught it here.

> For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.

The changes look good to me, and I was able to reproduce the issue on
my host and confirm that after this change, the missing charge is
fully accounted for.
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Again, I'm super surprised that a problem this big has gone unnoticed
for so long. Thanks again for working on this fix!

I hope you have a great day : -)
Joshua

> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

