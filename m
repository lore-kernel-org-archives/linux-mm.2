Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7497ECAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50FA8E0002; Thu, 11 Sep 2025 17:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01D08E0001; Thu, 11 Sep 2025 17:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A176C8E0002; Thu, 11 Sep 2025 17:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90E3E8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:31:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F63A1A05C9
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:31:36 +0000 (UTC)
X-FDA: 83878266192.15.C713544
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87B6312000F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:31:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tFh5AqH+;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757626294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHmXu0AkOxaiJpaZvBbiwNDV9hlhvpnupN6TeW++RHA=;
	b=L/0Qb9HujJbZcgF5WwjmtKFx5fpCaqcmqJLZnmhj1vdzIKqArm++NI+/TDPsYlIZVm0yQ5
	zvcOLOtYSiFWber6fKe9Nd41rRg/VuPZNYBbAgXLVvF08eQG8GiyXjg0Gp5BiS11HbiC1A
	80Vd+zjBuj1zJ0uOs2A9scaB3VbWBek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757626294; a=rsa-sha256;
	cv=none;
	b=OUY8lAxl+Ap5yqIVb9E0wuXe3pB42ia536d088KHcAF8DWtIGmYHbsqpmKF51+GtiQRypD
	v8RYew+LCyAWsWhw9SeENRdAsmYmG9IDvppM8ToJfOPLG+0PL6OJG6p4UxyV/VYZFzh9um
	MFIRkUT/aYFtkmJwvoVoHF8RpsNOKs4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tFh5AqH+;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CE7A601DE;
	Thu, 11 Sep 2025 21:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA22AC4CEF0;
	Thu, 11 Sep 2025 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757626293;
	bh=9x2Wu5/QlMnDtDHROyBHPWM0ROyv8HlbmYz0WmyG3Mw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tFh5AqH+gi6m/CLMpP7QXYgwkYHzcXMB7mZp2v+6RCpabU7ltDnI2vft5P5GybKjV
	 1RI9Og7EAf86WmewFeV9tfagYcVEXCjNB5Jw9HAOJHoKenxGlDmu3Cm2oc3rVNBNtM
	 7UIZ2y2u5VliwKQZ8V2TxKcXP4mi+uupY+CN02Eg=
Date: Thu, 11 Sep 2025 14:31:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, David Wang <00107082@163.com>, Suren
 Baghdasaryan <surenb@google.com>, kent.overstreet@linux.dev,
 vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
 roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev,
 pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-Id: <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
In-Reply-To: <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
References: <20250909234942.1104356-1-surenb@google.com>
	<20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
	<aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
	<902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87B6312000F
X-Stat-Signature: fu6uc35ptgqqgybxw1gp579xugzpd1r1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757626294-276410
X-HE-Meta: U2FsdGVkX1/MCZHHhjzfFBN8fSZ174x4xDU4fSh7vvqzcPxSpjNsO9IyrShIIr7qqRTaOtb7+epxjFT9zgVxFUMrImp6kTShGUXTz++R7Z1+GbqmkDdsh7+rUWKLgP60YBl8P+WigYkDpD/v9i+PgVyvFCm33j0YtoK/R57wKsHo6zDJLXoqcy+pJNwjS8w98tOxRlH5P8BBaAahI5DF1er4xsl7YBSsWI93aCHxd/FRf1T7xdBYaOytwcViVMSNHjJbx0gDHt/MlwOarVb+KSdTGBAAotyDV5lr7Spdc5Mg3/Xr8uJYN7h7NYd4ylhlvQBHiHx50TuyqEKwmxeTKYv8mtSJhIaYpbYTPdwKBqaZldWzhD9FSSKTIGCs+Ol+k8zfnsRbebLxiv3cKgWsvC6DFx+IaFBcM0ZdIIPMFD2HKV38oU1aYAFWfPT14Su8Jscdqi2CI4fbxjSHBoiA/xnd5sM0KlzkY4lBwHHjKi2EwaY60whvN5CVPrajaHDblqLG+N4RsAOKAphJxkA6ysq9ScDCPWiLIt9V/6vV9QCtzv6l5MlZGxCpoLwleRVjsCHqlC1DBwRCql6o3X6rEvHVcaozYC+jpr9v6I8g77HI40F8mKSK4KwNxBJpblzRMn6LjVpOjvG+c6dXsILxf/kjgq+ZGTNbR4+eIEAtzuw9BlwGs2eKMQTcA22gXyts/FJs1ed1wHg+OFNfA/xwgmAJREj8Gteh4c7PPilGTnUgIkxIt7HOD6oCSgZFrc+ySH2p0x+DYSqeUC13BArHY/GFMDX3Af0yCx/pCAZMWa0e7Z2+afPL2Cu6Z/epIO4ZS7AWL0VRFgOsuOqmKOSBtBsL3+2C+nX1k7Nj4ZYDTuLyLNUu0S+fPtT2b2OR008Vzygwv6lfuBdsAoRgSPCKkIWhe94ytLNMHUtPS8hpvLH82ol7s95JdPQm+ETkfs1FOTFvLkIegRM4AR+splc
 bCE1zLrj
 tjgdCrRV6tzpOPe8p6ZPoqmUJUSnifybsi77tK/2tPUkZ6JuSq0x/aDpxC6JfwpuPwEDwKvsXLmayp5xHwx88StvYrVomMSl37zYGV1vdvuUgT4GC3ZhB0y/6Cmb79r72xsc4rrSgAnn11qQmpBej3c0dWkHjlC9JA5pNETqHKN7LgZl74bQXnjDt4GDg5Dkng6OYEKIbWLQ2pDxa48JyZiOHSAbUM2e7CXbZ2Jll7KNmTQcbsLBb+1r4t9zxrGsCWSa7hlADpJyR0Sbp5/36Iujxga98/PUfYHDcbzkxOOYOPlvs23JckPR9shLTQTLgmoeC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com> wrote:

> > I think simply adding * to the end of function name or filename is sufficient 
> > as they are already str.
> > 
> 
> Instead of:
> 
> 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> 
> Could we do something like:
> 
> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)

Can we add another row, saying "the previous row was inaccurate"?  I
guess that would break parsers also.



I don't know if this was by design, but the present format does provide
extensibility.  It is basically

	NNNN NNN name:value name:value

one could arguably append a third name:value and hope that authors of
existing parsers figured this out.


Whatev.  I'll drop this version from mm.git.

