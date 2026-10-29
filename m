Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91A3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KjlUFtZL
Received: by kanga.kvack.org (Postfix)
	id DD9296B00EF; Thu, 29 Oct 2026 06:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB18B6B05B1; Thu, 29 Oct 2026 06:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC76E6B05B2; Thu, 29 Oct 2026 06:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADD8E6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FDCCC0349
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:08:18 +0000 (UTC)
X-FDA: 85375238676.12.88EEF2E
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D53916000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:08:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KjlUFtZL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793268496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
	b=QnWZITAeWBgCZMtaD5VG2R+wWqr+H3lIWyTXtVIpLOV4y6Cy0mctDOeNQFYL/ZfWH3Juza
	hAWq73yv5+nWCh2hF62K8hdcNJNp4j4RXF6XUCNA6YxoV3TYWnHK3V1ATGag8TaM89hJdW
	g1qVnzI6/UK8O5HFvhKlWJ41x7q4SCE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KjlUFtZL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793268496;
	b=iQbKxX+pCuE6zalZ12SHCXV3Ljxp1X2ypDZRvTBgu/rft9Gxkb9EmgRnBJ8n+hr4/Myli8
	/Pd9muoJVyGp35xQmPy5UBvunzucoi5NfS6YPKWt828Eru8/dho8JOepiafIiP+9Ee7+nz
	D953tTGfgam1GKtXIuK2+kha7WXz8Vo=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bcb1f1358aso1458521e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793268494; x=1793873294; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
        b=KjlUFtZLGW2uFM3MllGI4CmUnLYXP3f9FiC5+By7SXOqsgK37spSh+kxSN2/DzqV0g
         ZJSR4JnIKRQSGQb25z6i70EWUHxZ78tFAvFAVl1jsquGYcWtbM0xuxUari4FHXCQYaQI
         i9m+Oq0GqKZDRInfl3lNwpGwL1+gQbqNMS4mRzYBHqhn25f64/crifj1tlcfBddqaS0n
         MK6cwVpoIvweZ+jxaIGVaeWuzyb0t7ZKaljmBTg+IfVmihppkhfJqCAm/60zXOX4qDml
         2vCVkWv+7hrmB0F/hUtWRZVMa/hDsxy+Nq2DjXNVq75DAKE4pPaYyD4t06tzD6m6pkhp
         wmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793268494; x=1793873294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YqJZ0P7+7fLRIuROPGM5CtyVNeaoNZ5CLQZzkAwMRGI=;
        b=FuUPlK6bG0FQ3TOxQg11g199xIs8QLrEZ4mcmovdjiVmVWGSn58oTN6kS/v4GJhv0H
         FK7GGfSuAzsjR5iNlu2DXXabr5Z+x05h7k81NfKgNgTH2++1Adg5bFD5lkBukC2K+/9K
         Gwp2CiJBWgYbem/mtmmm1cyZIkUMjn1A8Bg9cb1/AOATuGirNu4cTwIHbXb14pMnwoCU
         kNnxylxC1IR5O0c+lg7gNF+wcQ2N4cRk1/f8oQ0XrP5I9CoDZbLac19X8i3nh5xqirIs
         52C/gpAEiylhqMizOxi8fgATUWFw/Xn4JhOB0d3rP3o0pq/i6hPnTSjgJQ6rtvyUv7bj
         r+TA==
X-Forwarded-Encrypted: i=1; AKwUvBwR9V0QmWxUthwdvJPskPga+jdSN3X3OzCiqzJX+SBXzTVovL05/aXHxmAM4v7hFM+QHy/UEVf4dg==@kvack.org
X-Gm-Message-State: AFq9FYKOlJbUxrAdpmTQBMkthJnyx5bYAp/BeJQHvHLZD8bH1AuBZjJ4
	694smRn8s5aI0IjX/+9UQVzxXb9Rp5TiYK/21E9RtfJCYhfuhsAczPFm
X-Gm-Gg: AYBFou2pgkY3jRGzeDKbXCTLbBoP7Bu7LjkL0h+v4HRbY4bGMNl7dHzULvJAXjRolRD
	Xqspl0jtgIbZ+ZsPmlGBagFCgZgNXhQh3Q66BV+5xrFJELsK1D8yZj/hQzCPl49flkPny+UOzGw
	KMLECqx3r90teF7sYqX3QwQmIjIfMQCQUnNQC3MUWmLdSJiMyekfNRiZfGZ7zix83PA+PB390As
	H6KgttutVVUJW+v1CaaJ0tJZm3KkmTbtN4UD9ftW5n8vDNDS5TlaJZyj3fp3fjXKeoub0yq8rZJ
	4MNr+7+YGMEkDA5bulmKC2QfiKybNFWisZOK0+OEJzgiXu2hh3Uabu5Og7DIMbQpUQFef4hmZiD
	hzdiCfHdpa8LxzpELhazxiCjLLwvMsy5mPpIheIOlYm91s+AUg8aHW1g7zl6xm1DVUlLjdoHCJQ
	rTNskxO3AHRwWz7W4/gPab7VXkVrh4oV68cFCjEgoCxLcmn3irkqFGP8hzCobRc+yJk4tUMTY6v
	2DsB+HHVONfotZrIE1Ad1Db8rsMK5wstaSOcdQfjrrEiNbg523S1NsTY1O6BNgTzmGlVcoCYfju
	hW/0Vq/IlltGdZGoAVAQQDYeqeJoJ+5UkP+8FaRehyhuUupwgnBuAMoXPB7KpEkTddafaY/3uAZ
	9dxhm
