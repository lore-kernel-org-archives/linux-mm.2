Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6100CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851136B0093; Wed, 30 Sep 2026 09:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802016B0095; Wed, 30 Sep 2026 09:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7188D6B0096; Wed, 30 Sep 2026 09:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506916B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:38:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC6121407D3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:38:41 +0000 (UTC)
X-FDA: 85270533642.14.31B40CC
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84F2F80007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:38:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xEyPHhsk;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790775520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P00NcZdXkR2XuhFtH4v6JbA7ANad/OjoIJXR7zjLsGk=;
	b=avHFWGILkS5+XhLAkbqdZFSXsC92feujhPTY8JdelRAoJD9YQ1tRU2DhoRTDeI1iYDRGeQ
	M1YZVjxullyPb2RtqGZrh01SvGV7oOsSCD54kav1Pwxa4xlihA5DmG5FRUcSbMGhXqVJwH
	Va3+jlTcAPbmJuPMJOxt+nHEnSmIQ6s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xEyPHhsk;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790775520;
	b=KWUNbdY3/cxGe9+aOBAl3zUks2H61x+w0ThlFMY7HHuCy8oi8F1lo8YTBjj2+T5GjX0Gc4
	3PQ6MtMX6xd02tT3AI8RxNCcKrX9vHxkYeo9TDI1qGUOY7aDUcnxjtDMybIHDVNRfX1/XP
	vfM//llyV3ih1rFHU2YfRUDxOphYoOk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lcQuluWqoElHRHUpdffs+zz1mzqDGPOpnACMggFGdo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790775518; v=1; x=1791380318;
 b=xEyPHhskqY+zKro0V3No4XYRdbC4c0j8qfiMjyxWmC7/KEcRAjzXGl17mTOIQ4Xk+L0xmwx6
 NCA52a4KCQ6dVj19nYnWKubqmVZ6MyBphh+XDZqinMF2AQy3maHBEMSW7fOIOSGGVEGRM70IHPn
 7lFd30bUgDrVUC8fO9w2Acio=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 441b9db43c699605;
	Wed, 30 Sep 2026 13:38:37 +0000
X-Mizu-Trace-ID: 441b9db43c699605
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa39ec65-a2c2-4396-b20e-4e4e7447df26@linux.dev>
Date: Wed, 30 Sep 2026 21:38:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, maddy@linux.ibm.com,
 rppt@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
 ritesh.list@gmail.com, sshegde@linux.ibm.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 qi.zheng@linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260929053231.66085-3-songmuchun@bytedance.com>
 <20260930085329.17337-1-lance.yang@linux.dev>
 <62E3517E-517D-4C23-A04A-F5BEB0A84C60@linux.dev>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <62E3517E-517D-4C23-A04A-F5BEB0A84C60@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84F2F80007
X-Stat-Signature: 5whqa93mdhj8ti9p5rxs1g91bhf3b9fq
X-Rspam-User: 
X-HE-Tag: 1790775519-288522
X-HE-Meta: U2FsdGVkX1+FJoMTrU7b2D2jJA4lqlUQZTrwUjXfsuxIWRIh7nJX7zQOQBa8HZsQZtE0r06NRsFaRpmrsqYJe8ZfqUdtAVdycxj6QOt7NuWriaHQ6+/7sC7EP9QjkhCwba9hsszPelN0w+vXC4sfGDibbsPYG2SgA8hW/5gzFD3ufivG1BhUohiRox1g6jOmMm9jxw7Ky3o2K5lXLAyUsufj2fAqidVK5zmZU3TkYSOomEDAAYRf7Voz0t1CGp1VF687TV4Ktn8euLemkmiDfYP6B2cKYUTtjr+mBYNHtIAlRbD+WHLwzufMlRGtTgamsREwHVfsci296oQyORjxHG+rJM7MxSEaljxw6z/OBdi3xTXNQj3eaZHE4KlvoypYN/vpuqizdzpcCD5IR9cYiBGb2gf51F2a491sDc3RxxJdIrUGbudTYd/HqtgWYYBf60JDL8pffV+sjh3xQfbHLzE8t6+44zDxwGL81k32NzLAOZxm0ZRYb83VYYzL7wvnhCyWYYVNTtt1PEsm0kPpy+iyTAr/Apz+/UH7y4I02WbB7kcN6Uyl91nN9Vh1kmqjR361RCx9du0ygNFlmv3B3aSydLl2k5tQX3+HfU2WPE/yfQkbZTZ5dHhmwQFQIhET1tCcenpsBrB5mdaAiHiALwIo1AvXnHmTUMOAeNIWztOekiUp6LPMGm9Zs9r46/slRQvE4jtf3jph3d5SnlDm0QuaSbciKInDZaE+Xi3w1OTFxEnA7ZFix5ZQhw7HjKhsA2ug9S43KpYWZ30rls0WeCTHkvwfsJwCGgMo4rY8OL4dYzlcvLeKPQsUEPJHkWCDeDGR4X7OKdbOq7b/InZ4fAEysskx81Gpwo6jTZNQijlfvhym30eg5xemzt0nsEU9vTyi7IfKf2Fq23cY+v5BHC1oLCjudSfZL9oPgdJe9uwcu8XxsNMThyePydpQ0D5DpgVKEEnCaIBkzeam2ig
 0HwJJO+X
 RR1/tSRuOohHqgtytFX3UZTrynQxP0jN8wzD8KmFkJdfXS2himEbyf9sg5tcR/XfqrHiQXBOnDtb4sRK3qoMsSqrwzE+nuKrVvuPNpDhYYdB74xZEg/XJkX7gODFVOHhhvT4T9RDdhltdiY3TuQW1cDqMxofDbcz7fkM5df4tso9ir7dOIWvRED+SPmJpeoNQ30GF5gyfj/z6m6osjhh4uKAUg+LYUO0PYxdGdMM0lVlpnOT7q7yAFcSaXH5pk/KNhMLxwy2g8eCsGxl8cKg+VB98jiqVNlDhil2SOr5Rgi2KLc8zFa8YzHoGHiSqvJMCtH3iGPj0RuvCr3ilWBsta0pt0Y1AuocnqTug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/30 19:11, Muchun Song wrote:
[...]
> 
> Your proposed fix looks correct to me. I would slightly prefer keeping the
> rollback close to the failure:
> 
>             err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
>                                      params->pgmap);
>             if (err) {
>                     __remove_pages(start_pfn, pfn - start_pfn, altmap,
>                                    params->pgmap);
>                     break;
>             }
> 

Cool. Will shamelessly steal this approach :D

> If the first section fails, this simply calls __remove_pages() with an
> empty range, which is a harmless no-op.
> 
> Would you mind sending this as a separate bug fix? I will ACK it.

Certainly! Lance

