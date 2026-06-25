Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99E1CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 16:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906476B00B7; Thu, 25 Jun 2026 12:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7236B00B8; Thu, 25 Jun 2026 12:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5F86B00B9; Thu, 25 Jun 2026 12:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46F446B00B7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:12:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD39B1201AC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:12:47 +0000 (UTC)
X-FDA: 84918928374.22.46AB21F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id B830220002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:12:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zlv05mcU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782403965;
	b=W+HQRY9WFH8H1bB7yQky+tuLbPf2Y4jEW/FKkuZcsnGbxHAwTnk4kE3X3nMN+yK+E4XMAW
	HjAgeMA4EwklDt2IdQeU7nRd34i5AdbV8T7Voha+VsYRe5oBsRoLimRplhbJ86ePp36LM3
	TezHrwRO5pqCyVEiOoiEbNI93J8hmT4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782403965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
	b=0EEnDZQ35UZKkdPnmb6gd/FO/YfAVRBInH8hxcWq+n1KGzDFTTkF+Y6K02mdOHPoToiZ6v
	23MV3Wr1Y0QRmQ10Gta9fhCAUxJ3x049hrrld0AVrhyki7wCxQ6zrTRSdeB7/DydRPMWfz
	SRIvrIQQhIhoUkE8O2/Z4VvR/NXR8sQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zlv05mcU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4624c1409c9so2043603f8f.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782403964; cv=none;
        d=google.com; s=arc-20260327;
        b=GoUYSAWyvByWW36KLXOaA7tEh6RqrCHRH1OdBVCA/uoV+8VNE8VOoMz7p3lJGzi5Wh
         vix6/SGTw7DaqFvrrj3635dLquax2hMsv8dzgDFiydctfQL3mWrHbFpmIjOYSWHo8kum
         5deNHg5IciuG2iNT4Zgq/BrVf+iEAHs7r6iI3KS/EDf8ra5AgQcjsgzO83YZvjRTtkOh
         pJBhDtHhCnPbqAEEW5olTY8bbk7gOP9IFLS96nikbbcmpmmnxRooKrr5fpMYh9a9LJEs
         78CKHr5yRTUUXdZpSLwyo4XkROfR7o7pDU7KWAiHa02rBbuu79HKLxcN/qCcdIebhEpm
         rTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        fh=ZvDed5dbTSND31ENnWjQ9ZnSOMwcaOQ7E6SxL3xlEA8=;
        b=kwGVvl//NKiQcyGuMeAAnZ9lJlHi26dR8UtmlMVoIjLq6/+a+A+nNOshxOxnNvkmJ1
         IJgWu+td0spR6lqg6TxXqFKNg0XsgwOFocM5DgMEoPHX9oRv7JO0VGY9WLkih6PiJXGw
         g2aFNpJLczBlV9hJWaBDitmr3uz2Vjl9wyAyUWnmHFkGAdquF5STgAzKg4Ulff+rQM0M
         tXXSHNIguYO6kb9rXHjO8kKNm0NviC54dyz20igLQ/j8vurA5GiPSoZNnLzquHoZKjyY
         bwwhQr5iMIyRSlbk2NNCgB9xc6guJKM2JH1ZdLEU36EXyEXA+rqnU52nZHSslqDoUcGv
         xxDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782403964; x=1783008764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        b=Zlv05mcUbvLMIouKfcJxlxp/h35A7tggwmrG+3VuS+mHYpGVSRT11qMtyL0pyRJK3j
         EmI3qgwVxdHdcuEYYXwwV0bstNHgtZrDq5xuMyGdpRmScDYL9Wq2fYkxi9L3ioEGWaVD
         6vbGXaasJPgyrMeZp85Ucqt+pgS3c43DVfwDVpzMg/TxYlcIpjiKA2AvHiDUy30e/4gH
         oav+qYeCecM35YJAY6PjPb6bTJpge/64otCIR0P8K0fkzjDihBSxHErA48FCDnYUeC95
         nydAkZP9V6qM39zJROUkaJlvNndJutokcis50dOHdlRI00WYVmhFt8VgjHTlP26HHy3V
         17yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403964; x=1783008764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        b=sFH/XlLBCBZhGgKl3rFAy/l2UE8m7zfgm4sX6awfUTRkKJv1LpyQII0XOgg4++eGH2
         T2hMmS9w/KU20Ms2AwfhBt/cRZmXumpmoWLCZa8+NH96dlJ+kUF4zzeg9/EwoQgDyjOY
         HTAkEXXbj0EUqbXJ/uO/NU2pQ3ntkki/6je2YeDU++/2938rjYPZ438wnObbQmFMH7wJ
         CXuZqgYUI+WNHLBPTQ446lKaBRxyurVWnpKGr8ly3tMR+1Js5vD/GZi9YQd2uTFyYV+n
         xH0UNGeIw15O7jgolTbcbJpgKHYym+MQT1cDWmIAaVAXJaMgBSk7KJURm4IBq0gQz95o
         5AWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqgYtSr9yx8O4+r+4EDR2BaX0lSJ9LdxkVX6t2DUoF51EGy1ATrTXLPUdVyNbfKGqajGF2G/FA8bg==@kvack.org
