Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399FD1098789
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BDF6B0152; Fri, 20 Mar 2026 10:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13C36B0153; Fri, 20 Mar 2026 10:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929D96B0154; Fri, 20 Mar 2026 10:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859206B0152
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:28:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BF5A1C923
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:28:00 +0000 (UTC)
X-FDA: 84566670720.27.0B24029
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37152C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:27:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hbgvL5jA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5anaHbzdYbs1EudtIkOl9bSB2SSJTEzjzjFR/hSjgE=;
	b=sg+xNzEFwHo3kiG8cEA9X+0alrBHp8BUZqvBjE+rU2m+i4WPnG0Qq1md/TgCcNddoxZXHA
	k3ouEr8ywEJ6Jpdfri6OcVehypivR/Eldfor3pQbGZyO2sGaHk7hMr7hDeiyTwTr2LRqzg
	xx1+1KypMNw66G8X6VEFgAUWR5qDDTQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hbgvL5jA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774016878; a=rsa-sha256;
	cv=pass;
	b=oNdxabC/XohQCrZRpVH1G46QamN05rmwxaExZ2ay8YSwgqr6dAtK3GUh8v6F+lMgG6X5Fa
	I/WyIA7+psOGVqRYyNu0k7ITvMYZ+RXO16THzy3fSnwQ6bMUWGidiHuxbJi85eMAt9SuHs
	xz/+1YswZpNFcMoo9qBFxqWh8Ejx5/s=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6611f41eebcso910672a12.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:27:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774016876; cv=none;
        d=google.com; s=arc-20240605;
        b=GEfc0fbfINDvsQOExTT1ZCzGvXvhQv1ZE/n7DLUl65+wBbnbrLJusAKGKH/lHCEti+
         j+ZgcJag6p/xeo+E5NbdoyliUsN79RJNQPdE3EdsxFY2f+r49QfJM1VAhoJk9ihM8GiF
         jFMYPRzykmE0Ltag1GTCiWPe17TVlq4jIJIVCd7/0C4ATvOfvvMkKfWJJ1OZ8vF+QB2J
         kKQbV3+nGTGXmhhIayBZ1uDWdQFQu2luLRcetO44BU55BWHe9IpjjTahRA8XexdV9rgZ
         LFgcu6PMJzug4Ouer9W4ISHb2OqJkecYneNkRDvxy8NYWU3JGj8X1BbVkrG7nRcPLM+a
         XPdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D5anaHbzdYbs1EudtIkOl9bSB2SSJTEzjzjFR/hSjgE=;
        fh=QCUIgDchWmB6yslFW8In51iqsXkseLhVP6vZ8rlXigo=;
        b=bHdnmfJF1xy38ZmNEEgjxAFpgWGovJoyE0bF3hQaFLIdkyHO9NDLoqmsAU1KyyJU59
         ENt0ZF7QXYzJdk401CffEYfj0DumDAqWpCH1sFNnNRCeUDwkaBs+0CzKzLadyKpoZ8Hi
         bIRxigeg6FHdJsdHP4aYlnJLZuSUJ1lJWBUQr2V6na3DFFh3VHTlfRseOi6SpCYkECs6
         iZm7+/lkiFlM4Z7M2db7TwW5Aq1z/ZwGqx5atn8eJKT95Eh4GKHIz2X0VMGQLVVVnhci
         9fmEuJw0vdUb9J85p6paTfLF3GIJxC0DNpPTAStcAIM7fQR1hM69fHnnA80SjEQ804HF
         9eVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774016876; x=1774621676; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5anaHbzdYbs1EudtIkOl9bSB2SSJTEzjzjFR/hSjgE=;
        b=hbgvL5jAr+AxV6kdU45ENCNs8oMxTbQhShdVD3e5PDqBWR4agoDr/GCAM94tmW2x/W
         U9ugXJWYqaHWgghzHs8exhh3LH0TjJ+Rqc0eg9WvYKY+qa8KLHqR++9PZ6srn+L0psAu
         1kKoxIdV5+Pr6kkDUpFpr4FP6eetyTwSWKtyAr5wcOk4S4tEIGTWCtulnm3zWR31pZev
         Tumxg3HukyLVsKm4oSw99B1WcN1izarLrHmO5nMhlnAXLHMVJNSvgMEHrTyDWJtmemoF
         Fpq6ngJ/1kWuGgf5NeFDt3SqCdLJajvNBIt6zk2IyZ0DVecR45PZZ8lAEZXXxGUNfe+F
         rYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774016876; x=1774621676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5anaHbzdYbs1EudtIkOl9bSB2SSJTEzjzjFR/hSjgE=;
        b=oMxLzcO8dX5JONLfAcfl+DzL1CN+sXka4uF78pynP0tZa+9Nw7EQaIHw4SMbly9oyC
         qV1Hq1AIdnDXSCszV4LL1YQy2tYfii3/zu+aMZz2OvPfCBNe8U07vSWhA/0A8eUsgZPF
         4BHAPweXt2FfmzrVLApLTL2SQfZgp0HOYsr4SyLYltd68jhgB/OIkhR80l2rnhJNtZYx
         Di+Go40pr4mDp9x5my21ret0IXvV1njcaB6fvlSWdhqlPgA7G8hj08v09OpL/9A/z5DP
         3gqOYLHilb0EBHYU9DvpYVW6vS9MCiwzZlMQlO2/VHHp1Y3E5DV+YjI7KAGofbCjUc4o
         9/zA==
