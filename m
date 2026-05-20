Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2B8CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719446B008A; Wed, 20 May 2026 02:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9FD6B008C; Wed, 20 May 2026 02:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF8D6B0092; Wed, 20 May 2026 02:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC3B6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:20:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF427C06D9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:20:28 +0000 (UTC)
X-FDA: 84786798936.26.8BE103D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24599100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:20:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFfMKWVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRoosjzRf37h/pwGsiGi0q+5SXjtwTQyz/NQU3Yaxn4=;
	b=G2Y90TZY+1PJdPJthQKqlI32uq9pGH27Q15rr+CtzpaTSd6Tuwu7DCRNXu5VJiRzVsPdUu
	Tc8uwQ9Wp10uiIs/tpOnPpUZkRNtPTWc4Nxfiwj+EjRtS9Us2ryteTeGkNkSan662v0Fp5
	1T+Fel4Lw8+uoeN3QXpPeicyob+mpP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258027; a=rsa-sha256;
	cv=none;
	b=g5o0LMQSv0qJD0o9gMzFrhoAnWBunwLSEOJYRBz5djYpoLEj05bGpaylTClPzx6qjXLT84
	+xOaNMZVpABOuydtABILzcXaiH3h/alSon/7HtWD0kVRjePBjaMV+Sx7H4CMtcBPUsav/8
	gtRgPqnPCAynhkJeLQad1pDk9Gioxa8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFfMKWVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C68360145;
	Wed, 20 May 2026 06:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E141F000E9;
	Wed, 20 May 2026 06:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258026;
	bh=kRoosjzRf37h/pwGsiGi0q+5SXjtwTQyz/NQU3Yaxn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bFfMKWVYCxCew7k1X8OGwRXHpwzHd8yu2IBtA1oQScIcLNfE+UBK9SwpldZtYY1QS
	 3W+9hy78tfebrfNK3SYnvhYO/2tI3JIVMADL7C/TTZ3GzgcezuEO9ccB/84QgLTaOm
	 JiMIndWClR5mU5zUn5XCU/8JeaIEN272URXRyfkzZ7lXXa9YbzCUAFFjcLxumB0Deb
	 MTgR26XMxeah36rYSKpWI4MrOBu/DTKnQMjoaHOW10apJ5dJQK9X48PxrMGTyzAKfo
	 iubUT/jY23fs99cqvM1N+8rCUjrlgUMmG2Nyx6RABUswP5ZmulRNGZwNPA132qxkGN
	 tUuBSFa2Bv2+Q==
Date: Wed, 20 May 2026 09:20:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
	dave.hansen@linux.intel.com, david@kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mingo@redhat.com, tglx@kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Message-ID: <ag1Sog3zDcJuOaaE@kernel.org>
References: <agqwZaEtwXg4-O9z@kernel.org>
 <20260518085700.69849-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518085700.69849-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24599100003
