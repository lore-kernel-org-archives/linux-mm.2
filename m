Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC97C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5495C6B0095; Fri, 21 Aug 2026 07:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FA36B009B; Fri, 21 Aug 2026 07:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436386B009D; Fri, 21 Aug 2026 07:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2052A6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:02:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5583A045F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:02:46 +0000 (UTC)
X-FDA: 85124988732.16.649B52F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE3D020005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:02:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ExnqYX53;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787310164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+Zbs7AKbQaKbIL7murYn+4F5I2qORmS8p5vc7CpbKM=;
	b=BH/dZgv2suTGUmcoeGe9RKgjEOXFd/T4QOMjX9Ckms+ZfheYt3AIfTosUzLnsHq4/1jd3e
	PvOwOG7WvltAQDW7WsKYZFx93RTaKxpKN4YTwKxlS46uro6yL/G6n0B/3OLdfXtzcAp11L
	yb37AwT/eusLU/2eV3CJrh2qIYmD5AY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ExnqYX53;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787310164;
	b=EXyoZCOC9IsnhofimQgfNcwn8zlMgSodTtnsrzcgefOP/xITxZNCbmCHccDBwPHzV7G+gn
	NqONp5Aegi4cYHSvpcZD2CdiopLjHdRM8fZyG4dPFwTs18Z+atD1I7zlM8T3voWujRZaNA
	dKlu9Hu8g8NMDcg6Loz6NPT+ekwF3Bo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a422090b14so1374345a12.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787310163; x=1787914963; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X+Zbs7AKbQaKbIL7murYn+4F5I2qORmS8p5vc7CpbKM=;
        b=ExnqYX53Npszry64oahRBxx7WhJeQszYw6H3e2MWdVQEbuI9H5LMGQEnh4k7jqoo5g
         OpHaAs9hm1xKFxWmJqvCqt0HPmUAC/Vb4Hur3Rh41ZDyLRBEt5CrYZ6OS/Sfve2RgND+
         51CS1KcFt7xnhRs3/+GudnOEq0tOZ/pNzSDPmHoTqUGhRwqYMhR5dYLcDdz2EskLlGBy
         vKxvXMGxJOL9XITqQhK3qJBeATjPcHP5Nojk+haEyUUxY283roDacrYUe/iEXNFXzq7H
         k4Qv6Kk+PuAQ1HYeq1P5L+7UYi2ARV1oxYUli6JLYaKJjak7mGNx8r36XgV83hToJFgx
         A+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787310163; x=1787914963;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+Zbs7AKbQaKbIL7murYn+4F5I2qORmS8p5vc7CpbKM=;
        b=nr/S7jio792TDKbwI+5JR3X2zKS3kw0S+1Fms0wGFsDNxhveoC9qByHAdYSKzblYOZ
         DJz51v5eibR3A3i8DP5/M7978Xqstj6YTV42UDmmE//qN1XQFdzKZ+6dRflqyFqfq3Xs
         Yr2H3jr2JE/NXp+H+bNWiSfTbPiR0/ePTz8M75mUk3SF2SktNVi968QdC/kZ4aVd2JbJ
         jijLdiYMjlXUMTUF988K0WhYnGeLHwgz3QFWpZ4Z4es0QzmsrlEqyfCb/cCusupgwfnU
         2T6e0dFG4Wx1s85qUjX0R/VGhiMt04r0KpSXWgxuprcG8fm4cqeAljxccTGZJGR8a+kd
         ksbw==
X-Forwarded-Encrypted: i=1; AHgh+RqMRy8qKttqqZbfzrviskDT+BcmSbGWl6Nwvy7/8heqsCnF89lRCq4HAWwM4UNAg+i/1lay/GsRnA==@kvack.org
X-Gm-Message-State: AFuF++kCShUwUL4ctmaJ4E7eYDNGTHtkI+q9Dd0ET7DUdwZkjH46kHoi
	CCZrSebEYdOFAeSh5j0lQw8ExAKCoj7cTHH7ydGr/Iao3qJs8bwm+z8cmkBpELoW06s=
