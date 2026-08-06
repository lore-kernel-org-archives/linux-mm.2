Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB864C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF4A6B008A; Thu,  6 Aug 2026 04:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96826B0092; Thu,  6 Aug 2026 04:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE596B00A2; Thu,  6 Aug 2026 04:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B02846B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:19:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48B56A06F6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:19:42 +0000 (UTC)
X-FDA: 85070145804.21.26EA9A3
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id B0E4A1C0004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:19:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iHI8hO+i;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy39CtWoc0zoje5YFx3qF8VnAfrlLSpF/ux3KEcnob8=;
	b=fdtXUNLPb96BpaA25eq04yq12kaoXypA7WZfrhi+NpsdNzGfnASN0rn6F1iPxx0jurWWPh
	KCavN7BdB3ArmTygnKjROye3E1uPcm3hAGzvEAg2bKthvlmQPjbVg5Fvxw1dSw3HZYV9hj
	cv2Zu8JTvA7BlJ24/zDl3klYsMKTc1U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iHI8hO+i;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786004380;
	b=CFl/IICfAF4kIFOGxxC8kYzh28pJ/6z4qhX5rXtlqzCkP4IMAEepbQTynjeNkwA4eta9Y2
	rw3BW2e+hDw4ZN0bNa6Mjl3g5Dws6Et+RrCPECxWWgoN/GVkPTT2M331w27eD2VtQjWMns
	lB+jDAgqTg95eFEyvuTPN02uqDHaO2o=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-446f87b6de1so1346917fac.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:19:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786004378; cv=none;
        d=google.com; s=arc-20260327;
        b=JbqEAkK52XNCxwfWwYKCa88th2N1MelUtRDi74IapVzF8+0z+BaGW8fmpXB62Pu+0k
         RulXOw1fTmBm9JRp/wkoESn/nuukS+V0YaYertH+O3f1yUU9ohec7bZMuV2Bwk9QoRkQ
         NqRxLYyIzH25oj6ASj0PRJYQdMa48Ph4nacp54eA7i9LlkjTKyqdsGm+K222DWV3Fc0/
         kwf1dy/R96M/ja26Di3/2UwjPyU/JsqurfrpzIkJv81StGzNOdFaBMquwodsUXoHEJQo
         HuDHZIfOze0A+16Wxw0w7u8RhjyO1kK8e7xm3RqkyZT+5H0G4e4lngWMfPfrXMWnhMVN
         kUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hy39CtWoc0zoje5YFx3qF8VnAfrlLSpF/ux3KEcnob8=;
        fh=uStR9HeO3MBUIBt9sbFQCZ+xc9sfdWVRppVfP3lp9Xo=;
        b=oH/tAUBgFtIJhAfGjJXgFr6usmab5wdWhmdG0VW29N8Th87SfnXJVAL2UhzTvQwIKi
         BJszrYI9IM1+jAPih6f4smLFKhfL52TsjadDj1U/HM5b60IX/Sw5HkQtU/z33TPfNz0s
         R3DEHzb1YTfltc43wcPdcMHVtt4FQH+tiu1INrAFsEdefrl6rZuOGoZc6y6DLmqTI//9
         OyUTtG3ga1z4gocD9czt56ZHjaaiK5dqDm6CEJDG61Tl03n4lOH1x4oEneF8UsLFfOOT
         oovqCQoyRGouSFG/GrUTO1npZ9lhRNbZ6VhuFiJga96WmfqE2mqFf4xM36WHTKn5ZWFR
         tMug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1786004378; x=1786609178; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hy39CtWoc0zoje5YFx3qF8VnAfrlLSpF/ux3KEcnob8=;
        b=iHI8hO+ioEODlfvrD1NXsabgeLkKAQ6p67hP1bL+F/5jvVkxiB+DIH6IIBZyiFybxL
         GCOyOiQmHJOqvuo25LBZgQfByv3TUX3cI2pjRauRK0sgER+cEc4KdrsRia+8viNasBJS
         /uKbkodPcYFcqOBjc/140ldbeQnPPSjI+1qeX+mlFdPFIyM0yhkSwII1J6XvwHagC8j8
         WmVWcyYXurIzaKi4DNPf5dbc+csBPDpiqR4LoDD10KDVXgwnJVDeVYXEjwBh44x28wsY
         4sauri5FB2R4uh1fXmaZgTQ3xcVrnMeTu5Atbhx3IlwA+LpEAgVLrEgwQIZyvve2vix/
         XL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004378; x=1786609178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hy39CtWoc0zoje5YFx3qF8VnAfrlLSpF/ux3KEcnob8=;
        b=l07qqKNl25NaZJA9xSHQk5xWZ/OAVYjfiFQuIF6wyU2xj3g81yFiljUQHk+ls8hbFO
         x0pB9BRSxQWEvS2SuvP/DbruHezahdlsKC0KB2tv/JVtKRmS8q7pcFksFXBnuK2QQydd
         oFn7F6clp27rGAoQbRZXf/hC6Fkr08GrUIps+LI3fvhxdj/qaBFY7gxLEZpW/ZN6KfHw
         +jOSCQ2FV8GvFvq89+cbPqJx9FFIrW9OOAPwhIvphwsyAJljOL/uT1atA7KOCy+M69rV
         c4zzRXA6CTICVAqE58SClTOzLxR/z08vHCGAT64wUk8WMecvhIiXUzz6xdqNNOohk8Bh
         O0IA==
