Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07E7CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B5D6B000C; Thu, 27 Nov 2025 05:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC2E6B0012; Thu, 27 Nov 2025 05:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2942A6B0027; Thu, 27 Nov 2025 05:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13F6A6B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:36:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3FFD1409ED
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:36:31 +0000 (UTC)
X-FDA: 84156032982.14.442FC53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3031F18000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:36:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hf1NMK2q;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764239790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNmzWWsgqJxfeRSl8Ws2LR0mw+9gWICYac2eBvVxBpM=;
	b=Z+9KxQ5YjxNe4eBqqpIknMbVWa5Fo0LQw65/87UKHdvdJ1i5KsfcHJ3xhAmr2LiYSDVvP/
	7y9pLHjfCNwlFGIHoRVmt23ZQ+P0GjuPqcywJ5sr+zsbTIYqunvbtBpvcscpOG0YTG+dM6
	eE3pG9iv1DDmzHygf3TxH3uGV8wRG/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764239790; a=rsa-sha256;
	cv=none;
	b=Ur+vSL+jfp/fDUxUqJIaMgS3zS3T2O3Zf88ffz9vDNf1pCc0yqtirjxrvz45mqRKEsZwPS
	J1hoWr5nE38QYUCJMQ/R25xKoUgKw5eX9UrNqyweXBtsxhuPMvn2be95dKXxeo0/xdFJSh
	x8HIalN1IaZBor0zPQqixaJiIVTVmOk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hf1NMK2q;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 872BB6013F;
	Thu, 27 Nov 2025 10:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E3EC113D0;
	Thu, 27 Nov 2025 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764239789;
	bh=EW7fa0YR0eAojjarOFkeA2S1shqTF3govz1KNpd+VNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hf1NMK2qId4G69jvB9K1jaDpSSbHc9z7L7hEiWYkXA+owEUB5rhk+3dXMbQSrEm2e
	 jTbTzwS/D1rlaSUmsddYIY/nEbhUMvcF54rbGLh7n1gRgiU8ILVbSgj1y1ehcf9VGH
	 qjBQGzgdBbS7Vc2FfR0TFqfMRW24fVG25hOXyZHffhid2u0bPGbZoZljVSsCbOn+Sl
	 glfuRo11li8xf9HdqBwO/vOolcd8estetolotsVKfGGiP0HQ74MWLEgaQWzyz2gbS5
	 3HlD+GwWe7UUm7kOJIqKAC2BV0tU/ddVj5mS7ilS1V4HF9VITB5LacR3Ck+7s2TQSH
	 LNK7x+xRw2xpg==
Date: Thu, 27 Nov 2025 12:36:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aSgpo1_ZSmxf84-p@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
 <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3031F18000F
X-Stat-Signature: u13ckzrefsdf46syf5zspz1t5twen78m
X-HE-Tag: 1764239790-135939
X-HE-Meta: U2FsdGVkX18avJyWeZg0yO5Bn5o883n7Rp5Ze8rACb/gk18nO0IgGBPQS19RXNia1IrWoWVK2oPRR27fdTuopA01S274y2qe6wPDc9z3SzUOPWmgpGUf8Bvoyk9WwzGUJ2/Zr5mNX9BAmfKGJocVLcs7qM85GIrzv8hWOnFDHUygMVA6JBnJQBAYtGppOYe071cBMS7MaAM32pzWvwSHPkJ1WyRtIABTrFPdS2lNvOyYUpyJXjIxrUPsYPQHpXfnXy0vVPpr2fdUyMbgg/Z4ZlvwP2Aj/Hooz/GvOo0FY7usKNEpzaRH39Qko5KC3DNOTmhX0Ng2QkBjHgBDgRs1ZR1kRLkFof4GWJyNLcPMqAKNMEHz1jxRuMIKE7Z5kfajg6YfdJsi3nmfn3+D+ILvB/ypdzcnNSEEZHuJQh7VVm8mU+iK9NZmgEdX3+6h/rjonCCKL5gfaYkXoZl0Prgwy9rRAuIizR5rYS4g9+GF8oN50TVh7owMZae1GxSRUMPyfzr7nilj/tSveI5R+mLYwB/Ieqnlo6edZL2lYv9gP1+Vup23ll9wTp1lOcC7NX2IuSqdUH27ft74McjC6UVepY86/JSk7X1DsidLjuDgJD6uPXjvXuCHF20vAlcHlSWT1DuDh9y2lPkkeDlBGsvYhdZBtYUA06hh26dEcSStGpgzjhcWBwEX8lI2jRhCd0yK2tzXs5OWX9cnoV+L8rLp4ZgYXnnwKFwhUuYf5+8M+QQrNxkV5Tk37SgEdx3ZFP5tdYSg5H2c+Z2+OKi/RYYQhY032vf2eAvA3U7pkXxQ/G5rFuvArfyh+10mQUuOa/HPCAsCXqFSaGmaa0NSjZuQ6tBMd0U4ZGbgs0Jw/kET7hqaV3i0+ic2iiAG+5MsFsnAcobYs3PFD1GXTvB+3Gp8mQWgFBaE/8vvccmrtXia/DHJi+O1gLTEDQ9cBrodItmJ54a0FkPxXv63F+cSUm6
 OMBNxnKt
 xvyFCuZN1zgcpjkpTtMCeYL5VLL3oUUeCTyeRvXIcNDhJdFEcW7vfkHbl8doX/OqRxrXguVC3NYtPJRO2LyR/rmxBv6Bfcbiv8tYjScHbtsTR4o0C6m8egRyP/REeg4odEmqBjKWOJCwcRlhqS7XzuNWwVhLJBsBONiDd/qgDVjLxUziEI60znn67Hv/leL/mofNcmlqRJ33XdTICG3h/W4zAIMuOcHPblXL/Qmrfjdbs0x7agP+LAzMUrQcWOxmwOhSuADxxCkV8YuMt90e2bIRPQIsSl87PiEmvOTXY2fNvdIx4E7Nt4QUSU+zJOpAhjQ0e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
> On 25/11/2025 18:38, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > +#ifdef CONFIG_USERFAULTFD
> > +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
> 
> We have to name it differently, otherwise it clashes with the existing one
> in this file.

It's all David's fault! ;-P
How about kvm_gmem_get_prepared_folio() ?

-- 
Sincerely yours,
Mike.

