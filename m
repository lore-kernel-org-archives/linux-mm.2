Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5453ACD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2206B00C5; Mon, 11 May 2026 12:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88B76B014C; Mon, 11 May 2026 12:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5B66B014F; Mon, 11 May 2026 12:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9766B00C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:44:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C9DEC0506
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:42 +0000 (UTC)
X-FDA: 84755712804.07.F1F570E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B500A2000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:44:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEcbygBB;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84JaaNkiwzCPgBvS3ulztQc3bWhm5qtCjcIz4V7UjbQ=;
	b=tpK225uRiBXsCXJtl1vLQ/tBQ1Pw2KVl2tAbDyQsmjU1gycCeR9K3OndVsY+jGUs12CRM4
	O8SstmfaV/xEXtnoJOXuMxyRscKp66ueCbyoyluwusskTg+JjrF04ieeBnAjos3fKjyqfA
	Y58LiU4C8+fZIFjMewUPG4mcMoEivC4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEcbygBB;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517880; a=rsa-sha256;
	cv=none;
	b=52qOmwNjSwYiJxMnjOB/0QlnZTcN2fvPs6TdUoPFaFbsigZi9ocCBCZJTnc3zazytJQmBV
	wrQh2vwavAzhg3jqTitqaJW/uTN9aIXnex8R47Do3Isi/fmPyScMnrYpE8kc5gaFL6FZKO
	UPnokXmLSg0sT4Y8qt5jGFzRYYCIvOU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 118DF60121;
	Mon, 11 May 2026 16:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B257C2BCB0;
	Mon, 11 May 2026 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517879;
	bh=7pZZP1uERtEHLWxXu+uAGasbabdb7FcMyhWApqq5gZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nEcbygBBMz4d4LFSejQILqt2ivyT1jfPBw4N5F+SRzMJgG5ddYdYJzH418hkwVAjO
	 75wxjHuKEHQ2JDOhJrHPuTFOmagy/5Hs5W/6itBu7TKQRwusnCSe3/a+I0W0f/IYft
	 uAZe6f4TQif69Ta2p7YE4G2vKD8UbYjLLuZbjGvpNVSQcGnRFSGZTo6Ef/mCbjnqjX
	 BQjECOTsJixun9rGVpL49BgveN8trOMbpmrbjo0qvw8F1wzvDoQ1MqcoNNpPzpwLKd
	 7nlmNguugHMyJmY4Z8B2lX74OsDwN/ngODShb7jXj0NqzP6GqqhalnRhMp2W/ZpfSs
	 id209vbx2lBKA==
Date: Mon, 11 May 2026 19:44:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hu Song <husong@kylinos.cn>, akpm@linux-foundation.org,
	shuah@kernel.org, linux-kselftest@vger.kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: handle fork() failure in migration tests
Message-ID: <agIHbwEq7vEl9tFI@kernel.org>
References: <20260511093433.2372985-1-husong@kylinos.cn>
 <dcc6c2ee-6670-42e8-9cd7-6bc999f1bf7f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc6c2ee-6670-42e8-9cd7-6bc999f1bf7f@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B500A2000D
