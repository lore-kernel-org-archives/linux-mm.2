Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77577FD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCAE6B0088; Wed, 25 Feb 2026 18:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FF06B0089; Wed, 25 Feb 2026 18:06:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61866B008A; Wed, 25 Feb 2026 18:06:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC4E6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:06:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50FA51A025B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:27 +0000 (UTC)
X-FDA: 84484514814.21.3239384
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 34533140003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IiAaSONX;
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772060785; a=rsa-sha256;
	cv=pass;
	b=A8Al9Ad7vGCB8fBoNetYkcv7NZwUsLerhjmm7iVdHLrJCLDQyr8Fpx7PfEOGxIcM93tzrZ
	DEyMMhk2KsmhGK1ELOpwaBMFEQ3FvccxS8FMdfEASCsktAFheHaV+D6RKMPqDm1kPB3AP8
	Buwm4EHMZUD6jPmnF73buTo47YEg51o=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IiAaSONX;
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772060785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCcej487YgFKOPTEV46nBBjzZMXcrtqh5hw60mHgWDA=;
	b=HLXZTxYiRnudVQVYZ95H3l4J9EwEI9CKVR86DW6/ASYZCyr7Tppsx+AEyg/Fi4cCxiNLhy
	qfICHhQoof3Uk9FZ64Ox8Y4rr+lJrqJ9jRTvgsdOW5yt+PWUW/f3Zr73M2aCOQHgSy7Cw1
	VFcX74f2AkRwso3GTuK8oGfYfQ+1gbM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aad8123335so18415ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:06:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772060784; cv=none;
        d=google.com; s=arc-20240605;
        b=Qohglm7hdg1RcwBfJecMElcKOQRYpLYBJqo9SVtPHYuDVE/5/ke1Tgp4CJx4EFJpMG
         M2XaNxuy5XWY6Yopi3BzbVa4vwKdQOfBnX3UAVj5F9EEa4Lc+A6mGMpKGB+R0P/f90nE
         bOW1Qo/RRgRcjNuTh78xEHcfzTvX6sO8MgmFOMF9nifmCqll6xDc45bWb2iVsKnWKhPN
         NN+9/MU5CHoaEnnWc5lNvE9IKTHPNrxCypvOkFzYoggslqvKEvrSh9JC8SJHLntnU3Zi
         90z6DxmtR5MsUWdRNOabBS5sTWMznbfvM1MSj35/Jfm298caVAz+ZR3sRkpbzLsU8LrV
         rAQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OCcej487YgFKOPTEV46nBBjzZMXcrtqh5hw60mHgWDA=;
        fh=HyhnVPbb+jHBygpfY1GcYIF4rXwYA+KwwNIOC1P8UX4=;
        b=Xea8B3zu/lDe5gFgTPEdh6cqKhdNk4vkO6CyO65gjT9ZSuq6ntbwi1xH25QNIVfsWd
         pecBxJqaB8jsuH225GfIBI+atoZwpP0dGKqUnuGUFss5Kw+XU2vtvEl8eQEhV6fOivRL
         XsZL1h46qBdDb3ZdH3t7jyN3rpUzPZzV/rL+Kmn8mRU5GB8UkQ8gu/eNgftDgkPYsTXq
         2vXI0Wl4m/6Y+RA5MTADus14qo6ifoM7EamBUMso2Q1gJw/KzrS3Y1AQpFO3F+ZWVHQx
         BIVXUFf1XlYHJ8+2gLS8ce+ao7shywXxUszHb5TlDfmnLE9bL5ZXUgGRhAU08piw77J3
         MIhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772060784; x=1772665584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCcej487YgFKOPTEV46nBBjzZMXcrtqh5hw60mHgWDA=;
        b=IiAaSONXet5OK7N6rJjSPVYqntQMjgMbxOKSYCnF/0MTqqN/w0fJgNy56dZR/cgFGs
         T94ENzTKMIPD5zCY7WGVLt3xG4JpgmYyr6p1C5dfcsxTXl95hmwkKK8xioq4KZJHs7Yq
         G/RUtkI/IvQOydpbeKGAxIbQQ6VLwhS+PCHLcPSseTrS+MhuEdbjE5C4stxppXKeEf+R
         dHxn5NF4pabm+KCzFmMqyfI1uP6UYWb2TDsSRXvXfKr2XGaAy4Td0W/iAAtBMUH9LEL2
         h0H+spVNZ7Lsh8Dlj8N8FCy3uG4cdo7V4Ip+yVk+SWjP1xcKlvR6p5rlylFKIYfeAZSu
         UmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772060784; x=1772665584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OCcej487YgFKOPTEV46nBBjzZMXcrtqh5hw60mHgWDA=;
        b=hF5++P4H/PZiQta64FPyPHc4rKM/lHyw1lmbR440byEvy6omnrxp9SJMzdFSniS5Wi
         qqFQ2JmTUXnmtfyjLdE0geTFvnZUTa/INSNlaNuPFxkD26HDez9/z1dupfiEqKC4Zsz8
         FFUUs0UMAJaQpiyj39MBATVN9C3nTj0Q8hRQBG7EtTbmWjZQ7lzGPuon8Jy2nZdimwmt
         HkeX07NQ/a/nOVV+XqVixkRQoZp5eXsVQKeqxtILHLq14E3Lb3Y0nH607x1WtiZooP55
         HKeTcn1JUP8d02jvi+A7ZTrh8OgX+pNRhy0/hBTFdgtlg488OSwYqM7IKznAi/nXYb9k
         oJCA==
