Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A5ED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEC66B0007; Mon,  1 Dec 2025 13:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6CC6B0008; Mon,  1 Dec 2025 13:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3B96B002D; Mon,  1 Dec 2025 13:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2646B0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:35:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A5AFB822A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:35:49 +0000 (UTC)
X-FDA: 84171756018.18.96B18FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 14B3240003
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:35:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqVRxi1j;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764614147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
	b=tQiqDb57yAOBQrGi1kXiG14kuuJszPpSIQmtryovK+D9UscuFNjb3upc3O9b7fYSoKJb9m
	GMD0+UA4OHnsRCLZE4Gsb0qCibOxVzzM1KaKiG6s4dR+iwV/Ju3/NCtTMRwq7lyNnxJFTk
	FIv2k0bx0Ct4h/ke5kRU+Ba1flfQzYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764614147; a=rsa-sha256;
	cv=none;
	b=CtpYTJFTeNAZ7uA31902DAsI8iZsJ+A4kcrGmWgwIbyfO1GepyrABGN6fA7jgufoMjmUBH
	P3ZmKp8ecjydwvOEpotr/hsHwa85d6Ds0evONo2euH3pM7Chk2VoVXKcTVaZOOCgcyVLEL
	nx8iSXgfiTu3ZOTScwQmhSBPBVzm0Hw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqVRxi1j;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764614146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
	b=eqVRxi1j8UrG84k5Yc5jkSU+KBhRANs4xYuxCjpw6j4ZQz9+3ZEzKr91D1AaQ0ZSusqBUG
	pf37V1YgsvgI8Ao5plgpBk0jqfXLRnrfk7TgVQCAcrMl2xZZentUYqYl4HsQLYC2HJO6ul
	H5mwxKihVBPi07O7BiJTBrMUXExTeQQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-KvA5Sb7sNfCkoVGblfPwJA-1; Mon, 01 Dec 2025 13:35:44 -0500
X-MC-Unique: KvA5Sb7sNfCkoVGblfPwJA-1
X-Mimecast-MFC-AGG-ID: KvA5Sb7sNfCkoVGblfPwJA_1764614144
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b225760181so504409285a.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 10:35:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764614144; x=1765218944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+SbwtOZH9ducWOEZb4+vngRgdkRzNyQHiBzNVLWt3d8=;
        b=O8Vv5a8UZFAPwXlVRH+WCqOCsFMqeSm3SFymrW160FDN4g3ylasBbTKRsYEiEyWTzL
         JSrawb5aGsNa68fred1rsIrBvC/Y8nwT0IKyBdc6lhSJ0+d1zfnT6jttQzxpMAup6WCX
         x5TkkOXdITypd6v0kPpKYwDkvmZmv3ogf2bWAJkpxQujUDli1OshkQHC1QyMQaGzg4Qg
         KV3+6P4dDuRhvMPPjKSNb9iWDx28hja3zHBBdOj+nn/bVyoeIgod2FVjoCGN5csiN07r
         D1K9KMmgl5YC2hUay1sMsOX1MI2N+IsqOtDWrvQSPfR53e7yyRODN3LA1hzQE7o9/7oS
         cz/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXK4wj3VDGfygSU5J0/z7MaAtTyiuGzkQkjqfUe9aiJ4VvjjvKm3K6OshP4v2RiI4gnWdxuksHhcA==@kvack.org
X-Gm-Message-State: AOJu0YwI9Lyru7nI2pRpjA55H2DP58opW48uvAscVpioxdjjSDRAzLQv
	nJneXEf8Gztn1YNS2sDrzwancKfv6h5WIFch7Ic2693VNMJQmcWM04wrBPbnjW6KNjsBB3i1esy
	ClDX9kt+YXCmY0IncMZ7ztS6r25tq0hiWbJvB5ZbxlHNPq6j41Osx
X-Gm-Gg: ASbGnctwEN4ZTcCDGiJ99LDMPiruCkyrdptSqBs4u/8kD8PFj8OKXU0n1WLGcArHEWA
	rgskg5YlQmr5L0FKzUi0deiZbsXqc/tSgGyFEULwRgloy6K7VOWEj5v58xNj7uCAY3YNFJkVxuf
	KnLn7rC57TkvgPeoEdN5o/VoiAcU6YWrl3t1tuyxwVM+HrYtxHgWKm4atYu/prjE1OIFEKYjIzU
	hE41UE8RfgMxqTQCEYdsb1VeM/GqC28E9r2cQVqrPT+MQl2r5AwR/CCExnZUUEq+fobhJRJJh5Q
	jgqM+5v9H+MZysnpBiagCpGIymrWdCGh0gNK7K9hSQSvuXRp0YXzqk58FNXARjKAb8VmufLsqxk
	QlNY=
X-Received: by 2002:a05:620a:4047:b0:850:b7ad:c978 with SMTP id af79cd13be357-8b4ebd9eb33mr3684778985a.49.1764614144215;
        Mon, 01 Dec 2025 10:35:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHc/IAOaSDf8i1YjJ+6md5JjMRZyr0e09X4B+I8m0ASlSLeFoGocESiXm6l1ZZbPYuAyWGexg==
X-Received: by 2002:a05:620a:4047:b0:850:b7ad:c978 with SMTP id af79cd13be357-8b4ebd9eb33mr3684771285a.49.1764614143671;
        Mon, 01 Dec 2025 10:35:43 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a69d1sm898568985a.16.2025.12.01.10.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:35:42 -0800 (PST)