X-Forwarded-Encrypted: i=1; AHgh+Rpbb9j2JCs0jXeKIYz4b6dkxlNrBeMeWyl0X9ecLF5mm/PXZpkaIPNEVFea+eDkxjDBhxE3KNqrow==@kvack.org
X-Gm-Message-State: AOJu0Yxfn2E4n01Rktb14NPW5JF0zruSVoLCPzF3I43aQMphry01sNAo
	MXH9dU/o3zMYJM5PfOr8JSbAPdHyo4kXF75QyZDeoPjrARjSbebTW42wOeSQw8LIPC1WuPH8aN1
	B2tymMs2q4tsRpo35MPKf4j8+JRA3trg84qnkJU7g0Q==
X-Gm-Gg: AR+sD12JZ9ufPred0/cabMznFp0+kI3H8lGBz1oCTA6pS2UW09WmaIEHZlLEIBJXh7g
	M6I7822d7X22I6Z/5Y0wO+6ZvnqUDPorba5z7nu8CJF8dfqnw9ThCEsi6+NIkNsCDUP4vEQh+99
	vTEa8ei4KKQI0QLUqZpp7wIFJ84BirLoNkhjxiykFBw0n7igpg7xpfFavOtopCDNJ/nD0LrG+o2
	rQHkicHaWPIJRWnjKYyjhwqBfl+8rqvhlMi28hWCLofv2JSQUmWErHb8njd+qUmsWSwlbFwip5U
	89gTmaJcoWdc/BulxJ6i/GtIOwmXESdhgoiJNYNYPFtssfc=
X-Received: by 2002:a05:6870:7196:b0:456:cdf2:ae66 with SMTP id
 586e51a60fabf-4599f106966mr6769705fac.20.1786004378386; Thu, 06 Aug 2026
 01:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260806055501.56761-1-cuiyunhui@bytedance.com> <20260805232941.e89e96269472ce5106967bda@linux-foundation.org>
In-Reply-To: <20260805232941.e89e96269472ce5106967bda@linux-foundation.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Thu, 6 Aug 2026 16:19:26 +0800
X-Gm-Features: AUfX_mwGgNJoKFTBh_OuUz7py1XbYGaSQo8O6U35_XIAe-5lSBoXE9Jh7Dvpc8Y
Message-ID: <CAEEQ3wngAf7Wse8=zfByvzuuZvvy3kD7gD+HJZjvHTOf1UBiiw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] mm/madvise: avoid skipping pages after
 splitting large folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, 00moses.alexander00@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n36mgd5jechyykfi9q39tj3596kn4hf6
