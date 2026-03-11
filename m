Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD82FD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F8A6B0088; Tue, 10 Mar 2026 22:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EB56B0089; Tue, 10 Mar 2026 22:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10116B008A; Tue, 10 Mar 2026 22:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFF46B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:21:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 205C2C1C30
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:21:16 +0000 (UTC)
X-FDA: 84532180152.23.9D9A809
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf20.hostedemail.com (Postfix) with ESMTP id F22AD1C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:21:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VaDLSTo9;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773195674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCPwodAJ50NcwUGxjO5nSSMRczLJa4bA27Dqr3fPsmo=;
	b=mN84L8Jy8ZFZtTrI1cf8PqT4YXkHs5RjiitD7Gjnm4MWXE6BEFF8KUbV7ym8hJjIqE7D81
	/ng1y66driJTk3sLvI29Tb/0cPwd+h5VIppEz8BBazXySlUfNl7GJ+/V0D+E6amqDwYSUt
	4QVvsoZ48o36128+sTPfcV94tPW1E+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773195674; a=rsa-sha256;
	cv=none;
	b=j35aIvl01YvAuZHECYmPIpQO+/yoWcvV9P3GynZEDfaXRKKRpi+sxehN+7zr9B5Da3wTRZ
	ptuMPXeWKUaRrNDwfw6TKvwwu4j/KIBoXDfyBCtMt4SbsZvcVfuoPgqqiYZhrIvLYKTjii
	kpNmsAdmZe8Aa1+9B8jC1HwRpADRhjc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VaDLSTo9;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZCPwodAJ50NcwUGxjO5nSSMRczLJa4bA27Dqr3fPsmo=;
	b=VaDLSTo9Y77YlIdlNU4uAQGJ4ccq+8+6s5Ez6s4KRr+5JQhnmLFG8DS6DsOmRS3uhAdi3SV4y
	wa0QgKD1i3LevuTYZMk6ysWDLpxeLvS2HUxrC8cQJdqt6SNCRN+Xh65bBzXblCiSq66gBGPzHzQ
	OoMQQjXUNv70m3k82BT/5zI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fVvVj3V7ZzpTLn;
	Wed, 11 Mar 2026 10:15:57 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 87F0D4056A;
	Wed, 11 Mar 2026 10:21:08 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 10:21:08 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 10:21:07 +0800
Subject: Re: [PATCH 12/13] selftests/mm: move hwpoison setup into run_test()
 and silence modprobe output for memory-failure category
To: Zi Yan <ziy@nvidia.com>, Sayali Patil <sayalip@linux.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>,
	David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
	"Oscar Salvador" <osalvador@suse.de>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>, Muhammad Usama
 Anjum <usama.anjum@collabora.com>, <Liam.Howlett@oracle.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <832afc6c34a784ca433b506622cdc98fe9540f79.1773134177.git.sayalip@linux.ibm.com>
 <556E284E-9638-4F4E-8CE4-7158DB914AED@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ae5108d1-4bf1-7b48-b299-ea3f12ee50e1@huawei.com>
Date: Wed, 11 Mar 2026 10:21:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <556E284E-9638-4F4E-8CE4-7158DB914AED@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: dacztibdocm7kj1mzq7fnzyaeb9ko7qb
X-Rspam-User: 
X-Rspamd-Queue-Id: F22AD1C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773195672-970082
X-HE-Meta: U2FsdGVkX1/xiKDyfRdfrk0xmeV6kCuQV4ocR24BFPn2Vip8Vtiqv69sRF8oLRAyLflvUgDobqzvB9ENl2SVBnPQhcgx4/p4dy41q/0CBGeHX6I5cEJ3UO7Q4v9EJhhSnQs+wY8affaXRf+cm1J+/84ZauB1z3c+eFbJAS+Gsg3m1yK69lvQaqTr/TVSENfRkZJT/EdG4DWQ/r3XY5Zzm/f45JO1eBJ4s0zTT1XsCJRohirHjxRf3/oV4U1bZpwzKOHD9ZjkgXlYSE+Gp1hkfWbVuzSN8ZQcixiZ5MWATTX4RcQP/Ga7ZQrv6k6Dhm07OH4eVk3VHLAf5IjyQmqR085/Zmm+uL7ZCbrImXQgpLanTH+IXfqcWGKTheiElMXWNB6WWUXPn1nShnqPX9yuCFyZMGjvZkIA/Sumsw+I9fe2kNM96krOXJslRSdJB42eFvB+f673E94P5Y4sAqnzxJL7V4wsbA9YuBG/lPcXW9t/MS6S0vROOtG3Ew1jIhIqHfmwSysGN99kp83tvQ+2rtBqAiMSQxCw+Ck23efItvnJDPjpcZ5V/lcIO3vF1FtkXTKElWUpAEarLrOUGM4uv37kUQA5QV3r8UxyDNwGlQ3oaRxS9S9QJ9SD4iysWMwj1CaAL/wV96TNH41IgwBDQQa0BYeJhSwbhA/c9GqI+fp0HFw1ZCOBUUXFqyxlIE1SBzIZci4bLy950qVJNsFj5Qy0cDX0bk1olxr/QOCfyFsU7yxr2x1Ieikp9sNHxiAgINCOFaOhHQ/qLrIQs/HuRmcyMQAGe/6wbtAlZwa3+ag1h0TPRQ/FDjkW7CCjYlSvfmclNLQq6hmmaHfz4iZEkMODy6awOvVUZ99HaeB4UYSX1Rn0/h0HrZpDqXZyvzBt4C9rIN6ZsBbHt1smdYDQkd0sVHiYmBhK1rQR82u6LNnvALjLxeIOfxo++5/kPV+OoqRykR8V8dLrsYQgL48
 k03kZqKs
 JcxHLbrdwspauuruEKyHF9/swx00+yLaccSnUOnHTjO1CNmwicQdCvrDVborL4tqzDPg7JlLCbGif1Whx6zEaR09V7DK7Y5Eh/+oH/XKSMJP2LEsPmV9UJ1ENt6amnFa6XRWa86L+o7QzHM4uBFcwbNDFhyhLBxxzm7VLWIeIFyPkx+G6cLxQzhu59+6UG6RaCYbgyOtO+HFRKBeCg2q9uM5FiHhz77EkjlrgGX9T4s4A7e7e8U5u49iWL3zQyDU9MLZb2y198GIwFJAoyNT0AuOivbz9+lIoveUyie7GWL4SwFfW/hszjKcgXxxWbz4KDueE648q6sa6WvfQs9EkiJo1jf10lL6W7CPUVIlg4qVQUaO5+/irpBY1nl53DtGk5j5IY7bMR/JcZNIrqPvhH4NJ3MsLp+UCFKzsWUCcYQ+olZ0MIVQ9f7+Genwzrgelf3FqAonxTUaMMChNRLzz61Qf7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/11 3:15, Zi Yan wrote:
> On 10 Mar 2026, at 5:49, Sayali Patil wrote:
> 
>> run_vmtests.sh contains special handling to ensure the hwpoison_inject
>> module is available for the memory-failure tests. This logic was
>> implemented outside of run_test(), making the setup category-specific
>> but managed globally.
>>
>> Move the hwpoison_inject handling into run_test() and restrict it
>> to the memory-failure category so that:
>> 1. the module is checked and loaded only when memory-failure tests run,
>> 2. the test is skipped if the module or the debugfs interface
>> (/sys/kernel/debug/hwpoison/) is not available.
>> 3. the module is unloaded after the test if it was loaded by the script.
>>
>> This localizes category-specific setup and makes the test flow
>> consistent with other per-category preparations.
>>
>> While updating this logic, fix the module availability check.
>> The script previously used:
>>
>> 	modprobe -R hwpoison_inject
>>
>> The -R option prints the resolved module name to stdout, causing every
>> run to print:
>>
>> 	hwpoison_inject
>>
>> in the test output, even when no action is required, introducing
>> unnecessary noise.
>>
>> Replace this with:
>>
>> 	modprobe -n hwpoison_inject
>>
>> which verifies that the module is loadable without producing output,
>> keeping the selftest logs clean and consistent.
>>
>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>> ---
>>  tools/testing/selftests/mm/run_vmtests.sh | 46 ++++++++++++++---------
>>  1 file changed, 28 insertions(+), 18 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index 7273c3e18227..7f3a3027cd9a 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -250,6 +250,27 @@ run_test() {
>>  			fi
>>  		fi
>>
>> +		# Ensure hwpoison_inject is available for memory-failure tests
>> +		if [ "${CATEGORY}" = "memory-failure" ]; then
>> +			# Try to load hwpoison_inject if not present.
>> +			HWPOISON_DIR=/sys/kernel/debug/hwpoison/
>> +			if [ ! -d "$HWPOISON_DIR" ]; then
>> +				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
>> +					echo "Module hwpoison_inject not found, skipping..." \
>> +						| tap_prefix
>> +					skip=1
>> +				else
>> +					modprobe hwpoison_inject > /dev/null 2>&1
>> +					LOADED_MOD=1
>> +				fi
>> +			fi
>> +
>> +			if [ ! -d "$HWPOISON_DIR" ]; then
>> +				echo "hwpoison debugfs interface not present" | tap_prefix
>> +				skip=1
>> +			fi
>> +		fi
>> +
>>  		local test=$(pretty_name "$*")
>>  		local title="running $*"
>>  		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
>> @@ -261,6 +282,12 @@ run_test() {
>>  		else
>>  			local ret=$ksft_skip
>>  		fi
>> +
>> +		# Unload hwpoison_inject if we loaded it
>> +		if [ -n "${LOADED_MOD}" ]; then
>> +			modprobe -r hwpoison_inject > /dev/null 2>&1
>> +		fi
>> +
>>  		count_total=$(( count_total + 1 ))
>>  		if [ $ret -eq 0 ]; then
>>  			count_pass=$(( count_pass + 1 ))
>> @@ -540,24 +567,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
>>
>>  CATEGORY="rmap" run_test ./rmap
>>
>> -# Try to load hwpoison_inject if not present.
>> -HWPOISON_DIR=/sys/kernel/debug/hwpoison/
>> -if [ ! -d "$HWPOISON_DIR" ]; then
>> -	if ! modprobe -q -R hwpoison_inject; then
>> -		echo "Module hwpoison_inject not found, skipping..."
>> -	else
>> -		modprobe hwpoison_inject > /dev/null 2>&1
>> -		LOADED_MOD=1
>> -	fi
>> -fi
>> -
>> -if [ -d "$HWPOISON_DIR" ]; then
>> -	CATEGORY="memory-failure" run_test ./memory-failure
>> -fi
>> -
>> -if [ -n "${LOADED_MOD}" ]; then
>> -	modprobe -r hwpoison_inject > /dev/null 2>&1
>> -fi
>> +CATEGORY="memory-failure" run_test ./memory-failure
>>
>>  if [ "${HAVE_HUGEPAGES}" = 1 ]; then
>>  	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
>> -- 
>> 2.52.0
> 
> +Miaohe
> 
> LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>

LGTM. Thanks both.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

