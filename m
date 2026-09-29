Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42748C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146166B008C; Tue, 29 Sep 2026 02:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F76C6B0092; Tue, 29 Sep 2026 02:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F277A6B0093; Tue, 29 Sep 2026 02:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE44C6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:17:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F9A3C03CD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:16:59 +0000 (UTC)
X-FDA: 85265791758.14.A7E3DC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C717E100003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:16:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8Hr5TCN;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790662617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERYLMmZBpR44MoQ0i7otcWJsFHBUEQChy50DUJ/ynPE=;
	b=7R9ZxPVlgOuEZ/PKXXUdYCYCyzfhxeRO2mkeVv80VvHSf6KdSipH9IzWMBntDFWfcYcyp5
	bPd33Kfa67TSXtcCYMA4Le0zuFWdMoZPM6qlR+jbdkhaU3Hni0ej3yT5j/d5se3AVx/G5c
	bbEB64k6zrjVrpY31tBt0U82ETIU49o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790662617;
	b=YoYntzf2By0GgCN1sJ1c26frZZWYmtPOsfWQkUIiYvPLm9wsEU3FG1HN66RlvqFEmok36j
	LyaFBxkoq6K6QGiQAtg4dWMlgFkBduMWZ64vca+tP5xVmvQhm9N8CJYFRkrXkhyt7WW1HT
	nhIRjmhQYJ///B9n/TgqM1/bRwWy5tQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8Hr5TCN;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A81460210;
	Tue, 29 Sep 2026 06:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423C31F000FF;
	Tue, 29 Sep 2026 06:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790662617;
	bh=ERYLMmZBpR44MoQ0i7otcWJsFHBUEQChy50DUJ/ynPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U8Hr5TCN9auVfN5baqm6iLIPwanGcfC/vIFhnarvyr7jV0WrmuKgAe4HzWz3LFksT
	 II9+YfS5+7DzSI4ovfV2Xv+wY8DojMEkpZDLH5ypYoICdpQ17A/EwbX8DO0nmN4RtL
	 TzgOAtljeMn8m1uBWYHz1Oqmx03Yi51/SyqKmtxYdf+e+msZdOKbpDU6D5kKXMPRMt
	 ENgDas9ZlOnILSG0A7elPUF785zFDwF4AagCmfulT96S5jZAg6zS8tZDgpCEDfGq5z
	 fQzEMWD3+1TzZU/7bKoUi2BToz/tW3OxnK7rY63tlzX9EPR7mJjLF53CuVPNOxsPv1
	 dm54uC+uyIoCA==
Message-ID: <c52362f5-60b6-4bf8-8b32-73269a0db93a@kernel.org>
Date: Tue, 29 Sep 2026 08:16:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
To: =?UTF-8?B?SEFHSU8gS0FaVUhJVE8o6JCp5bC+IOS4gOS7gSk=?=
 <kazuhito.hagio@nec.com>, Dave Young <ruirui.yang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, David Carlier <devnexen@gmail.com>,
 Tao Liu <ltao@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "kexec@lists.infradead.org" <kexec@lists.infradead.org>
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
 <9c47dad9-2716-4ae0-b6e2-9e6b5c718859@linux.dev>
 <4a57b255-cb38-4e8e-908b-d32e55a1a326@kernel.org>
 <a13c01e1-def0-4aa5-b54f-18e523082b29@linux.dev>
 <9d1f8623-c14f-4e51-8aee-6971a4cfbd31@nec.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d1f8623-c14f-4e51-8aee-6971a4cfbd31@nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C717E100003
