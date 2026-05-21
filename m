Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52498CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5506B0088; Thu, 21 May 2026 05:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875DF6B008A; Thu, 21 May 2026 05:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763F16B008C; Thu, 21 May 2026 05:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 653006B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:42:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F96C140588
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:42:12 +0000 (UTC)
X-FDA: 84790936104.21.3BA98E9
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40F6F160006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:42:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nkKFLAA0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779356530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuiZFKOAP2hQ7MTYXd5knANR52URvsfSk0kr76WNy7I=;
	b=RZTZmhfO6HhmOIx4hfKaqYH5ohMRndqGjrIL4/ZkG8Mpqpl2tm/IXPHFzAt/m1RO9kYtOn
	eV4hFqkEG+43W1i1jyVbXPaBKJUcF/JVIXXmKwuK63OK1bg3KGdv4Va64Phxzc6llnJcdU
	ea06VSvKa0lco8JMsPn0KjBx79PbqrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779356530; a=rsa-sha256;
	cv=none;
	b=6OL6DKTvg+plj9hb+nX8hn2sBtjPxHeoCuaYfbh4mEReehDw5oTxiAmp6/78eEtKUdVEb2
	CWfd3ItZZMJCvgDKt97eIKafpzQikFCx0zVYWvhJDYySr9BZO+w002kVFYpJwjY8In5odO
	moDgkGAMyZarOEcQ6XAu4CDdfA111JA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nkKFLAA0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4903974854dso3619915e9.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 02:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779356529; x=1779961329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuiZFKOAP2hQ7MTYXd5knANR52URvsfSk0kr76WNy7I=;
        b=nkKFLAA0ESSbHrNhEy3JX5ZJ0gsd6cZ9Nh2OKC/J/lyKfYurtS56YuxfI9BtW/NWb1
         /Hmv1hMfm749Zopx1gXNY4vsjtKxLJdihE44uv+532Hq7VXW8l58+IWgyl9pPKu9j8Eg
         jFlL6I7cY7ueew7Fu4Ddc8dlukR8OP3SOBRqC9Jn4clqXStw/f8BxP6ZzAu2FslH4FBu
         AExIbXW4UHnHKEfYvVBvha1/bRCQPDM4k/LhpTnkN240YS2d7+KIJi1KE3139oKA2me5
         1sSZlc2EfBgrwyXv6SDz2VzMCaujtiYkSO9eaV3zGT/2Fwnko8VYkuZDtEHrLYkDoiwj
         x+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356529; x=1779961329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LuiZFKOAP2hQ7MTYXd5knANR52URvsfSk0kr76WNy7I=;
        b=OMcr3XRoa4OdVSTEWDZ/mhKu713Ra5NcGnU3WPtBSS5EjGLXCejzeWlFAZqDAAIzSx
         yiBR5X5yJ+ktKKSSmzNnKbLfOPalhNM0bZU6gRxNEd5mVNq7ZsSIuGi7ijgiiGwFn6S0
         PXBMIbYYbJagbEoq3mcb9gzoTJ0V4wTvkZevkflZcIqLMqFgbZ2vCx0NkjJYHd1EQeo/
         TdQVeSBUX+vuciwP+syOens6FvkmqnRGMNajigFQOREmAhztVsTHnExXuZKeaE/1RKQB
         y8XPWIuOHTrc2aoXJfFtandoKprw4azGXw04F1Z0Dq8wM6qOAWLLAoTCPnJPmjtNt3sU
         CX5g==
X-Forwarded-Encrypted: i=1; AFNElJ/G4Pwx7JxWN/uk44ldAysKh7OXaBR5Onr/0ObGeFn1ucuHR9ALfF84k6xXmAeH4sJhU0MvXGAONg==@kvack.org
X-Gm-Message-State: AOJu0YxcLA5wsIeXWKUTjP9T3oiDm50Kvs7Zn4vC09DujsT57vfyQ6Dg
	jmomzcs9I/7DwuOAT16NQ50Pk/d/jH1JHjq2vfoTOyz0Dbktrd8hm4xZ
X-Gm-Gg: Acq92OHt1CZdb/BmGtWStcKC540slUfJ26xDwFPjeczwWCIVPcPJGUJRazfAbLl/CB2
	DNCMncangxAeKskSuQos29VXSMN702v6Fc8Vr9zEqWZ0hd7X9TP/TPza/rhTFWaUseTXR6uvVnc
	sPKvbb8z6zXuBtPUbwZpVOyZOFm1bv/raUjW3xOMJRJ/bu4yksPH1NxUjmO2QCJ7Dwar6ew0T5K
	m12vB3gdDufy6mkIIFI25HA1krZNpu0NLPp8TDmLezhIpaPUxoAsB45HG9rb+BVqTlS73XWOwGc
	/pwXpI74MZeRry5JOFv5r/btZx+pz8BIiq/kAfbpUHBuagDLFTIC7OsPstENnKeCRznYfjbQ1+j
	vaAveg5wyezYE8duPYe5e3w42/nSQbsb4ZUH6TcSAENFtgBL1SYmZthzmTTTVkrSl3BDFZjl52g
	oOnZDRpRX5r1vHzRvgpb5fLAXwjpPGOI89LKg5iqZVfPxHG68R7+S3NFSkuH7alHgI
