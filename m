Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4576DC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371D96B0095; Fri, 21 Aug 2026 06:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322F06B009D; Fri, 21 Aug 2026 06:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA476B009F; Fri, 21 Aug 2026 06:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E94006B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:20:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 072701A03EF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:20:14 +0000 (UTC)
X-FDA: 85124881548.06.89F6467
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8572B20007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:20:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=AY8QRAAQ;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBdWJ/Ft+65Mt1iUZsmGismhVTfwzquMzLyxhpkJVHI=;
	b=lgraguWfgtnhFvB9noUWFhJkiAEAkDI9EyiLGLcNVTB+CVHUXJMHQHtQRp2PvyJjtRpEih
	f+2BsyBNb5SbQy2ihc6NBxrpDFG+deJPnu3/iYPvo13eN3ofjqXeDTt5TW/LaE7Sa4EvS0
	dv3ciUuc/TfyPW+8mcw1SPJz5n3Kdtg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=AY8QRAAQ;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787307611;
	b=ulQ21FeYQ1hFlEu3DYczpwu8UKitVK3kbNv7jjME/riAer+IdiKT9w9KLbh8kmrEI7ANXD
	lsmJN/wOAeZVVNpZ4zcQrxE7OmAfLnOpSPMWPzq8TMq7NLE1YgE9H/Vqsc4AnFH/OMLQsT
	i9VCqkFk/ICRXkE1xUu9E2+ICWvS7t8=
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67L9Lfsn3797584
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=QBdWJ/Ft+65Mt1iUZsmGismhVTfwzquMzLyxh
	pkJVHI=; b=AY8QRAAQBt3F1TwqxdGj2SEJM9MTCpSIBbF3TexxVa++2bYp+H3KQ
	JYYYPe+an5BgU4pt8WGc28QbIX4RGseGlB7xDIiNnBgQ7AgjRSrzhMHynfH+cEOd
	FfoPnZMG2Xdl1t8Qoji/klDWSPr/6LSB2vIJxUuZG4w03M7SWVt23Nzv/R4jBVF7
	1B1O/O4jmXOixd+3gtnueAxZlnVlGk1vnxfQ7Ahb4Tr7j3myUs/vCRBQEK432CfA
	wU0eORmIE8UaK6aj+LofI2YjktV0Cec5ltvGQ/fxjY/v6XQEyBYhbvNGqquH8FO4
	1p5jkoEJA711vEsbXdBKnUAAk+/IsbyhQ==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g66uscys9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:20:09 -0700 (PDT)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69c20d1d150so766869a12.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787307608; cv=none;
        d=google.com; s=arc-20260327;
        b=fKfXKdLInWCvcV7XXC5jEcWv6TDIAhtx6rl0DrXOXmgNdCUHXbHsmgbmcUEuZTQf5e
         BeKcRNIDFGRiqFv5t74A1jE6Ycl6Bl4VdmH+XMOzKeu3e98h6XhtaCMb6zCCyPSzP4kU
         nQpXpod23vsV7Mx7iTZ5lrkM+CSXCVJKig+PsevBATYwe6AwyhFJME+w6v9vVZewrMsd
         fhg970xp3BSMMvqG1JfFFtTPfef3hTaBTca6qCOTpvu+mwX167W/exFuTzdYyaT0CkCg
         Y+949Kpucdsxp2zgKfJlhbfdDxOIfX4uNdeYqJWeErdB8Vvzc3O/jpdpe7IFoYeAFD3G
         Mo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=S0xQ/E8xpU6D6Yg6bGTT5qrnCBsTbsSONLggwCBJmUU=;
        fh=7qcBL5x4KoE3Vmi57ImBRzPTyguVl6LYAXm2KiCbE18=;
        b=i/DaPcoTnW1REktytwoXwwZzv1OgQ/gJsWVZ9O0mfL0QPQfJL/cVsZ/VwDW03kZFjA
         t7MjYmx/pCh4OrREvjYxWAp6kL0m/SCMrXAujutYUvd7t/seh+EQ8Pek+2rqjnzSockT
         vM+/PofdiZUt4bdrVPzGdRlWIqaqZEUtxyGvfKbI8Ag05kJAy6Aw6YOof26BGi3ukzod
         qVgBlhHduWe5nLAKRTBIeYvACUYDxOzdBXI0OFdDlOj6/BV3lNDSRaEwzKdQSMq+K0iz
         Ic2VKx/iwfCkRPP7k01CotYdS0+KTnGevsADfbIsCS49EpCBhcWR25PIz6vQ9tc9Qm33
         Vd6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787307608; x=1787912408;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S0xQ/E8xpU6D6Yg6bGTT5qrnCBsTbsSONLggwCBJmUU=;
        b=Zjyb+cTZ8bkBcDzljhrwn4sUps0ZPu737W2B+xBUuen0wQXTt1LtatvsK1uB+l1l5J
         anuaUCVrclH2Ik2lo1fH5Zs+JZJ/xN8oFpl3ntxrdr//b8w9qxPQD+FTsyqZIE2n0DX2
         BlAHbS7oLmdUqErcyas7Z7t/EYbj+qt1ia9DroKOBEBIfAfvTcBn9G1zdmDImr3HjvKW
         bCRCNf6r9fCA7RBzbqeRvbO38Db02Xavw11Grwwd+x8L+exlvAoBleaY1ROqHQ1pbPml
         WNLGjPuaGDMWCqyR17u0LYpdy+aZr64DW4uZUZ9lnBiWwlEPenN4A0vNJa7RJppyXVoS
         lvcA==
