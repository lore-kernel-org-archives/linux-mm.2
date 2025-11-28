Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90954D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60246B0005; Fri, 28 Nov 2025 03:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C382A6B0024; Fri, 28 Nov 2025 03:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DC86B002B; Fri, 28 Nov 2025 03:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A36B96B0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:18:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D88413190E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:18:51 +0000 (UTC)
X-FDA: 84159314862.26.B25CBFE
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68CEB180002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:18:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ek7JqIgK;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764317929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=El+DHDdiu4HEs/8uueXLQseM6o0zWxW5fRbqDOUC3Q4=;
	b=6Y1kmra33cT1ju3rYlcSNzyrFPLoLfavQ90GnvyPu0Htgv57z1qaO5sscAKITMDkdw0sCn
	V8jt+vTM3HKDEbU2BsqzHJwlGNjMaiA5pziaYOEu2xLNUM2BYJT0OejSorQY71De1rCDJq
	t3goh07c5RbFeh5Yams4CQktLcLtJps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764317929; a=rsa-sha256;
	cv=none;
	b=sNrps7fsfp15ZvM29dsRidJK3EOWAZoUKGpFpHbuRQUgxFDVF0Yo9rMxLd9oJDWS+Q91fb
	IYz+li3J9uyf2z7zBAVZswmJg7u/BOgGZtjO15bsCfsM8c14xr52dctptPTcHtNLFBeDNO
	QiJEGzUZ0DrDcAjLPJgu2hQWz2R1e4M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ek7JqIgK;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640f88b8613so1124530d50.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 00:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764317928; x=1764922728; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=El+DHDdiu4HEs/8uueXLQseM6o0zWxW5fRbqDOUC3Q4=;
        b=Ek7JqIgKI4CCjQdW2lCbiKTSas5S9oArpze4vDR+IeYVcEuDNaHs9xqHEl1SgnmcQF
         QvaG8KxZiy5PPhcvInAa5tzh/pijpVrqeJ+kli/iEWwR2aPWIk4qqsL2SMQq5HbYBu1Q
         wyRLn31ctg/h5cu+KB97W5o0QxH6UZ8AG9/MvJSbf098wi2zumDOi1nEDkkDFex00uY+
         2fEiKOPMmhc6pVAVGiQ0SchN717m+K3/4KNF0mjfvuulKFSi8Nc0WOa/dciHQ2E0KOON
         7OJ262a+Bj1Y7UXtgMWlLI+aiYojEuna5QugXmYEt+PXY4tdDmYJusPVgwUrnI3hTcbJ
         4KFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764317928; x=1764922728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=El+DHDdiu4HEs/8uueXLQseM6o0zWxW5fRbqDOUC3Q4=;
        b=wa1RIIp+bbL8WO+uBKgvRt/xjfVmsWlQCKC51er7JLfUThkSyf7wIOt6ZmktPljW5r
         60ecyTRNqG2ZyXXosrmXZ1roxBuG420BP+fUKznMKb277loZbGmySO0PIJHDirB/xG4E
         jg5H2iiU1bT9NHEvr01NQLsneMKhlKaZk2LOTEAuoqjEz74cpCKVF8z+jy1tR+R6L9xT
         J3Bi0byMgtPtZJK0lGLLexOlF7C831Zg9z6k5eh/grMlXGnkCOK3bBp7l4cQqhhyPnad
         8rSq141NZDb5O/0uDkLjaqdWFB8UdGBQE4h78912qxRgk1NfQDCVawajX5wp7qYGT3i/
         Zwfw==
X-Forwarded-Encrypted: i=1; AJvYcCVhfO+ukWRisoGveusccg/a3L/JXI2kxkT7MCgQVPAR9kuSB45myDEFBL19XrgbJcb4StU4V87z0w==@kvack.org
X-Gm-Message-State: AOJu0YybFdVFjBE9IR6xLaSpjGM6+Dsti8fA5q57OC49Gn7ip2ciYUPj
	eUXeVnCCsGwrw2T4NrKOjRXmjxDVp+QB4RC8XqMJ90YmzofqRzICCp6o92YETOp4TwIYEJmWpYK
	iBdBTFnHEyxXUvYEwZW+qy5egTZ2peRQ=
