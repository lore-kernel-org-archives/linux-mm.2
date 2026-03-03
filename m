Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86277EC0460
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA336B00AC; Tue,  3 Mar 2026 04:04:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E4D6B00AE; Tue,  3 Mar 2026 04:04:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D806B00AF; Tue,  3 Mar 2026 04:04:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B77B56B00AC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:04:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 782D1C1A81
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:04:33 +0000 (UTC)
X-FDA: 84504166026.16.E820D31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A42F40013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:04:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwIg7by1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772528671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLx2Bl9bORAU4WVbUx4nwnnYBAKxsx/PfZU/j2qQwi4=;
	b=ovbm23KHPfFe9yISObJOZezndfK+9rN3t4jwWd8RL1V/7I9HE/KfUSS2YiSV07GWfwT4ME
	XHAIdDK0x8hutyJQT/xuKB5f3Pktx/E11kALq+DFuJci7yGXeOqn64FaRgfuaO4qsVV5/3
	L3I6uZKVSuynX9JiXA3jbyGv6v5oBOo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwIg7by1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772528671; a=rsa-sha256;
	cv=none;
	b=2aBtMgDTSkAxumMZwbwDRbGVeZ772fKrJ7wO3Kq+qfjduKgh2M6J1meOfHVecD25J7h2JH
	xXbl0ySXQ11KHRtY8Nw5OdfbnobAWxG6VvKvOCkqfFQi0NlbKY+YC7iUnD6Hg4dd5/ZoXv
	g3apZieBF+h0kXUuz1YOa1+qL78YIO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CE7942BAB;
	Tue,  3 Mar 2026 09:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6CBC116C6;
	Tue,  3 Mar 2026 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772528670;
	bh=pcRg7UWy0oARLBPCzhsxNcvTwx5WBbNiYe8TNPnBms8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bwIg7by14/5Ml7GW5fG35Fybc0TWws4oWZAyqe1+hYdj4ZFel58Ezue5rsG8gjtAC
	 Yg6gNAhYGp2wPP41LGs3qtEBF/Vk4AvoLjtLfxWmrE4gTF5kA9r/c6K3YxArzWAQrL
	 BxxSdp9ycAwcg1Qu7kwPB0f9yLdLy4t8CnqCepfaHToGgZAD51vpW0ekyCw2QANT3+
	 rybJCFWvfrIPw52F/oB1oSnhR+HsyAdjPe77nDzKwIkW9QkEn9IZH7eTaRf+WWxujU
	 7x2pOm7B3QudTSqhVH5AB+Ed/bkj4rpTvlQ45FdazcS0AvKpf4q1pLg7AOdePTHnlA
	 5CF0w2qRGr05Q==
Message-ID: <f67087f4-d787-43b9-b3fe-7f0d5bb801c4@kernel.org>
Date: Tue, 3 Mar 2026 10:04:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/mempolicy: possible double-unlock in migrate_to_node()
 on 6.6
To: Matthew Wilcox <willy@infradead.org>,
 "liying3@sungrowpower.com" <liying3@sungrowpower.com>
Cc: akpm <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, victor7q <victor7q@163.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <2026030310525141773825@sungrowpower.com>
 <aaZgUNxAyKC2IwuG@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaZgUNxAyKC2IwuG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7A42F40013
