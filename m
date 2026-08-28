Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E57C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003166B008C; Fri, 28 Aug 2026 05:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D066B009B; Fri, 28 Aug 2026 05:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32546B009D; Fri, 28 Aug 2026 05:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B677A6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:32:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3192E12028B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:32:53 +0000 (UTC)
X-FDA: 85150163826.05.0A0D008
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id E50D71A000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PniMmFJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8sVJ1KjS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kTSiorrN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VTaz6Xjw;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgD4uvRdDUFrpJt2ev8YwoEx5lfmYjGKQqm35w/+pZc=;
	b=L15++K6dwtJ5qmPXXfnnnhUb2G8LLBj9CFeF0O7fvw/Wik71vx0laegWy+udh5ou3uDLIo
	jDM4GKRmUJD/zkkZu8MFPWKjiftLC5ZZJ3ve3+M/zTo3YE7EMTGrkv/VaoQsv+P9ulQX7Z
	SWHRp/P80X91lXF5UDiacuYkLAj6gv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909571;
	b=OjbkIT//4hEXd+IKW6Rl/TR4fkdGgXaDAAULLDs6n2oAJ0kZoI68NLMQ196dlHbZAk1d3k
	HPZ0J2+ZpXV6GPkcIV9AKr+UfYtPryImzd4jqIRVUniTy+fe3D2dGegmIpmUTJh4khbkna
	7X2dSXPLWlqG304Rp8t2AbIIaqf/QMY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PniMmFJv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8sVJ1KjS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kTSiorrN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VTaz6Xjw;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D08221A1D;
	Fri, 28 Aug 2026 09:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787909565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgD4uvRdDUFrpJt2ev8YwoEx5lfmYjGKQqm35w/+pZc=;
	b=PniMmFJvbBWMOSUzyIu74H5LwfS4SoBfjqrmWYCEkoTQL1lpMY/7KDceWmMaN8VztZwMsv
	79XH1+c8v0As/6msTEgnHK46PxaPgaZDcbdxhcLMXoTwn8RZEy0710RnpEDSavJ4vegqy4
	PTYJeSudP99cvU5cMMbrNe1dCGgnemI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787909565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgD4uvRdDUFrpJt2ev8YwoEx5lfmYjGKQqm35w/+pZc=;
	b=8sVJ1KjS824fh2nDBL6d4F9d5Zmkf4UsSiMG1U9Xk/Hi3wzpquHttw88DC3NsiUsT3wNGh
	5NvM9xj/3ecJHcCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787909561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgD4uvRdDUFrpJt2ev8YwoEx5lfmYjGKQqm35w/+pZc=;
	b=kTSiorrNolSn9CdCRNBBzqCEw3NqscL2CL5g8yMtN+xFntmYy6OPg4mX9yfvynKiDyD9Qv
	KQshuvx12joi5khK73EJN1rpGqBhl97b/IZrL8qPQwwyS3Klt8WpSoxO9Bb+Mn/AnF+rrV
	pms6jDfUqS9Jp1O9q+yLrdNMAVP7rI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787909561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgD4uvRdDUFrpJt2ev8YwoEx5lfmYjGKQqm35w/+pZc=;
	b=VTaz6Xjwb1tAgmUGp1INxPxHF4fam0Z0QZgjAQ3ImSkcSFj5x+cRBYSm96KWw1vDP+LsMG
	4BRnLzWFUoD7jRAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C82913515;
	Fri, 28 Aug 2026 09:32:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1K6+DrlVkWp/fAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 28 Aug 2026 09:32:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C6330A1324; Fri, 28 Aug 2026 11:32:36 +0200 (CEST)
Date: Fri, 28 Aug 2026 11:32:36 +0200
From: Jan Kara <jack@suse.cz>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Jan Kara <jack@suse.com>, falemi@asu.edu, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] quota: NULL function pointer call in dquot_acquire() with
 QFMT_SHMEM
