Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50296C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2D86B0167; Tue, 18 Aug 2026 05:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABCC6B0438; Tue, 18 Aug 2026 05:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7D66B0513; Tue, 18 Aug 2026 05:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0DB56B0167
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:17:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8DE2120B79
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:17:12 +0000 (UTC)
X-FDA: 85113836304.18.647667D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 194B340002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:17:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Sp+d8/Up";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044631;
	b=SW60E+mMcb/A5VrAvUVq7iK8dyUXm/QMvfIBHK3V453yfVBSArV4bQwlz/09kFSIPE9jkG
	L54eElamxjlIjk/1zjD/InnHtCfyPhOZSTWJT2K0g4zJRXGcd1mUgzLpEAKBnL/buYymrN
	2ilmd6lEs20wU8IXs5MRDgWYyJ946VI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Sp+d8/Up";
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgxvZuvkwadEpFuIclkSP8Q6+jXLcm9MUedkH6duLsc=;
	b=wA9JbhjZKsoL1zBCRT+cw9fAECVuN1ajUPM3CxIgy19tIC1e1FeCfd9rNrWTO+mp27LtbN
	Fj3AN/eOhBGNDkL20q3OI75i+3umGGIqLPBACw/KfmJK+ajix+45Y+kbWMozV3nbqgbi6H
	hPei3WvR11TuYpA2mlpd3IvT0uzy8kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25348433BB;
	Tue, 18 Aug 2026 09:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5751F000E9;
	Tue, 18 Aug 2026 09:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044630;
	bh=CgxvZuvkwadEpFuIclkSP8Q6+jXLcm9MUedkH6duLsc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Sp+d8/UpGyNfg9ewcl0Xff86tUjKVbiovZXBlh3Ez8eoIN3BHBBPccNWCWgOFcs7r
	 LVZEt5YFnKAmBxjwOWsKZ14WMGgXL99MEGoY8psZcp9Va/MxxfPaJUDoWcUM56Kk21
	 yFQZxRnckxSwrP5xQXVRDsbGZSyaFjGQUsTRMMpaA1QGx0xqRlBR6oaT+60odvl2u+
	 JQH3UW2CSjfU/6pE7mweMMg7erA82fC2Pq6GSQbODg+g7jDCbuugtfcSxPUWKS2+GN
	 M4Kgfe9jfmjsZ55GZQM2ppBjHrz1aoxwZudGG0lU/6cI+eYbucLvLxMsOcfnbp13BY
	 HUJTI/5305zig==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Pratyush Yadav <pratyush@kernel.org>,  pasha.tatashin@soleen.com,
  rppt@kernel.org,  graf@amazon.com,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  kexec@lists.infradead.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH] liveupdate: use scoped_guard for mutex in session
 operations
In-Reply-To: <20260817025146.GA133735@chenghao-pc> (Chenghao Duan's message of
	"Mon, 17 Aug 2026 10:51:46 +0800")
References: <20260814095506.631274-1-duanchenghao@kylinos.cn>
	<2vxzzeyo23ol.fsf@kernel.org> <20260817025146.GA133735@chenghao-pc>
