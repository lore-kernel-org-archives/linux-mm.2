Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEACC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 15:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DC86B007B; Sun,  2 Aug 2026 11:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE2A6B0088; Sun,  2 Aug 2026 11:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8A36B008A; Sun,  2 Aug 2026 11:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54376B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:52:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C45DF804C8
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:52:32 +0000 (UTC)
X-FDA: 85056771744.20.F12D4E2
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3C1DA0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:52:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pO3eVHyw;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785685950;
	b=lh487yX9A8+lEIE53GrvcpMVDc79IP+NfjKgYIoj2C4xNafHh7U4IBf0q+Mt+zEPkWJzn2
	2h+H6uivKjH1y0LgiI73QnrP6JHUmGz7MFzMJSr+hp2ocukURrFNUvf4NblwKhJ8XVmyDh
	LIuuGZDggmRUBg/zyXDrXz2Dm/ImLeM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pO3eVHyw;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785685950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfsggKPyu3o5by6xB//nU7yz9KE4HCf03TFtDT66V7I=;
	b=uTv7XJ9itOlo/ZZ36Kk/e2aVGEuoqrMGjCGowH29m5DB6I6riDJWjxu8I1bQ5SjF+y1vGS
	1uQ++M0q6gzmjjq+v4AxzTBHwPOrqe4hHhWAapGb7lMecZOyIjh44+Nc0pIrynWRw/EWnL
	9s55UhwyJSzUYlJGJG6fMRE6v9+IImo=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69fc2261f2bso4326219a12.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785685949; x=1786290749; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AfsggKPyu3o5by6xB//nU7yz9KE4HCf03TFtDT66V7I=;
        b=pO3eVHywJFUpxDtgBvkVfSNareKPp76DYuxDhJPlIXA1YtrwQiX/hBt+C+d5ZyAepZ
         w7m3POdGjBF2NsDTXwfm6zce73Vwzd7krsQwMSdkWK2/421u5iKO0oGS0KKLj43UBaAz
         UX81yPRhVYYFSmq6rcyhEMGkeI8Tn650EUA78vGCM0A63A6rkrWsJova+LewBwZoyZGK
         idFlC0GoU4nVWTN2oePTvRIQhMJor5/anKxj9KlBhrUo9p9k28Aa5H679a8yn/+baS8+
         vLHEyb6gBoNrVvJjxKF6DBriI76wXIYjQWgSSIIE924s/Iq9RG+ys5TpQzHtJC9Wkxai
         vDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785685949; x=1786290749;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AfsggKPyu3o5by6xB//nU7yz9KE4HCf03TFtDT66V7I=;
        b=ZVUdHbiC9DScN6vDIfUeasdUPbeyIYrUNmXKUDaMLUlw7Gd31UG+b4xpv2qgeIFzLN
         EJl/vAbbk5Eb03v0P216py/++jByBQwhTstwuyyYKTBycSLrAwm1kWfQLXqUVPq7vwI6
         Yjrq2GSeAwYuXoyTZaZHQYcQgnTpAYe7n/3oAADuTtSgzd2bPwLasafKD9D5VkOgS6P+
         ZjoXQnkg1e/ndJOeCw+natFTdxApDREYVY6pAhgPb39RRs4hDlgCWvZ16VzyEG3L3OOY
         R6TI54RIpB+OLub+wSYteQonWbAAw1TCdrCK9E+5SdRrQQCqyyVEN9+c+tOyko3QL7uR
         8Ubg==
X-Forwarded-Encrypted: i=1; AHgh+Rq05HnfWf/tx9Loe8viN0/CdjomlPKz7jJRaP4HP5xMtWAoUpUgorIR24P50YdkrlFUTVllACoHMQ==@kvack.org
X-Gm-Message-State: AOJu0YwjZ0RQ+8ZBJCT9dMCGx5fFpXRQXhqtMqwf4IyNBj+cxePAymPK
	7qtNGeKD8oC4MlxWu8eG1Bh9/9UudqOzQRZqiyN22Hu7ZnF05aA4k79N
X-Gm-Gg: AR+sD12UHxGF/rssyVL+AQsmT7CRjv6a32PVILQsAmRabSOPpRlMhW8J9XPwZOiZ9OR
	9r5cYuzgQdYVneqeZ8ah8+YITFWeM7vRE7wyy0uMURql6bpv3DveibwAZsHROYO8UM2G6M7RcRn
	qLrwKPpZijBr5VNR0dc70Koo2wr7Ximl/eex9HFbXa9W0vrgFkCBAggvwCANbQPaQx7OEO4D3bY
	Y/wVpiTa2iasUym7UoL/RIeMvbChyKCux7xtySFLnwI5SbWMmOiyesZ++5LpK6VP4fi7mwn/uJP
	WF2axzgp5ZjC0inT5mVp+6Rox3ausm0AcIUn2UJwyIRNSDGfgKiLPPbpNyWMai8W6h5uWHNwwY9
	O0rtiYTmpLhA5StbUjlNC/xJNq5PgnDdxQEOlbg6Co6Ijz/9g12LUB06YhYnRCJpyg1ytUJ+tae
	Eh9S22N8ziE0+/0hqG4WBpuIfUdA==
