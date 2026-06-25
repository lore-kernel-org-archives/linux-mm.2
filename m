Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA17ACDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4746B00B5; Thu, 25 Jun 2026 02:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB996B00B6; Thu, 25 Jun 2026 02:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2F06B00B7; Thu, 25 Jun 2026 02:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB9C6B00B5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:41:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FAC61405F3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:41:07 +0000 (UTC)
X-FDA: 84917487774.25.9A6C9BE
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE0E714000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:41:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OAFexs+t;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369665;
	b=QyEo45Q3UoPHlsbtFPbc98WBGUHOzbPxH9KuPWG8xW3ErbhuW09CgIypaAWLE+Mgi8sOa4
	FEBzs8PJLfSKbGIMgDchBY1j21qHiEXLAFBnZwJTEbHF1zU8MRtZei2R/Cit4v7TG/zgfv
	yVnPBU4hDzZLJoiKNfrLr9PdvoT6OuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369665;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoxZJjVOiXwcjZDwYFG+OwasLzMYbWC1yxc7WvB+JYQ=;
	b=hgKGggOQUuY+1RpHYy/1Im8Eh7+Ewn02nTo+eAbey4GBXMr6F4D+88WcC8FgBEaWSFA2YH
	XYgBLxyHZVerGRkElroEDyoxUakTc39pEbKTg4BrI1jiriqfGtLSHWUWy/Q+1ZdzAQShKi
	dGFYtlBsvHAX9B22pRKwIpoCIxOkaK0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OAFexs+t;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-befee9e5ef7so282672966b.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782369664; x=1782974464; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RoxZJjVOiXwcjZDwYFG+OwasLzMYbWC1yxc7WvB+JYQ=;
        b=OAFexs+tj8TWTg0Aug/jSJLolpFhiLALVj6GAjlpm7poy4Q5rp7pvSa+sI4OqYMUih
         sOBNvtWtl+klrWDvRWcLqnYNohrai86bVhgInX8k73IfLZrtNrBTssdl+w3Fph7FNHsT
         ALiLIpvY/NwJB8870IGLXAXUAz2WFT9atSxbgScqmUI6+HNJurYBX+OhQNrnGFkmPUDb
         kUAuMpfFOSS3ycPv/el1ECeg08U5OI6VQ0O9fZBoZUiEy6V+sl9ow+xYx6M/UzUpaHdm
         POAzVjWpVEoThytMlv6yVGVI1HiQQzAn2yRyqubhvweCok2t8aeACSESv7ymInFSxzc2
         kbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782369664; x=1782974464;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoxZJjVOiXwcjZDwYFG+OwasLzMYbWC1yxc7WvB+JYQ=;
        b=auvjujnMCTWrXmGKXUjq2JbXdNCm9Vjy4BSwm5ZpQzpTGhUWOsBdZ0W5GZnFp3ctuR
         bPavZPmWNEE4GXMiLSn5OrH9E0LXvEn1MdH4iInypZDT/uKBOdG2CpdXb5pX0YQ9Ltgh
         ClmTs/cNxgEX8BSKuKsQLzU7SGEzlade7SbetipuwCWeQlpF6vUx6qBYC+fufnLWzwcd
         W8Prvav8ZhUj1a0g46GdykP9azLvm/9beDsX7koNTiciuMoPcSbueuGp7H016LA99FQV
         Q2xi8HfOsRsasH7ddJLdwYeY4GqaKR5anRKaTPoDpu7Evl6R+V9tuVQNKVs/RrDMGIa+
         T2ZA==
X-Forwarded-Encrypted: i=1; AHgh+RoLQ+KIW7/3Z86ywA3BixJ1FAkcdy0GZbkzy+2cf0XGS4WHA2MxMYRf+MBDOiGPb0Yw9Bu9+0NpYA==@kvack.org
X-Gm-Message-State: AOJu0Ywl8TRcaxnGOR+MQqOBnoihLo1nlSFtttdEr0ogsTbtgKKG2Ami
	wzOJyXHkwD8ez+SvjG+zrzM/mQ1vFJS1GbvG2hQFd8xYXMFVFp2YMUAF
