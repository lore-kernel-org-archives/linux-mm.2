Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C55606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xu165m2S
Received: by kanga.kvack.org (Postfix)
	id F3B1A6B05B0; Thu, 26 Nov 2026 22:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEABD6B05B1; Thu, 26 Nov 2026 22:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD94A6B05B2; Thu, 26 Nov 2026 22:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 899766B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:03:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2434F1A0109
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:03:03 +0000 (UTC)
X-FDA: 85479402246.08.1059B48
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8A91140003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:03:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xu165m2S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795748581;
	b=kDUztJlKeVC2/aOgZCa3dct1EFM4jh8UbcYHPvQmaJZUXUxK5Pk2HAluE98v4UJI1oQ4Av
	I3J0m4JN7s75ulTg7Z6oOXR7TX6Z4vIb5IfDFu/YqRdlHUWKTe9zrf/9go6x8rgrPqzVDE
	Nc/UH2WDgoi5n8iJgOu9ErxNcRxvJgs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795748581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpmEz6SVw1Pidd87JGDfgjXHfjdwOXEDwvQkKuJh+Ls=;
	b=QvPpHK2QfZ9FVk+zUtQ3df0N7wo6WizYgbL+El+XCfCfsF6lZUcdaJZOJCxuj8OoAqe1RL
	sg+ga/QzLnOmKapzFJ6rSiBJNVwQGerlZNCKFQbtD0Ms4bPXJvbKn3S1HxBOpN8paiTTRB
	7bXSwVIPioTRCuiK1mFB5i/AQPgxvZ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xu165m2S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TMg4zXV0ILXrIqCuybjN+P1zkyONhZoSv1Tpf+i+AlE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795748579; v=1; x=1796353379;
 b=Xu165m2SZ3cMtkKCUF85zVIOxqRmKhMgt6u2iN+5e8v2bc2gLILRBvJwQnU6KXeBb/2dBP7b
 g/f1cE3WJP2kars7/H8EMBDHUQdfNMjblgd3VTqb4I0JkwgD5aWJVG2v+1ibvnZYKWsCsTrzAog
 xeh3WwAdobvMduvJ6mU2WSsI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4c9688f63cfabee9;
	Fri, 27 Nov 2026 03:02:59 +0000
X-Mizu-Trace-ID: 4c9688f63cfabee9
X-Migadu-Flow: FLOW_OUT
Message-ID: <dd3c5a28-e7c3-42ed-ae8b-dd714665503e@linux.dev>
Date: Fri, 27 Nov 2026 11:02:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/27] Docs/admin-guide/mm/damon/usage: update for
 report producer sysfs
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-11-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-11-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8A91140003
X-Stat-Signature: 5kccjw7kc9efkgaj5ackzcohqh9arr13
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795748580-865145
X-HE-Meta: U2FsdGVkX1+AXR05UZ5YLzMfmBt8faLaCpEbY28RMjKcUh+40+bQbTy1MwZIBAl7BHDz4RJY1RyPAum9M6/jjchNI0a+VCXF3wEjaIzrrSCBTlkclvKJROcNK/f9BCV5Cmoyh5AU07zPGyyALOopKv7KztzoT1xep73jfmLWbQzz4ev2UrfziWXWRRRBEbJiiHnKSmFhK25loCKEChkV42XbAjlug3H4Y1NnDB14oB3MihR3nu3mTe4K2pOPd356aV0kWHhSaZO5PxKPmpNdr7dhFoqAzC+MJLB+D5OuyhIJHug7c+RG+iHGjbhns7X2IVxpWiPeZReWk8JDVmnncH7RM9DDY5ScSMEICiW/iOg2Ga0YDeHdIwnJuQcArrKoQVBtusA0dTPvmdCDCPi4YLNCHK2Tt22vkacvAaviiUbUL5EyrqkS/6rmrhvsjVDrrJMPQeiSzQESB6Amv6R+QFt24kzNRZ5nJQImfbiZOjkZ9SysUo/rvlznOJXJAEpXB3eXJbEatEIMoVPAPsXnPRMJXGqp1reuo+oePLeKnuxaQY2pXaXu7BiJL8nSIgVxmCk5/Nx84ypgV0OYYbRAP1dHvfCK57XvHNDHS4uO9dLVeVNCXAA+NbLXEGUWkgyTqFPA3938rwc8ROu78I0BbOGv+0PCa6TTszsnRX7LX1UcexVGqaey0NxnpP5nyvUTxzlDCNVEycH3JB7Wez7uzxs1yFUO8rb6S4XCr6afP0XI/bYaCVEiTWAtdvr2hsV1cKwyxg5FEtBskIPxOPgUYB+egO8dm6JMMo/odnf5w2yhZOcmE7VwkNftzNrZqe7lXa845C6YBHnDqXXDV9VC52CnfcXcHEnzJ+n7Jtx9FCkpTf55AbEo3KNTo6iXOofiWUtnDMDGh1xI1MSlzw8iijhigsgdiGMy3D8ne71IQiSwiEWeuSVht6YUEuSahYt/x2EKEfwumrkzY8SkSFN
 Uty7lD3g
 NI2Mo9lwWnWK8wRkRiMRcTheLkWn3sOJW8U7KNfB8nJnMDLtu1bW6Rh7yYlQda0m08ACFyCjguOR+Utm12iya6vA/PgR78AyU8NAiqLxF4EeEQzz5RhcaMan1zn2XFJ9Cn0FkAHvlZM+neCO/HjWk0xXAsFs1IOEYMp83QmWmOqbZ6+3ieU9Ame7Hgi/ncJWCWFYiKLMuIcEvSmrpW0dU45cevpf0Rp5GswsN+oaPeCUY3pZf6zshwhgU1hRRvyMi0r+NR1Rz3EjP6x6UtNbN20NWchVRD+ZRDM7TGAYRyZvJCPcmVhtDxkzLElt6YhXP9sFUryiLLwkvML+4Dmi7zwmqDJcVi27TaolHFYYzJFaTmYt41FzbG9OhkQ65C4vh3Qi2EJKOnVsnNmJnyMH0eqpss5rHU3FGfFrNJ6g8aVJOqxEloYdo7aNYSKAHgTnCcvVCX0vjL5aB/z6BxSHfoK6VKDCHPCANMtEuWKal8P+uay4UUJZeBe2/rN1juglh4dv2QWPMJs1YBPgr/Wk7BJjh/2btKEVSh0Ph9QXsPLMG2L7Nq2JoryX3qFnsaizq5/8vtvMnL5KBiCPYN/KqV41KBTc11RU7Ao02SShsZO60zMaVpwcsU/kSHSUct0A0VxxfIsQ9qnkgcAyl+DQczza/djgsfeFKfmymM3UdgFCOV19yGFMOqCKqaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Update DAMON usage document for the newly added report producer control
> sysfs files.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

