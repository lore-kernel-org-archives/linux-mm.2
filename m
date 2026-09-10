Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FCAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A566B0093; Thu, 10 Sep 2026 09:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251A56B0099; Thu, 10 Sep 2026 09:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141016B009B; Thu, 10 Sep 2026 09:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E640C6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:40:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 601054050A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:33 +0000 (UTC)
X-FDA: 85197962346.07.B1119FB
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8312840009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PAd5zo86;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047631;
	b=tURTNHuZbSvKF0XB8+cg5XuomAo8l+gM5LvDJ6N3Glrytr6vVAkAYGD7ugQ2Qo4Cd+9zys
	7eKtcXtk5YaZKSGbvi+yI5Sizv1tUfpmF92RLuM9MJLnGlODZTQawFhumDdPfg7UPCvhq6
	zXaz8aEoxatDMchY5tk8dwWbXtvxnKY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PAd5zo86;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aY0bZ/yqrjuFAG3J6+JEFIWAYMbJQEXce7G9l1M4Rcc=;
	b=ZEeimXdosLLf4Uys1SOKMmL9yRHnU2FpgUNIXYl/g9joo5bI+LQfcwP/5WzFDecMzsE6bZ
	AAGrVcUFM6ld/VYHWOJOKhTLGGC9JL37ziVjWLXrpAtqj0QMlYkIKkIjnl07g0FG/0CnaN
	IRuYH/4Lx+/k7EiAspWnna8LBqi4HUk=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9377f717879so377216985a.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789047631; x=1789652431; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aY0bZ/yqrjuFAG3J6+JEFIWAYMbJQEXce7G9l1M4Rcc=;
        b=PAd5zo86t5PmMge4gCJviRGE69jPty0NoMkWBLu4RarK8Re0ypp2+DBFF8c23VhWlK
         zhPX8y7jsnAeEF/mR5qG4LOBQgET10N+1LaPwacicVohJ4KvkcPYXSXEWqJgcKe1Snt5
         RPVWAzXoi3Wc1LG2O8mJ7AaR7d4aqs4gmB+SmqDubDuvoLq8gRNI5RuPNbvUGpVc+oN3
         LDfrOZfZ6WI8i0F//ypraJEic/3PBHrkWtstQwI13tuTqO2MG1iJ0jm7OsJRcq5JBXGL
         SMzKbO5otIleT3s8Np+XVzW1mCkGSUKaNC8fJYXhXDsu3UlGH0JfMgdwtbEJuVPkYCgc
         4HPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789047631; x=1789652431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aY0bZ/yqrjuFAG3J6+JEFIWAYMbJQEXce7G9l1M4Rcc=;
        b=V8+9MM0NZ5jF7B9jVgDh2nzGJBIVpS8NUtIZeUUFPJBTPpv2hd/ilnTk07x09FwNZm
         DfCbFxbnU/jI8pkokwnlQL5CWax3sc/Z9Owc1wFMpl9vXW6pyOwll0I3h+RH7+QsBwq2
         ymGxFEk5fpz9k+Grzsjg1MOJT39WI+6NFej9zNb8Wun30U80Au5qqxM1/FYOX54XD8bS
         68piF2/D6uUoStZLQNNlrW40sEBLL+1QWdyDpGBHxzVly+rdnFsjfDOnWNq7BYpyZTuR
         tYkbsEVyGXmk+NpZL73Q/XvvwKOFdicP7pgWevRbZnSF0DiiItqtmuxtJu5yOLqyfEKu
         stuQ==
X-Gm-Message-State: AFuF++mpAGo9dvasW9v+u25Rd4rWAEjwBAR3DRLMF299AG43uIj/YILL
	zQgpgN/T365s2rURpZdmYtG4+b9uROmCzKtHrycxZtkC1Ka3EtqVP6qrBt/0VkFcYKI=
X-Gm-Gg: AYBFou1xf5mclC776LHE07Qh/SUoIYums/fG2vorAYqvXlCzIvmGFSddHb9W50Lrg/x
	vHXhDr8jUik6nrP0YfFkBQaHbxqO4q75JIyeDZm6nbl5fGJhR7UzEfGsDQVolLLZ8G/nsJEiDUC
	cu9SETrZWVsXrBsbAQFFFVcb4cdOAT7QPms9Pi6MkwLqUQ7LvNc+BIjv9+3MuHO1Fgf77NRGfEw
	J0ILaw0sL6bVJFe6dcG7PAnkCdI+qaTNAIDgovwKy8TX5uFylUKEkNLN41lcD6IvaBX7xdAftcE
	hrbJUYJnnDXpVTzxxbvPF45NsT0lgUnlJ0egVROWF096s/mJPbv3x2v4PWkAO1xXB7sqh1HzzqV
	bIUhwuwVMrdZa/5g+SzsgQnGA4OkwZvfDRq/pwJIMpXNj96k0d8xZ2oUcy+yTCXGE+Eg9/PLRI+
	ot5luuP+5YoP2CtQOTtOcC1bapMGn+xKlMl/tg2btZRjwp+BxwPfA/JnK1WN8AAXm2vUgX5dqn0
	6AppO08foKk1U+mQg70xmYmjrjpOvOJXX1CEQZKVGbIuRGLvRcId+3j/qzVdqlPAg==
