Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E168DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32C86B009D; Tue,  4 Aug 2026 09:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09F56B009F; Tue,  4 Aug 2026 09:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20C76B00A0; Tue,  4 Aug 2026 09:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 724CE6B009D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:57:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6F74A01A1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:57:03 +0000 (UTC)
X-FDA: 85063738326.05.724EF63
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4511A1C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:57:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="vHukB/HT";
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785851821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBsWrMLZ9IzD0m3McaFDhOmIT6EBYDLLbBBMJYpe3Mw=;
	b=srd1KX7GQ8mD9ArqxRpJ4p4aroHIqeJds+9RwkMiUog+eQEW71m+fIvHd14TP+r9XCXw7r
	bTQkvZGPNC0+xRHRiBpZiNkz2ta+OAmWIBAlJFoKquP8dJ12R4Us/HdxH+NsuG14KQHQRW
	aImVOw9Z9Rra33LdccwETJhT/qKEoOs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="vHukB/HT";
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785851821;
	b=MN2jVwCUMqYEsnQOh2zcPsqUV88wqottWfiHa/ShT136rhw+fLiZX8O52J7eF4HPWbjtrl
	EwDWZbxuK8sSZKCNFCoCn3opzVY8iHLgQpfi76PckdOVT9Oc/Rz8IvPvNEWVH8bMW3d8SQ
	GDalOpl/rI5Xfy40HQZZKOl3PZ0k+QQ=
X-KPN-MessageId: 5bbb6a80-900c-11f1-8f54-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 5bbb6a80-900c-11f1-8f54-005056992ed3;
	Tue, 04 Aug 2026 15:56:57 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 5bba2d42-900c-11f1-ae90-0050569981f5;
	Tue, 04 Aug 2026 15:56:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=dBsWrMLZ9IzD0m3McaFDhOmIT6EBYDLLbBBMJYpe3Mw=;
	b=vHukB/HTeJw5AIc2orXHKliiewULrRD+H2BHkbgUGkMyICHs48Z1HYymYTA49kVAuzPxT67Dbb1K9
	 vr2FnEIo8OtKaCs6EiHHnCmoeRrsmtl+f/s8mJUWdqEWl4Wklmvz553sggQw0drXhgAWdloZNSOeky
	 zAaLl9dkxBnGMJz73yYKt6L6rbYVX5K3UQLQMWHg28T1JSo5cv8/w6Erh5p6MLv16fCosf+gvUGrgM
	 uCTI5cUqxdaBxNALkjxqpBESqWfE5DeVNzklgwnvkCyEhwJZerwkhKHbVhbJAPsqKcVfqjc3AmJpVt
	 FvoLgeFRy6Pq3oPSVZn4wGNWfBzQbFA==
X-KPN-MID: 33|bSkcPgtBDk1gKMWgyA3HaTgwp6j+zKz9P/adMdjVcl8l9WJ1SXLkUfRWBhItrmf
 T9Nv4XDLjbSYhTSbUAqdk2fX/VT7tkRiSp+eUOrKeWoI=
X-CMASSUN: 33|LAGBz+PPp1YI5gX1WJ7hDWL+U1+b6MeCFoghNwngiaSKSBfbBbaqbo3yaZ/Wah4
 E+avM+Ydyes0tBkWiZfWg5Q==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh02 (cpxoxapps-mh02.personalcloud.so.kpn.org [10.128.135.208])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 5bb4102f-900c-11f1-916a-005056995d6c;
	Tue, 04 Aug 2026 15:56:57 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:56:57 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Daniel Palmer <daniel@0x0f.com>
Cc: ast@kernel.org, bpf@vger.kernel.org, brauner@kernel.org, corbet@lwn.net,
	daniel@iogearbox.net, farid.m.zakaria@gmail.com, jack@suse.cz,
	jannh@google.com, kees@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, mail@johnericson.me, stable@vger.kernel.org,
	viro@zeniv.linux.org.uk
