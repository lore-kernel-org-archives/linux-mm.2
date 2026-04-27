Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 218BDFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0C26B008A; Mon, 27 Apr 2026 08:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4921D6B008C; Mon, 27 Apr 2026 08:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3807D6B0092; Mon, 27 Apr 2026 08:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A6F6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B79C41201AA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:35:50 +0000 (UTC)
X-FDA: 84704282460.02.3F90830
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id B72B01C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:35:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RbA2OA4j;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777293348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDoYjYZWh9LtRBg4Tizg71Ej/LX6Vnwq3A4MiMtGWNc=;
	b=4vmVDDIQev8ra2BZcibWnz4ACAnt3CbZBrBeR9bt4lBJiPzEOfpO6D/+YeYB1geWOGFpHy
	KoOcJkEOwviKM0EDJKJPS4AoIpcg83dqZTY61G9+lxGg5yBJonbTxwHAWb3UMU0XR0Q2IM
	e94ck5Lmq+/x2LJp4ZunLL06+WXb8j0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RbA2OA4j;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777293348; a=rsa-sha256;
	cv=none;
	b=dJ/uC/bFnYBgEugNx4Egjts1bYDbHyGDcJHWxJKjgq9OG52xYDJA3S0Bj+q83ca9+cd95g
	KcLubVkDqA/9O22qYmp8Bpe/BL2/ZzdEbiAplmyAfd0Xn33oIgJprPSaWT+tNJoKPBbOAg
	GkSRY0FvaHNFIER8/MPcQ0CV4Xf4snw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d77a7193dso527308f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777293347; x=1777898147; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fDoYjYZWh9LtRBg4Tizg71Ej/LX6Vnwq3A4MiMtGWNc=;
        b=RbA2OA4jj1xnvHakFuJKF0/tpjNpX9TgvGtmh4Tn+wlu0m9twR2o9QzjOwi5tFbkMS
         o0XapfRHixzI8unPs6PUQN9rgRpxY0dQf83elQZYw6JPt6UzFh2Uic+31KS1lsdd+Ktf
         ugG81QMIxMm0EUXkaUmCXQP7THDgKMlHklnWH50mpqX9y9SqYQ073RCmFmN2z4togYkV
         LbaXvXsqaDjcEmHu21LzsTkDHtOw4VZFskSJG6X1hr7U/CSrkshN9bIL/MP1wws5WIHG
         czFlPYgA3jsGZtetMFKfJVWMe8LxyPgj7804kTpo9aGGe1pYEqNsIMGIgvC96RbmCnjD
         gocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777293347; x=1777898147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDoYjYZWh9LtRBg4Tizg71Ej/LX6Vnwq3A4MiMtGWNc=;
        b=VGs2WC+MUuePbbEMuYIpDeFpdQPMF0UAyILbBAQzGzB4JlFe0xE1F77N7u6QKebzfT
         whCkOJX+257E+gLE0uQ0F1lfCdVJ6AnU1Sr5htIpuew91UHMCBjTUJf6CiniceTSVbko
         7MSmOhAKE4y2P9d6LeHVjKDbCX+vOY0a1H15yVv2rY/LESgZFsvHmL0BWtc5jwYAATzL
         t69/92SqXv1vMft+qqConh04X0iracNkVyCUetVMbcXpqdi+6j3rnIMuCdTSkNG0WWYF
         0XCZ1lKVVJ//A8poWZs8L8PA5eOtav8pRPGeFNZMISncYBx5t8IKd6N/RUXtD/9Dmzrx
         b8pQ==
X-Gm-Message-State: AOJu0Yw2ZbyZ0S2FIl6bzYQVxLyhbN1EkrmpUDSFYbHpvgrhxkrmShLi
	+uJ6CHSndqG0ZLMlxb8JzR25ieUjlOhQ+8pPxbsXOVIDAbNWO5H8hTqkEGKL4di38/s=
X-Gm-Gg: AeBDies1YLFODrwK4JJxkzSQ3VTod+3URQElGK06AzWApVZLqphv7OiXnoVev4o6Ott
	a7CGfDn6THY37LbI0rDlmep/deZJkIUzE6bj0dCPF+wwRXnKHNNTAq1MAA94lx7T0ltK8xowesP
	rw8GnSQU6iYNRnMru5HTyxHrmBqOkr9SaffdNmCUleWUdSA0OZa0sRQQJv/swfnzTkNzw7qToqN
	fQPuFg5uk7xvL5iptrfq5LzXh3I9VOB8dU26Qjs5GwchjBsVAYwhmcpzTuu7f6wdBDc5Cqb/Up2
	HCPuwfVboFpP6GWA9XOx6E/TwNf4en0ezismnUs8duh/oNqWLPh6/NRixklALP9ByVf12nUJ9i+
	xS0jmbHO8S7/KbbmoAMdS0DkPQA8htPn0Dq71ECkvpE9G7gy807uD26eD4h7XhRAKq026ugLyYX
	3gAZp+0zyMZ4nYLJODSaTkX110x5tYycmNoEB9NEOoZUsMiY95JSDtjlN08qG7k0oo54OH
X-Received: by 2002:a05:600c:3546:b0:488:abe9:86 with SMTP id 5b1f17b1804b1-488fb784983mr337824165e9.7.1777293346696;
        Mon, 27 Apr 2026 05:35:46 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffc5e3f4sm448434015e9.2.2026.04.27.05.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 05:35:46 -0700 (PDT)
