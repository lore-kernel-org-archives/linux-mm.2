Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6EF606A68C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ov7j+rPz
Received: by kanga.kvack.org (Postfix)
	id 54B0A6B05B1; Fri, 20 Nov 2026 19:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB846B05B2; Fri, 20 Nov 2026 19:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7926B05B3; Fri, 20 Nov 2026 19:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146126B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:54:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26D8D14027C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:54:08 +0000 (UTC)
X-FDA: 85457304576.20.9E74D78
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD97E1C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:54:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ov7j+rPz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795222446;
	b=8fk0XeUAOADfnfa7C7oM0IYSo2xS25IZLsNubt0kBdvRaEqP8okJuA8g/Axuctx2ALt4XI
	Q5HGJy5n0AEeXNxEMQ5CYE4+3x+eVT0+NDCsIHotC5Q9jXsJHXGVu79gcZjeQkwmfVaS1B
	mYY5t/AarungiSUVzvfa8gwm061DCPQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795222446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iv/Rsd+eOs02GB8EmJ7KwRHD7hgEV9Q23SfApRNMcug=;
	b=bnR3LVcBSgRmgyfRyVBIk6eejnmKvwnnespcATC9recBZpEmFVte5q0cS1sOe3C4+Z3toR
	p5Wbn0UteEdEsrZBrAwMLrj4i6ShaMe4tmrBKAofMaAYygMMI6lUu4Tr1ZbtThEbpWX2nR
	6560Pok1r3TcrXoxUs02ivJn57/1TS8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ov7j+rPz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Iv/Rsd+eOs02GB8EmJ7KwRHD7hgEV9Q23SfApRNMcug=;
	b=Ov7j+rPzKYlm4j5qoduL+9DNrt9rsQYL0rgh5fmBXUKBKEh3ykDNA3+xbNXRio9IbdSPzd9Mm
	sctJu+821PFPoAJtpfyOoi3EAurof3hgvlCzfytG9d4CIpYKf6xxNvSA3WUxjJ1/W3gND7BnA+S
	WQmcr/Tvpq9RkdyZybiWCeQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jWYbP5cYtzpT0X;
	Sat, 21 Nov 2026 08:53:05 +0800 (CST)
