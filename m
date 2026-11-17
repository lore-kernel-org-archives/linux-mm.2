Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C58606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=UPESxrZ+
Received: by kanga.kvack.org (Postfix)
	id 8BB7D6B05B0; Tue, 17 Nov 2026 05:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8932A6B05B1; Tue, 17 Nov 2026 05:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9546B05B4; Tue, 17 Nov 2026 05:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5762C6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:10:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7F17A03A5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:10:21 +0000 (UTC)
X-FDA: 85444191042.12.4C1A85E
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4FC8140007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:10:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=UPESxrZ+;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf09.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.49 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfBMXtQzr2JQHUojf4ewtSOsAqE+X7FzRw+q2BHepVo=;
	b=lH7QAecMPSCkk3fxm9DtGA+nLxLkOq8eNLuQdnpWwEarSzOW6dt526m+gfDmTNwynW3j/k
	ipOvJZGjkNm2BByMeADmW0zzGOjTdLsYykRmseSEULBsHniRlGuR4Wz202i0agzMuXzEZP
	d/wALmvLv1dXVVlYXKCEUksoVlwQg7U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=UPESxrZ+;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf09.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.49 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910220;
	b=EmLsAY6uoCEaMs1DLp+6+W968kgET+gYVN85vcOlA0BaQZ/FxE2Zw3oVtGXX1QBye4rTZM
	5K+K8aPauyFgwX2NOX0E/rNumdbCaVdwcozHkTeS9yvVPycupXwh8qIxA9PUgQGA5s6ETr
	vdo0wPHVMVUoBSYsRFmDoAzGdRdjsb4=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b3bf3bef9aso156523a91.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794910219; x=1795515019; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xfBMXtQzr2JQHUojf4ewtSOsAqE+X7FzRw+q2BHepVo=;
        b=UPESxrZ+fF5igYwGUZoqa6pNP6cejGXyuoJ6e/2ImrUUwnXdlpuu2h5zeBdrVSnfBn
         JrsnhjEUG33VYg6+CYgUT7FFb0UhPiQaZSXSTyiWx8n4bwUF0s5Kfa0T1zVdi9XPc8fD
         1xXfqJLHgjvsl8VfuHxi/LvtbApI7AmuB8z9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910219; x=1795515019;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xfBMXtQzr2JQHUojf4ewtSOsAqE+X7FzRw+q2BHepVo=;
        b=I9h6ra4sJYEQNLkhfHDfWzhnM7ITPMBtdUhBf0sOCmurJgh2+mscBW6wE+ZVT+x0Xb
         hZNUTLbdfgmuNOkCgSjtZUSpVS0VrQz+Cs5wPDi2MXHnoCaA405X3TgqLwHowf64Kc1l
         0LSEhk9AGjpvgd6yX1nLCpVw/c2IXfrw/d/E1F2HgY/jLkCsK74BOlTJiFwqQW2Kwxsd
         rfpMDGkT6jINziL2U9oyJKU27/CbQcUpOasGXk1TLLngwUcXYGqScjLLFOpGypH/A38a
         mr0gHzr8FYeN1mOgmo0xEj5+2RPEbrhnVH4S+lW74x83sP6QnELZKCgD29iKtPoNFhHv
         Gn6w==
X-Forwarded-Encrypted: i=1; AL+hErEeZnVfOvzV9Wsui0XAlrTlhdhTRp3gll+bHryFnu8ZUhvzTKLBvaAsW5No0O5E8gwAuqJkhiKddQ==@kvack.org
X-Gm-Message-State: APuU4Z/Hxm8nbJpnnCXYA0lwr0/HAs8ZPz9PN3rXozlfuPFGbEPTNMCX
	+udQJ8Nb8EZi0TFfTXb8+HVjod6zjWMmehgc9qOxZ3+V9UpAePtgSipctCyvEj1AbBY=
X-Gm-Gg: AZFdTZdniM9W9QO9z+fn2U1oqY6UuT6QQJMGDvaQ/c3ibyCmZPUwRTTDvwaMdWs+aOg
	aq0+MMMTALabhtVyEDEPuL9KFtrvtnQPTkN+os/IgYyC9h4T7eNp6JYxsNEF8L472a008IDp/5P
	xErrwoG0V5RgRWZmumz9S82scYZWBpkRk6/MtDr2V1/C5nUZQi+uOP6jqM/P+S58WEDCMs4ihr9
	qkvNqrTIkQ09nR5F6TSzEiOAfQ/klK7q+GOYqfsfzw97AN1JQWRwr0eU0Ss7V+JlmpgLr3Mn0//
	BwIxgE+0hAEyyIFaoUuu1qysarIxQJqaK1SmRzBwh7DSghqmhbEIvu8FM5la8m7EJZ2LfYNywMr
	1yRG2x9QqlxSYupz75lmPUOXqGolbPbWBfoJnHs0QHYH7XiJr9g48gw4j0yF9LQA6bKWWgz8EDs
	i9KwxBgOUuNjBXn/3fCDyb8OPpanadhu0Hqpq4dCuk37V2np1uGevYVW7+H8K0OwhCgHNPi4y6s
	PZnTEZkLYBOuVXnGRRgqc1SlrQbMusZRFTA6cVWd9lRblkVj+/Hgck5D4AkrR371UNmwHxwhzgh
	cEWhJhRP2TCB/JkPNBWC41RfatFcoXBzsErqTemCClTR1Sa4zO26nEIH9MQMSM0dCUUAhuhNN1f
	fgHLfK6cmbygdSU2fwGo7NQQ09o3RO4yAER/L8u7/MHkleVagLpu27YoNrJvh3v65XlAd1FXX8V
	OOu0knTBF2tUy8KZ3g5Md7arQ+NIpzyOwsiAlvzptYuHqJ5bfzD1AiZkKAofIoUc0e
