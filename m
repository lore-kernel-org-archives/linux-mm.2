Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2698606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=MaEVME57
Received: by kanga.kvack.org (Postfix)
	id 764666B05BC; Wed, 28 Oct 2026 12:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D1B6B05BD; Wed, 28 Oct 2026 12:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6544D6B05BE; Wed, 28 Oct 2026 12:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31DED6B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:56:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C77A1C1F78
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:56:07 +0000 (UTC)
X-FDA: 85372637574.02.F6D90DF
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C133160003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:56:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MaEVME57;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3C0d19m+/iHxVzVsZqZF5QMTPBWCH1ibPkdNy3hhyQ=;
	b=jKZ2q2B6vH/GDQvY0AErGV3djmhxfwaB2YdkDp1A/aG7GaPeT3UULRXhnF73FiCHPkkm4L
	B00UFUvvzLOYRIlwYwPpu4qPYYdImRSX2nyl3pVi7ibOOiDPVaaTtDqFnzNhr6hOXm9/y2
	0AwYGN1+b+0yfB6C2u4eQ+qiBENduqo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MaEVME57;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206565;
	b=IXw+V6jCQ/8XfqPe1bChvCcll9d9S17iw+rHnuIQDRlU858AWkmDsy+Yin6t7VY8yUfNsH
	IeHuU684CNusoJfjudRHweK83Q2Xe97X39U460YibtXesQnjIH4erpE17udAd8aIFXP35o
	z7apuET6FO/B+bvb5A2/3BjMya3LJmo=
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-99075306daaso649918241.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793206564; x=1793811364; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r3C0d19m+/iHxVzVsZqZF5QMTPBWCH1ibPkdNy3hhyQ=;
        b=MaEVME57w/828pCzauKbixWORoAK3Y15d5RD9/CZzmOWA/MSHzCkZdanQqqDcxt86f
         jHq6rn5Ycw0cJWnaany6zz8+V8m0puE+EM7T2xX7dn1+B27bFwdrCLPO+o0K4yhjs+Br
         N9zoyXXyyXI6zUFcpyRqm2HnnHlz2hwwWwrR3KRhzkJ87wO3eRT0QxcyjTB11ceZI6Tr
         AzvECpVIA0wqoetr8RlIp+M+gEgT4hXZCvOPdL+sKYoZ+tcoe3F62UArR+f1Hs0CzSu3
         3v2ZzT97c1c3+SAx9AveAAcZpTfIRdnIV7bj1Cdrs2IHaaOCPjEDNcRtXHzrRH4i6Og1
         X9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793206564; x=1793811364;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r3C0d19m+/iHxVzVsZqZF5QMTPBWCH1ibPkdNy3hhyQ=;
        b=LWrOWyGZIkYnVTrsouj4OW6PWgFJgVKAynomDbenD1xQy2549jfBf/ev3RJuBwapu9
         oBbPCKDrdfLHfOXt1430U0Y6Dl4JuwTXemJEL2h9MCED+m89oGyylMhhGSSIgpglyJRi
         IZwywq9cAnEXVoRXW9Y1xY2QaOSpFVZ75V4p76owVrqsgodjcSMcrnR+jG539mGRIL3I
         6Qq2+Blx8xPGZA8rLdaqJwpGKKH2XDayfg0LTcrNFXzOWJE3DWpwI94WVZ+LokAOhYyn
         osAPlWii30W/7+6F4g3NqiTm8Jo1unEHMbZYMTKM1BlmCEj/+SOIGbWa3aBhFM2cJ4+c
         aarg==
X-Forwarded-Encrypted: i=1; AKwUvBxUUMQR4kvrrH6p4HmTweGVlFNv9m4VQvFiTp3GiXqeNhwB2HRnoIj4SkdujW4AyUZPA+sFO8nkng==@kvack.org
X-Gm-Message-State: AFq9FYJ7GucGS55YAEw5RFKB59qY4IrOirveoPcmti2129VNQLH+BLBv
	uwYlBCZJJkk7Dn1D7oqtW/ZbSgok2sVZSf6E6GmDzaUKhFQ09hHVXVVYfgMA3BeuDO8=
