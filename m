Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8CCCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C7B6B0431; Mon,  1 Jun 2026 11:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCC16B0433; Mon,  1 Jun 2026 11:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC1E6B0434; Mon,  1 Jun 2026 11:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA166B0431
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:45:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC6F6A0679
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:45:24 +0000 (UTC)
X-FDA: 84831768168.28.7E9451C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id A18C5160014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:45:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JnxPHiVt;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKVQKNSlYO/K/Un0+OKzuQETHxd1QZOoXKAmOpkH6uo=;
	b=JyrSKOYwbg7ZoAl00gwS9b3sZdr4EIu0ZQoyD8RAJGFak26L1HaQk+xxr+fllsZLIbsKYv
	WjFStUTnYKR6m4dF6tK4iQZhRQNSWVgVCjttkTG7ROGuwqJyhKgUWZom2YxBDBx3PMCmnc
	5xaRP63EWBR1viuzfPT/Em8sA7uIwEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328722;
	b=KKTUjCQL1inU96VU7H8lw7qZrWIuQ2Bp8MyCcZwnvANdXoNglNCXH9TKbFy4ibm7u9yVWS
	/5qfaDbpuu88A0QzwKeVmrdKa4QOPrmkK4lYL76XF1VWi+VZTudYN/1vM+GygdkYZO7r8r
	MZaIArRhbIySV7Z+bdpA1UReVM9+aLU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JnxPHiVt;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49041fb8c23so78659325e9.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780328721; x=1780933521; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKVQKNSlYO/K/Un0+OKzuQETHxd1QZOoXKAmOpkH6uo=;
        b=JnxPHiVtSP6aC9KXyptY4oMRED3U3aDsVxNfYZC9CFS/XhYzuNtPdv13WjRiNC/bBC
         xtO2PeBPJNgcxW2A9liLP10EUk/9bu9VyxRvPbMZT6joR+LlKnWDwBxk+A8yVx8GilZm
         HboceCK4omNdHwPeBgKnZDmZK5voLHyWF6r7Ur9j/fOyLmJiOTb9qTpfNHu3UVAp6FHw
         oZ/q2g6tfqSqbr7GBXcPb+mVht2Z4Ul+o7r4Vefk6naV+XQz76EboYGOiNgu4WnXAhWb
         7vZNJi7GC2W2WB+/k4+YJY1bXBtN37SOOdqJ57odRln7KbOp8xKkBLl8DnMYs8sTK1KI
         4r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780328721; x=1780933521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LKVQKNSlYO/K/Un0+OKzuQETHxd1QZOoXKAmOpkH6uo=;
        b=Ja8GKcMOxlgGX/C4q4ufiHOli32ksl4ptnJhudFmytLQ93JuPsNNqvaLpmL/zLV0Kh
         eqgP9AvmDnOhvhpAc/ze8jPIjy37Amv23CTMtaVcqbfTKDKvB6COYVSukbT8btYSUP14
         /gR9FWK70jszNUJzbumGxLtFvVOuQz9vQs99JVIUlFAeGqVLH0qcrk33ixLnC7P4UACw
         mius/uzKGM56luWYVrBZM3L8sVJ3SlpQeZNX3X7fpCDtZG896ggpXx7HLu167sunZIpY
         IRwNt8YBb929IZfHchwosAG9zRtk/CNmfgBcnTFG6A71Fo6CAM7iptczh/uk53FTig0L
         sXwQ==
X-Forwarded-Encrypted: i=1; AFNElJ+t5muSpmHwd2hSvOpvVyqigk9m2AreZRkRsWHge22P3XfCHcfi3zDSNvlU09skfePYRcmdsTAU5A==@kvack.org
X-Gm-Message-State: AOJu0Yxx0LIiLNmnVhEgfWapy4flUAfLP+R/8Yo6CU9JCrtkL+qNygi5
	lP14/uWI8q5DAG6ePwmtNUJfh6+admMqh2a2Izgj+ylW9FRJH7v43bO5mHXSzIDQ38k=
X-Gm-Gg: Acq92OFsooqJ/8kbmY+BJPmOkQPRhbYROSnV4ja4Ihd5KxZi13ofHocb3m+dkpoEF+9
	oJgUAr0jzRH5YIlZnIl4fhEt2A31PUz4tvBhBUjaQ98AZbQ9u6akdiv12SfeUUVL5JiC7cT1pSz
	zj9yxdjnteeDeHpWTlS3mwgMPBkGDbvyCvxwcFFD6BPgYychzd0LrEd1jUbnF/p0s7IeD/f5ihS
	pGkr6xaGcYwfEGd/7lu/aRFxeIsn3HYRtl+NFwvIAcgW6h7MWdZOwasUPOZV7DgFAqYuEEqYKga
	OYNA+PuretaQrE4k10yxkgqVAr3gBIyVFonTZaaxQrvWdfEaFtiCqOs3ZCmzmaf17jL5E5lMbuI
	Md5HxAkMR0YRhnzKWRr84FvtoqlH3OIMMTDDnrzh6H0V3FpprTPJzM5YlJbKNWrjCL89hJf8Jrs
	jbIVEL1gCXx6OkQKsMt3QzY+Y5XvjDmNHlxNx9WV2yBygJX4c=
