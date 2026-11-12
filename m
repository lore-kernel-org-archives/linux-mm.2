Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5C2606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=BIpJwFE2
Received: by kanga.kvack.org (Postfix)
	id B97CA6B05B3; Thu, 12 Nov 2026 11:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FA86B05B4; Thu, 12 Nov 2026 11:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F986B05B5; Thu, 12 Nov 2026 11:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83D016B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:34:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27942140628
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:34:35 +0000 (UTC)
X-FDA: 85427015310.23.054835B
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id E591840007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:34:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=BIpJwFE2;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501273;
	b=KiAGN4i9TsjK4In/3IXI3DTYPwrvHycGCq+Li88odisnbWg0phxM1FzkX4FTGBOVNHuzNa
	MCOo1XfwBk0g1Bv7flybvWWU1S6zUV8YnqUQfI4/LLHkjbWRH+7HPEZYDTEDLfbuaxnK7B
	EvbDMc1i0kgTlr05ZN1kpYolmJkf8FU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=BIpJwFE2;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkOan397muuCEgFMqk3a5KpizGYyvJYTBVZxmg+BXRc=;
	b=UZi2di3vI8LayLieCZFx/Yv6sWL9twd+vOJVLF+7bSwt8uZaadAV2Pl/jGhzOd0L1h8kpM
	c4apqrOrbYGp8L+1W59H2dZNisUm5iVAV2PHTa5bHAYrS89jVSKV6bh4ws29cEkArEpTCx
	bDqnUGYlcGtcIa7F86ESevCCcmx/XuY=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d28f75d62so119607366b.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794501271; x=1795106071; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BkOan397muuCEgFMqk3a5KpizGYyvJYTBVZxmg+BXRc=;
        b=BIpJwFE2wcZB5hdyFIrHxvE/DlJCvVVxlxoUkShMpkV0htV12xtdznFKuFFwKRylQT
         nj5FiHFti9ciJIR1+G9L/tFczjvj8KhauRGcg8A1kZFbUGg3OfyutSTJlfAAWq2kdejw
         6CvAfhUinakdyoa5pXmqk2v8IYj18S7jaahRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501271; x=1795106071;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BkOan397muuCEgFMqk3a5KpizGYyvJYTBVZxmg+BXRc=;
        b=QmlPBQvtX9dbo9V94CfP5NDT3lmYwuiKFO67A2+xaorljomUt4csRFZE9BxV2tT49p
         dh1eKbKoJ2gF4j1z9XP8BcwH4ROYM6lL49y0vCwNwTvLBSCfYrMxZgVog5WvQuEymHDT
         d4rhAbd2Jc/8nSdUVPntiLXai7513flc/zlLIk5U30tNxuOZUBRiZ8yp35ZhIuv64DdL
         xACptfLIZWY1Db5NohOzezqO01WABkJA4a+jfpJ0YiIE3oqciSS4S3AZHoWEXbZIQ9jE
         kJwKJk/4eMZT5178E8DkGc+eLgVaOfqNlYng65KyEGj7aSsPZhvnnFG8Vc5dIjnVa445
         1qGw==
X-Forwarded-Encrypted: i=1; AL+hErEtK/sngH+uYJPmNmESbjUJ7ZcSZWLMv3qEWskC4uUxXfzTdWBqcpJvMjould+B7FSkqBwGUaNvlA==@kvack.org
X-Gm-Message-State: APuU4Z/9Wm2PZR4jaU58YQTvRDAzu6zZ0914v9xlOevu9GBk4+VcgZm/
	krKZ+cKCKQXYPZRWGTaw2/VqBpA2qMd2tMIcqJWuzc40orwkADlaZd4D/tyWUmBBJUraKYy+VYT
	JiL8ClKIlzQ==
X-Gm-Gg: AYBFou1/wupJZ9tmsoSgbDTc6+OAjC/i1ZR6e9NgPOu7X55qlvpDDylKsQEuDl8rAfx
	No9fyVHfbofrCcexaGRHTHvSETAAtZMAhekp6tsqPUXhwyUmqhhdPk3L9gxuahjkvUAqIoLK0hN
	Wrv6eBp3xP2fmc4HkSqCawMYvEZEctmoPLBoSzEi6WjYCNqLJQxR3EqPDLHQmcNJz/33kQIue1p
	YT/qsUqv7M4qqgBUMA4D4pbb9lsb8W8P+tUuDJOumYvPfmyAURg/o9WDHaGqb/2C3pogM/p+Cnp
	6Iqo72oMVC+GlULouuQCm9vUU1MIBYaCtQKE1weCcmAulNpPo71ciGdmpvT1NfXPri3P1Ez4AIR
	gP5AQABLGPuNcmqsM++jIB4Wb2NIavZSBVZhyJj1pqYa78ayJ/GTsiZge8E0Ik+XGpPvQSeGz1U
	R3AwJR1bdxSMWS8zII+2tfNz5F6H2rbOOL0lyz8x9qa1J0Oh2uWXYH3AVaPu9AcnrKPt3VrHrHh
	cvtSNtCzRZaihT3OFALn1PSP+k/oEvFIfokbMxoMyiFl57hYnac86RzUg0ruepygHDVAJ/nalDo
	9Wv2ntzS5C5dxfEAvdHs46PpLEpqiKnqTGjjLAniov2YiiYYX6fvrAWyK3h7cdh0JHC+7UvUWzX
	Swg==
X-Received: by 2002:a17:906:c14f:b0:c2d:bd87:7fa7 with SMTP id a640c23a62f3a-c5066aeaa78mr523611866b.24.1794501271491;
        Thu, 12 Nov 2026 08:34:31 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a628c6bsm371837166b.56.2026.11.12.08.34.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 08:34:30 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d28f75d62so119603066b.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:34:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFgKcoFXd086yJ9cSzwjZ/x2OcB/NLg2wWJuKGXBwfk2gNSass2gvVCEYVua5ZCQ/ydlq/B1p5Rdg==@kvack.org
