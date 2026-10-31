Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C6A606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lo7IeOrk
Received: by kanga.kvack.org (Postfix)
	id 1330A6B00EF; Sat, 31 Oct 2026 16:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E44B6B05B1; Sat, 31 Oct 2026 16:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B806B05B2; Sat, 31 Oct 2026 16:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAE0A6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECCC51A0814
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:14 +0000 (UTC)
X-FDA: 85384053468.16.7E51A31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 216E580005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=lo7IeOrk;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478373;
	b=b6A9zUekaQkRxs0SFK5ATMPCZhmXBlvX9BUo7giWrbRQRiz20yCLX6Hr6n54q8hk4hj+ip
	C9rRhX+NlXbWUUdvxQ/YjgTFhksVg84oQ1LVLcCfsPVvNjOy1S59fmNdmeIOIKyFYcHFx8
	VrNLztoG1M7MRtYV9zYycgzGisrNWQQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=lo7IeOrk;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31OiWa7Bx6I+GremiKpxsthouh1jt/r3kqbeVlN0OHs=;
	b=WJiaoHel3Vy4slIbUbYjOHzZTXrvmcyIKTj6wOoRsz8D/QJAZNKL6hbz38AFepQXg6BGjF
	75S2TEJm0+zIAHicAILp91xL4XKxB4ctv7ihvM3DKT3Fc/h6TXbsczDhxiLyASkhIYOMKM
	qySiXSFvsefVH3bmbLuX61fD6S7KgHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0945600C8;
	Sat, 31 Oct 2026 20:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6AB1F00A18;
	Sat, 31 Oct 2026 20:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793478371;
	bh=31OiWa7Bx6I+GremiKpxsthouh1jt/r3kqbeVlN0OHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lo7IeOrk67ctqrGEFCDLMXypVEqIIsbbanGBvTw3tsxy4zUap5zf87NtFJYtMIGKd
	 RxfgmhQ4vRf2jK9dBpv3zeezgtDNbmPe2fd/N342PR1ugL2lvFgDOB5LBtMQ14+ZA/
	 z4ePe3R+kEmPnj3kp5mVISBjiG5w9cKB39OsWO1c=
Date: Sat, 31 Oct 2026 21:25:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Radek =?utf-8?Q?Marci=C5=88a?= <github.unusual340@8alias.com>
Cc: stable@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Kelley <mhkelley58@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.12.y 2/2] mm/early_ioremap: Sign-extend PAGE_MASK when
 aligning the physical address
Message-ID: <2026103137-showplace-numerator-a05b@gregkh>
References: <179346145167.7.7861216093151225931.1735978772@8alias.com>
 <179346152914.8.7838190602983146541.1735981230@8alias.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179346152914.8.7838190602983146541.1735981230@8alias.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 216E580005
X-Stat-Signature: 189pdbjg1iit1xxfo73m56nidu9pzfbg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793478372-533178
X-HE-Meta: U2FsdGVkX1+JT4ZsYfVT9Hh5wEIn19W43b3C0CEmO/yLYJHy4pWzMOlwdkyGfbp3vh8OL5dNyJGjzsStQ7RFV8aa1Oqu2imCr+yQCicfQwk4tdq/aN+VxfrtpcP22qZ8OO2nys0jrTOYNGI6oVopcbdeSN/TrUot2QrRVIx092lGMUomTSsPMCy8rtW97zsblbOqMNB5TpGKb3gxlCM3+2LykG7k97b97uQlbfVdKhHzwfcjd/5y511nsgMXNgZ7A1MSqRDj3zII2cJtVPw/N6hW1KQxnYbqlVKGsRn2R3jPheOZj7y0t/ApPeTwvJLwu3RvfbOtJuZBA9BaXDUhP0AWxYHalh7TreA6yWRRAciVVxhPQob9oZz2nH1QN2CU2yeUlczsPAHlrtCCPRQaFdIOLQWaQgQc3XL5xiA81SOJCD1b6uPonn2xAol9Kv2k1U4UwZqZcntz2Q0Lb62MQJv5jdoVRkYk/9EhQ3PGXVS/3pkSIvRE6N6dbnCauyIWE/mYdLzQYiNZCNKFWnOgzOmLauhMWBXQ8y4kLj4vtAtDf4ts+pWc2HzT16KfZrf5RPDhotqvlcMTrusD/npsPWBm8kAMyUOnjXK8aYDA1oS25onqss+ZyEA3SXWJBpgLy/o5Dhn64q8xeQS/3cE8E2mQPBpuRwearGDfyvaHybWSXwd9ugMyEQHGcHwlj4/mho6ynWhgGcHZkzKULkEMdvR/Z41qBRfp/ew41uUZROVZGyEBNFnauVdjAVCtp6tyNLj4pf6owT4Ik6JWqvIR1CLBhjMJUe3fq19Hf7Pb1PQ31E7aYJvyUCmM2DRmcsIu6ZSKEqZ7KQyfIEqOWi6FuA7u7OrNitDW34A1j5PJecLBqRoQTaM2KnuRuF2xK07zrpt97PTIAZqZGLwCNEk39mPvp1wAPC5C/FK0KzqmA+es0/iPRPFnhitX5NTO2SRB2AJWLNRUY+Xywif25gY
 qfUgmeh2
 BKrlMFGujccSiNoGVLblb3ddxskZZyABSnVKuDH0HS0dS6ryC1R/22xC9RQJBUUUm++Q31BFLXFHu/Vag8wsWgxi/p5pzuwKV6gCTtA9UH1dGxRn1ZS6zAys5t948A7KHbKKZdCf9NfgGdgjee4qlyfNXKteZiVWbkjKar+zP6pTEWlXl3AEyu2LX+cetzXbaKBszGH3IXxC2TSJSsoNc+ER8m+8aaXRbeRumRGBiQ3nRMFfkk7/Cvp4r/MY5lR69WwbAUlNgGVgkz7/wK3NvFktf96pFkoN+mJLc/CUJsc4bIMqnBFgZnJueKSoZ0Zz+dbcBEkmSRBHD1Jg++hmIq5UkakbY62XmabiopQ4vjoxOD3vyR/m03dLcrVEIExTwvbdT0uBUTcIyQjtBqwJv5KE4NHDKiJYOxD8pbAKzZQy9cqu9rjrotSWE/VruIWZtwJu9q8WFclES8yPtkwRIxMnYLQqHR2afYz+la/wnJ/uzVgvm9GxU8Q0ILQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 03:45:21PM +0000, Radek Marciňa wrote:
> Signed-off-by: Radek Marciňa <github.unusual340@8alias.com>

Sorry, but this isn't going to work for the obvious reason, so we can't
take these as-is.

greg k-h

