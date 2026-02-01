Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B75BE6529D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 18:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0C16B0005; Sun,  1 Feb 2026 13:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E286B0089; Sun,  1 Feb 2026 13:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CE26B008A; Sun,  1 Feb 2026 13:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 813B66B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:16:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05F858C9FB
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 18:16:38 +0000 (UTC)
X-FDA: 84396693276.01.86E8E54
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id C723340007
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 18:16:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=k8EpPKsj;
	spf=pass (imf01.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.48 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769969796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+qd69DZei4cvz3Cr4QJ8zlJeWj/dQzSCNJkpeTRc+c=;
	b=T+wO0ndtsvRxxZi2/24EVli718FvaCLWDDtelusYuw1dCJZCK8mNSDtRay6HVSOgtGrKbv
	4tvwx0t9ead7vBRJ6091Rg7G+nGi5qOT7W3mribxBlm/o81Bgdsr9LP850DxfIoPKU3DXN
	8DVv48QYpPufLYhqduA3OEKjP3M5Wxc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=k8EpPKsj;
	spf=pass (imf01.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.48 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769969796; a=rsa-sha256;
	cv=none;
	b=bTtSaxktybY31JMKAT22ydDUD553PX0K5SINkAquSVSSJg+ADvDSD4Y4npqkewvz8ZxuXy
	mLAhcLSCw0ygAVOwAuIth6dPoglOD+LgJqMsVxg6R3RoXyAgbuuNr0zz2VbEPHnEvYPWI8
	xWAA5IpMiyRkieDpGDCXD7FfWicFKVs=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cfca52ac2dso2393329a34.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 10:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769969794; x=1770574594; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+qd69DZei4cvz3Cr4QJ8zlJeWj/dQzSCNJkpeTRc+c=;
        b=k8EpPKsjlssKUmTaop6IFhAakSJc+f0fF7nu/xLCv1nRm6lJ3dTZ7bwMRCRRmAbS7s
         xOzSNXD+K8DEtn3WqbhrF1Q9UXPqvqO+FPvp6Fac0lvWgkdoa6Ghx5VKkGQQU++VUxDF
         KZhs6kBEOydjJLtHtjX6pCg7i9m3byjVyACvREvonCok8Gp+8UZjgl5E9W3xwalR1xWx
         uaPNrSknAzg81lYo7132NrhJARlL7ovnMvq7P9iVIolVhxd0B02EUlC/MLBNozX8j6dD
         JZpn3qp+xwZk8+MyZYu+wQfWvpmvPxTTXfmoijnGnYzN9NHY1EpMBU55/g9bIcFsr1SN
         atUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769969794; x=1770574594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+qd69DZei4cvz3Cr4QJ8zlJeWj/dQzSCNJkpeTRc+c=;
        b=Wt8wia7DMYSiWvS0w8Rx37xtmcM//Il+RTL84/ulxIl8o3cs0w+4OKLjl0H53LOTY/
         s8YfB1CQ9CJrUaEH2KixMTzHqqK6s+ze8qXIg/leEvxNuZ8TQLDt4HSUHy3JPGT6aBe+
         XeBXwwe//tTIWgotivl7ELI1Qvqbr7UCRLxS6UkP0imC9Zis5sFJhJlmJjdhx/R7iO4z
         VF5Oq8dXMnRy0MZhrZkqMXWPnRHA1rhkZy/peQOdM2v/viuIonqxU0HBmV5bSyhqx0sT
         xk3pdvNa/nI4UKq3HdBe5F472nr5eVLzzdw3Rqv9VtniFirywzwAvZH6d2AwVumjF5pF
         edbw==
X-Forwarded-Encrypted: i=1; AJvYcCUNYtVLrsjgq68+XmvUZAQPqQT63C9q4Za27XT0IazQZovmRetJtIk6f5lC4r9S5DDDUpJyE7vMcg==@kvack.org
X-Gm-Message-State: AOJu0YwDA4TIh5dqYhFIMGSPpKxoZy6ASzXdPjQeUPndyuSfAgOMCTkt
	qND9E3x064DPmtOxaqxYwGlpyomsgdNaZ54VsolP8+9xC76+QLDzNgX26aTg8eZViXU=
X-Gm-Gg: AZuq6aI4CCh0u2/aLW9mXQ9RxkMNP2L8ZbLZ+KFTTNY/l5juH3HTK+G+bfp0FwJaL24
	MCf8mcv5tdKiRbQOcpgpDdAmflvdYUjPRXKXb4Iaq/d8vEJF6mqPc80lf5dxNNarS3RI0wXCoz5
	MPof10g8BbHhWuZ98ALhm5qMmcTfPH7iXo1AjUavgE0izxHbRyBqb9EUaVC69HbTkCGJSzIRW56
	zybN7APWALF4Ut80hiZr+8ivDxscA26mlZ7iQ8zOB6pOLaD/uKcdNvV9Bh7lZE/g/sFcThxPxqg
	FYSiP7SNYNuKLg77suxkvSJEthB5yBF2VWEaUZrnNlMgiwXNzRo03PRp7J82nxBN4TWo6K8Y6kB
	BTVM8MRQBA94QPAZ7dY2CJ3VSjlvgV/LlG5hyuZ7YNGR2P1X3j8UdJrwaLSs5yGQlWewFNUDbmk
	A4Q9ZlnCnbTY4hWcxEkmM/SgHu0hmKbncwGC0vBvgdJuukbRVy2bGKEl3+pri7WGVoQQQu3A==
X-Received: by 2002:a05:6830:411f:b0:7c7:6479:38ce with SMTP id 46e09a7af769-7d1a5308328mr6009692a34.18.1769969794529;
        Sun, 01 Feb 2026 10:16:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7cf4f0sm9108214a34.15.2026.02.01.10.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Feb 2026 10:16:33 -0800 (PST)
Message-ID: <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
Date: Sun, 1 Feb 2026 11:16:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y7bzpkpqb8bhh59hmqs5w9d17d5aran8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C723340007
X-HE-Tag: 1769969795-362976
X-HE-Meta: U2FsdGVkX18p5oUQXpFuffbL2WXhkHDdeW3Yv1YXH5TFmUrJy5IqGWWeEVO2c4pvRmi8zxsx2349Y3/1hrCMxQkqoK+M4ZgDBJXdMRD+srGkT5agVUqqLKDBcy4sVd1PT4dpBVMZ89ircUvrYieKB7gJ0MRo4cMFYMB6LUjoLrzPLzcJGwhzB+fA6gluNCERwQxtGKVtJhrF1HcT9czQFEAwhRMhGkGW+GDAHJfVxdfNNMnSVwxtMebN1mhJpNFNQ22JPSOZJoYIAIIFPuhC6mHdJM952b/jBCH2bjCQoxaGdvZN0gXGcuZ+ClpMBqOlryoDKGH9Kn+aWKnOneT0+4zM03TlfchWjyqRxVazfI+WCVICll70w+sixFpTtUe/7VF238ARzkfMHgl5WNslxaoUm+0Z+sQo11eABEk6zu03mMAaSGkF4GlP5Qc4KbRbHYbgGlwOBbfnxht9YaBxAGgl1pfO2Sdf6sBbvHmXf9gzcGiY0L1WiP9RLk9Wl1cZESlygKHEfKuF3B10RrPYuLaJ0Kz+fyYFcnmo8D1PQEFOZQDFzLnFXd6VAZL1A8bHakqR6cf1zAcLCrMH3dBuxSBTXbpeoIJXuGkBcs7yI2JqZWQopDQy49kAywDsbGEgjcJZv//EF+CfeFmmtBt7Z9lb+1zp3d7wRkOXf8ZsNHFo9w4cwHNNQaEj0JzCj5H3+CwQ3ZMYXs0c0952EV5lTxva6/etu/biPNnSBu5MF9TdCNAoIMc/Wu/rWci4iBH6kdR3mbI+uFmIwR+1KI5gBwgVjBC9yPmMZkIL27Sjd1xf2McGFn+vxsI45W9pgnyWqSQIrfzRqVTfp4OWUm4FoBbzPurgXxQ0/Kxe1Sv59sIW87rETX52VHSNlIlfXl1TqC4ID20SMT01N/B9KL0ELr0vlmKhMlugGvKTVqNqewe41ny9oS794Zif/kKx6GlGwaQZPcH1pNPOrOb9YI3
 rvKhb6Tq
 s58qzmXJCEjWhBmKfcBo/jtujsNsw4ucQpYgpWm1BjDBx0mETErTzdjYEsQrsietXGDneW7A9r2XOYX9nVJOCx6ErW65Z/nbWDq1dtFWgAHlhbIw+2L/xhwmiSbf9pAD5HxPCPWN3fqEgWvA4hU3vTC8i9SB/77Xn2CrT0tNcfUcuhPwMnHrzDF0titFELtqqAPt0oxsq5dj1e/ZL89dRP6l5TuAr5DP5naFyXYRG3IhjdDTbwIHrVI1j5kRyFxlP5EsA4cIErrPgjMogWXAq52Ox1l64v/6XPA7rw4TeYWFrpufEmgzmejsH3EdYnDP9KOPGVa5ZuK8emuRDv3aLKN4FHyc9rTtx7VrBfAKZAEtqNlrcJF2boQkEm2SL9EYeIhbLTxI02o2oVQ8QJfm/DWQjDS1b0y9jJJHW/24p7ou78COYj8284XEZ1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 10:46 AM, David Hildenbrand (arm) wrote:
> On 1/29/26 23:11, Gabriel Krisman Bertazi wrote:
>> Hi,
>>
>> There's been a few requests over time for supporting mmap(2) over
>> io_uring. The reasoning are twofold: 1) serving as base for batching
>> multiple mappings in a single operation 2) supporting mmap of fixed
>> files.
>>
>> Since mmap can operate on either anonymous memory and file descriptors,
>> patch 1 adds support for optional fds in io_uring commands.  Patch 2
>> implements the mmap operation itself.
>>
>> Note this patchset doesn't do any kind of smarter batching in MM.  While
>> we can potentially do some interesting optimizations already, like
>> holding the MM write lock instead of reacquiring it for each mapping, I
>> wanted to focus on the API discussion first.  This is left as future
>> work.
>>
>> liburing support, including testcases, will be sent shortly to the list,
>> but can also be found at:
> 
> Just a general question: why do we unlock each syscall individually,
> and not in some intelligent way, all syscalls at once? :)

The hard part isn't enabling all syscalls at once, that could be
trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
And for any nonblocking/simple syscall, that would Just Work. The
challenge is for syscalls that block - the whole point of io_uring is
that you should be able to do nonblock issues with sane retries. The
futex series I did some time back is a good example of that - you modify
the existing syscall to expose the waitqueue mechanism, which you can
then use to wait in an async way, and get a callback when some action
needs to be taken.

If you just allow blocking, then you're blocking the entire io_uring
issue pipeline. Which was exactly my main complaint on this patchset,
see the review reply to patch 2.

> I assume supporting arbitrary syscalls could be rather hard (or am I
> wrong? :) ).

See above - it's both trivially easy if you ignore the problems, or
somewhat harder as you'd need to refactor the underlying bits of that
particular syscall first. For some of them, that's hard. Traditionally
syscalls have been fully sync, they will just block and prevent the task
from returning back to userspace until they are done. syscalls with
io_uring is more involved as we simply cannot allow that kind of
blocking.

-- 
Jens Axboe

