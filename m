Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A35CC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FDFC6B00A3; Thu,  3 Sep 2026 08:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEC06B00A4; Thu,  3 Sep 2026 08:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D9B6B00A7; Thu,  3 Sep 2026 08:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2FA56B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:52:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67F95C04B3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:52:54 +0000 (UTC)
X-FDA: 85172440668.20.D8C4121
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C3B240008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:52:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AL5KBfZ0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788439972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/BVphZoQ/SK9hU1QtOXRTarKJyoDJy/tE9xK1PMEI4=;
	b=Z8HqobB6K49eLPeVXAFMgiI4WzizbmspDkH1Sd8NkkdjiPcrWP01dSuTHnJMNvDj8phMjZ
	lQOZ8ybm888JvJ4v9iTD4e59MytWFF9SPgslbH4AsxHWLAl+KndkvcPsdEDaB0qMZN+O5u
	phVPmtUtTEC0QmJFMN6wqYOdWdfp9n0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788439972;
	b=m98lS5t83I8uJ0UhUMVdP3jLCNiSI88Unm92S2SVUlu7gDZUkXnrNyYwfyG0YxRFEoeYKK
	S4LrsmPusJqnca27Kt/wYIJoraSrSRS+hFbPOHl/cUJ4UxGkxLHAxWZBpVAsnDvzkJaxw9
	2r7V8i3sXrc2JLMnI0kzGry2sjr04+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AL5KBfZ0;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b8687630fso19864155e9.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788439971; x=1789044771; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O/BVphZoQ/SK9hU1QtOXRTarKJyoDJy/tE9xK1PMEI4=;
        b=AL5KBfZ0vSs6XHvfmhV+97W36aUkd+0LWemnYKPSgmV+Z3mXV2xvpNRCiIlVBvt9th
         SGfIxni7G+hEUWM3d179DXWz5gnsTdxXu9bU7DzGU+ilHZCytO83/Ybo8pH9wOy0synC
         peTVBr4/Mx97CxTqp/9wuBf6eaYOiFnNblKoH6ws9iH6YJql3+j3V/9I7vamEoHyaaCv
         ByDCN7smtXpduX/PLYeYK9KXR1oxcJwygHLl8DHDr7NODTY3x+5gTa9jrxHHCxj1mJT9
         2zc7d1UA+awZCLlytJLiSQFNla5WsuzZt6bML9XHEz+sxp5DC1GdEV3Q2Pdcke9TQzmA
         8SgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788439971; x=1789044771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/BVphZoQ/SK9hU1QtOXRTarKJyoDJy/tE9xK1PMEI4=;
        b=c9N6GKJMsuNefQr9jUWwBiKDBqdTh7PX7jSNByukQ10CGSYzBXG9yz3f6Uiif97JCn
         g30nZeyM4kctqJr9wzO/VCypPgwx9TEwz1DuRDwTIlyXaV34Fk/mL50ZJQq0YWydBLhl
         u/Mh46iDjurWj4Wd5G5T3NmSPKgJ3QMoIHMYGQoHYVprZGCQZUbQb+Z+CfGq8KmLrz+z
         QrgOla9tj1RioJz0JcmUl42hQ+1lMBSGB/n/04OIIccuT8YvfSknnrouDAvHY5g4Er8g
         bn3oRtWgRL1US9WYuF3XJNHquM2z4/hczpF91oi6E9w4K2wOoNDxjjJnG9b2S7ENejNg
         fvLg==
X-Forwarded-Encrypted: i=1; AKwUvBzq22nc58ab3HBTEMFFZFJrLNLqGgpotniTQ+JkncvO7fFWLggWkmilxe8cg8m7tlM6elkBhDE0iQ==@kvack.org
X-Gm-Message-State: AFuF++kcv0fjChBsQpTOqdDT+cqYjEM1UDP1Q5Q3A+fuCSl+LUO8hiTQ
	JjE123sS1yhf9rWrGQF6kY7CBuck0VgEvCfp4hxad5yKc2i6yICbnkmaSKjBkVsyxCE=
X-Gm-Gg: AYBFou0fW7w0xupH1Gqnna6Lw4fBeP/NlAhKcL3MpB3BZYWEjgMN7nbPpqVRIdTuAIf
	FSQNS15AlSZSwn9pENZzBH4YyJOygKSfy4dVHPk1MO3vlBaGp6mWigaC+ktLDlD46VyrNR/R9LD
	ieaMRd7oqd+A8wg/2XnC2BmpopIdhyvcaaJOYNxxdYg2PvvP9HNL4y6Ca1OCVNlbUz+G8Bn/nlq
	stla/Xk0umtTxMW3gzDpZUMGs4rsSZRS47Z1ACHtpxouvdXhyw/t6pNQezw7dejEg+rDiMLHmWv
	ybl0cvQFiEsr+sz/sJ63WcLhW034Q2S50YOUbO6ePV54gir82n4u+qvfjtQxY3yBfRT2jq6keIe
	GUS6XmNAV/hbPuL+5ykxtUBZ5jxdWJ+SW+Ins9x8uhnRY1W0jTuqzatMQ7tfrygFRdT9G0Db5YB
	bimL/BLGX0cVw8v6kq36T81oYLHBvCKXSYbsWSt6vRAZbwY3YAK9AJCgtph0aTRIhlgPF1xihq4
	O8+4avpbXIC
X-Received: by 2002:a05:600c:c4a6:b0:498:952:e276 with SMTP id 5b1f17b1804b1-49ce581142cmr250223635e9.8.1788439970781;
        Thu, 03 Sep 2026 05:52:50 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d6029sm71680715e9.6.2026.09.03.05.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:52:50 -0700 (PDT)
