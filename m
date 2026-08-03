Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC08C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07FD6B007B; Mon,  3 Aug 2026 13:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB96E6B008A; Mon,  3 Aug 2026 13:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB116B0092; Mon,  3 Aug 2026 13:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B89006B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:18:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36C5B12074A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:18:29 +0000 (UTC)
X-FDA: 85060617138.22.31AF5A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9781140011
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:18:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBresFUf;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785777507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDMlJ8e58+/poOlXD4ClH4FCQ9XO9ZMSS6kLO52PMNM=;
	b=v9N/AkX5hOKVJAwETBdQUZaTtv22EMQmKpB5QFQgVUYX4IRDFegeqf3ZJPf8S+FnunbKBt
	nBlbTv+kQhLcbBnKdPEu+R5RqDm5l/1Tyx3lnZMd3A2MkW3I1TbCX/paPfzxqTAwWBibfl
	nFEr7mkKXBYS1VJLIoeAoyXKRriDy00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785777507;
	b=zfoIuPOPrt+K2IzIoHnpD0j8ncjKhhHlTTbSp6YRZWOIhyJPI10OS9TqJ+H/aBrLj/5QD8
	Tipw/jm7jf+gHk8iuHfUf4if5zoJMogRuqvCNzPvhiABi9z6LQU+zhh1eN6uSXh8TuigLN
	72F6lDtfrpqj7JdJsI7Vbdu/roF9Vhw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBresFUf;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ACCB60A62;
	Mon,  3 Aug 2026 17:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D4B1F000E9;
	Mon,  3 Aug 2026 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785777506;
	bh=KDMlJ8e58+/poOlXD4ClH4FCQ9XO9ZMSS6kLO52PMNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBresFUfmOVFLxHMnrnvu7JP3JWOhzC21LYcTYOFodH5w2Zquzjfo0dPA6XoES5KA
	 70fB+/Tq5OuZiZ7UQRsaQzXm2aG2lNP7bZTYbaPkJLjQCJMh/jQ+50IZ9B6H4QvNmB
	 kRFVbhr/jRcBwBs1R/SCaOva1iH+gpAx9LDN1YE2h2kd39Lp+xUZYKQ7oie0S/6o/z
	 /4eoMokHPGRek/O7WCHNE7+GJKZnxyTu8yXiO4P9uOc09AGWC+DyQkzZsoYGrjJaCP
	 Ec4AN9CPwftDrCLAnWhCi1GmO6XjE6ggjnmkv4A2SjmWhE1bd5ku/9meYywEhi097u
	 +y1LS81KzmVCw==
Date: Mon, 3 Aug 2026 19:18:17 +0200
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, bpf@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, jannh@google.com, 
	mail@johnericson.me
Subject: Re: [PATCH 1/9] binfmt_misc: let a register string create an entry
 disabled
Message-ID: <20260803-notunterkunft-wildtier-restaurant-1733e9660017@brauner>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
 <20260730-work-binfmt_misc-preopen-v1-1-4a0b0da71f16@kernel.org>
 <178571387898.1880415.17662890925792360904.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <178571387898.1880415.17662890925792360904.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9781140011
