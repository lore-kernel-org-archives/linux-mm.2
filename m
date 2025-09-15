Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D95CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F668E0010; Mon, 15 Sep 2025 16:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7148E0001; Mon, 15 Sep 2025 16:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD0A8E0010; Mon, 15 Sep 2025 16:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5318E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:11:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D26F4C074D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:04 +0000 (UTC)
X-FDA: 83892578448.20.7435B80
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9559D40008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7yADzXGocb/qE7uG5osiTyGOa5Q91Vr/vq8cRHwFCM=;
	b=NMfI3TB4cl7klLkPHHWy+JzRP1WXUmoFIenrjORUjXM+zBr1FQ6qQa88/xf8W5oXunFuLj
	5DDqtj/iyXAOK6psplyfGXW3txPas4ydlpXavihbvo5/lMpt+A89Gy95Cc94mXEA8ktxgc
	AcJxs+BtBqVeXjRB2Mf0DVCObe/vBWk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757967062; a=rsa-sha256;
	cv=pass;
	b=FvE0vIxchigPTYfduQNIfdMD5QXK9dfqmlRHxzKwrKAPAhcruH76CeGREnWG4oGZm+TxAJ
	FfEEJo9MKTtMve3gS3WmhG9YzzRu5/mLp/n/Kdp61ItIy+nxpR+BqXw2GosFWX7J+oLzDp
	EdQth3AKcv1WeMb48kcfZB6SPfPKaP0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 281BA160521
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:02 +0000 (UTC)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0128C13B9D7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:01 +0000 (UTC)
X-FDA: 83892578322.25.FCC319C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BC484000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7yADzXGocb/qE7uG5osiTyGOa5Q91Vr/vq8cRHwFCM=;
	b=mtNN2yh+CxNpCv9Jyzp9af+mikCSh8LVFtp32IED9dk2t8pyBGxhVTxgDQMzfeH8MFuIGc
	bd/r/uLKst5cfDCIXevNPazimkSWIFb+XmhJ8PKd2A4tWjrtP5T04td6a0XBoSfbhWBSgY
	MxwDT2l7LUHzipXp7B9U3PNoIBYtEYQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3px0v3+8;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757967060; a=rsa-sha256;
	cv=none;
	b=f1EqW4D1Qbu0LmytHzyuCc3fvQ1slTnRJ0zN3rZe3o3rWn/BEYtHHx6Bd1yjZVQSjeaANZ
	TEwTJPc7qXEyzA0YFC9gojeiL7I8RVgTY5dOIuty9/D9HDO0n8Nf++62uZPLWMgc7fOcW1
	YE7tbaHZujwNKIPUuDLqx1Cw+4ZjMqI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b78657a35aso3511cf.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757967059; x=1758571859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7yADzXGocb/qE7uG5osiTyGOa5Q91Vr/vq8cRHwFCM=;
        b=3px0v3+87kIqb2hW44YfBxoUk6ZrbG+yv4E9oftLQveBwS/nIEAG57+aQ/qC6Q08nB
         xbxueMMkH4IBfYISlFuJt7a6GQqw8QbqhVuFBJtPXjYWCbjdQt/JrlYyhRagwOBPGTaA
         08Inkl7B7x+jkZUI/A3PdYH+USuN2aluHJOXePoccNGbtwMwqOnmKXkvo9FBJAOQtoDo
         VfhpcC6ePJCkpGpI2ZbNXK+CjXA7ZUjGHEDRjxlAFhnG4vAlpopX4GmoeKjX66GBC1u+
         raV/pU2WvWJcC31mXTD46ETyQNQaAyxWsMMl1ImC2kh/ZHA2OT0J+Q9J3lqbNXdm2B6m
         rnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757967059; x=1758571859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7yADzXGocb/qE7uG5osiTyGOa5Q91Vr/vq8cRHwFCM=;
        b=sQfw29R5BjRAD8WYB3DjMrqs3T42SDtdkGh+r6Wf4BYMFz9mow81jU8wbiBWxjtQI0
         AFaFb15kkzvvLa7lsRlwBKtKZibhzBAzSRWeFr5h2gftOxg7gu39xhMAEIsRydBSu6Ww
         93SQWxDs5o4mkVLbTgllY0CwScLNW4tf4onmvOlnWP5Fbd9QdS+Sp625qRsrctwPHmW2
         tBPVfFMmDIA4AarDySgdRKLKGFqD/SK9uIw+/5nYbTsZUOQ8lUfUomqlZERdolHWs9IL
         ePTQU0I62gWFeb6MIuGLyoLSrvWGJnE340cXXuBCkUJhjSGdmKL5XQD2hygRpx49Eg1A
         NSlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDbnvIzr0KiWW3xncq6TiDSSKqQBUr10LujXapHXfmKzp2HtiOIvr+nBRjXqwYijNXGM6MSd7beA==@kvack.org
