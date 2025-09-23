Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B9FCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 14:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9848E0008; Tue, 23 Sep 2025 10:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D68C8E0001; Tue, 23 Sep 2025 10:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E1C8E0008; Tue, 23 Sep 2025 10:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F25F8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:01:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1545592E1
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:01:13 +0000 (UTC)
X-FDA: 83920676826.22.76F9714
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A420EA0038
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:01:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f67cjzc/";
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758636071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r9zfyxkmjCESQ8duOa/Grq2TL8+r2DC084netIbpbPA=;
	b=D+29gOhgJ2lrXbngRpYmgYXWWwe7Y6eb9kohuJTCDV6StWUmkKdjUTHEn7dIlYeVeXG3eW
	+WrQ9eSjbunq9De4NvECkB4WZjv9tfBeY8asqqlZ+vfDawqrKAejT0ucFgYjWH3GpBu/5D
	E6RqxuU8FSme0Ftahm4AnrOa1DEt6L8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758636071; a=rsa-sha256;
	cv=none;
	b=RqrSJ55BZTTpfan9PGB4xbPM5R5pqqCnvheO4Xv0r3ob95P1WF7SSUYKF8wQZM+P3LCi++
	x+8H7OoId865PisE9DuUSCx5+SMP/tFqUr+Wm29ZB6W4kxKBqusw32fCsZY2BosQkQM4Eu
	vLrQMkGoePCsge8KDjtV2H/zX6K7au0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f67cjzc/";
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758636066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r9zfyxkmjCESQ8duOa/Grq2TL8+r2DC084netIbpbPA=;
	b=f67cjzc/fUCIX4goS8ORMiwd9GXGlojIB41rKXl4/G924TqPZ72vcMDdF36AurXjouaR8L
	zUQjAbVccK87Tc4bcU/tFEi/RLPY0IWAQf6lVGrmUHVferYGVvv+BzSFc5lINs9P0v8sJ3
	8ZXpDQAaCQ6176F9LrpnCafYOr8XxqM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-7ysLhiFZPhqHTScappfOsw-1; Tue, 23 Sep 2025 10:01:04 -0400
X-MC-Unique: 7ysLhiFZPhqHTScappfOsw-1
X-Mimecast-MFC-AGG-ID: 7ysLhiFZPhqHTScappfOsw_1758636064
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e198ddbc1so12515165e9.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758636063; x=1759240863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r9zfyxkmjCESQ8duOa/Grq2TL8+r2DC084netIbpbPA=;
        b=E0AlVS+oTMyIxoGD+0cZHJ25BpLm2pee9cXAPxvnniSvrMVcWezw7q15zPYdyx7jO0
         SxcmzVN701uZD5AkjAnVKmw+tbPdONHmzdS8hZD4AKiVTR2s+PVO4xLk/x8b8RjT8JUE
         h4OddBHjunRwCVcC6ZIbc+GPGXbjv/Fqhau76QYlcpiYnlTzPUxPFlYEBbXCz3kwGDbZ
         zqXRto4Tkuw2luNT2DUEsyaaB9bWGELQm/HMmEerrD+OLVtlrWACsvSl011XRI8jzrI2
         OoCEPVIUB2xm1YmuLIsXqD2ta1tFXz1MunF7tG2X5kwPB0/Fsgl/9SSvxHc8C09tgm0S
         dcFQ==
X-Gm-Message-State: AOJu0YwvFBYgtxOEx3WJPjxx77YYheJsWPRnRzOYdtz7Wx4/vLCWZu61
	EDW3QI7Z2mOOAx7M6/jrgPO3i6uZFb2Qoj6iShvg2zkY93D1wVfwLbsDV8LrcV8V6OOKpfDotu2
	fW3ctxg5KRoRfA+r9mUm5PJ/Gi+dL7DDfBwiCYYXRQdlOGTO4U3r9
X-Gm-Gg: ASbGncu2jQpX9bcDYrx8lQDgYLt9YminPTkJmwem+CIC/j3QRLSXwsNWjk/HOdVWvXU
	KyaeZrqVd8JUowdkrlmbwzMxRc7On+m0Ek52Zr9/7TNWBw51QlqdH8DRbLO+lqEM0U2TpAzOvvB
	NfkfGS8RbMbfrVk1TZvkmQwlW3OH0ZnMHj0okfwA8clA7NgFks9/RssHbUtHVNaKav9enlsSuRG
	UhTsz+ywjyzF0HVz2kgcwLzubhikcGc4k3I0oxFa0L3WSfeU8TcOVqgKw4W5fZXOPNmdgsEBP9W
	IP9KM9IXzDPxKCBOZQUknH+KWz6J+SXBmBHB1ZM1/4RI1b8qIC3t0wkS/n/XuPl8UAw=
X-Received: by 2002:a05:600c:4fcf:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-46e1e167fa7mr27764715e9.14.1758636062516;
        Tue, 23 Sep 2025 07:01:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzy72VmsUr7RNP34u9SB8i9Mn1d2HLUqmTAVbvDGWXn8O1Qe3RSKx5Tt/IQ9sqOIviJ/KYJA==
X-Received: by 2002:a05:600c:4fcf:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-46e1e167fa7mr27762765e9.14.1758636060590;
        Tue, 23 Sep 2025 07:01:00 -0700 (PDT)
