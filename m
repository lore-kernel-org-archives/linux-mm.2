Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4327F588F7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F037F6B0088; Mon, 20 Apr 2026 12:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4906B0089; Mon, 20 Apr 2026 12:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA446B008A; Mon, 20 Apr 2026 12:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBBC86B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:39:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AB1C160ABE
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:39:25 +0000 (UTC)
X-FDA: 84679494690.07.F56B224
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71D2DA0004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:39:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AqlEkxd2;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776703163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8gMGzux05P1JYM12/TA6AXH2BbplQrvfBJtB4GEezU=;
	b=rMrGEVtPtvUW37fYwxY1RrFsaWGgIom1zuRjLPsCdYitTUQ7ZWGvbzh+tcLYqF7cmQ+0wz
	rptR/uQB1mRsCmHDoKQ6GLnefr4ZTRMZ7WRmtuxk0JM28lJZjmo7l6TlM3vQsJE2wbsZaR
	hVbf+uAqkhDyFDQYfTIGrgaG/UulbwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776703163; a=rsa-sha256;
	cv=none;
	b=FVan4AO7aby79VKv7vczoOT8NfNLuDpQMsDvOe2lhbPaT8Diaql3OHZyEauQlc5CBUEMb1
	fL5ID3DQIeXtTyJViDWL/xTyL6mJQxXIRJYIOU+GHXONbSwn+uX8hx0FUMTTV+j/PuGnyM
	KJrpQoQl5gW3NCmmiLYXv2PyV7anq9w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AqlEkxd2;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8d67a483d3eso365580285a.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776703162; x=1777307962; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8gMGzux05P1JYM12/TA6AXH2BbplQrvfBJtB4GEezU=;
        b=AqlEkxd23PpKVWzV1FGkMwNj1VW72sH34CuYWAy2E2EM4AnRb0CsCxmNdwqWiSj7Cn
         SQUzL64ejWpK1rmcRJGQpXuJBQqHBOktCxoMvc0Z0tQ1nyODsvP8o48oGglrr9bT3qup
         X2yFWiCqBnF0e0XDljFwmXCHp/cdzvn13w1h+maTcW+9EvWO7z4adfbVujuKX3lJ31w4
         Kxill4kdODziE/9yXcmm3TPTFFMwKJRD8DsunioZjSYgJzeJRZgmKivLS+0p6g+fmd2O
         WbuHnbg/uhXwPPhgklorTi1b8D/hsBZkjNqCOk7Kkjzo8QhOE0Bl2wr23VR+au/y3q46
         Vnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776703162; x=1777307962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8gMGzux05P1JYM12/TA6AXH2BbplQrvfBJtB4GEezU=;
        b=TULpa3UPvV87MeZmoIEWju7z7QS9nUFKNau2jgUaR2cnDIybUiJa4WPyUhFMTIEjwm
         5BjfoQrds+pinYZRb7ITRf6az9ItXX8pBNtthIYrsl4K1PP53T7ecjXOtwnkZ0GhiBL0
         NEgtbr5aT6Co9jFNrnHdpfR8LIEXc4sziN4kBq30HQoU8JLhTOhNaZwRyaSxBlj9QfuY
         dfBjOCMHwTNY/q2dLziaO9r8BpN7woXjU6AevIyZbukL64fM19HYvl1GDfVgDds3/9u+
         PF6JSvVLOatOl6lYSgFdNXYGXKSee5VZMxWt3cu6lapxAWXGQk/gd1wiSxxorJ5t1zOs
         IgFg==
X-Forwarded-Encrypted: i=1; AFNElJ+uvDML2OJN0a14uBQN72sbrKCvSrp9y2W7kPEenO7KqxqGXLkwwJJyboA7aRRfxEr3d0F2JdFBGQ==@kvack.org
X-Gm-Message-State: AOJu0Ywxba8ucd3c3BWt0l4/OCl484j5ziOJxDKoKm5qmgWpfh92WjW2
	e2fP9dOYAmzQzoqNzvIaExlxyx+nEspKz/uAGzs5qis2LInfygoFeO531uxu45h7Q14=
