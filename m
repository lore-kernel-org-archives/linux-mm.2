Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF61D116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A0F6B0007; Sat, 29 Nov 2025 04:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BAC26B0023; Sat, 29 Nov 2025 04:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0D96B000A; Sat, 29 Nov 2025 04:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE66B0023
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:44:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A54F65BDEA
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:44:52 +0000 (UTC)
X-FDA: 84163160424.19.9DC8ABB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D212180007
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:44:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WdQujMwn;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764409491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uo8TBg8AtxzlOE4Yqx7kavPid3wS0PC/nG9PfSHZKxs=;
	b=TP8tFWrf7v3Qz6wqxt9OofS4dW7rCp856PEhaXgKCEmV2dRqh7bTIp+MoVK+cZP4ubnRnp
	95J1NVqEQ+sduXVZEFAF1Hib+nYE6vD87uq7svnqyY/ThvacPeLHPVWdl5acUQDu3Jr/K+
	7kYMGHLCt/iWJqxRkOUZfmVnwl3zNyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WdQujMwn;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764409491; a=rsa-sha256;
	cv=none;
	b=kHwipkD1JsL8Fbp3G3sqa2oi3G9Jtq+aXq8DHYLwlCY+uOKTLnHxHsI5MQsnu5Y2SzutES
	U1CWrMXZoYGh/Q1mGcx4c98hLU32eiZnNxqeREDUN4gzivxRM8soIgXTKXigRMxBffNqnS
	n+QxRSfy96LMhQB89YzagPtxi1Q0l64=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uo8TBg8AtxzlOE4Yqx7kavPid3wS0PC/nG9PfSHZKxs=; b=WdQujMwngoaiotKE+sjfTEDix5
	/Quh6v3dAOZbKwpiPRmLYx/4yq+iMPUTybuIxveIGsrIk9ol/Pwww2I6MKFzY9/8bfk5KC9gvcxlJ
	+XI3SdRUCbwXwlTUuxNp4Nssse82eDUiCkIRhOxgRrdnjJJ1nLFoXEuKXjIQtr+/z152+d0nhkZbV
	NMeLLVqYZSe2YuFhUS0OEmOm50coh4aYAoV2OlrFIZlICaBRiN2AX66N1ci9LOUKXUn0WTkKBJpBx
	vWjAt7xOnJlyU4zU5+O3ctln5KTWQG8AXSGsbGXZvUeB7266YsqjJelIwqS4mTr5vMv5iHIN6lym+
	pwkRJgvw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPHVY-00000008MI2-2f73;
	Sat, 29 Nov 2025 09:44:48 +0000
Date: Sat, 29 Nov 2025 09:44:48 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: will@kernel.org, linux@armlinux.org.uk, bigeasy@linutronix.de,
	rmk+kernel@armlinux.org.uk, akpm@linux-foundation.org,
	brauner@kernel.org, catalin.marinas@arm.com, hch@lst.de,
	jack@suse.com, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, pangliyuan1@huawei.com,
	wangkefeng.wang@huawei.com, wozizhi@huaweicloud.com,
	yangerkun@huawei.com, lilinjie8@huawei.com, liaohua4@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Message-ID: <20251129094448.GL3538@ZenIV>
References: <20251129090813.GK3538@ZenIV>
 <20251129092545.5181-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129092545.5181-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: 0D212180007