X-Received: by 2002:a05:6402:4011:b0:6a0:f9b2:4d67 with SMTP id 4fb4d7f45d1cf-6a0f9b24f94mr154075a12.15.1785685948981;
        Sun, 02 Aug 2026 08:52:28 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a0d0ed21aesm1101924a12.5.2026.08.02.08.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 08:52:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 2 Aug 2026 17:52:26 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Lytkin <iprintercanon@gmail.com>, linux-mm@kvack.org,
	urezki@gmail.com, willy@infradead.org, shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-ID: <am9numIMZZ4s7UMl@milan>
References: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
 <20260801114915.115224-1-iprintercanon@gmail.com>
 <20260801115202.ccba41ddac9f7a4f6fb1ca9f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801115202.ccba41ddac9f7a4f6fb1ca9f@linux-foundation.org>
X-Stat-Signature: 8preeur7dbyfyf6qqtk8jjm5a5gwqouw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3C1DA0003
X-Rspam-User: 
X-HE-Tag: 1785685950-61117
X-HE-Meta: U2FsdGVkX18jVYcLwd0NAfG5doIPOzPvQJdXs/EI4n+pGDgT4GAlTFmsla0Fo5TzSKjRABjiFyGLmohvPWeFq0Co5VATgEnBFsh6orhOmSwMXxPxCLXbmVtNYSOFUHLolheJg4HdUNg6HroYcBivchd2J1G6udgOQDYe+gf+kHuHy31RkRW0bL0jAPPQaV79fmUZ5EzRkANtIMTPKvlJmLV/37cVnp4fDa+fa3ZQxagza5q4mYAtOJYJCI0/Y2c8F1Tx35IpHdbureZKsq/lKI/C5JMYHfbjwbj1yfkxqc1N/ofcAXnl20S7gz/xyWfWEbityCjblmrgzuq5lC3cTaSmk79YsAEbmZixClnTM9Vfy3D7WL5cp2Jpfx3M/AS207946BRBZRi/4vAkkbrMKj+bBeseRs1uelXuauI3wHl2vvvCtEmT2TMZCrZAqzeHRUlqWTS+3YMhMLTlzLCckanPo3azOXe135KhU4O4lB2ZZpx28AMtLNWH6VB5qOr4U6DsegUTGICxPVHTbhfWGULA2hZ2x7o4I8XqqFiAESgXwR1mnhOIjzuZAoDgr4/n4ehBJMbp21E6Ppwq1rDqDLd9Na40J4GVOow9TH0KNZvCqV0HfKzMl2MXFyrK7mV25spEgLjtbihsPH+qZ78Yheaq2lXItwcCPe+40+huTJWzQ1ThVaOR8pW3HySGa3sV8co6Lxya4jJsvActdMJRLsbauQY7egHe8ss0qvx0g9qpNQEYNis61pDhFBHdnFdXg8b267vQodCCMQeKxt1ibwsehNQnGYoJmcbZt3ITrUh8C3IeuCmC+tvdOg0rIEoEE/FWEhnIeAChgFPpZrS3OOCRnRpGctuIrVTAIAZ/ckDcgArmpMv2TAD06D0k2AgJL6kHkCaTZ54svtQ1siFSWZ3xOkc4VIXqusm1iejM9rNu5CYpOmo4uONilG39CquEDBySTKfTWdl0d5AR17u
 rRt8mnqu
 aUPfv1ruiAkWF5f38m3kHXx7IC0H+1P/iM5nEmqCY3juSFtf/BhWFQimEGWRhWz/IUwQZXgj0aNLYBwRYKqyX3odUpb9L4P06luViRlBZtl4zMhbg212XCjFfydTfm4ok6Hl5FBKChuLV8NXS3ici7o6dnmZ0aVIiuRc67bEQqLenjMe1V4XKsDfIbtIE+JEfDft48kK65Bw/kwQmG8jfv8MMP+8N3SZqq+9oqkhAGAUdklFeLJPldXHqUV0G4RBy+qlrMXURbCim5v07pPvFb79QGCQrtMxiyfYHDvcO2H/ELWLwRLp20f7Zpm1uB/4qoAmLdQbOaqcDcwP+lLpRwHhZYACoNvDDCdSgaml5vfA83Kqc9tPqqtpBhET3vNGNBjuFwkc41Ggl/Q7LiDkKtXq8bcm7rAbr96GkaBUaW+0DmGj5k6Pbodov76LtF3WKjari85Drj3CdPZAEjE+BtE+ApkU7CEZ7wTqNLaDy35C5QG8Phs0cqkfFKm8fhT3EKkGPMi/QN79x4cEAhbZy2/A++LlLoqIZOZNTZ/l93H8VaXHVACvwU8KrmggqNGRqLtt4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 11:52:02AM -0700, Andrew Morton wrote:
> On Sat,  1 Aug 2026 14:49:15 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:
> 
> > vm_struct::nr_pages is an unsigned int, and the file keeps deriving byte
> > counts from it as nr_pages << PAGE_SHIFT. A shift is evaluated in the type
> > of its promoted left operand, so those are 32-bit arithmetic and wrap at
> > 4 GiB of bytes, which is 2^20 pages. Every site depends on a cast being
> > remembered; vmap() has one, two recent commits did not. vread_iter() then
> > computes a size of zero for a 4 GiB VM_ALLOC area and /proc/kcore returns
> > it as zeros while reporting a successful read, which drgn, crash or gdb
> > cannot tell from real memory, and the vrealloc() grow-in-place check
> > declines a request that would have fit.
> > 
> > Widen the field so the class of bug goes away instead of one site at a
> > time. Everything feeding or consuming it widens too: vm_area_alloc_pages()
> > and its accumulators, nr_small_pages, new_nr_pages and old_nr_pages, the
> > index range of vm_area_free_pages(), and three page indexes that were
> > plain int. Five casts go. Two prints needed fixing as well, %u in
> > vmalloc_dump_obj() and %d for the unsigned field in vmalloc_info_show().
> > 
> > No bug report behind this, I found it reading the code. The 4 GiB wrap
> > needs only a machine with over 4 GiB of memory. Neither larger threshold
> > is a practical concern: 2^32 pages, where the field itself truncates, is
> > 16 TiB and beyond what hardware can populate, and 2^31, where the plain
> > int indexes break, is 8 TiB and larger than anything in the tree asks for.
> > The int *nr cursor in the mapping path is unchanged and is separate work.
> > Users outside mm/vmalloc.c need no change either. Those handing the count
> > to a narrower parameter cannot drive it near 2^31, and
> > kho_preserve_vmalloc() stores it into a 32-bit ABI field that still
> > receives the same low bits; above 2^32 pages the truncation just moves out
> > of vm_struct into that store.
> > 
> > sizeof(struct vm_struct) on x86-64 stays 72 bytes with
> > CONFIG_HAVE_ARCH_HUGE_VMALLOC=n and goes from 72 to 80 with it enabled,
> > both inside the kmalloc-96 bucket it already comes from.
> 
> Thanks.
> 
> Ulad, AI review suggests that vrealloc() has an issue handling
> __GFP_ZERO.  Can you please check?
> 
> 	https://sashiko.dev/#/patchset/20260801114915.115224-1-iprintercanon@gmail.com
> 
I have checked. I think the AI is missing at least one point.
AI argument which is:

<snip>
If a driver initially allocates memory using vmalloc() without __GFP_ZERO 
(leaving spare page capacity uninitialized), and then grows the allocation 
using vrealloc() with __GFP_ZERO, the caller expects the newly exposed bytes 
to be zeroed.
<snip>

In the vrealloc_node_align_noprof() header documentation there is a statement:

<snip>
 * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
 * initial memory allocation, every subsequent call to this API for the same
 * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
 * __GFP_ZERO is not fully honored by this API.
<snip>

AI argument violates the documentation, i.e. mixing __GFP_ZERO is not allowed.

From the other hand we can mix it and remove that part of documentation:

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7a0cbba3d29d..28d0fed94d22 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4294,11 +4294,6 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
  * reallocation and possibly disregard the specified @nid.
  *
- * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
- * initial memory allocation, every subsequent call to this API for the same
- * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
- * __GFP_ZERO is not fully honored by this API.
- *
  * Requesting an alignment that is bigger than the alignment of the existing
  * allocation will fail.
  *
@@ -4415,13 +4410,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= vm->nr_pages << PAGE_SHIFT) {
-		/*
-		 * No need to zero memory here, as unused memory will have
-		 * already been zeroed at initial allocation time or during
-		 * realloc shrink time.
-		 */
-		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
+
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
+
+		vm->requested_size = size;
 		return (void *)p;
 	}
<snip> 

--
Uladzislau Rezki

