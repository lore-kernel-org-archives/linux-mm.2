Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0580C9831E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 22:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D5B6B0088; Thu, 24 Sep 2026 18:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF2E6B008A; Thu, 24 Sep 2026 18:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCE76B008C; Thu, 24 Sep 2026 18:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 278A16B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:31:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 908DE8046A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:31:32 +0000 (UTC)
X-FDA: 85250103624.17.E365770
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9003A160004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:31:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SycTMO2V;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790289090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLxQ1V7eKFjM5hpU7Dk8oYI/it/LXUSsiWfbILSfCAs=;
	b=38+ABOVqx37TnqMx39WSmtAoT/4sB4t4/OYJCwpSw/VfpJIGuMmBHJanAy7adSA5xETOv4
	I8u2J0swqaev6eV7JE/Pg03DN+gMilRC1p4nMvD3djXkdDimFz0FkyTprNNSz8O8y5YjVV
	XkXGuZ/YcRupfmZQP3ua0CLDGu7ZFOE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SycTMO2V;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790289090;
	b=jfZLRux6b095Aw7APTV7IGjm300uhPWSiw6ZxOtOBc9seWVCSufPWXHgTsOurFMvp1iXqo
	2WEC4qFABcRpq1t57DUBVC5uo1rpIVtm3Nydu77jCrQLqhdW3du8KzESOq8oG+ShgG4wIa
	lmRXwUAHrTpcdmG80OVuwXy1Wnjc5TA=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-530e2f50d01so4026921cf.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790289089; cv=none;
        d=google.com; s=arc-20260327;
        b=f50xbbsfY48NVf+kycFl8Q2LPIXAM6cnjvU3L7HZFEsVLpSw6dEYoDvb7fJ9cCKLp/
         npvWtu+180A/2JSLDroyQVLIXf9KVCr6s7Q8FC0nk408EYLHht0dvqS6ErEINAcLKfle
         anaBgMcsD3f+CHMeXnoxh6RzWnJMi7BvDAHuBOZnP9elJIihOdaujdVgQVOWgw/q7xxZ
         bX40pAUFG+9RF5n8o2EgpP6k+lrXny7fLvOq9LAjCZIvXUGA8YTMlyxs9c1jpYeRqU0u
         oVfnv+GSEG9VionUyjr03QJOeKFsWEk/yPwWQugfLTWEOpyRrXDU+A/0K+rVV/lKnjXi
         na5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KLxQ1V7eKFjM5hpU7Dk8oYI/it/LXUSsiWfbILSfCAs=;
        fh=Skhg9vLwfgRMHXyFGRRaE03GWg0sPlyXJhGp22wyE+g=;
        b=ck+uW/hEyZR8h/oO9BBQ7/FplbcIyIJC7xC843rMHpeUbVxgL4o0YNP6cPLPyYKk9r
         Vh3WJyqw2gi2d4juO+ziLmt/LkLi7GTwsSlXrmO+bdrF+8fyKlgY+TTJSuZRlOZejXe6
         MfNhIb7X2OG5UyLLFvkjhunh/0cCjKV5go84whHYm/MgHHY7UR+JG2Pp5Ek5mm3zQ/c8
         5Yx4ZrqrYDbcvt1XQTUxN9fDRvtslefjTu4r2ca3z1MK/4t2XC+ejrnN7q/6dQDo7yUe
         IIbnfqKAssM6YKPSwpue421uUw/9LSakY30GHAEem8VcfJFGy7zwDSnRrNGv0NUwPvEw
         2nDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790289089; x=1790893889; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KLxQ1V7eKFjM5hpU7Dk8oYI/it/LXUSsiWfbILSfCAs=;
        b=SycTMO2VYmujy2Vt0vWnA/85GBaTRWtUB8esLxRRNqexRnhRrCFvKzdcAvNjkOophV
         d3mUqN9uMXWGU8E3x59SvSW+WUfvrZRfBFj47HA0huKpQl/ci1LUXXE+62nBAC7z+VZi
         uMngDnAOfUsBK+G3njNOBlt0qeKVKebHar2uYEcybwtACZ5bQbly2wn8a1i3otiUaQbR
         usB0UEjJU/uJhiVes5SgkDo1z/U9bboLH/buMVAwRrzuWBRWhLVWWiVPaRpOfcAaVHGx
         rGgUNS0Cw7LndQpp5J8wQdQtMkhmVpo9Xq8Cr/+gz7PSTl5GcDBUSCVXZbxAQRxjmXrX
         OyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790289089; x=1790893889;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KLxQ1V7eKFjM5hpU7Dk8oYI/it/LXUSsiWfbILSfCAs=;
        b=gBJV4bkBVbGSPl8ko0PtWnObukBVlJ6A00gKqCwfh3GgEzD/FC4aZ+s2fT3eqFA+RS
         TfpnDaCkKE7YOmytUXcYbIEzqUKeu0E4msLRRcQ4UZt+GYuIpcLBSNIXBHP/iBf6DwFM
         FJbWomtHpzBkmbJMYcZYaVDwOFKuxbUQWpdk5lOEfVoOe05jX2vJkjsB7qcwvxSo3WXR
         Q5qQhrou/iH2JSHOt1zplRe/QU03thYCBvo2CzDJ/GIwR3yHtuE6rplDzCI5xb+t6wla
         JlIREwzvhMKB6wlnsifZcEfWWBPKiU9lx3ECjQJuZn1gBRwiGEtvmDtXjXW5QN+LWCTL
         awrA==
