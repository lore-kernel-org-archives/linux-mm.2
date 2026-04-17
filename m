Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C054F436B2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D356B0118; Fri, 17 Apr 2026 11:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDC36B0119; Fri, 17 Apr 2026 11:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613766B011A; Fri, 17 Apr 2026 11:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3536B0118
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:06:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04B7886EED
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:06:29 +0000 (UTC)
X-FDA: 84668374140.27.A0684A5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id E0C7F100023
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:06:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8SRZx91;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776438384; a=rsa-sha256;
	cv=none;
	b=QFttEp2Ixn8b8BstmtDYV3x83O6dFcG3JsW6EJ9LbHqzWhvmBM4j6vJbtoGeqe5SEb9QXX
	06qZozLYSZZKd7cHzXzgbnsBbcVkibTiiI0Nzgmb4D29jk27JX1TG8Uxs9Fl7c1D3lPaCT
	lFuogmiGWehi5xVC9QETcbo7glR/ZAQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8SRZx91;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776438384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zS07p4gDFB6pdBPpu2rNXcWukXsE2BkNWlsBXyw8e9g=;
	b=G8wk7uX/UEE9RVYE2n4lKm/8+Io19jvK6ttRt84Rrrb69aLnZz1m2k+3yx35KrIW4m+duZ
	VUQtfvo1lAhUWMKv7SoPkzycRm2dHrjMQK2W/X8xeffzFSzUJcocqYv1aHPxs0IUDRRTKQ
	3GlNbOXTHDO07C5JcXK62YsyS2YSLso=
Message-ID: <dafcb772-cd0c-4771-b418-bf2a09a468a7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776438380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zS07p4gDFB6pdBPpu2rNXcWukXsE2BkNWlsBXyw8e9g=;
	b=P8SRZx91MY45Hnht8g6QGi0CxfNAU6bZHFtcHzFHxQbtXEO/xi3L4iArRBE3qWdaJeBeyZ
	cpkQiATZJbwNUPKoLvXxUCI+/yX6HsxWA57b1yALzMrh4A+ZP+dKTqhjPSr2kGuPz12JHU
	oTxbC4BTNOeIgR6/yNIrW8mm3S+OYqo=
Date: Fri, 17 Apr 2026 23:06:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
 <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
 <cb3dd598-04f8-486c-ba6b-9965d93170a0@linux.dev>
 <DHVHKSI90H02.143VLYN9JY4FZ@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <DHVHKSI90H02.143VLYN9JY4FZ@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: sdxr31qctqqpqqcjb6uhe4nt3y31e4p5
X-Rspam-User: 
X-Rspamd-Queue-Id: E0C7F100023
X-HE-Tag: 1776438383-297167
X-HE-Meta: U2FsdGVkX19woESGQwpeAJNN09wZU693VCZi/JsUpxhSZFUJaEO3PXPuTTP32WxzUuyVbISjlFmGs5POPBqxOkAjuj7xMYsPoj343K6R7ZSlBcCpA1rJd1WFQy5nem9g8QZGhhqP+YdY0hcPIuQqsPLOSTircSwVQyvXH18glKCE6rVUzihLNqpRIaqNMjogL4DgrsttGWxLsK1e9NKQA27E285SFeAP2tphBAxoOi1D9wI2p4DWwH/FJtsgJu5n/NSKfsceUmWgWHW6FBt0weJ9anLm1V4ykeITn4/LJdTahwcrzceFAe6dAzt9L1Hcf9UBPkm8CHAavw2VUWbHXobnPo4vtMAHtjfivLSWavNjcTwjcH9+yRDuE033libKfeWG1DlanOHSxN47RbvtKOoVoiVtVRJEUu7iFK8xOSULX90mdoys23msJu9it+QhMFiEmt/B6nebrfvGtt3iDcacxrHpQtX1lKrpGz8gHGbM2/iUTwrekVocZ5PXp2PgWFBW6jcGHppClgG+tsUotUoLFbqgAZVRTH8gi9t+k0LNI3/v7AuT20fmu3t+1sW56rXSax+o23ISNBB8GOiSUxCwgvdjfoOhKnrMwcuSKI806Lw9nlsmINQHtVOUyJ0AsZ2kCYsL1bncP6uR+n4V4Pli3/IMMAstO87fnr1faJMzzVWuN7CAximS6vDLaQ/bAzSL8et+xcAoZtB0aRSQFV+NPM9R4EX86l4lvHK6SYCbUsWbjgarUd6kvf3ig2/8Qkxxbv+ID+raKwT2e8/S21+vPodVgFPrr4K7B+8nZjKt5eez/IPtyCKvy5Fh/Y3WQUfxsOaPcAk5LM41saC2Y2QWQMnBuLji03++t8ryR9yVCMvyaiQubVhpWh4F7YO+EW+wf0KcCrdnD/WHJiQkRppUG0Qps1r7yfDPg6Vz1WCEZKzkmVy4MmdEPoWjUVBBKDRW6dZIBhK3OTsc+Sn
 PDmuEBdr
 6GQKiLhmHhUYlKTUCRoRrE9J4h79aOZuihtZj4/FvAAA+71maFlx1a0o+6ME0TZGQkcA65UCEjp9HrsMgfwKH7GEFHtiT8AhTTqgziBgTTZD6CfvSujXJW8TIMW9klBXfbW/nh3222V+pBxSesYTK4X3ZqJEHKw/KJLl4CI54qRj9dfEH6RuwD+X3wCUTqrqK0y4nRrW64U2pC/xQ28sgjsKBzR7BjmwNyPAGTFFKsVS8Mm5TZg5bspMQtMTofcan/BGz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/17/26 22:06, Alexandre Courbot wrote:
> On Fri Apr 17, 2026 at 8:56 PM JST, Alvin Sun wrote:
>>> Finally, maybe I missed something but the new value doesn't appear to be
>>> used by this series?
>> This patchset is a prerequisite for the Tyr ioctls patchset [2] that I'm
>> currently developing, which hasn't been submitted to the list yet.
> Why not have this patch in the series that actually makes use of it?
> It's a bit confusing to see code merged without any clear user in the
> same context.

The other patches are currently under review and will likely be posted
together in the next version. I will handle future patches properly.

>

