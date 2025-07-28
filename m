Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8189FC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979F16B0088; Mon, 28 Jul 2025 14:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A9B6B0089; Mon, 28 Jul 2025 14:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8407A6B008A; Mon, 28 Jul 2025 14:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7667C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:17:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 264F71CFBBA
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:17:55 +0000 (UTC)
X-FDA: 83714482110.15.9C70FD2
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 164AC12000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:17:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoE5P4Bw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753726673; a=rsa-sha256;
	cv=none;
	b=wYvazv0pshAN4YKvdRckPfvIc8lS8ogjQWmZ16qlaFIQapUEDrrS53qAoCSXfE73ZU/V8y
	fUD5bJW0ijs6Kw7RqimO5nI3nlH37ZF0ie6lfyHoLtzzaRgwT2d0Pxx27T3+Ru6pleKpPu
	BVlVABcrNvNkzT655JADZxemjYhs4Ko=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoE5P4Bw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753726673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XImG3RY7RQ20GriC3ThDwzyOsZ+ZnkQcvN3PF0GjwU=;
	b=xnFevpqbuMiIsKxaGx9+PppRolz5CscQEDHFsmXKKRp7VLVq5nuuAuksUVk4gVvYAowsOS
	Zqcnx3VBvf/RWAzA2E9DiCZ2e+Q0lcuIOj7GAE+sr1s8f9YDBeJkJOV8oJf96J1k0W0GGe
	TIU+mTm4F4VwFnONUHNNDoO6OEMSy48=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso8417419a12.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753726671; x=1754331471; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2XImG3RY7RQ20GriC3ThDwzyOsZ+ZnkQcvN3PF0GjwU=;
        b=RoE5P4BwIsRp8hC7z+oPz5cHyxypEkhuoKoC0ntGBy253cqhSNNIubbOsZPFqPBsDO
         eHmVC3GGWXWkUDFEQuhB5RobFpRK1zGQQw6iEVWWgmxqZzS1qTmzh8/5p8xl+/3w7xAQ
         1TWZeBuk1uJYrnehN8HfsgB+bhc6JCXh2Z9OJ4LWMBS3tfJIoFrI8ngApq67gOJDscAe
         Dy9wVwxj/0r4BoIbrTa+flA7d0D2kLJWzhqS96KWXpJwVRbSvwGoPCz3d7KjmslEy7F7
         C0Uufm9f7CrKYqQ/emZ+NhoYybgxpWu4vhBwOiq0MNCZPv+FzqFjTcdzOK7eBV5UN6bm
         XP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726671; x=1754331471;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XImG3RY7RQ20GriC3ThDwzyOsZ+ZnkQcvN3PF0GjwU=;
        b=alHFGM31e8x1vFK6rMc/6b7wGysChYSLpcblk8ph6sonQ1vySTFmshUApMBhKGWlQj
         gXJZaGID11Rde+cetKrlvLGDHirmzN0WK/Iw4OV/LfFPaUGRjMUUb9r9YmXbhr9BHq+F
         HiDn4eK67Hou+epviaDhdcoZPK8QzOgcBLv2ui+f9B28SVjiStIHH76E++nSn3q6SMQL
         SLIGGQTfcjIbwRQ98mO2iCh+MN+ZpcmIkC56j60S0KoJ9JGryhbPvGqEXRSW2RtRmsBT
         fLlqcsAwG8k+xNa1drCDPwgy7Dhf/Xs5ltN5fJNaSXZM2v7vnJZ7PeWFOqANV+FIBet0
         wTQA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ76HFUQhv11X+Dq8OY44EbBVMpZmdYRYdl3alH1HVOqlRMRI9qxTfqjYi/EhxgnQwaPVAqn9XwQ==@kvack.org
X-Gm-Message-State: AOJu0Yxhv3QTdGye/zOFt71Kt7OmGnRNh2e5uOqWSdp8/76ZBhpm+9HD
	Bsx8QG24pIOZq512iITXj1pauQhbUyNDooJdYHVhhUIhbhuDwjp65cjV
