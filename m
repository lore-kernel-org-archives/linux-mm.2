Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3505DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D8E8E0016; Wed,  5 Nov 2025 12:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914FF8E0002; Wed,  5 Nov 2025 12:52:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B7B8E0016; Wed,  5 Nov 2025 12:52:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8D68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:52:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D4E01A0451
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:52:36 +0000 (UTC)
X-FDA: 84077298312.16.BA10EB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF5F140013
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:52:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I7x/d/Dp";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762365153; a=rsa-sha256;
	cv=none;
	b=7stuicYM80J/adpAIO+U7NdSAA5OYFUWt8MIh55VZzmrfe8tNn5ylhvv4C53BvZWOT2a/8
	zsckO0Yq3b+Hd23XryxNGht0Q2UjdKd9zK62KnCjvd5hSoEM7tKvYFnw0ouOW/3j7H2I7g
	/J8l1/ZlVVCybGAf8k3s6G/VxHopBDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I7x/d/Dp";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762365153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/VwlemY7chU8yuS08ctMQeHC/LeJ5gQNjv4ZI2xH84=;
	b=M0RuyMGKYBaazsYHCXAehdPvJeY/AHagIfojRSByZ9srjKu5SfP1a7epXGVR8/XimLEaey
	lV7gu8QZKT8UYLcz3xcqSSCKMWpuRtVg0PnkrSqqhoeiPbvk3O7oYXCNbOHb4hcPl2MV1m
	3ZyyeCxyfEpaiEN4+Mo1T5NPPS45zDw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762365153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/VwlemY7chU8yuS08ctMQeHC/LeJ5gQNjv4ZI2xH84=;
	b=I7x/d/Dpcy670Ry5NHJOlKIdqEA3Ofhd4bL7KDey8+vlIevdpd8rLW2kF+g/GID7OhgB4a
	yfE8SnGaiIxxXO61dCXUNWGcgxGWpUAVF+5XjUIECokndu7R376WAs83q8k1/TETTcKK+K
	aEsXTiTbhfGPg5VGtpkK2q5Yid1NRbM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-g2iyD3GVMYqLwW89tuaIAw-1; Wed, 05 Nov 2025 12:52:31 -0500
X-MC-Unique: g2iyD3GVMYqLwW89tuaIAw-1
X-Mimecast-MFC-AGG-ID: g2iyD3GVMYqLwW89tuaIAw_1762365151
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4774836c376so415385e9.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:52:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762365150; x=1762969950;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/VwlemY7chU8yuS08ctMQeHC/LeJ5gQNjv4ZI2xH84=;
        b=iNrYh5A9w83G6mzTNUWuV6JW9CFmIOJS1S5GNeQhJ8nUgPWX4Q6rL3w7LOiTyRLJ8n
         I51E9vdb9jzS+UMbR3zFG212YhU89YS1Q26QlanufDPBi8A0RHgw2BvY22dAg/T9VHy9
         XanwvvVMEwlli9vnuMRoOLquiuNFOjZkp3zRTnS8co/Y3xEk6P314CHNqUjCYkdDT69R
         QkN51UgeaFt1mhP8e4vhCebBHSAPvLy8jYNmfnDavBl1dMKM336TypHj+Sa6zjGjAcyb
         o6LX8o9s9cfmaQlyf31n0gUfDJG4Q+zBWA7tc51XwBQTMy3llMlFT3W/hctuzvRyf6Bw
         rPrg==
X-Forwarded-Encrypted: i=1; AJvYcCXLcnFthju865nWilVR795SmtvMZEEcMJP93YpuzHnAlrDMQ2cWxkPj6KlN9okkIprjJKCtrw8pWw==@kvack.org
X-Gm-Message-State: AOJu0YxO93//Mo1AbntYVxYh7b332BNLIHmdP3AfShD4wCib3wnexKEv
	Ik/MbkfVVK0ks3+f5BOasfiFRLuefxEWb2gZDwlRLIG4I12Zz5Ci3ms1njCmeulKCJy4Y7jtRqx
	NV3smlSwVOP1WSnCW+O/dmnn6tn0kLbHrWpdmouOMP8IcMaCOtjbQ
X-Gm-Gg: ASbGncvMFJdCV6XAuKIrZPeQy7102i5Gnf2tjLiT1G04XSDIRIxJ7dTZxCCH1od7nBM
	7Q3cw/3toD9qpthqABMZqubiBvQgsYZRjMx+rQaUx7qd2rT24OWg57k9NFURzR1NtMazJ5c4FD3
	tX1U+emq/iDmC6H4s/OOea+g1it9CSWI7IzC7Aprafz/ol+f/QhNMW6vpxsmzAIB+xAIR6FLdHU
	ekraDiL6bAGWW5mWUGbBERl9sTb2V1CfSaun9kVkWiuCQkR0W1aU26rviEoLdvwE9nbdc965M3b
	SDrv4GLFzG/JPzrL0D1wrTfnJrGCfb4vvXr3gGGeN3lUA7ksV6EboTIhoBKpck9cwRlk53PGW5Z
	cnPRTBJkPvieaqMldk3lD2HBVxrEDNex6xa/vZ3nN9LFcsdDryiDlcGswC4lcR9YQQC4NWDFgHy
	Jjhu1+ViSks6mtCt737A+L2SM=
