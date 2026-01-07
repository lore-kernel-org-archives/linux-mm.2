Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9BACFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01D16B0093; Wed,  7 Jan 2026 10:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E856E6B0095; Wed,  7 Jan 2026 10:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84216B0096; Wed,  7 Jan 2026 10:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C90E46B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:18:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E3F01403EA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:18:55 +0000 (UTC)
X-FDA: 84305525430.22.82FB138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE6C2A0017
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:18:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hKo9VFoF;
	spf=pass (imf25.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qxr27IuxLKzANdfB3MOLiqpjhWBXTrgQvz1V+lSWJmk=;
	b=ksZSgiKRTGeGeIjSH7h7+Wh0uu0pBQgUapdBt2EWhaQSl2gs6vCRXokldkJShOGedtvPgl
	g3MUJqAKjkH/IR3nuvp0J/wvQFGQfVcPT80zYbwTP7LNrIKYV7Xkg5dHh/pV78ImFso/YW
	rN0cau5PsDiZ4NkhUGcJUp9T84OAC0g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hKo9VFoF;
	spf=pass (imf25.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799133; a=rsa-sha256;
	cv=none;
	b=h5gd1uApC3PcThAzVm3nDtThTvBhxEM9+uwEqqj9yESBGPhHv7SR4bYycxZDawedZtmILA
	ySeNnGtaKLk9/oaaO/PpglvaKFBHtoW/Oz3ZkKXHybzvCgu0kTURaM9+8uYlWod7PEH2f9
	xHXMWQri4NkrA4i5BgDPIHqxt+Ta97E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16FD76001A;
	Wed,  7 Jan 2026 15:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E0AC4CEF1;
	Wed,  7 Jan 2026 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767799132;
	bh=xPL3Fpbo/v10fWIshMmR+kr1gDEFucXCaY5JfO1sMMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hKo9VFoFYLXs2IVNwu3AXqcLPdopcfM+7h7i1AcM4SEzMXY/jcKTyc3vnNPvsrsNb
	 4w6GT5HorsbuBTVaLehKcGcCy/wCNXbGjsydW/MDnU1Wi72qBxsl8RqXl5bwSmM2wO
	 kPvdRtILXgmS9p1xEoMMLewjrs7GMEkgUIKYy8ARAgMTyUMywU3XEnuyeCv0LbSId1
	 ZPYlHz31xfJLEHGkj5+Hxc1Ru0UKv+UGzbD0URy8eBo4iagBLpUjA9D1JM5kxlo/Zw
	 dWB4xgZrmA0DjOpnIgCGnx4cNDte1KoUOT1il+pJqN62HbnmEpR3kw+xEEUxe5v7xS
	 Yn1SysxrDOp7g==
Message-ID: <01d6b029-e641-4029-86cb-43e7de42814c@kernel.org>
Date: Wed, 7 Jan 2026 16:18:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmalloc: export vrealloc_node_align_noprof
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org
References: <20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: pdr94h1pfkjpit3y17rmdekop4bhtzhs
X-Rspam-User: 
X-Rspamd-Queue-Id: AE6C2A0017
X-HE-Tag: 1767799133-231823
X-HE-Meta: U2FsdGVkX19KTrMD0Ov+6CcVW5yviO4rmmL7PfbHieCwp1Uq4srGRDnirX/GKRB37mvloM1w9R04Eclt1PuOEkLEJlLDrdc0h8cUmdPWsHfydpVnXm86xNaYbKwiuCKuK0FA5S6C1uJqAdS0k2yXABp0GcLi/XRXvADIzEmLugvkbxZqpjQII61lbV0EUEUJM0Dntk3IMWKUzMFjqisN6IletOBGmbPJ6t/ZWeo7GFUB/vur59p2MX9UchqGiUb6B77FP73Fks0TqlCFI3CcSdHIFwazydLQ8TcF3kjSxa4+1s8XFcHOsjRTpG9++7NVGwaPA55Wi3U0f2QchROHj91sR5mn3siM62Md7uYvUctRgfDO1+DjlYriwvllsrb9a9DfWCYTG1UwnwDM4p76fhjDLndA38/aes49ZcXGQO54evvob1nlBUlDxc938fEVo+TH9tv3LWqanBsAb/JTcihpNpiq9csOov4HwwHAtbJlff+M0C+Fgsayxm0UO0Hpu16JWDgjbA/r7NLSzMSPQC8vfX14PCq7pgVNqjcs0ZiqkNfQUogjbR/xYg3ThqQe9QmB3W8aF55uxuIw3ajxgxoJld0cxN1LU3e925pg0yXwaio5apLAPIjbIy7puNssqr2Nl908pj4C1ODlHmDqbsXT/3lz4NPe6YV65nZzl1Oj3KhclwW4/e6ecSb63j/c5p1Mr3J1msx6hgQSryFyGnBGxRSpm3MjOJkYigYNuKDBnDwbf3XNI9zRewBRy7r2L+6hZSWJCQmwjExPRsaSfpO+/UYfATQqAs4fs4HcJO42fHeaUor3pOvei8uP4IH4kuHlNMCH4UAglCApoODrExIH/cPMAhsCPnQK+zKJPkUwmp7tml/7lvshK4LmH3GHsUyYpbRdT9Lk9hoDWZfyI8XnPhKP42n9ErKp6Jj3khwLE5YxMVW44Bo1THxqjVWfVuR3c0EEK3N9KhOjRCY
 ZsuB5wFZ
 xGqJAsA2Vz+CRDUhV4fKpEckWUuGWX90sBAgnFsyXt9hFE8MUJb/ZXk7mIoshY6ozO/uvyzdvUXQHNPVkZOBnVUadOLI8cVp3h/AJoAg3T8z/fL7PknMAA1pM3C22OapDStiIi/6/E0uJqpK3NMXjfRvr2yHtOBaxoXcjOslDHz9Ht5l+KnnSuzwd24VHR4+Po7PoNXxJTY6OpYQ4+AxkQImKmhrD5ebZXlGCWmWvJwPsoEBlV3dvVnhjg7gd+iSz7O2OUXpJO6L3mdQw261ZQtCpA3CpgzYd3BlNF/x79kwMD02mOZP714meoxDvJga9kV1nm4rz7qLvOU+IAUZHaZKdulOpx75P8phUciTQGN8Ggci12EPfuvRSrJyat7DlLzNDrV+7UmWp42ogmRJsrtwdR95HuXc4Dtyb9n0V32IVXbhfwqtm/cW2ngbNRy+kg02M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/7/26 4:16 PM, Alice Ryhl wrote:
> This symbol is used from the Nova driver, so it needs to be exported to
> avoid a build failure when building Nova as a module.
> 
> ERROR: modpost: "vrealloc_node_align_noprof" [drivers/gpu/nova-core/nova_core.ko] undefined!
> ERROR: modpost: "vrealloc_node_align_noprof" [samples/rust/rust_dma.ko] undefined!
> 
> This error is only triggered if helpers are inlined into Rust.
> Otherwise, Nova will call the exported symbol
> 
> 	rust_helper_vrealloc_node_align()
> 
> instead. There is no Fixes: tag as that feature is still WIP.
> 
> I used non-GPL EXPORT_SYMBOL to match the rest of the file, but let me
> know if I should use EXPORT_SYMBOL_GPL.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

