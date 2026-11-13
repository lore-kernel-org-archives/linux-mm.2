Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA245606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fFXXsTut
Received: by kanga.kvack.org (Postfix)
	id 031C86B05D9; Fri, 13 Nov 2026 03:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F242E6B05EA; Fri, 13 Nov 2026 03:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13586B05EC; Fri, 13 Nov 2026 03:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA2F46B05D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:55:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57D441C3C16
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:55:50 +0000 (UTC)
X-FDA: 85429488060.07.552339C
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D7B7C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:55:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fFXXsTut;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794560147;
	b=WhjU8SFpPPqDloGerZsnNxgedjxuh16+v5PJDl0QZCoH62JbSSQ7ah15ijUrzpveuztWe9
	ShmCTjtaykya3dX8mjRk0RluVhEGalKubKpP5SiqNrK1euMUY/mZbT/DjKgxcT6D3P+Z/J
	tLZqDIjVu4UkSes2w6qawfrxGkdeYVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fFXXsTut;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794560147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbWpqpVEiuE3z83GiQA0YLlwDhjEJ8fHQ7f78aTTUNM=;
	b=Rp5SCpYNut02XleJywgudEG5H9GdPu+Ywn+nn8bQerePV3iD75d6a4x3u835lkUUzCdFTu
	tlcaHLqlIOUku4JsVufIN0iLRXRG1j+1bdgBvAfGwrsYVDqDoUoMWyUJkg9+ndyR611H5J
	3fR5a7H946H7V9zz8BUAaM0BS9Z8MR8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794560142; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xbWpqpVEiuE3z83GiQA0YLlwDhjEJ8fHQ7f78aTTUNM=;
	b=fFXXsTut4QijhUWgRBPgE4k4sELZIkJ+h2qiWztIOms7r5LNojCkCMAwyk/0517mCll1+vPq2NLGGiKWvJD1+06gG7RR434XgNYZKbBruVfGduNZMt2QG9UP1TNKCO2Yi5MhIySuhEcQmQs4A+G+K0dDC7v5pU1CzZNOnQP+NVQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XEeeDi2_1794560138;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEeeDi2_1794560138 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 16:55:40 +0800
Message-ID: <79229fba-8019-46d6-9cd4-a24a463474be@linux.alibaba.com>
Date: Fri, 13 Nov 2026 16:55:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/16] mm/mglru: report evictable sizes per type
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, hannes@cmpxchg.org,
 hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com,
 liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com,
 mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-2-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111232603.9934-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ya1rhnkojr3fdcjcpmjah7jj8a6k61fe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D7B7C0003
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794560145-131263
X-HE-Meta: U2FsdGVkX19nKij7sBT35uQxEwQVVSzSN0Q1G0rdG86HnE6Png5qJIRvaM8JHEQB481sSZKnEonMSnzst65oRahoIZdBtmwcuS+Cmo47tXjdIHG35S+khWzCnzoQoZI66x9gDIh4LZ+z6/kLMQboIARBn3GdyMOxefP5oQYoasrDN28jykzlF6GWd38H9hkrN/oTeQnG5nQidnFS0/kQdGahf9H+noySbXyM3/VYFUjUWfsrJ/Adgb+fI8toa8TKH/OeH1m3zExzGJGrrdG4lqU/C2CEAJYXZeXvoUSl16mGYXVsh64OmQdZDN4EPl7JfPNztoedahxZAucySthkqf0SIgCI21ATeVZFU4qseQCp6kD4jG5mgqNdRQ9YX48We/MrZiKlq9l0N8ovIfxsxb2QJ79UyLn3KGdrF1C+CLgtnfc+YF1hbfDQP6mzjOmI0iTB3zqEltFqi98oaIB7UPBq+ODUhrv+BQ9wunJRhSdiNas7r7WQsrVMuMxPwkawC/YDZmHauV9pPZv9zqK+UMHIMCKg5iteoJ3Hq9iQCSAQ+zkAKPU88DHudTAj333eNotAKa6LKnBli9KNy3KcMbmWkKmBz1y5y0US986woduj/21ObufzsINQbTxwzqOjZrQxMVBjxpgcy22Jpl2+P9kwTBFBju8AlSHPKxn96kutW1ou0tgOQtjRAxD1iM5aXXYX0yexq/CWkXd+EPTP5MZLyUozdnSQi5QxgmyA+YeZ1igrhFtt82JLnRH0XlpIgTrl4h68zvezxVXeDwvEjVyQwGnUrBTeBZlV813yFmBRP5QJKa1IZDsUokZr98MmmEkYqSdclTaByZBdfolNq1mLd3ZxcAAXoDNZyn4p3Bs4atRm4HZbi5zCUoyWdDYGY55mv0Lx+WamVN7WF51OuLY/QGqNEo5FbbgSY/Fe9VOxUNiyAGIUypT2oZTE9dR/HQsFayTPgbyshJAGZW2
 AiMbx6s8
 hNEd9frbvutXQdR4MMI/R8splEaap3MEyxdY4h3eF5TPR6DzYvp+G+Pt6DmEFlM8wpakVh3AX8Kqa/VyT4P+0Q2YMyj1I54OgL+VFfRR2UDYQ0l+7NSIZJQeqXRIKEk1wytBX7rNszwkechFngtp53pT3KmHAA06UX3xhX+a3CEln/Ei/vm/JR9ozIQbFeEbC8gHV7HUGv/9KTKgcVkIlKEjiOiEg8P1dyTvpg+AAvovzboWn456pG2neffhpF9E+QuIzEmR5xX9gPFclX9cB/ZiorbcUE8bkCEhFV9kK53MRNR7uK3hUz6NJV2a9chiiexufa1pZwgc4Dj3UaskkNapw+gsw7Y+jhEbtIyAhNGbQ4sDFTgxAE4Qt38KkXlK/BZIu5ML2cImcOpV50qxrdY3iRragv2GFMuAy2a9wDMu2QWsf0LBuFUN6Sx41rFmbe3cY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 7:25 AM, Barry Song (Xiaomi) wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Change lruvec_evictable_size() to return the number of evictable
> anonymous and file pages separately instead of a single total, so
> that callers can weigh the two types independently.
> 
> Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
> summed totals are unchanged, so there is no functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

