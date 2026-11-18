Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585A8606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K4BleWLG
Received: by kanga.kvack.org (Postfix)
	id 735446B00EF; Wed, 18 Nov 2026 14:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3FB6B05B4; Wed, 18 Nov 2026 14:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3116B05B5; Wed, 18 Nov 2026 14:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA916B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:16:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B143E140866
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:16:47 +0000 (UTC)
X-FDA: 85449196854.16.9F79589
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id B62374000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:16:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K4BleWLG;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795029405;
	b=GWOq13VC/OPrwSK84UKBOgwVIZ/rBKn0jA0hX9/P2HMxu/TsQYs/HVV9zQLLNCfqlvSFsZ
	DXwAf98Q0FpJ51lgrdPnuMEYOrg+d0VmzD7LEC1rhek1aZXa/yQwTAsA3WRcX2ZAQ1zDwD
	s9VruFwb0rBMitgGakp3K/lklhDX8WQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K4BleWLG;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795029405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wesoUpV5LSWdODsu/SFZafU9p7VW5qMB6GV5WAXmCps=;
	b=W2v0fBUNucwmyTT0jbfkFWpVFmEqw/nomMRANUybTLnsEQ0CQr2fkisyQIcy1Q8rys/h7S
	S7kvAoDajpC54t5T5x0EacsUYvpQrbAQmBhPTp7VGEymn/RRMlNIPs0SXQihfQReT/wZ6X
	LuLtAlsZvHSH6CsbV1VGeUwbiZH5BLE=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4cdc606b47so237430466b.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795029404; x=1795634204; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wesoUpV5LSWdODsu/SFZafU9p7VW5qMB6GV5WAXmCps=;
        b=K4BleWLG9pLItRSeAf50vWSk+NT4wLZLYsTgFmzOTPc8XiToDo9abvoIgjOcKQaexQ
         8p9vu9ruWnM7vuLtqebGGJjCVvDCljWeh21Jd8M3pZrJvrGEVMN3VE7WKjTDdwUxRapy
         uJocT67xxhzaoqgABCZfCVMwIM49HSszKj/VEMXJZwfYj/KPUGwu10ZA7Bl1HTu8kbkx
         rMhOibZhxugcHAFI1GotzQi4ZJvyaqlJvnuTZoO5TmudQA86fSD3WzguhEzu1h3Gf2oT
         iEsQnE1VuSernov6YbHLWD5+fE1IoDd7Ot5Z6fDcUli/V+VHpbLDH4Fwz35pig8+GyXF
         X6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795029404; x=1795634204;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wesoUpV5LSWdODsu/SFZafU9p7VW5qMB6GV5WAXmCps=;
        b=p3NzWKR09n3ehrkqgP7qFNBQJyz8IkV7i5jJtD+ZwCxRw8niH5sPHgJSYn7u8IqjvJ
         3PUiYd1+CsQUhPpgslirK6YevT1WtQn634emdLvwdtAj4oq87kpRev9RF63ud8RYu0yP
         Hu1sebiqBAGmOr4MmSZ5sgy+B6a9m96B6l89RPkqLro+KpfY1wT94v05ztQY5CMBCIvF
         0MTxVUDyn1Ft0Vvas7PsZUsV4KUvy5j24K26wlhBltefNHKGGLYTdTfciCJob4YblVUZ
         wD5dgnhPvrd+g64n/crS6bfbRgJXuhfVH9653amWNZPWP5UHlfVvk+BDsHsbWvzm3P3H
         1BRg==
X-Forwarded-Encrypted: i=1; AL+hErEXbwN9XOYaW8WndliCPnv+tPrB4Hz+xDF+zS0y1dcYL/a2Qq7QO/9XRXM9W8wBDoFPC6JYqu4Zxg==@kvack.org
X-Gm-Message-State: APuU4Z/iUawx/2cHqnOCR8AOYu1X4BThAiVuHXV3fPawTlpbjmafr75k
	0tOUWDG/7EGuAfAjKehczVov3+yJtOqZJYxp0EyIz1ZKzxDJzLyAEjPQ
X-Gm-Gg: AYBFou0A4Se28mVXkWP9T4R3/qly55+ekEVEPq+VOEMFZp7BRC68nTLNzPOy7XylOvA
	9gQ3Yh8ctW8sgneohNB7Rz9pmG9FDnkeoPltgOPeW6dtMDEnyLRG8zl+WHoeTZNIo2+2QUIJNy7
	QHkTCFrTtsiurTQZygVQ43Da6MzNNGbwzk1qQfKcYJB34QlfL96ERaNQeLbjirU6/tYkZLq60Ht
	1cfz4fmnvAtHZFUEpcmxcuePEMq4iyO/b3BJzbAgmO0wJ58sfAIhl+ZMOTPerFYwWW2rq7DwUg4
	xPJXgkpsoQtxAGi6NxlJPdDAqgmSBFa+nsyPDDb5jO5iHQ0XTiUvO26sf7+hSjv5zVtVNcQ+Vzr
	DtIyAAVcAZK94d217vQy7SCBADLmvf+75EYv2YM5+FeJe/t14+F7iRj9xyrCAcu4qk85NW+CaYW
	OXHa+tz7yNsRZQU3PEOkEnH44DJXSMZvQb0sXfxpog+alajn7Z1JuKCTJ+6Ebas9oSJFgGzLCCq
	Z/7LRz1NCwt31zXor8lQjOKeCVbRhxOdN4rqiR1jvuiQQq3bcESnvTsOKyHLBp6hV8WTg==
