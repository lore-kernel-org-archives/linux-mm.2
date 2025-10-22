Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0A2CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5EE8E000D; Wed, 22 Oct 2025 11:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD3B8E0003; Wed, 22 Oct 2025 11:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3BD8E000D; Wed, 22 Oct 2025 11:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1798E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:27:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1489248290
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:27:28 +0000 (UTC)
X-FDA: 84026129376.14.16F3FF0
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AD4C160011
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:27:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=QThDeQaS;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.170 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761146846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoALVDG9RnT7BAOdsnJMe54/Tt3GRwf2SgNb0DV4KSQ=;
	b=0jqdyey+k7mE4J6W8Rm7pSULqCNIdeZWXZx9SCAqcH0J7F3QozVP/wVPmlzF5W1EeXPJlb
	SrLGvHUuWWDzydhB+ePo5LNynE3Apqd23U2fgvckMhYAaDl5zWB58YygNAstN8A+AedZlZ
	+3h3j76Y3vkgYTVxwsuMiEGsx82HhqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761146846; a=rsa-sha256;
	cv=none;
	b=s/cMej/hYUOn+gAqgfQlrL/rGfRdqwIyhFznCStN4EfYCG42FjmhN0paTT+w9AQHO+/VD9
	GpARpXJwHRqLZ5RNW3eUyYMJoKCTxL5QT/It5l4ViuBHxcmMQXSAJFkLW3K95UDMRlkY/R
	0VXd4M78Wbhw3ncxRhaKW+7USWZnR9A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=QThDeQaS;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.170 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430ca464785so50903925ab.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761146845; x=1761751645; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zoALVDG9RnT7BAOdsnJMe54/Tt3GRwf2SgNb0DV4KSQ=;
        b=QThDeQaS/jE3PkBA8ZWBubNbs/2Cqbw812FUEgy+afByhkmHbIfAOigqTjeH21TMgt
         lCyPZTcU9mTzfX8Jr70d0kDGWJGmHL9tg0scmkcDwjnNsHPFLWJfiXo04BjjeT1BbIxu
         yHl8eDSDpmfq/RsbjPUn4UV6h3U0/iWVjKMkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761146845; x=1761751645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zoALVDG9RnT7BAOdsnJMe54/Tt3GRwf2SgNb0DV4KSQ=;
        b=LXCB91MplM8ui8S7crH6o6BTvW0zYOKc9QRkiClHAvZk07Ap1XSiHF2MaHnPWliTHD
         TlGf3UN8nbe+Z3eHmmqzsAdaMW+IROQegPc590P3siN4N/VAd7t5i+3gJtA31h5FQx/k
         1j5iGOOpp4LFwlf70hOnUReH4/Cq1WMCJ/UitCt1HARfK2RXbMT6/Av55zv6TZeN5vkD
         s/awS8G+H9g2gBSxXnvn5WO/6eCvGC3VHqNXJIblLNMf9OUIaLGTiMoymYF8w4YU7gy7
         A2QT2DJ++XWvLOjuZ9FSz7l3E+5xgju2BLQDtovxrSPlZ5rZ2R+Z9xnUSa9XXG0tJAXM
         X4Ng==
X-Gm-Message-State: AOJu0Yzg0jLKsMbb5/9GzJdKRW7UqR1trpv6I18hoa4+0+tzGeswYMRA
	8tlYEciDLPDI4Jn3u/PTTX2HPnTyaLiV88hKXJiB55KoZ0OSAac/2m9blMLSsU4x0lw=
X-Gm-Gg: ASbGncuKJqhAGauZnmqoqvnVfwE+ee5dvJuEN9cRTgZxXMkvQ4d1heMGhVhXYFNs8uW
	UhnX19q/A2js4CuFR9HEgOGXbVSjRXkrRF9pK1vP+obyszWGsqA8npo9jwIzt0WTcT/WMCjmEEo
	Ydu2tuv5DpE+/WUGPiQV6YgzKnfLUsLWzoxbGB64Zm1WLUt6eX8dZo6UX0wGqLt9NqPg/kdJKX+
	0vmcdDbx1x5yGSMqtb6AjxcI5oJdck3ardcdu6+YrUzLlZrK9TeQlX0ciEVs24197D4EwQ3n5tq
	bUYchbywyjZYpIk7ll6Pn6ZB4awjnrEzKU39FlFfNNCq0yd1hAcHujkwizsXO1yHDlkOmW+3Qqo
	VfL8mM/uFCT08Bo3dHfmvarZq++yBqmkk8zlq6QivbbQX0os8FkFFUtYsNufUl4P0eH42SF+qCc
	oYEAI5fyNatgOi
X-Google-Smtp-Source: AGHT+IFHrNAgETUq7iHXWj4LaXPG7j1qD4lSrv4wnohCO6eo9eW67OevdQz1fzSz9sygsvW/JqehtA==
X-Received: by 2002:a05:6e02:3101:b0:431:d76b:d133 with SMTP id e9e14a558f8ab-431d76bd17cmr27048295ab.12.1761146845007;
        Wed, 22 Oct 2025 08:27:25 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a964a8a8sm5288976173.29.2025.10.22.08.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:27:24 -0700 (PDT)
