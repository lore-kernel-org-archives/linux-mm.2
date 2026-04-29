Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1CACCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 16:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE586B009B; Wed, 29 Apr 2026 12:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF526B009D; Wed, 29 Apr 2026 12:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DDF6B009E; Wed, 29 Apr 2026 12:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88D6B6B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:14:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 567701A027E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:14:01 +0000 (UTC)
X-FDA: 84712089882.06.275F435
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7323D40007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:13:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hSY9cFws;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777479239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQwXlv6d4SrpAwunOCAy3T3SkF7dwQSFYcS5dAIRLRw=;
	b=HLteewfk4I+/70G5XJNBYqKRBHkV1hmcdIqAsppKW8ocjlZ4EPec0Fn9mbh59QbVvCC191
	51Sa/z0fNHBgZ1gTmZPTcMIVrGcRfz1k1zFRRAiRAN85Dwij+JN84SXgqhsw6e5DmR0d4r
	BEAdlMgh08U1xiFJuctvuKSKwLeIBV0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hSY9cFws;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777479239; a=rsa-sha256;
	cv=none;
	b=h3ExHRTCOHp1MLsGWHKaPbeZPksL85B/ymNvbEs2BfauIFSQzFUP/wk9i1S753hKjYJV2N
	YpsWH90asO5E9NXfhYLiOpsuqJ0AgHwlNymz68CdRGJoGu+rypzRMCzaXmjCId8qxAcX+S
	+jklj2uB4YsjzWt7Zq8OMB5pGmCtj/E=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8ec9f099fc6so1079735085a.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777479238; x=1778084038; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JQwXlv6d4SrpAwunOCAy3T3SkF7dwQSFYcS5dAIRLRw=;
        b=hSY9cFwstlqJY8T5E1yZCU5xxEJlC1VYvmKaLXr8/WbCYDORQbCa0wp6mtpVvVyNsZ
         i0Se6wGltEr7/X8SYLRUdksNPwSSq9oaLeWhWwaZJUlMzmw92y7eV9VZz4I2KPGftYgo
         kjg+39KA4B9DTF0LzzgabAcEBktammVExSjtiPrXH+CrBA0PShW8Va4IMJzLpS/dat17
         muD2ENcNw9uZhZasbQ2hXG7KjYtbt4R/UaWCPv0gBVXEwfIn+fGA0uoY/US7RCvPmQcO
         cmdQ2NfpAAdGq3iIB2nvZAAAkXvX0IbfZr6G2wBl4ORTiQ/K3gfmGChdF3AznOjjpFTC
         u3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777479238; x=1778084038;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQwXlv6d4SrpAwunOCAy3T3SkF7dwQSFYcS5dAIRLRw=;
        b=Tp9Dy7wX152iJZeRt2euuH1BVNvbiyTYBTIav/r3j4izodyChKYBUfpU+IsYMxdRRD
         SKqzdM9rs1UxL7GK1nOjgeep+BUWEIJFC/WgsC3pkoH9wLkFvQkS8d9aBy7cNzoswCn8
         llEYgF31dv0m5DzmH+DrksqRnhuUvc6nRWw6tFFJYYX9rN3oeSN+moOJbcJgq9JZDWHn
         2QntqT7orQlxnytFtfEu4dwjDLhWBPsiM92/FcZ+KJOCnWAnuToqW+wyj2gBRX7Jkie8
         7aqZ6njFdQPzJlX0VILi46+vpYBQzhmoeQ/xnArrwbQZ4pNX6zy6TY7ojoGOUVpQe4Zw
         IkWA==
X-Forwarded-Encrypted: i=1; AFNElJ+znQ05YrR421I7l+xxVlZov/CyTaMN6pGyXXFRHV30SN3WTDL4+w6XS1+GKcvHn9yTELA93i47kw==@kvack.org
X-Gm-Message-State: AOJu0YwwACrrtpFANwzNQ6WAnbL4/WTLSViKonWS+PmlB3mcPTVs/JaS
	7wh8iojhaKmqMdFlSRD6+kIJDJ2+vViLO5q2GYOtU+8O7aEaCCrpTwvOJiNHIlBpAYI=
