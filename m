Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF51CCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2C78E006B; Mon, 13 Oct 2025 13:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363FD8E0009; Mon, 13 Oct 2025 13:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2525B8E006B; Mon, 13 Oct 2025 13:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD708E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:27:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B34FE593B4
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:27:08 +0000 (UTC)
X-FDA: 83993771736.22.0A0F5F7
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC8FA1C0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:27:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="dDgi/2UT";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf21.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760376427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlBh04JlAEJRK1BdDBgwaOiFlx027z2aLnENKnusXLc=;
	b=614S+YEeigaqe6YM/sxirxl6ZJKHQcN0PqTEjr6d1JXMdpmlR9ZFbfzkwNwQlZBjTEdlpU
	LkJAT97HUmZSzrJ5E1dw0ZspmjdUOhCgB6Nj8K6gmEovLSIBGoNnKrjsKm1TArzkLEps3Y
	1q17eNCEZhR8vY3rqKrtA7SM6W8CS34=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="dDgi/2UT";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf21.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760376427; a=rsa-sha256;
	cv=none;
	b=yMuRq//5r+tJdKNPT5BaZiR2Bgz92KAcYIP9n7/vdz1EBMxpE7ak4wtEr4AE53pfLBuZYy
	CDco9/1odQOlBIqPybjeynLCUOqlhlWG+uDdcignOXW5MnWplvg6iEsLiwp9vI8lCp/ATq
	4UENKR2GgJ8GMtOdA4G5RiUgVsHpBoc=
Received: from trampoline.thunk.org (pool-173-48-82-170.bstnma.fios.verizon.net [173.48.82.170])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 59DHQsoi022727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 13:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1760376416; bh=mlBh04JlAEJRK1BdDBgwaOiFlx027z2aLnENKnusXLc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=dDgi/2UTmAMlprvgiN153Sh0qSgcuiuaYPj/HPuP5f0AS3kQwDJRfXiRYRP5sB/zq
	 1zLGDoUuH+FJW+weAaM0BYBuDA5PCcZo4iZO1UNSayJgdDVJ0fFZnMXICI93gie8KR
	 jjlut8MV0bh6sCyz3mznhuHeuTiz/KdIIGoLob6oUCmd18hvNohiELQbXILh5AwXVV
	 f7zSliNE/AdkPnIM+INwzgFo2AVjCooskKxPpDmdDlkNTD1hw17NHt5dDZUw6mxqoF
	 kuhrdDXTFo7rc62FSCnlGZSwXZ3yT3OFVV/hJnt5Iu1SnPgoFCnoF/cj+tpwH+oSDG
	 n6t6UlrQJ6QtA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4332E2E00D9; Mon, 13 Oct 2025 13:26:54 -0400 (EDT)
Date: Mon, 13 Oct 2025 13:26:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <20251013172654.GI354523@mit.edu>
References: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
 <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
X-Rspam-User: 
X-Rspamd-Queue-Id: EC8FA1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: txdm6bq7rrddh8hwnq867u8ohur4sbb8
X-HE-Tag: 1760376426-113214
X-HE-Meta: U2FsdGVkX1/ytK+DVxuohCa+IKma21d1tCIe0lDYY3YDZW3DFSXFToYPReLWazGkGk/UNqcofcwXq3sBLP+zP9ls9WjQQLhEtKPRafXjjnOuP5YrY1Wc/TKSrCNKXfVPl4QwGynUP6N+3JDoWef/j9Bx34tJUI2AiIHQdkBG8l5dnlb1m+OYTecO5WkECZEv6oYfGfgDog/Ijij4V+pqlE8C0DOS77BWi/1DfwESXKEZhx2W84pWyTXPj8b98HJYyrcwgIa+wrG1+LRHHvS2R3xUC6HO/g5cNrtRi1zDvW5TD4+2+hkFECrwrZKikVgC9OMicsYmxxKxzSdIzaQ8D4F5ciD68EBUvHfVVxKsKYEQ4I/IkNISss02woWXi5w1ovzZQ7A9YWbishW/It3s2M8d6bA/Y+mKVYYtqH0P8WsG5cGpkz0H84XXFzdFmcferPCgLalVODqlSu/MTbHhqvTvgZQrKmfs23655Qxx8Plt3VOxGM5EH4QjFtyqT0WuGh3blKgWrtb9ERo+76lFYnoQIL0jR0yl/pjrPMFfwYiNuRjWM9y5SO6hZG4jiuKkLhMrH1C8iazX1tq+v7epxU4W5luj0tJD32Nn5yBKWPQVMruBhHkD3Zx35EWIkymglzoQwbiI+JWYD94/OXWXWwjccAbqmCKlpWObcLpKsdShhJRjuqxfaUTVXxwm3Fdh1thskLyDXLMUf+bg1w8lDrmTXIkSZWcNB2BJMymSK4kFdCbHd/hhZch2Ff1NkUGCX1+1TrMGrj/KRmSR1k4mEmyO3gGQ2BmiFZHU2RAYQafjopCweEAM/BSIZoi5iyIDRhwxBShus8aICSmfyzTL097o2H4OhHF3V2G0/3G4+LU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 04:35:17PM +0100, Kiryl Shutsemau wrote:
> I also need to run xfstests. Unless someone can help me with this?
> I don't have ready-to-go setup.

Sure, I've kicked off xfstests with your patch for ext4 and xfs.
Results should be available in 2-3 hours.

	       	  	       	   - Ted

