Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D660EE2084
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424056B0089; Fri,  6 Feb 2026 06:13:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB666B0092; Fri,  6 Feb 2026 06:13:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA3F6B0093; Fri,  6 Feb 2026 06:13:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1780C6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:13:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF3851B2AA2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:13:01 +0000 (UTC)
X-FDA: 84413769762.24.E542E63
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id D34FE180010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:12:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f1xumkw5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770376379; a=rsa-sha256;
	cv=none;
	b=NC6MvNYR4MqUdzaCUflpoaOEh4igCGw3BIq3Srd/pIz9zIfS9RbS0eqW2ls7d1kx2U+WH0
	ZQQ0o5Y3vAKBeb4ueDU0pO/juCCb4vCqERmMbtjD9P4WZfTaBaLP0px1HbcEFBcsWZ9uVY
	1ZhqH9EAaVmzG6RGOKBhSdKrJn/fcF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f1xumkw5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770376379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgrfaHug42gFco7+TwJa2fy+qNwllbhCnVeHrD2K5W0=;
	b=mUmrZOjwhV50fj4RrkR5jx0sMmS2lTtBFW4iiIA528084GZQSYR1wixMQFm6EjsIziZge2
	HIC4NKF8hkMI0/3cuLf5hlgOkBPWE3pBvNFibyGCr4+65oxgAUJys/WXlqNDvryK8L/f9r
	my4lpHehRDUfLZDpijUrWcDSPNvJdfM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8231061d234so2127940b3a.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 03:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770376379; x=1770981179; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AgrfaHug42gFco7+TwJa2fy+qNwllbhCnVeHrD2K5W0=;
        b=f1xumkw5z7tuy84nVtaHyFqKXuDUaxwxWVCPpJoYEqVaE6xy43lHhngAxjo8FhC9K0
         KI/Q9vUc4Rum734FXr14+hXYiCKP75g91cJ4GJYH/6wgGP+lnYyw9XtWqYEYTrhBS5i+
         JVIAX2YB+EE0LhgFAc3DpKfLMqu69L8rSzDV4qaYhop6ezbPTPiu01+XMM62Lroi7Tku
         ubh4hZQZfH5H4hvNDXuREpCxV0dTFklPPMP/EujqUxfnz9YXnUX0IisaCPy/EU3++bDo
         bfWYxCDoMbKcmMbkYWCOMO/yvmyuMYhPStHlKFlp91WvNeuvY+FPWlBhjsagfvcTOneA
         f0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770376379; x=1770981179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgrfaHug42gFco7+TwJa2fy+qNwllbhCnVeHrD2K5W0=;
        b=H6jPgWZoDkjDGOWpSuH1fM68bvq8tUF+i3yiOFLB/PPeQEjHyl4/tTZ8RJ9mB9VkIc
         BJTnCwguk6HvznoKxe0ZiQv+Q6cb8WAqX9qpJJGmJNivM1xGc7yLsfsDVM4RPPIyMtpz
         itsHxNtW/GVK12cFpXTgrWoJs4yMIiITwa7/ddM4CQFqigTTUHnSexCaBkTOGhzswPFM
         t0TVlfVZgOTo7B55oamXs8hbtyHAkmPvbHXblsZ1QOAdHrH9lmG/BRf394KRjR4/jDE1
         tzvl+Ekr5U0aRj8Pr8MqfYm2UmbiCLC8VVigG1mvxwUjZhThJeogFk/Mcs0lmC/qrAmP
         hZ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8HjiXC086g//VnrhTihjI0Sj68ykDwwQ6Ybu/B0xO1Lb4cdIOqJOaxh2EIQs3J7btn1O099m7dA==@kvack.org
X-Gm-Message-State: AOJu0YwJC1xG2wPB0TSXtZqTHZWsSmbBbZmmVcTQzCeZhFUUE8Oq53Qd
	qeGUIsW+YLutfSwYBbE8uZFNBlH1CPjbdlAOCiD4I4EtqXpvOLnSJudj
X-Gm-Gg: AZuq6aKv9ONchrSDCMvH22Bqy/CEGsI+HIT7ZIoO0DwVzojQob9tgFEoy5Z9t+dRGUz
	PgmlW/qBvSNq0dCqiyP0OBZsIAsfVolZUjl2840ZIi1LZzFkXBYovF01pxw2+9L/bhicqqUUNan
	u52XatHclOLnbAY/ni6ar7xf91fJ5znMXZTQkaDeooInXsauN+63NqxL0S4kGeLkdj8d7kh5yjy
	QAsEzQeMPI3nbS8shtp6xeir46U4T5y2I1lfA+fL9eGZUn8oeBtZcr4WZtpmtvW/clv8MhyUXSc
	Sd4tWwp45KXFVlGgYlANeJGvxOuc0xGpeMZE+nZakmneevSQ19WXBVTNo22pZTeH5creowUV/vd
	2tSQyrNXYkscnlqvTxOJ1ijF+80V03HZxug/SNIk1dzCoRQuGp9ZNBVikFNejexkU+9vo512YLp
	BB07dMZn3ZaCDQhm9QIR43r/A=
X-Received: by 2002:a05:6a00:10cf:b0:81f:4f47:c6d6 with SMTP id d2e1a72fcca58-82441789d4dmr1898910b3a.65.1770376378495;
        Fri, 06 Feb 2026 03:12:58 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418a70fesm1929494b3a.45.2026.02.06.03.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 03:12:58 -0800 (PST)
