Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A57606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lLSYzBnG
Received: by kanga.kvack.org (Postfix)
	id 68B856B008C; Fri, 23 Oct 2026 20:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C996B0092; Fri, 23 Oct 2026 20:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C586B0095; Fri, 23 Oct 2026 20:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14C816B008C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:22:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9464412010E
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:22:11 +0000 (UTC)
X-FDA: 85355617662.16.F804383
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id D73D740003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:22:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lLSYzBnG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3MPrbagcKCPEpYXebiXZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wfelipe.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3MPrbagcKCPEpYXebiXZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792801329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxaRVRenX1FR+iZ0AONAeVn2JQUzRoeRNX74fibnxLs=;
	b=cpbJy18w0vT2fM3gvsC534dlbUso8i0oMUxRYpWSd6BYugYsJO54DsSWOyHu9TvjeJuY4u
	U0vgfE88M9Sd+IXpY4gZX+cdG5G7NnCSk/UQ3J643etlhWxns6HApo30uuY9ymwZzcm8bp
	XJuT6S691fzQGXsyk1EdIA6uo3J3ZiM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lLSYzBnG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3MPrbagcKCPEpYXebiXZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wfelipe.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3MPrbagcKCPEpYXebiXZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792801329;
	b=dhK2ICSGDIhl28Nk8qNtHPaPFws6AXjCO/nNTIvXpq1L56KJAEB8tMALhe2meCMJgqMO6D
	1yEZqm6SxvDEW9OC9h4VtCnbwYfacLxBhf9Kem5LncaVgMY6TbRbWl5yAThzeJCcaQi+Zo
	kVuIjc7OEKz/bKDCj3YnmklvhEz1rbY=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6e0063e7a02so1567588eaf.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792801329; x=1793406129; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:user-agent:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HxaRVRenX1FR+iZ0AONAeVn2JQUzRoeRNX74fibnxLs=;
        b=lLSYzBnGSDBsTagVMbBKaehZu2nCy82qImBW/96L+QUBbbrXQCoxlmhVJDlabew5CH
         FmvDlyqup/W4u5CpPNrVzzLx4hUrGZ6ijhoIbmQ4unEAdD+2xPK1au4A79qs7W+Gkqdz
         eAYEcVf6T+IvYElSz+3yIa7doIt6ahXTfZQnTDfk59zrj0W0UnoNXuwySR5gFwdJxtV3
         HD1jIZPdkMIufd4bfOAQ11WlmtcURJxSXbX6BfYmOSoOYGCvxiVoDWBTtkAdMex5wb0T
         csVDZfTLlA8FO09gp0ZF85iO4IUFxjmmlYhYNnSMctuFLtVWWfM1UP3cS49csftaGBML
         TxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792801329; x=1793406129;
        h=content-type:cc:to:from:subject:message-id:user-agent:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HxaRVRenX1FR+iZ0AONAeVn2JQUzRoeRNX74fibnxLs=;
        b=bT7BAxde6yZlAykrJdrdb0KsiD2CK3umm5ryx/L0vLLRWnrx4uhVccl35yJfOBKPXo
         VMuKNFXFa0gPLWtL7/dAdXJxOxBbU0/HKl9Rje8lfVpEXICbkgCu9gwzi33Ymz0/sxkR
         UD2BYMGX6aOz919OWX4PiGszk9GbVdAJIqPFXcZDtsJqUCqm3d7cI5Rde0QNA5KW6BUy
         ws6HrDHHcL2MrW5ifHgxwdWZMLfiv/J6p/jTWVoSWGqkRXdvFkDPDw3ONPRz1ZSUC09o
         KbIs9Bk6HpZ+4jtDPlI12sBweJg4jbQaRO5olR5ABKS9lCGK4e05HDQgpXn+M2ler+4n
         I5zA==
X-Forwarded-Encrypted: i=1; AKwUvBy0F1A1voesBmEN5ggivA5/GHiziCUroftrgzkhSR2bOMURZBfcRJC6/g1djGWAMavuxj0KSsUfKg==@kvack.org
X-Gm-Message-State: AFq9FYJjZz6+YY1YK4hD40cxCJ2ULuzfgpiJgywYaTOJUlf2sp5wt7sR
	TZrUpS/0Tt3Dyr0CUbnA/7X0BBg2UocHzAJeCdKVStClcJBRkO7O+Hnn70HisA8ZQLqS2wYobZV
	TdcI5GYuL/g==
