Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F674606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GDU8EuhU
Received: by kanga.kvack.org (Postfix)
	id 41B096B05B8; Wed,  4 Nov 2026 13:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3FF6B05B9; Wed,  4 Nov 2026 13:39:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B1D6B05BA; Wed,  4 Nov 2026 13:39:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1269B6B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:39:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AF1C40834
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:39:57 +0000 (UTC)
X-FDA: 85398300834.23.9120F94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 188F5180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:39:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDU8EuhU;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfX+RSDf63q8RdYOSefxL9B17eZvLgT/fF9r72R8ItM=;
	b=bsEjLZoUUebltW7WbEmMNk8JaJHNR5RkuFkLU/uzZR0uoPhLBb4ELcaZqiCz7BMdguCgKu
	4RzoQeQWr2uuv04rHupRxxNJBak3/9QWZ/Ain9BN5PdhKDl1Q+i9fLu/44Eq/m0SqxspIt
	JfC5SLQllBmeaOGSGsbinkfVC2jhugQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793817596;
	b=xdBnAOQyTv/jlhOSvayaDNAmBVc5K8oI2hIhHF7cp8LypWLoM03rXFOGV3i0YxAfrJnXXe
	2eNJLrtj7kPlor9klPCRpOb88WF8ES9ZBXJNUDtBPnV5ZWrl47TBMUrIPEZFa4zSZA6YyC
	BBQdMVcwUdriwhz+URAobLbCZL68Pls=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDU8EuhU;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9485D60A87;
	Wed,  4 Nov 2026 18:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D94A1F000C1;
	Wed,  4 Nov 2026 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817595;
	bh=cfX+RSDf63q8RdYOSefxL9B17eZvLgT/fF9r72R8ItM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GDU8EuhUF/10B5PY7Ge41gK5xPnjrcLHs7feXWHlvH4fq+/JLsc6ePLzmMcenBTV8
	 F8DU2mNIqG7yMOIN0gPqiAwJM3jV9nVVVUEYkA/ePBSooGTee00ROqhKBnF1Bqim3H
	 1MIVC6ndCg4IYSs9ehay5xqAR6tGspnn8txoZnqUV3a/rwlemC2StvUcjU4rBzRdDh
	 smT5Fi28DptI2/GHQw2s7uG8id08IW1enmMV0ZcuUo2Xf6u9ciNae6b4/FwizkvKf5
	 0O5jZIOLbbQIYlYObNdALqLNo9VEtQX1aZ+lQxJHqEn6uUf5MjI2wjNp8uWWy07SZL
	 e+KRVPYe7/Ndw==
Date: Wed, 4 Nov 2026 19:39:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Chuck Lever <chuck.lever@oracle.com>, Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH v2 0/7] proc: move procfs to what kernfs does
Message-ID: <20261104-angriff-abgewandelt-ohnehin-e5ba30d31576@brauner>
References: <20261104-trompete-gejagt-raddampfer-9fb5640a6102@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104-trompete-gejagt-raddampfer-9fb5640a6102@brauner>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4dch1pzfjuduizhn4z7681o8fxp4j3mh
X-Rspamd-Queue-Id: 188F5180007
X-Rspam-User: 
X-HE-Tag: 1793817595-644724
X-HE-Meta: U2FsdGVkX1+QQXuk4o/T4UvURgZNsS9gNOS497dockYLQD1Lb8nNRQREQTJQGfuDb3dPk7Er7onRNoeaJmFjVTLbIA08KP588feBF225V9dcOUvn5ejVS1De9scO9ru5WFD/2ndHnYHolollWsnkX8mST4BdT0XkMkgCDmdyJzjk8ouL4WAibteqdzNhpdTgOZWGTVS8ONLSuMV4CGlR4pyZT1bQmWVmt2SCErbaTPW1dNwvpry3xh0frwYfRFnbkCqxtNe22SWmIlLAaK5cqy3rZraJBmxOF26+B1bCsh1V+caWV4PnrcUPmwVJHjGGE9HH+WR/9AwaU+6Cfkmh06H16IgSSRsmW1uV8AJdHDHy1I8JQ6MBLqFgNIFWk7zMeqKiyypmPGFqCbq1NrnczysaDRhHaMwh5sv4YaiKE3iNz9xh51bTMAHEnAxjH6aEQIkRE7C3YUMa+cvTgGpJZP4QGtr17qFOIrWWJ3MLOIUj/DOdkFUIBlyEq0lfjAjgZqv1Z+jK8fIMSn87jEMSEMU5scLZId1owrA/s1v+JEzirmNrzZECsE9+VBQleHQRxeEM9qgTZ9sQw6mcLmaqh7JC8YTEaNVLnxhtOJ7pQY8ZBPHzpS6YR0zR2cL6hXJi/GA83VYU05q6/u7N+3/07glNrOdEnWPu2aagohR8e+Nfz/Bd4JrREYrd4YvQhQHtH06/ohh7q80+35tJmgnQV4FM2/u+InGZdP4+rXbRwgjRqrsODL1YptxZg/hlLTg6vqeG7D2NI9ZZ6z1Vfbh31g1Nkk1aj+Bh5xo6pG7lFW2uu8kT2P1uEKJguVqBEFRjJaMX5HMRNI+eUqvdoPrdJBBU+surXXmskwgP3YFWzasyFroLGqkGf6C0wu3xQ+qceVSuY/yoghCduS6cce3QxchveUJOTti5S1ty4nb0iPlXrfW7d8+7gzydUIwGk6nF69On7l6qOiPxfajEtNS
 ZRpRs362
 Dbd94WIaqj2hXwhhKjz241LqyoNGfAiCFtbSe+o4kCQBwDqA/Jehcc7U2kLKloeGhAkxGIrckZokl+bUmOoFlYOpc2AMKkfEUU3BYJYHyzdWa2WVaK0yGHe/Q6Ao9wEUcLHsfCD/b+HuV7EsSlakurUWwPX+t0fX40rGFWLXo8fXsQJzuwDk0SNK/b/FK4RmNUJJxSDJPZXU6T1LE87sTJw/GNRaroHbXUlOeAQLC0fI6lmt3zzuIS2/FGi2hHh+6YEBXWK7IUyDybJA4lO/osLBkB39amIBn8Hxvys/Gp+4jGFAzQGuUHtsbVigDYLlZ8J7ipg6YEwUxIp4hdbvA/A+Ncg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Please ignore this. Network dropped halfway through and the umbrella
went out under a broken message-id.

I'll resend it all correctly.

-- 

