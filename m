Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63138CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 23:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4036B0088; Wed, 24 Jun 2026 19:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55096B008A; Wed, 24 Jun 2026 19:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44456B008C; Wed, 24 Jun 2026 19:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A76E16B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:45:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F10EA04A6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:45:49 +0000 (UTC)
X-FDA: 84916441218.25.0F6CB6E
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5D7420002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:45:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=TYGxauwL;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782344747;
	b=DhlM7hnlgHGsQFKEhjt+xEz3sLR/PamvA+dViI+keASdieMB+2VBf6ojtDlcqIUCGRgRMc
	7uz0e/w0XinmfCPiXo/Zj/vElzdAbHlbq57bfWUxWwAIUA55JXBrCgqKEbXpiErdy4P5PR
	odEuqRvhhDm54oF3+qH/5FzcPDEiOWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782344747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAac3YjQlgOMQMiCgcb6pkychBKZy76MaByQWH987zE=;
	b=2LMqeI2AR+82KaRq0lE0D1Gw0eB3kzgKGh+bdMg83HSxEUPUgODlrIAWToUAWfIacNJ5Fy
	idmyqar9qPhwR/06Cgukr7tkR1Zb2VD5sjGBMhw8i+gb7CWcpiUpOnUlVtsePV7fC0vq9j
	GUN9mQu9mYaNIAb7ezaATaJ3GPY3+Pk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=TYGxauwL;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 43D6F40E01B4;
	Wed, 24 Jun 2026 23:45:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KwMQDZbVK0C1; Wed, 24 Jun 2026 23:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782344733; bh=oAac3YjQlgOMQMiCgcb6pkychBKZy76MaByQWH987zE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TYGxauwLfdo1Q7NMaI4J2T7E5GF2+BqiAzGbYKN6cW/HZ0KVE8B0IVJqwQswl/mLE
	 BGSk69A3nl5rn+L6TtA3VEs1OOvmFCR5WNHtbVv6Bf7iOYD/RrDV7Qejgvc5OcQoU+
	 ygIRfEB1DB39Pq6uE9Wl3O7x3r0+4Cvjw2OByOTCDyUVB1xYQCpd9qK3IppN26JC2W
	 Z61oauNBSaO/5tOLKLUpjDY4dqCkPYGyQavXdANJ0VLs3Iq+/TFYA5JfEZTBoB2ygE
	 xh3/mysyW5dAvkLAh4Ycc9B0fV8J3lLAFoRgTLZ7TeysW8HNjwfx4QNCblJn9TmaDw
	 6ZD5XQZ4114jyimGg7mGrrUOZO+wwCP4l7JSAVuqXyNuv/W33vqHHrdSlj/fVI68Z7
	 t5qpUc2gl94SdxTARX5VNj+Kg5L9cAv+cGa/WrqypA1SA49PHnhCaKmX3/Kgfuv8Hj
	 VM0w8PNufH6GWtm8Pk8oQSlJTAIQetKrHgRudmcmFV2f+/lF24v9hMyBXiG/u87FUl
	 +rcNE5eY19s0xOit4REP8D98cRVqij5WGYo7I6HG91oPy1f8EDS6pix5a8Zsw87gmp
	 SnVV6nV18aShaIUfpEp5LVNVPx9tXeB+LhXeThPf8zc1YLwYznnkW0V9qtb5d1d+f3
	 bPr8v/i116dDdc66nE4IbWLg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B317840E00BF;
	Wed, 24 Jun 2026 23:45:13 +0000 (UTC)
Date: Wed, 24 Jun 2026 16:45:10 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <20260624234510.GHajxsBgG62PHgEZa4@fat_crate.local>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
 <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
 <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
 <87643862-e32e-43c7-8c81-7186f30059ea@linux.dev>
 <20260624025732.GDajtHnB1Jc21kQnl_@fat_crate.local>
 <c49b1499-6aa0-4e17-8385-cd2bcd2220cc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c49b1499-6aa0-4e17-8385-cd2bcd2220cc@linux.dev>
