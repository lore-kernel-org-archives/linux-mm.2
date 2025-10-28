Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7F5CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 15:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AF28016C; Tue, 28 Oct 2025 11:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202498013F; Tue, 28 Oct 2025 11:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FE98016C; Tue, 28 Oct 2025 11:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3C538013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:36:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C7F1A0373
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:36:48 +0000 (UTC)
X-FDA: 84047925696.06.A8913E0
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id B91CB18000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:36:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761665806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dn+J543PaE9pTtS4VYTKUNcdwvzPCZNgqy59cfgNWrQ=;
	b=yvGvZXX05jKQ9tGK7PIbbUMhcFabsBrsT1sc3PAN4DP1JflI2+VLEk2WNgXzdnpb1GJUY5
	zDKLKsL26EEvRsHw0E2T/ekUfQxqBltMVL8nM+L4FEZUR5M0i0KycknkxbFakuEprJ4X9M
	vaUfoY9+YAwrhd8C/rT/iz6nSrm0ImY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761665806; a=rsa-sha256;
	cv=none;
	b=vIYPVnSmnN7cFI1SXFnHHGS/FAtJN/8QMUtQ6Jklf3jYOTdYSsf7RwAOefSlGiTWoxx4D1
	J7+5DwBfSBgePkdQeLpGBqXIwgcq9mS9pRc2lfb5Eyfa1Xur+VFo9dbY1ww3zqzApk5Flc
	9Va8s4/wZGcVXyu0ExtgCB1n2AbwZZ4=
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CD0C1404A9;
	Tue, 28 Oct 2025 15:36:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id A321A2002A;
	Tue, 28 Oct 2025 15:36:39 +0000 (UTC)
Date: Tue, 28 Oct 2025 11:37:17 -0400
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
Subject: Re: [PATCH v2 19/50] convert tracefs
Message-ID: <20251028113717.2154482d@gandalf.local.home>
In-Reply-To: <20251028004614.393374-20-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
	<20251028004614.393374-20-viro@zeniv.linux.org.uk>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+s7gR+r9niKNL07T0pO7ukE0upf2CD5vI=
X-HE-Meta: U2FsdGVkX19g0bbaz2RZh320ocW7TSQSsOT9nF8qHkd5qWlBifJ/KGtfmWtsv1mzJP9ht/c5mZRt/OtFwhvV0nurLgOmsL+MgJEwJdQoabvLgqWyyWgPOtUtslgD012XhVqixajC5WLifrc/mNIrsi899n45JcxWb92Q20WFBPjq9fbMnMjzm49UpPMD39et9NXHIuTp+8ue8LHJcfY24Tb39Ouk2tY7I25w4L+/k2xiNhHBjQibW0Hpw7CZthMHcDOEtP04RbMR+7OcgsAvcilq3cwXqyvP6wxxoNA77oyga0E0P4NCRNz/Jj7XTabrxjt2M47rWHelMrTtE3Ho2LOneBwKq0YQxYsBKf09n05la3UZdYBsNJsEB3vTPECvtqDSIEN0Vv1VQdzkGQVHiqH5dArBachPtpebDDmuJAfLPjsP32VD10VFGrg/VDlo
X-Rspam-User: 
X-HE-Tag-Orig: 1761665799-59606
X-Rspamd-Queue-Id: B91CB18000A
X-Rspamd-Server: rspam03
X-Stat-Signature: wwtgrwiok7ucj6dfj48fehgm57npxp5o
X-HE-Tag: 1761665806-170732
X-HE-Meta: U2FsdGVkX19YNQXh8q1QgS/GYb8JsJW794V4cU6O7Z47csY9+sVFZm5i3Fn+/kJkd3hvUL62lt4OpH8jqE7EeIGchhiJyiLpnCJR5fbkLT4junf4MrGRIXYxiGiQ09XUR67qscfgfy+n4yHfG1R1U8Hzeqkpl9UcraaunwrThBBW5t4cBaxGLiA7+wYRA8IcXN3+dztJkzSQCSLj5xuOSmrcn1rXl1RLYFffOy2bse0OSRvvNMgZ+3emhbtyGJFE1JZuiOAjUbyNJxylRipKrQlbQzJjo/aaQ5nX1rUoe/U8M4FT4HX3eAz8da9e+CraTc31Y7T0Rytyb9p95vmsBTMYhLjGf/MDVw+PSMTh6xK3crm96MCO6el1uIGL7gpNCGJzujgfeychb2w+oTh2ia5Nbc50dK7MasdPdJPT4uO7VW2r2Fh2kNClaAwYhOD0sgVhTZsdWgVWBX0378pnbQvQ5OZfM1CPns5qJImMDeEEh17sEFO8fcDgs5hp9U9r//UAoJBnpozpZG0HH6Xwjc2/xw1WFcx5VtenutCWvyi1FVPEQLB7lKlL5gdNqAwN/bXc2xLBklW0FOC1c0GBIzk3PvjT6gYFKIsEj3wlxw3ZSgvzArI/wCQf30xasRe5iQ5JwgcC//jNjaEYGP5AcbjhzQaHnS7AWCT5TptbWrX7M/6i9uOFzgW34fvuB29sw59wbnO/RTyCegbOnh3Q5XADKdelxMdxw3Cw6k/TG/ilWF+IJKwU+ckIOIRwikdoaIZZyw5A+6lup4K8AqamrpJMi71uSg2P6WFet/rwEd+G19zrizZ5MPSF3jox6guLkFPIoKRfNkMqfPV8RftQrHp/DevYMcj56ZaNEN8U21hb+VAJYBYqhVRla7+VzFVwnOhKNJdTCueBi+NYzV8hiA91OXsVvJ5ZDP1pMTIAUb5pTExMFbxhpLNQAG10wHXdc1MAo+dAwc1vASlD9vy
 YQA2eBBf
 KWr68Uaxdpq/XU9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 00:45:38 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> A mix of persistent and non-persistent dentries in there.  Strictly
> speaking, no need for kill_litter_super() anyway - it pins an internal
> mount whenever a persistent dentry is created, so at fs shutdown time
> there won't be any to deal with.
> 
> However, let's make it explicit - replace d_instantiate() with
> d_make_persistent() + dput() (the latter in tracefs_end_creating(),
> where it folds with inode_unlock() into simple_done_creating())
> for dentries we want persistent and have d_make_discardable() done
> either by simple_recursive_removal() (used by tracefs_remove())
> or explicitly in eventfs_remove_events_dir().
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I ran the tracing selftests and some other tests I have against this and
nothing interesting happened. I didn't run my full test suite, but it looks
sane to me.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

