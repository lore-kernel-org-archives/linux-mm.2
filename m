Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FF3CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CCE8E000E; Thu, 13 Nov 2025 01:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314618E0003; Thu, 13 Nov 2025 01:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2519A8E000E; Thu, 13 Nov 2025 01:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 158A58E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:03:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1DDD5B63E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:03:34 +0000 (UTC)
X-FDA: 84104541948.15.6EF7E7F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7A6BC0010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:03:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A+SJ9ivk;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013812; a=rsa-sha256;
	cv=none;
	b=jTXEftziXPjFqdXtovdz02l//gcJ39O07DAD/bjhvNlZL7x+oAlRoA2fbHhG443T2g4Xyn
	9rnJ3uDSUnXLHnYAetAImOODNXZiubQVdznK+UsbkdWBTjCB2x6ekRCpjsMmOHy99tMeh/
	lpez+n9qMm/HHu2wgdbPxJ/I6EflYyY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A+SJ9ivk;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xvuh5w1/ZAKgFR/QxFiPcrUwFuMeEU+LS4Dm3RyAWa0=;
	b=fg3s+UMLhSOjRmmDijmgt+KFgTS0VOjtmXLM7WYtfHSZwHAqaUxTh5hbsDUmz3nDpSa90r
	r1NtoPZ+prndXQM60NI7fmolBjKlioOPQ5iGIMEhcbfQQMiSQc1XtFpilZ9NLUJtsWRJBb
	m0HbzrUhDlzMjzIsEuE1kqXeVW8YzSI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34372216275so537360a91.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763013812; x=1763618612; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xvuh5w1/ZAKgFR/QxFiPcrUwFuMeEU+LS4Dm3RyAWa0=;
        b=A+SJ9ivklaIWTaxu6kjouFioYTHDysbWD9uxwcRLnMj0glIghAzxN+Sb7258DobDpd
         0Ro1jESpeKD99a/kcDa1l/zqBknuzb++otDyhGcRmuQE9OJ9UlQkE3br4V96WEw8elnx
         9NsB6mocnkvo1O+hi0uPOHapKQwc8fMjnTQyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763013812; x=1763618612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xvuh5w1/ZAKgFR/QxFiPcrUwFuMeEU+LS4Dm3RyAWa0=;
        b=iNdGELlhWGtfV5D4H4sEvlvCIvjEC3jQvkuW3PMet198yrNtwVL48cwTELrmYszFjT
         9h1bHlhdlkukrPEaH2pnF+ZRYX5t7aehDvyKKnetjL9Dyt6610XDbA422yENXexpFy1d
         pse+kV00V1XC4ErQcvyJ/0rQM8YF2vsIl7Wp9XLwyz1O46lpMh59t0Pk6JkYcr/Ka4LB
         24/VDheEgSdeV76P9/jSaoOY0AOvWm1zCZdi5HsZMjR7UXk9xqulmR0vIPtxSCmsYx1M
         vsf4JhDBJRiSwHHi4dEspglLrG2kYQa8/7eZ/Bsgcq3n+6ghfSzIl68PCiaKRVSVtvff
         j9DQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrnb4DMpjIPi2wTerD/7ZZpsgDg7pXMORGbmQlutMi1Bcz42riWeTp7PlLR6mVZ04jiE5gmH7zwg==@kvack.org
X-Gm-Message-State: AOJu0YztnwG5xElKJZAsq51CHN/MHHMZq/2vwvYLyzWtQfKnBM5L4EeA
	rqvct9PpzvU4YOJn5neZv9IWKOQZfUoVUDPJJZA3EBBTdpdj3I9ttw/TJ1ntavCMRA==
X-Gm-Gg: ASbGncsXlyYkmrlxHVo72LPz7tHQDQ+sRrcKIj38jnYvDmYZs7GmNforEAIe2ixi9Xk
	s1ZYxoZEN+Mcmm27+iglnSjIEPw65V4HdiyDFmvmISg8XyHsOt/Cgf865CV8bV/Xb3+OZ6bGb9N
	B6ELpof4h7UDGWdlhP1ofkuCqCkw/CiSgzyE2mdIvr4QIBsyVMRZhyCPPSbCOTttIcxauLL9zxz
	FBrhwDwE/kWSZx0b2W0ZDnTr/KrAmiOnVQUxOoA3gqVwdFsBcn/7vhFZCpI5+LSivdFos63aHJx
	EDIp0fa6j8jzY+0wGUiHqt2u144sCZiUjYSSdwdZxzt30ynl13cH9lRAhD+BIsfyqoBlQpPOTjP
	4vZeaEv26ljClAhr60yPxpL9PoxGtVYt10WJy7nM/JWbN0hHHciQguQQf7YYUqQ1tzxmZ8f2yiU
	fhwz86