X-Received: by 2002:a05:6512:2512:b0:5bf:d56b:a71d with SMTP id 2adb3069b0e04-5bfd56ba77emr273419e87.46.1793268494124;
        Thu, 29 Oct 2026 03:08:14 -0700 (PDT)
Received: from pc636 (host-217-213-144-15.mobileonline.telia.com. [217.213.144.15])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfca5bb57asm1109637e87.74.2026.10.29.03.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 03:08:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 29 Oct 2026 11:08:10 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auMbCuecFeRmBFSK@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKshDXKQXt1kvjy@gondor.apana.org.au>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D53916000A
X-Stat-Signature: ijzz71aoqih4qza1861wnsu4cshk3hiy
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793268496-599956
X-HE-Meta: U2FsdGVkX1/c3BQ4rAJLgAG2pr3MOdDs3lq5rTSnmA6y1e+45fwZjbgOCwB+rzfa9sNAQ9FbQwjLlQZZAX4UsoV3sGiJ6d3QepM6tAniMFOAJrUixRCe5RQXiYEnRgTGn6/7RlRyYJrHqAAjjYFUc4qQVvjWXeHSFwAcYJJxgKuLnOTU0hNpmsdeQf2yUKzjy4aKyor+TDq2KUS62YZ+x5V2hoAW5fyVBoVOWL67QfszC+8McBUcXvDyCTuecSVqB6XDqpdaK9fNzViQHR5s6UCy6Plnz3AI+emeTGKKazWM80hs4oJ3m7HxYsrNfvnEdnCLGLOd0rvJjbub4rluYojMawJ8nkTOE2M5VcFTlStXturXOOnj345mykwRF168HaKkJAq2R3+9oRjzvBSg+F6yzFpLFq7k5/dFdoLUtqpBuybkxBovwQSVOeJGZj/tF7FC/6RJ6LOdQa289O+FVhyWgjTG7UONWIuVzcy1ZgpJzjxLJ06IFzqss8PN7HldBjZasyPv+tEladtFq2au4tphijfq3I39jjGH3hrmbRqA+6+tGo/mCw1FFj3mZKX1Gmd2Sa2CRA57jqq0lZdy1qI8cdWINjQRxx05DWSEjcboOJywprX1BXDPAS/WkOZ/5usg93oLlb7Nc8e/cd6Nb4upPaCM0dRXhQdtGfMO7rSCTWECLAPbawkGpQSCDOzkgJEW16afDd+E2ZFEScTBekaB9rzaUo7BICThf6AxY+gioy6XIWIo2AUT8wfw363mG0s4e6YJDYtbPCHWvwz7POLEYw060/qmXzmd7YKdw8cBEcrg+30TfHwp8GOdv3yKmID04gv67lV8+Wtrt/hgFnHjnIoCl82kll/a99ebzSLSuOHVLYlsRzQLK5L5x/IA41EErxFuL+132ndjKV/421MnVczeX4Mp3PFTVIzLTtBPvmaBWrbj8fAIAa6HBV6xKpcwQa3+7Xgi1iWEXiS
 r4z/GWRF
 HWJ4XCNROblxusMEKCwT2hzPrx/g7llB8uQdvTutUqVqdhR2NFbsBkABmtH1FKKbClwicBwEKB3MVuIcGzsgv7xxwnRfWyDyJDeAr6ma102U20GSPyTvVFlpIkBYxBf+g7qEwX9qoFWvN+B7BJNPWVTp0EdzCTuCZeu24rKujl06lW9pW6hWc78e+B/ACFMLrFxDI8NKNre2AKwecUa7EP+cgHv9QzfbZjQJvNY0vsSZqnuOMcr9BEl4nWWnZBhbbx/XvzlDHKWtHnC5IZ69Qyef5zoClfCcnlBeKE8ilT3aodfia1Pt9V515zKPUNuCT1oNgrAmdgE/PoSdvGp/6hXNhLGGqeGwv77icHJN12mvNrKRyLwmVN6fDTD4rn32I3UmAGqQf5oPL/qr9bI+riJ73DGaJQU+HLUjeAxVj5BQrCtMzgJivSZOAYmhKluQWM/q2olnuZfTR1FVydt9fI73gl7vgLVazEQvbcCQdU/Pz/Mry/uGj9GQltek+KdO+8/3n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> >
> > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > while another CPU is inside vmalloc() or vfree():
> > 
> >     RTM_NEWNEIGH                      vmalloc() or vfree()
> >     ============                      ====================
> >     spin_lock_bh(&br->hash_lock)
> >                                       spin_lock(&vn->busy.lock)
> >     rhashtable_insert_rehash()
> >       kvmalloc(GFP_ATOMIC)
> >         vmalloc()
> >           spin_lock(&vn->busy.lock)
> >             waits for the other CPU
> >                                       softirq: a frame for the bridge
> >                                         spin_lock(&br->hash_lock)
> >                                           waits for RTM_NEWNEIGH
> 
> I think this is a fundamental bug in the kvmalloc non-blocking
> support patch.  How can it be used at all if it is susceptible
> to such dead-locks?
> 
> And if you can't use it safely why don't we just get rid of the
> broken kvmalloc non-block path and have it always go to kmalloc
> like it did before?
>  
If we have a look at this as we did not have vmalloc() here:


     RTM_NEWNEIGH                      foo() or ...
     ============                      ====================
     lock_bh(&br->hash_lock)
                                       foo()
                                        lock(B)
     rhashtable_insert_rehash()
         foo()
           lock(B)
             waits for the other CPU
                                       softirq: a frame for the bridge
                                         lock(&br->hash_lock)
                                           waits for RTM_NEWNEIGH

Same issue?

I have a question:

GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
not hitting ABBA dead-locks or they are not interrupted?

--
Uladzislau Rezki

