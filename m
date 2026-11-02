Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65336606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=ItL3Zdmv
Received: by kanga.kvack.org (Postfix)
	id 60E5F6B05B8; Mon,  2 Nov 2026 03:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597BC6B05BA; Mon,  2 Nov 2026 03:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4603E6B05BB; Mon,  2 Nov 2026 03:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF366B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:33:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A2AB1A0C7B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:33:14 +0000 (UTC)
X-FDA: 85389514308.18.8F2C471
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57EF440007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:33:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ItL3Zdmv;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j53l0fksxsxqGVEYV0vEjuguCQNdT4wT6diFHQR+URA=;
	b=bgtDun8strfCvRmRRzxu2KLS924HG/bVT904/ZEUEl1ti6IeDSGGPSPtOitkftYq3Jzn02
	isdI7wN0wHiKZrAWEz216f1JgwqpOjQhKYjrDA1jmco7ke4f6L9erJMXlV5AEgdL4Aw4dP
	L+ig7zDmTglgDsUmiq48f1B81CTXY5M=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ItL3Zdmv;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793608392;
	b=kcXXJRo8ztToSUVVWnQktSibwH81tHF8j+RTAxyRBWQzje4uixJAz2i5ghBIWqcmMbjryt
	C5lu8QinSFVpSNqXW+6v0vWAd+95RHW2Owyz+iw9IB4s5UTGkmTuQmmG0k9U/Z0kAegnDU
	t2NfRhbrPqwfL/ABhrixPUSwUwxyfYU=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c46822eefb6so366447066b.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:33:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793608391; cv=none;
        d=google.com; s=arc-20260327;
        b=oJf89QrACRas/6EF7Bis5tpcNxRoSA5VOC0rpKO9TpwswOTnNU6Rs6WB52pQeAs75p
         tUpeZTYSrgypQNbXthcumIlKCrfeO7QLPWSu212FPo3zWouyVCvo4PEvBfZQDLMjpdET
         OlBxcyntOS2UNRH4h20u++NS1QWpI9ZXweF3DOlC4lk28NBN3HlEdeGDQYOVeGJRZ4tG
         tDEoLmoqf3n0WFS0zd/mQpYyhu6/9ktkdN1uc0jAaV0hF1xVShwMCaeodAisRtuPfLf+
         qkdHJ0XvyOsEK29zMfuWOoWYfNwMQ2mrKnzUTPPxTtBPE9AYljM+CxYZV80vjNvzv8zN
         yHuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j53l0fksxsxqGVEYV0vEjuguCQNdT4wT6diFHQR+URA=;
        fh=ehX6s6w2C8mn3xElURdJa5nDvfly5nNLA5f/zHGlpCs=;
        b=iWx0hrgDgjA/LedCXJD4j3nPeKdNT2rcGEh2J+Vw3vNQwtBiMxuEqcDFZmhz9aBAfI
         6qjFd3i+1RITKKG/5RhpH9HaZLuko6Erhoz65WSpf1Z9AxKj7D7rQjqCvkGjSmbFYu6k
         aEsB29l9Rv9m3ZEVVHRcWd6/zvbQ8w0wKaA/ITF3x+FgVcuFLw27lOpT572oEyrDTF2R
         6lHB7QXkV2fQ11kEN0jupOpiXwrS64k967XkcLVsX8keSVC4eE1yo/c99A0JMUWN6lmV
         9AwABoAeftWSnFS9hwliWZoWuEPGPx1mV6ZnEEuoTl91q+qBs7O+08WZBykeksTc3jiy
         3MtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793608391; x=1794213191; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j53l0fksxsxqGVEYV0vEjuguCQNdT4wT6diFHQR+URA=;
        b=ItL3Zdmv/MDZA55CugqFVLjUr2fovztZcVS8L0o7RlM3w0EtL40CiM/9Cyp7B5KprX
         GzOHURLVXRf6rQkyIdI0oAXho2Tff848qyLzau/DaYQyZsK20m+wmbaFQPL3gGWXIMnF
         sfgnG9nABIguFBDsCi6/+706xPNUYWvW1wVSg0EgMWv17DvhXwaSew7KnGPIPJu1Cl6M
         h5sr8hqzp7AfvpgVz+nmiJlo3kLlbV3Qw8hz9enhpSR7XBwp1ebLtSkWXfzRKEsbI03H
         L7aCMQae29H4ox9BajL9XsBDKtg/a3SSFJwWmdZeYlFaXuc1UDjGlq4cTC6WdO799tMK
         QPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793608391; x=1794213191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j53l0fksxsxqGVEYV0vEjuguCQNdT4wT6diFHQR+URA=;
        b=ZsqJNdb6SN2Iz95MSkBXM2Zs6O4536OPGXTjxGdDoFWZez1ULPGZYZEbBvS87MgFs7
         ZXP07Yk6Xu38WmicOS1momY/ttEhGXhqYtoW7w849S6oobeGaDdjUNijmHhCb8tJyKmf
         5cETyIVPIQ1LdRKcXTCsrNNF+IxvCj9Eq5utGzTB6KibY+TFvoT4iDnk6efx+EuL9CR4
         W5Ok9NbiddCCgWJSbmlqcmrsQhF0vQM26pRJydFPz30l0w0T1KDn7flEMN4P+B8vZkna
         pm3P9t8gaYxcEq3+dasNODu2wvYvBr7ibse/Nu9ZR1ydinXbS1035euJZxjMZWjHsGuF
         0seQ==
