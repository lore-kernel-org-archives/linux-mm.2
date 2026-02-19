Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB670E9A057
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0626C6B0005; Thu, 19 Feb 2026 12:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28326B0089; Thu, 19 Feb 2026 12:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A886B008A; Thu, 19 Feb 2026 12:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC3F46B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:47:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 841291A0649
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:47:27 +0000 (UTC)
X-FDA: 84461938134.02.4654DA6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E54D1A0002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:47:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p7Pg2dMS;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771523245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEXDb1RTP1nApbTBOd0H0UpylDzp2isc3oWrquK2Hs8=;
	b=e8VsDeZpUCtP+OUgrNWvd6WvQSqjFkv2qBj59wFdyAPTFqz3ICRI9HSS3rPDXxDyzQsag7
	7dloEGHbIKmG5yIjBZYIGfRnYAHUfWn6fSWqAXJOHj4ZzushMV8ntXHRTDINdmYw+kvkOw
	I9k1B93TdqbCjUUcMoVr3WTFs3aUPmE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p7Pg2dMS;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771523245; a=rsa-sha256;
	cv=none;
	b=gZ0FM7atY+viMTK7k9SowvKig3rzqoV6Psojcj7Hje61h8475mNw1dHufKKIM42HOcN1ui
	6aEW9ZrVG0ONZdj3RGB7y2wzllXQDMhkQQ6GffeSzj7yTMAieZwb3AxM52jn2CzjswEZOL
	+fOv37NfkvUc+L6v077P11jSzunQe4w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LEXDb1RTP1nApbTBOd0H0UpylDzp2isc3oWrquK2Hs8=; b=p7Pg2dMSmxSq9UV5uLTY8iH5YQ
	1/Hci6RWc6b2uZbQkYi+o6O1S6ETwtncBsuN5xW65xjA5fbBMZTTLvcuBsXmNvCPpeS1mkfw3VRno
	EpvlXPnYXxH7zL+VWk+lJYjdbwlnoVvHiMBn8gyxoVG/jbud0njpPbKybaYVP+eO5GQftxsFaIogt
	v1y/TK8ja+S0IWGWny7hJpcoOOLeDgVrc3fOBdOTVJg/knTviHLeXTCNrjMkRko/rmbs7Lnormjet
	CedBMFn5sVhDZdZ79nUWy3yCnRDB+4w+l8EzxHkfZ+LHeFwOA+ljw1k+6mkssWe7WCW8S/CeCyxqy
	zuyioeFA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt87W-00000007z8A-1MsV;
	Thu, 19 Feb 2026 17:47:22 +0000
Date: Thu, 19 Feb 2026 17:47:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZdMqub5RsukLvnv@casper.infradead.org>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
X-Stat-Signature: aqgb735ddfmig51m3c34c36h7zcfshk8
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E54D1A0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771523245-122104
X-HE-Meta: U2FsdGVkX19qQvhujsglcGmPlnKcYG/I18IFU5+uye6GSQf2D6gUeTHp0nMSKKvq8XylBtAB/o2Dc2yAwkME2IiX2d4/JtRkTnPw6HvWzv+EmUgj1p7pKQVIvian8AqxIdFq2QystzkDqIrAZgUnswyWeQ9NMrjandUhLDehuy2o1sdKEK9CAhDbUe21fww8THOyrM6qkI2A0DSiZxQlf3PEurxA/tAxph2ZLtYp1+EKDdLpEpq+huIizWdFjOoOw1sw0X3g+UfxNjWqD1wzvSHQlPLZg+mlnZUPHlGgvgnIZ5N5lF8Ck2ikmVyIoBAs0LvUEOMYlTakurtVH4PqBXYcw+pFWsL0HCWf7OKU8bq3IKE5rf+ph/bmN5aR+HWKh2WXx1NLkcLRMGM0DxhTntQ8J67FOYW5FS4gwLufiAhmVSn2ZsOMjwhuCOqgH+tBg4lONYJLR6mfNcKpI/5BHnstOc5fKqkW9bxi9acIekdkRz3xGmlAbQHh/JzffWO/t8NtKdoU3lwtkoV6UwxqpWkG9nZSMOI61FeXbqi406k6IRGXOOyv8hhrpnmmzKxShSK91yh/lZ+Jp13uoXsyNwaMD7L5SaFI8D/Z2ZVS3GSKKfjxJ6CmbMLHGix4P9WZYC2EqGjd/8e05pepV9ytpZyAQg6NdRJ6rm6Co5+lRjLkeuswYcVJobw2P9SBOnvWgjLvfuVu9UsIWrGJmIHnO6+g9/EUyg3EbZJIgP3LyDpGzIkEFlzZU0JutpVMSRZUOXZoGFpeLK0/BOJvgaMAUrxyXc5oJiMLgAP5MklUb8gUElg9fIq0kAKx2d0/pnxOAS4UJirFyIBMdVuNTwUeZxshttG3UsUZZDW0ZXyKfbi47RcOrbWoY0E9vJsZ0OB2HO+LSCWClZ+Lu1tf2Zfk0sIR2VNW++/7mky8AkX4jbZEwPKXVUAYeAHQBSO7dUtzf+igkU3wfW98TUHr/UE
 91GllzOY
 7/CUstKU/gP+m4bN4juDmPVD6dngDysv9dmHAxN9Jk4F/mIPy+TID/Fulsqh1+WgrqXpPVjM44o4oagkdwbXkduSKI3ix/wL98JLkSDjVisbwRICshWEtUnDSfnixaTUimG9b+W6Kkc5LEu5bUIW6/erbBJ1AdkS416Ds2HMAJbJ8RYhvaTQYu9N70K8bGiGrn7x5eP3aPVMUj6DQHNFPwpqQKi9M67slyBLt480dBQTgAiQvW6KnmMe447bELZogCoHi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> is greater than 4 KB, we need a way to pack multiple page tables into a
> single page. We could use the slab allocator for this, but it would
> require relocating the page-table metadata out of struct page.

Have you looked at the s390/ppc implementations (yes, they're different,
no, that sucks)?  slab seems like the wrong approach to me.

There's a third approach that I've never looked at which is to allocate
the larger size, then just use it for N consecutive entries.

