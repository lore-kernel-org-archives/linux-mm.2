Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9223EFF60C1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95E56B008C; Mon, 30 Mar 2026 23:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46926B0095; Mon, 30 Mar 2026 23:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C516B0096; Mon, 30 Mar 2026 23:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959186B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:54:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40B7E13BFF8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:54:09 +0000 (UTC)
X-FDA: 84604990218.09.FD868BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 848E51C0004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:54:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v969ObtV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2dHNA3DxwCBQ6+tbssOIgQJAnIRi9Ds/njUC1rWBLQ=;
	b=J3Fd/R5FnhsMfZFp9LeChqPLW7vcukbSr6HGh2m0q6n6WxRVNjkyqM/aJP0P/hwUAgGd8G
	EPzZA3toAFsq9AT7ggl8aBn60XQF97O+cARo/JuUqGsoCZI8om3VtvJPZ8xSRRX36cl0Fo
	TkqD3O/EqC+AcsVZssOz/JPGKJ5NH8g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v969ObtV;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929247; a=rsa-sha256;
	cv=none;
	b=drfOhsCi0x0KVvmKkOkA6JpqfvzodD9KiiDYlKkrmtAF83qFcc41MzVq+UHLJNUevncFia
	2AE7BLfihf/71oLiGQ/zBbWGKrYfPG4IPlFDaa+iPrAidsg4MTllNbWUU4bxDXGJ6+8uOi
	hyivrd6FlXdBp8oFm0/hc4PTqO9A7sU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D294160123;
	Tue, 31 Mar 2026 03:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1A8C19423;
	Tue, 31 Mar 2026 03:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774929246;
	bh=1zKueCjYPnMUW760AR6slevZskmLyUpa7pjvFUk5AWI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v969ObtVceDu/y5QHcMcwGQ58QnhHdCUH7gc4zKcwrmwyvkeQZ5sbjun9BpPa+lSB
	 j0fGOKuB1ZPTL2wmhlSQmz3XXeHalmeni8/LvVzICod+FXrVLF2suSaMTldjwKSSHe
	 pJVqFm8ONtL0XAoLDyYwM4CNJLSH0YJGh/QpNUko=
Date: Mon, 30 Mar 2026 20:54:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chengkaitao <pilgrimtao@gmail.com>
Cc: linux-mm@kvack.org, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v6 2/2] mm: Convert vmemmap_p?d_populate() to static
 functions
Message-Id: <20260330205405.44d128cac32b971ec9134c70@linux-foundation.org>
In-Reply-To: <CAAWJmAaOL_NUtJZfHguSdPUsNVCSU0U=GWnTeVAKhnGgwSKeEg@mail.gmail.com>
References: <20260201063532.44807-1-pilgrimtao@gmail.com>
	<20260201063532.44807-3-pilgrimtao@gmail.com>
	<CAAWJmAaOL_NUtJZfHguSdPUsNVCSU0U=GWnTeVAKhnGgwSKeEg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 848E51C0004
X-Stat-Signature: 7hi5tm5peiqrfacuawz1fk31h5kgh7oi
X-Rspam-User: 
X-HE-Tag: 1774929247-695492
X-HE-Meta: U2FsdGVkX1+xKOaawuijh4JbdHHrTCkcenwACXbzUdnhzU3NSBsYlDHWM9QVHjjNgzYrYOFW/VoAqOgPzekCrsmsrY2sjBrqzakgKmY4LTNPBf8uOI5XfQPaQmNsjAYp3kJgH8NANwFJZfr5GmXOtradsSI6pd9qSDj1aCp+EvlNp1a/tXOQ2gaRF4LEldDr7oowzrMHNcrSefqglKq19LGOKug6VeU4uI+aTmkdxqI/ObFNi7qh/UVf9raSkfKIQmGjBT5w4h2e39DOX9x/++IekpLMtBUusI0shVYkhxm9TrsHcH4mcN6h17tKMOA09odM6TtDcTpfAH42VmZbR6hbnPY/o9stOj5r8w/d9OlAWCC7xWJbcMT+M1tDN9OWKE/1LWgud647YNbf77oAd9PsPOGR70Yge3EcYFExlRYjwHPdu52g2Tp3hEcnJeOcRgqNT4FVhmIBN0rqvpz7i5qPhqbyLsqqmFHMYFftLeUF8pXSzO4hswbDpJCdhFUHjBIT2qDYrZAaUSFcmYD4tUIoK4aUGnorlmItUH1yw//pPUcKIgpVSlZYEMy0w5/vxuNjPXi/MqsWg4hTHjrbIJFAYkYQsGcvDFqaJUwykWFVxqY+6tvfuKJJYMb4jzT66mn4fgultxPcbtAUQrNeUgpNSCpxdb21j0FlGbsZL196bElYOygPRnEkoWWOKyG0vQdz5fLWF9AUvj1A4JSeuhlGr7Ub78qNOO/SvCFs913owDUQhuJIoBddBlaFHTO8clbswjpyUkDXvDDtQLVjZ2U3LDn8leMF0owmjsULYobK6GJ3a63CSUogUEvcA3Ne9GsumEbEKHkScQxBe+UFHuiWB6f30XbikCL6J3kOs7Xfr9PqZ9dfowswIQdWLP5E2elmKzPcekdQeyEsswwuW63+hiXmT00tNRMF8NxosxRtN50anh1h8cKQJ6LDrfouXMQkmeSz70MMj0I1j5D
 2FeixvBw
 Atug3pSnias6tkDH33DKzgFhc4pCcYnyYZ3NTCrMEH2R82QS8iwjnSFlNhLBDuPKYIWalgBH8ruee0pVt/HGpyia7jAheJFTkg6fPO+cTqI13W/9n+LVkf6Qw//SJ7JgMfh4PEWGWPFPh3wv27lP7mfIU/j8LMUms1rMGAsvG2HOTx2mtOlNj508Gvfc7jco8LovXaYSic3CwL1Elst/RnfVPII0mc/S0NCHp/M8bgWLNbj57UasY+1RsJD4I6lN2Ic6oA8ZkP+G5uSzF8mp2BRgevg5kkpx7jY2JtPyfwCJN9EWlwglKOh/nTVVdwrZH0CYl8XCHDhXUH7NP+kYtckpoW5SuFw5TDdf3vEt72biD3PTYhDFOX1VuTpb5o/WUjMbNVH9BRN+9vAnCbXRvt5d/vX3g+SKJ1t3E0lIvq6jN7jfStS34asWNrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 11:16:33 +0800 Chengkaitao <pilgrimtao@gmail.com> wrote:

> Hi Andrew Morton，
> 
> I noticed this patch was dropped; the failure report is here:
> https://lore.kernel.org/all/202603251338.grra8xt7-lkp@intel.com/#R
>
> Could this be a false positive? The series has two patches: the first
> one already removed references to vmemmap_p?d_populate() on sparc; see:
> https://lore.kernel.org/all/20260201063532.44807-3-pilgrimtao@gmail.com/T/#mefaa36aeff173d08f0508cd44be46e830c067fe9
> 
> Might the build error be because only the second patch was applied,
> without the first?

There was some confusion over a later patch which was there to fix an
earlier patch, only the earlier patch was dropped!

Sorry 'bout that.  Can you please resend the patch after -rc1 and we'll
try again.


