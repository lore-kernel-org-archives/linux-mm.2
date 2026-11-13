Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC632606A88F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=XDkJKINo
Received: by kanga.kvack.org (Postfix)
	id CC7CA6B00EF; Fri, 13 Nov 2026 16:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1836B05B2; Fri, 13 Nov 2026 16:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5866B05B8; Fri, 13 Nov 2026 16:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86A666B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:42:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BFA140157
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:42:35 +0000 (UTC)
X-FDA: 85431420270.17.C110D24
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14DAD40007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:42:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XDkJKINo;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwPRyHP2zyVmejGR1uh4JtlvqhjIfEODs3w+QBRfcJQ=;
	b=VXihHaK+V+N0Ce3siQffHl0Uz2rZX/oMa9m4Ff60MdA8AyLiV4xBmwRpfyCD2ymQE2UvlR
	xVpnoqMIQJij93n0FD8grqclr1a7NaBaFugxC+4vhLtyvef6DWp1EmgVKp9cuyJ8JYzNZt
	vBV+TqMmNmRSMyOufEf3pwj9XNwb/oI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606153;
	b=0vkqytS+4xA8aTmpdCXSa6TGM4Y9SlPbzvUi+4UNIkjS3myo8gPyp56HNTdwlAvOtl1CQI
	Ke5+baBlcbl1HxtYWqE1o3TqD+3MeBkpFr6zkQEqRHqtfJR4AXzWt+YsVRLGNLd7H7yQIN
	5zEKyDS64CyCFRSgZZWbtEkJ6Im6heY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XDkJKINo;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91f2b826fe9so16612946d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794606152; x=1795210952; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RwPRyHP2zyVmejGR1uh4JtlvqhjIfEODs3w+QBRfcJQ=;
        b=XDkJKINoPcrGFL/qBCC2kJc3oYq06CGeXGLjsG4Zjm1YfaejXneA6DccrLxdeJ8ELf
         ov1g7ksRDZ9kikvnZuzVlPqvpzrkPriA91HHqGvpuzhmL5yHd7QECYGT7VzvpTr3xibo
         oE95Keb8zDBYo+UACHPPB0juuuzIQHzQdMQdZiAO+mzax7TxpxV9D+65ayMLQ7INmMIG
         IdnfQAI8BNHF6NRG9RjEhfXpPcT2SkYN4dHWBQch1NH1T9/3RE/5OCwknagjP3a1zLhV
         C5ry+KkbLocdm22pmuULiIeNuTX/wsy8CbbpGRUKiGdvf1NK4fgaUqMwqYc3PNGDN1Yw
         SkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794606152; x=1795210952;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RwPRyHP2zyVmejGR1uh4JtlvqhjIfEODs3w+QBRfcJQ=;
        b=M/vGxi/IwleHzvJbQcpKiSOGSkkyyTh17Dm5SyYRsWUHebPgRCBCZAHOA6t1IkyMA1
         gSjWD1Cc7fVM9uM/lYABnGxIAJiEK2TP8qnalzD5d/BtjWymJxjk+9rvjlAOUNqMiv6K
         Y3JpWPO34V2v0HcjvOue1cxBFbdLqr1C9oO0rMdGiKYjeMRNtXVBazxP9rklBJ1lAtIx
         Wlz5mfOHxv0FWUNhoM/9wmdYB3d4FMRTEpGDGZis7Z8HV5CFj7w0KuuLMsWF2NxEbiBM
         j0MXdhRvjp3eayp3uZZWcc14s6Xu4CJVYW+hQazjPI4oWpkWjEXhWkt5H65udVJ5209b
         M1/w==
X-Forwarded-Encrypted: i=1; AL+hErGk20fCPUpuXdJRtMMIoFFWaDKoNeX2LCUAyB3NRufo+QBMh83RojP9wbjeoKtLi5s4b7IPLDT0XQ==@kvack.org
X-Gm-Message-State: APuU4Z9W5uSv04pVEmz5MJ1aAaUmKXqUTigQlnBXtSj20i3Jlzg8hydr
	IugikabNUInRCOpfDR1Epdfx6FYhTXbYE1cFFFpiciTVWSXpMQnLSkBiyytiswcb2XM=
X-Gm-Gg: AYBFou3GCwE3r4V5r5bKaBn+g5zxBZqhWloxQfygAs89E6ZZ7S4rvY8P0sNIgeY+i/z
	vFofpUieD6mkpgSCy1qh7Wkw5pxuo/JhCtuya6YkYm8Nki3tNr58VrHUM7NoU2X1znva5N34L0R
	agbVNNGyZBleTM+YTjePXsxk1x+GN04J0tPAv4p5p9z7C07HQ3ZqOhNoctwf2dfwcezfpidATL8
	0TLoWb7MhyZly2yt9OdzokWF0num30vKkiW6Lr1vBomJrDd9biLJ8C36PxpgzQtOBjac6t9rO57
	ibXtGCSpOyGPhiRdPTz7wwbv1NPaLQVXLULL1N+qeYI5NV38c89QbI5TkwBataSBKd1IhWi9rwR
	SKi1e8k5dALibOAwZUbxL70Z6IZVPmcx5FaM11bP4a+V3GACr+xU5099zI6HJPaavb4r53Fny1U
	ldAIUOmyLwyzg487CgI6XNLN6rNi6hGnTvpj7siqtLInhg1i5Riws0I/joOrlmQF2N5rW8ofVaX
	3whKCwAbqZ/fl7eRwrOoOTwKPf4u5Ddicj+WNcqTaA8aGEmbfK0atARDFU3o+28z0Sj0J3GbmSP
	pK8vjvhuptmyrbHCuU5CgbYJfTEOZI+WhgmCBQ/IUxNn/fnRL+oBt6vUY9bCLSN1DZHbxfV3TyS
	aqXHr9ak=
