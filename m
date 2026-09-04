Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99ACC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5836B009B; Fri,  4 Sep 2026 07:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65F96B009D; Fri,  4 Sep 2026 07:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BDC6B009E; Fri,  4 Sep 2026 07:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9310C6B009B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:26:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A2D51C2F9C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:26:24 +0000 (UTC)
X-FDA: 85175851488.29.2E8AF7E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2EA47160003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:26:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RFrqcsAa;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xnmnnz0v+/7VeH3rMzPKT4G/XBuKYQHbAvKkVS2pseQ=;
	b=kxgxVn470117l/FjXQRJ/qIOqzTRDQ4IFzXYktcQol6hm1BkW997P7uwxAfMcYkFAPeQjG
	AaMSfCSSCEXrJwHpZ3JKpRHouWV3trB9hxshFhxBuQyypxI7doMmR9rUjWkof5JG0gygvr
	geb2WJx+4M9RZiaglHfQPvFi5YAhS6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521182;
	b=uox6QjkN9+w9MeHEz9gjehR9IXgYyC7U+u4EeDvqhqjHbP/JpM/14t1T3Dj8aMVMqggm8y
	r2Ml3bEGsHOCRk1NeREwgHRV2y7+iA4NWiTG9F3m15fxQ9RvfzLZEL2FcBn0Tgj3+6ax1C
	u9opK0XMq5ojsAbkEnquUNmkdKGeujI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RFrqcsAa;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49557167508so10240105e9.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788521181; x=1789125981; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xnmnnz0v+/7VeH3rMzPKT4G/XBuKYQHbAvKkVS2pseQ=;
        b=RFrqcsAaXBxrhbWz1F0D5LoiwCBtWBjzgF+MVFMjKAsfP/JJVBrj2x+nl/6asD7mF+
         vH2r2dfbhVnnMqOaeHjUue5ye3g4Rb16nmQI/uczBqT4AhrzDrXeA/vWGZqcIamaK0qS
         WaG+LhHPW1ANrVutkQJWmnq0/7+supHXogNDuMNHGd0Y0XXH51W10Tm/D1uAg9TgcfHz
         vZNk1G0mdXPxqtt0lG+KEgmpyxah/DNAix8VHY67AY2jC5v6QAx6Pm3FAJwZEwy9x9Ji
         z+XGi7YsP3LW3+ykdkitjTC1r94WI6J3jvzOmkWqwpiqjuv1u5e2kP+QGngIHvCxIFBu
         0bXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521181; x=1789125981;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xnmnnz0v+/7VeH3rMzPKT4G/XBuKYQHbAvKkVS2pseQ=;
        b=a/wgNsK9cSmnSRDgZJTl04zBrhYpvdD5dJ/eIpNK5IJ5EygD+LXpK5wXt0U/MKgpuV
         7XlaF/cDBIPJe3RVSQs1ileG2Mifen9y/mAx/EvuFSrij3yywkzqlnaaMf9VW3/09G92
         MNOB41xO7bGKQaiT/ZgtP85ON04PN/KNOIvBHXIsuVUhj2gKyi38YGqutr8f+iHSS4o+
         IGZo4kaUB9KGhUv2I3L8mrFHzIjvgU359w7sU0ArABwja8NppLkAU875TlRroqKx154p
         n76eWTzVaYDw7Oo5A+hDorXjdHT3DPSWYZjl8kp6U2RHF8cMo8WWG/BcGrPn0l2UBDKM
         foIQ==
X-Forwarded-Encrypted: i=1; AKwUvBwWyGQs6wLCu0VTljNyuisZlQGfLOidkqXDD6cFVoLdN+E/UkuLLwbjX+Gq8WbZX5GlgbQhUeoK7Q==@kvack.org
X-Gm-Message-State: AFuF++n/F2iMEOLXdA2PDAl8AFVtvr307bKH83YyyFMRGNcmGcoVaHz6
	Juv9UxF1wsnN5unWjQgHcdrzbDDlQfP9i4x+RlxacmbVx9hOVJC7q+pkzl7+F5oMM97qNlLMi2W
	aBwODRTI=
X-Gm-Gg: AYBFou1bA+UkvdGquqHBzaqJAHyusEA1cOX+g+7a3yEIQhMi8SlHHXQiJZR8P3znGN0
	pilbVmx7K59iuXRPbJY7sNT+txW3EJxQfQtJgBwR4og0b72fg9zCo4LKqHKwBl3giYnbMcXiVK8
	LpZIYRoJauRy0qjnnz+onaHDBVbBB1/diDWP+UcjnQqZZOAENF5PNGsEbXhpm6+Io2MUWd241Dl
	vUsFwBPhgChZOl6K6kC4ffNWd+IZJUVnnzLZun9NZ22DzwJRQPwJ47DYvQFB6r/ZsfoaJayYUjx
	PXFKOBvfo+QPr5aaa+9VuzCw8sTyCCeydhGzAsKrUpQ39JIF2TA4z4Unki7od4ysxaB4ssZ8DoS
	4viOifBQyik3kmNpkRJWgJ1ABaUvutXwtRdFnE+MquJDL5x39hzjqrsHiKrRxLOp/I4tiMz6cEx
	lMCGkkfdMaOBAjlnjVvpavnyv+H6nbwFlDQrDQzwCrlI2TZUvn0HDf0bnFCuOE8CLDUluIDmtjj
	Q==
