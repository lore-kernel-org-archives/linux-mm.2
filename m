Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B0EC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0106B008C; Fri,  4 Sep 2026 11:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6616F6B0092; Fri,  4 Sep 2026 11:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550C76B0095; Fri,  4 Sep 2026 11:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB9D6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:50:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9755B8012C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:50:57 +0000 (UTC)
X-FDA: 85176518154.09.A3DBA05
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8245180010
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:50:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s75Z8nFp;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788537055;
	b=DjISpl9flC7dx5QY6+1qay1+e0XSefKT9HgdDV4Bdob3E7z2elm0H/HfGKSi0ATseAPnxR
	Mgwk53vqWCJwAlfiQaBuQizkC6XI3dJedCIQNWKApjwSbafsQXgnH5wvcFxNwcuvo9uFwH
	YnwiEPvcGeT1rVTfrpzxP68hbQPGru0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788537055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CPM3PhCyVUbcThvlnBvxoK/N41olTITEO0G3pjffxQ=;
	b=YUPLqnYEq6iOGb71c1qHFbkHQnSQATia1cHEcqJNuBKMDKKRvMpYLaV1mxHFEOE7gU+iYQ
	yym0RnWSs2DTJdfzQGWXtcsAARtNGSEnJJMf+O1gYUrqiGKZCtirA2rG7pW4TUB2zMzb0C
	ZNLGDmTKUbgLaxrgS0jLmgM4SuDr7IQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s75Z8nFp;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92edb12cdf2so82650685a.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788537055; x=1789141855; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+CPM3PhCyVUbcThvlnBvxoK/N41olTITEO0G3pjffxQ=;
        b=s75Z8nFp+tEoWIs7KM7WT4lQrCzTYSz+bZWQeVBwIjqmVKuCmA9M5Jd6H5/3sQbQw5
         UfInyfwBaRlleimE5SFai9UAaKrBSccMWC0ssBDH5r+mAeUDKj4uXODQkmKbdHVcAjAr
         hk485mu8wjsfq6kr4QdemAC2cSqrtHlF8h7vvtxUUypSxHj+mrpGZiZ0BIi1TMMlvs5k
         m2Mbnp+bg0Y1i7hKbqe3/vo9PPmACHyALb2C50bhcrnjwgg7+qjVqeubKXNtEC3ZxsAh
         hUoucza7UbNG4TyskfpkamGYBIkLJHyQZ8STgxmBo2KQ9zww9ogEuGIVg/Olj1/7llRw
         IMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788537055; x=1789141855;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+CPM3PhCyVUbcThvlnBvxoK/N41olTITEO0G3pjffxQ=;
        b=srS/fTWRg0OukPiDVCsjkJ9eejAk4GrCmIAKw7uZa08v50gr1bA8QbGr4ZQEq81Y4e
         I9wC1An4l/62e/0BWBMB2qv5zNJNlm0IUCVLT1VhYqg42y69LXyPJgxMLu/esHB3+WvG
         BS2o17FiyoRrILZ53RMxJb6K63LCwj9dHn9SIr2rkJA/6VtJr8kbSmCOAgr5qEBXnzGN
         wvyE20ut0+KvVxaC5gR2t5BH3DWEunaK7HvOztGO/o1Nmwma+hd+1dyOGfvMDroFrlPm
         3on4YDojooCWpNRg65feN/ou6mI0A4GnryZJ82PQwb92RUbgHZxd9vyUEjP3o8KUtVSK
         Y+wQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4kzRyqbXmPp5xA3Ek6Czq99lKhyukp+CF9m4FrH1fiPVntZh//BkiEtbGq5VNXePi71UL6s1VNA==@kvack.org
X-Gm-Message-State: AFuF++kSsQTOOXV3+stv1KNSXFq6SK8ZkIUIbqcMvlgfQ4/AX5QUVz2k
	8SNvftlFj1wLLBozlUVTPyaRaF48rI70INs9CdlKE7fki/XXFtXDBBhgmUkpJI5Lxnc=
X-Gm-Gg: AYBFou3ZXeYYRF7xdGGDL0BDHFeVRI9oLUs9EQOozBGrIGEsyS54vFQ+sL02IASHUoJ
	yJ/CeGaF3thZM+YxKMC5zx1uYjeF1eNPsynfEcg1Mu9XYzUJstv1TCJ5SIKVihKSuWKMa3ux2Ud
	Y6TOoC/mMuArdepMS0q6xcFSrPKR78JiEE9hOZr9IbcoCFnWGJFx7+LQX9CV2t7CagWARklm0S6
	+PYB01P7sNbRsfrkzQRlx91GLSxe0cVV9TduXfG+XtGBRix+rCR6YGeYxkghVPwA+g4sxioyjTE
	xs9dAl4WC4VSBcT/qkMyO5ycsWNvq7aTYxXjRE6ZFPD56X4VTyLd06BLK9iFodFjD5Sc9vaBmML
	hCtVNUxkzJjyFLqI3zxuzZEJID1G5iGtnUQHEqJJ+HQ2W3w34mtPSUcFUXlambaUaaQ1rbdb1Ur
	1ICa5ZViyyYtIb99efqPkOAYhjTkMVMlrnCN/OglbZ3dPJPmYoXaW4NKqQFz/Q09VjXqsyH43Cq
	d3U3hI7qL0L2oQxkxFtY8EhKDLenP+Sr4dUkDojfJPg
X-Received: by 2002:a05:620a:aa1b:b0:937:675e:2903 with SMTP id af79cd13be357-939804018c5mr653972485a.14.1788537049980;
        Fri, 04 Sep 2026 08:50:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397f9f0734sm245958785a.4.2026.09.04.08.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:50:49 -0700 (PDT)