X-Forwarded-Encrypted: i=1; AJvYcCW9ZzIJo3PdyGrYbZWj0BLN145HMounYeVmFHhyAdi/se/UC22nGY8zxeP1VwkOYEZx0HIl1pS82Q==@kvack.org
X-Gm-Message-State: AOJu0YwZWfEWz8KLoooZZDeCCJBhW38g2SrWuBqdeGd77iN3VzNyMiST
	4kggymvR92EtjsMPCIa2JqvGuRcFiwdZZ5BcmPGOE9vA9MBHWtjdgXiQQYWp0ppkHdXmqnykvs7
	FBBaXc+kId5ePO4ey1umclQS/3iUpiXGtx1R13MZ6
X-Gm-Gg: ATEYQzzZIthOWYEX0iR/dB06LxR5DQ8yQ8jyj27/Re+EaxYxIy/drdDCJyvtaiAw24o
	VhQiIYjkLxnzeQzsBxQhBamPX339D5K3LEzR9VXCuAPkE5RrsTPCWad3jfsQpTDOqZDjpNYcgpt
	MlnwV3WDD9clpqL/v3TJ8vaXvrcw7Ojcc2F3gcraveIskawU2gtAtisnyhIwF9JcYhODcilNkym
	T7uf9hO/OMiYLqjHwwwdGSyEy+PF3M7ddR8LmxGVrKLAdJEt4taiw8P4kHAmuUC2AL2R/Sbfnnz
	Rz5CD+aVy2q9Gg9VfOaTBh70wE805SKI/dRAVw==
X-Received: by 2002:a17:902:ec83:b0:299:c368:6b1f with SMTP id
 d9443c01a7336-2adf77829e3mr890095ad.18.1772060783430; Wed, 25 Feb 2026
 15:06:23 -0800 (PST)
MIME-Version: 1.0
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com> <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org>
In-Reply-To: <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 15:06:10 -0800
X-Gm-Features: AaiRm53L_V-Oqt0aKWGxGR-IMY7YR8csbAzuy6C894gHyFaSj1OZXeEBVl8_aWU
Message-ID: <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, 
	brauner@kernel.org, bsegall@google.com, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dietmar.eggemann@arm.com, ebiederm@xmission.com, 
	hpa@zytor.com, jakub.wartak@mailbox.org, jannh@google.com, 
	juri.lelli@redhat.com, khalid@kernel.org, liam.howlett@oracle.com, 
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, 
	mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, 
	osalvador@suse.de, pcc@google.com, peterz@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, tglx@linutronix.de, vasily.averin@linux.dev, 
	vbabka@suse.cz, vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, 
	vschneid@redhat.com, willy@infradead.org, x86@kernel.org, 
	xhao@linux.alibaba.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	Isaac Manjarres <isaacmanjarres@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	android-mm <android-mm@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34533140003
