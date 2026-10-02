Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91224CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B7A6B0088; Fri,  2 Oct 2026 07:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302F96B008A; Fri,  2 Oct 2026 07:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1256B008C; Fri,  2 Oct 2026 07:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECA766B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A413806FB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:08:16 +0000 (UTC)
X-FDA: 85277412192.21.A74960A
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf18.hostedemail.com (Postfix) with ESMTP id 42DD81C000F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:08:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T KIqkZY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=C2RLXdsX;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790939294;
	b=pkoxEsAVHP2uPLbXIkcHLWSN6Y/HHF0KWCFwk3vsXLXgSNMWIczi+t2/XxOmbRFRexXYSm
	HxnJ3vMvpqzGDle7HGwOZf83Yi5hp144OI4vTPxIzzZI6wPzhQwkgcZbOdPz1HHZ3scJr1
	gGIrWwajkFMns5wOeUNLTaNnDi+wnZ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T KIqkZY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=C2RLXdsX;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790939294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrR6OUaCX5CDWnI61xSEBYpaGhAGjsqwnjVR7pcNAL8=;
	b=oD9BDDAkLCRQYwEW7tYqjPJKt4op96xQqvoqkNNIzuq8fweq/GzHnZMH+S+D8/mS5E+RR6
	tBZLe7RRjYDUHClhG8BsrAZ+x4enQ5tLgzgOG9QgJK34HAauNx4OfHrd3Vyuj6eTFcaz4Y
	Gm6aRcBvYZVlbLHIYvjuqpAH0FkRNWo=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id AAAA5EC02E8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 02 Oct 2026 07:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790939293; x=
	1791025693; bh=jrR6OUaCX5CDWnI61xSEBYpaGhAGjsqwnjVR7pcNAL8=; b=T
	KIqkZYDAn3QoGmwq//hBAiaRmnnDyIhe5MfE8NWY/ntmCCfKZN7RCwJ5jVr8e8jc
	q/dRSjEnuxQsYVi2NQaRFMMrpIvy2XAA2gw6OAM/9S/CO96GYyuwd7aVuvly8EAY
	XUUMwX84Oi9S18LGg2A08w9yC22vhjSz0rClCUyeDT2jEjt1RsswmalS1Y7Kyrot
	IeTLaXlWEHZFDks6Vwddfvz6LZC6YCpwHjoHKzPg27I2VgdI0U4+gZoLvE7mXj8C
	z68KlAFUyymXKxrsD9Qw89G+WfmbGrma/Y8QNhN5uaZsFo3hrnmlQE0sPyrm/Zsn
	dxQqwgQnaCIqclHhQO0vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790939293; x=1791025693; bh=jrR6OUaCX5CDWnI61xSEBYpaGhAGjsqwnjV
	R7pcNAL8=; b=C2RLXdsXRHNKZ/hGDFofkCpT2htpUPLYe6JlEuihHUz4nerP6y8
	kR3/tcZ0xxUP+LtV2Ev+J6EXUnzcCEdvWu4nMqwVNA9aDuIxjjwQwTEOFDDrB5FQ
	tYimt1b2pEso+96tN7SY7CpyVMtBho3FbITph3htA9ln1w3t6lpP9Ghtj5VY0NfP
	ut1e7J7fJVzDMkSq/w8jskbKVnuoIdx7DkFpsAjilY5egOl2n2yhFRGdawNTClcU
	wXifHKRCybNQzlbUoxi4F4gdYSci8Z0D4jqL0ayfQsyiIIUmkbR40NNHgqJkPnwt
	CFfjtbUjq2ZWbZDe+NdHtFEyG2Md5Pj5slQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790939293; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:dy0OXYrH1DMkWsqME0zRuqVeDUp4Hqk0Qz7komfRDjx5p2V
	Hu98IKa8VwjDum2DOMyzmxkbA/1GqktF9FPRQh/QLpgODa4ay9bwx4HlefVYuLVw
	VZK+jml/nOy9DcG/FaUEbOaNx+rno+SUlDD4cumWFMT4ywU77cCfWsd+msdWzl3T
	2UspStR3Hsv97LMPE8Vo/hNqsWcys4F1XwzTMjsrzoH4qUmYS0AAF8bFpRwl7LlP
	VZWFSM/3kedHiA/B5qSgUoGnNaY8VAkMFCNzAtTpokJTQ6pZpPgvNBIdlCcHnpmW
	+DUndb/hTLwLNZZ2Hnu/JwLbXqw6ERuv38N4deA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:8ol4EYGt4R+FErTp0BTFN2l3nhYMwUXredyLtkLdvIA=:Yxvsm+EpuAAh+HTcOlmthJbkprok5JE7YbbSuBmbdJk=;