X-Gm-Gg: ASbGncsUa6o/0XD85DHpL72xpg8pgJjQTFCBqC6MLmxzVdPeckvHshL/oOmYJP91gL5
	78eB2Hk6ZyWUgRbVvHwtWMv+24AntCt/1eVHVbZPd8N8mWo+GEAgdtLjEDsNfwFsj19Cbdcp0N1
	1Cvs1qUqLAxzog92WAjadEjnSKCJ8nG4LpuaMVR0252tEQV9GRuCg0JNlwHYjheNtlKLESqaSCv
	TUMBkCyj7qyWZr2G/sAG0wXZappeHE6bKmELfh1p1QqFujvWFPubyPBBrE+2uN4VSH8OHcD
X-Google-Smtp-Source: AGHT+IH7ZIRX3n+soL0DbxqkevgQ8TnMBFNiXExpRFGs92A8/MBZOgZWt5uwDwEOF1ptbv4DflBTQ0ByEzHecDfr17o=
X-Received: by 2002:a05:690c:368d:b0:788:20a1:4895 with SMTP id
 00721157ae682-78a8b49758fmr220819517b3.22.1764317928293; Fri, 28 Nov 2025
 00:18:48 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org> <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
 <48878c07-6e8c-47eb-bc8e-13366c06762a@lucifer.local>
In-Reply-To: <48878c07-6e8c-47eb-bc8e-13366c06762a@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Nov 2025 16:18:10 +0800
X-Gm-Features: AWmQ_bl511PROfTv9XwN26WJ99s_VVN0B0oHDwCXD5Z70W8ZkfNX396eT4h2J60
Message-ID: <CALOAHbBKxHDuGoND5xwxsScKY6aW8eiqE5QuHppd25RpYHf_pQ@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68CEB180002
X-Stat-Signature: uzftbfcdfx48cwb5qeb675igihppcrwu
X-Rspam-User: 
X-HE-Tag: 1764317929-128612
X-HE-Meta: U2FsdGVkX1/2jyRr3csrRakxuegCpAwxiaJEcDMJHjKZ6smqmHnf5aQzkTTpJda4DCE8sOT4ny8MyYTMnP1SaEJ0EMUotNXuEdw+2BCJI5RYR9J+Kfh1wjN4l6EE7eEqauW+JjDmB8Kj8cvMQUXAEAKwERMUjtT12jN+j+sjoHk4D2vFGbtnQPZJJv35txol5rTPWyAoIMv/AD1w4ADALAJPxTYCaj1GnsBaeuic/c15D44fAmGHZMzWd/Hndrjuv1hxQKeRcP6Q0UkYZKwcVJchg+6+p6GigoDORPNFJBTa8wJfLkAEvG/xT0/WEDqQvtTJdC/BTVjGjjjfmy72BoqIMrHgwHfAPKi7RA1urYUyxvh8y25DVYu1ITYfXShaKCVK1ecN6AAgQOlyVLGd3s4FtKJ52RXrqexxO0JuRIXtopRrt3ViaYFj9keNKBjT9zRnVowXpo4N9pH1NryhBPheSV7zJxbz9pI+T1tApaTexP8ulPYX5Z7m+BqEnkMKMeSG3MiQkF6Z+oNQrb2R+E+m+u5kFEjw26lSugsAtlQYbDrt0a1AJkpd9bXFECPodtYGIhLLGWkO+EyhzLP+xmAhXw48jaKlFmtfVs0KAMTAjNNRVJODF0YQKKh+pAI1mLwAweRArvJMJnVyzDZtxmMCYSIQIkkruFjRlzREGiZwySNysrOGjbapFAtF8AYoTUMkkZFAvBCMOMC7ySwfB/ZrNOjGnSSO9W7N8FgQlTw4JZswAA5VuwH+ank11X6rDTmu+qL3yGZYCihIF0uvCaMrQJ8bIHxez0oTx8nUQnYZ8a2k8r2D3Yr9HmrBqXJm4RNKsV2vZeAR1XE2reQLUAWdbUYoiwOOzAHUyRjkA5whyL2vB7+MAq68LYw/yPcgQSjNvLI7I1Qk/FoFYVMQcdBY40rWMtZomTFZlfDTpM53TJgqn//i4WYDWIYp0ThHdp3JngfZ6TG4hapypvn
 PaceVh1f
 Qq2Vy1VyA8vlN+SMmSG/m4FwWKjlNu83BAunOp6twxJSn5w3NG30CJfcJY1ngvXNfbKCrIASsRuU4ArH7+DVm2WcdVbp/QnC/S889vIgANle+3dCAXgwXIogEJndyg1rtcDtLw9Jp+wGcrWiEwO6znHKXa+30EZect1oipbif5+Nw9UqyL/6OH6jDCQhKfqqnwAg86+jPTsgh3qQFQhOftmaISc58bDq/gVNjwE6UXhTNIJuAVyaoAce4W5rV5yOcspOeH3auRVsU1tONfMDl+Hb5G+bG06DGR5Mu/Uh8o8kPZnWBcu40ikOsYIadcCDsaQSU5lcZ1sTzQmFP2crlC8rM++iRFR+oazVKm1B+jW2U5GNCAtTWKKCv7COXKH8R80Ox6Pg1KU42t/0xJyao2ug1OmAO2rS6DZpC7ymZbbabEupp+oRR5nOeREaK72rk5iTM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 3:57=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> TL;DR - NAK this series as-is.
