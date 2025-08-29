Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A90DCA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C1D6B002B; Fri, 29 Aug 2025 03:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673806B002C; Fri, 29 Aug 2025 03:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B08C6B002D; Fri, 29 Aug 2025 03:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD546B002B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:14:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1ED7184E70
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:14:45 +0000 (UTC)
X-FDA: 83828932530.16.E56F702
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34030140002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:14:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SZrhyFHA;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451683; a=rsa-sha256;
	cv=none;
	b=Trysnz2aENGokDooZMZ0ErVlhpn9rdNyodyAQ5xAIs3CfLRE67cb8JPlYStC5egN7b7MTo
	w4WoX2Uo4RZa8XfJt7jQnTZXGnNQ/bEb/jkcH31ge0e6I1LlzGhodRP+w7sUzKwCohkct+
	P2e2gcjUkYLsEv5ZJFOPlNGIo/h7eHQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SZrhyFHA;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnAIYKYIPy93nPHNmWiB7bO5LeKcaSAfNJLovkkHCL4=;
	b=nD71S67Hqu5LakZzc+5BkRJQwZcdiYwNgeTMa8r4ZQ8rqmIEKZt0CuGbUqhmNMly8zpwtC
	zFnBcxPdsikgqR31kGiZxyvkDO9imwmAynyKQ8ASiSFtM4IoHt0vrBJ9cuibGJPzb9Ap6E
	BGfU+VIXuT86gK3ZxFB1RRipdgqn/yk=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ce4ed7a73fso733506f8f.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756451682; x=1757056482; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnAIYKYIPy93nPHNmWiB7bO5LeKcaSAfNJLovkkHCL4=;
        b=SZrhyFHAJe67aPfbBhQFx08Kphuen6v/dfgaOuqlNVHmgpxVVj+tW8cDVNISpDlen5
         H9CxLHNPKAcq1D4kkKxQl4TWky/Z74UAMF+FSxSqQ+82gIY7Wum8gF4FwOvkuPugzPx4
         urz8zKtDwF504+/9Qs0qGtgeHPoM9SSlochdpUtym4A7j5LGjVvFrUQbdbglK6Uk1qOa
         IqPbwjGgnA6nbwIzOGvcPnC4Ni9b2FBpHs3/EtnUu2smGDXrk5/mRdoQFvToOBP9TgSO
         FZ3rCfzHwkV0Hnp42qGw9oqG+o0fKah1AbyhKpB2I+E5mkn670JQriyaZ7w9k7hdH8ro
         ysTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756451682; x=1757056482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnAIYKYIPy93nPHNmWiB7bO5LeKcaSAfNJLovkkHCL4=;
        b=nD5WV16s/jFmD2jn6a+tBVoriad9EbdQUhWe/oyp90CaAPpaYEXb40pIe00T8BFHCl
         VX3jm6jctLx5vBu6Df3PKBET3DrQJIrlm20K/RGw23YTrqju62CQwQlorQ+5hHDvv59U
         hLzmU2wBHMy43U/pioEqbqMWio5TI/EgaJ8UD6aW3VAminOoc70X/HI6kMWzEv0RU13C
         srULj5iO2G45wYKhc4LZI8bNlBUb0fwKPeda1NeYaMGIn/5ZIlxXSC5O6wEtij+lx1DX
         aollxJoTCn6pwMcHyCe2dN7At0Po2mWmAKbp1hnbkSEyS7SrLft3eyUibGvfzz9qRnsb
         bsiw==
X-Forwarded-Encrypted: i=1; AJvYcCXrrPocdHpdT/Maxn9ukjFT/QJ/NMNC9iUJYQHXDeJzZIIvVHwSPUMVGe37WpAF4C5iHHmomWSuKQ==@kvack.org
X-Gm-Message-State: AOJu0YxJpH+CGtkORMUr6ow8e/7mBabSX5lpDYwpGqWWT3jPrhhUPhdG
	jmJFrd67jcw0UGrM4q6OyIRhtrmYx3nRr6HjDYD4WKQMFrvuXaFQTIcAjgapXWDaruw=
X-Gm-Gg: ASbGnctF57m0jq2NFKYiYhk/QK8OOYpyoEWCIYRsG08n+EW7+3w0UZNbhdQ67Ho5xWt
	BRbn3E0eOj3IkSxZP3itYmZKk1QBSYP4WXVdEC6yK7b9WVvM/syuVb4fV23Xd2Mz6ZftLmore3S
	Wyo+6Wc89cm41XmBconT425oe27ri6/pB+wBQIRoE1VfkJy0aAVbqVpNoBMFDKKTQiPwJqEGxE7
	8cbHp9/rdkt1lYmcqRCWATrJpxwFJJq5Sc5svhp+namZ7+fZwmba2u0yTpavnysbtDr/fLzRwmx
	WBQhf0p1s+CepKkQZtGfqH9XPfUKKAwzMci4L+rkpF6KJ2pFlV9Hz8rMiOI3slrV0eUbZIjhsSL
	xtoexh5D0+UBhT57mv7sE4E8mKWc+3q4J5WM=
