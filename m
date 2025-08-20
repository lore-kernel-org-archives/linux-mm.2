Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3F4CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EBB8E0059; Wed, 20 Aug 2025 07:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFB48E0003; Wed, 20 Aug 2025 07:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CF98E0059; Wed, 20 Aug 2025 07:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA278E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:03:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8735C8366F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:03:26 +0000 (UTC)
X-FDA: 83796849612.03.66F24E0
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9077820006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:03:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ecXwQxiy;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755687804; a=rsa-sha256;
	cv=none;
	b=lk+CUD+WbQqVv3Dq7THDRTkkvCCGFdKUk/fchKoIXUrUgiASrFmceDG4jC0dBrwHTC+LzJ
	wcFnVOJuu0Zh5mYyl8zWVBEotbtucAdYep5UTyQiWrxynI1JMVdxPOR6iOWgSN3wrOmV7T
	sR36TrGjH5jVtAX9QY2YFihLszEuFvQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ecXwQxiy;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755687804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahfDDflpdzQ8/uA6MgnjOXMXSU4HqqXX/CS0VshQj8Q=;
	b=F0swXdnjnmp+Wa60h35mCq2DADYEuF9ahy2ZPIHe0R8fMLr87G4Ccf2GUOsLa0BKU894r1
	rONU0rri6O/SfUNEl/gt1DNdh77mU2JU48P+4C+Oj4EnwTmEgFd11dsrPs4XvOkkrNYUGA
	ZA3go6kaNM0QqzvWb7cpOVXYDR1t0Cw=
Message-ID: <df3b5c81-eb26-41ec-a27b-28c273a74859@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755687802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ahfDDflpdzQ8/uA6MgnjOXMXSU4HqqXX/CS0VshQj8Q=;
	b=ecXwQxiyrEPuNlT9g4k47z/DdQB5eI1OERolpmZUu5ph04yCWrGvSa+YRVVnfgvSRhOUCa
	SsPJaDUuhqnd/OIznPyx1+8DZ29YUUNt/tTb8ICrXa9CX8LhdW/2qXFbqUL9B7W42/AErs
	+pMmxGvnDzvqOZPTRB6ltrhhDn/RUHg=
Date: Wed, 20 Aug 2025 19:03:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] panic: Clean up message about deprecated 'panic_print'
 parameter
Content-Language: en-US
To: Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, paulmck@kernel.org, john.ogness@linutronix.de,
 kernel test robot <lkp@intel.com>, Feng Tang <feng.tang@linux.alibaba.com>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
 <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
 <aKWWcPOf9qPIoCe4@pathway.suse.cz> <aKWYELPjbhC7R8NO@pathway.suse.cz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aKWYELPjbhC7R8NO@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9077820006
X-Stat-Signature: io61u5zwoonwfnzi8jc9fhf5hndfcphc
X-Rspam-User: 
X-HE-Tag: 1755687804-166980
X-HE-Meta: U2FsdGVkX18i2frUkhuq7HuSQpBZYkOcxeiI/h62ZiEqmVSoE1gobZzgb4z7t8jtDkZPIvuAgbIBqYK9RSgO9wA6kRQ9xGwIaByTBm2ML9fOQknFfOQWjumTpmQ5UUMBh1ShJcBdizatIJ3RjXy9FsFkLjymM6mKx4Jnr9vjQrEmOm2hQQk+Zdaofgh0Qr9t/o7+qAQXvVUGsPazK2N1l5FA4V6CHwgmhDoXco6Y4BsS0U509QqfLnoAQV3RxGl0SGLp8zctssYSiQOIIOzpkW4AQw6kPk/6FuRH9r6V8sZuJob4RngATOvz9xS/6G2CuKEe6S32hol1AvRlGz9fimOjIABoXdTW3o4gDfEDsdFk4pThMxyO6dv5eV303sMZCyeltddAJJAnYTCxunjPNdijis9dUM6VSecAlhmqgd2CMuJ3NxUl8d/4mvai0yHagDyZtd8GmwQD0K4Pf/MIh0v/2laSaqXAfX7KSazQeN55VTwu5weq/JIyIoOL1L6VG1IVpmvBOyw7F58boJW0UiaGV73oMFcT+wUB+idOqzbVAMTY3DrCZghS5YSct06JUCI51ufExpNPnD7621bilonew4191YRq1lYTxZJWq6KSKt/M/a0ffjozsGtwN9BRN0CzZyXtHTWHWS2I7Lf0BY1I5X5qE/mX6tAPvfvZ353shkZYlAyucgmOwGG1gW1ULBKzfaeV8XGCEhPjSQg7008OJDzvXpqOru2pU0rNnUWP1bV7xPQcfK/JiKxhLpecRuS8CweX/IQfcThWZGDSvvI2slKMMao0lhIl2cIFqTKSD+2ofJmrrdtmRRhFnYQ7iSVRXvkS5HWZAlskIrjIP5+94WJbPyrrYUy97H+/WtiHgty1BE7TpfagQa4sSRff8o72RwERVgjwjbL8ElIJmUDw6JZOMHirDlikftWLVqPyCAC0H2a+tz/tro5/oPvoB6RpPNHPw1I7Gz69Nuj
 mSi6vHFa
 TywY/LVSby8K8b4PA9cQS7xFCE/TyalDnkTaTXuw+q4VfoE7UIPL/Ug26gOVGBoCsVK1MUfiucomCAglH4ThOGtbACBwHbIN6odMTKY8DptB6YsWcXnZGBZCS3d6BrrXrdnn87HHoZntvP2c1XJgg6D0R/SlyLa3npQwcOXP52+GH4aaDEi1M3K+OMnhVrpV5Bi63ycY/lEzshvzhdszLhB58A5mzc9cMTKGjyl4afIqhiRyxtc1KI4VkLrGeXdQj1DLVDg8RGKIOXQ9eGwnfAdBCmXqVTSgA3VxaJFDV/CzaBWsNZsfKoxcKORgmeWGvArTb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 17:40, Petr Mladek wrote:
> Remove duplication of the message about deprecated 'panic_print'
> parameter.
> 
> Also make the wording more direct. Make it clear that the new
> parameters already exist and should be used instead.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Confirmed that it fixes the build error when CONFIG_SYSCTL is
disabled.

Tested-by: Lance Yang <lance.yang@linux.dev>

