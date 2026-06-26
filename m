Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05EE4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B466B0092; Fri, 26 Jun 2026 10:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCA96B0093; Fri, 26 Jun 2026 10:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13726B0095; Fri, 26 Jun 2026 10:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9421F6B0092
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:18:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A0618CA65
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:18:30 +0000 (UTC)
X-FDA: 84922269180.15.57E5173
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D23E160012
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:18:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSZxxfSY;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782483508;
	b=v2WHNyo+JLdYrij985JrPivQHFlBqGlkw7ePLNH2b3Dmsjymz5+ego+mczxewDVvbzRkCd
	fF01gS/2KqH1AR5zsKBrMlmaTwpHpAJxGwy6Nae0Q6z6am6sTT/n8dKeXwMVxxs6Go6lkZ
	L5CcMRL+/mZ6CDVuBFJ573RKk9XfzKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782483508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSqrO2bqW4dSYaxlrIc5+ZVhWS8NkgGiGqjtTA9ncRw=;
	b=btEUhHotsFYX01R85q4uf6q8fDjosB0Wfgewyhcz8HqB6lmQHZQ2MwkoIOxArssPnMYlhP
	KQo8/Kb7ivaEO8VjsxdyHn4E6Rnn16yOoX5NOQBALnxCoH+wULvGdGQfvE0bxzmntO9RK+
	77PXXG4ko0gH0up/4NpXIQOKQ6sK4zs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSZxxfSY;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C534074C;
	Fri, 26 Jun 2026 14:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850591F000E9;
	Fri, 26 Jun 2026 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782483507;
	bh=fSqrO2bqW4dSYaxlrIc5+ZVhWS8NkgGiGqjtTA9ncRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSZxxfSYlWcVT5jvIJ9nz2ueUduvU5pmr6hfphnHMxRs44ttAkP++FeuBcMZAniz+
	 XKgpXoqOPxXhGcrWyoy7CjrjyYlbzMZRpReiOFTKieSAxbPbwX+K4Soo3jrxsT24EJ
	 VB/EJ8jIdNFNmcOzW+rjjZrAUHIq4+a3vqUnz2O2Q+5UOGYH78I9AP8MM8wHeoAShG
	 p7FhqZQRFN8sU6U2uNMBBfZP3+/Fjt8iwoDlQuFkwV8mDUo3sasov9UqXrT+t8F8bt
	 6oBhi0sfNZDuxlv4FlFLHQV5xXzftdNMC2FzZqneQCyyc+/8suTxEdCjMxP33NrkMU
	 4nuVQXuuju1oQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Fri, 26 Jun 2026 07:18:18 -0700
