Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A94C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689A46B009E; Sat, 26 Sep 2026 06:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638D56B009F; Sat, 26 Sep 2026 06:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54ED36B00A0; Sat, 26 Sep 2026 06:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0106B009E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:43:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB1A6A08A0
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:43:43 +0000 (UTC)
X-FDA: 85255577526.03.D75E615
Received: from mail-qv2-f42.google.com (mail-qv2-f42.google.com [74.125.230.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0E0DC0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:43:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R2+2KMsI;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z53uSMUq2W80HZiwGXPg4CfzzfvAXSACVLwfmhiGvRc=;
	b=M7C2zaK0X4wFu7pQ83CVqfQEi0TnXxk8eNJMrO+4WSB6n81VT07lfbaovCbxvxUk+/ErIB
	rWkG8rbtj7tnDjUdq8C79BKTboc1hjYlocUiME1GUcGT/qP/16Ebkf1e7M7Ks6xonnW5SU
	zXom2KsJNPnC7UCdRqMr5G1txuX71VQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R2+2KMsI;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419422;
	b=0ECmcBIekRpt8SVBTJyWJtvbc0TOd1KsNx4x71ChhqvRNj8afvTu4fims6vyyAt32sdB4i
	OaxtTJbYkMADhCj0D6vY+EKnolULpYgG8RAiJEDft/GpCCDOff5PWUeZ9NWbZGjeh6OWkY
	rhpF18+XZ2k9kLW3iZv+/k3/Ull4J80=
Received: by mail-qv2-f42.google.com with SMTP id 6a1803df08f44-91447a0d24bso1487916d6.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790419421; x=1791024221; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z53uSMUq2W80HZiwGXPg4CfzzfvAXSACVLwfmhiGvRc=;
        b=R2+2KMsIf9fJZ+Uh2rrCCtfoMkneEAGoTnPw4O1o91grVkoHJs2GEX4TrEcLTvDUyu
         ElmUz0dcfUeOkisrgTfiUXXqXKadqAz82AeNCdhKwrrjCRrwyGnzTZLHIndWn8o3mud9
         Qs15pp6D4/rlriUhIDmtE8qJ8QBIpw5K8c2r3DeLZ2wMTfSY7MhnEa6ggw5fwI3rqSUG
         1zqAHXJ5V8pxqBQVw9SPxHirI18JxEMdJ3RGBSQuDaKFkWHZ/+bxZgfy1b+VK7dnp00w
         0XJKZt7Kml7OoBOeBamYFOKZ0QWsnbIR0pssUViHyZ8HRKbJv6Y14lcYR46TMV9bH+lz
         WGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790419421; x=1791024221;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z53uSMUq2W80HZiwGXPg4CfzzfvAXSACVLwfmhiGvRc=;
        b=UD7URtQHSUaykzlNpzXf9/aMlzKdE/z08+ylqwLYTHgroVTdgZoAN4BV1+eqg9Vs9K
         wyHYt+7nCi8VyHEl4rnck8coBCtyUYBZtSla32QYEEGxNbqyA7hseWbORVT0lOmSloOz
         ieut/JMaJog/ee7JNTzehxTtKXTrcxk8fOBVHsmMZcK0HdEsRP+7Hi3yj/LFiY693Fly
         9L9yBC8OdnckfsP6yedlz7sHL3JVuBYLNC6sL+owJwc9Vx0yWPoMu+swS0N16WfnsRMp
         oa/sx30iMP0Iyj/ST7VQbXTkEpI3a2eNI/Z9pNcxMngdef2HWTUrAMgCeuk2dVVlM7t5
         CrzA==
X-Gm-Message-State: AFq9FYLkv0PKpK7T8XsaXgzkNc9bthW3XV0h9V1M1wsvLbRrPmQ1KBWu
	mI//98ogjU7LE5GcGmfnmTnCN35b7QNy4SgT6NGCQQKHmWi2X6N/VKW0oJKRjql/biA=
X-Gm-Gg: AYBFou2OCIvPNbIll5QY4A7Tv+iOxO2WZFk2xsHiKD2bySJTHx5yqSkWg8JEj77kWqn
	U3gDbszb3an0/rSdj94cnI4nPyy7w8P513MJRCv2mzaN5Fc/HQz8untJtnVrRIHTKvjAN852Jrl
	FfVUSxAGKkfTjFW7p7dpE8CAj03FwTaXTg4MTmHFZziaSM6tfXfo2MRQ8NU4HOkpoFK5lysZaNW
	xOPTjr0xUrJMlDRlnv8savhfHktNm+ziMavlQPhOOGoGx1TzLrrMP3yFWhxdHG4W/GRvxyS7qIX
	BE4N7IBuxUYL/GTM6PnK5oVfSoRjUTTbWKXg5cgSvpbqX5VITANtBbEfW8yYOz3kkNgJEP+eeC7
	OWZRjsWZdx+vRwGMEdo9L0T+fevEQGAaScX4S9NQ8uI31q9qvXKyqId+ua3STSAF0OnW24kf74/
	3+xftuCOSaDhUhKNpjnNfj0GydPt5/GSiybPE/UNVaM91I0nMcQU4ye9FncxJFKTjxhbh+XtGKn
	fUmGhcrXRHTRN3wDezZN5DDQ9JhKmNMA+Ncu0iWwwQ9SVmqGgF9q8o=
X-Received: by 2002:a05:6214:3b82:b0:914:48c8:6961 with SMTP id 6a1803df08f44-91448c86fb2mr22359076d6.17.1790419421191;
        Sat, 26 Sep 2026 03:43:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430e6ccfcsm36688496d6.40.2026.09.26.03.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 03:43:40 -0700 (PDT)
Date: Sat, 26 Sep 2026 06:43:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/mempolicy: use vm_normal_folio_pmd() in
 queue_folios_pmd()
Message-ID: <arehr1Z86Vp4gFPa@gourry-fedora-PF4VCD3F>
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260912034833.2952750-2-gourry@gourry.net>
 <aqpyp7ouLyxGhJDK@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqpyp7ouLyxGhJDK@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0E0DC0002
X-Stat-Signature: qpuu9i74m6fq4qbm4u1eziixosbwa5j4
X-HE-Tag: 1790419421-540634
X-HE-Meta: U2FsdGVkX1+NHLY6ZbYSSQII5M/MOX28rRSK8mtVr+bRROU1Ilj0Jp7DzTCGe4AagSLCRPEkTcPDGXS7IEsixd0ZVGZKuzshUdbSi3qe9pPnGAsleN2FGZ+RQnZLqhaH1vPoViAVxn2ROlGidOzh6P3lni3UVE7HzgMA/FzcSWNdk+hCzy/iyhCsss6qCZ/iCPRNB3Vjuwk1eA8JVxJh19yBP5LqOEhYgkAqxkvXowhjdUE+jxQ0Esj3tqiMNZsj4TFJ0+Wz8eXprR/k5eid2Ib7eSNRpo27s2rW1ZT7+c0z3TarnwfyjOCGcz9oWd5VQUBWDz2QqM+5LIyX6UYa2+fEg7Qmb01aUV49NsUuPE1Kc4p1O75rQL7EXt1AzwrJpU0jfG0wfhQDIGo91oduEWEbjRv3pmlZl2VE1lrfvAyHNEcVkLBRmb4kpRWv7x04FxG+G2k3VH4R0aYb29jvO8vqqaPitolI8Vni4mLzazhlChJ8Yn7eBKWbDXmLzHITckTmUbPDnsMSHydiNpUqn5tZbbW4EZc7e1i2/BppPXG/4B8CFgZM31xtEog+WEgNOwfMFVbrt1h+UnZdkKUtT73QeXAVFbL5ri83xg3ykZf9HflLr863zUNusyu0WsB4B5NVqK3HhMbZ77qsA2YeCuPsO/PRs1T3Eug4udEn1RcODe40LFHY3ZjKGjZkJYxfi/4b7jdMYV9xPpDgq3BBbKKxx9+bIWISTNk/MEgg31CKkifmBs4MXTFv7i2wh7KJCIx7CkMejOPUM1udUfUTtCJ3AWj+dfHWSCuWAvL8pZkjOvwfAeIELr8imCcFlna1jz4M6qZaS5XRo7K0LB+QvZU7nJvW0BBCGIEwYAg8mS3BMhh+WFRs/wQUwZ+0fmu/q4vE4odbRaz0xjTRTCWoBLbUVo5oEXGLcHjxokfbGqzzL9TEkc/qlyNiWu37KIbHSM2YCVEukHUOYdVveYJ
 d1IDWibn
 vo1abXuTgeZLvcKNIr08PYA/lE9VTzxTnk0KmaUPsSsgiGUDFlWs7GapsaTWcLIMOxEZ5Yx+3hUW6GzfJhxxrReC29gDqQ18BSOpu0FR61VGQJYd0a/yTg0yQpne99EIoiNawyls/O987tAbSA+RuWLu110PEtab2U9VOFeaTLrk8lf269a5RxoaLjDE2VK6hfxIhzmCHp+eQ1eP7rd2nDMHZW3OSUhw3AzHmHRxUbz8U4MIo31IQ6HBIcPQ26lmhzerTw5lhR/AOHdvYq+YT3IrqZ555q6XIKQ0CwbkvBxvKSV6F6Kqy3AeOiBuF5JdnDega6HSDGQQcpd63IyDoSrfikwThVxJvfnhsxj5aPrjqc8kXoCzVY2leAg0DfVoyJpMrjhNvz7ZPoUyeE6GycHaH3rRZEjwbmECNWvQgrck7E1BIYBzMv5WK1TCJ96dcI4Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:53:58AM +0100, Lorenzo Stoakes (ARM) wrote:
> It seems that setting ACTION_CONTINUE or not makes no difference.
> 
> This is really just a long way of saying maybe you could just do:
> 
> 	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
> 	if (!folio)
> 		return;
> 
> ? :)
> 

You are correct, I will spin a quick v3

although this will hurt to rebase the rewrite series on.

~Gregory

