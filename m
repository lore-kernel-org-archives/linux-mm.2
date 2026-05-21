Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0A6CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915646B008C; Thu, 21 May 2026 05:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC306B0092; Thu, 21 May 2026 05:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801656B0093; Thu, 21 May 2026 05:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E08D6B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:42:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29CDB1A048D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:42:57 +0000 (UTC)
X-FDA: 84790937994.16.2DFB2E6
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 53F311A0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:42:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PS6DRNpB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779356575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Enrh790BjgIIUBfQlfWGTFeBgm0WSl+DUA/ZN6Netao=;
	b=J5SMTO5fXGW1mlR8y0EIzYBPShHDV5TQLpFafnpZBQWMU56TQtPRcZhU52jCnlyxKbpX6K
	IXJv7vRSbl3bUOlIJtzNHYW1mB9KpXKQcbNYfCN/KgqHbo1k1HKNXnizUL/4/q0CR3+W49
	OMQ63RtfGjMA3ppQzqR1/OfQGPKnjy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779356575; a=rsa-sha256;
	cv=none;
	b=a6fwfFMMhDF0JCA0xYPomaig7aRLEsFG6IbO+Nxm2AVSxzGBiFSXXZV/c9tu04RJdR/l0+
	VLoaYLKBAZi30etiTrbw9wK1D19SL1w97P/uHbUC4XUCQGf+hQoJWAVRBAIrI7EGXrxnas
	D6RLIiaoHlUMzrxTokW8vXwXi5Noaoc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PS6DRNpB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69d60694c9bso955030eaf.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779356574; x=1779961374; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Enrh790BjgIIUBfQlfWGTFeBgm0WSl+DUA/ZN6Netao=;
        b=PS6DRNpBZPK3SLJkB1TdUd7ojuBdR6a4QlbISIYXnNigKGlCbLh5I5WgVxfSWn41Wq
         KBT1z6nSLlLNHWamrssnqdFnzM2g3HLgGpWnL9zS2+9IqPI1mdMw7YKLBeJDbMwiPkk1
         Th659HEJA3GCsxnkpxGiG6fjbNtAPdkjp5UwAya6UMoK1P6qOftrScsgwokL9VfkLeNl
         xJqRFPVX+TIZDX+GCZD5WpqfO4MxsSx2yfKnSp6KUAi68adb7yLpTEVlffAiIViRySKX
         GtT5Dx4CEiJAsenLHRIpfru7uJ0TIq2z/MfEk/sRch+2JDRLPLnsOM0N0c1hI/ou4Gpd
         5MZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356574; x=1779961374;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Enrh790BjgIIUBfQlfWGTFeBgm0WSl+DUA/ZN6Netao=;
        b=dcRQwyweWV3u2eCpPGIRoAJeJd3JTU57ZvkCSPMVQdeR1D1G8mi3YVt1TTnenx+GOb
         fd4zZo/YSaODVAWRkGJD0mEoh/T1ILxr7z9q2UIhDbeye1hGBJu8JyTpWwgeo2BDlaX8
         NCjAktRWn3R1xcxaSrbwHmMuyt6Y6blidgchJM71x0eKTdeUy1bDSWm0zHXB0AYfXMmo
         H7BD6RfVtAcNcGK66oF46ZolC3ZT0c9Vl1EeIDI7zqu6DXbleT+ASWuLvkTsoFFNWDlL
         v0w6wv/gNfhkwX/VJlRLUF8Qrn6L1V9jqhJaIW25eBT42PoJAdkCKsQCXS7BwH601Dq4
         gmwQ==
X-Forwarded-Encrypted: i=1; AFNElJ8bM/7aRKKQW3TM7q/kYqzeE9WazwkiB8HsWCnGkrXIW+kM02UZiJR3fuuhcmiMznqOz0d3ajnHHw==@kvack.org
X-Gm-Message-State: AOJu0YySPjYfKgVfyrWHgIRCx47ardNLCbgPGuRDohrD5amSRfqJqNeY
	O5+SmZTYWaEZ7zRsNV14fro1g8ZaiJKIeqy4eRfJbsNnz1Xu5DrmNrei
X-Gm-Gg: Acq92OE+hPlczDYvIyovEDUQHiQiiOlMWNCy2kXOQMFQvXagWJ1h+pT+mJxNd7b3X9h
	fqNekXaJ2PcL3zMuIYpbZ6ucEW6AoTul7Ug7BXecG2dgXhNz3qIFCjHMOKWv7GOEX7dGw7BQDQy
	clkPPtnmAsPlHKkuVAQEbdun+zGcMjPfMNvzD9XZE3Yl77ZvEPCoHxHFfllRIwbmgNFP1J5j5Dn
	I4kJq/WxY4oNJYvHu/X8EQq9GA3VI5nOx+IlFILxWgetyNHHYB+MNiNqDoJE1pTyZCVOsliFitD
	8N0VyXo3P2wy5HbtIzbiN1U+nYRuWS8J6wU3ihOIf/dCROCx5PcRUAhiEXDBI07S5xRNlOcetfh
	HbSmZnL3Aq4TCHLEsst/Fdv/kELaGHzVLAuzDjqcxYxDc+VfVCBVXvMk2fQph7nqgDjhTe7BA5n
	9r5duTKZWRgmOmAgBYiyzDT5ngCs/4+7gIMBE2UgYCkAPhaSYh04LTV3aQHk7DW1E1YZxK3s/ck
	fGQdl/oi9MwAlkA9Q==
