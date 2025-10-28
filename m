Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70980CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C9A8017C; Tue, 28 Oct 2025 12:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04288013F; Tue, 28 Oct 2025 12:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19F78017C; Tue, 28 Oct 2025 12:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B02E58013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:31:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A94412ABAE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:31:50 +0000 (UTC)
X-FDA: 84048064380.04.C8E0EF3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97244180014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:31:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsFMAVyw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761669108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWSSRHmArf/3utDL/ehBcqRMhr+v6BRpRpOeVW9o8r8=;
	b=salBMRhhFsSrNmqDvjAX1tWMfZPNyilMLueiXCM66J8dWZUXXQ0x46VPPj78QvTxnahBEF
	JIszjzKpgkaUb4dWlOstom1xz7d8nkjpXkAoxGFNiShiNg+QVsvXWfZ2koMCU6qfo6lyBt
	pYuNK1czWUwkiVBMg8uTpn3w9J7F890=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761669108; a=rsa-sha256;
	cv=none;
	b=NvtfEoBBpfkf5CKYom6V1LxYLbmQi4jHYZ73NuBUnKUDhdun8BY3pTJmsV6ETNONqDxBW/
	U0dpc1KnPHXeqRYIVqsS2r/3Dy2mDWeN5rpoOtCF/RgSJTDQsnhAjOiopPKJVRWrkw7rbf
	WceLDg5xdnpN9491+8uBbCb+AFKhODg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsFMAVyw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761669105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWSSRHmArf/3utDL/ehBcqRMhr+v6BRpRpOeVW9o8r8=;
	b=UsFMAVywaT8IpkoioAmt6vXomW1hLiGke5lnfdOFm6CT75B6FrTgPwndxR0Ld4UWB+GB6Z
	kNutJOjE/CXohXqu1fHCO5Wo3THXTOtts+MdPLoZN5i9dq8L67okdhsPKyc4EOyrIZ69wY
	ts6Gbva7I2Aaj5nD5s2hWpcBahe3SXQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 17/23] bpf: selftests: introduce read_cgroup_file()
 helper
In-Reply-To: <58dd6b759499f212f626e6d7658dd558b3e6a334e0780898002cb2cb84dbcb85@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:48:24 +0000 (UTC)")
References: <20251027232206.473085-7-roman.gushchin@linux.dev>
	<58dd6b759499f212f626e6d7658dd558b3e6a334e0780898002cb2cb84dbcb85@mail.kernel.org>
