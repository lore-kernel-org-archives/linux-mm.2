Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89668CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEB46B008C; Thu, 11 Jun 2026 10:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA05F6B0092; Thu, 11 Jun 2026 10:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DEC6B0093; Thu, 11 Jun 2026 10:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A72816B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:31:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7588D1A069B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:31:58 +0000 (UTC)
X-FDA: 84867871116.05.C26144E
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60910A0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:31:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YY4EyAa6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781188316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+Dh9+uTJXNYOF5i1HD2hzM+xlcOTe+fE0MlRXz0TIc=;
	b=ONTBrB+mhqUh1f1Sxsp4SLxayIl4iRwVRjUU4zPixe+s5zYwzmlmEGjjHqg1x4Ks332ncv
	wZkhxU8SJJHGE/08x2OeyToOteVKgfq0wl2kcvzGFu4gbJfFN3frgLtGXIu7Y13UiCNmA6
	QDaSRzJ3l88QRJljauaZEroz2PrDCOA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YY4EyAa6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781188316;
	b=tR5ANbwg2UAzdGOyLkHYvHEi9gaknhWc+kXubjV4XqY+ncX6UzrXsjQssbr9kdjbxg/dQr
	ix2+TALa63HErRwzLZqryGyfyfmWKRNbwU7a4poTImqg+K+6HVtyvmz1qtlI32Cqg4RWjb
	5/KeYIc7TOF9aysaSQ5s7lEN83r6J2E=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so669708f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781188315; cv=none;
        d=google.com; s=arc-20240605;
        b=Kc+i31PzPaR5BeaceL/EeIUV91lCU9CM3AL8x9/jdg+EO9DMfm8be+DDlrfLUVxdKF
         nRHle8QNE/GGBsA2glyILUWUY1BiXXueKXipJndvG6RqyYQIZWkMyh2JGWY0L0a9Uju9
         saum88eNBvabE1OA242Dj0mOvb9WoM6GD6sFSec2EReH1KPJ6/1NpTakxjYoJD8oQ0Xm
         gMSTlbvEqvtwvA5F2dF5lcLb1X8fm9kOjAtQ8XIYAnmm3933FtppjX1wLH9ldYO88ELk
         w7Y/zeuaqzfm4e8HPHHAn0mYw+TXXZoYD2W6HEJVI7Ot1eeBqDtqdGeHriX6JHe2oOUX
         CXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i+Dh9+uTJXNYOF5i1HD2hzM+xlcOTe+fE0MlRXz0TIc=;
        fh=f2Xny+bAGJuhPkHCFlfpj+1jLHXmeIFyRnwGoxiXDgo=;
        b=lK+ejOTzl0sPl9TvJcYmUpiIEX08wJsoL9fM1Hjr0yVP6YEjIxQJEqkXAenPP6j2o9
         vCGzZ+n4ODbPBDTU66Zb2ohlwkf2zQgTaUTpWOFpjOntGhLrZoI6Vy+/nuA/4d1jj2St
         Cmiqfs1PU27PfWQq3nez0LU4NE/8cwpVLtN6rsXmbmJks57onMiGJhhXXcVoezb7dWdc
         XsqbQQP73ORzpZ+JWjqUaFDm6BfmBFSUCSKPr/o8/EMWu73jXTIV00PTUEVg7mdI4GrJ
         JD65Z70TGBQbDnDm8pxE5OwxZ8icllWzBfnWdueiVh2GBEO26liL982o3PLE0r0rv6Z1
         eEZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188315; x=1781793115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+Dh9+uTJXNYOF5i1HD2hzM+xlcOTe+fE0MlRXz0TIc=;
        b=YY4EyAa6VOboxxhOgSZ7GXU4zLIoLA2q7T0RG6j0TaWUpBsG2BjJieZNk8Fpu1Fobh
         RbD1HoiKzAYkYJkGd2nCj8yOZiqtIbLGBNxmu4fe66Qys/Y5Ob/Vch+Q0J53vzZM2Qdr
         ZzpQcvvF7myjgT5kdbJWWDkWJHhSO4mTb/1GNEYXzo/N0BygTnvaR+mO+j6yBrHbGVbn
         k2mkA5xelCshpOKqtD9RgBVBo0P/t8ySFM0CbTeRgV5acf4HOWTGuNVp8fyp3yF220Gl
         wCf2gQfoLGkeDpEqPoYFcnj5GOiOAPCSCddCs6bBy8MrA64258jsErtX2TlRarCSKpYZ
         DCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188315; x=1781793115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i+Dh9+uTJXNYOF5i1HD2hzM+xlcOTe+fE0MlRXz0TIc=;
        b=tCRJKR2NO4XTU/f8Li0FpA25LQIwJp7+JehzZFxMhNv4IpTWfMxgexa1t+zNw1oWRY
         Qvt098hnHyNvtqR71UfysCFkCh8t/Pzab+MCzX2CrGS4sYFQjdUE3xU4HVrXATv2q8V3
         7yro/L7mrifdqBM+be1rlcOXhjEVotoGxu1D4F8FBqUORRR+5v/LGRRrd4Nh+3G0+4w1
         EmABwzRB/54qWAiMOOcG91L8C5U8xRD0D4ZwBpq+13RT8ixbBho7CLTxksZAocoT+W3a
         J42aKtuVtMqF+ZC3mXKugSPdKYj74dNePfRwW6+umP0Ek7+rKMs/tKXsfu/CCP/IqHql
         37Jw==