X-Gm-Gg: AeBDiesLQ1j4BmHc2ZdHbLNwUegmCYKDr0d6lieP+73Hch8uAhyydRN5kULvCvuBIZC
	B9nRCOosrx761fvPyyfAWSZUM+xFFI73WJ8pS24A2l0+KUiGcanXd9V72mCKrEoYKLVIzcMP/4o
	CJyXTEIm126pGULJUeGAfTfrXtY58Vd9dJOcV+FM+WORl1izpbdSq+d4p2wM2UkvRzYpj2bTbHF
	CWmSCkydN4hh318pLpYwEwOlhK4mPD9KLQJ8NAyKQ6Rg7Oh1h+32GEvDzh0Yg2bL4SvrFC6p3x/
	y8K45oHp+CgxcA2N7Vg4+uyRh5tRGTyEELaQFIlrvMe4g8fH+PILGZfanDuUC5CSmVNJ89pyPXY
	IsAd4Z4+6okAk4DzfNww+epT4falIMJ+2N7S9ONVJdIRtxTpu2qhFav5jluu7VvtdSCpEddCSHi
	3ommw/R5pkBvULUH+v+zgUGMTac/MQMgFNKY20m4NXqpETXxQQup9LTn+DRfk7
X-Received: by 2002:a05:620a:489b:b0:8c6:ae78:f750 with SMTP id af79cd13be357-8e7900112acmr2084208385a.14.1776703162374;
        Mon, 20 Apr 2026 09:39:22 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb61bc0d3dsm249145685a.26.2026.04.20.09.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 09:39:21 -0700 (PDT)
Date: Mon, 20 Apr 2026 16:39:20 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, luca.boccassi@gmail.com, 
	kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, rppt@kernel.org, 
	pratyush@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <dik6oamo2qluybxvyai2y6tq6fk3hun3rk2kxb5hdissaj6xbq@n2n2nm4qq75g>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
 <20260420-buchung-panne-57e262f5057f@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-buchung-panne-57e262f5057f@brauner>
X-Stat-Signature: ze9rn3dn7fbqfxizozbjhwo8ypox8igu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71D2DA0004
X-Rspam-User: 
X-HE-Tag: 1776703163-874659
X-HE-Meta: U2FsdGVkX199W10sQWtPyu0xRFZd8XBJDu9+fw4dh4i/shpYstLvC0CfTJQWfH7esmMTvqgVKQpRMZJFPPbsyV53R5Kaj9DiYv22n+n3Egqu4c8PKlA1s1LWcwFrlvjvoad8QaRpyTvUKnu496QNpo1PqJiDsPum5QlzAmWPr7uyBI/FI4ahIYRTMNP47C7txu7E9xnQH+RiKIaqUx9+MWrmL73Lj8dvu5qxQcMJIjhexAgMfU8bj1fJtdjvJZ/wfZDWOjXV6mllCryvIw6edo89VH9wDR+TVNtgoSt6kckC7DxxIb/TyuALsf3DoeOCNKIACjJUY+ld20HCMugG0zVjv/zPZ+K3WF8A1boJQKmGuR18fVuL/LGmLPAakPV2Uy7EAmnIWXE5ZtgFXE3Ti7cqkaboo1X0+8RDvVjm6qfz5/TnleUFCTRNknSoAiP9CGjDf8nVhzMECFVE5kcmH1BjWElJX7fbL0I0wTCAzAGcCiSfoUUmE7yk96RsYXDfDY2fWyIHdrA+3gXmAAuUtbC01Bhpa+/xe7AXF0us36ZxeQXsbE8EcuVZP0+HLKaRH/LDl2ALGo+SoO5fifBBbtSpxNKVEftq6h1gSxmGxSQ2xvjz80W+DGPQhkdm0bxiOIYO4L/BkyoZBDr3oe/4otDyuKXspyTpCll0dPGHrMz2/MEi1P6dIE4joVAfkFN1Jvk3rkSoLyVnA3eArUdL9QKaqNQ5J8gYZOTf/3Dk2M9tLrju+tfb3/ON3OFvm49YPwvP4HgDN2uSYU5eHYDfoN06aCxcdPYy0fRYOwdWvjgEu+4D5lVlTcogGROkDAaMyqBNOE+W4xnbIxd6RvBhoybvz1tbqWwwoRc1mmzzYvWbxw12BcJwiY16lSePkV3hY/8iISEySVASejGgsATTZ0VZiDrP3xtuKKwtaQlKW337zB9EEDiCI40gXQutHQr2NGS838gy0pqWZAM+qwF
 y7BmugUV
 7YgZ3j91Nw2k+MSBQNFcqd47FyeBJzUW8Yj8fjKrgKClKZVLz4lwy2bumddQYJdmgUTUIScTjohG9aeMDb+ItAzfikGVIwq59aYgtNB+JAkN+tDExvoHYc4Aktd12Hq+AqvRjNMsq389xBMeGXIO4VlSS2uhUbPm0mqNiNzbLAmde0OrTYJxvZKU4cucil1xAI3VbiszpVe+iKGLT1IJahxFLFyZ+vROACaRdTuRlpFP1iatO1nnkuTbmLLvfYjsnLL86eOhkME/zjG+huqJehct3j2YnaHcI0rYP7dLeZNxuatE9FE1BPzy59nPxussgVF63QvAG6hKerJvnj3WKFHsY4sz3wEvfgQRor/tzOtD7SjPOw3oJughq5lRgyIH+EmFsvAFb0VwpO8jPMdRF7+BK7ob2FnmVa2r2dmhM4VsL5gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Right, you're now sharing the same inode among all luo sessions. So