X-Forwarded-Encrypted: i=1; AKwUvBxxxyeDxNHOeHpc+tsCLNMuNARLDd9X1A/zkXy+qEjGksfCT+qWtvHuLXTRn2Wo88K9/AUoS1/J4g==@kvack.org
X-Gm-Message-State: AFuF++lhIHAbYj37IByQIHZzLRBoK8q/rP03P1EsvWUCZw51C9blVKHb
	qFnnv5FK3op62U5FBrBjHco/YPqLX/ZxOiEDQxJQ92LwF6qTK7lGilM74mufTVrJ9lz9bp5/4B9
	gCochSK4g7LmSEqYYhgMdoPBr9piyn9T//ri4m6SL
X-Gm-Gg: AYBFou0jRBzQFjJCdju/a7QKwG6DOEgHrnzC8KgaUhtrUBvShQu5qDHnKpC44c8PIV/
	zFMCbKCrnoV9ptVlYTw8U5OxgKVF1p7c1//wZwgoguWCqyKDViuqRCcmD7Pw6fztxe+If2DR67i
	4g7ImmAehTX3ssYJEt5fNEj/AiMXI4DjIxHLj89OvGUxtJxPatOIrfcMmZqIRiK1+aXvo43jpT+
	s4FkXJ4z3tmppL05/QNm7bO8tZ2cppxolk9M4blJYUfJIUks63Det8s/t1jCw2FpkcnGnYGL3Hp
	ek7HNHWI9UjhItUx73FBB7lD77Sjtm6EZKIoHH2zJ+X28CunkAr6vOMHz4ZC0yOMkdwAaOvRA42
	Q+5oIIHBoZc6+OVq1pSn7uWMDnPjV0KUSSB1M3ZbSJQ==
X-Received: by 2002:a05:620a:2b93:b0:936:eeab:307e with SMTP id
 af79cd13be357-93c43cc5676mr141474285a.9.1790289088659; Thu, 24 Sep 2026
 15:31:28 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 24 Sep 2026 15:31:27 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 24 Sep 2026 15:31:27 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <179028368162.2007072.12117327378679658047.b4-ty@b4>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com> <179028368162.2007072.12117327378679658047.b4-ty@b4>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 15:31:27 -0700
