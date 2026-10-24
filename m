Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B863606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J7NC/nkJ
Received: by kanga.kvack.org (Postfix)
	id 96BE06B05B0; Sat, 24 Oct 2026 12:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D906B05B1; Sat, 24 Oct 2026 12:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AEB6B05B2; Sat, 24 Oct 2026 12:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 371896B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:10:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADC2D12042E
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:10:47 +0000 (UTC)
X-FDA: 85358008134.03.254F631
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id ADA76C0003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:10:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J7NC/nkJ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792858245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8lYg+fnY/scDiybaCmI8FMgC2eiB+AC2lyV0CyUaD4=;
	b=WtnycrOipVX9zktydfYFGJdEq+qItdFSs+YZWewl82fmsGU8YljKt/3fEBXkS6sdcoKTdY
	ftTQ4tJrGpJjTGJh2pBlke62TdNZb3HFzUZ5WilPr/d3v3SNZGh0sSPz0h3PwFvH+nrsRA
	UesNNMOV4u+Vgt+pOi++fNOQbxjAgto=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J7NC/nkJ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792858245;
	b=4OzXPjCH5j1oIcvLuz3zergI/igR3zrBeJZf+d+HLpeSsv03a5pMNoqmNiZxwffJiVMVry
	DUG8WMvT3l7zOiiL4W+LHYCfUwp36MyLXcQu8nGtkrTbQaUUOpedrt/thrYVzJ7T2TmavM
	TIh5RDtUP6+PWgLPoKUYjdL9muW6We4=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c43373ae89aso270827966b.3
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:10:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792858244; cv=none;
        d=google.com; s=arc-20260327;
        b=s4OqsRKrE4HzG01IxXdVTTVAFxKpSZTNxWo+1CIT1pBdC7cKc85k2eiV6mh3eo2cef
         +YdKxyE/gTjVQyrR2RHSx7qxQhgOLfuSoHt0oBFxXeT89sfMCc3raKcc0iJNJdNkBGZQ
         F3TogxgtMTZfXZAc1uUPAlmLYLxwEhon2jaWYWu1s5X/05s2fXGfj+ALTazlW0yjKmf0
         zaD0wPZLM3CJO40Ugkp8nbCM2Qfv2dnJZ4CaZX3z58gBWPXodsZhDbAqWAkR3DW9gXlj
         Cg6atZ03JMOJlUUDBd0lepWSNv3XzHNzzDpQcX594ZMXGQ1yP+omZxwVJOEYR8A4vhFn
         KB9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O8lYg+fnY/scDiybaCmI8FMgC2eiB+AC2lyV0CyUaD4=;
        fh=ofCL7Koe+SM4TQ2mGQQntPPsyfy3WakXQ2KBXwI/XTo=;
        b=UTuVs5bHWnI+7hsMPUhN0pwe4Y36WqpCHEVLnFjbvug32HyibkKlCyaAt/EZLcEBDj
         tROHMBC2DjSMRXDK0xluxZT33rerBA2BeuNuemfD0WJc8qL8S/lNvE07QzrmolBpdDkQ
         Oxazl2hgo9N2s8qDbLuVva1+DKjxXA8L1+ckzHlQTjJYAOnae5EKjqi+nEzfIVp23Bvh
         C/7lTSfSduQHfte0CU5TQzhq73m+TDDeeOC4+FYTaFAF7UhrrLrQzfhnEJ2TPSHMxaRB
         HTrg2Lo/KsWfNy+VYOWxGHzEsZet2jFQ4qhaxUKYO7CS3VJUT4qdXiY4y0nDy9Ztoy9k
         N4Lg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858244; x=1793463044; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O8lYg+fnY/scDiybaCmI8FMgC2eiB+AC2lyV0CyUaD4=;
        b=J7NC/nkJEszxXj5xs3H73v58wvPZ2bO20j7rhJ/DqlPwcY9wAOaaQ7T3nkTsNcd+xl
         9qLgRRJJ5+tmuoME4/bzs0utwGBy9qvc7yy4sRflxs5VSODjQTixNxAVvN6Oz+vVrlXA
         11G/fIoHpt10TV5o065Yr99koQanVTMN3MgsCNUiBV+sZ+FgEiBICvbYCo398CoyK+yl
         j9Nix3yBd64khW0xjKQ0XI3l7Eip+ObV4eSlYnTOhrJjRaG2GzJrmQkpHUE2qWGWHxdx
         rprU8YZXGsnN1sLKinyA0mJ/9/Sgt8xIA7t2O0L5yBiZynDUYmcdveSXXWeURluS/lxn
         4wOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858244; x=1793463044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O8lYg+fnY/scDiybaCmI8FMgC2eiB+AC2lyV0CyUaD4=;
        b=i0OhnpvOy0ngWPLAUb//CGm6ZsD3RSRKZYGj2f8KyNZB9LnmPRq3vgsVeLb4f3xGTs
         sVfLvgoZ+REGSHepTlAjA8z0FtstWIWzG88vMeRucZjMZA5X+m9od8js7fazkYij5jVK
         6PfHs3ahrHwPXphSUFXs1ymaXmirJyuR6BKTaB+NbJ7l+VrSpRtTyOMhvBRgl3kPC91t
         uG0oKrCl2wJjsajpYqvxFKGKojFsyv3klYzDUT32Jla4b2lpcSMHompnIFI2SbXSgytW
         Wy1YBfMjHB6Xke9mRtVB4V9UlMX+toy+PkxUMemw0SA60UnKpEn0Tfml4/Jx9us/2RFJ
         G96Q==
