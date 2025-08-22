Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D803ACA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 12:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069E78E00A5; Fri, 22 Aug 2025 08:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040D18E009D; Fri, 22 Aug 2025 08:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF148E00A5; Fri, 22 Aug 2025 08:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DABCC8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:05:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AF9EC0162
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:05:51 +0000 (UTC)
X-FDA: 83804264502.23.623B12D
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41E76A000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:05:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=I77P1uKU;
	spf=pass (imf15.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755864349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sjXBtj1MOzw/AdZxeUjWL1KE7gNgPG1VCq31ysNWqM=;
	b=B+qRNLPxdedvvdeVOeAJosqc/E9MnbMGf/Y1B4NAJNPk0ZhQd2CAXZG+Rulw+qoPH/Y3vF
	31Ct0XmU3INDJ1xF84yRcTouFt1gBEjQkEycM8TL8aR91+VLB9MJOuUmX+HXvadEw12Pu4
	ZlKoV3ebcxm7mjEkf/IUub14GEns6tc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=I77P1uKU;
	spf=pass (imf15.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755864349; a=rsa-sha256;
	cv=none;
	b=jB7OgP1uL6LESaHTH9XNwbyGLPZ3OBzYw+w1FHsbDU8GYN93hyWJizL+rSvMDi4ESXIFMk
	X1dTXNwTCsiklzbpzVF8wE0j+EHFatAqe8ogSinITjatJWjDAcAkI4g/upnibKm7EDYQnM
	h4eI7g9O6bKYamVRd5FrZ+42JFm+nUg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/sjXBtj1MOzw/AdZxeUjWL1KE7gNgPG1VCq31ysNWqM=; b=I77P1uKUeWLsabWoudzQTPby7H
	3I7AFVwd4agPdtzptBCL4RkqscYDOJdDiy1tSDcKZxzWplHulsHNgu6RFrKaMpCKzqZX6KUQ+YEoV
	d6VMpuehLAsJ3UWSzv79R2uqym63+DVN+2zgOYqp4PRJFRkjYGwDk7651LHm8rNlQCMD3b2VRZz3Q
	PrLzmNWi0iJVguvflNR5j+mGWUbQn1Mqrx37UuuYMq3DBTiiCgCbTsWX6Wn3qmhx3+8WFWwGC9R5F
	2xdnEe6nAQAdMO6OUiyMs5flaPyxsFMMTizHEGM/Xb8asUBQVtqNggtLasYWq6hUDaNAhOZzoR0Co
	/bNNZ1Mg==;
Received: from [223.233.71.242] (helo=[192.168.1.8])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1upQWL-0005V1-MJ; Fri, 22 Aug 2025 14:05:25 +0200
Message-ID: <3dd2e56c-667c-63cd-2103-44265b34c45c@igalia.com>
Date: Fri, 22 Aug 2025 17:35:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v8 4/5] treewide: Switch memcpy() users of 'task->comm' to
 a more safer implementation
To: Steven Rostedt <rostedt@goodmis.org>, Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, mathieu.desnoyers@efficios.com,
 arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl, peterz@infradead.org,
 willy@infradead.org, david@redhat.com, viro@zeniv.linux.org.uk,
 keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
 jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
 kees@kernel.org, torvalds@linux-foundation.org
References: <20250821102152.323367-1-bhupesh@igalia.com>
 <20250821102152.323367-5-bhupesh@igalia.com>
 <20250821124319.07843e17@gandalf.local.home>
Content-Language: en-US
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <20250821124319.07843e17@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41E76A000E
X-Stat-Signature: qto1fro7hu8fq6c845wifcy8wk9ao1ro
X-Rspam-User: 
X-HE-Tag: 1755864348-461281
X-HE-Meta: U2FsdGVkX1/3fkrg2sacivxEnKP1YLMa4uVF0bA68MoOHhmwBtp4XXrVQFxBCg6i+CgpZUaDTBbI7CBMXKlAVSTG5QebqcHOhFhfvfUaUdE9I8UZruF9pnP9SyehqqAGWzR+juaWw+3Yg/gEnWHEcDw8KekymaKLRUNxNkyRqnLbFImPVXgXG14MLGFUzdsObn8JopNmxfBCR0rx+Hm3AvFdi/XLr4cRWCdbaVUFaGOPvM6217Wj65aNNauqvS0ENnwrrw4v1P+gY5vylXJ3l/u+NdftBzcNX9Dc4B3mJ9GXCVg7/HbJrO6W3UEZ2UcjAXzhLm7SID1zEaBf2H1kgYPb7K3hX85iSMnimeXgRd7seVczt4kNQZGoYfHzBkMO/eghCS4q7hBpJMkKfRhS5C4qa72PogyEYV9rQ3cJ7psoDLX0g84ZqSb/K1ntUvndcbrKX89iAsaw7XaqJHVW4nedi0yPeLY215nyxIMj1uDVy6Irl9o23mgh5K7njbUt7bpCoT7UfZrJbNFn5VeYkQCLIeITV2OW7pcO3N8YfmKnhkcLu0vvP/8pPl3NaRofOsqaeXn9Jr3p4MCfeoHdoK0/FjEbzVcmx0Dxjg7UchWnrpGsEXchSSl1lUQbikoZAvelNMmE86E7XWVSDKkCaDHYodreUYO5AA1jZGKEChLdanaLIP3urdnGhQwEZwFUFw9u8T28f5HdmYestAe/+QZwwG6Pmo7iuCilqYyYNUmbUVxZL1EEfxED6k1YuwL5mN7eumw4rbrdcY6ryuqgk6wJFzIcei+SfTfBo93HeB9BFR8CJrNg+ygTUGg3RiSeywH8IDRjlv0n03ELjxcZ20FFZsMRrNOTmzY8Xyn5sKiay5WWat+Scldrsbrxhg38InGc+KI7wk1nccg4FrTAbj56N0ml7jAsJOls8Fa8rZHoUNtHd0O8LInk3qH56d9rD0zdKTj4zYMnsv/+MxK
 dHQw+tlN
 dOwfG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/25 10:13 PM, Steven Rostedt wrote:
> On Thu, 21 Aug 2025 15:51:51 +0530
> Bhupesh <bhupesh@igalia.com> wrote:
>
>> +static __always_inline void
>> +	__cstr_array_copy(char *dst, const char *src,
>> +			  __kernel_size_t size)
>> +{
>> +	memcpy(dst, src, size);
>> +	dst[size] = 0;
> Shouldn't this be: dst[size - 1] = 0;
>
> ?
>
> Perhaps also add:
>
> 	BUILD_BUG_ON(size == 0);
>
>
Ok, will add this in v9.

Thanks.

