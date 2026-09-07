Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA00C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD326B0096; Mon,  7 Sep 2026 10:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5FF6B0098; Mon,  7 Sep 2026 10:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBF86B009B; Mon,  7 Sep 2026 10:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0966B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:01:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23357C01AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:01:40 +0000 (UTC)
X-FDA: 85187129160.19.49FC83D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84D5F140011
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:01:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZDItgF5;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789698;
	b=3GRptpepCaidYe33hhyc44inWMxFzS1mOL4HxsLZ67t4L6jHUewOp2Iv/hFOdNbq5yaQbp
	Gv9flo8uNcEqcb2lGv+BZmHzu7OAtYqyLCuQiVuVa7wTpHPWMUhS+BtQPjV6wCrWw8+G/W
	o9WNW3G0tGJrhQSVF0QnDI3Zv4BTRAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CT/PRZLhit2fRIl3/YwuJ8bKg1BMJtfb23DmTmMzVEM=;
	b=GGv1jdUsb3lS4fSB09dptObk8N7VhSXNswpO2DsnxNMs4zVh/89c9xPCS01GgZ8AwN+KMK
	y3GRcMRPrl1g1gue2MRpjGYYxluBXJpRnBoJrz598E0C5yceElS3otfNzHyqf7Iq96RVY+
	QxDNIm0Da35NIf4DXlMDlHn7wJLPKhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZDItgF5;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AC8160D87;
	Mon,  7 Sep 2026 14:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E131F00A3D;
	Mon,  7 Sep 2026 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789697;
	bh=CT/PRZLhit2fRIl3/YwuJ8bKg1BMJtfb23DmTmMzVEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gZDItgF5lu7ObJAVqpHDntSxEo5tnQSW97w+OS3wzeszJHbYiCLfnRHHpSFXM9pSd
	 agr+j+4sQa8+BXS0SCLYyA5/yGk6soH2cY4y44jMqgxnRDm5+u0+B7HQHKCwPu9YgP
	 OwwBtmiqO9gxxGTzNrEIn+8/do2+xJw6XuCOFijbQ7nS61OMGxNQ2o/Vp+amWYf8zV
	 p/tXJKpLX7czlW1NVpT5cOKHcnUrynpMW7OxkgfmCIIUsjrqbPA53GwVtjOiG8QcYS
	 I0Q+7FlF/WKakyEpCFfKJ7oe1btbCA7Km89/UDdOpKf1uIEI0XBsirEGbFRHzkmjmN
	 3cK2HvEfdSQHA==
Date: Mon, 7 Sep 2026 15:01:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, andrii@kernel.org, 
	ast@kernel.org, bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, 
	eddyz87@gmail.com, kpsingh@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matt@bobrowski.net, memxor@gmail.com, 
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com, 
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v4 1/7] mm: Add copy_remote_mm_str()
Message-ID: <ap7CocZyy6K9QYMp@gremlin>
References: <0e4edfd3-0c82-42e0-ad09-19ff8b8d1511@kernel.org>
 <20260907134101.424017-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907134101.424017-1-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84D5F140011
