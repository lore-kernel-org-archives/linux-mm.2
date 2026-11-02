Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2273F606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cDqlMQ6/;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cDqlMQ6/
Received: by kanga.kvack.org (Postfix)
	id 2F6116B00EF; Mon,  2 Nov 2026 05:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6A96B05B1; Mon,  2 Nov 2026 05:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195D26B05B8; Mon,  2 Nov 2026 05:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC6546B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:36:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 801C080BEF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:36:09 +0000 (UTC)
X-FDA: 85389824058.02.BBB4B57
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 73415C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:36:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cDqlMQ6/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cDqlMQ6/";
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793615767;
	b=MaivgCobVeZ6uICqZ0YImWUSDp5rKD5025N5ZgWMuzr83cOU8wGwHIZc6EAFaF6G1dDiQg
	KncvIwxexjBO9DIz15mG2IfimjsqCaDiB0+Xa4wtjud+86i1KRAkGbW3JAz9O5QHyYjcKj
	l3mAVLRAZDYM1ML1sCpDGusF+Ge+c+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793615767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRhzeJj1YK8/7h9dIIOem89RRPtC49dqxALnXhljlDo=;
	b=qk61oNQWFJa1TWSCoESEv0XTji3k8WaduMg7rf8xmOd38QAl7YcDc87CQP9g+u4jz5asll
	OjzHvetxScWljin5SJ0rOJvKi0oN0TWrd4ldLx9zDcHW3Q1HdOQ7gWzFCMSvar63Zw49pB
	0Zoni86lnBDvS/tu3vlSMpLD0XnKgQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cDqlMQ6/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n4K1m0W4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cDqlMQ6/";
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 154E121F64;
	Mon,  2 Nov 2026 10:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793615766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRhzeJj1YK8/7h9dIIOem89RRPtC49dqxALnXhljlDo=;
	b=n4K1m0W4gEt+08pZ/ke7ocpeaWfykHo95r7XJVroWkyjbiT4hlZ8tSZkZ2CW8G+0uB/pcD
	Aso+EIUrHnHFdEysbLOTX6wVNdgNWeaoy4+l/tktODMKf5ksKAxcl7dTaQgfNTRiPn3agK
	MpkvITq2jcJNlb4zq4Kk8RL96nTyZNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793615766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRhzeJj1YK8/7h9dIIOem89RRPtC49dqxALnXhljlDo=;
	b=cDqlMQ6/px5ct/Lw6LJDpmI34aSvq3eKoIaCh8tYokTGUyPVgmMIL91f/zDsWFcoQRneaN
	BGawnmfF710E+uDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793615766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRhzeJj1YK8/7h9dIIOem89RRPtC49dqxALnXhljlDo=;
	b=n4K1m0W4gEt+08pZ/ke7ocpeaWfykHo95r7XJVroWkyjbiT4hlZ8tSZkZ2CW8G+0uB/pcD
	Aso+EIUrHnHFdEysbLOTX6wVNdgNWeaoy4+l/tktODMKf5ksKAxcl7dTaQgfNTRiPn3agK
	MpkvITq2jcJNlb4zq4Kk8RL96nTyZNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793615766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TRhzeJj1YK8/7h9dIIOem89RRPtC49dqxALnXhljlDo=;
	b=cDqlMQ6/px5ct/Lw6LJDpmI34aSvq3eKoIaCh8tYokTGUyPVgmMIL91f/zDsWFcoQRneaN
	BGawnmfF710E+uDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22684134B8;
	Mon,  2 Nov 2026 10:36:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p7mnOJRn6GrtOwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 02 Nov 2026 10:36:05 +0000
Date: Mon, 2 Nov 2026 10:36:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com, 
	Songsen Yang <yangsongsen@insta360.com>
