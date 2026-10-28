Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4B3606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=gRNr5xd7
Received: by kanga.kvack.org (Postfix)
	id 1DCD96B05C3; Wed, 28 Oct 2026 17:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E8E6B05C4; Wed, 28 Oct 2026 17:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CFF6B05C5; Wed, 28 Oct 2026 17:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF4C06B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:21:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C841201E9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:21:40 +0000 (UTC)
X-FDA: 85373306760.14.7EFCA1F
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D9B1140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:21:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gRNr5xd7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
	b=Od1eV0lDY0sMNFoqfp1LSGJgyzPMK6w4bsJSJY/6mv7NtA8OHJM+JgwVLgLN7IZlH7XW5Q
	4dIPjaMjpKJF5qpeL16jK+A2cPfBmo777rDXHSUkrwHwrh2T/hZS75AnA4V9WzxyB76Be3
	4ItBqe84aL27TjmObvKgjTDJIz8Ryl4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gRNr5xd7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222498;
	b=s8aAbJi0AegrzW1aVOLngwnI1XUfnETa3udMop18CndDp5nKxhLIUFGmBSSSTG0KI58VCu
	9ObMXVbjmjMXeMMoHnikQDmhPMppw4y1asKYYRCuKEUAuJ2OTRpy3XWLnveDr15uiGKlBf
	Ojh8m6meKwtBYkGMWW1tPaxrko4Gw9M=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b10ac6ab7bso13849027b3.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793222497; x=1793827297; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
        b=gRNr5xd7rJUH3tvt7VBWSORYFMmQ0VWw7oggO5o18/Pq3rrJ/OclhbDVLd5R+qpjmF
         bEO5if4S9ywy+Y7LBZ0ZT1zVmKhv3SrsKyBI/d/ZGW7C/VAVyrXP55gmcTYVd17FF4Nu
         +v6ezqC3YndjuDHAQx6o6rW21zqz5MJX6QkFjbG1vgYYul2rj3vpIk5q2jRioEHJGgoV
         KJ7zTHV4xNDgxmCzwyfuwgg5C0psAj5OQukOv+nzUhiG8GEmpF8380pVCK2gLSw+WaYY
         QsW6lwit0wUhPQHGZvxFuoUVNwy6nJY0KXb0o4sGFThbku+70KAd0s6nCuD8ZNop6EDD
         c53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222497; x=1793827297;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/AnoOf4KaoFS/ftZh5xPkws/q1U7dINbhxvKXiKw/hw=;
        b=trULRvZm6NaP599uZv0Ny25NzBK5BqAKEupx4h4385D18WYnsV7SF/3dk9WPtwW/zA
         jCxch8msv/ACZEIbhOkp29wwKLho2Dc+kBrfUcblQ1iA75dYUFKqN5+V5d4tSw1Ouyg2
         w3w4ZTq/yikUO0Af9jaUPvsQGGc1VgS2rDcvBH62wvvajiWXavJP6yOK4vEHC1XBNjfb
         MGsCqR+8RJ1TsqOWiEqrYnQIJ73AuqCKC40tzgZYBRFNvBJI+SFTXQvrqpaMaiWkHVnF
         XDAqZl12B7qz4dCZKB5uh2L96wtIH85vPIDiTPXTtNFaJREddyyFmmb8mU6Y8hpzY8wC
         za4g==
X-Forwarded-Encrypted: i=1; AKwUvBzqg1TUqnm1h9Ci0GSGesPNTw9wiifjVqc0LwbB7SM88D20DM5G74w0ijZIl/TBHNeARh/ZtnUkxw==@kvack.org
X-Gm-Message-State: AFq9FYLzlH7SKICjsRsnMjotNHL8htDF9QLNAVyB/a2PSsb/gwwsCV7u
	kgJqnqidfrZCBiu5O7ffJkkgr6qE1Grh2Lzf3e9wRjsGUU3lnIzsLWzI3DfkQlrWFOc=
X-Gm-Gg: AYBFou0Mv2VuNlUMtTT8hE71lDLgbDl4YMNsTRpBfy93nnLyXmPtkfHWia7i2r8u0zR
	ikXhHUyATLiPogTkpSHHeccp2CQe0/cegeCWhSwZWA/Eq9Rxc9IuLRwfe6zT6+MXq/B+ZxkxeMH
	pkhTvlgvx1wennYB3Rg1mFU8HBQ8iGYZCZFx6XskC5uizC0WizRKE3ba31XmafwV2awoRUj6Vaj
	JauWu2zkE6RwCse2BRRVo/OuUMVvM1eDlLCikVqSgAAdjgY3CYvmJsWNAkjx4Cgc4PqCJRHQpmH
	fphlxgrK2lrFAr0YbfwjKYCj1+YR6er82nYUsMnRxfOpNptLEJcWlTByngo8Pe0Yu3OeZ2nl/uQ
	NL/CM9alpML2VTJThKPnfLq1JvOnYaOCff4RG5QzfID+89hqvIT60hryLkbfRNMv3Q+XRnnn+o/
	Bw2wgSjDaZmbaLWbADYXDtwAyEhs7B79TDo8PbYhO1kSFd1jE8tZm+0Jaq+XUQfGcZTo/cxF6FB
	gDA6GHuh+9aA/WLkV0L1PzMG4dc/b2gRLakMjd7KVPxplBiznvKDw6ivB9otgTpYKTk77CyllEg
	vAxNI2Zwy8tZd6WwIqXDVB1nr/aE
