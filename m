Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7481C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCB56B009E; Tue, 21 Jul 2026 09:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A33B6B009F; Tue, 21 Jul 2026 09:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896056B00A0; Tue, 21 Jul 2026 09:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDB76B009E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:56:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEF0A120195
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:12 +0000 (UTC)
X-FDA: 85012932984.11.B7B6844
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D6844000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="eqHt/L9H";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784642170;
	b=vpZ61d8gg//LN1PEqKaDCW37lJUd5Z7mdK9ph9OGXv/D/wDpeUbStOCRUAgX01ZjBV1DIb
	8vOUokJfpWP4mQ33rOct5aaR8UYDQnStcj/6jcu8dAaWo5q1tSWOsrIbntKe22vs82VTSa
	cev5E0gpGK5zwTa3uOo5ahon2BxTjW8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="eqHt/L9H";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i39j9ZPSo0Qr2xtMzm51tKekm1oxcgLbT3Wlw2yCCUw=;
	b=jjBDvHJ1H+PZ60aqw7EbYHl0KKYbnd+2VBRrvnSanzLbTiJoiTzAFPYwNbXutuIBaHT1oi
	o+4kwnZEa7z7Xl3kQj9BEihxIVLketBt2rrZKSDaxzbHyKFzpGophHCsSRxBqchGcAI7TD
	bInZhkUDWwxUWLtsp8XXJ3zwxtty/9M=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDmJjP705075
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=i39j9ZPSo0Qr2xtMzm51tKekm1oxcgLbT3Wlw2yCCUw=; b=eqHt/L9HIE5K
	foimN4Kxyx8g37MIUm5hs5xTLxfBxDh3a1NFffPtJaWTbPk73wAl1YJlfSDnuDQe
	7mEZ8SzAPxCjfw0nbzv0hzjke12DEoPpDWXfzeTFiEP4q4TDgDGH9e23X7p//O4i
	xp+6i6SmdU/y3wdzL3QPEbZwn4ZiHeqldTVTfbV0jCRqZx3+LPrNW3qSs5HmCvr6
	WaOBMK4hNXA3+AN3iA4PN5zx42uSu5cvm7JPFXKPof7+ljLN/PMybEla2xOBKQTn
	RcTS90gm9eD0KzzqCCzX7GGiN6YQqlVC07QilsnP0pqU+s3+aFv+U5KIkJd8ZINA
	8tgkuRtTuA==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fj6bph707-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:56:09 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69c20d12deaso8069786a12.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784642168; cv=none;
        d=google.com; s=arc-20260327;
        b=byW1rr5VQhS9bUZ2s8WZcpmNC46YhjiHh6r6tli5rbV2J4Fkr6v5aOl6T6oMQFqW2r
         jqk7kSKJhlFs9mmxh7NHvC5kh2IoD+8NyFg/B+esqhTk6CD0nEhq2yTXNUAnpURZF0SP
         xns4zRYVdLavTxNIAlGryD1n1uuwudDUe8tsRH3eb4YsExuWvhyy9RzwIgN9gRRMZ5FH
         aAv2hO9/RcqhPJwfo5Ah+rfx1Z4wZ/+C7naoiWZZsgkimj4uNMJzF3YUlOdNRsPlj7TP
         mKEXKkvFSNlKuiuVM8oQA8JOcG9I/FrKw3NDDsqOhAkm9YzVDkuiOcSqiVwxHuCYKQ72
         BzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=gaF4gINzHeE0i2qJRc+ZrgkOrkJg7hRSLG75jHpuL7E=;
        fh=YDFbzcr24S9b5plsN596pyRenUv1lQb+g/guomQqYdg=;
        b=KoLVEvcyvoy6Ii12mDhPXK6oYoq0s6gSuLU5e4YiFwb+URYM7y97bb4HnpjGQBhgDi
         MrwsHgYmBviKxeWfMEXA+W/rSQOvuJm83vLEHN6obgBI5M1ImiO/nz5uYwIUExti9XsR
         HSGPkgkHVkZFK/pcyooh9Gv87YvUF2ZgIHfPVjfgRWGpVkSjko/+tlyJISFv6A9hwbux
         27h8GkWF1cRU//Y5QFAgRsaIpvxwb7Az7RxK7Ejcxj9irQG0Ermqeayvc+F6GRvrcjGW
         KTszFUzLEkn+4eWjpF7PP2mFLWuz81dPD6g044XYzpQSL9rJZxOZqPj2zIoXtHRhAJdo
         bo7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784642168; x=1785246968;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gaF4gINzHeE0i2qJRc+ZrgkOrkJg7hRSLG75jHpuL7E=;
        b=HAB3XpVcTS4vI5l4KzpvuPdo8J/XaRVUccWdlaL+7AMfRQDE8NoU9VFqWiQQ13wdNW
         Cv9alY5fF00Cd3YseMGVWuYMCzkHCbpn+kjoJCFy0jv94mlTUAdJKkyZJ/buGyjYW9FX
         EpXCR5U4ESeK1tVTYEVJDSG+t0w67zVTh+RuYHR/KmTZukqGWmWpgbd6kglYfgOyfjsV
         s1r3IUBXAExu6HCzmwJaofgvFdtV3FiEcnGlNaFy7bVcEvZTHZHBeDqeVWbpVHNkMQqa
         cuy74l5EqP9ZH4R1fM2nxJIDli1ZDtfD39cjVS3SBCe+29HSrXRSj1rm30HkKs84LQEU
         xOpw==