X-Google-Smtp-Source: AGHT+IET92ZW4pB+PBFF6uzPVIkMqG7CO0rfrkoigRQ4KbVW1FPAcvtd1uJYjG2e8Me+yGBpksIpVQ==
X-Received: by 2002:a05:6000:1182:b0:3cd:1cc2:f411 with SMTP id ffacd0b85a97d-3cd1cc2ff1amr4896530f8f.61.1756451681755;
        Fri, 29 Aug 2025 00:14:41 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e7d23b7sm25531145e9.1.2025.08.29.00.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:14:41 -0700 (PDT)
Date: Fri, 29 Aug 2025 09:14:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com, liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <aLFTYG9ciypqjTwT@tiehlicka>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
 <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
X-Rspamd-Queue-Id: 34030140002
X-Stat-Signature: 78ieryihfuw3wqh3ws4j6xzxghuumqkb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756451682-833656
X-HE-Meta: U2FsdGVkX1+Re5D0Mu7y4CZ61mK5EeS6xLGRb23pwd4dcRWFRLBwBc70TAL1ZGiQaIndcfxGrBUZS24t6zckNcZAHN8BMOqcbuJdbrwydvBnxR5YHEQ8AGKtFyEZq9Wm122qgEQ2eSYLa3JpHTW09zqn8yMivsUcnp9r1E9P3AgabooTCF0aD/CukHpTQ8QhzipuEozEt5v3W5xwukVEh4wPLADy5vQqAJm9ZtEwVcSv6fJs92YOQguuTUchBdGDfMSDeXGov8k1vbxuSdnCunl9R6XQkGwk4R+OKQnEEUx+b/mHadbPHG2no+eu6Gy4nNivOvmihuydY0gvV51ndmIr8fzWeoKdGb51gmw6NpsBDmq5V9imfIyAPUSu1NYAE3FHpWnq1eyGH7hKt4HTZ+n4XBW99rNxNSXFlVtzYu7i3qv6JKUp7k47RnTaUjQY+NRa2B8L/XwUfWu123Spo3+ukssJ6RuX1QaX/+ls/XhAxlRH4RAX5wWBWizCMKEuEowcth/GPdXtEgp60JHrOLRL7gzLdOKtqMfRuvfcwV8oL447pKAAWdMhiL7ssPEzvtIKkk3KryXZ0CsrzR3ewCXfylbJep8a2mK7uO80zdjPpJGmG/gSBD9b9KOgzPZNZgzeGCMsqScep5Rn7C28lacMjhvN6jF0S4cn8Tw3zGvXPGFaPrg092Ztgrah5IrS05mLwi9DHAh/RWialhxAjfI6R1riTaKwqqvZOo4ace9LuLncnU8aUUOooJan6JtjsAcDAnxfMS0epOlAvvclykhQ6T8us4i2I9/xKOiD5jl+xDabknHIhlZUogEaBn87/9UTr3rQeQ9TfzD0s6gxTHaz1zKodaWlGC1qFO7wzRUrAqloOdgtCnNAcqNFVA9uCxuegTn/d/ofFSaJSomjPycRs3QT9kDoJlkwH2zh5wLgH2NwwOJR/LoPr6toUzNrnXvR411huoMQ0rldKPt
 91+Mcms6
 MkIlU8mYzKiQNjQv31R96LaUvQE0mLoidk5WYhJX0Lxm4sIl861Ysu2dmVehyeoOv0Twp+Yru1VGfBR+LDmEZGw9b9XIl7DqgTXhmcallZ9r21xdHjxyjZiJIjfklQruNJb+yx+cdVB/ZrU9yCE2kt8vXG8XGTRzOfroqogOOqRW/CEvEqfiPFGO5kfolQoSzmwmMcn9WdRqmJ93zjsgMbQTY5SVrskZ6kHi/qaPVlH12O9hwAwu+pWlB66zYD2ony/FNn6+81bZogtuHkVDH9JZK+GTmGo5XpKRnfPmsktPX8+Nd/CDqIyjqGAAWrIiL6yWlfLgL4o1DmkYZ70sWTl6wdIhBP4USLLsBlFhKmrz6d0ENWPKY26ZxeJB54MMH+SUjZF+Fl0qrid9zER5hTduSzSRL8oja9wUZGgpKkjtEZ0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 26-08-25 13:53:43, Lorenzo Stoakes wrote:
> On Mon, Aug 25, 2025 at 09:38:55PM +0800, zhongjinji wrote:
> > When a process is OOM killed without reaper delay, the oom reaper and the
> > exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> > tree along the same path and may easily unmap the same vma, causing them to
> > compete for the pte spinlock.
> >
> > When a process exits, exit_mmap() traverses the vma's maple tree from low
> > to high addresses. To reduce the chance of unmapping the same vma
> > simultaneously, the OOM reaper should traverse the vma's tree from high to
> > low address.
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> I will leave it to Liam to confirm the maple tree bit is ok, but I guess
> I'm softening to the idea of doing this - because it should have no impact
> on most users, so even if it's some rare edge case that triggers the
> situation, then it's worth doing it in reverse just to help you guys out :)

I tend to agree on this. I would expect that oom_reaper would race with
exit_mmap only for seriously stalled processes or huge memory consumers
where exit_mmap takes a while. oom_reaper would be quick to catch the
exit_mmap as it wouldn't have fewer work to do on already released
memory.
Going from the other end of the address space might reduces this chance
while not really introducing any actual issues.

-- 
Michal Hocko
SUSE Labs

