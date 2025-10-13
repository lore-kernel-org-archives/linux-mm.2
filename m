Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CBACCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A922B8E000F; Mon, 13 Oct 2025 09:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6AA78E0049; Mon, 13 Oct 2025 09:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986968E000F; Mon, 13 Oct 2025 09:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87CE58E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:12:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26165C035C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:12:40 +0000 (UTC)
X-FDA: 83993130480.22.76D4A3A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BF454001E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:12:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="rqCxKiS/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jXjc+Sjk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="rqCxKiS/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jXjc+Sjk;
	spf=pass (imf27.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760361158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUuAPVpZLv5x/RKRQlcJZBDq3mhfpECuNYSEtNn/MgM=;
	b=sUntKqksurPI+rGZlrz7u/XxFhwqEhsRt3ac1C3HGNgRLnP6xh4zEVges9KvXGsBxQo5Vv
	8F5jZYfKzc9AWjKPPnyooqgZST3QQoLy8B0yJ6GKeJOuG0OWfVAlsrceEEFa+fIhy2RZ5H
	8/+94AdWvcgDA934WB0/KGlXxa8Z2fI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="rqCxKiS/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jXjc+Sjk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="rqCxKiS/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jXjc+Sjk;
	spf=pass (imf27.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760361158; a=rsa-sha256;
	cv=none;
	b=JzHEVIHjlKGzOhwtRQx1ESrWyQHq/bXbzwjH6TOjB+HQFDUIeS4u2Aiunr8EpInIxiyXiB
	XZdpfN3EFvSKPOgYBIzR/U3OVym903xRRdiDDTegi+DvSACnep8eJJEph+MV9EGdIgRM4B
	GpDyKRbq0ttuaO2EjC1UdxfmiUVfykM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 565F91F452;
	Mon, 13 Oct 2025 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760361156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUuAPVpZLv5x/RKRQlcJZBDq3mhfpECuNYSEtNn/MgM=;
	b=rqCxKiS/Gn/U+/YMsS/R3qNyYIrVdOukE/Q+IHbjUjPlgkZYtcHDm7y4Izu5HwP3M+MqLi
	aCTeDwOwZeIR06C854gj16lDtM337Djb2K4k8osZ6mEomFBe+wfSFKA8v8fp55FR7K3gh6
	qtUzvNHRjUakX9YLkijfyXooBZ6YfSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760361156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUuAPVpZLv5x/RKRQlcJZBDq3mhfpECuNYSEtNn/MgM=;
	b=jXjc+SjkQ3ffSxzkSe80xw4TRLPiLMIKD5GwQMLBqW9fpa9w4q7F2SjSIEw0USCypEwamj
	VW/kTlKX5FA4RiCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760361156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUuAPVpZLv5x/RKRQlcJZBDq3mhfpECuNYSEtNn/MgM=;
	b=rqCxKiS/Gn/U+/YMsS/R3qNyYIrVdOukE/Q+IHbjUjPlgkZYtcHDm7y4Izu5HwP3M+MqLi
	aCTeDwOwZeIR06C854gj16lDtM337Djb2K4k8osZ6mEomFBe+wfSFKA8v8fp55FR7K3gh6
	qtUzvNHRjUakX9YLkijfyXooBZ6YfSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760361156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUuAPVpZLv5x/RKRQlcJZBDq3mhfpECuNYSEtNn/MgM=;
	b=jXjc+SjkQ3ffSxzkSe80xw4TRLPiLMIKD5GwQMLBqW9fpa9w4q7F2SjSIEw0USCypEwamj
	VW/kTlKX5FA4RiCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4A4B1374A;
	Mon, 13 Oct 2025 13:12:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pHwrMcP67Gg+TAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 13:12:35 +0000
Date: Mon, 13 Oct 2025 15:12:34 +0200
From: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
	akpm@linux-foundation.org, broonie@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling
 huge_pmd_unshare()
Message-ID: <aOz6wqdZcEY8-ufB@localhost.localdomain>
References: <20251013093337.4432-1-kartikey406@gmail.com>
 <bab3249a-d9f2-4f19-9493-b7560aecc3ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bab3249a-d9f2-4f19-9493-b7560aecc3ce@redhat.com>
X-Rspamd-Queue-Id: 0BF454001E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cpmw93rhf9yxje34gd6j84tpbacjshqj
X-HE-Tag: 1760361157-580736
X-HE-Meta: U2FsdGVkX1+1LElJOAfUwQTQVFbPQF5FH5h9M5CP9hpXDUNN2Z20UM9z0mMdiznehr74k03jZqd+t1V9FBgiMEteTlTGGOeZL2OV4zq/E6oyb/EuWuqc6cREMcoppv71/Vykb1eMlB6DUetT16ThIAU1b3+kHqnnpF4BsvdrGX0cVrqt1QjenA2b+IHy/DetzGHMzfnQjmuaCYTyjgVGul56SV8+OEEG8nfy7hk1v41SDGigdgu+ZXxYFUy7XIGd8u8fpMKhCFr+qo5f8LMyyaNBRBg37W4vz/7Quwe65hsOBcdxsHeqTErahvAAj9wCetzoYHEONcjTyMs+AxreLUkYwh3sdWBhyFsmeSO97BTjN7E+2Mg3geRk9jfQTGNZVUdhX80mnc1FtYBQCh2F2wFdzk0MzP0kxb4w8E8o/QSuxRh1hZw0s2UyX3elcv1DlZd80lBmukW0l1u5pG5Rf4qaI1nB+bVTO0LwrRtXGN1vH/iVJoKQndw0wpj2tLilzmEUEouwVLly1kV25D5JQWhtgFvWSoKdA87pXCsTeUPM3s0oln6YbBrQ1tNamNZSCDvNHb3okU1xC/9GGoJNAdbaZHXKcDFUVYxRhZTO8HZ/MwhtvtF/M2Otp2/+ux+wrlKDTpvZ10kE+XIs7tuwuiBmFccqKX58NpSVGnM/iw/o9S1ieTcP1ig5WYHmUNYnL3OPImW0coQ+vV0I/gAvEHuZY+TNf5fNSO/wYf940tH4K0oidLZBRAiZSWtjZe0Dkt8hdbAAiumasyyRQxEpS0npFD2Ywrv4QPDwr0pbuDZ0aIyS2rynt3MChh7SrLF2v6yBhEK5B22GP0V1QYpbvvB2zy1Wc03bjqyqOw8gubhH7bD3ou9fVKbLvKICoSN9a+0bcF0QhwLP3b4B5C+fDJCddlasS5lLE8WkegDihP/KVviCEa0DmcDNBSuRRwCPuN9exvq8ogU9jsYsh1W
 wBVGkw1G
 3vY6H9e+KbhS2DpO3lLs2UCNV8q0Hyjl0G/hseiu8BpUEdwXIjFiqCwYgBCldooQrh7jg4ISxs8Zwq4WUZVhcsvfEaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 11:54:00AM +0200, David Hildenbrand wrote:
> On 13.10.25 11:33, Deepanshu Kartikey wrote:
> > Hi David,
> > 
> > That makes a lot of sense - moving the assertions after the early return
> > checks is cleaner since the locks are only needed when actual unsharing
> > work happens.
> > 
> > Should I send a v5 with your suggested change?
> 
> Let's wait if the hugetlb maintainers have any preference.

Yes, now that I look again I think your suggestion makes more sense and
its much cleaner :-)

 

-- 
Oscar Salvador
SUSE Labs

