Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FE9CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1D96B0088; Thu,  2 Apr 2026 01:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72CA6B0089; Thu,  2 Apr 2026 01:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988BD6B008A; Thu,  2 Apr 2026 01:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4776B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:59:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 144B158E44
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:59:29 +0000 (UTC)
X-FDA: 84612563658.10.9A32728
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40F444000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:59:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwJJ38sP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775109567; a=rsa-sha256;
	cv=pass;
	b=7pbDreFubIcGfWFXsrng0ViFSpFrx6yTeEQ3v/R71eAdmvYVacfcteU1TbKs+s1S2tE4h2
	ik8SiD2TN1JVuqaoy/F5ejkTuyUOA9j0eMpx0lKIdMq2hgo6iPJBSC9xjZcOjBsn4s2YYm
	/xAI4ut7rJrQl2s9xMYm7YMGGytv/OI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwJJ38sP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775109567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iP1P2Whq3Q6Zma3+abHBOxVrai0vamalzNcr+tyJcoo=;
	b=Z+kf+q0ji6XZhZBTA0Hc1q7P2TzxUsJmg507WwY4eNS3Rp1SuIxQbnCoELH6nrAz/vvDUH
	XIHFVNylku4iynVV4V83W9UAkhB7oNNmbkAGes1EA23jH8TnLQtm7PVMP2CpHIWcjewlXY
	QKC0MTfHJg+XZXK7sWUxXVdtZN64eCs=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-46726528f1cso341932b6e.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775109566; cv=none;
        d=google.com; s=arc-20240605;
        b=IeKqdtyqcECdLI9tYEViStyOwiu2DaRUn6zUQQHVmTiFiSH69nOOB8gwnyO9Yruv35
         7Cqd2IJmKt+4KdTqPkmZ23DyLyvjRn/QmOuaT/7Wul8TRKoqp0rgwGtT8jxy+f+SqbtG
         CuJhRPG+lNgFxoPwj/PlpJhbRlGqD7mQwGM9+Vwf73e5LFqILRScPMCsOH6SiZe89TPj
         u/rxOJrAtn0t/nJmUTQW/6uBcarQFd+CZM8WaJ6tmDK8k6koQL+TJFjjBOtXtat2doVF
         eIqjWAn9Cyq1oZYH6MWg1lzbMaFjLdlhNN9aQsYJvSfGsM0lViauRangyp7HLHGYw8J+
         TC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iP1P2Whq3Q6Zma3+abHBOxVrai0vamalzNcr+tyJcoo=;
        fh=Kk84Xhu6xzyaw0gWJVGahR7gYfIjLLee2fJqUmOiCZQ=;
        b=HddkwExAMmlKFVnlmaDIR9Yn+A5DxESBpe/NCr5vj3DI3KEkyls1kaRWJNjpzyM9Cg
         8or23DpH11NbK8VXmLDGcq5eQNz+8YjOosVkhYu7SdUU1QGUoAWSEn+Y0C2w3I/HM7Cl
         vshQB9oUtKemoANS4C5urorfsocUPTzH+5DTZH/frZzUVqg2ff2yF1KTlOqqTfVquuu4
         BfNJmYGf2sJNtqJDeSdhFJxAM/MWTeb1BWyC/9s4ygJnFT6okRysXvT76GlwKqRE53mg
         g+Ljiu8QZJU8azmCpltZ1l+PdzM2qaQjN5fbw3n5sYG2BTqIRQhmgVqgfLLi8Ay6RK7X
         ZEIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775109566; x=1775714366; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iP1P2Whq3Q6Zma3+abHBOxVrai0vamalzNcr+tyJcoo=;
        b=FwJJ38sPVcxHccFzEI2OG82UETvRYrpw53IBMz1nIxhou+X7IpBwYq0XO+666nwOyM
         xzBDOk/5VWZ4+iab1cuwJi9iGwvKkm4/EyL580aQz3CL6TF1nxmAjhO6Spj97duDKn6f
         PwU5KPFayEH6HdTqns1AzxrgO+GoYI4Qy6GZD8nu1BEXtXYrvfKnD9d83c9XKdqV8FG8
         UTAp8opqMyrbic3O1l04qhZErqZAU91zGjngfxAwS3AKC/Xm65e7L1/SomtEL8v2y23C
         svw59UiQYR85Z9ouPD++tkbjhTiTnrHVeT2kEONO47tch87NpqtAawZJ63Cdiz+vZTr8
         XHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775109566; x=1775714366;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iP1P2Whq3Q6Zma3+abHBOxVrai0vamalzNcr+tyJcoo=;
        b=UumRGZ8nVrVCOuXrphEcXlK7oMD1INrSfFq7mCaf1ejuFakn5Woptcux6HjMw0g7Tx
         G9RF1ag4Vx3bhM+UecKRhJ4QqNb35bn4p8mKOI3CG8x1fosgahGTpU/BUKaR0eD7ak9n
         U2C5KvU53TmUpirKJZNY4fZqhvgPYh8hMk3GIYoIH88RnRUDKV7SL0UK+CT85NbDrfSD
         XZRZ1y/Ss5GgTsnA1BgP89JZLgNj110TuV6gH42Zz7OCyGzbQtG7VZEl6xlrtu6K39Lf
         cALqaBpnKNlh96/QMehyTI4LC4XVo8a9CWy1dXfV/K7TKAvpqnkiE/2weyaxZL33RxIc
         7u7w==
