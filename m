Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6388606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bteK92xW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eq1GcahI;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bteK92xW;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eq1GcahI
Received: by kanga.kvack.org (Postfix)
	id 67CE86B05BA; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E3E6B05BB; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF6C6B05BD; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155D86B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D81E7160617
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:11:41 +0000 (UTC)
X-FDA: 85427260002.08.A71D981
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9780A40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:11:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bteK92xW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eq1GcahI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bteK92xW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eq1GcahI;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LM8wBhNRNhOCG/pAJr6opW9xMvaqFILD9ZI28NtAf/s=;
	b=w9eJN40/x2eT0kDhTC+gjVgSTeob4vvqdkdM8YoJQKwMh/iXYd90Bra8XwxHge5/uIvVPz
	7UCpNBL73WlZro/3eXBRXJjZ+H1d4HtWQV/haMsFSqGhM3i2sXq8s3tjISv2JW1qjmCzL9
	+4isIsBsZmC6/7Cg8J0W6w62TofDrKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507100;
	b=Y3OfPvqwqC8XHJdKqdHfPlWVkuYpvD3pytJd0cAx84fPmYFNudk9/YM1je8Vnt89UwLtND
	cBFSohswdhz12EmeyPO+6CMF1/vZk+x+iseQtvGRNtMsvwv1Ml0ufE9i1n6mzDzEt4vxn6
	XDDwTgiwxxmh6yBmf3RoV2YsZyL7330=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bteK92xW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eq1GcahI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bteK92xW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eq1GcahI;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 278691F7CE;
	Thu, 12 Nov 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794507098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM8wBhNRNhOCG/pAJr6opW9xMvaqFILD9ZI28NtAf/s=;
	b=bteK92xWwILulLFJBTyYTeH+vD3loZ4YW1kYfR6l+JJ99ue9NkjEXtGZeIHk1dNko/8Iis
	McWYgxcY6IyJu9HnmoN+WHAkBPRTVK/2zW/ugqe7dncGOmBEWr/SZxNmE6ZSylRusUnU0w
	B6T847t9NH5kQyNpQZoMZF7aXF7dqzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794507098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM8wBhNRNhOCG/pAJr6opW9xMvaqFILD9ZI28NtAf/s=;
	b=eq1GcahIE8BIo3ZdgeXKet6VrbMMzZCM9cN5wbkl6zNBSjDCscd/CsJ9HG8MvHYUH4boqk
	XpEzWctmukEgEdAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794507098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM8wBhNRNhOCG/pAJr6opW9xMvaqFILD9ZI28NtAf/s=;
	b=bteK92xWwILulLFJBTyYTeH+vD3loZ4YW1kYfR6l+JJ99ue9NkjEXtGZeIHk1dNko/8Iis
	McWYgxcY6IyJu9HnmoN+WHAkBPRTVK/2zW/ugqe7dncGOmBEWr/SZxNmE6ZSylRusUnU0w
	B6T847t9NH5kQyNpQZoMZF7aXF7dqzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794507098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM8wBhNRNhOCG/pAJr6opW9xMvaqFILD9ZI28NtAf/s=;
	b=eq1GcahIE8BIo3ZdgeXKet6VrbMMzZCM9cN5wbkl6zNBSjDCscd/CsJ9HG8MvHYUH4boqk
	XpEzWctmukEgEdAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0349413432;
	Thu, 12 Nov 2026 18:11:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FXq8MFgB9mrpKQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 18:11:36 +0000