X-Stat-Signature: q31131z7hkkaipipk3g7wsdjr97g9t75
X-HE-Tag: 1790662617-43983
X-HE-Meta: U2FsdGVkX1/KdUmZQh2qyBVyMMr8jnhBpV/sTMKHqxmRcRjFjwMSoz267tSucz9nzd5m+75iEJozPsxDPoD3Vs1s/XXfFokmjkhsaeRM+ScUSUTbNp/4Cwei63zZaYg3Z7DEqGBs2Ncox2rQdC1isBconJuAdiZ6zM50K3QMWnWGYO7/WTFHu9Xhn9XJMyMmV+W7JHlDQq39PdYOFWkAyU+gmtJDF/iNTNmqPyVEYmuabbHatYLwsvyddoE8eY8CNy4j4DwyApufh21CZ88w9W7t0shlKwvWvxhblUPxVwWFn6CZ7yMbpqGA3/rBzsHZ1Syc3+Bn+YRDibuTy5nHsG/KkfswU01q7RnzgmgjKAYGL0Iklaum1BZUh88pALyFYrGQOnRlnFogvAhETpioAmYSOZpe1+qHzSgKeOsJd9HvcZxLa29tjimgmAjhbd2A3pzxX74QKRvBriFowjaIrwZjGDt3cTQOWH4fZyaBI31zx5Kh5EL90Lt0cSIYaj4JNYLBTjqFsFf37X5QImw6WRXdUpcs+yPg74OVlsMtkkOkNV4og2SyvJLRZjqg/aCO+tr9sIa5TPpUwX2cCTjTg4pg6sCgLHwwyBjxKnquNDTSGTNh3+sCi6CXsaOm2SKaQmhIQvRb0TvnkrkIG2xsHx3xg5MkudaV/uolk2G1YIbejif6vgNJBRPmp2fni83SZcWzUoHtjI1d0QBd5VH8LKFAcRjEdvhRwvd43qb1vnEiLgrbQhdYK7UTskXJMyYV+2/GDYkA/B5NKt9rR90pjC517ef+Z/LvzOepRZn/Wn4dJxQbn2sTqEa4Gfbtc3heSXyK/V2+64lN4UzsBWqFvVSIr+Y6u8GMjjWC3/5tMtqcjW4V6c10GwiupfJoG5Iac2W96ImmBT5TAPmYBaPfMENIFfr+s1lF4sDpKPUXYAqsb0JjhFbeby7Sm39bYcpoRTnYG07aykWi85iQkl9
 Q0bZYLyl
 QQAGynKcphLFmbOlf5Gghn8Mxlt7F9eiCTofI9qZ/gFSAs8pndE7TmN8ZmtFVymWtV6pbACPwDIOBRVbmlv07ESsCsj9SEvHH37RFtoNCAmfrfpHO4pZB7jxV4269NxhC9CHOPQnDlh3O4cAbm7jm1zXnQ//TJwnjHr/18auFau7cSYVabcKWw1MnCnqSpBxyt8kMk3WzlXyvKQtcDvf6iQUnnZu/GOb14EaJ7+n3Nagxmb13z5RGm+yjaSkzuc2mnJ/LWi+IxNhlGl6oTS955UcJNBTnybngQQxwF3cXTDqhQaBrM+iuHnEoLRmCk3dxS1DAdET/t26sfpTk8/c/8Cne+tLMpFfc5St8hDTavN5HgzzSc9IbjOc+8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 04:02, HAGIO KAZUHITO(萩尾 一仁) wrote:
> 
> 
> On 2026/09/29 9:25, Dave Young wrote:
>> On 9/28/26 7:42 PM, David Hildenbrand (Arm) wrote:
>>>
>>> You know the crash code best, so likely ... it's time one of the crash people
>>> takes over this patch?
>>
>> Rethinking about it I'm hesitating to add many more to vmcoreinfo although it is reasonable,  about the #ifdef things, there are other places other than mm, crash can not depend on the /proc/config.gz which is not reliable in the old kernel memory, maybe it will be helpful to export another elf note for old kernel's kconfig.  So I'd like to support to use your patch for the time being as the first bit is always needed and leave the remaining concerns a follow up item.
> 
> I agree, from makedumpfile's view point.
> 
> (to be exact, makedumpfile needs this but maybe crash can read enum values from vmlinux.)

That's a good point, maybe that indeed works for crash.

-- 
Cheers,

David

