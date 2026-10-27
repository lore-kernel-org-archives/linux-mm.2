Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B62606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rJOvd+u9
Received: by kanga.kvack.org (Postfix)
	id 896AC6B05B1; Mon, 26 Oct 2026 22:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E016B05B4; Mon, 26 Oct 2026 22:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738386B05B5; Mon, 26 Oct 2026 22:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6556B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:47:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB03614057C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:47:48 +0000 (UTC)
X-FDA: 85366871016.04.6CF588E
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf14.hostedemail.com (Postfix) with ESMTP id E71CA100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:47:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJOvd+u9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvDhK1lQBCnTBgCeDn8IE0UD8FXFRVaT+2qmolhhuoo=;
	b=ZAqRx8UzLvGpwwVQa1fKOZTT+uZeWTdaLokApiIRihS3RcaPsKJDNDYsxg2Yc4lDpn9Gh7
	2uCcHeWQOF2ct8YkUC1VVj23xGfbJDpj2RRD721p397E63l2NMBykOdjGsApSZ3y0zFLOs
	wg2VjK6yG+wxLAwBBwlhWehb6NejRto=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJOvd+u9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069266;
	b=0EYXTfsz0f7cdWWC3m2na7WJcM+462TTHNRy1bVhrHryEQgktYYKt66FL45xQazQ7yiBK7
	6/q14P2EhdcDxYUMFGxBCOfT3B4li0yPT1KFIsmhd6PJwi7TbYobPPP9Bc8RmgEFm4Brcf
	Qq1NIL9YKHiCJqIdqr5Jfdu4Mx4jhgk=
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3ac63aee1ecso707932a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793069266; x=1793674066; darn=kvack.org;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lvDhK1lQBCnTBgCeDn8IE0UD8FXFRVaT+2qmolhhuoo=;
        b=rJOvd+u9pf3D++fNQsH2nZ07sqJGeUER2rX3r3wP2gsSy6lqjf1iRpXxOHtMotg7tu
         DKE8EPXiIrTzqtjNo0axCHadSbZM5KgzGG+qpf89VPSCa6hYe+MMkxXVlN+gC53ruUAG
         KjiuHg+9Qy5Q9+87IZV5RaUKII8cpZGRS/qQN7uxg0JMamiXmxcgjGCFlFmsM75PvDjK
         vlELSkdxGA5NF/1Je2ZkD9bACzaVQzRIVhsmU4ahfjwv3r19ufOUojpmB64h94tW5QNe
         IxLrn3hQitiGVKOy1kbgxWxYpcS80uTmKP6th6xawKyB7vcVjbmBKYRUFeqHwEZ3IBcm
         DQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069266; x=1793674066;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lvDhK1lQBCnTBgCeDn8IE0UD8FXFRVaT+2qmolhhuoo=;
        b=sGysr5um4rBxTmK214zkqRkDU09zYQzyq9OLJsUwKHQkY0GfoHl/SaENQAn8nQhHbN
         AI8OSDOq58lb3WsscVA8CkoI27EiTWh8jiBnYgzCeAdE5bGKqD06LwjZszZ25H2YVmam
         bM2U8vKHwvQOrjZKxckCVMyZGykV6kwzTebArEqcMgfRnWd5EbUjY7fOeGw2xrEEuyB7
         A2N32Be2wQN7o500UWR7XzYY6OuYR2VJQeFALNXD7tW/NcZBy/ayh0yzmtkoYM+7ptGh
         bhxYwxl7jNTE66Ug2RcHbhQ60jK/HgwlvVubGakdUCKCHL0GGa5ahdGQk0ktEPHxpK/t
         NCQA==
X-Forwarded-Encrypted: i=1; AKwUvBzTrg9O6E715dfMHJ/cv9wIPgEHLzwcTrw3gFDP9h34HeF2WIDTMVOL9X8VayEEXuQsmA/F319TMw==@kvack.org
X-Gm-Message-State: AFq9FYLo1Li3CIVOABVWgFx521oODcj09KvJwy9r4eYNEzugO+O4Wkjb
	OIxsIJwZfHDuWOJAZAa3fpnP7kSSiZOlF3PEJ6Pqk2ohQnD3DOICSaFRuX2vQrWg
X-Gm-Gg: AYBFou2DbGDd5czuFRQwKLLT8x3cVIh89WXfPyfiuH6nXlBwuKcFox2gyHIZTUKdTSA
	8PKiSOKO8djqn+6fOZmol3YDo3Vf7bubFnYAhYzBhOFS2mILQFD2q2e3MmWLmd+XCsSr1h1fg3x
	teF4oFG5WJh8My1B+UYKrUsKUQn9oUPiUgX1Cv3Ooh9w6lVul8ZpOlf4wbaH/+fAM9G7G+HfkFY
	I28RQ7hBmzI6yMm3SaWs5/7Yxyue1QccJGjcs3oa5grr20EhLuMuxkjJoPNtynm5UzB8e6yQXke
	iEPQUu45TddwQwtJ6ajf19wyuB9jAvEl3btgxA9QEqO/pADnoB6hQAKXIXoK4wPu1yU5Y0dSPSv
	cTLLiBrymIeEu2mCPF+qQ4OxxICEWxhsyG3gMCUfJ/8nHmeSzjM2Fun9U68xSVRH9ipsjfPeqrO
	MF2MSndsNykcByu0+LKx3zOyCtJnRJU3nMOuorEBx/Jka3JQ3Lhf/14Wu/A2t9Ew4JDOkx4h5TC
	uP8maSsQ8baffDR3iLURwAambuyFtuq98O0DhDHgZTB0HpV7t4cNIplGv1lNqzzWeSwSOQV5D6f
	vcGP1CD57OS+GkGFPUz55OKLyLPsYxVz3aWtrCIR1kaL8weQa5ae
