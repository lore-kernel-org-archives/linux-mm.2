Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A86CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 23:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2106B0088; Fri, 15 May 2026 19:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B306B008A; Fri, 15 May 2026 19:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2A46B008C; Fri, 15 May 2026 19:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF3D6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:46:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EA2414015E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 23:46:00 +0000 (UTC)
X-FDA: 84771289680.12.CDDE34A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AE1314000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 23:45:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=U81t2ZIa;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778888758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnoPlBIHGBifXSZSzBae7mPDjhkTo65UoK8Z/KktsdA=;
	b=ytZiQc9pXvpFH9YNsoZdCr4iduo4edZc29V2zauy+tUwbVRjXPgebTdutPyZaf4r51hZi9
	WVlHeQ2YhFLBkc2+JS/IAS32fLJUXHcdIITOxbq8JOngJsXcXOxMxGmfBdvoZiiOpjgfhl
	Qx3ctvwQVt7sUMfzSVrUtvnajJx2amY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778888758; a=rsa-sha256;
	cv=none;
	b=rfH6vFiwvfGx81/AecNaD0NGhatoNH1EQ/jPcoQ8hc6ALk+AjvsLEogIRtrttu1REaPHRn
	k8pJD2ukB89bTuOh742WL6d8FNDJdJc0/sjcNzPAQx9vMWCf2RmuL3OMVRz1Ua2ulH+kyj
	ymQ0P6utSijhx5DCzmu/1f4iaRVYLAE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=U81t2ZIa;
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6763cc8775cso3396339a12.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 16:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1778888756; x=1779493556; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JnoPlBIHGBifXSZSzBae7mPDjhkTo65UoK8Z/KktsdA=;
        b=U81t2ZIaefSCPoiAPHYNuk2e3DxvAdgDDgSD+0LunTBFKWJYcFtC1MnS5xMfCEu3AY
         C7sGusU46zCeOa47Q9678E7Xaro2STgevn496gwFg8nQw+tmimQKRyYHYVYkIe6en14P
         vZEVoqnmdY05LxbVqGIoDTCsCqD7tZnTFhnuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778888756; x=1779493556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnoPlBIHGBifXSZSzBae7mPDjhkTo65UoK8Z/KktsdA=;
        b=Yc07LCcKjPz6K7YFZyZ8TVDLuoN+B4wH5AqBPoo51HGoJYz4xvDlsRgp/WVtMHu6rW
         ALGUYR+RYp/kR3vDeDZ6hNYIzcLo143lvOBtFB+53UQ8MLKH64HfO8TV5Np4++ZOO+73
         uZzk3wOQYCap5Xxs6hp0ywhyX2ygUtPfrFDRGuIumzEsKXeGLWYMdO2wX9RHDaqI8PJW
         Ftq/ZDII8FzaXRB/nK5ofpCOXgMPDbKlqsU9ni/VnDNhh2neehszmld68Sa/n/upbuJT
         +TsxjDTVp2xKzwf9P+MFSMogRTXx9VNHwFI+LtFFYvIUIpOBGe+0CKjZ55d8NMPq5S15
         phww==
X-Forwarded-Encrypted: i=1; AFNElJ/lsbO4GVzeKQPsMqGSWzd2KBhM+EuyvdevaYxhuEgMY2nsB3HifOnT04P2ehvbbOS3n2ls2dyLrA==@kvack.org
X-Gm-Message-State: AOJu0Yz8WzBBXc4pAmL3Q6aQPZabBIIDriMi77Uw4usW8xwLn7pV4Psm
	oruQUC6ECtZQRHZOJKSbFDu0E3b9Yz1QbWao5XrV+ZZ5Vkk1f0/sPi0LAqckcID8DtfxnGHXR1H
	aOoLMkfI=
