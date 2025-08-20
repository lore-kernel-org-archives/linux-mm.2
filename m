Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B89CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E2E8E003C; Wed, 20 Aug 2025 04:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B460F8E0037; Wed, 20 Aug 2025 04:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82E28E003C; Wed, 20 Aug 2025 04:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94AD58E0037
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:58:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36D9B83120
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:58:03 +0000 (UTC)
X-FDA: 83796533646.18.0798EDC
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34F61120008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:58:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUMW6Hbj;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEEqRTpCY494Z2w/6UzF2GroDTGA/QgdLl+vHg5gpWM=;
	b=ubA2vy1IXFajVtrfuJw8rQQfWEycq1S8cxwmvtkqhCdnlXjMeMDy2vEWn5BtXt0m0fuVMm
	R+hAiAcvE8FF/vMMY2oM3ROSSLwj5deajP6kHTrM7ckET1mO/eCwZSZknktjsY2VecdMDj
	4uFqC0yhe0OlYXH/DJVdTiVbNYFytG0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUMW6Hbj;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680281; a=rsa-sha256;
	cv=none;
	b=W9SWLzi7F+AKTL4vb/ucA+9tWJlZFjwdUtqbrIbWPzAF9Z81jUobdAF6CfLErB8+lVoq0s
	qutY2xkHSlFZRR8sywQe5nGk2Gzp/KPtSh5CSQ+nQCmB2qZGjswJN3FFS7ewKG+HqH34bf
	Bmh01a/mv32bEuwPTzhfV2RuyAvywh8=
Message-ID: <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755680278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IEEqRTpCY494Z2w/6UzF2GroDTGA/QgdLl+vHg5gpWM=;
	b=qUMW6Hbj6XpyGTTHVacRcB0VNDElfP38acQxvpCBCvZDxpr6JIaa3vx9DWfjqG/5FKivrI
	RqR+lXLDft931IhrqBn0p+7Efk3WT0rnTMqj5MN7gHgyl9Dj+Zr/LghS3hdDZjK5bD9hLn
	eJCXsIae2gMiusK3+gUaUwmHUD5vdag=
Date: Wed, 20 Aug 2025 16:57:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, paulmck@kernel.org, john.ogness@linutronix.de,
 kernel test robot <lkp@intel.com>, Feng Tang <feng.tang@linux.alibaba.com>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
In-Reply-To: <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dzc6bconm5fj7rt4udhqun9hfsg3hx33
X-Rspam-User: 
X-Rspamd-Queue-Id: 34F61120008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755680280-570778
X-HE-Meta: U2FsdGVkX1+l1lXnT0rx5yJNIsguFVLk/tH9m69oL3Xdvf/0bbVI7HUDEEK9ddfBrzzrFwISbzo1jCULFaGnhaKYfAFtOJQdDoN0zAqDxs09wDBskVZc+XI9pCtzA7AsZp8+Mf3JAwIq86GV4/qFHkXUJ+W8WMAdbTrQm5sLrynaX/mpgfBqzTFdw5MG3VfdJVVYkL56uKUScuCiOR35BYm9McLtLeAKuAjYdjDX5hGXuZnANDCVzlP4yxh7j40/E+BiKMubF73JJYdMeGLYFZsjlyIiNyCuS3qu8FA2xgbZDrsdhek11igsu6ZCf/rBOwMxykx7k7B1IP4d/3BA/42oJf0VoZWc5ypb67hFDGx9D7pYmxo4fD8Fi/0aUNWiSI8dWW0IFeCBb2rq9rnyo3TiP712ZQdC/LPcfEPCvViKo2YosITOPVAu5z5EAvVuTnDcLR6X2SMEGvQuDKHBqr5BS1ELasbw/KNFC42s+x5vAkkm8eYLUPKdfn8crLz/pWEHGA0mzl3SNg0gp6KRLnWKJbfjHsDjtjNMk5xrOQjEFMV6G26nO+31BevCBnM0ky9P3c7OobOOv/k+w2sL+yt/vBFpLbqqA8aHKnWl9g0DOrg6UiJfjbH6gbmeoD7TfKY7Oyc7+SVjSHIqAw81DJMZcpkIiK3yJDcb1jYfeEQb84+KoQyGxzk/T5KLEUYgYon5JOUh9p1NnpcbmyT525ULBdKIOctYb+JOtDhKJKKtAYAZoUa2SYqJuXuVgVROZPEq63JH8TvADR1xZxCWKrNHb4O1TkbdEF/lJXicDaoX0Hbehj4Few4j9V0v0W9qufxS5vn/kPTEDjv/M+g1xMZ6RiY+bjMfwarE5iLAF701vZqHiuUI6Ry09thHsIxp/zHhhOsuahQS9qlHgfGIiQ1cLeUA+gsDp3saMqrspMBt2d1mHv/ZQGt83fy0RvsySwi1SKINP9F4vm/Pf4o
 VzBXG5D/
 sINNjCxBXQ8WQ2IKJ4Cf9TuiCRXo4fbY7qAzr+bMRcVh2YBV5Xlo3Z70myRe+Bt7wyrvu3naQVF4wP2dNeVeLQosC/Dq66AzXKx9QLD0/lp0QMPFRabD9Z/jEAzJarkCXvZPR5YkYguuENTx1lZF4muNes/GxYm9jO3WAuwAmmVZrREwkE69x4TUJsCGx7KzJT7wUkyZz721fzrmu4MQWGerOROBMj5En9951w2Hz/ie20qXOvxFOvKpNqcNz5yc+AYjs2mP6qPd+b8QLt2bA7C3oD5Cm5XSst4a+LPN6s6ZgylR5sL4KO3NMCikbA6PM1KwPptskLyOUgUV4xu5nHAePOFBWuHjv9uxmSogm9k9i2eUz8d04smUblPFt2EKeqJr+ddjpVP/ExRG7bCKmxhBU6o0++njL/y9KuR1P9eFDfLlgXRaXlIIHPeP7FKZeDwXtEje7gnyvbFRVxOc0cEa4aXroJ3p/+JN5wyst7fPPHpk5Jy6En9ijW/4J6+t0GxnHbcZJjhxYOK47WEw+oNTjBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 09:56, Lance Yang wrote:
> 
> 
> On 2025/8/20 09:54, Lance Yang wrote:
>>
>>
>> On 2025/8/20 09:31, kernel test robot wrote:
>>> Hi Petr,
>>>
>>> kernel test robot noticed the following build errors:
>>>
>>>
>>>
>>> url:    https://github.com/intel-lab-lkp/linux/commits/ 
>>> UPDATE-20250819-180717/Feng-Tang/lib-sys_info-handle-sys_info_mask-0- 
>>> case/20250815-152131
>>> base:   the 3th patch of https://lore.kernel.org/ 
>>> r/20250815071428.98041-4-feng.tang%40linux.alibaba.com
>>> patch link:    https://lore.kernel.org/r/ 
>>> aKRJKZHgcxyNF3y7%40pathway.suse.cz
>>> patch subject: [PATCH] panic: Clean up message about deprecated 
>>> 'panic_print' parameter
>>> config: i386-buildonly-randconfig-004-20250820 (https:// 
>>> download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub- 
>>> lkp@intel.com/config)
>>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 
>>> 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/ 
>>> archive/20250820/202508200907.PsZ3geub-lkp@intel.com/reproduce)
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new 
>>> version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Closes: https://lore.kernel.org/oe-kbuild- 
>>> all/202508200907.PsZ3geub- lkp@intel.com/
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> kernel/panic.c:952:2: error: call to undeclared function 
>>>>> 'panic_print_deprecated'; ISO C99 and later do not support implicit 
>>>>> function declarations [-Wimplicit-function-declaration]
>>>       952 |         panic_print_deprecated();
>>>           |         ^
>>>     kernel/panic.c:958:2: error: call to undeclared function 
>>> 'panic_print_deprecated'; ISO C99 and later do not support implicit 
>>> function declarations [-Wimplicit-function-declaration]
>>>       958 |         panic_print_deprecated();
>>>           |         ^
>>>     2 errors generated.
>>
>>
>> Oops, panic_print_deprecated() is defined within the #ifdef
>> CONFIG_PROC_SYSCTL block, but it's also called from panic_print_set()
> 
> Correction:
> 
> CONFIG_SYSCTL block - sorry ;(
> 
>> and panic_print_get(), which are outside of that block.
>>
>> So, we need to move the definition out of the block to a common
>> scope where all its callers can see it. @Petr wdyt?
>>

If Petr is cool, @Andrew could you squash the following?

---
Subject: [PATCH 1/1] fixup: panic: clean up message about deprecated
  'panic_print' parameter

From: Lance Yang <lance.yang@linux.dev>

Moving the definition out of the CONFIG_SYSCTL block to a common scope
where all its callers can see it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: 
https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
  kernel/panic.c | 10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d3907fd95d72..24bca263f896 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);

  EXPORT_SYMBOL(panic_notifier_list);

+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. 
Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
  #ifdef CONFIG_SYSCTL

  /*
@@ -122,11 +127,6 @@ static int proc_taint(const struct ctl_table 
*table, int write,
  	return err;
  }

-static void panic_print_deprecated(void)
-{
-	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. 
Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
-}
-
  static int sysctl_panic_print_handler(const struct ctl_table *table, 
int write,
  			   void *buffer, size_t *lenp, loff_t *ppos)
  {
--
2.49.0


