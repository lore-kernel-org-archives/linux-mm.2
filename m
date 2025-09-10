Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D57CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 21:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852048E0003; Wed, 10 Sep 2025 17:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8295F8E0001; Wed, 10 Sep 2025 17:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7185A8E0003; Wed, 10 Sep 2025 17:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC2C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:56:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F2651602F2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:56:17 +0000 (UTC)
X-FDA: 83874699594.15.40B2B3C
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C30318000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:56:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JMG9sJEC;
	spf=pass (imf24.hostedemail.com: domain of rene.herman@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=rene.herman@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757541375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9d1QV8DriomeYuygow3J7NXcF+FjsYxyafVX+X7WJo=;
	b=kVLZflqMB2JrwLbtRzOF2BznjYLi+HdIRAt6M/QhlzAnvWT7abIzIwniKcdg9mrsGr3nhZ
	yrjRbkzBcBgtZ8jfmoLqNX/l4Efh9fZypWFGNt45l8rgOzXHgeY3+mVUrEz0pF9kEwkDEZ
	fxcOXneHiI6keuX0L4rTuAAhPxnYWr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757541375; a=rsa-sha256;
	cv=none;
	b=XFoKtmSD4aMds3F4LIW+D7DYj++KaFA7zL3TmTKFLtE5IazljM4AViv12yOFFnOA6hk12E
	2Y9aHcSsS5ElPSawMLmXKV6g3XyfapiEUuY9jh5M0s3tv8CzRydYCQXqHoYTOAdEcz3h9O
	eLrpkAhIkV21pVphxdWUvj247HNi4uI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JMG9sJEC;
	spf=pass (imf24.hostedemail.com: domain of rene.herman@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=rene.herman@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61cb4374d2fso45350a12.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757541373; x=1758146173; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9d1QV8DriomeYuygow3J7NXcF+FjsYxyafVX+X7WJo=;
        b=JMG9sJECbcpKgZAn+/w1WM7Tkmq+xgwlthmpL3udJrwSlKsLEJljgbTcacs4GDwZK/
         9fEnUiwH3gailu+JZAf8hecsq6WtoekvC6Huk4tSbCnbaLkvLyJ3J9iahMPLe4HvKJnF
         BUF4pNPO5IFydrgruvqFqOIIp154JCP4uMlwr2vBhY5jEFYvGctIOW2I+qwIols5vrV9
         UdObn7VWwsuu2mBcOapNV4Hl+btHLF1Vx4/vGrFUtmsj7IkSO+g8h6VGrWEjoLSH5yMw
         tz9LDdeyepKBhuN21MWPM2Xl7VWkYoLiAL9TeEZxkg9Ur1wBQ98CyQRBZq1KUbJJ4e6d
         VjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757541373; x=1758146173;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9d1QV8DriomeYuygow3J7NXcF+FjsYxyafVX+X7WJo=;
        b=rtzpR9TCP/ukt2p3DK5/S0/3WESXTvL5JJRTA5tZsGQbLN0QLtGAwUWKBa8UOZ1usB
         HVvTTDhz1qyBCE2ovZ4MPHsgNyYM7cYbf/oYc1+WRvsyPpk2t7NRfGx1BDLpzxaXS7Dr
         /DCiMc2090eaMf/LTbAacOidzAL96NUG/zTyNc8P2hh8N0OGB8JaFN1JcsGj/RTY+Khn
         fXDb6tm4PrbkNv5VZm2ehrM0nKlXMJnI2XgFSodkjPR2aspX4KnI++eNDbe0IhTxbKBM
         Xl0HjX/0FLcwuDlkgaAf2g6GyyqJg8Mcu4T94gSwIO2/0LM3B0b57qlkBJThPFQUL4aD
         Yf+g==
X-Forwarded-Encrypted: i=1; AJvYcCXAxbTtPElg7VojmxQ+f7NDwYGmP5xPN5jFiGSNHcJW9GA8hUONsLXrwK/Wll7B+BKhZ/FFKqSpvA==@kvack.org
X-Gm-Message-State: AOJu0YzD3A1KChds463v7DryYasRoOL5bCqVaCV76+p3L1YTjzmMeW9p
	QuVrg0lvMYPj/VeucLr/GL6DVIyM2fnnswxJiJKxfkvlXQn5F3HKV85h
X-Gm-Gg: ASbGncuXQ9fRKVI6kvH+RsGAUNeYKF3j3B9jDmKeLg6gB8sixtBeSwi05sUVXNUoFDP
	vphk9HmlPmCm8oZ2pA/dgpgDFk5bmI5wezq253xO2ZnX6yCenIh3JwMM3Mq2gbcw4CyeKemkt8B
	ePYTxGxj0VScWJoXtrJHoCBPBTzQxRv3M7kSlZv6AfR73QtOy6GLejnardDWxMFLyz3gELLxUGm
	pXkwGrKjztnwusPmx4bz9kolc2OFK3mpho+YBSjMNLbgU+7gR1CySGaqNd1c+eKxOtUj2diYsWb
	nVxt3hhUoJw7qpm0Xf2kRJj4W4EQ7e0VX8BAsJSKaYhdp5me8BpOyOtrt8gABMW25YSkjbDXCwk
	Bo8bvnQtY6RoNX7QYcuGJGic/5bOomyHHS4Rnl29T/SxPbyzO3YoQvFq0E2HScSjE9fVLSqrxBP
	bfghi6y78=
X-Google-Smtp-Source: AGHT+IGBsR+U1n4WFqO8g+vB4ERFu4ybrDNCTovC+1KY6W1/R7uSZEcXa89aKrlY6FwBWGiHJP9Ndw==
X-Received: by 2002:a05:6402:50d2:b0:629:c417:ee5c with SMTP id 4fb4d7f45d1cf-629c417f146mr10662130a12.32.1757541373118;
        Wed, 10 Sep 2025 14:56:13 -0700 (PDT)
Received: from [192.168.0.51] (217-62-96-139.cable.dynamic.v4.ziggo.nl. [217.62.96.139])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ebfe0ac03sm69476a12.16.2025.09.10.14.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 14:56:12 -0700 (PDT)
Message-ID: <1206e86e-488c-4c58-9e67-2313a678a5a0@gmail.com>
Date: Wed, 10 Sep 2025 23:56:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: richard@nod.at
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 alexander.sverdlin@gmail.com, andreas@gaisler.com, ankur.a.arora@oracle.com,
 arnd@arndb.de, chester.a.unal@arinc9.com, christophe.leroy@csgroup.eu,
 dave@sr71.net, david@redhat.com, geert+renesas@glider.be, heiko@sntech.de,
 imx@lists.linux.dev, ira.weiny@intel.com, ksummit@lists.linux.dev,
 l.stach@pengutronix.de, linus.walleij@linaro.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, lorenzo.stoakes@oracle.com, nm@ti.com,
 rppt@kernel.org, sergio.paracuellos@gmail.com, surenb@google.com,
 vbabka@suse.cz, willy@infradead.org
References: <640041197.22387.1757536385810.JavaMail.zimbra@nod.at>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Language: en-US
From: =?UTF-8?Q?Ren=C3=A9_Herman?= <rene.herman@gmail.com>
In-Reply-To: <640041197.22387.1757536385810.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C30318000F
X-Stat-Signature: czg9usw4ao6wjih6mo763iwx84gp4z3d
X-Rspam-User: 
X-HE-Tag: 1757541374-123527
X-HE-Meta: U2FsdGVkX1/9DiIu8VIH4p2AJ5ApLaWhfc3GiUlDbpEdXt0n48CjGLe0To03xwDVtjfY1C2kqVeaQUAVPguZLf3KbXa0WX9Q8liP7wf0NsxuU16dRbiUa0Yrl8j053ZYWeGNUODyQNZiztXzjQjPHZzrp2HVsZ1tIbzBSgZqYpl1qAtDc0zz+Som7dIrKJcQS53IBksVjc6cm7KkxyhuKJmFuMvpn8THAAbI4fwGHsWSNEDUY9m+j3iMGo7D1SfF2fpPpshPmRlkh6tw6uK1oS1SHRC0EYN0+X7TVaokdBhmjIrw6S24fRPxihx+Nthc1ebw3yQMStQcEHZZNAH7GjmDnb77EQbA3e/Kei7dT1MDAZqQMCeRZSWcmZosl6biepitF0wP945OCBvsdvqeIRdYV+UXbf0bxEIeq7FsMR0tpCmlLf++fLs+OY9q6+7+CUTUF8PeAgpXIkTUodFUjE+atPzBaYvbC1VEKALSOJZa/cGe+MKGlUuC/ePfj1t6mc/0oyeyhJ4HVspaqb34AAjzNEHnXgS2YKaEmwQqtW9Y1Bjdccl2j8uuGJQxFhT7pqg/MD2MMfC8da21mhDBstzKEy5RitsTzmULPOadznWLWcOfLVmozMxhw2+NyVd34TyPeN2Ngd9u1JU3oiORW5fY99EXALXQc54KVCI2LsGC9KjxuXTVHg6TJp4Jv/kfR2splWUmkvDfTtRnOUk0nZNh+h3rYKzamhuXSJOQn2e4MICeCAmSZFyUqLkmU3CRvkhX8Ov6/dsozaRmM0kD5lwdtIRmnZNr1E0VW0899tzD0F0Vz90vAiU4VXKYpB+tujT+HKHt8ilVBS0mKCIYuSC41dNetgYhEvJX1FKLRU6DmBZfS7oYaMgUykczKm5+Y97A1V0lNqFGwyWmwORj65Pj9QpaH+GGMUh/kJMIM5DJ7gaRzoCRl1g4OtgUOdtcPmf6lKTqCG9Bph4U2Sn
 UiUHu8UX
 i8gFNBxlfwL2G613GtpycgMcVk/KmxXrGL2AckCLhV2cSW//4z/Q3MYUWzGI8asirZ1//sGjwHdoc5WvnI2j9OcRYI5sHcIoq6qYbth00xfYYvPWB9/NrsRa4N0KxoNmOd8mlHxhWWXWJKPXcioNAVFPssVmv2uU6mMaIAJyY2aM48ADH9G79leCSwJjWek3LXRx2c/bve4ViepEwT4LzbrB7N8q5cdRIDliT1SQnmY0ihBcggtlnpXliA4y9ZGHtC7u1ecQeWAA5kW8BveZCEJsli3JVmVBE6UatC9Jr/w6ug/JaL+6010CbqSfq6uFWfe+bEdBM9NW3NzlpKTXccEL4HftuJlDIM0BcjV57DGVsNNe94iEBKWNWG9i8N+vbEVtVixWmvRDuVb6s33Eu8CX8Fvcvgv+9085ewjPOC4rU2rBsBtMFNr52QAlFvcCBrvrPTYJkGlqAZ91cLf+a7os7RX+lAlrlNNjXC5oTCNrsvOPDjHrfm1q+ypabafq+rzbr4ks1Q7n5E9sziOHQIa5v2J7NCyLJU70vfEN9NNTaKrHg6exiIrmbQq1Fm3YLTe9d0/6CWsSg0tq3fw8x8UJBrxvAaphDKzoVhmcw8BnZLgN0eWESEkaNuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> In the past I saw that programs such as the Java Runtime (JRE) ran
> into address space limitations due to a 2G/2G split on embedded
> systems. Reverting to a 3G/1G split fixed the problems.
Believe you guys are talking specifically ARM so FWIW, but I remember 
for x86 that at least initially Wine and things such as VMware were 
affected by the more creative PAGE_OFFSET choices.

Both will have been as a matter of plain bugs and are supposedly long 
fixed (and I in fact believe I recall such fixing for VMware). Never had 
or as far as I recall heard of other issues back then.

Rene.

