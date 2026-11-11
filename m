Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F072606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=BgCEjrnm
Received: by kanga.kvack.org (Postfix)
	id B4C006B05B7; Wed, 11 Nov 2026 03:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCE06B05B8; Wed, 11 Nov 2026 03:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB856B05B9; Wed, 11 Nov 2026 03:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7640F6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:16:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EBA980217
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:16:52 +0000 (UTC)
X-FDA: 85422132264.02.473AD88
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 070AA40004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:16:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=BgCEjrnm;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOHVTuC5hHIVI7UZZ0LVQbOrU8lnvBC2EJDORqtQwNI=;
	b=tNO/qUkMoPgQWClgC6Cnba9eisBuFRK3f9b2WcLP9v951AaJ0wgIdtmi1ufGvafJ0R2QlU
	bRDtaxHnx/xhUzCAacGqdjIf8OHL7m+Epwu5MM0TSeuMHpRwW+rjkTEGLS0twwF8qFgQmF
	u6rzQ/of2L/EKncYO9t+25UpkCHcutk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385009;
	b=0PCOquTiZpljZwGJeFITpdNnRIdyoZQPlxdr9EwoSYlP26KFy2QW/ISxUN0pnzR0UD4MKd
	6OXyw9JIxITngSMTTU3/hThnB3dKtapDMDonuTK7raGLK6Ro6OhnKbxReVOzGHAJGAQZQA
	Hw/pTZdf462FDO+cki8D/Bnt21VeKcY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=BgCEjrnm;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b0d09df973so2295199a91.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794385008; x=1794989808; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qOHVTuC5hHIVI7UZZ0LVQbOrU8lnvBC2EJDORqtQwNI=;
        b=BgCEjrnmkwwKcWZWb2yBp2WmeYhxHOLgqD0bp5ScA+nEbogSBq7FjWmKoKgaXNaYVz
         2qkOKxs+OiIi+HW3PSH0Y6awkowfQRpE1bymYzjM7SczJXkOw78Y43/2/uET/oIkSGrC
         CTKRmABW9R/tEuVEBfLXwlvvm2V0NmxdfayrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794385008; x=1794989808;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qOHVTuC5hHIVI7UZZ0LVQbOrU8lnvBC2EJDORqtQwNI=;
        b=xiHoy03c0GCNAROGIcGzKOyJKgvCXVLXLOQt7pTBoGAmJJL67GoJQxyFBguX9JO3yd
         Snp+zRJD+OUugYteJ37vHT1ziODi1tvIJVuvTZY670xdOwsMpILKZ2nmv8H8CKsX3tE2
         XjL04iuuVX6tOfNOsq9i9rheuQ0cUwoJzj1LJQDZdYBDVKIu89RhpnJJ0d4dK4qOPmwm
         if19jbFxwm9NP5QHzy0PqlgunQvhD96n/Zn3wv45wMVNn5rjfaovvBIL9KEq4jYuUhmq
         TEuZ0wf7kQ+S//PSfnkvVcN352euVhgdsVS7MMlMekc88qb8F2rA89Zhr9aDxKI08KLZ
         zSkA==
X-Forwarded-Encrypted: i=1; AL+hErEV3wxOCIOsZK9v4dQnikWBqX2vEaW2vhR2xMeQ/OOgszqXTJ/lo8Tv424/RUBPXW86pjW6Nh4NnQ==@kvack.org
X-Gm-Message-State: APuU4Z/xG0m2SM8kaY4LeTYttWWOni+TCLs0ruR/LEx60b4osS4aVJ3g
	icQZbFmYJdZOpgL0e2uKi1T5Lcf9Kk5uyIkHTP++z6Pi4Bsii0X4dn8OmHk3261SCGY=
