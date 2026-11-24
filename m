Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2646606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZSbg36dd
Received: by kanga.kvack.org (Postfix)
	id D2B0D6B0604; Tue, 24 Nov 2026 01:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC096B0605; Tue, 24 Nov 2026 01:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3746B0606; Tue, 24 Nov 2026 01:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9697E6B0604
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:46:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99A3340AD6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:46:11 +0000 (UTC)
X-FDA: 85469078142.01.825D2CD
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id 083A3180007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:46:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZSbg36dd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795502769;
	b=22jP9KXGmp0qGoZexSL3Mrn5ahVvB+20zw+8adKuWMLdjdstQXF2gHlxX+Hfqd6EW9fZQD
	gHTL9/TbZ0LZEc1Lu91ftaqCNlS3y81KxUB9DPjXwZtfrR5ZbzXxk/dH9GxEK/YLTLvjXV
	6ahmf3I8clmtg9feUB4r4/eBWNL2Yno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795502769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sYa0/MNtMTPTssKXuUvurm6SMBJrP8UAVrLODQe/N4=;
	b=Sr2NbfFVLhJ48dLt84axGdKGLKwJ5zl+oBky0mVAvr1rGcAf7smwy/41dSx4ce/8ztW+DQ
	WjRMkErq43t/Q04SeScGitEdlWl8pxTNo85trXfe4nt4cSAxnNiFIb1TjQOr4xiNrOATq/
	SlnVTEA6qmNRB8l8xIPTlFcbmj+bCcY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZSbg36dd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3npPxS4jBIhlVFQxRwHh1gdVjroPM5wUvVXRudY8btU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795502766; v=1; x=1796107566;
 b=ZSbg36ddJQt0IyrYFFmDCxLr7kCH7onTvkTJEqrP2fF3OS0DxO5r/b/f9srvYr4hP9PZ2Un9
 xZH9Ipq1R0t8aXi3dn5Ju4pIxSamSu1SdginSDYcVDDPIN4ZP9yx4e+gHULSPh3tYsOfr3Lj8pe
 aeKZnGRqp/24zRr9J8Z6FA1k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id eea903533936a8b3;
	Tue, 24 Nov 2026 06:46:06 +0000
X-Mizu-Trace-ID: eea903533936a8b3
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 14:45:49 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <awUyna_r2Iwxu43f@bogon>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-4-baoquan.he@linux.dev>
 <awR-0mcGnK-lM9EP@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awR-0mcGnK-lM9EP@gremlin>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: o676sehkis96nah5djaw9c9ud1iu771d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 083A3180007