Message-ID: <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
Date: Mon, 27 Apr 2026 14:35:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Lsf-pc] Large memory allocations at LSF/MM
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
 <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B72B01C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: u5eo77m31dgkhyxzmpqkt3pxa8bjddz7
X-HE-Tag: 1777293348-862545
X-HE-Meta: U2FsdGVkX1+nhKulU4WDMbojqgMfBQvaUcuz6ESyHgcrC9h8m/V6MPxhe050vgcYfgIQXbqSykUJi933/52fiv6GUj+jlIYGpjTf55sGlQKT8WwznCfsGEUUZGe5tFHjmhUpWggaKxJZEtEopTZLd7284IsvSpih5dkgeeCJoi6sVt5Oj3gc7Wa3ENRh3R40SFkGllEl7XdyWwwJu9tlpPHrI9s2hOv7Ro+QaS3WlUT9ZeVBN2rpQ1eBLxF8lM6hJ4grPWmax/cCRObQ+HOY5s4eEPU5RGobU70XMd3AcOE/6FN21tCk+do0wEOrUE6t4zY+7VNiGlD7MfQv9FAvAYNCvwIcYNdG9eOtAwZCYB0ldUlkeybF4ILG2kDqZPQW9BdvV0+1lDEuKPFfdY+8gnkJu8kUqzd4a3RSJxBmgJa6NWxI8eekM+d7Qx8GDJL3bBA5Yzn3XKNeq7vKXAQHp5inxiemL1VD4JPJJrv7mc3zzKFgOxkIbTavAQ4NDlNlPtsc6deAl3tmjpJSIl6zcYhXBGiFtD2GH5v6yqSyzJ7XnYfr8mnuV41OVDdHoHTp0YhqkPQwFk2n043S7yAxkzrA6/viYFsW3UY+9vr36sEdJZhuhsA1Zs71PtWMMDNdYyQoTydCHmgXAAYcoV31pLVoTA9e3rJ7t5lISSQquzcz+5lk5qmjh8v+rPG+sZB6g7Fz97slT8SvI1wbx9CNjxcuSaX94QQN9i6xNBSPQcLMZbTTtRbM211S/5HKf/Enz7AO7hO8KTqKGi4DyTJgM9ksBO6qgyGZvZBxsTOMh8KpvFlz1243qzdJE/mA/TU7nCKmL2oVOLb3aAO4hzbEgo1ZwQ0Kz+YR0bIFjEU42MbZe+f4SsECeRyHFLRZtIhlREsCg6CZaE29xh6eP0H7CGLE+9KcnzG++Dr6lQMGZiDnaPtpAY1ZAbV1bp4u++xpYUzdAQv3ee46sPxTQCW
 WvnwQyWD
 Y3NyaGecPJH8uhgA8mv0lAJGxGW4ygKrId4VVuHA3UR1Oi7DC7GCxLtwVS+vHlvLnqdlaui43GIbNphEk0TdrsK5jXlCjwHAee57njwLL5wgLPAzeAVJhKdnY7Z12u9y6gzSsXB2ojSO/MqhjdYpWhnUi0SfSTHj16AMj28gO/K4Y9ihb7kH/uIQ4nrAQGBFTVeMncFEcpQJ9a6aZ+LAwiF8BFk20+TWMYDVYXiYfqUiy/ZNcCQnh/YTMK1hncWrI4MfkUuo4NM+eOW4l1ZPq9gIu4xio9QrE1mOo7mk62zPYqXKzDhAsUNdbP9S+3SZxDuOwdQN7itkkym8ZxIPd4XmTLTrnSeY1I1nFYyx940X/s54mATDcEdfQiXOdhl90UCCo/C3QPMg+Tr9AC5Y1Xmx9PO/yvoo40kBtLYc3/m6c0IoUlvhybzkSjtrizHe5k9wNzDZeqkFfSgDY+CI7t0/TjbDpwOVJ7ELwfIihZyvrFlWkSoz+4OuxyJ65rql2hyd/M6jyUT0+qgltTLPkgfEgvBcFZ50l+bfHvzToQw4dr+JNnmTIlew41GZTmSTsp6VCS8cXYeqyXco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 13:45, Usama Arif wrote:
> 
> 
> On 27/04/2026 11:58, Kiryl Shutsemau wrote:
>> On Mon, Apr 27, 2026 at 11:46:51AM +0100, Ryan Roberts wrote:
>>> On 23/04/2026 16:52, Matthew Wilcox wrote:
>>>> We've had far too many proposals for the MM track this year.  In an
>>>> effort to squeeze in as many topics as possible, I've currently
>>>> scheduled your three talks into a 1 hour timeslot.  I think there's a
>>>> fair amount of overlap between the topics and we probably can get a
>>>> decent amount of conversation going here.
>>>>
>>>> If you feel you need the full half hour each, let me know and I'll
>>>> try to come up with some other way to squeeze something in.
>>>>
>>>
>>> Thanks for squeezing this in and sorry for the slow response. Yes I can make it
>>> work in 20 mins.
>> 
>> +1. We can continue discussion outside of the session if needed.
>> 
> 
> Good for me as well. Thanks for organizing!

Well meanwhile we managed to extend the session to 1:30 :)

ICYMI:
https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?usp=sharing

> _______________________________________________
> Lsf-pc mailing list
> Lsf-pc@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/lsf-pc


