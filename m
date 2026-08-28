Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047FCC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016986B0088; Fri, 28 Aug 2026 13:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09B66B0095; Fri, 28 Aug 2026 13:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FE06B0096; Fri, 28 Aug 2026 13:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5BD76B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:26:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B56A40504
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:26:43 +0000 (UTC)
X-FDA: 85151357886.20.F0B56A9
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC0F12000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:26:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YRCvmniA;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787938001;
	b=y2zAbD+PN1fdJ7Zz4Ycxca8d8gCerCQJ0FUNFJYORg8LbomMEORYAiV+LihCZUKMghy3s5
	2zFZJY8vAkSuCBmJt8w8u6nzzgYne3ieliC+HKtSWO/p49/DyZuc5U4tTU67nTCkTJ5gBj
	uz3s9kBd5nvN1Yb0hONck52CvXF+emg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787938001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1RgJgjYZ6layd6nj/pPqRD5/ufb+nrNE0c26oBEfgY=;
	b=GXLnG183qVpi/8UoTMy8MF5MjXyiHee1+KSvFK+R2AFusbNzPwd7X6EdbE5d+cJQCAM2pv
	zoh6I08BO0XB4f34EeKcKqeJqlOwQnarNpxe4hFeuo0pYPyGCQrmQ60Ritsg/x6hbNDWxP
	3wRKylgvnFV65FYyBbxq4A1pGRv4Wso=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YRCvmniA;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c25099bb1fbso167503166b.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787937999; x=1788542799; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y1RgJgjYZ6layd6nj/pPqRD5/ufb+nrNE0c26oBEfgY=;
        b=YRCvmniAgi5wG8PYgtSPZXnwGKx1sLv/580rc8qqmxitq90t2A8jhbSF/DXa1smM3G
         BnI+k4i2Szd9U7dpHzsXoWWhN8p76A4ZeOeOf/bRUHVsAsEh4nHFVIOVJXEaIN54pqDF
         wPL/eAhQZNYuqLkHCpApPB31tJwrfP36aqpQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787937999; x=1788542799;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y1RgJgjYZ6layd6nj/pPqRD5/ufb+nrNE0c26oBEfgY=;
        b=JzKreooGrm9zu9U59c2IiZcw0k8n5MKoTpXrqqpsX1UvpGfPAUHyEpiXh5rBbWviN1
         TbPgEblZYSsRzp3iApQ2ee4Mx2dkpbZYU4XxRjD4iRMLuezXCG8L8WAlUi+FT1PxsSZu
         17dg1ZSLiJ+eNhwzC3sewSnMOan5QwTxXeG8GHTGTnTHKIAu4pgUCrxZtUihYnBm6ALf
         9VIlRg5X2WodPPiQ0O8G/h9V5utd9v2O6hdFr9G4rYP8K3bD8fFLzvDbvs+0KnjlgbQf
         +NRpJ0Io+FJv+lW761o/Kw40FKpIjp1/bEIFeVY4DsV/UQnVp8gBmQ8iedADjC8pkUBi
         TNGQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro23v155bz5nVs87RsHJlvZe20laA8qEF2U6CQ9BH2gYBhHbl9To7DRH06uPwcdtD9+noX2wpzk5g==@kvack.org
X-Gm-Message-State: AFuF++mp5F5KVxFJ4ox6meVVakHtU9ff7+z1d8WmYv1iAUKwtdMgXoZJ
	0ttyuMbc8mrb3YTjAoNtnYzPAbI59wOxCMDRN4s4OpW6Ky59cxBRnK3KZBwB9tTmoHFhk3g4HOy
	dgv/9eBE=
X-Gm-Gg: AR+sD101mpNREvw2B5VuKTthAC7nKeixmLkJ9+0hu3HlwcB13yMYfxEkKcnkWj2zhMX
	bBskaJNiELhSt7IdZOMZfCK5aAeSLbeZ6efh9X0dBr+6uI6lyqLOlqdRM2hdmZNu+Wf6LSKwrF8
	kAEdNw0GKf2c3hWLCkZiVrTQbjz7/Cpl11+55QBC9uGFZXqqq0Oth7ecRTpH6Zqsgb3zTNlZi+b
	YEMe2SyXvL7Bp4+eKjSHwcQwVEmCjPLCCBPbZbnXJATf7F1TfMtHGRtykBmy385G8smRwrFl9Qv
	aF2+zdxlgqLf4AcFadwoJWX/T6gHGFbBOsSWj6gg9uj+0wqDSVIhGbmtUd9l+AtHELI4TWzdkqR
	Tk1mckPH7SvsqRcmqD9AhNlGSF95tyIGR4TGGpo/1c2v3uhsXh0Q1o+/ESCSGe8i2yQia8UfQPr
	1Yg7vJNFtp2yn99MvFOTtCQPLzGdKrcJt+zotcb8UIIa0Wq4p82ndkqgAssWABIjNJ6A79+cESG
	DM/ZkqIE7qTvmx4vbM0ryJO40KfQpxsioWR6PE=
X-Received: by 2002:a17:907:c81a:b0:c25:31b4:5f15 with SMTP id a640c23a62f3a-c2556babb2amr654852166b.1.1787937999396;
        Fri, 28 Aug 2026 10:26:39 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f23d434sm108599066b.54.2026.08.28.10.26.38
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 10:26:38 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a051b737d8so1449919a12.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:26:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoJZMKL6PrHLyu3V8wyDxqi9qw6UIekAIY/nrRtakE6lBMifLEXlNaTvJ6y6XRxIa4+MaiJmL18yA==@kvack.org
X-Received: by 2002:a17:907:cd0e:b0:c25:2fb9:b897 with SMTP id
 a640c23a62f3a-c2557164d7fmr623783166b.18.1787937998688; Fri, 28 Aug 2026
 10:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <apG8g-5krNRUFUuD@casper.infradead.org> <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
 <apHC_mHJ3wsJPEgy@casper.infradead.org>
