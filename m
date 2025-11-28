Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3BCCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5036B0027; Fri, 28 Nov 2025 06:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C5B6B0029; Fri, 28 Nov 2025 06:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4336B002A; Fri, 28 Nov 2025 06:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0950B6B0027
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:34:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AADD389C98
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:34:44 +0000 (UTC)
X-FDA: 84159808488.12.E5AC2F9
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6252B180013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:34:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=jqPsd8CW;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764329683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n03pb56uV/bng4zeqw0XDs9CYZXB2sMRKA0NowRt37o=;
	b=XGRslcqKq1WWaQ/0UDGSAqpDqqBE0jHapSOcgmoUphtj/SiCcmPqrU0w8eFHuAx9KRY5T7
	3fiErZ+xqOIFx4kmCPIkIWb1RcBWbBXiqkHq6Wr5l/wtGfQ4viZsONRRgTzpqb9JZUGeAt
	Ewfha1TYLDVthQcGMy+mCy2twhSeBO4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=jqPsd8CW;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764329683; a=rsa-sha256;
	cv=none;
	b=DCfrT9uwyqgLriM+74W5FPi0YTBbQjtoyyFlqrc4L1u068CTBJNqqZNXYgFpJRUcfaF+3r
	FcQfBwy/h1YalH/x2ZTaFcgcVltyLkyxUcks3OVXbyADL/PyTILYUoRmYSNsQNu6tEQshX
	2m5nzasZYBOx/3sPaEBftJEWLIJXyQk=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 97AD440E00DE;
	Fri, 28 Nov 2025 11:34:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RUR8aTs9spya; Fri, 28 Nov 2025 11:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764329674; bh=n03pb56uV/bng4zeqw0XDs9CYZXB2sMRKA0NowRt37o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jqPsd8CWkdP1sYlUop+5YOGjpjpKztitu/YqeuhptdC192Kr6sCl9pIdqWtUTTQ4d
	 RlzFfkaEAwP2Jgux2YS/9xQK4tpEHyFmzGUD+QrBOWQxg+1XDNupu2hatR408pAgX6
	 sYalciOLua+VUGjn9+zrJpYz73MCkaqISeJw6eBEYVZcVkAPpXeZY/F7HcoYvSInGp
	 Zb5d6b04IdxdrBeoFmY7H6VWcL/y/vJZ9F1xjMf3ubISmokhwuSQ4Z/bHPxEweId+w
	 xIrn4wDPIXpHxUgVw4U8MJNIf/ahF/3/V7LLjGQ2LAPE50hskEZnIJfAh1ylJwHuz/
	 098vVCxSaP5i0oitGnzamsx88hO+M5sYkYOaS2W4nr5n9NAAUldloZGZc32ljKNCfA
	 K6LgfpK0oLEpWWDVSBg/+VHbUlncNcO01dRD+ZZAEY2zuojrhGw94wqqAWQdyH0Jjm
	 SFFZPPZVDzyFIZjXPezuOfYJN+9FbGr/j5tFVprbuOTmffG44hYCmlrgtFFjw8VPP3
	 sNoHRlZsgOklHheNX5P27tvAb0fQBrFm2ViGYPGBw4o5wyTY7yplAJ9BZYyxjd4NMb
	 ZlgRTFo4Ffw2ZlplE66i5QqEvPvxpu0JWa/Hzf19uoi8efmaZOOStL/8yiJGshFyIG
	 e0rb7cPSvVzh/NQcSv0U0hGQ=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B1B2540E0217;
	Fri, 28 Nov 2025 11:34:17 +0000 (UTC)
Date: Fri, 28 Nov 2025 12:34:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
	linux-mm@kvack.org, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
X-Stat-Signature: dw47jax83em5f1qdr4pbuotfebq5meby
X-Rspam-User: 
X-Rspamd-Queue-Id: 6252B180013
X-Rspamd-Server: rspam09
X-HE-Tag: 1764329682-872467
X-HE-Meta: U2FsdGVkX1/QcsYphpb5mZWbeX9HBUMPzjLkYT7sLxuByoISXW2C/EPi8XMMvPXVyVY14V/iHomsX/Py8HJc6qmajbb+vHyU/ssa1iqhLQD58SdLQR700UgT7nvv/XDMXx/k06XkwYggnTlwSgJ2j/DDARLSjJeArMOzD3AiQsGVK+XNjC4ipjJsbji89r+KY0Ry6wYzKTQB0OjICMw/Vi82+sT1DCfr4HzrfI/MWMwjsSshwbBiWa9NbDWX4Qpp6vMqZhMJWsbgWXKLPwSfJCX+iIYSyF/11GDa9l6l7HJO+zJilIct1s+H6dcBvhpuPUpGRRfeCa9Hd0qExBYrQu7ASzO9U51bXyt/R5/dMBfq7XGiBPuogae4se259VkUbGZI0GeS1fBCa7eNh6lf7QJtnJZ3dOp36XhqzDZqUJrE3fy9FqyRVsyNmViJE75DCYCf40sqIBRqlwF6L8LT7ktZS+sr7tE0HdMxF8ePHX/Ap6NyZhzn/oF6uo6INFxPNI11iBXj3/jNbkztHnWd4JcZqkRZcIBGnk6fee3LG4v4c8xT0N0raibamYDAfHioajthvtOCotUR0FyHtrhwLKgzuTPsRVw5X0GNvQjU4gzYY0DUmsdUdLjmyoc0IlC5X5w1M87fObjdGjeV1ZHqnWxnhIvywuuzpYP29bJpYGH9OXft38vMH1SxwN2PVOz8T8mjvAjVAPGGJj5VvmTAvhZaPfg6r311LnvpFFjmckTQE1dTwh74Q1qSEmRpXsrCkUCuSgWJ2Y5kazOkihSMJgmrVFVJvleyTDvrD+f9HuqYXdOs6sH7ROZcCrBr7XyvbP3jRTQBrzZG5OdjJrybGYwS8J+JjCE6dzTwD/QxatEPa/rTwYVQktWIOal+EHI+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 10:30:15AM +0100, David Hildenbrand (Red Hat) wrote:
> kexecing the same kernel is typically used for kdump purposes.
> 
> kexecing different kernels is used for all sorts of things (live-upgrade,
> grub-emu come to mind). It's quite common to kexec different kernels, or
> maybe I misunderstood the question here?

And my question is: since when do we enforce no-ABI-changes between kernels so
that we can kexec any kernel into any kernel?

By that logic I should be able to kexec 5.x into 6.x. I'll bet some money that
it won't work.

So unless it is written down somewhere, I think we should probably talk first
what we want to support and why...

Makes sense?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