X-Gm-Gg: AYBFou2toG73kiXzXtjR5aXtG+pG1H/53BZ76nnvHVnKT/HiaBfjEb2isu46v5eO8jG
	5BZuSsc/+J49DBLX9nadFPta27Aa8kAxsU8SPrUtQroBJovjg2D0K43ehD858nbLLLwlWKVDs1d
	qZ4VfHKmVkCdXorIH48vAjrZ0WmBz4bCcE8m6waScolW6lWYHx9rToAPzaSyGZcipUy2fAaG8aA
	15AviAw0N9ARO/8TAbucabVLZXoVkV1ruigQ4hAtrEmLdt4SCptnVrf8wIRtuIvXkfcWdXqIEG9
	YfgjRVH0pcNcx/d4Oqds9Y99PC9Vzr6jmjbH9yjpeULShqCT5WaeBXpK6vqNlomf7E4i/S+pjHd
	K5VJkVpcsCTCa0tk1p0WH7o0SESML7WqKR3NhLiMI+Q8tTtwScNHqCK7hrcD7cKXBpQ8obzAhiK
	grzCx1FkfmjByKMFnpYpsWZwizC2hj/pquMtcihlx5NVjNEMhfdUq7dL6YtKsCyeHu2uR816otj
	GEr2zI1NNbItcZSrFUnUvdhuGogcLaAvuB6onIo/iABAQDmsCryj17nOB4+ENWLshEB1KuGa1kr
	t/Ar9ligat5e7Yc/i2eBMpOMUPUtfvUn57icbExV8w2j3NVNy2CAmyuJMlRt5r4QOO1iDWSC6qe
	nIOLdiawFgnDmSCKSOj5A4bWhXYkZd7vpjBD1vk3d9etuXtcqT853XXtomuaDsEM9J+QRWXsTp9
	ziAV41VRpFgGygCcWjkGCRmYYyxbPe/HbNjj48ouKmWhSoKypeuOjp
X-Received: by 2002:a17:90b:4985:b0:39e:6c6a:6580 with SMTP id 98e67ed59e1d1-3b182f3801cmr1550647a91.67.1794385007677;
        Wed, 11 Nov 2026 00:16:47 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b181fc804csm1360430a91.1.2026.11.11.00.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 00:16:47 -0800 (PST)
Date: Wed, 11 Nov 2026 00:16:43 -0800
From: Chris Down <chris@chrisdown.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: Prevent reuse of preserved pages after a
 reservation failure
Message-ID: <avQka0wY-EdLkspv@chrisdown.name>
References: <avQUquBK6cO6tUUI@chrisdown.name>
 <avQg0_jFY3get3wG@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <avQg0_jFY3get3wG@kernel.org>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: qupdj1emcds51emwtrh4reobdcjpdorz
