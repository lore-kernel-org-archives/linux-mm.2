Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C8CCCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 14:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA608E0006; Sat,  8 Nov 2025 09:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC21D8E0003; Sat,  8 Nov 2025 09:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7D98E0006; Sat,  8 Nov 2025 09:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 873B68E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 09:30:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37585BB397
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 14:30:42 +0000 (UTC)
X-FDA: 84087675924.05.1134DD6
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 121471C0005
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 14:30:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=L1AYuXN5;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762612240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IPtUJbJzE8XpnfYFuMq59jzeHUiSCdVZaEmuNd5LUQ=;
	b=2UQ1JTvmQ4OrjHuuivtpwp8G7OaEKOk1yNiysSHwa04Jsh66XJ1RnnCPUFacacdA/ChqZy
	zWkoCYf5dtw7FUJdkymxxDnYCw33DZIo83w1VLvLPeQVFg5ilxEnFUFz32Q17SHKowlPfm
	wGkR2nuHjhA4vCycw1ShSfuvbejmfEA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=L1AYuXN5;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762612240; a=rsa-sha256;
	cv=none;
	b=cyUF3LEe2KreFGIvGobA3TaIiBP0K91EmVipriHunGejfxv8gSQN/7ir8bQTdmiMFvsbe2
	I7r2lVYPwtsKJgSLRB30ZV0DFY6vpMKIgZYvCCf+At71wlto2IeG1LrAS3z6sHNI/ricYq
	eHoEPmNve0IRIjps6UvlSxUzpvCpK4Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1762612238; x=1763217038; i=markus.elfring@web.de;
	bh=6IPtUJbJzE8XpnfYFuMq59jzeHUiSCdVZaEmuNd5LUQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=L1AYuXN5ce51+Wz4mZqZNHbJYroDA6wauSmjN9GBxRvRwGvIhIoqV2KsRGebvqF8
	 yzDrl1z3TG9uib7jDG5btUPCgd43PfB1gdrc1FSkvNYt1mccpenpECST9f9+TiwI4
	 Oy0YLcwUmT8pk2Y9fbUpzPyEplqbdxVututpJZsnOZPzm9dl2mh4CIkJ7LCNfbU4D
	 onj0pKE8OguOiLH02xBh3ETY1Od0wsMnhcfEAuAiwXP6puE/n2CpqHmwJr0eIRJbc
	 fcTwS2yyXa3D0eJy5RzLwmks/iurwQC/NT21vEdEsTMkRwjJVaRq0uBM3YR3GuWXP
	 Kf1V2LbWabYKC4vPsA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.239]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MQ8Wa-1vdeZC1GTI-00W2wX; Sat, 08
 Nov 2025 15:30:38 +0100
Message-ID: <630f7b97-323e-47a7-b4af-50978d4f1a71@web.de>
Date: Sat, 8 Nov 2025 15:30:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: make24@iscas.ac.cn, linux-mm@kvack.org
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
References: <20251108115346.6368-1-make24@iscas.ac.cn>
Subject: Re: [PATCH] mm/hmm/test: Fix error handling in dmirror_device_init
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251108115346.6368-1-make24@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:44v14SBETpli/qm8/ELghyCqY1BCMYr2ao9UnqZP2YiLmNtQi5c
 DOD3rpUedMBIrBvSDIGU107XXiZbUoV1+VD3HYAYTHMMQkWn2FYvFZyNJExowwjx/LxjSnQ
 v1ZntpVIMNf2u+vGfCSFz4gadnJMyPAkHwCgsSnfJ1w/8JAi2JUQHmIVuMz3+s7kPJLDdfm
 o7jX7xmOMnFuGH5JdAN7A==
