Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640F9FB44C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88CA6B0005; Fri, 24 Apr 2026 02:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C396E6B008A; Fri, 24 Apr 2026 02:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28C96B008C; Fri, 24 Apr 2026 02:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E45F6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:57:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 534968C728
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:57:36 +0000 (UTC)
X-FDA: 84692543712.24.424EDB6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41FAE180005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:57:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DL+BUrZy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777013854; a=rsa-sha256;
	cv=pass;
	b=cK8bHLVKxZ9zOrzspW5jDt26HOdWYI/FXkAm61EiDQMc9FMsZXetOzk+5UoLqs9rADnCR9
	1Wh8okLinPCMuHx1Y2XPcirPNK9FdQamYyiam7+xrzt3Ds8cSKXhXrrSr+rN9xsYZ00443
	ED85G0Hpt3pW59nAiAupHbeFcDacE8s=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DL+BUrZy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777013854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
	b=uDboGsQ4VfKqX97yRytuAjZ1Emlitvd0PZxJQVzWuZeD+77aBouxLJxZYFSij3OBzHiylP
	86Wvk5CjoeRMnGTalYWqPZMDQrHkDlI/Vj3iTb/eiDUqZOZdLtI5PAgLLDbrQmd/W6LSfh
	ZwvgF/VAUqnrVZkXRl03r9oK31BuOCg=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so2322248a12.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777013852; cv=none;
        d=google.com; s=arc-20240605;
        b=XVL4jtKyia31TRjQZfaQ5S7YYLXejQSfqpNRsb+Tmi+m1MzNFaGLwQQa6p5f9UCdG+
         5yu0+mJml6l3gkjw/5u0TaU1VjW7xJXV9ggZ2huZn+B94aPBMYmDt0UYKS2FHU/C+yw/
         OfY6s3VkUVzQ6lO6CfamZBGHu9Q0o9UhegCNzYpwn+Bbnr8Er6fLlez3DaxfMeU4CUt8
         GiRQyk2gLDsWze8r0g+m5ZyN2ojpes3UdAZb99hBnbdFs3c01yPCtL7zHhd/wrKUDppZ
         Cxzp0d3JZnVnoQaDqrd9MwaeEcPHn3GRRWiX8gyoh2Nl7AeEWNeJsVuWy2jRA8YbWSqW
         FFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        fh=hge9RGqkveCpKYxZ2wvs67N7zsIcwut8zqA54KNmwEg=;
        b=Wt2r2oFrBRnMgfuCDLlFjDMdZs+usKqZ56HrpaEiIRdD0wu8b8hgViZLGdahmspEzf
         xKelYqhORsMfVYFBk7a9mq57lKVBvbIIIaPTlEJNxYZWJjDSzB2Z96VMNoiyzLuaB1wU
         nFEo+eSgIJKiXhWtJyVZEqoKmEGe2ArUignu52x8fl6aLGGdnYK6vmKhRhxrmymj/QNx
         rNOFuKlO3Z+KMytPB0Ou32vuvQwIJeoxqo+BNU+MWX1AIrr/E3v2ShN1B1CjzMLCN/On
         aZ368MWUvt+pvBI5u1utqJhbx/QUuXPW4m5HM9ogwcS4wWIim8skgSIHHSY83vG7+VFO
         XHJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777013852; x=1777618652; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        b=DL+BUrZyG/5vDxglJiLVMTYnpHjxclbo+0+od0H1xnlI87B7DFsHLmByN6TmqMqMsO
         LoXEG3PbtaI3QvhvT0JPLcDyk7nQi+7PXAvSlf8MeV1sO6XMsG/eu35Qa7aE04aIQgT6
         MKGH7Ke8r9AXTXvu7TIW33HjvsgKuSueDL6L/OyfNWDHvNFDZLMGtLPaIdjvG8mqHCLI
         4U/v1KGauGAu9dL8EjGUPwepD4D3qkesqiOhAxOlqYsdrgG8Gfoe+BxFI/TQehF+Bn6g
         ILl+8QcMUe+RnS96Sn2wXmx/3+QubD+XliuzvMVQykdHKyOjQcpaKFVZFypQqBLD1sFx
         Cf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777013852; x=1777618652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1xbLIQ5Fuluw6Mpoy6KL9m+Q4rOLvVceUe/0sWgR12M=;
        b=Fs+AT+Te3ShUckUT3YFs38Aw7g9MYHMa3Mgf7kA/3lMKCHFlijkW2VoPBlnAoqt5/5
         laAnffP8RDJ2nthUU6NNRDtFvH2V5X2ANnMoivlvD4u8mHNeZh7t33E8ngvHO5hLelvw
         M11+KXGywcz+Ubd/KL2aeBHA+T4ZwLbAwm1wUqnEVbfNbrwawpCrXzKsOXm1y6ilz7BS
         uADdw7zkzih1RC2u2MNoQZ4VUFeqrQ5udeTDxOAFCbwi9IoqGyNgdRRGXfgyE5Av9YaK
         8iWFE8SoFfEXBLZBJmrsHqVER8CRQpEJT6kWlxFto5dkuOIKdH35N6tVupVGt3/f4xmz
         TLTw==
