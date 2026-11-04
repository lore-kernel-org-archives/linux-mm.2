Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C0D607D664
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qAu9rBJ5
Received: by kanga.kvack.org (Postfix)
	id 2299D6B05B1; Wed,  4 Nov 2026 16:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DAD46B05B2; Wed,  4 Nov 2026 16:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5BC6B05B3; Wed,  4 Nov 2026 16:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D58AA6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:09:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B77E16086A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:09:55 +0000 (UTC)
X-FDA: 85398678750.01.DA76AE1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E724140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:09:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qAu9rBJ5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6brttOSyQfuPbUsj1XLHAAdWANxJRJocz3zzeqBxf4=;
	b=tRrB+8GUPzeybMjIgk/LhxuLpHZyIG+0xKfiKIi8QZJTgq0uj5/VmQWWSSYc9vaD74F4IQ
	MR+4G/eebwb6HbHaTVQH8OT7HmwFAeFkji5OuO89KVMw5YK/IgsLMO1FCiavC0VoZppO3l
	IxUKbfLCR0iFrbQ4s5beoN8tktEyTkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826593;
	b=mGDYUejJkiwb80zcUo7JvvHEXVglUvpyCBbY2JnrN6Izu2AJeLdLsW6aURMNWvAtbyLOYZ
	W11PUGbsOR3Tgu6r9xzSu6Hzvq09I4ePxQDu2UdD+RZ0OX/rn8SuD8Ytob8GYsTPzPA9wh
	la3/BJLYiH1KvfXgZXUML9vA9kLr4RY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qAu9rBJ5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso7923895e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793826592; x=1794431392; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y6brttOSyQfuPbUsj1XLHAAdWANxJRJocz3zzeqBxf4=;
        b=qAu9rBJ5IIZBINr2nuW7+zo9EkejU+PrM3hl+8CueNrYR5mIc0KVOO+k8Y576wM7/Z
         PHkaF6NzSSVTYADXHSewoDhFYjkzAZhe4RB8pdW3poVZNBPVbTVOWW2zOGnjiTsBZLhk
         Ttp/85dnrMoVahXJz2+Rva4K/lrR1n8vSOmENIMNh8bjMIAahUDcLJgfvUqd/AaO+glG
         p7GXL5Rlf7I6PSw98T/Zw/Gq4DnnpAkoOD7pGAR1DZG4HRb606kQnGpxZWaupH5xxtE2
         31znqvEE1cuWyvnKSGivktuZ9AlUSPbz+fwqnxYzVa0SFvIx09RqxUlUe44Vtg5JE1Xw
         nxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826592; x=1794431392;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y6brttOSyQfuPbUsj1XLHAAdWANxJRJocz3zzeqBxf4=;
        b=QKE9Eh4cuo1zqUcNp0EXtL469qwd4Hq1ovCVyXfhpRelAeqBpvg9hLW7g2fecmCwha
         2bVK0gA4DUnJFZt9Z0JDq3EkB73wfXW6UVaU78r6d4OHPR9rpOXH3xsFg3muByz95Ihl
         KgYjXMio5JlJ/th18E1jme1Ne7YruZIMewMTyImvjotwSeDZ30U+NkQwVg/WC5nl2P77
         ujIrh0VofCTlCXiHoE4SfiADwUEYhf+S2rmVL9TPTmqobd0oDjXYc1XM90UHiWhlC/z7
         M0hWihp2LlNT+koW0NbmAc5XrFFXjwpzRDGN9MSteENCjPPPrNe6QHR6lPAwV2uig68I
         JBJg==
X-Forwarded-Encrypted: i=1; AKwUvBzz1O5EIcaypsRqFHsUjomcGg+JK/J3xY9nNCaXlIEalCAgpgKCMmJqqKij9u9IlHDTa3f9opYk6Q==@kvack.org
X-Gm-Message-State: APuU4Z+eH3Zw2z3AiaAhdws7QO59iKWqlN/Ty3LclBmQ2/izuqjaHZOh
	8O6rSNufR06xRLaAXFxskZ+F8t+QZF+LPI8Tu7+ybuz4r+nLiTFqSEqm
