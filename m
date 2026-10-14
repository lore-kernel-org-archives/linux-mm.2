Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB3FCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58966B0088; Wed, 14 Oct 2026 09:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C316E6B0092; Wed, 14 Oct 2026 09:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D0C6B0096; Wed, 14 Oct 2026 09:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96F7E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:52:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 111831A0536
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:52:50 +0000 (UTC)
X-FDA: 85321372500.01.5850829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51025A000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:52:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYLOKPLa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791985968;
	b=bFmaIXWS4mDuXtx6qo+mnlowzibHwUdyBqzb9m7U1uGl3EnnwhrZJ2vdpeflcxQdpoVp4F
	tqrTQpNLZr9rLX84wTVJa5cZqMT95/eQpj/R3mdbb6FlFnbaIAc6W4pCmh3XBg4ZalDrtJ
	pMILtfFG/PWpCNovWlmZoPclHzYzTUk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYLOKPLa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791985968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fG9/eyKPy40SDyhi1NG0w7HlNhFj+AsuLqMKvUUaVp0=;
	b=oiLJ5WZI7ATJ8vliRRMryj3CjkzPWMyctCPTPYEo0Epug8zEHcjTaahVsAhDyQu8YlxSfO
	ktZt17o42C3cysSAhQpmPHc2DEqzg0MjyPuyICbjJSHYLoWqV1fGURN7QzQhD5efp+KVxk
	3QOb1bgg7dFUCIW2XpWgX7zzPQ1hy8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89A0340223;
	Wed, 14 Oct 2026 13:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1C41F00A2F;
	Wed, 14 Oct 2026 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791985967;
	bh=fG9/eyKPy40SDyhi1NG0w7HlNhFj+AsuLqMKvUUaVp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYLOKPLa/MdYb05p7MIzhm8DPN1Fgwnkw40e7Vcv0XpzcecOvuBfoJmJJQaMhJfg+
	 IluyIEbgm0hyTOWoLGLroYLWssx0UA+mqbOiopN0itMoaqt7pS7O/fG29bxG2exo+N
	 dgfeKQ7BhsBwwKtkwCcaUtdYNdcKED4O387x1vtSk2ctGUWbio1z6qtAjQqFvBnG+M
	 miDmC6C4EDRXpdP6D8ChQ+HjjbZNdo6NXJJFPHlvRqJ6Xcw5wxBSSMJjSH7kXJbq3L
	 ro2dwVTOErDsgzlI8Z3+W4BgotVk7LyxyyK4qGMdGES8mqrxODugGCb1QM1W3HW+B3
	 kyZN258MxGy3g==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye
Date: Wed, 14 Oct 2026 06:52:38 -0700
Message-ID: <20261014135239.3596-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <dfa05908286b5e5684ea0002dde1ee99627154a4.camel@mailbox.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q6tj99gowp3ikinnietwsx4nh3nnb6fr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51025A000C
X-HE-Tag: 1791985968-850552
X-HE-Meta: U2FsdGVkX1+ScDs9JiulVfj3Jskuf6Sh1bJegryfaOHnNOcferrSifC+/Zyl8seYsXeiBAXW2pzklmOWbrvNvfh9gD/Zr0f7Yvy1guxWDDJWuZs3zoWo2H5gyhhz12/uGjoifIhuOKBu7Ky0YSj8zOfq8WxCjbjXX/VxdMXxVyg/5M7eyDc8VEuMyhVIP80lGPM0Hk5hf6AbkpfcU1QlRTpWB5KysH+zW7mqu+GRdpiAdLAjroiBw9VCKen4BI0Ocrr0sih6dWt04/Quo2Ec3UT1GxwSIDye56aQfcX0uqudAk7e2RLIZZEW7oSIQvvm9mZA/+C2juJTkPPEMvUFLiTUw0H/eEyZ9ehzk7Qpsr8VImqf0fU1eUHA8ZPMJ0FpG8MKtAViTfVjgIIma+oTDGg6FI6BVEI5aZO53xIFWYEDyF0Ag8cznn89IEJZSo0RhLNAUIWJOHEFU2A36XEbACq15uFAjs8QxuZaqB4Ul2t1tQzU2MaFgGxR6AD9MoL6esD0NWsrOMxA5DJfoEKPW0ZGyrZiWn5Z7Qvqvmq1JjgQxPEUKG35u5XJO6t/lZrr8YK8cJJHkPyAyeyvV1822Jv5JZKEyysyBJFSNOYYX2xtiGJBNSI5srk/mNLRF+u9mGZJ7JKBvGda/cYrHR48CcYs6ntiI1Y+l55InpQVnNBiMeMWscdIwDE40Rj3pAIwLIfH4YQoOtiLh2XkdlenUVpH26F/K9+/hvWF3CzIxkYWQYGyTssQE4kI8HeibnG9QiSd4AB38ik40uq4oNyhfGrIZjTKlPdLqg9JLpRLqyiz3ErsVUrwl1JhEB7rUGScDJbGts0sjo+8AHgunIvfwYxGrD7yeU3SZ+9HqMxv8zues5ChvQO+HVFEXWS/i2QC7sU1yizIWEUtgvDKskOjm5/qybsu4moz1LpLTmSnQY/e34dOjOxI7ggVbUMMf8wEwLjwMoXEkFBh/7IZX5d
 oY7dD5nZ
 ZOpKyFyl/Rkh67Xf9mXeUw3NEQ9yKuubpqKgLZt5sAdWlgoBxXs+r+tO1mZTHho38IdDV/PD7jFAeymlm39jSueDa9XoNFqY1nwExazxeN7H3N/WH5kBMfUrcShEFqPdYkm9uGMlOjz2Z6pAuJRy+5l0sqDISxjX8OAO3uNr9V6ZlQH4p4OLmOF8mgt/nOPk3A1y63gkuC/WnIfkeR965DUDwDmm1xld2j0Q5tAPOoVATtEW5jkCa8gz6XyAnNRvSfunwjqg3JsG230ABfwlmosyVKy6DuytbQVEVSTCUtxn1mvAHB1ydqNNvdfw71qxYSP0ZwkyFHUAWNdTSaugEP+cvlLH1niFYUrUAzs2YVsb0i00p92SOY7HjawVOrPmxJuND
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 14:34:51 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi SJ,
> 
> On Tue, 2026-10-13 at 17:32 -0700, SJ Park wrote:
> > Hi Manuel,
> > 
> > On Tue, 13 Oct 2026 21:13:27 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > 
> > > mention 'least-recently-used' AKA lru at the beginning
> > 
> > I think the readers would know what LRU means, and therefore
> > 'least-recently-used' is not needed.
> 
> I'm probably one of the few that doesn't know. I didn't think of the whole picture.
> You are right.

