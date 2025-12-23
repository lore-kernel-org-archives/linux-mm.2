Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4FAE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8201A6B0088; Mon, 22 Dec 2025 21:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F80F6B0089; Mon, 22 Dec 2025 21:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F456B008A; Mon, 22 Dec 2025 21:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62AEE6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:56:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03EAAB9803
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:56:21 +0000 (UTC)
X-FDA: 84249222204.18.DE4D461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64E4240004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:56:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mKSA5/Rw";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766458580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCSwQjrihN/US+U2Xl/t6TgU/MEzhXsecRltZ4oG49g=;
	b=jrCYuXizd9MDvzgI311cU9gNBdVo2EiwaQSnpfZxQ1Asai1CIgsnAqSOAd59oSxP9kEGZd
	mSsCh3pgH8nKPD6d91qazOVepSioi+QwKI4vvYKwoWBD1aaFtBOB6QL04qApa6FndxPVSo
	LQzDzm2fP2CXG4WEeFFJtjsM+JEabC0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mKSA5/Rw";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766458580; a=rsa-sha256;
	cv=none;
	b=f1jrOnjxAu/LtiUH+XC8v36W0bgRw62Sp4dTSLU/vb71xXH+cCLzmFR4e3OoRNfihlxThp
	ZZTzsyILf5GYka3LjTzVZ1wphr8JbHO1P3zk7R7t1JXw0tzk5Ekf9xU9TW5RMTv7uy3wHN
	ANM0//eIDSQbEkHOBE9L83oAS1WiAJo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0FEA60153;
	Tue, 23 Dec 2025 02:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C9FC4CEF1;
	Tue, 23 Dec 2025 02:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766458579;
	bh=U9A22yvSeV1PNJAgjZUA6GYw1/HANkzGS4qI6qnUm54=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mKSA5/RwiRVSo+XMwVR2NyEQ/KdmZt3vCPVGYzH8nkQapUptA22cTcun3nJGq7b/x
	 qmYR05cZlFN9JbdHkzWXahDERT4s38GKFoJTjhw19mm0Bt9WOpDcsrYNFhdd7yGG76
	 befMYq85SpvJjefoZmHE9QIXWG6lu7gcYS5LIZF8=
Date: Mon, 22 Dec 2025 18:56:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>, david@kernel.org,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 4/5] selftests/mm: va_high_addr_switch return fail
 when either test failed
Message-Id: <20251222185618.e5c3e0303cdc5f34c45c9a29@linux-foundation.org>
In-Reply-To: <aUoCepcpRjuMKoNW@gmail.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
	<20251221040025.3159990-2-chuhu@redhat.com>
	<20251221040025.3159990-3-chuhu@redhat.com>
	<20251221040025.3159990-4-chuhu@redhat.com>
	<469acbcf-22f2-4774-8cf3-7f68c7095c0a@redhat.com>
	<aUoCepcpRjuMKoNW@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tex9mi9u8xa9ncusjjnwikt9i5osj7ro
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64E4240004
X-HE-Tag: 1766458580-831276
X-HE-Meta: U2FsdGVkX19t6V4fIwHWR3VK6UmjJFd5cU0XbKr+WZmF+q3CmMO4ii2MFD+W3knGEPZaM3QCgo06FOVEXSgEsgn825BKTikkYiZG9hOG4c5jdWQ+BoeBLV9M+y04Cv+mO5StYSn9di40Q2b9oeu50SWneB5py/hwKfpI5tpmyjLq4ODazmWEbkSTiNrusDNlwjudDjLJX6+fquVNGKb5J9vywttJ/cBi/mXDX2cu8q+o0BBb3sLmu0XF+ylEd5+Uq0K1OOzduby7o9VWjMuuAOieFV+rtjM0ZhYzN/GvT5cbkLYzLODa5nwPv9PEY6lpwQOqQYE1Vcei0lxgSpu12Mph769U0OydYWHXWv4CXzpjicXQREkwEqGpD5WctUpAuZmWcT9H6VdQVqL5w09x2wc45eElorDDm6d6HcHodQKqNs78Its0qO0/ngRWnb79TwZL9r4RRe4u9ldyroDwWN+0QRAiP5IpY+Rp/KrmeHaDK4QxEZKIQNqut8BHdvX7nTK+A2T7y+POA7QB6WZqmHEwLAYHQ/7yQbhK49fnZ/WnVmsScOyx+M0iywYRhBzu2k09fSvi5nhnd6f+axSUTdpGMhYSKZtR3xF5I96XKqFSgi3vSiIKtEPqpHt2E+BDClKo1orYX6SAM6e+iNNCAGjcwUjNge20toJhm7VbAO1K5eTnnY5CYcx7e41aB4uWTcmnitJ9YygDw1K44DQCCf7L91rKuzhxlBlgKqRo5Ww9CggJvXsnZYRWBA8RtjWM4EwxuRWGsuJMpCAvgkM5a7WTcg2P6snHEPaKHwfFriu8A+DER8tyZ7T51pHneSZMCE5QM4lhd+O3UQpW915kRuUdmjr1Xh7geCGF7o04aW8i92EMC2yylcgIsaocsbHvTAUgfkWEPZ3CpdDs/Lk7Jm8DCNfCmem6ioddgXGiclSaIUUOSN3UvKLLS4JMbzamPJgLNf+mFb001taskSB
 lF0b6p9Z
 hDsfDX93oTNcF43giJVoiZgHXPbBngW2JnBqtGt+q4Ba1+lsUFYPagZf1+WO097JTwiBOSaZsGER5CHTYNiFUIQ5trzXa6ul+jyriOEPR4IM8yccdMDY3zddSmA97DqgzREWqjOmyl3w5LU1nsk5biS0wnep9PUqHbs4uT64W2jCS3yBt3XgLy9E6+O7xqip/nunHqrrrNGdQpWaU3ZytnJNpPKrNUbGS5mnP+nASFIDeOheUa41EFgyAkOhT3N9tuTsjyTYjhm8YttqaPx1a03X2VdikoVIobQZQ4PZXNnQKCUQvbYGGDmBJGPeSIdkUHcFr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 10:46:18 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> > >   int main(int argc, char **argv)
> > >   {
> > > -	int ret;
> > > +	int ret, hugetlb_ret = KSFT_PASS;
> > >   	if (!supported_arch())
> > >   		return KSFT_SKIP;
> > > @@ -331,6 +331,10 @@ int main(int argc, char **argv)
> > >   	ret = run_test(testcases, sz_testcases);
> > >   	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> > > -		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> > 
> > Maybe you could just have used:
> > 
> > 		ret |= run_test(hugetlb_testcases, sz_hugetlb_testcases);
> 
> Good point. I thought the result code is not encoded by bit, but for
> KSFT_PASS and KSFT_FAIL, and KSFT_SKIP, they are per bit.
> 
>    85 #define KSFT_PASS  0
>    86 #define KSFT_FAIL  1
>    87 #define KSFT_XFAIL 2
>    88 #define KSFT_XPASS 3
>    89 #define KSFT_SKIP  4
> 
> @Andrew, do you think I need to send a v3 for using the simpified way?
> if so, send the whole series or the single patch?

Leave it as it is?  This thing isn't a bitfield, so using |= happens to
work thanks to good luck.

