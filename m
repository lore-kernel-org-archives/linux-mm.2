Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F9DD4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5956B0005; Fri, 12 Dec 2025 02:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76316B0007; Fri, 12 Dec 2025 02:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64B66B000C; Fri, 12 Dec 2025 02:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEA426B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:18:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5266A13056
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:18:03 +0000 (UTC)
X-FDA: 84209964846.17.8423A64
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7854A80010
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:18:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sG6XQZ3g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523881; a=rsa-sha256;
	cv=none;
	b=WX24Z6TcAEILT5U7T5C83mBLbLGBdOwPDyVvV74hEHD5Cx/HJC9pJvAi5194V2HvoXSnjy
	C+hwRhvClMYi9Sf30cFjPBGsm4pWV/ZOPIak3YxUHQM4o06t3/lyGwMPqLNs3VW5nH0Iw2
	Vrc/F/JAjCcQpCJMob0qkrOVWWv3OQ8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sG6XQZ3g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDFj3cPL302Wi6J3PzLOOSoxJj5lTq2UhgS864Dd5n0=;
	b=uVCaU1wNe0jy+Md/UKxyUJd5XofF39g4LKbi8WD21Umb9c0kPCj80eCBLYzuH9iW8VxEJ0
	04FRFJAewzM25YLUdBH1FO/mqHKGc0Pe8kH94uhVaDiXGqEYzKFbxmsAxiaHEAthj9VOqM
	+Ww+D0CToa/ilEjjfn5wHsq0Kg6QJeo=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-644798bb299so746405d50.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765523880; x=1766128680; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDFj3cPL302Wi6J3PzLOOSoxJj5lTq2UhgS864Dd5n0=;
        b=sG6XQZ3gMNIdcQMyfRVWKKMYkEdI7h7PpjAEmJRL3OkBcu16TpY9drezhjIJdaE2bT
         caQ4xmRwYGEt7MZCRYR4xzreHGKMLFGWXiq9hhE90ZxY20g9vpgbwR1wGZ9jOZiET76D
         5XZ9gVxyTi7QvfmJ8qV+cbHSJbAIRXwPtdNAZwnh9kFzAX790O50/sq7ONdNH5vC78rZ
         u+bP6FSYtcsuALcSx9if8mdKeGub7QGHRYDiXhG+QZq/r6frhSYI581vy5A4EweuKLuZ
         vtWZ13P34r2xbEI7uG+MJRK0+XjpKQC+y9zuh7oHyXX+PngZ5ypHv6FdwG9Zuq9EXVG2
         yd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765523880; x=1766128680;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YDFj3cPL302Wi6J3PzLOOSoxJj5lTq2UhgS864Dd5n0=;
        b=QJW+uZ9TwSbHux4vVjaVbZjthIzKow/+UKff4hRWX+KrFR9+3onR2AZ/nzxOra+aqs
         f0hELeCxbU/GS3//FMY6CvlUeSvMrHVjI9E3LNHRrmxXolriFE/0wX/OhOoKxq8I+H7h
         k5YpHKrwm2rmQztBeJkP/YBXuuunh1SerdE3OJ+Wavr0TLdDN3399SGxR8/BSL/eS/DI
         ujbSfD/KMMAv4vpdEKAoizXYvLyjd9maxwQkwKtxj0/JN4bHRlHTJeFJOZDD5PXYEcLQ
         3v8Klw8HDD/UoAG9V8TI6CE9rpDYsR4QO62u9MYfBDHedWu+Ww+1y0yUSpPLktb6Vvpp
         M6xA==
X-Forwarded-Encrypted: i=1; AJvYcCXytR9Sv/0Y+edPCcqRNWa+JshC5q8Ru+LBpEs6kFl/DsRhZ/NG93VER8Nap+h5P6YgTjtHk/GtFQ==@kvack.org
X-Gm-Message-State: AOJu0YyR+NUslBy6QrBiqsXryyAUgxR50HgTQ1aHNOm+htCOkb6MCwRS
	/7fo1EHFO1jMdZoVzZN2krcu/q+x8FXHxll0ZmFV82VnBDjWq+amlK/ijUr8VLVm3g==
X-Gm-Gg: AY/fxX78GyWExcWiFgooaDvXVieXhvU3uXO209RZKmg1LDblFPp+kaO59SS2zHmuhYd
	lTPRG5TffS/LHp1OW3qCVoZ1kArB6sqyqU/lXbSQ1ErxmYvzgxvFfsv2zphTy74CTAz88uUMGuL
	FQWEYmS5a1dVuwxoth8ZMuf2ZCZhRB/Ct8I7AbQ5JVbps7lvWRvH6oawWK8zNMe6Wfv6xm/cRWo
	HSjnmJ2RHbZHhFTApfTe5FknWNIMrswoStNbj4ir39f4VxsCEmARvqAu+eLBoe36snv6O/OH7AN
	76G80p/fQTDB+CS3UT4XtY2NCJOjTk53B6r7lHCqQFkfQmGRqEBaMy1JAWYKjGu4vAqgWdT8M0e
	o4HjEzgn+ynZgBtMYL0m8yF13XZbkEnVzqSgh/v414Sxkji8jVxLb7gSc17/FBv00+nOeaNsrnt
	nZRx9D3drZJKkiqOCZ2vY1QWcSPs7kDlBgb7qjTvIhw2b03lZ3b434uphG9xTqfsB7xhRRMvY=
