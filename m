Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8ECBD0D141
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7AC6B0088; Wed,  7 Jan 2026 12:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74EF6B0093; Wed,  7 Jan 2026 12:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB266B0095; Wed,  7 Jan 2026 12:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7CCF6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:12:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F0F913AC04
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:12:29 +0000 (UTC)
X-FDA: 84305811618.11.1F5CE8A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id 835B220004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:12:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X3/ew7Rg";
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767805947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJdK6eXQyVsQBxNRB9kThBuGis735HeC+Y10QgIj3N4=;
	b=JsoslbbirTuOtSB+mict7mleoGOI3/Cr4JEdDm1T3Ru+F+wE8fQ6dd/FgVENIp0WBuHxWG
	9Y5uuJesnsWGsi7gHMIB+WioDtqmKJmmEMRrpU2JzjtVjubTOAELEwz42kX9tqjRccmIM9
	3ZeqdChKEHgagCEZw4R2AHe37iHl+Vg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X3/ew7Rg";
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767805947; a=rsa-sha256;
	cv=none;
	b=EQb0+aSrbZpw4ElmUvncKKAPi/Uwmqt0p5k2ZkY/jL2fDAE1gLG9kIy23PfAwLyyyjFAix
	+ttqvsKtPsijgWR4C3SeiGZn96O0N7bM84pHkPLtltp+PVQ9WYbOSgqpgDmHvu3VzPPfaW
	ZS43+3SPisuxdUhOCuOUB0WzvKhHFcs=
Date: Wed, 7 Jan 2026 17:12:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767805943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TJdK6eXQyVsQBxNRB9kThBuGis735HeC+Y10QgIj3N4=;
	b=X3/ew7RgQIQjiwQmXTwXFThbDMFiz8fA9n/fXy1EFGcJVlBLMqeKGVL0HdPGwY3yiKcCub
	uq8POEx90/kApBMcj4Zbe+qveftINkJ0e1dsyhUu+Bt4+k+PHKXkfiKEqMLX6mrtIoZyka
	HMXCxIE4IwN3Rz0uTUi/bb+S7mTwG84=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
References: <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 835B220004
X-Stat-Signature: ihpfophdhpzhaynktgqqkcwzmwtqahf9
X-Rspam-User: 
X-HE-Tag: 1767805947-953171
X-HE-Meta: U2FsdGVkX1+ev1nF2rbJmJ7xyzQQD0BGura0VL+7Mv3v17vCd6DOL0+m9otMyfDQyAmsY8Mv1ax2PsVVVTVxl1z7ytmqr0jFgmCQ9pr03eDsDEKYQBIkEbUJMas1FEeIaQblbGeLOqtY7PqF+/ezp7aBIwihve1PW7wL07ieiET8ANZBIlgDzpf1BMZfIGzjmLInDd6dg0AaJ+NT/HnqqhCQJ5axUJqXzJZFO3z+mzDPoEzrSqYLbBBk8TdoOQjT+FEMfwMr8NOfbPqud1qhhmORYJbjEjZPVvOKFF3FqBmVtZDXGz8D7HgnOOuPW1cNUEJ9HrwcA/YdUxMLLnfv6ugDurnbWj4tYhniQLs34bIB/F04inMHpk0gQ3cjNjgP7OhUVzNBPC39vl1N6jdmXyWTVMhues+mrxQ7m2wFC+zVQ4LdrLx0uYA0/NsXNCr+sQLfk1vV1Ferbc/MHOcpTbfBTvK6s0/nt70xNjyBjsYtYG0RY7hWYWeZpEVeroohcae4BPtEjgv5rn6WtIKZzo3U7fIDMkWHJ7v5t1Af2Ibr/miWJ+62OKpdfX9HoV4POP/xfGgx/xDB4H6u6V+5l4kRpxBM8493s77moHmoEWJsZRsZUWi+lqW8ax/xvAthwFL/OxhyewGOg/0B5crSmDQYZZom+SpX0JVvZkYiXCG8dxMK2RFKqaXhbqAcdrjTc0mAc9ZWbLPdttilgpV7FvWmBSBSdfVjEzdRjyO29z8z5dYegorarlhUW2ISqsasVTgeJQX4Xvp+6ToQK8uCyYwOU40i26rxX5JoH63bUCasZTTvzcRmygJz6//9islcmNyIUM/kLGCHZK00RmG+Ya6KH/ZZW+kAstHk3+3LrtR38iRXWtbTkXqEJTm6KPUhZNROO1SUQ1s5B3dYIB6IVeYTzLRGXPnRpFecf4Z9oOD1IU7/TR1eeeQoCTNB+j81JhYjR27gsJbd9qd8/b8
 OKHX5eN9
 tYuhS64EF8ri441hGx77wUkNhRtrPBmZpSidnWFbFbPuFwXEHnzGPLsrV8A0f98D8V3WrLQL93+Aw/lHDvHl+n6ciHP4jNqfC9oJWa4SuNXZ+sFuqaNzr4xFOtg50p2eKXTK4YBuYONxYWqkTslYjcQGo5E1Gk3tiLaDDVuY7iVIX7Ucl8dPB8g/VnObkUj0nGzX30xuzFkZ80Hk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:43:42PM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 05:39), Yosry Ahmed wrote:
> > > On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
> [..]
> > > Adding native SG support to LZO simply means removing the memcpy that
> > > scomp would otherwise have to do.
> > 
> > Yeah the effort to add native support to compressors can be done
> > separately. For zswap, I think the most common compressors are
> > actually zstd and LZ4.
> 
> I think it's the same for chromeos: lz4 (primary) and zstd
> (secondary/recompression).  zstd looks very complicated,
> not sure if we really want to diverge its codebase from
> the upstream (meta github repo).

I think there's value in using SG lists even if we do not have support
for lz4 or zstd. We'll remove the memcpy() logic in zsmalloc and the
kmap handling memcpy() in zswap if we just pass SG lists from zsmalloc
to zswap/zram.

