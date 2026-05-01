Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B6ACCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EA66B0095; Fri,  1 May 2026 15:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05E36B0098; Fri,  1 May 2026 15:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BD86B0099; Fri,  1 May 2026 15:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E116B0095
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:39:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6000C1C0140
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:39:24 +0000 (UTC)
X-FDA: 84719865048.30.7E0C018
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1A34F180007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:39:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uHjHrPPD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777664362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rp8f/WeQia8QAD+YJmPABxXPXrvHyOM5hZfBchCKMDA=;
	b=QCOEEnbb2S25JcElMdcDa8XFfOALPR0Pv2M8k5mDocwDeoOojhtc+qi6V1CM/QTYDVHIKS
	/vV9VHRoOvtNLLvE9rcFOKCUy1oMdThiCdpoq7UoPIKpChvF3Zh0jH2aoPHCEt2ggIfte7
	1AgMDHZ4HcP3WM6WqeUcnWwr+4+ZFqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777664362; a=rsa-sha256;
	cv=none;
	b=eJXU6LkUavPeOnkiFY4gC7JqkcHFj0ld66wbWFTvBJJefGXRJqzuaiQqB1QU826dytQJ2x
	WpKBFVucbsM4iPXdouVvQfjyMOUDQ8u9CcbyuQ6180P3+RfiflJmZOjRuIqnhG+tH0GUhA
	l6H/Pv2KVMbS2zffWZ422MAwCwC1AjE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uHjHrPPD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=rp8f/WeQia8QAD+YJmPABxXPXrvHyOM5hZfBchCKMDA=; b=uHjHrPPD2LeDk5mLziBh3YyqEj
	pfhR1tJpiKuUsooCkGqL2JZsb+D6vXBCRLBIbK0Q44xOCZOqwgtOj5wLR1q5KX9Q3NvcP0rciSd+G
	ckgC0Zlz14TMgm+JsN7ZyOCt1Uvx4cReuGP0X3rwHMIqy2VNYPteQIn4/oeQedWAMeFvYDZOK+5J9
	gMu8Q18KidiWTxvlLNVjdpduJUbW8ext7a3iuodZcXYJM4buozO5xWvugDSnEUtY1AeZRzE+j32qI
	9Rxm90eK24xcN0FvxD+xBCl3zDGmbqcxwWSaplpXlbRREhdZ7Fj4povFbiHlxELsrOySKt4514WFP
	5emRWH6A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIthf-00000009F6Q-0jSu;
	Fri, 01 May 2026 19:39:11 +0000
Date: Fri, 1 May 2026 20:39:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afUBXnPVnt7Jt5hh@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4x8sNtgv7Y198Gh9NSY+SE2o_JPFAxG9aWE+xXsB9vwGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x8sNtgv7Y198Gh9NSY+SE2o_JPFAxG9aWE+xXsB9vwGg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A34F180007
X-Rspamd-Server: rspam04
X-Stat-Signature: 6wozbug4hemh6f3jntpbcjwitiux7a45
X-HE-Tag: 1777664361-601262
X-HE-Meta: U2FsdGVkX18QBQCQBxqswBDmQ9tbJrvNra8mC/S1EV+knHBhZu8Hoj8ceT7Rr3B3hrpmT5CfEhgizSsLIjiOZWVZJJI8W48Z/3ZTPnRNPNnXLYul8xfpJPIj9r3QR6rbUzNruCHk1SFCuYnLlVzkWmDXHMe9vsBjEvc1wLmnuUEwFegmHU9Z4ToR/Kud7Oy17mjuQKBeSOn3IZ+XjHcUm5xlGVt8IV0rJLK0xGvmp/SAnbB4jtoBm6DmF7EBgwNXkdKK25f6pSkAUHwtL9ttQEyxdJJO0HcAHkIRV+6Bpzlls3k0vYR2PxMC4roaS1DcpJro2tNx+bCsNPubDPcFjXHx//Vn+7NXDdg82YlOuYAMMmoAx4SEMNVKQUL+k3OfFCefY8/7fcjJ2SjYMrwH+wyZWU2OiZhans3buxzmzvBFq9zzWj9uvS6TiW5Jb18z/rnIG/4+HED18BUiYwYmPdVje4SmTHdKSOnnVOcPweaRpPK9LS0P29dv9BDIHHJ67oGUJcKp+S3xUk/7JROm9eKVwsNB1Kdc3JAxXYyWJSvE05zz+5woGnAElM4nWZjWr3kM0Wmcr2uQK6+QQFgbCpcSzQVUtQz+ulb0TunvP3jtk5uMKFnKpwfonnnmudmZhoNzxjbGjN3ATXUGTPwvvUKM61sp2nOpTp3K9v/K9xsV+rk0/vsnupvEy5HvK9MZ1TRvXF8qvSYpTsfxrduod/DiOjvYg5zI/jThZwFmsJ0HitSB62DKoIwmkbAq/SA4bZDm7o08c+DmA/lU0v1RCZsR41bHrfjXeznktX51+aybwNMEVLnVQqkstmxyGre0f3fqfhZDak3Wdugln5/FpYCMYnNlEjXsdKQaPe6W0FdUoWvJWdgZa49gPhVW2qA7prOvimj0dOz/N2OxNZ7brNywOj+kg0lMhrdp80ExqJVQjUQ9VVcyFPODWmNlWY4kf8iHdtuwMHFEnBHsujJ
 GSs62S08
 LRlgMmBn/zFly8mO+otrFtUD3bU0ux4eRelONA7yiuoiBL2hpbctT0pEk9uzskAQlbHrj/cnQTlRqiS78WS5vsWY6+FDm7PKQnvfAPIKMsmmOKhybL0PdVjJLRuydP/abKNESiOBZe3+gJzOD1ruzSN/dgceiT+ZOAEfg8ZQvWZx4Y7PnS8EOdRpw/Zda/j6T70i+kdDQHnjudAtTjT1tu/NrpnBJt/LuGPBA04/3Z38BXFKfaqTgURzY8abXkwiWpLolxkcP+QGNlG44MhykBn2+CZJYrC7lrSCt3Lv9hx/zbnXCYUToxp2m82zBjwYtLcQ02q3kAV88XKOWAse2bUVPK14g2ht62hVz7AimKgxchbFRunu5HAbmANIGVvt0+wVT27n/G+CU5DNcdkE/8BDvy5SLjzQUpXr+ABBZgqWVBsa8BNlaLtamfbEgXE5EbNa5Jfy/gp6zNpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 02, 2026 at 02:25:37AM +0800, Barry Song wrote:
> On Sat, May 2, 2026 at 1:58 AM Matthew Wilcox <willy@infradead.org> wrote:
> > Yes, but that still fails to answer "does this actually happen".  How much
> > performance is all this complexity in the page fault handler buying us?
> > If you don't answer this question, I'm just going to go in and rip it
> > all out.
> 
> I’m getting quite confused. In patch 4/5, you suggest a more
> restrictive condition using
> if (folio_test_uptodate(folio) && !folio_test_writeback(folio))
> rather than if (folio_test_uptodate(folio)), before we decide to skip
> retrying the page fault [1].
> That seems to suggest we should be more cautious about when we can skip
> retrying the page fault.
> 
> However, in the cover letter, you suggest removing all retry code entirely.
> Does this suggestion apply only to file-backed page faults?

I'm making sure that if Andrew decides to override me he at least sees
that there are other problems with this patchset beyond "I don't like
the additional complexity".

And maybe we decide to do the fallback for anon-mm but not file memory.
Or maybe it's just something somebody happens upon when reading the
mailing list (or more likely it's just grist for an AI).