UI-OutboundReport: notjunk:1;M01:P0:G7udir24tHk=;kI/+8dh1hYDJAuejmxm0c+zsN8D
 M43L00tsXDkMnHJUDWyNjnfgLqAGEVkFOkfseKcCzVZiBheoZNosWHcd9wiZNE6w1AaTtUxN7
 fnSd0j/oVlevm+Y+5quJje7n165Zz47hY7VqitAQDY0T4g1BqFJ/+RswlAzk6QIB6tzy9Vnju
 dqqFOGDHjI0uAsrPZINfQgADuY+29pkHqv/Fan1XSinr5iORslf6zD+YoWQHVhhayXXVGszhh
 iusqs6wMVWyzPWhpyjYg1CN54YWBl4K16fsyQqj9oPAPDOl5Vle6UE/7hBxWDKai3iZnaeUoX
 +FpkfHXSRiC3dvJQw9EaWYFi+EphbXhzHW86qiXGWCSognFpFkIIUiN5KHPR+kadNiW8aEIYh
 62KWb7HXbOCk6QjkvcojiZcY0btYro2IuA2rpfxkpL6PehbFxuVKiiXSUOHzYk3tAYknXqq2t
 /72KMJCmIHCjmW0TK2j884AOwtgbDiQMNFbFJyZVgqCywHvdS5Ok3zg/cacMEEp0I0VIVKR8N
 2YF4XfDgmn/S6EI6uRjQMLPOsMfkV4A/Hymoec3pVx8CeTvoWN78hc0/lpSGbadQtRDx0S3Jq
 kA1yHgwJSvWVIjDPCXuhpPw59A4CdEktzHp0cGIgkyEkx+hoJmnZcuG/Yi4pb+n8jykFGeEu2
 k/y/iQYMWCGK2ArSI2d27LNAAKNtHrxYJHyHkLc0tlJ//ayPZBsICfI5FYFQxeYU0PjuI6tVi
 qqE+/yY4PSBTkUG4Yd+ALXvCuAdM4eA8TSD4Tc5aG2cn947xo5oxTTJdd0jfgQb1EZ6D34Hkj
 a57NtQbagowXvop/TOEWKO0febx+DUVW7kS9j+lLsOFuhctlxN5B92yZXCajrh70fAuKOjTyW
 6KYMcYJCHXXAEQ3QIgt59liwrah78tdWcucr/iB1NCDsOj2qQCnQ9rayKAvjdHacbrl1VFE0v
 kCh/SvyZuDeBxF/bfzHrs1df4ft5/4L7MBtcp2EfTOLGC+yyxuc+A0BErEjapTg3yMd1iXclR
 5kiMIqtmZlootOA79ero8GVtUKXM6kxpJkMAHPiBXgp/QHAKiTZTCaNSVl2LCwqsCSCKBWboB
 ccu/yy+blR674TjCU3IGRpEPhmaB+T1ncB6A7rb/57O+QFkEBYCxokk/9umhqBlESiW9RM9nl
 MbAlKFRSATLRKJzbgdnEBt9PTOKp+kdQo4ooU1GUmcDJJP7P6aRnXVBCUPzW91wcUfEmc4onu
 uHv2Ib+G52M2TKY21zLhA1oKGFjR7pPTWEHhsfTukut7/G7naCQ3uvTt9rZl+D58EyzI5QuEG
 mUWRnool4Vl+k3up/tdB1y/mgpayQyUOm0/AtQr8qshfNKClgsB+T53lMTfbtIWuNbAk+dKH5
 REPY9hboR+EodtE3jlViwW17r+5aVsTGSby4iMigkitMLN7Xwot8tS36I46SDbxdvmkMtjzfb
 klDTcmWuZN3WJGmXZj4fQwwCiH3ypjSIeEmOZAmuCIp17jw3BaJHMKFr4g1/OfhwOzmi6cI0R
 m1BP1tHyftLPV6cpndpGwJgcQljGAzeAMmW/Eob4s73rjavlFIfKKo1hmb6+9tQWTkjxc2C/+
 LCgzXl4Uo18OX8FVjl/15hxdfyfN1GGqe99AX/T10ww7YSEkhuFb+YtXPIxOt3NnbQ1ygMaRF
 jbxHH0mP0ZkAwrjKoQt+lfi1LI6C+L0u1FuIa4+UhbmhRg4Gfg/06P5ngb+xOrL9OID+aisTA
 1BpDH9+BJQRHEgY3Sj3gzxSvKBC+gIQCqP7534AM19J7FIkdROQxyEuq+thBOUfkhPrFOL1wA
 KKapClnEKSu4Bl018lEhirKb+nas2ENm2QWxNgRv9rr9yhIrK0RC8jDsQN6XiwskKg9tpcVy8
 I9kobwrtTkdLbcB0C8hDZJ38qkYlNhUr14cVDsMaASc3taztqQsiHS1nc2MLTxlFg+iFRSVhS
 dRTjCPSx35MUijdtv8XMxPkuh63MPRR5Y4RoKBxmnQM1NOA/SNa69Nk6CYYjmtfb7qrZ6ekik
 61LLW9Z5M1MneJ/IYYPbVJQ5uCvupVneD9BNM90y+uhggNvElHX6ybP5dZazz3lTAJ4vb3QYS
 Y7gdUEscXZdE+ejkJ8h5NsKAk6kqV1xFqwuGmyQv7mm3aJu1f2U1wzLvVzZsSYJBWdqzOBx15
 +mk4flXeOB5ZFeJuRttD01Ksuo+a4nJ5JlmdhZJbI9xKo7aLTIo2PaqNHx3oXnI/7cA6J6YXF
 2AcgkuMRJf/xg3+2J3oS7a+Zy8K+0Pi8q9fApDma/7eLJI8igGn4Z2st522p2SpMcRfv+Lswz
 JaDz47NNu/joaGXhZACYTLzn2HSx2SDXGmYKpFfKDcVhRIRe80EN3DLGKs5ErEpTcVNTQ7h4n
 LBHvSuq9n7s8igicjVwmNbMTzGpJM9oWaJ012UBc7E/WCSc/UV592WwTQ4CVA2I7Xh3HYdSye
 zdG99YR6gWWMLP6n0ud4OnFFxX3drXYqR2L0V9ZDZ/FfUSnp4+vBr8A/A/1sTpsK3AfjqEfwE
 LMlp0gqQoJstAjfHCuGFWqZ1sECYNQ5undVm0XwU1n3DFicxECH/KMsOFUfGJIMdAexlLRy8l
 2kTDBoDUe77hTYz/3S6qiOl8wYl2ceg/idwo4tXrsTFwm44qVOQnApQ0u4btc5hw5sCypo1YV
 SUGzU8ao3xeeQ9+SD+m7FuAEwkLIHErk5K3GsSfQDfns4hFb9ECj6aDlJhlQHtgpu67H4OPUX
 dqwycUqbpiDxwE0/c6loYKJeYLq4AxrC9jExnZdsrxlMwYwAYvepkXuSd7LEx7rEC75KxF+xr
 09ZrqVeqgOcEWZYawGfnXLEAw9qJh1ZLXVoBze/BN4CUE4CAePXgSvHYpqDrVVLukn8jJZodW
 MuOjZCZLXbWK2CXLSefj7CfbfLGbJ6kIrRlPAenky+w0Qw6LHv7EFPtV9x+Eo27PJtKQgsO0N
 /cHKqcQyGfLPDOoGX3aIw2+Yhy1e+EYtWRsaqvhwynoPbnelN2RVp9DUZUX8bBpt0qoigOE+k
 7ATGrwycYSSR0LdrMrf7FO8zUY0pftX5tR9IqE5wC+LlFu4linS+7TVlBOSrLyeKGsVFUU1/T
 jMM9Lpa4dsrJFb4Zo70MlZX/z5IsLrFojI6gbw4N/3xB9i4VSaclCebCN4To5hIsBTEE3ISsD
 52BfJB+++CSiQiPv/1drHxtkJ/4ndi88qGHKlXEiln3Yc/F86KAwdQss0semCxP7yHx+M05lS
 svqCuzU0Y14FtMdTTEuV9kbP9RrTRopt+BEEU+NrUH6hwXyyrBpmKMJz6u9PkbdkfkHwYDH/t
 T8M7jbPV2JJTgBwCckqJxBkF8JFwYlvS1lwf+UMOo2pRaMYaqxRNzr3KMMdAccOTyWuXMsR24
 0i3B9h5N8pSbDcNbLKpTZ9Q9ymM6HTanfarZPV5KG0EzjZakPFkr4JCwLtcYr3mQ0sehk5rEZ
 m/g5J+CD7ukQpBd7fNS42zanl+jYy/nHDgbUhgGDHE4a2iFORUU6jpj1rPGK63lJuBg8Vw5ev
 HJ7Xr99SEb79h0/aYzPL5cIHDJdgc9zbKM+ZunSTdgjBgQdFnNxavv+8OT1ouyL6sZcY5dB3h
 m5E8rH+9WSqGqAb+emDIBDc6t7Opbk4kHQswIsnjv+of9D/q1M/yR933xiONHVFuAjLtu8SNw
 iA/7RvEY8RCAvEWdxPY8c7w5gqOOO11damz7McKHS0Zl1VRDvG7J37kKK2YvwmFjl7NE+IssU
 i2U8x76SVHyxhf5Mh8Q5QDoEHC6El7bM934a3K71bGJDfd0t9aeZc+XMylqnfFVj0VFyPA3Fp
 GZTPmm+CYASXL5+o65vZvPhUM9F7a2UdnODbbzG5ONFLN2xpTtVzk8RIOIgzvVD8yGgk+5vOn
 idUy4m5mT7yx4v+b/GUUgSz1jURAE1aQqvsKTR6U3flLSC1g3YFop237f1bKU8tmya886BYDp
 nYQHVUI9KHYnZ87uVvx6FeclAfimBXwNjkdmaNmZ+5un6pASNJbWec+PD8yGz5czrxhPOBHzs
 PSu/meBofYT6JzKQM7bM842hUkAvaZdm1kHhXcUnNC1lP1uwn3nj0PnLOFb9CpETOSIf/yQ+v
 5usBuS2S0YshGhrEDfquAfgkbY93zN5/eJCNEoTyU+Sz0YyC3NwK0saqHedqN1I+hJLfg46Mt
 BPCShyr06b8bvSPxcTvD1Vp5ZcuDbVXHMt24BPaIK+JoNKRCUVu5ghXE+UAWe1Gs+MQYduOUP
 AiSZyLXBnshAFCWcnlsy3HktxreGkvyYxDrskK5JQgK4Q+IDsI4e4yodOrjdDda0uHnZaIxtl
 2tjGMuanq0nkbRUHT2KK3Cdx87LBIOkxHJ9oRPMQgnILaMVKOQ6qk9SQiuLlnL+FOG3BWsSAr
 HEuDXrFWLaH4NtkKBcoPTKNtV+dx/ernsnBSO26upnPsm50ityCCqBSDPG8TnPmIwQie/NuHi
 WPBK9buY10wA3K1N1O3AIM7SULAXTSW4KZMpvj0hjrfjCVO5HMjiIfMZQarB7mNKLc35KjbVG
 IwMQeZxGJjcAzW0RhJ1xfjYnPAgbPAlZVXCcPwDFWnOBwBBGuDaIPwJHE91fG5LfOVUeavwxo
 pSlOaJkCOUAZKDd97M5rrPBugpvcGp3F7Clli7b6oSeJgYRuOI5FyeOD9ArPw54kgtauGyqEV
 4twDVep7RhO4zw524BuQ6QJYtDqOX6ycTAkXy/9htbtGhKAHQ8Tl0LARNH2e3kGkOwqzJXelF
 Gz/8CRgF2aocbgmvVUzx0jBUlSL8bquLcEQa7gDURVrIVTYo5BFTSZjkHDytRq4dxzGvGDs6I
 R0fFo0K/RVwLrYbBwz8HTUAcxHzWwSGbsRMmE9qXB439K1CV3VM9NzOCk5LeJSanadwGgAxvM
 iO4dQ372ALn3fP/QLv5ohdGJ5MyDZYvyH/BDPfevoE1zyG0g4zW9C9C7+VCl/4refHknvxlyx
 rNqxRlCxzcVfeYKN/xCYMVGTBArzKFKT8KnW9ORmDcQajLznLDXL5PuZxirULIVtq6cQgyVld
 eRl3A==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 121471C0005