Message-ID: <1267570591.181935.1785851817769@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260804134225.3631912-1-daniel@0x0f.com>
References: <al_MqBrjDW1QjRau@daedalus>
 <20260804134225.3631912-1-daniel@0x0f.com>
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.226.150.234
X-Stat-Signature: 8isuotuk1fpbnse99z36eoec3kyxeg9u
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4511A1C000E
X-Rspam-User: 
X-HE-Tag: 1785851821-504556
X-HE-Meta: U2FsdGVkX1+CQ+iXFtG0g2Ka4XkpUBgynvlMVUNecrz3vDd4fNIm8UFiahbAX76FANid+eFcJMKB4g9AuNfzJVruWJpR5UmTEuoohy/oC5pxtrv0cYZFiyKa4qi5xKisVwcAEe3rXWgCbcjsEMrPwGbCZhgYhttZY/Wpy+NC3QLhAbdRlqDIerEnHKhI4Ulxr3JhZ0EPjVKonqcwlXL4iTpfihuozDZDj6PreGuGtjrByCwseRJnae0A9VdnX59x/XXAxObNf8QbTbpVVVDVQenGFxLP45u+6OBMTF4FxV3wr7AZp08ueiaIpTCfchdIaQAYfoId9LlKALZ1B+vZUpjpcBS7cqONLteeHwPQB3ss8c97aPjBHaH1eIxUIUpwOPQNcltRObznZ+hcnrt9KNAikV8L7qmJNTnmcUaiykeKlDgxdhnsuddjSiF8Gw5bVzHX4KYyHWxsuKzWGD56jRW1ZWBwy8PG6JeyyQ8j4aTPmpe2r+T04rKX5h8D1shN4HafKPhuYTWF/bh4+HrxlirW+GS190f/EYpAmweQmfs09K+IUI90mLA6o4Yzvgg7+7KxfQNGTdbB0IWKlsDyBFCxOeMuEsnu7wnnhq8fsjq9VDzQMnK0pxTtVnvx7CVODfnW8AByIivUKzTnuRmT0BHO34SbRRpU8iwaeDsN3/fK2XVgw6IKiB5ore0TkLq4xaBd+wQYcn4EYBpNVLKQSH65V7dNmb4JmG4QV94TpEA+TWkqgyCa3gjZzy5KYLasHpWimGq0SskAfpOm3BeTk2KCLzirlBdlMk3NcXP6jET/XVwiGXzlP4kQBsgr4UurjKW9wCyBnPPW2en7q8vnhac/jAr06XAlwLsn+iyqj8ikBdBun/ZbrC8gw/FPaTckESZDDgCqv6pIjo+cZbFtq7r6fpK97iY9pGOknrIuj1c/6w9y481oMrAuuMz6Jnnh79TM9Jw+Y09U9c3pDbL
 ZvqoJdPA
 OOlReKUmc9mNy92m44+dGwDiju+15mMFEkzBvXPhtA7+H8FBcDT41IHPJYr2WkGsb4ZYHoEPiPKDwEHS0Yyd5kIjmn9YcmSu4/bToIMnGZIMhFVKcpvolhsivVkgFn3FMIC/hZZh8C8+O6ZzGNbGBWQiay6ZfR1Ovm9AEb+VMnZv6oTcWrU3wwvzGKW4Cgq6rwTVqZt2R073fN7RrVvdkNo08ylbUKvC/u/pFDgJTe3XsupfIjs7hCYi8M22f4ZvURiw1tzzs4mx2n1hFanIkXMcpvGfxZq5iPP4pTWEwrBuF7k9DUG2U13vb/AP6e4azOh+z73BirX9hqyDLxPTOsiWEVS6P5fbBbj/ludwi5tpVDv17VHiMwKSCpztudQ22CxbOInwJdzwEWInRAZqSM7hGI5uTxBQ2e5+lqyHihzhdrIV3oGMPdXkmgMUpGzl7PQJ9at68K0Wwg3RCOFjfXb7b2J+d4MmXxt6tQwwJ5vF9MvL2MPuEmk+zqXSjDfLKZA+cO9lf2i8ygkxCP93ERT/k8PbCXdgOV1MEI3Ya+kO9VoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Op 04-08-2026 15:42 CEST schreef Daniel Palmer <daniel@0x0f.com>:
> 
>  
> Hi,
> 
> Sorry if I messed this up. First time replying via git.
> 
> >Afaict, currently read_code() may blow past what vm_mmap() allocated
> >there, which may result in memory corruption for a non MMU system.
> 
> I ran Fable on all of the "nommu files" and it found the issue this
> commit fixes and the above issue,
> I sent a patch (co-written with fable) and we proved this is an actual
> issue on nommu via a reproducer tested on a real system.
> 
> https://lore.kernel.org/all/20260710121443.1059549-1-daniel@thingy.jp/
> 
> Thanks,
> 
> Daniel

Charlie Mirabile made a good point to me about this, namely that on a no MMU
systems, if a malicious elf can run, you are basically screwed any way since
there isn't really any memory protection. I don't know how much worse it is here
that you can corrupt memory, given that this already assumes a malicious elf. But
I don't know if no MMU has any other protection that would make this patch useful.

Thanks,
Jori.

