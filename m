Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4899CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF3D8E0014; Tue, 23 Sep 2025 04:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496BA8E0001; Tue, 23 Sep 2025 04:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385108E0014; Tue, 23 Sep 2025 04:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20CAA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:28:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6E00B94FE
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:28:24 +0000 (UTC)
X-FDA: 83919838128.12.0B07CA5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45D8C140002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:28:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JxSpvtB7;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758616102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GS+tvOnybnp3O6O0X53XpAdOzzoNNJS6PxgRaybOU24=;
	b=0BThJhlZhdBBranowiGkq7MFkuGwu0dOb6l/O0Iq4o5JND1v3i8dQBy1RZpE56Fn2ifdZs
	ttHerxVB+C6tSqK2NRs8lda9sQ3nUDP2mOJ5zbh/2nXwRysIwpF/xZvuQHzJ6fiB0TL4Gj
	5iwwa+qv4BB7koWzT6ZLILwQPpi11qU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758616102; a=rsa-sha256;
	cv=none;
	b=k+6Hrcubi+c3lrv5bpqRsJlEClvOwm0YUC69ITpzWVm7+d7zJwKjFVqrPta5XAycbwacJ1
	t/UBbwaVb2HoeE2I68UqRjbJW8sqBTpTzSujyKI+3JzgJ8QzyVZzqEdNAY0zKP6YrT+xrX
	Rzh5OuOwoJNl4gaGcwO6pTeeJ3UkgP0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JxSpvtB7;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758616101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GS+tvOnybnp3O6O0X53XpAdOzzoNNJS6PxgRaybOU24=;
	b=JxSpvtB7I6vAEpFbzMK4epDFhCZFVPTYJAkd6GE9JsQrzWOwPKOfnfq8E4Xnb6KNbpiKuz
	f0nU7QM2/O0W1r30oU4WwXOMjUVTw7ocECN7zVLxI5NQ5uSQ4PfMIt5fWVlMRr9gBllszs
	WBAa0KW+LG9AMSIqcgrMur+KYnBg9go=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-ii4CNO-cOgOWijcCBoHfig-1; Tue, 23 Sep 2025 04:28:18 -0400
X-MC-Unique: ii4CNO-cOgOWijcCBoHfig-1
X-Mimecast-MFC-AGG-ID: ii4CNO-cOgOWijcCBoHfig_1758616097
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e997eb7232so2444494f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758616097; x=1759220897;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GS+tvOnybnp3O6O0X53XpAdOzzoNNJS6PxgRaybOU24=;
        b=G+b50z3PXJfkgad0VfOlmqBPfSedgAVJpaYBD4LXxwG57EkPhjaz4U7tEn8ee30ulQ
         qqExYRoBGYI90Ji7++Pq9qHinIfx0WSsP2BNSoxs2ErxslRtq4xv15VZjuHY+rgOUUph
         Qq1r8hFh7jeDkT51R1NlvfiHHHUUAmEVcVOWKMF4B0pm4dHNM/qx8weKSKBPCDRcdCsL
         hsOmqy7i3pN7eLOXpsJ6obBhm56j9KLY+XwqPhW4MgWECqYP3EMJME6bvNGmhiUlNPpr
         RfgIXobLzc5vy8lXpjOSOhc0OQXUr7cpf2jrwx9CZwOx2Pujm1k40GfdzdwhVAfCtlnb
         Dw/A==
X-Forwarded-Encrypted: i=1; AJvYcCW5a3T5++Dub444jAP6N4/jTtKWX10Lx8p02rub9ulUPDeAigOg2p0NcoXtQ04qefRnO3DZ9oDEuA==@kvack.org
X-Gm-Message-State: AOJu0Yz4ytKf5M1tX53+zyv1TAsVqIiCOqnzx8KuZk5S+B9E2EY/6ObC
	NmeDwWtPhGawErY/h1PCYHkuwAO7VgOGbE7YeO3+vCOOkbj1iQRMfCexfl12G6/c5KsS+rUEIW0
	asq9MOZIuJK6ihGGvVE01UjawDN0YoxsgwqUr+b8r9zjOTxIuxhr5
X-Gm-Gg: ASbGncubI486/Epl51GNFTyAQ8gvyVLKFWydUP3eZ9fgZC0AA9M1Pp3mxQMJMdFmLaG
	kzk/t6a8EkI4h5Uf1gEgQnZ2TM8+LCA7FxLJpf5qcqiUHhwkbqDkIWykkpqaiG791BQ+v8vQE5c
	xsIl2BcWIcnibrpFt4+9TNjNbJjZ7V8xj051evRaE8vHhbOthKOLcpnR6nfNHUOC4Y1sz72t32m
	FVzfZsd8iPSyUXdTjho2fFAEDk5CPbClwuxpSd8IgoMrma9woBAINKJZet0KIYs2AbyJ505OheQ
	fzCI9/C2+Y+eYAN6aNxIz6W1o/N4yFCPam3Djcivn77ip+NA/aHWz9+RV1nSe8v1R45Wtkc7KRU
	Ga6O/SD1NvaXqIL3fOIW8ed01hm5vN4izdUC5I50pa/rue+Y7lnwoniKw8zM/qDCNKA==
X-Received: by 2002:a05:6000:3106:b0:3f8:e016:41b5 with SMTP id ffacd0b85a97d-405c505241fmr1306406f8f.14.1758616097170;
        Tue, 23 Sep 2025 01:28:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHziPBDuhBDVi+ICJTxoEgNM/8e+/JtcJ6oteLK0rvVQF1Gr6+D5gkrvEqoxdsbVysMEgvnkg==
