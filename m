Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C28BC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992E76B008A; Wed,  5 Aug 2026 04:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969F26B0092; Wed,  5 Aug 2026 04:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8820F6B0093; Wed,  5 Aug 2026 04:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA3F6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:46:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D18288037D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:46:10 +0000 (UTC)
X-FDA: 85066583700.29.7798FC7
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id EDF99140005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:46:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MKZQdoBy;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785919569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yani87D2vkchIXW/xJvT3dpw4a1HdmFyNSK8oLbUwI4=;
	b=qy//8oPRwJdreKyuf75MsrFfbbEF/gZtO7ONoftgToYEg/btDEFBcQOtst9cMNCD1h/xNG
	hmBlwqXA+ZvG2Y6htYLjqbjStaR500yhNs0gZXr74DvpNqw85CbmI12LeiosTOiTHEj19P
	/U7YOOk72mSMriOYCnVjQAhjm+yIugM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785919569;
	b=q/j6rh6z6Dy1BxtUeia31wkCIidLVUHKAa+6qdpYMOgvDQoTv/Mtbx0TDqg8dAZepzaYoX
	SLQIXS4fRjWdm9aaPdkpf4zq8xhdlkV5BbsS5IUfGkuPWB6dnZQ1ym1gQFVu/oGOsjZaL6
	m3piE+0Wx8MRvpOEzt/91O0luS2cJwY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MKZQdoBy;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so716546a12.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785919568; x=1786524368; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yani87D2vkchIXW/xJvT3dpw4a1HdmFyNSK8oLbUwI4=;
        b=MKZQdoByok0srBIwxqVEEtpVO8RLNYDZbrj1U+j3pEXanzHwUt5no+UH1MxHy0F+7J
         WEPvBvjdHBG2aJIL1Gtn8uARkY0Y7u766teCfkyd5KwW02Mjc1kDiri8xSiIKKrquI7x
         O1VuliW9EQNXiOTfiApmRKUKztkRG+coOpKHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785919568; x=1786524368;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yani87D2vkchIXW/xJvT3dpw4a1HdmFyNSK8oLbUwI4=;
        b=gQ437bafiyAtT1MCNlEuiemHUbT7X+9PjlWHgyHfvR9XMpRCtBBQ9CBKKuX6tjuHJh
         NZRUQdtnusfFRLsYIEbYaiBjLoCQuB4OLUzjSQ2DSGgPiUm1XBU27YOr/uksMTw2+L+1
         qCZMJd7XekiJXxUKbgogxGW2xxx3LrCTsPqDHq5tltX8CEZ17P4aMwlAiyoYq4Y3MULP
         S5a1SaCT6ZpryPjLeP3PQsPgGPRwQ9qd+PZFPV0uJhvjKyTjNwKhOJ/xlptLkri53Yvj
         /6gIG2NFhLYqxBSzaQgKWlkxbswwckOZAvYKUnhTpuwdV9wCISM5vUyH8mQbVMoENTmY
         QSGA==
X-Forwarded-Encrypted: i=1; AHgh+RpgY4O8MxijdFl+y2zT/TJWSte8S3a0OJNxbQ5yJeix/HRmVMf7dx2YnLuX1bOVsjyHN6Cw0aoIPg==@kvack.org
X-Gm-Message-State: AOJu0YzK/vDeGtLNhN9gR4oHWJzvVbJ5hoi9eNMyoDGY2RQFoDI82NE9
	cmpz1Ga0dqQbUfOo7ienBU6hgaxLJrj8EDnYT6Dj3nsyqbktn3QfgsOYr/YDDYchPw==
X-Gm-Gg: AR+sD12fNzKaYHP6jfiLCOY8kA3ZqujHZxObMWedVWPkmvj1qt6cvT7wUB/3l9m6Mih
	zKdLqqYZsN8tT81d2Q7Qv0W0EE1baaakul/q0fd5sr93D2Qhpy41cK87sX8cQQ240m422N+ngnE
	vc/CH9FrAnqRaj/uqGqJn5TJc/3QwlopGpNn9h6BJAUAYg6fUBhJEa0OH37MCTUoDDc2bLD4uIn
	TOdmeAXS68SgDvsqTQmLtL3mgZuw2OC/gG4Gb9VTdrtNIQni30Arz4F0gCLRLXxOTiNaSmETNkJ
	XMPHvU0sDNlk9xGwYAZv80ul2f2+EytdPJxkcoe2uyqG05lOPH6PI+PojBhmKlPK2U1rjom12qt
	defGKh9fQrr9aPQny8XXHrfauEcEHiP1+0a30NoQP98flV4nheyZ4rl8IKGB5ZB3N37eDzkE2IT
	qQQtB+khWuDXv48eC5HMmFkzzwROzuQe/1EXRubVp+1aTfbhhLgAhfrNXF5IHD3DKXvIxNF63Le
	2AxSg7O1txAHMSmK/Yh7/Yin0V7