Date: Tue, 18 Aug 2026 11:17:07 +0200
Message-ID: <2vxzfr0b23fw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 194B340002
X-Rspam-User: 
X-Stat-Signature: t54174kxckxhcpdp5tmkwr8oqwxqsnd3
X-Rspamd-Server: rspam06
X-HE-Tag: 1787044630-706139
X-HE-Meta: U2FsdGVkX1/X4tIHWAq5JGV3x3R9bnvtDZwXsNY2ofl3/JCwU2MFs6OvO+6/s309afPMzGCS9WfkDmt2TV5cOEIWWM7BXgak4ZdUWpl8NBFIHWlBcrRzdzTCEocgqAzzuyFJFJpGaBa2FAKX3tfYlbHeTnFyBI7iAl1LbV8FJMNkBPBBzKlrFd2/5zu2y5nM/sAxn4RIxJDmQ1EQtG50EG6WYHIO4Medj7lMQeLBLoyFfEWfIhmvnIKRkmd8h0pIU+Z/Cqr4dPIU4fdAynaW60kCTWO1OtMByG8MqNrFHWn/rzAIl6RKqtpoQOj6zMXBshSx03wsaM8OVCeNv26sKJ0zlWgUY4JTwkvGxltCiCF+9KeC+n0FGsWFuEOi7k2HexMXw8+YnnH3Bw8dzVSb0xKbOXnmq1XYDXi2aTpFtAhs7ImZQyGEvqQcX6IMjvltDP3i0caam/a44EFl7yoxrNiB467sdVzJZPcwAVZ8/uHGSjNE5VHlDWwUQ66wfr9ZjApc9ivoWs5NlEJ6MocOFJ73qcNVaY309J284AaWBZZ8mGQxi6TYgm3Z6co74W7CDFNkePrfdALAwqarg0idMiPdl31gouOOkKpZTOJsOMoUEAAsY5OH0YwSmcgI4VX2ahKC5q+5e4nJ/0PfjDtgcVj+kDijQC1ESBnLmZ2mo/doFeBCj/kBnO9Jr5QANWFfGd9YLvWJfIL7EMjmiEYC1ifJiZrDGcRAW0kHqvHgV0ISxfhJE6VC3e7QR90DxcabWidUDZVswt+jaVKtuhrDqTlEzLjy8lNYMp9iai+CIIP/ySDn5iGbMU1e4CWdec/o7d+VLyJYqMBlym1OBgDjrdZD1BlkOuq22up2hKW2QVPCjXw8yZA/W/vqSBd4XscJISbUnaWtG5+1yiRXNQKAOZVTwKiOmBF/WGcTMUY23N0FkAl3pWV3QRfXRrWCC6LQKJgqYMLJR8vNyro0Vmq
 3aZgkKHA
 GqHRPCFao2PmrMvoLPSOJ6T1G3wkZ/6wC6zvoVb1fvI6Fo5jdcPsk+TDI7pVvrA/7Yw6+D7nIQUa8FgXTJViAOZvNbJnsmNFtvV7+sHhjgdprY1PqvDw2Bfb4tFlHN695TF1LFJPtBQmhjxWxE9bpqD16ZAsVq2kArHZQpNLIKHQfus9zWl/jnVNYZw57eOe5Gqf6H2PArq2Hmw1ZpS/BJEpcOSvaHcUycn9NxR5IDJnYHBkat1VsrzP2aWJlCvQWuqk7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17 2026, Chenghao Duan wrote:

> On Fri, Aug 14, 2026 at 04:10:34PM +0200, Pratyush Yadav wrote:
>> On Fri, Aug 14 2026, Chenghao Duan wrote:
>> 
>> > Replace manually paired mutex_lock/unlock with scoped_guard to align
>> > with the coding style of the rest of the codebase and simplify locking
>> > paths.
>> 
>> No. This is done explicitly because we don't want to mix gotos with the
>> automatic cleanup-style locking. I don't think we should change this.
>> 
>
> Thank you for the clarification. I understand your concern about mixing
> `goto`-based error handling with automatic cleanup-style locking.
>
> I was wondering if these particular cases might still be suitable for
> using `scoped_guard()`. The patch only changes two manually paired mutex
> lock/unlock instances, and in both cases, the guard scope is limited to
> the operation that requires the mutex. The lock is released before the
> subsequent error-handling logic is executed, so the `goto` paths do not
> cross the scope of the guard.
>
> We could also use an explicit `scoped_guard { ... }` scope to make the
> lifetime of the guard more obvious and easier to review.
>
> Of course, I may be missing some broader considerations. If there are
> other reasons why these cases should retain the explicit lock/unlock
> pattern, I would be happy to follow your guidance.

That's one of the recommendations of the cleanup API. From
include/linux/cleanup.h:

    Lastly, given that the benefit of cleanup helpers is removal of
    "goto", and that the "goto" statement can jump between scopes, the
    expectation is that usage of "goto" and cleanup helpers is never
    mixed in the same function. I.e. for a given routine, convert all
    resources that need a "goto" cleanup to scope-based cleanup, or
    convert none of them.

Which sort of makes sense I think. Also, cleanup-style guards can cause
compilation failures too. For example, if you do:

    err = sanity_check();
    if (err)
    	goto out;
    
    guard(mutex)(&my_lock);
    
    ...

This will fail to compile.

Now this problem doesn't exist with scoped guards as far as I can tell,
but I do see why it is recommended to not mix them with gotos.

-- 
Regards,
Pratyush Yadav