X-Gm-Features: AclHuK8DxWsVWtzA-dbMsis8Esd8BT_dOvi97JucFF4AgqprHJknTuuePlOITb0
Message-ID: <CAEvNRgFpMwduvHPGJ5fLoVPr_iGn=ELzY4AcMGHESC6CkMyeTw@mail.gmail.com>
Subject: Re: [PATCH v13 00/44] guest_memfd: In-place conversion support
To: Sean Christopherson <seanjc@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: f4rp3txrckec4e3wj36w4q8ksubzn5gy
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9003A160004
X-HE-Tag: 1790289090-440146
X-HE-Meta: U2FsdGVkX1/iOdNDQejqB6yxLk3/kLKFXeyK3NpnPCDqI0o3QKGcCjhs2XmKNaqpv2Xh1LVge5M+3W6zNsGrqPb9x0sDFjpRsnQXRt4YBPyQUWFxahG6p3qS2MxGKNA8wBhDoyKho0L5v5Fh6gjvoclVjBgAqXh8xycgz2M1pjS9VBudL6nCX7i+lXiylpJ0i+p+rZAVLJXpC9nkm3ONTdDVNe7pA9GSaOKzoAN0QLdw2Ywmj2XAcBIQ+xmFFx5cz1vpmbTxx5Me1qjw2V7IMU4gBDOmVn7x0fhNBbCFo3svva1shSGp4SG4Qmf3IvHy4gIOKJz+UUxBs5EpcvSWXsSLgriRterFnc3u4waCwOKiUkgYEa4cwcRF8peXHvTuR6DL2vK+R3djFU5+5TQ0DTc7rron6Esph0vFYPJFUNCNTy3tgiaaZfmuZLvBcApjJ4LOmxbBmWR9dvVbfsA5SVzaVZv/z9AMmhR+64GYM3OhrhP0pclZTjg+O8EQcZ8iQe9k88/1oxtGJ3kSlxZKgdoXQSRwxsdOAm36+Ba7qS56/UyWpsoZwWx4NbqKCCe4vznwoLh4iuTgl8vmMuiShph9As3dMZJ7vQ45aTm7CHGKcbrV7ySf+kbOQnX9z8f+KXVfL507uAqXA0PEWnKZM5jB200aaPUGAzNFurbUStNU/eUdDxLIwW1caf8zEULghH7Rr3IBSB8Ed7NvY5chJwtb0HgtZ9vdRo6eQVDlt+7uD2/ZHv/iTO0wvryc1ywIs/w7UrIkPB+rqx/9C8QJ07i/89cR1icmNkz6WtfAnOiYEscAympwlAjyyFvkoL+TB8Tpkp1YE9ygTqdfGQXVVlofRynS9aH83jIcEhrgpryOJChM8GdKj+hKJcVKCxlbNKEXqPZAZbFEzhQt87hARdws030UyZgIvrkOojQc0MpYmvzuUAa+OsriblBEBZ3YV75F68vbON+VWPAYKsP
 2uojAuen
 KO+iJboTpYkLJnjU0daZxB9flA0OzvblqFPMZwrp2cILQH+L3KLFBz1W+lzbnRMCbckDaFx49LecWt3B6RgIFjVpx5D/O4dpkNFHb2TGl3UNDC4wbKuHTRt0omnZr0shg9D/06WNXGBj63T3DZWmPuUwMuv3KwB3Of8JoWKzzRY1i2i4cQi5FwX470UeZ5WLR05vKxhRiTnzyvV3y+OgITGtK9r0T4FA1M/hKEjhRE06E5GkvBesG17p5HPlw+Age+WQHiDHn5L4o7OLVj+kP53uZOS2+9ziBc/UbfYoObD50w+kO2nKC8jAneGuIyENsDcsCZx5uXgjRW/6gRvNSxPGRKcvsqP/OiovXOIKL17Q8xwig0pe1rEGInQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, 10 Sep 2026 16:55:26 -0700, Ackerley Tng wrote:
>> Here's v13. Thanks everyone for the comments and fast responses!
>> We're now at ~3 weeks to soft-close at 7.3-rc5.
>>
>> v13 is based on 7.3-rc2 and:
>>
>> + Hugh's patch to export lru_cache_drain_for_folio()
>> + Another series [1], which makes kvm_gmem_get_pfn() NOT return a
>>   refcounted page to KVM.
>>
>> [...]
>
> Applied to kvm-x86 coco.  A *huge* thanks to everyone who helped with this!
>

Thank you so much everyone!

>
> [...snip...]
>