X-Gm-Gg: AfdE7clk8MbfUikslVTAJXPaAoXSIBh3667RetAD6kiELYy7HHmSH7pEJrpQ0uYTebn
	WEI6lezzjX87pDgeuUaPBxSeLkrBKg0qrVS3dieBsD/42s38PSSV80z7wDQFwVipYNaAVivpYef
	amZhL5chpnjoGboUUqU7mE5Twpebb2An5VXMecm21C7NX5MraP2I35YedkLzR6kMZOdtqUt2cZz
	qAkBRrzr+w9GBn1jNSYRjmhRMGUYurR2UdCezpmx/YoRsFcbNRzzarD5luFssOHojnMAUsfF7yG
	MtaPeY0l6Cfuf5EtKkQiMBFiSCc0QoYq3xa+cooG6B0hVv2szPuN9RX30hnrdtJ4qLBYkbLa3tV
	DRlOClTy7peJzqrMvzT4Qvy073sYyeo/5DMvouJE7csSWYUzQ2M4PN+8ONPs4VTZHgxlYWXFWtd
	WI2K04rJfRWbQ=
X-Received: by 2002:a17:906:e10c:10b0:c08:695d:392a with SMTP id a640c23a62f3a-c1205eae8fdmr40097266b.24.1782369663747;
        Wed, 24 Jun 2026 23:41:03 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm111119666b.39.2026.06.24.23.41.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2026 23:41:02 -0700 (PDT)
Date: Thu, 25 Jun 2026 06:41:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org, ljs@kernel.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, willy@infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lance.yang@linux.dev, balbirs@nvidia.com
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20260625064102.tcmvrctcqibl54yr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
 <20260625034629.nmgdwl2c4luwod77@master>
 <20260624215943.332f1bdcc99a3b85b7df0822@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624215943.332f1bdcc99a3b85b7df0822@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: AE0E714000A
