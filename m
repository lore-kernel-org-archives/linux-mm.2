Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21EEC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 06:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2198E0002; Tue, 22 Jul 2025 02:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AACF8E0001; Tue, 22 Jul 2025 02:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0828E0002; Tue, 22 Jul 2025 02:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEC48E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:05:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3FEBB785C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:05:11 +0000 (UTC)
X-FDA: 83690862822.01.504C43F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 418DAC0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:05:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYfk9ddf;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753164310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9BWsXCxaef2ts99/bTOYj35C5lR2CsLaB/EDZjhpEM=;
	b=skdnn9jb+ywesLLLrRlhyWgYX1PES2WGB9FWr3VRq2lqlnlrLiDiyubJmPzL5aAP+OhO8p
	jRHfWdRre6uT0Mlgnx4LM1xkVExEjDjcHzKAZp4QtJ2ADeBTnoaRzHizP99R2jrbuEMh2+
	EVYrR3Y3ndJpRHetFWlZulHCmfS3PFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753164310; a=rsa-sha256;
	cv=none;
	b=nx1e9kjckM9/OvGEuaixE3KSIUcafQe657qLQxDfKTWryq7/uHAnIliv+acSjdQ1BGVYXp
	xJ92dyNUgNXKK22YWsZb2YDnnzuBgDvrA0kLtIQKThosQ53Bc8EelmikhjeVu1ySIULW45
	ogsOwayb6on3cZlGJ99So4J3II3fuzM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYfk9ddf;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4FE3600AC;
	Tue, 22 Jul 2025 06:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432BBC4CEEB;
	Tue, 22 Jul 2025 06:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753164309;
	bh=F134i57yThMGkReks3hjElxUss2HLVKAnAIFuY7jQ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYfk9ddfFwsuAZUSdq0PnLLV9IqxxB3vO44fsKlyRJ3eK5koOvZ5xVgpsHhmBIMI5
	 yMoKPCcjyyyRAdDelkmmPF2gpBoAmIeH9Rf+Vaw1KozDPOkUDbFeCTUE2iZXRwPE0i
	 NVB+aZ5WyeEK7QO1dDEcRLbCEbl9iZRXpxZuKagZcjzPbNG3XphQPCQb9dkttTsSvp
	 MpInKMkZ3Rut53qZAVHQxpqAWZyKfimTVZdtXDkwom23jSg9eTsgJDtn8Kj4UqiHg4
	 0YO+b93RQuwYPThTPwdkH8pz2bq9bkdmYHkm2nkErTJ1G9lmqTAZgG4MNH0a8trm/3
	 0mR7uQAu2Jknw==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	oe-lkp@lists.linux.dev,
	lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [linux-next:master] [selftests/damon]  4ece018976: kernel-selftests.damon.sysfs.py.fail
