Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07919C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D7A6B00DA; Wed,  2 Sep 2026 08:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EBD6B00E0; Wed,  2 Sep 2026 08:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45466B00E1; Wed,  2 Sep 2026 08:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B107D6B00DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:26:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7CFB1601C9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:26:26 +0000 (UTC)
X-FDA: 85168745172.02.2DFB97C
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5947100004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:26:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXzBJ7Fy;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788351984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=036mA8orffinoqt2iQHKcFlBXTwc5/7dbRbRMf6syWk=;
	b=62eFcVoXQGTJCA6dZyh84VRoNIy/UM4I0UZE6xP8TA3DhsA/MK5FsMLb18c9S2Uf4YsuYZ
	EctkZuHuQyMWfk1ku7+hautvtRm5CO+63dEKk4A0yK2wEkMn1sX7k6fch37IsfTc9FIStu
	QNOSDHV00rPL47SZHcvnF6jzu4N8EVM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXzBJ7Fy;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788351984;
	b=ABrmPxbRi+CkuIjj42HcSoQ32tPuVVAO5SpNKf1FpkLs8gGK9Yyey5tn9QbyFA6nt/x0iQ
	x/W3EmPbQKQ3EpzaEmbf/xum8dDSdvU+jK3e5KBFVD78QcmPUry6k+UMW4H8HdCrBtUj3K
	pOprHpGAYyZZ7/l9xLXH5xiBxLAkSpc=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so989917f8f.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 05:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788351983; x=1788956783; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=036mA8orffinoqt2iQHKcFlBXTwc5/7dbRbRMf6syWk=;
        b=sXzBJ7FyzucEGY5Ty7hgUmiSrN3NSgzKD0OtorInD4ArIe++FPBPdAR26W3mbO1nqK
         RpFT/0MenYfonyl15m8cxLR1oIGr5j6qhBVnq03H7JxWWjmVnKdgDs1lwOKrRIiPjZFh
         XQ+8J+hVklmrPTP/LfRYRSUjZDFeNqCpGavpnBuFt4bLLjaFPT6dCpBYd0wkr6Z9MjNq
         fhPz0YKVwHVIZhz8Hec9DiIhZEx7Ughp44DexBT/KgHT81ykzhLdb/ETdDWBh/KQrV3k
         mBsxONxZMCyDuJsAvhOfSEo7TCk3Z7hTANLMdBeaFzIugBQTw20WmPg4stlfrcUrMNA8
         QPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788351983; x=1788956783;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=036mA8orffinoqt2iQHKcFlBXTwc5/7dbRbRMf6syWk=;
        b=fpremybhx83qT94TL7NWBxcr4mzvnLPkDj5UGDeEJQO06wSZNot52EiFfJ5ZO+GHIx
         vsZ7/kdllREt8Uv2T2hkXtmaZzZFA6jZdZHsoXr4bs/YxsoIlXPZl/iLsaHdpKer0zTB
         8LKf2O5R/DtItV6mCL1ALD8uVkFp1K1cHuSH7m+XruylMbd66dbR+OWU6OLGFHQ/jlx4
         7r1PVLzRS0rk4NP0XsrelyfIL8oHxJxsYcaNcbIP5XXOvLyuvO1buELZGCqlWEwKED2T
         vEznqyld6CnLEHWqMRF36TPoWiKm4hEawHF2vJhljjRF6VyKSB4UwoRrD3sA4TuV0O60
         /Btg==
X-Forwarded-Encrypted: i=1; AKwUvBzKegYiGMFuQ7oVXoJI5x/3KI4QFk+wzKCWLFJ1d5SmykTlLClbCU9zy38XwDhvlewMq2BieK2a9Q==@kvack.org
X-Gm-Message-State: AFuF++nCgP0TM+HKDTj4cFOB7gzvukM7IuCE+vTfkaQoL0CfenNv8HXT
	q0pZzYlRmcXrYR9N/RHZc34VTLQz4/S/k09hTiqKRGGgciR7nRvqMr/4