X-Google-Smtp-Source: AGHT+IGJLiDo6r3v6q+Z+SSY6LmdyLiyTa7Gl/o2vswo9LxewapmGPoaY0Ik84Ee5aPVmK+e9T1+JQ==
X-Received: by 2002:a05:690e:1447:b0:644:7398:6677 with SMTP id 956f58d0204a3-645555cdb89mr688396d50.11.1765523880218;
        Thu, 11 Dec 2025 23:18:00 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477dab9fbsm2184061d50.14.2025.12.11.23.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 23:17:59 -0800 (PST)
Date: Thu, 11 Dec 2025 23:17:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
In-Reply-To: <20251212063026.GF1712166@ZenIV>
Message-ID: <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com> <20251212050225.GD1712166@ZenIV> <20251212053452.GE1712166@ZenIV> <8ab63110-38b2-2188-91c5-909addfc9b23@google.com> <20251212063026.GF1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 7854A80010
X-Rspamd-Server: rspam03
X-Stat-Signature: yub33fwd6c5no99fzu3t76ajebk4ig1m
X-Rspam-User: 
X-HE-Tag: 1765523881-383502
X-HE-Meta: U2FsdGVkX19n8smvJlWFcMozIYkNTvESn/cO2TLOgixld9vnUIHucO1sAIOmgJSRk1E1yxgIt1EyxxkRYlgLOKNByvGQfE9v/hiSWg0YoUWBntLmoEHW9FxmTxoAJ4FcSHmIbhn68Y24oj83h55Gp8Ut804NHUaVcNts03QGSe1gpkE9zC/AHJl5Xwf7ZRkoruLYU34RtUKrCQXjxHRF9DPG9SOz0zq7BFxdtIYnD+8DmQ5SBvzKBhbJizhhPFV32iWbhKCxb+dffmabqvIOXqLhDwzxO8KKI6w1W8murtKhOXZuo0YocGBFcJz0ArTCMPW3J56GqPRZawGKja+UIwdhLwCSOb0/eoLZJLfnm95Rid0ndO1wm8dsXHC6BnsIz8+UMThaGVYucztsTJQY8HvpEht/22D3pb6cGFEB3ernGl/kNbTKMyaVd8S9jTHRfgCIxvTDP6zg0FN6fUWryiqa3sMj7gQj6elb47nsqoGMolHOkIF/shbcO5wyFfQVSkdxfF8w2X/sb1Rchq4AhlI/pN9JvZZSpH1MqCbLSJxdzlVkFRTMVnOE02WDMnCYtVreHKPAxAvN0LinSXVcjQXRf3G0Om8djZQLqc25e0RTgpi9GkR+Aa8lAlKGRD/ZC6QL/zvrvU0Hm39vbkUcRG6JbPB7/f1sOdZ++9Xno4d4/xjW2kL46tZ7mTcrcDI60EtrAGNO5XPpAbJgNexDCmVLJy9NEjYTk4wdv5/WIQaKew4bd/kbCacF42k1DHDq0xnPyRVwS+qYFxk1qVITRpadXaF9cDBmKzbNUNoK3lP4vo8V7jOpNFZrR2OFzorqRvhbIRL1a901q9C2EzdByW91LIfhHQZVPS09BImarttXgJ9x2cwngoBNOyS6C0IPWjqjvkNJlV2QZ7jyMZrUJlBZD9e3YG8ubQYbJwqrqt33Y0iGDgeObCgvXF2C2XLV6uIUUnv18St6O7LvyUz
 wtaiPySh
 dYJ/lzBYy2huhV4i1HaWo4JklXVkmAf8OXeyJ4auPhiNXvzKDMES0N9C6RoEl/PFkkptXFqr5FZBqpPfbRZNFh5IRzTUG8HUv0Z5dwcmTlqiKbB9C/0dTzaNAl27YcHrlMREttWbAEagaQX9fK4+gqQfoSmTaHUZvbAYzYO7nBjNMkGxUwVLSX0UNGwmv819t9+JW4sEST80C4xhJkMSQ5KUgemsGf8AVqE3RewBD/7UoK/rpp6zz+otnxUAZHUypIJ4Y8Hraqb7XQwS43kEUkybgU7DvTXi2YgEYTEmrpFNTh0jmE9P9+4UDYfzPxyxE4uSc87rkuqvmFNMbN6nBA+FQw/HfYDMJx9pi7WVDazyMo/aI3iXAfNWsC/nTm6pH4v5wevkqajfg5R+PocMMF8RaJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025, Al Viro wrote:
> On Thu, Dec 11, 2025 at 09:57:15PM -0800, Hugh Dickins wrote:
> 
> > No, sad to say, CONFIG_UNICODE is not set.
> > 
> > (I see why you're asking, I did notice from the diff that the
> > case-folding stuff in shmem.c used to do something different but
> > now the same in several places; but the case-folding people will
> > have to look out for themselves, it's beyond me.)
> > 
> > (And yes, I was being stupid in my previous response: once I looked
> > at how simple d_in_lookup() is, I understood your "hitting"; but at
> > least I gave the right answer, no, that warning does not show up.)
> 
> A few more things to check:
> 
> 1) do we, by any chance, ever see dentry_free() called with
> dentry->d_flags & DCACHE_PERSISTENT?

No.

> 
> 2) does d_make_persistent() ever call __d_rehash() when called with
> dentry->d_sb->s_magic == TMPFS_MAGIC?

Yes, both if shmem_whiteout() does its d_rehash() and if it does not.

> 
> 3) is shmem_whiteout() ever called?  If that's the case, could you try
> to remove that d_rehash() call in it and see what happens?  Because
> that's another place where shmem is playing odd games...

Yes, shmem_whiteout() does get called.

And when I remove that d_rehash() call from it, 269 476 650 and 750
complete without locking up.  And when I remove the WARN_ON()s
inserted for 2) and 3), then they pass.

You are very much on the right lines!

Hugh

