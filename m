Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2436CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374786B009E; Wed,  3 Jun 2026 11:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C306B009F; Wed,  3 Jun 2026 11:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262096B00A0; Wed,  3 Jun 2026 11:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1480E6B009E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:00:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D371C1C0AFD
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:00:18 +0000 (UTC)
X-FDA: 84838912116.08.1A6F805
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0440416001C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:00:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Vo9bhz/9";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780498817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvMHfiHYUP99FrIyQrPKXSaUDFV16/XdU6uT2nwNWZ0=;
	b=xzK+OBoBkTVjvTX1zEGUUXjSTi7fW0D9LMIXfCV5F8D2OMdwu64hokmBcLP6y4Uou54y5D
	OlRN/nRY6nqtpFnFx1ZlKnNGpYJ1n0JMq3F9b1PGkY4rGS6P564wBthOhCkWTCMSEtR/+D
	ZvVIw8cYIGQyWzgbuBNtYaTdc84+nts=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Vo9bhz/9";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780498817;
	b=0ZfMMr0Q1Y/45X+0S/r1xwpOG4p0NIYrlf1TJh0tO+RgKOTMG+izAS0Iyw5ppwMeMmNyyC
	/VrDFXna5s9xkSZRr+dwnYHiDKi408ZpQIuMJBjpN8QRLLMlxOhCqjFJxHNf++oMRf1KR6
	+RDBm1W9dYMqTregGgIj0VaLht7rIqQ=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccd1f57b32so81296386d6.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780498816; x=1781103616; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nvMHfiHYUP99FrIyQrPKXSaUDFV16/XdU6uT2nwNWZ0=;
        b=Vo9bhz/9Ibj9R/PIPCMdC2hJCERpUqKB/t8EisZo+4aWl1jrKkX8YCFE+xrGnlby/g
         F1JxOfH2c0vWqb2UJDNp3oSfU7yLT2vixc1WSQ+zBlc0Q5taf80eREzaOIe+4cRRimm8
         eL3D3Chyrqa7ttLR1Zzkvf2cb+J2Bh+aA6kccTq9ADq/XEdCKLZ5+7nuo0sqY1jROEQg
         okot3eb4uJVlQJJ6R4jmBaEg3iD/qy+rYbOno7fggsZO7wY6QLh1b38cRMUCffiU34//
         K30+NEfbGQdiohqLi24HEqZdQolusUkFlsjkWFfbCPahBZuoyIrOCIW58WJM+ANuEN/Y
         TJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780498816; x=1781103616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvMHfiHYUP99FrIyQrPKXSaUDFV16/XdU6uT2nwNWZ0=;
        b=HR61R+imjGmJbvWaMH9dh+dv2oMHPnRoct4CqVApANuFexAAHrISRjh+cH7IKJRAVQ
         R5TkfNNaTr2GNFw1tq82D8iEx7NaWhu/FSnijH1VL0OKIt3SQUhVmSxJYtJLArZPbvDW
         ekyamUulYQlNuq175Fz0Lm9TWxQq4BJCwQTM9GkyeaHJfP4UDdMII5L+stQ0ja20K9W/
         LxCPwME5w8lQ5sHGrjNg+vWio9Ma3ToSyUUZqJlXLu5V/05SRQIqbX8z/2rj2WkQIezq
         MBgwb471HiCaaxEjzWJlygvoxDA66lRJuLcYwkdNhxy0yB9WKy+qcdPB9m7bF4iOjMVd
         0Qrw==
X-Forwarded-Encrypted: i=1; AFNElJ8Wfyqj/lFUCkSU57BsdZjPurgFRVxLORWKnH/COCgmYxQOgNnx+9rG6fsrBcL+40a6XegygnSeJQ==@kvack.org
X-Gm-Message-State: AOJu0YyUpNM45qZl8ovmI8tUTNCQn4RKlUlsILQR/NiFQPV8BzLsmO7p
	HhYAorK5zXGfBUP0/r1UdSYNiYFyEqRYwjNrgZDsIWoLE9pD+KznuPPwVMpd8+4PUnU=
X-Gm-Gg: Acq92OFztkaGVuvwjyZaJuqrZn5Hvu7DlaqpHs+izEkB2havepa134mA9H29mNRfmc3
	Issivmih445LnEBdUGGb1uRis28dxlVJJ+HsSF8OFEs4qXjHSieG8gSjLbYnuaS+OiVG35Dw322
	KdHwonmKYBFmw7J4evWUfXi2x0+FrODLccABuTcTgAqoxa74GadFIXobbcg63PIgIDoCkGEiZAR
	QKwhFwTyA8h7fCHeFAVkOfSl+kiqjn5zDfcdnF0JqdDSBFziHWxvp7SbCkWkSZn1DQRQnnir77E
	NfHoWgqHvM9C2CZHqsQhK8bTJc5K9YVB80d2SeqGdvZUVWbPFgyP4aXsNq7GWKp0vW3Mz8mDdX/
	oAZ3gw68nu9alb8u8+Hap73qEnXdxGqoo8Xu9GsZd0ILdrCOmR7k4WqZWND9Ha9gXsxhXfEmcvg
	C4BSZc8i8DddaDP9pVOylyB/rTby5H6vleXMACxRUCzWg=
