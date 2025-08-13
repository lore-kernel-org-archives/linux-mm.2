Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B9AC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACFE19000CF; Wed, 13 Aug 2025 16:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80F2900088; Wed, 13 Aug 2025 16:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F8E9000CF; Wed, 13 Aug 2025 16:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC3F900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:06:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5574BB8913
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:06:33 +0000 (UTC)
X-FDA: 83772816666.06.7566FDA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 10482C000F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:06:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WLUH7GHX;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755115591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47lxym8iNHWBOL/w60+zi9Lo6y41CAt0QBGdV8YddYA=;
	b=KPtb9RKU6iL6GUf2CNMuC0p5vjz8QLbseOruzNRxnsxAHYmL3OVYSw16kiQ/igPcYgzXZ5
	07IM8G1srahJzY7iLydbDyUTrHzRNjN/SheQzHk8V62mk2nPmYmASREb2OyxWHeUu+5+Io
	qKAbGW5seDQ2AOjFOyblb8gTLa8Bf7A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WLUH7GHX;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755115591; a=rsa-sha256;
	cv=none;
	b=UjaJzFH1ic6SC8d5st95WIfOQha47kjb9JUXvDoWsw+NCFJ7ZNLrHhxT5jUpqMXW8eWCVC
	PPcPYmG6WSWN1Sr2EsqX25h4YQMhYlMdwqCNuuX121+uPN0apzkMhTs7wKtDAXSx7m8FJX
	hhbCcVj3QulAASeATotCBPwSVMvB5Gg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755115590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=47lxym8iNHWBOL/w60+zi9Lo6y41CAt0QBGdV8YddYA=;
	b=WLUH7GHXLB77bGpal7kBSnYUB4G+gjHrx0PubNb14YuMnBW5N/NqKGugQm01GSlxaDgTYf
	Par5qkUjXf2QOKSDsGqBvmT0oSriVdXzWq4qakq9dl1mYn1DNGaJUAN7xdJgCyFpBojjBQ
	fWhIYyowvMGGGFC9L/6+2kIH7t1Y/EI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-CryIfU5FMWurZ5_f_SVxew-1; Wed, 13 Aug 2025 16:06:27 -0400
X-MC-Unique: CryIfU5FMWurZ5_f_SVxew-1
X-Mimecast-MFC-AGG-ID: CryIfU5FMWurZ5_f_SVxew_1755115586
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-70a9f534976so8643416d6.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755115586; x=1755720386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47lxym8iNHWBOL/w60+zi9Lo6y41CAt0QBGdV8YddYA=;
        b=iSwJ5vHRAljr9LVY6TzPLs4V6OaIao8+H186+TmB0QkN0chEx1+fE63DLp8SK8GFby
         I52+XJREJnXghwlNXcrJEkvpeaTAZapZCUovaaCG+7QTDpT5SZ4tVaqrTurzXkWrM5Oe
         j3P1PsenirOzqgCTq7RfyGb07UPC9bAf3EF1Om8ciYE5DARuR2IpEfE4ji2w4BMuAClB
         tNwhYdl9i+me6tng/AId8v5L1mDUa+WgN3dWPBJhG+GE0wqZsulI0iJyB0uzv6XV3pT9
         S/iu2vW4iNE4iwAQOni+qWyt6fULsXHCvh5hPjJu0yvF+4t/jgYI9gWLLq2UbEZb01bp
         +kmA==
X-Forwarded-Encrypted: i=1; AJvYcCVidkKthdUyZZ2OPyRRDu848vHdQXVU7XCHfaeTFwWHH73erbX8/1+s0z0FtiQk7VRPt4M6E/v+OA==@kvack.org
X-Gm-Message-State: AOJu0Yzon+W6N4JYOu3+8K8OZhZdh2kRmZBfL5gMOaved+B1IhFTR5Ma
	GWwxYnk+knkjLXdVW5f4/RChMlQsxf3K4Lx2nZUQCPSIfKxB1vafi1XgGrIPZPIWpc+h3ioBUYv
	OhluX0FF+PmsgYmtLzh6MWlqIr4olu5EzRO3Zz0HGZUujLKKxV841
X-Gm-Gg: ASbGncvJPKGjiR8NzLqqFcjJc9RsbfWhD73ZfGaKeSOh0USvuiwMh5NJ+eyXHQGnh3k
	aHkIApLXOBzGiII0/RQi6avPIFxx9X6Wejm4rO+XEHN+nOvKLZwEKsmuyj6Sx8uMWluRMgaQwic
	Cb3f4oHgGOIOdMFoWPrVgAAN8APvztEQPbOixnt1FOe2afCAXcGdJeoIcUrx4kZU3l8P/++yQg8
	ZqqQQNh+OdPWL7thncr8VVXaMEQv9Qtlm8y8mqbDcaLR1LHBwC0VZ4b7wJIdIlj6SNLzGEuGEpN
	XsLeDKmJM6EK6gTJYXY74iOf2xwPEtXj
X-Received: by 2002:a05:6214:c41:b0:707:69ad:d84a with SMTP id 6a1803df08f44-70af5c31faemr8222206d6.42.1755115585962;
        Wed, 13 Aug 2025 13:06:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTvuKixXYylw6jZAk9WOPy5ESjWCqWkg0b02ZWazA25ZrJ13LuOVgPLfrU/sj8o6PUC9anPA==
