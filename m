Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DCFD4415B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 10:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA3A6B0005; Fri, 12 Dec 2025 05:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B4E6B0006; Fri, 12 Dec 2025 05:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB08E6B0007; Fri, 12 Dec 2025 05:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAF976B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:12:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5765813B1F3
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:12:39 +0000 (UTC)
X-FDA: 84210404838.22.AFA2F59
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81839A000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:12:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSTVJiV8;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765534357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyiWj+teLSvOcemqfQ8kWGe8XZlNZ+qzMwX7g7wGHpA=;
	b=mnc8LDslIQwRhbmDbIhMoo85VkwgLgh6tHza4GsY+dA4oTB5pTVKcsUWivJfz5xjhOnzqv
	AWcNFfpjjuM4v+RW82pRWuMOB5w8tVhBMgtD5BzcWJ0WMiiesRT4UL2BzIj/+jdDF7L8jc
	8+sj6E7s3dYKFqSwQaPM/Sfqrf4RAd0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765534357; a=rsa-sha256;
	cv=none;
	b=0+ehFTHOsUv94ZQcW4UXI713RYKhRDhXv1fodfjkA2pu5KQ7sGdgI37/BP7uI6r4IPWaWY
	8bRsu7Cgc5JAUbEk6Gw2AkOA6VsVRA3F7nQEdG9XjyhULPWPrjG7OipD1Bil0FxmmtJtxB
	wA9AYCOwDSxctkWL3cybrb42I+xiYdA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSTVJiV8;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6446c1a7a1cso1013704d50.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765534356; x=1766139156; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyiWj+teLSvOcemqfQ8kWGe8XZlNZ+qzMwX7g7wGHpA=;
        b=pSTVJiV8lH3t+89Uq44702Dped6sLH0HUqdb39nt+t1pXCjR8k8395YwrOiP06P1QV
         f+uaUYoCwDSpPZ0H15eVrb8mSKhyqDC9IxkJQu2tvVyoxwzen3dDWhGEhWLFCdF34di1
         DBh5ffrPKs6VCf/Bo4GdzZU41qV2G2SKXwdHUgdAKfMV0St+atDh1ohGdPY2+lv/IWSt
         RhLig9F1nftGZlCF88e2sTMkDLF869I0vJ6itJQ+HsfqglhPwUBzr5BhOp2YTCVP2XRU
         VGSQApg1G30rIc4cq+/5qJV19PYlPj/C5iobWCawPYUI34PgV8CNQ3oUb0W7GEq9toHa
         8gLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765534356; x=1766139156;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tyiWj+teLSvOcemqfQ8kWGe8XZlNZ+qzMwX7g7wGHpA=;
        b=lSL4kFMzIkM6qXwdnu46YUb5G/o7FgXygNnLrF3Jq6kT3N1y8ipI64WQhO/QLuQnmE
         BHSFCagMevXfgHjJ2PgC0qWs7cVtxPrmORo+9hCkcUcKW93DJf2A6szViikYe+R5vzsn
         yGZvvvjIaSwXl34RDtea8WBHC6r3qfjQgWJUGjDdahcsbQbfeRordil0x4e66cJKDCGV
         9Z35X2p1mvE8zBgPuGHA40hroaqiidiMqk1Lc4lS2svi6NWEEPHaC48roTt1amJsrJC7
         WcgLFFmhnrpTkpoSJniZo5CgDorfiIkj9nRKQnPbxTzNvKI6OJnuguOk7bRlAP4awmRu
         sGpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw+0u8XZDH5BC9xcGCFB99AX7Kw53wE+4q/CBwZcf5/NjEfhOw0dBkZGLMKtyIN785fvlQlzOygg==@kvack.org
X-Gm-Message-State: AOJu0Yx0nA5Hxq1dyaWhd6xBv6dqUGQr56+vwmuh1RnI2QUGJD/IJdNR
	tmVP/TFciSiLEpYY5fQwbVh1YqoQrmZVel4uMtEX8PCq393Ex0uLYet8KHwNAoO4dw==
