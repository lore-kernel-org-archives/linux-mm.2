Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D99606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=SkPDjZgg
Received: by kanga.kvack.org (Postfix)
	id 2532C6B00EF; Sun, 15 Nov 2026 01:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204C46B05B0; Sun, 15 Nov 2026 01:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3D16B05B1; Sun, 15 Nov 2026 01:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6086B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:05:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 349808058D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:05:33 +0000 (UTC)
X-FDA: 85436316546.16.3C818B0
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E83F1C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:05:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SkPDjZgg;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794722731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68DxHpqqFot2faCcIPu2QwkdA4mxu3avVweYehLM7Ug=;
	b=Fgm+IxxKKoHt51s+yA2OnsGMlS2WQCVfJk79rKLInKiMJEjSEHuHiwz/VNTH0DnjrSXVIy
	N9kZt/+G+7BReUWK+tOyTKwvETUrcjtknFaApowOwD3WpGX6fZXv/GHL4mUT9iOts58z1s
	nME0SP3M8zkkWO/17jA8ZOAXkQNcetc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794722731;
	b=uNEpNJ117eN8Dr3MLpma/+v5CtEC/SJaFH//7CGOy8JM7ji9MIFbF8ahFNQIN3MrlZRx+Y
	EZxluBwsW8CprUatdeNeh1ijPrDEGIUBkt3RPjsWcqxMZ0wFY28woAU6POQUPxKDyuI0Ne
	QytWYf04g27e8qNIFBkekz9IATLhN0w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SkPDjZgg;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-37986eb6fa2so2420824eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794722730; x=1795327530; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68DxHpqqFot2faCcIPu2QwkdA4mxu3avVweYehLM7Ug=;
        b=SkPDjZggGq8qrzGrEZN+IKA7JMtbSODye1wdUVlDD3JX2R/n3xKDxwYRasDDdd7PZt
         JH8rUe3JWd8COYvxDBTu0KMIXYXJuzQlGF46Q8zuA35+GkS019Hc8vjeKPtLT/UzbuVX
         cnaZLYAf/0XzuRtCwnbUk1fsA47ztZ6BAUjhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794722730; x=1795327530;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68DxHpqqFot2faCcIPu2QwkdA4mxu3avVweYehLM7Ug=;
        b=bir+vzLQJFHCiE8ft+1wL4F4bjLO9P+vr1dJ6bloN03PuO7/3uoOIB/1T1POjlBCC6
         peqt+o717EO3E3MD6UaMHCvMIL14cGAq3Sxn9uHNVjeLWyqQEEFd+rNrlvnztZGbEfkE
         wJB52zGpxW1gzJzl9WUO0ngnQhzpVJ2awgk9P+H1sPGy2aceC+qJuaLTFhBviCSQUaN0
         7InU1eCOgpNcLQOAA64/X+H1iad6bNiOV+qnAkQq3nswHFUnJRFU4t+Y+wZZL2pwSGQE
         P9hs/o3O09VTDbFpH5wtBE8MLDrfiqVY4B8jh+6r+TpWL2bl1ruN1uRe1WpWgSFncqDG
         DgjA==
X-Forwarded-Encrypted: i=1; AL+hErGEdZbh2WvtmVHQWP63GEzkGzZqsoANt5D2Unl/iM9i0ic1SnIMmaLV7R9X5WvL3BGdzA0eW6PWdw==@kvack.org
X-Gm-Message-State: APuU4Z9WSlwNjHxdk8bd6UPV4gkpivaiwwflXUmS6huzjt13PABjC+he
	1JP9T5Jb48zXQUbXhl4JhV1oa8QzjiRDoMKk7qMPmS4IspUZ2EHEAzj/5fbShj57SIU=
X-Gm-Gg: AYBFou0QT/DESd7VaX4fDz+UHjIdSEH+/UBTC71HU+7meKPvmHV3rOohDC9tF1EriT9
	A9gvy1h2oonhhoIYIP3ffVq6aqPP3/DBQWiC47etIxHD1okTz5gcFpL5SWSEO70NZZ7YoixdBx8
	wuiN4MsLpjrkFLmOnjeOP6H4fWNetPaNxizJnVJj23Zu6HSdT8RO3yrGxITMjVmbvFC9LsnQPO2
	RiVSOdaeCqJI64pNsx7MaQ2Gli6UMZQhqg2tCX6EAg9svnMnJnAKoRHJ7MGiMZFDnm7WYEwdf/N
	jqAeWq8gqa6+aXMnqgBkZJ58FSIh/sAFuDVI93u8ztSr15upmWToya3NMIHVtOzjtmXJSvY5ahY
	A+fHg7XVvYWbPYu1we+r+7d5hrRdxX8+Mzuh4cI6lH20DG+PKgWDgdqj5Z1Xui8g5v5nSXulpC9
	k9egKVarKv991HMt5GAUVB9FLImrmyeXkJX7PXGpFHRmvgww8niTHZl2JLrMDVCS1XdcQbHgnSt
	Jf4wcmlF0biZTrGna3hnp9DlpjzkzrGJm2vqkuFuhq9E0YAb7FLqrtSuNOuE+GYbg/36tTTm3DC
	NJKadxoV3dKTFYykiOcvxi9Cx/TsG6glv3OlOyIgScRjQ5YwouQsSg1uGZ9z4vvH+7biJEsixLy
	Zog5CbxOKAhl7n1xlT9lCpgOgwlaM28uB3jvXpWk6UWWhZa6g9dreeIEmNDL4aulRdt+wNfbKW7
	/bLTGs28Jp+pLLiDVxgAGFni9jHM1iKacEK7eK9orVebLphD2xGC6v8+Aq7AUC7Gt+
