Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336CECD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0426B00C1; Fri, 22 May 2026 12:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7A06B00C5; Fri, 22 May 2026 12:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDEC6B00C6; Fri, 22 May 2026 12:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4586B00C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:07:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CD141C1FB8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:07:55 +0000 (UTC)
X-FDA: 84795536910.14.14A5245
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1709C001A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:07:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PNl7Q6/b";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7CZniyudQvtGykBjwFqflJux61iIz/Fi25N4Y0qOJI=;
	b=WAOE/kNvzyC69zbx9jTmzkGPSzSKmJTGdEunCL/OtirMmdwqnLfy9xj8Ob9N0NAK0a+3A7
	MqtaNsVXgjswhwtvLujB0EkK0ObQnD7G1oTvnGjUWYuuVQK6ZQeL3s92XYgc2jX+q0kBKi
	oa4s2uNs7bb5mk53BQLaYjOYkxZkSpk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PNl7Q6/b";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466072; a=rsa-sha256;
	cv=none;
	b=x8dfUiHhODFaaT4kgle7v89TKbjJIz6BIdR2FQRn84RVzCFnWqn0j+3OjoRuBvqRVak70T
	U82bnSLqCeWXc2v2fCmHYRfZcvrkkPn5uyt48O7nS8G5X5rXVPYodNXj/Q4RzlWZxfCCak
	lGrLqzev0Ujjv+snH/3J2LB9ofQzfIM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779466072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7CZniyudQvtGykBjwFqflJux61iIz/Fi25N4Y0qOJI=;
	b=PNl7Q6/bpFzjlNljoTdLqlnYTmyofZ5nREKlsDKT9jic1gkPoAQ6vx5aRIeulfzIScIUNX
	A5WXOwfWT243UwsTXJgx24rip3fBryDqCQ8lQHgx9HdStqTwupnJj3OwVOyghiMWcZ0Z4C
	RxNfkDjbJswHqBOSSc91RYNo47Epgto=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-wJ47zdpNOXiHHVdv-J1glg-1; Fri, 22 May 2026 12:07:50 -0400
X-MC-Unique: wJ47zdpNOXiHHVdv-J1glg-1
X-Mimecast-MFC-AGG-ID: wJ47zdpNOXiHHVdv-J1glg_1779466070
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-65e1b9f1ebeso14670356d50.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 09:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779466070; x=1780070870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z7CZniyudQvtGykBjwFqflJux61iIz/Fi25N4Y0qOJI=;
        b=KVbRvVuhuMdeG/gHi5Ji8sy/YWd2HGtorkwlKLVRfT25CdR2H4n+eV6Rpi/mt98a9c
         gusHR5tWnahyYFUPPRy4uxpPB4cYB7M10HEXLQ51yUScvZ5vtkkMvr4EZW23j4Tt3QCI
         XXojYj4EyguDg7sCALLGtUWL/fPfjcvd3ms4VmVrilgMm2ix83JElKS0hMd4jWUpqQbA
         1aQtNDGPnW8jtHAU++lvxlzWEtjFd3ZuGy3MlC9nlgBLVIpugZPJtf0WpyHlTPvH1phl
         vhac6ISsctxbRTP1Zrf0Vjmgc2Jp+heyO64fj1HVWMMgZAgk6ufZgAgvL7dMtrW9cr9o
         Ss3A==
X-Forwarded-Encrypted: i=1; AFNElJ8wwn20pYpr1clqjOHX3AlJgpt4Wr/ZWWVqneDgeYz38+oN9eQjaLMk5OosW8rVFbRkM6WZ/+ZGXQ==@kvack.org
X-Gm-Message-State: AOJu0Yyb9AXxCaQ+vtrFi8eHCFY+FNr6YISUdQQkA8zc7xPN6rwncHvJ
	QD2TYkIwVJSIkXvnwymt4YEGV2y1OH/fzjfGSENavZeztsmb4/j4WEy6p6kdclDjKgW39gB+ePy
	/0y9uVY2JKIibu5UUDwxe44MTKxwAxdKi6xsuSTF7eYuefL9wnyaKW5j/ygC/gDsa5/1Lk+6AOd
	eedmFHbG7WxI6gFQqCVq0mflT2/yU=
X-Gm-Gg: Acq92OHieG0e6mku/pj4D+HS5EsnvOXRa9Ohb9cWhr/NdNOcVTdimK3pv4jAgWLr00j
	P2orlY9y9nyUrfQFwIc+WbQaTPUP6qkipSTx35+jbhkeUHDOBfJl9J522J4IUFLD+UTyMOSOwyp
	2PQwMM1FsGXU1VgBT5wE5jD03vWqSkCJIlg2Uus3ybEoesVKR7tHCsaTeaGK+ib4dn5yIae9B8I
	kjtFw==
X-Received: by 2002:a05:690e:1284:b0:65c:74c2:31c6 with SMTP id 956f58d0204a3-65eca654410mr2973376d50.5.1779466070083;
        Fri, 22 May 2026 09:07:50 -0700 (PDT)
X-Received: by 2002:a05:690e:1284:b0:65c:74c2:31c6 with SMTP id
 956f58d0204a3-65eca654410mr2973309d50.5.1779466069568; Fri, 22 May 2026
 09:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <ahByO_HWn6MB8z-u@lucifer>
