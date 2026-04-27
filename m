Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AF1FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20076B0088; Mon, 27 Apr 2026 10:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF73F6B008A; Mon, 27 Apr 2026 10:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6246B008C; Mon, 27 Apr 2026 10:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF196B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:18:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 222D11B6DFE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:18:04 +0000 (UTC)
X-FDA: 84704540088.09.80BF34D
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2A7D3C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:18:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qcRDwDhR;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777299482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GsBaM19ELVt+4ypSoInGGnTn5j87p2XHaAospCoRwY=;
	b=4bQ6v9MByW8muJz6635ZlEOTdx/rhuW+sEYhN7mCx3GGOzm4wDzzXd89pw1PlxFWkyWGUj
	fcQynJMBS3HRZqW877nopoYAHXEUUMej+cZEEYXBekLfN52Rgf0ER5xQyF0AdadOaw+m3C
	Wg4YnK4RGomgA9NsIdJOL2/TjzAQEB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777299482; a=rsa-sha256;
	cv=none;
	b=8ruUj0vRZaalk+O4slhQA6gg8peYm+Lv1iinfhEGrfyXWfrDos4dMNLF+KgU3TFF0N1/zt
	zHuHqvRXjH3Ixr5dgfCbl/aNAfepTVEOcx4s6jRFrfu3HV0lv6UrKx5gMU2SXBrmQEhC0O
	nMHLmtD2P4fRd1pmdIrWgeyiU+mCchE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qcRDwDhR;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a402b2d102so10878527e87.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777299480; x=1777904280; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0GsBaM19ELVt+4ypSoInGGnTn5j87p2XHaAospCoRwY=;
        b=qcRDwDhRVob56g5Y3kAarTg+LpTza/teS7K9G6kWilDPrR8Oxm3WlM1K5Pc8+4jW0d
         gCz8QZakvoGUQrc+0y5x21gJ57Vd4cXcLhmfAd5cxz+DWFXNUPdqs8sfQnIeF3R2icwE
         LkgEiaOGheCznLt/SlWh2lD5OTzC6gntQZVWgHt8P1k483L4ZCpkideIbCmLKAE0EDeL
         45e89Ov//TWWCmUORw7VymrLYBP9cUlQcsbM1iWhO+To/dQsokTpu/+ti8l2XJ1e/n2B
         d63fcI7nVtqA83xYoKvrh7B0xFQ4m05idvdoXclStK2SQNYb6YA0s8ICEj5WjPu4gv+h
         OOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777299480; x=1777904280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GsBaM19ELVt+4ypSoInGGnTn5j87p2XHaAospCoRwY=;
        b=S38eH/lyWVEs57VWnJisFSaiHwbNM0C2IN9TFg0RAfbQTo84s/9JVLnCdcqxZ40CbM
         wlCG75yE/3UmSV8blRCXGgQyQQvqxT+XvKVMkMZBmfWwFu6oTlLUKMCaHwIwPTXh5Jne
         ++NrIP6ocy/UccJx9Luqj4eFRi/MtWyrRLArBU9JUaqRiPBCTdgrI0cRnD0TITUa8ZzP
         svhrKee1FOYNYORw9LbEwpHCPm0DSY1Ulu/KFJ6l2O9/d+VkNJQJhFgfDcchh7ZQ6CTD
         6QYuovNOJy3IdUX16mLXCgXSsJSKyhaRzOAOgjfhZQRIqSi+ClHvki/43JztffpWv2hx
         /78w==
X-Forwarded-Encrypted: i=1; AFNElJ9ZFr7ubDWJohp4WMKep2mXc7D6HGN7Z/A2rMY74ofbAoOOU4sRuIuXWfi5UWLxK920JRg4Graa4Q==@kvack.org
X-Gm-Message-State: AOJu0Yz9ulWnkgUTeNqFTMTmiTSZS597WpFK0kwD76iM3rfheEi7u1l2
	a/bRxilX0vdjp9rc1gknXYXfxu1KcDNVbarCBg7EweQK4ME2nFix4/kt
