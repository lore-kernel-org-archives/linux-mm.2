Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CD6CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625C48E0010; Fri, 12 Sep 2025 12:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD208E0002; Fri, 12 Sep 2025 12:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512EF8E0010; Fri, 12 Sep 2025 12:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB378E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:04:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05FD913BE0A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:04:24 +0000 (UTC)
X-FDA: 83881070448.10.20C184A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 79AB740014
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:04:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PPAOPSna;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757693061; a=rsa-sha256;
	cv=none;
	b=cKe0ADJH2lw7Plp3H2v2WwylZksv9AWcIlPqyJYDzxtdZ4lbTtYeoX2vhk5pZU40/eodJE
	yEUuzWDjhvKuNmhsyOp6oErGgXZXm+j8UzGOYRvj9g8Dyr2ppQRvr7/KxzY/7U1foR8s9W
	UJckPnPrHm0nUxyMqg9vae7+4EocEvI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PPAOPSna;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757693061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG5/AZKn+Ejtcke6z1a0vOF9JLYUSlcjriPhjMOOTD8=;
	b=bpR7ECxeWgl5AzKgZ6ee7lSxznkPL7+njTdn7ddhRN+x+i/xx2lmvi6iVw40zanG7yMrP7
	TCg8XZpZiiUgNhf92l2dx3aMsuRR4oSpelczuyvZ2Bim/w/t9hj3eei/Hn2P9obV6u9jIX
	kWr0NV7G3l23xHX3lukrliyPX6mo3tk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757693060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hG5/AZKn+Ejtcke6z1a0vOF9JLYUSlcjriPhjMOOTD8=;
	b=PPAOPSna/Vphay5ATaQYfO2jSWMemDzwZjKoOiF6GvFeAyE+AlwDHqDPaPeLGGMo+s0bYq
	FCPGUuI68xz03KZuWS/nkn9GCh5moa2gJjcE8r8/fa6zjg1KD0urcMlymMgpBJ3UpABIYW
	Ic9iMn2ZLJO44UK+fQzc4w6coB2vUN0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-cttIqos4MoSIoIXSZNEPVA-1; Fri, 12 Sep 2025 12:04:19 -0400
X-MC-Unique: cttIqos4MoSIoIXSZNEPVA-1
X-Mimecast-MFC-AGG-ID: cttIqos4MoSIoIXSZNEPVA_1757693058
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e751508f3aso1469900f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757693058; x=1758297858;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hG5/AZKn+Ejtcke6z1a0vOF9JLYUSlcjriPhjMOOTD8=;
        b=wT7qMMipu1MQ3mjzvxmxAcgDB8I8S3ymXXHs3qKhvpCxLX7YJ/goffLRPWvCb7sE2q
         pXu0MExzTezQ6P+5TWXHR5DCCsWjdhwTfkQyXnWN8odHirwhJFUnq+jVhI2OQKN61mgC
         XFF19mq3oOv22uzGsIkGmfSJhUdZh34NOFIfOa7a5XVYpZsEyXqOhkLkS2OWKYwVfq+w
         b5M+zlQWb632rRS3AhgX+AfAMgkFCO1LQ3TBwqhDELpLtzakyjAXH60GqdOQ5ehe0WFO
         QfBlRdwjyKuUW3vPMTelRckJUKIXCjdnql2m29MbWxkjKdrsoHz4hsgaoCoZHRcBSlxH
         KVIw==
X-Forwarded-Encrypted: i=1; AJvYcCXPFifnCB+7mbx91wzwBaXvEqn4Fk1gC+ap3KqZhZE5JhHcyXSuL5xqbQQIYK0f45ve9JUEJpnIYA==@kvack.org
X-Gm-Message-State: AOJu0YxoblvJh7OVzB30DMXZzz7X+M4lYAldGy1PrwTdIiIEeZ4xdXvd
	bFuU6Doa+yK5mBLSn1pCYGedtsVjHicShFpF4vfGdo+4Ta0PVhYXe+axhKjI2P3fLYeFntQHgsU
	POJmNRcDypRDIe7k3l5mzPl68PPHIS1CwqjKa821LBL7nO52rJ9w/9pfes4IC
X-Gm-Gg: ASbGnctG+puZZ2Qh1yoLj51ZETvj0Pmg1Iu5R0umj4r2lP6ADHF6atXgmV8C0bkQIoM
	14sV9IA+FYPc7CHkdTqwfHgfXFdmsx6mJxm4r11DjHrEc/WfX18gu7kIsgBMGuX37OD1eM689Kc
	N98sLyQfL8aP0ZH6gC9PSs+U3tamRMy5rJARm4JW/1j5muolo+DETLeTCj15+u+THnVU86oPkVN
	ormc+Lp/squ6Vv84MeYxE4SDvDYEkp4PJDuHK5CcBQdDSZ/xukh9XNvWrbUHM9Zfl0lVJXbNjSw
	dYTBiNhWdQWkkSjgVg3FQoWePPc9KiwBVK/EOW41r3aKpEEJiE9nZ5ELnJV+2q0UwULAWCQ1/Rv
	dTs5RzdtCboZTQLZUELu7QFcm0ds2btXpUUKNfyLkQIxBvO6V/Y/Q5Ojj3Dn9EsyIF4Q=
X-Received: by 2002:a5d:588a:0:b0:3e2:b2f0:6e48 with SMTP id ffacd0b85a97d-3e7657830c7mr3389209f8f.1.1757693058043;
        Fri, 12 Sep 2025 09:04:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmTJGEBJ8Yi7y/CDniv/Cb2vtmWE7VSCvpdTGEnByD3ykpr0oRoFqb+KeFU7uief7Vv0aunw==
