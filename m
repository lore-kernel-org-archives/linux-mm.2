Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65023CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E268E0002; Wed,  3 Sep 2025 03:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17798E0001; Wed,  3 Sep 2025 03:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE618E0002; Wed,  3 Sep 2025 03:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77B458E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:46:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF31F8558A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:46:51 +0000 (UTC)
X-FDA: 83847157422.12.1525F39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id C43DE80006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:46:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZWtjDNvd;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756885609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aShlhK0M5I/4dFVaTyFFcCXOwiHo3P/PmXViFObtfNA=;
	b=wsaLnpfOnKVujaHA3/dwroh7DduZHBIzPt4izU0Qcr7pAvP6WvrWRtvghfeAirAvc3R1RN
	yKyqNi60XirD7t7XaaIjPkbXhsCfU1dGutYCoHWpXOo0oW58oJRgtbPqh4D4ROTbGiFP05
	fJzQ0fwQF4XwgDmzsyHo0Rh3K+bebAU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZWtjDNvd;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756885609; a=rsa-sha256;
	cv=none;
	b=JPIktKFbqHt2Lo5sT35r1BzxsaTKqpeG4uIDDtZS1b4jbpa+jQAdAHDYq4sJS1jnAD04oi
	FQ1Y4KsZnHD5j+oujEWDZHmzFkUE6XLXD8LS7EgAq6pxER5zE1NO+K8OjFzG0tVgab0Gop
	LeU91wd4gRuI4W7uGoyPp5Vh+ZNitK4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756885609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aShlhK0M5I/4dFVaTyFFcCXOwiHo3P/PmXViFObtfNA=;
	b=ZWtjDNvd0KDnXiEQrcWgdp16KgNDXk80TIXrkaISZtnfqlAeQs5ezMKU76VxgPQWrpgYXm
	JelOER1D76XcPcLpAa7nlcso8KVRxjd3c8X6b9VlLUI7fuIpAQ7NNmEYoYLpXjUQz9U/3X
	JA9UvFXcPuVk6Hr96lyMlL6wQmZpZNo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-fFfHjnmKNa6ejwz3P6iEWQ-1; Wed, 03 Sep 2025 03:46:47 -0400
X-MC-Unique: fFfHjnmKNa6ejwz3P6iEWQ-1
X-Mimecast-MFC-AGG-ID: fFfHjnmKNa6ejwz3P6iEWQ_1756885607
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b920e0c25so16217335e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756885606; x=1757490406;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aShlhK0M5I/4dFVaTyFFcCXOwiHo3P/PmXViFObtfNA=;
        b=SBvIOPmNAWUHyyFLrpSoCtUWIGl5n8xz6tYLh9Tq1yZiqC6ZjxRXj3gsCUEFZgVjq+
         8Bk35QAZ6C28hgJYIksxl2hj2AWdmeOyDiQu3jAa2x0fUywXb8//t2PagIjWvCxEHhAS
         CozNuvu+dT93302fiot1/YuyrZeTZoCGnVLC0c54sKwB+OFPJNkxWjEW8P2BoWugtfBq
         vGtDbBm9rHrnJFAlqKRqt024LQ2mGa2kmUKkZ7wh2Qnyt8jtl+8qnRL6+LZqVEehfb1I
         6dtz2mLXafhCUvWXBbF1Yn+iyVt9aOJCiW/g+vmSL/5dh0crRyaY+zu7Up72vslazFJ9
         e01A==
X-Gm-Message-State: AOJu0YxhhuIJ3dAVNsBLEiCrlHWVDCQ+UFpVLxMvf51r6rrBZjClEXFN
	ka9AYcloG6/dlSqdBC7Kromc5tTBKxxPL7n9FP5AxR3oE8XLpPLnLWv72/wt+Qed6wlj/amiYTS
	tAK6Er45DisgHfCkxwXatBwVmHG0IrgL7waUiSWK8MWaM+Rphfc8X
X-Gm-Gg: ASbGncutE/lLn9UlDixEfJez764eKgIIZr468Et6yKFt1IF+p8sA6cUzhtua00aiZ2h
	Ck8CbyQr17WQmF4j8ltEDVsnmOyTBTlYsqbKUg3sQsmu0s4Lyv/bELPfBmJrtmUfG0Mrldx9ifg
	2HPPYFh5EPMnZxLpicTdMgkfovsON4pmMqfipkAt+cQUjmysLNR/K0Lnx6jv8GW9ACVcjWN4xfG
	oUyis6hPpGwY0UNfk56kzj533t5mhsjCDYIVQjVjJy9Q+AOl8I3k44SYWIYp6sQiGdWx+A42rPk
	QFvI0Yk+0DCEopLR9pCmNh0KdzM8hdmLdeuO1r7wp8ggCbokMWZi0UGHNhr649yoyAfMgaKDXK/
	IXotlCe1nc9HB8iQy/M8O3Ihw68f0LC2HdVrWjG1xwk0pJ4cFcqQ3ElbxHCitHZRnplE=
X-Received: by 2002:a05:600c:4f08:b0:45b:6b0f:caf3 with SMTP id 5b1f17b1804b1-45b8843e109mr99804495e9.4.1756885606515;
        Wed, 03 Sep 2025 00:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcK11Fj01Y4VYea50OLhr0MjERaXU7HBpVg+QX6sa8pEoH5KpraGIdHQTkUtzFV9er9RgALg==
