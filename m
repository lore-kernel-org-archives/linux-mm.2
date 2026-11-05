Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53704606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U9vhAAG+
Received: by kanga.kvack.org (Postfix)
	id 492056B05B0; Thu,  5 Nov 2026 16:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469906B05B5; Thu,  5 Nov 2026 16:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359B26B05B8; Thu,  5 Nov 2026 16:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F776B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:48:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73CFF140BFC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:48:30 +0000 (UTC)
X-FDA: 85402404780.19.DE5443D
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 857F9100006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:48:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U9vhAAG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793915308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2pRTFJav8ucjqvUufNHSrzwm+2Gj95TGBH4a3gdM5M=;
	b=mmoT7f3Us3SIf8PYlc7CC74AeS3WeJ7sZfn6CZHS5B+/AyPvYx/EFVud9lrhf++g2Ci2LG
	UHPyErP1nUOXWnzRzep6GQh+hVZklyIlSBtb1UjgpVNPYiNmObtGgZblaKH+jwldlY9DVh
	gKNJlR8Xr6gpfFhOHRwcuGLHdqKe6rk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U9vhAAG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793915308;
	b=o/msFUHRoOV2R3FxyuC48VZ+i1kNWGsVkkZ29qJhZpVaoLm1ACndcTm8mz+G6CcK3FXJPk
	rkt4XYmk4mo1pYCHcAgwNBgCIBnlasZdINjSfGiWSkN1wX4Vf9dKcG19D3I7drDOKBdzeW
	grEkV6j/19dFmMGFXFtmJZP9XaLVd28=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso16429f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793915307; x=1794520107; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U2pRTFJav8ucjqvUufNHSrzwm+2Gj95TGBH4a3gdM5M=;
        b=U9vhAAG+8Uq014uG4KVAxdRg6aVdTEi3H6WgjNqOnClCe5aWvHiIWjMiA1jFNxe1Lk
         hWSmyqfsqXVez5zsJt9ggoa3mS3lTSdWArTf1qQoBr1xx513xgbtIRHM3zlE1151wJeX
         tPrINRnmtQ/UkKaUr74M/O5Nai/omAi+kKy62oPL6p62vE0liY/ys9/1KOkA6dy8Up7R
         Ba3cMQXwwanJoVO61WqgRbjhKCurDzV0vXzA0bjS8t2xw4lqW1TzJgflMSBk737WUFQJ
         B5U74QCCQwEamyc1LW9ehkYHNosVSW0Wu36VrRKLFiI2M2S1KwJgeeGGlmEcdUhUjdQp
         RiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915307; x=1794520107;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U2pRTFJav8ucjqvUufNHSrzwm+2Gj95TGBH4a3gdM5M=;
        b=0dJPwKojIObhA3YJ+gaS17gedGBNo0TCd+h4eflmG+dn8AUrlhBIAUSqvOiNhMWko1
         ai+NQPpQqCbbYplQ6xGIuNifOAY/60hypqWdl3SMZuihIG1XCyOepABOZVoKmiF3HUGs
         46kyOUCT1VQsvrwr+BusYRYmv77LphBqieX6X+GUrT4vLZO4HLhMw9aRod1wDTqBAuOu
         0zgAcT3KIj2bkwnDlrFxVye6CLUDHITwbZCr1A8ZfbcAkuXZfsstCUAX0egD4yzfULuJ
         3lswDiNfG+vjWbHRElWk0G9dsWeJUu3b+98UPpp1OBeHcxauH1NSAZ++yRxrYHjM80uO
         oAmQ==
X-Gm-Message-State: APuU4Z+eqjvn+ZgPgKMnPdUYo1wtfXoSI/D1F+m/Y0CdV4rT2ra12mQk
	K/2r8B2extixNwB+GCrCGw9zYSLO5WpLqEZmjEZ6LSmeg7yVsmlr7NWi
X-Gm-Gg: AYBFou2dXWdeKpm2BCzP1olTp5dEtWNroX8xcQsbqWrkdR3dxOyNKbgP/mALFFbAx8u
	A0XqwtV4e1xo6t2UXz7jtkqMJAXTeXkxWW7UGtgEAlU0YqYSxy7Y0mYH9rQjIcQRYXNIxa/JKZe
	JVxwEnIXQA3hechY0FSoHRYZQxJFJG2p/I2h/jFnuhVzZwV6F6qul5BDaAGoBfH8/BeFxDEjzxX
	Ab5UsO4W9unpyi7k9KtJ81y0ZimQ9CKoR5PKr4t+hNPXGiL5Sf0zqcGxpI9sUDhDfni/SQixpMe
	r7+xoqVcxDydLTTaJG3MikAC7M2yw7QY08qPsQsBjbfQZnZ2WajIAI0LXy8QZ3RveeWdb9b0RT8
	H+DfJ0U2+G4CgXJLKWfAtm4iCs5p0QIaoRZx6I7y1bz+3pIROMcWoIRXjHFQns8O7nWNjNTIy3G
	Bo/UVSk6yP/7FrrJSH6QFZglspwZOpDj13K/a847yfMrZVPneaA2/TAzhqFdCd4gUiW+iGd2w/f
	uzGkbtqoLA7fkksWdA7llKzpGOUgL7Z2zTocUKNnKJFTkWRCAE1ckN5Kn0lvpedHww6G3nGgtxi
	LgHB+gXwKnx0jZoxRG0JcXU=
X-Received: by 2002:a05:600c:8b23:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4b6dea6984emr6969745e9.9.1793915306776;
        Thu, 05 Nov 2026 13:48:26 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b571f46489sm87112035e9.3.2026.11.05.13.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:48:26 -0800 (PST)
