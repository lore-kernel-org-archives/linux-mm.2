Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38198CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D8D8E008F; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DFF8E0002; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDEB8E008F; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6431D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40B9811AF1C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:43 +0000 (UTC)
X-FDA: 83978277726.20.CB684CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BE7420007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C+CqYBXr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007521; a=rsa-sha256;
	cv=none;
	b=pIpbWBJpNRauac0PutFrBLjRVGX6kvGBqNQgIMH3uttqCIp3JdNP8aj24P2wbiL1tqKc2J
	6tCvFRSnFAC2x/oesjW/69NYbOq7/zGz3ZvnNxAza03z+KDfac1VULGWKmC0XOySzqVkvc
	r+7LuFf1AR1ZBD6xWtn3BeS7w5d/yEs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C+CqYBXr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpaW3mfuR1t7mYJOaH/otlw4EEzxifZbzSB8jzgbAmA=;
	b=lS6l08BQUTkJ/rjVaWviqV4QdKC3hLWtQxnan66UV7OIPreofYZ+Gk+cFt7hNrBQIrJtQJ
	Z2G6B02H3meSwG3d4jc9pDpieQWaPHN+6rvoVpPD8KBAGDX/VtD5boG0pYUi5oomTxbe1c
	/JvdZdQ2L81q/ooZK5rKPpOALArgfU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2375845240;
	Thu,  9 Oct 2025 10:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566A8C4CEE7;
	Thu,  9 Oct 2025 10:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760007519;
	bh=7Nur+XSIKNjaZ4TARG/0OtkaTqABK5qON+LE3aEY7Aw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C+CqYBXrsPK4Hf77dWS8x2tr3n47VJ1gWIZgOIq2eKyhyo1+cmTV2J60K5aYhgHDw
	 3CEeKuIGW8qjA4K3QhBrWjuQoCMP5w8o3T0QjK+eWq+UGDWtZHgRCIHoxuEGrNX+Bj
	 pIlpM8NA+mb7eJTo8mf/Bdjf0HLnSrm9//Wt0xWRbT6Le7m6gzZdQW3NX53MK/u9sv
	 S10U8ahIcGBuVvRGwnutN4BYzYg3r7AgVyWHlcPpwLme5rmkzmzbHl5bzEpdZQvZ2N
	 XQNhDqGAJ3Mjyg0LPTV3FINr6FIiDNji1zltNhGX/uBPh8CxPtU2d4qxRFTeaHmIkF
	 cN5qN9D2zj3Gw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "yanjun.zhu" <yanjun.zhu@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
In-Reply-To: <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev> (yanjun zhu's
	message of "Wed, 8 Oct 2025 18:07:00 -0700")
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-20-pasha.tatashin@soleen.com>
	<a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
