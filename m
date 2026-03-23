Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCBFD58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B433E6B0088; Mon, 23 Mar 2026 18:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF31D6B0089; Mon, 23 Mar 2026 18:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A093A6B008A; Mon, 23 Mar 2026 18:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4BC6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:39:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58DA613C243
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:39:45 +0000 (UTC)
X-FDA: 84578796330.27.500848C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A99E440009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:39:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWvfirzM;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774305583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+nj7mA9qtW+fF92DkaKkSJl1S81uqYYiloHL8drKrE=;
	b=qYWrDWtJwpx0dVu+tEIi4+okpiHeak/KRTamWT/Yq7PfGL/aGe3fkGv26OhzuxonY6BSTl
	6FfqmyUmNr0L1TMEnylLJ9xCoqTFSo5R3oBMX0ql5Ufl210uUqDlQHwkBRlPbq6hLee2mc
	RuMXIBAJD/lFZrVmxhELdyUvGYmIwW8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWvfirzM;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774305583; a=rsa-sha256;
	cv=none;
	b=ZJ55QvSPUuRbiVos6xRRHmYe6kn2xty4U4X6hQrEY5/I3HkrkIvmYA3wakv1ZGl2JcuWvT
	OkykohMD6DdHViTOdcSRKNtY+wIHgCkGyusidvN06+cz9RaOwe+EHYa0GJqVvdM0kw/3zk
	Rf1NF2EkiWZnjoUxHWMLmdtMttLbC4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09802600CB;
	Mon, 23 Mar 2026 22:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A12FC4CEF7;
	Mon, 23 Mar 2026 22:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774305582;
	bh=/POZ2oyUorAwl07dujQRj5OswZjstruSQ2Nk+WEEwVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IWvfirzMniNwG13wiim+tYJvHHNqtjnwB2Xmhzc+Mxq+gEpjC4wppnhtyoJJdylan
	 Ic4ev5sD2XcmD4ZWlCd62CYnEZ0mqdN9M+63U2bGlR10Rsm9iojPfERVlK6SRyeVbS
	 poawOx/Z28W4YqEFCytBm9qhcKdLhK/7f/d10Af0=
Date: Mon, 23 Mar 2026 15:39:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v5 4/6] selftests/mm/vm_util: robust write_file()
Message-Id: <20260323153941.289938dd9ced4dbb76ca7804@linux-foundation.org>
In-Reply-To: <20260323151753.2576137-5-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
	<20260323151753.2576137-5-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g8ew7n3q9cxxfhkh4g4eaowdu8c6jd88
X-Rspamd-Queue-Id: A99E440009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774305583-384403
X-HE-Meta: U2FsdGVkX1+M2bGZvrkRVZxQpIz8XOJ5ZTuOXog1FnIpKPOAVbwhw+5m6aAETcHM4cCurBJzXjQd511mVCNJKqltuBxJborIahiL7NhocPsC26NyDYvE4Wa8zslYv9Ioc6X/Ge5zq2skw0QmpKp5oZz+Yn6benzNxYT9vfMvgzEGrGRAbnYSYb7/PiVI0vfZhbNXtHqXlfTdO+UMb8emN6jG4djN2k/dIaU+PyhSDmMA3pZwn2/xfSoE2baRDZDm+Gkibh02FXmO43lzokfvWFfiUgtjU37GGylFpK+acpnxu5d/NOeMRY1CeXFw2XziONTo8woT8RLKkl4Kk08g99kMuziDxcTRBkGCGGETXn96J5aZSYisDJx7WaLufd4aCoL5C+zAQTbKZ+flBebW7kOh+KondEr43xCnVEdCruC4fR55HIMO/kpbvz1RFmAQR5TNndmocWVnSufyH7r6QFQWlmPPT1Lc4qrylyy9T8KFpYPM07DWMrfdWjbwwdW3WAAgcC/vuKPWigaoOWWZ187mo/v5VYITMGleyOV5ybYFT6Ha6KsaMCDxNy0HVQX2jSCCVQ7jbircKnYqjU2YtxtzQMONKIU90A91hfUV/fJ3A7raBulj93z/oiBmcW3bwsoF8nbe7P6KptCEpeDEFd7Mttlzq945tvrNVVu4bCxYb5C9PAFL6UYqmAY8CFm3BmR/+nwxYrQaFMLzdhbbaW9CxLuPKq4CyjeztgCzNQJp08A7/cvELsqm+hli1us9/AT81dB6730JTAm6fVIGOcMVK2MUhNuleTbeZPtDk4adrOm7fmkNdmP2BbknMCgpIUim4lIpQjk9J+iqATSq83xvIYCvLgch8oMu4iiSt2RQ1AiW0FHsOygfW4cbU3ZNKWalAyRY1KzxmX3KvyLzqtsnszJhzSVsJrOJeiZ7EKOxXgSC3U02jX5CbDaKoFNRiZSMxa2bKqNvlx1mdcd
 yp2r9rSP
 YfhI7v8fR4VTbG/x2asjGwNRb53O03cEEV8XPSVKlc6wHkurINEZ9q1i9xrim4KZzAD0m1E/E9DjVD5Vx771VFBW27bQOb7NViTC2bT7TAXfO1ZLya4XJtQmU3CwRPm2Vy/xMruGFTiQ89bSLBuJg+vi5peYkohx0Od45+n5K1ln9uMmlSpw1CGdTOavFeVJWuxZxUuCWItGTS3cfu0JCqXLF+Yg4o+koESwBSRCS9WacjEKZ5rVCCbh+PApjgtxFOKPfCcVxhVckBiBn2D3ZzGFSkEpw9y+ZYw5Oi6wTR/ZgMj4XAy9JRH7k5TwuX0ZJGmG0p6fRvln69Rn3P3r/e81E+UpitBB3uNgTIdI2Vzg5AHr2+ol9O+Ys7A1FNS/xlivc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 23:17:51 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> Add two more checks for buflen and numwritten. The buflen should be at
> least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> The numwritten should be equal to 'buflen - 1'. The test will exit if
> any of these conditions aren't met.
> 
> Additionally, add more print information when a write failure occurs or
> a truncated write happens, providing clearer diagnostics.
> 
> ...
>
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -769,6 +769,8 @@ void write_file(const char *path, const char *buf, size_t buflen)
>  {
>  	int fd;
>  	ssize_t numwritten;
> +	if (buflen < 1)
> +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
>  
>  	fd = open(path, O_WRONLY);
>  	if (fd == -1)
> @@ -777,5 +779,9 @@ void write_file(const char *path, const char *buf, size_t buflen)
>  	numwritten = write(fd, buf, buflen - 1);
>  	close(fd);
>  	if (numwritten < 1)
> -		ksft_exit_fail_msg("Write failed\n");
> +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> +				strerror(errno));

AI review
(https://sashiko.dev/#/patchset/20260323151753.2576137-1-chuhu@redhat.com)
points out that `errno' was overwritten by the close().  Maybe.  Or
maybe a successful close() leaves errno alone, dunno.

Apart from that the comments appear fairly minor.  Please lmk if you
think we should proceed as-is.

(I'm really trying to slow things down now - we have a *lot* of
material and a few weeks of consolidation is needed.  But selftests/
tend to get a pass, for obvious reasons)