X-Received: by 2002:a05:6820:290f:b0:694:6acf:a42d with SMTP id 006d021491bc7-69d6eefa916mr913981eaf.39.1779356574211;
        Thu, 21 May 2026 02:42:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d77385a8esm199938eaf.11.2026.05.21.02.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 02:42:52 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 02:42:50 -0700
Message-Id: <DIO99FYEHNC1.23KFEHRPTRB5N@gmail.com>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-3-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-3-tj@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 53F311A0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 67a4ds5myrsx8u6ogoqbamodhq455fhi
X-HE-Tag: 1779356575-898744
X-HE-Meta: U2FsdGVkX18NhYNI8sTJuyTZLx1eO7/KZJDFzH00XQe4el946A1KlA4/v4wDsxtl4pOet2l1Zsqpn2iG5i/BKTtXLFSO6PzsOwAUSFDgkh76FyD6NqVtlQUtww6+SQDhMcPL8xRvetW2fJARSERthjwfpitAO694b99TB2YIZwpUt4O7ME42zfEAm4qHl1jhEXCJkTJaHpr0BNDYbkgmlGcXvBJzZzcjikCRVivlgd/JZr+PHIibSufeY91W/gNV1NfKsojCdVuV1yE7cj46paceYkOtIt0tdWGRSIeZdeFyTumLz7feB9QfMl2HYS4roahSbggfQRiBK6BeIOV2ur72/l344iWICPbtgAbanaIgndH7VoYUgvfc3id2ur5F/mcF7Tm9Mjic4n5HXrQk03H2PlKmKFFKHXCAiVFlet2vMEdsycRXv/yq6XCONff2GyCUPa12CMljVjdByck7DHpgNK8ruNa53nwXCK2pCTrEgliDeXi7wCyBGy3BD+XnvjQHgIftlRbdUsdpRlIJW7Vx0mUvJ6C+cuRPALTNtIfvPnT31p5B0pnrb9S1TJ8IreeaFmAH8t5EMjMMj5Gjq8w/ehONginhkctndM5jmCYOyPOMHwcpa3zfQPWGBHtxnAsWD6kxSnYtVyjPkdleRikW6oD5ix4rGJvEz3B2fH3N0i/10r/Z1TBkT3pWPlLJurgBDpyyaAzqnNInNSVGiPCvvmlQFJGi9DNF3V5Qkg8opljMDfFWslYks1Mo8/qmi9HHAoP8U6z8mwYnm9vmdDqWMWzsoeQLHHN7AHNUeq4pTVDX4bS1m+mjX4p+pgwz6c4m9F2ER2kd567FRrEQfCTjnZICJoPjb/PTgmljR6SheNx1EcEWLzBpRq1Bk4SVBgakROqkajnuWqFp4FgR5XPDGdVC+URmKvCBal5d9qphTuZZK9E11JGluQPl8/MYZkdHQT4PO6C17ZKsOAq
 15K+4iv9
 3rAtTo/UyE5svdMFSMzKnTrcMAP3xkygHGIeClfW7iyAFwFJMXyx9wa6/6Uaj6Wicp6AfiKLicb0nG7APUpgtgN5S7yVgd0pASDSdO5kEeltdpNUISIpCiV2trKz2OBJ/kNIStfvfjDtboj6baLvs5niGTgjlffHwGLipnQbDMDR/LdqpKR6eMlXYWX9POlZcWdBPpXqsHTakhbYviNPdpfg4cQwIq4VWEEzwSawadUxG1B58MnQOpGoJ0Ql9qd4TDK5Xv03oX1PIBG0ivuTASwPEojARDXZrW/nT90NamcRAIo0zBH56pbTyWuVyKyJXnMypiCxAfc6kLCKEskb4fpq8+JmUEuwePKuL1jCx31+GVgtlY//IM8Vd+p8skUS2QMRWxihCBhXby2mnYko+BEVCIRx9fuEsfqr/US/2pHSP/KK5+OPqFfMldbfS5uJbfhfp+tHUPiYtFV6+xvv8Cun3Dc6FnlGLosVXZpof00J9V9AFDiqCH2r+kR/ExXAXa34/MV0IAky01SlgSx5HQlPcyEt4vk6HLU4B9yuXa0Em9uQ31+lJyBHiawdXRYWpG45pQbiKFve6aJx/kfxAgnvcThyHpoKegfZi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 4:50 PM PDT, Tejun Heo wrote:
>
> v2: Use ptep_get_and_clear() in apply_range_clear_cb(). (David)
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> ---
>  Documentation/bpf/kfuncs.rst |  14 +++
>  arch/arm64/mm/fault.c        |  10 +-
>  arch/x86/mm/fault.c          |  12 ++-
>  include/linux/bpf.h          |   1 +
>  include/linux/bpf_defs.h     |  11 +++
>  kernel/bpf/arena.c           | 177 +++++++++++++++++++++++++++--------
>  kernel/bpf/core.c            |   5 +
>  7 files changed, 183 insertions(+), 47 deletions(-)
>  create mode 100644 include/linux/bpf_defs.h

First 5 patches lgtm. Should we create a stable branch out of them
and pull into bpf-next and sched-ext trees?
I'm preparing a followup for slab-over-arena on top of these changes.

