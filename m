Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FABCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697938E00B8; Tue, 14 Oct 2025 00:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647EC8E0007; Tue, 14 Oct 2025 00:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5850C8E00B8; Tue, 14 Oct 2025 00:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46BD78E0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:09:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4F585A900
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:09:33 +0000 (UTC)
X-FDA: 83995390626.12.5F6BCB2
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id E5FCE100006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:09:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWIc5B1a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760414971; a=rsa-sha256;
	cv=none;
	b=l8pRidheFbO78t7bVj8w/OyHxq7w4BP7SlN6Nn9ZQrQGqeqKSbdeger7Nv9MET8IjcWF6m
	Yn54AwAUFvFINxtYfkEckKYGDRYz2Plgyp6y8cUhlf76Lv2xQHiUWCzfH5jISmZr0kv2Kc
	UXM3MdHyG4noZXVXwmzp9O9eGmHmagY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWIc5B1a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760414971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2t/ysbOLBQifu3AncOUS++OTG/U64LIdWxNEMaNf1Yk=;
	b=C/qGY7sRMoXb6IQ0I53aHJB0aGYx99skcAKYp2eL5isAOxWb60tY0vDsp+K8MDuOPxOe+w
	a78umO7EeU83RYr4TL6o9teH4M4CJeZrMHfDaa+Y8WSnkdQAT8Vdtl20HGW6EQHIYVcuJc
	/0nzrUWj4kYeNEwIQTQrTsMiur5a6vo=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-85e76e886a0so533937885a.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760414971; x=1761019771; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2t/ysbOLBQifu3AncOUS++OTG/U64LIdWxNEMaNf1Yk=;
        b=gWIc5B1alBGuizeWFro0axOV48O2OsIuoocTJMvvIX8OyY8qH1zPHL5TjEv9tk1X0w
         f1Xuj9SHHitgTGwjAkJFjvk3cBZdVIQOofCC90Qm/xhXP8pV/rcbBsj89hGtj7FKVq/J
         BWD8d/pgu/gqafwDA1J588HjAemfQ0P9mC7D2FGPFPASXo1RJQVt3Y3UZgqxvhp8un7H
         P33MIeRzxKSUyJvIdmeK4zDGkKL1isnYl3yVAsC5xszQKg/sW3N1P/SCultaxdYmwm95
         UOTPwC+hBrlhRda8k3ZTJEvuG822Vfezwv4+kpZtv6sv358d5OaFlY/FSIy8EkUPfRIl
         vuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760414971; x=1761019771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2t/ysbOLBQifu3AncOUS++OTG/U64LIdWxNEMaNf1Yk=;
        b=dI1L4x73JNC8Fag6nbzmuT3vzf1a2yn7sSgxEG4L95brEByThboh26ODdeUTcAA3pr
         ReDMDKztdWy5oyJ+eX8WHn/OBUEut03BZ0NZ50TngXgj61SdmHkP4bta/vZz/aqKABP2
         9hBfEu8VB63Y4p/vz2SS2C7Z87GN9xkUTXUtvQr7FQZsDd15PH9mEh84x0S7w/FUzabm
         f4oeYNyjvgBPRuPIDWXJpuakiO/tU/hdpVSdUimPMz/c6FQ7AJ4mA4ajNqf1FmGHyvK7
         MdTOI87rrABcyPLOo9E1qIEsaUdeuCEqrL+j8vNObylP4PwrIyaLkrViuTZBNfq4naVb
         9h8g==
X-Forwarded-Encrypted: i=1; AJvYcCWWEIlekwhgDkx0/cvU+xkME7Aza8Huf92pWBJQmoaFrc1eumFInLoNrBG9GSWVDTNAwxZrBR3+eA==@kvack.org
X-Gm-Message-State: AOJu0Yzlh3QB+/LTeDxmpsv2MzpmV9lqOeGr8e2l/0A0tVg/eTXz3KiL
	iP9CQ5clnQk89hbCYwSDzUt1ZVlFZIABtA+0v6wbjb8sLY+DoAynm3+EICfWwXhw6+DXOKyPyZ/
	kVVeVEkg52KtQ3AijrVFpDotC9dsUty8=
X-Gm-Gg: ASbGncuyrvT58dd0SvHoyBs5cRAWRyT06IUAmz1NEELTVKe1WoCyLs+wC0V9HcsREd0
	t5RAIjJS0w8lB3JhDo5LZQkrOpghItH0Gr1MM0j6fiviLxH1gl0H0g0OUFDHEG1Qp56e7bTZ5BW
	x5j/4yobS5KVesb3R5pd2Xxr4cbUWBkSf+TNk/HfiIys2tBV2r0UIHTYSOo+QEvgE8GuXPEyR3F
	XEfTiEsBy8+YhwQhP8gjYjK5YlQDTW8Uqx2vPwY8j9C0RFdifE1eiCmsw==
X-Google-Smtp-Source: AGHT+IETi+Y5YVwDc4yOoULmeg0a/9GeqOMfyBB7w5srSvCikgvrnPsYVAaDacZCpZa84Vw9/offBLIwQL/Ei3+rCbk=
X-Received: by 2002:a05:620a:2696:b0:883:9634:5182 with SMTP id
 af79cd13be357-883963455a8mr2869615085a.2.1760414970813; Mon, 13 Oct 2025
 21:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