Date: Tue, 28 Oct 2025 09:31:38 -0700
Message-ID: <87ms5b3s45.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 97244180014
X-Rspamd-Server: rspam02
X-Stat-Signature: df94j5stcfswzamrjczgix9c6fbi8j5x
X-HE-Tag: 1761669108-95227
X-HE-Meta: U2FsdGVkX1+aGK9m0Cpj9phv5qZVSHrT3h6MkY9bHPOjv1izrpmHioeg3I2YBSPyk2FHYni/e+Pf+CdylDcfVOo3hq72PNf1a1+yslxQymAudV/2692WUvTsRNTdOJAeMEhN/5gSfK7XuPjzMxDBKM/d/iKukZWXb4u8YdZInOuUHW9IMjO0TGOm7O/JtPtyuZM/KsE373iTB1b+bW4+23okeFp8V8xKal9xNLylhovzkmmdSXcLSHkTR2bTk72cZhk4kGbt0j71D4u+hNn1YSN+1hjTtTPHLsyS1jdYC8GzNOPXchIO2IQ3pmFTwjhx3XbgY+zlQn7gQiQyNNiad02hxIfvUwltzaSS/SlVhSuvDCwjCPwSW0x/uV+9RTHEM4HThp2RGE7knqR/94AZtJqz7/vt6Ih5UQsQnmuk+LXevH3FO9LT0AgAD6O0WBmH5y7SYYJ99WYrTwBvfiSNrSpDRg24h68TlQmbQBOBSZgfWcrZB6Xk4xOSdvgR0SnESNIBiVDgT0d1GP5MDJc7WfX5Y2J5bOJTZAwaJGqwl5FiIhQ3g5Cxf1YTfxSHCLRZQYDmKSVLIcJ4OQI3ClTRxmjzw6NGjn4rrOIMX15Y6IO00L17wX1pSKhmsK4F/LY0UPEXrepjMz9VuzkGnCMrn8hZsOdev1NQyQABLWbtnWm+1Gi4WgmDWV+CC/nYo0hn/HLevbPOb9fWSoMy1xpvhMzvuTDfrQxLQm4jLFcc76wruqRcfqCVk6gB6S98qGIx10luFy/Z+XYHWsWynQIFMv+jhXinzDYmEiJQHBcErMu6asf5e3LEnU7SAggiRkmFJlWSYkx0MTJB3lNwWf285J0iNSvpZAR7JbiGTZO17YoqCSepu/G64Jh1WOVJuCShkVvqvcjhdqfmvRA7qXIbsSBTqqAQgDFvS4O6L5Z9yBRupiJ8xK+wnHCi3Yp1D+m2CNa+GWR859oCFDX3zoV
 RWCuhSep
 8nip9NAGCE7gUDjkrWKaDpMymZVIstEMDe14ClVz2TMUguflPdPPJSC7g+7JDvOGxyO0OucD8vdF1Q7stmS8pLzCllAfDy0Y0yhym5W9+35oKPKauG27LglmuIIGWAO+JLDLiC45ldB48GuzLug1L8drvewYT2vLVNa1iskT0NPuuig/hvnYvsipEDNkcm1Vow/CReaYLPBEkKNJeaXnIzkd5VTk+EdOFIR82CNRyYi29RN92O0ZWgG/zCj7y+D65QWhwzNZ/dDvwFfkprqsShYiHvLI04nOrBo0lezs/GVUY5IS4PekUBE3aIvg1yOtPMJhADq342DgI0zsorEFzcOsDkZJ+IGZ/mnhE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit 712137918bba1b0a9c7c670bab9200b0f0d6a7e8
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> bpf: selftests: introduce read_cgroup_file() helper
>
> This patch adds a new helper function read_cgroup_file() to read from
> cgroup control files in BPF selftests. The function opens a file,
> reads into a buffer, and returns the result.
>
>> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
>> index 20cede4db..8fb02fe4c 100644
>> --- a/tools/testing/selftests/bpf/cgroup_helpers.c
>> +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
>> @@ -126,6 +126,45 @@ int enable_controllers(const char *relative_path, const char *controllers)
>>  	return __enable_controllers(cgroup_path, controllers);
>>  }
>>
>> +static size_t __read_cgroup_file(const char *cgroup_path, const char *file,
>> +				 char *buf, size_t size)
>> +{
>> +	char file_path[PATH_MAX + 1];
>> +	size_t ret;
>> +	int fd;
>> +
>> +	snprintf(file_path, sizeof(file_path), "%s/%s", cgroup_path, file);
>> +	fd = open(file_path, O_RDONLY);
>> +	if (fd < 0) {
>> +		log_err("Opening %s", file_path);
>> +		return -1;
>
> Can __read_cgroup_file() return -1 when its return type is size_t?
>
> The function signature declares size_t (unsigned), but returns -1 here.
> When -1 is implicitly converted to size_t, it becomes SIZE_MAX
> (18446744073709551615 on 64-bit systems). Callers checking for errors
> with "if (ret < 0)" will fail because size_t is unsigned, and callers
> checking "if (ret == -1)" will also fail after the cast.
>
>> +	}
>> +
>> +	ret = read(fd, buf, size);
>> +	close(fd);
>> +	return ret;
>
> Does this handle read() errors correctly?
>
> The read() syscall returns ssize_t which can be negative on error.
> Assigning this to size_t (line 143) converts negative error codes into
> large positive numbers. For example, read() returning -1 becomes SIZE_MAX
> when stored in ret.
>
> Should the return type be ssize_t instead of size_t to properly propagate
> both success (byte count) and error (negative values) to callers?

Correct, fixed to ssize_t. Thanks!

