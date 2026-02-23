Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DB9EC112B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7FD6B0005; Mon, 23 Feb 2026 15:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9AF6B0089; Mon, 23 Feb 2026 15:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34676B008A; Mon, 23 Feb 2026 15:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1F0D6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:08:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87BD81C262
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:08:42 +0000 (UTC)
X-FDA: 84476809284.16.0B29FB4
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9BE311C0006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:08:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/cHJqkN";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771877320; a=rsa-sha256;
	cv=pass;
	b=G9QFOlZFN2IBM8QYS6diH0Eg/kf02Wy8nVwEp9OwHT6E08XkSrIIFU9hXTNIVGL86R5Aax
	Sc5CWLdmZi0sdu3fKOdj2XCksE4KJBBuC20hnPDl/T8scsSiEKI/DnpxzGggYLqTROXrYX
	Aelqc0Pt2pzbji/p6zvH0zrSkNkyDQw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/cHJqkN";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOM9+OUamiPR6YXOi3oPvt96u1RovV72e28HWgHBK/o=;
	b=HLe4kK+nSZBiSFhSZKVQ4gevhBTzFexeFb8neyER+Vyh8uxRhQD4pEL4YmhmT0411g28DQ
	19V1kXqaD3/BQ8sruHMlQ2rpU4HG2ks2lxB4+ihffTo3Ou5iIAf3eH6scFjkf6/5VDw66h
	p5sS0qaPczFDWXgfAVzt3AVJdzcohRc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-506aa68065eso41896291cf.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:08:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771877320; cv=none;
        d=google.com; s=arc-20240605;
        b=L9QGo2ysBgYO3UYB7flluSrrikMJn+cOoxAc4MDi7UD0iAGMpuO/qtNi8dprunVlXR
         +qO4RH103R9TnkOJYC9tTM9+jiY3+vdLLRD1fJqY3e7aZFR1DdA6Q2s+RcVoCBPmjnPG
         yq0apVAQ+hlhOG0kQBR7tyNl2oZOYNmpiZE4dvr7zAZQ1KIcmW/9jTCDs/wC1qgbxtfx
         QUzfWCh1bzJ6JknVzs/4K8C44qoSl9D/xz9d3+CGHzq0QyIUHRyiiMUj5DVLc4ijJ8na
         fFxKfRRlcq1LnOMEGoPoqFK7/Ac9WtTgDVsMvcZ7NnCiKF8RvlSTVDg4R69Df6RVWZP3
         dufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cOM9+OUamiPR6YXOi3oPvt96u1RovV72e28HWgHBK/o=;
        fh=Rs+1kv/agDo42RftU5n0dFsDrRJywZ89qZoJjKLGd+Y=;
        b=IdwaNw0tOzoE+k7dA7RiGfWlHiG5hmF+JrXDsO+cHd9kYpPR8ShqnVVYNJqnT8XuYY
         rjfnG77ghl5a4zdSNUrnU8NIknTHKrEbUPCipI0CDVY227IpCcjgb5zLi9EgfH1LFVaW
         NzsW0AYoBtUAg2qimJsGhgubOh5QT4mxPAalLyZFigkEPXHz0KLSlOjdRYxuR0ZqVn7O
         0xNbje1PrzqvnKzKYXpZFNfrcAqcvAooqgyMpia3+Dk3cPRj9puNRkljW8ohGmv3OleV
         oBHXXcErqe7cg/syl0wD/n6lfKn9qKIFdl1+gd9PyLFaqp3ZMg7ee0583BCIMRbsP2mN
         6dEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771877320; x=1772482120; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOM9+OUamiPR6YXOi3oPvt96u1RovV72e28HWgHBK/o=;
        b=k/cHJqkNkfXYZP74gO3vDKjuvz2FcMffjsxCSLeFdn0uh9eTqduKrZfroZbjTIy6ru
         ZyJ0g1hZol4qGfmzxhETiwfMvfN2uc6uDJ/08lHoGdq9D9FRUvGff5nW8mWhwnSQvs94
         YxaY2tbGfuOjIznpiF/I+/qCPj6r86zRrV2qlmYjbTmNZYzDVnHJrsG4QAsE4oJO9iBd
         luF9cWQIzUv5z8bmsmGriifSfmqvRMurkXKDsIt9W/R7Zo1V/nsceTOt82kra8BAclzQ
         8wKxz+9gZL8m8+er+TzIKsRsNjbcJBgq0lQ/r4eYvXTwWFfSNc2UXbW2x+ZHLD7tuRTp
         a7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771877320; x=1772482120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cOM9+OUamiPR6YXOi3oPvt96u1RovV72e28HWgHBK/o=;
        b=cfA1l0h0uqbwh1b3+50mJVXtPVFIwjQjtkSY0ufG5aO2b4aYE2ofF3PVGEIQUsiLcx
         ZVbkli42fNSdp9W932yfChaJuVx4se4LEiLkFGV/RVuE1JysC7it+BtgIP764xZRLEUa
         A9GfxJHUV4/S71P8RCx0Pnjvd3R7Z8HVZRvz/7bwid0/WBCD4PqpS1FBC/3b0tJTMpPl
         VYe6fav1fildAxY+jh+UYN2E9n/WkztvXLNrY+1SAQRyBwhn7rquaAkYX3gta1BrhOaR
         ELHAna0O7VJvYgHAq7CyYs/x0TdeHFPgvnikyNuxujPV6y/riX3Svi+HFUuOSJESHf6n
         4OQg==
