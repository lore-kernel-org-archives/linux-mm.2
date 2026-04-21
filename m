Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37FB2F8FA6F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D256B008C; Tue, 21 Apr 2026 09:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673E46B0092; Tue, 21 Apr 2026 09:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562CF6B009B; Tue, 21 Apr 2026 09:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 479786B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:03:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E726B1B947A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:03:26 +0000 (UTC)
X-FDA: 84682579212.08.1EC0CDE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4CAB31C0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:03:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJSKJC6E;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVf8kdVYwRFUCCaA8aQHSDPXaxh6wDEbfv1fdU/ML/U=;
	b=U5gQZgcGehQ2iGC/9C2OmgR7Q1HX72jspO3coU91uZwFCNEKS2THTTDgtHsUb4u06JCE8M
	9n9ylok3IwBRKXD+lLkS1FxFpslVGIIjaLzJCo/Kp4zgjTx7TfeMnwwJ61dJzvYuV4RYYW
	OACVOjPQTbxRy+RN066B5UbA6/uvGJo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJSKJC6E;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776604; a=rsa-sha256;
	cv=none;
	b=DdNgDnUengsLdJC8k2vk9G/KpbGO29ATCqKEuJImhyJ9eKRpM1ysPkFoNfnAB2C6U61WTA
	ExgkzdeiB2WCJPpEGdEIuFnDzO5Zqnj+rzJCDZcVvb1Cn9BfEAwc3vyHmZuEtBRxKJy8Hs
	28MpZ0i/c+gjwIDov6EnjIg2OrGLKhs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776776603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sVf8kdVYwRFUCCaA8aQHSDPXaxh6wDEbfv1fdU/ML/U=;
	b=GJSKJC6EhVg2eT39n4ZeKkF4GVwQdO8ZI3/KvpZ3dK5Fkq4zkl27ryaIrRvaxWaLz2VP3T
	ecqc+OkpZo+Cnfrey5xTHOt/Qvc0wTEoZkpxvvTsmBgTBZoPxIR0ypTUI6QhDziHKKhtIF
	6WLGSdOYl8tZu6jMiaDwfiLFnNbuRz0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-5wjo3cs8PcCQv-ZMs84X4g-1; Tue, 21 Apr 2026 09:03:20 -0400
X-MC-Unique: 5wjo3cs8PcCQv-ZMs84X4g-1
X-Mimecast-MFC-AGG-ID: 5wjo3cs8PcCQv-ZMs84X4g_1776776599
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488be33b7a6so30104415e9.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776776599; x=1777381399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVf8kdVYwRFUCCaA8aQHSDPXaxh6wDEbfv1fdU/ML/U=;
        b=RvQSo1qxAW0C35Hm+t48XIXYY+SlnCHzOAAZ8Gk5aucEe7tmI6lYnRSjCrHi2uEy4o
         xl07Vvmqv3V5nyFDaLfHjgCpwg5SavhN6Xgba/a51tnTwHzBfYsclH5wBkBcB+Obd7yg
         DFYRL8d7ZKOslFgFxKX8up+9jlLsN9Kom5MQgIQ6B9j+t20YvXmEATwyGYgwVOtazuZ3
         BhD58d6eTkZXK2vN+jicZLJD6dEp/c/eRGq/9Mz4qLPd6UJd1yDzfUsjKYn1qN02SPnr
         yKvJPVmzNBa1V2kkSBkrshzS89zyMKbIC+XWmGDthHdKfTLStsfytTyqM5cCMifyV9wR
         VVsA==
X-Forwarded-Encrypted: i=1; AFNElJ82aBcUK0T4iIfUOD92nayJVg17pv51H4zrrxC7v8MpmW83BsXfV9ZalWZom1VIzQ8IHrKulKmdnQ==@kvack.org
X-Gm-Message-State: AOJu0YwN7Yk+en/7vOerkdILOvBMwqf0Q1LNxjANdbvODmAw15rIYO3Q
	0mCD+jgCxl47gQjCZQ6bCaSbMZbBcHnSu/ZYeg1mt/gVbi+7z9OUT6MiDyhIAREY89lZjgv3jYq
	OnoHRwqosOYrCaOE28w7O2xA1aied16o2+9KrcdAnvk/EuxjnsZDa
X-Gm-Gg: AeBDievSu0yTFtCAe5TQJ4a/Lrvp6ca6l4nxmLRT83muuxoCYjAzOjLp0oR7rqUTC9m
	F0EGz6WS0GUrIYfskwBb3RHQ45kPI6UEq2JtQU3hE5zh8J3mdOxhdVJAFK9UWBbElfIRfEEfeD/
	vYtTlvLROg8io4HTu2eF0c7OsrkuatgoozlwEbW/++V8f9+9I+SGNpSj0Qvq8K272LTu+RdzR6K
	/yfAujUCYHgmYJEIqqR7/Fvf+zKBJ2/BlQsooiWSp/lRLYIVvCjnPPgVdej9KnwuuYC61wO1TUZ
	nt2s7B07wkMrE0mL322X838mqcmIJjqHF4UJKQ+hRrebFWhUe2XTHuhPNrOswlBnyJoQKDnVrhU
	DMzvbQ2Vi2VgsvjutixvdDbLd3L9fSHcTc4I0N/YChmgbaTU0wgSr4A==
X-Received: by 2002:a05:600c:c4a6:b0:48a:761:57fe with SMTP id 5b1f17b1804b1-48a07615be4mr102694945e9.0.1776776598665;
        Tue, 21 Apr 2026 06:03:18 -0700 (PDT)
