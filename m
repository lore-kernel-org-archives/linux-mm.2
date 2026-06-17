Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3EFCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B084A6B0005; Wed, 17 Jun 2026 14:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9626B0088; Wed, 17 Jun 2026 14:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A79C6B008C; Wed, 17 Jun 2026 14:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68AC66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:12:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8D6EA0548
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:12:26 +0000 (UTC)
X-FDA: 84890199492.30.852958F
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4B2AB100009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:12:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=oEtvE0Gz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of "prvs=46286f5251=riel@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46286f5251=riel@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781719944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os89ZtOb3i8ANDce0+qevNQ0MTW9lrr15bM14PRyjeE=;
	b=7bQS5Ja+UpzE2OkxWsF2XE9Z/98gUxckateKe63T1RG5wbyX6uXUhPxA9wKy5YsoZhFTBC
	TvK8cIgCln6YmcoUHFb+/S5nfxGjdpjfSkkqjze2E6TLVKVTIYeX1fPt2bX5yD/RPwtKSH
	lwyCzY/zT3aegxFyp5ABQlROG3JRRUU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=oEtvE0Gz;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of "prvs=46286f5251=riel@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46286f5251=riel@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781719944;
	b=gyq7MY5fo3HzDYkqqutBHXuusH5NzKPE98lGOAoVy9JICaEJowqYsQ4ElgWOGbn53QLI5s
	PuPqg0WK4wtB5zStEOlsteWGJ+rkDYnYVrpP2wEV1Wf87M0WMuenuXw7YzGta3PFyYBbrm
	sHeWOWuxxaN5K36KZGN5ZGS9H74Gr20=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HHdQ44469758
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:12:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Os89ZtOb3i8ANDce0+qe
	vNQ0MTW9lrr15bM14PRyjeE=; b=oEtvE0Gz1CmQqNqnfJ2zXnRCU5SCxJ+MaD+H
	n86g5Y7ga3ED+ZUa+IKl2Xk4Dutzfo5VsIPrCpJXUdKRcahMwfTgRLpOYjx6MzVC
	uVAcZRqDQ1Q/r/ntht4jUN9OLfrd1GnY2A+Xh1m5CKNLasTcksZTyU2MdUC522zq
	+lcthGVG0pxON+q8EDmxVG3GBZqA9D8p3owMVM7/2tASvuaxqukeSXppbbUAvKe6
	r/xc3B1+RrM6fu+n6NUeZw2TO0dYy0PibArn4Ey3/Lb1n9PIs2fOfjld6qU28Lh/
	NjXfgE+IXM4lhKb7kWTEo0Jdjl3wmtMqFwjmRQG2Y3o7shIBlg==
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com [74.125.224.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4euegy67jg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:12:22 -0700 (PDT)
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6605694a059so177952d50.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:12:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781719942; cv=none;
        d=google.com; s=arc-20240605;
        b=XJn+uxElDsuo9sVOiCeMcoUOidl291v1JVleYXg7DCeuk3pSyDRRPCcMiTrmv7EQcv
         vPcorVmwA472wgnGr0f03VQsy8mqdH1+47TaImT25cdhCp+xbLS7z3SMPn9r97G8XuIQ
         YCsrVN6WlNuP+sUULMNYPaq25SdG3/aR+LCDKF+bOM1L1q5tqClcILAbBigztTEQA0Xa
         jPUyX7dx038OPIBjF8z8wvdI7oFJLK/3uYqULdFQXcle4eV4oDREPd7hkjxo9YcOTpFb
         AiuUpWjGQ1FkHq+odpeClu08SCYgND63itTmRYrFTna4LlW57IYOOSjqNNNKUEm7wQbU
         h+gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=Os89ZtOb3i8ANDce0+qevNQ0MTW9lrr15bM14PRyjeE=;
        fh=65eGAbq3XtO6fmX+hgoKfFcJgu1r/d00kT8kOn3yfwE=;
        b=IhK8zxxSTf5ougiT5JBQgXDi8uTv8kwF4jzMk8zVMO9pq3agqNgxPuRm9D7/lnBTEV
         WjgrHhNlNdZe1gfhLPZSPgrpLgDCcT64HCyRiSz+O7P3N1KHsR8hTd8pXZjAOSZ2PMmY
         kkSWLzoQQGs+GPRJee98lDopAokpT+ZfN1dvzgwtRnP15uZLVBeZ4pmAtbcjV+W2xRkl
         4caEDT+62XtJJXq0NlP8A3gpPJXp8ZCLqL4aISXWfQo61U7P94iZjwyVzNM7KCZLYRKH
         B4zbeuNyY0F6mNNc/lZr3FEqXwCPNYhH3xifpu/5UFqPhTTmBrSsztJ1xP6c4l6UVGZN
         fucw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781719942; x=1782324742;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Os89ZtOb3i8ANDce0+qevNQ0MTW9lrr15bM14PRyjeE=;
        b=ihEi/T4T78E27gdtL4W4BoXfTnHEEitecN0y1x5jxk3ISA3aXIc4niOq89CrEsjx/B
         CkS1owgOPugdda6qEninofjjybuz+HQDcdi/KsrEZ0w8SYovwxNVtTwjWBsMfRP2Qcfi
         4+zFWezTDNbqeI43TjwShde9tLzvYq+LW7ddxyZ+MbaIijFfjP70+Vo6YNeYXZeAs8UZ
         Ta30/ikrF4emtBshYVIXdIWvI1SVIEtlawNHbwdp4lRGfrgecJ8UdXfnkQy9Ta4NWPxz
         i6ainyz5SnOti4ZZz+Uqj7bF9iGc0hqLnMA7I8B/ZN1w/NsAE4hHFUmmIHow9KTKVRr1
         IDVA==
X-Forwarded-Encrypted: i=1; AFNElJ9e+CSvTSnqmPTR0NM5/j0c5VXITmH3En06hYp1r0802NQcQ5R7vuCMuvdveB0rV4O7t4fmlBXa8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx9/zpMqguRadqXpt/5K2P7TyQlzHILgH3T3emx7PDK5q3dsV+l
	8CwQbj5OI8TqnRI0zlRxmols3PDw3D1wlpgVbzozHYuybLpjRe3XoxFHpK2EFvcksctW/pT0Six
	jjPyH4n8H7pbnop/env5hFle5gZngOg+zfqP95XLpnYBOX2dVdDTnr9QylpJ6DzBuv5/HyIIXW4
	9dPpfISspZMxjujpGn8Cg2w049uQ==
X-Gm-Gg: AfdE7cmaanhc+BZ3rUf/cqYPvVlTsPxGg5wGg/PXwpde0dspq+qsFhdcCRcDJ7+wZbf
	ZyetaBxbSlhoANwo2HNDPA95lttXc1FUs09MtJRswmKUX0R11VgntHiNIbwV3gk8LGOfCsumZDe
	o3SVptOGiyRMnS0d3IdIoB1laA7Td1tgWQZ4po+8b3+sWCDW+3a6hkbwZuxC99/eB4GJY+Z2k1O
	g0WlKEUYXw=
X-Received: by 2002:a53:c749:0:b0:660:5e16:f249 with SMTP id 956f58d0204a3-662cb92ca6emr3629029d50.11.1781719942097;
        Wed, 17 Jun 2026 11:12:22 -0700 (PDT)
X-Received: by 2002:a53:c749:0:b0:660:5e16:f249 with SMTP id
 956f58d0204a3-662cb92ca6emr3629002d50.11.1781719941672; Wed, 17 Jun 2026
 11:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260616145413.1491961-1-riel@surriel.com> <ajFrxhGf7loEHUeX@casper.infradead.org>
 <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com> <ajID7ZpnBYOucAVz@casper.infradead.org>
 <CAPkx9x3BV3vMh8d8P36wCEOYRshRobT1G0Q9v4h1OABj1ffS=A@mail.gmail.com> <ajLh_pdGl5xea5dM@casper.infradead.org>
In-Reply-To: <ajLh_pdGl5xea5dM@casper.infradead.org>
From: Rik van Riel <riel@meta.com>
Date: Wed, 17 Jun 2026 14:12:08 -0400
X-Gm-Features: AVVi8CdQDcAAfVFSg7jBeIfKVMo6ChKJqefPoY0asEsXauJoYtQ9Bcd79JfwUus
Message-ID: <CAPkx9x2KTYgTBPrJ1nXuSaeeWf0bS_79bOeGe6kYA16=A1HPGg@mail.gmail.com>
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed collapse_file()
To: Matthew Wilcox <willy@infradead.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, Rik van Riel <riel@surriel.com>,
        ziy@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Hugh Dickins <hughd@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="0000000000003681af065477006d"
X-Authority-Analysis: v=2.4 cv=ObWoyBTY c=1 sm=1 tr=0 ts=6a32e386 cx=c_pps
 a=J+5FMm3BkXb42VdG8aMU9w==:117 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22 a=JfrnYn6hAAAA:8
 a=LX6sHTniJhZue10ILgsA:9 a=QEXdDO2ut3YA:10 a=YJPP8TRMgpCOOec8AE0A:9
 a=60EV_NHLd_k5TyBZ:21 a=lqcHg5cX4UMA:10 a=Epx66wHExT0cjJnnR-oj:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE3NSBTYWx0ZWRfX4gFafzb+6q+B
 tSQm+CdNnRAgcQyBfofXK+WgvlrSzchg1Pddjy85KbKRqSIyz703QpMX71XAlsQYDBkJMcQ4rxN
 5omv6vh91Gzg65h5KexOtUvaJkQJOJFEepcpRyxe2IP2plh9lBw65pHEEKRksyDiILxs216iB3V
 eCxRwEXdINlDWf6GkzqfU6ntsEZKqvY9S7DReUr2qCgPqgTfWYI9FBKUhO+6lCVHpPwI19Io8t1
 BycPCmXJ+ociEj9ILVMMiRFpIZoNSZ4aKoYO+qideCLr+FRMnpWPJVernBdPW/PiBcxsRWMPgVQ
 WpxnGhVPxtg7baLJO6wM4yUpMsowtm79J0Pjke5v3a3Ssdx3DFJ4wfJWC/yTWTXX/8AO4/NMwvQ
 DU5yFAQ7LKeo4wz93gxH9Hji4UVo7PGnJguTl0dztLow5n5K1BSdqjBHHb0QGwHGfnjmI5CIetb
 yGiJ/H81xM5BizN0mgA==
X-Proofpoint-ORIG-GUID: IM38_hgqa2oILHz1kOwORPv9KfaRarf-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE3NSBTYWx0ZWRfX8+5h3QhRRvaV
 RdDS86ZCcieVo36cWK6xAANekjsYCwoXZDWjBwJh6pFgRtsgu6dSI+VsRQ9eX6Yz34HyAkJHWLu
 q1OX+gCMdUd0Bq3Tkmt0SBMvl3geySQ=
X-Proofpoint-GUID: IM38_hgqa2oILHz1kOwORPv9KfaRarf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B2AB100009
X-Stat-Signature: bbarrfzpjnj37qgwzmg5ggk1oa34mgj9
X-Rspam-User: 
X-HE-Tag: 1781719944-896207
X-HE-Meta: U2FsdGVkX1+OQC2MKcisyck9yaSh+34efmBNR30iczoKH8tKnsRxmIl+chORIU0rofo9hgFvIBwR9nnuUQNYIzPI+sZ4p+tcosEYUQ0U3s6ojzd4tRt9brMJ4yvP4QUtRTZXl34gYqS1oPBP1osPVQrgvd1ow2zQqQfE4kbA0Z4vZw87lqewNI2cder3HrRufK2DF6wBK4mtptZQJvYkYjkayr8Y7sFmYboSo2busk0xIrwrql2NcYExfovsBmyxrCzfpQGoSpTDbjt2UYdkEPCbP00FLjuVeUDjqOeFdanBcqfCgbrlbSdQFE5tprIKMtW6cz1KhZkECvsK9rHhkh82Dr1cc7FFa+5JE89OkEjIUURl8QBo/16z+7IUlUNJ835XTDqT9ilcz3++rzGRVJZmlvdAqyWel/IIGHKVWJejW+lHnyzrANq/azZ5bUsB4OebB1Vj2qAWCOHLfwOvvSiKwqaVoieujKuBjE7W/oMlBjnVZY1AeDTtE67P0bjf0AG4kqNY5IFztiCl6gD5pM6qoC0D1ke6cWfBkVv6qByeowjpdhgytOtSn7hggENANlL4jaUmBcwZQlqncbEBpF/5k0j1gO2QgTu58DZTb6fGlLPokFMApB8yM9c4GQWw1Ith/zTE4BDJUJ1CKMaNO3RLN75Yu2uwL830HJzm5iglftjF44BmHHFv5z1V+XSzLHl++qJByjE3ZZ/8zRowRqTbN23gYkd1ZyCS16JZapKa0NwcHviE7v2oUv8oHtyc1EDqoNLVLiBnKMxn4uijdYpB8DS/gM6MiOEUPKdoBslscIn4zh+/ah8DIvpOrmVyGNTfTUVGQuwCu05QcJSHa1RjmhSoNGYrbkkc/NuW7LCYxIRTamWoUbFOCs/vWIsnrn1GlBjmaLlqRybYkACS2zWlwNhlp1iegfrH2c5uaaeuWO8q30YTjhBFIUnmXQwZpTVkLUmtEtGrgz7FCND
 gSPCUbr0
 prWi9jTSziPJiqNfsNsj2Qbpn3gUuu9o6a0R0Sot+TVJDey4jey09eeiog4NYYlgz7S4IorZN1Rj+kyUzD8sXvg/Z+9Bs1lJSFyGen3A8RVJ0GKTQ3WRPOJ0LqH5fRJZw1pvgfK/Cr0MDtSgjTI/CAWYn+JF6WSXYdQ2hzv1/deY0Ma9x1G2g6HUdB6yIiQDH+zXThP/qhbvB1T9SfvMtC00SzHFaCJ/dZrow0NsdAQLChhhUCnGPGfe9peGyVSf1z1H7jlDH8CxOQWO4+7yNJswX/EdcajYzDYPKAiLHHMYqsXTRC/cCe8PkzlmkrOPS8ZQKQ4U/fljZZMsWdNeMO5JExgUmKYeEdPtpwt1XtOTabHEgqScWQANYW+EOZ83YFDV8rJ/nH/47fIftk7Lm4yA9CExpp7eRSFFLhsxAc+uirDWIa7O2iv/AVrAAb2M2jWdEf6BSgjK93YX49PyxzzqI4sn7HMPR1xjhje/jN98vFbhsb+mEhDf5c+PAfvRBD07n4wLRPMRqZxZbzNvh8QVp2WJKF9H4YxvSSXrsC/XXroE3YuORTa+VTMa4GUtV5iUHVXdX+lufzuPfJrg5qF4537sz7YjBHHINlEMGsf5XK2UGLeo/VS/HNphfN8i7o322LuAE5sm9Y/z9HvxPy5QZiyRoq4v+GG+otKHDyveegNYwRJfQz3SepCmgkWNmcsjPg8t2AelcGwIeRxmK+BihoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003681af065477006d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 2:05=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:

> On Wed, Jun 17, 2026 at 11:40:28AM -0400, Rik van Riel wrote:

> > If there is no harm in leaving this xarray node hang around until
> > clear_inode() time, I agree we do not need this patch.
> >
> > Are there no issues with large folios getting inserted into the
> > xarray at a later time, after zapping little ones, and leaving
> > the empty xarray node dangling?
>
> That's not an issue.  The code which handles this is in
> __filemap_add_folio().  just do xas_store() which will overwrite the
nodes.  That calls
> xas_free_nodes() on any nodes which are overwritten.

Oh perfect. Lets just drop this patch, then.

--0000000000003681af065477006d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Wed, Jun 17, 2026 at 2:05=E2=80=AFPM Matthew Wi=
lcox &lt;<a href=3D"mailto:willy@infradead.org">willy@infradead.org</a>&gt;=
 wrote:<br><br>&gt; On Wed, Jun 17, 2026 at 11:40:28AM -0400, Rik van Riel =
wrote:<br><br>&gt; &gt; If there is no harm in leaving this xarray node han=
g around until<br>&gt; &gt; clear_inode() time, I agree we do not need this=
 patch.<br>&gt; &gt;<br>&gt; &gt; Are there no issues with large folios get=
ting inserted into the<br>&gt; &gt; xarray at a later time, after zapping l=
ittle ones, and leaving<br>&gt; &gt; the empty xarray node dangling?<br>&gt=
;<br>&gt; That&#39;s not an issue.=C2=A0 The code which handles this is in<=
br>&gt; __filemap_add_folio().=C2=A0=C2=A0<span style=3D"background-color:t=
ransparent">just do xas_store() which will overwrite the nodes.=C2=A0 That =
calls</span><div>&gt; xas_free_nodes() on any nodes which are overwritten.<=
/div><div><br></div><div>Oh perfect. Lets just drop this patch, then.</div>=
</div>

--0000000000003681af065477006d--

