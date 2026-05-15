Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E6FCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33436B00BD; Fri, 15 May 2026 03:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC836B00BE; Fri, 15 May 2026 03:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB2E6B00BF; Fri, 15 May 2026 03:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85A096B00BD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:24:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22294C053D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:24:11 +0000 (UTC)
X-FDA: 84768815502.09.266FC65
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C8612000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:24:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DHs8heJl;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778829849; a=rsa-sha256;
	cv=none;
	b=hkuW0Qhk5GKGomFcCEtlc+DHtpNU7bhrVOfczY1Ne8hOkM0il5hFavpn9lKeIAShnKY4dB
	AfpVbcwHOX4u9qGUrn3eS5pSUMqzmbe6prgjyHo43w12IyrxF0Qda+ObQ4QEvxgAHVaHo/
	h67PqfmEOvfRfk7Slsh1M2DMiyVnlKU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DHs8heJl;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778829849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BQWalTB7WrDJ6Z53lviHBLjV/r4fpMOX4vRdUEy52U=;
	b=5Q5/d4bk5xcqyEx9bgVhaSNEJqVLtkTZVZj8mg84zLLZZaWCEIMW2dYFnWS5o3sT6+AXQm
	757S8KT+PoItXe635RUZlZPvlCrZTB9CPlkcmBzMdQ+GjyId7uQ9ifuRekYusLQ/KZl48j
	JwV2VVyoZLO5yyr+rlHnJInNSFNlQVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8B
	QWalTB7WrDJ6Z53lviHBLjV/r4fpMOX4vRdUEy52U=; b=DHs8heJlfJtLbU1Ajt
	/jDHVcfgRbc05FA0+XwxAFkcvTWoc7b526a9mQHwg1hoB1EIEPxmH+8i/PnV19lA
	RkVBTEzmMrp/JAO+ORknAT95+O1NvrPdY/zMQmrCnVdhkRRtvF/xJrsq+aTrJROl
	33bOb2C44YP6jdKF/AlFWC2FM=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3n+z4yQZqiwcBBg--.6646S2;
	Fri, 15 May 2026 15:23:37 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Fri, 15 May 2026 07:23:36 +0000
Message-ID: <20260515072336.53287-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agW_BR8qNsxzAKYi@lucifer>
References: <agW_BR8qNsxzAKYi@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n+z4yQZqiwcBBg--.6646S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWfuFW5WFy8Jr43Jw1kZrb_yoW8uFy5pr
	9rJF1SyFy8Xr97Kr1IqF48Gryrt3yfJw48try5Ga4Sk3ZxXrnakr1v93yY9a4DAryIqw4I
	vr4UWasrXw1qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpa0kUUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hnMGWoGyfmI1AAA3i
