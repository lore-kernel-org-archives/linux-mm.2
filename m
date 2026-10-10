Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DF7CA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 22:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303036B008C; Sat, 10 Oct 2026 18:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4196B0092; Sat, 10 Oct 2026 18:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA226B0095; Sat, 10 Oct 2026 18:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED2B46B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:41:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0E02160583
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:41:05 +0000 (UTC)
X-FDA: 85308188490.01.1179699
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6277220008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:41:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0QT7R7+T;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791672064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgR2xZdk6X5oV3TG2BzN7g/AX5fGjkbf+4nm1DsKlzA=;
	b=d7EJXmr/kJWGFIwoGwL2ZnS8CsRBIf/c+hNmbaTWEhUH0Incp8XsWJMQpXZVTODXBPybcK
	xIkvx9ysEmN6o82AzO0CFtlukvAwxYXkYeloSk3TWMpDlRNSU1ko2UBlx/KoTrF+i7FOjf
	cTd7ArNOksSKl8qwGxn/nyUEigDSq4E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0QT7R7+T;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791672064;
	b=ThrwnAfbgm5uHLfiAV1EqIwrvOtL1z672WR7gDyIkc9yGDWRfaX3EsydXiPteM5e+VWeqQ
	4n5c2LwIKCttRIlU5+hmqyTyWPhhEpWfTzD/yCcNoHOqHavQqSnvWVwVA4LEOcR6Lj7V/e
	2eCG4SiY9FYjQFLbAeY905pfgdQHb+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFE56600AA;
	Sat, 10 Oct 2026 22:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDAA1F000FF;
	Sat, 10 Oct 2026 22:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791672063;
	bh=pgR2xZdk6X5oV3TG2BzN7g/AX5fGjkbf+4nm1DsKlzA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0QT7R7+TEIVPJnDuKf4am6S750uSMDkdS9X+01iyYHcdTPkGhkwexCLnDFhwYzn88
	 5N/4vnM0693/b1SFbbQ/zgbNbXVPysZx0X+KCol4fmgxEP86nXNOjQYokCiPURTpE6
	 brgE/fR82tEQ7zKNmtrlvCTkUeS3jRhO8J2ALjSE=
Date: Sat, 10 Oct 2026 15:41:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Enze Li <lienze@kylinos.cn>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 linux-mm@kvack.org, enze.li@gmx.com
Subject: Re: [PATCH v2] mm/hugetlb: move hugetlb_sysfs_initialized into
 hugetlb_register_all_nodes()
Message-Id: <20261010154103.917270fbab7b73ff28d24d9c@linux-foundation.org>
In-Reply-To: <20261009142010.552614-1-lienze@kylinos.cn>
References: <20261009142010.552614-1-lienze@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xfz8upf4kimk5s97c14de167qbfta5tp
X-Rspam-User: 
X-Rspamd-Queue-Id: 6277220008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791672064-945390
X-HE-Meta: U2FsdGVkX195hlXpBPDLrueXRGaFUP/dNGzuGJuKoRyF8Jc+dWi/fRrFYNlfqTvQLRsd6ArTO2nV1dP4qgum1ZOFMJyybi96sxD+QgFrttfz+IyUW2mirSesld0M4109xWzeMAygdDVvSfUz/NShmppiOX2ckX9MPCVy0EjOs0d7y6HEEqrWB+a6dl9YldNeCnm0nF5/rxCRT5PHL81u9uVI1rZHhyMx1HtF2SCwvLaDyq0+EVpzFqFUwp7BFs8stBfqLy8p0HdlYHIE6bxftGHzd/jrSOA6Rh6g6zhVWcxamDirfExXjnBq/2rJoF99z9oZmjwZAz6SSJ6210zOlcES0Akl02K1++Q95C8Zu7Bn5FFoOsKFQkh7c7+KXbV2/llK7YVnDSGPdhkFOzpGAFymncH3EDy2iQrtn5u6m8yAyEKf57NxkqBEgpxuD5hBiQy0+BjOy3A2W8Zi6YooyyajfyKTCDaRHPbgWVgoTNWBHOK6/NKrivMXpX3AB+Yytx4F0uwJH0cSy34Ut/kMirmXLq8UE/GE08o0KJy90JlMymY6hP23PRuXYl4S6YnftFi6PBLohDKsKhIO3UdTjNOqeysPzyZy1r4PkpWSctJPxUwdBjakPE0vEsLCgukXPg91HfCMSbW2lX3fv5DrYT+jx0xomkpJlQZln+Tcsn0lWbJ4/GW8qeLYj29Wo0VbZk4s50eLtLnYABqbjIfl0mUc6TkQurGmV76yGO4YtI8kytyKz0GHz1LTtSF9szw05Ylf3C07Ruzw3LqBpr9SlcQIt+0FyML+LB9QrvYLaWS/QlP5CdMpjN1KVv2ZQFkTymPk6+iVoTVB4O4BdPBz9b7no5W+7SxC4X1N5g9to/udfZC2BeKguw5A+eqFyPnOce2RnL6VIYs61aj7Lm+Faju3VmofDCUlnYySWmtS8Ia1yk+tgzPh96zlNTLBYd+MVzJ7TM8aRgFv1nkDbtj
 Vsymd9Cw
 oVDNnTziYKYViV5FrOTUkkSlIYsl6e1YWuemMeamx9ZdQlGdQFkEn06lkYcelYj7N4lxv80EXpgajWsp3xNNo84Ug5Os4bTS6dyui6qicsQcjgo+1ssbYOC8GVeC0j18NYPN3hZ+ghoD3qwrPEQ1jtsk0m1FgkZVF9+hgqxZqHIx7Fh4HWjzuFaLIyBeuT+7J3TicztsMLHiASVdWLGi4bQbva/TcWjbnocrjYumMAWrr3gOKGR7VcxankXp1BKVA6AFtPoTK0LfDmbqXcSTFZcP7pQRIYTLw4KfFiFWlmg6+RFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Oct 2026 22:20:10 +0800 Enze Li <lienze@kylinos.cn> wrote:

> hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
> assignment with an #ifdef CONFIG_NUMA block, while the following
> hugetlb_register_all_nodes() call is left unguarded and relies on the empty
> !CONFIG_NUMA stub.
> 
> Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
> before it registers the online nodes, so the #ifdef in hugetlb_sysfs_init()
> can go away.  Keep the !CONFIG_NUMA stub, so the call site is unconditional
> in both configurations.

Thanks.

What's missing here is "why".  What effect does this have.

$LLM tells me

	No functional change; its an #ifdef cleanup.

which I shall add to the changelog.

