Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148EBFE51ED
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5358A6B0005; Fri, 24 Apr 2026 05:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DA26B008A; Fri, 24 Apr 2026 05:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4239B6B008C; Fri, 24 Apr 2026 05:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29DD96B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:06:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B3EE40764
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:06:08 +0000 (UTC)
X-FDA: 84692867616.18.AF8D862
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AFF4B40006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:06:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkQGcP+i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777021566; a=rsa-sha256;
	cv=none;
	b=sQNyTh6U7a3bjkTDTqfrSyli1CXqP+N4iPlHT+ZCG91hulPqNL6W3WDwUI5T878jKfgEjh
	tBo6isR/E6Wlo1fbW24MIWHyPKvjlMLQ/WQnjYJ2POuZtqnV/OoKjDom0uqyobGKtY//yo
	lRXpnbALcoz9Y5FAMCJ2QaeEXqbt/3I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bkQGcP+i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777021566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJtnXZaUKg2jWaZmuw//X2nthxVSBFqOwqekEoOlEaE=;
	b=Fsagkpmm9jx2oPhpUlshjqXC6w44KwRnmKHzUM0gqIVzrbrlD30xAYWtSTOs7j1CeZHTgW
	6pBkt8CMslmI2JxH7tsPqvOk5NbvO0MWREIAWdQ6ZROYI20WSUNAq2wB8wZVeN3d3fkyI1
	uXxxHxNovRC3sJ4gQWDloSBKoVQJ4iI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A3CC436CF;
	Fri, 24 Apr 2026 09:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5660AC19425;
	Fri, 24 Apr 2026 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777021565;
	bh=micjOqkkr/VqG7KcOOjItyv2p2Gb9yjnk7cFbYc+VsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkQGcP+ichtekerTdW0JTCjbrtA5F8us6abcbyW2i6hni8/3JCULT0jC9pr8o4eUJ
	 4pGrTvta+9onqNxAC1gljpYyN2U9LblWw4Xmbwe9oYDaF3CBkFJl5B9nk52ctPY0jD
	 /NEv1j6cwFkYnf8PvcdNBloiM7cIwDwbOzzYLRHBsfCWM8/NowPlhUyxa142vrpC/t
	 B3cS8RKQG9Ix/CLUn6t8hwD5L01S0T2SVJ1Llb9RTwNjgLayHIWjxDHUEyY6GecYbF
	 O1xOJcg+lKWzT44Ros21f7rHRJ+9CFObM9b03dobkmoNrmMWstq07k5sJLiN042Pey
	 jCM6g4aFLhV0g==
Date: Fri, 24 Apr 2026 12:05:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aesydC2-WX-sYrgc@kernel.org>
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
 <aeXIKM9BeRmaCZ_d@kernel.org>
 <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
 <aecZPdGyF5i1baee@kernel.org>
 <CABFDxMGU8DwoG0yYb8gBstntTJ5okY-2bs_2iywBnrSX1H7-Uw@mail.gmail.com>
 <aeiIish34t1mA50H@kernel.org>
 <CABFDxMExN86rK0h0XesE7rT7TjCZbYS9_dmb6dES+eJ0hN1EEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMExN86rK0h0XesE7rT7TjCZbYS9_dmb6dES+eJ0hN1EEg@mail.gmail.com>
