Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C071CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C868E006D; Thu,  9 Oct 2025 04:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6534E8E0002; Thu,  9 Oct 2025 04:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568D98E006D; Thu,  9 Oct 2025 04:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40FD28E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:19:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F04EA1A0158
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:19:40 +0000 (UTC)
X-FDA: 83977876920.23.2B75175
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A86E3A0004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:19:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JTGmn7yt;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759997978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=232LmYa1xgTsHrJYIShD6RhPMQqA4sBT5P2PBc2izaE=;
	b=J8Y6TPcv9HYLT9SHrUHugJ792r96KEPoabrn5auU9x6vY1GGGHjhzDxMhU/WfSrPyuDoGD
	ggQbMtg6PQZbOtC5v6n2vA8wWe3tWXYyEBJ5sGI0Ok6tSSEVA1ooqlu/JUj9s/UKWiVQo/
	EdNfbhHMF8g9ISodHF9JDUs9Y5+H+Q8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JTGmn7yt;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759997978; a=rsa-sha256;
	cv=none;
	b=JXuTEqMtWYLUkWdmEq8WiSnJ7N4yoXb3o/cmqNwygvzlH4GWvVEOeJV/s3NlRpEU+pV0FO
	r/Xt639OEM1N7YWYm0M/nboCqy2zO/TFeu/nl+OaSKM/17b3oF8meaLFU/ygBzoUOW/077
	z0oE0gu2K5nC4z4x0x9mYN9dDXk1Kls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759997978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=232LmYa1xgTsHrJYIShD6RhPMQqA4sBT5P2PBc2izaE=;
	b=JTGmn7yt0cPdSyawJxPmzDJEsjj2BgN7fXAg4mAYK/yVDkgS5DTkGR9i6nbzSUMFnltTrK
	I3E/H0KPiDGmiHRh6quU8mtL6mUpNmjLgMBNFKXN/YVwC/yL+nEM4iqjt7xCVwM/2J+Cep
	2gWm1e/gY6Zg0+MJqzgn8AzYNyyqeCE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-3QFQ4SS_PiCGOfmqgpJUjA-1; Thu, 09 Oct 2025 04:19:37 -0400
X-MC-Unique: 3QFQ4SS_PiCGOfmqgpJUjA-1
X-Mimecast-MFC-AGG-ID: 3QFQ4SS_PiCGOfmqgpJUjA_1759997976
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e473e577eso4215215e9.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 01:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759997976; x=1760602776;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=232LmYa1xgTsHrJYIShD6RhPMQqA4sBT5P2PBc2izaE=;
        b=FGjoJUs3BB15kkow131ivoRfLkZYImcT5ysmPT47589QWfM8sdDVrn1e6Y+7pbawcK
         as9YSeYZYvdoPNLATsH+QIH9bFjYFApxZ/71Gq+wMwqc6awveI+pv2J4pRYGOK5vJOt1
         LTk+NQyN0dtCU3R8lG0M5f/pxkl2h4TdrNtKpF8LChiS6V/WekrtmFxmKbajiUORo3md
         HJ4cm0+EH45xcQdZYNd/keXEDZGejRqAwF5UTPW+arNLwwSlE9wx/yXcjQHjOZw3fhU6
         8O3YNLKFdMZtlgStHeEVNMiZAr7ANK2EB3BWCWgRd2rCJwPchknngEVTeWHmWchd8C9i
         O5iA==
X-Gm-Message-State: AOJu0YwsisECGXGYxs/VqqePJ3BYqSOKVHKIzbfWq39/lQUJEdlPif8l
	ZmkGpkqO3UDPRBUkqBnHxzS1xrgnfkduyS1kkrHuUNiHxmAwLndWNlcJhfLSiWz8ENFYnTTwDiO
	HC4VZGNIG5Wovr0Yuw8oJ0NaHOxNy3L73GlDGd8wZlwv0wTzstzJf
