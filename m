Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A95E6F082
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 10:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CA26B0005; Tue, 23 Dec 2025 05:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9CA6B0089; Tue, 23 Dec 2025 05:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1815D6B008A; Tue, 23 Dec 2025 05:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 089996B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:27:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F4491DFD83
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:27:56 +0000 (UTC)
X-FDA: 84250360152.21.DEDFA11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C1E4180006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:27:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LcXR/eLR";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766485674; a=rsa-sha256;
	cv=none;
	b=3RPGHBgoQVXWUCo3h8zesMwo/HwZ9ZuhE1miBa9U/KZornLD3doyeYVtdNIHQMchz4DVqH
	poeyhqrhww6NHgkvrtitmlBNdQbrE0PcNjDwanDmKly5WGlkSc/9zmbMSCKuX8yj06WbHh
	ssGWWXXNVCopWUScInhqOEo18I7qXy4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LcXR/eLR";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766485674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gW6Az7Odb7vsxG49M4eWTPA9mVwU0/De6Xv1KzqFvrI=;
	b=0nkgWWdIlMhOcpapJqMzhfOWNBV/riLfxnVABy6B7HaiIlQvCLberem3/ObycOUETCwPf/
	PL+0WjLnBeCV2UWINCuaOke5RXUgOkZc6lFHQkyKZYohujPw/xvLu6J+P+CENiF3zDCbWJ
	3Zyt4uXMoAX41PTlB1ZUBEnKxek0FU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766485673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gW6Az7Odb7vsxG49M4eWTPA9mVwU0/De6Xv1KzqFvrI=;
	b=LcXR/eLRL64RelzDt1diQcxoegmKMhOGOgbGF6O/gxCIHvA0nK+4BTf3ZdWrQFMZzPZ+L5
	92S29XyTGNlARz1TA6k1YijYmZYF8tnd/KWg+MS8lAuC2Dlq5ULOjL0PcPgjLWQZPaUUMG
	Yrp+hkraZq7bQ5M90yOc+TpaJDRNepk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-h9bpRxaENBS-vzIDX7yPFQ-1; Tue, 23 Dec 2025 05:27:50 -0500
X-MC-Unique: h9bpRxaENBS-vzIDX7yPFQ-1
X-Mimecast-MFC-AGG-ID: h9bpRxaENBS-vzIDX7yPFQ_1766485670
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47a97b785bdso35324325e9.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:27:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766485669; x=1767090469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gW6Az7Odb7vsxG49M4eWTPA9mVwU0/De6Xv1KzqFvrI=;
        b=TfFRQd+xc9le2Cy+CQQaB2MTIseYJpBxLE7x0A+7xuAhcwKbDVUQyO4Y+uBXF0/WXE
         vCXKmBgTYOWMulNvSNKkkbxjqd9mdGbvSPWphyFKkobT75fiqbvAsoza47KiUZn/cJra
         Lcrq8AyiHwSDjAQoWzpTolwDoDucSajewMqstXEhJ/2uc1qzXy3FEJqYvGsEfssK7QYX
         RtY4hZK/o5kMRHzjQZ4OKqZICj33lT4DWVT3AWdjW7IcA3LHt9T1QEbvfjMroQ3ZzEU8
         7dHzvhTi1Ff/6WitL+TVW6tgD1ZKbw71mfkaimZvm6v8XCQtvRhVrvdlWPvEHHmKm/ru
         YO5w==
X-Gm-Message-State: AOJu0Yz984QBQ1z/hvfMrUve4NaAitvzTk+i5Y+6kZj/FhPIMUcXK4lM
	bokj2bZA7oqtpw+uvkzezCfUwH7uiKSri65oBOL4kRcyG6sVMMPC/tEKMr039aFsMPH+AGpUWq3
	baqO6hIK1K7tIfhD4NTZ3VBLrH5EhraUL4JQgAtsGR02lLzJposGP
