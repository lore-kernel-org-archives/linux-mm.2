Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD1CFA0C5E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35006B0092; Wed, 15 Apr 2026 05:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5EE6B0093; Wed, 15 Apr 2026 05:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4F26B0095; Wed, 15 Apr 2026 05:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78F956B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:16:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34B41E40A0
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:16:29 +0000 (UTC)
X-FDA: 84660234498.03.414F605
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 227ED4000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:16:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PftCzvIy;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5IZ+dOe/qCEN9b6XI8ElLsT16xrwMw5gmxZ3qINeFw=;
	b=1f1B4mhblnVdkyC3A2Yavucu0Mq4B50rRw1ZPHyNPt2pXwaYZlqy3DEXinqZnrYU2RoBfy
	GlcXNLEwhUzdzsfXvzOjQGpPtfuDiUEy40eyzChT0mSQqtLYlc5RzKVFhJOV6lyqhad2Xe
	jzM/bnirhS8y9Q/SMFopgo14kZZw3LU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PftCzvIy;
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244587; a=rsa-sha256;
	cv=none;
	b=UGMouOzqAEh65+3nLwc7xe6plsGmB7Hxl+gR830vfH1LB/auyJ09+bUrRInoVbzeyYKI+h
	DQB3nhtPVxcjYABG91MiIfT6tv42+BK90w9x/jfcTARGhTgl35rz5iBlo3hFnLvIC1OP4y
	VsqbiQ15ujJSB9Kbk5jyxUlIJ3Wj0Jw=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso64105255e9.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776244585; x=1776849385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5IZ+dOe/qCEN9b6XI8ElLsT16xrwMw5gmxZ3qINeFw=;
        b=PftCzvIynzNzRWsd5Cg/K/D5xhbW1WLM2Q4edicOYJ5yt4ovzzj8dnEiYNHR/yMQJl
         a6Xb7mHGu8WuCY9TtwsXs1ahrYADyszt5V5pJ+tK73CoQRGW5v7ZKDkBBWLeHEHB4ztX
         47CCHp7f4wHhE6RrbhAHh8eNDaNKzEczOEfxyy2QPLEH1ZtO9cMaKwujN66v6XsGIvya
         ImqGQ6F1xg6ch8d6aMFUrFg0uhsuztd1Z1HE9Msym/t6W07fCKXgzcb8mejNhvGRNVP0
         pdsSdkcdwkiQA2O1RL7CkujGJHNJ4gwgxPsUa3j3Cb0lPvGIqbFKtZh2H4Y6CgVLhy1I
         zLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244585; x=1776849385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E5IZ+dOe/qCEN9b6XI8ElLsT16xrwMw5gmxZ3qINeFw=;
        b=d/wAnKI0fgD8WmnCZtFH2Uf5LXswMSuTA9LvnHvMooewM0G7dyW/DYJI/Ht0SlcLwr
         vWKSjViv0HA0hKetdSt/vlbBnmkwOH9A5GDUrLztIxKsaoq+0oxDhD/LX4IxglQJsDGe
         BtekYDTsop0fJTUiJTGpU5/YBsj5b7TXz3P40COSEHkSJ9rEGYfBhFDFcjdF7t2j++Ue
         BDJoGvaRsa9f6EpZdHppVrY4qUvTitFYd9ycwWpizLu84ZejmuXDeZfpo5LTJVL3fvNv
         abvwEEnr3JGg+rz8J4WHefN7sLVADjSlIlAmK9rGfH5ITpGyyNDO8nxzLKaInUWhbZj9
         VOtw==
X-Forwarded-Encrypted: i=1; AFNElJ/pSJ2Wcjs+kul4fCvIf+ya9u83yZrtpOmcTFcumbmE+faQCpSZJzGriqkTa8lBrBhAiVAVhgem9w==@kvack.org
X-Gm-Message-State: AOJu0Yz/0cSGvy/aTFd7nUh94hTexynzBhv3Ano0pRCsRn5PC3+hOwjY
	5tadlTRJBbYqyp3eHpCSs+Ep1jOpXR0PGf4WZuuPHzbVZbFHkkoGTjkA
X-Gm-Gg: AeBDietn83Y9as0iCMT/d6pkrEozcdOfmX4k9e/KbGlURAanlNG3qDNQ+evrvVaoScE
	F/j01l5bte3CJy5wFLG6m64ef1dvJqf/2I5NojuZ4ulCm6AI+IKs7Rhqpl9ObAnQjKA9ZZajFaU
	8BfnrkXpNRsY6awkZaZ+q6CkXAgfaLdcuRIhaJ/UeVPXiIkBoWuXME6g7DpBxgs4tXUHnXP9Ghd
	Jj4j70PmcfDDFBeqqxTHHzCpkBYvJUUNld0y/bxmBtuUYrdytk0OUaB0Dbh+B/lpePJwIwgvxtH
	3CVCYNHK9lIq9IXFWZpxTrSibdj0niacyOQ5d4JXrsLYPX+WzQIuBUVO+zXD1I71vfJAPWSu+wL
	vRcZmmKT4Xx1cUCRKZq1ecexdhfSUGo2E2L1cjHHbv7xFVRx19hj9zjK7N2j7Naf4Emrmu5+ttH
	V7md2F+Y5dOfmgPp3AMHMF+ycu0aWrM9RJAo/lLA6VeS7jIgqOL9OtXMRnRnv0oaql