X-Rspam-User:
X-HE-Tag: 1795502767-714794
X-HE-Meta: U2FsdGVkX18oCRDzEx6rxw8JvpNSEs4W3shyaDPx5eJWdZum9A50F+2eqPw2FZY2wj4Yjd0mCdwX+CQazSNfLHqmqCFwb8rui65MmO9ncN00TZWSXwFxld9mjnVHn5v4EYS5izHcgo9fbx+3meI7DeUu6bW9JVwrcdRDikFeYzKycjhozfZzuYGKfKBLs0oYC05Bs1t3a/3jwFTibK8jMdKcx8Vm2FtaFkF4QhHKi7S0vo5j5Zh9ZP36k39ROjU5N7gnRyzhtInNDJ2DLMZolslEPF0uTyZY+e2U2eDpu1RJ9i6bzuPkteuJD109vb94jese4HM3lTDEJ7LxGxl01SIc/VdfmxcSNn7x4sOb7kIni/gj35zaEBvkGVqDjMEwscNcaX1jAf3U8CJxsheIO7mby4V/qsoRN0KZQajMDVSoAL5toKwFXigegoYvh4yDIGcZxBaGZWjLJfoFFGwk4gCOBAE06UQBwjXCoANDYiYavKiKtNAWRxJkh+sllbqFa1UytSc/KGi/X9lkxRmNsMisMcLrQQpA5XO612LkMhc530ravHqqLAPyxjCx7bgjijMRHWfDQ8r9JI5MdHC1XcQ3YuyVIlQyx9/WdhMxiJVMpgTCYzqyEJr8eFWOBXGS0rxfqToUIlGm1bqmcdrINLkHqut97GasTPhnL4KV2llqYJoLyw41NIesfx1ZYhbeDfV0EDX2rqCg9O1LpmyVgc8QG8raYwxcO8iauubBhIpjtOwxpq7DSccIam5z3Q7p1fOf7PtvjcmSVcsxH5uXZ3wJFW3iv/WP5G9x5bYU/xRXk7W01DgWOFukO1Mop5HJ3avc+FxpSryNFNZPOAmuwmKd0nQQDskuZSh/EbBYuTu/Xy0Mbff8kfILWebhA+QdX85KZ3EA/oFEsn5s/wqjb8vbCgAug/zYM2mceUPmioGfbD2Z+AUG/BDDF3ZMWsxUNAZ/6ZLgbRMqI4g0lsc
 cy3mfKEZ
 RLePI7BLHrR4ujyCXOOeR5IDw/5GrzYOOFWe32Zcc21CtiAfstuF/oLwwTn6P2EVP6XzzSZTjKO839WjTj8qdtmQ6wZwxwCZjEHCIaesPhoIwJUBFw+G8izdevsjlXkSX8dkQLl+Hhr6Ml1p8pQFsn1aBzXeLXBygkpSkW67jP+7woC0XkW70me2TlKs+cyXfGQdQy6f6uDg1QnEiKTbqrK2WT28259gX5VCqS9SF3pM3uH1wAMQjpBOPzuMGenv6j4eIiaJMLKFXEHh06a7g8NSSpiqr61vDxmM/MHCDmm8x9m12ICKu51jxg12zjxo+Jx3j8+9MA6NBRxYR9sYvzilvdbODPgnpwk/ER5FBiMJ69CU0qNgf4UZpYycLccpVTYvFWp+n80UI6Xyih6szaEw88FhqmVx+mHvh915/3Qoz5qxqQMhpPBGiUfhKptb7Lwu/jn7LnCJWCTgxLCm5uZQsqkh5fHck5mVFFeRTuc5snW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 at 05:59pm, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 23, 2026 at 04:57:59PM +0800, Baoquan He wrote:
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 65646ed6fc45..ea5ada45c09f 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1004,8 +1004,11 @@ static bool folio_referenced_one(struct folio *folio,
> >  				referenced++;
> >  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> >  			if (pmdp_clear_flush_young_notify(vma, address,
> > -						pvmw.pmd))
> > +						pvmw.pmd)) {
> >  				referenced++;
> > +				if (lru_gen_enabled() && !lru_gen_switching())
> 
> Could this be abstracted a little bette? This looks to be embedding an expression
> specific to lrugen in rmap?

You are right, the "is MGLRU in use" test should be kept inside
lru_gen_mark_pud(), so the rmap side is one plain call and rmap does
not have to carry an MGLRU expression. Will update this in v6. Thanks
for careful reviewing and great suggestion. 

@@ -1004,8 +1004,10 @@ static bool folio_referenced_one(struct folio *folio,
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-						pvmw.pmd))
+						pvmw.pmd)) {
 				referenced++;
+				lru_gen_mark_pud(vma->vm_mm, folio, address);
+			}
 		} else {
 			/* unexpected pmd-mapped folio? */
 			WARN_ON_ONCE(1);
......
+void lru_gen_mark_pud(struct mm_struct *mm, struct folio *folio, unsigned long addr)
+{
+	struct mem_cgroup *memcg;
+
+	if (!lru_gen_enabled() || lru_gen_switching())
+		return;
+
+	memcg = get_mem_cgroup_from_folio(folio);
+	lru_gen_update_pud_filter(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				  mm, addr);
+	mem_cgroup_put(memcg);
+}
+

> 
> > +					lru_gen_mark_pud(vma->vm_mm, folio, address);
> 
> --
> Cheers, Lorenzo