X-Stat-Signature: qguo13pomi4nyezn86ed8ozx81zh4h43
X-Rspam-User: 
X-HE-Tag: 1772528671-753087
X-HE-Meta: U2FsdGVkX18inBmEF4+v6QI5rOkGGsbwQuqeX/UD6MA7n7HVb8NyESJP/qQKp9+aasznFT3JBVswifWP34HvmplQ6CnjRzZwLkcIjR95NY5p21qh00Dfay6hM3eCshgVvEbsBMBJKo/Xa3bveBUP56VuFk3jecKO7z5spCbd+6YujoK45DeR1FptPNhSZMOaGKhSkaF2XmtR0MjE29805HMfmBBV4Xk5uNoNchWNKmFBPEfyMOjGz+qKAW8BYggC6/1GERmFgroSEE2X5uN71pEn3M7u/KS0mf518Y+B3l/o/rNEZpb/JcrWXj0wvQDO4cK2HLsFX3/tmRnZUlpJvA+G3bX/k8vDGOy9qb5axCEuTFVFA8q0XvGujlYdPwLQqgW1QqTAeoYbkDPYi84Va1DrFzfqfFo9YKU9yCXxw5pwlFGaNUweckwu0A08CK81iRiqb1bBqFABvN2m7Xd5vXKwgN/kBE+f40U94AmAXqHthaoblzRxwGKBvYA0Tw61nyBcBZjCm1XZd1f4jjdNjFGes+ZIxGPzyoR2uaYTTC5qjd0/tkoG7otWZ0jqbdoIXlRrEk17RfpZbodWFWUd3nOeXTIYPNGX65CV+PXbC0uQTIBJD6m+tq3qGrP4Z3x1eBrJkaDgwzDyDFw8QDKyci2ML85NZjCn3PgqM6aW2bTx//nb6CcxAP+zTWdmmwdqcW82gx+JxzEBtnDYu5EY/Fd0Z1gbiVxci/r6p1hnSql3j5uoVL4wifNkXehq7BZf4fxZmkMsn/UJedzgDiyfbKV8hhw/JLwhnRa9/5y9kgSAaEpFDF2JJTSheEHdAY2vuzu2wAU17DSPjvxr2Pg2WeR0+Z7b2wo52nZ+tXzmeAmVsSRQIggIb5V2OCawM3u9pX/1MjGe01qooFkdO654Oxm5cY5sZfVugmx3ssgGD7+7+H97V9KcXJUE33xHZjzL0O/w5s5G6OvBekhiRQv
 3FrV8C3G
 w1l8KYbWyNlfAxwhmKf29u9JT56TI6JGuedDoZpfSYmBtDdaNUM5zP+M7WAviKN5C4FIzOV3cw6AuBmeK/NqVPJT8SDVJeuneyPHso8lukLcS8XO23nj4T7mcgvlNMHjmnVR/CMoeMhNBwHnNaVfVfVE985NQPQNqnOUCQRa9O/aM2rI76RK/TGFdzWJoEF/ao9QcP/eqfCFVw69KypsZT4akDbtmAlxkmOLViTZ1n5VeduMGqBUdLga8TTYlww8jyXyZU1bc0SKDZ0NskjuiBnD+8VYJPlo/9TFtvrh3c0fezHCVTGHrw2U2Ev5v+O10yS9UzCdDP86o8n0aha22tkArqNGIZM4fbhd/gNP+b8oFbO5yltLEe8ofBY0jhBZW5iL2nTlO7KUfADg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 05:15, Matthew Wilcox wrote:
> On Tue, Mar 03, 2026 at 10:52:51AM +0800, liying3@sungrowpower.com wrote:
>> Hi Andrew,
>>
>> I found that a fix is required for this submission in branch 6.6.
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=a13b2b9b0b0b04612c7d81e3b3dfb485c5f7abc3 
> 
> Agreed, although your email should more properly have been directed to
> David and possibly Greg.  Are you going to submit a patch to fix this,
> or do you prefer that somebody else does it?
> 
>> Regarding the difference between branches 6.6 and 6.12, in branch 6.6, mmap_read_lock() and mmap_read_unlock() are called outside the migrate_to_node() function. 
>> Therefore, mmap_read_unlock(mm) should not be invoked inside migrate_to_node(); otherwise, it would result in a double unlock of the mm.
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 54f1b78d1b2c0f..94c74c594d102a 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1071,6 +1071,10 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
>> VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
>> vma = find_vma(mm, 0);
>> + if (unlikely(!vma)) {
>> + mmap_read_unlock(mm); // this line should be deleted
>> + return 0;
>> + }

Right, that unlock must go. Let me know if I should prepare a fix.

-- 
Cheers,

David

