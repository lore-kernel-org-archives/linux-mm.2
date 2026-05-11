Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C97CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40D96B00AC; Mon, 11 May 2026 12:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18336B00AE; Mon, 11 May 2026 12:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06836B00AF; Mon, 11 May 2026 12:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE5D16B00AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:26:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99D2C1601ED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:26:27 +0000 (UTC)
X-FDA: 84755666814.27.9A815E5
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id B8B8540016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:26:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p8nmEdTG;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hqw8rV27s2rIaaJU5shbxCCsz/N1fl7ypBY0wN8aHj4=;
	b=fuwdps1/msqLi86yHQX9cvliRQ5yi8S9fKBzySc2YewpHz42Zz6SrRHszcUVqRmGM45vWZ
	NkU02Tnss3DaQDvvmabpuoXF8eBud0Cze4uJUXP/wwVegacTpzRYr0t7ZS57SajTasJTnI
	htBMTqd6D4QgMHzlZEnVPineHq0hwqc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p8nmEdTG;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516785; a=rsa-sha256;
	cv=none;
	b=X3MrsV1AQDSM9QissvK6oteWsmtIsTr+MS3aTasUKXmoxvUSeeSRiaeVi8HQokrU4Bamcq
	XhAJFJy+Ty3w78JgJ6q+DDNzzSPJc+HRYoq60JZln/0rPZ2wWV2idrM7EJ7kAqOqrV8Aiu
	CilVc8rNtRxRP8WxWhKq9bbldpXNY1E=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8eea23d01f7so606036685a.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778516785; x=1779121585; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hqw8rV27s2rIaaJU5shbxCCsz/N1fl7ypBY0wN8aHj4=;
        b=p8nmEdTGO3OSKFAE7gndD4p5PbB2QHdZT29Ug7H35+Z8OC1IX2j1tziGtr5M3dDRrN
         eIPtJFD9iRFirzy2bVvcvLokqjSdSvx7TRDKS0weTTslou1Qilf8yTme+e69pfxUFB6Z
         fGJo5C5pLSVuInWd5lhwpATCyG2ft+84POXH0HORHKuRoI1KJEJs1EHHACri6docFeWc
         QJhLpls75cKCLadkpq4atK+c7iSHHbE9YIE+Eym1bBCc7qXUMUHMh8sET7fspEe6PdWR
         SnmoxAdvVBi7P/YW/LyqlwzuBOD4V0l5Z1a4fv5N3m3IGwfYaSXYvwCfYQe7iRV6uSJJ
         3Rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778516785; x=1779121585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hqw8rV27s2rIaaJU5shbxCCsz/N1fl7ypBY0wN8aHj4=;
        b=ab+uTRhwFKUFZlCZkUg2jFgnhD31AX6xmpBQcukhYSN7mzhiG1D/RgbZ+k5cE0r09a
         cnWGfdR0YH7cCVSBD3owsd7tdWuMfFhbPS2E6nAxyNpX56mAti/QuJEiUrOtbbCirLRF
         VqGkRh9x9pACQeP6LiljQO/lhzLb+5jWzrNyCrisVbOFWrXtPKg+8IiB6TdaLs3KHDOo
         fLJW3Q4d95/0vEuszQPEhwRcmigd3skhg2TzHm6pNLlne1izVAEedozoVuoZtVmrNWkq
         c7BWLJ/NP9j0SURC4g1xTNvyFQZTdIYbM2a2SqWJvUh4Te2Pj+5CZSitfCt0TOqk2fhO
         CFIQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+f+ZKQYpIRpPNXW9YnWSI7AApaKQKLqGK3w6cueVcZaq8E/3BPGUFSKI8RFdxpBVjRxv2XG0miA==@kvack.org
X-Gm-Message-State: AOJu0Yz4OhmT83+2/Is4LaE3llFzrlXVD15L7y34bvlSKNGcXio1Pen5
	Spg0U2yuERhtKi5/YZQqPmMp00HtHtCMxMa2gBxFiVOMMUCvXMyrjSLdN7R53zTWy6s=
X-Gm-Gg: Acq92OG4MLBlJPqiV0JJ4e055DHzE/1/NWoe5qb3xW1f1zjtRCJCsvOSrSiegAxTbon
	ZkseUGOEhIW3A75iymmCbMxvNetCOUGqiAqDcMeawvsdvRtsWkpgL6IuIHzlFHq+HfSrpqNTuKo
	ytsMtRamq+mZGoi5zL/J7yGl7mvHbqHcIw8tkhv8ibn8ayNLc8/wp2ao6iZdeZVaQzGpkOD3052
	wiF1+XHs42gOQRzXdjz5Q+eVL3o4cfwuKpnt7KQAx+e/evYLytDjae/cMRqFqTHa4g0lAJYvaj/
	+6quASweMkQty6duekuB8+5E8lYGtnldny/xoGUzTVXmvI9YAhG+oc5t3bnRjMe+3cVffTpKnR7
	+0rdM26kIbJBpDZKw19+lna/XYxqySflK7BfQ4hUwl+zb7Bzk+8PRJO4o1kwlqWl1U6qCRa/dRL
	+5w+iBQ/ORnpL60sS0MA5kaTxExw9vc+4+9Y4FCQmyoX9iK4QXIu5GzVCHo2BMGXxCLE1cahHXN
	m88YeZ86wo2
