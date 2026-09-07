Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864F9C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9972F6B00B5; Mon,  7 Sep 2026 06:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9471F6B00B6; Mon,  7 Sep 2026 06:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CE86B00B7; Mon,  7 Sep 2026 06:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 617026B00B5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:28:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED68280707
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:28:07 +0000 (UTC)
X-FDA: 85186591014.01.BBE1979
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1FF3C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:28:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m cY5I/U";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Z5izyY1C;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776886;
	b=JFPQ4w3HZbclmR3s8T1T+YpPHpjlHnKsXPzhTKKT5sfY5lnnUH0OiR/Q2UCf6Y86ZTBoTM
	tifJhO8uHobSgadVVHweh44d/9DVDLpCNEPC0+ESXV6jscNXXOYCUX53A2UZHdLf1Opbm/
	MaGRYF1LtLRZuHEcCK94ePnJ0jbLe6Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="m cY5I/U";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Z5izyY1C;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f59EBJC/4ov46ZCcEJDi2RPpWdMP2hCDD0qZyQ2pkiU=;
	b=rin8vmBguu5S12W1ymUxoGW+hZkmbjJH9Sxz+d7C1j3GzZYQV5xWg8YQXJ3URR/FtBtdNk
	BxrBN9HLUhH7Kf0hmKkA6tN+0Ommt7qX40wgdwTn8atQSf8QVC5fpQplHOeH7b3Mfh7kEL
	nmO2Ii4ZSc4jj0AiLMX0jYCMIZPq3hA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 64559EC00BC;
	Mon,  7 Sep 2026 06:28:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 07 Sep 2026 06:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788776885; x=
	1788863285; bh=f59EBJC/4ov46ZCcEJDi2RPpWdMP2hCDD0qZyQ2pkiU=; b=m
	cY5I/UfwYFSeAQHuzewFLmqdpoFEUWE8AUwUXGpyIWk3U/X3jOecLARtpOHj+gSQ
	NjmfDNVWPu/oznccqL/+5Xh9hN4CIZF52ofRgi+/jNxZrCweIIR9bL2wO2anieT1
	vZh+WY6asXA9up7/4v1K7Qp91tmpg7Wp9UC0xHXiFGsJAsIsIumsq7e2C5t20xF6
	RdmHvJ1gwbdQ2aEepyn894x1TYolXxrzIjhTbCrEurH9RniO1MSQX4Ba29vaoqH3
	kmj9+Wnp1GoL1szROGPkUVHMfdHlv2SpmugHniWz1Zpxi0thtWQF3T9K4YwWFzqV
	5o9TyCSavp4zCpuQymPhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788776885; x=1788863285; bh=f59EBJC/4ov46ZCcEJDi2RPpWdMP2hCDD0q
	ZyQ2pkiU=; b=Z5izyY1C0skqDUJfbFnOn+ebPFhIIBFXExxRMGpZWzZfY4Ah5ss
	c8Vlcfymfnhds3zbdOU77p2m1SL9uFfG13kdYR/ccWDOzE9oHwJH35I3I/pacsWz
	SgHU2777P6nP+9JNoe8gs8QI3sF1osgFxf8d9cqWrVJARkiKO6y2K/dSJ9k1QUIs
	t5KEPCzVQfyMFypOaT48rlUmOkHr5hjcxhljb6lv6MNUC+A/Fo+n2EvP9HPfHS8E
	+O+QCu7VSDR7AK7thqactXV3IkEOjQx5aASS7ivMPcN/O821zzJy0UYL34EOkrAa
	hLRwfV9XwMu1XhExJ7265QZ/LMjCbtZmJjg==
X-ME-Sender: <xms:tJGeaoU68yoKoEKdNauhVIokwD-QzoIvT8BQpYex709Cnp5m2TuHRA>
    <xme:tJGeaqMjX2b_OmRAMpgjktF0t30Bq7KPQ8kXdBU4efxdWZOHoDxQiiM0T5Sb5Dm24
    1geywWZnjZVkkFsxvGvX3s5PJQMv0AVudIftIdMpz5qDoMKWbcQ7po>
