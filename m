Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1F3C5DF70
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 13:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAF26B0354; Sun, 16 Aug 2026 09:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C616B0355; Sun, 16 Aug 2026 09:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1BB6B0356; Sun, 16 Aug 2026 09:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22A3A6B0354
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:58:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A3621C1886
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:58:11 +0000 (UTC)
X-FDA: 85107286782.21.A32C0A0
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4ADEC0003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:58:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kueHDcta;
	spf=pass (imf10.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786888689;
	b=dw02fwonwsZ8vBJNol8U9JcgJF27oL20UJoMK/gubRwpelhqCUjQZqSAP8XTyToTkntbHl
	4/olYLv6Jdo5QObNVdFjaZqIKVoNfEiTFWNkCoC/6/mUqaf/rmO7XkWVn6mZKn3Fu695/K
	+pzoPfM6TF7xsR3Q+J3umpkMD534Nyo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kueHDcta;
	spf=pass (imf10.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786888689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fThRPUBNCrqFeDKJK17T0YONc4Gpv3LdKTE6Fvw3mI=;
	b=3KnEo52wLxUmlzIFTALjnxpAc4Ry8wpCefh9uO0c982hd2W8HowhF1aK1o7AZzUoKkNRy8
	COYOKyETb0emZqd/XvGcx1D+mVmYqCN6bqeQAh6ImsY2B5Aty7ZR2tS+bGCIgWU+DJH2H9
	JUhZCBvrfBrejEl/Ka/EIyTh4nMzBAU=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2cc61541f8cso44359685ad.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786888688; x=1787493488; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/fThRPUBNCrqFeDKJK17T0YONc4Gpv3LdKTE6Fvw3mI=;
        b=kueHDcta54MVuK8H9f9kl9qUKil/7ZNEiZvI2CDWCUUFxR3MGL9zNt73PgVJHlKKTf
         LRbai9ojxiGkEWxap0pAxJgeJsACqzPAPFOeJsAaHl2Cj1JdYESsr64L/0PSaWK4o1w9
         0zWe+WXiBMTAqEh/VMVD/lSy2Y3IHadY4rKbvvBvtqvJFBKG+6eJIpl9fYT0DV0bZJ96
         ZIeiQxUcKHqWJOOHyywVRottu6Sy78Xr8jDJNOzNw/x5QDrNbVIi7+KtYNjAXJI4TDg9
         c4vcQ/GLVDadGKSMaNVIxuL0dAqV8zTwbI+l/D/cwDpR7Oc87p0A/NMX8dcMQOkTh9bM
         h6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786888688; x=1787493488;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/fThRPUBNCrqFeDKJK17T0YONc4Gpv3LdKTE6Fvw3mI=;
        b=O9BeKQQuGK4roo4KbBuOtAD6NBTfYZFQujBR2UP/wWxRco0s8UWTlKAIw/NV1J1IzK
         W7+MI9Nhfwa5yB75P2X+0ceRZByLPaMeLTVC39+h0ULe7n2eu8NGSqVvXPZCJqAgRY5f
         8jcOT2vKF1Z4yhPk0vawPifwho4m6cz4kfu8e/TNMqVMP34qclcif3fEjefURWo2iO3R
         r+uFKWIIsr3gTqZd/r8zzbIdjFNk4q/qNgMEDtDcA0x5DAnXSlEQfGUnpBPoGq1fLMOE
         rdMH5Maomsxct+6/aDk0jbccEPTc/MOWtDwpYrvUtoV6H0E7I9goKqO5zHvjgdxi7QBh
         gH7Q==
X-Forwarded-Encrypted: i=1; AHgh+RpxDbPcyDZru1eHb2TA/3G081JefQgdyp1fC01DQqHWGAEwTxtUjtY39GSVlO7+8CJ391/UtO0XmA==@kvack.org
X-Gm-Message-State: AOJu0YyQxGDiawihdXwPDmMG/opeP6fDQlNGyZL5sGybBpLaRfE6MC8k
	bpSBNVPtd31IZ+EkrARXW02Jd10+eFHe1j3Bcg+GPwzTggcxGPuU+a9Z
X-Gm-Gg: AR+sD13gqqbIFsDfn3j4zqjOCo8kPVPEspKic8HgEl43LKNzLxLpakMj7V9dGWh/TXG
	F+3TqAOXXYAxjp9vDPSDI83lqaBuLBwEw8QMbfTJyQ+6+ZoqKwXVvk2yNW2weR8pmdk3SiKCEwC
	hV39HzmMNxYyY8lmmGNuuebReK2fjdeNl15bJkDD+uRBQtZvhI5JLk8pFdpQyzi7sSHrzh7BCOv
	O/JVIPKsleLm9iyIRJqsHK4CULnh15ZOdk6OeKu3sh2hzfVZyVR5MZXtBpNm7XKbhOH20aIY+VR
	ONj0kk1uTJE3TKi5m6kLXFCP+IjjXkZSwA0MbMQYidGW9bS8/3k5hlo922ClH8p2UFp9FrHYaLv
	BicsB1KU83DxeXxeSAlqPK5qdwNPSLlJ8+PsK3UyboGEGx8F9uggaeJ2Nc+wMBmuygGTUO6cRAT
	urQThOWZIIZAn7de7w38TeTTZJwsc7Gvrh0znq06yWoO3SO9ZEpiQm
X-Received: by 2002:a17:90a:d005:b0:36d:b12b:f57d with SMTP id 98e67ed59e1d1-3931f581f38mr20607364a91.12.1786888688422;
        Sun, 16 Aug 2026 06:58:08 -0700 (PDT)
Received: from 192.168.1.2 ([157.85.198.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387e49d3sm31515973c88.7.2026.08.16.06.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 06:58:08 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Sun, 16 Aug 2026 20:58:04 +0700 (WIB)
To: Mike Rapoport <rppt@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
    peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <aoGi3g9AlcG9EiyG@kernel.org>
Message-ID: <f6c5c31c-13d9-801b-cdff-09fa8333e419@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <aoF_qmSHiEgujaH5@kernel.org> <69522f38-7e5d-ebdf-d42e-11d822bce662@gmail.com> <aoGi3g9AlcG9EiyG@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: C4ADEC0003
X-Rspam-User: 
X-Stat-Signature: hi9baa3ff6pxyitm8gysdqtwrhh9x1bp
X-Rspamd-Server: rspam06
X-HE-Tag: 1786888689-657436
X-HE-Meta: U2FsdGVkX19ImSSp72bvCCvFTC3PcdjwE2MlQU9mP9hTuH+rYJui4YccImscMVxCVgwz9ioFVuQPnrGjMA3Hm3mwA4AKAeiNXq1I9blMRhN9dYxhjhVbQF2kMDWSyee9K1Fh8Gs7vH+99DdpYiQXELjvawZu1ubQFrB0U+g8QLe0UEGaAExBnnVfP2NLF0ijmIY85FdNxuzzNXdfKQEdg9MGWFf1M00Avi3svshnmu/L/LQvxjygpvNnycIojLLkc4mvVLmT7QKcZQ6IP2Dfw1ZGk8JS+id49A4QW8k6frhT1c6FomFMP5snfeNVBDapUemi9bT4s08h1Ahv+PCv1IjgN8xROEAbKAF0Iv6mc/LaN7bT7zo7PSI+LD2cGlojPPkdvhpiw5G9ZYIK9g9qm2pbho48u8OsqKhuMJSSLOEWDjU37Ofx9oh8vuMyxKsF1BJV5m1+nhY6s3Za7AvH7von30HPx5N6K6YONCnDccLJMfJcohCCwCY/8brIuMZSyxpKvJOIyTJecxdSU9p4wEhejRMvquBpHiFRuX4kvJ9Z83hoforhUs8yzU+dTFkWUHQkZMGAbUBbc6HbYkWmR6Viw3B+xpIjK2KkhF/CCsXJwhdoId/5kxNWRtn9m8DXkkBAaz25/2R6vYgXcekrvSo3Efwb/1rCtd+mSiYvVt7CVOJL0i/94MHyJ4Di+SV/R6/TLHl9OYh4YxiSJ92r6PT+e+K/DzeZ+JhUpoLQkRkg4Ah5vQZ8RsIXcyWqOIBxZIsYpsHp+GJzljB0sJNQY/hNZLdVcrlBnOTLmlHfQjfDyU/qvpAK+WKA08a6ps8no36NZKrZPcsHPX8f77mo3DPaewJCYewG0VxVsw+XArNGMg7Ir3ixt1IuKmnm6vvjAmUwcqfKTegqkXfNWlVakfbLsaOEoSVGjqsiVvQtdWuxskvEk7IBzxMArJNQm4sqrdT5SBar5wVOT+IgDOd
 MiMWZAHi
 7khiD14UAjYPZsLQicuf9MCLGr5DjWpMvzHHgsbr5bxsrSnB+5DAfKsH3vRxZsC40W8HG0urBy8eYla/AzxemgqiGOWC9cO6FesOwW53R4dTz5jZrFst48ASryNfqKS//sg/t/AZ+Iic8ycWOSFlOyLd7BIHaTGOv1GXTWuO0J1zKCrPJNk52g1RDnBrh7s4Ej9RYJKgP2RCYj3Hon1WKins9ZvP5VHGt+19NBdiTI/ImLVFCSD6Q3vPcAmHIS+nkUvd7FSwSgdsG1YGdKIWorli1Ps4d+uK6UtqKNc3rgAGAXq0GhheEt0tt34jXzNMnA8WBfDKzrF9IuqMz/yZmLBStd1tYs2G2z020smAhRsJ8UMAy5y5LzomF3M6Y2wstFYr+dT0NtIFDQ/kNio+pbZGUuo0pEVREQyE3MJZ+vYgBh1vh6hkeXdreHWwvmXFvu3oGX0SV+TvRzIxy9MyyYTqx1cTS+0FFi9Ss9f/uOqugnOADNUO3l1+9NyAB44ngn331zmQfYedqC4TOzjD+DDIIEL3ubZL+Pu7VifyhBoHwAMwTfWMElOuhdxt8Dax/lqQIUsWnzUHuM8IcFym1tVVO4nyqPLHY9k0FSbqfCJfzbgxRej+8FTjB6pyViqn0uG3CTmT7nhUYH2OD99n+RZCyZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026, Mike Rapoport wrote:
> On Sun, Aug 16, 2026 at 04:41:07PM +0700, Foxie Flakey wrote:
> > On Sun, 16 Aug 2026, Mike Rapoport wrote:
> >
> > > (adding Suren)
> > >
> > > On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> > > >
> > > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> > >
> > > Is Foxie Flakey your real name?
> > > Signed-off-by should be using a known identity (sorry, no anonymous contributions.)
> >
> > Thanks for response. Sorry, no. A question, by "known identity" there is it
> > means my real/legal name? because I have read a document about Signed-off-by
> > and because on internet I'm known as Foxie Flakey in multiple places, I
> > thought its fine.
>
> It does not have to be the legal name, but we do prefer real/preferred
> names over nicknames:
>
> CNCF's clarification on DCO explains it well:
> https://github.com/cncf/foundation/blob/659fd32c86dc/dco-guidelines.md

I see thank you. So the Signed-off-by would be fine as in if I prefer not
to put my legal/real/birth name. Would it fine to keep as "Foxie Flakey"?
Because I have just read that guideline, Foxie Flakey isn't anonymous id
nor false name.

A small confirmation question due not sure with results from internet about
where should I add Suren. I looked that you placed Suren in Cc. After the
initial To (your first reply to my mail), on followup replies I should
place Suren or anyone else to Cc filed after initial To, am I correct?

