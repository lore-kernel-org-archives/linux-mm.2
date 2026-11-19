Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70C260A261B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=MjoeKzAj
Received: by kanga.kvack.org (Postfix)
	id B91E06B05EC; Thu, 19 Nov 2026 04:23:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43CB6B05ED; Thu, 19 Nov 2026 04:23:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59E56B05EE; Thu, 19 Nov 2026 04:23:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80DDD6B05EC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:23:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 113341409B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:23:56 +0000 (UTC)
X-FDA: 85451331672.13.4BAA2D6
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA34240007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:23:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MjoeKzAj;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BbZkq+DmyFDYud+in+NzZnjvISsdRt+bXMusCvgfHk=;
	b=o4V2bY2AqxZ2flNfN7pNzkolZHfyQgQjQl8R+QY+sg7Z4tqdTNpq3JtkYmWxIH017IamIn
	XHmyrSSsxjNJTMLXh8KPWgtUTKvUcrr3dFbBS+9ldByrsumetfrsnxx8xnqbv4ZfkEMXDN
	NTEn2yTxFcEZUHUElmjRp3ItWj+ONYA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MjoeKzAj;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080234;
	b=h53N/sYL++vSOg8ZGmKQ0YVxHyKW39LLBCgognl4xLkV8bpIOO8fQbF3ZKbXOobztv/ChN
	oo39EqLme9YXBl0p5gfW+QSmHNFNtm5tDuYkQKMxkyR3sCYUSI1LjcQQ3/FqxoXUgAs8Fy
	QlSFSEHrN6SgeWuWNxx5hBEe/0BPkS0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8BbZkq+DmyFDYud+in+NzZnjvISsdRt+bXMusCvgfHk=;
	b=MjoeKzAjt6NTNI1C8Hfiliqm/LHebpFMg2BTpiBkAuHBOlFsqKLJDpaAYAhOv2sEa/6eTnntA
	opOGiCj4OVATWyDQX8KPLumcQHGY0SdCrGDSzy9I91p9fY70O5JUgs87YGWgas16Gql9Ub8pAgb
	5E23jIqpglwcGzZ79aTvDbY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jVY183phdz1cyQ2;
	Thu, 19 Nov 2026 17:23:24 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 03ABA40586;
	Thu, 19 Nov 2026 17:23:45 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 17:23:42 +0800
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
CC: "Huang, Ying" <ying.huang@linux.alibaba.com>, Kaitao Cheng
	<kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
	<vbabka@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <ziy@nvidia.com>, <wangkefeng.wang@huawei.com>,
	<tujinjiang@huawei.com>, <mgorman@techsingularity.net>,
	<chengkaitao@kylinos.cn>, <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6536c6f9-4cab-9f64-53fc-897f3bd9c9a8@huawei.com>
Date: Thu, 19 Nov 2026 17:23:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: rmgwmtxboyct1rqopmn8cdu6kdbuo91e
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA34240007
X-HE-Tag: 1795080232-165575
X-HE-Meta: U2FsdGVkX1/nT0AkOhhMczQ3DW3TzxfaCS1iZLqgzQZjO7xL6lZJG0wVxN3efX6sP519rXjBxsk1+6xDQ6/BVvXkRJvXuq2qujLwxD82kv25ktIX/0pBfPXiTOieMbjjrCuva3D7LbQloRzC5sOhHBvDwIO+QT+dzKUYViZe9CuVOvktCKcs+1ulpxQ7jwZNlj8rIWk9QHJiaRYarKmTWiHa5f1fwV+FwspIRbjXER/xC2Q8qSVH1/kG6Wu/BG0A9T+jWz75JUp3010rr0CY2LyOhv1ljy7vyV1MKHG+bwvUZn5+DxeywwsUrHY+lxYKqTG56fVLoaNk0F/2/WjkjAuOGyvkriMdmrMGNYsJZ+kCwa6yJCIgZU5hd2dVkIHU+q9uSwg4okJB6po4TBCkAhk7gfSmMfd0gomF4ISxdGnmFQ7CdmA4seZjyL42aNTmZWQzdFWQGOXbaZp85LZvUEfv0+mqAX9m/a8pyLP3QrwEjrJVu9xGJeEiSYK23uy6xS33FZ0uFZ9a/M0RjiSujnmK2In9bOCaFTa6kbcRn2FF0wn47SN/qqHlayOcn9lVhlP+ajG3vm2hxUCVtc1YqeRlrh+sB7mPUue2MPRBptZPBMEVJw3xVC2KCTvSUACVWdKnt1Vot/uvhZ0qT1TUb3tS6TkUUzZvHa77+h3SwfqraQ4gS1LKruC1Qle0r9fSBNZRPp3kRVQ6HvCPPlS36i2YO8Jp2uaANWj/L+ftgt/PjaRbzuMTEa+PwGdjs7ccv1R9JstiFLlAo6pqMIu5q7va853A4coRPSK5SYwjuDgsh7d8HhHInDaQPGsFqiq+oWxqGnou5GYij27OL86YV6LbNtFs0jex2QJnmyyUgoyXd9Bf4o0XS11LDcL0rURIxQP9bfYTloRvpmTp2uIJLhgztrltfjfX8vkVPJVRziIZu0krhyVqXzdEkz89hdFpb9Viu9PmOtDsh/1bU9t
 l5i2OSzI
 oSXJRrwKTysih7OtYOOZuKY5rOg1PIIMM9b6LK/d13eItx2vDvbmCmyYeX+6BKd/hDViv+q8ck+0xT6JLrd5h2XUSGRcwcwSuz5Xx8oF0ZHLGvS+O9MoOnCYDqtpd+F59Plj3yW7RIGzQ4lPVUwkxryhMWMFUQo5G7ZQaJnqJ5cD2W4xvGTfY7vOWf/N5EpTYZO2kfbM1GBDMih34b50MI0TdsYnjf67deJz7v8o9Qhz7/9JN2rV1HA54HFqzcTJhNaLZNDfoIPMdy8XTbTyF3V1zOIlGEYcpFmyW4BfdGtS8eivtutL7orpenDbB5MZmfrhIIUPu2wyHZKYILa3DQ41+ObK3h/6witLlueUfKOgz6IXUjKMaZH9sjU/WSi/Oksy78wTofFSVOx3oRl+ApLhVxM5VJqXlfXML/f/zISw5PLtQSzgk1zwoEe8ywiKi3n+Oh2fBY7cukgHpENt9mRNQ4oRO5ICwGkWRNqGPPDESsi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/10 19:26, Yuanhe Shu wrote:
> The !copy_mc fallbacks of copy_mc_user_highpage() and
> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> set while the data stays readable, there is no fault to recover
> from: the copy completes, the destination folio carries no poison
> marker, and the poison is consumed silently.
> 
> Check the source page with is_page_hwpoison() in both fallbacks,
> before the copy, and return PAGE_SIZE, the not-copied-bytes
> convention of the real copy_mc paths, so the callers take their
> existing error paths.  On archs with copy_mc this code does not
> compile.
> 
> Measured on arm64, where the fallback code compiles: a
> kernel-space microbenchmark measures 90.00 ns per copy before the
> patch and 90.71 ns after, 0.8% of the copy itself.
> 
> Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