X-Received: by 2002:a17:907:96a5:b0:c41:e75e:5889 with SMTP id
 a640c23a62f3a-c5066b5bba0mr524017266b.33.1794501270421; Thu, 12 Nov 2026
 08:34:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260914223212.i.829-kees@kernel.org> <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com> <avWNCC3_Ff0knO6J@devuan>
In-Reply-To: <avWNCC3_Ff0knO6J@devuan>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 12 Nov 2026 08:34:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
X-Gm-Features: AclHuK9Nmkkll1Jqx8Ewj5iXnIEjw3xkEvFj8OVOVXeQp99rrxeYYFJHUsjvVTk
Message-ID: <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
To: Alejandro Colomar <alx+linux-hardening@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Kees Cook <kees@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dy9x9egiinm5zcctf93i9m88s3e9cz8e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E591840007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794501272-816888
X-HE-Meta: U2FsdGVkX1/Q+21IqE/l2cCvQDzuLdsh6LKLfbf0FwbEZNWRnAuYnNNs5jWFvaKCHpgGdlL6NtyAPnly5dph3/5wl35bpbDSt3/qzoybe0KpDKKqRrrvbNrBr1QYx5pImDK3yZ/vI2Mw2ygIxIrfB6GIxn4GUr3Ing4Mf+dPhzsUdsSDTIn1i5a9174ED5miNWS+Izk2YIOHwwDkfxIJA5XRbdOV6HT2oWV3sPCwAtQ0fQE1xZ1DjaOJCFhXALfA2RTNcvkKg6ZNR+jVvIhi9VVEhT0HpQ/DKCBjJDZbxrcz3h499U5mG249kLp2aq/iPaWkH7jXqikVoYKEhaqcMSZSWLLcoCsZQ3OCMKgCWXWFYOt/RqWyUZWKFWzgJUzHbRwePLOzP94feokFamHi7vMEzS91H+ucCByE3w3GmgNKHB/UlFG6g09fxQOhY1MG3J52MdZjT4QAfF5/tDxgbYHNp5gRQsIertfszTZIuZToQEAMdFznZvHsBrMSDtHpcQM2ZSNjeVj7dTtP1Qd8dRl192kBh9uWx4PhN8Rn7HSjiccPWHW//O3tjD4wwdShh24jCKxSAIvu4cGk/w4MHEE2El7f4TZBwTIG/OeoetxnjMtSl6Ihzvbbd4VguBaJ1EY+f/rr8CRHu27DVD2plp7nQjR2sdg0S5w38XJGUwizmIiWT5oRDqzZ8IZNveK9Y0UQ03wEwuhOJkt29+5mihwrdFf+AfU9fKFvwjUrJUAAwQ5KPxuDsnS4TZUIS7TFSKJDuDQPnUuij8RDFuxLxmzmxJlY9tljzUFszoqafxcsQ1S+1sz2E2CDh2n1sQAgs2j70jm2G8T0p16UytpHXrMF0a5SYIW1bu0Ca3a20wuCgbq2P/V1JT4slR3rzo6WJJO7NmUCMQyPOPVwHoIDeRoK2KfTDO8XY2/0wmp+K1raZDfGljkHax42NjQ77sIcCnV5tzHkGTvBnxExctV
 BdPe8haM
 VlaYD/yV005PkMtIV0U6MxFH9Ma5Wm8tnzY/I7jHARa1FzCAI41FYlVFPH3csEgsgtQQ32SHhK9m84yS9amByMsXLNzFvX6AHqRSeqK7E3JCjWh5yDzOyR7wtR4I7kGc4slPB43QzsdojKj5xk877tnNcNlFb838/igkecIDnYTBLaNPJT7DqyOZdTceoDLr23JVfqyfLAGQKpFqD8AAAQw+rtnXAqE0T37+NedCGRFXwwEUerF6wl+Wz9/hfGUX2utqsdqEPMXdEBImPP1ApqS20w2ZmNdREgO5fjw0xbd1IQ+54NRAEIig6AAwdBwgJAOI+UE2Vp/yI0y6qwDP5tMxhtinrVksITrF7eRlJTP+Bx6/h6UgEDwpCogtQ9zMqzv91VVW8K6kz4ppApRKfV1tikcB029PM3pque+lZvgvj/P3q+t44HQUUKcC5zx1LMKsT2uZHdi38qb3Ot05aXMwQL3wagcJH8bbjgS30BYQCSsqUMwVt4fhCtGnWW+RYerM/O97NNxROat4MJJznldn2qUVthbrvuCP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 at 02:13, Alejandro Colomar
<alx+linux-hardening@kernel.org> wrote:
>
> I suggest removing kmalloc_obj() entirely, and using kmalloc_objs()
> always, with a second argument of 1 when we want a single object.  This
> would remove the risk of that typo.
>
> I also suggest having default arguments without variadic macros.  The
> way to do that is using empty arguments.  Linus complained that it hurts
> his eyes, but it really makes these macros much safer.

No to both. These are both "make the code worse to catch errors that
the compiler should have been able to catch anyway".

If you *really* want to catch them, make "gfp_t" be a 'struct'. That
way even compilers without things like the restricted types that
sparse has will catch at least that one.

I did that many many years (argh, decades - I'm old) ago to catch all
the 'pte_t' etc issues when rewriting the MM layer, and it works very
well.

It's going to be somewhat painful, but ti might be worth it. People
who only use GFP_xyz flags to pass them around wouldn't notice.

            Linus

