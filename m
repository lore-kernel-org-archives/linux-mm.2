Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D46606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=BDeEApVH
Received: by kanga.kvack.org (Postfix)
	id 7C9016B05B1; Thu, 12 Nov 2026 11:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779B26B05B2; Thu, 12 Nov 2026 11:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668906B05B5; Thu, 12 Nov 2026 11:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2D86B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:13:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D64C31C3BA4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:13:33 +0000 (UTC)
X-FDA: 85426962306.10.6D8833F
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC20F180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:13:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BDeEApVH;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SNlzExwuTi3WbPB+pJy/Rdg9j690l3UVVEipCGae4g=;
	b=cLs3DneYkPua155s44ZHJI5BL8h3X4RjmxIR0HyiPNScn+5LeA396sghQAQTr4C8HhxFhW
	qXuxzdeOUTwJNiDd/Njmh8+VY1fFTTyca9mJp32d3jPaeS1bRbDXVDqRQM2tcBcureybVs
	25Pxjb6W6grC0tr6GpkcSKY6gru+Taw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500012;
	b=gP0VPXCoLTA4qCpbX5KWYUsMdG2mQIlsLmpe4A0BA2aZhWcz7QFRMnRgUjuJ2LmxkOcRNj
	vilnphUQvXBVJq8/fkDw93Wa4tTuyisX5gAF1GZk88unfc0YHNSIQf2AoR91OhXWIiQSJW
	KPdASV/RWFSfN/41XhgqXdueWK1/qaA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BDeEApVH;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b0d63f60bcso187777b3.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500010; x=1795104810; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/SNlzExwuTi3WbPB+pJy/Rdg9j690l3UVVEipCGae4g=;
        b=BDeEApVH3ipZXR6AMtans4qG9UCTivsp+3jFXhKz8ZKt8xgC6GaC9F8nOFGkU3vAEm
         553eIRCSKoQkwMHT07k1FzieY7hpZu05H+iC+OJhhdkBt9HCMgQaW7D0AafcSU6CCbhg
         oV/ecZYeMT+S1k8xMhTZ5aBfl/BUW4Llx0IDFpiksR5xlcPRtmMgxK3if+xzmQWKx8Mf
         FSSQuzflLj0AJeBHPzMtxiiNCn9hYaMdqDojfSVXrZe8sXgvat7ChHLCSvvNG3HDQmwe
         2lgTCZpqzIhVh6gVJEyKp+5h2piO/wzXyWNzpSP2uCT+innra6KAyjzglGEv3IRBumkh
         o6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500010; x=1795104810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/SNlzExwuTi3WbPB+pJy/Rdg9j690l3UVVEipCGae4g=;
        b=IDjpCrxPj7YJ1j+kbxHqs+zGdbeyKgJlj3CQfI09eJR/tcQwO0z7n31lvK4uc8v4WZ
         zGfMNZii0F15g8qY53VCraetTKSDmMQ1m7y5txJY+UiO6sKLeBZ3n4wYam+8piWnRhCN
         Brd6YGUH7LcWKaeziq8bsGy94zaUceBaj+ukK1ML3GPh9KJu9j8ShEVibsQo2vYwpf7I
         QgeTV5RXUlvhydGXDulY3CULUIdwMiKkBr3uRoFI/eZnA/TXPZzhofI8BgtBGaySjH8J
         8C3b+vkFbZGDp+Dj/oNmxUJch4S4AalmtGO/9v/A6qW1iuVKJe6/9VlJLuSaYCzv63d2
         jUHg==
X-Forwarded-Encrypted: i=1; AL+hErFQGmw/84obgQC3Ifc6dlYo6UqZEidNyxVgiJJ06nd/L2oaXHDvv8KxgifsM0gq4hsS2OzIH1uXoA==@kvack.org
X-Gm-Message-State: APuU4Z/O726nQlZidPQ4OCIw80bLwMWB5Yv5Lx455xnRldEanFUXFAZd
	xMVzPn+O656dx74c76l3rKSJssQ210TYeCglIHmr43Soj7NVCPu8CShoTHzESYrYiMw=
X-Gm-Gg: AYBFou11f7bRBVvrNHEz//PogXSIz32zSusUmCDsCxQq+L0KrAzB+qIBFk+FLRgC1HY
	w2VBXHFncBqm2paXky8XhCp+WU/EExFYbrWUAHSUCmyF/vqVM4+oXGrESFemXDVKS7E/jmZbEz+
	d9MrLZEerGfW2pLfCt7nS14B5CNErz0tffsbwXpHyOXXrzUwxSlm7IxwuMm7QbFnyH7vJVQjWU0
	olSIpzQE6qd3TIwiHk/vPr6p2rGVIgM88OcoSnh6Lj8pOjev8uiNUjXwooJmNBIXjLl+qgWt+xY
	+y0KS+uLfW7xfa55+M6bTjJzdBj1CksfEqASpiGryYoHOg/V8F0OZf+NbeNXN7e6OnOmTJ9QLX1
	gp5TcaWUQbcD4LGsXpHPtWvxw/+U3oNsegH02m0kfQmYvYr+aPoO2H94Cs+d6R7UYLwjfxNRHot
	O2lhdZhmhtZF+56FvZmypNfNh5eye9lEdmrYpH3X/XXUqeH8Aqx53f2FLY2EFmCBDPbL4l3E9lc
	vxnDfZkonWAg5WXfII2daIydtrVyKOrm2lCC+0X1jThsASpbQVaP8RuGi2fzGTZh4q+eAY7GS1k
	BTENDxDyCN2pkBJe1xRlTXVObUS7
