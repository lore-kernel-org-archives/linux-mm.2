Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5CDCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368F56B009E; Thu, 15 Oct 2026 10:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340B56B009F; Thu, 15 Oct 2026 10:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256FD6B00A0; Thu, 15 Oct 2026 10:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEF426B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:46:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6430B160A7B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:46:06 +0000 (UTC)
X-FDA: 85325135532.03.1855592
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA80116000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:46:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpirLI7A;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=n2eKzu35TvaEv8HyPaHxC7x3j0v0d8cIHnv6Jg8auww=;
	b=F1n2HKg2K3i0B3k4eUogg6SArqgkWXwssXor5O8iltQ6BiC7ZCyniP3T8rUF5OlB5wwaUV
	4BzQZcB4/V8HUfCS32fZvKg7dizP2Ync8oP8k5M+4sPckVMLYpL8rd/QqyIq53gDH9VHZC
	DfnO4wx1I4DLUqm5ajGKs96SQg4rQ10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075564;
	b=dkyI+Rs5ux524YgR67wxJdsOnlLy+R90F+OeNAuPpoGKpWDGOylxZ5xQG16T6x6UsjD0G6
	gdx+JISY1AHcjyTGBohB+meKPMCC2xBjex9UOsNMKXNnIipr9RkdZirvrnrYY4WA4o4v6Z
	D9b/aJ6KIVr5Oz8Ip7HaeZQw/H/NAU0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpirLI7A;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3abe4821449so2267435a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792075563; x=1792680363; darn=kvack.org;
        h=message-id:date:references:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=n2eKzu35TvaEv8HyPaHxC7x3j0v0d8cIHnv6Jg8auww=;
        b=lpirLI7AIMZCXTJsM6IEsklQXueP+g2TZ8tytzkobcFC04/z6Z8Fhcpmf3Gi5pXHBd
         wjgnkdh6Toyyo72tWRus5MVTqjHSNzTswNHgZmDGLJYLLhzyz4IOPI1X7C5LjxlsJnUX
         CYkqJ2mZSjj0ieInl4nFDsBqG1VE1gQ9U6ak8xzHjuMTv9YsrBXUOzdQ3dwSZGgPHL7y
         y8hNot20nVkolRnCszvbuguf3v2RZuX8dBzApHVwscgmfvPQ9Vj2FTxH4q1AU3PI3QM/
         cQ5WCH+jzmLEHR2Fj+huN4Bz2Ndx9rTOtFb+heHvfajEzeNdYjyAC3ovGIYoG5KkkCdP
         ZEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075563; x=1792680363;
        h=message-id:date:references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2eKzu35TvaEv8HyPaHxC7x3j0v0d8cIHnv6Jg8auww=;
        b=yL+TEhHABNTcEKT+yFvVsPsdbkPklN97upm+ci681AvPSutcqC4O9uKHIe3G755Af4
         tU1wYDp6ouubgNOshwJZ1t7Tm5LSF/s+UBQ40YgB74aTg27+/0NsV+0SE7xK9TH1wNdr
         RzEIlWm7KpYpKPwRxIcGGR9k5bib0EIdZJq6H7soQPPZ+SONCLbXKDwpOIH1RNQhtxNH
         dXtJCCaHVBlDtjTnDIb1K1IU7wmFTgBO2HTNjpoHR6iqF8Fj+eYaQA5a7r2DKDQaIvd7
         3mvQeobLLD/UpIsRwxWjOL5SAD7QOgrN2/LPTOr+m2t1WLdN3xyhkh+G6hk2hbPq7uPk
         9hSw==
X-Forwarded-Encrypted: i=1; AKwUvByONJyKc7HprLkPK9YkdCSeEuB7AfuRXz8v7IqDLYRPFo09gg4alCtvD5Cr4OOo/fx/aK6mMyzq7g==@kvack.org
X-Gm-Message-State: AFq9FYK7g/tvWA7aXoAeGTYPW9HW2cr4zzdUe5kYqTZveMW9QLRLnPYr
	v7+dfeYrQHiu+toVWq3Di7Gv6U3CcpcAAUDKUEObI6jwHHpzGn+cuCxhonIOSgGa9FofiCMK
X-Gm-Gg: AYBFou22rdgxWmhilntu2stz7qIxf3tEnqnO2Kv5FXbvBUDxKcCTPzFLH3/WmWp/HlZ
	mE3WeXWu62zK4QSQbq15p+iTsPP/KrHB0NDWccDhQFx2M5IBE6QOrVezA9dJGRPCLg42Vbo+5Oc
	MjsRC5B2XnYjByhwp84LCx1SHc4REQEhGahWUYOcc9b/lLmnXj6zRVqkfyXr6cL23LjevE9KXmu
	N9Fw6Vu1sF1dQw9fnHNB65AO2ygd7Zy8Q54VLV5GlELxeOKCAcAP+WlV0X7kuCd6P0R+vcrncky
	lEGFcob3u+dRxoK8AXJ1wYigvRZnpvsRNKEElDOOiZqmyp4ZyfICckRcE824uLe5l++theJNRx0
	lPqxN08qzPKupdSlkoUIUp0g+GSvf8tnAeVnttkaIDRpStQ9FshNhhB9iV6fr9wGi96uWWCv73s
	Xv2q0/Fwl4SouGVzAejbPE/tsep6MjdnGqBJ9j98sL/Tn12dyayv14pM7WyhSQ7JQFJ9kco2WVA
	tuVNqZxbNtdEo5z
