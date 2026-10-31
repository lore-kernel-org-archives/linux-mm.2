Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C8C606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FdAdo72s
Received: by kanga.kvack.org (Postfix)
	id 9ABC46B05B7; Sat, 31 Oct 2026 06:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C2C6B05B8; Sat, 31 Oct 2026 06:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872366B05B9; Sat, 31 Oct 2026 06:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63A026B05B7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:55:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE1971608F9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:45 +0000 (UTC)
X-FDA: 85382615850.23.AE79666
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3E80540003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdAdo72s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793444144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zHOCVGlKd+Gbw9WkcwRAX9nfU8lVQAZb5r1Oq1ewkk=;
	b=69D+iGQSeASnZXZhJ/8RThmgr1itpNeYSlrIGf5Z1RhilSKroI3rvhVMgKAT+fpfeibDDp
	0PHzxL2ihyFhoqo8OwO9jkrKduPuptz0Zv5LiwQ7T1rt2nn5dy8EnIG86mBDVPuCeA8h8k
	PL/1XqoXFfLGVy/iTE+1cTTMZBFiSfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793444144;
	b=yU781MqfJRQQxwMKbJrCn7brOjHXRdhXR35jWnlRUN+Hc8jVwTkR4Q7IH3Oq0BDAT3Nbbe
	dDROmvfSgHv4ODQ/bDVK9RVuTFSffPCVZJIw2wQ0VxQpJxE8Yi+4l5pC70eN/14VsYAAcg
	QOLiVwiuaCzVyhKu3MHRHJvh+Ek6PTI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdAdo72s;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDFB43D9F;
	Sat, 31 Oct 2026 10:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF88D1F00A17;
	Sat, 31 Oct 2026 10:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793444143;
	bh=/zHOCVGlKd+Gbw9WkcwRAX9nfU8lVQAZb5r1Oq1ewkk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FdAdo72siP0pWKtPYHKtDnT3myBbO44Iwr2y7PQ+tvrQr16MRxsWBeogf0w1mEycX
	 F7KTXuXQz91GvFIZwzuFXxSVKD02xpOyrHOGApOiHCw0zx8OXrMxu3khaoylsQzd1m
	 xKaG+SRpDZHcgyg+l3ScfTlpQdzujaWDiHne2N8c4k9djSAqlQUdQDr7cy3uJ/lzeP
	 VMrODT4NtA6cATADzB73dBOSZfqgXIV6n2GgvQTDXcVIqnmhMNXHHgSV/nFteiftAi
	 fv9qjBDhYrKGwvHE3Y0MQhc0eXTV7uKkWuk+6b1W4Y91/zGSNhOl8gODnISQZyt8JJ
	 jjetI8m0mleMg==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
 jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hch@lst.de, pfalcato@suse.de, 
 ngocthang2710.1999@gmail.com, 
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, 
 stable@vger.kernel.org
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
References: <20261026152013.10511-1-lance.yang@linux.dev>
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
Message-Id: <179344413746.15514.3017134720155207012.b4-ty@b4>
Date: Sat, 31 Oct 2026 11:55:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E80540003
X-Stat-Signature: is411zpjj55piyi1pke3z5q7n6m5cagk
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793444144-968618
X-HE-Meta: U2FsdGVkX1+FU8+SNKgrRVvxkQ7qml4Kd4oEuqC1ruJZWBaDW6i72Mv7i7v2HY/sX5qGdvB8s6N7SNvnMzoRSiBD2MIFGbVwlwa8Zo73w+UoVJzua1zX8d/j38y2hWwLqahDhOvNTzXgm1DEnosvFkRgTEFDkG7+3uC8Ub2f2phvC7+LDkhGOhny0CogSwLLQiJEPDnuYL4V9ipAIlU5VHzOtZSdvvyN/RRoEgUX3ROMaI2suTacqL8ZhPxR14mnvoj6yVVO3tNOPhMHd/IaNjGLrj9vS2dSmtgvDf649CJXC2gGLQ10vpRXHuXbp8pUKYytVXpk+dTwMjnQNftk7J0mTqrLqUM+mCCnuQJr7CNSfsGrUF5tnDXNJ5GbEytaMml6ZRvwP7JIGkBqPwuPj8X0u6AorXP4CWVl+pKh/l2XN7g7s7UtXSl7LHv4iTXywtV/qPeKpIJ4gU+9NZymuaCQSswMVeevHov5DSGZP87N2P6SA3M8+TrCgNCUYW+mcy78kTkfKVEnrViNKZI13MYJXqz3KArWlAhvzixLYWme6OjgOswIrFW51r0bw3kbmjvisf+Iq+4Y1JBncnDUoWuj6c6olkaaZd9oJgwwhikN93mNQmvpZyyEpCRdV7yTFnKWK/8/BvfUP7mDEzEuV4jD44GcES+NTlaShZYuWK467PyzlOzKnvsoeALKrGvE4g8sys9AeqP/w1w9zandHudVqk/IYDToD5kLD9cN+Encz1+uYbEJ6BQEpBEWu2AwGVyElvy/LofdAXWu3IUGc4/1aAquipFwD4QsOScw6uENJMQPc+8iFFNPp4kQfiokBxkd7ZNNSdO7rl+LgWPCb3vzT61GThtUAH9zevaelaB4M3AGosIoubpXsc+4Pgu98Emj7VjoIOYfJzIRoIXSJL83KG9NgV8M5gGXXj+zK2JOF+28wr8E0I3AUKT+eJPZAYj2hwc4KWzS3/OgnpZ
 hu5vyJTv
 5iO/LlQ5ARICNVZnW2crMCbbpEkF7YD9e5Pxkxd2HfdLkcROFWJtAGQCF12IurEkDieeidPCoRlzMuuqNo4Ce4YmeqYn6nculpJvVkEnO19YzmeWAd+4WEXvx7MWWwI3XhE7JNGpMZvb2zigyLnWd5CHwCQ3xz1X93k+rX+uxG27lyNOTOBfdYe1S/KJ9EFNCraAdb3XX1EJPb1aLELCRO+J/W/ogLerkX0JrBJCl8t4x0s4rNtp2RQlxMzBqZc2nMSUdr+LrswNXfw0wTFLE2jVwxufzC8djH1PgY1TluFYgIBpyj7r4H5l+G1bk4SN/H5MJL6ayWtD7rorYBXL7xXJouDNCCXTo9G0os4Jm1Me3THosCldi9qqtuv0YSf+PK9YWuchMmWf3J9pNZLUZVgFQgonj0ZcneYNlIzpUdrurIoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 23:20:13 +0800, Lance Yang wrote:
> collapse_file() can call page_cache_sync_readahead() while still holding
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
> 
> We need to release those folio locks before starting readahead. On a page
> cache miss, roll back first, populate the collapse range, and retry once.
> Doing readahead after rollback avoids an extra pass when all folios are
> already present. If another miss occurs on retry, give up rather than keep
> retrying while truncate or reclaim removes folios.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] khugepaged: fix readahead lock inversion in collapse_file()
      https://git.kernel.org/mm/core/c/96995467

-- 
Cheers,

David


