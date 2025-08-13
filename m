Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE98EC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC32900057; Wed, 13 Aug 2025 06:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CB5900044; Wed, 13 Aug 2025 06:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C58900057; Wed, 13 Aug 2025 06:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61F8D900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:30:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D663B1602E5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:30:12 +0000 (UTC)
X-FDA: 83771364264.30.60F9626
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFB9B14000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:30:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZtsMR+me;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755081011; a=rsa-sha256;
	cv=none;
	b=AMS2+UTsuq5YoxgMkXLD0ZbOKQhtHZQTfe1SHA9pV5Z52JQhjJGmSgmciB64J4eY0vbYPz
	b8PvKXyHx9UFGDDXGdFPT8syLb3SCI6yQKAjfdpffpCzEOFR1MXG3kRQW/rnlLkssCO0Ey
	ZGMVLAbAUDmmSypGmTsBxqsryRplSpw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZtsMR+me;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755081011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL2N3rzy3idztlSr2gXwrwvq9ilpXSh4BwMyKlX4iZ4=;
	b=8RApfVeDZsNEeTQrdqtc32OeD0z6wdBG6Rdni4YrhC1KK0FJ+97c2ynNkfqzi7+xqvnlCF
	ulCD1h2pbj7XApG9MNfnSPEAIgD/4FWmtruhuMzZlJLIpvRXgEmZkFKJBKSDm5kWxpzFKa
	6ZlHDH477num0dI1XXDMRGIcJdMjmWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lL2N3rzy3idztlSr2gXwrwvq9ilpXSh4BwMyKlX4iZ4=; b=ZtsMR+mehPPuVmA9EzTZAgr71b
	zRk/vrnpKSBIzuvdThdiipz3zee+0BL3gGCnjOOu87QWnyvxy/iebh6J9ZsNgEn+qfDDS2kJdDJlu
	BdqlJhOVLps4vcTMQY8edpo8xKKOjG9SNTLhgrNq8S3dtry03dNL6LOkgUVRFkyjXdBtNHNvntsKU
	olWbzqN+CLvtBxsLHUKArciwfJxO0HB7qYzayqQNsr4oTtmIcr2PEcVWRDy3rc8Q+KDoexLCnx8Qj
	PvHw8l0BWnVQuaqo8vH3ZhDcPZpGzq/9OMZU5wJYncVMGYlXi/p6zOH2TwqDsvdg2r89xY8fwXayi
	P358ykDA==;
Received: from [223.233.74.188] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1um8k7-00Dcki-KG; Wed, 13 Aug 2025 12:30:03 +0200
Message-ID: <6af1a8b5-1c10-06b1-a368-a685a7e21e15@igalia.com>
Date: Wed, 13 Aug 2025 15:59:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v7 2/4] include: Set tsk->comm length to 64 bytes
Content-Language: en-US
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
 mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
 alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
 mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
 david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
 ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz, mingo@redhat.com,
 juri.lelli@redhat.com, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, linux-trace-kernel@vger.kernel.org, kees@kernel.org,
 torvalds@linux-foundation.org
