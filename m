Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B8ECA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 06:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABF36B0095; Sat, 10 Oct 2026 02:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89116B0096; Sat, 10 Oct 2026 02:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0A06B0098; Sat, 10 Oct 2026 02:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBF06B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:40:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B0CC1407DE
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:40:19 +0000 (UTC)
X-FDA: 85305767358.24.3213668
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34111120007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:40:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDUtnvpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791614417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlbA3upGwk044fKBz43T5VJDihz4e5V6S7+qAUQy3Tw=;
	b=j7OJF3u7tcnKH39vnqiZfIV84xNEXa17+BE8UQMRPRV5feUJtv/PevcfyzszHKCvRBWiSD
	qineauN0mVwdIegsMRH9wEOWvTS2V+WzU9td/3lH3ez4IOsZQUoNgcSH7xeTFLlQLBve2t
	37izExMKNCOsfRGXw7W39w6WSTA7XfU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDUtnvpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791614417;
	b=5xHg7EcxHZyJpmiwWqNY4crCP8ns4+4Grke3XlMu5s5dwJunFo8gtPisqIQFoNm3BKXM5n
	twAJHJP3CPoLPvOSiW3vF3M7tXi/JF6yzJZe26uf/r83p0OfWgikY9c8v+29WrXMKfJPlw
	EJ4gV6mrEcvHiKILvgRepFviq34IYig=
Received: by mail-pj2-f5.google.com with SMTP id 98e67ed59e1d1-3a7adbf1b3fso111286a91.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 23:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791614416; x=1792219216; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KlbA3upGwk044fKBz43T5VJDihz4e5V6S7+qAUQy3Tw=;
        b=YDUtnvpavFpYk23HrxvUxPhV1aqUYJhVcj7LdwzjvbJwsyj7Cm7pndGPJnls5bMDy8
         qxInwNhkLzdD1unErcO+4NL8mXt+rDKXTvFkYa2me8fi8mAInU5QG3r5Rpzdczg2xwCR
         LWkW0caxFQq+2DGSwprRjvCDTx1Kma4pi9tvGro1ZfTCnxfmqXb4r9I8FeuseS6YKYY+
         LkViPcMuHI4ykGRNGq4x7jd0Jjl4ncAwfVV6S8jLTmfH1b64Kx4GYFxvAfZTw1V9BgqH
         T/oWa7CCvQedWpEH9sbC77g8HEQ2Er7//M869c6h1bkGipyt2gQ3HEtNqyVAQPcIsaHk
         btFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791614416; x=1792219216;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KlbA3upGwk044fKBz43T5VJDihz4e5V6S7+qAUQy3Tw=;
        b=Xp6aEa78oVJtyKP4QwO/ElHMWXd66eOxzidkLCYqha0KIPcuZrl9nuVTEb1pVOQpWW
         HDrbLtus0S2I/tPaibKsuw7kKWTnDH7ZxUAlIHjHawuIzPifWQJps2kzIb9rJvSphvZS
         QNG1wdzFwGj/lE2jN6aan5wzYNn0GE5THHuXXTtcEUtdTS2F/8UmYxESyknP783dpcF5
         LN1SNbIfl/7NCnVJ5MDHzWxhYMuWVAFdk36bCVnSFjqB9/aEIs0NUXUy2zss8p3XlmGd
         CmMTcIlEUxl8s4jBkdf2tXm3YnEiYwpq7v0O8Z05qwBkhE8/Rc60Salo+J2YwKYFGa6Y
         HUkA==
X-Forwarded-Encrypted: i=1; AKwUvBy0UYHsSOQITKWrDAevR9lE29NO4x1EdnsGWeVtSR4YE/W6A6s3aAfvW6VbPReKk/9ceaJ+9kZIlg==@kvack.org
X-Gm-Message-State: AFq9FYIdyXLSXvKt9uVDIZPrYHaip5JLvhN6s7UO9uT6Gex568iBrsMj
	Xh0RUwBzJkzuQb2/GV3zbGMaXZh3HyaS23HbHlSiSbZt0xMf9Ba+aKwo