X-ME-Received: <xmr:tJGeajwwAxT4V_izDNGfW5MaQWjScU3SeMhZ01oJQyQ5ajJQP_soJQOdT4w>
X-ME-Proxy-Cause: dmFkZTEajUuK27hQfEZdWhLtkuQZ3pAPRpnx/tbUwrc/v9QlT7g/7Gy66eqONUzN+j0KBI
    l9/1HIG3BYS2JhiizAePa8ggrFALJu6WrIq5DugLEZ9a7i9lU6Kcy4CsTHxBKoJHFgVZtg
    EoJWTuvYf8HjIhz+N5A9ZZVcXSMS39pLs0Z+g+gnz4US2YclD1wx2uEzQd25YzHXGVhmkH
    1Z/lkmjVpPq44tqalmrZoouDSgm7HOL47Iw2w8Qen0V0rRjW95Xn+RtTBdFs1xc+q7hZPg
    PbWznKtKwvBgZZzoz/0Nn7E7Ph6ChFZkxWNQ7tTQ0sC9kxSKpIFubwJAqwhcS7cSQT+rP7
    ZsvtxuqnS2jfe4UAfb4iqVGGXIAQOV2RKkydq+mrzLybVQMeYKEIFHHnK5FbFzu1O7vDr7
    OFDILwOpljnp2cc0K8Cp1GyfjtVTwUWsz0edZAXiRr6AOjHVEEygfNrHq4DcJYfAu6Ms2N
    H4d5G5GfjQGebOoh6Io3B9H4EFlxevLH5OrQIqRZjD1sCByP77ekxKA74pEbNrWLhQhND5
    cH0rjs+I5KQT7Ue0GQCRGIHm5hTYSfgWf7dWfF3JCIlKsqw0meMCjnLDVKzQnnjR/s7veI
    5rwIRyyh98hRpgiOmvsczZH5JC1Ij6mAm+VfSBKE0Tdv/9pJZoKuexWMkUFw
X-ME-Proxy: <xmx:tJGeavg9KbQZkPJPU2BVND8jY_ugtwEzD8E6HxozUhK3-lXN7-t0_w>
    <xmx:tJGeaqTqw_2psIBP3Yjtji3iJzooW-NGeMx_zgi_j0sRtdpEHVztXQ>
    <xmx:tJGeasPA-XuufJD9MhXSGFAkTn3ew630p-QOCOTZWU_wJs2uih16Vg>
    <xmx:tJGeavGPKAUScomINHIH-7FyDsSbFs0jSHNC38I1Q96FYHf14Ezkuw>
    <xmx:tZGeat52CSqtoFjqX435ryj37GF0Yj6NJHFpPpruDQj2B3-FA-KFMUC4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 06:28:04 -0400 (EDT)
Date: Mon, 7 Sep 2026 11:28:03 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 00/12] mm/collapse: separate a collapse from its callers
Message-ID: <ap6RNHS_ve88ijLo@thinkstation>
References: <cover.1788533997.git.kas@kernel.org>
 <20260905172342.72be31534af21871f8b13f47@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905172342.72be31534af21871f8b13f47@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: 58bmjteexrhyqbt14wna4uoffig8ntsc
