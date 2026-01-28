Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B331D35671
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 04:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E016B0088; Tue, 27 Jan 2026 23:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BEC6B0089; Tue, 27 Jan 2026 23:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058756B008A; Tue, 27 Jan 2026 23:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6E046B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:58:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888F2160296
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:58:16 +0000 (UTC)
X-FDA: 84380166192.21.AD83EF4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A47240006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:58:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PKJoiaAI;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769576295;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daXjtGTfmlVfqWEsV/tKRDwuwZG19vc4O33UsaVuyC4=;
	b=UQJoydc5uSPm+ig4MjG+yULsd5AaHW1yk/iOVihkMnf3ilYroKBbiJS5Lrzm1cUwjUPflU
	Rm3wBxsbbE5rpHTX85koncdzFG97/O8raKNVNoHVV6Ip3uvlLTQrUVxMsQauHPWY3FnVAS
	rf8PhHOleC4hEkH8DuSPwEqQZB+nvLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PKJoiaAI;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769576295; a=rsa-sha256;
	cv=none;
	b=UK9xleqN0yQzGgrLvPK7cRJLHrrEUcJ/3a9eqlqVjluyupXfA16tevXuQhElK1XOPiN5GC
	ZFAU2DowO0u1JVB9sHinMqQer6o+mzBmx1yCOnFl+wLOeZSTBdOHmvrsmggv+wH6ii/VUv
	ReuQ0Caa7ekRsON51EXMGQahWETxqtc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=daXjtGTfmlVfqWEsV/tKRDwuwZG19vc4O33UsaVuyC4=; b=PKJoiaAIeJUIezjpIUvwLfhLOU
	ljSMzyiy8niSruUOPj8Yhae/1tEMXXOfdDkBPWvk228fa+x3gT5ziOetsoIlPS6qPOcomc49/VYEg
	TXRw9lJUhkDbPABnmZAwnrgsKAmLUH7AQ4AnGZOBwiLlkTJITaGg5cRexxsqxsIPyy0pfvevgI10V
	EkVCPliHzrpbNBjpdQZtf8BtLMu9Kcsy7J4hQT6WtNuW7LYoAAzyuI/C3HY4Xp5Pm7lL1/zj5aQ3N
	KpLYJej9U/8afrfofjKQFQuivnbtyPIWzjnE64luVJY6SlrAo9HkNbF8Ew4ypXGp7RUjQj7TvDxC5
	7aSVGjaw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vkxek-00000007aLd-3OJ0;
	Wed, 28 Jan 2026 04:59:54 +0000
Date: Wed, 28 Jan 2026 04:59:54 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260128045954.GS3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: eafuj47w41ujqb7mfqpjob1xqt5fyiyy
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A47240006
X-HE-Tag: 1769576294-859221
X-HE-Meta: U2FsdGVkX1/0MP/fyEcjhrTPLZBrmctHe+aa14b7chLsucQH/xC72xQOBEoql0c0VxqnH/PSt/gbEpcz5r0p8AC5aWoar+r2siYtpdSNeY/K6dMtAI3hRtGOvux/IFpt6RWtDZjyVCkUrzwGYepcSV2nWsrKzw4l77N0jCyu19AOiDowf5Jg9B2POpJzzh4Azwpug9R7A2XEuNW50pLckTsUO9+mMc+52/c0bivJFVl8/l9pECGJSDwtHGhiNnZJVivQc7vVp7rIuh3Kn+bqXhLJmVLH7CbH0rFVr+DG2K569LH3CK6H36p8XKoeqyKu5yftIfhbMooZDAOKivb1z7ps0rzLRWCbw2ybaHAMNMuIYgm7uHoQLsj1ZhG61lGKTj+8/kOBvzEjxiu2ELOfTzZMgrPIxiHvUdkA/C48mhZMgA8jwBodcuhPgydQkp+ByBKzShuCPtNrsVAFpAQyJ0deMd9JXQW+zX+TY43W0cA+IU3sCDjojZoIklnMG/8Sl1634qtLBZXMbjQKH8JLfQrufaIk+CdiAHlcuYf7heajFk9Zhdyht+YhjNcPke237gRHZac17BVXP6tdA5Z7xNVoyD2yiAZClI7VZX+dhw7pExk69KD/GJZDxLb8UqFgnP7N97f1nnC5m0sPd1SkZRRH0h5fLJ47MBerZuKxHIvuVClrewFSrP/jnMwPJ2IHPt4CctOPzMrkqNllXAHfQ7kM2FQBa7gjDZXr32vV7+x9/iEV+kEjs7PU5VrXjbap6XBr7xT02wfcaBotUMw64FZQTm6WgJyP5VvkKJgvqCvFU/mN+dgrXOJoiaso/I87Ktg2hUaZLzGSc48SWIdMVbgD1rJCZ5wkCtmPinOzinKT6FsfnvKI2lCfYPDe3TogZ9Q1NHp0pgnfgfzF0ljm+UHF3KJZFUhi66yd6bt3yButikYcaT26kIL1LRWosIjWnqQrZ57vqRol8bjDKQ7
 XvNXxL8G
 /H6PrJuGSsGQmQertOyzqjHB0XX63iXLusp9jmCV0G3WVPmA+Q1Cjdb28HAtzjoygQP0QWaTz6vxcXVtPdRQwJd+pWTjAJe7zYJ3itbaNjow5btiQLR+SlpivYuboF1C5gGCUftx3GONrbnRS1R+yjWfEgNkWexddrv07tsQ3ri42XK35wVpugA0G7ak1LhiL4PwLDNKBZ6g6HguMTWnisDLIcUwB+4rpKM0BiYlWRJYi9ptpmVF3sH9Iu3y7aD7yJ7YWnki0GuA0tsNzSOwqdjDSTDxcTJ801ZzzwjHAGemlxPa+NSzg2xSyU5gIEzsVpdIR+9biph9ejQkSMXcvWjoV/4vVs5YeXrJ7up2EYO6/Bn+xL0m2Pbb8bUb0hPuyZa3/1b/zbZKbSuWPWTZoL5CnqSg+HtQt/GfwwQWVReTQFy/RTSLdrS0JocelXpcc4snu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 06:02:25PM -0800, Samuel Wu wrote:

> Thanks for the suggestion. I tried a few different setups, and now I'm
> fairly confident e5bf5ee26663 ("functionfs: fix the open/removal
> races") is the culprit. I did have to revert 6ca67378d0e7 ("convert
> functionfs") and c7747fafaba0 ("functionfs: switch to
> simple_remove_by_name()") to successfully build, but reverting only
> those two in isolation did not fix the issue.

Very interesting...  Does 1544775687f0 (parent of e5bf5ee26663)
demonstrate that behaviour?

