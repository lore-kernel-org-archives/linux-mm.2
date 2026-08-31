Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D5CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCFB6B0096; Mon, 31 Aug 2026 07:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACFC6B0098; Mon, 31 Aug 2026 07:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CBE6B0099; Mon, 31 Aug 2026 07:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2F926B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:30:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 614B41C2033
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:30:54 +0000 (UTC)
X-FDA: 85161347628.16.56FE183
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77E6C1C000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:30:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n38HeTaj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B62KGiNz54kxYfvsaX6Te6uL5bqj9S2a+691iHGSfMM=;
	b=MhvgxXxP+bTNs8XOe1H79O+koF7dRbzAQnbHBFPLd7C/TpJAxswoAq23j8umcc61Fr0Z+K
	LGZhrJCHEYtTQ277DWAiHQuLTJx8Jqa9AwP3i1kxWD4fpkQpSmfTd4rqv/+Nv5PSDWvmiW
	QRj9XeH5iCmoC0pR19/4/1nYcr1xrLs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788175852;
	b=e8JNdDVJNd4sCbUFzpPZ5CFLF2nuGuOakcqzun4opXhf1Bhpda214SWz8s4BCXyHeHl9jS
	k0Kfy61PQuMhabH+w2LueTmo8xr6P0jGUrNcDZDQ2U1/l0A9Sz7wy9fzgsjzSbxB3gx/Wn
	eeERIq9kgNOHWSjeZzDs25/ki/egjio=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n38HeTaj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66e3d262d43so1035320d50.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788175851; cv=none;
        d=google.com; s=arc-20260327;
        b=Z49Hh03/Xcso+jRhA82J/hpXX6fH7FxiK5uxUo2RMv/hMu+8Omm7msB00XTG6Ws5Eu
         SVssFXwXpfUJyTre4pgEgLnDgX/QA+tN6VrmSQ02Msf1F+ImE8rjV9MQajOJyoQVWA/y
         R08g4amnK2AHRwIY3REHS2b/9RbMhcRI4sikPfrcYuA/fRXQVXjHpKKDFtxbHx2T1ZqU
         Bp5RN44pHysy78f0WeAugVx6yT6nlOLgShWzRIVEyybTeUCHdGiz4Phzod2yfgzTqJAs
         O/gDrSH/j343erO9lVfgeU8WeOiWc+oZq2i9fY1puE1fks4jjgz74DkHlrz4nChd2Plz
         K6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B62KGiNz54kxYfvsaX6Te6uL5bqj9S2a+691iHGSfMM=;
        fh=bSNMuemqiPzMljI29BpSGmk20/sD0hTOvQsSW8KUKxE=;
        b=bMXrOCYDm/I18LyatJiwK0rNOF16axrDyIoPQB2LurIxz8PsuxOEupHly+jXElKGFZ
         kK/NidqDHUJce6UZBc585ctN/buHlH+VBAEFiOY9/6JZNM+DI3nokVBtAxqmIUuPz/f3
         oWiDHy5rRxqO+JF+EbzYeKD0/EJQh4AQ1Y4AWZsyFLh0cq+Iu5nniJhc1Tnh53sOSSlu
         z5wq/6MKzGN3g9lLJT5MQr3GIr8P4tTfJAY1m5HAr3kzgB+2gpeJMHFYJkVQH8EAX9cw
         HXRz6Ibmt+tVnXzmaEJuJXUlXrNO+HdXpMvjYRcKwpYXe74hg5Lh54uOo6oupvdh7XPj
         ES1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788175851; x=1788780651; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B62KGiNz54kxYfvsaX6Te6uL5bqj9S2a+691iHGSfMM=;
        b=n38HeTaj2xR+dYdCR5KFvdU5YpT5tBgtwKvQGT0GXLeEo1v/7WfurpiMvzavww/p0/
         SIZGykoQxnLlurLMZOE0H/hvTdokQtqKEgnlILoVFXRao/w6QKAWsH1G9tKS0FNmiXLn
         wJY48CM91p36wI4riFp/tm+zanYg5ZzdBSCRH6Rc22zEbRhw6k7aFZUJwi8udF0G0vgB
         pJRr/ShEBlS0mL0/oghQlU/EN3uooYDO+Dd15jTWddBsUAcMdYUAivvqwME3Rmieu8KN
         +E3y7JS8FDHyq/t8kWYhdMB3Zha5HuioUipQ79SE5IvHoUyNUYfu4ftk+S11DnEe29jQ
         6eWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788175851; x=1788780651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B62KGiNz54kxYfvsaX6Te6uL5bqj9S2a+691iHGSfMM=;
        b=haEaZJ4/vFhsIJFQPackE0+aDxJxoe4zWQUYiajMC46EKNeQKryAteevSyHp//g71y
         YEThTeXgLyJb8Qg/gacwXAN1K6rSmW9nXwfSU9p3MiR228LBglRljPB6JFhXiJzocGC9
         nklpTThXHlENQigQfHLs110FVOQfZCpaiedjjO2MQBV9pf9BNDMqcqiTPmkgLyLyFuVE
         CdpWfSmtz0tfiUGjePvoEeeW64qLZDXsYDi5mPk7qQMy0Zg/Wm+Ov+cWSW3LdxA+qk1p
         FCrPEVZbW0kyrbqSbSr/XhFsE5NDf/+PxDBfjI+ixqUaS5mxtvkb55nChRotfssp11DL
         CIjA==
