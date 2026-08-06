Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB31C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DEE6B00AC; Thu,  6 Aug 2026 16:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE9A6B00AD; Thu,  6 Aug 2026 16:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3C46B00AE; Thu,  6 Aug 2026 16:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 796C66B00AC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:07:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1449D1C0049
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:07:02 +0000 (UTC)
X-FDA: 85071928284.09.C878DC0
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0E464A0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRcywGcXCD6d1cvCitg8GbORMo2qB7zJDpojkxSuIH8=;
	b=PammLC4R3zIG4SVKjIPSbJmNRC17xxI5RtwY52ZNKDDZacoESNBgE3IVstkKuGcM5CADjQ
	4F67JXlRikbqlFbhK3V8LAatt6yQN2ZJxXW9l2ZVhYS9QAND3t7IfWQPNut21OqwwgkQXd
	uq3Wia45RIGeY7vCAKA65gSfVO7czHg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786046820;
	b=X9MRLDvq73DLtEF0qGeoANcl+cvEK47T0DuHjGshq63DOy0wp39OH/ogkLWoG32pY8kMCO
	pgWqYgCKLlS5tcohw13ccl+HOroNvDR7ipubtBHEl4pvtRajyjOVTruuwVBP9TkhBsMe0K
	CohiCnjFxz78pFsroGyWHIjSeQiXBP0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F70FC0177
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:59 +0000 (UTC)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C1EE1C020A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:59 +0000 (UTC)
X-FDA: 85071928158.14.60944B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 26D1F40012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:56 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRcywGcXCD6d1cvCitg8GbORMo2qB7zJDpojkxSuIH8=;
	b=0bTj9It35Ozk583vid0ALDUlwV7s3qDW02jMRXcCqvDY9xHBCuoMK0kJDBZS6trP8bNOLA
	5wwsluz74Ms+cJ/arQswhE/MsVZaoIrwH7eIJCroIsEcbhD+ZTrgCHzHeDIbw2/yg32faE
	acaXSyDqsVA64syGRLbIkT9QT2+7hl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046817;
	b=ylF3RAYRimVyTi8iIkCXUrz7RUNLeaHTOpr4UaD/spaX/GNU5dAUI0Lawg7deEuaTYJxO+
	el2VgHmfSJgp97Xcx+LvjqPEMANHG38dvFbe+Ea97zyXVE/XEllCxclNhwVE65HTO/SWmX
	VoAbDnP4eTWPhcCeW9yGUdmz2m8dHjE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hIjfUTpL;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2426043D3A;
	Thu,  6 Aug 2026 20:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96AE1F000E9;
	Thu,  6 Aug 2026 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786046816;
	bh=kRcywGcXCD6d1cvCitg8GbORMo2qB7zJDpojkxSuIH8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hIjfUTpLf+KoJs7FTHc0BYi7/zXI3bqkA7ZyYDhzk0cglc5ZdNoz0YTQqpiALa564
	 wei1Unvcy9ce11r/URXCKizBor2+Y82Vzq2wBsexTal0uOZxdDrCigZycF+wYSfC12
	 so8MsskKhMemZUX6A0i+hRKe2h+BuG7B2ec1NiBQ=
Date: Thu, 6 Aug 2026 13:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 her0gyugyu@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-Id: <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
In-Reply-To: <20260806193228.458685-1-youngjun.park@lge.com>
References: <20260806193228.458685-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX18pweycnFuSy+wRRweqsUbQU2q/v9ZOWR8FXku2MuwMGb17b6J0NeZakh+GrXMR+hfoOBU+Ran1yA9otjqV4U63hmS9AQYPkXCl+tEXA5LAHUbUytBkqM70t0N2JeZ5/TGFuQUlY2lMkmDVuaQOq6XM8YoIz74znQHpPoWE6KtRD3GBSMJjF955KgAZbjV9+iR0h6H7sAp3c3L1T2z5dH4mR8t150/bnnMl7IExQiCAIic9Ek+as+Ku0fxRzmByl18AX+nBDENtF6GNpsQXGNyBgG1+6Zh5wt3bKHDXAyOt8X7cqm0OZ6VX3mRt46OwlUIJFkhSoFmMgxbqk58gTb2Vn/BaGG76Ng2TXuhBnUEAi6yPARO3z0ds3jx02HK6skV/yqZoMOddOaXngxSTXMNKrN6bdAJvJdVlYandmq6Iz8l7qSu8mhVBI5R83GOKQ89oD0mYvPnSZRrAIy/CwEbSahOKC82XSHb0EVwm7ySO2Z3ahxzWhfdGH5XrrtTGJtKHcDT0VgSCCq9aajYjsf+HDdWydyhOHp0tFysA8hbYHdaS/XMv64SA3DE1X/VzRnuzfYFlOUjNJil5NVHNtlSw/FWjuesUMia9hAEEG6JIirRNbnpAzyZaj6GY4Yy3E9EKggCV5JvvMmkTOFBiot33PG4rqMSMI12yXs7OuVgyDkEBwlnXWo816Y9I+elGbmMjdF4JLsPTLbFrA1+67yI/q/7uaCjtFZ1CUE/ZRVYXEFAT9o1oUyF7jV8TLTcH3e1Trj0xnjHvH9HiLWEUXbsT7Pqzn5z/OA37ynxLRZEbxDTy24Sx2H/TZwh8619OMRuGxVHvfaORlPOlaT2/W2+jqAoxNYvUKgKFTiCEzuHYwfDxGXgNp4Q+2Hf/o8OLHrLskbJrQM+ElUR3hXStUrdVnxFL/JJVPaT66RRGKCzdyOEsp/gGQmIpuy+76KKSNw7cRTMmVwc
 s9gbDyA9
 B83cHIcV+jHtbLVMKsqhfnz0C/WASFhkUk90m3nutcaK/Qy1jN813XS32OuAA5VIcwOtZsll5SEeISGM61ttNd3Tuz3iltlZbyZDm2VxZkrtTN7W5XMKxgUc4wbZB/ITLwJBfeaR5J8Rmm5rnSkWCh8NXT+dZ8NS9idAQ//hKmfBl6XZylpIBxMWH2q2g+76zzmSfIHGCrAEAdYufpHQ2U0IZcGUX7Dcf/ca53Dbrc7nYXKOe7J/FVSHxY6s8Lqj80Puyw87cGN2KJRHcJL0AjW5bog==
