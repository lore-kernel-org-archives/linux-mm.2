Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81223C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606EE6B00A9; Wed,  1 Jul 2026 07:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B75D6B00AB; Wed,  1 Jul 2026 07:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5556B00AC; Wed,  1 Jul 2026 07:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 277DC6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:45:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 808D94033C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:45:18 +0000 (UTC)
X-FDA: 84940027116.13.5436C15
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA17FC0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:45:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e0CSKR/V";
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906316;
	b=Io7z/c6RLH6AdtydSdnD/0Pl1cfET7yFMj/HUu1emHDwVL20VHdwo7rz+RsL/cMNE9OIW/
	Ne2qbdNTWtsYIPvMqYZ8OcSZKcZ7GU5RkUCukiLLQbHoFCSgmErQFUO7vy/pD/r2ol6664
	bDsUqFg4Hch52h3K9l16pev7ZguDNOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ee7YMVRzqI+ZD40aoZQ9RtQKlP28mAE9ycV55I3/ig=;
	b=vuQoFEfKUOvUzvX9M1VDv0yvuOT2xhF1sxBoguvqt68UfKW66do+FVFuOma5y0Jfa/1opR
	YXGl+ieTxWW3QixB8iDecrj99kqSM1hE6odksPwtgDRFbUYmTc6DVBsYfVUJF+orBOw7yz
	w5OfypC0cYUfb+OgMnq54SxIUPtN6bY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e0CSKR/V";
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-37fc01881f2so506746a91.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906315; x=1783511115; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ee7YMVRzqI+ZD40aoZQ9RtQKlP28mAE9ycV55I3/ig=;
        b=e0CSKR/VAoxXS7SYqC9GSolCimAZiu/BHO7MiRfFB+hMc4ALvECyFVQUJRRByyRuad
         4lXlNEJ1M2jbYQz7vG8wPPC+DnCaNvuEJy/WR4ufYMUWXBgC4TFbQpQcso5/cevLAgrI
         s9+u14hwkY/kVw+SHsfrmZbIeJUPLMILB+4/mPe+OC9V1k5eQaV12FLPermKoPWwpLHB
         yBiLR1eLDQY/Ycxgu7lOXA5Ka5Uy0GL70Pn17F33fhULTEorPtc4bRx3VIhQ9pT76oLB
         GM+nKClr+HOwmPAekqt/TflDDsdIEQZYk5+BCt1OCtm8NXg+FbJokA8/VcNmgDfTiOt3
         BzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906315; x=1783511115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ee7YMVRzqI+ZD40aoZQ9RtQKlP28mAE9ycV55I3/ig=;
        b=qweUkTHBbPDay5wQYet0USkJoxYZtF6wjP2F4isog4FHn5nP1Z1PllbaOirKZgJUKb
         ZrEwuI3yIz1EEHKfNyJbGI2yTguJKsJ6Y8IFoc6r2eynhsR+CBkQod3kKPdjG5WAeaf2
         t2G6FdqlGDCvFEP1rHT0hewrx9Tjjg5+x2erorN/AXo3idztEcSvBmYEw9E/x4vu2aE+
         Bv1rUi5cWDUoVIubtvwCfTMPaJnhuWFtN7g4CP1hisykTIcXcW9h29Aa9U2Ekhk2P9u+
         1pnw3C4l707Fo2Y/qnSCFhOLlQY16jvhn3AZSJZB8SO39750swwEvLvGyNeLmilAzQ13
         QQ7w==
X-Forwarded-Encrypted: i=1; AHgh+Roc0yqyE6Ex8q5IcavId6uoIlGKXATVrTs2QucHjl+Xyc7Z266+g33+v6o4da32zB44jKBZ2qH6Qw==@kvack.org
X-Gm-Message-State: AOJu0YziT5ipypZH6x8kLE8LI2GGr22EsPdPRpCUkC6QUt2XNxVJTCN2
	TLWchKjn85ZmonfwctbRTuf3qcUsyvtcguV6gGRiEe0MD5wbyh8o36fu
X-Gm-Gg: AfdE7cm3V6m+kd4FJX8uR/JnJpuUBtxKmcX1/r5CbHLMjiNHpYR8zidVAMihAhLg2w5
	6wFlJxOkibWnnpTLaReiLTDPkj0X1OFKqx/LSDt97e7kKbYvBr24hyCcIBFPc1N7OTdJNturK0s
	e5SPv5pvZE4mxp8qoQVubCeT0TsC4pytEuEAv44cw0LPTCMCSFmGb5lefNAjXzcIuKyHxlrd6Ph
	Dd06IAh1wIUVRsy4dxhpW8iwj3h0e5HSYS/eMuf7fIKfdx5+C/STZUPLhf88WXLnRlK6X3DSogp
	eVCxH5K3TJyiNeSx2XRQzUpzhjNSQ6e2Hq9vIrMEJPS0KQWra/qFk4m2gr4A04Y47oh2I6K76RR
	rIFWATf9IBEcmW/QNjiopaPh7fTXAyevWpyO2uRpsAhzfgCP/XPdxwwSLCpEMlYidoDEqIhUGPp
	7oP0kpbiuFGRek2gLkFO/t/eN5CIKMs0jhMiAKadzeD5U=
