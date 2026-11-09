Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653D9606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=R9+SjjOM
Received: by kanga.kvack.org (Postfix)
	id 83B7C6B05CE; Mon,  9 Nov 2026 13:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC246B05DE; Mon,  9 Nov 2026 13:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3F26B05DF; Mon,  9 Nov 2026 13:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC966B05CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:46:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E49781A0779
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:46:37 +0000 (UTC)
X-FDA: 85416461634.17.0B02FF4
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id CDFBEC000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:46:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=R9+SjjOM;
	spf=pass (imf28.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruyz/2K4wlVY4cyIFsxKJQ+uv+8W7GCsg6g5SZEw66U=;
	b=O7dRKXjVBkVSyzw9RoHh3uYA14vOJZ7ydCtmDNt3/0V3eiJohSF4emP3l1TS+AXmObjgKa
	m7eCoMdlWr8sJIGwUSUntMHPy+7wqX29eKkvx4iV+FgDUAAAqDrqOAcdtMA5eEUtVkQbSc
	DAxmZESRLJK8TR3xd/QwizhnzJ0HgIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249996;
	b=Udqy8HLRD9GHnQaXlkqcbgVem9P2liBrhbMkgCNUUC/vOWBHGOBhV/M7EOIFkG02/12Y3e
	hjozyUsY8YDHv/LAb+xO+Nc/Y06H0H2pBEb5p+D7bwGTTG7Vz+8Ic96YKMU1HY5D2C7nge
	qYg+35AQlMlrCdzbHADwWUttbwjQPeM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=R9+SjjOM;
	spf=pass (imf28.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1794249993; bh=6kVwTzI1/KcDLMSc20Gf48sZcIqocBBJVzv0nSohHRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R9+SjjOMzRhZ05/CIvcJT2p8lmE7XRQKOFIX21zFe9O5hD12H4H1DPMPqDz6CGn/d
	 +EN7gyBWrcbWHdu58Xgors8T+iHxqYvDpaZLBwZMTV4nKMlOE0JPbIUhUGoav+LpIJ
	 4cWNeeCAhiLPpXPydpgjO9eowbgGlBdMYCxUUO6GJrf0QUOcyCqBPqWWw3U9/FvmCh
	 +VJHBAoRWzpOeVcQzbvtlOA/rXPpFxHBCRh1S/bXcX1SbMjIl1MfaCK+LR8WIOMGO5
	 I5/3Ksz0FyorAPpSh5U4f171zLiOwSWYne3a2fHuMlXz0y1gnhPhbfQErGurC/IGJP
	 AbMtvKAc199jA==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 8DAE69CE; Mon,  9 Nov 2026 12:46:33 -0600 (CST)
Date: Mon, 9 Nov 2026 12:46:33 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: kees@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	Jinjie Ruan <ruanjinjie@huawei.com>, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, paul@paul-moore.com,
	jmorris@namei.org, shuah@kernel.org, brauner@kernel.org,
	alexjlzheng@tencent.com, jannh@google.com, jaime.saguillo@gmail.com,
	elver@google.com, blbllhy@gmail.com, bvanassche@acm.org,
	pjw@kernel.org, broonie@kernel.org, debug@rivosinc.com,
	tglx@kernel.org, aleksey.oladko@virtuozzo.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, morgan@kernel.org
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
Message-ID: <avIVCf1ok6Xyfii0@hallyn.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com>
 <avHfm5/mVtuN/oPW@hallyn.com>
 <avIKUzCKAkfC-wuk@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avIKUzCKAkfC-wuk@redhat.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1foeq4ncqgf5y8wxnc4nk476abjj69hk
X-Rspamd-Queue-Id: CDFBEC000D
X-Rspam-User: 
X-HE-Tag: 1794249995-91347
X-HE-Meta: U2FsdGVkX190Nk+obMuH6w7sTKRrrJw36BFaR9SCZGWFvrstWuI+eXFZQluTemZVo1f/1XxROJ0YrvoMFVMvc+8csiGT9otsbKoJ3H8iCeDr/0DDm7gDrx497dbTFnA0i4AXjy1t4p4xiiNvqh9We/8lsUYeOX1Meo1gA/BbfW5B4RkJkLEGTd8Lhh933TVpy33HaVzpLaXDof06E6dQWUgel/dmyerbRoVB1HeH/LeGWfLd0Vf34N3VWXzGQeWcHorJ8+jkVDA/tvrX1DfoY0b2E+dciZpVSlADpc6pfMBdGuN21hs9U1bUSqxxTFz04ZJDrGCE9+stgYXSjzgoYW7PDu99VKEUFWdYZc942ovSE4OI6jyi9btiG+CVZ//2bOV+26hpa9P6I2CiZRCGs0SERHz5Qy6mdk7a3TLkLYwyK4AVRGpNuoFU9e7H2dJQlgDQJtR537/K3BexM2gPfiF+Cf0uOqoME7nbBTk5009bpF8uyHEBiEAKfAoOzcrpwekEvL6jLbCyx9c2Y0xQxLLB/ifZnFD67jQVnq4M265F6VDpMTCVmwaiWUaIJNcKPjb9LB2RSXShzhQPg2aYVZuCALF261KYoWTldTKOJu79424Zmux/psZ0fbfbfjRT0XlYm7+kOw7JHW1Xj5wqV4NwOe4E9J+VZY6IVmyTXTywYnDXFSyA+wvdqx+58Z7xNEKKTnK7/Cx5u+GHhvpIK778d9iw7VOeFF8F55hd6t7ysWkFQLnkzJSWB6QqnJ9SfSq4bZqI9aIw9He9jQ9S5Zx2PqmSlfPhoOwX8hsVKUEoNpeyYVo5fpOPkfW3SnPRfZvXeBm1iw/sUkVsC4vmdTozWi/HlXRf6e0bxHo4KYhcta8jVGwoDXUHl/SOEnNJG+WurgdhgkOi/Qr8CUnU9azNeXU2Rjfzjwv/ZUSbf6k2k1CFN2hopYMl8wSE/indDQ7Ay9BAChPAGvNVsTG
 oNoaG6Qr
 9TkAanKoDPeWJ5NaD4e1RM8LZLv7Qb5Dmk8h+x8Npu0mZ0dce1VBbibP4UDI0m6XsD7axPEzAtTyIbQV6EgVosFn/+XlAoUisdukL5rvjVoYQKRZpo7F5BZRBhAO9FW65m0Biz2A3SprNLpyMH6W89sKI6hRi40Y1ZsNHK2ERzcsCedVOIU5p5g/UlUWWC1M9ezbR3bl/wPc6vcZr1E2Eqqll2Qighyq/zrAyy9a+YS6ZdH7YjgnHOiHu867io9o9Y7Ax4Zt4BjfYW5bLlnj06rarfj8Z/SyLB60mOrknlTG+VD5DEZt09nylD8gjm7z3FlN5Bg7EYhe0FeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:00:51PM +0100, Oleg Nesterov wrote:
> On 11/09, Serge E. Hallyn wrote:
> >
> > Hi Oleg,
> >
> > please see below.  Do you have any issues with this use of sighand?
> 
> Hi Serge,
> 
> I already tried to look at this patch, but sorry, can't really comment.
> 
> I'll try to take another look, but can't promise much, I don't understand
> the problem space (I could never reallly understand capabilites in details).

Thanks.  I'm mainly wondering about the storing of this pending capability
bounding mask in signal_struct, whether that might have any unexpected
side effects.

