Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E092AC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12276B0093; Mon, 29 Jun 2026 17:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAB96B00EA; Mon, 29 Jun 2026 17:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0FC6B009E; Mon, 29 Jun 2026 17:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7736B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:55:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB0451A028C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:55:06 +0000 (UTC)
X-FDA: 84934306212.14.2B0D3A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 879BBC0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:55:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XvkRdxat;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782770104;
	b=gTm3zJktjdXS0BQWugh6pXScpjOGYOSvFDyEgDTvDNJSQ0DnBgfcHiLrEd/PHjk1m89Par
	I5w/UDojTb3h8rqamJpEXmOECYinBmUXZkF9SLhAAeFeU+My69tK6RN2ceIL2pANgJbREO
	dppsYSy2urFx6wuyqNCsd3sGpxqoJoc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782770104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/gDMLrONl6W06ywIXxs1piiNp16Y2gD10Hb0jLylf0=;
	b=jvSaV+LZuSegQorbcdb52oFXhlfzEVUrNFTa47SISXWTl3iGLrRN0wxgaJMIAgcVGsWvcO
	aAod3/vEK6fMKs1DIMjItsPqoHZl2Cg7TTAGjSnpIc9VlJI53+dca/+vFpy/JWg5YDMAzB
	ZMACZkWcs5oBrvU5tEk1e9nxAHcjPE0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XvkRdxat;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782770103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q/gDMLrONl6W06ywIXxs1piiNp16Y2gD10Hb0jLylf0=;
	b=XvkRdxatnxuKUCzKL/C1aoDs9wT2WwvPGTf4iBTXG7LhjXD95tZXgUwhDBtkRfXbnn6vac
	MCk83lB8ynzjRoJAfV32gLdZYPl8w3e16CyVptxSpdVMPtpnKNEIaZ+rvRV5GngC0kTK6Y
	/mWKittM4akVFl2D0OLpxP0YLmcoX44=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-rUg51hjSNvWAOdKameggew-1; Mon, 29 Jun 2026 17:55:01 -0400
X-MC-Unique: rUg51hjSNvWAOdKameggew-1
X-Mimecast-MFC-AGG-ID: rUg51hjSNvWAOdKameggew_1782770100
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493a6fe9ebdso10929875e9.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782770100; x=1783374900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/gDMLrONl6W06ywIXxs1piiNp16Y2gD10Hb0jLylf0=;
        b=ZLXkYxlvpaW3s6uLAQpKOHq7JMZmNp9Wmu30YfC3npj0NMyh3mq3VkipmAv/jYR9Zp
         wvekM3dYY+w9aCdkVaEsCRRJH6pzPxsPek7LNvnF67WR9sHICUHXPmV2oP1UmebpYRwL
         IZUNMPS5ij0UVC0edothCbA4hGMkbtlEQHW+kyRfsZKXKhJQMHL87TlW4Gt03P8jHCOp
         kftsO5QtZusR0UaJKO/T4WJ37+3z0vdtbtr7R2mvAIMN2qORg1T/C09VOrksJ8xkk61E
         qhXWWCZUJtN9Ctwv59nmeRgGytF/SS8LGgqdGGmAarjaeWYQiXT0+yq0vsy4DPVdvCsX
         nvAw==
X-Forwarded-Encrypted: i=1; AFNElJ+Rg6Ua5VYeKVBerPo6TCdAgk5/Gk31OO6OkCYAiDfe+3VJx82j6qxW/6C7BozB9wlb5Xyf390o8g==@kvack.org
X-Gm-Message-State: AOJu0YwEdLxllvIN7nA0lCfwqYJ+uaLOd5lfCD/G3R8w7ARk7IpUSKCu
	l81em7SSW7226vE+H4e0LamWdEpVGhDNTpau9iCME1/nJEG7BRSz4UY/QETdSyX9LPcAiDLwCOD
	KJdWHTR+SH1KgLntXfAbS+OSlmMATnIv8H35h2DPUOFRVgpeNcgQz
X-Gm-Gg: AfdE7cloT7afBKKpJ7rWVrrxXmxfFKiVsiziKK2xNNSBptbKG4gkbH7glTOCcEboR6f
	hmuRaMuAvSKDQxEZDOZIdVfRw7+AN6ELQmtyJVn8mQVxfa+tzrRMvQ7gk4XNMph5zz4jDcJMNkJ
	X8kpzzhMkD/5Mukjbbg7Xt8DRn3v0vcL+Tmx3NOo1QqLTbqBXAZ525tXmcGIVYc0WnL5vBl98fO
	4/+mkumpSgOtQi7YR8cM8O14x8Coqa3EUoROpPT7R31Vpx0sxu4ySAK281QDalOjHub6Wi+rDkx
	C2Nu6Oi9I7rH6g3Ygl6/myuB8GTH6dkeuBVSf8Pqdl+aXWwjOw1cc3zk7eT2/M4n+G2ViHg1aBi
	eS/sx0+qCI0WksX9RVioYO9k65BkuVXwn