X-Gm-Gg: AY/fxX7BU2HdxaDmNasjXtussfTBC3i5BnvHGCiHh6Ghvj1ZfrZVjUs/l3Iyrhei3AB
	zEx/3ZY6IDSiLV53yJ2zjmXfXtuHUAPsN5EP99cF22jf99VeF0WOTGzl1xYMbDBfXRZ1NkM47aF
	uatnE4zhQ4M9TkSvz1G5LQRk5u94gZFUwA5LU1507/1H4duMYZCbKMhk+AG10mHtNSees+CCEDd
	Wj1DaDSky9uoCDQYd+CRa5l1eqhzbfPXjFaWlh6dU+Lxa5x2wY/JRk0b6wriHkNaKBGynhNzZRr
	cKwch4tVuWLHgrBEDwPq2SGs9kszMIDpiyP1oLa1cUwEHwOf3r+Xl3H8LU8JPIZEDAb4CTWdRYu
	gH+ibbxOgk1dJ
X-Received: by 2002:a05:600c:350b:b0:477:aed0:f403 with SMTP id 5b1f17b1804b1-47d19549a95mr128307795e9.8.1766485669537;
        Tue, 23 Dec 2025 02:27:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEo2375ubP3NGR4G/066i7ZpeEj+Z0OlHm2MPrvB8YlHkxm/CeEdo9o2skjUY6UCqpZioUlDA==
X-Received: by 2002:a05:600c:350b:b0:477:aed0:f403 with SMTP id 5b1f17b1804b1-47d19549a95mr128307235e9.8.1766485669030;
        Tue, 23 Dec 2025 02:27:49 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830f3sm26613687f8f.22.2025.12.23.02.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Dec 2025 02:27:48 -0800 (PST)
Message-ID: <a10a9239-ea4b-4a78-a5e6-d38d6ba749a9@redhat.com>
Date: Tue, 23 Dec 2025 11:27:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] finalize removing the page pool members in struct
 page
To: Byungchul Park <byungchul@sk.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20251216030314.29728-1-byungchul@sk.com>
 <776b0429-d5ae-4b00-ba83-e25f6d877c0a@suse.cz>
 <20251218001749.GA15390@system.software.com>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251218001749.GA15390@system.software.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4bGMwdpmptDPA2y0_8eplEsyEJl2tUKAMyz6EzEx2Lw_1766485670
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C1E4180006
X-Stat-Signature: 6gi9ajuw91qhm97r6gmzfyup5tnkog7z
X-Rspam-User: 
X-HE-Tag: 1766485673-709537
X-HE-Meta: U2FsdGVkX1/wSZPhiKHkiRsJpQHCYrpb9DUrJ6A0EstL62nOK3eSkPTaLD77qLZoIQvdZtcNgaYrAUXn7+udeKuBcqw3MllLMd0ZKQrDUkFfEuB2jxG4nX01Es4Ysqtx9efJ2baW3SbAjuyn1iQ56OIbXU5oFtoQiX3i11vDfPNwgX+QyPX541TQoFJt74abK1KKEMv57GZ7vUKFPQAQyjdYcPmNPAbSkn+p/r2t7PzinEi1NcCx4fP8EMaUM9UwjNtOBZMC2U4QhUf5BS56uNWbhT1mNYRx5vGXHgPOMJbR0kvnHWUU5o2eiLF0cwYqYDJS6APpL6Khf6o3LBK8yxLHwvzRoVhfVeQBdXJhQea/KMVZQIR2HMAjQ5ORJ8DALeTS/UXAxMhTVxsspNMUNZSKSfubl5FNpwr6g6Yn/ETNm8V74o2p74twBNkN2cg9qif+7mgs0gGOoOViuLdYaAGzRBUH8tsmuuRC+cVEnSqpjEYsTjVbs2xjVEBfNCH/LGkiTiMM9dJCtbacZUZXekN1nSUTFg1rqM+tlikjwxkI5Y7SoV+QLGLndyUKGCsdYLzXoPUwTyleDfcxRMAkiWnLNSR9LUlYwN8uCVdIi6cIVvS/Tq59hRnZs5py6WNJMbKS06wrR2Jqpa7twDbrcKEtw6vT/9kTtsAbeke7H26eI0dlWnrl36saSqZDcYaM3pElZxyoQaJM4DsZE4BLb9iQZc8Rtvitzf2UbAxJjJ/yWPy8/E5IC2z5gI98dLy7F/MVJ/aNWy0xjNBDDE3wI+tQMCdmJy/5WeC9YNjS/wOGyC+lFtvEy2dPDNaq56PTFXrTUjF21uklftinGegojiqwn0D3g7fh+fGQtaLOVZOI/i2+JUfclMzwNoKD1k/zsergww5wwj8nzfyP/CoF6RlcujKSHWrSPYB9j2LWGlHw5ocqNRkBPbTdJBNQwNnIZQmdUc/O0bzE0WL8o6D
 fNYxqSJa
 YS9RCFlLwyUebK5Ab1Nrmj+SxL7Ed20qjYtqWqJ6ZnK8vsC96cNfo3uxtKcd+vZKJzwtw+D4/p68an63gmcKUncy8K6u1WJ9a6oFHPk4D/8miiZl7j96N6mz69JgzU+KZADc1MUkf0lpg1lWKohx+ptqCWD7+DremsJwuIwPi9a0WEuhL/MGSMb//rqNAYq8cDMoaj2JFPd6Rp1QiGStXJOkfDmm7avDH50mPK8valXwp5itW/pIrhLtW0gZqPwiQsVMZA7K6r9bK/9K4wukkjiSonnlV2AXvkWWpK5Lir/VDac8eLlq+p8nWK85/dEPYIlxxn/2N7XBxiIe1YFb8RYf7FWivdoQn9uT2x7ymyyxOKjhsShI/+YScruth267MK8oj8BpkBcbi1MqsV7SL3EJHESgUS6iMrZVv/UN6w+J6pFUHGvaI+12Hl+sA/lJmEmwt1js6bElJmf+gs9s9SBH3WxYfovziynSBQNXR15AWswQ4EQaVV0B1sMIexnjOXiv8rVCXJVQDK7yk1sX6Idn17hs9CmXIYPizYSBgH+4kqfU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 1:17 AM, Byungchul Park wrote:
> On Wed, Dec 17, 2025 at 02:43:07PM +0100, Vlastimil Babka wrote:
>> On 12/16/25 04:03, Byungchul Park wrote:
>>> Since this patch requires to use newly introduced APIs in net tree, I've
>>> been waiting for those to be ready in mm tree.  Now that mm tree has
>>> been rebased so as to include the APIs, this patch can be merged to mm
>>> tree.
>>>
>>> This patch has been carried out in a separate thread so far for the
>>> reviews [1]:
>>>
>>>  [1] https://lore.kernel.org/all/20251119012709.35895-1-byungchul@sk.com/
>>> ---
>>> Changes from v1:
>>>       1. Drop the finalizing patch removing the pp fields of struct
>>>          page since I found that there is still code accessing a pp
>>>          field via struct page.  I will retry the finalizing patch
>>>          after resolving the issue.
>>
>> Could we just make that necessary change of
>> drivers/net/ethernet/intel/ice/ice_ethtool.c part of this series and do it
>> all at once? We're changing both mm and net anyway.
> 
> Yes.  That's what I think it'd better do.  1/2 can be merged separately
> and Andrew took it.  I'd like to re-post 'ice fix' + 2/2 in a series if
> it's allowed.
> 
>> Also which tree will carry the series? I assume net will want to, as the
> 
> I'm trying to apply changes focused on mm to mm tree, and changes
> focused on net to net tree.  However, yeah, it'd make things simpler if
> I can go with a single series for mm tree.

I *think* that the ice patch should go via the net-next tree (and
ideally via the iwl tree first). Also it looks like both patches could
cause quite a bit of conflicts, as the page pool code and the ice driver
are touched frequently.

Perhaps the easier/cleaner way to handle this is publishing a stable
branch somewhere based on the most recent common ancestor and let both
the mm and the net-next tree pull from it? Other opinions welcome!

Anyway the net-next tree is and will be closed up to Jan 2.

Cheers,

Paolo



