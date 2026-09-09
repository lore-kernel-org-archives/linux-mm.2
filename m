Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11314C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3976B00A1; Wed,  9 Sep 2026 10:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154516B00A2; Wed,  9 Sep 2026 10:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BD46B00A3; Wed,  9 Sep 2026 10:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D385A6B00A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:52:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AD931C18FE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:52:48 +0000 (UTC)
X-FDA: 85194515616.24.7A53D1A
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2ADF01C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:52:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Avn27oCq;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRvd1Tt7kpHM/AxQHBaJz2yfsVBadJLI9GFkxk7vpJA=;
	b=sn21ruqROR0wIOVGEnkLsZAUF8md/cgv5lo+6Q8rM+UfrLzx3Pa94O9OLEic+W9n/fCuhM
	JjHyLKd2eHovEy9Qi7u8fC5uE4IZBetHPpACQ3lydbCTNS+txXKHvXn+/MLzmYBI+FhNWK
	S7Cvb3nFGMLne5/v/zz7OwfL7WmIC3o=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Avn27oCq;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965566;
	b=BHMCHRVgHYwiXNA9GkH2HlT8w8Zxe5iVyBnh3K5lUzn/HLWrDuSy4m6n6xjku9SezD9NWo
	7nvev9F/6/w+OGqhXwww3K2Yv5AmOxCNxk3Fkbj0fdaXolrnXZ7N3wpSdTXZNwberulbDw
	TH6CKQnJWR6h9GuRD+pFF6jH+UDaAjY=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-855c26cf490so44341437b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965565; cv=none;
        d=google.com; s=arc-20260327;
        b=SNdFknITYVaNETXklZY/ci3C2mGmdnXzmqplvy3UGaQyNFaDA1Emc5IF97Vp+k+MDf
         JOzTuEkRICebILyKNwg0twGt9qhRVy/arntnGNgYZzFZ3g8Xqzj4a9DoKfaAWApRALPh
         OkF719y8zEv8Tu9mc5ChJuQCYNQVg2x5CqldNs0SkGo/3e4l5nSw9Ez5NkdHOxoi+BD7
         F7n9h6OzZEZvggz//ym6OFljPhDToT+iWx2RMrqQ2WNAHzG+rBNR82qOxJs4s2jm6ge3
         uN+wen2G3Dae9bH0amzadwLgdkDxWfbz10f8ueCC/+6zVm/ofACqUynJoNxzO+QMorBZ
         oNAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=QRvd1Tt7kpHM/AxQHBaJz2yfsVBadJLI9GFkxk7vpJA=;
        fh=4HYUzOIe5ruLw7lIIOX4l36gtD34Bc6lqAB36Kn64Jw=;
        b=hJciZ9IuJd4i8HeSOAuWiIY7SAxOErMwnuAUmHPVOSD72h4zxHEZMcVnSKBSi0QJyS
         K5/rsfxAzzUO4KK0iYEwrqRAIzUl0r9OYxgJwUrotWKH/oCZaPpucrywWxWRoJS+EAfV
         D0oByK+JYvep0j2EJ1gkl0G8+ODdcj6LaIT45pTwaorswup+kuStenN2VqYftLZ/gz7w
         Xj10KBzXaXb+F09W9lVwrQ3rHxUNvhWfgYwKMU4/15ylO4vojEBJyzMWGXOzmHmeO0cN
         hXOMbQ78awnSK3hzRhHfhjw/1//lqmT/igXUhm8Jj7E0tpFDCfvOkkdCS11/3Kdnnn5k
         cyRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788965565; x=1789570365; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QRvd1Tt7kpHM/AxQHBaJz2yfsVBadJLI9GFkxk7vpJA=;
        b=Avn27oCqn5CRiOqK4jXGNcCuEkj+ZOW3S4h/Ku/JPLJQS87+kPL86ZuhWYrRIO0H59
         nzz0KDScthrwYWWBsdM2OyGOt/1RR//TPjejDWfy9F/wBTvDLxNk2xYQct9LyFkCqOKC
         +ZXdhSlSIwNS1Xt79VGndS9zb78UObiu8LpOb1ZPUn06N6VAXUF+Dg9+v5i6G2lz80Ip
         wB6T/zYD9zDvaT550bddP+HSmBSUc2A/h43j7ULOYZrbQakqWRFG794uaTPqt4ZVW+Ch
         rjP9HjS56gMNeevz5+X6tOak5xhOplTgEEFZW/qDH+zpK4yu63fDemLXy+YtOCWhURoc
         oiwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965565; x=1789570365;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QRvd1Tt7kpHM/AxQHBaJz2yfsVBadJLI9GFkxk7vpJA=;
        b=I7iNSyKRcEet00M8V4e6mfjmidEAXhKeaEU77Pu/JH/twxuzViPSBDYVEB/dpF24Md
         70wTSAYcsEDIzGFjErtWXGY8ZpdK4B3/UC6PiWL804hyrZ1++97Pwy2bB1vB9gSmCdXq
         VZgcHSWASxKjiPoha1mn4ZRh2UlYrWc/FDL+39vSPQyCYgmVBFN7SRnKCxBMilau/IRH
         HsxzphGTJD6U5VqAI22Bj6pBtLJq/2z2V3SXepT6l7bY/IJpwU7ywNE9R97+Jy2zktq9
         rCJMWFJ2qWR7477bST6H/gmWapEMo5KGqsVak64jyz7C16XnttLydgyjyOAnf9NPvqWl
         fNLA==