X-Rspamd-Queue-Id: AFF4B40006
X-Rspamd-Server: rspam12
X-Stat-Signature: ek6h13ipe5sfiacmpna4u8qo43rrngzq
X-Rspam-User: 
X-HE-Tag: 1777021566-708239
X-HE-Meta: U2FsdGVkX1/m0eUWlNWEvgSaX6xezopJTYfqUVHfBM2768wKKvRMZac0JV6M4Jna/Tdk5tCRYW8DC+bQ1p56OXXsLCt/BRXLnxo0Hzp/YlOrsEsGiTVg9OlMqb71CtujVhfgZVFjWgCZnbi3yX1XjD1e+Rtujtum3kt+QVW+RC9Ar5osRQ8vW0JMDsktqLSpqkMdwppqD0/0rWMp0eXa6ZpMjQxx6Kfwd5FQisQZR9ZYI5cAPGh6EtnejC2bz2vld6y7ZZ0F/D44aQUNeM1TVrulD+rZhavGx+hoshmr1u7suFANwpqj8emBvXInILBCIQzHg2rqXnuw+U9ncpOKTvcUGvH11LvN1gdriyjGQYGN3K9MxenehppuWnAWewH16MoAan6zcn4a5RAxx/vI2SXN38D5Bhp2cGf8zsBejoNjzdjjxiXqw8mZifa41x7EwB/5rlFHUwxCQ22gdVKiA3ZJExa+c+dTa3boiPq/xCsJc3wjMa+Ru6+//EDAGnv63KH5rfXy9YS3gI899nRzq3TTDFfK6nYQtw/xa7nVwgQ1RYDye40xyqOl4K/HeCX/rUmrCluE3MUEZgusJtMZ1UHLMoUIS79IqIlp/UR4MknWPJwFfyx0YbHN34VRxmtNIN+C0ykkUKiWv0xGf8eXQpLHiMAVVeyuoynoM5ZHO9gmOmj0TPpu4SMfC9eqX4Cr6Sse0S3p3/IKDabUEP1ob4gYC8DayEBVoL8l0RRVA1YGYh9zaQgfaFbOlj6BDdVqYuqkX4eDUOWrYyve12j3uOAUJpvKysgGu2Wr0GEogNHw71iF5aahJHmB55QdqDmAO2IH0LpSHfSNndLbUg57rGuP5FBT/QGI7IrgOmIhXgrmicwQXoXSRgQHU5UrMt3WBSi6ErDV1vLpKw4PzRQJjJlpBiXQKLPDGsChRbO68LTxZsLqhYZf3tDQgc9DZk4vDt9ef7JzX6LyoK3YRVb
 8MAAVGF4
 B8v/zs8ydyHY7YSyaq+/uM1qOS8ncr1VRZAhMWmVaEtJWB04dAkVdpd9PIGCLGP9Y4CMHmQ4rdx4gOn0O2GDloXIXt6WVv857eSyYM46Tldr8Lk59IonuPTfDpuFmmyaUC3sd2Hyjwk1lwyr3XVQeWVSO8v0yfpAXjP0rklo2En+/aYArCs+gKxFFyd8+ufSbWWyxjS7SQ1zHz0kOFkOkgPiH1desduLd2hN3UnDDubF86p4Vv5YEiusgrpG4WVo0wUrlsR18mSFU/N7sBAogfD/Nks4wXQTU19O3X6BlMer+uHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 06:26:34PM +0900, Sang-Heon Jeon wrote:
> Hello,
> 
> On Wed, Apr 22, 2026 at 5:36 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Apr 21, 2026 at 03:56:01PM +0900, Sang-Heon Jeon wrote:
> > > Hi
> > >
> > > On Tue, Apr 21, 2026 at 3:29 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Mon, Apr 20, 2026 at 11:26:13PM +0900, Sang-Heon Jeon wrote:
> > > > > On Mon, Apr 20, 2026 at 3:31 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > > > > On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > > > > > > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > > > > > > returns the next absolute node ID, not the number of nodes created.
> > > > > > >
> > > > > > > The existing under-allocation detection logic compares next absolute node
> > > > > > > ID (ret) and request count (n), which only works when nid starts at 0.
> > > > > > >
> > > > > > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > > > > > > 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> > > > > > > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > > > > > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > > > > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > > > > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > > > > > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > > > > >
> > > > > > In this example it would be 11, won't it?
> > > > > > I'll update when applying.
> > > > >
> > > > > Oops, my previous reply is not the main point of this review. (Please ignore it)
> > > > > But 12 is still correct, because split_nodes_size_interleave_uniform()
> > > > > returns next available node ID.
> > > > >
> > > > > IMHO, it would be clearer if both the commit message and the function
> > > > > comment change into "next available node ID".
> > > > > If you're okay with it, I'll create v3 patch soon, including minor fix below
> > > >
> > > > No need for v3, I updated the comment and the whitespace:
> > > > https://git.kernel.org/rppt/memblock/c/a34436ac05e76bd6634a89fc0a399ab3a48f509a
> > >
> > > Thanks for your help, Mike. However, it seems like '12' was changed to
> > > '11' in the commit message. I think this change should be rolled back.
> > > Could you check?
> >
> > Node IDs are counted from 0, hence for 12 nodes the last nid would be 11.
> 
> Right, the last nid is indeed 11. However, the return value `ret` here
> refers to the next nid, so it should be 12 in this example.

Fixed now, thanks!
 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

