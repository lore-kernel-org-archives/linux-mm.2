Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6198103E17D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 13:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227756B0203; Wed, 18 Mar 2026 09:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEE76B0204; Wed, 18 Mar 2026 09:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114976B0205; Wed, 18 Mar 2026 09:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0E8C6B0203
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:50:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59529BB0AB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:50:39 +0000 (UTC)
X-FDA: 84559318998.25.FB18899
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 467C640007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:50:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W4n8TL0s;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773841837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNIKutHT8Sq4z/Bn/gSEZuEvYmflVIDZ+z7WhX7LpaM=;
	b=zOemEQJw2pjKykXT8tDxxbopcJhbynIj9CQZmLpson/P3L3/TdEf7xnqD4fe0XOEb9MTwP
	hmtr3uYUng7/2QH4ks9yLFHR8AnRF+SgxIi+bQy57TGtMSQYGEyp+xC49BWOrn89BBXteH
	C1OgdB7uoAOh6b8UgBUF3NjVKiHta2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773841837; a=rsa-sha256;
	cv=none;
	b=RZ7WWoH28MRLqmM8iD/GGo71Po8/w0+nQ2XUYsNCzE1o0DAtASYYxxuh9CFAiSJIsy19tu
	DgmMnSKhqyc9IaZfHuEjg+SB2uphTAgAI4dtZ8Rv42GBhOWCdB1qoMZ0zylviI9x04NSna
	8I6vff7hT3Q/mprtNi1mO/NrDyPpbMY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W4n8TL0s;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509101189f1so61911071cf.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773841836; x=1774446636; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dNIKutHT8Sq4z/Bn/gSEZuEvYmflVIDZ+z7WhX7LpaM=;
        b=W4n8TL0sphJGy4/oxohlefqxTyYInESOuMtZ0NMSSnK3rRWofkSwhLAJ1Jqjrpt6y7
         Mc3tqY6sFD+MbntITmqp7dDOJyxtv+fSBjdTAwgGXVOOPKYbxGGM/IC29pI8i4OFaI0x
         7Lqdlsby4/0u7JqA20cL4hHSwaRmRPFGf0Uj15ntWoaUGgYwQx1zAZ7TBGFJ9poHLf6u
         aDQnOlPu38kIU7Ym8LNUtOj8KTxVxeKpeRsJq5zf7AD9iSxvo7eMRwO4vTv+ocIH5Kus
         kmUcI0X539drqIjF7QEsnhgTB3xYIY89zotirVGWGJRj2hH43Tt0ozk7dweFgtJloxT4
         mFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773841836; x=1774446636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNIKutHT8Sq4z/Bn/gSEZuEvYmflVIDZ+z7WhX7LpaM=;
        b=sSjoyqf+jQHuCdzrvsx1PPjnvjZYpVez5724pMSjFvq+07rvBMaTdeR+8n8FKGiATx
         XEPcer9Cs4RAyL+GbW28FsB2zXFIUhnxK53nWWyMgTflBLTvcpclcgyoCZAnc563MEof
         bEuTIwZCVBmURNaK3YBJimdyfGU/agKruOcsEbCpbWpbF3aRiDUXm/TTMStQmZouxo5e
         fOcr3eFlxbt/xfdDOZCxGAtQKX3uHXliTV9Fml/sbQl8hcPb6ZG+dIdx62d/YdvQf5O/
         VizolcCUGfEVHfUv0ted20U9H1/322N4cuqpeh4eZIZ5GEPDaJnRYa0dF8oc9Ts43QxA
         Wgig==
X-Forwarded-Encrypted: i=1; AJvYcCUdu6Qp56rmI61rNrt4DahbP3ICCyX+14lkZ4J1FX0egNeTjWO9HFsV1/7ikM+SJenqDrbk9mxZlQ==@kvack.org
X-Gm-Message-State: AOJu0YzbC/6KuO+gOUOdHf+GdQHsgBylsp6TGaF2KI1Ye7m1W2ln8C51
	FcaNyzWbJOZ6VHUedsUeXuq5Y3QBx4jALg1YpudpbdtjgaaVufBt0ATB4ehyHwglVks=
X-Gm-Gg: ATEYQzylvcdHbJEzbFKCheIRSuxzfrBd/tcbLcRZZCFD7zTodN2SQlYQJbyyg9bjNTz
	GWVZBvQZ7DgP53DQehp8rlng2Nc1wYQMHSv/icD2WILHRPMY2i0dAgmP09hKhOC7FIMA1u7Cs3g
	mQLWVm2+DBMF4Tfx+2Voo4hbH+amNjwQqR6hsRzUiNmPMwKDiDchznw7rVG/IhrO/2MyzkZqLAO
	QzakLFRQTLzNlnzR+gTysLf2oLA4RUUQQVywXZ7M+TKe69eb1VVTXD5ee+Nv1xUdZWg1NTuCN57
	G1MPQSfPCjPvnENoGoQisJBr7Fi9dkn9SsFql9szldYxZGhT3LyzJyAasMULFL9POLViwsW1okz
	RGPXQrYoaK5KNUlZa88tfW+WXAoE1f3UQjk7KDwD2LQDvcKuVeup62V8omj/Ls9PfN+40GOz3W0
	Rfm4e6HN01Q5adfBJ2z9zsRw==