X-Received: by 2002:a05:600c:c4a6:b0:48a:761:57fe with SMTP id 5b1f17b1804b1-48a07615be4mr102693515e9.0.1776776597864;
        Tue, 21 Apr 2026 06:03:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7c0eacsm116411425e9.35.2026.04.21.06.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:03:16 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:03:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH RFC v2 02/18] mm: add pghint_t type and
 vma_alloc_folio_hints API
Message-ID: <20260421090238-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <290d615a001cf121dc0c604eb79451bcc7917baa.1776689093.git.mst@redhat.com>
 <87pl3ti0x8.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
In-Reply-To: <87pl3ti0x8.fsf@DESKTOP-5N7EMDA>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HG4sfEJdTqB4skFJwo7VHqcwH2csusITZkJ_qDxj08g_1776776599
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CAB31C0005
X-Stat-Signature: fw4u1nk5aitzpdi9fs9tpmt6qtjieb9q
X-Rspam-User: 
X-HE-Tag: 1776776604-123226
X-HE-Meta: U2FsdGVkX1+BgcGq5/LOJrW+ONozStMrMt0HMyeg5hUj7caASe8T3tsdFVwjZ9g0SFyRD+EUmDIP1XIfT22HkeLv/FHBow0RtwR93s9GDvuEhSlNkKspW5NLGNwbRMzPswjLjWibRZ1/QQNwMyh+prgi4HF8I3SoQ7Vo61H146MgD7OzgcHjNcVWAud9OE7T9CWmaKkL9+d/K6rmFtI9Q+cck8WDyPQiGiSBHd40Jacr3PTXgXmKDFYSyY4uKcIIJipp0+5EDQKec/RIs2NjwGQ7s6j1qxKOI9OA9a0N4QgK51qJZafgAqzR12fGBUslhnTA2TTIKZhAgHZy4Fvh1OpLdojhHjAgbr8SkSgZlBB/6MzWd/F22UZlXDHDn71EdbEbgCO3hWXeNDvmYowu1zeF9TfXK8v/GhLvuq3vE3l5cPoqKq5L59Te6zDaKuzlAnKibRgHl49KugSuSWlRNmB+pRQEXoLX2bgzvRfjQ2gVutdQ49+7d7ZE1nmhXr+Gavov7E1HmAsbHMgy4xw2c0nCHkFxhAM9QxKF/IxYMinK08J0g4exAwapDj8JnocMLagUEUbppCR2MSkIsb/zhHKbKxCQkxQHS6/TgPfGTKKv+YKP4WZT4YiyuO8KA8vsjjZrnh8zQDdPiPMjYQ8iqOlMAFyeYVmbipzyUwnYqX9txq/PGwktZT8vR0s/rzo+u1OBwZbovnkBw+b0V+okGKjKwFXCg7HRrLKPYz9kvo8+7X5wD7DT4hTIaAzc/wzERp6yBjEwCsF+m9X7UDnTsgjMaqKSq+oU1gVKjGoLhhN2W/hpDLhO8r2Gy7gv//f9zOSDftQLpawHuuDhTfLvNyoJcObgBZB9tEI3oqqDLO4IvcT90r3bvneVORYevJTpPJDsWE1D7niYubny3qNTSPluccoDimwelsCTruamaysshUKGTh/e0kBCIQHAweQ47cR5xdGFWwpyjEHtJk/
 do4vPny0
 xO74T7Y0JfwlcoGYJ/UkfSLlmaqliqyHBP9AmnLiFWIa2Z1025tcZT4eA50tejWggfduddP/ik/SmdQZ7jtePzd8NwjRnYcBAuSurStelAKU/6kH0JcHDnIEdl1p4OqurunXlUHwuo40vWXZihm0x7kdKXHN8S7F8oSTNMQGyvSoOgRnsO+fucg+h6XT7t+2QJdkxzOT5W/Myov+FbZg38GFtUQGelayUMUIUo4Wd2LmcQkDdTPSiCu6i+pjTkqC6F67k4Ogj8ovM5X0TYMRfRscWieQhkuUuNxCI7dGnofjfVL/BybUBZvmIhRafCJLpCiLKffZPd+HvdzrRqQD53jqhoamuIjBnoVDS+pofXNvhSh518tvk1iSSTRGgfCqgGVzSMflapIKWzqPi8Y34vGG31vgXJrK8gfQG82KToSbXeRl9vwDkZeXN9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 08:58:59AM +0800, Huang, Ying wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > Add pghint_t, a bitwise type for communicating page allocation hints
> > between the allocator and callers.  Define PGHINT_ZEROED to indicate
> > that the allocated page contents are known to be zero.
> >
> > Add _hints variants of the allocation functions that accept a
> > pghint_t *hints output parameter:
> >
> >   vma_alloc_folio_hints()  -> folio_alloc_mpol_hints (internal)
> >                            -> __alloc_frozen_pages_hints()
> >
> > The existing APIs are unchanged and continue to work without hints.
> > For now, hints is always initialized to 0.  A subsequent patch will
> > set PGHINT_ZEROED when the page was pre-zeroed by the host.
> 
> Why do we need this feature?  Is there any performance impact?  If so,
> please provide some performance data.


It's in the cover letter:

Performance with THP enabled on a 2GB VM, 1 vCPU, allocating
256MB of anonymous pages:

  metric         baseline        optimized       delta
  task-clock     191 +- 31 ms    60 +- 35 ms     -68%
  cache-misses   1.10M +- 460K   269K +- 31K     -76%
  instructions   4.54M +- 275K   4.10M +- 130K   -10%

With hugetlb surplus pages:

  metric         baseline        optimized       delta
  task-clock     183 +- 24 ms    45 +- 23 ms     -76%
  cache-misses   1.27M +- 544K   270K +- 16K     -79%
  instructions   5.37M +- 254K   4.94M +- 155K   -8%



> [snip]
> 
> ---
> Best Regards,
> Huang, Ying


