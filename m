Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84813CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889846B008C; Thu,  1 Oct 2026 05:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839E96B0092; Thu,  1 Oct 2026 05:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F1B6B0093; Thu,  1 Oct 2026 05:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56AE56B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:13:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B86744033B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:13:04 +0000 (UTC)
X-FDA: 85273493088.28.9B9F7D9
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F18E80002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:13:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=idhuDO50;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790845983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXE62c1+6sda7wiEzBoDUuML2EWV3+F9Ld5776mPsl4=;
	b=BTGyd1rid/z1NgyPxFXc67Qn/7TX4phk5cUWmI8+Uz7CT76+8TfwvLYqc43BbElCbkugj8
	mb1nN/JHMRcBgNZNTNEqjv8nX2P51RQk8HUV+JsvMUFsYU6JmXdQ22fnl7rVTQ3Oru2W2V
	L/bAy0y7VS7yAvx4VsHh3byosFlHFls=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=idhuDO50;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790845983;
	b=c+5i/jxBoBUfAyBCoEgZzyn1j0TKT/j+QscUMd7kRrMa9YeOtfu4DwMkYQv+KPfp3whYD5
	4WPTk74OuyXLJvXPVCSQeJM1ywq03P4nkyW3L8K+BlGM1LIWbEUCMZ3Houu7CS9Lv+idCZ
	hY9Iz/AamR5hXXBfxdmTrp/O2eQPGvY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MXE62c1+6sda7wiEzBoDUuML2EWV3+F9Ld5776mPsl4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790845978; v=1; x=1791450778;
 b=idhuDO50gR9mWDeuzKphKPEN/PcOw6pyZFRTxaMtxWWCBlPVwWXQpbNFkltIDkQl4GuilKYW
 OGrKkZ/pDQWgfQyNZii9yiivfxbPoPLD6K4m354aMB8sP3Aou1aMqzstNxU02ztjKVhV1rTJiYK
 UKZDmLBp1SXOkO6lyztaRiYg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id faa0d8be43e3ed7e;
	Thu, 01 Oct 2026 09:12:58 +0000
X-Mizu-Trace-ID: faa0d8be43e3ed7e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/1] x86/mm: fix spurious warning on __add_pages() failure
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261001081555.35485-1-lance.yang@linux.dev>
Date: Thu, 1 Oct 2026 17:12:37 +0800
Cc: dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 david@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A0683ED1-1E2B-4FA5-A045-4D984ACB2762@linux.dev>
References: <20261001081555.35485-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F18E80002
X-Stat-Signature: ebga3hdfxdg5j9aptbc8ix8n5f5uepzc
X-Rspam-User: 
X-HE-Tag: 1790845980-81620
X-HE-Meta: U2FsdGVkX19YGmvsLWQUjcDZrNuGta6mULjkfBnFl1sSZ/YwXHtTIWWm9EoRFj2wYFPq4gE+arGqZONwZXq/3jQFQOutbEv8d34odfL2Pc/gmxEZJKgzV2c1Mwp0UmhAvn3QR5lYh8kY+uC6axQIqJgOms5dV1ZDyVQ6NFOVYo6eO3BFCuXl83ti6yTRNFjmoPK0puD1FJ99AUkQYUXF+rm4kZ0HTaHgWoegaOip/hfDHZmFe42NFoaPfvQ8fLKkvpgW/oknInkz8LDVp956gOxVvwmSSIIfm1uDEVbZiBfyyC6rNynbOZ89iTjtNl53niGpiVghVB5y+UFOicUsB3adeogw3Hl1vXykWFWb/YLitEXoqj7aEmi7XjNBPhUWz/+7PZsTbepaNxwvmo7f5vRXXMgeRFyh8YplNGJofwzFPwT8785nZPFelF77p/BSoSGNeTmNucTUU8ZItSISpNLw1EpsSdmiBxYYC2yFcZHg/jdUSAzWTLFhUIe9lowAUoNUe88teXhc4VQyQGZJYw2JxXnGTz+/QRYf34i/kIaV2zZfTYbIvXZRLRqFrv78fiZmUxq5ftixgeHe/Kk2tV/xOGFVxmNT1Fe/pKU37vOn1xR6IcjHnr7lF33V5TdFT+SANRfBWU39Q9zHBFMXM0MITFu/DdL68B/AcZEwrcbBlvVsfOheo9vOt/nJ3ri8BJaYqqeIoaBiFAT/EVrtqSkJ8G1d8qernCJPIP4Y/ymlhN89oX1DXD2QVdbsXCM0bRYPOwWIUw0oUFAxDY+HKN0pANoIPNOdrBehAcBxK7nSsnhX+ZSBqdMHfyLHgiziU2kARPUTSiY/ZvJA7KZ3cbQed9C9aIBzVj5uzGnnWOvzbtawDDi2dqhcpNZ0R2zZbJph9Kw6Z/j+f8kP+7F5TLA0qfWPErtf+6aWwqOhuRG0gRHQ8lHTGLkZbaZozGNWC7gc2iO1H6wHHTFIZS8
 9cKxc2TA
 dglfvTBIg7IXa4h1NgAfnFkW/hN9EorxMsuKpXeBlz0trvVEGoxIQqnNcOV/eEXwyJ4dwZnVATlRRahAukVDEDUMH8LDLy+mJpMoRmYp6qbo0SVppFTADdUAioBCbkwOEsffjd5Qkou5YGlUqSUw2hGxQZYLunWINJET0rlN/fw3lWpiR7u3c3WMXQtPk/cqfkq2BhDozaVAi5TyGqIR5janOm0Y3VhpmecS75MnTi2ae47F7oQCMneWKyErECXgMn5KMPuYvP3YQYjONKKtec00YJs/QLaOG/xfoMco1lQOA5F0FzFiNYgVv9VPrbPfqYbzxwJOaWAW/xvgwCiU6wNxctshP1ynizWASHJY6BDH2P3yVOVZp3U4hvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 16:15, Lance Yang <lance.yang@linux.dev> wrote:
>=20
> __add_pages() can fail if we run out of memory. The caller already
> handles that, so we shouldn't WARN_ON_ONCE() just because an =
allocation
> failed.
>=20
> Let's return the error instead, and only update the end-of-memory
> variables after __add_pages() succeeds.
>=20
> Fixes: 10f22dde556d ("x86: arch/x86/mm/init_64.c printk fixes")
> Reported-by: David Hildenbrand <david@kernel.org>
> Link: =
https://lore.kernel.org/all/d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.or=
g/
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Link: =
https://lore.kernel.org/all/203892F4-B04A-4F69-A1B3-DC1619176C67@linux.dev=
/
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

I noticed that __add_pages() already reports invalid parameters where
appropriate, while errors such as -ENOMEM can legitimately occur and
are propagated to the caller. Therefore, the additional
WARN_ON_ONCE(ret) in add_pages() seems unnecessary to me.

The change looks reasonable.

Acked-by: Muchun Song <muchun.song@linux.dev>



