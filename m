Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCC6606A321
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7iLJfrH
Received: by kanga.kvack.org (Postfix)
	id 9E7596B05B1; Fri, 27 Nov 2026 20:09:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970D46B05B3; Fri, 27 Nov 2026 20:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F8D6B05BA; Fri, 27 Nov 2026 20:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA076B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:09:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E44C3160555
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:08:59 +0000 (UTC)
X-FDA: 85482743598.01.5D8EB54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 529BF18000E
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:08:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7iLJfrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795828138;
	b=0duHCOXyRAN1Aw82qP16I4HEZP2La6UhfB/TnzEa2KpyFev4AfdxlndT/JzAMAJ2fhhvtb
	yCLHJjclqmQ/5tPlEO6BDCaPcoMw3+qcfGsTODjNzraBUAjpTvBkmZt11cLB7QDoR8boCG
	CcqEbZzFFaLClMtXjacGttIxAIj62Sw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795828138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiX6ZyljcdQPQcS9kGO9WzZ1LmpsTkhRSgDRiHn9c1o=;
	b=42a/LUCsGrvWJfnNStf2wC5KiwUUlxGsFjK7MImOR1PjcIGktZ7q4j4SnQk6Z+5mW1MLmJ
	hlwALPTRyOCCGFx4nER7XlGqebHZH/RLfqtTPlEN+pAQTV0OuTDHmrIkDHDsn/xxWDyiv0
	fCrOrSB5Fcdn7keY2NilTw7jlvtC+9M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7iLJfrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 709A6442FA;
	Sat, 28 Nov 2026 01:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91B211F00893;
	Sat, 28 Nov 2026 01:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828136;
	bh=BiX6ZyljcdQPQcS9kGO9WzZ1LmpsTkhRSgDRiHn9c1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m7iLJfrHpA8eePZ6FYzysI93EHHYYCIo2ytcOQKp7ORyyDMSYxAtkEvF/yx09Cg4R
	 iJpoHjXY0fVAvXCIvIs1NJ/9w+qIsCt6RlwL4ajRU1yO+cHTh7Kqs9xPXT70wa2ztz
	 w9aAxfd4oLS/lkq6tKivYGYmqxvSr9+PmXk6sL5aSxkY+3hL8PAK3/XCPEqMlKxIz+
	 HQtEFMtzRMrzi4vfR0aKtXsT0Hn90k3NcrBuaz2Pdcy1JZLE49YB2Eq7UcGR+3pIPL
	 0oJTU3Xa3CDhp1P5hE3sz1DkIOuyxJP2Em7qSR+Y9YvoBlBS1Ske2Iz2DgAlZ38EGJ
	 V6CXPjiHUEcjA==
Date: Sat, 28 Nov 2026 03:08:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, arnd@arndb.de,
	bpf@vger.kernel.org, brauner@kernel.org, containers@lists.linux.dev,
	corbet@lwn.net, dhowells@redhat.com, ebiggers@kernel.org,
	giuseppe@scrivano.org, hughd@google.com, jack@suse.cz,
	jlayton@kernel.org, josef@toxicpanda.com, kees@kernel.org,
	kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awoppInSWN0XVPz-@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261128005541.873229-1-safinaskar@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261128005541.873229-1-safinaskar@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 529BF18000E
