Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A1FE67A96
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618DD6B0099; Tue,  3 Mar 2026 03:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C416B009B; Tue,  3 Mar 2026 03:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470806B009D; Tue,  3 Mar 2026 03:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3720C6B0099
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:32:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5922C19F0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:32:12 +0000 (UTC)
X-FDA: 84504084504.06.72111B3
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf23.hostedemail.com (Postfix) with ESMTP id F03F1140008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:32:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYHGiOfs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772526731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCKtvBz6u4VQYJ0ASC9f9azcq6abhXVxZJlOEPkzL+E=;
	b=Upe5VGdZhGRWcaB+qMfFSGlluvyvWwJEQEsgAGYrXxCRJbieI5ZDUsGURHZcZNgJpW7P8D
	+1DIHpPNQ8QXYihxKKqNXpneNSF2XBNw/RKK6rzPHoQkI4w41s3tsnN0kgOfwd68eWjIjH
	apThbrqLojWRDArqVsJxIJyO9739oQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYHGiOfs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772526731; a=rsa-sha256;
	cv=none;
	b=EIQRSRtmJXhRnz+ZeNH9HjjkSgUlTcE5KwvpSzTlF6xUq637ud4k5jOkeRyYV2HvO0Ft6E
	GERNz+k4uhbr+iirGCv4O1mQi9QMmtJFsazVkQYqegON6J1RTQpldCmSkaImo4+321U3QQ
	gOFtjOxW8dYndqHeQSJplLOyV+ULoFo=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2ae5636ab04so17589595ad.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772526730; x=1773131530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCKtvBz6u4VQYJ0ASC9f9azcq6abhXVxZJlOEPkzL+E=;
        b=mYHGiOfsuhQC+wzGBOWb8ca58lsPIr12Ww/P4yOMaF3aFFRoTsVAFFmNXARaKlTTyU
         zU/GDgo4tLc2DoIUyIlXvuxM6BmyDZ65uzQTx0YGWkvrYmQQDpcnyixtfhFDtYL1Bky4
         xHtztmGZuZT0ktUd/4dlXVjhfdhlIV+VmPQb6HX7P+EZxkjKutDSCscnOkvj8CQxcah2
         oaOrOjWCgnirZo4Yog8Jx+To4xBiuQr1OvvCNL7pbdSs7YAKK57Fsxe8peXtyhKQMCxA
         lXj6XIS46ux/QuJm4K/9yV1WKjoN9AwfnBNos3pIMQHTEiKoJDckDdtwxxvZTEb1u6v9
         6d+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526730; x=1773131530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZCKtvBz6u4VQYJ0ASC9f9azcq6abhXVxZJlOEPkzL+E=;
        b=cLSoXzE3t9gkwJj5j1vswviwBui8BsV6zC7EcKeuHUZHaOUnwwqUM/0DI7BmxqiFD0
         1APpXGViYOjPQb45TPjxPoYnRw+VkS8chdYQ1+n3CCN2nQtPwbeQeAg3+6YqiGjHVQYB
         UY71jnWTROULuc7f9zSzk8XCGwG7manphzjqrjIKLYgg71zp5e7ofRIaclQjf9wYVEQT
         wipyf2qkeWnoKA62u7U4Sone7QlclRjueY5mTthbiHSAuGk96PHVnckjKdBwiBqOXox2
         +IFJQR4kiUmG0eXO7D5OcWonqeciuvL+jMQyvMR4OQQtmXCiybyX29SUlrE9frLVbniB
         EN9w==
X-Forwarded-Encrypted: i=1; AJvYcCUwJFTaxl2jrIgRdMTFG6SNKLtxQjbuXpMWI4VGiC4Cxd1oxmUCsz12yiAJJY9euNDMAnHFAq0I+g==@kvack.org
X-Gm-Message-State: AOJu0Yyeh65dSE3LguQLT68ddNF+eH2Y36ZoMSktdMF6RD0fmROUqGf4
	73kj5OWSC1mEiYgQ2SJKuBm1hrOwx24NBuZjcJsuX4tYSHf1CeLgo4H+
X-Gm-Gg: ATEYQzzYh0erOs/apLRFSQsYxzKlEJ0txdLu/cwmq73y8rx6h26hRMKgqcBEVsr2wZf
	owFttaS0ONQJyZUnUMMv+dx+uYODsMFISjkRcTf7EzL9WpNz7t19nDjeF67/Bc3jOnFNRr64eAz
	HM2BJqByl0U+QyT671AKkYbuGgEAxw4mRoHUHRV++NVT+vn1boUUHBPqVaVcDCq/iUBkIKmNUtX
	72XK/jmTlqltJpHR/aDjbhs/e+vo6XEIxcdDk1ZphfjIvWWFPY1AwCliycSCribbOyv8r7SnqcH
	A9A2r/V7pSrmccgE7Nj1gc2oEHH3Jk1O00M8OeHSG84RccrVDJ3yMgkeu9yt967RCD9XyZcPy0g
	7KipsnY3spxmP2xMdmmdAS1z9rIvr0DjPBXg/0PV27oXCsq5cVsWYlingw1Vm8OtQcC+/TzwT9V
	/PpsNknbMjAFOlji4Mh0CyLT2WNWzq0rGqW1VrYyNknnWHxPflSmM=
