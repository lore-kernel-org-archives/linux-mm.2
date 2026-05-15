Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B7D5CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 11:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748496B0005; Fri, 15 May 2026 07:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8AA6B0088; Fri, 15 May 2026 07:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E1D6B008A; Fri, 15 May 2026 07:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE446B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:52:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEDDE1A03E1
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:52:22 +0000 (UTC)
X-FDA: 84769491324.02.D041EFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 390EC18000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:52:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDJe5+ss;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778845941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=265NmP87rJQa5PDh1tUu+XWtrc8NhZNLY/hfSClFvzM=;
	b=M48w1yle+kEbyqrNw5Ab4NmUBOTTWwmW6hJ0EJEK1kfSbx2cw9yOsXfFRUlSOIDzICkdCJ
	whTD8wDaMx+uv+e9nbybQDVpYXA3YM+osIt9gq/pst8hGYiTgKJV14MbYSH/o8C4K/CMxi
	R0DmB+1qLmdq0Ngj8IuvIJ8qV7AQXnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778845941; a=rsa-sha256;
	cv=none;
	b=u6wbwGclMF0fylkIRBf5WnWkNYfCeqDIFzOoiH+O+glA+wr+h9Lfoflp8t74r7Nl1pHI7+
	eoKY2lcVKpAaBzBG24FYssJcOvNVQdxcj4+qZJkAEukMmnLdd8X4nAtsrIHMRY1vjz820o
	c9pI5ThzSQtUjouRLv3OcDUxBSI3KBg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDJe5+ss;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D20060252;
	Fri, 15 May 2026 11:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B668DC2BCB0;
	Fri, 15 May 2026 11:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778845940;
	bh=8PaiCWf8AUezg7he7iC2b47fmtUb+20mIJPeEv7U/Y0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kDJe5+sso7hd35pmgzbRec8EJdYFSAwXcWDHIULo7DbPrsDAl6hsi5m0Tws7hwLeq
	 nWZpRus0U9ISk9umHlTdCNb+ibfhrhUAoXMAlFkw6TeLMgFmhxcv+LAspg3ZcUFjN8
	 FZsCkn35Rt0VEoc00wFmuhNtBeWH4h2CjnsZ+tukSsz5wrgZ4CntgmHLEqsJCEwGgz
	 qHApvhZmrQ5QX/FiKlCSUyuA6kMPIFs9pE9dHXdTR6qDLdaoDPIqkuc0ZT13XVeEOP
	 yb6hTSsP+gEYH+VGqakcdb0IiJIbaGhnKtyUVGHiBv2xYKeDHScSELnkDzyD6ifWD/
	 OR01yP1WM1yIA==
Date: Fri, 15 May 2026 12:52:17 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ahmed Elaidy <elaidya225@gmail.com>, Andrei Vagin <avagin@gmail.com>, 
	stable@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y v3] mm: fix VM_SOFTDIRTY propagation on VMA merge
Message-ID: <agcH4ve5jrc0iQWN@lucifer>
References: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
 <20260504195447.31794-1-elaidya225@gmail.com>
 <2026051531-failing-nectar-83bf@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051531-failing-nectar-83bf@gregkh>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 390EC18000D
X-Stat-Signature: rxh18xpzxnd1794fgkz9qgi95j3udyos
X-Rspam-User: 
X-HE-Tag: 1778845941-118692
X-HE-Meta: U2FsdGVkX1/XLvRF4Va3HCxTFhBF13UaiufEIDRegeRahuFLpaubHhdbIbPWq/U0RdhVMZQI17yLaZ9vTq4ETdHPqk+915d76fKn2Daap6ZRVdOwf1X8XpDSyYiWbpz9qycgiitEfpTBAhpX/ONujccfuQMiAFnq2eLycekWfcRqK07hYRYaRTuMpaih0gEFDsMMdLUsr5XIEC5CgoeLhSwz6B+d98q5hia4ttdET1GkZFFWKNmP/G6xHZUzFRWhnLjyzx8+ZjKsLcQywLrM7Z46ngIbLhF72r9mobOunRNWgZTbzL8UdwjhJmCrehPl799aH01Jwnaju9Q2+8umSscD86vQIfvuT/SCgSj3zF3X0EQAk4dNY1dgbPEmbolvCG45yG71FQJX06RgKEJJPTd5DIoi1jODusR/tcj1u/ePKpp+IukzYfy4OWlQMEmXFk5Ei34QnAjofqI0X3ZoRx1jvABGrGpp2t4RSx2RF6R14BnkM10MzJ0FzoaYgxqdTuxryRwTx5sKUm22JSCC33tl5s8yPiR1FeTv9aNeK2PcIuYdKJCtGuw/I/fuCtwWQ/pTNsA8e4CwZLUqfRF2ZNW2+oN1qF41+e2HsA3MZT8GJ+vhtBBn8iIFegD6sPgmkTQdrcQOtFktiExHGZqhsfN2Nyd3MTtsbo7ymikpQZEzHxYEH5DgjxHnNeuUnyI5eSZlxd0G2x+mbqRcU7bOeq1Jiz5GLCVpfOBdhkIP+Rq2u7OT1o/w0OJzQWjpU8e4Aclges1l+JjoXYBFbM4oZ39rvkpatyEoC8r2bybBEp//3DCUWgBW8CrYF7GhJSqK1qrwXK6QjUYJ+M0GqcZZImz+4jM/U8gED1lbc/lFJa7ehf6Z1eUwNRO4qGkzNkIlT6ZqnyqU3XCbG6r5buUA9xV8CMIzqMtR5Q3Yy5oFBFfF3Nu/iGHNkiPtN726KoDqYI3aVmhNTsnlp3KVCpj
 QwNgF+Ai
 71dEXZVdn7vsjT/vFQjFUppukZgDfH65Q1AQB3RTPlDuZVYO1LDj3KOF6D/Tb35fyymMhmaztGF8vsmyMax7EaXfuVBWdd24OIQ00c3pEyTC1chBDew6KVZfFE604Nr9UH2KvHHVyaNoGqDNMyI+fDdGbFDyWrix1mi8D9tdAB/v08wja0QK1CMVd0exf0fzHdpZb+c8Fy4Gvqsjh12K0xPptD4zuAqbOmaekvV7aln34PshQd+nZfj49aRM7mM0rVwY6xgXXzR+FeDsNqgpE4FLqyBhRtFqlMUAFKstDvPr8trY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 11:22:02AM +0200, Greg KH wrote:
> On Mon, May 04, 2026 at 10:54:47PM +0300, Ahmed Elaidy wrote:
> > During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could be
> > lost. This breaks tools relying on soft-dirty tracking, such as CRIU
> > incremental dump/restore.
> >
> > Upstream resolved this using a broader VM_STICKY infrastructure (commit
> > bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn and
> > risk in the stable 6.18.y tree, this patch skips backporting the entire
> > VM_STICKY series (9 patches). Instead, it introduces a minimal standalone fix.
>
> 9 patches is nothing.  Please just backport the whole thing, especially
> as we will be maintaining this kernel for a long time.  We want what is
> upstream for future issues/fixes, right?

FWIW, agreed!

>
> thanks,
>
> greg k-h

Cheers, Lorenzo