X-Received: by 2002:a17:907:3e9b:b0:c50:5186:a428 with SMTP id a640c23a62f3a-c510e2d83ecmr343950166b.27.1795029404223;
        Wed, 18 Nov 2026 11:16:44 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51233c4cf4sm30980066b.29.2026.11.18.11.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 11:16:43 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Nov 2026 20:16:40 +0100
To: Dev Jain <dev.jain@arm.com>
Cc: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 04/11] mm/vmalloc: reject an unaligned range in
 __vunmap_range_noflush()
Message-ID: <av35mNq7RrxN56Tp@milan>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-5-hao.ge@linux.dev>
 <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c233641-15ad-4e5a-a106-423bc31f357c@arm.com>
X-Stat-Signature: 44xg7ecp14cfxf6zogo7hstso51fa1dp
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B62374000D
X-HE-Tag: 1795029405-143427
X-HE-Meta: U2FsdGVkX18F8w8T2aU+0v4h2FO1ZHeqDiMWaQi+Effquvo1fYp8aZx/ocAe2CMxrMbBLdq3NgPRNJJU7wb2VSoXfRLd413mFkdE4rWLc8daJD+xyfgn7C6rLIE0o2fIdpSe6d/f4oL39oGRzfrKLfFzVSlN6TpOpkzCSE3qQvLZZpnKfAIe4j82AaZs7M77uuXxriyPbv2bS8B3aKQeQc9ly3tOeIOfm54ebmIH2HXVIUFLm5Dy5EIHxy1KV5xo6iX6MGEuRbZym3rxQ+oYPGZujUSwwFPrvxBJ8L0FJn0m90XJSTKLp4WANMh555IGnWpfSAWxRi3vi1uj8GsTPZHBRuBuwWK4Nid9eqAZaSeYtXswcLDpa+y0pon45S8vOwuxbyjsYNnK5w/qkmMZbwZOkpcp116OGWwDg36mRbPjIAULMxFmhw8TYH6x87Llx+siKdZOlCBE+D1wtmB4SOvQ7RoI99fe/N1iiqPWVosLxqsfvEDI1utrdLt8pOhc8vzPgHU6+S5/mcLxbjWBxdm+w/11iuHnFnMogaTUBEzdleZePUiaGZdoiPqOBcTcWXs/EG79u2c/bgSTe19oD0iUjjNo5IyAsdaFTgJVglYeu2W47+nYx6BDSh1IPGxTsxJ65p5kXTmfDXmqInuBMAoHjW/frUFsq48TAJGilyZOWKGpdkc5n8LgH/DHrfQnDNE6TOS5bAs64SDoAolmkNpPexH8Ouk6lBC7ctHC5gMeo9hU09P7QOJxVpF45xhOyjqYdaC5NKEP13ABSECGrrE+hwv3vgas8DF7VWhr8Gh0VA/QglFeAJDjfbomtmBRiiyBnsjVXg76y8bIq9IPE8lAGtzXE88HGvtqosHZym+08XUPCpY35ufIDJPYyqF5Vs83nFu0+wrKX/fbcGZmzmhv/f/OTd0rKeipWLK9ynfOucwj4EmH21zYgzqcbUe1X9G3xcivYNW8xAikXAc
 nz3RAcpV
 sqBSQAjAL0m6X05YPllmjIFnx06B3Uu/+Sy2ncGzdzy1rmAjwFbH5cVEl6/XG6C8rSHes4rgESRoCXsQ8Sxgk+j5OQb2HYw2hVAeWFj6XBVeiCGtVg+3NHeZXE7HiqNXRYlpvy+N4MJHd8mDf7gmwXzFRA+0UiLV/vNbA7d2gwnK4T8wm7LGS3GukLtK1TFKPcSuaWT1o9gTHTCH8pLUWIv2Q4DsHD/57wbx2sIXQgA0sCBm4IdHOyiOD+3RRYVeqMQ7YkbApghPu8biEYox9c35CZkLr4q1g3Y0LMoH3urhEER1+gmt/+0D6lCsR9BC/+VwJ3jSNwAs0PRYMVMWET5yidiou3MiqdRs6xAOw/lNJepmSE8wzKZdEbMaPNJeUErpiHS79c5EaPMdA+LIsWUgQltW5CVQgu+ZNL3S/JLxOJv56bKhyYRY03FyOhLqTogrL9eu/UQ0LA+IH7t2ZBSwfgrSk69fpPl8qUmH1fUgNO/TB9IH5HV2cDTSRFyQh+xYbAKpfMnpY/OlqqY+PebZMeUMAUoX/irN1YW95RFwKizJ5qvqoqgEu1yvQMv3hrIqKzdK4XTNEIh9KH439b1NawfZZM+4qUBkwvANdgoDueF4x7yKvSswndh4bUCi5ULWk+lQsIUHTk0wZK7kNYhGPvTV9uGbN/tce
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:35:24AM +0530, Dev Jain wrote:
> 
> 
> On 16/11/26 12:43 pm, Hao Ge wrote:
> > The PTE loop stops only at addr == end. An unaligned end is never
> > reached, so the loop keeps clearing past the range. An unaligned
> > start clears the page below the range first. Both are caller bugs,
> > and the damage is hard to attribute afterwards.
> > 
> > vmap only installs page aligned mappings, so an unaligned unmap
> > request is never a legitimate teardown. Warn and bail out at the
> > entry of __vunmap_range_noflush(), before any PTE is cleared.
> > 
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index a168f6f20f4f..e2b63cb1592b 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -523,6 +523,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end,
> >  	pgtbl_mod_mask mask = 0;
> >  
> >  	BUG_ON(addr >= end);
> 
> Nit: It is usually a practice to change the existing BUG_ON's to
> WARN_ON's too, if you are changing around that part.
> 
> 
> > +	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> > +		return;
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
Agree, please also replace BUG_ON() and feel free to add:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

