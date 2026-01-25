Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD93E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 18:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D986B0088; Sun, 25 Jan 2026 13:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB5E6B0089; Sun, 25 Jan 2026 13:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9F06B008A; Sun, 25 Jan 2026 13:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4706B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 13:13:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 160A013A947
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 18:13:19 +0000 (UTC)
X-FDA: 84371283318.11.FCC2D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3971040002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 18:13:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Du5aLaLo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769364797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxljavPSGDsVER4m5cgbqthLx/vYNmzH6qPfVVWuNXw=;
	b=xrkxjvUDWmbFjVdFZ8catu6MZbqN8Gu7/6+O+IR53R5HEu/nOfPanXtcOLZ9dqI7inlpf0
	ulI6osCqnGRjYJ/D6/W6lkXAikhLQHovzxZgJQmogzOJK/wPqttiDLMW/QmARZC66yN3Cb
	Rxmtd7W+uJxahp2MbC04OLMOGRA5k6s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Du5aLaLo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769364797; a=rsa-sha256;
	cv=none;
	b=M0dqryiCAwIJaWo/0+cQeZ8V4wqJdsfc+6+T9D0HJEYNpbmRZI0pxMLYaxBP16W44oZkqu
	XmAwgBsP1rpQOi3Jdgn2lBJo8GDUQfueU8PyUO1toTJRlcqIfDD+k0QJX+RyUTytcPOdjy
	O1HKDZCcsPlj9+vPeXkwdwnS23AO8qU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 090E844084;
	Sun, 25 Jan 2026 18:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A265AC116C6;
	Sun, 25 Jan 2026 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769364795;
	bh=m1VV53Zle/o8n8yKCbI4JuCkUtvt9AMf10/cVxnd0Lc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Du5aLaLoysxDAfWXUfj5TNmXOl0slvCcivfgg8B8kDf6jYNWdqT5gpe378B/5aAMC
	 87dGz9+7UzGurQeAOEhUlwUqdT1ZUPabuwBgItjZrSd3eK3xB7QsCA906dIRqFA+2v
	 gbPy2HWOI3KuZZjswmAeo6UNoaoL11rW6+G9Z9caOM6hp6ZHrH8bxQWR1ua9/Ep6sG
	 HycrU1oklfAsceGXNK2tDqo7/GJHOUjyCW0sclilH52ruaG3Gtmf4kYjlaSrsmXSEa
	 oocIZEFdLIZ/fgPoqprBrq10t3KpQawDK/rSxHatc8ZlviIfJbFiL/FgvXJcXkmK3G
	 hN/chk01QOuPA==
Message-ID: <7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org>
Date: Sun, 25 Jan 2026 19:13:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in hpage_collapse_scan_file (2)
To: Lance Yang <lance.yang@linux.dev>, willy@infradead.org
Cc: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <69757ea0.a00a0220.33ccc7.0017.GAE@google.com>
 <20260125121001.32733-1-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <20260125121001.32733-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: n5ihhatyzscmi4i5ms3qdbegtkyipnnu