X-Forwarded-Encrypted: i=1; AHgh+Rqzy6VJS4r3POA3XJgUKIgNyhEyjVdPmHs3392vg9wh9fffLXmMIenr/9f3HV5fZHbaAU6yqf/EOg==@kvack.org
X-Gm-Message-State: AOJu0Ywu6qrhd75uI8Da+/cJlgaE7UydVuWnmaOQ69sfMUXIdoacu2Cp
	dmZe6Hy8EfwPLBJM83ql9u0LF6kPy8WcfVs4VxntskZBHvRY2LgmiWeZAVcwVZxjKYM5CmVRXnz
	t7Ddk0yKJZ/MHvQdpYhZVp3uBHkur9OfJ2S7A7uhG3PPFNvWbuf/bI+5dZIFs6u48CcHmwxIMVQ
	h1QY2AzOlkJBxHN95nQhaqk+UL1w==
X-Gm-Gg: AR+sD13sEzyaboojWsGPBLIr8eK8KocCQ75gB+ptFfejdeaAes7Ep+S5XmhDDz8QAeW
	xyP8Q+KjfvSbkizJMuBe3/JEs7bpP3IIZQvDEJdamUrj02ACRq04C+FdmbQApAgMUHQU0heI+R3
	ar7lVovW1t958PhaVra7bFmFqi0ltzl6HLIgWKUDqginJLe/enwhDCgZ44UhOsMT1QDqOXIu/Y
X-Received: by 2002:aa7:c556:0:b0:69c:5eb6:d913 with SMTP id 4fb4d7f45d1cf-69e38d4ecc9mr6571603a12.14.1784642167751;
        Tue, 21 Jul 2026 06:56:07 -0700 (PDT)
X-Received: by 2002:aa7:c556:0:b0:69c:5eb6:d913 with SMTP id
 4fb4d7f45d1cf-69e38d4ecc9mr6571588a12.14.1784642167406; Tue, 21 Jul 2026
 06:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
 <al9cUqWH-72HUAG_@cmpxchg.org>