X-Stat-Signature: b81zogiixckm8kqfhcw899z6fpsr38ju
X-Rspam-User: 
X-Rspamd-Queue-Id: A5D7420002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782344746-967225
X-HE-Meta: U2FsdGVkX1+cMiLvE8eb+wa3OBTYh6r46k0Oj/JI+szVH1aygrErVZwulzGQjmMi8S/of8c8M53MJqGRpZuCKhUBCmat5be5zO/9HsPfqWIoW2Q26MQpMkZgHsiwJ9qW4yrxzNN0EvWO872b5EPNQARNp+VmZysLdwXKD+tU77ceIeMunZ/r0PPTusQYcLQfH6VU2synwMLNszcVbIqTCwGE7PViJPJIIcKwq1WcMjqSl0Gq/0dcNham6QUJo3eseEdsX+BK5xasWO/j4OpocSPXZkYttG5vR/J+5zNM2QCf87Ly9zjQU/XWrX+jrWpsJwLHlPJb8s1viIRvF7bnOPzMrGcvLkAIR7swFGhfMFabSK4icZm27UoNXFF8GKmr+ODctgOgrjMi2upjA/C4GEc7IeSPe0quJVcIHJnqrKJdGgSOrdRFmx9X6rah6OB+H7QZcz0z7dzBuded+Z2sA2UFpIyMv4sPWJtN4XEyW2jOgfDYPV95iEjvqXCV+Zs3J6h1q5tVY1yLUBuvPGqBoFfz8Wg7aryZ2eNhwRlEyrEye7TgUjiwTSoYQ1jp8fooNQnLr6tmiH+6X4cHI1kaluOwSDdvP2D0GmPK6sNvWhF3PfLA9FmjECdQVvDiDSc7EibcGw7HmdePCeAzlre3e12x6AA7LsnYoh+nlj0qZ5dkNkef7qHnwebxtolytnZ3pizSmY+b1NB+sh8K4VnNAmFsSXCYsx1lYZB40L4fupILTec57P5059TuC+dUBV9IQl6xTcoEjsdvGxncPc5atC7bX/asoG9X6PYZ5hKslDs1eYndxvUkpatXDNJ+g46PCMZMGN5loCY2iqsIBdS9f1MQkab1sXkH+hNWEM823PZFxBMYTYil5WCD++Q9RrNYhNszW1+jrElyGPw8ewRkqY9Z3CgBktS80BFTj3WgTYbbgZXTu9Q0S1QQiwQkRXEnrV67cUgPY4U5RNIGW3o
 35ZgqzBA
 P7hDD6Prc39QRB5nyb65z4v7Y4XGjeftX2QW59bA/4SQlnlrOQr5WeAiRa3vlWryNgbW+b4pbDnHCQmphbkj+EGT+mBNpIVqkcVohS3Jyftm+g3GUeMSZbNWDQcqxSzOG81+X5uCKC2rHvIpuy5JxMrunKyis2qqdVWU8yojMXeyqCDGuXtxzCtCDOSa1Kg6CiwY1wLHKq+R1zCh4Ts7AYp/b/uPJD1xRMjz8k66qyKWKVswRz9gNHgrNkmbZ3v4xCAW6H9qfMhQZeo1L6RHyx1NTuAvMCfjVdX5TC/nZe2K20cUUKhG/7P/QjXorblB9dsbFngkn8jDXbR71HM1iwTNUst7Gx4PyxHR/eIhukkSBA1jGsj2Zxk2Hpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 03:45:15PM -0700, Ihor Solodrai wrote:
> The instructions are quite detailed, thank you.

I hope... the devil's in the detail as always so I might be talking a lot of
crap too, as usual. You'll know better when you start poking at the code.

> I'll try it and will send a separate series as soon as I can (likely next week).

No worries, take your time.

And ofc, if we decide we need a fix for stable, you could make a one-liner be
the first patch which maybe which disables KASAN inline  when 5level page
tables have been detected. Or something to that effect.

And then the last patch will remove that fix.

That is, iff there's even a need to have something in stable. I don't know how
widespread kasan inline is...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

