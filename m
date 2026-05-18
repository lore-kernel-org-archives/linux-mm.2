Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CF4CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E860D6B008C; Mon, 18 May 2026 07:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E361C6B0092; Mon, 18 May 2026 07:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CDA6B0093; Mon, 18 May 2026 07:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C360B6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:45:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75E7E1409C6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:45:04 +0000 (UTC)
X-FDA: 84780359328.07.6BA5C78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1A15C0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:45:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYxjPmaU;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779104702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUgDWcQoSRXmILzUK9YdfQK3rBQSlUha1U4OtBWh/EU=;
	b=IC0kdxe3sdTgAp52Kjw+1gm1UEaWXFlqtkPynSGBGjFX4xKSU87zI5wgHXhwRQtQgvTas0
	fjuynEvFr0kaGOQlEw5EJ37ZIG+OQk4VG9e4WPktM2hJ63aJRxIgPkt6D4/6TMU++xMJl0
	6fLM3v5zPbOJm1vKfYGqyxQ3koK+0pQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iYxjPmaU;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779104702; a=rsa-sha256;
	cv=none;
	b=cXK04UwwTIUR5ssn03IEHmVJb1dCW9eXUHz+4PmlsFqHGKwPkcI4NDCNpnEPK3Aljp7vOy
	sUURpibhrJhlOfQuw645/NilJ+9elkFQYeQ7BAieqqzwF92jznJ58M4FPgwbkQ1+fMH+q3
	p37zZCDbSp9LKpaAEwkO9hPt/m43qTA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63B2E60141;
	Mon, 18 May 2026 11:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0B7C2BCB7;
	Mon, 18 May 2026 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104702;
	bh=KCMsmI7DxcQzs4N8ZHEtNZgXCjWeh6t4flSXexbE6g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iYxjPmaU4QodPbr2+BG1wxZ3B51ve3CykyM5F/HCQlIkUKNaykQLZASK7R3RQy4CI
	 L8OKUPbPXk3Pea6QlzXFG/bjTQHNNi5lxCmevmPcWwrZtDyLHmcGdrMgqdm+3g0k8N
	 41hJRZY75xgNZu4Skr+A73mEtWu6ztjnKqNoS98ZzuD4G544FKt9Gv1hWE5N/PZThM
	 0zikTVNCOjRuwuXkionRzQDgC7zw6TPn6h6h4ri+jOs6NybC4LmTPTU5BReyDKs+Gr
	 Njx293XQlwk/zAziwHKCa1CDK2aGC0pkdoSIB6IlxjQkzBTjg7zhjUURJvs0kT5E0u
	 okaqRyCOj85lg==