Date: Thu, 3 Sep 2026 14:52:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <apltoauHn-l--8nI@tiehlicka>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902162323.GO3004@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C3B240008
X-Stat-Signature: 6qoyweem9otnz1zyb174ao9ua3pbjdwy
X-Rspam-User: 
X-HE-Tag: 1788439971-27098
X-HE-Meta: U2FsdGVkX18OODrHz3T82d/v22fXAPpchHQnZC7uAINg0L+iY/cNO4hbS7f8bSxR5Sj6fULtri9aSI8O3OETXxWNR61/EFTZouxFoC60JOW4GUuUhkiQl+YYXBoPvV8V9qlcJu7qkt3+aSViBqqFL4lGgwm0C0x+3qQsuzqTrJOeg3ZWLMzo2k2ySFfbExxJbUoFxk3CBONRPGurfJpUcniOUXu5NjTw7btkC2rdCJme3xqmonkknYUbrbr8JxyKIABqlMYFdrxInjGKab3xrqytzVcF81AegVN0ziIKIaF+3F3FKyq0nmGtZerwOo+VAUzVQy/xG9gHq9wIQJtG2239LhlQrqTKJS4FBTzqeMdwxNVug1/CcO8sjGyqJ/+6kVbe2i5gCzRQ8Ux1mJlE0MLlXVAurhzAkHW5NuVi22M/w21rO6i+8sA0oZ40IP3GSuV8lFxsEa0HmH2961BOGtj7kcBlnDTYBdNL1WENrqehYgb1CyoMsqvOQ5cDv4keEmkdgp3iBu3sUEwwuM6Eg0Bp6/NiKB9/lzFa87MAG1sVbZiJBLQYrWEfzMwymVbkQWkt5VyjCi+Z9dBLjZNDpqHlKCWcJRExZaLpv0fJV456IZQVDn/rwKtC6RE+oXc8d7d6/h1oVnCRxR4QxcPTRRuqjFeio0rXKWcAlsiKipqXnSs0q2l1pfIhSnT+2Kdt8vRSa7G4mp51358ClCdwEuRNfY58bNMcDfcKSJXGkkL4ZRUFz125B7QYjAcmuUOyGR7cPdCIpapqJKmDfdrylAfxmt4u/h9NnO2Ir/S7cIJquX4zN5Fzm1r90XauTyLE6m1zYkLK5/KqKuwV46Vycjx+pdtkiDvl2MMGXxUzqVLYq/Pp/iPoXA+Ilm0lYwdLxxC8mB+m2lb2rcKLzhEnK+FyZxcLW7ox1aa2rtsF5Ewn+jc1S6WGMjipwLaqJBPMQYeI1oKbL6BAVSpuO2o
 6tuZU8LR
 v2xG24BU95Qo+FgmghdscQ2TK7A/mmWUC65AvN1Ryf/edEsuhFmKJByQX9Xa5LTxU/PTfT0lUy+L9NOGPu3CnHUfNEtYuYonCVDMHdJO3ieI9WB5MVcxWeHdyWjCKgLThb//Pm1djw9M6+nsZhkJc56C415mtwN62Gp9ADMiFbjl+xio2qbnCvzRSScA5SHVBJPwjtHMQqpXN+DKwQpLCPPOFgB+TtqN3Ia5X2XRliO8QU/IugaFaeXBRfm/gRqrlvFA6OTT0pHzy8eUYjWwEbSie9QJSQtg2tsE4mg+xTlyWNu3lkn0BkHeO86s6FJPkvxk1HCEsTDvOIEH3RUcypAbUftGcbUih4xxF1GwbjKHD8vG81HXCDzWpfHQzZxZSxaQhEk9pO1nMlsK1KwqI6ELXvo8mDBbFu7XONb32/uIaQ0Nniax8UJk6Rgsuv8a13uG6lwdCAVNF0RGE8Q4FV5RlOCmGji0Aqj/7sAiwTVoEw4/Ag0eLGpP5oOl2kb+hYtomYGxFXwYebHxo0JT2DeNg3W/rCTIIUVWa1R8ejaWikuhOBTJPjislWBhqV32b4/ng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 02-09-26 12:23:23, Johannes Weiner wrote:
> On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> > When THP is enabled, set_recommended_min_free_kbytes() may raise
> > min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> > Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> > heuristic to help keep pageblocks free and reduce fragmentation for THP
> > allocations.
> > 
> > The recommendation scales poorly with larger base page sizes. With the
> > default arm64 pageblock sizes, the contribution per eligible zone
> > before applying the existing cap of 5% of low memory is:
> > 
> >   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> > 
> > Even with that cap, min_free_kbytes can reach excessive levels.
> > 
> > The automatic min_free_kbytes increase predates proactive compaction
> > and many subsequent changes to compaction. Given those changes,
> > increasing min_free_kbytes for THP by default is no longer clearly
> > justified.
> > 
> > Remove set_recommended_min_free_kbytes() and all associated
> > recalculation paths. With this policy gone, min_free_kbytes is
> > controlled only by the page allocator's default calculation and the
> > vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> > higher value via that sysctl.
> > 
> > Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Nimrod Oren <noren@nvidia.com>
> 
> Just to summarize my take from the subthread with Zi: the premise of
> this patch is to roll the regression dice on every THP setup out there
> because certain ARM configurations result in a questionable pageblock size.
> 
> I'm not against carefully evaluating and testing out today's need for
> set_recommended_min_free_kbytes() in real world examples. But this is
> not that.

I do hear your concerns Johannes. They are valid but I am not really
sure wht kind of testing would prove such a change to be safe.
 
> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

-- 
Michal Hocko
SUSE Labs

