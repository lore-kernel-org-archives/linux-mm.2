Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90C0C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 03:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762276B00A4; Sun, 20 Sep 2026 23:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A256B00D9; Sun, 20 Sep 2026 23:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FC36B00DD; Sun, 20 Sep 2026 23:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 417FD6B00A4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:33:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC03C4054B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:33:31 +0000 (UTC)
X-FDA: 85236349422.10.A0BE27A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF94F40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:33:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gIqEJlLF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789961609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6VHmJPAAkgAY7kGGRO3HmxKD/ZCEfTtvi3FHnUUDOE=;
	b=22iZTpA78mm0TZ/GLXS2Fp9jntGGpKaXKxONENX7zwhTNbNixnlrn5IX+s46nZ652xDRWz
	vM4BKqeToaWiPSSQy7yGRKfKAjf/yg0qAVUCWXNEqY5VCsDDpXu48CUAtdiNz+0EDO3jPn
	0NXDCJPiUY0L5sVvFwq0Z29vBR5bQI0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gIqEJlLF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789961609;
	b=R8MGSkzGJ3zT+3pPbzGZ5ic8LtPbOkse8yA3fHesvsRBZ1XyYxbgeXmLw7PbWfeKAC1KtD
	KzOPh+YXrIONMRz9ULsc8aNg4dW20CSr5lXaBrlhSO7PaN3X5o/zbjlu/DlPuMFj1dcq22
	dL7Qx8KQJVlkykkWXCMQmq/uvTgqkdc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5306abbdccbso29303621cf.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789961609; x=1790566409; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A6VHmJPAAkgAY7kGGRO3HmxKD/ZCEfTtvi3FHnUUDOE=;
        b=gIqEJlLFpGGwcM86B58/LliAGSSIfZ+D8xbW/tSqXcMsG1r3qv9soFjOAiah/CXpKh
         /Y3OkSmpv+SE3xLNcF7ur22035qPFnXn5JBqJE+/5iSdZbZ5n9q0o3sqM6ixnjKO8eCy
         dAtSb5lD5bCPWvnnPEQxQ0VjEVTxqwCBMISmUuoZfOpYLburzaqWX4l9YqLWHHSBUHCH
         SZDe+TdHO3REwK2mXMLz2bPWs6122JMA5dtDSWd9u1fXBBC+kc8MfASPBUypxuRCOnhO
         9ocL353mharK+w1M9rpM7km4fyA0UpK25Q/9sdj0ME5Y0zjKmCWeDZc45EuMx6ID8qvu
         dIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961609; x=1790566409;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A6VHmJPAAkgAY7kGGRO3HmxKD/ZCEfTtvi3FHnUUDOE=;
        b=uJbsplIeu+NDO1OUcPC7aB1jxWVNdlfIik0Lx9k5nZ6zpO2/NK4TQjpv4id4VQOP6L
         te/1TonCwvVyrkdFOMb6xOvCYz5861VQIp7x7V5m54SLYwKksqb9GPcChLHEc/htyJ+/
         IUhnDvQwFA9HJ3O2lXyMg8GuLNI4iEkHkoQ+uvST0Jqt69Ti2jzMF0BqBsodWksQlzMt
         zC+BsIU43YH8FnmyQ+DXmAv+KrxYnUoEHwwsHeTbJ0MCM/K7bflNTqaLcAOY+C5K5+fw
         UsP7Pl4s9U6qg4y0InP+4UwQUgu2p7dJGOG2+PPdWUfQRkN+mUbwsSwIvvzbIt9dkn9+
         VgNA==
X-Gm-Message-State: AFuF++nF7DdFsVxp/uAaMW/jfARNBE8l+HpD7yB7KUKmayi9OPmT8PiV
	vYY1BDcv8BVsOKPUffh7EnQWENxwGHYFRvllMyuOcuLGTilgYrzJYEoHu7kPb0rKa/U=
X-Gm-Gg: AYBFou1+A4ZYiqFcnx0gUqMpVmw1SPx8E3/4l0wkHUT8Z7MtDYFIFN0RUqOK5P2ltHA
	lNKMmLCWl2WwGEBIqied8kRs5XC2cqBmy+Dv+CHfq3EE+dPuOiAdEb1zAzopOubBoxjIJWU/ORa
	UW7R/tMtTZdRvo6DNpZadqH+I1WiNjizDBkA50uzo88Q7JjuIWisq6JGI9P9BYyN1OTEjAseMNI
	hcW906DiPtz5mwORKKl/mYIzw99mMURzMY6q7F8Mqy5eLliwh6ODM3MAVJbjE+gzOGgg1c3TdxM
	XkWbgTotDfL0/KRYATtqTYg/3z2ASQhBOuEupX8S9zAzJuXPM9x2LGhD6F4ZRLlQMIAqa+8u1Za
	M0b2kNgcV4muTlBIMvumEbWT3xaXMRysE1ZdKceydgdLLaO7xW+7gr5ObyhTk4Go+e1onA7IU0F
	GLgTu9D8orch5a2wbdYfAaKw71PYTOtAQuMLE0ay5C5BE3sRDuX5/692rFKIYuTX6eWPUxYooRb
	NWIbkB6I0XiPZiMvvcOsd3Ljfh7i6/2kWbQKFfHZr5c9p6kkEfrWdU=