X-Received: by 2002:a5d:588a:0:b0:3e2:b2f0:6e48 with SMTP id ffacd0b85a97d-3e7657830c7mr3389149f8f.1.1757693057182;
        Fri, 12 Sep 2025 09:04:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7d9844d24sm1148099f8f.46.2025.09.12.09.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 09:04:16 -0700 (PDT)
Message-ID: <5617a501-3f46-423e-b3da-98efcd63d7c7@redhat.com>
Date: Fri, 12 Sep 2025 18:04:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-6-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910160833.3464-6-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Phq4CCNS3IT6svJ9xpMomGN8FgHvC3NulC0upd3RNN4_1757693058
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79AB740014
X-Stat-Signature: 46s1zkjh1bfyru5wk7zaei7psu4scua4
X-Rspam-User: 
X-HE-Tag: 1757693061-368206
X-HE-Meta: U2FsdGVkX1+rT0l3c+Hcr3v8oxL7fwD+ECIZKujUkT9qfAtykh30NntZc2EOZIF+yn5VvjdrlLd0sznDJLVcjUC2dytb9HOiqWcHXsg7t1f94x+Pm9fJa9iSRNNqv8yNM/dOI2SK3tSx21RYog5rXhXEVZHMN4H6Qns3hzBkacM6+AxH/x5hFnn4BfnLBUtn87VA1lSmdHa1pwfiS3jms6rGmEXUxArLUTKiEyfGPRakqPCYLk4+lFmCcr4g/p4LnfMFNJGAV/bTCS8Enayq9PHPkVTCjpw5k44OdgA+aKtuD/7GcDuNmkREaVFLn6MnfqdGlfyFrLgNHXn+YMxxFyeUCvi8yyH5ASPSY7QQ0IXjUL5Im9BPoRPRF/FWFpy3qZ9YPpG4KFMWNgtqeSMRpCidPptdQ9UiULsSZqXM5gwBh0DJvBdz+fI7Vjc47T2U/meAmxRD5praGXEyM9Z07KY/cv4BHiZSv5yaKX4mhetxkrXF6/cpRHb6JYfyFJnlOjTe+bnes44tQf2wLvWdDSp03fHzbJYx9qumV9z9ayXvK62I2RdIUyUzUnM4usfJxylpkDooTl351xQaUC0Xd2YnZmeXViVWR8onFn/QPz/j83MFhNILRVOqGlyWhzAXmzQ54PNe0AyYCGFgmz30/p1U/vjuDcdnaB9Gf1Iv/VPISMPVSC+QAYunu7jEHwucVZRGON4mxo+Y8BnR5AqCU9NNWhMpPY2g6/5oaM9cbQ5K3eHVV6Adx6lffBo5OerdvecKprMFdRdDdK33g5q5GiW6rpp5nKjnDtAOtfNT3K58jpKhV98dnmeqkAV+qkKVgyH/aSjanVTxWQquttRfxS9ZBlvABpVRCSwjsIFp0dYrYDdskbCBGOzaJi1JyhY8YqqsheMEhkmfSQ2JBg3qOAvxYGe6Q142/u5BJ1lZSwGBnh6xZLRbwomwzPagDH5olwIObYik2tmIj8AGEGx
 51LPPF8U
 Hvscn1s1eY4WXcJ06syIKsouGBvf3JiWBJ2BiGSauZQqTOLD7a1wY7/jAqPHE1Rpy1oB6pFLqMu2hCZI3W1vjRFjwMDDf0U69t9nOCe0CtKCfwYKMj9MsyUU5udkZUzhRDgOdzTAC2v1gfvlNFZz6DQ3H0PxgOvi7jkVxmTzPc4Kr1W1mWCPY3LOvvv1L50J1ZakfVmt+WIeGI//FHHRf/a7bi+OtLax2L0Pc0A64M9zYXcvR/9abpW44xCt+SeGt4TkP98Qa5MVhBVsSmTqltKgt9czY3X4AkAJv0k2NC7FKrtJ/u5up3PH1bd8CbCfIZ9HYjZkWGFwqq+XwYd/EGto2cMwtrKrALogBhT56qSGLJy21ysgk74P+6/doSaqqc/7wG4vbVcwj1DFEyo2C0/pihhriCqrLdeCX9D6sB3ra0Wj23BvNTwgfoIcS8KeeRJId
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 18:08, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Swap cache lookup only increases the reference count of the returned
> folio. That's not enough to ensure a folio is stable in the swap
> cache, so the folio could be removed from the swap cache at any
> time. The caller should always lock and check the folio before using it.
> 
> We have just documented this in kerneldoc, now introduce a helper for swap
> cache folio verification with proper sanity checks.
> 
> Also, sanitize a few current users to use this convention and the new
> helper for easier debugging. They were not having observable problems
> yet, only trivial issues like wasted CPU cycles on swapoff or
> reclaiming. They would fail in some other way, but it is still better to
> always follow this convention to make things robust and make later
> commits easier to do.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

> index 4baebd8b48f4..f1a4d381d719 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,14 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>   	 * Offset could point to the middle of a large folio, or folio
>   	 * may no longer point to the expected offset before it's locked.
>   	 */
> -	if (offset < swp_offset(folio->swap) ||
> -	    offset >= swp_offset(folio->swap) + nr_pages) {
> +	if (!folio_matches_swap_entry(folio, entry)) {
>   		folio_unlock(folio);
>   		folio_put(folio);
>   		goto again;
>   	}
>   	offset = swp_offset(folio->swap);
> -

Nit: unrelated change.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


