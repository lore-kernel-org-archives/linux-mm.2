Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00423C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2066B0088; Fri, 28 Aug 2026 12:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993026B008A; Fri, 28 Aug 2026 12:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880876B008C; Fri, 28 Aug 2026 12:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62CF66B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:46:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1B20140499
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:46:55 +0000 (UTC)
X-FDA: 85151257590.12.ECB8D29
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id F09E618000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:46:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=HtfXXF8h;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf24.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.214.173 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787935614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBVClgdpKmfnkM4Cu3SaLQRKw2oS/EQYOdlTnpUMlbs=;
	b=1jJxuJmx8/HvK52+aO6gyi0z586ID5tVHMgC+XRmjiaTEU1OaAPy6ubv+uElFWJlhpwYbp
	GbFOJU+TzFSw2qJuk5/BUdxUd7I5l3yTmSG8eAYwm6jkvfXtBIx93dVuFi4HjOEJ6TR8GH
	Eo9QA2zKM27jrP/049yELKy44eNIRH8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=HtfXXF8h;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf24.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.214.173 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787935614;
	b=fmBxzWgKvN5bDfiqWWTULIiUxCwyAh1gMxJQDWZsrfMBW/jFm2ZN7J40Gt2JeXeqMprTTu
	OUgL7KCJPh4UA1R0Ke1KpoGoNwLmbksFeFo+fQouvSa/8wE/HMl8BT0nuZNpBnpy95JfS9
	2RQpDNbKhRCnCsulv306nEb+dSKvsYk=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d58efc7356so12431145ad.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1787935613; x=1788540413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pBVClgdpKmfnkM4Cu3SaLQRKw2oS/EQYOdlTnpUMlbs=;
        b=HtfXXF8hgRsZUsXTKrvAE16ZRTYPXNE/RuCJIs4kM0GlhYFeueKf1YpoQzauGlCnSt
         HzZq+PtvCBsp3Kk1ZwQsePSU8TMG/o/3UC7z7W0Gf09fXvYmow5cKg9pyBnQY9tw8nHp
         itdF9n9R1I0v1M7qQOoznBrt0XCOtdhbQIt7rTWCjGK2m8ZRTOEnC2IhNpqsqKrvBvvC
         wV9ICRWCCVGaJxzn3YIv0BDag98mzfLXomNKF0eU7zMelbBYzXFfp3UlFzErpiceRa3o
         Wnu3YHv4Ucd/EcNLHatjHlp4qlEC004dAB27ZkaVn5goQBKrzayzqet0S8OJe5r9OhYa
         gzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787935613; x=1788540413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBVClgdpKmfnkM4Cu3SaLQRKw2oS/EQYOdlTnpUMlbs=;
        b=RO3yYn1jsikLQASbVBrwO8K8dN4gIqZN7DmMipnfN2NLgNTotDKHEC0tMHFUtwNJEA
         +y/BBjy1BmX9jmG0LAcJxpEwYy6r6wqNu1I8CSv5VgMERH222IjPMApVKssIV97mDTKE
         JNM0LYrAaQdFexW2bLyA26N82Pv//QdeCSNJEjQ8BpRIJMEgZMFfVy+44+mwymAzcJ53
         gltos4EA929Xf12xQsFarNuGFX0QulVebL0woI4kwjks3cow25PKYopwhKupubECejfH
         QNJs5A2ei6wxg0BBpSavJ17igbHim5G5TMrQE9DvHn1Z6TJqm6B4x1kcCL59WRpFEed0
         JO2w==
X-Forwarded-Encrypted: i=1; AHgh+Rr/+EU1qTxtqHmQrA3JGxW5z7j+gBfBZTQAxyAXRFlftlJlOI5ewcv2ZO3JrC6GZgpwLdpL2H+4WA==@kvack.org
X-Gm-Message-State: AFuF++kL2aqh8anzMudoq97OO/sVijd+qmyhLKPHyvRbdo5JyzBeRnNy
	C4d6xz+HzyDlqSNDfO3EKaAn/wRXMzOPnQAUIihM/EB7/7Frl/CzrplZtv0PK3BQ3lI=
X-Gm-Gg: AR+sD10ph3yExMpXxmXt+pjiRq/U6be50HvIOEDbNIt/deCnyB59V/bJbC71TTXc1Mk
	TxKx+dOz2W8le/BBVPYov3qFP6QgdEu2tg/IRDVh24kIar35QkTfDawbx4b0ZqcFY8x+IXIu0uR
	+Kf5GGHDWM4gtQBotIDm/+muD2wtTMN8IQlaq8cxuKvveC+qUYpQQK89uiGv8fwnVU7IYRcE1pH
	IO1cUUZYP/tAqyk+bj+Wvt+Ngss25nLfC380e6797jyzyjHm/mJSrUxTS17OUVs3yNVFzHrFzIy
	olTX2o4lB4rlUFB1EclaaUfXf4RtRqZEQ5RYEXugUKZoWw6QsZZ/aN0AAwbiYOO/yBxzQ8Ec5R3
	VJFIPYA1WI4BfRKIxbglP5dPt3tv2RisZwcyuZ9k9ljAt9Bra84Z40hWsLHl/HfbaKZPEVjhgjY
	O4uTKQ/7jdT6SHLyCsbEB1qS4EEO/NQLx+dZEiopN9DxznWgCs6EAdfE1RKO8Nk6WWBiEmgR4IT
	w3BQ96jG9+jq0sf/bfQ1rpp2TGNOAJWdQ41tv8YLZUnZ2bWzCss7kv4f9hAiXHNBz7G8Q2efaWM
	Bd2OFQ==
