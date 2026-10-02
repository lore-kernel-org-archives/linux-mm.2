Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2000DCA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C9C6B0088; Fri,  2 Oct 2026 18:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EC56B008A; Fri,  2 Oct 2026 18:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0461E6B008C; Fri,  2 Oct 2026 18:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1E046B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:03:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 494FC1208A7
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:03:24 +0000 (UTC)
X-FDA: 85279063128.04.D04D74E
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5AF3160006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:03:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=EphSt2mc;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790978602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpSfJ99S6gKPsbvq++cNkKIHi297uZ8Oiyydd+zHjdk=;
	b=PTXwz70u2V1oCtTI+w8u555ez+CcsVlTJdotAgNIriB6EImac+elo92XIE6BSkQWbN2KP8
	TWhQM4tVcstip7BKzsoFXri0tr/n/renBMWg6crPFgQYD1R6oDD3vvAV8V+fByQ0N2bc/J
	0zk5t/uS8JEZPYVQV4H+qY9NkqmDwe4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790978602;
	b=hV3eKBXhoeiqaWzkLisUyp0nrLLsQFMRbTcQyJ14hJz8o7sbDqEUjh4T9N1HVhrgNrRjmr
	Qcx8YwOCjtuVLj9cGHFQ4vWQ3OdIi+2Dj7lrwbEIO1lrd2GppeAEo2qZXsWYRCAIRi2RaP
	BeSCAXaUlJ/hgUoh0Y9+9T7jq/9R93s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=EphSt2mc;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A40B440E02A8;
	Fri,  2 Oct 2026 22:03:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id B0CVUMO2Y442; Fri,  2 Oct 2026 22:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1790978587; bh=hpSfJ99S6gKPsbvq++cNkKIHi297uZ8Oiyydd+zHjdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EphSt2mcqG1qrC3mM2Pat8NaXOI6O+z/vNpiFeKdBiCQHLeiwK2ZzI+7vIMBUAjWb
	 mEkLhxV34Ui9pNSp4w4UAzme6ZRGFW/8P7dmg8G7XKM2MBYPNoJAqYkGYSv4SHYKBr
	 Ig4IhYBzr5pHotY8HK81DW/A3VZ+z2u0gPZpF1LFyPcBlHVoiwMqJ7Z9urSqXUx4ck
	 1lKXqZyhKfARwAcBwTmcQ4A4tvtbcZNuLwrrVuzlYynK/9LeA2worDU/QAPN0I87KJ
	 pXDCsg/ABUDSI+aNc7ay6G5ptecZ9o1QI/Z5bA/+YOsrGBiechkCxeBrqJp8weVADd
	 341Az8bhewh7JIn1ife2W50QBKTVgeQgOq4pOo05L+z+tbZmrrfoubDsrmL0/0Fiz7
	 YOPYPeaR8e9gLPWVJRMrF0jdYh7dNcO7dpqbiJEXxIQCfgLaZfgDMag2pHf89i4YTt
	 z5Xw3NdksJT/Qg3LcpMWk3sCA6O0OQP/plWCUyqhVewrcF3zZzxEmjtFGDKh4D7OAN
	 JwDk1Wj7I8PCDf/tIDsunMFs/9mGfPPmlpq9U3aqutrlB9TEKN7T3qr+1HX35BmA5k
	 xvRMoWl6Eb37T+QSMfyzltmWprqoh3sGUmg6AIiqpbQ/MlbPeYXHahosef5nY+jiqN
	 K/4X69qvOhdFyTbMQvgVDAgE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C9E840E00B9;
	Fri,  2 Oct 2026 22:02:51 +0000 (UTC)