X-Forwarded-Encrypted: i=1; AKwUvBzHdsI4UVUy/xO7QIDAVO+eLcSjvEUw0OSkX3hXmwbuHhThNHFZFOx3gOBRgYBPMQRl9EXSe1GGNg==@kvack.org
X-Gm-Message-State: AFuF++n8JV5b6NMy6+RRIIPuIk3tfzzmsxss30TAFS+1SmA6jHV1v5Sd
	R6oyE4mYHmm/LJx5RpV1rsLtl/c6CdnKTEIwPoye5iUwC/tikhaXGQ1diBAUom/iFp8kSE8lZCD
	2IhiEAZbjjry76qdrmWJUkg2DvH6zIcFYENH79fjk
X-Gm-Gg: AYBFou0MyQPd60TNaR44uNWADDoWTl8i8wua2zHmvdZaKOYCnEtMJH75eSSwcekemNY
	fbaxuycoS7kwwyHraYSHqhRJMB+3nMlsENK8Tg2d0w7nGcL83Xpu0GydeDIEWQe+ANfTodAt6Xq
	smFIu/jlyAGUEGXvvAW8gjZUrVIX7KbDKc/NIG8m6Xw9mJk8rkocF46wopNmFnKLiF4K3k4osXR
	igRBjfc2baqi/AMPwd+Ni1GFodPFjvowxnCqlgJLY/G9eoCTFUDw4U2aBpIJ8jKkDWDk+NMRChn
	snbid0jRHWcRqqcaL4MUb42x2x5ltc7LYttRjJ6yQ4+b+Sj0ilVUZruFcLRKWF2NShsG6kZDdxY
	V9CpeOwLcWEM=
X-Received: by 2002:a05:690c:6b88:b0:845:ddf4:a3a7 with SMTP id
 00721157ae682-87126aa77dcmr145268997b3.16.1788965563207; Wed, 09 Sep 2026
 07:52:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 07:52:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 07:52:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTyU1Ldbw-qqdQOx_P8jrt85QEcKSGae2h+AahsDQdbmLw@mail.gmail.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-14-85e5fd25252a@google.com> <CA+EHjTyU1Ldbw-qqdQOx_P8jrt85QEcKSGae2h+AahsDQdbmLw@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 07:52:42 -0700
