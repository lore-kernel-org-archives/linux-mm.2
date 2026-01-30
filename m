Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BFEE6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 19:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A21A6B0088; Fri, 30 Jan 2026 14:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679FF6B0089; Fri, 30 Jan 2026 14:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585F96B008A; Fri, 30 Jan 2026 14:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44A636B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:50:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F08A48BFC1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:50:08 +0000 (UTC)
X-FDA: 84389671296.20.4F16EAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 329B68000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:50:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QAFXk1/S";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769802607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqUekhMS5LSWwcX7H9aL84G8/DDvAfv7LT8nfF4UBXc=;
	b=SqS/FgzV3XctEhaBjeLuoKJfsb5MgrAE4OjNdAybyvkUY7gSJk6Ninx7Hi4MRRKOfGpmoK
	VlNGPDaY1emfbcfp8zEuSWr7zN2INWA0TDoIzUfSUN02ch4VqwQ8jvcB1V/8XTMGOadCIZ
	OAdLbJ9Noq+Z19JNqPj1hvLSI71R1sQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QAFXk1/S";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769802607; a=rsa-sha256;
	cv=none;
	b=UwpuS/y7m/jaeff6pKNMdLCyJo4mfD19RThbnUBh7ta5SovCyo9w3pK0YhrRWwZQxz45/p
	5Kq8g+UVZeMOOu3+cQirOJrOMSKUK3keMI3q2oVYDqTU8rfuo0vC2+nai2+1FHsW6Ddm6A
	d8yThTMUg/akNuubY3wl2NwR60g8RIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1C9740AC0;
	Fri, 30 Jan 2026 19:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81A4C4CEF7;
	Fri, 30 Jan 2026 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769802605;
	bh=4MqJ0xG1i+4H/3cRqSloctdqhhWB0J2vgAAzwo3d5eU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QAFXk1/SgugS9OOblGfQgWX4z6TWpoYLsh9B0j2wLjiLkf2+8naZFrAy3KAGL8aPY
	 KeTA36PjTJxhJ3Up36xQaAguPd3Z0mFfMMh1BEX3m39u/1LzlCCroIs6th+0OhidfV
	 mX07tA0CIHg+E7czI0uqBokfGuox8pjHzdyQznAs=
Date: Fri, 30 Jan 2026 11:50:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 1/2] liveupdate: luo_file: do not clear serialized_data
 on unfreeze
Message-Id: <20260130115004.b530155b27d6d15929bcfa63@linux-foundation.org>
In-Reply-To: <2vxzv7gj7wv7.fsf@kernel.org>
References: <20260126230302.2936817-1-pratyush@kernel.org>
	<20260126230302.2936817-2-pratyush@kernel.org>
	<aXnwvkuTBL1NLt7f@kernel.org>
	<2vxzv7gj7wv7.fsf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 329B68000C
X-Stat-Signature: tt75rdah1z3d7c1qec1rg9i5hiosq7nm
X-Rspam-User: 
X-HE-Tag: 1769802606-670325
X-HE-Meta: U2FsdGVkX18Ig+FbR6+wKPot8S4eRkRN47oQc3Z+EA2MjA1E0wkG7hJWnnpPq7n9qXyqTcwvmb6XMVqeSvpr2UCs4b874Ne3Um9EMSlKuUqT2TS+me/7ybh3hVmFsh6G1P3OQIy6LuqkZzbdOotgxD4FKGHFSN5Inv0tTDlf2m6XVKEyz0ifzPoR2vmweTpWYHPKKzON95hn2OLcilXQiZMiBJnZWKP32v2W6P1bK95aHZdAkm0vZhwz6tCSQtnnBaUGaLSuAgZrQ9Bz6Q4h1Got1C/Kvg9FxJ6XGnPe0dDUjvbAGODccUlc1Me+B06DrY1kSDxnVC1gg1CXeh/ccuKdqGNCC03RFigu1AjFyJ/TxBiie/uOTWW9LfdgBEzaAaKDze54Zxk9A/xwsQqEmjuJ+i3N3yz+8bhUhTXYFGD/wNgqTxi8LuNi1XtqBE4FNsRoRBrF/QkJ6E1UPe1QP8neLQzTAWfBwIPCKY0pX3jxDoCXF4/6KzwQfLnF3tY9RKXkSJtJqMf7Rb9hf5XWyJDB7DLI+16hm/vecGdQtBOyCSLkzUNQIjtlo/UBbg9YQ61IAXSJK3a2q4s3L0I0bdAll2FDXoQ/JYvBqXkuc5jdB+npRW1E1WXz4kxNHyOkevRAAClkXathVnEKfyBDZfHhhgsE+zs9e+CREH2dlyCINrLsg7xaq+otbCuxEzFFhyQgLgtcRASqFK8raikH6qtPESzo7/4bqYk6InWQJ9EyMJq/U/G40hCbI1yf3Htf79HUMNQhYP6TbwGddKo6WoWrsCThE+Rm0cvR/L1pVoOAfN0ohTjNNejLIPAa4ud16ZqdQBgNQAkCMAdJkoNZ/xhC7RINJclA72M7rvoWxjQejGxzdOu6QMRbcIy1KDYIRGlWRia07Qjv4/PkB06vWELudg5C9CDmLzvbqLmiUeQPb3z/g0YZjZtMesRWaMnuW3eAvq2/3uVEP9S4Ai1
 uiBEisOX
 1NdARYAYpV75U5o8TjRp91K1DxfnJ9C9i2Qret0ZUOOWd5YuI8Jpl8E7VAqJzJBgvyg5wrcfCzlkq48y85Vz8YS6n4gYPHg/zNT6wdu3HmgsGAxBWDf/K5c1P706pQFs8YR/G08N+m55fRcHW9mnNkKyGTbYITCQlj2IGxhY3TLmCO5Kh2ESfBKl/XCPQB5p1lHfW7ILMHjYKDonYGdaE5IQQGYcXy1+Uwq34zfrypiV/1K0x2S3WOwhzIh4fS7igLl9x1SLZchrjjdjes0GS8CBrpdJVT6YDNSQNy3Ocw0L45ALXXAd4OCIk17MlMlivKrCL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 19:56:28 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:

> >> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks.
> 
> Andrew, do you mind taking this patch in v6.19-rc8/v6.19 hotfixes?

Yep, that's where it was.

> The
> second patch needs a re-roll and I don't think I would be able to do it
> this week.
> 
> This is an independent fix and I see no reason to block this waiting for
> the other one.

OK, I moved "liveupdate: luo_file: remember retrieve() status" to
tail-of-everything and added a note that a new version is expected.


