Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D753DEA3F00
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 05:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D3F6B0088; Tue, 10 Feb 2026 00:24:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D06D6B0089; Tue, 10 Feb 2026 00:24:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2F56B008A; Tue, 10 Feb 2026 00:24:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6A76B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:24:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB80E5876C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:24:55 +0000 (UTC)
X-FDA: 84427407750.04.91BC2B3
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80B8D180010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:24:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=EibEAGw9;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770701094; a=rsa-sha256;
	cv=none;
	b=TT+hZL1pqDffu45j2rclszg3+yMzD38naJGu2zKpU3X4YG7jSheX4LWUYtWlXE69Q5GQmM
	LdPZTaglsfbP7HayTKO6eG85dgvTtiTpNLP2+dCmnMbJG4NmUUfbEb31LqQ4fl+rHcbeY/
	ScOXn6dflI7yqp4d8TkDFasxfb91Q5s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=EibEAGw9;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770701094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/7rWnoJfr6/wTynS68F9CWZaEm5ASoXcAvL5grOGVE=;
	b=TVx9gnKkigzPxNv3juVX4wH61TPQ3pR5MLofhxQU41ayfy0pwMUgd7RK8Z0estLKb4Lzp5
	dTgk64XRiAw5v9wV3LFotviEiB0h67IQPJLzsSwGepR1ShzKioCFZjcxrEDxKqDwnGgCf6
	NbCvYwgqjMyiHt80ZYtR67xM3OWUypM=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A5O5Yu3174215
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 21:24:13 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A5O5Yu3174215
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770701056;
	bh=5/7rWnoJfr6/wTynS68F9CWZaEm5ASoXcAvL5grOGVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EibEAGw93EXIJD+1pMGDkuldPftoy7RwajBcKhpSj8h3jZo0/9gZ6mzqiCUfco+SF
	 6dG4SvGlu8xLZvLVwzTnaRtHOKPHqYWXb4DMTQr0VpBB+EAVUAsccAh7n4ZYTdEKvb
	 hvvyeQjfW93yf2iSwjnIvw0Jf4jkG6gjZZFwslwjglHAD5WQnW+o43mAM6T5K3KH3w
	 5u0Mf8oFyei98M8K03AptZSC4xJEw1+Sb3KN4GAGQBQR8r0ACuA8iDyoHvSbkRVfEW
	 9trAdUc9rAWd8cMspGvRzqo1aGNEFOe9g9mVX52R5SyW3CKpZ3ilMvuLSgR+DQVsYs
	 d4GXySsi1RuTg==
Message-ID: <663cc342-4740-49df-8744-3142f3738dd5@zytor.com>
Date: Mon, 9 Feb 2026 21:24:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
To: Xi Ruoyao <xry111@xry111.site>, Jens Remus <jremus@linux.ibm.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
 <20260106211856.560186-6-hpa@zytor.com>
 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
 <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
 <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 80B8D180010
X-Stat-Signature: 6nnioqfwreipxgsbp5b1549nbpcp1nrk
X-HE-Tag: 1770701093-143714
X-HE-Meta: U2FsdGVkX19V9hZ/JJ66Y7iM5heUa45LjAGxygkyytTvqCWVYP4m5q1fs01n2Fk3XiSAmfe7Eoj6mD3DBjxLYPIaa+5ujtfVi4NKB8jq+lFjZqMxH/AdOhsW2Q/mzwJxVVvkUC9BqrnQqTro9Y/mvd/Z0IilBEQq/s8XwgjvLG873GxQNOSVs6ogFqINdnY5VD2lTA4RfD6hYWpg1o0KAI/1SyOOjllcwAqp1ypMaGcyrCc6e9asGGjHY2M8eBPt3eHuTXLCPvP4I3ETAWjiyqFaYcz1IT1Ao6RxiTF3fQGkIQ2t+ZPdNdvAYuXdpLzIt6W3YeU6eaO4VnVZ2b2621BsiyLNZErf33jHM5PZ/jODw1EbOiTJGjKBEqoPcRLP+8LOJ8gna6zdbmjvNo1tIm0CyG88A7I9dGS/A9uekDOYQjBurw7wfEX3MSax0j7f2kQzEMQgmw3R4lzAh9bFsXJqVjJ1XylxobkndVNlvE/oNb8cvGLk47AWtblMlm4/VmxVpUd5d+Pv6Sg4Fbh+j6KLJf0cIB/Vom0mWq2cVKne0FOMSoBNGsrFrFNkVCXLCb55nbcJwIWTVqXXCkafMmuq77/1gowgktEHj0rNsmEv8FAhoH89X8BE33zhRmujkLgUoXLuTJPEQRyePM516InzibH11UDLZI+wsnPyK4kMkNvnRJRNLpPQRFnfHrYlUY/T11nBWYrYNVCGyP6+sG3o/krRNPuBtP3uOr/B/18iW2ElOrfLRWDXdbdsdDdMrXExlTJvRl0jeOttBo7HG05bs6fFp6HY1InfX6XLy7Ib3tX29TLkpwD59gmNYtD2mdlj2/70FZpM5Xinveip1i+mu4WIod8p6vEc90cD5j1lY2KF6IuP5wt926QHuQU59Hg9oVX/wZbHltTFHet7CnagO97vbMQzXUzL1a2+kro8+kUw/rWOEjtJBx43MrJSh0IdJY+DsNkdv0v9djy
 oZYNFb8X
 dN1HUJPadie8c1VtkUX/00+85iB53f3Cd90e5kiwtBa/tkivkeRJgvlZLMqT9cpyj9l/VQbvd5T9/lguzNm41sUUQiHSsb5D3/3ERW0I/R5qBaZFdEkH3U6m+++1J24juXK/4Mzppgbm6DeeHRvNGefudUV82OG2GDzU7lCBNYD13KwvxFmpknrgFUWtfdaZdbhaniBMfGNpQiNWlf0+vPXVrBJTEy8aDWcFZHuNnHCqvfT4ONvhaCJefgCwLPLKwYW5gxj0zm1HntUD8Au5Fux4KwuRHyPSEdCOXs4kU5wm3YU5TEej7p8Ei1H4HtdAIcicz+LyUJLju5kp880Gp7BcGLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 20:56, Xi Ruoyao wrote:
>>
>> Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE*,
> 
> But only if after the patch _Unwind_Find_FDE returns NULL here (instead
> of a FDE of another function).  I've not verified it on x86.  If glibc
> tests (specifically misc/tst-sigcontext-get_pc) work fine things should
> be fine.
> 

The x86 vdso should be fine because of the alignment padding, but we should
probably add an explicit pad before just in case.

What a mess.

	-hpa