Date: Fri, 4 Sep 2026 11:50:47 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, urezki@gmail.com, chenwandun@huawei.com, linux-mm@kvack.org, 
	kernel_team@skhynix.com
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
Message-ID: <aprm5dwF_kWaOe44@gourry-fedora-PF4VCD3F>
References: <apgzMZQPTxS9QtDy@gourry-fedora-PF4VCD3F>
 <20260904080140.1992-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904080140.1992-1-rakie.kim@sk.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8245180010
X-Stat-Signature: mxh1rcod1ncafrhe4cag56w4dt9asiwb
X-HE-Tag: 1788537055-231110
X-HE-Meta: U2FsdGVkX1+IJbNq0NFpoz5Cr8rdkACUEVeBSlH5HthnaFOJz8Kw8ct4QXPQ98OdUJUFz615Gr/ZzvEXvGvwlbM+rIpTZUrz8AricN2u9XsdHpOeCEfXP8fL4TtMOrTOJSeSPUlshpC61PfMjOdMHvvx82JAuh8fyLmb0TgdQ6R5opBV+NNdkvMvToClhn5pymlG2yAMzkDlimrlsrYIyadgi7GZJ5540AZ99HrR2+rLBKtLR8j39mFUBeowGDcMFWW2KoJFCaD4bcND/Dtx5Saoob2tacQlE4bxwvazKUpLpWiR6CkdNIEfoT65KmlfwNLTBPeM0o5X4oI2+9jQ0M0lAbHnmk8ipSvsNtaQMO0mId1+UQP+eGhaFhgqgyjy7ukqEhDtINB+HZCRxlp+Jlp/pmn9J9Cu7VOMkk9puE9Cy3Ak5i61QqE+WD8apGk3/LP8LqF0oPV31b6Y1B+lAAwc7aWX73RaAPB7Ti2DEgeRjtke/apVjwHeeB2Jbr9mBNEiDmyiBOoDt9Gr5mOnM+lAknenq34ztCalRCYcS+BaJiwtGIvTpG0KkvjDHl5syEn7aFd/+duebFZl/bYM8ntZGcyQ5dbSCnH/3AWsh1R1k4PXTvbthAcv+Ydx+6Fh6EegUKRUlMzVgevuzXn82wdhRlDYf1ziZu1UA9zUydRBgvwO+/mtONHZ0bajQB1u5Z3qbUYWHfI7uxnoPFr4/xD1uTG+qq/qUlL3loUuaPoYhzVwgwUd8A7pImdEnC88zpdG7waWBcfdQVnahJhfU2u8IDsFFTgiCy5ein4rzgsiv3xjy7kCbcDbgU2ZkwmKr9+TocPDvf3mKl+PlqqCnN9ckV/rD/9USAqljr44O56EdhzMcLhTEN5WbXhN21RO7ys5ngKwf3to3gaJWLCEz0z200V09yaKch9h5KqD/piyeaVBDAQmeKg6ZgkzvOBJFzKsJ07GIQa0u7UEu3y
 fYtUqDkL
 QWZ6P8SvcUkZa/fRbDsdluHcNchDKZ1as+2TAL2RjnlN2mzXJXqLOMKEcFuzup0RXxmYOxAe9c9dE+72DmZhXXR0OrilidTCFpHO06sGMm9l4SLe4bGNQ2k9MPUcC4Vrh+4bqoseQ/128fj9dYjda5i2n2uFmO2lCPEyJogy8r3xAU/JPnRYndPkSVc8m7uWYFGp+x3Rpr2ZAg/3guwwbiPWs6sO2yi3JjiKlrFG/KZLhL+AP4kFvUncB/wjhNFEVIBp/8uOsTjgqwbVxtTBAMMflL7FxvjoWQ3TAiJ82yD38hVbc51rqjQRY/Fg4IEeRntWoSpVKFb8puiovcqfnR3UbLshyx2ZKm0KJaIXAX7NAssTtAyBvx3dFtMGxA1WEAyWzHrlUib8tdWjzbhKXUBqtlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 05:01:37PM +0900, Rakie Kim wrote:
> 
> What I had in mind is the gap between the two reads. Say the policy
> starts with two nodes, every weight is 10, and 100 pages are
> requested:
> 
> 	/* the mask is {0,1} here */
> 	do {
> 		cpuset_mems_cookie = read_mems_allowed_begin();
> 		nnodes = nodes_weight(pol->nodes);	/* nnodes = 2 */
> 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> 
> 	/* a rebind grows the mask to {0,1,2,3} at this point */
> 
> 	/* calculate total, detect system default usage */
> 	for_each_node_mask(node, pol->nodes)
> 		weight_total += ...;			/* 10 * 4 = 40 */
> 
> 	rounds = rem_pages / weight_total;		/* 100 / 40 = 2 */
> 
> 	for (i = 0; i < nnodes; i++)			/* bounded by 2 */
> 		...
>

Consider:

	/* nodemask: {0,1} */
 	for_each_node_mask(node, pol->nodes) {
 		weight_total += ...;
		nnodes++;
	}
 
 	/* a rebind grows the mask to {2,3,4,5} */
 
 	rounds = rem_pages / weight_total;		/* 100 / 10 = 10 */
 	for (i = 0; i < nnodes; i++)			/* bounded by 2 */
 		...

in this scenario every value is wrong.  The weight total was calculated
based on {0,1} and the loop will use {2,3} weights and ignore {4,5}
entirely.

It's the nature of the mechanism and race - best we can do is ensure
safety.  Ensuring correct distributions would likely require locks or
reworking the entire weight mechanism.

I'd rather keep the change simple (cookie the value that can cause a
div/0) and leave the math alone.

~Gregory