Message-ID: <51c5b442-7a81-4357-a1af-75cf552f05f8@gmail.com>
Date: Thu, 5 Nov 2026 22:48:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-2-4384bbfe4606@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-2-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 857F9100006
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5e91ndaai6zeipx6d834a6q78uo4y5ot
X-HE-Tag: 1793915308-64956
X-HE-Meta: U2FsdGVkX18HV6VljPMIPi1jo6HyWLBoBRivmz9bP/S8LQya4RujiIbLlka/sZMAfsBmJ0UJaHNEWXgPAX3+mhYVUkDDCvjxbFzNeXbSiiG0cu+8o9mSGm7rMBVHHBoE3aLPryRsg8uQiUb+J10hHlcjv3bA4uco2RcLVNCTTuUoxEgTzCpsBRozgpvnMSuH2SjMOgHEAjUVbHvArg6M7W+f4DsDjGQkUZDJD2lXXb6iZ43gDZRzaV6LDzTFUsLvaufT6xo+A9xlGcc2xnf8wwo5SIqVxpZ5tFIqJbrEDsyR8r0fcNqvYA597Vz9urUQzQqHIfrmJ6Wi8JoQkD9LnhogRRcOh5i+CuZsfN1PyB9I+fZaTc6nXKJuFAzkE3xkgRq+Ajdga0Ohe8qxD7VwxlEVMI/lJP0bXcOUHLNdJuBY+TNw5bDbwTF8KYePf0xBp0gzkjpUlvekbSzl0ERJ7EAQwWL5mb+w9rLGaJAAkO0A1m81wcmY+eaYMTF/Q69N0y13iKgSQKdrQXiZIkIUwWKIAOXdIGgv7CsHZIM4wPPpe85rBiS0TtSU1SMrjStY9WsclsCw0ECS9omwx2J4IE7efm2Pkh/yLmXPFdA0/u9+3GnT/Qa3c/fliIjCdgN3IT7Ti8JotNXeyaCgKqGgjZApo+RkdJZvtXjcfujuqrFYGcyigbRep7RE7x9SR29opNsIV8PDXOVtK6wPw2iKNtqxsaUOTgO1J0cUr35OLpgecIpCHQV2gh/HDEVSsLiCICBL5Vr5SXlqDlfThYXOpYEdm5N5JXh4V8M7kk+W6aZJG7AevGCYfYWjHGpYNqzOfbsCNtQwSDTnTMuAVemzWJlY/d23zw9KFNwbb4u2EvS6yBixt7DDXK5nejiaMmgHdyNp1XpvY9yBjoOB9NqzvGzqERj6kMNibYP9a/cr42oqn+463CaibsQtIdYEDjEJxRHYRxLTHR/TPXRgDrD
 NPU5Rotg
 FzVzVqWnN6Nk9KbmgPe/VzZUf0uJbqP8fLnny/LY9YPFsNbPQaADYCsfSFDdWRTrkU9unkp5EnJDLIzHV1Ga2VdcdnHRNUO3DU6KZG56oZkzx+nhcOuYJphvlbvtU12uXqOOcAXWYyOyvTGMjda7FcYgdfEIpVRajyKC9LN827SHDe9+35i3cNzHtPSwGG4ptOSQRKg2ImO8afyV/Qer7nF9AyZRSX+lnPqv85x3Cd4PKvMrF4Bu6qzsHwMfkXgeOVm9V+iX+IBnmSA9MprtxA75xoIk1UNfa0w4p1kSLnQpiKEY3TKt1cT7lu9pZfYya2eUw7bWPnpLwyiEgIi6rMzdGnRlVP6IjzY7/FqaCLw78rKH17wVv+6t5ijkmS422tnBp+GDGxN96SqGO2PMO96IH2GDgJOvuF/+jJS1wfXKFGSFL5Oe2ynRyUqjDlvT6gqf+kXeHCQhwZO5IQkHj4+/pLFQCVb+I8g3s5rcnJzQ1U95cyPiU4AU1QOQt0arsL4WX07O4ZmycnuJGNH+L57QmaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 9:57 PM, Lorenzo Stoakes (ARM) wrote:
> khugepaged scans VMAs in collapse_scan_mm_slot() in the same mm until it is
> about to be torn down, prctl(PR_SET_THP_DISABLE) disables THP for it,
> mm->mmap_lock contention occurs, or all its VMAs have been scanned.
> 
> When lock contention causes the function to bail out, khugepaged doesn't
> keep track of where it left off, so when the mm is next scanned, it starts
> from address 0 again.
> 
> If there's a lot of mmap_lock contention this can significantly slow down
> collapse later in the mm, since the /sys/.../pages_to_scan budget can run
> out before the end of the mm is reached.
> 
> The budget is incremented (as tracked in cc->progress) at a rate of 1 page
> per ineligible VMA, but the budget is only checked once eligible VMAs are
> encountered.
> 
> Then, it only takes the combined total of ineligible VMAs and eligible but
> non-collapsible pages to exceed the /sys/.../pages_to_scan budget for the
> rest of the mm to be skipped.
> 
> For a system with 4 KiB page size and default sysctl settings this only
> requires 4096 ineligible VMAs/uncollapsible pages to be skipped before this
> happens.
> 
> Resolve the issue by simply tracking the last examined address in the
> khugepaged_mm_slot object, so when the mm is resumed, the scan starts from
> where it left off.
> 
> Additionally, skip to the next candidate if a VMA cannot be collapsed.
> 
> This issue was noticed during some work in which an mm was instantiated
> with a large number of small VMAs under significant mmap_lock contention,
> during which collapse was observed to take 10.8s. With this patch applied
> it took 3.6s to collapse the same mm.
> 
> Also, while here, update a couple VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s.
> 
> This patch is also a prerequisite for the next patch in the series.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

