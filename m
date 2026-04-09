Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DF2E9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8985C6B0088; Thu,  9 Apr 2026 04:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8499E6B008A; Thu,  9 Apr 2026 04:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EDF6B008C; Thu,  9 Apr 2026 04:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 650A76B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:04:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1C22BA009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:04:04 +0000 (UTC)
X-FDA: 84638279208.16.F04EA33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4175614000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:04:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgytiDwt;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721843; a=rsa-sha256;
	cv=none;
	b=tjYGeV893V1tfxAEVmDg157hj58WaXaxN9U3zg1gf7NEKw8bcN5QzoRYy2Ax+UZ3nN7FOR
	oXwnkvDvMd79bAztsm0v0EPvY1unZgnABm0Pk2IYN48G+WcrSrtDeAQDFufQMvVK8IMwhL
	4ScH3lwHH7n6ZfYQygZQMdjagyz+FH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRGNPUtpRswK70iMLBYC+Pa6fNL//yXjl1W4GqZSscw=;
	b=3jCchdjMvIl9xEBrhsL+OJ7u78166eEQh4Oguc3vtnm/LCiW412E/H+/yPo1tAIvgh1G5k
	CNRPc9BMto8aMVOxgYbnSkvLrGpn8kZcTVoOlTuVcpGutBhTuycJ83uXPRN3kMywPLIzjs
	pg09lbLpEd7gDw7iVSKA+HGmQPUml4M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgytiDwt;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BFD140E00;
	Thu,  9 Apr 2026 08:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B89C4CEF7;
	Thu,  9 Apr 2026 08:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721842;
	bh=G2ZJR48gQHdHGhWfbPFbOSyHC6zZ1l0MoaQGw2C7Oak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bgytiDwtrQUnhP+4RBfPsfweYkSoLJlcqMjWZgQvft1H8bo/ZuURAdBynkBlivQ79
	 x23fW4+brpjAHzYdS8JKxxvv0UNwldnu40j4PiOCgg7joz4IGCDUQSZ+Jp3B6L+Wqh
	 swYO/kw47QdR5k0RR9QaTT+DeUwWeGz6QxfurRhkHbROtUAA0b1Q5ZDJmVUlO3MPfh
	 Sox2kWgoupLwfcZRwczznLzd6H2CIPCTtAM65+TXwhYDCuQYjHBI6KOZLzQE5A27Fe
	 Vw8SYH/1cEdJHTB2xipw7YeZm5R+AXamw6HHzwPB7/bl3+ehguRguJbmfz5stHABCl
	 HLvhFnIDAT/Tg==
Date: Thu, 9 Apr 2026 09:03:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: anthony.yznaga@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, 
	shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <adddNM1yDJ6tWXsR@lucifer>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-3-anthony.yznaga@oracle.com>
 <20260403123120.82cb5becb19e1b572d474394@linux-foundation.org>
 <83b56ffb-6e2e-4c9b-b0cf-9f04b61ebe7f@oracle.com>
 <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
 <ee802934-0be0-4c33-b3d6-38ef713e6bf4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee802934-0be0-4c33-b3d6-38ef713e6bf4@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4175614000A
