Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AC4C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 22:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025466B0088; Sun, 27 Sep 2026 18:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17FF6B008A; Sun, 27 Sep 2026 18:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DC36B008C; Sun, 27 Sep 2026 18:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C44E16B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:55:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE863120631
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:55:13 +0000 (UTC)
X-FDA: 85261049706.03.7DA4979
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4960640004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:55:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eIGI0kb8;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790549712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fonZKBEVnLUi3nmIxkkXaoCZILdYms0d8ZYuqeeaJBg=;
	b=TL6j4Yfziz1X4zn37elPLSkY3iGybfLhp8L8cjYzS6+x4OJIPBO/KiBOzHuEFNJAr8S0Ov
	ERNHjtl8d0zqf7eqElAmyphYw7tBR/tgbFGS7Vn4LzvhuiMfu7T1bgDQYSRLQroDqv6sCo
	OLHbYf1rA+xg8iJtVpeaEmS5I+KsrnQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eIGI0kb8;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790549712;
	b=DQWiv3MX7f6TSk442jLF0WRfC5fYSfw+zJkILbKubwMxIwip2GWS+ZHaiRKRMaF9/k0IFf
	nsyiteHmxN1oveSooAKElOMMXZq5Bi9NDIPfb9YvWbGhQ8fe1kuPpeVLpRi8fQn25FRYG2
	O+3Px+/5n0nkNp7HyW7TuvW4ftjfkt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fonZKBEVnLUi3nmIxkkXaoCZILdYms0d8ZYuqeeaJBg=; b=eIGI0kb8JoQ6f59QATnKY4VWTy
	KlWA18PX6hX10BKhOmxNq0tGi3u1aRfvl4+RCRxnypG+Q3zub+tAGfPLahvJ7UxrqebG6Hw87AV+5
	pjJ5wII77N8SG6ISTZur4tDlzHyQJG/AruwRnBvYUL5h5vM1R4LIVih5MQuljHXPOD6svEMX0vt5w
	fN1uh3q8xkndWOy2mJeEInuuRC2htXs6SWKt9eP27BmPHjB6Elzy1vZxpqCT0Gl7etIkQcBpxUbK4
	n8v611VA11zwhLqKPmNANUdBBOafXd7NBkYlngO75KzUN/H3oVubmt74amemlxLWMaFpHJpsXr2/5
	Lk6vs5tg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xAxlt-000000025TY-0cPK;
	Sun, 27 Sep 2026 22:55:01 +0000
Date: Sun, 27 Sep 2026 23:55:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	surenb@google.com, david@kernel.org, liam@infradead.org,
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev,
	vbabka@kernel.org, zhaonanzhe@xiaomi.com, linux@armlinux.org.uk,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org,
	kernel@xen0n.name, loongarch@lists.linux.dev, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	linux-s390@vger.kernel.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <armexcXDiG8ryZd6@casper.infradead.org>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
 <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arI_w2wTfA00Mgy9@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4960640004
X-Stat-Signature: sfc5td18j7sx4xrumi84bmdzozhnu5tx
X-Rspam-User: 
X-HE-Tag: 1790549709-634525
X-HE-Meta: U2FsdGVkX1+bhQNKFXhh701LFY859NPg2sPGCbVlW8tzwECM9sQBGHwhOn0FcmHd6fhuAWCsHyJg56Mp/UDl1AuEi8gwOaQOkL+vXZt3/R8Ub+Q3dGI4GOwFIc7xrbDMQU9eeNGr58e469XafjEM/MuvT+dS6CchGieCzfbuDFAh7rewtbdABX5rURIulEz95HruoF/zm2Y+1QUS7cx2HjYrTLRY5nfqEUJIyJk96iRMnRn7GsleOwuMZwPRJmkxXB3nI0Auo/UEuThlOBnePk0DcSos8XdUd4WtsYmYDscOtey9D8nh/qoAGPwi9XxSnx7ctwhmLGgQGLrd98ih6p5865QAj5V+xTHWQCyTk7CRDDAY0Bmx4AuhA0v7pbbHN3roHVopdvRBXubZ+9NUrCBEUQpe80VzZlak4FALZug/7lSbVpNKbP0bypTrhQ4cavvmnfPIbAhfnzXEUvTaSxHdF9rwQqGhZPO1wemP5c5ZEoPFxJrYEOdHQ6iOAoqzKuEgk1tZGDbKiMKngCGpWJvkUoRD74xqSyHYLtApiAQGcERiU799uepEpM0zX/OMWIN5kpcZq6wOT8YFIBcXTK7TAaV3DFHd680QWHof5W6t4pQptuadCnMb7GYBxNtFl4yddAMbulqQhjIBoaODhb1sU2oYHdwGt7eSa2SrXwZ2EJkF8TKxqCVFFlzOXeRkqvPKYBLRqouNK0z2DNYRZU655c6MJZ94Ym5TUb60SLLfeAL2wQFob3ZrLGPjKETx7Pd4Cy7HqmMo/ee/44BaZCBmAwyyAi19y55R4c9OJgjR8+3EU9xUXSD5mLY4R5SH0ff3MgWNReeKHu8Bq8G4nyE2MeY6O9MTc9FQZ6+J6P13LoBRa4a5xIZKle5cI7uaUlxYCuN0ou8hkwQL+0QwKbkr94igHRGbMrXjAHej/Cd0D8l0P8ZXVJ4NqSpVMcwv8WPdAH1fm0GV0QYMALa
 SEqE1pDR
 +uffw29yZiBUAco6KIa4YP9Zz1ZNYbRYknEiQjig0GJYzXMjfD83sGCvANcXgICETwf5xMBqyaMD3m3iEDPedzhUH+cBs7UX1eVEAkdg1BW283JeDpX2vg2Oahv3GAhIv5lsDsQ3w+VgUEGTZJDrO/u8IhU23zZQZmT/49gkvK2By6JRl3wkWBnzn3aqcJ/84qUXZSoR3dTL30YzHA3/Wn4uwD71QxauqZMHQH90VXT1B88PAgyBEK83/Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:55:23AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 21, 2026 at 07:57:23PM +0100, Matthew Wilcox wrote:
> > more to say on this in two weeks at Plumbers.
> 
> I look forward to it :)

So while doing my slides, I realised that what we need to avoid doing
is (a) sleeping while holding the mmap_lock (b) returning RETRY while
holding the VMA lock

And that turns out to be as simple as this patch:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..94ed2333f8d8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -723,6 +723,8 @@ enum {
  */
 static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 {
+	if (flags & FAULT_FLAG_VMA_LOCK)
+		return false;
 	return (flags & FAULT_FLAG_ALLOW_RETRY) &&
 	    (!(flags & FAULT_FLAG_TRIED));
 }

OK, this is a hack.  The function is spectacularly badly named, and
needs to be renamed before a patch can go upstream.  But this should
fix the contention on mmap_lock.

Could somebody try it?  I've verified it boots and runs some userspace
fine, but I don't have the workload to test the contention.