X-Forwarded-Encrypted: i=1; AKwUvByu3jBQgel5ii6ySXLbUDNl01KQbHkLuNQEmFFa7owqhj1gLRSfEnb4/BGNBYcmV3rZw4uCJr58Mw==@kvack.org
X-Gm-Message-State: AFuF++ksEUXV14WkGwrXGW1RezWBKaBPrQUh+QgEkScKuhPNYuCti6/e
	xU1eqrApNR/d6bEA0mr/weuTQsaJm3LhrjPA1hAbCAoSDJZGxD05jU5A0H8+WptqLC5EHlSVPSC
	GMFd5H1PgOaYmxKcM9uX+ZQW3Fk0cqUY=
X-Gm-Gg: AYBFou19svbYdHUg+2Kb3SrXdqzHFUgy6fHFbeLbwsVt7UrE35LFFY+A6SV87hXAIl4
	+FlYObEpcVLvu38+yI0IqbO62PpX2la++rAL2M7pqACm2ffI3qwRlUNX7ZktMZwfw2t8gnS1v7b
	CqFUY50u0OuFIBg580g14ljYANdPdShGi+ANnw4nz/tyheeHD23RmXuo5yhDHJ20/BBF7w9TxeO
	F+URv6qmm7eQMDYRrJ0fjTKLQJ5iZLqO968IFRhXSosVTS973qUM96TVinHrbhLozT49b0TerQ6
	ElKMyoDxzC4V8QhjNr7z2ieRj5joK9+x+64VsT39K04rxDXjYwf8
X-Received: by 2002:a05:690e:12c4:b0:66e:6486:e809 with SMTP id
 956f58d0204a3-66f87597547mr2148d50.30.1788175851291; Mon, 31 Aug 2026
 04:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260827144151.486192-1-ekffu200098@gmail.com> <178816183737.3691663.7482057515031348878.b4-review@b4>