X-Stat-Signature: qwxh8dhfbfak9t5n6zx4wp3wcs4k9935
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795828138-978447
X-HE-Meta: U2FsdGVkX19xZ9Pyy8QkkK6yf8GeXQKl2LVDzLOTQD0eAWUESx+G3X67DWcanxVfOGj4QNnmwL/IpeeyMcR+W++Y9nz+0clB0h9NrQezipDE1k2+G53ZTWk1bNISQIK7RYv3sjOZ8xmxoIiAjM06cbAWgcYM6Z6Rf9gVDbSuil5dSyCH1KnJQHFUcgnZmoLqCfj9Hy8rbKjkDHER21XAQZfd2epbKz2l2I8G79SUFnNRiIc+Bvt9hbynZCtbBvoB9RC/+H0qOozNMGEZ7ozFC59dA4x8nOCD74N630QDP9FfyM1JK2FaoBDASRVCkirrU9v73ZLHk8wM8y1aG0zTL+Qu5iRrwPda8VkbXtYO5YqRnkjG6/OA0Q3LxFC7al6YdIWgTsYDeSENBDQ+BDvELJ8VsSFCOqcsXDzxxYhn44Zykcy0gl5z/CQu5v0Jd6JEOTo7nHf03S/Ougg1j4xuquIExnFCgq4ZxCuLDy+PKDN2kkCPoXTPBVkP7kS1ZqGz/fw4CCVtqOMIgWz+gNEiL+AVe6AbNNoaCFZn068tSg1D2a/Re0cca7UKyn+S3NDvrPFujweWJE29Oi23wWlNWE4F/c8IZSMBQi0rV44FhhcUpEq4zMbxzLROaEL5fGcupWFFdREaLVbVZZlGDJbwV8LAVC3Otebm7Tx4dlzf5QylsTZGWfeJyJ5EdkWC2jupgkU/epkeLF6XE6AXrR0a/c032WViF34TzNV0HYbS3Rx5G8u1rtx4dyLjWnbDLM1cmHsMOc4yLJNTjvr/TbnAhYh6v0hZpukMzcCZpm08g1uzNowCD2hnrujNs/+vvs1uKAyf9v2gujgzGfbOq0aT1Inm62Z3QEtgRz7HkmDmIp5JNmlLTsW0JhVstiNVNzXmesa1fleabGsXknYSRGvWvCvMG2MJ3QNJRwjzVRVwpHedq1Xszk1Vr7egU0OtLD8h/oYA/CsPpPIIR1fLmF8
 7JTXbBcs
 b+brnIMiY++y8KeqtMyORjhKCzdBx5WFr6nUDG7dkDCdr+ze1zkim6A7eVQqjSO4xCiqyhf2uQBjvMChASv/IG7mrn4FHizmFWhatjaMPzxny6tZM+Nxoi8c07JBg+bbfzDgD8tnUjwmed0SI2m2+UBes76vQXSIBzvNBBJvWS265jHy6W2y+K1V6y3CJiUop+FMGHkKliUxyYrL32sxkFZ3rHzX0c3Ek07gifCFXqlwD9UqnZD2JEf11Rr4ORWgu+j5L/18/IiC7jFhKck3h+JipMkLW/0MEHRLhLvZqsioAFdKhT9ZPU12uIAo/GxWOHfkB4iu+sL1+p8OqOuEV9D4rlU8ftlJ91BKuhesfHSWs5qR2NOBJEKVV24fVNmnWX/60zo1y0VbIzvBGqN1FSEw8sRiCa6itwcJgsQ8YVjd+UrPMzlKto6xM6ZsmQU4IeoWt6f3yVHV29t0CdAHyQHR4vuj7nEd62dhQcAuWjKnd9p6kWqsq7awxGwtwne8+bb+iT66JfwBQWAJRVOI5xjWiZamqM300/TtNz9rmeS/dWBZ5uOunmH0asnXHA1wutK80rGan/2mUWMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 03:55:41AM +0300, Askar Safin wrote:
> Jarkko Sakkinen <jarkko@kernel.org>:
> > Work on this feature started in 2025 after reviewing David Howells'
> > container object patch set [1], whose underlying mechanics made sense to
> 
> > [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> > [2] https://lwn.net/Articles/1102593/
> 
> You put wrong link in "[1]". This is not Howells' container patchset. This
> is Howells' fsopen/fsmount patchset.
> 
> Link "[2]" seems to be wrong, too. It is not something "earlier", this is
> very recent LWN article.

Thanks for pointing that out: https://lwn.net/Articles/780364/

Br, Jarkko

