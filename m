Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBDBC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EC16B00C1; Mon,  4 Aug 2025 11:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15F46B00CA; Mon,  4 Aug 2025 11:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AF96B00CD; Mon,  4 Aug 2025 11:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFB026B00C1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:46:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95A491DCB1B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:46:08 +0000 (UTC)
X-FDA: 83739501216.21.583DE74
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 92A70160002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:46:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQEmA7L0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322366; a=rsa-sha256;
	cv=none;
	b=a8pCEunrYuYpCld9x9I8DMG8l0Y8fnXaryeg6ZQqbzz5pi11PDpcTB+lJz4AHeQe2AFxaI
	qLdXdeeOMIGf0pJ3TylaTGqaCREnXhGVKWXMKZjuJl4nMxpI7u2a/XNaTdmOe7+Op2sowV
	DP9Hc8dsOAlN0yrAToUDQ46iam4cIwY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQEmA7L0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSPs+xmcRpXzGAfInjNfwF6qcuUqjylfctStx4mmHhY=;
	b=N9WGrY4iEU40tOw07wKaXrnhlkWQpXQllE+Dv0BgXoavd6kiCdrH4EOilfhYS/2YJ34ipQ
	HY11E9FlKXpu+hV/pUJFBF5t5AHwoui4f6BZmJJxSl6Q1Lp4iKfkqM78//aK54MI4HWjMB
	UvB3osws8+ec2CN7qZjkIb9htL+CG3E=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45896cf24ebso34277495e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322365; x=1754927165; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSPs+xmcRpXzGAfInjNfwF6qcuUqjylfctStx4mmHhY=;
        b=FQEmA7L0IPnLl2eYM3Ox/8haE8i+6VheHLh1xIClNNoLy4XbRORWGBnlahusbhnHH3
         oo8UsyyGgMHaojthD9D/FBHIy6EDT1eofBKv+rkD52VMU00zq6vMsaGc24IlPzw/t4FU
         QK6BriAfJejnTL2E/uPMnMSV2sCVUI9KPibdV5GCV3N/kj/BsFmjEtTjB2QeMP6MSPJl
         zLtrsgP1BJ3A9zY2MicDajxz1KzBGTfLbmJpkIi/G11eug27E3KTXmkOHN07AzY/C4ga
         OetVWP83zHoXV3CoLN77RJjEmJqnKs5VlgMBNZVF7QVyZtPyFjSk8Q1qxORvQjAI62U5
         /cNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322365; x=1754927165;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSPs+xmcRpXzGAfInjNfwF6qcuUqjylfctStx4mmHhY=;
        b=rVeU0u3p52+IzOxg2ZXvFSCxk6PSEIBO8whY6VZwhAMyap+7d5ma5aIiPe1V/45J3m
         jmDD6jVsHxHHFLJZk3th04B9LBmoHoFQsJr5oycZa5SqPzZ2B3SDsYGZ+e8knJYy7TE9
         oAWwmpviAOuXmKxGJxiOei7M6hzVpJXQJtTWL6Xr2F0M4fS48PSza4wnIXwey8m/3NqR
         5ZCA88i8MtEsSRy5WqZMMI5HVSIkTCmH1/jWCoy57Y14T7cJrwAApQC6lu8nMzVyWYK8
         a0PgZARBwA4t4OsqkBbAhFFo09WE6xrzEOkLwsAMhZKpO5gyCleU6MwmigabXvAxsevX
         73EQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsHUyIPE3J66fL34ijU1G5mlHDv2xefX09Wsir9rkotxLDryd9HNzI8+WvuNjb091eR6iff8teXw==@kvack.org
X-Gm-Message-State: AOJu0Yw67lMDbtx1LbhQQ+Vwu1/KxNM1atd9AgqZ6gKU5gtgM8eU+aZr
	Z9H7YHVARpToPcniXIpP/mVtwohespEmfcKtZJSbyU8cro5LTm0V8foR
X-Gm-Gg: ASbGncv1XYV9ijRAjfw0cRug/4uULuuN4J7xOg4d89RerQgmik+iR7o5yDKkwwgqoQ9
	AfYhhm/jBOqbmOp6wgc2PRwqTPt2P3k4Da8Eg2kezYdzKFISPK0rZxqrLYtuQ8xxzKxa28L0h6l
	euzIzc/MOlbv2J1nHQ61FrVuzRj0iOQABTyCDcFVvQ6goyEKd5UbfO/MkyOkSooqw8wQqnjtb4m
	7jZIq8iIutL8NC5dgmLKN8dNEw5u1jiYPJlBapggCze0BmaqLylXqvW3FQftDRMGnlUDeR7wYDp
	nKT9n4f/OhEq+aSIljgl8ej1tfNMUf3pIvFu8KuDCI48cXra+nX3Yu07pb53lSjiJ+oaj1YOsXA
	wgE+5pbr7yH3C+b/WriT9YKHxeaCrc/0y0eZcWAihJpFr7b+4IfDcDX7eaOlBSkwf95AJrvJEPZ
	2lGf4eZQ==
