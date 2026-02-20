Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B90C5DF68
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C505B6B0005; Fri, 20 Feb 2026 18:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27CA6B0089; Fri, 20 Feb 2026 18:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53F76B008A; Fri, 20 Feb 2026 18:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A326B6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:59:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D08A1B5671
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:59:56 +0000 (UTC)
X-FDA: 84466505592.01.5328093
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 52B071A000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:59:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q8spDmPm;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771631994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
	b=josL3CSqhN6GVZV3/mQSn1IDGA39+synBW7IK6AueZVXMy5iYBUpvbb/VwJGH2ZNVegIAp
	vrQYCraotAdCQY0IQbTMVlvIAGt1qOCvsL4HD2/XGqCVdTPWqeJDcwM0qx359CYCLDRYCf
	8iK/JXPWMhQ7VOAgdqyEC3/j4m9yJ1Y=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q8spDmPm;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771631994; a=rsa-sha256;
	cv=pass;
	b=pHke9GANNPXOYQJRTUQ5A5UbVnl6KSA3BwhuadzqitoAyqbfszeyCY4N5VWYWCqf7TaN0a
	2jPG745xR2jFpirRUK17r7M6xVfOoqsw1cdhOFZ8pVYWMAYdN6vz6DjmEy20SgTV8MJEwE
	WBhw4UBHr9PHYzTvOa4LjTGAYryab1A=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5673fd077b4so1252599e0c.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:59:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771631993; cv=none;
        d=google.com; s=arc-20240605;
        b=ON+kTphqZU9H+IMo0n/u70urtLq5cDGfIIjQQ6WAfOOtNFak3o+ZmXQVWIsMi2P/8D
         vo8f0jCVR7JfnRaUGn5DqgHq8XCJ1VUd/XYjLoDLUg67m4tmm532Ls+lxFmIhR75fGDv
         Uii9TbyuP7mZdl2Woknjp0YOlLOC+2GhcBguV3SxgtYz5NFybhciygOjQLxbUdseF8aO
         PBgL6Kti5BiTK3Eoh6kWtYkawntHASuCy6bh4PJ+YaxJzj3h579Ks3xej2/Eh9iNDqRd
         qxfch8j49cq6cONplU5+OKyiCPe6xw8eNlchgP1TU9m4LZ5mEPwrEo60DTnUIPfOS4Bl
         TZzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        fh=DSxFU9vb00RnrBYf9XlvrG2hgm3vpNwB6RG26FlbDVI=;
        b=cH6fz671x2+7YoIVeDyiFyek6kn9PKqpM3AsEO8R9AY0t4+KOIHj7L8pSZyRN84fLu
         Tp7x9Ud2STkl6luSs5rZHDyL6R4XRREP1/Ln48Tk70z3owenrgU8cIHEY9QHhYV6s2wm
         fNPJj9qFCmWgb51UUgTGodr7QP5UjVagWnN6+2U8XotMiijtrMVzp6Y9OLSKSUR1hi/M
         rT22qfsbqhkugD7FIlBY/rWNDHRZIfWM5um9mrnKLmbjrk8iyWJNjMwzwFVnQOPghdVw
         kVQgrb/Wtx4JG4kyRhDcW/SCV8L5G1NXlvalX9gfsurXd4VlzTZcS+/wFvZ6JiAjDYnP
         37Wg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631993; x=1772236793; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        b=Q8spDmPmoL7MPGPg5y3eItaw9T4w0NMJ+l9bUfuaZyitgPyl66OV9zL7F/J8pvfwDN
         tHVQ05SgqBWckFuo8m2ZlA0KQyNJJNSIA04SFPq0nmIkxh+PszL0eAe1gXLHZlzGB8UK
         sUe5OADqIFEf2eOecQMNyjGSTvagFgRM5kNsQbqPMNCJ4w8vCCxBnvEKisRJvjsrUw4F
         uzsY/fntd/HC2QZ6kYkpQiKd63pCbnNyXRDZMGwgUo/ZJsCAT0/kfzj4rSkaV1qXf4Xk
         T7An/WnpzVvc+SKSX04Qnvrf4Mb55PfdjJJ10jyHLu3p+ElBWfjwpnRA5AHYq8pqqG8T
         bqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631993; x=1772236793;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        b=bBYIprgOsrJAotTM9hXEjagcslusp+VjkqTV/7slFc9awu+CO4y13YPoqymOj1KY7n
         dJBgJVDi7fyENEsK4U4o2vC42Smo8odFI+BK0nwEPLayvWLl0kLLRJhYEog6Agm4AiFy
         yHzWjrVhZpMB0VxY3aQdgOMNOifBtSxMItp3NhzfcOP1dI5QJHewdiU7zxVv1uB1Jj4+
         D1PK8dLJ/SPLjWMmI8ihlAfQT7Jc9q6xkv6tAtzXIHALH6jlJLqgMuYlV8I2VIyDDHul
         jXiSunruv9gHzsOGpeEeHedwn+O+rdaMCe9snPoOOtTBTU4ZrdIWCj2pm4YTYas08+ML
         voCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHbwhPRaEXnrvDsixunqbFa0Yh7mE0tWChzpslK7dT/jBoG3heVEUFFl5lgjCNoyJJ/FOs9XPt2Q==@kvack.org