X-Received: by 2002:a05:693c:68ca:b0:369:f05d:6c5c with SMTP id 5a478bee46e88-37967410b8cmr6726925eec.28.1794722729913;
        Sat, 14 Nov 2026 22:05:29 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955332a77sm19790083eec.4.2026.11.14.22.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 22:05:28 -0800 (PST)
Date: Sat, 14 Nov 2026 22:05:25 -0800
From: Chris Down <chris@chrisdown.name>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] liveupdate: luo_file: allow keeping private_data
	from retrieve until finish
In-Reply-To: <20261110175855.2437084-2-pratyush@kernel.org>
References: <20261110175855.2437084-1-pratyush@kernel.org>
	<20261110175855.2437084-2-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114220525.cdf6ca6e7fc4cc0a@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam06
X-Stat-Signature: mnnc3hs4xmk9y815fu7eh7zrckwu6eae
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4E83F1C0004
X-Rspam-User: 
X-HE-Tag: 1794722731-941146
X-HE-Meta: U2FsdGVkX1/FRjocNI/tMiRDIRIl2QrRqGsVdhdavvmS4VMcorSFlN9Q+KMjzmRQFy06cSzcgBDZsyWaYlKiH9Dujnwg7w0x54FxepgKy4L/hNXhMioSf7B3o82gE8TcLjJZbSFVyyIOR8XpZCieDsV+Gn6S5qTjO6+EE0ZDnD8VgBGRHhpSz18CKZ+tpfsiSeRKe77T6r7T9K9EHRHZaEvjZ8AA/xR6fbuGKorYixF5smP1iAEeXxMggRMcE59dnvYwWIYOqqHBqQW1XJlkvmbm9GOknm3kWzbnCWScX2D4xUPG+VZy0aOyENzX96TtULtvgmZk3OwVFwLlPYVO3ayvRYysQdKrI/gedeSZHu6ykUV41jr03wEEhFsUUzaw9oTEHzNhoeOIErzXz9Jte9p8qHVaT/HIvK60WUZVqDI0ScFVBZd8xJY4HzLnUOovJ94+rDVtF7eoiOiRfczzQqBPZv9aYw1ZLoUOuodtI7GcM5w6SKysXDldOli+zC0Dl1oMzm4aPmWca7KNW0JS2Uw635EbU20PzMVjHP2W/4UYuJeDONaH1GcsLZbHhDeIBPD1Bfbs8TsfbMMjCTYyx4thhJumtcSJVFkjx/WeezBTPWI9+CXYQMmjqMmVcOZoFESyL1JYTf6SJCwQ5HHWkzRjwfOqfCIzYHr/ypKqnSZ565Qi/1c7oVwRtJLKSL8TMC7UliZ1/3Po4ofHr4mzrQL1lTaVmAyIk0FCiAOa7Gg/6du6g0fRG2xLfg3fGLrswffBg1wo/ae+A2DXDRUxduvo1q9IiL/BLn4wYt6f4mlufcclHhhoYTIIHCce1/z6I/s2oCjI1EdCoP8T54TkyIiqV83j0eFnXhGN39z8IZ3zFngKhV9fUEpL6xGZqM1qCePP0eVA2452S6B5x2Y4nBJPfpwDqRIJxTb5RMdkrYdmY1g9Yn9yv+6xx//RIggP00FAUJjI9/+MjOv1ufi
 svF6GZ3R
 1AkGWQnOMFars7i4CUr6mDuAm8RKOxbSB9g2gT40ZZuxdr9sx+q7tg/MYSUZCHxVBGVz50780etAGOccDa/ji5tTrVh3npLeSsGHnQWo5gFrKrjTTodA9tzZgllfCk+ODLzlHu66+EZqOBZ1c+sXRRM/UNmYmGkvu0ZTsx1VIOTnHzAJ+BngEsP1GmKLBpwN+TXYTPPgiu64ae9kTiclomJ8/mp1Fn2XP7l0BwQ6b00XJgNaNMeWgolXvKx806nwcIGUi4S1HqJyZb3YDVcx9MJYM+H4QVdcbju+6OinQ5seE6fK5Za4RmRsQfbeuen2U6ev/xPN16kMSwynpMu22jxsY23NGoMCM4KgWFe1XkSGjYhrDtont2bJm2uAU85Ip9q/c0ux5wHNeK7KoPgZ0zGgC2YPKshKMYN4k8XIaYIouog3bhIfRP5SAY0t5yd25T+98rD0nxIxAor2iEgGODhLBN84LEgI1xFQSMefxJVAd11vRqhspINJbrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

I've tested this together with 2/2 across a kexec and it works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

