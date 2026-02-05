Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B871EC1E88
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5856E6B00A6; Thu,  5 Feb 2026 04:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533546B00A8; Thu,  5 Feb 2026 04:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415126B00A9; Thu,  5 Feb 2026 04:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCAD6B00A6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:54:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AD891402DE
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:54:49 +0000 (UTC)
X-FDA: 84409943898.30.F38D85E
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 738FD10000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:54:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TPkMESn+;
	spf=pass (imf14.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770285287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xBIY0mav+3IAaN2sDOZsKW4O0cnUlRHLSnJJ3/BuhM=;
	b=NZ3BaYVuAV9W1dGF6AJ/wxJUG2u0Cp7OryOgm8zEg9jtkYLvFhOmRmBwC+a1YPwIOwN82i
	RZb4uc24NBwWfN3fdElGDuA1CHUHYZnWCoZliG0FUqHdBv6H0xRseu8Qgb87EID9emETS2
	ssy4HopDh3y2KlVeES0b19DRnIAh1/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770285287; a=rsa-sha256;
	cv=none;
	b=xWUozLAj87UKZro7lwxsaF9f3u/55E6MNfpYaMxNs6PIxjDXvTQSWmT8KS1CSatCANV4/n
	6BFlxZ17HqWrlJj5QLoE0Apsb3htwEz5KNqZesuaWarnJXZ4ftdPr0MkX96n/KV9KMYb1r
	ETNghq2+dAqyxMmIo8dMB/wwRsTOjbQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TPkMESn+;
	spf=pass (imf14.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so596515a91.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 01:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770285286; x=1770890086; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9xBIY0mav+3IAaN2sDOZsKW4O0cnUlRHLSnJJ3/BuhM=;
        b=TPkMESn+wg5fntQ5eIdHFrGbz36UXaecNPVWhCEil5cYwWVwWRwEnk8i5/6SAywQNf
         kVdMiwTWkAMnQg6L669bw4nNZoBYfPanhDta7WWNGMXoE2Kee9w7zMxYDtswExpIaun8
         k8ESM/9ipWz8foEe//wKpdDZqb/3A6yBSiQwDgNKDjEIy60ElpAcW6hUF2FaWV5cTJZ/
         xm406qEvLUmpauzmEJBAdPkhDXR3U7t7TTqHLunFJlHtPmr00G5YDBny5xi5sa9iAGJU
         jwnpgO9cKKCgg5QiLfGwDv9kENczgvTdcazbMIQgGfReMiOHHekcjNpybBPUuNsFMUrz
         5Guw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770285286; x=1770890086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xBIY0mav+3IAaN2sDOZsKW4O0cnUlRHLSnJJ3/BuhM=;
        b=u+9MX8MFPsBOtB+CcKzN7+Qb1pyY26teROUaRXzBlJNxiDm5241Q636WR5CwQ2vPDr
         VQU9dxXUDd2GdGggfwp+Fo/0Si4uUgk4pfgf6XXrfTCa+SOVcxfLt9QHzd1dDpvtbO3k
         dgxNxlEYfNw0FVPVo3XZy2uSXMKm1FrRZA1ieMo0Lp4q8Kl0oiC6traQyx81JctqHvbk
         XJ1YghhHpmdrEWfZSoBx/5d227YyVuEiL4ovO1lBNV6jIFjLFpuZahL4i4j2CfHS0IIS
         2qvlTNhhglb4y7CPsA9eMDpbMjeajEu4s4rbMtIPaTe+JyzCGjL3pxVhMpihnUVe/kVN
         zT6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbOC2sDsWJlzYn6g8kWX3+0c/UkQmze8IGUnNwAcoT0UnMsHttM2FUGzS6mDOQ28YCJAE7NxSHtg==@kvack.org
X-Gm-Message-State: AOJu0YzfNPkeZs5HPMkV248Ih+Hu6voOp8pqyFfvCs6hg9s70PnMFEsr
	MI0H6m/7mp1JcG3cU0sOfWwuqa7pXDQME0XwxrMLzCIq5Cg3Ccfod87OYjj5jmOyUe0=
X-Gm-Gg: AZuq6aLleuPc1wHp+bT4NPBOP+eIJJbHBNKckf6PHHHldJiHHMjoKIqW1AnDGQCR/Ty
	AZtV4nWEdjGndD71uiWALt1b/1Jyl4eoWj0dv/Jrz/4ZbFrRpDqJMxQN1fRqrj3fr7darCEBYUM
	TadM66eCjEzTFf0poaYhnkkYH3hfon1379RmH+rXh3aiFMrGum5nAcEPyhA0ZJdhMJt5grms5t9
	dGq+MhNEwLCZFpCHWH9tyKdD1g6hiXGvjE0b+laaoeQ1Qjzbbz5426ZXttvNcscvReBAOueEmuS
	LVnn6u7iFfn61Rm+tJt748YJvmeHOh+8Tn3NNCrWUVZ/CebnOFR+V5W7XNje8puW41XlLBXUOjz
	8hQG57sbGHZ6jH7NkbnFQ+t/j/HMr2Mc96Bc0c0MlsnNGvy3+89qJjs6zGlGwT84XiztFgZ1joH
	EzUU5eqG87Kag=
X-Received: by 2002:a17:90a:c110:b0:354:a05d:9dc2 with SMTP id 98e67ed59e1d1-354a05da864mr1522955a91.9.1770285285886;
        Thu, 05 Feb 2026 01:54:45 -0800 (PST)
Received: from localhost ([122.172.80.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354894533dbsm2000361a91.7.2026.02.05.01.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 01:54:45 -0800 (PST)
Date: Thu, 5 Feb 2026 15:24:42 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>
Subject: Re: [PATCH v14 2/9] rust: rename `AlwaysRefCounted` to `RefCounted`.
Message-ID: <xh3iuwlz4wapmgzojg4v3sen4oezfua4vsedskvrqhc7ryyclj@jggikwra6dmj>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-2-17cb29ebacbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204-unique-ref-v14-2-17cb29ebacbb@kernel.org>
X-Rspamd-Queue-Id: 738FD10000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 73n17ekw7h1k5ywkpffjk1okne5p6f6w
X-HE-Tag: 1770285287-900033
X-HE-Meta: U2FsdGVkX1/Q/vt1tGb9bv+d11SniIKAUBSb+FslZ8VrfplN3wc0HbYB1tb0yp4hiEp8GZ1C5EG4h+6vd3pMBKfhwhr4aEvDNwdLBDaNTlM5K+jWceLKKTl476tyW2io6/IAEXJAn1GCUjpMknbRLw9sNoTWIQQ8lpRIH/Q1YjTqRbEHwY+HKJg4N6O1MfV2myO8Ln161xR2iUkwHdfI2KliGZOW9NGCy8hUbQ/KpdJL4lK2K1+QyVD+Mw3Al0LAhdWr2KoPRrIZ6nRyrM++sLu518fzB9T1Rf5usOrekn7/4Qs6tGGmIfZe2FkNwinHoIWHPTMpeExgZFIUh5i4I5zGBWGNUGIh0xqk9y672oUf4wKczgT4GLwwCu8cer5rlalZ8F7vQbc87K8o6NMqAF8mzM++X6hA7tVXy4HOv9bQhU/AsRh5qnzTMkrFfbOI7ncQKTouI9bVz7oilsBEXSZ3YpxeSojF2fteCNGGndv0yJqenguM3D/8dN9i66VEbIprvWcmWh1/HsfuKP/g8If7ZWOec+QteBcxmAqhorTXTeGJ9O51+5XVIbJG6N5GN00c7X3082BEkvZQUWX8/jGfTLYDY0ct+k4xbD8NEqYWfwbi4QKMJet3DPaFkppVIZe1LvuFWoOr3Y7waOloIGLT3FtucXjyNUfsdpVymAlodbHNZ4c1HCw48PtgH7zQ8Oj9KndK7iC7RD1D5QQYqpHsvwKBMd4sGk9K3fevOZiM34YPfit8HsFd2Ui7pA/W3jWN1TR7RQuSI55cyAhjrIC0WS50euFyzAXmdBQyI55NU7L6A15SwwTd01v8p1R2tk6ag9kz7jCxFnjG2CUCXEBwsF8MJrpzWUk3jg6Gw3vbEooppmBy6iEA40CIqSM43nYQNRu7MaaZkyTePU/xKEZ6g6O+uFfGyPs0tXdEJKcI9fCcR6UA4rEJbN8pS2lBIgrZAqs5o2RcdlIcLER
 jaSUIZv2
 0IvTr45EYYxCCRVFo6ytM1xI+zxwDGo0xl/hlqk3Wm8gostE3hR9fC3+RzA5fmiRmfrxToxqRO9ZZ0YhzYIBDoiyFL4fMmuSKm5mg5biuCg0HYyjySDzq/TKFEiWde2ZCQ9ZpRhVHuPu4tNcQBpyByKw9vxTHmzswRMutqCLd7oU/3EA86+TmB/g+S4VPCVDPmL6fLSCDG1MD0EeoY3dPI2zzKDLGHV8YML5zTixOQRt7Txj2XZSYUd2B4wrkCkfrd1OQoh58kNuDozSTU7QsJEHXZonOqdse/NCQKpt4sdOkFm0pPsj/20X6lE6pBsoz3TgiNqGEa19HWSlit2DrnCDkEnIbGyNN8dbD1FOWqtQNxQUVnbvK6nE8EH2TstKTm3mSzc0dwd62J87RtE6sZyTmHgGzoYmneKj6rSh87pWlTZhqMoTxbPGJEKXWOppLkT+wLRK5bYgYhSDjZLH0LpHkSxVJOWKAocpEjImXjZYPMr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-02-26, 12:56, Andreas Hindborg wrote:
> diff --git a/rust/kernel/opp.rs b/rust/kernel/opp.rs
> index a760fac287655..06fe2ca776a4f 100644
> --- a/rust/kernel/opp.rs
> +++ b/rust/kernel/opp.rs
> @@ -16,8 +16,8 @@
>      ffi::{c_char, c_ulong},
>      prelude::*,
>      str::CString,
> -    sync::aref::{ARef, AlwaysRefCounted},
> -    types::Opaque,
> +    sync::aref::RefCounted,
> +    types::{ARef, AlwaysRefCounted, Opaque},
>  };
>  
>  #[cfg(CONFIG_CPU_FREQ)]
> @@ -1041,7 +1041,7 @@ unsafe impl Send for OPP {}
>  unsafe impl Sync for OPP {}
>  
>  /// SAFETY: The type invariants guarantee that [`OPP`] is always refcounted.
> -unsafe impl AlwaysRefCounted for OPP {
> +unsafe impl RefCounted for OPP {
>      fn inc_ref(&self) {
>          // SAFETY: The existence of a shared reference means that the refcount is nonzero.
>          unsafe { bindings::dev_pm_opp_get(self.0.get()) };
> @@ -1053,6 +1053,10 @@ unsafe fn dec_ref(obj: ptr::NonNull<Self>) {
>      }
>  }
>  
> +// SAFETY: We do not implement `Ownable`, thus it is okay to obtain an `ARef<OPP>` from an
> +// `&OPP`.
> +unsafe impl AlwaysRefCounted for OPP {}
> +
>  impl OPP {
>      /// Creates an owned reference to a [`OPP`] from a valid pointer.
>      ///

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