X-Received: by 2002:a05:622a:598e:b0:536:566e:6b52 with SMTP id d75a77b69052e-55ac7564a85mr62222541cf.27.1794606152109;
        Fri, 13 Nov 2026 13:42:32 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0349423sm27363181cf.7.2026.11.13.13.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 13:42:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/15] hugetlbfs: fix integer overflow in fallocate()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@kernel.org
In-Reply-To: <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
Date: Fri, 13 Nov 2026 16:42:30 -0500
Message-Id: <179460615000.482102.14809359037930927808.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14DAD40007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: x4g49hmtizh9rh8ihbzss6h5yytsmexm
X-Rspam-User: 
X-HE-Tag: 1794606152-766193
X-HE-Meta: U2FsdGVkX18sozImsOBhXguVfvmnyHylHKAFKvPRH+M/cgQmmQ3rbDs95rRok58DVT1QSUO7qCGpvElmhm/yK0/4cqPU3HxsROLNSc0wvnNkiL458yCBxaJ77am/ir+7tJY1dY+Z6VgRvZO1JfgTE8jYQuZimVvVkCaxn5ZdJCrziFigqVt7WN1uxAjamfOcRpk239xzR9Q8XC1zMbrvaYQfAKr2wjI/B9BzJ12K4rVoYtGzuxW4XyEhldFiKUxaLiwlgtvNtyuZ6IHfwaEsNgntJeIgCWpb7AxVe+YeFod82txW+7u+7VaONZgdjvFN/3M+UlqBGgL+xI+VXDSdBiFlyJDcWCahWm0xp4wk5CR7tW32cJWrs8GPJSHKfDEFYRTFtap9iN7lhidO8d08gro10NNkKY4c6XwFmSsKXGhIsQYns6Ms97TtF6Yntkekf2VqsG/51SZfOW5IAbgtxoj6HeJy3heKNC9DSifPaw5UjbKotjU1v7Yog/40tu/O2L2ua0jxOzaHzoqOBIUEE4YrDqhsrTLWTg+c9WZO51KyHuEcauVQ8C0xR4izURtD8uUlgfaCa0BIf+sLlaL4yavZbokcFFXosVQaHD6RZMs9g+65zvaIEWHoDF/nzJSrvkF0zlIABSV8BpW0fhgjHeGHHn1hxIB+CInA65AjVV5+nlSxEtE7kqMDIDSteynHn/JLUPF7eUQhj9d3x/denOY45zGwgjmrjG9U96eAhqcGxWy88KdBEOoCqG0Bt80ts+yZv2699F8EEndqtoeqcxZq+8m9jgca9jCyQklPFbv/BIxrfGMMi0nmcu/nz3IDaocoNytB+//p4cx8T2l2qgYT2P1Z05G54qNtOLKS1Zxn5IaQbuYijD4Kp2HDsm4wzm9EeTWlFBKchEhzVsnyggb4crUcU9LXyItSFRwrv2md5tlWMuYSxpTiT6qvFardaCUuqizxjFX4h1ORcrB
 sTRaylHf
 syp3PbrJUTcwpS7dWLIV+GHoLTk+IdCkq4Q+nJ6HQse5AzhEkfOniPfj3oyvlW9gCxZSd9r9vaVajHMS89KUR7UfrhFpfVhvKGIqGDVl4ZmMNJis0zgHN06Dl0ghhM3YKrU4uW+40Jfaf6UNFD8vwZSbIYP4AUmfDAMsTipUf2MFIELx0uJEr63hotl01vBmQNa5Lel7eQkrNjnh0GyTtMnen/LWX+mFmQCCo3Eae7Utn2o8+G0+6R/e7ZRsyfSYv18zueop8dduCG1uIWhTV3/N/ko3cwhigh/PTG5SazIolmW97dYcNLShO4uwTBlUx3rG8geZUPcGbr+ZR6M4lMFfYNTV/1zqpOgypg/KNbyziXULsFvOoTcrA9hpJWyyx+MCSKOB9s+UGPDlew4IFpbkXR2spnN6Ks9wY8UU4NymCWhmBLeYCM8TlSKUB/1/Fxs7zqJ5onRb/LAr3274oFy/7DdP70etXgQne4IUsWq+yE38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 21:13 +0100, David Hildenbrand (Arm) wrote:
> hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
> to offset + len. vfs_fallocate()'s existing overflow check only makes
> sure that offset + len does not overflow.
> 
> Once we overflow for valid endpoints near LLONG_MAX, we can get a
> negative temporary result that is then converted to a very large
> huge page index.
> 
> A one-byte allocation ending at LLONG_MAX can therefore consume all
> available huge pages. Pages added beyond LLONG_MAX are skipped during
> inode eviction, leaking them and triggering the BUG_ON() in clear_inode().
> 
> To fix it, calculate the end index in a simpler way that cannot
> overflow. This also fixes the signed overflow reported by luojiajun in
> 2019.
> 
> Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
> hugetlb special casing in filemap.c"), remove_inode_hugepages() must
> include the final huge page during truncate and eviction.
> 
> Reported-by: luojiajun <luojiajun3@huawei.com>
> Closes: https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@huawei.com/
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
> Cc: stable@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced the BUG_ON() and validated the fix.  LGTM

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


