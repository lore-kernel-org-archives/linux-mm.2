Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744B4606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=vRqDJbAD
Received: by kanga.kvack.org (Postfix)
	id 85E1F6B00EF; Wed,  4 Nov 2026 01:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835FC6B05B1; Wed,  4 Nov 2026 01:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C4F6B05B2; Wed,  4 Nov 2026 01:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46FB46B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:42:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2E7016065C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:42:45 +0000 (UTC)
X-FDA: 85396493490.23.FFC42D3
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8B0E1C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:42:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRqDJbAD;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793774564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
	b=CkfTitU02b/ohMXrwQOCYLACkNhlXAEv5qlwDcOynJru/kqwHlRFoKuoS1Ghiaalpw4Qdw
	e+fMH90d6/FN74eaUx65sKPq3oBHk3Y6NKehbzURSr2WYsgaHN3P3tqPI95mjuAcFfHs77
	c07GrSV77prsHcuNrbGlBHmALWgYFfY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRqDJbAD;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793774564;
	b=SEAtS22AIwkIsH7zovRBV0/qi+VYjfPIAiv/fQa3b/g1hoSKF66rCllPx2kul7GP3PGgkU
	H72gdWtNQswcVwDZsH9MTyPrtuxnre+xefRQrk4QwpNmjJReE9p/n/0QsEJvG/eTwpzTOR
	Cmvw5QwTRh5PcZ3ZzHAIQcQdS1uT02k=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so627796eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 22:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793774563; x=1794379363; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
        b=vRqDJbADR31kRX8WXd88JunWykkVf11iDbSErEW+q3nT1xQ+5h7nl88QPEctB+n16m
         FEtiUyU7bCbpnqaUW7N0OUCD7s47fLLNZXWx014neEsfLoQ7lQBn2kEaD610WWEnGeUO
         nj8Sw9pWfVwMPBiPApIjewjOH+X2Cd1XPkHJwe4czY14enPpuogDQAY3z49L9lTfYeP8
         tgAG6qrGQicQSA+cySL8lWg4n2SqFwkj5Yb9lgmofOiWRn2ySrydRT8WkluBJfjXcPMC
         9m+8hIOvFPp4sytkeBycLGLig816lMGuAsAIuqP983ES7PcKt68IF4/bYpWrjYmhGUql
         TiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793774563; x=1794379363;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CaIA/Sr2kiTxJs6D9LfjF0iFIQjHh5ZBby7zBRLnjyI=;
        b=M2YZOJU6DZnlQl8wlB9hFO8uYzfWLA4FLXL03kWo4oxgPPaOQtMzTt5VQvufBBSt02
         fj9XX4wJRTnyrsdylno67dftBJLFjniXOrijj2za+uNGsNj1ggGNz6kQcrtPFGl9oivd
         BmirqmKMjjvKXZXohvd3PwRLYS55Vb4tBYQ+PnuYGI8VcZZmdmtUhuGh0N05eNNBcbxT
         IfploYs93p79QW0DQ9EzL2DiUAVBrlX+13fdwuiV83aMWEzhRqohNoXD4pY1++90tvvw
         aJJ81w253p/mFHg/nBx6tuKlNVE0/cNYt6j/HAUn5uL0QT141gbwdfnlUBnWsabpv4+n
         Edzg==
X-Forwarded-Encrypted: i=1; AKwUvBxrWDftpNO4mEM3X5V6i42Z/J5OX7JCMEUq16+0kLOkHRLHzAjTx01JyeJkdDwNopNcSM+FlYsyxg==@kvack.org
X-Gm-Message-State: APuU4Z9xxbXHpAOAY0yTx8FzNP6TXIxJG9jrcHhxfGNViX8gkhu8rv8y
	VAEBaP5cnhMsvH7HXwnr2QiWq877dioX3f9XNsqsVll/miQBDrn26y+EPEit8V/HAgA=
X-Gm-Gg: AYBFou2n9xejxhYrUcTuLlSM1qTTT3uBN21lQRrlptEylPOcjZESPQA5wMatl77dhbm
	/FGCqbv0KKG7uTsJb22C97/wiT40uTTTnohjxBrl6sXB2g5+aedANar3fSpZ0Mrrh7Y+nalZZW5
	3K56wnmSlbltmqpldsk1s2KhBzhJLNSbEwL6KWVwBiqvoyREbLzGKrKLVF+6yvteIJCeI/+bAfN
	xip+NnqIGKV9yajZCq4VN7CZ8woSh8lBoFkcUrxCPLs5PhelPH0TaqEwWxEe17vjWhoRU45eJ/L
	/7C1Gm2EXzKZa7IqfHMBRmqCQsKthEtIgE4f7zsh1KCbPdDlCz4ENfcVK5zfiw/aKyiS0Xz9JAE
	JzJHIOfvxGyCeYJlzaLj2oHucnhfzWMxvHT/4Kdloe7lxvgen+zDaHha4M3SIMgR/XT6w7pwPKI
	k0bMMWmutQfUfprxg549m8E4co3VeXaLbNeSnHwZ51dJwT1HLMC/05Uxyc8uxDsgknLp0W+jjH5
	Qyjuxn5HxdqCUt9gXviqoGU6zdqLsx8AI9fVVD9T3uTMftoutO7FYIUU4PfGt3lINkswCeWiMtB
	4a1YPvVOpUPa50xcs84AHenKD+HLNl7XnE/Qlg==
