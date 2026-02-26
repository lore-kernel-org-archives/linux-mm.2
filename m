Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5284CFC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B212E6B0088; Thu, 26 Feb 2026 02:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEAD6B008A; Thu, 26 Feb 2026 02:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B08F6B008C; Thu, 26 Feb 2026 02:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83D4C6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:19:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 279B713BF20
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:19:02 +0000 (UTC)
X-FDA: 84485756124.25.C1D0775
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 229DD40006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:18:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgdGxl4j;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772090340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
	b=K/UOGf38cKabHs65lqhpsUBC+6T6bAel+CMIJC0qnBZuCVv2MHvoXO89Dvbl7yXqmdVXEe
	c0wOIM2bASxlpBCjn8lowbQe5qbvLjIPgQf352Uf6CR+1ocfcHkqve9PSmPylkppr87pGg
	LgmtWwaEHJXSE28Q9hykcfDIdUgFkdg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgdGxl4j;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772090340; a=rsa-sha256;
	cv=pass;
	b=TwxHGcEO6XTcjWtPaYNzcOcjI8FJt/OIF406B7VW7rezu94u2Ggtopdbn1HOCgp4v29U9W
	Sez2TnLQoY6wPwYA7plHmQZQZdhHS9RHk1BG2zl0Mco8SGf8X1dEXWBydDStC3vLddOMDy
	aY5vl00+bpbSd5DSOpKn9P5WfwKedp0=
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-94acf3fa688so139317241.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:18:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772090339; cv=none;
        d=google.com; s=arc-20240605;
        b=bmd6/m+AvaZT9WavKZg5WbbT7MDFvPinVlHp4p1dQNoeXLNWOTrrhDcVh9/hzrDtgE
         uXtjk148FrxRTPPE2Kam40iDgDflbilUwmQwN4yNeVl5ZOWAA/blU4Nn6qt/tQfyw4y2
         85OJoLsFkVhAsYYycDBsXjJCIfxRz31UYYWPSBuFLzevd/swC5HAzQCyqsN+1qHNMRdE
         QrsNe2i24JbVJV3WdpKuRDc8EQxhftlqdn5Lg8gkjaj+8/2yhClYJQ/m1OTjj8H/7wVJ
         pzt4N+A4f+FKv8v1wdbd9ttq8613SQ0F4AxAjF+v9To6Kg33xrCgvyT1UN3Wl0jnlvp0
         uLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        fh=RkKIBlbGVO52ljbg9nFoDYH13dvZ+pdKokwE74qSS/E=;
        b=idpQVC4KVgmU5s+NM51xIwJMFI56elAMlzk4TvTzyx6nrgPzxJRsPEMgVWlbonAcyh
         FjTK4xoqAhmbizqbZ3aRav+FPHP+2vQwONpmAyPaAWUkHo686RLlhEahiZ1a6oIems3y
         UdUowaOFlyEpfdcK14n+WQFkx+OaMO/cNMluoRBdXImaj2p++4+BzmWpP/FEOfVWjTDH
         eorSg6dEV+/gBfmjDxLdE+AZ/QbHp6Mn0m2zcQP3diFuu0NfsAE3327k6IsQymq5H3+P
         s6kPxeY7mhchXKzI7jfsko9SwBye/DzoJAhhTSjWmJfOvo7oPPyPRFL72LH+5JnnK8e8
         xXEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772090339; x=1772695139; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        b=xgdGxl4j+qgjkhBKtDJlqgPYgoNxo8B3fPudJEbKOINTRQNUzJd83HYVcgGky5yQnF
         MLJEVGia3YMRlQLhu5rxhwouOl8guf/RjbiTbqUDtxO0lFPgkNsbV89sSRPH5rkUopAB
         OUFgL4lc1awIb+tR/DrMiILG8XM8ncBhoWNdyxu3PfO7mUgZQvJReM68yHcHBKZ14oAN
         WKkeVlIfiim0VXWcd+1r0BinPhAmZzjiIRxxs2jxBIytpha/OO/ZV+gch7wfGyRlclE4
         hiGiK/ZNMBaqGUaxVPFusKDhzDE3mjY7ZvsV12WGNZkZ4DztZf/sOLvxIavu01YNlofk
         Mv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772090339; x=1772695139;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        b=EuA9h5Bhi++B5omrm2euaT4gXJTp89zg9igIgoi27BX5D9Ya7u/tUc/ceBs12t8NjM
         l1VsS05PnWcQfNCITzeLLp8o2w9hPHIxMH/wmMcYH96NrvPkRr12k1lMj1swpr/n50dD
         lxH3wOCz/SzpQWIdThvRZuBii5vJfDbuoud1KMqmetvEybdy/lE1CfhoxzP3nnXkae4D
         xSDAP8xQFvv3U9SM8z2zLutE6C8gxJWjOWxlZOb3w8+A/PJBLrd9+bKQAqu8zu15+Bko
         hbSlm1StTQhPDdSnayJdT1DkF/30edgOZiq2KAnXCyqQT+Z+8n/yxLh73IysC3hs4A/k
         t2dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCGY2YDTAAEEHpHCZPLHdcZaJkxSKzI6Ji40K5x6Jph3v/t/awNsfFTckxUpMoGyoDwhIQ5Au0ng==@kvack.org
