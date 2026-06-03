Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EEACD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FDB6B0093; Wed,  3 Jun 2026 08:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40606B0095; Wed,  3 Jun 2026 08:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FA56B0096; Wed,  3 Jun 2026 08:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92FB46B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54434C17B8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:05:09 +0000 (UTC)
X-FDA: 84838470738.22.B8506AB
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6ABA2140010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:05:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XHnZO7wy;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1X7rdmAsUUmk8fm1lXinqRbOJ2Rb1qcFGzfHrd7zSSw=;
	b=OX2YFG0c4PtHx1bpY0de+FO/6/RvKmo707l/fZ/v8J4AXLCCzEBruw/c3KjcYorRH31UF0
	XhhFDsW7v4NrZrI/ZHYw6TCiDs83C8A0mRRDN9tnOBlp8bekr55sNjQ8RVa6t+B8uoMmy2
	Ych4tA7bEPClySPlIHEDnDTlIqmp2Hk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XHnZO7wy;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488307;
	b=pF0ZC+ZTF2JSgqoc0EsAjbppu2GXWwX4Bd8oHvR85hMSGzW4/EReAiq7QlVfM2blcVTOMV
	qFb+HsRMwrSB49qz7NtoYRTlv/jLtF+0STMacPx1UnI5s4sh1CGRgYCHdKrEABSduXtmRM
	d/kOe82HGzLhULrAoR2Gx979NnbJcJo=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ce9d444173so40078746d6.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780488306; x=1781093106; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1X7rdmAsUUmk8fm1lXinqRbOJ2Rb1qcFGzfHrd7zSSw=;
        b=XHnZO7wym5xIZh6I1M+8TAgOq4w2Fw2A4Hm+7LkgweWwhFyUZLMcSqm2zGgAgA7w7y
         C9Hmajy7WP7SzHIzUqnJHA9tjuSwh1EXU+vD9ALr8aPKlhwRh6DqaNG0H0dTkx4mUzCZ
         xb5Ql6lSkx6JlxPnefI7iwiF+PH0K8Bqq9pkTZuonzpJ7QCNwBj/vdL97t7ZQ1UNgMkK
         Sy8wB+7dU+0HAgcrDWpgls+ykhk/C7tuxIrdzogYteRANtVaafPf6gy8ZwmyoeUPKoOk
         cfABcvEL+Tux9UaLFB9njAQY2/xviF0ZkZ541OApul+HjX4cLBPZ227y7P1BeInGXc/S
         PQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780488306; x=1781093106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X7rdmAsUUmk8fm1lXinqRbOJ2Rb1qcFGzfHrd7zSSw=;
        b=jdVKLIv4TGkTYTNTncJSuBGSqKpjYK9OBw6NMvF5lrr6qzu+pQamisfMw/YJSUvoSL
         KW0Uilu/cJMHNcOzcICU73g+dTOojFl916VZyMH4kM14rs7w17FMUcVct4vYnzKFYoNv
         42Id3eo7qv8cen1aR+U2ZaWZ1rYv2SC8Y/NqQvSgS6j2tYCeFy6yESG0m0lheKezBrvZ
         Rb5FwxATy1QSTjf4Tt52p0Ts7v0CRAgSzp247EFDiJWWeQ/6osTjctA00wV+fqc2XRMz
         BYh3Og4CA4gXpuEBWX4+zFDlB9Dz7afAErOLYKNgzBesMJbqeMjpRvOO5dPSR+cyLWF0
         +3tg==
X-Forwarded-Encrypted: i=1; AFNElJ8u1XBQvKMlFX1ee+8Hutbgk6nofJ6IydLr835UJB+qE7gHCtE5nphMBnOSprLvm98pIhpS+lTyvQ==@kvack.org
X-Gm-Message-State: AOJu0Yzvm434xy+VF1qMci06wJ9/rUXNTVnV7yQ6+X8oQN2RMj1PUmEc
	4FGSE8zXaV36jFq/NBvD2sveTG9rWaqDTGsTuzeHsUHBLxIdpUzH9DEwuFi9oAUqpow=