X-Gm-Gg: AY/fxX6F6k249hdUWGMktkTYf42h+xtTV0oTNUNewDt8RlKbTNf4zF88wY1HQXYH0Lj
	tIs6OjnD3Zja+sX5RvJXGPxjNB8OkbHliakGz/kioBrt19QZw8X++XLHFIdyDmUE3F4m5Qooz4e
	8wp35PFnUdmvLW2iEr3hcXcH82r+l17t2V0NDkXrZauQ9c8jgQGyEvkxDOIWCLWNsN/gxUK1Orq
	VcXB7FFwTaixQ7wkcA+YNnK0TO+g6DVLHUY32TymnRzCpi1cFV4whlza3KQ/wt0nuAIIcY6rdRT
	LcDYRrblqdii0RhDsrpFQRf4N1iyKMUxWfHuS0BGprp6AkzYGth3j9EDQ47t42x4fiFa9rtgOqW
	qNmnxSM/Z7lKZQ2+gdvy2kCr3zgsCZGhOTPQrgaxxXPw5Wboj7dN4J5jIGedmR1F1UW9pCKDI/o
	fNnsMtz+Dt9wgDi3v8XRHj+F9qPoFsfDHcNIFHFYAid7f+ozOQRIkPdZFW1nttDhqg2tV4346vg
	+QcHDDLmQ==
X-Google-Smtp-Source: AGHT+IGKtXEzcTRKcustuNEfSG9GQgq2I5s1vamHi1Jm95rHy6d13FrXiicoayqFzE3hF90bPUJ+gA==
X-Received: by 2002:a05:690e:4105:b0:645:591a:cb5e with SMTP id 956f58d0204a3-645591accdfmr267163d50.5.1765534356223;
        Fri, 12 Dec 2025 02:12:36 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e6a46397csm3097617b3.53.2025.12.12.02.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 02:12:34 -0800 (PST)
Date: Fri, 12 Dec 2025 02:12:17 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Hugh Dickins <hughd@google.com>, Miklos Szeredi <miklos@szeredi.hu>, 
    Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
In-Reply-To: <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
Message-ID: <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com> <20251212050225.GD1712166@ZenIV> <20251212053452.GE1712166@ZenIV> <8ab63110-38b2-2188-91c5-909addfc9b23@google.com> <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 751xnfnybkd485ju6e1bu5xyc9cskhci
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81839A000E
X-Rspam-User: 
X-HE-Tag: 1765534357-929389
X-HE-Meta: U2FsdGVkX1/61OJP58wgMv9v4XzQiZz8DfL9nqECztoFdUg34nG87bbhcQtqP6KWmH8kA7fX5VAVA6ZLBCeVefLeNJyPTWdPsuc/LZFAdBs7V6lu/DP1ziqYtbl8Tb7Zky+TXp0graTpGvJmHMWdfXVKk6lPXNVZsBFB8qtngGu2rXrfRx3txO4dWp4YK5oczh8BubbWHdSNtV2hDT9ePBJfQGODA1r36WeyCibnJDm203sDOGYJwN2SmFONeAJ8ic3SjJ/AZO5VSILxg6C4Gl/IEEze1FXwu4n4tajizHR9AXGk4aRAzFxxn5F05E5/0BW8Gkt15Z7Rbf/7VTo2AOeDs2HJSqsj+X0+Sons6XM+Ti8tOKHI3XMfgh7YgMy5sc9U/HhWLsyr/jFNfOQdnzes+Y3Pgq5YeywGsHf98OhxNgzAwxEeDICuxTLwW4M9J03oSdQr+IugXmdrijL/CeVapSZpVyneuhr/F/Hj2JPPmNUefNNhw6UHhiM1pPtwyw6+10MnLYlJhbKrRvVEa0NqzqOi/6yp7KHkruPz6u9H3zMg4WTp3dwXDXx61mx1sOtX+8BRRUMEFA8lRfFELf1CniUGacg4Cw5NsU3T4MkmjtkEg6lI1TdV9ok6Jo1XPWo3UeKcIB4O8N/nMxlIXgQ+D27jcyZf0VhKz5Jh/w7iSE96XPAGoxaYpn+mTMUxmj3J7c7b4W1Rl49Xn7s6YWBbvLraWx/k3CKvh8Wegiuw73NIVjeOnOMlOSjuOVbaLaWOI6+nEPA1n+Tbf8XQojVRhnK83heFYTFXiQs1Ba6g/D3RhN7qeN+WrDf9Gvvdo/iWp5fRxyMy16Q7N57kk2mYXUO7qja/LYWVEvODVxvp8P0YQOQf48AsxLYb9PUQXag3ncQs8FSVWMP78rPYHMQ9zQbbVh3K/vMCXo5vM165T2hzcu0PfcE68BqDdN1mjo3Gz8ePPQ3GoJvTlM7
 dP8TGusk
 2lFwhiVhs/GGsd/6N3FVXWshK0+aoaj/dYHs4Hqt2N5XFWhB1gHY7JoaZiMo32HP5KjPEtmd6GFlqbH3B3bFJrpPgozB55fGdx3wtJBVjM5wtIBVd0jOTXrwVakdxPAAB6KJQip0V5daULmM1zV6J1e0zgChNkw+h9anEkSDV9IANBwaSpK/sNpvSp2+XNnKiNaWK5SrBtcjtkf1GfOSqHC16xhyKMUuQoWxCxD7LcN2s8Uah9/kzjCQd0CZa0LOTcCu0dwr9F4k01ozZTC6iy/Z86rSgHlZ0wUrnF9S5WJWLLPOF900Ls5wQbO1ipzc5vBy59Qxe9mhbV08iqcZVka5SIpXjI2670E16LG1Pv2A5JusTe52RkBpmsZcV44rzT3LxCrdg2G1MT80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025, Hugh Dickins wrote:
