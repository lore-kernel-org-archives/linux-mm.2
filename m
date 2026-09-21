Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF4AC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3596B0096; Mon, 21 Sep 2026 11:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74336B00C1; Mon, 21 Sep 2026 11:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A632B6B00C5; Mon, 21 Sep 2026 11:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD5B6B0096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:58:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C47D1C1933
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:58:57 +0000 (UTC)
X-FDA: 85238227914.30.C720EBA
Received: from mail-qv2-f27.google.com (mail-qv2-f27.google.com [74.125.230.155])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3B4CA0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:58:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NaXP2gZz;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.155 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790006335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMayVPzqy74wYsK2+s0iOp7Kd4xLwxOjegiyzaJMk4o=;
	b=HML+ybocScOawG1ZjpkVwK/2+TwdgxynRUTyABrB1kzgqbVSHFrhpIdx0hN8fSsJGuMo9C
	OfNVVzYO7ejjn+4F0+AKxp/U4npcVQz1Sf5UE0F32QYz1aotUGM1TmYYe7MoD2tly5WYY4
	SKgBsWWTiPrCspcgu9fda3fecQ56I3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790006335;
	b=jC9r5XQgy3wqRI/wa5ic6clfZ/iza+BYJpjXyhj92h7myIIqNB7mbzGjMlB0RPDmSBnt+e
	i5CjcgwHtYU6s08saYYx//f7ZPhWbz0JtSSvakd0RzDF8jEoPOIIMYjT5z17xDai3iUyLY
	eFLp+wJQICYP6lkkBNBdSEddcrrUdK8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NaXP2gZz;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.155 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv2-f27.google.com with SMTP id 6a1803df08f44-9104649a5dcso28690056d6.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790006334; x=1790611134; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YMayVPzqy74wYsK2+s0iOp7Kd4xLwxOjegiyzaJMk4o=;
        b=NaXP2gZz1w3WNa1yPoAEcY6wLWbzuXpiDh5yGR3ailOiV0uXK929lD/AoA/K6+NV5Z
         s1eerOng4Dodunkd+2t3ya4DVuEa6KnqxpIQ8g8OVHvtPzRrHVMWT91Ceu0wMiSgIJjP
         s45aS2mYmqAVaYyH0/t1dCl4ovf0/8KRFzG/7NV3HiOhrELf9KznhxDAuYSovSLPfqoo
         SaBDDxZncPRPGPwEFoYyo6fn4JnHkJOhifOZfyDZiyEcI9pVEy/rU4rxvTE+DyazX3jR
         wI6bPaQ3K71hTrvKI53i0Xwgr784emh/ZSRFUoGv49kGiMDVzSDJG4N5XuCvE0TkPwjs
         twFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790006334; x=1790611134;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YMayVPzqy74wYsK2+s0iOp7Kd4xLwxOjegiyzaJMk4o=;
        b=Ht1FsZXTRERg9DYmtPqOgAdoyzd4NZzKe+JJ6m+od68uNJfWMX/8JLxkrL7cG5gP3h
         HhSWW3Jt2l6oE4j/TwOVvrKYZ+XRFPRUFDE4GXt9kJIX4e+VNXxQN6rU4BemGT8f5f1z
         vfRqbE7/c5OeDn/oUlQ7z4Z0R4MRfmODAiV/LPrElf8bYVHxBUbFYdbHRKECnmCFMfR2
         KC4xboHMw3vJ02NksFIWeTAlf7knbtlXq1M6dAnnOUiGobt40uOgJBG3YzlipOmnevvn
         f+GjOG0Dr61222hgDzIbJ6zIqWYmDrK6iXR9kFjsI7jcdmQPMryaydxvBnjOkQTkpIyd
         /kjg==
X-Forwarded-Encrypted: i=1; AKwUvBwitBCgw4ha2v1TL7JGVljRJQIQhrRw4XG9JkH2H4G/Rd0qfI6HWzCht/TgEgLdwbBlQy47B/gAmg==@kvack.org
X-Gm-Message-State: AFuF++ktvNO0SQky7J2LMyZ/K72KOnfoGRlRbTSZfYDfvZlGJrVD1rOr
	YvZQf/2RiFfp0nJXOy4lTCRLdk28dTVeRd5FW09zE7KZyc7/IUy+o7utu1tGJTZ8scI=
X-Gm-Gg: AYBFou1f8w72Po6QcyABoCsW84jdN1xzuFHxAjjNw+gmwJzs9EfOwYnp3ajGgw10wUw
	dy1V6FtdmT5hpdLueZostBFW7cuCy4/s+d07OGaEJc7gw9cdLGsROIL5Kb23wiX1im0kNeTUj2l
	XXtSTOuIEovtJl23hyiuhPEzDmps4h/8ugHTyycXV2gmBZkLbdsqTZJqMM0gdwAq4KCD3YzFc2t
	y5eQAX58G93Hrw0/VzKj1BsE1cuRG8F2/WEFmU8scQERZ34jFgWjPa6B3d/0eAWWEdZHGY4zHgg
	b3eZvpkZvCpOqO824K5at33kEsp0SgDi9G09DW3FSPL2/Vug4a3UhYy7tP2WrJwwG53N/oEBJ7+
	SohqzixJ/L397byEoDC9TbgoZqdZScFSSMOqyB+g8p3oVoSKmY1IQ++3XBRazpUPIw7yEk1/EI9
	1G/7OlEAsGgjjgTBSLyyrpqpHGjF3ZYy/CIfVYQxE2bmFwgeUC4suyzS+luVmigSLy5U7ya9gsm
	s73rkY=
