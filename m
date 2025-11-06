Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0927ACCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 09:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAE68E000A; Thu,  6 Nov 2025 04:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BF18E0002; Thu,  6 Nov 2025 04:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71A58E000A; Thu,  6 Nov 2025 04:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C28068E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 04:44:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FC10891CC
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:44:06 +0000 (UTC)
X-FDA: 84079696092.06.5F21546
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E8A0140012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:44:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf23.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762422244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sm208FJEeA/c+SbI6xb65eRbmqGb0ZF1E7Qhw6Hfkns=;
	b=ALdbdJ5/cswqTdFMzZOF2B+FY2lforGxugAGun6rIOlM0M3lPHGMJL0Ivd7GEJtr4qtxKG
	uzUbyUpl3OUTAqIjGfDTiX/cTn5lr0wVF1ZA3OfFqlQvapKCql0XYNv+A8uTZzwqkzrwiD
	W5Om2SJIJcRfqkPtA3rRRTLII2GETjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762422244; a=rsa-sha256;
	cv=none;
	b=YqyR1YY6X+TDgMzZSW/JenT/s5s9P46qHbS3q7wtDpt3r8vqUQH1At9EsFByWFQ6qo8U5q
	aa3W0K1sUeiZthyaetlt1o97Y+Vm1YAiralODj774yMnEsmds4NXqMiPLO8mzeaX+G2aAI
	7ezzv2SYdhih21RdJKgW873UGCJ8KDA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf23.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id B94553C2AC3;
	Thu,  6 Nov 2025 01:43:58 -0800 (PST)
Date: Thu, 6 Nov 2025 01:43:58 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: Michal Hocko <mhocko@suse.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
In-Reply-To: <aQxl1sXTvhIB753a@tiehlicka>
Message-ID: <806cfd1f-df36-5d75-d318-3bc604479bcd@eskimo.com>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com> <aQxX1HdOnVZJAERp@tiehlicka> <41d1cb48-7711-690e-c9a2-978e0f96f5d6@eskimo.com> <aQxl1sXTvhIB753a@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Stat-Signature: das6kkpmfrbz4m1m1beeh8ekohij188p
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E8A0140012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762422243-764474
X-HE-Meta: U2FsdGVkX19geVPM5UQNf3RuP9LH4ZXmHnD3DgMYEAresgfx9RWtCNdm0HeY8WHK87ze0kLbqyeMij+Hp4DU46TUbSIfYmXCvDzxpBX9ZTQ8CsxfXJG9i3m9TNQH2d58lU68v2qulyCfnz8548pk/ZTCeOlVHjQSxNuuQ5IQ7GF+h2iheuhiIGzIGJS+8iuXDzLjCEvteQ8Ef2ySeXEKx9osKAkn6l40M/Cft7o+VmOLil2UmBt5ktTN/J0SzmsC4RcOvRE/2MMNkIU+GoVhcZH5wZgUZatyUsH/DaI17XLjBK2jz/1pngkY/iubIoq49ZgwDNLekyvKZN5irHka/AICTnm4EmCFe7B1cafIom3KimpYorW+p/2I8jNPFUueEmWcQrAFrsVmpisHOW5tarID+NPP9+ddYmD7s/OEpR9JZb1LZQH7bw5KZDFOw2hHV3d7FxzgK/GDBlYwgmFenlamlEZCnvznFe4WWwcVE/pgpXAyB/2QlBWUuYFuiqY7Q0nrrRL+kVbUUCuJdyTxGnzrsBEZSjd6DN+/2J+diWR+HEnBa8t/bxXE8vrcQSliOV/ERP5E956PgPQB8piDFoVoLAAdrXZoYOI8AydrfwWVUVbq8EMcE0dd5OrEK3ZgZsq+PlJrtOEhxz5ygrg+uGK7izqgbMVyfU1+taI0yF6WtqZeOClJaEtiHzGTT7ZySamiPZk6jQTkXdF7dRmE/1fPqK2CZavsbl85SaXYOLVVhByxnEFBWajCd196VumPr8Ppu+2yZHqQn2eA3BXDR3ulksjmP4kCxJ2VnpPG65yIrCPOcfhk1YlPyZGRKeeapVcOq5WeYcfnraTXtFkaj5LNpUPnaWMu9XpBkBvJ2jSKrSZoAEqo2hRvcpdg/7G2RwvJ5UYtH2e/om8RRMuM4UGN+FjsEovLXsUnm1IEYskszeCmHZXUbrbXpKzagbw4a9dir51dZUNwHZB0WRe
 PFl5F/XK
 aAYYRJISIe/DqHIL6upKe3rmc3e+2h9ibIr4MbDpL5YEBjs5zJuzrJ7yLJQN1o0ivBrWOZGUCzbVeTFDzBpwJshhfHemJnKbuWvn2FOaNpGr7agoAxhM7acFXRQRI7nnpzyWhjGeaBfrk8puxmHFZulMbMaPBW4YZmqo1rBc6umcPcwpeBqLyraHCOAUQ5hKDJ8+RGP0npLVsl7zXpJ5CktYlNn9XZnutDdx0c+4IPiG1YzHw7uBtOntyoxyJPeGD/6gPjdVffEJ1m7b4lPlG+VAFhmJAwoZSA25qkeuIB+q7e1XVZ1NUlZNJ2saydQUYvGjbDbWeiatOxiL9XS/Xruv2RLlP984Mwm+0p7zvJIYGM6ARiUo2tgInATZ8ql2lFp30rdEm4LQni3zRnclfagLV9mkcyqTNk0qoNuRqI/4BI/nv0roNlMTtPsDBM4Q6qVVhkMJkbguet6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001148, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Ok, I will wait and see if this manifests in 6.17.7, if so I will install
from the git tree to further follow-up.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Thu, 6 Nov 2025, Michal Hocko wrote:

> Date: Thu, 6 Nov 2025 10:09:42 +0100
> From: Michal Hocko <mhocko@suse.com>
> To: Robert Dinse <nanook@eskimo.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
> 
> On Thu 06-11-25 00:24:36, Robert Dinse wrote:
>>
>>      I am installing 6.17.7 presently, I was a little resident to install
>> the current tree on a critical machine.  If need be I will.  Also, I do have
>> a crash dump on the last failure if that would be of any help.
>
> Understood, I am not sure who is going to be willing to debug this on
> top of stable tree if it is not clear whether this is a problem in
> vanila tree as well.
>
> -- 
> Michal Hocko
> SUSE Labs
>

