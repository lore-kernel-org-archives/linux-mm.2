Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1E2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF6A6B00A2; Fri, 10 Jul 2026 19:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70676B00A3; Fri, 10 Jul 2026 19:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986046B00A4; Fri, 10 Jul 2026 19:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70FE26B00A2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:37:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECA1DC3C5B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:37:22 +0000 (UTC)
X-FDA: 84974480724.03.A0F9BEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 173E016000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:37:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjLh9rRW;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783726641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxtUTG9YppWBtv2ok8CBY2pxzZOnUJOUZB2IWQYK9Ho=;
	b=RaXmgckbHNi/8HSeSSM/Fay4qs9+jCQHcIdv5lFE7id/0xaMZ2t7drNRz1ng9Tt+YV4sHB
	g6HJH2Ez/KfpiLgnclAv9FtG2m1DVqhbzGuFVWkssXszJ9lTg/f4bmCiYgGriJ4nfe3y68
	xvxKjsO/uipl5lFmZnIrVpufnw71u/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783726641;
	b=Bxye19K69vPLJ+UASBSPmNmUkfPEx2Gpqf7NLUYaYXzvd6buNxfVMvd/amSLR+l6ykQyAf
	UwGViyM6A9q00Wyv7Qfcg94ce1wzLiVtB02vdMQq17OUNhYnc3jr0lvmk2HH/axfrVV8mv
	8tK92htmga+qkkjIOWlfNthZRWJqYGM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjLh9rRW;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AF1E60051
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F0F1F00A3D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783726640;
	bh=wxtUTG9YppWBtv2ok8CBY2pxzZOnUJOUZB2IWQYK9Ho=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hjLh9rRWr/DpxB8oQDHPy7S1naRHyHTX90Y3NceQh0Nv4LISXIITi1UgUVKejpq11
	 qKbI9fTxV9n5aBNPpB4N2sz8XK3RYKrK03HrfXZEFZSajcuPJ7aeP3P2eoLVEguCDm
	 v08qVP63orOw5mNfqh56gLer07/jIi62lDYBI99Yb24fGGpbCLXDiAbmT7l+9PPJ/b
	 sk/larsurN/OYGcLpGLjSseJOW1L3Fa/x8E7cSErRqWl16fk82eueL8T5Qbb/aUg69
	 GjMOEIx4UQaKy2nnrbdsoFHAi692dOlpJoK3RHr8+vVO9G8FecfyWnnBe80LpIhi/Z
	 GMz9BFxhgfu9g==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ee88fce476so15263666d6.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:37:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rodalg7otXFNFM38xEiJKAFFkX2Wgu1otwUZmS50UryT0xSu4VqKyTkMILIO8XEo9nJJFs/5qWWAg==@kvack.org
X-Gm-Message-State: AOJu0Yx4uUmEyxm/K1eTOQ0atcGeZ+YIsQXPa+0mteOGPUWx6aE2GUi5
	VH52CAf6grr9hUYUM8ma4jareZ7NirX4YLJJV9wbO+CeXw7CpvvRB1B3y/oMUe3saYGm/ZLz+O4
	uifuAUc6kpyX2duqd4meqW4vodkfwF00=
X-Received: by 2002:a05:6214:483:b0:8e0:6afc:38c2 with SMTP id
 6a1803df08f44-90400f94eb6mr14264956d6.34.1783726639609; Fri, 10 Jul 2026
 16:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
 <ak0Xl6q52exX9sBH@lucifer> <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
