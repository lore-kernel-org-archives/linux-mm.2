Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2A5606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gwqv+vQo
Received: by kanga.kvack.org (Postfix)
	id 16D416B05B0; Wed, 18 Nov 2026 04:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7DD6B05B3; Wed, 18 Nov 2026 04:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00E56B05B4; Wed, 18 Nov 2026 04:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4A426B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:11:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6A81160290
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:11:30 +0000 (UTC)
X-FDA: 85447671540.30.CF753A4
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id F326EA0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:11:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Gwqv+vQo;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGpixNBxWXCW1MjpAmJloCJpQLDbcvvCFftHkMbvGwc=;
	b=d4OgEqDX76l6+jV1wtdQREN61b/99gd2OEpRzn7lxO3/LXfaozbkvellGdxCfmvhzkR9S1
	lzxkh6uE6GMSnqrJLV75LS5VZfrUon3uW2JwPdEitjZF6xH1TPiP6o4i+WtuNdvXTot/RW
	cLP5sxntMnASlN9OxLidIRaCFcRsI5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993089;
	b=MblGREQOOM1yGNLMff6YU1ydTMp/Fhe1PoC6WfooSQqXeEM4qAhN2Gu+6SYqtgs7qBv0ba
	t8OMQ+jaRHZ65yYKPF/GF6Sdf9kO7Jb9CSOpjIkPjQeDE85bC5LMx6pZn3lsnfg8WoNZYU
	rSxbuw/TELcjHkipHEPrgSy/cyZ5OZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Gwqv+vQo;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so7389585e9.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794993087; x=1795597887; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YGpixNBxWXCW1MjpAmJloCJpQLDbcvvCFftHkMbvGwc=;
        b=Gwqv+vQo/p4/EL5I5Ih7oTXuQx6tPR7ftCpr+MmwsuvgBT1bdI67t8X42X7LcQwWd2
         TFxgDOyyD74P0A4jHfundOkJ1lexO/Q9AXdFbrK7Eu2KkDVeqj4obtOsKl2D4uLRtsnF
         AdqYI4WgNPT6yOWcQddva0JvmAvtufiTbPh28hU55T51T9keECu/ymlOSWpw606UKvxH
         4a2dYv6gO+wPSuMd65FEUbl86NwPKjJOFBTTLepLYIlS67XrDHD2ePYZ6kRy/Ud3ybjX
         /5DLajCHC5FE7hkClhIaYljNvimIOcwt91DS2ThbWzVmG+PfhBJMCuJENxYGojAxvc4L
         xorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794993087; x=1795597887;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YGpixNBxWXCW1MjpAmJloCJpQLDbcvvCFftHkMbvGwc=;
        b=a5yfxPySa3JNGsKKad5YfO9WJX17gdz8MQ4vQUScuux4SKUgAFE3eza+o5//GDIWa4
         cQ6d3QmiLefM6+nfLc974IGOARRWpHGBL2we/RBzvzVxdB8rL3752318fH3clSCyn3BA
         CQ5pHwGbCmuz+cMd48USD13cM2/cABntK20e1H7/8wqI8pvjfN1+vfqCT5M8V5ONQ+lx
         MDp3AWCeDlAD5VOr0Ea7QLEUBGl47SEedN9Ub/8TmuzbXr+K/vtolXUTMUDoe3Mbqadz
         QJ2LkMOplD3PTTYQOM3lcGfFuOKLQ5rKOnAhpRCeEM3RLEYXYxThFwUVu844iREFh2/y
         qFIg==
X-Forwarded-Encrypted: i=1; AL+hErHXxl4EeDGGK+tjwWPIlf9vkXUiYKWdBmsrQ78pyzgFnbd0fW2yKSatqFRASqm0LyDOUgIYdc8b5A==@kvack.org
X-Gm-Message-State: APuU4Z+u4x82RBxGpXk28rZLHkV7CSKnMUe1RXsIkKqLylCcpjq+PH8C
	lbD3JITsvRJBQGk68UTRO8S42tga12iqayjN74/yZ1eiMgsUZXQwA+rN
