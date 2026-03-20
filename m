Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276281099B2B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A296B011C; Fri, 20 Mar 2026 13:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661106B011D; Fri, 20 Mar 2026 13:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DE36B011E; Fri, 20 Mar 2026 13:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2536B011C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:24:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16982C17B9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:24:02 +0000 (UTC)
X-FDA: 84567114324.14.ACF3CC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 80DD24000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:24:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATswcWl7;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774027440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOZ9iikVb+7SHcLJC20iKdpw/HGgz7IGT2++bx15Fio=;
	b=VroF3IJ5ngfg6c0oV4tkPQHEyBAo4xpECWesBhzDLLgKpESQuyusH1lSXuZsbQZGQwMfnU
	0dW9n7qqkbrk0LbkImgRPOGJhybb2ar43nl/s4GMcqJjtkDN3xPpM2FjBDFrRC4v/5gSYq
	nyI0gtTPXeKo6O3rlbwe5pFw0Lnt7Fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774027440; a=rsa-sha256;
	cv=none;
	b=vI9V9UXlMWgJCwCTxvvJOD5M2u96REVG/KWz11DwfCSpzYra2oQYuWN3qtj72tImIcBXmy
	rhodGfLDQY2P5CgwybtwQRDUTzDLoxd1PMwLUS8geI2Ce8dlxUTFMSxn/O/ggu1PAtzR0Z
	bZDj9ZYmuz2vb6Ik/4ofSPl64dgq/IM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATswcWl7;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDAE43F9B;
	Fri, 20 Mar 2026 17:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952EDC4CEF7;
	Fri, 20 Mar 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774027439;
	bh=lkMH+Fs61pHyUrN0N7PA7Smmgeamo1Ed8V7OOsLNBN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ATswcWl7MXWHHj389gFxOlECgcgQeJYv1wKqdExtZHqinVM8C1iUlLVry9OwlEG+s
	 hQm57r7Pk+ZpJ3t0nw1/vvLOsQgKwispPEvcju2E9P/9JEP3v3yKvGkvycL7b0J2eK
	 ezcqS/hxxM9fVO52XT/cmWkPIx24fW0C1LS9PL8IDJR6j8X/JoZ8s36B+4wxYvx/7M
	 P98bC7b6fLvX4lzSxnJYRzQmThW9ckw1V9os4pxuNV73Z4BucD39QRODtyzANsRpNK
	 4W1hTmWPTL9W0bOriXcoFpQK+v+c1Mbp60aVI67dnQEaAkyxZ6w2Qp0mXlzveN3nC0
	 CSmw5tCHpFg1g==
Message-ID: <b917813f-78fb-4c31-913c-5e343c52cab7@kernel.org>
Date: Fri, 20 Mar 2026 18:23:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] mm: add documentation for the mmap_prepare file
 operation callback
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773944114.git.ljs@kernel.org>
 <172ef809d9976b067bba4cd9d2b78410c6c6d03d.1773944114.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <172ef809d9976b067bba4cd9d2b78410c6c6d03d.1773944114.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80DD24000E
X-Stat-Signature: iswiqwob88er3epq5h63m8csbze9pk38
X-HE-Tag: 1774027440-218973
X-HE-Meta: U2FsdGVkX1+TZqUDJPHXy/hLLkcDzCTSpd3KM+s8odG+8vHsTgvqfjuWCHHcBhEktnAP6Z9WSP7LYLpBODaSnudUwLof8X/pbFN4EKpgqxZHzXipoBfMxwhfyP8F2f6VlVceBbeglqMoz0vQbOKbz8rs4Tb66EcyC0OgMSeEEAamsFalRAKM0E7xrqQPOQTjCGITJH09LKkbLpIcrnH0NKXrs7uVLQ5e01CxK6OALTrgKItzH/rt2ohNB4i9Yia6pPyMVR/Mv9H2uHWmH3PT8HtIzbttmdC65naoT7bviobaTzqrCqzNR4Q6Ia1WaVjNyMspvgjYnc2av0icBEr+7CVPEfMsRFptRjdudou1n+OWr4GI4dojacdrFVJ/GaeJKro5lkGLlPhci4xqjjNwGYVs29tvrtnIO47Re2rha+bKscm2jdkQrmwsUndDyJ9p8IIa3bMi7leuGMBn207jnAslrQ3lvxN9rS7i0oYD5dZL+fHVgV2/E9EwgrVcw9ByhT3QvPeBJze3xthjbuXJnvJmbk6t8sxCBvfdqKiEIvUoxiBnUGyE9xmkiX/cxWzgzBq9r6ATYGNBfYIWDePw0Xhcwv83oGJYBOA9Cgltu4bfuMurOdHm6llS47bj+/qJWjyrVp+CkaGtKIRHiMAxVRvq7fVq/M3O046YwxDAcnS834HEBCfHSwAQKNXD77jeOxHy4IuNRRbxh8sJYIx1i+pIWTPgmTdR92sBQGg0ONyH+dsAV9qK2/ZkaUpoF4pc5Imiw4baDfx9uhdWTXfWswHjTbnx0L4nPlvTzPLzilAOxXHYl5SyzfLOPuwxyQNAFjkYQPSJhSm3LKLaH/n5bOWuvF8dVE1OlyoThysrhT8rmPzAHurKSmUgikinHBAHkdxrT+dIZGgTQEPP4NJ6G6ITpSyj/DvovtEz/LCGUO9ZuaYcqGhgx3OcPvCz6FD4GMcG7+RzLE6U85nPL7J
 /3uO8A6w
 1afolVxlq3zZouo4oqKGD1vran3Zj1LJxpYgdPlEiFLOKJ+Usl4JvfX4e4awpsOnfQuNQPcBIooDmFkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> This documentation makes it easier for a driver/file system implementer to
> correctly use this callback.
> 
> It covers the fundamentals, whilst intentionally leaving the less lovely
> possible actions one might take undocumented (for instance - the
> success_hook, error_hook fields in mmap_action).
> 
> The document also covers the new VMA flags implementation which is the
> only one which will work correctly with mmap_prepare.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


