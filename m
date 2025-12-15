Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE2CD5B861
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 18:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906C26B0088; Mon, 15 Dec 2025 13:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7FE6B0089; Mon, 15 Dec 2025 13:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD216B008A; Mon, 15 Dec 2025 13:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 681A46B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:44:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E561F13A93E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:44:39 +0000 (UTC)
X-FDA: 84222581478.23.11DAB6E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BA8FA000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:44:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qDTmPg5e;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765824278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAiqOi8TZw1rLsOvihPpKeP29wCvEI8XhvAaGda/QfY=;
	b=O94hAWHiV4La7yysGTfVKYheRhswbx79eGZ+VUIlAhW+iXOIj+n7XNNVJlxB4eKaYmG0tY
	0LSWjcqZXw0zgOMqHmRwf90CHcnpCpoa+5LtCcU/zTalEdJuDNOBoLqf+zNIpJz6vEGXmh
	jsYwEXba4D297NNUpRWjqiQcKoT9Fdk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qDTmPg5e;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765824278; a=rsa-sha256;
	cv=none;
	b=5WGjthaY66FCorcQadgbnxDr/PtQjjCnVPlKtDIDSLMMB2499XWvpQgDpYhEE8ejEP1mLu
	Vt7TQZt38SiWuIzLbiCs184Px8BklLZ3OUIJYcIJDax7fXqasO6RwvDVZTxcmVVPAavRC2
	ffxTPmc3JGN+cUkP/pKwsTsDegvmsRw=
Date: Mon, 15 Dec 2025 10:44:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765824270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAiqOi8TZw1rLsOvihPpKeP29wCvEI8XhvAaGda/QfY=;
	b=qDTmPg5eAfzImsbkCVnJoL+ZWsGX7DVQAmkvf2J5lFgLf8K/vtsuohQG6Pn8rxzs6qVFmN
	ToqkuRf7vsk1wTj7ayQKmBGt4OJQv6qCeNMxQEeWCsZaYfGaoLpASp5OMHYMB5nVI/eQpv
	IrIN09eHo6UExBTzxmN3hl2Q1RK16uc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] cgroup: rstat: force flush on css exit
Message-ID: <imgjggr6py3746i3bclw6o6vwktchw5gtt2pylilvftc7dqr4a@ywvoxalg2xbi>
References: <20251204210600.2899011-1-shakeel.butt@linux.dev>
 <hjxarrg2jy6cyy5hptjjbkop76jmb6mjdcazlcyqe6nnaoo3l7@7amn6gdssmeg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hjxarrg2jy6cyy5hptjjbkop76jmb6mjdcazlcyqe6nnaoo3l7@7amn6gdssmeg>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mmz4n6ajnxpp3ppnfszh7uzcbujrk4a1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BA8FA000A
