Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C994CCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9FA8E000E; Tue,  2 Sep 2025 09:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1848E0002; Tue,  2 Sep 2025 09:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7D38E000E; Tue,  2 Sep 2025 09:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFBC58E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:33:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8286BC0114
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:33:29 +0000 (UTC)
X-FDA: 83844402138.22.8A17AB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31232100006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:33:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqT2HJBm;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756820007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYYSmug/4nfDKtRuGU73yXX5tjcKnPDQSahXNdfE4Ko=;
	b=MrERQQHXCMDKTonFXLW/o3cL96zhnK2A58Wze4tQrsI0BJEncT5W1WWRM3qoa8VyLt20cF
	Cwz7PVvgjPFz7xdJ0purkeoJ5pQYbh86YwsqLKo+bxkvlzaSxVs2s7B//Z3hm4zRu1/rAk
	ypa1M72DGCJ7C1bTacCuT2EieP8ltLo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqT2HJBm;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756820007; a=rsa-sha256;
	cv=none;
	b=ctuaCXpicsCnIIt0Um5Do2WIKRwxu6OYOTSu129NCmNeYPknQznd05ZxI6cnMyoxwJZp6b
	/6lKu18qvdlO9KiGWt7jKmZDHABpg/0xqdlwonvkWFXgdCYtgdKBvt8ACkgdgJfFhK7tGK
	rV6+H25I2GfL1+uBzeGLirxxFIOWX3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756820006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tYYSmug/4nfDKtRuGU73yXX5tjcKnPDQSahXNdfE4Ko=;
	b=eqT2HJBm1nHkM7gIE/sYBoFM/OUdTqI5HEtQRTBlKTnTS09AkhUw5t2R23khkN/R+zZsu2
	GmNSJUQphimgiNTDLKNwYemDA5qD1zcLANN7/ysdyTpSD3AHCpiLrkhNw/ITs/lCh+IixG
	p8DiPxn9ixHaOuT/N0/7c8Z8augti3g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-Ftxwq_xPMuS-NSM-hpAdbg-1; Tue, 02 Sep 2025 09:33:25 -0400
X-MC-Unique: Ftxwq_xPMuS-NSM-hpAdbg-1
X-Mimecast-MFC-AGG-ID: Ftxwq_xPMuS-NSM-hpAdbg_1756820004
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b883aa405so21388835e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756820004; x=1757424804;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tYYSmug/4nfDKtRuGU73yXX5tjcKnPDQSahXNdfE4Ko=;
        b=UNSXiRLryVEw/DEEoEm+OtRRLLs2bhuP72S14JVZMEBTG4YXHdtucL9THxyz4vK+Eb
         NWM8tGgsHOU9dfgueuYfluFbP/++DPIpim/PVZOKoN7Eus6JuvqDRiqMu2w+Iyp/7YQw
         RRJ/LPChQW1e3j22Jr6RXtyFbnB7KTQHajfD8ia2h8jMcqgmn2tKqxiZQcuUPl/GAylB
         49gE0jGSv883keQA0G6p02zZOy+9JXEc3aJzx4J8MdMs3cIuQlODobak/DwBq+0TPL8l
         HrozE9B2izr7uqEUdLOMmhZY0PKvCU9schBR88FLF8mV1YYV3a0LcFKby+vBCC2d9AYq
         yogA==
X-Forwarded-Encrypted: i=1; AJvYcCWVUHiSaUTMGUVAwgM9YanjZJh7JdQJLjs3Ih8jAv2k53UoXaGRK2JbHUqq2jafwqMQn7zFtTFFXA==@kvack.org
X-Gm-Message-State: AOJu0YzlPGuUXbp/uWdmvdf94YBhlcb/wQC0Tbpby4c2MGzJwAd3nATi
	gHNozBqZShc5z/qziy5RZpUbIIBnHL5dMW5fsT9lBxj8IPaMMwRZ1N8uRSg6bFDKvsbr4emXRQP
	KjuDCrfnDv6we/bJZ0AbFthBV2r/OCwgt9exvnGZWDNBsc/p7X1HL
X-Gm-Gg: ASbGncsh0SfCAIMNftrc/hlwz34aP5TmTEw0cvtVvboofqsWf6a7pkVZVSgpSiDHAEq
	1NFY/0g45Kg0Bwtv0V4U9sUB1kY+aG+vBMwdFrz6EJJXrhor4JEWsOHnEtIDBArGEiNKaVyuDe3
	9sZ1CUB7WkusRI8ucxqTo05FwrTeJ63BPlwtW9wsHKZakzBWMvWEccH1+p9nxjUfnG+qmiCEkZi
	C39IhfnP69PxpkZPgYU+wb4gnkBNYlGW5jklJkkM8qe2a1/6HAQDAjCj1AuA+oZkvl8rOns4KMI
	Z+UXvEUXONXzJKDq7wiOgIdB+LLovFTHjaWzx1nK452Cea9oWaHmCbOr22V04ENY884wArkkIQy
	LkVmWSxI/sEWYmOEKqMOqbn1Z0dNkX7jCuBIoJpLN/c2NrnYPsYXlGulAWMkbqBJ4e38=
X-Received: by 2002:a05:600c:c1c8:10b0:456:1156:e5f5 with SMTP id 5b1f17b1804b1-45b85e42eebmr69024245e9.31.1756820004186;
        Tue, 02 Sep 2025 06:33:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGMJFAosuw8WDJkQ6aeFhwj8Lu711vhxmhqMDvwp8Dw/LQmdpI2HzCUGWe0+3fI8VcSyWZmw==