X-Gm-Gg: AYBFou18d2ScRIIXQ3jzxpJFVVP6UFq3p0hYHenNz/oyWOju6tuSntI03+dPpSO1s8P
	hZt+gYlsUrhF3qapkiLyN162Y+SPGcN3IPOK3AcmgY7Lm/YvXPpNnqySHQZKhb4TzxTDZwMQ6Ca
	v/d4bgTW0OOZzQn3yMlJFbroe6OZg06JiNo9PhExC1SEg4o+finQLyCNVQR2TVUIugDs0LLMHSp
	SMzJ4GFROCQm5rrrj6YCNBXU/6VVxA8yK3dmouXkfxTCEN5kaP6MHQFH5BwhOKv5VeE8dZI1xzE
	ubMLGRnzn89GyUMky+z11taqbw/JBcd+bdjPKJ1yre8hVuP8UYL1ckIidJbBTQF5LZFT2Snbe8B
	2ZznYD2V7Z1A7jtzuTKmgw9CLkNnNk58Gr4YSu4I8mMC9YYydlDdOkOZRzki4NhLBN6tq1oZjhQ
	W82tT+LrAPlEe1lTN8dC6y75JK4l6PbW3Ezy6cIwqEZF3hLRNpLZwVrEjnK1rB6e2FkRC6Obfc+
	MaDyJ8/vXDOtDDrwWGqWZM6/BYI7xfS3QR2AScjr4tp/Y6EP66w3+8zVekII8zJG/Nm+bkBystT
	RscpgRyAV/1icOpbzqu9immA9RanPqiT5+iPVQBjcrVWwd7Gy9vUeRuoYq0nKn+7mw==
X-Received: by 2002:a05:600d:6011:b0:4a2:1050:aff with SMTP id 5b1f17b1804b1-4bb7da12dd2mr34320085e9.6.1794993087333;
        Wed, 18 Nov 2026 01:11:27 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm137000655e9.12.2026.11.18.01.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 01:11:27 -0800 (PST)
Date: Wed, 18 Nov 2026 09:11:26 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, David Hildenbrand
 <david@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka
 <vbabka@kernel.org>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