Date: Mon, 21 Jul 2025 23:05:06 -0700
Message-Id: <20250722060506.56112-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <202507220707.9c5d6247-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 418DAC0005
X-Stat-Signature: wwnk38aeta9ihcq4a1o8xaj7xij6m9j4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753164310-522484
X-HE-Meta: U2FsdGVkX19kuY+9tw0IhDUbfUw9xSDahtFmI/JfKA9WfO7gbSZGViDri6qWACXQLcQe+9RhFw+LyiSFOkOBme94dkL/W+0DsdqCCmvBCD+xVWzXTKJ9i0G5X7/fGfm1LKtZIeL5pjbxN0pFqYZUcq/7o7/T6Dt+wRf+3mMV7B4uU+iyB4xVChvyKwLd2cONr8f/6gr0Z2c1xB0ZxZa5bpsRwf4xPMDhaTwDKP16TxT7I72yG6x6f1DBcLwKVik/tP6Poixz6HkqWrMYMLw2jHm3Un/OJki6QmniduRqHBrb+Ta/uklYRXbLa0VtdnBDEi2MuvGzASMXe2STXyGk+J//yIGD05or0sDar4pZhVA9Z7x5uEfTYvW3mf05Ek5dYOvpSR4NOEObnr6LxgWkCKyolqxKv/Bz/6bQWQUtkeePPq0dvQAeQJCU5eSWYPKl+eVL0oIvwHqpee1Lksed/kjMenIxTEMuZhIu6OkKEnTruwj0Ipeex3VJz7pf+k15MOYqZuYE9mrXTX7OiPe2W+T7aj26lyDZPn2KQR6cBNpr0Lq0XBaAN1Ff1X3K0etPg/egot/n5prS3Scz0gKsY02Nh7F9AZUX3PB8qSEPjCNUghyJT/TJOosq3lfIINj2YWfA0qqb1pJGFf2PjrMyEYdkhd9nXOr/+n1bVQIzFaaK89hc8Z48HCehEXYIvBm2KRSipve1z3WbKHIoPx8SX9YHc1XmrV5atmWXuPMuNhOR/MeZjaosWXrQ7HSWq7+QZrqsE4r8eiElV4Q2z3yf+3YO9RAoxCQNEIC/PDIEZzUG9rLeA/GtA80Ufju6DySAxlK7tnyF/IaJV+m+HC82GFyxkXof/JOQU+pY9mHdf/aRR1TLF28gI1H1FWP/OA0U+19tPxcWTQnoj1v41pGUfl4wik4H5v/StKoBmhg+v8012reyoQ53Kf5gNhoxdftbj+8iR6c3evNGZ47tR57
 ZqI3W0yT
 ZqPerh41wcAnLpzakV7/3EyiOr2SfQ6+ZtbpNPWXQ2jnpXdpQBhyAcOYrTU2NoUPkoBYfBMCb6a1Y4bMgVuTjv3qN8+RJ/nCsgulBDJO8GVhIphLUn9eULx5NXNwKFkIDKHTr5ss8+CcuHCAvpTHBXhYa9OUnFZZ4WYB6ksLVJ9qFjiIjZZN8StqyZRqg/G8S6PSOU/Lvp8pIoXvVeGriDrJEZCDDnIU5yISWgwdcuDCWhykz6IzO2XBvjyaimwLZ9fTO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 13:36:02 +0800 kernel test robot <oliver.sang@intel.com> wrote:

> 
> 
> Hello,
> 
> kernel test robot noticed "kernel-selftests.damon.sysfs.py.fail" on:
> 
> commit: 4ece01897627ddeefcede4ac709cd99763994dc4 ("selftests/damon: add python and drgn-based DAMON sysfs test")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master d086c886ceb9f59dea6c3a9dae7eb89e780a20c9]
> 
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-7ff71e6d9239-1_20250215
> with following parameters:
> 
> 	group: damon
> 
> 
> config: x86_64-rhel-9.4-kselftests
> compiler: gcc-12
> test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> besides the failure of this new added test, we also noticed below tests failed
> while passing on parent.
> 
> e227472ebf00b6b5 4ece01897627ddeefcede4ac709
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :6          100%           6:6     kernel-selftests.damon.damon_nr_regions.py.fail
>            :6          100%           6:6     kernel-selftests.damon.damos_quota.py.fail
>            :6          100%           6:6     kernel-selftests.damon.damos_quota_goal.py.fail
>            :6          100%           6:6     kernel-selftests.damon.damos_tried_regions.py.fail
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202507220707.9c5d6247-lkp@intel.com
> 
> 
> 
> # timeout set to 300
> # selftests: damon: sysfs.py
> # Traceback (most recent call last):
> #   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 42, in <module>
> #     main()
> #   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 31, in main
> #     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> #                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> #   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 13, in dump_damon_status_dict
> #     rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
> #          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> #   File "/usr/lib/python3.11/subprocess.py", line 389, in call
> #     with Popen(*popenargs, **kwargs) as p:
> #          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> #   File "/usr/lib/python3.11/subprocess.py", line 1024, in __init__
> #     self._execute_child(args, executable, preexec_fn, close_fds,
> #   File "/usr/lib/python3.11/subprocess.py", line 1901, in _execute_child
> #     raise child_exception_type(errno_num, err_msg, err_filename)
> # FileNotFoundError: [Errno 2] No such file or directory: 'drgn'
> not ok 2 selftests: damon: sysfs.py # exit=1

Thank you for this report!  I just posted a fix:
https://lore.kernel.org/20250722060330.56068-1-sj@kernel.org


Thanks,
SJ

[...]