X-Gm-Gg: AYBFou3cjkByMEhTmlCrHXHANlb75YJHuAMAugpLa9vM8zpihJxPLghnMOr2rVpMbJF
	GdoqVQFyEViqYxvxT8USy29ZquyDxddv122Hw+QJV0G5yo+K32WgscG5XN17WS1eaQBCFbg8jcQ
	SMtP/ewrLDiVK3Dg6CxxF47scN3x458LyO4UkTYPGwG8NHHJ4h/0ZDLzr7o0+F16ABsPhKX0X6e
	Qnuo8CMKPSlRuPOZQF95dAnWpP7E5w0/igome8RadQKLeqblNlG4zNkeKhA9Fvy5VHRNL83NznA
	T/3oeFvPPe7T2zrCXyYopqwimrNYnsleIBd/SZxDLwF2Yz/lG3i/2VZ1oBop7Oqnc94yqGcdqpw
	r9gVDppaPcuZAJJfFFIhsVYm+XNkXHAdN1fWMWkhJqYuEDKFv3/tB/IKk7jAEVzO3t+0O9jt2t9
	JCW2wWcJPutqcMw7VTzJqHzhQF7oqe/GOo9xoKIr1k60kMCCGBMzTkoTAHe+n4UD2mIHD3YCQzj
	cbVFNwZTaCGivUxf3zPgPfcx0e2YpwHhQJv
X-Received: by 2002:a05:6000:4b1d:b0:481:503b:b663 with SMTP id ffacd0b85a97d-48488f1ac85mr8671422f8f.18.1788351983076;
        Wed, 02 Sep 2026 05:26:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492cdc37sm6635359f8f.34.2026.09.02.05.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 05:26:22 -0700 (PDT)
Date: Wed, 2 Sep 2026 13:26:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Brad
 Warrum <bwarrum@linux.ibm.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Michal Simek <michal.simek@amd.com>, Ritu
 Agarwal <rituagar@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260902132621.7444266b@pumpkin>
In-Reply-To: <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
	<20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
	<f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
	<20260831123937.32255a49@pumpkin>
	<apaF1HUtJnstuUN4@kernel.org>
	<1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
	<apcPg_y-HsMki7we@kernel.org>
	<9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kej53tqazi64gzajwnfn7d7ke3e557cu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5947100004