Date: Mon, 18 May 2026 13:44:57 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <20260518-pfoten-rekord-26ceab27c0ce@brauner>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <CAGudoHHeYbPWQbz+vXoS-Oi4PhxX6rh5XsMUkZetyfdnJHNj=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHHeYbPWQbz+vXoS-Oi4PhxX6rh5XsMUkZetyfdnJHNj=g@mail.gmail.com>
X-Stat-Signature: 64k4fnaigby76fi7c7h487kj1fks38a9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1A15C0007
X-Rspam-User: 
X-HE-Tag: 1779104702-537226
X-HE-Meta: U2FsdGVkX1/qJH+blGxUZibjKC2i1dNBkhd2J5lGm/nJFs3dFXwAHZC6goPijfio8anxu3VSkYrpIj+rnJvKvHsITFtEI/xeXFxeQX7PSfruEf1qoPyM7E/TS5/yG+px7CRPGCtunrCHiPTsnoTyDEssdJQtPm69fSn071Bl8kaxEy4OW5jDkT9FXCn/qC5KKPa61zJMWiIbXBTJwrhdxXA8PSEDjL36ZpPwm2/0SplG/+FVkpp0mP29wPgKygUWfyS8o7UiiBBuPVRYhtraI6WXFTBV9q8LuK1tchuawkJr1zSuU9SzFrkjlm5DtAw4Uoboe7wRhf+fuWoOiikVs+uBHmoyaakuIrHqhOYCqBjeFKH3RmuLSwULaTlOST2w72y7kjn5hdlNELFuvnnjl6TmnrDAnVMZxN2UDRhOpurFF58unFEDL6TtmzCWMUtvJjRkyaNN9Io/tecCw9EE3jEEAS6H8C68MQ0f89F8BL8hLzE2ScElpgDqyqb0041yH2DRjNxZZ0lRm6CiYwUY1Seg0skTPdfdj+a5/Or712HxzTkFUvHPyqAcGy4kHOnxsAogMCsYE6V5RCIXdTKn16RcAgu2PbGiHe9GmlClAcd5aSz3GbWUVsgKymJ5LokdsU1KCePbgVSzvbFN+dv+5SEzj6FOT3LOOObFxakSrPRY1cGxkE8aUi0WhMTAdw7ogR4T0qP8adHgFQEB+I5YA1HTR+FQ2AAqbjlrLgr1SA8KjKZ5qCly4V0wFaImOtfVzClcOOSJ7dO6Gtye0WiR5N411LoQEHSKfaJftnWbz5UoRtAMpBes0++fBiSiTuY3H+RYpdh0RJGxSbsZslELQ5L2BwZWC+vY+P+TIpQpB21VcXjkv/NBnmldA5x2MLBo8Xu9oylooH6XvIuOHuYN7xeMoZaUEntad35GBtvSMTe2zTa24b4m+DnpdnOSWmzJkAQWYn1862Ivf0d88X5
 M6n8MkIx
 RpefzWHh7mP/nQ29HiV9TBHL0ZZwccVsmX6Fs00c8sCUUWPpJHHZRRJH797M9j96EnmzF0SPO2luNuYJTPAXWVt1naweUII4sh6+Bt2w6ZRUQcZWILghGyMcFgLKINqijdZ/8NsNE0xXSQRePRFVm4THQXowoeBJUBibf6quP+FbxP7CaocUj4o0wQHny9NbzVP92khy16lGbUiUJdG6XYIGfH2H+fGUbStuneWY9WLhRkaE6ObguJz4MyhGU1mqn+KeKJwyaHeyGeuKxfuxMbv1Q0tEvXjFKsA+Qp5mpslj641k1y4xP1z2tG4msyTm2xS+4oBLiQ7urM4t12QnnkDctsSSL+uY7Mad0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 01:51:16AM +0200, Mateusz Guzik wrote:
> On Sat, May 16, 2026 at 8:21 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
> > and Fragnasia, splicing a read-only file is fundamentally unsafe.
> >
> > As such, as a mitigation, add a way for users to block splice() for
> > files they cannot write to. This eliminates this whole class of exploits
> > that use splice()+confusion in pipe/net/etc code to gain write-access to
> > files they can only read.
> >
> 
> The patch touches stuff I'm not familiar with, so no comments on that front.
> 
> The core idea is a half-measure which will at best buy few weeks until
> splice bugs dry out and there will be a new attack vector du jour
> which people point their LLMs at. Perhaps it is worth it as a bandaid
> until a more complete solution shows up.
> 
> A full-measure solution would git rm these modules to
> fuck^W^W^W^W^W^Wprevent suspicious modules from being usable by
> unprivileged users to begin with, at least by default. Of the cases I
> had seen so far, your typical machine either does not have the thing
> loaded or in the worst case does not have a legitimate reason to
> expose them. Someone(tm) would have to figure out a sensible setup
> where stuff stops autoloading and there is a whitelist of modules
> allowed on the box, and even then the functionality provided is only
> usable by select people.
> 
> Back in the day I wrote a LSM which learned what kind of socket
> options etc. are being used in a given workload and afterwards only
> allowed that. The code never escaped $workplace, but the idea might be
> a starting point.

Shouldn't be difficult with a bpf lsm tbh. Just so we don't get any
ideas about adding yet more lsms to the kernel...

