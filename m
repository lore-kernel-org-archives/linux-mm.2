Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DECD116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 08:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4BF6B000E; Sat, 29 Nov 2025 03:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4663A6B0011; Sat, 29 Nov 2025 03:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BEF6B0012; Sat, 29 Nov 2025 03:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 232076B000E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 03:54:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86CE95BD46
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 08:54:19 +0000 (UTC)
X-FDA: 84163033038.23.6FBBA58
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF2E11A0005
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 08:54:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PTjftmI8;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764406458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5Hf/oCoaC+bmr5nJVcUOjG4GACNlaY1TCA6/nmAPjE=;
	b=QMQohK9K2lDI1rElohw5ilfe+xlLD5+J47ZDOhNOuhJENlIw8A6ZKcbH/Pi2zT037edt+p
	6r4ROYg7AdydeXd5qd0kVVxKaQtYzno9AgyL7dGdr0xLa9kJndJKyooA8OODhyij9Mu3Yg
	NHLygWkgsii/q6ZQkUmLC6QnmRez8go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764406458; a=rsa-sha256;
	cv=none;
	b=yssAz5Ix3I+08GVxbXRXNFVBvtY4UsIo8tlO4Dh6aouR066agipbagMVuJaFlsu8GWLJB0
	vmgBc97RdMVOcjTkbXlhsw7JKuSLp760JQJQs4V4cSuc0f29877gKu5cqb+nXJMIB2sDOg
	eQe2da9MlWAZiqpzKorOPGdZFWiYbUA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PTjftmI8;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N5Hf/oCoaC+bmr5nJVcUOjG4GACNlaY1TCA6/nmAPjE=; b=PTjftmI8M0fFYykNkkoVgNwvZe
	sRl0yPdorZlBO7dqb9b2+56JO6cvDqq+27j4S4lAbjt0IfK906dSV0JHKIF6oUAcZh7F+1I9OXyXN
	6yRPprKZfRAggthT4NsG5xgCJhC8j4GQ9Y0hCbf/btIVPJ7aUN2sWaFQ1aXkZrmx7iSZU4M6KA5i1
	VpjlZA9tKeXauh5uTQb1RaTc10dAEnvXoJRgc3j3+Qj591X0teehEUGcHrjh3OQWbF6S0017Ao1VM
	/Vau/quGQchFyHIe6X16LLSWuE5UEd5iDmwgbHYeivqdZVuX9//YAH6hMECm1fPh6ioRSJEV6mVbY
	teD+rj7Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPGid-00000007Cs0-3WJq;
	Sat, 29 Nov 2025 08:54:15 +0000
Date: Sat, 29 Nov 2025 08:54:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org,
	hch@lst.de, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <20251129085415.GJ3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
 <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
 <3d590a6d-07d1-433c-add1-8b7d53018854@huaweicloud.com>
 <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BF2E11A0005