In-Reply-To: <al9cUqWH-72HUAG_@cmpxchg.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 21 Jul 2026 15:55:55 +0200
X-Gm-Features: AUfX_mxt3Cctj33aPUGv57TuKolyrbhcy_t6t_9xoWTK1h6XqlZegZLiUMOCUZU
Message-ID: <CAEmasaWbXLzsrR7VPUxMUOfU6DRd0_Jn1iUX=QaZm-aH61c4Ww@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NSBTYWx0ZWRfX1bUv3RloPZmF
 dZFnuAd0EWBdcB0SxTtgUaM62GzdoPNg4iPlsp4ntlBskHoB7KRYzSTOUBmhv0UT19uDlVjVDT3
 tFGQ5behSKD6YFcOACoe7RSyOoseTSsQyzeWh52jqu/Fvn1IO74JL7Hmxmbp3wuSsm5N+L9ZVlN
 h0zUIqMphyIc8SCT4AYzW2KwAhN5aDNE+Dn9lntlC7v2pLrD5uEIiqqomDY6uDXu1c/PYH4cu27
 gu6eZuxiW2w79hWEe74KakMBTQfLdl2lENZQhSQxLSeJhK8NWX9ePYsZ2/54hTVNUzpwEvLZQ1i
 dHvM8xbm+oanweZLMVzuuioBpmiy4Q+1IZI1WssELpMxuoarxXWTRdI06U4d6xuaPr+roHlWM/h
 ljUi6+Sj1a1ALyJe4CYCZfMP3FQKhkOV/MWLinWUflkj+S0QksbPIiCKKw3cTMi90lgvd6rSDJg
 0A5Q2azfvXrUFpAFTCQ==
X-Proofpoint-GUID: u7OoKrzJfooCI9WG3gs_VLctYMSJtPwQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NSBTYWx0ZWRfX7B2Qc/yqCVMA
 5t6D6yzMmYoqhSx2EOcObWKuKlMonPOAxq729UmW0W4dcTwaF219fYXG2j8UX3RvHOncz5nLnWN
 LRPE2gpFnG41QahDj2ydv1MRO0vL9Vs=
