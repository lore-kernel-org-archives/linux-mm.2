Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F37D277F0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 15:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED77A6B0088; Sat, 10 Jan 2026 10:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84D16B0089; Sat, 10 Jan 2026 10:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C156B008A; Sat, 10 Jan 2026 10:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3D806B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 10:31:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7ACE08AA5F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 15:31:34 +0000 (UTC)
X-FDA: 84316443708.17.3169E3A
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4839180015
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 15:31:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm1 header.b=RLxqTbj3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="q 5IL6Wt";
	dmarc=pass (policy=none) header.from=bsbernd.com;
	spf=pass (imf02.hostedemail.com: domain of bernd@bsbernd.com designates 202.12.124.158 as permitted sender) smtp.mailfrom=bernd@bsbernd.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768059092; a=rsa-sha256;
	cv=none;
	b=ZYmF5nDk9U1SNX/UJ92IzITQxh3DBu082pazXQuPw390k6PNUirUctMPQ0G7dqQTe8fNCe
	jks1Z49hq3sclUZT+aebxI0PPfFuwFLzCRkqypLg2PuZfbvZMAd2jMB95+vKg+qNbIpcfx
	i6cerXawh4BKOj0+CCnKgSW97p4XBm4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm1 header.b=RLxqTbj3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="q 5IL6Wt";
	dmarc=pass (policy=none) header.from=bsbernd.com;
	spf=pass (imf02.hostedemail.com: domain of bernd@bsbernd.com designates 202.12.124.158 as permitted sender) smtp.mailfrom=bernd@bsbernd.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768059092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xnPw8kDbk1FnC17fO636ah57YcMdXKnjMD8FyXDqDU=;
	b=SKusfQsUgJXZcYHyG1xI8+LrvPMueZZhMLTq+7dY6g4e8ywWFRGMWcoF5CKL82wTEe78Kw
	0EtmfiM4eB3wplbrAVDlh1IEgZq6c6DUp9yiATaqL7cJvO9xLJvR9yj36ZI92lBcVw0vIv
	5q7902DMhq6EOrj60Zox0wVyWg/E2b8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3B58B7A008E;
	Sat, 10 Jan 2026 10:31:31 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 10 Jan 2026 10:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768059091;
	 x=1768145491; bh=2xnPw8kDbk1FnC17fO636ah57YcMdXKnjMD8FyXDqDU=; b=
	RLxqTbj3JlBtQ5+lW+9o8DdlRmQ/Zqx0C/Tgt+zI02MIv1ZTBhAzDmavRNoy9DLG
	kb4aZsb3+K0iMcTEAnqg/yvFiUFF23v/Zklfgd42oA9LSrm78VUqxtMN9sxvY5by
	9oIoKxG62Iy5uFXt4ul71K/cWcdgYKdJegfni+d3pB0hXbOsKtQz6qJ5RGWWtEuW
	SCg2TAHJpmIGJu96sz/W3Q97J8hOjzT93Y82Gry/vWSU8iMMpAr59fG/cQopSYLn
	owFhBKy/lkhn4CrXst2bEt7Fx0KiljY3+4ozE7mChSkc8Y2s+Y+efN/b5K3K1X02
	IjKgQAD2Mfkg3HL8w/0xog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768059091; x=
	1768145491; bh=2xnPw8kDbk1FnC17fO636ah57YcMdXKnjMD8FyXDqDU=; b=q
	5IL6WtDmfh04neTlaIzT2RxE8oNm7SETDbRxy5JaYBS+ah0y2XuYu4PbkMeYbMCW
	CKYKCa1zwwae1f6EStwlGW3GR20n5dBtz9ZNayEPalgxrzFHXPRkZEMu0Y60QHHH
	RmlFPJJ2teYEiiPpnunKuBT3ZxYYm3jJtmp1iR4ON4ycfeB8s6r5grX4UD3xy4lE
	TdOTLfdQieKwMhr0LRFDaZGZHfBkNeBfiG4UqBR85YhLhW8yX/ohCZQbosdQCjKa
	Liq760yNaXZ4zbOqCKExwSZi/U7H54neaNQK4jGoGCf1fJ5U/L77sOCkDb5SNUUy
	fb3WWmRa5L8lOiW92zQhg==
X-ME-Sender: <xms:0nBiadOfjl1D8kGZmKw8b734EEvIjcG8LcVUsffXTQju4Q0lYK-ZQQ>
    <xme:0nBiafCZPtiAqB-BwbwIGEmqREyyI73Jp3si-P3nD7XmF2RGSvgai5EPfYwFOUa2m
    dG12H6G6xwEBjLOURGTx0k7ZdkAugP0RApejev5k6GTPBqJv9oZ>
