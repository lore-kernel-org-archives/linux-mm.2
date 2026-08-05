Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345F4C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B236B0099; Wed,  5 Aug 2026 03:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4225D6B00B8; Wed,  5 Aug 2026 03:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F876B00BA; Wed,  5 Aug 2026 03:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1206A6B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:56:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A54E1203D3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:56:45 +0000 (UTC)
X-FDA: 85066459170.19.F9ED316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 02AF340009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:56:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXlVg2rH;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1+4NHKehW6dJ5xem9fLO+i3kQ3eYgsR66WFXjwzps4=;
	b=O+tpzR5khN8h/bLSrM+DR1wEx+/JWf8eynid38ST4Pj1Gw/T8PkBeh57Mx6e78RsNsRUPE
	Cqxh73fWgnb4+ASiQtu9hBjCHRvH8H13Hqj10Jpl6NPVVAR/ulxSX/wGqhDno8FpjXG9bF
	MQkvaVlllyHPJKavYZ7q7eM2KowNNXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXlVg2rH;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916604;
	b=h64sAcd5Wa2jeQtPpR4K29m6XHQfipz9VwBoSJS82J2e7OBWvLbFCTmldqlIrtXvH9TZ3i
	J5O8FjTsx9iWyy710sDqEfh+q4EfpXAUT6DQZ4eb3weYbEcd/xlUsm7/Im6NfSIVAiB14b
	zqyNEBOHnXkIPucfUFgjLen1hhIGXyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26FF240C1B;
	Wed,  5 Aug 2026 07:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05D71F000E9;
	Wed,  5 Aug 2026 07:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785916603;
	bh=v1+4NHKehW6dJ5xem9fLO+i3kQ3eYgsR66WFXjwzps4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IXlVg2rHg3PlC+qUbgpOulXUDtxMZEvwh2x+XsEcdZMeKjtXYo3z+96yHv15gN/My
	 EK4tAo3j2YaxeCem5uhQ6Dg/uMiUhyqn7dr5roB+OFVTlbRvLJPmmlLEid4Ar98JMj
	 PBlGG45Cr0HCX/jnogtpaQZsfC2JldbCmjQ/NWpS29PNpbvpqH89oihO5omp2k9zMs
	 Q7zehXboti07v9CN51FkIMM3NZ68MWbiagFlhKmb0C5DuvesWornwClHCJmSDvfHMH
	 VcgIn1DS4H1WD5FSCk9IsmUCYEoBPDJFQy5F4S5B9d/8YwoxIudEJpyiCY7iq6/8Re
	 iLRyA5CkcEAhg==
Date: Wed, 5 Aug 2026 09:56:36 +0200
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Alessandro Di Federico <ale@rev.ng>, david.laight.linux@gmail.com, 
	jack@suse.cz, jannh@google.com, kees@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	mail@johnericson.me, shuah@kernel.org, viro@zeniv.linux.org.uk, 
	Gemini <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
Message-ID: <20260805-koordinaten-eschenholz-ellenlang-b2b8eb93759d@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260722011217.45e79a08@spawn>
 <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
 <20260731004604.53c66732@spawn>
 <20260731-batterie-galant-zumachen-d4b91acf8af0@brauner>
 <DKETT5RWDAG9.1AP6L1IJ3CL72@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DKETT5RWDAG9.1AP6L1IJ3CL72@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02AF340009
X-Stat-Signature: nxbrr9uxhkashkeoi7js9ho4ddtkjb7e
X-HE-Tag: 1785916603-229572
X-HE-Meta: U2FsdGVkX1/PAaGHhstm2NtSLzohY+LIbaC3C9cN1ZlT2Mqcsk17QdUaE2uhmbC48H1BdBteNakKPUsbQd/yiaFBBQkAW/p99GcXKR/+jUk85HqLY3h1KPqPG5D2qkJa/EyNEpvUSo9cSA2ekT/9BOdQBbNBqNp5Ca4XINLcICIHQ0pYZfjIHdvYRikDCn6ku/PIIuM4W7YLx3RbhlCEzk/MUe8usAhPKqNTCuU1f0cpd3WuU68FLXO5Fohw3RK8A7ngU+HGsV6syLq9t635SIct4esgSvCeqEBZ51BK66bUpvLwDVaC7VoJrveo2cMvQMz8NX26K2iXOd7jQ5CBMAfXYmzeE+E65HFq6UCUEaWAZdttEx+DbWnf+H5X7AKaLKxy/VIb/X99Hp6BX6UhJXKcZzSHKSGRuFCkjdn/M2OkQ2hkGiojHYwk5096dU8h7SAYES9MtKVKQNUCp/0lZyYKCHM2+6kU2/KBwkh+I/zekeIy8Lkfx4V2JoJBI8vuclL06MN8pB8Js/0rIqiHt4/atBO8y0MrqUi07n5qFG5FI6oS2ItFuYgI8GjYMv8lN4u9i9BTlEONrKm8UEfCg2sYk0GUqVjRoXrbv5lpb2foWkNjeVwjDIBzM6CQoVnNIPzrUQgw4WTu13HoY1LhxnhuHn2K9FfeEICum/0oDHu+KWdv2eiwCYDcYPnknYxQtTgjyeXgxcf1igFLrKbZGOFREjLTW9Ex4mIhyLvJJTxmyPweuKUEDRiB9Sy2xSRL+1fuE6/AUof9XLjgD+MUktrbMxnrUM+O/jcM0Y65kTjoAhwRLk+OpshF9JhDvN/wzk99Cf9MYULdCkVNFoIG6+DzKsTD1uHGF3Y4j7Br3iH6nbmfxK0+cdW1UwNttfEu0PgH+PGU11UVZ0U2cNiUAPlA/Nsvz7Qd3CC4BJApeqImPmmwGywEy5gAQGVj3CW3kDCRS4KLpuJP+8ygJ1J
 UkiMhkz1
 jYYhrnlDAQuGyeHVgjIhcoTYZYzV4M37W/Qr1CJ/NRR4t5bud1KXXTeSfmc2P4ltgUv58jODLsn811RfL/uGzO6yBTagK8bttLWgSvTkXkyL2VPqrEU76LXogoDn7IiNVLYKg/e8U1yK/XEHN7o1I1BmOtrAnTtzS+hE/g0/g7Pcwvfqx4a8LMWShOpFSfKgcRVe+FtxFmPNvi8ZA+5pdzsheNQPtd2oIxoXDqFhM3QHBjeePJ0FU+bXrAYWE/aaBFB1lSC6EKne7weIH3oVu11PS6wNAPd7xem8e0jUot2IjL/TDnNRZvyFZhYFbQwLw51bxi1ADLFxcewjT89YnYUu/soVcYyHccw/E5RtABQ/kbBGUapiyCVnCN2xjVPto2b0aYzWkykRp+1Lv/ZuvGOeBd9UB01V4xfgVFIL0xQKg/us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Christian,
> 
> Could you help me please understand how the next branch makes
> its way to the kernel?

-next is just an integration tree but is intended to only contain work
that is going to be merged into the upcoming merge window.

> I see NixOS Offers the latest as of 7.1.
> 
> The topic for binfmt is named on 7.3.binfmt in vfs so my assumption is
> that it's slated for 7.3.

Yes.

> 
> So that means when Linux pulls for 7.3.rc1 I could start to test it on
> NixOS? Maybe 3 more weeks?

Two more weeks - unless Linus decided to do -rc8. That happens rarely
but it does sometimes happen.

Note, I'm off this week and will be back on Monday.

