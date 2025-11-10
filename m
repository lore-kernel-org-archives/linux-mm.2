Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B609ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBA98E0025; Mon, 10 Nov 2025 10:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BE08E000B; Mon, 10 Nov 2025 10:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A928E0025; Mon, 10 Nov 2025 10:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C12E48E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:09:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8D7E85561
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:09:20 +0000 (UTC)
X-FDA: 84095030880.11.D9652B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id B6F9D1C0015
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:09:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S75mZqiq;
	spf=pass (imf18.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762787359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGjo2w5ITfWj64+3hzmyM5KO59pK1AXWwf9AfiwSZdk=;
	b=VBcrvA8pTjmKGmqgQMholTVUaVJKRXNYzOox3AXv+2XazpapiAu024JkaHfrNAEmyZDlO7
	W7HMn0KmtoOZwT/lmdm/kGxujPNdcQhvRphUe7cfYnfc63aFKcWfB5ql8Wh/OiGPj8Hmhj
	ZjXKeCC04icdaY9GLq82saLFyGuSt5g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S75mZqiq;
	spf=pass (imf18.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762787359; a=rsa-sha256;
	cv=none;
	b=wlytS6zHv8o9YukMi1Xd0Gh95T5ruYl9B2ZSaBUOzzsdUSneRaSae6efSzYOKhGF8IeW0f
	2/eyr1hsfiECAIjf0YdSMKAOov55B/tLOuiwCaXZej7GVcuJhRbmM4IsEp1sHN2oNY/fYS
	JoWGyHA+zarMl8xEDolh/nmILW3NMHw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762787358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGjo2w5ITfWj64+3hzmyM5KO59pK1AXWwf9AfiwSZdk=;
	b=S75mZqiqInSHGw3OUEl7Ox1/OEbBgwOXivf2wFJzft7sJ1r0Shkaa0f/H4MdemlGmdYQjU
	C8WVIH15nzDtg+W1eLjwXLWnT+mBOceRda4Cywt6+IlHFJrG4nSe7zQEJXETaFns3BBdyI
	aJLhc5/aSpfzQr88LrD567y8BRHWjWY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-qUFs8U_0NA-Z5BLaeSXOpA-1; Mon,
 10 Nov 2025 10:09:13 -0500
X-MC-Unique: qUFs8U_0NA-Z5BLaeSXOpA-1
X-Mimecast-MFC-AGG-ID: qUFs8U_0NA-Z5BLaeSXOpA_1762787352
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0959E180067A;
	Mon, 10 Nov 2025 15:09:10 +0000 (UTC)
Received: from fedora (unknown [10.44.33.158])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 96D4E30044E1;
	Mon, 10 Nov 2025 15:09:07 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 10 Nov 2025 16:09:09 +0100 (CET)
Date: Mon, 10 Nov 2025 16:09:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] exec: don't wait for zombie threads with
 cred_guard_mutex held
Message-ID: <aRIAEYH2iLLN-Fjg@redhat.com>
References: <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
 <aRDMNWx-69fL_gf-@redhat.com>
 <aRHFSrTxYSOkFic7@grain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRHFSrTxYSOkFic7@grain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6F9D1C0015
X-Stat-Signature: kz8dgmc33dirf8deynj9awqie1w8p3xm
X-Rspam-User: 
X-HE-Tag: 1762787358-664946
X-HE-Meta: U2FsdGVkX1+zy/Cs7nmhiRs8rEQhQLn0rb7QPpn+XHeOzSb0ZPYaEwdvJltgT6VDXH1OCKNeZmjpYCLcEdj1/17Ssv8sD2YqatO4ofYXw/bgMr2hPbhYjx0rF8/YX0HZBa8x4crS+nQiGnHmjuj54mbhM/tOejaqTAC6zz7EfzvmV1+K+C9ghXqELwz9EqZAclRw5yFZjLhQaCi/BZkmn0+c+ynLEdSfTK/3Qw2+arSeTiQtqtDoEQGiu5A5BIiEOLDmBp2HExcfVZrZnuTikxIAlCknaQE+cVP0zEbLQyDM7otZpSclipZE0SPlPZTd7/PSXMAqwO7dYmXLHki2L8F2VubCoBkokFfHARSm2uXfU+7x/c50lIY0ha0wRjo1JQITJ+43eAITlxhPKzmwP19DVx61UJRKHYLJ0BxvNdXqerCIKmIFhyHbPATz2xgf1n5l3HyZQ0HloZk7mwnD2S5sTY/8mol3Rx3SiYwtpGnP7xQCIImDBwtY05ZyTwtm1ayY7831/6byoZEQYuDvu1aggRcfDIQat48RJaUr4TQQvIoDNi9Etbd4S3iMTG57m8zGTZdFh7d0X1mYxEiRFCTMuuQKMR1pYKS6YZftNj8XG4imvRTk9DQKaCNr8i3m3kpgP+kUikzkTHuyGGBYGiOA0/rIS2V52uyvRDnNca4aAP9CIq+yQXiF+Tw13HmanyxTn0K/VzRfdt/Jv1xMnhttNRYeOpL3I5W7s1+Xb5xSmyZ98KjwrKDmBH4Oe4rB46RaVpVNiChH9RP+lYqgWVDC0dbadxBHeFNJ3vVHe+AOZg+PJEIsWic6hxrXeO8dJRZd2qMVTf3i5QvAHbrJlBpfztXLmwqfJywOfr571AMDW1QlKyNQ4mlRkQ48WIV7MvhQL1lt6zWkxvI0AzhnNqdC5gauITjyKXHgdtSR7JRdJWwfDEp1cDoyX5FaW0ezsDi+0kZthWWcKojLFtk
 +1yvgtbm
 Yi7rHTLnr96X7GcAEt20dbA+vqUCIyKrtvAXmLgCbzYdGUAcin/F1dIhsu0vIy2mHuyqwel32LDMaA9g73OkTrdwUi2byS72FpledlHT/rOnUpQW9UJMB1P6MhPPnO8WTxkBLS6MfnKEkXxcm4Ju5ZewtaoCS9IwoLJzk47YtcpJjqyEYgtkpSK24WJPMeUi0xJlhxfdhRV4+du0jnXsmXDDluz0dhe+ohW5kZbh0pYiJG2E1BpFzPX3Zg17IXrYlTjRFGh6YZ5NKqb3S2jFY44C+20MTVk02R9gU+7kgqEeKNZvspovd9wAy30Hzbbz4Sx40w2uJaDM89dRZ3De8X5TGRHDodhfUCfyx5vbOjH+i8MPmRaKSiKaGYameABQgQU5R/StX7hZibclHsnVBBFE9sRJqALiaA6GWUW83EifPKvT6Yw2O5+kq7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cyrill,

On 11/10, Cyrill Gorcunov wrote:
>
> On Sun, Nov 09, 2025 at 06:15:33PM +0100, Oleg Nesterov wrote:
> ..
> > static int kill_sub_threads(struct task_struct *tsk)
> > {
> >  	struct signal_struct *sig = tsk->signal;
> > 	int err = -EINTR;
> >
> > 	read_lock(&tasklist_lock);
> > 	spin_lock_irq(&tsk->sighand->siglock);
> > 	if (!((sig->flags & SIGNAL_GROUP_EXIT) || sig->group_exec_task)) {
> > 		sig->group_exec_task = tsk;
> > 		sig->notify_count = -zap_other_threads(tsk);
>
> Hi Oleg! I somehow manage to miss a moment -- why negative result here?

You know, initially I wrote

		sig->notify_count = 0 - zap_other_threads(tsk);

to make it clear that this is not a typo ;)


This is for exit_notify() which does

	/* mt-exec, de_thread() -> wait_for_notify_count() */
	if (tsk->signal->notify_count < 0 && !++tsk->signal->notify_count)
		wake_up_process(tsk->signal->group_exec_task);

Then setup_new_exec() sets notify_count > 0 for __exit_signal() which does

	/* mt-exec, setup_new_exec() -> wait_for_notify_count() */
	if (sig->notify_count > 0 && !--sig->notify_count)
		wake_up_process(sig->group_exec_task);

Yes this needs more comments and (with or without this patch) cleanups.
Note that exit_notify() and __exit_signal() already (before this patch)
use ->notify_count almost the same way, just exit_notify() assumes that
notify_count < 0 means the !thread_group_leader() case in de_thread().

Oleg.


