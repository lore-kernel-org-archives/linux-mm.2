Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2BFCCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FD98E0011; Wed, 22 Oct 2025 02:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0338E0002; Wed, 22 Oct 2025 02:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD8B8E0011; Wed, 22 Oct 2025 02:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB478E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:07:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17E8B160758
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:07:59 +0000 (UTC)
X-FDA: 84024719478.12.D33DBBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72EF01C0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:07:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fQ+MJtKw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761113277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srkenRpEiHXPwQ51Ii6mcXFG6JoJPGlwguS23YeEel4=;
	b=aUk8FAcxdAe9Ng5lU0AWkSheNaB2OK82bX3KQHHaHq0e/QrCovPk4+NMv4SKCVNUEc7PZQ
	8eVV5XZpiO8PWPDhBt4u4UZM4pQ25coWlQTvhcYnD4lcjFqVKHOJbIsAyMDq1xony9actb
	V8T+roNvnDSMFYOTgmv2j0FyGuu33iQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761113277; a=rsa-sha256;
	cv=none;
	b=c2WfnaWreuanm4JHsruec3BMSOFAY8VKVlmgmK7TTnEWGDZWCtpbckVYY6viMz+Leyl8pU
	i5tvwGDiW6RkAbnpffzGzqA/vIe+xKRM2EDWYZmGj8xg18yFrNqFI5qSBrFTTlCjfvoWj6
	obboB5SeR0K1ubwj4wnTjheNPJvJg+0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fQ+MJtKw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0A4E600BB;
	Wed, 22 Oct 2025 06:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30800C4CEE7;
	Wed, 22 Oct 2025 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761113276;
	bh=srkenRpEiHXPwQ51Ii6mcXFG6JoJPGlwguS23YeEel4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fQ+MJtKwHr36LOV3G1knlCK+R2NmGpz8aDtIbdAlzs/EJ7QKjuRSL1kK0lnwXqXkj
	 NVoNMlgTR1iPqdlrcsDTa2AQL1eE2b928Wjyralp6cLGchU0sIzB3IOD8WOkMuEKK3
	 j5LoeRq1JK2PQokjwa7wnZN10H3QznVZKEGgFpz4=
Date: Wed, 22 Oct 2025 08:07:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Leon Hwang <leon.hwang@linux.dev>
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Message-ID: <2025102245-backstage-sprain-76fe@gregkh>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <49bfd367-bb7e-4680-a859-d6ac500d1334@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49bfd367-bb7e-4680-a859-d6ac500d1334@linux.dev>
X-Rspamd-Server: rspam01
X-Stat-Signature: s78wo79mdfomcrqosourpj3bpoysfopg
X-Rspam-User: 
X-Rspamd-Queue-Id: 72EF01C0005
X-HE-Tag: 1761113277-240549
X-HE-Meta: U2FsdGVkX1860WDYpoL1Duk9OlPtur2/+9Fs8/Eui/tv6STmeI5kEWX484/wQ9pohwaBLdkJSYstqQyTj/HcQ8+inz7VQz8Aa5adKqOSB97sXy+U5E/R9RJnyiykJ1ZUz7Ezl0NPAW950yDwYy9y6lyjqqEzfrMRi42ipnww3rtH4MoXfUJtTZBJnSQOQ6xT3Zp7ZgmwPfxjYHB0DDydgjpht/ZLoAMeHMOgxgURQsGUWF2dyxC6GIeoYrGKcSSvro0vaDzrSUhZ/7Weo45CPUtYTas1lKxnIfdx6TQyMNP/X03Z20uDODBMND5HmNXnZ+MNmdCBR9oGhIhSMV1h3rxnu8Uk6AsLd+YMiRBHw884vazF6dvMgAuGg0QuPFHBMNg0iWkkEsvNxLyCYwE6OuE0BeIFHXtDn+z+3xKfDhU6jAA9Lh+mauGjgbizGW1UPXe8wbp+8/OSmxPUGN05ESaTO5llWgAspqY+u0PSNQ2D3jzj5FkCcb1zrFJLqPbqbbJeaQuRGooZh1uou6Cac0/xY0bU5hkxZm7pVWEbMD7KFUc7ZqK3v+tC3azkmmeOR7TrScjOdQ3xmsELhnFSZraTxcHjkXceAYyT6G430QeFNHzOBwGvXc8wpsum+lks/Om8MxTRSd1lhuZ1M4sOxOdP8l0+hHy9iwymQxYEZNdNsSnR8+Fad36xRq63hP54al4scimdCzHC5hjPkK12S9MLKlfQV/hqj2V227Y8YSz0lK4Zqg9/LnHhdNXbB4nQ4f1zDO77wTzjFmx0hLBMQAsktj3w0QTLRrnLeKHnblAFu9QufBxVUbUs7nwiOa8Xkt81ZnQjMH0VcPIIyJCHKKdENqvJPIrdM9vLS91RauB/q4VSnLs785l9cFcWTqWQ2A5p1YlSI1HO8vCB9cffLB4pIse4WtPIdHyuY40pEpM1TGh39JrrkpzpFaz7aKAw8UNZXSOMRz0FiBpOCMB
 jVbAsKZY
 tDQ+VWFdgEQB7/XgP/Td/25PUXmfTcKesnJVVq2t31l0430XXy8oqN6QMiYbGCvCnSPXdaCB//bcgl0v63CodTAcTwyAggYanHWbp6EZXMlVtWeerxQ/LI5h32Ili8pFbn8geiI9d4uv4j4JLswSwaAi17mNw/sYJziO12gRfZ7bbvVoZiq2ADXpd4oLzXk7u4DT7zngGy8TZdkr3bgysu6VDoKLo102Yt2djo1LDTKYurIEbSJ2vlMtrbIEtG8j/u3cfSfV1mZqIfnTAgS1fPCJvOOnPXnadsVjx4YEHKMl74odRbNT28R8xAK6C6hLCYtsy+Qf/WmGunVDz9L88mcwR2lUK/iSotxwVtVxEjUBT0xvRbexZSh29RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 02:01:26PM +0800, Lance Yang wrote:
> +Cc: Greg

I have no context here at all :(

