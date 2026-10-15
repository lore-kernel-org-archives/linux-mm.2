Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A516FCC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6197D6B0088; Wed, 14 Oct 2026 22:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C99B6B008A; Wed, 14 Oct 2026 22:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9666B008C; Wed, 14 Oct 2026 22:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 241246B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:04:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92464407B5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:04:10 +0000 (UTC)
X-FDA: 85323215460.25.D594C99
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id B5E191C0007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:04:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ChupXePo;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792029848;
	b=nOuzQ2Ccn9hyzYKryZAr43qj8NjTr7rAkbI9pMKoUbcflbgAycCtJ+l0c8qGstKlBNZRyq
	WiWoKiGIzVImqUOwoxvG4mZeYp1HLffxnR5rl/qI2bR6WZ7hsIVOOaqATt900X0gSqD9gZ
	cwUrRKOR1HRy+acHURXT0aPpQL0T0fM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ChupXePo;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792029848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wgW4AUmqbNUpe4dZRuBCucz11edTIwYqEDP8LKuxdo=;
	b=qUJCx3CL19hGmbXv8OBUAK7hPYYvXB6wtZRTDe0RQSNB58xnbGjAy2EBTp9ZsxtbAz6ive
	sxpWYV2ycAENKGJfnDf1sXbuYcYYZLq5D6Ye/VcCNfEOK7NTGkaR9Is0kLuVuPF4FztKLl
	5DPR0r2GlsTtQZyG20A+dD9P4ieWhO8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso2614649a91.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792029847; x=1792634647; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+wgW4AUmqbNUpe4dZRuBCucz11edTIwYqEDP8LKuxdo=;
        b=ChupXePoVUqZkhRC/iR3AhSCdQhxeSPcvbQbZIJ71vGMxdrdUFtwPoY3C0usbytWz3
         /gUlRIm7CejH7e93CcbeJOqBvHrNKuuPCkcOZElf8R45LZkUd2TJzuMRtyHRLZkTJQ45
         QrjeB9AqO7vwacPBIXb7IUEZLOJTErLD7Watk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792029847; x=1792634647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+wgW4AUmqbNUpe4dZRuBCucz11edTIwYqEDP8LKuxdo=;
        b=KFY7vYa+WJm6057Tj9Zmi4xsra6OBFnChnG3F1bP8W/p1MBnCVuARFrFMED6CEVItz
         3ab0BHbZjMttgf+SzqYwGNjZrxhXmvfdXYhYotsADpY+NIRVTxIWp1h+RHjl0ue6QoRi
         YAvF/twUEtgNBH8oGIuzmbB0rdJpDL50YS8eHOvrHdqUgfHDcuantZgQUpfTfXliYmEb
         qlH4xg37nlD/dg78zmrFElohQ09rmToHSWuKFOkjLnMGko70RecWrkxH8fhBfHrrbZKq
         iwNulezIL0kXGsHkaQV3YTxHEWO1BWSigujhPSAV1mpXCld+hz18iM/+85tGpJf0Ajxm
         LGow==
X-Forwarded-Encrypted: i=1; AKwUvBxPsal/yPAHGfIzYghx2dBfNcDZY7srPr96BJ3hLUteSiEgczFVxd6l5F2z04BqUE0YGAu584t9Eg==@kvack.org
X-Gm-Message-State: AFq9FYKihKvca9MAfD2w9uLtJQ3oZg8kOVxYxMBRX78pb9JBYP74Lk35
	jzAkwyW8BqbpMewdZnX3g29d8iPgZvrqvNNeAZC8iABG5+7qcOJXWrKRMw8gudHBM3ex+s0c/li
	Rv48=
X-Gm-Gg: AYBFou2dwLpzAgE4sIrJf/DpDpHOFCtHNVhSg2BVBtyabv+QDC9xiPjX/q7OJXwKEkE
	ODuVFKKbDvdJJEJxwJlfPMTVOVjgJTD3cy6WS3pN/KK5IJlHVrffBLnIB+m22qFbELniroveDgl
	l6vUuaKPT6q3UcZJ2cBZRh8sU7aOAZ24cJJ0+aAqcdt6Ia1XWusVW9CNS/O5qFaXfKW9yiA2RU+
	2d7cEkvLAC8gWYlO2h/X83N7C3c8SlrZ3P0GYr8QfgLiHMb3oEpGUOyho6wMHQnGDxB4ecmc0lZ
	s4OYiml85Fp+TjXY9WMWZ1aew2f1Vmh/UUGKuqPtmt1MyP6/W3VudcS8NlB5Oh2SPlkWhBTrUWm
	yLfTkDaj8f5pIq8XThY0O4/IBOf0MUgaLXhx+39G0zrzCjoHl4DmMA1BSUMUSxCAmjmKhOLwOWo
	wFp66m5xRAsmVzZZdHaXRqDKbYe6jPWEvi4m/xGdmWlzlsKwjKOIx243eWtsuDsI1qARtmNk2se
	p593J6z28I2O/orawfAalVhhxd1ppkjLiT3X6w=