X-Forwarded-Encrypted: i=1; AJvYcCWH/n+OL3YJXp2nm2JI3Wma6jhjSWh1P9kMNx8H/6zAdpECZaA7b6HPuR5j/0Gl9+78GGFaloCaxg==@kvack.org
X-Gm-Message-State: AOJu0YxeM5Z7p8yF4rOQPKjtCx434BnWsYaPhvqwpv38B59XNuW57ogx
	DKu7O8p4NDjLtH/5xyEDd/fNi3gdWxdz1woHvvxx6unOVOLB/88grU/9iVqcM/Wbt56qz3PUJVG
	tdNMttCVvFUbp6fN0z165gnfD4wapif8=
X-Gm-Gg: AZuq6aKBvy6IabrK+Y4pXMewmAPKvRCGV3DqJOaKmHLzbWb6WZ20PbbWGsUa2cZmyB2
	JxfVZ9Nlc+wcoWUXHry1sJA73ExcrvMx0Ap5jEB8lHdh2O1eiKm4zaoBMj3T2MaELCursh8x5E9
	sF6EqwdO57jbw5TtmMcwpDwlisqrIlCztS7eYYjVL/J3O13mXZ5tcBN4W3WMRt8vE2QMRpTBlXY
	TiYU+3/JYBTueEnrBs7PH9B7Q3nA/MI6/7xed+pG5gCvtUnC3bLXN6BYaLRPFl/IAt1W7tNCIzG
	evidXg==
X-Received: by 2002:ac8:5a06:0:b0:502:9e4c:266b with SMTP id
 d75a77b69052e-5070bc9afbdmr139058861cf.42.1771877319179; Mon, 23 Feb 2026
 12:08:39 -0800 (PST)
MIME-Version: 1.0
References: <20260221093918.1456187-1-vernon2gm@gmail.com> <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
 <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg> <658903fb-cf3a-43c3-b8c0-d47b63d10782@kernel.org>
