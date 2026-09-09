Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A55CC79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631B66B008C; Wed,  9 Sep 2026 02:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2476B0098; Wed,  9 Sep 2026 02:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA056B0099; Wed,  9 Sep 2026 02:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7AF6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:45:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB545160117
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:29 +0000 (UTC)
X-FDA: 85193287578.02.A63EAAB
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D81E40004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j3eVYzJR;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788936328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ss/fd7CoRDmHqqk6ygxFDyk+tFe5fP03rVfekoXKgVg=;
	b=OraLopW/f+UpORKiZOmpJBGRe4x8dMzsjit536y6GEG/yOUIv7yqdaH6kv09j97zvMzbAZ
	WRksEuHPNMbXDC2EWfFM8pmnz4spbucE5uP5VOuzF1msdG/dwm+uF+izZD+/XrST/34CC/
	vyW7nHxWSETQggnHSOf0XCt1P/GYLog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788936328;
	b=J6aFobG48oL+MTJpUdH5Od1smarHlMhBPWuF4yUP92L2I8upCoSRl/dtNu9NqN2PE05M7z
	kxqMSgb8Zaegy0T4OGFKIZlBO2gY9fVn+f2bZorO3g6Nu9f/orfpf+//ezwEh3svC2QGhz
	7NeapJzui1q+lM9cMqBA0MLRN/Oo558=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j3eVYzJR;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oTBpNY7hw7Wf7aDEdyGbqp7ST1teTAUXIET1OkGaVu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788936323; v=1; x=1789541123;
 b=j3eVYzJRDP4GuwDpk1yAzHJdHeOy9WgKtiCl6wojdnOYSSQYKj74Ze4IE8uZMBTffhl0yVEg
 0g76LWdQpAcp1yt1dkPOsXcAIBwRB6+Jj/p/QLt0UmKmLZdtwSgMtUR3G1lQ5vgQmgMbqfwYwcT
 GAu5tQEiBO8r9XugGs76VhSs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ed883708a2057349;
	Wed, 09 Sep 2026 06:45:19 +0000
X-Mizu-Trace-ID: ed883708a2057349
X-Migadu-Flow: FLOW_OUT
Message-ID: <7d47a955-eee3-4a93-bf8d-210eefa59f0a@linux.dev>
Date: Wed, 9 Sep 2026 14:45:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix ptrace PEEKDATA check in memfd_secret
 test
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, James.Bottomley@hansenpartnership.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260908025111.34562-1-hongfu.li@linux.dev>
 <ap_N7u5DbIk4FEeZ@gremlin>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <ap_N7u5DbIk4FEeZ@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 78wd7mryzzhg9tu5xhd5j1tfpbqw1ykz