X-Received: by 2002:a05:622a:5918:b0:531:2087:63a7 with SMTP id d75a77b69052e-532b73277d4mr83973791cf.19.1789961609053;
        Sun, 20 Sep 2026 20:33:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260aa1db7sm57867246d6.44.2026.09.20.20.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 20:33:28 -0700 (PDT)
Date: Sun, 20 Sep 2026 23:33:26 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <arCkv_0nk-BtW_DW@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <DLKNKTQHSA6H.6XC9WV37LSVR@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLKNKTQHSA6H.6XC9WV37LSVR@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF94F40004
X-Stat-Signature: wdasfrpaupsqw6x3tiqst9ye8ke54xf5
X-Rspam-User: 
X-HE-Tag: 1789961609-81836
X-HE-Meta: U2FsdGVkX19dWETjXKRDE3cwdLCRRQ6vHKtQmal+50tbbRSG7LBb4FUYyE6IG8JxuPhcqyhHM1SP0Cq5p6IUpeQzwHWpxOfGFyIZkfkFa9kH+SKVJ73ooU0eFX2BjywoVieMiVLye2I0V/Tzx85q+iLn4RApZsIIlE7ebnGb5fyesHy4CLfOZrEN/KJ3zjb+Gz1EUrBCD8UQza8R+FQgZUJC3ZA/AwG1HLdLPA1+Y5zhod91fVqOgjUsDwxVO9sHgUWrjGwB+womMEoXZ4x31RNQ9mruxWTcZCbUN7cvCJLO6PnbUfEbGmLfIq+LD3NjWNaHqL3eLgSmxYcac/kbtHgzLCX0+5mRMIEJ6LQTklKb3OeTvj5xeC9gl4FSJoZh3ONqhhJb+NcA7lKiDvZ7xLyfpVih+y39Etx1zgxE2G+w4q7CrCjt7vT7wQFBJ4HGDLUtBNpb9eEdMLQyTD4oV3qlUH8Mh6bPdgG4DULBnle1uDX+O2P+1cncnE5Z1szAYf+Uyb+1K5uTG2aYqIfoEabiB3WvNST4CmCOcMZ1ZhfpHmAh/7jEJELLgBR13KFdvBBqoqC9cuPuRcpI1CyX56qAyvobFLhOxjmXkGiCNpuL8Ja8/UkfZtmP5fI9YMqL+ja/6xlLGCwpDitAYr4dZ0rqMim0W0lej6vlCzJFysNGssRDOCGi3BUNo6KttMD9DFgkPUpPsijgtpobwC0t7o+Al85VTMG9+ErqgG4OJrf2hjbAO90k4eCVtOkODwobtK5Q2ZwJIXLRn08QHFnaxqkUrhzEWuwTFWp+RwXm4qKH9G0blQ2ozVEqHueWMeYtENG08Rxe+z64KunLyY0DYaDczxkzAJeGzspKOmLz/Ch15KZmXOCZz/X82ST+1MUMjGXYUwW7Q/9t7hHADnsLCdl6Jj2cEnrN33dLPvV3JD42c9XtM24Mg/Pp526o6WFi5HVl4gxzXWyObS0WD2m
 wSvr/1Xc
 T33YaauedYxeM5WdXZrLR6TTizHFd5IrvwMcefP66PPzi6iN015EOAk3kq8x5zSkr2dGB0kgmslyX32fYVbzA9/dY+alTTTqPjoqp3sRopJeLjAu73o/mUiFVOh1KYtTfpni/VC1QQvluN3sFE0gMZnHKKhMdrNyzA28LKs37i4JACkOYBQ0DpWyBIsd8JiV4eF0CvfKT3o5X080d6SMKHsuVJ/4MVFii2D1gwDpt6ho45elnuhzdCXSKWRl77nYYMGCFdNqGqBnbvY7Xsnl+MuvY6hPrrgf9uY+jSZ+qZqJz/uERHnRTv06dySHsRC3zJKbt7dMMYUYb1R8nFVIisVvHFWMzYeUZokD43okdGJolpgWBoGNiiowABhiPXZlao9rQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 10:53:13PM -0400, Zi Yan wrote:
> >> +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
> >> +				int zlidx)
> 
> Is build_numa_aware_zonelist() a better name? Since the old comment said
> "NUMA-aware ording of nodes" and the code uses find_next_best_node_in().
> 

I think that's a vestige of older version having different ordering
options.  Now the zonelists are always numa aware (except for
!CONFIG_NUMA, which... duh). 

Anyway numa-aware is implied by "node" in the name.

But I don't have strong feelings about the name either way.

~Gregory

