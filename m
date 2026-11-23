Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA8A606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TOqcWK3X
Received: by kanga.kvack.org (Postfix)
	id B16C06B05BA; Mon, 23 Nov 2026 00:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE74A6B05BB; Mon, 23 Nov 2026 00:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2456B05BD; Mon, 23 Nov 2026 00:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB806B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:55:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E70EF1607AD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:55:21 +0000 (UTC)
X-FDA: 85465321242.25.2656DEF
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id F15611C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:55:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=TOqcWK3X;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795413320;
	b=AyOqi77DxnIpDhWbMWqFUbCvDjl+XcFwHmc0vCHO3npXm7ebi4nKfoHPUqQQmdot1B0FCy
	Ed9bfhV/wP86KOFlOQ07nyij+gRaInl2xs0NX8TqWn7vLrJ0wolZSyeRz5DXjFNXWG1WaI
	7ZfAbwNTm9vAS/JYpWYWn/pIbfDZXiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795413320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75MwwDfJskbLcXnBINWfK7mei4WvO5E0Z8Rt9qBeNGU=;
	b=0lcapl/LexPXhlW1+VYo/O8oKf4clHdjG8J+LKnANio1SnwIrWbSkWqrSisym0tZtVZSvI
	PUgarpsAsyrsvr0jOLx2HkmDHUeKN0m/WuzzsljWt13cci+afE6B7sbZ9LehBdITmGgilm
	Uf13WDkhZd0FiJ3z2FeQom7cp7MDpuk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=TOqcWK3X;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-679aeeddc6bso2529246d50.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795413319; x=1796018119; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=75MwwDfJskbLcXnBINWfK7mei4WvO5E0Z8Rt9qBeNGU=;
        b=TOqcWK3XDHPZn8P82lzQvHQgdyjUTioN6L2GFWS5CFVjiPDa23S1Y/2rlPuNMT2Rqe
         F6w44hDKiwSZJ9eSoMVPBpY5a4a/y3SRBVPv4aHhwwc91ijA4CR+53uM7/0XVl2JVZmp
         TQiVMMgyiQRjvbur/g9XHnkSmSvFL3+EZmwHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795413319; x=1796018119;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75MwwDfJskbLcXnBINWfK7mei4WvO5E0Z8Rt9qBeNGU=;
        b=G9fMvUAG3w5Pb7RRRSA4HqOoBrkDU3BqqJUGh9unakl8hN4AEkeefoWQVOWt/8UtD0
         +9UhJHISs54AYoSa5puGQXvmemRZYuZ+LcFp7OTxNGLc3nnZq7u+ks2CgfaIUekk+tw/
         N/1YlJtrHxdBfW7kklIrtInwaVJIxMvNtVo4niQdDYaPI60UJg4WOghiDsjwBBfkrS1Z
         Iv8Ly+pLSxSau0UqwBF7rP96WS1A8kC5CGbfqiB9qmDL2gZst7/dcHm5wH7/SfnkF5XA
         4EJOKIjTZ0aGLwoGr+VNxYKQAlXsigFa9BEoyHTNyzru/7+SMpqOlCR8hur7DtCODr9D
         gvdg==
X-Forwarded-Encrypted: i=1; AL+hErFShfDORCl9QpOHunvrXKjsVeJia0cwnvi110uFtQ2Ckq2+2EVHhx/Rq3D23ppmblpZHqD5pPSI3g==@kvack.org
X-Gm-Message-State: APuU4Z9FIc/JRn8MQ7iILwy9Wayu+BOiFuKN0MgZQWSegT6rGgmPbd35
	Ej5ZagROv6A5JcmtQOQWj/Dz6DcmUZBOd2qkabx1xU4iEbCsmOB0xkmieNbtNKVCp7M=
X-Gm-Gg: AZFdTZd8vdD3+CWdwri/KU1RlJrRoOUF9Fc+Jh4LF8GGDe+sgeMkMjpqPYUbmayM8Yh
	LABHot5bWsXBzxGYuXQoNPYhF58L6H8uIZP6W9oiUV1WrUK/GQMKViGPk6HYGnU/FeYoOCaPdKI
	kPr5b8HzofPHCWNx1xIhAVxvaRMev5WWjxU7yAG3Zoa2xaS+dqy0kijLHuA/48dpQrnGYJW6Pur
	TlHnE5IDlSkfY/0G//+escf9+qMWWG/l+IAwnKjHvGm4dOJmFy+7co9lNnlsOLyCd0uNg7zS6Xz
	4Vm6eJ92zGbPloC7zqtxkkBGqZUF9/1cH2zngnoqRLvuIGWRjnDoTP6n26eX0j4D5NcDXygsb5d
	j1+bnF9XALSo8lV/KjPgbLJvro73MH78GyRyfM09H1gFV8UPa6EwKcHdMMOPAqmXJuz2mMbvQgB
	x3OOgcPd6ub2oSJkKustYyMIaFr0v5hQrTXJyL3PzDUkltjwNneW0UgYGMMcxY7NIiDb4r8yEyh
	DoviFSKE97mje3G+zIgXmOpHLPXgEnWOglBrST3dsITVre7rM6x3lDYtRu5FoeAL8CLqpkzc8TG
	QvtSBUhHGHCGiuM0qboefnOInLVoKgVEaIPRGyPvl1E3aubtms/CDYxvzCPBHrQyUw4t68VcN70
	B0kt3WdB95KvMkKEWecySQwrEpA/fFSnUJ5hum+lFwXpEOlDaYNR6rbfUDeaYAadyVwzUDhJPuP
	mO+j34d8Dp4+TM5iKllXTc5T6ewVgekpFie8VMVwjf8fKjNH630rDC4rphOyMOTjN0oGYJzKV0W
	5JuYebwrxkkyYT3mf6DRj4YgMvaaGzLxec3WuCmo3Gw1+RWLts3cQzB/prmQeOL5Q==
