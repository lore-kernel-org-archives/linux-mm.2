Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11C4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7796B00B9; Mon, 29 Jun 2026 19:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFD66B00BB; Mon, 29 Jun 2026 19:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5D46B00BC; Mon, 29 Jun 2026 19:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 964176B00B9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:30:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08DF9C18BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:30:12 +0000 (UTC)
X-FDA: 84934545864.26.3FC4E84
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 951E71A0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:30:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMpCN0Mz;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782775809;
	b=mAAOrHqsO1gQSPWX+KB77PE9sLGL07n13p8zEJ4u/fiD7Jng6dKVSulL2gAfvQo4yy4s5B
	oIFsvjeCYaDn8YwuW/YVyBhPhuwDXe8gNZIWmpvJSA1Ml5BBDaSrDOQQE3bWNpLq9L+KOa
	Yr5/nnEqz8S5Tll1Co7gHWmDrzCNSsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782775809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOB2A3Nx/t4sRU/lLAvGFLJpztA8K98QuH51mbtmEIk=;
	b=S/CYWHVeSmzvo2Tv9TkekMfs5XELkWQB65lPf/ZUwJwstev31Q/qHpKQk3qvN7wmtEZVEf
	RCq2IPTOf7i6546k2qqIyzALavEarU3fUIFSwniumdZ4C6BVbDx/gC+oRS53Xp2IEYO3re
	nTYWzRrloS+53Xv9a7xXv1+1mi8TLt4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hMpCN0Mz;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782775808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bOB2A3Nx/t4sRU/lLAvGFLJpztA8K98QuH51mbtmEIk=;
	b=hMpCN0MzriMMuOUSZulI/R+bUS5OJ5l5KevOtMGFBBCY+fVZTPY4+tcZ8GjwnEXqIW8JLN
	SkTISF+pmtYpT5qfsPR5utmHw/M+halnqxLDK0AW0eFfrJdChTjtMoavteRRtdxaKHT5zi
	tp6U0OYxmBsoZu5Ra9WtYpmsOK6aDIw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-J_bCrNDfPmu1tPRfVbIQJg-1; Mon, 29 Jun 2026 19:30:05 -0400
X-MC-Unique: J_bCrNDfPmu1tPRfVbIQJg-1
X-Mimecast-MFC-AGG-ID: J_bCrNDfPmu1tPRfVbIQJg_1782775804
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490c56e2576so26293335e9.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775804; x=1783380604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOB2A3Nx/t4sRU/lLAvGFLJpztA8K98QuH51mbtmEIk=;
        b=Yuebmxmutt1PvGV4wxk3I3vUO1b7yCrVHd0PwqF4DeaKYKv2YA/9NNHf5DXcGOXHoW
         UxHKvnQpC8siPJjS7KjSophZiIt8omEHD+l9/361VDASAWPC12HnQ8CD7pDqSnLWdLBt
         XYFUmXp2QblGTaqt2dnNJ7JESSGFBRyVP4OJo4RIuvMLgyJygEPL/hb1/eWxC0DQ59E0
         77wcr2Q8KFX9BwshKbHvo2NorlTSASqIyhJgxuB+pjV5GxhDpO9V24W7/Gli9j+fjZkF
         urYbMXCMVhW8+IKMTSGklG5Ar6H4MjIFzVn/q/mZWYy0CsfaFDc8EM8IB7mNOB1NlwAf
         lSCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LQOvHrieXs7uBAzFxLMfM8VaNynTCC4ErYyCj9a+oT91OhGGzIrFWaySwi1HDmdcnMd59NbenoA==@kvack.org
X-Gm-Message-State: AOJu0YxHyD0fdB4U6NEilVD6t/fiMk2Zwd7y+suT+z2Slm5g3Ii0H0RE
	iJWimYYTl+LqLo8WkViAdEwA5ezaQr6F2jrojXlbyTBI2MueqsInudnEhQZleQd3M06wMeOKNvK
	2sIvmUDQ02YMo7mHd6S1sxSkCttE8tvRpQCGNWCfkb6ChUpSt2Ywg
X-Gm-Gg: AfdE7clC1+qzUTrJIKwCKaPiA/oTdUET77BSG5iSlMaww9twDtwU3MVpu74xtE6aCFN
	bPlrAMnZXX2TwNgmNsw3TZ6woUuGkaidVRdnBiNeHRYh6JBE+IC4MAL8xGczQL2aGAmn998UFqy
	tVzXAJdRMkhcV33MR6ZsvomA7dVVu2fAYHIWUDQLLGJ2+FZCXypAkSRA5b7Xuuq+5c4M5chw8MU
	U6prS2OtnloiGrY9fjonSFMfAKaBMKNS76vnrirVDAnTbDd0kXYHWKTIFFKZC1rbtecx6Aifjw+
	fudwGBGinGQG1X2DEUe7uj7uC9nt2d1VJjIHLIggM3FPuS/Jqynenkcx21s7t/9XPQ5w/MS8U4M
	HuW3BIO5jdco/q3pKfvY9rtg9v4570jGM