X-Forwarded-Encrypted: i=1; AKwUvBzODoIZD7LBLYpcv/D0NAa065v1gLl/S5btXqz8t6UuMafocZAb3eOm5Q8dpU5/bB4efQiycnRQTw==@kvack.org
X-Gm-Message-State: AFq9FYKS35Ln5Gd72TIqGyAzBw6x1WqwlKPOhXjvnvCtzu6/mONrCwr0
	H8LFK06gKb6qeBpc1u1yubZLfoLkoTU0envVsEXVED696/LModz36HpsEo/KPl6XffVoStg1MVE
	q1rMgnX92y+XL7ClLLHvdQcdTJc99JG4=
X-Gm-Gg: AYBFou3WGKra6acBMH8tV45sawxE1S28vXjCp5spYZB7a/L/UcZkgItxtd7GchChtOu
	/JEQkpqo9bQGnzB28ULNQxHx+Z2dZ7aMh6XGiQ8i6pqlr9vS0SUI1cjV+yLbOH/VIATXyLdFZhh
	3aWGAR7QGAu7iIvd58JSXR0AqcQm+a2EOs/pP3ATFH3hIINFsnpbYmmlKLPGulwgIiO6wrRivDC
	vffLojrNL+vshCi9RmysGh0C9oLZwfQEC44fQViuMD4haFCrRxtuNCwRxqO7pJYu/ir3nTx5BH/
	8zFf3ZZ05aqCIKG3gFe+odyIm/RECuCcfMkwjn7BV8cXMr1m8saoSwpyJAI0JnDTCUPyRovXCBU
	b6x4rouUQgqzDD8sbGJyFeWj6cpDRiz1nppz/8WgHgFzkIECazMUSAAGXUJkyFlzcGRwszg==
X-Received: by 2002:a17:906:c111:b0:c29:f5d5:5a97 with SMTP id
 a640c23a62f3a-c46bde8850amr239585766b.33.1792858243877; Sat, 24 Oct 2026
 09:10:43 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 00:10:07 +0800
X-Gm-Features: AclHuK_zKvVN-u_xkgLG7OpnDHiy6FM15-noft6nDg26HGMwK6XiyRffHviluFo
Message-ID: <CAMgjq7C6htO2bp21Bq-dU2feN2tXuxHaqgNcG5sD=u1bwbEuYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 00/14] mm: mglru: fix swappiness behavior
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, 
	baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, 
	lianux.mm@gmail.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, 
	rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, 
	ridong.chen@linux.dev, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADA76C0003
