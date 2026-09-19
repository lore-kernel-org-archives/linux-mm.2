Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4235CC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 09:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB87C6B0088; Sat, 19 Sep 2026 05:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A156B008A; Sat, 19 Sep 2026 05:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58566B008C; Sat, 19 Sep 2026 05:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC5056B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:07:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 273D21A0204
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:07:55 +0000 (UTC)
X-FDA: 85229934510.19.ABA6905
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5632C1C0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:07:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv1Pq9vx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789808873;
	b=URx+KKw4QLn/FAICHILBlM6tTkK9Yb3eivAZSJVXjoRiES5X5xtur+jsgj32y3niDL/YAy
	TsFqRAbWrciiPDY1U+CV5f7OhDK0xfSASFd/XLeaAcISF+gkKydRNzQJ0CQKTrtXnldXKQ
	qY16pZUkBc7QFXf7zq2L93LOWoESs6U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv1Pq9vx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789808873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbapgDXr+FyoTKQ50JUeVgfa7Tqe0pMogS4ct7fFvKE=;
	b=4YmBTZ2YXjipqNmM4fGO0dgfi7V4gdqSOfIbF7VAo4V20Bi2MLo5GF0z/CPXE1AmYmCPfz
	7/29y5I4/3vWUhBUfYuxhjCOC3n+jUp6cdMY4phghW8xSnjcjzH2XFzQZpfKKnNUa3t6x9
	2LPr74B47tSF3t2zMdxy8zVbFhMedYI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccff31419so12733335e9.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789808872; x=1790413672; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NbapgDXr+FyoTKQ50JUeVgfa7Tqe0pMogS4ct7fFvKE=;
        b=Uv1Pq9vxu2pwqJvZ7D45MmXFUesFrW5nyexL4JGX/WrzbXBdA3DlgEeZ1xTs5BTQAj
         mAjZ6QeQBLQawJf72jBqRN+fdzwQfUnHzYla/BVzdqaeW/vW7wdOfxtlhFxghFjJ/u2S
         ZmhkX1TBaFxQDBSQSF1vi/7fErCyQijBxNwwOhMdqOBDk24KTC7fFhAk6tXy9s1rqZ8e
         dE1AlziPOsxe3s4Tk9vJme2oYw8XDfPX9FhuVTW0BUxATMxVN7kGsaxDX2vzjY9Qe8bV
         htC4axGSEJ9yZn3NmxDTNy4gewJsmVJZKixI+hjmEmRQWzGq4jy3jr5kr3uXZzyFwXYI
         PazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789808872; x=1790413672;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NbapgDXr+FyoTKQ50JUeVgfa7Tqe0pMogS4ct7fFvKE=;
        b=cOaBleVrJBunkB67UZrHqac4vbzuDF5U3mB+Om5kj4E3Zf3C+6V88rRmVAdmgfS4Tp
         VJrxUJigJfzGH42SN4pDUAeLxlRcaYIGFqLd9yyTlMRQttwOT16+9UiI6LK6HsUyNLJe
         RTbZK9Il+NFtlzo3gFDjeekvGPm8pQtXY1Pka1TPvqCvuSTUNFe+2/b1mIrVo8V19BoP
         olxEYKOhbbhcF2X4xe7kr4p4RxsFb9f11saHjNTesbEjIJII8VQvbUUIphFcyGGt7ppE
         Dn2dt47yn70XHxMncc/sKK+fxA9YgTTzS0nVJ0Ca612ilPHaetAcXe4hKxKsYz26BS4x
         wSTw==
X-Forwarded-Encrypted: i=1; AKwUvBz6QYHPjp6OwYWp/cGiB5pGynjoIr0iqhagzAZLlwCRYuDZNRbRJzuEzHGWQJN0aa9a+TEmJATR2A==@kvack.org
X-Gm-Message-State: AFuF++m0ULA2BZm83RzmD5jDOTLsoTUpG2CQ81Y9NUTEf1ueCwGNvEon
	pPrpqXSUZoGzLTE1hGeDmBOZlxASPNQ6H3rlZ0Ls1gFVtQ5srdue6Mf2
