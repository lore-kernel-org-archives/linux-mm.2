Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3A3CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 19:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C10E8E0007; Wed, 27 Aug 2025 15:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A9F8E0001; Wed, 27 Aug 2025 15:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459948E0007; Wed, 27 Aug 2025 15:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34B1C8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:57:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A969160854
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:57:15 +0000 (UTC)
X-FDA: 83823596430.06.99778EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A21D40013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:57:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d5LlrHtm;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756324632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WeO0im/QGecZr0be3griSovPXhUrYcztVBMRyg2pzV8=;
	b=WEsNSCkzOOwEvePDdFtq9N3G5GFck3zkItvLrDqqVsyrrsivTr3WLZZ0IBntTVY2U/+OJ5
	surrrACKx6K5tQ/mvDVI9sF/9GQEMyNzmTE9eUEEEz/YJaaKWu7ug3gsNzfixyOBz1iHEw
	89sNDf6X8CGwvvxh4EtFvlfilPMNJl4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d5LlrHtm;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756324632; a=rsa-sha256;
	cv=none;
	b=R0iiAEBmjhAPy0HK60MgOXsXTBSbKf8htirhuTHJXeO8x7VPOOLd4ZeJ6RCWNuadhl2RD7
	Ir6yJYp9lCA54F6GW6yDuhZEbbawS/KS2LXwcn5v4GuhQGAF5XqYQouuwHKIgLs2SkGGds
	Hc1jhflcjJBHuA7dj1Jdas6d4sRdang=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756324632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WeO0im/QGecZr0be3griSovPXhUrYcztVBMRyg2pzV8=;
	b=d5LlrHtmhs9/xkVo2glGMwloqYTRs0u3pRs4oJIrf1YUWJ70shWY86p21OHh+BznV/Nkit
	mNsHcsCn1OSolKne/F5+H5tEad3NLHxu5LRMy+DWu93LVpCvoPoK1n4XNVFMH9rxO1WdFX
	Ez/perLuphiLIO5RiJUkUU4O70cY7Yg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-GHCS8W7dO_OvUGHBMAGuow-1; Wed, 27 Aug 2025 15:57:10 -0400
X-MC-Unique: GHCS8W7dO_OvUGHBMAGuow-1
X-Mimecast-MFC-AGG-ID: GHCS8W7dO_OvUGHBMAGuow_1756324629
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cba0146f7aso58834f8f.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756324629; x=1756929429;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WeO0im/QGecZr0be3griSovPXhUrYcztVBMRyg2pzV8=;
        b=YDN6e5m9E0FHUUju9gvZ1Tb/mYagdJwwQlYly0d65ZN0xYna/tjkiJSKJAW5i4+SqA
         pSe8S6aWIKl2izIJWzK9zrK0XSNisWn6Lxi7VGmXY5j/pbuAwgqFAq/mWKPn2O7qdHoo
         MOaXZHS/WtbDsrfaCFwI2J+3sXG8QsA7Ejt8q0oExfPyktk9Ll07ZcG7NczLM9iHbbC6
         2nseYePpjA2PD0GjPdQSECUogNWBSiBs58B8LAgES/TO7UwMEdx+zr5MhbLvMhlCdecF
         87dENbr27PrySKdn2NWmBJmXiKRojdOMvjr1b1V1hTEtilVj+LgrHhPLVCitpmI1PbTz
         UZZg==
X-Forwarded-Encrypted: i=1; AJvYcCUG+oSLqaNhIY5ZAfq12bgpxu9CJaU2FHPrDTOQYPcq7HLx2RCNbxwV8XHkK2Z6NVy6YO15GwEyjg==@kvack.org
X-Gm-Message-State: AOJu0Yyd0/eVn4kN8gp0oxvbGUyLypJNVMUiIIsDyntQmjLrcVxgE4m7
	HgFCLtXXTRNJjurK1z3ckpi5XI95ycpIJ9lAvoXDaXptlUVbL1qkBh+I3wbIKnsoip/tKM2qOax
	eAaYD6eYHpPHlgfyRqg+Q8ytQFD103TuXts+BibnhrnTxmPxEDEdp
X-Gm-Gg: ASbGnctXJK3v36oui8kpggfL9jkjVWIjQ6XVy8gxGGbreSlRQ16uFRKaaRhkK3hAcrc
	WNk33Vik72rLZQuhIdi1gg2EhC6ud0O9V286R38REvChMj+QQnUM36fFVZ6VD2EJOiyU9EUVFnF
	SmVUkcbieDGYKhnN1+ylqCFMDCJrihZskkBqtYdnGoamfVTttIUy+DYbLXjlTutNDb7Uc4RA7B4
	3FVX4Z1CJ+G62Cdx60z1FR2iOWEeGa461/BzcPsgEg+sRXsrNfIOEVQKoAQJC/HUBve+4AkegKe
	rMrggFeiU+LVMgfGves9t/xw9+AQPPF257FPaoLykrvE4+QfchBihANeLjKtDKtrXu6avA8=