X-Received: by 2002:a05:600c:a11c:b0:487:2671:fb8f with SMTP id 5b1f17b1804b1-488d67fa40fmr205276285e9.8.1776244585433;
        Wed, 15 Apr 2026 02:16:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ee038752sm117771055e9.9.2026.04.15.02.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:16:25 -0700 (PDT)
Date: Wed, 15 Apr 2026 10:16:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
Message-ID: <20260415101623.33004858@pumpkin>
In-Reply-To: <57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
References: <20260415044509.579428-1-dev.jain@arm.com>
	<2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
	<57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 227ED4000D
X-Stat-Signature: hr9nhrpufmseiiit65j5uz1atxbd6oda
X-Rspamd-Server: rspam06
X-HE-Tag: 1776244586-236808
X-HE-Meta: U2FsdGVkX18q2KA2pDoI4YbrYJuE6th5LNsaLKdka9X1THh68GS4wfmgTkEf10FNV3bY+vLrIJleE4kHF339qQnIvIpXU2+sstJ+Aqmgy0rKKBVNUmtQ+SVTIOt8oLhkMQ3vce71Qf85Nf+DHLkJgbaX1oBOlSQWScF/r76kqUS+TmHWc3n0djvX9Lk6EOlnNCdOYKySC6ZKEzVARCPwZOb7xs0dA3UjRxC2+y089mfgVCueIPMecJVLtR4EC0XdbAqWaXOWfaCkLhlrK+Fnp1QbD+owbQbZbAaqiCGAPkrLkmxQB2cQLWG0RlvJS3rJB6YWHRBl1LLchRYHRswy5GtYccZUr8RmOLa5M8BC3c2CGREl/C/JJNTHvt61HIWU1lyDn3BbueW0zoZJiQoYkecdDtWsutKqdjgB24jvRq2xtzwjffDD4QMGOF6l85A3hhwvLTP3THF4gJ/6oHS1JfKV2C6RCZF7f0bZ7jDkrxKF66CR3e39kfNlZW9lDBgOp676dwe+cpSetfykdE3tFUwKOBV3Ef5mKaEB317EC+jBt0TAqJ2gzk2XCG5eALuD6ZtoaYhi1LI8052pY0ZRBpyRPn2hz19sVE7tSnkmw4RM6puLjqn5kw3o7oF2zAVVF91kJuljDcHj0ksf6g4HXHL7syXc9NaOzu0/zRou6Yf07Ntry5mf2LxVAaIR4+22FKWRoXXLzKu7sREDsdyHVEYz8pIqtqypI63hMnYZElY4NwfygNY3XsB8JKJsoNBqTv19xwG54FCKoZz251sfJkTaYUg84BiNNZhCqaJYP55cBuNyb7R94a4yHHZfLASKY0IxcKIRF0bbLQZeRV8HV1xEvEQ0SItts6qN50zt1bNm8l8ZdInZ80KEZujuchr8zjVT6ixVbLYfVDxka4Cq7NJjjZpgOA2yWAu8rUXoG1YlyHCO/ZkQqI9jOeXqe/MAQa2bioCG9BYkCQ/DqOe
 HTr6tsRO
 4ZVCwZCTGME6y/ONt93R+H0s8cuLYjzq09LJKA/6LZs5ZCQuOzwLzrm8dkbiRVxmvCMAB3u6spmTlup0yCsiBj0vLsdWFpozCKK3XKpMIAB3nB1DoY95hw2OtN9whTBj9HPVzh26k0cr+0Wi9AQJMcWcJkpwmqybEyQ5xzeStl4YX02zvzeCpX2/j7Po+widYr/e28d3fGgLMjBEvONvFre20yEctnbathJIKIrQjDOIo21HphFHh1Tmf72AXygYonpS3Hyc0b/mt6BbMsAstORpRzN8As94LWrz0pQAAFNInmKvJqob67lBeL5nOHOzjRw+SkPM/0i87qS/wkWGp+mLhn4BsnhSFqJxWoCVXP7qh3ccCeMVla9qPIMA4jVkrp0nGd+eK+5zHcxHBfN/npXHIkks1dpMTZkaYiKOSJ5RxW2kOz+R+BrL8khfCvVLDHUi/hQ6MkSMdUrtB1N3K/9oS/IC8hWli8RPJnLOgIkEVvMgPXvoEMzy9/Rc5RA7dvv0Lqp4fYMM8FZHHwUE8et+XzE2BxQ0fMx8rzsiln46HKM1IDkF9mAFT1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 14:05:01 +0530
Dev Jain <dev.jain@arm.com> wrote:

...
> > 
> > c) Remove any randomization from the test. There is no need for random
> >    patterns, just fill pages with increasing numbers.  
> 
> Agreed.

I'd start from (say) 0x123456789abcdef0 rather than zero to avoid lots
of zero bytes.

> > d) Just always verify the whole regions. Without the rand() magic this
> >    will probably be just ... fairly fast?  
> 
> Yeah we are doing a simple memcmp() so it is fine.

You don't need a copy of the buffer, just compare against the pattern
that filled it.

	David

> 
> I'll implement these changes.
> 
> >   
> 
> 