X-Gm-Gg: AeBDieu32uNKRvvBZv5w0XyoGHJcjNKLhOr/06P2cBMJ4U1TgNz9WKpmWk9b7NkzFZp
	K/HdsCx6VN4vf9jOAOHywRHbt6f23UPNfLPC66NWdNYowNdrgLiKlUITxdIL7JCsEzklnxMtYZz
	KJFzrUZkGf5TF7a9EF1irc3bVvEIuAdjbEDxPaMyM2DQAHRcU+NPIvGcVwYCkmcJaOQuT0tyKZj
	vn+SGVbjkVVKdADEV691f9xpw0lo+p1kLGddzeBodfduy8XV4NLPGsBPO+4EScbw9mh6ijL1HXA
	FworgqG4Su/s9ClwyQ+2ZSFSLLqpPzPbgqlLOnhALMQZ0BGObE/ST1sb+TQDHDXM920XcVfCn7H
	HKQG9p43ib9unUdwcDOnNN0/3aqc4ZdqDnUc/2nNmHyi3ktXpA7Jpe626r9gvFR7cRFzuHl1jPd
	FZiSeOhZ2BNw==
X-Received: by 2002:a05:6512:3ba6:b0:5a3:ff60:b72e with SMTP id 2adb3069b0e04-5a4172eac66mr13248322e87.39.1777299479648;
        Mon, 27 Apr 2026 07:17:59 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185c88adsm8464965e87.35.2026.04.27.07.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 07:17:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 27 Apr 2026 16:17:57 +0200
To: Vlastimil Babka <vbabka@suse.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Uladzislau Rezki <urezki@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <ae9wFZp7dS8QF8br@milan>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
 <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
 <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A7D3C0011
X-Stat-Signature: n7emgk7m59x5jgysrs9smdyk54rsumhr
X-Rspam-User: 
X-HE-Tag: 1777299481-356634
X-HE-Meta: U2FsdGVkX1+hFBT5VJ7kORGObjDGh6q+UY5/b24dlNVOEo2xjjxhIMLjyZ4UBl3BeU7S2KBulsjFVMtVAEr8Z1Mm/TzANk59GvcQxhZ4phULOk4580q4QeTmYJlafl4Swa/eEhhotl0e8jKBCxUiKh1ivNzsiRzdvcFnkzaJUlu6qL/F8zIDhF6KCcaRI2UWpFlAWA0fl2l0DCCre9GkZN8boApjpM6RH0pZoZ2JR35cJKCN7pBPEWQwtwh6OGyolhemaFHeK8G2he4qCBUfyabm8MC/TZ1cX3UW4UKXTLu5ClDwP8WMTM3eLD+YNqiHL55a77CBP+j1XikIVtO9tVDJ/pbyEyIrHk7UPT0vZ1hhY9S+eT0gX71W0uUxkbHqq33th5wK+cBmm6Nam67KA8ZdWhWVeq2IhyUlTD/6VjtCvk3OJ0IBRy16U+V//Ps+N07Utk7WhFsCYZYbRqM8UJsePHMRRSsRdmtvexqv+z4ZOSnvOjkWNlOWE/dzkuwzD1XsYIa5QLW8aXo+vFNsXhXbYSS9a3Ye+9JMEn4JXcobGIWEctzpf9/rWvrL/Upt00rO//J4iFuIrQTRoxrN6JdP+zg1gsR5Xnzqkje/iCy/24UTnKK/jT5ZfNymed931D7C2uV5uQwPN4S8B/BoinLzgsMdstpcaSlpcwI8BI/VRPsxfHvc/q11LdMOf74S28tp8zqpkNg3fmxXzX7l3ajMevmIPuw00pH4NcsSHpxOhF3/oqBhO65ZO+I1SPc8/MR05MuDqcO1zqNg1iHh4VY/+rDqb+dsaQpireOWcB7EBqgnmGMfwfSD2gQPISdhQl0EKNqPA423nKdpCRG3A8vlJmWGcn/Kd2jBAbxusqq/OGaMdPpiCQN+2o9keSD3bWaBExiyEfnmwUPaNPXAwdhTEYBtelBe/w3ks2Zo/xVPurpKkvEnne4der9An+CJWghCwFTzBher9p0Jtc5
 OXUjvtV6
 wOrivqESQFgAVdgGsuz2zKObJ6OIUmCRRLDEIcTZ5Mzub1lmHYbEwaJ2EgKwKj0Jpo7m7/ymLwqZ0nYvLFEabydkiVYwqvsnNfJkqxr7bhf5YbYpi29mIuoMVWL6rE42kEPG/QszaAP7PZcmi5iIj3FVgIYBQ7SGpUBYD0on4JFZMApEuJyyeEchiyE53ULTEMUv8yl2fd2NWtNz43VX/0YhQq0B4oKav7sLwlKFCe9ao1Bs14p/5f/IylEC9Q5J5h6OyrPvFiTcDxWK8pq9xbpnFrSFcRlCtqaxGXKos0H+A3895pr0ONZaYb5Mck+ViuN4pqSs4dMUcfFcWs699YzXLlOArDlnnl2wPZSfoWlR5Ono/RS7FpCIafGZTbbMfcfm8Y06Jw7G23hDlNYrEoo8PDXKBwUuaYtcfoeK6Yc+5zmGQPzqhpOdf9SPjbYiZx1Qqxz6v6fwjuEMWhA/3pBjJ+6HM8zi3EfgwdoX76T/k2D0rn3pAaFWKJQLAvcrn79hH7A/F9Ncc4gxhiQ6xosgSnS+ZWynmyhH91h1dFBswF3teCChgG850euEWA28CLvw8QjBgLnIL5nZ48+jr6EWO3iqQ4vxlR5XfTedhZXgPKqz98psnyA3/LWw8OU4aM3HIe2v3PO7ZZwaFoFQqz1pCJLoU9EVWjA+teSuusyqlT0YiZhVPMlmg5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:53:52AM +0200, Vlastimil Babka wrote:
> On 4/23/26 05:34, Herbert Xu wrote:
> > On Wed, Apr 22, 2026 at 10:32:16AM +0200, Uladzislau Rezki wrote:
> >>
> >> We have added non-sleeping flags for vmalloc() to extend kvmalloc()
> >> functionality as folk need those.
> >>  
> >> Another option, would be: always use vfree_atomic() from the kvfree()
> >> path.
> >>  
> >> Any thoughts?
> > 
> > Perhaps add a kvfree_atomic that just calls vfree_atomic?
> 
> kvfree()'s comment says
> 
> " * Context: Either preemptible task context or not-NMI interrupt."
> 
I am not sure the description clearly reflects the intended usage.
To me it sounds like all contexts but excluding NMI.

For example, calling this under spin_lock() will be invalid, as
the vfree() path may invoke cond_resched().

> so this is neither. It might be ok then to create kvfree_atomic(). Always
> using vfree_atomic() from kvfree() might be wasteful.
> 
> > For rhashtable it really makes no difference either way.  But it
> > would eliminate the unsightly call to is_vmalloc_addr in rhashtable.
> > 
Seems atomic version makes sense here:

<snip>
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..2b5ab488e96b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1234,6 +1234,9 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
 extern void kvfree(const void *addr);
 DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
 
+extern void kvfree_atomic(const void *addr);
+DEFINE_FREE(kvfree_atomic, void *, if (!IS_ERR_OR_NULL(_T)) kvfree_atomic(_T))
+
 extern void kvfree_sensitive(const void *addr, size_t len);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..e25a0eab6ff7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6802,6 +6802,22 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+/**
+ * kvfree_atomic() - Free memory.
+ * @addr: Pointer to allocated memory.
+ *
+ * Same as kvfree(), but safe to use in atomic contexts.
+ * Must not be called from NMI context.
+ */
+void kvfree_atomic(const void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree_atomic(addr);
+	else
+		kfree(addr);
+}
+EXPORT_SYMBOL(kvfree_atomic);
+
 /**
  * kvfree_sensitive - Free a data object containing sensitive information.
  * @addr: address of the data object to be freed.
<snip>

I can post it if no objections.

--
Uladzislau Rezki

