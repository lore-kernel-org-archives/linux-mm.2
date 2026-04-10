Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78665F44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EF66B00AD; Fri, 10 Apr 2026 10:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E836B00B2; Fri, 10 Apr 2026 10:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934D56B00B4; Fri, 10 Apr 2026 10:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 831E66B00AD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:03:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4399C1405C8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:03:59 +0000 (UTC)
X-FDA: 84642814998.07.A562430
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 693DE140025
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:03:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FiIZLPmE
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829837; a=rsa-sha256;
	cv=none;
	b=WSGU+pv7iaWAu8Xw+8huCOKf2L8fDcnx6otZeNm4PGptsHajQIqS/IGXUn1Hk24mpCDeDw
	xfaiQwE5UVRZweSdooYOUWLdJCMZL/B8sDZ+2Uw5Zv4rJDxB5w3cKxuv0/XemBt8gHNsFm
	2g+8bvPKfvMBMjIW560bVmJDzIaW3Ic=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FiIZLPmE;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u07fAeMble8DRxQXr390mZRhSpEry1623RqnFVFFlts=;
	b=FZNxcra+8L3+AJ0r8IvCsdQ6PnOf9875lBsBReT1MKQ0664UmOADcoxRIoK5s7KzAdRC2D
	RRNwl5eZgj3Utv0DGbonzNZwZeHUXkcdeT/cBYnE3QpglHH4G+ZDSbvJlI6BU1489LdwEl
	DHCZLGdHQ/3Ag0YyublC5Gzcw4fF8E0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u07fAeMble8DRxQXr390mZRhSpEry1623RqnFVFFlts=; b=FiIZLPmE9vXhLmIvq9nU47rz+d
	Xq9utxOqa7ohP95zKw4udUp6qC1POyYZVdjayitrRJRTp7tG91n64oaBTW2PicsxWFDP/zxemGFZZ
	OFPuGLR8DVi8RPv8bDSZsGWBnaCnkQEJSlQ3GPumsrmf70le7ApsqQtzciAZR+VEHF4ZVN/Hzac9V
	/KmfRHSN3sKVSOY4ShHzazNDBdOvQBQzM3BZ2MJ2Z8qKvfP4IKjOFQJOOC5b42Gq6oW2uV+1qD4hg
	/vFgEV9AZj8OepwMksyA09u4Dm801kUVpZrHjve55uJjp99R85B+MnkS6lzb66pWJ/QEMcDfO2nsO
	0lvOsFeg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wBCSc-00A1tG-1w;
	Fri, 10 Apr 2026 14:03:50 +0000
Date: Fri, 10 Apr 2026 07:03:45 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
Message-ID: <adkCtR0LzJ7aWfm-@gmail.com>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-1-9e40d0f64f7a@debian.org>
 <e074d5de-f494-4995-2521-32de4f2bd34f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e074d5de-f494-4995-2521-32de4f2bd34f@huawei.com>
X-Debian-User: leitao
X-Stat-Signature: nzrndacqgdy7pjhoam7najweswm4eb7a
X-Rspamd-Queue-Id: 693DE140025
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775829837-740498
X-HE-Meta: U2FsdGVkX18mglmKGe0R+m0q4CQN4sUQ3ceLnmTmobqed6B+Ukr6Q4/CF2fJXp+UluFTT/qGkzdEp7/ClJDHUlvO+6EweF5WZd2fjBgVK9Q4THXCY/lyuT92mVVHdTiVtVrGz5JuELu7TKWjRjFTbS6Z0GXbU2arwuWhwRT984u51JzCVJNx8LH38C/rOwX5ughJctiBHFTKP7ERLsR2yeiao1MDHFKfhmThTrGvb+sJ0/jsrOJEABrVUI8aT7nBpCFA8MjQnNQ9ec2vDeY8nhubaRVzDTxhhXSj4QOKGLNrduZes06FYTyXu3ra9y4xj6DrHMSdcOKSS1b0JJoWf7jRyHwcXQ7M1LnUp/esIPq3uFn1zx0u/pISnDPKACSxBLsnPjC4K69fCD9AQvfAWAbvQkh0B9zNTYUJXW6NVYW4ibJS2N7L3WzENIA20fQoM0pUmGZI3SE8g7ngEf26MBSWB3YtGXNhcOhoBSNh9Mmiy5S9EU1+sScGR/rBZxB+Bs+iTtyJcU+8aZCC+Y1zniwU5glBld4BM4RbCc2XTPVlHT158J/RscseAnTGbwNdtMv14u1ThYhyL0ScX5/PuWgZVwXE2Pl1/JHRv/LDn3Rw6YFgp5OM8vurmz3pGrgLkeUDP7+wxpMFkKf8nN4yZGRPAdJD1aOJj4CjAxDaTF7LtGtyW4C2FYZ7Eq3p3P02y8BvKloaNi3lMuv99vLzKPHe+9QDkBKCf1LatwdoLerkJQHG0BChdDch4wyGnnzEtfo+k5Odsn7TphXqwdFal1725dn9zDyajuS5fRt1RCt82APAffI59eoH2IK8BdXTCKFkS0ZFnJusslNx8t/LGhGNIxqb1JrKRYtVYT8N9A+wCEkdAvpWpiHybrjKaaWZX/cTZQcRwmwDHTrWDx+eQCOV+8Jng8CHqGIWfvlvOZ145HLhecWL/TuPDwkQSKiIBRvyzlYIEaoeYazWnGx
 WJJ+gRfT
 ElYG3+4M+6C/xar6nM9Jql+omXh7po4j9zzsKcr+hOUeIbNcaszoOOD8Jp6l0iZ9GfC4kXcW5PdkkUGk05pcuuJlURBuir+JiyTpoDZ5jeUumLcBHubm/9DmxCIz1V3aO4AMp5OBBigyA6LKYtRL/SIuTcDUk774/7wDGKt2BA2J2xrQcgXyM2Vrn2Ttww1x0mrb8+0Adhr42BZ/bJCrMg9+Wc3naydphHsZnhPCtmlu3gianinr8CHkkh0SQaeZr9JDgVjor5lagQsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:56:39AM +0800, Miaohe Lin wrote:
> On 2026/3/31 19:00, Breno Leitao wrote:
> > When get_hwpoison_page() returns a negative value, distinguish
> > reserved pages from other failure cases by reporting MF_MSG_KERNEL
> > instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
> > and should be classified accordingly for proper handling by the
> > panic_on_unrecoverable_memory_failure mechanism.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/memory-failure.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index ee42d4361309..6ff80e01b91a 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2432,7 +2432,11 @@ int memory_failure(unsigned long pfn, int flags)
> >  		}
> >  		goto unlock_mutex;
> >  	} else if (res < 0) {
> > -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> > +		if (PageReserved(p))
> > +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> 
> Is it safe or common to check page flags without holding extra refcnt?


Yes, this is safe. At this point the page has HWPoison set, preventing
reallocation.

PageReserved is an atomic flag test on struct page memory that's always
valid for online PFNs.

Reserved pages are inherently stable (kernel text, firmware, etc.) and
don't change status dynamically.

This follows the same pattern as the existing is_free_buddy_page(p)
check a few lines above, which also reads page state without an extra
refcount.

The result is only used for a detailed classification, so even a theoretical
race would not be a bad issue.

