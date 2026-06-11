Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7192CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115076B0005; Thu, 11 Jun 2026 08:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C57B6B0096; Thu, 11 Jun 2026 08:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DCD6B0098; Thu, 11 Jun 2026 08:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE2546B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:01:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CCF11C24D2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:01:43 +0000 (UTC)
X-FDA: 84867492486.12.D315017
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D5A6B8001F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:01:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUPT9KJF;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781179301;
	b=R/Of0Hiap3vstk4ETSMEcGXhP63XGg2rcojt/p/mdlNnrfR7OzaNuuadLbfE7n2Rbq/jTp
	4adUfFrSHhlpDCXZgxph1w8QTvYTsDXEuejrGTjh7unk/+tvfM8/xscWdFecPPz30BikHi
	EvcdqR7pIkUkw9SSylTZvuK/xVqe2O4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUPT9KJF;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781179301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HH5VtNr2KT+68fL1jugLmwwkhnImVC0Sb5WzuYdHcBw=;
	b=FkA412MgOgrJGttgWAS+3Lzjdjd5LRhuOqeJ0OGutq0wW0JTXua06GNU897kxbfeJxEyPG
	Rm6elywzr/2DKCwj49i+6xK1RVL8tRbyyAPfxA7c+gUfPr+O+pnGOZvMSYi4bG0lcK+uss
	u1VkJfvy8Y32UB8c8Za8MZtXGBL9z4o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52384600B0;
	Thu, 11 Jun 2026 12:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B501F00893;
	Thu, 11 Jun 2026 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179301;
	bh=HH5VtNr2KT+68fL1jugLmwwkhnImVC0Sb5WzuYdHcBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUPT9KJF2Gly/lJageiBR5OS+ZsSCltsXDAWTqNgnjDvRXpNw6VROiYW4xMsf4Nfz
	 zlkPMmkEKXvzpCSeT1Q+Vt2z26rP+5AsqV987kmlh26TsPaoDh/qcDDjaeS2mApyVf
	 LlWnRQ4otUasQ16KJiDnuYX+4unwZ/hLpQ97mdkbBi9PPEp3FxHBiB2IQxlNcnfImk
	 thAwEMXBVmmxLWhu5elHFtcI2QfxWCc4bmlDjgVhYTuUhS+Ynpadpw2L1JxhJbnZ5t
	 +P4ZjjljRfEkBaN7YtDyw6RImW1RLetIFeAtm/p9NYItFEJlCTWDVjeLVSeixgY1+F
	 sNHm3kh/McQgg==
Date: Thu, 11 Jun 2026 14:01:34 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, david@redhat.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, vbabka@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Implement a new generic pagewalk API
Message-ID: <aiqjnj613Ut2bK1n@localhost.localdomain>
References: <20260525165528.184397-1-osalvador@suse.de>
 <6a153468.050a0220.7dd1.0004.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OMyYprDkbMQMsjSv"
