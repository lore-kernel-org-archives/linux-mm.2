Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5D2CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB846B008A; Thu, 14 May 2026 09:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444DE6B008C; Thu, 14 May 2026 09:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E64D6B0092; Thu, 14 May 2026 09:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19DA46B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:53:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98C4C1C04C1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:53:49 +0000 (UTC)
X-FDA: 84766168578.24.37B1BC1
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id A01F8A0008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:53:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=APBOAicX;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778766827; a=rsa-sha256;
	cv=none;
	b=NdNuQ5hyoOPw5xHqySbHYaibxVoD9fDCXlzSDdJZyRNzd7KeVcR0jcfIM3RMqmkyi/iatl
	g5XRwba5XfsHu5RUYz3pBRe3kR8wdGkaxVKL1Yffd6UW+o62lSje3ayFHOg+A+04e4LCvU
	scA6gMLOfwvWWx1p33kWcIh3EF7yDWg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=APBOAicX;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778766827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+SudBIcbJEYVdXIJisNlY3md8aZgEue8Fntr+vI0eA=;
	b=WLXV3bWWoLcWmQJmONVWiAIjVehW3Bqf8JYbe3ei9DaAYciqdDFGekQgPFPr0F9Zob5rVm
	CllOB/dA1IACxN1VcN/BCT8d1Mu1b6Y7r4heNCRVGA9cS/eq7t3UlzcJhTpSqj6m3A0uZb
	Kfse2iAg14fefreHpiXzdQyZQ2yF2EU=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-90d13fa59e8so337240185a.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 06:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778766827; x=1779371627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P+SudBIcbJEYVdXIJisNlY3md8aZgEue8Fntr+vI0eA=;
        b=APBOAicXTd+doUqACoX/Yd5kShhF4Ohy/6riWt6MRF7yHKuMDLCIyv5lj2RKvnnVcf
         3g7NO25QSl2KIBvks4WBQYPLR2l/T0T3cdGyBnUnEVQpojX9bgGzqPQbbKlwIeeVgZJ3
         OU0qCfXG0qUWSfFiA9uiqeZGjwcBQHfMvqv58yZU0y35yttzf67cS1KCTnkUOUr87ESc
         Q0hql2GRW2hf/Au3hQtd6YQ70XXt04wdkWUfpxPpvPNw+kfSJPgTXj+fuVWD+1QkCwuw
         qVe1WNyb+h6nEl0U453CcNJMC4xqWdYKSzI39GGp32btBiXQYchEqaPkLVxIkS/r7/i1
         0TZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778766827; x=1779371627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P+SudBIcbJEYVdXIJisNlY3md8aZgEue8Fntr+vI0eA=;
        b=XwhhiXwnfNPWlNSP4DLhM7jDP8ri2zJ+hOXjEvwLBPHRheIH88lA87fXPPVhKZDu6w
         FT0lc+ZXCK3Qht8lQusTo3vkScVQySQ8FlUT53zuRKqJZ5pRJEQE/Kd0UsMs0F17cDB/
         2RJTvVwmsiKBeFTsoVCsd2qbwr9IQ4twnpuGB/+KKRgSMzee/n83frOcWavgQwETMTFU
         8ePg2G+hAz6qiSyRi1XcW6xmjYQ6FQLa39UCK6OA2IvcdXAbfFKLuRtnaDxvJgKLzc+f
         gXZc2BKY+IjBul5GaZmedJ6Y2ZBsz07FAtnsgkIzbd5mG1AkrvtPitWReeiRNqGyz0ro
         kEFQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IRGXsfaJ4gUo5xurbV1g8vHQVVZjA3RQRE4wYN+293wO6lK9w/VvZjnYwdC1xXOnoZL8hdoBOJA==@kvack.org
X-Gm-Message-State: AOJu0Yy29YI0S8iPiycCzeI9eke9TZjWfXlNzUknosSse16NABCATgdr
	iwauuvPMCTLyV6TuIpW13JtYvkK+mkTeYc1qMSi4lIWlZTTnFx0YXu+tYlTgjaiFfRs=
X-Gm-Gg: Acq92OF/lQzzjtXj6gig0WZn50z35rABynQUW8VkWnKew7var2/MQxm67A6uAnCl13y
	a/BBIs3o32YvAulKNM6xi1JKPpOCY6LU0c9ia7xewELdgdnnchXwLV7X/OEIPBz31HK8qyF63xN
	qOAG80BP280PET4JhTo0pd7Nqg5I4qqSrnYBZGN2SSKJidUqNc6f8N1mxH4JzuEHcjKOANrKclm
	kXEqh7WmfaLvnmIvvVLU3lDWWcigsAGADk1ch55178nv4D6gag7hwZCz8x1U0pxUS7y6PUx1lxa
	soAZRBTvrBmb33RSs6bNTVHTN74XDc7iGilDHuXrd0dym+PPnlchPlRrBgwFMtO6i1ZToH1/a7K
	/O0mQEdCNyN7FZ9TX4xr+j972NFah3vv3Ao28uMESzjsz2qpu2qUi/rMLmBoHhoCUn0NgjMV8Wj
	imzFrWOtBSbVjnX2uoO7xF3A+jw7fw7FsrDGJketAmmWFd/CanCodVpa/y5F18Zr+p7a4LhvwWS
	kVRBg580U3p