In-Reply-To: <aO11jqD6jgNs5h8K@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 12:09:19 +0800
X-Gm-Features: AS18NWCg3XvdE0hLImKQoNMslsxmyNkYfWghrFBQZL30dkAgd-aSHHY4CyF1lvs
Message-ID: <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Matthew Wilcox <willy@infradead.org>
Cc: netdev@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4r86xofdkfndkjajhwhjq3m3jpqcz8jm
X-Rspamd-Queue-Id: E5FCE100006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760414971-128785
X-HE-Meta: U2FsdGVkX18Z3r56+8GwBjQzaPKoRx4wWLj+Gnc5ilzeRSQ0vkZeullehjVXvimgqfKB59rArbdSHgjjTRk4xZsZgbeFzCWCv8JdAJnOT9IZ59MJ200Z5iQ++x6jXtlzKSVQh3Br1jIhFMgF+BhBuhcK8q8v2TOb8xsBg0mLYk8Wtvzj70/LU8cij7XJF6qLxU+836OZ0SYd0WOj3eGaqR5VsDG3WOqeZkQdMeQk2JeegmFV+ctMCiHXlcv942EkMvzWFeDxD7PR+q4GD6kRcTOa2Wu7b8aNmaZD6QDQoFJKYBprVJtletII3z2gwuy7pxJsAWkJe2AQTtYDBKBAHwpa4jM9wO7kSxwZoN6N5iwIbpH6k7vAwAuYTX3qOOr0eZLq2Cr6TkjmsROSGuPutZP4ZUsimSpAecW5x8fWRaTK5J2dcFFyCd7kp/NtDAdOm89Zqqhqsg0wCzKKMUq9Qktush15QHSEfUrveb5eJxOH8Ff0/7d3cL7eibyX+YpmDu7AafgA/OAxc5CmjdNLjF7pYi6zAV9txdfk+Jrfsjr9x/oOF5KmcVkQkQGZzV7xnQzeFRE/UWGTywe3oj8Tr0zVERcJpzca/D/vG1OuONohC2+Q1l12MEdtct/LkTzXCzqmdLSlpcLmQPrwkUS5Se1DbTrlLcWkqG6e5iiYYleiPVaPTJPCrKf6GRDAaG8sNa1pij7VBmVvgTrZH3zU0lxdVJx41wFE/YP5V6S9ili0fVlBCt4M8T9qf+0tc1iXdL9KkMslDlSc9lopFdfKcuGe7WeQKzb6OZwx1k9ZYzVDJWxkSGc63oywf0jbkpm8gWqZ+LNcKJ5kHxfdigta5nqEbfWFfmTECH+qGdq2NI1IxiTwWVy+0lm/3ympEi+bzLMqxH7vsL+NmNTlW3ZURCz9temdjzo55Ju/ZLM/fetNlUViafYBPP+/Zkyuyzmiofnc/mpgLMARK1TGyrm
 XP/CAisg
 +UTpH5OGziyFamW4zlJDGNbHNzEJG5sJzMTuc5vxr2SfBJ4y0GDsUKrzvR0kqIp+L6P6SzP9DTXk2PQ419LXSCjm46Tn2WLc3lRhoaCvdCglQVCaKI945+yhHgpi34IaQz6R7H9O5PJySBWpAdpvKyz9W3zmd+QjGi77I6s9KoFfqhLDxdYk5NEGdt2mQxLQ0XkU7iunrgePgWY+Vb5Q2xNoiZNKUDVKX0U5mdWXtzN8XGA2QMM+jSfwoh+8RQAjQplGhGUWhflvlWmwN9hMLX+gLmw4JEjfmwyahXw118D/euHumNmpfXjvHbyp00dR6iMJhKq6pARcdU2cCA//99rvZAOGfFTH7g5jojkDsbxvg+yrFG1LkfONW2dj9SJ68XrntrRZMfi+67yCz/WvjwS2tecVbJPqDFft4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 5:56=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Oct 13, 2025 at 06:16:36PM +0800, Barry Song wrote:
> > On phones, we have observed significant phone heating when running apps
> > with high network bandwidth. This is caused by the network stack freque=
ntly
> > waking kswapd for order-3 allocations. As a result, memory reclamation =
becomes
> > constantly active, even though plenty of memory is still available for =
network
> > allocations which can fall back to order-0.
>
> I think we need to understand what's going on here a whole lot more than
> this!
>
> So, we try to do an order-3 allocation.  kswapd runs and ... succeeds in
> creating order-3 pages?  Or fails to?
>

Our team observed that most of the time we successfully obtain order-3
memory, but the cost is excessive memory reclamation, since we end up
over-reclaiming order-0 pages that could have remained in memory.

> If it fails, that's something we need to sort out.
>
> If it succeeds, now we have several order-3 pages, great.  But where do
> they all go that we need to run kswapd again?

The network app keeps running and continues to issue new order-3 allocation
requests, so those few order-3 pages won=E2=80=99t be enough to satisfy the
continuous demand.

Thanks
Barry

