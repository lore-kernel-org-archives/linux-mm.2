Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845C9606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=XjxS2zBH
Received: by kanga.kvack.org (Postfix)
	id 0ED5C6B08BF; Tue, 27 Oct 2026 15:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CF86B08C1; Tue, 27 Oct 2026 15:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6366B08C2; Tue, 27 Oct 2026 15:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF27D6B08BF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:38:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE43340AA7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:38:08 +0000 (UTC)
X-FDA: 85369417056.22.BFA189C
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFB0180013
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:38:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XjxS2zBH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793129886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoGn9VEZ3I8Ld7dNYqrh8Oigb3Q3zSaylzK9qrRu+PM=;
	b=sAQbFejc/P8TyVHurABtFz4RQBxIy9Pe5nF2aJlH96uxngZu4ts5BqdhsReoUC+SWV516E
	XBn+HmWYDwS2CB3pJrd7kgAje8NhUEPX7N1CDrl/ZRT4q8vRabGSDf2IOtTpBoQHleRFeR
	T6jbsADBbOMFGD7SxNQH/rezksXEHMI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XjxS2zBH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793129886;
	b=JeZTlvSI6TcWy4WSTd14d9cLV92xEU3UcXM7kXbQXFDhQs8w/LBIbxlX7HKEfQcTBfTGEu
	BX9LFXDbxl4QL/AyELvmdw4IfZzLVoTCJOBhA7GG9aLOZS2FGiBJBACHtjjm1fEzNfrtmY
	sv/2V69LX7ZBb+UFSMB5GtXIlxxP0JE=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c43373ae89aso26098266b.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793129885; x=1793734685; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AoGn9VEZ3I8Ld7dNYqrh8Oigb3Q3zSaylzK9qrRu+PM=;
        b=XjxS2zBHli9X/dqoTxilS87gyFjS0A46OpIW6Sw77+6thGlCeg8diseuLTEbLp1gjW
         RHFSMylCfUS5VUMJnOpFxhbL5DKPozB4gw8Y86IsIIEX2v3v/O5yPPm6MDD3CYXoHyY+
         On7YtMOYGhvV1wIsrD2VXDYYLI5JrnjHCgwSnMDCX5zPUpuEgxpxBZM6BXW2nqZMaqcy
         aMXFoT1qd69MRbFWI/OQxSoJjPBxFk5n4rO91F53Ty4HqdWlkzyU76z2t8Pp6dO70q0+
         hPEriRL4545VfYxQAI1x/OVcxLKfrGP73QiXguNcQUCON4gzUcLM4eZVvj6zAGBeHF/V
         G0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793129885; x=1793734685;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AoGn9VEZ3I8Ld7dNYqrh8Oigb3Q3zSaylzK9qrRu+PM=;
        b=o6evpTV3aHzGbjyBwYSZ6ci+GGhXVWawxBYq1TamvW6z8lqs1kQFJ6Y0PYKYLnacOY
         n9gZ/IXEe4ML/nBzWl/FtjUiJVyuE6RaPIf7y8VhBIASMgvGe04GtlqxSsyi1149Xww4
         WV8nhEyxwU/Z60ocZURMsxw4ilgEAw2NK9OvyGyXwOMDDMcSW1//GUXfiL+KSyoccUZc
         jKVOkF6egj5ZblnRL6YoL5ay5lphO1DADqebFeEBxKHfvB00eEy+e5UKZICcUcKSMRXW
         rvJIGfaxFT6ij9KViFvWetMrPFyQy7ri2C0mRbjdhLZVWpnqikTVWLgfcSzcNt3Ft1p7
         NOKw==
X-Forwarded-Encrypted: i=1; AKwUvByjYzHaOq8JEFVicWMM+bKpB6zXSoLrdIrBdVnk2PCcSP+8+PJ26HHdwdXPZhG67/TlAGLfDbjMRA==@kvack.org
X-Gm-Message-State: AFq9FYKnCVhyTg4kAv5wr/qp0XfsNb7eLqAH4dmMWee+rIetTNVYbEEP
	qeVocqUYuWWefOv4meUNt5xcjp+SRMIiWzXQPrXKbM82suVC0sPxDU/+D3PSUKeAPDQ=
X-Gm-Gg: AYBFou0/Y2092zlHdrZ7+PdiFGVzSBOrK3OJ/EaQRnoEOch4F1Bj966huQQnF9I6RxL
	WK4YPKjVccHSMtrB4745EmriCKfoHoBpTdfYKHlLSwyaKc3OVvpz1zcF/pgOgPHgjs8RWwAa8so
	S+P/3P+fMja47P/WOXISkiiWz6BzNOtk1DgrpOieZf51FzO5+kWvudCAgXKOIYZh/nA4FoZmYRT
	IoVvwu3iKwDDbwoN8dhy5V8xxwhZDXE+t2fsKrRbI1RUOXloms6rUFxtz/jfcsVv+WrdutNRSZi
	A4GcWw0owuDPIFvGFC07k9g58zr5rU/r34CvNsHqy/llI3YwSggb0JbxNVD/nfP8WVdyuTW5jqw
	eNaJQZAsraFknjzAmjyOykY9mqeQ+HyWAR/nFDbjVCymH5T6ZSlraBSepTLE+Vp1u61LB4kz9kc
	zFYk+FIUm+eFg8tBHOWGw0xHPi5lxLdVo2ikEEcZU0We1kN3BLiSXUwanadGg3jMX8kl80xEsbG
	Ign9DcnuXnjEE71vtQ1qzKAi9oq5OBmgva/LWYzCGNrEQ==