X-Gm-Gg: AYBFou1Wq2zfaS+vv94BktBsJe2rBYraMQy5eMwU7dM425X1EtmBQ1rfI/yqCFeBLX8
	2UlXtbndDjffunKzNtSgfAtXqiZOBpdI51jBvgbBdEDc1Fk99hV387v2gk6nymxH5jD5HAP/L5t
	UMh1gHoD+PWjrc5yklPjIdM4gXrQxo2ignApE/fkNPcOXh5qYrsaSkmqVP82guUd9dbRyBDZZ0P
	7HTsrpA0eR1/YU7qXpZEyBbUuK5iWa81JJm22RpUA/BzD+KClR8K6OCR8AUMcBuu9iJZr8vup8D
	+Lf4CzSC7SHwi/MJaOzFVFZR3j2QS62BKbzWifPNk6F67ppUqFvY4sbAtEPsmk2qkHNCrzBQS9C
	SktJwmwSIZ1LnkRe5+z4eFrPVnZcKwt30TGfsXiBGdtTbSW8P/08tk4zC4gfu4VPLFQkng012Nn
	Z03YkmKunwmHmSOLDtRFxjwADVKzGxF/iz1nYwmq80C/Lf0Bzoxd1WvuykXTIdwbRqnw24dQxGN
	zkaSDNqpZnaPPFTsk2fwCDqCKVFx40vZD8HLchmYBtTG4Kt8YTVda73ba5NiiHtMSS/llMGJCKH
	KTlYjb+NsDuywORM56xFt6ah4aUkVu7nnQEHBVfgchPCIyAwou3WNNxzHTP0pXGv6B43moCHcgp
	WR3g=
X-Received: by 2002:a05:600c:a085:b0:49d:25b0:cc60 with SMTP id 5b1f17b1804b1-49fc5747f7bmr70121265e9.29.1789808871519;
        Sat, 19 Sep 2026 02:07:51 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc7cba562sm86917495e9.2.2026.09.19.02.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 02:07:50 -0700 (PDT)
Date: Sat, 19 Sep 2026 11:07:48 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v3 0/5] slab: ZERO_SIZE_PTR alignment and ERR_PTR
 hardening
Message-ID: <aq5QkQQkyaljq0R9@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
 <apqmVDiyGJWnEnp8@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apqmVDiyGJWnEnp8@nixos>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5632C1C0007
