Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E74E748E6
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2FB6B0089; Tue, 23 Dec 2025 16:38:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC65D6B008A; Tue, 23 Dec 2025 16:38:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB666B008C; Tue, 23 Dec 2025 16:38:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF156B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:38:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F16613B20C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:38:17 +0000 (UTC)
X-FDA: 84252049434.16.4D12A1E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 30D9C4000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:38:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BoWdjj9g;
	spf=pass (imf17.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766525895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4UlY53rg0qpE7qUCOTeby0OH8dUG8TIZCeZtME6Mjs=;
	b=rSGYoDmwAuepDxXo5oTrt3g2a9vl7/wtSuON7mf30/usL2Q+KJlgx94Hsme2jsHcAoQzl9
	EVSjq/mLewRm8FI75TKAMcqJ7GxDHGP40YzoG5veSvfg0ZXFOV0OCVr04NfTQE2yGfHzXy
	UKdHawQJer0m6+cZHTn0UK9LbNFiTIg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BoWdjj9g;
	spf=pass (imf17.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766525895; a=rsa-sha256;
	cv=none;
	b=Zde5TeuYUty3gKifRcnMAf/8CE/7LGNZ+OvU9iehudNxdgY/SLH9GRobjfQrkzTuNk6ka2
	byPkmOkZGYkQd42S/kqZSlZOSyUXY7vzp2mJAekqAdjjTEqL0OfS+AqPqLl+K2tbkDWOLV
	8b0cAyN8WadnZRu52a5VDPztkFqS+EI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29f02651fccso792015ad.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766525894; x=1767130694; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4UlY53rg0qpE7qUCOTeby0OH8dUG8TIZCeZtME6Mjs=;
        b=BoWdjj9gOKUTxRV4+im8/zHbnS8FVo8+PjOy1sVJdxTzV4MSBkb8Yp3q+uANjFi+Fi
         0xzn8MraJ78tRhiEkeAf86fU4OUvRWBnl92wChbQECNutYR6QkjteUryLpST+ylzKjXq
         n5gKvFiUqwwNU2O5riEM96lO2x4b6OLsx2fCydzuev3gO3cxbbhqoZCusqK98RX0lro3
         mvldut6S2SZTowmTG+brJfz9sKfRtRQ0n5J3T3tQ+l/jETdBe9jt/FJDbrn5z2B21Hql
         9TFI7qjx9/TF2SxODeLx3xxIJrwPJkrOiwgSZ75LLEFNGQp/hnHK12fTCyTWnjwN7k5u
         ewig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766525894; x=1767130694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4UlY53rg0qpE7qUCOTeby0OH8dUG8TIZCeZtME6Mjs=;
        b=AVnNz2Fjen57Q2K2kpAmE1IFdtPV3VdKTh4hq93OIi/R0JEh5+8sImTiR4ruKJ851g
         rQt2L9Mwq+akSAP3gR3SC8dt/tJG9DjXGpOCfqhwRcd8xUK69Fpx+RLiFySK5gXfL0eC
         4t/0RsITMJjijV2nJJNDWMMefzXxvczNL83OSc/SWwlNrbpML0ht9hD6rmgAQ+r0CfRL
         4+V+xqjnxdC8Ex8tC8QXaUJZiAwg6Glx4aFKjIvICBpr/iPezrQ/tMElIUw5+vJPirRf
         ZuKlVomllZvnSit9geWRBjGJQZOmLrsYznqNp83rVfT820d44vBA576db5WE34xTDRSM
         k+PA==
X-Gm-Message-State: AOJu0YzoaeJkA4zcFJaXDNluJcJViLLwd5Q0awMYIMAm8X7aNdEHtTGK
	v/fVPEm8vjByZM8kcxsar2duWLrmbCIA/UxWC7AxnrvhimS+hYPkJrvBEb1FyRPL4AmtFhFR0eD
	+7oDoOQ==
X-Gm-Gg: AY/fxX7BtzaDCvijsEm5VBRAchcakgxyQtwsOYhtxkVgMtoMNEXw3EsYnQPiW0h0LEc
	GpzX3c7+S933IhWwYZC+fkCzZxVTQFGKBMyqNzPMpKljqSlIPXTc/dWTAb3K+K8z3/B0y1Jc5oZ
	fKLu1C5GVI30N0T2ilzqsYydfNroab0AIlgXzar3r+xUKJazGEYnf/UPwDhU19Vq5O04Jok0Qst
	Gqhtl/ucZEcf+I45D3BWp3v/EHgEzKCtLg2a3CwaPXFgAJcQPEJMyywUUJ7L5VuG4OZmchq5Wt9
	VTmIjJYQec889kdpSHKAVYSCZbuHFkkFIjbqXL/lxtfOfVrWJNsaOfIDxSTHXAwllwdZp+f7d4/
	L8VelgDW1YtR24sjIR//XKp/fd6TlhQfLCRPTgNXzwasdVv7Ppo+sw/73YmrUeRMzTZGX6pn3rM
	ex9afp1zc3cDx0SLiMl8yKw3bW4L30LT0ks7OIVpwN5PxOcKKZVsGN
X-Google-Smtp-Source: AGHT+IGs52EWQM2FUMzO5YyNfnbgcTLrszUf1ftByMtYiGKp+ZRXjSGr4Y7SBZ44TSjuWIdc+/wPVg==
X-Received: by 2002:a17:903:380e:b0:2a0:89b0:71d7 with SMTP id d9443c01a7336-2a353a52bf9mr268415ad.13.1766525893282;
        Tue, 23 Dec 2025 13:38:13 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c66465sm137827105ad.15.2025.12.23.13.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 13:38:12 -0800 (PST)
Date: Tue, 23 Dec 2025 21:38:07 +0000
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	gourry@gourry.net, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aUsLv7LAgqGlhTjW@google.com>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30D9C4000B
X-Stat-Signature: 8wknfn89ofttynegy93nogsib73j5d5c
X-HE-Tag: 1766525894-205326
X-HE-Meta: U2FsdGVkX19zo8VeOMvqjyBLZXsiSA9Ch+YMdyIS5XMPl1JORT7GIVxVh+Cbs+sxehL9JPIAU4lQcf3Gnp6UNJsaRAoolb4PTgACZclMIOhto+1d8HmnbkvKDALDeDthrNFTaucxsF0jfzRTIMjwl2FW4a/u14extgx06tlaKC8qzD1yW+MabLxpsGC/HS9ptJSSzTRHGqRfLecoQ7QvrRC6jw5YkmyfCn9sppjVhApQdzyg/INXgs2FHOKwPJsqSu01wogsdu3pQgvqqAlT7myIC/fU2nB481dA+eQute9oZQoKXW4+ZN1UAXTB87GXWhsOFNPpq276zRWRilwLPsXozYmRg4hXCg1sXdRY7AV4zodx/zjsZijQUaqprc7iR/urBz/w2btaxMEUmu6bAkL+B3YPw8AzMZlTUkgxXZvlKMzKm4bm0Ma2qzDjU6Y7EkcUzwNkjQ+OpsZPEh7k5Nlusb+jgWiFTyAZLgqE4EyAtaCuQmbGuJjGtijfYjyn0qAg4sJXGqaVsBIF7dItR52DhKl/5EmN+y+6S3krONYUvyLU5A6pdXtrt6flVMh/ukLzDtS2xAoIcEfEJYzjn8+WorJkS4mVGDpNBWJ74x4ByRQ2r7E0ba50OiTUsSRfbLX90cpWfuWC7l+/Vcj39V/vQl0nQI+H3kM60LhxbsZjyR8qnuEC+wVIl27DG7tI1AUoUYGIgN/s182svLWdutRKeSjuJctIgYk7F0dOgH9QnIW9DRcU7fB1kbSbVQLa7Q9B8YVypcHLYyOps+4sDIaqB66qo9Q/2YQViTCpjwOYZGdPghjov3JSoV/2yz8cnoHi7IZyZw5idvr1bnXq62uUR/IqNYvVmS+pksBpf+NFqnJmvzGz/OZH3C3G9lBgS7NYqttGol/Y2KDChKK0ZPdWv01VYq2e1ilVZbfxnMlGDkClRd5W1Ioqk5jLse8w43O5aCQ2ZIsgTKqc82Y
 yLe++2xZ
 mGLh/gnzj5DLLh5EU7oQjyYgxKazHYH/nR5EKvRy7uDAtN0EZHtVappKSdwrYPlROakhsOYNnMDIFXvC2Zy/BnzSEHQIX1bmlLgR/uapXM/c+YRIRE0Q3y9eQc1Kz3QHiqTFwFqX2156Rluwq5KHRBlJNGirn0DBCp+hDExFwV4HHfOP3HcPOiOYxaJmBq8ykgL6OsVwzX1u3EshA9Ii6J7v0/Mjw/J47UuKpcyTDj54HCjk3B1MWl6rITITNEnvd/a30cnSqXWM5fKU1D0KtN8PqAk9phE67p3Iw5FT64pNOS9LvMM2NwN38UXpdoS2Zel9k2qWJuHDq/G7Va1EcUFj/Vcm72/E3evho9QtgjBvTGbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 09:19:59PM +0000, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.
>

Considering these bugs are introduced from one commit, I think
it is better to fix it in one patch rather than split it.

v3: Rename cpuset_node_allowed() as cpuset_node_get_allowed() to
    return effective_mems directly, providing better versatility
    (thanks Ridong for the suggestion).


