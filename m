Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3A5606BE53
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=vMbJqT62
Received: by kanga.kvack.org (Postfix)
	id 48C3C6B02E1; Thu, 22 Oct 2026 11:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DE46B02E3; Thu, 22 Oct 2026 11:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D4E6B02E5; Thu, 22 Oct 2026 11:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039496B02E1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:17:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8710A66C7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:17:35 +0000 (UTC)
X-FDA: 85350616470.24.3CC29B2
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id B137414000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:17:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vMbJqT62;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nw86MTT9QYJNuk6B5SLe4LXpcyaG0CYCN6se45mv/xk=;
	b=dKWCCMymC2vDUVElMfAripN0xBkpYWoAAXnOT7i4waN4ewqNB5qw07kIuxBjZ52JAZdpSd
	gRHppFwqKhg4bUsSlv125LYV+0uP9YB+pu02pswTMDp+0lrUKeVh1ODm2MRjzab6Zsbr99
	n8THeTc36p5MLXgszl3zjFKp/RY4zWA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vMbJqT62;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792682253;
	b=SouLZEeDglJlCCLdOa+J2mQNP9z/esCLEW8Qm67vt9gqm+RB0hFuD5hIYxFKtuGgynY0Xy
	fVOThJOhKFMPCGhW4BQLqGgrDSOvRlBTSNYQZCySWUgRE2k/7GzkvjsPl5DT8ezADZpR8Z
	l+CCnioZo5Z7dd1yN0Iphp4QAjIEZvY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5365f9bef55so9903881cf.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792682253; x=1793287053; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nw86MTT9QYJNuk6B5SLe4LXpcyaG0CYCN6se45mv/xk=;
        b=vMbJqT62Q/o6hpWzk5JS8FuyqKxlA/t+RaSNOBYs4gTmMMmeYn1s4xWBB1haf/gpmm
         7zzNczLFnSyPaR+fA/39LV09wYnGpx2d0ckkjCBFts5V3jOnxwVhHCWm1+U8SoNiycrD
         Jb0I2y4coQSRcOsGqThsiFDyFZT0q+DLSKgrETsY9JIo8FVORr788figaM4EdwkO3Jpb
         NkVz+TCxXwvrhBY52KafaPo1htkeAacA6jgXmNGXC38g9R0190Ew+eAjT1+eEGlZ10Ts
         /0jDN8TQpzBthQ2IArHvpyWICBv/b5wfqWVkarCGL91g8leJJ7tVfwfqHq/xYayo/xVz
         NKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792682253; x=1793287053;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nw86MTT9QYJNuk6B5SLe4LXpcyaG0CYCN6se45mv/xk=;
        b=kzvkwKDoqc3L9pd8/u14F6mJCxCtfaMRMTRaUMmTK1nW15U8VvsUyjcEv1sDlpt4s0
         uReGUhVNEibMvXIMawrAIwrgXDSkt3x2AZM6h29BO6OgFDGt8A3Co9sBvTyv2JQ8ENS6
         uuNobpAMdroS5EZc7ol/7APAe/Ot2U1CzuXKkD+zx4qAIVAA03drkkj+RG1n88N26XeI
         4YgL48PzR+c8EGY+15CSe3Vyc0JvTo5o/nLi4DNtDC5Qq0KjIWTQAvUc1cyfJLT8NJyz
         PtIpb7OioTKVWv4ZcniQFzHeNmbFKIUOR4TiNVyj34Ke9KYqJX7D9Z1c0j+uQMV1SWhS
         YjTA==
X-Forwarded-Encrypted: i=1; AKwUvBw/ODx4GTeyNKma/kVvi5poKR8BmIi+4cGlOSVlJ+hmr2fBb7seOouK7BJ4/peUbYeT8oxo9IatQQ==@kvack.org
X-Gm-Message-State: AFq9FYIU2u6+xHLKvy4H5rw0JKGobo08k+D6pTAO/VNY2RHE0RWvtUH8
	MyeKmDtS4L+qCgN5It75DkveYrbigNzQBxZ2z8qfKIEwiF7+1A2sJspWWRUnN9Jnz+M=
X-Gm-Gg: AYBFou1tuzAVQs3DOAuBrEWQhDY5FYIEi4nihu1HCq4FNGf8RCt910fwTQaRAqVDRUH
	ZvDey7xAxeeFKSc79W18bhe9XBx27wb2I//JeqSH1f6Aw/4yjitnhGoZ0Axa3FjIrpi/YBZ51nW
	YtN2Df7qkFdr/+bLQ4Ua7ucWp2rSuNZMJU9Ypv/M7ewU6bXzBbgZKjj3S9+NiOVRBsgFMLAnBcl
	3pGJAl/yZ+99z+8UR8GOm28fyQL5dfVO6pA+3y+hezDlhHuCIX7MgX0LCptYRaSAoWGbCjG/Vx2
	tjndIEG1LJy+PcacVqnzS+vklmxaEZkjIwgwnJlrUt2h6Rl2c1G4wnAsHsEtLRqinRdaxmeuJAX
	lKFad6lVq5ANKAz1XVv1bhR0iVK76Wbojeunst9HWZMSl+JmUW2I9hMeukkpiSJnoVK0h5Xb5Yl
	GlyOxwzl883uRE7L0N6UQYt9ccMjgpTUR6+g3QffK1AJi4evqP+xGyr3LrAIo9S6u4r4x8gRPUG
	X+/5ryRJF/QCJro5bAnrxP5/ZN+QGbhsMGvlgA8jA4gwRfGnd1q9OgY7tR6f8XTJ3cZSV24wUU0
	WihEpkODyEy6rTjBcxtQls+Lhfv9uSgdE1VOW0I3bhQhkP8U
