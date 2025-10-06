Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8632BCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71218E000A; Mon,  6 Oct 2025 02:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E211A8E0002; Mon,  6 Oct 2025 02:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE90B8E000A; Mon,  6 Oct 2025 02:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAD708E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:47:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72160B9940
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:47:04 +0000 (UTC)
X-FDA: 83966757168.06.C6491EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38EF1100006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:47:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DbTswMxO;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPuQyz7shwzMNySRUVtO/p0q34+4ONGwrtRGbC9zHCs=;
	b=kE9/rdSiq5h9L9/WuCtHVdpGa7vk+9QBHfySwaY/z6JouB0X6/h6+km5CgqK4SQ9m89dh4
	x5KYq0txbLjTL1zodRNO65SymYMbcff7b6hdhSj3Mb1X3SOZY+MYw5IGF2IZfORTSy5uiB
	oKN0pf6Hcfdml36qBEmNLrSZd1W9gD8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DbTswMxO;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733222; a=rsa-sha256;
	cv=none;
	b=tQlOt5Ff0kFxSa1bVtJncopU4tn64DBjw4d5vS3W6tDEFWe5CwYfyH9Q04odHWWeTBgJDG
	HSZ1SMbqPIGuuYrMF01v/kHEdX+Vdkb0OYNjeUZmJJBVLgH9QTGygpgOW9zkf/vbnMuV3S
	AXWRltT8f5lr5BVO6m3HNbDSnFV+SZc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759733221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FPuQyz7shwzMNySRUVtO/p0q34+4ONGwrtRGbC9zHCs=;
	b=DbTswMxOaGzx94pIIKA2JCPaK4/CUlUbx+3PpxKP9n8N68cPewcBkCMr13JRf5KkwklkxL
	X5NewJG42fqS58uwZhhO2eECPnnkwRCK2eH93uKLjtF5pfV5gvflG+mrtmO5UwQzPizDYw
	2nL8NbLFso8ggcvxxdh/bfIsISFq2tc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-N_BUEFZsM5WL17luMB7JCQ-1; Mon, 06 Oct 2025 02:47:00 -0400
X-MC-Unique: N_BUEFZsM5WL17luMB7JCQ-1
X-Mimecast-MFC-AGG-ID: N_BUEFZsM5WL17luMB7JCQ_1759733219
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so2414897f8f.0
        for <linux-mm@kvack.org>; Sun, 05 Oct 2025 23:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759733219; x=1760338019;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FPuQyz7shwzMNySRUVtO/p0q34+4ONGwrtRGbC9zHCs=;
        b=aF4G68u+6qucYumr6g+9FDwS81zol29mPFU73JjLxO2Y3d0yagDrKNsfraZGbZFnUx
         KRG7IqkqNv5f4eCtr36RkM9jAaa/sP6bTtOktuEiwfrl2ESkRGCFOuEOX4VwZlIbjA3v
         CQtBWpwQQbkSEewCRtH8UD0Ye8NVJy6hgJsK5qDJFEAZf4vRY+t/edlSLBNX3E7JiNFJ
         qm812AEiR2jIJKXX2k6lX945dOquWVImRSks4EagJE+7f+AjmtWOz2mtvMVM4q+QekZU
         DE5nzKlne32nHsk4/CxaateQgRP4QO2uDerAd3SR2h5Fl2EZWyFA8fINMmmkqSNyNSom
         ajRQ==
X-Gm-Message-State: AOJu0Yz8qnPvrb7he+NN7p5fthJcwVIsoOdadXECmLLGqWpK5yDGejsq
	o1HMBkyp5Hnm3ao9xjqmyGLg3yxPuz8pU38UcN3vkL/UN+jZtUkhjAO0RaM4I/qfr1QjAqdvLPn
	VkDMRYRqZnszyaJJgdAefVKFnYI9iE5nTwIzX4dMj4oGxrfnDTIK5
X-Gm-Gg: ASbGnctrneRW1/zR3wAgmW0/weoSNBTWE70exWpiteEGwTt9n0QQiGzqpYVEkSXg2Bj
	bUBO6nzsTKndkiFcW4Qpcw9nI27DSDUj9mZ50cvvb8iBHxRvH7fuUKy9itsdCxi+DBFhugZVDzQ
	c4dA23WsQhhkZfPZdWA2cBa9OgSUQmbSgGLEy3LzeqxdWX3y+4PJLZs+YFQZqvDvA+soPjmBkBe
	ZtX5JkLn6EMKqUWETUyaUHSp1KdPF85tugZFVim9ljhXvX+DJIETqUYvEZNHGI9BvB2GmA6leGz
	VHcF933UYG5R6seKSCBv/U8qJMDy6/nk/aOSzlSJKz0/1GgRJ680OyYc04ismDaOqUfldkSnZPt
	0bVbq23SB
X-Received: by 2002:a05:6000:2010:b0:3ee:3dce:f65f with SMTP id ffacd0b85a97d-4255d2bb045mr10090416f8f.14.1759733219104;
        Sun, 05 Oct 2025 23:46:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ4/pWaVB8kQDJnaq36idFEla4MhditXSnHOrwhfk8GEocayvX2aAoNNFYRmvRvmugFJYAqw==
