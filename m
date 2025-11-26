Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8DED1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 22:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3D26B0006; Wed, 26 Nov 2025 17:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB806B0022; Wed, 26 Nov 2025 17:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07CA6B0024; Wed, 26 Nov 2025 17:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A27846B0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:32:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47AA78A4BE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:32:02 +0000 (UTC)
X-FDA: 84154207284.08.BCD87A3
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id D602C14000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:31:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FKCD5IxZ;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764196320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCGX52XkArpHRB0malEGuxEN88kirZhyxtG2hjA3Tq0=;
	b=doPwv7AmGkF3t+hDjc+Y5k1tUkHyWQyZ5Biu9Qgy8JKEq5S46JJooIc1GlMfCyOqsBt/fw
	FjMqt2fvli7mP6nTrpmZIBaPlnkH8qcRsgXYAn6aFssU4h+Hu4lEVqu8oVcxdogPPuV0ht
	iYAcgP8oumMg404s+9RfXgL6GwOWNOs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FKCD5IxZ;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764196320; a=rsa-sha256;
	cv=none;
	b=MvA0+hmvInqUpCMmmqm+sH6cTnmNb23bTh/r6jyvRrBo9lCTaEIRxeDe6fuFBTLjh0Qxtf
	caez+x0Js6K4vcMZfj866nTOwsMH3h74vIB0WlUbEU7Ktrv+Lr58KqVvayjyo7YMCHpLq0
	KwvwgVerFO+5z5xDeNIWHDn/NUDzPJI=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D96040E0200;
	Wed, 26 Nov 2025 22:31:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 78zWO8m3eFdW; Wed, 26 Nov 2025 22:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764196310; bh=OCGX52XkArpHRB0malEGuxEN88kirZhyxtG2hjA3Tq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKCD5IxZ9QnWpJ6q9qf720njFD3v3xcOuhp5akzBOPGn6LfBpD4pj0ZRi215bvnVd
	 rKEuDt62gtO0ZqxVH2oUTEnSjivuz2c5IgvYkFx5NADGFttr8SDsZljG7VXKm0n1Ki
	 4ZAlNYITs7YAbfwbdT9Ylcfo3LXCtUC+6avsoBBVWULZ+cAt3eFZBLWcKM3jvyXxHy
	 av9ayYWfs3vN6OBlkiYz59JuXysW9VOO0SbTilZ4AfAfpzh2H9kpFQafx7VfPQzn2g
	 7PaxTQ7lDppVk2FXZIeGEwWDrcuz01l1Wya8Q/cG2hBII2Ua0+YTJzLBy912OBy58s
	 ibqqNlyXL4kcshkVFPIz7cy7+oZfFi5c7x8tSDMo0F3n6SnePE3SLI4wbX/BjtepN5
	 eCTagNmjXqK80RWzpUjNdYE475JTEyMkWyu8cjqAHGhT99lbonn8ztHu3fq5KGVBKy
	 MQRG/ovQYMfx3yKxblEa/XgnKAOQyg3c7u+ZqwvzOe60qEyxxlRVBc2bzCiJvEONz6
	 10t+lqAl0vM6B6lllVejc/uCvaJpOI/H/BW25LegEM2ut6aoXvZ+cKflFwt13yvb9/
	 AUbFn2SRxndw4kmPfncF0MmlINuHIdLn6DvLTdPNqq8rUFgGh+wnbsgGwSdULm3881
	 zPwSiP/GKjKYduli36CePJ0k=
Received: from zn.tnic (p57969402.dip0.t-ipconnect.de [87.150.148.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 021BF40E01CD;
	Wed, 26 Nov 2025 22:31:33 +0000 (UTC)
Date: Wed, 26 Nov 2025 23:31:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
X-Rspamd-Queue-Id: D602C14000C
X-Rspamd-Server: rspam02
X-Stat-Signature: ybptk85og833zfhdy6nzmeq6w5b3o84r
X-Rspam-User: 
X-HE-Tag: 1764196319-135900
X-HE-Meta: U2FsdGVkX1+Ic4OLieuwa4T2rO/8E5QkXrA1ygbiT8fnn2GPKNKOL0Sc9YGecwYKgXuvSg1RugLCYi5bOE9TTIdOEX4Wh2gVtb50NsO5MpVjDNeQA/ezGASIK7wW9ivBbFLbKMIN9l3B1fX1sqLG9WMFggl9O43y37phMGq7QCmw6JYnA5BZJ0RbSMIZWJFU9nGukJlwdWjSNbtbAGvc6DTc0xVHkXGs0j0vqdqQTb8S0x85VL7zGhVeRDCh/exlLBgSRDNgp1MVKunr7kVlau69RsUT7yt9uxMJMo1pslPZ90t5HC0j21VwfuYmWE8l1JbiiNVS+4S+10pdO4pyDEv7yV7NJjzJlnZo5qkeNal8VFLprHCVPg2IfdoLb/Lwb9tJZVPCaoKpz6uc244OHikmlvPxQuLLIAWYrnCF5Jke5FRDv7DalBkdKWVh0YBP7s1ntR23TFAwWyq+jAxwuqZTABFo7Qn+vChJFob6L15zQiLUNfMkoxsXMSsMd+sUN0136X/YV/ONYwOktPG9DmJtTQcZlWWMfotz5LTjEOJ9hMfy5nbZj/7pyqp/cnqQJGNoswKX92LnQhtxazkcgWwovDp4ANaCqi9HjzGFPhxCdnjPn4a7UNe/pnmTwXXRYZNzGfYc3Jri7Ww+808aoEK8+xOM3o5r3agbfyeJ15wNJ/DRk0o09zDyEeL63HI9KJmXpXMkvUBAUDstWAp1Hk/uvmNiflKqtLsfoJmdVqHUd5OuSlL36Erh8iRXItRZv4Qpknd8mkHs9E8+rTUhLkF1iUzjNqgLaLZ8ed8EWXoYD5inQxvegJCSp7SOEU7TSheI3WEFNxCLFSpOhddfIPFVzymHq/talXQwdJ7PheIzrZT0cwLheFn/uwkSmQINdtISHwtJ9QXdoieM8NipA1C3/D+jhD3CKrA2Q6o62I3CcGl/DSSLUnhNcbwSBm1Dsn9ddCt17EWK4dFCwhY
 yQ65hc52
 w57Lg+ATa0C9Xpio5XDiJEzQ+q4MZDSvjDV0G1CPk7ujszcufLiRuex+6+rywFJmSsHyVh1z4Inrxezoh2xtKZP0alqk98kKze7UGKRnzW/YwQZ8KpenRDB5s5X9RXeRDANolGUIGeT2yCs+aZxEwnquqUGUnK7etvFC6S2TXmVTTNUMqwo52u6B7QZMgqWJfyOUYCa+Lm39YvDZ8dzKNf8dkB437xQ6S66E/DO9YaI3LGZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:12:13AM +0000, Kiryl Shutsemau wrote:
> > diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
> > index 4f7027f33def..a220a1966cae 100644
> > --- a/arch/x86/boot/compressed/efi.h
> > +++ b/arch/x86/boot/compressed/efi.h
> > @@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
> >  	u32 unit_size;
> >  	u64 phys_base;
> >  	u64 size;
> > +	bool mem_reserved;
> >  	unsigned long *bitmap;
> >  };
> >  
> 
> Again, this is ABI break for kexec.

ABI break for kexec? Is that a thing?

Since when do we enforce ABI compatibility for kexec and where are we
documenting that?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