X-Gm-Message-State: AOJu0Yzy0hZi/sHEa/xrlJwyXyFaX+kufJSV5V1TEWXyffH02eR6rY7B
	dzSiWqAKnKZrG2HuZoHo191SfA5/IUsvwWfeVpW5Om5Wh/LO4nrTZ6MLnu8qWLKVKa4BL6w+DSE
	3wa1hsxmxVygHwXj/6gDzMIfmdHjNL7RF2DXA5upZ
X-Gm-Gg: ATEYQzxMmbGyiVKtwqCB08Tk2sKwYxgJjhZFEqCielPc1aCX2p4ASBVvvwdGOBGIts1
	oye94PXIRtVpZ4NB6EU55vIRSV7TlyqmP/BE6IVcfh7wscrvRcGUI2RYn5rG6ximWzDbtEOfdkj
	4N+iA+cKmQSyq1XBNfvaf7Rzvk7cTI+8qXwwHDWNNn8ejCRnWLihKnDke67SmOQa2OQaWtJzy6M
	OpoiiWassBnU+5LJfHd0l2bn9Fbqt10YAJsmylcKPoGmg89qUWxGSfp8sSIuMosSJuzsfT6oWOr
	89Ew4amT1eWBO96tofrsNpFCFEDNhZIxT6eHsbSOZOpw8iNB+Ou3Ivwptp0Q3OvYm8Ar+Q==
X-Received: by 2002:a05:6102:3581:b0:5ef:2cb8:e9db with SMTP id
 ada2fe7eead31-5ff13ef650bmr1386972137.18.1772090338420; Wed, 25 Feb 2026
 23:18:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 23:18:57 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 23:18:57 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <f6649b09-aa64-4c91-bf3a-ba706f023180@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
 <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org> <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
 <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com> <f6649b09-aa64-4c91-bf3a-ba706f023180@kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 23:18:57 -0800
X-Gm-Features: AaiRm51uhp_e3rB2FjbroD20Md18UNjoNkKYVi3b2D7VPNikPNLP_eyGmYzYmA4
Message-ID: <CAEvNRgHaDDTW_CFT_91Rqzx=OErmiP1GvtuCYnAs_wNRWb-hZw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 229DD40006
X-Rspamd-Server: rspam02
X-Stat-Signature: 45rbg6z4bc11tfw6qa5dj1bfepau19wx
X-HE-Tag: 1772090339-810397
X-HE-Meta: U2FsdGVkX1+9AF63STgBXFwYVSgedLJT/lqzh564ORpRoIYqJUIb8Ww88BDUCaEVFj0jzLGNmjCetL3y6R363aetneYUnqdR3kX5Bb697sqWYb9Sv/rw6qa2GkjHT0s54gkcaAFaXryES0BhpWBA1Y84M7rn0jzabz4FHLw0u+oimKW3hyuE37Xmlc/agdhuN0+W5PZzb5hJ/danvDe/eM3D/QMydIvRTYyprFwvLSYKhX4roCBRo53b68cSnGLHiVDv0oS3CnBsLdBRSlUzFiRcEp9hJd9Gbt2Y3vZzuSdM1x939gULOYivOpcJTHNW4RpasAyii8UUAyrf6jyp1/By6YsBhmMbFLh0yiRGAI7Fc+ZKUDlgFjtAV7bDlsOJDC6tyb/3hGk9z2ygyAyQeFd0vVJdyDpmwHjHQe4e8AWZ5n5XtCpPobZ1G5KHazTBc7aUTIyMa3sVwo1CLjV226nHL1Vw81um/xos/Zn2xCzh31g4H6gM5zTTzxi7dmIghhREub7iMTevaVfeYuKSI3GfxE5mBWAUWrMDaFRrzTSzWdPGN7UOzzbGvjvHMJRGZeys4sFvSbPyn3hhQj7X5aIb8/1x9AKDtWcfedVvGHTJa6F29f4CEiJ1JcpyHfj7Zo28tLPXhsg1hD3GqCBrXh//g+VQ1vYRFkEp7XQ4EUX9+lRsUqyEi72QKgZOSEUv2tPGZvN6+XMmo+8DHK2k+Vl1CnbvTegtBwRgOBPTr8GjjsU/lK38j1i+tQxi40AXLB2pEjAh5P2U0jP6LZbNl2/A6hudcryuHottqiuuL5dxx2d6YBfvRj+SS+gCQ4ocWaahl8cxv0ZMi1zzhWNgPG/pWW4stKJCfXYeztekpnX9zHcIymuo0FAWndMg+DGJ23G6uJ5QqS0wnvohEbnXVVsmLEZZ4ykoWHSYebsJuwAemhXLmyYdkyGcKNlZ9XFrE3ER39oJd4xZlH1Eqeh
 yMbxZj0s
 y4nsbzxz59x+Td9vfwqy7obwEg9Tl5lofGrgMJHnSjj0kffamUy8Du5lTKTHdplS3PShkyHOXSwmREBbSe3B9aB1vSGvgJCR4M+PAtNK8+Ld7N5tQGroWyiy6Zv8mM4/wGnxmRF3OM2jw8oyqaA3I9XSQBcZpdKD3A9cSEjMrpfU/ckBQoPE3HHzEtS9pKQ5nopDvnrmiZrepq97jBgY3e4Gg6qIEKdJvwzVxER8RSTy/+ok6DJ7D4CnihNzbJVeq+q7IPURyPHub22mxds6JFDwbgLVbapsqv4C6Kmy5dzRqft1ccQgL2U8TSOgB1+EFKcRUSO1PRd062tgWrA+eRx0Lb2d7zLVo9jB8gBfq90tJ/xBWgnxs5EezN3fTIxKnk0yIkHVO4uWzp+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/25/26 08:31, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>