Subject: Re: [PATCH] mm/vma: read anon_vma carefully in validate_mm()
Message-ID: <auhnfQg8aS30V70B@pedro-suse.tail5790ac.ts.net>
References: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Stat-Signature: 67eumb1u33y8nwp85korr4pxf33g6yqj
X-Rspamd-Queue-Id: 73415C0005
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793615767-532830
X-HE-Meta: U2FsdGVkX1+9BfvcctKkgTRiiAWs1f0lvjmg/+jtPTJQTpx6ORFwIqxoXpVJQ2r8L/D2MlKcQzQPcqLDIcu5r/hTe8nqhByKPQHmTWSIKagEF7jWkYi1mPGskW95D/KiXzR7mTJtnwwFq8qFtgvoLkKKfh37lPA7bK74rEIUxGtLu/+3kR+CjIcasYognPB104JNx3Hy8VFlsVwbjgFot0WeNh3YefB9Z8FRNVB4W2afOMirsMe0kPmBYI7tJZelNKhczuJcc5jtM3BX48XQXImmeHArQeMOjBtM1tIpBMzXwqMs+iMmPxH8rCrAEioPHbmsp2+gT+P2uznciMRctONbE3kjLDFeaff+1v3hk2Hj0LsbrVEa45ZbcN/XgiUTzrni0QXFX+uZt7xMpSzUoKstfQWNdGzdamEvGI4AgUxYQvOV70QXcrynkincOVMb9xGIrH6+hYZQN2CyhxjnnqDLXVoCGDPjLQnEBbzTQj9XAo6kok2p6sW8PzFOMVwsiT2cRbSXY2cOmN47jTuST40Ecm4kEhFk3YcLb//6f1us7IID0iZHmK7TDPfqBeByU6R3i06co/zZk9ZkdpoSFMj0Lq0vUhLTeA8Vt7Js1iJbGkYHzywcRjLw+v8l4yl7EkvYFPlWGSOO/9WynCBOn35ZQkukZKxB2y0ejXPbF5McsQn9Fcmet7pAmWS17gTCMIURqmmgS15H3gh7g8wK1MOFYol7Pu10LdnM10D0+umGS6SWQwy6TKdCs4GBymPpZ68I+aA8zDMTgmyynMfJibT/wxy+x8k0nPIes4X6l069qjDbeQ554dzWfYGQgwKUNdWnmne5k1OAMnM+vc6P4oYFmMPJYpZr3T3WYrQiPeFPYhXX0p94HOUkT3+ZaK9kKOADs1bGpB6HJj5v6PkuOharWCudCrROj26qJeI7srt1zGbLMx3tLIi/T9pkhohrZ0AVWk889zxZ+t497t4
 9bKVC2BO
 jcWiRLBcp9XYizxZseiHaxp0zvnix1dcRLOf4TdWWgQTxzeX+Z0XubrsI0ECrjBDdgujsElYyghFLOjpfNn5q7xE6fKTS+gBEVzxUKfdMqQquxmJ6RRADgI5gM/iW3Kxeh9W6ZJK+krFQg+PEwknOr1HOzt+Yr7NA8SHW8EUU8g3bP7J/XP8zfjLP67PqH3c2lpovOdQTBlJx+fcPje5RolwONXAd7DP7uHJgDi3ARfWuJvBrGVvg3ypDOWv0sZBhe4+U70GCcN1iTTDDrCEdhT8kMgGMdrxrmNRRkDUL6n4TmUbs87H0G8M+Vs5LbXgY3C87VbADCa9BaXCkoECbB1fOi5z0NQUcsy49kad3rxrY2Ib4xkBMoJK/AYU5LWC+tQz0mGnnH2WdAS3foyTZVQTW5eWYE5KdM9CNjvBgQfrpqUuw0qYW73pBPxHxQQ4lMXIOQ7APKJWfK7ns1A0wjAg3vmWJqNcuq41ru8F8i6cjTppk8K7wMuKiPh5cNE0hpBY9Tsm1ZFO4y1DYHThICDkIN8/QzzlG4YxdnSJeoftexTVIy3WpeTxoNK2kjN4Vt+ePBCpJZwnp/ipa5o3iQzDWD1Qwjl7MJ1lh2Cekqne6ERfL4qnFeYRnkwYtbws0jfFUAvYluHlxJexQAGv1hd5I1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:25:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> Commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence
> KCSAN") rather clumsily converted the read of vma->anon_vma into a
> vma_has_anon_rmap() without accounting for the separation between
> assignment of anon_vma and later use of it.
> 
> vma_has_anon_rmap() is intended as an optimistic check, so doesn't need to
> protect against a torn read in vma->anon_vma. The caller is expected to
> take care of this themselves if they then in fact access the field.
> 
> validate_mm() does indeed then reference the field, so resolve the issue
> via READ_ONCE(), and simplify the code by separating this into a new
> function validate_mm_anon_rmap().
> 
> Finally, add a vma_assert_stabilised() to make it clear the required state
> of the VMA.
> 
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
> Reported-by: Songsen Yang <yangsongsen@insta360.com>
> Closes: https://lore.kernel.org/all/20261102074414.10902-1-yangsongsen@insta360.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

