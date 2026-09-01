Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C451C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171586B0204; Tue,  1 Sep 2026 10:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148BA6B0205; Tue,  1 Sep 2026 10:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012076B0206; Tue,  1 Sep 2026 10:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C57A36B0204
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:07:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53F52140446
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:21 +0000 (UTC)
X-FDA: 85165370682.21.8A26A40
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 572EB80012
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/R6B3sF";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIGcl+U27GyVraDoyCCr0BIrhXcX5R2Yw6dtHQoJARg=;
	b=eSJJc8gNxCEL9XBZ7ZehC69erS/3GUs61xioEHKybUIUSsrcJI7Y6cGTKTg7a6xMyMaf6Z
	Jxa3SoNNS/Hj6PRPjneIrkHynpWoxWHd8HFbw2VKobFq5cy4n0xeh7DDM7V6gjASArB5cL
	4oMaoyUg6Fv1BpAIb8mwnnOIOGvgojc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788271639;
	b=sBseZQbRIflGrtnRc6fo1j//Agb2rBQHaIEk8CdGX1m+mtBkC3DC/ER71do6Gd9F8Lkof5
	d+B2ipGeytPiMN15olPMjqDA5zDFQatDujc48KSIKOz7HzR4q+GhXvgnAx5KyPEUSGqlaZ
	Dp7lUb0bMP20//pPBIan7bDuW4ozmOk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/R6B3sF";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4a451915d8aso662761b6e.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:07:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788271638; cv=none;
        d=google.com; s=arc-20260327;
        b=YcLFxlkDIZ0QzCUnAG+3T1t6NY1x+BUFLBwrrTGB6pDm7vLdMG1fKDW90RoNin8gDF
         f+SWQL9H3fEMxCrgsp3fv1dWwveNaUMHrHZ3iXmhkHyOXLDnTjMtJ5js/fP0uC/u2bNU
         Avr/DwaFMfUQLSYGi4OL+EspAB+ZMMRPm3+fa0yd4HM6dHHF0EhUcB6RVL2t3n+Tt7SX
         k6zWdalS/X1REpwGCF6sei01gQVRZ2nx3BlcIyo3BZ3JGOfkzGW0vbZx4hUa8bNkGp+V
         CfMDkUhv9GXM5pOmg4A/zjQGiSX/JD5RD0hIsltOoTsTyxwc7lXHGOP3mFWDW7vd9P16
         xQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RIGcl+U27GyVraDoyCCr0BIrhXcX5R2Yw6dtHQoJARg=;
        fh=8xVZI2Ry9c9Ky4QGuMdhzuhDuyZFPxMS6nE0us2IAV0=;
        b=CMHOH7IIT++d+r6dO3nnKaRoeSSrSKr6x53r03NOJSjkhkvmlBaOq5P9ugn2+EVJuH
         vhZOI33RsUXBg2JYS+wLTNi92VxN/h1nqv8TeGvxBKz3aV4fUnfA/uqZxm2g2l/gg1sl
         LIUgCEEZhv36iDvkx7vTmAYNrYc7DVo366NQnIwY4hmM3n+8vl4aOz17FUJKZ+CW/46r
         F4nFH821yqqOA4AXfj/dGmAX3Vsz6NHEUmE0MjbAgziRVRtCHI+W0U2opBDuvs2mdFTP
         aQrIk9VU2bbK8+nt/cvXFRMqX9bd72aS/mxw4HIAm/no0LQwBdAkBE4vx/AJxSJJ6t0M
         sfRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788271638; x=1788876438; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RIGcl+U27GyVraDoyCCr0BIrhXcX5R2Yw6dtHQoJARg=;
        b=T/R6B3sFQYo4wCImHkm2FoDG6tlYkJVOauNEyiqJC/YfKqTXnySiaY+BdZ3zjXnjYI
         j5Mz8ZVf1We0cJn+tm5Ueci/c0N1kvkgjkNEVpsof6midf4q00kyRTZc4WwmHBrfKIse
         /Z/yBIrxUG9IpXOdzrI4Rv0EMP8j+VcTPBp/LXFExwPsqqsPn0MYXrDsjn8AYeqvDH6H
         Uz8Mar6WlkL2mab0vA1Mrr2WZu1YSWcEmua09B96RTm50lwICOwhPaSHkDC0gCrT27Zt
         RLiC2VzKg2FBTUvw+IdlPEs7CEnFqyLEcOBKj+ZqGyqHGYGTI5W7uzgYnNOQyULb+fMD
         0ORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788271638; x=1788876438;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RIGcl+U27GyVraDoyCCr0BIrhXcX5R2Yw6dtHQoJARg=;
        b=WAUlR/K/sGfT5NQsPMnW07fA4B1jK97LQ3jSPXrNpQglXoSBB6JCM3mCFkxP0Fnf7j
         rcVCQPUWHRSIJB3i4vNf1XcpI9e92EwWT6xsiV/h3b10c8W3Lh47I6SRJiId7qvIG880
         OXNNyzb7kmn0UIQpMIKvTiVPssGH0oCtYiYgWomseqGE4i8szyd6zXeC/w1OmvnGqLUC
         SJ/pPear8YwsbenHSOseY4ducrGy7J+KN7qj3hJ632liEEpdMWvITnOxrN72vRy0LWoy
         KxXejJuhv3OEwZmhmWedZbTapJZFM3zp5+7ft91YTI6z4Rx+Lq9rL9r1iZ1cTz6kGqSS
         +Txw==