X-HE-Tag: 1765824277-760017
X-HE-Meta: U2FsdGVkX1/v6S/swWgN04fhiqvHHE9xgs23jJjt8RhpqnsM4UqXYW03r5PaAZ4Sy/OiVVF+E7TVojoEvILFKLJkuOrH+oQl5VvpG7BMPTVZ22wLHwedw/z9jGkToxzcPVR0+oEDsqms8JgJKggMRMFsONUwpIyM5l3Nxq+komTbmjI6RSyqaRaBkQfvH1Womh9Wz9PADEKpnXFy5WOoR/4RsEePiPtwaTGI5RwhtFTnA85CSoB/5YohHhM6jod5tLOAMVe4HvTr2wHNlgcAWSoYSIMoMNVz+XW6NQTZmtIjF0u7I9wpzGcNrkz9SMlV/4gDO77boVZjbN6PgWQGDqphVm/x+WkfrQL4X0m822z0BQtg8jG6aPI2xW7onxrK8JAztusmUG4iK3QzHbwr5S1prsdTd43ASGWRKWDXC1i60GXPLhFmJfwKFCBWiFzPFqe8672cRCF2cc4Jh1GUEjMLRU2ZAizMI8hPBoQCMo1qR2d4WGbIczviFrbfrF5k/66blwYJiI1gnQT5mcTQ+4vbQXAv0yVMoflRTE4NB+EMxUh9fRrjixL08jm6KTdDOhRO8IUb9HMPaUxAMw/MpulWrp0wuCvQXZs5UynFvht8aIEHh+kl0rTxKMd4TW9jCPVYf2Pst5KEb9tshb4zwTvzliFB/vY3RrxWeRx+e1EDx3MNfl8UIIQt9MBBnIDiqi+P7AmrQZBmIv7mlWmJSPe9y1i6L8Vdrn+5xnpJfuHg6SjeS/2NuEAlFQan/OguJPVSv+hyTt6SPx/jRU8e/4X9I9Q/NBBGoy8itKdKOVMQ1UyxJuuq2lZZYKQmy66EA1sAF1T/AHXxYfG54+CEysZm4bhIe0rBz/aDDnAXM53F3NJZ7zxsbSgaJrprkz+I5TgtlDnleAnB1JPBaHCw5IzxaimSxJy85yjhNwcwee6HUeX8X+aVPMqZqp2OUoG+hIBb94FgWtSB5C7/KbV
 8dbpX4aB
 Ftign7QkF6okm6UOo96lwd8xGZpV50tGDqUgIe8mbKJm6YfPygt5Q3pdRBpPdi1u9UxGNPT16nD3gyWXhWFypeDAPu+9MS/RFbOQO5xSCRHpkF1ANQL3RNRKlsJt1Z81qnRaTrZ8POi87nHx3qcP1VGaT8TApE11z6/kCXyfErorlk3EyF32YL9loeocliHgdelDqfuZKR26jPlNzonPF8QfmloH79pOJf4fDIrXZ/Hxd2MM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 07:35:30PM +0100, Michal Koutný wrote:
> Hi Shakeel.
> 
> On Thu, Dec 04, 2025 at 01:06:00PM -0800, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > Cuurently the rstat update side is lockless and transfers the css of
> > cgroup whose stats has been updated through lockless list (llist). There
> > is an expected race where rstat updater skips adding css to the llist
> > because it was already in the list but the flusher might not see those
> > updates done by the skipped updater.
> 
> Notice that there's css_rstat_flush() in
> css_free_rwork_fn()/css_rstat_exit().
> 
> > Usually the subsequent updater will take care of such situation but what
> > if the skipped updater was the last updater before the cgroup is removed
> > by the user. In that case stat updates by the skipped updater will be
> > lost. To avoid that let's always flush the stats of the offlined cgroup.
> 
> Are you sure here that this is the different cause of the loss than the
> other with unlocked cmpxchg you posted later?
> 

I didn't see any stats loss due to this specific case but I found this
on code inspection while debugging the other issue.

> > @@ -283,6 +283,16 @@ static struct cgroup_subsys_state *css_rstat_updated_list(
> >  
> >  	css_process_update_tree(root->ss, cpu);
> >  
> > +	/*
> > +	 * We allow race between rstat updater and flusher which can cause a
> > +	 * scenario where the updater skips adding the css to the list but the
> > +	 * flusher might not see updater's updates. Usually the subsequent
> > +	 * updater would take care of that but what if that was the last updater
> > +	 * on that CPU before getting removed. Handle that scenario here.
> > +	 */
> > +	if (!css_is_online(root))
> > +		__css_process_update_tree(root, cpu);
> > +
> 
> I'm thinking about this approach:
> 
> @@ -482,6 +484,15 @@ void css_rstat_exit(struct cgroup_subsys_state *css)
>         if (!css->rstat_cpu)
>                 return;
> 
> +       /*
> +        * We allow race between rstat updater and flusher which can cause a
> +        * scenario where the updater skips adding the css to the list but the
> +        * flusher might not see updater's updates. Usually the subsequent
> +        * updater would take care of that but what if that was the last updater
> +        * on that CPU before getting removed. Handle that scenario here.
> +        */
> +       for_each_possible_cpu(cpu)
> +               css_rstat_updated(css, cpu);
>         css_rstat_flush(css);
> 
>         /* sanity check */
> 
> because that moves the special treating from relatively commonn
> css_rstat_updated_list() to only cgroup_exit().
> 
> (I didn't check this wouldn't break anything.)

Yes I think this is much better. We just need to disable preemption for
the assert within css_rstat_updated().

