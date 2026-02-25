Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB20EFD214
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998F86B00C6; Wed, 25 Feb 2026 04:25:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946DB6B00CD; Wed, 25 Feb 2026 04:25:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B636B00CF; Wed, 25 Feb 2026 04:25:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C47B6B00C6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:25:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBF7D1604FB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:25:26 +0000 (UTC)
X-FDA: 84482445852.29.7F2C18B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE4BFC000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:25:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eq5J4gR6;
	spf=pass (imf10.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772011525; a=rsa-sha256;
	cv=none;
	b=GFx4aSLEvYxwAkMTobKBeyLPN2fAEg2c/ATOzaD7Be2E9h2Xo/iMCWs1TsCIld50hqxQVo
	dvYJmgskpUNlGpL5Q2ph2B3aewEQ89NZtkJi75j5oe6uUqsvJgcBs+rzs6Ca7KoOr4OIMU
	ueG5cEa4NtgOnln+0o0FYVAw5BkVYNA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eq5J4gR6;
	spf=pass (imf10.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772011525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFxGd8tt1psILcxBsQnx7nL9xt0mE3Hus9OpWjd1eMY=;
	b=IXofH7gnTw5CPbCZGuAs7CIC0hn0yC33eX4wA/USffM2A7TS/Mivm2iUDrI3b7Tf49l6jJ
	GaiJFYz5MXY0CLRyZljWHRHyfTrZjTNLDv5WUGb8N1731lBBOtTSBUnR2yDqDHumx6V+l2
	k/z7TinU5axb+uOpc8ZxYfG1Icu7EjY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48378136adcso38565145e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772011523; x=1772616323; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NFxGd8tt1psILcxBsQnx7nL9xt0mE3Hus9OpWjd1eMY=;
        b=Eq5J4gR6hWya8e5RpGqJ8ulordDCMH8qoFqZV/9cOFZlIgMT3ZX7JHwG8Y//Lvq8tL
         Ap86tu9Nlch9qXQUIJp2s3Cafwkf2X7vKGTOam4oJ//5A7l9yeVB3/VrXUw0FwKR+vP9
         Oo+l4FPD5aqsBcWKzm+feIrHOM8ezyk0l0i57SS5ZGbi/5F2wsw9TQ/liKIzugQzkePP
         AVIsT4HxX+XmBwZfEEBIP3NOLea7AMTRN5d9pmo6do/XuLJVyJoGm+ArHzqRiiACAd9U
         gTruEOSAz/8k45vV1u6KxeqBDFW7R34hEIlyJQke6PuRlbd+XxsgU8RyJD9pFoGpuANa
         jKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772011523; x=1772616323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NFxGd8tt1psILcxBsQnx7nL9xt0mE3Hus9OpWjd1eMY=;
        b=H3bIPMhd3xZvoIHxQamVjeoV1PMwvsDTZZinV1mIV3KQlC5wAdIU9RqsaW/BHKQ9AB
         d0+kFR5i1MeWiRV+mkTV23snwkqV7iwhMAPKZqSXgOipg/YRltohonPL0/o1WFy+tjoy
         XKsHKUshd866GkeXMF2Roa6GVnvttHreU4e4msGIqNwZBzwzLW4txjtWHvQk6NH8ScPf
         VTcPg1iqvDgtgNCM9X0vbQ4qlHUDTpFgcWqSUHrbJAPn5E8agRFELuS70ps2P/TGbgrg
         L754QSxUlzsA6OJU850Aa89TA5eDazRFemnOhoVVUspfcp7P2i7tUmFuFburrPjdK30c
         Pymg==
X-Forwarded-Encrypted: i=1; AJvYcCUu9kw/vhK0lYoEQbX1VLf4Ly01kMJXhiw5TWFeVQed5vAZmdxiJ8D3zkPLoau4kxGQC7uJmuhOmQ==@kvack.org
X-Gm-Message-State: AOJu0YzwaE1qf+ExDodtnamanReSMQ5XJ8E2qEFsbtIMWbEDgBum4E4i
	rn88604AxcMIHJBjgCjgIZWdXABmP+XZ0iGd911bNjMhW2gQXoeGksuI
X-Gm-Gg: ATEYQzz8gWkW+jN0v1g9mMDRm0+G6Sqst5XUVpOrZu/mTbm2Fd+UELU9SKPil1JSlJW
	CllWheG79iDolEgXLp7aMmw1tbXeX2Ux3l0x7gtKznQeAWRG7VrCRLTrKDAc6mmOzu0PVBjLgid
	DfcRCJJfAyXi+sMdFuRlVUcWKF8Jf+QxiwgBz1+Ta6REhA7ONvzEI7ubYkx1LPMxrQ7eaNKp77h
	rxhRe5PpZhbPqCHmv2lkSpxtYf5q3aABPurHokImuMSBiEnPKZY1LA05xmygMGpdZLrjrMlOO4/
	ZYrbjodjGmqrPkP1+Qo/7WK0W+a5vu6Ssfo/lAcSlmQnVMjQ/gxVfwPb8SyyawdOcohmDWTbyWc
	2/+bfYy123J/6Ujfy1W56YetDU/uEOjj49meH5bLfqsSM9lKplP7W87pRxqTanSWO7sArsF+jmR
	OGC3kGDFhN7Prg9UzpJdxpd1K19u8c3+peVLes9t8oz5QTxExitEv5S9FM4wyenzxWmqft2uuKJ
	fXvnm2UsRRQF4Q8BL2u391xGk8y7o9lBqlAGZMlVhAkvsm0Iag0BE2JikLpbj8LaFKt8bAXxa3A
	1w==
X-Received: by 2002:a05:600c:4f90:b0:477:55ce:f3c2 with SMTP id 5b1f17b1804b1-483bef2a427mr34570355e9.14.1772011523170;
        Wed, 25 Feb 2026 01:25:23 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd726a35sm50268215e9.9.2026.02.25.01.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 01:25:22 -0800 (PST)
Message-ID: <bad6cd67-88c4-45ee-bb51-e24331263dc2@gmail.com>
Date: Wed, 25 Feb 2026 09:25:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
 dsahern@kernel.org, almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
 io-uring@vger.kernel.org
References: <20260224061424.11219-1-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE4BFC000A
X-Stat-Signature: 91748511qhdde36xc4oofozgi55cp1kz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772011524-443686
X-HE-Meta: U2FsdGVkX18G/57ICSmM/uhmyqWqRjSDFbnS39j/NZQJKXyFFR7I1HAXyMoaHkP89xER+8HzJgCK/ltVK/1kmmW/EISGK+kodgQhkL/u69NFQLC+0t+E3k/nrp6sT2K6lYoQMNQUVugwtmGxltw6Zc8/ofci2K0jJwzsKsO75bNmGKr0gt97QTOR67nB/C1/FbZIXq96dzVzB3GTFgKPSGZ9B820gQqILCOd7NOuUFTh4Ub3F1qeEPHceozLefevBSESS2WbcS0Vqa1jhzzODp35Fi2TJYSP/SM2fICDZUOrFowSwrwI/h0SQmoi5xjnhwLb9nKIz0vlorOCrG2/0aEQ4zeZq8u7LsuRdznkaegOmzaOjNr16PZJsxWrWmLzw6lj+biLbvRXvSjxO4KLtERs6HYItGkAmaML809vu2yLWFUjsVHuh5TdDTjV9AubO9LpPsrviFvp7LTwYnftiJWTmm5wDxOmMptLCcXj0BXSBCY5d9S8MyzzgxyN0zwz82iSiMRK/xMPk2I4wVUTb7Jgkdzg2zZ8t0j/1sQ+86uOSGEYcAQJIlKj+lANH3lvej/ufAlkJV4wxr63S+55ASHwbLPuFCmVfqfbsLUJRFN85e0Y6lp7gcABKfsmPGrT8PfMWnwx+nUAACSV8XSQzuA2qQw/6Vb+UVC3OJJoPxZeYuUpO8kiEV06LNWXvNUMHimXMl0Tg7tNkfTcQTS+i8seiU2mDq2L9wQ0hV5kuHrE59XjnLscNUb0Gjj5jBzCAgXeGPu468/vifLK0Yk9PKNll7YtMAJucrCmvJyMuOv1Gv7bBjkdYFy/rUWznWePPZ0bmu9QLVWhorWCCJgPbufSh+afNWQMV7qTJgE3bvPWP4+v/WHTL9YeS8QwvkEkpwPTA8+XWUhZjrp0/PlDDD9lyC0aQtpXkZ8hfUR90V87BmU1Is8NTfsYpwex9rqt8PWylvdE8U5P01IdZ47
 ctnqFrVp
 /QdTP+rrzrwRBajZOaYFQQWYnTjwNkGyGhJMkcYfBYKgSUE9z2hT2UjQE81TLAAJT9WMb27hrnUAo7F73tC2YBnFWd3gAcgSuYLy5VPIfTDlT28rWfRBnkNBYS3hXsrE4hzqh6HQ9KhdqTrt8SRiv+dhZ3ZqEwS/gKG6efUiXvmkby5pYiBJL4z4qPqB9ToimknxGGmilcESKet4eEf1tLZpl92n1xkuwXgLn8kiB/3cgW+hLY519/ZtvT27TcJn1iUnjDFa6RZnd1/YT4w4Aj1vKehKSEidTMVrVEOXAu2V47LChOmYS+kzcGiuifnLc50aU0Tn/J/8CsU1zMDEFwInZdWCdTzldrgEGrG3Tpjb34EDdtQg+p46VP3naqSJzK4HykRVfW0iVVoSypGAGc15e8ugNDYFnKwOevewKG8jA3krbKyUA4/1qccUUGDLw56GRuuEYt3kUgVLfSRDDkU/W+cbYCKyqExYjnjYM1U/YhzczJTcQ4/loim3bGeE2tH/UZWIWtElRrMhHJPERmX1pCA0cFaNj9wV9rJdT7SxyFBYC+O5tEVdb6SInI4dL1H4/Qaj/4Y+3hevRVux+MPLXVoAx2HnsZ01qUocYjXFqTTonQJuDbuYMZAKRUslJijIRlPZzzIdu4uX7rPpvMoX4gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:14, Byungchul Park wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.

Looks good, it's great to get rid of all this aliasing.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