X-Received: by 2002:a05:600c:4f08:b0:45b:6b0f:caf3 with SMTP id 5b1f17b1804b1-45b8843e109mr99804165e9.4.1756885605992;
        Wed, 03 Sep 2025 00:46:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8879cesm227680705e9.12.2025.09.03.00.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:46:45 -0700 (PDT)
Message-ID: <b0ed22cd-ebf9-41f7-b5fb-6fb078db593e@redhat.com>
Date: Wed, 3 Sep 2025 09:46:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Kees Cook <kees@kernel.org>,
 kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com> <aLdOLQLjt-A1DBGi@fedora>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLdOLQLjt-A1DBGi@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h9OI1yzdeoJ5FxEg490FFjcnEDaPJH63Ap-TGH7Uej0_1756885607
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C43DE80006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4puop6d9aqni9m5fq73r7eeq8umx38eo
X-HE-Tag: 1756885609-819614
X-HE-Meta: U2FsdGVkX1/97aO2159YhFELPMUHEGvZgLGT0N7NPkyllcc8lCLHJKEI1TS0VGCnVyXFL3RFPiJJ1H3Zt4siAkUeH7HEbKoZ+44NSBIqg2asFmKgadiTv3OX9M+87efvnqKLY6Ed5uVFNgmtuMfxPiZTcNczHFSlc/NOp4VtGvQMEl1MMA8pRhEp1clpgDNubWufWTbbUq4vdvkHZpyJp1xSN2yPQz7oiIvaw2bR4Kh430HbGJ2RfABBr9zQBdcePN8ux1l2aXN9ls3UCx/Xp/7aQDMHJUFLb/EvPFMYQ/x+oGk4PMoATMuAgYRleAevuV+yEcLfhLq8LOsGyp+s6tka/g0SlcjEW0tHASsSDA/FclFj6jiHkQ0etr7AL+asZAJepx45vZpy1Us2CXS7l4XE/T6VGDrtOEt4QwEM3I3sbzWKfDlw1UdYn/Sfcs0rV2hhNfLuXh3jCM/K4JjiQGmVMg6C2cTWAqfWFhaRdfr6qYRuRFN9AkJ4plFIL9nkz1T7mmTLuwYB8stWIlPO69lpD9LsSlG4JldZB2LNl/IfwzMiLIyKw8vSuDDlzfCRfnuaQ4OWcPCFx/JPpmrUe3SLjJ+Jjf9nUd6H9wFo9qAri72VnKunf3cBY6yJP3zFvXW6OgIWUiDGreJqiG0NR8wIP/kWZDt/gKaWMZ76fo4JbJ2NskXmPyK7Xctq8TP3hVQ9/niM7uA9nLlxaPZAUDSxeTqht0nW5Ly0y4GXq/Snt3wTTXr5bvyKxj4/UHMhULfllr4Nk9pdzsKikXapCXikPSsIYj3s1QP7WjmUnlVF3FogP8xsrYE+Vdb0W4QP635vwQPx5olm0jnRiN3ps5pFPcIUKxvyOgRJAWtTj45Tn8jjSKWJ8OXCNy+rsTpKCgGzE/DpTNTHYOXLl/ph9vVW+WpPVlACIbGIWypvs/FqNhoWMArxJu3exr4SLczkJUeG/8iGph/AVrfY+OP
 rYH8ynth
 KNL00fMdwkzfGKTvNn6jW7/LUnBym4VUQwPY0t4etb/6g0NK2p9fz6to1Dcn9Qf8P4m812NXQf4PpCJx31PSuSknUW55xcsgxrX+8ofqfjdQqYXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 22:06, Vishal Moola (Oracle) wrote:
> On Tue, Sep 02, 2025 at 08:23:06PM +0200, David Hildenbrand wrote:
>> On 02.09.25 19:59, Vishal Moola (Oracle) wrote:
>>> Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
>>> that were being used for the kernel stack.
>>>
>>> There are 3 cases where kernel pages are allocated for kernel stacks:
>>> CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
>>> These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
>>> respectively.
>>>
>>> In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
>>> than 0, and pages are tagged as expected. In the third case,
>>> THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
>>> This meant that in those configs, the stack tagging was a no-op, and led
>>> to smatch build warnings.
>>>
>>> We definitely have at least 1 page we want tagged at this point, so fix
>>> it by using a do {} while loop instead of a for loop.
>>>
>>> Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>>> Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
>>> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
>>> ---
>>
>> You sent the patch on August 20 and I replied on August 21.
>>
>> I did not receive any reply so far.
> 
> Ah sorry, I didn't mean to miss your reply.
> 
> I can't find your reply in my inboxes so I definitely missed it somehow.
> I'll go find it and respond.

I had a mail server config issue on one day last month (sending 
@redhat.com through kernel.org :) ), let me check if that was on that 
problematic day and it might have went straight into your spam folder 
due to dkim mismatch.

So the mailing list did not reject it:

https://lore.kernel.org/all/96148baf-f008-449b-988b-ea4f07d18528@redhat.com/

And yes, indeed, it was on that problemtic day, and there is:

	Received: from smtp.kernel.org

So, problem on my side. Willy already replied, but let me resend that mail.

> 
>> And now I realize that this patch is not upstream yet and the commit id not
>> stable. So the Fixes/Closes etc. do not really apply.
> 
> Gotcha.

If there are bigger changes it usually makes sense to send a v2, or a 
simple fixup as reply to the original patch (I prefer as inline reply).

Of course, once it's in mm-stable or upstream, things get more tricky :)

-- 
Cheers

David / dhildenb