>
> On Fri, Nov 28, 2025 at 10:53:53AM +0800, Yafang Shao wrote:
> > Thank you for sharing this.
> > However, BPF-THP is already deployed across our server fleet and both
> > our users and my boss are satisfied with it. As such, we are not
> > considering a switch. The current solution also offers us a valuable
> > opportunity to experiment with additional policies in production.
>
> Sorry Yafang, this isn't how upstream works.
>
> I've not been paying attention to this series as I have been waiting for
> you and Alexei to reach some kind of resolution before diving back in.
>
> But your response here is _very_ concerning to me.
>
> Of course you're welcome to deploy unmerged arbitrary patches to your
> kernel (as long as you abide by the GPL naturally).
>
> But we've made it _very_ clear that this is an - experimental - feature,
> that might go away at any time, while we iterate and determine how useful
> it might be to users in general.
>
> Now it seems that exactly the thing I feared has already happened - peopl=
e
> ignoring the fact we are hiding this behind an, in effect,
> CONFIG_EXPERIMENTAL_PLEASE_DO_NOT_RELY_ON_THIS flag.

Thank you for your concern. We have a dedicated kernel team that
maintains our runtime. Our standard practice for new kernel features
is to first validate them in our production environment. This ensures
that any feature we propose to upstream has been proven in a
real-world, large-scale use case.

>
> This means that I am no longer confident this approach is going to work,
> which inclines me to reject this proposal outright.
>
> The bar is now a lot higher in my view, and now we're going to need
> extensive and overwhelming evidence that whatever BPF hook we provide is
> both future proof as to how we intend THP to develop and of use to more
> than one user.
>
> Again as David mentioned, you seem to be able to achieve what you want to
> achieve via the extensions we added to PR_SET_THP_DISABLE.

We see no compelling reason to switch to PR_SET_THP_DISABLE. BPF-THP
has proven to be perfectly stable across our production fleet, and we
have the full capability to maintain it.

>
> That then reduces the number of users of this feature to 0 and again
> inclines me to reject this approach entirely.

I understand your concern. Our intention is simply to contribute a
feature that we have found valuable in production, in the hope that it
may benefit others as well. We of course respect the upstream process
and are fully prepared for the possibility that it may not be
accepted.

>
> So for now it's a NAK.
>
> >
> > In summary, I am fine with either the per-MM or per-MEMCG method.
> > Furthermore, I don't believe this is an either-or decision; both can
> > be implemented to work together.
>
> No, it is - the global approach is broken and we won't be having that.

Let me rephrase for clarity: I see the per-MM and per-MEMCG approaches
as compatible. They can be implemented together, potentially as a
hybrid approach.

--=20
Regards
Yafang

