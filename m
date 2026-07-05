Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815FCC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704D16B00A2; Sun,  5 Jul 2026 04:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC406B00A4; Sun,  5 Jul 2026 04:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1E06B00A5; Sun,  5 Jul 2026 04:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 374CF6B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:42:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA298C26ED
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:42:48 +0000 (UTC)
X-FDA: 84954082416.02.4CC9E98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B4542000E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:42:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KwjhqWH2;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783240966;
	b=8mSqOuVI6Z+MmrxNB30buA8ca8aw7Liq36MX7viN819efyOnowXVAEgQ7HzNHs16tclWcA
	pw/nDqcVtPU3AY536N/8BdOk3w3InJ4+Is/nq3n5Xjuv3glYNsQQoGvn1TIuEAPZRkJ6U3
	umtHnaur3YiZLzszD3v3c8ud53pbLAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KwjhqWH2;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783240966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHXtK4FpIqGf3brzahyfCCX92d/AVZ7ZVXjnm2IjYlo=;
	b=m3ljUGV/IDa5nufZo2MQ10CdFzNL57+rhraAsL3Ae8fMr2ES6Vu8XgK6qXrYKvxOYJlrMQ
	dQdqS0DJZrVNhG60QIkYa9CB8DRovx2AmX1GrF8E+NFd2ybkxBqbFtUzAzHL5cYoDEqpYQ
	Ncmh7GstS8OBHW5Vpq/sgDxUQsgdx40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783240965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OHXtK4FpIqGf3brzahyfCCX92d/AVZ7ZVXjnm2IjYlo=;
	b=KwjhqWH2qDV6rZZW9VZa1Zi1t8DDvVd7Zpdp95MA68Gdn0MNlEh834eMgna84BlUIQiUmA
	EeVbmy2KWzGtAShwp4kxpey8NjKR3iRdmeoAkhJx9VM1UyLyvDPhhJy+Yu8Y2T/H9i9URJ
	hZyx0Kp+1TjcOirVNmxbt7DWukrl94E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-Dkgcs3FEMF-PvoiWvsR_GA-1; Sun, 05 Jul 2026 04:42:44 -0400
X-MC-Unique: Dkgcs3FEMF-PvoiWvsR_GA-1
X-Mimecast-MFC-AGG-ID: Dkgcs3FEMF-PvoiWvsR_GA_1783240963
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47162f83c75so2065533f8f.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 01:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783240963; x=1783845763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHXtK4FpIqGf3brzahyfCCX92d/AVZ7ZVXjnm2IjYlo=;
        b=fkuIyNBXRFQVSbiuEzyQ5VLA3QkjFp2ILeXEAsbY6QQnOh8WNljUDeFpw67sqCn6aj
         HKtl/UKjHVf7ei9O5BNGGwF7o0UwECFx8sUnj6EHBm+sv1CmzGqA5yhdCDgvHx0jBzTw
         d6P0RjjDoqlixfGGwsEJ7qnjajAm5RTlb9efKvqA+Rnqmvv9XLQRcTHUf5JJB4Zufrig
         iHLX+V7t1B1+SkP/4knX7YSWPgR9fJ9/3WqtFSonIPzleEjC5049AOUFJdA6uHdnKwBg
         Cbcp//Plrx0Zn4NgkibX5okCG/MX5jJQ8Eue2TF7DQNjxnFKpC5XDgNoQkhM5EAy3giI
         LU3Q==
X-Forwarded-Encrypted: i=1; AHgh+RrBKWPZNUeZnB3+yAByg9GvhQnrUE/rVnp8jlFlsqEmiFzuGJ80Oj7s6FAkCsETrXiviA/ycyFs1Q==@kvack.org
X-Gm-Message-State: AOJu0Yz7MJNNHbkpf12QMExbc+VKsLfCMDCtrpVa02Su5LFmsZsz7zdU
	OUHW6zxtmzRqaLkSJ/KrCRa/BjT5cvWoe0Tnyz6kFy93fkTdR1/WydQNZdfNAr+ynq/hJyPBZIB
	YNff74m0WQK9tt6Tl2MRWy8ycjI75bZ0s8NKQmtWjp3wkImhxxuVW
X-Gm-Gg: AfdE7ckY6Pef3bfx0x1JjDudjjfGOiglin8c8MSuzJAyMbbc70SWQxzFqXBJTAAPYsZ
	gwadzh8Mgb/N0D8i8wMl7p9XticRRWjYTziOn3/e+jKQbt2RYkXzF7bGWVHKfKRLlHBcJEY5aNP
	Yz584kAOlPa/12xlzpwXX47Dk6qiLz47IemBIsM3XuWgLzF8BfMHeWzdCo7ofITJH+ts3/PFaGo
	KSW9PpdlSt0S4I2Cs3Fn6xh0SpLFugnnea2oc6+49VIUdVpwIge+AvqtI8kxeGVSkewciMTx6mO
	russuhsLKixyzs2+/diYrWpyDokIycoT/9HF7nUr/Kzg/qDqDqKkGLG7UAcJXstLxFeX09IXiCp
	6MeniIzdqhJBHcNjoqWlEnLZgzOwM6tjh
