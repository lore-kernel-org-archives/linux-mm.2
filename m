Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0537C1061B1C
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB506B008C; Mon, 30 Mar 2026 15:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B8A6B0095; Mon, 30 Mar 2026 15:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A796B0096; Mon, 30 Mar 2026 15:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E65A26B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:32:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 989371B85B3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:32:46 +0000 (UTC)
X-FDA: 84603726732.12.084C43D
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id A6B961C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:32:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J3tqDbDD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774899164; a=rsa-sha256;
	cv=pass;
	b=EribrdaJdbPDAXAFKLvcmD7l6grRuF2Q9VnB26Opw9MjuzXKzfQJs3EtXsrXyMA77H5QgG
	lfGkoFHzpJxrR8Hm998iSh68I6xRpVa7qCMbIvrfj3s2nATRU1xQZ2lM2br7Rfq1pfWgCs
	oW88xc1xRBh6FH+8ufwkU2+R1AJeHxc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J3tqDbDD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774899164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiZP2WaVy3BCJtasME/QMACdFF8iIx/adm6y+fLF6Bo=;
	b=uo12BOU/dnijdkr0XTZUJXKGaXszVRCZhaP4F9QJwz6T7hzt9AdGwnkkXGe3XVkli4AHUh
	HOVFT+7/qVQOEJMVFRSv/2/ADiXIjhQh50wBHXFcp3aF0nx/ULaq4hsLxpnwg45YyChdc9
	ihRzBM3SuSNB3+iaaWB4TH5gdS7lV3A=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-66aa2204e9dso10850142a12.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774899163; cv=none;
        d=google.com; s=arc-20240605;
        b=C/nB/rbCJ7ykY371PK+GZ8UBwaqNhLSExKnWl2isZQL6e1+OIMDUxk6KFtLgtuh8Zf
         8QrxZOy0n0AGatVTDkF9rGFyYD4vGzr3U3RaqJbr/g+TIGlH144jad6NRydWlic1cOf1
         VI39jX4WpKdOoMbetNIGYo5jLDLHNA22Yr04DWUVlSE29AVQZqmiGZyzNAKLAsfbppWc
         oqo46cwGngW0CMMHbupEe8awRYV7d/SrC2/Lk7o+0NgZFTUiJwanSkHhrJkO7nPiSfsw
         WH075rWBjhkmdzD9FUJNrBbq1/1fF8HOA7Op/HfH9n9xkNOdrMAcKMBL2UOPyqpKgBvB
         NAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NiZP2WaVy3BCJtasME/QMACdFF8iIx/adm6y+fLF6Bo=;
        fh=UCECzfoyHY32jT8GuvVLpcyC7CO2tfOo/4BwUyfuHAE=;
        b=R0gdPcEi3wAo+9IKdjcVuBOvWZHwPpBpLSkFTb2WHnhSOLtkRBDyuWQISvitxwYpSY
         CIUoCCnZ0eJIIkFnk6wOHvIlLCY0rCKWYvUeM2sSV7TeD+UR9se2SHdPYWBQJps+d/Fc
         +5Wdk7P4RicrM8y3A42bwD5ML4ZCggQsYqXqkQV/CdkUllA/K5nqw0CmR/Z0/Vh6v0VH
         JQlPtHXmQsPmouWCp2gwJfUr/cFI+Q/b5MCdgmVb+ugOM76UM85jeaKlj82LiVs6aXu5
         Zt7mXL10oL+1QQZlPtEl+xMgAhLNRUAy6EyyzQXgwpx6/B9Z8D69XCr63GLutVpGlUmG
         AdWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774899163; x=1775503963; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NiZP2WaVy3BCJtasME/QMACdFF8iIx/adm6y+fLF6Bo=;
        b=J3tqDbDDio5/c0n/BDv3+yxHCwQvcJjZ3dybFUgNtvrpr5nW4+kegxkdFrpnd74MDq
         646NnCrJgNU99mbNGgytlAmdtjCEX7EXmaZD00i1s4PBDuicuqT710J7UmbfljmD2U+k
         bBe+ZLbX3VKaBW4uOIwJlVtIiDSSee/bJerFEdh23Ey9ywXbet+RIua8L5KbNSXHzTvw
         hDQ73WHoGPKEJYaz74lNikYnU8P4VulV15wWNf5Lxa6EIe94C6YiP1+TDdu9qar50+Yr
         LBPKetSt4efj/3JdOTlAJvGmzppV0bS8zbR8N77c6DjJlnA4o41asYtz/P/s9AzJPEy2
         13SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774899163; x=1775503963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiZP2WaVy3BCJtasME/QMACdFF8iIx/adm6y+fLF6Bo=;
        b=hwA/Dji92hlq/c8uXFPAcfgmX9ox3Er9QaBFt1W3dcZDLuT8PzAu3WUMYHml8aM+v8
         rPpQLuySH2KhCQmn5agnod8pmsjE/GSZM1jS1pqVhREAms3hDL9OEj/jdMqreQunVkD1
         9KgYW/OLTc24doGtFA4QOljuFLf22RgxUKfqVAr+j2PrlXVEVv+xzWnlr4GSwP2BGDpi
         ndhHsaYx1RF+DzK+cONxDjI32YiKeufT6fvD5C7g3QLP/rVcQHX90Y+LSof5zE8ZXj+S
         WjGkCnfuMTzGfjA6jGfTbQEmH73jaEXm6oeYqwsLhJbiE8mCF+z3XNthaHXmjJMYc6xH
         za4g==