In-Reply-To: <apHC_mHJ3wsJPEgy@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2026 10:26:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wimz+APb9hGEry+vHDLB5D7WZvNGWU89HjGw7wH15KGHg@mail.gmail.com>
X-Gm-Features: AcwNN1W_Djqrb4dbrNf2FnJjSle4SvoCwveEoSjB4FMfvcDCroxNv-63LlnlaaQ
Message-ID: <CAHk-=wimz+APb9hGEry+vHDLB5D7WZvNGWU89HjGw7wH15KGHg@mail.gmail.com>
Subject: Re: [GIT PULL] Remove dependencies on pagemap.h
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC0F12000A
X-Stat-Signature: sw1yjherjb5qeef4sord8d7bawhbawdj
X-HE-Tag: 1787938000-972241
X-HE-Meta: U2FsdGVkX19W6lvFcnUlRnO0ykJRfhj1m/IVl/y2Unzma2pJpeRdjsXegxHfVt4zY2/HTZkAXBccf0NcHc/IYJ7rsZ5zv8CbtPjbqh9ZiquFmf31PL2TbYdaar5YRhIHdV8q8A4cGcesBbzIruxHQ7dUSjQmboyL5HhGo3dM+Rs5OJWvxg9DAXvCQnXP4KAYNLc1Se/s93k+0J5iKIjoKg+xRnACx2nyyqVTOazz94b7d6QwLJcFAxrDfzcA+pDHhq+Zu56kfKiIHYxmIXi0RahK8xCAFWfsvtUNC9FPmqdR0jeGaN6NfF3cLH6sVTsir3fbRewgTGZeiTe8LvWvxz+OQySRz1FkgS/OWFluJnw3L9WbAJmqxo5v7Z7NotqNemQI86LWl9F6Dx9EqDw4cJ58qqF/DwYT4bhCvuBDbRZFgl2SnUDM9nCFUerBI3Lb3zt0KJ35loPPGJpjdiyo6FuXfguzAS3DZZ6j8cG7zYDMYJrlkSwSMQFT2NPdB4QBs3RiCMHxBOFThUnmXZU1SmgzWsVvIGpyOBbEmerpEzwqLdv72x+q7w63Xc6sgryf27amiaCE3b0DaEMz00iy7oO4eoZB1zNiDJad0MwJmfxsInWFCVXJGq28sLmubHTMY6ri8rb56mJ4SDDJ+bTtPBfY5LKmuS6zSRLRIOXZyIJ+Sfz8qQP37T1DOhkIhYm9zEVDDTC/CxAVgVvH/thIU1DDorLC9sAZ69drH1AO1HoI2O1zRj+0BpD7NmKgdPaOjE6kDwp/3fkKVTMZjMr3becsKhP7EmJsgKXD5MzKGJHW6RKN6vIDXja1J08p/myDDEL7eqx8TV4AdBLqrmUg0YXpjCmro0vSkZOt/TvK1IJPAceJ2dHbNmz4FXKycI7DXZm/JEPKiCy5/ZZ0zwtM1S9sKzQRdPVvkDfm0knEeYdzaYmF46A+ATcarin+vot4Q5GPzKfWRMbKgCT/3XW
 qRF8Coud
 gQeOrIazMm3LNuKn5CeQuwCjNzXA/Uollutgwmkn8vSWY1r9IgeI2fNkv2SGnD4z7mlXQXpadw4JJJuE69auLXlX6/aY0dunssXdgLkDUIH784sNPMCRys0DLMXaVodhxB2h0DDwCxSMFmB7b3MS+ewOvieIh0/wNmEZzJnkCLtru1D0C9IX4wQpAKTt8yOV8GN0NlU3wmQWIADdCvglFuqRJfbJTWlsoFajCaHuvBdBzKg9NlI9r48Xw2vFyWsJl0XKhnHZJloZbW+Ag5zs1cwjfR0f9qA5yhoCpIcRVcMIfVCPYZ5FHuIT8Kk9alwL54e7Ea0hGC+LrcSO8OZROFQthlXUENFi1vhw42pfc1TlfPuNzKsd0EbP/xGWNP+9GsdwGgM5HpsrLul9rEiczxH5VviJTrDIdB/pizu1P311EFtcqzHhah1csC5guKP8iw+Wh96mldknPduLFMGbDLfm+T1ufZ2ERcZu7h3DisSKlIHLvV69/BZsNGorXKFQCJ2grgKrOH1QCglUWiXS2G2l3z4MeOunca7ucxOJOfdYPUW3L/4uWYeXMtEk/oaTCfKkD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 at 10:18, Matthew Wilcox <willy@infradead.org> wrote:
>
> OK.  I thought you liked this kind of churn stuff at the end of the window,
> rather than having it create random unnecesary conflicts throughout the
> development cycle.  Have you changed your mind on that?

I like things like automated churn at the end - IF I HAVE BEEN TOLD
ABOUT AHEAD OF TIME and know to expect it, and people have said "this
is scripted stuff that can cause conflicts, so I'd suggest we do it
just after rc1 when all the big stuff is merged".

But I absolutely do *NOT* want to see a random pull that is broken in
other ways popping up on the Friday before the merge window closes
that has never been in linux-next and has never been explicitly talked
about with me beforehand.

One is planned. The other is just rushed garbage and badly executed.

See the difference?  You should - because it's not a very subtle one.

                   Linus