X-ME-Sender: <xms:nJC_atm-Pcsr2QON35QNbpn6xF2n9iZrJBBE3MLN32vJQK8w_9BfDA>
    <xme:nJC_amfzbG7qnMYlpZ9Q04OPfEHdQ1Eq-wlcFc-l-5apYW4vDRh2hm5xS_v6CsVh_
    CpV3mTLF6cAuSn5AgH9dBVjuwnqbeBEFN12lbhCVFvKNqZ5nwjvcHs>
X-ME-Received: <xmr:nJC_arC-Pmv9tI1iHpUCnUl2EE1QGMDVgVVfaz5_LvHnxUR1GFNiZouNfok>
X-ME-Proxy-Cause: dmFkZTEnKtj7AidfH7fVYRV/Gu16ACcgxkEKSxWSUUMyTNmc62cb9W0oVIihGd5C5eEShn
    odF+vZX6J1yUfdePX1mU3en4NP1xdbwc7AxJREZkF14IWEdHwi3xhFCR3d59SRdN21aYf9
    QX0zAh/3o+TfdeDAFaBDqoiyEkpDs1bcEh4mBOGwmT7PXZNVWB8A5GT1YE7+LqT9RNc8r2
    GKsdqIDh+97RcZGZymjuD3g/wxQ4U1b7PwYZM8G3uU60G5Wa/l4/rVKcytpYpr0t//DtZw
    EXyC5IJfLn1RdNnEza2DaXSPFXqWXHMpAAbU4OweAydjQ4Z0Nvh4aN6wSH3H+Y8aMx5tsH
    YYqjUX2MyQZwaAQCvw+lGs6zg4ZaGRDkGlNW+2kF5+NNHZs2E1+lMdbC/9Th9NKIk8X8oM
    Aa546ci2N4D8zXggSEzSQ94AOoX6UEBjuSW89M2/hTV5k+ubqbsJt0ApHEnIDTypFag6eJ
    tk4lwUmEa9x3f2/1RgxrfVwFYdJgd3CBIuTpDcopyUkEI3JGSH4QfNdVueqDO9eQ1n2Tn2
    L9sDsztXSkAbb9XVHTAcDH4ew7lQpEgLmqWbgF5aZBbITx6cySFGNbsfj/1jA/0yPWOwVq
    hgfJZu3WBI5LOrj52fyA5Mdntdh54jcDk3D2Wmq0Yw1aVlA7aLuEr4kCYV8w
X-ME-Proxy: <xmx:nJC_alwdcUUK6Fy0aOQmDBoq8l3_FA7tucWWPtRCqZDZGwRWC5-M6w>
    <xmx:nJC_ajjgQRSywVEa0_NNEBgx0Ry2U5AUzL6qOlaDzvIDtdcKp059Cw>
    <xmx:nJC_asdIrvYnGkwl4aO3urbwitc4hAN5Nlog-ukLlsurf92DBRhzHQ>
    <xmx:nJC_aqUR6lGvQ6ITR9AyUOaZURU1Bv3j6MAg2hBdn-eBl2gexjayig>
    <xmx:nZC_asL4jBb3nU_ezElDUXVqc3wDz4K-QqUPaieLGEqXP1iG6PdU61fS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 07:08:12 -0400 (EDT)
Date: Fri, 2 Oct 2026 12:08:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 08/13] mm/collapse: call collapse_file() from
 collapse_single_pmd()
Message-ID: <ar-QK2P_3Lc_YCkd@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-9-kirill@shutemov.name>
 <67034af3-9849-49ab-8904-6d661178222f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67034af3-9849-49ab-8904-6d661178222f@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 7wppsjy4nu44kf3cph6s9hj655tou4j7