X-Rspamd-Queue-Id: 070AA40004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794385008-598003
X-HE-Meta: U2FsdGVkX19NhRDDHXG2ZcL9Lmmf9WAqiJRpoJPS1q+DovynEE11/77uxNt/KThmrSZSd4NOwwi6yytDI0Cmg8497O4FeELTKagOjNHMZcNwwiZMXD3aY0yypMiMtxLL5tOqOS70/qhje5aMhG8oiJ4h2hTusf/try2rKZXQJNsxr2YkjX3vZsnkZBuMHigJpLQVN9J8hsoXZ4z45nJr1Go5RjxMrzytnbl/w0Gt968FkIvrJPAibA5qmCPr0iEJbMmvlgvgltDWzH/X1N9BZnF3V1kEG5FiJOwxS0VE7zkaiEnHvWZxEaUvZ6WKJCVeQ3i3ziCrZtJ1rz1Di3Ni+dgKwSQS+FnOlnOMhG6ceneoRGoKt8D/sa41f/slONQHrjc0GTzhJPppWZHHjbFmqLEIzB7YDpPmhtxRGlfpBetXYN5X3muTXp3IlWls9R7c6l0HMT1x3M/hQbJpspaGDAvtcorexQtAvHrHdDVV4nWW4Zw+wDC8dreJqY/tCmdWLHPV+USb81H+Mk/Pd7w7BqzR+FsMxKCZxKDHp+XKaiBeKRyjjXHCu4e9MFnxEQJnNjhX5bDLgeAzNNBtnuIqM8LTYTAGEALGWesomwZfX/ZM2jr2yuUeyhq0SMd61qOgVjgvE+ITA8FyRSArTkvE91U1NNLJ2EDhmvTAUKWpC5i0QIU2Bik4y6Ye270avbxmkrUJx5EepPHcuXot1Eyrde0rVVUVa3n1wF7MafH3iF2FDVuZ5d/LEOZeV4mFFhIB4zgaqnApawT3sVTVIaNscdrs0+wkm153zybAEBbH4oy1/4DN1cGFGpbA2x1WIQ1UN150b5T/k/dRbYj5spLdUwYwQTgTpmhBO2//Axq9CsP9JHIjP0CKt4ZIhPsGaYgpnvwLlFVAvCq4CyggU37fJQ+G6sL3YcrgpQ1jj9qPBukSAZcEDJwABPt3IUTZ2Ms3jFENUzb3PPKWokNA/9e
 ahHJEjPq
 IL56rzZRm95iJ+xs/32VTR0RFgiZL5YFzoMlfySJIejKrJbwTacpAb3nkgkRPlePLTg4XCbiaXP/g41GXypZBBYjmDONtVBIsDZIVzayFC3ZE34lcyEWErClbMKoPhox5YsMWSqn1fRoTKhJTQxpmkxv7Hf3etwA4cL8b6eT2LQBBbXIhE3cKAa4cEsEvTrkKD62Vi93O/IsKUXLa00CvHMfukz0QKOKoP3UYy1dauSE9LTANVd72dbcrjft0csJAhC9qV27+bnf1sc/JMbzKtYLq7txO4ekNSXl++U4Ny0scY88lValyRtqEoh3Zqvsjrn4XkrhgkQfnH6UlBgLzEhkYL/z0B36GfoHv5IMzjCh6Gm5v313gqCKP4u9De0sDBlmuF4zjtugJQGSKgo5qUAb9XT83y3/PviMJgPsyPb5nguNs/BdLazsqSYwsKf8QbRhiWeHj5F0CPkp7GdC9lgQRrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

Mike Rapoport writes:
>On Tue, Nov 10, 2026 at 11:09:30PM -0800, Chris Down wrote:
>> kho_preserved_memory_reserve() reserves each range of preserved memory
>> in memblock and marks it noinit, but ignores both return values. Either
>> can fail when memblock has to grow its reserved array and can't find
>> room, which at this point in boot it may only take from KHO bootmem.
>
>Is it an LLM analysis or you seen this happen?

Are those the only two options nowadays! :-) In this case it's just eyeballs.

I happened to notice this while preparing my KHO/LUO observability patchset and 
thought it made sense to send as a separate patch, since it doesn't depend on 
anything there.

It's probably realistically quite unlikely, I would think it would require a 
lot of fragmentation or a very small kho_bootmem=.

>> Dropping the handover at this point isn't safe either. reserve_mem=
>> revives its regions from the handover before mm_core_init(), and
>> relies on this walk to reserve them.
>
>reserve_mem_kho_revive() can memblock_reserve() its memory itself and we
>can carry on, can't we?

Thanks, that's better. I had thought carryong on wasn't possible because 
reserve_mem has already reserved its regions by the time we get to the walk, 
but actually you're right that there's no reason reserve_mem_kho_revive() can't 
just do it itself...

Looking at the code one thing we would likely trip over then is that 
kho_mem_retrieve()'s error path only clears fdt_phys, but not bootmem_phys.  
kho_init() then thinks that it's a cold boot and runs 
init_cma_reserved_pageblock() over the inherited bootmem which has already been 
handed to the buddy allocator, so this would need adjustment first.

So then, let me send v2 with reserve_mem_kho_revive() sorting out its own 
range, and making kho_init() skip the bootmem setup when the bootmem was 
inherited, if that sounds good?

Thanks!

Chris