X-Received: by 2002:a05:7022:1711:b0:1ae:59d6:91d7 with SMTP id a92af1059eb24-1ae59d6945fmr17559078c88.40.1793774562347;
        Tue, 03 Nov 2026 22:42:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([61.251.99.240])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c57430sm5905073c88.18.2026.11.03.22.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:42:41 -0800 (PST)
Date: Wed, 4 Nov 2026 01:42:23 -0500
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org, mkoutny@suse.com,
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com,
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave
 controls
Message-ID: <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
 <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org>
 <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8B0E1C0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: jzrkyhw81x6zzu1ni6yy5z3q3subzdfp
X-HE-Tag: 1793774563-560780
X-HE-Meta: U2FsdGVkX18clSwSKx8ZZWxaBsVVzaQP7Xbc9dl+mM6XQ8kreLNQc0owhAdfgQyYA6daFWQP2/PiNWremmLnBdOs+4uaO5OqLHh2Uef82+8dALyowiOyv0H5po+gg4xg3pcfx2WmN7mVxO0ypt9iH3abh51moTrrZ0SGts7nPLOSmmewp/Q38oyzOxoas17pq4vOhYw9lBvXWzJp849Wn2ka+1qrfj7SjQX1tvjc24xaPWqqBGRNWcG9zr5VuR9DjPF/CPK/t8kudFHjjxhZmIiwWqCJr/EO/v340FO4yUDteQWZRrHVGRoxl9PrOVMQHAhn7J3sTv2vpGlsnId+5OZjdu8FY8YzB87B8Mc4YvBnoWZSBP9BSYPxxMnmrgI+4ESoVUr3hssFIz3XEi6EMs5w82rC5UjQ1yqlu6XoC1VnEHtojgnUa6kA40xRqAoXQv2+/kYEOA2zFISBoj5oChGA9BRC5p0A9dmSel1GCcQSdI5H3BOxk+pSyKLtTU/gNkgw9qWi7AvVls1LgUxEtuMQKgazhBW1hm+LSCpNfq+R+Ctyz8GH6X7VnhTDNjcNsPF1CpNgeOjGG4IbvdWPEmoNblmKBLPW69xrG/WRr6U0H/nN34Ef6PZZoC5tfMmjRh+ZisPogOyavcnWStrI90siRQU86BhCEk0XpUTrSFtKl9AxMDswwoy0dWTDUjeTCG7pv4wOim2V6XQI6gXeBc7orp07ssqJTF9cgdts20Q+mNNKhMqYII9JMdCfL3xm/7nHCHSYK+o38nwE7ddM9SGf5lQtGBMqWB4BS1tWI2SVvIJOL2a5ovTSlZDPhejDXNw0jYaG5UR64xn2OCrWmtF6nu4G/xGXSXQXfXuX5pYfMf/RK1+SXXv3j79NNVDoj+0rGGlyy0sCd6GD7RuLn3ECYpsviSTEdojnLLMN18gLkSw5nm4Cbpp6SYpshHVq7mqR59NaHQdNLbQLKRc
 T39pY9AZ
 oOc9qhIm1P6RFatK8wDfQYTVLgOPvlkllKuEqkyjpbMREVxP0GPIg69Ah6LaaKaIl+U/GNUVSSUA7Mxeaxv4VxmKbSWq9Xozod5u6Op8r1HBjk67SRv5a0GXXG5umFDAXiTOwFQKtM4E/oQP8UtOyz1EB7XbSwtM5J2L68N4W5tlKJrYCxr5KfIXAsllx8Xz1JiAKZbVMm9J6qaRkC3yAi0/IKkwc+DthMH4WxFGsbYK0kniROLYjrwbrTvJAHqJ7oGLzVlybvVEXovjifaO8LhMCdJnLjb/T5z6DDuughynk9g7ll56z2x1xsJ+NjnC+vmr4f/jFY8iHCsiFXcZM0ldypOMax5qz4ELSC2uLIGEoSmVYJM9Fwg1XrGDHFM2x3M2snIKsz6TNa6wCM3khQkEZWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:44:46AM +0800, Li Zhe wrote:
> 
> Does that distinction make the cgroup-scoped override acceptable? If not,
> could you suggest a better way to support this kind of administrative
> weight override without adding new mempolicy syscalls?
>

I'm a little confused why cgroup-anything is needed here when you could
just override the weight table / interleave functions.

I don't particularly like the idea of bpf hooks for a single mempolicy
mode as opposed to something more generally useful - and I question
how useful task-mempolicies are in general for tiered memory systems
(they also affect kernel allocation placement, which is not great).

You have many patch proposals recently trying to adjust the mempolicy
components and I think it might be helpful if we could chat a bit
about what big problems you're actually trying to solve.

I get that you want better control over task/task-groups, i think that
can be useful - but I also know that demotion immediately mucks all
this placement logic up (and we can't check vma / task policies at
demotion time) so I question how realisitic the value of these
extensions will be.

~Gregory

