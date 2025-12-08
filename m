Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C9BD1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 01:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD156B0005; Sun,  7 Dec 2025 20:11:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E5F6B0007; Sun,  7 Dec 2025 20:11:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3FF6B0008; Sun,  7 Dec 2025 20:11:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B58856B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 20:11:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4958D140965
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:11:42 +0000 (UTC)
X-FDA: 84194526444.12.446A600
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 779B116000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:11:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zle75YD5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765156300; a=rsa-sha256;
	cv=none;
	b=e6bX1Fzs4gaycC9LMAn+S7L9mD7S9hpNWeLfMNxKtY2/gLFSqzvu9AcnJJtMb1/UYdRUDi
	af4QPq4d+fdGWqo5OI3pjiDh1nYoBNougxm/g6p+CnHEhbl3UuF7u0mfr5B7cleGT7ftZG
	dMt8279q6p+7jW4ZVm1JMCsrFGGlZY0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zle75YD5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765156300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rVqmSkxnEapCQZcc1eYuT2scz6BrFpy/qXEqATvDEE=;
	b=VCX8Wnh0X8llHyLfMC8ErCzVxugFB8vVJ1HtN9cr04cqNyODX2GKHUa36VIzRumC08f1+u
	prv4bJwcmeP4IORfsKpB62SN1G3iLUg0IeJm/UP1caV8I+4Oi4B/eA/HxjzDAt+dN9Kj+F
	tjDUX+9CUX7KEBrR4wyDd2qPELzriuE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765156296; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6rVqmSkxnEapCQZcc1eYuT2scz6BrFpy/qXEqATvDEE=;
	b=Zle75YD5kYpVdaWY3BWgc6rGqQzsgPmLBxe0P+7p4H/j5jxzX1C6zV2SlSz/xBzKOLyRJUPy5ZRhN+Xy+oqOoyQdG9ypVUm/EnUyf4+yTqiYbfVl22mxDQ/Q/F9yiSpn17bOOpIId/9UBzcrc2NMBxLKTbMwmiR9AuJSwfopeyk=
