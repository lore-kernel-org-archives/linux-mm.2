Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4DD606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xbtKaUiv
Received: by kanga.kvack.org (Postfix)
	id A48596B05B1; Sat, 21 Nov 2026 07:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9176B05B2; Sat, 21 Nov 2026 07:50:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7B06B05B4; Sat, 21 Nov 2026 07:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4D06B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:50:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0A45A7FE3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:50:47 +0000 (UTC)
X-FDA: 85459110534.26.B07A42B
Received: from mail-pi2-f9.google.com (mail-pi2-f9.google.com [74.125.227.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B45BC0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:50:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xbtKaUiv;
	spf=pass (imf28.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795265446;
	b=yNsAdF9F+WXDX3AcbYLtUgQhump4BrSKdLM/5RhmkfLDTuVPcwMiKiZvXITZgSb/rCVSho
	SVReDXnYyjVzi44giZDxyzKHwF339oUl6xqzfGD5o1p7g1Gr1rDnksMb+rApSo4HNnRzBZ
	7rqPPZkEjrapdODdpiEVz5X8Q5Lb9to=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795265446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=205CdX5PCQW2SykzUQ2r0VNC2kEGRl78KXXpxrNibvQ=;
	b=BVW5YfP2nnCyxLqNVge9NaCcfHLyX8jJfPvzUCiNq8Z7VZIchArbOEHmLhS+2bNpvXAGsO
	LbBHHD5x288ETEG5uvEkv1hPsVBppz1cCNVT2vtngSylzPfpMsMxdW8I1joFIC2MJBsqR/
	K5cJQ4vsMUixxJNCUYSPNaNuFSAB6lA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xbtKaUiv;
	spf=pass (imf28.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pi2-f9.google.com with SMTP id 41be03b00d2f7-cdd9d0d40a4so449774a12.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795265445; x=1795870245; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=205CdX5PCQW2SykzUQ2r0VNC2kEGRl78KXXpxrNibvQ=;
        b=xbtKaUiv4saN3IHAbZV8auunnW0pdRal0CpsiEjG1QAZSSIOUUj/ke7IHXzNQfw+Ur
         dgMOgLi4JaIsS9wCZnuZ1gjrKUTAHAj4Y7PdnCq4UVWMs/+VdTuvyQMMhpyb/88cb/PP
         muwMcQCoKkeuicWNANxNSZ0ysbo+2QDRsbzl0NV2sxfq213JWRPc/rQ5bqTfjvtOGz+o
         7KzhAS1bd77mfEOTzl4BC7WNwEzRduKLYnEAREiIhmpHWqFH2Q90mS/0bTkxRNadECbK
         8TZACd5INBSg82HB2YsUzTOfuEeo7JfBGdXwQeKvkem8tmnmCIyXJpybF5qKlCaY2fBg
         R5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795265445; x=1795870245;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=205CdX5PCQW2SykzUQ2r0VNC2kEGRl78KXXpxrNibvQ=;
        b=o9bDM6s4HTwC2mEQ1CIIc0guZ+VEw7KwlODTXhdmiI4ow00BTMby5MEi33LpIRBlF0
         QK5ezocRUSObstbuXOPWOfZVWuIIqXo4LUIaIni+hekqtA5nhPRI1xKm2UoqpesYrzp7
         V62wyX98mt6kIwVpSU/G1SXtBkRIacpH6L/IaQ3gCxEM1q1uFZD0LAkhKfAf91nx7BeC
         a3cTrLgHrTIy5qVQLL9Y+7HJnpI1K9UCOJepqjNme/IQBZWdfJD4g8knQYGhaZyWiEnp
         MDZITFyngfnC/dkSFqqPv9dVpjJqCnDWJkWR9VkNTZPPfM5SKBxobpPlaoKbp0JTUGmW
         yuSQ==
X-Forwarded-Encrypted: i=1; AL+hErFkXI29RCvmiBrSI8qPex66G2ADS94Nd+GbQorQuMmou5DC44ONwXlFppHU8fYAiOy68xQviD2JjQ==@kvack.org
X-Gm-Message-State: APuU4Z87wgqfiGBCSIYOCPQyf6zqpZUXk1UL0oZLlDV6yeI/8cHlf+lp
	FVefWUzD84ZV9qvd0IC0AMoTZIW/5l9P/aAKU97rbKuwiuAV9XYSdMeG
X-Gm-Gg: AZFdTZcQ+16YNXeru+aXetasUmCueGz4X37oaQnCMoZLxAUNgnsTp/fYLjxrR1kp4Dz
	r2UuKXkCZarivREvHf+geNdVMoLD3D9vSfpVrtQggJYUM47biTa9WWpMGnr++U/0z9Sd8FYTYZi
	Q/9kw6y+6mizQrz/CJM9PuEKvtnftn6mPf8OY3XChvMqFDxwgTe2jcOmWUpQwBg0p4n6PsIpMcE
	mVv9bMV1LRNenE5pqVMLVjEF85PiC6HAwHDTpC/DBajUygTnfcStfjq5RBtxMhM437/3aoVc+xf
	8h0THuZxTHeTuOBY5wOjMdKgn6Pg6p5huT6/ph1fYaB9t8DEYdTAQsromRrRATcZPH+VgjpUVIc
	xe3ckWN414BdnGkAAg3xJLNI/buHJI3Yf9h7ayfB8SyavMGSLx47vA6mDsziYklTz0vbiNuedJU
	cHI4WURIgO3wEzZbtr+EszutzBEhfrlM5bqFVotS8wM8l0h40a5AJgpEp8ouxWUkV3E7680Hs20
	R5Hd5KhzBYm3ifdL21UuKCgUdnqfQhRQUnSGI7MPpX91YZnL7n5r8FayQ5rkN1xDjFutYGkaCJ4
	R2KiFicROgFkbL6RuuUU3Nbxm/uyrOqwwyGp0Qck4LMah2Zn3bfe8GKQ9bJ34SI0cz9GSYTXFqw
	E62o2FQYlssT5QHGeFeCBnv35lWxvxjd2VQ==
X-Received: by 2002:a05:6a00:4c8f:b0:8a0:70ff:ab27 with SMTP id d2e1a72fcca58-8c87c09e5bdmr5660349b3a.28.1795265444677;
        Sat, 21 Nov 2026 04:50:44 -0800 (PST)
Received: from localhost ([50.7.253.42])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c272sm2888869b3a.19.2026.11.21.04.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 04:50:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 2/4] mm/damon/reclaim: set memory PSI 0.05% as
 default quota goal
From: Aveline Noir <jm5905938@gmail.com>
Date: Sat, 21 Nov 2026 23:39:16 +1100
Message-Id: <179526475633.4.14859465649138957731.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, arijit.desaii@crusoe.ai, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 Randy Dunlap <rdunlap@infradead.org>, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261120060741.92121-3-sj@kernel.org>
References: <20261120060741.92121-1-sj@kernel.org>
 <20261120060741.92121-3-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Queue-Id: 1B45BC0003
X-Stat-Signature: fq8fwiz69gq6nx8orp1iuak31c6rqfu1
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795265445-150638
X-HE-Meta: U2FsdGVkX18ikP+xGuGCyWZ2esINa119SpplLGha1JnNaPjaFbjrEj+4tpcmAs1oSMiRKi4M4WuFdaMBidC+sovvj+9jDiYKUOlNbRLmtBnx4cw3og6RbcPj4XsNHELzUZkQEq+WAphnfBB2QvdTGnWACTk1DNO9XU30fW1OMspcIWIZFU3ObillnLq9vgOQs1Cd/BWdjAFOM2ToDuR9s8bPczWIAfgHTKkT5XtY9LvvAuvlMYcUHbgImNGyJe8VuAUkCa4M7/ZIUP+lsylGqNWL9qVQ03d/TocaCabySn+lAawCpVZY1KWJjJHfczqhxKXlJJXof/uD0F1UlVz6ze+TfafFdHaD8XccIQfe4fwxJVT0h2Ek6Kv3dtf6/JQ6GVpcZIagyxeTfKdx8ZmtkU+NziODP6xpY/o3fvf3pIzRB4H27v7odrkk+gILzROkrRO07ZUOGzYQN04COyl4QzEuq7309AgAkkaIWejSsR1rHAIM7kI1qQWt1bdTdNAInGY/eKBDGDuN6MOlKcAcXhbCWjryxc3WRdwmLLGomYgXcqOV2P7zTXT0cuLJwfiDPdru44V2kej4zq3bX5GKgs+JuNiyFLMVBW8xzFKaHlboBC3ga3V6ORS8o9WtaHN9bDYSB7Aw6q96ngXSFHJ24cWkcZLZkXVjfU7sns9jXawukw8w+50RXWOqb1/F8OYjPO+Q/4Ax/0cBOTBjhDs8gk6PJGkJ/Z+Vkx4bnHRLe/cMkqQn9j441lbrYzuV5UZAs3LxIzlgcgqgfOHMlNqHGGW5mBexAQTT/rzDFcQHXk83qoo9RbruDP4LjdXEZU39sde/Bi2JYy4ZaMjB5eFv3oznQFeO1w7S/GMbBrgRDToL9hmiNfkouY5IKu1PFv9zvzb+vb8SD/wMhv1MHeLqTEKMPvltEzmY4TVfj4Y1q+mcxH/rRb3IsPli07b3ED322v0GxMWMkdsuUY2HXNa
 2SGB9LtQ
 6umiHMBB99YgWc14uvj2NSbb4UOFPzj61E/jMY6AKXptgcyxG7rZZmpAli1h0vAZsxaC/8jx2rqqwnmONYjvk/22uXH5YCGyKucjJXAxZ6q+UWNtFtzW9x67B3IdXG1PYgrhotXh9Ob5qouVM5v4bXpCk3rqii1o1A5mCIVnVjzJvgPYS2qQDA8vARoPXAL/Kp5umT+tYLlmeBi97j5x7chC6anDBEUisKd4x1jGbhbkwHsC8ALnvb+DeVYEuauQvi+tTDFmrXThEJbYs0UZ/RLZAeAbDG3dLRWA1WUIz6FaJNoVjLj7ITOymCcbKv/s7wRgiTZGpr/AwHR/rwTmmMrOo34QQyFtfIbwUdjI0j3qA3ol15VVPdIFmj3OrhmTbjxSlJryHlVGerDD1aqpczOZtwvIEg4IlM/sSVQQfV3QSga5kGU5x0QaJBCQuRuTXt2DIaCE8vtvvxM/9fmWWo+jQCKYz5n2s0VylFw6/JVDw/VybpqbrVUaHjLDmSgC1sslZUC3a0PnFkezv2QuALhtccHPms4qd9F03j6/hIqie+KqNoMtyVBlBjPy0GsgJKe6OSxVDDZhZvLpeO2RjhwxeuorHtXq4ehVQVTYI35x9nPR5HocvRdE64kQSiua8ejvgq+jlKUf23e3sqSUxuTL8qNRRQqhCl/ak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Thu, 19 Nov 2026 22:07:36 -0800 SJ Park wrote:

> Set 0.5 milliseconds per second
> (0.5%) as the default auto-tuning target memory pressure ratio.

0.5 ms per second comes out to 0.05%.

> +static unsigned long quota_mem_pressure_us __read_mostly = 500;

With a fixed 500 us target, maybe a longer aggregation interval also
lengthen the PSI measurement window. For example, if the quota ends up
being reset every 2 s, should 1000 us of stalls still be compared 
against 500 us? If so, the tuner would drop the effective quota
to 1 byte, skipping pageout for the next quota window.

Thanks,
Aveline Noir