X-Received: by 2002:a17:90b:548b:b0:37f:9ce1:cdab with SMTP id 98e67ed59e1d1-380baa971aemr453297a91.33.1782906315613;
        Wed, 01 Jul 2026 04:45:15 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38095d4c263sm1750153a91.3.2026.07.01.04.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 04:45:14 -0700 (PDT)
Message-ID: <4ec2bd64-af40-8ebf-b8a8-2dd7421a1100@gmail.com>
Date: Wed, 1 Jul 2026 19:45:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
 <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
 <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fhuzhoa69p8sheo5a46fugdfjxfnsbz6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA17FC0003
X-HE-Tag: 1782906316-35691
X-HE-Meta: U2FsdGVkX1/xeWSBFcchfoQhTdxconavCgKhDD5DJuWpXUdstIdMC9mo8wEz0a6+GipRQa7CAzAovq33frRFB0krwfmQSqwlaZ1ZGH9XDY19HiF7YIwhBlo5Mw2R/Cf/gunBBC5lLBtuasVLHskI7NPqoEHbXX6ODDVR1gw2y/j/FrxehG3IXWGN3EjrJHIcYzQEnOQCre2xvAkGlMxeMSOhLIeH4sTGOMo3hTeBMgXlHZBmzVBCpXvgPaMfw6vn69zqCIqp+3lOkAbZo7PWUxNYkAn3jYRQ4528SBLH8Oh6Z3s5xN+UvTgrAWafWdCdHYYK/1R5aq9GoFzxGOvXP0N7+v5pYE9cnFZqFfbHLcTGcL69CTKzkK18AbXuHwnBaaz/MRgIffwym452OGy2ztDNG4gpvnRMZNma0XH8qboA2rAwkIBp9pbe4stS7vAjjYqIzOwq/0fk5qlGKFpoxZ4e14ASxpJGk6DYuZMQLrZrofRwlm30YlL7AOOPwlpWXmgZJGFEvYuaJeknJidZNMGviYK0uQn/S9MxF2CJPDRoGjXVwljy2e0VU+fs1gvLYKtLKjKoSaf6sqplPbsO+KUr2oU6MxmxEd7wujTTsBbnvjWQjTNLqShHtbJxeK0AzzW/EOz1Y2M0DRcGA6ndsnOziJMIaAIK7Jcu/VXGi9TkO3OKvbM+hsaPOtm4t/9tRymG0+ljpVVW3y+jCYP6RxD1DLpWyxkCDf5Sn8Y1r89L1XWvuhcD/sBrXgnpMZxLJMPaLGivLyQ3cmS0YhDl2dHSUIYYxnPTHwlhwFGnxKDLQPlw/yC5f/RcU/WEReXbZkf2dsl6Xa3hKb71IgWXTG6fynb4yx/iUXjNF5aUywR7CvzLH+nAIdSuwZe3/JDHBRxqwyoe9glsC5SvmFG/olBmR5f4B8FvHrrPxID6xgWxXX9+RKiDnZL/u7z7ACF/XB/GyX/tphaMog8DnvQ
 b9n8saQA
 f3BbXKehLVYfo005nmg+jV9DbN6Bg/ikijmVjAtPnSkLuCM4at1Oz8KAo2KKA2yEWsvSZ0tbJbU7U/wpYgjcOc8zjhNSPGZM8+mKTS+nLR30GdKfcieehEGf37WNexYGXX8uetadqNIOhw3FUGCxaAnKAhy1YCQ6w5+82ZYnS+J2csEDngElYfqdHISVn4QtHafY1eC7EOztkyr+AtTEKzAupiSOGEd5zyXet4Mpo4Yi5BmnhBWaetvuHv/2UaZcMAt9HNCCmeZX7Kdh5stG+FTdlscVoLxf3tQXsBDWGUghX7KIHn635FPFlxvNATQ+fRVylskpP3sHbGIcb4nw8MLxPJPf8do1gBXwwElRIw+26ONCX3Z7ZljsyOXzm1niy5/EGsl+2apz5W7LZDzCAW4Oy6l+3yvGHqwGG4AT1kmLe1/PcAfLx0X8yjO2/F7xbFmJh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/1 00:10, Yosry Ahmed wrote:
>>> Before going through more versions we need to figure out if this will
>>> pivot to be a proactive demotion interfcae for swap tiering.
>>>
>>
>> Yes. Should I drop patches 4-6 in the next version and wait for swap
>> tiering to be finalized?
>> We can try to get the non-memcg parts (patches 1-3) merged upstream
>> first. This would also give them plenty of time to bake and catch any
>> potential regressions. Thoughts?
> 
> Patches 1-2 can be sent and merged separately, yes. For patch 2,
> please include some numbers for the writeback performance before and
> after batching.

I'd love to collect some performance data. Do you have any recommended 
benchmarks for this?

Thanks,
Hao
> 
> Patch 3 does refactoring in preparation for patch 4, so I don't think
> it makes sense on its own.
> 