X-Received: by 2002:a05:690e:1905:b0:67b:e67a:da38 with SMTP id 956f58d0204a3-67df4423620mr3279582d50.21.1795413319184;
        Sun, 22 Nov 2026 21:55:19 -0800 (PST)
Received: from [172.20.0.3] (static-host-74-205-137-217.epbinternet.com. [74.205.137.217])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df30e4407sm5198997d50.0.2026.11.22.21.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:55:18 -0800 (PST)
Date: Sun, 22 Nov 2026 21:55:15 -0800
From: Chris Down <chris@chrisdown.name>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org, stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/list_lru: fix potential infinite loop on xa node
	allocation failure
In-Reply-To: <20261122031143.3639941-1-songmuchun@bytedance.com>
References: <20261122031143.3639941-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <awPVQ3aJxojMSEhb@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 1g9kfjjud867fafjo71pnmrtst3qefrm
X-Rspam-User:
X-Rspamd-Queue-Id: F15611C0008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795413319-338943
X-HE-Meta: U2FsdGVkX1+bjhjdhIxvnfp8q57j/SgCa/e77GddgdzY+Dab1Ve0xiZZ0nXMTZ5vTdzKscKoN2ZUENfMI4RSiGk3UeOcmSTq+KMsrOOmVJGt+8HWFfF8/Pn0fr03W/gWxRErQtZ/CZ/yY5WkBctqpfgx4dOWYc0xFlhdF2yypuNtv8SKBJ8RI6e80+5NJSD2dyOXDEdxdAUUMbP2VTA3iB7vCDrzRKTB/uxA2npU+dbQw2/N4TyuRjX9j3nftPf2u2r1d8lyB1ew8Q5EXf60LINeEVXjgxanBboq8SIn2TWEFBIZbF2i4zpJfmV67NF4cEiU1EsY8gyJOta1oSgIKW+GKlFcIQBj/CXJ8fS+nFRG9XktNhrFzjMvtxT1NGFZ+pUySril9L039EkZzdX2L9dxu/qXrzFj4ktYJ0HjErapLNqPQG5asMGZ0/W039gxDUr7IGMCsTGfq45vTJQLGnwAlkl0P8MtzW16W0Dq6+3HGjXo5mqUb4Hv3jeZIohs07dvmd1zybqKQKyuTRdplKFRLqg2mEk8iAgyT8cprRGysc7THxIl9AmFm3y/DAEuGGCxg819ZSSf7KC6WNCGDzphykbXPMw9qGQx0cE/JvnL2y0liIOujjNCIZR2Cy8QygUF3Ipcsy7X2z28WcdOUrKXRJDubi7CrvNapByI0+LrMFF150zyZ6jV6hg1EEPBsw6kFDlhTizNibJ0i9Ta57gU6Pxhwiw6eJJm5h1cMGnvmXRXUtPaXA8K0wdYfN+it8sBEvOEL2tjvH+xUwtJgMyGHELTZn5ILTABxDJF18e8O8qm/j0dWkoesFuSKi0T8zRI6L890NZRNBRaRWTSAbYRIh3BkTugwWtdYxojvF3Wy1tF09SI9R82IzgjwiL9re7Ikr4uAvxoRgfJmZdpVrBJJ8rU2UH0hKcJXqJvim8AteBfkSIY58R1WG7NtRxStvMsUuybWwoELYe0Yzg
 smPyP13E
 5/RR1fIvnyEN/7jF7ARJWzAq7gLqTqLbqdqJcZtqHgSqsm6KZfcP55f6Tv4PKlVTQY/TmtJBdQ/wjagLAXaR3KNzypuKWiQNeIlmijIORcZoFMW29W1a0Sw6ZJnqI4TTNUCF3Ut5D3wOBTw4r3//8o9w3zP8jDI7SN+el/YDUJxAC8K3lGh5J3dkBrixhFd1ZmESkIpbYxnmlyZgKoC3HsDnR7+Q3XImglEzH4KcDeQ8Hj0DMozYM3lhgjX/DHod0WbFB6g99Shwfxo+oPMfatm3kFJvQDeWxWdCzSj0BwtvxkXAY1RblGLvDEySpn9edrwdavPNJ5mFtCLgQdNCr2fhAlR2DSWcwKbYB/wuOB7J6wJUbuHUW7AMo5yVZHnXQD0O/CUV5YxPnkICXq9vQW6wx+QJNFqDjORlFhBRlCrGELp+GQDngPKcFJoNojuWmJP5bXYMNq2ryarFUwR0PDT53fIiIhi48MfWnxyet1Rfge301G4zsxsu+YaSkHcHbjL05l/eCiOWc0cf2fQG2FCbJ0fJvm5uCx+Gnfk7uLCbELcOiRVCLYzHQ/w7AFaZurKhqm/ysK1EN+msV+IMWsMQr3MCFDKnXoHwVYMzPeRwTyg7QfF965fPf69udBds35hu4/1pPjHhf4cCcX/EbtyWdBNwsSKK93HCEPYMly9z3swHNWTYlRof1JUa/Jq3EsHF7XF/34I7vFYwK1EUTZv+hy8NXjtN8049J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

Thanks, I reproduced the RCU stall by injecting failures into the xa_node
allocations for an unpopulated ancestor while reading a file from a new
nested cgroup. With this patch the stall goes away.

Given that:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

