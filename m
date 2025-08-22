Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C937FCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F348E0091; Fri, 22 Aug 2025 05:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B82B8E008C; Fri, 22 Aug 2025 05:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99E08E0091; Fri, 22 Aug 2025 05:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D70AC8E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB69FC06DA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:19 +0000 (UTC)
X-FDA: 83803917918.14.D9EEE33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2970540009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c4236KsY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faN63CP6wzr0s80Apq5XGXLJE/MDjDQFzV5+gvCjSzQ=;
	b=iBvJHwZLK1T69PcGHRNoK+5FWI5Zxtuzy0Cp38+AYp95YtSEkp8vW/ZR2EuyKhQQMoo4i0
	ApJWuJhWIHdDeJGnrbLAyNhlAR8RVGU7XyJo5pr/ZhnB6mp19qmD+y5HcYrdU0/2UMNCTK
	A0EykgvVNqi4Hnx5f3R75MsyHuE2gvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856097; a=rsa-sha256;
	cv=none;
	b=ZOykXsugS6yRP3s7auFd0NmnE8lTvioch1jy0Sirq8VOZHqiJfATMtq9X3xeoLiwoQSZ/z
	tw5yUVKipqchPzIgU8PWJIg0qA3gDYxIxVUmhdbdFfIqskrSZejpgI1PdbVoIJCsA3Eo00
	8ST5rvcnTtt3ZWY53l/IYhWNAsEsqQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c4236KsY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755856096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=faN63CP6wzr0s80Apq5XGXLJE/MDjDQFzV5+gvCjSzQ=;
	b=c4236KsYl6GjdkHZozuPM1x2fVFA4aVtsYW6GtfgVlodA/mBQs+jejOTo9WiHvfC87OWky
	mL4c1hVeMVcJDUNBV7BcrXGCHIN0ip6tYMINOkrRXnRs6Idr7oS6wl3MYhwQbUbfBqLiRX
	yZ0TMUoW7S1uuAkZaN9LqfKYx2Z3yRw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-EEHUAvMQOzqqcDJr2oroNQ-1; Fri, 22 Aug 2025 05:48:14 -0400
X-MC-Unique: EEHUAvMQOzqqcDJr2oroNQ-1
X-Mimecast-MFC-AGG-ID: EEHUAvMQOzqqcDJr2oroNQ_1755856092
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so928254f8f.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755856092; x=1756460892;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=faN63CP6wzr0s80Apq5XGXLJE/MDjDQFzV5+gvCjSzQ=;
        b=qIoQ4RPU3gNLaQ7LFuDclxqy9TkxbRJv5ao+KB0C0zl6K+yH0qG0GwwVryTPfbtDLh
         SmgQs0SztT5LckXlCACiZkKVvLDBQJWJShbnmZKZs3diCAV6jFHR5mN6JANCxAa7ToLh
         TF6eutI2TCuQA+cOBJ61g1mCXg1h1DYXxf3KTSF+VYzmdNa4yxG1lpDQrUwN+7HPwiWU
         8LC4J8hOxHzgwUOMSNXY3aIWXFmhfL7xrZqxPYDTXLxFROZOnMVGQIPRE3Kz1pgmq3vq
         aAVkPoPhU3akz+0kCYEVOJ8vtGJxiasD7z02g15n7YFq3DBNIcfK/5lA9Gx/wzGUWH9H
         9eaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF/WlwB8pUXlV08swsD/gzK2qEJUDEmwQeo5lHxnKmGwA9pe3Dr8iGnKEJdERJeP2cxklKPWq2EQ==@kvack.org
X-Gm-Message-State: AOJu0YxfmBL7AXL1kn0oWtBjLQdSsB5NQ7VYBmcZGqcu0amsfczU0yu1
	rxsmLyuN/as0DMUZgA7nYTlHTsIC18Re+cNHh/yuYHYQXkDCdqJbV/lotr/+0ZfRVlXmf3hElQ4
	1ut3LjUg0Wfi6FPBBIqi8UZ9S6yhy06A5GvQicbkES9dQTk0Dr5iF
X-Gm-Gg: ASbGncsp5vEuv9gzz8X8LpQbaOhhYwd3ZoN5oEblkq+LpuHa2dZOxF1PhpESbN2vMy/
	cRWvXJ8pNHjPJ0vIseePC1hWTHKcnluiR+fv5+Vm4l+Yh4w4MvUp0ZnhsbcjKln42Ht6ZJKzVWg
	M2KAbXV30WDg/Zw16YxXIA+5ZVwE/2DO4eTeres1OFciAwbrSG8294Z16DwsyKbP6n+NIxbi5lI
	90BZb5uWDAtjBGq0cmFTIS72SPcBPdIPN/rsdVmEiUHBAsOHWghD7Fjv7y8gre4jycfIoZ4wmMe
	PNLc0t+DnPAvXc4QExAXhBbwJGayEoc6fse0PKsrThFGRL0oeP3KTXsVIF2r5E1L79tvEN0yfkP
	0y666vnfp15+8hEc/kb5hqXpwV7om+nSPxZL2g8UWjtmgAab+yFEC+LsCItsl0L1Y3u8=
