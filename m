Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160D3CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D8D800F4; Mon, 27 Oct 2025 21:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED6D800E4; Mon, 27 Oct 2025 21:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AA4800F4; Mon, 27 Oct 2025 21:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F24A800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:14:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E30C887C31
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:14:32 +0000 (UTC)
X-FDA: 84045752784.18.4D46C4E
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2414C4000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:14:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761614071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zAtvblnyhJ9Yl46nm7hwWBBHx0i4EpLuxlHngY/39qo=;
	b=13igdcF0gHZyGELbNmDeWkAlIND9b46dSnb2xxtlDOPLxtRjROZXhljf71VtfTGgSkatIg
	YxVmSToIHOnYDGPx8QxER2mTM7GYdZJe1n8YqKa5jTCNk8/ZcuNKg+s9wYqLHZIWV0uKnp
	TU5l9ydaHDHgh2vczVgkhOGYDIfpOxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761614071; a=rsa-sha256;
	cv=none;
	b=5xIzGUDOTapHr6C2UsUn8INRkKRYnrirQkpS8MiPy4nZtGkep0QpT5CbWoahhNLRKJBU8q
	OaP15wTkfMGiYZzvaYoUlWNLCylfexuYK9KxQoovwOBxrWpTsifIk9+9hZHNxWWy/G62Pg
	W1UOixxjV06ja2REqPjwJAf8c8oF/ms=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12D8A12A5E4;
	Tue, 28 Oct 2025 01:14:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id B058135;
	Tue, 28 Oct 2025 01:14:24 +0000 (UTC)
Date: Mon, 27 Oct 2025 21:15:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
 brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu,
 neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org,
 linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com,
 casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
 john.johansen@canonical.com, selinux@vger.kernel.org,
 borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 02/50] tracefs: fix a leak in
 eventfs_create_events_dir()
Message-ID: <20251027211501.1ec4940c@gandalf.local.home>
In-Reply-To: <20251028004614.393374-3-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
	<20251028004614.393374-3-viro@zeniv.linux.org.uk>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19GTe7PKSAfAGlbt/zS4ZGC8rcOFjmyEK0=
X-HE-Meta: U2FsdGVkX1/G1h3gGfRooYvnXx3jiT0AwrBONfXuKy3eeIhUbLFRGxNdBXPDpG/5ncnLD2Wi5bI2V9h+KPnTFqly0Q7VErHQu2q25ySYnNUny7DQWnj8sQCkkGfdWbi/bua2gd1Vg0frbF65fQ9/rH9lMpLN/+yjp/Vvtw1+ic2u+9OP9IqIBCHUSVaRSxDQRiidgj30RK844jt+AK/UFlJ9gl7wzbw6jqw/OkARt4qz2ow1hPKmVkDosJyejXNCzHhjgqGnoD0TuFx88/ym7PrOpd+IGQq4/krEZ6R626JFHE2nA2hzR9aU7tXEvFNqkK/yNMiujAAkUAQ+eodxQUyFYdHjihtmjcWI+LhUwkQvR3fTh7c3F1AI5fHutu/+k5BuP5JJRzbLX4ISmbC6rhojJVMm7lNjNjOrSwZtVdzqO+33uq5OHXe7VMnZNZ5zUTeXJ7349odfYLfXhL1Dfg==
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2414C4000A
X-Stat-Signature: juqopd33f5mdw1n3anbbk6zy8yxm73yf
X-HE-Tag-Orig: 1761614064-363610
X-HE-Tag: 1761614070-314186
X-HE-Meta: U2FsdGVkX18fROolaU7mRgVx53xCTqX3sS5Aa4+ZDv36Cpd6EsDDta7VyxbSse+C+f6cihAZ7ZbkGM7nH9wB5hYojvFeKcF3cTs4IZJT2zhzsXDeL3mrCAXq2Ok+G7RUSR9+LPLFWN3G0vlQLk58H9AxMHmp96jfoPCp/OWrZgeqiXnHLpFbuhDpw0DU4ovz9eQwgJblHPetFHTtYv0Cau3DeKd2Btf/w+HKrecHEsmrpPvZclN9vrbHXyOJ+SUcn5dc2LMIW6/RY808BHKKAU1ksF61Ky6bocO6fM7raUkWI/45xIR8iaycgH8XSN8M1v4sEWMgwB/1MqU213QMD1Yf+fr9Sc4GFZ8EPai2BWuY7Bhm3CP+A5L7MLzoGOjqc2OtA2uXdcnZ4L6YM6OBzOBQtrQwWBr4Ti7nHD2C5XKSiokm8MYOzWiyss54xxBeoVJXQSLhzVCxIxM6+uuogDsyYi9KCP4E/xRNv+cwJMO7YIDcCap766zRwdYh3m8V9kysR0rciCkUJtelbXMgCeG7cx46dGYkDCKJUQInFrDahiONgnLqWKlAwGpf1+EpJvw00djwTAfK0+TdUDVglLgfAeNcMnyHjOLW92FD0CXmb1Uce2F4IyTUd3p2oHnhZKId+h4kReIXyecNrvlS4QLTesJ3MjQarpOhqTvmcVmOGFw1zonSAA+xsjYXqRCoqRCBK+3a8Gn06cSP1GiNjKQY35iCHEctsjBBIvwsV2UrvTmAWrJOKS9UNNupZGp7Gr7PDrETaD2ejwgs14qw/BczNF+ttr3LQDyP7MtkHShHATJD6nPClrJpTXJ/Xk5shS3Tv8PAUg3Mu605oIm60gw6lWf7YHBJO4eGpwZfXzAx22IiSuS25M4R/wgrlvSM1R6PG/AFjU7JHh6peNoF6LzkjfFWw8WpJ5amW80ZN39QUGo44fKfSJWvOpBujsEF3+3j9NwWyDkMAW0Yelq
 prISFt3E
 eg9Q46ppd6xGSHsvUuY/NBSHqDeEboSL//EHXz2GypG2UOJN/RN6rksvfYTojoXZGedxfo23rGPP3Nax4upyR1miBSE1fMx/f5cEjmMDyhfN5Adgb9srL5yQ5Cw2CKJyqNTAV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 00:45:21 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> If we have LOCKDOWN_TRACEFS, the function bails out - *after*
> having locked the parent directory and without bothering to
> undo that.  Just check it before tracefs_start_creating()...
> 
> Fixes: e24709454c45 "tracefs/eventfs: Add missing lockdown checks"
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/tracefs/event_inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