X-Received: by 2002:a17:907:7f9e:b0:c46:645f:cedc with SMTP id a640c23a62f3a-c49be054a4cmr17194666b.46.1793129885192;
        Tue, 27 Oct 2026 12:38:05 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:7::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4964601f2sm455107a12.37.2026.10.27.12.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 12:38:03 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Gregory Price (Meta)" <gourry@gourry.net>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, 
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
 hannes@cmpxchg.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de, 
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com, 
 stable@vger.kernel.org
In-Reply-To: <8a841fb1-8e71-40c6-91d4-3252a0a1a368@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
 <179310997463.2232644.3260379218896917308.b4-reply@b4>
 <6f5aaf2b-894c-4306-a0b2-e56f815d0a89@kernel.org>
 <A4D82AB8-F33A-465C-AE69-933B746E4885@nvidia.com>
 <8a841fb1-8e71-40c6-91d4-3252a0a1a368@kernel.org>
Date: Tue, 27 Oct 2026 12:38:02 -0700
Message-Id: <179312988283.676746.1330276872732304961.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFB0180013
X-Stat-Signature: afnaj9u7aa3ypwqmh5uc6u3t7hcxtchq
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793129886-596540
X-HE-Meta: U2FsdGVkX19sr88gwjBjtdR46r9wT0YEf8TgkeX7AcemipShLZG+Th1G2JBYxigqot/SeVKrmjgrlc2DyekU1F7TxeemyeronHeXNXgzEmt8Hpjg5FTZnenJUXM70DD5ycTyTLM5Tn49Wx3dtF+nN1f9vGBAmjBgfT6Om3HW9pY4hmlswoQDDjb952jsbSxf1cmxzWy7mvNOSF01xKRWBDE0/fgoMn+l7FQPu4Jo6ap7oH6SKgkMEchVzaHjUvgQ2q5q+FdTJ8GI0A16xLBcJF0JvWR46uaPk53cMFhjJUC85FZu9xgxbd0F0hdZN8kugoVOTazrdjft9bViDKTqU0Ns1qBFqXU4gEF6Rz4JHGsGb6XMCIIVDsW+LbyENMMFZ2ClTywkw2jqcMTrDFWkZpqXxVpC75G0w5vxjfgO+d4cnUIa03HNAVtl8crNKZMyXXQFGrN48EsKdE/i4+fCc0E+ijY5U4V62/T+mPh6YWYh7exLFY7+zjgtHy7mN8AZOMY97VeDrRkbLtDgcEXmWgqN2OLbRa+eGslw2O2iEzx9YM7AQl411ZfPiU//hWYPx1r5tvJskoyAuFVMiQYLuReoxqSZ+0R5Pb+2Gn0h6cMDw2OORHg3omz07fJqKKowQE6/60UMbADfFTB2lDkO97dtmIOrw7hSt3PjYhYCUHwDF2rM/TfJT5ckSTHAKK927a8l1sAswpd7Iypw0IABLlBmZB9dgstx2QBizeexRmeHYoAQjCDy/8B0kt7fJl8NWyeKIvfR70Y5fPPOvYz9Q8EZqWhPok0Q/Y8UU0bqnIPW4iDxEWL0oJqUy+S+nimrMVXLq7l67Cxo6Q9ig6KfqIcRL17x/xDX7rCiSJ0Iv6I6GvljZzgRnOANjgkChSf1/vflF4yLnmWDSYBIBvHYoiiq+sAtxuj7fXfVOLIVqo7YxMEJ3BClzUtuYXoYhAFSS3JsqiQefXui758PHkA
 JN84sGfy
 Q+FdVY9oHnDgA55HSbPQH+3mQJj1bId+8OB7R1uaUvYGotIxPmY6U4oUFzzBXcepDK/5TPzf2mG2xFcYBJSGRFS7PHS0D537FkVcUOZ8lELR3ieTxnlehnqO0nE9nCwlbQ/wamayVtoSfxFPPdCStDzyYtW8Gm/g1niJkA52UgJYFLMOE63JpDocX/VXokDghMk0abVicVbcM7zSk7x6RiRnr78Gy6NyU92/+5ZD5GE3Qn3vJwS/cIVtnAI6hACmUrwW0ES/+iop+F3LLGCFUAhNlxjar96PuD94r1afv4fEvFxkBO+uiSJLojSNzho94NWjlENTEMWavFZblCyITztJ0HhrXiigE0/M13xlvw4f0weFIpNCtNxJja1BTHk7dDNDUwK/vnTW5BOv0vR8MgfW5daPa0YPnVueYtkdulbHw531h0uH9Fj8Dqa7m0VEaVE25OVt8/HuNxPGhW7+FYdT+TXU+DNFsKYl0I83Wx5nGfUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 19:58 +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 19:53, Zi Yan wrote:
> > On 27 Oct 2026, at 10:13, David Hildenbrand (Arm) wrote:
> > 
> >> Maybe. But if it's just us core people we can just talk on IRC etc (like Zi did
> >> two days ago when he was about to post something that I already had on my queue).
> > 
> > One idea is that maybe Sashiko is able to identify patches fixing
> > the same issue and does some grouping or tagging on the website.
> > Or send an email about it with a lore link.
> 
> I think that's too late. For us core devs we just need to sync on "has someone
> already a fix for that or is it worth cleaning the AI shite up and sending it out".
> 

It might be worth just having a maintainer Fixes:-only review branch
that automates pulling these things in and responding to conflicts.

I've been working on some b4 workbench automation to make triaging the
list a little more sustainable. It's getting there, but it needs time.

~Gregory

-- 
Gregory Price <gourry@gourry.net>

