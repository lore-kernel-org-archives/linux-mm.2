Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5DAD77891
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA246B051A; Fri, 23 Jan 2026 12:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297E96B051E; Fri, 23 Jan 2026 12:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A636B051F; Fri, 23 Jan 2026 12:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF9C6B051A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:31:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86E24C1F0F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:31:17 +0000 (UTC)
X-FDA: 84363919794.11.D3C626A
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7A2A64001A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:31:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CFjNAGBR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769189475; a=rsa-sha256;
	cv=pass;
	b=gWCl165IQdW+YsCRuwlEktAQGiSh2waIhez6OC9326F4th2xp/woGKI9ib7ib4T7rswtB/
	X6BItCLpkjNmMA8f+67a7lNO2SQdEJ03tjSw73JmbY3WxqOA/hTbiG2H0FClWb9zPphHdZ
	51wp4KI6AYk1+FH3mphjUZK6VR+sW+4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CFjNAGBR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769189475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//l0nEjTNRiO6ok8x5R3UO9HJXdIVnzS4jZFSqDgDdg=;
	b=XvR+mL6dE5/xByRfY9IcIrqZ+8WxDhXSBFlimlggEVzvHukPdXHDq1IK3sU54qnS51vlw1
	YV0dBz/i9pGTzzBznr6Ohu4h9WFzK0Q2xq3YuVa1obclXIlYR4nZP8Pn+vxQgTYYVp5ZNp
	oNMqIkwKKbeZGG50w27tJb6Go7bPLoo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb5810d39so1569207f8f.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:31:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769189474; cv=none;
        d=google.com; s=arc-20240605;
        b=jNJtZcwBEtNb8AuvRnUU2cJUm3rIxTklwCzvRvUQshITrqIK6Y0H34xztwO7TLL1nN
         SSDBqgis0fjJF0LqQjFBbISuzTrEDJoFtnUp4kc4zGx3k8Hp4XRoomQUaudkESqjn+5P
         N2+7EfC9qEF8fLXEeUxjwCMSN2cVW2xHsWHtUAT7MvXcs7uGF6/TJhYcDmjeiJgAQhwG
         b8dnSHkt6DuvgtOn1qYnq4WO0F1DkC7W4/lydJEzISKfe0jNaE6AdF0aMwzmZVhh8EHZ
         AfYizh5X3HFNyFC/nJ1YnPXZJuUgibbTgdXec7inFK8oQS13Q4o7KrAJnLwtQzzKf3F7
         cTAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=//l0nEjTNRiO6ok8x5R3UO9HJXdIVnzS4jZFSqDgDdg=;
        fh=mhKIflfzxaHu5rYiA/IPKInYkSDd7FF1R6zQJK9wXDE=;
        b=Bkj9s8+nnMshPh3x1htqYG165xIQ7r3pN1Nr+ZUU9+d/xRyZasYS3mzKpz+ppWGeWI
         uMnJo4NIQ6wYHfLvnZcH4J6/zO+BjqCGt3y/tXKm1JVlUEnT8ZSK76uzIg7Znrpaurzi
         pSIJXl5QgbStWGJgnSFK+KLcm+9JgfK57avqKb/9YjLL0mQJ3vE3Akxt1d1f8mxoLICV
         m60uD4ZNr0Q0MSVVDIM7f6/OQKA75AAB/FQHNMnjY6BqpQE8dQ4GI71fuv5gMlvg0t3h
         JLI3Xroa3pnPKuj6oI2C5bcKVS1qTWUPdut4wX63khqEXa81bqOuW06m2RdUgce7WUDX
         PZtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769189474; x=1769794274; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//l0nEjTNRiO6ok8x5R3UO9HJXdIVnzS4jZFSqDgDdg=;
        b=CFjNAGBRPXMiRfSCaBc41Gukoztb1V94uW5O6uOvtlwjhHzj1P1II6EAKJaElGKtHa
         G/EvqqENYQxcZ61h7gJnnJ4jw5XX5QjUzR1q8Igo/n7TJuJiZU5g2VMeajOk4F2FCWxM
         +T1sQ/+ta5ZQJO++FIAkpr08L+PyNnSwK6q6qnxwuc+aoEsK1X35FvF1hqLuYjCpAQJ/
         JbXYNrk2lHkREiSfrk+bPADt8x6ZYoJZXEoK5f/ZBw629u07nmMNp9MlsLTHIyULQF6Z
         cz3oreY2CDUcSmPUfFshyLkWQIdfwgkAlutPn0P64q0Wr+Lq1XgIKxZv3tWaWYDdaUyG
         Vdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769189474; x=1769794274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=//l0nEjTNRiO6ok8x5R3UO9HJXdIVnzS4jZFSqDgDdg=;
        b=wOHVVi2iASy4lAF8QSjnOKTADVeebnHqMDFF9zXBrp9fmpbsNk4qMtVUxLg/m5mlCY
         ZnrfDW+eeANZgUyajVKEiUedUVmyY4xNfTQwZNEFSekXiiU+yJTmw2MupScZTkxqDmGP
         SMatVjN3ed5htEbUWqQ+scajmMQeScqPRjHXcUQrkT6EVwhWWjpixi0Q645zg39WRorY
         xaoa5YorYdRWUHMJPdV4bly+tf4UTDaC3VR2RrlCKzrrAFOE6tOze4YIqmrfM9lKzG2x
         YFjwDL/TJEB/WKIZOFocyDYWxZEyzzaB75+erkewoYV1SyeKwlKEwm6O8cgg+f3cYYA8
         xJkw==