In-Reply-To: <ahByO_HWn6MB8z-u@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Fri, 22 May 2026 10:08:19 -0600
X-Gm-Features: AVHnY4K-NMEYaoOF8CwzqrbGVrRxOSsC61YCW8vw8BzLOXMR_M4k6Y4gQwbZHRs
Message-ID: <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u9EITFvUVoZNz8MgPZFtrmAz2LILM9oPPP4rqW4vHgg_1779466070
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1709C001A
X-Stat-Signature: z5uege7kbk89iqz1wwuj4ts6hjpqq79u
X-HE-Tag: 1779466072-614521
X-HE-Meta: U2FsdGVkX19E3zgFDwVDRcq7rE36hYz4yaG2I0WkH/MM///3gMyeNZg0tihN5r12l7641MM7kDPeszCbdO2S+kNwsnMWs3+8/J2Fo9Bize09b4jyLjBvM2cVY+ZEfM3mLtOGl3m54meW2WhuP4kgz6srhVjIV29o14c9hLUoOjQUXNmZFWuVL4Z+rGP1fB/JNX/KMrpdPwHzKg3d++GV0Pk3HcB4EbfG62v0PfCIljj7Si+1oDg12KcdWxFH/U+ozzMVMVC/NkkvURH0bFgV8/6rWnZH1iIAItOKN0nKlDeI+33vfm0kr8xfZ/7HBxT9/h8V6t20lQKWAc2r2cWCeT+D0K5dd+LWEFXaeBJsmmWcYu44yKjPA12OokoSPHftkAenAaSUtTyw9yN6qz9sttfMgLACrdkaAKshTHgigEhzvdUG5tFdKj+8gQ2sdonpcC8aEwVWtB7Ur6DZPxFjQJT8hx2Vt2mxZ5O2d937r4GhNH3+55sm6lLz04NVBYYEPxp5YzpAbsU/bAyVTVEyaOrSUGGGhvTQ4iW4hjycxP6yG9mMJCieo1TvGuqq0fh4gUrcIHNLGx1BNqs0i9xQ8yJDalQoYHxbCBMWcp5WAop7Sxb1fS4jSEgucMzz1fyzloQUA11x+il1hO9o8MSrLtK4TUvSPAW2Pv1BYGK0WEIYOGcvxBzRM1jYOzBkiDpl07rsvRjrvZ6pj5e4QwasNH3Cx9LYMihtt21Omh7pogU0RDtMssDIa10GgbjOD8T/OjS7oaYLNHcwjMrb2Yyi6tm2FjJYnNt2n1lGwjM0rMgQ+nbHJ7gCGkoaszc3fwkOF5/ytC2mgV1EOeFMQHPoUvmjuldJZTtsebTNQCudukvoB6dtq6QD0zdMqzlaAUWE9DNsSe9bWaI1gGpIidaobgTWfHpCGE0CXFVxGIEVMueyCQvDeQEKHREVZWcJHTQP22pNoD+rTUjJAxP3X+n
 F38LwafO
 TWGUSw+XwNoUjAeZ2In6NHzX679zYZAEn03f0a4PrIYwAn+rFBozZJxa6Ibf2tMn4PAOJ+GD8QdJXm4xHF8uJlq865T768TDQ3yUbxVnSeXRoZMpaO1BYsBdnx4lKHL3AF11CjwQci8tJ49mj8KBx00qPG+3vtNYShJaHJ0KWkPZ0dDlS22UVlImadKOzIBwfLYte3aBSwNK7WYbY2aGAjBlN/DVXmUU6ucwltRV53nS0qnB3PGEgqNKFV/Vz8HZ974omZJbvh6kdc44m1/HltoenrGVxA8CX5FB82xAgTEWr/CCEz/QVXw49AyQylbYPIs/qmvkMQStjqbacfGSG/A/EM0G8yYqohWxGpFJAQ9QAWTMeFvD8imMNmv4crC8rDYh19IjhKdNyndU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 9:17=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Fri, May 22, 2026 at 09:07:29AM -0600, Nico Pache wrote:
> > Whoops I manually changed the coverletter subject to reflect that this
> > in on mm-hotfixes-unstable but never updated the others...
> >
> > Hopefully that is ok. Just a small mistake. Base commit is referenced h=
ere.
>
> It's not ok, this isn't suitable for a hotfix in any way shape or form?
>
> As you know, because we told you :) May has been difficult because of
> conferences, holidays (and in my case burnout recovery).
>
> And unfortunately the series seems to have needed quite a bit of review a=
gain
> (my suggestion to you would be to ensure you don't make major changes, on=
ly
> small incremental ones on the basis of review feedback).
>
> So this isn't viable for 7.2, and we'll have to target 7.3. Therefore the=
re
> was no rush.
>
> Also please don't spring a respin on this series on us without discussion
> first, with people away and (frankly) the amount of work involved here,
> you're going to have to accept the pace that workload/availability permit=
s.
>
> Adding spurious hotfixes tags doesn't help anything :) please don't do th=
at
> again.

Hi,

Sorry for the confusion but Andrew and I spoke about this before I
sent it, and he confirmed that I should send it against this tree to
prevent merge conflicts.

Because Zi's series depends on this, and this is already in the mm
tree, choosing a candidate before my commits was best to prevent merge
conflicts.

The intent wasn't that this is a hotfix, just that this was the
closest base before the v17 that is already in the tree.

Sorry for the confusion, hopefully Andrew can still apply it to the
correct tree.

-- Nico

>
> Thanks, Lorenzo
>


