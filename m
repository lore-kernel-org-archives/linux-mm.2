Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEFECA0ED1
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 01:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029AF8E00AB; Mon, 11 Aug 2025 21:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CFC8E0045; Mon, 11 Aug 2025 21:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32808E00AB; Mon, 11 Aug 2025 21:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAB278E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:56:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E0CC1D9CBB
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:56:39 +0000 (UTC)
X-FDA: 83766441318.14.DEC286C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id A2B4540008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:56:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uDzzi4Sq;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754963797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/alzWjQ8g3Fl42BNTZ/nu+WhrEcJK5LRqgE87dY5N4=;
	b=pnvGnuZhgt/Izj5AapP23P2Pxg+EUAZU3njic42Ad+2cS0pLd8+B7jzMeK1v1Dl81CofWQ
	wmuA/AgNoXbpN8UqTTdyCeuBb76C6lvC1t0PJK8P2jvOjjBXK10hcoruFEQ60eVMcX4qnA
	sDGyu69blekOI066H0ZlCT1htgmkDUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754963797; a=rsa-sha256;
	cv=none;
	b=jY79joGFsAQAnNVxCSxTrtgWouSTYvwcP8j8+cMRQrB5aaXPpgmnPMdSZz1K909T3tBBBw
	S8I5LTZRQgrqpaDY2VsfptIGAGNA5R6crm/9UxdwVNupzVFoXPnfSwtB661+R1ntw6i7DU
	8ehy/tjeL7HexqvZWxv+eCx+EW/eHww=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uDzzi4Sq;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id E6B28A56EF4;
	Tue, 12 Aug 2025 01:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C58AC4CEED;
	Tue, 12 Aug 2025 01:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754963796;
	bh=hBSK0PX+81rnA9LuOdB2E4A8PLVyJnCl/SZJxlw7J/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uDzzi4Sq54eB+bbub4G2BGLTrMaAicSK/MW8JNXopL5x7Kr80Dnosw4CTZX4m+qEH
	 lPxTDc06DtH4JEmUnm6uRfJoGU5c2eSXz+4iTpVUiUfRlWKp0qQZ4Ghf4GPkcjx9yK
	 e5XlbT8QjnxeGWGNdXv94N4B+EIYlSdg+lkFp0PU=
Date: Mon, 11 Aug 2025 18:56:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-mm@kvack.org, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V3] init: Handle bootloader identifier in kernel
 parameters