X-Gm-Message-State: AOJu0Yx8hzveKtA7B3uVlCLqhczoE7UfWs0QLwQVd03qMqaA8YP573w6
	nOdNwouvAp9VPvU4wRAStGgm3oh+7GqE5OMVlvl1EoowmC7/mTGd7RRGiW4xZoNSuR5+gFITgef
	LF1Gw2B/RKnfCtwwTQgtY2bpi8Wc+6MCjaBODQnN+
X-Gm-Gg: ASbGncsSG0OzbGz5jatE422ef6D3R4Z87NiAVQ9ValicqEdGui3+sVb69sDBJtjNh6S
	RsjyuIrKHh7PGaaCKtK55DnTdVEkaPLBBQOIgxRaCrDFebsnzmwbCKaJLHciCal7/tnZzhmbG6T
	JtiAgxvL+vzpsSnadHCGxtb0PXnfQfQHNRIyuJ83XvKa+aXG/oHoFqjwCRcDhyhdy2k1/nNutns
	NA0iXZFOBma5jnPwykbTbA=
X-Google-Smtp-Source: AGHT+IH2ABfXb4DwKPnac3WHtKB/buhhVf/EdUWNCc4f+qA019sh73f6G3fzY2MHaUsZNUbwzHEwRuwgYnb3fDthRSo=
X-Received: by 2002:ac8:5955:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4b7b2d829a0mr192231cf.7.1757967058696; Mon, 15 Sep 2025
 13:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
 <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
 <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
 <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com>
 <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz> <CAJuCfpGR2tHhUu=p4X2YKPNot4TJbhuFPRiT8BgOHvtcw=j-Ug@mail.gmail.com>
 <75bc0c27-3d08-484d-9d22-59bc70f7ee1d@suse.cz> <CAJuCfpHJyGrH91yErLBMPbFBu9dS3Nr_ij2FJdQ5cUnYxAu9Tw@mail.gmail.com>