Received: from localhost (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e23adce1bsm17786785e9.24.2025.09.23.07.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 07:01:00 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v1] mm: convert folio_page() back to a macro
Date: Tue, 23 Sep 2025 16:00:58 +0200
Message-ID: <20250923140058.2020023-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EhlAnkR5aZvfNmfJ5Yq4gk5JticBrZHzHkYLS0O7dM8_1758636064
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: fc8g7dfyrt9q8u53fyegtxxqnxtstbc4
X-Rspam-User: 
X-Rspamd-Queue-Id: A420EA0038
X-Rspamd-Server: rspam10
X-HE-Tag: 1758636066-946152
X-HE-Meta: U2FsdGVkX1882fo+j4iJqJ1UpYQAAzzjGlnRw/qFxa5RUQhYgVshdcoTmXf3yKuiZQ5JZF6EiNE8TvE/THG913QJhMxojd7mklFDyAYbzdfpa2+4MeYigCKcBOTRTp0+Z/clsmMdCuPvj+4RllZxU2ZgIXtAbv6E2/JcZ0dO1e2BW7GVqSMWvTccLPlARJTel53fQKumCc8souMUkiyNfQVz3etkI0XYCnlGlb9SRfjNseojhTysbt3Q68y3JNFnX9zvusL31GKDbxFOD3dBks0YhFBAHdiSOtnh+iTHetgbuWEQODM/okzKIfsYDeIc4h1xeYxwTtFmJB1dBU8jg/HcjkKhdW6OJagh8U5LMCOJKJ1iV98EEWkD9C6EPkV/vPW/ETYcPcfRJbWD/EQq4zwAWICBdVlDoLZvLpfn198PrF+Ia0KHZQ0YSUW3wvFwb1OJlf1f5Z428bEoy32V3aK5LLs6fld8LuXuMscNDDqWSh/UyALR/gOq8SSwXnA8TKtAt4N+hO7H0MMUHlUuPVDkP+WBaCQ4SWYLd9Hs4bNiBmXz6o9EcOTzCVTfHVNSZoHfpPexNb+gI/PwUim199RyGxYblXXG3aPEzE5Dt5xtm3/oycY8TQMlpDtdDlcKTcnaSzuib5RvrXnwtr0hBbojfXwjJquMR67s+eQ0Xv1a6Kq1VQBAJrDyNR4ZRhA177qN+RNoaz/Y7AkPk8lSHbceTfNYupByQcwQJjcNHErN1M5NG0BEfyHwhFz8sFcjD37OpKO8HdGuKUwCf/KXSd9JNxCFucrrLGDChtU0zOYPWfEWwTXnWEpjLdjjW1ahvu0OexuStQUTC3xTz53LRZfO8pGqZJV9iwcXFkUFy7cxXdU0A5htNIwZBTuZKwZDhpZZFMwo5iSs1wFNlVlXSR3R7uqM1+9IxuF2pF5m5FYbr0Seht9qbrPTj7pqfi5ssqlryP9Nu8rcVJ9IOWK
 HxqNieFJ
 vJJtQg0kr6Sp5x/cKmK6Rdfvn/lcyGm24p3ZKRXfN5j63Zd11Vbx97rPWmOynHnfeciZcoMqWvOGoZvp6PcsaX3RGYUCKRhbUzKugqfzQAnYKjJw48ruDGuxqBMpXVSH3ZqxfmRqXFtdJtZqyOveL7vMhGJG4tMmotQLQNDNZVyHbzi0I/+NS4JBedExeIajY08S9nf9NKuQ1EVhD61Auu47fPPvfhogntXYMxDDiW+OKDHxXlLhbydwqd28youZ6tkl3vIpjjQFWULuARQTjsitmFqOuiIUqwlf/jx3NPIOfA3l5w8vH+ZTV+AZIKpoehb3EAG+fdrSVteOhCoAJz8DDlhvELpa13pwRBX3kmjrFDInBOGqGtTR0g0Thnh6oHYI8C/JgflRrPmxrtZkWMIlU6XCs1ZTJGsYXUAgmb0Cl+JIhuBotn99jBhx8vj2JNZiX/fKUDI6fGTWrnY5EHjLXagSrovDRvBiMYbW+2c2hYpe7Qw72MAbO3hZj2ldRVjS1kGHNGDAiVbzSaMOMIzqEGDskaj5M52RCMR0pKlHGOoEv8NF7ojPIjLCP173ZbPAGddrE0jbEBNJoGkfNWMTqz4HC9r86wVsiX1kucT96OmfpKIhVspM0KvwR4blop4ad3CcuJ1PbCeG2B/ebrBDDkwEg+yDG01C0OuuxVvZYBpYoKYu9eq33ATuNFHDEy8H4ZNaP8KmZwknfpK4p+PkDKrVW74Qc+aebyDiSvCxkess=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
we converted folio_page() into a static inline function. However
briefly afterwards in commit a847b17009ec ("mm: constify highmem related
functions for improved const-correctness") we had to add some nasty
const-away casting to make the compiler happy when checking const
correctness.

So let's just convert it back to a simple macro so the compiler can
check const correctness properly. There is the alternative of
using a _Generic() similar to page_folio(), but there is not a lot of
benefit compared to just using a simple macro.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/page-flags.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 568011930e358..48e27768e7ba9 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -316,10 +316,7 @@ static __always_inline unsigned long _compound_head(const struct page *page)
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-static inline struct page *folio_page(const struct folio *folio, unsigned long n)
-{
-	return (struct page *)(&folio->page + n);
-}
+#define folio_page(folio, n)	(&(folio)->page + (n))
 
 static __always_inline int PageTail(const struct page *page)
 {
-- 
2.51.0