Date: Fri, 2 Oct 2026 15:02:48 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>, Rik van Riel <riel@surriel.com>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261002220248.GJasAqCFwxOK4l2TbS@fat_crate.local>
References: <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
X-Rspam-User: 
X-Stat-Signature: 3gz9uiqqk78yhnfurpnux3r7ghyd96mu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5AF3160006
X-HE-Tag: 1790978601-703881
X-HE-Meta: U2FsdGVkX19v63HvBUBlG0LnW20L/szEFGjh9CoI/xAExN1NGSWtT2WGMT1wXvf3FqcMYOmgVNrbailM77M847y5D3xlYSc2Oi7cRyO7hX3fKitciWNZV79NAFiSm+VF7hky3vAZWzFJDsqIhQQ0EHImbgoz4IepyO/mAhkSeChQRQpujGryIa7XSTWELt3NmxyNFYVT/F3ci2CUQH6OTMdZySDHyw9K3SC3xXdKt3v7nfcSt1anpQ4ypc4YiLWqmMCG+3R9iU/wI9yuxzMAOrZAQWospe51hpF2zk6G56611Tqs5tWAxVMP+YA1sMMhnMEtIqljRjb5/30k4ylX7J8fZ/fmveymCk+l2DLLKFJoMkEmkUkrKbR8FhrxIwbvpXNauF+G83rOA46u3sif3HTZ7eTXjpXS2tgLrveaNMWKGk35dsip9fDfHIpl455N0jt/nlqu2b58zv55kyd6pPC6OwPqmGUyfesLgGTBTT5SQJhWnDa2E5ifA45T/TpYyf9KCIaegoVqzKByGa2iGmWdictQxsNsrEWkHATRNHQLsgx6Y3rxy16uovWncVwXkWSZTRl5yzxNHIyiGBvo8zAlYhYmUuDoyGDWxiJxmBwRQdfHr8NH7nU1DVaWIkr3aE7kG1oOBJpbIvy3hWqRafVrKe3x9p3iwBCBt7xtWzVxo2phEFdEa4E3TvJ13N4AIbpZ/Fm39iWkcLlX40DN+5yCYbBJIxxgMsRwoBRVGe6fSBXVp2JI6PPrTlx93FzNcoI4WMIn9ytYG99TBWn177o51o0OajDLz5X9c3cDOHly9t37gQ1V3QSGYUyfU28TzOzvyCS5msSZwPE7J/sCtr1tYLq4e8RFGKdtX5Y8eoBmDvx4x2KXV3G1DGX5YkLr7V0LQaKC6agURAM19cGXkkykmgWcUDnCVVvWnhViaCsVltzFgM4gRGmHVpL4DBw5PJCmS/TAc4+5QLdgK/i
 ukJfo+wr
 FvQQQUPBG1VOOxXuYQ+3k4JIHbRFJKiZR3GzpIe6wPMSm2fMGnlhO9BvoTtQKkvNJOEe+bJZ+PUOw13IKeHlYEbenmDQUyYL6ZBw/vbyc3Z75TFl6CWkA79uRyWFvuGCOFIxdNKBe95czRWJa+NOlC0TiPa09Uj5x8tD5nN1EfYBOalcb1n3EJzFPwlvb034EVxLwJsaCGJGCyWC+cP4n15R2ZwEXB+fjgDO71/sBhYqWN1TUVs53EqNMKB8AabuH97u48kz0A5ktdLivmG/sYxA5udr4s+kPnrEfxKRsQ3/bP3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 04:55:39PM +0200, Nikola Ciprich wrote:
> I'll leave it running for few hours, and report back. If I'm able to reproduce,
> I'll try recommended workarounds and report as well.

I'll venture a guess here and say that Matt's reproducer won't trigger on your
machines.

Just to rule out any other issues which got fixed in the meantime, can you try
mainline Linux and see if you can reproduce your observation with it?

If so, you could share your crash core along with debug kernels yadda yadda so
that I can poke at it.

And before you do, make sure you have the latest BIOS and microcode installed on
that machine.

Also, where can I find full dmesg and /proc/cpuinfo from those machines which
trigger this?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

