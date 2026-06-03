Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376A6CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B646B00AF; Wed,  3 Jun 2026 17:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2FE6B00B0; Wed,  3 Jun 2026 17:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8FA6B00B1; Wed,  3 Jun 2026 17:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA7D6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:39:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39454120409
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:39:06 +0000 (UTC)
X-FDA: 84839917092.26.545FACB
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10F33100010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:39:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=a5qGApmF;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780522744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8X5hcAFVZJZKmCogabE4dJnuZ1g/E7cQIrqG9l17rg=;
	b=oPoXFV49lKL/o9rEDJ9FSLmzjz0hALqu3hFsmLOzA9W7nbpjw70Rl8qnrN/GNbFLCimHRE
	YsYCpVAU8t+Q1CMpM5luOsFc2/LjM/PMuCb4xTK6CSQBoL4OuvALaljoxs6T/5cMrlvNa7
	6c7hOFKBKx72gXstR+H2FXysaeCgYEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780522744;
	b=31sv94/QOqPtQROVb1gSy9JIZ7rKFI7yGCcqSTi6n+TH1NvlXGZTWYHkg22USB5O2zjxqY
	aPr3/MWIxZsAUVZOIkpN3pJ4I5UDlCDrm8ObmiN1zgCuUUNsIhCg41bpMKM3iCn7kExuV0
	fHStDnkswvrD7CRpHd0rKFu4j/zAow0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=a5qGApmF;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf2247e38eso238105ad.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780522742; x=1781127542; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O8X5hcAFVZJZKmCogabE4dJnuZ1g/E7cQIrqG9l17rg=;
        b=a5qGApmF8OO4SifeA8GYzLsKp/HcfZZoEJGT/KZd9U7qUK6b/8FwCFnwXX2vXlVZtE
         T0BPBaFvTpccTnb1sl24+xwNHIc4mD+JuI0XlIIuWRyG7zEmmdCJNjvrR9Z6+2Khf7lW
         b+fT5C2nN2u40pTkSquB/4v3o8Q+q5NQqJT+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522742; x=1781127542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8X5hcAFVZJZKmCogabE4dJnuZ1g/E7cQIrqG9l17rg=;
        b=AYK0uXtW5ItdFPS1dFZJbH4n+DQC3sjWFYO2R4VG3xf4EdVH5R7Y0gQ6Vc7Cg56vLl
         ZJidfI/9VC5+Siw1p5D1s4WDbGju+f3ifc0zQe8nsE4rdaK67z6PLu+Jj4rZ+7kLC6lC
         oRt+VdWWjKjFRdK27Q2U0LRN4drhSAeSPb6PsSKAq4SnGNrgSrtWS0bYzjlz9DGn0/hh
         8Z2RdSwIteLFAtiM928cfbNzc2WdauIOeb7LWgSolDjlthyWjJI9mac+G1n1BmV2IarT
         wkTPsOzXiE8zQz0g1wYd+21XEUkoXhpqvQKavnYulP/MB93CZDInQhBVt6taFc+JyGsT
         Mesw==
X-Forwarded-Encrypted: i=1; AFNElJ8YlS3uyy35FCLDhlwqrGr7B+0OHJuAYJ8OzfJs4UgxL3kyGCKOwM55E1Sxetrjp1C7mqZDQsAZQw==@kvack.org
X-Gm-Message-State: AOJu0Yxr9afVWuPCtX4XOcJtuOcErwZr8XYSofjYorsdLZyfvjKx29zP
	dWRn+LPqF8adjF6n5s/Xx8kFPEZhf80/QaldQmYcssZfERGRjNVv5exXiJuNrS4ehiPYsvDBsgY
	9s4PQGMU50Q==
X-Gm-Gg: Acq92OGFSixBtrTnLI3h2vhMteThTSWYf/bTv7pL66Hk43qgLwPbIJLUdrx0md2riH/
	+TaXFTRmhOto8mFy5QiFIJ6DGyVShhIU0YMTXiNxHBi2wZx+eofaL351J1HIA57bpL6a9uZgmZl
	vjsyj7JSdJHXJrP10pM2OiJbVIg8yLkIxf4SJlgWMaAmJdX8gzCF08CHbTe6BN0fM0a1c+XbXAb
	x1EnIwzMN9EoyYfGgqXXksx9ejtCs/33SQ86hg6chT4m/lJyH0yarS6pU4tmZW+eAIWN56mPiPV
	XFOpMPOtAxQOSpmi0WRDoAn0hkg4WtRcUmTJLGkl9MB4zql+8cOcSHvFseXHFqKR7syskcwrRKx
	hrg1KlLXRbUrT0bUx3CNlYMJ6kLau79aFvnaLrO5R5dbkvc0jxBm5CcntPCblMw0F36ATFNtnsO
	VsKsdhZxvY7bvKyYmnPyeHW5x19bH/QB+vjCk7pFrZ3WIY+jyF/51cWBmFbEgXf4DAHorKh1eCF
	K4zPZXe1Ec=