X-Received: by 2002:a17:902:db0f:b0:2a9:410:2413 with SMTP id d9443c01a7336-2ae2e46c01emr200504215ad.29.1772526729844;
        Tue, 03 Mar 2026 00:32:09 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([43.224.245.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6c4dd0sm164082165ad.70.2026.03.03.00.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:32:09 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: 21cnbao@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 3/3] mm: optimize free_area_empty() check using per-migratetype counts
Date: Tue,  3 Mar 2026 16:29:52 +0800
Message-ID: <20260303082952.477277-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
References: <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F03F1140008
X-Stat-Signature: bcstger7i5cx5usstsds48za7m141ge5
X-Rspam-User: 
X-HE-Tag: 1772526730-739135
X-HE-Meta: U2FsdGVkX1/5DyIjNIAPydNbI77Lfz8r5WT5yAfxmuVHxioUbPqzFM8AXDgS763rT5QkAZB4Z1hKBPg9L7t0WFmBW3UQ8pzwdzHiEb6HHWi7L0F/ZukwSqSj6P4hpTqcnAEDQ4DHUOzh1qluDXj0YBe/gVq5Mh1yvmzD7FFpPtIhj3UlCVxlaEnoEYvwcrYGHcTrN2900gCCw95XrNqXPUN69SWpFeb4yM0kNRC46Njpi3DIQF7lnbDw88WSbP3TW84hWfvX/285XzhEkyvs1JF8ue2Ry4Pw2u24rGtgOISPoHlFBea98LkVjwg4t7giVMI/os88mW1kj517pZdffRG03QGGqIxjBmB4YErNDYjnfwcT/w05f3BoLzJgAmwa1jaCoWvzwV7Pzrz6bIAnXi27lTA1FRRRGjS879elPu1JcEs9ke0vo/CB/zA3jomGqolTaLPc0eTAFE/nXBlSNokqRFd9WFWD9E+yLwYIR1srXgia7bdQITFMr5wIKWLnzJ+rt5iB5J0BUtc/UUJmuMZaQ4QKSk8XhDka7hhJwYX6n2KP4AzQyfDMJZUrOPPw0HJVxqTsEBrsSI/Ik4PIRAVcT013wn1WzPmvQegm0Fl3ZiAUvw6HB7TuLkiG18Ug3YsmZ7Dyfq4M6zhFzdUd8WmjXKDHAZRiYCSJO/MXLK2RJfAFnHlYPyQw83W/TiAsbfiKvEfyedQuAdtu4x5c/kkbogL5DR2KAZ2NB/laBC79UWtJaX/WOMC4R6UnMJZnMrTdSpqA3pXEY2Bps5MuoQ3uvleZnE0JZ5y29ihCAe9kjFgERYl0DIYk6dvJWeq2A2hIZbmg75tBHzrEOIaVuxZDErRQlf+JKrfEnbFKevZXlQ0OKgLTJXzhqVDvhY8+/urRjiGf23o10vq7CmjmI/aJ3DKHV08uvfktzOXuJrrLB+aB93mcXquYqp6mQ8vRRjgqkU2Tikqazw3j2yy
 p98TUtk9
 NQtKEurvUD6bl/1B42aVtPvEtsTTtCX2NX76FeQ59J54EUraSY/XDB0mc7UE4V3F3HqOeZJCzmaF8jlMocGO2X797Rrrhl/KkfazcnsWuQUpSFVipPGsNqJXWPx12MEwMNT51/g1fGo/qJUD3Qyr8kmSzGYmGQf+OwPUq/nImGj0DUlCKV9dbQAY61n/LABa29BySGl/AFrE/BYihsHXnbRVsWWhrZKkTgCPaVJHMUOTNtVX4wYjNiFtwiWgGJzEwlL6uwAcmvGwye+aG9DHUnPuHsPPjeBAiQUuNjfpE9zacYWzggJG6tRTrEnoeVLxsOYRJ152lYlVmVwhi4yP3aJySdjXRAQ3i6k1nejlu5b14yBhwEZ15oNJv1z7q6jbD+ha7x2aHcq4qOPsbws//XpTAaCzTN2HonYUaDvrtoeZiDwFNcptW+Uh8Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > Use per-migratetype counts instead of list_empty() helps reduce a
> > few cpu instructions.
> >
> > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > ---
> >  mm/internal.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 1561fc2ff5b8..7759f8fdf445 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
> >
> >  static inline bool free_area_empty(struct free_area *area, int migratetype)
> >  {
> > -       return list_empty(&area->free_list[migratetype]);
> > +       return !READ_ONCE(area->mt_nr_free[migratetype]);
>
> I'm not quite sure about this. Since the counter is written and read more
> frequently, cache coherence traffic may actually be higher than for the list
> head.
>
> I'd prefer to drop this unless there is real data showing it performs better.

Under the model described in email [1], with this patch (3/3), memory allocation
performance is 0.36% better than without it.

Detailed data:
- https://gist.github.com/zhr250/4439523b7ca3c18f4a2d2c97b24c4965

Reference:
[1] https://lore.kernel.org/linux-mm/20260303080423.472534-1-zhanghongru@xiaomi.com/