X-Gm-Gg: Acq92OFyv1QPt8VYyIRK9l9uatbOr1uh2y6jI4hSM6idENZgn3FAuLI/7Keo9KKtnlO
	KHepSDeUoLl899MxDtRGkeVQxehdaSWvTcClCWSV5m1dB4m1D+pZupFZ37a+N2EkZAbOXncwUKr
	A9HWgVm9qLLVfUP5uha2e8oj6wFgghpZCRS93VZapD2o0RyUi/aObT94LvZeWuNTWOdKc46OKvh
	iUUIQMMxdjsuplrH9GQAXqhE0B1Kvau0Hd9k+nGpJztK1epMUTa/Mz+SVIh9mv6V65O0cEHSBjF
	TjfeA5MGe1ambTyQAqETPe/gHvy3IntJ7j54W7hOkRki84ZBKSQdm+8THR1ZKnnvFbYRzQ0XfnY
	xOe/tWM+9suqi5FeFDW0YqkXXGZh+DttOYjdteoWG7rYTxXutigTSdEaAKZHZQDukt7p/mjoQss
	RtX0M//u4JcRah25V2q+WKy7cuQa+10Rxi2X6aSXDIJ16iSVj7QIc4Jxa0SNzoRQ==
X-Received: by 2002:ad4:5851:0:b0:8cc:f012:f42c with SMTP id 6a1803df08f44-8cecdc09461mr34569126d6.6.1780488306396;
        Wed, 03 Jun 2026 05:05:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd2682f8sm18054716d6.43.2026.06.03.05.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 05:05:05 -0700 (PDT)
Date: Wed, 3 Jun 2026 12:05:04 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block serialization
Message-ID: <aiANtYRRDr5iO5QR@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178046937151.468621.13398573538792303093.b4-review@b4>
X-Rspamd-Queue-Id: 6ABA2140010
X-Stat-Signature: 4dzqyww6gk56x9jf9ss3skh8doge3gbf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780488307-653256
X-HE-Meta: U2FsdGVkX18WosIgYhMmHr2V2CNCAE3jhQV/Q1cTPeYgg2F6LyNdpKnt0QTxTtQEFaSaDotvQsAsDxXvu1r47M2ujoTnMOMe/5iIIckjB5JMEP98jIXB+ZKcdCm4Vr7b65LZ+fY3LowYHi5LLPXMJ+5iAtMQwO83R6NVleIN2ZJD3cX6ZX38EK9+OFgCPFiWrueNBq3oDdYlYJjVKLp1bsY5j5/5J/2h2BuvQTTKNnj5bJBpO7XZ3JQeBT2Zsa7MgrXQ5zzZ0YxmLduK7uGTCHzO7n8L9uVtDoRTn2NJdgdwVquWSloN33dPb+BXmjkdrqCJpRxFNMV/dK92W0WoHoIQHf9giIQ1QwyTTuCgJ85l4Fei12mM8O8Ax8UmN7GpuNPbXaK5rts8NEZZH8/vDu0F5g7mwjS3Mgn6WiLXB90o8zY+jcR1neK8zV9AlTWujP776PqPRI6t1XapIQJLf4A5gkFW1K78zQlbMaOLbxUK8z3qtpvxTpnbmGGdlNc1HeleUH6UmN1YFwG9WDn0UzyWIhtdeB+Ka1yuVNbGCU6jI8O/IKJ7wcrZjGZaBAoRSwvXQY9p7PZy6pBzL3P0A3kRItLGsshLh/d7FxEB0AsJ6NiqHcjVzsqJkvgOz9qJ5ell8c/NnFihRjisLNAec5HP+X26jUvAxEMwVvhYCIxxBkR5t8cO+qYbwa8paFnN8t1U4/FF2gyzm4+yJgfgiY08slyw8kfmQRAbWX/QwrwGQ51BCKWgBPMcymf85BJnQ1zl8W4cEHFshELWv8kIuKvpzXrnQkIXPWza7glRtJnaCg8+4afghllPoRclHJv6XezBzJboauq69yEMCDbFYp5+eSzr/COCJe+9Nwwh0STui6Wz2/IhCwyFskRDCg5D+I1kOGq2yymNaum9NfTxL7YLlOMb3EjSGN5IBvkJHegUfYvznxuIIJM9XRc++ngYqi/6PSmoQS+9jT0h0uw
 UtqPMHLq
 jteu6vuYvw84DROHueo/YmHD/tHY/asVdBILfmiY3IVV6KP3Kw7RBx8Y9Z3uRpqRmMSp7OTCqm/hMBPTlgkn6NoT4uemOVMTsfPTk/Lob+ik7GopU32mjYOH1y7WFVMGpfPNhqF5QzHBaWXbKnb+M942l16vsU9WASS2mO3C7e7ekdzVLoz/O3eJXDOvd0j2IdIuiaAzf0QUxhz+//PTRBnatQgM89t7v9zlmwzGopAbdCXb1/hHGrpmfDbjATNxzxUR6Hnf04PtyO2b5KXoHB/k1QVHHe3VQ+RSbaTl0+R2BZPcIt/2yCER/kn0rD1Csme5eTGMmd6FXrbzk1Po5WIHr6t/tuexEoV9c/4VvcSN7Jc1Sf1cWyJ4GbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-03 09:49, Mike Rapoport wrote:
