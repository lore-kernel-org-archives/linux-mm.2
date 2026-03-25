Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3324109C05C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079326B0088; Wed, 25 Mar 2026 16:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002C26B0089; Wed, 25 Mar 2026 16:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CA86B008A; Wed, 25 Mar 2026 16:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA28C6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:50:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80FE2E0F1C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:50:00 +0000 (UTC)
X-FDA: 84585777360.29.59DCE1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CC9C120010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:49:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gppLDZ0v;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gppLDZ0v;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774471798; a=rsa-sha256;
	cv=none;
	b=ZzLOBhvLpM8JiUKNWMczrCAacP+91fbtdCXaBgoA/fHjq+95Pvk1pdLdZB9u7HK+fxDFRG
	3On6iGEvwnZbsSlFLhcHH0d0llh/Bjm8GdoA906dd0NpXTJKvwGO/+q/QRLqGv2xPEK/0x
	KTegE/lRUrhSwEiWOOTl1WkoSfzFprU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774471798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7cKFzcJHpL9j4Aat/RZIzjWabg/dXzGe55O5nZe0Dg=;
	b=o965eDv9pIWKGbIMhHSGZhKZPV39ayyoNO/VxzoZQgQWODTo7wcjG8pcbhqDqrX5fNdoNA
	Bu6LVj8+lVyi7+zYbjJ1TXvD7SfUdHKWb7JXA2pneMmE5yxsW//kD7OHyZaSDLsc3hmqd9
	H8EERZV0vuheUHR8gWvGdGZnDX1S8LA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85D9944299;
	Wed, 25 Mar 2026 20:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE30C4CEF7;
	Wed, 25 Mar 2026 20:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774471797;
	bh=12gWYwz5+UXNYe/GprR8bIjp7XZsuOCyWF6dzqhGQgs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gppLDZ0vI9UUtn6MhYJMTujUQ4p8ZgNZMcHSfqeyZlJAB2FxSUKXGOCdge0xcuU4w
	 QBHBp6LX4BHGdYiYk6pRJ/E9xIbk24RAnwIDsyNtcSpiKpQcUIURogQ5qxGFPxurSl
	 8y9/PUMDxd6fcoKABFgWXVaIxQZQLG3VLEfi+4DQ=
Date: Wed, 25 Mar 2026 13:49:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325134956.0ceceb29a77fb367d657815b@linux-foundation.org>
In-Reply-To: <93f3be43-0883-4fde-86c2-a35f8a9c999c@kernel.org>
References: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
	<20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
	<3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
	<8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
	<0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
	<20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
	<06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
	<20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
	<bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
	<20260325121549.2b887a8a8c154d5bf8529ea9@linux-foundation.org>
	<9930979b-7bab-430b-ad29-fb35f36712b6@lucifer.local>
	<93f3be43-0883-4fde-86c2-a35f8a9c999c@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CC9C120010