Date: Thu, 09 Oct 2025 12:58:29 +0200
Message-ID: <mafs0qzvcmje2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 4sa1pqcqjfyyso9zrmqnq317rx4u4iji
X-Rspamd-Queue-Id: 7BE7420007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760007521-935357
X-HE-Meta: U2FsdGVkX18JA+yDiGldBI8PhjwdK7SDUgqzjSBdFvn3iO+L3HjbUwzmdlDsFFjtM4IpTqW/UwuanGc5X8T95sHjjI9RpVryXZ55eeWjOg1QssZagdWRPAsXQ1HKbNqNKF07U/ftRXFREsH/tKx29LSr5k3mDE0slMhtpuzrcROAiJiBeXHygzSqJYpH4Tk/I+WvnBtv+5U4uMZEV6q9lPIuMPgoqH7pX7rczUVtVzzEjeBAOal4D3uGV1tvbBPhEnK6yHDIgV6Uv81KxxEctup6AX4BjOoVfqoGFW/Fx6sHz1m6z7z+VNeCyMBOx1bzp2AHQQNskoNUXtsS5e2F3MbBihOifswmizaf4cQN9VaU8r5ji9pNXTteWAcfPFzdrVfO/pESED6mm7j+XoIBRMkRRNC8fSdhLJJfsh3rO9FC8madgKPrt7M0D86sq0rK7ma1QIsSH7x19sIHAC5yza03CzxCKe+emO7buZN6gPria3EHGvGnQaHfDqLbsT/RBmS6aQi05FkdI7E0RCAQkAymWOB6H55yImIEabD1B1WVMdPSn7XMvDc/8wd27aV9K2+yyRezdKN5Ijqxc8P+/16QWz+n64BXFHxWKQML0kXZsMhKb201Zj2L6DsKgUnFYUR4geCORbKHbubXv4yyWKbK6NBPJne0+lNuom3HNtciOFWSh2w8Vj9y7UlSfmNG4iThejG2e9A11+5vBp5CQvHcTWJDdU9WtY+u2nDI6RU/vgPp7KM0grpusFZ8uQnP1k+/BnMV+6bvYyXJ+vtmjehUkfUv82lpIxacfgciiSUj7cvR8dKnUs8ks2YGJvQWVkVvpNCxpiEUCrIUb7YosIZK0p8VCTcw/2LJtP1NL4YiM/Ag3ukiG36UVjym+hi6PxHRIdEtytvDigypcsvmKLpso1GB/B9TyG9jH3roHNxSAfo7FG0yoElKAuv7BMwjPLahiFES8QWEDypqSxQ
 dhudmQ7u
 JBmTxeuGIecVacl5CY4vxynT4naFWqFg4DhLu+gf6SF216FHGtcPT1k4Nxn+bJtmE+yehmP/K14u/Pfo5QLEYYDpSQn4PO6GW8cyA1ewohfcLQmPj7ZCdnQqruBkj0/jorei13a/zY+wSc359nY1mgJXs3Ul/W14Xmdx4zMAaQm+s/0orbbjafd2acjfE/xMSbrRMsWgVPMuRRosmOqYlWzQ5WzSHGt9JhYHsK/jRb3udE1NFMtTY45BkoWHQGDWvkS7MbuXnfFdELigJ767zI01J8DxqrlXFzxMqXU6mxgsW58keJiD3n7+ccqVYy1nlovtEfOKXj0emFm4rrO6kxM9pVjjN0143XCdi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08 2025, yanjun.zhu wrote:

> On 8/6/25 6:44 PM, Pasha Tatashin wrote:
>> Introduce a sysfs interface for the Live Update Orchestrator
>> under /sys/kernel/liveupdate/. This interface provides a way for
>> userspace tools and scripts to monitor the current state of the LUO
>> state machine.
>> The main feature is a read-only file, state, which displays the
>> current LUO state as a string ("normal", "prepared", "frozen",
>> "updated"). The interface uses sysfs_notify to allow userspace
>> listeners (e.g., via poll) to be efficiently notified of state changes.
>> ABI documentation for this new sysfs interface is added in
>> Documentation/ABI/testing/sysfs-kernel-liveupdate.
>> This read-only sysfs interface complements the main ioctl interface
>> provided by /dev/liveupdate, which handles LUO control operations and
>> resource management.
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
>> +#include <linux/kobject.h>
>> +#include <linux/liveupdate.h>
>> +#include <linux/sysfs.h>
>> +#include "luo_internal.h"
>> +
>> +static bool luo_sysfs_initialized;
>> +
>> +#define LUO_DIR_NAME	"liveupdate"
>> +
>> +void luo_sysfs_notify(void)
>> +{
>> +	if (luo_sysfs_initialized)
>> +		sysfs_notify(kernel_kobj, LUO_DIR_NAME, "state");
>> +}
>> +
>> +/* Show the current live update state */
>> +static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>> +			  char *buf)
>> +{
>> +	return sysfs_emit(buf, "%s\n", luo_current_state_str());
>
> Because the window of kernel live update is short, it is difficult to statistics
> how many times the kernel is live updated.
>
> Is it possible to add a variable to statistics the times that the kernel is live
> updated?

The kernel doesn't do the live update on its own. The process is driven
and sequenced by userspace. So if you want to keep statistics, you
should do it from your userspace (luod maybe?). I don't see any need for
this in the kernel.

>
> For example, define a global variable of type atomic_t or u64 in the core
> module:
>
> #include <linux/atomic.h>
>
> static atomic_t klu_counter = ATOMIC_INIT(0);
>
>
> Every time a live update completes successfully, increment the counter:
>
> atomic_inc(&klu_counter);
>
> Then exporting this value through /proc or /sys so that user space can check it:
>
> static ssize_t klu_counter_show(struct kobject *kobj, struct kobj_attribute
> *attr, char *buf)
> {
>     return sprintf(buf, "%d\n", atomic_read(&klu_counter));
> }
>
> Yanjun.Zhu
[...]

-- 
Regards,
Pratyush Yadav

