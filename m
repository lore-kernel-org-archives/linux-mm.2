Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6886FC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4966E6B0088; Fri,  4 Sep 2026 05:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447976B008A; Fri,  4 Sep 2026 05:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337216B008C; Fri,  4 Sep 2026 05:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6F46B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:58:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85F0EA0323
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:58:04 +0000 (UTC)
X-FDA: 85175628888.02.F5A9122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E63B81C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:58:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXl+95NG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788515882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84RQjvUIbZegelFgUCwrD+5Gg8PBRCldn9ArQR1bQ0Q=;
	b=bijccr8+LKBzhvrwbtEFEdOSdqyQj11qoyi5x8L3kJMh6hTNPy6gj56aFcKsuX6Sup1opo
	Zpcs9oyW3JErAqaV/uNllsESObHuGpPgFcAhOvfeUAGnC0A3uDpbFa2DknU8T73x3Syfl0
	5azdTCvQwblZvrCpjg/wS4csHiJrETo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXl+95NG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788515882;
	b=tujK56x3XRFiVKnaysiCFP9cLYweYYzmpry1KBFkKNcH2oLlMdlxORs24egrWoRLs7yMWC
	C5FYT1C4UIAip+d3CffPv+9wLudj0BVVaOnVUycNcNPvk8aMa0HsB0/doaq6TMdPCyKobk
	vbCTdL0XNC4tcz0OOsTJ4GLPHjYgrLc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6173F60A75;
	Fri,  4 Sep 2026 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7204F1F00A3D;
	Fri,  4 Sep 2026 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788515882;
	bh=84RQjvUIbZegelFgUCwrD+5Gg8PBRCldn9ArQR1bQ0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HXl+95NGCkRn8wpoJGvYycHo6AFaZsZMhDw8m68jymnrceifFIzGIlqfOs8JNnCNS
	 ndprzaCRxDNXYtrz2A2B0DjKXBH6/qTAXIJl/SoPyxrZwwkHwXB6h3YjDS0vQmpJbw
	 FU64XqtGrRI0dTQ3q9MqUVCe8TPxCHSJpBuPjXmESI8ommzpz4g9wPhnMMD2eQW5wi
	 YP0XLHJug5Crdf2Cd2Ewyc4Mfb4/a5hWceLXfL049a1IlD39ID5VMR9f4n5sg7k9KV
	 KxpQtTMAYWOFgv0i20IDqwo0HOTgaE20eL3Pp1t+/HSyooz1pVXv/BSvyCbPv/CWYg
	 blDgD6ygsVJgQ==
Date: Fri, 4 Sep 2026 10:57:56 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com, ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Message-ID: <apqS7Z3F5Rtq7caz@nixos>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E63B81C0003
X-Stat-Signature: o41t1kx6thkg6z19kr7tj8u7cnr6ytx8
X-Rspam-User: 
X-HE-Tag: 1788515882-936351
X-HE-Meta: U2FsdGVkX1/4eNcMSh0VWO7uj7iw3apWmKeF03Be6dh+wIwNdtlwMzySb3xaGWgC3DD3uDAeUolRNW7gS77b/ifcHpRmRxsEZSu9hvtxutFXDagqUEM1A0eM9bv1ALzUjfM6gks+/vWh9U2NNXa6JrjsBOruzIg3vyKKHfuLeltMoVaPBsS6pITzh4StdzvH9gqAJ3eudFL0ueu89KZsTzlnFwtI5hUBC1ap81upy5SXyMIZulJaFGMCsPO9lFg4tWF/JAP/RBuNBSXDSHaWYsit2x2S/UAurBBMP1lLF+v6yL8TIPQQlFzs2KEWiBAL0lDdbVGyD7BAFuBiQBXvts5TMupS2gkCk96VBQEvO/E4nnkliV51Injee5372vGR5Tb86LAi+g6JACS3/wzCxTFJjjW1hl7EvzMM0Uyo4QMUQpK2hRcHLUyRgX3MspN76fIbYfq8SnLKTd8HknnXpyHRConONMEoobIKkPLDz3Ix9t7Ta5fy8q6QiuUPba4oDNAPg0nKUVrJV6mvcg71O6g5+kprjiCv/2Vgf8Fk5qwYi6VU/JfjypiO78jhulS0FQVZKuFCYS5OiG3uF0gT0yG13xTh43o+wfe6fRTiRUV0UIHEXmR6056xF/N/ePwkrATLj86jGbC169R80ijvPSAdvvIUuVZJbL+KoDf8NymkySuwb0IuahmrWcoiXN1CtM0BPX29/FFHAaXekZGZU93NPhRqOxMNCbC4s1HveGf+FiMp5ra3PLU/Givv6vVw0ckSFKqRXrxeMJ8fduxeFantWbi9HUagM2Q73kdfjXsrpZ21ii+/NABWU51B9k8sop/4GPQuMZ1NGVuNSORi/xRYXyy4OhD2neQYnr+V17qj+U58FhMMNtDpsPk45no7MyRuhVZKYNBrcD0dlCzoKLTVomAQsfO3fj7zbLBtsF+IlP8TkVglwMU8Gwz0RT29k8T9Ma5DEj8pwBc0Htd
 rOUriIFI
 AMx24z5LwFuX800sz7lCoSkATzfNVrXSGA8iwFZYxcSx01l/Afmd8tQ6OGWz+eZDUeEkhLqqBWBMmWIPFoa9dp+xiDmT+L8puEJVr0vR+XP9kU6pSVD8Oj5/p5zXXBKY43t41AIO4KyS0wG19me3+w1RSSw4UVo6GxJHH2Grf6cDaW73okP77A0mxZvZ4DMX3a9nSQtdHFjisNgCgdKQ2mDS3n/lTs4vflkVixjQgmryh/2xiINSUyRkUyZrBhVh9zEf0x701utQK9cDvHD6TFAfUuekupwph3nlVkQo1vTG6BcFKITSaNS6FjqcCtSshssdhH4ltwwxTMAD4Smem80KZrCZPGk25RbeTzF/k8AOnqdrViEySIQ+FkTflkz5Ch/N/KP6O86leqD8yq0l033II1Y5/4rdNNja8tRu1REVg9t6qPOlxMs9RflaSAZVFGAp4vmRy9pvxVZNmg8EOmC2SLe45H991rUofzApuEQ4E2tG3tfo3JZiNOscZXT/hmwq7rxMmjAC/ZU+1KETrKDpXlNDWRicdhvpfYXboQuuDS6EEWAwytreI7fUe9q0q6GojEeJgwe081MYcZcBL6CjwBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 06:02:38PM +0200, Vlastimil Babka (SUSE) wrote:
> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
> local_trylock() is safe on PREEMPT_RT from any context.
> 
> However kvfree_rcu() is also called by set_cpus_allowed_force() with
> task_struct::pi_lock acquired and there it's not safe, as syzbot
> has reported.
> 
> For the immediate fix, skip kfree_rcu_sheaf() on PREEMPT_RT again from
> kvfree_call_rcu(). In theory, kfree_rcu_nolock() would have the same
> problem when called from under pi_lock on PREEMPT_RT but that can
> be addressed if such a caller is proposed.
> 
> Add an explanation comment, courtesy of Sebastian.
> 
> Reported-by: syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=acf142088e0182172e58
> Reported-by: ThangNN99 <ngocthang2710.1999@gmail.com>
> Fixes: 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT")
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

