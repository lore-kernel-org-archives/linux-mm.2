Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BCA606AA24
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=O2OimBiv
Received: by kanga.kvack.org (Postfix)
	id EDE5C6B05BE; Mon,  9 Nov 2026 22:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8EEE6B05BF; Mon,  9 Nov 2026 22:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E696B05C0; Mon,  9 Nov 2026 22:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1F3C6B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:38:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E7F980763
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:38:03 +0000 (UTC)
X-FDA: 85417800846.10.ACD60F3
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BABDC0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:37:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O2OimBiv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xR8GHVAswiwBZf376osv+2IMiUWvGBbfvXTQYVFuwY0=;
	b=EUSB2csbrdjTq0ALMjTa+reqQdRnD7wIvoh1AVLOyU/BxT+HifhpfT0lNIQ72BXtegvYVS
	I1SrmMhl2Vm6Jg1B3YscNUKaUNoft4XzQY5/h/0tOOD/wh5PPYWnwg7xgs04RG+BXKd1xV
	AOaeFWiFxS2bjMKd1NU0tcpaPjy8X6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281881;
	b=HLVbtQz5BlnyV0Rxb0vM/8VtcHYzwW3DZCLiE+DhGM3j+qQ/a9xHZOwq+vnkl2AVbv8rnP
	aiko9OnSBLKgUN5dmynEpAqVAdm5Y8EgO4Mj+9ZufmSm5G1ksu3izCWljJEJKC1/hJYqlJ
	qDdsxpjvT+Ji05p0EGsq/idobgaPFs0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O2OimBiv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794281875; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xR8GHVAswiwBZf376osv+2IMiUWvGBbfvXTQYVFuwY0=;
	b=O2OimBiv7wuCx1ZF9FK7O9vmTNQhLD4tFL6VSiNan6m7UWr6JzOqJrz0oCWWTdB73lNQEbzd07e5UrtVW1ghjKNJuaDZEsaDlX2Tj2fP8gw/P61YdLnCvF18WMChikbfZnfzTiDvFQ5ix31VwU0nOan5sdxZWKWTj2ltMpM3LUo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XETsyWO_1794281873;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XETsyWO_1794281873 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:37:54 +0800
Message-ID: <56b4150f-9e77-49cc-aed3-365670d401c1@linux.alibaba.com>
Date: Tue, 10 Nov 2026 11:37:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g33d65rg6fs7i9ejz473xhr8srgnguiy
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BABDC0004
X-HE-Tag: 1794281878-71034
X-HE-Meta: U2FsdGVkX1+4XrKsAtkQTtJAGTMZBBG3b13+2ip4LMpG7aAjjaYJUjyq28HBivn7+JQMRWFKWrvjLVI94cZ34Hc3B5+g4A4oney5nuHqoLt7i/wZY6/o5Kdvxzd6dBIlNkl3f0SMlF4WZjXvxnpNKE5ctUPrrghfcKpUCNeBW7cbhYmTD16ezu3U6HKomLG3U2q6zNMu+AYgmAgDV9RfakfnQin/Rr/6Q7R7V29v5xcUSR8RGw56C7lnlvfKqVM6zBYuE7DiSb8Ie+tk8T0pd4vbhYaZIDJ6ThhucO5VAStwFPnXLgk6aQyrxkHlu1ewGQBFxTTjDNoRuJKSXJawVWmalFV7uZtWQcU5w9wuwbnVVOt6BdfvZ5+oNf0qvg3mDlFXLIOLgEPCo90FJtqDjtmhUIQ8HB31p/xKqbT0lOP6eHGjJDAw/4rcaIchPSfGyUL+POzLwnQYg342CDjgvHmARXLz9U1Xx/ZX9Ta42XwDPTPWWwhH4xf3CnPW0BnvOXKROoMdQx+hnvyLt/c1mgZr5oMKm6v0jHfNacbRQZvCMD2kaOZZP1qA989EXK57uHLwd3KtETcOlrbDCsKLbyR03lj4t3VM+32auMd2amUOlpPtzF/WW6STtmuOuLkW6aDV7cnsXFD2Q85lDmFIX0FU2wVRw5g658efaGJecMD1vTd7TzD20qudqMkGc1KAy/VawMVcaefPxS4+vQbjVx0LDnfJXSguuFLIaxXtSS39b0b81gGdla4QYHjkJm6uRG5RYJI6jaJcxtex/Zg84nW4KJJMc4j0g1mfn43Mv7+OKBMAS/Ifl5PlATzzGrJlzPMHsZ8fUz36GGY8bYXCLCIJGVnfzxt+/fTnCc0OwrVe4L6hVVqME2m3PQ38zM2oApBqMo8GLGGdafeoUxrEnAVX7Ref+2J2WVuastLOuys70JUAtto2Db2pM8GJ7IJ0l13R7v2MKyaRSW6PRbK
 3jJTvHrV
 UHlxRqX3Tb/TmTFT1S/XDSTPKXGEduOSn/kOBD7Pooo+aws0alvg4D1b4tRElkA7poSLfVbXk8jfPxt4Q3DJJGH2mCr5M0j2F3Nq4vxOa9DjKHPztW/nuvn26hhQ84CWsSyzuqd09XOlXbvcJxnjNeeUXqisE/brpFqPMDpXmXQ8JfMEJC1g04VadhTXqZRvT+r7VjnLPDQabPTS91uznI62zV4bidR3Mq5NPFJk3dgyJd+vFNZQIXWaA+1GSJPIyEmPzebAXfFKpZyDVPNOxbUo4uhKtOETRBFAsFFeaa6tUOP4HSTN7+oESnnTcykf2pA8kxE0lGKlId9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 2:31 AM, David Hildenbrand (Arm) wrote:
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks for your great work, Kairui and Barry.
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

