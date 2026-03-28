Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBA410BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D186B008C; Fri, 27 Mar 2026 20:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945096B0095; Fri, 27 Mar 2026 20:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A606B0096; Fri, 27 Mar 2026 20:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73EFA6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:41:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13027E0850
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:41:01 +0000 (UTC)
X-FDA: 84593617122.08.7C4752B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36FF8100007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:40:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nM+F4mPZ;
	spf=pass (imf14.hostedemail.com: domain of wyihan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774658459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nStNyZTKOlE87jhF0HQxL1hyyc8Mzt87SSZU0LYZvHU=;
	b=Pywgb0aazAsWMJsbG+ZgrRxk8Bdo5loHhxp4C2jH3TqZ2tIkYFDLKM47hhE5IAXMsxQZGa
	XtpSWn6gbyuX9af8UfOfSBsMOVCfe/ed79pqddE0qtWob6IkZsdwduDrEEOUcVtSuujEZW
	M0plaum54atnX3cqBWq1EVqwJ+wgKe4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nM+F4mPZ;
	spf=pass (imf14.hostedemail.com: domain of wyihan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774658459; a=rsa-sha256;
	cv=none;
	b=gQfijkuG7OlJGkRfba9PVDTqVC4TZur14f0GiRc6raNbPMvzM/lDaF/cWdJGynGb84WvNG
	sNMjNmdRrcdpOIhWhIIa9Pn5HfvjvCf0l9r6ecxqGBfpceY/WD1N/PAwD5vEt1TIDoy0zU
	ZdSpXSueoJfuqgUTok/NMZemaWBjhjM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b0c12be0ecso39545ad.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774658458; x=1775263258; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nStNyZTKOlE87jhF0HQxL1hyyc8Mzt87SSZU0LYZvHU=;
        b=nM+F4mPZ/C6ddEuh++oVyLYoolbqdUDcMYwlGCQF8Skk4GvbNFgwZKj3t7Ubehp+aO
         TyeR4zd5NS7/lJqXMbt/X9LpMckcmXJihYz93WA2UjxLXhcQSGWcH/71/XLRp2GE6ika
         VLGlmN56+ahDe/TXS0Yn0DVyt/F2KiKK4T9Ccpul9luGX5nH1bi6uMT5dMt0jNDQt0XZ
         tnmCRNaUSh0lXekzxi8D0ZJ58r7cSCQo/gpFGcI3s2FcZ64xaoqW1Oo94b3O2dIwW9t9
         uY9Oihpa99NzRou4QaVS98R2QJCuhvefOy8o9XkKY0eqrbNkjVmCMl1WTYzjw0rrK5o/
         Uhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774658458; x=1775263258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nStNyZTKOlE87jhF0HQxL1hyyc8Mzt87SSZU0LYZvHU=;
        b=NUavGoIpXOAnWh8tnd8z7sqf3f2w+c6uTUVfpUU1b2WyNn8xQIqnugvmy2lCkbUiU2
         s8mdpVCyl4PAcSfWD5LDwulGb8kWrudNQSRnyJWoncbNKf6/KdwlhhvDha6BFs/KRLmy
         sk2LQaLToTj3PHsxVl5qgKANO/IQscugHX7YBpYMv1FShdFxjfYMGuLSXKQ1zveiUBoy
         rBLFpKG1ds7+pxONBbRhHK3ZTPXCQZSUXTkUPdNOvBcTbA/DpoGJ86ibJw8yig8x0rjG
         mM9Y9VMbOiAeYIY5jB/Ty70Q7eIYqT4xJaPaEZAPJa3DrO+HYmK9lzbKuD9V/UBizK9N
         gv4g==
X-Forwarded-Encrypted: i=1; AJvYcCVL+okjdqgx7Bhp75i6Vmo9yn3RnmaOSdDOvDjcIInQOW4OpnBWJC5hFg6Q3M2wqalEBiCCXi8IYA==@kvack.org
X-Gm-Message-State: AOJu0YwIlStu2F2GbVVgZIZOSnm3Ix6ix8X74SCmfwUdwXH0RyyLQg3J
	8vFaCFlwzjuKHPGY/3mrSjADA8mUqEctOXoOlQlpNy5QfrUC/uKZMvqVnYSzTcW7YQ==
X-Gm-Gg: ATEYQzyF/8OlTpaWLxjh9FUsLwQrSyZIa35xSeZFlqmX6uWIrxMZetmhwQ/ChJF7QCC
	JCh1/ZfhecJ+n2wHTrmX9ZfXwVQpWTs0tmgHG5buODVqopKI5sggr08vAsuG5m9G3EAynmXHPPF
	+uSojECMlY16KzgKmWXKffj3J4Yqndc6IDTlMNhvRM1zX/gQUYqEg0sdsw/7DSICKBuvd8Y7/b2
	Nne4H46fypn2Wmyv5OlfJJiV6Em1G4tWHev+uuQ7Zot6nlu9RJTQue0ZtMTcXFfFChsDnYLy+q7
	0oJAG176cg+i90OfgPuueXA65F2/40S2P8/crjKMcnlbsFnc/giiosvTdGHmK3faSuMQRPkYreK
	zDMzZPseAxebHuTvBo2FHvGPBZVofi+l1XqXcGZM0uSp9EDHrSh+61tG3vaC0GFxDlUTpJQs+su
	xN4Go3H+D8pjyDzxoPwGkJtlirPL8CPTyak9C32YagUDJG84/sHUhcA+pLn6c=
X-Received: by 2002:a17:902:ea02:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2b242d1addbmr913375ad.19.1774658457398;
        Fri, 27 Mar 2026 17:40:57 -0700 (PDT)
Received: from google.com (249.53.168.34.bc.googleusercontent.com. [34.168.53.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427c4cafsm5106475ad.81.2026.03.27.17.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 17:40:56 -0700 (PDT)
Date: Sat, 28 Mar 2026 00:40:52 +0000
From: Lisa Wang <wyihan@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, rientjes@google.com,
	seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
	dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
Message-ID: <accjlG9lUyDQO_mz@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
 <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
 <acHeLL0l948jRchK@google.com>
 <52c26e05-5bbc-4f63-84bf-c4879a6de7d1@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52c26e05-5bbc-4f63-84bf-c4879a6de7d1@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: sqss18niaa9qr571ybwdo3ag58n8495r
X-Rspamd-Queue-Id: 36FF8100007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774658458-103329
X-HE-Meta: U2FsdGVkX191kXhVqAVt8fl4fSnAnyEOXFi6TtLs+K9Jqm0Wab62d9qW+RzQIkXTxP4zAA8coMRoFBD5Ed57MGAQd7eYDrDPglUWlYsc8czQiCYty0U5z5htbuHycecKezy9VZQmh664FD1PxDx3O5FgxrgZidRQ8KzBNTuMXFgu7u2fraseqpduId46M3bSf9u0lUyOcFsa7N+Pr2m3IC03yZgM+ee8/BgudQsA+lp5OH9+TOj/PqH4VlKsQQtGb3tbMxAPlKGeH/rCngVTT4HQoU6JlBhSYh663dhOQ0povWoNMGDE2Ua1SM0iRgTO9TCTC2GYFxhNgGZj8RcTdPJWFgiB+03XjITHkc4QfuOZqk4ENPX7D8p1lxfduVcS+hfodavf+CYVnXzdBmR+W5sWAd9wr6LQsxWv8sYnBAr8A9WTMjxfZdPFadiNM1tx9zIi4Y30dCliq3x38Ig84zwFR1zUozyHHqcTCe2Lg1pZS2oCrU9oqtLm2Xa8LoHRLxjl+AOlnslUns9L7YIg4ZS1CZsJtmEv87wT35nudB87nEqpxT38tBZn4+JYpfwMK0pe71Y3QEv+Qo3NkQmIAeviQgIIyagVDe1h/YchvxpX4qpzHWkIePwVqEwBoboRizJsOUjf4dpCAkOSzAxcm+0mBAZWirlKj/53OTknn4E3EhPlKAzzK8mpD8R+t3IkDoGRyzuvVzpgTZnLIbED5n0bCSFSo9YRHFRyQTpZGhJwDbPZ6oxlUY3Wbe2jopAA32J1LqU/hv0B62AT1cOOoi8ryot1o7iP2pRsPZ4rpRsIF6ZFQf2IpaMAsGNZIS0RnkYjAyv/PGTQWC9I0fzL3qOszEZMn9+bONBIfhLVLeJSGQxcTupQzI8G0kjM1smgyWfcg4UTux8d0DJKlu0rNKSbAk9uFn/oxqQlqLqxFRFygp0+wsmycno+9LgnuK/AIuN88jzyrQN6UdlzmqM
 u80rlqoq
 zeWirHpazV9HVkPmEv/X1f/V5HR1ro+tegdkIOmSQOt4V8A8CmL9eYSomCyLWnBwVsrgcVfiyYQ8qj1WJ2PB+tD+EzoXTEFcmP8IzTSCsai7u/vBcmq42itHRA5xrkUTJnOinq7MOlqMUGjTfolD/FQdxoSOwbkT/r6FN9lJy5Y17anh/IcA2+1/Rh05/hqVuMQju23eOSpRFWbgY4gA2yn6Bg9C9ttRfWeGkBlZRGPIRb/L82zNSpYF9ENwsHqIXcW2A5ZO50u34O2mIU5K3KdbAs5vIXybrqQsbiGQ9ExS9aaM6wIsigSW8+xAI8VZmhkrVV9aHg8vnkqs54lYxunWzkKNnmUROVA2I/nQq7xwMurz4h31X+O2uLzLjCWM1+BvTmXkilBnfLrX9CLAc9Hx3qLoi5fQxayV7whOOuU0VABvdI+o+wfdXEVcpgUOdrPok9qeFs+W9/c/Swb3+MorDJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 08:36:36PM +0800, Baolin Wang wrote:
> 
> 
> On 3/24/26 8:43 AM, Lisa Wang wrote:
> > On Sat, Mar 21, 2026 at 02:30:04PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 3/20/26 7:30 AM, Lisa Wang wrote:
> > > > Add a shmem memory failure selftest to test the shmem memory failure is
> > > > correct after modifying shmem return value.
> > > > 
> > > > Test that
> > > > + madvise() call returns 0 at the first time
> > > > + trigger a SIGBUS when the poisoned shmem page is fault-in again.
> > > > 
> > > > Signed-off-by: Lisa Wang <wyihan@google.com>
> > > > ---
> > > 
> > > Why not move the shmem memory failure test into memory-failure.c?
> > 
> > Do you mean let memory-failure.c kernel code check by itself?
> > The reason I write the selftest instead of combining in memory-failure.c
> > is because
> > + do not need extra checking code in kernel code
> > + make it easier to trace the entire execution flow, starting from the
> >    madvise() down through shmem_error_remove_folio() and into the
> >    truncate_error_folio() logic.
> > 
> > Pleas let me know if I've missed something. Thanks!
> 
> That's not quite what I meant. I mean, since there is already a
> memory-failure.c in mm selftests (see [1]), I think we should move the shmem
> memory failure test cases into that file.

Got it. Thank you for pointing out.
Is anyone currently working on the shmem memory failure test? If not, I
will merge it into my next version.

I have a question regarding the current implementation:
```
ret = sigsetjmp(signal_jmp_buf, 1);
if (!self->triggered) {
	self->triggered = true;
	ASSERT_EQ(variant->inject(self, addr), 0);
	FORCE_READ(*addr);
}
```
Here is difficult to distinguish whether the SIGBUS is triggered by the
injection or the read operation. I am considering splitting these into
two separate SIGBUS jump blocks. Is it reasonable for me to split them?


> [1] https://lore.kernel.org/all/20260206031639.2707102-1-linmiaohe@huawei.com/T/#m18e62ccb3e87316ec37dcde9389c1ba1c56d0951