> On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > new file mode 100644
> > index 000000000000..8641c20b379b
> > --- /dev/null
> > +++ b/include/linux/kho/abi/block.h
> > @@ -0,0 +1,56 @@
> > [ ... skip 25 lines ... ]
> > +#define _LINUX_KHO_ABI_BLOCK_H
> > +
> > +#include <asm/page.h>
> > +#include <linux/types.h>
> > +
> > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> 
> It's never used by block set and after looking at the following patches I
> found that it's appended to LUO compatible string.
> 
> While this works for LUO, I think it should be kho_block_set_restore()
> responsibility to verify the compatibility.

It should work for any component that relies on  kho_block. My proposal 
is to use this method for other common KHO data structures (e.g.,  kho 
vmalloc,  kho radix, future kho xarray). There is no need for them to 
carry the compatibility string in their metadata, as whoever uses them 
will include their compatibility string.

For now, reviewers will have to make sure that if the ABI header content 
is changed, the compatibility string is updated.

> > diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> > new file mode 100644
> > index 000000000000..4f147c308e6b
> > --- /dev/null
> > +++ b/kernel/liveupdate/kho_block.c
> > @@ -0,0 +1,411 @@
> > [ ... skip 121 lines ... ]
> > +/**
> > + * kho_block_set_grow - Expand the block set to accommodate the target count.
> > + * @bs:    The block set.
> > + * @count: The target number of valid entries to accommodate.
> > + *
> > + * Acts as a runtime notifier when new resources (such as files or sessions)
> 
> Not sure I understand what "runtime notifier" means in this context.

It came from discussion with Pratyush, but I think we are on the same 
page what they are, and I will just remove this.

> 
> > [ ... skip 11 lines ... ]
> > +
> > +	while (count > bs->nblocks * bs->count_per_block) {
> > +		int err = kho_block_set_grow_one(bs);
> > +
> > +		if (err)
> > +			return err;
> 
> This leaks memory if more than one block is added.
> 
> > [ ... skip 31 lines ... ]
> > + * unregistered, allowing the block set to release and unallocate redundant
> > + * preserved memory blocks. Checks if the last block in the set can be removed
> > + * because the remaining entry count is fully accommodated by the preceding blocks.
> > + *
> > + * Note: It is the caller's responsibility to ensure that entries are removed
> > + * in LIFO (last-in, first-out) order (the reverse order of their insertion).
> 
> I think "in LIFO order" is sufficient :)

Oh, I keep removing those :-)

> > [ ... skip 173 lines ... ]
> > +		it->i = 0;
> > +	}
> > +
> > +	entry = kho_block_entry(it, it->i++);
> > +	it->block->ser->count = it->i;
> > +	return entry;
> 
> This looks way better than the previous version :)
> Thanks!

Thank you. I will send a new version of this patch as a reply to this 
email to avoid cluttering the mailing list.

Pasha

> 
> -- 
> Sincerely yours,
> Mike.
> 

