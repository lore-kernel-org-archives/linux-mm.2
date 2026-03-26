Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB60106F2E7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EF36B0088; Thu, 26 Mar 2026 03:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9706B0089; Thu, 26 Mar 2026 03:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B74F6B008C; Thu, 26 Mar 2026 03:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 379366B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:56:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04B17BBF2E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:56:30 +0000 (UTC)
X-FDA: 84587456982.25.1A06117
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4CB540005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:56:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mh248hYp;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774511789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+W5gqz+rPqP69gORr+nBXsRDDIcM/5iD8CnLmX0DLIU=;
	b=5EcWfLO4c5bFaKbbf4Hvx3QR9sSv7pL5P8Bjx0ch55WxIA3mdBCjoIMBPu6tIGjXr4lVLM
	x0JDoViaubeHuxHXr5H0jV81FF+e+wZt8DXarUXD6tKHbehVGNX226mdObcKnFujaNud/4
	OyfuaEL+WltqfbthyHHgRtl8f0YzUqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774511789; a=rsa-sha256;
	cv=none;
	b=2WA3hqKdQCc03SIwLpl7GrF2XuDkaxMh7ZgtM1W4pDSOCCcQ2hdYZDGzRMcPoBgF1QqFYP
	AxaiojqCNRRyk0yg6B2iyKK8O5poY8IHKRWGut3uMDMbbBQ4Dr2R5fhGFqih6AYhf8FVw4
	H5i27oWR41jDHiCV0AEqnhwL5NX2f7I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mh248hYp;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774511783; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+W5gqz+rPqP69gORr+nBXsRDDIcM/5iD8CnLmX0DLIU=;
	b=mh248hYp69GJbzaHsKIV1ggLJOa+8W1ZbnQtJDA/cK1y0mXTtrB+lZwjSqduEulotHcbD0/5pFKjjyUPnAHK2baPeXw9JjK+fTuYUpr65jlU4GsKyEpoi0UMp358n3ouOZGxfFNsvlbBZZ/BePtTCc0/auVpXLMzLN85ue+Xs4s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X.kcYdn_1774511780;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.kcYdn_1774511780 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 15:56:21 +0800
Message-ID: <6bce7af6-3c34-42d2-afa9-5ba8d63068be@linux.alibaba.com>
Date: Thu, 26 Mar 2026 15:56:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 53mb8nuqygt74fxf46dmpymkm156bsns
X-Rspamd-Queue-Id: B4CB540005
X-Rspam-User: 
X-HE-Tag: 1774511786-753123
X-HE-Meta: U2FsdGVkX1+oMamQ5G+CsXbLQhtw+PNrEbHmP08Zv3jwW7gF0upCzPegVUhtHtiNgTnC+TMAqrySrQTv0XjVFBe7COkU7vsNrcYqU2d3Ml7xnzprzguw7PY0KSQTMcV5ymFrlmai0hzwXjHzni5M58LyV1NHYYc1j91PEIj/nTrmgUqB+Qq/lYCuYZYxljNsxKR/pXP1RH5LupgU9EzcPGAmBxflAJF8zSLPvlrSym50cFRXxhG9LpOkE59+AugJQ4T6CtSScEf8RnNIaJi+JTvXYYcp1GizkI/mW36PMVdbrj7zcHSuVqzLe7IiOylGjDOX51XaGe+OtQUTMXnolVvdsX1zHWFDuG/Yse5x6hxtZws0KwsnMsrcoHtyKF+v/oJjJsCc8YA225/G7MJahF/t5dR+/loAS/0DthniWk4/1IzXp9BffNBoRqyJTzkzAyTfM7xPnM0SK7LuIjFoDP1w4lnPAztz8KHifrqBjrcuzKHZ4ZugBrj9sChP0ypbwoQ/OdMHHfZ3ES/EiSD8tb1+S5wXDP1Dbqy3ma8kcsi29H7I8unzCr0f0teB3Aic152gWXVrHVfUvEf5lZ1E3KM/F9zZAbUzXuomtKYLfme3GoaBj5T4gt2SMqbLhBTuYUwXaDPULUU0nMva28goC5PbYb7CnPfglb3fPoLcOnoRzIXyPSZefVciSb1qds4UV6WoQtH6jAvnK9PqfxfX+fpJj5HAQazh6JYWg8Ijz2ljESHs5uvic4ImE1NOaPvYBwazVyfEK98j6Ek/neM4RrNLKVIV4PfRpAjScNKhBLjCZM3yHmUz9iRN3Sx3/7r+CiUCtSqOtCvfLMd/+uT31LcOcjmfbrMz2Wg6styVleJ7AfBNDKb3AvsJWrwEPpu5NIAF4dC+iDr849i7hycWEZXUybwzTCqzsCyJfxkrJcNDn7P+HOWmlEW3Xu5vLROLnZ31V12E0Sg9zA3wbIq
 TbhImRn3
 D5rYPujNxErvT63v7i4MfgH9H5WbTxyZI5OIJWrsUPa2IKAqXRhuyuflrsOdqx2TRgEmLNPC2fQFeJCM5H2ilDlmRUNw/NwPBaQygEw+d2+dl/tawJA4DkC1VrHD4eVyz3nNS0K04LSRayEs1AMSdg1F+bMfbHH8cyNEbVg/uMCLp2fgqP5E2UfhxvVvrCXp0sgI/ynINDkpPWAP8TEFCXlRoQAhTpkJMEihJLcTHyWS892K3cY2TuwtUIhbzHxyrxrI7rz+kNaTs/zutq74klkVoZ00Z7q5t1tLuuHj8qR3KxPdPCO4RHiceKwQLBt4i91Ty/ElA08aproWY7izf4H6BDMBRJo5BWbFr83kfs6bn8p/qesTjpulniUp7NV/bKsxjSB1RoV39O3Z9teIygM4TDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/26 3:09 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current handling of dirty writeback folios is not working well for
> file page heavy workloads: Dirty folios are protected and move to next
> gen upon isolation of getting throttled or reactivated upon pageout
> (shrink_folio_list).
> 
> This might help to reduce the LRU lock contention slightly, but as a
> result, the ping-pong effect of folios between head and tail of last two
> gens is serious as the shrinker will run into protected dirty writeback
> folios more frequently compared to activation. The dirty flush wakeup
> condition is also much more passive compared to active/inactive LRU.
> Active / inactve LRU wakes the flusher if one batch of folios passed to
> shrink_folio_list is unevictable due to under writeback, but MGLRU
> instead has to check this after the whole reclaim loop is done, and then
> count the isolation protection number compared to the total reclaim
> number.
> 
> And we previously saw OOM problems with it, too, which were fixed but
> still not perfect [1].
> 
> So instead, just drop the special handling for dirty writeback, just
> re-activate it like active / inactive LRU. And also move the dirty flush
> wake up check right after shrink_folio_list. This should improve both
> throttling and performance.

Make sense to me. Additionally, I think there is still room to improve 
the writeback-related logic in shrink_folio_list().