X-Received: by 2002:a05:622a:46:b0:509:3c8c:2405 with SMTP id d75a77b69052e-50b147aaa16mr42355181cf.28.1773841836061;
        Wed, 18 Mar 2026 06:50:36 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b13320817sm28740421cf.0.2026.03.18.06.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 06:50:35 -0700 (PDT)
Date: Wed, 18 Mar 2026 09:50:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH] mm: skip dirty file folios during isolation
Message-ID: <abqtp8kpNpRhV2Eh@cmpxchg.org>
References: <20260318090656.1748509-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318090656.1748509-1-zhaoyang.huang@unisoc.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 467C640007
X-Stat-Signature: rnkocb7cr457qeiqboz6eyepd5p4cz7t
X-Rspam-User: 
X-HE-Tag: 1773841837-366543
X-HE-Meta: U2FsdGVkX1+Coeo46hl6CZTdvEiGfr6wSOnTiaDI1rXfYddtif20qJRT9hkxVgv297Zqy4cekVfNQ8oSPhYG54gsc69ULeE3Orza7vhYLHQoiaCCQqCeVaNQFtLkWaRDwCbYg3FIv+G3ckGJwqEtYSETJS1VC8ZXZKfR2p48CreIaEo0Chi449m7oIQWDWE4dtAa2/ID8QE+Zvr59V8dxUqqM7BubSimsOoRSBL0MvzS2mx1VwbQ/H2njJ0MlbSpbuj+K5bTCKbbVyBv3/WIX6ZuPAcQ7QNgE0I35ooVgbCplAxiSskorwrNkPG0nt1apr1dMRzEemtFLuH9OqCe6FLNq1Y5MFidKAC2HJBWHNmF3ReG/ESjWbKGV1gn1QSd2Y50B6sWTRJrfybvXh8L5pVNzXSUni8AcPmXE+rXHFMlqPglMQpsjtn6CVvAgKhQgSDbqwrH8n2c5nMyVfNVBruyi192BUrqRiEPwpT/5Y6uTRulPTMoefAHDjWCjb1uEU3h5TRjlpF6hGMEu2Y1GU5pxoWuTrDkJNJd0uAkzc/okWC/VCjlc3VxVd1K71VNJ28IP2mFNe1FO7nBP8KI14uRMI8w7dsjDrqN/P6Y9xsiKKBRKy26kD4wyoln8Js/irLaVrAQR+TenR+u5y0ccalZ1ouZrZp560V6rYNiSROZvjkqExIyis96/0LNvdcmMGj4wJ0dJJcgeeNowiDqcglBrUhy5VU+ZpuzBga+t/oeGxlAtPQY5GpCLNN7w8iTUvxRsxro6VlZQjYg0mDc23GkJAMYcEGXscImdR/+lypXp05AWXAhaQA2DNCPYzufcaezXbV0nmjAovJx9wm4OJWVl5dp6gxFl1N0CTS6Yn0IfbX2xnAe3l7h+ITQbuDDt2VCIQpbTsJcaGcWLynLruCWbpPa/11Dbln/4kJQUBCz26jS7QgFlGRDa1saZ6Qb6tSBZyQWw6/clUPrYHW
 g/PN3Lr0
 rEf5qNJS+F4E5D1SOa1XQE0Q4DXksZ1Zlz8GVjBP+truvOkBRip9/TM9BJ6HdtiTDZYyb3T5pkkzffXz5U0OznW1gZwYnpm2PiStrNofpWbGoGmqZ+ANVUrACkr07I2Ny4qoAOjvbx4jfCBjKLgx2x0lC3y6nTj97Rh8U0vEZtyrkFlbS7zxHbfeWqDfAYBDokuHDcmG0h3ZejkicMZZzQDji0TVdD0rGHnKNEusDuu3VGK7bjGwon/iX+Rgk45M/c2fpL+NBHOCpIZ8py/KNbyXe1aNNpMa0uFu9aGULDot0Tfsgc1SPTUqdIBla7rmQ1muAV++UHbcIj2CXWS7Q9PbTZiqxL8zOW+f87c9gnCG1p9iIHgE7oavB+oBa1xLuwp5qbds3Mm8EhB8KFiQoaIIF1fC310/qfmjEfOEAdAOszIHJyR0kYA9C+SZU1OKujL6n15ZOaaN2tn2NkDeAP8z+lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 05:06:56PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Since dirty file folios are no longer writeout in reclaiming after
> 'commit 84798514db50 ("mm: Remove swap_writepage() and
> shmem_writepage()")', there is no need to isolate them from LRU which
> could help to improve the scan efficiency.

The reclaim scanner needs to sample dirty state to coordinate if early
writeback is necessary:

try_to_shrink_lruvec():
	/*
	 * If too many file cache in the coldest generation can't be evicted
	 * due to being dirty, wake up the flusher.
	 */
	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
		wakeup_flusher_threads(WB_REASON_VMSCAN);

