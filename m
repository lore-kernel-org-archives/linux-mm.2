Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70851606A884
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hpvU2tZT
Received: by kanga.kvack.org (Postfix)
	id 91DD06B05B1; Wed, 11 Nov 2026 05:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4FC6B05B2; Wed, 11 Nov 2026 05:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4A36B05B3; Wed, 11 Nov 2026 05:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 572626B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:15:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5C28A0267
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:15:09 +0000 (UTC)
X-FDA: 85422430338.08.CA9E6BE
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61F6A20006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:15:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hpvU2tZT;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoFu5Y8HEl5Mu4EdTi3BieAt/LoevyDG2bUSzTwF484=;
	b=waJGXA+XPbtnj6MG3taCFHWO+IYD8JVJtxcg3bFesxaeFKHdC5WvPS1od8qAva3s6ToZye
	5iyca5ilNBxWE+G066H5xVddthORU9Spof8WtvY6hznJmtyJls31noiJPVB4Nb+7q007NX
	w11KzB+TXNa2SiJCikxv2+lSTfW2FKk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392108;
	b=nSl8urmR0K6zDxMR/ir7+g0uehJidmfwcaXHhpRo907GXZl5Mrqueimw5PV+3vBRDUIptl
	NCjbsAcyPiYpDftNNGPZDBTTfpNOkOqCitA2+7yw4D40as8H/Zi3Fdl37hFE6lITsG6Zep
	I3LJmLTCYROTd+hzavMsIpGdkmNHf8o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hpvU2tZT;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WoFu5Y8HEl5Mu4EdTi3BieAt/LoevyDG2bUSzTwF484=;
	b=hpvU2tZThU1T1BxQr/2toWig69cLVckE9jSW2O40IDMDKabXB4+6aj6yO1He0Gm2NRlgrIRCp
	098Zp68VMRuEU+7iz+UQeqep2Mk8rvcEm/42ADGib0Cpp7b9KSTrfAOrAD3SFIlxayNl6mBRU98
	zvoj8LCGtM5vvTV9IVqiVMc=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jPfX51cgpzLlt9;
	Wed, 11 Nov 2026 18:14:45 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D54D40578;
	Wed, 11 Nov 2026 18:15:00 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 11 Nov 2026 18:14:59 +0800
Message-ID: <64df30e9-4297-4e37-9e9c-2760d68af24f@huawei.com>
Date: Wed, 11 Nov 2026 18:14:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: "David Hildenbrand (Arm)" <david@kernel.org>, Yuanhe Shu
	<xiangzao@linux.alibaba.com>, <akpm@linux-foundation.org>
CC: "Huang, Ying" <ying.huang@linux.alibaba.com>, Kaitao Cheng
	<kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
	<vbabka@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <ziy@nvidia.com>,
	<tujinjiang@huawei.com>, <mgorman@techsingularity.net>,
	<chengkaitao@kylinos.cn>, <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Ruidong Tian <tianruidong@linux.alibaba.com>, Tong Tiangen
	<tongtiangen@huawei.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
 <16cf88a0-6652-4276-95fb-12306e417701@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <16cf88a0-6652-4276-95fb-12306e417701@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam06