X-Received: by 2002:a05:6000:3106:b0:3f8:e016:41b5 with SMTP id ffacd0b85a97d-405c505241fmr1306375f8f.14.1758616096637;
        Tue, 23 Sep 2025 01:28:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7107sm24037069f8f.30.2025.09.23.01.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:28:16 -0700 (PDT)
Message-ID: <accb281c-3c2a-4162-ab14-38e883d1ff72@redhat.com>
Date: Tue, 23 Sep 2025 10:28:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3 1/6] memcg: add per-memcg ksm_rmap_items
 stat
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, chengming.zhou@linux.dev, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
References: <20250921230854496C6rkj7YZAYi39dNV3t6Fp@zte.com.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250921230854496C6rkj7YZAYi39dNV3t6Fp@zte.com.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i30GmSLW7Jd7BphDYy3RGYKxvo5jxFBJysdxcxpKoiQ_1758616097
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xacih3fskt3qtfyc96hqmaqzepb7oqtq
X-Rspam-User: 
X-Rspamd-Queue-Id: 45D8C140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758616102-578328
X-HE-Meta: U2FsdGVkX1+o8n8pqjX8h8WBdVhUUSz9xyRCvDmaUhWEc/EOu4td18yjb8Fs8i4EzYCgInVrbZ1z5iUMZ0UkEDF0oYY48KZsS841W+q7Z5pELrLns/PO0n/jF2nHl2humEKkmBqXZm89RwFhZAv+OsymebzUebuPMGCpxCRCU8cgXIas5nw3M3ASqVszp3Ubq79z0EsE69dIjxGC0Mv15b/QwAMXHlJ3V22pZ5lZf4tgn7ZoMRCzkO6xp+y/KugD7vOyLuZLSQwBgI2pHjV+lH7vvnCnUKIVohA8CAbbjW5V5+g/SeUU0bG1fVuVyXpFNT5t+09YaoxILvcTWPY5DqvAR3P1HUuaaXfotqzuCiqt349KtY4dRuiXJGSsHz9FO+dva5bElAt5BisEKeSb1/dNY2yZrrxx/rxNMakdnM3DHK2+E/avVq0TRMg3ChPYRPgs4ObZNM15y5LulDDuywMVGZymlg55J9n9UMduhgvP+QGBICvbTdk5iDBaUOJrGJ7Wc2++f2SoLcxrzmioDo/m5/1h4m1xfGwviu8l/DfEp4lASTmjwixOZsHpWZe7btbS/a/5RnFrL8TL095vbgm70pjzsDtoAw2tblr1Jaxm+gjCTX0HMkga1aNg+9Jx5btmEbQPmwxznUeM8Nxdmb838542t7EstJx2Hfdaeu0V+LfCer0x5L2em9zowNqXyojx81IjEqZgZd51Q38SbrzYSGzZDs8jcTVnmDVBbJrmdu0ClDDHR87rNScVafTMHauV6eyFkekCqJHpmgoYHid07kDh87Zl833FKZOWTz059vp+4QmIrHfP4ZVRFkrsUPU5qjbKDQLU3G9KdeT1L+81V09jOUsENU6j/4fu4eQwsVatsQW2rv22awLLdN/tqWBRPTvRn/4fpA32m+Mi5Cb0elKz5cRexUWP1SWGrQ18c+9X8QpxxyPbQVBzHwW5/ngEG7uxNF9EBlv9OzE
 6iNbJ16m
 rP6O7FKxfOqBOFLtDytUzxr5TYv4NjG3OKrWx8+8VieQ8x62FINVpA1boh9XRPFzvcQmocyLNHmvB2YatZ2A2Jan8QpBgEIZCvtTi/X3cz6UKPYt9U2UtQNpejm468GQ0KV+GiV1yfB8OzpMx5w7hkiSEV2wO70X5nc9JAuD1uDniSATHOCku0he/WMMEOk6vJIDSxdtaSOMv/rohFa9dWOo5JVm/ThHafpO2o21CIZKGjWrkbsccu9ARZm2e0y/InvA7w7ybkhMQTrdOLJsFb1hLxdJirvG7m8v9eRj5IIaKBwvretDHVFgMSOK3LNPHxf+dpB+XW3WHnR9yKLHdeRnGct+M4qVnmQe/6Ul6TtFVNEJfqiZhSBdbMOlxUSWYdeCouPnZ00jEU4pxoA8bWkMgAqGymuEc9UNNlLqO/BBlql2iCRp5VpDXbF5q1Ay9z1pjNgp0ertmtR3aa47dIMG93LZqTC8IOpE4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
> +/* Show the ksm statistic count at memory.stat under cgroup mountpoint */
> +void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
> +{
> +	struct memcg_ksm_stat ksm_stat;
> +
> +	if (mem_cgroup_is_root(memcg)) {
> +		/* Just use the global counters when root memcg */
> +		ksm_stat.ksm_rmap_items = ksm_rmap_items;
> +	} else {
> +		/* Initialization */
> +		ksm_stat.ksm_rmap_items = 0;
> +		/* Summing all processes'ksm statistic items */
> +		mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);

What happens here if you have to tasks that share the same MM? (CLONE_VM 
without CLONE_THREAD)?

Wouldn't we end up counting the same MM multiple times?

-- 
Cheers

David / dhildenb