X-Gm-Features: AcwNN1XhqWHW23-sQN5ajMsWY1WhBdcubAUAi4IgbeOekiJ8g-YJ7YTjJ4UYzFA
Message-ID: <CAEvNRgG36aXk8UW=Mi7ey-6vUe1EOKnkgNRNzdSUz-QJih4uAw@mail.gmail.com>
Subject: Re: [PATCH v12 14/45] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2ADF01C0004
X-Stat-Signature: gms1r11s5j97ogx6sud7fs7ojhsyydky
X-Rspam-User: 
X-HE-Tag: 1788965566-781385
X-HE-Meta: U2FsdGVkX1/sofq8MfcteMcR63iz3h9V72rd99t1Uk67PqgV6horbpwCqStic3gTTzKUr2tEctvxZVmUkQiGm4xrQgCnPEG6oNqE2kyG5YMhgMMmn92rdncyvND9FmCNkoGjDg33Dq9M8BQEpPjM7G2Bli6SgDVwjoKs7ndbZokqKTlXHqwrRF/Um/oVZlwhX482RAP8IRwHWO74xqq5WtWusloSINsM8twvpoBjneDCx9YBDqPrBVUqJtTC61wXfCHQPcXFprNCXr0MyFgyIThJtD+ZQUcNA41rSmP1Ks7u0dhFkho2vKF+kmlljzeozvCNEDAguByU/LhJGY2Xsy0vb/0YSa2wiTMS+NJ5eQ07MO9RqOjdqujiOwmPEVLieMe804tEDg/I85F9Jwh8rNeo/csKWW/P+lI9tXedklEw0HtwIrmQz8cY7WlNexFXJIHnXyAPp47lvPWvIBi6uQz8+bo4W1a9rsutufLzzjbp0edfEZ4V/cLZ+53WRpaldtFT9jrrCANCWpHVtoEndTgFqZScVPHlvOGkrKxjd9MBLuUMQxoIhvXoAXRGmc3O5SY4bVD6nZz3PfIBz7+QtbM3367aWQaVWeh4WX3RASBYTiOJ4LueIxwQihCpSBg+QY7tqRFa2+i9xN++s2KyiGUH+YL6NozeNQdsUz12KYVUXxnJbpJrIh7x4dzwmJPIzkdTvmhHCu92L3cBWbpI9h9SHMs33RdfnRl4HG01N5YLhHTosbp+sgLCtIuS5ZZXqi22Tk53QNvxrybDJDuZ1BQOdwfezOHTOmjHfFt8ZHe8limaI5HoHahgPSq+bpSnFSlFWB7q8u02DAAVqYs+2FKRi7/kxa/N6NC61H0GFKl7WjoI1crJOu2PIGhCs9+QzGxFegwf57b+JJUxM/EB7NfSaj8iFjmrWdkTtem9MA0E2xM0iRbFHDEW77UXR3FICqT5gcQZvuWgdtzq9Hz
 enlIJOaY
 oQKUnXH7xmAKHJBFPodlm6rKYQoB6grOouDTNKtH3Ho3y/18UfSVvqgKNGJywkcfDeYjvfGPUkqnwypWxASrdVAUCNjvCVvIDNXHOq8fXD0/TNfvRdH0VWPI+GXiIWmWCvfuZqxwHND2v9+sCw9HPsJwgxGv6V4WhFfTQIkSjQPaPPBD9kajsBqN+gBGKylaDM9thvMx51Rzlze0OzBGadkPrjXkbhcbo9H+culwnCM5TXfYYCqAeZymYphnL2rcSL6lvRlHlQ/QDczChdAzMX+zjltrC7qTilt4S8c0FhbrL9kB2e4uuC4BiBpKuoJtrtXvwvVihaUdI/ZvYjZUKrIVC1CDXjgSIR4KTo+zEEcG2qW8HsYsGUXr9VzMZb8ZwKPS8MrGSFcSXdPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <fuad.tabba@linux.dev> writes:

> Hi Ackerley,
>
> On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
>>
>> From: Ackerley Tng <ackerleytng@google.com>
> ...
>> +.. _KVM_SET_MEMORY_ATTRIBUTES2:
>> +
>> +4.145 KVM_SET_MEMORY_ATTRIBUTES2
>
> This section number collides with the existing 4.145 (KVM_PPC_GET_COMPAT_CAPS)
> below, so api.rst ends up with two 4.145 sections. One of them needs
> renumbering.
>
> ...

I'll add KVM_SET_MEMORY_ATTRIBUTES2 as 4.146 below
KVM_PPC_GET_COMPAT_CAPS. Thanks, good catch!

>>  4.145 KVM_PPC_GET_COMPAT_CAPS
>
> Cheers,
> /fuad