Thank you for accepting my humble suggestion.

[...]
> > > @@ -17,7 +18,7 @@ systems, LRU lists are normally not proactively sorted but partially and
> > >  As page-granularity access checking overhead could be significant on huge
> 
> Is this huge as in big or huge pages. For the latter I would put it: ``huge page``-systems
> or `huge page`-systems.

It is the former case.  "huge" as in big.

> 
> > >  systems, LRU lists are normally not proactively sorted but partially and
> > >  reactively sorted for special events including specific user requests, system
> > >  calls and memory pressure.  As a result, LRU lists are sometimes not so
> > >  perfectly prepared to be used as a trustworthy access pattern source for some
> > > -situations including reclamation target pages selection under sudden memory
> > > +situations including reclamation of target pages selection under sudden memory
> > >  pressure.
> > 
> > I cannot find what's wrong with the original sentence.  Could you expalin?
> > Also, I think the updated sentence is rather easier to misread.
> 
> It's two long sentences, thus (I think) hard to understand. I _rewrote_ it this way:
> 
> As page-granularity access checking overhead could be significant on huge systems,
> LRU lists are normally not fully nor proactively sorted but rather partially 
> and reactively sorted for special events.  These events include specific user requests,
> system calls and memory pressure.  As a result, LRU lists are sometimes not
> suitable to be used as a trustworthy access pattern source. These situations 
> including reclamation target page selection under sudden memory pressure.

I agree it is too long.  I like your suggestion, thank you.  Please ensure to
put two spaces between sentences, though.  The last sentence has only single
space after its former sentence.

[...]
> > > -DAMON_LRU_SORT finds hot pages (pages of memory regions that showing access
> > > +DAMON_LRU_SORT finds hot pages (pages of memory regions that show access
> > >  rates that higher than a user-specified threshold) and cold pages (pages of
> > 
> > rates that "are" higher?
> ... that show access rates that are higher ...
> and 
> 
> > 
> > > -memory regions that showing no access for a time that longer than a
> > > +memory regions that show no access for a time that longer than a
> 
> ... show no access for a duration that is longer than a 
> 
> Then ack.

Looks good to me.  Thank you for the nice suggestion.

[...]
> > > -Desired active to [in]active memory ratio in bp (1/10,000).
> > > +Desired active to (in)active memory ratio in bp (1/10,000).
> > 
> > I think use of brackets is also fine.  Let me know if I'm missing something.
> 
> There is 2x (de)prioritization, 6x [de]prioritizations, 2x[in]active and a few more in the
> file. They are all fine by themself, but not mixed. [] or ()?

That makes sense.  I agree consistency matters.  Let's use ().  Also please
don't forget explaining the rationale of the change on the commit message.


Thanks,
SJ

[...]