X-ME-Received: <xmr:0nBiaSfpwe2RMy0auHYh4I8T5kRnqe5MQYLIFRb820nZG9nbzdM0Nkgk9GCV7VZSDaNQHnHGmiHjAH6ietvtAXQabJUoIc_KtutSXr8dN_5A9tMcDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduuddvtdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffhvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeelleegudduueffuddvteegffehudeuieffledtudehkeehffegteegfeeh
    vedtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeekpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    hhgsihhrthhhvghlmhgvrhesuggunhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdho
    rhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:0nBiaWNt5qm8FkukJb0OEphNK3P5UW0Fzwa0VGicN0392RAfqhN_3w>
    <xmx:0nBiaaIT5jZX0e1jTv1ZlweEsMOHkQYZX2lpDOwNTibyzdpTxpEfsw>
    <xmx:0nBiaeLlqYuA5mYVT1b9U4e5pJY56ZgwM9KLl1hxURkM_T-xsiPL7w>
    <xmx:0nBiac49-4bJd7CYrZ-BMz_IPyS70nuuZNhFKhPbgbqpEmw0EmirTA>
    <xmx:03BiaUYOknfCuYnHPT-zBoifes7Or69uFOQUrCyibILyD8xIVY4W50DL>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 10 Jan 2026 10:31:29 -0500 (EST)
Message-ID: <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
Date: Sat, 10 Jan 2026 16:31:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: __folio_end_writeback() lockdep issue
From: Bernd Schubert <bernd@bsbernd.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Horst Birthelmer
 <hbirthelmer@ddn.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4839180015
X-Stat-Signature: 9fqb9s6nqu79yhhfqu5teqzca8p8o3p7
X-Rspam-User: 
X-HE-Tag: 1768059092-930097
X-HE-Meta: U2FsdGVkX18TGyKvXjKO20Icl6A1Zv6qe0fqkf1B/rzC6kBHm7iJLQwshkWSSz128k0BkWSeiB233lD9HnX1V4xiWydjdFQ5soiaT4aec+TAHkO7+9Hv+FooLiudPnMYw2juXShhwW/burLXt6kQcdY/iUlX3kIgBxOAldVV8HOMFW8dBLjQNrJZPSl1EIzr3sPCfx9wNRGwgdT1I8YX7Ozk49pVCrgVWfYLCGqdYiRZId4woEbqrvcaiKi3ZNffoBTuFVZ0aiCrOXrmC0MTwe08kgUeAiBJBYqkpv2fPTG9C3pj5S0nQ2stavG06kD8PbrnBa3RhPPqgCozLVYMdGTABcLfHRH5ImH7V2iwnyn2aiZI6hg6ufvJxJNvHA0INVJvXqYvtr8HXNGfyVIW2xkvwqi4nbV1rG2vU4okPJ9qW/FKpTT1k9ybWd12JQztrcG/s4tIp5AcNiwHnDfyEbw2NoWKR49eHAvTPT7LMa9jYXsW7Tmo8gOoFDdG/JrlaySlj8RlzjvbqCpoWOhMuFd/odXShhTHAE3itB3CqxyZodulp/D/DevMOARj60AeQkNe7e3ymuG2/o2HHBHRerZEKDh7amNCX5BEhAtxM7J9ipRcT2kprn3dS29IEOXURpMUDxD3x6C8P/2RdNdER7reqq1eO4kK4fFfxG1VXq8oahejd/jHJqEP0KhTFOX5xZF0b9IM8pf2Ie5799/Zs757keXgdayG72R7UFP6JQymDBhuOsw5F3mUwKCpgY6fbgCNq9guEadoNPQEMaFOgsOVjUdfuKPh4wOiXw92z6EK9NqpsXcmI1m6LAa6X5PFMyR0/nZnlURSrnkdneEZsSqBOz7Mx20nirbQ+Lg7qKwdHn0WAAPAphZDE9i/wOrSZGLLH0rPnb5PxcAkr9x0gES2i+ORVpwJGOazjOjgO4FwdRNG563lvsxX+F+X/73dkAEh3v3CYZg6ZGk5qxH
 dchNP3I/
 kQyg4qZHREuPwEX8WPnzdngU6RseVQEM0DBdFJHS6S/aiYaNR4UHAG7SwiI9oxm8vbUGx81McCKqfP3kfikUkde0a/TwxXj13CVj8HOuTDZHnNPkfGNYRCp1DGFRVcwigMIcb2ZvsSPHu8rDGfEPkrmTa2Vz6VB1sjSd8PcESKoXaobsc0yGq1/OUEXyouXdwKBrkmxxnGdTGsCk1ad6M1oECfCH6SMmjfdz3flH2yI1D3hridQQJGyOnUS+pGZx3t9JmzdIx3rQTR/1YbcJWC5f0ZGF7wF4aPgYczso2t0o7QHQUiuP9aGR/MbmXEvII8q75EEXX4XaZeFDh34LN4FoOaDdAdlllz6aM+5H2LYoAH/g31xvAFW/fy3+H9/kbHYis5QPktXQPeJreBAmLwTmB+8ubWs3/dYXidpmbPWbV9AyiHOvKk6LFGCmbeFXh/jfkJWVHx31qYeNAScla50FPAgsYrHWTLoCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/10/26 15:05, Bernd Schubert wrote:
> Hi Joanne,
> 
> I run in lockdep issues on testing 6.19. And I think it is due to
> holding fi->lock in fuse_writepage_end() until fuse_writepage_finish() is
> complete
> 
> Proposed patch is
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..b2cd270c75d8 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2000,8 +2000,8 @@ static void fuse_writepage_end(struct fuse_mount *fm, struct fuse_args *args,
>                 fuse_invalidate_attr_mask(inode, FUSE_STATX_MODIFY);
>         spin_lock(&fi->lock);
>         fi->writectr--;
> -       fuse_writepage_finish(wpa);
>         spin_unlock(&fi->lock);
> +       fuse_writepage_finish(wpa);
>         fuse_writepage_free(wpa);
>  }
>  
> 
> But then there is this comment in fuse_writepage_finish
> 
> 		/*
> 		 * Benchmarks showed that ending writeback within the
> 		 * scope of the fi->lock alleviates xarray lock
> 		 * contention and noticeably improves performance.
> 		 */
> 
> 


Hmm, actually the critical part is

[  872.499480]  Possible interrupt unsafe locking scenario:
[  872.499480] 
[  872.500326]        CPU0                    CPU1
[  872.500906]        ----                    ----
[  872.501464]   lock(&p->sequence);
[  872.501923]                                local_irq_disable();
[  872.502615]                                lock(&xa->xa_lock#4);
[  872.503327]                                lock(&p->sequence);
[  872.504116]   <Interrupt>
[  872.504513]     lock(&xa->xa_lock#4);


Which is introduced by commit 2841808f35ee for all file systems. 
The should be rather generic - I shouldn't be the only one seeing
it?

So this?

mm: fix HARDIRQ-safe -> HARDIRQ-unsafe lock order in __folio_end_writeback()

__wb_writeout_add() is called while holding xa_lock (HARDIRQ-safe),
but it eventually calls fprop_fraction_percpu() which acquires
p->sequence (HARDIRQ-unsafe via seqcount), creating a lock ordering
violation.

Call trace:
  __folio_end_writeback()
    xa_lock_irqsave(&mapping->i_pages)     <- HARDIRQ-safe
      __wb_writeout_add()
        wb_domain_writeout_add()
          __fprop_add_percpu_max()
            fprop_fraction_percpu()
              read_seqcount_begin(&p->sequence)  <- HARDIRQ-unsafe

Possible deadlock scenario:

       CPU0                    CPU1
       ----                    ----
  lock(p->sequence)
                               local_irq_disable()
                               lock(xa_lock)
                               lock(p->sequence)
  <hardirq>
    lock(xa_lock)

                   *** DEADLOCK ***

Fix by moving __wb_writeout_add() outside the xa_lock critical section.
It only accesses percpu counters and global writeback domain structures,
none of which require xa_lock protection.

Fixes: 2841808f35ee ("mm: remove BDI_CAP_WRITEBACK_ACCT")
Signed-off-by: Bernd Schubert <bschubert@ddn.com>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ccdeb0e84d39..ab83e3cbbf94 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2994,7 +2994,6 @@ bool __folio_end_writeback(struct folio *folio)
 
                wb = inode_to_wb(inode);
                wb_stat_mod(wb, WB_WRITEBACK, -nr);
-               __wb_writeout_add(wb, nr);
                if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
                        wb_inode_writeback_end(wb);
                        if (mapping->host)
@@ -3002,6 +3001,7 @@ bool __folio_end_writeback(struct folio *folio)
                }
 
                xa_unlock_irqrestore(&mapping->i_pages, flags);
+               __wb_writeout_add(wb, nr);
        } else {
                ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
        }



Thanks,
Bernd