X-Forwarded-Encrypted: i=1; AFNElJ/fdROMMmGiTmlZv2ZU8JaBT+j24fnMbNHY15HMAIwEodiQNt2QktI1Kt/lGky29tc/N2Ur/JV7vA==@kvack.org
X-Gm-Message-State: AOJu0Yws9/3KG5v0nvn+YRzgNHFud66aT8zBq/sxzwWe/s8yGOzIt6KK
	unD+hAZl4aqnGYTSx2eLSbh0pHCV1dS8cuzGToOamsxb2ocsJiAp/wGqkvu+Y5wyrQzIkiB1Sm2
	blEtLXxG6jzA32A/PbHAHQ5fUKL2k9OM=
X-Gm-Gg: AeBDiev7/N9inVaifMFmh+Uk2JMbPlPfdTT0V9hIz5Zf8qyK7PD+jPbLohSLKJaBwoT
	gtpyBxikj7STJw3HMOQit8y9eo7x/bRkZ9vE6y3gTQ4MQYxnbKMeH83batyVsODil8FPhXVef7B
	V/eWBUnTP0SF4syQVzLhf/0xKg/3wFXr2ZuBZDom3bdj0GqZASDcJF5NtTSDzATholsP8GW74Cx
	+AhPKUwiDUtYK0eincL6NBSnFhNqLv+dsdjYxO6MExVjIhQ0vVrAMn6/XJ52FWnqN/Vv3VCTZZf
	Wng6kE9EknnwhVg5hbV//puQLo8Vr26hTevN3QKTObM6PfzDkBIY3MO7Hu+87cs=
X-Received: by 2002:a17:907:97ca:b0:b9f:9e7a:bcd2 with SMTP id
 a640c23a62f3a-ba41a632e8cmr1588080466b.38.1777013852060; Thu, 23 Apr 2026
 23:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org> <v7dhrmgc.ritesh.list@gmail.com>
In-Reply-To: <v7dhrmgc.ritesh.list@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 24 Apr 2026 08:57:18 +0200
X-Gm-Features: AQROBzA7au-Rxnv_gU_TeRNbE7y_vZ61_PUN4YtNXKiJVY5WHIMs7q432z4NtWM
Message-ID: <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Ritesh Harjani <ritesh.list@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, 
	john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: pduaowjij9j6x7ugyzyjm4dxmm4phgzf
