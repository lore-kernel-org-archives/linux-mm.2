Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D13C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8236B0092; Fri, 24 Jul 2026 11:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79CC6B0095; Fri, 24 Jul 2026 11:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F436B0096; Fri, 24 Jul 2026 11:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8804B6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:50:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F0F3A117E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:50:02 +0000 (UTC)
X-FDA: 85024106244.06.288AAC8
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5C0A640009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:50:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AcwSQ5V3;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784908200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puy/lbx3gV07h+EH3SaehUGzAFW3ZFFm8DNCtKB+s9w=;
	b=8D7TPKKVll09RrOvV84nQ662bXAtJEHrPxrpiz/fin2kLvJN37Bd2cy8NQzl58+t2EfwZM
	OxmLwMwlv66V3ToSlkjw/MKtVon4l+SUtJ2WdilSFqWa69tISaw2+qfuEPXLebiAYYXue0
	JtlwyAdPOY5l85hW0gY1kVfvQ7LDVWY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AcwSQ5V3;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784908200;
	b=f2JYZAde2Lu//LvB1v722bpymxOqUO/6CiGykIPq14Fl76iMIpYhbaXx0nI5N7rFhTkLqp
	xv8WBk1Mw9JU/Tvvtb3KF/PUSyMcJuGlTdRxUUb7Z4SHuy6dsPJB46aIJc7N59p4t9L+6a
	0kq4onSAHOjS1TblTY66Zt60MR+JAS4=
Date: Fri, 24 Jul 2026 08:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784908198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=puy/lbx3gV07h+EH3SaehUGzAFW3ZFFm8DNCtKB+s9w=;
	b=AcwSQ5V3zO6db9OMqK62FzP9yQd9LWe6bfPiHIs4UBEzxfBSCHJN+F/plzJnvEcRBg8JUT
	x0t79OSyv5oH13OHSGeUgCwIc5/CZDR7rRTK+jOjkds4tezzCK8HSQt1wXX5RdpZN2LztE
	HNArZlMc1DUXpwLcli7YQbn6xcKl1QQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amOJW_RmU0_4LL2J@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C0A640009
X-Stat-Signature: kwgoxy5sgu8i199sa88ewgtqsz7tyy8r
X-HE-Tag: 1784908200-131271
X-HE-Meta: U2FsdGVkX1/q0xZ3FnzVjJpsBo1H5tvPICbxGZP5hIyYoJAcTqGUMuHj+unSMVX3jYrVJ0EB2UDn+CjcrJgBCdjrUtGfZ0bJ8u0ekBrm5ZHEzx90BUu+R89Q+w5k8IfQRIPYLbEp2vpqYFyaV7ler6zE5NBtcmoUXM9gPY9/GSiL/PWoY+J0ONEYAv+MSfh8RsYyPJBF3xNTLnll/IHloesZb+7MJAvw2E4r3ApqHh54ViKHl16K0TiziRIDRmJm7EUlyMdOJVH/m68shYmVXLlzxAxAeNac+Z4fnJCK86O3wEO3cv+AzTlnmIO3T6NnvlddjXRYDDoVYu3D1Zrj07wPeVmq31B4r2fYoxNSLZANZDeZJFaM+VdRVq/ZNKoVKj5Aao7JUUEHlsNTly0uscVc2HgbIGUNFKFlbv1w3P7pi4fa/hgP2+avzwWhdH+YI/M9GF9Q/pr8XBKHga4pR8AWmLBWXe7tLBkgzJbV6VY1I7TRvQ9EoZ4XpZ6VcXrniaE6qglPLKFlDamDpdn8wWx/azflRQ0barWhv73BOexRYwWWaHRPuUoPr9yWSG/Hut30QOlV6/GpkJl34i1JZ5EWrS+UFYxRaTIvt3plSYCYYVVXfNOH0q7ybxMnYWXHQuK9NZHMMSUiMHpdX3CkhRAheyrxLC1/XWuPf9W3fpKAElDQOV/eiRN/Ql2fOJq2kr5f7iwIoj38bgcZGY8FlOi7PipbOWoxCGiZB1aErbcBiw4ls6CGBbtkBYtDuxkRdwk20W0Gw3nK+e3foo8zxrKYmRTlmip+o39s7i6vHZT4XlOwzpt8cDVwdLHSUXZ0QzZum2DCg5VoFNKV4FCVZaTuSiYizV4FBIQxD5NKf1PTtNMP91DuyTzcfwE2bPdvlFCkSSRKATZpxZE/PlqjolLLJvBWTklQASXZOGwLUPnSIdiNcxdJij5ILkWoNCeyqSJvuZqBdDjYbu3z3CZ
 a+MFkBkz
 Ds5kscI6KSn2OC7+js3/MjexJvPDmh43a9ShA9zdFkNTHuyrBGUlI5N3iobMWzm8GysVe7TOCvdiHESmQAPMv25Tg9iqfxO05WtJoQADu9l556yLEycDOhNjMaMlVFjTvt3Nbvm6vKCV38wkA5CCQNKuYLnNwK7dj1MPOAcyldYgiHhAUxVA1PzVcpbQj/WaioViKNUS/c2XBuL11LWWk1SzxnMCZR1eCC4BX5Bjb/hClcGp6F+Ln6VW6pOmvFvy23JHc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> 
> > 
> > The patch looks good but I have one question. We already have concept of
> > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > the number of pages we scanned but didn't reclaim plus number of pages given one
> > more trip in the active LRU.
> > 
> > Older and newer pgrotate metrics kind of represent something different. It may
> > cause confusion. Now before suggesting to change the name, let me ask do we
> > really need to expose these to the userspace? How exactly users can use these
> > new metrics? I think you can use them here without exposing to userspace. So,
> > does it makes sense to delay userspace exposure later when we have a more solid
> > usecase for that unless you have it already.
> > 
> 
> I do think the userspace counters have diagnostic value. They can be another metric
> to show how much anon/file reclaim work is spent on pages that are not immediately
> reclaimed, including pages retained on actie LRU. It could help explain if there
> is elevated reclaim CPU usage.
> 
> But tbf, I don't have a concrete usecase, and I wouldn't put up a patch to expose
> them to userspace if it werent for this patch itself.
> 
> I definitely dont want to create another hidden lruvec rstat infrastructure for this,
> it would be too much code churn. If the stats really shouldn't be exposed to userspace,
> would something like below be acceptable?
> 

Yes, the code seems reasonable to me.


