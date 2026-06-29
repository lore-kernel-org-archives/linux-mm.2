Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF195C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774FE6B00BE; Mon, 29 Jun 2026 19:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CDF6B00BF; Mon, 29 Jun 2026 19:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664C86B00C0; Mon, 29 Jun 2026 19:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 283086B00BE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:34:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 915C9402DD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:34:50 +0000 (UTC)
X-FDA: 84934557540.26.8CACA18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2D554C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:34:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsnyPtqO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782776088;
	b=tk5NhlldJUr5MBHsGEHCJM0ng2irb7frCOZdgpJwvTSCt85BEtSGPNQgpO8JjH4z88Vof2
	ZaQEHIhXSr4CWt3s2Q+oFO659lrvm8rolLzNMSb8N3/PK0lkFbbnfmJQv+LMJIWg28NmUR
	rP/yaLT3zZXOQCPk0W1ZR/lUin90G24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782776088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tx9bcHWuZ8oC4m9hNe2V4W31Y648brgxhiWHI5yWr0k=;
	b=gywijhCOHmJC4N5C8Kw/Eu5YT35yMVlloSgjCN6/kdRGTccxtVWjHZQywu7RMnbKGE0s85
	4uRi+IXiyPvz2O20lWUHBFLXlyycL+EG+DcZ1I2WO451NMS882cxUJfp1DjGZ4yFGIcCh1
	Z79BishuJdq2RFePiXoGgYi+ftn4TkU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsnyPtqO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782776087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tx9bcHWuZ8oC4m9hNe2V4W31Y648brgxhiWHI5yWr0k=;
	b=dsnyPtqO5cZ/Q+ivcKftVNLdxCx0nHrF9YJy31h9PJgD1lyN/xFZI4Lo/1mzmRlM/NhICr
	reWvgaG/fYGnVyfupZPTLZZWrG4Bqic6tsdU2I/GX+mw1dTZ9hRaPVh+KZGu0ev/nXAoDm
	Ix/VKd0K0wrcNPwivkuttubSj6b7mvE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-1wRSU-_zMNSh7DgCDdXKLw-1; Mon, 29 Jun 2026 19:34:46 -0400
X-MC-Unique: 1wRSU-_zMNSh7DgCDdXKLw-1
X-Mimecast-MFC-AGG-ID: 1wRSU-_zMNSh7DgCDdXKLw_1782776085
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47416fc1674so922040f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782776085; x=1783380885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tx9bcHWuZ8oC4m9hNe2V4W31Y648brgxhiWHI5yWr0k=;
        b=mv1ilicsZbfV16MCTN8vy4sYo2sRH6E+VIEoWADwmMf8NEvUjvoI4KFlsazE7YwyUE
         BvEy49WV7yUfuPIWRU6etfb/1Y8eQul1vPypAB5SU93BwRZumhuhFph4Qeg0siMZrfJg
         M/FZ0S1IpZoFyDLJxMIRAlxOYM3thA1yR4duDJCvrJ3jBuLbo6VOjBoZaBY1DoPznoo+
         Mc5UeGlDc2L0hXO3j0XpIFiVAMU81TnfLde8OJJ6dGZHdV9yvDxWIhlbU0EtyWA+KEXG
         AvQ8KZFCm/qThFc7No7HSjQIV1Db4nD07IXND6meTmUwceJ8+uYVbgHxbipG6spcBpAQ
         sx7Q==
X-Forwarded-Encrypted: i=1; AHgh+RpH5jjiJ9DeXmddtkl5GBxEae8lZyePVPRyptVThwNX0p+rFfqGCFESlmzLKLEvTcffdNdEOZWIFw==@kvack.org
X-Gm-Message-State: AOJu0YxLZJn/7by+DcFct0YIM2RVN/WsRh8i42Zsew19L6chTSr79W0D
	AGxQWb7MILhuSH2CfcSLY3XrQNhE4Llbw5dW0nEHBaKEDmvqb1RhDx71EDUkfG1EAtQpYdPU/kQ
	Pm0mOJGTvvi55mvafKmdH8E5RqmWPKfde/DDIUiWpoOXwhtJlkU2j
X-Gm-Gg: AfdE7cnY8IowsNj/Hl/tgg1SSyedeCC/NEDiF+o+tjtv1mWvqehVm75sAxFBezjO4eO
	x+Ip+1WmnfEAMU8IoxDZXnY013zBIykSaw2iNszmHC/sQnmPbcS8t8Ex3e0YQg5G3+YG6sUSVQ7
	m22foI2DgpIuBZdhROGGEs/4Yxk1gmAJBktYwFqkxyc412uNLJ2PhW8gP1EYF4JIz4k8kJUalFl
	8Z9rBg+xQmE9Uhg7scZnH2V1KXk+q33wsCGMjPoIdSQQo5GcoCcTz3HELwePoWFKVG/lhJmIuLR
	8hnXO8vV1FWg5CotgO7ZnmpuoFYGqftJZ8RGtEcWWVDSi7EIni2NYIxi1nTL2HoVe1Ze8280PpO
	FehsjbQh8WZRzyXXqf+baQh+9anfTn6nC
X-Received: by 2002:a05:6000:1789:b0:472:7ded:66ac with SMTP id ffacd0b85a97d-475505f51c3mr1799238f8f.7.1782776084939;
        Mon, 29 Jun 2026 16:34:44 -0700 (PDT)