X-Gm-Gg: AeBDiesq60/J6pTcPvGDe/zIaTv7A4ENg+w3FtwviHmriyuRZ5RolZrtqf+hCqmdRyI
	aWGWhQSTDPUPAR0FKfPbj3DRJLfEhqHE17oS1axWvo+kB+d0jLdomuKq4EYZE2JYfmGaItbrTvz
	Ct+QmkWSjQJ8iBU8x4vK0HNHuwAi0PzQf86VsucgagH0TtEeJmWsqnIL/7CBvR1xJ+4Or46p4Dh
	sU0UdNClrFdVdnkwXAhtaKRue1QT+QzUoNoAb4xMfsbhZZd1NQMDm4YKeJt47m93hq9aGrkgaLx
	gjbbfY/dPRjjCGT6EMBj6TXnu4AIPIupksTMcG8j5x2yibjvtDeI2OWSYNEmQ8YQVWul23ciDla
	Q94fcSOQgReFtazRsMeWSYx2BB3YNYAliHFfUUeaqCdELVFdlCggh5vs9rLSolDzpiiLGGCOdao
	vpOtkGJI3mNjw4isINodsHRxBjlDhlkJ9XlsnyCxQ1e6am9c2ksJgQ7ygn81TIE6TvtZmasRx4
X-Received: by 2002:a05:620a:472b:b0:8cd:9033:172a with SMTP id af79cd13be357-8f8f3a204a5mr643580085a.3.1777479238360;
        Wed, 29 Apr 2026 09:13:58 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f93f5826f7sm235640585a.30.2026.04.29.09.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 09:13:57 -0700 (PDT)
Date: Wed, 29 Apr 2026 16:13:55 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, 
	pratyush@kernel.org, pbonzini@redhat.com, seanjc@google.com, maz@kernel.org, 
	oupton@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com, "Petrongonas, Evangelos" <epetron@amazon.de>, 
	kpsingh@kernel.org, jackmanb@google.com
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afIru_PE3W0hIsu7@plex>
References: <afEwWZksU0Fw61oT@plex>
 <b52e7d0a-4275-48a0-850f-6ceccfd5204e@amazon.com>
 <cd0ae5795cf14a7b20c90840b0a3eba7db160e72.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd0ae5795cf14a7b20c90840b0a3eba7db160e72.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7323D40007
