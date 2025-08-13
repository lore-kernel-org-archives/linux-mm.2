Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB69CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F875900055; Wed, 13 Aug 2025 06:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28245900044; Wed, 13 Aug 2025 06:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149E8900055; Wed, 13 Aug 2025 06:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3BAA900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:26:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A74DDC02C8
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:26:50 +0000 (UTC)
X-FDA: 83771355780.07.199DB8F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 82F26100008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:26:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=f8mVD5J9;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf05.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755080809; a=rsa-sha256;
	cv=none;
	b=i21kwAWV6N2bOQuBECDKdVtYt1CvhEbcTYy7r+dCDsBZPbzynQcxx0IgKEIFBAp1a/SACJ
	3edKMyca6u9sSzTzUEjOfx/faldURHKC9uiY4QK7S4O1pM9uT43XPwKNeJYG1lwvaC1QU+
	buBUP6VwQytB0XekEcmEOU5LfxxjJLo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=f8mVD5J9;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf05.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755080809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/igN/4vZBSgdq1C5WsUcG5wcK51bFeRFJTKMj+Q+1cU=;
	b=mOTd65i410fSiGANe60vzxr0DvlmegH6EDAtCPfS5u+mAXET9hHenKM2RezZmfDIrG+1P4
	u5AOhF3kGA0y4aOK0g8oSZfYpaV/+AVlgzlD04yVUZMhPxwoKZFFti72n9o6hHlbvA+SwO
	JUqIaLLS23VAEpgIdaHdmnv+ev5CG8w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/igN/4vZBSgdq1C5WsUcG5wcK51bFeRFJTKMj+Q+1cU=; b=f8mVD5J9jFpgHazX+M4wRz6VTg
	06OffFNxGS9eeenKOyJDu31FyTLSF2oPFG2gYMRQUJFC/OhT+mcn8zZVDbPDMRomyhAe/YxPnL7Sf
	0W+HLYiwUdZielZbVU85KOVFRN2Aw/0QikGcAjSjaob3eSRynkVLYlAVEF8MsT30StEXktETyvJAM
	qQe6t/V5vt4x7WDanAkKUJ85fxPOuoMkUbnhaDWTI+rcIAW1fsM1nXyzYe1CEbTULhsFk7LB9/J9L
	69Y9/UAfnomA9vmLNzdyCj4qgMBSZK9z2CSlmPAyO20izELtwz/xtiDWNxPJ+tESbn2gu4t9yQqpR
	SYqxkeNw==;
Received: from [223.233.74.188] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1um8gi-00Dcgg-50; Wed, 13 Aug 2025 12:26:32 +0200
Message-ID: <5d949644-6a4a-3b94-8794-27c2b5cfd976@igalia.com>
Date: Wed, 13 Aug 2025 15:56:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Content-Language: en-US
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: kernel test robot <lkp@intel.com>, Bhupesh <bhupesh@igalia.com>,
 akpm@linux-foundation.org, oe-kbuild-all@lists.linux.dev,
 kernel-dev@igalia.com, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, laoar.shao@gmail.com,
 pmladek@suse.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
 arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl, peterz@infradead.org,
 willy@infradead.org, david@redhat.com, viro@zeniv.linux.org.uk,
 keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
 jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
 mgorman@suse.de
References: <20250811064609.918593-4-bhupesh@igalia.com>
 <202508111835.JFL8DgKY-lkp@intel.com>
 <6b5c92c4-2170-8ce9-3c9f-45c0e1893e03@igalia.com>
 <aJoE_tzAGE4krB5y@black.igk.intel.com>
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <aJoE_tzAGE4krB5y@black.igk.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j7m6gknqfxhe8nrshp1m9iiksqxu941w
X-Rspam-User: 
X-Rspamd-Queue-Id: 82F26100008
X-Rspamd-Server: rspam02
X-HE-Tag: 1755080808-442735
X-HE-Meta: U2FsdGVkX184ZooNuMXDVNb2gjXEnDh/GjRe0XCDsBcZRbXnSaUsxebZs16X2E3I/qKZlAFJRQUU75izOhDt0iXcvpRK8b8p944ygCNiDxamy5sjc7jwlJhfGU+CZvjfWl+mElnJXqWxovhzacSNdq4vxLFLyalKxszbXg97C3J5XUg/0fLKQBziAO52PHsZfwTsrTLixvfKNstdzj4WFtLgvtjCB7YInckJIv34ihMg2hJ5bqQNDZHC3malVoWmbC9kel1LT0IsLykmnKfOxKwmJo2DqhIy23rPBQxqa9zdmDcxcAkU05DcYnwRDXGF/PaLychhXOp8nmw9bmdfju2vQE9LOEP34YoHWNU6icXUYf+N4GxDFkaxSftPqO98r3+fINuDVn87/qwDvNVSsPlqI+rvs7qOUTKTLSu2KTjcXUW0gonOOGE+XJJoFyf7UvjvhB6Y0BCAzMFB25yXcbxzFkD5xNOFls2JUmpB53ZQ13xq1cczZGljMCjpqlMgfDY/tVt2R7h7PYxPWHkm05Rxj25FYChrQfstkV/3RwTAza/8/dtX7XjysvpiqHHERzrasqmXINlwRmJz1sMC9O8Bjhm1zl4zv5Al6KxLsevIv/qzk/Uej+ZeeUOoDndHNtKDkIRv1yDEMjfMsUKD3EFe2c7AmHhUNKEHFHeau5ovJGzwwxvWeAMSupTLyVqNTBBLrclP/ByNecvzBCsXoLZNGBd0C/ZYWekM9NictovZBpof5F3iZNgckJHS6/CwR6jPSZX2qeJUKvqlVwROxjmC4DgocMpszTpcOQ+mSZzP7Led/ZEO0gigoVyQ9u1UnfIh2peVmWsW+m+4nm+u4dD1BNj1KdLvebqp8PrxdYlUjy9RTulfYtqnTDBLtrryrgwEyvKNagOehDJcSPWZdueWn6gwiqrSvzbsaJkMWZkkC8tccZjyzu3wSI1/NyovJCzA9Fl9JQGhV2bu7uM
 xXqLwIfc
 FUsKRh9rpKyCZyzJN1BbUmjvomifXMy1SgDJMtaL17yp8tZ8CZKxUPrNAOPI3Se5VqPoTSWgqWgMuk+slryxXeSv+F41yQOHvTF3ufmwH91DVMjnf4syNnVq1XIMGc8o/It6GWIYrtcSmZWmEgwigRSAeOdCFbOdJHkfcES86yScAGwjeZzqC+wovk/4QdiTwHNDfOphGZjTiF30/EVoJoe1z6HtLKpocb5NNKb454sFoBPmWKOubmkxVly6sKwQul0lrbdmqMSuUy086sQhfAA6QRY9HutwkPgDESWLEt27F+y72oqexgQz/3nioiACIfPiTtaBzfCxT00H2Sx/0ra8fOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/11/25 8:28 PM, Andy Shevchenko wrote:
> On Mon, Aug 11, 2025 at 08:19:08PM +0530, Bhupesh Sharma wrote:
>> On 8/11/25 4:55 PM, kernel test robot wrote:
>> As mentioned in the accompanying cover letter, this patchset is based on
>> 'linux-next/master' (the exact sha-id used for rebase is:
>> b1549501188cc9eba732c25b033df7a53ccc341f ).
> Instead of getting false positive reports and this rather unneeded reply from
> you, use --base parameter when formatting patch series. It will help all,
> including CIs and bots.
>

Sure, will include it in next version. Waiting for further reviews on 
this v7.

Thanks.

