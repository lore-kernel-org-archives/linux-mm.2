Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 810ECCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB45C80063; Mon, 27 Oct 2025 11:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64A98000A; Mon, 27 Oct 2025 11:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CA280063; Mon, 27 Oct 2025 11:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0DB98000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:44:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 673B756B7B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:44:07 +0000 (UTC)
X-FDA: 84044315334.13.89DA694
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id EFF5B40005
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:44:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OONvCf+o;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761579845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adOAQTvoac18lZ9/wdsLg9tnRtOabe7VU03ECgTR420=;
	b=lgCvBwZd/s5a+d7W0TBo515mxiqNCD3oP/xkuJlXqSvGXdXMyCLmqXdyVRdCCCbUnWVuTo
	nlgxeAGPr9jqsnuOF/UmnrQTJ4A6k1NawH7eIlZjiCr8l2sAZeZFFQl073kCOyR5u5OLY3
	b78AfV8f+A28vxan3Y9MXr4jJvuw0lE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OONvCf+o;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761579845; a=rsa-sha256;
	cv=none;
	b=SUeFII536EhxfM6gaAbiZtf5fXVPGdjUgblMc8AKO6aqjxJis4v2G0P7DDIT4DypSuxo91
	eYa6/TK+tWFLjWlfQxre3kAt4shO039bfkIc2ti8QB8JkCRCnrkW+Syf2LOc5jbH0qzLTX
	UELuJkoWCgkLNW0Z44Q3cnHWk0JDpeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761579844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=adOAQTvoac18lZ9/wdsLg9tnRtOabe7VU03ECgTR420=;
	b=OONvCf+omaS0XEAdlReBiSeu+VLJjIdqWTxVczkMlS8WyNUhCnlsHXd6KTP8/sst4Gye9n
	utEWwz21kAY+b9BqFptYldDJMP6oUk8G9ibSZ9x7KvRe3h2knSAgxC9Z77DyrpQXMO9ooM
	oCb6j+ML8uzcAtdmoiC59OXwM+Rbs7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-zYVMscWmOCeTmVNeZSPE9w-1; Mon, 27 Oct 2025 11:44:02 -0400
X-MC-Unique: zYVMscWmOCeTmVNeZSPE9w-1
X-Mimecast-MFC-AGG-ID: zYVMscWmOCeTmVNeZSPE9w_1761579842
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475dd9906e1so10333345e9.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761579841; x=1762184641;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=adOAQTvoac18lZ9/wdsLg9tnRtOabe7VU03ECgTR420=;
        b=BVfPvzSYYuapArINyn8nWqd59ZR7PVKGcdRFZAGmkN1cEFrTVVDROVbChXbJXkgpGz
         Qw62+jCvW0gXnyyZRazYyVwmMMkqHtUt8DThJVZmlSARMmBssvIRZ5IL8wohUuESe9A9
         rspBgHCMufMu7QNykTXUoAvzviz9Wf6+7auTUQq5o8mCxQlBCFdxkdkzGQz5IR9xclBT
         R6LK/T0362lXtakdc/+cwx+aCLC1A2k+qlIAzFdPumfROnUP2uQOCXK/mugyxLjMDtGX
         5V/fL4kcC17ml2eSlBjg/c2rMqiOBtDCO0aZ5Y6JS0VbyBovVdCkyXM/ecVlS/JvMBSI
         1JXg==
X-Forwarded-Encrypted: i=1; AJvYcCVEj5WRuBHOG0AMRriL9Dhkwflwxc0jRToNIjCDwILZSRb/iHDKQCrh4XApaE0i3/KNkpJ/yIB0pg==@kvack.org
X-Gm-Message-State: AOJu0YwEUPf4n84fE8J+HR7Y3Vejld/SHHlyqRKK23j+oJe9A/WOE+Og
	g21dtlowgORrW1YnGZyKU0Dn4RssgDOs1iNAOOrmPwJKiCxRqo/cokbLB+1KrKdyxvy2ZGF7Gsl
	GNXhOkkzTnI5U4GYodticCym8psIxS6j6u0T4i7TFfyYBsEn9/a5s
X-Gm-Gg: ASbGncv9gWGnFAv5bWaniTBC8lmQ8MJlSlew4oDXLQlzE2CK0cRpvLwG+vHxM2oVIeX
	KCNCqzUWmEzqhF32lzn+5RlQqX+xi6qznSSKglZHICQ5fPYG/MY3GE7blwfKv30TTjlL7QAXpLp
	4l/w1bFDnLI+62jgqCaBjSIl8BBVkxb0yk0+2QG0C2W1PAq5f4f1OmjNA3iRVWLDjelDorbJCdM
	J29vI4Bb13cw6IC+uA4e2rAwoV8UGhWqBK0iX0KKAzua6FwyYkz3KEU7JjNIgol//s8z7yRSUEK
	96jMQjHlyaXMrH7c90oFNt4LdfdmfkhTLBD5n1FLSIPMXwRay2uA27RMmksVm0bFpv21c87gOnu
	yXf19FKUeEs9gxZRNjsixIKqH2Uz8dXd6DKaHvqZQk+9XfwL/sVy5zxMvvaCaIzr6n5LUY1dk9Y
	kJeA+54s3T07VcJnPjHZSTVWyvsdw=
X-Received: by 2002:a05:600c:5487:b0:475:de68:3c28 with SMTP id 5b1f17b1804b1-47717def760mr1347225e9.8.1761579841631;
        Mon, 27 Oct 2025 08:44:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiDtRwUHjEVIAY8aM164h+qxfVydqUkwRltLaXAZRqa3l9fHnulYdgUNkImXXiSGhlxa52kQ==
