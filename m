Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31848CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EB38E0003; Thu,  4 Sep 2025 14:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615F96B000C; Thu,  4 Sep 2025 14:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BBF8E0003; Thu,  4 Sep 2025 14:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40BEB6B0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:46:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E10CFB79BD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:46:18 +0000 (UTC)
X-FDA: 83852448036.14.F23BB73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7645E1A000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:46:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CslaTtuW;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757011576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBSOADYwr8ZygdaTqworYy0RQpChneRvGIr3llBzJqQ=;
	b=AEx4kJvw3mm0TqaeyNK6/ZtGoL/TnXnSiXssXpP2W31tDB7aqZDOPL5Q+CtJSMB1cJNg6d
	lKvcr367dgcWCPKTK2QbvbbJl3GUcq/L/52UfaAnPxCYs6TSMD7NyATbeqYdwBcrJLibGs
	SJn7bwewIv1vTtObkxNIWbchpjjsZ9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757011576; a=rsa-sha256;
	cv=none;
	b=BtXJfytyCXGRhT2MR/5UDx44I7U8YmWLhbCWG3IvcAaxOYg1OQy60yrUOdOup+Wzt+5rI6
	L3PbsJGrOEIa4ISjj/IaeAK85kwHy9nXK4/53Z66c6Ta0xYBpn+SbehQDL83m9JTfpU+v+
	YC40HIyIfv50qMsKPRujtBUFlcO9CfE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CslaTtuW;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757011575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NBSOADYwr8ZygdaTqworYy0RQpChneRvGIr3llBzJqQ=;
	b=CslaTtuWiQft9eUaKTScA0ur4RCHHBaNUYdRZiXOKVnDFchlYVy89G5bSz12aZb+2pLEKt
	XQ/vFoVhFhlSJfk6xqBArOeRV6ZVEV/pd+UdZ8ZE1um7rKoYO0qtDWbRrT6bsJZaSzQNfk
	XyOzQIICCX2Vqkmq5kq1RjwwDC98/+w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-k3TnPGaPPm6-UkAlfvEGoQ-1; Thu, 04 Sep 2025 14:46:13 -0400
X-MC-Unique: k3TnPGaPPm6-UkAlfvEGoQ-1
X-Mimecast-MFC-AGG-ID: k3TnPGaPPm6-UkAlfvEGoQ_1757011573
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8a2b9fcaso11203585e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 11:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757011573; x=1757616373;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NBSOADYwr8ZygdaTqworYy0RQpChneRvGIr3llBzJqQ=;
        b=YBnU0CdYA/pEqnTSXg6KjQTA0yytMJsmAbrDJxxKa+697dUx/B0lG7z/2rYvF7utAz
         mrcNyJfuCBIjYjPKcIdm0kxYspubk1RywLxz8VGngkK/2mu1oNmU22tnLcg2oGLQ3epm
         HZFbJE6Kg//0WFSP0HR0j4L2fwJ28ywQ27TdwY/U/LabFTpS189L3GCQQQZeC+TCVrFr
         CloYayQbLGgnWGDdCbKYpRHIe7e/PUddeAnIQefnPiWrpCH7amQ/IYxqK8EXNnR5+1qM
         y37zqn2dth/wSOsqMWUmI0Dq3vET/DvI9Oxu6VWXM2JHrx0BJpvCxMnRfu37Yq2cPsqs
         DlWw==
X-Forwarded-Encrypted: i=1; AJvYcCXARkO2dA5wBy8UAbrR0Py8Z9CsFtfGimuu47NXJZkhtGPDGjKstXQnpV0VZVfttfvALpRqGmnBWA==@kvack.org
X-Gm-Message-State: AOJu0YwpmVkgBmxRUQIk2iLsAWJEkKBXguq2yNButZZi4eTXRiyPBMmp
	yT6knyL16pa+efk2RvCje7Wjt3sNQ6lPK2r3Y4VEX/CX8fmFm+yqT5h3ZcoXGMzxde8mAIF+OPz
	t0wwpM9GI/BFc7t3oiIgxoFRvzFSl7BWleGHTVSTPKCRGbgYSqE+J
X-Gm-Gg: ASbGnctMOoumBeMJo3HxOL4HfuteZETfTz1KJDUPznA/Z04ecmIL5S+aWz5lZWwpXSF
	Layhp0+TIEVTb3lCu3j7+4bxQdaLyG6chlYyPDROh7v3KEt5Sdv9uZui7+7845qtVcQrv3K9vPJ
	SSqlJbr6ykI32fvQkkQpiE7QMRf5E/rnSmQrHuin3vo6c/yX2S2K8rBtkDSnA2O6LQPL67QK231
	nzLPU2luzdavEy/fHSPceVBKM/22dUcocLvcRLqUx8t7bzl5vZQY2P0IIlfkJL1xrinX5jzgxKd
	7W8KEcJPVHkHGcHU8Bge9A+gF1rmUqslZjJhDJvUtBrRCHrDDeQ5V+kWqvSfApa8ERnxewPbfEX
	h7gXDrtpUK3wceENr7JNjAD3CHeJFSXHrzb32XwU9jqElAjBNHXFxTTNZiTimMCzz
X-Received: by 2002:a05:600c:4fcd:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45b85533712mr187038745e9.10.1757011572664;
        Thu, 04 Sep 2025 11:46:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeLaYr/8wuH1tMnSHl+6BgHt8bBR1PEimm7tDFuQNTKq5/7xgw5++iJNnbLrjNKhjAk8upQg==