X-Forwarded-Encrypted: i=1; AJvYcCWIc8KeZXSvEcMeBZ0kj1PAdIN3qFaymnCBYBldYdZemG6FU2JQTMeQ2UR7ZFf7SEAbmY4wN8tcgg==@kvack.org
X-Gm-Message-State: AOJu0YzA3/Zhh0MvIXCZjUTXRIKvU3/YDqqcVh33SMofyQoAxHUd7PuO
	09Rm8z+BY/D547YqHE20oJWSI79+BZWoTvnAn0c5ELnaK1oW9wuOID2oQYjI44QyAsmAybOvzY9
	ca7r3LGQBXA3gv/5O3Wrgtd/ZbEwoDQM=
X-Gm-Gg: AZuq6aLHkRf7W8yABy06kSDKyagwPcLor0FTakH0FIjHwbG2jdgmhYtS4ZBNNMpruXq
	TsELxmiBPmqrFDVzGREd3vlqm50k0oH4PhjglbaSiaWetTGvxPjuN+Np/VURgy6agwTLlbllY5U
	W/5Z4dSjhSwJJNWnnO40V4RCa83sdU7NnRBkNVd/W02VNZH1yekD0VIPwbsJPKPShtQrGmWESya
	3Mc25yurg+IjAOwkN+cA6llQa/+VnmuhuuIho/LEAiKqnpJP/uj+wo0PusvzbS239rOML13MHVk
	jDr7Y6VnaBpdAQowfXD+ELkO+AoNfo3SCG45XDm5tFSKAsNcsgeIwGVFUeDnWxw3qsObpMtC
X-Received: by 2002:a05:6000:2dc4:b0:429:b751:7935 with SMTP id
 ffacd0b85a97d-435b16280damr6748411f8f.56.1769189473665; Fri, 23 Jan 2026
 09:31:13 -0800 (PST)
