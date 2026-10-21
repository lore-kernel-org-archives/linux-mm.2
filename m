Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E4B606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/VdZDYY
Received: by kanga.kvack.org (Postfix)
	id 8ADD06B0797; Wed, 21 Oct 2026 16:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837B06B0798; Wed, 21 Oct 2026 16:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7020F6B0799; Wed, 21 Oct 2026 16:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47C636B0797
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:30:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8D781A0687
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:22 +0000 (UTC)
X-FDA: 85347775884.04.1C578C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 491FE4000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:30:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/VdZDYY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dC5pXc4nN0qf0upwnfjFKJD9G2HlA8g2yqaCeFHQhQQ=;
	b=YgcVI4fi5FvRRdgVcTuVmuPu0zY83HWRwNgTNf5lXC1CzpiUS8864NOFTSKfXAYj3e82BM
	JIr7fWyY1BOHbusvFEdiVQkId9YjrH0nFThPK+B52gRDYmOSZ3dxQgvNo6KL/xwZf5reHI
	GtJhgmywh31Zqho3ISY2nUnu/8FuoEU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/VdZDYY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614621;
	b=anOC9rxdAW2Bbm7YFxNRIYHv1/LC2bs5FIodpvaSvLupdH9MRA5/60527bjxgUFNbpWQPa
	ZQ4q5dCtFfTqYji0oydER9u4w4C0h0IyqUsIXPqgAHy/g7tUH5m4oGdZmAXYSUgz2pWt/T
	iQRiUzjF/xfss2LDFF5NbqwQ8aYw/3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C926560142;
	Wed, 21 Oct 2026 20:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A47C1F000C2;
	Wed, 21 Oct 2026 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614620;
	bh=dC5pXc4nN0qf0upwnfjFKJD9G2HlA8g2yqaCeFHQhQQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=N/VdZDYYRjr+K7gPY+DRPpbDh54v1Jugz91wj373VKafhu5CnBpph665lbj73ijd6
	 0zG42WBW8RZ/GrXqQKCOM9BWFDLgs8gEccQO0oacheUteDflqkucODHDVauwr1AGiw
	 3GvoQnX2+Ca4VmfoEui8dsXIbH8QgJNynaYYZFMFeF8Byd7nS+fOiGJTbfUNl2Mdnz
	 mUO4oZ50SElfFKrEjVRbKKwdg5x/iYEScJGYHLVOSW9/iY9CMvtDdTMM0XOX9DaCTC
	 XOLenf/H9eX+cZk+p29ipW++EAsQwQWESGMz842uceiR2R2AEf4UxNg9YyeYDAMJlw
	 au/3qGehx3jcw==