X-Received: by 2002:a05:600d:844f:20b0:490:4973:91a0 with SMTP id 5b1f17b1804b1-490a292191fmr157681595e9.10.1780328721126;
        Mon, 01 Jun 2026 08:45:21 -0700 (PDT)
Received: from localhost (109-81-85-133.rct.o2.cz. [109.81.85.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e0de7bsm1097895e9.3.2026.06.01.08.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 08:45:20 -0700 (PDT)
Date: Mon, 1 Jun 2026 17:45:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	akpm@linux-foundation.org, tj@kernel.org, cl@gentwo.org,
	vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ah2pD468y1LCIe3G@tiehlicka>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
 <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev>
X-Rspamd-Queue-Id: A18C5160014
X-Rspam-User: 
X-Stat-Signature: 5oi9fmeyh5b57hbyf8n394btoy9iaryk
X-Rspamd-Server: rspam08
X-HE-Tag: 1780328722-175464
X-HE-Meta: U2FsdGVkX180QbsvAGr5qf7rOYXj+RvYgSeDDGZwJB8xIdV+fcDRlgOoW2R8cVBWZjJOK31UKKpK5jVMQvGFShAumygdeB5mWBy4qpRDyLRxQdnOjVciwsrFRQQ1ti/iEw4/F4kDJqrTyWt2aeZq8TqPeVSGz6EOi6VCXZUHdqIMA7zbu0VzVpo5W5y9Eih6zPKuuTsMO4t/gbHxSTyKpQuJy2Cs9qS82fyLslHQRaAPQt00ptjJ9DHStg/WdXtA/b60MAYWpZxj/+77Kg0pGIXb1LoOGYoTNESD1X9Z38LSkwLOeeiz9r5cEyMCqKqFQo1xBUC3ckkBOQaxmHkfJBit8FfpNFLekXKEKSOqB2iCXEu9czYrncMxZ++zAzXkE/NR1gvZMmxUe0Vxwo+zIPpN4w/FfGAqlCj708sywNQYRgqieAzJ2fJ1Y+DH03frVm2F44MUuLp4zqJHH4plv8CnCzziUUMuqxN20tTBK2A9zcERIIEx1+2vV9EuzG54vuVkdngkMXI54cFoVFnApySxMc+Zb3PeyDEuG1STfdPQ/rh0nhRvrEcl1GUXNBEFiLXCygERjo7hcJCiJx8tEZbxErDe3NbOw6jX1GOsOAyzQfJoio5UxS949Odq33amhcHf20514mlMALPc69uM3XCuetOfW55ejrk/M42FSfHxozovXaeBABelNCITyvP+/jVrRTvGC75iwLojIu5Ukp2ugGfi1kbMmuu7CcSQRVjIanDgddnm4+3xftAfHYmPK6gEalLkWPD7/6lZ/DZRCky9Z0grDJdZS9mwl1bjXOBtylaGfL2Zg88E4Rehj67c0bsgTrgbW/eU4XScAtXTWBEsQoud9oeU9hrGauxKSU0I9OrB4oKM5UHyy/Pf0AwiK4NMdOTF8eP6dsbJPgaOn154CiDAFLw9tXPjVoviN7WU6aj8JmLZxVhJtUpxSStfrnD1xiRblyohDxoi7cm
 iciSA5Av
 rFJKGsE8BlIzcOSfBASQnMiTPm8xeux7f2yIIatOiyPYct0mP/mcsNKdy7Brd+Pa46QyXJagnVO7hPhA8TU2Cxa7f1hBdToJmaBYXUudEPUNfOv37jFVhfWeswl3Mez4niEdc1vipsLG5/zQ/9egQTvxWAYeehTHqQpxgF5LBobapuXgdebFyHg2W/mBToj8Fe8VEoBrpMwA891kkxrYW+8VJwWlY05oSHnKzZ1wOhaiwxTWsxHU2T/6oe07t3XsbhwtmxgdvX/OTSaaWkL8YHYwFdWuLyTkHD7mPLR0/knwMaECPC13vsXzL8aTQL6PvupXCx0gKLhWKZY4nCdK3Z+yrb+GFd9GAg8CWOjtZg8v8YO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
> However, if we revert 9a5b183941b, it seems that all of these issues would
> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
> allocations may increase, which might be acceptable.

That has practical impact on some versions of iscsid which do not have
PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
based on a theoretical concerns which I believe is the case here. 

-- 
Michal Hocko
SUSE Labs