X-Received: from oara11-n2.prod.google.com ([2002:a05:6870:534b:20b0:4a7:c9:bf73])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:f027:b0:704:417f:a571
 with SMTP id 006d021491bc7-70ba0b5aa65mr348934eaf.5.1792801328540; Fri, 23
 Oct 2026 17:22:08 -0700 (PDT)
Date: Sat, 24 Oct 2026 00:22:07 +0000
In-Reply-To: <100602397eadeaae2e3206e1d9aae55e@kernel.org> (Tejun Heo's
 message of "Fri, 23 Oct 2026 10:05:11 -1000")
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022042921.711624-1-wfelipe@google.com> <100602397eadeaae2e3206e1d9aae55e@kernel.org>
User-Agent: mu4e 1.12.15; emacs 30.2
Message-ID: <p973fqxwymkw.fsf@wfelipe-west1.c.googlers.com>
Subject: Re: [PATCH] selftests/cgroup: convert cg_read_key_*() helpers to s64
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Michal =?utf-8?Q?Koutn?= =?utf-8?Q?=C3=BD?=" <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D73D740003
X-Stat-Signature: ui1f1gpr75wo5zy7cd6kqg9nunx9j34i
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792801329-735516
X-HE-Meta: U2FsdGVkX19QNTOPAnmxbVqV4HeZaOn5DAzoRry/rUVhaBi9abWY/OU12Xig13GJMMK8V9XfnxTKsMTRi04VTksAQTQ0igmX0GuiOgzAc4xlEzM5eP37oYqzTWtYLg9v6W+nfPoQtHeTZNnmS0L5ASHqJFyktoYPMCBGc+yTHM9YkTYH9al4iAzVwkIwamo59rvmYFYutNuiZcTZHNaKxQZdPW7zHf9jzgdQfiKnNIjTa+79vyCqibLMAXiP8z3qkKbmzRgJLYVcl9YU1YPE/cpsCx0sKZ58Qmy8GXGEGmoRcAeCcNiQa6G+DwHmk2c3numnYxWZLfcivUizsSEDlTtjOu4Wm7vR69gLmf1kmkmZPrH1bY6dAeO/pIoIwGzxyM8G2X0J+WxVNydrsZjV4kAFp+HcN05deQ20DLM26GzG7eOK+2RZ7Xu7G6aoAu/G2smGtoh8+BpBm6WwVq9NMxWlQ/CrxcntFXSG923UyfBJTGvNA8Pl9gadMvswUGJF6fSV9NeyB/L0xKBt3TSuSURzpDMnZ5v7RNadwnHhNkzoZ7mifrFUIox+EQXIS+RpWF2nPx2z+cePPOsUlLFL2rAP5i7MxPpaAG76yzWQRhp6ie6VFS7Nojc6sxvI0KqXOVNBzKwCDFUxlHHi9D1/ZAdT+igts/DbwI7cUHMaY0J1yq6GXG34LHKiNqwjEvYbu52RIs4dghxr5pdMRymQeJ2tJd66iRVO7Tsnkj98y+TVtRIn+VIdHOES+QQ/jiRxq63N3tax5FqxOjP30XJAjsPCJeYN/NM8YaVGkw3uEFfiLJ5Ve+9+6TvHei0eZFPj8uzAas9+aX8cpVuPKW+L9BUpFxOFyqPRALxHhO+oqLTg4DHckJfrBqkBX5D3yvWBVVfFCQhZtqeF9X+fJC8y6iXcjJal620q7khAfVEOsxSTnsuiJ15hBexCyh8HhmNagqcFDxKLDltkV6yMouS
 sERd9IGU
 fH+9ocmrN7yMuTKpdCc9ynE+5s+bpR3pPNPcobPnsxVauJqtvD9zeJIwP2ziN4wc201cK1RIfqrfhWjWpc+fzWF7E9V0a1DTlmrKW6LCtxnw1VHq+SboKEYppffJ6au1Xlr33pqePF3t/+7ihQrfnm23U8vwF91zIq0o3Y15Bb8wJbSfDUmgHO37RP14KUkSzjpQjiNycmrPfNOiCQvQUM/vfgbEDklPk+6d/wPj8mUNPDXAwWfDN1EHvzRijFlf7ZXof2MR26Dzea576uLT9eOYf8z3LujGqOKAQSSEPWBucga7qNCcwUhtmychgslXUXKJOohQYVdsBFNSxZ3DHTsohU3q4ddcs5xLAisAMdOtDar4qCswdwwG8QXiMrWwzW5YjazwV2YJ3ct8+/UPtmXoc/3fapl93F3vluWnR09St0FcrLbAwo3YX73EiKEeCHal8kltEK1vI6oSEmedgVNeUa63CQgxUu/SpV2oyCTw6zVt/qqu0Bqg5CGCImlO46sEEOgunRdC518OUfoHPqUle/EKWChcfFa3GURCeJdXQpfBMuzSHfAaZNsvOGOKbGi8SjGxMqCRBXJ9Kj+On0oSvdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tejun Heo <tj@kernel.org> writes:

> Hello, Wilson.
>
> The following is a Claude-generated review.
>
> On Thu, Oct 22, 2026 at 04:28:57AM +0000, Wilson Felipe Pereira wrote:
>> On 32-bit platforms, cg_read_key_long() relies on atol(), which returns a
>> 32-bit signed long. When values in memory.stat or event counters exceed
>> 2.14GB (such as on 32-bit systems with large memory), the parsed value
>> overflows and wraps into negative numbers, leading to subtle bugs and
>> false test failures.
>
> On 32-bit, glibc's atol() saturates at LONG_MAX instead of wrapping:
> atol("3000000000") returns 2147483647. Event counters are counts, not
> bytes. No test reads a value near 2^31 from its cgroups, so the false
> failures are hypothetical. Can the description be updated to match?
>
> cg_read_long() and cg_read_long_fd() still use atol() and return long.
> They read memory.current, memory.peak and the swap counters, which the
> same reasoning covers.
>
>> - Migrate helper functions (get_cg_wb_count(), get_zswpout(),
>>   get_zswap_incomp(), wait_for_writeback(), and cg_check_freezetime())
>>   and their callers to s64.
>
> In test_freezer.c, only test_cgfreezer_time_empty() is converted.
> test_cgfreezer_time_simple(), _populate(), _migrate(), _parent(),
> _child() and _nested() still store cg_check_freezetime() results in
> long and print them with %ld. In test_cpu.c, overprovision_validate()
> still computes "long delta" from two s64 usage values. A 32-bit build
> with -Wshorten-64-to-32 flags all of these.
>
>>     rebased on top of mm-stable to complete the s64 conversion across the
>>     cgroup selftests (including updating test_no_kmem_bypass() to s64).
>
> This doesn't apply to mainline. The test_zswap.c hunks depend on the
> test_zswap fixes in mm-stable, which aren't in mainline yet. The
> tcp_client() hunk in test_memcontrol.c conflicts with eb69e955de7b
> ("selftests: cgroup: make test_memcg_sock check flushed sock stats"),
> which went in through the cgroup tree for v7.4. Can it be rebased on
> v7.4-rc1 once that's out?
>
>> +typedef signed long long s64;
>
> This is the main problem. The KVM selftests build libcgroup too:
> kvm/Makefile.kvm includes ../cgroup/lib/libcgroup.mk and links
> cgroup_util.o into every KVM test, and access_tracking_perf_test.c
> includes cgroup_util.h. That build uses -I tools/include, and
> tools/include/linux/types.h has "typedef int64_t s64;", which is long
> on 64-bit.
>
> cgroup_util.c then fails with "typedef redefinition with different
> types ('long long' vs 'int64_t' (aka 'long'))", so none of the KVM
> selftests build on 64-bit. Maybe use int64_t with PRId64 from
> <inttypes.h> instead of the local typedef and %lld?
>
>> -
>>  	ret = KSFT_PASS;
>
> The blank line removal is unrelated to the conversion, same for the one
> in test_cpu.c.
>
>> +		ksft_print_msg("debug: zswpout=%lld zswapped=%lld zswap_b=%lld\n",
>> +				zswpout, zswapped, zswap_b);
>
> The continuation line was aligned with the opening parenthesis before
> and now isn't.
>
> Thanks.

Thanks for the review and I'm sorry for the build failures! I believe I
messed up with I rebased it on mm-stable and didn't check all places
that had changed.

I've updated the patch locally to:
* Use `typedef int64_t s64` and to use `PRId64` from <inttypes.h>,
  similar to how KVM selftests are using, while fixing the build
  failures.
* Convert cg_read_long(), cg_read_long_fd(), and cg_write_numeric() to
  s64 along with the remaining callers in test_freezer.c, test_cpu.c,
  test_hugetlb_memcg.c, test_kmem.c, test_memcontrol.c, and
  test_zswap.c.
* Update the commit description to reflect atol() clamping at LONG_MAX
  and clean up the whitespace changes.

I'll wait until 7.4-rc1 is out and send the v2 that applies cleanly on
mm-stable and cgroup tree.

Thanks!