X-Gm-Gg: ASbGncvY2vVGrqxEU7bYvuWtegjyB79exNCHnR0HnbDPVSPttHOjOcl9fmRa3MUOL5h
	+hneajr5vF2iG+ak790Tqrh3yxc5w42q4qJggTMK4GRhGe1VX+hBSymhdRQUN6cZ/W+meMnJ0cI
	aTbocl9Dhu1+f9tA7az87sJWtwVEyJH3oiA5BOSubnDSs0ScWxtirpxwnyPWW4Eg/duhQnj+qNC
	g0XapVCtJJGrlhoFZjvkAI/f1lUJMsxtGmKf0RCg+0+XDXFcTj1oY7jWPYploO4uW91drQuI7Le
	/LK/xjafJKH1JfCTRHMuyHtDVPppm9/LcMmIfmOBtwQDpuQ/yxrWXyz71e7rP//rrIbAdiVruBZ
	7B9YFu40zYiIYZolGLUzkK1i87nMNB5c=
X-Google-Smtp-Source: AGHT+IHE61hHXgBHYY7mn+Rm9n8UNepBWRf5ECBwt+Kj2Dy/Or/52jRxs31VW64wRWx15L3XVNwb2g==
X-Received: by 2002:a05:6402:524a:b0:602:1d01:286a with SMTP id 4fb4d7f45d1cf-614f1bdd941mr12122182a12.6.1753726671077;
        Mon, 28 Jul 2025 11:17:51 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615400cebf0sm1481690a12.61.2025.07.28.11.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 11:17:50 -0700 (PDT)
Message-ID: <72861320-2b54-47da-993d-a82050cf56c2@gmail.com>
Date: Mon, 28 Jul 2025 19:19:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 3/8] page_pool: access ->pp_magic through
 struct netmem_desc in page_pool_page_is_pp()
To: Byungchul Park <byungchul@sk.com>
Cc: Mina Almasry <almasrymina@google.com>,
 David Hildenbrand <david@redhat.com>,
 "willy@infradead.org" <willy@infradead.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel_team@skhynix.com,
 kuba@kernel.org, ilias.apalodimas@linaro.org, harry.yoo@oracle.com,
 hawk@kernel.org, akpm@linux-foundation.org, davem@davemloft.net,
 john.fastabend@gmail.com, andrew+netdev@lunn.ch, toke@redhat.com,
 tariqt@nvidia.com, edumazet@google.com, pabeni@redhat.com,
 saeedm@nvidia.com, leon@kernel.org, ast@kernel.org, daniel@iogearbox.net,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, vishal.moola@gmail.com,
 hannes@cmpxchg.org, ziy@nvidia.com, jackmanb@google.com
References: <20250710082807.27402-1-byungchul@sk.com>
 <20250710082807.27402-4-byungchul@sk.com>
 <CAHS8izMXkyGvYmf1u6r_kMY_QGSOoSCECkF0QJC4pdKx+DOq0A@mail.gmail.com>
 <20250711011435.GC40145@system.software.com>
 <582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com>
 <20250717030858.GA26168@system.software.com>
 <20250722012324.GA63367@system.software.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250722012324.GA63367@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 164AC12000A