X-Received: by 2002:a05:6000:1789:b0:472:7ded:66ac with SMTP id ffacd0b85a97d-475505f51c3mr1799165f8f.7.1782776084447;
        Mon, 29 Jun 2026 16:34:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-475641e4618sm2067879f8f.9.2026.06.29.16.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 16:34:43 -0700 (PDT)
Date: Mon, 29 Jun 2026 19:34:38 -0400
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
Message-ID: <20260629193347-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iIRoVBPbpzXTSJoA93p3B9E35jLszaQ5vVjdTvMZGRQ_1782776085
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D554C0003
X-Stat-Signature: 6k1a8tcng7zfwmngnx1zakfcxk4b5qiz
X-HE-Tag: 1782776088-897228
X-HE-Meta: U2FsdGVkX1/Gqy2xpu02/aONe5loFC+bB9UOCJoYq+R5Zxu8HMuUlyKHSuDEPKYFMbIDnX9xJApEi5QcpjPhkxl43aSKb+xGjSEirqNP1rHsYHAjWDV+fzWDEt474Dv30++ImnEg1d+9p5VC7cBGb/IPqWXGMUAvwqauXe7xvUlyljMJFvvTFqyPa6eeWw/0wX4zZafRWthK8SclzW7jLvJmUM5wk9vNAQA8dKksr4/i8CNnPvJEr/ELmHvw9Vwwyq6OL33gA1qYjtASKNsTh5owQrD2PlbVnHfJ8FR9Qx5i4R1+mX0/CoGlklVdTZTKPaxhZmh75HBz1u++iPj5zQX0V6v7L03Im6iTcjVt2/NPWeeKhrPC1/SLxHLUYtEh9dXmXbWEtFbHJ9a8QAABcGkHrfKwmNqtbqsoxCSac6usj2KbZ2Z3CjMEEwArTtc024LihoMHtZ4JILiKDfELjXO5sHvMNiUe6v7P93Tm1JH9crKwmptooxRZyP0zTqZ+yB3ZP57nosnlJR7UwhsglP4m0s1jjUYR6SjvK6WAdhBB6/qqyRzctawW/t/bDR4FKjv2eFpsLrDY+s8SqOsSbysuii6oDxBRqpYvDJS508Ah83I4FokaVMhUut1TkRbUvxIRfa0l1bX0G+vhBVFkKNAM5BjlsxApsvoy+d/dkYxdSy371XsnQgHIhlfMr4tZizCXSK5Z1cjwwMGajLQ4VUPTQL5UDWCQ8/B89PjXwFyP5pBaev/hzMIb1DUnWW1lT4r6uuLE+N8BQ4u6DmM/oZSR9HpXo3A9I9xPHwtTlN5+nMLh3HGWjjLNnwh9JiE2fjF67b+7vtpET8v4wYHUnGf2zyH8gnQr7soh3h8HZRYdV8GZhPsXzOyPTJmBSW+wG1K7qd76AIFgNXDXwshg+D4vRYOv3JpfC6v34JUEtaSoQEj6wcHWRRrPZTh0oRYCxhDrsUXDS5hXHcNkPFi
 986jp68A
 +eSDfHpMAM6M6kt7nR763jUvHuV9H4BCKS83nR1LRVRmIbkpEP8vCNHjvsNJi8cBPEnCm/TCMfnzp4ceVzkCpVectUb6wwSEwU1LlDteCgwIWF7GCaSySK++Dip2mtR/1occBIzxkcnfyJHbzV6Z3bMIGa+VubHgcDKD3u+okhY4Cz4bxSMwzO5ZGkinTW9xIpyZu+Ie4Sg8Lc2NeOqPOVl+yxOMul3NxuU+vKIqJP3uxHsUJiQI59vf7cJT38FragFtryEaBk7ltXyi/apjzDGEFhDkviGUALy0d1UrJvW9WqAgu4FYiZeIa4oTRPLjqtXm8U05hzLAXSnKLaQz8AXsVQMFoK6KcHf7b/Lhs9cC0UW9dKbM93vcsMT6w23KFOKOBxbC8IvwtFWLXbKrL1++WbmoEHmFV6e1u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:43:32PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 23:22, David Hildenbrand (Arm) wrote:
> > [...]
> > 
> >>
> >> And again, I'm really not sure fixing a theoretical race when memory
> >> is failing is worth slowing the world by 0.1-1% for.
> >>
> > 
> > Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
> > read side locking is essentially for free ... well in some configs :) )
> > 
> > The question if we could optimize it reasonably enough ...
> > 
> >>
> >> From what I saw in my testing, if we allocate 4k pages
> >> it's hidden by the overhead. With hp and thp it's measureably
> >> worse than rcu on !preempt config.
> > 
> > ... for example, by doing the rcu read lock + unlock around the
> > 
> > 	for (i = 1; i < (1 << order); i++) {
> > 
> > loop on the alloc path. But I suspect it's not going to make that much of a
> > difference.
> > 
> > I concluded, similar to Andi, that stop_machine() is too big of a hammer.
> > 
> > I wonder if something could be built out of preempt_disable() and sync SMP
> > calls. hmm :(
> 
> Scrap that, shouldn't work I think ...
> 

Wait a sec, what about call_rcu_tasks? Use that and re-check the bit is
still set?

-- 
MST