X-Stat-Signature: sgru6oznm38733wdrrguirghahp9eob6
X-HE-Tag: 1775721843-566892
X-HE-Meta: U2FsdGVkX1+OLtULLKtK19dij2IlBCqs4pCht6nlFz9VcP4l73Tg2k8M+t0hmQh6qBj2Kzf0TIpyLb7uSXjmOqdN93gsQsFU/4YTmbB4srsHbwMNwMGg2g6oMR5NpK4SRzPnFIsqPJPwS+DcIw/1NaPLYwydnf2ZiqyXOBllbxy+sInaaD4iVbmwFfWZaGdeyIQjD0tO4xwPUfPtKXx6HnRb7pAFYA+bGFOHVBNILrtBbuNb8rK3RE+0WhQyh36a0aMxS5oaIUlTjMD5Ul7wMA6MiJWXYZlmT1GURRdpvdPSFzEtX0g84+PPss75HVWNapIL8bmhAVX3ar38tHthEb/6ZNL3pfC3Gxl3W410xrmPR4cuMWyd0rGwHIb7TwHoyLMbqPi9sDFxkeAhEmIdchrXfm6tpmXro1jc7N8qvXO8sn1/2gLDjucehsEn9zGWXyUwx4mrkll5LxJ8Fm1N3QICwkBSX6Z/4nofnolkKSCcjm+K3ySsRG90QTbo/038OmBmqIAZc4moM9iZMhF7siaEFLSv1hTXt9zquEoIE/s/vsJaKzGJcwB8SxO8d07VBmx8XaGo77z/N4YlwalsCDLTCzd2+pI4bBEcc0UGZrjDlEM6SRdTg2oTGIBrZZWLiAVI1zkcSKF60QxNwx8p0SVgBjdwUJ93M2lhnyEVGcUTUI9IBuKVdy4e+swwjuU6e5kZRc8/Tft/GsoBOldu+3A0lnvhKDakeBEKslXhPz8dxgEFhmncxcQCnApB/2PWVaN4W27Pv6tGqrxZpmPmoE961QKW1+nUGA6g8HyZDb2S9DBKei/ZUD0BrQVDxIdtWZ3HtO/LM0HGYm8oWsci9lGcoLsAtVeC4U2s1igWumu9gryUjQ1tnv7rWjrqVT1hKCHnI6ASSsSes0tMV0W5yQNnrixXaCBHECiapSaQwkjsSm6FcDyKSYFr5pSqYTEIEVKifmXICwRrFt/LdhG
 cCv1jMWP
 OONOet6vp0wl4EcIHqQ95lhVWo5op6DqYdU2LSmrE9umLJPhBemjmx8cJJ/jvb4TvNA2GT/xDINf26ZRF7wyjpU211D4CgVghpjr6AlpM7ErsixMRhNxE8OEQAjboNrGi/U2KQUG769dqcTEaVME7fmjJJ0B7Z48An/a4nhdUuiOnIxr49ogk9xCgG9uLoSlDxEs2Aj/QBsyMFfI6R8gSdpTZMJQaAvU1m+Cyz9vfK/gJDM5Nvr2Dm90EbGkfQBjFqapZd6me1Mg190NkYWAWSNMwYfvVyYya448CcgNRrqHTw54RbdhtEzUzS7wOYnOjBM5VQtxjKYO6QCHKagsRBO/UNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 03:26:14PM -0700, anthony.yznaga@oracle.com wrote:
>
> On 4/8/26 2:02 PM, Andrew Morton wrote:
> > On Wed, 8 Apr 2026 13:35:42 -0700 anthony.yznaga@oracle.com wrote:
> >
> > > On 4/3/26 12:31 PM, Andrew Morton wrote:
> > > > On Thu,  2 Apr 2026 16:59:33 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> > > >
> > > > > For configs that support MAP_DROPPABLE verify that a mapping created
> > > > > with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> > > > > be locked if it's created after mlockall(MCL_FUTURE).
> > > > There are a few queries from the AI reviewbot;
> > > > 	https://sashiko.dev/#/patchset/20260402235933.10588-1-anthony.yznaga@oracle.com
> > > Interesting. Of the two issues, one is certainly legit. I need to add an
> > > munlockall() on early return from test_mlockall_future_droppable().
> > Cool.
> >
> > > For the other, the question posed was whether the tests should handle
> > > possibly being run on an older kernel that doesn't implement
> > > MAP_DROPPABLE. It seems to me to that a selftest should not be expected
> > > to work (or even necessarily compile) on kernels older than when the
> > > selftest was introduced, but I don't want to assume.
> > I don't know that there's any policy on that.  My attitude is that
> > selftests are not intended to be forward- or backward-compatible.
> > That's why we ship them with the kernel source!
> >
> > If we get a selftests fixup then I do like to backport that into
> > earlier kernels if appropriate, to keep those in good shape.  And that
> > has the effect of reducing people's motivation to run a later kernel's
> > selftests on their current kernel.
> >
> That makes sense. It's trivial to skip the tests if MAP_DROPPABLE is not
> defined so I'll do that.
>
>

Yeah in general, I think we best-effort try to keep them working for older
kernels (but no guarantees IMO), so checking if something's implemented is
cheap-and-easy.

Cheers, Lorenzo

