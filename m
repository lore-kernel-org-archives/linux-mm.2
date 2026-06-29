Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49B1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 22:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A833C6B00EA; Mon, 29 Jun 2026 18:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34236B00EC; Mon, 29 Jun 2026 18:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FBF86B00ED; Mon, 29 Jun 2026 18:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 674876B00EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:00:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8816402C5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:00:25 +0000 (UTC)
X-FDA: 84934319610.24.1FAE1E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6DAE4A0010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:00:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RKrup0tm;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782770423;
	b=1aU2oLQt1HwGJZZUvNloWPRVRi0aXOi0XXoLKzCcFgmGKHU0i6B3pk0KN+IVVxaujHh0lw
	GxWH4TclJnps7iPU7++E80VxkyzKHEagLNxNlYAAy4DRL/uCxLhaCJMedsrHKjsDVhqQ6p
	7HJg/S8z2W4VjfMdno/+GA95yi/WXok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782770423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiFXeMjHNJpp99quRxVQ4oRrHIqTG7TQuzkulOWcPj0=;
	b=sc+BO0M55fuoE9BzCZwt0CaLlP3UWat6CO42nn06eXf3ZejthqU5sufdxrYf+8qXwAhgpn
	LQd/0fdPZqT4AVT5vaga8ZUZOY9yMa+TduY8ASMhfYDQvyUZVRlc08jDV0wfsr+iA/9B+A
	KxqpuiIFu4p/ZPYIbcIYa9gvDih90Pw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RKrup0tm;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782770422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiFXeMjHNJpp99quRxVQ4oRrHIqTG7TQuzkulOWcPj0=;
	b=RKrup0tmuDNBTouDAw5s4eWHTuj3gsczGlCZ+gpIBVbHyeu2wZl57IxKxnPsujEmTgIkxy
	i/aIEr0qiFRShQHag/orANdEOB91BAoCIsOj/HoG9a38Bw7/rrUC8Vi5wmQ+KKs/Pj6pUp
	19OrvzHOLUnlPwjS+ufoWECF6f13x4A=
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com
 [74.125.82.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-JWF32R_DOSeoPtGwkY5l1Q-1; Mon, 29 Jun 2026 18:00:21 -0400
X-MC-Unique: JWF32R_DOSeoPtGwkY5l1Q-1
X-Mimecast-MFC-AGG-ID: JWF32R_DOSeoPtGwkY5l1Q_1782770420
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-138acbc0e69so18080262c88.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782770420; x=1783375220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iiFXeMjHNJpp99quRxVQ4oRrHIqTG7TQuzkulOWcPj0=;
        b=C8MdUSod3QPvVfudOgQ+rL7uzB4HZWfKfH6MUt/4QaCaEssclPGiF4HDv7ANFKGtMo
         R5/saxKkMusB0awS6hVHSQ7Kvt8O/2ThuPVRul6BNU6YZheAAQbry4DUdnoWBNHzzvGl
         YyH6v8kCxIOd9wSv03ZLyMCFHaSdVcypKRc5oiaKwaKMKecfvyrRDYvUlyljOpgjMsZn
         Fy2UhV+HMK3gVjM7nds/NYhrHL1CYxhsad1yV0FFV22/kLuZs+AI4bMEf8k9MFmgFazM
         vrucxUhWcBEDeXYxZd3LWZKdiH6eMCBM04Yj/Fj7/Ja7xPcDt59H/zu8Calc7Kq8avgf
         ruzA==
X-Forwarded-Encrypted: i=1; AHgh+RrHPI/vM0CYRwWBe60Czs3y8DCvlJyApOihzQ8ANOARLYvIkwtXXIk+OP3zgGkHwZGsB+MqS3/5yg==@kvack.org
X-Gm-Message-State: AOJu0YypKtl7xosMdYy30Kfs2JqYsrlfulgc6DZA9pAM8OFsV/KjaWgz
	1cC6CNwtaLZr+v3jn2JJroGA4mazWEH/RBGvLNpH6DahjYC22pDS//xm8DQ7BoaDoNt8HcjNlQT
	+G8lttcyh5D1fqGETgRt4pr7O+7UANcJ5Rc32EeHvyc3vs1veNa9h
X-Gm-Gg: AfdE7ckuAfKs2EuHsM4mLc0q7OmN63fvjWKLYFLYc/UQnu69gz2gf4RxPGQLg+ApiuF
	D8n11SYS5hqAwR6tOVJR0IIKIq5wpSYsA5MuN+mOpeAWnduh18TbYFN4+Q5dY3ekMJPWhweKXi/
	j/lx1HtTDqejWGlLacjhHb6thiMlR2tw1U+Vk9+klhrZGM/Sv1W/gY93yQQ0FkWZmpF5WNFhOvx
	6GYq0jMrC2aOvAZ7mcv4CftF+6eeex2f/swVTaTWPPOwFuLz7OPebAi6rdnZJNHKzNtLwgz0LzO
	lUibQ65NRHHk1+BJtymVPo3Aq7UTUNPTPIh7WpECgtevRLpFP7qhnkWWDTMbyzAjuFJA5BFaB3w
	NwxWNPJkpnGk8RANt2K2fvZW8gVgTdzAU
X-Received: by 2002:a05:7300:2141:b0:30c:1865:d9e0 with SMTP id 5a478bee46e88-30ee12287a4mr843064eec.16.1782770419941;
        Mon, 29 Jun 2026 15:00:19 -0700 (PDT)
X-Received: by 2002:a05:7300:2141:b0:30c:1865:d9e0 with SMTP id 5a478bee46e88-30ee12287a4mr843010eec.16.1782770419124;
        Mon, 29 Jun 2026 15:00:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2fc12e7sm1126539eec.8.2026.06.29.15.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 15:00:18 -0700 (PDT)
Date: Mon, 29 Jun 2026 17:59:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
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
Message-ID: <20260629175638-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <akLb3WW1nJBaIBwc@firstfloor.org>
 <20260629171727-mutt-send-email-mst@kernel.org>
 <akLmILr-cbl8Eqq-@firstfloor.org>
MIME-Version: 1.0
In-Reply-To: <akLmILr-cbl8Eqq-@firstfloor.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PEEbrvHfrJFoBWwV5Y695riqdP_oAT3_VQD_qaikZsI_1782770420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: x6qpcu3s6c65t7dg34rwf43fhgrgc13o
X-Rspamd-Queue-Id: 6DAE4A0010
X-Rspamd-Server: rspam06
X-HE-Tag: 1782770423-290302
X-HE-Meta: U2FsdGVkX1/mitpiAQzsJTzJhmgU5kZ8q99rHDXuRXOvV2oHlfrwA4W7YddqIi4A58fRgLEhJU1boIzdn9uKp9gmARAtFkrgAzts38QmEwdLjBNZmMgQOguP8Efxyd+FahScr4lwetNJi01j5WssGKC2v0Ul7fYtJVDQtywz0qL5zZ/Vju2t66546zFlILyLCbHGrY4p8Ahn4b532c0HzmJCLx/KqHvqROw4fbuSfpSAmd2Z6J8YVRy45VTSHhq3xAlmNO/r0yLBsyAVsNLwIbiPj5KhJW0OYWJGF8QtFSfqeOWQMc4fdlmBHzJxwibVoA/zvi5dBnvnvSLPNFrfCh6DZmHNzGKxcpC3pj9P7vzyHv0HanDM9T6h/6GlV1yguYLm1NqA0mPOXtcaqgc+kVFVAgdu2B/qsBSFNNkCtF37P5Mprt8c+IoQL2RcOQGCSO25kL/lQ9so0LfUQQT1t9kZDkqoiQgHpvQh4GHYb7S3Hm0HWXdUrRK89rckOGT8VSc/I/6yIAxjJDq73xHlHL/4U2kxpndNCea9FnUtI/MfMEivEUfPnFYeEfo+3uphPC3FJ8ozXFnDNjRGiNm9vwnBsT8KrqK1wp2RQGdRY/YpIvrNxKzNNa9qMmj8DWGn9X5E5E+by89sYX5sIxdUXTdWZwcuQ7d0tHjoCeY//Ko+w2vx3U4Miaq6x+CCcpekWqHHVl38aFJRcxULakgQ4rAAsJkTTVxyAmnUw+1El83aLFkejWNadPeUrbg1Eo4PLOkHk08YutwpZqwPInoW28N52ighPCvK+QUayDpy7k4yKQbia7UreJVsqoT4T4XT2YBHIeBCm1ERgtcL8qpd7Py5ltBCJ4qGzWOgeFDwYT762cTdeuDLrz6ofRuaqLzBETKrnJUPBAjwu0B/mWOP9jxT7mszDa7VbyXrQJr/l3oCrpQglMw9evPN2ODfFRWoVv1M8PNRqIkZ1mYhxQ1
 QzGKdJSv
 BQWVl1igzPpo9xAOr46yTGxA5Cs3OhH5+ovJYneeFnhbgbbJZX6N59KZcSfuVY4H1Xv95vbm6qxvWIjIBtZDqoPTyaR8g0LpbB6BtKenKqJ8JLaAigAk4VEh723ZLTmREcgJaAl3KhrzlHc+FMFHA4NY/2upGaNHBCic15O8colXgTCVZJ0kOF8LNsWuZAZ80TRtBj8YsLzJcVHvNAehMf4xK7sOkmKfAuAtYDRC/xZipxgr9c8ZKCGHFzWQ9Ojra44mojFNS34N8jYZWo6rsqVcOsV8R4vy43bXzfrsI8jopFxG7UD+oH/DW5hq3VM5h4X5nZMRx41ks2dGCF0R+BbyQ7r6tfDQ0XMFSIZyauHoU6Qxh9hJ7r8ROomPshGg9vrtKoWZKxC2g0rU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 02:39:44PM -0700, Andi Kleen wrote:
> > We can maybe batch a bunch of these, and do stop machine once?
> 
> If you add a long delay you increase the risk that the machine or
> the critical process dies because there is an unrecoverable or
> process killing AR access before the page can be off lined.

Well nothing prevents us from opportunistically running the MF machinery
once first of all.

No regression then?

We then add it to a batch and once the batch is full we do stop machine
and reprocess them again.

Hmm?




> 
> (BTW that's a problem even with the RCU approach, the cure might be
> worse than the disease)
> 
> If you don't add a long delay you would do a lot of stop machines
> on a flood, likely bringing it to a halt, even though other sockets etc.
> might still be fine.
> 
> -Andi