X-Forwarded-Encrypted: i=1; AFNElJ8kBZH37Nht+NpAEwp4AHSbsPjXv08QVQJs9WexsnDFgfIIJ1G+CtWTBtAP8ver71+00Lq6QUZZEA==@kvack.org
X-Gm-Message-State: AOJu0YzdQNjL0YVz6zvUhfD2VJdN7E7v+QVARbvVdXhQbuqpZrOUQuoR
	MGVzoHkfc1omdQ8RtDswYwectfvTWRjUiJsr1HZXODok5TOSORFRGqkZtR8vOFRSFk27MZxqdD9
	waTj+ZhL17/ql+V8NBXeFoeXpYbCiH8A=
X-Gm-Gg: Acq92OEIrNHTUlUP4It2eKqodmObNbwGay0TPu2RTuhHXyoyrmL12+OsdUVaSYD+usj
	SpcMojCD4iwSD2jD2kISNbYqT60DRNL8bvQWkKTirIgke9wG6Yyea1hSbCwbG5B01d4UujOriXD
	BA1BAlNf2bK8Lep/3VO5Oj8QpL7r1/azdL8CK4hGhemn9QmYusJwMjO8hkz8RLwSo2ICCEavGkY
	ZVu4UPJcy4VAw3Ut8Sjc1kn5aCKbZfDaWIi0FW6pkL70O7ZtcOH1wmzDJipFYEoQuavkmYLMQsh
	W5iWdO/mYXQ5XQM7taR1At1hxtPCOCFOk7d91etPohrDrdpN9lkR7bnj9otzqkr+Fg==
X-Received: by 2002:a05:6000:1868:b0:457:ff13:b2a4 with SMTP id
 ffacd0b85a97d-46067dfb1ccmr4199861f8f.3.1781188314452; Thu, 11 Jun 2026
 07:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
 <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
 <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com> <CAOptpSPseFH14dyyVQrvfLxqjSXFUyhoVg3GXsQh=7qktJ85Nw@mail.gmail.com>