X-Proofpoint-ORIG-GUID: u7OoKrzJfooCI9WG3gs_VLctYMSJtPwQ
X-Authority-Analysis: v=2.4 cv=AOkSgtoa c=1 sm=1 tr=0 ts=6a5f7a79 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=ufHFDILaAAAA:8 a=h8lhBcyy4TMpjp85FJYA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D6844000F
X-Stat-Signature: c8yfa6zjqfpnu6fc84qqit41i8jrxz7a
X-Rspam-User: 
X-HE-Tag: 1784642170-368184
X-HE-Meta: U2FsdGVkX182yd64jB3SOm9MjV9G+mtuXNlA2f7j/lZzXQLySwMPgZLAlA10Z1yb4G6Gu3tTWzozg1tYwQurK2K/fYb180OBFhLRkF8pR9X5ed3rtMQOppqXPjxFesbcnWyIPMA53cupelwBL7tNit35yJUywvrUZ5S0HrzHCU4gItavcXskISPLNzDzB0Qt/pfq4TmCQ3i+s5tYZuu+2w43qLUvGuZMAq2mdnzxzRQsRgHkWblPjFum1RG2yOWksF7auADkUgB6zPHDD18aSrUBTrgQVF9j02ujFPR52U/rkvrKJy/h1a6a8xpAq/K8KHG+QlS7mSEez6mbcx9YGWQ7R52sjPUC94iEjB5tC8N+M/jVAwAx+zfNSck++R6pVXsYuhZ9yEHei7jdW0wRmq7bOIphGVF7BWdXpbM2LWMehjIA+1vN+F2IGVvza1K1pO5ZWDq6XGttDaUVEyz7StCkAuHVT7oyjHubjqCBVcEbL1m84z75RXEu6mawFUxeC9nARn943KLkXEeEXS1AVarqv6vvp88A+eEsUCrZ+KfAknWNpuB2WCb4R0ApLD2LItSAy/FH2Yp+SDrZF86QS7A2Ahe7i5Iy/81Jd4HrUeCPDZRsODIYoPA35CCPgZYmDQZ5NTSGDzKqJRW7+9krl8IEsX4hCuvVKnY8GZHtoEGvirUD6GPBeIgOE8CiyiupXOZajuNUbTVzotDdO0xq86zAyQj9Xj35/qTx5r3rcnZDDK4vwaxnUiJ5Q7cMvIkl4+DS0T099RnD0v/CNa1nnlZZW9VcO7RcO7JeR9JV8apFcB9Csuq44TvdHEJ58LB21QV767nHkWENU0Eg3uiZjrr8Wxm5xvOrnVHAY5EAHm6k/x+f+sWAlnDM5et6MhRSTeRdX3g3+ETYYGz74MZioXzk9l09dJVna9eCiVQ4oCEV6Y2GMhjmkHnCYYZrj9izOhWiL+T+Hr/OAgLFfv5
 JkPp78d2
 4icRXf/d26Ot4G7juek+HbczDCoiNI282fAKRhyWksgV6aoJwfILBhPQLz7EDC4j+sqjFKvOMxRW/vc2/Emlv0s72NEsnCrdoYg1yA3+UaZB39tvAg9tBXf4vfuVPOtMaOuGUECn3xTsUkN8YDZcbOqG4VQCxYR7vH0pmYp1ChKhW1aoTHz0KKj84/w2nf5Mj7A5xKEHCIbSNqw6s0Ag4XbUs01z4s8FA9z1P0u/D0mvrTjVcDwHk5wbepnJi0K2QLMmVYksJe+1Lc3cSS8WfN0FvwC92nFf4A21ikT4jgtxZYF4QoumpQrWNU9wC5D+nkhjUEGVEPSb7KcAH6Ot/VJpSau86QA+Aufd73BHDxwX1gIUlX3e6eMuNvhZK9905MMNj8QdQYqZF1Ln/lZ7zloQaMM95mIGQ1+RxzQCqe7j5VioEbK5pB6Z0lByhvbqgfBiFJMt6/vmlWl5quB4tOdZ7KpRHjsiizMLeCZFKwUoPJkhOCiwT6/FQHIRIjHva/LenthPUpBVgcPTFQ2BMBs35MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On Tue, Jul 21, 2026 at 1:47=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> >
> On Sat, Jul 18, 2026 at 11:36:39AM +0200, Alexandre Ghiti wrote:
> > @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
> >  /*********************************
> >  * writeback code
> >  **********************************/
> > +static void zswap_writeback_free_folio(struct folio *folio)
> > +{
> > +     folio_lock(folio);
> > +
> > +     /* The folio was allocated off the LRU and nothing re-adds it her=
e. */
> > +     VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> > +
> > +     /*
> > +      * Gate remove_mapping() on folio_test_swapcache(): a racing swap=
in may
> > +      * have freed the swap slot (folio_free_swap()) and dropped the f=
olio from
> > +      * the cache, and remove_mapping() must not run on a non-swapcach=
e folio
> > +      * (it would trip __remove_mapping()'s mapping =3D=3D folio_mappi=
ng() check).
> > +      */
> > +     if (folio_test_swapcache(folio) &&
> > +         remove_mapping(swap_address_space(folio->swap), folio))
> > +             goto out;
> > +
> > +     /* Raced: the folio is now owned by the swapin; put it back on th=
e LRU. */
> > +     folio_add_lru(folio);
> > +out:
> > +     folio_unlock(folio);
> > +     folio_put(folio);
> > +}
>
> Is this actually zswap-specific or should it be just swap code?
>
> Both this function and the dropbehind queue in the next patch seem
> like they could be reused if we wanted to make the generic swapout
> path do dropbehind as well.
>
> It looks odd in the next patch to have a generic swapcache &&
> dropbehind check and then call zswap code.
>

Yes, agreed, Yosry made the same comment!

I'll come back with a new version when I have numbers for generic swap foli=
os.

Thanks,

Alex

