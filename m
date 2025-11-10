Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 898E3CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 21:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEA88E0008; Mon, 10 Nov 2025 16:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC61F8E0002; Mon, 10 Nov 2025 16:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC548E0008; Mon, 10 Nov 2025 16:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5E198E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:49:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FE885835D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:49:43 +0000 (UTC)
X-FDA: 84096039846.18.20A313D
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F3351C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:49:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IrYkqZ/o";
	spf=pass (imf18.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762811381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFirqqcYt6xjzQLvnHeiyd54+NIBXchkEuHWoh2vuEE=;
	b=1rsRvqsWwjvbhs6go/yqz3659/jxVc2H74bygwQ7qOa/mV22Gk8vnItnvE7+6Dv26Mb5qd
	xf6r6z1D6ZC+l3uPLIJR8+XIOJAkzylX6AFRiI9Fw/Yiwsuf3mmcvI59ygMgBrt3DbcURD
	3Io51gJC9GBDZHVs7GhueJQ6T74jtvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762811381; a=rsa-sha256;
	cv=none;
	b=0Lw7N6KEnyY3frZVO7XIbi8NkpKXfm2tsQFs/PI1cuImvVmEefCjKDzvWW0eMggZqNw4e6
	L/ImQ37t3Cg8I6RHdRZ6bmYeTW4pcr9c+wcTipoPyX6hW5PXtDSt3IGE7paF70UXU+ZlQH
	fgOvsK4Gtod9536ueQAsciWRHnAL8IM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IrYkqZ/o";
	spf=pass (imf18.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5942ee7bc9dso3404323e87.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762811379; x=1763416179; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFirqqcYt6xjzQLvnHeiyd54+NIBXchkEuHWoh2vuEE=;
        b=IrYkqZ/oH82FhAFi7Jo4nyAWfkbzFmka9iyzphK5PdXCqOClXNyYDI22RWPzl2MDB3
         9c+UnzHRlQvw0jVcyJeY/TUpgnT+XhPdFaHZ/885G1u2jXYFKIoShXfwqcYcfuW/7jW1
         KtFKNlfU7nCVKnFF1Jok79zQWvil7zJ6WNKtllzA4WNVDfzIgdSTkdkk5Ck9LIlXqYGV
         1dM18nZ+PxCa148cq7KmISfN8XjXmkKwm1KonRKXHz0Ke76xcHmKxgX5+F1O4rca0V2q
         Y/j4iezlp+dD2sx49/jRQGeMZQIaKsLa0lAsleJHXPZh6Qz3Vuxch3dPILj/QIS/x98K
         QDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762811379; x=1763416179;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RFirqqcYt6xjzQLvnHeiyd54+NIBXchkEuHWoh2vuEE=;
        b=B8r0KxEuaqiYDshmk2tD8AsDcrMC+A/CHPQ/vUzesyEPKjmEJP9hHsWZBPBroah1/U
         4YEqYzTcHj9GAuHnkqSlvVt53gPcTLCk/RXcAQDlm7EWLCu0/LASRSso9mxj9fRNHncb
         XLR/KjuWLYsZZma6LCLiQVNTP3ZIUGoSeo7s3NhMAFbEEBnKIL0jClTZOQuPDGlfI4im
         dk5QkqhyPNyy1jY72fW8TeXRkdRf0NoDOBk3zJwwMNNjtWxsNUK8p27lunQS57MFTHrm
         X685ZH1V9QBGpk5HuUL4gE2e6EGw6PgMnSzIgxkC2Y2oV30hya7ygjei8CNZ/v/sS7n7
         AFgg==
X-Forwarded-Encrypted: i=1; AJvYcCUXKx2KPhyzWD2GLsOZghk4sD2ZFp8keLrzMtTNNxxyuXDAi6xog30Kca/1sJlVVvVIFnC5VVa1Ig==@kvack.org
X-Gm-Message-State: AOJu0Yz+QpwCObOYw+WT5uLwty/WoBmm6kntl52wqA1dcHEi/vmteB1T
	aqdKf1dvc0c9yPI3x+q/MsiqO4E8Gmz8fsgbIHByzxCYC+nLV7xHLlMzte0Qtw==
X-Gm-Gg: ASbGncsbu7cO6c75gaqAYfC5Y6L7uR4sOCJWlH08yvbbAoKmnoxQ0rhQRQgAArouwV4
	8GDSAgXBFW2YDat8/FI4/bBHsUEg4geOrnyT/LOv4oiEFnfV/v3tYbwq9KkQnSkI5AbCl6BqkkR
	g8I4z0PQEs+7GnM1Pq4KmWJut0oNh/5W0x8s76T9SvrE88BzeeazB6kQogQ9HSrW9rtkILlc/z2
	fVOaSDbiuynwQ/RAQTSxv3uJ7LomET9tau4a5NEei77WmGcB9abg+/6VTLktxFvUqeMrbuRbZyL
	8qR7Nx/tW7wPG3WjLm0YH0F/n1W8kLeNTF5sm4cbajmsgkPvB7agSN5klRhHRdoJ//Hup2i+qO8
	JCeCgoe4SRxhjSZZD33FR+Kqn4G+ePVu6Ffo3nPfNkLo62SRSQ1xwjBWMcdr9FDLMVY4jgjx3lm
	m0wg==
X-Google-Smtp-Source: AGHT+IGjkYEZuiIm45qpRwthPMBOYrneNAO2t8mNMUlpQZhecV1r6b86jhyyoGDLr3xqW66ODHKdcw==
X-Received: by 2002:a05:6512:3a86:b0:57c:2474:371f with SMTP id 2adb3069b0e04-5945f1e5562mr3111337e87.45.1762811378727;
        Mon, 10 Nov 2025 13:49:38 -0800 (PST)
Received: from grain.localdomain ([5.18.255.97])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5944ff427d0sm4115144e87.68.2025.11.10.13.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 13:49:38 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
	id 93D625A0033; Tue, 11 Nov 2025 00:49:37 +0300 (MSK)
Date: Tue, 11 Nov 2025 00:49:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] exec: don't wait for zombie threads with
 cred_guard_mutex held
Message-ID: <aRJd8Z-DrYrjRt4r@grain>
References: <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
 <aRDMNWx-69fL_gf-@redhat.com>
 <aRHFSrTxYSOkFic7@grain>
 <aRIAEYH2iLLN-Fjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRIAEYH2iLLN-Fjg@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F3351C0007
X-Stat-Signature: q98yhuionu9ny9i89f5j3thensdkr4qw
X-Rspam-User: 
X-HE-Tag: 1762811380-693259
X-HE-Meta: U2FsdGVkX18+zDyrqOig4kgAA5jhrJi1H//6HRY9r/4hYMgJBjCZylu6/cXfbeGWVtROTsS4K2hGh7Gxjx9+8y3CFgAlu4kDsXL8H1Dk/WLTgfjXaj2s9Tyt0LMIHh6zmeN/MAqKjJn6vsGrzdba3T9Xb4gBovuUPKNewbWrxvnJelU8AUbLy7Chr+cDemim9oz+nzs8S8m1FcuFtE4I79XFqOGCXK4mllW4Yr2ImyWYsq2lcVpPpLqHv5UtTW9J1A8ECD+Onz+iFyF8NnOtmn2Y4BkYS5OTePaN1vu4jMaxKok1M7JpTMsvCT7EwS5ee2ghKyGrVxOvAjlhev3OwV9yw+qAsR9zeiMVXJFi6nUqu9KXPCzia4LYaQLb2oKTbnJiqnup0jiNwdK9oG3WEGJeMzGvW8Qmwq4KqcwRTTcnbF5nnlU4KheSR5uHWu/vpvSiVoj8ASilz4L6XmJgmwYO50hccMKNIa1rgtDE7lQLfPjqEPvJaC3cfgABI5QSVlzYEAoHPOfyZE0EvrIrUNhNyz+Ce77OPg5LEWw4pTcs9ix5R8iQbTjmIFnCkJLoNJCK8yK2Uf+9BhkvqtpEFULhdUOrSxyEu5BM8kpe7wtJ3v67zOqyv0xmseZCZF7aVuvfx2qlbIybaMTWYU47r6G2uMs9oQKGAuhaPQZ+hGLzhgb4t4xa94Xob4ExUE2bi7iE4mSgeA9gV5LdUq67mgSz4HlbTqhrJY8DVbK5u5Jkkc4bZGSzXbaTxyMj69CbBv5JznJxGRwOxkTyEiC1eI1ct/JUW9VpXP7vgHlGx3/4MDHH+EvZmCsjlHg+Vhi+faXHJVMBw1nYJLzsMucM30xPRuX004swMy0dJJRWpDFIWNOj9X5JhLPrvQIk2vKEbM51zdLNY9QjlXtIzWWysu8kaL83pTb/325LpbUdwWNLALl5ARDMC3qdgFQXAifCf6/Snbiw17GZDv4/0ei
 XoRnC6t8
 xSJNtkuJBTEHjs2x6tLxSMZGl4zClsWX1riHkkRrW6uJ1arJId1wbMlPXM5VDi9uO5cr8tFsLKJORhsvpKf9ysY8JFps6IYuv2xFjWRH5I/9liAOouuyQjQ4bJWGXUJeSE1m9LMSz8N9QSwvLOAvFYN5NFJsYiINv9Bvt/Jc745xWJ5YGEZkDKBkXpEvMmuBZ2JVFmdFQmufx5J5tD6d7BOxJRO5xtNf0iQQKSBu9AbGriKyJ5jhRXO6QdxNrdyeznJt1MbAXikcnwoQI80ZH0yUHoyLoIUThmCryhwnbUMy7LK34fAGd/eV4QEtA9wNAx5X5xNMNYJhi7VBibxs6GrpxVJ7h++T9bPaJRa7F9SFQUKDq0MF9UiLOVuiCzzCH7RjWThuvxvTUUdhAX0XFG1ONH2LwB9cMyyIeH0PUH3ggNx0Rz8C51xaV/TbxKRW+8e+oVNOdLWg47DoLzfeIeFn4biadBLWZ+98HHx9afJUIUGjgbllcA8QgbDq0KhU9JptYv+0wUiTiOVjOkxjK/a6l0nWxxE1iRiRd0+V5OILiQgxRbx3WCxd2yLHyA7ZqRxrzGBgzpuANGrB06GzCUEUale7Zq/NepBHx8foXOI0vCg2l9K4wh1W/QSBmhbZKJG84
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 04:09:05PM +0100, Oleg Nesterov wrote:
...
> > > 	if (!((sig->flags & SIGNAL_GROUP_EXIT) || sig->group_exec_task)) {
> > > 		sig->group_exec_task = tsk;
> > > 		sig->notify_count = -zap_other_threads(tsk);
> >
> > Hi Oleg! I somehow manage to miss a moment -- why negative result here?
> 
> You know, initially I wrote
> 
> 		sig->notify_count = 0 - zap_other_threads(tsk);
> 
> to make it clear that this is not a typo ;)

Aha! Thanks a huge for explanation :)