Date: Mon, 1 Dec 2025 13:35:40 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aS3f_PlxWLb-6NmR@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
MIME-Version: 1.0
In-Reply-To: <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SfNhT0LpqNT9g8WBvuz7nANM0WG9QqJfFZrGhQK4P28_1764614144
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14B3240003
X-Stat-Signature: w5dytnf5f19np99mx3qdtmmk9cexp4y7
X-Rspam-User: 
X-HE-Tag: 1764614146-295566
X-HE-Meta: U2FsdGVkX1++kvXsqjNhN1DN6zq671MInoZHQX5I0sIEAO3SSP5AzjzLt+UcYRVJCjM0Ym8eeGlFBLQhxFZ9nBFC8mE5NvE3ZQOZllfvBrTl0IU6zWSHWK+bOCrvr/SBw5DxiCyDUK65OFp17PFnTPhXg2ejBFJmlNl9yjJFJFj5t8ZkX8BTchJUOYprebxftC89NmWsSrBEBbTaz3qhBLvxenmpHAM56Qt58O7XwBtVxPq8yEL7yPvSMGs16emVrBx3jM3SSF3t+gOIxEakWCZwg+1aqvJqHAI1yIOH0Y0aMqJMOMrDh3IZ9e5lvXfSYV2IyaNlWD4tzTieu7a7JP0QrUSh4JefOeMXvu53DFgvoW1+zUrJ2UQeoEfFnmc0cCgbZ0uRgnogIOTSEyBVnHzN4q2iqj6E/zPsnNMG5x2GAgXiH3iwvGXRKHOBO4VVmUFogs+/fgOoBP62kB1EKjSgKAbWKxHqV5TNndLBRWZWWyJAo7/kRJVsQYf8xRecrYpf0KGgYGa7JcT8SF+WNjdhL7p1h5u2hg+1rZu/38us2atI9ydWw4gkdKqnD8jZn/jXHCY+3lkYGdMTYN0iS5uUCX4B+SSSKfx5u+8CSF//NihGMknMyDKDh7t9cAF5w7pf4p7FzVwILfZeY5q0yVP3lAoAOalLKfxqIycZJUF4BA+ccAQtS6RYDl9yS9ly67ORwxqcNEN+ncXZ0o46uLY46/GY4+rAnPD9ER2OoJE2Qoq5yUlBxMkRVNmIbwS6L3LQqX2O9Maq1STr3Oz1FO4G93w4f8B/T8Pt9IJ37vcm9cNJc9mkX6uwSIF2MUKBbCbtocS52jZtTr3p+NXLA7e1B30U+i2yupYdH6K60jWhe0T4ZH1w7d3i+3LSaXUITyGPsE2i1bpeTMAKoCogoxhXxxL+l9qW1/jaBGlOrniLp7U0OzHxJPQmi7PMpu78dQxUNViRlb5TWFe4Lr7
 /l4OWcBJ
 +C/aTdaDjrrInjInwLJk5lmvVJyfOkExS2PbXtEKGBEO/8UrxguQPNkx8b12Kq/ZJk37LmTUCPLATJ5MfxHnLaI0oJP8B8ThlJy9h5bJngp7DaSifMgW2VRqyKtPDHi+FgYA+PAkS4bFV6MMmoM7K/7f3WFft7zhg0qAz/vTKq7f5QDeqr48eivO1vkxC/BpevYcyoAWj+Hk6znxNIR1nKshqvTJceFiraFJqYx21YJJesO8HDw1MVxjI8O4i+i3JIzdRdkiPVV7trT8tjg/pZuZzWfmUrtedugeAGVsFLiIN6D3SFwJuqxAH+X1sM0+9v2j7p9v82gSYeVtgcND4gZf+2XObLQ3IXbPH5fFwtHkva12Hvnv58i95sZhaBvAbVXH7Rq0E508JAES/FsC6BE2ISM28YCcX8CRafqCPF5/QLU5Rx/xbSf1AebrTb9rBqoc/SH8+ypym0QomcMIZGo0xT0M/fF0RWNHkCInBxA8GjPDz07NlUfTRNOinbnUnOpRIwzbI5Es1pKyRbigVK5wTJ8ML4QMJnZe+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
> I believe I found the precise point where we convinced ourselves that minor
> support was sufficient: [1].  If at this moment we don't find that reasoning
> valid anymore, then indeed implementing missing is the only option.
> 
> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local

Now after I re-read the discussion, I may have made a wrong statement
there, sorry.  I could have got slightly confused on when the write()
syscall can be involved.

I agree if you want to get an event when cache missed with the current uffd
definitions and when pre-population is forbidden, then MISSING trap is
required.  That is, with/without the need of UFFDIO_COPY being available.

Do I understand it right that UFFDIO_COPY is not allowed in your case, but
only write()?

One way that might work this around, is introducing a new UFFD_FEATURE bit
allowing the MINOR registration to trap all pgtable faults, which will
change the MINOR fault semantics.

That'll need some further thoughts, meanwhile we may also want to make sure
the old shmem/hugetlbfs semantics are kept (e.g. they should fail MINOR
registers if the new feature bit is enabled in the ctx somehow; or support
them properly in the codebase).

Thanks,

-- 
Peter Xu