X-Received: by 2002:a17:90b:3b45:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3ade9b2cff5mr7922722a91.1.1793069265598;
        Mon, 26 Oct 2026 19:47:45 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404426c2sm1518262a91.7.2026.10.26.19.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 19:47:45 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Docs: damon: fix grammar and typos
In-Reply-To: <20261027004916.160854-1-sj@kernel.org>
References:
 <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
 <20261027004916.160854-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 13:46:00 +1100
Message-ID: <179306916017.2.12297411301652219760.damon-docs-footer-reply@gmail.com>
X-Rspamd-Queue-Id: E71CA100008
X-Stat-Signature: guxph4fwx8iy6ocef7ko5xiyz49mutcs
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793069266-627809
X-HE-Meta: U2FsdGVkX183Y9XsQxOnLpf0TTKklrTzVbO04gYszYwVdKsPC85I3C64F4Tp/sMeiqgr2/r05c+N7hCaCsrbLbfvHNJGvrGUqaFHTlnW68P4OC7qyZ3p2HeLQ7v6Q20AZqrlwzLOLD7UhRV+vXYx/vTnNlYbGhN2pBHZ6xCkmfSM/2NS0rWhGb15puDwQGrG8nWSNvNJgMngbSUZ5G66LAngeASbKuquEm6uWoR7tFe3+lONloDN0hQ2SifMLJWezkhkZeQCLvI8HpS+veOo6d83orjHZMxMHnFoH5wAorFt2DLBcJ44Xu3ZjZXYZbSGTpSEoqdNt/VevvbfHETS+xjqO0xK16yNg4t+byA0gjuZ/6b+77EjnZUbbmTwVHF4ZkhWLlXjViUpFwWobLL6Dbne91KGkMAg/CtGEWxUnFLQlX8nuQY5n3R0MyXmSvDJCL9boycPZMPz66+dcENJ4j//tZkxNyc2R+lErAIlnsFPMZY7i6XVEncxX+PxCikBSzwRvQ1chtXFq9y9yuEHISpPPcSIUgYAtY+esgwBRT2vJqcdZ8qusxzbj8ySE88I9wbTe4ZIg53gJntRgwGVZCwiYFyWWihkP7rrBkW6iO0pheWQweeKcaMOi+YXcmNGvtGCRqhAKrl8hqC7zyebbIEoe0HVcMQKZMMwbcLdkzidYbx3VDxXaU8AS1cO3FcH3NcH6RNVkirHTL3fCptOqfRbtpp4dkBXFXMSSkbLuMAo0OJveXknznTdecRW9GMeVTRoxhaE25Gc8gExz8A4Ceyu/dJI/YKNPDOe0/lDl6divSbO6ayV3FPlxUh6TS1TOS0TBMPWbjm7Ehrcn32iCpG2r5BI5PQtXp8YHmyArVeNd6BLg5916jb87AfKxXGknK2KOtCE3FljPMjxSQM0F/vunNuQ2BRQY+0nub9iao8IttN4SJTv1/oXpv2S9kuOoo8F+KTNP9d7ZGDtoFh
 BkMG+BEQ
 S3gLwVRPSfNinAzCOGAKn7/9CeMBtOXvIJoEcIDU6pdsXLq4GabrfoIeqZGF40iWYEln4z+cxKIt4SCqwlbWDC6l8G+8q1ats+/Ffr5NKQAb8koX42owCnjchFPR16UP1XgJVsH+09B4OGKcm8ezeiHJGqMptr0msFq1s8RIGnWtTSESb/5EYOWAQ67luQ0dYlTSNYL1XbD7SKcLLnKI4YpvJ9phurJlXxskcxd+gFpgg5WVfWyjVQ8JXpYM8nSje26DL3HzVE1vN5zJmX1eAOeACFXk+tZ+mOHaCAWEK7rk8xsG82Qkl3nRNb1csegZO5faO89FKxkYVqltEk79ttkXdop6Wt1wEd+OoPax9pbebTAkblsm81stkEjCC/ctCXvb2pWxmO4wBeM6/R3nzKqdFF5RjkF8EvGqdPN5H7zVmmgR/9d13+JigtuiOXhxVAoPuSH8q/LxEl0hUxOCE1a13au6Vd42s45sa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Mon, 26 Oct 2026 17:49:15 -0700, SJ Park wrote:

> Are you intentionally removing those suffix, using 'git format-patch
> --no-signature' like feature?  If so, any reason to do so?

I was trying out my own script to assemble the patch emails this time,
and seemingly I forgot to add the Git version footer. Thx for 
reminding me that.

Thanks for applying the series,
Aveline Noir