X-Rspamd-Queue-Id: 9D81E40004
X-HE-Tag: 1788936326-616420
X-HE-Meta: U2FsdGVkX1+YDrpKbu6RW0n4Jcn7z+oDq4BIZpVm8hCz2CrRyCN6ZUlntGANr4MhO169DjLyVgsEsHpaEQLxKbzGCSy/K775KsoKLQloV5V2Zte+GUG9NZ1UMyxVEM3s0WcceP+Vcw11VY0aa33LT9NN0Jg3amnnlxf/uE1j/l5TVWrSq9UtEZHAY/pNrdNy3HqFnvvlRcd1p0XABVs4OzDSkSE1Vprozoe6w6ZJFrnYnNF4Zoz6mXGyZI0fgFCRNmvRXpl4xTa3xe4mcWMNyrU/8hV7mjEynnGT/OufNBPYaTUONBOVvgFhrvWramNyytT5Cmayr9jh7QcdNEsn0296yAK4+VYqpqhmTjdD9AhsmPOnMuWZyUcaOplrCWJE/mfZRHLJuw2vdNYRvKd6IIV9sGClI9f+ALKmicFPBBnqYCBHdK2Ut/KBKyTX+HXLfkGUsltYH7pOLw8/qKdta9LpkY52fA12fw8s6CK9MFDbKe/GzmeJucNoa2n612mgSu7C4ykY5ouAtk0TVZ+KX90tOSUKRTyh65I1V9J+ur8Mc7yXdZDwCuxdtyKtLbKoBE0vHLvvIrmF/tjpRtixsF7a+ugxiPtl8BQ3xSc07PGaUa5ub9oGCdP1u0xx6SRjqBGBzol/7yhyUbwExC84NFi3oA8VkV+tYpbk2ydbUnjORQ0TXE68Xs6UtNDogUtYGRq32Zmr44hckr5JWX9GOFVzvoU0X/h3S8VcENP1Mthv0GoGJ1YtZqwZL9CEoM8IrdY+QZWX94cpXFt+3zoSr+oh1o/xWtEiWNw9gqZYP7Au1TqvZD7eU3Y9cF+oTojFC17T6UP8mYrkYuTK+H+xFO5ecm8sa95qibeJQBZksVthBt8x+jdg8r15YVf4LVYB+eUvo9WjUaVZZc4AUPYWkbz78LTeoDf0rNQc0OgiXvxFbpZQMEWMMqyKRtHCtYL/C2T+cuh2UREw97SKXhr
 0+/1Ot/G
 Qt0jVTDxBS64nm8fck+yN9JzlaeG2YeKOFlPtnJEU3lwnBXJV4iUhUexMJ71Gi+SJAaFeb+e3vNNfH6LZYbokg6lAjJZd7W5utPl1tfXIAW/v/z3RPV2ss51xXfGuXSu2qDIjYg4dkoXMSEzleuZ5ng7Z+HvMphgSYyDXQWz4w7k4dAs6iC6wN/UMcijklHIhqpskBoKKgqj+vJuzSUH6f69w9r2T/irTBpcZ4UO6UlkY9YuVscTsCjnztBEFKdXkuco+80bSM3Fwdqdg4GBOBX9AORv227uamJ7yVz6+F/RQAWnssAhFr3GvKU+zPiQtwUOhb/STephDOPn1mbTgCwC6j9mg5xD1Phbp5VEi6hGa82U34ddNEcAYSxeZXj2OIRLcbkOK2uE1C4Vn3AYVjg/Wqo9Y89U4rpZv7L6uIRU5kd/RL/CCu29P5mLDOexCEhfecaq3XQeRx6M4k1rTu8gOfgqwCSiUO5Sjgl0WgUQMAgzYdOEcnYLzIC3Aw2RThKwhUGp0FL1t9RD7fycBo3TBGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/8 17:03, Lorenzo Stoakes (ARM) 写道:
> On Tue, Sep 08, 2026 at 10:51:11AM +0800, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> try_ptrace() treats PTRACE_PEEKDATA return value as a boolean
>> check. A successful read returns non-zero data (memory filled with
>> 0x55), causing the test to incorrectly report PASS when secret memory
>> protection is broken.
>>
>> Check the return value against -1 instead. The test should only pass
>> when PTRACE_PEEKDATA fails, which means secret memory protection works.
>>
>> Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
> Not sure if a fixes is warranted? But I also definitely don't think a backport
> is in any case in case :P
>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> The change LGTM afaict. Though I think a comment should be added. With that
> addressed:
>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>> ---
>>   tools/testing/selftests/mm/memfd_secret.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
>> index c55d84c5e613..dd08a3a1ef14 100644
>> --- a/tools/testing/selftests/mm/memfd_secret.c
>> +++ b/tools/testing/selftests/mm/memfd_secret.c
>> @@ -145,7 +145,7 @@ static void try_ptrace(int fd, int pipefd[2])
>>   		exit(KSFT_FAIL);
>>   	}
>>
>> -	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
>> +	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
>>   		exit(KSFT_PASS);
>  From https://man7.org/linux/man-pages/man2/ptrace.2.html#RETURN_VALUE :
>
>         On success, the PTRACE_PEEK* operations return the requested data
>         (but see NOTES)...
>
>         On error, all operations return -1, ...
>
>         ...
>
>         PTRACE_PEEKTEXT
>         PTRACE_PEEKDATA
>                Read a word at the address addr in the tracee's memory,
>                returning the word as the result of the ptrace() call.
>                Linux does not have separate text and data address spaces,
>                so these two operations are currently equivalent.  (data is
>                ignored; but see NOTES.)
>
> OK so we expect this to fail as otherwise that'd be a violation of secretmem.
>
> Feels like maybe we should add a comment to that effect? :)

Thanks for the review, and agreed on the comment: the test only passes
when PEEKDATA fails, which is easy to misread, so I'll make that
explicit in v2:

--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -145,7 +145,8 @@ static void try_ptrace(int fd, int pipefd[2])
          exit(KSFT_FAIL);
      }

-    if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+    /* PEEKDATA on secret memory must fail, else protection is broken. */
+    if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
          exit(KSFT_PASS);


I'll also drop the Fixes: tag in v2 since a backport is not intended.

>>   	exit(KSFT_FAIL);
>> --
>> 2.54.0
>>
>> --
>> Cheers, Lorenzo

-- 
Best regards,
Hongfu