X-Received: by 2002:a05:600c:6087:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49cf81e3454mr91305315e9.4.1788521180735;
        Fri, 04 Sep 2026 04:26:20 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm149377045e9.4.2026.09.04.04.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:26:20 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:26:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Stevens <stevensd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apqq26054VDli46J@tiehlicka>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
 <20260901142552.GG3004@cmpxchg.org>
 <apbyZgB_Zu-DK8pN@tiehlicka>
 <20260901205946.GL3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901205946.GL3004@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2EA47160003
X-Stat-Signature: 3qgpxso3ehmaqeizqgo8kbirr41am4hw
X-Rspam-User: 
X-HE-Tag: 1788521182-64992
X-HE-Meta: U2FsdGVkX1/sjEjtofekl4/fBp9Akgb4j0p7bWnE7ZNF2kIFNEOv4DP4oz0rtW8aD9QGvh1Q8zSRBjS2f4kFFV+OQ4wZNh8ARCpswuycvGDmBFjTwVZonnzpDSG2fBSUXWOAsPK85XfUT/V4C76xW5rdpWKMje1eUOtcXlVSQMw868f40XiZbxPkIJC7Gly6pF0pWlIJXSCSdbVGmzw8VZaN77rcpSLkcie0XwWRo/qY1+9qq/Qr2CK+Yj6X+29fHIvHEOHz7cgTRfZB7YeVZJwvKW75NlKkNuu2dBZaIcr+/LVTA5WFNG2Oigy+wY/j5QYGSltrtWRWtl7wqVYPvTVDdcnHi7AZEnwcLEBDTAZyVzvBVuvXEJ1tKeQnW6i6i9/VZSskDqGG2nrjZ2OJXWQkMs1xMvVjjIwnhDVvPV0EIszbSbg2oCthJ3UV/jpGHO4m+/D+wUF20pCqvhwWhUPGhyzzZINVZvR76qf/DvUd65im6bIBeUR/0ek+Ys5+3ySXEFccvXKTJtA1/Gm0q3eujgoQmnkFyWqtqmSyZyIoO+YZEjUTs3THOf5s5sG8lniumyGHRe7VmW53ziVzO21T0RKnlvL4jZ9tY/WVaSjc3p+SmgbxPSQow53DXo8Xu0tRUV59tDdH0vdqoyLpC/mg0vEn3E7UH7TqkehXo8owJMtOpLpdk2BI/IgjoOk0RPgnWVZaGXYDhA+atC77oJ83W7PqoBYeUk8eP1NGON6gokRpvZVbwIshCJTB4U6LlaagieoKpMrUjCj8AU9LR8a8ig2sEke/tvCzFTQyh1xlsyOP5aqJy/vUa65JEPCMZ/EpQwGWfGQTCcLV6UHOYfwOG616FbfrzlVAbLbDoq9/m2lh2+pk6qThGL7/6F/6Q18Fln+TB4jy76ZukC9cnh/PPrFFzlt+xouJA8k3POELRjq8Q2ov6FQCeqGqEnp2A0lO7Fq07DtRMtV+oPE
 RT9JhdP3
 LIWZWOKhMhpn5aajY/X6SF5Ac3GYKXNrFz3LsVKab5Mgpz1YerWqNW69EnP/2jAUvts5curp+tltYatwaYiabbsAxBmLJqJgTiTNH0B6hwjHcABeJAzRdXJL9tq7FGDCbB/jN7FHFvv+1myWYx3sKz7wjf2+pePVDlT5QRpAc3V4newPlzaMgH4ZebxsGL2oBA6Gh50CtuTT8nHoH3TLruQZI37fc2kKuVukC6m74Ux0ZeMZZiRs8UDNqXAZr9UuQ4xrAaJyQYypskSWYIKmcbfk7e6xf3fSeg/F3qdhSGbKR4DSktwph/qBtS1rpH4RsLN2skLd2ojZEd82zYckIsFUYJIoZNTObpKdYREY/UYYrjxK13i+rLcFV4Lncm/HIOQMiAAuhc+RBT/qk1yyusSBB1MYRsF4u1f4cOcycVjqNNSHRWYwlKU0/dpxy5+GoHBPl+Nh8GF1Q0ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 01-09-26 16:59:46, Johannes Weiner wrote:
> On Tue, Sep 01, 2026 at 05:42:30PM +0200, Michal Hocko wrote:
> > On Tue 01-09-26 10:25:52, Johannes Weiner wrote:
> > > On Mon, Aug 31, 2026 at 06:04:57PM -0700, David Stevens wrote:
> > [...]
> > > > There would be no guarantee that memcg reclaim would ever be
> > > > triggered, which also would also stop MEMCG_HIGH events from being
> > > > generated. Overall that seems a more serious than just dropping
> > > > userspace notifications like is done for MEMCG_MAX.
> > > 
> > > I'm leaning that way too. It's an indefinite error, and it's a freely
> > > programmable surface.
> > 
> > I am really curious about the indefinite error side of things. It has
> > been my understanding that these NMI safe charges are a) rare and b)
> > there is userspace running so eventually any discrepancies would
> > resolve so the excess is temporary.
> 
> So I think the question is what limits the error in both space and
> time. When you say it's rare and userspace fixes it, it basically
> means the answer is: luck of the common case.

Right. I was asking because so far we are trying these allocations as
more or less trusted (we do allow them to breach the high limit without
any pushback). If there are known scenarios where this could run away
then we might need to re-evaluate that. Async reclaim might be just too
late in those cases.

Anway...

> But that doesn't help the worst case that can be triggered.
> 
> Like I said, if we need to have code to handle that !allow_spinning
> case anyway, I'd rather just have a few lines of working code than a
> (lengthy) comment explaining the luck of the common case.

Fair enough. A jump through irq work is not that bad from the complexity
POV. So you've convinced me

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs

