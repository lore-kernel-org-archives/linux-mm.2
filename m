Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD68CD98D8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234C46B0092; Fri, 12 Jun 2026 10:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BFB6B0093; Fri, 12 Jun 2026 10:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4E36B0095; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D83916B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D0FE1C012B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:12:25 +0000 (UTC)
X-FDA: 84871450650.16.ED1E2AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCB344000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:12:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGbU4S6z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781273543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoeOR964OeNWGZmPS/w3uwI/mwySqgJZ/w7oZHK5+9Y=;
	b=OlagF5MKuf3NlKPA3IZxIRwO/DkLXPrnj4KEpxeXcQOg0Lt9H3kPQGhDn8xJ6Bjsvifnvn
	0OohcQCRNn8NzWC8SI4Ksr0rrcGDudeylYRd3VbJxGhPdJbQDiV2fUKlHQo2nZwTEwPq6r
	EZHPVhoD06/jhJEHCZBLvpTgUpGBpZQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGbU4S6z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781273543;
	b=kJ6a+KwIkDBhfEaflOcOr1e0UegJ2CeG6rFczPuVmD0RpmZ7HrcUFvYlpcfN/rk648zHvc
	7KTyujG1PTAxkGrAOuErpmlDakjyXxK4KPs0qfZ+cgilYFfIeMjwEto1n+FRRMGRzZYreG
	6BAWEaAipjJvQe86lTy7lpPSlEF6xXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20089600B0;
	Fri, 12 Jun 2026 14:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8818E1F000E9;
	Fri, 12 Jun 2026 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781273542;
	bh=eoeOR964OeNWGZmPS/w3uwI/mwySqgJZ/w7oZHK5+9Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fGbU4S6zVHiGSBYdoEEFM08WYTSoXrhzVg+2DZjT3EdRQU1Heb8fhc++pWYTKF8CH
	 KvejKFzNfUDqnK7msxQWG6I0VY6VVVvpIBEP9CwWg8vay6PILfAQjKllOVwKEl8wVP
	 2/ei2DzQTaLYL/4WqjbTsjJnkQiRmOOLQJs0UDHRSeAwCnsLcwwi2YKm75w+YAjaqw
	 oZXDA/6/SuJORPsZbX4l3ecep187pdo8GHlr9LNiVrH/BbhBtKxVzHIigrBl8H0Lx0
	 rcpTaXp75BCwlqMLNVtMYyCtZ2JKSJDPABhqUSUrsQlG3KuQwOlkRzWnoP1WLlMWfL
	 SS7OEJF4obD8g==
Message-ID: <e32c4ac6-ec26-47c1-a046-99583d054420@kernel.org>
Date: Fri, 12 Jun 2026 16:12:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Make per-VMA locks available universally
Content-Language: en-US
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260610230411.617DD5E7@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BCB344000E
X-Rspam-User: 
X-Stat-Signature: tarqhypxroyyg97dieyoxfnmos1tje1w
X-Rspamd-Server: rspam09
X-HE-Tag: 1781273543-259530
X-HE-Meta: U2FsdGVkX189hineKOcpz/5BYZpbDQ4UK5Vx7Lr3BKx5/tD5wlYTZGj5+FDp1Xwu1tVADqdgMpJrrVTCn3Yem8tx0Oj28nIlml+lPYaLSxptqesHBjf/I0rziIHXuqsrBXYdCtSOLZpedfCWw9MklYz11Ol6eA4knibURyl+5yW0saBj97Aa3IA49IdWr4aXArjJJbvpPlgcj6sE7fyPnElepKJ2XazRjaMIJd3kZK9fohUOBChR8hP3D9+UgW5M5ifEZJrjZtCm/vpeztPwDYiBphElz/YotVfaktRb5XlsJtVrqUjN5+1/vVPW+Kx1HY2lkXnp8zNqTam6HipLqToa2+Q9lkLODa6A9MYKHsDtlV0wOK2UmfPXNWN/8TLnXCLTz2+HPvPPGRrRRivu//RQNxDDg8VHZu6IoWnyXn3/ZTvtKd+yu36wrnf+zMJ/Arom72gtyciB7JWWJvbqKd7VDzsU/7DnP/zbS7Qph+TFwAccsntbRs3nbHiBbsdeQpy0AJZDxXcb04dVbtUI0jG/EBC1RVviEpW4XIO8Qkjb+WE/2/X6Y0GpLSfxPCy0wB10Z30VdUXSbauC4fVPPztyXrVSgIGjjkNqN+rVtA8ZAYQIfs2j6NG3TkYnPpeNdNxQo3+neSQr5mrmq2XX0n4OfFwz2mWi5WA85xwvfOfp6desW1r7A06soNOyCzEoym1rC6U/N/KHDluFKoi6um/aERm0/Xy2Uav22ekwpTeAP4QwBX8O4ntBIlxw30XKrvEztVk/Z2gqipHMCvNNCCJYlNfi8fb8ISrU6eUFqL5Mlplh3YPYxKCcUsQRRFsNUSnbkHUeJFwwmulyNwlea3lOkXe/dUQyWuZS+q7qlJTITTRtG7Ec9ejBn9Tmc3HORhM2EYaiWhI1DY+BF6DleuQpgTcQ4dsGWIn4CDdqcg8Gb9vk1dq7UorxZJTEGullwWyrd0yGFfQmOuDp5B1
 YLUSrTR1
 fbGbpiVakonpnZYRfgzgYfOfrkmDuLm4FC41G5qbWFm4ubuQNjn3++mRp0brHKTqYx26vuHoR4G2KkWthya9IbNIj23pS3KweOGH5cTmXcl9Rz91ss0BYCZMvTG9Lu4ldc7vZ4LKm/PY2iB0MR8fRCN1EoioFRpWfVNyQ2d89nhEANcyohUj+UztUTSutIRfmoY0r71M2RpqxxCROV4zEuh/nYTnfpVzikRSESK3/+/gJ2Vfm7y8q8z8AfO+lCUcXBkmR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 01:04, Dave Hansen wrote:

Not a Rust expert but...

> --- a/rust/kernel/mm.rs~unconditional-vma-locks	2026-06-10 15:57:54.051368539 -0700
> +++ b/rust/kernel/mm.rs	2026-06-10 15:57:54.078369499 -0700
> @@ -174,7 +174,6 @@ impl MmWithUser {
>      /// When per-vma locks are disabled, this always returns `None`.
>      #[inline]
>      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
> -        #[cfg(CONFIG_PER_VMA_LOCK)]
>          {
>              // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay given an mm where
>              // `mm_users` is non-zero.
> @@ -188,12 +187,6 @@ impl MmWithUser {
>                  });
>              }
>          }

Think you can remove the { } as well (as that was the scope of #[cfg] and
reduce indentation of what's inside.

> -
> -        // Silence warnings about unused variables.
> -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> -        let _ = vma_addr;
> -
> -        None

And here you should leave the 'None' as the #[cfg] only applied to the one
line below.

>      }
>  
>      /// Lock the mmap read lock.
> diff -puN tools/testing/vma/include/dup.h~unconditional-vma-locks tools/testing/vma/include/dup.h