In-Reply-To: <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Jul 2026 07:37:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8WH92WMV3V6Yd6+Q2GKYfTyw3PbNdBSQPTj_hcpz93A@mail.gmail.com>
X-Gm-Features: AVVi8CejNqqZijPXmSP-NpafY-Xdlwlcu3cbFMGu23FMXlPcAciR0V_dMYX2yUM
Message-ID: <CAGsJ_4y8WH92WMV3V6Yd6+Q2GKYfTyw3PbNdBSQPTj_hcpz93A@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, shakeel.butt@linux.dev, 
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 173E016000C
X-Stat-Signature: ki6b7cgra156iwbdie4fmj88sy4ub8xw
X-HE-Tag: 1783726640-681722
X-HE-Meta: U2FsdGVkX1/c1LNPurbPed0l8+TR13VqYJZHVpLRSzdB7QUAr/361FfqUjYyn0B4Jj66nG2RJiOZuyj3h3f2Dqz/LiyaE4MhkJwdiCdcE+rAIcXgS3o+BziWSB6VkHRpXlARUypezPRhXvQaKrEux8+l75lFzjCS9tq2FqAaemcMRL81Ny2R85p9Z8rR+z+X/B0KbtIbL/+MlNkrOS35k+TadHSPJx20/HQKs3nxtHqJBWOgA0GK33d+X4c2OPxuGThxmwnqDlEdlZJ2iToRkpnHrbSZgxL6/13n1y+3T6rfheuuxU3sCPm/lcvei4qSveaVt/2Y0520H3cXizmep/ck9engIObscs52zhirZR1J6iIWXfuHkuNr/+F+aLWFbnBHeYfV7HUrLeYOHpkceaW6BUs67bJ3ZmQoiMyWF+7ttMDyNPIOzOugRKMowWkfgiNb9BR0SL+f1qouZ+EcyfylvVDt4JH6RgvAa/u/BDwCOu0hNIy7BPjejWEsx/9j7siHZFjgC+BPI0Q69SBXSYHyN5Z4nEXCe85OdIp16YvFor4Xs5c5hw7ovp81V4S6igq469ZQ1jUtVXjjCo6aSecSwJC3ToZmOXNXCEVdnBivnDlujiEpOHg2UDhAG4bE9kizg9O+MOBtlNb9vDya0BVpWpQbPilr5EaSBiAEE197drniJuOQivs3C7FIoV5BeTVRab/WXFz0qd7eQ2iTyb0RanRASNkLF6m7G7UNPWu2Qhc7YsKUeZuKAJ5FvJ4UaFk2HpZAsx8f5CQeK9hnhnKVtMWnNFkSzP+wk058QYlc/oN5Aq/e4RpeO2YFT5LEIAxiG3tTkDA5Jfa9NNArx4MQMg7LAFPwDdPpune78mLvTXXyre21fvH2RNpQmeILOJIEhL2FQSEngnEXvgfh6n71mYhi2QJUfvZmjVhErsdu3pSvlBORSMVUp6VSL+rSXcUs7WUBDtoikAdgmp3
 BLAIXGPQ
 8mED2JL6TxptDFYm63xeY9pfrvF+J8n6LN8UCb3BkyzxYpMboc/GSKlJIOq/Wl8NA9Zm9P2H4sJTn4FKl+G/AVuCCVjsabqHxggRXFDRWQXenUBHyqczIsmHgy3VxmoGbmcNqjpg1e5QfoWNbhz5Qk0jVpM7aZLwGEgCemxPJxvHlDrHQYu7XlyRFvJ8T2wG/htrpuSygbYf3CKllNIfPrV1Erfart5puWBn6VVZaaL4vodvCKZJqJBhrfuQVWSkUYjfIIVmHnvHpW7ix/T189Hgm7/w6FkkQAOMknBKjWpGgiLl6+4CaNOP4Y1UvYnr2P2I+4sO5ThxXCZnOxUSC7uzmAJC4SNH3pXo4/kadPySrHn1q1vpT5FGH2LWeV714XCKy/53v3rYpkQUqG8sK5oHitg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:54=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
[...]
> > Have you audited every single VM_FAULT_RETRY case? Because getting this
> > wrong could be a serious problem and break things. You should include a
> > list of call sites in your patch and explain why it's fine in each case=
.
>
> That's my main worry with this patch as well. I think a better
> approach would keep VM_FAULT_RETRY as is (falling back to mmap_lock),
> introduce VM_FAULT_RETRY_VMA (or whatever is best to indicate a retry
> with VMA lock) and then convert individual VM_FAULT_RETRY cases to
> VM_FAULT_RETRY_VMA with proper reasoning and explanation why it is
> safe. Less churn, gradual conversion, and happy reviewers.
>

I am not really sure there are any happy reviewers here.
VM_FAULT_RETRY_VMA and the gradual migration to per-VMA lock retry
are exactly what was done in the previous versions, even since RFC v1[1] :-=
)

[1] https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/