X-Received: by 2002:a05:620a:2a11:b0:939:a2fe:926e with SMTP id af79cd13be357-939a2fe971fmr3077102985a.17.1789047630473;
        Thu, 10 Sep 2026 06:40:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e190f8c3sm78468885a.17.2026.09.10.06.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:40:30 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:40:28 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	pbonzini@redhat.com, seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, shuah@kernel.org
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Message-ID: <aqKzIO3DD66Dhkdw@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net>
 <9b67424d-70e5-442b-9ec7-22b1d3db12f4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b67424d-70e5-442b-9ec7-22b1d3db12f4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8312840009
X-Stat-Signature: cy4hex56tghqyzqtckjb1fjyn9mqxbit
X-HE-Tag: 1789047631-235577
X-HE-Meta: U2FsdGVkX19IZPeJeBrD8+Ufi9jbhqATK6XcE3D791t68Ws3SFdqQUip/f2TZqcVuh2nS8+FuBjKzA0bd+7WSTnYiiRvrzZO1GElVJJEaU5oqrOKblBC1CnHzWrBpZJnDWxhHsb5ZVyMPghIU1tv7vV7TJOf6/+02AVBoPuT8WcScJBqQuZsNRmX+xmYGzLrVRvQyOlJEo27DJFhkdDk+h1mdLM6V2QE0muuyu/AoaWgW0qMhb1mWwUnoR3ku+IY0Jj/BatL0bxF+0f6uueIBLTlmMUjRg930gvyMbN2msqWJfr/vxX1y+3UhALNrwBNcI+473zHGnun+2Mwk1VQ0fdc+Vdq+KHb2UPs5aqPngANcADN6b1cjzTdDq5sh5sc4hArsyzvAh07Y9LIJoQFxfNh2AsLBdGF55j1ObsuDDJDnFTqyZR1jTuunWJeXP8YCglsNoCPfy+zL02z3BAyjC7CPY+h+GLExbl/o92VfGqctQbR+iOfsK5l20CN7rVG61NQYr9Whxyyjbkt9RjwOtuTwxffAu0ZSmV5jTFawUz+VVoKpiVC9wJs444PkFuP/FEXjnnBBZbf0XdUjq2Cvp5TSkPIeT1i5IffX/MC6PdS7JnqsBJORIugNxccvxIXCsAnSoHjFff3mzyUmG8ugdXusf9pBiIOj5UwTAqkdzAbn5l+EMBwSRTVWv32SKbgFAiWF2t/OX5GTBZrB5Us7JLTJlo280B7ESqK7pOnonwPLkXFcRcW/8zY6RDAXyaAT1EbGjtCqEOXXy1iyMG/KO3yp9DMfAckmGucX3RZQnEjtufkHXMY/XdNSGlK9Y+6r1Y9jwLuyzW0q3jBjkZrG9iitseM/dZS9xVu/LUlTeLxIC0eZbTdjX8ThPfGc2xX8ahO83rYTbn33tH+rC+nJQOxoVIuEE01V0pEz+vIsgMAUzdXqp491oczSV3wKU+pkpA/3viewrJpNLp8H0U
 v3CZPTDe
 DVa51yaMOvcp8wPaujYsBf3vBZSYTiwbfAB6sl6jyaRVjd7vYiu8vbkccFICf9Ti/vtE1AANRUcnLD7pLqBIiQ+5dXq3nJLNuOqLTeIvIwmZGMUsQK6Qh1Jfpkc0l3eRop2htw3gV4Rwp1Wa6bgGPorhzNXsKXscLDG3jQTWUjMQSBCQoq5PpIXekGAbsibLBQdOSM8Bxs0U3BtkGcPVkieBWuUa0j/LdG6jIblGFAFuen5D0E2FMGcqn92SOvVqloL0TTwjjuMbd1m9tBATXGJ5gELCojNZu90NAAi4GeLmRr1B34MJldLEns4uHucmLVME7JkWx+M6/pOJM2Ej9O3wrNmg+M69OYNDL4yCMKZoTYzATfuHoLiZFjQz9G2tH+djsAAf8aVSauDFUjLyc4bx5e10feY6b6VuDIi4WkkTTTFt9YjA+UVlZMQrIQtHzME3nIN7PIHX/ghY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:30:04PM +0200, David Hildenbrand (Arm) wrote:
> On 9/2/26 21:46, Gregory Price wrote:
> > guest_memfd allocates its folios through a per-inode shared mempolicy.
> > 
> > Today that policy can only be set after the fact, with mbind() on a host
> > mmap of the fd. That requires the fd to be mappable, and it cannot reach
> > folios that are only ever guest-faulted. Neither holds for a
> > non-mappable (confidential) guest_memfd.
> 
> That looks like an investment into a mechanism we will soon consider legacy, so
> I am not convinced this is the right approach?
> 

Hm, I think i've missed recent work in this space / this context.
Any suggested reading here? Don't want to eat too much of your time.

~Gregory