X-Forwarded-Encrypted: i=1; AHgh+Rqqin2/S4HRvMR/lSqDVtBZYGBx9/iCkARLHgmggfFMsanQW+zVVcqixCyWFaPm6gQF+zMTDpgHSA==@kvack.org
X-Gm-Message-State: AFuF++lalv6C1g/p2unkAQyKjQ2uMkoPJ4P35KFgvUMRtBuGNbuKM6l1
	1BdHZ38cgRKirXcB+twzdu1jZmnMNAdkdiiXqs8zG2DHOZKhbZvbOey/VoMkIGxxKIetaukIcfc
	Z1+SH7NPifvq/D5SnggC9ZVRDiGakBj8=
X-Gm-Gg: AR+sD13q97bkLjH8wRGZRreXIbxsjkS4MFq4E8JCsSo3g5+eaVjKuxjts1D+Hs2hY0D
	JnLY3t+uCSmA+0+VJZ73JqzXNiIpwnMtbC1ruAFxvgSgWFv+LLVLh+r6ypBjRbfzrY5zxvx6kr0
	jzP2ragR83pIgz4VkJUapxOrUTLtFIK/dReLmCqd/caR3Ba/m9DWKaM4yhu2CiwNHRrbM/cNhEs
	qXipacWHQuB2Qa61qBUZKIQgFIXCrZAdyqK1zcxz9J6SU1987qoZwTRZa8Iu02sYk41B/9tVVqc
	m17jzsMJP7+Yn+ILx8EjM75iZp2rfe+A9iWVmCMlMeT4yMPDyDY+k85Jps29Pi8ThRTeko3shw=
	=
X-Received: by 2002:a05:6808:23c2:b0:4ab:230c:5faa with SMTP id
 5614622812f47-4b39835276cmr36421107b6e.18.1788271633600; Tue, 01 Sep 2026
 07:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
 <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
 <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com>
 <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com>
 <CAJxJ_jh6J5N0vbFfi2139vnTVZEECJoq-AV4VVNew6a0Bkwk_w@mail.gmail.com> <CAO9r8zMr4bnWHzO97R5ZaxALDf_5688DXv_LS3KZ5rz2Noe_bQ@mail.gmail.com>