X-Stat-Signature: 46awczbnf5cm1xtndy7uchu6ddxartw1
X-Rspam-User: 
X-HE-Tag: 1762612239-113682
X-HE-Meta: U2FsdGVkX19Ya9X3IFQE2mRgLJJ6I3Lam9yhB5Z4CBEB2soxOieEVKRJgCaSwOVB6AZIM6EWokf6FXT8unWB/YrWkunp6lwIIUpP0JH7UoCJ7fJU3E6IvjUd0MPZyAfGenR9uI4zKCiGEOeYZmM3OO5mSsw3Ya68OcFvFp3/qzH/R33DlP5xQEo8Sc1rJZQaox5c/1Q7gBHzK1dWkhTSzcCxHjUEwxL3gL6a4Ahv6VulyzLtSg8c9pnWg0DsD5YVd1QO4V7stwrAuU++5TTwwdmFaZbhScLCddfbbS14Lm3JuWJGcSHz5UcC5syP1bUT8tCXcgPj7qaMotJbrVgNAk3vaXxaA1aVhO46Z4jOIompQb94eqZIGKWDJafbGtB33jNfnyTJrOhCEyV6cQXy7Q2CXDiZ7OdbdLXMi8jhEg0zw0SxqvggoAy4TL2tztDaX4dHdg3qLKS1348VyfoWXKlQZebYcfw7F54XmI97XYHTyr1G60FYADNkkWeZ/pxHT3QKeXyai9PyaI4bLfPAKPRgFbYxI6m0tPb/ZbqRff/fTqxVpMqj6NbqgXHyLs8+8EDxtab2ZE9yDeirAPtUsPqHgf2n9H6cqflWJWq2/uG+AFbJ6kzLP4D3PApLlcmE1mWXiSO2ixnRiPZQWpukGRhAWIf4QKBsU9RsrxwZFmNU/KPLWJVOCvraQoFbnsG9rxxhdirjQNPj4WnQve1IH3NhlvjDfMPQAqN7ugylahsyt5/a5foElJjwgrv7idyL6yZWrW17R1Lu0nhMg++yF09Ztgu1gYUbe1B+dhZGPYSVhlZaVtyNo/wl/8s3wz9p52jLII9V3iotb5Bib2hEBSGgB5BMwX5+SPv3iCClmhyhm+tQY33qn0p2yV/sQboq0zQNQNTXFYnwqIjn2punyG8KIFUFvygI5i2+uRV+Ci2Rmy+cbLLvv8u6SFmUckSDSPmk6bi98HAs+kjePFx
 C3+peL0s
 ltVI3798b4Z+wfr+0dBfojSFPQFCGJMXJ1SfJj4o3fCk11NP0iuKGQf5dJ3Mcn1jQcZRlAvXIRYyPUm6EXMAZuJOuIEGLHuyLoxLy74XoxuqdSYv+aXQCJSiGn8zUwnt69mevM6bAvPX9TI1EBAI68effv+HCPw8onVgjivIBdHGuKi+skX5mDqxk7HLd/8ynqyzD/5vwc79rPijXtMEYH5+84a4D7MfZAZgaX2Q73nHfygeEWYoGV+zuUUoWQXmKpjq8QwBmyMXy22HbPuenSPxLegaI1Gq+9yVylMf86KZhDaCo9oPj00QkRgxYWNZFFN6C+mKG3r0KddsgJsKXtSDbVEXKdFEfYQaN8CTT+ZB9IClelQUVMuUGmRVSJgkr9EdDeKjGczT09jEJfo6z8fwUph5dqNXHgCHIpzqUbakcib4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> dmirror_device_remove() lacks the final put_device() call to properly
> release the device reference.
=E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc4#n94

Regards,
Markus

