Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C45CC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DECE6B00E5; Mon, 17 Aug 2026 11:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5EA6B00E6; Mon, 17 Aug 2026 11:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCCE6B00E7; Mon, 17 Aug 2026 11:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E17ED6B00E5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:15:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CCAD1407FA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:54 +0000 (UTC)
X-FDA: 85111111428.19.FB6AC8B
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF2DC18000E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dqBqBao9;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkIXCvEaOBZrdi7ChK3r5JFweXwKUKZFGDYp1HFtFrY=;
	b=8X9Yp1ZudxxENn1b4NEkgcl16WTzizSVkDHtnOR92jUBa1L40+cvwslDqxezRg6+ebXfYz
	Vrn96Jl0Yha4Bqr2vN3w4i8qHMOHdjh9JIRTafQyZbdhQxm4UmQmEZ6WU9LLRQ27szM4Y2
	t6nXXodtSIJTX6Xes5nL2xY1fgSSAb0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dqBqBao9;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786979752;
	b=cAFjvFPHIi/DhTz6PBK3Cbi28cSCMc0fjTWnvuoqnQOpGjsCp+l+VzRWvt778VN4CokVWM
	Rb+JMFgiZ2GRUC4IRPXFe9ZGxNu38Md9PTFA5dy1sLYIyAMcPGIWh1pvfYtixtgvKQB1ab
	BcCziBu+uT/0y5q3jIsYYChxOSzcA8U=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e5b048375so179215485a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786979752; x=1787584552; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LkIXCvEaOBZrdi7ChK3r5JFweXwKUKZFGDYp1HFtFrY=;
        b=dqBqBao96fxyFlT7XUkWqs3hqN/hkedzQfX1LICbpPC0tJZ4rlc5melehwAUDKr7vh
         YIpCnCj6QS+uGR8IgJOdfsLVe62zG/L9bNgvOoH9gma2Vw6Yysfkce/hE5d/J+Dv66wf
         PjFOG89RGNpig/FgpI+KkLHpqtbMLsJCZ1t/7VnjygSbd956OkAS+KGAIqLncWaTWweD
         9REyE9DZpdVMr4u/APM7wemUpne9QY+lxCv3z86fHfXQV17SV6zeSm7b7YMEo//Ff5G/
         NJ3+HaO6xDvf93CThp6ycjlb6rOAuWFxfTg5T2wydQo/lhCkyGmG83x8Pmp25OktdKtL
         n9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979752; x=1787584552;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LkIXCvEaOBZrdi7ChK3r5JFweXwKUKZFGDYp1HFtFrY=;
        b=YPD5mUm59kGzjb4RYcyKeRzgHtnEjj2kzAUHPbS+cDnWQfy+u53ICuH6RyQ8ca2okP
         vuXZwmD2a3zmK9l23jo8srVP3JQ2svxgL5AElwaHDtton3643Gpc1N5YrmOp4Ep+kUwe
         z5gR5WMrpOESFGtv6/8dCAfyiR8dyqufi4lE8ooxqIYsWdQIy4UMafjQsc27IDW++Zar
         5vT8pfTtkaeNLfn2uVdoodkU6Q01JSIsqD7OWxs9RaW7JEZz8Wm608/wv+6Y+QABsDex
         4U1jHkd4TxZNhd8v14fEGv3/0vUp7zhmkyUxFVDRtUA4EqDnapBP9Wsj27acXdhLVavI
         au/A==
X-Forwarded-Encrypted: i=1; AHgh+RoeWg6d4UMv/2PYMh34p8SUN8hkXhAmDGP194qqbvJCvaEyR3j2AnjOo0gHZF8v6u29sEkjeGHLrA==@kvack.org
X-Gm-Message-State: AOJu0Yw1R3uLe34+HNG71nmx/abKqwXzvuqlhxiGv6kvrIRLaBllgAIW
	Rgm+z1tMTXbb0Vq7w51f1S3+Z8HHiIIM30Ws8sJsyMbT0mnEd2vTMdXDdmCZFbqD5mo=
X-Gm-Gg: AR+sD12ZmoHjz9EBHevR0UWFkAT7mJTy4ZTGyakW/08ksdzJjY4lv06N1I5FD+Pw59H
	FKGwHGDL41BfceQcHMUy10VKYd7dIjk+SICfHalFOaSbBlJQ1O/bherCiquvC/15y8bhNn1bST1
	8h62AewJXSmWjNW/WXwHUtOp9YY7q1HLdyvRPmZ6dOJuf+pMMtfnSHW0JH0iGYSdVv2/z1Q4mJw
	G5yzltc6UnWf6GBZKIjjGp0dtwcB29p/UEgMp1jiRaksjvlF9s6y/mfD/mWR6kuKQSdDsHf3QX3
	bBsitDKGChzkexqL2eSjb1hJRhKv/V+O4zKQziqG9MvDZwgfqDQtI5HV2ljUT0OQm/Wx+rRkbw9
	7LNRCdkV3htIWqgHTmuyfwalY2NVwuk0DDo9vTtOP9isMGhgCAyJJg3Fkj7HnKeYE0fVEp+Rowi
	bJuzknhyjaBcF1dTbraygYvukHqfhk4MHqpgvewxmNjWYK+BYas8X0hozLRnunPgOG61E58Lj3+
	BtEAL1I1k4GwoCEx/sxNaLm/sx8OWyfW3vSf5dTzvnp