X-Gm-Message-State: AOJu0Yx90Y74Is4j/3ezRQJNDfGAMnbT1YXmSTeY92uO57imjD6NpRBn
	lWfpynIBymmL85dF3RMs1Li8D2P0CaivRKMO8Ff0ikrMHeGImMz4euBsyGRvIvVcM/M0u71aH0n
	5zUxROgoweXbEyAfmL5ZKxt+Qq10ngg0=
X-Gm-Gg: AfdE7clKyTNsl+66xkq9yZ4BeZWOiFEQkn8xdKU9gimvdHnG8TA/x/1ouOsaoE275MX
	HWLJR/jMOhdhyVlYgOasfZWiT6yhHWrhdZH3qwtof1VhVMezp9zLmUISxcOQCfIeSQfsEylQSjk
	7biBnVDwg1PHNupxBx3Axr67nZAfjemmy/L4OoI3FyAOPEPO6KKVyLJZNEvx1cUAT7fEtD3jv+1
	4PzhLQML2rlhy/vcaIzqPPp1P4bvGzO5qpVVp3CWr13gsVJOl7GVAesxVnuRr1/lf61fPeezZ3a
	tNaeDXSHlBed/30mkhqbZ99q5B+6
X-Received: by 2002:adf:e011:0:20b0:46e:6210:ad4a with SMTP id
 ffacd0b85a97d-46e6210ae29mr1543499f8f.5.1782403963978; Thu, 25 Jun 2026
 09:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com> <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
 <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com> <aj0ku26XNT7Xc8x9@casper.infradead.org>