X-Stat-Signature: g6r3ze45ndr67zcyqu6y7dinotdnwkwb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C8612000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1778829848-282838
X-HE-Meta: U2FsdGVkX19hg4AHvvAK7Igg1FEw0lMCnJHLoVZS+10DYGf851aNGTB6JUo8zKdg+uF9FLfQqhzywDSDdaPnmVeKB/3teJ8X3wBhKl9Sq5DtGlfvDz7j1p51RU2/qB3Vjex/BMZYDR1I5dOByGVstyAEGhXwG05pw6axrwNckSka1BRjWxr7xc4Bb1VtywBbNcCpV2bg/2mTdgxxfwLsBdLAtxct+s5zKdFCUZSwZbj3i7AGRJTYOSFJ4xd1FHO866Rn8rVzllDQj+/5G+1ws9FXaHseoOnYMif2lWpUUYrO12/rT5bjG3paM3WUJ4xklsaqzDf1eBbmFb6tpR8XUTlHi05ZwS+3kajwDbKn5sBAfuU7PeoEfzjK51fy/k41CHsO0KbRPGWXgzzn7dS/pb9fQZRWEiqSDXMfmV4q8H5o3KDxljQaaSIS7RMyaDR9ltnzIzxIwV/joiDAVLNmng27aKrkvQzinFU7+yWzxle/mFozk1zfO85AwlMeO9VBhAisY2pz4k/wZlbQ34wqif8Ab2zO7m+MUl1SRLlzzl0EC2ub9SURaYh6oB0WR9yoDJuy4ebfmEB0yPoA7ImhVVjiwBXWgQUtwJfdm+7mouG/XVqXIMovwJsbO/+eISUQKH3Dk4ndzfku+dleb9Nf2tXbwfMqsw0CKu9yq4yzruyv4lQEKpVQ9K+GYqBfqQPre1dRDTqvQt5kSfA8RMz5RnY2n/9fK4/6Fo6irpsf5VT/1v3yugNQ9mqnEHECIF98fxLty3GB4qhDk2Nb138VY4ykfk9cA07iNoRaFGQ4vLze6Qstu1Wo6ao9g1Svo4utdYn+DL6RdtS7ah+Xee35FjgaBhBUAzpB8Egq1hSsjSmFVH4GwFODGF0wjAY5aeIknw/LvCB0XgW5qCvZGZh6jLiwUWMWvuImdZQ6sx6jYLFxgHswPMDsx6pU7ukCz1zHCIlzVq1dzXAHkgBSlC2
 u4YwJmNB
 oJgYfPYUylwKJ7CqDudQVju+MJFNRKQzZt7kZW66yp6v5Bci4KsAKrTuFfF1PY+sNWyaXxF94+l5c1ZxQrUsUw59nUQYu8kb8NpN6PY/4dLWoHzLmThQF/HW14Yy5+bxmkCzfIKA/GmJCXIsQfWdGxU0KyERzKsXa80tskxlDVVQS4DGOtGJaNmWIPkRtx88lPIB1PY2CIUtmXLMc3haVgfJA/KcYZNMbxZPWm7DOHC6bGX/AmS6RwN/xRBPBtP5InmwOPTaKEYcS78ab1D5UMOzubEnYTCujRSWpOvZhsT4QuqQHmju7uu+RVmQME7to1AZdeRFR6lh7+U+GwLtuNMUYAhUnHLVf93eXcrdZQjhvSwvMmkLgtldntqTptwAwgn8DI+zXHsETRKO1Eh4KdTBCAkJMNhVMGBE6X3QUHWqHn2XDtFB5C/74FPSsLE58itkDKLOTroFniXmyyNPo2tUDDSbKFmn02DUEDuljVupGb87pYYymy4FdAVXtL28OSwUXzlGC6T9EK0pGDVVDagw5yPVVDQVNef+P1kZ7jFx5WFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>
>> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
>> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
>> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>> +		return -EINVAL;
>>
>> -	if (ret > 0) {
>> -		int err = start_stop_khugepaged();
>> +	spin_lock(&huge_shmem_orders_lock);
>> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
>> +		if (m == mode)
>> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
>> +		else
>> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
>> +	}
>> +	spin_unlock(&huge_shmem_orders_lock);
>
>You're copy/pasta'ing anon_enabled_store() but not the nicer refactoring that's
>there.
>
>Please split this out like set_anon_enabled_mode() does. And put:
>
>	static unsigned long *enabled_orders[] = {
>		&huge_shmem_orders_always,
>		&huge_shmem_orders_inherit,
>		&huge_shmem_orders_within_size,
>		&huge_shmem_orders_madvise,
>	};
>
>At the start of it like that does also.
>
>Please don't reproduce the single letter var name though :)
>

Arrays huge_shmem_orders_by_mode are shared by both store() and
show() in patch2, so we should keeping at file scope to avoid duplication,
what do you think ?

>> +};
>
>>
>> +	if (changed) {
>> +		err = start_stop_khugepaged();
>>  		if (err)
>>  			ret = err;
>
>
>> +	} else {
>> +		/*
>> +		 * Recalculate watermarks even when the mode hasn't changed
>> +		 * to preserve the legacy behavior, as this is always called
>> +		 * inside start_stop_khugepaged().
>> +		 */
>> +		set_recommended_min_free_kbytes();
>>  	}
>> +
>>  	return ret;
>
>return count;
>
>>  }
>>
>> --
>> 2.25.1
>>
>>
>
>Cheers, Lorenzo