In-Reply-To: <658903fb-cf3a-43c3-b8c0-d47b63d10782@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 24 Feb 2026 04:08:23 +0800
X-Gm-Features: AaiRm50CmhylFaqCTcB5lEm_OVn0msoPbo5rJOxFhTlVBg-bcqnOMUJgS7vm7Tw
Message-ID: <CAGsJ_4xwTDAs-=WETGxj=dUTrvu_1oYaXZOk-r_yzJ9p2tVOXQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bdz5mawnyx4b5438n4yd6inxcmhs3sg9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BE311C0006
X-HE-Tag: 1771877320-943836
X-HE-Meta: U2FsdGVkX19tocikp11J800G3JpKt20nWopSFbRaVFdRyAp5M7kgGJI6n/aM2O0U/uKhVr9OvY8xXHmuonXHlHeEdu/910KJwD12bziEq77wf1XLWY5B0ZL/qhwSYfDaiaPvB8s6d+BxkPvBgW9evy1t4pC46bBngGoj8pgPSlHQ9Zks6n+FlQKeq0SLAKuh6vNP6daWN++TbmFWwzTk11ycUS4w7XPIt3qRuI6MY6XCUBCV/VgBEgcTV0yCQpTf2Fvo8jAJgep3IUXM7qsdu45ee9gr3xHJ8sjsj+HjRhj8UgPp8EXZuLXrasc0DXvelwda40hc4IjeItkfkxR+i3Pm1tyxpMAS+f/LDWB1fAQ8U4KcESkSKO8SseKVH+PqAleWxY8AwvRlYJHcfE+cUyZXU2tEScv4yGnGS4Vcm1XO4jTCLTTPWjjOC/lsDcmJ9a89alAEq1YUWMPWFX+FOZzFrclDPE2recB6SYnISTVzkhT2nnOWkuBPyLhlrrhjYsfeazFDdwjajYIHn5LOJ4g1KiQ2Hk/m9ZQgjVc61xVJh0HGwF+tjOmgcSFVij8HIlKLKQRP//ya4hjqz+A0UaVOtq4bQkjWlKrq+5WytbdOU8/d1Hpl7GOGxkPn4s0h/oP63/twnLZlCs4kREx96sW7zZeQUwZtkSSmKho5p8aqbbzU+GsEz8TSY45k9cYNxeny5pB0YSH3YDcG0NJpxYQhM35BQxqQousRki/2KH4KyZHOi1JP3jRlUzsBDd0DUOhQWqv1DRp5L5RwVfam+CtokS0+ShCBkjWhXv7N7hzYP2Hn1YFBr6omrPdypYiWNNIbUH+ELo7qLskMIpGRWemlByNbwGcrF2y3XM/YhRqORAaX54jpbVn2a99tb+VNIfJwEJNKYHfL1JrMSNggp4nUnD0/CfgHpxm+qIZE3/gTHt3/fw4MBl7sztI75wOktx4pS6MM1c1SvSiXTCi
 /iI0keBf
 QQNTn4ep9QMeyupwtw9XHQ1RtoRYrSkTvBM1aPrpyCVAr2Y5Smn9wVkFkSTV6GUhHnw/7i1RH33tS+h3fXCOkEzwHSFBKI+O/PJZvMdt63/YoB7Z/sNUBZrlP7MEAtsfvgb5XduGO5pnFAVWfqr+rS0DFKQ10YlvBy2rc2U27w9PaTij67peMg2L3nVOMPvs/nmnyg92jn/+ba6CanSW2d/dm9qDMAquCHx/PPYxC+IbxO9vY1uw8xJfehouLZXvkwvNQ+QXrZxqM4ehyI6mgWFRYVJnrUENntmM0ezhHwl0rmjyDZGpjOXT+BAiIhgOJ3BiEsuG2IXnY/fUg/qFIt9Uvl3cHJ/M6vMAnxDfXgl20IBLmB1+T5N7OZ/0U1OTrcJPCaCZwWF4LVrwI6RmF1kRniEmp/F4Dcq05V/Z06jdr9lWEqQ51mQc0iNPwmWW1sixp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 9:16=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/21/26 14:38, Vernon Yang wrote:
> > On Sat, Feb 21, 2026 at 06:27:36PM +0800, Barry Song wrote:
> >> On Sat, Feb 21, 2026 at 5:40=E2=80=AFPM Vernon Yang <vernon2gm@gmail.c=
om> wrote:
> >>>
> >>> From: Vernon Yang <yanglincheng@kylinos.cn>
> >>>
> >>> For example, create three task: hot1 -> cold -> hot2. After all three
> >>> task are created, each allocate memory 128MB. the hot1/hot2 task
> >>> continuously access 128 MB memory, while the cold task only accesses
> >>> its memory briefly and then call madvise(MADV_FREE). However, khugepa=
ged
> >>> still prioritizes scanning the cold task and only scans the hot2 task
> >>> after completing the scan of the cold task.
> >>>
> >>> And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
> >>> that property, so we can just collapse and memory pressure in the fut=
ure
> >>
> >> I don=E2=80=99t think this is accurate. A VMA without VM_DROPPABLE
> >> can still have all folios marked as lazyfree. Therefore, having
> >> all folios lazyfree is not the reason why collapsing preserves
> >> the property.
> >
> > In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
> > attribute, which is the root reason why Collapsing maintains that prope=
rty.
> > The above commit log clearly states "all folios in VM_DROPPABLE are laz=
yfree"
> >                                                  ^^^^^^^^^^^^^^^
> > (the "if" is redundant and should be removed), not "all folios are lazy=
free".
>
>
> Exactly. folio_add_new_anon_rmap() makes sure that all folios (except
> the shared zero folios ;) ) in VM_DROPPABLE are lazyfree.
>
> In fact, MADV_FREE should be a NOP on VM_DROPPABLE, as
> folio_mark_lazyfree() doesn't do anything.
>

Maybe we could do something like the following?

diff --git a/mm/madvise.c b/mm/madvise.c
index c0370d9b4e23..173b0e5308b5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -817,6 +817,11 @@ static int madvise_free_single_vma(struct
madvise_behavior *madv_behavior)
        range.end =3D min(vma->vm_end, end_addr);
        if (range.end <=3D vma->vm_start)
                return -EINVAL;
+
+       /* All folios in the VM_DROPPABLE VMA are already lazyfree */
+       if (vma->vm_flags & VM_DROPPABLE)
+               return 0;
+
        mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
                                range.start, range.end);

Thanks
Barry