X-Gm-Gg: AYBFou14AtzrPHc3sR1q8vThI1KUMse9rA9Vb/4/q9RET221hkvS7vpbjm35mCuQYxM
	kD6Xi8d1auhb1IjOIcK3h74tin3pbAJO2yRqxybQqaKlrB4Sozy2aWKOuwU2XFGjz6lVuXblgiF
	3ssHpELpJ+PvCXQdakJw0o34JPHrV1zC2MVPTq9u6txhMRGV6TP/zXdQy2xszmK4sYiEbm7T3aj
	gaULHdqM7B60tW/PJCjIZHvRZ0kTU5ms3FPQjGoDbO0ee7MrCd6Mx+JIN66KE2ahX50NHfhBMqM
	Glr9W1PkXXN3KQ299ty2Bp6pGfRiqoOkt1vw4QNyLEYU/iXiHmA4YkNppOpzbK9+Dfb72W/tLqO
	XEO81pPM83UPmJagTvQjGjcmV6wPdz5godeSllj2xuZzO6GjVFXHgoyF6mC9FA9cHO4+olv/nwO
	AdfyIkJfQsuJ3ChH7eQ6lm1Cyst3A5qPQrUfi/ALkULkgZZ+onNGuofC6HiedCocrlPm3gLGEoY
	e6NDD+qZgunbizp6fZBPAS8oyED7LnKxFB5tF9MGJUWXgCfxvw0mTof6g+SFRyOFVOalqIkVz9i
	RsM557niwTswen0=
X-Received: by 2002:a05:600c:83c3:b0:4a9:18f4:925e with SMTP id 5b1f17b1804b1-4ac174711afmr372871705e9.18.1793826591951;
        Wed, 04 Nov 2026 13:09:51 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ea592fbsm9904705e9.4.2026.11.04.13.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:09:51 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Wed, 4 Nov 2026 22:09:49 +0100
To: sashiko-reviews@lists.linux.dev
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/8] selftests/bpf: Test user memory mmap
 kfuncs
Message-ID: <auufHZQ_hFUvH3w0@krava>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-6-jolsa@kernel.org>
 <sashiko-outbox-194794@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-194794@kernel.org>
X-Stat-Signature: kp11dgyuend971igmhhqarexq1tqf64i
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E724140005
X-HE-Tag: 1793826593-998521
X-HE-Meta: U2FsdGVkX1/R1Cb/1iaNcXj+yFEOBV/9kSYyQm4dIOOJpsQTzY+EEAfVdKI3ufsda0OpAxh37Kr0hgoPTN21tIcQLyiGTHd2xsSxVee4QqzPSFeAtBh1tEEt0JnX9+ZCbuTxDWw4zk+XfVa7ycrHaAuPKJFfXGBt8QXAkI27JxJdJqHBQGyhodw7qIrM2t5612c16+54WV46BbdovGIqawR14QsH4UbMnYjDq2oAMTJpsHQyDaxCxUoARrEnIsdIP8JsI94ImPxg4C1Fl7Po/Q3arNQeMPEv51ckYGiv7IQKUFhZOTiNyfA7Vr2SSPWtV8tR81CF8bUMSRUaG0wNffSsaWIast7rcZnCgEPrixEzQvZyj/jKK2p9kVxllSz9fU8oGH9pIGLi5yLe/0vmSkebp+/QWdIIcoH+MrV8bCEikBSvvznc2iqScwiG+d0/yWZjh/Oyi1/IPpnRNLygM02820Gx/gwhDlSdrgxgnLUB1xo3LS36DMr/cq0RIG4OFlwQmDvKxS8Vcuz4c4q7e97nv0D6huWVW+QtF9hbzsw5lSfXWAX9NtBs8qOSkQsu9YO7cZz5fFxw0wrHo45jybJoI/SVD3MvMNkYcqwBd6Ypy0C4guhofI3FssrfFj4MqnptCGtVnp2in+kmfJpRxGR2YfalpGNxHpQFy6NVivpCHGrwr7kkSsYI0ojaB2aTmGeWTZcxFH/mFrh7OUIzbdqGd9TOYnWI8pO/3ONJvZxp3c9fr3tEgA8XZQ52rp9vbbmA70MSLlShq6Qw9p/zE0ccFxJnJSEx1BU79md7lytzKhHlaOLzDPK760x8MepUcRO3zbT061dCvDgL+XxODct07d6FTTz0Itp2H5Zoq/TOgzqt83OYcSEtK+F1fmpfkKP7k2zJD9uGrB+HLeoBBVY/H/0KhbU3u0dJbT3Z43vI5yvFROwa72bfMk+D0CiQ7V0skM/TF1Fe5ZDQ0x6
 syiI4fhb
 Uw/+Z4PkqOkpEsHxc3SCBykFYj0s2XGvMiFpAPoryyc2rlsnzkUgzUkro6JBeRVbcd6Hd5ziSLe5VZN8n5rLPgbTwZ5Wd7YE8U9tg/lJ2ijEWc5pqBljsT3QYe78lwHU/WIi0ADDEY3Khg6ElFL+tqksyG7u8jbjygPAmLmuL6zrAtk4+5vJpvHYCOc6LcvfAvmhvX5sGwjcJ2B9KJ6O8OqMshhd2Wv8wwTHxnNoHrtuV5LljZoPTDPtQS9Oi6zvcZTlPuTeis5kzNwQWiiAb8CXvCCTE/OS+j3VF0XalJHLqL7Rj6ia6OFZbLlzwccXekWG8cGP4Da0I8/y9h2ObdJ7zugqEWWZyyGNZQbnpYPRl1jENNKrW8tsrEWUqLTVWICFUFIsZmYOgAwSlZn1EShjtHcm/S9BXZQTr2yJdsqmxR2e+Opm6mygozGH9/mNsGXeuvPjkBXGyKFoHrZh/kZFWVUiljDvKKG+Tc1YdqGmMctC6SNM4n4+cLdr2A6wphE4k87sUvl0FXs0wnsxTNu1ZzwnOSqY0BDvTN1EAvjunKJGfIQtetvqK2sTffWekrIKX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:05:35AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] selftests/bpf: call to undefined get_procmap_info() in user_mem.c