>>>>
>>>> [...snip...]
>>>>
>>>>
>>>> If that avoids having to implement truncation completely ourselves, that might be one
>>>> option we could discuss, yes.
>>>>
>>>> Something like:
>>>>
>>>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>>>> index 7c753148af88..94f8bb81f017 100644
>>>> --- a/Documentation/filesystems/vfs.rst
>>>> +++ b/Documentation/filesystems/vfs.rst
>>>> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>>>>                 sector_t (*bmap)(struct address_space *, sector_t);
>>>>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>>>>                 bool (*release_folio)(struct folio *, gfp_t);
>>>> +               void (*remove_folio)(struct folio *folio);
>>>>                 void (*free_folio)(struct folio *);
>>>>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
>>>> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>>>>         its release_folio will need to ensure this.  Possibly it can
>>>>         clear the uptodate flag if it cannot free private data yet.
>>>>
>>>> +``remove_folio``
>>>> +       remove_folio is called just before the folio is removed from the
>>>> +       page cache in order to allow the cleanup of properties (e.g.,
>>>> +       accounting) that needs the address_space mapping.
>>>> +
>>>>  ``free_folio``
>>>>         free_folio is called once the folio is no longer visible in the
>>>>         page cache in order to allow the cleanup of any private data.
>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>> index 8b3dd145b25e..f7f6930977a1 100644
>>>> --- a/include/linux/fs.h
>>>> +++ b/include/linux/fs.h
>>>> @@ -422,6 +422,7 @@ struct address_space_operations {
>>>>         sector_t (*bmap)(struct address_space *, sector_t);
>>>>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>>>>         bool (*release_folio)(struct folio *, gfp_t);
>>>> +       void (*remove_folio)(struct folio *folio);
>>>>         void (*free_folio)(struct folio *folio);
>>>>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>>         /*
>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>> index 6cd7974d4ada..5a810eaacab2 100644
>>>> --- a/mm/filemap.c
>>>> +++ b/mm/filemap.c
>>>> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>>>>  void filemap_remove_folio(struct folio *folio)
>>>>  {
>>>>         struct address_space *mapping = folio->mapping;
>>>> +       void (*remove_folio)(struct folio *);
>>>>
>>>>         BUG_ON(!folio_test_locked(folio));
>>>> +
>>>> +       remove_folio = mapping->a_ops->remove_folio;
>>>> +       if (unlikely(remove_folio))
>>>> +               remove_folio(folio);
>>>> +
>>>>         spin_lock(&mapping->host->i_lock);
>>>>         xa_lock_irq(&mapping->i_pages);
>>>>         __filemap_remove_folio(folio, NULL);
>>>>
>>>
>>> Thanks for this suggestion, I'll try this out and send another revision.
>>>
>>>>
>>>> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
>>>> might be more controversial.
>>>>
>>
>> I'm not sure which lock you were referring to, I hope it's not the
>> inode's i_lock? Why is calling the callback under lock frowned upon?
>
> I meant the two locks: mapping->host->i_lock and mapping->i_pages.
>
> I'd assume new callbacks that might result in holding these precious
> locks longer might be a problem for some people. Well, maybe, maybe not.
>

The extra time (for guest_memfd, and almost no extra time for other
filesystems) is on the truncation path, hopefully that isn't a hot path!

> I guess .free_folio() is called outside the lock because it's assumed to
> possibly do more expensive operations.
>

I thought .free_folio() was called outside of the lock because after the
folio is removed from the filemap, there should be no more inode/filemap
related contention, so any cleanup can definitely be done outside the
inode/filemap locks.

> --
> Cheers,
>
> David