X-Received: by 2002:a05:620a:25d0:b0:909:e4dc:fb30 with SMTP id af79cd13be357-909e4dd008cmr1293290885a.38.1778516784603;
        Mon, 11 May 2026 09:26:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b9772b87sm1059935485a.5.2026.05.11.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:26:23 -0700 (PDT)
Date: Mon, 11 May 2026 12:26:20 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 13/30] mm: use __GFP_ZERO in
 vma_alloc_anon_folio_pmd
Message-ID: <agIDLD77wTF8ZN1Y@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <c8768c7c2a4965b5e2dd78680c936b82606cc034.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8768c7c2a4965b5e2dd78680c936b82606cc034.1778489843.git.mst@redhat.com>
X-Stat-Signature: f6dcfpmnfcro71ap8yttexfqft368utr
X-Rspamd-Queue-Id: B8B8540016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778516785-464791
X-HE-Meta: U2FsdGVkX1/td4kOTd4sDh+MrIfOaZB3xKz9L11L8+Dy+BRw2WTzeKGLdUaprbzzMMLTWRaTwJmWFy3IVptWz/7wWGM29e3dcUFTKtR0McGhvxoSoF07pmBtngMmFf/xouhUPp+4hAfCQQ4Vp9X3+WK61S+Pihw80gQhS+/4TuseI5LDiAIOSvHfL+a785/8btjeSQGySd8DW+2RZ+qgnavPrxGtJfq5/SPbXaKvtq5ErW00FjInN8GdnjbI1zkDHWoh+/B44tXbMVDhaZHWwbPYhSEi6vNX0jA6PlJTM1gGtdyrkkECg2Clnaf4HMcqwWr1jLHzJLCavjOuBqGBWhTJHP5qFwPPZ6/uiWQaThmI40C4Iji6rCYjZVecUyOGHOth9kKMQmiA1m+MDrHlBK3cDuR+n8nJpewxfPutc8pofRASBNAxqMz0UVmMSHpnfmb92Mte0aT7y6TkeRHWDwuKiujxjxvLXdRd1Kwv9mN890Qf5jDX348Y8cxssFBiMM9HcA/uQrIq4gLw9r5zpEtMKzJnsrss4APWeYJaupygLyjDfJNOSpUhogEUHDIGdzXGxErxFZA/cVPcyjIlk6Ywhp0QKW0eyz2jeOopVvFRO9tH5yJ0Bi5q9Ad1j+kbY5QFkoV3N92Gxeu3BhOxG3ayvpGnmi2NdbwTNt7wDj20Ik974k/WKcFuvIn6qdF2XpCMucpp8/edaqU5nZd6kt7lN3f/UhmXG3Jocs1h1RIkVmu5YHZo45p4dc/J+O5ENZ1yC3KY96fzp9jvH+d/CKmM7x+/JHDL/tGjAWcELeXuPjBlfWGV1OZcr39u8mVnk/N7XV16LAwGYuzzp72JZfNiDXLBx/w/bgvovNOsponMNXyu1FluxHihFKcz19lOA50UPu9c0Xq8RJ6hnv0oI0zVZYO6wpvyrN69txk8pgM063i8nf1oFPNatWedk2aqc+S7CXXj5SvX+ZkZCYz
 Lq9b1bWP
 6H5fbhzbe4/dQ0ym3aRALAH4OR40ONyIrgwI6YPm304RsI/yGgkQfV5yMujLJl9I6zN4barI2KQj4O/kasJAQkcuvnoLeZeWg+LfH0PP7j+2X1/hUTASTuo9Z+1oaSDRWm8K2IjP/jtX+VIhNQYGiJnf4RGPrvzpdu0dYuFK0pbfKVWqUeWqtm34D08owzIq7EniKPkIpdJrDc/onGFp4H8SoXIbKIZjQyj6vOLhl7ITynoX8Ir+Q/gJovVu2frboyFcvMp+kh0bTtL2EUjeA2YuCOxBK0IbjeyzVumnnT/2Anw41/8YJ5F6bz+iPZgDwlnaLTPhffhU8kQuYVpZp3cLjt9Jp5DLug1HC/0HtHG2JkLLw0qX4J6q2+R/L09ahce3acsGPZSfEGTf468DDCFyO5umCsv1krH/xt5RRcdmtcKvIXaxuKqktEF8QPRR1qJyGLUPw4HldCQ/fG4Hpm0bsmm13q7IMKo0QkRlbPbL24Qg91Kki7ILwoWi3mwVFHB13qEvIg8SOCelyjDoTLQmKsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:57AM -0400, Michael S. Tsirkin wrote:
> Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
> zeroing at the callsite. post_alloc_hook uses the fault address
> passed through vma_alloc_folio for cache-friendly zeroing.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Gregory Price <gourry@gourry.net>


