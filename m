Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D33C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2B66B009E; Tue, 22 Sep 2026 07:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A296B00A0; Tue, 22 Sep 2026 07:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71146B009E; Tue, 22 Sep 2026 07:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF8076B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:58:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5005D1A0444
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:58:22 +0000 (UTC)
X-FDA: 85241250444.29.3F97F72
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1F8810000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:58:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gazFT6eY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zWCSQ9yM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cMOiS9+R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MFkt+T3/";
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790078300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=G/9TVw5JfAjkeyLKERIF7iFilF2Y/JN1sm+M9QyW7dZS18MdJ42QOUCz7ZA1ouqOTi52AF
	s8VX/ShQulvEPgkOdU9IpUMbwOoud5hoYDsabc331Y81AJzH+whPymyu1KL1Wt09ZGo/YC
	FLRnMHzTF9/LtEkKYpNATtNaXZ5Tpcg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gazFT6eY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zWCSQ9yM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cMOiS9+R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MFkt+T3/";
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790078300;
	b=zq5QGBr89oATP/k9STcwXVfmEIsOYxKQvyom+i6qKtGoTDeUtchl4vR/iaUpLClmK0WCTp
	PDZMjlAuw0mMF1S9n6vsQ8lSFOstJrEebaZ14FDY3mIOIhOfTDRsyb2XoPUtclitnz2uLJ
	RjX492Vnfd8hpeSeoGGkVKmWG84Dn7c=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 582751F8BB;
	Tue, 22 Sep 2026 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790078294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=gazFT6eY13Mktjea8t6HM5a4SvQjeV6lOHma/4K/R/ZFwIfhz3ZAyuWYyvaPknMeUScZF+
	lqB8wQCGUpzS4VOyHBI1ecpj+JHlop0iE/fIFeHyUv3klpb7CzJkInh85gGVXA++Mh6Js5
	iljlt/xU5V+Ef92ZJUkD4V6V7gvKPgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790078294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=zWCSQ9yMb8y6mLbUr2/cBizsUF9mPWCnPDfllS7SrVmnBJGK7kbATORkpLIyrCUXjjBteY
	pfVp7DcchsmednCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790078290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=cMOiS9+RwzmVOKWc9qNCrjflKetvpYcuFhb4CqsQVskyr7iLKgcyvHtm+tzQw4//fWa8V8
	77bKGmjhPP7IovphrATm9qvlnSK1kFjfW73ctVoOKKua/i8CkJHzH4PFZys/QlPrx4imo9
	xpL7eStPjOyiXh9+Z3Wzm/jmglStc5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790078290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=MFkt+T3/1Y8X21Exqc3tyExQ0YsfZs299hCHyCrdSI9ATPNpgIA6tWx+8bYUh850iu85FM
	BoNh4WaxKrcOMGAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B396132D3;
	Tue, 22 Sep 2026 11:58:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OwJ4AlJtsmqODwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:58:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ACEEEA13D4; Tue, 22 Sep 2026 13:58:09 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:58:09 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Message-ID: <5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1F8810000B
