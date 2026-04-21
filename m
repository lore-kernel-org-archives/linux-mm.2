Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A7CF89256
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A436B008A; Tue, 21 Apr 2026 06:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1E16B008C; Tue, 21 Apr 2026 06:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A346B0092; Tue, 21 Apr 2026 06:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 335876B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:52:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDFA15C73A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:52:30 +0000 (UTC)
X-FDA: 84682249260.10.EDA5259
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81BDAC0006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:52:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fPHBxCFQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NIpVhlJJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z8U+lhic;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=35EltkHD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776768748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3gtN4tIM+7Zabo3eLUtfRWVZsBOfY1ub/97nXRsLho=;
	b=P1sxyFHYFmwWmEg3dmZu5P7InajIGv4AKmF1c+RMlIYHnHeHWqbCk2IcAXj3MrVszMlEU2
	AWvpjtoakn7XO3KaZ9i1LFRsoH9DOrsPsPR2904OuRNI827XOm2YKCKcq6MX+2hxGm1F5S
	VQ9Xb8ccIwwSQRB1HplMbYvvTfG3edU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fPHBxCFQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NIpVhlJJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z8U+lhic;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=35EltkHD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776768748; a=rsa-sha256;
	cv=none;
	b=8h14SMXtnqy0KOTE76FNQ7n2FGBQzz32ryyhNO45OCyRcX0q/owqyQH7oQAEo5pHdl5qxV
	xb/EZi01pt5V/jK+WNxxIlr2g2lI8d4B/zvPvtOkd44toN0lr71yMCx5nYVg+WJZKnCWGb
	+ygSS9QND2mBwJMcic/tx6ChSlR649E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D182A5BD39;
	Tue, 21 Apr 2026 10:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776768747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3gtN4tIM+7Zabo3eLUtfRWVZsBOfY1ub/97nXRsLho=;
	b=fPHBxCFQmuqvT3K9fBbnhwvlP4adioWI7tZlRsU7aHqA0yNZvH+LlRExlLK1ZEsl7q+PBp
	fmj9vmxXoe1EVvqSpe/t91bjX7k3r4LdzSZcwAgrF8ZNXNqTR7+oDYHgg73/dVwkTP85+P
	vEFlP2NpHE6LG6Dvx6YZQpf5j1FpnGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776768747;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3gtN4tIM+7Zabo3eLUtfRWVZsBOfY1ub/97nXRsLho=;
	b=NIpVhlJJoRECmgBu3KTaMttkmDtEsp++VSUpPNLhPnPLKlC0NuU5n5i3M5f7eNPNHazDD7
	+RzKS4YjUjlmlTAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776768746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3gtN4tIM+7Zabo3eLUtfRWVZsBOfY1ub/97nXRsLho=;
	b=z8U+lhicZub+h3n8xRn0YFqk3zUtgA1BjiHkFAbvD/vI5rnW1DgtY4U+rSl/OfTyUC6sen
	iW9tjYucRHqvBc5uyPC7YGuxv46Ferp2CVfGC2F2ybYKr65xfwZ8qH64fqm4haYc/I4bXp
	xvJz6+qR0KtK4r+gQeKrsyBtaSJjPVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776768746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3gtN4tIM+7Zabo3eLUtfRWVZsBOfY1ub/97nXRsLho=;
	b=35EltkHDlys1Rxt9BncLbK8l0agI4wm5+YmKE8kESZX264eIFkfJdxjT8GU2qZ0+UEP/cK
	eM98LGZhO1jS65CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14E9C593AF;
	Tue, 21 Apr 2026 10:52:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gKjLAepW52l7cgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 21 Apr 2026 10:52:26 +0000
Date: Tue, 21 Apr 2026 11:52:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/vma: do not try to unmap a VMA if
 mmap_prepare() invoked from mmap()