Content-Disposition: inline
In-Reply-To: <6a153468.050a0220.7dd1.0004.GAE@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5A6B8001F
X-Rspam-User: 
X-Stat-Signature: d66jaw75prokcxt1ghw4ntw4qpka6n7y
X-HE-Tag: 1781179301-670887
X-HE-Meta: U2FsdGVkX19Rm+WM4Vtgr7C4euqTEY68a+scx+/Sgdm2L+f7iBqEA4oj44YBP7CoqG9A8Rtndw7oh91cQI1IG8Gl49xF0RMY1bVjRnStRzhGmnuYv5DuglXQKdc/fSYasuhMXzzhvYEz6L1WI5qjP+7LUdCSUTFB2ssnpmzxxXUi6MVa0v4qvGeU1A8bpyeySmKkJD3eHca/WAo/axJMLBC31COf3DB1vsRMPxEeAtnwClSGkwG/x1fzLqxIMfEXEULmM8ikq+iNLaz2hYysM6QxKU06GbcNf74c/3JSVp7C3UepXLTeS0yrXbQwSU/FnR7dL2gXXU1UKNA5rHuoD9IL6+KWZ2j76L1axrY7Lp8jami8GUnylgEE1S75IMvBd9Md0wvr745PLA/HH5aig8fLnDvxunQpopBZLpT7GZQwnpYf4z7bjfgxIrxNXyR7GwiArVmIHVMLlRkBNpaEHvJYbbmUqnhj2KG/5U8TjT0gv68nXo69wP/tu87zmB2dG/0zTHg+TAVp0AQ4H6iinq7Ud/y/CQs7crfM2wEDj6dHNs4aC/CYYjpRlBNjkCpg8/mwGBA5qw2LwBMs79Jus1Hbb1JBTkzoG/grHOC/en4Zh9a4EYDIDJriBb/9Fiwo/JzV06fp/7+oKE6CHvNY1h2holOoQ5mErbDOGJA4ygOlXnf++aFiPSUuqxeOkqzHyjS4O4dWZcynq1Z95Ve8x0JdjAFHSe8MzLVAZlOJoCJRT801KuQC5cUvjmdAA8zaj8Wd7z4BEYN+d7OFOTNGW9H63E1nhe13y6JjUFgzjQEjvWXY4oWs5OdMNtOp0y+/UqgtmmI6NfStSFLfYuFJd2f+9FxeCwV3wB/h4MhibLF7ExvBkOXdEwQ7MdotAgdiBKz18uU2mt2hod79lEF9x/Xkz2igjWlWZBEvfcl4rc1+Jvm9O2AS7HzHTvzxxlcihp55Bgh1Y5qcmvC/jj8
 Ils0nGzk
 fqB1NTA5yFCNibAShCLhZBW1HfisEQrvzaaAiGBc4FbKhQbtRWjUDIrR+KNU9NlET3gw4ngZX2fadsRygHIckd55vAtpJW6/z1q5+8mQHEstv16orvs0BxRM9H1AJeIXSK1pVXjdR97F8vjgvIST9fqRgs0tOoljcE33jCs75+c21t9VXbeHuXkDkzBa7l/aJFABhaE9KRQttOL+40nblFX8HPo4F2D0yadNBHlWmpn5aD3R4iPF8+SxKviE2MwWDvxiZkR8O6LITTwAi31l+yDAxSO+TknAuehTLAch6B+LG1bUhfRVP5fPMIGJH18gfohothOGRtSDiTyQWuHerkffLjR47GRiMoEvFqP2lW1zRMVoIfnWExqUtsnijZ0eNOeFZ84x8e/bfWl0eoPlHlLDSeJx7d6qIOUWRWUWtAUbeQzHq/L+CV8cKZqaNc48rF5jomC12G69kn8TGWqD9pAOfhsLc7yB1nOCPZub00asCQx6ISNwFo0bsIwvTVJ0P7dGgk6TwjqYPp08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--OMyYprDkbMQMsjSv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 25, 2026 at 10:49:28PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
> * [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
> * [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
> * [RFC PATCH v3 4/8] mm: Implement pt_range_walk
> * [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
> * [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
> * [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
> * [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API
> 
> and found the following issue:
> general protection fault in clear_refs_write
> 
> Full report is available here:
> https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

#syz test


-- 
Oscar Salvador
SUSE Labs

--OMyYprDkbMQMsjSv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename=0001-fix.patch

From 252fd5679cc74ebe82d01d5bf1523184f7e323be Mon Sep 17 00:00:00 2001
From: Oscar Salvador <osalvador@suse.de>
Date: Thu, 11 Jun 2026 13:58:44 +0200
Subject: [PATCH] fix

---
 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1134dfb3dab0..87515949b09d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1710,6 +1710,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			else if (ret < 0)
 				break;
 
+			flags &= ~PT_TYPE_NONE
 			pt_type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
 			while (pt_type != PTW_DONE) {
 
-- 
2.35.3


--OMyYprDkbMQMsjSv--