X-Received: by 2002:a53:d711:0:b0:67c:1557:7b48 with SMTP id 956f58d0204a3-67c67fd9f14mr3153613d50.64.1794500010621;
        Thu, 12 Nov 2026 08:13:30 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b393409120sm73138157b3.27.2026.11.12.08.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:13:29 -0800 (PST)
Date: Thu, 12 Nov 2026 11:13:25 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
	Balbir Singh <balbirs@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>,
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/13] mm: cachestat: count each page only once
Message-ID: <avXlpVZTs5_ytZtV@cmpxchg.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC20F180004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e7ai4oybfkdhhkbmndp64fhhsskegoxu
X-Rspam-User: 
X-HE-Tag: 1794500011-27943
X-HE-Meta: U2FsdGVkX1/POuBmGSuaVoL8OX+fDBDJREL13L/Ixpf2aVxg4sTVfWblRDO/lrQiXmguOBpdlgCgnD0pugpQub1RzupxWZ5EbSGaWXhomEQUTPqNCjrSCGTXH7ojkidMag0RTSK0rD2deSQFCtAbaLYlZQ6nqK6bp4pJhe2lqL/20vFPzZHJqoMTYe+KOfzw6vh/hkpip66yzKn2Jv39Pd/WEHfPgHq6t8VA22sqJurAp4bwsXqZIPqc5ZHbQqJnC3ya8RIK+8AvbCP0fiCwpsSDmbCcrU8WaNdLadY+omNqRSDKG9EfHWf+vh45F+2m2ITfGp0jPNU5SnAIPdCtsJhOuOODDZV1hw8InswnQiQ65b1LM8seKDAsSMbEd5RT8BSOTA5cKYwhH2nuwFcYfih/iuHZDPP57Wh95tHkEAG2CSRJyfiNGPTA1mR41E/0Y6EWqXme/UUY3S7aQ1qbk5h0pIZLtw5p7z048iR4P/a3JiXg8xIVeNcJb4lRSr7KrcPOBvPV/Re2s+EHI+8C2UilFbMCYATR0CTq8KB9HSPuGKIJfiKnndUdneRfDdv5ClyY9/ItqI22zUyu0jJr1x0hNVhSxw2bkimDOyQ6IsP7rtcxoDFZZJ6t3tGXkBEKniJJKRyY/atbrJ5AEqR6X/wudxZSq+r8PauGnVYwR4EbC943MziqgV2cIeEw+Kov5yXopXXUhXaCQ/IFtKv1irYfThAA0xAd6Suh+l4ioR5e85HGLWNBq29GEuskijY+bKAquGkNzbfLocFFl4OfiUm26yeNuZ8a8Tj5uCRwSoBFemW9uY8jG+pkrkpbyzFFZSOwEHBll+tj8Q9ToZZgxbai83L3R+6LWq6MTjAPPkbFSd7t11B3DsZ3t/O5SOMEu+2WF2QgfgD39DKuKdkHvHMKMyl4rMArh/er0cj9SWqeXXzrzdNAj9Wb2lpLkoQPp+9fgJ8cgPDRm4ff3lm
 /j5qS07i
 VEGG7y4IxeO8hu1hJ9Z0xlnMwDZSI5I+uHU0Ud4z18q49rAwCWv0BLzeROuyvQydXpIL0EgyjDndQZtWma7NNYRMAepmGe7h4+lteDP0BdX/xEM13Tqtob90Eb9qvtGtOLzfoIvPpbqNQSIFAfmI2vhF6GxsgP1FpzZHhGmM07jtvp3WfQrJOmYzSFKDU8rmsM1A/QYdo59rJ/CFE1T/IJn6UE26zGtWtBLyBG/3q0ERGvWvQUQKTRHXc3+NqtJKRseANC2Fk7A4+mV7cUgPx7CAwyBtcad3Id/DXONK1bRb1FV1f0n5l/7AnQAJNxiJPWaNsGkUuV8pYM/NUphy6MFhWuJwuowIMWOts5zklg07+E0YISEmfuVEERoeyZalWK4NOi7YDPEQfdf0sXdKm6N73u/Q32gUIGPXhGYyw1UkWOFDfVEL+yeYc4ALyQmTgVvFLbwt2ww/PvRNIx+0LYzV3x2QlfXYpl59GsgQYGZ0vkg3XDcSUSFbabLktqM2tnToI458+0Ku3p0y0pxxvXHOUeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:16PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> It turns out that filemap_cachestat() can unwittingly return incorrect
> page counts, if large folios are present.
> 
> This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
> kernel if the input range starts more than 64 pages into a folio that is
> split during the call.
> 
> It can also occur due to pages after a large folio being skipped if the
> range starts in its second or later XArray slot and the call reschedules at
> that folio.
> 
> Finally it can be caused by pages being counted twice due to folios in the
> range being split or collapsed during the call.
> 
> filemap_cachestat() walks the page cache under the RCU read lock only,
> and for each entry it counts the pages that lie in the range. It does
> not track how far it has counted, so the counts are only right if the
> walk returns each index once.
> 
> But a large folio can be split during the walk, or small folios can be
> collapsed into a large one, and the next entries then cover indices that
> were already counted.
> 
> Resolve the issue by tracking the current index as one past the last index
> in the folio, and explicitly using xas_set() to set the current position in
> the XArray.
> 
> Additionally, add a check for folio_last_index reaching or exceeding
> last_index and break out of the loop if so.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: updated to use curr_index, fixed comments, updated commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

