Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175FFC982D6
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED7C6B008C; Fri, 18 Sep 2026 06:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E5F6B0092; Fri, 18 Sep 2026 06:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CD46B0093; Fri, 18 Sep 2026 06:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFD5C6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:53:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C6A8A0630
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:53:48 +0000 (UTC)
X-FDA: 85226572536.03.912F30B
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9994D1A0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:53:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="M5//GEIN";
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789728826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAR8zhCOEVqWXPt6vBsjOMeeQmFuBz9UsZFbgyML5lo=;
	b=L06tqG8HFhw0tLqNotpILyyqvMbLrMRGCFSfd993Nw+HDDTNnc6tVuDF6ELZ0wsL3iu76t
	xQpiLPjYjXuiXFvqou3Xkx6tO6jvgygea0IaR1Ch9vAHMHVmBl2RvdFDQvArrah8jn89wr
	3Pbqa+/EQ1rjtX15wqxsWl6zeD5IvAw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789728826;
	b=z99IYdvbZpYQuV/LCNwNJJTM/KaipfDUlECVRXg0sBD3xqxo4tTjciZyMUf2gErGvQ4Udy
	6MWSn7yx17Nq65pJwoH9DN6WpTij/b6biSDK3Uaz15Q+RaCrcj9KcCLhnj2PmNHvJX42cl
	ZGyb+LmRjSYvm+LxV0Xmc/Ca3u3KERY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="M5//GEIN";
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2caced6038eso4986715ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789728825; x=1790333625; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TAR8zhCOEVqWXPt6vBsjOMeeQmFuBz9UsZFbgyML5lo=;
        b=M5//GEINfX5bYzCUc5feQneCrAsoMZbvegR1ybYJGTADbN8dXbaQXmKtGRIwS/TDGr
         ugLPlrTQglzRw5/XW8P6NrnkZ+hjq9dAijSQE3dwl4ncA2W/eAhdiTGmYT5MoEsrT9fA
         N6Ax5RjmlniGPRi+FucKpQEbwWqp6aOsRRt5VDYseNV3SoDBON8wjvAlLk93oSZNENgl
         s6pciU6tYwxdzcEz6nfPjgEDUjjDFIEzTgGyV+1AP1WEQBgpzmGA13mE465aD0fDbv56
         KLizvSlxgPcSgu2cmpOhotC7FBwc9eG1LU4BiV5naG06aH+bDd2fLk8iKXObjlp4ETJx
         4TyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789728825; x=1790333625;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TAR8zhCOEVqWXPt6vBsjOMeeQmFuBz9UsZFbgyML5lo=;
        b=ybntMQkCIoqwO8h5RqQ0wI8E+zRsOz0xZ/GNFqsyoJXCatDkHCxtjl1ly03EJJOpHY
         TIAh7bcLvhJfiA+r7FafLRCdxN2sDufVjPHBl4F2Gwi4BFxzMI++8g+hrqFLYX/LrkxU
         Utg3BJgKvHdkNH3tjLaZvtIqrteotE66wwP32aGYpU8OhvhH9k7NeKbfYOe17WJ6sF6H
         syKU8p9N7eNo3iu/8+EmckGZkcVDNTRBr02JKJ8ieGOfwimThPuW1Me5uTKUyuCQNUxt
         igCDxLdrIythfpqd1p67tV37XXheCECpzSnHAD+UqkhCRbw66T5WRF6OUVcOBRnmu89j
         kl+g==
X-Forwarded-Encrypted: i=1; AKwUvByTDrYCZZlPj+MwSI7z4BwBrlbSiKwB2CK16hfjj3+fi8IAA+aaCPS3drYqqM0cd+WsfPEY75sjog==@kvack.org
X-Gm-Message-State: AFuF++mTUubl0zLgsQVvPgs90yFYiWd0mbw//ONxFKe3F7py/5JwUDJK
	b3WaCESRcf0bjjdC037xsnVL+kuwv8YQ2monrIEG2HNW7PFiOvE+jvdm