X-Received: by 2002:a05:622a:4084:b0:536:18c0:ab9c with SMTP id d75a77b69052e-536ae2086edmr43246221cf.43.1792682252769;
        Thu, 22 Oct 2026 08:17:32 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10beb7eesm53022736d6.28.2026.10.22.08.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:17:32 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] selftests/mm: merge: keep the far mremap() targets
 in the carveout
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Danish Khateeb <danishkhateeb03@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261022121837.28723-1-danishkhateeb03@gmail.com>
References: <20261022121837.28723-1-danishkhateeb03@gmail.com>
Date: Thu, 22 Oct 2026 11:17:31 -0400
Message-Id: <179268225123.3943303.2482161052665688188.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: B137414000E
X-Rspam-User: 
X-Stat-Signature: 5ekrw3tskyzc4ys98t364d6aq1zzgjhf
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792682253-535202
X-HE-Meta: U2FsdGVkX183C6ert2OqrAKXiDasEsYFFcE9iuXk08PrtxVHoOTKaNH2AgIJ8+uz9EVitDe3V1BfL23oQi37RIJwEsgfYwez1BOg+Hlvz/ZYqoAxFjDyjm/hf66ye6t6p/r47SEaGHVU0HwSjnwSVitQr0tFYtMK57IcO2pfQN9m8GRjP0VyuGmBkj9RrMHrgdaDMVtZ5IV6D1eKzO3z2E6YzG6ZnHJJnD3Uhh49pUxSYG3rGskNATA/tPV5xENbHzPT/cZ/oH/9oKA214PBteeBROxRWOM80TU62Vr2CvrSa4TVKaFlfDxvXrTxG3LBwDAiCmJp+KiP1sknM+c/4KZe0kEE79A3xe+LCTif0fVrtLhaP5zNBJZeQwI7irDLIdiJjQ4lsntViXa03GT6wcYk5HMSOkhHkAKvuz7uJCPR5Ybu6wujJ8nMBL0Xoy1PPf/woJkeihCBDuHyVDwIt9WIQctWbW5XiBwxWwu9FgoDrMD0TyNupohTy3L5Y+YdOzmj62K30blBkt7gGnfaQOQfDm3R235z85oXY5QULZ9+nmLLy++ue/0YvSmXBkFe7J9L0azTEvGsQJxXmQV0hTYx2WoFy3CAovG8EzTEVNSl2TTsx2gekV+f8RAbQhAtB5+iMRv7svfrbmLrIpTLUz9u/HvPSWOduj7PjWIQ3BkMj48YVyeRXB4Er9c5iTn+rS/Q+78UlI7aO40EOwbH4/S7dWWn0gT7nic1JwXQYg8GPX6TJnK7NhoDxnlSBy6DmE97vVn2Xng3Qoe0yUrElXA9UP4e1BbLC1mstU3gk0Bi4ytVwaZ56bBZHebdbk6EOg8Hkx0/TIDk16ycfV4pkq8OyHtorScJNSS+Y+2FAnLAtnsiRA22a9FVWoriWQg6r48e+gstt0hjWF6b0oIGH5RCM+b4GtxBtTEuEC64qCs9p3Xm9zN94PktVH07zRNa0LGeWbDFP17JrPD0TNa
 EtFcI5R1
 z7vP6+S+TjEp/hz73PXRRn+jxfrRHwm6LIqPvXR+dWycDXfgjQOH7jwLCf9w+tFHDNq/LMippvMZGbz1NE8Yoa0g/HoJuBJ2s23lx4JIiYeo+iJJIGlaerpUy4A9qvFXRVQ014KpTxXeGg4H0fNGOsZvY+1Ki+tLkXSZJOoiFdDWv3ixYGpIHLvelnaAtiNjjl5Wrj/yUUNe8dFRbRhEY/Y95xHB1AQz1FYaVLJQfll7BlG9YVYRMwrBf8TqsQoGij7TZq3qlMONzv5KGlZcZAdu0d7M9lnsjWe2kfAW8mUDg+SA11F89Yy2F1YmfM5m9iv7qYSilZhChpBKX13qUCj+X09NkmfVEnTun4UiRrSZw0Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 07:18 -0500, Danish Khateeb wrote:
> The merge tests map their areas at fixed addresses within a 30-page
> PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
> pages away to separate it from the others, but those targets are outside
> the carveout, and MREMAP_FIXED unmaps whatever is mapped there.
> 
> Under virtme-ng, the shared libraries are packed right above the
> carveout and the dynamic linker starts about 4 MiB above it. The moves
> then replace part of its text with an anonymous mapping, and the test
> crashes in its next lazily bound call:
> 
>   merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14
> 
> Two to four of the mremap() tests then fail with "Test terminated
> unexpectedly by signal 11", depending on the exact layout. On a host
> where libc is mapped at a 2 MiB aligned address, the targets happen to
> land above the dynamic linker and the tests pass.
> 
> Since the areas are all within the first 30 pages, moving one by 30
> pages is enough to keep it apart from the others. Add FAR_PAGES for
> that distance, move areas by FAR_PAGES or 2 * FAR_PAGES pages, and make
> the carveout 3 * FAR_PAGES pages so that it covers every target.
> 
> Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


