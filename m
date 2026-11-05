Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB00606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 22:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jXVSObUF
Received: by kanga.kvack.org (Postfix)
	id 52FC46B05B0; Thu,  5 Nov 2026 17:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1F86B05B1; Thu,  5 Nov 2026 17:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFBB6B05B2; Thu,  5 Nov 2026 17:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 103A06B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:09:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C29C80C1C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:09:30 +0000 (UTC)
X-FDA: 85402457700.06.751C1AE
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id B1B7C8000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:09:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jXVSObUF;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793916568;
	b=RFHP7nU9ihdgU5jJdfdIA4UqWqcKj5K4Ii2RZjGz2/c7vMlAP87OErqQ73umI+5qSUz1NN
	GQE1tt1LnxBozIwsEg++TgPx8OrirmRLvy+Ct0UCf/FdcM4AjtUQ8T926OK4fPeLIFb4L5
	O35PWbtsJN3/gXiXw5VE70iMIQsV0yw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jXVSObUF;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793916568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/I6mqklwR3W3ZG0TlgIFqv/lt7q8A458PettktwdYM=;
	b=nnGXa/3B6zg3bpU05TjvO9gKY60T4DGFFBS67RfEjLGqcbhqQ6POX88hl2ZATarzOQdEbu
	OIfEgm/gWzmASfZdZK2FL4UWEQcsJlsvSNQf85nSpnt/jILHuqr1hmzc75jmNASP599wBv
	B8fKxSNfOvEZYzmUowvgkDI9mrMcH6k=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e09aa5264so22308f8f.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 14:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793916567; x=1794521367; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q/I6mqklwR3W3ZG0TlgIFqv/lt7q8A458PettktwdYM=;
        b=jXVSObUF5lXTcMiZPlmvEowZUUClNgY2gt7n5hj7tyIyovb5abLT7ef1vk8lD5qRfl
         b1u6ApOHazmuYrY7qzPnS+0LU24CMYs92lwz3fEen9UPsxjZpjC3SuoRNwft/ZOEEBb7
         49inu3uplHmCMq8GuAtfbhnAAiLT6ofJs9ZU8FHeJsCCN8UA4FtaCIBv7kHZMiLkV1NI
         k3o3SEzlEaXj0of4INnd61ogTTzRyrCcyigRvyXU/SdGgdKkzddG5fl5iKe9RTxj/+Jp
         iKxbVIzF+uLcfXtgVX0QiOaD1s+aydFqeNZhFx5wt+6zH81wFwNdfVfviOOG42Kb2P7u
         7RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916567; x=1794521367;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/I6mqklwR3W3ZG0TlgIFqv/lt7q8A458PettktwdYM=;
        b=e0LLRsgEOuXXM+u2DeT9s8gRIZRxvi8jrr3159DBgltHhAfoTRvjY3G53skwxszmJA
         aVgL9DAOQ2ft0ZaQbAMBtTPWYoQfSzsjMDLyJo49F35ruolKql8mEWBLTm3y4DCzVVLQ
         d5OVtuwlMM1VtXtxIB6UZf77HFNG7kEw4WKj5JVwODYeJEpVnSK/oP9xNmjPohp3bHKQ
         I5c5pUx4XtpwgTIArq0SujikmVD3+aoVS5IKkmbhAOaqCFY7f4GhVP+9M7ZiR03KkAN2
         Q02uSGpdss+wzFzQIld/jCegZ05+q3W823cp90/Y1ipM2K5y4w9wFzjOl7Ul5Jm7Q36J
         zCBw==
X-Forwarded-Encrypted: i=1; AKwUvBxwE3rfqravRAn6b2s34lSNMyoG3aTNg2K9cDGxQgzwtMn9qp33jSNOjZZS0KSohzH7AYHOwzlOoQ==@kvack.org
X-Gm-Message-State: APuU4Z8DLxCG8gNCZqXGcUDPeauGWU2R3oXjaxtxJF7xYymAdzhrTB0W
	It2BrEJ4jiYWUO+ydsfc/BfpIaplXtY1Osd04AVvXkpSWqT0iQ9kJq6Z
X-Gm-Gg: AYBFou0GbhASAfT05vdw4zhbk0m1r3hwqyA1AGCm+wWLOIqstLshucJ1qOU/Ss9dzyO
	tUBY/fS9IZnu3IMjGrR1bNz2GHpErsAskQudUDPrPQbmvAyZfmA1lnP2Hcacra2SmwDytAhEZTk
	O2Gwc8bUDhVDhY+dPQsrHorUv6uJiPjeytMjoCQymC+wMRmO6MjqUz3WnIGK5vRw9W0/MbrkNWC
	m8WRpiE4x0OH0DReD/zJ7LE/hOFqbu4tJi2mE2yghpFZOGz659KAbikuYbIJnIgm9T3tRI+tjPE
	gNTLUHPQFnwrULgIUERCPGMfTF6R+TUEC1Vx5D/GPEMcUuxlGo5YSs1yPXY4dkoVlnOPTKFfVEV
	7bajkQiIypmT7G2W6+UZsMH6T3hUiuJ2zcbHRxC9X7koz3wWdK0XkgdHStw+ZZSTIUisx8pjQlr
	FEER6nvqYklhnN2CdRMiMFsLYRGl+F1P+APkNZ3b23mXF6Y6kphTZy+n9czT15r2x9gve4oH4+i
	YMMw4sTxv5FstKyMNxyuIx+sXgkY8hxAPvDL7k+laGpicDhPxxWRPe0pjw0jV9FyHw0wI3O+HMd
	4NVy8Kc3cBUuI1P8JHwitnU=
