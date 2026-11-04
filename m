Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D5A606D83D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oJ2Pr3YC
Received: by kanga.kvack.org (Postfix)
	id 358C96B05B0; Wed,  4 Nov 2026 17:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330416B05B1; Wed,  4 Nov 2026 17:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249936B05B2; Wed,  4 Nov 2026 17:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01C1D6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:31:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BFF412085D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:31:59 +0000 (UTC)
X-FDA: 85398885558.20.4F78EF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C36DC180003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:31:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJ2Pr3YC;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831517;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZQGrkSDxvYhOH9fwbZBQNsu+CCHkAHmzOvW9coQa1A=;
	b=xkou30q4yWKcmaFaNLp/9E6S3iWB21ozf0vWo/TfjYi4dNXVwS58COYL227C6SQY+2i4oa
	+ENc8CkflR0NSxkQmg8J+NiXgCWnwSygGd/NPrsZ9ybe/5GKZyT9XSxuKL4mr5K/f9oplW
	dbbbFs2vRn7zz/u7Jhs+gX0MNqhJ+tQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831517;
	b=vSU229ZPzNcI7WeXFHYLBJCllWnODwcWJz32H3ZJNliArzA85MNX92EW94BE5UZzPpVGlx
	VWT/d36V4cygAKwyt1OATfxZUx/61uBcmWg2ZzcQFMiQ7yZt4PpAKY0V3W0q7YOqaCKPTm
	rYo4U6XZy8z3bDZbx4Q9C+RmgUA764Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJ2Pr3YC;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33C2540374;
	Wed,  4 Nov 2026 22:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E521F00A1A;
	Wed,  4 Nov 2026 22:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793831516;
	bh=IZQGrkSDxvYhOH9fwbZBQNsu+CCHkAHmzOvW9coQa1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oJ2Pr3YCv8dGpxd1xuaOrMwBYV5a9uJr7xhfDvM8vD7VPOlh8TaPvZKNZpepXtr1N
	 f9aLC7HUTzzF9ZB0C/3KBjub7+Ms40UFnUqCjaL055Wwqp7XGDFW+c+sMTyZxhghO6
	 4L8fvkKe6BUWGHiFDUK7vJR8JyvB9nEFAiFlh2fGtbAA2aQDVAGtAveu7Wq3e5+r7z
	 g/thipPF5Vcukvu5HkKuDNwQIFqBF/HyGAe0zbFsqZJlpx6lR0WczSy9qBrZ/u6jT8
	 35qox3c7eqNJHZ4D+YPLBmar7ocYtv4uzBvf6J6Llu/3Vam4xvYgWykqpC9dipK+ue
	 0CFkN7/FKW7Zw==
Message-ID: <sashiko-outbox-198230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 1/3] mm, x86: support copying a folio using
 non-temporal stores
Reply-To: sashiko-reviews@lists.linux.dev
To: "Huan Nguyen" <nhuhuan@google.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>
In-Reply-To: <20261103223025.2482227-2-nhuhuan@google.com>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <20261103223025.2482227-1-nhuhuan@google.com>
 <20261103223025.2482227-2-nhuhuan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 22:31:53 +0000
