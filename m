Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB39FEA83E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C386B0093; Wed, 25 Mar 2026 05:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43606B0095; Wed, 25 Mar 2026 05:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980386B0098; Wed, 25 Mar 2026 05:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 895176B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:58:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0645140816
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:58:40 +0000 (UTC)
X-FDA: 84584136000.23.E512CE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECB42C000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:58:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+uY8j9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774432719; a=rsa-sha256;
	cv=none;
	b=euHTIgxMupsClpkWbAgynaH8TJMBoNUgCyYWT6rr2mzxmiAN/IdKCnaLenfI9OcWBlCMff
	layXQa1/ryxH/bszwC4BE9cpKtTOlTCijq5w61JvqVSvGPMLqZkia65b/4UykBaznh4Bdn
	BJjXUWHwVdxkggO3Nm9gECH35B9x8DI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+uY8j9D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774432719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpYiYoXoDG6Ic4xDLF6eLk5LC3Stg63tlxDdSDp9P3A=;
	b=sA4Ti64y+IQNspW3qfZ6LqFF/oJCEd9xm0NuTTimjxr2F3u4Dv7gUkiLqgXD1k4Kg2+Ymm
	B9N5fJVumuCR3LRoCN2O8TMTy6a+lsgqfyATqZiMDgIg1wfdEvO9H5MqhcUd/6n0mQ/ny5
	z3r3osfVdx+I9EtXOhKUpL6kmiK0DFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBC5943C1A;
	Wed, 25 Mar 2026 09:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFACC4CEF7;
	Wed, 25 Mar 2026 09:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774432717;
	bh=HuY/gXey+uWVLYsCI6CkmOeVgc5q6DFm7SVnZaIS/YM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u+uY8j9DdWnf6aJO3ZHhf6pj8o6upnz4tgfFLuwATHjhN6SatZRmXJbkO3JFsl45s
	 ADbQAVoZ2bfxIeImDpnwFdFCo0b8tn6HNyoZW5/j1NFRa+uXe019/Hzk1B5PNJSpge
	 oitV6NhzQsBWdl1ZGdGjjAleBOpYArsdSSBmuxkg0gbhRkp5b/B8T8vJcIMEA4HjHA
	 nsppJG3k+pdtmXbLxSqIZuQQW9qLID/Ou1ZIPnKK9/Xrsxbabxym2XTk8bjNKNnh79
	 gW+HYIQy6QtFwqaoSQC+HIe2caOI1oDm6sqQ/VOpZmE6eK1dpqAouDkD3M6o3nEwh3
	 regiPf+e17GQA==
Message-ID: <9b205b06-e938-4f30-a16d-7d90f8c49818@kernel.org>
Date: Wed, 25 Mar 2026 10:58:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/21] mm: add mmap_action_simple_ioremap()
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
 <a08ef1c4542202684da63bb37f459d5dbbeddd91.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <a08ef1c4542202684da63bb37f459d5dbbeddd91.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ECB42C000D
X-Stat-Signature: iw6pca66gyq7cgkoyh6ba1dewi98ie6w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774432718-928549
X-HE-Meta: U2FsdGVkX1/b9+Jh+IPCxQt7e6+CFcSCn7kNQYmL69FKAhnE03fNjg+qIi5nQPMafR2/WX7dspsJtMvgySftVOlMfex6VvX6s6gTH903JTnWk9TSLIKsqAzXisf0BT0FfEs8V9/9Sw6waXyERGriKRxHNhpq8nuYLDYK5Mr56/T2oNNu+EH71SLmGb6SgDRv8/qhvwSR/9hvdFA+9imDVLFf9Qrb0QRmME2Q9rtwiEYE/TP95wW4EkUZsELrKJ/UzSS3lrPitU53qR66xFSQRcQBRHZjW95INgPOCucF3XIg1rpgkJtBA+nz/WpfH4CQdLwQyeH9wZ+twYxaiZa0yMjgZb9TElJsbidLElhpy4zblKU8DGyJO+iRcJs0kOrGbUgRIRDFm+8qVA4qGaTlGdBtmyx8l9l1X76XPmeajzUyGUef+hPPeNNWdORTMrlhIQ2QQA0OzYfKjiLJ/Wqf9QwT/LB15dP63Ta/zE8ypRfliupzr/vdkpL2sjft5y9EaMfkIbZi0ABAgZ6iAPE9RpHYpcPI7ZGrObnndqLxxV3ZJbUj3Vz1i8hHWzbvPeWPRMYXQQCWF+PuNeaxSO7jnUKpUh0QeSweS6N+tikwmjIZkkTDbvAr0S6SnvuTL1mI67ivYvBg4IHOS6tnkkKU/DWdOd1XGWf5eX6OSRi5f7F1W1yqAntKuOuqKb0obDxn0pj3CsouMGijUQjZ9QFM5haprZauCUJotqxOwmwaScGn3Lh2I3m/9OK0CKaHIvx1oqi9l84UrqX2YkkrpYojmh5KcTGxDmSbAJlk2UsPhsIA/z+LNYulRlf5SFrsDOnuygtxz+DLTzvfICF8nEG8O1T4W/zuwWdCFAhG+iPdeJRXgqFrCmdJfNXOFYSHFrBbmTjdYKzRIOKPIy0gxN68FNjTwT6lJF/73HqfEB+v1V7d9wO6DST6eoTo/CN99b+a6mXVni7wMccB4gUHMlR
 u1UV+i/T
 d/lL/dUB5dwMdbC+9AJ++e2k41wGMyhvv+aPNvniuZCEuzba3WTSSNuhVWSWuElrMNXD0L6/GUv3lkzMIC379Ax2sE8DfC23elmxwTQfNctz2KYbJYPq3qIN0N+uwDSJOicktgakj3KxZyKZtiLtG+l1mxErwTrPAOJVpCJYpKE6gsDKT0d0q+wf+VkgvBI2hdAeLH1OBJc5agrC8GsbOfrhlwy75wSJTCSaBvbpDaspLizg0vy8PN/5dpINISlqYeiqXFizlgfLsWwoNOE0E5eHCffZvCZxgL35WME+qjEyEYLoJk/EgGQs958iLsVnF0j43ZIbl2T5Ks8yBW7vn0IlaUX2+CeTiZYKo3CDRFlaQCHi/ErSeZcX8aZM5vD+NSANuMb6QVQeRU9VBO27lcxETifpC0Ekxv7v3Rx/T8Fj/jMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Currently drivers use vm_iomap_memory() as a simple helper function for
> I/O remapping memory over a range starting at a specified physical address
> over a specified length.
> 
> In order to utilise this from mmap_prepare, separate out the core logic
> into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
> simple_ioremap_prepare() to do the same with a VMA descriptor object.
> 
> We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
> mmap_action type to permit this operation also.
> 
> We use mmap_action_ioremap() to set up the actual I/O remap operation once
> we have checked and figured out the parameters, which makes
> simple_ioremap_prepare() easy to implement.
> 
> We then add mmap_action_simple_ioremap() to allow drivers to make use of
> this mode.
> 
> We update the mmap_prepare documentation to describe this mode.  Finally,
> we update the VMA tests to reflect this change.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