X-Rspam-User: 
X-Rspamd-Queue-Id: 3971040002
X-HE-Tag: 1769364797-522639
X-HE-Meta: U2FsdGVkX1/nEvBY7kU8T/3zEMEDzrADGUEwPmML7APW5/HF0+W8LGoTk47JywuQdg2jpB5N6o8Utb6+wPJxFskKnRiFRWC5KKIAO3c1CHl9v6hdQqfEgmdHCwKZBQwjHe/pUGPOPnamj5eDJQnI9edBxs+OOx9XXGnuhcbMdcxLayIQ0IeFt/XHb/5HpQNcQqSePY9qR/BPckLtFxYzqmDtW8fre5BZnubgehovV87LoD/+do/ZAYZYXX15TN8Gg3njS3ATkYiwkq5kaFOOWthMeLQEwqJ336H64RYl23T6bZphnDMJ+epo/0wyE8QlZGhlN4gauL8Ir+v0p/eyTBF168TGNAQCX5Nj/CmU6oJIe2wHtV0jn59LN2SyXP2EcT/QhmL5j5M764PvdQ4GlshfpnSGDnVR68Kl2aE6Mhn2YZIZuQXHruxO0ngZly3A+LQ4rpdiaokdJaFk6/YT9J2Op0/UtbFepUHeGQLX87wJ4XomVRd4vw+k4J5dNx/qFZ496rxxBQBsrd/9fP4EiXigZ3bmeuQRpFegANrMozPzP0AYgOzvIQ/mOzOlQ1w88R+LepfNA3MhVghj1ddpPppSWMew/W2FuD+vyFN5qB7f0nbdR9WRcXlzo8p5Ya3rOKO36NE112cvALyEvs+ITZVAeguFCdX+DtTqx08U3z0Sj2eGxXjqdJIQIucSKP125C9ocGqH3zCE4HjHHssnjbepdYZH5ynUO2D+iij3V3onsma+sl580u8dLEAtfoIiBwbrSpcJ4sZN2D51D8JapgTO8v3AJU3RQ1/8DA0x1NMX63bLwz9uvQ8Rhj+MnvhI18nTbmVzTRMOaLPnc/oS6f+TZmsmv8q2pii9xALudhTG8z8R0p/vUM+Gofc5P6m6UINczuRyqhjQKAWPcj0CZsgHme8ldTqIJgoFrZcX4SvucZvrzfFYbyZTS2NGxdYsh06U8iGhXglQUkLE7Iv
 SZL1uA1H
 V8j0JFZlkINKLRfXuIOGS4BBGfkpUvpgylDMFE9Hne4He5K5PRoVdvKLKtkw3233FeMQn0twH5rlv+S/X6R0Ry5tKSUJDcPq0/SwXjRIZHfQ1qLdTzcLh3lQm2QZR/8oHv82L0FoaDmoQfwhPRoKjYNN5wzmBm2zTrQgQSOoU3Tye61ZgUF8ujVbV1RzZM7bn4b1VbMZ31FF/len3qPj4mwF5CZdixkEzdR5qbw1BNIebaxvf68jn2+uoNuO0AdgoG3cUwcEIDZ+XKHuVkdBoBzDy5kaj+BEGWkquePOWLAYXRqA2JlgdZ4MqmHClBDouHoJvWTYEK113C8d+CUHxFAI+zFz9vqWsY7ol19r3r9HGz0Obwhxv8/eC0dTsogRDySNtxynnaZ8B6mpWGazYJHt7G7bBKI1/h1TI3BG0TdyfrZvDXL1sn2Xa+/9Nmasaeyw3Z7nNpuS2j4SgcmNeg8X8UheH645d9UU+Gf6SoiJA5VM+vHh/I2adv/PJf1KzLA/hOxqwIWLd3Avm6NOO9VynUiv1i9bJRVM7L7OKExt8cBin2CYowdmFAKtLO9jgpQEKb5KIZXeQHQiEzEFiEzImU/7SexXJ/AiV5/rE2OZajVJPBy97+yroClzOenF1kWJ80KQhX0DX5OC5U1qfhhoIP8Td8QKgJpHcGdu/nxWbNtr+GG50Q5LMFTwgMGzUWR7dEamBu0C3wl/w/gK6ZjJ+iOZCsaus5anRAc9lRSK5QZQ2wF4ZAh6rTvgbBefawiH56QYrAh6DWPhJ5Kef1yrSdWmy9dFCoaUoqwBQxRitHyPRsjExL19G9HolOlBESgOya2AgH3iePU57JYeWKZcsP475KimBiIVxUOiOpcVechUvgpHNtSmUNNfdqrW0WKecB+xVeP3zyOa9sEUMqKCms2FTB7+YJwVgbYWVshYNJBf7hzz0JiKL+yDS6EGRg9Jleuzw8iGr5GI8Cw7f1dnXhWe4
 sJDKiuAk
 x/Rm3TJ4eOTGA339cEMnyk+/rudJzOqlPgm1JvVOCSPwzAF6l5HwVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/25/26 13:10, Lance Yang wrote:
> Ccing Willy.
> 
> On Sat, 24 Jan 2026 18:23:28 -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ca3a02fda4da Add linux-next specific files for 20260123
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10c42452580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=10f2b64f8f12b9a4
>> dashboard link: https://syzkaller.appspot.com/bug?extid=bf6e6a6ca143afea5ca2
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f7cbfa580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112d405a580000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/291ebca63a31/disk-ca3a02fd.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/b2112a214b54/vmlinux-ca3a02fd.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/77d1ae437e07/bzImage-ca3a02fd.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+bf6e6a6ca143afea5ca2@syzkaller.appspotmail.com
>>
>> node ffff888148816ec0 offset 0 parent ffff888148817700 shift 0 count 64 values 0 array ffff88807be6b0f0 list ffff888148816ed8 ffff888148816ed8 marks 0 0 0
>> ------------[ cut here ]------------
>> kernel BUG at ./include/linux/xarray.h:1441!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>> CPU: 0 UID: 0 PID: 6017 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
>> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> 
> Seems like that is:
> 
> ```
> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> {
> 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> 	return xas;
> }
> ```

I think there was recently already a discussion about this.

See

https://lore.kernel.org/linux-mm/aVvz3tYdu49TGkjI@mozart.vkv.me/


And where Willy said that likely it needs more thought:

https://lore.kernel.org/linux-mm/aVwm3MQ_ZDa_kU8c@casper.infradead.org/

-- 
Cheers

David

