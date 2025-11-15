Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA20CEB2C6
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 13:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B498E0007; Sat, 15 Nov 2025 08:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562DD8E0005; Sat, 15 Nov 2025 08:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478DA8E0007; Sat, 15 Nov 2025 08:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F04C8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 08:21:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB70E4DAE9
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 13:21:40 +0000 (UTC)
X-FDA: 84112903560.10.4BEF871
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33443C000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 13:21:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AuInizII;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763212899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjAcPjiET4P3fr/sVoUSbva9CVqQr8Uwew0Z2DECgqQ=;
	b=ka2bUjrmTpTOvzwHK+QTQL7zeAWoDzgOnEpZ8UO5qGAyy/r/fZ/3m7Mzn1hg3u373dg/0G
	ooeaG3i0jXRFCuaxhWSvWJYoPJlYfbYeoJG0Zx55qRi3vv6ibnayQaG8kdPEUlzJpdjGmi
	3lUIDJ08MG6TqsckNRrIQMV5XTFuD7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763212899; a=rsa-sha256;
	cv=none;
	b=mgVuT/jhQCOHEBsorm4xmHJ91YAqf5Zuq73yBFc1qHl0LS75wVpMBd1bcMGIhzKU88qCrC
	Qvf6jpFh6hHZkmbcQCm9rRZrm+EeNxzv+i8ZcqJsHSGfkznWtvfy5uJuGlOdZhHPR40yBt
	K7EW1yBQR+ZhSzGwarpPH2zmV1geMG4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AuInizII;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 771B760131;
	Sat, 15 Nov 2025 13:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C00C16AAE;
	Sat, 15 Nov 2025 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763212898;
	bh=Pl9jmC5EL7AGwr+SmsgthHF9drWTTfIqBaIssfzsdWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AuInizIINMwBXTMJu1dR3seLB3VmALsUQ3+5Ndj4MXto6uH9ENTPXUU90Dt/8DjPq
	 gmWQkfEhamMufZT+G9MKX9xDtzSNmpoxmmi+AH6rv/rpdY47vOYkLaC2Ol/C4V7Kfc
	 vAlEaytoOD6Xr7/mBkMwSJH6iZ7zuxrbmPJUjTZw=
Date: Sat, 15 Nov 2025 08:21:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: Re: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <2025111555-spoon-backslid-8d1f@gregkh>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114074614.GY2441659@ZenIV>
X-Stat-Signature: g8i4d1bzhjgezogp8zj531msimm8hknq
X-Rspam-User: 
X-Rspamd-Queue-Id: 33443C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763212899-478706
X-HE-Meta: U2FsdGVkX18/OInN4KGKHQOd5hibhzbDyMx9JHdkl9dCc8qUdxuQVTXgQejGgMR+Afi5zi5EiKRCrG2uAo+FMtoQdM9VileRdOadCIfFYV8UH1x/Hiqii6/SmmFtExAbd7HI8CAhICZxT2Cs6PIoDRxAIgdlfZgjPwaaZbXgN6OV4vuETxhkJ+ua3I3uyl/h++uusyiLAl2VS0Sr8byJdWxvfSK7KfUq0LoRd+bZGxHTnjcqE3oM4ZXwA9X3aiw26F12KzsA0mvTDDcvmFpksKD85mPhKzyh3wWK2w5anzhspO/nULI05pQEOfBimhMdGq59ZyYmSfdXsDq/zoMg27mk/hOo0DO8A0QWhKTEHOgbYr5sqS/+Xw0nes7uwmOu6ZfiZ/JCRCRNx8tddbUan9B57sIqjz5QZGv211qr059I/NYmch18SnEJFksSrEklWSdINuWmzjbqJEKmZaLsnPTcWB60hnQ8fE/tLe0U8GuKNif+3VYLXhNwqOkr461pvK2CP/UE4NqpxGns3zmRJwEvNBFIlZD14z2VlSDLX5YmB0YK6wQcDpm/7ywXW9z9A14k2WKUYdqbbBKAOzSQWMPTts41GAGqsJ/y1TzC+N+x2Z49xD6UzSz0vLyXiMeng5J1o+tEWEf1IEREAqJ8OLg0iFc4B/f9ezWUAvd2rIMU6aUc35F1alm4Wnqhui897AthgDxlZRMsvb2ZiRMpPXy3NLjlzdLuKNh0NOEhataVD+kYBacuJ0tIftJlY9OPPfcKrnr0ZWzm/fi6IxIOAjTOy/WHd8v61D3L6P3WLE0jDLpwTCEXvH20JEZpRfHoQeFEpOYBsZ6sl1zBzcAefmxZPt7IvfM6Tw2eeBHmpTaLf1QftioU3b2i3H+WBySLWk3hqGk4yO3oPW4vVqWHgj209azotTsJwnOwkevaUW8NNF7rrnPFPsbHHnqosdPUNLBaBG5cK2YgKRJMWSR
 fukXx83M
 jjxky7e+RAa7hIb3yZ5YF/PRumgncefMLFG+TIeYwdnvCP/184fYSIIJORunIIgMiO6k4GHQnM2VTZxbh7jVeIbckRD17wj9ihNPIYNrInbmiU8SZx7rUezEbvXOz3MtO2QZL8Zr6hFiQVBHhM8/CuO5YfM/ao+hvzSvQd3SoLP2aBZi1MI/tgaUioyMzPny5YZYB6EhmgQrYsEIT1D7tshgj8TjuGq+i7gQHz4weq74sxGEdrNS6YQOgIxDMX3otbQ1SECUGS+HqWY/ARwE6ctQXXkdqhMXkt3fEfw75F9M/vFvO+IWXRcZSzMqbBBG63GSuoaMgDbBdZDvkJx5zpxfQ9zqyAgNZ4cNNFQD3oUhhTj0EsD2/uYImjojSQ59fFV4e5gsKjkjZiHRm2NrKB97n85hUfxtBJ7upA7GA6TqLNwQcUr8hM5CfgYntzcFV+oqnyMa837Ii24eIDTxO6Uw4fJZRVq4zLWJaxOeVQMGd6DctvtwMxuAWWW8SyOQh15AN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 07:46:14AM +0000, Al Viro wrote:
> On Thu, Nov 13, 2025 at 04:20:08PM -0500, Greg Kroah-Hartman wrote:
> 
> > Sorry for the delay.  Yes, we should be grabing the mutex in there, good
> > catch.  There's been more issues pointed out with the gadget code in the
> > past year or so as more people are starting to actually use it and
> > stress it more.  So if you have a patch for this, I'll gladly take it :)
> 
> How about the following?
> 
> commit 330837c8101578438f64cfaec3fb85521d668e56
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Fri Nov 14 02:18:22 2025 -0500
> 
>     functionfs: fix the open/removal races
>     
>     ffs_epfile_open() can race with removal, ending up with file->private_data
>     pointing to freed object.
>     
>     There is a total count of opened files on functionfs (both ep0 and
>     dynamic ones) and when it hits zero, dynamic files get removed.
>     Unfortunately, that removal can happen while another thread is
>     in ffs_epfile_open(), but has not incremented the count yet.
>     In that case open will succeed, leaving us with UAF on any subsequent
>     read() or write().
>     
>     The root cause is that ffs->opened is misused; atomic_dec_and_test() vs.
>     atomic_add_return() is not a good idea, when object remains visible all
>     along.
>     
>     To untangle that
>             * serialize openers on ffs->mutex (both for ep0 and for dynamic files)
>             * have dynamic ones use atomic_inc_not_zero() and fail if we had
>     zero ->opened; in that case the file we are opening is doomed.
>             * have the inodes of dynamic files marked on removal (from the
>     callback of simple_recursive_removal()) - clear ->i_private there.
>             * have open of dynamic ones verify they hadn't been already removed,
>     along with checking that state is FFS_ACTIVE.
>     
>     Fix another abuse of ->opened, while we are at it - it starts equal to 0,
>     is incremented on opens and decremented on ->release()... *and* decremented
>     (always from 0 to -1) in ->kill_sb().  Handling that case has no business
>     in ffs_data_closed() (or to ->opened); just have ffs_kill_sb() do what
>     ffs_data_closed() would in case of decrement to negative rather than
>     calling ffs_data_closed() there.
>     
>     And don't bother with bumping ffs->ref when opening a file - superblock
>     already holds the reference and it won't go away while there are any opened
>     files on the filesystem.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Ugh, messy.  But yes, this does look better, thanks for that.  Want me
to take it through the USB tree, or will you take it through one of
yours? (I don't remember what started this thread...)

thanks,

greg k-h

