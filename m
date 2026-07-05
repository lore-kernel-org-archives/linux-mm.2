Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60F0C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66A36B00A0; Sun,  5 Jul 2026 04:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17876B00A1; Sun,  5 Jul 2026 04:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906696B00A2; Sun,  5 Jul 2026 04:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 622BA6B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:26:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB71E1C3B2C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:26:10 +0000 (UTC)
X-FDA: 84954040500.18.533E10F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76F71140007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:26:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KQGkMd+Z;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783239968;
	b=zDvzae5wN5+9CCjSqkAUS8SawY16IVK750hQUIXMxSOlqt+rmnPvMUVtghAM41iVAZXKB9
	DYnF6/F6O8Ghi/QipqaGhCBsrutp25OmtQ35Uv2VdgiGWG9kYH3wKwUoCnNJfegjhe5osP
	qfxAhe2HyeextOIuwfPvnh4DsxpdXGo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KQGkMd+Z;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783239968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QARhhZ6+Yy8zGrmYtr8GGmZltZ9TCRLEJ8tCyAg6hw=;
	b=QpITE0XAi8VW4AFrprraGp7pdNld1QpDSNK38IBd5jP8SnMEJeLdqBKsFwLzYp8MtD+zYm
	uRjd6aMtrFnsiMxLpXe5LnojQNc0iPKqAw6VCmcmqMxGM/ex9oOYgyVS0fbJax/PVolNF4
	c2UDQbhDZAGIurismFVeERTAYINCWP0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783239967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8QARhhZ6+Yy8zGrmYtr8GGmZltZ9TCRLEJ8tCyAg6hw=;
	b=KQGkMd+ZWhsayUoJp8sQQSTJ3AHOpRJB4wVxhoMJk4+7OSs83giiA8njHdgfHIzCDaU9U+
	MNNH2YvCOXDj1na/uxNlioSEBt6jst2xsEXMRpFIJKcMNVSIOCujLQ1PfWZPgTdqaRZpHZ
	i6mWDWwA5MC5olpmWqOpXVnZCBaS1Bk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-QZabZCFWMJOvCEuQRTP_Yg-1; Sun, 05 Jul 2026 04:25:59 -0400
X-MC-Unique: QZabZCFWMJOvCEuQRTP_Yg-1
X-Mimecast-MFC-AGG-ID: QZabZCFWMJOvCEuQRTP_Yg_1783239958
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493d88406cdso854465e9.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 01:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783239958; x=1783844758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8QARhhZ6+Yy8zGrmYtr8GGmZltZ9TCRLEJ8tCyAg6hw=;
        b=s1v23p4N6jZPX3ORx0AN/DNCrXng20E+hbzW4H0ofVefM1fN8W8c5kq8EOipZCmZZw
         sRzyU9latPXQ7tATlU/2ym1S0wfEagVokhge7a27iylyLjZ7xhav+gKN2Q+WVu6qu5fj
         jwW5yscN6SarDj+40XR5EdYDlsa3M5PpTti9Ilj1NWulEVgc2Kd8MpEMdEDTGy3ajBek
         lKnOTQprRMNxmPAeTAgqGQKnS710A/odcgE8Xr27y3ULvFvlsaSgswVE6LAmwwCi3XdB
         DzMQVJ/cCq7b6hnqqsE2rFOquCMNf+yWpD9QRnu5C4BWiOIRx3n6DInaVJN1zt21BAmn
         dNrQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iF4PcDbhQu/CKbzl9t/fL+zPIzSTDSCeJoUi046F3VeP443n+QsyZ3ASo6/g5f9wWfXo01BHEiA==@kvack.org
X-Gm-Message-State: AOJu0Yyk/GDummeUnqUCymGyvnaOvJDwopcxt47uTavOUc7oGzPKPmrQ
	QEkxZoLEtEvsKKWRzxxfrFbdM559FeZrOLZktpeQFUh4YoSLJFh91CFi4M50EgVbP/OzPLeB8+H
	eJs+yDCiBEokUsvOWY7b1azx5M7+diwhhaHBCUMA64m7oyZqE3I6z
X-Gm-Gg: AfdE7cmdtQSFhPzgq3bEGfGGnV+dHGphoFHI/wmhSqVZeyxx+B0qT31tk4JtsGJyz0g
	/Bo3S92mbkQHf13XJX+eeelpKbc/zjVpKeK3HtzcPIFAw73Nxl6Uww3bYc2G3w6h6NiLlZf2bPA
	I0k9g3Bi/KNWBz89GIsWkISy8nIjU1at5DcPqk4Pis0RKqXf8++5m0cuuCZEUgDWLqSkkHpo18v
	0dN0Q7skH3KY14/JovAHC7ie+Jlj3KJXOU8n7nuZWq3EFaONSXpuSTBLsk0BGMIBcXSnH+ZJRup
	tMGJNKPaabTtqmc3/ZxbxZEKH3A/ArfnWgK/1jU6F9g/+ZUhMU5uXMIRjNx+/mw0zi/NpMdkjYO
	w/cKgJhvBlCVBF8z8Ke/q57OPOLGEW2o3
X-Received: by 2002:a05:600c:4687:b0:493:bd2f:c5dd with SMTP id 5b1f17b1804b1-493d11f3769mr69488715e9.21.1783239958238;
        Sun, 05 Jul 2026 01:25:58 -0700 (PDT)
