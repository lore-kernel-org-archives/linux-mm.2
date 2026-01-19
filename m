Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D47CCF2EC
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC776B0197; Mon, 19 Jan 2026 06:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0946B0198; Mon, 19 Jan 2026 06:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6916B0199; Mon, 19 Jan 2026 06:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0D586B0197
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:41:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77CFF1AF05E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:41:03 +0000 (UTC)
X-FDA: 84348522006.19.C41BFFD
Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A1FB4000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:41:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="pRxL/2Ui";
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ux9EqExLk0S9sgu0sjfNhFAgqMdUCgo2g+8tHNn15AM=;
	b=7tst1DT/BJA/W/x0NTr26Y+YNxZn1sg1pleDwp/oco/Cg6Nnox6sUH49XI5aDmz92m1CvW
	ulsAP/P5l2bw8SlREUgS3S+74PXfd9EICIIFu4l3qE3EJjA+/N0Ug0Q5dND8bRXmusVVcC
	oudIXKuyOQGfATOqRPa8zsbmhGCdTHM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="pRxL/2Ui";
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822861; a=rsa-sha256;
	cv=none;
	b=kT+2ZBszic676CRGb9XXCiV2K4RNE1S7PwduUi1qxYQwvBY09fqJfFZEYm4mz/TQQOjB5f
	YGes1k7bj1iksIno6z2F4zjJklIi7+n00VEXC10eNctfqaQv5L2r4luNb5rjuQ8baAMrXp
	CCeL32BgWkYgLpzUzhd2v3v9uJMpEf8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768822859; x=1769082059;
	bh=Ux9EqExLk0S9sgu0sjfNhFAgqMdUCgo2g+8tHNn15AM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=pRxL/2UiG42qu4+CQqrtO5UF9UiauSQN+YQAWAADjLskNXOBsq0mvOBxIujdfP+ZU
	 YXj5Ln2wRfzjarBYssTZtvAHPrJSnqZB5pjO+5V86tm0+KJUlS3Gg9iXm/Y3ZWgDW9
	 4+O+nLDVr5TPVvd4CRCvC/0mn5x0LyXxTxz3v9t41FIVaRaXcLIM38yodvgPdZOIpz
	 xgS9SgHH8o/dyr7m6Ha4i3uVjAQ2Z4s+/J+jsh9q60eFKYRF25674tXn5hmNyphG5O
	 jQ6MhDU7s1fKoy6uJYxFmVhi7/rYTF0TNVUdEGNLfxEdbuZJtzqWpzrNx38lGq5+r/
	 sGx7ihvVVep5Q==
Date: Mon, 19 Jan 2026 11:40:55 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <aW4XiqW5-P-f0_PI@wieczorr-mobl1.localdomain>
In-Reply-To: <CA+fCnZewHBm+qR=zeJ4DG6RJ-mHhLhF9G7f_xSaNt_PAogJv2A@mail.gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me> <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com> <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain> <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com> <aWkVn8iY27APFYy_@wieczorr-mobl1.localdomain> <CA+fCnZewHBm+qR=zeJ4DG6RJ-mHhLhF9G7f_xSaNt_PAogJv2A@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: e92e8e19771804293aa60425c71ec8789b768681
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A1FB4000B
X-Stat-Signature: 4wsdntht1qid6dc96apsngyyauy188h3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768822861-777889
X-HE-Meta: U2FsdGVkX18vnBGkCj+uX1m5Bs6/eUuQxEyDvfXWcgG8PoXbbe+yky+qoe+NGchOeD+v2iJgeOeviGWKph9YwOL9EDE/Fa2cphU6L6CCJm4vqmIL7QPONCnY7idsNs8kbtkyo+U/o0MkWenCQmThC18Q6i261Jm448qm+1lvvrMFfolSTADrNKpFyrD8NrV76E+h5NPLo2a3/2GUMkfO5rFNxu8r7tp1llMgOSTFrgiVqitoEs+1E86cm8/+AoQKYUypPUFoBkLul8+/+BWXUa9QM6xGrIy6XyAvM1LdrAF/lzjNBj/IgRxb9K7+OD6R4mZt5OfL5SU8p89LEOMIpYQCY7QQBU1zRA6Obh+lEt7XVQjnCTdSAkisdmaUDxKESFkKTZGg8LglhIJ3o2MrM1EeyFGtPYCPPyMwvSJo2hBan6U5wNK8jZmpxdf+mWtjBjKrpO6nmqngL5RejhFmWNF/WmbzhDrVTLUh7ctzX5eIFrqsKA/jV3ckUCNFKgaSrXqARf76nS1x0/4qtEbTzdFvgudLSq5irO7r0roQko4hDjLWFkROvx8E3yDCJ+mNjEtAjPGufciHrE9/WZ+9VTibVMMz3a213dkYXxMMwLDCNkfOHgGGQXjoz2A84kvQ8nSvYgRXywnUPk4mbYWF+UM/FMTZOzBII4/jQ6V79ezt5vvY+fCgUdbeP2/2ZKCGzDg3ccwZbtQROMYfqAaslU1rESLsiH9UcVoDXsLvdecbfgz5TZrUsEHlfbW2YOFqZNfQsgCCjfGtwIDVGcXf4Ix7hfimOyQrUSlysQDDXbRHlxy+rUrjNx1UWQra2fP+QnHxm7DGipigzG++8wd/yknlTuNTtaabCO1HwlFOm/Tq3ctwLbWRoxUH5KzOlYnE40V0Z6K7UQkoA13wDJKUr7hPx7pCjdNxu7fqYkoq6vZtRFNYSs1n9cq3NdnVFdule6w4a6iSyV1mWJZ+t2u
 cnFigAEQ
 JfkHgMw1HomNH22/6b8tJ6A2ucyNVcZw24DiOdt7IVdjs/zpkoXAU3qF3AOKOCU1N76HpBkZ1LoQ9n5NZ7r9uMvR88dKCLspnZyNDH3a6M6WJSEhxhssfRGKZg0oWS7mQiRHc4y+VF7OEd3LbMCq8EjSwNWssv8itgbuZVzvAGX4SzmZRPRne8BkYPHfrql6/oWWQStC7XN2QXBsm4g+2oK/nCJVNFMYcZyWQNVksQEd6H2n2pFQWC/TAUMwYxnUWiaOnG5mCt7tDlcEm7+sr57+AB8N8caOU0pg4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-17 at 02:21:31 +0100, Andrey Konovalov wrote:
>On Thu, Jan 15, 2026 at 5:43=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>> +#ifndef arch_kasan_non_canonical_hook
>> +static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
>> +{
>> +       return false;
>> +}
>> +#endif
>
>Let's put this next to kasan_non_canonical_hook declaration.

Just occured to me that, as opposed to to kasan_non_canonical_hook(),
arch_kasan_non_canonical_hook() is only used internally in mm/kasan/report.=
c so
I should toss it into mm/kasan/kasan.h instead.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