X-Received: by 2002:a17:90b:35cc:b0:3ab:2737:3392 with SMTP id 98e67ed59e1d1-3ab3afce21emr16003498a91.53.1792075563236;
        Thu, 15 Oct 2026 07:46:03 -0700 (PDT)
Received: from [10.131.15.42] ([115.200.102.144])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd635cdffa5sm1393286a12.29.2026.10.15.07.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:46:02 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON_STAT: idle percentiles out of order on 32-bit
In-Reply-To: <20261015141319.88393-1-sj@kernel.org>
References:
 <CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com>
 <20261015141319.88393-1-sj@kernel.org>
Date: Thu, 15 Oct 2026 22:45:01 +0800
Message-ID: <179207550140.2.6042983090152523193@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA80116000A
X-Rspam-User: 
X-Stat-Signature: r5eb99diwh81oxatfuezmf4e9a3ehtkn
X-HE-Tag: 1792075564-579906
X-HE-Meta: U2FsdGVkX1/SO2VRF4DNDe24nFvRk0Mg/VqHEHYdAtLl5Jw0uJQN+lzEQhhNFKPJpU/69aBA2cgbWCXZ0PwIdraHNfZNVaqA08YC9vwI0aQuWBA2RrbZExbTNcGKueBFDLAbzrXInPy8XW9cptCQdFyTuGQWAHRRJ4tbKNo8jzXRMV+sfIJprFP2l8wmYenrZ7Fs9RCP3V4FTNS0EJJJM6C/msL/mKCsv4dOgUoWx9wqN/CPNeQWK7z7JN/x/7nPv0HOq0Uo69lrzOpCnXE71zapQ9MSximkS3MlZvF/u4wmgJSSyOCeL4NFOGPyJTmUkWtogLtoNU8Bx4pbpeBBtLSkCCOAR+PscvRW57u9cuuPz9jO6PMfxiZAGkx871KZ+4HBf/TNkNCrVqMjyiw3O9HJGRDV/VYoEpxvoQViUg9EvGbVWDpeTmyESkOovHW70rD7Ag92dMOIahy1pct/rAXsEDEKWuhKOcbTS5Y3FPbysFjn4z8B/ZNBo4vh12Q5YcbHyonoFX4cHpVLcc2a4x0yInD2pLM94ynIluI4f1Vbmb7WGhgSSFkfLJ1/mfcG2Grx84E7HDpVIUtUt4lf7HA6OdM/3EmTUyhxOh2Lv2cPFZzmDOPHZWtebKpUB8Vl1XF8Z5LfFR8jzOkYtSO+nLTl9940F3fTVSNotSDlp6AEZeJex/vxPxuH/6Gi9IKepfhQ1zNL72hFEwgvvXYN1pCaApoCHkFFOGX0cdC1MtEALZHfYbgUjmgRCHQho+x26BhP7I0Mb7RTvo3DBkPKz6Dxm0ixleoH8k66IpZinE/h5HuwyjxEXKtGWKv8WJAvMUbXBkopBF9j7rxCdvnohcPyoBaNowp2Ae3jNeYqKALbPLut40/Q83QGTXCJaXBfoygY3XHjQQ/DpmzUUZs1CLLG0m5pKK3EJ2+qw6W1T7v6Gkc74CFqeR+HRuD5F42OoegW/G5b600oV7ThuZP
 HaX3e8Yk
 OweL4yjJFBkQIQ0ZjIljjEA3Ioi2+nmUm3fg32rSN7/P4FmVa/zv6W3z2UZSMdKOL8SwjLXtYyKeTZVwv/Qd9jq8TwHJbBjQQILZ2nb0FdzYoTnxVSYRmIQSXr66Dp0xG/w32rJkIunHWS+oOxw0/fkUYI9prFC1pIMs8sIYQHuBldyKMI3eHNdUV8k6tpL/Im7Y3heAyQHK7RwKOX2ZuBYNwibZU9Wt6JhsOh9b276zjkpacRFNEcycdizodAiCpySpSgVED4j1cLS2O0Exb3Vawgl83/AIuETGMBrCLY/+GanNiTFT61xSj8/PWYnIT+tuLC9UsJ15I2njr5Y3mMVBkZmZ95HoC3J+Nr5ObOZUGDwMgqwiqfnEIBEoroDD+v34BNBdQghabESw00/QYp3AtnltampK0RfO8uHRB6z+G5vg+zDiIognieG1ViZsAo3kK/H3nKhJvZQhrWatP96Rnf0DQnsI1qv2xmJg5TKYn8xU8WIkgY8M2vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I haven't seen this affect a real workload. I found it while testing
DAMON_STAT on 32-bit.

The upper percentiles can stay at zero or keep old values. If someone
uses them to judge how much memory is cold or to choose a reclaim
threshold, they could get the wrong picture.

I'll send the fix and test results in a separate mail.

Thanks,
Aveline Noir

