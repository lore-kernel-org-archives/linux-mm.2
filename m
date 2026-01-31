Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDFB4E6BF33
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9756B0088; Fri, 30 Jan 2026 19:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877246B0089; Fri, 30 Jan 2026 19:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758D06B008A; Fri, 30 Jan 2026 19:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6626F6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:58:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 571FA59AAC
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:58:10 +0000 (UTC)
X-FDA: 84390447540.19.A547B12
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8915840009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:58:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="UM/ksZZW";
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769821088;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wn5ysU0YfloeA6exMYYK6iQpv2UsqLmSW+HgYt8Lvk=;
	b=IWYdOTxlzeomNZeP2LLJg6GxgE9UkTwx4bPgvrwYG6mfrBO4Yx9UnbGT55fBhUNvESndBD
	vHSlqLjHcHjSAoeQC7xUqrAV7sMl7snL15j7hPza32mfS9u0cW5TuG/5haojwSrpdwwXR9
	VZZy2P+USDi0EpLJhG3bJKZNk4kwWbU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="UM/ksZZW";
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769821088; a=rsa-sha256;
	cv=none;
	b=2+xejCu+gdL5/KooJnwIMUIds0SwovWJpJXFXYIXi9XUNWq1COb2E9xG2/EfOT3QYgSUBJ
	1nLo/mD7Zf/WBGg+gqDp+wfyofKVGXyhr7TxDiQkrQcRMCtL5T3eSv8kylsMtcWBJVu8fX
	BTWvTHlIXYyufnHxEekG3SQk02dNL8w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6wn5ysU0YfloeA6exMYYK6iQpv2UsqLmSW+HgYt8Lvk=; b=UM/ksZZWv++c+yQ2Z0BCZkfn/S
	HjTROjfZP9usvFLH2AozqIKT5BfvGCplmb5PT/OrqOxyIcxn1AnMzXsSeyOPcgbqqK7NMoXLYcvD+
	AiRLG7sl+WVpci94VwwaRDPiyv+ALu0PW0AOh4CiNKrQBg0ntaI7j9YVDXwgHCt8rFkuXFoQG/qMG
	eM8x2UZHeYYWXCwshzBNpx/h2uX9YYt6vLnLMjgpBNC6Py3sbsH1CGWkWSNnpJz82lWdW9yjSFjyo
	D5jPNPQHtBTk91smKSHKmFupg6W69tzPTg2LBnAVeU/tacJaM4FNWwWmfNA5hRayFruPqi7yXGApP
	RaQL9bWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlzL8-0000000D2NM-1MYL;
	Sat, 31 Jan 2026 00:59:54 +0000
Date: Sat, 31 Jan 2026 00:59:54 +0000
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
Message-ID: <20260131005954.GX3183987@ZenIV>
References: <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV>
 <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130235743.GW3183987@ZenIV>
