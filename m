Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96CD606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ew+ST9iO
Received: by kanga.kvack.org (Postfix)
	id E0A1E6B0A1D; Thu, 22 Oct 2026 18:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBF26B0A1E; Thu, 22 Oct 2026 18:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7996B0A1F; Thu, 22 Oct 2026 18:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A77FC6B0A1D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:55:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F08EE160332
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:55:02 +0000 (UTC)
X-FDA: 85351769244.26.189E50A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54261A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:55:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ew+ST9iO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709701;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/VAmHs3WPkaKDCUDbFDqnQos+34yRbV2GllagT5bVI=;
	b=TcdDiaJ88R+kbrbDeKZz051vmJGwQBVl6hLys0LWUY02LBdtZ9xro86PymyjtCN2FTlhXv
	ZuIS7AdF+/LKt7+tAvdb9EQ3TY4MIljF7v8dk8E0Z62luBxVk+IpRirN91XQWdU1rdpX8h
	wWd6rExnV8BvVQh3MwBmhihlAFLs+CI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ew+ST9iO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709701;
	b=JxxT76dDir8evtYwSxZPxlOee2woD9p3XOCj9YzA1L06Bht4/b1HQzg2EI1PMrt/sjW1gU
	MPpRe2DoPENpc6omWsXxP/bsqVZz7RfOUGUWHi1i2zXYmO1VRRIlAJaK8Je+ofBk9iqjNB
	Zfmcq8mBVrWIGnBUfPeqAh5eJQ2LpgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94EA0407CF;
	Thu, 22 Oct 2026 22:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2331F01825;
	Thu, 22 Oct 2026 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792709700;
	bh=L/VAmHs3WPkaKDCUDbFDqnQos+34yRbV2GllagT5bVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ew+ST9iOKkZ+xl/krXhNO+wEnsaRGuTfCRg0IveistS5gP0Bg9f97Xt7RyU4Frvrv
	 gOQu0X8PsvSCafxvK/CgKVP+PJ3G2pUcJUoiVqkmkRVlrGK4P1JOYOZPFDGgCvXwnX
	 WN1Mm2byMNyhj41gliOAEbzIA7xOu8B/fMl3M0w0Xa5afzhB1Sy2T9i52WNZWj/sMO
	 XBzxvhZMRMCi4NoJikRbgIyRyYkfsA+77gSvEJQTH85IRwwmOSpREOb8KIXcTxknxu
	 kUXPADoEt+In/JB05dYb/6zJv88v2fyl9a1CE951z5tdSGWEpxf9cVjE0FHgCpqJup
	 UiW7T91yl/N7A==
Message-ID: <sashiko-outbox-182137@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] docs: core-api: include documentation from
 linux/uaccess.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jonathan Corbet" <corbet@lwn.net>, linux-mm@kvack.org
Cc: "Shuah Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
In-Reply-To: <878q3q4qby.fsf@trenco.lwn.net>
References: <878q3q4qby.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 22:54:59 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54261A0007
X-Stat-Signature: qg87cbg4j711burb885geawjo5nta1ni
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792709701-783759
X-HE-Meta: U2FsdGVkX1/JOlPycBWkQ6g/u2AJWIlWYM59syM7qQObg7f0CfEMf2lTOLMUSc+gXMkljIq5XLzQBAhunIz+QK9BSglMILnwQfqSuBA3iDMJXCJdUTarzLN6n7yM/0mOgDksiuAVPhRnJOrt6MtxEbjjrnP8XHCJv7J3HFP9+AAip+kjMtw4Era/JzK6jAseHizP3ZD5MCmTmJW9TV5XRJYr9rrCy3fp1wMj2r5wUGLTqZngqpqtsQgMymCuWE3bNQXpXY9s0BswRC9R8k+OM0GaN6d/K65vgWtOSD5HG0TgfFJcmfo2L2kW2o3fImFml5NyfQnCow1I0D29vhKHDdLGzyGEj7nHEhOivnE0y/EY2x3Di0mevqzAni62buMSc702Jwmce8d1J7+BFMEzyT2h4LBSk9+Jm8GbD2neWfyTjm6NfXYL1tr0v0GHStqPFZdf0rb8weGAcdO8K7Td6KYEdvCxcBYiLcSv/ivsSw+1zR1eDu27QLPDDrqDJq1VHGk4BpTWQZaVqy0TYSIM5HYEQke+SutqDipxylZvbq1A4clye6sEhNNhTPs/bt1dY8SODTU7yVwHTbnA1YFLDw0fKd6ZYsxKftCrLPv40bAPa7UAjctSEZK4o8gsQyzkzFIYEMKGKf392pPhJanJfFczyzC/uQJD+owQTIAUeZfpU4mua7wgowFsaKVqWJX/fSPq1vIS4ntEhjPVprbiEDkfIfapEBmm0ocn/ry2WcJNDvxBGqZQODN6FaxZsWFJXuF7HVkxBx00k9Dz8gYcME3c3eULIeztLSQU8tcTEpB6hy2OVw8wwhOZCCMcKuSCnshTiJQcx2hERXDBMs/m+qoWnNav6YSOAXdVK/2zosmdBXnvY69rz/fxJ6i9nDIqao29AF29ZfGZLBk0SxFfeYOJ+S+WUfZ5BIaWSd1Je5UXLBHIL2mV3ELjoFNQSibQeKiplsxoGS7BquyuD72
 UYVYiWWe
 ovzNGgpqHfiJA/85XFP/5D3K6BFoFPkhgLsqVHU0oKfpWOS7GNOgUTIU5hHCdj9M4Bcn3jl2MAPpB1eq/MwyM8ozzf631G3BSB0l4/AWMHFvimKOGjIJVU/vmPT6Bd8WWUAeuYFCoxs8eazUuhXrmfvUDGMae/Z3I6k7cRWdeGul1fZbgB8SGYj+DA4c8/5q3K8NzbHAnPJAATsCbvP/XEXkx3BbTl1qe8hiLvNnE1AQWL8FDF+kcMHT98r1cuYflMBw+KBoQ+DMqWLjPTFqh8UjFlrp6/LzAZT7Si4Z5Xm0y8DLTu+hKX+Qi+AIdL9Tz7pDbzPQHHVtavA2N+XKm5DM9XcdpBHt+L8dCOc7jVp2ReIqkS6VBHc+sxs6LPx2Uls55eaNHtZ5tnZ9FpWrTD7XBwQSqfFBS/4H60T/d2y1sdyf5Gsxe/Ydx3Ke1cgA0ZNiTMUI+MQ9YoH/v5edojwHMYPuNMCXTnw+jrCbCm5D+WTfA7JaHFCl5QfGqV6wvkpR/TRTtC+c+i5tW/Ao5H9lK8IefWyAxBJ1l9R1NnWs9RyQCh8IHDKXvjOJ8BBr9On3wN/Ts4yUyXZj+AozfHcnzcHr/qno9MsUGavzOU8YfZlY9VUOPXYamPg==
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
- [Low] docs: core-api: kernel-doc and Sphinx warnings from linux/uaccess.h
--