X-Stat-Signature: kft7pd7eo949q97nm7rcixq4jbxj3638
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 61F6A20006
X-Rspam-User: 
X-HE-Tag: 1794392106-745699
X-HE-Meta: U2FsdGVkX19/ZUCoZ0wxaYOsyFy+gcyC4EZNFBHJ2kZiHV2SOTn7xty6cJ4uUuKsyqTV10FgjSF3rwKVLhCtuUIxITyVMlv974teJDQEbEdQzdcdyXNsr5NpiUL6X7Ei4x9f1x1zgsL/WTtTPMYvT1NeZzaRmmbjmRkEhmXh0ooJs+ccjguh/WDsDMvC4lvhuxxqWj6dHt1WfOxa3Z0p4lAcNBZl7IG/QpJIEWUOhWghbavuJh/8g/mQsSFe72WRTWAyPg3FWv6NwSEqfcKWLh0hxqHpgYP34M+Ls51ZuZR7wvqottRX29KDjcd9XgNek7Ay0U7usJ7TowVgj8Sqo3Ihz8D1dwl2zmp8wltv8i8A1h8Ex8AGgni7h2prmwhmY2zp+2hl2EQcG6XQRes+4IiiYNiZwJA2oDOZoM+zBEHtOpiklgJ69JP5YsHw449zH7iEX0xpFMYvd1TvU6CfBkIRa38ZriN2dTun6kNcTaCCOX6tTo7ckPbVSh+/kK7YVFiXuEH5z6xX9ch+RhlMJ/aIgbug96A3sro2CDLHsqkcFgNreKOWpCbyjZsT+Hqh/sSge76g4rYQlE/cJkHOiuhpsaSoYdbg/gkOOdA5PeThQ9Uig3BIY6IAeRHkRudZqBbdSoQnad2DdJjCTw7FGsqXgbqPutMjp3qlrmkNOxTs35gRyhXpIaFsGAvDp22zY6bj13n292XhPRm2lfeV3xLU11gIn6mjcYnqp6W/PK3TuDCx+UxAkZ/OqRy6NVVtvUzhhNEZlAbVfmV8VO5a7sg5tFUfdW+xGbV83Auyqzropk4iztOtQpXVpEHlbl0pUee0/NYdsgVzxFyoUwaT5WOoReyCYl5g8P37Q2qoYNiRdqOWn3ZlNDA6tIA+Ar3HDae2TtFuDmC7uDcOzTuUirKDzmtKSFyVgzVAT4rPO9WSWA/PrdkTSdr3AB5YBvQ/l8i1vRgM6hYxYBE/3dY
 HVdjBd7i
 rdFLU01U5pLOQvCybQeNHVqOj9dY9BJmSVg7eHAMrVUxOSJt87NYFZKLNbkFjciBAm9dY0kpUTZR9po0UNqyjeRZyWTvKhNDIwL/XTAw78Z1217Sj9CjIOtcMAN3V2v95EH3iva1f/yPhK3RlRybgAcDO0zE+1e8Je1MMhpc1cqNZgnSVI4P9swRF5jzjFdj8ZFe5beLoSW5oZhn2T7B9QZBqEiqHahGBcpD81DwehCDhgejRDGa528aFyXCUG4Hpi5VbNqQNdk5xKacvBGve3Nzh8iE9+PdaeO6UXBu9LgE4oo1+sA0YH/3ctxpemSnvZ78QCxwxJQynmhEEJfJ1eImbjGY76OIYxQzmznTBrTUYM8+skRgc5JwXNUMtPUNlocD/liygO/57OWQ9ZPB6ENnShmKdU/ot9RrQ8etfXyN81HwzQjB7t0yoOUmXIiW0a9hy6hPgadWRGYN+I01QFytZe6aVUvi9V4/Fh5Y5JDOiOJSfHGi2J24Qd7fqMavPrBQ+HoFe66DUO4m0rlUfLscNwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/2026 5:36 PM, David Hildenbrand (Arm) wrote:
> On 11/10/26 12:26, Yuanhe Shu wrote:
> 
> While the file touches highmem.h, this really isn't about highmem at all, right?
> 
> This really affects any architecture except the ones that define
> copy_mc_to_kernel (x86+powerpc).
> 
> Or am I missing something? Would be good to clarify that.
> 
>> The !copy_mc fallbacks of copy_mc_user_highpage() and
>> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
>> set while the data stays readable, there is no fault to recover
>> from: the copy completes, the destination folio carries no poison
>> marker, and the poison is consumed silently.
>>
>> Check the source page with is_page_hwpoison() in both fallbacks,
>> before the copy, and return PAGE_SIZE, the not-copied-bytes
>> convention of the real copy_mc paths, so the callers take their
>> existing error paths.  On archs with copy_mc this code does not
>> compile.
>>
>> Measured on arm64, where the fallback code compiles: a
>> kernel-space microbenchmark measures 90.00 ns per copy before the
>> patch and 90.71 ns after, 0.8% of the copy itself.
> 
> CCing Catalin. I'm surprised that arm64 cannot recover from a copy from a
> hwpoisoned page.
> 

+1

We have been trying to support this feature in the mainline for over
three years. This year, Alibaba took over and released new v14 and v15[1].

In server scenarios, COPY_MC is very useful because it helps avoid
unnecessary panic behavior in the system. We would like to receive some
guidance to accelerate the integration of this feature into the
mainline.

CCed Ruidong/Tiangen

[1] v15 
https://lore.kernel.org/linux-arm-kernel/20260618092124.3901230-1-tianruidong@linux.alibaba.com/




