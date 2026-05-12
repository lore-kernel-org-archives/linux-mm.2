Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CECECD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FD06B008A; Tue, 12 May 2026 09:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0AD6B008C; Tue, 12 May 2026 09:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E1C6B0092; Tue, 12 May 2026 09:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81A146B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:05:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00DB3404B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:05:46 +0000 (UTC)
X-FDA: 84758789934.22.164AFDE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 553B3180009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:05:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TbbFtDMD;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778591145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kX9NKZc878QSw9T/nFa6vS4SRnKB4jXUSRuipp9+zYg=;
	b=IC0LfLqulUppEoMkrWiHBZBxdI5/oVw84DMlfpnjnkc5LAVUj7DyMwM3kfw18aUlvQX3G2
	CmidyotHesqW93eTEy9KG4SxOwoQw1G66dS1gFgj4/NYzFj74pmldfs7RWIoJqQcLH9pgx
	Clnt9EGp4buoILCIi0FfE2vTCDHFY2E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TbbFtDMD;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778591145; a=rsa-sha256;
	cv=none;
	b=5Qcm14TxtvO93ffaWsN9oLD8OGHnqVwl9zGp81TLCP3vwJdUiS8FZKWhSGrAlpUG0BcjNG
	iQiHIuzMxf/JfCTiUsF89Sp6KHAf0hC5mR1h2r5hhgV00ufc+u1wT9+w8x2ZG2vYUr62DC
	J4BDD/A/URl56ec42UXM8U3C3SeRbJ4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kX9NKZc878QSw9T/nFa6vS4SRnKB4jXUSRuipp9+zYg=; b=TbbFtDMDVxiioURi9D9kuOtmSW
	cETUFLucu9DUzw9+DFDImtEfVW+HvJknB/Dq48RIfpjP4PQlqAg9JFBMhrVoToz8+GTLWlAASsAXn
	ECD4xyOtJEmCmJUBNAgqD3vjN7uWz0KWGF0kz1WFu8d/z7UnCdqN6TBK1JVMjREfUBDl9GG/CHRca
	2rkx13nLibDxOjebq7bdpGIKLvXmYE5AFJuia/D3KYSUaC4bCBYFYytHaUM9AVGOo2AkGGGrsngHC
	3nKTh5Rz9hHXUsdXjzh35vu3bmCu4vZ4jl4+z378xsCu174PkJk5KB95Jb+zJBe/eweGM5wskKdCM
	PxVEDF6Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wMmnj-002ObZ-1U;
	Tue, 12 May 2026 13:05:31 +0000
Date: Tue, 12 May 2026 06:05:25 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 3/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <agMlebHmui2quDBr@gmail.com>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-3-183012ba7d4b@debian.org>
 <8d4940bc-d8c4-4e7f-a35d-979e6a781966@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d4940bc-d8c4-4e7f-a35d-979e6a781966@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 553B3180009
X-Stat-Signature: k4nwmi9daxybuo8enkfopkiwiten4r98
X-HE-Tag: 1778591145-239841
X-HE-Meta: U2FsdGVkX19K6wRLrC74yaCOh3gLQR2QvrcD8qcGt7173qz89ztiCFvHjCHiOUzgo2S5RzQPlSjVUDzDppA0oDCGDWNTPTPMHwvWQ3AZE1xHIgih9K+Q90bf59NeNhOTjtOsIJgVHB2dZsPbbegCyxFWOT8uNBQ1rblopl0aejOx71C+URI0pskgbeX049ZQdXPzvpKa2AkiDEyNTqnqmfur+/V8ptR1/u9tcVNU7XEYv4Qb6StD5TUp71zxkd1trTMwz7GhpNjE0cPbAGmSfFG0iobkkAINUj/igfoGTs89ihhepmRWW8QSPRXychIUU/4srJhzliTn3MKmXTO02XdSmdWn1Ga6FkvvzzZT0ku1NjJiiX5vsZs30If7bRKf67RmA+3QRc62JthZGnuqR7HxwqcRwoVTQw4twFToq87Op6RKWCOd49NshFve6DTP2r0nkaZrlR+VmM1yYTuwq/z22tyelgAFfj6nYXl/PGhJdb/9AV332f/Z6EAvsVtGYfsVsCpicdvZff2bPxwJtglj0A5i8fM6aig7p84FjkC2/KMxM5qW1Xe4GtUnQhHuUmBR5fvLofZny1RrvQ6FqjN7MIlYB/ii4yb67l2lB6ih96f69MYLLkEdfJnQblJY8oJ0kjg868BH5rB05ySrzXzx8I5o/KCcGeiPql/ehcdow/x5oJts1W2enfGmmxyJNraw9gMozUkuOcu+OqFU2FV14MKiPIvSRuY4gc2+PzyNpLIqskGRrnfjwgE349kunVtsrv2JAAZgMQyEVxXPdYhl9TJFH2rPvy9PRo//vB0XjrOd0AcYltq2sWlenLLzqGXOYv0vRdYAxOWYTMjx4wLagwlJkupEoruBfp6I1ZMz3TYBgSCxS/YOFbQ0kbg/0Tv/r8Q8nS6gSsbut36aRG7Rq7q69ThDxzu+1bE82CQGcRFKWa89hjc0zNHMji7iXsi17WeCF4oMPDmjr0w
 i7VfSEk1
 mECn/pLRKkdwn8eQdGdYf+8QMaE+n9OCsCU9eOUHemdBwB2eldaNuap3uJdNpibRkHrLKakbzIXkZHd6pP9MkXmdSyUlv0PHKlYSpXg1fA/JUJ2ibdJ2LQreQ+qD3+V9A7tfiEwE1pwPwbgyzRTUvjRer4OjhLt26RcR/uJxSMkP3ceAiUg0lOQO3QIuZGfDwvvg0VxXxXLfFaCJUCMsaBSJnkmF7iyhEpmOUlZaA4Kp/vfPM4UM6x4MK1GEt1efb4wKjkihWmyA3zWi3UeY8b9OMbnEDrK72yMgG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:22:38AM +0200, David Hildenbrand (Arm) wrote:
> 
> > @@ -1281,6 +1292,18 @@ static void update_per_node_mf_stats(unsigned long pfn,
> >  	++mf_stats->total;
> >  }
> >  
> > +static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
> > +				      enum mf_result result)
> > +{
> > +	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
> > +		return false;
> > +
> > +	if (type == MF_MSG_KERNEL)
> > +		return true;
> > +
> > +	return false;
> 
> return type == MF_MSG_KERNEL;
> 
> might be simpler.

Ack, I will update once we decide about the other pendencies.

