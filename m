Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3967AC624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 04:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE60C6B008A; Sat,  5 Sep 2026 00:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97356B008C; Sat,  5 Sep 2026 00:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADDC6B0092; Sat,  5 Sep 2026 00:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1DD6B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:08:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 513DB12028A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:08:13 +0000 (UTC)
X-FDA: 85178376066.09.78ABBC4
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf24.hostedemail.com (Postfix) with ESMTP id 289B3180004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:08:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0m9iSVi;
	spf=pass (imf24.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788581291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swmnUz3epL8rr3V5+L0G3wg1OAO3XsfkpT2QJi7c4SQ=;
	b=yGA4HEZl8CIibhDQA1WWWKLQiEAnJuVogbikiaf7+GaRDzPmVMApI2J3Mok7Fba5r0Dc1l
	uT9zFR79UQATOCYg3ce6k7sAP42viT2roGBazvKPrO5LuOt04xC6tjYiSlCli5M5KPZoCx
	QSBfDrXQBZOknZnYRttCLso3w2rgVts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788581291;
	b=VbDNLm1ZAVONFTOVoMiWa4dA8V2SAKaOMOP5KEXD+9wTSV+jXACxC7bhFuCXku5jKpbPwH
	qS+S5OtfPbvkQsTtEgGnuS2qeaSnau40QJZPh9XFEEnN7AgmpvWAb2k1nT4LwLY51dQbdP
	L1C8v882t8OkOVgy/U9mxQSITPuSW8o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0m9iSVi;
	spf=pass (imf24.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ogjcy6AWuIiNMoFElPu+5M0YUvjA1DAHyKooz++N5NU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788581289; v=1; x=1789186089;
 b=h0m9iSViCse/ejJSm8+5HMIXz7cna1EPV225TkyAJuyIJeXjBl/i1XdzNA+khOH3q/PQaElM
 XiAHPsrupi7MmolggXHPIYA9nOvRdo8VsJpXDcXiMCo20SRUog6KGljhmBDmdKfCQP/p6G1kZhM
 sxddT5qZ4EsGtJPFGW9RJL8w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92059d4e748b9bc4;
	Sat, 05 Sep 2026 04:07:59 +0000
X-Mizu-Trace-ID: 92059d4e748b9bc4
X-Migadu-Flow: FLOW_OUT
Message-ID: <ffe712c9-6c24-4452-b703-c8e01828ed18@linux.dev>
Date: Fri, 4 Sep 2026 21:07:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/20] vfio: selftests: Add
 vfio_pci_liveupdate_kexec_test
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org,
 amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
 chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
 dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com,
 jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
 kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com,
 lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com,
 parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com,
 pratyush@kernel.org, rananta@google.com, rientjes@google.com,
 rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
 schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com,
 vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-18-vipinsh@google.com>
 <0556e2fc-3be5-4023-a9a4-8482fa8c88b2@linux.dev>
 <20260805055042.GA806762.vipinsh@google.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260805055042.GA806762.vipinsh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6gn5gxux3zssfm33chd3snkfc5h8tjhz
X-Rspamd-Queue-Id: 289B3180004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788581290-725154
X-HE-Meta: U2FsdGVkX186vuawIg++BLWiyY9uesIrFMIXRt/UIiD0YBOioE44mxu4JpmeL+UpEzhMub8tTxA6+tCPNBroWav95snz9uJcYL1zg/sZSt6SEx0i7N2tiDOAYQlkUPfoUU8kwGVq6aG+V04WYf7E+3ys9ch5dZDWlkQXlr1DGzQwl9i1lRp3mxauJQNmCvF9gSPGx1xYhdDbwFNP1ZwwgQiu9hpiLLSAg+qtxiY+Ji8+rxwYc2UxHc0EFeAgmbypMGAjUexJqtsJV3OEFlaaS/54k8DcBI6v5iorl96JacdMfGyBtBzKyg3pfAIB9Bv0VGqwm/dAaretGuTaeRjMFQqBHyGSSjlC8QOz2NADTtpUbxL5eQVCkmOR6f4szK9SmOARuJMGAvIHuby+JIR/H+fsr52c9Rx1gJMYCBw0/0QGTDUbEtUiROf5GmRV2SZF2NDA+rEJKDCoMzHs+Mw1S1SQ44ckPlntAJYScwBf2lmnos/JejA09MZHBxrHDJAigNLb2f6vrDFWJ6g0UVuTn74o0psrLPNGsbpi3UXkIEH3Bygk1lK7Ls3YTKOipPwrY0723fJO/SDOlGFJJBr+KxD1L4lvF8jK7IwNSxeZ3CDl12BvH41vlqeMYkw9Iy5Am6oE9BVkuJYC27LqSbKynpUZX+RKXkiNZxfWY8BLUMDGS6Ei9ci/TvKBLuL7ng/5ycW5UfEW8lf0UrU2zBV0lNU3ttBsQS8nwTsFy2Sr/WPZN3UkcYHiI17qaM+OE6S842np8q0deJhQqyBWdktJoslM5aGk8xK3rc4SvQrGVCsjvjiVMnTKf6OzXfdwPpF+daeuhLGBLcnvUnHjDqGTMgUprJZ0UuBwfvBI15MM5CdKvCnKzNEHhN8AVMUXi9tHVF5Wm1Bz54j2KAosJujusXku3/iEnweUc0Eo1rirN9zlpOLwqFgEwBTn8UHMoBYIJD9I74s4JczoB7wkgU6
 ICMRjAMa
 5rvzodNpVfqjSqfSTx1rFYSngJNaPbqi4wl4wb2wiwJOjyFlZ7Z77DWsRKHiOUCS3snswTbPm4ttd/tI3gowWBeob+vKaVZF0iqzKYkEutV7RKI0W4cU9K81KSGGolwjKrCCJzRUi0/izyhm0+A23csQ/PIpHVGaLgF/HMWxlVV6IrFbSchyq7NmhFwKZt7JqMwQlArO0zH363s18uESiYi3c5BEzT3hyL2sygiyfPZg1PYZjdQhaCUJlfBTc/RwiItdGFpTUZIYVKuKur8t1Tem5Nmio4SrM4/HampaYzcAl9qQO4ZeWcHQPL8hyeqx9GenDjFcuw6CtsXoePs4skWE4bto2uatndRao/gP7ra4BNpBgy5BjL7Q393yFZFLLiXAty3DpULTptk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/4 23:02, Vipin Sharma 写道:
> On Tue, Aug 04, 2026 at 03:19:34PM -0700, Yanjun.Zhu wrote:
>> On 7/14/26 8:15 AM, Vipin Sharma wrote:
>>> Add a selftest to exercise preserving a vfio-pci device across a Live
>>> Update. For now the test is extremely simple and just verifies that the
>>> device file can be preserved and retrieved. In the future this test will
>>> be extended to verify more parts about device preservation as they are
>>> implemented.
>>>
>>> This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
>>> manually along with a kexec.
>>>
>>> To run this test manually:
>>>
>>>    $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
>>>    $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
>>>
>>>    $ kexec ...   # NOTE: Exact method will be distro-dependent
>>>
>>>    $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
>>>    $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0
>> Hi, Vipin
>>
>> Thanks a lot for your help. I followed your suggestion, vfio-pci setup can
>> work.
> I am glad your setup using virsh is working.
>
>> The followings are the test result. In the step 3, after kexec, there are
>> some fails. I am not sure if these are known problem or not.
>>
>> 1. Before kexec command
>>
>> + modprobe -v vfio-pci
>> + tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
>> + echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
>> + echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
>> + tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1
>> 0000:00:04.0
>> Preserving device in session
>> Preserving memfd of size 0x40100000 in session
>> # [STAGE 1] Forking persistent child to hold sessions...
>> # [STAGE 1] Child PID: 1236. Resources are pinned.
>> # [STAGE 1] You may now perform kexec reboot.
>> + set +x
>>
>> 2. Run kexec command
>>
>> 3. After kexec command
>>
>> + echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
>> + echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
>> Checking open(/dev/vfio/devices/vfio0) fails  <--- I can confirm that the
>> /dev/vfio/devices/vfio0 exists. But open this failed.
> This is correct output. Test is verifying that open should fail. If it
> didn't fail the ntest would have exited with an error. A preserved VFIO
> FD can only be retrived using Live Update session ioctls and not through
> usual VFIO dev path.
>
>> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
>> (vfio_type1_iommu)      <--- fails
>> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
>> (vfio_type1v2_iommu).  <--- fails
>> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
>> (iommufd_compat_type1)  <--- fails
>> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
>> (iommufd_compat_type1v2). <--- fails
> These are all correct output. Test is verifying that userspace should
> not be able to get VFIO device FD only through Live Update session
> ioctls and nothing else.
>
>> Retrieving memfd from LUO
>> Finishing the session before retrieving the device (should fail)
>> Retrieving the device FD from LUO
>> Finishing the session before binding to iommufd (should fail)
>> Binding the device to an iommufd and setting it up
>> Finishing the session
>>
> This is shows VFIO FD is successfully retrived by Live Update ioctl.
>
> So, you saw expected output from successful test run. I will change
> the message getting printed to avoid confusion. I think current way of
> printing ".... fails" is confusing.

Thanks a lot. I have made tests in KVM. I can get the same test results.

Reviewed-and-tested-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>
> Thanks
> Vipin

-- 
Best Regards,
Yanjun.Zhu