X-Gm-Gg: AYBFou0PDDl7PDykrdBZr4aFhN0evC/iVCymjH+GeltNVeaHyrJ966n8tB3YiUPOkDK
	6ZqRbKntJ46yeXzDba8ix1fmanVYfrNxe/RK9I23jzFx1VZsxYKBU+a0mMO+u1lcOgn16siu27Q
	RY2TXvRbvajaF2boaCrUuLAnaHN6w4num64dnCjMjIB8KU/5a3rOxpnC+N8CmtwxofkUuMSe1ko
	rBqKF5iksGPbnXxCHHS3yNsp8FG7I3o11tHqxltjxIJvAd7AQf0ZcwCu1eJ5suUfKsFRxKxA2J7
	oluQ0aLXAAgAi3yMsW4erqtmxncO3sygbvKudzv/jbawXC8kVO1VVigSp41jDk8+Pskhs+xHYjn
	R2HpRSkl1ZdHt+wQ2HUbl3p4kzZJ72QVjr7KtzUXHMG0M9e/NLil1ZldP/fIsm4pWTv1iMJkxK/
	6RloTfQvEsrSShrWHSBYmO4jb2OPScarFQKYMXvxOFxm57ZnO2WxFEnYSbgaBw9KhrDv29/TUeS
	SeBVN1wxN/p/XrBhghpyJqw74GF9GQlHFPG1dITHAAqZGa9soMSTHT6Lq3kEAfGPzMqWcqeP7hy
	4QlyzHn4hbgv+/DFHOFuPbmscQnFeSofrIn5L3Ihjmgo250w/Wi9r7jdm9l8RoURmEEJangndaL
	i1ImuSyFYHNKrM/3Iw2uEHkSNsq/WIeR6CY6o+JN2jo8zMubEziow
X-Received: by 2002:a05:6102:370e:b0:7ce:a79e:75a9 with SMTP id ada2fe7eead31-7d03a59dbf7mr1528233137.36.1793206564343;
        Wed, 28 Oct 2026 09:56:04 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-991259fbcbfsm6525438241.10.2026.10.28.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 09:56:02 -0700 (PDT)