Message-Id: <20250811185635.f51ddda72f36bc0c2ba20600@linux-foundation.org>
In-Reply-To: <20250721101343.3283480-1-chenhuacai@loongson.cn>
References: <20250721101343.3283480-1-chenhuacai@loongson.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2B4540008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ic4uwdqbenz48kcnesxb3wtougcxnrqz
X-HE-Tag: 1754963797-383749
X-HE-Meta: U2FsdGVkX1+IuEjEnY5rcEoOaYV8giJQbOOEnld0STlTYLnpr6AjGrcfmdQ+QW5I+muwhvQhtBD5f+ntnvH7hLM7zT8f7ftxmpsP8tFjGfP2uCEbS7lL4jvxK8p6RlRliQRRUJD5boK2vaZbDxGArCsByfbOHL4Z3Vxh2urG1zDhSUrJ2F34t5b0etVl+RkJfoi1vHkuLUerCw+31iaKPgg+aC3lPJB3ZAN86QcG//WDt7/IW8/vPgML6jbpneGe8bF3jqHteLu/6hUd/snWjvn94k9yI7kHiV4BKtXY9ErsB3ShWxZsurKISxRAy8QAw3wJ3Y+D7mY98XanajONJTb4sNxpdVki64bIINeWLv54dyZVLC6Z2MTnI3Cvb81awBGRLMahNRhikMPbVUaZR66T1OZvheaiSKNJ6WxlHOgqIniICZ6CgByYywv043p8wKl1O/hxmNDrOnc35qAcFYy+jWKN305M2I4SkeBV4sNMVRpvy/0KsWVRSPIIK29Zn6ZHzX2qG3LqRcn7eMYxmTRBUDsIKKG8DB8duUS5/zJz2zcFnvac9OoGBfw9CxlV5gfsshgYSwcm4s8U6boEtfs1aHCFQpHPjaTz9RMaRnd1xeNHohlDmX9lUIyY7+lUfno5V4MM4uoVR/HmOk7vElnGn10ZigGouigJRrnaSID6tFeeTieoIHISUDB4EqVwuScbZTC9Z2W0xC9ouogW8spWxy7cDybWzjsViP9sP+826TEcJotTDe5AUnB0Kh54ttoVzY5g5+GRqO66Sn6RxapGPKfmsv43771/WjwMJgSu1CEELurPbWf+sveuiDm5+WT/ejElIV7HBmXy4y2vVKefPgIQmYH4seXbtgrnOsd0/iuArhmLB4I3p+O5dnykqClZACyhqq5GbOxIIDdaSXYyK45hgr6wV/GDCuiKXVh7fZW2Qn3ZzeR8kYaCwqR/lxW6Tx3UEEYSDmmofTb
 vEKr/UnY
 mYnFxUZ9fkzgmnWzfzvS7nPNBGasVilaWdw0KvwDOdC6AQjiqVvZHVmOgTAFOwNCCBcvzX2K4mRhRIK6Bse5hZq5Q+CCUN+RXtAMSAKyvrhf+m4WUsPBs/nk6I7fIsk/meJsJH7C4h0C2/ODGZYwJv8LuRMX6PQysQBsVHu/Ilw+Aj2CU1EZmX2mGaTs2WrieZMrFIoe7gJsAaXkEdI+qCOWkPonXqmJrShGY+kVWnworMDStboZ6HLJCdQ/TYlUenmXopOxY/z0e9PyPPMWmfz5I8+JVIEQiY1ffDFNSsQRyEH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Jul 2025 18:13:43 +0800 Huacai Chen <chenhuacai@loongson.cn> wrote:

> BootLoader (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
> /boot/vmlinuz-x.y.z" to kernel parameters. But these identifiers are not
> recognized by the kernel itself so will be passed to user space. However
> user space init program also doesn't recognized it.
> 
> KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
> some architectures.
> 
> We cannot change BootLoader's behavior, because this behavior exists for
> many years, and there are already user space programs search BOOT_IMAGE=
> in /proc/cmdline to obtain the kernel image locations:
> 
> https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
> (search getBootOptions)
> https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
> (search getKernelReleaseWithBootOption)
> 
> So the the best way is handle (ignore) it by the kernel itself, which
> can avoid such boot warnings (if we use something like init=/bin/bash,
> bootloader identifier can even cause a crash):
> 
> Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz-6.x root=/dev/sda3 ro console=tty
> Unknown kernel command line parameters "BOOT_IMAGE=(hd0,1)/vmlinuz-6.x", will be passed to user space.
> 
> Cc: stable@vger.kernel.org

I think I'll keep this in -next until 6.18-rc1 - I suspect any issues
here will take a while to discover.

> --- a/init/main.c
> +++ b/init/main.c
> @@ -545,6 +545,12 @@ static int __init unknown_bootoption(char *param, char *val,
>  				     const char *unused, void *arg)
>  {
>  	size_t len = strlen(param);
> +	/*
> +	 * Well-known bootloader identifiers:
> +	 * 1. LILO/Grub pass "BOOT_IMAGE=...";
> +	 * 2. kexec/kdump (kexec-tools) pass "kexec".
> +	 */
> +	const char *bootloader[] = { "BOOT_IMAGE=", "kexec", NULL };
>  
>  	/* Handle params aliased to sysctls */
>  	if (sysctl_is_alias(param))
> @@ -552,6 +558,12 @@ static int __init unknown_bootoption(char *param, char *val,
>  
>  	repair_env_string(param, val);
>  
> +	/* Handle bootloader identifier */
> +	for (int i = 0; bootloader[i]; i++) {
> +		if (!strncmp(param, bootloader[i], strlen(bootloader[i])))
> +			return 0;
> +	}

We have str_has_prefix().

And strstarts()!  Both of which are awfully similar and both of which
lamely do two passes across a string.