X-Received: by 2002:a17:90a:e7c6:b0:3ac:d79f:8229 with SMTP id 98e67ed59e1d1-3b1b0d55ce6mr13140816a91.61.1794910218659;
        Tue, 17 Nov 2026 02:10:18 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abbad970sm3433447a91.4.2026.11.17.02.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:10:17 -0800 (PST)
Date: Tue, 17 Nov 2026 02:10:14 -0800
From: Chris Down <chris@chrisdown.name>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] KHO map
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avwoBj5ceKYjcS9G@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: D4FC8140007
X-Stat-Signature: ks4obfigzc37jna661fax3rp1j4teqop
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794910219-609743
X-HE-Meta: U2FsdGVkX1/1x7NQEPXzx7zOnn9+wYd43wEtfFkCU4EO+OqSvrJtVnt3BgB+ZUBUZkKh6tFHEvVpkYTMy3i33O5txOrkRUUuelv3gK993JFIAuxxv4ynaxRLeJ2xflK78G3YAZiluuYuKkVv4GpuMSFLlJmYFv4pqiwNsQ8iUP5T8+TyZtCs81vb+QXZkDGDrHoKlbtlbHodsVfBVkv0FZIoX/HvE4gKFbe7RgxSx6EcxYszr2DPGifX6dMop5CoePlGp8okZ/w2bSIEa0BH3cGh5gCmZQt+vQdhuCRIlt3g0rPb6aYjlta7UDp7D8hsV2SbFrU50JLm3SVDlyDHsP6MewopMx1f9gc5rTjgp8m2r3IftHblC1a31XKYEexa99qppT7wUXMPsxUqfadnnjtE1zqDyQT2Zg0/6gmWd6HydmQTQkkP+qDtN+h/3SRSHl41akkDittN9gf98IS+6i+e6h2/5noiiRBaKFQCMPyla1olwhJrww/oyfgrkJX3Rq3KxECsmr78YD+wHm2wCKxjhwl2ujOjARtL+SuqD5m7eQd201i3C0zdXQBFQAnqYSDeGzgVCRq0iL4GOiKYEOZZVNgm2qhFz8cxbHIviUFrG3e/p/V4YIM3rk63xTM0LVuIyfoLtGCJOwOnxkO2A/lBOsqPxG6JwNgVK5LtrMIRpV1KX1fM0hhNphUriuhCPY1A22Oahz12jHPphplhELvPWFWhhwsdy5DqMqjueQIfivHLI18Fe6MCiqu87Sg3bgf26OMPMqKwiuq61T4lExzA2tP5NXISyghAwguFoRBAKBUqPzJYi3ijHvVGNUrg4jp6cvZSVSxIxIz3oSHvxRxyY5bgiyP8SIZ0iWdpn1jyVab3kicFlwRddx41JYLQj5WsRTDvlIlFuWTlVHt9t+U1YJoXTs3j++/CEN7bLw6XcA0fpOXtByU+oS5L0NyZhTkPt8BBtINCEb9Karp
 /EUwsrtz
 7fLWAdy10kN0mS7XgCIVFQyPO6lHZad4D7EI5KoqJ+ztKQF2LQTPqgBLNcb9ff1gDvGGIEsz4LDZs3tIY1HH9mczD6fzlqIjlz+XfJGGBCHEVqO+I6oPJ5qCLW3B8nrTf1BuYcgST/YszYEh8vvKLbuXMvoJkNiiIVP9WOP6EeGycMp8sLAklaxvTL7tZqnCk2kqqex2r2xeGP3HAxHs+Rpf8BLtTGm0quP56po0/tPlk5KaKhx/hmw1nSRQDOV5h+Lgmr2eNwsWxGwBBfjo991zX7ZaDUaZj/ysvx7jZy8fP12hYtOT5Slk7XCy+/h4xkgiMWPRdJrBcIBrnoO+XC07U2nIPE9rmwJJLDlOaCDZdcdm4nKUtaPlvj68YHsfQGQb7FpDmHx+JnRpqBFcpFEdXIHdU/69GXoh8qWhaXU9CZ28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

Pratyush Yadav writes:
>The main user of the map is memfd. Currently memfd uses a vmalloc buffer
>that has a pair of {index,pfn} to track the folios in the file. That
>uses 16 bytes per page. The KHO map uses only 8 bytes per page with some
>overhead. So for a 1 GiB memfd, it uses roughly half the memory.

That only holds for order-0 folios though. A leaf covers 512 indices, so
a populated memfd needs one leaf page for every 2M of file whatever the
folio size, while the array needs 16 bytes per folio. Per 2M of file,
that works out as:

     folio size   array    map     map/array
     4K (o0)      8K       4K      0.5x
     8K (o1)      4K       4K      1x
     16K (o2)     2K       4K      2x
     64K (o4)     512      4K      8x
     2M (o9)      16       4K      256x

>- Multi-index entry support: currently, while the map is very efficient
>  with 4k folios, it is horribly inefficient with 2M folios. Each folio
>  in the memfd takes up a full page to track. Multi-index entry support
>  can fix this by tracking entries that cover a whole page in the
>  previous level, similar to page tables.

Since patch 5 makes things worse for memfds with large folios, I agree
with Pasha that this needs fixing before memfd switches over. Storing
PMD-sized entries at L1 fixes the 2M case, but mTHP sizes between 4K and
2M would still take a full leaf for every 2M of file. Do you expect
mTHP-backed memfds to be preserved? If so, it's probably worth handling
them in the format before it becomes ABI.

Thanks!

Chris