X-Forwarded-Encrypted: i=1; AJvYcCXgJdQBr6mVdSBo5WuN05oSaqYxKb7lLjEzEu2UJCTxwg0zqu4zR3EctPFHE2ziIgUahsy3A2nBsQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+jf5BEx1ABaR8tBl6uxe+J7k+2IZ3XIovq3gCY6Z/BIpS0Qqr
	IZ4CUxKCjxkHdA0usE1Ok6O73RxDG2ZBdRY+Yia0wIGLQ8iFQZSC7aap45QHtYOxe5MhhgTE94T
	OVdDia5Hhslw/zOiSFVpwSC64133KBpw=
X-Gm-Gg: ATEYQzwA0WGJYZo9l8N0il5alw1DPgCoyl81EqgvdeSSrej9JOePBHX9RW8HOCdUZcr
	uCZtLyyjFDlY6pFo+uJGCwCqjM/cIdji2/p6pu9ZJWQmpAvyxopFoAHFP/fO03uXMxjgbR1fSsV
	6mcrMLa3+K/PymcLrlohcQQmIDgmOQxY7Wslky3LG4gjaBY0LkueDOe2XQWEU/rQ7RTQxE3woU5
	aoH3VGvxVWrpvttxLg+cFmIPGdl2Kde4Xp+p+cyyxV7AtitCsCr3dkQxH2cJMZ+sGSMW9fGKkcC
	7z1BqKd0GQ5TeqSkzXpvqT5kgq+7ZN9tv32kvw==
X-Received: by 2002:a05:6808:1929:b0:45e:c00c:d063 with SMTP id
 5614622812f47-46ae01880acmr3595353b6e.37.1775109566103; Wed, 01 Apr 2026
 22:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260331134158.622084-1-devnexen@gmail.com> <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org> <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local> <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local> <ac3qYA40OW29ibbq@kernel.org>
