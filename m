Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB3FCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94996B008A; Wed, 20 May 2026 05:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D458E6B008C; Wed, 20 May 2026 05:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C347E6B0092; Wed, 20 May 2026 05:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2CA46B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:12:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DD631C0C7A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:12:45 +0000 (UTC)
X-FDA: 84787233090.28.FE24F1C
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E0C116000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:12:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GLK1m6Aq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779268363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVK9lCG8t/9sfDORk8nI6RMdbwpsR4qFe6/O61rN3aw=;
	b=AHcFCFKhXIb8mcMF4i2QwmbcGYYstFHIk/VBIwKV008cX2zE6SXK1JGJJ9KOkxnOrAI8Xk
	L1Xd04VdqMz99ayoT5/dC0gAh2q1Or8Ia9a5q/ocpi9al8uNKC4JXxYsiF5bsQqdW+a4iy
	n9xpTzUgMLcctuhFCBvcTKEKAS94u38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779268363; a=rsa-sha256;
	cv=none;
	b=5gghi/2DRVznxJ/rmv4xGgX7U3M/LYClKYnVMDd7X7hykQ88ikFYOyynBr219a9AiuDfrZ
	qXONMRhoPITLs9sqZpSy/4m4uGvsJpZJEBlrVtj7wZa8lmNVuKq4ZYFKc8L3/uJk1SW41z
	Py5UUZdvdq1KfoSH6lRXgRzwGBkxlic=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GLK1m6Aq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a887ebb416so5674469e87.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 02:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779268362; x=1779873162; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XVK9lCG8t/9sfDORk8nI6RMdbwpsR4qFe6/O61rN3aw=;
        b=GLK1m6AqY6ecMUIQ5XaLs9vA/JofyL3KOvAzZSNe1OdTUkVpcPj16DeLdTipnMJ+u9
         MzxxUYKQHfqOZz8DshbFarPikvZ703bwV7HsetUEqsL4x89OTXl2kb+McfSXE9weHk/H
         uoo/MpdEcwy8YYOwVRb7M4pgO4v586Pe2oSzTeCv3Jjovsbg85vnEOdPmJ+KYNX7gAyZ
         G7DItkdI/D69YNY9hob4ngTfdIBZ0FtzjnYglTujmVnbZcQEv4pBJnLctBYoZGYIKakE
         I+NgMG+oA05MxfZkdOuAC6fIfXW9iWtQtNTj97vjHd63tccy61BRDH9Dh28+K5N8QG+X
         6HMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779268362; x=1779873162;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XVK9lCG8t/9sfDORk8nI6RMdbwpsR4qFe6/O61rN3aw=;
        b=FplwM9PPN6gtXz1n2vwQBysrGA/yFPIEUZ7g99kq5eJUwnO4D6qZxvrkKheR0mt7rH
         P5YySTYKX1StyrnOeOwf8orZ3oPAkJK8CdPmKZQk2zfsR4LEXqkt48vdDci15MlzTxAV
         1pnrpc/DwcKjNc1ys6Osnyo46O3KMBtZlBte2cIRHH+GCc3uxE5OWs5FR9t1hGO7w12Y
         O2TSNmmtjuiU6UzpGuqPjYwhT3EXM2eMI0F2Ox33uR9EVDb0Usyd+oJ4M0n7AT3rccQv
         WTiPJaftBICh5Xne4D1vKPr3D7EnvcSgjjzc5OjDu/1vM19R+sQrz4W6WoNWy5lDf/Tb
         h/Qw==
X-Forwarded-Encrypted: i=1; AFNElJ93XPMfJ/4qD34+HYD/9H63IW41oQ8DsRAyn6V5KLFW5gZrPYuKJntaUib/LusPhTxX3EXTbkOaUQ==@kvack.org
X-Gm-Message-State: AOJu0YyOEGL/z2IIYBumvkUX9b2u0atF/4LNJOz89geQ78BkhcHHli9D
	N5fRiA5ntpvSDqDH70KTQw18z8pmXYL+LCw6UAwfQ/R8bJSsuImQIgiv