X-Stat-Signature: 51iu7pwgxqd9kgsyguqyjszp93j8n17m
X-Rspam-User: 
X-HE-Tag: 1774471798-739485
X-HE-Meta: U2FsdGVkX1+YD0aDD1vL5I+Z6Q+OhcPejSrmhFdMoOZ9UKjLYCHGoQ7U8gnilufWbEIk6Z9660/CloZE6oE9v2UdfYlI7GYIv8ZXxzzJ+zQ7mZ3I8mc/4x/nWFftl4z/5DJvmOxxo4YwkMTIOW2s2FUFgsay3JQkpmuFhlf//k5dAq9jXcjJzR0I7AssIcDayMlXHp14RBWcFMmaRsrwC1JxQhdk5+ooGWbZbJrcOKpz3mjZaH197vdTYQTEG04ow2wZF+6Q/Lz2CkwUW5QbK6rhHhgmlJE5H6jIQcTsHBljZIt07AmDu1OndnS2vKRjpJfhxxDvfrTu8nsQBqc3FqW+VGPeQYlwNZ6BIPjLc2z9ah9axtY/NxiNqGmBKylfSVbUVUpSZa7UbMffHxjcGcpQbOv7wRt4KOZBfEdBIflO5EeB3tD/g7ZGLd+MEBld7udpgcvRwI52giQUAqMT83sL/qY6ikec9l9H23Uv3ojaBCsS1M0RQu6UgdMm3RpaoZG9G1yC1tGSfPL/T0Z1wo2r5Goy47s/qWOhp9ZmOZJhBQvrnrToQnvEJByFLxlWvgRSOd49BTckv9We1gVjk0C/2qJKQ+ZWjFzZVmKQPqpTOaHSyI7B2uok7arzMaWFLh8oXZAwufT7mdc2sWN4UcFrpwAZeOLFtxDepS5YW7Lfi3R2HnAzLaJBXCr+G5hF0K0a5gYh6E6yLzvlxUkwlAr5BSaCW1OTIZ114ts6BPjEa/XiCFX25Nv+wL9AJZSE7jN/73tHn81V5cw0tJ9mEZcGFrVvRJVz3dEgv5/zD3b8FxxXSu8atq22n9F+mGULpP5unQuGgYvs0yAneGrVr7NRtCyPUvuB2IqH8PWeF5HxgrKtn2zS4NfmywJut0HZLLorUfdmSrRl7W4KEIAOPUc3kEETJvzAgMA26d3ZWTfN2fZNv7wZqRO8nVrtkCEIE8rjaBBiAo1e3dQ3VDn
 GVLiVURZ
 IRIamHjA0hyluexGcdEAj4BjLuu78jYcUPqnWsCfWeKnEixwAhTPR9jBHlJN/puaaToB6u6iajIqjUQOFyBKaX/S2bRcbfR/TY1bsu08o3Bi/0CwxuZ7lzvnU0mloJAG2Av77NZM6Jcmtip2ygIzf9iv+G/ZsK/hNyDCnJk/UWg28MTFVq0RJ9A9Rerm3VZRmzwxcKtSdP3K/IIueYjAEp+GTwj/9BEIj+nfWYbnKoNPLFBRo8dRUOo/RMI9nxcZ+LNzV0TWigO+hgqMVzt3Oc4mwWbVtz0SsnflG5ZXhuCkpAuQxo6dMHcpv5R3rf5/rzs/ay0kxdvdgmDVOJFLT74DCFTrnE06MORVq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 21:16:11 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 3/25/26 21:03, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 12:15:49PM -0700, Andrew Morton wrote:
> >> On Wed, 25 Mar 2026 18:53:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >>
> >>>
> >>> I mean instead of having a separate commit for the fix, put that fix into the
> >>> patch before it and denote it with a footer as you put above.
> >>>
> >>> I guess that translates to what you do when you rebase and fold the fixes into
> >>> commits as you do now anyway.
> >>>
> >>> I don't see any reason not to do that right away, as really it's good to see the
> >>> combined change in one go for all practical purposes (if I resend, I'll be
> >>> combining work, if I can grab it from the tree and avoid a git rebase -i all the
> >>> better).
> >>
> >> OK.  So what have we concluded here?
> >>
> >> Is it: if I get a -fix, I add that in the usual way, then temporarily
> >> fold it into the base patch and mail the result out for fyi.  Then
> >> after <period> I permanently fold the fix into the base and add the
> >> footer?
> >>
> >> If so, what's <period>?
> > 
> > To me it feels like that should be 0, just squash it in right away,

OK...

> since the trees are being rebased constantly right?

yup, the mm-*_unstable branches and mm-new are blown away and rebuilt
from quilt each time.  And the quilt patches are rediffed and refreshed
during this.

> > And that means the tree contains exactly what it would if the series were
> > re-sent.
> > 
> > David, what do you think?
> 
> How often was it helpful that a fixup patch would stay separate? I would
> assume "not often". :)

Not often.  Sometimes a -fix is messed up and we grow a -fix-fix.  The
record is something like -fix-fix-fix-fix-fix.  I suppose there's
slight value in tracking this for a while.  Not much though.

