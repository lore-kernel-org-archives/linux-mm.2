Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378CCCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C7B8E0003; Thu,  4 Sep 2025 19:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC968E0001; Thu,  4 Sep 2025 19:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6129F8E0003; Thu,  4 Sep 2025 19:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5458E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:57:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCE3C160454
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:57:56 +0000 (UTC)
X-FDA: 83853233352.12.EAAF020
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06A7BC0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:57:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IP0RW6nO;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757030275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1JF9ABm23/crB5M2qXk95TNoGCZqy9JAAct0jdXudM=;
	b=dRJ8m4tohJT+jyy4BWp0LqfJCY9TkK4Qx8kGw7eR1yowPtuPU4ifHtsy9UexGvUBkqGDWn
	3/zswrNTWxr2hGPX290kROXMsx3jA7Ofzx2uwcrE1/GpOQauJ97I0V+WROo2cxm0p7Kb5x
	KH54rDbRYmm5q2YSBoqYlVfJRVwmNnE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IP0RW6nO;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757030275; a=rsa-sha256;
	cv=none;
	b=5lLYQDhrAFqhvcUZWu0aSZq7jsDGeSyV1T7WLJgelZgua8Shz8PN1ZJkgN4GKK2CYUjTfC
	jeST/k/h42R2blg68PGX+zXMg0DMyfLBa45Kg81+a2rQVANGjgdqQYSH4r2aL6N0/HnHzm
	KoNywXNDvz85MLWG/WPlIgIbdEWob5s=
Date: Thu, 4 Sep 2025 16:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757030273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+1JF9ABm23/crB5M2qXk95TNoGCZqy9JAAct0jdXudM=;
	b=IP0RW6nOGMgFPd9nXUCLLw0ahXL7zYDkVP5hnRPsxGQbC8r6JZ+o1Mki8k8IcUbBMSSfVP
	xY8GEJOkCrT/t5Yv8dVOu0RgPaxIbveuBbRwhK8/wNymTsDGEyJCvlxxw9KVMEtAQMbhqn
	6n6bXsZWN1E+SIRU+boROe3lY/qrCas=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/12] mm: establish const-correctness for pointer
 parameters
Message-ID: <ue3oriedwzzfhvnobtetuyjvcypbvl4dboqmpvdededzaj3amq@5k6vk44ae3fu>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 06A7BC0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 31fcfue99wewwos164gewdk53hf7eu11
X-HE-Tag: 1757030274-534829
X-HE-Meta: U2FsdGVkX1+G5629PadRHpHV4dTFBTbQAfvR0mOuPRrt1DuoXwjg5/0DmfDQSdI4MFHBpdTSdyFZm+ZF/qxPZOrcdh7Rt6vzcW11zNSciNKQlXkFKjk18jlr+9J+LdZ8vjI5wgf8F3h56iGnTyL0Cqt4T7gTr/slP4jZZ0c05UBsIEz/W23W+0q64OuFJgILxcCVRTGB/CagJi5hjJgA1G4mrKQ3X9ix9zMIAR4z5tnBCmZj4DkxdeXE4BcpI000tWwI8w4sNQVn90dhAwn1BxU9P3IZ2g6v+bD4aPzkXkDIafdUXKviyTonPskG1zrPfrIDRiHjodSYDWo5R2LqYSnXgkAAPUvkuZFhqfjk40sJthFoETLy5jRWsiuTcYfgJlC1X5LpJEYcnFpQGHnqapzb2/XMTdIyO0HMMBOn3izsams3nbcO0/CmnN76Ez6uyPJmiMd8JCnHyO3L0vD8IQpXxSNs5ILtYn5HaB4bYon2SzL5C/djw7BzTrw/wORfwmUmBXxhaUmU//UERbzTje/BWK/hCGAPN0aAS9DKdoRiGWmmhS37m8L8AMwHqsSCy4jHhrh/i3dvyCc0lB8k6KgRpc6GKt3o9J5P/gfeoT8uLAmTjdwU4oqrROhcrFKdWF0f8ubtK9Svqe+1t1rRJniNIE90D9wbcI4H0+WJcDL9+0nfzS0sHNktQG3wz7vQngskFUjislOLLJWKBe0agWyex4viNRh86waaVD2Tcg3iC8sEbdPQxPDPtv9uOqj6Hg+m7G1D/TVX0OJsvZYT+fWlSCmIKtS5NuUdzQxZNiYUe+bT7TJUvWwV5FDtvG1hGbcGJZtXhlBgaQexc2yVu8RcxOrQ7336t9igCEkC1AUqCP15jjNqAd3IS8ansmY779l4nc3KXTs1s08TLYyU4ThbDjWnuFoakBYl98qoKq0ZPysDgrPBKcS8GchBNj6ukXzPOvuCIvoWIfTsiJe
 7ITa2wTZ
 uELWFhBQ87XZq/PWGSF8mn57zgSo50ZZcEEhavDUOu1Pvl7cHN86sVhNNmi7O8iA/LyTkDavbW3zZYIP1t3fslHZu+K8OeOj8F+tdh+bSna8dviWDkrZz77FNTw7qhi1U4VmSEgBqslgMDn0L9CXMet8HL0TUfpxflT0sPyWyhpW7PqGRx4q/fOe5Lq+iBkYBLiOF2s8x/PppeX8ORWoUlVcVbWIT8ijvC1l/w++VziansPWjvMXCp21LKxcEup9Wm/bjlG4krofPYtR1BPi7qFS43+2lPLJx8x2dG4zE8/v2kHgc45g1IIaCEsI/J+Fdm/S16rOLYpFqZC/hmIv4A5GHiiodaDgxHPS2n4fJ3o2ndMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 10:50:09PM +0200, Max Kellermann wrote:
> For improved const-correctness in the low-level memory-management
> subsystem, which provides a basis for further const-ification further
> up the call stack (e.g. filesystems).
> 
> This patch series splitted into smaller patches was initially posted
> as a single large patch:
> 
>  https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/
> 
> I started this work when I tried to constify the Ceph filesystem code,
> but found that to be impossible because many "mm" functions accept
> non-const pointer, even though they modify nothing.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

For the series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

