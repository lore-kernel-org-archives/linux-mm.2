Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893B4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660D96B0098; Thu,  9 Jul 2026 11:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637D86B009B; Thu,  9 Jul 2026 11:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E8E6B009D; Thu,  9 Jul 2026 11:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28B476B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:50:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AE4E8C7CF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:50:49 +0000 (UTC)
X-FDA: 84969676218.15.DAB4393
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6B8718000E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:50:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aKW3ZesJ;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
	b=06vislpb6ZorBYF7kvmrtYNVQbGZ9JruhGWaaHUfvPQjzvX6QaBCZayEM1MF5xqu4AoYz6
	yfNATpcutY/qJm4pEcVht/pv2F8XeEq9KjFtgkEeNuPV7uhFO6/PlbIfxo4uwgu7cVEEau
	X+ybZzepp6W0+ntRCbr7szeSIEtrinM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aKW3ZesJ;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612247;
	b=0/WpTkyfQwzWV70iEr865zEjvNBEIg4VSrLU5a7OAo7IboKO46N/CKLGHjH1NIr4h6ajlZ
	w7UYZqA9M1YqYWAET/ueJ/UGZNWa6QQeQX0wiPa1KOtDKD2nIwNlQF91BuJj+bdnVJqNDb
	omUpvdWxm/95vxH/RaR1rbuXKjEpqpk=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c21495722so9129821cf.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612247; x=1784217047; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=aKW3ZesJYDp0xemGUk8GgHYTL/iSUG3rIuPMQAgGIb8Tt2h8Y35U7IRsRBYMkYg0zr
         XBU3+aun9SwjhH0RtmnfThG4so25QSvyaVZsYrconHTtqEbwxPRZ8zOeh89RzXL1mGs0
         b02zMA7b7WJ86f1Wo7Hs5QuCKD3o0zWZGwZgJHh7i/mbKVxgtb6/bDZhjNWkZvH3Arvx
         s/6AwRi6AO56gUcnMVQKbABtjsLVljdGgJRR1Avons6QHjcL47/VvdHc67ifgvfcs8RY
         wJCMIm2xYI6EPACQyZYJWJRXoKjdg3Fr000s6/w7bRm6QmWhYO49YTKCeMQq42wZYITA
         FACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612247; x=1784217047;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=ErigeDAQNHJ6ThXXbx9o9PWOWjywQDkXcXbzjw9mKQt1ooKV95XciekRG0Msl3gaqm
         HmtnVmFtqIPe++GdT+L+U/3/7OCG6eI4pkmV6elzpJhLPwOuvYDbpPiN1XPNK2g3P1c9
         IUFoYvkyRXJqoSpS9+LRgmOTTm85wIRKQ8xoeFvPbVce8ZJ8vcOFSzmJsnTVH9/Ji1Am
         8tcOVRbn2Fb10a2Ylpo2RByi7EbvPRLstXNgFJtVNvp5ISuIhtMHd/0J3ke1e2akys29
         TKTvw1auOvb4QV2H06HE4XEVOa4P+OkaSk3qmjZxjRGPxVvS9DiEmuamQ0joqvv4GcJT
         nBZw==
X-Forwarded-Encrypted: i=1; AHgh+RoLJUXr3sc3lAgpyn70g+wDw0ZGRHLcLGJ2gfTpaU2UuKFlUjeqEDhTvNklDR07i+FZ7y9lbELTpQ==@kvack.org
X-Gm-Message-State: AOJu0YzS2m/Xxe2l8Ab/95cSSltCiEBqIm/nyI7HpJC1VoPXltpeBx4N
	VX2a1lZsWEmQ0JB4unXdYwDlVKDtRBBW/yfHsepgo1NG+/emfAO/wANO6WwPMw49zq8=
X-Gm-Gg: AfdE7cnOjRrmW7nvXUj3JlgiazpMwlUGCV0HGzPCg+qO8eS+1TMAXgCFWvuTT/Yizq0
	UEvAe+oPh4dkteZfBybLQ1EA/MPTMAt88Dr2bVRjvfGHKfQfDhV8k9qjsmghaaHICJAQBRLM8PO
	2C7KFVgnp5G6C3dH4l2Ca7VE/b2VPtPR2un1v2x9FwxwcGajzfZ57xHiaKvRCiHZv6KcTgLMv0x
	LvS9xA0VXAhJp4xZB2+c1Q44L+1x8YBhy7i6v9m6kZqIsJBvyqDa8HyxxZduPUzpNjluv7/bMlc
	hweVcijMTZGwhjKHILL/A6NfPhwQ1nPJizvhB6L+nvwLWWDfWmnkcoSaM/hgD5Xjs0gH6hmz0V2
	9TpIZvd1NZyOKV6KKVKGvO+JFk1jOqwi3TX/E9L8cFw07+TIDoXg8sTT5WT/8K/hheXx7NBWDhY
	2fyunc4EkmwAVN+QtHZadz85eNg/Z93seHrwgpX/psZjRbVZIeGcpSW1t2emPA7IdnePKE