Message-ID: <20261118091126.25efaea8@pumpkin>
In-Reply-To: <20261116152216.165348Aa5-hca@linux.ibm.com>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
	<20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
	<20261116152216.165348Aa5-hca@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F326EA0004
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: br3he1z9ah83dywhpa9wmzf6xqh5krwc
X-HE-Tag: 1794993088-323325
X-HE-Meta: U2FsdGVkX193IuftzUa5YaIMHuaG7/1e/n93aDjgYaeF6oyLHZYzudH9CjjdOLvztZOE65m+7IAgmFzV3zER0qewQA5Tf/b67ZumUtfMmSPmSDtLXbPA2q8lbZK5FcHNSLtC3Jsh4cnpAEkfjv3Azvn9cv7j+0XwxUh6vbuRL1SHjqaw5Kr/uTsyZ7zI82qvnUcNFDWoEgxtB2vujSE8KrXwcrLF28dzHu1O5y1IBGQEVh9B5qgvNfsEBiQGeM3A5LxiIFZb/M2XhhTW+0LB8DeAvalhyxTG/rlqBRGB+ZhKDErzeFMjnrf8yV3PutnpzUB9vxmCkTDkjFz1iMpL/jSZavewRU8HYYfZrpCiAoibHndWCiq0aZ5alS+DKnrITlyyrsHW85b7QtgUpgv0xQWTguoY5JRqQe3s7WAJAENjaDptUiMJ3TrW9w3JOSqtIvgH8RSznUUjUotHi9Ws99Ke7zqcAkYQwC4YzWSlg3Wg8gidL86JxJyc/Aqe46u1MSYEiR24MmisOLv6cFq+kGV9hP8rmpQF7iJkdXNZ/L5w325oZrLwBPyVlTzGNDVNuJ1j6La4GovSd/3Ht0hnfljvDrI515Qn54I6ltpZVuqzWXTKxxJWvJKOpylQQhpUImBHamWWKPjRUugU5q/6u4cZw0+LJEMpXP5Iu6IZDI821ZGqwwKLCWevxRbtJ8+Gk0ZFa8fNvuJIwih06a/14ZKpKGHQDqgmzNcXWVnKG/37m4oqaVObIlhXSfC5/0VSL9qnP6qipai6J0Y1TU6RtJ3GtgPVsXmT914R5Eb5swieelMkM4DGrPwMfEfwEupGwJhVuN0N2lidp1820m7DrBRI559NengEjV6Vwl/XzouP1iyQJnElewlr3Ik5LyVhjW7Y5h5xH0jC0qcXNNBZy2S9OshYT7MDiq8VUFeqqm0efRBiGRg3dN725bBwdfrjW1bJY1OAACSVXzHbj3q
 s4Qnf3TH
 O28ZR5PxspcxBX70ODiNM2mPaqu+1r1LHI2HGMHRB7JW2G+zHTrRKFN8bNPwq97NEP3NjHIDAxiHzBtY016z1GsfnOA+nxfb6XZZMRJnRG2jUiPSNOPwvucMUtGvdITkyH3Vfd8ebc/+riZN0f63BVa9wjg9owGFV6nE7AsWqj/bFa116hrS54w2G4fgDRxTFk2ip34K9r7MYzqHApDtqi7V5rwOaa2J4zi2ZX9S9mHpHmLZ/i67g1zkp+QfVPQb7noc8yEsPr1dZZBgvWC9WcI4Y0IyP7dNVgLgSfQgjyN1IizS1knruBAziWNBqZmKk3hXZMLOf6TwDokXJLM+oDTnK+O68027Cesk/aRRewldfqJIoaeaWykTr/Wt5MI57OeMlAmHOPy9GMSbDzRu1dANN2LvcKF4DZhBiosMEHmPwUH0J4dHDhbvEb4SKq45W10mT3YRNarUjINf1isIE6PI6u3QAT2D+Tk0OZ+yuDhH6e9Mh/slqmmNTKjOmiRmR6c39VEVNWTNcUf/u5wKTcQ3XRMzuGLsSMo2U7ymsbeflM+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 16:22:16 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Sun, Nov 08, 2026 at 10:58:41AM +0200, Mike Rapoport (Microsoft) wrote:
> > _sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
> > allocate the SCCBs used to read the CPU information, to configure a
> > channel path and to read the channel path information.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > While on it, allocate only the amount of memory the SCCB actually
> > requires in _sclp_get_core_info() rather than rounding it up to the next
> > power of two. An SCCB must be page aligned and kmalloc() guarantees that
> > the alignment of an allocation is at least its largest power of two
> > divisor, so the extended SCCB is still page aligned.
> > 
> > Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
> > and free_page[s]() with kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  drivers/s390/char/sclp_cmd.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
> > index 1dc93d945be6f..6aaf1f6a3633f 100644
> > --- a/drivers/s390/char/sclp_cmd.c
> > +++ b/drivers/s390/char/sclp_cmd.c
> > @@ -102,7 +102,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
> >  		return -EOPNOTSUPP;
> >  
> >  	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
> > -	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
> > +	sccb = kzalloc(length, GFP_KERNEL | GFP_DMA);  
> 
> It is a bit subtle that this really works. EXT_SCCB_READ_CPU is 3 * PAGE_SIZE,
> so we end up with a guaranteed 4k alignment from the slab cache, which is
> indeed sufficient here. But this is really not obvious, and not as stable as
> before, IMHO.
> 
> I'd prefer to have this changed to:
> 
> 	sccb = kzalloc(PAGE_SIZE << get_order(length), GFP_KERNEL | GFP_DMA);
> 
> which comes with the same alignment guarantees as before.
> 

Would it be better (more obvious) to round up EXT_SCCB_READ_CPU ?

David

