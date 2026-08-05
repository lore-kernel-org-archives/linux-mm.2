Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA15C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E306B009F; Wed,  5 Aug 2026 04:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE006B00A1; Wed,  5 Aug 2026 04:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AA56B00B4; Wed,  5 Aug 2026 04:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB3936B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:07:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6C091C0BCB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:01:22 +0000 (UTC)
X-FDA: 85066470804.25.CF7813F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA5F6C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:01:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdkrKLaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB5C0G7Cc8JHFwptbKMTVTwEEYaXtsxurUQnbxM/1Dw=;
	b=bALIYjIsS2NL1Uk2AGzPcr5jRA/RNiV9PEkPvEIZOaFmD4uQXrXr503AwZjA1ufe5jfs9s
	eguXNfMshpO4EdEU/vixiN2PP02xqBFhWEmgW8Xk8ftbD278Vcp4gf2EEJbt0ZQyt/KfTA
	jsrPl/gyQBaQw3EQz1erzt7AJJ+I/04=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdkrKLaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916880;
	b=R6lZTb63zIc2ALUjWBcm6R/DT3GiUeRMwcPUZkcBD+SfvBXzvJb4AlgXd/ad326ZtLroN8
	Zllq0OELxfjdIql3ooqcMEbmQzm9Supm3Wp9P8v59i8+HJ17NLupKHJQpgCEbUjopDQ0Vr
	dyeuwdLaYFD5awtEhGXyztd6z5y2wRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8126660A6A;
	Wed,  5 Aug 2026 08:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF5F1F00A3A;
	Wed,  5 Aug 2026 08:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785916880;
	bh=IB5C0G7Cc8JHFwptbKMTVTwEEYaXtsxurUQnbxM/1Dw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mdkrKLaHV73pKPWdrMZAtd+WNOxofMCKwvOw9Xg+3CJkvFlQB1AXzc69l2ilhN99D
	 ZxhGARFTnKP6m2Sd6tR5ODzeFvxtJDZD3l6RDWzoitBTOGskmbHrgOS1cYonwgYMoX
	 vfMWvknXEQaFZ4CgEbT7XKf2U/zMRvhTsLpm8VVmMJDTL6ianioNJhBW4jzIp1rgXz
	 ydKqNW99qQgpSLoanjMw12N/En2YxPXSc9wUtBTOyt+k8ZFMitr5rOLOyTPlCDLYAt
	 X++a17tDXsluHFQuUsiuIzMC12oeIuyXOeE626u5RaKwVIqM7h0B6LUWgELbTmbY36
	 SDDHZwAXYig2w==
Message-ID: <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
Date: Wed, 5 Aug 2026 10:01:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260805004619.GA28508@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA5F6C0007
X-Stat-Signature: h7nos1e8esdh1y3hw6j3c8eufkehqgcz
X-Rspam-User: 
X-HE-Tag: 1785916880-597289
X-HE-Meta: U2FsdGVkX18MS/0dmKhF1L12/JwQeyk66pEzr2thl9S9y0tgSnVc98R8lknGnP19P54A6xpVS4kmiZ+y5ZYz35m5UBrqE6tIevZ3t+PGgdOEJLQq84WYHSDYtn1DobMtZ+JUfYCvzaSXsHJTdU47L45Gls+k194tPtgwhA2o/OSmcupw6d8iSt6ZSVg7bj5m67fKYHnHewl2DDMaHyrVFICudVgMMEXelwH1qLfvL8NynE2dJb56a3ZmR1HwHLrWscqMXbK9hbb76gH6BBKkNshrNKd+aWLZnCGa3VNGmqwEQh8vQEIGmLvvSHfh5AfevoK6bCJNaIo8KM1pEb8vQ4xfZNRczsL9csaAoYbeqMLb0397kpbhBmyRwV03fMqHH8fEhPoi/IljNKj10UlNYbd+ui5H9Y3AVtivfIAqykaHPRlTbMQ3Uz4dV4RHJhIpTsZoodMXgvCJZ2QXBtWk2bGPS3ahtakzhm0k/3isGCRUKkeKzL8tiDl7DRbBqBFBizyZnPWOVk1DspAjSOqL8+8Ol7xcbc9PGpvMviRtFxx3ZnyDqQgIoubRowbQyp1xfY39/PNxqKIe/roK9rACt7UwArNO430D6rkv62lqYuEQBOcAy2E/3fJpDroNr1EQz+WY8O2lOzaiODHqH/hb8RknGvNc/iRuTJvIv+Um0hfkJaMV11F7tbg/IN6rhw3N0+SLXoXbauf5uAzpsc7plUtgCwATvPhapj/IbPYdKh+MHjL8+SIbM69KFvUkNSyim1Ri2MbfJauZs+qDfjuFbZQCFEf1X2dEUOxyumOHgoCNyi8y1YOJRy+YP55Icyr4lB8p01Jun9XGurvWB5JT50i4JnKnn/f0PWTaSpyfa0vH73hH6ov9opop6QYEXclTUI9kQsG1gkMc1EeYMvpLZEEz3jhm2WHwc0hTAUJJGiJD30ybATrg07QM7DjiQ7BtmR1cZ5G+8CKlGNu2aBI
 rED15WoZ
 3F0kxXYFqWzv/u0jrxsxeoph+Cvmn/HvIuLRaTvqUNUAhPoQit2BieyRljXUAUEWDA1IWGDP7Hb6yHeUN11mSLdhUcFAWfAfmMLJ2y0jDe5BxRLBC0eYoa96qKM4SECWPNNqNJp/EwLvej06CZJa99ww2YPq2y8yPgxq0M2Ou1oeLsyeBucTryxaqA52LXMrtoa4ToSfw4IVeJ+Bd+aMit3JEkuVCCAd01lKzAHAaTWdBqsaIAtTAJF798uvGgDpx89Da+WJT/d27UbjghJgSuntegKYnUSd1iJ4nltAJ7ffdtwyu7xaWkDz5jQybNhYz+cegoIwWhrnBf7aFNRbECWQnse56S7OknD0VU2GgYDSWGLwoPdzMCfH6qiHL5+g3tRNt7Z+8pD4AaDgh4eBnCYu64e9acXX0AV5OgCEmnSW0i+nEqLnWrUafFU5VRnmJRJGHgn0UPlOqLBYH9/9WkYuWg+hT2H8JTcn5Fh2W85dUSFTzy5m2T06eY2loBYBTrRUSx4ZiRXX0hhqYUwIMu+sOxuiWIH9t5ewlJ9dHeUg8DXiG5H5MHiEksA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 02:46, Jason Gunthorpe wrote:
> On Fri, Jul 31, 2026 at 06:07:24PM +0200, Vlastimil Babka (SUSE) wrote:
> 
>> > Thanks to Vlastimil and Pedro for the help on the plan.
>> > 
>> > Summary of previous conversation is here:
>> > https://lore.kernel.org/all/20260618152451.GE231643@ziepe.ca/
>> 
>> Yeah, unfortunately, "too small to fail" is a lie, because in some cases it
>> can fail (such as the task itself becoming oom killer victim) or any of the
>> other conditions that can cause __alloc_pages_may_oom() return with
>> *did_some_progress == 0.
> 
> But then we are back to the original problem, an erase API that can
> fail is fundamentally broken.

That's why the plan is to add __GFP_NOFAIL, which overrides the
possibilities to fail listed above.

> Jason