In-Reply-To: <CAJuCfpHJyGrH91yErLBMPbFBu9dS3Nr_ij2FJdQ5cUnYxAu9Tw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 13:10:47 -0700
X-Gm-Features: AS18NWCSLNjt4OO-yaU88tQeA8HQXsepTIm4TtQqdSzJ2SipSga5dU21EKuuu4A
Message-ID: <CAJuCfpE20N31AFdTboQX8GOrD_Pn_=oNB_UtGsFFKBotEb2-1A@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX195CwHehnLRB1t7QrqA5kxHSowp+dF+EK85JwFV+qeEmLXScUTQ5dQhPH7cQ9Bp8LN4bu/P8s/enJos7JZ3LUfJElY4lt21ftubpfiyOJBqD+CxUWX9E5+ZYmq0+pMsouwTogsnLjZOAvMFx/HTvyeepxY5fzt6dHuYTbVs+ZCrSYOYkkq0Swgz+hRJNMuh+4UvP9Iqy6H+rD0tCNGwrnSVvqPeLZp4KE1/9PmJVT9OpHFXr6OJnbqNfbV1+Vki9/kYplbbq0wWkWoXtY937g2L4iRV7HWZlInZtV/f8POiY7WlRnrOeS48X97T+mi7eOzYyBI00m6X8Tcq1J+hEzBKiF3kSOrUGxhXpmrt0oYwlfIJa3NSalxxk2mDR0elpERhCkzmb7IxxnbVZuvezC4q4diVceV8cYo5Pd550nQLrI1llD8bZ+0fsGlUfJjwpduneWaN5+UCuigbe2iUccaypgt0JaAmBiUO4vphocDnVRZrkAe4qGN3Ng/QsJgWlHJau/ozCo2jFDK5Ij5oVvRC+egZobhPprYPVT8XIXO84rzWMPWgCNBp2hLLGq+z66WWYv8IEJMNn3A96+qN5lCQv0U54WQFf6kMJ/nO5FSPTx24QwomT25H/7pHYmf0S2wGZssg56xMQTb33+nNzeVBXLZqeBMkw0aWv6ZRJ/rWHLX7gYioK0Qs9ik+xErBFBLBwvpm+jehtbeDGh/XZZTBRB6y/2Ccmo0hVFIvL/X+8H9hjlO4w2CSwfGhCtJtwmZb256IW06EDd5BK9P55hRAiH5J6+nFJDIYqWOeGPaXkvgoloElH4mISDF6hcHwXnJZIpMVo/i43fw0sGmQH+rbKUrqvJfSf0KLV7HotjGKCYgrroxGhYARI/+Zzac85A4i16g6ynvmln+MZRh1MVxIYSbINYWL9W58D3h8uVZ9pfyHPt6ZpSuHULHA2zKY1b4bbTdZY/X
 QXxefOUs
 x2cTIvkP7TLfaOQfZatpJBfHIIB9jH2PhabXE5WKdduDdmycpN78u1jvi/XopcIHB28GvUdyUURnfw/EBfhXIPk9o37hSCvwK8GJkzHViDIJyvbywLuZSTXAwpi9DG/L/cumT6GNqXPRWxQBMPvtvtAH7AX+HeEjceek2RrIxenor1YP/lnvbipopvtH180dpm6kwzQ0SDUE5wfQGUY5hOjGKWj22F5Y8NsSOlxuSxgnk4ifmBgGl4PuKZZplU9hz3h6w21hBXPBu8OXB3B0rJjPQc8/vlbQeuGxJHQjbZmWHUxpOSjZ7//olclGQuqcya9B7omI4ONql61EScp2yXwxdpZ6TRd7jRO9Jfes6RoVdTlWHsM+1v+a0VJ7eXbNO6x0bLJNREYnct0D/GYnGrUiUl78vK4Vzo5s3