X-Received: by 2002:a05:600c:46c9:b0:493:b24e:649b with SMTP id 5b1f17b1804b1-493b827c8ccmr19349945e9.6.1782770100170;
        Mon, 29 Jun 2026 14:55:00 -0700 (PDT)
X-Received: by 2002:a05:600c:46c9:b0:493:b24e:649b with SMTP id 5b1f17b1804b1-493b827c8ccmr19349615e9.6.1782770099527;
        Mon, 29 Jun 2026 14:54:59 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8c7b82asm18608955e9.8.2026.06.29.14.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 14:54:58 -0700 (PDT)
Date: Mon, 29 Jun 2026 17:54:54 -0400
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
Message-ID: <20260629175149-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
MIME-Version: 1.0
In-Reply-To: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ifvem2SAMMXitHxkhmjL2p_lI6yy_04UIyGGGjcuErU_1782770100
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 879BBC0009
X-Stat-Signature: pm3oz4gc418csotuhe7g7885mwifnnht
X-HE-Tag: 1782770104-333301
X-HE-Meta: U2FsdGVkX19cY0VQEWjJrm22FuSSt+KM7DQgWq9ayUEDMLmvNqSyyAEbwo4NAH+QTH7tYAW4K61Z+WZ0Ws/8S/EAQ8QdY3+8+ut5SlE6uG8dzWJgZCn9FwS7MoNBTwrmfq32NIKJNk0E3xG5XJ3o+pF4TZigLMrQBecZnl+U6Z+Fk7+dBXC9Ln2q27Ax4f6IHpMsaqnS2cNKfcTqhbgDVWeDakdWJrdc43QqO2nwjPnFdFgMCEzTcWtn/CCBNlil7/80jToOlteZdBt7vxe1JixbkfMg3cO1Ss9br2O4574kpHXMr4FfyRasIm414DHf0IMipB2YQOJqSgk2Njs6bYUK8pAgPgYX2v7rxNV5W7ryr1CNRT0W+nwbHc75n8YIj/r5yxu8NDjF6pJAfgVO2+lQxoxHK50uM5c8INPH6KhCLDWG3uXONMeyd9Z6haoayTufEgcTzU17GXKe/IylQ+2vVl7CjAKnCHjHjwjaWSM/UBzHkq/6b+f1QfZYUnAW4P1paRVJH/4KF2lokHyDEs9O5JT0xBD5kVgCmSOujFY7qXUYAsw+3S7PpqxMgX8XJA+Hs5HQMz2cHc7JLdZu2VtJeLhytzTCjJiGjSx7shkcCKpxO4r1bRopPTEpzxttOv+O0t5mvGt9nxnvDturuB6CF/bcj3SFj6TYL8XmjFBDyk5qbwHWh1o05CTu8t0xLM1+xyQIfi1Hwz5+LBJLg3ElmJAnP4P7ASPYJShS5/J2WP8x8rrgez3dXDMs5zooGNUQWMBo/JMfo6B6Rd/+lh006bpSs6J9XQCtMomdJBTwkSew77yNcGbVsDJhOknl8YDfMtd3KdjWIY5O8KP8Y2aqaU5iZZgLd7mttHZ9BYThcsEk881AdB3gMVShZOWdX7jsxT0DTdcvogCbC3NnZHlAT/LW4bf+iSpEKaw2ACwrXK82yUCmyStS9Z8Mv7z8OCXT7JlvnjOy71KIvmk
 9Nne5Poz
 19JU+9FxFM4h+jpS9t8O73XrS95u8uvyQQZ0zloJ3qHPGSmQj/HgDSisUfElbz2EjxXrzVdyeQhG8QpqUZsZLGJutb/RasMjgPjM19Zn2ySORluVvMvH+D502CpZpL5an2cRpx2D1skv6AU3jCqEnmcdVvuNThwn3Y00/nuI9iWXSPkoE6xTQXcqcNqzTy0gUQz0fGWZKVIyHKYX6rnyNYLip5TrZSBFl0QMpJQ06SvMfRK5VUYd4B7wWZDDKHmjMw+A3wdyAr0rmReXOJbTsL5WPQOSZeRxE0b9nJgTHsfCDedRguOR1s35V3OOQVz16rKVU8+cy3OVu/NPaqmuHIoQm7lz01xUOQX+HVDntCvy8nuN3q3Xo42PHhZmCLRGf5HDxVwlfomY+2GtNq09yyluyIV9KbbEyGhvQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
> [...]
> 
> > 
> > And again, I'm really not sure fixing a theoretical race when memory
> > is failing is worth slowing the world by 0.1-1% for.
> > 
> 
> Fully agreed.

Let's say, we just send every bad page through MF machinery X times,
and hope the chances of a race are reduced enough not to matter.
WDYT?


> I was hoping RCU was cheaper (I mean, we were once told that RCU
> read side locking is essentially for free ... well in some configs :) )

It seems to be, just not to the level where you stick this around
each memory allocation.


-- 
MST


