Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD14BC5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6FF46B00E1; Mon, 17 Aug 2026 10:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20FB6B0166; Mon, 17 Aug 2026 10:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EDD6B02A4; Mon, 17 Aug 2026 10:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5DE86B00E1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:42:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1647980790
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:42:06 +0000 (UTC)
X-FDA: 85111026252.30.1AD8D97
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3950380005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:42:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M3bgo9IU;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786977724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCd/GM+SB+20nc87cPYs8vSFqEi5EzWcz9k0G1zmxpg=;
	b=JnKj95kTmk0HTUKBzekGP1yHohhgYwo8s/4KjbaO44b5IbZe+db9c0ZK4EudSNLbG5xz1g
	Ru0XU/XERvRmNJ3wh+9/7Qg4dvjUM7Av93wzqRYJXzG6EbeUc8liEweTQNLOvAD6GMGzen
	epNBiF7QmOfz2o7EuVwglyB7MgUW6GU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M3bgo9IU;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786977724;
	b=ew2qOOglhR9vtsw4eONEO+7L7knZd/mr+C5yurrh1r+9+El+ieaGcjdRxCGAocMNeXA894
	Zhx8Iq8VTYaXiZWnUYUp2gSWZ5FK6anak6mUDoJmRwu6kpOipAQJsTdYIGrwVxepzxqUpp
	JlH6/kFei2I9ubqnVVvjD4fF/luOH64=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e6c4a867cso210871085a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786977723; x=1787582523; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BCd/GM+SB+20nc87cPYs8vSFqEi5EzWcz9k0G1zmxpg=;
        b=M3bgo9IU70Pr5Im77SB2l3Yr1b515ND3nvKKYhf47aE65eq297xSSh0PVb9pX9kUyq
         ffO3Vd1sSBP8uYVk8v0PRbKqupUXmsa8piSN5oV2X81gBivwTFLk8Wq2GrHaXrJtoYHn
         L6plZPPbyVAI/UQ0LMxvgZLY670F9+/ypxlQQYsc1StG/zG5FdJUmxnqQSdXC1ZjIk4x
         ZeSLtK2+I+jsTnsKRyUpb3VLII8TK86VBZaMlXdDccb//YgI5MXFqDdZCfDx/f5Cez9J
         CPCAUvIG/neQYTrjlUU6TG3iz0vigTODSATLdGEO8/s9V9uaxdcvnhABu151MpUgJK3u
         DBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786977723; x=1787582523;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BCd/GM+SB+20nc87cPYs8vSFqEi5EzWcz9k0G1zmxpg=;
        b=PjdFVqTVi8/i+iNs2V/ig09JzIfqLjVLbtyqdB3BKXpZGCTOYy1zc0VXsNZsUjAB41
         jjMEFzeHYbla6B1+sA2+WuAanzaP30EkFwgI5pM2BKP8daM86DOsbZijmwBLUByNH1b/
         GYt7CgPFgIKM8j5XHzRYLnr403k9v7i8HJQq1DKuP+jwPtzku8wceX1pXLE3dXsifYLU
         8iWSpwCKpOboQDtK5XWNy5o6Pd3lyfWyzMRJB1UbXVxBSLyCOPhSZ5Uda7dLTywrpS+M
         87NJWBw+ALR9JeTRnUiw7bmk5iu61/pXaIl5ODG8UTxQRwbjL3ReMRHl4hPwmkoLXuSS
         Y3RQ==
X-Forwarded-Encrypted: i=1; AHgh+RozlPqMZiNdGcEXdOP/oKsUadI0Eb2exIalPS5oSpHMXC7UOEavSc5TwXcBN3MdnzyixzVe9Oc2xg==@kvack.org
X-Gm-Message-State: AOJu0YyEVNmVqwILA49dvcLp+4jvZXwbdw4Gakp5kDy3X/GjKbU+Wy2l
	7gM3BJxXaqI0ZXuwX9UAHWbitlptjNaNswhQy4I9bZQZjbN4B6ZMG0adEgvyA8W63Gs=
X-Gm-Gg: AR+sD12s4SgkWHuCCA8iCc7znZ0c0T2dY6q2366/kuFxYYub9Oh4LlGTdW4YmDJUppE
	0aMfUrFbvrXZsl0736ttanlFSxnJeSvCqINnPiTPL3AG17S/Ib9Brf0YCZxcr9pPa2/Vgno5YyO
	yWPIYojGjuctxVl+xCRTmsoxkzMC/xa0WTT7p9wMB3xpaXwqjjozolG7e6H6+iIMX6krl0qNrdS
	MijbbT2QKenigBf0L9pC0hoYxzkePMOBIGmNDZ0Bhe01bIOfIJJklftorEshFO32VJDfEioYR0p
	+w7Qwwv1IDYyJ3gox3GDDM91elYNbKpAh9NnlDdBKAxfZ9JE6lBE3ij/wWl8ueuE1q+Yv1SQH3/
	93RP3EY6erdjAGBD6C8YbKLGjQt+4tzoHN9u5btGwHQqo769m7mN0gls6oQEImdyO31NoV8Z40N
	wAlYdShA4Ouj0VPbDfarkYH7aR3apbOJgGGDZ5nQtgm0SMJdfAX4Jwibx50USw1az0374M2Vf63
	zXnz1F2ATgpH5kQ3IWLla9BO/1iVZopB9xYvOF8+RHq