X-Forwarded-Encrypted: i=1; AJvYcCUEXxYc9j7FTq177f8zdsd7hmCQNHuB7lgfzZhiULVsIZ5dxUnz7S1oWStiUbQLP4WqYDC4wZKFfQ==@kvack.org
X-Gm-Message-State: AOJu0YwEJqg2Fb0ZI65ufjZnGme8XLDvPKeCR44MscT8Ow5WtwlWVpQu
	HJdrjjXevSVMHQHCY1/6R3LfMDlnmB4tsTLcAP/sOI2bpwkocjWgYuCOyEiiHGg16JPAzeGVkdW
	frPlLIPupR/ERRbUKSSuAif4EvI5fcgA1VhzE141ZKMU2rVm1yy8Z
X-Gm-Gg: ATEYQzyAChvUt0CzJbXnYoUXgkEw3aUAHQQrQ1TaysOHVL0nCkCsVtkShsgkKKpynMq
	G+hcheakm2MmAaF1tE+7izQDMOHasdsPzAP0QtkUpojdB7RsRmhD9jt3mCU9/FVjjOi0qVEnsYF
	RWR7ixGx684ovSNYXyt0wvUi2yxn0iOrEl+cRmKOSLH9mjSJDj19ya8szn/wf/+bVpI8s9kFfg9
	PcJmepfDkMpPrIZ/4VKVu5RM029Bg5AG6FmGQ9GZXGWJ4Gm81Be9vSoRK65T+f4ilio8K86WWvE
	dX4vcdGkb4YIBlN6otyYEVKBJqfyjy1Yj6ZYWQ==
X-Received: by 2002:a05:6402:44c8:b0:66c:235a:c3ea with SMTP id
 4fb4d7f45d1cf-66c3371dea0mr314985a12.5.1774899162749; Mon, 30 Mar 2026
 12:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-4-pasha.tatashin@soleen.com> <acqnQ64U8Cxst-ce@google.com>
