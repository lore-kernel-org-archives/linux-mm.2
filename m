Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40318CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE206B0099; Thu, 21 May 2026 13:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496066B009D; Thu, 21 May 2026 13:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2AE6B00A3; Thu, 21 May 2026 13:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D51D6B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:22:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB6C914070C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:22:32 +0000 (UTC)
X-FDA: 84792096144.12.95561A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5596CA0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:22:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKJIuj4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779384151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=AlzKy8zLiXVW3OOWreCz0uBaIrjhWNSN2snhmHYvFec=;
	b=kCuLAlZSrUAdARmLHkj85e/XMOPjKTSXeC/xThBfv2SYUR4t6Z8FmWV2lPzjpjBagc18Vc
	WtBhwiXEercV8QUz2F7/c6LkCzVcnDfAouq+n+2xcjVonq1p4TkVo2bcn2+aWOEtYUBPiL
	C9gHUkKvTfk6lD6KVQR2mxOUuR/GV9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779384151; a=rsa-sha256;
	cv=none;
	b=8JxtRFnmDhpJ5sgOCSJZ1V6o6FKGK+Nd01Mw1nUFRMtatgIk5yf5KW7ufLJwyWYH1JV+6r
	RiG4c1mbWjgjJ+R5vt8KPhFzhReiGP+c5XjBZsq+qPJY4WUSh06Sl0qgFFRD8ejUnWcDcA
	Ze7T3J78L2spiCnoUFh9Sm3yRK5TBC4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKJIuj4G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34314438D5;
	Thu, 21 May 2026 17:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29FD1F000E9;
	Thu, 21 May 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779384150;
	bh=AlzKy8zLiXVW3OOWreCz0uBaIrjhWNSN2snhmHYvFec=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RKJIuj4G6CxC3qvs89BfWMbcUoDSq208cSVcu+n+piDs6pYGX3tDnKJJp+wyEpHQI
	 zfUxFkRf6rqU3CJqN1pP6wxooh9U3NjM+1ynKMmwDjMJ2wuEhEaWjBQRv2GCiudUKk
	 tJuHFTXznYMDXkaP/pjJvyWq1OAXTOoYM2k/2JCDJC1pTk8+4K8wfZ7e7rZAUC7nRn
	 QnMWl0LV1raXD5Fb2tTHOkjsG8/RXyC7x1eS47hWpdOdJc3MnWfetSleiaOD6JugM7
	 BJE5HlqjmfJDsh8jjAnbWtXKeRzJcN3q9opWMQRnDTlT+jVbgUCD1I3eFZAWBMIFmy
	 6+n2MkU4nQvrA==
Date: Thu, 21 May 2026 07:22:29 -1000
Message-ID: <0ea50f62b8255cc0ff1a96206096746a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
In-Reply-To: <ag66lfvACAEAI9w8@gpd4>
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-8-tj@kernel.org>
 <ag66lfvACAEAI9w8@gpd4>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5596CA0007
X-Stat-Signature: y77mm6kgt95m8h14cebaxy74sdega854
X-Rspam-User: 
X-HE-Tag: 1779384151-380007
X-HE-Meta: U2FsdGVkX1+nZHPbkaGSD4qvsdmOIf6f0rtO3Ikn6RojhKLmdpnjAjoigWRXQOWx4rZrFnHtI5Lf+v42giJXBJQjmyb8ZYDGRgUi2vz0vpoEfbaJkj4tpfnSXAABDXd7AuVYvLIR3oOKbLdpb5d/RXeIrTPob2X4JLnK8A24WyVmdVBpL++aO6ADIfxYpj6ACBpN94WKR+Vyq0a05549Azl9AQLvo5WmUoGHbtguYV31Nx0Vs+E8F3Z/75c4lqkMjNrGGtMAHXTUfD2eCvqQUcDjdd9raQDjnq6JwnVAReHhxYcdxv+54ntbZDoOQQlznxxWPlZig7xRjp3qxadGKW90AbEwky42LWfnt4IHEyCploOTRPVdQB3AT3vqwcLwd991L+JCZd+sI/ZkXIXT4+BZx1abWA3U/mTayZVE58AF5xDVky9EleqxXXYH1QdvkaMZc4FDFokczBwaqLJyTabWd4XXUQNgAzFIdHvfOjuZS4/EZEuF2i8fIecZ7ytuPAWvX9+P0bMyu5EoCftARXd8ONf0qUnMi7z6tWmQvbAZ6Pg7Qtm9UJJbisUlrbgItXeaJQyuRTOdJ1lSwFpnTVGr/KF39Tzn+fyyERX644bvNxK7it5nTEOCk8jUQDNgdnayiVxmIddjcR75ggVXw/ScoAEVqmQJCRZhIU8UUWtV6jRUpkPp5TkOtZjZlpd+8LSnF8XcVEU0KXqS5xtc49WMwT2PuVTUYiak6oMK1ICU+/69ZdzQmsVI2R5zIEA929R7QtqBxkgmPBxlmkeUNeGPaA0qQQbNCJ1kZLCg1UTJ9FgRSdGoNHzQSixPB4UXNqtqz+fKJGLNlWk106CqU/99B1XYq4d5t0iGL1VX9XF4oJihhp1EARr2QKqHBjDPVk61lo4+VWXFH/oGPydEksSAqvoUixfm9nMnp9zIdEckP3eLj7qf2c1+JswrOqRygHJ8P7Ke+ToeajSB7Aq
 uZpdPKRm
 OqjrL+pRUwWPbRbJxGkrxGD02IX/ZIU+8JeATxqtolinx7ysTwoCh/dPzTupdq6x5JP3ssxneWzeiRhAxgouSx5TXC9NGd0OeaGKjfuuFtZaty5qCZ9IIWLizq90cd3+qCoQEF1jJGn1jHr7YZkZUD2O2p7gG7BMbDB4f6pXfI+WzOrrMa/zW/KPP+ltI2N4q+ih6koHq3BOff5DMoXSiMPzy8Lyi33DIzst2mtGjoKmWOb5nKf3ls5mZJyjbv+L4+V5s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, May 21, 2026 at 09:56:05AM +0200, Andrea Righi wrote:
> IIUC, since @page_cnt is sized to cover @size and the new chunk is added empty
> to the pool, gen_pool_alloc() here should always succeed. Should we do:
>
>   if (WARN_ON_ONCE(!kern_va))
>       return NULL;
>
> to catch potential logical bugs / future concurrency / exotic configurations?

Good point. It works for a single caller, but a concurrent one could drain
the new chunk between grow and retry. I'll switch it to a loop.

Thanks.

--
tejun

