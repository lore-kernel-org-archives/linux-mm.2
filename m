Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E5AFD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B06E6B0005; Tue, 17 Mar 2026 10:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088976B0088; Tue, 17 Mar 2026 10:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08216B008A; Tue, 17 Mar 2026 10:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF5A26B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:10:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 975741C0DA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:10:18 +0000 (UTC)
X-FDA: 84555739716.06.1888F8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C8531C0020
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:10:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZhiLGEz;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adwNO8qHxeguMqhMooyUf3x9HNZJwla6V4gRdqxEYok=;
	b=tZ375jbljmPK+FMKz4JgHMaHJ9u+FAk+tXxMv1poj4zsgSF6LhAwS8UwypD4nCVIWhRWKy
	CdtV+3GVJw/lGa0mZbbb3U5L+3q2mzfiTKvfVZewpVa6ITnZXjhNSTYtTxKLUr60ax2CZx
	pWYXeb1wvAt62jpMwV+Bz9m22Bb0seM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZhiLGEz;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756617; a=rsa-sha256;
	cv=none;
	b=e+KjnILNWnh1gmc21d2TgKoQubckEMbGBp4VStCuLM/0HMaFASEqy+NWqFE3ERQoyB+RRr
	21OG4fu5Xn4dPcySwSYqZyzPc22MnxDhETVgealZ+Dd9nCl6PXbWU2fL08wXMzfp+SQIUl
	/MglB0foWTpZhP2+DxfNKtHeCHPel5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6133960018;
	Tue, 17 Mar 2026 14:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07FFC4CEF7;
	Tue, 17 Mar 2026 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773756616;
	bh=zTEjYMxz8nxI7sSA0AfMiRIrBlGTsxynyK1A2baWMLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZhiLGEzLelyP2kYF5XxBKfSjB39PAV3Nbe7BvzhKzBGX6Nc+nunMon74QdTj/MXb
	 bSXbnk/sfFBG/ZFWY53aTscpsXIuW+hdZ3L65xaogl+Wuyqncjfjvs3NfS6tU+hJx+
	 ytEfewD4Zw7oYf61jAzAgUQXnKoKPEcfdm6YgTi6WlG29nvWoig32zuHnYPFvMwYHb
	 1wSC4x0Niw6HWwM6J4KDzMJujB/mflaloD70dhr9QNTCwoSNO+/PSDpSKR3t0YO6LC
	 UHqv5mR45/blvKCDW7RAz46pZHqB6T508paAEFvr33bMX3mp7cTr2TVf5wbSh0j8fI
	 B41QWobEubxDw==
Date: Tue, 17 Mar 2026 15:10:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kees@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
Message-ID: <20260317-federn-umsiedeln-3afae949282a@brauner>
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <ablNqvlB9NQlRcw8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ablNqvlB9NQlRcw8@redhat.com>
X-Stat-Signature: de63naku8sezjz1a9o6k7884oa99bwef
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C8531C0020
X-HE-Tag: 1773756616-480776
X-HE-Meta: U2FsdGVkX192eYJb5I5XWxob+NoaoN7QQpb5rM2VB7JVYBJ9bAhbxn5rx08oDRbU2fJfyPhX6knslDyuz3Gn3WDTKb0PGFPWRX/oOAKDRwWiEFBu4+iTI7v2+8O87k5TGxSXrXtUjws1zci3GdsxVTdUV7dsH9POAFyV2Z+vm3T1n9E9Bx52Ud46kzmv2Q+xAwcobSv8YFKM/BKLAitk7PekS8n6JbkAczZfn964ipxMspVRXykztniN9mKuGYLgWt9F99l2gMnM8DGBQ2R6GUf2+NpjerIKBEeHBp20u+pmSPdu1LNxa35EAObnSp/YK6dVXe3mtb/rO647+hpwQ618f2CnXhRhQ2VmshyekV/wCzbmwly4TbqU0xb5qSkfOMC29lJygSBH79qFvIeY/ohkbPYt5k3LQv46hQwQ0sL1GUKoQVzdE3HvfGc7RWx8YTkoyoSVfssc4rrBDqb7QLOCLAEzA//Gv2g1VtYKAgt75UK0/XUFTrVkXR73bLPr6VN4uol1SfBCzgQaRUE064Jq+lTjCaIh0aDyzwHAsVM7ZfTD46ABi/zvRWf0+LGVb8jSjS1kysyPmTYSJm1dM0BRgSTwpEH9JzLycbEvFQui5YyYjWNk06YyGPSuSpZU7GCjB7pT6zIchwwcESRe9eVluAad1r/ShZHsLKTEusZvdh5i8SiFdwVIcuWgjJdvGkauugWwWkI6m9pXT6I4eNGnp5V7asHysT16hZgImB5T/9EWRxeTjTnuOMGoMK3xupF1AkQziGGvQTRiwa+iZRWEgL/nMdXJQyrKA0X+n6xj4XIjQA1mUQhKOu7mMEdWQ41T71/6Z4EvNQbDxz572xWYSTC2p1KfRMSBSQZrQGFBOubXjPIAgwXdE5PYQjD4WGxavhiHYnl3J0U6zLZnDqO9b3jup5TQm9rrQ4TuwRgC/1swXR8rKFfdRJHsepZRfT5HLgod2lYsxOMODM+
 Eo4gwrBg
 f7eqC4dWOVDMzB8SqwsUFI21z9ods1LCqZZi/ijypoSyXnVKqvu7rP34rFo15M05lpyAV7zPLJy3xggeQtcitxF5Uq1DzOhVFcqYbge1L7Ra+q4jX1PELB3R2fwACuNg6VR9oPmLbmVd6fXKlApmLh8DVaRFGCoPcA/DY6m568KEsJYYLEj3vADT0zXui4mk2MEd2UaJkFX8W6V40gWDmpdhDTTsADjS9vstr3vBUiKBpseiDpYDWr8H1t3Pm9sTYP0iA42DJ0plw5H6ICjaQVT6KwF7msfo76XVKYOxf571thb2ycmd0Na2aoFmUy0NGWc5uk5ap6D49xmzcWA+kDj/Bue/zquGzOvsZMJ4ST0GIFNlSvi4Jix3hLhfiOE9RkC4W8g3LQJRct7L4AkndF/W9zuoWov3g3Tw2M7Jo//5+Vlkd8uvzQsNhDygCvnWElWRP8CBlSFeTe4OI0O2j4WibUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 01:48:42PM +0100, Oleg Nesterov wrote:
> On 03/16, Deepanshu Kartikey wrote:
> >
> > Note that this is a user-visible change: previously, passing an invalid
> > exit_signal to clone() was silently accepted. The man page for clone()
> > does not document any defined behavior for invalid exit_signal values,
> > so rejecting them with -EINVAL is the correct behavior. It is unlikely
> > that any sane application relies on passing an invalid exit_signal.
> 
> Agreed...
> 
> > -	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
> > -		     !valid_signal(args.exit_signal)))
> > +	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
> >  		return -EINVAL;
> 
> I guess this can die too, but OK, this needs another patch/changelog.
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> 
> 
> Andrew, I will slightly update the changelog and resend
> do_notify_parent-sanitize-the-valid_signal-checks.patch
> in reply to this patch from Deepanshu.

I'll take this via the pidfs/kernel tree. I also have a bunch of work
touching this stuff queued there.

