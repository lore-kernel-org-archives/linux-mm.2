Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4B2C43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162266B0139; Fri, 26 Jun 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1138E6B013A; Fri, 26 Jun 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028B56B013B; Fri, 26 Jun 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8616B0139
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:49:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC627140534
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:49:19 +0000 (UTC)
X-FDA: 84922951638.20.D56AAFC
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 005B91C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XEEyLeew;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3q8k-agkKCJIFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3q8k-agkKCJIFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782499758;
	b=0SccVFpwp1iwVZ8kPei72odoyAqq/PVe3ctZUpAcqGKzieA4WcI2QfhxaKP54toqDVBRZJ
	SaSgc2moj8G2+h8XlxXgW7ak2ie9we3VhkG3YoCAyA7rSMnUCjyj9Qa3oCvUpBOAYcUhaI
	Q+PhYxJ4D4r4DaaLZI8d+jJmCxLK3dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DYOZPc47JqTq3OBvPwgELKvYMpLEHI1RmYpvjUyG3k=;
	b=wkFcnJAHKdUAcTwRB2gzMQYPOBjd+hW7lb3RbAHjW4x7jdIU6SwkEyVji8Np6IZM6IjxCw
	mkGY+JB0+9AecZbtJI8wMxTCMUy30zlQdWaYgDhIgKUUNDxSebDcUMANfg6/z6Btef8RmM
	F+zoz/xCRAW/vJvEK+rZhlPBa9b93C8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XEEyLeew;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3q8k-agkKCJIFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3q8k-agkKCJIFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-697560b83f4so1328009a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782499756; x=1783104556; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6DYOZPc47JqTq3OBvPwgELKvYMpLEHI1RmYpvjUyG3k=;
        b=XEEyLeewyfuZxaTAnLGiO/abWfUGKaGA+WnRs3zzjbN+mG1a3UEaPxdbqmrfkdTO0I
         wyrHuthYUDxtFQ0o7J8FTYEXDIwO7ld/2VD5TQ6HBIYNnle7PILXBaLxnjvJzNYF9oVI
         QXGJQvFWu1R7PSwhQLI1sK8iHP63bQB9C0hhxoKI+KEabW+kDxPPfdgyVo6WEe46+vz7
         I1DKUm9GLNb3nQ9WX7ilSy1mJFCXChxFlmI+YArkjsjDjTxEZfen3BTCYY4u5iEbvKis
         Iszanv7UkkTklIOrbX4rgePLmP402YuPAgC/TpMTkadVcKd6GIeOBQmgUrNwbfDq8rS2
         FpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782499756; x=1783104556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DYOZPc47JqTq3OBvPwgELKvYMpLEHI1RmYpvjUyG3k=;
        b=Mcl0S41UsIliHXcDOcQlm0g7/r1PAIndvgVnDuNkpEG+VkgirNj2oxvHdn3E19J4jj
         75fjxUA5GQLhsx2PLmPCSk6eFsndmN/YChiCP2NXjuXlmlfQvmGNTw1W2FVkmoPsUo6D
         bi7nwUwoIqtMQEsdKLwlH6rBoqXF1fsjkHZe5alMRRsgux5b6Mp8adOGbVmq6GEXogBT
         dj5H1XRmvE9vXKLGyYviQGQJQusXQefruJt0lkk/XgMh+T4ed8Scs4LhTuJUTd3y5PdK
         d+tRQ+FPM231vYsWRqLeJfuiTFD2EIsX/ZsYLN8tFlve3LGXuMORK7dFVtSdb4x8vqaM
         kgdw==
X-Forwarded-Encrypted: i=1; AHgh+Rr7pVGKzFfBy2FRdbDiXY/zmvsByN+qDK7AIkrCFnw42Y8SPXtBbiMcR/gpP8XqcDfx4B5338vIHg==@kvack.org
X-Gm-Message-State: AOJu0YwPr3zU/F6OvHc955cjVHldDf0ZnhdUc/dUUkXi6E1+hLHxZQ2Z
	Nc0eJaXUcvjztdMyVdwhu2ksUhNgiSj/DQE2p+MAcBNi3p92lPbtVzpov/jEAAmkF2uYYSbEbre
	sM4ccNO9M+PtMTgCWIQ==
X-Received: from edaa16.prod.google.com ([2002:a05:6402:24d0:b0:695:9e2c:a1ca])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:280e:b0:698:3b7c:3b2f with SMTP id 4fb4d7f45d1cf-6983b7c3e1emr618285a12.17.1782499755827;
 Fri, 26 Jun 2026 11:49:15 -0700 (PDT)