X-Received: by 2002:ac8:5f0a:0:b0:51a:8c9c:7f52 with SMTP id d75a77b69052e-51c8b40a675mr79940341cf.69.1783612246884;
        Thu, 09 Jul 2026 08:50:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c4202366csm161049781cf.30.2026.07.09.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:50:45 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:50:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 18/30] mm/vma: remove duplicative vma_pgoff_offset()
 helper
Message-ID: <ak_DUDt-1tb-V3b2@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D6B8718000E
X-Stat-Signature: rdg1j4e9hu667pfzstbp11gbnef1zfm1
X-HE-Tag: 1783612247-517578
X-HE-Meta: U2FsdGVkX1/eqh0bfOVarwhqhBwwueB/0sIsdijXkBgwmROPkzbM13ZqmmtcUpmyRq82DiOyENfgc4mrNQ3yBXNWHX3+a0Y/WjRmx1THCHI0NRUHJLMzdXKouQ53d7ScER7GGPYRHitVqg/lQod/6HkLS+rKnQwWB1KhTyntSvKR4JyMrRQRGhAhffkn8It0LDk/ZR1hJwmFXKNcm+oFQyHNmhnXiL6nI6R3qc3utgOiw4FSl+UuAuAnvxGRj4yhWOX1odtVGiq3WuN6TuIJKq3Xoiq1XZxyC1UxeAn5avt2WH6yP6mpM6dyO/QRTSnZjKR7SHaJ57RQoJv6BYCCd56sk1KdQ5Nt3meewrrPlUwlNJBJah4YNUPVuQjrTa0y8Bi90REgp9cPzspCSiqHzhJB0ghUmLT/bsGriS7j6190tvr1SWLIGEEgAw3Uh2mxgCDQtvh3oz0fIdhgUAsSOadnwzUysTjG3IDheyWddhpQswlUqN897D654zBNJDBL7aY6iMsQzxGwehdOWkXnFxZ9wjP0GETpV05j72UhM4vddITS6BrkGaTcTlIJMpAlHLm3c1A7M7HRlVjDbK5jOAyc0l1DFWH/XA0YQquYXTx8B2r+oaLCSc0GJRNNuPOU9rZ+aK19ojDSEoS5ZzHVC+pyEE2OoAaVU657KsOLqx90ctL6KWg6SmDqLYArqpckFlMARKlZ1ASqxC2suGfC5UteSEi+cyZvaGydTaCdQUaf2jll8HKerXoNsWFjOcD+MKjMmALguqTrJUuEadbmUmUEisRYpv7ES381FJWqmPixJM5eD0CqbUHC/Kpkw78JPr8aHaqjVhKfw4yvWA0nYsnmqiYvbO2saw3pkQo2rEVBbANpO0rW3Lqi7079CeUZjNnABmLbZz72I717IuAUQs9RH5H83kNML4XksmZ8VqeRnJK/2ZzSS3bpwNC5G+QLHSTuMG2BCWsOTROChl/
 D3wwuREp
 E5sDssMMryUyCCB4wXPX3c0xIK6IxV8hRRw3eHRKBeuIr073aT4BiHwKmZI2Z0JQvZ4chwgfejCT1nlx017wU2/IaSe0BxObWbSSVCsi1AwoZP3g9/y/a4BIvjjm4Guu7WhtTIWH5+IYiYHK7HKUbexfy0JIeaabNQueiVUkBnRJ1Cn6F9xMADxD3h3N2Zc2OmqaWr/rzVOvpG1gjm6BGT+tSOhvs60zrQWdoPoxogXI5ps6POD0jOrtcLRKGgd5XjH//cVbogTpraWiXLfv6IjZCVBa5d0avJlYJd+GLY09VAiYNV3v/zeVneKAFwnOtSsJg7pJ5p5VRn73tI5IADOFoO8LVfP++IsdsLhMJ4PjCbVFymloHoHzwgVQTiXlk8aavOOa1Zk8cdN+gFqnrlx3KPc75oHL4IaK14JTKClm5jiNDwl76/CpBrWdQOqSUmm6IDsGl1e+jgj0+eKAUpDmypUTeBNeGV0rchxcm2iVsv6yl/Vnqp4gBgAGQ4c4qQ0HuQnHsKUjKRh90CdXEeP6KHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:29PM +0100, Lorenzo Stoakes wrote:
> This is doing what linear_page_index() does, so eliminate it and replace it
> with linear_page_index().
> 
> Update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