> 
> This is for exit_notify() which does
> 
> 	/* mt-exec, de_thread() -> wait_for_notify_count() */
> 	if (tsk->signal->notify_count < 0 && !++tsk->signal->notify_count)
> 		wake_up_process(tsk->signal->group_exec_task);
> 
> Then setup_new_exec() sets notify_count > 0 for __exit_signal() which does
> 
> 	/* mt-exec, setup_new_exec() -> wait_for_notify_count() */
> 	if (sig->notify_count > 0 && !--sig->notify_count)
> 		wake_up_process(sig->group_exec_task);
> 
> Yes this needs more comments and (with or without this patch) cleanups.
> Note that exit_notify() and __exit_signal() already (before this patch)
> use ->notify_count almost the same way, just exit_notify() assumes that
> notify_count < 0 means the !thread_group_leader() case in de_thread().

Yeah, just realized. It's been a long time since I looked into this signals
and tasks related code so to be honest don't think I would be helpful here)
Anyway while looking into patch I got wonder why

+static int wait_for_notify_count(struct task_struct *tsk)
+{
+	for (;;) {
+			return -EINTR;
+		set_current_state(TASK_KILLABLE);
+		if (!tsk->signal->notify_count)
+			break;

We have no any barrier here in fetching @notify_count? I mean updating
this value is done under locks (spin or read/write) in turn condition
test is a raw one. Not a big deal since set_current_state() and schedule()
are buffer flushers by themselves and after all not immediate update of
notify_count simply force us to yield one more schedule() call but I've
been a bit confused that we don't use some read_once here or something.
Another (more likely) that I've just said something stupid)

+		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}

	Cyrill

