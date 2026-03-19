Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5956A108E1E8
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65A86B0476; Thu, 19 Mar 2026 07:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C576B0478; Thu, 19 Mar 2026 07:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978EB6B0479; Thu, 19 Mar 2026 07:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 805D86B0476
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:07:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 359F18BBCD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:07:19 +0000 (UTC)
X-FDA: 84562536198.10.08D2932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FF6D140012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:07:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPr0tZlk;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773918437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CV8omsFptplFHRG3329dbSm62IiQAOIJxztrZtHZO5o=;
	b=u0FkEUaaq4FvhDE7ILPkep4RsYAtbnV9ybElGL1Wx88ZUPr0jUKTKDR4EWUOlKx72+ghko
	yLqvN6fridCUT6IOdh464/lxDvnFbxgTvY0zoRpX1MoZ2qirC9CyPigOQTjt8JSgSiF2Jt
	zzUvnQ6LysyOrU7BRn7CucbFiuNr9Lc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPr0tZlk;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773918437; a=rsa-sha256;
	cv=none;
	b=eI42IWYphcJWrvmtTT5jdm29MaZatPD8JTYP2kS9Sy7wsbhuik8r9rojxIFWbHesQ63xv4
	yMpFxo+COxj7KVAczF/9in/lWOmT1ryf04dXUoOzFgmZm3gL9JO0rtz0xDRtd5g8jIcl/I
	hpTvrpsJN4KswVPB1PpdJb0EL5la0IU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2AB960127;
	Thu, 19 Mar 2026 11:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C57C2BC87;
	Thu, 19 Mar 2026 11:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773918436;
	bh=CV8omsFptplFHRG3329dbSm62IiQAOIJxztrZtHZO5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MPr0tZlkqWEPEvseOW19Cg60NMjtp5kP17U5edVqBT+fTmuI4OT9X3sZ8TO42ap2b
	 6CR7VPouXluz3LXDcc84dLK1ScsyMw4tMTlngLzanfoxEHerVqCv9kRIaJ4dMDQbd4
	 A/CtZ1rDJTUHrLP32GcvrH7pMt5eNL8pmUycePYgbkXzzd3q+qt49zIm7QO9I3VLUk
	 ZtQ3x57fpGuBvHN2JKnSHmCn2scyCrAwJberaF0ywbMH3Nsm+NIeJeKsm+jsD5mQgM
	 FBxHxRT1Ck5b2DuxfRH0BUwK3jc7mVY2aIJ3/pg5Di0hunuSqfrVPh6eY3oECH61Zg
	 POFPtTqGJJ+Sw==
Date: Thu, 19 Mar 2026 11:07:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>, willy@infradead.org, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <b5e33e17-86ac-4587-903b-b277fe5b752e@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
 <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
 <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
 <37b48d94-9576-4529-8576-d4ed615d4768@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37b48d94-9576-4529-8576-d4ed615d4768@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FF6D140012