> - [Medium] selftests/bpf: unresolved kfunc externs in progs/user_mem.c
> --
> 
> commit c7cc5f98b3a4b4d8d168ef0934e6c41fe197849d
> Author: Jiri Olsa <jolsa@kernel.org>
> 
> selftests/bpf: Test user memory mmap kfuncs
> 
> This commit adds BPF selftests for bpf_user_anon_mmap and bpf_user_munmap
> invoked from a sleepable uprobe, verifying mapping permissions and
> unmapping behavior.
> 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> > new file mode 100644
> > index 0000000000000..f301a18437062
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> > @@ -0,0 +1,112 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <test_progs.h>
> > +#include <sys/mman.h>
> > +#include <sys/personality.h>
> > +#include <unistd.h>
> > +
> > +#include "user_mem.skel.h"
> > +#include "trace_helpers.h"
> > +
> > +enum {
> > +	USER_MEM_MMAP = 1,
> > +	USER_MEM_UNMAP,
> > +};
> > +
> > +static noinline void user_mem_trigger(void)
> > +{
> > +	asm volatile ("" ::: "memory");
> > +}
> > +
> > +static bool check_user_mem_vma(void *addr, unsigned long size, const char *perms)
> > +{
> > +	size_t start, end;
> > +	char vma_perms[5];
> > +	int err;
> > +
> > +	err = get_procmap_info(addr, &start, &end, vma_perms);
> > +	if (!ASSERT_OK(err, "user_mem_vma"))
> > +		return false;
> > +
> > +	/* VMA can be merged, so ensure it covers at least the requested range. */
> > +	if (!ASSERT_GE(end - (size_t)addr, size, "vma_size"))
> > +		return false;
> > +
> > +	return !perms || ASSERT_STREQ(vma_perms, perms, "vma_perms");
> > +}
> > +
> > +static bool check_user_mem_unmapped(void *addr)
> > +{
> > +	size_t start, end;
> > +	int err;
> > +
> > +	err = get_procmap_info(addr, &start, &end, NULL);
> 
> [Severity: Medium]
> Where is get_procmap_info() defined? Both check_user_mem_vma() and
> check_user_mem_unmapped() call get_procmap_info(), and this file includes
> trace_helpers.h, but neither tools/testing/selftests/bpf/trace_helpers.h nor
> tools/testing/selftests/bpf/trace_helpers.c declares or defines
> get_procmap_info().

in previous patch:
  selftests/bpf: Add get_procmap_info helper

> 
> Because test_progs objects are compiled with -Wall -Werror, won't calling an
> undeclared and undefined get_procmap_info() cause compiling and linking
> tools/testing/selftests/bpf to fail?
> 
> > diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
> > new file mode 100644
> > index 0000000000000..e3b0689f5f2a5
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/user_mem.c
> > @@ -0,0 +1,43 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <vmlinux.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +#include "bpf_misc.h"
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
> > +extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
> 
> [ ... ]
> 
> > +SEC("uprobe.s//proc/self/exe:user_mem_trigger")
> > +int user_mem_test(struct pt_regs *ctx)
> > +{
> > +	if ((bpf_get_current_pid_tgid() >> 32) != monitored_pid)
> > +		return 0;
> > +
> > +	switch (action) {
> > +	case USER_MEM_MMAP:
> > +		user_addr = bpf_user_anon_mmap(map_len, map_prot);
> > +		break;
> > +	case USER_MEM_UNMAP:
> > +		ret = bpf_user_munmap(user_addr, map_len);
> > +		break;
> > +	}
> 
> [Severity: Medium]
> Can user_mem__open_and_load() in test_user_mem() succeed when loading this
> program?
> 
> user_mem_test() calls bpf_user_anon_mmap() and bpf_user_munmap(), which are
> declared as required __ksym externs, but neither symbol is defined or
> registered as a BPF kfunc in the kernel or bpf_testmod. Won't libbpf fail to
> resolve these kfunc BTF IDs during user_mem__open_and_load(), causing
> test_user_mem() to fail unconditionally?

defined in:
  bpf: Add user memory kfuncs

jirka

