Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9609C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 01:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57408E003E; Wed, 23 Jul 2025 21:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D7C8E0002; Wed, 23 Jul 2025 21:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6AED8E003E; Wed, 23 Jul 2025 21:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0B868E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 21:54:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 220EC57D51
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:54:38 +0000 (UTC)
X-FDA: 83697489036.23.60F7D3D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 47DD91A0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:54:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EnAfWo6y;
	spf=pass (imf19.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753322076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gt99ZL11NftF0tgwHS5Fp8cvOJq8ExHVRAMy6E/IxNA=;
	b=7iNYgSvuNNDUnKPMT15u+NmuD88XN4uef3P1jJ+o/bWqfQrKaRXA9yaZD16WuuG0AMUGQW
	GgFIkOV3D4LKnN9R9FAD87F0ZT41vi64aNqnK1OaY5GeXZoOqnYHLG09LVwgE+tmd5A0lo
	mS27ipQNJUB2IVU0h/68c3D77IsB9oM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753322076; a=rsa-sha256;
	cv=none;
	b=iVVAoMsUBwYN+7fbf/It2BuYsFKmrCDFyVjr+g5hqOV42y68rmYv+5GQUf3gMnWhZAQAXy
	PC8Gp7uHCyJBbPiIXXB0DJ49CQHYTV1sqqtBjfkZeHgycXwioMgCYbOBu4nxWWYN3PcnHN
	8VCB95JYySFhVmjo/RRyp/4kE/LN87s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EnAfWo6y;
	spf=pass (imf19.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=gt99ZL11NftF0tgwHS5Fp8cvOJq8ExHVRAMy6E/IxNA=;
	b=EnAfWo6y+d1amiyQamzEYsuwyveMSeXEAx8zntSG+JnIbzl+ZXyMhrSpocSKP7
	JsY2X6gIgA/CLH1GMKc4OjlcnyMN6rn6nTPYbMYSSoZZy6nUeKHmozktFG5t+VmD
	XXj4I9CaS4Ehr7OpCwLQxYtLnAYklmdjJ7QNhUX9IL2QE=
Received: from [10.42.12.6] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3NWpQkoFodDt5Gw--.23202S2;
	Thu, 24 Jul 2025 09:54:26 +0800 (CST)
Message-ID: <07dd7e42-b2c4-4fbb-87f3-ab888d11256d@163.com>
Date: Thu, 24 Jul 2025 09:54:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/filemap: Avoid modifying iocb->ki_flags for
 AIO in filemap_get_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250723101825.607184-1-chizhiling@163.com>
 <20250723101825.607184-3-chizhiling@163.com>
 <aIDy076Sxt544qja@casper.infradead.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <aIDy076Sxt544qja@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3NWpQkoFodDt5Gw--.23202S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJryUGF4fWw43Jr4xCFWxJFb_yoW8WrWUpr
	WrAa4vka1xXa1UZrWfAw12qa1jg34DJayrA3W7Ka1DAr98t3sakF4ftFyjkay7Jrn8XF4I
	va10yFykAFW0yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRSD7-UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFASUnWiBj9Y5sAAAsg
X-Rspamd-Queue-Id: 47DD91A0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7gku9dcoqik5g1nq5pr7f1yyjzafgmx9
X-HE-Tag: 1753322074-331494
X-HE-Meta: U2FsdGVkX18ewLMwJ2WDgDAV32EPfMJ8XxEVoNN03DpmWSwfVI9ZlTEevAWMolDTbnL4ogPigeJdqNOhlsSahdec0qAfx7zu2gKq6ufDOz6t9RZO1BwsgB3DtsXz8oAhP7SaKpPpywfSbHHJoF2rvpSKEMcD83uOOudQoTMQRzaKbUyuXsCupQE4vEy2pvdYcJwDjJRehpZQ+DKIXxkrNzv9nAY8+hGmn6AOzNyivjTp6mefBbqDVMKoGx4CstBChyE0CUgyqqobnFtRduVdFmjHL8/rcnhuEkuVnOkaRcM0Wj5VwRsnrQAsxlj1MsA0ue+YjzICyyuPYJbVtZg0/ECM9hhVMiPt7y3MB5ezMs0PoC7mJlfCnm0xTl2pioOrIhVeb5DZNQKCGGSar8qUq10fVw0iiRgu5hrF1gQN2gEFLzTIyxqmevl0tjnhHm7tH0ManZq0UEPoD2S+1aU8KlJoRy+PTwc7rtJIbBTG7xcQLgrEoonSa4EoMMCI7Ybxux7FEBlWJQj/3J79oQgfxdXn787KvRkakhqrdK8fjtO2Wv9Tvn5aHW6d1mLqTCd8dTjLdnWKPKGaB3Tl1AWMoL0nzijPRMtnDx8MyirJJGO0JEFdlLr2xE7HQZedDMd0YmcXmNp1fA8aLuu2cf0HadbPFnUnLba7B+yrU45W8zYnkT3ZgjK744yk3rMKjkxYMGwTpb+BftdKjlfTkl+BYx+cgBFxpPs3Tn2xC1jlaS44BeliW9A7xen0Qs7D0qSOgHr2TjEzs9aff8U8AIHdE/Hbu6WiUh+viR1bp1mz5YBcPAEnbX9MadwzcJ6O37dupNgtS+dQMasayebxZrTRXE+sjeZTgiEK2rcoOUDhqjkzt4BR6tB3x+u6dtf9knyCaUmRmUfBZH5cyJiW3DhIhZBIdYsfHqkhyQZSYeuWFMbH+ynpKyZRuJOR3ft2CIFAlSzwDknH5bSzcrC0MpD
 +qRRaEnH
 aO+jj24DoIcULueG7JHWlV8rGihkooYZXHQAI1rS5YR9Lv5c3Yk4CHba8p+gFcbBTkENkLAZSj/ZT6qqaAfyYsxG/49nrK2rV2T1YYFjN8o5TR53HR1+MCyr1smaB5s4G3aShpDpMMlvdrVwTm2TQifqszpYpMOwltV0nBFPlyevc6RlYsYspR8IzdWh5gQTeuzI5LsWGzjq39Y3XnnpUJO5X+35BRgMlUcHyEGHhe0JFo3rUloazlSAMPGlawcch3yGwkpjkjP/QlffkYj8MihHYTs4CAkxNYPUDquSSBHaG0hjZFwVH5A7c/nwwYS4qfyMZ2s5cTXa7z+wGZY4zjR/wGmV0VbS9yTa1B+WFnnQP2YH05z5e5WNfePdgUAWmlIZLmAUWK01BgB+ndTlRP2I5+eziA6V1zoOIuqVZ1aihZrAxtyaKTaLCMurSQjGvXfHrJKAkUqsVoBDqyjT9BxvRiy21ObYRfOrIHafhSU9XtCTCguRklFj5BrP/dB3QL6tSKvwOT+MdqA9wh44Q4QhEpjMl06NgmJkXDeEZiFh44ugO+yrySCYCco1twrie9klsSn+RAamVMac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/7/23 22:33, Matthew Wilcox wrote:
> On Wed, Jul 23, 2025 at 06:18:24PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Setting IOCB_NOWAIT in filemap_get_pages() for AIO is only used to
>> indicate not to block in the filemap_update_page(), with no other purpose.
>> Moreover, in filemap_read(), IOCB_NOWAIT will be set again for AIO.
>>
>> Therefore, adding a parameter to the filemap_update_page function to
>> explicitly indicate not to block serves the same purpose as indicating
>> through iocb->ki_flags, thus avoiding modifications to iocb->ki_flags.
>>
>> This patch does not change the original logic and is preparation for the
>> next patch.
> 
> Passing multiple booleans to a function is an antipattern.
> Particularly in this case, since we could just pass iocb->ki_flags
> to the function.
> 
> But I think there's a less complicated way to do what you want.
> Just don't call filemap_update_page() if there are uptodate folios
> in the batch:
> 
> +++ b/mm/filemap.c
> @@ -2616,9 +2616,10 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
>                          goto err;
>          }
>          if (!folio_test_uptodate(folio)) {
> -               if ((iocb->ki_flags & IOCB_WAITQ) &&
> -                   folio_batch_count(fbatch) > 1)
> -                       iocb->ki_flags |= IOCB_NOWAIT;
> +               if (folio_batch_count(fbatch) > 1) {
> +                       err = -EAGAIN;
> +                       goto err;
> +               }


Yes, this is a completely better way.


Would you mind if I add
"Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>"
in the next version?

>                  err = filemap_update_page(iocb, mapping, count, folio,
>                                            need_uptodate);
>                  if (err)

Thanks,


