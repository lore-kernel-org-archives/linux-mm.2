Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6BFCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80AC8E0002; Thu,  4 Sep 2025 17:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31368E0001; Thu,  4 Sep 2025 17:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FAA8E0002; Thu,  4 Sep 2025 17:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBA78E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:46:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 190F011A477
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:46:08 +0000 (UTC)
X-FDA: 83852901216.18.CB703A6
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4389DC0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:46:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YyfXPI2U;
	spf=pass (imf22.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.172 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757022366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dxmIK87Es6+ed8yKW7yiT6uue3ZfsQixPgvt43/STU=;
	b=XIdPJwsrBV7f3uTdkocSQcPu4t5HWt8p6rtQrqV2U8Zz0+w2qePzs0RcJdxtnWRd/mzAFO
	SrZiCVrLgwmt8q5IZLTpwQS2FpgUJ3mckak4wrAfY2etAqbSAS9kiud6YHnlDDIqGWSzSH
	7L0I4N/NB0/5TU/Sk8flSOBisBa0A2Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YyfXPI2U;
	spf=pass (imf22.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.172 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757022366; a=rsa-sha256;
	cv=none;
	b=Ha0Hcv90Cs1h43iDQ7IB627CLtfla3fFUAzwpzoWFa2+dUAuc5N1LzvA/Hp7fDgRO3g1Ox
	C2/ddAE6obS03jWmdG0EwO9A2jJzRFUxpRBhuedTsgTQ625JdttWwNlTgiKD4z6dBZTaNo
	GHr9/gxRe/Rg/cWsUe5pp/lj6UbBvwo=
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e96fc00ad79so1478890276.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757022365; x=1757627165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2dxmIK87Es6+ed8yKW7yiT6uue3ZfsQixPgvt43/STU=;
        b=YyfXPI2Uiqf3c8J0plxH2pzSJNv7HAjum7U8h22ZgZLCbqfI8K86Utcz6qp4Nnrby3
         spnJxVjDbyowsDLCkVCX7umvcOvbrv/orj956mgG1bNiQc0C8gTVLBq2xBWICfVQpy0X
         G/jNRz1w9BhNAA8xI8YuhSMvtC2ldA6rsIQ67LNBOUnPyK+zEV3IE6G8l9fPuAQufUur
         583Pi61KsbH5/Ajpm5aINlwMi+jEVoHRTCrAJd3naBF05t9bPzQuchlWcBo9a8TDyr7L
         LCECSK+VzfVe+TyEbMjVsoY+mg/jJ2WtgH34jTEKpwkNiTiNSrgp8+LrIg+Dwc8LZFOG
         QVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757022365; x=1757627165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dxmIK87Es6+ed8yKW7yiT6uue3ZfsQixPgvt43/STU=;
        b=tPg3DT5rKcCQC9L4WiWf2UCXedYrbdBR27K4oxbnaR1kAoOOXpY2+0jtGk/JBx3gJl
         WLegZ25nQWcjMxnfHS6KhXQYgYka/2FT0wozOMGYae7w4x2jQ8crrADC/fRxHy7yZzxE
         VH5kURuR4k7FJaA8fFI0FQ++3KRM57hlGggCw7cp/drCDSnYqPLx5uGcGrK0bOSZ9geJ
         R0SOptklh1IY6SCKEMn0MnXevwwsKuMSOBpALdg8l5BmuJPNPO0cORbTdslea7jTL9Om
         StQVq6r0y7i7Hc66EsBPzzJWgIQf8ifi7IR8ZTNyNYjf2IPFDpEgq9XgGDvUX6fzRaNw
         tlNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB169Zb0m3ns/tpHOOL3LT13abkzqBf3mlzNFaHNB/6aNb0VYRkxfJ4p9fHRWUguBkXrSZu9qwcA==@kvack.org
X-Gm-Message-State: AOJu0Yxt/uV6IVjV3Gv5wQiKJ8pFOkbBZyJZVDxkjw3bEn1jwPDxmZUV
	Lm8t66XI3p0blXngFQVxcwr16hul0Af639TRPxK58TAzaNQRdh4upSEp
X-Gm-Gg: ASbGncuyJsg7tNI0ZB5TZDUk+eEgCY13xwlsA3LsWhpwAyIMjbCLTTVDDjhOynpYQ3u
	4fAmyBY95SgUoT9RjS/V+8eTPo/sMX+o6yeHmY9+bRMrVpWgtUJ8HcHm0F9bGfDQV4kDGIgwRCM
	TnN0cLObd4enF+j44DEe3i/5Ghw28c4WAVGeBOS9lbqAZMwDvdFKm8QsxPTmSFlXPr7Sq67FRlZ
	W1w7C1t7Au9JaZAAyUkj3blMp52rk35F3+T53+lw4RTnTmSajQBhpypSKo66DISW3F3x5Fj5hkl
	2i6XgIbKnwqJ+4px4obqDAZHqOFpubtf3YaCifO5hOfG2QlKade+US+tCka1kEqrGUNNP++qMhj
	LLp0u7NCaqjTRFPRNOsfCO1cqWNKjMTht6PawtNhDz0A=
X-Google-Smtp-Source: AGHT+IFMi8TYlY3AfynFMyr7MO2wBtRPKgDfu06foXlotOWPPhYh6f2Czm6tvqNfbPzn8j5BUU9pJw==
X-Received: by 2002:a05:690c:61c6:b0:721:5b31:54d7 with SMTP id 00721157ae682-7227635bbcfmr192690397b3.7.1757022365134;
        Thu, 04 Sep 2025 14:46:05 -0700 (PDT)
Received: from localhost ([2601:347:100:5ea0:1218:85e4:58ab:e67f])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-609d205c24dsm632727d50.0.2025.09.04.14.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 14:46:04 -0700 (PDT)
Date: Thu, 4 Sep 2025 17:46:03 -0400
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
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
Message-ID: <aLoIm94aP6Er0Gn8@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
 <aLi-7W21N45fBGJk@yury>
 <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com>
 <aLn4bopPt8uS4d1O@yury>
 <68b9ff1c.050a0220.35de1d.11b7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b9ff1c.050a0220.35de1d.11b7@mx.google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4389DC0008
X-Stat-Signature: qc9csaw8iz6za6gaen85938tu9js9cef
X-Rspam-User: 
X-HE-Tag: 1757022366-678365
X-HE-Meta: U2FsdGVkX1/pSHxsT9TPfvS7ZibydiUzENd5wCDuiARDGQnE8vZ5xEdQZlwARLQFC6PQ822LIp70+psFu/OQrBxP1n8UeFkLfiAYCsXOhRraDCAIBK7P0t4VzxLSj9CSNRTkM++EL+pJ1Z3NXRTSExfHVI6a04RTc7TGwYV1XJzGdOzwoYfu+9aYf1nNo73h8xBZW0o6M3pmJzhHKCnik923kz8V9QPMmOp0B0hLgbcHUOr781l4PvToJ50rNkDY3ULsflelYC1F75TVhm9tms9SCvKenYf3SesJ7ciZ2+F99s9+i9iJ1jIz6BGnpXqGiz0U0k+2b0VGSffCi7HccZrUqRD+wwzR6p7fAbnhMRYcnukKq9F2IikydVB2XRB93F2kWhsymOs14o4gy0y4Wnz9fm1FcQ2+gcv4p9/8BQffQmkDhRTo6j6reanG0h/d4LYvbQSzT3rfafJhVJSwbQ2H0iLxgCKfPZcaFF5TCDj/HVDInUQnBtnrW8zyXzP6yB7k8h4QUWPzShEtqIPiBn22GQ/h57JJjkVScY2dOwRgckZfHkAK+H0xM42OF3OKcpLBHjLjcBa04WAjoVlsN7cVm3rRBkzh5/YMiRWzBXVjfc5R6EQ1baMYCznRwPyxJliUUbb525ux/5HRK1/5pTRg8cgXGkuzJA7ZkQB+vdLHiuw6ADTGCl14DhV+Rh7dP7P3EmLPN9F5epV+lFG/Go3g6HGXRAo7nL0mdu6+9Hpr7IwNvW/TaluISU/Z1KiJ3kzgYoBl2O0Pv7WApG2m4lVcZQqFJibyejnBYxPvpUlQXxVVaVs/PmGTu7IPn+b7m15jxD/eZuy6DcJsYInGwC/Zj6vhOUe/o7FnZqDXE2vcxwhEPDx/QvFQbNo15Kqh0yTL5mU/sOsX9++XuxVGUmRw6a7MdLax1/oNlh1tj7kcMfGIh9+t1HD12q7HoZ/j0DcwSI6hHLiiHW7wCPv
 Bofqyiln
 DO31iJA8Lbv4J4X7o0M3S+PWqYDExATLItt1bNlgYEWla44Pf33hiaAZGR0ERE+UpWJkInGlqf8bQt9KP69N/knwYLZr5PFOLncZGvi6PsjVjHM886g22cwpG/RzsomOKY999L/gywou0NiPwPSR8oC9/o0qjen7bn58qI+lVkuxgs6/MNjCGy4EQ+UCJJwya7rIrVFQGFCcQX7EeBKajWwreKK40v7rwKvZq0Jic8HrSXtacz4qrtPkxC8f8UZvl9PGnWCSlTUjx9uPcgI3nwk4aQdmSYsbv8idzGPrn522yaMMXLebSRLvUCOplfc7LxUXe/+TNLu8POSTe7x/rsiQPAhmgcafedWoiO0aTLWlcas69VuES6Q4vi5kxBsSbPTafQPo9yevup6Djx2qgVUJh6FJqcs6TkMgg5XzS70x93LL7Wtnt+z9+bFG+4pgRnyvWHswqeLl3JGQ3uwfUEXc8B9MJZgDUb9NRMDc8OKqZRYrmGGZ0N1XhgORGyMy5uivvto5guyf2aZ95Bov9vyOJO88EsXyee3jdOdc06abOTu5KxiLk2spd3/dha9wcsgIMcUCj2PoOStCosW1pDu6X7hD37P77Rd0X3IcOPlsfEiKzSwuMjadIuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> >         for_each_possible_cpu(cpu) {
> >                 let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
> >                 unsafe { (*remote_ptr).write(val.clone()); }
> >                 let arc = Arc::new(alloc, flags).ok()?;
> >                 Some(Self { alloc: arc })
> >         }
> > 
> > Is it possible to do the above in rust?
> 
> Ah, I see.
> 
> The syntax would be slightly different, probably something like
> 
>         use cpu::for_each_possible_cpu;
> 
>         for_each_possible_cpu(|&cpu| {
>                 let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
>                 // ...
>         })
> 
> it *might* also be possible to use a macro and dispense with the need for
> a closure, though I'm not familiar enough with proc macros to say for
> sure. That would probably look like
> 
>         for_each_possible_cpu!(cpu) {
>                 let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
>                 // ...
>         }
> 
> though personally I think the first one is better (simpler
> implementation without too much syntactic overhead, especially since
> closures are already used some within R4L).

Sure, #1 is OK if you prefer it.