Message-ID: <20260626141819.86269-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626081038.46569-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qwo7nko1acnpdmijwuzftwk1o7yuzbsz
X-Rspamd-Queue-Id: 5D23E160012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782483508-344197
X-HE-Meta: U2FsdGVkX19C2T58Ozsdu1d464voW8hQwXVFuSHrLmxcK0LiUYQt/vfzgwOKyswUBIruzfo6p06qtcHe4xpwPeqVh3eKWI7NsoWkkDQbZ4ETNsak3rAc8SfJtH6vOxZwmm/jb/Usm9cxFSkOIEJ9KIgvxQSF0l4FCbE1732zPhuE/pZlvxBxmxNPYCGMlRXZt+ISSLmDzo0f34bjKnwWPYyfIy4rTipd6HdftJU8/cas/8VoJXuYDamkqTthHfLtZVWNXC76koJ8kctfd12XqWuUyn3SS0BnEy6TmLr5iGlYhyNla63oNH7IgwDyZl2ZbESI+izxQRxL+VHNtNl83kBTEaV2zDMpXxX1xxiKOhDYm9IcB6ql10URxpRYOeHFX98lF1i709bleGx50MxTZ+26JZvCFBG+8VdylX9QGd9Zbzh6COGmeQxfSwN0W/EiIz3YBTuBwRnLVHlynb1eCHNDrN+i9t/4jU8sq2y80dxi2BY62romeG/B2lsfcXi/rHj+Lw7IRg4ZGkTpFlhmnsq2OoVdMoxdNw51zqcmqNaiD/EjjwSpK5IOF2zwAXlXpplMITFogB+En5Rs/mnoN6vYTyWWdTlcO+nLL20dhpvUBGA7bnwimPGGLtbQlmrg9H3sENUEh/K+M9zqqX9sM5zxbk93YTMvR9j3oolkm6GntwUsC+Nq8Ng18y0bvizuJKEt9UBM0zwNsrZkcLLjN1SendNLzrxqBztuFYYjZrmEU+QLsne8XvcMqZ/pKAU+HRT3gPn1/hwfmtyqNrYmtadmxyx/GJF24k3AL1Hwe1iFgGMp07o/E8cN/wIQIdcloG9zyX31SbvXQcqcDV/Yz/pERdL11hOIIRFNhDwrcb5BkjdYLtH1gGu7yhFRfFT+C/71cobtCfNMViBbZFDyCQtOvQIR5ciK6NLGlePmdTrlzny8HiY//otOu4bZDJZaKeVOo94xnzfik1tiMtm
 r251C8ki
 IDaG+Sk6bDeFH8A5kbe/joUJH7gFLQmS+n07dzk/cvSFmBgTEh9zylEWeUBWN50FBXZE0B2oIUQ7OpnnVy5AeCCPeB6EPzqSw5GR/bbl2sWXwq6XsKwHO+MOjs0OhSJP5zIYJllRm0YBdeo6DgqVl5+12Cf4mYhdQ2ADfVB8xKQsb8f0FOt+KwSvAWJe++3rEXvzPjk666le1sK8daFfeWiaOxQ3fJ4Hoiy20zVlI+MMM0KNVUnzAKB5tFPCbHQQjlg3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,


Thank you for this patch!

On Fri, 26 Jun 2026 16:10:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> 
> Currently, DAMON's watermarks metric is calculated based on the
> proportion of the system's free memory.
> 
> However, on devices like Android, the system typically maintains a very
> low amount of free memory, even when the available memory is abundant.
> This causes DAMON_RECLAIM to prematurely or aggressive trigger memory
> reclamation, thereby increasing the risk of page refaults.
> 
> Solution
> ========
> 
> Introduce a new sysfs parameter 'memrate_type' to DAMON_RECLAIM. Users
> can switch DAMON's watermark metric evaluation to be based on available
> memory by writing 'available' to this parameter and commit the change.

How about using DAMOS quota with its aim-based auto-tuning, instead?

I developed DAMOS watermarks and quota as safe guards of DAMOS.  In more
detail, DAMOS quota is for restricting only resource usage of DAMOS.
Meanwhile, watermarks is for restricting resource usage of both DAMON and
DAMOS.  That is, when the watermarks condition is met, not only DAMOS but also
DAMON is completely paused.  Also, watermarks feature was considered smarter
than quota, because it is a kind of auto-tuning.

However, it turned out completely turning DAMON off is not a very good idea,
because it drops monitoring results when the watermarks condition is met and
therefore completely stops DAMON and DAMOS.  It drops the region shapes and
'age' information.  Especially, 'age' of some regions commonly cumulated up to
hours or even days.  Dropping that was a problem in production use cases.

Meanwhile, we introduced aim-oriented DAMOS quota auto-tuning (a.k.a DAMOS
quota goal).  It made DAMOS quota smarter and easier to extend than watermarks.
Nowadays, users can also pause and resume [1] DAMON/DAMOS without losing the
monitoring information when they want.

So, I personally don't encourage people to use watermarks.  Of course, I may
missing some problems in alternatives.  Hence I'm asking the question to you.

How about using DAMOS quota with its aim-based auto-tuning, instead?  If you
cannot, could you share more details?

I'll hold reviewing the code until this high level discussion is resolved.

[1] https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org


Thanks,
SJ

[...]

