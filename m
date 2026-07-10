Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A170C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF8B6B00B1; Fri, 10 Jul 2026 17:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FBE6B00B4; Fri, 10 Jul 2026 17:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738096B00B6; Fri, 10 Jul 2026 17:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 437776B00B1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:17:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A77A0C3C6B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:17:00 +0000 (UTC)
X-FDA: 84974127000.23.D77165A
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3FD4140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:16:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sGQueECX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Izor2xUYDxPFma+uXVb9laI9dziDM9wo4fE46zQgxzc=;
	b=5D1vCCVIQx9Bz8LDkLshh0ASopuxS1DmIGultwDUYo2ra4CPBnsulguHqIAcc8Vi9yEi+/
	rgxl+GCEq18cdBA+73G2agUMooWPu6xaUOPrX2hdDBu6njI5ypcfjY+NnpZlMIvmqzNoXx
	kzUtBzgt+zOxabRnKiicnfHigP1jqCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718218;
	b=V2LPFE7iteK7mOxmcSzmxducEVb8VUdneRdnVAJZ/bw17BavlU0xFbI1czSk60UxBw+hck
	H2A1v1UoimJzhvk11uwV9YcYaSoeTEvTXhhKe+pvc6HaxgxUpi5I1OIw0X+ckRS+PvKBOG
	HPguOFaGfl5mq3jsYCprTKglE3lKhuw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sGQueECX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e6a434cabso71486085a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718218; x=1784323018; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Izor2xUYDxPFma+uXVb9laI9dziDM9wo4fE46zQgxzc=;
        b=sGQueECXdJ6fkhIjv28u6WjZqctqGbai4fdejBbsNP37ynQ9kwKwcuJODITFj+s4GY
         hvXADTgiLozqfPmcRFXcYT/ha0xTBcZruQNdA4XHxVRO2GWEyM0CsMqwsPQXzY768WN+
         Oix4M9ZeIlsnTzpheqjq5HKWTvuVCHsXZaXCGOxpL202QBbEvAiqFk6S6+G0tkD9Hjr/
         JW76iiTmVBZPXXe07f7W/lrp+XLp+yzOUPNtnpetPFSIekETDPCi4S412fKEAbFy83/y
         xM4Q0TS4a3LUnwFCKt1Hd6MPV9QpAwq0iqSaqmhMEprKX0fLJ2pzHs6CkOP/LTOyjpWm
         9Tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718218; x=1784323018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Izor2xUYDxPFma+uXVb9laI9dziDM9wo4fE46zQgxzc=;
        b=HAG7rtcsn6LqZ7Nn2xhwase6l+uQgfLPvn9nheX/SQfHmPyoEmUHYss/mM2elgyEw5
         fUY0H0NRyHjs2QCldw08UnsXi0O8f4DL/b0u5WbErZu+m/VsymyrATIkYSgEYln/wEQ6
         pS/8QR3l++dOUVMGnv2IUv9KowIXe3NRDbjRhA3KHi9tqUUtKrd4303LKGZhIwH8M6cm
         gDylMn9ELbelFlq4oRMKXlvHjs31+cq47vYU1XbrJhvxbh74/Rnj5Xr5NqmCR8OrUPU7
         aqFXGPs4ef4jJGIy/q03CG1GHhT8UzK196yTXjyANjd383QDHxJ5/gYKTPnGciA5pPOD
         TGZA==
X-Forwarded-Encrypted: i=1; AHgh+RpDr3ypZtqzdTCAb00UtvkKiD9qd1sAEaRbTJnGehnZxlx+8dxUjUp8UVaYGbdEVp7tHue36C6nEQ==@kvack.org
X-Gm-Message-State: AOJu0YxyVUGbrsXJruGWAZrpveT8116G0Zt8p7H0T6SO1OqFIKkWSkqH
	sUMkom8VoLg/8D9ciPnKEDLbXy36j1A7lzTGUwA+5ek074hqICRT+IPoFk5QAbUQq1E=
X-Gm-Gg: AfdE7cn753aHxribFXMS6/PJyJx3E0e9G1sG7qv4xDMcF1nYbmby+84Q8D+mbwIDdgA
	u8zBofILajGJKWjBxJKFits6o1ktyOlSrihjxDFM19l0pepx8QyB8RyJ6G+LrMgrdnNuabD/gGc
	eEEU6n8eP/r9KTwI/1Tqy6fDHhp7+3P/bTZ6X61Qo4UFCwko03Wpq9Zlv+rHYCSBUeeAxv8jA88
	uKPyglwU8tt79Qq8OFIxrJ2dHRRx3+Irjs/bB2LqpVNtevFpThvnPPirxNGJzyJM0PIEL8H7RVI
	rnYnNrC+WUWia6Sik7RjZtZJuAVK+v4BlUiarnQL25D5o6yIO6FBCUeMqWpmxcAAEXNFeA739f6
	QlohRoTqsb8c3RrSiA5Ftu8cPaKBAkvyEsf8WH3wcUE8sn9vghgGMvidsOYboYHndhs8WFq+Eyd
	0dxCytnEdH6/mygjptBkd9RdXzYEsbaHR9MC3TvXUvmWjTL9Kx5jr1eHCv7nuoMrm/LMsT