X-Received: by 2002:a5d:64cf:0:b0:3a4:f663:acb9 with SMTP id ffacd0b85a97d-3c5daa27b91mr1221709f8f.9.1755856092047;
        Fri, 22 Aug 2025 02:48:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsdAE6BVKMKTQokf2HQDERhev26tuT34FaU+oJmXccUoKh510aswQcMHluDCuMsd6oXjJUWw==
X-Received: by 2002:a5d:64cf:0:b0:3a4:f663:acb9 with SMTP id ffacd0b85a97d-3c5daa27b91mr1221683f8f.9.1755856091630;
        Fri, 22 Aug 2025 02:48:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b51b61256sm24247305e9.3.2025.08.22.02.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 02:48:11 -0700 (PDT)
Message-ID: <83724cb3-4cd5-4a5c-9a85-c61bf3553195@redhat.com>
Date: Fri, 22 Aug 2025 11:48:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/base/node: Handle error properly in
 register_one_node()
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Yury Norov <yury.norov@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20250822084845.19219-1-donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822084845.19219-1-donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V8E2N2T_zs_jOGOyyBetZvP8uwGJzxwS2pda0kWlz-w_1755856092
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2970540009
X-Stat-Signature: bspcxtxjwpkeafx4a94n7s5iunuf6rng
X-Rspam-User: 
X-HE-Tag: 1755856097-479569
X-HE-Meta: U2FsdGVkX1/lvmwbd2mafeo/DekkWn9nLUA8vU4ArI4QXI4DwagAsUWQrhR10nwc4H6DkMRBPh2Ouh71PeJke+O6qKSSwafIhWe+6oraY8o8egJwk4skx7X4a35sEkQWjgNTXZwjKMQUjB/aSklToe/OhgPRqFciVovQCjKp1ecB8DUxpy/rh8CuRiFeJeZ93ZXoS4sZ/SnDaETDgHyawS0yzI7XyTa/C2X6Jy+ZF9JMi/4afk5IWIdsN6kdyLYO0reZ+c7tNjMl9Bvhq3qeOHvYacQOJpDvRIsH3Rzq28q5PLxs37OuruU8WuRNJl5rZDotA44vPi/Q7yCrZH1/kMTawUEP59hHBEVM1zssackWfvMNgQKDQ+aANGPqPxJasHKwKXvxN1xdfz+XsKro1w3KzpNs4la4xolttxW73NtCO0QVl9rcLGS8q3ne+MG6F0spV/9XNkf2b1B/v3rwesuIGp56Ev5y4qQKaqxp1vtqA5UonZNJdGlylkuLxmE5/y9UwSforRnMYARcu/o1ESmLYNKuCPBdk2MFowiI9OXBHrpU5ZMygPcql68WFc21+4fPaLAIUaX+KaRiHH6DqTvQYQamEQ+dQaMzUC0R5RTiQ8hz7pMiRR6fSDiZ5240e8RiIw+rUyhBfw6KEZroU2UY1j+A94DeGS/zJhQdqmZjBml1fRMxyU90zH0zuqUsIP5R/hS/XmTC7rumdVtqbbZWRNEdoW8Mk+rG3fzIWQ3m1UKgtkHTm86ZdB7bSVGxZlCVAgPx82xjuYPbyXiC3+o+Tg0WRQr7L0fL+HObeD0i5P7vcmO9OvoInAnsm3pwutcW1bosHG5AIIStCOYDlufZ0Zx14hu0bCM9eJvGIOtQ84gnhY1V31bXqjveosP89vOmuizK4/WZs67p58cdXul6aubV5rPrAQE+ldyRzUqyO8oQFcfN4/WTsAhPoto2B7CfKJrKDfhpgImq4lq
 FHgPgrkV
 zqHtsi3WZ2exNJxdYUfvnIVZGEHaqhl1gfOyU1jAC14bLVT7XEORm5pDew/+yEophx3s82rRFz11Ml4M92RItJHDOwpysgMON/U6+G97de+gcP0OWDEIvJdZLmsWo36uCN5hiSlvcAswmY+9ql782SzAI8kwCBIhHkkh+XWNv82lOiYqJCT3RjF5sPFZXt6wdmGCRXC20n/BOx30mSeg1nvxH8GCXUvqoW/J7GOhIaEPcDLxGRI9aEz43/RYPzwTnOKjIyjPZE9NYNyxkF7OS/u0Yxu7DoL3aQsaYRI8QuZ1LtH4tZyc1TODPb+YdTtIlp88GHCmR9lDv/mCZDhefuShJc9DpgETrRcrHl9Xxy0Shtha2borprQhRBvM9467mGGSxxvoZER1aNNSWfYkY/vymt4bDxXraKw5lYCKdEgEhBjr+zxHWOXeYaRATnGBQo6iqM7+YaxYbUyJc1WqaYJK7QFwn5RGvdofkmXOX9SsoGXYLnSPadn+daIOnizlvjB2rGM6R+VgYH24xnU8VsHv969DEkg4Z3OK2bgwrlz/b6UW0XyUPSS0m8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 10:48, Donet Tom wrote:
> If register_node() returns an error, it is not handled correctly.
> The function will proceed further and try to register CPUs under the
> node, which is not correct.
> 
> So, in this patch, if register_node() returns an error, we return
> immediately from the function.
> 
> Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node struct")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