Received: from 30.221.145.74(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuElbFK_1765156294 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Dec 2025 09:11:35 +0800
Message-ID: <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
Date: Mon, 8 Dec 2025 09:11:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 779B116000A
X-Stat-Signature: yg79rqmjwps3hr4zs38d4bropmkpct6t
X-Rspam-User: 
X-HE-Tag: 1765156299-183414
X-HE-Meta: U2FsdGVkX18r0GQzO+NXcl8Vas+MH+etUsIosW4KS4x2gytoAdxmn38IOuoT2ht1Loq6SYS4Ys7Ei2SFXy5h8keDU2LYsOcpplG2Y0qid/gZbZ0M0NgwGDpsmXzkr3D/vBAulQsHXnlati0ak3AvPhCW686lcDbLBeRacyaRHv8rY+1MOV9nQSGdwhbmEv7TnSuBI/KjhCJaw87JHsNtc/1MgqGrZboyC8pbWy4Zokk8LOCIMrHnAvy1KzxSt5Lbjg4d/am5eGubfpOFyYH/wpZrVDA8e+V0FXnapq1JVZMM4ubGlleKhXBpEBq18z4pqmfFugrwRmDIEYtUvST2ScNR6Pxx3Jl6SNaO8c/mJe8/3sgq0pgpvdr9VV99NcO+xGnGxDKWwOSgUX6oBLtz2aYlNr4VOdQGmvzqsu24NTCkgOz3fNqG7ydtlKpjLO0JiCqxlut9eZCFWrIwSMDOxosOxHXFhSOd2b0jv2Os27sO8LkMjaITfmzKNz0ZlpTglJlwXhlKJ16oYpb6RUJVUKRkI/XR2f3XsAffJIbL9MlFCzqOuZAEawnBAlS9w5jogvVxh/pLVxzSAHfhGgmt1QEnXk7XW+SbeIEzZTmC34blnnVVT0Vf+PTlCr9vL5MlhSXLZKuRI3pdm2wncYDTyCmqj+7Ar7d2C5+kW3l3jvnq4xVGqFhoE+Clic5259eRq/cUfBJnn8tcSTGWCj01a6v3YYl6mzxbwW0ctLfXojXU4lOc030aDU70HEEB7JkBtFzN0RQRItsJPPHk2ZSbv/foIxggGJ7uyZuBlTz8DokKC/ktvN6XZEyoXaMrJiE0yO7V0nD7KnPWNdhnLYqS4Ey7M0ZF4O5xpfoZ+hurLw4CkFASWJv7vS1BIsxHNlIeosh4+/4nWwQDtMYHnkDs2TjHcqmDp1ZH6wPmVWmQ9x71jWuT7FSt+AXWRkZyX20QTBMX2wbUFAORNpYUndQ
 Imfnufml
 x+ZtHZKkYJV4VouRbPXUiskpO7tFDoLmhN3VnEtwo6S0a3lRpMhzurYgcuYMQ8z+Ustr3xBO3GXoT4KDvOmdRZu7gFp32GI/EjpFEtZh5/EuEh2gpQLgr9Pn7x2C1aP9R3ytjkDoSj7Qn6BCB2nNnGjzDW3ver6y49mUBl8uzzN/p9A6DYHXXCZ2nTtLJamGtl2rngjMex5fKkIytc9wcfbPzYzsZkCqGclMk9hh6n1+ow7aJTfpkDmltgqoyDYZQYRHY18fPKLVaF0iV2RlMbWtw13pD0ogOaP52G9UAhcs8V8hF8cptBVS3sLVXFx1ab3Oz19/MJ4tE/9iarqII2koZUBNQJTy2OhCtEq7+3W+JtZyKGiwVd7VVDu61x7A7ThMq22dgSWohqoo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/7 07:40, Linus Torvalds wrote:
> On Sat, 6 Dec 2025 at 11:15, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> Dmitry Antipov (8):
>>       ocfs2: annotate flexible array members with __counted_by_le()
> 
> This causes the build to fail for me with gcc 15.2.1:
> 
>   In function ‘fortify_memset_chk’,
>       inlined from ‘ocfs2_reflink_xattr_header’ at fs/ocfs2/xattr.c:6365:5:
>   include/linux/fortify-string.h:480:25: error: call to
> ‘__write_overflow_field’ declared with attribute warning: detected
> write beyond size of field (1st parameter); maybe use struct_group()?
> [-Werror=attribute-warning]
> 
> And the reason appears to likely be a bug this exposes, rather than a
> bug in the annotation. But I really don't know the ocfs2 code at all,
> so I'm going by "the error message is horrendous, but I can follow the
> logic in the code, and I think the code was actually wrong".
> 
> I have "fixed" things.
> 
> And I put that "fixed' in quotes, because my fix looks sane to me, and
> makes the array counting logic happy, and my fix may well be the
> RightThing(tm), but somebody who actually knows the ocfs2 code needs
> to check it out.
> 
> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> error") which simply makes the 'last' pointer point to the actual last
> entry, rather than point to one _past_ the last entry.  So now the
> memmove() and memset() in the "possibly remove entry" loop below might
> actually work right, in addition to building cleanly.
> 
> But again: I did this without knowing anything about the code, just by
> looking at the logic.
> 
> I _think_ the code used to copy one entry too much, and cleared an
> entry past the end. It probably worked fine, because the code also
> decrements xh_count, so even if it cleared the wrong entry, it was
> past the counted end.
> 
> I'm a bit unhappy that this didn't show up in linux-next and that I
> had to chase this down. I don't think my gcc version is that odd.
> 
> Anyway, it's building for me, but I really really want some ocfs2
> person to take a look. Please?
> 

It looks fine to me.
Sorry for the noise and thank you for pointing out my mistake.

Thanks,
Joseph