X-Received: by 2002:a05:600c:4fcd:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45b85533712mr187038505e9.10.1757011572221;
        Thu, 04 Sep 2025 11:46:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b81a9e971sm310049405e9.18.2025.09.04.11.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 11:46:11 -0700 (PDT)
Message-ID: <8f56ce48-6743-47f5-88e4-4c65f6865216@redhat.com>
Date: Thu, 4 Sep 2025 20:46:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] filemap: optimize folio refount update in
 filemap_map_pages
To: Jinjiang Tu <tujinjiang@huawei.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250904132737.1250368-1-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250904132737.1250368-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nAvLofnm-ut0TYTE_GppnhH9Jw0cr9kQJdr4q6X1bVk_1757011573
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7645E1A000F
X-Stat-Signature: xid1gn9frjx18d5tu7tmf4jqy7k3ejza
X-Rspam-User: 
X-HE-Tag: 1757011576-1848
X-HE-Meta: U2FsdGVkX1/iMYM/vHsA/y6CfFYq9A6jLJOt2X5xcqmgz+wM2CGDEYOzncYwUoICB7LmRZ1hb6V3v5y68tq0drNG58wzrqBYpqoV3DPmooSHlVL09V12EjK83bj+wXxDVQZnL8GIkLJ3aHnvtDuBUaOdNr1BrHW/9elXrfmtCYrkTCQXPq+IP/x7G4Ywys6HAUC5IJGY7Z3rbyEfQvRGrORShlubu2mWCDFZS/aSZW3I5SN5eLyBLZc2mARX0wwJHZ/gr3E9CgmXkRLEqmQ8FtMo5JecbrnOMUuWJJfDdO3h+4IZJjtO0VTttqXcCatqj6EY7vaoHabsy67ZjHGvkFyThN9FA8n3FmBwhWMXbAplQ/CP1HAQfwpUvLoaE3ZTaah+aG+NSpBTjukruoJeAz97QjAEOoFQ+SxsgvMZ5Kzd9q2OWikEvzWDZrgJgjrof+6mkNzHHXptVq5z+uoH7iGWtUoOyfwWwAttVkki4CO2iqMeW74/TdC2v4kag4zgSHTmFoElO/kNI5YbWJL35i8vbucelq1L4bCFKM/g+mQm2RFQuB4bPBORodzIZXh4wDKp+uWxAaszX4jWYPctB+5/z8aiHcLyhcw/JCpj9OiW5l4gjKAZCVYCN6e9qk+roqclWPSM/H0GRirBq5JJEB4gUl3DTxdWuy62/b3NxJneuFsf0YxtVqZzXSVO1gzz+1Zb8YNwXT8VamgyzSr1+OIwmXkOYHfEfsS914wIl6cjac7qWc0xaUz3H1InwzPq5YaY0AWWUrT3gk7nIIu62k//I/A4tIU2b11SrMaAVGQEtqrQ8wpmJar+T5YrIWpKMkNQo6eEdK/eEgX/+fL/Hqx6nnOWHFxldp2lDtGDSkP2/ZyKgtCLuhzid01TKturIMkyNzTFvtY0JeSbMYKekeD5oFsbBXC4ibM4B0e93T7jk4bdAJiS4c7ZyEs+cqM7XLwc6ve3pztcs09h5nu
 a9V3hYNc
 ek9D4Xita0gnQO0A04RJueb6Kw7ekScAgWeqBTY81gF3uni9VtgpI8J/VGA26gkw/MeWJVRTEEStqHpSyIZksd+7PWLW/jGLc6AzkDNRSlox+8Et76WMlMc0EJVO3pb0E/Z80UEXuIMIjQ0Zn3iXizaSWKTwZi2DelknJu0RVmcOJKMVgcBeeoKbV2DIUhd0ZP5oiklGCxp4Bw25B0aom+LHdBWSCFUIR4VupuK4Ps+IYulEmc6QpGA1SyRsiYpbmFWq96T+BRy4E0nriKlr3XHchsTQFXnk9z0RSQf/pvbjk9+uCnwtX9jcfi1c+tT8uh9frOdqtvmhIGVT3PwdldNeTu1hMVbddzdCAjz5MvxlFf0v2JQUPsTCWaek2gLq1S8vwXKguHR1aB/KHBbgH4JNDtMZgsvYQ/usht66OkMinwLfEC3maKc6gOZmucb+pa9hDEjzciZEWnmIX2XBk0tvopJocFtTwZh56t1kaRsEJTDgFlkuKZJXAlVswo7jK/4LFZqjjMnnWQana/QYTNFxo9SxrmJbXS4iYWlONIwGHo1dGTFaH2XfxDLQmvkVLY3DT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 15:27, Jinjiang Tu wrote:
> There are two meaningless folio refcount update for order0 folio in
> filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
> after the folio is mapped to pte. And then, filemap_map_pages() drops a
> refcount grabbed by next_uptodate_folio(). We could remain the refcount
> unchanged in this case.
> 
> As Matthew metenioned in [1], it is safe to call folio_unlock() before
> calling folio_put() here, because the folio is in page cache with refcount
> held, and truncation will wait for the unlock.
> 
> Optimize filemap_map_folio_range() with the same method too.
> 
> With this patch, we can get 8% performance gain for lmbench testcase
> 'lat_pagefault -P 1 file' in order0 folio case, the size of file is 512M.
> 
> [1]: https://lore.kernel.org/all/aKcU-fzxeW3xT5Wv@casper.infradead.org/
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