X-Google-Smtp-Source: AGHT+IH3mTcbBsftpdea/bfQ68d+fnRjUnK7Qbl1Z7kxY+gw6GFtjqZKvLEbxRDEUPNLOcHUPMEsYQ==
X-Received: by 2002:a05:600c:138d:b0:43c:f44c:72a6 with SMTP id 5b1f17b1804b1-458b69f2c1fmr90559905e9.2.1754322364805;
        Mon, 04 Aug 2025 08:46:04 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:64f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458bd5a1148sm57008995e9.0.2025.08.04.08.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 08:46:04 -0700 (PDT)
Message-ID: <58a3317d-96e0-4836-a4c3-cb02c5c55095@gmail.com>
Date: Mon, 4 Aug 2025 16:46:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] prctl: extend PR_SET_THP_DISABLE to only provide
 THPs when advised
To: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 92A70160002
X-Stat-Signature: showdrwxzqpya9748q8qjjskod6app8w
X-HE-Tag: 1754322366-443642
X-HE-Meta: U2FsdGVkX1/ASYnGpPHKg0TPCWUmFNm2a/1EyTIkYiKIQ7PYkVjL2LF56ItWHqySuB4JtSyD8ADd9xebZ9PBQ76PL880dWpD8hAgZGJkLwep1c8sC4lVNUXqPgug8gj0lvMECtvPN2+DFmfksbKdir+Jcoc4RSiscbue7FCp6LCRquKY3HKXu7QyalccdqlyhfEwByAM2m/4pajKv7uYbRSkitO7LRz5c0ZjPTvAriI4QQlz/mxpB7Hrwp9dQzqjlxzNtgF5DNimjjMuBTUbesjgDibioFlkj1ee3VROxNVpPPKpldDLg4GG2usqULgME9TNQu1JGSsKKFzpvs62ajuSMu15BFEUImA4FqIssirRrxQvpMJD9rKXuJ/YYUz9y29xjIhVojOY6YAll268UxRnmW//TgdNqHzG+wXTD7WiymQBGJo3wiy9s2n+PKNPh502lPQgf5/2Sh77aRf3FkQQo9nscNyOvABgR49GTb+BzAJWrYxbzQGuurLtvGc4qkwrrEIgo7YY8/pLI0wAK9jY5t2xKrz1VKJfXuzC/yX9q3VCUnCXTHT3TlIu2w81brXuFUe9JeVw3xFYsHod8n0XTCmR9pX8uHyEVJck5G2S5yt+uetruB+3Na5bz2NUaMNygF9UIF3KweZoR/RxKM9GwtEGA4hHPe2F8VaARjogSFQYY0zxGZCcD/hmfvdfcg6dk94nWTJPYvqQstgz3qyQrQovZi9g/rlujOhs//Kw4IwBpfXqJSCDsQL8eqhNEWxZj58Jo55IhXo/hLhSWBkMh9MoU7axXGNQcRCffHkGVEc29hgNRl9HCFP5EUFh1vKw/T71Anywvd/fF68SGLYSbUmOLteaOiN3HCdnnmeUaUWAcMezpTbgx95Zkk5XuRXzThqans/FCJeEsYPDVWp1ai13cLqx2tVgl1hIgyHykk9X5mbbrq4WyDdz1FLLX5sYYQtWddMoLXHULUe
 6vO2JQWy
 BUOjh+NQ6npPzgaFCYhUq7Xv+LpWQ0EHS08TiLl8k3485bHjejsYshHhbbFqZT/guI21HoxqUJJ5KRJaKN+t6Hfp3/L8Q9E2luRq185JgGx3uOqDrrhijLzbf1EA7a1URlQ+netNcKutNwvcD+kZPlBfTsUgBu5/hkbQiVDd6o4MuPbF6qrh1bSe2pm/Zfqr05INRQfsps9o/Vd7oeQdcpuewgBAaGhnNU/mM2GRzezXUTzeyTRaE2GRCTjFAO+qHzDvhiosJM5oUPBA6ciiG+k2e5/cHt2TbjtlGsVRSwewsIRIbTn3cEL6pfaUoji2K2owYGrBuscpmaZWZ3iEPSCEjga/FVhDmbsSbRomvgZc/vS9ZaZK5mCUao7bPCxe7vZpsRX8ngNwoPdAeVeLSdurAPPjbazsNoO8P2U6y9GVsSdGYI3hsha/K0j/7KRRcoi/0aB8wnMWfkdusGI2lGW0Q3HP/Y3G4wy2HsK+/WIk66RcOtLTACt64bgayX17mu8zjjOKPC3f2+rRqVp3Cf/XmZLKUG9x0zpzHCKhudOrBwiTeEy7lXMVOUKTFMljStpOb17ieCp59g811Icz3/SBVUDfe3opM9sCZA/WXwhOYukRGg06vCAXMnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/08/2025 16:40, Usama Arif wrote:
> (Resending this as forgot to include PATCH v2 in subject prefix)

Not a resend, this is v3, just forgot to remove the above line from the
previous cover letter :) 