In-Reply-To: <CAOptpSPseFH14dyyVQrvfLxqjSXFUyhoVg3GXsQh=7qktJ85Nw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 11 Jun 2026 07:31:42 -0700
X-Gm-Features: AVVi8CfUEFgpg_T9bZIVNwDbe3PuXNIpDiBfssczEOroQagK9g8LgUhvOBtA4zc
Message-ID: <CAKEwX=MjWMTV3KLUDtfmGDM7LiRXNO5au85==SwFqpSBAQ6Wzg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60910A0005
X-Stat-Signature: 9m3i5w944krinq9yscbfgrzy9zbzjm4b
X-Rspam-User: 
X-HE-Tag: 1781188316-948172
X-HE-Meta: U2FsdGVkX18HA8I+RJzOw1JKBeiAjjyxu9e3ZvNda7c9+CpTFFSupsvNQYAPo9mZhtqg33e8zXcirP3EGTYInWqT8p7sRTJNZAqbeOEj2e54JAaK07sLHvwqZCBcbqMjg+XJ2aclEkedl8AWMORAJspt4HxtCuj74DHCdiHsWSG19iULseTyAZ0RfyvDh6w26XuvmnyGja54dCTWFzm+Swi3HzeRVaxLF6PZ4b33XtCBfuB2RsGRTPsqNyH1eyQY1smdZx7As9W8sGi7lZ/7gjtUHG8kygIvocEmWVsa21FVseZAL1LR0O55V5LVoTYg1D2aA2oxOf3O8aKHCWBhkfGgQpmtyfJY6yNeWgdJ7Sm95UlW5vxXEPQB2DvVbSUC/piIZap88Vb/PSnY0I93SkHNzykJLIrlJc9R96xJTer/O53nmo0KOqj3rfw2GYG6zY5IlgQxgpFeff4ozUfHyysRgaHB+UlxR5T5/xB578U356wwtWUIGbFGiZk4kwcgzN4qXuSZ6BBKWjYBvvukksJsDyMDAWfHEvGuewpn5Q9/PjgJ2RNj553rmTpgqcRIl1LzTtw1n7hd0nu+3U54/WFiNjsXCPJIFcYiQQgPkkfgONYTQxglx2svQzzndTsFkNH3PJn845V3zZrP+8HviUJP/Dd9le079BC1V1bC8ECGlcKryRle3ICBVZ3C61rT8QwEN5jEDnq7VLmBLIEB9EMw72xM4YPexvQEKXLXLSMUtvn7Cgg80EJ5eULGiFD18DOw9WYlwvssv1auVkh53vzvaCWMIoE1pdjGyry0QCyLYwR8pBpHzjZ8yvoH9TU33Lensn2CRSyaP32OcMV2Qbe9xLfe4Uxx4Ezpeihl/WD/LSaCGvspmy4gSas6SlFs1d6q0SdFYES9zXTqf65+LTVjMS1N4xMH4JqLc3SThXOracV0VxnLWIHyVKqxCWJCAYd/Uefsy0j891Vmsac
 lzyp8Rq/
 F12JxJ/6H3Yjrg6jTAFsIv4ZBLguGwvZbBiEdYD8kxZ5ATV0ZWMVqdr/m2ikWTXcPPqBASUFfHetq0UKApBDGelz2UVFz8HBcn78awb7WUXU31OE7axvYVJOILNC93f7lG74voiBuhuoMiVtgwdrMeQpJAspQTA10x7E07fwmfzV/Dr+CXkiIGs2UITZP8w90BOMI02BWDlt1+uquZy8LD0H3ypXoL9Qmp+CSMTftR1UXUjKc2NWoMTRF+OW1uYKPYg0EQ4yotIfX5PR23aqtTWX+X/gAXAB6RXLZZTx1pEJa72DuIGrxpjFjgaXRJUNSwRdr80nMES5iHiHjXECyIuf66aLUhRnkVehKQY26W9uElHxsdryGgtGrz+zxd8fqaFK699Pd10npwCMKbdTcgQ8lX3YiDU/lVkmHRpn4tgyt8oYdI7Cy7tu1y8vuJpm3xcfbOcXNRHQuqVefeIgAiX5QcWPvRzpcYuOcdNgs4QTh06Cyg092SWwMoBGXCH49b0a+LNGfDOsDIV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:15=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> On Thu, Jun 11, 2026 at 5:28=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
>
> Agreed, will follow the convention and drop MAX_:
>
>   ZS_CHAIN_LOG2            -> ZS_PAGES_PER_ZSPAGE_BITS
>   ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_OBJS_PER_PAGE_BITS
>   ZS_OBJ_IDX_DENSE_BITS    -> ZS_OBJS_PER_ZSPAGE_BITS
>
> Nhat -- sorry for the churn; this supersedes the names I proposed
> earlier.  Let me know if the new naming still reads well to you.

No worries at all. I like this a lot :)