X-Rspam-User: 
X-Stat-Signature: kdf8psbiiar4a3rfytrx3ke9tni3znkm
X-HE-Tag: 1778517880-136551
X-HE-Meta: U2FsdGVkX19ldjVeUBXlf07EmI8imvm5jiTWVrBUFuYjDBsEFdoNvOe/lxkA85sRSUBg+57RDatC18Ttmsl9FqMSjgqjAz2qvxm4GLrISvop3lKBnahJjNDe5cDxvScPUOvLBNowwRl8eiul09aI3EQe1WUYAeS5yq3Twao0NK85//9RVNKF5oG6JUJlDCBaGrx96B4ardwoSWFPqxAHy94LeqYjarn3gmDFBhn82eVaOZiqTnvkpCce0yNxb8OnZRdkB8CvUkzWWdcu7FuXPVDXx4Q+sBcwGY2DFH4UbwlTslu6o9kfFWskINa4hTnCKt9/X6JMob0noGJxBDPuVFZCbDndJCENXwyUZABPaC+odIEkEDdIKlMGQytLngGvSEYUl85gFeTDVSAjZVec/11n0UCKxmTBmOup/let3w6x4doue5NNgPMvyukUQfW0qSei3XmBt4oQuF4kLO3eKrAqZIu/HiDOr2J7WUGqTm3fepPUlgLW0IcN+QbW6dkd+L5mlusV7lAcvCeQMOVYggEeJpiy6kh3bKXXtehbyA3p138x6189LnR9cexFmEySIpQ1wnpfvsw2J5wnPWmpN2UnNheP+Ytcw4eAQS5ZngL5i7xAZlGn7fge1p/57sr/V0nawdjT1Q1i07GGX0glbGkkb69i41X6dZaecYAiL068wOMfE4SkED56e5/yMpzlN8OyT7GNCqLe/3bJZE8urbvH3P+ZJoBAuCNVHeKv10G7KlOB2RgGFlobnVuhB3JTlkvnNwVk+c7C8WzfOt/ZvrBjgqqJicdwL3i9vmKvxyk/2t3I1Pg9K/spqchwCyHm05XHvFVHJp6LejhZsK+YpPlUzfFfhSmdkE6gdsatAclAUy3y9Bf+xAwEW3aNd9Hf8k7WTrs/C6xwPhkxEkZM46LdhLbvd1eMw8d3+sViWu4Q3zk66THOOmvn7TnHYNw0v2MwxAKfL8gVoCA+y2f
 q1UgtbO/
 PDJ2MB4XpHGmXeZdZSho2Xcu6VFnfptCtYXiwPGV/Bm+jz3A8UBT6n5TyVg1hupEUk+WHBWc+V1G0vthimZWZSlBsrZ4GHpSapEvAM4OJVkZpR3zmBLhbYRk2gDSrLmDIRasT3poQAQGP2fjSYj1Fa0QvszE1el4B4yyHHeosh79GQ/8GSrQZkveS4yzqiSKIz/hwN3RaCnRWNv4wIlGfz08DMjfNL3nWtJF1mgu/lZJwkVF09yT95EDuklLWe0IibvH6VEFDDN/2GqU9wfdVYmDuHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 02:47:38PM +0200, David Hildenbrand (Arm) wrote:
> On 5/11/26 11:34, Hu Song wrote:
> > From: Song Hu <husong@kylinos.cn>
> > 
> > When fork() fails and returns -1, the code falls into the else branch
> > and stores -1 into self->pids[i]. Later, kill(-1, SIGTERM) is called
> > which sends SIGTERM to every process the user has permission to signal,
> > potentially killing the entire user session.
> > 
> > Add an explicit check for fork() returning -1 (pid < 0). On failure,
> > clean up any already-forked children before failing the test via
> > ASSERT_GE(pid, 0). This fix is applied to all three fork() call sites
> > in shared_anon, shared_anon_thp, and shared_anon_htlb tests.
> > 
> > Signed-off-by: Hu Song <husong@kylinos.cn>
> > ---
> >  tools/testing/selftests/mm/migration.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> > index 60e78bbfc0e3..f433e4f195ad 100644
> > --- a/tools/testing/selftests/mm/migration.c
> > +++ b/tools/testing/selftests/mm/migration.c
> > @@ -163,6 +163,11 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
> >  	memset(ptr, 0xde, TWOMEG);
> >  	for (i = 0; i < self->nthreads - 1; i++) {
> >  		pid = fork();
> > +		if (pid < 0) {
> > +			while (--i >= 0)
> > +				kill(self->pids[i], SIGTERM);
> 
> 
> 
> > +			ASSERT_GE(pid, 0);
> > +		}
> >  		if (!pid) {
> 
> I think "else if" reads nicer here.
> 
> But why do we care about cleaning up the other processes? IIUC, we don't do that
> explicitly if e.g.,
> 
> 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
> 
> fails?

We care about cleaning up all the forked processes because otherwise they
remain zombies :)

But killing some of them if a fork() failed does not help.

I have a more structured fix here:
https://lore.kernel.org/all/20260511162840.375890-5-rppt@kernel.org
 
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