X-Stat-Signature: t6ybw6rzurobwafga5uweimy3xx6wy14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782369665-325432
X-HE-Meta: U2FsdGVkX1+ReBnHj7I35Qws0c7mVphtHuAjxyTJ+FSHcQl6kTqZVosnVzGnBt13aiy96Ret+oIqj+1Fd1GiFrjsl5Ldzg4TuMC9K12q4IDf8fdSLIuOyt04d6Wkje8SIwHeSU4ZErc520IYmmzP2aqPqHyjMZxWquxEWzIP8Fpp7tvbiHqrUDEQ+1RiJebweOube1yT1R04hb9KfsCPug0045FgHznT//HLn0R4Jm2kmPIZnZOKMQWgGWGW/n0KyHlvQIdVItNIj3WjL6uc9J4PDs2i48fKbfUq8V7IoSC4KJ3ZWPXyOprvhUrRb86Ub/2Rs6j32CK9IyMN1SJQXaP1S+xd2aWXIUPVmWGaR4Bh82wnfczphtuTHWDySpEAiXnVkr6hXmsPJfNwG2c8Vp+w0divd/b5PgPH79EHe9qf6EfLAIoxNLnFZHzIu5OdSOqi8OxUYEYIQMWwWSi/mDMmuObB6CcKinC1vq+66Ltk7BDWAFxs1akZpxlCgou351Sunh8JLCv2VxVb6eh4lbQJGbvrnpA/PjjipEkCamGIYOwnapntEOxT0vVab0ynSmVkVOoLiDuwMMGecVVkDWkL2R0XjBrpV6ieojRncFIEy29KexDqGm/gsJPwskm1kRV4AcmXT/o5dEKohPSz0DH2CGtYw0SGlij0c0PHqR/evZcbJc60Ln+L+QT9Ud5evghKmgXWyh8ZLgCERcWrcBC2FrLE31Qt0IL8inaMUGCREIHDqndj7zcHSYLz4z122mN0oa9vg1PdKgdD0Kv+nIiax+9SYFO43IY47iMhnxYXxVnQKffMMm9PW0X44/4VQk+qOi4jsQ6utPiWFB/+x64tPhyvDme8bxCc9rkHhmTLPRk87Y8CjzivXNO/2wBJMYHWfUhTSLvC0ajb+blXY7wvZNzlb11YO9z4ptN6Tl0WZS5UXYoBX+2kKVauGN8F9ZcgMyHQY6eBahX2v4B
 cjOViVv/
 qVmv9Cl6kFVN/GffJj+e1feUeCG3SzLV39vHKAIXrYZcAMsugGCzHqrTwpO2q2d4YyfGabTl+ctJMlDPk71B3NO1mkhQL7LcY/KBVWbTNAA8HORpbSga8F1x0VX3WV4cuu0+d8Mdrd7XgkAowMMuzH8xGOhQ1+K1heVglxZo0NI5PsDeL2M3rY/mm8Z/Yk+aVaJ3xOB+XhW2tCP0uXZeYWfeOpep74pAkhpJbO8gXhFepqR+mKyXp54JU1hna7toLczbAbPNhuSx9vl8G8UoUqqQ0vBUf4sGzxNOkNNnRM2D84EZ37WK1d6MxrfxH4m5h3kwgR2X6aQQqP0PMb780C1FpBBD7gxE4zA5l2U+ieRLAviVErexUSEEYIaNsDWDAliA9yt34uAElLb6c1vAXEt3mBzgjfP+yoMb8pJ0Z49WA999QY/vpl4yfcNM7/0PPVI4jWPx9rzM9Y+MaY8MbaNHBdBtbDpVrii3IjlP/X4ebwiXXbPX8viQyKnpvDec1gghrETuftAC0O+qb0BH0WWPK2gaZURx9/zt2TXLjm2eKjlMaUPiHdZasHa/Q63nm+uFHkVOrwcZJgDXgRmtsPLXxJalO9O1wIgMIwGlgkcUMw21uwK83YKtud2i4QNvnsXGGz6RiKZ21olqVFkbVLn89vL0Ozup03GjMoinwQKQQtOk0KPuJhsV8uM5xS9ZrCemBEKjRCw6kRe2PaqkAKgA/T3Ew5SUxlDrGiPWxBW1qbCHYeEHisnyeQNd9q4z5Qc0WiDsLdKb02T1nViEdUTEaF3oKzXPx6G+5glS36VbKc7G2CE0Fliwd8Zkxlv3R5P7M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Balbir

On Wed, Jun 24, 2026 at 09:59:43PM -0700, Andrew Morton wrote:
>On Thu, 25 Jun 2026 03:46:29 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> >Sashiko had an off-topic complaint about the surrounding code:
>> >	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
>> 
>> I see this robot reply, but not see the Sashiko comment.
>> 
>> How can I view Sashiko's commnet?
>
>oop sorry.
>
>You can go to https://sashiko.dev/ and search for the email subject. 
>
>Or append your Message-ID to "https://sashiko.dev/#/patchset":
>
>	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com
>

Got it, thansk

This one mentioned two things:

  a. page_vma_mapped_walk() return without check
  b. whether __split_huge_pmd_locked() would split device-private pmd

For a., it is being fixing at [1].

For b., to be honest I am not 100% for sure. If a device-private pmd could be
file backed, then this looks like a bug.

Balbir,

Would you mind taking a look at the second comment raised by Sashiko?

[1]: https://lore.kernel.org/linux-mm/20260624065353.1622-1-richard.weiyang@gmail.com/

-- 
Wei Yang
Help you, Help me