X-Forwarded-Encrypted: i=1; AKwUvByFDwZuPd9Rkys3v5/vkMECLnZSRS34Bfhh8cNd6uUKVUY6nNAeVUMZo6Pcs7XKPAvFqzhcZylqwQ==@kvack.org
X-Gm-Message-State: AFq9FYKmpTJGk/MT7DI3HMppX1BePkdrrxFxt3Yfhs/ecxi9XwRtFqnk
	R51hWFE4isBSdLlb9iLEIKnbbd7TxXPtbuG4Zb5rZMOUaeidk8Lo6ZIEFlTnRGtcS/aoWuzlC3o
	TfdsVi6T4l5L8Ifd/LecUNOzRo4ymXtHhpbTgWy17Qg==
X-Gm-Gg: AYBFou3BL4x83muGsi4yZjFaIgxFZtAyZLDeKPsMK/sKfYQWS6sYLDz625DK2ArnJRg
	/Oi4hB9UFsiXmneBFmqMLJxog8pG8XW8ieny3ys0SnXx6mImuMg9CrRthoDYfy+d7uWV7FNNedm
	LxKqQD1jsBqVVSPZdcKK9sPV9XbKuTp8X6lEcx7/gRDvqsWUW7EmAduEyKpnOLV6doAUaxzWEMd
	vIcwd1EwwT6xiz4VkaX1GSqZuReE+IxeKHfNB5EflL7MSzkgFW5ycaM4r3RhM6JEEkCoHTj/fSY
	62q+Ju3UIXyhwUtcv6JkXqCQpeEySjkQPaH1a5VWM+tbLyzwC/Pzn9hVtSLiFesTj0XJUigUxiu
	FqqgK62Q4EknAQEvxlIMQf9xzrw+CVqxoq/PLDaxnzOF4gAMVUmDOFhSZaWCW1u7wUw==
X-Received: by 2002:a17:907:d64a:b0:c3e:f39b:2298 with SMTP id
 a640c23a62f3a-c4ca7a0dca5mr747330466b.16.1793608390908; Mon, 02 Nov 2026
 00:33:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-6-max.kellermann@ionos.com> <CAGsJ_4wbQtQ8zfokd44_QM39J_02xDVJoeTK20+jo03_NxAx8Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4wbQtQ8zfokd44_QM39J_02xDVJoeTK20+jo03_NxAx8Q@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 2 Nov 2026 09:32:58 +0100