In-Reply-To: <ac3qYA40OW29ibbq@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 2 Apr 2026 06:59:13 +0100
X-Gm-Features: AQROBzBgRWyqJogYNVMiyiFDybYk9gqvdSpOKXfZ0-indKq42_N1Bv98LXessEg
Message-ID: <CA+XhMqzGfofZarKS+rXvLz2EAT1jUvy05mTmffHmxz=TycEsxA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6n853d4z67q1ass3zigtj38rjpcsobk7
X-Rspamd-Queue-Id: 40F444000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775109567-234196
X-HE-Meta: U2FsdGVkX1+z80ESPCpU0+/+azee6gJktJbfWOVuK/Taa4llAphDMKDrhbHsgCFeq1FdXg08xbg9zxbhmS8B3X9R3LKhwFeDgJgRlN+TaUr4hRH7+m6OF2isiTGh27brr2gDsg6nhpFloCqZynTmeB0frx4etM+H4M9hvoBUDJl6P5+FLlBiSPKKJbHJ6i2rGKzMDg4UTu0PA5rcy+Suj0Wlrl5VFWQsksTiwlgBbQtBEXZuFtYv2CiWQ6E8tZzSkwKVWO4zV8slv8Y0++iR2r2Ajo/eWeWgGzG1yBXxc1d/rB5pNiXyQjdx++ZP+yssfU7eMiCqz2pkUlzkX7gXL6DgVoKNrV9847k7lmXTUcHg/OWcgWbUYuM5tyhasAtOIEH2A4pHi4C03E5yIG+sD24CtV9wEfe/3VyRfWh2PTmDVCC2JnzBVmcu3qtZcBCXnCoY6SCWtH8ygSruxekDAODSnLTnQlMhdAVjgdduRxg49IRb+bI5q2lK50tMcXasmG8Bpbpd/zcnCS3LXf4nFgY+uG40MlhGpBbTQtJWi1FSACYGH2YwT0VCNZ/VqDJnlCT+MNMGzyaSZXS2JDJK+PKfmKvNlgE2uHcZjEv3OPoZ6Rt4uIyHr8TMu4aQFTBP3lR5rFpRzkh9YsPskKtnjsK3T9a2c4C86NXIsfIEk7efuuH577/P7xLNTU8ndQFTjWkj62BRUsfBCyXnP4yNmPKTkSgy3VZu5IqdgT993SY8LAGcJlNT14m6rxctbC9tOTjqcpLJnXuWmsOKYU7UTPv9scAAbBjcIunbp9LWdj9R56YMM2OiKH35U4PgZ62tMrITiGVKzHrbakdMeYPIupwXS4twhRQI3GQuTyPQCZMI0gueN9PyavVaVLIxmgRDZn4QABs3zCDhvHAoUAyNlm3ca2wnTt/hjhA9QW1YtNsRACkq8n/UgEWtcXX5rtvOr8LibT9++NM+yZg1jeA
 jy/CVJ06
 peGQHIap4LYTdAD7xkg/K0otGxy9D9xLR/bhYoXpVjDxaiTSPdSbwC9sauazXmhHNnlr88H1PZ7C4ATwjZrymLcwA4yLQu7o7kd0gbPSWEjMe1p4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 Understood on all points. Will rework patch 1 to a simple ops
comparison with -ENOENT, drop vma_snapshot entirely. Will cc MEMORY
MAPPING folks.

  Holding off until after -rc1, will resend both then.

Cheers.

On Thu, 2 Apr 2026 at 05:02, Mike Rapoport <rppt@kernel.org> wrote:
>
> On Wed, Apr 01, 2026 at 03:22:03PM -0400, Peter Xu wrote:
> >
> > The other thing is I just noticed the err code was changed to -EINVAL for
> > snapshot changed cases, sorry I didn't follow previously as closely on the
> > discussion.  I think it should be -EAGAIN.  It's because the userapp can't
> > resolve -EINVAL failures and app will crash.  In a VMA change use case, we
> > should return -EAGAIN to imply the app to retry, rather than crashing.
>
> No. The return value should express that the VMA is invalid. -EINVAL could
> work, but looking now at the manual -ENOENT would be even better:
>
>        ENOENT (since Linux 4.11)
>               The faulting process has changed its virtual memory layout
>               simultaneously with an outstanding UFFDIO_COPY operation.
>
> > Thanks,
> > --
> > Peter Xu
>
> --
> Sincerely yours,
> Mike.