X-Received: by 2002:a05:600c:1512:b0:490:2153:2c3d with SMTP id 5b1f17b1804b1-4903608957fmr16164075e9.20.1779356528456;
        Thu, 21 May 2026 02:42:08 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d8e71dsm50329955e9.9.2026.05.21.02.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:42:08 -0700 (PDT)
Date: Thu, 21 May 2026 10:42:06 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, Usama Arif
 <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V2 01/14] mm: Abstract printing of pxd_val()
Message-ID: <20260521104206.1c7d3fe0@pumpkin>
In-Reply-To: <74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
	<20260513044547.4128549-2-anshuman.khandual@arm.com>
	<74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 40F6F160006
X-Rspamd-Server: rspam04
X-Stat-Signature: 43odf7bn3ato3h6kdk3xdrhmj5nfqepa
X-HE-Tag: 1779356530-8975
X-HE-Meta: U2FsdGVkX19EOV/VoVIceuEpmULb9z3j/rdZxOneQ5hPLbNpkC6KttwLJHQj+9RTqZToTmViBZZtVXoVic/QyzC0kUls110UUAVzkbryGs7ZllBnwqfEqgKYJ9H3TMIAYH94xjolIlRebNr45ZFYMHnL+yib/l6FUaAw/wfEe1GgXGBO556mAT52JctfGwusIubzoBEs52z/vWng5p9p08AoUcITl2/tHzCq+AEWMBkMA/Oid1287IypeyxaMUlswej9kFBL6DDty2YVnVl2my4ijlTZCdK4heRtPs2J7wl5EHgA5/ROl8cQDkYkVhWd5RfHHb5SmwZyQH0X7hsJIBj9n4zt0U0oHBV35TAkDktFen9id7HLuR7cYVAPyg46IAdxCLeH92YnIjjZjzbjmA/Jv3YDd5MBKzdJ7/1TItvI0Tbpt322jiaVn+EILxfefI/wCQs15nqB+INW+QrOgbrK7gqn8J8wpiQsbTwXffUmp3oWSigt/LRu0ONDB9yJ5RQM5F7SLaSPmO9ap8CWQA64STqGCRMn0qs/VGx8LWOTZkyhnoGFfrp1uckflCyg9cW9k1GE4CRG2DIkwHG0S984NH/UR/pzgE4d6LmsUYmEYlZouz3MBoKZg+xVSDJOloVzSkxYn+hFFeh+t1PJNQLye934BkEHwyY/ULBFl+8QvVRqmb5+rCoBkQTeA9mqGHF2oSdnhn5xXXNJlrbnrhlS54uWCVKPUcQYuVYHyoycoD+vq8Q4ghfTqcQLSpkSOvdO3IhUpEwHjSlJmcmj0V6N5noOLxbK3wtPmIG9sebAEDCeUmjXHIG3ou/f3T+k9UOnlHIeKqYOtqd+kLoVt4nIZi40QeiGLZ35kc6eSChqGWC9FYyofMTMKie9dOVj9DshqPzIa7Zqtc5ozTT8Ier5BBx/ZyPNBDfI2s5nR/oTbVRHmYFxJ1inuC04QrBNYR1+AiZJ3mLpjzfwGWZ
 geRGq1DR
 GoNzCv7ldkLP4SupanQkqQsQ9X0yNg4VqoaecuXsOkXPZf00mipouox+7Pz809tV8TddnzaPUBNWRxHXJiZm+Cvd7Oz9jSLh45TLyVej8ifCPAMxNwOqeS3YDvO16kpiCunGIj5i8IhbL0amSFVesX8BaaGvBMR9Y4CQFLqTfzFxgURtwbKetoRe0rjt3OXJfCECiNsL75NjjP+x57cLE8SKu3F9tMug5dz3Skjr/T/C6hF3txkm8DUf+HR/4E464pnNPDq7ktL2ZHtF5nlPe5+rG2+kcp8bWg+FYH0Cb3iePpf+FK8a4VlJlS/5hho/5ktLC27FGaOJXNGFVpgC1yUBn8vP+YaRy/j7yglnhswG8wWpKmTH4dWhYT4WCDQ8zDJLBxboQ2YJYAeQKeg/j2mKJexeOzV63V9Cw5cIgVc9gjTYqY8bhrjkyHU5tWwg0+zK8JejqNAMYyZ+7Bwvwq+dOGKHwlvaXlqeM8h3q7V+PkZ6WRLZOwEgSXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 07:28:17 -0700
Dave Hansen <dave.hansen@intel.com> wrote:

> On 5/12/26 21:45, Anshuman Khandual wrote:
> >  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> > -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> > +		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx "\n",
> > +			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv));
> >  		return;
> >  	}  
> 
> That's not the most readable result. Could a printk() format specifier
> make this nicer? Maybe use "%pT"?
> 
> 	pr_alert("pgd:%pT p4d:%pT\n", &pgd, &p4d);
> 
> I _think_ it could even get rid of the p??v variables.
> 

Adding another %p variant that is only used in a few places just makes
it all harder to read.
Perhaps a local helper that lets you do:
	char pdgv_buf[??]:
	pr_alert("... %s ...", ... fmt_pdgv(pdgv_buf, pdgv) ...)
might be a reasonable compromise.

-- David

