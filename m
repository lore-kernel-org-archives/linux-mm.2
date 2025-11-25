Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B47D0E6CD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 12:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517D16B000C; Tue, 25 Nov 2025 07:09:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8C26B0028; Tue, 25 Nov 2025 07:09:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DECD6B002A; Tue, 25 Nov 2025 07:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF086B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:09:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BF4E160830
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:09:01 +0000 (UTC)
X-FDA: 84149008482.17.3731F25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9BEA38001B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:08:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D170vsed;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764072539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELdoLOb/tIBx6c6xl5kUSgwbjhOhW5k7zrLZGG6tA4M=;
	b=pFxrgeLTPZJclghMrClLa7N2oPxEp9ZaS74P+RjKPuWWpakul1WxljOY65eA34H/kgVa1S
	4wv1o/fAWEivAXzn6jdK4XKT+MI4aT1oKgu5SqbEM+foYFXTiKTTZ3vduCwL1Bza5vKwck
	R02nCrrb9cLZ2FUCLdWyU17uiggSIUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764072539; a=rsa-sha256;
	cv=none;
	b=xd5W8Hb/IScFflNlU5m/CjbkRx4nxA+29NdWKo+sIVhLkZdAVLaZLjKqq598W0oaxkJE08
	k3OvE1I/b/15OqqDOzqn9oQ/lwx/3WaGPPwvhvFhPqLYQ/3vW2RRCv6bweaW3LTaXHybcV
	fcVpxbpD2cQG1lZjpkuIKTwr3ncnZCg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D170vsed;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B69AE6019D;
	Tue, 25 Nov 2025 12:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF23C4CEF1;
	Tue, 25 Nov 2025 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764072538;
	bh=EZEFgzwKtEIgXMiMD00SocZBXA5FusLtrAHuJeoOxAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D170vsediSym302YA7i6jtCyqbam0J3ZnMX8COM/dyuLyoVSXcxbpIvO3/iP+yJ4y
	 8acujUW2vueKrIEa69G3CxyE6JDC4awoJmKO2DITgEQ4qmDwJmXn2ExK0C8oLJEh0G
	 tq/amk7sIpOWlCGolOD39TL1bVSEe9AX5+qEFpt+LKHsql7MP03Sk6Toqs29czU0bc
	 MVMGidXne71SKxMuScY3M26FWK/4fO+l4CWjREe8Xu53vaP+rHHnRNWVt2Kg3WLJad
	 8bVcGMOCRLiW21+6zCxQN8hB7XJViOJL6wKMmI6QLqlcUDDAsl7m2q0P7bwU6BtGt6
	 u5KfUJS7i0Emw==
Date: Tue, 25 Nov 2025 14:08:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with
 __counted_by_ptr
Message-ID: <aSWcTjgiUKjKINw8@kernel.org>
References: <20251121193957.1655580-1-morbo@google.com>
 <20251121193957.1655580-3-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121193957.1655580-3-morbo@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BEA38001B
X-Stat-Signature: fsjrry4ff9kzbwp69uh8jydeqzasm3u3
X-HE-Tag: 1764072539-428041
X-HE-Meta: U2FsdGVkX180Ertom28vaA6TjzJtyIRpQdRsIC3abivF+YJYtCE+CVveCms53HKSNunQpLI33Y9TE5APTOl2y75TS1t17YnUH8XfoEDBla4BWlkPET51RWXbkJKQ59YaGvfd3LpscVUjsuFLv7gJSt4Octvevh5Sgq8eNSkVIvnl5RlcdBqfB6BbSh9ZFG07YcwWitSAV/v1xBV9+js8ZLQ/jUASsD7SlsB6O9VgF7tEnf2DbB9KwoSjsczRPP05rQQxmLaaFNwsdF/TpBoqX6RLXuKoiatWYZyVHaYV4JnDkohg/8Viq04N0PfPn1UkY1iAA7+BlMwTVDDgMd/2UKxq4WVSMrfKswd/mXgXdlc97eb9H0SSG6Ls0Tg0yR2bjYuIDJRQWboO0PsmlGqjT4qhTKNLNeVaM3zC5gMXoFjMp9nSbyB3Q2vjc3DGEu1Y2JyXr4EJjbEM8LZMgtyHmI8DejHOtUTvsTPILNkxVcjLrkf9awKaFvIUdFkBwqYaRT3IfO9RguLCUrAzZTv/p9lATQvCeqM2o4EHMe0DH0f6AdMXEdx8rQ6d1r90FkqQDLxIqGZQAeo85Ol0Yldv0kpt0p4fwaoDglrCVYZWwD1oRrbi9pvWJp+Lp9eqiS/imKMQgK2PdkYRO1e8nRY2UtaSikSz65DB3T/XMn+k5h3TM0XcxqnpxlBpI3NmIT9fTcJgxiFPg4vf25xQuGpmfew+4oqYNw6DFrosUDao5vr5zDxb56oqR4wJBw9POk6jg/zA1Rrk8SQlrMMLNIxmC3ryjg9fNUCJZ7Uwwv/F69039+nwHFLP0JbJLhjnaq946qwFeEThfc+X9PYM2gf9Nen4uJPuTSAxCYjS8YmZKDTuCLB/7PQlsnwR13h8ID34UTrNtKFr28Mv17eR1zzl5/4pakep9IyjQmvDgttTfm4KWOks1ngTjO4ftv/giP0ck8psm6/jAyxinoFBrWR
 PofTeK5T
 ex1hWfn2VK6Z1hNJjkHB4iI2vtyRydjXgrirS2dpywAKV8SXb7fX5viti1P6ia2wIWH5gWV82PeVK62CDGC5374UU7dYBOWRvCrQNvaVYKVngx68D8+FzWPoGL35W8b/weOUbraoLsCBYKhLHU5POKdbayA0UmlWWKiBG/gu6Kon8dkbiSrYC/IyEaLcXqReg8PgBetEHwMQSupZwfCyMibSAFX0T+F8ssG0mcgMU3cdEKkypRBp8/uXG9H9vDyu80x32hMn3cRyLWkAiRTXKNwapan0+rrZOm8bB41e378tiqpaNljv20bidR2YnHfZWN+/1L7yYXuIgPetMPlQj5rn2t6Za6zjeEvQxI1OVSdrZdYRcQNppEzY2MfRrGY8/AM+QkANCqRsvrsISPg8T334gEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
> memblock_type'. The 'regions' field is an array of 'struct
> memblock_region' and its size is tracked by the 'max' field, which
> represents the total number of allocated regions.
> 
> This annotation allows the Kernel Address Sanitizer (KASAN) to detect
> out-of-bounds accesses to the 'regions' array.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  include/linux/memblock.h | 2 +-

Please also update tools/testing/memblock

>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 221118b5a16e..ba7f7c999a45 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -91,7 +91,7 @@ struct memblock_type {
>  	unsigned long cnt;
>  	unsigned long max;
>  	phys_addr_t total_size;
> -	struct memblock_region *regions;
> +	struct memblock_region *regions __counted_by_ptr(max);
>  	char *name;
>  };
>  
> -- 
> 2.52.0.rc2.455.g230fcf2819-goog
> 

-- 
Sincerely yours,
Mike.