X-Received: by 2002:a17:903:1a26:b0:2d5:c099:16e2 with SMTP id d9443c01a7336-2d74e070456mr160099615ad.13.1787935612681;
        Fri, 28 Aug 2026 09:46:52 -0700 (PDT)
Received: from MBP-Saravanan-D.civet-hops.ts.net (c-73-240-212-25.hsd1.or.comcast.net. [73.240.212.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988a1d6sm7487845ad.55.2026.08.28.09.46.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 09:46:52 -0700 (PDT)
From: Saravanan D <saravanand@crusoe.ai>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Saravanan D <saravanand@crusoe.ai>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Cedric Le Goater <clg@redhat.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
Date: Fri, 28 Aug 2026 09:46:49 -0700
Message-ID: <20260828164649.77283-1-saravanand@crusoe.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F09E618000A
X-Stat-Signature: 97d1eij4r9hgpzhrddkrn5idudcrzixd
X-Rspam-User: 
X-HE-Tag: 1787935613-534096
X-HE-Meta: U2FsdGVkX1+wH9nvWZ+fjWObiycv8luLKjn6NLb2LomMisElZDFYu/cuSqGrP072EXJqLjxeKEPGLFlxH4XJifcQUC5EL+eP5lb7EDerd+RrnR6H1WpZy7OlBBTfysxJm/l+kAylkblo7Xg8AswXroiKc2AJioyWX5f3vhpCqGjnl53EJUtPJdPVBvGf7Ax7zSLtQA1Xo5Ebaq6CAr89bgsYS4r6VTSTetzkDY+v8wlMtVU5aWDskheHTJfC5J8N17Y3Q9CSk1nJLfQ7DCkrIT/6+4jnH6vGiJTMK7fX18uuhF/gE73zsQiEC2yupY24unvbSYckOI1F8Qxry2zKqcS8RjJ8MiJAxyOHaoWO9ZEBl0OKJYZit/l1tbH0kAEYTDU4sYlI44V5DVqH9MyZxlXPVx9n69Na9mtgpnZTfpNqYj71yzVV1dB/OXYJGnPxBgAe62V9TolZdi/nTZ0nQrMLCdC0/DiUMgkk41j3BCw2UlJuoFYmHFqcN0fWT2NNdvSwpIdAnNV59ld5UT8K8SIqZylcvFd4rOPNQUrMiqMi8RS9MG5KZtrBoLZdYOuQbMCiBnrMd2uTkSwj8BgjKiqaoy/AlA3IlUKomKvxzi9S8XC0wLY70BurbAX5QpDQ4COFnDteHPQHOuWYwhzjpVmLo+94nVPsKfrj1FmNcyrwVkOvTjLuaVwGnAcmjpBLJOFhaDBQ7FLGQcbBcdIuoG0pPKAst3e1PA3Jxs/Pf40hdV3Vqj+n0kOJW1LEtvQI3lt9aeCiGerndntndcl1eylX2QMn1S0IzlE5H1/yfwy6Jw4Ip3ztQpaphV392prVh+RDTJ+DGKOTByisqinTVjOovx7CkBZTdlv3sjNg0BubHnTh4Ldyf/JPBJAYLOMz3eM+tfd9y71D0PGp1CN2PA1lft3R0Y0B1OapRHtV6rY87G7LKma06jwbykQBAp6pbdaFMbVbLoc02y7fqFf
 cvqlaPwo
 GQWlFwlT//xrs7GdLAZb1iOcOZfKjZb9SnhBUdJJSiGmObZhmpYDG4R5xFOHnjGlc5hXbqDIUeSSl4obFSG2uYxlogUfyNMmOc09stwJLZTtPmDRaIKvK2er0YRbNaa+6tn2bsH+MsTns8qYXkVITk1P59ll5Q60wX7GOe9Ie0PAmMRLRW5nXh1cfX54miCy4kZrDfHmvhfnjPGeyQ40iuCd2yU5AN8Jv9xIEORxw6QQSLVBYA9ZgoUPrTV6+sYbeiL23qe1xTmsc0Q3TdbOrdSX1mkYjm7QVmRC8eHIHl2q2Gu7E3it/JbZn+8Qlpl30GEJufxbVw1cp5+mwOGca+CRTjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:55:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> This is incorrect - if a huge PFN map is available (defined by
> vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> should be mapped huge upon fault-in.
[...]
> Correct this by explicitly checking for this while ensuring that smaps
> continues to accurately report THPeligible statistics.

I backported this to a 6.17 based kernel and tested it under
cloud-hypervisor with THP left at the Ubuntu default of madvise, on
two GPU generations:

  - 4x H100, 128 GiB BAR1 each
  - 8x B300, 512 GiB BAR1 each

With the patch every BAR faults in entirely at PUD (1 GiB)
granularity, one entry per GiB of BAR, so 128 for each H100 BAR and
512 for each B300 BAR, and smaps reports THPeligible: 1 for every
vfio-device VMA. Total time in the huge_fault path was 4.5 ms on the
H100 node and 130 ms on the B300 node, and the VMs booted in 11.6s
and 32s respectively.

Tested-by: Saravanan D <saravanand@crusoe.ai>