X-Stat-Signature: 5fe6uq75h1f5ubjtcwthn3unr965ezu4
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792858245-351272
X-HE-Meta: U2FsdGVkX1/KhdfFj/dFbBfKWixaWkNiI8TrQDE4lY6GN0qN6SoVk8hEO9PpH1zipfA02kLJJzdej0d9VvinQmW1l+bsgkcUVnenT8DE52GjICFtO2iSJAzspyQ278Gezts83NMx+KE8b8u7bCVpfT9hNpEdmmP+YfX9pAwaoemtW7RdqkEeUv0Yv4uBfDjejmDeum1w7PgHhKBEwh1mSjUx+8++6Kh6xXgy1F+aU1CXBaKO6EZj3QCjqrZxh46rbpOh/sz1bb7dhP9Rttyc0T2t45iz+oIFuS4Ei3+OG2J5SBtJC7h6TEyaedKaGIBfA4X82SeGCd8YN0M2bIpqHxiZHVRYnUq/rqpNz15ohSckrxFDCKmLaL7EAgmascwX09udCToeZA1MLR6T3brfJ7siROVMoVqZdf7ba3iXJka9L9MY54HT6GZgBV1Oj/3c3ox7jZWPhcubh7pVHRbvueUfvgqVsTP8aaETP9jVvTDCvlTL3oVGb0G3rQL0/VRccHH/GhP5wYnUmWKQqAwv4bpzRsJUZExxBZnv2DljyaDdFiObFYLaSaI94+EdMc1Fjy1H/D/4jnEXvnGyrhhhyRctVvA6cBdORWtllMLpo4/m5SyvTkToOBDSki1T0vO+Qjp4VdtHkdcJQx1ABGifr+atIUdY3RrPoOqE4p3NDoyN04CVA27QeUz9UED5by1aIQKUGNcg6SkGbefPc67vNicpq0NrEPERwdPlNyaPPa8sLXja+BeH9s/iMPXChGPnThk6h+Df3xC7redBqvjsGsSuKLp23gOiIadfFCr6Hbw2+T4hNk09F+Zg5hWZc4YNUIx9W5LSYi3dR9oDOUPwAlOucM9Zga/9k+Em6k3AToXwXyKYgLXVFJGEOAF1/oP0w4oYfrrAs1jSGc4+evNH9pPN6cmQZFyajxghtDQ0RIJ1+3fG23kixrGRYFuW0e2GkFD0K9iJpJNOrGPhTYq
 PWAUrZHt
 lQG1yps3/FlO5nCYLVaWLsiMqUCB3LHjgKMJcYLIeETrvEnNR6Bk7/9sumajmbh0o2sLr8Fot32EeY1ADl0u4ewCz2hryUHp3o26LHhV3QRBzbKlImw6NDrN75C6lk1NdQyjXQwAakrwvHLR5v9eJEnd12HWjJInWkAdXDwPhaQmoic3b6oNo164NLtKBINfDIfYw9wrwuKoP+6MECoeNLDrjchdhPDEp1nO3qcM7MJIY1ipA4hp7hjsGwl/9GmUEEP+dSlAVvu19xwL/a/d23sVgLJQeXAKV0BZindmeQ3KW31mBCVwRKOWq8n8JJPr9EK8bkGcy5akda/OhUUyg4E6c74MhpVnxXLNph4bMLma2/b8vFopnk60/7mtA7WEDk7rc9KNBXmc8cFVLxR7zHop1CGhG7HPRnAAPWa52F2hgt5DqpHmAnuTjBtR9Uo+FGO4gxZp46A+kB8TpgRbXcCHUwzu4YKQpbhGvA+kyhmkxooOvnxZjFjfS/bm0FRX9XZzs85IzpZ0ZadAFcZsT+MufdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Classic LRU respects swappiness, while MGLRU only partially honors it
> when selecting the scan type, resulting in a much smaller overall
> impact.
>
> For example, when building the kernel in a memcg limited to 1024 MB
> of memory, with swappiness=3D200, CLRU barely scans or reclaims file
> pages, while MGLRU still reclaims a significant number of them.
> Similarly, with swappiness=3D1, MGLRU does not reclaim as many file
> pages as expected for such an extreme swappiness value:
>
> pgsteal_file
> swappiness   CLRU          MGLRU(no patches)
> 1            5,894,538     756,589
> 36           799,998       497,282
> 71           548,331       415,612
> 106          407,012       383,814
> 141          253,737       354,249
> 176          189,003       347,805
> 200          0             346,078
>
> pgsteal_anon
> swappiness   CLRU          MGLRU(no patches)
> 1            3,962,404     2,768,654
> 36           2,830,250     2,976,260
> 71           3,121,386     3,142,954
> 106          3,521,720     3,382,383
> 141          3,504,471     2,970,859
> 176          3,592,335     3,163,130
> 200          14,095,617    3,209,132
>
> pgscan_file
> swappiness   CLRU          MGLRU(no patches)
> 1            10,270,808    886,997
> 36           1,010,341     569,036
> 71           656,136       490,972
> 106          460,326       436,042
> 141          295,184       403,132
> 176          235,147       390,358
> 200          0             398,363
>
> pgscan_anon
> swappiness   CLRU          MGLRU(no patches)
> 1            19,341,957    5,960,884
> 36           17,530,774    6,394,951
> 71           18,624,264    6,673,569
> 106          20,088,558    6,976,364
> 141          19,686,813    6,206,580
> 176          20,936,177    6,344,854
> 200          45,313,873    6,295,581
>
> refault_file
> swappiness   CLRU          MGLRU(no patches)
> 1            5,795,115     678,254
> 36           720,877       419,659
> 71           469,270       338,518
> 106          331,584       308,983
> 141          174,509       277,375
> 176          113,352       272,390
> 200          0             269,349
>
> refault_anon
> swappiness   CLRU          MGLRU(no patches)
> 1            738,618       578,308
> 36           451,410       665,723
> 71           514,961       657,870
> 106          633,161       786,893
> 141          648,640       662,673
> 176          668,779       708,969
> 200          4,816,312     672,514