X-Gm-Gg: AYBFou0QfYTrO9B6/V3zZvPXjh11JVUGvgaU5orWir0vqpn3a5wQIhbth072EwVJQf1
	OR6IVk6IB3jlJeGfbhzzOwxEkmt2cnZt0ABOBEP8cFp5d+WWZrw0H/5q/E9jeR8HkT0UlJH6C8X
	IagMJILBGaOEZhX63jdye2zM4xNMOEvW3mbC8uCMMh5zKy8J+7FwKdYFVq9IxevmEk6KSmhbUsn
	LyE/lnhug1r4f9fADvKd17YHDxJeNIAzQEdCrfWwoEPaQNHgzyTcJx5hPl/BcXirpCgRO74Fjai
	bMF09EASkYtnX68QwjNOVoVTBPXzRdQHRP5WXykbOXFxsoffFM8sZa085heu1bC5gJhUL+hxYIZ
	lupfVjnB7rYtVMydJInasQLY4FLjthqNleMO8nwURafDglhLmiQG8Z6FhulL0ZFpHkfwZ3U3V/F
	gJUkkqn5l6X8yFHCBJ7XgGtKiucgq2UIu7UTWrIulUoevnxt99ghLu6oAzqbU+A4XRQecn/mBhD
	oblIg==
X-Received: by 2002:a17:90b:1d4f:b0:3a8:7242:e8d3 with SMTP id 98e67ed59e1d1-3ab3a2910f6mr3570924a91.7.1791614415817;
        Fri, 09 Oct 2026 23:40:15 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3962f771sm3150080a91.2.2026.10.09.23.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 23:40:15 -0700 (PDT)
Message-ID: <42cdc3f4-95f7-4efa-be23-b3fafae84109@gmail.com>
Date: Sat, 10 Oct 2026 14:40:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>,
 Saravana Kannan <saravanak@kernel.org>,
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20261008152403.766439-1-m.szyprowski@samsung.com>
 <CGME20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331@eucas1p1.samsung.com>
 <20261008152403.766439-3-m.szyprowski@samsung.com>
 <a8ac6daa-e721-4cba-bef3-3333643db23d@gmail.com>
 <81d6c6be-d03b-4fa8-be30-1425c4d1ad40@samsung.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <81d6c6be-d03b-4fa8-be30-1425c4d1ad40@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34111120007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: p5ssgw7fuub3179wnwua7f7r5z93qzsi