In-Reply-To: <178816183737.3691663.7482057515031348878.b4-review@b4>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 31 Aug 2026 20:30:40 +0900
X-Gm-Features: AcwNN1Uqx3mPqCwuwqOkUz_hqxHT3iPOElbh9dodPcQG9GTSKkZdXkVBQFWRaI8
Message-ID: <CABFDxMHQjXUhbkUs_5Ki7Q6ZpQkF6Y-fDCS+LfxERFv09UgOrA@mail.gmail.com>
Subject: Re: [PATCH] mm/mm_init: remove zone_absent_pages_in_node()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77E6C1C000A
X-Stat-Signature: f4b7ro81ee8pj8me1utnzned96wu47ba
X-Rspam-User: 
X-HE-Tag: 1788175852-894170
X-HE-Meta: U2FsdGVkX1/hMlEqRMiZR8tZHKc5+Ww22UAqmAK2PhaufE9U7P+cTr7kc3pI7kzlbktl2VD6z9WXGcK8XxjFFmF5IQobNAyoSzP1w7eQcjzmw+zhhoxX0Nk8kL8FaL5tz9c/LzcAhv3y4w8vmfOq9l0hbqWNwxkv4c9vKREh7V+AqStOH4py+/Vq6fhi2Zuza6O3ouJMo0mxXtiXqFp9nvEZVQUM0Myy/t+s0nfY55zoZIVzt+P+oKfyDpmgs1W1OEvT9JqqIL8B6TbOEcO0jJfr1qW/sSgCg+Ph6hOR4YmAnSDL1pk13YJzvuFTlhqm4Ym9gGwbxGFeW8uCZeCnJnT3v7uietNvg1UGFEpqQjivbvhH45LAkzi8Uc3Nskk1eVu0I99lIr9Te1lvuFFLXoGYBVcruBWDVP5SxIrxC1PzotkI7v0qK6cZGXmIWuSWs0rt8AaNOmBi7lgmbmapDkwdkekX/4dcUGelo3FNBVFI1J+AR2XRROEuBhBLlVg+XvzVkauThOPAxt/1R8R0lleVtG0YiOnV8GHgq6ij17yF0yl106beJZqmGFXnZwzjjEEx93sthMXVlpYDGi9uW4QBJYEK7tKOZkvhv7z+yEdHXoqeO3Qv5WQOlDG31kKZnaxZ0tOfUFFNya2KhwXo0YyVXnX5VtV3w8CAG2idQ+NPlwuPe2IZW5beCQ4wDCG/Y/h0thcI2q34gzuXU0IrN4TCCg8X9EEJYFZHMRGDbytODtG6fHB3D8hGrovf6SeeFlGFJdymaedbzJ85hhFgiuZ3NTSgU0yysvUMoofy4OGYr+E8zDRRWGPd5ugJ13veyxwEBoe2wov/LbRsP3viWsZuWWPuicpTUpfBji8/AooMJrGmW0Knn6C4GrbP+8l4yQQodfxlWIYnJc/ZHY1RY8oCFHCvIla/urguoER5cPu4G0bm4blEmuzkZwUGkEtm9QwQ8MsZl/d3KoNQlEu
 IDJUhsnM
 fwxEOA57/dI7ujaXQs9qfpyopHVWYv/VgVSRYH+14Vrk7KzLJ7Cpu2LRCtWq7w6g5OCyK1Fs1ZrG1zbg2xXyDcZ5j3gfRalHbk49i9mhoXBiAlB7Zwjgq1LYCx5O+AMwiPbW765TY4jbZyhB5EeTVBjHRI555IqdjWPB0qIDV/YJEeHxmsEtDEAEO9RQ9yhpzFz0ycVSuVPjsUZQ6Feooe6AAw2qZKJLu4CF/opNqhAh5niQRV4dFqPDjAOSo086lEM7g0Tv6arrbyqyOertt1SNZISg1jM4q5htF7S1mgI1FpM7YG8vkphA51VbcFDLE90cZhr0WQAhUcthcAwR4UPsUeAdLEvKeYJgldWXAjqs/GG4TRYA8huhBpW8Glu/d3MNejYtrZdjYghN3E5EnigL1EG/OnGDUgSpTHAA4VetmK2mGBkGWTFMOjo+5pSY3FNbdV72DOjgVRTqchqzqUQ5+Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Aug 31, 2026 at 4:37=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> > zone_absent_pages_in_node() returns 0 when the zone is empty and
> > otherwise calls __absent_pages_in_range(), which already returns 0 for
> > an empty range.
>
> Right, but it loops over memblock memory for an empty zone to get that 0

Indeed. How about adding an early return in __absent_pages_in_range()
to avoid unnecessary iteration? I just want to remove the wrapper,
which never uses its zone_type argument since eb0e5b61369f
("mm/mm_init: don't overlap NORMAL and MOVABLE zones with
kernelcore=3Dmirror")

        unsigned long nr_absent =3D range_end_pfn - range_start_pfn;
        unsigned long start_pfn, end_pfn;
        int i;

+       if (!nr_absent)
+               return 0;
+
        for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
                start_pfn =3D clamp(start_pfn, range_start_pfn, range_end_p=
fn);
                end_pfn =3D clamp(end_pfn, range_start_pfn, range_end_pfn);

> --
> Sincerely yours,
> Mike.
>