X-Gm-Message-State: AOJu0YxPnFWY+XZ2JSzW3R+sau9vGSOw4coAOdwPekQ4IFHUoBkFB2iG
	Tnl13ZKw9Hd0XcqyPygjKnEt8BjaUpcgQ5kxPe6HEIpEA/ITSNtfmCqlHpn2oBClE/4N2dvmPGN
	jn+ciMcDJne5eZzW+PFGtMR7ekiRJVhfYvPJ2Z0ZX
X-Gm-Gg: AZuq6aKmeYDcBsSqYDbX/H6j4c6Y+8Q2aJJVhqBLgzFUjJXAhkSplh3FZKh0bOQEyVR
	TsFTLNx7RYPYgpNXmiIh4JfjGf9PIQnqqSC80+h508be/bqa6SAR92OjGEUpjy45N2yCTz0klYE
	MNCLCWe2BxQugdAwsZhEC5uVn9e1FtWChy7MCcNU9MFj9ajfjlYkzTozjq364wTLtdwsxi5Q7vC
	thWdlnCMreFdGZLeYRzIPK7lpYXo6qPDhd4ZTUDxhrngDt3IyhoxC62VBkApk6MBnHFTID00FSf
	4k7KLzTN0xnsxdrUWx+sDnsDV8cUibAx34mu9hN3dw==
X-Received: by 2002:a05:6102:358d:b0:5db:3bbf:8e62 with SMTP id
 ada2fe7eead31-5feb2e60d7dmr725313137.1.1771631992819; Fri, 20 Feb 2026
 15:59:52 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Feb 2026 15:59:51 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Feb 2026 15:59:51 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aZSGD-EGSR3Z5Qyi@google.com>
References: <20260214001535.435626-1-kartikey406@gmail.com>
 <20260217014402.2554832-1-ackerleytng@google.com> <aZSGD-EGSR3Z5Qyi@google.com>
