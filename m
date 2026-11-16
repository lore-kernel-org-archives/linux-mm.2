Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827A1606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=O48mHJRR
Received: by kanga.kvack.org (Postfix)
	id A1A116B05B3; Mon, 16 Nov 2026 11:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2336B05B4; Mon, 16 Nov 2026 11:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907BC6B05B5; Mon, 16 Nov 2026 11:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDBF6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D052140177
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:09:47 +0000 (UTC)
X-FDA: 85441468014.12.6B8E67D
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id E348DC0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:09:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O48mHJRR;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794845386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/mwZYYaBoMRcXn1MKOiGJvQffr+SWgcNW4Z7wvG98U=;
	b=7cloG7lPM0TgDQUtsmqwkxpL3ydNYHXciq9E8JjT/ZdvQSJS5MtB7KhmpmB9fl3GZpnz5H
	ZALV0T7EUNkylgdcLTFs0vCfQ9gZd+X8ikAPffeDOpw0aIW22zxHUfNAhkJ5nTziAIALEs
	MeKEsdzMZMlfkgUTHH6jMc4ANEMLs7A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O48mHJRR;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794845386;
	b=8kGa1ri5UOvnvgFc+XCl34OLH7RRHhbGBt0XvLFcmRVoVKONZtCciLCsiX2auh88v/y7F8
	LiSoAt/m/oDGJKa3CmUdEoX5JpKfax7mLNFMc6B877pqEpDPgE1A4uwj9KGM/L+3AB0qRW
	3LniFhKbSnC/QkBKRDirEPH6X4qfI5E=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91f0b9f0b1cso47327906d6.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794845385; x=1795450185; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O/mwZYYaBoMRcXn1MKOiGJvQffr+SWgcNW4Z7wvG98U=;
        b=O48mHJRR6Kc6OKq0YhaVjgituFIlwYg2qLfuaKIZgja7LzQBpVHNKjtG9bJei14IIQ
         gNmTXx8KyNEOXtvESCBc7IAAHjR3WQ8XXpKZdENwa+F7VDKsquUcnkrbzbQDumVnlqPw
         oztwDBfshkhFuxB+WX8vo9d02/CYPqfwUYawusuf3Y6x2IrNgw+wogFtnyMKrrUuSOeM
         FIe5w3IR0M4xpJrIKLmrYv1+zJQa3LamULaLunhfJxH65JMmVwnmQIsJkv9vjzzEN5W1
         2QFxWdn51xAi5v+/3A3fzp1z+0X5gyQl2CfHDC5gOo6Vul2iAdwdc98Tc7wNY5fmkyS0
         oRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794845385; x=1795450185;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/mwZYYaBoMRcXn1MKOiGJvQffr+SWgcNW4Z7wvG98U=;
        b=MBKSroGs+/K58OXi8QCPRaUmHrJJEkIh8/KjJfG4KDJ5/cmsOTet5en7LUiuCa0VOL
         R7oko/WeKy19qzi0OfYnoKu2Vc30f6WgPsw0/BT7bwpWTWegCHWIF/wictp5FKesCZ85
         KiBGcTxvJJa96aFqR3zl2N2SlMda9zHUUpjzdReecSbTwA1I32fCYrvf8wIjFF0xDv4l
         7lN22FOLrD2S9WkDEuR4PJD1wLax+3am6wDlBaiCLhXNez33kNDPwftNxjQiGJMcWrvf
         EeABXvSSKMlRW8ik4YT+722EMb4imWoNnLJfwEQQpzP/dwGGaF4PKZTtP2tnVz8llU1E
         D+Ew==
X-Forwarded-Encrypted: i=1; AL+hErEyp8hG48m7qVEBZ73lsqIl+oe1Hl/IOY7dDC4s6wOrw1gF+1XdU8O1LDpreqfDqsGRIqia9c9BAw==@kvack.org
X-Gm-Message-State: APuU4Z/gmoCwEIt44hYN31DgAD5+SNFD8gTxDIsphB2FS91zJ5p+d5En
	Dq2qNS7KCljKb7bLAGoUJULj/SyHSS0gu+Y3QvBcBjdqPYkQC2BHEP1YU/Lfo49WQSo=
X-Gm-Gg: AZFdTZepbBgSSh+PCT5N5D9cIgeBj68Ee1vgylLmNgXuu0EZY0FXX06ZH0hrF1Tm2sQ
	SdmBPjUNl6dqgiVd4zCv/A7WD5wRCb1ekk9sg45p+5NhzHScnIsirrzTrvIbjQqZV/U+COMXoBy
	delrUsjTovcLiA6/NfQWxEvaOktbUCt8Q3JG5lDqBbGnNRx+k6hoBI8m7icRw9lJAEpx6xfe7hq
	hOViBte6Tls0snC/X03Sl9+KGGrqGGi88acj+snX11TpeaXfQg2GEkwuEVpj9/qjWU8HMBDFdXd
	tqkmzMnYT+HoBCgSPchbCOkk4LndcImj52qAUwvfRJOVK9MsWn9hSFY+6XIxn2Lr9hAKgDZz4rM
	fxYBUKVJhaGvGIR4kSI2Qu8VM21YPNXTetRdjrm1hOq3O41uP/PfV5JfihuhLju9/ZP1s5MkRyf
	GB2aknItc957pT/20cKjp+WTVoKeQTz3KAQnTBE9IuRWmwXjdXklDbq/Nl27axxyMNFwok4V2l3
	71oQ4LYrmjqNPq2nKbExmZbefxNTISCIuarIDaztJ6KWO0OvUJUBmbA2iehpPCGp2fL5jm/Jg9v
	R32CSpCdb2Ayqv3NKsUD8YWaXdGjMYqAKEW3oA1NDX4VpQVK6pE7M8tjY2bMAI6JdBH7aZegVK7
	qMX/tLwI=
