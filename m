Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E0CD31A13
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4316B0089; Wed, 14 Jan 2026 02:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372146B008C; Wed, 14 Jan 2026 02:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253266B0092; Wed, 14 Jan 2026 02:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11BEB6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:00:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A58EC58B79
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:44 +0000 (UTC)
X-FDA: 84329671608.13.D3FDCB5
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 711894000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:00:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768374042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXRLAfVUFAWkBDqYGWw8aUdWzbRW4J9L3xN2L60cDN0=;
	b=skr4A+OTJbM68IrJORich7ErEsq608pOjROEupXLXRNOJEoceZclTottfJ0TBg/T04TwDt
	FJ31lW/cSJb4mFmSLUU/DWgrrD/4VL+CTFMQkscoRSytyKCndvM/pZUyhbnDCyb7aSzM2i
	eL8cbc9afJHfer9yEN2ekPUW/9kPD/A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768374042; a=rsa-sha256;
	cv=none;
	b=iTnmhln+82t7L1H520yVRMAjxPNUftkyx2I0gwAAPkKSc/QiaH+eZ7Jh2pdhscGtUCrS9w
	AMsEeWXjlI5Gufm15s9xbTJzHFfoZMPiMCxlU2Z72pdDl65vxo7Z1Ik2EH4d4bfls8JvVV
	41e+3AZuGqYwsiE2tWiMRZFEtwFA1sk=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4drcT12mmWz6FyBv;
	Wed, 14 Jan 2026 15:00:37 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 60E70R4v041133;
	Wed, 14 Jan 2026 15:00:27 +0800 (+08)
	(envelope-from wang.yaxin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 14 Jan 2026 15:00:29 +0800 (CST)
X-Zmail-TransId: 2afc69673f0dd59-ca7a3
X-Mailer: Zmail v1.0
Message-ID: <202601141500292511NYBdWwzTilw10jiTcGlN@zte.com.cn>
In-Reply-To: <aWcZCwz__qwwKbxw@casper.infradead.org>
References: 202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn,aWcZCwz__qwwKbxw@casper.infradead.org
Date: Wed, 14 Jan 2026 15:00:29 +0800 (CST)
Mime-Version: 1.0
From: <wang.yaxin@zte.com.cn>
To: <willy@infradead.org>
Cc: <akpm@linux-foundation.org>, <liam.howlett@oracle.com>,
        <lorenzo.stoakes@oracle.com>, <david@kernel.org>, <vbabka@suse.cz>,
        <jannh@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <xu.xin16@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <fan.yu9@zte.com.cn>, <he.peilin@zte.com.cn>,
        <tu.qiang35@zte.com.cn>, <qiu.yutan@zte.com.cn>,
        <jiang.kun2@zte.com.cn>, <lu.zhongjun@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0XSBtbS9tYWR2aXNlOiBwcmVmZXIgVk1BIGxvY2sgZm9yIE1BRFZfUkVNT1ZF?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 60E70R4v041133
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yaxin@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 14 Jan 2026 15:00:37 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69673F15.000/4drcT12mmWz6FyBv
X-Stat-Signature: 5et9xoohdgemi1w7af3hx4ypx4zayns3
X-Rspam-User: 
X-Rspamd-Queue-Id: 711894000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768374041-472694
X-HE-Meta: U2FsdGVkX1/nXuJRVvi9SS4/araQWnJUEwpSUC5LXCmgCzd4qtqJB8uJZo+QIWfroI1QGz3r92Kp6FZpox372lcM42iullEUoWZoxypGlmXiargVrh0Fya7Jc/BWjj55gzPcj/j27yqbLpumDdil8rnp3lz3O3lFcD7z/r/5GmqLN7xzZfVbsbLJvwjezhASs+xFm7UAqsZQ4N8NWYHo0EEu01pm5VaMdEOySvgWJsY/2oQUkx3yergxRVocdk1q4itd4QEY7fDZeSHubaXxjIPD9IJrahge4rJyFgP0Ul1xpbsjymr2OO3r0WgmfR0/GtYrq2WLFvLQ+U1AT4ttMR11aTK4QS4qA8R27KJ5PhuXYVjUhqVYF/pX1ZTGisetEYtsya2f/rzc2Wqbe5AaOje8+WkXZBNaizEjc8HvvJ2NYhPZRtKBGcx/IIFbC1QmcCO2QarxsArHz2Mnmv+4i3jCYelIYBmsX4Lf51sHSM46PbbQkwVGoJPQnjP0eXGHiGSiK92ayBg5v8exJqnTOQyhudA4qZ92uvG0WEL1LMzLRfte5nB8lg0ccD5Ua6kWXZOevbD9YiLUAq2cmOU8Q6dxnj6+fFL1wFDz53rJKtSbIleFEKt0m5qsA/xd36l/Obtz4r7cRGaJPFEkpB3P+30iGWsxpBHEk8kXHBdrlXFlffuW8ufjHZF4SAgvknkH9j32atHhDitkzcO/iRuJjjeybDTzr4uACxN+dCvbfXIszNQAVS1yGQ4aFJkA3C5STrURCZBNwieP+P1mbytDfdaTB2frB8zTKllhN5nUsN/WA87zTLBP5/urM44xPd3v6oZ9eTr0/seX4VNkWZs5RI+RZIvQcq9NYJxGfTgx3I1LakXHVZKSK2B1su7KjKatXet9ynzaWleizXXzGeUtNU1FGbIw1EuLObTNrnenh+0UMptR+dWsxwMmZgPOhfzHQ4HHmoLCVZNYwkfImWU
 aoPz8U+9
 gREqGwSELq01dOv7GUXbAKpTsMfC7BjzZsJhb96jeTc1uYCVIqWvIvD03kXk5COY+7BN6n5zsuj/I6g521NL/OT7u9U4/USvI+LhgPeTeP9g9+elowflWIjsE7COM4LJ1iG8bPo53HKoqRn0aTNDr6Sex59gyFVK/8TOt8KKBFmJD+ff4ETGSP5R7ihPzHwr15anssnBNzvS0w5vta0rmGnR07o+zXpjd2CASKZ2NgxN/f6N7mrKvYzWcL6WNo/lAaxeB8QCVb21nh6oeQP42SsdgSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> -	mark_mmap_lock_dropped(madv_behavior);
>> +	/*
>> +	 * Prefer VMA read lock path: when operating under VMA lock, we avoid
>> +	 * dropping/reacquiring the mmap lock and directly perform the filesystem
>> +	 * operation while the VMA is read-locked. We still take and drop a file
>> +	 * reference to protect against concurrent file changes.
>
>How does taking a reference prevent file changes?  What do you mean by
"file changes" anyway?

Thanks for the review.

Taking a reference with get_file(f) does not prevent file content or
metadata changes; it pins the struct file so the pointer remains valid
while we temporarily drop mmap_lock. The VMA can be split, unmapped, or
otherwise changed during that window, and without a ref the vma->vm_file
could be freed.

By “file changes” I meant lifetime changes to the VMA → file association
(e.g. concurrent munmap/mremap or VMA splits) while mmap_lock is dropped,
not changes to the file’s data or inode state. Those are serialized by
the filesystem (e.g. inode locks) and are unrelated to the refcount.

>> +	 * When operating under mmap read lock (fallback), preserve existing
>> +	 * behaviour: mark lock dropped, coordinate with userfaultfd_remove(),
>> +	 * temporarily drop mmap_read_lock around vfs_fallocate(), and then
>> +	 * reacquire it.
>
>This is not the way to write an inline comment; that's how you describe
>what you've done in the changelog.
>
>> @@ -1033,12 +1045,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>>  			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>> 
>>  	/*
>> -	 * Filesystem's fallocate may need to take i_rwsem.  We need to
>> -	 * explicitly grab a reference because the vma (and hence the
>> -	 * vma's reference to the file) can go away as soon as we drop
>> -	 * mmap_lock.
>> +	 * Execute filesystem punch-hole under appropriate locking.
>> +	 * - VMA lock path: no mmap lock held; call vfs_fallocate() directly.
>> +	 * - mmap lock path: follow existing protocol including UFFD coordination
>> +	 *   and temporary mmap_read_unlock/lock around the filesystem call.
>
>Again, I don't like what you've done here with the comments.

I’ll fix the inline comment to say: “Pin struct file across potential
mmap_lock drop so the file pointer remains valid even if the VMA is
modified or freed,” and remove the changelog-style prose.

Thanks,
Jiang Kun

