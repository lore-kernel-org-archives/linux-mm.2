Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB1F606A320
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cHe+OruU
Received: by kanga.kvack.org (Postfix)
	id ECD606B05BB; Sun, 22 Nov 2026 22:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5C06B05BC; Sun, 22 Nov 2026 22:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF4B6B05BD; Sun, 22 Nov 2026 22:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9A636B05BB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:14:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DFD81C4194
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:14:50 +0000 (UTC)
X-FDA: 85464916740.09.F48CDA2
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E260100005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:14:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cHe+OruU;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403688;
	b=mdTDhTmAYz6f+dRq9jGm6DzVXW0m/rNB0tkzTNcbrNNmaTKnqXYKd1kWEy0L6StUIuZCaz
	5Lm4CDIhvqjV0NVQdsgFOFaqFV2xAQ8mh7D1mvL3kE6O1MPHMnbc7ofEfTGisDxJKOM5bn
	TVclzKFRf5K9F/+hMlB7Ns7Zp5t5bjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmgsHFkL+h5rhuDAcwccXtAUWFqNQ8ooJCVW/O2Ov/8=;
	b=dUkbUIcyBOGvbbsty6XAn8AaC4DtLzTaugarVWtBAHUDORYbKTvrcQxqNqon45oCtFRfYO
	/CHL4NQo+p6sX8HPxaIkCvtNyPphFp48X+1HBKprOJ21oELq94zuoaZJbE5aM/BWOIxN3p
	MQ6PV2306e20SVGSDu/L4RzE0tYKyEw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cHe+OruU;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cde84cb8803so297924a12.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795403687; x=1796008487; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WmgsHFkL+h5rhuDAcwccXtAUWFqNQ8ooJCVW/O2Ov/8=;
        b=cHe+OruU+d2rtEijzqT/YV71kz2Icd1eDl7dzv1fS0dKbwwJa9tIdvnHVzh7PJelwL
         c0NEpp7+n3+E+H+9oMp3pzxrAeFrfEvkCNP4nIdz4r2x6hlDykfw9Hr04ToRGurGEEEz
         B4jvAldCjBFjJh3Qj6uFq5h5QPKthDFMGMdoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795403687; x=1796008487;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WmgsHFkL+h5rhuDAcwccXtAUWFqNQ8ooJCVW/O2Ov/8=;
        b=qXb0lZIcRBPvO4sqIyQi3XIRxooKVebvlQ6a9kSu88Cj+Y5JjrsdOsyo+evBgDIbLR
         RYzuSJti1TnXqcGvaK2j3qkZLdrq0Fg8KJjM3Aj2v7800k3zB7xO+mzFhe5cMSqVROr9
         WQ1V3qrPLbpnJh73PinLLfXeT66YWQ9kPjBZrsHSBFrH+klEyHoCP17Vq75Bi6nsveL9
         nCKPfXMgVUD6Dp56kM6pJ/yIlgx/JA5x/BYfePuWpBRJP1ej2MblshcjRBc3Sy7V8OA3
         ZxfwfBTQQevVtyBrzTPUwMPQRPN/aqoSyh8SMvMb004FR4EN1uElDA37J4rLE2dOaYtp
         biJQ==
X-Forwarded-Encrypted: i=1; AL+hErEBej4WHnyTZoQLOeN7vT+9Z59iAz7B0QzOnrqh3Wu/lev+AEyd+NNUskcgcRJpL72Zkupq95FZLw==@kvack.org
X-Gm-Message-State: APuU4Z9eaV4GvGdNQt4AjRW9wtCvg2sLybNFjlD3f+PHQreeTyO8HjZ1
	wQ7t0KvTtyXNbhYLp4DCOV3ixTJdGhGrpsZKkCnMRCdzf7hC2v6g9YA2HrIYwh6MMQ==
X-Gm-Gg: AZFdTZcPsKCDQdprsQQpE7fmizFa7HJ0wVAkSTj4f2WtfZK3WG9L3lfRqMJurHwGFod
	rFUigYVSXnwfJFDCxaTzH9YpXLG2MagPdwv60gNY0HwWQIhmebuB3wL3YQOcAHaNBgwdbEXzYgC
	fkT0KFJpsSdhAPiOJncL6sLaFYIr8bTwe7IVLFWOkU5IEEQjtk0VDCU1kMv0FBdM/4Y+80TWlJz
	cxOKijlMifSP4df+hX6+C6jbJLIY7FVyRHcJhalzP0bU/pfxvfuREJ5jZL8VW37+904RSEbtfgK
	yg+9QR9COd77nyOY6bJuTHDkQQat2RaeRGYMG7oUGY20fQcvyVcsDL1jWs1SZv4wcgN83kMcN9U
	yuexqhuIylKHEpfBc6JOOeToFbXnNLiAePrqxNkzzlt2gkdXrdAvioaNKmLALEVZUgD16ocaFAs
	zD4BdmOWAkBheJMie/75+1Oo1tmoeyu0MCh1INyRQEu6bJBjKKW3NsBdZGsDJaLkmgEzToTwO52
	mqet851l5koMLyMlxXVx8HS77G2ONxtJiFCi/WWS7LcRhKjnuVfYLoBn18NJAMD8pKX1YAlHtYL
	isuSJ9jZdZSeazRkngtmSgcRIab6eOmf0jXqpPQBFf8SvGdW/Jk0D78OdCEYCA1dYAPBXA==