X-Google-Smtp-Source: AGHT+IHJSK58zJfETaE4wa/PjHdjxMZKbnTlC1cgxs6GeEpxRx5OPn8ZRrdiWfc1MRgfi/HYWIglpw==
X-Received: by 2002:a17:90b:58cf:b0:32e:a10b:ce33 with SMTP id 98e67ed59e1d1-343dde6f801mr6239881a91.21.1763013811608;
        Wed, 12 Nov 2025 22:03:31 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ed5331e3sm1090918a91.11.2025.11.12.22.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 22:03:31 -0800 (PST)
Date: Thu, 13 Nov 2025 15:03:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Yuwen Chen <ywen.chen@foxmail.com>, axboe@kernel.dk, 
	akpm@linux-foundation.org, bgeffon@google.com, licayy@outlook.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	liumartin@google.com, richardycc@google.com, senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <kyprvtaorfdq3a6fsddaww4jg6ixv253rfonrdv2snyhq4pkuh@zdei5bgqzd3o>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
 <aRVvTCCZSjPyAF_2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRVvTCCZSjPyAF_2@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7A6BC0010
X-Stat-Signature: iz3bgtzugmj7irpx8qarzmigyubo9tr8
X-HE-Tag: 1763013812-577957
X-HE-Meta: U2FsdGVkX1+2qvc9mGvRbbK6i4asaG3ojzR/XX87C0KtFo65DM3Qi8gV2D8QyI51vd3axMvZvg2YAIWvnoWlzDyGS9aNoG2Xb6LZ6tEZWInzBnlKpNDzE4gIWnW18fQLtkmVxRxnrLsn+MxZbg5dUufMQBZXrNf0J6hOK81tZfLEeoZiTmNrJi7MbL/dTMk20MobmnmTZclclY9rgw7fdIDIAtKVlq/Rcy31K1VG156SfSCG4xOG1EZhOjLlCYV4OnfJYlEZ6c3skKdmkv6+DhMLeY7ZrtFbnYsbOVRbgLWM3RhhgVHwgObPQssQ0HjZbsd8H3wn4VJbLHsPokA1qxRNNYQm4hD9UKqvIJXYRZwAd0tHuIrCOrNeKjS0l+atnTEBDcDeIFJ6JVcCvma00NzjSL/5ut92A4/wXyWq6mjE39Q3V8abSKhVIbZ/pkOLoE9yr3K1vkODS529PtVbVOs2RHfPjrb+3JCu2QBINDuH/baoqsiXLrQifKdoV5kY8npH2UhZGMhrQxONwt6pdN9XvWmxwQUQVTt/nPwcNm4RP8sFFO49tvsQexgWOuilZSXxcXuV0TIT2WjBmAOXh6uH1aEsnUR/+9nXfWl3hcoLNhUr97oYubKdpids9Qufc7+rNIr0KdLJ078potzHXTkMeW4uBdVF4vQX73lTIqaOtqoGffE2C4HsQUAR0Ex1a8AT8awPaFwCK+B6HqElGPQ/Y+53v5v7k9tGZuYjaT6rGOPtIKBFHNRMIBcjKUfy7FyyY2dwY+hpXgyKfBtwN+58YkKawbYX3LofKzG4xTUu0eYMfjWX4PexKTXqLEU+xaDCZ3yT6t01sSWkvV0O85/703E4tDrht23I/LpdcNeWKC2Tdu/rGEAK10sh3DqM7kMIeHM3ymuyI71Kat2dtrze/lmCT/DdbLkYU6Aqtz7yZ3eyvZ9iQTDK1RnfFZa6aZhng4FTk/LR9e+Chy7
 IXwD6PGY
 JD94hLP8g+gb2rpUOr4oiyiquGqq8iuBUkx724MRj7+fKRKFdTo5whcC6Ukmyy62/k/l/YL9InPA9jjgeR9JhPIimlNnpJ/0lGwCH8O28NCvIvbmjB++LmlzW7SpqO0hlZBfz50s21RAHvWGIXIgSOFZIAH7/57pQpJjmDZN06OfvxKP4eezHwBY8vdmHrbihGrmkssqWvp1fEGukckZmkHJHCiZl2scbk3GkXYsuOgNc3zWq5OnKvwTNciY7eRJqMCLa5i7HZLrWulo8B/+UU+YwzlU0xUapIzYsTwGlVtTotKtW551sYGBPGp1SvcFc/qx/UxwZsJLLeTMTe1RjJvslUpnTcxIyqUlhL4+uwjx7IflkP8iqjMoKYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/12 21:40), Minchan Kim wrote:
> 
> In my opinion, it's much simpler and strightforward align with current zram
> writeback utility functions.

My preference is [1], which is very close to how current post-processing
is implemented in zram, w/o complexity that dedicated kthread handling
introduces and so on.

[1] https://lore.kernel.org/linux-mm/45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org