X-Gm-Gg: AYBFou1+FWVTfx7dhrb2MweMBvmnLqHOn5Rfl1oASX9QbQ+lPuD+2HbcgbUo+F+1P0w
	Iu2oIy4EvVklv9vJoiF4UqyRKvz0ds4aS/YM1N7f2PRUlp6rb7bn0yeS9+V811c+KO58d1CWB6d
	/KpCVg6VoXRuqjJaOp/+N+XWfvJEBCiyLKckBBLWT+Kt8qkTq0h+yPDS9kPkLK290K0pVzA8112
	Hr7XtyrrbWNTnjGcu7r9uuPo9s4TEfn5i0wVBomm0dRkzPKzMP8U2xQ7E9VDq3260oP9BFcuFOU
	9PDyESZVpKiJG2fQ5YpS8sdrPgy6hOW0ITdvE5P3674NScsnLuZcJyvBV1dEdoq4jBLRejuTfHK
	cIXNYGGGHuTtgyGR3yIW/VpNjnCov42QwLBwFj7790zNyBaBHds/MxAljkzQ7zM7yTBSSeGnbMe
	P7/RTdudmJjhccgRS0NIRmxCUlvOpEbH91EDU8+Wm/Jaq3EaTfqbJq4SzrfOVtfn0chVwovhiH1
	ZzVow==
X-Received: by 2002:a17:902:cecc:b0:2d8:d4d2:d139 with SMTP id d9443c01a7336-2dd9ca3f088mr93269015ad.21.1789728825328;
        Fri, 18 Sep 2026 03:53:45 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb7525b2asm5835555ad.19.2026.09.18.03.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 03:53:44 -0700 (PDT)
Message-ID: <1a47d5de-fb68-4c10-a199-f0d274689cdc@gmail.com>
Date: Fri, 18 Sep 2026 18:53:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
To: Baoquan He <baoquan.he@linux.dev>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
 m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
 alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <aqzznOgILX2pZg7b@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <aqzznOgILX2pZg7b@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fogg85qsa9nmzqen896ndp8bwdernxdu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9994D1A0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789728826-851189