X-Forwarded-Encrypted: i=1; AJvYcCXZjq8lr3Tul2ygmpjTwc/39cAZBceDtdfCKV9MgnOQ2JQ/NadmnlMe2slQTf+1klmPzmRG4dxxFQ==@kvack.org
X-Gm-Message-State: AOJu0Yyg0iw9Yz3CRsttJhiixnJSIl13VxOb1avS/GbNK7TTVKZzef8A
	mXjurPXXEe9e+uVgOKfnz5bjaiYhFx6t6VpZ5F+todh++J7rKZ6Fb4Z25/xOBjBi5GPzDT9vmS9
	Yvc6d8h1gxUS3zzNv2GQ5WoI5ZJvxxjHXD6iSvnay4A==
X-Gm-Gg: ATEYQzyls+vJWxDAxVW710vKLhsGRz2fbKdDwynLOF3uJcHnmjfojON4OM3kf937JzM
	FJQU/e0Ip4nP7/e9xAX1n4VsxqA6Cta9vStiiU88WSHbzbdfyfh/HiAX6Q+wO+EHkKRSvqhXyd8
	Mb+D1rMilzCiVKX80zMYMr0/sktvpeSlmYZagMCMt4jeM5bq0bnS4nltwjyXKkRPBulK19pIs4v
	TOfIxOM2HP+Uk7k+yZJkS68wJXFyTNCdVDDzMXF0vmhGh3XfnKcK5QmTOXVOdfcck5m4c59BCuV
	LdtNbsFO7ALAR3zLyNLjigPVS9e4TOG3Nh64kQU5kxpo7LQu
X-Received: by 2002:a05:6402:4542:b0:667:ddf7:7d9d with SMTP id
 4fb4d7f45d1cf-668c971954bmr2121321a12.10.1774016876376; Fri, 20 Mar 2026
 07:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260317023834.487682-1-pasha.tatashin@soleen.com> <gdu6kqpymqgkzbw2yrvvsrububimn2ocuyi533d6llofqu32kd@sqc6d6hsuzic>
In-Reply-To: <gdu6kqpymqgkzbw2yrvvsrububimn2ocuyi533d6llofqu32kd@sqc6d6hsuzic>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 20 Mar 2026 10:27:19 -0400
X-Gm-Features: AaiRm53KwLS0dZ_0F2E6R9Ka7xHwPaNadXUdllrLPjUjJCiW_fFG9VxgEmZKncE
Message-ID: <CA+CK2bDGvesu85nODXTbHQDy_UndWyGO-bNHcq5gDReX+fyz0A@mail.gmail.com>
Subject: Re: [RFC] liveupdate: prevent double preservation
To: Jan Kara <jack@suse.cz>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, rppt@kernel.org, 
	pratyush@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37152C0004