X-Received: by 2002:a05:6000:1845:b0:474:88ef:cdec with SMTP id ffacd0b85a97d-47aba8c6a4amr7086537f8f.6.1783240962802;
        Sun, 05 Jul 2026 01:42:42 -0700 (PDT)
X-Received: by 2002:a05:6000:1845:b0:474:88ef:cdec with SMTP id ffacd0b85a97d-47aba8c6a4amr7086499f8f.6.1783240962323;
        Sun, 05 Jul 2026 01:42:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f2186bsm14266295f8f.36.2026.07.05.01.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 01:42:41 -0700 (PDT)
Date: Sun, 5 Jul 2026 04:42:38 -0400
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
Message-ID: <20260705044139-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
 <20260705042313-mutt-send-email-mst@kernel.org>
 <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Oaluqed_kM5-mx2mA-ikgae3YcHpdjqwuwyrPWhQoMA_1783240963
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B4542000E
X-Stat-Signature: y3hkaxgqnnxtsfojmzpdcuqo8rhyfui7
X-HE-Tag: 1783240966-901610
X-HE-Meta: U2FsdGVkX1/omW91s7kKsSKJyUSrBfFi0xX394na4jf0SLGrZQezCP5OWHGIn2dJtGa0MPcS/KxX2y04h5TmKhjHkKHwxEN8lqKUn3520EvlPFCsFMm9xm08b4hejbSxWY5qZvOa+kBCv7G1m827vzHlYcyOHhBIBh/bN4dEkuA9+qkwYoXKzkl5f4BGXED9K4nIBiYiavrpAfRfPss91FGNo6949VVkzCJN1JOcKbzXFIs26F9iy14VOP7ogXwshBgcbYglvxuc1Sbf0ChMzyXC7iohSruI4ptuAGdbHxU1LmlELgz+dy6reGfkZSC/hhzxK3mqAXwGw1FVvif1wtR611/FCbSg0RbH9NzPO9EWGOdNc9VW9C6DhLp7ZLVC1wq0IIG7DcYJttnBUZfPa/oWkKn6Ri53Sz0pW7sy/QVrSTLnTUrJgZDiUUs7xcIhpe302hcwnnjK7eqL2KQe4BTuvu/GS/p6EIcCJhPmRsAiaqKQx93L9i8Ct6LSMkSISCkfYQNxZke84aR84+sb6sC9CgXCmFtcMZEkyhrICFWua+c/fYgOnYPeJUPMZy7eBuDu092/mJOnVO4pyswSs3R2qhMFaaAkdUTViZl8YGZsYkIadSKNHZC3E8Y4LWpL9RPqGy8dnUjG4b56tL6CY8wJXDHjHc7Ewr/qMCJWh8ZATY3YWRnOypWZEi7d43JOz/UuOMW+dyqHcR/Jf2G0lo9qE+h8sioPb/w3xsWBmw4qx6Kqd8nOXQ0OBKHcIpgtpxC+0KhFyszfY+Q0OoW3Vmq3JXhhGaoDbuM8TnuMNJkNjTw09LXGJ9iY8mBqub74xmdvdtDdUwW+dypC+sXvcxz4j7ZpdvHcXgMjy85JmzLe8J1ou8SH18/MmlchAVNQRQlXweyfp76joMMhCYVlI0sI5lj2+OCPawhZVELl/xX9qZS6wWLEGAoasbn3o87avWedTAqsc3uWcPx9FpJ
 QYtN0gD3
 hORhJBuxMkMmU/laMm4BVqm/8hGp3/i/MkKf2nxYW/I/pxlawnhlXlUTHYwXUnk/EuadPGZQBG63skKELT4U4CIpihP9KeGd7kezC/tReE3GIsYdoHSqM41Gn0mTT+ZqQ8zhi/mmYojS+FS9bQidtvS4YiMtVKLoFypQ7Bz+0AIQcfxaYlgyMyMSXw8oIfJsshMw8rZZEVqPqdwZ76VKLKTWXz8PsY5d0vdopaNiJznos/UAi6RKNSXLG6tPMcV/tasK542IO/5wSIZ1l6PnK0wqrfrW4O4SGqp8NL1xnsCxBOQ1Q8Elr5Xnx4HtM6dQJSAJaf9hpurdomUZAXSdbssyPUUIU1y+JnfEbPJxArJOGt8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 01:39:56AM -0700, Andrew Morton wrote:
> On Sun, 5 Jul 2026 04:25:53 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > > > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > > > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > > > page_reporting_register(), before the reporting work is scheduled,
> > > > so we never get division by 0.
> > > 
> > > Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> > 
> > If possible, I'd like it in 7.2, have a setup like this (small
> > queue is useful for perf testing).
> > It's very early in the cycle and the code seems straight forward...
> > I judge the chances of breaking anything is tiny because
> > it just failed probe previously.
> 
> No probs, I moved this to the the mm-hotfixes-unstable queue.  No cc:stable.

I suspect the Fixes tag will make their AI pick it anyway. But hey.

-- 
MST