X-Gm-Gg: Acq92OGW2oW6CS6/wLTaSS1rNbpk1FOSTOebyxr1QQKJ0UJXWJ1Mv6YVV55z+EMquio
	Bb5r02uEel3/T2nqZrpVfhjbDbBpVbNMaSM993GrkU2k8RmwmXsUAfZ0UoMOdNMkbhBbYSY1SyK
	fawvNLjhc/aHtnGo2g20HKj+N8F+Vob4rokQ+lVK+lhvfOwlld5fZXOijMAAw5/duDCsB3LXQ4Z
	FskpnlbcS9I6fmtD9x8a9Mp3jBuJar0Uv6duCYGG7bblI46n14m3QVaxb1+4ZaYn5pKs2nbdy3L
	0Wmgo5oqhwjBl6nIQeGTpjjVWZ0NgTJ3/5om83TbEYbvtUZ3mczVJxxfc/VQE2a/NAvvI/6OGMk
	6ISFiborCfQ3wD/ZyYL2/KtNkzs4GLeGScPGF7wXQu8qzbaDPKh6+InlQPRyULOJfX6LFTr+xPn
	H1Sh8OrpGrXQnVALKNw67qwPFfv6lnEFChdUAmWlCzU33UQGADwSyc23fuLxn/DAHEQc23GB5tm
	TsNM4l0Ee0=
X-Received: by 2002:a17:906:fe05:b0:bd5:1ad4:cd73 with SMTP id a640c23a62f3a-bd51ad4d3f5mr309774566b.2.1778888756336;
        Fri, 15 May 2026 16:45:56 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c31404sm287683966b.25.2026.05.15.16.45.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 16:45:55 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd21ffaca79so84887466b.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 16:45:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+525AWFB7CitMFSD3MfbC39XcXDknxWmFYDXPxtDrTrYk1Bvt+Yg8xDGR8UeXVuhDZHpmx0IhVCQ==@kvack.org
X-Received: by 2002:a17:907:c10:b0:bd1:f09f:f819 with SMTP id
 a640c23a62f3a-bd4f34bd039mr495323566b.25.1778888754734; Fri, 15 May 2026
 16:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com> <agefLhQeWpvil14M@google.com>
In-Reply-To: <agefLhQeWpvil14M@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 May 2026 16:45:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
X-Gm-Features: AVHnY4ISab34jjbhdpMRq24hfEjl9hP1VDaCyqC4-uWVI2wdpSycH5ojtzu1j7I
Message-ID: <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4AE1314000B
X-Stat-Signature: 56cw75izhf7pjdrn6kj77mnpcw5owezi
X-Rspam-User: 
X-HE-Tag: 1778888758-392478
X-HE-Meta: U2FsdGVkX18xO1PSVZUEBub+HXtEW9LA4D5MbgoeEJHN2cnd/E99YaKErvF10X6F61acjjP4yKqnP/q0A9xjzvhv9c8AZlaGBxIKTtXSmht1Uegj7i/VinrOTQvqPTCe2W40bZ4DcAdmohykk1iwcqZQEy34kXyAGwFVtKiGZvbYIgm3gC3pTu7PdPx7HkED4jfgSnwMGum5RMqmNcSqlcnqJlorti1FJctpDN39yuKGN2C3tn2/TNuLVpArKyjy88CTEIHglePzUCmpx9Yap2xVd3eIfRCbTJBCs2TqvQJiuk4IH+yA9hJul/E/DoPUR1lXHN6HTohlKRQeez+Xk5D8ty/pcsDRAq9EUvjZ2VwP61cI5fAPLnFv1QwmTsB9jcB9kX0cxkxIzuYe0ubSykspLjvdfbOA00HtLNJOfAINyVpPD0x8WNF/hLwqCh5zB6yoEt99j1YzvLe7xFFBfRmmmaEqIybooWoFx+wqryqSau7y1P61KufVlvPiOx1YhT4gQI0lWYSG3UIweGyQuOeE2xupMmcJm845v5MS8aWnzQ/j9WovOhaRkkjCEPVIBogDNgc0i1pfkrDdgeuzs9EMDcudOdj8R+MmEB7xEl8OcL2Q+dUyEI1HOJ8j8SYskUNCFxOAYbVNbAwoHzIOmXYdsDTWjQJTEQobuKTrVdSe9mXj2MfzX5l+LpjmI54HZqjG6w4MZp05yI9mRYW1YDYyZLf4qWzA1n3bjWO+sBnKzkbWxMNeCPEMMMmy4oWtFydaeUPIv2bQZLmK+3VFwTo0FfRfC1B5Pkvz+XcTGkNnq2Ms+qMQ2nLZvTe8SOzbMSCGc7G0Q/PdXQvTJ8tbFPZpaX5rnYmqljxQjxIqIs6I1IQ1lxOSWGeVw6FNazjHBNT2JxUTDbmNxGGPcb4WPEJUsJuWxmcN9zKitNHzo3NMNzyynb88a7jlWYVRPjAcbx65jKKT31qL4Rqc8Qq
 1ztIVHzQ
 VfDZrUPOXrKw10oeYndTOR8VV6VTunQonPo2rVKinaZREs41B0azVewCJcSPWcDxjvpvLH2WPQUjXMoV5igED6za1d91S7OoY4YXB0h968eZvcG0KhuIVssf2piHD5hnMa6dfgelt3YRrda50Bu2iA76ROOHQZF12qWkLIMGasLyaxIlryF3dIRW/nFB0XelrZhfxQolpTRe3qUWGHbA7bsdMzQw5dK7Z0leJoVgerQOlMQfAYV2XZzrzF892F4LGO7JMJCAj/+dJH19kxlXpHNUKGXRwnJyTcQ8taREDRC4nF1v9u592RLX5NtcdfboHJx/wy8ulOqJC325hOt6/tGN3d6+MM7/uC7EUpn/hcanDzWjM09H1C1JQqfqld9tO40w6sk2cQa5jUZw8SfttSq4Gpsh1IUGBUzs2/ibZeIrxDB5PXdTCwvNuGRB876qC1NBvaWrL9+pdNmWWnvPg7JZ/VtssGYwSJ7R6KBi1yLT4TAaPbD1rCOB7yYflSnhEK/SfNg3509TgMgjQBWV87k7YhPNl0WWohn8tNqLTQRm+Vz97NXL+wNWJOD25O+FqT/6HNF3Yz3v6OuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 at 15:33, Minchan Kim <minchan@kernel.org> wrote:
>
> I hope thisclarifies the motivation and mechanics behind this issue.

This still seems very hacky and a complete special case for one odd situation.

This all sounds like it's just because smap is a pig.

And yes, smap *is* a pig, but it should be trivial to just fix smap
for this case - fix the problem spot, don't add new horrid logic
elsewhere.

I really think the fix is to fix smap instead.

And I think smap is doing odd things. For example, it does

   pid_smaps_open -> do_maps_open -> proc_mem_open

and that proc_mem_open() takes that long-term ref to the mm. And then
does various memory allocations - and copying data to user space -
under that long-term ref, which is presumably what causes all the
latency issues.

But it doesn't actually seem to *need* a long-term ref to the mm. The
seqfile interface is designed so that it should all be chunkable, and
the locks and refs should be done at m_start/m_end time.

And the smap / maps m_start and m_end functions already *almost* seem
to do that. They literally look up the task again with

        priv->task = get_proc_task(priv->inode);

etc, but then they do that odd

        lock_ctx = &priv->lock_ctx;
        mm = lock_ctx->mm;
        if (!mm || !mmget_not_zero(mm)) {
                put_task_struct(priv->task);
                priv->task = NULL;
                return NULL;
        }

dance (where lock_ctx->mm is literally that long-term ref we hold).

And I don't see why they need to do any of this. I think it's all a
historical accident.

Because I think it could look up the mm from the task pointer every
time, without holding that long-term ref from proc_mem_open() at all.

IOW, at open time, we could save off the "this is the mm I opened",
but *without* any refcount, and then just verify that "yes, the task
mm still matches". No long-term refs anywhere.

Yes, yes, we'd need some sequence counter for when the mm changes due
to execve, but *that* should be absolutely trivial.

And wouldn't that make all of this go away entirely? And probably
clean up the code at the same time?

I think the only reason "proc_mem_open()" does what it does was that
it was simple. Not because it was a good idea.

                   Linus

