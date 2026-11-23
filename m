Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB19606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AH4TBgs3
Received: by kanga.kvack.org (Postfix)
	id 3599F6B05B2; Mon, 23 Nov 2026 04:11:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331316B05B4; Mon, 23 Nov 2026 04:11:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26DA06B05B5; Mon, 23 Nov 2026 04:11:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02A766B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:11:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A1E51607AD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:11:25 +0000 (UTC)
X-FDA: 85465815330.21.AA84700
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17B4314000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:11:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AH4TBgs3;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795425082;
	b=1eVKNokOBsA8U9jCPRmekP7cjneiFac48v6phx2cDal8oeUqQWGgSr+mv2z4LUdwSGVVdf
	QIEttClfw8r/d1b9CHLnHGfImYC3BKcrzKOE1wLuw3Wzfhd5z25PjRM2rD9pkw/K3WjeMQ
	CaR3hK1t+4fLY3G5mqirA6ntvicZJAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795425082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac8gm8BAflyZQyZhhIITxaxPSlspaqUNqNNCAAWfRPo=;
	b=7qZCAxZVXJeBWXBOS+fMLqocR3jN9JNAaNSuDIHsTfuqPelPs5nPWe+X1DzzT7WTzmMcrC
	o8BtvAB6sPW33zDWl0IxD0wWzNkZcDZFCnXqbpf9sz/mYyZNRMtbjWzd4NeFn+ctqRwS6o
	wJlJyB3JyiBUzzbrqvetKzNQ9svydh0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AH4TBgs3;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795425077; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ac8gm8BAflyZQyZhhIITxaxPSlspaqUNqNNCAAWfRPo=;
	b=AH4TBgs3AMx4k30rfihnV+kKEQrU7vG+r3OBhcnzGbyRit0EZXO0UPSaAjPAnggUDWWERPw/SCLnCLPF3l02iqnDaLTzTiCXNr1NjNHSvFVvCcTx64q5DzepESBhPzgW5Lvt7aP0365Dot62BQNB83ygl14W7jnIr2TI7Ose7s8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XFGA2m0_1795425076;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFGA2m0_1795425076 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 17:11:16 +0800
Message-ID: <48e3657c-d29e-44cd-a235-c93051520674@linux.alibaba.com>
Date: Mon, 23 Nov 2026 17:11:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
To: Fnu Samridh <samridh@modal.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com>
 <e4c0fcf1-b70e-4d22-9c4a-5829e1438ce5@kernel.org>
 <CAKyepcSuZ49Nv2D3UGC++-niYtfMcPEE7sjAf2SSRx4KAy1oGA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAKyepcSuZ49Nv2D3UGC++-niYtfMcPEE7sjAf2SSRx4KAy1oGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 17B4314000B
X-Stat-Signature: dnna64mp3b4xougnsghkqhsniyutk9u5
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795425080-636175
X-HE-Meta: U2FsdGVkX1+jdXhE/78TA1zNwaMvgndxi9nxr2GBnmQUGDM2ql3+61dtPNtwYAdVf0BnLH2xTOyGKdrhN4ORH3DmvviI19VfYKz4GcNcYJi5YOrZcSbhHisfnuVwSoEzj0zGsTV6WDtJzh5m57QmiSeLTrQXKMVuN1grLLvhZT64ADqQvl5A1BcrAWPFnpp17B8zMGP4iwj55hhH3gUGT3AvhrQZGr6LaVuofF1/381YZIM4vP9UxFjp9e16cTrcC+fJfjHsnTzqkeQ8FEMMMi11x/OHYphTGKFoVE28j4CN1SOritMxrtjeIElDqcNGtnby1LSfnTd+c0Nh9yzZG5gQWYzWrbC4sba+8zkTL1IGpm3rZLBKgP8u+3lOSRp6CyNkUKG8net6xhjc4gHGBH7oACgrXssybBVCiQ2JsPdiSGc6czkU+AJQ3MosZ9JAclDiTPUzlHu+HBdtsXnJCblNbvlffwhKh5Vln5J6AI62Hlzt8qDjsiD5fuU2JhqrETbAuNrRKdbmkeTXKK8JNR46xzSHEvLM8LT8X+n/NJU54oJ5pQFEQVxm8hPqABAHRikYGunI3DCRUQY+qEr8sHFapIXKH2kih3dj7QKw1JX+urxu8sPPcIksca2+ozX4LVm3Y3hUDSl+DbXtpUdu5zpSetRuZQ1v4HO8M4vvKynuHr29/c/tWeTtyUq2F903jOHshcL0L/ec9Oa2JKB4mJJZSNlIVDXJtlOu36yGB0espECEALc+NSB/AI0+Yhhnp3Ka7LYiy9WE/OJyzSgYYh76jk4bwAfBy622oDw9sZS6fHCTWFKK6haFoaYgCIPRZrljcuB9EV8pXQ+4z7sWza2dHkunxPFjwaaTY1ECsC6pAnXNn4J/Af+rhL7z3p9RJRBOIR4WpUpWgGNsbqoA239aP0g+ifKRCxgaFm1Hwbt8JcU3NW+/TkNtuyv/vfqmmgFhWyI6vWpCzg5Tj7Z
 k5m4m/vO
 jl77O9BIxmlMe+5MbPmMwmHr8mlvhy8Uii/kBwZutIUqzgAoS3Swq1i52Guknt4njzhiGBdW/rE/XYCdNBDFHq9y8bCYqff8556oL276M52ydV2UiGMxgbwQj8iH47RlgfhgHmb47W2smJIWkF9P2OzG5shKbs98yoP3KuRwWBo6fa0D5jvXc7mT2A/vamnmE9ApULPCldyM15SndlutK3p8nlD9Cr1UyVCyvZJ3wfaT+3XayvTDXtvO2fpkto9F+NveHFBjdU9hSurMoDIdzeNfIM9eHY2oqkFAJwtQpvM89sZufowz3iPt9mHruzTTSDXbhNInG/J10Afb1C1EDTXibuaueuDRy0iQt/wWBg+vtQF3RwO7a1qNfOkF9mOvr92jXfFse03QlTVz9z/KlrG/lX+zYfb5uxGy13KP1agI0fIADw98yLf/7lUypqjmrdqYiEUmgWXVV27L6vM5+d83v8JTaF2s/KIdkNjYKLFwoZdwNH1olSCyEww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/21/26 5:40 AM, Fnu Samridh wrote:
> On 11/19/26 18:06, David Hildenbrand (Arm) wrote:
>> I do wonder whether that could go into the loop, because I faintly remember that
>> user_alloc_needs_zeroing() is disabled when CPUs have dcache aliasing.
> 
> Yep, it always returns true on CPUs with dcache or icache aliasing, so
> the flush only matters when we clear. I'll move it into the if block in v3.
> Thanks!

With that addressed, feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