Message-ID: <cb30af9e-c22b-485a-a83c-f395880cd799@linuxfoundation.org>
Date: Wed, 22 Oct 2025 09:27:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under
 label
To: Dev Jain <dev.jain@arm.com>, Sidharth Seela <sidharthseela@gmail.com>,
 nphamcs@gmail.com, hannes@cmpxchg.org, nathan@kernel.org, shuah@kernel.org,
 morbo@google.com, justinstitt@google.com, nick.desaulniers+lkml@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 david.hunter.linux@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20250929115405.25695-2-sidharthseela@gmail.com>
 <486e0d6b-799e-4fec-9e6d-3ddfdd64418c@arm.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <486e0d6b-799e-4fec-9e6d-3ddfdd64418c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: hs1fnt41wu616paygh3oy4jeit3cf15j
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AD4C160011
X-HE-Tag: 1761146845-976425
X-HE-Meta: U2FsdGVkX1/baTi1ztaKUUOngp2LEFleOA7aMlAJsSjyzJ87fowT0w91sJv+idFt7PzdTCRxXjayyInxRY4oNYqlTWNc9azxfYRBopvlcSEANc/Xr4uwnoFPOkwZjKH2peL4N9AN+5tvX7DuiKzv071jjRIOMHrPiBM2OdwH6V1hDhBGSCvqSkSKyPjR95RXyVLFcKPHzF6XftGpMn2vJ9+f2Kzdh9PhXQMZ6NbhCr1JUqeh+L/YDCqiFLrodD3uj4d8P/sRvRW1LdcNjAVLtYRlohKgqtNzyucGqmk7KCUdzMYXey9sXuvOtTNy0hLrIFiUZPVkTtCQmRIXfS+rQorko5W/cXXvyCvnlnQDd6tuIafL51D2wa6uUm7UuXr29094+MY16KGRFajeUd0EkDou0FUH57tU5lU326X1HC0/e3MIHX1KOGA39yNl4cxF6xTrJqZQksDnbKWbghK8YwD/nNPX3MBhCJr6xM4eGCXoww1NAcVZk08s6qg8ogbiFDzpGBP+7EeIw+kUoKZTVDTWAHukoUbHQu/ycL75IppmnJ5Pz+7f6vCcmdi8njblu759moJFWAcY2+Y6l6LxjdaKXkERWc5w/H1OgqyX7C5nKZAlwTlvwSqOyka64EcTiQ3wwPAUq9Lg8RcW5LbRafj8MzK8YYdetqQfW5s9wZaN8yyjNwTau1nnu8/HFa9yekqYIrSR+uCx9QPFKtkJtu363RBLeu9W7JDoc/DVPWqWbaYCtNX99LqrOGIhYSag9rXWEXYWs3Oo4iVDGkNwB1rQfzlkOwu4PlvzVHQwdzUt4M2HEJKVIVxgIVrEsk0CeFFYCw7WCpNAlLF0k8EvMDwNo64yP59CQEAyFAOHKH8CKRmI9+eMbkZAuB0r8g3ANpBYGq6h8yt4f1kn4XF4FawlqFdm/Gaa+pPMl11dQ77LfPsRcXJaYqnD58SVRzDCnP9KRr97lRAqbw6JJ+F
 8XwrNYCO
 isaLfaYOoVNY9NI0Rd6CJIAGbUlakvORCqUT3wZ4PXD4YUVnAVK21nketG9hWz3caqaUHvy7bvMfoTHk53lveaA2efgzw/bBLmaOAdSBILczg2QJ8hlUcTMlMcy0jI3tPseARwHZkuNbk0vRkyO1C+tGhK8M111HBwrPp7qLWEyvn8qUMeygl31PVjKRi15Z/sptqdw0IjRAmv52YgFDibntmL5xL7HMRZER3zhZBAWputgqM8/hsDY8phJaeNOgfstOXUWetchcK+E+34Fpjg+EVOc9DVz0Y3/hRhBtB5BbHU/F+GJ6DvawaQBofBJxzPtQ/ZeMV9KwvbhslIW4CSTGCzbSwmdv+P1zynVD20dmyFZTKexW9iKaRlWVTDsZ7nJnDE9tEZUEpqyQg5kHCZ/KCgrbFJ9zBuMHpCOx2Au+xtjxiuUuj9LoXBFeEqGLMqdBcGK7YIcV9KhDGnyuWJNEXIfeUT50q12WfdqnzQAQTlLbw8oi5sv8ljcvwVM7I1puSUxOKXXqha/4hvwKYwY8tAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/25 22:52, Dev Jain wrote:
> 
> On 29/09/25 5:24 pm, Sidharth Seela wrote:
>> Fix warning caused from declaration under a case label. The proper way
>> is to declare variable at the beginning of the function. The warning
>> came from running clang using LLVM=1; and is as follows:
>> -- 

Sidharth,

Make sure to not use "---" in your commit logs. Everything after
this line gets thrown away. I had to go fix it manually.

>> -test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
>>    260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
>>        |
>>
>> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
>> ---
>>
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
Applied to linux-kselftest fixes branch for next rc.

thanks,
-- Shuah