X-Rspamd-Queue-Id: F1FF3C0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788776885-805514
X-HE-Meta: U2FsdGVkX1+tLjoxjNV9238aEle8pWBgs6rdHCBT9I9/X62yuvQA3C3O5VTYSXL/0pk16HChAr5FkIPXP55PsAU4khHoeF19/8AJUfy4z66cUSces+oecvLk2BXOQzeDrsPGGxnzlKpAnoDiyaEvyatfTiW0c5iYeeqQJuHfciZkdmpqZP9q6rLpS4xrQEjKmlwDHQrCRbzYakuOvTwTzkRkh9nW1cWGpgq+86xD6bYdgnB+rJttGab8HkwO8Y3VjTb8RfQjhG6Vj7c2L6TXMK9kfiLUTV+p0MeZxKbY/EnIs/O8h6NJBNmpaig19smSv2QC2CluyO+KQxWU6qJBFUmviuSDXQC/wyt+aRH/aOdTA0wpkmsrqoCdW+AnwmIMWhyEmmZ9Z6/92umvbxANGiyoSoFosI3A3PnnTme4TxOn0DmZaEnLs7r/A3Jkmww7LwcSYhJJ5SiehYX+q95cFdi4NIVzWwimfIsDFbZpCWJxQhZwbDMdDeRoD31p8sbFEDXFUC/q+MvjWT1w0B+9pqMFBvCGkeZSjjHq/xlGQkhnU9A6qyAQSHVPf3dpm6kdmM4lfE0Sp8XLGHV8M3pvlvqy6Cvtp4p6pBznly540/eqITz8Pk41aGIZyYu7HOR2ZNIVqFOY2DirVgje44IoTKBlUWyEB4mhgIWs7z1/8nSl9yHYpb5ETOYwWyhSAGScQynaSrO3gPizZPaFX8WFO1HODgKe3FwGGtVMWrURgwIzrEMA6TctHf4jmKCVUVE1ucBH3Y9Vv5saVN3E4EEyRHbu7U+LCctxlOVbfsjJROkvBXnGxqMbGEpzcwoXP+FL2b1P0f6ygkg2Be0kDXv9tajOj7RkalEDUvJZhpJQFnflItiAtWpcmIC6Mbn7pfdjPrRo52pfHvOFPlSMUSBJxkRVaWM9wo0Lae0v59RU+XN0C6K4NyykX9JjU+Qwwm+aiXGTwIr3EnyFO0C3y2C
 j72N6aB+
 Bj8Ya7kCHidHibAIfPaIuuuX7+2NfUikOFAPSbJZ+jRrdc/k8NFK5888lR8wxTrdcUhA2NAv3z6wZAqi+KyHp+HgzEN4+5caAR9rZ26eDoPc64aIQxeSrc1GGV9Pjypn9UDYe+63f/C7Hyer0dyGMHeUpZM352yulmnC/xIMGlaYu6HfCjuwWG4jxloKsJ4iVi86PQiu/bahPZLK0V8TeanE6pCHscNQXaAThnNpW4bxJl0MnXyxX/wNWk8O54uijHGtF4uEMbXk+VG5QxxHy6TD6d0Jnae+i6BKSNAoGL7X1OiBfbWN7my9GXi+Oa7uZFmz8jgAqxmxKU9HamRbhyY1vK7NS8KcmjoxwD/y1kzGv8HXOYTqj3OwhkegN9Uid0FSjDtPuJxpYF+VPyB2YttiqX8sjQdK6fslWNurX5v8kluqCcM1wnwKX6US2tyt73wFa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 05:23:42PM -0700, Andrew Morton wrote:
> > Behaviour
> > =========
> > 
> > Nothing here changes what gets collapsed.  Three things a reader should
> > not have to find in the diff:
> > 
> >  - Patch 5: khugepaged fills its policy once per scan pass, so the
> >    max_ptes_* limits and the defrag setting behind the allocation mask are
> >    sampled once per pass rather than once per table.  A table scanned early
> >    in a pass and one scanned late are then judged alike, where before a
> >    knob written mid-pass split them.
> > 
> >  - Patch 8: mm_khugepaged_scan_pmd fires before mm_collapse_huge_page
> >    rather than after it, the scan having returned before the collapse
> >    runs.  Its status field already reads SCAN_SUCCEED for an accepted
> >    table, so nothing changes there; what the collapse then made of the
> >    table is mm_collapse_huge_page's to report, per order.
> > 
> >  - Patch 10: which orders a table is scanned for is sampled once per VMA
> >    rather than once per table.  It cannot widen what a collapse does --
> >    the order is tested again under the lock the collapse retakes.
> 
> So is *any* functional change expected with this series?

No.

The three items here are so nobody has to find them in the diff, and
calling them behaviour changes is a stretch: a sysfs knob written
mid-pass takes effect on the next pass instead of the next table, and a
tracepoint fires a few lines earlier with the same arguments.


> I'm reluctant to merge an unreviewed v1, but this comes close!  I'll
> sit on it for a week or less, see what people say.  Please poke me
> if/when you think it's good for mm-new.

Zi and Baolin have already provided enough feedback to justify v2.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