X-Gm-Features: AclHuK-7lS1S6JyZadszv7IFLH9vh-tuiPb0pQtxfKPOHSoMU2Adf-ZEzxFVxhQ
Message-ID: <CAKPOu+-NG4sOXVb6xTzVtJJLK4LMag+5GWwY6=7mgSKnp4ZNqQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] mm/mglru: reschedule between memcg reclaim attempts
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 57EF440007
X-Rspam-User: 
X-Stat-Signature: hdf5eotac88iartrah7aq56juao9mc9g
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793608392-932427
X-HE-Meta: U2FsdGVkX1+9HwS0wLpKbzQtUel/rbNQffVUQjRr0BkYbf8YYrgmYjBVNlndyP59MJNUQiMneQo4MDkIrQRyeIl1hFuSwW119lzASzyU0u+whJbeCEQ2jO812avEbkeCnlma3YVoec08XKQa7orLeZTBiTFf1doJCGOJ0EVZEImX0xItU4H36Zhjm9FSnJrngsvrZ+esib7inOLAxc9jbx8MRXFGujnaH4aWr9LS8JCIaeRAZVaRn0hdETVv913DW9wHX9bTWJ0LNqT24UYvKXrbcA/hr0/GlcO1lJ+rQB5Bs5Ba+kCH2df/yMI+wNAARdoVUowVu47hVD/9WvRFyhTO3wjaNMgMrCzH4BwtrFNGMQ+qoVUCKf7xLwGxUb1mTiyig9fRYDEMepOt8U7OLdq0wDav77NvSjMU7SS8vFZb73i5KC2e6I7108GbuKXs2iBcM7Rr13inWQfzbFemjgEtmmlkdVYlhz+04yw3ONs5Q9AdVtrXiKCoBDLltv9KogWcRsR1iuXEEiS4FFHPCCmWwiE+5ZdEH1xnXO9fveCwRqgCedbKFP/v7bF1akwBAaOvO9G7qseLkGZ349zGGtzpJsgUDEATQKGPvlL6rZ9sFWHWlKA7yMbd5SNScIZ2IWUayLOTdu8h/nTbtxhql0hkEQyT6ck+C+vEESvcBqPDFCKBsVMymNmjUXKavjQmyHp/Myl7bHZ4+vJOFnx6H/B23Ak+r8kggBgjaDtkhJhbYjgoYqR4LnDUGO+pviwJiSNOzDb+7Ymv1Xi/qlbF5c65WIlbOlI92uKup9Qno1u+xsPCZ+UWDT6585lYxvNAXC56ODgi1JlwKMmcMy/N4KTydImZRhue99/HGin9VoLvxcAaFmE9SeDFY67vyvjs5grkyYiXZnmCRb0vwK2jn/HPpGIONonF3xoMI7hNhwdvHzxy8/uhnF+p9LeVhLstTANpyRRrTPt/F3nddTV
 kbKGyqqq
 elKLWJYhgX7+rxz1+T+ybFZ5VIatf9ZjB0iG0dtP4BL0FxiyMTHTc9asPs4S8cbYk5+uwdl9PZEIp5ZGSH/4DMtNcD3A7IWWsxk9h1KNjzxaiNYf1U9QmO5Hf3ma59bQAfP9XY7IZgC6spgWpnx1/4QoQWwM+RElcj2toht4CC6sdALkxpsaGOmH1umT8I9Ng+veZwV0CIIw2oMOH13ZwjFpcdZbN9OvgUM/q7twZgIwKTgxzHYP1k6cReWRdNQQzzPSUgIu0anp8bbMvdPhARt/H3He32lHwlCcEA06pDmRQV3XqeEXy21jlFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 2:15=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
> I'd appreciate it if you could provide more details in the
> changelog. Without this patch, are we seeing an RCU stall,
> a soft lockup, or something else, right?

As I said in reply to Andrew already, I havn't proved that [5/5] alone
reliably makes the stalls/lockups go away. I guess they are gone
already by fixing the underlying linked-list performance problem. I
thought [5/5] was useful as an additional scheduling point (similar
calls exist already in mm/), but I'm no MM expert, so view this last
patch as a rather uneducated suggestion by a MM newbie.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