X-Received: by 2002:a05:600c:5403:b0:477:3543:3a3b with SMTP id 5b1f17b1804b1-4775cdad69fmr37489685e9.6.1762365150532;
        Wed, 05 Nov 2025 09:52:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/hxcE6W/i4TxLbbTb+RXUoGbnNDf+haHkh+i8Ym8sAzhoEf+Xhdsyx4l4V7qg7Ksy3FgPeg==
X-Received: by 2002:a05:600c:5403:b0:477:3543:3a3b with SMTP id 5b1f17b1804b1-4775cdad69fmr37489485e9.6.1762365150157;
        Wed, 05 Nov 2025 09:52:30 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce329a4sm60618105e9.14.2025.11.05.09.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 09:52:29 -0800 (PST)
Message-ID: <db8a72d8-a6af-4a0c-b571-050403371a7a@redhat.com>
Date: Wed, 5 Nov 2025 18:52:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] ksm: replace function unmerge_ksm_pages with
 break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
 <20251105172756.167009-4-pedrodemargomes@gmail.com>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <20251105172756.167009-4-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dr3tw3_6J3cWFfvsqJSHXQouKbBDvugLkAHGqXPxtDI_1762365151
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF5F140013
X-Rspamd-Server: rspam07
X-Stat-Signature: entsf9j3f4bbrgqisdkmpwepsf3rbeo5
X-Rspam-User: 
X-HE-Tag: 1762365153-901431
X-HE-Meta: U2FsdGVkX18u2Qicah2kidSKj7IeX+gVPeMPUT7l5wPu96N+2EXyEHAr6OD2ATA+0c0I1Otqjcr2ROLmyN3KxvUhyUqslnR0gXeE99aBAgnG2FlTNaNK0q+PZZyGtaj8Tfaojcu/Q0mnONPVPlsQyELTf7d1yzzQI6F7AfV/EAceOFnP4jsYnH6IWCXWyfLNZ+ubVdWb+CP62iV94+SlCELUWqwjcJKaY/geAVTdn5unm8AKdOIYiMGXm65+Ry2yzwS37SRRG34JgInFvLfzPCu5WfbUvnbl1PUYT50bvEwuwL8BlWPYDLnOpuDgIgsjEQDphotQlfmnj0RzeODqAYbmGezWgYnDbSnj88olAdy8awtNuUFzya0jy7IijvRP3pKrRj5rqs/I8VGQ5q66/2u9iMkPMNdqHjEfgFOu1gfuNK6q7oNN7cdOxZ624JqXtxwnkmEbqE/vn6u7Mo+BaC87ugfLAI+TmAaGqsuhITo5g2/+d1w+WR4V2xlLzrsLt6mol/qUPXBwYUlKTJ8noe4Pc2N+bUFuXSdaE0BveJV8bxv6nurM7svARZlbN4/vCWOhyfEqMD7cscYMJnej8UgSJbYnTdKlGKfn03TOmuH8hJM1oO4LEF1v1y5FxTqBep6sRaqSJjgD15U8+eo86ggK5U2s1M5GPgiUOs390HW+ZUbtfSifjtDkH2Jg5OHbv1Wb47KlCBB3jpJTCFKp1l/bFs1x8X79Vb4wcx5lRMCIHnNcekmOTUd9JwiXNzozhfqEwLYi7qVB5jQiSTSQ6HJ7PxK6oD0VYUMTcKgijRp75OPM3wBb+FeDKya8e9/VtwD4QMqWN/F+AaW56HwG8sIoqlOAGjFfEV2/5LBQPQ455g+C0Hu1URcsWjhceDkSd07BjMOEE4OUxo7O+VqrVnpTTwK+3dJU73P1tzMJody2t9t1El7DZpIneWF+FqElDq8wObugMFLgXcmRyXf
 Np/z0F2I
 5fuTPbavNWDE5vnCxOJuVJPi5pBgk+JwZyfnaLEk0V4kyjZAAJ+zyXyaHMh70IQYkUvGcH0kpkeIVx6E/HHrR4JP9A8U6/1dckK6sa9QGnOpjn/23mcAerm2H36QrXDMYjp4Wu27pzYSWTwpit0Q+iy8IWonhgBqp112VGu+ggUBwneZlf/KjMXakQFeNnb3r95fJIx8qT66hLdWWjvyv3Is2/hYbE4nAqK/tbr2/PU/peem8NvmOTgLSVZaERejpjfeIp3Iu5S2MuDjhkzxVl+7AIAKi+flfRltQCmanI/BkwNC4Lw9/rPqzEp00VcldT5hS/3hwxm+EvFS7MgleeTT051h3NEKCUHpRkelnjNCY/vnfw6PYYuhQqR1llDrGCvgSkq0qV439RmcDhLplEQxZeqynh92WEKVeZLK/WjbGIMjMpusQsfER292M09JZIkVZ9GewyYmyEBtPqx9ZxSSqyfa0AM+7TwjExVpVAJ56JY8bVWLc358IKYOxpv/GTURb1dYtUIO2khgXZYCE6ReXZyLrgtke3glurz+8P4Nop6Ohq/P9hkAyi4bbLuzpHkCAV6GB82Gqw4PA7NApdtQMB7S8oBv5IpFahQzh79Y2r6aaDoenDLnioEUc7QresPhd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 18:27, Pedro Demarchi Gomes wrote:
> Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
> an address range. So replace it with break_ksm().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

(make sure to not drop these when resending)

-- 
Cheers

David