X-Received: by 2002:a05:600c:4687:b0:493:bd2f:c5dd with SMTP id 5b1f17b1804b1-493d11f3769mr69488415e9.21.1783239957721;
        Sun, 05 Jul 2026 01:25:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960816sm13749921f8f.29.2026.07.05.01.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 01:25:57 -0700 (PDT)
Date: Sun, 5 Jul 2026 04:25:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch capacity
Message-ID: <20260705042313-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HI5Y9yHygyo2T966Z_2ZxyQk4s1TjYLdVpROnuFxOwg_1783239958
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76F71140007
X-Stat-Signature: kkwbfztht1posbqe6451ow6zms6smzqm
X-HE-Tag: 1783239968-509610
X-HE-Meta: U2FsdGVkX1+hERzCjuEKI4aYrLKGHw/rtEDYCvAH6AXA9cGMZwI4tjHrD+bXUdvzJBeCb9cOPUL0a09fp5RZoxpeP9/t6osHmFrxSO9Szozlm08J5z4ANdOveQ+ulXDQD2SCrri2LasI7PrEmHQkYMJ5ciBrbn23JCobPiWdB1ybyxHwdMMDtuKMfZh4tKW9Rj5b88Kl2jEouew3davE7TVcatL/eqXMqcJQoEdKUUwD8sqHSuPvW4oXy52AIXiuSLQtQ8jLGq8XFoMYgQrwYjYLFno1MNUX1nakbD0EXU2a1j8ci1EbOcf9Kke1wdTZjo95iRTMcDqhRt2lNV5/8UyZgsBd2RgjjWI7O0BCKN0WBVsjyytijsDXK3AoIw3RY8sFdQJNE+VDJjevhIST7QIeYDLEbWbBEl7r23+zwg4VsfEsZfK2ht9yY8Y0iNdlZiT5hB4d1iwZ0PGBZ9WVF9exzGAgRNPD7yVuv46J9Xqfzj16t3zX2+NKqX+UbjoR/0OYconquC1pcmIeyCrVrfi8RlppfxR0ZToY/52MMd2kAM8ryQgdu9LrjbpWhmHuKMBLlCVxvsG8qUvneberJvamWxokT+89hiET69FgC6d5wCumBOwTGYzAjmSkNeoo1YnQL4NGcmwM1XywdzTgIP27hTLz+v7cL5MlK0y2nulhEIDYsFYZJuSiBihcH9gNCsLo8495EFZYoeyvpi0OVaWzyIWMw5eoKDBLyVZkWgDJoMqLGi5EzKg5z3gf2uzZhL4mNfnnff+P1H5bAAvQQqw81dsLkMvUp0/K5e+h0P9EtvWZWwd1NtrKbaktmiyVaYDhuuuBmk/BWgQoExRovh9fSQ8s/2i4SYM3mjGTffQ/geZi64ur1rQr7ibjw2mYjHjSHhMgOSj13KXHpGLfj9mMXjfyuHypchgg7P8JswjnKKDAROBatBAhrVLL3kH8qaYER2EJEZkI/DzEyLD
 YmO9tXVH
 NcQQL2pwq4KumYRwtqyz34zNuKKMXH+3KIOyDtZ1fgmUDRd3R/8LFJft9M3NcJn3ayN4UxnLxXRg+b1jEtDLNFndom8nMzoPAi3X4KOHhp9Ijs7CSInC2LsL12YobhyLqvWh3q0BBy6ZIZ16LoTf8Bu1rFMFj3D3cu9f2U7paQ4SuiZx9lCJ8XprDexX9krIkVZKD8DcUhmBoviJpOtMLZWNmuCl+/sUkEQWM8dAfpuNk6ZRHVgZBlYfQtgWQ200FD0ObegqYsvefU5q7XnyX5QikqyJXYb6Uffr+3NDntMRKUG7C3nozRsPvtl+dt8+DblppFY/qC836jQ0j3t2em74KgYV6w5Dh3AyDHBEhZJhHkGzvOApgIuB1DSXriL+T6/u0/zdNOMEyIbHYSuFtr6c25DroFpGS2JODJjHcDfSE3GY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 01:16:35AM -0700, Andrew Morton wrote:
> On Sun, 5 Jul 2026 02:25:13 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > At the moment, if a virtio balloon device has a page reporting vq but
> > its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
> > probe.
> > 
> > But, there's no way for host to know this value, so it can easily
> > create a smaller vq and suddenly adding the reporting capability
> > to the device makes all of the driver fail. Not pretty.
> > 
> > Add a capacity field to page_reporting_dev_info so drivers can
> > control the maximum number of pages per report batch.
> > 
> > In virtio-balloon, set the capacity to the reporting virtqueue size,
> > letting page_reporting adapt to whatever the device provides.
> > 
> > Capacity need not be a power of two.  Code previously called out
> > division by PAGE_REPORTING_CAPACITY as cheap since it was a power
> > of 2, but no performance difference was observed with non-power-of-2
> > values.
> > 
> > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > page_reporting_register(), before the reporting work is scheduled,
> > so we never get division by 0.
> 
> Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?

If possible, I'd like it in 7.2, have a setup like this (small
queue is useful for perf testing).
It's very early in the cycle and the code seems straight forward...
I judge the chances of breaking anything is tiny because
it just failed probe previously.

> It seems that Sashiko has found a pre-existing issue, a hard-to-hit
> error path thing:
> 
> 	https://sashiko.dev/#/patchset/444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com
>

will look into this, thanks!