X-Stat-Signature: d8sbco4gik11g6erwy4cotepuqofbnk8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8915840009
X-HE-Tag: 1769821088-105904
X-HE-Meta: U2FsdGVkX18jg6XA+Oqka2/4g4JBXKGrcRtym4BiPU29kr2jjVInV8Py6yUF0+H/8Zfx8u7UchUEk+e3D4uCnY/vDjAVgUwm9CRf6GCfEDxAZRw7AKN8H/dMcD1rZHL+ac2fLvqcVuFtK9Ir6wySnrQ7zu7Itl/AfUbbKbgQmrlyM/3w3S6T/FLpGs0QYwTH7HaaOS59jqV+isyNeRwcf7SVYpFmdEm6g/Op3sQGJ2gLEB23ZkUivHN18PKFXzUpq0u+Mg85z6SzaBZNfmL3A/YJkQ6BPlgOxEoOhSj5j3W+qd1ZiuKrC3tGQ38l978uyveJpImiQi+lJBjgyWrVXB5ruv4QlD4ko1pCM1ZdPLvGLL526DwUa/ZXu6+ycLC/TMQFFtrj4B9kh2lkarUFEn6PPSeJLmkriKskhC2b99Vb1DBsCfxrrAugsrcfHReFSt8BgS8+KiyFZWdxX+ORNnT3Ew2ZRaz/fkDCj2+JghAuQbeBF1BtoLeJ1BjhoM0Ug1NOjQz4E4HFVEVNQjqb6W9Zoimj00/8PawpZ7dFfttWvr+bsNp3vAsRW9/jib1CyK6AhluH1kj3W7npLf5yTpKg5ocIZphpXr93kbaE2zGwHxmnyaZazU/tyExywP9MLdbW3dicDJwRPRcSnnrqPpyVPCqMPkr3Sf+qjNHj6QXYm5Isn9KbC77VBC0F73hdhWOhhKP475EMF4QSkVQLiHmZMIGD/s71AjXnqElPt7+ZgLsF28nJtp/5cLgBNrNIixjTk6fO67tmQVAkdXa1FdFX3YeDjaT6I5rtY8sHYnnsyjYpLlR8nLBUI+5b5cVsE0LCqn+9a+vaNPyZBEXAhNJFn5Z8QhEmKWmPDkW7fISVo1WBnhyae+wgBgezwcn/2K/o627m5138baSwMCs1wkGsyErdlRDIRJZZeZk6eacNKe+r1bGn5ziyNdJTA9YKdkr/0vcNwjNGAFgUeB+
 X/v9voZr
 fY+2hEkk7mVFs/Mxrpg3vjnC6VphEg2Pv1mtTZ+s0N67BNyBMRk6s7hQWfGDMSHjDV6RtU+g3nUbuPat2puSaFoADAvhTuTLtCwIE8mcWfJecHwLPguKR2+PeDMGHbu1DAQ1OTWA1h3V4r+ZDakaobI5LGjSdUxVTUopDzjlULhDm90eantwT7sQsSskwkxhTaYw0Fm29Nlr4sVoBnrTSjDvsJhitW3njJPdaHdtEpm2yhFW92dimfWMH7I69MeG1NDwsMyAzVzuIUekq+v7wJ56Qkf6YAEfTNs0EvOo7DD6uXxMfQLMNVWyrmbTufnVf1p7EVlLvDNgFESZRysLEu42+6EQmq2nT0zRWFTRSXvN0jKD+E8dk6zIVJjg3KKB3jvhoFUnodx555gQNjXIBPjSu4rJjMP53yagsodnASFlRqycCsnFRA7wQ9GEQfQ2VdOkN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 11:57:43PM +0000, Al Viro wrote:

> Another thing to try (not as a suggestion of a fix, just an attempt to figure
> out how badly would the things break): in current mainline replace that
> 	ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK)
> in ffs_ep0_open() with
> 	ffs_mutex_lock(&ffs->mutex, false)
> and see how badly do the things regress for userland.  Again, I'm not saying
> that this is a fix - just trying to get some sense of what's the userland
> is doing.

At a guess, quite badly.  ffs->mutex *is* way too heavy for that purpose -
that's a geniune bug.

State transitions in that thing are messy; AFAICS, the state is a combination
of ->opened and ->state, and transitions assume atomicity that just isn't there.

All updates of ->opened are process-synchronous; the nasty part is in the
FFS_DEACTIVATED handling.  We don't want it to coexist with ->opened > 0;
normally decrement of ->opened to 0 gets us into FFS_CLOSING immediately
and follows that with ffs_data_reset().  In -o no_disconnect mounts we switch
to FFS_DEACTIVATED instead.  On the next open() after that we want it to
transition to the same FFS_CLOSING + the same call of ffs_data_reset().

open() running into FFS_CLOSING fails; that happens until ffs_data_reset()
switches ->state to FFS_READ_DESCRIPTORS.

Things are complicated by ffs_func_set_alt() and ffs_func_disable() - these
can come with ->opened being zero and both contain this:
        if (ffs->state == FFS_DEACTIVATED) {
		ffs->state = FFS_CLOSING;
		INIT_WORK(&ffs->reset_work, ffs_reset_work);
		schedule_work(&ffs->reset_work);
		return -ENODEV;
	}
with s/return -ENODEV;/return;/ for ffs_func_disable().  The point, AFAICT,
is to avoid deadlocks from having ffs_data_reset() called in the locking
environment these two are called in.  At least ->set_alt() can be called
under a spinlock and ffs_data_reset() is blocking.

Another potentially troubling part is the check for FFS_ACTIVE in the
same functions, seeing that
                        ffs->state = FFS_ACTIVE;
                        mutex_unlock(&ffs->mutex);
 
                        ret = ffs_ready(ffs);
                        if (ret < 0) {
                                ffs->state = FFS_CLOSING;
                                return ret;
                        }
in ep0 write() happens with no exclusion with those (as the matter of
fact, that transition to FFS_CLOSING holds no locks at all)...

