Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C1DC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10CC6B008A; Fri, 18 Sep 2026 10:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9AB06B00A2; Fri, 18 Sep 2026 10:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0DE6B00A3; Fri, 18 Sep 2026 10:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 960A36B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:29:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1C171206B9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:29:48 +0000 (UTC)
X-FDA: 85227116856.22.BED2FED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 581824000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:29:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=niy30VT4;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741787;
	b=OcQIhPppfPD7ItK0o6Laztj9EgX/y3495vVoJRs+I+P2VP4id1RIBaRBPJ1xr97DID6sOx
	D91vV6stQfY4mQGaJi4JE6KsM1+Mvk3oe8ohilRGZ+ZvhnTGG1UYiiW+2EQxoARUw0hNjL
	FWZHEJ9HefXbWp22ROM4CLybqXMeBDU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=niy30VT4;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3spve4byqYzWkhtX7Z1uSwfKm3Dog4UDZegAdsYF48=;
	b=SHDvjOCzEF5PYaaYwK7D8HFKdjmuWCKgI3jnbdx9DvatutZakmSDidTXq2CrsWhp4OOIe+
	/k9P9gs06vurSoy/zd4iZyM/StXdZZgNJ+ldO6TtzeriDWwsZfjavYDsZwFii6zBjNv7H5
	VKA6Ge0b0ab1fCli+9VtrXPRvqVu3q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0316E6022B;
	Fri, 18 Sep 2026 14:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B521F000FF;
	Fri, 18 Sep 2026 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741786;
	bh=C3spve4byqYzWkhtX7Z1uSwfKm3Dog4UDZegAdsYF48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=niy30VT4DpS3IqJE3lE2Y38gqFkVE24N7haV1aSclNsAlIay2KKYOxlSYTspkkKe8
	 /oSj6ITWVBwXnyYHbckgRQdDTisYbCE0wzuyBwPxWfanIu5FxNvrSm+lqNBJyCURL0
	 HYLuktP6BDmXqLR7kL3FXIapydJQvdHSUWIYAurv4EKg4/i0HBfEXVX7mzKi8nLfA5
	 8O5nDFCa2ycK2jLsOjwY7bZTygYhMbKDlstsJx2oyBQnEXZIsTjf4H7XEEvCSEliYo
	 QYxVYcc/9gVGUkb3Jbq8vWklRjnbyAwuRpDOFxF9+979ek2oywaWuWTD8Mja64awcl
	 0FhnLa2vmlUmw==
Date: Fri, 18 Sep 2026 16:29:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aq0_lvHDViIpX_Mu@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 581824000B
X-Stat-Signature: 9scwrwzsum5iq3wnhuxq1zzygzho6c5y
X-Rspam-User: 
X-HE-Tag: 1789741787-739996
X-HE-Meta: U2FsdGVkX18LlO5DHAdIxDVrTcx7uB9dGP7zCiUE3sdWM/ywxxa74bjatJvwdXfexZz6f97YSBHdlJtgOMih6dX2GhHqcEvSM2DuOSPKtaCzC31xyeeqli/sD1YkMw/3DlPu5UG5W9NG9zb7FRAEe29fOJBJjItdJyrFVTNl73JBWuWI/NcCTCZcahau1O1Y5pYRjwND/w9XNW5KvFdwVNGFg2TNErZDmDyGeWq/RU/m8yVj87vMNMQjxbZnpJKmkKFIZ3J207pah6q0LVaXgHYHMeBp37+DlloQkYG/L7uP5qWIQsuSOWwH6kL8s0QrrZ3nBT1R7vyPr+HybrHyI5Uu4rx15616iW53YtL8cANVusRbkEEDNE7ymGQbu6LAhMRAGWYufGAfQwFZhgHyzKbacxKJSB1FwziaX5fmSSXtPFyXkKyfi/X5ppCdrOmWUg/EjwUWeR9xsKdhbyHeIX2s3EN8lOx9Vs2nJ1p5vwIq2+2RcsdxfRfXfJ3o94XxProxqu7gpVHaN9LpO5F1Jox1CfJU8qnYm5390HXEupZtX1gtoegfr4232rqBi1wJoHYPovk9n3eiXFFkKBhOoXPIQjWLg3BY1fcakroSrFBpVcxt3kJFOP+8pLOKz3WKSaAbKljVpv/MHazNAdnWbDM6FzWr6su9GJFfr4kV5AS6Fb+hAzPEGGk0joqzklCJzow5RFABcODc3xLp4fAWiYLJ6fJaMyseFVZaG1pTPWZBYm7Yr/HfQysOZULXRcFnLS4bTBE1Y6SV9wq5CFxlthrWRo69mJ3upqcKT65QhvcUg8jKt+aEk1BfJAEgRIMQmn1QXE6Tp2287X78e9RiDx0jLSAXEuje3lutPbas8BZOkXn7Xxo07XbTeNJGgOlascpw+Yq6lCvlowIDLzsTgESJnYwgjiJo1liybYZGAkVI6OvJ8RcJc/mBGy86EJuiSq9+XWKMwqXzsdKl8X3
 0EkkPppp
 RbrQClDGl4J5nDgorfCHG4Z++JhGbtMjSZJALNBlTf9f9YKL6ApPpfI+azZzypffMv+ISOQPZ8djpfSBGd4UBFA1FXHlLBF/oPgREn/q+A5xrGMvWHWMHSu80RwtX1ETJRv55dkHyhV5UrDIf5YesPftMIS5u0Xd39tUvCWuPA5ifKFEWgMj8Jdjc7QgT7UifxgXei4sMaN5Ohn76GodnAqifYJTtSleEv4bDOwAYF+1H50y/CXa3ncTbacaEIEiocYIp5lRPvgwYkWECghfNMzQrAS3CjqagCJCX1mydlBMItli0YVtuobeQfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:41:42PM +0200, Oleg Nesterov wrote:
> On 09/18, Christian Brauner wrote:
> >
> > I think this works but they also need to check ->in_execve as the
> > exec'ing thread is obviously never signaled:
> >
> > @@ -2709,6 +2707,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
> >                 .user_worker    = 1,
> >         };
> >
> > +       /* A creator past its fatal signal or in execve gets no thread. */
> > +       if ((current->flags & PF_SIGNALED) || current->in_execve)
> > +               return ERR_PTR(-EINTR);
> 
> Ah, I forgot to mention...
> 
> Can we shift io_uring_task_cancel() up, after setting bprm->point_of_no_return
> but before de_thread() ?
> 
> I know nothing about io_uring, not sure this would be enough...

From my reading of this code it works.
The cancel runs task work and any create_worker_cb() queued before the
exec can still create an io-wq worker. If that happens before
de_thread(), that worker just becomes a sibling that de_thread() kills
and waits for. After the cancel nothing new can be queued.

