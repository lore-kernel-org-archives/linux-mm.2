Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54449606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V27p7CPV
Received: by kanga.kvack.org (Postfix)
	id 3544C6B05B1; Sun, 25 Oct 2026 22:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306286B05B3; Sun, 25 Oct 2026 22:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B476B05B4; Sun, 25 Oct 2026 22:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2C1E6B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:31:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 702A8A065C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:31:32 +0000 (UTC)
X-FDA: 85363201224.22.2DE1E0D
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34CC5A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:31:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V27p7CPV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792981890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tmUp/po8zp9IZH++SfJkmavFuUWmlL5Zk5aLDt/8oo=;
	b=njRoJLcnGlgjI4xgP55I+adHBSH/mUxOCxtZAFGwYIbDiOttUPnEn4JgxQWVIzXwhVrqdf
	GEDNYhmc80cuN1GUYy4sEJyUF4fsfPVHHjew3vVJNd+LGP1v8PBKUbX5fCksMrAXQEB25H
	9C+X+LjFQMHzleSHQBtV/xquPPjHicE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V27p7CPV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792981890;
	b=uDyZ9JCsudqJhOSvae9U0pWhs/woXzAhiMvfN4fiFhh/smOKm/qUuhAg8he3TKEWspS8G7
	Is8Twu2lOx97ZvvVmZvOdCfsKcYHqzINudXXzBRGbJ4TH1p9RdFEDok/HRJyZgs4BBbKdO
	fL85w1VPXP6joJGOxTiZTdyEssGYNRk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792981886; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6tmUp/po8zp9IZH++SfJkmavFuUWmlL5Zk5aLDt/8oo=;
	b=V27p7CPVViCf+UxDrTzBKmL41hUTdGQIzB5y1tM9P8NRSLnIaOiN5kXnBvHJSAIVqZ01HWBToxL18Kk7v99qFiOk09nh6C+k7ca7rTRHtJ+/pUh5WW7X75/h3iFeIam4nIEfxEu1Fh0tv6qGiL87BTma6lR1qO8anoRJfkHuOdI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDRaBA4_1792981884;
Received: from 30.74.144.181(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDRaBA4_1792981884 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:31:25 +0800
Message-ID: <39026bf7-83b6-4b8c-9d82-2a647fb9711a@linux.alibaba.com>
Date: Mon, 26 Oct 2026 10:31:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm: multi-gen LRU: use mem_cgroup_lruvec() in
 get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
 akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, yuzhao@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apais@microsoft.com,
 rlmenge@gmail.com, Hardik Garg <hargar@linux.microsoft.com>
References: <20261021235606.89545-1-sidchintamaneni@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261021235606.89545-1-sidchintamaneni@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34CC5A0008
X-Stat-Signature: gxoxywjd1pg1rtcrfrqb1gwu9ijb6n5e
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792981888-858124
X-HE-Meta: U2FsdGVkX1+jWaI4ye60q7mBFS3Vfhhgnwhcc02012H8tPlKoCB9xgk6wuuO6bjlWkhXwi5CWdMfd9h7tTAsbXy7r7mSlPweQxrM3/RfiJSjT3Go2lovE4urLQcUmsNDLz2ZCpfdosJolIDs/yRnI5KCRwExnWEmSFzAkOUhBNTxi2ykjAoPALIWxf42U5w8CRTkBjhWVf74JKHqZBKP2NemhvNnGVt+ymmjXCmPz3vFV/HckJJ+fumwnE70/AmfJgWBGt6qj22oEwA0zBWzPCW0EcMmjeQop//lIYTurDtcKZK+o0tq6NoZ3H/Z813eY6aLgznJoX2xGWu1lIp0O3ADA+soJ8Vom1rUFkR7V6vnIZ0U8hBJxzvbcHf3YQL1Uz7KbZXtTxg9jO4falqu1jYDPTjdvufSQ0t30xypRuAPnjdSSyPPa7RPW9jMgyrdQag1vXfIQGukhpOUZphcigEgAH28/3cJWKbZlFezFbvaBCJWy1VxdV1NAaiK6x5nrGJyTfk8blftPCaIM51FydG/fDkDZY4+OsJcrTh6cm/rDFIBU0RZ5DC4Gf2UvxTcGLrmnOD31QSIeUmLqtsdUNhyxaIe+UQfxPr9rfZoinJcqe6ffWuUJUxHRsA8QMrIZnaoBx9Ud+FRyhdmtzJEYVbINWl/mMR3MS4usUdrFf0FOEik2wdM897TH47v4fVWlQLMyVNHLl6AtdCaBBWwkfG6qHkCO4sEwcCrYxe97eRm9OApEQavMRArx9ajFaH+SmdoTk8S80bhmlbhz3GB3TybzsAcsjGhuW7+29Z4cqaO02LkPuFxeU/nfADCNNfmDJI9kdTKZHxnqCzO7gcQsH+CgoeVMlnFdFdz772iHV+VEPIQtQU5ltAvediAR8ZciGT43x5OD/SXcmpWzOT+tdojbmHlx7mkrtZ02FFWX1fQQnAqezmaZU+l+DBxx0RFUxLZd68j6aIM/gIL+EY
 zxwH1WLU
 RHGBgd3cBPDTgjSeR5b5h8RhhMixKKd66Se4nCSct/FRVOaWl+OrrAc4AgtOoM6T5yZDkKN8jqMEQ0LLd/IMcYHFmjCDM4RaaG6jbQIGazACyTZ3Qf3dPzNX42nVIy2faDNjF5jLyXKyErlOWJGqvj/IbhYHDSNAiWfrDeKTB6CoQIJm10COFRMKOWZfIS39MxEnLcEf20yui06CAIxS2TpbirL3P+h2sK2T9++HTSxPzQtZ3bUb2bw2b13zuIPDtH+d6rzXiNWfHSOw3EbJ7PebG8cTA3uStvfZUvaCZAat4zRb81PPFZf4SnuPWi33jDbwxl+doSo4VZAqq6r+2vDaE3qJmxWnrXmZC5fs2D+TtcIbhzCGG2erp3qX1oOKOAe93bPC52vWUVxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 7:56 AM, Siddharth Chintamaneni wrote:
> Andrew Morton noted that get_lruvec() has the same pattern as
> lru_gen_shrink_node(): when memcg is disabled on the command line
> (cgroup_disable=memory), it returns &pgdat->__lruvec directly instead of
> going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.
> 
> In practice all callers of get_lruvec() run after kswapd_init() has
> already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
> this is not a runtime bug. Have get_lruvec() delegate to
> mem_cgroup_lruvec() directly.
> 
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

