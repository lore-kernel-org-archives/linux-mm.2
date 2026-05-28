Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C01CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926A66B0088; Thu, 28 May 2026 11:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D75F6B008A; Thu, 28 May 2026 11:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECCF6B008C; Thu, 28 May 2026 11:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 721856B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:31:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D5C0140898
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:31:54 +0000 (UTC)
X-FDA: 84817218948.02.8BE4122
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DF3840008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:31:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WSsYghy6;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779982312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qZOrPfBY5z6252HcGXjHXbe3jcHPNuwLEhKhMfcXxE=;
	b=Q0wpCIpOOv6hJVWRFzBTW1YCHoFRbInqfKYzxnzQ7blphfUwpPbMtiIzTMsaewQDyb5HWX
	1jFZMeazIHUbdGn7JboP1GTLA9b+OHbONP9KFRBG+ieETTmj8REEQXALviHi7CLvenhuLR
	Cvm8v39Jsm+oZB8mUgED1qg7Mbzwpdo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WSsYghy6;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779982312; a=rsa-sha256;
	cv=none;
	b=Rmzp+nJnxgNQgWZOH1NucDVBY8hSe50jp1E4JBcuWlQCPcg22SC2mgH0tJtwqt2vrCT8H5
	YeWWQeUDGL9LD6b9CAohxI9oASUVpADSweF8buHLa1p0xe4obw4IV2zkYmXCisevXvikJY
	XGwDTQFjlUuuMNLbcwJ0/HMyxz+mDM0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4B8B640E0031;
	Thu, 28 May 2026 15:31:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7P0cXjPFcvT9; Thu, 28 May 2026 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1779982297; bh=5qZOrPfBY5z6252HcGXjHXbe3jcHPNuwLEhKhMfcXxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WSsYghy6yed+4DuVw5/3JHCoAqivyd58i58+OKxpg5aNyku/y8hIskguVcnhgc8LU
	 fjV8/hzP7o/jT7sgywe0zMVD955t2jIv9szUbQX+rSivUarrN9EUmHld04zTs6cupP
	 MCBTmM0DQiyBmM33w+FOcOwEdaoCnZ2CwsxgzUjwHFnhnyyP1cUMnNsf/ow7WHnQhC
	 5z8lbhpeyA3r9S3J5hnZR4bf2ZNoI2csoi1Tds0fi3zWSiGbi3L5OTZDO8hBJtJ79n
	 Ia6PFPwNUy8v6ipp31aVUbm5xuR2RLr4uivv3VWWR1OEul4jTyxTFn1yB9qujSnCjC
	 Xj3DNye8kgBoY+h7w3cTp1YRUSUimrXi1Fw6vwKPhJXE/qBWPZbDvflsTWtZqX7nhI
	 b80MnPySU6wcxfvws2qTb84wlDF4VcS80uIgzno3Q1/pTCyiujadCUzO6GQAj2jaOR
	 gLa+KIUYfFbWiOc2ZQtiqFeJYRWvTfhtCyq24jLLbSc7OUcZUyVfxAU7MSE4f+oYZN
	 9Gq4h9qL7pzWozvOPX451VQ73JYf8/V9z0vUlGTfFcpCHSFbNy9Rmf81bHNPqre0TJ
	 756jcZ83M//hEWkok4eBeqM/bI/BHsip/LmdQgwm1iXmttO5M/w8PaVjvL011/7h8M
	 tA6sn7Rgf2rEl9cLQnUZkVL0=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B895A40E0140;
	Thu, 28 May 2026 15:31:27 +0000 (UTC)
Date: Thu, 28 May 2026 08:31:18 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Karsten Desler <kdesler@soohrt.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <20260528153118.GBahhfxo0BmTjX72Qr@fat_crate.local>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
 <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
 <ahfWdMdxX68ni4ZM@localhost.localdomain>
 <ahg4zTSRK6THd2yP@localhost.localdomain>
 <ahhLIOB7u210pjfA@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahhLIOB7u210pjfA@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DF3840008
