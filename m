Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB583C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605EF8E00A2; Thu, 24 Jul 2025 13:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567E68E007C; Thu, 24 Jul 2025 13:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E18B8E00A2; Thu, 24 Jul 2025 13:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24C418E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:37:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F46F1A0453
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:37:03 +0000 (UTC)
X-FDA: 83699863926.10.68D1241
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7FEB18000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:37:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9B1+w96;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753378621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+0psVHngmmkd6BNaJj165FgVIaF52MaA8fovNqmaAQ=;
	b=u+oF3Xdk8wyTvEe+qVSkJbh4pF/77V3k7gF2dLQn5d49dMKf++qtcLuhdyXKCGXucKjTtG
	y1jH5H5TfGs58pB+EkYsK8lBb1Fl0XDPl/oENNBas7/2qSirAtUn0oSSwHw02gNRgcpC0b
	li3JsUaBRXyVWc/AKVyXzck8NX8QqBM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9B1+w96;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753378621; a=rsa-sha256;
	cv=none;
	b=G76MSDJXUFZOYm+2TrSAy1UuYMDYrw0xwDK2QscLH6c42yzrveUDumaHb/gPz6SWkKjJTy
	+CggrT8Cw0Mt4nBKq9q656iHM+qCnUBAv/YmicL2TqcCqM9Jom/2DPbkaVnM8ADZUERwl1
	BkvxwWqbcpOitn3sGRtsLEQniSPlSWU=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55511c3e203so1153396e87.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753378620; x=1753983420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u+0psVHngmmkd6BNaJj165FgVIaF52MaA8fovNqmaAQ=;
        b=M9B1+w9664IFVAI7IDYc83WSYGHooKSVnRIXWb3If7SUejUs6M68P0dZDXNQVrU7it
         ehtZFxfeYOhBu+ynlHQh2PBDILoSMXVBTlSGO9erUzcYmeU89o6PVJgOnxnEeseIkeHc
         E8TW7GDMzwxUXHjJSjoENq6E1NRXMxCSUtCzYZftx7PrQ+kDw9n68flLFONIRUEXnSs1
         8lvLrvxskrX4NiqG9FgJtJqitaSpUNa4fXGBdDfViy0m5IPxsN/bc1Qu4yknFDxv+p8W
         6yVcqS3U7ghdLd6kJudtRdaFZKNb0/nndpb5ck9DQXna5mm89Mmm8pukNYWdJj4ei10J
         a+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753378620; x=1753983420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+0psVHngmmkd6BNaJj165FgVIaF52MaA8fovNqmaAQ=;
        b=J8XWgfFOAzXLzXJvo6jE+tFTrC2uhFVQIHhoiwIo3ACvZyZ0coAkqPao/35kzYH7ra
         uG5aqJzIwKgItNaFXGLB5gtRKczFwaCXVXqzvDgR6R6rmXmtNFF1uvZfZmKrm0UWqTtT
         PMfhzVxNQuF4orGUOdQXMcfgaRXeOlmccKO5hMqJSJ9AsJUH8roYQC/V9eqZCqHJEUeN
         5XokcaXZQEUWykwfEqa69EC+zMMOUeu03FK0qJ+JuDG0r8M/6hwebcOOHXu4txIoEdgp
         FWwP7v/lVC2r4wE1dTNlJW1vHSG3QMahLqiBd3jLGg2W1Qq1Vdc0U2WaH+WAZZ+iHib2
         KYlA==
X-Forwarded-Encrypted: i=1; AJvYcCUWorLoGbyR8N9qmK8T+NyvzjBk2KD8k7OOoyx1YsF6ug7dT6Wj0vmQNG4tKl2vW7nLeCV48eLgBQ==@kvack.org
X-Gm-Message-State: AOJu0Yyk6AzqBeEd2HmcpEW7m4XLuSVf8JKYxY6sTaSTHC/hcqiRxOwS
	AeQawgTDxTVY1AM66AeNPojizZTxTd0IrWkK5jFJFuJWWbss+gZnR6oF
