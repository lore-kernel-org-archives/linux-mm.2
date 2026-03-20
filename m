Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F631099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2CE6B0179; Fri, 20 Mar 2026 15:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BDC6B017A; Fri, 20 Mar 2026 15:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7696B017B; Fri, 20 Mar 2026 15:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA0BF6B0179
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:35:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52D1013A869
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:35:24 +0000 (UTC)
X-FDA: 84567445368.24.E52A515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9684B40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:35:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Oew7NkoS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfw/ncVjXIl0hJYuRQaO9N17D4B8y7WV2m1plIWdZoA=;
	b=iC8U8ANbOjPa6MPpdtIxkXtEG3a4yCVv+p42j7q32V3rFYgJAZt5juDZiD734xrQeda7cN
	D0sWejufMVfGXjHv5/k01hHoOfL9Quhq+CQxt/rQQkhhZn6pCNaWo3s6c5aqHoql39anPG
	GTobl4YbA3ThIqr5u2Jv0IaRdThPRz0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Oew7NkoS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035322; a=rsa-sha256;
	cv=none;
	b=N/clJ5+yHIWHF216SnYMQxJFRyyviPEiYaaCgTHbBK0pzsT0YHsDVh1SJCX/TCsQEJPnfN
	SNUd7A7mZnMUBtS+crtHPPGpzN395N2n7V/mM5GNFA5PwboHqqZgNK/OGjfucvnVXJ6DEb
	i4xt68CKpXZ7WbJp3YbgbbvmAhiellw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0262A60128;
	Fri, 20 Mar 2026 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F9C2BCC6;
	Fri, 20 Mar 2026 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774035321;
	bh=lz8NbgQKGoPYkg9rAXWIFF2VzNwNk75zfobC+DqUxZ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Oew7NkoSOTo3/RzCToFkaK99ExN8a/9ytm1keifE+lhzyqQTb083d2zboZF+og7En
	 fZvqvq9GFceNQAg0+KJWN5eEzQga/3rPaTSx6vGjCWUT1qBEOE04hIWxKIJh1JW62P
	 YuD0rDhqiN0Bfip4E9lzKEx5JAnsV/vsrPsJ4d/4=
Date: Fri, 20 Mar 2026 12:35:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: Yosry Ahmed <yosry@kernel.org>, yosryahmed@google.com,
 nphamcs@gmail.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Muchun Song
 <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-Id: <20260320123520.616900ef63996ba448bcd91f@linux-foundation.org>
In-Reply-To: <CAEemH2cQSoTEVb+8NxZpc=qQVrd5DBhj7HmJA5o9GZFke3zj0Q@mail.gmail.com>
References: <20260313043532.103987-1-liwang@redhat.com>
	<CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
	<abPEALhYmtBnEULi@redhat.com>
	<CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
	<CAEemH2cQSoTEVb+8NxZpc=qQVrd5DBhj7HmJA5o9GZFke3zj0Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9684B40007
X-Stat-Signature: k7d3nzy84iiy3ggd9uso3hjgak6tfzpb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774035322-29270
X-HE-Meta: U2FsdGVkX18cb68If4W3zIMFzTwBItxAwPKjn33hNNSntmg8hVfEnfKbSz1ze0NLS2M4q/tAOJ2xnTfoRgoUpZ6yvj+Mjjod+KumsZ+yB6n1g0Q/b1JtIxyJjuBh/PFfi2mgMAOgFUzCOoEp31y60kkMpFMnkKCmP0U10DdNvntSKjfp2AnFZqavKSBXXDnDO/zcO7EyxGmdo765w6qgZNRDzs1/7NPIZ33c692wgfRsVZ8FOxr36/iQmoNTnGyIuPsGfTkFtWCcFvr4Vbuk9h8tPm4DK9FJx+IEf6Or63h7z587luPJwmWiGCZTP/SqamiMdUZHGi/N2l2vxMWPFHHzwfZ7U0uTPqXDQHlLZ2X1zS17XUiWBDYRKMQmeseqJA7jNCvim8QLNzDpo0Idpc/yshRn1zIPVif7fFo5bD6jcatJ/VBD3uRWu0PZJASRdA8HrtgNGfQOLpLCVUtyd+9FqdNIpcJ4NTwL52YsObuyOhlN0VbWYApAQbNrICQlTUBUu5e1ezyXFzBOnjCZlrknorYo1VzTDw5So796lpbl9NZB55w+mwOZ+kFExlx0qohzXQgQ1POfg3uHaB6WZPjQtAXJ0vfX/PcEd4e+PtkFWueq+ILnlYbcjgxCGyURMPm9cQxsWYyX+roIRhhZf1VDbOcgWAcempOb4+pTxyZJDW1+AkxnFPvgBOLHkUE8TrW15jok3AcMDuRv9cGDEVLa3Dp4YjfawQA6baLaM4ykyFvukTBJND0Ey9MRugdWDoFCiqBznQBgSxP+2GFoSdrngo7LFpe7yLWBRZnvXmt7mgyBtsHBiWsGHFzjHFh66F5woVYfH+ld5yH7L4v3lqiBZAmJJaFod1hd17Jndc06d7BTIwGsxUPhR5fK+kt5UWM+u6OVWF7btIsM8IioVRwBnWUMo0bQ4glF+51MVrbmylwoQbvRHkDN/YHBSq4+dQM26Vow2SKhbFLA8Ey
 CGUFxPNH
 u4TYw+Ph597xtc6bEV3m3VZ7aIUhmU4++0l1x7ufN9aZkfQTji53C7anLmM/Pq0AzWWvNxPK9H0vK/eAU8zAf3gpjQ4HzmGc20gOcRGXCqwAtDC7zZzryeFT6FP1SyeWzrThiWkr0Du75/ZDXO9snlju2PiGNOiiFB12eNseYPbMlHwkVWX0K3SRnq09i4h6nkkPmNpO8nsNbo79RfyZQdm2EdKcin3+lIZW+DaZLW/1LPXmgAd01xY+KHmNK62+Es8UtvBe+t+vTci9m4sMDMDNuk5pd1wUnKUd9v2B233xJWzcPmZLQJ2i3TTVmJlEG2JNLLQFkktUbGslxhuFT7CKosA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 09:25:10 +0800 Li Wang <liwang@redhat.com> wrote:

> Hi Yosry,
> 
> Do you know who will help merge this patchset?

That would be me.

> Should I wait or ping someone to move on the process?

A few more reviewed-by's would be nice.

Meanwhile, AI review has a lot of things to say:
	https://sashiko.dev/#/patchset/20260313043532.103987-1-liwang@redhat.com