X-Stat-Signature: m8yq9567d1tg8uks7rhgxmihr89o59uo
X-HE-Tag-Orig: 1757967060-430699
X-Rspamd-Queue-Id: 9559D40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757967062-198158
X-HE-Meta: U2FsdGVkX1/3rw0DP17UxqFIRpUNfKNsZictgKb9Tr9Y2eIWptBiTCbqbCucTG67F9vrMHZIYWHXvH9LplHO1+tCC+czzlJNLXozkwN3xJFQeIknzUuDV9ZVetXL1agG48z0JojSZ+7lg74WBBYxYAuiJksIvCwaWwszdHsqR9WSASo3J7nO7dRIOmis4zZ6BQ4M79bfO040cabDzFHIqxtYfTq7ola6gaEc5HbRsXzmbMgkyqlb8yd14xqQNUKwirJ0aZu1mECITtQTKR5hLqE8+UXPAUk5ywEWHV3ddsw5rcRwYrY+NavaDUmTZPRG8NFhPi+IeHQM2qeSA5yp12T8OkmxKfn9VuIOLIc9qrvo4GU3VBVcd4Yg+km6Yp1BPMA+m3DjrMzuIFMkLCOaq4H8/8CV8A+6Eeg9TDFDeTkyik5TgMSoWhcaES6er5siX+YExutB9CxjLnEhywpafyfXVTPYAFQzio4GMk3GcvNDHRbKN9lrxNGG9KRC2xZVEIz7iJo19sWTuOecWTcGB07Fk2bQNmPRjKfc7YxpxdWtIx9iwaMJaxiU9S5IYAiCc4xkHxTFx66TG3e8DkBBe0j6iZGAIbmOzy10OpkjP2ayjV3kidNilYTjErpy03qByq4MsZInsSEnQpUMZkxRlSEDLs3O3Oe4TTRcMJzKHJkJFPfjnppHotCaV6bD4foTALKxnb1zA8hyYHe6kKfB81/rNHqZLMptTNBPYEbWKz+Z+QecVvHgzyIY7kiGAZ/DtxsWdk8vbBU9E/DJndpH8diNoAqBHpttYt7p7fOJajHNjhB2CnseB4vYI033/4g2WrpGVzE3m8WYnG+yGNCyd8aLrduFKjSCITfZnksaJoYRE9cdoNZ1SSFIUq07rwPxEi4UhkeB1tyxmip1ukc611qrBgpY+AWfJ+lOLmm1u+IYU/nNwm6xRa8TCxMtatr+S8mF6yd+z7UGK38f08N
 6z0szXMg
 Tgdn+RB5PWejloBZHKvOdWqSndbMoL7GZkz42EEgG86oH1MoUS8XS+27GBgW7dpGbxoHIHBgeZTgJ8Ky0a47GSm15soqykk5dEGS+SARxlxBOoiWyz9piIZXzMHDO/iIn/SXs3xY+1z8kqSDR2WUZ2EyPXc0GPs/dtcomglrxVyQ6YEP2UAAfvd68+IkvwH4neANB3jO7MsvBCQvMCUxm3sP9Ew+V/euvulX11Dnx31SMdlh/aMU9KtW7nPsumbdSJ6QLDwI0YqjggTK4YHvWCe2IKor22NOn1wRnubistJPwlR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 8:25=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Sep 15, 2025 at 8:11=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >
> > On 9/15/25 17:06, Suren Baghdasaryan wrote:
> > > On Mon, Sep 15, 2025 at 12:51=E2=80=AFAM Vlastimil Babka <vbabka@suse=
.cz> wrote:
> > >>
> > >>
> > >> Shakeel or Suren, will you sent the fix, including Fixes: ? I can pu=
t in
> > >> ahead of this series with cc stable in slab/for-next and it shouldn'=
t affect
> > >> the series.
> > >
> > > I will post it today. I was planning to include it as a resping of th=
e
> > > fixup patchset [1] but if you prefer it separately I can do that too.
> > > Please let me know your preference.
> >
> > I think it will be better for patches touching slab (only) to be separa=
te,
> > to avoid conflict potential. [1] seems mm tree material
> >
> > > Another fixup patch I'll be adding is the removal of the `if
> > > (new_slab)` condition for doing mark_failed_objexts_alloc() inside
> > > alloc_slab_obj_exts() [2].
> >
> > Ack, then it's 2 patches for slab :)
>
> Ack. Will post after our meeting today.

Posted at https://lore.kernel.org/all/20250915200918.3855580-1-surenb@googl=
e.com/

>
> >
> > Thanks,
> > Vlastimil
> >
> > > [1] https://lore.kernel.org/all/20250909233409.1013367-1-surenb@googl=
e.com/
> > > [2] https://elixir.bootlin.com/linux/v6.16.5/source/mm/slub.c#L1996
> >