X-Gm-Gg: ASbGncvcgDrMkBuTKoEuhqIQtrYCFcooNYw20yvJnqYiD09j777C0f4dTyGFG5SgEWx
	9am8Qrzd9vveP3zZLgZLaPmgenlkNrCZ+FB2Yz5Ff39ecaUI81w2WHvAXM6D0wGIijQQEr63NRs
	BsXER2DHFdHrcrI62NOmhJsrByPqafPMNlm/jcnvggU0IH+lNEJyT7TKNFbS6/+B5s8+2EZ2/xf
	Pexu8rq0saOoG9aLXx8ijGrCGbMBj9Asq/PIaXSZWUwE7FATx9jabHdWvyrQTec8YvplgYGir8r
	+62YAXiIxkFu1U18sp5anoVS8it73ruH8BeITu9X8bTYwjdkoSmCCWezKHZPxXP10L1x4HUbJsp
	4tADxP9Lt
X-Received: by 2002:a05:600c:4743:b0:46e:1fb7:a1b3 with SMTP id 5b1f17b1804b1-46fa9af1814mr42960795e9.23.1759997975722;
        Thu, 09 Oct 2025 01:19:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa+CpelyvQGZcWwrBxquib0NEHdrDGNbze24DJiilYC4uLoTX+/Fo9t51q0IqHKKkGFvtxCA==
X-Received: by 2002:a05:600c:4743:b0:46e:1fb7:a1b3 with SMTP id 5b1f17b1804b1-46fa9af1814mr42960565e9.23.1759997975316;
        Thu, 09 Oct 2025 01:19:35 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d7f91esm72241855e9.20.2025.10.09.01.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 01:19:34 -0700 (PDT)
Message-ID: <fa4b8446-a304-4494-926d-f62a1ac9f256@redhat.com>
Date: Thu, 9 Oct 2025 10:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
From: David Hildenbrand <david@redhat.com>
To: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "trix@redhat.com" <trix@redhat.com>,
 "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GMCzfJYiReO6_hgojYIUPLrVPg3MIgI9twDdL9TyVg8_1759997976
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A86E3A0004
X-Stat-Signature: ta9d437h1ftwas85szen9148rta1uz16
X-Rspam-User: 
X-HE-Tag: 1759997978-203841
X-HE-Meta: U2FsdGVkX18A6DP6NTHjgNTZ4X4/Qx+F6Wa5HPRXNPnsfLNGaosDtGyQqOjrbEL1B0HJlblXgCRAXUVTJNi8mqI6gK0FjqSMJUi+E/v2rj0/xhHzTlF1/INrbYFafITuzpTYJvoyJ2IVZEm+yrY5LRud7Dut693+uj5mToGv4wt3g65mZdY4R3SkDsSBX4PydsZqx0NhoNcsIs9jsQrgkUBLdA4YdosrTD/qOfSQLMQGmx4rxCm6ISu7QS+o6sTvi5kfyOSdzQ57eVqz5nbbdoeoRRENdQPs+sYNTHxkq2Vb1iWLELJCPryPUy6pF9S8ngIj4Z75AIh07ju3ahWgy/0MFobwVVi3f7Ih9X3x6D+smKPNalcqOi3K7gJoKlFa8ycWd3BqldGvpafFGiN7CcyKtnPsAyiwRSRqZORiLF9L4pJayX8gH3JXr4R/Z7zxvbDfRRxFE04UtAEYqGrHKImjkqoVAjjQQ/ZN5xIgoPcvFq9vNj5j1nnj9YX7SCPQKKs7eCTJ/sZpgp1nim6u5p5oLQAjKNSedgzjRDf6biF/iWAbgLXOMYh2l5uMc+F/87EBNPXEkXT7d3XrxOYoGV+CZuaxB45eJ1VXedQIXJv5iuRBDZAf5R388wVvC8Vu81LxNuFdE/3N246a5xneDlUv5JUHPD/QOCNlq8EC+NVyWpEDZQ0q+Jl2nUjNT+kI5zrDuDjMfXs7D2Tawg08ZSFkbe14aBtKJINtsIP45RDddj2sDVGX5r9I9KDFNX+VTJEEnPfbXiCr2qPrUttKM3dxMJYPsWO5nuffdRYYYhGUkWkkJtojOYJRCyDj4khell5lk9T7I/BVhFKLLfFARzdg2JhcWCWPlW2Wnu0V04qCzrrO7EOgFjHobRCL401ui81MkZl7HBNycRlRKhrcMdJSWdZgkgOzm8oj7y8w1lVApE2dD5E6EltYohyjq4lwJ5y9cnxiBGVrVpKCltn
 5mpCDX0w
 NF7ERDWmC/08S2p4v0auQ+rrgjemaz5hdczrtULJ3QcM2XsyrVCR+ZU3qKN8KKVdTgAwcytl4ksMdCJVtJsqVb5h+wYEinJxgir/oOCQHzv7hgUojHiH8HEUHw8RVSXH86C79QqsMaigw++8uuXhLv7XXcI4RLr1uJyhm7eiPR4lKL8dr6hcu+PTzvdOSbF0O85pq9K5FXICq9TvgWTpWPzSNh6WNPqX6VQGeRaRDHTfUuOpPiueJg/jNuLZsxQ3si14Ki+H4PbuPV58Iy7MCykAgE7DBVacH31R7yo7K84muhHZSPxVp+tx/PaTjXrKXak4OLP7HL5JwLmLtIXt4qhflpBhz+Y+uY1hAaRtcu8EoVzmC9Eran00EvwoL6caMkgaqny1FmzxTH5ATI3dbkSXtqz5ugM5Rg3ZQmvS8mvSPECDSpxfBoQbmobE5gaOfpHxknFvQSswLkt9+cpQ1tH1Y4iCMvBexOwgChxgouuiZuUUkEM3chgCToKF/dMt93weZrVXisoTeUsaQ30Hn0O4gjKUNKaBTofEWGiG+S7JLjISwfFaJsWzVU2ptYedgKk1ulvn94e+mzdatyQCLvt0czxeFBtCIiWnJtl0WanT8/U/Cu5qqIjFIrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 09:40, David Hildenbrand wrote:
> On 01.09.25 12:58, Jann Horn wrote:
>> Hi!
>>
>> On Fri, Aug 29, 2025 at 4:30 PM Uschakow, Stanislav <suschako@amazon.de> wrote:
>>> We have observed a huge latency increase using `fork()` after ingesting the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB of memory with 196 cores, we identified mmapping of 1.2TB of shared memory and forking itself dozens or hundreds of times we see a increase of execution times of a factor of 4. The reproducer is at the end of the email.
>>
>> Yeah, every 1G virtual address range you unshare on unmap will do an
>> extra synchronous IPI broadcast to all CPU cores, so it's not very
>> surprising that doing this would be a bit slow on a machine with 196
>> cores.
>>
>>> My observation/assumption is:
>>>
>>> each child touches 100 random pages and despawns
>>> on each despawn `huge_pmd_unshare()` is called
>>> each call to `huge_pmd_unshare()` syncrhonizes all threads using `tlb_remove_table_sync_one()` leading to the regression
>>
>> Yeah, makes sense that that'd be slow.
>>
>> There are probably several ways this could be optimized - like maybe
>> changing tlb_remove_table_sync_one() to rely on the MM's cpumask
>> (though that would require thinking about whether this interacts with
>> remote MM access somehow), or batching the refcount drops for hugetlb
>> shared page tables through something like struct mmu_gather, or doing
>> something special for the unmap path, or changing the semantics of
>> hugetlb page tables such that they can never turn into normal page
>> tables again. However, I'm not planning to work on optimizing this.
> 
> I'm currently looking at the fix and what sticks out is "Fix it with an
> explicit broadcast IPI through tlb_remove_table_sync_one()".
> 
> (I don't understand how the page table can be used for "normal,
> non-hugetlb". I could only see how it is used for the remaining user for
> hugetlb stuff, but that's different question)
> 
> How does the fix work when an architecture does not issue IPIs for TLB
> shootdown? To handle gup-fast on these architectures, we use RCU.
> 
> So I'm wondering whether we use RCU somehow.
> 
> But note that in gup_fast_pte_range(), we are validating whether the PMD
> changed:
> 
> if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
>       unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
> 	gup_put_folio(folio, 1, flags);
> 	goto pte_unmap;
> }
> 
> 
> So in case the page table got reused in the meantime, we should just
> back off and be fine, right?

Wrong page table level. We'd have to check when processing a PMD leave 
whether the PUD changed as well.

-- 
Cheers

David / dhildenb


