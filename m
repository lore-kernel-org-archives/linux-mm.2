Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BB9606EEAF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0PHiq03r
Received: by kanga.kvack.org (Postfix)
	id BC3776B05B8; Fri,  6 Nov 2026 04:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C906B05B9; Fri,  6 Nov 2026 04:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2D76B05BA; Fri,  6 Nov 2026 04:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86DEB6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:50:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28F8B140C8B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:50:42 +0000 (UTC)
X-FDA: 85404224724.06.5F8816B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 43F174000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:50:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0PHiq03r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RupwrtSRCRknDTCP4U8+mHVorluG3D1aDqrqCuXGL/o=;
	b=xNOYbturtPbWkbahdH5X0g+z8DaWPJYSXOqLZ+m87iNeYCt3BkFQdQqu11t4bB1iHpFZen
	hl/Iqe6XUzvdXCndVh8O5WDWHzwqqcRfo9BmShMXpyVph0X+c5dfmFqd3Jfv0QHny6C2sW
	2uV9zXR3DMNtUqXRtDkEAhv4CkaoPkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958640;
	b=BKF9K3kVl4eGud7jFuBX5kIXYwiWEe1ANNVz2rgbeMjhMSHtbsV/Iq+hnj1t/m4IekYphd
	sSf8aHHca04TKR5uKPrINWMCXR3RiR1UtzZ4BcLGA+MM8sFEnrn/jf5PX1WjwKmApZmif8
	/nkFCUOmSJSYHT9/fNQq7sNXZ4FIeNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0PHiq03r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so447415f8f.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793958639; x=1794563439; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RupwrtSRCRknDTCP4U8+mHVorluG3D1aDqrqCuXGL/o=;
        b=0PHiq03rEOW6tTCNwmdmmAERclYV5bEyueVaatAOriBi/0NXiU9Y1jYI9NDQh0Y8G8
         8C1mIm+3HIONuKShbpCwAluel62orlu0/80MnU1TnJlEPfiTTpZYTB6t2dyUXVVexcNP
         ZVjWe5xbsRbN87CyVO/t8UzuyQeXwPfXG5RRPiqvWrn83IzvvBgbhLRKWFBcWd9+W7T5
         gB6yHNJlu6lmm/v/Ds21KSk3oLajVCI7FDuZdpytZKvD0tYgtfrPRnzTsuG7B/GcfSSX
         VuuqvYdPFJW/0qJQfNOJGaOxpG/d7yHxgbBVA0Tk+xYGzeNvxZY0aEzDgZ7CyvnFwLDg
         F/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793958639; x=1794563439;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RupwrtSRCRknDTCP4U8+mHVorluG3D1aDqrqCuXGL/o=;
        b=o/qwv8LXblj25/YeVhHNskHbvtISEAEKM56UwdCCxuk2rj1hzSmgyqF8QxZFVEnGHO
         tGMKIpQSUAVkWLa9yjjHEk+LRJnMgPShZTbItgG0TRxBXeJM5Pmi4Allv+k/GrBLbZqY
         /OuiMNIdB/n0Xv3bNC61wypyCigaxdh/mANM12HoDK2DqfW95dtfRKS+MECKrsjq3fOP
         Hys7dAW8K+f+oZNBMRKMC5M1Mz3iv/ihfZpH7qTT7bd1G4b8LPth3mA9CTelg63Omdyc
         LZkTyWImZfChoq0Qa1e5RqEjD9QwqTSxOOUZ/7RuGOGFSMJmDXQvUARYFlAMZ29IpKyg
         4LYg==
X-Gm-Message-State: APuU4Z94Xl+s7r6LZgWPeFhMoHH9DXXX9lMVIeN6zXPTxAdR1YdT7Xr8
	vnzdyut+1cXEHcVr3VgsTESBv19dPnulQ/9mNyg+FTQL6yzuuNiCbSUk
X-Gm-Gg: AYBFou2+dIwqxg90P6S3+GXLZtscw1d0t4WNpveeg7U2uCVUiUhNij3jPh4gimeoMOi
	1Kr4CTnZ5YgBIIWR1hfuvnccfeporY9ls+8yrT+zJZAfhl+HuIcltS+ufZYc8MiNq5ywU8X+mLO
	8lGzaUbtciiuy7o71n5ItHI59nvgKfv+5Rnx+RIgQWQZFA5futnMRlW47s0zJOhs1nYPgyQe8tE
	HQQMz2EDbuCPIaDWf9JEUFIwDRXkQ03j++3Ot3q39jQiC2+WpH/LnjERGRIUObue/a4zdc8uhUm
	1LB1lJvNok0sg9Jxnj9bTM7P6+M0VBsOZVZytIsp9GcttmSxO3Wy2yETWBL7jJsH0b7rGb3sbyN
	HaGpuyAGOMvXhZuA6He8O5H+Je+p5KTcLX+5hvye9baLu039kduqWVggEEneKeQq129NqGeWKCI
	IFEIe5ApclVNmBvJMsOXEa3HnIwmNZtSZqOLcbj1oPjXcNLeyK4kw5dpY8V3NZDErN3dqV7ZpDK
	03obMP6QqMudKNALvovwjkpGpbbsGWZeRNrB6JrSODazICAKF/KbFTAeNIFjyeFe/Xn9FCaFkZk
	NyauZadx/6p/ynhOsnPw4UE=