X-Received: by 2002:a05:6214:27ee:b0:912:6067:f517 with SMTP id 6a1803df08f44-913fc979c79mr11430666d6.46.1790006333775;
        Mon, 21 Sep 2026 08:58:53 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a86f62sm70283746d6.33.2026.09.21.08.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 08:58:53 -0700 (PDT)
Date: Mon, 21 Sep 2026 11:58:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <arFUPOi6gadAvD3E@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFFKGrpPwtTkoCi@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E3B4CA0005
X-Stat-Signature: j7z4961jt5dsatw3ifiq1n7fxh9p5o8j
X-HE-Tag: 1790006334-947374
X-HE-Meta: U2FsdGVkX188MGWwhkTEnDSzoErr+yPpwmNXhN2IqqsDieXSrsqs0dgZ720bWCev5tDFMG7fjIOAKvI7mmrt1cS2Vh5UZ93gAl8HzgkJOGIMdSptKLY0kWXlVEX1f9Pt3SVHcNZyDnzkX7t+L3LrlNqgex7KrZw9zyPSGbehXz1gmGk8YbqSE3nlxrd47MG1cPEdOHgktfkiJ+34wA4e7Uhz7mnMQ1c3QfwtpYpJm4mME6tYZe963zjoUdH9IHdVtMzsNCjOcuQ/L8AJ0sY/11FGSbhYYOvqYP3j2C+ljLd2pvwiRcVpmkejl6GrPmMyCX53msbdddViZkTI6fx2R+ZwDXzD7jQiYKVBG3Yh5nM52uLgQQFDoPqBRPk5iSCvmgw5rg+fLaQWggw3oloTAjx0FBzAa7Ct8tpg1FUbIIEv4jHkCc6jEtOnm9DwKoslbxzYA2OxQmBgjfFrafOueEirIUL90KsO+XsvATlAHgkQNpvbcGcGQOT2WeVlH71KMY69a5du4ZCdwjPYCQRKenPz5HoArO4xaewKiqVOL0Tovd6W3JP7HWfdkppPD9cORYqyr2hjuJoPnSDgA6fdDJssimIxXqAhZqMu+f0Pc/UHzZW5CqZ+2jBQuGhLX0Y2mObCWL464LvHTvv1nGO9fJZpOMdknko7+FgNPBjcl6HOMwDivnbbVh3wguKNvuXQ1vMYpHu2nM/ji8i6ImlMzV9Iw8HcEL6XJuIkS6nMdPJeFEXxYLxbO2q4Aod4HcPtTkvm0g9N949ZENJnA8B1/HKj1TRK9Z0Bff2H4WDK5e+R0RjGS8zy8o0kQ/I4uhtmWETFbhdhZh/iVfhgaIx/QGySi/7UH2MJgiaZBTSaOxq8B98MdS0bbkKCZXZ7msk+ijDzqbpm6RNeCplASQmr5I29ckMNL1nhhKJ+NLd4hIvPGbnYr6Iq2AzGvZEfU7mMKvQPS7Y1mxX3hhqhl2a
 hprVNUMV
 aaRzk5XnQic6kuSQUM2RChnwEC0IAn0byuoE1uMPgFw2C4nm4lkuNBgBnSfhggh0DFbsBr3+kqFrTagGGM3OeFT6DPIEQuJ9RN9UHpmsA2Ri8WGCSO19M0re2lwz4rsHKANpx25GxrwTZLTi7rS98/QB8qW8EtMm36bpcmrshPgY1k+9wN9O669WaCaTGMDMUp/FSFXggjzBjlVScx+C2R0XBNzRmdjBWLzwMPFFgK4wOZMmNeXypbfZ/WHxKlxOU7MiKHtFAw0s2Gyx2qrt00XQjwBU7x/uyaoJOL//dQm94ITbD1QqwBfz5YG/mZ1y00hUFYiYeUHmc5oyG+JfNHoDtch+eDIm0bSZ3jhV/x2rqYLmMYoVf1fDNce4tHK63/4DGztFs28iQmaM52TN6Kz7OQbB+h8kANQqxKcyKdOeXT+orrcKUmRxKO06YGeU07t734Pl/3mfZsNBOq9KNewKR1AJe6QstbyrnXI+4i4C0pcg3K4j1S7bN+2Gfid80ak1uEbXuJzEk7pdWwsBoD0QAuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
> > +++ b/mm/page_alloc.c
> > @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >  			 * reserves as failing now is worse than failing a
> >  			 * high-order atomic allocation in the future.
> >  			 */
> > -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> > +			if (!page &&
> > +			    ((alloc_flags & ALLOC_OOM) ||
> > +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
> >  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
> 
> Would this be slightly neater?
> 
> static inline bool may_access_reserves(unsigned int alloc_flags)
> {
> 	if (alloc_flags & ALLOC_OOM)
> 		return true;
> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
> 		return true;
> 	return false;
> }

I tend to be hesitant with single-use abstractions, but no objection
if people think this is better.