X-Stat-Signature: 8pr6mgb3ync3sdiuwg9914yp4yt9ijia
X-HE-Tag: 1785777507-119116
X-HE-Meta: U2FsdGVkX1+7oiY5AqTyBYaiH/QC/RpiGQvdhWM1ntg6iUopvqc0ZZYMcqEX/VSRp9TnVLaPMw0l0bc6STWowiSyLBSCzF/2WKcVNvndx8/AsoZKafCae+KWf3rbBTLTk8OcdyZfsXBeZO5bKKzfecjyS4zYYIKdh9AAtWUDmTbrdIZULKH9V8lVytKmbobDcfcJs/5hnBFbT+hhQuLPS8tX83EmqAzxMPs5nMUUsfobYI23yZ08BzAg6YnFjJV9E5VbdTaSHTLyNPPMqYFNToeaxmoYQ+xi4M7gUm0GLkUpM/STC2rULUhK7xCYlcqUc9qikCoZ8Jvu7pNJUkucIl9jao5qGvRRIbIMte1ly4qj5a7SoYM7WW/7JMXRWoYeLzehxuOtHOe1wG2iX2a7+vyza2hAtRcoUB3R14c+grCgQmchEuQrxtmb7hO+VpmhInnIXnGFAiYyz2LuFMCubxDdmFxJktkji4Sn9nQ1vyfnt4vtCm3oE1m9avXyLreb/sbic1zO6AhtIFTI0zuR0tRT3agydB1iPEORj+1t4RITUs2jUe/OkRxHeo+2Nw4Efp0QG3ytUVTg8rtT2HevtHOWSw6Sjmf/KuDJVaCiQuoMRN6piiZmV1GoWWNBZQz6W3mtowcUyTvXQd8pk8e4k5ETPWlggY9+ztqxOFCoqf9A7WqVyVpOerZy22EtpqF2YkN3WEdF/eh1h1S3jtOnHDn2kYi9nHgvxeDlZnz8g9zNy4u8KxIBIQK6l9uNNmt8elugNihs80MPNMt4kZAGGc23K5OqYcWrgGoMlkcHyRE1IoeZT386Pni29KhNlkyeu0mgRajN6gYQrM6TFlkqIVTTr3yXuMuE+ast7FlUC4PQtSwGW55C4V4Y1VHlsT8YOywjV9+Vn0h4I+56mhEslh5N87k0HBigORbEvpI4lkF77Q8xQe0uEzLPbtRViv8pBJ7cQyfttr64+7ugLuT
 76WdiT8U
 faqFOwGN5Hh8lEedq5DNs1H+ewbcX/zpBUsa1CH0Da0NfBPdsF4boqXZxXEWNOODVLlKRqNX8st17EzSJaNsk2BnRtM6D/b+pFi+qhmzu5jbbRld3jd6gIDkjq+/buQcr600PsQIgKWIiOFA86h+/9AL1mBj6KLwR9EPnEdvPjnEiJ14Yq9oibEGBpD1haqDtNIkSEOSG5E5b9XdfKmUUlcItZeI+J73r+tVQicy89VHVzPYK54y57M8gqYHVtT8tBgIB9wKb6zQ0KsdGXPDV0P7v9mmD9U0KpcVtrkvr5GEf0JQmgI0Tma5akRgdCQRvvmIfk6OkSVn1pJdFHqddXt2q00T3B8BeVG3I/67EJx/HXUDimMOLWjUNBy4ul2EtIU0S9dkOOSENLkejVcFGYrOwvbs++5Ehs88lzl7inxoNU5m09dTGPb9I8Y6nBKMH41BYn6bT0AWNDxcjzj6MFym7Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 04:37:58PM -0700, Farid Zakaria wrote:
> On Thu, 30 Jul 2026 15:34:03 +0200, Christian Brauner <brauner@kernel.org> wrote:
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > index 707f8a14f8a6..ca7840b01a2b 100644
> > --- a/fs/binfmt_misc.c
> > +++ b/fs/binfmt_misc.c
> > @@ -75,6 +86,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
> >  	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
> >  	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
> >  	{ 'L', MISC_FMT_LOADER,		0,			"loader substitution"		},
> > +	{ 'D', MISC_FMT_DISABLED,	0,			"register disabled"		},
> 
> AI brought up an interesting point that this now changes the set of
> valid delimiters which you might want to call out in the commit message.
> 
> For instance 'DnameDMD0DmagicDDinterpD' was allowed before.
> It might be a very obscure feature to pick a delimiter because
> https://docs.kernel.org/admin-guide/binfmt-misc.html does not even
> mention it beyond 'where you can choose the : upon your needs'.

Yeah, I can send a separate doc addition for that. But that's kinda true
for any new thing we give meaning. So _shrug_.