X-HE-Meta: U2FsdGVkX1//zZqSJUuL4D2FQsmBOtzPLSKZ/uer0tuze/EQdKdh4rPVF+Ulvv/406AjHTE2RzB6ZS8ociOUDS80b2fU9YyPGf7BAIAiroj+m6UDb5pVQ2plX2dkODlbY3e3uGSPmJYcQeXiz8SPn6NeYvHurT2ZePaUJBm2dc6BKrQD4xo7jbyI7HMTukhvety60bnGaA3vJQ7z7Na14q6R8CEQMWl3CkUvS+RWhAdtqc45eJb5Y5tjp3k2uh5oe13P3Khq+RTOM4LP9bcah5HUZxXd/Ux431KRz6TI0TpbuFkyVLdBl4gYBT7tIlO06+mG/N0T/kYt0FkUOaU5jn5WphguqNo5oQN89WWJHm0UdoB2fNAq7q5Di7WFB0MX1/EYLUsORB4wnBt70Xcmns2rj7p4ZyubA4pPA80BSvcYtMZvJHSAt+rQJcwNy/Ae9hXYMP/bT4jtbvg9vqXpDPnddCr3lWC6YRMVQwkZsP0Jtld3JdbxwhrxkARtmoVX6YjIgphjcIglroDzPpVwdrPga4anBg01RkAfiobe5kBFZvKoP6qJMk2/xpJUKQ2h7vYF1EQYV+u4neILabVHoIKGE4QCaUjlGHLeMnJWCvAdIm+f1i3o1TrAzA4g0zVLCUWuaubuFPLFosT6fkCjOApPnvlkZrKvVMYqNh31ZC2SmvkGiD72lIerKKvU5EKw1kMv6pejBoTN4OxUor3Pj23izLboJjnlJ6yv1khOWMymxOay8zLr6lo/OAM6dcgybwBxRKa26VQqcu831qe+sSS5I8AFgcJPKFAwuF8iqjFD1DIUW6wGJVCBEFwjb/yYTC0aCAKtb9mj1rv4GBzdJ0IJXhM+gzG5mMoB+djhZeyt1ZkYy85WTX6U61CWIlvS5qe1LvIkROmT9IpuMfTlV6bP39tunz7DYlfqjajxNRQgw8jrT4H/m503QxByQKMTnmk0+3KRTivAyed3qgx
 Bx2z5eHl
 RpkYgPTf0nhxcFdt39TpMrZjK0jzUzqGBlFYfhIdHrhQ6vRyk29M2Gxez+4Bh/74nJwYH6NL2lsa7JVia6gJtYaOgPCRozMg9NH+X94rUhfGbJrGw2B+uJtgjWzXpgtYEMQqOvXjhDNSwKCHfuhK9l/42PHN4SVVB4SD1CWEY/IpTmf6SCpyTJqVkB9kullDXQAxcuI1QxUrAmD94qKZZVvw2haJ6S+dU270QK5s6TkL/lpq5A687sbFghqEW96J3zi5x9lrRkwgMevy3pGkxrOk81E//G2uxcg2CtIALyQtXTZ00PIyc3rJEYyY85znF6Sdvqz09wm/UcqeajS8bzTLHAmSSZ0jkyByfNZT4AFuPQ1TVPzEL+TvRwQrihMlNbBAPw0bkhGCZzc+MhVDbs2j+1c3liv6T7LwZxI9uXq784zkO72yPiHVzYzIS5heLZ6jkS5T6QyczhyOTOgiUYGL5EV+Ek/Vb/x4EWuJ9j869GrQg2cGpQLVFnl1ZH3YpTOKUSg9idwc6zXWmfohWKNhPeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 16:17, Baoquan He wrote:
> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
> ...snip... 
>> ACPI systems already filter reserved memory out of the vmcore through
>> their existing path; only DT-based systems currently fail to filter these
>> regions, which is what this series addresses. The flag lives in memblock
>> itself rather than in a DT-only structure, so the mechanism is generic and
>                                                                  ~~~
> The patchset itself looks goot to me, while I am concerned if it's
> really generic. I raised that in sub-thread talking with Wandun. Imagine
> I tried to exclude many driver regions and split memblock regions into
> hundreds, cma could yell out: cma_declare_contiguous_multi()?

Are you concerned that setting the MEMBLOCK_NODUMP flag could split a memblock
region into many smaller regions, which might then prevent
cma_declare_contiguous_multi() from satisfying a multi-range allocation?
If so, IICU I don’t think that applies here.

MEMBLOCK_NODUMP is currently only set on memory that has already been reserved.
These regions are excluded when iterating over free memory, so marking them NODUMP
does not increase the number of free regions seen by CMA.


Before marking NODUMP:

  memblock.memory:    [ free ] [ reserved ] [ free ]
  memblock.reserved:           [ reserved ]

Now, for memblock.memory, it is one region that contains free and reserved memory.


After marking the reserved region NODUMP:

  memblock.memory:    [ free ] [  NODUMP  ] [ free ]
  memblock.reserved:           [ reserved ]

for memblock.memory, it splits into 3 regions, 2 free regions, 1 nodump region.

Although the memblock.memory array may be split internally, it does not create additional
free ranges for cma_declare_contiguous_multi() to process.


> 
> IMHO, withdrawing the claim can fix the nit concern. If I am wrong,
> please help point it out to let me learn more.

I will revise this description to avoid any misunderstanding.

Best regards,
Wandun


> 
> Thanks
> Baoquan
> 
>> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
>>
>> Since the reserved memory regions are filtered out, the vmcore is
>> smaller in size and faster to produce. 
>>
> ...snip...