X-Rspamd-Queue-Id: B0E4A1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786004379-723028
X-HE-Meta: U2FsdGVkX18usgTtOjPpJDiPk7Ns1A6V493zn68xAtUQrQ8F10Tm9JGqSInBYpUwVGSETqtyatY034HPheRqgoCUr0eBJQd5kI1Nou5zJq9OpogBzWxHHEJUELsJnmy0I4ofrxkdZf6lsufgEE7zG73tAiivTVzNsVKRo+Y84T12yS3RvWWigCqlkjm1frShydh0igHid7eGoOJQZjEtP66NQC8w7brXMS5xw22o+aFAjW6FaIIKpCh/KoBKD98S3Aw6GbLsOReZKczFLa+8KEXHRpcg0DXIEOu3ZfEfR3NZWe8G1+anWMvlJf5U0oUw5mANxKvks9wchNw9WyII75b+Unazob0TIQClklT5kWRwzbWT3Lva7lJuz4RcRvMOesycUPCl5mvSoHrRIHYyT5NbRP9dg7I4UMOLVzsoeT2eAr3yh8PqiZz57MZgUKSegEKXIWPIkm9xKRhhT8eD8OaLn4G5sy4C2+RT3MdIkUbITT1I+a++CcQYWQroBQIuyhy4ZYJ4bjXHrcoJC/lyl7OcniptPWY2YXHSlIItejzP8DdrY0/ewF0QOxWTIuiBovk75gg9mzXkG/A1IWixGLzzi0qUSRgdFgOMQED89UtvgebtClNj7hRDxw5ezVkiDvirgLDfmLBkr7FFjEVgRr9NOznyIdfqefTQw5IA2PCWBvYJl+1df5hOXqqh0N3xLatMQPXVFDAwMmZ8yGY4ywdEYopoPWE2c7QEjxtsAcrMciEIkjFelg5H4F8cTzPbNJSvXna6a0RGA0F1ZRaTFjsI1M0JZBrjZwkIL/1C8IRJ148M9sNMPA6+a976G/PJCg3jR5o+54ooP2Uekmm+Pvh38z2tlrSRccUCVSKn6gPOPnWaih6+3j9QnDVPcDQsUOxL9xZS4rSy0Dqu/I/T4Lx+/jsFQf/D3D72b3QKRn1aWw930T4KrXq3FDl6ci8JdfFikxHaf+TpAXoIax6
 P+7m2tJA
 ItkaauwxYvzOuJx0Wswgg5BhTywygD/bvPorvWlyqGSprZ9Tu23XUGDT4B9LkazhnpnmwrLYl5KEn6fQWuU9L3nkZc9LxyTH3rHZWxpMkTNqVmmgfDL2ZPE6SnVYns7P2tMdEhSWxzD3C6aEqPxqDcSaQy8I6+oqYJOBua//UYHncwlszn/Blf8UTfj6VWNgk77ulGym6l8RzXEGRovSh0/0gdFyahOkJY+iy+bXiR+1D7MN799ypipHUzISZ8zLLdj6smECxGUdAu0bOJ20CWagAPzb6lz6S1OOqIlKgrWtRURMGeiai/IRrGFMpcMY9L25lrraHZDtPgDRMDJKnnqVBf0QGNiOAn0b4bABTYk8as2T70vzRpnNSoMC9TYifYIR/Vj/bIWm47vxpi8yT80HfDry6UYJM25YC1SKYrHyGnjSclFl9n4T07A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Thu, Aug 6, 2026 at 2:29=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu,  6 Aug 2026 13:55:01 +0800 Yunhui Cui <cuiyunhui@bytedance.com> w=
rote:
>
> > madvise_inject_error() advances through the requested range using the
> > size of the page returned by get_user_pages_fast(). Saving the size
> > before error injection is required for hugetlb pages because successful
> > soft offlining can dissolve the source huge page.
> >
> > That stride is incorrect for non-hugetlb large folios in system memory.
> > The memory failure handlers split such a folio and handle only the base
> > page for the supplied PFN. Advancing by the pre-split folio size then
> > skips the remaining pages in the requested range while madvise() still
> > reports success.
> >
> > Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
> > folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
> > folios are handled as a whole.
>
> Thanks.
>
> > Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page ord=
er before page migration")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
>
> Should there be an Assisted-by: here?
>
> When fixing a bug, please always describe the userspace-visible runtime
> effects of that bug.  Especially when proposing a -stable backport.
>
>
> I asked Gemini this question and then pasted in your email.  It told me
> stuff, but I don't know if it's correct.  In this case it would be good
> to hear that description in your own words, please.
>
> And perhaps a means of reproducing the bug - clearly our selftests/
> coverage here is poor.

The issue can be reproduced with the softoffline helper from
avocado-misc-tests. With 64K mTHP enabled:
./softoffline -m private -n 50
the test consistently failed with:
pfn matches, softoffline failed at 10

After temporarily disabling 64K mTHP:
echo never > /sys/kernel/mm/transparent_hugepage/hugepages-64kB/enabled
./softoffline -m private -n 50
the test passed in five consecutive runs:
Softoffline succeeded!

Thanks,
Yunhui