X-Rspam-User: 
X-Rspamd-Queue-Id: 41FAE180005
X-HE-Tag: 1777013854-9191
X-HE-Meta: U2FsdGVkX18X7v1B11N/LgDqwZf4OIyje95NmQuMskj7pB1YZZo2J7YPMV+9Ma12WUnJk+4P0BCfG9zI4Oql92mM5N3iZ9ttZ7jrWWSW+ZIwbSjzg+4osbldUC7dcUAKGdNCGTBtK0ueKBoTLgmZLXwslxCiuZxQrtgBfTUCA3YQgU3xEc7AXjxXIQD0hxHkckss3c+2g400xLz28Xwo2lU0+p4e4WFq0mgKat2IJPuXhK1maP88fl6POJ0xem4gVJHz9GzWlXYFvYR/5/ktE63bF7a1r57KTWrml7GlNUw+dfZMEZqsWPSZfzRoK549WwTM33sBlmqi/edryE8vryoNuhGmlyBpDGeiFhk3ox1Hj+zO/3u5Ixsjgfa+ZGwrUjUzS50mApbBIlhSi47O9vJP3tUfEfnE/wAdUxIwt1RW6HEGGtAW9r1gt5NMR97n05tfJ+KdaiwlXcWXar1a8T4ZAisNNpEmcOn0f027HROQTATr8usklV5s7GbEPp0XJCe3hGaFUPwLZSGHhDOyCssBUAUTwAbry+GN0Zc6aJvcdaiocbOiFDrNcqGSOzjd6nncgiK6p6ATPWC2G+mrDcF2Q1h88MUGatsv4V0W2ZPsOe/Z2rE52U/wNClmhMeUMt4XjOc58U3XMfzQ1Vg+H8Jq9ZDCHZt7lN1YKMyINZtUoMo8cSafmglf+NiXop8s9PdBGMXmpX9tuLoYOFzR/O4k88EDpxp6peSdF7h8gh3qZWkFz0ci3PMe1UqavddzlPNYEVOA0nV5G4NQVgeAjuV/eCWB4JlCMAM8m5EP3z09g0YyxkMlieTV2hExxtZkU9iOaaiWijORkiaoiWJ8N7s5Q1R7DFKTzkYYHWvi9RUv8S3/BkqTR7RTLp6zk2Zl27MPjFcnyXplTM+1t+vEK8GG2muSABVgNYmEcLgRKHTRvrADB6rd6+2BS345JbUEL9Kq4hxJ5S9XgCIRfrD
 N6Mzh5Hu
 RbyRL8BtibWP1fY69CWfzNL10Gz/TKGKR7LJta6lhk/mC+EPpRz0CbOIl4RQHMI0dkwJJi3i7C8eXND/7VRsPlpZTZzWLY+JVjImYitUpvowc3F/lf6JEl6tWoN1o26PGxkHIc9DU+ZVo3GkLg6MXSSKs7xxteCCobbT8iHPgvzFev3QXv+ACR+7Fb5JxGoF3IwPxcAWzhFd3CRjSZ3uJXfCwRrZt7QiM4w/56U7inWu6UlKWRNi9MBip2T0f3FtedSZFtepE9TpF5xIvnxGIAC5WHJP30OfdPQFMvKkM0/gYVrOFw8B10EnJMGtZ6is06dp3brG+CI8ARNE+0PmLB4ukEgdo9LuDbiReo11A0tey12xIRPnoDPulnXfAaTVYIfV+aLDNS2sj5Vvya+FSEX2PygMsahqp16sO+0e8rXSSV+VA2cWsAbR66FwaXL5VuSd6PTRcLc2NbEXGb+Ow5o7brdYOgc9YXWkPTVGjrrZhn+4XMIUCouDGZ5rGP7jQjSKEU8qc4M9MYu0wSUAU03HWJnypH6rN2mgwotlq4taAbqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 7:07=E2=80=AFAM Ritesh Harjani <ritesh.list@gmail.c=
om> wrote:
>
> Matthew Wilcox <willy@infradead.org> writes:
>
> > On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
> >> We were thinking if it is possible to extend the Buffered Atomic Write
> >> session into two "continuous" halves of 30mins each (total of 60mins)?
> >
> > This is painful because you've requested me, plus both Storage and FS.
> > FS has lots of space, but I don't, and Storage is also pretty full.
>
> I see, sorry about making your (and PC) life difficult here. I know it's
> a lot of planning :(
>
> I think, both FS+IO folks will be interested to discuss both of these
> topics. Do you think breaking this into two discontiguous session help
> us plan better maybe? In case if we don't have any continuous slot, then
> maybe we can split those into two.
>

I scheduled the two sessions as you requested 9:30-10:30
for FS+IO and moved Parallel Writeback to Wednesday
across the MM CXL session.

> >
> > Do you need me for the full hour or just half of it?
>
> Although I understand buffered writethrough is an FS related area, but I
> am sure a new writethrough I/O path is an overlap for you in page cache
> as well :)  So, yes, it will be good to have your feedback on the second
> part of this discussion which is - buffered write-through for buffered
> atomic writes.
>

Matthew,

I don't know why Parallel Writeback was scheduled as an MM session,
but if you think it should include MM, could you move the CXL session
to the now free MM slot on Monday 9:30, so that we can extend
Parallel Writeback into MM?

This will allow you to participate in the atomic buffered write sessions.

Thanks,
Amir.