X-Received: by 2002:a05:620a:f06:b0:92e:7d53:8e8d with SMTP id af79cd13be357-93704b7d4dfmr142017785a.27.1786979751821;
        Mon, 17 Aug 2026 08:15:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033d2ccdsm67050085a.30.2026.08.17.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:15:51 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:15:49 -0400
From: Gregory Price <gourry@gourry.net>
To: Rob Herring <robh@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Saravana Kannan <saravanak@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, 
	x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <aoMlXHFTvcpwOv8W@gourry-fedora-PF4VCD3F>
References: <20260811162642.3504565-1-pratyush@kernel.org>
 <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
 <20260817145231.GA579285-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817145231.GA579285-robh@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF2DC18000E
X-Stat-Signature: d7gopk811uzum4jun5p8xx1p8bsnk7ti
X-Rspam-User: 
X-HE-Tag: 1786979752-893629
X-HE-Meta: U2FsdGVkX18YfkYL1jaKV7Ru2WsJIDy3rHsSy+BsQderqX6WJTvcPlwZqRU03dm0lIZ1PuFm27379SCpI01h+3BTH7fVM13jt3Tv4FFqYC9rHnJeV2JHBQZhjuOutIpDxQuOSDXv0F0DbEaCJ+ngDUTMascPHxPdtAVnWIB3VXJULwjkRO5CgjYLKCMQdvMw4uD3VGffNUd53IBjmAcfftLFrFsBuk6CCqq9ZM4TVCoG2P0McpR/6VvP8DgFS28q5+Wf9r2Z+uzWJ5vJLBJhM5AA6FRXx4f0VmnmoF0Ll+hRKhrjJYSJn7w11SmvKqhu1vfLU3/2Ctr7QNZk320XNfi2JmyaEfVNXcr/1K0dT31MshJTIKeRkHzp6nLKZ9nVvAn80vc1rl2B5+nYDC43oZC1pzIiSx21IaGKtCiawanhTR5Od2J3xYEg21joLmjzp0iykm6Atpqsc+2fk7bLdz6Q5IocyLvM97Pq7TRez1VpM1Ds9J2WQsvPIZphXjqnpsR+yTsCfuJxNGkrQUvOVI5IOJNSxX5yI3eGm7am51IIMTr5r677ZTB1CiK95H8nq+VBsCVBDCpeb7J/8HW5wsMbPHSOngbyvK1npSmDx6VYtniW2dCdUXGnAzxe8J3NYs1krWkgsYH/rBFld7ZzORoeoZls2Fqni//bUcqLc9OC9RYOVaexvul3axfeiYBF81j7UFmewMt6cxmehK1fNQIzOWdYPKJAVHDLXRWg2N50GXjEKbHXJifzZ2y0RjciRwaRt6T6iZho/t+Yj6vGZTL67f3cAyz6E7vbrELIx8omKCMKnFeg+DyORWg0CLIbsutJcKLWr04LxFi83TYDktyfF0ADTjHLXC7wPCq0rcJoNUAI9wnIzzx2SBOdfXhGTa2soV/pdYI9sL8nmTJ/lhIIzdY8mewt9o4xXT/lXcUFsymt7DwpJkRo3C2fJbmvLfj17OkrRmpogm4IrFW
 tNhJA3qP
 bJ5Os8NmrYfQxIg9nuvv5r1+8sIM8Ce4ejYv+qBnU1WvPENeOxu44U9crQMPLsr4VLo5/IRQkbGCySIn77fc6sKr/XZaXJTLYvwkNxexiUNoZcMXw8aPHua/91h255VZIY3LGgC9phZQxploXR1jtwGB0fhLbuwh+wAqErbA9J+kIDEwxrZZbEDDyTEFt8s5FKTwlfyonzZXBd3CxMvWd6tklpD9VRaYNSGGUvGk80ZOk8zI69LtuJ5Y8ZQ0yOtyBXef6GAgTUyurDxnEwAqGktmGOs/fkvVVGdglljJiObQo90HQ+WTZDV+OLzGHLDja+k8wrBiC9w5ARR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 09:52:31AM -0500, Rob Herring wrote:
> On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
> > 
> > Is there a non-verbiage reason to justify these changes?  Living with
> > "scratch" seems better than potentially breaking folks.
> 
> I don't think these are the first breaking changes. And if the changes 
> are fine, then that means more breaking changes are fine, too. So why is 
> this upstream at all until the design is settled?
> 

Surely we should not break deployments for the sake of renaming
something that is very arguably already aptly named?

~Gregory

