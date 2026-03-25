Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48926FEA808
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 10:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572AB6B0005; Wed, 25 Mar 2026 06:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5237D6B0089; Wed, 25 Mar 2026 06:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439166B0098; Wed, 25 Mar 2026 06:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 349A36B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:35:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FBC35B442
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:35:06 +0000 (UTC)
X-FDA: 84584227812.17.A06DDAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F2FF82000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:35:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyqtwD0B;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774434905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd4jFhAF7HsibuqHiAiyPoi3BPPP99WUOLb6w/CpO+Q=;
	b=1cmUuKLwvIwzguqjHpY6/Bo1V6V29FVRM8YuK7SCjmFlbILKwBzANo1zXp/y3gMkGxBAIf
	/+GzVZ/akLH9w2yf7EFgD2qTssbMYgMS50aeZCY0MLGiZGp8iS3+w7xmPjsGDTPKJUt1qZ
	YfO9pk36QuQy+w5GdkGt1Q3shxvgHgg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyqtwD0B;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774434905; a=rsa-sha256;
	cv=none;
	b=x+kqgJmBxZdVzItMUppwdCFYqq7SqAQyrnE04TCFdQBibyOnXqblsl5BUyxRAxy6mWwOWk
	eANONlXc9QTvNGg2r78pro4rPzRpPsVDg1MkIAtijdON7HRMuf4bBvR1bt5ZEZWC3RlJtU
	pJWM4HtxEtJiz+fefqZ/vOk3231MJk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48ADB600AC;
	Wed, 25 Mar 2026 10:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB41C4CEF7;
	Wed, 25 Mar 2026 10:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774434904;
	bh=+W7AYaAXVw1i2DYITazSh58FngLmUYCv1t3fq5pVTRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XyqtwD0BVJpUUEeIxQNuop7kP0eDlwdduGR8d5uf2MwwJPd+cw307oTk9Phhs8x3l
	 Hh6rIELrW6PhJt0RPyJGSFPMzadyDZwsObuPFoqXKHX/qCFcrK66BtKCtHaH7HSpF+
	 0NGL1KxEeCeVDvLkU166GKoCMV5sPI0Hq9RLohb9yNUsRArIsKfhzMbamkj//nH3YJ
	 4ug/r3J4vaM4CSS0e7WBb9VfoiGQ7drIOGpXk5kZ8oqKTpFew/rcW80Y1ZfDDm0HKl
	 tIqVPpHAE7k98Loz1LnKsoU5+bfkVjx6lxzQNcGzna+siEzTrHVlZuoNwTrwpSF67C
	 HbfXsN+/yyUDQ==
Message-ID: <ec28f19e-072f-4f26-ad6b-feadf7a88dfc@kernel.org>
Date: Wed, 25 Mar 2026 11:34:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/21] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
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
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <08ecc1e1d319564fd49b9e9012f994edaff921db.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <08ecc1e1d319564fd49b9e9012f994edaff921db.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2FF82000E
X-Stat-Signature: wsgwueoz34493hja4tqbmno94dybq667
X-Rspam-User: 
X-HE-Tag: 1774434904-107318
X-HE-Meta: U2FsdGVkX19w7yAD73Ytpl+RP0zeZyh8ZG696es/wfnIgXpElWyQ8JduJAsfA26CHfOtQR4QLczt3DON+hzibZloL0G5yriVdPpCEopMkCx6GTCvZUX7Xdy5EgoWF/eJD5jdxeDGCyyl/lH9WH3ACkK7EdDSLsL39h1IiOaSW1iIeW3zr0WIwDZSWGgAPPg7Rs8cMGxTcl7kOvInQ1Qyf55F2n5xA6EXB+XRFsGLglJm9l7dUxvvvXWYzk+GorIpV0qkmHpNsGblHseeYxknbHBZBo/7iLIVz2thJU6pX9bRnAXiMx0+v2669tpGMFR22FEtUksPY/qTP+dgNjBFdAEkEiNoPcGGUbka5HJseRfkGPUES8pmnQnUXWUYJQrOHyMl9o3SuCrP051rg3JRG+kAQLQA4AGR3sgHIkPLpsKeHU2PSMTR9L2eY3ikSJ24NII/JTd8l8wjjX9dP/izpLEnQ1A8C6+drzHXnIsSCnXOH0PBdZgvQXRUf70RJBiJk7UTjclL6zTd0WXH3+W8SPyYHdF8jRknqFZ7skiA4V0f7eJc+Lhun/AbzGPKKrocHp8IRIXdEo3w/hNrPDrgLxPHABVSNa1bAWEYuLEAkXZl2fdWC2lFOVe0SfdRuqedDy91QVRTtexzj9CyAwEzrYG14wn7mBFWX3sgnbAaMqbJ3jMxahLEvU2uAHGWah0FiYfHhgQcMEgd2/hZts2oNPTiesJcjq7yPia7iuuqJcmJKpti9AzYNubtVrLjQ/Gyu8DNZStP3y2+WHy7Ed/AU3HOI7hKY6iHkl0wjSRP4BCmldlAH1O+rK+j8r+wnIKFmwN3+2yztwoU6bMq0+GUZVLWKq379hxZ+F0BuA3b17/DJ06o69WXxkl7x6XpR39P6nWW/soN9crrKT0sAhfsdUQZa5jOrqBH5UFAfOVI1/B5LF9WPqmvIM9239rxMyBsNjosZE+PxnpYRFQmqGc
 JvcrCLP3
 Eg6F+vYSXvtV1lY5wyWN5TGmHEA37ZxUxBhSlMFPWHM0kFf17e8P17tQPC9l/RV1Xs/6Pe8rhTCFE61UOvaHZqqXloWyg9Ib9W8yzhEsf8lcR+VoS5xkBcIA6el53KYXxInJZnmGgyntmDOMQGQrzb8755+hy3KqyNf6Ofr3xtjRD25oNmO7aavkvHa5ry6Ijc4QQV9hXp3Y++ZWj2pdEWWeUJ4xJYzhuiAYJBqx/A7KCey+qxEXtOrNH9Tx6CXaZwn/v0hCqXCsDKjRMlMsDHlDOLHbWd/8kHtCpx9HFrE9NtOVP2vo+Xtcuz009xGkj68xGpDh2IPRLJmNBGF1O5IarZYglaSyidA6bmBP6c32VlFSqv6+NrhYPonaZWdGIYjNSIgSQwgAJ/X68lF3TOm8gJA5tZ/8l9LF9BvwkC9XfYO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
> 
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> 
> Functions that wrap mmap() are also converted to wrap mmap_prepare()
> instead.
> 
> Also update the documentation accordingly.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