Content-Type: multipart/mixed; boundary="===============4819838643990905154=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <038645137772f125ac45a4ea75ca052ffcd035160522f1bc4c2011fd372e88bf@mail.kernel.org>
In-Reply-To: <20261021195759.119421-10-jolsa@kernel.org>
References: <20261021195759.119421-10-jolsa@kernel.org>
Subject: Re: [RFC bpf-next 9/9] selftests/bpf: Add user page failures test
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,linux-mm@kvack.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,linux-kselftest@vger.kernel.org,shuah@kernel.org,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 20:30:20 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 491FE4000C
X-Stat-Signature: q5zjxfd8tukr6iu47egwi86hhy86h6fm
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614621-321743
X-HE-Meta: U2FsdGVkX191GXTpt4nPXkBw5p/GmJofmy62iUmfysRZ8r4j3v4yvYhRgqjPjoqqTrTAYgSYhSqEYRksuDVQAnZNCO3adc1dyKCrYoRxbjb4yrriB+GKjiT/yrPv+xzvwpkyGb5xXbrv1k0wtvh7PwmoP+p0LWyJCIaWhJLztye7VLji9KGskG/mEc3nIF5NSIJwSTsJy4g9L+1OydGznHS2CyyRah5rqrZdOS59+VwbGgVAAKdOJsSnVWHxqyS5NfvYEYKGB3/HRDgrm6kkn8gfNEhkyO/3C9oWo5iq3Ckq/huw5ZZb3nrr8+J7fVZfcrqTm+2HH1MuyMKvQS8DfFE3TKOkARWfXn+y/dS1QvO3j5/wjbTxvT6K5wqksu2BlwnADS/tPx8WBxpxZO0/2uYgoZaKeOWks/5y9dXBQwG/56RS2REJlmZIuHk9gmgYLV8jXEJ6R+u8iuDc5jssaUk/BpbP8R3hZ8jrlZYG1yTKnTiTk/eSSMpStez/LDaABUDFx+A1wg+/23fCxyqjV40KE8lKPMk2PopWwNmZC2nTbXVMx0I8WyVIBJtK665nNztvARV0EZectGgmNzedG7YjLLYfavVL3QwoVBKKC0ODb+0eqYi9ytEcegVwNAXDqQibbzwBQvK8MQ+Yf5JYyHOxOyYZ4zmH3ztX97afZJCf/0lMKrCMeK812bzYWJkyrSV5/YZRaAh2IjmX49oj6OReEwr0fMgNC08SclbGoaCaInXSKubXQvv7uu320U8BlOyhEFR+zWSVtXppnOYX6xtsVHwfNjbpeqpSbPfhJ9egP+S3Y1AZ4ajbllZGR31Ibl1Y0sc4vFQX3Ky7wI+PXxx1tuEPJm1YNYULFu0MpbSuKbsEGLHUATQvrJ6A30OHd169QHN6GKIEsGpM8l0ImLS9T73YkkZ+vH61drbh5ZWd3EEmcAdWAoiORt2xFBg8UgA6gc1Su47ECVq8tEm
 pBABtrx5
 pHVZegabNxoA9hRYlj1irOufNsYMwXZjfsubyPJyBbawnYHx9jZw0U1+lIDWqOfZxOUgt/6NXG1jzRsv1hnN76s+G63bluk1DpaTyRK2Xi5KJs27+D3ZXMEZ7TtqMf8MfTRSUveuu7mHIWP3te9xwU5w0+GF/Yt68NqnBL0UP0I/fe17czcTa9ouRYs+NSWzdMUtLfHszg1So0zFhLZ4lbGjUMZz6z2iHpo3ZTksgSM1MS4JCBVV7mNwmjT1zipuZYzrlLBCnm49ousGI2YjpOxSZyRvelvepSwdB9DMK5A/Qomp40yds044zHrGnByvgBJT7hd/HM0GufAA0U9HzLcWKbSOsbghayld/EJD2fXa60LsX852SjdSX7mk/nMsHnQJb6zdL2zIuVyRyqzelXAkvV6QNsJXhm8bJmCCTxj6O8WEBfsD4/7i3NOdZTL7dhgQcUS/QeqamKYdBJCN10+jd9+ROpcyFgQ3BodXpawhs5D0gdwcXwMkUwypmxk1uxOLs5I3zaNJgsdg3p9uuhC/6h3SzXYPjTnfc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4819838643990905154==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Add user page failures test

TL;DR: Commit message claims the test covers replacing sealed mappings, but
test_reject_replacement() replaces a still-writable page before any exec call;
either reorder the test or reword the changelog.

>     selftests/bpf: Add user page failures test
>
>     Cover expected failures for invalid allocation sizes, misaligned or
>     unrelated exec requests, replacement of sealed mappings, repeated
>     execution, bad writes and attempts to restore write permission.
>
>     Assisted-by: Codex:GPT-6
>     Signed-off-by: Jiri Olsa <jolsa@kernel.org>

The commit message lists "replacement of sealed mappings" as a covered
failure, but does test_reject_replacement() ever seal the mapping before
replacing it?

In this series "seal" refers to the bpf_user_page_exec() transition, which
the kernel-doc describes as "The page cannot be made writable again after
this call".  The test goes straight from alloc_user_pages() to the
replacement:

    if (!alloc_user_pages(skel, 1, &addr))
        return;

    ret = mmap((void *)addr, page_size, PROT_WRITE,
               MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
    if (!ASSERT_EQ(ret, (void *)addr, "replace_mmap"))
        goto out;

    skel->bss->exec_addr = addr;
    skel->bss->action = USER_PAGE_EXEC_ONLY;
    user_page_trigger();
    ASSERT_EQ(skel->bss->exec_ret, -EINVAL, "replacement_not_bpf");

At the time of the MAP_FIXED mmap() the page is still a plain writable VMA,
and USER_PAGE_EXEC_ONLY is only triggered afterwards, on the replacement.
The replacement itself is also not a failure, since the test asserts that
it succeeds.  Only the later bpf_user_page_exec() on the new VMA is
expected to fail with -EINVAL.

So the scenario the changelog describes (replacing an already exec-only,
non-writable page with a writable mapping and checking that exec refuses
it) is never run.  A reader could also take the changelog and the test name
to mean that the kernel refuses to replace sealed mappings, which it does
not do.

Should bpf_user_page_exec() be called before the MAP_FIXED mmap() so the
test matches the description, or should the changelog be reworded (for
example "exec of a replaced BPF-allocated mapping")?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39668036298
--===============4819838643990905154==--