X-Received: by 2002:a05:620a:2682:b0:92e:e695:d622 with SMTP id af79cd13be357-936d22ea6bfmr2612870085a.28.1786977723026;
        Mon, 17 Aug 2026 07:42:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937010c3785sm100435385a.2.2026.08.17.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:42:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 10:42:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
References: <20260811162642.3504565-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
X-Rspam-User: 
X-Stat-Signature: n1nxdnxkjt3d7iuiwkatbb73qcd7g3o6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3950380005
X-HE-Tag: 1786977724-648445
X-HE-Meta: U2FsdGVkX19ZRGxeThnauHdexoY2yFPsGCBI0y+mOBqiokIb3L8A0Ze6TaRuSMyX1wvslT5ly35PLO8C1cRjD6YuKsWtp02eDOfBEg50vvXR9FEKe0oVjasKLyyBE5wt9HqrT9yzXLGOikFIq0sMroifGGvPYGBypRDEeDkxfvA1OBktCoIHs/mQYvvHwRGj8Kv3UX7zzVruPFgxbcXlcHFUf1FfC0q6sNLQfcrcrOxVs/NlZT5TmqlD61hX1PnR/Se/BUUFPYn5snpsm8DrNLXqRq2X/jM8StSdYMk2VzB4a3KnpRls2Ri9BgtwviefQMh0Z1cQ/NMJE96u9b6ee/4RO22goBC69QtvSlfPRU9NNZw25QBbHyzUjjczogkXKfe28k+Z1tC+22TLe5P5iwLBVrOEu+zlHTFwuQid/ylvQchqs02l4Esog1OrKe0lBDgiK6Q7R0mX6cTZeefwgYbIFRgvX2sT/1NfVgoTjjPEa2UexuEBztx41l7jJdbotOpMR+UI33fp3T1JFIrWFigNjCeAq4XVj9HNLOS9Vv4GDp5uCxt7RGCoU4+bRN8JN/dbFPj/NR2y9LWgn6KkZcUJw6YjvFInEJOuG1M2UQdeQBeA6qhxSyL+IfQEYJDNBAhkkeva8mFr3Laype49oYpKXBB4fy9xIOyil0qTNUUcOO/RCRZaxuQDmZ2RFsVMK4+nEI9rro8nUve8jf/uld8ax/3RN70MEpiX/f+yE46g+bVILfwQr73f0a3zYnyNNLmyvUD7sw+OGNtWk1x/0KTbzLBS0tFq+7fv7pvrNIIjmJiP6XoLoTkVl6ahLGNm9NW0HNwWWWpJZk7/7w0OjEqVGieqUxZuEv8xzsZsRuaRLRS8ry8a7qKWtgcYHl1VqxAZpO0TmrDIVMVT1OfBl+xHdW9dZHl1VlMvElF4WBUhi026CgN8SVw7k3zGhz9+J0w1iQ9ovT8HtQAvd8I
 Boco31qU
 8lxn/0WQV+F7AQ1uG9i6cBd2EhNPnLZJssbQ3Li2DXf+u291AVQOCrMPobE4pXt/2grCYX5BKO/+R438M4nbCaIOrbFnp30ddD3LaMTs1P5MMXwc4VXIcTzy+Vijl5XPLtaQZo9APH6GSr+pM/3ci2pSaDqcds/Jg2IzdArDRLOdw6vvgIBjiZWTv9FeV+u9cvuCgC+dbpGloqvLGcrVy4UChzqiDEMb1IHM89nd60Z4m9jmOGyyOQ5dbPIVnfLAzkPk77bQYeASonWY4ORF+cslnnEJ/TFEaCA1HZM2xAA9a/M2gLOdAQTinfvfSrwcw2T3RGvdjUzA7GEiV/6xJcfT5Xxhsk52f6giD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The term "KHO scratch" is vague and overloaded. It does not accurately
> describe what the memory is for. This was discussed previously at [0].
> The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> is memory passed by the previous kernel for early boot allocations.
> 

This seems like a lot of churn to just rename some stuff, especially for
a term "scratch" which is very much understood to mean "temporary
working memory region" in common computing parlance.

The boot param name change would also cause breakage for existing
systems that update and depend on the scratch parameter.

Is there a non-verbiage reason to justify these changes?  Living with
"scratch" seems better than potentially breaking folks.

~Gregory


