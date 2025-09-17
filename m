Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F3D6CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D222F8E0056; Wed, 17 Sep 2025 12:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8548E0002; Wed, 17 Sep 2025 12:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E558E0056; Wed, 17 Sep 2025 12:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A97258E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:23:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52ED459BBB
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:23:48 +0000 (UTC)
X-FDA: 83899263336.05.7A55756
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B77B20015
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:23:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=b1QHgXi5;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vbpx2/EQFsv68Z8YLJv2Q1LEaliBfPp1phTF0OcPHX4=;
	b=YrwBsNGGZrGi8cZSnKT2CdrIwoqW6rZMraRWdOJIqu4vzc+2YomvJCTMBdMtsIG0ZOHDmO
	+UdZLwJOvzOgMbBCb/cpP56oHcy6+WiKM1IscaF0Ce/74lB+6kLFX5Est9E/Jwct+DPKQl
	EZc7cmnA3oHoQwzrEMTwzmkLeLBZFB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758126226; a=rsa-sha256;
	cv=none;
	b=Kk7SGKftpbjZ+dYUkc/LYw1jcEGdGcatihd46TrWypxiOmh3v7nuEw0oSgnUi+h1dZ7Ap9
	KfSINDWihbva7zqLxUW1CPOvYJytGRZU7w9jr+I5N6lk2Q5jurdhHZkFdLwqsZ0LvSWTM3
	yzwWkmBVGzZ7wzSpBziUKFLE0nLm+oM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=b1QHgXi5;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5202540E0176;
	Wed, 17 Sep 2025 16:23:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DLmdsVukSGBV; Wed, 17 Sep 2025 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758126214; bh=Vbpx2/EQFsv68Z8YLJv2Q1LEaliBfPp1phTF0OcPHX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b1QHgXi59hwSfoy/WamP+UQar5Wx6lMdvI5x0AupjorX7gJryB3gf2+K6ZycJND6B
	 ftTs2l1lBif0obM6nPca0chtIDKQNY8tfU+oQ2k/SRockCWgVHwXJ0KT6e9YkZun4M
	 q+GYLCBBBiQPmjyaJWGQSmnQooPfV/o+g+48GazhYZdLNNBvbSUkob4f5QYkWrDAs5
	 zWgnD3SaaPlrz4rOiC2wgXnewphWzWobY9qKNbEq+3sn8ib1WVGrA5/0bzSmFmEbbp
	 39U5h8sn8FdaagJSt3/hrtHG7bj/8uxAAlaggpx/1DRrBTMxDUIhmM13sIxsrcohPy
	 tM+MAYVzHt1GS5HEbIIwlk6uYw6gnxzc0fgtW7rRoJ5LHJTjFG2OZw4KAHJE+dD+ZZ
	 3W74juSmASbbzditF1Vj11hs4ZBqzyfG/pah5LUIdJXo7dKb9BPwabCo5Dx8HG9RkR
	 0rQrei2zIC5XOxwdSHxygp9+DZ7OKsw3Lw2j0KGdk4g3X1jfTUmnuWQrKmXatG/7+o
	 UsoR1nXfdVvf2LnP03zPb61sKAH9yvdHjTVTE+Sprw3wNpRHTZ7F5YgZstvF83JD0K
	 YreUQHA0D5EZVU2uj8S/ubzOgUZ9jc7VdcG0iFQCi3Nrmj14Zvq2yrbaoJOL3WZpRP
	 O3kuWMdPuVyQPTIlgGzImDq4=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 5666140E019E;
	Wed, 17 Sep 2025 16:22:59 +0000 (UTC)