X-Received: by 2002:a0c:ec03:0:b0:8ca:1cee:7c5a with SMTP id 6a1803df08f44-8cecdc329ccmr45124016d6.12.1780498815694;
        Wed, 03 Jun 2026 08:00:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecc8222bcsm22979756d6.0.2026.06.03.08.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:00:15 -0700 (PDT)
Date: Wed, 3 Jun 2026 11:00:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 3/3] mm: move reclaim-internal declarations out of
 swap.h
Message-ID: <aiBBfh_lR2AUHidk@cmpxchg.org>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-3-ce0219e100d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-3-ce0219e100d9@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3jpdnxs3empg8ehkyzbhg6o6bzwzefx9
X-Rspamd-Queue-Id: 0440416001C
X-HE-Tag: 1780498816-707043
X-HE-Meta: U2FsdGVkX18CoRGwLjdSflmumGgheJt/EBvU8DKxo3W+80GzFracuI4hti3PCa9GvFYnBLlUV88LeAxlrzeTheJtaD591B7j2WfDC4INAs4r+gakrRXYNNyashzqO6RIUr74ot0lgx/1hOCXmPbxtSjBIL+S+swEfp2Z42p8HKhGXVFf8JDhH3ONhn/SxSHNuvSxm24aloZWV/ov/Qh02RP1iGujUiDuoOcXAJ5Rwfi6UfFiJjD7D2ObibpJB6DZvpw1tuL5Tpp5HANHIggeEJVp0in98yZXgVmKpQ6t/MAxef1zSdLFyppUSHZMyRu9OCN7jgxMb+9Z/YXBEFy6WCapI1Vh1PE88odyZRTEpi6XHKKhlq+Ps8iDOo4Rl1Hzo6Vpo3rSkc4n5W3t+vzeDKHjG5+XkXt0NvGxDMFP64aBzTHiy2FKbE4mGchYpmBB3k6zPHThZgIDKnexlx0V7RdO44En0cpVbA951CnwWjUeNzrDzKRj56xSaqrb3LqdInVsZZEYmjS+bdeewA88gR4V1UJffJYcFTzJrD/uKbngccSovQZwTfnLV3t96d/jQKK5P3p2aUChrhb39hpsnpvk0rvJ/z41feEqXxHajBZQf6y5ycfKZnkNhgSOu6EO/f/8llPYWZOk5mQYzbgvVTnQ8B5VzXOsxqW4n+L0OvDqMbcuLWWL1UhkJ7ZewCqAR+d1s3TaKXU012SgeuDTlqbCFat6jlLGfhoYqaBef8EAFPzUGgjzx8EXp+HBlTdrYw1n+rnle2jj43aocyhC/9w9EgI/mq6oufMtTGTj2lyrO7Fl8cNcLkwNuu83oC49mY5p30dl5F4chojcHwLuS++jEYyRbIB6kHgzyLWWCr6jdWDpxfikHOYcsEX9nwp/WCgBDDwo9aKNDol8OFJmYdEtF3OOSfFRdYX2PsFfybTBOoxyLOJ2L2dNT6vO8wfXwdNiLensMbbgl5jFShK
 mRPgHLso
 jxcvJLMz0H8AjR2MJyQAUs1eqReVusdIaju9zUT9lYXddPBzfk1fTAEQAInBTcbk4VJryzeoDcWhVJCegKtBF7Dsv2hv2V8F1lJ3N4aiItnSdIL7fcwyP7NACRZZnhucrVLxgg26qJI3fHlmHx59aBzMSRCHlTv6fiYRyJPpjKHfvxcw+yD/iC18NtX8PihhF6CRF7UzX6hsGBcWnN3+I77Uujbxm4IhGo5kNLmCkLoBnWEM6QRDQisiFzsuGvhW0p7iZTTir1vmQTZrvFadXwevpPZ7IYu4ePRiH0AIgcDxidot3nGQ286aqOSJaEAKo48Znm2yWpr++HzX7Jjrm11TqJtCQmOjl+ak4paGxRi9tK+M7xoi/MCPXXkbZQwiPcxuiVldz1G7jneyIDMXZnRe9zDuk6E02/djvyBcBlXNQWzGw7twisRTOJ/Td9dZnh5TwwRDRQn/pNwVlCOvoD+n6EAThVzq3gv/yMvr60aldt1UVRiJaMM31sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:05:34PM +0800, Jianyue Wu wrote:
> Keep include/linux/swap.h focused on swap-facing interfaces by moving
> MM-internal reclaim and workingset declarations into mm/internal.h.
> 
> Leave the small set of LRU helper declarations that are used outside mm/
> in swap.h so this cleanup does not need a new public header under
> include/linux/.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Nice cleanup, LGTM.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