X-Stat-Signature: uph9x69xnfdkjrrh8nj9ry98ztuusxxp
X-HE-Tag: 1764406457-687092
X-HE-Meta: U2FsdGVkX1/KEkV/hlD/BSPQN47xgc7OB/ymecwEhSlhm9cVVsSgYkVkxgzWfHXIQgQzAp1LpH6wRYRChr8QP8YAB/+UL6hpxVlfMTtOSsJdplfdV2AtwDtn0d393p3iYvm0VFa9IarNlyaEcUb4QM8hmXs3oo7VpACJgwPPAuuzUMWhP54ZSUIGDcDsnMk8PrZx/xwfkdUX3gCfpvmD2ObMM6LggqJZgBD02cvSYl8f8I3gf2X0z0Ng/KIHWBMLv2DwzYa5qiOE3SbYEAXRqFJd90Jc5tb4iDn5WsZcy+FkpIpv1RXw7K+nscvpTQ8FPlQuMh+SHHO+g57kkN31apDXyGnHGViSiejI1uv9maAS0qNP9xQ6y1WA46tzDaOzrD1aL/HezBbFYIJpsTSSLfMNiJ0iRzpWoHhmp1Q+0w6MfOT/0Aicj/kIIS0VDWYGR/SPCnokpaEQSEfrkQKEp68NF2lgEGYGMJOmADBmD1ZlwmsTjS12WIPj8JsyfKAR/D0eBl6/dguY/ZHjKzWx7oEEX0/V+wuXpcMjr7dJiMEQ+yqPNX0v5Rklk5ZHjqBy/4wcBN84RYyj9jZABET94IvkiLMtx+USPr4cbJAcAqGeEcM6zEDX7Svxy/+j1UFT56DrbhO3v5Igprnzf1H6c05+pxVW9TWM3YNUNCOhtUBQ3/atnzv+TG9QrZo28X4pNbtFHv0vwWU15/WqsFgiHellWg/DGKpb2uPhE66fjmeHkVc8yCiiNB0d32khL25Ps4F8EPlZMX99Qsj/ei2cXaGARxMUZ9WOlrgwN4O+zBdD21mAVEMxhjDCoKbOaoC0bVRKEWjPdj0Hp9QYwBTU88s3krkzFIpAjkL6AptmCl66tJ7vi59ZEe0CXqjhG2VsuZB06IujyseT+4OyenPA/pJk8KGtj4Glq8Fx7mmHyVwz2hAnedOTNMMnkfu4TAf9ako2TVVgiOMg22iSXYO
 dnRNahMJ
 1FsEtUyK8ntSimDaQceoKckOHMkdHhfSy9PXPc9kRdrAup/2wc7yNquLI40GxO7gKEadoQzPeWGa5PUd+8/uSPsTKMvta4rlTazb34CRfmbWKRLJvOwLWb7qudg/YjY+brxh5+2H3sO7u7hyrV5aOFJSW+ROGjZZq4DmOzI2yEpgKS5xWzQTEj3ze+pbGwxG8C0ZDzgwKAftOCPWF0OWkRrfDWFNo0xpSe1Tuzp3FnSgYLFRTlMe6AKYnhaSmxHZGHqzwAxynYFZyh6xLLG/blCu1chQfVK5Tg2nIgdTdfr7bcPMRUPZAYSnnrPV4/WFaGm2DLXCRdV2f/EfdVJmNIHgilJncDEAPOl3PMcfAJs3R7jBpgk2vjj04OW/Fw2jvnHSPUjJ+BGboQnRMqrmR0n6wwYOlkzfxaKkT+1ns7aWBqklVWHiN+sUmRWS7vXEr/rQoNc2nRtJQBhyhRWxs2raAI9u7Hmq25pvDPPh5tLvtCWzOsYmdLAUW+QIbezKpBP/C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 05:35:37PM -0800, Linus Torvalds wrote:
> On Fri, 28 Nov 2025 at 17:01, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
> >
> > Thank you for your answer. In fact, this solution is similar to the one
> > provided by Al.
> 
> Hmm. I'm not seeing the replies from Al for some reason. Maybe he didn't cc me.

<checks>
Sorry, I thought you've been somewhere in that Cc, should've verified that.

> That said, somebody should  definitely double-check me - because I
> think arm also did the vdso trick at high addresses that i386 used to
> do, so there is the fake VDSO thing up there.
> 
> But if you get a page fault on that, it's not going to be fixed up, so
> even if user space can access it, there's no point in looking that
> fake vm area up for page faults.

gate_vma is not inserted anywhere - it's special-cased in coredump_next_vma(),
proc_get_vma() and get_gate_page(); none of that can lead to insertion.

AFAICS its uses in mlock_fixup(), __mmap_complete() and should_skip_vam()
are pure paranoia - "if we somehow ended up running into gate_vma, let's
make sure we don't screw it over" and had always been that way.

So VMA lookup would get NULL.