X-Stat-Signature: jzfhfhi368gh36yzt4hdak9wx9wdsyef
X-HE-Tag: 1779982310-383035
X-HE-Meta: U2FsdGVkX19uT0Ng05BW6iRwGc74fXtqL7R4afycLW5zJ6FUX5s4NNOJBHlB0WP+30BDpDp52rhCYGCcMcORw46e0bq2/1y12V5kGlW2w/+epY7eDzeigKJGEqpMH/RYHadVxyRpC5b4orbI+mB5m4QQOwXBBkIIBmnC+xc11AXTxrS8z3zWurcyEwuoYRAfkTnJ1DMPSkBOfRfn5aaeqH4cvcKrkZPQHh7QwJtUtJY6MMv/vSuqWIn2WpUJch8YNUNTjshVUeZSUsqsRothEVlkd0TwOl8Je+9Fpknajmyq2sLrTTKq3mDKAemZfPnZMWsXijKxcKIzZjNUOvBDuAUcwCDf4HwdrctTu9IQfxmiGe+6GYal/oOGYoyprKUZTsB4yGEA9DGS3PwpJ57sepvmzvTOK7YgT20X4aevWaNYFmSi3CQLQ3QNHLprYoOnh4YQlBzM4bhLpI2cazL+Ep+2dKX+hFh29CVjKgg0iUitqrp7Z/DgvmfyGZ8JDFHzIRIUcFL/MXW56bM+u3jA11xArq9yrORWjiFuWqhr5i30urM7onD9wg9+5pTGK5RZ8fvv1nciTb7JgGjUHvXRbtFd2EIbG3jDduV1Nve7XvIo6zeFcbqfiQ7wPxoDPWoYgosqgyoIY2efgoaaQfB/8EsIjDMRbDmdP3z2slNA6vdfYzdohKSGdNLDWISkVYFefOh86R4BLc2xTU7o9FDbv8pX25IiP9uUDJs64bq/uxfP9JfozqXn0MJXbEaQPXr0t/urxEj/X2NWTTyQKsY1DbmuTpCjwWmMP5+zMIn2KJXJ3UHkYMizKK3DAT7Ari/+aGc/lCzaj9fhpRIhlWqzQEf0VKu+9VW4zKw4cH1Hjw2jTNyPPXrx65czwfh2x3fKoWL57Obr9qJfGQu+KnUgqtmHflPJ0/PBBB/C8usSwirrwJamyi82knt4eSH8FGhtI8I8GQ0mk2cZQns30th
 G80gggod
 BRQmIUrMLuYM16x1qdkkersNJ/MJg8LNoLlCQNN2K1yu8ry5Rz6eTB1CdJm33sTW7UhvJaR6v3lEGgQ4er7VqijnCNrPxavB3XKpZS1rg5OMNjIzRliX4v/Rt0sXaNRb62W66edAFdPfYfGjxUL+lmRX1pCZw+M1e2tFZtDHm2RMUaOzCLOQEdZBGJVcta6kXRlYyr5QdspJKk5n/UTedXphznn18hALpbPyMSPwbDLyZ+E3HpQzk08ESVkyyG5uE1vy79TbYdrrxNrQ8vVyBRt9o+Oo1RbQS2l7c2lvO2pdXpa0phecsvQl6QezXSaYEQrhjuetnXftSrJjli2YqCYnU8F3lpIMYJN/X9KQa8q/Sa17yNABiWc3aeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 04:03:12PM +0200, Oscar Salvador (SUSE) wrote:
> On Thu, May 28, 2026 at 02:45:01PM +0200, Oscar Salvador (SUSE) wrote:
> > The only thing bugging is, should not the same happen for THP-file-backed mappings?
> 
> Aha, no, for THP we do not set align_mask (at least on x86), and the masking off is being
> done in __thp_get_unmapped_area().

I hope you found this in the proces:

dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties on AMD family 15h")

It is from a different century tho and perhaps not too relevant but I thought
I should mention it...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

