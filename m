Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5A3CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17528E0005; Thu,  6 Nov 2025 19:25:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7CE8E0002; Thu,  6 Nov 2025 19:25:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6E58E0005; Thu,  6 Nov 2025 19:25:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5B318E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:25:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36C5A160286
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:25:33 +0000 (UTC)
X-FDA: 84081917346.04.C766FB4
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 578FF1C0009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:25:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCHqbggn;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762475131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDrGyP4KsggNDtgfNXCVvLL5On0RJHEibXmC0ga7f1Y=;
	b=hdW5z8Qjjj/TmAufQbVAuGBPaj3mQM7Nygy8sbg6cJpWDz6AwpKAAo31TitoFuDj0++ShP
	sHepp6Z6lG9meUnZfSbYEoEMCP+8dbOq1uINi55Ds++4qxgl5FnfxbYWTMBde5dJjxFT6y
	XpceyP3sG+LcuqU2j9fz8x0HR3LFeNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762475131; a=rsa-sha256;
	cv=none;
	b=GMwwEsJuSZAIhVUQPysHqN+KS05xH5B9gzEUAIMSq4bHyOrHt8snH1XSnMKpUkgWpvJonj
	phq0EeBsjujkuwR2tpFd97WnV6lRBojifh9cPVZzRvgGTQz5E5BA6UGkbapWhayjtw7AHL
	SikPF7IGAUuQ9kufo8o7g5F3AV7N2X8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCHqbggn;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b22efd44d8so23091785a.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 16:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762475130; x=1763079930; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eDrGyP4KsggNDtgfNXCVvLL5On0RJHEibXmC0ga7f1Y=;
        b=QCHqbggnU0eiI0UycQiTFnHNPWyOiRUrp/g8XwqF4MwTxneUF4PatRAjVRIgLV0/Z4
         LXueJzWNWQlU7Pr2rvz0csNq4NW83/pW0auMYVtnGuxnXWcRI/KOvDuFl/QAglT4mZuc
         YH3gj8J/QtisprtWtM5mwSOfkTM7gW50xgf+v/p0s2nJGkscCO/lcZHvihhpWwYZsqeo
         rTsJgG9CZYJd3yXOkxQ9PqJCqt8zXBxDOXdpUEiG+VFFbCNNF5H8jvM9qYL2/DdqCCed
         Z4DRFpPBKNWUb/uz83i/wM3izqa3s/X33VV+GTVMDqmKWH0g89QJMxVrNS+Cfqurclu/
         naJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762475130; x=1763079930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDrGyP4KsggNDtgfNXCVvLL5On0RJHEibXmC0ga7f1Y=;
        b=Lb4le7PS6MZ7l3W/NugluWKLapgcaivamFcYrnmGPG7hLpheI+K8zYVpiRoh2IpvNr
         LloS2gkHQJwxCLEliiAG3nt7ouXku7ONZCIqPIHWVeAdqK9czxXR/HXc4dIVpz/M6vIm
         VyBSMu8INdb3C97wAf8Hff6YOvhSIP9+FBEXXxJtU9vrS35V9NWQcFpQd279JKndXOvm
         v7M/DZeVMbWd3RYKE0uJMRcoY1eUIL6AxZS0le361ie4ATYbRaA8EOgBVIuJwuKtf9Jd
         UO+NKySM1zSRyhSMIz8L/KpBNd6Am+7rQiTt5Q/fuaw+6LLDF8aFF/zf8NobhjrOq2GQ
         Ch2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWz+M36pPe8vJEDaZAInNoQJMs0/PY6kqREJERuf6GqKvcsUMsUiSJrwZYOGeP4AGmqGfKE6YheNw==@kvack.org
X-Gm-Message-State: AOJu0YxQwVS3VhO2U646xfE0H0iqOb5QoHxQA+Q/CFcS+McLd9rBcJJH
	hMQZ90z+76EhgDptsAhKJ1y4zCSy12seerd2fmbQ+uynOKdD+I6OMoi5
X-Gm-Gg: ASbGnctfHHt2jbSUJ0Yp4RDe8mrYO1iOBiO3ox4016puDQKxAgXD+g4XR+aeRaHggMe
	FIEoZqp6Cf/sFE29S5Qfqc5Bne076T0eopB0xCiqVmyufjc8DjnY3kdD7UAEJ0xzn8gAGm3hXc3
	pB8ZdDBOJAodU24qMbeXdUfoaLKfvGczZxkoYU2VddXP81dVueL6JOpOyETrnll12tbgQLEVlwv
	9q/wDGwjuMpDZzj3pRPYePEbgdaayCzN3F8XGZg48jd9DIoZoRuanOqq4tWgdmNHIWEL+nO5PXk
	c6ieJfqcZrs1KJ77wXcAq/efQkL641N7vLz81LxU20CUfPbKL9TmV0/EFFYUOjVm5LkPKzfacVD
	T2aUxhP+0Q3dhINuN4AVan2kdTpK0HE4bjJU54zh5rlSKM36yjarSuyQdDxv1UKOk7nTaZDfE
X-Google-Smtp-Source: AGHT+IE3wHS1UJmfiT2G9cUOC3xFxU6u/uO+VhHYvECIZct+pRXqPd9d6g9YleM22aR0m7kB5P9qtQ==
X-Received: by 2002:a05:620a:2943:b0:89e:da49:7967 with SMTP id af79cd13be357-8b245286758mr198236785a.18.1762475130279;
        Thu, 06 Nov 2025 16:25:30 -0800 (PST)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2357de61esm299869785a.32.2025.11.06.16.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 16:25:29 -0800 (PST)
Date: Thu, 6 Nov 2025 19:25:27 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/9] rust: cpumask: Add a `Cpumask` iterator
Message-ID: <aQ08d2NUVsIf5ukH@yury>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-1-984b1470adcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-rust-percpu-v4-1-984b1470adcb@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 578FF1C0009
X-Stat-Signature: yti3qn3kw984rzm5mdt3m4jeg51gwr8j
X-HE-Tag: 1762475131-634735
X-HE-Meta: U2FsdGVkX1/RjWVc/Xpvlj/J2xYUr+5cTi9sNh691qgCvgxYmrfmtUWiHlh8eMrosIyoZ2VZ0W4KvjEtgZ+Kq8yutVFahnZ2eHK8HohFeLtYgh9BaJOvrXLbagRl7513eexEcQ4iniSGHdV5Z/OkKioCCH4eNz59EcEY04+Jzb+VPCFC5aixKu2NuJfIPKG6mlB1WZYhmEJMfie+dYXufKFnTOCfeyWGehN9z8BHd/NA+yg4qt45lLiQ+zzOD0xQtBAJfkyDvReJpXKEuMGwAHYtPRwDyg3om20iQgvDbdXzlzY1PlUdpEBOcU5iFBaVgPF/zLLDZaQFpK9zfy6GXjrjOqCOi5E8VLxSHTAFaOpOl7fmxxHypjca3qc6m79PPMzXcek96H+4JnEiVMZSyN06PXaTBKtWi+V2/FVPprqlfYEY5vTD5yhwcStXJUhC3ZSj0wJWOZnOL1VsyWoqDDD+7pcQtyxhDLWuyNABi+HQMNQtmJYM3CfnNviVii21CMKjLqVIwsdU9wdF3SOwIy4s3/RTOC31nrHb8OGf2fOHNqrJdZJ6RsLizRZgQeIC4zHaP9NRbEIK3JOseQ4KPKzlkRuBIrsTN0FLRKByWE0XKhhQPSTa9/UhWNLlriWQeMHBl59WHjr7M7C0JIMfIyjcChOgRoGuw4gOS87QJU1tcraoaPhTBDGUnHzYBYqzNGcI/3hl7lNdiIGBZ+5NYDXbxvbdEZI347c+eAq5hnaHSHz18IRGdEfgFYyMLoSvBRQuKQIOdba4npbbQn4/g/txIAX/pgwVHy0lFjc2G6xOFwV+Kqqd6V7lUlbssUTLp1Nd8DaTjP6LUaKggrq51e1Qd7tP7kU7T0DjQRjKixzI17Nf1840S/VuuYOw8Gp4VHBcMl6ADUVnttSUdu/zw30ACfLMJgvblfVVT2KEN4RPd8DbBZtgnyOE3nSJrTCe7gY8j388O9lu1hwdwEE
 vlqLTaxc
 LKEazZJfu4oXAiMK4j5pKMObUmQP7F/f8XkPq8J47W3UvM4m3VxK9sXvTWFPbwMKCkd+GuOdkiuju9Qg13BARcYH2zS8focjKT4NAKkptRLhjJ27u7kGdp60sq/2TELhfp/BoKew8Xt9dc1Yc3rGdt2gRsLKDkq9PQ4F/s3yijsxBIMTLdYH5wuwNsEd4izIGFTw6u7OZ+EiY2ouVR6CBLwNJzlUCSRy+iATRXbpllJB700hHv/FPfqBokCEpB8/xcQA9l6pe98BI+2xvWC0AC3N7HcqH1zn42naYHJuvxwFO111j4oKwjbxL6zhqqScxI6Z1TWqQ1dxoHEV6s2fHRVRvHiTQv7nVhM6L2wNijij99Wiv9wP6/f1K0WRWhafyyuNEbJxtBbe82ONfoGKey7T+aaVPkd78Stm4rSqWuHG3v4nhTMRbXE/GHPQ/MgyJdGG8k03ed5ELSGitcQfxX0WJftlekv8g+HhKCzMJj6zhmqvNardy5EEzQ7oyfyBa4D4nawO4PGj5hzKEOMGFjbxCCrI6u3A816vCt6kYkmY9KJV8poh/FPLPCuolrp/YvIEZQSLfN7rPMhLajzxwPlGwf9M9iZacdC42T62nnpQZyvpRVPHmddSPprkdeGRJtEFWqt0kM61y0JBPmIAgrJVheBqUPGPmuyfQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 03:01:13PM -0800, Mitchell Levy wrote:
> Add an iterator for `Cpumask` making use of C's `cpumask_next`.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/helpers/cpumask.c |  5 +++++
>  rust/kernel/cpumask.rs | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/helpers/cpumask.c b/rust/helpers/cpumask.c
> index eb10598a0242..d95bfa111191 100644
> --- a/rust/helpers/cpumask.c
> +++ b/rust/helpers/cpumask.c
> @@ -42,6 +42,11 @@ bool rust_helper_cpumask_full(struct cpumask *srcp)
>  	return cpumask_full(srcp);
>  }
>  
> +unsigned int rust_helper_cpumask_next(int n, struct cpumask *srcp)
> +{
> +	return cpumask_next(n, srcp);
> +}
> +
>  unsigned int rust_helper_cpumask_weight(struct cpumask *srcp)
>  {
>  	return cpumask_weight(srcp);
> diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> index 3fcbff438670..b7401848f59e 100644
> --- a/rust/kernel/cpumask.rs
> +++ b/rust/kernel/cpumask.rs
> @@ -6,7 +6,7 @@
>  
>  use crate::{
>      alloc::{AllocError, Flags},
> -    cpu::CpuId,
> +    cpu::{self, CpuId},
>      prelude::*,
>      types::Opaque,
>  };
> @@ -161,6 +161,52 @@ pub fn copy(&self, dstp: &mut Self) {
>      }
>  }
>  
> +/// Iterator for a `Cpumask`.
> +pub struct CpumaskIter<'a> {
> +    mask: &'a Cpumask,
> +    last: Option<u32>,

This is not the last, it's a current CPU.

> +}
> +
> +impl<'a> CpumaskIter<'a> {
> +    /// Creates a new `CpumaskIter` for the given `Cpumask`.
> +    fn new(mask: &'a Cpumask) -> CpumaskIter<'a> {
> +        Self { mask, last: None }
> +    }
> +}
> +
> +impl<'a> Iterator for CpumaskIter<'a> {
> +    type Item = CpuId;
> +
> +    fn next(&mut self) -> Option<Self::Item> {
> +        // SAFETY: By the type invariant, `self.mask.as_raw` is a `struct cpumask *`.
> +        let next = unsafe {
> +            bindings::cpumask_next(
> +                if let Some(last) = self.last {
> +                    last.try_into().unwrap()
> +                } else {
> +                    -1
> +                },
> +                self.mask.as_raw(),
> +            )
> +        };
> +
> +        if next == cpu::nr_cpu_ids() {
> +            None

Please:    if next >= cpu::nr_cpu_ids() {

> +        } else {
> +            self.last = Some(next);
> +            // SAFETY: `cpumask_next` returns either `nr_cpu_ids` or a valid CPU ID.

Now that you've handled the no-found case in the previous block, the
comment doesn't look correct. Can you either move it on top of the
if-else, or just drop entirely?

> +            unsafe { Some(CpuId::from_u32_unchecked(next)) }
> +        }
> +    }
> +}
> +
> +impl Cpumask {
> +    /// Returns an iterator over the set bits in the cpumask.
> +    pub fn iter(&self) -> CpumaskIter<'_> {
> +        CpumaskIter::new(self)
> +    }
> +}
> +
>  /// A CPU Mask pointer.
>  ///
>  /// Rust abstraction for the C `struct cpumask_var_t`.
> 
> -- 
> 2.34.1