X-Received: by 2002:a05:620a:2691:b0:92e:72a4:f290 with SMTP id af79cd13be357-92ef2b3518cmr83584585a.19.1783718217777;
        Fri, 10 Jul 2026 14:16:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fe218sm49983646d6.33.2026.07.10.14.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:16:57 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:16:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 11/33] mm/rmap: rename anon_vma_interval_tree_*() to
 anon_rmap_tree_*()
Message-ID: <alFhQ71-WGGHo1sJ@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3FD4140007
X-Stat-Signature: npabxmo3y86kona1jxy69iqeincirke5
X-HE-Tag: 1783718218-590302
X-HE-Meta: U2FsdGVkX1/y3IDHWwKXpFdvpLxgYpN9ITHwj3NfrPi/AF2d7xCefLGuPg2d+c0idKZyMQwMXcjzP8BjKRbyn2rPU6dXhlFAow0R8qBSMEyAQ98X6o+WZMfxE4oNn4T36GYROj3Lzs/2f0vCW7edx4z1IYrd6ak0+a837uhYr6FicxOtZM7vMUPdQF4d/FywqQFwVQY+/ZKpq29+FstfMLy/BZheyaAARSQzldRYPrS39XU+8VwrgszMDezSGmdGIrjeJRo1bG+pohQD9icro6DAWqyLOD7C+anMgIQt/vX8t+xv3mOgAq/55cy2wqNVkiefm/llY0iHnWeuY2mnLw4HtmZKt6vBMFt4m82fqh1D+NKtsuKBWqMCaN1ub8oqzzX2qRuCZuxgUrG0sAe+8n/2kJfoU4eon2esIK7NME+N/09qJT6ZMP1CobP23uhyLbUvSwaXzW9mpqeF/6SArAEaOAl8fS6MQXXICpLKwa7XQJqHr3sOYCCzaO/DxisjohZ9KDKw8guleEyAIPIr6/mJoGvEwQM1Zh6RkJ1tFiuyy1Cek43aBMns9zTCc0vc40D+jZGja7EpOaK85Eicin3OgpPuJJ1EBlk9g4okI4COTvCfkn2iYJJsr0q4D1zPO/E+D7dU732lZNxMSglQejnFKBfiJ9EVli/T+mgJNe+XHZZygvFTrvcUw7ColMEoEGlQ9WO9OWP051w72yM0XDYBVgjbcrIG3H11lScmP/1wCg4aap0UYKcsRoEgzyr9KMAuXs4j/JVDVfJbztUHLtnG+waLPBnMEznhn+/KHP/+lPWkkopNYR54bNI4FznzZNN4w8wojBmJ+l916UpThzamAchpUeyR+a9xk1SZvlb8TgliZ6Eqns0M3cZZpTWPa6yDHYhtuo1Twa0Qe0IgC59HfgzOf4XFXG/RNG+wkhCqYDBcrIR+8eMmWyzcNz7OV7Q3osvDyE2ogwskz7a
 oCxSPcdE
 SUfNduaZSOm4UEO86hqBPUV/kdo3PODkYK30v8JVmX3AIu1GgyxKiXYVsFVK4TWwDk/2vFUZFBOkB6CWTL5VKrbiAyeGqwrSfpLqCNWA/vC8Av7ukS6DhLraajg9yHPoNgnoUY2wyBF7YflgXl0xFPn49/8mcSGa09jHT5Tl4MdBoQqM2eSuSEqievC0NI1m35jeZng612nHZu7Sx+q6a2rpX3nWBHrKwjU5Z8si7ODzrjQq1juPE3yMSCDVlxFNy+dlEpUpNCjYV8+j4n+0Kx8TdKZpv0KQ5e97uD6MTuPAy7bLMXsRXOy/9iBw25jKG1fkg+o7gsJGdKYcRp9vAwK6Cndg8gIJnjL78k8/BLsFoIplW7pkPSp7TJ12z8St3IHi3r9u44kMa4mR40/98vtU3ROFG4eqR2TkMwWPj7ZaUH+EDGpZE5367hRDhJbe7S+nVfrpvh4IK4vC7mJD2VGZkq9OxaWNTDHUS4uAFZUKD/JmmqlZQIZcbuO0yVTsK24rVLKxJ8YkTPyeUF6xt38gXGvEpVymitr5aBYE/Qd5ALrOjUVdhPR2lS6kIDnaXVdTV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:16:52PM +0100, Lorenzo Stoakes wrote:
> To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
> anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Nice.

Reviewed-by: Gregory Price <gourry@gourry.net>