X-Received: by 2002:a05:6a20:ac44:b0:3c3:8440:f6da with SMTP id adf61e73a8af0-3cb85ea6fa5mr6036539637.29.1785919567859;
        Wed, 05 Aug 2026 01:46:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe708be5bdsm1024528a12.15.2026.08.05.01.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:46:07 -0700 (PDT)
Date: Wed, 5 Aug 2026 17:46:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anL0utxGYeGOGwjt@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com>
 <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EDF99140005
X-Stat-Signature: romfhxjgm9beq3gti4j6swxaemexdjdr
X-HE-Tag: 1785919568-809479
X-HE-Meta: U2FsdGVkX19S95yD2/7YPgtKjrzqAFeMy0DCaR9ee6QfStkoPazU0vldo/cLebSGOhzJ5C51KQpiudAWVCtcIlxRYQeKxEDN/XYAtSM4kPFc98RJgHwpwyo5N9X3dFiyW56kZeZMz7va5IZTQ4Ion/bPlKS9IanKtVxxCb3qmbpYuv0FbO4f9+qybmYIGqrO2ScU4Vq/PLEDqLqx0c3ShDZ4nJQBlwVHN1JXv70OOSMxp91pm0kOTnNr8h5jkGKrSAbd/AGkHUjxRUfEC3o/2W12XMog1mBYPRA5IKaPRgDsv0uD4JtlVlFB+u+6/JPvJV1n14OyY9SF75DQEpeJU61HNvh8kCb29GdeFsCm6AAJ2RgqNpGXiA4bvj/Wx6tiNYyFQ+J4Wh4V+WJbYSAsN9P5UpIK1Yvbx7Vl8xghGQVPfM0EvJ8Ny+Iq3tC0hEGtXfzbbRR/ZLnlgFKFcMNhE7I36aN4gIoda9YorIs//qqnqvplUwlzVp7+ufBn45n2joJUI7ZiDEssR7FjWE1yYo2lE9zVXPaQBvLfa4xgda89dQ5ezN8wbeQ6L4n8i0jb8c2tyCK09JkYAh4YRI9Ftxhv9Du89WOFpKiKMvWmpcPRf3gqt1703K9wGm36tTICBWRiA8WUXNLIfZGWoVP0zl0FmzYYDngUVF2G0Z/QG/HM3w1PzR3jJWLIzneqFpFTGVjyO0s+z/CWusgFU1swnMv0kSXpsoMi/VoKJin6zxFhZkTiQpKcXQhxcxSfmzFIMtP859e9ficX8Sy4PILn0jhRzgzbg2BKUsK5hxJ8RS9D9rnV+b2u1g4xo63xH6kYuSX49rrhXJo+eGJzTUgUSi+MzRnLt18HbVGQiWLje8rAcXhfUFNcdZzGW6Vxs9ltMQSYFItTyKnH6OglHYhxg4oF/qb1qkxicRStvx2BvSxUr1elBjBclbZ+ueuTSbAmt0jkzOgdyilGNHF3Fdv
 lswNbcEY
 yTt1QRFyO8TPZpl2xImcQallOe6FE4JsM8Ly0QYDIgODoh5vr7AsJh6WLwBtCNIi+SGjiemtrGX+F9LIreL/nDoZ/0Yl4O5yYplitm7Asqj2Qgn0nXfaMzusV3bOW3RaU3Ak/zvufhFR53ILGLk6Nn89qK77jCZps/H9owLR0fZYniKTm17hz+Wlp+oxp0skM+KOoVQ0MpHQ5slb6w5JVjePT5KhqAT4ZjUC6C8/N0YLmt6uVJvX4/Ra8ENkbyiwrDMNwzfQBWaxJW8Hs6rSVbbuGa5rCIS45iUnwcPFS23rW6euklHZliSRT+PZsoQPg5g0SAQJ9O4GNuMn0qXb52hdcgTOPTDzl4SKcNno4lLlG+pQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 15:50), Barry Song wrote:
> > > talked with our engineers reporting the issue. i believe it is all
> > > about priority inversion.
> > > proxy execution wont resolve it as we have a sleepable zs-malloc
> > > within the mutex.
> > >  i believe i need v2 to release the mutex before doing the 2nd stage
> > > zs_malloc with
> > > direct reclaim.
> >
> > Well, we cannot just drop the stream mutex and do sleepable zsmalloc
> > allocation, because this will invalidate compression buffer.  So we
> > then will need to do re-compression.  Something that I was really
> > happy to drop [1].
> 

[..]

> BTW, I wonder if compression and decompression could use separate
> mutexes. That way, a sleepable zs_malloc() in the compression path
> would not block decompression, which is the more latency-sensitive
> operation.

This sounds interesting. I think all of the S/W backends that we use
have stateless decompression, so we probably can just split per-CPU
stream mutex for R and W paths w/o the need for any additional scratch
buffers.  Wanna give it a try?

Back to preemption:
Is there maybe a common hot preemption point where stream mutex owners
get scheduled out? E.g. inside zs_malloc()?