X-Gm-Gg: ASbGncumM3UOkL90XKYBC7eV0t3HqxRh1KVF9JSo6aiIGcqiIzgGK0+taN8Fi75ESe/
	2QWbBhpQLMqIdxR2xx++fFZ5ZQpotRorEcWcDIDTO/XYgyhyEQxjroGFdnvjS38uGY2JSgmC/N3
	qEn+Ila/ALAEzkmO8x04hN+myPic0r2oBS/MKGjsMTVLBY+P+CvsPAOARWQ2mvXJZtk/lYKKdAQ
	62iWrbj9QJnq3bgkIhCPuE558Cv9daShGy9SaPsh1N/Azs0e/TuFT+9QjHExUYF8L3wCABf3EG0
	YPPUtPSmVePN35pl7z3lP49f9cR0qjA4XD2v5+dQUDZv4jlSm4dE+fnkBSQ6bMhd3RmAEbJsqCW
	dOoAam+TXmxiEyJRM6NNrJLhsi0buOGPyFpRea+hTNF85qYgec+Jy
X-Google-Smtp-Source: AGHT+IFJ0U7TkNADQ2AfHDBSDKSrNM+CuHEwo6+dh7Yi/pvc6GyK1HnMSXZ+oyUuzgfWZ9O/y6V/sQ==
X-Received: by 2002:a05:6512:1104:b0:553:2c65:f1d1 with SMTP id 2adb3069b0e04-55a5137e065mr2015821e87.13.1753378619517;
        Thu, 24 Jul 2025 10:36:59 -0700 (PDT)
Received: from pc636 (host-90-233-212-206.mobileonline.telia.com. [90.233.212.206])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b5b348ab3sm25610e87.53.2025.07.24.10.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 10:36:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 24 Jul 2025 19:36:56 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 02/14] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aIJvOLqljFiN_VLR@pc636>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-2-b792cd830f5d@suse.cz>
 <aIEQQ0MW5e8KMvVL@pc636>
 <9cad7b86-4b77-4881-9cbf-637b6a61695d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cad7b86-4b77-4881-9cbf-637b6a61695d@suse.cz>
X-Rspam-User: 
X-Rspamd-Queue-Id: A7FEB18000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 6u5twoibjrn3z3kbuhgjdcdut4whj7x8
X-HE-Tag: 1753378621-590542
X-HE-Meta: U2FsdGVkX1+f3pBFjpuXgXYRjCQb2ey34jx4Q+NMuPURt1qA9Jb//laPViavUWYKKGWo5Bdtp/fmjrKtAVt+fLsWoWrWLpxUn8a+nrySVtYxe5nxyPRB8B/ls3hS3VaAxfeD/BaDyAWIBp189rL0ZSjGM8vAlkkIPzpAyjUO9DZq2CYGweh/h5NeCNzbbeu2M2wugnevaE6F/FEuKHj33YQjlenXncXQ98VTrvjMw+1BLwF9bi23vwSZkopcch5fPzw0dYgPlw/2Z4dNCtmU2b1pyaG4raKG7OyhLzgMOWMf2ugFfp0tCUTDg0fCK8HLwdsi9lvOqdbn5hEhMzPAWAqyxM2IwCRsHwesUrFJNNG1cUYQHqnMA1hWSp6wxdJh+7c/ZcCGv0o4/2o0fekkaqoWV6czFkCpOiCd0CHlLEGAigPNi8fVArQe8M7p7Jtw1fo6T4u5n7kLvnqU9k3t2LZ2LlynyUggDuEVxZm7aWnxUTd57wB2cA4tlRh63Yt/uVKnDUPwAb822Tt/w+puTknhc+HVl68csSTr7owzz6TnA8szX2ts6fyfHX1PW9pSz4nC5WDY4G7NhljjQzHcEVFXokn0VKR+iHAQmvs7XieEsIbcNkTpCoZ/ZZLD7AvMbNKlM/pOdbimGtp3RUi6PBuqH7a4WE/BmPALaKjRvWoGYH0+FRX13BH4GAApdTDhJ4+ybl0pRlma4bFx3yMrfSOAzLKevHiBq2PqWQALv/FltaPJT9dghfOaLg1uAd/xtnvoSXQlmZ6Qwgkk1NJj9D9beGzFtcv06kC5joRoSrNYa9jVUD576vYNatxyBW200w3MY+SxWjmWyHkBMohD1GwhOLgEj6LmK5w0LRWstBCdT+SPUmCrO8ySBn6XtFdNk6Sk3jNPaBIh/vAHyGLTA9gYPzaP0V/YC9fp2oIFVViHanW3B6RUk8ABIOPnVKv0YHtkBNAXV0hPP9sLUSr
 VsWnpjCI
 SU8GitxH1yzvTOBPipgq2+Lfeb7hoXALHcvPEApoDyDSRAg77XG33+kgq0FGGZkaVIOeV5OT0KSYOM2oFjoUxFaekQglSOi8kcwDTF1Eio57ojey3fRPLc0RN58otAs8QzunrqIlaOONMO32/LUzKQ/dhXEFFuKmvdsok90t7D7sqlSJiJckk3enPnXYmFs9odnUMQOW7KjMmX6CFANCEJY+xOwUkKR5/GBwwGNvP8I1a4QF43054ZdcYBn1t+/8xVFCOfv7JGlPVeJ0uw9+F8nN25RjXAoQOhVBEf4RU7a02MruB7TNkmWG7dn8p4J4UF0tmG25tI6zIufeYwC5IvPYy6YaGqWgswBZe3S152GWKazd1vUqN40lJk6yivNKf/tKqS/cnGzR0oHJx7dm56VTisXZv9qdhGgqf9YUbqAgA4wTtm1YJUm6aevcd5/Fp4fu+StDko+LUj0ak85ZzUrPpQq8A99hRFMSp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:30:49PM +0200, Vlastimil Babka wrote:
> On 7/23/25 18:39, Uladzislau Rezki wrote:
> > On Wed, Jul 23, 2025 at 03:34:35PM +0200, Vlastimil Babka wrote:
> >>  static bool
> >>  need_offload_krc(struct kfree_rcu_cpu *krcp)
> >>  {
> >> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
> >>  	if (!head)
> >>  		might_sleep();
> >>  
> >> +	if (kfree_rcu_sheaf(ptr))
> >> +		return;
> >> +
> >>
> > I have a question here. kfree_rcu_sheaf(ptr) tries to revert freeing
> > an object over one more newly introduced path. This patch adds infra
> > for such purpose whereas we already have a main path over which we
> > free memory.
> > 
> > Why do not we use existing logic? As i see you can do:
> > 
> >    if (unlikely(!slab_free_hook(s, p[i], init, true))) {
> >         p[i] = p[--sheaf->size];
> >         continue;
> >    }
> > 
> > in the kfree_rcu_work() function where we process all ready to free objects.
> 
> I'm not sure I understand. In kfree_rcu_work() we process individual
> objects. There is no sheaf that you reference in the code above?
> Or are you suggesting we add e.g. a "channel" of sheaves to process in
> addition to the existing channels of objects?
> 
There is no that above "sheaf" code. I put it just for reference.
I suggested to put such objects into regular existing channels and
process them. But for that purpose we need to check each SLAB object 
because currently we can free them over kfree_bulk().

A separate channel can also be maintained but it would add more logic
on top but at least it would consolidate the freeing path and use one
RCU machinery.

From the other hand what else can we free? You have a code in your patch:

	if (is_vmalloc_addr(obj))
		return false;

	folio = virt_to_folio(obj);
	if (unlikely(!folio_test_slab(folio)))
		return false;

vmalloc pointers go its own way, others are SLAB. What else can it be?
i.e. folio_test_slab() checks if obj->folio is part of the SLAB objects.
Can it return zero?

> > I mean, for slab objects we can replace kfree_bulk() and scan all pointers
> > and free them over slab_free_hook().
> 
> The desired outcome after __rcu_free_sheaf_prepare() is to take the whole
> sheaf and have it reused, not free individual objects. So we call
> slab_free_hook() in __rcu_free_sheaf_prepare() but don't actually free
> individual objects as necessary.
> 
I see.

> > Also we do use a pooled API and other improvements to speed up freeing.
> 
> It could be useful to know the details as in Suren's measurements there's
> issues with kfree_rcu() using sheaves when lazy rcu is used. Is the
> kfree_rcu() infra avoiding being too lazy somehow? We could use the same
> techniques for sheaves.
> 
I think, it is because your patch uses call_rcu() and not call_rcu_harry().
There is one more tricky part, it is about how long rcu_free_sheaf()
callback executes, because there are other callbacks in a queue which
can wait its time.

kfree_rcu() infra does not use call_rcu() chain because it can be slow.
We can delay a process of freed objects if an array of pointers is not
yet full. When a first object is added we arm the timer to kick the
process in 5 seconds. Once an array becomes full the logic switches into
a fast mode, reprogram a timer to trigger a process asap.

Also, this patch creates a collision because it goes its own way. We
have a kvfree_rcu_barrier() which becomes broken if this patch applied?

--
Uladzislau Rezki