MIME-Version: 1.0
Date: Fri, 20 Feb 2026 15:59:51 -0800
X-Gm-Features: AaiRm50KSzR4QWeR2pY6q56NWZqd8e8f9tXSjFga3oRJAj_7AZ0rMRT-3FKVTjc
Message-ID: <CAEvNRgHQZzdy8+rbsH2EibpCo8ddinXMSSef5h1_r3mK74q-xg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
To: Sean Christopherson <seanjc@google.com>
Cc: kartikey406@gmail.com, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, vannapurve@google.com, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	i@maskray.me, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, shy828301@gmail.com, stable@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8rhfzywq57biedkbaomxxppk4kbnfesb
X-Rspam-User: 
X-Rspamd-Queue-Id: 52B071A000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1771631994-686129
X-HE-Meta: U2FsdGVkX1/vGluJGhLadax+pWLV9r0y6OYA0uiIY5zgbdnvZLyvtwjrMovBOGkg6IpPaQWa6GKIe2txs1szkRI+DH6mEnyHHVaBolopuJmxJSEOKMKLR8W27+4CEYwyPfRkuBja+qsSbZHqDuxhD7xmwjWmBjfpmZlSPPEnf71RQjhJE9PaG/a5FrBd3hrGeMkaDv2sEmUwQ+f73uNfFlTC77dRPSNlv0MfoMz5yG5t0CEwoLVqRFKcdWeBfZ5SnYjQceoSGjPJX1WNVgs1bQl8+ONWRxVdPutllxm8QcGtG0Ra9FxRAtk1yyJWwK7UPbCrX9Ahj08EVEjRhmh5BCaHJbhkOAdFiyd1KuRPj6+fQATDOKbvKB+J8Kx6tk7X4JUj+W21X6Sq0nOTJUWb3Ioj+liwJdbQv01/XjZWxAYMr86KmhInOAWpiTtZqINTXgoUYTUhC98hokA06B5gr5IRiNttGQqdPKzMUTBTHukf6t8HPDO0wCJ9/s/ona4PZg/1XuZSlJREhumRy8kAWgNtnF9uq9gaApho/Hs+PMTv9tbKqYgEZJOJp509bftZRIYToGjbII8/8Qj0ENqW3iI1X7bwoUlYQjLhfty3yWNvDL6qvR5hGn7m3KuovKEQaPc/n3M4WOp9OhHcnQ9hc92CMQ+DiUWvt4QhrzSia5fHDj+ncaFmFo9B20ALZ/pdcH3Ini/XcnsSj/S+eg8XsVZx5oNGajABaFHdl5dWf6OAX77A0L8bwVcsSOLh3z4eYwkNuBEeAg4oM4mrhtCXMknauanQZCGVAljZMBWKqdwH7hJGEDhRBcoAtv7K3Lfk7QdgUrJZ2vUP4tPt7oZfImtJkohmk5GlgKAHqiFWybI4cJN5+RhoMGNcYKKq7fFLeNdB1gAtrJyHlOvSboJdTlPazdQCUSx1JlIerSBeTdxsh3VklrLdC6bHSZokbnz2SC4pD5/n/PqHvVqeQaf
 RLE7e8il
 zAyuCXypDAiOIbYimZ3Jou8G6EuITZJ5aNrLR2EapEgk0iybf2VPGyK75q8Xm6eWb2k/5h8aiIqlj3lOr3uy4MO8JKX1sBLB5Iqtal+VMKACCSGTr0XBycZ9RBkDZy6GhgiruRbvmOrVrlkGFuarb6hLvRjS/dgy6oxVnXHuHGRrbtVYS8ypbq1Fgd6Q28+AL8mQtIseQeKZo62hOSCuKrxKWNIwV4amQgY9plbXMDV610DutvvuUHS2rTswZwxi1d1EdWJPTMqrsCz4iBdlm8qX+xwUo+4S2uoYnaLVSOLtigFXYJFUMuuzYyjEySAuminuTFtBT7C3z/xhARIXhA69wd+BzTcrce7EgN5D2xM5M/scF9lwETNRDK9UOD/e5Az3uh0tdLmy55dsH0y5hw0dol4mkuJHVNIiF4nNNACSr8DFzhuPNNX9LReMOWn7L2Vlf9MoysMGPan5fIKZFtWxT36OxPxjO7cU3cmLE2timMtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Feb 17, 2026, Ackerley Tng wrote:
>>
>> [...snip...]
>>
>> +
>> +	/*
>> +	 * Use aligned address so that MADV_COLLAPSE will not be
>> +	 * filtered out early in the collapsing routine.
>
> Please elaborate, the value below is way more magical than just being aligned.
>
>> +	 */
>> +#define ALIGNED_ADDRESS ((void *)0x4000000000UL)
>
> Use a "const void *" instead of #define inside a function.  And use one of the
> appropriate size macros, e.g.
>
> 	const void *ALIGNED_ADDRESS = (void *)(SZ_1G * <some magic value>);
>
> But why hardcode a virtual address in the first place?  If you a specific
> alignment, just allocate enough virtual memory to be able to meet those alignment
> requirements.
>
>> +	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
>> +		   MAP_FIXED | MAP_SHARED, fd, 0);
>>
>> [...snip...]
>>
>> @@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>>  			gmem_test(mmap_supported, vm, flags);
>>  			gmem_test(fault_overflow, vm, flags);
>>  			gmem_test(numa_allocation, vm, flags);
>> +			test_collapse(vm, flags);
>
> Why diverge from everything else?  Yeah, the size is different, but that's easy
> enough to handle.  And presumably the THP query needs to be able to fail gracefully,
> so something like this?
>
>
> [...snip...]
>

Addressed your comments in a v2 [*], thanks for reviewing!

[*] https://lore.kernel.org/all/cover.1771630983.git.ackerleytng@google.com/T/