X-Stat-Signature: cm5j9et3mryynw1erp6q796zmsuawri7
X-Rspam-User: 
X-HE-Tag: 1753726672-829033
X-HE-Meta: U2FsdGVkX19IL8w8RnRV+FeTd2avI3L3PZEiMBvnco5b4F0IPHdwhGCwF6oek7SK/+G3/FvvA24V8+9A9/AZXVQ8/ffhUWE1ggA0Hh0WOKg5riATe9Z15kB67J3nYu1Pw1105xe77dLFRT6EPLHxinGH64h0ylvUOCzJPh7YpyjP3zu4jNuHDH8zGv9xsnKW9isqYEah3C0+rwIdR7ZgOkPfBmFHL3mpOkcaf3h9XLFSWUITkzbAaRvmdGZz3K7PMueZlty5i8oq02Mq3KEpJiHC/ajFFrufUuaY+gUCE8VYYZLr6bOmDXYTHCWbPi4nsy/CosPUi8xOyHjAIqpewyTVnMjFTyaebRIg6mVc/2O8qq8EQ+rBCn+/FmS0HsEefptL8DnLwbfp/idZ8uMHhP8ddTDmOS6s85uBgZdGes/mE0bvr6VuMwHjY9K5Cu5M3Z7hl9BQSCVncaDmQnaxuJCCSNA3LZqpdznlo++LxKpOgfokGFYtpjcmNa+PNUYXvkNvrD8fTNT6uiRuvK2A6RssbWxzH4qLQrk2BuLfqS6PUFqfbIY48rCJXAk2y46pSbRWBEb0nFjye2Y2bFSH0JOybrAypHpoL/mCgvYvru0sgQkC3Rw81xBBda32GB0+UlFCsjy+8KGrXpG56U1oeiqzk6FunjZii/09+btqcWLyFah15Z/hgZl8ZTWCmdZFHubdjhE281j31Y0MLsD3ToVzGwhEgjJFot858USYukzYOdhL3HUqVUVVip/nYl/RfQysuA9RFk60cVKNARATQwxVdobr5nKqfJTURHkvegYFMCabvOd/gZ8r8ytSLwQ7rDHfQncJWvlf9IrSyqGcx/7W9V8ROjxIRPSYF/gpk06MNQQGo87SQu/Djmjk3QclM0PjJYahtkt+UpkRvVowDrYjBuPoyFIssX25oDvpUP/47pL12h9QacAzAgYdoblo9Plv75N6pJOoQ/l4Uez
 damLPPeN
 am3Uk9uiH7Xs1+0zw/MF6BiBcP+zRj/0Rpoyqg9ytny4lbbrP3FEFJeq6CiHSOj5PmdCpHDaA2Ig259m0GtrYBPpCAmd/0pNZJ+tP5V8Ll2VU07lLyEC/n1v1a7baVA6WEmuTZpBoJSdtxZdlmOhTA3ChPdTxiY3Up2ZuY3W95eDK3wsZRsxqwY+pYKp00aJCsH/AYU8JKIPmTJR8LF7TOBtAxF3Mxcqn2j8ZvW5agzTkIrjg/kqjCWD2hLtRNaBAjrlwUeCad57NRfBzQVaEH/MxIxbKzbJFaImtrjV3qqMZwuGKYc8Bc8m9/Tc0zQNbaK0fdav/NGG8sg/FUAFlB3icI/eoXd6/XAHMb+zuQObO81EetHrvvWsi6paZpKD2GVY+F01MKTRoivNFBA3rDDNmUQqfq1pnSiXUZ19hOHkICX2EfwSi+Yc9DgrmhUbHj7qBr6HwUOpRBTCjdoTKJXRa1HrxStEfVbCjWAN3O5H267hXV7ok1k61O5xCmFtmATURWlzTIEksGMEgMKeRN7y+Kuyh6G1Ct4NKUJYffxNb76YP1+1Uw4lEyv2wjuO0MgvXhhrbo1PyyMApkPboipW+BKYlbkXTSHv3MNqEMjbFa3zHp/3J4JygmnEaGlT2D7tZW06EE8I9as2VixYiCQhLHoA+CPmfqpT6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 02:23, Byungchul Park wrote:
> On Thu, Jul 17, 2025 at 12:08:58PM +0900, Byungchul Park wrote:
>> On Sat, Jul 12, 2025 at 02:58:14PM +0100, Pavel Begunkov wrote:
>>> On 7/11/25 02:14, Byungchul Park wrote:
...>>> commit 8fc2347fb3ff4a3fc7929c70a5a21e1128935d4a
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Sat Jul 12 14:29:52 2025 +0100
>>>
>>>      net/mm: use PGTY for tracking page pool pages
>>>
>>>      Currently, we use page->pp_magic to determine whether a page belongs to
>>>      a page pool. It's not ideal as the field is aliased with other page
>>>      types, and thus needs to to rely on elaborated rules to work. Add a new
>>>      page type for page pool.
>>
>> Hi Pavel,
>>
>> I need this work to be done to remove ->pp_magic in struct page.  Will
>> you let me work on this work?  Or can you please refine and post this
> 
> No response I got.  Thus, I started.  I hope you understand.
Missed the first message and then got busy. Anyway, sure, go ahead.

-- 
Pavel Begunkov


