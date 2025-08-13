Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ACDCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C224A900056; Wed, 13 Aug 2025 06:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAD7900044; Wed, 13 Aug 2025 06:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D723900056; Wed, 13 Aug 2025 06:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C19900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 213B85857C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:27:33 +0000 (UTC)
X-FDA: 83771357586.17.8744D7B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F76540008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:27:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=HCmlWVyZ;
	spf=pass (imf07.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755080851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYwoVXG6EVtDNB7BQEDc+4ji6UVSTCEFJFvpf+ftEnk=;
	b=Eip6a0ZEDFdZyiPCHInN3Tx2LO4i6lYOEIaM4AHeaOV1sc9iXQzWRq/3HBDz922fIhQx05
	wbqrKoyvfAl4VxGkjHrwVKr2ZPYjASjM/D2WmeQ/lYwf37LJefFjGuPsxe26d9AHHYeTxs
	2PnAaWS67Z4vO+YKwh+LEyl1kpJIeCQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=HCmlWVyZ;
	spf=pass (imf07.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755080851; a=rsa-sha256;
	cv=none;
	b=L7LFsAyaiOngcGiVp+cSN/d1L98Bs6hvRosWxNWuKt0c8BNqBfgxcMAPwoeCSD0sEIezVr
	5RAA4e0opTPh/OS5YkksoL9gxtJn+lvbwwo0ELXTi7/PLIlxmXRe5H6Ul3t1uhcblIZSBg
	aSx9CSFfa7WVT+0Qqax0RlGkd+is8fk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gYwoVXG6EVtDNB7BQEDc+4ji6UVSTCEFJFvpf+ftEnk=; b=HCmlWVyZpwxvhNFdFqNNQ1MltH
	tzABBEfLYpc9Z9qWBJh1OgVAO9NfXYc9RUKHPbVQcDbgjfxUeGjIc+gLalwrT0cICox6QAd+0AAJj
	W419et1dlc7204Vkn3KBNChVJGqHaErmA1/acfm+Q8ZXv3qGtLy1uD0jplLJqg2xAcUY1Skt61mK7
	Wu382QfV2GCUkSm7ikgYakGa771LzswGReNsFAuf8bsCFK+1TZ78hHBk5aMakoWa15EphPruqzssP
	CKEJAIcrh0JWCeAnACZV73MgzabyydXmM8NL2zPDk9mI/Wac8wrfGNNnfLSrtJvhalc2IYDJpxAha
	h3NB4vIg==;
Received: from [223.233.74.188] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1um8hZ-00Dchg-7i; Wed, 13 Aug 2025 12:27:25 +0200
Message-ID: <b6e63336-aa39-dcf3-3f7c-ac90dea127b7@igalia.com>
Date: Wed, 13 Aug 2025 15:57:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
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
 <20250811064609.918593-4-bhupesh@igalia.com>
 <aJoGvv5TEfl1liSm@black.igk.intel.com>
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <aJoGvv5TEfl1liSm@black.igk.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d9jtbpwh8ssk7cciahwy8wittdqruz6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F76540008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755080851-476938
X-HE-Meta: U2FsdGVkX1+/XPXeefv2NNcyreBcKnXL/49cvZrNkHKPfB3pAtFqw14mNUFgBNi+WcJyGIjQwDs+mSsfAzTV1/1Q13OTrX/CnREv7XsHCEk5J2OHvcnkD5tLrET0OEQKZhiu5VDX+fsJ9KATERQK0eM5jiu3aDeyFGDWb7eN5CAR+nLKsp6/qljMESwIJGSuuYP1ZrGVeeAf+hhSv+BH7jdBXrV3IYimfL6uo4Mq3X5v3qnXO8TRw9Rx9nIQgBI/2jSuNiXS67PH+IfObRZ6EfTB+sBcsTs0b2jtCLIPXnF1JfBDpaLbF+1P4pIctu0ZqLvwvq1dV+KsxmW2ZZFwMSGAfCFZpvpIw5YhIM+rwgtYpbsqByCinJBLkNQOsBXFFaXG7PWIw77wB9NYtcO4Tf98qB7oarrG2v8H2+rS0Wv9Bx9EAh1Zt3WqQCEu8LC46k6RoxuO68SXDg+SLDulJ4/iqHllM/7QZLV/7Svf11XkwQzYhoCI4cBRrqcJN1tYVGMo0j2h8OO21RGVhbW6lDdpqQnJkPA5u8fpfr6JWuLLatdVdYjlFFvq4yu/aRTxpAHI//Pap9udvj+DKcUSuz5pCgAnt/OyBQveaUpm35GB+peZ50vtUDlRG7OobK+o/Jp/vh8lwGQy4F+7otQnDsmABpf+4guObN8dc1LvP+Yy9y+OTB75vhQDEOr1GatsDUkGeJf4LZlQCP2U/RqPcZ4Q/pHw+/jXRKFouk+58tcCeoNVwe1ywC9brKvtuLDb9kve50jOx2sxCf0I3uMG1+Ty80w+ogf5tr5ldo6zNWT0Cpt4ecsCPOGg4NF7eutCcrW6I5oloogEx1i7zdZ4JxgIda4BrI3bEwEHzY0jY0gD2U9Tue7+XZohqLiZ5tRI9HEq6jg0wF6v/m+uAUC7ipry9/QatbYUs1neAF1H/QF0MGA8hByHZwLpGSO/618rKjTvR17jKJkjeMEH30z
 rZHjJ86c
 nN1kJwI6a1i/CMdtKq6M6HUf1YlTKwsAWBzR+7wRJFc8WFeI1MCmabqx2lQEEDqzi9pkqdWM0m2s4sS1HfFhU/wsMQ03p9WNobHmf21mEnFik5VgjNFyQKRQuKDx2FEWylbg+7KVDTyV68vCw+TmK5Km6VbllEhq2cSGTtYQWG2t8Nk2XsP/5ekTHnnnPFvevPf+82iwjbj8ZXlDj87ccUHKwEaMHg7QQJmEF0Tk84ySL0QYM/hhXzyd/X9nPAwvVtEFbAQXC8JQdQkNnl39yqOR1agYW2WcFixqnDx8MTtZ6xaVzUO1cwMbPmL9IyKutM03WTVuTVnYd8z20JTmgCiRDrS+8915qfWNvbKPycyhf9aEVN3M7fujch0tvDsBVgGAM6NoNwCsjOMHHI3hiKOtipi5QX8UfjvtRHlFmSen96X4lZmaqASBqpteKjE4MyPpQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/25 8:35 PM, Andy Shevchenko wrote:
> On Mon, Aug 11, 2025 at 12:16:08PM +0530, Bhupesh wrote:
>> As Linus mentioned in [1], we should get rid of 'get_task_comm()'
>> entirely and replace it with 'strscpy_pad()' implementation.
>>
>> 'strscpy_pad()' will already make sure comm is NUL-terminated, so
>> we won't need the explicit final byte termination done in
>> 'get_task_comm()'.
>>
>> The relevant 'get_task_comm()' users were identified using the
>> following search pattern:
>>   $ git grep 'get_task_comm*'
>> [1]. https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/
>>
>> Signed-off-by: Bhupesh <bhupesh@igalia.com>
> Make that a Link tag?
>
>    Link: https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/ #1
>    Signed-off-by: Bhupesh <bhupesh@igalia.com>
>

Sure, will include it in next version. Waiting for further reviews on 
this v7.

Thanks.