X-HE-Tag: 1791614416-191841
X-HE-Meta: U2FsdGVkX19GoIMfGFZdRPBq89Rg+6nGsyVUfP5+zkOiOe5YKk2xbs/61R+vEHH4bD0OzPVFvbZ69aIalh0NPHuZjWUUS7G3IXlNeky8EA9rgch6itvZlnClinasHemdEDIO5jribnuCJ2VWy1sYqfCOFa/9kMzm6ZScr96U4vV/4bWI/zzSl44tkJOUS+qimgIdDcgMACwenJQrs0iTwz+SE1UO8bv1pW56ftV1p+7/uNeDFSX+60/Hdru0TpuLuBGq5GH8EFM/49F1ctk46TlxmE2+7Z2yZJGqbbBPju2IkOsbLgbV5ablcOkAFFJvfFxJ3EFBW0AERK7JHAbDFkSL2ZF3cPk/zTHFO7Wo4wjKE8ovMwFohhke8fi/8vB41t9c/cD77TMEcmV55toQ2WjbvHbsdywREsNsxkauCIRg/n/qX3HNVPKh0uqWFl8bJ3UVvun+lc1+qeV80gJmogi3JVZJuzZPSbqNJ8C1tapO4cpLCjOIptP74BiVviDvey8AG/vXzuDX4EGwiIWg0wbug3+2lPP7oln3puEqjX3CpebfZ+iGJfZhMRobaidkiyAUNSR7TcsZRf+6vN+3a+o2bIGFtG2/IQFiY4dQ4ea3dNV02djSoD/mN1rv7lsIWZrCFOk9CzLvTYn5gQP5QBj74FqwZlJ45/iMrT+AqTs9VdNwLK7EXwn2bigUt/5eOAGRH7lXKZCiVeJtAAYGlzJMHafAua+7O+1/+aJp2HYEZvGImqT4mq53k4vbH3oIl/FalmdsRL+rMf5/+PHyQtWJcvUnr2AORZ+ATTEEC2APB0XNN/rtY5LKsr/kuPvM6Cf79C019Vf/H1xxj651GEVC2DfB2EoYy9xgW3NHt1iSdYuZqjyLUPo+pS4FaNIWCmPeiYmPiNaqiYIqdsuEur17u+HpATgvxRMFFaiKjPZbfwdhpIgMdV8MzJ09pb7R/nvqHMy+4PtqkuKfOzZ
 IEnDucoN
 zTzolUWkdeHr4l9DBsqAe+1TvQBq9FgHo824rfMUUvXo8BDmyy0lRjGWf8QrWXW0121L7w3g4dDKtFk2koBiKxA78RUG4lhtiurtgqEQItBwM7BtITNbhDf0UjEaAAk39kdtWJzkuPdKe3syT/bEELsASLRP4KECOWYmebObrGSOIIwDOomCCUR4Nb4i9tKxi9L3xOnv9QwWO0swxOJx8l5DUC5iA/aitMTvzo7TCnCgFStaG8jIwLhWH8tld2Ku0t3yAtvAtQUB+FrrsLP/6t1f5l4HXuX5ppd+su2A+3ejYQqMJqohnvntBl8WQORhvijsIHSeiC5XskyvhfJnwxn+wRdqL6umgnm1MLFd2FCwijpsmI1I0DmJTzjCegJgvxEP+kG60LfwLW1bOBxZbXyl83a3svqKmuWKhUbXyACHbaEC0HdMrO8+BDq8FVKBgQNnrHlryIkSrQMIpSVe65BLdu5izZPN3FvqpMqTm51/p5ZeyQls/9+UkgY8Bw0bW7dvaLMS0rjGnFIAZKV5V1eVtNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 19:27, Marek Szyprowski wrote:
> On 09.10.2026 04:16, Wandun wrote:
>> On 10/8/26 23:24, Marek Szyprowski wrote:
>>> Get rid of the static, limited-size reserved_mem array and replace it
>>> with array allocated by memblock_alloc_raw() and accessed through a
>>> temporary early_memremap() mapping. Such mapping is needed for some
>>> architectures (like ARM64), where linear map is not yet available during
>>> early boot scan. Having a single, writeable array with all reserved
>>> regions removes the need to perform two step initialization introduced
>>> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>>> memory regions are processed"), so all regions can be processed
>>> directly during the early scan again.
>> One concern about the ordering here: the new memblock_alloc_raw() for the
>> reserved_mem array runs *before* the static ("reg") regions are reserved,
>> so the array can be allocated from inside one of them which makes the
>> subsequent static region reservation fail.
> 
> Well, that's what Sashiko already reported. It will be trivial to process
> 'static' regions before doing the reserved_mem allocation, but this in turn
> returns us to the point of not being able to handle their reservation
> failures. I wonder what's worse...

Indeed, every option has its pros and cons.

Could we reconsider the approach from my v2 series [1]:
record the nodes whose early reservation failed in an reserve_failed_nodes
array, and have the late scan skip them.

As I understand it, this handles the vast majority of cases. And if
the number of failed nodes exceeds the reserve_failed_nodes array size,
the system is already misbehaving and the DTS configuration itself
needs to be revisited; even in that case, the v2 approach behaves exactly
the same as the current code, so nothing gets worse.

Also, IIUC, setting a memblock flag may split memblock regions, and since
memblock cannot resize before paging_init(), that would increase the chance
of a panic.

Best regards,
Wandun

[1] https://lore.kernel.org/all/20260818092420.2859026-2-chenwandun1@gmail.com/

> 
> Best regards


