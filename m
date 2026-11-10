Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0DB606B2C3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P9w6SBPv
Received: by kanga.kvack.org (Postfix)
	id D75696B05B3; Tue, 10 Nov 2026 08:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D7A6B05B4; Tue, 10 Nov 2026 08:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62A66B05BA; Tue, 10 Nov 2026 08:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F29D6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:33:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1053A0909
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:33:38 +0000 (UTC)
X-FDA: 85419301716.24.822457C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 55C311C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:33:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9w6SBPv;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnFBc5/3J+ldv1POK+b+j43xPTAaqz4dP0Xvyz4JmJ0=;
	b=ZHmaaZ1UaAK6Fs/f7LwdTlDLnKKfftRfHuE+mmrRzzkWFBST427Z6HYzZrDm9vkwZ7gF9C
	TcF5WYZ6pBe/BG/gEvd2rZDCIbAYSPWTazq5EHvRCo2DrU1oKzowPEtfCvgAcHbpT5WcvC
	hf/9/zYhDUXjvvdngL01M43PZD93ty4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317617;
	b=AOdG/E+k91p23Rv0JTJ3oYQcvzVQe7E8/U4tgzJiQiB8g4WIsJl5ltdby4jPi1JqvdIxoW
	lPDYgGZAz+o1Q6lQV7ZrKyLFCcFNttsLVFvmHMGM1+ko30dy3OWmaRWdIAWlpHtCR+buz7
	cFPlTbvfFph0PUuyEwqv1gln5XUFXPw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9w6SBPv;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C42CD406B5;
	Tue, 10 Nov 2026 13:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B41F0089F;
	Tue, 10 Nov 2026 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317615;
	bh=vnFBc5/3J+ldv1POK+b+j43xPTAaqz4dP0Xvyz4JmJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P9w6SBPvJauunn+tf4ys4VQ74ac/ir9Wol/AAZwJaJu5GcWcbXcjTkAf/iKFotS8G
	 QscXPFgFD2ReyjJ1UjgOmo0o3u/whiAwEK3ZyU/oLtmYD82JdBx2KaVpXXoGWSugGI
	 xp/xiBmgP5Ph6X4cACvZ90BEBK/nvzanJSIehWA0pFpx+j0GZfHiXVjS/lMMRQSeof
	 u2clJWhGOlBbd7FXOWLXsE3kJ1Cdtd0hb4BpOX4nseOK/LZWVYtMa03dJcdA42vFDj
	 mdrNG/sdnLu1NEl4JDR3Dop5xb0a6bdZ5RikiC7t58drb9tlehqmeXsAcCC1j37aqH
	 UM2MbNmwDb6wA==
Date: Tue, 10 Nov 2026 14:33:33 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: Genericize x86-specific cmpxchg16b comment
Message-ID: <avMcw2Poqn2uk5cl@thinkstation>
References: <20261109035906.10857-1-yangtiezhu@loongson.cn>
 <DMQW32TTNOPX.24GN6Q7VI6QJR@gmail.com>
 <145c23ea-bc4d-b235-c822-df94b00a647a@loongson.cn>
 <avK8RqLl69zIkVY2@fedora>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avK8RqLl69zIkVY2@fedora>