Message-ID: <mdwzyxkmqvtf2ogc3uenosrtbyw72eyqvtg4ik6oiolqit4gku@3bjag4lb73g3>
References: <CA+0ovChCRKkAga2sWaNCZms8Hv=2+5gSpQfkaN0eePs7eWPXrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovChCRKkAga2sWaNCZms8Hv=2+5gSpQfkaN0eePs7eWPXrg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E50D71A000A
X-Stat-Signature: jizqpn7iao15i8sbxkry75op5c58ydm4
X-HE-Tag: 1787909570-630715
X-HE-Meta: U2FsdGVkX195CQb9vRf/c3RxqYdoHgjFAY20XbaSXQbMMUmIJyBmvJeHCYt0L+j0/idToG0t4swPYu+vevujKXsaUPX2cyzCQMjYzPa7wJnYkf/1OX2YhVjzJwzzvOB47rQE2Fb/ERVo0DyhvE8im0+afFX4xqA0wd8iJwByuA4O5E6ODVXX4txocMlwwjoGCUfz8XX2LPWAfa8fiaBGhTZDL+BaseA3T2x6+XeLQaZaV5vR0S3f6qcms2U5SW1Rcafqx3LPPgnxAAbKD9XYSFz/otRDRqv2JQABGQmzSpBX8XIQvq0LFgjnhXyPNSAPO6JmcietmbU/pCXOlb97NHRn/CPz+nTWb03geL8Ev0j0pJhlTfFyAkkTzHSJv51PT95NeurWA6PzgYG2OdOwx4WLY8n2P0ZRvqGqzB1Zp1RH6IQD8Z5TpNDINGR0Zd0N8eaoxQ7rEMxlZJB2w2tdY//h4LFskCVcO7JBQV7iYacbY8rEneV4BEy6KAx+wtQ4DbgHZawOQIWKuZbZXCQ3vdV7CX+B9aY8r3iEBeDG3+r7gL3g03QnSBVnw3pbmDVSczH+d36TUiIZwsLi6HGbEwDq7+n6gtK9yuFZAekqLGqC97vYPxeCvNIrNS6gl1K0GMOwhDuraiO4cB8Z813EZXy3Hve/izqb67eqeHNy0PDbTnHI/r68UlkhGyLkot2StM2Uyco9H5lDnvnlnUkZusuPlVEil6WnyszjHKVsk7rer9BL5CkAEBf0Mie3u2m4zNrS/M15+icOrR8/1yf6l3yUiWH+eTUPu8ZxEN4WvzPALqsJRJTbzLmBAKs0jTwd6yNJhH1xfTv703qJBmVr83KcGBNBwslhbAMdb3nPEitp2ihv+2Ndn6wt1qKvqH1UHvH6qzUw5KT1dWiCC5F6jlOMc0tYnB/zORYxrMUi+PYELvldikQmHe6wsp2EZZctpUaITLF4sPDd5j159H3
 PkSd3RzT
 8QtDy0ZMEl1gzEATJOhsQ10+Jkrow1a/M5XszH2gY6Oy7EBOSuFmqCrZsEDjAivcVO9kzWPIre9uqQhAHReYGyDHk8F5ogB0Q7K0cRJZ3rw7YlezcbVQtNgeP+IpsZBIGskh9lb3GMdvaetUEBZ7co2MQkIkq5uS+NOc1b3g7c7eMG8Puc3OHHNxWTzAbKxq6G9ORPOQlV/BCewQ3ItwP79LUVf1kX5/7t/owVEoR3Gq6uGHAN/Sqm3Ta7oa7RdS2bDPLg4fyu5OqgZuMiLbshjGE9UPB4SBtnLUaFj7p0i4guBWWBmlggPTA1LnT6Kr5+9X6PtindJXnoepE9eRlJhn7hsJ6L9zS2CAtsLNQr3qo8lRDfUnGHsznOlXh+eJQ3kdHcyrrkruyzds+BXAWQOHQeEYcdfZkHYjZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Thu 27-08-26 15:35:52, Farhad Alemi wrote:
> While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
> SEFCOM lab, we hit the crash below. Crash reports can be found here:
> 
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/103-quota-null-func-ptr-dquot_acquire/
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor instruction fetch in kernel mode
>   RIP: 0010:0x0
>   dquot_acquire+0x175/0x610 fs/quota/dquot.c:489
>   dqget+0x795/0xed0 fs/quota/dquot.c:1002
>   __dquot_initialize+0x3ba/0xc60 fs/quota/dquot.c:1530
>   add_dquot_ref+0x2ca/0x3a0 fs/quota/dquot.c:1073
>   dquot_load_quota_sb+0x873/0xb40 fs/quota/dquot.c:2496
>   jfs_quota_on+0x2a/0x110 fs/jfs/super.c:803

Can you send me the reproducer please? I suspect I know what's going on and
it should be obvious from it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