X-Stat-Signature: 8qcziuux6kzuc8385a94n96thuo3k8x1
X-HE-Tag: 1789808873-276918
X-HE-Meta: U2FsdGVkX1+ZPwJnbqxkvuyNDYkLTWVsSGXuBPKIREvojYqV4fbLTW4ke2ZWHhPJjKHp6+ZvH3Z2ffbC9c/p9k3XkEJAPM6J5PF6NQ9LHV4Ppw3WMX74q0atWROldAdk3KboqEcM4grISCNi/wCfzVWpE/EbyOpCMn2Sf5Ea1P5zmu/SdV6XYcIbWTOHPeF8PvPWxd2DdNXXI2CYrSfsPsNQpzG/b2RwYN1m0prqMPmY0hqxIm/70Y4hCfa/V40lbMtgQQaMPKV1rs31tKCbNYtKjEdhsfy4Dwpz2A673INKkEE1vZJAEaB0hwyRlDJ4VyGLLOwuQ96N8HTHHvfa45M8iq6uRllOv49GORpdTTxUvhhR8hHxwdY3UskwgCh+vLr05M4EclZR+1sXZZlP90vHVG2kiLSNzLF//K9utV1oMCBMaj2ZW641E+QuxGS3GJZ9KIf7r9Fa28BF3g2yG99EMWL/q/38T+bLb00plMpH3lEWHJYolBs6X87pS7+i7PJCk17Voz76cPOyO5s9g1nBgSBldZajluI18UeTLXNnKebYRWIpbrB1N9SubtT8OsGwqplr5tnbD0/fyHE4mGni5dlFKuPykzytXWCevlCqHXgsDZpB98D6dZY08hIj9sbNzITuqJg8uFzdSVt3dqKYtY1IPxucknQ6OPH7G3YydQqer06e+hiLhpEEyWHAjh8y++gp4Bqz5w2xShNK+BAy+G0GEJdWDdkcHXcDnH2e1UBYjTMzivTDidGgxm60s09hAKMELmqP2azGuxYx3Xto2Dd99VU25QaBGEQSRvw4GY4H8xZ6irycSKPsRoYDWjM+dkZqpfG933P4gX32RNisxYMv5GfLSv6litd0ELANLdKT8m8GkAQiaJsALAkpVM1sY3A4jixIwAdyEehjsaCTapWi7ZjUNcmJ5lJmxeR8++x1MmSM9B9RaUYn5P0v6xKscjZvNohU4N0HKZH
 NAQaL10E
 szNQ1n1l2FMhB79mLwk8ImAgME3AswrBXTPYOUi6L4sMXmjSdCQ5EDYACeLwosJQ3VUE3Hf2R3Wc1Wjw8wHK5boKomPS2XWzy9Kv5pISxch4Zd623E778dM31gXssDyPus4OoupBh4IQgCHaBhWJsnLC/aj7RxsmSxGIz3ElGAN83+c8O0AX5UBZSy85Ze07vT7jyaDlVOXmx08jmUdttyMjfk6HTjUIQYI/1r8B719AQnvaoS+IFe053o4IrCrgYfqqOpJJ6qblC1nBagVf1SiuUrSmx+ceJei/O0zAdR4uj9frSk5DdY1Gn2v3GgAUicv0VSu5KQTbLBKdiO4p8LDHdTMqEJUrboywZ04dd4FW9oTHFwLFPN97BhiXQy0yITQCy5pfwG2woFk+DfV5cDgD83xBb66SwhgdN5ezUxrmrGMf7J29F1eCmXYBw34qyozjQyEw8ZYVmcRcH8BLf7PL++l8RnEFucCnu/rEakT9JwUF/63AeBlPKaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 12:25:59PM +0100, Harry Yoo wrote:
> I don't understand why v3 of this patchset suddenly implements
> hardening for kfree() and usercopy to handle ERR_PTR().
> 
> The address range for 'zero or NULL PTR' range and ERR_PTR() do not
> overlap. The bugfixes and hardening patches are irrelevant.
> It should be a separate series?
> 
> Also usercopy.c changes go through the hardening tree, slub.c and
> slub_kunit.c changes go through the slab tree, and LKDTM has its own
> tree. Patch 3 and 5 touch files across multiple trees, which can be
> avoided.
> 

I added the ERR_PTR changes after Kees raised handling that range in the
v2 review [1]. The two topics also came up together in the 2014 [2] and
2019 [3] discussions; in the latter, Jann suggested a separate
warning-and-return check [4]. I wanted to broaden the discussion and see
whether considering both together might suggest a better approach.

I agree that the resulting implementations are independent. I'll send
v4 with the ZERO_SIZE_PTR alignment, exact-match and zero-size KUnit
patches only, and pursue the ERR_PTR work separately. I'll split that
work along the SLUB, usercopy and LKDTM boundaries you pointed out.

[1] https://lore.kernel.org/r/202608111716.0FA9DB17@keescook/
[2] https://lore.kernel.org/r/87oaumdz1f.fsf@rasmusvillemoes.dk/
[3] https://lore.kernel.org/r/20191010103151.7708-1-mayhs11saini@gmail.com/
[4] https://lore.kernel.org/r/CAG48ez05QVn6_gQ2TBrRa1a_DWQoaSSYubUsu5YMWxx-gqMijQ@mail.gmail.com/

Thanks,
Karl


