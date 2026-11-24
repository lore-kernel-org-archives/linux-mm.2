Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183B4606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg
Received: by kanga.kvack.org (Postfix)
	id 301DB6B06C7; Tue, 24 Nov 2026 08:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8EB6B06C9; Tue, 24 Nov 2026 08:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8CD6B06CA; Tue, 24 Nov 2026 08:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9C956B06C7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:11:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07EF5140B80
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:11:20 +0000 (UTC)
X-FDA: 85470048720.17.B6B7A15
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF4AB8000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:11:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeUYJByg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeUYJByg;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525878;
	b=i20/pZxx5Eb7y3PQUKaye/kYAbKTx/MIXse/ZxiSTOmhIjwwEMdoqmNO2Aaof4l1yN6Hl7
	MKeqW6QC4iWHk2goM4gLvnC7VoPXvkOTRXPMnObnHHUQf/pMfzXa6w0qQs5yNpiEFmMj+i
	7xf63b29Z2xLM4TjecgOocXbe4XECc4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=8Gu0h3vC/h7kv3+rXzq+ZEouhMa7zZJpmYBHfUt3vt6JkGJUfUWX+4R/YI17JTsdeTxDLp
	C6CR5+t7Fp8oXdK1dDZ9iyAfcdblTOhILtEY9PtI1ljEvCNUNzu9noUMIEFWO8tuiHzrom
	uWc3XvCtYWZ02e163r+C4FAvytUpGg0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeUYJByg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeUYJByg;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F40C21FDD;
	Tue, 24 Nov 2026 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=rb5wOvWbiiQFQufaaSQ6BhFGSvCEohd4nZR+CQo4KfMnxUX/jKgoquVwMwELJj2awY61aH
	siLKadWiKTIL8cEQ1IA5VX1COpvGbtTnMb/YwAc698svrqR3Ex6JetzQyK1eq26CquRo+x
	kTqpmWj4804vqch1ZhSuPS240hA90po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=EeUYJBygel5fY8HrGoffaBTuMuyzXz8uIOK6uwho7Wcybt9v6VWfU/4ukG+s5rFwn4sayM
	3KpicyNzRDxErmDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=rb5wOvWbiiQFQufaaSQ6BhFGSvCEohd4nZR+CQo4KfMnxUX/jKgoquVwMwELJj2awY61aH
	siLKadWiKTIL8cEQ1IA5VX1COpvGbtTnMb/YwAc698svrqR3Ex6JetzQyK1eq26CquRo+x
	kTqpmWj4804vqch1ZhSuPS240hA90po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=EeUYJBygel5fY8HrGoffaBTuMuyzXz8uIOK6uwho7Wcybt9v6VWfU/4ukG+s5rFwn4sayM
	3KpicyNzRDxErmDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 016BF13505;
	Tue, 24 Nov 2026 13:11:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Imu+MPOMBWvkMwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 13:11:15 +0000
Date: Tue, 24 Nov 2026 13:11:14 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yi Wen <shicenci@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [BUG] mm/gup: WARNING: mm/page-writeback.c:2678 at
 __folio_mark_dirty on v7.4-rc3
Message-ID: <awWMsf-5RMa-TdGu@pedro-suse.tail5790ac.ts.net>
References: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
 <f8cc1652-7577-4ace-97ed-081ecd65a031@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8cc1652-7577-4ace-97ed-081ecd65a031@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF4AB8000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: f8qsybhjsueoxiuaprwfhh4c4fmggr7s