X-Received: by 2002:a05:600c:4694:b0:493:a8eb:5145 with SMTP id 5b1f17b1804b1-493b827e9ecmr25267185e9.4.1782775804084;
        Mon, 29 Jun 2026 16:30:04 -0700 (PDT)
X-Received: by 2002:a05:600c:4694:b0:493:a8eb:5145 with SMTP id 5b1f17b1804b1-493b827e9ecmr25266515e9.4.1782775803560;
        Mon, 29 Jun 2026 16:30:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47563d195a7sm2001293f8f.7.2026.06.29.16.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 16:30:02 -0700 (PDT)
Date: Mon, 29 Jun 2026 19:29:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629192811-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
MIME-Version: 1.0
In-Reply-To: <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9Ix3ql0IP6MqrPZ8qszA8e60cVC78XNldrayzGgCBN0_1782775804
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 951E71A0002
X-Stat-Signature: m7cne41xqyczicrtebpgsymz4p5f4e9x
X-HE-Tag: 1782775809-138291
X-HE-Meta: U2FsdGVkX18Gc1H6Y3w88zfC34R6PjwxPnfHWbIKpI5XaMCDnTSPL1Vs3MAb5s5ocZiDahCvK+DoSuU3pFG1fg8rSPCuV2SaH2U417xVCfyq0IZAWx/Oxj0Lunnmuj+9AbPOyTeV4WDgZwRnKCpc99pioykR61fbAXhwnX4tH5HJc1Wo66tfBjlgFm1CA1aqB+BoN0Unr3PeJ0NTkDYKhKojcwZrPLrmvbaliPmbj0lkJS/Ifk8baNgHhb9jDjW6vZfWcvC3nRs65Ty8UssbRlgM2xJ9iAOOdxOfny5T9Ppp84d1RuhpIjQiVoNF4MLgOU8fxtM4nXLhxQEkoymGm8vUSwBnTHHHuTGotXHHipu0aZRHCcBbZJxU4vI+wCFZtVwZdm3Fnm7bmpWlCUvnuCMOAc2fTfvx/tyY3a6lnnjb1Fm7dHQn94fEg+De/MT7rI5rquXKy0igUXsdRtsdID/ZgkFJgxNrGQ3JS/nvFhJYwINerbl7YgMF/3O0BSR464xSq7d04yRA3CcTqBJQb9ixpcWF/j/wR94Xj7Ips6Jc+2vU3xk5vWHZ8SSwJMvpgasURcAEgbzvizz7jK4r31JdcVDxLJs0TSbg8caBUeXHHz+DlgzWNI3FeQaDuCguC7ls+IDxRugaqTFgtELgvRvsvBefeB45mg6a8PTNMv/7kIE4mQ9LQ38NMLIWmt8V18OJogX6ugUlFm4ODmi4hXo5QBBgCM4V3ev7rTgOpGsK5nbtGNRpUGcVLl5+66d/fNaUlM+kxA7R7vsxdcJOQL+b3++X7ORUFCGg5mDdJ5s6LM2IuQOmzG3/ANWmKwmk4VbeVsFGEvIBukie9IxT2HtZ16VzlE26WU8+d3Jhda5iMytXnqCYVou+NJYnQjIbP41oadz91qcTGcMTVUQVWwULoJqtateU/VR3kRL4uCbbmBRR8qHU0gFrmQ5vPSAv1xwtnqLLyEbAkJA5JHj
 yXznkAqt
 MeM9h5Ch7TT0oFyY+AOlb0VBIIIGXD3ftY8on7k/YqLsdbEWSbrssLOm6Ru3zxG5Mm+HM4xe2c1KiiHhWu2A5nspxo1SvqcvHFBeCqYWWcikVDcz6h48exuJg2epy5tUiwoSTRDb/O7Bmom2lsC7AB65po/m3Bm2BSlBIvAX7p3nAPPNGHTxJpVmwbD4UZDE3uyzFs3COIAsMY9qBETbwAH8zjto2t7BHSl3r2ACBrFbpJdDb14TMrqgNN498uKfYyg56BT0HfCZoEGl+7QXP0/MPOeg2CnE3PVx0GoHBJF/4hzcMh1jgmHDgPDfdHqcgaJVBo0PC2BUJQxtcSMrKB3JNjRGHpnkwjcpyQaHWSW8N12+k25eD9PXzCWn1lpazpJrxvAs3oM2yTzTRGjnDT+69sq/WOgM+OgpQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 03:05:18PM +0200, David Hildenbrand (Arm) wrote:
> It would be good to coordinate here.

Case in point, do you feel this should be blocking the zeroing/page
reporting work (which adds more non atomic RMWs), or I can work more on
that putting this aside?

-- 
MST