X-Stat-Signature: d377dfoqsmzy1ygxsqkbop94w976bghg
X-Rspam-User: 
X-HE-Tag: 1779258027-366453
X-HE-Meta: U2FsdGVkX18PPhB7gLE4kL6/S0FBoO5MUnf/tzUDHlfbn3S9j6p7AcH9R6SlNYSqyQ6aNMicr2azr3q19EhhF/0Rtsl49wVTZbJYp50P4MCgWWxpjEiIw4uQorYhVfXN6f05sthC/giShGncVu+Pv8jQZd6x/TD0Ioyehubm2Jd2IA03QTIJBFs7Fc+Lz1I1Azgkeg2P4LgYQPwPWi05s6vxLYbXZCw0bI/oPQy/02y1VM5+zdpKfX0e2fSYMhyfQU/LSSy5oTFR3dWe4SGiOwyHrja0VnduROZfAoKYVa3sYCOCuWkbTfHSg2YOrMu1TqyyfuRPTUMdshUPRIl89uTL1EbVMJHXqaDZvxiqlADQ6/5AD5bC621LIpnpYRGAM5IgFFBLjqyJ4a4OIHfXQN+WTsuDs1GV44t7JGsRjpAJ1N9ZbDpkMhkNxt0FE67DseN36J0sozzwVDAjq8UnePgQQpTFvLxbJmfFwOQLNbLFPvsF18ndx39ARB018i4KEvm8ChMSb8DPLsJoi2NSmAYObkwx+qDDJ5Fz2ouNfSJ58tEXysXSViEMGS7DOzsYDl1oZegDm8wLN+7wQCnqjP9r5pWU2eyUvjBtImak85suAub/mMQnTPJwuU2TilBHsCijn5663AONRdDTmdSccuYcVBYbgi8+3q/3XJznxqIKmQSZeGM0tFw/8CCW8N+1HRz1KK8o9+ntnDvADRMwtYdonIkN6U9smasyeKXaasDCrV+xJB+UhaMeuzCac3yWXEKL7yXtScfY1TfKyWmIAYlX0ejIvEIf/hmuI8qPchRZ2ACNvpi16s3aBTZSPp5rw0ivEDlcKxUAdVirk05M6YCD8QpNOCxtl8NpJUOx16ed9Pb5bBYNntGK8ub86TMnNmG7NrbHORNDlLqIo34H38d2hyBM3PFrdJNocu2EkmJ40+gl9qFdQfOxa1dijHagbF5VbblFYeQTCWY1Wcs
 XQPrrHVb
 6/IRTcwHRgy5u73soq6oFfu9Ia3P8n5oV2nUO2nR4H3ZjqfrodnzQQvF4LWtSUq8IWIo2zDw0mnSfDGSrHmbXvJldl8ExO8O/ak2/Ig7ARo736tBYmIF1QA+KpFMXYBLAfg6OePOURsYY4TOho4nMKN6n76Ng1rdwdAPmTvwzbKSmfQuIPdWrS0NYu9hoRWmzQbx2G1zjnR+ugW6tqvEPLlaM+M4z3RJE08hpbX5aeWQWZ8jjDWT2oRFn97aClyy1YYkM8XYgxQN1LINw/rjZ7dVpAtVJxUD2g61Km7KnBn7G3TrroDMn6Hywt5Swt4cr+kwSvbJz76lo1ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 04:57:00PM +0800, Li Zhe wrote:
> On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:
> > On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> > > 
> > > Performance
> > > ===========
> > > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> > >   Base(v7.1-rc3):
> > >     First binding: 1486 ms
> > >     Average of subsequent rebinds: 273.52 ms
> > >   Full series:
> > >     First binding: 1272 ms
> > >     Average of subsequent rebinds: 104.59 ms
> > > 
> > > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> > >   Base(v7.1-rc3):
> > >     First binding: 1515 ms
> > >     Average of subsequent rebinds: 313.45 ms
> > >   Full series:
> > >     First binding: 1286 ms
> > >     Average of subsequent rebinds: 116.93 ms
> > 
> > This is really good improvement!
> > 
> > It would be also interesting to see how the template approach would improve
> > "normal" memory map initialization.
> 
> I also experimented with this approach earlier. Unfortunately, in the
> normal memory map initialization path, functions such as
> deferred_free_pages() are invoked shortly after struct page
> initialization, and this function performs both read and write accesses
> to members of the struct page.
> 
> Non-temporal stores via MOVNTI are primarily beneficial for streaming
> write operations, where the cache lines written are not expected to be
> reused by the CPU in the near future. In this case, however, data
> written using MOVNTI is immediately accessed again through regular load
> and store instructions. This results in an access pattern that resembles
> a write-then-reuse workload rather than a pure streaming store.
> 
> Consequently, non-temporal stores do not deliver the expected reduction
> in cache pollution, and using MOVNTI provides no measurable performance
> benefit for this particular workload.

We can split initialization and freeing into separate loops if there is
overall benefit, but this needs to be verified on other major architectures
as well.
 
> That said, a template-based approach can still accelerate initialization.
> Based on measurements from this patchset, it should improve performance
> on the generic path by roughly 10%. I would appreciate feedback on
> whether such an optimization is still considered useful.

Improving the memory map initialization by 10% is valuable.
 
> Thanks,
> Zhe

-- 
Sincerely yours,
Mike.