X-HE-Tag: 1795525877-263390
X-HE-Meta: U2FsdGVkX19fvAP3E80QcCuE5PJA8TZRyumIiMW2g76CS39P382KuTjPeeb1YBxtDfaqUBNpUD+SV4LRjC6u9WKlK3eIk6+rtuxa6you+JEfOFIiQjw+5dRCPLbMMRNVNNnaRT/wj6AynzdQ3y2/G2LR1SNZ6GxS5PIvPMRVsOJnptb9Emsq7PxvpRexIPBjnJ/Zf752zzP3jVNGiFziePqpi/8u1PLjlk5JBiknP5hyE/22iFCFnAauFy2KmUpyxjqBFXe+xXrWPmRFdTTj7iQhuefoP7I5YfcX9ICwePkM7QEqk480B7dm2IO/dZpNFcBbqjXxp8pUjYcAUoIr7MCud7vb2fK850RWRSQLTYhHuqRqR156a4tGiMv9jQmcRLM+qO8mT7vtvPVctyfibKH7XhxiOEMU7/3ws+VRu98znkg+Vc5z3CO1CGgfh2KbT5WqJjSfWCsTTnkuuyTpJMIzC93EFfxlOCnB+EPxSdjeFCGadvTVJqwD9OYb36oIMUm1uHpwoDEuzMBXcs+m+1qhI/3+O0SROV0c9ToSKUE3ucIeKQAWW8W4TerOhAVzEizD+vM4g23y4cW9anwdBxkH74Hj1Rbv7yg18KDqa0JkqlcD30H3ADujbWgv2cCXACMCUheQENUa/POgXNPRhqggGA311FGfPY2yNpUiblayCpH8Ehr8LlmrVU090hv8UZzPDPQ/f5/al5SV7xFzEooHAoVzlcveBlLotJVKIZbut/PlYmo6rt2PuMQnEWfEGzyAWPSUkXqegKveImyF0P5UdTYsi1oPTpC6huSdG4SFj0aFL0iZUMucZD4rNgySQgzuBmgWho9Pqr6FNhe+1G7NyU+9R0fR8m/798MVxaI7pj/MLvxHW+0XICqMakWLk91TqfBT/zzt6oxg4GQjVqgx0zxZ73cLSzxNgiI9mWNIebNKLSD053mlONZEESUsyZo1ZiDZqqGgtwO7j7G
 AgusrxiP
 MnJ4XALHziY04cf/6r0EbJTiAEoisqdsVPPkM4/bDMG9fwsIcn+FXeEiuylCPhZsjfGJ79XnA3djK5tUDD7GFSU2zKUWoK8hqun58UH8CURARUJ9dAUI2QLRj4K4NWayFAZoF6qUhIq/ZczjFKOm7LUacQ9OIInn2iaEmkwvOJSTSfcFUSncvOcDTC5Ezn9dwMZJjI1EJKPvuXSAUO6hGc5+ZFwKADmMoG/6J/v1gDK7F7QY1YqcabtiQq7aupJZafGaAE/B73zPmNjxQCYaqfxJE5F+2OoiJa+GKtWJol8irwv4t8BL7K2KBmZqyL1yhtq8wFOFMc5SPDbSHCm2rBycvcbVc2LLVCYRfu+UDD0aODXwyXGh7GvzcYNLF3qUhGAJfdoE/AHXve6i614YTpmCaj/VqSee8+9K+onas/za5dOBi7siFx9xlT4dfuOz2TBPsFvSDqQo2fpK6NGWS4DbXjP5ALLooKXEyIJjDkxNWjv31f3EtDFsKQ71fxeG+moGQtjv4HUaIR+Kza07H/70qv3wmY5rLV/VehwnlGQem+rDCV3sxS2olpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 05:44:34PM +0100, David Hildenbrand (Arm) wrote:
> On 11/21/26 15:49, Yi Wen wrote:
> > Hi,
> > 
> > I am reporting a kernel WARNING triggered by a syzkaller reproducer on
> > Linux v7.4-rc3.
> > 
> > The reproducer triggers a WARNING in ext4_dirty_folio() when
> > process_vm_writev() writes to a file-backed mapping.
> > 
> > The call trace shows that the warning occurs during the GUP page
> > unpinning and dirtying path:
> > 
> > process_vm_writev()
> >   -> process_vm_rw_core()
> >     -> unpin_user_pages_dirty_lock()
> >       -> folio_mark_dirty()
> >         -> ext4_dirty_folio()
> > 
> > A second WARNING is subsequently triggered in __folio_mark_dirty() in
> > mm/page-writeback.c.
> > 
> > This appears to be related to the interaction between GUP-based page
> > dirtying and filesystem-managed folio metadata. In particular, the GUP
> > dirtying path may mark a file-backed folio dirty without ensuring that
> > the filesystem-specific metadata required by its dirty_folio()
> > implementation remains available.
> > 
> > This may be related to the known issue where GUP-based page dirtying
> > does not properly notify the filesystem through page_mkwrite(), as
> > well as the interaction between GUP dirtying and
> > filemap_release_folio().
> > 
> > Before these warnings, all four ext4 loop devices also report delayed
> > block allocation errors and abnormal free block accounting. These
> > errors may indicate an additional filesystem inconsistency and are
> > included in the console log for further investigation.
> > 
> 
> Hi,
> 
> thanks for the report.
> 
> Did you only find this through syzcaller or by the help of an LLM?
> 
> I'm asking because the timing is interesting; this should be one of the problems
> discussed by:
> 
> https://lore.kernel.org/r/20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de
> 
> CCing Pedro, John und Jan.

Yep, looks likely to be the same bug.

-- 
Pedro