In-Reply-To: <CAO9r8zMr4bnWHzO97R5ZaxALDf_5688DXv_LS3KZ5rz2Noe_bQ@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 1 Sep 2026 22:06:57 +0800
X-Gm-Features: AcwNN1WbX1D1KzKB3UZxSV6NDo0XCn9KAgMzYBsnhCsTgidhCzJl4alvK9vC8g8
Message-ID: <CAJxJ_jjmODTs9fQCbaHKGFm_4LoRV0OiE_Hdg8N2+tmNugK2xQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 572EB80012
X-Stat-Signature: 6kao58dso864qcdphidjharfw1ifxxzp
X-Rspam-User: 
X-HE-Tag: 1788271639-250024
X-HE-Meta: U2FsdGVkX19HtaNnq+FrO+VUX1Rh0ckGWCQAof9/uaDl3rjNZUcSK1rIX/HT5pME+XzdAVM3ehB58FZWCcg7f5Ba3vFUq2t3GHvOkhi1zjrEtOeFVlA8H0Ryc1P7rKcqfqyn+2NTVY/yd81hRk42/Y9vTzgg0G3pGL9GIAKivujUF57u0X1sS+WaF008HvLS7K8iOSKVAV6Hk2HpFsmYqYTpbDApF9brnTmPk9Q+h/KsR/GhICACwSbYZS70OTbP/ybIoMZ+zr9MKa3T0s88vvXiM3waytBqoe2dja9gP4FGWtuQhPCEfUPr8yE8+J9c/7mT7JDcNbSeExGTpuGeNx5+b+pWE+OnTINi7P6q7FNWspProEocxEEBj+NxRZSX/UWtKPfGl5SdtR1gt2VPTHQCW7Ruh9mAHdo4COXlpy7sUWlndAzrHldfKlseVTF6ExtrH7WuvgyYkvZhXIB2yCAtc0QXWeGgnGupJgZQ3F8r0+IJIysRcKcrAfCmkt3h7BG78qQH5atYsdUjNMBCjvfvVyJGHveSF5ErD0l8N8OsE/LrPWwikVIS/Su8eQKSNH46opPB1ELLlraMPni/VkPEVUkciUxr2acPX+tr6XQ3CaL1w6e6GE2Ddaohe8w756gQreWcAuToQbptjwoZdWjcIb9w6fBtz8T++DnLJ5z6UMOYewjl64ghY0VVz/vhyDgvmWMTejXcnHfhfB4lGMs1T/Aaytr7B3cCVzRKpCGuAhmTXMP/CBCPPk08+0Ur4NemeffxcDQMxXvzWDBkIanopcZOMJ6ceowY2GkMZReZSG7HNtUF4N1yh6cB9j6QDBBnqNE4fVNa/zdrj/QgX5PL22hPOVYaHhfgVg8f74N/ilmc0+DgkAXZFbUQwlTXcK/Z+8iT+rwyiCwP0dX6sWNZjNzilwCzQBkm+vBD2n62W4xk8zVRevK1GBB8pvifluvMTy0LeofUYdir8NQ
 1Q5+o+/e
 gX2jrb8gzf6YhvUolSIHDNmOJS/Rv+/rLAAO8iCs8pn0PlyESkNzDrdhMV7+/572L5071jp68g9AXM/IXE8dhbHFcq5pToLAlu/tzvS5ggV1cNGjlKMbUHTcZ0ddqWEVCKk7QZ+kRgZFHsVDQ69dKptvMof47HwEurvi6H++d/pOu9nlZqA9aqYB/HsM7wfpRMc3l7rJgujCpefB2bRNemPOMlrnWTFV87lAiIiORVUJb/05Sz/PpesfglleFdkElcGHSyjprtPaAnB/nrw620aAs8WAC+Jv0/IFRJsyY24UPV6cRxOy5y67XNbvlsd9qYef3biRqpvV+HrWWRLIZioAZ00XKMLlRtr2biz9LVM+SuXjsrgS2UY5mpOft8IdVLAUMDPJk8mT+MPFeV0oyVFjEckgko5UPatKyqTLxibG0enkycismfHY1d/hEYfjrBCzchF3sMTAb8ROy3F2TxfacWe63FOs4Xnv9TACdxpGdphyaxClTq5FlhaR8RruFs+1RdKnIhfFcLIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Sat, Aug 29, 2026 at 5:10=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.co=