X-Received: by 2002:a05:620a:7283:b0:90f:d004:5480 with SMTP id af79cd13be357-90fd0045772mr809098685a.6.1778766826553;
        Thu, 14 May 2026 06:53:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba9454basm253697485a.12.2026.05.14.06.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:53:46 -0700 (PDT)
Date: Thu, 14 May 2026 09:53:42 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v7 11/31] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <agXT5s4FLL54MS-e@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <7d637bcac4bb5705388136a75f0fdfe2881e5f20.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d637bcac4bb5705388136a75f0fdfe2881e5f20.1778616612.git.mst@redhat.com>
X-Stat-Signature: djigwqhh97q31dtubea5pgjhmrg7sdrh
X-Rspam-User: 
X-Rspamd-Queue-Id: A01F8A0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778766827-138017
X-HE-Meta: U2FsdGVkX18lk4uE5s6K0VIY4tmxwhb9UBoxdNqnqo2qcvDHmNQGVcJGXCzqwy3uRcxXeR20e3yZVvdvBMF6m7UIvS35BhPjK6jGm9eutbBLZ/7+MYthzOwYPSYNkeiHN04SVljcNzjlbv+KG5HDS3RyinCI3I8mHRYvXmtzWkDPcvepF4a7RPzFor+zPPmm47FKXRcUl8jAHiaM9D+ib34YLY/3Pc7kq8ecKZzWL1ilPRU4y7IFeORdhutFY66cDUzrmTnEFouY5j00vdnhmtfw9VZpJ/mCM7MIO+ih7TIghvRdXuzp2SNEJY2SvauzzcDI04h/FKmcXBkSEAPgTX7zOBP9rYUriS6v78wCez+xvcHQyJl1YGaw764W6bo1Vb6mDpO4pr3blq5HGf0FnRZ1uH+QqxfHMVEEXjos0qscXelRB5m/nnfKoKbuOLdvpKdF8bfXpcqKAjJSSQmwh7NnO1KyNEtFcJHuXU1qP2zLpqS2SX0AESFEQeLjMdt0SSgJvnBp5D3JzvbUABmWFbKm8bweD41MV/qWAtJhmdHbM2luUPI2XcAYZyiZy2xli3rdpV7tftTL7USybKneYbk8nrc8gYYero0s3Fe4Yjhf77Gx3q4ef1ezt9n5vOIAWuhsC2h2sEU0VPKjQv7TW1cBBTaAnO7F/DVMsyHm93EuVq0kCzTJJl/DzglQAzDwzNpLFJpI4x9OW1fwDn0XWOlaVZ9NoIiVlom44g1mdsreiPhu9dv37VWmy3ryRrZ3wbolj1nYOw2+Qfyipt5Aozd2/RGUBaMzAMTC2S43Um67wh5hl8aubL945xmeIcRnVWB3iDbM9XJegyx70lmAxxxSHPsOZDrvGkq5h7n4i2MAxnSF1ibCh2HCjt90qmgITJGIOOdYgGPClAXgOTx4s6ThRRUQr/SUw1w2lYYZaN1efMfScoZu6Pm1CUb/uLXD79nxAT7hmqBvkJxSPcW
 KB7Qb/jc
 XVNx7bFjU1fbvpvkHvjUs7wjmg1ED4WHFzc5w+esymHPudJ32ODY08/yo1sJALhEjZz8R7W3ZmEJu4PxSjcux51DwRoXATddgqbrLeWOoCxuZ+P5cdrwYPurqRlJtNQpUMsNXyoLGSWwmWjhSySn6/O/BtT8gaUE5FmiPE7Udvzqx2Grv6wOPRlIqPl8svnhTxv47U68yrBybvwUOPjA3crli5b3lkZEXlxdUsasITuyTDJE4vd5qiqsoulKp7zy0nNQ20dPu7Z/S+sjiI0JLfZ4Qx+Khrf3gcRxMMmVUJFUGsYGhBdHtuOMInP75Ri90YziwmVJMoBWx12wJBGqyNsYJtFVsj/IEHTmBr8gE8zayvngy4xJWNS0xPX2msTPrC07qkyf/YgW/2GMijt4O5wKMHdo/s3sCNa219pA25h4s1RByW4mM88wJeEJlKQLHJg4/ytGpMb9OzcHMnli5MYLPm/tEmv8PALppsP/r/0veXfN+EDFTsPbbp+C36e+vgMlbuBS3RxktNOCUsedvUYBWi/g0glUpFJYu1Wq7t6MO+kxBjTZfm/C1kg3x6cDUcoB62tihwKFeOqKFen7YwywfOhrYd+ygARIUbaODER/SgNoJ9IM1flx10QGIjuGTqv7/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:04PM -0400, Michael S. Tsirkin wrote:
> Now that the generic vma_alloc_zeroed_movable_folio() uses
> __GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
> x86 that did the same thing are redundant.  Remove them.
> 
> arm64 is not affected: it has a real function override that
> handles MTE tag zeroing, not just __GFP_ZERO.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: Magnus Lindholm <linmag7@gmail.com>
> Acked-by: Greg Ungerer <gerg@linux-m68k.org>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Gregory Price <gourry@gourry.net>