X-Received: by 2002:a17:90a:e7d0:b0:3ac:929e:691 with SMTP id 98e67ed59e1d1-3b41c8d5a52mr9034938a91.17.1795403687341;
        Sun, 22 Nov 2026 19:14:47 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm16010576a91.1.2026.11.22.19.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:14:46 -0800 (PST)
Date: Mon, 23 Nov 2026 12:14:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] zsmalloc: free a zspage's pages in one batch
Message-ID: <awOvXnBW_QWGigkX@google.com>
References: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E260100005
X-Stat-Signature: hzbci6msefzzuqe6chs7r4qqz9kggnx7
X-Rspam-User:
X-HE-Tag: 1795403688-526829
X-HE-Meta: U2FsdGVkX18chGQL85fkdis4vE6ub/ZsVJyaUrXfTLmraTZs9rk7jGZwJqarNcQn3YHV2lc/AY16OQN2MjTUI1SqzaeipySQXyUPCiOFRh+l/wVqJDI0qj9LP7GCu3CY5LAZiTK9ZdwIcMlfayQIGjzgWrffglXT63SM1jV6nMP7IzpxgrGVlf60cgufSJfUpk4+BitthwZIqwURSAA8VeKbc5Vaxm01z+xWHSriBT6Uukd3SqZzznjBusY41194tmYY1HSRmG9mKpX9Kh1YW8TDbWXKJ4+aklyaK9k7wa87HKGun+C+XlIMch3Xj91MbOvDGJBRsbJnyyQx+Q8unFkvBQwzoOypj6B6qomFvR25m/sDNnV56w8OfBSqAj/oqPlmxM7DappAMTn+JOqfPzI2lKRSgcOWbhBreW2ZAqASjHofeMxkoK7qOMwqM3ZW4MunWMmnY3IGk2XmvdDxsAh50/WWY87w4liLmpHfOF1/tOSi+/9tZzVrv5+EEOLNiYL37x/91b4ikgwRalbfjyWwvF9mQeGNoatRTHbJRUPjQhxIau25HLiYHrjAitOavFg5gXBUoWsJYIY7KKgv5vkZMeP2ypBfyQAd+QZTYkz0vQlmenElfRANJcogwcy+st+GyhaaJBD/LC0OxgFjBcTgnB3hsj1yV1soTJSCdwte3XywV+/3Mwnqi/j/rHSkfI/uAkmCJDFhSNFqPSLPC6ZCL3xhHHFs8VzpBsE8heSr/E5kwLklL/f4xzxVGIoJ66nQ78kMrE+NHQ+TAcUEPR+uXnOklERNlA88b5bf3D8uL+eg/Oq+XeXTAunBCAUK/YHRZ+6cWBokWDbIQmFZOW+PhHL9INrEUSg98F3Fkh52UTJJqnjus+yRbfE9GoIPaMkbF+ClrV30UYN+z1M73pyjxsDsjFjGPVPTF5VrPjYPiC/9zfSG+rZ6zJhlA74EymST7ahvrAfnn/yVuWd
 Pwi+3hmf
 0NgJVLNYRDf+VEvefi8BNGY+D0VR+3xwp0dgwnggr2NCrbMsJVMAHrikT8aw1e2ybHoE2YyF/yRCXeDFUI44cDugLkITycDXfzpH1gylwOlz7LcedrNPsKr7bW4YyrepcztMutWwWl5pmadiUR0QpNg6ujOzmODO3mtPrq1wUIWY/yJOhZxJwS77oVM3LammWtm9qbJRx/xmhMIeu+mg4U8w5Bt8yGv8UzOfEgvg0NXvYi0Kak9dwBexoA1hQea0RH8Az2Gqk5aRTFosvl1N8fMOUWj0ieDITIJHFz6xJLJPtowQ2Q/OxW4RR6bXP8tRWCZcLC2iiIt+fltqlbFamiOU0azd6R/6iLNrC7U06sEsuFZlpUZGHwbJ7tlWk44B6R591r89mzKcBWSt7XGEyeYe6ZNJXudBkyShGc1HXiHz2rN+ZNeTX+MhjO43jX5FSUNJaA9X9dDg85cYyWjITQQdt45BpMdbUEZ/uIpwBG4FsDDwl7w2AWZnlUe4wLJx3aA0LUIoRJGQkLVF+pUGKsYo8RaIrZXZ9GUb1Wkhdm4JiYhXPndD/LWjggW71hwuwAC0bIN8/iFJEtDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/23 12:10), Sergey Senozhatsky wrote:
> [...]  The batch lives in its own noinline
> function, which also keeps.

Oh, the "which also keeps" part is a lefover from a previous version of the
patch.

