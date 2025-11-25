Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06507D0E6E8
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D8D6B002A; Tue, 25 Nov 2025 08:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605696B002B; Tue, 25 Nov 2025 08:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542536B008C; Tue, 25 Nov 2025 08:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43D296B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:53:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0C6616013C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:53:24 +0000 (UTC)
X-FDA: 84149271528.10.550B573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40110C000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:53:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPCDLMdK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764078803; a=rsa-sha256;
	cv=none;
	b=wRVmae4AQ6QknUDy9tRjhVc4mafiYTCacDVzjrj5znt61XAw4SJE35Uavqw9XuuotptwzP
	fbriFbnsTqoLgemFLituBRFfesW4zWTn1Yf1+/fftfrI7/aJnscqEDHhP7TEnUiMA8WR4w
	qQIrplZPUtJ0nK4+//3MGLaTP/xu7z4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPCDLMdK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764078803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jINZJmyyWu5rCApo39y9CQSrIgPXtGCDMkygKLsTsQI=;
	b=Ng3n+wEIH5ILsYbmeevdlAduUnbJR8vqHq3xLz6fgjBV460AoppvzYENaIXA6GSy84vZyb
	U+4W97D/mWjASXeBU+MRbZWJzTsbUluP2xcjXJfq6HLOlY17oKDfH0f98TiybkoT3FoShW
	+0JjO3QOAjcUI/3pslQDir3o18aJ3Uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 162CA43D06;
	Tue, 25 Nov 2025 13:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4CAC4CEF1;
	Tue, 25 Nov 2025 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764078801;
	bh=wm6FV3IVT1IV0DpBE30PulkbTqg/dBVhT8sK6JRjf2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPCDLMdKI43zuEecrbT9L31Ory6H5TCx9BWZdKDZON2SHCBPuwYMv0wBVhVS7cB0c
	 iIJQ1xIVYTxfl0Rpr3BS9XUzqXdlNwS/TPGeaTPVocHFJRKO8Gqc8qpCmxm7HROe5Q
	 5J3f0ZBm8mupwSBzJh9D3Q7rZJFPalAN5MpOOdFvro4YZWdLqgs4EH0J7U4SHB596+
	 WcRbnLveEiK3AkGThBNyo3eUk6ZvNRsZ8vEDjV/ONd0ORJY2a2c4GRoZi8rwW+bsk/
	 ppSENZ3oU8Reh+pE2+BZSB/zRrNw7O4CVBVKu8bHuocb3W76AuFFT5d3fkVQQz7vNb
	 WbIP1TP22cbbg==
Date: Tue, 25 Nov 2025 15:53:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
	Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com,
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org,
	bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net,
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
	dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com,
	jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, pasha.tatashin@soleen.com, pbonzini@redhat.com,
	peterz@infradead.org, ptyadav@amazon.de, robh@kernel.org,
	rostedt@goodmis.org, saravanak@google.com,
	skinsburskii@linux.microsoft.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org,
	Breno Leitao <leitao@debian.org>, thevlad@meta.com
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
Message-ID: <aSW0wySe2kRl1P8e@kernel.org>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-13-changyuanl@google.com>
 <a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
 <22BDBF5C-C831-4BBC-A854-20CA77234084@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22BDBF5C-C831-4BBC-A854-20CA77234084@zytor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40110C000B
X-Stat-Signature: rd635sereq9fizts9wfd99m8ctotes1b
X-HE-Tag: 1764078803-593585
X-HE-Meta: U2FsdGVkX1/vbi8hx4ksSCR4tNUKeQze6Cz6R2N+pL3ptcFplNyfet7kXq+rbNNhZJAVVBK+QFq7DKC6OJwZHpWhDTMSXCe+krSzYONVdgj7f77IehWufai7b0Y64WLWOdV9+l3vqV1FOuMk1C62pBSCfzy1DliJGVvtFQSO1WiEeOWibZR2bws8PBn3rlgtR5CPFfDOBUVqN2zvCl8QjB8IJUFmxa4PSWzUU5MV22vduc7qd9IXAOgpvPa0XGQJdymhNIzqV1XnwBOKW4uVH7zW4bTU6o8BYWKj1OWZhflM9Iqxvq49OHFkwNHMXwZL7vcc9sz0gK51OLG5fXYUKYdiJtnA0yaUB0rdgmsYURqJJp9f5s8V7a92j2zNnQiD4rg3va7A7RH15U9jek8oxVa2f+6Llb0dah4RT5ZKZusUaG/X6Y+nlBYvLjhPcsXqyeu2hgWtaR2lfMZPf+eaGvZexU4hkI/24V3XdmVQfKOCz/9hPuWdD6vu+dsaHaj+vNqnC18bwWn9PExzyjRsOX4+6SKPNsJH6yJBrl39/UNDWLjjw17L6EXn4mk8h+G91QK7uBK0GfiC8mqucpIU7tebyUgQ+PUvXE3jLWkcVdRM9t2vXf0xy/0eYkkOeZO/LTqfDg4ufgrxqZG52t1Z56B/0lTsypdfnz6rNmpMIol+F6y2o1/mlNr1JCObA2L1c34SYPH0qJbSDc0gTwt59avzSecrGk7Y7oMfFfksiohryKGRyLQoptVZ5C4NxG1B7l+Hmczqcc28rGHW1dIDhk6vHzmLvqTATBl25xz8ET43vBYBuXO8NZBAgiK6YPUbzcOBHWwn33AhtADOmndZ8tdkLPGl0RjrVxMnJrqK1/XSAQ0ouMGac2Ac6qtWXSYmpXrd5U0Ot7vkv+xHpPHNbgHBqlbBAipOh8JBcjy5+ObZcwLyVxGGDy+ZvFgku5WPHBDIPsOG4IyJjhcE2nw
 vvqNwohh
 ++ACffqHNQ3lZHxDrb8gV0hXU8llEAAtJ6DGaSlEF0KCWL8hptjZ3uhPeA9vpOUmDXz57VahBdNaDWcyMEFuWEIEayJnUoIFWHHvAP4DQiA8uDNhITUWs/fXpUQI5tMfN++iQyB6dmdMh8BSGixQsgWQNBDWlopawRVQM00rF/kV8tDcaYGHG8tEpbPJPJXJMiu8+BkAclaBNpgqb/Thnc+QWZMw8/f6U5gXrie5W347pCIR1BaA70s++A+vIGS0y3vwoIoqMSe3YmEv9lA9cJkdacw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 04:56:34PM -0800, H. Peter Anvin wrote:
> On November 24, 2025 11:24:58 AM PST, Usama Arif <usamaarif642@gmail.com> wrote:
>
> >diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> >index 88be32026768c..1cd80293a3e23 100644
> >--- a/arch/x86/realmode/init.c
> >+++ b/arch/x86/realmode/init.c
> >@@ -66,8 +66,9 @@ void __init reserve_real_mode(void)
> >         * setup_arch().
> >         */
> >        memblock_reserve(0, SZ_1M);
> >-
> >+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> >        memblock_clear_kho_scratch(0, SZ_1M);
> >+#endif
> > }
> > 
> > static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
> 
> What does "scratch" mean in this exact context? (Sorry, don't have the code in front of me.)

In this context it's the memory kexec handover used to bootstrap the
kexec'ed kernel. Everything beyond these scratch areas could contain
preserved data and kexec handover limits all early memory allocations to
these scratch areas.

-- 
Sincerely yours,
Mike.