X-Received: by 2002:a05:6000:2010:b0:3ee:3dce:f65f with SMTP id ffacd0b85a97d-4255d2bb045mr10090400f8f.14.1759733218762;
        Sun, 05 Oct 2025 23:46:58 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e77972d2csm105996535e9.5.2025.10.05.23.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 23:46:58 -0700 (PDT)
Message-ID: <35a274b8-dc9c-402d-9ca1-24f7d3c94584@redhat.com>
Date: Mon, 6 Oct 2025 08:46:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmscan: Remove redundant __GFP_NOWARN
To: Fushuai Wang <wangfushuai@baidu.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251006014948.44695-1-wangfushuai@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251006014948.44695-1-wangfushuai@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 29Gdm35l8QxOyzKoRZOS5Dsqi5B6jzXGLYoLrvqHmWk_1759733219
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wdr1nzri481ig1aebgpq3xeidntpooy6
X-Rspam-User: 
X-Rspamd-Queue-Id: 38EF1100006
X-Rspamd-Server: rspam04
X-HE-Tag: 1759733222-714919
X-HE-Meta: U2FsdGVkX18aGG/EaCq3fyyGo2Sj9tuKI98sHiHQJyvoB4uPUDMOewpCcLpGOPgoEPvrijOctY1wSbvi3X1m81K0InhosAZZLc6rSMET5fw/4v5wBWZom/54WntW5JtPOvWKsjl6wmm4NeHtfH5xG9/aBhADdFsqe5nOPLa4e+X4Oz/JuLBhiNoW1cq5lGH0ffnc5F4nh5zu+SfF1hKDv+dZIc1Q2V5KP6rIknsAz6T+ywNtsWtKWNSknYjm3PwwZTInBk++kjwgkpeUcu8xVTK3g2KQn45NmJ1yF0GUZRdAb/oabJCe6bMOOazyRHKqdVDZuRDPZb0jOAcJA2sTWUbzDbnKZLRepc7bRE5XpR0URxnvrD/xaG6PzgsRVEDXqNdgHnRycrrHiLuQZ6+swE1YyyKHwlvH1oZ0IINBx0muHWs9/voQBXCHGCbx7GV6LIlyLHxr6t+9Bq4Z0tvj7V9x1hYE+QcWFUKSM9qQG4YhIDWXM17/QJcXeDCCbDbhbim4pm+2YRPjH9SjsjuTUvWRlqVfqMhgImvarudYv1VMUbFkUhZ6gqKHcC1s0vJ8lHaZltNHqhg7siphsjQjZegGCBA+CtiQZTeoyFn0Ck6n/Bf9AFLpPn0EkJdvJuonng+ObwvKDKu9YTOiitOhRWwQKOExVPaEpsxbWYpAa927M5KzSQ87dqdEuQOlaNga0fT8szQfXraRVttCTxLIVhBpNUjQ9BTCpOEjbv6wCAXRVmqYfAAOL5ALKuFKa7wCYAyvkbEEKGHI2hjoYC9wGDKgZmsTWuJpD7Xunur95lupH1Up1lpOyCN+dkX0ssU3jf58LZ1QPlZSjmMO6f6hN+I4fWpMzrZfRwfB+0AxA/cSLqlDj9FOp7oiFOkpDaOHh7j+oiS7dpBIEYm0j3wm65denMe6Lg5Y7JxeNJkgoc13BDHsxfdVAKpiFCFIRCCP7x2yi9jXCpbqFoReeLh
 TYbdBRT1
 peDNMn+P3H5W3TExfk/ClDQITu2QKqKIi51hFPiCNqUv4acWTGbkmdZZ7C93/ysGxuMx64MPq+PEi7Y/CzgcogIFJFO77F0Dbvw8u7xuA97iiZ/xwO6brdwr6FFztN/ISsrm4mbzNZGUXTPLOQxsJIqzX/L4C3QkAJf1HjAXqGXPPvjMgNTA9MuyKERomKVoYcKdziLor9/0gckwG2gNCj9TSM1pYC4v4Ot/SeEviE191KyR6gvQFMPM8IkB/UDBRvrDXVeNZ3JFIOp2rxQJi/ujJR5R0bdScpI5T5BikKwR6lK9mHITwqlC1ZJfyy1FwYXvGBs0hH1ZMlmPiT0I6Jycl/7HKGpf+73t9y82IG8O8ZxNWTaxs13YUC+k6DOb06iOyB/pDJNggNkQJiPQlhRIdI0QxeJrtTLeqihP3VuXWNF26ri+eujr01HgsG7lEcKrjkHOz0eQWYnz8JpQP9en1ThanngBwMk6lezCAwjHilKuvOalwXOQpGy2+ADxH8SRzQ4lg+CTrWyL1QN8wx65yrlF/QweKM71U910mMo9f/c/HS9XCdqYXTNf8KVKLZ0VXI7Q4gPlXpDQZsw85ZpfRJfrzkriv0pjJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 03:49, Fushuai Wang wrote:
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
> 
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