X-Rspam-User: 
X-HE-Tag: 1788351984-48653
X-HE-Meta: U2FsdGVkX1/+/bNvnzHgOhEnduo8IlYSbURNeRyQCs8WXaJZwunAv+AI8cOg9DPmZ22o/3nzINCzvR4kQLCR6EsaJp0qHo05M4Bxlwf+0cZmZyTgonG2WLQ8+hRixWzNQ+WUjzqioULJJ+5yfZbiyTSZyeFq9FIrMap7DvlRBbL+PkYORhwdxHryOrd7P4rVCE969uYD7kkiyjmxj0o2t9QyCiNNgcwHbdkuHLxXumlty7ZezSPjbGtz52/n0quXRpdU4/mdjCYj2N5JBGjX4Qt2NKuSIMFpKyqqcwyLpWFSFMFE6ab68MaBBRrJ0RHeTtVVvsvaxpHDQTlqiNEhS9KAtpwaH8lQZ4P9zflfLPgO3SyTFEYoq6jfY+ZCOIKsJp5cnNFzEp1rCfqSx+YvjgYqBNW1eXdznAfNt48DHC7JufoDsynrJs6xja9xPFjLVJe4CnubQxXzuZ3HLawt4VE+Cjb3PeVuMWHGIMr38vcJnmYtVggr8jaLgehdxIUxGQT8eWCTFXx7TwfAgaQ3lUwf0FVE2vtl+mSobr0Grxoj+bkSi4YSwIQKWKzg+QNLx6mGL7PAQE79f2CAD0bjGhAT+GQOR9eLnV9q6cm3bq7xSt6MuvBVnWjqxpW74Uk4o6quwG/m8st90GFz/oO+m6134FSPLzi6QzjjLpJ+OLqbEdqcambFxoDiqLnaXHEbwIrLyL+UCtbVcHulVSy1+25IWb19pd3I+CqIrQb7pQj5Tu5ZBq3MQq4+4vr3ObkJznzawYFfQlNrLxpSgKl6o5KA5y+w5R8EwINswHBmQXzkesMaiUXyTZqlj4i/XMijBO5tf1sEpcN/edS4RR/+0zIANJ/UZEv76Om6I60yUuVBuf/tUzmw2eAIpCXcKJii+zx7cP8nRaxg+nwrohth6WBwvB1IKN2wYbzhl9fPLWzd3+ql2y1/RqIwx65X1ib/cdRsiLDRnHWXL10I3AG
 X36V68Qe
 nhmhTV4lMaywpIVEn+tVZ1hGUhTLQKVg0mfEqm5b/U/YIbWYsTpOc57OIOsysBMmEmqont+/3Rr6/fm5BDq2WJaLB70X6ngiYDVfjWn870UKwXuEQr/D0RuooYDDvjgtZ9sHFus7P9i+Omm4luMqukUOifCeMTjt7G0QJ49nQna6wHcUK3KtvoPb38n0spc4eLW7o9/3CBWtmmbNO3fmson0CqgkGW69H3x8vVirHg/c1JfPakoa4I7p8wm+64ucQQ0+07JZgoTXSLuC4PU22QnIGtZUQi8cbUY4Xo3aQLaZObxivfP1bwBUGXAote9/YtT+8WcJAguyab+36NyWYG2aynBXNITvDVMhGbwcx933sCbwIfZu5cKKOWdpQC/gqMDXWZRLfT2C6agfDKRUrf4g+OVoMJZB0LcDlNUEh6kt7R5IRgG34UvrOtzQsiddusv8/ND13/TvZnsElz3aGIHSAUK6km49C2HPei5Mi1TCeAT6Nb04DnP7Fnase5dpneesCczXMFXgFABsXVsO42HeNnWg+MXDineli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 13:41:54 +0200
Eli Billauer <eli.billauer@gmail.com> wrote:

> On 01/09/2026 19:46, Mike Rapoport wrote:
> >> * Does vmalloc() guarantee that non-pageable physical RAM is allocated when
> >> it returns?  
> > It's not pageable in the sense of demand paging. Some architectures lazily
> > synchronize vmalloc page tables and this can cause page faults that will
> > take care of the page table synchronization.
> >   
> 
> Thanks for this clarification.
> 
> This sounds like a showstopper to me. Immediately after the allocation 
> of these buffers, data from the USB device can arrive at 400 MB/s. If 
> the data flow is throttled as a result of handling page faults while 
> trying to write the data to these buffers, this could lead to an 
> overflow in the USB device's own RAM buffers. This is because the USB 
> device is an FPGA, where RAM is an expensive resource.

IIUC The faults don't usually happen.
But if one cpu write the address somewhere and another cpu picks it up
immediately and access the buffer you can get a fault.
Even if they do happen they are unlikely to be worse than normal
interrupt latency.

If you are trying to receive data at very high speed I'd have thought that
you'd want the USB data written directly into you buffer list.
(Much the same way as most ethernet hardware handles rx frames.)
I realise the the usb kernel code isn't really written for that sort
of access (some of usbnet could do with it).

David 

> 
> So using vmalloc() may result in a malfunction in the data transport 
> where the __get_free_pages() would have been successful. This outweighs 
> the benefit of a somewhat higher probability of success in allocating 
> very large buffers, and surely the improved aesthetics of the kernel code.
> 
> Regards,
>     Eli


