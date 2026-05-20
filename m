Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3671FCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887396B00DF; Wed, 20 May 2026 12:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837616B00E0; Wed, 20 May 2026 12:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725956B00E1; Wed, 20 May 2026 12:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE806B00DF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:56:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E10FA03E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:56:17 +0000 (UTC)
X-FDA: 84788401194.22.C60F173
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 07C1020002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:56:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=MOk+VoMG;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779296175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sC7SWolRbuUdshWOQkOX3Cj/rVUaA0lodxCKWtaOJ0=;
	b=2CHggDOTX7HXnEQ7OneaaePIExHXkrjOEGtrFPDwcWYobjXkhpNhTNxrusJyfAB++Pr29F
	jNrbBgWXdkEjka5ccezZFcncl5+KmwxHET/jtoug8diKwDnk9u5V46+lEpH1feeEq3yCbo
	jLkuu9OuCNx2UIlTQXuwmMrAWlBlD5M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=MOk+VoMG;
	spf=pass (imf31.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779296175; a=rsa-sha256;
	cv=none;
	b=e+Z/TwUWS++TYqE2JxI9mbxHarcjt1pxYZpiUSIOqM/Xm32bhGu0aYaqfGf52ynZr8ykeG
	kz30Y+ffwXLLL6p2S3je+Yxlx/NOUXv9PmLoabaSQVe14+AzBsh+KF8zJk6/SSlrqmaJBm
	lJRg5IVME7DuJ8qMDrflHM9KV7b2Udc=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b936331786dso666992666b.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779296173; x=1779900973; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+sC7SWolRbuUdshWOQkOX3Cj/rVUaA0lodxCKWtaOJ0=;
        b=MOk+VoMGosujNmRfd/c2yX/kswmOH+5ERp+ZWKKS4MconpmSr7DaoBo/k1aUox0Jr8
         txL7LT9eAH5d2DbaJMX4vUcf5CstDoQFGKoDKBD3FIu7VSuB4v5CAbWOBSIU/OOX2GwQ
         0sy+TcVd2FIchyXIxQv7gpmaaX+sFotegpxMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779296173; x=1779900973;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+sC7SWolRbuUdshWOQkOX3Cj/rVUaA0lodxCKWtaOJ0=;
        b=LZxBil/en21KX1Y3ihjICx64r3FAG5LupmvvJPUTRR1wzhdHVmvVP7HrLyHX8cYkum
         AbqOMl7t6mwX/j2Z0LG0oNBtCNAwuGTvV7Wl+Bqfi6DBY33/qqVBKKMYstVlNdNt6j/+
         LgWcXzEIKva8DES69XlbYpIlbapZbrfIlY29rlbdKNXo4S9MfGm+xuxxQup87+8i872t
         eElFnuIJz6JILLxMp4nUdolt9LbYkHv4pK/GhsM2vDM70VcyFGGbSmle25GcGUgQZONX
         zyYDHSCPz/SnyAUPkUsDxa4XAcgPMLo80JpYlVNkvw+NGbreggsvZagVirpPyiJGE08K
         5hrg==
X-Forwarded-Encrypted: i=1; AFNElJ+N/0vxfmJJ1qPWJ7XaOZgVtxCWezF9K90vHB0mta/D4CPJYzuHrxDeH+yvsu8ssUhvgxS4ax6QDQ==@kvack.org
X-Gm-Message-State: AOJu0YzDiBhcYE759NKt0nEY12ycxkIQTLJxJ1MifK0gSKpQIXw4hb6Z
	A3h02Pk4lEsaHuDbKk3dlJDaJeq8JQs1R8//GIkVLyNluhm54CKBfmBfOKjXNrsL8RVlOyt86Ix
	WLvKz1hkdNw==
X-Gm-Gg: Acq92OE8GnX7zsM0IGcteypH5dZvUU18uS4EyXWRIeNBjYZFFroxG3QUwqTsexnHRrQ
	GjbG/bL3ktewIuHkmc5NoEz+ZUL84TOBQRdBEqApBcu69+vSmeqerO30Z6H8I4NintEvk72hBS9
	8sEbaBsN6hoDtPydQHKGM8lM5U+8HCq6H/RLij4XDey6srezPdXgNH4i/jmlu6Z/E8hMOFKelt0
	cdveyQ2ZHnPGl1UuYNouQg/ZDTaRWcY3fVMK4AV5zDY0HdfgpNfM5IVCaBez1S/3aj662mYFNhJ
	9Er5qFttBEBndLMX38teLiAon2hXTTyyMVmE3DavSoJ/YDgq1bENXELyMKkpFZEkuvp4qBM43pj
	6Gp4v+gOsuIKo0GTx06LNdU4qKqqL+AFc8NazygkcUDy4ia08Twi34SG2l5gdFRNiaZL6wXkj2p
	AqSRDPBh6zRTC6ip40HpYeO+HWpm/OJer8I2TMSadISjFpahtS7hs90ixVqv4O1qdICWpYOUE=
X-Received: by 2002:a17:906:9fc6:b0:bd8:5ef9:9b34 with SMTP id a640c23a62f3a-bd85ef9a07bmr737440566b.48.1779296173291;
        Wed, 20 May 2026 09:56:13 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6830fc1a0b4sm8202911a12.0.2026.05.20.09.56.12
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 09:56:12 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67c9616b4feso9198599a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:56:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9X6/syyKtg8G0V2qGrcLMhnMzg/q3ON6A8oex1UUSvOgLJ7KJEWi/I3/4d9/Roih2kwmdwKQN8ng==@kvack.org
X-Received: by 2002:a17:907:a688:b0:bd9:23c:8ca9 with SMTP id
 a640c23a62f3a-bd9023c8e34mr636057366b.28.1779296172480; Wed, 20 May 2026
 09:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com> <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
In-Reply-To: <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 20 May 2026 11:55:55 -0500
X-Gmail-Original-Message-ID: <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com>
X-Gm-Features: AVHnY4JgB1LltQ03cncQjpEC_gxFFxfx7IiNDZ8BzAGdlc5I8bw_T0evS0zNkAk
Message-ID: <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jdc7u6ffqj51tz5zzx8xbkcyqemn6yf3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07C1020002
X-Rspam-User: 
X-HE-Tag: 1779296174-103368
X-HE-Meta: U2FsdGVkX1/0AkKvVqfB3b4L1pBEI5l7fY97UxKYXP0S94HgQ2ErNANDSEjJsPreydkLVOD/45hvZ4E6pXws5aTw3y9ZPbvAy9M2BOc/Uo8g5Zs2Q2GUVfSRNyzWSZa/2ZdAeih6IpNjpUHxJsJNK0SMFWhSPVqOhboeTpQD2PxIeLfjD3AGljN8UZYq8XXiU+QcCoQlgI9grcfjOu32EExafGY3q82+EYVFG2mYebFOtcO44rc13swnekrKVBHyGgMt3UXP/5wmko9k5pvp1g0DRD0oTeN2e5Ac4LPMxDKHJoUv62jSqZ3btI+USUCzSKRFsd6WVUdZ8pGkxqWgchi+vMpbqfRTt/ozV/OX7fQhXgZmcRNeW9dEM9bFiDyo1vj09AOGYbEozE9eUTzcNJa+6Vym2GCFuLaSi8K0lIFg3x3viRzv/Pi+uIXLAnkfTAEF028GfRZUqBQ7husVhVSZZm76o91q/DDQ/VVsTvjYbemIhjukmgEJ3xx/EcRrqeJXyraquTizPn7zW9trNYHJx/mJ3M+eMxxUngXRI7+wvA2W51LNA96Wb99a9D/3gzpmIk2nqy0gOTgAV2IivkauJNB9kIZCBXdyYZKyDg710mTCvjmXtbEb0g065tGMxe3/3gOFLjRAXj1r/s3V2+mVjymQXvD2NmueSAzFPZ44NooYDcExZ21jC4esqf9ZNqA6eFRd+aa/PMfflp7hbUmtC755rkNpbZZz5mqrx2/oQtLtlQKBzUs80AiLo4WQ0kr7dKwNt56TiID8NVatDQbas+Vh5nbgmEp7vWDWKoyrCnwZ72+7cocioNoVTzRH6AZh+cv5hUVEOFJXAbZmfgp9xBo70MhcZH4Ryz4hboJxGOEEIs8rtlO0K3eoCdabMDHl/1yzf+gAHfVMZwyiKa2s+ae8KqrBpJtI66HviCLA8orZtfQaKAzA8XvxSax3NMU89tIrWtYxZ4Kt1bY
 Ae3/F+3O
 irDgHVXs/GpMxeE/PiEIZLChMROq9N/SHDNTFBaHpcLeqwuWiRfCMTXKplanXmvADjdAxtrnv0fIPIxZwxFsXH1SSND/z5PJpTz2C4w2NFDOXQ7glbW3sr2IMaUBq8f57erJJ6VwUV0j+QRpvOI5vbauX8f9U1PTJFuStJXjaOtdn2BumYFIJrVTV8Ef6v5+Frq2yO6PRvUldhkxVQ2FCs+X36Nv05o1DKyYNU4Zyc5+NknnL++mjDL7Dj6/p2rF510NG652004hgTxE+vRzs9ZMT2pxww4fjXm4tcW3M5fT+JgxqHeL/dCETb0UDMSdQoXbzqufAsv25Np0FZYZbfQZL464ZZ22rzgljHXGLYTMxEzWTx2905LggflZEoRckY3uhXbcTH4LVBkV36CSwvOrQWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 11:52, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> Right you are. How about just modifying the rule to saying that
> prctl(PR_SET_DUMPABLE) just always creates a new exec_state for the
> current thread?

Obviously we could also make some clone() flag to do this, although
I'd rather not expand on that interface..

I guess the good news here is that Android may have more of a
"upstream first" model, but I think Android still has lots of its own
required infrastructure anyway. Is there some Android kernel person
who could pipe up on this all?

           Linus