X-Received: by 2002:a05:690c:c5e0:b0:8a6:1901:30d9 with SMTP id 00721157ae682-8b1b5c9952emr18568837b3.37.1793222497186;
        Wed, 28 Oct 2026 14:21:37 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e566718sm35368027b3.17.2026.10.28.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:21:36 -0700 (PDT)
Date: Wed, 28 Oct 2026 17:21:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auJnYNDHiAED_dtv@cmpxchg.org>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
X-Rspamd-Queue-Id: 3D9B1140004
X-Stat-Signature: btmjffq7oumzd95gdzks9f9ror9537rp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222498-947799
X-HE-Meta: U2FsdGVkX19J65M776angEb8KA9YfCx1qfPEdmoYR+rnK8OANfL7HKAxFbEJ1s3NNJHbn2s5iVeT2kISk+xnKjmPy8cpl4+qhnthtakIhG1gfTuOMcQYRjmX5xbDKnQOBCduXb40zSPf9bJLAG2IkDkn7KlyamOoSIp21Sc8O0IaQyN3E4InmHkl5amjsPcQkElnLwDOraaFoFqxuVLlN/HbQiOyXDVMQUsEZW+EhMC2HDdWCKoUl1t0WZe7mLEbJF9PULcSwUVPuu+OiTpgf3eVLoDx1gBiI1EyjzF9Zzw7CTIWJDsjB4mzi+qG2HG7T196a7cAzi8oT4h5pmHy34BZIDrPtGeQfsw2E7PTp9uNVR5LZaaUOHEvVoTzvqSuX+4QhfK8/Z5Whu1tJPjI6xLK+Kn2V+IgfbrMRfij54X+A6BrltNYRAjV+a7CkhktD4tR7R7rHhu8GQJaM9+6Bs1K64P2fU1dQwaeL/KRHqoiThAMk3XD6TbOeDCKZqvqckw+tWCwyYAZoi83IUmz8x6CVvr4S/YjBY/zmbMR9yNsYDU1yqGPFxXoZ6mBu7EyadIVOhF3NPWlLxnC/ubS8tZnZXarEdDtjdqFjOizxZTP0PZeholKYZ6ov68D0pQsZ7RQ1nlAO5CugdH0NdK+vrVugX3lsxVS9JLchA0VsEuNP50C/JhCSOu1hd9a8JhcM732/HRsKlEaP05QJsgLmWDSV2TK3LoNpBrIyeYhIGoXDTRdpKnKPWKP+3Nsb8vpPou+wCxD5I2hrxrLEuG0ZtTukH3Ekf8dVd/y/O3tsGFzUsy/0Fo983ZeGV/5O8MX+dwdWlWiW7mvrwgYkdrfehvXy2jFqWbTbfGmCqih781g7TrDEHoibpJmQPhKdSSwkKIbiXb/iDxNDzawM/0CgT+fBNwJQXElWWSZn+jLF/LPMbOt0orZ4LFl7GWbh9aX8tAcvUuKusykveZzjX6
 h5v/LfJl
 iXtCpH65xLMcdxUNENDnHMb7mwpuwfoGV59ThwPSi2szVbNrJuCA58i0rCYAx6iwNGK6B53x92rX9V1l7MT5vjR8ZBdItDBfZUU7pOSsKDNW25gMj0MQJ+KOdjAcWeIejc00NvVGzaNLEjkHOkk5SZMJqiB1vDmmAsbs+0h8epD1Jtr0QVoJ54RgKE/X7irkrBFgAbvCRv3QpuQt9sw+Rfn2VvbOSRnVdG7WCUCYYM9gcfzTrRTUG84QWIZsE/oJ4rgyHJLMI+KglEzuQ4kU5BktH73gs3pMzho7Cr/VE0KdbYPd9eplkkh7Qf60TlEGrKKM7gN79mCQUpuGv/PE+7uLVkzbJp6a2ULC8OtfK3TbSNK/L9lftkFEQC4WbBVqBGqiZnVu4oXMeqaGu5d6cd1fQOUpQwUQvjcn72AEDeAi0+HUy4MFfiTtGJb+IgWhOIDM3QsKgfslkrb+J3jLGVxLILGDdztXRvWBdnkQZ6/lflJr+CcOJOgbVY12vtml4Z2kuWHFKY8pXl6Z7PU/TX4IfWOMPmVtmZWMU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 06:06:05PM -0700, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Great cleanup!

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