X-Gm-Gg: AR+sD10ezYBrCPI5ms3Ey3RgTmZr/n9od1pPiA0/oVUISmvPj0uQozVCFD5fyIhtu4P
	IeErbzSrSsaRiwJ7O12ved96RMTjhNrgeK4AbFQeDBFiB3Deg4iMPP8UDwGkPZrdpVya8zbb0S8
	onIpGw+Hk0x85gJHQlf9QyFRjUcTeEo+BNT3M5MTYJxhuaV4geEWFBtIQ5UpUeNBU6BFQ9tyYTZ
	vQwBueWfFo/0JUv9v62R5bn+bdKzRT0yAw0EQSrZPhK6CB80wlJoQXPraN73k76ObbDUCiX6wRq
	hooeq5ap3dp7hoCKRV3KsN4XoAYqtEgA9xTfgFMxYe0XcS7+x9TgbCHumkHYVcsNe/vLlECqggX
	97f+UiaoxBRLD7BXRilssgsAy9cBbVu2AjObIWUHLXJ8OAvVFeLT5hcLZWxcPdxTeZBID9+lle0
	2MUE58XOkQ7Ncbaw27/k72f0qQLNhZBc4LbBYBwe/hyxTq/k7PzzxhBr0rACOwEE5k6CfcKhZKW
	w==
X-Received: by 2002:a17:906:f5a6:b0:c24:87e3:b8b8 with SMTP id a640c23a62f3a-c2487e3d755mr132843366b.17.1787310162979;
        Fri, 21 Aug 2026 04:02:42 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2458b58a50sm456168766b.26.2026.08.21.04.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 04:02:42 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:02:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogwUac-sjfcs7Vi@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka>
 <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE3D020005
X-Stat-Signature: 6nxgz4wjur66skzzhapeajmf9b38n6qo
X-Rspam-User: 
X-HE-Tag: 1787310164-58008
X-HE-Meta: U2FsdGVkX1+00tQHnFmfScqSuRe7wUmNLhHfHKb/tJ8xR18DKYCiucA+spNz0eBiwlQiEGyjt5RIZrTaoHoBsWtcHb6M6ZeuQJPXsZwDYz4tMl5qCOfRhfXesVmbn3oVth7upsBuihkv2ULL0QACYc6PZtpArqfAuhDIIj356H/NIPwkSify2YhtBYFYw5fa0bScUdw2DkMDop+7M7ijnbk6S4w8N5liiNq9Qa3VzdQrE8h6jUk+HDDuXq0LozWnoUGGliKrpwxGflI3CF+fO9n63P428ef91eqbq0iatOlsq5W9TmtLwTz7pg3aAJSnEIxh6NX3BG99+Q9y9kxt2s7RZfg7oDPnQO30j1L/X+CtiJPFf0fLAp5LCTOrxlufbyEhjr9aZro806vuMr4Vdg9PQLRf824NOLeApn6U2mQmq4SElzK3+SWdLta5S1Vqy8bGBRWuRQ6eKSfMN3n6lWga3ETQ/hNADCCOpuuUGSCX/OVNX0+yTqzdRkpdf8WF3TAysADcJHeKmoiQrqLEAkxE6UIBc4PCdP+g8I2v5H2aRsxL3M0dwrm3hHfeaHE4kCFMj3KG1gbHa7HpacF+mMY7lGgsxmA23WU2Cld6CGfIQy70fqhaIG03lY4NrjUX4ZJMo26XypfwkKswmk0t2KfN9V9xU3qg9pCqnM5FskNvO55W4N+tRFUS7S379jAt2ibtR+B3oW3TGSM6oRoN/eZDu4O/6VJ4m1lnA4uM9OEr7eWBQ/nB7/a5J/WWObZqh8C+qU7Uv1APiFAaEjuC82Y3ceR4uphnDAXxtXKAKKOHzhxt26SmO5M0+7iolR7273F+DSMwSsKW2qv93sziNHcxzu7ip8zI8xOP9eciL6cXSAs17IXSDyPQCF7WBTzVt+ZKNlz0I3ldn7wg4RUA13mjRsOonLJkPzitzrUhmtSAs4sqxHU07hLpdqyGLECKrbaqO9S5b0HpjBDyic7
 2CCB93do
 bhiaTV2hme/q9Ig4/paGbuj/Hb7jSs6+gzA4wq9eFkmtfoaVI9pLRGG3p04mBjHvgUgwVV0RIGqzvCYYjQENNxxf8CrYQgExgXX2fz8PVinrIUqxckYQYUFxqcRuMOeGJdf220Qwea5wvAZmPYz5a8agdTJ9E//ubD84o2hsVfmG2Vvyjf0m5A/Bc5/qv18mFyP1niIWA3vp+aO35nLDJb0i3dquvsbN1QgilmrDjZ9V0Gd7MQmNbJsrackWl5lg0ccVJevHQi4Fp3ldSvLkawJTUSrQccECjRfMElozF7aZR99cCHZQxKJ6cTX08z6RI+ViafvwqbtHFophY9DT/qTwwh0TR3UmmMlZ92LM+EV7nMYnr1vWyQ8hFddQhB4+TPFfLQQmlq4wUiAFLfWj0W5L6x2kUdL2g4b2a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 18:52:12, Ridong Chen wrote:
> 
> 
> On 8/21/2026 5:24 PM, Michal Hocko wrote:
> > On Fri 21-08-26 17:07:32, Ridong Chen wrote:
> > > 
> > > 
> > > On 8/21/2026 4:31 PM, Michal Hocko wrote:
> > > > On Fri 21-08-26 16:17:37, Ridong Chen wrote:
> > > > > From: Ridong Chen <chenridong@xiaomi.com>
> > > > > 
> > > > > min_unmapped_pages and min_slab_pages are documented as per-type limits,
> > > > > but node reclaim treats them as one combined gate: once either is
> > > > > exceeded, shrink_node() reclaims slab, file and anon together and pushes
> > > > > the other type below its limit. Per-node proactive reclaim reuses the
> > > > > same gate and fares worse -- with page cache and slab both under their
> > > > > limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
> > > > > 
> > > > > This series gates each type separately via two scan_control flags
> > > > > (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
> > > > > drops the combined gate, and extends node_reclaim()'s early bail to check
> > > > > anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
> > > > > are unaffected.
> > > > 
> > > > You are explaining what but missing the most important part _Why_ do we
> > > > need to have this addressed? Is this just addressing Sashiko review
> > > > refernced below? Is there any real usecase where the current behavior
> > > > matters?
> > > > 
> > > 
> > > Hi Michal,
> > > 
> > > Thank you for your reply. I should have made the background much clearer.
> > > 
> > > Yes, the original issue comes from Sashiko's review. Sashiko found that
> > > proactive reclaim fails to reclaim memory when the node's unmapped file or
> > > slab pages are below the minimum thresholds, even though there is plenty of
> > > anonymous memory available.
> > > 
> > > After further discussion, we realized that min_unmapped_pages and
> > > min_slab_pages may not be used correctly. Apart from the issue above, there
> > > are other problems as mentioned by Barry in [2]:
> > > 
> > > Even when page cache is below min_unmapped_pages, it may still be reclaimed
> > > as long as slab is sufficient. Similarly, slab may still be reclaimed even
> > > when it is below min_slab_pages.
> > > 
> > > node_reclaim() cannot reclaim anonymous pages if both page cache and slab
> > > are below their respective thresholds, even when there is plenty of
> > > anonymous memory available.
> > > 
> > > To address these issues, I am sending this series to facilitate discussion.
> > > Your feedback would be greatly appreciated.
> > 
> > Those interfaces are relicts from the distant past same as the node
> > reclaim. I wouldn't bother fixing those unless there is a real usecase.
> > Pro-active per node reclaim is a different thing and we should probably
> > divorce it from those min_$foo counters altogether (if they are not
> > yet).
> > 
> 
> Yeah, proactive per-node reclaim currently does not divorce from those
> min_$foo counters.
> 
> Did you mean that min_slab_pages and min_unmapped_pages should influence
> proactive per-node reclaim?

Nope, exactly opposite

-- 
Michal Hocko
SUSE Labs