X-Received: by 2002:a05:600c:5487:b0:475:de68:3c28 with SMTP id 5b1f17b1804b1-47717def760mr1346995e9.8.1761579841208;
        Mon, 27 Oct 2025 08:44:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475ddcfd598sm70070705e9.3.2025.10.27.08.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 08:44:00 -0700 (PDT)
Message-ID: <608c8166-b6c4-4187-abc4-9e1f0d31f107@redhat.com>
Date: Mon, 27 Oct 2025 16:43:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] mm: Use folio_next_pos()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20251024170822.1427218-1-willy@infradead.org>
 <20251024170822.1427218-11-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024170822.1427218-11-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BThQalqyJOL3CITUvOk9p0rGJJJiztCv13FJbcRLLfk_1761579842
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFF5B40005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gf6coezxii3bjbrxbqq49fh1kpjj645s
X-HE-Tag: 1761579844-521700
X-HE-Meta: U2FsdGVkX1+5n9AD5uewRaph4anytnmSkEOqkTr/Vib2rRgAISYykgS9bsnK9RneZpb0/tdQEfG0AgYDpZRQDZ0b+BzWgjzt55vpK79rz7CANt3kkUbpMWHzSy5jd6BET7ItL8St231oMUnC163BcMP1m9Us25Ge6/H0MS373U2QzmKyCvCP7Mge16dVjZWPkMjoJuaFTW2s+ZKciL5nqdO+x4bxtvUqJ8IRedEl6VzBo4nYt6OjwdHmtcJeyTubkBc5y6L+7mFmLVfIjRxJmvDEoAYhXM3KdvPG1GFhnfnwd7oRIEJvw0ZpxG9j1+enfqfNGTdx23e63hIl57iFGz3fjrdsnN/6RLY/S0SHuH3tKA4fXfByboc/hDOl10EBSg6RFgBLRvzlVl990UusbEgBgtlg/h8T2F6ZTfGnB3C8qVXD6CzlGVAkOCRfwAU/3GNQ70NI82P6jScvFn1XPVqcavZIHpK3S5f5q4Ri+0iEQXnvXBx32oN7mQM2tUOc0VKtrZPJn8IUxKRhbK0qRiz1NSvNnCOAWXEDOzrKt3Y0/pxvfOtF0FHKt/mNgUZApqQq42XeLknHnnLCXBdnLCudF3cgFC84eluOy4jPkd9AGqZxu+GLQNs1lJtoZgf4ZfauOQy0Vyo3InO9DB0ce5w3PGzuJRitzlq3yWpZAuc7ecPIovtYLdpNMjaJhvPq6ATiI71LGHwf4+VNePrHYlto4HD0WzjlEKnfufjnQnYasSMb3LCnBzjN2nv+lCq4pDDl7e8NrxENiODaGryXVa3/qZgRKYAt8axB1b4Tvr54QwwUVbqExw39oKiGGeqHfi5lzyS+2SZNaxmPpWs/o5ou5rdrbkHG3rOAnCHFicZC2wu+Cm2ncD6N4kYibtP1V5oQFETXcAZCv1JTIY5Ady7oVXu0XLzbYpvUlYqEI1luG/qH4vOmw8+uNR+Uc7ZxCWBNbDd9FLHBFKBotKm
 iSbOVllq
 lx+cMUQSnp2NDuC//9RoU2Y0DXk5siNs/59R14TwW4mOPVnYgzwrSKb9zaIA/N7HQd573OZlZkBBCa5u8eP12IEqBeOCmqwr4onO7jYdv7D58dlKX0GZeMZwlE99/6dXonsId7t7LhczLAuCKLrzHX+joYrrEJFufC971HT52o0LSyQvzapE27DWjIXQwm2X6yQNWmfEX8k9T7crf6vrg9HsnoMkQ++/Wx5r5e9qSDjAwubGJL6MUP3LFTDlnKdoysMjCvsF6jgqgCsbLjSR8AvIy1G3EZdlWaiaVmIaVI0hGbVUuAmcsGxL19Q3gglohodILK7s9citr1hRs4W2hbSK09bDMPSu3QBuXL0rcUYDTN/ReBfuzQQ8pZqM/FwL0GkDlDJ0ZN18KNZ7d6hS+3W2PH9vyumcgfdCC78dxehz4HnH2qu0qv9ApiYNoGRPME775UR7FipNJBfSLvSvVQjiamKdqlEjrVk9CZdCKfusCjogT+6sxtwfQy4lJBeZ7WS/8FlEiaLzbcCDQcRRSj0adFlxkG/NpudBQtTHcxnRcMhcGhegiS8ySmoNBOT8R6uMRaLppNOGVT/Lac/FQyz+h5vQU/0PMFD6+spSe2xr01p+k7FFF9+MkfWazsWX97GKHvZtwfnDTM0JLLpMzChQJ9sAZCaxiKSuyX6W3b5QN+Z443YIK9glIdDH6L2xPWIMXcnMtYMKvadXEi/FoAC5HwbdxGLw2A7mgVa27+BT3HCh7fQ9DTahAan6bv+HRZVB02uIV2mu+qtT55y6DPfBzl+zMxpWu/9265OSN5VsAuA5e/h1MtuqoUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 19:08, Matthew Wilcox (Oracle) wrote:
> This is one instruction more efficient than open-coding folio_pos() +
> folio_size().  It's the equivalent of (x + y) << z rather than
> x << z + y << z.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