X-Stat-Signature: wj3x856xdzkypowf87qbqbrskq337jw7
X-Rspam-User: 
X-HE-Tag: 1774016877-751941
X-HE-Meta: U2FsdGVkX18PTltmhVHFztN6oal8kkn/h6E7PTrWvVyXGuSXDiljEw1Gc2dfS3/yDWpa7KKQwJ/spV8Xni5UQutmwGPSfLi4/oBNFI0ZV9UFOPM+KukDH3KB5tylzxUF6bJgs8XZdi6MqN2JZdeyGdZRVFPNmTWgCXYlkde03yfIOP8cYON2l8RenHA1dYfvYhUjBfT1GU857YgWyzpKr0zCHCNUOdv5FwlhCQK/Kdbdo1x+C9JLm4wl91SXD35z/GDlxbcz2PLTA/aoze3PpCKmu6EWmPc5DXdvjzYEH/Gk2iaXGqSn/fqRs4+0gcmYHtqs+juQklDrLBhfsIBf4wXW0rljQ78bGzVgfwU78vtc76OB+z0vGcNDWhAz5B766WgQ6+R5pctXKnOzEVAjVuwuRNTNgC2Kg5aJ0zw31+BYEhpHdaCq7zvoZHMRfVOcwdj0QJQVPohEcluI2ov0UCYcc24E3ky7ptimuRMK+GaESjvLIVnKHqKpQ83owh0NO9Zf4mWUIzsvrxysF2vRhWO/WGM6KsclqUE2/P18NxIrqWxWkMAy1tTgSOJwdqCl16J0fVxkMbmDkqUhteWyqWAUEGaHPq0pN7hbEib/vBjBgVE6J8Mnk6lhB9oCSfTcZX4yNhaRFr+EjDg4nel84gSusXSIrds8+jVqNJiwZsoQuOMB+MlHqkojfT9T9RD5TGHl41/l8d5+QSpkABE+aomq/aI+Od6OVwiGGwIhM4NDUDOtVWF0H9zCAjS8NJNIdgOsOn+ksaOOCY3O3b2ccd5PlOhkjwxEZlTzLkQj3uJC6eSJ3mKXNZJIfQ0jpI+sJP16oDeBOFDXZKDyCuv2CPacLNwKbefcFgg9/Y6P/oisOWYTLT4RNU1E45rrCw4ZmeEtISXUS19xMO4t73PR49JEVmIDEtGkhvokOGs0eTO37GuYAvMaPUpj0US3dwPztDuRayEMxH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 9:47=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 16-03-26 22:38:34, Pasha Tatashin wrote:
> > Currently, LUO does not prevent the same file from being preserved twic=
e
> > across different active sessions.
> >
> > Add a new i_state flag I_LUO_PRESERVED and update luo_preserve_file()
> > to check and set this flag when a file is preserved, and clear it in
> > luo_file_unpreserve_files() when it is released. This ensures that the
> > same file (inode) cannot be preserved by multiple sessions. If another
> > session attempts to preserve an already preserved file, it will now
> > fail with -EBUSY.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >
> > Background:
> > Because LUO preserves files of absolutely different types: memfd, and
> > upcoming  vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd)=
.
> > There is no common private data or guarantee on how to prevent that the
> > same file is not preserved twice beside using inode or some slower and
> > expensive method like hashtables.
>
> OK, I guess since this is a single bit, we can live with that although it
> seems a bit wrong that LUO needs this in generic struct inode. But all
> other "cleaner" variants I could think of were just an overkill. So feel
> free to add:
>
> Acked-by: Jan Kara <jack@suse.cz>
>
> Just one nit below:
>
> > [1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google=
.com
> > [2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@googl=
e.com
> >
> > @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
> >       I_CREATING              =3D (1U << 15),
> >       I_DONTCACHE             =3D (1U << 16),
> >       I_SYNC_QUEUED           =3D (1U << 17),
> > -     I_PINNING_NETFS_WB      =3D (1U << 18)
> > +     I_PINNING_NETFS_WB      =3D (1U << 18),
> > +     I_LUO_PRESERVED         =3D (1U << 19)
>
> Add comma at the end of line here please so that we don't have to modify
> the last line again.

Will do.

Thank you,
Pasha

>
>                                                                 Honza
>
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