Date: Fri, 26 Jun 2026 18:49:15 +0000
In-Reply-To: <20260623105201.3724592-3-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com> <20260623105201.3724592-3-tarunsahu@google.com>
Message-ID: <9huz8q81yw5w.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v5 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 005B91C0005
X-Rspam-User: 
X-Stat-Signature: nkgzofmopom4ig4t97p3efob53691w61
X-HE-Tag: 1782499757-752556
X-HE-Meta: U2FsdGVkX1+YsDcq2sMlHTcQFDiFefqp13sPqTCUrL3KuKABMr9yZwa3brbyF1V/0aSUDXF1qfa8Iv3zKtcl9WPsbAXmbxZY4dt7Q55ngCmERNw4cOZWX7YJLdd5zQY+OyoyiaVoZXEjH+Ci1GJ0NX7CgLnGSRaLybxOo9vauOGk0Me+6+yVToqaT5f5Kl8n4q8Uc3rtnwF2h5FYHDRnDz+eGvHYtIl2gwX3IiiXLW3p7wtaIZS7Eb+/02FywE4pD0RUrLmXnGuTeDgM2AmpJDkPx/W/xDhuAgNDwdoKh92y0bwVMiFNGZFquBJbHoGY2csenc2e9TfjasOfmd70J0T1Y9WnN+3QDZYKBZhHxUZYRaxlP6dVT/ce3jOHjyup/zUji/TFjTBjgUTJ3J8aWIgi/TSOVjD1XGMBSW8Tm5QRnQ+kmoPGVzepic20LhQ59nNVjG+RpEg1L85zB+MRNaT/MvbHskoa9Wn5wb7DUH/SqvcDFupoAzb5PcRqLwCzdcCMHHeKFdL4WIRuqTnMXiknnfgO8MkM39Q5gUlmdV96VL4jJiJ9i97broAELJ91pepr9bDxbQcm1BQnxXJ9FbntNjvGt7Tk2MfK4JYiarVvw/PupZsBO8/pCUYpfbtD4q5YnOmejln77f05C5r6iuZPFCYXDV5WcP870snY0NK6dqd47q9QcV6o2sLBtBB6H6YIp1ZoTfUOL2ktWSHBtXwsvT7dXDuHu73mfmJ5fZDbkew2+uDUXL+JWRgM8yfSC/8Qw0Ef99qgwOXcRHzKo/DQ7uhARwYSvAwXfVIOKBQVwIRnvSsics5BR9NrYSVbngeWSYua9YQWk8kaxz3LjMJxQIXe4Q1IjPMZDKVgCmWP+jufTL/qeCrH9KKOxdopBgHZ+kN5JSZ/RGoilp5EdGmivN8L9WFcj952z0Jckb+Q3oYfVr5NrUaqD82XmDMne1fBi9ttkaMxPuJYdzx
 2sdJ9rkI
 H6ae8eLtVR7vZyCV4ePBmECexKWlnNrAXQdGFNTu+w6Aqq4q5oDD4g1VJWAAbdiz1NYSscA2Jcwv00nEpM3hf4PjBu/RUAScmDpd/EYSXQ2NLfi8Ee9TSkuwVUIRgHVZM904STmKqsUpxymEUvQgb/lOhd04xu5z1BUGPc9Tz4i/ge1eSqwSDuQ2FYMjSzdi9g1Dn1iOgpyY7I7gwoy4nP9VDa+HM7q+/vcixiiWbczFf8eVJuCoryADw7HSSUvshBxXPV4iF5Qa4xuDv0qKDSyQYYyt0rEWwl9XsPO9b2Wvz2l6NYjwfvUspqyxyxiBQktFnCG8d4VZ5JKLYzm0xzLnZMnxsQewhHJt0G100mu6Sxmv6wl5CjgQyvFEZVwJLIly1H9VFy70z7pyn9SXiA2WJ+wyHYGTr/aXWngXpRf0/xBLksrzPZ7HHezaU0KfT5wgv5BtmUgCBFokLFHn82D54VXb3eptnD8Wgsf+zM+tRS8dkTOEAUqWPJ47cyxfwPygfnOkbBbLUDqD3ZFHqnQoBXzFR7JD9WEwkJsQQJsYsUBW50QlDNDYoujWgQLIJgj4rsCUf2uHDnGhvmtJEp3i+HWO5qW+1p2hk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


+mike

As per you suggestion:


	({								\
		typeof((dest).ptr) __dst;				\
		typeof((src).ptr) __src;				\
		static_assert(						\
			__builtin_types_compatible_p(__dst, __src)) ||	\
			__builtin_types_compatible_p(__dst, void *) ||	\
			__builtin_types_compatible_p(__src, void *),	\
			"pointer type mismatch in KHOSER_COPY_PTR"	\
		); \
		(dest).phys = (src).phys; \
	})

This is incorrect:  as it looks for type instead of var and adding
typedef like below throws warning in checkpatch : no new typedefs.



	({								\
		typedef typeof((dest).ptr) __dst;			\
		typedef typeof((src).ptr) __src;			\
		static_assert(						\
			__builtin_types_compatible_p(__dst, __src)) ||	\
			__builtin_types_compatible_p(__dst, void *) ||	\
			__builtin_types_compatible_p(__src, void *),	\
			"pointer type mismatch in KHOSER_COPY_PTR"	\
		); \
		(dest).phys = (src).phys; \
	})

OR we can add __builtin_...(typeof(__dst), typeof(__src)), But this does
not solve the purpose of improving the readability.

So I am fine with the original, as it is more straight-forward to read.
Typeof(pointer of destination) (typeof(dst.ptr)) and so on.

~Tarun

Tarun Sahu <tarunsahu@google.com> writes:

> Adding KHOSER_COPY_PTR to copy one serializeable pointer to
> another. It basically allows copy of phys val of the
> serializeable pointer.
>
> It ignores the typecheck if any of the argument is of void *
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 5e2eb8519bda..c1b61d875dcc 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -139,6 +139,17 @@
>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>  	})
>  
> +/* Copies one serializable pointer to another. */
> +#define KHOSER_COPY_PTR(dest, src) \
> +	({ \
> +		static_assert( \
> +			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
> +			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
> +			__builtin_types_compatible_p(typeof((src).ptr), void *), \
> +			"pointer type mismatch in KHOSER_COPY_PTR" \
> +		); \
> +		(dest).phys = (src).phys; \
> +	})
>  /*
>   * This header is embedded at the beginning of each `kho_vmalloc_chunk`
>   * and contains a pointer to the next chunk in the linked list,
> -- 
> 2.55.0.rc0.786.g65d90a0328-goog

