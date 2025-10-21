Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD7DCCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 02:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224A68E0009; Mon, 20 Oct 2025 22:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5688E0002; Mon, 20 Oct 2025 22:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC578E0009; Mon, 20 Oct 2025 22:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEC238E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:15:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F456C0387
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:15:18 +0000 (UTC)
X-FDA: 84020504316.25.BCDE09D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70F4710000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:15:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J519sp9y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761012916; a=rsa-sha256;
	cv=none;
	b=km8PfZyi+v2wDT2fXuq0C6bh+O8JRxJKYeBIzYqBZR9NvNt+jMZdF+heqLJvWke2ij2/io
	mdtNgQ52R95AiHBd08eI//i615GZ8EDJu4vTSP+B39+ZI1Z0hj1MqyJNW+N+wCA+0c6Vhc
	+f3IkiCqee4Ea7LCq8tXTJuhkZTBjw0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J519sp9y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761012916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfvaitQHko0T9y9BKdTgNOOZmOpTbCeZVw+TE9cO9IY=;
	b=pfN8aHyAjIgByb8po2XIvyswKk9Pw/eTmwHCCne7HGHiBTecJyXPQF5ip145xxyN4poZ+f
	O7FERp4a6x02BzWG/EEWXzdDO2UfYR6JrSZpU6Hc/ZitToVy+pEhnl0rHf0yFij5E8ImW1
	BRODnnFMeJB+WVjIfDpaMVsH/Jb/gSU=
Message-ID: <d36c0e8d-386b-444c-bd6c-ec9439778e96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761012914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kfvaitQHko0T9y9BKdTgNOOZmOpTbCeZVw+TE9cO9IY=;
	b=J519sp9y27nGBlbS5dV5jMsy5LarXYr1fJvPmPLe/no8dffuqDk4nwH8BFKwxctENR/wDS
	7DaMC5qjFvC1FrYpKHjv2uYEcwmRBBPcOF19kP7j5GyJL+UPqdlDkNKbzFP/vfSw/xpX7A
	GbuMtZai9KpNzvb1dWs62rdHlif1DlE=
Date: Tue, 21 Oct 2025 10:14:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: Factor out common logic in
 [scan,alloc]_sleep_millisecs_store()
To: Leon Hwang <leon.hwang@linux.dev>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, david@redhat.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com
References: <20251020115350.8175-1-leon.hwang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251020115350.8175-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qkan9pe1r4u6dpsuojtwajyborh5qb7r
X-Rspamd-Queue-Id: 70F4710000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761012916-448817
X-HE-Meta: U2FsdGVkX18yUB20i9gGBHxh+ow2HpxayppRMxrDAu1dPrwBfrReRjH5i8C155UT4K2xRYYjQbETWj7aJKSGbHAcVCXHZ7BjFWKGsrnG5MX0AmXx0fiqkh8nTLuslaUC36cNcvTwj34yDDGqCqqtkp4j/vhmA1ya8JsA9gTXrKxn+pXkIi55MlfNrKNw9A0iJrNT/ICxFBhsxWimsyUZY40EmUdwcKPYVp2D+N45jvKouytBjWLTkMaEypjKjLvOWgXn30LEbIXiPKCKimU1HCdJGjzX+kjx+AEcCrzHODM55Q5UxS0Gm2im9zkgVSPjz35nBGGFUd6k41rZHe3hyAFlg31U5JsN+0fFBhes6kkKx5gtt61WdbGboPl/xZAdqWDRRZSYotf9qcx0G53nT/a7bM9L4/fC4qFXNVgyYcy1uem/7n+hTtoU0IRDNoMqZ7PfQYkmnidg1jvsCaLzC6+XhxihzWuhjAor0VIad5VRHJAVwZk3s5h0rjs1qV2byRVrni6EGMr9QtvI+Wy5gyEE1t9h4WdWzfJdX76FyxhTyxcb3qAtwkMyfBr+8reIrHFzYMjlFd+NTQbdcaKK43wvALl7SLc//L/arm7WM2by5S+kI7yJKoYrAzi2YKZW02vFiKWOwTajiHTBvvJ9Cig9jG0w/8g1yH4IBLkLkA/qNncXB5p59Yeo8YNZ+5rZBBkBsnrQ/j1Vyy71mCsd6/3xw/Qu0UqSvgAggKTxsqqkAAFwqiY6/VEZunR0pX7seMHR5chjKMufuJ765F27hfgggedhPkv0I7skRpc0l9l/oPsv7rBEEtBveGtndaFArS9qF6LKbflLtG9vRTQd2sS6W/E4jtbY+m4eNMf0CiQEp+GadiZpRmprJCt+rocr/VOLi4+V0bLcJM8jsgomBlU5MFIchU6UMlDDH4sHA/AQCkpbRKzDOtQzcFwfCqQ6ejmbnz9qu1wdqOIdrZY
 rf11vI+n
 rtKz64MnCu8N4+QpJGaGltr0ddDtnUqZfRJzUmXBw+nEzSyIKx08f/mkQ/nOjBYONrl+VCABlCqwLk2N0yrdAdk6p4IK9/9ElcwB8d/fMU/HU7EHYXd5fhyywks2cc5XJM1lG6v+Y/F4B/Jldb/6Ts3PcjtBzZspR/mee7f5PzqM1N6M9+aLPHQfor3NMjc09qWW6OfUfytD1Anl9x8muHyNuO94Zg/agvKcuKurC4GLyKKF8U3kFvmZP03Jt4KzqnsX1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 19:53, Leon Hwang wrote:
> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
> 
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.

Thanks, less is more ;)

> 
> No functional change intended.
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---

After tweaking as Lorenzo suggested, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

