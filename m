Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB3FCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C5B6B008A; Mon,  8 Jun 2026 15:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123676B008C; Mon,  8 Jun 2026 15:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0394E6B0092; Mon,  8 Jun 2026 15:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA50B6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:59:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98C85162F25
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:59:08 +0000 (UTC)
X-FDA: 84857809176.12.9CF13F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 492CA20007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:59:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VnDwRTB7;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqSTEGK8xl8EZeqE74tv6zlFs8hlnJlJcde7w58YuZs=;
	b=aEpRYRuE0Gv7iLIdxjy300ozRBvU20PUV9yCZk9KufpETSo8d4vr1NGJ2BdU4FlBCzK7Ad
	j80XmAn/W4XnFDiM+CZ4pA84ym0f9wh1BK1fFZtFXc6pgsy0iqcxEm/NiyfEGXH1cdIlYP
	n/FxEyjF/ifeBGbLip3/vps7UCQ6naM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VnDwRTB7;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948746;
	b=luLqQATlI0+EK6PwCj0KdS7sjrfZpC6WiLyExyEvvIIvXbJRSxAPdfv7BlYsotx+yVJT9P
	vpavJWa3KYV9CYFIGAIDvbJdaxqeWu72dhRbYIU4ASXYLLRxCFZDzkEw5UXsc5uI8orkKH
	ctKN6Wl0VCX6ejrjFLnz+VOPK+VJPe8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780948745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eqSTEGK8xl8EZeqE74tv6zlFs8hlnJlJcde7w58YuZs=;
	b=VnDwRTB7lHxKeKihP8k7grhzkUwWV+Jn5bq7TChVe4pFv7NWXTrRfvVK76P5xC6G0Wsi/W
	fB0590GorTB3Tu33kcOPgT+UZUR6OlE0gwqxJkRkzB0V3A+7iTlHc4yKCqfGm4v5MxUKgc
	JbEUCy5pLcSeM35uF7eCBggTcNKPJVo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-kac16pD4M7Scby9sl19STQ-1; Mon, 08 Jun 2026 15:59:02 -0400
X-MC-Unique: kac16pD4M7Scby9sl19STQ-1
X-Mimecast-MFC-AGG-ID: kac16pD4M7Scby9sl19STQ_1780948741
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-460153ce644so3372677f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780948741; x=1781553541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eqSTEGK8xl8EZeqE74tv6zlFs8hlnJlJcde7w58YuZs=;
        b=kktlrnH+G1nP5fgGVtlyK8JtmAgDUvKzWjYQ8UX/xIVvLGF/bW0m8FVCBiNt4KJmCf
         x3QwUY181ym0am5fzl8b3HRDaoJbuxocswRM848N3e66u+yjksdYoFqlUzQ/adrsOJQx
         n+p9+h9eDR5z/8hClWJhUubsBmR+jSqm+4jxzntn0s4K8YJXXDoTxzGfiIlWRj78xrsb
         /2kT19hplT8W9V/6pfC+sV8ZfcHJ6kJ14Yf8NxBvcWGnop9kOcbazzvk1YLxy018u3mK
         amwjfRu02jU52lOQiAme9KC7+TwSIlTKI7tp3TsZkiePRMu4aoxLw6MO74AHVXYNA58h
         nsxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/cOhjFVAXs64ws4Dcy9rl65pUBY/r2bCnJIcxad3gwpJQ+/3RijXKHmMbyX6HTYX9xIkFLbRMWWA==@kvack.org
X-Gm-Message-State: AOJu0Yy2Ikev93GWVi9VwNbq2qirLPww2m7e45Say86UlAY3qNPbQz+6
	JdMwExYgSdPtp0h344/bGWXgthT0maM97wbuSsj6U2I/BYx3kEaSbvtNnyVjjDotgQU2DHFNz0F
	ygYcjZFaXHz6kiUu/eqT0fGoxmusEB1YKGJ2VIV//3/HDjD3tC+Pd
X-Gm-Gg: Acq92OFe437GaRjIjKzc1b6KXm166R2X80EEUrJn9ueOe59b5ehNMNaj2+Z9rGa1Xpx
	pTEQnXZKtoPllry2Y64m21hG4GDTUdkfocJlLqZu53FyGyxftBvZYEPhOhghAifEbKtdu5hGu+2
	UMPfBam/MvktiFfNnJ2vQyV8FmOGY1WaBIXuYOZH9RDYbC9VcVzESgjlIEqMgGeA/ErqFd/L20r
	NEkU6oEJXl95JgUjR8R/jcTlQ2+EsqrJtcqDWYEyVSVJtTEOWhb+UqaGtSw/duNxwH9yv7ud2Fs
	Pcmavrlpo5ghDEpHU6VnTObxTBcZX0uOYz6ysDD7fV9N/Rjg0a3Jf8t/4om4GPkIxA8cEnN6wUG
	C/c8jXNEG/58jVplQSZgd0wuJKANKr2MQm4OWidnlq+r/l1mEOQ6VOg==
X-Received: by 2002:a5d:4d0b:0:b0:44b:5398:4e85 with SMTP id ffacd0b85a97d-46030502519mr19992710f8f.22.1780948741123;
        Mon, 08 Jun 2026 12:59:01 -0700 (PDT)