> > > you've gained the ability to recognize luo inodes via fstatfs() but you
> > > still can't compare two luo session file descriptors for equality using
> > > stat() which is a major win and if you're doing this work anyway, let's
> > 
> > Luca, is there a specific use case in userspace where we need to compare 
> > LUO sessions for equality?
> > 
> > Christian's proposed solution of using unique inodes provides a standard 
> > VFS interface, but it introduces some memory overhead and, more 
> > importantly, a performance overhead due to the extra metadata 
> > allocations required during the performance-critical kexec blackout 
> > window.
> 
> I'm excited to be convinced that the memory and performance overhead
> matters for luo file descriptors in any shape or form. Userspace manages
> processes using file descriptors via pidfs - systemd exclusively so. So
> even if luo session fds are created at the same rate and amount like
> processes you can rest assured that it will be fine.

That is fair, I do not mind having an inode per-session.

> Let me turn the argument around: You are adding a full-fledged
> filesystem to the kernel for the sole purpose of providing a separate
> filesystem type. Why are you bloating the whole kernel for this? Use
> the anonymous inode api that allocates a separate inode, use your own
> inode operations and then add an ioctl on top of luo if that's all you
> need. If this is a proper fs, please do it properly and with foresight.

That's exactly what we added initially: an anonymous inode, and a way to 
identify if it is a session by poking /proc/ for the [luo_session] 
prefix. However, I understand that is not ideal. I originally thought a 
luo agent would never need to verify if an FD belongs to a LUO session, 
but since userspace will need this capability, I am ok with doing it the 
right way.

> This whole patchset is based on an idea of mine and I don't need to see
> it twisted into oblivion otherwise I'll just do it myself and properly.

I do not think that is happening.

> I definitely want to be able to compare luo session by fd sooner or
> later and retroactively bolting this on with the next hack because you
> have userspace depend on the single inode stuff is not going to fly.

Sounds good.

> You also need to have LSM filtering on what may be persisted and LUO in
> general. All of that falls out for free _trivially_ if you modify the
> code to what I did. It is incredibly easy to do. To me this is ducking
> behind questionable arguments to get something merged as quickly as
> possible.

+1.

Pasha