In-Reply-To: <acqnQ64U8Cxst-ce@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 30 Mar 2026 15:32:05 -0400
X-Gm-Features: AQROBzAxVsQpca_B-s_NGbRebxXDIv48wSsMEMtKeJdaMcDdS4ixD-aE9zr90Ig
Message-ID: <CA+CK2bC5B0NNi=C=E1EryURhoR5_EZVgU45t1cfzFeiVpcoNQw@mail.gmail.com>
Subject: Re: [PATCH v3 03/10] liveupdate: Protect file handler list with rwsem
To: Samiullah Khawaja <skhawaja@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A6B961C0003
X-Stat-Signature: gwnmj7rghc9qs1uiexk6r1f3g5fj3wic
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774899164-685972
X-HE-Meta: U2FsdGVkX1+5/KDl0KGwXdylg37nTldHWzXP3qnbMRhiv1HTqC1p4mV0R5ts/MIPUrxsnzoNiQU8TvOEZ/SEROUjR3srREtRbwt24wZJZdmAoV/h+Mnt5RArKL2/peyHVdhvDgFsJlZ/asRBI06q8itofz62ue7cA93cW55MYr4y4TygDclTaamED6iOFZN0rE0j9SIeShTxjQu6a4MrQuc8DA9Tn364ZMaYN5jsyudK0qL4+CBZFtpvJ8bT88gwsSTIcFr0CcWRSgNCdBUXkzPMdqUx+A3IIw5iBMNvmu0izO5/fnt133UvJ2sxUWrLv4C6u+OiAX5UbHOBE/NZ/fhNN7qCqDzY11LKKfPwBIEE2XErGZmknp3oy5AqsIJ+jYpeafD7PP/GBeAvq5XCkx87TGAtlV9kVCYhPa9PwCh5WSZdWsm58qME+2/JtJklHxz3WyZfdO9s9Zc8RRZnb6yBf/NH5BwoZrWEAfCusfljUBdGhB0qtno7/0HDCm/VmHFkNS/lweGYfwwMYo0DFEFAkwSLerZ4SE/b8t2yXKUzqIqNqMGanECdppwG7dH/y5WX6Eih9dlvtldU5veGPv5WQWW3LOTPxv6pp0+pO7pejccLnbJzqfj0tI2UC05z0R+rUaZxMBheFP/GJod9t4d763//A3OE4TicBS1mPvd1PvFf4KC/WgCZnR3jQ93H5k6BnkIjihb2gkGgMRKy0QnEDrwFcJ6wd3hVoN4bbz7heJM2C1M1lnmuDTvRrrnKYxK/MBBwWNJxHwcZxPgDtK45KJF4QMF63+vgsL2Mx15eHUIsx5m78u2GpnGMT7dXcDQpb5Gvu1AEEkHFVz+bsZzmtbgWrENcD8cr7sC44Y8wleWg68lFpV3Bmldmk7pvWAHhTBbzTlYeOijpUVhJdBLmW786vgmEfN323ncTf+twESnPIi/qSoqyV8q+2uHv4P7seI4SRiv7OMbhGHj
 JGTIEWpE
 MUPUW5UOHe/j+SHDQ0k3Rldy+CsXDNQJTPk2rkNQmZYDVJEhqJv17NCYeg8S+zae4V57osP8l2XxEx2ckPVJtDsPFxToIJvE0IlvEVgp4hiLfFzVr5Djcv71vBYLxM2MvgVD5VDjEz2gXAalXbwCYMkSd/joKCOWShdvvGEaJA5hmcrxfbqEP3Xud1xKMHmzE3DkXcE8YyQ38CogFnwsc7Lid+oy9UelzcOljD62IwMIyu/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >Because liveupdate file handlers will no longer hold a module reference
> >when registered, we must ensure that the access to the handler list is
> >protected against concurrent module unloading.
>
> Nit: Here we make an assumption that the file (and flb) handler
> lifecycle is bound with the module lifecycle. It is a fair assumption,
> but maybe this can be documented somewhere?

That is true, we can certainly add this to Doc. comment. This could be
done as a follow-up change if needed.

> >+      up_read(&luo_register_rwlock);
>
> We took the read lock here when running can_preserve, but then we use
> the fh without taking the lock later before calling file_preserve. This
> is safe since the module reference is taken and fh will not go away
> (based on the assumption I mentioned above). Maybe add a comment here
> that documents this assumption.

Sure, if I respin this series, I will add a comment; otherwise, it
will be a follow-up change along with updating the documentation
comment as you suggested above.

Thanks,
Pasha