X-HE-Tag-Orig: 1786046816-290129
X-Rspamd-Server: rspam08
X-Stat-Signature: 9g4znz93d54ugz1p8zaamsnuz5chn7up
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E464A0006
X-HE-Tag: 1786046819-539645
X-HE-Meta: U2FsdGVkX18qnTOdhIABsiWR2BPzk0Der8kXj1IDZDpzfeG0n9HMg30ndu34CxAvIiSrFWyglsrYwrs68oPGQLfwSt1g6pVix8gu4uW+LqYyDLPUjJrkj5/FytWPyWbpVifgqWK/ycan0MasTC5TocbkLGh2M2QFbzOBjWVio3L8i+QAltCUqaYRu+2cR3ANcLXh0fEJaGT+pViuyDmftp0jvKFHvj7YJ4sD5EWInL78oFKTHVNN7oo2++0XH7WdaXg8W2rZz2W2zxz46EpEdNLW6S1wLbuQrWQXRhblY5Vt5dinIQJYaB94q3gKUCCqA0oibLm/OkTMaGenK9cai0G6nruGJ2MKO0RIbWzOqgwI2JOZQsQxQJXYY/l6iNPyiNLI7DtGc5Nsk7yKAR+XFjJlqvv459IOa6CWCgiwtvUg6H6QnAHFo0hcMXJtSZC+5g8TOHiKYcdMJokdv/8P8guG39g1obCcnUJvpCIwiuB55FSAhhW2AEvN2uCtg2f+880E2OyTDrTrK9h+lArxhU4USPaop8VXvxPWCB5b0be7Av1rnYwU7BvbGxKLHcvyFl6gyEfKjFTZlBX+a3TRRTjoBOEMCnQTCABShpz73yN2zQhZwrkF+YATGmtrdjqxczrAs79iGv+l6aOumbUVzCow0HNBiUz7iFu5ZbDY0C1k70vTNkuuy5ySMqoTfG66UFq+XimQ10A46wH5rffI+GTIeluc6Rat7gHZDpKEwebPo2iiKEjCy+rL2Wwe21D20wm3zT8h+yOb24HSRWr1aciapYlw2DitXAnrJIjD9y/0cgTHozikvqU7IZ9KpnARhIi6dZTlR00KTJnVxDxSLlGVhTRZM8zbNIOBbY8nlIWPgGe8WYLRkXMMUgf50R2QChIovzhXrs937wr2NemMXuL0hniizai0uFIC8B2VCGATLfytLcNUGg/ybeL79Q1AT93tGsp8h5WZxKhuPUT
 Cd+JaPOH
 Q0NBMBZO1hTFpiuxJhwb+FRsDUdbBdmw6obEJvO/tJtuwDoImR/YhGj/zTXbU4Tk7TjsLT510NUWNiMmTXrJLtplxTgwkAUdNNSu7kr4zLB4i5loCDFMFGQu5wyexSx8mljX/uVQyDNs9dSqafg9Nnyg+2phpC9BNr0pwwY+HXAFgWqo3UXQW5QnJf63iB0mU00JX1tWuCvbEYc8EU8y5qc8L5ATipnXK+AOVR4cF35Af+J8qUfIiGNZH+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 04:32:26 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> find_next_to_unuse() walks a swap device one offset at a time.  Slot
> state now lives in a per cluster swap table, so patch 2 dismisses an
> empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> reads.

Thanks.

Can you help us understand how significant this change is for users? 
If "not very" then I'd prefer to defer consideraton of the series until
after 7.3-rc1.


