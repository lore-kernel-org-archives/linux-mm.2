Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F7CCF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84E46B0092; Wed, 19 Nov 2025 02:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35556B0098; Wed, 19 Nov 2025 02:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972676B0099; Wed, 19 Nov 2025 02:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 85FF46B0092
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:36:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DCC81603B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:36:17 +0000 (UTC)
X-FDA: 84126548394.09.1D623F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A04E94000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:36:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=t3NbtU5e;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdrsuAUdpbqqunVqp58ReSXW32+mjpcLGlUNrIEe4eE=;
	b=4/xywTnWf02h5QJOgPmqMV+TAvShNRec2paHmXWgTYhwtZJw3NuaSQfMOZE7DzwdV3azuu
	HnfgqGzaXGRu35a3e4WuMOWArQgipf8Gbzsiej0WL8OynUed7C5+0kX9eYQWDwkpyqVW4s
	76Vj6GqyuILzp0lqyK5j3jdMoQwF8jQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537775; a=rsa-sha256;
	cv=none;
	b=HVFbQKRQPnWsl5EAAX7hQ1Awl1Qof01GShXOYw8iQbFXe1j1mVivPiiY3JoFXRg2KE0DZW
	/IOhkZlQg1p2wzdy+ngs48NdXcYj08luuIK1sKb8E1fbJee5kGkwFqakiL2LJr6yJfGd6Y
	7zvzqr2rvCLy/hXG3t5+cZodvR74zHo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=t3NbtU5e;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5BE460203;
	Wed, 19 Nov 2025 07:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18C1C2BC86;
	Wed, 19 Nov 2025 07:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763537774;
	bh=1Wyir4dUb411OJQcXtSbnzdCRtoxa2Xp8KUJcJ3isiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t3NbtU5eN3FF6zsiJiXq1AUAzSh7rwLD677imzgwtElqgiiZBB12fdPuxr3vmbCln
	 UnAvNFc26kqOfagNuvvLFcPyJfcFOenRr7BKPOzgQOgJYV/1VUSTDeaTOp1EvpIGlA
	 KOX9ejJhtRoMceQOxstmIpYyZSno0JPW9NgO7tNo=
Date: Wed, 19 Nov 2025 02:36:09 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
Message-ID: <2025111944-tracing-unwieldy-1769@gregkh>
References: <20251118182416.70660-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118182416.70660-1-pratyush@kernel.org>
X-Stat-Signature: wwgnuuyqw17qhmgaz9j7h3t7w1mpfcgj
X-Rspam-User: 
X-Rspamd-Queue-Id: A04E94000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763537775-51313
X-HE-Meta: U2FsdGVkX1/YzMtLNGCeePqO4KG2jNIGd6sGhIbf+gov59uw6qH8sHw7No0jynakOtDaQyJg8CPRUUvRaaQQXW5HzUxRfsa1sAHvOmj5FqiA8mQu/g9LlMjy6bdgk+MhYi+Bo3r5qe/p4B3mEa7C4zlkQRisd59M5JN5QW3jFRNRe5n9o1MFavqM8iQsJliX/JSWKvfFe83OUtcSOcrwh3JtxZWQ+/6M42dHhVi0Egy5TUR3vKYWM3SB8ZX/I5X5Tvykd4acXuM6tS+11t+lTJBqz27TbJIgUkY4I/+SnI3JrVsvLYmTrrqJJ2fQqDkNUT1uQy49g5L6LRM+lcxf5tNeubqorQqGE5xDMY0i4gFI/R3j5bvyvUkjy4ZRElMrbo54r3VaXB6K0Jms2YYCb6UyrGaaVHFUnHJy5ZErx0pGXgDy9RWnfOuc5/aI/qt/mExNQ9Np3n2/235weCf5P50S2GP3pKaTmaUlMuifHRiAZlL8ubxtIsoQCdiGbra4z/Q/rffIYJBAqbknZOEjxaPBrimEXJKbMbPLcrE+B9NkibAFcBahS0w+RSZa+c3yVAl7Q3Z12YkUUfRidFYRCw1hxCe1Term6qqn3lGNdLlfETMIGThygr2/NB1ihnoT8G+dIKBrjV5S9Ru+JyTpB5hF/ohIXJ/rVbw6yb8wYafRH2mHFszouqXiNY6jKWhK0nf3kN9K3oTWjRfR+KbMstJoRcEf1rEYj2S/Rjf87nu514KgDUFIQMExsbEHxXmrpOSXstSMknfXgyx4fOt87PCWCMitdSdRuxjbBNdJ+If4RqWGZa32VMytHeqnGW/Dpnn71a4RW9YpOaU0rp0/evMfkdjPW39KeWvQ7uX3a0buAyV3DmFFSF7LE0o1WnZkeFGFY7Fp1px9S0FxPNT0kSUt8Gm9+O5SzRd8OqXA/lz0QsLBegjKATTCYUef2y9FKSRQEWAFJdTcsbOIoHd
 i5+IfGMM
 YPIRyDw4SxilZ783c/CVZYGCHUECDSJ1/M8vdDto3JQAIeFnbZVAuAPbHdOnhsRA34XCA1ukFHKPOMtZpdL6hmMwULbTNx/hc5REM4nldcfIAMtmXgTL2yLvxq2Bl0HybGaK/ye6JdGOSBcys/PLhywc3jy/XhTejjFSm/vrULwR/t3zP2RMRzv+cJFs+X5a8VfOpA4jj5Hhn/tX46QHIK0ICu3kLYiXt1O9Lr9tJHbXx1k2aX86475U/G+8mf5L9rICZ9Q7/eAKkk6rpZCMu9T7yTeaF2Jmbvjlk7ij31FZVux1sqq/C6UGLuh4ekfsm3pzL5mwGlzXk68fIvdBhX+Ok1QjWO71HhsLo/DTmscELF2dSmIbPmVGD8ffYLxRsrnNz96qW8c5uMcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:24:15PM +0100, Pratyush Yadav wrote:
> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
> KHO maintainers can get patches for its test.
> 
> Cc: stable@vger.kernel.org

Why is this a patch for stable trees?