X-Forwarded-Encrypted: i=1; AHgh+RrvmGHoOzcbCpo7sJJjphvNRm4lDbhKrgdFoKrMHHYwsN81WIoGa+VsFzWwixySn7+Neguhw/hx7Q==@kvack.org
X-Gm-Message-State: AFuF++lavLuWWkN2y2a7PnI2DnkvOnJGtVOSEQ8GGuhrkKhTKRMqO5rO
	/XRU3iv2Bo0Ch5mpIwZGPNMvh7M+HYjrgYmeDFBeXnl1D7IZhs6SqZJVAAAdFZfSJF6BZwoWCpb
	anCNvruO99T/FKgVpR7fGqQNWqkOSy2kRJNklG5t+AIbV3dxnjmPHUfFWwf0C9uFyqyX5KE8H6e
	BCeM3T+YwHnjlm8ES7mgmcLXgLUw==
X-Gm-Gg: AR+sD10c5nua02T9lmaEejvKK53lowSPivuoSEZditCZff3gJwyYvdEHjrkTwX/Cz91
	EJ3k81DvXcE2e9tdwtKeVRcYWBB/cUg5043ThxVv/n61Ey9NoI/ZMytCeM9X31Hn/RyP2/BPwlE
	LdetbRjaNDfEk2ag+5ubiKNbf13QE4pBznftZrqZdNeZnnDmH2YXzVr5M1+isJ2i01aF1SwQ+kU
	Mi+0LQCmKWWJmNKKQ==
X-Received: by 2002:a05:6402:27d0:b0:6a0:9c84:ce0e with SMTP id 4fb4d7f45d1cf-6a42f20af9bmr5632589a12.14.1787307608375;
        Fri, 21 Aug 2026 03:20:08 -0700 (PDT)
X-Received: by 2002:a05:6402:27d0:b0:6a0:9c84:ce0e with SMTP id
 4fb4d7f45d1cf-6a42f20af9bmr5632490a12.14.1787307607878; Fri, 21 Aug 2026
 03:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260821093606.2231216-1-alex@ghiti.fr> <20260821093606.2231216-4-alex@ghiti.fr>
 <c6e1ffd9-def5-448b-ad2d-52dfca9685ef@kernel.org>
In-Reply-To: <c6e1ffd9-def5-448b-ad2d-52dfca9685ef@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 21 Aug 2026 12:19:56 +0200
X-Gm-Features: AcwNN1WyErUGIL8bE_9Kyz4TX-nUH-FFlKTN6PXU138KXn6g8_fDtZrgVb8lYJM
Message-ID: <CAEmasaV8tzcebVQNbV-UfBygPDbJPct6J_F-9kY8T9MxjRcjbw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm/zswap: preserve the workingset shadow across writeback
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA3NiBTYWx0ZWRfX/WkMxhi6sLfD
 CrEgT7++gpdkhubN5YqeDBK/UQzVp0Oo4WI0mvWdnJn2K7giUVus/0nKcQhQIknWYrSckrIyADa
 LcWqWVS90/E7/di4dvYrc8bEGh4SULUbIMNDB8rrabEvpF13ePzfbn75LAeyJDMoq6ko/w9I9N6
 s/rvn2E/gcAq5meUXsa1inBUoG1FxOH7PFk+0OoUMU9MrX+rRG2GK2GMT1/2hHpS/JQc7d2xsRH
 BVznmlGXqaBHm568J/JjJdL+4pnrOz8rnbacIVaUAmZZfHYLRNd9qKzGEuPZtg4IBdjroJm7oLs
 cMwPmQSRbeQ02JBxcDQ0IZmiJU1ELXqMC2FO/dYB6XwxLRS7zL+Tbl8MsOOn6oa4/qy9Yed8Okm
 PIpMjohr7efPVSAGbXIDt6SjpUAvGQKJQnSpw/SWfyHOT8g6DMht76WFJpnoGs1YElcednwDjJC
 aajxYN8AEjIKX8jBwhg==