X-Stat-Signature: mjo1r7qw1bsu9e6b4idce6dxafg1aqif
X-Rspamd-Queue-Id: C36DC180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793831517-949639
X-HE-Meta: U2FsdGVkX18oiMW/pHw7dCoGXBXMdGCInlKByQyyNBPB/K/D0vhPvd11UznABUM8dPMgzkUE4f8noARuQU1PUIz+wmWtI7ynYm4L7FTrp3M5UCWN1tmrFKG0lGhRb99htr42ktBDohd2iXULaVovMYs4TRv3oLjHfm93ku1AYEotm+qBLUuzfd/xau/3S9mHgK2I4zbYJYQGk+mpeAN4M9leGdi6D2vEHps3J2/lXk8NC4EyvKY0rxX2NoLY14EtwYo/sEoev2jhSpAlrXrJcJCTtTexuevRhRkPnjaIc35aa/TIl1PSTxZDXgyCVCdS1PB4iOHyzdmPEw4MBRJeeJgZZDRNfL+n1I8btytUKeUxg1nnufjUQn5LgHmIR0cCRtzl3hxWwrM2YW68CCoaAQY0FV8sPUryMHByK6TiR6y4OqkdwA+0utCz/vlYerXnf/PoYPlaVvlyEUu33Hh4m1XhMXMKhnFAFSsAYJdC95Xkc6znNIvCLq788SL26SZ4IsVkjodJ9BHMNxeZz2ttJDWzsB+UkJ7ICD76MLodTOkaAP3w564/cndvsMfDzaHK/12UT+vCU/Fzzjnb22V7VyZ5fVJqyJPJyNQ4QejNh1vnrsdRkMZ2+etd4sH39vqo5NKOnLT10X5ZIbwZ8JsgS32FOlKQoPtN1DAhPBkCszYcMOa1YHnf4iypDqILFI/fJB6dwavE/zI5Qv7sGxuNFL2eTcEp31dp9Hc0ibfDK8aamEnySZRXnpokAhmUBqy23AwIKEWn556MD1xQxOVaAb7qD3yhNu29K4RQ7QdKT0M9ixJNHjC4de/Z9U6dSx5uTfhRZs3EuoQwpPFiN1GQd+zH4M8Ew20x8d+Wswi/JMYwMj4oHkMgeqP7mQt26wtVU8ALtmvr3E9XzO7cxIzizgGzeFxcDO+4zgxHUTurhqVq7iYdy2RXC1fwJUdJQASUg4YhgJF+2ne16yDvXrC
 lkAZmVW5
 y/YaFGj3AvFYJ6ZFXaJXpmWJIudpE6ijeEsSbLU6jIdCDcF2Nlh5OnCmt5/br/kHIHe1CkoXKbkb0W3p/WwEtvmmbotSCQCOa1NYi+8+lgl4xxD3L0Xr996GapDwFOTTMYzu52w42bjPP7kPHjAtOE9437hnX0otqFfVbpVO6pANVoiVIHTotEaEUXosPMwz+C/HVzA/BTzpCsTSZt+ImJuv1TqNZAjXITkF55ZPs07V8HLHSXGZJLMVNbNAs3oEfasPibQ3kuGVxFO1tHsowd2Lg2bZ7c/5CZesAvOzyzFtK/hZ+uz6n+BHIvzoQsSBMPnI9rePlTwM3IjBV+YusjpLY9NJO61QjFFIMXXC6fIMTl5PPmmxNlGAUeW4ZEhOUwGOKDfdDPzJME3kefhYOnjJO8Vd6hosFjAPkgv50X/db4G9B9SWhfY4k0G4fDlzl7FFhS20hFNSwoNopwtOKxkiyv+XT++UenDXdIFtJWXZd1LggfXlhTOjccnkFF01S0c4F3mbLCiuQB3FKrDcXjkLZ9cR6qykBQQ+uqdMiXQ+Vk5X5wL09GsXnp6bWd+0k4kJkgTHAt7W+Ao8COW7ROp/C1DFQeyjqjQRktyocoQTgZHdMvVeXfDNWKpluKs8AEtazJe4Thpec0poQBpZvrVvMh+oTqHvErlUN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] x86/mm: missing KCFI_REFERENCE() for copy_mc_page_nt()
--

commit c8614f6dfdf00a57c43828a75e8413d839e5a48b
Author: Huan Nguyen <nhuhuan@google.com>

mm, x86: support copying a folio using non-temporal stores

This commit adds copy_mc_page_nt(), copy_mc_highpage_nt(), and
folio_mc_copy_nt() to support machine-check safe copying of folios on x86_64
using non-temporal stores.

> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_6=
4.h
> index 1895c207f629a..f37126b562390 100644
> --- a/arch/x86/include/asm/page_64.h
> +++ b/arch/x86/include/asm/page_64.h
> @@ -114,7 +114,9 @@ static inline void clear_page(void *addr)
>  	clear_pages(addr, 1);
>  }
> =20
> +#define __HAVE_ARCH_COPY_PAGE_NT 1
>  void copy_page(void *to, void *from);
> +unsigned long copy_mc_page_nt(void *to, const void *from);
>  KCFI_REFERENCE(copy_page);

[Severity: Low]
In arch/x86/lib/copy_page_64.S, copy_mc_page_nt() is defined using
SYM_TYPED_FUNC_START(copy_mc_page_nt) and exported from assembly via
EXPORT_SYMBOL_GPL(copy_mc_page_nt):

arch/x86/lib/copy_page_64.S:
    SYM_TYPED_FUNC_START(copy_mc_page_nt)
    ...
    SYM_FUNC_END(copy_mc_page_nt)
    EXPORT_SYMBOL_GPL(copy_mc_page_nt)

When CONFIG_CFI_CLANG is enabled, SYM_TYPED_FUNC_START(copy_mc_page_nt) emi=
ts
a relocation against __kcfi_typeid_copy_mc_page_nt. Because Clang only emits
__kcfi_typeid_<func> symbols in C translation units where the function has =
its
address taken, and EXPORT_SYMBOL_GPL() in an assembly file does not include
the C-only __ADDRESSABLE() annotation, nothing in C takes the address of
copy_mc_page_nt() (which is only called directly from copy_mc_highpage_nt()=
 in
include/linux/highmem.h).

Will building with CONFIG_CFI_CLANG=3Dy fail at link time with an undefined
reference to __kcfi_typeid_copy_mc_page_nt unless
KCFI_REFERENCE(copy_mc_page_nt) is added alongside KCFI_REFERENCE(copy_page)
in arch/x86/include/asm/page_64.h?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223025.2482=
227-1-nhuhuan@google.com?part=3D1

