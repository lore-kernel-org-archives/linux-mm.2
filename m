Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6668CEFD01
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDED6B0005; Tue,  6 Jan 2026 14:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B766B008A; Tue,  6 Jan 2026 14:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4F86B0092; Tue,  6 Jan 2026 14:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B79216B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:46:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EF328C959
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:46:20 +0000 (UTC)
X-FDA: 84302570520.30.32762BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88231180004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:46:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLqCeCwG;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767728778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URX669MPjltVUJFI/791Isky/Jh/x/44RN7jyDVOBjg=;
	b=LpC9L/Q1BwUpE9x6Rc98WPeK2qx6PnyAipVj52M7J2OrubwreY5kHF6piFzbpecH8L/iJX
	k7nwVPAkdfVZ7nf454weaF0ukujzynyoJ54xKFVgvlnQRZc0+GCVZG4ilzSsxNE3JlTVqF
	pJYlxAVzRu+BKweh6Zf4fLwAjSey0qI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLqCeCwG;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767728778; a=rsa-sha256;
	cv=none;
	b=4jZU7R3q9HFtfWcbw4vP1XkLQWUC9LWpCGqBp0VcUxRKz+DWj2PZJBIY7gzEUAFVnddM8E
	YcIPdo/4V9lwh5Nkawjztyg7LirLox2AOjowZVKb+7SPx2ePCSV77QpV/8O6cFWFVjyNLY
	SW4eyE1wlbVqI6qljzCbjgCBtxYtT0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F221260007;
	Tue,  6 Jan 2026 19:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F2EC116C6;
	Tue,  6 Jan 2026 19:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767728777;
	bh=dvajO2fLli8SqFjSpkHtIoV/jmZ3HdNgl4b9tT1yC2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LLqCeCwGP8hC9Mq3Z1J+aX5sDpBXFVT3fM5KhxVGNm/YoWbAvXOLR5QWiwM/NdJ/e
	 lloR41ZjnCzU6fVVURReq9frk0WkR/ZFz9AG9vI3/oNuDJPvrGBvTR4pZKQJ8JvF4t
	 LkGknZkIMAnHEztwWly0yEClYlZ+PBg95A+vtp4SKJKgyvke7+L/UMAxJeQAeeHOBZ
	 AK+L7lucRmk3igoRsjmtpIu+c76SJPKDWD0pEWYho4lW7bwz/PKZ4Nam8chM0m5amV
	 sCK4iLzoZlkWFXXmA5HyE0Ur9hu8bfv+r9IklZsC1WA1YCD3gehYNDzusHeuTW2h32
	 0omxg/6gsbFFw==