Hi Barry,

Thanks for pushing this series forward!

One nit pick so far is the test data seems redundant with the one
below, maybe we can just keep one of them.

> This model also allows scanning and reclaiming from the two youngest
> generations, including the youngest generation itself. This can help
> resolve OOM situations[1] and reduce the need for aging.

Right, the OOM reproducer is demostrated here previously:
https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencen=
t.com/

That series is merged at V7:
https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@t=
encent.com/

The problem is largely eased as described, but it isn't 100% fixed at
that time. It will still go OOM with higher pressure. So before this
series, I could still see OOM after hundreds of loops. And problem is
gone after the fixing patch in this series. Unfortunately it's very
hard to reproduce and that reproducer is the best I have so far.

>
> Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
> 1=E2=80=938 (which also exists in mainline) and improves reclaim efficien=
cy.
>
> Patches 10-13 from Gaofei and Barry optimize aging based on folio
> distribution imbalance and improve reclaim behavior at extreme
> swappiness values such as 1 and 200.
>
> Patch 14 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.
>
> After the patchset, the results track CLRU across the full swappiness
> range (see table below), with more file scanning at low swappiness
> and more anon scanning at high swappiness.
>
> pgsteal_file
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            5,894,538     756,589       7,394,183
> 36           799,998       497,282       526,176
> 71           548,331       415,612       433,353
> 106          407,012       383,814       347,647
> 141          253,737       354,249       314,437
> 176          189,003       347,805       261,677
> 200          0             346,078       188
>
> pgsteal_anon
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            3,962,404     2,768,654     5,362,153
> 36           2,830,250     2,976,260     2,736,749
> 71           3,121,386     3,142,954     3,246,589
> 106          3,521,720     3,382,383     3,074,851
> 141          3,504,471     2,970,859     3,178,409
> 176          3,592,335     3,163,130     3,650,544
> 200          14,095,617    3,209,132     14,538,399
>
> pgscan_file
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            10,270,808    886,997       16,246,260
> 36           1,010,341     569,036       614,389
> 71           656,136       490,972       484,769
> 106          460,326       436,042       367,969
> 141          295,184       403,132       328,943
> 176          235,147       390,358       268,142
> 200          0             398,363       188
>
> pgscan_anon
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            19,341,957    5,960,884     7,646,122
> 36           17,530,774    6,394,951     5,914,405
> 71           18,624,264    6,673,569     7,167,762
> 106          20,088,558    6,976,364     7,821,921
> 141          19,686,813    6,206,580     8,495,970
> 176          20,936,177    6,344,854     10,585,375
> 200          45,313,873    6,295,581     30,313,342
>
> refault_file
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            5,795,115     678,254       7,315,064
> 36           720,877       419,659       448,199
> 71           469,270       338,518       355,269
> 106          331,584       308,983       270,736
> 141          174,509       277,375       237,643
> 176          113,352       272,390       184,908
> 200          0             269,349       102
>
> refault_anon
> swappiness   CLRU          MGLRU         MGLRU+patches
> 1            738,618       578,308       1,383,725
> 36           451,410       665,723       543,071
> 71           514,961       657,870       683,874
> 106          633,161       786,893       669,716
> 141          648,640       662,673       719,231
> 176          668,779       708,969       901,918
> 200          4,816,312     672,514       5,511,787

Right, that's really nice result. Do you have system time or
performance readings? BTW for the performance reading I think we can
focus on the 36 - 176 range. If a user asks for extreme bias towards
anon/file, they strongly favor reclaim priority over throughput, and
the behavior is arguable at that point.