X-Rspam-User: 
X-Rspamd-Queue-Id: 42DD81C000F
X-HE-Tag: 1790939294-585432
X-HE-Meta: U2FsdGVkX18We3tU84YdxzoC911liyABdQC7BhayU+Tg7t0l+bFHYCZibZlm77/2P1seYtzmWCYNV+ebkFXnObQ1BzXfUpfVGxCv7jfmNPddQbdoOWy8GO1T3A0ugGYNoqPgB7BHH1Z3yrmcfQU75fpSa52BbEv1BoaLCbNuwhNMznpfAZydJWCYfYHweVHAIAQZlq7H6GkJXapi6G5jqggfDTd2Bn9OSf+utQ5CCw+L8k6EDhjceUfG5IO1bdTQkxVx3wjDnqXbe3kJjn2CBmiFEAw3rfnRVk90gyhvFJ6YwqMd7FnFwES/vYcqL9qJZgBA7G1HGatOEtII6oIasyB+O3CLyRbNrUPOwbEd/bD6t779hULx/t6cS8t8G/Od/j0x+kLPtvs/JB7vWMddqsY0PCI+y7Vzs/kxmnFAiwdtVSqbDXBPJghDXtBrTEHMgkcgDof4hUgKb05mAUcQThaCQSk74eX0Hz63jWH76LHYqJ7pEFFidoZivHWjx2uYmUBE42JpbxhdEY91y/WqhH24pr1pnG1u29s/HQyM/KEA0aEFYS8YtyMuLsSHU+7ztMqYbNTNS75W8dzthLaNy4i2U5/0wlkeaOiD/Y1/da8STNzBfRuz5VuwaYMNHaS8S9miALfX1djEc4rRCfCg0iUVge6Iqoa70vtvG/a1ZlKVm9eeVWN2sxGCNB8vFPZ4mxW/9UqKapSW2c5aURZSCLsFtokQSbFq5jwGdrh3TOdcUMGgPaW2W3a1ijzmDW8T38sCBdF0hzDFKCBjFCnjoJPvYHsBqRv66pdihqqvI9kdvyoHWDdGWpZBSbYOQLccPZAOylTQuXu4E6pEfJr5EtlHkoKxw9xiBI4UV8ru3I09bEvwq9VQbGWrTebR/Q6dPu3NKaGe0JkfoA4cuvKFevuN7LYtOwa7MZINppTrYgiNZ/mowroF9K3Vhoq7uefyH7tHJ5F3/Yh48Ya3Nl3
 FoN+in9e
 /PH7YEXzYObXpARksAMar3dGkZKrWyxoDln0iXAqXpG7wpJfK8kseId8N8XD79udCKDlMwBDu5DJKVQacnxEry+Goz7q4ykKyWmzsBzZadMorxBWzf/gC0hj9B4Dk8d9xKgN36oxezzSL2rz8XErAue7Bc1VJf6Kb6bIzPhtFEGe7IeFDq0ddhnz7k1wySvebAIzY90rM32vF2Y8gPXe6HW5r03SBZ4WqcRQhAoRliPNO0mV2+VFM8x7k+n8QjcqoNZ9DOC9iJBrTqxPxLuu93iQaUpWouR44zL+OpEIlt1CbC/XIDEMCDuOGqu+AlqrdhFgKjV8vFdoiLI9MqZTyczv7Uku/pBda64BwHUPlX7eGk43zk60A+tYIcN2EIYf0Pw4SOguw4B4ybdACXPn12CIV51ESI6Ax+KGKrrraJY6QgY5LncCNNJ1avnduIB79FWJq7mnRXDN3YUfea0DnOI2q9+8dMK6Qlqh8t2U7NFU0Mhj3E4mPHpWb8SdRNHS4t4EeX3lSrxDRgTuohPLJaiexPVQFrygNMmpXxmHJBsEws9oGyfrL9QNkJr5JljIYSYZcK0zIUVCQAk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 10:08:09AM +0200, David Hildenbrand (Arm) wrote:
> On 9/28/26 12:06, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > collapse_scan_file() reads the page cache to decide whether a table is
> > worth collapsing and, when it is, calls collapse_file() itself.  The
> > caller cannot get between the decision and the collapse.
> > 
> > Move the collapse_file() call up into collapse_single_pmd(), so the scan
> > stops at the decision.
> > 
> > Two things change with it.  The writeback retry re-runs collapse_file()> alone instead of rescanning first; collapse_file() repeats the scan's
> > checks under the page cache lock anyway.  
> 
> That change wasn't actually required for "call collapse_file() from
> collapse_single_pmd()", right? You merely decided to move the retry label in the
> same patch.

Yep.

Once collapse_file() is called from here the retry can go around the
collapse alone or around the scan as well.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