X-Received: by 2002:ad4:4484:0:b0:91e:9ab9:bf37 with SMTP id 6a1803df08f44-91f2415f57amr132104666d6.14.1794845384821;
        Mon, 16 Nov 2026 08:09:44 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d6193esm88683016d6.19.2026.11.16.08.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:09:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org, 
 akpm@linux-foundation.org, kas@kernel.org, dave.hansen@linux.intel.com, 
 bp@alien8.de, rppt@kernel.org, stable@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
In-Reply-To: <avpAQyLCpJPKSpT-@nvdebian.thelocal>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <179464112539.482102.8723246686117488051.b4-reply@b4>
 <2fc85df3-cffc-4786-a7a8-0f0a6347fd59@kernel.org>
 <avpAQyLCpJPKSpT-@nvdebian.thelocal>
Date: Mon, 16 Nov 2026 11:09:42 -0500
Message-Id: <179484538296.482102.4367398493158269026.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E348DC0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cr6xruthn8um9xcto5pkakaf6fnzbotj
X-HE-Tag: 1794845385-973676
X-HE-Meta: U2FsdGVkX18odWZmzyLEZ5Dmsh11OoWpEp6N1WIP7Yl+HULmWr87xRG02psyPPRaYY2BqajajZsApvH/Bh+VkW1HcKxScFmzdUnA3Yd0wRzwPxu1DNBCFRnSc+wW8GH0zmQF4tVY4JA/HF8GhsaHzmuSMXrXgFIAEjf4UTSBhmt17yPszCH8N6Pi2MWJxFfBgz/eWJz+UOAZXl9bw8S8iVyeKYLZTbIVc35HquX6xV/+U+5Uy0pWr7tsvMJ/QmPa4Cv92ri4ITE5515M5gen2uyKNNdNOIOulORWE1YUtvS7edDzuM8I/r/zRe5/EBKj/q6Qwa1oinPFByTc42o4l0b8M5HEdKRwKSuiruR/b+dJi1BGqEGG6pJa+JTAOuHdn6RDKOvvILIXR9pDg90/Z1RYeHZjvdBvh5aU1GlVwPB2yIOpBQjIAyhXaAO+TGnslJ2UeuCe58orOYQ7cpiGvrkyol7O2wysshcmjq7Yufwf78TuSDINhMdWbvYV+rfDkXGh3eYU1rbVwQtpq3bV7KlB8Y9+Kc907olWOa1YeveMPXJbPvIOUfi8aSsaBzW+Goizk6Hus9DvNeToaKNvDzNrcFSIgy3hmbbKwiqj1G/Wcy110y7obJjDXMraep44zZBGeVkBWtLPzMB5mXabnwtxJpvqqAzj4uW8UUuuddpyNCWdRc6xH+T+UbApHIO2S906LtHlLp0XXMRgWfonCKI4qc0b/pL6vaUqUioA25OaZalfnkyuMG8Q5oLUiAmC39fNhxDPZQ9Uxc0HXxNZiaTzDJ29ksDpq6NWM68Qu+WKNyqxzdWnpbKF1YClGGb1qiDxIL5yRC7ZHa4J2fit9oiEyxRrm+bgPVyYJ3h+2kdhyvW0JhxZejvwkup/8NRMF4lj8tdlrZ2efORZL3aIyUNg0eKuI79EOeLgo35P5usQV6bwT3Q5QuOOhzril2p2htFfsRl/18Dedi8mTwO
 Abz/kTZV
 OwvlYDlScAkYQbNR+Au+eLNft2zEF7dQC3dKHhhtL4wPWr3JL+FBE4aXsrNSatqPcdNLbZ/knyFh93uoj0bl+/+33Larrn7HKjoQtkL0mVfwFESc3Fj6Auof/qlHtAQxHyymc1c1UCJd9mFk7Ti8ELwosiaN3cdZJGyO+8MqCzkAr9XfATq07oq78di4c+3Zs8Ec09lSyrpDDEai4aq06ZFbYgMwiQ9RLuL3YeR2QTmyRgYd3KovxRG5OCNvGLVdj0SL/hm7PnEGC+GavFFwHncoZWQE884oI5dTF+Ib8UJebHCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 10:48 +1100, Alistair Popple wrote:
> On 2026-11-14 at 22:11 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> > It's writable by the hardware, that's what matters to core-mm, for example, when
> > it comes to things like fork(), mproetect() etc.
> 
> Except they're not universally writable by HW, after all _PAGE_RW = 0. So
> pte_write() is documented to return if it is logically writable, which of course
> is what hmm_range_fault() also needs for certain values of "logic" :-)
> 
> So it's easy to see how this is confusing and got missed. Anyway this fix looks
> good:
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> 

Thank's Alistair!

-- 
~Gregory