X-Received: by 2002:a5d:5f4a:0:b0:3ca:5708:2b0a with SMTP id ffacd0b85a97d-3ca57082f7bmr6237659f8f.4.1756324629116;
        Wed, 27 Aug 2025 12:57:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw8SR9bQ8n/6/JMeWtNWjuCDZmep5VhDu+OqVpD982EgtQAreXteDUKqZxzqH1dML5SdFe7g==
X-Received: by 2002:a5d:5f4a:0:b0:3ca:5708:2b0a with SMTP id ffacd0b85a97d-3ca57082f7bmr6237649f8f.4.1756324628685;
        Wed, 27 Aug 2025 12:57:08 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fc83.dip0.t-ipconnect.de. [79.241.252.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cb901975adsm7882053f8f.8.2025.08.27.12.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 12:57:07 -0700 (PDT)
Message-ID: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
Date: Wed, 27 Aug 2025 21:57:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix lockdep issues in writeback handling
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Joanne Koong <joannelkoong@gmail.com>
References: <CGME20250826131210eucas1p21a27a684042f37080b7a19599f479b7a@eucas1p2.samsung.com>
 <20250826130948.1038462-1-m.szyprowski@samsung.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826130948.1038462-1-m.szyprowski@samsung.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fMYNJqOyoMlSEK4f8T1qjDazsAT-UjzZ9j7Dk94wuWA_1756324629
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A21D40013
X-Stat-Signature: p94k6ti4cx3bf5878uu7oucn4c8p897x
X-Rspam-User: 
X-HE-Tag: 1756324632-267868
X-HE-Meta: U2FsdGVkX192jbFbNXzLprAA+lZVBl7W8r1zc9a7QeerbH+bMkp72GmcMKLHdMfZGxt9YkbSLLcmT2VpbH6DA42PU7QnuiIYijr30bni8Ya7q9UrRT2vPLNxc9PpraMsIQiUwrWvSXmOVXWwdVaW/Av8g5mb1OVpJb6hIJVNxwqfeZj+lRxIQq8tsP/yBu0Cl0T5qsckZK6Uiy08MIUd0EsJGVF8rjZQLdtLcefif2+ZlMusWkq4Vala5wOBNeCnmTVW32kAMcwIKAt3FAXCwixNeiqtz18lJy3zGBYOoobFSzz6hvBEbtU0tts8/87ppwfs1IxBv/jJhq/FFl960EoCnUl6lsujfq5TCuqQ8icLee6vK+E0LbxNiHiqVcZNMVgxrKPr+LJ6zh1wWe87eLygpahfMXEtTcNWLuGgRXTv3aOZ35Pjm4IKRTsBQQsgEVJczk1xnlaAm7LPh8dL6YNsJDDuiL4IMVGeahjtBh8fn85VWeIGsmUDAcLNkCHGp9zPwlyuxo5qoqrAxvKqMl1ONmM1IfL3V++kJMKZLmzbtivyHXWbj2+wPIc+4boLLskNRg3X5ZwGS8yk5p0/MVrMOwAX5++lWGe8RVj0RaDMW8kcQRtlEs2Ock8gfLzs0fa2rguFtJyWgT5Mkn4/iXbp/48zUZBZNbC8E9ZC8RDSVeEEVFq4GEbUOUk1THNoXn3QALrpJ3OoffUCRx3EBKmLEEulmW1pkIhq9Dl+/P7WmqxJFO2A/lsyW4X9CGaCio6IGcRy+NGt8hdKQyNPkDIvfVMmmjbVtybr4d6pmvFXQxv42OtzX3WaYst3tgVQ3E0RcI9iGFUi7lPB+U4Kko23s2c9D6R+2cVE9EUqi93WaOQvXN3Jb7zGPyo4Q9un4rflemDjHNleSxyHqRAol5XvpnL+3hsPM9MdzKmmNgMZZNy6+fLAHpVMBitfgHhdSJQerYHV29YeSIQPP2K
 UUozmzB3
 DWJfD0IZC+3vcmBa7K8LTzPr7oWXOeYOFRb6fxIbPPRBRRkryrWUuTm0+40N+Ifh30EcUR879hHZ1ycMGOK557hsyp4bj0/Od+dVundqvrsT6OHmQ/zA3IaZYPmD+/W03LPpeDOeYVPCJbZ4MOYq210R5B06eFGK4nW9EwElwke3iHk6l8xHQ5L7d157O3EdUpCZy5MbiepUbj3+5TYiBkdzHezqEQI5hrasxWclVMMME55Go0QF6xNAbdSBJVOpzywCTBm3Zg9l03vZLQCT9+/QJopD/HU5knarn8RJWrzbcASqsXhcVVH6MB+4m7orFXcgbAaZ9t1F6NKouvm2wg1yc4k+EvHDQJMPt3dH2yJwi9B8zkjaZrqV+6u+dd4IkRlav3AJ7L6iy/A5Y0cbVsBUIuxFAkTpEgx1krOxWj8v6VGzmux33F3adyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 15:09, Marek Szyprowski wrote:
> Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
> BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
> Unfortunately it also moved some variable intialization out of guarded
> scope in writeback handling, what triggers a true lockdep warning. Fix
> this by moving initialization to the proper place.

Nasty

> 
> Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