X-Received: by 2002:a5d:5d82:0:b0:491:83e7:32bd with SMTP id ffacd0b85a97d-49277f88313mr3982559f8f.50.1793958637679;
        Fri, 06 Nov 2026 01:50:37 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d3d60e78sm2755152f8f.1.2026.11.06.01.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 01:50:37 -0800 (PST)
Message-ID: <6662ae76-c8dc-4bc5-9730-bf9f537ca9cb@gmail.com>
Date: Fri, 6 Nov 2026 10:50:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into
 pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bgch6bkc73n38u86wnwikg86or3th8qc
X-Rspam-User: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43F174000A
X-HE-Tag: 1793958640-681704
X-HE-Meta: U2FsdGVkX190oVgIY6EXBg90l8YL1S4TbuaYV0sMxQvy4fvo44VwSpOlKxtx3Z+B+VRy7dJL0ZaeXhhz+jdxEwBJUn3ZtUQLLq/KFDCkOzfGGNmIJv81Lg68RuIj72IZ8Jg8h8+u8eguql5jtmJW5zt8oRVATzJDYvnrSA1ecmLg+kKkUmjbfjKHWPov5ClL+CkltfL46OgY37ZRK5p89vlshJiDta7vMM5XXu4TOuCVATjLAPvZKUDWvSJLl3RKhV3mW9/ulqT33Ajt9xk9kT/8ALirvlJCSVi99+i6aEM9qEAzBp5lcX3ZuvQwwmG3/glPEawZAFFVZPxmMhOp1ss/Sh7ntjzUYg4M10dgRBov/YXg/G5l9NSPyKDvSDDce6V61arGmT+rtv2xIpKcHLuJNeAIAacDJfxL0SFrEjzlr6BnRsQGMb6xSiSBruR1/x1+16GSO50kYYP/Ljabl+nmyZnFD9uY4Rbt2GbAbxbgPBZjCD29D0TOFAL2yOdLGLo+bRZqRThPEDH9+Px76lKBGfIlsBFSvxW7i0beLhi457rWFo2RKnILUDRlCbD8b9OWxeKINeAhAuRohxUahx7ZNNt8wkQhyOe5ih0h/Cd7LzE29qWmCpOjt5WyZqKeXmGAqMKPHP8M5ss51e8PtUe+/9r+MXr+FVsYzEjG2m8pgbqiVcGECI1L3yzX2GIZm3fDdFxjHUI4PnnPI+AZmEaSdry19Rufp8dL2+QTAXkSgOr5U7NzHaXKqJsq7jyW8WsEWWJyKifc37MjMQkkL53ucB7O4gIlv3STmiuJo05rPOa/Q7UXxkOclPm1I6oHB/BhNoHuzGzlh+kVT0Dm/V/IB4OKN3xEQKQu0qs0EeRkC45WrAj91TykBuoFv4Ha2fmA4uBmYBOrly0FrSaH35+6AZIzci9HADRvIeLIgutsXIrbWUZ39Z1BIjo+7wChKAW41KnWnLN1ooNQpMT
 hM3HDwh9
 HaIstmvqMjBs7DykILRb6GTIopGAKyBVgXkSYsltc3vfMuyFuzn3k1LILQP9wqSW3e1yobV821deguumADbYTnxuZ8lIlC460ujRW38qjaWKp/MtSc9i+37imP0TdIEPcTqflMbtXk2P4zCc++wZ//ztEpOoAaGiEBSyY+uNgldt2+PGhmsXaD90bicGRS3n6m80ZePptXD09733X8k9vVpO+f9OVwcW+LFFUJuy70At2uNKxbtlP6/oW2ToyXzserwtBQHY72gDsDKUByHXRgLzrk09QW/rbSWyy/fvo8bCu6pWky9F5bI/G6QyS7oqH5NRlp6YAhwJsM+eJCTT1owL6Ep+YvvxhqM1DlrEp3JtW8RvNqHBWuGjyDihCY39hNv7Y6WFv8FOjYE2S4eLRktLw9cXqgajGZRWhVXDIG0KcU4r4jE7kPzEWdettD9hBc1q6GZMpIzHV52WRHR+G8EUfxUOV7LI7AlzPuVP3ZwcZ3eQ5Iz3rl5hFW+EsNM7jxMr+1JjbZEKyf+9GOuD3IWzuHIOxUq3BzcjSIPoj2dKo/lCqlUtdX495bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
> Similar to mapping pagecache folios into page tables, let's reject splicing
> folios into a pipe if the refcount is at it's limit, similar to how we
> handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Let's keep it simple and check in the two callers of
> splice_folio_into_pipe().
> 
> Also check in try_get_page() to cover pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