X-Stat-Signature: d4sdgx7ntto87f1j7k3penb6ws1grthb
X-HE-Tag: 1788789698-652151
X-HE-Meta: U2FsdGVkX1+Ttrdi+kyOHrNpQ6MGLHDCCSfak6yoYBbfDepJnKYnKcVAc4PzTxtYiMiEaUQL3nU75YjTmWTVFJrZ2tGUdfF5iWbqVorugVEvoHFROfEL6Oq3l85SqxYr8FCk0NRVw5vgHMzoMqYJS3PnrQj4po169tONNhe5fjEdHWNZAFUAC/4pkp49IWk1UWH3XVa5UiJVw7iSUHgiMNZSb6Lkd6yISjfQVPpza/cT12Nxggjhc/qQwXf8cA6Ij7uQXZF7cTZ7CPXcPWzFKqz+mqQjvcqRPsVBiUh0Ssj/qhoCAra+GD5H6MmigNlb38zNWjU+POoYaZWuE0SKPIr3E95sTH9dNToEc5t5sXM/y4mN/HOr9fE2E2OVpTVBHhqwbDK4eE9TE7VR280etKANvScmQrMz99nmN8fp6nOfV14C+WxSV0yF9LJUY6oIdwmea7znS9dz1kMZrBSPfVP+TIUuuggqRr2qpvOoKqs4iLPzivLPcI9OSYwWNtX4eUE1tBKDgPZmWstrqrb7qPhQ+Gxyr+pNYE/36jH8y3quN0FMnzKZuOotha64T/CnnxHz487QtsYT1OHVttbvqIThKOMfVixsOazcImeqKcZ3sGzlqMIVqkVBTfQSnQtKU7d35pB3lrG0iGM6Dcd+eLPEz8VLey+12AWi0768/8NCFnIcl/n+rtevJwGHW+6QLYegWcfpFQbTmer2R9VP9PeTQv7+3t/w5/tAJrIjWgmHdip2qufrYHwL8Rb4YYwLTXGLn78OgHld5MOk9bD06Q3p8ZOURLkCFqgiZvq42gx+Ye5WKKTrBmVGWSU8LNLJU+XaY7w5MDtUxHwLWz81nFB6U07N1/wGBM0O7NrS4yeXmO3EMAu0cAwYDWdu6atI8MoiEEkJABodK4K2pTNv2pC7/Hr+uqcxgJ4gEW5hq8LbUIC9nmVc9sOg75IaPpiMGOkPsoLL5G3CKWV/J1M
 YFlGx/R/
 8iCZq9ZQxhtSN7tgfQsgauRqNnNMw595wr0WECN7RtkgmiOg4aDiKjdKNE3V2t6eUrN80uMWFaOW5yH+hxUP2h7dKSE+p6gP/rVbjOJIKdyS0zmRnD5hBQ71RVku9JbnU0Md4vDZ1f0iuPBMB6r8hmX/3WQ0WKtDbAP/iS0SnVct9GDEpzcXr16us4Q3h6XAf1T5VtnRzD1Dwm41uPikDeBx5MUpfD/rXQoSZVoqa8PktaqxDBu9lebUWEsTjlJsUZMJvAb66/g6Wfl5amI77eVySXptXUcQOQEp5Xbq/dNRFPlCFX4Xorwk56XLSb+5AvUVUjxZks6bx3o21owLtuGGcD90flib7j6atomz0S3O6lhj9RaTpdHNwZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:41:01PM +0300, Anastasios Papagiannis wrote:
> > We have this check in copy_remote_vm_str(). Why are we performing the check now
> > twice?
>
> > It should either go only into __copy_remote_mm_str(), or if there a reason to
> > have it before get_task_mm(), it should go into copy_remote_mm_str(). Same
> > applies to the memory.c case.
>
> Yes, this makes sense. I will fix that.
>
> > What's more annoying is that both implementations of copy_remote_vm_str() are
> > identical, and both implementations of copy_remote_mm_str() are nearly identical
> > (just dropping the gup_flags for nommu). I'd like to avoid duplicating code for
> > nommu.
>
> > If we could export __copy_remote_vm_str(mm, addr, buf, len, gup_flags) for both
> > cases, we could instead provide a single implementation for copy_remote_vm_str()
> > and copy_remote_mm_str() e.g., in mm.h? (I'd prefer somewhere else, but we don't
> > seem to have a good git for memory.c + nommu.c shared stuff)
>
> Another idea can be:
> mm/memory.c: MMU implementation of __copy_remote_mm_str()
> mm/nommu.c: NOMMU implementation of __copy_remote_mm_str()
> mm/internal.h: declaration of __copy_remote_mm_str()
> include/linux/mm.h: declaration of copy_remote_mm_str() and  copy_remote_vm_str()
> mm/util.c: shared implementation for copy_remote_mm_str() and copy_remote_vm_str()

I mean copy_remote_vm_str() is tiny, so maybe just inline it in mm.h?

get_task_mm() is available from include/linux/sched/mm.h anyway so it's not a
problem to use that there.

>
> This allows us to remove the duplicate code. Does this sound reasonable?
>
> > Now, that's also not completely nice, as I don't want us to EXPORT
> > __copy_remote_vm_str() ... given that these functions are "#ifdef
> > CONFIG_BPF_SYSCALL" could we EXPORT_SYMBOL_FOR_MODULES?
>
> Now copy_remote_vm_str() is EXPORT_SYMBOL_GPL. In this series, we use
> copy_remote_mm_str() without the need to export that. Why do we need to
> consider exporting __copy_remote_vm_str()?

I don't think that's a problem, because all copy_remote_vm_str() is is:

- get_task_mm() (already GPL exported)
- invokes __copy_remote_vm_str()

It already requires that the caller has pinned mm, and I guess the one key
difference is you can't pass some stupid parameter like NULL mm and have it
break.

But if you're kernel code you can NULL ptr deref without anybody's help so :)

The other concern would be accessing a remote mm but... that's literally the
whole point of the function and we already export that.

I guess the other thing is mm copy_remote_vm_str() is only available if
CONFIG_BPF_SYSCALL is enabled but that's pretty much any sensible kernel config
so meh doesn't matter really.

>
> --
> Thanks,
> -Anastasios

--
Cheers, Lorenzo

