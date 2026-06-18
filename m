Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49062CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2715E6B009B; Thu, 18 Jun 2026 10:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249426B009D; Thu, 18 Jun 2026 10:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138676B009E; Thu, 18 Jun 2026 10:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB2306B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:51:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 493611A015B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:51:06 +0000 (UTC)
X-FDA: 84893320932.23.EFDFB35
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4AD8940002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:51:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bPuqDXAw;
	spf=pass (imf07.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xzK9hDXp89mOfbYP6diL+1HgZ3l+0kIzx7qhy14yzw=;
	b=aAUoPx8tDG0pt1Q34l2jn6G5C3elgwZ2Xvm4eYGGGIc940TkNe0UUbyVl4+DR2ZD/aWPwS
	dVXdJ5wvW8JkeqcXrJVuXqcEc9YMJMKLkQuIc6FkGk2F/STv+nh7Uqn9qf3VWRvPbh4sw+
	tLExiqdJWzxLhdfT5CBr7pRzks+XiZQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bPuqDXAw;
	spf=pass (imf07.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781794264;
	b=2+2fY+4VTpUhvRKW9/nLRDEnU2utFXYyQ8Ixdu1JaiUhPkhyOW0aYTLY8R+NIafRkvswE2
	XAReneVYCvVx0/dJ+fCVfMRq0L8vm58QjVmCfAzVyUrRNQKRnAvsrLlli0PFrLYf3QNliK
	ch2Z1xrvQ3G+IVlKo/tpnXsP69Jwxu8=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765531803so326131cf.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:51:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781794263; cv=none;
        d=google.com; s=arc-20260327;
        b=mw2LB/XjwhDJ3ZwHhkMq4qgB+B8n/M+6KDXAoC1KIPRhMkr4gMiJs5Q9Gpzn/5Gm+f
         theHMO8iBxa0BAtcQqJkc3EcJbJvj7xo0M6giIumcEcETHfK3RUGUNucV+WFR1O9BvWL
         CxVNMxla3jW36gMstUpbiIUdhHflPb0C6IhoT5j/81+jWymLcJC4cERUfh40XVsm4o1W
         XssHW1WVJfuyDafMDJ9Ed3ZZBHx+qnnZ1TQEsqUnYJv4uf0ceh6xgNLbWAuhLExGFzzS
         Nh+mdzVllDu9HjhFaPmGJ16lW4vAE/oMiFdISgr9jupKnVb2o3QBu25wqlc5/01cHm2n
         +5fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3xzK9hDXp89mOfbYP6diL+1HgZ3l+0kIzx7qhy14yzw=;
        fh=q4bOvSQD58BwOIWdW+YbVTLbKCl1ZLDBSP/tby5oUPI=;
        b=kOzwcz3OAgJEBtzCCVUynyo8Uk2M061PVp5BL1sJJo/vjPLnICDg6PnQERh1+D9W66
         X0chksfz2WRUdRsSh60FZlj0xuCeCES4Niuq6MDme/JMgj841tprlIYnX3s3l5RK8oeH
         lDDz2XpmKsqxjyFB+2bZpypE74m/POvfIcGvZFju2RMzD0784t7GR/20tZjBMbM7SMxj
         g6e0clJiNiCTVCm+LA9u9zh/GZ8vpvsZ8m3Avp6eqsFYeH0kJ+DidtlWSbhrBSjdgr0Y
         CA4c8D1hll4zG7x+yZt7+4FjMaSnLWZa7UdVf6mzdeE5HOWTmVDcFq3hsSyqJuYPqARa
         PSOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781794263; x=1782399063; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3xzK9hDXp89mOfbYP6diL+1HgZ3l+0kIzx7qhy14yzw=;
        b=bPuqDXAwsdsvsZjXHmu19qqLfrej7lY9JUeVp+rzIRFE82HZx79d+4zXoplv9EL+24
         000Lw3HPRB92YgBLRE3RiGNsKUOIPDOzvGRejLDx3uzW+w1yHeWDev4fOPTCpzF5dcQ7
         pgowvMZiSnNb8dafJNzPv5m6q5lKKfq2esM1D8jnw78Vda9nyoq6H3ML5eVBjgUKikWx
         3WUKRTMhELGuzJMwWTO4PaGXBgUuhpiWwYBmrvKqnUsD8zL6FLkMcGRIQ5Z69dy89lZ8
         Cs5hDWTGt5/aKLONUckWsUgnfijeskE1dNXbjjKbkUJyfDlVTyShF84XMjoMLheWXYP0
         HcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781794263; x=1782399063;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3xzK9hDXp89mOfbYP6diL+1HgZ3l+0kIzx7qhy14yzw=;
        b=por2tDeC7Lytm/f7aWWSYsnoMIsXNIeZXf7z0vkVR3s5a5h0RnYnoX/8eORRxm+xji
         bqrm6Rjr6qMe65lTYwnZGRPe1njayQ7CYs8CukBN3JNJN5p+F0jZp9Gta9b1xicpgir5
         Og28qgCT+54i3icELM+8eI+p6Qcu709+6Z2W+zRuBG7Q2TKekGBqL9RKt7go7tBBcacs
         7qDlzQmfb/GRwnp7nJl0qpW6yCp06c6c9HgzN5RpZGDX8CaHjZg/NpF+zEHGA0iQMJIs
         WAOu5p5TBU03251NrunGcUoW+GOf4/B8attnkKdfA3VV4+ajOLSQlVgS/V/wefvfD3AF
         B0gA==
X-Forwarded-Encrypted: i=1; AFNElJ/8PTtaMeyyGn7uuCly4Kh16G1UQEroMoP3X+o8Ob3Y6G8oSXbrrYIcpEu75PzwyMavjpLo3B4blQ==@kvack.org
X-Gm-Message-State: AOJu0YwFoPxLWaNzTZHme6+ln3DUU5CFdGK5p/PheFN8YJfYXCfqPWYw
	/KsxZnHLHDKzYLZDWL0kAqvp9fm5bwOH7d7NxhU23Ye3/Opo7LLTepoDBwgKwHwwsoXqMYUwZEZ
	3yEJfp5X4Q1Sg7plv38q6Ap8GS6vy6+QpuBvWj03t
X-Gm-Gg: AfdE7cnCKwWGqYKmgna+pu+Y1mxD57hwxdjYqy//xsWfCJf3iUdr5QhEWM5QZ+ePEzA
	UtmQ8ad28crFBpCr9kiqEimRdku+/KvMAUQ6wTlB+AxecXw1rXojSxT2Pd1/QsZln1SI4F9RyxM
	0Utvb+aUcitSzNyJihbzvlEGCI4ubtxHtg0q2WEYFyVhc2POfE/qVsrpJNsHIqmQcNM1IMJKc1S
	qruz1XXRGPI9aqFN173rCK81idWIsUSzWHuQhwl1gDQr7mWO7KdQdZ2LtPbRf8ItZA/06znwQ==
X-Received: by 2002:a05:622a:5a12:b0:516:4f62:85eb with SMTP id
 d75a77b69052e-519c661aee8mr10188061cf.22.1781794262609; Thu, 18 Jun 2026
 07:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
In-Reply-To: <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Thu, 18 Jun 2026 07:50:26 -0700
X-Gm-Features: AVVi8Cd8J7A4tM0GgYrWT5722EdWYRcaMva6zkF64Do4I85F9yPUGOZvN9NSrNQ
Message-ID: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AD8940002
X-Rspam-User: 
X-Stat-Signature: mwcu4iifx56n5pnibd91tp1dynenykdp
X-HE-Tag: 1781794264-64975
X-HE-Meta: U2FsdGVkX19nkH3NMfm5HH5/8ylxgDh/CUIG28SwAc2MY5WFDBCHBsiU4hAePjx1lS1RVoTdWLpB9yuyVT79xc/wnDEV1htyEdmWA35nh+yiOLJk3JugOXmPljYt5H+vOp/r9b87IhkehNFQEV7PKJgw0ab02rc8Z6y1fRycXJHc0X1EjJJUUxqipUpB+j77XWlJY7ditYMAYi6PUuRtHJUabgIGuC8146raa2hWduuzwIPTFvzbfavnkmdDNq4aVHcpNrwbWYltmDeQH1fa5ssSlpcRuK+IXocl+oykyM4FIpjE+2al+9YvH+ZYg15vzeJnv3N/sHzV/Vnxx74dTyPzH5Ynv13BCmzDC8VwxjyglDJyh8+pQSXkKOLbTrbfLJD/5Lus33RRE00V6H1BOd14BbWdpI9SuGcONPjS5mteH52Q+SKoGYHjCDQS6wDZJOXxNUudFu4WtNg9nc8ukssugqsL1xTqKYb87pRaTI1cbLa9jvE13CPvqBYxVbIDQBMUH/VV/lb0uAWyMEe3dZNxBVOa5fZaD7gpw+kccvdLqtIK/Fm98KWJ4fZHVnZLZd4WLoTstntX1Dn7vIKRC6yCfRm4v1TzmIJyo0IFFZH7FptFu1A+J+1MHUoKNtYRUO1Q0kulePuTDu5yUAAYSixBbsxlRI30MQ6jUz64ObOvxHXDcmkGp/UWYuCoNoIv7HDb1qWq7bXoNxqS8gyUhbI5ISCLausNZmUoxP+hY95hbfg0Dpoe+JC4HFw1pCW1uFCDpt5NjkVPhJQLm8C8ERnUAPXZLbdn6zDssD54dglVUoJJmEGBEvm7IVw6ePcPozWI7cLEzGx4EwqJ6/Y7KtdacHN0N87OONR3hcsK3x5d5bg9BX0khzfZtYMDXSlaWIBJ7q/FrtzZ3qcTDBhdVup3FgZpOMnnQRcm4Sg86HeSCrt6VxCQKrBnOWy2864Tk7RhdpO60AjwpQOih6r
 kyJqkNOp
 v/dEQ0ejgSivMH0H1sweI8IroDKt82yfPRZtXW+nqNqY2riZgglNjkBZZGGZFJYkVBwz5FcM9Yaw+O2r2VjVkHmDURucr+m8w//IWWq5axvPrfZF8ItffPGrZW5SsYs4lVyzRYDBG56kTG1ejqn29/f1SRa24V9XtyasllbRf2nzrCmSiNwcRC3O0fe9X8GOT3mLvz3IYX/C8GPgwloDpE2N0SS52TxknXu8/AivcSUhW8bTMWxuqEkqCliOB9wyPwYWr+RiKN57GsWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 9:22=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 4/25/26 02:19, H. Peter Anvin wrote:
> > It is worth noting that this was one of the VERY early design decisions=
 that
> > has shaped Linux from the beginning:
> >
> > - No swapping of kernel memory
> > - Kernel stacks are statically allocated
> ...
>
> One other bit to add here: In the past, kernel faults on kernel memory
> have been allowed, like to populate vmalloc() page table entries into
> the parts of the page tables that are not shared across processes. Even
> *that* turned out to be too much of a pain even though it didn't involve
> allocation, and the kernel has been moving away from that.
>

Dave,

Necroing this thread, as the potential aggregate savings continue to
stand out for us on the datacenter side (whereas David is motivated
separately, from the consumer device side).

I certainly empathize with your position, and hesitation to give up
such a nice simplification just to invite new headaches.

However, I'd still like to work with you to understand what feasible
path forward you see, hoping you can proactively steer us away from
some of the bigger headaches.

I think we are fine being forward-looking, and only supporting this
for FRED (which is on our doorstep). That said, understanding the
issues you foresee with the IST approach would still be valuable, as
it might save us internal trouble should we choose to carry it
temporarily to bridge the gap with FRED.

Overall, are there any particular painpoints you'd like to see flushed
out, first? How would you like to proceed? Would explicitly marking
this as an experimental config, in the interim, be more attractive?

Thanks, and I appreciate any help or guidance here.

Best,
Zach

