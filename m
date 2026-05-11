Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C517ACD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0376B008C; Mon, 11 May 2026 08:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7356B0093; Mon, 11 May 2026 08:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD7C6B0095; Mon, 11 May 2026 08:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F06596B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:47:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AAF74070B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:47:44 +0000 (UTC)
X-FDA: 84755115648.06.ADA6829
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A739C40002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:47:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMm+tJlf;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778503662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piSl0NeQrbjlS0csXN4uGW/cPXY9oks0JFPMT8zO/Dw=;
	b=edb+sFaP0DG6lJdASEcuI3GZUuMiXz5y9z4sWcnX+yGiZrTkiTghnK3Z+c4dXrm9qIN+12
	J66wX0i3T/YPdQiZGidgPiQlNZERwEa6eygSJYkx8zNlIn2GD31L5PRFJqnKN8Zdznclpk
	CKCDNe8EngQMtBrCkOYpxcPUqFd0mPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778503662; a=rsa-sha256;
	cv=none;
	b=nX8dal2lxaiTEU62kmaWScYl4u5iIPkkYDnXg4DHdqPnNyQNFm4b4a8NnIK4r3r45YSAAe
	2L+eG9Vrk57tf153G0EjIZ6qQI4pglcTZudHu65y0swknnKHIffTsG8W9XxskRQuRDQg6d
	Qe/frwSN4e48UqmkfV299mxhaeVp04E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMm+tJlf;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C0DA6001A;
	Mon, 11 May 2026 12:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA0C2BCC9;
	Mon, 11 May 2026 12:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778503661;
	bh=qByFLGVe72rTgzx4RNADis8ATo7lw2Q1IJlWwe202SM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vMm+tJlf0KqF5tq3PABUCWaZAb074MhjWjqY+BZbZVFwfwG/ev+CCws2dBMA/GOAe
	 B9RMCwdrMehqc6WVfjccnog//+xXgEjpz7VJ0q3v50X3bic8VPLCwF3TUMzw1tUr05
	 7TObAuuiIZR930Xt++jqz66SHq6BrhGMdkrevJjSYTKzdOxyb6zR1njxLLneD616Z5
	 x73PpLJW/OOsrH22EKVsy+FJjBmUeRW2FkKcf6HJMOFicq0fYc23Aw1M5FiEXusXFs
	 +0Ulb617Zgt7/XLKTcQj0mKjRLy9yk4ACpIP0cQqf0OCdoDNUUNlVbIGrbNcm371wT
	 iAFRAaWwR5YLQ==
Message-ID: <dcc6c2ee-6670-42e8-9cd7-6bc999f1bf7f@kernel.org>
Date: Mon, 11 May 2026 14:47:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: handle fork() failure in migration tests
To: Hu Song <husong@kylinos.cn>, akpm@linux-foundation.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511093433.2372985-1-husong@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511093433.2372985-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A739C40002
X-Rspam-User: 
X-Stat-Signature: ama9ec9x46r5c5hskmdao8ukz53noupg
X-HE-Tag: 1778503662-323572
X-HE-Meta: U2FsdGVkX191TkWpqX2OPYhTlvm3MLBU4gKH0zBitlOvRqJ4zJbGBqoVCGECNwHXImyqcjpJssGmdM3kznmGzcS+MNnlyBjRHYgvMK7N+puAMihgheEjctQS0yf4WOn8W2I3+f7qs5tGUiq5+E7fZCFH2rjqODACtDwADdnH+i/KOT6gjdXLsgcJnME71EbbWG60nQqCNxj1TSxUcO1yC4LU5L1NZEzhSqrj6GL7TdDmU+j2ef0CrWTfn9j9WnzAOe1RQj8/yWyb4W358Fu2jjxQHNO3rlM5mdL2U98bArCSinUZkoXpRK6+5s8mSqMnQUD7UP+hzR0/wtDrL7SBb/1kWMPNa6Ww2OYNEzL6lRr8n6B8X4NhmMkVeI+4UZyuKlyterwaEOE8yvKThxsDxCHu+JROxhqTexlytUTZxkmVfrkQ4O+6RoQ9i16MIYXRSntfM60K8zxXI+OBTRE3PM4jK3V1ntvY+O1jCfZfTrkwET+ieJhJ6vb7/z0/TBKu7s9lEwd48vMyS0Jy7Y2kDZcg11SBeAC0u7Of8/MPXNmCSd0KrsVtc+Qn3eTDkpaqAIGmthvH+ns+7MaPgd7ibRbGjDq4AC848kfjr/cblhcf6vHQT473eKd4sIEjbwACyr+z+LCb/blPpPSz50LQ7JTh7gHwk3+Gk3U9RlJj/GvU0tYHnrrG8L8KK5QuVWofdLvAyCEzSgfFDCryxRzjpWQdAeQ3QEZS3aPuYdsKqEUZEcWLFcMpo/4lk+AEvPHwb0hmIMEMn2G+ul1u5BeaAqNU1/K55PD1gzSdZP4bkiTlRWLK0PDvxrdx962qlljn2FLR8P9GWRA/WW/mCXOA0pRKMNNTqVlaE0bREhnGlN+GjNGWIVK8+r6KxoD7RgyTr8p+WEAhaqPsetOHrQHxXc/hYLDYfEmwsC31W7gC+RWMf57rGDHl86MkQ3u3QXW4OL1u/kxCvgwZXsoQMPP
 rAJ9Dyb7
 hjK3+Gwoh0MQeAKz5OGGDo4EXD1/2xSxmQxfMMunvhkhy+PogJ8mcMuuX3VR4o7o5iLpHIbjH0V5VDzRZ+gfO1GrSdFhXBEvD3O6zcC5r4UxWCLPLvu4pZL+ncGlbAuQO00WP6BvHRDQufrOL09YeuOCur4N8fAAfMXbbjy61AmVrNbawcq/cmhdQidpd6Gl6mg54uyeImjQoJPNIO2qKHfMWof3HO8SxBDbNFJgJvHkKrmRIr/5hmqH1P98NUTJngyEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 11:34, Hu Song wrote:
> From: Song Hu <husong@kylinos.cn>
> 
> When fork() fails and returns -1, the code falls into the else branch
> and stores -1 into self->pids[i]. Later, kill(-1, SIGTERM) is called
> which sends SIGTERM to every process the user has permission to signal,
> potentially killing the entire user session.
> 
> Add an explicit check for fork() returning -1 (pid < 0). On failure,
> clean up any already-forked children before failing the test via
> ASSERT_GE(pid, 0). This fix is applied to all three fork() call sites
> in shared_anon, shared_anon_thp, and shared_anon_htlb tests.
> 
> Signed-off-by: Hu Song <husong@kylinos.cn>
> ---
>  tools/testing/selftests/mm/migration.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 60e78bbfc0e3..f433e4f195ad 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -163,6 +163,11 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>  	memset(ptr, 0xde, TWOMEG);
>  	for (i = 0; i < self->nthreads - 1; i++) {
>  		pid = fork();
> +		if (pid < 0) {
> +			while (--i >= 0)
> +				kill(self->pids[i], SIGTERM);



> +			ASSERT_GE(pid, 0);
> +		}
>  		if (!pid) {

I think "else if" reads nicer here.

But why do we care about cleaning up the other processes? IIUC, we don't do that
explicitly if e.g.,

	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);

fails?


-- 
Cheers,

David