X-Received: by 2002:a17:90b:5828:b0:3a4:ba6e:65c9 with SMTP id 98e67ed59e1d1-3ab3ac95f56mr12616470a91.59.1792029847508;
        Wed, 14 Oct 2026 19:04:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94748c6csm1889088a91.10.2026.10.14.19.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:04:06 -0700 (PDT)
Date: Thu, 15 Oct 2026 11:04:03 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, bgeffon@google.com, minchan@kernel.org, richardycc@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atAzS6mTZQ80tTHM@google.com>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
 <20261014153603.1365617-1-zhangbo56@xiaomi.com>
 <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
X-Stat-Signature: eqpru4bcsd5snho5p4kde8qgu7mcswn4
X-Rspamd-Queue-Id: B5E191C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792029848-386144
X-HE-Meta: U2FsdGVkX18xYBr2vaqsWLynpWqnV6CGmjqH9DfsrXvGFVkxfgpe0BYGPEXhsLvbMmlo+bpyu1HvEfY3UCPzCnNWdpfqOUEs0aBi4tjOY/4MOQNab0LqskqH/W1I96iPuYD/YCvRoOx7oFUBHX5g4aKgrzNwqi3ZEbdiuHmfkcIj2Sc4GibrnFZZMoZ3E5AJV5WsV04+0zfjP6SCcOkrmCII7uz7Xavkecj2kO7NbPtFgV2MVWpdNsYH6hb0UDVdZRBdbEXfSOmZ32mNNAcgzHqGHWj2iPODkvtPXj7mx56tFJAeT4+0jxkhwKuB3RYg9ufKP62+IcWcW0U4WOeMtqsKP8AtjgQnD6puHQcpl+AEMVRttsaMAdXBCsFIqOd2jgTJq9BYvPnxQdcY4zlrRcKDfD9+QBoQWc7D1KIKSr2QweIoXMULLvBqtFl2lNqiGCWGR0Cp6adjymHjCOu9BXE7A6YWk3jAz5blNnd0O1oG2IHsQXU6+4h19YHXP8G/5I3a2BvZ8KKI9UQB6PWR8Y84hVg1KXIjHPqrFg7CtKyCGcCgyC1GJG6IQvF11R/JB8a9V0FiXyasHnBQdEpGLVLLfV4wmm3yT3HPUhRu4QEAwkkO2zvkjD1nKYE8I8VQtWhC65Hv21HhthGYah4xN52gKwUY42HaoYRhApiHEeXW7QJoKEON2XIK8pXhlsNngjEo8IX2eofm0XOD3p0WYlStcy9IbWJGIJD7xedr8MVIEM4+ODTPwd4ynkEPZe0nQl/HM0919SJREpZ8agzUBDHU89n/hwuijOAjnXacvnNMjrYoj0r1Llint+ch1XzFGcxwSAxjZljhKDkqBeSLWclc/CsTA6gUXPhvrJgVS4LGJALpisfXyGxWhQoVnAtHu11J4FhHWosUbJPrPLPRHOiDxrTHyG3thZ8ixunjxBWny9ZD3dplodzSiIHLf98T/WkymDAc1ZmnoYB+Xp0
 onyANlwX
 PS6Jr/5JO7VHeCAwXCeMseHeLHLC72XBHawMR3oFI8HFjO2Q//iGD6FJaR21HsfxgYQ1rY/eDaZ4vm7oq8X5eKOpep+nbZI6uepnHJrLh5ZybTq6v2EXuNaBMeC4plBVIKYWIWbyQvdHvQ/rgaVZY0XIqdBMWLabO7fwGUXJrIHgalYEETEJL70niYOnICj87bmpVJbTZFRET6RYPYCiCh/ZsKTIYo02+cdUXEoohKyVB9Med6QXdfemqIZxzsKtuVWzEaFlbwWPPbqW9GK0bbZzoBg53UUGDZAV4W4eUn1xFLmi8FX36T2MIN2Ua7eZ15Yma/5F7e32NMySV7aIvrmYvm7fPqd3itXmrhPDhICz2psx3s4DqnTXEokj8rFJJmtKZzB0x+WYJkCHKHihkINmcpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 04:46), Barry Song wrote:
> Also, with either deflate or zstd, create_dctx() will
> always be present. So, what algorithm are we actually testing?
> What happens if we switch to zstd?

Right.  Am not that concerned with deflate, but seeing zstd on that
list is a tad sad.  zstd mutates decompression ctx, so it cannot be
shared.  On the other hand, zstd_dctx_workspace_bound() is almost
100KB so allocating dctx per-read request will be rather problematic.