m> wrote:
> >
> > On Thu, Aug 27, 2026 at 12:56 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > Makes sense.
> > >
> > > Actually, this led me to rethink the slots reservation mechanism we
> > > came up with and the issue that Sashiko brought up initially. I
> > > initially thought it still existed, as two racing threads setting the
> > > compressor could try to resurrect a newly created pool. However, I
> > > realized that's not possible because a module-wide mutex is held whil=
e
> > > any module param is set. This also covers zswap_enabled_param_set().
> > >
> > > So IIUC, we cannot really have any concurrency here. Pool creation
> > > either happens through params setting (protected by a module-wide
> > > mutex) or during initialization. Does this mean that Sashiko's review
> > > was a false positive and we can go back to directly assigning array
> > > slots at pool creation? If that's the case I am happy we can avoid th=
e
> > > complexity (but sorry I led you astray).
> >
> > Thanks for the patience here. I wanted to check the details before repl=
ying.
> >
> > Agreed, and I confirmed it. param_attr_store() takes
> > kernel_param_lock(mk->mod) around ->set, and for a built-in module
> > (zswap) that resolves to the single global param_lock
> > (KPARAM_MUTEX(mod) -> &param_lock, "Protects all built-in parameters"
> > in kernel/params.c). So zswap_compressor_param_set() and
> > zswap_enabled_param_set() are mutually serialized, and the only other
> > pool-creation path is single-threaded init. There is no window for two
> > threads to resurrect or create the same pool concurrently. Sashiko's
> > concern was a false positive.
> >
> > I also tried dropping the slot reserve and went back to assigning
> > the real pointer directly at creation. The only invariant that matters
> > is that the slot store happens after the pool is fully constructed,
> > it's the last step of zswap_pool_create(). So array walkers only ever
> > see a NULL slot or a ready pool. zswap_pools_lock
> > still serializes that store against a retiring pool clearing its slot
> > in __zswap_pool_empty().
> >
> > I tested with LOCKDEP + PROVE_RCU + DEBUG_ATOMIC_SLEEP: an e2e
> > store/load workload + compressor switch (lzo -> zstd -> lzo) that
> > exercises both the pool-retire and the pool-reuse/resurrect paths. All
> > passed, no lockdep splats and no suspicious-RCU or sleeping-in-atomic
> > warnings. These are functional tests only, 2 writer races can't be trig=
gered,
> > since param_lock already serializes concurrent param writes.
> >
> > No problem, the discussion made the concurrency model clearer, and we
> > can drop the complexity. I'll refactor the code and send out the patch
> > in the next version.
> >
> > > It also makes me wonder if we can just drop zswap_init_lock, but
> > > that's a separate project. Most of the zswap init code needs to be
> > > reworked imo.
> >
> > Agreed it's separate. zswap_init_lock guards the zswap_init_state
> > machine and coordinates the two zswap_setup() entry points (the
> > late_initcall vs. zswap_enabled_param_set()); the param lock doesn't
> > cover the initcall path, so it can't just be dropped. I'll leave that
> > out of this series.
>
> Agreed on leaving it out anyway, but doesn't zswap_init_lock guard the
> same paths we just convinced ourselves are already mutually exclusive
> for the purposes of pool reservation?

Ah, yes, exactly, param_lock already covered param writers, and mutually
exclusive. initcall also precedes userspace sysfs write, so:
1. zswap_init_state: initcall has resolved the state, reader is fine unlock=
ed.
2. zswap_has_pool: param_lock covered. Writer also holds zswap_pools_lock.
3. *(char **)kp->arg: param_lock covered. Write by param_set_charp().

Best regards,
Jianyue

