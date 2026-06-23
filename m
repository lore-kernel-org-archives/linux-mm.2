Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D471CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A275D6B0088; Tue, 23 Jun 2026 09:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7AE6B008A; Tue, 23 Jun 2026 09:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF876B008C; Tue, 23 Jun 2026 09:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66B076B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:10:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D085EA017A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:10:39 +0000 (UTC)
X-FDA: 84911211798.12.A11A874
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE30840013
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:10:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwcGsVlG;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220237;
	b=PbLwUq+kP25OCJal2nODmWLENAq0mWNJcuLI2i1FzeHc7ipzYujHKjei4GJKQXSPe27e+Y
	ZTbpWbiQIeXEr6f1ZWex6M2dzo9xTZB+hejdzNzJ6Sxnlmc9MtrgPQZ4FgJrz+ftmaSoIE
	JAmdmenpLtpBjJuM3oxKDko3ms5BVA4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySc/aU88S6zSpYP9xtAHR5MOl3lswAD1LvzVMh44STc=;
	b=nCvXbbAt985HxvNgtBPRWFuwF1ts8gpgJQ4SXeR6AX4HR+XBpI8yUf0UCXloo9Sw6+J2Ac
	vnghyXnstxk8z0K1xoacSlx9cZbJ/glHAmaMyAsus57bJH0bkJbXUYVupriiglzyRPgdXH
	RTal6l4LGeSs89UXYf9UTzkyD4uh1iY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwcGsVlG;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6910E60052;
	Tue, 23 Jun 2026 13:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B001F000E9;
	Tue, 23 Jun 2026 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782220237;
	bh=ySc/aU88S6zSpYP9xtAHR5MOl3lswAD1LvzVMh44STc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=lwcGsVlGmcwleSUa+A8hLzj+NGdzH6Y2I1/rOJSzYRIIYezzYMYMPVrPRQ48p6ryN
	 HCeIPZwTqvHv4bxVit2bpZ55mELXNbC8DnshsrQFi3O/nr5a1TOjfhBl4rzNPpYYaG
	 s0IkZTPen5kAJlYWNL6QNcraZhJlNtSCVnW82hygriTiFyfQFrJGRiImoU9gcgIftg
	 91+c3VMiEF2pVllwdflj8jRMREiydmr57VoaewxsYyrDnc7iwxHs4M43/J1C00L5J2
	 Kx+/vvUqLJwW10wZhEOwJC5uuoRDHWjXZ1iIR3iQuiqlWCA/7XQkBrG6AWazz4oE5y
	 DAyh7BgcnFbIA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  rppt@kernel.org,
  akpm@linux-foundation.org,  kees@kernel.org,  tony.luck@intel.com,
  gpiccoli@igalia.com,  bp@alien8.de,  rdunlap@infradead.org,
  peterz@infradead.org,  feng.tang@linux.alibaba.com,
  dapeng1.mi@linux.intel.com,  elver@google.com,  enelsonmoore@gmail.com,
  kuba@kernel.org,  lirongqing@baidu.com,  ebiggers@kernel.org
Subject: Re: [RFC PATCH] reserve_mem: add support for static memory
In-Reply-To: <20260618224018.117978-1-shyamsaini@linux.microsoft.com> (Shyam
	Saini's message of "Thu, 18 Jun 2026 15:40:18 -0700")
References: <20260618224018.117978-1-shyamsaini@linux.microsoft.com>
Date: Tue, 23 Jun 2026 15:10:32 +0200
Message-ID: <2vxzpl1hmmgn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: x1hky5cauqz3pwnwyk8ty58r4exq1h4m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE30840013
X-HE-Tag: 1782220237-292162
X-HE-Meta: U2FsdGVkX19YKCeDZ9OTNgNCk4fDV5SDUx+XmSeMviANGE+0QaEWB48YJdtuZo3FxM5xHPj2ATiGlRC5S94xUCZ/5u6gLhBz3QFULcB18TAwTdQlh6S+E84+OA9b0CSc8L0jPp6nZqYwPHez7URjfHVdiyLaRD9xxlo2NpmgxIfvkVIX1/W0laRcdNeDDKsyzs+4sPxWLvTLWJRkEzGGCS7P6aBb+nEEJEE4wRF9FOVUCri1dfYMp24/6K0WUgiikD5sEc04Uz8dPgYNnksNoON7xgyDvzyFEKDoYnFyaayAi+gYjyuYquvmMW0TQ4897w6IW0Y5PSNTNVdMxg3dHZ3jr68thMBsMaaAxthbaDieCXysoBz3kk+k0BQTMndQ71v7zqpVL5D3cRs3h2pg2R4LyuIEAoIjK6WXYQKrpbVupk5SzBOI7SiNhHbzeZ5/FwRVDPAGB8FbJDenVlVPhrUEYUMcyNAREzGt69jBk7qkN7NyQahX+iB7SQVkBgx8MuWCTz/8jdp14eetzhwi63hHxDuac9R0bo3cvl4pZvdxOvnICjU3gEu54ImGf/0AvDm3GSjQm1WRp16ahKscsqgpAWv0BIuoL1Selzvq/3LDV7fZQGUoEB0/S+6Qd5BXH3Usmb1xGU/N550KJ6XMHos6tVzQpp1otI0TmEj5+ghohEQyJsF+ecR3fL8pUoUupIdbxPk8aWRmxmDuwQtGT5pSjyqedPho1LTKyoDOY2QvzazSAyD4JfWYCbTEzYzJUxH2a9iUEBC+YD/2WRHv6hDnpeGJwmOsCwWQyQiADN3chbdPLpcKrakowCgZ6vB9A2cxoqNZQHs5O7vOxYtPhRI8Ly1T9FOy7PFAjxxPelXGihQmVhkDbfO/2ToiSAATmMlThdftalLua7mAVSMxufEQnehk4tkUNXy6LxfjrEjsGmisANjNELTFVsEZjEgBmSi0FNp3/Gck84mqprL
 AIMsA7rc
 se0e5hmAakhuWiFsXB7iq5CtoppOaoaWXKrfAuWPc4b8B7X6RbdedcrDwQ1Cia015tEC9U51GE4PhdvSrYOL9bGD7WSYjGpDbXhOnY4/gheVDRmfB+yBkuS8+hHNLtyIzgQJFQeMBoTOV/BFDMF5Ln3MQViA2hqlG/daAoF8Qm4JICsHjiPG23GT3nt7zgB0lJ9LcFe9tfAv/nw7LWbaPo7Ju7Mc9gW2PkWico6mfEzl9qxDlRCNk6942yiEhEtNTf8Ekg94KOrXX5spwrj1XkUS+PAAnspQz4GugZfvsaRLAAb4SDqvjMvLOYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18 2026, Shyam Saini wrote:

> reserve_mem relies on dynamic memory allocation, this limits the
> usecase where memory and its address is required to be preserved
> across the boots. Eg: ramoops memory reservation on ACPI platforms
>
> So add support to pass a pre-determined static address and reserve
> memory at this specified address. This enables use case like ramoops
> on ACPI platforms to reliably access ramoops region across the boots.

Doesn't memmap= do exactly this? How is this different?

I always thought the point of reserve_mem was that you _don't_ have to
provide an explicit address, one is chosen for your machine
automatically.

>
> Also skip parsing of "align" parameter when static address is passed.
>
> Example syntax for static address
>  reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
>
> Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
[...]

-- 
Regards,
Pratyush Yadav