MIME-Version: 1.0
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz> <20260123-sheaves-for-all-v4-14-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-14-041323d506f7@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 23 Jan 2026 09:31:01 -0800
X-Gm-Features: AZwV_QgSD9SUVQI9Y0Yihip1NN5Dune2qBBleSwBNI5G1-MsD4RlJ98R8TtLbTY
Message-ID: <CAADnVQJi09vC6Y-jb8mCRfj-OrECvSTMQ_XL2OE8W-B4zPwGSw@mail.gmail.com>
Subject: Re: [PATCH v4 14/22] slab: remove defer_deactivate_slab()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A2A64001A
X-Stat-Signature: 16c39efuect6fbba7cxzzridjkrtmng3
X-HE-Tag: 1769189475-606718
X-HE-Meta: U2FsdGVkX18cyWPV/Ac4btP86KUOkowyTeptRDGfzqSZWU3qOO5e6ULuEp9+4uAhczhIn2D3GSN82GukK6mwoKMjg611BkP9zpBZ9iujji4Ezupndr5+WlT9D5TM8xDzzHvyWcjHaGxFFm+KDd5rKnvTzCgyGkP/lVkHCPNul3snNyU99rT9JAa4feAYOV9iyL6LIqYV3lX2yHjf0AtKUeIk+r7DFHTdDA3+M4U0UrVNkzaFARqHGmgEtXhL7AwXvyzyU4HND3nXjNtQXEtWZKNN1Q+nJke00xS0+OrzScslDwSfYqojPo9QVDRvjOITqRMti3bhaAJT+FYLd+nSkO3M/E0jB2XuOHluNILxEVTT6pxnYPnZ3uMHQ4RCXf4fVLkDKbQmWw9PPGmoPn3R3N/xkPN9hP2ePuirvCVfEGQfzVJDWsblDjCHN41l7yxEeeGE/NELg0Hz4v4lZlzrUW7zxV6h4cKKH47RSSniTBtDGTqYZo3QdY/Z3sjPLZqCXwl9YHwcBBasw6A2DOwmTtZbQeDLLLNZKL7z5kZixbW4Ze8+NDKXC85qCnWROvJGjyfNc6IqbmnkNcicuk2EJtm1NkwLc+vJpbO0telvOs2dvZ4FM4qY1xwrBP7ueLwYcBEkaD0KM+4Iv2XDwgdH6EPCWc1axY3hV3VAWBXqn5m3W13kxFxb6hcS7nJi8ICixZRqb22dpCYWx4M3LV02xMqZ7e7JWfItbAqlzxUw88XzpD/5cAs2DoXYP9eqshazyrE88VQJrYZaZlxYboyW/HdXOyiJiC8GHqLmNkfv7XpqmWp/DY0aak7zUj4MxscpiWy0irgiiXYtXgZvFNnwll4s3XiwygT6eW0n24ChIIaVlp453bFFox9Yo4K3kgQ54d5GwYqKggLX2+99y3oWN88dhWiJ+fPRwV21u1KQJJEKQea+o8hLzRMCxaKh/XfPAO+98jVR0VKiFp+YRRM
 UaqBFDTJ
 Wwn3A7QO7+VVN1Iomw4+wn47qSf4myoSBj8nAjtsNm425hRAL9Be3KJ3kIm7YF7MP62P1/gOBxcy7U5hISOXyUMe8JRu0cV270TX7GMJ4LOLg837uuone4P61hV+bJMfG6noPdRmc/XtxDDLzKzIEbAzQheIN0RlYz/+6OgJug6J8Q0RIAMk41CCtdIVb71V/eGwRdx7SKOYi3GnZ4zJAF/y/q4OKbVr8I8QbDhesT1A/k1g9hREUYcMe0SW7i+IYnCJLB2i8piYWLNB/xpHDWOKwftugpIGe3SsiNLnpWwsT72nSg8a4D+77ffD/+VNNlYeQF6usK94Cn/yxELMvZshZKZIQf+jnyPCdXPptenJKbtqTkr1MUU3MzlDHJgj2XQAF8mlORKK7lDmJ94GkaP13RjWMHJbVG2f1THgE2PFm8+sz8gj6mn23xvMGWFWdUYudaMWUIgjiKoNchFokHDcNsNtbbql5cc4W3gg2oAUSX114v5cZy7zrCK3BvqZDDP6QkJmA4r8RRuUClZQ0jPmqNs/ahPWW74HIIwb7s9XTrso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:53=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> There are no more cpu slabs so we don't need their deferred
> deactivation. The function is now only used from places where we
> allocate a new slab but then can't spin on node list_lock to put it on
> the partial list. Instead of the deferred action we can free it directly
> via __free_slab(), we just need to tell it to use _nolock() freeing of
> the underlying pages and take care of the accounting.
>
> Since free_frozen_pages_nolock() variant does not yet exist for code
> outside of the page allocator, create it as a trivial wrapper for
> __free_frozen_pages(..., FPI_TRYLOCK).
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Alexei Starovoitov <ast@kernel.org>

