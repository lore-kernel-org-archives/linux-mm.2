Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DFDD39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6266B0005; Wed, 14 Jan 2026 14:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA37A6B0089; Wed, 14 Jan 2026 14:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5B36B008A; Wed, 14 Jan 2026 14:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBECB6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:19:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76CBF1AE304
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:19:18 +0000 (UTC)
X-FDA: 84331532796.04.D820EAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C39DC40002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:19:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7mkoktX;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418356; a=rsa-sha256;
	cv=none;
	b=du5Mjf+2lP7clx6cK1+ZfobtLlEMlwi9q9Xpv/GcJKGwHRySaOq4yNkc4vtiEEOFNhKDuK
	r7057zSAzh7bOBNJjp6HmiI0u6FgfTZWgur2Scjr9spb/9+55jOPhEFq3Q/3fkKLjvNLFK
	kFoVWC1KPJfYpPmrxINlTKx2NJqhNAI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7mkoktX;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48pxd7azFqEQddtR6G3+UaBvVGoFI1N2sWGg6qeVLpk=;
	b=OlFrZmIhHk7AWNyoqAguyGtTdhRK9OhfJqabdvOljL7itQ5m+2s047wSl51sX5++iYEb27
	xLTPU2aAX+BIJjon/suSPC5VagNcsx6uj5Er2bp8NlvNC+snIOXXn7qDFgFYfN1IpPNxMV
	TCSX6nK2dWNlHKGPgsZnTiXp8t4ihuA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B110440CB;
	Wed, 14 Jan 2026 19:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52919C4CEF7;
	Wed, 14 Jan 2026 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768418355;
	bh=PbSt1EkBjctA/aoLe3SvAGeQvdWaG+2+t05R+3HiR8Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=L7mkoktXP5v0/RPVXM+q7CecPRvSeFXAVpTa/6Zi4HnKjplmUZN/H5wnjKazdmLdp
	 H8M4zx8EUPxaLtXjGTqFH4oB6mjnLPWC/BSPgdkl4h2qIjZ/HPjQL5aCE1C0JM/lhq
	 Le4s1EByn67fR4X3Sa7CgHV2tayNiIxZZYNGWS0+oRh+u/liq2Tsmx8K7sVndzLSmb
	 B0Z/FnUjSciukjiyp38oAqsfq7wdzGJRRZK4KfYUMTPZauyEEJt4T0srAwNTH5//SU
	 s/XWZE0wl+KGlzUFup0xv2Cgj76r0cxJJKixyGJzRWoML2Ql4GrYceFXQiAQ8Lx1rb
	 G7k8chNnYAEAA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] kho: history: track previous kernel version
In-Reply-To: <20260108-kho-v3-1-b1d6b7a89342@debian.org> (Breno Leitao's
	message of "Thu, 08 Jan 2026 08:40:58 -0800")
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
	<20260108-kho-v3-1-b1d6b7a89342@debian.org>
Date: Wed, 14 Jan 2026 19:19:11 +0000
Message-ID: <2vxzy0m0gfyo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: rgq1j7z6i79j811cmth38jrm5bq1y679
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C39DC40002
X-Rspam-User: 
X-HE-Tag: 1768418356-877557
X-HE-Meta: U2FsdGVkX1/KBOqBhnpBiS04F7b5D2K7vmRRykgWeFpQDmrqs/MZ1ac8lzlkKoP5px3NDkkwM3SqkOHJNsXSRhOC/hbbLeuRG5ayAaQHdIfURqRxRbA60OcFUMkbDk4kM7B23idMwfrJDXgrJ5WK6+niJRMaa+I0wfInZvikjie+0+/o98Ck2nnn77PmXegXx49u0ukNwgIUyjLSBsfISby4kcCzz+QWjHmw6Fv/qYbInahUnAoAvizG1QSvNsrMIiXoZjINBpoKNyNnxnZKFBxmEkpCYciTEYkBdZA+cYazkA1PyT6M4LqdthOE61DcGsSshB7NQWXDodIhtTTfkR4qP5rPkKEOJcEuA3LEkfbUXeX6dJpGBOOZk3oFM4EzDUDChCmxQLQdFOQnrK7ACO2lBEycnW9A8WPQO40HNq+iMG/qCJdHpgfwW1Zh1+MxdJUWS0amm2G0oP8uvI+saVUpyFlcmFYjPMcO6NZCybkrsPqRZnZYdLYAGmcaw6k7NKAHk/m9aJVMMoJhr1kA/uuIqIMEAdDIJw7XnbEBPhcrSDBMiEiHTWPQoAiNNpGHZcouUiQe4yPqsHA/FEKMCC7B7spIJWfFH11Cb94trvAZrBhrMBxTpThxlcuCYvbrFm2gvWTy3gxpqc49gcd6V0K0Y0Lb0cii0LAUcXKNGsqRG8q7kRaj8W4smjn/AOugzEANCFT0pXnmLbtWqnQ/IbYgc8v14V1o2SEgsLvkRG/8Ri+VDPuGfuXDoBnQ+gvrcbU00qohTBrDi8IChmezatngga93/uby7wURvYb16+qhkGxIvi/U3nvH1E16ecBJjyov1gXr937EwEO1FwjKM4c0TLtDucKBEGp3CvfYUcPpSPZVb7f1smHfkDgNLkLIWQU2yo7K0P0KXjhWb/Odcp7sZX01/rrPFxI8xPNYKy02D38UvbhDWWhniPbJdKahRNXbecPMdlxhmbKlG8I
 bHTpyVzn
 +JQZycI9YENo0OrYvAR44Q3ojOvoe+MIh07lWPeVqOrM0F8aPYmmuhhDRQ5o2Ut6I7vKC3dfuhqNEhWF3WDyPOz1WfaHEfnlaMy5OY6g2bvbZrgB7OR3LOqdUN7mYqabjDfCrCsAGbTWwmYBfW+fv5wFGOaheB7XbRK38etfFeYAq554ZNZARLYNEIDehPmfNo0Yq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Thu, Jan 08 2026, Breno Leitao wrote:

> Store and display the kernel version from the previous kexec boot.
>
> The current kernel's release string is saved to the "previous-release"
> property in the KHO FDT before kexec. On the next boot, if this property
> exists, the previous kernel version is retrieved and printed during
> early boot.
>
> This helps diagnose bugs that only manifest when kexecing from specific
> kernel versions, making it easier to correlate crashes with the kernel
> that initiated the kexec.

The KHO FDT is ABI. So you should be bumping the version number when you
make changes to it.

But honestly, adding this "optional" stuff to the core KHO ABI makes me
uneasy. I say optional since it is not needed for the main functionality
of KHO. Making this a part of the ABI increases the surface area we
have. The more things we stuff in the ABI, the more inflexible it gets
over time.

Any changes to the KHO ABI means all consumers also need a version bump.
This includes LUO and all its users for example. So I would really like
to avoid adding optional things in core KHO FDT.

The easy fix is to add a separate subtree for the optional metadata. You
would still need to create an ABI for the data format, but being
independent of core KHO, it will make it more flexible and easier to
change in the future. You can keep the code in kexec_handover.c.

>
> Signed-off-by: Breno Leitao <leitao@debian.org>
[...]

-- 
Regards,
Pratyush Yadav