X-Gm-Gg: Acq92OHuyQ/pIX+LCFjTGnHctG++TBOjfKb5Q0RejNLKCkLWc0h6EmGGcRrzASctQ6L
	QxLkRkx70s2ueibjUtQ7xguldwSCoj4DRD8FwL+Ix6JW0tr/VM4LOQWJJCBLqzwemZyddF4blip
	dT3RJ4f+vRkuG6FafB+k3ZSGVS0APLWDtwY9wXKUtbMVXS7CvgxHP5FQM8HBoK9yd2JEKnP5Ch6
	EF/nLJZp8Cl63CKTcKtN6/OKtg1wvxEacFv2hpha1vhYV15expJknXHP4HRZmm6UOAZukH05Yzi
	Ibr7zdLBi9jPiUxQG2nLiQ1BZX/AmIMlgtICa2OjW+c+KHQhmA0QAL5Bfp2nKmBaOTPORYdVkcO
	tQH2Dm9MCBLvxIsloBasG5kW7eWuqokoeYyY1+dc431zj2pVRkkVTXTO5JBvokdNtCM6bw1Sv82
	PMFMIC8f6pExtlL1ThVa/CLoNHFsHg4qHwCbItx99JyN1Q5fw2f5Mbiw==
X-Received: by 2002:a05:6512:6c8:b0:5a8:72e2:dba8 with SMTP id 2adb3069b0e04-5aa0e6191e4mr7180894e87.3.1779268361357;
        Wed, 20 May 2026 02:12:41 -0700 (PDT)
Received: from pc636 (host-90-233-198-171.mobileonline.telia.com. [90.233.198.171])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a90f11a7c2sm4711004e87.32.2026.05.20.02.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 02:12:40 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 20 May 2026 11:12:37 +0200
To: Barry Song <baohua@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org,
	Xueyuan.chen21@gmail.com, dev.jain@arm.com, rppt@kernel.org,
	david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
	ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2 6/7] mm/vmalloc: align vm_area so vmap() can batch
 mappings
Message-ID: <ag17BYxJVRUu8JhV@pc636>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-7-jiangwen6@xiaomi.com>
 <ag1jhrWivbasi8Jq@milan>
 <CAGsJ_4zjQDOXToau0xoWOTnoP9kODxRdzSeNX6n_b3wxguC4mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zjQDOXToau0xoWOTnoP9kODxRdzSeNX6n_b3wxguC4mw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E0C116000A
X-Stat-Signature: 3578kznzrmrsdw1tetzq88hwoyhostcs
X-Rspam-User: 
X-HE-Tag: 1779268363-257282
X-HE-Meta: U2FsdGVkX1+OUDGyCHFQ6/TB5imptEfWVwOvaxplIiDh4O/0lFXINvZnn+icKuEMsg2VmjjyNSySWTROL82WftQXrik0PtfJ44JmeWwA04qg2x7pM5AY2eIAkmOUd6mTyykCrZfr+rGen4PMn6ljyaZXqnaqI/oJAlTewarvDXL/7rJSe5h73YGsRwE5Jk7GgftKT0E9g9/gt+E6nojE5+T6hxlDAJLaCkDVlqlgCRNMOOnkEvBhvg7JReIoSqeL/aamKW3reNOi/tHAG6ccJuKhdJynHfI3BfAHlr3nQj21hrQt/CmoEq5zJUfFlCPG2iK8O86tSIQOlDiTvr8oifyL8jrBls551vmTZ95ctLEXbk8V0OQyqgRJ8f/dxZKbGqf07J+/fhf8bcTOAStR1lT74zVvMuGlPkzC7HfmOIbA0IDwkNzreoWxcdmaJE27lwe+CZVm0MipWF7TxwOgf6ScS1IhNjatIDpmRdnAu8iEbAmrjnr5Vt4Xva6oPtQ3RwR2jmXUDFsfWYXBcAXy6I/UnZUE4RMJC72CUQzUqjiaBwzMXc1wgUfayh6zO8iyX/PrmTmRPbE7IWd7HUAWZ8AVwuqv9bOkCWKdFqQAHRzZmBKJpgP1NZHoUqBrfIjutPllolnM+EbgwLX0JtTXoTvR953BK7mQPWfLYB9OvoWKKmyoJFGUkTvWglkHuohSpZefIe23OUvRMmD7Y1a7Np5yhpKVICuPAyFA/gTiJQ9Da5u/4M6dRQNmjpUs56nbd4oqj0VdHSjvEQriY2X5CajXINlErBvkLWNvs4xxBC6zua85RfJm26rn13/DZFpYaHMnbpM/hT0eyxmFK8DKDbpBEeQdX9viyhn2BuUX9yScjzyY1CILaCl/MLMMw39vHtfMms37rB63Z5YBwsa8yOynzjtFhW1gHhac+10rAdCEa5jaR5IfPmn9nCt2Q6Q/D0cMROSrooYnM9L3yX0
 Fjylnaj5
 CyYoESg1W0+vynBp37zThb4Afs+B93eOkeACBoyRYnyZGL2cWkXitBwVpuDLpwqvGOjwGMOaPzwAxwdZEyEF5t3Pw0q1ET+eekjg5Eor0KSUQNicyB0MvKK127CxGJdtl6kIaNKrCUdcndNfJZfU0kZhIYtEN/4UOfbtcfUP88JSJm7SUcgKeuAg4/liZS1vc+bjGFUIyYdqUDAR6zB0ir8Q3kYiDnDuZS6U4FrKU3IT0dT12aq7wUOftoEpWYRdX89QDBJ27qGOpHgDEfvdobtk60il4fv8WYjIUmDiHpsQumiGBZxry6KMwH26aomeyb8MQEiYz/YkYgjZcbhsk8BSun3wrWjuUOtc6uy5uL34GO8hv77U6z+JjBlb39a9YRrjhkCKpko0GK8sGwrv9eeRk6prce9WsQ62ysz6fy8UILmw6HxDUR2YO5gR0bhwCt4Dm+CKjCQ+chcEcm90SJCD4q028lS2dYzdrZNUkF9bkuHbHQaX9xBllLyY1cqlSz+puhn8COd0yUv3lGfXAm/jC7LQZ17bv3T4bQZrrR8cUuXNG50rXkzm4khKhKkJQ0oKr2sC+A0nSPdqNUFhK03CZOwvRJ+okVlsPEAu3DLfmPO/HvqUQ/yGMA0KCcnDYI5EfP2cIGWS0t4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 03:55:02PM +0800, Barry Song wrote:
> On Wed, May 20, 2026 at 3:37 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Thu, May 14, 2026 at 05:41:07PM +0800, Wen Jiang wrote:
> > > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > >
> > > Try to align the vmap virtual address to PMD_SHIFT or a
> > > larger PTE mapping size hinted by the architecture, so
> > > contiguous pages can be batch-mapped when setting PMD or
> > > PTE entries.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > ---
> > >  mm/vmalloc.c | 31 ++++++++++++++++++++++++++++++-
> > >  1 file changed, 30 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index c30a7673e..b3389c8f1 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3591,6 +3591,35 @@ static int __vmap_huge(unsigned long addr, unsigned long end,
> > >       return err;
> > >  }
> > >
> > > +static struct vm_struct *get_aligned_vm_area(unsigned long size, unsigned long flags)
> > > +{
> > > +     unsigned int shift = (size >= PMD_SIZE) ? PMD_SHIFT :
> > > +                             arch_vmap_pte_supported_shift(size);
> > > +     struct vm_struct *vm_area = NULL;
> > > +
> > > +     /*
> > > +      * Try to allocate an aligned vm_area so contiguous pages can be
> > > +      * mapped in batches.
> > > +      */
> > > +     while (1) {
> > > +             unsigned long align = 1UL << shift;
> > > +
> > > +             vm_area = __get_vm_area_node(size, align, PAGE_SHIFT, flags,
> > > +                             VMALLOC_START, VMALLOC_END,
> > > +                             NUMA_NO_NODE, GFP_KERNEL,
> > > +                             __builtin_return_address(0));
> > > +             if (vm_area || shift <= PAGE_SHIFT)
> > > +                     goto out;
> > > +             if (shift == PMD_SHIFT)
> > > +                     shift = arch_vmap_pte_supported_shift(size);
> > > +             else if (shift > PAGE_SHIFT)
> > > +                     shift = PAGE_SHIFT;
> > > +     }
> > > +
> > > +out:
> > > +     return vm_area;
> > > +}
> > > +
> > IMO, we should get rid of this while(1) loop. It looks like you need to
> > handle just few cases. 3?
> 
Hello, Barry!

> 
> I don’t quite understand what you mean — are you suggesting
> calling __get_vm_area_node() three times? We try 2MB first,
> then 64KB, and finally 4KB. If 2MB succeeds, there is no
> reason to try 64KB. Likewise, if 64KB succeeds, there is no
> need to fall back to 4KB.
> 
I mean either to make three cases kind of open-coded:

...
if (size >= PMD_SIZE)
  alloc_vm_area_with_shift(PMD_SHIFT);
  if (vm_area)
    return vm_area;

shift = get_supported_shift(size)
if (shift > PAGE_SHIFT)
  alloc_vm_area_with_shift(shift);
    if (vm_area)
      return vm_area;

return alloc_vm_area_with_shift(PAGE_SHIFT)
...

or put everything into the: for (i = 0; i < 3; i++) - that way it will
finish in any case and for user it is obvious that we handle max 3 scenario.

> >
> >
> > shift min value is PAGE_SHIFT, could you please clarify when it can be less?
> 
> I guess this should be changed to "==" ?
> 
I assume shift can not be less than PAGE_SHIFT :)

--
Uladzislau Rezki