X-Rspamd-Server: rspam06
X-Stat-Signature: y5z5ebwy69sq3y4m7dwbyyg7fk9i3tut
X-HE-Tag: 1777479239-239437
X-HE-Meta: U2FsdGVkX1+nxHqQPPKOV+bSQLqFBucb7+9NVJ2y/gH4CisIHWf1K3tBbWd7y99xuczjxHyc8fHOQXsVt6Cuwq8NLGVRH7ZVFV6tT1oOXOhADeNDyMcD5W3lHIdD/FNa+JrcgHPmkV6vVzg6WwZeSS/oKl6o9QH+uaCaF62Li3N40RTNn05Cr8vP5179pG1H95D/YgO03gRjKc+t4NkrQbVnjtJrbtF8KqgR0UW9SQtY7xcnZjc+QFUzpbeod9b/b2ccbT1jOAfUWYoZLjQCf2spBbiBY+9Bw6bBkwYEq6XIeOBtrrn7zA5z8Jd4Ez8dkjhyAGNLqbuBx4tOHBgneMswWUEuVPapkVddea8tpIm3/SSXKG1c0TJxDOPBc6xXeXLo/H54m5TCUb4sGjlJHhvxjKaFRZUaqyBTLVo9UbHvkynP/h4xY3SF5gyUMklPLpCaEtSKzJbBLgM6Bd3mHLhVh3yWypSImVJ3+30M+HZmaBNjx2nV66Ahe/9EuQ1pYNcoAEoALKJN/vNP6yDTlJa1kaccnszRyY0sEJ9eqpIs1g0i0zZrT9DAbghXmc5w4+Bxev/ydZ3pnr8b8e7Hhb6tyhZlvRkbqVrtrFkmmH15Y8vi02BM0KESYTL8HPE6B8Gw2auaZLkV2U1S/m1bycdYv2hoRs5g8GBBHVX6enEDEyekrnLCL869J/vVvsE7eQ9uJgl+XLaJ8Bhl/Pk/BbtIvsehMhLULxJ0+UvCqHMjCO1oiGjTvH2ln1907TI+CAUZEQivTCQCeWXakx+ux/z+jWgmCoUBmPE+DWugLC7BDb0p3mqc6xniBnilNvzzR+DIZaWbyxfZhaSk8tjrkHUGD0LdIn1QJu03D5wjYrHcyHalc+OBd+s7u2wwrVxE5Rng5MdQPExd8brnyUW9HmCHe/40aJq7Wb9MBOZtD2iPtgZ0rmojgNxiyxQXDC5hezpOzFiaer20QHN1UtF
 KKyqDJRh
 eZle/SsEtg1P5OD8F0iMetWc28fXK3yEZDOew/9GWI9aW0T3/vnpcfSxwisdjTReABwgALLjGyWCBDYqblR0gfvUzh7Yl7T10rE+k6SZRHcI3FzI9b5EzHeHXDVRoM7aDV2sDZUNevO3RP7PVYG9Zvijw8vdC6uPsD88XOgyN44J2FX1fmR4dMdMDQHa1bB/nQ13kwvuDK2sr4nP3WIFxvis1npbnWrlDFH61LRPJ3jr1ryO4v69ll8Zi5G85rfIDnvLKmyzCIrlKqVAx12RF8Ie8Xw64mifuBmjU5h98wfNHiyyZb3xJ70Zzm/ohAGEKMNmJCesIGHGGFb4vWuX+mUG4W87lK2LxPNBrIhw3KaDINaBzrwxbXhe8E8aExLmKx+/153ZlvhblATZUm9bou29pUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 09:40, David Woodhouse wrote:
> On Wed, 2026-04-29 at 10:13 +0200, Alexander Graf wrote:
> > I would prefer we only attach the whole caretaker and all of its 
> > specialties right around the point when live update happens. Why keep it 
> > dangling and active forever? That way you can also late load the kernel 
> > module that contains it, so you can be sure it's an up to date version.
> 
> "Why keep it dangling and active forever?"
> 
> I've always wanted to tie this to address space isolation.
> 
> The only way to truly stay in front of the constant stream of new
> speculation vulnerabilities has been to just make sure there's nothing
> sensitive accessible in the address space at all. Hence all the work on
> secret hiding, XPFO, proclocal, etc. — and hence the occasional
> researcher finding their shiny new (5-year-old) vulnerability and being
> confused when it doesn't leak anything *interesting* in certain
> environments.
> 
> I'd like to see the inner KVM_RUN loop switch to a completely separate
> address space, in which there's a kind of caretaker which can handle
> the bare minimum of interrupts and timers and the most common exits,
> and which *relatively* rarely has to come back into the real Linux
> address space.
> 
> And once you have that caretaker running in its own address space...
> why not just let it keep going while Linux does its kexec?

Yep, this captures one of the benefits of having a permanently attached
Caretaker.

By establishing that isolated execution environment for the inner
KVM_RUN loop to mitigate speculation vulnerabilities, we naturally get
the hardware-enforced boundary required to survive the kexec gap. The
Live Update capability is effectively a byproduct of achieving true
Address Space Isolation.

+CC KP and Brendan