Message-ID: <1690da61-412a-457a-9bb4-1135838135da@kernel.org>
Date: Tue, 6 Jan 2026 20:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
To: Kevin Lourenco <klourencodev@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Kevin Lourenco <k.lourenco@criteo.com>
References: <20251222141817.13335-1-klourencodev@gmail.com>
 <961095cd-59d2-454a-9b97-493d12f296a1@kernel.org>
 <CAFveykO9tAhGnKCnSD-2_wt3QxMTNF3sW20NGwnPK-3yMd__yA@mail.gmail.com>
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
In-Reply-To: <CAFveykO9tAhGnKCnSD-2_wt3QxMTNF3sW20NGwnPK-3yMd__yA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88231180004
X-Stat-Signature: mo3zcjatozjuyguuq3qrmb56ox6cxke8
X-Rspam-User: 
X-HE-Tag: 1767728778-903172
X-HE-Meta: U2FsdGVkX1+Mrw6jgVTAUu865IyQcigZKkztMVoEFpVfsTCtAVrIpB6JZchQhdFzSTf4PxbdOiSMojbw+MfxSECs2IZ1W7H4SWfhq3gMNjEOot9u1o33L96C/5LedHtFw6gGT213Dc5VnNqq3tk3YfFeJQbsq1ImMDVUZKowL8zhkYtoZglQe4CO40efHlvgTjCQZhlMlTc0SyKdBnaLRcNRAYa/htSP4lRUov5l+j0zDcdnsTTmweQByVKtEv6bejY1vMUeJkBTJsm3bws9UMonaQMcmkYKtVzq0kJGtko6GnICa+uusGTF0TBI6KkStwY3zf2TAscv0trrNVGW63ZkNTKPJoFo66iGXvoUHph4EtRPfRSQk5JObD9zIdEoxxHmwBgZk06Pipf4oeRhDxqgvlvtavnW227IHea0jCCLha4csnzHNCt2y2ZlfRuaG12s59Nos22DdvUoWP0eJPTlD7Hl/f1OgFtqACtja4L79L2uz7dq0eGWLZb1gIoUXOhd6U5zS721UvcstZAPhutlsDHkZN9eGIRKQMlyuHUTZrTVwvTB/b3yjghFiLmQh6uh2MuUVGdMlOaL3lm4gcHLnDfsCJCXls9LfaUagopPispSaSQ7C4bxYX4hfSrnrCEgV4QjKkRa8rag9rQ5vpYtKljoUKKnNeIOv0lnw3XO6XmIAzGKOuPp52zAwb9n6J9lPLSgftEqcO+KuTCSq4f8CP0A7Qrv/J+EPrqF+Da0vUuYsCfwkl4nkMpREPUpVAX14ZsmD8MYIBk/DqPtNSB5u2FRPYc+ofX6xxuXXCvhRYg4q7wxbg8P3CKt7FHI9nMrBnTN82fmGW9ReGP2BloOrdY/OogJF12KdsXHWFT85eV9gr6jgPoEeuq6oFfGMi4518dabwNbxbyo/eSwlW3FM4TlIJUV7Pjn3dk7adYG55OvB+yk4lzcUsOdB3Klz/GPn7rfcz1rJwuHMMO
 qBIQpxem
 Fo/inSxlcIYB8l1OTt9xpDuvinnzev5hUhx9ej/1IOFj/uuOFiS6i9QKZgLTRLHGcC54tXGFk3KuFRJxsMmIEVRbaiZBTPzItoq43pZhwTHcevRpDa6rBvMu84QO35bTHiVwBAg9+2YVvWS2h0GPfoPmmmA1BxSY+JqqxtFoIUxbCYu2kCCnJNv4NS6pl16pRgAdGQGQZedv2nXATRIaJPFqedRPZN1B4ne/Qg4FetUVfnzyp7E0PEz4K2V/0lFB4gi3FGLLGeURCihJXIIw5k/Mu2aNx1fcNsfXXwxySRfSRFwJwhXL7CassCabVLE46yHnp17ijKuMXNJdIoS1VygFNDOp7GAVHSPAu4RRG2dacck8dpLOuSlxfsMymU3BrI+o3elLNWAdxwnXSK/4CEJzGC+WkiDq4rNNkulx3ajuAISKD2XaWJEdvp/JUBg3+4JBe7fQ/3nee73jkuKH1ehOczIGswITpH77bqI8VXF73iX6ko3cHxkuNf0VOxHnq9KNG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 17:16, Kevin Lourenco wrote:
> Hi David,

Hi!

> 
> Thank you for your thoughts and recommendations. Well noted, I will
> now start limiting the commit message to those specifications :)
> 
> For point (1):
> 
> I see POSIX definition like this: "The byte position in the file where
> the next I/O operation begins."
> (https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html?utm_source=chatgpt.com),
> so what is almost certain is that a negative offset makes no sense /
> there is no hidden mechanism or anything.

All I find in that regard is

"... starting at offset and continuing for len bytes. The specified 
range need not currently exist in the file. If len is zero, all data 
from offset to the largest possible value of the file offset for that 
file shall be specified. "

So, something with a negative offset sure does not exist in the file.

Which makes me wonder whether we are here in a scenario where we would 
simply ignore everything "negative" (clamp offset to 0), simply return 0 
(because it's not documented to create an error), or whether we are in 
undefined behavior land and can simply return EINVAL.

> I don't think we can
> accidentally break users, my intuition is that nobody ever
> intentionally passes a negative offset (probably the same for len).

Some programs do stupid things, you would be surprised :)

> 
> We could rely exclusively on the user to ensure the offset is positive
> and follow POSIX recommendation. But since errors can occur, I think
> it can be hard to debug where a simple test, the same for len, could
> have made their experience easier. I think this is also the path
> FreeBSD chose: https://github.com/freebsd/freebsd-src/blob/main/sys/kern/vfs_syscalls.c#L4918

That's very good thing to note!

Interestingly, they also check

	offset > OFF_MAX - len

So checking that offset+len will not overflow. Do we want something 
similar? (check_add_overflow() etc. )

> 
> For point (2):
> 
> Since I think nobody intentionally passes negative values and since
> that makes no sense semantically speaking, I think we can consider it

Well, then why document negative length? ;) We should be as clear as 
possible in the documentation.

If POSIX would have been clearer we wouldn't have this discussion :)

> unnecessary to update the man page right now and only think about it
> in the future if a negative offset gains a new meaning, for example.
> 
> Wdyt?

Likely we should really update the man page to reflect reality. 
"Starting with Linux v7.0, posix_fadvise() will fail with ...".

Given that FreeBSD rejects negative offsets I guess we are good.

-- 
Cheers

David