X-Stat-Signature: yrd3xzb5mihoauucyuhzkrgte4ymqtou
X-Rspam-User: 
X-HE-Tag: 1790078299-941251
X-HE-Meta: U2FsdGVkX195nSfddX0mU577+MmfUElf93t7b1oSR6Bu80IFSVYhZx1t5Zf0jPizIk3nDa16SlrEKF5D2vSddidKU24tiOsMJX0V9Jir91voZ7AEDGBwgPbBCzVoy+nyjvwtSfSb1padGaGT1cl6EJN+nKMdEV9QuaatJCkyPTJ8eYVQpJ1yGb65hMJitQF1FRGXINfctzeSJTpWvOZe9UU5/LASxRWfo2IkscpPCMK4TTTM6PExNRz/9aEUxVEz7VIW5YWAyHPSH4nOzt3fTE0LI7L0rhnnUCMt0fsMvL0zI7HpfP77v5oZM45nrJLOjp2BRcSgHoN9Rp8YKroPsX8mWUd07txGL1IbREDrdxrtFdOkFko51mu0sSFYOUGWbL8QkuP5iJ4NSMM/601ecN6SNrUNl22NqDlK652UaB3nsRLScRHEx8H3Kl4T9JmpjHaYGaD9SCAKNGTsPjzJ0ykyODlZcblGWrXmAo08IEZ7dd/yo+bBkoOcQPeyeEXbWOu9bRnXcLPjaesqm/C3VSIeB3u1o2owWc6qPi/JIo9fIa5GASPejtMkDgkkz286WOj20kecOMBTv/Q5Pe2XAjR9ansrOhZgM+h9y7qTlrri4cuuNR60M7Z96Rtge2FVj5JpMDOIi2J7+WwkZ0cCdi0J64FHCd2jya1CHdN4q4wm5jgb5rZIr9rYAqXKkAK0qfhw9wwwiHJT5yE4+hmyhK7foF8HrAlHK5rH5H6XSKjiAIWKQ34NWf8fRWAA3M7h38hX3DENXoQNgqBzlQSiwmJ/GKqlLFHl2dBW7qrXfnxXfbafK60dR/yeJ+CazZEQ81zwEKqe7oJ/TWgj7v9kHcMf1mUlA/FtBT+71c5YuTttpGbuD0ht6qiCzGmum3UOgipaGBCZSK58WF2wGORkv7ob42jGPYdLlf/zPlJYqLQy912qwey7haDYL2baAMO6oAqEqPWGXJpfSMOvCCt
 SkSNxR2R
 GXP4l0VEaYYxuvqktS32JyGLTQzHRHeddt0a9P2tVBPgn0T6ltYrcZJDd4tZrlSf0Pz//PaS6AfI7V4PI7UyzWNMrxUP3ffjP7vJbeQzmV+EEN6KajGB8F+lzzVrGB3B8v7U28hJtorxdzXiRxlaNi/Q25Zmz5ObnkroL/QiIETX+O7ad9m9ENvGqaUkKmoJ/NZg6ihL5txu4Cgz8xZzQfubA9TUqQyQZPgcEt2AMRQVVkLSkeqb+1pkEkNH8K5MHLZufsLbmyqFIFod8GtpJM+7Jg9lR0iv6H6HAVLeP3RqIAwGcvsseAiUhYJLR8CPUQ1Nr82wPXrwM7319CW4XIIWVx1ihaIh91CrqHd9uYMAT5KpspW1+TPpcQ73zG/si27TLV8ZxT2kisvkntvOFFbt3jXuCgl0tgtT+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 19:07:03, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> With the earlier rework the callers no longer rely on the return value
> of truncate_inode_partial_folio() to decide whether to adjust the
> truncation range. The pstart/pend out-parameters carry that information
> instead. The callers now only use the return value as a flag indicating
> whether the loop should be reset to pick up newly split sub-folios on
> the shmem path.
> 
> Return true if at least one split succeeded, and false otherwise.
> This clarifies the existing confusing return value semantics.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just as I'm checking the only use of the return value of
truncate_inode_partial_folio() in shmem_undo_range(), the code there looks
fishy. It does:

        } else if (truncate_inode_partial_folio(folio, lstart, lend)) {
                /*
                 * If we split a page, reset the loop so
                 * that we pick up the new sub pages.
                 * Otherwise the THP was entirely
                 * dropped or the target range was
                 * zeroed, so just continue the loop as
                 * is.
                 */
                if (!folio_test_large(folio)) {
                        folio_unlock(folio);
                        index = start;
                        break;
                }
        }

However if folio was say order-2 (4 pages), lstart is inside the 3rd page,
then the split done by truncate_inode_partial_folio() can result in order-1
folio, and two order-0 folios. Hence the !folio_test_large(folio) check
fails and we won't pickup the new smaller folios so that we can free the
4th one... So I think we need to unconditionally reset the loop if
truncate_inode_partial_folio() returned true.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