X-Received: by 2002:a05:600c:c1c8:10b0:456:1156:e5f5 with SMTP id 5b1f17b1804b1-45b85e42eebmr69023895e9.31.1756820003558;
        Tue, 02 Sep 2025 06:33:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6db6sm298998095e9.2.2025.09.02.06.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 06:33:23 -0700 (PDT)
Message-ID: <39087ce8-6f6a-4998-95e4-813e265318d0@redhat.com>
Date: Tue, 2 Sep 2025 15:33:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info
 helpers
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-5-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-5-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BUYq-GcdWuWPYSlMGuEe1-KJ8TgR7J40mvY0wlIWxiM_1756820004
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31232100006
X-Rspam-User: 
X-Stat-Signature: dbsmtt5ki88haz5k45rsepuo4hepptx1
X-Rspamd-Server: rspam09
X-HE-Tag: 1756820007-335173
X-HE-Meta: U2FsdGVkX198LSkMfksyYZyNdLHemP3RxhtIMkG8mGkjj456b0GvvqHOfMbthjUb6t7CR3t2+cP2R2/L6kGTkbWtFwCN9Lk/t8do6hWBX0LAzY0PggRfj1/vUOiybsUp178unf+WsLP3RfxYqUmD3/vOOQg+HZmYwARuU993aMS3w5rZD1+dcWVogfVpBScuAuBtSB4R2ECJoWCzLgqIkvHf3LQEvMofcB/Fgr29kdB6EwT5X2BZQDTC1ZX3y5nWGNSM8x/iAvrTIJS2HMky3kbcl7Sde1TgWzZOtFrw/YJ+zZT2ZoB1mE4P0e2R3ndBRIllmPjHi8SjGanIZbJwcdkvezbOaVGBWoDlJ42lMyQN6XvFuYXYTuTCbBXutAhbUmmNsaIGFNy9AWTQiYdKVPixChxGBEppj4GN8DyPgiPSlNlUWwQNS8vvSANAJqQeWfEW53Q7MPt+M5VzxDkAQIKhCkdEWHvKfGGVG867NUHbS2hHQCnq5ZdGvGnv9OsfQqxQIppmOSZA4LHFUEC8n8Gm1+JuTDDZJGM2jSzDNJGX63yfZCY9yQaW7euTeMFGhqT7I5/yu2BEiKw7TWzjCHa9taWwVEJ81mlweSl3S72Bj75LIJPq0wipoZK8HvnrElubesWeWQ0cumVR7FNHDKGp79yZzHq5DukF7jUkTw/EciqMUtfs3Sh/xo2la0KZlagP3xQ5uBWVt31/ZatTfG/IGAY6WXtHnGJIZ7ZjitsuhqzENYwS89qFjT25WRgeqGKkMi2c5vH9Ox2f9KBu6C6irLq/kG2GvLVmWWR66ykWnUWEE4HeVZQ4gbZGdX+8TvjnZyCLV8AH9UC+NJN8XhTkMb3kbxA0PvppR1KUoeK82rkiIDw0AR3ILsf4s0lqxRkGXsITj10AFfslwKvjg4hOTfEL57jPFkYXLJRiu21K+9UIDG3+Z5W627IZXLJu12usKyCUvOwT/JzK8UF
 MudBGF7R
 4KnDwIgyy02lph7ttqY7B096q82R2AX5nrTYYAbMfzlvpME2SPWcy0nQQLTfOO6DdrqJaxq6klGKIeljGeE3nsQ9uOm0P5otK8lM8WH4Do9aH/fjq7cClRfjeIBCRVEXG6PifjpuOpvCfheSDo3Gp5cPbvVHnpWiV/vDoC9ZQQxLC3I7cThCnatkOdVMy4cUW6FUzETQBB0EVJVtiRTXJj9NHscWfjeEvtPRh9oc8r4ELGBM8aZ22QhNk5vGMjJ2qfqvH5wO0qoOKzFyXr9dN3/emiqIrwzzNEtYYOBjRQHBlrni5m60eiVWkIJdyMXFGs3wT3+fDsPxUC2DAvnY+QScE6BW3dV9FZb6zND0Xhj1N/shVLFyfPQmXaUCNGft07SH7zrUq/HSEhCt4Ij08wnC+vcGn0Ce+uQvajXOEeibBtsXQwjQwXlLKYskKJyIFiTa2tGQygBqcU38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 21:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> swp_swap_info is the most commonly used helper for retrieving swap info.
> It has an internal check that may lead to a NULL return value, but
> almost none of its caller checks the return value, making the internal
> check pointless. In fact, most of these callers already ensured the
> entry is valid and never expect a NULL value.
> 
> Tidy this up and shorten the name.

Shorter != better. But yes, "swp_swap" was a mess.

> If the caller can make sure the
> swap entry/type is valid and the device is pinned, use the new introduced
> swp_info/swp_type_info instead. They have more debug sanity checks and
> lower overhead as they are inlined.
> 
> Callers that may expect a NULL value should use
> swp_get_info/swp_type_get_info instead.

High-level comments:

1) I hate the "swp" vs. "swap". Is that a valuable distinction or could 
we just convert it to "swap" as we touch it?

You're converting swap_type_to_swap_info() to swp_type_to_swap_info(), 
and I am not sure if that is the right direction :)


2) Can we just call it "swap_entry" when we work on a swap entry and 
"swap_type" when we work on a swap type in the function name?

swp_info() is a rather bad function name.


3) I am not sure about "to" -> "get". "to" is much more readable in that 
context and consistent.


4) swp_info[] vs. swap_info() gah.


I would just have done:

swap_type_to_info(int type)
__swap_type_to_info(int type)
swap_entry_to_info(swp_entry_t entry)
__swap_entry_to_info(swp_entry_t entry)

__ are the expert functions where we don't expect NULL.

-- 
Cheers

David / dhildenb


