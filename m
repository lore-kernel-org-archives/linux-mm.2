Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E92C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA0B6B0185; Wed, 12 Aug 2026 19:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B566B0186; Wed, 12 Aug 2026 19:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0B16B0187; Wed, 12 Aug 2026 19:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86DDF6B0185
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:41:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE51E120434
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:41:02 +0000 (UTC)
X-FDA: 85094240364.20.1380A88
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DDBE140002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:40:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SOtQe+VC;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786578061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNVmZBOJRFO5+YzBQnHEpYoSgRgPekxz5xDiFALonEg=;
	b=UWEMLa9aJBNATL+03+0GPMmPqLahPEbFJBlkar/NL9Ymm29ITpa5rBUY6/EL/3R0DYA1yM
	lRpvelzxHFRRMDKd4PMY8GwiB1+/MXVL4vu2dSA/W/shyE+6nX14Wfup1hM78dvQ0IZZXT
	J8Gkr3QXmsSZbi3rgAAFdqFvet+c85I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786578061;
	b=gJeTT8aC/ix1GzwlkU1qDl2jLgtSGPGShBXm7BhKvwJkiM1MdmcFt5dM3CzfXl7LW3UK7Q
	eLGOqcGfSNUnTNaoKiFPffuYdW8MfAslw6dzQMMsnvPhQaAD+VlUfEhmGBiUKhkfPF7sJf
	0q6/N9lO1nyg1iagJTv3+s5gxoHGGPk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SOtQe+VC;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yase8ojYlvTroh3czrYooSzU3qkMRoxgGLJx7SI36pA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578057; v=1; x=1787182857;
 b=SOtQe+VCa2lKT2DRQ26s0zYpWrbz7Q4CIoZA4353SDSd0SNZBT2fQzOjlHr8lGkm1vqEpSnP
 pekpHhPgbbUqunc7/NWektN8D2uB9kIHK0cP/aMN17xGIJGPZXN1TTS6srHB41AW27QCEwsOrXu
 CdffMo+aZy8Rci+7CcDFMkCk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 8bf1ca111f2545f7;
	Wed, 12 Aug 2026 23:40:46 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:40:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an0DbbqFL7i9W02s@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
 <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: gx3x7g5sm5iz744bscs91k84hnqkaq7o
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DDBE140002
X-HE-Tag: 1786578058-972728
X-HE-Meta: U2FsdGVkX19VttY0riEb3T0vemd80RmRxz+SNp85yKDrmEt668NZVjdecmhp4E4rbbKfvkJuDGPYMzAhfdtIkW7rchUgqcpJkHC+bmHJ4WLdfm0X+WFh0IIV8nZR7JSZNul234xpKDOrC3a+zo2AW6I5YzTWWdFnktF86VPi1SNgKbkZngSjPbgIxCRRKPwF0/jFECz4WOrXEIBTrQ/3zaI/9UF4UWvS1NCSnOMgMcZXaQbaLCOQ6X8B01t/SvnlRRxfOSl/bTy7/flD7h//H+iuJdsQ6uTteIklJAx4j59suLJ36VRjl1IZ+D00lRYtpvbkVjttkiCsIF4jMrPpoWnjxOl9bSjHVkflNelcEmYrLIkAP3XR4uUhi2XDbVHkQh9Pv6I3wcUw9rQZicoCj12/p+UZ+n5vPXf5DrCwJv0oxLg+RBFP83S2gm+xXy8A0YgMAeJaGO1R3B4PRNcw/x3CU5o0JjIBRItaJSzj5QVPZi3rvJpwiyG6yHXW7bvV1IrMVFfOz9irYJOv4xI0Y5f5UQ/bk0Wf1PetSzS+M5+5Q/Dr1QjjpqJZuc5YHJU8vazENRyk3Qn09llfeRtctFpntSmZBNhVValv7ajsRtmCVpYIOS2L2mldzdHpZ38GHTxVF6e8oETwsYCNO0M+H+9ZP9unBvJZPOcVSDiUgJaPM9CnSEKHLIuswRxeFKrj6qEOFhBu4T1zAha3n6itftkza8FPXMg8WtJjuiI86QMED07OhIfNB4buWI9EfINvyyMUq9cAQLghI+sH36NrZXURxVdOVqa0++GS6gurq0gspSld60RgybqQ6DNInS8MCgyYqrSp6gVNOcwHH236RZxGicicHMx/CnZJgkVFpE91i/856mQGMY+7ZUCuipPrPCVZlh4WJIZ5YrmieV74O/da4nHNzZ7L2IVmyW6QBjMpsvhPzMBz84yyC3e+Sw9ZUvnKev8Heb2O73gKOhC
 2Ln9BAuC
 lVrvjGtrvamdemYCO2kUC0oPvbp3cirje9yPPxAZnmjW4wVtR7G7Tfb1AGVtN4f2aZ/Qet4B5Nr4yLzKqRNZRMb/R7Q9TKrLap/jyUEC5Y6loq1UoMIv5QVd8j/2Pc5+G8llZE5XDT2IuV1xRlyf6dc+OxE8w87HISyAvQm2HkpQkpo8nW2YAhlZE0VnY2iQ5sVIqlrG8I97kDd8GDlMnYTpZSOFbNbUsr7sYFy2bk5KVN4SKTliNT2/HQKhrY3VDSRemu27GKdlm9VRyUoaBk5Z6x83uqSb8q5+cGi0cwtzW4F0xXRqpSgwKetCFc+mwvOMAcUNp+2BStMDP8ToAFZbbF/SjNaVj0qOCNI2nLT6iPo6GxnqPIkuG1PvpCxsGJkY/TJj3uHC8TgcegPqZHO/ljFclUPXUsw3j+FuyZ3PPv8/mtQxX9Iny19oGbw1SMOZolRfC6pOeCS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 03:50:10PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 13:31:55 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > The v1 soft limit has been deprecated since v6.12 and nobody has
> > reported depending on it. Start the removal by decoupling the interface
> > from the implementation: keep memory.soft_limit_in_bytes, but ignore
> > writes to it and always report the maximum value on read similar to
> > what memory.kmem.limit_in_bytes already does.
> > 
> > Writes are still parsed, so malformed input keeps returning -EINVAL.
> > The knob now also behaves the same everywhere: it used to return
> > -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> > disabled.
> > 
> > This also fixes the syzbot report linked below. Soft limit reclaim is
> > the only caller that runs shrink_lruvec() from kswapd against a
> > specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> > and in turn set_mm_walk(), which warns when called from kswapd.
> 
> Thanks, I'll pluck this one as a hotfix.

Sounds good.

> 
> It's old code, yes?

Yes.

> Are there any theories about why the sysbot issue
> has just popped up?

The reproducer is toggling MGLRU on and off continuosly which is not really
recommended.


> Should we backport the fix?

I have no concerns in backporting this to older stable kernels.