Message-ID: <l7dsbewodomciockueakhd4d5ncxldhue7ysvs6n3aqbof2wys@revnmkomdpsy>
References: <20260421102150.189982-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421102150.189982-1-ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81BDAC0006
X-Stat-Signature: u6jyjfwbjkjp6by9b4szmjp6kixgka8b
X-HE-Tag: 1776768748-267127
X-HE-Meta: U2FsdGVkX19EIKcnboPulUff0jF2C5YwFZGsRij44stBeX3wVctcQBg5lCNEff8UR3YLLBenRMT/YLkt8WZycPVU9UrzEOjLySrDvIQMvdTXfCENleaggusPRoeqeL7TLh1kao3O13ClprEigERhr1G2LF/73PqxyARjMBScgMICUOmGdbcQK8T82eqvB9/ml8JfhvSoU8bTABx3GDwMqryf4eS60Vg+g2G+VZrx97EitdMD4H0ddy4DVvljqkypogR3ZvGAnJpEbqcZ1ROeCOPiMW7zhwv1Sms0yL6xsmaoC0q1xCl3gVOnekEWMOcdSJHXZFAU2SqPQ2hwWWY8+Gj7pxgNOQf0V66vVtg4HXSKuot13zurz7U2qIDXuDH5pcRFB497jmxXzj89OtvP64bB116c7XxPcpSPL+Dcdk5Jg/JmUImOCx1Hw9rT1v67QTe9lIgU73s+q7zP4avSCNrL5IHB2GWE6bx6XjEwKapQg6+SdEJQaEO96ZzK2jPTbUujEbVi/tuKOqLHZ4m3be93H65O/ExompHlZ3ZdnJ+kWOUdFv9euCppGN9bLSC4hyCDB0a9wvLmnJwuf1IbjdBBywsKb+OId5QVomcBHhyw2n0DubgjWKR7vKbKHVUNhb9CDbS7587Ama8YrttNZoiWF5Y9kbJkLlh/K57BlDsO1pwsqGivUFPEFfUKpiDAPtmkMmm3zliDBxOe1E3uVPfC69f8+xDJ+xKe6Hm0T4caHFWK7HdyGi0RFDnQBUKCVi6aCH3o/zipyLxGckZGrbXXRWJuEvtAd8bJEEyS9jNTfub6zs7MKSyib3f+znUhmAO4KJhR1oXHAgBJrE6f2wlYIZNTjcUQ8/VvSAm4eBsvlXfq1OEv/mwU9hmw5B7JSUFclGJic0qO8V9jeVCqyXyUVmUSRk+YknPx3JbglWI2PdCIAq8zZZq5HiE8jqFLpsaidx+s331E5Q6dq6X
 /AaFO1FI
 vvH5/Xb1dfzUHxGVOekxcuDoPvlGFlReX+fssTY1JorjqpWh9lPfEwz84KF2bsRta/MZ+GSfpgpRDqyNgVCbZsG07AXbY7n0VPOR2t7nAhsEVNPFKj5mFQ28Z/UCY4/p+GwWbaZA9F6JlVzwsNknlLio87XYPzWcxJ4cyTseLGAMSv0y7w8CZXHCBGQ8FJDJPGlFxRwC9T1ujX5EYjFnZmWl3vS76tLMwqznUHFqbdZ1c0s/Qci8+NnEapig3rbI3+UPfAhiA61D5O7ewIq76hirVdpQocfGk7XqCsvb4k6W5/zKeNa1f720kFw0CDwQUVn6LmdMjpJI9H7KlYrTRA9TJ//QE2OLYFUYM4sUwEiMz7cNihbe4gtUV35TurZqIl+04HCGHfsZLHbzeCu7mppSUCDQqT4QtVp5oszSfvrjiEbjuZGU6yeHb6TO3HLoqBdkaD9ta8YSbBbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 11:21:50AM +0100, Lorenzo Stoakes wrote:
> The mmap_prepare hook functionality includes the ability to invoke
> mmap_prepare() from the mmap() hook of existing 'stacked' drivers, that is
> ones which are capable of calling the mmap hooks of other drivers/file
> systems (e.g. overlayfs, shm).
> 
> As part of the mmap_prepare action functionality, we deal with errors by
> unmapping the VMA should one arise. This works in the usual mmap_prepare
> case, as we invoke this action at the last moment, when the VMA is
> established in the maple tree.
> 
> However, the mmap() hook passes a not-fully-established VMA pointer to the
> caller (which is the motivation behind the mmap_prepare() work), which is
> detached.
> 
> So attempting to unmap a VMA in this state will be problematic, with the
> most obvious symptom being a warning in vma_mark_detached(), because the
> VMA is already detached.
> 
> It's also unncessary - the mmap() handler will clean up the VMA on error.
> 
> So to fix this issue, this patch propagates whether or not an mmap action
> is being completed via the compatibility layer or directly.
> 
> If the former, then we do not attempt VMA cleanup, if the latter, then we
> do.
> 
> This patch also updates the userland VMA tests to reflect the change.
> 
> Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69e69734.050a0220.24bfd3.0027.GAE@google.com/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

How about something like the following:

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..c29165de6d5c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -868,6 +868,12 @@ struct mmap_action {
         * completely set up.
         */
        bool hide_from_rmap_until_complete :1;
+
+       /*
+        * Set if this mmap_action is part of compatibility with ->mmap().
+        * Internal flag.
+        */
+       bool compat_mmap :1;
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index 232c3930a662..5134f879566d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1229,6 +1229,7 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
        err = mmap_action_prepare(desc);
        if (err)
                return err;
+       desc->action.compat_mmap = 1;
        /* Update the VMA from the descriptor. */
        compat_set_vma_from_desc(vma, desc);
        /* Complete any specified mmap actions. */
@@ -1400,7 +1401,11 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
        /* do_munmap() might take rmap lock, so release if held. */
        maybe_rmap_unlock_action(vma, action);
-       if (!err)
+       /*
+        * If this is invoked from the compatibility layer, post-mmap() hook
+        * logic will handle cleanup for us.
+        */
+       if (!err || action->compat_mmap)
                return 0;
 
        /*


We have plenty of free bits in mmap_action and this is a little nicer than
passing is_compat bools down the callchain.

(that comment over compat_mmap is really... vague and bad, but I couldn't
think of something else)

-- 
Pedro