Received: from whupemk200018.china.huawei.com (unknown [7.152.184.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 637CA40579;
	Sat, 21 Nov 2026 08:54:00 +0800 (CST)
Received: from [10.174.179.32] (10.174.179.32) by
 whupemk200018.china.huawei.com (7.152.184.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 21 Nov 2026 08:53:58 +0800
Message-ID: <29124d54-a8b5-453f-a65d-9ca499cdab96@huawei.com>
Date: Sat, 21 Nov 2026 08:53:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>, <dingf3ng@gmail.com>
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
To: <ljs@kernel.org>, <liam@infradead.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <shakeel.butt@linux.dev>, <pfalcato@suse.de>,
	<david@kernel.org>, <jannh@google.com>, <akpm@linux-foundation.org>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk200018.china.huawei.com (7.152.184.119)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD97E1C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: hpgpazek54sm18rg7j37r1jkf17bi66q
X-HE-Tag: 1795222444-412307
X-HE-Meta: U2FsdGVkX1/FrM/DYtCwcCA6S18ffKeW7+5wb9WVlSTtY+Qw9VzdoIPIfxPHAQibuk+ZGJj5KBzbZTAv2EEQEJkgEatxwKaOI6Amz63bIhAgQGm8Qx1fPGPTw6QyV7Gc/0mUPFNEgGfThiaFROIIueczeyKbEDliNW0Bni0jZ+YyBiUG1V4Ha6TqFtpxv/akzbDl5OvQPjnPXuiMyUamLhdJTfdtpm+4s6D5btCU7XCAmE8POOQ2mz54HypjnzxMvZuT/SK+gMxdft/UrnEae3jo77PEuwY9PVZZQi+kPZQizOLwhCgPo2yOnn6trojnyHcBuMLayeJmJMBpoaqnlmmZcoyaWC04Y3sfpTx5xSwgJU2GPXtFgeufV4UzdXMdgyDTF1Po0PzRZ5JVI1GdAYdgJ3MGMNZl1MxlkgCiSoRcV2Mcdn5PFr1MkLNhvWet507GoJy8svONbzJ8xsTsjHgz3Dp6Tf45+37D/CXXFU1Bx5iLdEV32vAB5bvVNHhrecj/3QfuG/RAYupwwuya6dnNukcjbKMbTJIPUlaEyBpS8upHCeAwE8Q33qiadOl7iSKDS4YHBe5+zma5rktEZDCr1xdGaLyB9zQWAR/dzC9vHtt4JKZIzSji3P1Gn7CZTjCmT4Fo5SFP0p1h7jgG2TIGLu1SkiXUADwybkvBNNyyBY9TLa9OeupLmDc4099OVpKfb0ikQbAACytj/HzWh2VwGAAYQcZ0P9e8JlytVuDf2B0G2MR+kfTWx+LyjE+X0w1sLLRBJVo5C0RRHmxmmfMCmB9QueXl4Hm4iSLsbqmN+f+Yqgby6XtwJI5n2RwiaFp35cnMfCUroIlf/JYvKRUh2mY/5bZUTjDP+MdG2bkzlFy86qkkPMmo13QGpC8G4LYpq18fNILwkqiATxta5LHE2+achbxFNHZ9jEcUrUEhoh1I/3DXF+o81oPDKeVKMQxQL/XKgH8C6iF8UTl
 VadjG+5f
 fuza7lvPx3Qr6P9CglRWCJvT5VEFEqIVLdvvea1J5H8mEmn0qakH+GhUJaXGZjxGRTFMbXo+/Rad7B0sVVcDdk3S1P8hNdy8NfCCeGRZcMPGbIr07w6lrOrzYjWqlMegyFgjjoy0lREo1EmDA+N1S/KrRSpoNOD+BJorv0+xuv2azKDZiP2mlaJUdUK8rdmwdmsZ+Z96rR2EUT8FrueFzscLwHLz7XkMUsEGZ9SUBpW/IN3IlLo4feipJw63wDGrq7lrLryqj2J+5hhEDZJMbXrMgip2s15a50J7hYjItL5n3Jxy9fEF9B958Gb0KfvBTnVOcH96oS1OaN3tO5A4a5E5wFHAAvLzk4Sk4zESosrdYRnLSzTqSA2hwjLjSm/88fwX18TwlfgKZUTnMjUbpMzrJ8sjgF3dKrgnE7IjiMW+aQzM4WFhZsHagwp1+QuQ64A7P1RiEe6bqwzLON3QdE3m0GIr2/gzpM11yQ44HffiUIAiTggBEY0/MqKdOVEL1Oc8/pDKaGO8avpMe18IalpRvylk+ZXdpV951e2Ys8t1N4E7hVNlauHLkDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 周五 2026-11-20 18:59, Lorenzo Stoakes (ARM) wrote:
> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
> 
> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.
> 
> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.
> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/msync.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Thanks for your work;
Reviewed-by: Wupeng Ma <mawupeng1@huawei.com>

> 
> diff --git a/mm/msync.c b/mm/msync.c
> index 90b491a27a14..ced41d3c2903 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
>  		goto out;
>  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
>  		goto out;
> -	error = -ENOMEM;
> +	if (!len)
> +		return 0;
>  	len = (len + ~PAGE_MASK) & PAGE_MASK;
>  	end = start + len;
> -	if (end < start)
> -		goto out;
> -	error = 0;
> -	if (end == start)
> -		goto out;
> +	if (end <= start)
> +		return -ENOMEM;
>  	/*
>  	 * If the interval [start,end) covers some unmapped address ranges,
>  	 * just ignore them, but return -ENOMEM at the end. Besides, if the
> 
> ---
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> change-id: 20261120-msync-enomem-fix-95f830e305dd
> 
> Cheers,