Date: Thu, 12 Nov 2026 18:11:35 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
Message-ID: <avYBFPhB46XWAG4A@pedro-suse.tail5790ac.ts.net>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9780A40003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 15pqhqckkboub5485s8n7couoohapaz5
X-Rspam-User: 
X-HE-Tag: 1794507099-77903
X-HE-Meta: U2FsdGVkX19d+QJERBVdGo+ORd7Lk75g/AQY4rv99xgc73EPI+nfHt+E19sk0N899rbWHFmB99vNEYM8NJurVbNwpDV1/wLOLkpAdLX7Vwj5eMWPF8N8s16ktJZXq71HR5pv3uk//od6d3sBzog7zqTLemEdevJHYvSLEAZkVIue+j/p1ontpNnZ4ubUOcfEz/kOUpHPuhaqfyzNosoH6Cgjg+qSLTrXa+etp26VrxnqCxSyBIneCjsXZyrWZTSPqa7E4Ne6YY5D40TYLo/kc7bQEzQqUcHUmF+KEBFKDmKCndBSne82LYk9e9NZNeO+FYv9jlrUr1KnPhSaxCMMb7R1DelRjbnTWynBGkUJvT3+8Pc1uVNmPjZQSSPVS4tIFiGuaVe8kJPl8oTpejOfx72pZ8GvnuwwJO0DXm/g1XuGVKp6XLv44A5FYso30Cg9xNopikCawUtYEEgpaKf0eywJaL4RQ+CakhstyJq5eaQ0VKhzKYSzLJcQkhrDvj50hhk+40mt0MFvElH2A7z+FzbiT+hRugVXGackZYN/Ywpm5g/5a2/1f6NLgY44Av7rWkWpD8uLDCyRPN0PyvskeQ1Lqh9AF/ttnWUB8jv4XuwFvVX1zsEpkvxnCmuJ6LJ4zkrE18RR1389EZxjsHhDFD5CtkYu5dJLrlu5wyGS334FynzIXC/+tYfx6sFJzKRsQHGfy1Cz84zwDfulqHmqucBXyPTAvlaBf8vfTz1eBNHTcLIR3ACz2xnPwI9XRv6oR99h6P7NafUwRhTpGscXgMp4/35BBF0tX/eBdWXSccKLeYBBjitKZQqEs/Tpdh2bE6U0UEFuf87eZ50jGEkoEVGnwYXxexm4L3bj9n9Ddn++R1iPNNWGqzijL4eBFMqqAmTqsbEDlHNS09fOFNlwmXNr8QLJuwQ3TiZV7BHKS1ZLcsYlhbPBDsbmf1f/HkhE+iOEXLasNRLqK+u3FUc
 WZku96zp
 ohRLcGFZRTNsD5wpY1Eqdo1ViEaj0rhWTTIlurdksjLqWyIrFyCY/rumsoY2ps2vkP30oWhdezXyvVgnlm12/yvWdKS7iUx1BehZAfAvsso6JvCW3/Aj4EGOYlDEqKbvQeIAbzUhHPHyw/nmoPk8VTUbShTl+Jf31bOvWbtut6yyJI9nGUPUasuG9HKEzERY/LKIIvI+vRDl6Y7lva5TWMUwOC+c6TzrZCVgKJ3nKOmSAcMeB3+pjcK6snYwGQC2uQ9o+9Y7l1CdXOEr0drF6MIxNrGLTYNB/Tg8UpqHUjbr/a2h/t2pJPsrshVClBw1ZWJRcr2GTIyKm0pWEumbJ0UuMW87cylYZXx4gKPv9NtpomHoC58QbVNm0ugeGv/iOariYu14y3lkCifXmrnuafwJMpVfBbTHX4gSWd7YWAE9owk8EOXWfE4+kOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 02:23:35PM +0000, Jérémy Jean wrote:
> MADV_COLLAPSE lets collapse_file() treat absent shmem pages as holes
> filled with zeros. It does not check i_size, which allows one present
> page to become a huge mapping that covers the whole collapse range,
> including pages beyond EOF. This makes those pages writable. A later
> file extension can expose their contents after F_SEAL_WRITE.
> 
> Hold inode i_rwsem in read mode while collapsing shmem so i_size
> cannot change. Reject a collapse if its page range extends past
> i_size rounded up to PAGE_SIZE. Keep i_size_read() outside the
> page-cache XArray lock because its 32-bit SMP reader is not IRQ
> safe.

I don't think this is an issue. shmem/tmpfs purposefully maps with large pages
across i_size, and collapsing across i_size is a feature, not a bug.

-- 
Pedro