In-Reply-To: <aj0ku26XNT7Xc8x9@casper.infradead.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 25 Jun 2026 09:12:32 -0700
X-Gm-Features: AVVi8CclkB7MBq3wqVoG0kXa1O_Tzai8KiVnn_7BdwN2N3gQweVrg3KGSb5MSwk
Message-ID: <CAKEwX=OAg4VzZ6UA0BFOhnkz9EYNF2H1FHsEAkfFZObcbc4dFQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Matthew Wilcox <willy@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: th8jkk414o6gr9fmmnuspsgbm7ynm1jw
X-Rspamd-Queue-Id: B830220002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782403965-707590
X-HE-Meta: U2FsdGVkX1+VzeV4AxXXstClgiFDkIDSxK//Mc54n/6n3kTgkn4o8oFxJSTDIDcVpwCuZ1Aj9j8Z7RFb6yz464CDKKF2xQYsWOev5t+2L3iV6JQjBXyRIKYeLIDkRXNfvijPsMdZ8WH3P5i0KLb0LP1jW4XiNhTWGsonzYXj//bb2U3Ab36dcIiHoZ6hqPcXeb05vA8AU33efqqGwNlGtOc6BFqjBoeO8e25vvzdJtSAKY+WG4/y6S0ZvJRPPKMDYgtTcEt8mEAYnP2uM7DomBk5aUDtb9ANZECsApA68mViVBvVZRvu4+gTCmak/Dt6hWuoeBqALjdlBRtGf6DyR0sMwWHLuS2DdNibL9+cno4L7e2ynjcHZ6Wl6VlpVOJ/HfeF1KEn1TmEtKoFPXLcMTyXCTprRw2RBPADmLA2x4WoIENp8vIxRmhAwwQJRow/ZhRubuF1SBJgqD02fLkD39L899Fequd0KbbWUd/d0541ojdcKiS3UD1X1lYLTFYhoRJ1w4CGN+WIjv/8i/XN2TlV9XGuLdui3vz+YAltHGI+41r8CIa3qJGdcpon29ZqP4leuB+gSqxS6TKmh9QXhZ4MkHYpQgxP9hA0v+7WjjdQ4zudXeaQjBQuiEhQTWWdaWSkCxMNfIAv4vt2jNyadJAC2aiTwHgsIqMRhZ4sgZk7srCA0WW08AHrOPYiNiWN1rriZTweFI4fL0WQgjDftGJ7gfCce8gTGeQzH+QmeqASyGv1BVqYMqeOOcCYC6Nb7RQnFDzyZL1y6fmKGhKsOkYOoXNDuXRGZt1pkJCOWcKoD2ozntk7jrYXah0XSZ/w5jMkEVYBIV9lvrMtPq8atQ+RCbsfLURVE/KIOxBOL7EfWVbmCQCt+a1KFzvD1/2/ia8a9veDOWIjSm7uyY0/EOgJWD/pn0GjQ5Jp2EaG1daBm0ES8GS9thXWGzB3opJjKcw66I3SXQxw6sOs1hd
 WHXaXKQD
 Rf8dghdKLB8yT6YXA5P+5x0Sc8dV9roBC1Gt0L/uY+x4oXXLwWVa1OzIM2539V+SQV+PDaVXz+7JjYwKLFvnaFcVVuRclcG1MBi61rPoqZ7aa7SYgQHAXVGsX4VucVk/NZ+eSJDu7beR9yBdbYEHz66uxPgBJrwsiUqgwvbO2/qzELM5nxzZgBV9+bi5Pf+yKf+68eTLvqsJ5MnzmQ/YrOhXIun3zN9gelCXqDbCHBAIDDUYVrMc7PbwenlFalrkRFuyOISosf9GW9wcvvyRSzl/fRV7kqYhitduwuaUHwQCG/AVmh8Cz3kZT57RuFsQYK3Xv16v41pzLyPP9XFXv2MhEdheZ8hZg8iyI4YTSl67f/46jIjJsCORYAIu878X7RDc+JJ98r0K1uNAHjSKyCmfkwaIaVcsC0Gv0TD3HibtmnikBxnevovkJj1OK3FPy7FM4mebHgzrrN5Tj7GfCQwkJgJj80+wbqsj/HlVRp0lSf7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 5:53=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Jun 24, 2026 at 12:06:54PM -0700, Nhat Pham wrote:
> > I'm more concerned with undocumented/unexpected behavior (error type
> > in this case). -EIO was an example that I saw in ovl_real_file()
> > itself, but I'm not familiar enough with overlayfs to know if that's
> > the extent of it.
> >
> > But I'm OK with just updating the documentation with a simple note
> > that other error maybe propagated from the underlying fs, if no one
> > else thinks it's a problem :)
>
> That's ALWAYS true.  POSIX even says so explicitly in section 2.3:
>
>   Implementations may support additional errors not included in this list=
,
>   may generate errors included in this list under circumstances other
>   than those described here, or may contain extensions or limitations
>   that prevent some errors from occurring.
>
> We don't generally bother to document that pretty much every syscall may
> return -ENOMEM if it can't allocate memory.  That's just ... expected.
> open(2) documents the possibility, but read(2) doesn't.  I think it's
> the same for EIO.  Any operation which accesses storage can return -EIO.

Ah I see! Admittedly, I'm not aware with this POSIX detail. Thanks for
the clarifications and pointers, Matthew!

In that case, I have no further comments on this patch, and defer to
overlayfs and fs folks for FS-specific correctness.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