Date: Wed, 17 Sep 2025 18:22:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: "rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Message-ID: <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9433067c142b45d583eb96587b929878@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B77B20015
X-Stat-Signature: 4x583jz1yz1gncwss9iobzgaehpdtqky
X-Rspam-User: 
X-HE-Tag: 1758126225-866057
X-HE-Meta: U2FsdGVkX1/qTXT43PgtGJPRdkThnDpxUwOO4oM511Ok2tjdAJoLzWYLRkq0z41/77Fop1CBfQkkhHD5Z6yW4o4PKlQWN9NZHmIuoeU6ZqKFRpOFQxhldAIif05nr0YhbOmz56x3HpKiKAt83Yoacd7iGqNEEb+xBzBM7nt/E4vdlhcw9hlIPpNc2Rnvcy2Qog1LbCmecsEJQK4k0ZdH1C6WiJdFISZaX+Irgtr9Tsxg2JZeSFfO3aS9NmW7pH7MK3r//oGjW5GyZQeS+euzm6nMibmc86LnbHkJSR5MTksljnZpMaaFxd5mWFro7hChMlJWk4C93yNac4k0VmmGda6d5k54A62Bm1wW5zpddSvwtCeL14E9J9Wns5anR5gjP4Ns42jou0gpqnH72u0X8eF+RZlfUvObIyUWhE7R5k4xh0LAqwDC0x1c/p+geYPht/iVnG2xoLlrS4cbThDwPSAogZbI8hkYqXs6Kuhth2ik05ExqeArideZDU+7E8TYBoOo/WvZNBwqzHtoJotdMxa+yx2exRpji2s2abCRC6euJQTiDIKP+pbPymezC5ScNHkV4UkE9dgx56bXfOuBtg+py5g2zGmHGe2nOWY/UdxWJ+USvLTy2nrJ6fY+tZBFWwC6pcDpmUlgEKeJBGAnofWPJgMcNcS/qG1d8Q5lafxT3flrWBLec3H2m2pzZKvX5KvYiegbMPLAzjDO3NKoinVWgmwUbFtYiko2n1QgXSZ691zdMuMBcYg7HxTwewJrFsNOKOLf02o5ebHGR1JKcFj0RukpUEou34Y1pKR4AB6XS3T/9wGShR7A63UWGVpMJcz82Fy+YzSeGKyuwWbW0jtUM1paD0auT8w051UWWERM8xp5/fuS9Hzdsw0H7+OXbVXfFT9AqTnnzS1e3Kgf2eyhFZTIBIPYvW8s2zk7ZS3AdgRcBjk30Gxby4lnqI0QWJYXegUpBalxXfX42mQ
 fzYC/hAV
 YwjKn0xBqcW8hoW6E+9ZMpzROgT155DCgEFv1uyY3PtCiPjURXPDlhRucQFWclCRlVijCfzB41gmUKv5jfRunhpQEdVVD7NfTH1tVfklV2q02+XCAm6vJSQBRxosao/UD6oMBVYAl0DoNWSUDgDXj9f3SG/Sq3mv0qOqq8NS9iCA93v/gdKmAZ//eHg4tRK3z4xQQ1AW8YY0dic8LfXaJIPT68QgRiYox3X/u5UVaJ/hWm/CKURIPHZao0cfjkIbdBzpe0pGQpMJPxAnfTx8l9fknwbBN51PflB/4NlhW6pOrt1lUhVL5tUR738uEwfXPXWOmoABJHfh1UZEpIJq76L562bLBfnQk9p/jogkJzEKVD18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:50:16AM +0000, Shiju Jose wrote:
> This has been added as suggested by Jonathan considering the interleaved NUMA node.
> Link to the related discussion in V11:
> https://lore.kernel.org/all/20250821100655.00003942@huawei.com/#t

Sorry, this doesn't work this way.

If something in the code is being done which is not obvious and trivial, then
the reason for it is written down in a prominent place so that it is clear to
people.

Not pointing to a discussion or some funky place on the web where someone
might've said something.

Your patch submission should contain that info and not have reviewers ask for
it.

> | node 0 | node 1 | node 0 |   PA address map.
> Can you give your suggestion what we should do about it?

I don't know what the problem is to begin with...

> I think Option (2) seems better?  If so, can the EDAC scrub interface  be
> updated to include attributes for publishing the supported PA range for the
> memory device to scrub?

The memory ranges should already be available somewhere in the NUMA/mm code or
so and for starters, we should start a scrub for all ranges and do the
single-range only when there really is a good reason for it.

Also, you don't have to expose any ranges to userspace in order to start
a scrub activity - you can simply start the scrub in the affected range
automatically.

Like I preached the last time, your aim should be to make as much of the
variables that control the scrub automatic and not expose everything to
userspace so that some userspace tool decides. The tool should simply start
the scrub and the kernel should DTRT.

> This returns error on the first failure.
> 
> What if there was a success before? Does that aux_device need to be removed?
> 
> If not, then why return failure at all? Why not just try to add all devices? Some may fail and some may succeed.
> ============================= 
> 
> We thought second option is a better because a successfully added aux dev for a memory device and corresponding
> EDAC interface continue exist and support the scrub/a memory feature. 
> We do not mind doing stop on a failure adding an aux_device and free previously crated aux devices, though
> it may require some additional dynamically allocated memory space to store the successfully created aux devices
> so that free them on a failure later. Hope that is acceptable?

So how are you going to present to people a subset of devices loaded? And what
is the point at all? 

Is there a valid use case where you can use only a subset of the devices to
even try to support such nonsense?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