Date: Wed, 28 Oct 2026 12:56:01 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 38/46] mm/ksm: reset the unstable trees of all nodes
Message-ID: <auIpGR1VG7lOxJ8P@google.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 3C133160003
X-Stat-Signature: 1hxkjwophf1g7irpdq69gud1zo5ckppj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793206565-582475
X-HE-Meta: U2FsdGVkX1+7LCCHFVW7F0Q44oAXsOdks+JeI1EPoI3yYGjRXsb3skSyvOdeUUbOyBPBJrzVeUYzWv+vQ50S/aNIHbxQI6OqRW2hjK8Shw9lBu8kTjw9u5LJIjliv380Hj5QWKHv+723xkGWMITGdRhMjYHQ6VxYbXsEsCUiZVqRXVB1WdHrvvjKah0+BkzJEJGPDnZX3TtaIOf1wsOxX/qno8P5J4OYZNgO35VhMA02rgczxacF3wcNnHwIq/KAAtNcIPsrGP3QGc9xT4rQHVKHHPNPIm7Oq4taWhTdEjTisfZiSC6XIK0FPRNfzwZHI83evysBFqgQxysMPdGobQybI9OcWh2kcoILh/vd5BwGwz3KXW7TK6S717vpCAVNTuWkQUcnnKdWvAxSmW5gHgQnqTHDW/055lfQSVbj583K8nZhZUMwMc+9HWo6OQefCQFiN8BErPk2VRZQV6ZA9UxCVue25rgkPfPlaK5JQrSrCe3yPLBNPPGqWPcO6yi19iGP2ZpaoFuF5MTEivhc4pNH4Z0FntUrwTUNAjt7cEoqzF+e+MmpsNn6HqXg9V83WfiAdy5wKWvxl9M6werZMW3p8EXiN3/HwSlyjEg64nAg+MgPy95bwP24jnyHN3fpB3uyFeuwH+q1CcaA9VLtAbZo4yQZVsljgTo4yicFGXFdpWZSXFkOI8QxOQkyOc1B3//zRJGbb96QPEP9XJhZparix6gr8qpKEBo5qmbpZTijxm6f48lEaUevChXFp6zpJhSuUA/65FyOcTJrER8BNtPj8BOik69H1e2CD9UsZbPGXPTlQlmeSPEVGJhmRewo4tEOg+jZUv2izhI+MaOlVxiQmgctf31geADgA33dIIEme7yY+g5r0naNkBQKdrUYZrSALP0Vi1noTj1vnwleuhC/wgGO2SnOGLs0tsLbpWJtY7CTPwQHNfU6p0/bgHYmwMzfHvMl1aDPEfvWWaY
 AvdBME0W
 c/tB+hp+BxK0lCcaUSWmp3k0odgRLNjemglF0e5lcl3jLbjb6eWJtY+BhQRIGjU/cY9DLYgLY11zk9gqn2EG0xPFUe54cTsjcrb4YMMytPG03EVu95NEm0Ojt8UHwNX+ZzMOnhsfkcb08lDnyf/t5HJOYsrP7pJk6sLyU1G+Hp+MFT/LDPYPfyjRQqp5r5HISUh5I/EbncvecxDJ48Y0DOnc/1eVcFO4fZFIayFspfmB9/JAF5Bh/IUXCTvQv2xiTpDV+YRUZ7sjrrM1OSqbSk0/r5bn1DKvjlDuL4bLUVawS6Jx0ZC0Ac346gV2byynltmj9+WZec7DyY4kpO1QB9l1bYxsuc5px4n8T0wpQ4reXP8PiVrLRy20WcKogwt+LdfuHoEaG6mIT7Df3J6/g96ZDX71/8AgU3Ko3Ms7feyIlbrie5+ZOAbAaf+w7BSSoEx0btI1a72CmQPClP4jAdIhV16FlhUgnpWqklJjbdnAmVuj+h8YwxfVzuIJcbBh+T5/ywvFvXFpf6HFwl/xfUeRiJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-27 00:17, David Hildenbrand (Arm) wrote:
> Each full scan resets ksm_nr_node_ids unstable tree roots. Enabling
> merge_across_nodes resets this count to 1, even if per-node roots were
> previously allocated.
> 
> So when toggling "merge_across_nodes" 0 -> 1 -> 0, a scan that starts
> while the setting is 1 and continues after switching back to 0 can
> encounter stale unstable tree roots, resulting in UAF.
> 
> Only root is allowed to change "merge_across_nodes", and the documented
> sequence is: "merge_across_nodes setting can be changed only when there
> are no ksm shared pages in the system: set run 2 to unmerge pages first,
> then to 1 after changing merge_across_nodes, to remerge according to the
> new setting."
> 
> Let's fix it by tracking in ksm_nr_node_ids the actual number of
> allocated tree roots.
> 
> remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
> more tree roots (skipping the empty ones), which is harmless.
> 
> Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..9c51925825cbf 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -475,6 +475,7 @@ static void advisor_stop_scan(void)
>  #ifdef CONFIG_NUMA
>  /* Zeroed when merging across nodes is not allowed */
>  static unsigned int ksm_merge_across_nodes = 1;
> +/* Number of allocated stable and unstable tree roots. */
>  static int ksm_nr_node_ids = 1;
>  #else
>  #define ksm_merge_across_nodes	1U
> @@ -3636,14 +3637,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
>  			else {
>  				root_stable_tree = buf;
>  				root_unstable_tree = buf + nr_node_ids;
> +				ksm_nr_node_ids = nr_node_ids;
>  				/* Stable tree is empty but not the unstable */
>  				root_unstable_tree[0] = one_unstable_tree[0];
>  			}
>  		}
> -		if (!err) {
> +		if (!err)
>  			ksm_merge_across_nodes = knob;
> -			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
> -		}

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

>  	}
>  	mutex_unlock(&ksm_thread_mutex);
>  
> 
> -- 
> 2.43.0
> 