> On Fri, 12 Dec 2025, Al Viro wrote:
> > 
> > A few more things to check:
> > 
> > 1) do we, by any chance, ever see dentry_free() called with
> > dentry->d_flags & DCACHE_PERSISTENT?
> 
> No.
> 
> > 
> > 2) does d_make_persistent() ever call __d_rehash() when called with
> > dentry->d_sb->s_magic == TMPFS_MAGIC?
> 
> Yes, both if shmem_whiteout() does its d_rehash() and if it does not.
> 
> > 
> > 3) is shmem_whiteout() ever called?  If that's the case, could you try
> > to remove that d_rehash() call in it and see what happens?  Because
> > that's another place where shmem is playing odd games...
> 
> Yes, shmem_whiteout() does get called.
> 
> And when I remove that d_rehash() call from it, 269 476 650 and 750
> complete without locking up.  And when I remove the WARN_ON()s
> inserted for 2) and 3), then they pass.
> 
> You are very much on the right lines!

Well, more than that: it's exactly the right thing to do, isn't it?
shmem_mknod() already called d_make_peristent() which called __d_rehash(),
calling it a second time naturally leads to the __d_lookup() lockup seen.
And I can't see a place now for shmem_whiteout()'s "Cheat and hash" comment.

Al, may I please leave you to send in the fix to Christian and/or Linus?
You may have noticed other things on the way, that you might want to add.

But if your patch resembles the below (which has now passed xfstests
auto runs on tmpfs), please feel free to add or omit any or all of

Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>

Thanks a lot for your very quick resolution!
Hugh

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4023,18 +4023,7 @@ static int shmem_whiteout(struct mnt_idmap *idmap,
 	error = shmem_mknod(idmap, old_dir, whiteout,
 			    S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
 	dput(whiteout);
-	if (error)
-		return error;
-
-	/*
-	 * Cheat and hash the whiteout while the old dentry is still in
-	 * place, instead of playing games with FS_RENAME_DOES_D_MOVE.
-	 *
-	 * d_lookup() will consistently find one of them at this point,
-	 * not sure which one, but that isn't even important.
-	 */
-	d_rehash(whiteout);
-	return 0;
+	return error;
 }
 
 /*