X-Rspamd-Server: rspam08
X-Stat-Signature: tzwm3p4ayy54cezfcrea5pipk3rgkk1f
X-HE-Tag: 1773918437-618142
X-HE-Meta: U2FsdGVkX1+sdhafTx2/VJK6Gk0iVkc2tzfBhA6t1Sc91RAo9RbtaEqgBWs8pW3AG3JIwtbyv5J4vL1Q8K7GgwS7cgh51ivBRCIG9cwgaIDboj4UJEP1H9PAoYleGJDgvjxnjMUqbetwqCIDismXlogkFktLiqwqgfl7tx6dolj+I2ubuIQ9kPTMCU6Tl5cNlHf5qUuJ4J1JnzluMjx1kAtGvoTnCZp0MJBKzeHMvaMmW1/EtovwHO7Rh+OCKQ07TK4i25m/LKeOrNSt7bKaZxJcktZ7tC0uSnOQZjkVu88IrAL8UsxbOJm4jt4M+HscmpU/gM0btjCkHVFO0QGmOYd91VEGd5lIp8EIbNHi4jcl1ZG2cf6WUsiFlXRd5xvvGmpmnLO73/yo621XQl4mYTHT2UyI5xNkhGq6Q8QOuuMZEuJaSXezA7ueEz90rNqRp+EZis7vugNPiPodfQbj7A0A5thpEhDCG1gbJEb6d5qHJAwEVEgVBWexYVeTFReYiBHfJR002rmAciS5GRtAJD8UHUykNhzD/KCJHAzRWVeggoFIVv7lPpCAqRkv3ii/VZA7S/qHmKwn1n7da7CrVMWMDM9hSBgShl9Yxb9Wm8xfhfs0zYWNgbFU6asep8l3BIxj3C/U5QnOtmcVZRASqb2hrqDT0545OYoaD09q8jI2bSrU2KCXUXgCST47W7GlUqTXPRTVO5bMdreUylR/jkzgohJnvMCr5shHzLDSpvc+jGv4PyZjvytuKqrBsCRc9h/OIdOcvfOnA1dg0Q3WwvRV4a33pRKtB4QPO0HLd4MaTFSMm1EvtLCmAOAzcVmdLjNrrTz8ekstQBxthPXy9oTUAUr8jIV7vMbUQhD49UNuKXb3ViPMHg3Mf4dpsAAWP+ZzmbktuNUWVUvjBuE9MzlRrb6Jj4YPb9ivGxjXnjVfI3hX7/bA8crZzSYqKocqFvO6a1i+cKPV07znM1b
 qmq6gc6e
 iWelsJP8BvXXajcCqC9ulVX614AQOiGZWrc4Pwp9H3rh3kFeR8iTc4DYSmhOT32F+kFDmy79AB1H5AuSa3a2Xw9Nt3vDNW2MPJW+xCA7Jv7w6XYIhG/raX99ROiNplqMv/IMvF6VPT2Ui0Rc4fyBinHgaxEx55jJUN+kyphVSGW0ArBnSPltMTded2w9mEZjoR0H5PSkjesVGW9E0GsAmxoS1xgJzSgfW4To7mj2tyC7rXr2wDFzeNf83gpQHO+lQt6PAUfxxxkOiCeQY64wRtVONDv66xRyuBpMcGMlVnQQ0OWb82I201DXFDfsmbGX0v2QBWAc4HIoqq4X1yvOfct8yU1DzVtV8YGCXlFlqRaeQs1kmNPses2QgtWIBfWEqHBOMa8w2INL7nPgxlsL7cYZ4QBcEtAoRK3gqsIFgiMpmz4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:59:57AM +0100, David Hildenbrand (Arm) wrote:
> > We shouldn't, really, be just ignoring splatting kernels like that. At least
> > that's my personal point of view on it.
>
> Yes, we shouldn't.
>
> >
> > But anyway I really don't have the time or energy to try to track this down or
> > push on this further.
>
> The problem I'm having is that reverting the commit might hide a real
> problem, and understanding weather there is a real problem requires ...
> real work.
>
> Willy said
>
> "It *might* still be safe in this instance; I'll look
> at this carefully for a bit and decide how best to fix it."
>
> That likely didn't happen.

Yep, and in that case given the assert is suspect, the correct thing is to drop
the introduction of the potentially-buggy asserting logic rather than tear our
hair out as to whether there is something real or not.

>
> Later he said:
>
> "But this is a long and complicated function (over 400 lines!) and I
> don't know if fixing this one way or the other would serve to make other
> bugs more likely or expose some future problem to the debugging code."
>
> with
>
> "This isn't the kind of thing where you can just jump in with a one line
> patch and actually be helpful, sorry."


Yup, so again really I don't think the kernel should take the xarray debug patch
until it is discussed and verified as correct on-list.

See the discussion with Vlastimil.

>
> So I am clueless if there is a real problem there or whether it's just a
> false positive. And whether (if it's a real problem) the simple fix
> would actually be a good temporary fix ("make other bugs more likely").
>
> I can try finding some time to look into that, but pagecache code is not
> particularly the code I'm familiar with ...

I don't think we should waste our time on it, willy's series should be yoinked
until it can prove itself for-sure well behaved.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