X-Rspamd-Server: rspam06
X-Stat-Signature: 3ietjqo5m4z4bfszn3y7htszfzrq8nni
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 55C311C0004
X-Rspam-User: 
X-HE-Tag: 1794317617-435970
X-HE-Meta: U2FsdGVkX19gYkQUUPfTd6bb9ZkjFagyL2bSYSezkBuGZtsOJOJSQmHDt1U41k8s9+2juVVsLjCC1Y/fakXquvfhzn9zKoOHq9ckL1u0gpHuH/RhCpGH8hsZKlfML/l4R2R5EbEZ6gI2YBvIyYl7K9p+6ug5NO57A4Zx9DuU2zfmwzthIttMl4Fr8jftVn2hzViIaEgeOU/MgGcpLU6pej6uiMiUmx2z9e1r4quMDRh9FQCVJvKjR1DXzZU4pxj2yWk0TQGI6us/GA5tv0xZQwPTuZNSDOWPMY2caVpy9VGpPqDts3CgYz/FFkcMLN2zWbnjSlxeXFhJ2nL2k29NVjIHm4lAN8SfQGvX/Jj47Xqs062KLhtbPwnbFUn8SXQAb4FGJSO58QwcCANA5MTUGPfyjVWFfIH0SIKI0kGQXrwrDXHVdr8JFUskTTh4SzJ7ZDJtox/o/YrctBCXrnF6IMN35mhwRlR00afwBI7qsv9FqeU7jtHQoXqt2+ZAvKPswKVVVMxw07T5GBz82JxlA8Sowh/VK2MwC6xrydWVos7++HDY+LDhqoLOQVhMduCaj5WuK5ITA5ZeZjOyBfkcrlpYz7FhvjxM89iqXXuFqerb6ekvecM76IJrhhS3IM/rA9cglKzhALm9+U772mL4kWnWt9XLLVfcxZeqjJ3PqRa31DDpIL4xTMpMFtzfrRLxR0aC9ZwkumdGccXcMlZ2Q1cOHdZ5+gM++8VtHj0IHZrngqvc4Uur2InCqi7b15RYWs0ncGdCRU1acr/PM4skZ+B09XSGpUNA3ifNk/q29wBB+nKbZ7aCz/VsGt33XqPEge9kDipnQPmtJFjtTiByTGXv6Umn2YJ1nqHqM8Ak193bR6crU5WrczM3LNFxK5U47N1Ke8A9m2Vvf2ECAlMajGxPmRmrZA8bX4IuHrgxdntRSicU9OkJ+LRdC6fRnIfckFvPX+ccC6RnJZGuhYI
 dKHM1maL
 gCsD+d2gDxBroYm5RB95ImXqVwvkPs+fMBorRZ0FPmwMOIJ/V5V+A0pqLGnAXFZo7cBKiP3J6MHP6ql3/kTCr0QYZEBG6O3GVIUu7br7RphrQudi5ZF2/P3Vr8Nvg6RWcQrAM4srzuFZ91nbzpUlt32SH+UkZa5KZKux+dou8oAm7rhshcV3lKBozA/zTYGdI57cl011aM8j62wLElD8ggkQBP7PBd6S0bhVo7Lyl1a8UuTvm2E0fNepMQQKg8WwkLKQt1f/IgPc/3YeT8+eSfgkdfU58WYSKfA2pxgIAc0OasZM9yclrKvj3I6TNPIdIHUsBR8b3aDCGbN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:05:14PM +0800, Hao Li wrote:
> On Tue, Nov 10, 2026 at 09:29:04AM +0800, Tiezhu Yang wrote:
> > On 11/10/26 2:25 AM, Alexei Starovoitov wrote:
> > > On Sun, Nov 08, 2026 at 07:59 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> > > > atomic primitive is satisfied by different hardware implementations:
> > > > (1) arm64: satisfies it via LSE atomics ('casp' instruction)
> > > [...]
> > > > Update the comment to "double-width atomic cmpxchg", which provides the
> > > > following advantages:
> > > > (1) Accurately describes the cross-platform hardware invariant.
> > > 
> > > You ignored Hao's point about shorter commit logs.
> > 
> > If the following shorter commit message is preferred:
> > 
> >   mm/slub: Genericize x86-specific cmpxchg16b comment
> > 
> >   In __kmalloc_nolock_noprof(), update the comment from x86-specific
> >   "cmpxchg16b" to generic "double-width atomic cmpxchg".
> 
> Ok, LGTM.

Looks good to me too.

> > I will wait for a while for more feedback from mm maintainers and send
> > v3 if necessary.

Please send v3.

> > Thanks,
> > Tiezhu

-- 
Cheers,
Harry / Hyeonggon