X-Received: by 2002:a5d:4d0b:0:b0:44b:5398:4e85 with SMTP id ffacd0b85a97d-46030502519mr19992648f8f.22.1780948740596;
        Mon, 08 Jun 2026 12:59:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d40sm54186487f8f.26.2026.06.08.12.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:59:00 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:58:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <20260608155520-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
 <aiazXE8pUDeCmP7c@lucifer>
 <8ec82477-b497-466c-902b-82e108ae2b7b@kernel.org>
 <20260608100602-mutt-send-email-mst@kernel.org>
 <497dff41-e831-43a1-a56b-a6ab98bc11a3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <497dff41-e831-43a1-a56b-a6ab98bc11a3@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9l-TB0upA_23buGucbPIY0ojM-gVbkGSc8j17VkaCnc_1780948741
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 492CA20007
X-Stat-Signature: 79jmmgh75aqj9tsnmon4aijeks18n89n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780948746-40174
X-HE-Meta: U2FsdGVkX1+xqf394rJWqbMyFWYm2Kq4hYJjnRU7k5wKVVLiEbzRbXIJHSHoiAw6MbTTbuGKDjKe26czLH8Fdcx6zcbw0P9bTXWqdxRIU7cGyyRTmBrzHCcT5gKVqPEZf/nxil++lO7RQnUe4IEGhbjSF8JMpneJVW78FrYPx1IQdkZwq16qg4+NS/CW6ehY6Qx22P8xxak7l+O2zTYx0JZSbS36fB3ZRCh2WDYLeUHDVb9NUvtRfEUhvlWSRlFn1778ZudPn1r8O2sEQugyqCqCI7pEnQXW6XzoeiMXAW2JN9X1cSoVXdo3BSCzE0qmcL9+rhvZGHSX9celFkEXpDYHRUn10oMQauRGL8h3VeGFWN+p2f/LvKLUoyS/8N+6MZhbHkjgjFOc355GouE0dikhQYUO9cKvWvi0Et71mHtZ35JBtBXEnwCJUa7r1DFFdBCPmalNUWF2NaxufH2fwJYoDYU72o1h7ltB5g8eotMKAZQdcOBBW/zJtTzQfLUunPC2L7XQ8ihl7czudOc5tP2B7Nrx+XrRLM39lMcJ7VNiOg/tDMPcr8JiM/dfGVTYcZIMkGR2AfPedCd7g6D3xJqLovrPO17LhOyC9h6aqfTn0URbZgMXUHZdMAdYDoDaeFYMoilGci8ywyFXp8q+vgH9dHj1ADmlDnBIJ1TVY1Uq6cAoXoGvDEHpHPcvnfukobtizA3/fhI9Dy5oRYuJhyD1Wcrfl5t1Y5UjAwSkpHVA0q5ZDhn0gW3nRdRxEFB277JGSxdow80r/ZdRyBN9JoF0aiTNrlKtg8jj8H7QcyCvasY/oB11yEMQJ2+dLPTWgoisQwCSSaDkc64mEU2h+jdyzPre9wX3x89DLHTjY+HRrugwUWWDJGy0WHyu8omI+Lm9uyD3Rypfz3r2qxiqz/qSrVj1DzsdZEoGvxXRN8YfY0neG6sF6mnStMMVLyHEYelUgmsWIrfgvRL7JM5
 GQxUmQlk
 IMtBjA6Uv4dN8m5Uh+opp/FJhUlp8Eco/Qhf3Sdrwf57V3zyRTxz9v6gb5wIuv7saedqOmy4C6XsHhuzKCNbLX5PRgOsB3fbKhqUzt4RkKyY15J+gE5gmbWP7JuOeyMQGRoADd3F93pHnfyz52ZvHTpYZOYfiQa0KCpUEplQce6A30iRs4tM2CecLWzvw2xxj/eb1oc8hZZVBeYB0DZy5F9zXifChjtij3xMvystS1VI9qGFZdX0KfD9qTdPr429eaXZUdRNtG+SbTggLik+1FspKgGWzdRCekVfraD2d6k6XzN+ba34y+1UVCjqzg8kP617r4XS9/N+0KJY88fNVQtCRIDGxbiRFJEKp2bL6mMBlury5ta/NLDwemAyQB9Rs/SkVnWQ+DbvAcRwPoH5R9ogBGY91lk4YadekuYLBan9DLM0A+Ui3uUCpfth7dTxlsgVUYBOIHHDN/Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:28:48PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 16:08, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2026 at 02:46:34PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/8/26 14:25, Lorenzo Stoakes wrote:
> >>>
> >>> Do not put comments about specific expected races like this in the commit
> >>> message but not in the code. Subtleties need to be called out.
> >>>
> >>> The commit message also doesn't at all explain why PG_zeroed doesn't
> >>> suffice here.
> >>>
> >>>
> >>> I really don't understand why you have a 'zeroed' folio flag but need to
> >>> also have new API calls to detect that?
> >>>
> >>> They're also HORRIBLY named. Zeroed as in what? Zero page? Huge zero page?
> >>> Memory zeroed by kernel? Pages that userland happen to have zeroed? Or host
> >>> VM zeroed?
> >>>
> >>> Each are cases we address individually and relate to folios.
> >>>
> >>> You absolutely fail to clarify _which one_ you mean, and provide absolutely
> >>> no documentation and add an exported mm API with no description.
> >>>
> >>> This is just I think not something we want to add? Especially on something
> >>> so fundamental?
> >>
> >> I raised previously that providing a folio helper is odd, and that I suggested
> >> that we defer this change.
> > 
> > Sadly it's a dependency actually - without it memcg failures would cause
> > repeated re-zeroing where previously it failed without zeroing.
> 
> Oh, you mean that we succeeded allocating (+zeroing) but failed to charge?
> 
> I don't immediately see that to be a real problem?

Yes exactly.
I don't really know if any real applications live close enough to memcg edge
that repeatedly wasting cycles zeroing pages then discarding that
information will be noticeable.

I should be able to write a test to show the difference, if that's the
question.

So just writing code in a way that we are not regressing them seemed cleaner to me.
But I'm not a maintainer so hey. Just so we are clear.

-- 
MST


