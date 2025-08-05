Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC94C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803138E0005; Tue,  5 Aug 2025 12:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DACE8E0001; Tue,  5 Aug 2025 12:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717C58E0005; Tue,  5 Aug 2025 12:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 619EB8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:06:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD5B21A016C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:06:48 +0000 (UTC)
X-FDA: 83743182096.02.4337ECA
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC061140012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:06:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YKKJDDtdxUXV0lV5aN6SeraxUcBFKLa1fTZ3jSmMfEc=;
	b=mspgBHIFA0sptZWPsqeTDyK0Aa7eVW4/YnzSSeKBYlPy0iBAgQw2KLGss8L/vVkvA4YOGl
	U0HqRJpDRrBWuXL3pX7nZdZGgsRRLP+F1O4Id0zJeF6znrwyyU5UwUs4dwwKLW4ZKZAk3l
	DL2Q5gms6eXBloCLNXPEPfnHN+Ri5ow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410007; a=rsa-sha256;
	cv=none;
	b=N2rVIqEadDBwlX4evDKAFFvFQCS/D3/6XgdSiRm7HSTktlstdqBUy46ZNnBPoQcNztYkRM
	3MNmmCnmOhENqpvB6g5+F9oYedobJP0AeO+BXxJu+ij9em5NVCufJtaIbg4/H813nPce5f
	ivD5GS1EgK884iDDRz0Dv1gU2/qvFiM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 417DE44427;
	Tue,  5 Aug 2025 16:06:42 +0000 (UTC)
Message-ID: <20c1e656-512e-4424-9d4e-176af18bb7d6@ghiti.fr>
Date: Tue, 5 Aug 2025 18:06:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] kasan/riscv: call kasan_init_generic in kasan_init
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, ryabinin.a.a@gmail.com,
 hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com,
 agordeev@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, trishalfonso@google.com, davidgow@google.com
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250805142622.560992-1-snovitoll@gmail.com>
 <20250805142622.560992-10-snovitoll@gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250805142622.560992-10-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduudehiedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhephffhuddtveegleeggeefledtudfhudelvdetudfhgeffffeigffgkeethfejudejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepudelfedrfeefrdehjedrudelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduleefrdeffedrheejrdduleelpdhhvghloheplgduledvrdduieekrddvvddruddtudgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepvddupdhrtghpthhtohepshhnohhvihhtohhllhesghhmrghilhdrtghomhdprhgtphhtthhopehrhigrsghinhhinhdrrgdrrgesghhmrghilhdrtghomhdprhgtphhtthhopehhtggrsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhphhgvrdhlvghrohihsegtshhgrhhouhhprdgvuhdprhgtphhtthhopegrnhgurhgvhihknhhvlhesghhmrghilhdrtghomhdprhgtphhtthhopegrghhorhguvggvv
 heslhhin
 hhugidrihgsmhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepiihhrghnghhqihhngheslhhoohhnghhsohhnrdgtnh
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Queue-Id: EC061140012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t5hfs945f9q7norkowt785m8m84br8t6
X-HE-Tag: 1754410006-211221
X-HE-Meta: U2FsdGVkX1+YibiNBhu2VxpWm+kKtVPsG+xvBA2WzE7wUjTC3aibNwcm+dswQE8TvjN7ML8ECpTY3X8TnfZf5kk6gogIunDY9Eisq/RHvkNRljjgY2pLUPKmcLoZZR/NwvIesCVyv0bYrmAuRtu8AOmNj+2QTzAw9eHz5ZZF89gyWy8+m5K1RhHTQWEgI8spxwM1K0RRDao9VAjctBZjkhgL4x0tAINrmsh8hBoq9BDWVcVnm4I3rP/OWKWuwuIZJhcfR6ZyajkZ6Bct0qMX/qo9uDMk3qFMWoaT6fOxuJGo83wHGztmOHJdJOH/dARj/fYnVyOMZe79iXIG7Zfw29WwDkxfwdGHaqqJ79ExRZsUKt51PDdAMy+qR00LuzmrHq9duV3xPbpmySMaFzeLtrwyt6dBnfmewWWBdKRa9X5tF/y/RVy21P1UXh3uxiIPQSL6xY+AXJMXftj6aLnmyCcsAcWL6BHxF7VZNpFWg5n1SDIL4VGyP5YJxyVDUxrm/vL9eEmiPl9oQtwovO8HAKv5b71xws5J2KIUxYNcDY0givYYJ2ESBdXJHA4Rcu9Jt5iitiecISWhiYXqWePt2YGrGzZ67jlC9rEdjhZc/yxI4RS03oPW+K6fp1rLJG5tr8h39Fn4j6lTjrggAbWRJ8nwWHlKkoSqat+2dYWueLw8LwLgBflZz1MpD5eRXN6Jkrxf9VPXeiaD/FdvvxbUu9nCZXn2yUzZwrUSwe3xejDQ49qcsjkxWn34qGZymUCTGAwa2j30ZfKvxDZU5PYim4Hcd9UGfUaBc13gXSPySW4N+f4SzM1s+f4vIu5+oJJUoIrAgMCw7/2bX+9de2xII2CL6DAMhbjbvy+H28Bmqf4eDE6Ay8e/CXIVArxUR8ZufcwkOeR4zTpeiLGHsx2LvA0PNfGs2vV43vSMJD51O50eAQ7ndT3LalrylI3YTeay6CAArZGDMpkkXbP67NW
 qWG4jYkz
 OBmOjiArFvsPS2JMv/fnxvv+G9CSajWsE6kCPWygVFfUA15A4uKKJejlOAPx9aT0hc+m6bBw/4Z9yltX3QLdF/VsEgYa6sZr2EYvPdTBaUAxTrt6TkfilLpRN2zby2xQa1gqLNHwycaVjwhj5GBu60t5OtXCFJJnNxUHnB8zrxeSc+kn0DiaOhgK5vaQjj46wrYXG4qncu4S0UBtNumM3dsHpc3ahbK9XB3kb+yN9fX7yomlayqFTjsxnoZ667awmd5pyz/Icakc0W/uDmGciD4M1AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sabyrzhan,

On 8/5/25 16:26, Sabyrzhan Tasbolatov wrote:
> Call kasan_init_generic() which handles Generic KASAN initialization
> and prints the banner. Since riscv doesn't select ARCH_DEFER_KASAN,
> kasan_enable() will be a no-op, and kasan_enabled() will return
> IS_ENABLED(CONFIG_KASAN) for optimal compile-time behavior.
>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>   arch/riscv/mm/kasan_init.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
> index 41c635d6aca..ba2709b1eec 100644
> --- a/arch/riscv/mm/kasan_init.c
> +++ b/arch/riscv/mm/kasan_init.c
> @@ -530,6 +530,7 @@ void __init kasan_init(void)
>   
>   	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
>   	init_task.kasan_depth = 0;
> +	kasan_init_generic();


This is right before actually setting the new mapping to the mmu (which 
is done below by setting a register called SATP). It does not seem to be 
a problem though, just wanted to let you know.

It boots fine with defconfig + kasan inline so:

Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex


>   
>   	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
>   	local_flush_tlb_all();