X-Stat-Signature: shfi19d3cxo43umziqywg7kyg94rpudt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772060784-732673
X-HE-Meta: U2FsdGVkX18oXG+SH9FXzCjHaVKTySJumHmjtQZfn/I0OOQiBY8iY/gSS48/D10hLgk6a9dIsvTCnBZSKClNPfvv/SE7GlWbk/7aFu69SB1YuX2KKcmvdM2lOYU0D0MRevdtT0vDX+XkiEFA3D4KhYKjqLKh52KVIz0LLtTmToA44jTjrxdp4oqUsLnfyYWyVzYsNzS3tmntrPh4JnoyrNzn/xLMOMEgY5/5s+DlodpgUlLiGnhUS9UWcETaRAvwNkb8redrL0x/ULKeSdn1Q8WNuxVPMQxEIu3q8NKUGBG3jqkrZ9zbUD1wriZZZ6Fq0NtIpI4mecaPlHH2D8w6FnxbK8dopqRnwMlT0aJ1he2Gi2ySuFlhJl3MD7ttcyNed11aywMt/VJghx63AUs2yELa4B66jituV7wkPngdxgQMAyfM/XgFmykXEr5FQ7mhmkFfQ7tP0fnk/TwMDmSAdiJBpdle4LaHwOt+zuWw38NEmr2ysTcNf8Eyr0qcLZARjiihRbREy/O3w3ocJ4MYmkgT0c4bdUDZAHj9RpnHuH7BxHLF+8DoUijnUgGotNwPW/Ve6kfEypokRK6Zpim5Lz2klvrMoAbAMlKph3BuKPL063ccMv4om4jiw//QTB1eGO46V1CS5mJ//NvjNcS9QFdrxM7H2MPSDrZNfTY5oNwtlezjPTKJfXXUWUx8NKecIrdYwbbS95gb/Dodmdf+ixr65dnFmbetZbO19xP8t6fS0bpyY4LL/TttkSbsNw7IkYlZ3onAMNXDE34VzOr1vlYc3VFdpjD5sD+TGNH81wYOulLXVCu4VkpbzCWPhpBSCEug8AHSqFnvHsjng3WBYavpREP87QO9UE8qJoC1Jfzx6m43dOhSotSUJ+AdaFAAFMSd8aLOIapcu5EvxwiRwuyNtsRAxei3ff9k8eEfF0/Qh8/Nrr/byYaZWu9fZdJbApCyuawK/II9eg2Oomv
 qFbT8iZK
 No6IDaFRp2mJbwEPBx39aMKiEpak+lpEFTSnv7LOw9b0K8wjZpkjxixlGB99c+Eni8Qi1BuMEU+pbT4dDJ1EXpqUK5WBjv5el4PxtWXOkZ2xZAdh+LdxrUditAongjfRedWaEqRe99xhPmzmIJTYpq0qhKiosr9Z/f8ij2m64NFKrB4n8Yb0xqItbpZ0Kmf1Ay01APslTSgMLGKKEx9UHDtlga3nI19l/Ii/nlrkSYONOhP4sDow4umE2VshgYruresrMKwwgvA3sboP8fKu+wbabhCQLPer0WRYMNBMJ+AaEnzJbKfvM8LtLkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:40=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> > I believe that managing a pseudo-filesystem (msharefs) and mapping via
> > ioctl during process creation could introduce overhead that impacts
> > app startup latency. Ideally, child apps shouldn't be aware of this
> > sharing or need to manage the pseudo-filesystem on their end.
> All process must be aware of these special semantics.
>
> I'd assume that fork() would simply replicate mshare region into the
> fork'ed child process. So from that point of view, it's "transparent" as
> in "no special mshare() handling required after fork".

Hi David,

That's agood  point. If fork() simply replicates the mshare region, it
does achieve transparency in terms of setup.

I am still concerned about transparency in terms of observability.
Applications and sometimes inspect their own mappings (from
/proc/self/maps) to locate specific code or data regions for various
anti-tamper and obfuscation techniques. [2] If those mappings suddenly
point to an msharefs pseudo-file instead of the expected shared
library backing, it may break user-space assumptions and cause
compatibility issues.

Perhaps we could advertise the shared VMAs in the /proc/*/[s]maps
entries for the processes sharing these areas?

[2] https://lore.kernel.org/all/CAC_TJveMB1_iAUt81D5-+z8gArbVcbfDM=3DdjCZG_=
bRVaCEMRmg@mail.gmail.com/

Thanks,
Kalesh


>
> --
> Cheers,
>
> David