References: <20250811064609.918593-1-bhupesh@igalia.com>
 <20250811064609.918593-3-bhupesh@igalia.com>
 <aJoHzTKO9xw2CANn@black.igk.intel.com>
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <aJoHzTKO9xw2CANn@black.igk.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CFB9B14000A
X-Stat-Signature: 8r5kp9kbuy49nkoo14dwb6bjia5o7kmt
X-HE-Tag: 1755081010-731594
X-HE-Meta: U2FsdGVkX1+1ML736A/isg3WcrNxmm0KIevx/oibSNCbr17D3mbcAEJWaahMdZH2qSld/2pnuXHIxZOU9eamOGEsEy5uwHePudCVNJqtkxVmKReam4reqEj+yOGCg1voBe2kI5ehMSYk5jFwn/nkbEeLk2yKnimK5S0aJHgRu8dY6Rl+Thgxn+03hUUoaaLRGVvgJti4z5BUsOyKI+u2UzRJUyAPpxi1J8cYAS5DbfaSyNvn8OlYZckfcIK0TmQwYfV5QOTaRvC7V7YU2CuE8oH5gvvzekQDWufuzv1cpLYSAeI5A7ipKIUYvcp4Jqkju2+EQ1OVr+9XefYO6izXn0o2hbE0h8kIEtWaMu9HVikfTZ0m+c0SASsBSpwGxDBanTRRqjc8MLzuzR+w+0SAxPDWfcEVAmRKtl799S+rChymQbjbpdsIqy03Ot0yfR0HfZq3sx2V/IRfnGcKvX3UelPLTdFadmGK2zcUKiM5ELxRXgoX17Rs9l9TE1zYEDV6JyrMtqA3w0URN2B2zLdOIDzXIl1ZXA1/BmN17H4eQdB/zlEeUIfjMKv3yyA0z9JQSOvtXSQCbcnGBDdHqWuK+lULf1u7T97YklG5Wg8WFQkyp+4i9l6SyIMmaQxO+HF/g8eD7SvOKcOi3DP15xfxVK9HlmJ0URRUob7e2DJGRvs+ExY6+zJiAELKkqOXFym/jj8Fp+cGJW3A1H60unwwjAdzHtqf21kNwHQuzxuMKKKGFyRr85D8KSGS4BZ+tvysNoUvgsWZTHIMHG5SG2+5uhNNJE/lBIyUbVTmHWlGVaGme4kgdDKc619WIUsRwt+e6uMacVgpAylMOHgfa0Z91VIVq+whgdn6j0ld76vaMmASwRBCch2048jY6/fEe1fo3XicMibVuM41TaJ0c/SKv4d5UFpJoJ0golIrzfCpke6O8svdmxsb+7Z195sxNcP3aUYkuoL8r87cOqk+/h8
 B9zji/WC
 RQwqc9rq2WYgbGqoCj9TO2v1dJPVxrbePM6ewldxms+t/2hGTmA94H5P1szpxUuxdQ3XMnRR6S0Ig17WTcGqffsk8PB0i4X3o2wLp59FDA7T0agGVNeJfnV49txQKO7k4Rs7kEj8axn0tscS+UKneE1GYrPFfzctzTaKjtWG9DU+9qgVES8cUs7S2tP3Yne40NRP6cdeNHghsqwKDk0qlG9Q4CN9eQxHHFBJ9SSWgdhBJSB29xg1ahiHRldVf+TeuLw430llDUAX1gwg0jhSb2CUHfFNAhObByZe+bUMtd1w0pos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/25 8:40 PM, Andy Shevchenko wrote:
> On Mon, Aug 11, 2025 at 12:16:07PM +0530, Bhupesh wrote:
>> Historically due to the 16-byte length of TASK_COMM_LEN, the
>> users of 'tsk->comm' are restricted to use a fixed-size target
>> buffer also of TASK_COMM_LEN for 'memcpy()' like use-cases.
>>
>> To fix the same, we now use a 64-byte TASK_COMM_EXT_LEN and
>> set the comm element inside 'task_struct' to the same length:
>>         struct task_struct {
>> 	       .....
>>                 char    comm[TASK_COMM_EXT_LEN];
>> 	       .....
>>         };
>>
>>         where TASK_COMM_EXT_LEN is 64-bytes.
>>
>> Note, that the existing users have not been modified to migrate to
>> 'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
>> dealing with only a 'TASK_COMM_LEN' long 'tsk->comm'.
> ...
>
>> -	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
>> +	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
> Wondering if we may convert this to static_assert().
> (rather in a separate patch)

That's a fair suggestion. If others don't have an objection to the 
suggested change, I can club it in v8 along with any other requested 
changes.

Thanks.