commit 2999ceef858b0ddc1bc84f5c20261a45d3fb5ade
Author: Jonathan Corbet <corbet@lwn.net>

docs: core-api: include documentation from linux/uaccess.h

This commit adds a kernel-doc directive to Documentation/core-api/mm-api.rst
to include internal kernel-doc comments from include/linux/uaccess.h.

> diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/m=
m-api.rst
> index c1d03a5a2a192..b8c00bc5314e1 100644
> --- a/Documentation/core-api/mm-api.rst
> +++ b/Documentation/core-api/mm-api.rst
> @@ -8,6 +8,9 @@ User Space Memory Access
>  .. kernel-doc:: arch/x86/include/asm/uaccess.h
>     :internal:
> =20
> +.. kernel-doc:: include/linux/uaccess.h
> +   :internal:
> +
>  .. kernel-doc:: arch/x86/lib/usercopy_32.c
>     :export:
> =20

[Severity: Low]
Does pulling include/linux/uaccess.h into the documentation build introduce
kernel-doc and Sphinx warnings during make htmldocs?

First, in include/linux/uaccess.h, the comments above
copy_struct_from_bounce_buffer() and copy_struct_to_bounce_buffer() start
with /** without a kernel-doc identifier line:

    /**
     * This is like copy_struct_from_user(), but the
     * src buffer was already copied into a kernel
     * bounce buffer, so it will never return -EFAULT.
     */
    static __always_inline __must_check int
    copy_struct_from_bounce_buffer(void *dst, size_t dstsize,
                                   const void *src, size_t srcsize)

When KernelDoc.process_name() in tools/lib/python/kdoc/kdoc_parser.py parses
these comments, it emits a warning that the comment starts with /** but is
not a valid kernel-doc comment, and omits both functions from the generated
output.

Second, the kernel-doc comments for copy_struct_from_user(),
copy_struct_to_user(), and __scoped_user_access() in include/linux/uaccess.h
include indented C code examples preceded by : or . rather than a :: literal
block marker:

     * @ksize is just sizeof(*dst), and @usize should've been passed by use=
rspace.
     * The recommended usage is something like the following:
     *
     *   SYSCALL_DEFINE2(foobar, const struct foo __user *, uarg, size_t, u=
size)
     *   {
     *      int err;
     *      struct foo karg =3D {};

and in __scoped_user_access():

     * wrapped. See unsafe_get_user() for reference.
     *
     *	scoped_user_rw_access(ptr, efault) {
     *		unsafe_get_user(rval, &ptr->rval, efault);
     *		unsafe_put_user(wval, &ptr->wval, efault);
     *	}
     *	return 0;
     *  efault:
     *	return -EFAULT;

Without ::, RestFormat.output_highlight() in
tools/lib/python/kdoc/kdoc_output.py does not treat these blocks as literal
code, causing Sphinx to emit unexpected unindent warnings on the closing
braces and the efault: label, as well as inline emphasis warnings on the
unescaped pointer asterisks in sizeof(*dst), sizeof(*src), and
struct foo __user *.

Finally, in __scoped_user_access(), scoped_user_read_access(),
scoped_user_write_access(), and scoped_user_rw_access() in
include/linux/uaccess.h, parameter references sit directly adjacent to
token-pasting or dereference operators:

     * When the scope is left user_##@_mode##_access_end() is automatically

and:

     * The size of the access starting from @usrc is determined via sizeof(=
*@usrc)).

RestFormat expands @param into **param**, turning these into
user_##**_mode**##_access_end() and sizeof(***usrc**)) (along with *@udst a=
nd
*@uptr), which triggers further Sphinx inline strong/emphasis markup
warnings. Should the comments in include/linux/uaccess.h be cleaned up befo=
re
including the header in Documentation/core-api/mm-api.rst?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/878q3q4qby.fsf@tren=
co.lwn.net?part=3D1