X-Proofpoint-GUID: K9bFsqcByVsO6SCgWP_33RpqaBuReLya
X-Proofpoint-ORIG-GUID: K9bFsqcByVsO6SCgWP_33RpqaBuReLya
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA3NiBTYWx0ZWRfX291pX7TGbYMv
 0HFfO+nizZY8XYRSOmL26cqcnlv5mmXVVE4uQ7l449mTMlWfwUROCmKIYKWY5Wu0+da4OsUAeSc
 wjzsCCbrveMGtn7YaJ44TNxA58WpfeM=
X-Authority-Analysis: v=2.4 cv=D6h37PRj c=1 sm=1 tr=0 ts=6a882659 cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=uOQYcvKv8qPnW8Wm2wkA:9 a=QEXdDO2ut3YA:10
 a=1oAhN8tkTtOBK6_UvoHx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8572B20007
X-Stat-Signature: 3bg667yrtq7qmkx9i4tq38qupcf6zeay
X-Rspam-User: 
X-HE-Tag: 1787307611-505363
X-HE-Meta: U2FsdGVkX19ifpD+ab833F2jbYE4/iXoFjh5bS4Sb/9d5ztXS6s3SMW5uFb9Vz8rmff+3dFi0u7g2ZGaA9PiI2mZ8nRsqwSO54lHlwRwLY4GXa5A7nKNwNnA6dcuCPErkxFzyk5SLWSOmPyqCBYmHbr05UVEoQSDoQzLVVkTLgiodYq91YquTXHX5SiXH/IiBJA3lW0nk+wxxgYOroCwHUPyGy3P/zANc7tA9+Ig/HPsWAzDk/CxQUlHT72ppIgcXOKNf015PnR+YiVTAyxXBwT2iYGIvQDxfpKZYNrrZ9+xrLZ2VIWJD+pHWtj24j5kfh79ZJI6gWCDpUdl3FCF3qF7qsNR13GamIQSTqLGziLY1dNNYnQdKzDMA/Hh9e7aSqJT1fM4QXuI/zYIsKDCQ/TjgIE2rMomNLw5+SkaPP71C+W0Bve9/E9xayMwhV53kQkq7BJLFXw5iQY6GJbezQF/2ggNNcDAQefkcug+vlODoRPukqHu4k+X7GVlU53aUcxQdzd9g0xdFwyqRMSepLWnPOzObu3dp/YqupIKPmfJeyYoDUwB16o/AAOjU8OdxHS6pxGri2vn/ujmOETpGz7jCXgAACVVlgDQt6JS1Sdc8X2/BQFPuzu0uouDNkydFNUaWJpXzHbH8rtT3dgZufroPeMuWMnQsmLKEd2gxh7PbLCdiMBnsoDFgWSTzUotSIAQYw8E/E0VjvRYHrfujCqr862h+NNGuuEYJsGpZW8fENhibvQX8vWUXnSVnbO1sdlPtCGPvM7wVCoN5qm0mv3BfzbROvZDkZE9qx7ZtaY80BREPKAuLxB8Zm1SpAupAoQPuKUhYEJ63tKyrE/ULhgojo2CIFTxR/FY7l9w4wi3uC4fhGhy6N4Tp4tSSRxwifUH4D3SBE88lecHP0D5CxNoXBTVXKudUHiHRvFq1heczyGH51UN1OtLc9ZP8ufVghglGTIAtEOB8tm61Zo
 nPG2+4OL
 CqmLgCzPiLZ9c/7cQMeDX0tw/lIJ+1QPwlEFrWvkDW+8QolFfgxC2tKh9pWywasIDF1VdB8QzyKWJ5JRKFLZ7/BPs1fWW/IsKmgTGCIYxJETuiZsx3YAXvrCoxkGZcCzpzgILAB4dVRJOZEXIJwng5zxF2LYscyF87JsR0VKdtuBP7cg9oSpSjnKqazwl42tsdF09+k4pGRDowWlK60/7rCOrHu4kYBIXRlnsTfjdPz1RrnmZoqEj4DvfaUGqBv1+bCFMZjxq3Ad9jxDoK7QyBPobv2uGsYuf2EKmodO8I0Nw9nMu/c2kj0AyPTfewb8aI5+Iy0wROxLZ1vF2/jxa7QGZHgJVfNCrKyJFR4JMv1O+nbapbptqo1t+BDYS3q+5S50GsOb8vNNPmv2BpifN2LQIfqiUyVMqwQFhDs+ImCwOQpSe5GEPVAruiCQ2JxWRldhtUpqq5+em0uepn39BAUft6Qzg5l3UPDIhLh//O/Cck/kI8OLLZXUUbFbrug/7KLXy63tfG8sQLNik0LHox08YpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Fri, Aug 21, 2026 at 11:58=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >
> On 8/21/26 11:35, Alexandre Ghiti wrote:
> > When zswap writes an entry back, allocating the buffer folio in the swap
> > cache overwrites the swap slot's workingset shadow. It is lost and later
> > re-minted inaccurately, which corrupts anon refault/workingset accounti=
ng
> > for the written-back data.
> >
> > Preserve it within zswap itself: at writeback, park the shadow in the
> > zswap tree in place of the freed entry, so it outlives the writeback
> > buffer folio. The buffer then meets one of three fates, and the parked
> > shadow is handled at whichever happens first:
> >
> >  - swap-in: do_swap_page()/shmem_swapin_folio() find the buffer in the =
swap
> >    cache, take the shadow and feed it to workingset_refault() to account
> >    the refault of the now-resident folio, then drop it.
> >  - reclaim: __remove_mapping() skips minting a fresh shadow for the buf=
fer
> >    (minting would double-count the eviction) and
> >    __swap_cache_do_del_folio() restores the parked shadow into the slot=
, so
> >    a later disk swap-in still refaults against the original eviction.
> >  - slot free (e.g. process exit): the shadow is not needed and is clear=
ed.
> >
> > The last two both go through __swap_cache_do_del_folio(), the single po=
int
> > every swap-cache removal passes through, which is why the shadow is read
> > and cleared there.
> >
> > Fixes: aae466b0052e ("mm/swap: implement workingset detection for anony=
mous LRU")
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  include/linux/swap.h  |  2 +-
> >  include/linux/zswap.h | 12 ++++++
> >  mm/filemap.c          |  2 +-
> >  mm/memory.c           |  5 +++
> >  mm/shmem.c            |  5 +++
> >  mm/swap_state.c       | 14 ++++++-
> >  mm/vmscan.c           |  4 +-
> >  mm/workingset.c       | 16 ++++++--
> >  mm/zswap.c            | 91 ++++++++++++++++++++++++++++++++++++++++++-
> >  9 files changed, 142 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 6d72778e6cc3..ef9b1612ac12 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -298,7 +298,7 @@ bool workingset_test_recent(void *shadow, bool file=
, bool *workingset,
> >                               bool flush);
> >  void workingset_age_nonresident(struct lruvec *lruvec, unsigned long n=
r_pages);
> >  void *workingset_eviction(struct folio *folio, struct mem_cgroup *targ=
et_memcg);
> > -void workingset_refault(struct folio *folio, void *shadow);
> > +void workingset_refault(struct folio *folio, void *shadow, bool lru_ma=
naged);
>
> Passing booleans makes calling code hard to read. It's preferable to eith=
er use
>
> (a) Dedicated flags; only makes sense if there are really more flags expe=
cted
>
> (b) Having helpfer functions that spell it out for calling code
>
> workingset_refault_lru_managed
> workingset_refault
>
> workingset_refault_lru
> workingset_refault_nonlru
>
> Or something like that, which makes calling code easier to get.

Ok, I'll see which of (a) or (b) is less intrusive.

Thanks,

Alex

>
> --
> Cheers,
>
> David
>