X-Rspamd-Server: rspam02
X-Stat-Signature: pn4s5ckf7gdsixsiykrnmn4tj4ziqh3t
X-Rspam-User: 
X-HE-Tag: 1764409490-831149
X-HE-Meta: U2FsdGVkX19iTXhsgw5dgt44oNTYPNelbrvfv1rGHiEHtvs0p81ZdJsFyIcQmynhuVjisuPDbyd0srQSXfbooDU+VPWKmRTaMXegpVSt89PD24AvaY3RvYbWOt+VAyUYq7/gMOApGYvTHmcphQE5ka8nYK5x6urbA4eiAloUE+SepNOc4aqD6gBhvohqQSfNp/0mFWmCo3rMK5TOk1rIfU6n/MwnGW+CQogXpqjLAu4Rs6+iUM8InflWwa7uTYXWNM/p0IjJpafu+jFeHfkmt+3pRT1ElMROXaz4jMFAcEPT/EVDZZja2YBjOAWLowjIybfo9R3N5PEVF0WsqSA/GPeV+FuNqFdjII3wvWSmJh0dBOpTCrNMIEQOE8lB1gyftDCsWKmiEO4jcOgoMyUYrKgLBNhvBzQEH8AWedBUReSXmkhzAQCX2f/uNWE46juNatb/3C+SeBkGMvy/51k8/Xl1GjzW5pdKH48N77treEruQrjzepzCPEAB7EUSrZzg+prQSWZyfgM201lQdOkYxcltexC3087DLXEaL+wZQZZ522prp/JM4JSpQ+D2dYOijp6zXfLpE75EXp3IGdMXriKUMjgapJZh+wpwqiihVinFRKjARoEJzN40XCjLDJfbtGZQVmUlh5R9mfNdtmB3yHZ5U6JYjbs0oguzUadnWGvKUJCWU/5W3NvMd37/TKQuF7Ljet9xF181UbeHmiy8N8bep7ElsGk9CBy7DmJM3G0Zmlre6n7noKLoxfEad6XuARFwTwjh8SLWOsbQXRlpcSMom1tTInSGiUSyzYPuRRtl6K3Hx5wiAB6JF2mUHdcBQMsFxb7tXjTcLdzSUifuAi6rkkodIFdoeHPeFD6n2Obv2oQ2i7F3wy+F4zI4UFyxq8TnQIb0v3W27Lb9/doQoKqRId8DbRS+olFyyA+0uquoeFcRLFIkLA9YPh5AK0kkqS78rACCJguzPXJPMO7
 8b5UjpOR
 kMA6ewxZw9sn52lV+a9RyKN+CoSwHu7tIsJRs/64DefJ23JAw7zTXTN9xmGq5CN2U7jKEq0a3QCYcYmvqCD9ZWM0w+ZWez7N81T9OovEqFBOCvb0GctLMM8o9KsXAmIEsUP/yuVTGbWtXk8hm0gnBxdZi/m3rXFz582PzCsQEVtRU0lHNTG6Jg/mM1sICR+DnQrLkax1NvV8vYyPTuei5o+dlqT3+EToAYTyUXXQ3ageH5rRjFf98JK+hwbhZcFMmOVkS8UO0mJnvhhvUCiNnasopun42/D/p7/cMqwQQ+7JVVDwZHJ/DOqxesmnIBxwhIE6wtQRkfLy6Oq1HovZYippgGiXI1hDz8Js+qLucQZnTCZvbtOCb0vt9WcV6ufgpFU6h7VfllhZXiPfJiVhjCAo4LfEyl5i0kr8BqeAGjyhb0wXMd/1rlHHMIGOO34Rcrl0ABgMaPNCYY8md6yg1Wn2QzKOdLKkAd9RlW7dx9VwemF4B5rEd3wTrIclH59MtdoQIsT/B4A6ZdLsY0wv1y6lYe5J3jwHhF6T+X9YLfyhQZcdflKpYG2jhA990d7CA8cXAQ3PbR1F/ZmqtKbMsBVYiV8onvSyr8mJHpmOvEX10XJY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 05:25:45PM +0800, Xie Yuanbin wrote:
> On Sat, 29 Nov 2025 09:08:13 +0000, Al Viro wrote:
> > On Sat, Nov 29, 2025 at 12:08:17PM +0800, Xie Yuanbin wrote:
> >
> >> I think the `user_mode(regs)` check is necessary because the label
> >> no_context actually jumps to __do_kernel_fault(), whereas page fault
> >> from user mode should jump to `__do_user_fault()`.
> >>
> >> Alternatively, we would need to change `goto no_context` to
> >> `goto bad_area`. Or perhaps I misunderstood something, please point it out.
> >
> > FWIW, goto bad_area has an obvious problem: uses of 'fault' value, which
> > contains garbage.
> 
> Yes, I know it, I just omitted it. Thank you for pointing that out.
> 
> > or
> > 	if (unlikely(addr >= TASK_SIZE)) {
> > 		fault = 0;
> > 		code = SEGV_MAPERR;
> > 		goto bad_area;
> > 	}
> 
> In fact, I have already submitted another patch, which is exactly the way
> as you described:
> Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com
> 
> The only difference is that I will move the judgment to before
> local_irq_enable(). The reason for doing this is to fix another bug,
> you can find more details about it here:
> Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com
> Link: https://lore.kernel.org/20251129021815.9679-1-xieyuanbin1@huawei.com

AFAICS, your patch does nothing to the case when we hit kernel address from
kernel mode, which is what triggers that "block in RCU mode for no good reason"
fun...