X-Received: by 2002:a05:6000:46cc:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-492784553b2mr1033560f8f.47.1793916567243;
        Thu, 05 Nov 2026 14:09:27 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fec8d8e29sm12845499f8f.19.2026.11.05.14.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 14:09:26 -0800 (PST)
Message-ID: <9e98a961-fb45-4e61-a08b-d8d7f8e9894b@gmail.com>
Date: Thu, 5 Nov 2026 23:09:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: Remove the zapped-entry checks
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Rohan McLure <rmclure@linux.ibm.com>, Tejun Heo <tj@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261105120322.3319301-1-kirill@shutemov.name>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105120322.3319301-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1B7C8000B
X-Stat-Signature: 8wuzuhazgkn5g7acffggjfx9fcfpszfa
X-Rspam-User: 
X-HE-Tag: 1793916568-189100
X-HE-Meta: U2FsdGVkX1/zrte99drsV2M8sRZIWA3Wunf4D+V340gsMA6IbiSxdVKv94UB9VrQ3m2zlU2M41R53QmOz3AsgKs3/VoGweuFHwc5UtZIRXYJwAM2bYD0LvEFbzHrre6YKgYcuHfi9rypWsEgrnemeyHUOXTV2m8+kknfhUGougFzVeKEJCojiw1EgdjrAC0vOHLHjU6XM9zGqSe8Y0kgrY5KWw7w8OUfPqTjiafUcDTa3LJeU7YOFbM1XFBxTD9rwBvlN0I3fPBiGbUWHYxFmTHvtFHqUzTj/4b+91cDKLBmE7T2W0XLy/xAkslz+mGE1KKHkO+b/X8Yn7tGQ/P2ZKvUuwXORkdjP66T73SIlCJ3A63grqS+Y3BDeTIUQnev0iG8dL+ErkBIbOgTn0N6we2prXmjpzWWhdO6A4sVNjtwmiGkG9+40xKS/ukjT4LOrZsIf2bmU3TPTc+hfBq5XXjQ+VoFbGu8C72xrauq7d+yBQqKcRy24uJBScsCf9y7eF3qx82ToIUk0nPkyGHISH2DI7HmFY34jULLQW+2JiiAAXH/VGWeUEn5njrvGC614tACeMGbfEMkyAo0HtW8WZvIrR+lQX6kEZSw6hn/E3nX49cPri4RFrrjVR+9nmg0lBvgUTIK7BF+imC+/doA3Er4I7+gxuvb8rZYqTb/7nycXCR2TeNix7r/dveK5/b7wzRnr00FXctcyGDPH0virAfes+alADHirfdiAdRTuZRVhhmYYI4NVlHcLn6tm5EvbKLFggdUNgVTt6C38EEEVSa8L2oSgHWtMsaYD3J264Q+e/2q6X9A0iHeuAmR9kYHaYJHJ2i51Ya8+mEPw3VBVooOf637lAdMk6rExN2wm+1V6GLkRNNk5WSq9S34h2AIIsAr/1/wnl0zQ4v24Y1911BP8QuSNdMMnO1svxhFJNCOYA8iYGk9I0GLlZmhOZy5WYvq4gnQdKS43TEbTyi
 yb1pmfS7
 1a4d9HAoNG5APyAvarRlBXuPlMy0azAPcZqOuIxDf2WMek0JAnv3FqQFp0E6YqMLTW+7xc7T5ht7RPkM/tCx4BHD1YA7yoFpVLvAVSPvUySW2bPB0Xwc2V1ui6YxxkQFiTHHYXDvuFa9wsglUWAff+unwrPduAfesJhAjzOr7P5J6Y76T3lcIIdcll4RUC8FPIpj+KrcK6rBpc4OTonhCUSTk9CrcYpjFMsY5GG8yQRMrOZ/zNWt3+bHHsMy5GnhMO+v0ALvd1fBrTBTlbNk1P5n+BqG90k3YpXz3AKSg6UZw/1j1JOsS5Sb9PzEiqkAWyrY0NNr8qXqGIEVmUx+c4Bxta+HW26kIoKOGp/5nquzNA8bRMTUrXZ6f61yZDlCJZy82ZZS5duy+XnPIwCSYtjfFNTix3Pi2yzEf70/KuX7+uAtCuD1nvY1Mt1lufltfnfKqSRXzRPabhlNELhgbd75wCf7dwBbEFE1CZ1SZoevxYRT7QTkIRb4b7wPHscoMgAKEw3yJmwlOm+GvI8VDkgq2JyrFfu1sK0/cfNTiB3p9FuM1R6ju8sAd5ApBzuI5Gn9TUggOY21u0Ba1qzJa5Az96XTNg5r92u3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 1:03 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
> which is every page for small folios, and arch_check_zapped_pmd() or
> arch_check_zapped_pud() for every huge leaf. Only x86 implements them, as
> out-of-line functions that warn about a shadow stack entry (Write=0,
> Dirty=1) in a VMA without VM_SHADOW_STACK.
> 
> The warning is a VM_WARN_ON_ONCE(), so without CONFIG_DEBUG_VM the
> functions are empty, but the calls remain. With the SRSO "Safe RET"
> mitigation the return of every such call mispredicts.
> 
> The x86 helpers already keep such entries out of other VMAs.
> pte_wrprotect(), pte_mkdirty(), pte_modify() and their PMD versions go
> through SavedDirty, and only pte_mkwrite() and pmd_mkwrite() on a
> VM_SHADOW_STACK VMA create the combination.

makes sense to me.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

