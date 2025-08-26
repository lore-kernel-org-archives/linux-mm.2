Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EE7CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232FF8E00E3; Tue, 26 Aug 2025 10:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC4C8E00DC; Tue, 26 Aug 2025 10:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0840B8E00E3; Tue, 26 Aug 2025 10:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2B9F8E00DC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:06:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DB051A0135
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:06:20 +0000 (UTC)
X-FDA: 83819083320.11.9FD742D
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9870D1A000C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:06:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aZ3dD4Ii;
	spf=pass (imf19.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756217178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlKAEubDhdWXLTp3RgKe1j2zx0nuB/WOtFKlQ/1PMDc=;
	b=QcJHnEEvpCmCJ/LievZ4W7IvJFg7E97BGr9/0YYKr+O8KRsk5ZcICTlF5nyeWpL0plKejK
	V/ZzIKIF8g6tK4LhwOZhz4xZcLYdCVfi/LY3x9cefPjnzyiX5rKaWCBZRvy6m4nfAfs8nv
	XsfKZXzzG3EDEDOUzsVUi1ShaSGeqTU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aZ3dD4Ii;
	spf=pass (imf19.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756217178; a=rsa-sha256;
	cv=none;
	b=FIP9ndtxgxqf/rpBEyfSmU/AUZSH/2+WtxHctj2+QCyxSoGPJo6gCjb/0A87XQuPX4CR4A
	UirA67pZOdkayHu9PwzOrjVeW41cDOFHrNZR+/76GhLPnlHpsj+H2eT4/cHNXesaS3Yti+
	AT2VenKB1aWMDcTUuhBF4V8NcFPR7Yk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3c79f0a604aso1682275f8f.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756217177; x=1756821977; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MlKAEubDhdWXLTp3RgKe1j2zx0nuB/WOtFKlQ/1PMDc=;
        b=aZ3dD4IivZbEKo2F6EfbDLUJiYfKxu96BQYVlCdvleC+RVc0C19+reSDT5asS1nR+M
         /H30n4MTdWwjH/P0MgWbLHhlSSKSYQEsHTnthu9mY1CB6rwcQ12MbJmwaAvTD3NXWgm6
         8AMo7a07IAU65QWEkVbER69kOt7xEstwtylDWmUTTUNQQtZXS9GfzDvU54riLawZ6mBc
         p+yuEPfZqqLKt02xvQRj/zOjrDCdaFg7ji/vdaIuWj6JK/4LNvWeCAz8IBqiTqlGTZbK
         MKqbGnJOhRdS1uEoBpf8SD5f1yXpzwfiJS0UzulbVVWhGPB3pVI0oClFbUwyT887jxQi
         ZIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756217177; x=1756821977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlKAEubDhdWXLTp3RgKe1j2zx0nuB/WOtFKlQ/1PMDc=;
        b=a3301t18rPxLwis72RmAeFPKQjqbHyN+vqN9xa4mwWtKlR8pf2Y4FnWQSh3Tc4YQ5s
         gC7Ut0Zkwr4CZMuW8AHN+7dFBclNA7zdEyJdS7qUXb6MjqwPA/eLf9QXAsKLiC983iVc
         HzetvddfyM45sE5jw9T2KQ2GEWDTmh8mnWa5m/zvn88yToYRBTKB+nqB2MAe0KGGl52o
         9QzY+rFbbOYB7afjoyZDnelb6O0baZXpTxZSLY1G/bBvXcvtZ61jCXvZYyFat2BFR4bz
         7XWduQoGI6UBHt5Y2fouRgcz10iArStKMEEDViLvcGFFlWxB2t3GNL+vVHNFlYiaO5/l
         KEKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjSbnRPPUVywTieti7kAIkPKieKvvFTDhSGKEfQnCiTerXxf0IZ8f59NYNdE7Q+hF0grv4rUaiBA==@kvack.org
X-Gm-Message-State: AOJu0YwBQ559w6me8UmMN5SFtwFT7ceaxNmL36oHmiPY529m6rw0KW6q
	qvFyPXcIG/aEg9NXmGEWCgbVND8E749Vq104RT1e7jIBF30ffUDwcE2D
X-Gm-Gg: ASbGncvYZ5J2R1ehR1ylmA+eg8In4Ubytk1Jdj7RnpjMrEruO6Et/7N3xqqsOqynYZ4
	Bx5zWwvFaykKejOVvA64onMXbSsAH6YPLDocsgH9rm9HIRT5Lm6nzgqdoFHdOwpLRnf3cuPQe/v
	7lkCIxA4TGfBiIWC5JZy/7RUvz2SioBAeijmrKVvP108cZXE0TX28TVoKj8PtZ8GAv++AiVywnP
	cUPWEGsB0yI60ujuQuRkEE7QRMHgulIk6tHrA9y5a40U5ly2KNjMy3EwBfcWg0Tuu+WAWjrNVlO
	Pm+bP+dtLmrqy1yWVq2B84gNlNz2lG76jYvXNx94QL4h5+LJ6Mq+VzySW8VRVvBf/PzCO/teHMW
	MLWmx8UImBQLy+CsRUThQzy3WEXMiusgUjAbi0cE=
X-Google-Smtp-Source: AGHT+IG22gPI5488uIPs25oszBDX56Yi53KPVP8VjvbYnpIG7qN6HDEcXj2kkT7vF5pcH3GSgehc9g==
X-Received: by 2002:a05:6000:1446:b0:3c7:f0fb:834 with SMTP id ffacd0b85a97d-3c7f0fb0c5amr8807636f8f.42.1756217176808;
        Tue, 26 Aug 2025 07:06:16 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:54::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c712178161sm16263514f8f.67.2025.08.26.07.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 07:06:16 -0700 (PDT)
Date: Tue, 26 Aug 2025 07:06:13 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9870D1A000C
X-Stat-Signature: o8grx1xk9aqgyfa6an7cojz88yaij6dm
X-Rspam-User: 
X-HE-Tag: 1756217178-34045
X-HE-Meta: U2FsdGVkX18MEqCfnZA5n/K49LzAUHZlbmRj97ZesjGjKw1YjJXV9byKOwuvvEiVLvM3hcZgQFegMwzkWx9oSr5uFKzowxlF34gfy/I8Nht8z1u3d/EVd1+MoSaA4TIvbstm/s09PW7Xwwi5OkgmXedPmp0st7nnO3vdKr95YtoOYsrimg+EEtDhAOnaxiTvp2gHk7QIUdCeYWH4oy5dQ7DS9QTAKeGSDAbGXuelO/i/gNVxOVSpvx12D5jwNFyod/JVoowos+A+n6QhL5UHBiClust1XZQ+q4uCWW4v4Hxj4VeLmq0qEh1j+U2BDJBMVQqiuiwfCC+1Z31At5rSRCpfubyBcINDsSqcopWCcWZEZc+BthFn1DS/KUDxY3feLxboiyF5cNFoqxmBUEQD47ZlElzPz4JVED/4dN+mtEyVklyJEuI2fvKCw2tVmB/lcgYIJKFST+DLweeYwTvkdq3rF8tliUlZ8v+33NmfTNG0SnsHgI9RhDh4wUWpKM//+aptskZKnfcnh6VLcE6QpJwFFzNe2WRdJfzCrI8Dxy5bfIj2M1NL6UgvLnZk9+dSpUC4K3VDN/0VefJ3yPampkwg1ZeqjlleLFiK83YGt7w3GzD5ZtUfODqvxzvOtTQRmbMQRWle4Jlc5meqHCRvI5DPt8rkfQL8m+9+Nbzk7+QbRxyMoOvyPgFhO73NHyl+og4E8HefhX3VxBK4Zd6MAci/eejiuS24TlMd+PWHQbYkry5eP2Ki64NR4Doiuo5AtV21CvEL6VVxddg4BFCtp6VvrSEiO9vVrWKfxPut67bX2KWKJPlWjeci+lTRI8OJFnvdjLy4pqn88VsNmvxJvAeRpuPpr9Z/a6Hr7D5FkZDaZjPSNoo68e2x45guaBaa6WRXulYXxJuNtkIkF4R4QE6F/uezUBF1uR4DmnEsnNTIkU/2m/H0AKo/s3oGr4yYSyuOdVtP+aaLZobcGvZ
 0Q2okjGp
 VOecRE8LNkTei7pgifrGxnnJgKafLXhTOV2AD6ZcvqLT+QvPPA4I2VKUJj8hndTe+yGlgVDkhnMB58AX8FHtJNtwL6SV3QpnRW/lCUdy2YuoPN6ELB+2nRoZ76wFkbum7iNe9akdtIbrSf/jKn2KzIRhcHzec/SCuIBHWO0eoY8yOOguaiS9jWeypD/lZyPd7mga7X7hQigCXrnCaxAjXZ/3o+pdr6VjSsh0C2U8Wk9w+bUFlU2Ab1rPn8P9vFn9e4+FGPDgtOUwR090XcdVU53fmfIUZaC6223CvMlp6BgVn8cUJuy5ixXx5+c5HSxnMDjR7oxq9ItftOiJXYo9gH0J5hTMPztmxcL8tRIbA0kuKialI1iFvwoJPJW4ypzZCLGhVRv3DeM+xCjI3T7EVWTqOI17ACo8up1eOfpQqfgSPlcOzj6HjAVC7IMxYM9JETUB3rFcscLnvwo5Z3dxdWpaiuTnFMHj1r7nZQ97EMxiYKlN/gKLeBnFHig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:53:03PM -0700, Shakeel Butt wrote:
> On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > Right now in the oom_kill_process if the oom is because of the cgroup 
> > > > limit, we won't get memory allocation infomation. In some cases, we 
> > > > can have a large cgroup workload running which dominates the machine. 
> > > > The reason using cgroup is to leave some resource for system. When this 
> > > > cgroup is killed, we would also like to have some memory allocation 
> > > > information for the whole server as well. This is reason behind this 
> > > > mini change. Is it an acceptable thing to do? Will it be too much 
> > > > information for people? I am happy with any suggestions!
> > > 
> > > For a single patch, it is better to have all the context in the patch
> > > and there is no need for cover letter.
> > 
> > Thanks for your suggestion Shakeel! I will change this in the next version.
> > 
> > > 
> > > What exact information you want on the memcg oom that will be helpful
> > > for the users in general? You mentioned memory allocation information,
> > > can you please elaborate a bit more.
> > > 
> > 
> > As in my reply to Suren, I was thinking the system-wide memory usage info 
> > provided by show_free_pages and memory allocation profiling info can help 
> > us debug cgoom by comparing them with historical data. What is your take on 
> > this?
> > 
> 
> I am not really sure about show_free_areas(). More specifically how the
> historical data diff will be useful for a memcg oom. If you have a
> concrete example, please give one. For memory allocation profiling, is

Sorry for my late reply. I have been trying hard to think about a use case. 
One specific case I can think about is when there is no workload stacking, 
when one job is running solely on the machine. For example, memory allocation 
profiling can tell the memory usage of the network driver, which can make 
cg allocates memory harder and eventually leads to cgoom. Without this 
information, it would be hard to reason about what is happening in the kernel 
given increased oom number.

show_free_areas() will give a summary of different types of memory which 
can possibably lead to increased cgoom in my previous case. Then one looks 
deeper via the memory allocation profiling as an entrypoint to debug.

Does this make sense to you?

> it possible to filter for the given memcg? Do we save memcg information
> in the memory allocation profiling?

Thanks
Pan