Date: Fri, 6 Feb 2026 19:12:46 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
Message-ID: <6zltgzs24wpypzu36ldwgtzilhv2z3ofuu45azp5u45huiwqvj@6jhhp5r24po6>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D34FE180010
X-Stat-Signature: km9bzyzqsyyeun5wg7zmf5saud3ngq8m
X-HE-Tag: 1770376379-14558
X-HE-Meta: U2FsdGVkX196b6QAChsvBRHXRoaluqq5mpSoLlkUXZHSpDknxrDOCmwqQy4/DqtctyDVn/aPK3uYVpRVM5B/Hf6bxFJZDH37W25APsmYFKHy1DvLa4p/8yMLLgiavAVrdpDRLnl/bLMLYMbtd42Suc3ICHekEYpmVrHs537YIYAgkHFqdfZFcfN9abzWS1jUhCVwRuyP4cXXzxuTejUQPUfAv/R6vQPU8Q86DgG5+MUSgzlTLeaF66xhbTPvMjtu6lMQR/cpa2U8+pGiQOSd70yieJ0Bv5OeJ0DWx4F6Zd/K6ZUVNGg0HV67mQgPSgWOptGZmCACPfCzJ+D7AJl76Zjuv/bxfb+aLs5ap0cYjCK8yt1qL7c0OGGpTaDMz2sK5jh8r/RTc4I6X/3UQ/YDW/8POS4uEk2CNtBNlpoRQAOyJVE8EN8yjMFMKYJaCo/Rry4KkSluRij5Sp0p22RuyG5fzRSHdXMUXSTSAL58rvMWwirLzTmjEfz/No+WEMuGE5f7pyAjj8EBRL8q57uAUXarN3WKPhC2hCYtRUPuTx9wUvzpOML3XARMEAb9koI6HoeGY7HoJ+S3pldVxyIlAPVW8jS4AJ48ph8mYlY52kc6abPZ/2HrTi5hIYdNgj6Jx9A+twpPS8gzaGWWNCPePHOH9Dcjp1XqiydDXFcNNxPujfbcZyAX2Wbcazc5pj136Ih7GwExOv8H340xkY7vGQLKqFXXfxhclIQnUwyPzg4rpdkhRVfeRkVbHp7nhPlp0q4nh1B86NAqNOCidQh8lYYf0xOmCDZheiUBf0ictqbzrzdIAKKEdO8BLlq4pY3vboJPpfD+UrbkVm9qAMjEgZk7ksICx+GRkQtvUYfsx4iVqB7eTeflQ9Z3Stzmyh2TKqupNjmGJD11P18Awiwuc7KxZZ8l7IqjLGoZl1kUire1o+x/cE6VSChIvVS80oP7A4ZPqiP+/v7x1EHKA1U
 0Ps9AxDg
 oJyXcoCCBdQ9S6oP+QjdP6nJzYGYo0w2+SA1Zajz7L8j74JEmVZ6nXkQqmvLZpwYJL13NCpTQRu8qN6s+h0HlH7WeMQI/ldn/GrehOFiBOEzlRuGQvPed8y4UiPY5bPRJ+QKyYRVfrUn+lNQidxqksGe8WkRqZVTtFSk9yCXa8zg4R5Bi6huha04m65kJxUOzG6WFczAO0s4LjyHE+V3WXGAPvMYHnI45W9mhS5TYONBFzb+tdVSYfjiTxLfQUzm5udkaKxY06j4ElbQlW+/q5XoBk2grm3NfuSia6fTKd8bdmWWQ28ot2L4+tgc+gj+2znl9Fz8yZHjeGllMt4bKzkixw1wEUL94auUauYY/yICb2/nkpMpBfdakhL7D/LenFoSfIVJEN0Fwo0+Is197xrUM3beGjV7zNY3+XmkTMhoH0/69SxSEnLCRD8imo9hVUbbzpyIbGpudQB5IqeJ1a6ZSoDp8DsCzKzqG4GfYyvzMTCjosJubpDl641jHiezU/ytKG9hJy3eaw+zh1RHDKS4o1WyK4zBsY2qs1QVHXE9Pym/RmeeuHv3X9QxQUlSWNThRIYSn422c5qc3MbJv2Q0Uwh/DAaksU2L8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 10:02:48AM +0100, David Hildenbrand (Arm) wrote:
> On 2/5/26 15:25, Dev Jain wrote:
> >
> > On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
> > > On 2/5/26 07:08, Vernon Yang wrote:
> > > > On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
> > > > <david@kernel.org> wrote:
> > > >
> > > > I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
> > >
> > > Yes!
> > >
> > > >
> > > >
> > > > I'm also worried that the compiler can't optimize this since the body of
> > > > the loop is complex, as with Dev's opinion [1].
> > >
> > > Why do we even have to optimize this? :)
> > >
> > > Premature ... ? :)
> >
> >
> > I mean .... we don't, but the alternate is a one liner using max().
>
> I'm fine with the max(), but it still seems like adding complexity to
> optimize something that is nowhere prove to really be a problem.

Hi David, Dev,

I use "*cur_progress += 1" at the beginning of the loop, the compiler
optimize that. Assembly as follows:

60c1:	4d 29 ca        sub    %r9,%r10		// r10 is _pte, r9 is pte, r10 = _pte - pte
60c4:	b8 00 02 00 00  mov    $0x200,%eax	// eax = HPAGE_PMD_NR
60c9:	44 89 5c 24 10  mov    %r11d,0x10(%rsp)	//
60ce:	49 c1 fa 03     sar    $0x3,%r10	//
60d2:	49 83 c2 01     add    $0x1,%r10	// r10 += 1
60d6:	49 39 c2        cmp    %rax,%r10	// r10 = min(r10, eax)
60d9:	4c 0f 4f d0     cmovg  %rax,%r10	//
60dd:	44 89 55 00     mov    %r10d,0x0(%rbp)	// *cur_progress = r10

To make the code simpler, Let us use "*cur_progress += 1".

--
Thanks,
Vernon