X-Received: by 2002:a17:902:cf08:b0:2bf:222e:455 with SMTP id d9443c01a7336-2c1639edf7dmr49287635ad.7.1780522742668;
        Wed, 03 Jun 2026 14:39:02 -0700 (PDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com. [209.85.216.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649ca4dsm34531155ad.76.2026.06.03.14.38.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:38:58 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-36b903567fdso6418266a91.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:38:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9MpI5cX7H2zqDWcqPSoygVzfnuTpyZfhPHsGlywZ54xNQejuWXws9sRFmlQQGjCC8DYlD4GJx09g==@kvack.org
X-Received: by 2002:a17:90a:d647:b0:368:af5c:5925 with SMTP id
 98e67ed59e1d1-36e31102a48mr5572800a91.23.1780522737998; Wed, 03 Jun 2026
 14:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com> <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
In-Reply-To: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 14:38:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wha=LtAq8y-B4j9ps1g_qv3CK0LrHdHEVxP_52p-m=NZA@mail.gmail.com>
X-Gm-Features: AVHnY4IpVbwzilxzEo0kIzmtKsGcV63XCgmSpKmBQvjcdm3Lbflf84U-wY6VXLY
Message-ID: <CAHk-=wha=LtAq8y-B4j9ps1g_qv3CK0LrHdHEVxP_52p-m=NZA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10F33100010
X-Stat-Signature: 8d66fpoyqezrfnwxi3cioirhfury1cuj
X-HE-Tag: 1780522743-189733
X-HE-Meta: U2FsdGVkX18GVMJu4oKkaWR8rP53fQrBzLw0U3g1Gb9DfujMbYvQZ0I1MyTQEYiPuWyPFhRm2TBa9krlYWaTG3Cn0J0EZG6BTh0AIeS9BStDmaey7TlTDn8Q2/gFUaFSEZy8vkiUBcqIOcXROGH8SL4F18TXa+uoPrarHFwVsBbGsnT0wPFd0zi3aYhuCy+izf68T3yqvS/KcxfrhT7EyjEaDakexKZF55VnC0hIPpPcKixQz5IXvzy9Ovyd+wulpDqmnrsJDm9GGkvm26Lxb7XsNS9p6eNB0NZPxGsTlerxwzn+Iq/I0AULjsfP1ngLeM8joOhmeyf5JD9mQCFTDGAef5KjpNZ/9AA5q+7A4rqmEqHd9Bl7zLvQuxu0B2NyZqS234FLvrMD2MdbDjvv9gookH0rrwp7Wwau3RlNmyt0uLf4WuCvNz72qsEQn7aRm2qb+cPRDcgmOa8LULGyIL9ADTkdHrjxlbXbRkc1C78bVGdoGAwN1nQNB9xeHqXf9K3McYe2v3jaC6mLsulZtlA2a9yK3GV9cgVVVD867PtwSfw32I+w2xfqqcqxYPGa5TtbLOoHLrXQcZZKCi3UqiR9m+lrcDUqq6JeIh1jlgHrGk/n/tlpqU8sLQvAThuuSpfihJQlghE61hTUOSQn/zwG0rh54vlsjxXfQ0YL0DITaxV8KGoWZCGMo4uT8f+7qqZG3kVpVgxRi31sY4QXmPUmnVSW1EqI1GgOUqAgkx+90vFehkBhgkGJjIut/CwaQWSCnzpRTytgIqBvmIJCysBnegscbc1F1qPdoreT+z85OV2c6vmg1zjmuGjAL1AJEj3OO7wEb68+NzPTjydTZ40vW5+HF9bsj/1p35E/yaDw4NbFuefQ1R8xa1w7YHqg5O/WG9jmKHjaMhpnJhzLquNFY9giq2ydECln50qgfUECt5e5h0KoHL3PW1K/8co/8IFneZtCm2omiKyQWZR
 M+VhK8lq
 xNCmw7UaA0bS/nV7reuhxHMjVUV4oSiRj+nAEyR5qHn1COZGQBfjIpCohoEl5CSYwep4RzD1h3cPY8aOwMvBxjwm8HA2arJvV5YKmYcI2nTWf5kc8tq9yRsC7l/3A+aPJQTjxeWgJBnnlBR8bp2snN/x+06csqkJAikClqP9qHc9eHCxtbz8IgRkS+5X6fprYv0cQbQNxXkk8iirJLG70ChQR+7XTvqEOg1HfKRmSIcKDassUjxRpcVqfP8/jxDtlR3sCQ3PQm+pTFywmySA/wr2hB6kf6TxIQnGzYim4CyzWqsE/XVu6IM1vkHbWY4vHbZjfKjFAlAOM6JKgVGUIfle0XmcbeytbmwzDoJBzQwuQe47wb5p7f871Vrq+RmfaZCVx5iSsTqxXhRZ34zEssgUfY8FlyE6wEOqab0c4RKkSLecraC4ZOH3Js9OuzcCeZiBzXliRpFQHDNnPRYqDRaFQ4Y6NCYAVR0g7L04A8/EnCWkuwfuKNDfj46SsoqycqRV57suTKW0V4PfQN5DtsvD5LYEJ/QLn79id2XwpBHUFDvzHywrMjgg/S2XggwDfGJ/d01T8b/I5w7Ow6xRmR8deLwHSwOmIaVdXnC3YPaUMbm9+vthYtCx13w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 14:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It was just the filesystem side that basically now instead of exposing
> the page cache directly (with filemap_splice_read) now only exposed a
> *copy* of the page cache (with copy_splice_read).

... and let me note that UNTESTED part again.

The patch looked "ObviouslyCorrect(tm)" to me, and I did actually
compile-test it too.

So it probably wasn't _complete_ crap.

But I never even booted it, and if I had, I wouldn't have had any
loads that uses splice (or sendfile) anyway.

So caveat emptor.

              Linus