X-Received: by 2002:a05:6214:c41:b0:707:69ad:d84a with SMTP id 6a1803df08f44-70af5c31faemr8221766d6.42.1755115585490;
        Wed, 13 Aug 2025 13:06:25 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70af5b0ed60sm2678236d6.45.2025.08.13.13.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:06:24 -0700 (PDT)
Date: Wed, 13 Aug 2025 16:06:12 -0400
From: Peter Xu <peterx@redhat.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
	ngeoffray@google.com, Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-ID: <aJzwND0VIq6KB5kD@x1.local>
References: <20250813193024.2279805-1-lokeshgidra@google.com>
MIME-Version: 1.0
In-Reply-To: <20250813193024.2279805-1-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o1R6TntS9yxWpEUdUSL2It5stfEQM6jmd0kE4_W3SOo_1755115586
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 10482C000F
X-Rspam-User: 
X-Stat-Signature: urmqz1gnex1rwabxskzqdmdkfde65jkq
X-Rspamd-Server: rspam09
X-HE-Tag: 1755115590-736677
X-HE-Meta: U2FsdGVkX1/ivLodAdZAVcgjBZ/pNgbGSGOFDj7dRfkzLw6h8PGE841m8B3XY853/+KBBbL/ZSiPyF7uZTJ71Wa3xy7u9EExkzX2GmbUvHWda8anVn7W1naU3TaxnrrvHMxDEyPP7Xn6/dHFj7KqJo0Vy04kOgR7C8lp4Ieq9+TuSokTjhGGj+CMg/pYS8J47zlP8fMJVTedxdzqhqOomFQNz0vg3utEXNdJNrJ/e5qvcnn1Xuhl56Vlh7vvhG6qPjR7jTc/yOSSSl+xpURLUmVYFcUocFtg4h6QfzbMomO71YGt2pMvbAP1kzYjhyLfQ6j3JZCFskUKfkJj2hjTRwFayn+snKZK5WLmjbFJYYfhKNvQ/YOcvzFcT8qDAOm30ybO5vGOrVOX61RqRmpifBz/YnoebJEf6jGaiqRD65vNW8FVVUSlb/hI6Iee4iXtkqqmuo9fZf0oijGZmO1U2XVVY5vFelEsa4gd2wxR7JkwgiI2gpptdV+RmpOxBnevy8MTGB79s9FmNknMW1TtXBhuLuYihaviDgBaSXOr9fDUAgk6/J19aW0Kxf6grqpDDXp3poEO1+8kEYtqRonqrmHyfXmrdanOErs0cVgBvu57Os4RqdErJW9J0p96D43BCtn1QouHkxFZ2vUazdR49cuMCuyH7CZGwMo/QIKQDYipwUXiOQYKXFV1P28+YAmwb5GVIMDRCiTLmWsQEDAppfri62FpG4B0iSe5/jgV9M/kLJ3jM5OJXW69GP+MRmu/f+6DC/x1CB49uLNlduwJCjvDwF4q8uF3a6XTN24FmeaSYYkrZ5INaeB9as4OwX8Take8KJpdVcqqI/UDGvjgnWVBJeym4SjggfgwWI8ym81YQErU75uOAXZxS02ZlBD+oPgx7WoI2LBtNxFYcvl0xEnqW/a6sp/UtPqA/PFUS5sxUIUT+jTTgvdFxBBeKrFsCvqpHzr3DfZfUGUHn25
 rPFoP/K5
 dL7lgrlZ3REJ3lWujo+7qm47M3rsha2JysfVFVQpBLJXIQywvGHH6hcsYxexCJHjwsw6h6N35Ve4QD2ptRNdymM2S+JZSlSQYyQDCJueWnKqtHwqf8ainwWWecwPXJcfnVQiUdWdt6aZDwo6VljpQwMlVyQszT0CrEwJ6XIeqjJ7pBqgmZfFda1jMKGmGkzkgkGLInZkna/VXV9wkVXd1mpnizmIxQTAQQODlOxrjNvPy+cGi3Jh9CkknHZiaSgecXic2oVLR11WviGHe9T1ABH8zT7xuE9O6R/hTJqXc9AzgvuXxpmDq/kA0ANBPODdNrRN4KSVlJ8IwhxEi0cHsUe1fSx0T3AUdRvJop9Qu8UcLmTU8BAb1p88prKIo+sf+RNaZf01SxChtxZpcn02JRtGawsRrIyms6ymJaMNdXtuQ85Bn3kQCdTf7k/aCezfpdcbK2+WA8OK5j368o1IGjkrJmSdYY84JYEYyVUCtYKGl3FmtKH4QsKcCTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:30:24PM -0700, Lokesh Gidra wrote:
> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
> 
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
> 
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().
> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.
> 
> When the GC intensive benchmark, which was used to gather the above
> numbers, is run on cuttlefish (qemu android instance on x86_64), the
> completion time of the benchmark went down from ~45mins to ~20mins.
> 
> Furthermore, system_server, one of the most performance critical system
> processes on android, saw over 50% reduction in GC compaction time on an
> arm64 android device.
> 
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


